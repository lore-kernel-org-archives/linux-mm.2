Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E713DC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 21:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9880D6B007B; Mon, 20 Jul 2026 17:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938B56B008A; Mon, 20 Jul 2026 17:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828756B008C; Mon, 20 Jul 2026 17:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2D76B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:41:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3838402E4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:41:08 +0000 (UTC)
X-FDA: 85010475816.15.31F893F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 32B11160003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:41:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pjzAkcNx;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784583667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoK+4giQKcMFH+bYOQl1nYWS1DIN295cFQNYu91TQuw=;
	b=Q7lcqox8gal3OF+hE/h+JjjpF0abdJaz1Yen+Gnz0hNI6Gj2DankEUv3aaD/0qEILtVdx1
	S3s3ygXacJOYZmeygLdHsVcYGjhfeBkUDGK2TCFTSTpXcJpFuEtirUSb6ZyrkQihrJd0s1
	49FFuPYhA0Jn7MYx2qqJEwnTzA+REkA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784583667;
	b=VNHepGaeZDZtKNa4o83qvWOJBModUCswo++iIaFBRnFJiRfj+4eIzLFaaCwJZJN6d6hncI
	GLLReCNjJ9xu3XryXkuzgAOXSrM3J8lEEHMT+AR0DzdCidiXZ6K1Udw1ncptcx2AiinhVo
	hBKL6vfhn5QNI7CqIjmWUWyYTFPBFEc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pjzAkcNx;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BoK+4giQKcMFH+bYOQl1nYWS1DIN295cFQNYu91TQuw=; b=pjzAkcNx2VvIzFiFNf9E8ADTA8
	rQua3t/PzhBgSH6Lu2r1ic8Qz1/k26bOlcyRC73XZfHL2Hwki2oX66BW2IhEWF2wa5yroWDhQ2G6Y
	IYBD3dxZuvVbeaxJdOxRajBLsbe7qSG7PoDr0TZRKmJM7VC7NKDokMklUfbO2gvM1UN20UiwMLcyl
	TC9VaCoAvfKCOtai1YbjppJNZzItaOGc+TCwA6T/L6UkeyR2trfJCdpCu3iIfNlbuUccOtOk2Xig2
	IZf9ZJkS8zr/JvU0s0hnuSwz6vZXP8zGl7Pm/volcFSylJH7RWuO4WqdRzsu+5q5nNafQLsQNiQ94
	KBxp7DYg==;
Received: from [12.151.47.154] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlvjU-00000007yFg-1UDn;
	Mon, 20 Jul 2026 21:41:04 +0000
Date: Mon, 20 Jul 2026 17:41:03 -0400
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH v2 03/19] maple_tree: Add write lock checking with
 lockdep sequence numbers
Message-ID: <fo5r2xl3fql6gyvjasfvfu4ftugjti2vxg7zskdw7hjeo3xvqm@kk66qmsf762s>
References: <20260630190843.3563858-1-liam@infradead.org>
 <20260630190843.3563858-4-liam@infradead.org>
 <ak5v9UDuieA-dNUh@gmail.com>
 <dzp5qpqjzc3j2jwnamgbv7j2blqcbp6xq5jnwvkm6hzx6fbjni@2vom3uipdkuo>
 <al5F7sT-39J_wbbR@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6r6evq5qs3vswy6a"
