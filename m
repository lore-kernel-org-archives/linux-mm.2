Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE84D74EDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680DA6B04F4; Fri, 23 Jan 2026 10:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA506B04F6; Fri, 23 Jan 2026 10:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B846B04F7; Fri, 23 Jan 2026 10:09:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B117D6B04F4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:09:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E51C1403A1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:09:07 +0000 (UTC)
X-FDA: 84363561534.08.F105DD7
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5398F1C0007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:09:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EWElQHCV;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769180945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTPFJHsp7+e3p+AgGMM8NKUKVszz8QkOczw1QOR6pB4=;
	b=MPGLvaa9CLqW1HelOVJetB3GlCO8DH4rEtnVDcCrOp0W0BXhJV0h9k8aOdGK3zRVJlGGWy
	m+ThN5nSVNAv2yA/nL6NCtXf7tiwl9BQwg9AQC+2RV2bLFD9zkUPIMPeRMKaajRsNhnJFq
	aT2G5kJTDr6NgF5y1kPWjv/dK712B3s=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EWElQHCV;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769180945; a=rsa-sha256;
	cv=pass;
	b=nz2Eh23l9j2QcK+9qjW8wXrFsZCEbx7K6vDzwEcBBEY6ZG7tSbHMVnEm/yrMJiOrbu6PlP
	7a18+A69BGp4coS/B/7xo5CccgEUfYkIbYbjz7oP1y45YXjLlXUNPc0QyrNsPUsbskXCyK
	FB+uHKUBZHh8ztUkiV0Oj7/dq9zKGUg=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59b6f267721so2041340e87.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:09:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769180944; cv=none;
        d=google.com; s=arc-20240605;
        b=Rh5YmLMtrvjh0/hbUJAqARqBASjqn3I90+gWEp214Tn2cYbhqFQkyoVm93CN22iE5g
         71gYL+7Um8uh8M0FDxMVrkS14dzd5+IUiHQZQmk9CGkNL/QT2PoW2ukbUIlCs4p36s0P
         I/oM+eA4g5v/zXCFzcQ1XnETOPU3TrZdz5Vc+qmG6ptGiBTEcKW+GM60ObiftlWBlfMk
         vC2U64Zs2WpeNeUNcCvQNBGLre1nGU3Gh4klHg3dcU4pgXCHvfciryEy9u/UzDlpay08
         r3KKSrSSusl/6DQ3c8iPKI/lPgDrXJJSExxEwSa4ws/ba3jAUNvRxDJYyTtO1X469hYV
         eWGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hTPFJHsp7+e3p+AgGMM8NKUKVszz8QkOczw1QOR6pB4=;
        fh=zQT6uM1IpPK/A3S5/4yDwQBVL5UVTdwrYYKb8fr9GzI=;
        b=TXSwdDnjRG2hYMlK18SdeZaBvKOfgNHM2q/iSff01VHwrjeYc0EeABDK7hizenxUwL
         7xeHmyhej0BO0wtxUpoaeGMxOtFZxoOWyehtV8EX3W0kYGx0PzUh/TYXXcZi9eXRJlDY
         MuU8tkkTLamH6kcH1tXBCczl4ZuQ9+X+LxSWGJwZlqEzCI2YyXS5uX7cB8rjAIEPb4D/
         AFILyE2dIIKEj476beKUr7ugC10fkQKwiF55hy/4QcJGWr4tpxCyS/VZJ4X8gXkoRkF8
         wWpWMwUIp4sp+8B8k1rsQp8uLK03TswXdK573u/rgXgWQkgi3RladvLnAbyzcvEVR+7u
         ZUSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769180944; x=1769785744; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTPFJHsp7+e3p+AgGMM8NKUKVszz8QkOczw1QOR6pB4=;
        b=EWElQHCViykPlmD4G0qDd851P02QVjwEyUxeLjSI26zoBJ5vbWvA2XTYamyKEXyV+h
         sr4asZ9SfEp2dOgELr49gA2Q5bOHI5MAJkFQnoIP9UKssk3o+envppkM+3DEB3+P1NNz
         TWX6i+Po7RBFK/srXtEQzyCZfAbvlytkGI16kI2/jemovKeTQMgcKf7m+aptxysaQKaA
         sgdORhM+vy6TDtuMsiW2eUcijBIb36PlcaXtiKuexdNbq5RtOhn9eya9Xe1JyC+QiEBJ
         xQxeqIBn68mj0LZ/kAZ+Ai2xTO5tS/mmHOPbdxYD+88GXUEyLFB+muHCYyuLU2ILkzs0
         QlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769180944; x=1769785744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hTPFJHsp7+e3p+AgGMM8NKUKVszz8QkOczw1QOR6pB4=;
        b=NBEk36+/zNeIn1rQeqssT/5DpopREjpXCyJdGrUeQ32E9Hlo5+BlUShe8FqgmBMi32
         U6mJMA3U0hctwS2+bKIpzl7O2zUi1HFHBoayEvIcfIFZ8vNBKH/f0QP/MwCX92lO4DMj
         1OT/Jv1lfowwWAMVkVzSvslsPsjFOnwvrNmLcFnBb8EogHDZAzeGhGnrwV7i9fZkX75o
         pwI7xoWDQGlmp5O/2Wn80Rn7ekOMQqitVrxDDRtiswcsjtAXiD8usLUPAR2c9Vzw+46y
         LWkML4xwA08XtwU6Jn2rtVHX/u6EIQmRxxjuDxu9+g/j8d2O2AneZ/4BwUortJUGK44S
         bJ4A==
