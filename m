Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1037FED9EC
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E306B009B; Tue, 17 Mar 2026 12:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5406B009D; Tue, 17 Mar 2026 12:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4EC6B009E; Tue, 17 Mar 2026 12:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F17386B009B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:19:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99D5D13A3DC
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:19:17 +0000 (UTC)
X-FDA: 84556064754.09.30E287A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19F7DC000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:19:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=onANVyMs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nlxj7QJh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=onANVyMs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nlxj7QJh;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773764355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRuj8oliuRB8vfh4ORqIsVuipaAv9fM7y492n9A5HMI=;
	b=DmanIM72EP6g+YSAyH/omkUHC2TC7CnQ8jYpp68EvYFQnDUO8Y7YqFmPotJSvtcGediCxj
	dOn4gjTSUntg1M74ArlHOflv0eGV7btMM2PHD9npev+txOMyDPMS6NfWd6cKIppHZ/iSIi
	ys9zn38YxZTw4kjKbsW2SuRSDae5XQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773764355; a=rsa-sha256;
	cv=none;
	b=lA9PHE5T1Qsod9Jy42o6rFcRB3rylosd0VarsvlHpwysNX9MiVSTJl+2k3bfEri21y6bVG
	xd5hj85ER4JxeoJoIFCrCeBL0e+GRnkdSoU7DWxkpexI9fVN+azBn6kyDu5nKfhDgujaie
	Zm9eAqgnNmilKa3H5hRGe8/EdcQgq1E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=onANVyMs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nlxj7QJh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=onANVyMs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nlxj7QJh;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6CB7E4D300;
	Tue, 17 Mar 2026 16:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773764353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRuj8oliuRB8vfh4ORqIsVuipaAv9fM7y492n9A5HMI=;
	b=onANVyMsJfK7ABC1vv+qswwa87L39qBQ4jINzeVewhK1AxkNO/aRCI0CPap79lhYmdLKSa
	fBkVn6baSYdEsoEOnc7lpQdzmJvqcZGY0CWer1mbj7P/l64FvIaNGGGWY7kOzAZ444NUhK
	22BYKQH0txhm6fSYB5w5cnbI31YuNaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773764353;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRuj8oliuRB8vfh4ORqIsVuipaAv9fM7y492n9A5HMI=;
	b=nlxj7QJh47csd9CoxFDXIr77mCwdKUKjxJu3FlJGc8Egx7/Y9EgsYBwk1XVPUJUSw2Vomz
	msNdQCjpVK2rTuCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773764353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRuj8oliuRB8vfh4ORqIsVuipaAv9fM7y492n9A5HMI=;
	b=onANVyMsJfK7ABC1vv+qswwa87L39qBQ4jINzeVewhK1AxkNO/aRCI0CPap79lhYmdLKSa
	fBkVn6baSYdEsoEOnc7lpQdzmJvqcZGY0CWer1mbj7P/l64FvIaNGGGWY7kOzAZ444NUhK
	22BYKQH0txhm6fSYB5w5cnbI31YuNaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773764353;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRuj8oliuRB8vfh4ORqIsVuipaAv9fM7y492n9A5HMI=;
	b=nlxj7QJh47csd9CoxFDXIr77mCwdKUKjxJu3FlJGc8Egx7/Y9EgsYBwk1XVPUJUSw2Vomz
	msNdQCjpVK2rTuCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD75C4273B;
	Tue, 17 Mar 2026 16:19:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8njFLgB/uWkddQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 17 Mar 2026 16:19:12 +0000
Date: Tue, 17 Mar 2026 16:19:11 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Benjamin Eikel <debian@eikel.org>
Cc: linux-mm@kvack.org, rcu@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [BUG] RCU stall in unmap_page_range during exit_mmap (6.19
 regression)
