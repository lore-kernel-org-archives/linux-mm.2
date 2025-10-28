Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F78CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C511E80178; Tue, 28 Oct 2025 12:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C271D8013F; Tue, 28 Oct 2025 12:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17ED80178; Tue, 28 Oct 2025 12:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 998608013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:20:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4ADD088ADA
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:20:02 +0000 (UTC)
X-FDA: 84048034644.09.7C6E145
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6AF6320014
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:20:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t9ZEsbjw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761668400; a=rsa-sha256;
	cv=none;
	b=o2QaCFfM/J2oIPx3eNe/Bds3C+Bt38xp6JlU4KNDXA780wGKF8AHLNdv0zvo8Az/9s4ZwJ
	dAez6OGVi37ISz2FnuxzLp5vXFa6J8SDoKRt3Qr+d3KlfL5CO63n5pDwUAHEyWwwFvIFop
	wI9NEbQWFKcOub3v9Kvi9um/6H+gLhE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t9ZEsbjw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761668400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3NYMTtUtXnRnu/bVYpO+gcWtkC5YG9W5d6TUN2aJ6U=;
	b=fRhaEnn0pIuftt4TLOCJUqURRTwdmqS00wkXX0dma8n9ZUa+umX4/p+iS8Em95zfhrBKoG
	loy5r0NbZbgYMZgk6OemZRiFcX17lzW9VkvBSYF9+q+i6r4lOZnGT574SY06Jze744bOFw
	pbWxMzvFwpELZT3SpsC7Rxa0We5CY8c=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso267891cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761668399; x=1762273199; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3NYMTtUtXnRnu/bVYpO+gcWtkC5YG9W5d6TUN2aJ6U=;
        b=t9ZEsbjwzhN4dKJwMscD20UlO7NrV7zOT1g5ZUF1s3KHczw+PqflzTYclLfwnXwgbD
         zip0/JM/5eNghnhTgN7TxASu7hxJBP+eMia/BAoFfe5iML6+y1ItSCx9EfxgjQc+WqQ6
         R3lnXaZQod0Ucc/s333KNTZdL6prikq8KlCixa2hD9NuvTI45/2FYP4BiLFxmb6X3gSk
         PKmT21n7NIgqHoMDJxt1Gp54njIuovxYwrxMu938tznCnQxcOlyiOBAUJTcG8PkZaCK0
         SQNEWTZIrfPXPnglTifLqyOM4NTqCfjyjxhXtTfegzt3BpkkNZq6WtrehepA2DH8MfBp
         eSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761668399; x=1762273199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3NYMTtUtXnRnu/bVYpO+gcWtkC5YG9W5d6TUN2aJ6U=;
        b=aGZvyHGM7CETGSGWs1PvRcRGAB4xU5mmzWzZd/N3hD+TbQUuctWGJr8DqLniD/Sncw
         NdBywoMkiknLxSsP0VXpjiB2t7utmNgk3FhdtSLmTyPzCbrTycpYGtxrr6hlkIhGKEDZ
         6S0YXESgdyVeR5CV51cQ4JZ5k7KhmdvMP0Nv+A1WS+9iRKaSfZTckYTHxqTeqBk/89m6
         v1USqJTBpjYOANV6/1evBOSF2wSQiEaAKYQGJcsgjL6ccGEB+iSsJx3ZdYHuwZsPdEJQ
         WC2evbIWJEwmxjQV9nZXIzb5e7bn2sz0HZ3Msy0SC2aRab8Pjauc/T0iPjxdw1T62vP7
         GGxQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2i6TfNdtSdAmakVBSMhDrC291/5lfuW9EtfpeHetNFguHX/PoAAi+qpnxXhH4SBkr+1l18KEaKw==@kvack.org
X-Gm-Message-State: AOJu0YyrBADtT4p+UEy6VZzsf/cM45qeOLR6TnVHXbcY8dmfItI9c7Bs
	udiUa02iAXv0a5//tVVz7e+dP0yZk56dq7n42Ze+m7swlAvC9fO5FXukwkUyEW5z+y+zwPAqz+E
	OQAy4cZHdioqUduxgn9OTjdanuVkybJOY2M6POx1X
X-Gm-Gg: ASbGncv1rmNK8Dghf1Kp8bdw0UTPaSSt5K9c424kGvRYjyxb5gCRymG84YV1VZN4EQJ
	UISoN/mbdFpqjE+dW2ezxFdwJDe3sDg3m4XNSLQL8Opql9VyeRZ+4GtO/UmtQC0WVKyCkgmELes
	ZITYo3USgfhKdNspl1Sk9oepD1TqoYL+Md7cEot3tKqpfE4fxNbC/FSPRJ6XNxQWeh1DjcYJhPd
	oua0yMtJPlydMQ1x00GD06pOtW0B19F3jF4DeWy4D88IvO+2gL7v1qszAoCaZye+cdVdPuc69CJ
	7COdETjGC8JO0NI0JBT7DfdJ+A==