X-Forwarded-Encrypted: i=1; AJvYcCXk1s4RdJlzaqrMydsU5ePaT6QabflkpLPtTjl296rRwHJ8x+l+x2pgROpeCfpXgOvjj7XdjP96Pw==@kvack.org
X-Gm-Message-State: AOJu0Yz2rAjlvlBT8c938z4swFI8amQ23BaZdv3R4TpVp16jyYqMNRXg
	NgyFdvZvQ6SFehTmiDoXChG5hqQWl4s/ND4fju75FrAYwKSqyinvLAyZ+OLeXr3qfCKbqcS6GKX
	8F5MoXD3bLCvh8qaoFDiv54k7PYqIEVXwWjlRt3U=
X-Gm-Gg: AZuq6aJmiG6qHLb624KacIY/BSy0ySP/ljZIWKLgrH1WNGo6Z++E6g9UEN/JOu73gFi
	rpD7YtGDTc1mO8nH1i6IihFEiusQgxlXc+I89WNAJxXvaIfA1ULKxqTTAwJLGpluEnIKxN6+Ikk
	S+4+ILAkyl5DTt3dV82YW1Uzdkxs9a++PnMvZq8rzOnS2Cpaw5a18fdaPUBXUZ0JWsqseddnHZr
	KQ20uZedTQZ8NnyRpYgyadaQvbdYBmJxj0UMraFWv1hJk0WBPoCQhlCqX3zQu2lpt2Ud7s=
X-Received: by 2002:a05:6512:2513:b0:59b:9fee:2602 with SMTP id
 2adb3069b0e04-59de49130bamr1104247e87.19.1769180943292; Fri, 23 Jan 2026
 07:09:03 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-5-vernon2gm@gmail.com>
 <5820b1e9-3c45-432c-84aa-638cf92fd240@linux.dev>
In-Reply-To: <5820b1e9-3c45-432c-84aa-638cf92fd240@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Fri, 23 Jan 2026 23:08:51 +0800
X-Gm-Features: AZwV_QhS1nxlj2EnvC6I8sFHl5Yi8lcT62VM-jATdm2GqT5TT7YIjjiTEulfQKc
Message-ID: <CACZaFFPCZfxG+FK9rrefFi1UmtWxiOf2j6KXx+9JDJfcHBz8ww@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 4/5] mm: khugepaged: skip lazy-free folios
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	david@kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7c199a6j67541z4q34qxcg3t9wsjd9kh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5398F1C0007
X-HE-Tag: 1769180945-473568
X-HE-Meta: U2FsdGVkX1+BtttZSC0ijxXdxg8kAM+MUFGbDUmx8dEnKU/yBTU8p/uylw1B0X346zusgApQtSnT6aLnjtbube+YWH7PFQX1g74s2zo6QhqG3bxdQYd6DPPZFfycNw8PVti2c9mh36dWdTLmmEmQKpUT4pZByRC+WQtOgmP873IdwawyQEfpVdcEvOgKt3TjDvK4YgegXNUES8OBc91MbP8ByRE5ix/ij0CPM30cjmJNvnYaVdKXWLBBdVGJD9Vqj69JAZouMRgMwKFH2VBgw4HGwd9V7Cr6zybATL+Lx2eBrz1rSmkiL8o1+bFaf6/V+03Onl5rpvBimJ8bHEw1WGusjo7/bG4XEG+8Adh0uZMYo/vnEf0uruEIItoWbKKPZ/751o58zwTt8xcamkx+EQ86NJph/ffSXZkbJV/5apkbsmOMCUzOnzlB8IwwLBW7NMtuba0a8QcLmPksUwAl3s9juCkorTTwuYho/I+skiGXpMrRtG+OXWGO19jQXYwSQ8Qy5rnUreMjZ9Ft1OLbq5jUrn0hhoR5ZXlRySxsjvLyuxoqnF0y9DZn/rMQpjjT/NLcemCNOH9qQm8lRqzaPUi+fCF2q1koHEb77uFCIjq33Enit2NKAnyI6Y0ZZhOENJrHfx5U5U8FgFFL1WAucU8iH2bWTOdWBZkOkhmaBwGtIqInMW6X9/tzbSc+l0j+bw/b51TqF6iZhzQ3A/aaFhKeb0/3MpE9q5q17bgL+P++TkhIZTHv1szIH4XWsBpzTKtlbLQCGBUpBkN/qQoW+hrqRhRQCZJzxtkhA7BP1WuxD/CVgmYyxakR0FsKenx95oROM8h+2nBZMRziZ59eIrR+LiSa5G9vnAjQr3/eTT3/iKAahLyRVadSSlEW+JPzD4phvDPkJdykYsRXGjsUmyT7VOYG+NRx5Ja2/Eh4wT+SKC6VRAC87tKegNUqrSYWY1rYeN1roakr0fMB/LT
 TJXcrNzD
 eytSnyVJJMv925frdEYfR9ZdgHO2fHXpItb7E76H5wTev6vazogbYEBQKnH2kv9uC1GpRarS098HtUiErUd5BADeOFCcAz0JmNDiJm8CxxjIMLdK2xjvC1fQiaT0Gl/cS+O/v4kL4tZ5FuefcTxGrn51Hhk8uukdpxUV8CXJeukLFxVhom5kphZQoxXyaJCtHTvx2jtpsOBGAIKN8dpWz2V1YoJzBENbrdELVPLfMQ/mLa7VVSfL0b/5qBtCmv66MuTW8NLiFHXkKcvkDm/U9xGGF3e2zhl8N99PBJBPABIpZYLv20GjGMHCKjJPtoFBy0zXzDhSm6Nft1zdxa1cJz43eXQCsQrf53OXatDjj5NcwP/iNztpIh7QrzvEjny8S+LRmN1TiHXA+DQ7/H0FvsdL5oA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 5:09=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> On 2026/1/23 16:22, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > And if we collapse with a lazyfree page, that content will never be non=
