Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE7E0C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9856B007B; Tue, 11 Aug 2026 01:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AE56B0092; Tue, 11 Aug 2026 01:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A236B0093; Tue, 11 Aug 2026 01:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 972A36B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:46:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 200D116035C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:46:00 +0000 (UTC)
X-FDA: 85087902480.06.5C273FC
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2A983180007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:45:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MfUIycZR;
	spf=pass (imf24.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786427158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lggr1VxwvpvvLhRSEnyeYpoGNeYzxNtdgIf7V1Ih0B8=;
	b=2/3VsYbcH/fPnOBlzI1aWO3vTOpKpWfHU+69M4hx4kxRx8zp1W/qi6nR/H/HT3upv1pfmK
	kmN2x3qz1Yp/9mbMJsVLXBEAM1Fx3wqPC2XBw1uUvioqE1bxAWiX2bpdGjBg5Atg8avD/c
	VviaBgrcSr9J1iHSXtieihIkCnmWcjk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786427158;
	b=xVIKH8/9oRTiiMvWX1ZtAQRhxgM3XNfFSejXw4fmDfW3WUVSsdSXxKsEcNoC0bKm+17s/s
	2t+n40DnCE1a5+GS7VZVSFjncSSdCGzQ4GFextyZaJgobhWUI2rfSCsJORxCMUms1xg5wd
	OAgaODz8S/XN5mu1UEQSMqVp6gBFnQ4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MfUIycZR;
	spf=pass (imf24.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a8173142so2699e87.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:45:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786427156; cv=none;
        d=google.com; s=arc-20260327;
        b=K8/F7oaGMxZMWMD4V0rpKQCiWKk0Wj/81IiJ/+fIL5hIus3TwRpGBqDE2To7VU0czy
         vCbyHucxktTOMGyFT3v4MkoKYU7YDdVc1YkODQvDkvr8jCx7TZk9m1rQNeu87P/QDngu
         +r/2wk3U0FeDTzviNfKx2Qw6Gz2KLEIvOatKn1F6kn1Kl2EZpqQM5hG3S+oMZK+yHuYL
         fBthpISStU2LFb1dgDlCF7Cl0AT1fI/b/F0P5kY/KDT24YGWz20GIJNXM+RI2NVppfrq
         G2OE1fTU8I3nRA4t/bIz+B91nFrf4fHXTPKcNMqSJZfcfsFoUSFL26aCTjFZyW9Yq+Iu
         FwJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lggr1VxwvpvvLhRSEnyeYpoGNeYzxNtdgIf7V1Ih0B8=;
        fh=vzavADtX/ZjUNxazbzNyyZGdCkGXsdrP8GPubZFLILg=;
        b=CNJzM/BekAF5+HxE6QAshICpb11Gu60YxvrC+ymwTsdF4gtkImtLSR+pNPxfzjc1Ag
         gUbRI0r4hy6/i+fI0kU3lBYsIro34eD+c8VfsLA0+sy7huYAyuxn78OU8SV3uW0Y9GuZ
         9RG1bJLsYPlgiyVprhk653CecwufuVeoWeDKLgxfX6/ReJzat3NL11Xe/UzowHkNYEa4
         KOce3OXTI0kuNSyacquvnQwMwo/jKDGr8U3CNoW6GTL2ABPhiMHU32Wcg4+nLtA7kC9D
         5zWiyPAmLoMROp2gqbD518paw70HQKS7EOdVMS/dxt7kvMfhMCfu2uKUY03zPcrTaob/
         I7LQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786427156; x=1787031956; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lggr1VxwvpvvLhRSEnyeYpoGNeYzxNtdgIf7V1Ih0B8=;
        b=MfUIycZRBS1CZMgVSVpq9NuE/iLxsGZ6rAViGOpM2CiHUxHRTps5rW1Asd5G3p1L/O
         godCi8isxVAvRHsGN/0vwI6XJ5ULD/PPc4QvwfrQWyYJp2HhPhqolrCvBI+gvjtWGDRn
         TsV8yr+coH1b70EcG3CfgfTBuyq8HFK0nf/1tRkHXdFitqsFxzY+EFN7c3fCgAycgDAM
         r0cmxaKU7NKC27QhNHZPLCA5dlG16PaM8TjWSw0dr10N6XJGWmrnBbayGRAFEb+ek3Sa
         4by5F4zWhv/l9P5JWkYf1MyhgWbq8iraZHVplJK1qm70nlDqL2Zm1hfjDVjW9rlWmJtp
         nyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786427156; x=1787031956;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lggr1VxwvpvvLhRSEnyeYpoGNeYzxNtdgIf7V1Ih0B8=;
        b=k9p+7nrC0xXWnbEKqkvuWoO1mwTtR9tbpu9KspkVYFJCQ4dQ3NrN984lhnn75ID7aS
         594SMMrG2QNaJIOPo9tGUqiE6RDNiOfBKhUuhpz3/mVn9ZC74hTK7JsN/NcbEwRYjhDW
         89+ADcI0Ng5sFyNpdJ4XJLQv0zNAUfoY04zVXEoEXiIdGBHH4/kNPuMM6owsaIM6Y/JU
         /EsGUbRsplkDcs3HB6Cc/nniE1Z/eUj0ALboSVeBuf9Vj/L1pXKzag6z7E/Oa5CrmQwo
         ubnqIj3dwqOdpeEjiZk862F15rnRsBCxQvoYdJuUo/n57LCh3cpukVxSVg88iDLW2Ogu
         F8tw==
X-Forwarded-Encrypted: i=1; AHgh+Rqns24Z8UAkP7vPMThs7JC3lIGLgN92vg9QSAq9NCSKp12K+33nzj9vpOykqv2NnpULK5d5y0heiA==@kvack.org
X-Gm-Message-State: AOJu0Yzj9WNqwHFqXL8pRF4Pgip+n3l3Ly8WrYkAmKQ9v6Fyp6iY3q/U
	pHqbevJBr5zUUbqO3Jx5ZvjMmv1XItVx5RW8+3zxfBtRtR8lE7FI93mp9UoXFoB7vG0nmUKqKtv
	DoHENOy1qnw2SX7h/stSieDv4GAWjewZN8iggm07J
X-Gm-Gg: AR+sD10F1SxKnWkUG2DuDPNHfTxXIPU6CpPOtSJPH/5BhXLuIT21vmZHf4lpNMZmcuz
	Ql38euD3GdJ3I1Z+TpRm4JhHpXfjRmQHRxHBgHFso9RW8iEYvRQKMSwqmFP31l4a4EodWXidOYq
	N4Gqh6vG7ZvvanXg1tQEv6XIFaRagjZk0WLSrANJo62UJhOFDfIYi0d4AcKuFMA0qfQmNskaVJL
	UDPMmtHxSYGtn+I4TTlBigyPU1sJ5yHHpQ3kSS03TZpmNrkGdALMgiEsHr3mmetWnOjEmgEgHRn
	feH11K041oiUv8kXK64RVE1647IdTXUmlzTyJMtuPJYMscAqHhkoOZf75vFH1WiWp9QaGQHymMJ
	IA2hnJ5+fWWLGARoHW/jrUiFVyhXgjJ8zeg==
X-Received: by 2002:a05:6512:318b:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5b4484f9601mr30437e87.2.1786427156001; Mon, 10 Aug 2026
 22:45:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260810230844.3778931-1-souravpanda@google.com>
 <15EAC670-AA9F-4361-985C-F8ED2C322CF9@linux.dev> <7bdocyansemdfl2lugkmazjo6xytdunv4ujtabxjzeip3h4qbw@6nsaenwowryh>
In-Reply-To: <7bdocyansemdfl2lugkmazjo6xytdunv4ujtabxjzeip3h4qbw@6nsaenwowryh>
From: Sourav Panda <souravpanda@google.com>
Date: Mon, 10 Aug 2026 22:45:44 -0700
X-Gm-Features: AUfX_mxkbvkO7F5uxnYEFgon_bNzIVebG9En3e26bCH7O8U8dppinvD58OS-lXg
Message-ID: <CANruzcSkTm15OTcYExR8nS6h-x0FMgDF++WdhgLsxC3VMxKtMA@mail.gmail.com>
Subject: Re: [PATCH v6] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>, osalvador@suse.de, akpm@linux-foundation.org, 
	usama.arif@linux.dev, shakeel.butt@linux.dev, wangkefeng.wang@huawei.com, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	hannes@cmpxchg.org, riel@surriel.com, sj@kernel.org, vbabka@suse.cz, 
	mhocko@suse.com, bjackman@google.com, zi.yan@sent.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A983180007
X-Stat-Signature: rzp7kjpf6536sgc7zakqg7jctcmggrcx
X-HE-Tag: 1786427158-805357
X-HE-Meta: U2FsdGVkX1++NiMKpndpUEpWIGddTpxtjGospK5vPAiNfejIBO4+seMjhmEIYtotP06gJaGmSThJ5YswFmmPXiFIM3JG2Vjx2dOHaCLMxDOHu6GH2ynDt1SKz98zeyzIPehZGl45LEW++/0wZjawiUgL4p9d66uG8J/wuUA9ehtnMHHCaVGupd6U9khkYyx/P5GQoF86q47cngN3eQ0F1+DqzecPHjJ+i5pU5og6DQUpV2ICAJwsWCLK7sGywLI+OijVD7Ne5r2vYGu4Ta6KY0FDZZ0AwzLc6o9Mb9ptRnqdfo1DFUOV8phkOadmGrsiYhUWvV7rzKmmixhMjxqR7MwBGE4iitt8HzKiMzRxeeHHlGFFLMKG9C++kqnQynOLz0Ds3rywaKVbuXC0gteumvgLF179rg4KMRBEENXScFZ/VP+/YjI6iAv6v61weyAbVHLuXDS6aCeDyCUP6MPCebgMI64BlblKiT/bGwwYycqNhIzDzk8v2viIdkmpIENtfP2PJz1ArlE35vC/KQbGp5/V5fZ/MyjENfP89AyNXplKzcYxzbGyFr3Q7Hum2wwMEc5/4sdZKm3gihnUuByltQPLRkWvCijEZLcY3EPLtZivs0xmeAlfTlM1h1wCq5fQVt8bI3Dq7KpbGI4bjoYdib9sTAlqNyZvwDV4Mx1nvUoik2pqek51P00rB20NEsAaJODtQtWp5PLDb9O/glK7pOANYBWxLJB8r281bVQ1dMdfuHuJ/vdyUSnZwN8aKgnuKTEtr8XBVvgTmqgA3ec92oA5o0a5CQmq3hlpGeTaJIfTHgFEAKHly4fgN3QoGLJ1NDAqnbPSAVnEGPFHzl6vvZhiuIOb0V9qmpd7P1p4DD28XW3hI9AXy7MA8BSe661UxTR/YPbShxq93vgvCco86hud7bEHa7ntThZj3grl7aUyJ9IaDVZsYM875lI1D+h8+63wyXmcnKBmNowTXqv
 d1FIBdN7
 Vt5E4PMV8kyKp2bPGl8HmCLFe4JThaMdZZvYV0KP9jMqdmcKkDbCPcigMgtgRTdxC0Zorx1rqDjEpzHFiu+SdqSUzGgbHFWv0QLAoCjMyaWtECwnKQUoMyrsGzLi9OaGW+V/KpquFYxC127ndctInne3AFsjWKlXom8H+/eEF6xJdMPyK+eaGhtZn8pdwf1l5FROvC6L7VrlW/zrN4XF9BLNWny1esapp8JsMGNN1/FE1CN9rTi0AbFyEmkUk7K0Imc/teC9AvONyL+InLJbI9Px9lXniKKuX2QTbCzM1vsFqQZDVNO506yXX5CpUsa2iyxz700jY6qC9uX7uhajrZsYfSYMXacymUUnC8t9YnEhS3Boq+BrUABSCTlxaO/Oh1OCyCaUZ0aO+HoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:26=E2=80=AFPM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> On Tue, Aug 11, 2026 at 10:48:31AM +0800, Muchun Song wrote:
> >
> >
> > > On Aug 11, 2026, at 07:08, Sourav Panda <souravpanda@google.com> wrot=
e:
> > >
> > > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > > alloc_gigantic_frozen_folio().
> > >
> > > Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> > > allocation on hugetlb_cma[nid] without verifying if nid is included i=
n
> > > the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensu=
res
> > > the initial preferred node allocation honors the memory policy / node=
mask.
> > >
> > > However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask i=
n
> > > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > > leading to a null pointer dereference kernel panic when nodemask is N=
ULL.
> > >
> > > Fix this by checking if nodemask is NULL in
> > > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > > cpuset_current_mems_allowed. Enclose the allocation attempts within
> > > the cpuset seqcount retry loop so that if the cpuset changes concurre=
ntly
> > > during allocation, the attempts are retried using the updated nodemas=
k.
> > > This ensures that the initial node check and fallback loop safely hon=
or
> > > the task's cpuset without violating cpuset constraints or causing NUL=
L
> > > pointer dereferences or unexpected allocation failures.
> > >
> > > From a userspace perspective, this bug allows an unprivileged user to
> > > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > > configured on a subset of NUMA nodes.
> > >
> > > This can be reproduced by booting a VM with two NUMA nodes, restricti=
ng
> > > CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> > > hugepagesz=3D1G hugepages=3D0), and running a program that allocates =
a
> > > 1GB hugepage area without reserving, restricts allocation to Node 0
> > > using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> > >
> > >  void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> > >                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> > >                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> > >  unsigned long nodemask =3D 1; /* Node 0 */
> > >  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> > >        sizeof(nodemask) * 8, 0);
> > >  memset(ptr, 0, 1UL << 30); /* Trigger fault */
> > >
> > > This results in a NULL pointer dereference:
> > >
> > >  BUG: kernel NULL pointer dereference, address: 0000000000000000
> > >  #PF: supervisor read access in kernel mode
> > >  #PF: error_code(0x0000) - not-present page
> > >  Oops: Oops: 0000 [#1] SMP NOPTI
> > >  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> > >  Call Trace:
> > >   <TASK>
> > >   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> > >   alloc_surplus_hugetlb_folio+0x6d/0x100
> > >   alloc_hugetlb_folio+0x3c5/0x660
> > >   hugetlb_no_page+0x3d9/0x650
> > >
> > > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugep=
ages")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > > ---
> > > Changes in v6:
> > > - Enclosed the CMA allocation attempts within the cpuset seqcount ret=
ry loop,
> > >  retrying allocation upon cpuset mems_allowed updates to prevent unex=
pected
> > >  allocation failures as suggested by Muchun Song.
> > > - v5: https://lore.kernel.org/linux-mm/20260809043250.2917406-1-soura=
vpanda@google.com/
> > > - v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-soura=
vpanda@google.com/
> > > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-sourav=
panda@google.com/
> > > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-soura=
vpanda@google.com/
> > > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-sourav=
panda@google.com/
> > >
> > > mm/hugetlb_cma.c | 23 ++++++++++++++++++-----
> > > 1 file changed, 18 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > > index 39344d6c78d8..9debf033d4fd 100644
> > > --- a/mm/hugetlb_cma.c
> > > +++ b/mm/hugetlb_cma.c
> > > @@ -3,6 +3,7 @@
> > > #include <linux/mm.h>
> > > #include <linux/cma.h>
> > > #include <linux/compiler.h>
> > > +#include <linux/cpuset.h>
> > > #include <linux/mm_inline.h>
> > >
> > > #include <asm/page.h>
> > > @@ -30,15 +31,27 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> > >     int node;
> > >     struct folio *folio;
> > >     struct page *page =3D NULL;
> > > +   const nodemask_t *nmask;
> > > +   nodemask_t local_node_mask;
> > > +   unsigned int cpuset_mems_cookie;
> > >
> > >     if (!hugetlb_cma_size)
> > >             return NULL;
> > >
> > > -   if (hugetlb_cma[nid])
> > > +           retry_cpuset:
> > > +   if (!nodemask) {
> > > +           cpuset_mems_cookie =3D read_mems_allowed_begin();
> > > +           local_node_mask =3D cpuset_current_mems_allowed;
> > > +           nmask =3D &local_node_mask;
> >
> > I don't think we need a local_node_mask, nmask =3D &cpuset_current_mems=
_allowed
> > is enough. nodemask_t could be a huge array, so it might consume a lot =
of memory
> > on the stack. I don't think we need to do that unless we see a clear ne=
cessity.
>
> But does not local_node_mask capture current snapshot for cpuset_current_=
mems_allowed
> after first taking a reference via read_mems_allowed_begin() which ensure=
s that nmask
> has a constant value there after. Otherwise nmask could just change value=
 by the time
> it actually gets used.
>
Hi,

Apologies for the poor netiquette of rushing out v7 so quickly (I just
saw your message after sending v7)! I am heading out on a long
vacation starting this Thursday, so I wanted to get an updated version
out for review before leaving.

Regarding local_node_mask: I thought the seqcount mechanism
(read_mems_allowed_begin() / read_mems_allowed_retry()) guarantees
correctness here without needing a stack copy. If
current->mems_allowed changes at any point while nmask is being used
(even during allocation) and the allocation fails,
read_mems_allowed_retry() detects the sequence change and jumps back
to retry_cpuset to retry with the updated nodemask.

I've incorporated this into v7 (Sorry again - for sending it so fast):
https://lore.kernel.org/linux-mm/20260810230844.3778931-1-souravpanda@googl=
e.com/

Thanks,
Sourav

> >
> > Otherwise, LGTM.
> >
> > Thanks.
> >
> > > +   } else {
> > > +           nmask =3D nodemask;
> > > +   }
> > > +
> > > +   if (hugetlb_cma[nid] && node_isset(nid, *nmask))
> > >             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
> > >
> > >     if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > > -   for_each_node_mask(node, *nodemask) {
> > > +   for_each_node_mask(node, *nmask) {
> > >             if (node =3D=3D nid || !hugetlb_cma[node])
> > >                     continue;
> > >
> > > @@ -48,8 +61,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int o=
rder, gfp_t gfp_mask,
> > >             }
> > >     }
> > >
> > > -   if (!page)
> > > +   if (!page) {
> > > +           if (!nodemask &&
> > > +               unlikely(read_mems_allowed_retry(cpuset_mems_cookie))=
)
> > > +                   goto retry_cpuset;
> > >             return NULL;
> > > +   }
> > >
> > >     folio =3D page_folio(page);
> > >     folio_set_hugetlb_cma(folio);
> > > --
> > > 2.55.0
> >

