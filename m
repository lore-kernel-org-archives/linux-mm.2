Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51115CCFA1A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 08:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEED38E0010; Thu,  6 Nov 2025 03:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FFD8E0002; Thu,  6 Nov 2025 03:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98ECB8E0010; Thu,  6 Nov 2025 03:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2AA8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:43:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4100D160638
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:43:36 +0000 (UTC)
X-FDA: 84079543632.16.40A3100
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 08C391C0005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:43:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=W5YLioDe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YWPtDJAM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=W5YLioDe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YWPtDJAM;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762418614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sswmt4J0aLVPOKtr4xhZAlr6mDBfGuLUTP9RQrzr0jk=;
	b=ZwS2g+hApYupIrHEnyC0dBc8oeb0ehtGmMzUjFOvVoh97fbCdIHPP+VAg8RMuzoM4aCShS
	3hPMARsAcUTGXpdjjGTs1wm4b19D3mzqgR3JIw+91Jh3+IbTN46BVhI23IlGJVBmsmgZpR
	tV3Ft1t5IHO3e4SvfxkuO8O8KdkLJco=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=W5YLioDe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YWPtDJAM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=W5YLioDe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YWPtDJAM;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762418614; a=rsa-sha256;
	cv=none;
	b=kZCMGxmPOKRTCvERidQoGqW+wf/ndL8gB+q16PhkRCGA1sK349j0Od9ho7vgJpKBXjBLcw
	TsAg2odi8syl4b0bmkKtgN/tNMqpjFp8WNsU/GnxEaH+MYuHP+WC7i1/rQE16K6lRl6unP
	KXJCQYXGpOQ9w7kSB7A/Fgz8hAAgpFM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 75EE921194;
	Thu,  6 Nov 2025 08:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762418607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sswmt4J0aLVPOKtr4xhZAlr6mDBfGuLUTP9RQrzr0jk=;
	b=W5YLioDeqt4MRMm2tCeuY30dkbESv/0KIobVbol6iQnwgx1f5ntgWo3JXcvAe1R9mwxfiW
	sEPM6aDtV9rkDTRUugSqcooiKrqS4pAdJ0JAQnmMj2YUZDVNy2ufidKYQ3SLcbiYap6MPk
	QMS4KZwYJOOTftOOXxKSvMnwc+XpVBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762418607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sswmt4J0aLVPOKtr4xhZAlr6mDBfGuLUTP9RQrzr0jk=;
	b=YWPtDJAMywHqn42RxiKz+H19fg0gajP748WkVn2MKMBq52XwhBD14IZkYSOAWe03kHINvC
	7Iqa0ipvdAPm2JBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762418607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sswmt4J0aLVPOKtr4xhZAlr6mDBfGuLUTP9RQrzr0jk=;
	b=W5YLioDeqt4MRMm2tCeuY30dkbESv/0KIobVbol6iQnwgx1f5ntgWo3JXcvAe1R9mwxfiW
	sEPM6aDtV9rkDTRUugSqcooiKrqS4pAdJ0JAQnmMj2YUZDVNy2ufidKYQ3SLcbiYap6MPk
	QMS4KZwYJOOTftOOXxKSvMnwc+XpVBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762418607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sswmt4J0aLVPOKtr4xhZAlr6mDBfGuLUTP9RQrzr0jk=;
	b=YWPtDJAMywHqn42RxiKz+H19fg0gajP748WkVn2MKMBq52XwhBD14IZkYSOAWe03kHINvC
	7Iqa0ipvdAPm2JBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DA6B13A31;
	Thu,  6 Nov 2025 08:43:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BJn5A69fDGmKZQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 06 Nov 2025 08:43:27 +0000