X-Google-Smtp-Source: AGHT+IHf+o2pE67Z+7JlVXiqy4RUTGrA7p/D/mdKHAJHeSQSlz11no7OpeEV+9/vsdJFIhaKa+xKjobHmPb5oh1A3/A=
X-Received: by 2002:a05:622a:145:b0:4eb:75cb:a267 with SMTP id
 d75a77b69052e-4ed08f87205mr8681501cf.12.1761668398926; Tue, 28 Oct 2025
 09:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20251027085214.184672-1-hao.ge@linux.dev> <CAJuCfpF+0ok85A1ZhbptSzrB-X6CUj=TMj9ZvwzjV1tO5PqFbA@mail.gmail.com>
 <d1456749-46c3-463f-bc28-f465b8ce6ff9@linux.dev>
In-Reply-To: <d1456749-46c3-463f-bc28-f465b8ce6ff9@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 09:19:47 -0700
X-Gm-Features: AWmQ_bmziyhE35dZS-EFMo6t5xA8THV-QN8lMIV3Y9oWsKJhVXJbDT_X1ibZVWQ
Message-ID: <CAJuCfpFJHE-VAOgKfoXJA+V-okvgQt_iEEUdvd4ZCaARFiWExA@mail.gmail.com>
Subject: Re: [PATCH] codetag: debug: Handle existing CODETAG_EMPTY in
 mark_objexts_empty for slabobj_ext
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dfkpb95uugyryj78ns41mntgs44qxtex
X-Rspamd-Queue-Id: 6AF6320014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761668400-772889
X-HE-Meta: U2FsdGVkX1/EDEa/sR10aeEB5IjdSD+S90U4EjOfBBFb2rCYD7Xo2l/IH7IgxlyWF3F7jXJgtspqDiiQEdGV37hYw4wn173o8a9h/4L3zIzZJmorLTtVLOk6wy9VkoLYlbbouXXM4MKFnhCf79vvE3T1QzZXfhvK2jIWrb8bbl9er7vTjIhxhQFWSkPIgJc15FpUnBt/lQHmy78nX+uzaA1Cc6Ektn3YSvLC+aIA2pMHoonU+/IS3B6boYJ6Ql7hm11NGTlCKTq0yJ4Qzt8KNfmneevq4BBPyQ7EDKcQiPnTtuJ9WQbZPyhMhWIl6AcGJjLUALqLHE+ec6kTeS4F5Ed7yDqJjAT5UU6pKAQIaa412pvfOl/5MFL3xKdkarudf/rxLcwTdWnTO3DGzvCXyGhO2ulGMHJnZiywUtGSLLu/+B/+eu3DppV9hsZeeLFHF+reESX44E0q04S8rMMwTlq1LRgcvT1E3/45YEW1aMGd+3giMjKe7FFysDGvTMSHaB+M+mJJKgnQJ24uDO7bS4XcA7GPK8LKEWKty6ha/IObxlyDZ/Ov0lR6sKfWtz1DicZEs2P2KnpbTi20HpyX4v49r6CIyC1ezTRjYLcFRFEh8tb5/01nJLK7BvF3139ZHXI9NjlZ0VZ00mc3eoLc7LoxV1Y2UcRCuxoFFLgED6XURUnxkI2PIya1ppZYv5mZdAeRyH6znr0OTyc1F49Cj7cMaWrkUp8UBpXPxuEGKRx905IfSb0WLOOvT52HBWOGU76oIFzZCuVJyLgqWqTKmYImhyva/ZqGf49eCVv0DuYP5tK3SEYj7d6pUFjlF5EnFvnKPwt65R/RMxZpfZGVhkJUXxvRDr3mLSXmxURBV8UoCVR34IjjIAcm/jf+wjMaR+fPPRO+VUUtpqVEzEUi2D1iw8h5I7ZDBShjkfzoY3mIpjkblwEgchZaM8QFLrb+pILBeJDKxTBpk7CeYgn
 +0bcTNTz
 v4h/K+fJOlMVvjV4QfVATA4RLWW9AeH+ZcBuF11VFSk3Voo1A6KprMWM7BpbmkjfwR6AlnAAHn5zDIEE3oH46OZspRKxl7+F4uweveQQ4ZMVW+OMy/oSAGaRPRp08pSkpauwopwYR9EWNyc5EMOriHldm5uqG3Q+mHd0N1iKjBQxewrUnRFyha+c9vPrQne63CRVC5/ohOZUgmAd2ONoVoz/QuNM1Ztn6V/Z/J0GT7DZmeHXK394Y5tvMZEF362QSiQFKNjyil7Pd6AsI/cvXiniFNTBjSwiGXWKbD+B/qUpIi5Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 6:31=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> On 2025/10/28 03:44, Suren Baghdasaryan wrote:
> > On Mon, Oct 27, 2025 at 1:53=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote=
:
> >> From: Hao Ge <gehao@kylinos.cn>
> >>
> >> Even though obj_exts was created with the __GFP_NO_OBJ_EXT flag,
> >> objects in the same slab may have their extensions allocated via
> >> alloc_slab_obj_exts, and handle_failed_objexts_alloc may be called
> >> within alloc_slab_obj_exts to set their codetag to CODETAG_EMPTY.
> >>
> >> Therefore, both NULL and CODETAG_EMPTY are valid for the codetag of
> >> slabobj_ext, as we do not need to re-set it to CODETAG_EMPTY if it
> >> is already CODETAG_EMPTY. It also resolves the warning triggered when
> >> the codetag is CODETAG_EMPTY during slab freeing.
> > I'm not sure what scenario leads to handle_failed_objexts_alloc() and
> > mark_objexts_empty() being used against the same codetag reference.
> > Could you please explain the exact scenario you hit?
> >
> > handle_failed_objexts_alloc() assigns CODETAG_EMPTY to the elements of
> > the obj_exts vector while mark_objexts_empty() assigns CODETAG_EMPTY
> > to the obj_ext of the obj_exts vector itself. In what case do these
> > two calls operate on the same reference?
>
> This issue also occurred during our memory stress testing.
>
> I apologize for the incorrect description in my commit message:
>
> The possibility of its occurrence should be as follows:
>
> When a slab allocates a slabobj_ext, the slab to which this slabobj_ext
> belongs may have already allocated its own slabobj_ext
>
> and called handle_failed_objexts_alloc. That is to say, the codetag of
> this slabobj_ext has been set to CODETAG_EMPTY.