Content-Disposition: inline
In-Reply-To: <al5F7sT-39J_wbbR@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 32B11160003
X-Stat-Signature: ksgyr6eh1qnykxunt7x67ppa4d63f4o7
X-Rspam-User: 
X-HE-Tag: 1784583666-239631
X-HE-Meta: U2FsdGVkX1+trP7VzWUr+MyTTL7UR+P7rOG16XsfIPrdvs73BSlwvkmb08j5R3/Figi+14/ftdqLIGNAaQvTGuKHVBXjzluHv0zuraAqXMFgtiypC6qDQ16n+1oh0iYdlTd1PbpL9a+xDnub1PMGBh7EkbEE5FClPBqrOa8bQfQgLK0GKO23J9fxXjqXuoP8Vq41hMtpALlvpgvdbD8XhS4LAYu4GxmHrM01cWJ1jWYwsX5QjGcRVA1n5QMCjMwEhAL35c7lG6I9dmZ7gXHwBOFenMLndHzh9FYfjTtmAdxzSkSpBcX1ZuUTEhp3aK/DvvAe0E0SXwJdXu6vHpriTy1op96L7uNauhMd4iZlLOhK35/YnKZGnVVqCXACujQV79bbf9m3IYUzN26vErywSLZE1/tH0BlxJYq2AqPrTYSNzu92ZQkkw5vuD/mi3nRv84+oOh+lYpgf6nSl5nGMN3J+0cKhqDwWtWRk7YeFDnBL/kAPOIq8l4QB2yRWBpmwLxENwm1aRaPYmUWKld8z/u8wQjfpV23BaI5qjGkmvzg8+VW/FVcHJa8p0Au3M2P3Fwkv34q1rWFeDDX+RFhznAiDMGzB/8YnYcdgS8YvHmVrOLPOfxgAfEvdRJri5Q8ftU9ZhHKABbAbcAygowV6LEg9Cn6JsuKjNJIh7sydllQOG0p7p2RtUupoxSGVQ+O5k/YwMwi+mnmG4lG43eq6isbYj/hfZx8GHuMYmrOHCOUAebSq6YxhH0ESRhuL0w8C6CenCodGsVjlKIobLagGAa6wbb/E/ox0aiquStkG4G9+qjLJLHUJk8qci7h52bNZlGkxiFMzOS9/PjVHD2hHkTq9XuY5ifh/6vFdlRIttOJj9G6qh51X8R3SH+dTqEGBuvDbcQROVBlVwW4OOKwP9VmCKeSLoK5qWxR4vnk23kasJzpfQzxL3C33MwZ6/NTFtWpJkXltjgNkcvGwUY3
 HnyWshQC
 +oncxID19dYNpwPkxustxNcDhr+L9mcuNeqBCYXGOzRxsdOstOTDqse3h9j8hEYyDdEijU5tsCchhsv4ayI1B5VVPHilcaIEqbodYjCaUFJPBWBfy9o8+bvFJrLzxc0w5jwlXVz+E/nnGPLMG1lpDi1tWcyZ/4c+DrV+hSIxH1dBBj05a4L4lOYaHXbm6E/zd1zxTilcSoOM25eXB41Pw4Xd36Vf8vCKP5zbnIZ5TQyqnALvDKf80DxwgM+6L3LR8JwfP7pmt12dimRZT6hXsfhVdWKS9N/B9L3IS3LjsogvqXBnkN8PA6WsiNrL7UN8Ezl4EoZ5fkfBzHfyKElPJMJ5Io6D6y/teSI+IaS/j0OEeHUo6BpdMj/yXRxjmwCgcXWfUo+452uhiS/CIAlm76G99XXVJfRv6hvBjYqC2i3dDFY9mQN9emMgZ8mvlJQ2s6b5DvShopxNGEVZIgN09VkGE/USWCAoZ4D0O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--6r6evq5qs3vswy6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26/07/20 09:04AM, Breno Leitao wrote:
> On Mon, Jul 20, 2026 at 10:03:51AM -0400, Liam R. Howlett (Oracle) wrote:
> > On 26/07/08 08:44AM, Breno Leitao wrote:
> > > Hello Liam,
> >=20
> > Hello!
> >=20
> > >=20
> > > On Tue, Jun 30, 2026 at 03:08:27PM -0400, Liam R. Howlett (Oracle) wr=
ote:
> > > > +#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
> > > >  	if (!mt_locked(mas->tree)) {
> > > >  		if (mt_in_rcu(mas->tree))
> > > >  			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
> > >=20
> > > Testing next-20260706 on arm64 under a stress-ng + fork/exit/mprotect=
 workload,
> > > I'm hitting the new maple_tree write-lock sequence check:
> > >=20
> > >     WARNING: lib/maple_tree.c:1188 at mas_store_prealloc+0x2a8/0xac0
> >=20
> > No, this is not expected and I didn't know about it.  Does it still
> > happen in next?  I'll start looking at this while I wait to hear from
> > your side.
>=20
> Yes, I see it on my everyday's test.
>=20
> >=20
> > That's very odd.  Does anything show up with a lockdep build?
>=20
> Yes, but not sure if this is related. This is happening twice, thus, the
> messy kernel message
>=20
>  01:37:12  perf: interrupt took too long (3127 > 3126), lowering kernel.p=
erf_event_max_sample_rate to 63000
>  01:37:38 =20
>            ------------[ cut here ]------------
>            WARNING: lib/maple_tree.c:1188 at mas_find+0x620/0x810, CPU#45=
: stress-ng-sysfs/419993  =1B[36m[warn]=1B[0m
>            Modules linked in: md4(E) vhost_vsock(E) vfio_iommu_type1(E) v=
fio(E) act_gact(E) tcp_diag(E) inet_diag(E)
>            ------------[ cut here ]------------
>             cls_bpf(E)
>             evdev(E) ipmi_devintf(E) ipmi_msghandler(E) spi_nor(E) button=
(E) sch_fq_codel(E) vhost_net(E) tap(E) tun(E)
>            WARNING: lib/maple_tree.c:1188 at mas_store+0x2a8/0x678, CPU#7=
: stress-ng-sysfs/419987  =1B[36m[warn]=1B[0m
>             mpls_iptunnel(E) vhost(E) tls(E)
>            Modules linked in:
>             vhost_iotlb(E) mpls_gso(E)
>             md4(E)
>             mpls_router(E)
>             vhost_vsock(E)
>             loop(E)
>             vfio_iommu_type1(E)
>             fou(E)
>             vfio(E)
>             efivarfs(E)
>             act_gact(E)
>             autofs4(E)
>             tcp_diag(E)
>             [last unloaded: test_bpf(E)]
>             inet_diag(E)
>           =20
>             cls_bpf(E) evdev(E) ipmi_devintf(E) ipmi_msghandler(E) spi_no=
r(E) button(E) sch_fq_codel(E) vhost_net(E)
>            CPU: 45 UID: 0 PID: 419993 Comm: stress-ng-sysfs Kdump: loaded=
 Tainted: G            E       7.2.0-rc2-next-20260710upstream-baseline #19=
 PREEMPT(full)=20
>             tap(E) tun(E) mpls_iptunnel(E)
>            Tainted: [E]=3DUNSIGNED_MODULE
>             vhost(E)
>             tls(E)
>             vhost_iotlb(E) mpls_gso(E) mpls_router(E)
>            pstate: 03401009 (nzcv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=3D=
--)
>             loop(E) fou(E)
>            pc : mas_find+0x620/0x810
>             efivarfs(E) autofs4(E) [last unloaded: test_bpf(E)]
>            lr : mas_find+0x1c8/0x810
>           =20
>            sp : ffff80011fa579e0
>            x29: ffff80011fa579e0
>            CPU: 7 UID: 0 PID: 419987 Comm: stress-ng-sysfs Kdump: loaded =
Tainted: G            E       7.2.0-rc2-next-20260710upstream-baseline #19 =
PREEMPT(full)=20
>             x28: 1ffff00023f4af5d x27: 1ffff00023f4af62
>            Tainted: [E]=3DUNSIGNED_MODULE
>            x26: ffff0000b65379a0
>             x25: 00000000000000e7 x24: 1ffff00023f4af6f
>            pstate: 03401009 (nzcv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=3D=
--)
>           =20
>            x23: dfff800000000000 x22: ffff00011aa90e78
>            pc : mas_store+0x2a8/0x678
>             x21: fffffffffffffffe
>            x20: ffff80011fa57b30
>            lr : mas_store+0x2a0/0x678
>             x19: ffff80011fa57b78
>            sp : ffff80011e9c7810
>             x18: 0000000000000000
>            x29: ffff80011e9c7890
>            x17: ffff800082ef24c4
>             x28: 1fffe000507cf8f2
>             x16: 0000000000000068 x15: 0000000000000001
>             x27: dfff800000000000
>           =20
>           =20
>            x14: 1fffe001310d8da4
>            x26: ffff000283e7c790
>             x13: 0000000000000001
>             x25: 0000000000000097 x24: 1ffff00023d38f40
>             x12: 0000aaf4db60a000
>           =20
>            x11: ffff00015fb58bf0
>            x23: dfff800000000000 x22: ffff0009dd07f178
>             x10: 0000aaf4db60a000
>             x21: ffff000283e7c780
>             x9 : 0000000000000300
>           =20
>           =20
>            x20: ffff80011e9c7a00
>            x8 : 0000000000000000
>             x19: ffff80011e9c79b8 x18: 0000000000000118
>             x7 : ffff8000808bcf34
>           =20
>             x6 : 0000000000000000
>            x17: ffff800082ef24c4
>           =20
>            x5 : 0000000000000000
>             x16: 0000000000000068
>             x4 : 0000000000000001
>             x15: 000000000000000a
>             x3 : 0000aaf4db60a000
>           =20
>            x14: 1ffff00023d38f07
>           =20
>             x13: 0000000000000000
>            x2 : 0000000000000000
>             x12: 0000000000000000
>             x1 : 00000000ffffffff
>           =20
>             x0 : 00000000ffffffff
>            x11: ffff700023d38f11
>           =20
>             x10: dfff800000000000
>            Call trace:
>             x9 : 0000000000000300
>            x8 : 0000000000000000
>             mas_find+0x620/0x810 (P)
>             x7 : 0000000000000000 x6 : ffff8000808bf46c
>            x5 : 0000000000000000 x4 : 0000000000000008 x3 : 0000000000000=
000
>             unmap_vmas+0x180/0x320
>            x2 : 0000000000000008 x1 : 00000000ffffffff x0 : 00000000fffff=
fff
>            Call trace:
>             exit_mmap+0x134/0x8f8
>             mas_store+0x2a8/0x678 (P)
>             __mmput+0xb8/0x340
>             dup_mmap+0x698/0x1350
>             mmput+0x60/0x98
>             copy_mm+0xe4/0x3c8
>             do_exit+0x594/0x1a28
>             do_group_exit+0x180/0x220
>             copy_process+0x12f0/0x31e8
>             __arm64_sys_exit_group+0x50/0x58
>             kernel_clone+0x14c/0x768
>             __arm64_sys_clone+0x100/0x140
>             invoke_syscall+0x74/0x188
>             do_el0_svc+0x10c/0x198
>             invoke_syscall+0x74/0x188
>             do_el0_svc+0x10c/0x198
>             el0_svc+0x64/0x260
>             el0_svc+0x64/0x260
>             el0t_64_sync_handler+0x84/0x130
>             el0t_64_sync_handler+0x84/0x130
>             el0t_64_sync+0x198/0x1a0
>             el0t_64_sync+0x198/0x1a0
>            irq event stamp: 251
>            irq event stamp: 265
>            hardirqs last  enabled at (251): [<ffff800080911648>] seqcount=
_lockdep_reader_access+0x68/0xc8
>            hardirqs last  enabled at (265): [<ffff800082da75ec>] _raw_spi=
n_unlock_irqrestore+0x44/0xb0
>            hardirqs last disabled at (250): [<ffff80008091160c>] seqcount=
_lockdep_reader_access+0x2c/0xc8
>            hardirqs last disabled at (264): [<ffff800082da73c0>] _raw_spi=
n_lock_irqsave+0x38/0x90
>            softirqs last  enabled at (136): [<ffff80008011dfb4>] handle_s=
oftirqs+0xd8c/0xf08
>            softirqs last disabled at (131): [<ffff8000800103d0>] __do_sof=
tirq+0x20/0x2c
>            softirqs last  enabled at (178): [<ffff800080092ed4>] fpsimd_s=
ave_and_flush_current_state+0xac/0x100
>            ---[ end trace 0000000000000000 ]---
>            softirqs last disabled at (176): [<ffff800080092e58>] fpsimd_s=
ave_and_flush_current_state+0x30/0x100
>            ---[ end trace 0000000000000000 ]---
>            =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>            WARNING: possible circular locking dependency detected  =1B[36=
m[lockdep]=1B[0m
>            7.2.0-rc2-next-20260710upstream-baseline #19 Tainted: G       =
 W   E     =20
>            ------------------------------------------------------
>            stress-ng-sysfs/419983 is trying to acquire lock:
>            ffff000390315b78 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_l=
ock_killable+0x20/0xe8
>           =20
> but task is already holding lock:
>            ffff0000a1747180 (&root->kernfs_rwsem){++++}-{4:4}, at: kernfs=
_fop_readdir+0x1e8/0x720
>           =20
> which lock already depends on the new lock.
>=20
>           =20
> the existing dependency chain (in reverse order) is:
>           =20
> -> #3 (&root->kernfs_rwsem){++++}-{4:4}:
>                   down_read+0x68/0x320
>                   kernfs_find_and_get_ns+0x3c/0xf8
>                   sysfs_notify+0x90/0xd0
>                   btrfs_exclop_finish+0x94/0xb8
>                   btrfs_swap_activate+0xedc/0x1900
>                   setup_swap_extents+0x13c/0x4a8
>                   __arm64_sys_swapon+0xb20/0x1490
>                   invoke_syscall+0x74/0x188
>                   do_el0_svc+0x10c/0x198
>                   el0_svc+0x64/0x260
>                   el0t_64_sync_handler+0x84/0x130
>                   el0t_64_sync+0x198/0x1a0
>           =20
> -> #2 (&ei->i_mmap_lock){++++}-{4:4}:
>                   down_read+0x68/0x320
>                   btrfs_page_mkwrite+0x414/0x1088
>                   do_page_mkwrite+0x124/0x258
>                   do_wp_page+0x52c/0x3270
>                   handle_mm_fault+0xa24/0x1bb0
>                   do_page_fault+0x2ac/0xa90
>                   do_mem_abort+0x78/0x198
>                   el0_da+0x78/0x258
>                   el0t_64_sync_handler+0x90/0x130
>                   el0t_64_sync+0x198/0x1a0
>           =20
> -> #1 (sb_pagefaults){.+.+}-{0:0}:
>                   btrfs_page_mkwrite+0x200/0x1088
>                   do_page_mkwrite+0x124/0x258
>                   do_pte_missing+0xa7c/0x2160
>                   handle_mm_fault+0x9c8/0x1bb0
>                   do_page_fault+0x35c/0xa90
>                   do_translation_fault+0x78/0x90
>                   do_mem_abort+0x78/0x198
>                   el0_da+0x78/0x258
>                   el0t_64_sync_handler+0x90/0x130
>                   el0t_64_sync+0x198/0x1a0
>           =20
> -> #0 (&mm->mmap_lock){++++}-{4:4}:
>                   __lock_acquire+0x1b58/0x3418
>                   lock_acquire+0x160/0x3a0
>                   down_read_killable+0x70/0x358
>                   mmap_read_lock_killable+0x20/0xe8
>                   lock_mm_and_find_vma+0x1e4/0x1f0
>                   do_page_fault+0x314/0xa90
>                   do_translation_fault+0x78/0x90
>                   do_mem_abort+0x78/0x198
>                   el1_abort+0x50/0x78
>                   el1h_64_sync_handler+0x50/0x100
>                   el1h_64_sync+0x6c/0x70
>                   filldir64+0x228/0x500
>                   kernfs_fop_readdir+0x444/0x720
>                   iterate_dir+0x1f4/0x370
>                   __arm64_sys_getdents64+0xc0/0x1e0
>                   invoke_syscall+0x74/0x188
>                   do_el0_svc+0x10c/0x198
>                   el0_svc+0x64/0x260
>                   el0t_64_sync_handler+0x84/0x130
>                   el0t_64_sync+0x198/0x1a0
>           =20
> other info that might help us debug this:
>=20
>            Chain exists of:
>   &mm->mmap_lock --> &ei->i_mmap_lock --> &root->kernfs_rwsem
>=20
>             Possible unsafe locking scenario:
>=20
>                   CPU0                    CPU1
>                   ----                    ----
>              rlock(&root->kernfs_rwsem);
>                                           lock(&ei->i_mmap_lock);
>                                           lock(&root->kernfs_rwsem);
>              rlock(&mm->mmap_lock);
>           =20
>  *** DEADLOCK ***
>=20
>            locks held by stress-ng-sysfs/419983: 3, last CPU#4:
>             #0: ffff0003919b1b30 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_=
pos+0x1b0/0x240
>             #1: ffff0000bfa8d200 (&type->i_mutex_dir_key#3){++++}-{4:4}, =
at: iterate_dir+0x164/0x370
>             #2: ffff0000a1747180 (&root->kernfs_rwsem){++++}-{4:4}, at: k=
ernfs_fop_readdir+0x1e8/0x720

This looks like a valid issue in btrfs.

>           =20
> stack backtrace:
>            CPU: 4 UID: 0 PID: 419983 Comm: stress-ng-sysfs Kdump: loaded =
Tainted: G        W   E       7.2.0-rc2-next-20260710upstream-baseline #19 =
PREEMPT(full)=20
>            Tainted: [W]=3DWARN, [E]=3DUNSIGNED_MODULE
>            Call trace:
>             show_stack+0x24/0x38 (C)
>             __dump_stack+0x28/0x38
>             dump_stack_lvl+0x74/0xa8
>             dump_stack+0x18/0x24
>             print_circular_bug+0x328/0x330
>             check_noncircular+0x17c/0x1a0
>             __lock_acquire+0x1b58/0x3418
>             lock_acquire+0x160/0x3a0
>             down_read_killable+0x70/0x358
>             mmap_read_lock_killable+0x20/0xe8
>             lock_mm_and_find_vma+0x1e4/0x1f0
>             do_page_fault+0x314/0xa90
>             do_translation_fault+0x78/0x90
>             do_mem_abort+0x78/0x198
>             el1_abort+0x50/0x78
>             el1h_64_sync_handler+0x50/0x100
>             el1h_64_sync+0x6c/0x70
>             filldir64+0x228/0x500 (P)
>             kernfs_fop_readdir+0x444/0x720
>             iterate_dir+0x1f4/0x370
>             __arm64_sys_getdents64+0xc0/0x1e0
>             invoke_syscall+0x74/0x188
>             do_el0_svc+0x10c/0x198
>             el0_svc+0x64/0x260
>             el0t_64_sync_handler+0x84/0x130
>             el0t_64_sync+0x198/0x1a0
>  01:37:47  capability: warning: `stress-ng-cap' uses deprecated v2 capabi=
lities in a way that may be insecure
>=20
> > Your
> > trace comment leads me to believe there is a lot of these triggering
> > with CONFIG_RCU_STRICT_GRACE_PERIOD, is that correct?
>=20
> I don't think this is set in the kernel I am seeing it Why do you think
> CONFIG_RCU_STRICT_GRACE_PERIOD is set?

I added more debug for strict grace period that is not being triggered,
I was wondering if this was contributing to the log mess, but I don't
think it is.

What is happening is that I have an issue that is flooding your logs
once the lock enters the invalid state.  lock_is_held() is returning -1
(unknown state) after lockdep sets debug_locks to 0.  This happens once
lockdep detects the valid deadlock state you have in your logs.

The logs are flooded because the reading of the sequence counter will
return UINT_MAX (return ~0), which then does not match the recorded
sequence counter.  This will happen rather frequently.

I have a working fix to disable the checking on seq =3D=3D ~0, since it's
not possible to hit that value even when wrapping around (seqence
counter isn't 32bits in total).

If you could test the attached patch to see if it stops your log
flooding, I would appreciate it.

Unfortunately, the deadlock does look to be another issue in an area I
am not familiar with.

Thanks,
Liam


--6r6evq5qs3vswy6a
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-maple_tree-Stop-flooding-logs-when-debug_locks-is-se.patch"

From c291e6d64840ae5dc6a2166bc0de8b82a6906705 Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Date: Mon, 20 Jul 2026 17:30:38 -0400
Subject: [PATCH] maple_tree: Stop flooding logs when debug_locks is set to
 zero

When lockdep detects an issue, it sets debug_locks to 0 disabling
further reports.  The newly added maple tree sequence counting on locks
to detect errors is not taking this nor the fact that lock_is_held() can
return -1 (unknown state) into account.  The resulting action is a flood
of logging of not matching sequence numbers being reported on failure.

__lock_sequnece() will return u32 ~0 when debug_locks is zero, and the
real sequnece count cannot return such a high value as it is less than
32bits.

By always updating the sequence number, regardless of lock state and by
ignoring ~0 value in the sequence number will avoid ever printing a
WARN_ON when this condition is hit.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 06cc05b79fbdc..2280be62235ca 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1173,6 +1173,8 @@ static void mas_lock_check(struct ma_state *mas)
 {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map *map;
+	u32 seq;
+
 	if (!mas_is_active(mas))
 		return;
 
@@ -1184,8 +1186,12 @@ static void mas_lock_check(struct ma_state *mas)
 #endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
 
 	map = mas_lockdep_map(mas);
-	if (map && lock_is_held(map))
-		WARN_ON_ONCE(mas->ld_seq != lock_sequence(map));
+	if (!map)
+		return;
+
+	seq = lock_sequence(map);
+	if (seq != UINT_MAX && mas->ld_seq != UINT_MAX)
+		WARN_ON_ONCE(mas->ld_seq != seq);
 #endif /* CONFIG_LOCKDEP */
 
 }
@@ -1203,8 +1209,8 @@ static void mas_init_lock_check(struct ma_state *mas)
 #endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
 
 	map = mas_lockdep_map(mas);
-	if (map && lock_is_held(map))
-		mas->ld_seq = lock_sequence(mas_lockdep_map(mas));
+	if (map) /* Update regardless of lock state */
+		mas->ld_seq = lock_sequence(map);
 #endif /* CONFIG_LOCKDEP */
 
 }
-- 
2.47.3


--6r6evq5qs3vswy6a--

