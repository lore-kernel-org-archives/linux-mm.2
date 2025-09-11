Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C13CA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB7C8E000D; Wed, 10 Sep 2025 22:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC5A8E0001; Wed, 10 Sep 2025 22:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2458E000D; Wed, 10 Sep 2025 22:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F02F78E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:49:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9797C1A0392
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:49:33 +0000 (UTC)
X-FDA: 83875438626.02.A52D24B
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id B8D6F180004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:49:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=atMU47hM;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757558971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPkvLMLUO4/MeSrlRc20PFaOfOQfZFZatjMRvIBVqIE=;
	b=jj5L2ksPe1GIJK01gQQoVky6HTWsDkMpdXUArTnJn64QtmNJnC8pS896gDIrAgIAk3Yi+f
	1KPyELjChDZ42JwRj8avSpVmPhVZ+cKCf3LoMChcXixRxIlIXnr7dtxRW+oKg6aEUA4Asm
	JKvjNEdeJbEH583MmIWNs4yxSoTOujs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757558971; a=rsa-sha256;
	cv=none;
	b=KFJtw9i0vUk62lTSgPvVHbLUyEbW8sRAnj2kBJJOFx4D7Fwf7SI3IOzWiNjIKheogO7TnZ
	XGZ4Mh6tY6QyJIm6AiPWv1eCSZYM/tq4JqX1c0v1PpK+BYFuoOxoGP9pMMv/9zPKGiwNLu
	+8v5FaoDwEVV6g/mI99Leb0tXiXnX9o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=atMU47hM;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-70dfa0a9701so2711356d6.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757558971; x=1758163771; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPkvLMLUO4/MeSrlRc20PFaOfOQfZFZatjMRvIBVqIE=;
        b=atMU47hMBODIujovd71zQ1gnRX8KVEl3r01zMfI1JluD7NTfx1qUJ1ZALlJu1ru9Kt
         +/k0DrctpRu9kTZzQjG2/YH9MxY71N+UdK2m2h9zPWnuRgxCIsTh3yJpPpTw45GA8pq+
         dGClZw+JAvDJ0XuF51Ubfn+FttrYuPBJzbxDD1HHRHO7uFGmBfGh3ymdIAS9yOAZ37Zq
         +ctDOtw95csW6QbzqKzzvtiv6JqFV7oXfUTt+3sCRw5vtmBXubVUQf8vhft4MgJE9Ahh
         BGEbMvlTxLHKpgb5rXCdvdRKSxRBhqGV+RM2MGyeBLmOUdj9Vbg0hAxahusgrwiWucs8
         d41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757558971; x=1758163771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mPkvLMLUO4/MeSrlRc20PFaOfOQfZFZatjMRvIBVqIE=;
        b=JjpyGYez1ZVfVnQl+B+3IEfnJsMUdEHHeOARUiIwYitLLrX5GJ6h59WXcKoB0gkkAC
         mLogeSZ2BSCvSjcj5is8Tv7kOFtrufnD01gfueFjy674ElRMaX0zeMuEiPpMrZwq4eAF
         jW+phu3ZE97bTASm+7Cc8Z9uuHO9F6edk5MvCjSZH6Upf7+/k6uqFkkNSzjiD+ZHcy9B
         bEVkSjhw2lfV4Xd6J6kRkmHCRetCSotuuamAP4ubTCeZrg3p2ICgvDroPs2k9BYrzZWe
         Jxs6j4tQka++e20bLuBsPQFPWr34CpqIOdFIDeCcIkKk5YXbcCdQwIZv0C/4P2z5Vuy/
         aUfw==
X-Forwarded-Encrypted: i=1; AJvYcCXZ2OGvYwphYMqSvzt49cj+4aT8MwbXVPD6NV3p5LYsuGbxJ+G7zQMgv1atSGUBbO1YirmOpzOXgg==@kvack.org
X-Gm-Message-State: AOJu0Ywhm6OFgT8eYl5UD9xcuiChLJjDfS4yTbIy72wUpJMcUFIyn7fl
	HKoeKCmX92fGlnhRDNs+V0D52mkutoMhB7susBNrpXvgQgzZ23lrIS5GnHywiAHu/TrCVGXYG/R
	tpfWSQYJtwhdMZGB+78lXBQPaALVcWys=
