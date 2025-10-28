Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6386DCCF9EA
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 22:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BF38E0199; Tue, 28 Oct 2025 18:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C538E0015; Tue, 28 Oct 2025 18:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B7C8E0199; Tue, 28 Oct 2025 18:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECB88E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:53:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE89D1A04C5
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:53:00 +0000 (UTC)
X-FDA: 84049024920.11.F007DDD
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1AFDFC0002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:52:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IM5+d2Lp;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761691979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XeRHaWxCuwv7kpg1GFSiaajJwh/OD+VbnZnjgtpqBtg=;
	b=4twqXpSZD6qxjH9zzY7eLhbzrqdTjwOeAZLT5ZxVcPed+wrXqg5SeMWtahl8Drf4Tw2rfF
	kmg5o9y2BXhBexBLxFpQzvM7BcDtfIcLc/8A7pEZcIq9wCkP2E7qBo0szsrJ/UoerLOVJ0
	HRxyqseJRYO3Z8Cgi6iqb9o+wW9lNi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761691979; a=rsa-sha256;
	cv=none;
	b=uKdmTkJaeufNn+8fW70SU84GsZQp8uj4dSOml1cI7pRpjty5DsbiRDdbXC+nXi/yBgzkCc
	ztCTOB9m5FmMrbSCURh9eqpl8vAlRvTkKBVof4HBiokKfldw84+Kr5CggRtZRDIS3RrWJL
	OGXald7AVXT5SQIfgKwMLPGqGlzFDMQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IM5+d2Lp;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4eccff716f4so138491cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761691978; x=1762296778; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XeRHaWxCuwv7kpg1GFSiaajJwh/OD+VbnZnjgtpqBtg=;
        b=IM5+d2Lp4+j1l/p/yxGRQaLbXeQ/WyY+a6uwVWYU7ffkx/xmEbBI6yxCsq+qNV0Dv2
         hwpYZd8ywQMLLK3kOChemtA7ZN3zTdrMm2dzBMR3+nuP1ujEo/8HHlpPx+CDPfW2JD+Z
         j5+LU7ffbIU7NRIV3Ee4M6xSD62JcYk+Bcj/BzpTWX9eRMyPg2QLS+p4t+nfsI64fM8P
         0Fu+TtfVGmpHxwObibEFoHd+RXCrWP/vfrUe6zAEGXOD9iGm0VRoJJJO9XtYluhLq3eC
         sxuM83HLvPkbJW6Snh3/apH89+I35Y4QHMNUGZnRQvyOC/DmP1Ex+wFPWd++AiLOg91H
         RJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761691978; x=1762296778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XeRHaWxCuwv7kpg1GFSiaajJwh/OD+VbnZnjgtpqBtg=;
        b=j9olDm8YqeDUJD6ZctNL5PHFmz6UQ7m51k0H2Rnc6xfVeT2yPzaTPW5xCUGop4t0I0
         Xf0De7fgCttCveKK1eXtRPww6hhr9fJrOWNKRijhT4zp+M9sjjHCn5IXC83w8aE8x5OV
         cDRhA8qCdqTChFIyMwrPaGQiLQnB57a6z1uQ5FW0sXMDIZZsA/jSQHIJPw9jAlCYzFVG
         uZBI5PLy5DfI5VrQ5lQzOmpT/KZK4+DYzBbMymn1okyYqBRH+Y/VhM9kaKV1+lytBkHV
         r3iw/xy2RSYTZbCOxu1oZ8idrE2bzB/pWss/HjBB/VgKHbrRw6cOUileVI/NG/fw5siU
         tMQw==
X-Forwarded-Encrypted: i=1; AJvYcCVBaN/gkHH+omGkT1Z+d42CMJQ3OZsz44dgRUIbPelwefLWhsNfYQzbyEnHYzRuWptHtHKIlmEVKA==@kvack.org
X-Gm-Message-State: AOJu0YzIMJ6m2Epww+DodnitDry+Mf52dxPlNsGR5WGpY8dGVuaTunvd
	gtGLxSyMciqvSfM3gcoogOh24ym+ORlm6s4y2G9du5EwlLBSr/S89wdrriRZ8vz/YhwYbNCfZy4
	ZtUImcCNGhio6yBMFL+3lOwYB0XlIiaTigRHMRfx1
