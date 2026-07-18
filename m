Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8070CC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 13:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A72D6B0098; Sat, 18 Jul 2026 09:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F696B0099; Sat, 18 Jul 2026 09:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36DBF6B009D; Sat, 18 Jul 2026 09:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02A696B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:25:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 677AAA0AE3
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:25:21 +0000 (UTC)
X-FDA: 85001968842.12.4554129
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6784220005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:25:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SN6prbFn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gGB9LIjD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SN6prbFn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gGB9LIjD;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784381119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NyFeik/6OqvK+QhewdEHLLwap3FrhUqFQNxLAcaWiUU=;
	b=bNYgxDixpRGvqz87OIEpJf2W/56Py9GUKM6Hm7xVvR9dN8B8JvBccs7ODbu+pQsdzgK8uN
	LKn7wrtYQVUViOnrJEB4/uaOxK84cwJ03JNVZoUyAj6W0tN0NCOr6ccohRmXd8SjC7DQvx
	dvrC8jeEFzPf8TI36CZNzo5FPvx6ULM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SN6prbFn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gGB9LIjD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SN6prbFn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gGB9LIjD;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784381119;
	b=wyhn/fY8DAyq2k7XurK35Mz1cjpeLuO5DtpxNgzykDJCb673XoqDUon9TYyfr/dHv9aA5+
	uJ3GOornWuVHZCp8Tf4VLWy/KF6QWrGKb+P71JTVfVsLo2TnGemW9ZhUht1vT9Exj0bR0E
	sX6CfcDzzfcgKK9xX85tR1CyaMbBzGg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C72253E4E;
	Sat, 18 Jul 2026 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784381117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NyFeik/6OqvK+QhewdEHLLwap3FrhUqFQNxLAcaWiUU=;
	b=SN6prbFnmzTvd7DxOhCxHij1UhhWX0OSmhktw5XWhgXdtww0i5XQlCc3Abr4/iWyphcUSv
	G3w8rGum/Z4InFT4+cbrID9LLrENE2XFLtBjTxXJiulW3qZpD+1Zo2WLOKwy9TDe88xaJ0
	nqLAEha5frsUL/ZyLOPEQ4lXXbTOYIk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784381117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NyFeik/6OqvK+QhewdEHLLwap3FrhUqFQNxLAcaWiUU=;
	b=gGB9LIjDf05nioALSX810MJnJLp8x+bCbPP7p8Pmy5eAUsIeQg0lxwKHp1FW6vONb+NEEr
	dUfd9a3zAsPDJ0Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784381117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NyFeik/6OqvK+QhewdEHLLwap3FrhUqFQNxLAcaWiUU=;
	b=SN6prbFnmzTvd7DxOhCxHij1UhhWX0OSmhktw5XWhgXdtww0i5XQlCc3Abr4/iWyphcUSv
	G3w8rGum/Z4InFT4+cbrID9LLrENE2XFLtBjTxXJiulW3qZpD+1Zo2WLOKwy9TDe88xaJ0
	nqLAEha5frsUL/ZyLOPEQ4lXXbTOYIk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784381117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NyFeik/6OqvK+QhewdEHLLwap3FrhUqFQNxLAcaWiUU=;
	b=gGB9LIjDf05nioALSX810MJnJLp8x+bCbPP7p8Pmy5eAUsIeQg0lxwKHp1FW6vONb+NEEr
	dUfd9a3zAsPDJ0Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E452E779AA;
	Sat, 18 Jul 2026 13:25:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0yy1M7x+W2qyIAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sat, 18 Jul 2026 13:25:16 +0000