Message-ID: <6ccygsneky6la4unzj2qd6m6o3ty3ek6xwidznzgrpdvc7tfel@qeoj7rramrmu>
References: <6261958.lOV4Wx5bFT@thinkpad-benjamin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6261958.lOV4Wx5bFT@thinkpad-benjamin>
X-Rspam-User: 
X-Stat-Signature: 394dddhuqj9ecfgy4hnn3tjxgncr4uds
X-Rspamd-Queue-Id: 19F7DC000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773764354-290261
X-HE-Meta: U2FsdGVkX1/Q78Oq7XTlNQHRs6teJEqM6TQehUknYcbb26HvgmtwevzPWjTCnXq8Q93MgetjTQiMatjnDPC87GBsvtPizQr0JVeOrkxM9owgpXx+qkQyKrNQbDSOKO3l//tCZT7AOmZRZhu8SY4K0Muczt8UfQsRo/gNgvEE4KfYCBeFpzLG/IaGp0H4x+w6jP1Cq/YJNsmxW/MtswGsDSIE9qGNQeWWVg0p2wp9iaw/UZGyTRTktOY1BcGVB3eJDohLBrxJEn0qp0Zn0DJzi0OIRVQ4rqdIJIkODvebymg2DYvOEgQmkFmEoH6GPa/U6WoHxqxrm/KL1AxqUg3JjvNkNjnDJyhZlc1W/6xfIYW8p0Gu0O05H8ydMYFlualfv+E/RGxCPIP1a9Vr02lNLcwajnZrbNdnbLpb7EMgMSa+DQ6z3lt62TxyTLkhknkN90n1qpvK6J3ADWh4d39xKX4p/1n4TI697ZZkBL+vSr84l7SVrrM/2FB2T7l2P6dQpOGisu+p0HBPt6eTfcRe3s+lXVlmYJmH/+rKT96g3VA/gRuLzOeVi34BMXk0CxoUlLXD3cWvJQvPbPgkavLgZRihgCIEvHyO6QXHFk7draxThhj4xF0BBsgvMH8U92jj/pY7PM/2xONd8hEj7khoyuB9Uo8qInhlHrEdXLAvSZOvJFZJbT9rtzy178K8Ho8n7z5pIHQEyEZPzQs3LFZn6qDMK88FQX7hEUtbDrmG9sfkoZZXSzbkL2nf/Qy8+czkmkOoMz8JGPp/y7ga8+Fy5nC2vkv4UcSByvXN5D2K9BHW+E0otm7Q5OVlQrMeMMDG1ZSiAwvRu3paH3zIGzmCGlSztkcpvBQFgOlRvwdI7bDWFWuHg4oDS2bT2nTUwFk2Qu8jbF03uoSMEILDcRb3o+MKniOXDqeSP5N7BfAvEvtw25zPOVfCfMp1WVX3oDOnQD+iZuccguYWWmZ3+Z1
 lE02kPdt
 OtDiniPCzjSwCPpwcq7URwmL2EmUexRcxwTJFYBCXUUN7kdG6amL4git12oL33vzM42nQ5p+jKETMUntDXyYtWchqgSn14cEfkJ9nIR2uSrXjo6qdqKgtw1OcPzpCoD1gxvZB/DAFiApiRmAfxXOI4xRxWv9g7aWqXBCpYGeKxIF/Psd8tUILv4/zYnixDKQBls1VoTr5kDYhjtblpaXTMncjTLy+Oqov0k3WDetWRaaJhNEoz2XvZpYfQgtepxS9CAIA4yMA0SUcdQTnoWuQySdSZor/vvJXCtEOYcxZ5ADRIib6RpFuloWN5szxq8oZX5xmEwCO0/ma/XOuw8wLNkgiUAKBx1Ms2vvQ1Wzs/X8sVKlvdMkC3wRvXjdfxaOJI+4oVd0KbqSlaEyCfkk1GTy/KRS/hpsPGZ96Vx8N+1aYuTUzHCeXS/1TAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc a bunch of relevant people
On Mon, Mar 16, 2026 at 09:18:37AM +0100, Benjamin Eikel wrote:
> Dear Linux kernel developers,
> 
> I have reported this issue as Debian bug #1130138 [1], which has been marked 
> “upstream”. I am therefore also reaching out here to make you aware of it. 
> Please let me know if you need additional information.
> 
> After upgrading from linux-image-6.18.15+deb14-amd64, I see this error several 
> times and the system shortly freezes. It seems related to Zoom crashing first, 
> but the freezes were not noticable with older Linux kernels.

Do you have a simpler repro you can share?

> Currently booted into 6.18.15+deb14-amd64 which does not exhibit this issue. 
> The stalls occurred when running 6.19.6+deb14-amd64. More information about my 
> system can be found in the Debian bug report.
>

Can you attach the debian kernel config? Is it possible something relevant
changed since 6.18?
 