X-Gm-Gg: ASbGnctMoU3Y18OnHgWEmFPWSk9H2NIdJYuCrv/uUhrmY4djpPHWLIo/e2JKwGHLMB0
	oY7/uPgoiXiFBGbBUtzNqC7S/TEDIVcK7DenGr1wKdALR1a4KjBUjaxSKCUQy/kzqDgbyvXeANV
	OJ4b8yVB3m6DyDZqttIlIomYgdOCFQlm9W607i/DVqicE1ThZRChhcD/bzii3pDyKdSGbA3qkFu
	5eHi7rQYes5TTv8CXT+26RYrdng3+qOMSB1/WYqQIC3elspTqdc4zLMBU4XrPBFCdJNFrnA5AtO
	PdQ9AmLbz93DyeM=
X-Google-Smtp-Source: AGHT+IEGfEQgDl4zF36P+embeb7lzSfG54e7p/DWb3ZsOJN8Yy+uFZKRQuyIT1cbEm4Wz9q0ZGdCemFvisq8Djvddbc=
X-Received: by 2002:a05:622a:4c0b:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4ed1588e7e8mr2901541cf.8.1761691977604; Tue, 28 Oct 2025
 15:52:57 -0700 (PDT)
MIME-Version: 1.0
References: <20251027085214.184672-1-hao.ge@linux.dev> <CAJuCfpF+0ok85A1ZhbptSzrB-X6CUj=TMj9ZvwzjV1tO5PqFbA@mail.gmail.com>
 <d1456749-46c3-463f-bc28-f465b8ce6ff9@linux.dev> <CAJuCfpFJHE-VAOgKfoXJA+V-okvgQt_iEEUdvd4ZCaARFiWExA@mail.gmail.com>
 <058529d6-01f7-48f8-8030-e62b95b9a45e@linux.dev>
In-Reply-To: <058529d6-01f7-48f8-8030-e62b95b9a45e@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 15:52:46 -0700
X-Gm-Features: AWmQ_bnzhvbJZXrLs9OhIOFvKJ3bZTeTSdO0p4yVyWI8QAv16hHPMaudIYuXUkc
Message-ID: <CAJuCfpH2FrQ2OCB7sjXNGf72mLJJPEefXzOu=Ywi=MO92p0HzQ@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Stat-Signature: grc361tizekxi7kpb5j37j3tb5s5ur4c
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AFDFC0002
X-HE-Tag: 1761691978-816677
X-HE-Meta: U2FsdGVkX1+vTDAun/gtDs/no54JfMBAsEyUw6Qity9KjznqkfIogSPZehXmLYWUoCyoMDjiNob8WuzxcRRMpY6OMIjwECpkFOyaBjxpqQwZ7uK/vig3w2opIsvGvCvjDNdXwh7hUutVhVLQ+AAatPfCchgPc4Yijr2S9JyDPQ/OaviIIYfGPHQcfq9VLwjYT5Z/DjNxcX4bZS6TM7Y7i7gCTDvPT8Out1PyCir7q3YH2sMp+OL3PwXeoRnZT2j5M91SFTGYQIhDKPr+uFg11l2x0NnJrH3x2mG8g9ZpHqkoHNn9aRBZv8teQXY5dgyLUPvquzOSheCdZfYfDbyN2a1JC/IrUBFLgdpyYIwXY3CNoeZHQg3oYOVVk90aC4fL2i6RL5m94LJ55yfndufQCfstnjfX/r+/J3uDgcI7YSeiI9WdQTYfxYyu8vCg6RX1wmAG4oxmiU8EXG+2QB9NK+xS7jZiGXqAGI7IZDL7wVUtzBx7AltrKPiELe0BDYYSYRyPtFcBCQPWkyVn/kqbKS5HuOQGrza5Gks4dV0Nh0IsR+IpVcc6KoPtV7NaKA6bex9ecfCUJBJwkdfjSPVUXTYWgELvUp8x6jYc6k/0hE8Ym+72d0rZ/jeYtzkf61Bwdjv1/V48DlBIBbPoN6P+F62jwlM1XsRtuQ7ZUWaRjosPKLt/Xc42vEspKDQ96888cQf0zd7NCtGACv639L6DU2NwqLrnfEjUcDK2lcuhmG1yQe697XX2d2bt9rGeH/2bqY+2tA2Ub1pgcWTXfVH/nvrRYqX1j9DNCaifveUg6YjqpBGaPt6UHuQGJ//7/kttI8dn/UVSNyt7xKc1Aop32FCIMJxRrGzSry0ilpdjG5MfIOebhDVg2R/KQkio0w14+wZ9rm9cdJnADZWDKVtY3CcbKE9Z005djOF79c9ZyMcPwApCYDcWXFPSSJXr6lvPJFKhe+XrUWBGXPg6HQe
 7pPEx0LA
 AsUch/37e7K+YTLmYxKp8tWR1QuMPZlHYduBkgfqYYtsyVa2nFb2OfS8AqdxWMyKXF6igDGKjbgcL21U+V47zNagngoAp2fTFHVF+hY3jcd/C/EKITCgRYRQbC+YwftEjBFAMGHLnxm046ksQtiuEq9EijKB8GkvUjHrPW04Bb1svBki7M4HLzLljne54JYeWH784orDsSbK/FTlgYQiugZ9RC7igoa+QzNSe3n40FUXtYrqqGLNCCQ7DEhQAN4+wi/EDKjGSIvzOH5DcDgKC7ZGewCIFqVOq3aocBR+1IWJ7b5M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 9:58=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> HI Suren