e
> > and the deferred shrinker cannot reclaim them.
> >
> > So if the user has explicitly informed us via MADV_FREE that this memor=
y
> > will be freed, it is appropriate for khugepaged to skip it only, thereb=
y
> > avoiding unnecessary scan and collapse operations to reducing CPU
> > wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   include/trace/events/huge_memory.h |  1 +
> >   mm/khugepaged.c                    | 11 +++++++++++
> >   2 files changed, 12 insertions(+)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/=
huge_memory.h
> > index 384e29f6bef0..bcdc57eea270 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -25,6 +25,7 @@
> >       EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
> >       EM( SCAN_PAGE_LOCK,             "page_locked")                  \
> >       EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> > +     EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
> >       EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
> >       EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
> >       EM( SCAN_VMA_NULL,              "vma_null")                     \
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index de95029e3763..be1c09842ea2 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -46,6 +46,7 @@ enum scan_result {
> >       SCAN_PAGE_LRU,
> >       SCAN_PAGE_LOCK,
> >       SCAN_PAGE_ANON,
> > +     SCAN_PAGE_LAZYFREE,
> >       SCAN_PAGE_COMPOUND,
> >       SCAN_ANY_PROCESS,
> >       SCAN_VMA_NULL,
> > @@ -583,6 +584,11 @@ static enum scan_result __collapse_huge_page_isola=
te(struct vm_area_struct *vma,
> >               folio =3D page_folio(page);
> >               VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> >
> > +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
>
> I'm wondering if we need "cc->is_khugepaged &&" as well here?
>
> We should allow users to enforce collapse via the madvise_collapse()
> path even if pages are marked lazyfree, IMHO.

$ man madvise
MADV_COLLAPSE
        Perform a best-effort synchronous collapse of the native pages
        mapped by the memory range into Transparent Huge Pages (THPs).

The semantics of MADV_COLLAPSE are best-effort and do not imply to enforce
collapsing, so we don't need "cc->is_khugepaged" here.

We can imagine that if a user simultaneously uses MADV_FREE and
MADV_COLLAPSE, it indicates a misunderstanding of their semantics.
As the kernel, we need to safeguard the baseline.

> > +                     result =3D SCAN_PAGE_LAZYFREE;
> > +                     goto out;
> > +             }
> > +
> >               /* See hpage_collapse_scan_pmd(). */
> >               if (folio_maybe_mapped_shared(folio)) {
> >                       ++shared;
> > @@ -1330,6 +1336,11 @@ static enum scan_result hpage_collapse_scan_pmd(=
struct mm_struct *mm,
> >               }
> >               folio =3D page_folio(page);
> >
> > +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
>
> Ditto.
>
> > +                     result =3D SCAN_PAGE_LAZYFREE;
> > +                     goto out_unmap;
> > +             }
> > +
> >               if (!folio_test_anon(folio)) {
> >                       result =3D SCAN_PAGE_ANON;
> >                       goto out_unmap;
>