Date: Thu, 6 Nov 2025 08:43:25 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Robert Dinse <nanook@eskimo.com>
Cc: mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
Message-ID: <erytfim3m6fy7qy3tmfwwkr6ymvyfoevhwsac4xtadimei6ux5@um6ylfu5e4ci>
References: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 08C391C0005
X-Stat-Signature: cq74qmp1moicmx3r4cxo9sydm8utf31g
X-Rspam-User: 
X-HE-Tag: 1762418613-817496
X-HE-Meta: U2FsdGVkX1/+FpGugzaOzB6lAmRBo+iipy0pro2Rxs6oVRE5IYGsiG2zZgPjk3knK9nPPFNid2eaAIc28h3B1oTmUXWj0hRPTfJNDXw1FvVaCu5VuMlWERJ6y2k/luFHqlx880Ohi0uknWBgxBXTMW6RrmubJQBL0/QmnVD87OH721i3k2+ou1+DenKpr1+FoxyqDAQus1rM49YFxShzp61dKXDqsCOWYS7hkR1Hieq18z/9HBEw/HtjU9V2wvqqzd3hXGnYZz0vho5GeaxvLVHuf6zbx6QbZwiHkBHXsmE3/M4y0o93Psqc+pN1MPl4PcvQfw1tSUqqRrAUMQahGVRmM6eU9GB2OcZcrWT8pVV8JElwOFTee6JccDNptNDBDztCgIzkPV5Qufs4jjzOoxb1tnOyrXchdOA/L3Qve6HNghvH76BJdPyKRXCAPZYlBnBvdv2jrS1UiKUrq1vaPEUNJUVMSe0mUP1scXpM5Rm36M1yA0PItQEzwUWKQ0k27tuOAZ5Rkl6YC9jen3oWurooCzEwl8mfc60FLWqZ7237j6BIoKLoFIUVaeu7jb0KT9Rf3JGPam7qi7BB8w06IdlfcFkgwhvQszhnmHbQGMQnCrkZdbI2Fpw7G3w448K4jAtIkQPlz54M08zBJddZjGBKRV6c/aJ5RFtxmniyNh6/GWa39wtCceKbjx06C5yeKDPuvee1Df0HauCUui4zci6dt3gPd5orgN8o9RZqT40MOLTNYpltKB3/rVOVD0DWSXKxKChZn+z2l7I+gwbgUzR7cbKqyq/NQ+fuujJNFBoRJVaHPUQ6GKv3i0cBOeqCGd7fgkhD/XTqjxrZLr73JL73geL2N5UHIYWU/gdqcTGQ4ZZUs5TfxCGVSr/owyXzP4I7nJSx4bKD6xjGzsEFALiM0bq7v8vRm8lF6hHfHC/9M5fYKbrugvEu1cUFH2aT/MGdF9BldtUzQ7o02UK
 cUTPYnnn
 fBfmjq3NBJf6YYrSE3VQDKilepdO+eqXVLrNmUbDf/VTchJVfuTUa5tVlgUHMsRgS85NHROEPiCM1ly+gaQxl1cq/1rbQSGhpXh+TdC/gcCqDCx0PCnOg+mUTcAIQ9BFh2bJkk+o1CdEzkYafBOjb0vhLQ3C/rVH6zaUAixC/TLDBCSvP1W2xO0cp0UDnwwRTrBFBxE3kC2Z6h6oSIFjCgkchvJwRUYDGY743m8TL24Y0+/OEEPytZ5ykYMRnnrfR4BbF5YAQblfetnohVK19gy1Y3cowNz3NxTd4b9njpm9ruRSIEaZJlX4Pvxka3C9S/MHM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 07:19:17PM -0800, Robert Dinse wrote:
>       Since 6.17.5 I have twice had one of my servers lock up in a state
> where it still routed network traffic and responded to pings but no user
> programs are running.
> 
>      These are proceeded by kernel splats:
>

Are you sure it didn't ever repro on 6.17.5?
Also, I'm wondering if you have the rest of the dmesg?

