Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3729DCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD8A6B008A; Wed, 13 May 2026 02:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4816B008C; Wed, 13 May 2026 02:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4396B0092; Wed, 13 May 2026 02:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C42C6B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:48:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B994C1AE0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:48:24 +0000 (UTC)
X-FDA: 84761467728.17.421317E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1EA5A20009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:48:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pb/w9yes";
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778654902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NO9IfTuyK11eGbbv/78bll6gwJfN7wdF7CjlfPBKFAY=;
	b=oHwSWtku6Ob95o8R6y/G0usKJcbyfyNZgKVWNKXQMUCeWIg/Lz0Se4cD8fYlxFAS8xFBmZ
	ecJZ0cTMb+luT3r0X+2K9f0j5Z+mKUsMU9uKh3xGCNYfo36M+LGVCH7iUR7YNzerK4wSzY
	Np7kSx8zKIZQJxx1U5xt/XUlbOC6BUo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pb/w9yes";
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778654902; a=rsa-sha256;
	cv=pass;
	b=Z4nZjqLsc8KCBbIQpIdU6i8UPvEm/CtzNPLNAmSD3MwA+wAdO35o43Ucwq1bUZX/JiqOu9
	ClaPuTrV2TfE9LkjInvTzRFe6OT0X+9hmUG5ptu05xzs0tsqY4A+5HHFkcZq/IjNL4mmvz
	DLLh1b6mVqInCNGrRwZ99z2P8Mv3OAU=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bd3eb594960so40142666b.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 23:48:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778654900; cv=none;
        d=google.com; s=arc-20240605;
        b=jbszepCcxoPbbLTwE0/F8vDWuId2Hk+c8Hb+fK1w71kq5SBxtn75hon2iMcFW7iDRh
         PCLB3v3cjDqYqqbSV5wniQWF/bgx5z+aJb//Vsvd6knO06rQOBWeYZ080GcGOpBiXz3D
         inwkdqvwGT82MH4HMbVd365NsSvUPgidP9IgznpG8dhDCF5oP15N2FkcktXX54JkkrER
         HLgdoFy9qHWZcKYSxCurWhe7sD+I0Poe6plWpH0Bq4+41atuWyaS6mHOAGJmS3L6y3us
         7ZBDHQh0qOFnJARnbbpKtmmygGL2z6A2ry78jOf8enNMIifbXF1zgnxLLC4c8nKC1qPz
         Wg+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NO9IfTuyK11eGbbv/78bll6gwJfN7wdF7CjlfPBKFAY=;
        fh=HNtA0Z4WJ6w/bmtP+IVqMAvGrDLojCqFhHQiXYFmXTM=;
        b=XvX0lUDPHSNlByOdM280/KgDP5B3Z4A+4VFk2Eg64ik2uAHDI2qVELd4DTg2ReUnx5
         x31mrnQ0jPCstDDEjl8FvU1arR+OyjrCOTsUAVoSTMGmSCIGhpljBeiwzb8/8yCXToW+
         2Jqf0NlsuE7ZqW7rgAbBx8N0++BVm5Qg8FS4j/GbMTrEp1tqtAsUT4uQFV8oYyM3DAzM
         30AdJOQ2vD0relQFBycF4SvG8NBZunYU/VTcooP9CuAO5DV2qmslVMQqXgFvpyIpefMY
         Gc6Tpk0X44LQIzkIwEvklFVh4Jc/IJB/+uvSYjsWhd4MdE8U0YmcGren6S3bIrxlC2tJ
         56tQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778654900; x=1779259700; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NO9IfTuyK11eGbbv/78bll6gwJfN7wdF7CjlfPBKFAY=;
        b=pb/w9yesFK6aOYCdqbwVXD8JsZVuwetvDedQCnXhSMfeBh8EXCCWzvQyNhE1pC4iyf
         0h1okmeR9vqzyXezeZYTPfCobaYLUgeiPXW82ir9FKzr9Da3ne8eMpQC1iTMnGm7G9Nn
         IQ0l73N6WENW2dUK243mzjG12dl7Ng0EL2AncFdLpP5WPggxBWjVSX3SfkWpzk3tNA2S
         8hy4Ok/0jc1SUxZ+YiP5rR/amDXf4/uBegi2C/ocNK3Xii+LbdHzk/gYCL8ri3fgZ/1J
         0zM4TF/82Tz0A4+NPTrtYaBhPzqpe2FT2UtaXx1EWf6md8gS66kA6tTJP6niDmvoKavo
         ghKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778654900; x=1779259700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NO9IfTuyK11eGbbv/78bll6gwJfN7wdF7CjlfPBKFAY=;
        b=U75hh0TiM8AWzBddehN+eBMGXcdoQ8Ut+IsMvILPmcrF6QitY3pYyZLrob3poc+hIW
         IwClXSWdTD40msuVsIikU3oEhBD9CjsNc19Hra9qNAPvEYok76EhW0F0jsc1w/5dXxaV
         qFxbsn4SKeMjNHSSWrutc7hx4tC44gjZW4KK2zc07naWUQk8Npqqnoie17JX0Nr5JQ+T
         a5D//JdR0W4zLBSyD3xUdO9JRKblKibTXcSsQCUvx9yIs1LFV4E0FgY2mE7PPx9xXpYL
         Jt+9g9BrQc7c80hDRpsXpsYVZfQc6b9hIZyV6Q0mQNQmY83lskuMSYqCqLSzmXXi+qj4
         N/yQ==