>
>
> On 2025/10/29 00:19, Suren Baghdasaryan wrote:
> > On Mon, Oct 27, 2025 at 6:31=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote=
:
> >> Hi Suren
> >>
> >>
> >> On 2025/10/28 03:44, Suren Baghdasaryan wrote:
> >>> On Mon, Oct 27, 2025 at 1:53=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wro=
te:
> >>>> From: Hao Ge <gehao@kylinos.cn>
> >>>>
> >>>> Even though obj_exts was created with the __GFP_NO_OBJ_EXT flag,
> >>>> objects in the same slab may have their extensions allocated via
> >>>> alloc_slab_obj_exts, and handle_failed_objexts_alloc may be called
> >>>> within alloc_slab_obj_exts to set their codetag to CODETAG_EMPTY.
> >>>>
> >>>> Therefore, both NULL and CODETAG_EMPTY are valid for the codetag of
> >>>> slabobj_ext, as we do not need to re-set it to CODETAG_EMPTY if it
> >>>> is already CODETAG_EMPTY. It also resolves the warning triggered whe=
n
> >>>> the codetag is CODETAG_EMPTY during slab freeing.
> >>> I'm not sure what scenario leads to handle_failed_objexts_alloc() and
> >>> mark_objexts_empty() being used against the same codetag reference.
> >>> Could you please explain the exact scenario you hit?
> >>>
> >>> handle_failed_objexts_alloc() assigns CODETAG_EMPTY to the elements o=
f
> >>> the obj_exts vector while mark_objexts_empty() assigns CODETAG_EMPTY
> >>> to the obj_ext of the obj_exts vector itself. In what case do these
> >>> two calls operate on the same reference?
> >> This issue also occurred during our memory stress testing.
> >>
> >> I apologize for the incorrect description in my commit message:
> >>
> >> The possibility of its occurrence should be as follows:
> >>
> >> When a slab allocates a slabobj_ext, the slab to which this slabobj_ex=
t
> >> belongs may have already allocated its own slabobj_ext
> >>
> >> and called handle_failed_objexts_alloc. That is to say, the codetag of
> >> this slabobj_ext has been set to CODETAG_EMPTY.
> > Ah, ok. Let's see if I understood this correctly. The slab from which
> > slabobj_ext objects are allocated (let's call it slabA) tries to
> > allocate its own slabobj_ext, fails, then succeeds and calls
> > handle_failed_objexts_alloc() which sets all elements of its
> > slabA->obj_exts[] to CODETAG_EMPTY. Then slabobj_ext object is
> > allocated from slabA with __GFP_NO_OBJ_EXT, therefore it leaves
> > slabA->obj_exts[obj_idx] intact and equal to CODETAG_EMPTY instead of
> > NULL. At this point, slabB->obj_exts points to an object in slabA.
> > When slabB is freed and free_slab_obj_exts() gets called to free
> > slabB->obj_exts, it detects that slabA->obj_exts[obj_idx] is not NULL
> > and generates this warning. In your callstack stack the freeing seems
> > to happen inside kmem_cache_alloc_noprof() and I think that's because
> > we lost the race and freeing the vector we allocated here:
> > https://elixir.bootlin.com/linux/v6.18-rc3/source/mm/slub.c#L2165 but
> > the scenario is pretty much the same as if we didn't lose the race.
> > The warning would happen later on I think, when we would be freeing
> > slabB->obj_exts. The key for reproducing this is to fail allocation
> > for a slab that is used to allocate slabobj_ext objects. Is my
> > understanding correct?
>
>
> Yes, your explanation is extremely detailed and thorough.

Ok, let's work on the changelog them. How about something like this:
```
When alloc_slab_obj_exts() fails and then later succeeds in allocating
a slab extension vector, it calls handle_failed_objexts_alloc() to
mark all objects in the vector as empty. As a result all objects in
this slab (slabA) will have their extensions set to CODETAG_EMPTY.
Later on if this slabA is used to allocate a slabobj_ext vector for
another slab (slabB), we end up with the slabB->obj_exts pointing to a
slabobj_ext vector that itself has a non-NULL slabobj_ext equal to
CODETAG_EMPTY. When slabB gets freed, free_slab_obj_exts() is called
to free slabB->obj_exts vector. free_slab_obj_exts() calls
mark_objexts_empty(slabB->obj_exts) which will generate a warning
because it expects slabobj_ext vectors to have a NULL obj_ext, not
CODETAG_EMPTY.

Modify mark_objexts_empty() to skip the warning and setting the
obj_ext value if it's already set to CODETAG_EMPTY.
```
I know it's still hard to read but I could not come up with a better one :/

>
>
> > BTW, your fix seems fine to me, I just want to understand the scenario
> > so that we can explain it correctly.
> >
> >> To quickly detect this WARN, I modified the code
> >> from:WARN_ON(slab_exts[offs].ref.ct) to WARN_ON(slab_exts[offs].ref.ct
> >> =3D=3D 1);
> >>
> >> We then obtained this message:
> >>
> >> [21630.898561] ------------[ cut here ]------------
> >> [21630.898596] kernel BUG at mm/slub.c:2050!
> >> [21630.898611] Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
> >> [21630.900372] Modules linked in: squashfs isofs vfio_iommu_type1
> >> vhost_vsock vfio vhost_net vmw_vsock_virtio_transport_common vhost tap
> >> vhost_iotlb iommufd vsock binfmt_misc nfsv3 nfs_acl nfs lockd grace
> >> netfs tls rds dns_resolver tun brd overlay ntfs3 exfat btrfs
> >> blake2b_generic xor xor_neon raid6_pq loop sctp ip6_udp_tunnel
> >> udp_tunnel nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
> >> nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> >> nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> >> nf_tables rfkill ip_set sunrpc vfat fat joydev sg sch_fq_codel nfnetli=
nk
> >> virtio_gpu sr_mod cdrom drm_client_lib virtio_dma_buf drm_shmem_helper
> >> drm_kms_helper drm ghash_ce backlight virtio_net virtio_blk virtio_scs=
i
> >> net_failover virtio_console failover virtio_mmio dm_mirror
> >> dm_region_hash dm_log dm_multipath dm_mod fuse i2c_dev virtio_pci
> >> virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring autofs4
> >> aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
> >> [21630.909177] CPU: 3 UID: 0 PID: 3787 Comm: kylin-process-m Kdump:
> >> loaded Tainted: G        W           6.18.0-rc1+ #74 PREEMPT(voluntary=
)
> >> [21630.910495] Tainted: [W]=3DWARN
> >> [21630.910867] Hardware name: QEMU KVM Virtual Machine, BIOS unknown
> >> 2/2/2022
> >> [21630.911625] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS
> >> BTYPE=3D--)
> >> [21630.912392] pc : __free_slab+0x228/0x250
> >> [21630.912868] lr : __free_slab+0x18c/0x250[21630.913334] sp :
> >> ffff8000a02f73e0
> >> [21630.913830] x29: ffff8000a02f73e0 x28: fffffdffc43fc800 x27:
> >> ffff0000c0011c40
> >> [21630.914677] x26: ffff0000c000cac0 x25: ffff00010fe5e5f0 x24:
> >> ffff000102199b40
> >> [21630.915469] x23: 0000000000000003 x22: 0000000000000003 x21:
> >> ffff0000c0011c40
> >> [21630.916259] x20: fffffdffc4086600 x19: fffffdffc43fc800 x18:
> >> 0000000000000000
> >> [21630.917048] x17: 0000000000000000 x16: 0000000000000000 x15:
> >> 0000000000000000
> >> [21630.917837] x14: 0000000000000000 x13: 0000000000000000 x12:
> >> ffff70001405ee66
> >> [21630.918640] x11: 1ffff0001405ee65 x10: ffff70001405ee65 x9 :
> >> ffff800080a295dc
> >> [21630.919442] x8 : ffff8000a02f7330 x7 : 0000000000000000 x6 :
> >> 0000000000003000
> >> [21630.920232] x5 : 0000000024924925 x4 : 0000000000000001 x3 :
> >> 0000000000000007
> >> [21630.921021] x2 : 0000000000001b40 x1 : 000000000000001f x0 :
> >> 0000000000000001
> >> [21630.921810] Call trace:
> >> [21630.922130]  __free_slab+0x228/0x250 (P)
> >> [21630.922669]  free_slab+0x38/0x118
> >> [21630.923079]  free_to_partial_list+0x1d4/0x340
> >> [21630.923591]  __slab_free+0x24c/0x348
> >> [21630.924024]  ___cache_free+0xf0/0x110
> >> [21630.924468]  qlist_free_all+0x78/0x130
> >> [21630.924922]  kasan_quarantine_reduce+0x114/0x148
> >> [21630.925525]  __kasan_slab_alloc+0x7c/0xb0
> >> [21630.926006]  kmem_cache_alloc_noprof+0x164/0x5c8
> >> [21630.926699]  __alloc_object+0x44/0x1f8
> >> [21630.927153]  __create_object+0x34/0xc8
> >> [21630.927604]  kmemleak_alloc+0xb8/0xd8
> >> [21630.928052]  kmem_cache_alloc_noprof+0x368/0x5c8
> >> [21630.928606]  getname_flags.part.0+0xa4/0x610
> >> [21630.929112]  getname_flags+0x80/0xd8
> >> [21630.929557]  vfs_fstatat+0xc8/0xe0
> >> [21630.929975]  __do_sys_newfstatat+0xa0/0x100
> >> [21630.930469]  __arm64_sys_newfstatat+0x90/0xd8
> >> [21630.931046]  invoke_syscall+0xd4/0x258
> >> [21630.931685]  el0_svc_common.constprop.0+0xb4/0x240
> >> [21630.932467]  do_el0_svc+0x48/0x68
> >> [21630.932972]  el0_svc+0x40/0xe0
> >> [21630.933472]  el0t_64_sync_handler+0xa0/0xe8
> >> [21630.934151]  el0t_64_sync+0x1ac/0x1b0
> >> [21630.934923] Code: aa1803e0 97ffef2b a9446bf9 17ffff9c (d4210000)
> >> [21630.936461] SMP: stopping secondary CPUs
> >> [21630.939550] Starting crashdump kernel...
> >> [21630.940108] Bye!
> >>
> >>>> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL t=
o mark failed slab_ext allocations")
> >>>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> >>>> ---
> >>>>    mm/slub.c | 12 +++++++++++-
> >>>>    1 file changed, 11 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/mm/slub.c b/mm/slub.c
> >>>> index d4367f25b20d..cda8f75b72e7 100644
> >>>> --- a/mm/slub.c
> >>>> +++ b/mm/slub.c
> >>>> @@ -2046,7 +2046,17 @@ static inline void mark_objexts_empty(struct =
slabobj_ext *obj_exts)
> >>>>           if (slab_exts) {
> >>>>                   unsigned int offs =3D obj_to_index(obj_exts_slab->=
slab_cache,
> >>>>                                                    obj_exts_slab, ob=
j_exts);
> >>>> -               /* codetag should be NULL */
> >>>> +
> >>>> +               /*
> >>>> +                * codetag should be either NULL or CODETAG_EMPTY.
> >>>> +                * When the same slab calls handle_failed_objexts_al=
loc,
> >>>> +                * it will set us to CODETAG_EMPTY.
> >>>> +                *
> >>>> +                * If codetag is already CODETAG_EMPTY, no action is=
 needed here.
> >>>> +                */

This comment is more confusing than helpful IMO. I would leave the
current comment intact and just add this check before it like this:

+               if (unlikely(is_codetag_empty(&slab_exts[offs].ref)))
+                       return;
+
                /* codetag should be NULL */
                WARN_ON(slab_exts[offs].ref.ct);
                ...

> >>>> +               if (unlikely(is_codetag_empty(&slab_exts[offs].ref))=
)
> >>>> +                       return;
> >>>> +
> >>>>                   WARN_ON(slab_exts[offs].ref.ct);
> >>>>                   set_codetag_empty(&slab_exts[offs].ref);
> >>>>           }
> >>>> --
> >>>> 2.25.1
> >>>>