> Mär 09 09:13:48 thinkpad-benjamin kernel: rcu: INFO: rcu_preempt detected 
> stalls on CPUs/tasks:
> Mär 09 09:13:48 thinkpad-benjamin kernel: rcu:         Tasks blocked on 
> level-0 rcu_node (CPUs 0-15): P10008/1:b..l
> Mär 09 09:13:48 thinkpad-benjamin kernel: rcu:         (detected by 5, t=5252 
> jiffies, g=177537, q=28067 ncpus=16)
> Mär 09 09:13:48 thinkpad-benjamin kernel: task:zoom            state:R  
> running task     stack:0     pid:10008 tgid:10008 ppid:2089   
> task_flags:0x40040c flags:0x00080802
> Mär 09 09:13:48 thinkpad-benjamin kernel: Call Trace:
> Mär 09 09:13:48 thinkpad-benjamin kernel:  <TASK>
> Mär 09 09:13:48 thinkpad-benjamin kernel:  __schedule+0x48a/0xfc0
> Mär 09 09:13:48 thinkpad-benjamin kernel:  preempt_schedule+0x32/0x50
> Mär 09 09:13:48 thinkpad-benjamin kernel:  preempt_schedule_thunk+0x16/0x30
> Mär 09 09:13:48 thinkpad-benjamin kernel:  _raw_spin_unlock+0x22/0x30
> Mär 09 09:13:48 thinkpad-benjamin kernel:  unmap_page_range+0xbcb/0x1700

Hmm. We have a bunch of cond_resched() sprayed around this code. This _should_
work. I don't see anything particularly interesting that changed between
6.18 and 6.19.

