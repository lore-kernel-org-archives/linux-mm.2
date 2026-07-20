Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 676DDC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E006B009D; Mon, 20 Jul 2026 12:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E526B009E; Mon, 20 Jul 2026 12:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE936B009F; Mon, 20 Jul 2026 12:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE3896B009D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:05:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25116140203
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:05:10 +0000 (UTC)
X-FDA: 85009629180.26.5845DC4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3279F1C0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:05:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=B7RK5LHQ;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784563508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPrSCcboo6QNVYmxgmeAVdHNL9zuwh9fX91xHhB4SW4=;
	b=FxzWMaUrrt7UYQZ386Lld8c2bdsCSqVQKXbjm56FZWmotfD/12iQYQqFK+MThtzJ0f+xEZ
	/wZcljPqmFsAoZsoftfJyD+Kk1efi5ZmdrS1hjRxJ498nfc4nwDlWioTDP6RkvKVGtI2ZC
	FOzMr/eV+n/XT8VXoMBFWmxdOY5EemU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784563508;
	b=l8ioNz59rNVPGtRtXv3D2XF5usQy6jPEaVZfj/hI0VQzywdKsYl5PvZY2pjZ2ohDJCyk+v
	BmLVQMA5+aY7miJ2bRpSumQnR+tnV2ox6RbiE5vOdPbZ95Y9per0enm5sOzd7OX19va+mD
	x/YUCL7NylFVyWh38E+7rh1W5jjfMUg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=B7RK5LHQ;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=mPrSCcboo6QNVYmxgmeAVdHNL9zuwh9fX91xHhB4SW4=; b=B7RK5LHQ5PkiTZ/V8+0NehtGUn
	/Mmx5kHqJOPwm/o//qJf3CwzzqqMxD+T87m5steyMNmp6yfkGUaXgMQr08/BNJSqoyG8Y0mTExvbh
	sjSfIC5J1APVZiUs5ZtZsEvWYNSw8QLDjLnugfkCyaxtMvuAJJlJ3p9OkmofMQaaN9ak6YkSxRz2k
	Ytqc64i2W7YAWY4/MHYfu2vcJXkepscDDxiXZbfpZ8lwpgV7TVvinfDlFjFDk0tlRwUeQdClVXMJj
	nlXsmSeoBlJUQefrCnk8iG3y3p/+xmcrfqD2T7WpFbDh/OwMW4+ecSIt0FZB5sVNNmTW/nEfq1TJ1
	TwLpcMdA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wlqUJ-001YQ9-28;
	Mon, 20 Jul 2026 16:05:04 +0000
Date: Mon, 20 Jul 2026 09:04:59 -0700
From: Breno Leitao <leitao@debian.org>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH v2 03/19] maple_tree: Add write lock checking with
 lockdep sequence numbers
Message-ID: <al5F7sT-39J_wbbR@gmail.com>
References: <20260630190843.3563858-1-liam@infradead.org>
 <20260630190843.3563858-4-liam@infradead.org>
 <ak5v9UDuieA-dNUh@gmail.com>
 <dzp5qpqjzc3j2jwnamgbv7j2blqcbp6xq5jnwvkm6hzx6fbjni@2vom3uipdkuo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <dzp5qpqjzc3j2jwnamgbv7j2blqcbp6xq5jnwvkm6hzx6fbjni@2vom3uipdkuo>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3279F1C0004
