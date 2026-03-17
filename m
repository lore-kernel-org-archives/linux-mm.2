Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1490F3383D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C356B009E; Tue, 17 Mar 2026 10:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1339A6B009F; Tue, 17 Mar 2026 10:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070846B00A0; Tue, 17 Mar 2026 10:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E854F6B009E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:46:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A42D61B7154
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:46:12 +0000 (UTC)
X-FDA: 84555830184.11.A3F44C3
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [194.59.206.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id E1E681A0018
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:46:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=key2 header.b=iZQaMoUL;
	spf=pass (imf19.hostedemail.com: domain of regressions@leemhuis.info designates 194.59.206.189 as permitted sender) smtp.mailfrom=regressions@leemhuis.info;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773758770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GL2gx7ss1pzX264rddGdC76Cpil2U2XTalVR+xU99k=;
	b=FNPWgQRA55nlKcP7eojYCeIcnJW1rAM1gCIuz204XevXYuj8iuCLAzaiBJsHnlpIy75avL
	Hey/OFnKfUv22XLZ6AM7THi5bkyP7l3uA1+uDejUf5oo3aPB76S/mrfNJQkwIkqHBbOFHg
	hE1FN6hXMtvtnxLIwIQ8w19ANZOEXB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773758770; a=rsa-sha256;
	cv=none;
	b=TDsE8z/l67D7d1/a60FjqYRGlgv0GpOr5P5dBLsFt1JNU9p8lQkTQAZPtxnpCUo7K39Prv
	yju9xUaY1VwWlrdUpVVbeHR7K4R/TqnjlubZU665xYu1OzpDS+Aa2uRtqsQ7JF2SkM4Z4W
	A0VOa+ttt4DIl5tMLwgENGqv6cqTHIc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=key2 header.b=iZQaMoUL;
	spf=pass (imf19.hostedemail.com: domain of regressions@leemhuis.info designates 194.59.206.189 as permitted sender) smtp.mailfrom=regressions@leemhuis.info;
	dmarc=none
Received: from relay02-mors.netcup.net (localhost [127.0.0.1])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4fZvsW4vvzz4DtN;
	Tue, 17 Mar 2026 15:46:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1773758767;
	bh=hU7Ja8MxE/dZQQrcMBR1UXNehBbNM13GFFWz7ogHftw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iZQaMoUL+oEc/38KhuA8S8+7E2NC0J9rVIUVZT1JJx77OS2j03vgj/xPlEfi1f+0P
	 2E/ZAkpooyMSNVCR4T3TYQVQ3+OwddXBwg7Y+3xoXtRP3DFc5KNG8fP+yXV9/cfZSV
	 3EzJwd34x2jmlmbejI6WdW8jHuCLwJzCDBWEuh9Tg+wuceQFsDh4WaGmC5hJKDTA3r
	 67oSp6nLaKx47Ueixr32DUPLT7p9+kllIMM41Exr1T0pZI4f5i0pEXrMQ4KobMEtEc
	 k3qh4fDeKdkqz9s+0mbTL/7yXh+BO/eRgcFgbfyzO6w375znWGq2hZ3OEUqDAkKer6
	 F/Pt2AlX37nsQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4fZvsW4Bygz7wZR;
	Tue, 17 Mar 2026 15:46:07 +0100 (CET)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4fZvsW0drvz8svF;
	Tue, 17 Mar 2026 15:46:07 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 7C11D632D3;
	Tue, 17 Mar 2026 15:46:06 +0100 (CET)
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <bbba90be-5825-41d5-a0b2-49a56f75256a@leemhuis.info>
Date: Tue, 17 Mar 2026 15:46:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [regression] Re: RCU stall in unmap_page_range during exit_mmap (6.19
 regression)
To: Benjamin Eikel <debian@eikel.org>, linux-mm@kvack.org
Cc: rcu@vger.kernel.org,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <6261958.lOV4Wx5bFT@thinkpad-benjamin>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <6261958.lOV4Wx5bFT@thinkpad-benjamin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <177375876673.4092997.3395963888020776942@mxe9fb.netcup.net>
X-NC-CID: VI8GR9lw6G18Uo1yXINFhZklGUWTm/u/WkVDAqWoHVKv1JU15aY=
X-Stat-Signature: 8gos4p6kcnjhg4ar7xhaaem3p1jwqzho
X-Rspam-User: 
X-Rspamd-Queue-Id: E1E681A0018
X-Rspamd-Server: rspam12
X-HE-Tag: 1773758769-234909
X-HE-Meta: U2FsdGVkX19OON3kRMxElrhgQ8fIm6JFLWMRQ6+mu3Bm7Lsy0MHA8uwjvR9CsjFpmgT2N2h0dQLC1hlTPNVe4LPrMdyp7jZ8WgSBPG3+uLnNzbMS/QQQObpY8Qs7BXNL5DYh2OE2FyP8C9ObrL5ZzHGf/RuiyLZBKYa/IYnhps3kJ/8GpPU2fe7IGkBHiM4o07vCV6SSXmnBoI5gN20iWbMvZt5dwh7t8gsNg0QvRq+NsZfqBQ914NIrMWULIV7tWqrnLbIaTrkcQZkOoX/p+dIICwidrMIYmY7V88vh0kyFhRHOreSRwY2UU0fwwz9N6vVxALd8/J4Dbx5XSYv+gdQQoL8ceNbPYRSak1iLrcq3RCOxKw9GenLKLUAmGq1u5LNVDdGrIfcLIjNco6KfVgT9qEUO88oYNpPr7TTX8y87LvxAvEkG0ctzgSuZaqLMggHqfdPFDowrnXYZHh8/nr70yxiYTs1EHtQSLV3w+wr9cxTghc73USwIXTk5rWXaqF/fvTMuZiNoMcwGFowAnDzhhFgh66FxuZUS0yAiLxOqJoT+IHM/WxyCR1mBLJO8/j5ytiT47tiV5XN8imZ8vP3nQ0swLvWWoHUnXzSZu98T9I8c3AG82iDzsjS8NnAYhMpQ73bVzOSJTlV3QyDhPFPSu5IuPeNvs3io6U2w/rxRuVZolH+q3rYnQQWSWdPWxrPE1yex2rm4gQW7/cjcraVTbQMbBe8VtqJP20p2j2sLGMZFNseiVBGsxdKlT4WJZanf1aop4w7Y1+nL4rnYF8FmGYnBg74Uj7B2gh1Bi1vNh9l8DKr21WA01NLKeFzQTISIXQPq78xea56Jx3To66meTX2+pY7bjCT+1oHfo0jVtd5Ini7A0b45Q3kJtz/nNIUBix0JGeXHk2NkhtLpv19TlvhPIbaO72MAMfXI3zuqO/S53+d6q9IrAqENYCz0uugPd4co4yq5ew0B8Zt
 48kVIHkT
 B92icnKDzR+j4vprBm5Jwdddr3jx2QGXZjrBYS/aTibsIDiIDAR5MBiE8/fpDKuQogewmE/aYcVY3q1TBrbzYQBRg9h5Kt3SxiI/GcWYUPyqH2yvx/RsWwaEJ7zJvxertm5u4+BFEloQNElIBJzIO6ePK+WQ9d05LY12KebZpq/vwCfLECsIQ2xuP3h3FW7d0Hw4xCH2zBk8xSzhnfPnyQsyuN/8GLEoEEQpbBqkWjzHuaBdice00ojhYo6axhresJzkSFNpiVrtNLawsWGMpz1u25in6/2Yq89SMjp2uhL957WV1fki7gfZXxfmosSe2nu92TSJXSZaMvtuiMgHDCOxfNCjauLYwDzELFZUJjhSfQBXIjvQF2h+4f+xChIH/fFQmsMIPLFStxefMH1ZidAjN0hK2oy47FmNnS4uOvUJr6iLdAbNe92kq2rfDgunWPWZXizpUHgosv24dgfHcR7Hho2ByW1cfabdTWJs1OQBdlzsmH/A+NldUCWMI085LDIZULyUXdf1jgKXuwYxMbqtn5CyJG14kuBwz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ccing the regression list]

Lo!

On 3/16/26 09:18, Benjamin Eikel wrote:
> 
> I have reported this issue as Debian bug #1130138 [1], which has been marked 
> “upstream”. I am therefore also reaching out here to make you aware of it. 
> Please let me know if you need additional information.

FWIW, if no developer soon shows up to look into this, you likely need
to perform a git bisection to identify the change that causes this; you
might also want to check if mainline is affected:

https://docs.kernel.org/admin-guide/verify-bugs-and-bisect-regressions.html
https://docs.kernel.org/admin-guide/bug-bisect.html

Ciao, Thorsten


> After upgrading from linux-image-6.18.15+deb14-amd64, I see this error several 
> times and the system shortly freezes. It seems related to Zoom crashing first, 
> but the freezes were not noticable with older Linux kernels.
> Currently booted into 6.18.15+deb14-amd64 which does not exhibit this issue. 
> The stalls occurred when running 6.19.6+deb14-amd64. More information about my 
> system can be found in the Debian bug report.
> 
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