> Mär 09 09:13:48 thinkpad-benjamin kernel:  unmap_vmas+0xa1/0x180
> Mär 09 09:13:48 thinkpad-benjamin kernel:  exit_mmap+0xe1/0x3b0
> Mär 09 09:13:48 thinkpad-benjamin kernel:  __mmput+0x41/0x150
> Mär 09 09:13:48 thinkpad-benjamin kernel:  do_exit+0x251/0xa70
> Mär 09 09:13:48 thinkpad-benjamin kernel:  do_group_exit+0x2d/0xc0
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:13:48 thinkpad-benjamin kernel:  get_signal+0x8a4/0x920
> Mär 09 09:13:48 thinkpad-benjamin kernel:  
> arch_do_signal_or_restart+0x40/0x250
> Mär 09 09:13:48 thinkpad-benjamin kernel:  exit_to_user_mode_loop+0x8e/0x480
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? __x64_sys_sched_setaffinity+0x6a/
> 0xb0
> Mär 09 09:13:48 thinkpad-benjamin kernel:  do_syscall_64+0x20b/0x600
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? ksys_read+0xcd/0xf0
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? do_syscall_64+0xbe/0x600
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? do_syscall_64+0xbe/0x600
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? __x64_sys_close+0x3d/0x80
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? do_syscall_64+0xbe/0x600
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:13:48 thinkpad-benjamin kernel:  ? exc_page_fault+0x7e/0x1a0
> Mär 09 09:13:48 thinkpad-benjamin kernel:  
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
> Mär 09 09:13:48 thinkpad-benjamin kernel: RIP: 0033:0x7f2876359e2d
> Mär 09 09:13:48 thinkpad-benjamin kernel: RSP: 002b:00007ffc91243ad8 EFLAGS: 
> 00000246 ORIG_RAX: 00000000000000cb
> Mär 09 09:13:48 thinkpad-benjamin kernel: RAX: 0000000000000000 RBX: 
> 00007f2875207700 RCX: 00007f2876359e2d
> Mär 09 09:13:48 thinkpad-benjamin kernel: RDX: 00007ffc91243ae0 RSI: 
> 0000000000000080 RDI: 0000000000002718
> Mär 09 09:13:48 thinkpad-benjamin kernel: RBP: 0000000000000020 R08: 
> 0000000000000001 R09: 00007f2875206de8
> Mär 09 09:13:48 thinkpad-benjamin kernel: R10: 0000000000000000 R11: 
> 0000000000000246 R12: 00007ffc91243ae0
> Mär 09 09:13:48 thinkpad-benjamin kernel: R13: 00007ffc91243c80 R14: 
> 0000000000000000 R15: 0000000000000020
> Mär 09 09:13:48 thinkpad-benjamin kernel:  </TASK>
> Mär 09 09:13:48 thinkpad-benjamin kernel: rcu: INFO: rcu_preempt detected 
> expedited stalls on CPUs/tasks: { P10008 } 5361 jiffies s: 1609 root: 0x0/T
> Mär 09 09:13:48 thinkpad-benjamin kernel: rcu: blocking rcu_node structures 
> (internal RCU debug):
> 
> Another one:
> 
> Mär 09 09:14:51 thinkpad-benjamin kernel: rcu: INFO: rcu_preempt detected 
> stalls on CPUs/tasks:
> Mär 09 09:14:51 thinkpad-benjamin kernel: rcu:         Tasks blocked on 
> level-0 rcu_node (CPUs 0-15): P10008/1:b..l
> Mär 09 09:14:51 thinkpad-benjamin kernel: rcu:         (detected by 5, t=21007 
> jiffies, g=177537, q=87903 ncpus=16)
> Mär 09 09:14:51 thinkpad-benjamin kernel: task:zoom            state:R  
> running task     stack:0     pid:10008 tgid:10008 ppid:2089   
> task_flags:0x40040c flags:0x00080802
> Mär 09 09:14:51 thinkpad-benjamin kernel: Call Trace:
> Mär 09 09:14:51 thinkpad-benjamin kernel:  <TASK>
> Mär 09 09:14:51 thinkpad-benjamin kernel:  __schedule+0x48a/0xfc0
> Mär 09 09:14:51 thinkpad-benjamin kernel:  preempt_schedule+0x32/0x50
> Mär 09 09:14:51 thinkpad-benjamin kernel:  preempt_schedule_thunk+0x16/0x30
> Mär 09 09:14:51 thinkpad-benjamin kernel:  _raw_spin_unlock+0x22/0x30
> Mär 09 09:14:51 thinkpad-benjamin kernel:  unmap_page_range+0xbcb/0x1700
> Mär 09 09:14:51 thinkpad-benjamin kernel:  unmap_vmas+0xa1/0x180
> Mär 09 09:14:51 thinkpad-benjamin kernel:  exit_mmap+0xe1/0x3b0
> Mär 09 09:14:51 thinkpad-benjamin kernel:  __mmput+0x41/0x150
> Mär 09 09:14:51 thinkpad-benjamin kernel:  do_exit+0x251/0xa70
> Mär 09 09:14:51 thinkpad-benjamin kernel:  do_group_exit+0x2d/0xc0
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:14:51 thinkpad-benjamin kernel:  get_signal+0x8a4/0x920
> Mär 09 09:14:51 thinkpad-benjamin kernel:  
> arch_do_signal_or_restart+0x40/0x250
> Mär 09 09:14:51 thinkpad-benjamin kernel:  exit_to_user_mode_loop+0x8e/0x480
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? __x64_sys_sched_setaffinity+0x6a/
> 0xb0
> Mär 09 09:14:51 thinkpad-benjamin kernel:  do_syscall_64+0x20b/0x600
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? ksys_read+0xcd/0xf0
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? do_syscall_64+0xbe/0x600
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? do_syscall_64+0xbe/0x600
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? __x64_sys_close+0x3d/0x80
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? do_syscall_64+0xbe/0x600
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? 
> srso_alias_return_thunk+0x5/0xfbef5
> Mär 09 09:14:51 thinkpad-benjamin kernel:  ? exc_page_fault+0x7e/0x1a0
> Mär 09 09:14:51 thinkpad-benjamin kernel:  
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
> Mär 09 09:14:51 thinkpad-benjamin kernel: RIP: 0033:0x7f2876359e2d
> Mär 09 09:14:51 thinkpad-benjamin kernel: RSP: 002b:00007ffc91243ad8 EFLAGS: 
> 00000246 ORIG_RAX: 00000000000000cb
> Mär 09 09:14:51 thinkpad-benjamin kernel: RAX: 0000000000000000 RBX: 
> 00007f2875207700 RCX: 00007f2876359e2d
> Mär 09 09:14:51 thinkpad-benjamin kernel: RDX: 00007ffc91243ae0 RSI: 
> 0000000000000080 RDI: 0000000000002718
> Mär 09 09:14:51 thinkpad-benjamin kernel: RBP: 0000000000000020 R08: 
> 0000000000000001 R09: 00007f2875206de8
> Mär 09 09:14:51 thinkpad-benjamin kernel: R10: 0000000000000000 R11: 
> 0000000000000246 R12: 00007ffc91243ae0
> Mär 09 09:14:51 thinkpad-benjamin kernel: R13: 00007ffc91243c80 R14: 
> 0000000000000000 R15: 0000000000000020
> Mär 09 09:14:51 thinkpad-benjamin kernel:  </TASK>
> Mär 09 09:14:52 thinkpad-benjamin kernel: rcu: INFO: rcu_preempt detected 
> expedited stalls on CPUs/tasks: { P10008 } 21233 jiffies s: 1609 root: 0x0/T
> Mär 09 09:14:52 thinkpad-benjamin kernel: rcu: blocking rcu_node structures 
> (internal RCU debug):
> 
> Note the stall duration escalating from t=5252 jiffies (~5s) to t=21007 jiffies 
> (~21s), with the same grace period (g=177537), indicating the unmap_page_range 
> operation blocked for over a minute.
> 
> Kind regards
> Benjamin
> 
> [1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1130138
> 
> 
> 

-- 
Pedro

