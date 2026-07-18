Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD305C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 14:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64DB76B0098; Sat, 18 Jul 2026 10:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625B66B0099; Sat, 18 Jul 2026 10:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563406B009D; Sat, 18 Jul 2026 10:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2277D6B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:05:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A25FA80453
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:05:44 +0000 (UTC)
X-FDA: 85002070608.11.CF3D7D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F166140006
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:05:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiZHHtgv;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784383543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YboIhEy8Gf7Sbuxc0hEVi+sD8/vS/YgZJ3wCELGbNY=;
	b=ZngwDbU7y8FdB2EKcVmo5YB2TFD+0c5T1p4wK5pzAal9/FceH+P+OExj5qDXam0AXHHKbZ
	zEBGYetTu8i+aN1nI5Bysl3KPpS7InktxVhrDbAfQU7J8L0SeYJnjp3e4tJelyXP/pv2hQ
	2Bus485PKNxIoirr5m3eBLHthlLW0M4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784383543;
	b=VMPPwdVR+yL/V0wlwF8nLLUevnxQd7wG8qC2zVvLbBNuVHu01QwvebE0jqVTCkrwOHMCWM
	cNboYh7f0jRZ66dDstMRGzE4xcen1ax+qhsOkTVJPp7e8Hzu/YI4SxbXrQba7ELFNhq1zX
	pl0OhQBMBpPSwq6k8w5kzWF7g2fyrFw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiZHHtgv;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B5DE60018;
	Sat, 18 Jul 2026 14:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA6C1F000E9;
	Sat, 18 Jul 2026 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784383542;
	bh=5YboIhEy8Gf7Sbuxc0hEVi+sD8/vS/YgZJ3wCELGbNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XiZHHtgv5ObrEyZ0pjsFqmHrk+8+cTiY6Yr+xwQBj2UAz5NslBYWQk3Y1HbsymMp/
	 2ScgrKZwjxdrJik5V+jhEH2pa6xa2Sj60UrVOnyAx8nI2eC4c90ssxIFINxQMjHu0a
	 y8cRk2G3J0HzfidzQC0P1/FTyGsN9QFpQQEZRE2jcOYUbl/Ndy9e77oGW9Ig3ti/F7
	 JsTERqNDt/nrc3eXYr2KvpbP6YSTuzejXjKOvEewH1pJG2lmzVmAfk3zRBMgABvDJ7
	 DSeTwoeELnIZzMuHP/hs8c7TcR0F7A0bb53gJ6T7Nu/5KqRuj/ruKk4rRQDX4OPtNl
	 wmIUOs2E3RARg==
Date: Sat, 18 Jul 2026 15:05:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Liav Albani <liavalb@gmail.com>, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Fix an imbalanced file ref count in the mmap syscall
Message-ID: <aluHg-QYRAPoFPof@lucifer>
References: <20260718123417.16339-1-liavalb@gmail.com>
 <alt9VpLcRFHAiy8q@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alt9VpLcRFHAiy8q@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F166140006