X-Gm-Message-State: AOJu0YzOwVszNMQII+hNr32DFjhqqPDPJLgiQH4r+0esKjXIPFRdItKl
	a0KrCqgbDqDIqvA4fyJDvQO0VohWNcWlVwToPPY1z3Z7j1+/n3t6pcSITsZ0l4S87i5xB63KP/Z
	538pVAj2Ch5ZdMtt9G42MeQ1ebAGqGmo=
X-Gm-Gg: Acq92OHFuDi9kGLEPaWmEwoJF1+Wlde7HW4geNzsEIoD3XUHv5LWkvqqc5fFepFE0NT
	arI9vdSpYY90dhudWVqhU3QaGKgFNvMYpRWCx6gj5clHjQTPzbeQBChNlMyuLhf+XPRvMwUQAos
	PUWjrgOHHgUnE88LT6bxmc+DxZMaBk2ofrmrSyL3cFdC7+IiaFO77bsUkFxEjJvJ6R72bLdNXVB
	7nkIACEqKSwsmjbv2VQj1dA4Mji6QIdBpgmRENmG9cFxi9aKiUt4D1M5M25Adv4ruU/JeHJ+1GA
	9zTdgLT/YYM1LjMAVw8MGtTUg/Fd4zrrotRSR9jh
X-Received: by 2002:a17:906:9c82:b0:bba:8587:1164 with SMTP id
 a640c23a62f3a-bd3e0459b78mr85678566b.15.1778654900164; Tue, 12 May 2026
 23:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-5-2f23759a76bc@tencent.com> <d5341d37-5644-4446-a406-9a7251b83399@linux.alibaba.com>