Ah, ok. Let's see if I understood this correctly. The slab from which
slabobj_ext objects are allocated (let's call it slabA) tries to
allocate its own slabobj_ext, fails, then succeeds and calls
handle_failed_objexts_alloc() which sets all elements of its
slabA->obj_exts[] to CODETAG_EMPTY. Then slabobj_ext object is
allocated from slabA with __GFP_NO_OBJ_EXT, therefore it leaves
slabA->obj_exts[obj_idx] intact and equal to CODETAG_EMPTY instead of
NULL. At this point, slabB->obj_exts points to an object in slabA.
When slabB is freed and free_slab_obj_exts() gets called to free
slabB->obj_exts, it detects that slabA->obj_exts[obj_idx] is not NULL
and generates this warning. In your callstack stack the freeing seems
to happen inside kmem_cache_alloc_noprof() and I think that's because
we lost the race and freeing the vector we allocated here:
https://elixir.bootlin.com/linux/v6.18-rc3/source/mm/slub.c#L2165 but
the scenario is pretty much the same as if we didn't lose the race.
The warning would happen later on I think, when we would be freeing
slabB->obj_exts. The key for reproducing this is to fail allocation
for a slab that is used to allocate slabobj_ext objects. Is my
understanding correct?

BTW, your fix seems fine to me, I just want to understand the scenario
so that we can explain it correctly.

>
> To quickly detect this WARN, I modified the code
> from:WARN_ON(slab_exts[offs].ref.ct) to WARN_ON(slab_exts[offs].ref.ct
> =3D=3D 1);
>
> We then obtained this message:
>
> [21630.898561] ------------[ cut here ]------------
> [21630.898596] kernel BUG at mm/slub.c:2050!
> [21630.898611] Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
> [21630.900372] Modules linked in: squashfs isofs vfio_iommu_type1
> vhost_vsock vfio vhost_net vmw_vsock_virtio_transport_common vhost tap
> vhost_iotlb iommufd vsock binfmt_misc nfsv3 nfs_acl nfs lockd grace
> netfs tls rds dns_resolver tun brd overlay ntfs3 exfat btrfs
> blake2b_generic xor xor_neon raid6_pq loop sctp ip6_udp_tunnel
> udp_tunnel nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
> nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> nf_tables rfkill ip_set sunrpc vfat fat joydev sg sch_fq_codel nfnetlink
> virtio_gpu sr_mod cdrom drm_client_lib virtio_dma_buf drm_shmem_helper
> drm_kms_helper drm ghash_ce backlight virtio_net virtio_blk virtio_scsi
> net_failover virtio_console failover virtio_mmio dm_mirror
> dm_region_hash dm_log dm_multipath dm_mod fuse i2c_dev virtio_pci
> virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring autofs4
> aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
> [21630.909177] CPU: 3 UID: 0 PID: 3787 Comm: kylin-process-m Kdump:
> loaded Tainted: G        W           6.18.0-rc1+ #74 PREEMPT(voluntary)
> [21630.910495] Tainted: [W]=3DWARN
> [21630.910867] Hardware name: QEMU KVM Virtual Machine, BIOS unknown
> 2/2/2022
> [21630.911625] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS
> BTYPE=3D--)
> [21630.912392] pc : __free_slab+0x228/0x250
> [21630.912868] lr : __free_slab+0x18c/0x250[21630.913334] sp :
> ffff8000a02f73e0
> [21630.913830] x29: ffff8000a02f73e0 x28: fffffdffc43fc800 x27:
> ffff0000c0011c40
> [21630.914677] x26: ffff0000c000cac0 x25: ffff00010fe5e5f0 x24:
> ffff000102199b40
> [21630.915469] x23: 0000000000000003 x22: 0000000000000003 x21:
> ffff0000c0011c40
> [21630.916259] x20: fffffdffc4086600 x19: fffffdffc43fc800 x18:
> 0000000000000000
> [21630.917048] x17: 0000000000000000 x16: 0000000000000000 x15:
> 0000000000000000
> [21630.917837] x14: 0000000000000000 x13: 0000000000000000 x12:
> ffff70001405ee66
> [21630.918640] x11: 1ffff0001405ee65 x10: ffff70001405ee65 x9 :
> ffff800080a295dc
> [21630.919442] x8 : ffff8000a02f7330 x7 : 0000000000000000 x6 :
> 0000000000003000
> [21630.920232] x5 : 0000000024924925 x4 : 0000000000000001 x3 :
> 0000000000000007
> [21630.921021] x2 : 0000000000001b40 x1 : 000000000000001f x0 :
> 0000000000000001
> [21630.921810] Call trace:
> [21630.922130]  __free_slab+0x228/0x250 (P)
> [21630.922669]  free_slab+0x38/0x118
> [21630.923079]  free_to_partial_list+0x1d4/0x340
> [21630.923591]  __slab_free+0x24c/0x348
> [21630.924024]  ___cache_free+0xf0/0x110
> [21630.924468]  qlist_free_all+0x78/0x130
> [21630.924922]  kasan_quarantine_reduce+0x114/0x148
> [21630.925525]  __kasan_slab_alloc+0x7c/0xb0
> [21630.926006]  kmem_cache_alloc_noprof+0x164/0x5c8
> [21630.926699]  __alloc_object+0x44/0x1f8
> [21630.927153]  __create_object+0x34/0xc8
> [21630.927604]  kmemleak_alloc+0xb8/0xd8
> [21630.928052]  kmem_cache_alloc_noprof+0x368/0x5c8
> [21630.928606]  getname_flags.part.0+0xa4/0x610
> [21630.929112]  getname_flags+0x80/0xd8
> [21630.929557]  vfs_fstatat+0xc8/0xe0
> [21630.929975]  __do_sys_newfstatat+0xa0/0x100
> [21630.930469]  __arm64_sys_newfstatat+0x90/0xd8
> [21630.931046]  invoke_syscall+0xd4/0x258
> [21630.931685]  el0_svc_common.constprop.0+0xb4/0x240
> [21630.932467]  do_el0_svc+0x48/0x68
> [21630.932972]  el0_svc+0x40/0xe0
> [21630.933472]  el0t_64_sync_handler+0xa0/0xe8
> [21630.934151]  el0t_64_sync+0x1ac/0x1b0
> [21630.934923] Code: aa1803e0 97ffef2b a9446bf9 17ffff9c (d4210000)
> [21630.936461] SMP: stopping secondary CPUs
> [21630.939550] Starting crashdump kernel...
> [21630.940108] Bye!
>
> >> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to =
mark failed slab_ext allocations")
> >> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> >> ---
> >>   mm/slub.c | 12 +++++++++++-
> >>   1 file changed, 11 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index d4367f25b20d..cda8f75b72e7 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2046,7 +2046,17 @@ static inline void mark_objexts_empty(struct sl=
abobj_ext *obj_exts)
> >>          if (slab_exts) {
> >>                  unsigned int offs =3D obj_to_index(obj_exts_slab->sla=
b_cache,
> >>                                                   obj_exts_slab, obj_e=
xts);
> >> -               /* codetag should be NULL */
> >> +
> >> +               /*
> >> +                * codetag should be either NULL or CODETAG_EMPTY.
> >> +                * When the same slab calls handle_failed_objexts_allo=
c,
> >> +                * it will set us to CODETAG_EMPTY.
> >> +                *
> >> +                * If codetag is already CODETAG_EMPTY, no action is n=
eeded here.
> >> +                */
> >> +               if (unlikely(is_codetag_empty(&slab_exts[offs].ref)))
> >> +                       return;
> >> +
> >>                  WARN_ON(slab_exts[offs].ref.ct);
> >>                  set_codetag_empty(&slab_exts[offs].ref);
> >>          }
> >> --
> >> 2.25.1
> >>