X-Stat-Signature: bn7rzeh9phoqzeqaiu77qop3mcrkedpz
X-HE-Tag: 1784383542-579620
X-HE-Meta: U2FsdGVkX1/RUHeC5p7FeMDvZI9XDQXsjPbQtk1vF30Og+tLRlNUtAi/NY2zL3Gz0uCBHWkMigGS0vvpQVm2LFCCC4VUWI1xa3tF3w4TgL2EprK8kxG9xRvq008Ps/B5EGWdbDiZk2UkKj0PL+PQPCyLQbOaR4B9fub5f0C/jb0fAJapmn2dmQrWN4b4Ceo3p9YtLIAPZp79QTM5kC/QKU8dsS6j0GXTbVh6/cHhzTb9R9YzingcWNfEPD2gMl18oUPj+c1ynES9UaNBMvWzxtI/jc/frBhcDRVpHkUduJaYqZKAW58skCwiy1O/Ybn6yxLwuLR2uMT+IU7JnBk8BOXrw10fwvUHrScTElrvQToRdd4ZLaLiimovRR2sB+/9GF/XVomtnQVEr3vAf6aBYBHvLbCAL3MS/gVwoDDFyFDUoRcrwH2GfVwc0tZRaaC61rtXTgbDnpXPKtw78C8DppuH+Tt8F1zP1XQc3vjG8OUm4/TPdc2PXO1YPpgweSW4l5w3qMmTEFGIMhU6fRdTK9JuLrmzfGaHXgq5SN+Zr5lUBx2X3ALAwQGTcQTcLZJ2zHUEHatKx0Q1E0TIM4JWzUU9dGA0u+OF3kfke2ALGfqZ4j2NuHLhizsqshWH8vx3BS2siwbL6m7LJH1Xh+2WIKL2Wl4uGXBZDpB89YS/ZyRX4SRHlNOa0UNdegN8ILTzdHOAg+Aa08vYtF6XBCo6aJRYkx/Lu3gCstSgLcx6DCr572HGic1YMgz7DwOUkQe0YliPiNHG9Y4hHSwrKG7kUUWQNfb8QjqXCS1P6cWuyG/3JSc56mX77KxqHdG0trVCIJVvZMMdbrEmpseZWshCKRmIR6YHqwItl34+wMy/hCWZlunLKnAs8VUInPdEdWDap6UQnpfObDGfhttER5btSF/l7r+Gqsn1JBgQVyYQ2rwEX9qekLAYeVzQwwWQn72O8cc6Xzv6uK1W/V1aOLJ
 WCHGvCwk
 l09/nRSyRqxiXyLU7J6NkVE0RQzL/xRFmpps4gsJqN1nLRPmDsY38Yc4IoqVB1Zav1S0OIdbIVZqYzQZznrBLTtpoeLYcE8HZbkXJc/yM/kVOM+cUXNGpM4IcaFTacf8I8gFDFjG/BRIeefnEd2R1icANPJSYZjDvMmipHxW9nOe0WPmgVmFJ1eFcpcbyCxQ2+4XsRmvpKYFujIIvcBbvRzN+tYOIMwBbDQ2QjBeboXRgzFN0z5BmiKoswgnKNGz+5y/GQPK1zWQ9GaJdL8e/JC0FSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 02:25:15PM +0100, Pedro Falcato wrote:
> On Sat, Jul 18, 2026 at 03:34:16PM +0300, Liav Albani wrote:
> > Hi!
> >
> > This is my first patch that I contribute myself to the Linux kernel.
> > My apologize if there are issues, I tried to solve this issue in one
> > evening and understand the call graph and what could go wrong.
> >
> > I work recently on a project of mine called nfiop, and specifically on a
> > kernel module called ufedm - https://github.com/nfiop/ufedm .
> >
> > The project has a driver that allows a userspace implementation to
> > intervene in the write and read callbacks of an MTD device by spawning
> > an upper MTD device that sends the data back and forth to userspace, so
> > userspace can implement its custom ECC engine and send back the results.
> >
> > So far so good. I started working with kernel 6.18.8 on an Olimex A20
> > board and then moved to my x86 linux machine with a nandsim simulation.
> > When I started my project, I implemented a memory backing based on a
> > shmem file for the shared memory buffer, that is expected to be mmap'ed
> > from my custom character device.
> >
> > When I updated my host machine, the new kernel version was 7.x so I
> > decided to update my module as well.
> > Many changes were comsetic, but the major change was to implement a
> > mmap_prepare hook.
> >
> > I wrote something simple, taking notes on the mmap_prepare rules and
> > the guide from kernel docs.
> >
> > Then I started to test that my character device is at least working
> > fine, so I have my unit tests for ioctls and mmap, and the mmap
> > unit-test failed after the second-run.
> >
> > A kernel stack looked like this:
> > ```
> > imbalanced put on file reference count
> > WARNING: fs/file.c:36 at __file_ref_put_badval.isra.0+0x3f/0x60, CPU#1: test_proxy_mmap/116
> > Modules linked in: ufedm(OE) virtio_net net_failover failover nandsim nand nandcore bch mtd
> > CPU: 1 UID: 0 PID: 116 Comm: test_proxy_mmap Tainted: G           OE       7.2.0-rc3-gaf5e34a41cd6 #1 PREEMPT(full)  bdadc55b51524b311c430c1536a97e7071150fd3
> > Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-2-2 04/01/2014
> > RIP: 0010:__file_ref_put_badval.isra.0+0x3f/0x60
> > Code: 85 f6 78 05 c3 cc cc cc cc 48 b8 00 00 00 00 00 00 00 a0 48 89 07 c3 cc cc cc cc 48 83 ec 08 48 89 3c 24 48 8d 3d 61 bc 30 02 <67> 48 0f b9 3a 48 ba 00 00 00 00 00 00 00 e0 48 8b 04 24 48 89 10
> > RSP: 0018:ffffc900006bbae8 EFLAGS: 00010296
> > RAX: bfffffffffffffff RBX: ffff88810409a180 RCX: 0000000038748000
> > RDX: ffff888100a44480 RSI: dfffffffffffffff RDI: ffffffff83b12730
> > RBP: ffffc900006bbbf8 R08: 0000000000000000 R09: 00007f8b49f8f000
> > R10: ffffc900006bbba0 R11: ffff88810409a208 R12: ffffc900006bbba0
> > R13: 00007f8b4a179000 R14: ffff888102222440 R15: 0000000000015040
> > FS:  0000000038726400(0000) GS:ffff8881b77d1000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000038728618 CR3: 0000000104a1c006 CR4: 0000000000370ef0
> > Call Trace:
> >  <TASK>
> >  __file_ref_put+0x30/0x40
> >  fput+0x4f/0x80
> >  remove_vma+0x42/0x60
> >  vms_complete_munmap_vmas+0x179/0x230
> >  do_vmi_align_munmap+0x225/0x2a0
> >  do_vmi_munmap+0xe6/0x1c0
> >  __vm_munmap+0x113/0x200
> >  __x64_sys_munmap+0x1b/0x30
> >  do_syscall_64+0xaa/0x660
> >  ? ksys_mmap_pgoff+0x168/0x200
> >  ? do_syscall_64+0xaa/0x660
> >  ? vfs_write+0x281/0x560
> >  ? ksys_write+0x7b/0x110
> >  ? do_syscall_64+0xaa/0x660
> >  ? do_syscall_64+0x5f/0x660
> >  ? clear_bhb_loop+0x30/0x80
> >  ? clear_bhb_loop+0x30/0x80
> >  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > RIP: 0033:0x440bcb
> > ```
> >
> > I started investigating this, and it became apparent that there's an
> > issue with ref-counting of the vm_file - I changed it in my mmap_prepare
> > hook, so it must be the cause, right?
> >
> > I also tried to artificially increment the ref-count of my shmem file
>
> You need to take a ref when doing the mmap_prepare file setting. mmap (and VMAs)
> consumes one reference, thus need to pin the file. Thus why the ref count
> manipulation around this whole code...
>
> So, in your case, something like:
>
> 	get_file(dev->shm_mapping.filp);
>
> in your proxy_chrdev_mmap_prepare looks correct. Otherwise, something else
> could sweep the file under the VMA. Note that this is true for every mmapped
> file, even something like /dev/zero (which does what you're doing, creates
> a shmem file and changes the VMA desc) implicitly donates the reference to
> mmap, which will later be unref'd (and the shmem file torn down) on munmap.
>
> Let me know if I hugely misunderstood your problem :)
>
> --
> Pedro

Yeah I agree. Thanks for the contribution and your interest in this part of
the kernel :) but any file replacing an existing one must be pinned as it
is then used by the mmap and the pin signifies that.

Perhaps a patch to the documentation could be useful here? In
Documentation/filesystems/mmap_prepare.rst

If you found it confusing that that implies it's not clear, so something
there saying 'if you replace the file, you MUST pin it via get_file()
before assigning desc->vm_file'.

Thanks, Lorenzo