In-Reply-To: <d5341d37-5644-4446-a406-9a7251b83399@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 13 May 2026 14:47:43 +0800
X-Gm-Features: AVHnY4Jc9dnL_qPLCNsf1WUukJFRqXaEPwjZkq2XUmQtt_5xcUIeBJ3UzKjpIu4
Message-ID: <CAMgjq7CPDk4hP-5hnV4Bth523W_Z+9hvg7Wo_upE-5rYCA0Mpw@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] mm, swap: unify large folio allocation
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EA5A20009
X-Stat-Signature: riw78dq4i54xat5fpyw98pcn115osoyo
X-HE-Tag: 1778654901-191928
X-HE-Meta: U2FsdGVkX1+xJYCF5UX5fpYxQXUUGTi3b2vqCGi02pG7+uxo8Q0yyk7OTMImf8L12Qr410nUc+DoBir2t9LDc2jXxJtuJsGLzwDyJg+jHSXJ27/H0jt9VHxXZprLocNsixvvzxAh8+sKhd5zVCWUL085BKJDMamMFm5QP4IK1LrE6z52r56v/LwUbNg9mtVqaDBne8cM2eK9jNh2bzQ4/peiuuXgDX1y9OjWwjSogBDoOlsG4P26AaucYz2IVlvqaYQYrMg+l1PLUiwDxrUNYR8QMeU+v7h+fOA5ATs7hrWMS4a822+jesQkAJwfcJC0n7LxpkbsoR0LZIGygpd5+mhW0TSwkYjdDtbjZ1Gt8BtWYg0hQ0YseM16zbktPsmSlQj448O4CTRS4eeI7JPFKcG56mS1vZaA8fLZemMZPNg2KwowHRyXlrqR/qSUsRluezfZMX9nug7zHPwi3SqoD33+aV1HZGuW5QrDq+h7mpuBlF+5IFsydRByR5wQYTAXP4WxZWXppnXuUzfPAY0yAYWfwbmXqOuHVHsASu8vP14HC3OuxBmk5+whKS0BdDBqrQPz08wTU1TjMA0IWuG7v5QVkmhyFnAYR9MvvdwVHoSq2pPAgwIQNerJMNY2A1qpdUMSQb88qjszO8PRWOlRvHVOfgoLJOYNhW5M5AE/dxZZTBzvAquSB+8bMqKTZg88RVHeTrGw8yU4h+LkuQE3g/kfXjmSGibfPBU7qTBLfaJqJQA1O9E9IqcjhE54XXc98UxBk6Vhg/4YVHzbRTlIcu2y7SDKYsyKYzgVuNcsNECKF7/mukPc+QI2iJ0fa7gYNzq+quY9oFMwCpJkVHljxi+y2zmh1LiO/LKK68vRxob236i6PBzDCDC2PcgtLUFwssiQnVZqaF42n/6Ndn0kwQ1s/kmCILV/x0ysYbkJEVW+gfIGpJaHJ3yXa75UreNS86ZfAkevZ+mR2vv6+O7
 G0TvIQi8
 NcKRWd40yPVdzkRyuHpJfICLPVtKyeDArfas60H/adia/I+FsyhO13B5/j43RhmNuovg1QHD0WplSBRJ0QLqWSJYzGmSPj7oXP0W5WaQaHpJkSQfIZEogC516rxa7uO2uqGe8D6jz5br1JhGwUvsl02qaUbuEEUyF7Ko4yzdwHZyeId+w+jybdodnI2mtdSCM8N3S0C2huzv+HGxyw4xJSTaM6x9CF4IO8OxTf5+hl52SDgag9Bw82LcVlYxU55tkY45TI6gLA2jx9Wp6wYLtcLqi9Ztn/NHWQJq4N7S6nAP8DYL4sUgoVnMyuz8htG1n2LJek5U4Qi5bUpc7d9Hy/bhucKmOtLp2CfkzCw7fA44nKPd+dmMyhgoqOWBx4fQNm+9Bn/9T5o7Y0awP74x1ahiUVlv2cTwihQRg8Tro9BekSNhmrsxXrBCSkiNTQ+tn3XVGd+cCHDWDEIPDpmIsyyhhFpoupr1Uhmp9gSrU0NrjDIS2RTsOR3uysw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 6:14=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> On 4/21/26 2:16 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Now that direct large order allocation is supported in the swap cache,