X-Gm-Gg: ASbGncvxxykv2aaAkeqN/bEasl6uKNycKKVEG9rBvXNfUufOChAA6qKdEl65WsUdjTC
	Sg0N/uwykcEU6xmdbJW73lDw/e4FsinikivK36oj16I1WS3GFhR1C+DO16azWaqTR9Fb9pLhSeZ
	51YGRKQ9zUe6uzWAtkvazZYGpdpfeO2zjcwkHNj1ocleBpHsLl3XZpV1tJaucqNHeJMS6BReSdk
	Gi3Q6qZbvQKMWsxJq9RB7VhETsyG6vOUlPXNW3O
X-Google-Smtp-Source: AGHT+IGqscjg9YNQgZdBNOy6g5+0CDhJK0qHro2vjyAAA8dy6Xw4gh+wTZvmnYMWSlPTMxgNC1MioX6UzB7j+ICQZ0c=
X-Received: by 2002:ad4:5f0f:0:b0:729:aa08:11f5 with SMTP id
 6a1803df08f44-7394587e3b9mr199292636d6.64.1757558970712; Wed, 10 Sep 2025
 19:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
 <CABzRoyZm32HT2fDpSy_PRDxeXZVJD35+9YqRpn9XWix8jG6w8g@mail.gmail.com>
 <CABzRoyYqGsABGVgXbH3Sts3yBsk7ED=BsKbcP3Skc-oWeFsN_w@mail.gmail.com> <ac633edf-4744-4215-b105-c168d3a734ce@linux.dev>
In-Reply-To: <ac633edf-4744-4215-b105-c168d3a734ce@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 11 Sep 2025 10:48:54 +0800
X-Gm-Features: AS18NWCKZiA03E-aejW3uz2mDNVDJGB6xG9JGVb75n2Lnhn-9uYRcZZKPr2Dc4I
Message-ID: <CALOAHbAfzDNdx5LTUhH+eMgVfdG35gAM5subeByP97x53=CWLw@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8D6F180004
X-Stat-Signature: p3gu8aiqqiuownpkbao1ps4d3384itqb
X-Rspam-User: 
X-HE-Tag: 1757558971-508419
X-HE-Meta: U2FsdGVkX19STKg6v/wOwI3xvQThQ9lcNwMtNjur7f9q/F0EgCcUkW3U0bxsTgRdjOTAYkvHJL7OZc3cxtpunW8W1MN0uEkMAxbb0A0plW4lc8o5ycKYhQ3/zUiMHzVr8IovfO76u2B9K4WNVZxmj8PzSBXwCPDXkYBZ/qlzeSQxA/eaZEzwOkub//Sn1HCbcqeRSxjoG3xSW3K923Ook4bzkEaHw6zMzyL6di73UUazOplNP+p/tSUFyzLUlW9vD7dhMfzc0OAulaZ64yLJGRd+W9nvL8PH/OSR6ejMOnEsE4m+YsZ62Prf67Tfvb6PRE7qFG0+ryZ797ZOHwYsB0Uom7grwr3T2pT00GNKruBTUi2WXWaCuJfWy1rC/u7nmkcQG6A1NtWe/k73g09u2ytTnW9Je10zly0v7HsM1kAOkdanESkLxseLMrb+dg0IcHBaZYK/bpZ1EvMfforvcNJfYmOS16pwG3G7jv3qiXVwCP0hUWNUSHGgKRBiU7sUnkXV/Y7IngX7zZfqzaP6yQ6lGm4WqrfSJJRlm/LgHU0l2Hd9bGmRuz82l7BpZ11Gzo9kP4A8kgcPcIP0uuV31vQMH0/g5jICOXuPsAc+/BwUsMDDlcoFZ8qKNvQ8jGC0HxbW9MzOa8Ff452YFAxRM3IqGWOUyNc7agBmFavbvB1xRk0Fv+GT5jKBKD6DRP6jGOv+uYjD7Z8IlNSKjuBKZvagqosV8keq/Lm9eLZoFM+v0mFpC8ALzYn37ykgb+PBMRfF3fltOzBEulwpEA4upJtDN8YiXW1J9Mde27fNbyC417zsWXDuWBe+sq01s9/RHtkGwHWMjGKJ8X41l7PuVBX5OY2edWguyy4nK49GgwMMsfxk5yerz1kz2+C9lWqumMqoT/wni2o7VNZ1el3z6ln//K5orGpuUGOl9QrfYm5fevdEE1ioqzjpFOXzDkdzWLOGeV6xeDr3hiUoDfG
 5+UxZhmh
 qMVQPmpIKauN8bbHSdnGkCnhM7Un8Y+4AWIEV+hd5Q+QCaEuefsYikPfceK0qvwIB0YN/Y07kMeGta6roNlUfRirjo1nOORSoThIN8TYnzUdKP0TZfPo+gIVnBvOR+5hAeVdMPL5exEleiHSX4QbtMR0XYNvHgTKDaAqDsK64nXNCZ4WFXR19vlO9SESP0qd5inw4shgjjhWOnXpf2DBnxwefbhGPpKgUqnBBoweXZTpwZGB4Rniw7rMR0cKAIIkouz5sBMvuCzoSH0ytIGJ52SGvi/etnKhIk8K2cyM+F9Pygx1BKkdsR2P/uU312gVHCbO+N7hEodd6IcrlYezPBgmCi5iNV/D3A4yGAJTwtFz2Kz+NyYzgoCk8CHZgQHs5Wc2gMniO17sV1Xssy7iNBEMhF4zH3JnwzMQ8ynPiAqTZ8grOZ05xWrABz1Es9L2OPY0vpJNrfCCJoTw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 9:57=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
