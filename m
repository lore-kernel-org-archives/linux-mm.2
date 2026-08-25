Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD97C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 01:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6426B008C; Mon, 24 Aug 2026 21:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BE56B0092; Mon, 24 Aug 2026 21:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4465A6B0095; Mon, 24 Aug 2026 21:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11A4A6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:22:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F9C61A02D5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:22:08 +0000 (UTC)
X-FDA: 85138040736.04.12B2ABB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C8F3D1C0004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:22:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MsuVrxeF;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787620926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMf+k1qYoElhLjeGeyt6xhyjktXku4L4R9ADFGRmYsU=;
	b=a5KvhNUcZre5Q2n+ibklVqSWDKfB5HKv6xzEQtGAE8iLP6Nkjj98LUw9b9UlMweCFVlN5z
	295fpI03j5WXFbQVAhSQFG4B0e0kqagrLgx+7BdG+FSE1iYznG0IYr2+6AsKkkoGaUfV6M
	nkukYCYju2ruPO7MiQnMRth9K2Mh7AU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MsuVrxeF;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787620926;
	b=q/CdFG9rdq8hc3qjhv+8Z6N0PT5EaSFYbuZlD+WFC4Vb5BALq97JXrr6A14QBmAUPeiGK6
	aHqy9G3obw2JRtTeBIRwUNlDIMf80+VwjZ6tKcgTYu48QCKC4eAFOhJqrGqdOJAddMe62b
	yzrnSrGsuZvSyIkEGHm0PX5OmhEtCKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06B9360120;
	Tue, 25 Aug 2026 01:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8611F000E9;
	Tue, 25 Aug 2026 01:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787620925;
	bh=dMf+k1qYoElhLjeGeyt6xhyjktXku4L4R9ADFGRmYsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MsuVrxeFVLYM73ColyjiKkUoy+ki29rSdaEx1WqTJHMdb/zwFuO48VaWGncnwEfpc
	 F63Lys22NC2ZrGRn1ItwS5tP/uRUg2P2IigZEMJ24tSvI+IFj4HuMifoyebue6J6wr
	 jxRs5hk6lMywbJib5Ra37MeZCxnECF1TKh5tFZiw=
Date: Mon, 24 Aug 2026 18:22:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, Li
 Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 linux-raid@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in setup_conf
Message-Id: <20260824182204.d73425f7abbf90cfeae1580c@linux-foundation.org>
In-Reply-To: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
References: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C8F3D1C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: qxfkkhyeaiihz6cbwbre6641zzw63bbp
X-HE-Tag: 1787620926-378843
X-HE-Meta: U2FsdGVkX19WnqttKcSLs9OzqgOS6IbxWbEq88MdbaSADkev1WTTWjpHu3dcOflhqjkyacqJMargQci07blZTEyH98hZ67bbe+4el92QQPcN88O1ybsfK3I1Bx+DIUhVomyijL9uQTyYfEe2JTdRXMubUQj0Ge2ncoINPwf+LAoaJfrrR26BakwfUde7p5ztR3gNC06Yv4hHrO8/NLvQkG56pYL8eDpGA0lDK3Rlgsj4pVwoSObPMtX9AxkDbJ+ca1PeDD0l3qSrfTjfrg8gdWtvX6m+MBYsQSFukAKZpty9oLsPygzJ5pNo12M6kZpSUbAT5eOXihb6G3PryQ2ppVDUDJjq0F2sylcCOAC83Wq55VmBp3b06kupbXIeSW4gI8tK2/7jWDyPpCWhB2Cc0rDBHLJSWb2r6Q/6FuvetB+7wayfsyJoiu5W4dzfjacKJ79BqTCvSmCPkurXazrq2SZah6chUg2dDNWzZ9Wg9b9DwzV/9v8s4rdsz9FivnCIPcZ0XtlF325jffFM8Xrbq1226kVSqDUkVYXreeT59LTbGbY2cmI1Z7n5qXlXMd4+D1ECtR6333j28nweXHWVxZjD8mo2Qby+fjbJJOU5KmBMNW7Ac3kC4rPAmDpCEhjG+hOaGYfXoRR+Am14K5Q7WNuKhNxcZ1+0Gxzb/N07Bk/+3kdmm4gtuLrrpnXLi2L4oL4UgwUr30IbVM+voBYIVQ9BUEK2gLcEwTFR50BCPhUtWlqHsyoCiCza9QgHrLy0NOGfg8aPyRE+f4raZiumpfP94WGQWm2oSRLTdcVh5kFGkgY/k29iU7s6GNbTBUu9Fb6EdnUffn2NRAg1iJIOFlkpxsNURv6iBVuGLakjoa/CdQG1YemwT4cLkPNBj6ynyYW13XQhCjVVh92BIe2rjvaYz7DFXT5m0kC+aPFKxPIqgxolYNK4aJcydWC3nmubI6MP9VCDkrc+S6JNbaO
 BoZilgI1
 CpO2xz2TaXQu5JwnSj+qlsmOxb7HFYdBC1eIXiSClVIILqGXUtqRXnQe3wjy8i2cUVT9HHU0OVPG4Vit2Lvxwh3OenjCWUVpvKLz7Uma7rGHWQ99Y+z+H8UgclXGsOSs5kjlgthrxw6D8VJK+kJ7OGVM4RaGjC5oSP1uk5OlD0gayCoJGns1pPhopfZDnDtfJt5nXqrvdoZ7g1S+LwcIOG4gY3anX4Qpltlm2V5TNH37ylv4E8wDhVzRba8gby8RlPtc/mHeCH/x9Y4mnZC4Qx/Zm+pIw52o5EtN1UdXA2Og+GVVIEgAH+9e+EEJWtY96rWr1TLZhRV/MbcmLDgm3RPVhnnAfJCJmgPquo7dYV6/GAgLOkRPCtvcqMGcd7aPe6KBlHgRre0kvb5kinC8dlPg0LF7Uv7iwTVxIMdG2BDi1qqDRz65oxYEKjkLzGf/UnnHEZfmOnry5EFoq0kduWMK8Pa3VyFGQpVROUthba49HSXPnIwcjY6Qpp6fILxioQWxFRFkvp+Ad/uGNkm8Qi57nDdL1xuBCe3Ed7Z2LcWknuzB2+501lBaz/EaAk1WDtA40HJkIoGAHDZd/obDqr0IlgQKjHdAVd1Vj20t4ilDaSTrFIjtB00cqk94X57TBjgm6QBOdrBjzktJgy80FyUZQFuaH5Sn+m5WDyU5uXl5oML6cW7Gfg9ffzSlCDxcpKsGsypWbDEY9Fh9CEtoUqSHEjx8hoiCU/IBrrHvWCmLLO5A4wl/yY6+Jvr0L5h7TFK4sZPqIUY2uktCa+MkE7b1omI+Oy+rzXdzpM1bND2E1yXFBXZ4ld9ghZNq20yE+/HDFnzXMHMj9IU8JuilvbW9e0z6AfsLD8JbANxx4Gx9ZBkHSASbGs5CL1DFQWe/oLauas+WTdw0mx+NSc+EyjKkdmiWZGLj3AANkD1/g/rrmBbSqBetl0AUHS2otHEgIV9FUE504y7L7311VaXygNd7iVCUu
 N0694j+q
 CgVRkCjKRE+kfj2KzbUeeiNzBEMQcJ1TmbwBuzS7u4Bs0GCeoipJW3OBQm8vwtlrjty/RHnCceK7MHhxfM/m9wL2hV91SQo97VoVMyeFGpq5guxJlP0ST3NJNclFuXMPfpg9OGxW5Abl7ggvIKPALmqXDC4rV+vMaXfIPxiYGck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 17:03:34 -0700 syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9d2ed026f031 Merge tag 'sysctl-7.03-rc1' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1124919e580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6e414d6e0a79e71d