> > both anon and shmem can use it instead of implementing their own method=
s.
> > This unifies the fallback and swap cache check, which also reduces the
> > TOCTOU race window of swap cache state: previously, high order swapin
> > required checking swap cache states first, then allocating and falling
> > back separately. Now all these steps happen in the same compact loop.
> >
> > Order fallback and statistics are also unified, callers just need to
> > check and pass the acceptable order bitmask.
> >
> > There is basically no behavior change. This only makes things more
> > unified and prepares for later commits. Cgroup and zero map checks can
> > also be moved into the compact loop, further reducing race windows and
> > redundancy
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/memory.c     |  77 ++++++------------------------
> >   mm/shmem.c      |  94 +++++++++---------------------------
> >   mm/swap.h       |  30 ++----------
> >   mm/swap_state.c | 145 ++++++++++-------------------------------------=
---------
> >   mm/swapfile.c   |   3 +-
> >   5 files changed, 67 insertions(+), 282 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index ea6568571131..404734a5bcff 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4593,26 +4593,6 @@ static vm_fault_t handle_pte_marker(struct vm_fa=
ult *vmf)
> >       return VM_FAULT_SIGBUS;
> >   }
> >
> > -static struct folio *__alloc_swap_folio(struct vm_fault *vmf)
> > -{
> > -     struct vm_area_struct *vma =3D vmf->vma;
> > -     struct folio *folio;
> > -     softleaf_t entry;
> > -
> > -     folio =3D vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vmf->addr=
ess);
> > -     if (!folio)
> > -             return NULL;
> > -
> > -     entry =3D softleaf_from_pte(vmf->orig_pte);
> > -     if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
> > -                                        GFP_KERNEL, entry)) {
> > -             folio_put(folio);
> > -             return NULL;
> > -     }
> > -
> > -     return folio;
> > -}
> > -
> >   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >   /*
> >    * Check if the PTEs within a range are contiguous swap entries
> > @@ -4642,8 +4622,6 @@ static bool can_swapin_thp(struct vm_fault *vmf, =
pte_t *ptep, int nr_pages)
> >        */
> >       if (unlikely(swap_zeromap_batch(entry, nr_pages, NULL) !=3D nr_pa=
ges))
> >               return false;
> > -     if (unlikely(non_swapcache_batch(entry, nr_pages) !=3D nr_pages))
> > -             return false;
> >
> >       return true;
> >   }
> > @@ -4671,16 +4649,14 @@ static inline unsigned long thp_swap_suitable_o=
rders(pgoff_t swp_offset,
> >       return orders;
> >   }
> >
> > -static struct folio *alloc_swap_folio(struct vm_fault *vmf)
> > +static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
> >   {
> >       struct vm_area_struct *vma =3D vmf->vma;
> >       unsigned long orders;
> > -     struct folio *folio;
> >       unsigned long addr;
> >       softleaf_t entry;
> >       spinlock_t *ptl;
> >       pte_t *pte;
> > -     gfp_t gfp;
> >       int order;
> >
> >       /*
> > @@ -4688,7 +4664,7 @@ static struct folio *alloc_swap_folio(struct vm_f=
ault *vmf)
> >        * maintain the uffd semantics.
> >        */
> >       if (unlikely(userfaultfd_armed(vma)))
> > -             goto fallback;
> > +             return 0;
> >
> >       /*
> >        * A large swapped out folio could be partially or fully in zswap=
. We
> > @@ -4696,7 +4672,7 @@ static struct folio *alloc_swap_folio(struct vm_f=
ault *vmf)
> >        * folio.
> >        */
> >       if (!zswap_never_enabled())
> > -             goto fallback;
> > +             return 0;
> >
> >       entry =3D softleaf_from_pte(vmf->orig_pte);
> >       /*
> > @@ -4710,12 +4686,12 @@ static struct folio *alloc_swap_folio(struct vm=
_fault *vmf)
> >                                         vmf->address, orders);
> >
> >       if (!orders)
> > -             goto fallback;
> > +             return 0;
> >
> >       pte =3D pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
> >                                 vmf->address & PMD_MASK, &ptl);
> >       if (unlikely(!pte))
> > -             goto fallback;
> > +             return 0;
> >
> >       /*
> >        * For do_swap_page, find the highest order where the aligned ran=
ge is
> > @@ -4731,29 +4707,12 @@ static struct folio *alloc_swap_folio(struct vm=
_fault *vmf)
> >
> >       pte_unmap_unlock(pte, ptl);
> >
> > -     /* Try allocating the highest of the remaining orders. */
> > -     gfp =3D vma_thp_gfp_mask(vma);
> > -     while (orders) {
> > -             addr =3D ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> > -             folio =3D vma_alloc_folio(gfp, order, vma, addr);
> > -             if (folio) {
> > -                     if (!mem_cgroup_swapin_charge_folio(folio, vma->v=
m_mm,
> > -                                                         gfp, entry))
> > -                             return folio;
> > -                     count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_C=
HARGE);
> > -                     folio_put(folio);
> > -             }
> > -             count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> > -             order =3D next_order(&orders, order);
> > -     }
> > -
> > -fallback:
> > -     return __alloc_swap_folio(vmf);
> > +     return orders;
> >   }
> >   #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
> > -static struct folio *alloc_swap_folio(struct vm_fault *vmf)
> > +static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
> >   {
> > -     return __alloc_swap_folio(vmf);
> > +     return 0;
> >   }
> >   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> >
> > @@ -4859,21 +4818,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >       if (folio)
> >               swap_update_readahead(folio, vma, vmf->address);
> >       if (!folio) {
> > -             if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
> > -                     folio =3D alloc_swap_folio(vmf);
> > -                     if (folio) {
> > -                             /*
> > -                              * folio is charged, so swapin can only f=
ail due
> > -                              * to raced swapin and return NULL.
> > -                              */
> > -                             swapcache =3D swapin_folio(entry, folio);
> > -                             if (swapcache !=3D folio)
> > -                                     folio_put(folio);
> > -                             folio =3D swapcache;
> > -                     }
> > -             } else {
> > +             /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es */
> > +             if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> > +                     folio =3D swapin_entry(entry, GFP_HIGHUSER_MOVABL=
E,
> > +                                          thp_swapin_suitable_orders(v=
mf),
> > +                                          vmf, NULL, 0);
> > +             else
> >                       folio =3D swapin_readahead(entry, GFP_HIGHUSER_MO=
VABLE, vmf);
> > -             }
> >
> >               if (!folio) {
> >                       /*
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 5916acf594a8..17e3da11bb1d 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -159,7 +159,7 @@ static unsigned long shmem_default_max_inodes(void)
> >
> >   static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
> >                       struct folio **foliop, enum sgp_type sgp, gfp_t g=
fp,
> > -                     struct vm_area_struct *vma, vm_fault_t *fault_typ=
e);
> > +                     struct vm_fault *vmf, vm_fault_t *fault_type);
> >
> >   static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
> >   {
> > @@ -2017,68 +2017,24 @@ static struct folio *shmem_alloc_and_add_folio(=
struct vm_fault *vmf,
> >   }
> >
> >   static struct folio *shmem_swap_alloc_folio(struct inode *inode,
> > -             struct vm_area_struct *vma, pgoff_t index,
> > +             struct vm_fault *vmf, pgoff_t index,
> >               swp_entry_t entry, int order, gfp_t gfp)
> >   {
> > +     pgoff_t ilx;
> > +     struct folio *folio;
> > +     struct mempolicy *mpol;
> > +     unsigned long orders =3D BIT(order);
> >       struct shmem_inode_info *info =3D SHMEM_I(inode);
> > -     struct folio *new, *swapcache;
> > -     int nr_pages =3D 1 << order;
> > -     gfp_t alloc_gfp =3D gfp;
> > -
> > -     if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> > -             if (WARN_ON_ONCE(order))
> > -                     return ERR_PTR(-EINVAL);
> > -     } else if (order) {
> > -             /*
> > -              * If uffd is active for the vma, we need per-page fault
> > -              * fidelity to maintain the uffd semantics, then fallback
> > -              * to swapin order-0 folio, as well as for zswap case.
> > -              * Any existing sub folio in the swap cache also blocks
> > -              * mTHP swapin.
> > -              */
> > -             if ((vma && unlikely(userfaultfd_armed(vma))) ||
> > -                  !zswap_never_enabled() ||
> > -                  non_swapcache_batch(entry, nr_pages) !=3D nr_pages)
> > -                     goto fallback;
> >
> > -             alloc_gfp =3D thp_limit_gfp_mask(vma_thp_gfp_mask(vma), g=
fp);
> > -     }
> > -retry:
> > -     new =3D shmem_alloc_folio(alloc_gfp, order, info, index);
> > -     if (!new) {
> > -             new =3D ERR_PTR(-ENOMEM);
> > -             goto fallback;
> > -     }
> > +     if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
> > +          !zswap_never_enabled())
> > +             orders =3D 0;
> >
> > -     if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
> > -                                        alloc_gfp, entry)) {
> > -             folio_put(new);
> > -             new =3D ERR_PTR(-ENOMEM);
> > -             goto fallback;
> > -     }
> > +     mpol =3D shmem_get_pgoff_policy(info, index, order, &ilx);
> > +     folio =3D swapin_entry(entry, gfp, orders, vmf, mpol, ilx);
> > +     mpol_cond_put(mpol);
> >
> > -     swapcache =3D swapin_folio(entry, new);
> > -     if (swapcache !=3D new) {
> > -             folio_put(new);
> > -             if (!swapcache) {
> > -                     /*
> > -                      * The new folio is charged already, swapin can
> > -                      * only fail due to another raced swapin.
> > -                      */
> > -                     new =3D ERR_PTR(-EEXIST);
> > -                     goto fallback;
> > -             }
> > -     }
> > -     return swapcache;
> > -fallback:
> > -     /* Order 0 swapin failed, nothing to fallback to, abort */
> > -     if (!order)
> > -             return new;
> > -     entry.val +=3D index - round_down(index, nr_pages);
> > -     alloc_gfp =3D gfp;
> > -     nr_pages =3D 1;
> > -     order =3D 0;
> > -     goto retry;
> > +     return folio;
> >   }
>
> IIUC, in the __swap_cache_alloc() implementation in patch 4, when shmem
> swapin falls back to order 0, it doesn't adjust the swap entry value
> like here. Because the original swap entry may not correspond to the
> swap entry for the order 0 index.
>
> Of course, I haven't tested this yet, just pointing it out for you to
> double check.

Thanks for pointing it out. No worry, we have the below change in this
commit already:

                        /* Direct swapin skipping swap cache & readahead */
-                       folio =3D shmem_swap_alloc_folio(inode, vma, index,
-                                                      index_entry, order, =
gfp);
-                       if (IS_ERR(folio)) {
-                               error =3D PTR_ERR(folio);
-                               folio =3D NULL;
-                               goto failed;
-                       }
+                       folio =3D shmem_swap_alloc_folio(inode, vmf, index,
+                                                      swap, order, gfp);

It's using swap instead of index_entry now, so __swap_cache_alloc will
do the round down for large order instead and skip the round_down if
ordedr is zero. So we are fine here.

