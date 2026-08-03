Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B512C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8D96B007B; Mon,  3 Aug 2026 02:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9676B008A; Mon,  3 Aug 2026 02:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098876B0092; Mon,  3 Aug 2026 02:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7BA16B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:37:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63814C060F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:37:46 +0000 (UTC)
X-FDA: 85059002532.17.CE5FF09
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7983F10000D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:37:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gNqnRDh0;
	spf=pass (imf14.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785739064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ebPcDGXj+PaswuSP/wgGv1AYqRzCOupgQ/8wHK9b1c=;
	b=NAXCFiOPRj+VzBBWj+5MBCVW/KWRQzx7ybRxX2Kdrrc1Vt2szgEUrz186ZCXochYY2EoHg
	wPNGT+wHq8pvAKj6jNlffSHN3bgMADsRzRLWda1zVkX1D2Xa8x9hricynK2cT6iMjpV/Ro
	bxvTGJOi1kDFVn/BNKcj7X7N5FUDkbA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785739064;
	b=24s4CRyAMW1nG6wppFRjVgx4clPPk6tJTyV1sGry/DgRxzepPzOn777x8i2sOcnlR4dcmF
	zXPses0mB+gBQsgYglqYASopuXklQqae3hxsAD1d7wh+cVTcyvCgYNMhOrNLnArNch+SXf
	+Bdj9l2bxutwFs9W8AxnG7Yl1+xSO5k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gNqnRDh0;
	spf=pass (imf14.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so5605e87.1
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 23:37:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785739063; cv=none;
        d=google.com; s=arc-20260327;
        b=UvRomNfLn3XRUzWSMz+bnFw4ERQ3uXAL07gowtefi3p12sxYD6rhZb6gvcrO39epiJ
         EJR+kYRP8FUFN8PN5qZVm0rrH7pedo86+eVfPEHRzFFjHjdrPL10HydUZ+ojOA2ytXp3
         kbcN4KSRJPACci2PIzTLhHHVjztMYp5+r6VX9oVu1NyjNAXsJkTk/6ww3ii9ioaWDjsi
         JUYlGZjKMHDt8ucf2E5NU4LvpKRAkXyUh3IuOWPNv4PBgwOTwdY+PzmvH8HjdHc7mmb3
         Ii9+2UTC/g41WzVxTa5FjjbIck/1ahU+6UnOya12UNxJdoee5pu+rQwiAyVglmNEQ9tu
         qLNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3ebPcDGXj+PaswuSP/wgGv1AYqRzCOupgQ/8wHK9b1c=;
        fh=XAUDxF+UC4aXmJthjGSyR9cXpJPxiRt2SgJaZm+ojAM=;
        b=S8hcG3UGYRE3Re1giCSjVCkEMjkdoVk3wiL33pKJ7V6ww6pv3nZfhUBlx7SwaDBSeS
         B/0MfAl7PAlMRCpFtMibwZhLI9OSMoUfyZnyHnAkmvwkr1BkG15i4uKpoylOUusJRWHD
         HGaYErBUlgGrj9Wil3CNv8vR0ltp9Gwod0Y9N9+xQkx6TXx79oULNVMXiY3VfWKsRYVt
         21x7juicpk7yMkHAv1Q04gBM52KdyyfaSrj4mrYmOxqQc4XxnNvUEgQj1gtEH0QgHh00
         EIDnFAjDvupzzfRqXwZ6JpYCm4cOj6xJHp50ZOvVwOP4sROjG0LF6f2EzsIMAd/qpy0T
         5MeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785739063; x=1786343863; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3ebPcDGXj+PaswuSP/wgGv1AYqRzCOupgQ/8wHK9b1c=;
        b=gNqnRDh0qpRXtNZiwGTsN/b1CXlGDal8XMnp8r2MjMatIXCdL01zx64wfWp/hgeYb2
         TvmqpHAtj6Te9Om+monyP7qycmTYen4hDfR+vqj52AGF+uT8HhJdK9DqtaWFQY+/z+QN
         rp1b0UukZP1M393f4mYpTtwKRD5Qg6D5s1XvMABNJ4jksEKL5qUqxQ8o6vCYRWUPaIQw
         zpmTR3Schj/Cq50a9BOeNMbhcOZiNFUclReM3a9fkCEYfvdVG1MJ6QP6/50B3XMUoZ4q
         x6YtwdfoBvhkQwk7AwXGHbIQMvItg/w9Z8JHzywaV51wHWEndm9N5itOdBTndiKdE6DC
         aO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785739063; x=1786343863;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3ebPcDGXj+PaswuSP/wgGv1AYqRzCOupgQ/8wHK9b1c=;
        b=GKF3W057Wem8RYK19f44dNJfOEWUla34xI0BgCqblkLK8+8JYZXbL5DWobm5QZujTV
         mfmMEkLgGVzT6B8i/7quC0yyiGC+cWxHLs2nYcmW30fEByPuzLXPG+faCA2+SR4LR1mu
         6aQqK16cifuLyDGvqnyL2IOJ4l/aG8HXYLdK5aSGmwwCa1J5yfhxMwKKvIuobXf4uWIt
         KJBg9mWxbkBPtUD+KKOgDMHV6+81I9oKMa2fW4VjgnBrWGm8hBqsoPECZxd+zKqhoeNx
         cw34VR+quMvJZ6JdLUx4javnv8CPbQvlIraKN1rbTcRmUOjelgA2e8xfHo22plJmXL1q
         BoAQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqd9fnIKKdQyfGzDC0mMcwLYv68IJJiX3+W6ld5DsAVuPXFlRM/ADQOqTgtvlT3NBUUSFuP0PvFOA==@kvack.org
X-Gm-Message-State: AOJu0YwTSFohV+8lNtDi2XwC+E70tDfOsiONtaSHb5dNXx7FEhJksE07
	DIsONDCge8QtBTAS3/crUP+th2FsuvEYztuYf1MZzfRPbhw9LCn0obM8s8Jiv7ksn8FvnCEPGS6
	1Yjvd3qMBToi4B1dlJ3++HUQSWsD377OgtivgG5xZ
X-Gm-Gg: AR+sD10Pa7iMkn10MafWu184sLlTycX/2QH6hTYnf0ZJzbi2PxPfF9Rl1uHjuzf25Ki
	w5jrtRhUVmAz8j0+zxi6iZDQV8yS1t6xTQF5XmxoAnBdlR2RFzCDi+gtzp3wTTYMaGcrlBOVpcl
	A2Hl6XL6QYMyWMuqYu6/xaj9fFGIXSy/sTfe8K34jCo/s8eD3LPkhYHmMZjSbAqZiTsmruVV4kY
	8r3LEk/U/xzbhTR1V02bOaFrkJW3ig0BNf/lzpvjbTUHvr5UIyiT1dY9PiIYek1vv3+NvLbkFCa
	7TLwPucfk8cu9BpYShpLC8+VxRUrCOuwVGvsossaiyQAZSVxvMK18MN+iOjPEtlC/C/RvA1k7AL
	p55D4Gjd3oXiA4/6Rl0qsroA1tdFJrFPcls3z//gSEKrbGQ==
X-Received: by 2002:a05:6512:230e:b0:5ae:ae6f:8b09 with SMTP id
 2adb3069b0e04-5b2e5717f12mr173140e87.10.1785739062441; Sun, 02 Aug 2026
 23:37:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260726072935.3513996-1-souravpanda@google.com> <20260727175704.0e4ccd4a6201435a6284d260@linux-foundation.org>
In-Reply-To: <20260727175704.0e4ccd4a6201435a6284d260@linux-foundation.org>
From: Sourav Panda <souravpanda@google.com>
Date: Sun, 2 Aug 2026 23:37:31 -0700
X-Gm-Features: AUfX_mynh8xiJVQvCsrbpeYCESucPbykaRMktmgYyAxyyOhntZ70mcAeB836PGo
Message-ID: <CANruzcQ=Wez3KYwkdpAsUYEbGQYaMYJmYSy408u-v1vH-gmQqw@mail.gmail.com>
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Usama Arif <usamaarif642@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6cfti4ih88fw3t7qio178g7ip7ndnmha
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7983F10000D
X-HE-Tag: 1785739064-78741
X-HE-Meta: U2FsdGVkX185+VxCVGeqBnZJiOC8KaHIYFnU5CDJ37dL1VNbWK5AY883OIqh0/gQrzE3e3aTJGe0Y4xT95cgM1jI/NuRl0WDpRp72n6IX9gIADMKnKSMK/IEePBMKueONjGrAAVF3uceTOqBAja4r1IdH6Wgn5lgLgt66kSVxaULVLQxMstyKQbYwB7j0bzESN6oAqdFMBLjXjZTEHJeX1jbfLGv/N7rur+Es4xKG+flvtCW1dO/3wsLrhJrjOO8JX9EAsf4XYQSkDtxma9aDcYheqFoDZy/p3dKPHxpykpucfZ9iq5WaN74dzqzn1XnkTl8Ks2jXGBw75P45JULlU9WcQ1spRQr2v1MZcw3XHnxlqIJvLJbNy/H/waIiVXWvkjhk9gtTZSCrQDPbM69JTrxCwbC6qPk5549AmeiMXfdMKUw5c90N3F6ICeibPlHGM5Cp8OOsnWUSUT85mvdC4/P3roQhqfZQBfcKAeRFPqAJAfHCI52OoyUOMuwI3U9ui4VXFPXg838z4NYWdYNBdpflW8DSjTwP+2oHaNnE3pZhn9XXjbo0v5ruhoFk68lO+lQWuFEKVTa/Azgt4wmL3R8bI4HcGBjfLbXwOSxwDegnEs5jZ6J/Cb6k+ijVhGqO5hp4spfdnEnXeERyU7jvxGN5ID2L3eYsnveGVJP91cze7lSlPX+XbgAuLh+HWDfgKPEGy7p2ZuJAG08Ppe5HrUlfbBfwQqKUIZHoXc5k95sPVTGibfCkBKUFAQmrL1/FA4st7SN6w2TygO6J/JyBKSK3GfZaSp8LoS3OWP+VbPBiYTVTMaSTgCZnfVHTpRlCzodRQEjEy5EHzzMO6hBWoTzGzdKdnNX64LKy2HIbX+fFD547A/voxUmmzFmnOffkgpA8H9cXjCH7hJGCWNiIpokVY1FLXQq7beMGawFE1o5Wa2WtwezubEihTxN9oL30hSgWWhquBzO1U879tn
 jhJkESJL
 /P4ayOZ5x0k5k7yMg9b9RWmuwnnMtNsRZA3ML+B6Xx3iQ3JjvmXBlsOmcegFw+IhJJPhRJ0tKH0ifoWCPkyPkbm/uAQzsYqzBi9MGKVF+NoV9KynUR4e92e9B9Yqp6H9OgM+sJ3o12p5a0yjiFCqe+QRuPGmBf4vsu+88dFUu583Guvn3ByQeyzLgLQjiccjwmg96t7+X7CgAoBDJ273p1h05dZvjAovSZI0HTwtnXO+FMjqrPGS6YmPXuCyNCFsQTXBEzGwgU5HOIQQPURQkA7EOjIlUr8ZYiY8jOFnmr8JwJqAITRlJEdhpwEgs1b6a9A2MTkZG8L2XNIR2c4Ylx3vN/cSk/uxc4+JFJJWDO0wFjqEGcdJNzIQr7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 5:57=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.com> =
wrote:
>
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > alloc_gigantic_frozen_folio().
> >
> > hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > leading to a null pointer dereference kernel panic.
> >
> > Fix this by checking if nodemask is NULL in
> > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> > back to any node with memory, keeping behavior consistent with
> > alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> >
> > >From a userspace perspective, this bug allows an unprivileged user to
> > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > configured on a subset of NUMA nodes.
> >
> > This can be reproduced by booting a VM with two NUMA nodes, restricting
> > CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> > hugepagesz=3D1G hugepages=3D0), and running a program that allocates a
> > 1GB hugepage area without reserving, restricts allocation to Node 0
> > using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> >
> >   void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >   unsigned long nodemask =3D 1; /* Node 0 */
> >   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >         sizeof(nodemask) * 8, 0);
> >   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> >
> > This results in a NULL pointer dereference:
> >
> >   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >   #PF: supervisor read access in kernel mode
> >   #PF: error_code(0x0000) - not-present page
> >   Oops: Oops: 0000 [#1] SMP NOPTI
> >   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >   Call Trace:
> >    <TASK>
> >    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >    alloc_surplus_hugetlb_folio+0x6d/0x100
> >    alloc_hugetlb_folio+0x3c5/0x660
> >    hugetlb_no_page+0x3d9/0x650
>
> Thanks.  I'll queue this as a hotfix while we await review.
>
> > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepag=
es")
>
> It's a good idea to cc the people who were involved in the to-be-fixed
> patch - Author and Reviewers.
>

Done!

> >
> > ...
> >
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int ord=
er, gfp_t gfp_mask,
> >       if (!hugetlb_cma_size)
> >               return NULL;
> >
> > -     if (hugetlb_cma[nid])
> > +     if (!nodemask)
> > +             nodemask =3D &node_states[N_MEMORY];
> > +
> > +     if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> >               page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
> >
> >       if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > --
> > 2.55.0