> [542551.007650] [    T238] INFO: task php8.3:1373100 blocked for more than
> 614 seconds.
> [542551.007652] [    T238]       Tainted: G S      W   E  6.17.6 #1
> [542551.007653] [    T238] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [542551.007654] [    T238] task:php8.3          state:D stack:0  pid:1373100
> tgid:1373100 ppid:5513   task_flags:0x400000 flags:0x00004002
> [542551.007657] [    T238] Call Trace:
> [542551.007658] [    T238]  <TASK>
> [542551.007659] [    T238]  __schedule+0x41c/0x16b0
> [542551.007661] [    T238]  ? _raw_spin_unlock_bh+0x1d/0x30
> [542551.007664] [    T238]  ? tcp_cleanup_rbuf+0x43/0xa0
> [542551.007670] [    T238]  schedule+0x20/0xe0
> [542551.007671] [    T238]  io_schedule+0x4c/0x80
> [542551.007673] [    T238]  folio_wait_bit+0x102/0x200

This does not have anything to do with folios (probably), but it looks like
swap IO is stuck. So, could possibly even be a block IO problem.

> [542551.007676] [    T238]  ? __pfx_wake_page_function+0x10/0x10
> [542551.007678] [    T238]  folio_wait_writeback+0x2e/0x80
> [542551.007680] [    T238]  shmem_swapin_folio+0x58d/0x1210
> [542551.007683] [    T238]  ? mod_memcg_lruvec_state+0xed/0x2b0
> [542551.007686] [    T238]  ? xas_load+0x11/0x100
> [542551.007688] [    T238]  ? filemap_get_entry+0x60/0x1c0
> [542551.007690] [    T238]  ? __lruvec_stat_mod_folio+0x7a/0xc0
> [542551.007693] [    T238]  shmem_get_folio_gfp+0x17a/0x5f0
> [542551.007696] [    T238]  shmem_fault+0x7a/0x390
> [542551.007698] [    T238]  __do_fault+0x38/0x1b0
> [542551.007701] [    T238]  do_fault+0x2bc/0x5b0
> [542551.007703] [    T238]  ? __x64_sys_alarm+0x61/0xb0
> [542551.007707] [    T238]  __handle_mm_fault+0x439/0xfc0
> [542551.007709] [    T238]  ? x64_sys_call+0x17e7/0x2330
> [542551.007715] [    T238]  handle_mm_fault+0xeb/0x2f0
> [542551.007718] [    T238]  do_user_addr_fault+0x203/0x690
> [542551.007720] [    T238]  exc_page_fault+0x7f/0x170
> [542551.007722] [    T238]  asm_exc_page_fault+0x27/0x30
> <snip>
> [542551.008011] [    T238] Kernel panic - not syncing: hung_task: blocked
> tasks
> [542551.008013] [    T238] CPU: 16 UID: 0 PID: 238 Comm: khungtaskd Kdump:
> loaded Tainted: G S      W   E       6.17.6 #1 NONE
> [542551.008017] [    T238] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN,
> [E]=UNSIGNED_MODULE

So, you have 1) CPU_OUT_OF_SPEC (wondering how you even have that?),
2) WARN before (which possibly explains this hang)

> <snip> 
>      Am running self compiled kernel on Ubuntu 24.04 system.  The .config
> used to generate the kernel is attached.  The compiler used is gcc 15.2. 
> The hardware this is running on is an i9-10980xe based machine clocked at
> 4.4Ghz all cores with -8 multiplier offset for avx512, -3 multiplier offset
> for AVX2.  The machine is equipped with 256G of RAM. There are three RAID1
> arrays, one based upon two SN770 WD Black nvme 1G drives mounted on /root,
> another based upon 13TB CMD drives on /space and a third on 13TB SMR drives
> on /bu.  We use Apache/2.4.65 (Unix) OpenSSL/3.6.0-dev and PHP from 5.6 to
> 8.3, most applications on 8.3.

So, yeah. As you mentioned on another email, a crashdump could most
definitely prove useful, but that's a PITA to setup. I think the full
dmesg could possibly be the key here. I would not be surprised if this
turns out to be a bug in another place.

-- 
Pedro