X-Stat-Signature: 5hguzzhg7g4nrh5z8qyotab6f3yoynsu
X-Rspam-User: 
X-HE-Tag: 1784563508-281340
X-HE-Meta: U2FsdGVkX181sOQstnOR43c9ZJjS2obXpD4jHryaHBGiBixyUk6WM9ywi7Ii8Qnkj4Cws45pqeFAOzTrtgDllWs8MsHmHRisMJ60AWGR4f9nH4jO504v3jaGn1oZNSZ6FmNv3ySg/SxzjR2kxTPT89nB2/lDw/af02JVVpMZvYfExM/BTg4CBlZ7ANjZAZ/6UkGutT9LRBgkHMs7sBwM/R6GljWM1kw/6/nM8z6wTauDxbW5uoLrzW57KIYiuN1OoOLEgOO/BFRoSULRv4AWPYP9lwrxJ7kGDHqdbNL5kn5eULT7aa19j4+p1FqzH7PlvL6KRB26wlQXLBMNasFZ/WvN0iUKToKB6IDPurMt9ww4QunBNzHqZsxWcDaIBleQVTihVXZ/lQnK66YjwXVT+JbUE0v20nxuCrdlEwP/1paIhOva8Lz2mesQI8ekYPr87Yu9mnC5/pg+qIWAQUPCFpAPYkO4v3y16BaR5UEkEqOg/WiiTqVPj16UhQ6Z1/DCImtskqKJBM+9/OqJneL3FWROnL9YLPYWo7DH0qCBpy0p1UUnK7USMmZP48rEgGUUgTiJSTkrmb4JYt3RfN5yfvz7PmghcH1SMn+4hx9f4B64FUS6JT/9yk9wnsOp2o5/4GNRQW7f/qP9Y/+xugMIAnJ9ZdmNKhHCEkKXBYAkf/10nQ3P0cdSmvzogCrce/1czvt0q+4nMlOoPkX2HJvCCrpFQnIaNwKPujdi3JBf7M3jxtNvaJMYjFB7H6GXshpynidU3QkuwIycH7a1VLpVP8vW3XxxPO/zS06SuK4FjoIshjdQ1cDYL2HL/lzdnbRyK7h49Tq2pKOAUJoZR2KQ6n6ioME7xhlxvNjZl5R24SqXjsrv2+A13z8E4RLbY6TdPlZ1eZ33/gcUxzAfFVSnBbke5stI6JnLHOplRmANz+Dk491P/56h8ecQVTNtBUrCFlMBZxSs+8VatY9L6tX
 mcAgs66F
 a0rNqcexcDtgDW+94oKnqLfNGc7IeRwKkV6yZESAkVCbJ3oqklyVfOx4aPfVCxRck8cMTHHLJqVxumUfICkVrs1u5huGiyfPyJ+qWtf2VSgddzTDipF+wnhQBsg/aZaLagh0WPslYOryB0S2ecAFCChvR16RDBAzN6AeAODCIUlXBB3phuXxuFANB6YHV0NRDmBO4fKkWPls/PAJdLPqz3b/z57+Tdo7FCSPv2j0oVVseyT1oEIgRPIvq0gijHf2wFphuYV0yhnMlKu+gZIsloGO2NupTpUOYqPzNBw3Oq42tcyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 10:03:51AM -0400, Liam R. Howlett (Oracle) wrote:
> On 26/07/08 08:44AM, Breno Leitao wrote:
> > Hello Liam,
>=20
> Hello!
>=20
> >=20
> > On Tue, Jun 30, 2026 at 03:08:27PM -0400, Liam R. Howlett (Oracle) wrot=
e:
> > > +#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
> > >  	if (!mt_locked(mas->tree)) {
> > >  		if (mt_in_rcu(mas->tree))
> > >  			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
> >=20
> > Testing next-20260706 on arm64 under a stress-ng + fork/exit/mprotect w=
orkload,
> > I'm hitting the new maple_tree write-lock sequence check:
> >=20
> >     WARNING: lib/maple_tree.c:1188 at mas_store_prealloc+0x2a8/0xac0
>=20
> No, this is not expected and I didn't know about it.  Does it still
> happen in next?  I'll start looking at this while I wait to hear from
> your side.

Yes, I see it on my everyday's test.

>=20
> That's very odd.  Does anything show up with a lockdep build?

Yes, but not sure if this is related. This is happening twice, thus, the
messy kernel message

 01:37:12  perf: interrupt took too long (3127 > 3126), lowering kernel.per=
f_event_max_sample_rate to 63000
 01:37:38 =20
           ------------[ cut here ]------------
           WARNING: lib/maple_tree.c:1188 at mas_find+0x620/0x810, CPU#45: =
stress-ng-sysfs/419993  =1B[36m[warn]=1B[0m
           Modules linked in: md4(E) vhost_vsock(E) vfio_iommu_type1(E) vfi=
o(E) act_gact(E) tcp_diag(E) inet_diag(E)
           ------------[ cut here ]------------
            cls_bpf(E)
            evdev(E) ipmi_devintf(E) ipmi_msghandler(E) spi_nor(E) button(E=
) sch_fq_codel(E) vhost_net(E) tap(E) tun(E)
           WARNING: lib/maple_tree.c:1188 at mas_store+0x2a8/0x678, CPU#7: =
stress-ng-sysfs/419987  =1B[36m[warn]=1B[0m
            mpls_iptunnel(E) vhost(E) tls(E)
           Modules linked in:
            vhost_iotlb(E) mpls_gso(E)
            md4(E)
            mpls_router(E)
            vhost_vsock(E)
            loop(E)
            vfio_iommu_type1(E)
            fou(E)
            vfio(E)
            efivarfs(E)
            act_gact(E)
            autofs4(E)
            tcp_diag(E)
            [last unloaded: test_bpf(E)]
            inet_diag(E)
          =20
            cls_bpf(E) evdev(E) ipmi_devintf(E) ipmi_msghandler(E) spi_nor(=
E) button(E) sch_fq_codel(E) vhost_net(E)
           CPU: 45 UID: 0 PID: 419993 Comm: stress-ng-sysfs Kdump: loaded T=
ainted: G            E       7.2.0-rc2-next-20260710upstream-baseline #19 P=
REEMPT(full)=20
            tap(E) tun(E) mpls_iptunnel(E)
           Tainted: [E]=3DUNSIGNED_MODULE
            vhost(E)
            tls(E)
            vhost_iotlb(E) mpls_gso(E) mpls_router(E)
           pstate: 03401009 (nzcv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=3D--)
            loop(E) fou(E)
           pc : mas_find+0x620/0x810
            efivarfs(E) autofs4(E) [last unloaded: test_bpf(E)]
           lr : mas_find+0x1c8/0x810
          =20
           sp : ffff80011fa579e0
           x29: ffff80011fa579e0
           CPU: 7 UID: 0 PID: 419987 Comm: stress-ng-sysfs Kdump: loaded Ta=
inted: G            E       7.2.0-rc2-next-20260710upstream-baseline #19 PR=
EEMPT(full)=20
            x28: 1ffff00023f4af5d x27: 1ffff00023f4af62
           Tainted: [E]=3DUNSIGNED_MODULE
           x26: ffff0000b65379a0
            x25: 00000000000000e7 x24: 1ffff00023f4af6f
           pstate: 03401009 (nzcv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=3D--)
          =20
           x23: dfff800000000000 x22: ffff00011aa90e78
           pc : mas_store+0x2a8/0x678
            x21: fffffffffffffffe
           x20: ffff80011fa57b30
           lr : mas_store+0x2a0/0x678
            x19: ffff80011fa57b78
           sp : ffff80011e9c7810
            x18: 0000000000000000
           x29: ffff80011e9c7890
           x17: ffff800082ef24c4
            x28: 1fffe000507cf8f2
            x16: 0000000000000068 x15: 0000000000000001
            x27: dfff800000000000
          =20
          =20
           x14: 1fffe001310d8da4
           x26: ffff000283e7c790
            x13: 0000000000000001
            x25: 0000000000000097 x24: 1ffff00023d38f40
            x12: 0000aaf4db60a000
          =20
           x11: ffff00015fb58bf0
           x23: dfff800000000000 x22: ffff0009dd07f178
            x10: 0000aaf4db60a000
            x21: ffff000283e7c780
            x9 : 0000000000000300
          =20
          =20
           x20: ffff80011e9c7a00
           x8 : 0000000000000000
            x19: ffff80011e9c79b8 x18: 0000000000000118
            x7 : ffff8000808bcf34
          =20
            x6 : 0000000000000000
           x17: ffff800082ef24c4
          =20
           x5 : 0000000000000000
            x16: 0000000000000068
            x4 : 0000000000000001
            x15: 000000000000000a
            x3 : 0000aaf4db60a000
          =20
           x14: 1ffff00023d38f07
          =20
            x13: 0000000000000000
           x2 : 0000000000000000
            x12: 0000000000000000
            x1 : 00000000ffffffff
          =20
            x0 : 00000000ffffffff
           x11: ffff700023d38f11
          =20
            x10: dfff800000000000
           Call trace:
            x9 : 0000000000000300
           x8 : 0000000000000000
            mas_find+0x620/0x810 (P)
            x7 : 0000000000000000 x6 : ffff8000808bf46c
           x5 : 0000000000000000 x4 : 0000000000000008 x3 : 0000000000000000
            unmap_vmas+0x180/0x320
           x2 : 0000000000000008 x1 : 00000000ffffffff x0 : 00000000ffffffff
           Call trace:
            exit_mmap+0x134/0x8f8
            mas_store+0x2a8/0x678 (P)
            __mmput+0xb8/0x340
            dup_mmap+0x698/0x1350
            mmput+0x60/0x98
            copy_mm+0xe4/0x3c8
            do_exit+0x594/0x1a28
            do_group_exit+0x180/0x220
            copy_process+0x12f0/0x31e8
            __arm64_sys_exit_group+0x50/0x58
            kernel_clone+0x14c/0x768
            __arm64_sys_clone+0x100/0x140
            invoke_syscall+0x74/0x188
            do_el0_svc+0x10c/0x198
            invoke_syscall+0x74/0x188
            do_el0_svc+0x10c/0x198
            el0_svc+0x64/0x260
            el0_svc+0x64/0x260
            el0t_64_sync_handler+0x84/0x130
            el0t_64_sync_handler+0x84/0x130
            el0t_64_sync+0x198/0x1a0
            el0t_64_sync+0x198/0x1a0
           irq event stamp: 251
           irq event stamp: 265
           hardirqs last  enabled at (251): [<ffff800080911648>] seqcount_l=
ockdep_reader_access+0x68/0xc8
           hardirqs last  enabled at (265): [<ffff800082da75ec>] _raw_spin_=
unlock_irqrestore+0x44/0xb0
           hardirqs last disabled at (250): [<ffff80008091160c>] seqcount_l=
ockdep_reader_access+0x2c/0xc8
           hardirqs last disabled at (264): [<ffff800082da73c0>] _raw_spin_=
lock_irqsave+0x38/0x90
           softirqs last  enabled at (136): [<ffff80008011dfb4>] handle_sof=
tirqs+0xd8c/0xf08
           softirqs last disabled at (131): [<ffff8000800103d0>] __do_softi=
rq+0x20/0x2c
           softirqs last  enabled at (178): [<ffff800080092ed4>] fpsimd_sav=
e_and_flush_current_state+0xac/0x100
           ---[ end trace 0000000000000000 ]---
           softirqs last disabled at (176): [<ffff800080092e58>] fpsimd_sav=
e_and_flush_current_state+0x30/0x100
           ---[ end trace 0000000000000000 ]---
           =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
           WARNING: possible circular locking dependency detected  =1B[36m[=
lockdep]=1B[0m
           7.2.0-rc2-next-20260710upstream-baseline #19 Tainted: G        W=
   E     =20
           ------------------------------------------------------
           stress-ng-sysfs/419983 is trying to acquire lock:
           ffff000390315b78 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_loc=
k_killable+0x20/0xe8
          =20
but task is already holding lock:
           ffff0000a1747180 (&root->kernfs_rwsem){++++}-{4:4}, at: kernfs_f=
op_readdir+0x1e8/0x720
          =20
which lock already depends on the new lock.

          =20
the existing dependency chain (in reverse order) is:
          =20
-> #3 (&root->kernfs_rwsem){++++}-{4:4}:
                  down_read+0x68/0x320
                  kernfs_find_and_get_ns+0x3c/0xf8
                  sysfs_notify+0x90/0xd0
                  btrfs_exclop_finish+0x94/0xb8
                  btrfs_swap_activate+0xedc/0x1900
                  setup_swap_extents+0x13c/0x4a8
                  __arm64_sys_swapon+0xb20/0x1490
                  invoke_syscall+0x74/0x188
                  do_el0_svc+0x10c/0x198
                  el0_svc+0x64/0x260
                  el0t_64_sync_handler+0x84/0x130
                  el0t_64_sync+0x198/0x1a0
          =20
-> #2 (&ei->i_mmap_lock){++++}-{4:4}:
                  down_read+0x68/0x320
                  btrfs_page_mkwrite+0x414/0x1088
                  do_page_mkwrite+0x124/0x258
                  do_wp_page+0x52c/0x3270
                  handle_mm_fault+0xa24/0x1bb0
                  do_page_fault+0x2ac/0xa90
                  do_mem_abort+0x78/0x198
                  el0_da+0x78/0x258
                  el0t_64_sync_handler+0x90/0x130
                  el0t_64_sync+0x198/0x1a0
          =20
-> #1 (sb_pagefaults){.+.+}-{0:0}:
                  btrfs_page_mkwrite+0x200/0x1088
                  do_page_mkwrite+0x124/0x258
                  do_pte_missing+0xa7c/0x2160
                  handle_mm_fault+0x9c8/0x1bb0
                  do_page_fault+0x35c/0xa90
                  do_translation_fault+0x78/0x90
                  do_mem_abort+0x78/0x198
                  el0_da+0x78/0x258
                  el0t_64_sync_handler+0x90/0x130
                  el0t_64_sync+0x198/0x1a0
          =20
-> #0 (&mm->mmap_lock){++++}-{4:4}:
                  __lock_acquire+0x1b58/0x3418
                  lock_acquire+0x160/0x3a0
                  down_read_killable+0x70/0x358
                  mmap_read_lock_killable+0x20/0xe8
                  lock_mm_and_find_vma+0x1e4/0x1f0
                  do_page_fault+0x314/0xa90
                  do_translation_fault+0x78/0x90
                  do_mem_abort+0x78/0x198
                  el1_abort+0x50/0x78
                  el1h_64_sync_handler+0x50/0x100
                  el1h_64_sync+0x6c/0x70
                  filldir64+0x228/0x500
                  kernfs_fop_readdir+0x444/0x720
                  iterate_dir+0x1f4/0x370
                  __arm64_sys_getdents64+0xc0/0x1e0
                  invoke_syscall+0x74/0x188
                  do_el0_svc+0x10c/0x198
                  el0_svc+0x64/0x260
                  el0t_64_sync_handler+0x84/0x130
                  el0t_64_sync+0x198/0x1a0
          =20
other info that might help us debug this:

           Chain exists of:
  &mm->mmap_lock --> &ei->i_mmap_lock --> &root->kernfs_rwsem

            Possible unsafe locking scenario:

                  CPU0                    CPU1
                  ----                    ----
             rlock(&root->kernfs_rwsem);
                                          lock(&ei->i_mmap_lock);
                                          lock(&root->kernfs_rwsem);
             rlock(&mm->mmap_lock);
          =20
 *** DEADLOCK ***

           locks held by stress-ng-sysfs/419983: 3, last CPU#4:
            #0: ffff0003919b1b30 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_po=
s+0x1b0/0x240
            #1: ffff0000bfa8d200 (&type->i_mutex_dir_key#3){++++}-{4:4}, at=
: iterate_dir+0x164/0x370
            #2: ffff0000a1747180 (&root->kernfs_rwsem){++++}-{4:4}, at: ker=
nfs_fop_readdir+0x1e8/0x720
          =20
stack backtrace:
           CPU: 4 UID: 0 PID: 419983 Comm: stress-ng-sysfs Kdump: loaded Ta=
inted: G        W   E       7.2.0-rc2-next-20260710upstream-baseline #19 PR=
EEMPT(full)=20
           Tainted: [W]=3DWARN, [E]=3DUNSIGNED_MODULE
           Call trace:
            show_stack+0x24/0x38 (C)
            __dump_stack+0x28/0x38
            dump_stack_lvl+0x74/0xa8
            dump_stack+0x18/0x24
            print_circular_bug+0x328/0x330
            check_noncircular+0x17c/0x1a0
            __lock_acquire+0x1b58/0x3418
            lock_acquire+0x160/0x3a0
            down_read_killable+0x70/0x358
            mmap_read_lock_killable+0x20/0xe8
            lock_mm_and_find_vma+0x1e4/0x1f0
            do_page_fault+0x314/0xa90
            do_translation_fault+0x78/0x90
            do_mem_abort+0x78/0x198
            el1_abort+0x50/0x78
            el1h_64_sync_handler+0x50/0x100
            el1h_64_sync+0x6c/0x70
            filldir64+0x228/0x500 (P)
            kernfs_fop_readdir+0x444/0x720
            iterate_dir+0x1f4/0x370
            __arm64_sys_getdents64+0xc0/0x1e0
            invoke_syscall+0x74/0x188
            do_el0_svc+0x10c/0x198
            el0_svc+0x64/0x260
            el0t_64_sync_handler+0x84/0x130
            el0t_64_sync+0x198/0x1a0
 01:37:47  capability: warning: `stress-ng-cap' uses deprecated v2 capabili=
ties in a way that may be insecure

> Your
> trace comment leads me to believe there is a lot of these triggering
> with CONFIG_RCU_STRICT_GRACE_PERIOD, is that correct?

I don't think this is set in the kernel I am seeing it Why do you think
CONFIG_RCU_STRICT_GRACE_PERIOD is set?

Thanks,
--breno

