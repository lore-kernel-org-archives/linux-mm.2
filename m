Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86309C5AD5A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 20:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5EF6B007B; Sun,  9 Aug 2026 16:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496FE6B008A; Sun,  9 Aug 2026 16:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3864C6B008C; Sun,  9 Aug 2026 16:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0853B6B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 16:11:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9F02405C9
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 20:11:50 +0000 (UTC)
X-FDA: 85082826780.13.35B3FF4
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id E397014000A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 20:11:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rsTQnBan;
	spf=pass (imf26.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786306308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BK3ib28Zt9ouaq6sGPwRxjwPJJdGLDF6aP1bdV6S2zE=;
	b=2+6/66LvhA8O7hUEaS96yXYpqymrMamkLgoiBykZz+0cCcdE4uOvt2tbwuzrdZV/p+fJfj
	q73fvPGL/yg2krZF0qX3sMj/fhBuwOP5E2nmkjQWtw3AbZgWCS/wyiioRXK3FKqC/s38B4
	5WfJiIS30hhlkz6s+E8LoiGWOt4Ohm0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786306308;
	b=xktE8NMeImtJHb31Egu5mivJdSgV+ck5ZD5lstLYwbojUMWajkiJVOgpZVbQ2VV/hwjkyP
	N9n9SPB0TAdh77LrrwYEusX7xvZFCFt1KQOzW1+VaF3bTVSnM1bd6IVlShgR9kuBbvfggc
	oi/xCf/EkS5WazSYtBEHKQWLfJaXhvQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rsTQnBan;
	spf=pass (imf26.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so4397e87.0
        for <linux-mm@kvack.org>; Sun, 09 Aug 2026 13:11:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786306307; cv=none;
        d=google.com; s=arc-20260327;
        b=NGG+kfU5qwcyi0kj/cVA2yQ7rzDXKWMuCdb6woR9vFp9fUOHg3oAZCsSS9V1omCV6r
         L4I8Rt2t27eZHBSrMjjdDPuPMvXgW+kEUJvU7MsB/lahRCwyiDVjwg/AVrGQGSf9LNaf
         7rNS8SYT829F0XsaIF6NYJktfGnyT/4CE8/iBJKzviXgdZiECUhEVonp2JmYkV4HxmlB
         H2bCv1aG1rziXBlolv/umM+BseFsC9y0SNEXuoSjsz6bn2JAr9j1r8Yygva4KxLajR1C
         6K8YFnSq4XIpezIuaNjHGrBL3i+ePZuoNi3/+QD9+ocKmf6cbtpP/CKi5m6JuuQIImD1
         rd2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BK3ib28Zt9ouaq6sGPwRxjwPJJdGLDF6aP1bdV6S2zE=;
        fh=LbVyxa1R0t2OT/YRW0T5oYyc7wGf+PQWydIC85aqsjQ=;
        b=R4gulBh7n3agoAwXMb3jqo21+vtXJOw1PbL+HfPBzzbIiZI9oPrS29bmlUEko2/GZK
         UnHbh00O+nZm8WpBmfg3nG5q7HTPdVpch396PKwoZvR3G+H3zAOylj9Ggovb8MCZWdKu
         9R3pakfYOhf2Xi/Iw55L3fDB8QghSKtzvDLcDcjOA/LdoysFauBm29sqq3X5H6e9Ayce
         JTelKuFoSBsfQigo1qQB15/z7ZLOSm4zFXa0uUBwFFqysKNetZzSJehpr/WISNrxUuzt
         xXVoGB4w9fZm0kXzbtUAFGHieiN/TZxbXEnBGgceKBfKpUEYxJIQp7NJdbHbu7bU9La/
         IsDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786306307; x=1786911107; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BK3ib28Zt9ouaq6sGPwRxjwPJJdGLDF6aP1bdV6S2zE=;
        b=rsTQnBanb7seDN8Qr4hLGm3GBvVCB0M0qDaewch7wumw+Hv4Cpo3NGebEqxpINaH2o
         pkvmKx3BXfVaAc1uueE2BKA1CpUtfBlOXy3b/8Ny3Im6P18Yzm9jmy4XxpSOq/eES2om
         ox/RHLiJ3z3CbpVx8zWtIcYruR0Fc0Xm0LP5T+HuQfmlde5PVVkQVTE04hZQutcgvVKP
         eQ59jKrH7xbpIF6+Nikp6FbH+3LDBaHjbTRaO2tKd2GRTmuIFjMHak6IewKf+nInTNU2
         nqBVaow6glMY+hzYkQiFVSR/xODD4Jo7RbAyG0J7mmyTu5HRAwDZkeeCIeTQLef7GVNn
         DdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786306307; x=1786911107;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BK3ib28Zt9ouaq6sGPwRxjwPJJdGLDF6aP1bdV6S2zE=;
        b=foWANu/DkpoEgvlNTJvYYBPr/3XKuYKq0dGHxtVvQEAKYpSoJEy83AiCXeSRPO3M0K
         T7ZE4lO4StMC7SaYhm6rv1bbcOGqSSEHKoownoaKp90hEEio+AQiccHJSdSWYJHygAO4
         1h3hZGSVm1f6Z/KYxgEHIrGQVq2Dlt13zDfYtWK8aIRZmj/uQ5+fKlOT7vBzw5jkWvkG
         TCC9dY1o/MeexZP1Db5BFbRHISbK7yV4hw2t5BFmKzeqXDIw0kuVo0v2q9ErqzugQJVe
         zAY5/m4041FCuLSakc1LJAnPLtHrv5ltwtIaIFLymFQGXcTbaRxKWKzVGvYudzpZaIs3
         ytRA==
X-Forwarded-Encrypted: i=1; AHgh+RrMt964qcl8IJuLmAnBlfHWQS9m/8z6/SBgl6GVAwhmHm0v+LYWYaa2UWsy/E5KhWLs18rJlgZwYA==@kvack.org
X-Gm-Message-State: AOJu0Yy3KSt7GPlZ7DP+4TvrlkBdQjSTEZaJMU/9UQ9Ozu/Z/lF8Eyfr
	pjw9cm3WgNKEup6eKkkleV/SqHLe4OPfVnc0lba1pzLqvkj7F4sL13bkkZe3JLqrQkD4FP+VFi9
	p6c3Es4vXiri4befBq25RGivOAlt8M5B/Prli1cGZ
X-Gm-Gg: AR+sD13th0F4BG/MeMhXTG7X/QYHSJpElEJNzy8NBE4EQ+YYcFowbnNFsPLBHzcWhhs
	p6GWH8ZlT0h1LBY8TZ5imrfkim02MGyUe1WRt9Kxyz55KBuA/lVsrW89lNcjHJkYWuDgLTnphzJ
	E88OjYGU953tS0HPtjzXAo0BiWPEOGycFH126so4UgsqTzkptR85QvOk6HrFNmwjnix/yPN5YXW
	exvvhWGvlk5ZkY9pPs9aLIUOEw0atX5cxTameU7ecLaN1mmdsWWoDJhiP/JBY01ODyzLTgdqKRV
	W92DbyEg2uqxMkhsX1bw3IQsyv+xxeOa/a3OGH+TTiajTqDBMLPX1gMycbpcFbTPBAHdblBl7NG
	sOGsh3d1gPe0ONy/lCQ4/VxHu87Ha2Fdp
X-Received: by 2002:a05:6512:1593:b0:5b1:571f:715f with SMTP id
 2adb3069b0e04-5b30dd6c9eamr80451e87.3.1786306306644; Sun, 09 Aug 2026
 13:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260809043250.2917406-1-souravpanda@google.com> <E2FFA328-21B3-4E3D-8CB9-5638B4CB545B@linux.dev>
In-Reply-To: <E2FFA328-21B3-4E3D-8CB9-5638B4CB545B@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Sun, 9 Aug 2026 13:11:35 -0700
X-Gm-Features: AUfX_mwX3l0SoZzxDLWxWWTL55jMYns3GuJZleGUtmU6HaagqkfWDfdA-Xz99iE
Message-ID: <CANruzcSySUn_gLEh9kxwvatSCn4hizcy6v2BkcMe0Jb=HoUOSw@mail.gmail.com>
Subject: Re: [PATCH v5] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, usama.arif@linux.dev, 
	shakeel.butt@linux.dev, wangkefeng.wang@huawei.com, anshuman.khandual@arm.com, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	hannes@cmpxchg.org, riel@surriel.com, sj@kernel.org, vbabka@suse.cz, 
	mhocko@suse.com, bjackman@google.com, zi.yan@sent.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E397014000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: h1it4on5gatfoqqic5onp747y5kmy9qj
X-HE-Tag: 1786306308-775187
X-HE-Meta: U2FsdGVkX19+pESLTjTmONOboHNlEZPiTIdWbR35QtgFlvg9zlvRRkpIZIETVVbLAXoqM10jEJv4BoaBwvkotNeyboIUPrs7mnep7spXTF+LBMXlZWTxJX5hIG28fmSd2NMYj2nz3DOCS+rhr9lfv7aT8PoU1yKj39Yd2sOva4ZqkwkX78LP1/24l/Bc7hXY88ZmR/VQxEc0qMagu5YGpgBixGmD4fT2s8kyqAiRWkTX8fVH/HWzZSGcQflrXyVOa3BvuERMje7Y45RcxnHIphCLMY8mQRajCvNvTuZxr3D85obA3sC8+SoTOJopuzVk9gkkqV8AAChsMw//QPu0MxIyTD6iPysrQm7eTwihyeMJA9GhEkMgEJKUPfeCcnJQ3tPYUb31yTwnyRyLkZ8y7pXTFoBQPLH4oFW3UdkEptDRgTgm9195y4LCZMedME1ptiP64GuWe2gCW9GedCNTKDiFAI8W0vFOzUv2pQVOZqp+PExtLsBxLhdxqbD81BKlRPiKig3RZOjERAbluyTaSWqZX8ttip9+X716X59eXCCI/n38zKN8PXcr4JEiPrICJbk635DGTiJpvZlmS/nSgT2FTArSsxltrRtxKSPTL4ZogTr0HZV1JfQh+3rz5nF68fg00N/loi3WlYIu2qp8rBFb5BQlp2D7KY34fczmwWlpbng42hy2gNiL7RMaIHsm8tg2onXs/cCSwoks2Y4Vtbld3SZrn8XstWm1OesYoe0n96jUiIreYa/B30d3irRX7jGoUG5s2ME8fdbwdrZOcqFFDv1Iexy1FhllCFVZWUJCtDlUP92ZZu8xWChzFGyRcVLl9I4fOLtReGzXNxXy3EHK7oFXkPHFLAxS5bMhbZBAUhazhyD1EthJUUKXIyu99w/Foee+2ET08fuYqzAGvyQGrRshtKxxAPkMviLEAUKIpzxxlEthUu1l/5tCpBv4+Zk/oMcXb5nIbgq4ejI
 plhi861i
 A636YUsjBu2VJOGzxw2i70Ie+8s9Wt7PyaUyNdmTo03FCf/99Ro1ZBGHOZN1usk3FKSWYo7ZWGrM6NmlUrLQnlh5uws6PUoLyxRWNHc/ej4oFSwVOn5UOMnszaFa9SBCMGHB+CgL7+khQuJES2hLsVCKBcYocAjV9RezsGA3LzWUYx8J8mAOmiRUkGAOA5vydJibjxGhKy9zI7RXaxxrYcmf2h0LQX9AdlySWSYCRTbakeIw8GsCVczdFObsMPqic6EdJ55n8cIl6CH3DAm3ztEim+S3E5uE2yyxaRhvzZycVa69BRBgA0DgvpG5XfuZ18WPVWeL2C5Yuads=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 8, 2026 at 11:58=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Aug 9, 2026, at 12:32, Sourav Panda <souravpanda@google.com> wrote:
> >
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > alloc_gigantic_frozen_folio().
> >
> > Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> > allocation on hugetlb_cma[nid] without verifying if nid is included in
> > the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensure=
s
> > the initial preferred node allocation honors the memory policy / nodema=
sk.
> >
> > However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
> > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > leading to a null pointer dereference kernel panic when nodemask is NUL=
L.
> >
> > Fix this by checking if nodemask is NULL in
> > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > cpuset_current_mems_allowed (safely read using a seqcount retry loop).
> > This ensures that the initial node check and fallback loop safely honor
> > the task's cpuset without violating cpuset constraints or causing NULL
> > pointer dereferences.
> >
> > From a userspace perspective, this bug allows an unprivileged user to
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
> >  void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >  unsigned long nodemask =3D 1; /* Node 0 */
> >  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >        sizeof(nodemask) * 8, 0);
> >  memset(ptr, 0, 1UL << 30); /* Trigger fault */
> >
> > This results in a NULL pointer dereference:
> >
> >  BUG: kernel NULL pointer dereference, address: 0000000000000000
> >  #PF: supervisor read access in kernel mode
> >  #PF: error_code(0x0000) - not-present page
> >  Oops: Oops: 0000 [#1] SMP NOPTI
> >  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >  Call Trace:
> >   <TASK>
> >   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >   alloc_surplus_hugetlb_folio+0x6d/0x100
> >   alloc_hugetlb_folio+0x3c5/0x660
> >   hugetlb_no_page+0x3d9/0x650
> >
> > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepag=
es")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > ---
> > Changes in v5:
> > - Replaced defaulting nodemask to &node_states[N_MEMORY] with safely re=
ading
> >  cpuset_current_mems_allowed using a seqcount retry loop, ensuring fall=
back
> >  allocations comply with task hardwall cpusets as suggested by Usama Ar=
if.
> > - v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravp=
anda@google.com/
> > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpa=
nda@google.com/
> > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravp=
anda@google.com/
> > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpa=
nda@google.com/
> >
> > mm/hugetlb_cma.c | 15 ++++++++++++++-
> > 1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index 39344d6c78d8..3ae9347078e9 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -3,6 +3,7 @@
> > #include <linux/mm.h>
> > #include <linux/cma.h>
> > #include <linux/compiler.h>
> > +#include <linux/cpuset.h>
> > #include <linux/mm_inline.h>
> >
> > #include <asm/page.h>
> > @@ -30,11 +31,23 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int or=
der, gfp_t gfp_mask,
> >       int node;
> >       struct folio *folio;
> >       struct page *page =3D NULL;
> > +     nodemask_t local_node_mask;
> >
> >       if (!hugetlb_cma_size)
> >               return NULL;
> >
> > -     if (hugetlb_cma[nid])
> > +     if (!nodemask) {
> > +             unsigned int cpuset_mems_cookie;
> > +
> > +             do {
> > +                     cpuset_mems_cookie =3D read_mems_allowed_begin();
> > +                     local_node_mask =3D cpuset_current_mems_allowed;
>
> I think it only makes sense to move cma_alloc_frozen_compound() inside th=
e
> loop. Otherwise, during subsequent memory allocations, we could still fac=
e
> unexpected allocation failures.
>
> Muchun,
> Thanks.

Hi Muchun!

What do you think of the following diff? This way
cma_alloc_frozen_compound is also protected from stale nodemasks.

         if (!hugetlb_cma_size)
             return NULL;

    -    if (hugetlb_cma[nid])
    +retry_cpuset:
    +    if (!nodemask) {
    +        cpuset_mems_cookie =3D read_mems_allowed_begin();
    +        local_node_mask =3D cpuset_current_mems_allowed;
    +        nmask =3D &local_node_mask;
    +    } else {
    +        nmask =3D nodemask;
    +    }
    +
    +    if (hugetlb_cma[nid] && node_isset(nid, *nmask))
             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], order);

         if (!page && !(gfp_mask & __GFP_THISNODE)) {
    -        for_each_node_mask(node, *nodemask) {
    +        for_each_node_mask(node, *nmask) {
                 if (node =3D=3D nid || !hugetlb_cma[node])
                     continue;

    @@ -48,6 +61,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int
order, gfp_t gfp_mask,
             }
         }

    +    if (!page && !nodemask &&
unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
    +        goto retry_cpuset;
    +
         if (!page)
             return NULL;

If this looks good to you, I'll send out v6 with this change.

With regards,
Sourav Panda

>
> > +             } while (read_mems_allowed_retry(cpuset_mems_cookie));
> > +
> > +             nodemask =3D &local_node_mask;
> > +     }
> > +
> > +     if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> >               page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
> >
> >       if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > --
> > 2.55.0
>