>
>
> On 2025/9/10 20:54, Lance Yang wrote:
> > On Wed, Sep 10, 2025 at 8:42=E2=80=AFPM Lance Yang <lance.yang@linux.de=
v> wrote:
> >>
> >> Hey Yafang,
> >>
> >> On Wed, Sep 10, 2025 at 10:53=E2=80=AFAM Yafang Shao <laoar.shao@gmail=
.com> wrote:
> >>>
> >>> This patch introduces a new BPF struct_ops called bpf_thp_ops for dyn=
amic
> >>> THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
> >>> programs to influence THP order selection based on factors such as:
> >>> - Workload identity
> >>>    For example, workloads running in specific containers or cgroups.
> >>> - Allocation context
> >>>    Whether the allocation occurs during a page fault, khugepaged, swa=
p or
> >>>    other paths.
> >>> - VMA's memory advice settings
> >>>    MADV_HUGEPAGE or MADV_NOHUGEPAGE
> >>> - Memory pressure
> >>>    PSI system data or associated cgroup PSI metrics
> >>>
> >>> The kernel API of this new BPF hook is as follows,
> >>>
> >>> /**
> >>>   * @thp_order_fn_t: Get the suggested THP orders from a BPF program =
for allocation
> >>>   * @vma: vm_area_struct associated with the THP allocation
> >>>   * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPA=
GE is set
> >>>   *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_=
THP_VM_NONE if
> >>>   *            neither is set.
> >>>   * @tva_type: TVA type for current @vma
> >>>   * @orders: Bitmask of requested THP orders for this allocation
> >>>   *          - PMD-mapped allocation if PMD_ORDER is set
> >>>   *          - mTHP allocation otherwise
> >>>   *
> >>>   * Return: The suggested THP order from the BPF program for allocati=
on. It will
> >>>   *         not exceed the highest requested order in @orders. Return=
 -1 to
> >>>   *         indicate that the original requested @orders should remai=
n unchanged.
> >>>   */
> >>> typedef int thp_order_fn_t(struct vm_area_struct *vma,
> >>>                             enum bpf_thp_vma_type vma_type,
> >>>                             enum tva_type tva_type,
> >>>                             unsigned long orders);
> >>>
> >>> Only a single BPF program can be attached at any given time, though i=
t can
> >>> be dynamically updated to adjust the policy. The implementation suppo=
rts
> >>> anonymous THP, shmem THP, and mTHP, with future extensions planned fo=
r
> >>> file-backed THP.
> >>>
> >>> This functionality is only active when system-wide THP is configured =
to
> >>> madvise or always mode. It remains disabled in never mode. Additional=
ly,
> >>> if THP is explicitly disabled for a specific task via prctl(), this B=
PF
> >>> functionality will also be unavailable for that task.
> >>>
> >>> This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) =
to be
> >>> enabled. Note that this capability is currently unstable and may unde=
rgo
> >>> significant changes=E2=80=94including potential removal=E2=80=94in fu=
ture kernel versions.
> >>>
> >>> Suggested-by: David Hildenbrand <david@redhat.com>
> >>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >>> ---
> >> [...]
> >>> diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> >>> new file mode 100644
> >>> index 000000000000..525ee22ab598
> >>> --- /dev/null
> >>> +++ b/mm/huge_memory_bpf.c
> >>> @@ -0,0 +1,243 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +/*
> >>> + * BPF-based THP policy management
> >>> + *
> >>> + * Author: Yafang Shao <laoar.shao@gmail.com>
> >>> + */
> >>> +
> >>> +#include <linux/bpf.h>
> >>> +#include <linux/btf.h>
> >>> +#include <linux/huge_mm.h>
> >>> +#include <linux/khugepaged.h>
> >>> +
> >>> +enum bpf_thp_vma_type {
> >>> +       BPF_THP_VM_NONE =3D 0,
> >>> +       BPF_THP_VM_HUGEPAGE,    /* VM_HUGEPAGE */
> >>> +       BPF_THP_VM_NOHUGEPAGE,  /* VM_NOHUGEPAGE */
> >>> +};
> >>> +
> >>> +/**
> >>> + * @thp_order_fn_t: Get the suggested THP orders from a BPF program =
for allocation
> >>> + * @vma: vm_area_struct associated with the THP allocation
> >>> + * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPA=
GE is set
> >>> + *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_=
THP_VM_NONE if
> >>> + *            neither is set.
> >>> + * @tva_type: TVA type for current @vma
> >>> + * @orders: Bitmask of requested THP orders for this allocation
> >>> + *          - PMD-mapped allocation if PMD_ORDER is set
> >>> + *          - mTHP allocation otherwise
> >>> + *
> >>> + * Return: The suggested THP order from the BPF program for allocati=
on. It will
> >>> + *         not exceed the highest requested order in @orders. Return=
 -1 to
> >>> + *         indicate that the original requested @orders should remai=
n unchanged.
> >>
> >> A minor documentation nit: the comment says "Return -1 to indicate tha=
t the
> >> original requested @orders should remain unchanged". It might be sligh=
tly
> >> clearer to say "Return a negative value to fall back to the original
> >> behavior". This would cover all error codes as well ;)

will change it.

> >>
> >>> + */
> >>> +typedef int thp_order_fn_t(struct vm_area_struct *vma,
> >>> +                          enum bpf_thp_vma_type vma_type,
> >>> +                          enum tva_type tva_type,
> >>> +                          unsigned long orders);
> >>
> >> Sorry if I'm missing some context here since I haven't tracked the who=
le
> >> series closely.
> >>
> >> Regarding the return value for thp_order_fn_t: right now it returns a
> >> single int order. I was thinking, what if we let it return an unsigned
> >> long bitmask of orders instead? This seems like it would be more flexi=
ble
> >> down the road, especially if we get more mTHP sizes to choose from. It
> >> would also make the API more consistent, as bpf_hook_thp_get_orders()
> >> itself returns an unsigned long ;)
> >
> > I just realized a flaw in my previous suggestion :(
> >
> > Changing the return type of thp_order_fn_t to unsigned long for consist=
ency
> > and flexibility. However, I completely overlooked that this would preve=
nt
> > the BPF program from returning negative error codes ...
> >
> > Thanks,
> > Lance
> >
> >>
> >> Also, for future extensions, it might be a good idea to add a reserved
> >> flags argument to the thp_order_fn_t signature.
> >>
> >> For example thp_order_fn_t(..., unsigned long flags).
> >>
> >> This would give us aforward-compatible way to add new semantics later
> >> without breaking the ABI and needing a v2. We could just require it to=
 be
> >> 0 for now.

That makes sense. However, as Lorenzo mentioned previously, we should
keep the interface as minimal as possible.

> >>
> >> Thanks for the great work!
> >> Lance
>
>
> Forgot to add:
>
> Noticed that if the hook returns 0, bpf_hook_thp_get_orders() falls
> back to 'orders', preventing us from dynamically disabling mTHP
> allocations.

Could you please clarify what you mean by that?

+       thp_order =3D bpf_hook_thp_get_order(vma, vma_type, tva_type, order=
s);
+       if (thp_order < 0)
+               goto out;

In my implementation, it only falls back to @orders if the return
value is negative. If the return value is 0, it uses BIT(0):

+       if (thp_order <=3D highest_order(orders))
+               thp_orders =3D BIT(thp_order);

>
> Honoring a return of 0 is critical for our use case, which is to
> dynamically disable mTHP for low-priority containers when memory gets
> low in mixed workloads.
>
> And then re-enable it for them when memory is back above the low
> watermark.

Thank you for detailing your use case; that context is very helpful.

--=20
Regards
Yafang