> dashboard link: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9d2ed026.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/89c0c0c0f535/vmlinux-9d2ed026.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/80d7adeb0e7d/bzImage-9d2ed026.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com

Thanks.  drivers/md/raid10.c lacks some sanity checking.

In setup_conf():

	/* FIXME calc properly */
	conf->mirrors = kzalloc_objs(struct raid10_info,
				     mddev->raid_disks + max(0, -mddev->delta_disks));

passed a crazy large number into kzalloc_objs(), causing
__alloc_frozen_pages_noprof() to hit

	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
		return NULL;


> tipc: Started in network mode
> tipc: Node identity 2007ff, cluster identity 4711
> tipc: Node number set to 2099199
> md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
> ------------[ cut here ]------------
> 1
> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5310
> Modules linked in:
> CPU: 0 UID: 0 PID: 5310 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
> Code: 74 10 4c 89 e7 89 54 24 0c e8 8e 2d 0e 00 8b 54 24 0c 49 83 3c 24 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 74 6e 18 0e 01 90 <0f> 0b 90 e9 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> RSP: 0018:ffffc9000d50f520 EFLAGS: 00010246
> RAX: ffffc9000d50f500 RBX: 0000000000000015 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000d50f588
> RBP: ffffc9000d50f610 R08: ffffc9000d50f587 R09: 0000000000000000
> R10: ffffc9000d50f560 R11: fffff52001aa1eb1 R12: 0000000000000000
> R13: 1ffff92001aa1ea8 R14: 0000000000040dc0 R15: dffffc0000000000
> FS:  00007fe2b9aac6c0(0000) GS:ffff88808c519000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffc93d2c090 CR3: 0000000044100000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x212/0x390 mm/mempolicy.c:2490
>  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
>  __do_kmalloc_node mm/slub.c:5322 [inline]
>  __kmalloc_noprof+0x409/0x720 mm/slub.c:5359
>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>  _kzalloc_noprof include/linux/slab.h:1309 [inline]
>  setup_conf+0x28b/0xce0 drivers/md/raid10.c:3883
>  raid10_run+0x1d2/0x16c0 drivers/md/raid10.c:3984
>  md_run+0xdbd/0x1e00 drivers/md/md.c:6760
>  do_md_run+0x35/0x720 drivers/md/md.c:6861
>  md_ioctl+0x1c58/0x2580 drivers/md/md.c:8492
>  blkdev_ioctl+0x5e3/0x740 block/ioctl.c:797
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe2b8b9e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe2b9aabfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fe2b8e25fa0 RCX: 00007fe2b8b9e0d9
> RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000009
> RBP: 00007fe2b8c35024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe2b8e26038 R14: 00007fe2b8e25fa0 R15: 00007ffe1ca65d58
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