Date: Sat, 18 Jul 2026 14:25:15 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Liav Albani <liavalb@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Fix an imbalanced file ref count in the mmap syscall
Message-ID: <alt9VpLcRFHAiy8q@pedro-suse.lan>
References: <20260718123417.16339-1-liavalb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718123417.16339-1-liavalb@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6784220005
X-Stat-Signature: 43yztpmke5an8frg78bdmq3kz5zujkfi
X-HE-Tag: 1784381119-265675
X-HE-Meta: U2FsdGVkX19A47PburXBQezMKkAXv5P59mIhaFD09jIL3rkg0wdMXNGKoIYZAOjsKFtcDEeIoI7fAycCLLl3H0/qH6isVdaafwFBRyGJFDLJwVGA9EqGuqnvputvH5NIFcjMy/9vNKp1/khzAIVPMEayM+JjThpSuYaT+lfOX9Uu7wDj2KzoiQX1FNx1hL4v6TWx7MCg0EjfcoKGJs3KqaCNEWbSqiJkouxSLra8PZQonWHTu+hnOY7Bp5vh/xbCYX7NaQXAp/FoPDn2lmMsK/bkrJG5ZunKJBvZhx/Us0gJiXskHPjtTdY/vJVM1so3Stpk5zhpIvFXhksVSVe6xh3XwTkPquTgN5YJx15n9pxpP9xwsUotSClzF67KAvu4nWiiQ43+x9gSoHjQ54R1ZeClAnnxOnq3mzYXK7Ll4+Lz+8QSfvGp8m2D/ht47o3ExJ+ICyMIcdQ68G9pj8bSOITpS5fVBG67SWLkzRLYjL7ee7yb0lBe2i7qi8pAMxraqcizOoaRgX4rEFyjWYrGDrEt9iT+L14wSPhBfQtfB0J2403nzkcxDYOtUrPP50QFGqfPbFd/f/WQuOvor7Ou1zu6+id/pAMardmQJxX7GciLADMu6FQzZL7RuSMwHWMP0ClTng9pHhd/mxwBgzNq6JjpRFo8uSQ9IGV6pa/ae9R4gKhsa7Ipwe7G4mSlk027veowKzjbdZcgISNpI92mRWNcL83NJsMP7nXzL8I56VAktlMfoHH3EgJTbH8YCs2qcP2YYXt3CvgmOY3Zbf22308WNvy8K5GthtMea7cPxKXjxFBtu8ZgyXnd6zr/jdAQA6hNIeMJx4WxdzN28A2ldcVrJgdM8f/E/ov6g0ZPof6CneUsMDIQplgz0oyngMc5DLM0cyh3IeCAWg8DKUiVtXdhJyhhc1BADiPwgTbdEzvz91ItE0TR1gUdO831kSMoZhkvSKnswZrPdiXjQRy
 /VLq5d29
 SIjrGB5tJcG8/doqAud63HpjGoLRBjXN5xh+oi7kp0ShPTB+PrnJTk+aDEhogG6uYY5gQXsY/fXCsYr5zyTMkwDZ7MBzrM1bKcAZtFc6qHtyOF/2FNCUb9uLI3AHKAtn102nT8bhVyp+cAUyn19wgwv4viBs3swdU/raiwR34oXnLKl0gPqokgrSVBvvsbS8/1YItRuJlgDAnOfGKJV6dhv1CLK18U6Y8A8bpMaNZvIWzR2WmJkaoYQEV8K1kEFjh/JK8pMShfi3YiNYLEmXY+6f4qepvk5bMZZAv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 03:34:16PM +0300, Liav Albani wrote:
> Hi!
> 
> This is my first patch that I contribute myself to the Linux kernel.
> My apologize if there are issues, I tried to solve this issue in one
> evening and understand the call graph and what could go wrong.
> 
> I work recently on a project of mine called nfiop, and specifically on a
> kernel module called ufedm - https://github.com/nfiop/ufedm .
> 
> The project has a driver that allows a userspace implementation to
> intervene in the write and read callbacks of an MTD device by spawning
> an upper MTD device that sends the data back and forth to userspace, so
> userspace can implement its custom ECC engine and send back the results.
> 
> So far so good. I started working with kernel 6.18.8 on an Olimex A20
> board and then moved to my x86 linux machine with a nandsim simulation.
> When I started my project, I implemented a memory backing based on a
> shmem file for the shared memory buffer, that is expected to be mmap'ed
> from my custom character device.
> 
> When I updated my host machine, the new kernel version was 7.x so I
> decided to update my module as well.
> Many changes were comsetic, but the major change was to implement a
> mmap_prepare hook.
> 
> I wrote something simple, taking notes on the mmap_prepare rules and
> the guide from kernel docs.
> 
> Then I started to test that my character device is at least working
> fine, so I have my unit tests for ioctls and mmap, and the mmap
> unit-test failed after the second-run.
> 
> A kernel stack looked like this:
> ```
> imbalanced put on file reference count
> WARNING: fs/file.c:36 at __file_ref_put_badval.isra.0+0x3f/0x60, CPU#1: test_proxy_mmap/116
> Modules linked in: ufedm(OE) virtio_net net_failover failover nandsim nand nandcore bch mtd
> CPU: 1 UID: 0 PID: 116 Comm: test_proxy_mmap Tainted: G           OE       7.2.0-rc3-gaf5e34a41cd6 #1 PREEMPT(full)  bdadc55b51524b311c430c1536a97e7071150fd3
> Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-2-2 04/01/2014
> RIP: 0010:__file_ref_put_badval.isra.0+0x3f/0x60
> Code: 85 f6 78 05 c3 cc cc cc cc 48 b8 00 00 00 00 00 00 00 a0 48 89 07 c3 cc cc cc cc 48 83 ec 08 48 89 3c 24 48 8d 3d 61 bc 30 02 <67> 48 0f b9 3a 48 ba 00 00 00 00 00 00 00 e0 48 8b 04 24 48 89 10
> RSP: 0018:ffffc900006bbae8 EFLAGS: 00010296
> RAX: bfffffffffffffff RBX: ffff88810409a180 RCX: 0000000038748000
> RDX: ffff888100a44480 RSI: dfffffffffffffff RDI: ffffffff83b12730
> RBP: ffffc900006bbbf8 R08: 0000000000000000 R09: 00007f8b49f8f000
> R10: ffffc900006bbba0 R11: ffff88810409a208 R12: ffffc900006bbba0
> R13: 00007f8b4a179000 R14: ffff888102222440 R15: 0000000000015040
> FS:  0000000038726400(0000) GS:ffff8881b77d1000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000038728618 CR3: 0000000104a1c006 CR4: 0000000000370ef0
> Call Trace:
>  <TASK>
>  __file_ref_put+0x30/0x40
>  fput+0x4f/0x80
>  remove_vma+0x42/0x60
>  vms_complete_munmap_vmas+0x179/0x230
>  do_vmi_align_munmap+0x225/0x2a0
>  do_vmi_munmap+0xe6/0x1c0
>  __vm_munmap+0x113/0x200
>  __x64_sys_munmap+0x1b/0x30
>  do_syscall_64+0xaa/0x660
>  ? ksys_mmap_pgoff+0x168/0x200
>  ? do_syscall_64+0xaa/0x660
>  ? vfs_write+0x281/0x560
>  ? ksys_write+0x7b/0x110
>  ? do_syscall_64+0xaa/0x660
>  ? do_syscall_64+0x5f/0x660
>  ? clear_bhb_loop+0x30/0x80
>  ? clear_bhb_loop+0x30/0x80
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x440bcb
> ```
> 
> I started investigating this, and it became apparent that there's an
> issue with ref-counting of the vm_file - I changed it in my mmap_prepare
> hook, so it must be the cause, right?
> 
> I also tried to artificially increment the ref-count of my shmem file

You need to take a ref when doing the mmap_prepare file setting. mmap (and VMAs)
consumes one reference, thus need to pin the file. Thus why the ref count
manipulation around this whole code...

So, in your case, something like:

	get_file(dev->shm_mapping.filp);

in your proxy_chrdev_mmap_prepare looks correct. Otherwise, something else
could sweep the file under the VMA. Note that this is true for every mmapped
file, even something like /dev/zero (which does what you're doing, creates
a shmem file and changes the VMA desc) implicitly donates the reference to
mmap, which will later be unref'd (and the shmem file torn down) on munmap.

Let me know if I hugely misunderstood your problem :)

-- 
Pedro

