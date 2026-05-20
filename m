Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBA1CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942E86B0005; Wed, 20 May 2026 08:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F42A6B0088; Wed, 20 May 2026 08:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2786B008A; Wed, 20 May 2026 08:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 682406B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:05:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1339D402DA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:05:11 +0000 (UTC)
X-FDA: 84787667622.22.8F91BC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7246100003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:05:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FHkDkkHg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779278708; a=rsa-sha256;
	cv=none;
	b=HYXhw+OSw+CdmR39JwGiFC9otf6nmwzsQIyS9sUSQUzuCUi0+63lShk69tQc7G8aSxrGfo
	qCbz+hyQchfphGsvZDUiT6XteyaG1dRK3vpCYPBaLoohYtBodiWfIrtKEP2kBqfu1iDXr4
	l/l4YHYVWjubcfaDaHSpBUDECGlH9LQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FHkDkkHg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2ZE/pE5hSr2fTsHeV6QyYnobMcbWzfo9dXFNayhhUc=;
	b=YYkFH7QBFO1hURW8faQA7acVEY/9pQk7jy2uY8ICTLzbwg2QVa1NeDzoc+CT+HUMOv6xaQ
	Urnlfek4zDjXCLf84PM56TL+lPJNuuTtLDNiiV1SLpCd3ayEJ9dqbeKJPdVhiXrN5peWmv
	4Hzrn9Ay237lhgLP7eoih6iEAEsrrkg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779278708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X2ZE/pE5hSr2fTsHeV6QyYnobMcbWzfo9dXFNayhhUc=;
	b=FHkDkkHgpr9YAU2A8N+vbHojm6rhdjBvTTLe519/beS/GRUne54pA1YqJXHxMpvrOR+fpd
	20MT/vNFzh1rloEUhGBpBMNQ79IzdkkMMWl9tJi6cfxn4O1kDNMfnRfA87X6AM5gYYus7C
	UevdMDZBDUMAKTl0g6MFfDqsKyHOORs=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-JODGswopMA-DGvTTHhFpKg-1; Wed, 20 May 2026 08:05:05 -0400
X-MC-Unique: JODGswopMA-DGvTTHhFpKg-1
X-Mimecast-MFC-AGG-ID: JODGswopMA-DGvTTHhFpKg_1779278705
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65db7715a7eso129459d50.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 05:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779278705; x=1779883505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X2ZE/pE5hSr2fTsHeV6QyYnobMcbWzfo9dXFNayhhUc=;
        b=pKmHTiW3Yg2G8l2+5T1QKNNU4yqorhZThM7H1EsYPZqkb957atFJqR7jkuDVlMPlie
         55H15bazg++7wd5QcDg+Ll0C96r11Tx0mU2DozuaJwr9f8o8oNylU1iqK62tefjuLC5B
         34VTFS5zTl6cMB7b5fgzQ+qyp8PHWU4c31CbvNTT4ALcEP6hVEb2U02x5ZmRjfOg5tXm
         qzOue2UJS0fP8odU7xq1lHQ4kbmP0+jmtSH1Us4itDoJhl2d9l+jyiN40a8P7j92Ppwb
         uFFYwh18atiVaWVRdkQIr92SpFbukPrJj/1pYim3id2PYTYvbwb3X/8sDnov35j4MZwk
         a94A==
X-Forwarded-Encrypted: i=1; AFNElJ9qJgAxbM0MqlvRGvCghsnl8tQLrlipZMxRevUaeiRND94oO4q/mIaD43nRns186N7y6xr2SSaUKw==@kvack.org
X-Gm-Message-State: AOJu0YzhIHHPt/lS8Dv2g60pKWOLLDstoC/IwgkHv5r7IgezmfNMFKss
	F/GGffWtp7RjFOXeavCX18toeBFF+jWLbgvpQHs7Nmc+/8an4C5hKgCai8mP5NhLzrF+ihcCXTx
	iR8Goq4UbizaET+uR4UIJEdwyhngmRfmG4NOn7Vv/RpfEtglRZqWEDLLMykSPIvdjZ9iDuPN/sT
	wOlnd56M8X+4I/ny87mW6ngIhhY0M=
X-Gm-Gg: Acq92OGb7GePQ8potfTRGTIRVhyC3UubCZVv6cZUE4AeK9BEhB7cRwmmRFs/VWyRuBR
	Hp7+RzQjTAH4HUX/OgzNNmFYdI8/Vg58IPQ+p42lwiuWqHUBnGwO6w9u0nkWi1K8+pZkjVmwWx7
	VqjUMl/tYuqBhL//12wWMJkuuAQ6oMkj/gL8XsZ7O0gf2Ws9pnixWcZv9Reg5CgvaXIKxYlvH6T
	vBtEg==
X-Received: by 2002:a05:690e:d4c:b0:651:c38b:e60e with SMTP id 956f58d0204a3-65e22685cedmr22029138d50.4.1779278704940;
        Wed, 20 May 2026 05:05:04 -0700 (PDT)
X-Received: by 2002:a05:690e:d4c:b0:651:c38b:e60e with SMTP id
 956f58d0204a3-65e22685cedmr22029058d50.4.1779278704322; Wed, 20 May 2026
 05:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260511185817.686831-1-npache@redhat.com> <20260511185817.686831-12-npache@redhat.com>
 <20260512154431.jxcs632mqqatqtsw@master>
In-Reply-To: <20260512154431.jxcs632mqqatqtsw@master>
From: Nico Pache <npache@redhat.com>
Date: Wed, 20 May 2026 06:05:31 -0600
X-Gm-Features: AVHnY4IloSXg-o2aX0zma4RbhBcFkj0iqvrRQAFcLN19LiuJy6POHEMF7fysqUQ
Message-ID: <CAA1CXcD2KPKFrwCZd2PatQhf_e1nrvCguPD77GcNOVPFZLvsew@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v17 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fa1Nl_J-XrXiqLWfjAqiVHg5TMRELZFmZ23U43kIMaw_1779278705
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ritw9b7awk4rq9ggg3sbfru5mufuxggp
X-Rspam-User: 
X-Rspamd-Queue-Id: C7246100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1779278708-312595
X-HE-Meta: U2FsdGVkX18lxMeyq4ww1e+3vDQC8NRtATntToUE7bQrBalMv51ivuncMOEaYPM4mOSg2mIpppWlI0CAXYi+ddf6eFDHIUDfx5q6sLj2Lc9v3ca+CvfeDuFGKOmqbiwIDltOSPUZA0SjRw+ZWC3E1D1zeoE6RQaU6uHV8bcTFRX9ZmuqcitJVER5+Y1PlB1yUDO0WJvES98XtLKd/Lc02HXUtJX5wclAixNtE/lsSSl6lOrTWy1B6VRvNFUc0Nq+LeoThMulPHzTeoro8i119yIfmMyshwtK5z7CZzVqXTqQoJY93L1SEMadKbPBi5nZwr78qTZr6goSmYnrL0sXX5Cp0ntKN1R1YsFLSEfdrubJuiXr5OPJUhwbMSL5/fdTycOikqIkxwTNO15Fiyz+yre3Ag69/Nzx0kohISpD1lZAilIv6MZHhRInSGLhzmKPEgW84t+ZrBr8WPBEon+BpoQWPK5+DNNkbRoAEraC6DHICYWngB6en9CfRB0Hbg74gm3GOEaUEzxgruKslvVEk+o8jKppsggCLgsPNtsWjFFe3V5qkEcSI3Hs1Tr/lI+kvOHdQSFwWu7giAnfSlVXbIkB210XRUWFPjkMS8/XzPkDKYBAFlkaXsGaWPUqLQ2jKZ52HLpNm1eVrFaIiRO/vXghlh0FQMYwU4Gdw6GEM6gZZn+0A7TRbSENAnscZ5Ywd8nGeSnHturBTkGnxwT6purU6kweT/ohdbuMjRs3CMA6Lv48QgUgJvZtBwxBtLYOGkCKCp37eceLMcuHJVOXsZBkR37LWeETSZNiD3iYzT9HJtK3xJtwPe/DidhNFiGQ0XAAjyMjpcVEg8a6+JYP0NrX4QXXxDhSvSlPKCwmD9dLRtTFwgkBTsG7X5MJl5A3f2O6xYYPKCCvrfUNzfQ0wbx0835GrodshveWSWHfKtYiCjoF8sszN0FDUD3g/+6SO7PIeDcHwIMNyuqqf7J
 DyNVhBsM
 uciTw33KgnpMP3vvEbQG7ATq97pGvpq7v4KQXS107pGT5fD1LwIV67B1b9XWQUqWD+ZXuS31KRuwnhgrNXk9VihKDX3w/0g+h69NtCiYCMZXhO9kBJigcbMZdlu+0kThfx1Tj8J5V3Ucs+QLJavlU21Wzrn581lAoHxhXq7+lncLyzCGg5rYYc9QHNOxkt1ne12OLrLywBpr/avkfwIdN8283EiMmGdEIWVcwe8fiesX7YE9pQ9yhpA2KePoD2H2uarMPxZSsvDFmqKBNZNjHBIg4z935nolDcFLLEJsA8Bi8EWHyNZqg+jGcoHxa0Zk+90pTk+WHL9SfREZzk4+vQXDc2FfKljMisVTe6VGJNk+1oqbQ0tb5SrSUh2WSRR+juQsMNmQ5FJRwLo4gXFuZ6FrgA+I3x8xubToz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 9:44=E2=80=AFAM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> On Mon, May 11, 2026 at 12:58:11PM -0600, Nico Pache wrote:
> >Enable khugepaged to collapse to mTHP orders. This patch implements the
> >main scanning logic using a bitmap to track occupied pages and a stack
> >structure that allows us to find optimal collapse sizes.
> >
> >Previous to this patch, PMD collapse had 3 main phases, a light weight
> >scanning phase (mmap_read_lock) that determines a potential PMD
> >collapse, an alloc phase (mmap unlocked), then finally heavier collapse
> >phase (mmap_write_lock).
> >
> >To enabled mTHP collapse we make the following changes:
> >
> >During PMD scan phase, track occupied pages in a bitmap. When mTHP
> >orders are enabled, we remove the restriction of max_ptes_none during th=
e
> >scan phase to avoid missing potential mTHP collapse candidates. Once we
> >have scanned the full PMD range and updated the bitmap to track occupied
> >pages, we use the bitmap to find the optimal mTHP size.
> >
> >Implement collapse_scan_bitmap() to perform binary recursion on the bitm=
ap
> >and determine the best eligible order for the collapse. A stack structur=
e
> >is used instead of traditional recursion to manage the search. This also
> >prevents a traditional recursive approach when the kernel stack struct i=
s
> >limited. The algorithm recursively splits the bitmap into smaller chunks=
 to
> >find the highest order mTHPs that satisfy the collapse criteria. We star=
t
> >by attempting the PMD order, then moved on the consecutively lower order=
s
> >(mTHP collapse). The stack maintains a pair of variables (offset, order)=
,
> >indicating the number of PTEs from the start of the PMD, and the order o=
f
> >the potential collapse candidate.
> >
> >The algorithm for consuming the bitmap works as such:
> >    1) push (0, HPAGE_PMD_ORDER) onto the stack
> >    2) pop the stack
> >    3) check if the number of set bits in that (offset,order) pair
> >       statisfy the max_ptes_none threshold for that order
> >    4) if yes, attempt collapse
> >    5) if no (or collapse fails), push two new stack items representing
> >       the left and right halves of the current bitmap range, at the
> >       next lower order
> >    6) repeat at step (2) until stack is empty.
> >
> >Below is a diagram representing the algorithm and stack items:
> >
> >                            offset   mid_offset
> >                            |        |
> >                            |        |
> >                            v        v
> >          ____________________________________
> >         |          PTE Page Table            |
> >         --------------------------------------
> >                           <-------><------->
> >                             order-1  order-1
> >
> >mTHP collapses reject regions containing swapped out or shared pages.
> >This is because adding new entries can lead to new none pages, and these
> >may lead to constant promotion into a higher order mTHP. A similar
> >issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> >introducing at least 2x the number of pages, and on a future scan will
> >satisfy the promotion condition once again. This issue is prevented via
> >the collapse_max_ptes_none() function which imposes the max_ptes_none
> >restrictions above.
> >
> >We currently only support mTHP collapse for max_ptes_none values of 0
> >and HPAGE_PMD_NR - 1. resulting in the following behavior:
> >
> >    - max_ptes_none=3D0: Never introduce new empty pages during collapse
> >    - max_ptes_none=3DHPAGE_PMD_NR-1: Always try collapse to the highest
> >      available mTHP order
> >
> >Any other max_ptes_none value will emit a warning and skip mTHP collapse
> >attempts. There should be no behavior change for PMD collapse.
> >
> >Once we determine what mTHP sizes fits best in that PMD range a collapse
> >is attempted. A minimum collapse order of 2 is used as this is the lowes=
t
> >order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
> >
> >Currently madv_collapse is not supported and will only attempt PMD
> >collapse.
> >
> >We can also remove the check for is_khugepaged inside the PMD scan as
> >the collapse_max_ptes_none() function handles this logic now.
> >
> >Signed-off-by: Nico Pache <npache@redhat.com>
>
> [...]
>
> >+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
> >+              int referenced, int unmapped, struct collapse_control *cc=
,
> >+              unsigned long enabled_orders)
> >+{
> >+      unsigned int nr_occupied_ptes, nr_ptes;
> >+      int max_ptes_none, collapsed =3D 0, stack_size =3D 0;
> >+      unsigned long collapse_address;
> >+      struct mthp_range range;
> >+      u16 offset;
> >+      u8 order;
> >+
> >+      collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
> >+
> >+      while (stack_size) {
> >+              range =3D collapse_mthp_stack_pop(cc, &stack_size);
> >+              order =3D range.order;
> >+              offset =3D range.offset;
> >+              nr_ptes =3D 1UL << order;
> >+
> >+              if (!test_bit(order, &enabled_orders))
> >+                      goto next_order;
> >+
> >+              max_ptes_none =3D collapse_max_ptes_none(cc, NULL, order)=
;
>
> I am thinking whether there is a behavioral change for userfaultfd_armed(=
vma).
>
> collapse_single_pmd()
>     collapse_scan_pmd
>         max_ptes_none =3D collapse_max_ptes_none(cc, vma)
>         max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT                --- (1=
)
>         mthp_collapse
>             max_ptes_none =3D collapse_max_ptes_none(cc, NULL)     --- (2=
)
>             collapse_huge_page(mm)
>                 hugepage_vma_revalidate(&vma)
>                 __collapse_huge_page_isolate(vma)
>                     max_ptes_none =3D collapse_max_ptes_none(cc, vma)
>
> Before mthp_collapse() introduced, userfaultfd_armed(vma) is skipped if t=
here
> is any pte_none_or_zero() in collapse_scan_pmd().
>
> But now, max_ptes_none could be set to KHUGEPAGED_MAX_PTES_LIMIT at (1), =
so
> that we can scan all the pte to get the bitmap. This means
> userfaultfd_armed(vma) could continue even with pte_none_or_zero().
>
> Then in mthp_collapse(), collapse_max_ptes_none() at (2) ignores
> userfaultfd_armed(vma), which means it will continue to collapse a
> userfaultfd_armed(vma) when there is pte_none_or_zero().
>
> The good news is we will stop at __collapse_huge_page_isolate(), where we
> get collapse_max_ptes_none() with vma. But we already did a lot of work.

Good catch!

As you stated we eventually ensure we respect the uffd checks. So
there are no correctness issues, just the potential for wasted cycles.

At (1) we only do this if mTHPs are enabled. If that is the case, the
only waste that can arise is at the PMD order, as that order respects
the max_ptes_none value.

I think one approach is to gate (1) with the uffd check as well. That
way, if mTHPs are enabled and its uffd-armed, max_ptes_none will stay
at 0, and we bail early on the scan early if any none_ptes are hit.

But then we lose the ability to collapse to mTHPs that are uffd-armed,
where the PMD has none/zero-ptes and the mTHP fully has 0
non-none/zero-ptes.

ie) assume a PMD is 16 x's [xxxxxxxx00000000]
where x is a populated pte and 0 is not
If we guard this scan (1), then we will never check if its possible to
collapse to the smaller orders.

Let me know if you see a flaw in my logic, I think it's best to keep it as =
is?

>
> Not sure if I missed something.
>
> >+
> >+              if (max_ptes_none < 0)
> >+                      return collapsed;
> >+
> >+              nr_occupied_ptes =3D collapse_mthp_count_present(cc, offs=
et,
> >+                                                             nr_ptes);
> >+
> >+              if (nr_occupied_ptes >=3D nr_ptes - max_ptes_none) {
> >+                      int ret;
> >+
> >+                      collapse_address =3D address + offset * PAGE_SIZE=
;
> >+                      ret =3D collapse_huge_page(mm, collapse_address, =
referenced,
> >+                                               unmapped, cc, order);
> >+                      if (ret =3D=3D SCAN_SUCCEED) {
> >+                              collapsed +=3D nr_ptes;
> >+                              continue;
> >+                      }
> >+              }
> >+
> >+next_order:
> >+              if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
> >+                      const u8 next_order =3D order - 1;
> >+                      const u16 mid_offset =3D offset + (nr_ptes / 2);
> >+
> >+                      collapse_mthp_stack_push(cc, &stack_size, mid_off=
set,
> >+                                               next_order);
> >+                      collapse_mthp_stack_push(cc, &stack_size, offset,
> >+                                               next_order);
> >+              }
> >+      }
> >+      return collapsed;
> >+}
> >+
> > static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >               struct vm_area_struct *vma, unsigned long start_addr,
> >               bool *lock_dropped, struct collapse_control *cc)
> > {
> >-      const int max_ptes_none =3D collapse_max_ptes_none(cc, vma, HPAGE=
_PMD_ORDER);
> >+      int max_ptes_none =3D collapse_max_ptes_none(cc, vma, HPAGE_PMD_O=
RDER);
> >       const unsigned int max_ptes_shared =3D collapse_max_ptes_shared(c=
c, HPAGE_PMD_ORDER);
> >       const unsigned int max_ptes_swap =3D collapse_max_ptes_swap(cc, H=
PAGE_PMD_ORDER);
> >+      enum tva_type tva_flags =3D cc->is_khugepaged ? TVA_KHUGEPAGED : =
TVA_FORCED_COLLAPSE;
> >       pmd_t *pmd;
> >-      pte_t *pte, *_pte;
> >-      int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> >+      pte_t *pte, *_pte, pteval;
> >+      int i;
> >+      int none_or_zero =3D 0, shared =3D 0, nr_collapsed =3D 0, referen=
ced =3D 0;
> >       enum scan_result result =3D SCAN_FAIL;
> >       struct page *page =3D NULL;
> >       struct folio *folio =3D NULL;
> >       unsigned long addr;
> >+      unsigned long enabled_orders;
> >       spinlock_t *ptl;
> >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> >
> >@@ -1429,8 +1579,19 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >               goto out;
> >       }
> >
> >+      bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
> >       memset(cc->node_load, 0, sizeof(cc->node_load));
> >       nodes_clear(cc->alloc_nmask);
> >+
> >+      enabled_orders =3D collapse_allowable_orders(vma, vma->vm_flags, =
tva_flags);
>
> Would it be 0 at this point?

If your question relates to the issue you brought up above, then yes,
max_ptes_none would be 0 if it's uffd-armed. We must recheck the
uffd-armed status before modifying it to 511.

>
> >+
> >+      /*
> >+       * If PMD is the only enabled order, enforce max_ptes_none, other=
wise
> >+       * scan all pages to populate the bitmap for mTHP collapse.
> >+       */
> >+      if (enabled_orders !=3D BIT(HPAGE_PMD_ORDER))
> >+              max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT;
> >+
> >       pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >       if (!pte) {
> >               cc->progress++;
> >@@ -1438,11 +1599,13 @@ static enum scan_result collapse_scan_pmd(struct=
 mm_struct *mm,
> >               goto out;
> >       }
> >
> >-      for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >-           _pte++, addr +=3D PAGE_SIZE) {
> >+      for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> >+              _pte =3D pte + i;
> >+              addr =3D start_addr + i * PAGE_SIZE;
> >+              pteval =3D ptep_get(_pte);
> >+
> >               cc->progress++;
> >
> >-              pte_t pteval =3D ptep_get(_pte);
> >               if (pte_none_or_zero(pteval)) {
> >                       if (++none_or_zero > max_ptes_none) {
> >                               result =3D SCAN_EXCEED_NONE_PTE;
> >@@ -1522,6 +1685,8 @@ static enum scan_result collapse_scan_pmd(struct m=
m_struct *mm,
> >                       }
> >               }
> >
> >+              /* Set bit for occupied pages */
> >+              __set_bit(i, cc->mthp_bitmap);
> >               /*
> >                * Record which node the original page is from and save t=
his
> >                * information to cc->node_load[].
> >@@ -1580,10 +1745,11 @@ static enum scan_result collapse_scan_pmd(struct=
 mm_struct *mm,
> >       if (result =3D=3D SCAN_SUCCEED) {
> >               /* collapse_huge_page expects the lock to be dropped befo=
re calling */
> >               mmap_read_unlock(mm);
> >-              result =3D collapse_huge_page(mm, start_addr, referenced,
> >-                                          unmapped, cc, HPAGE_PMD_ORDER=
);
> >+              nr_collapsed =3D mthp_collapse(mm, start_addr, referenced=
, unmapped,
> >+                                            cc, enabled_orders);
> >               /* collapse_huge_page will return with the mmap_lock rele=
ased */
>
> collapse_huge_page will return with mmap_lock released, but mthp_collapse=
()
> may not?

We are now releasing the lock before calling mthp_collapse, which
subsequently calls collapse_huge_page. Even if `collapse_huge_page` is
never called-- say, because enabled_orders is 0 (which should not
happen) and all collapse orders are skipped (never calling
collapse_huge_page)-- we still return here with the lock dropped.

I think this is sound. Let me know if you think differently.

Cheers :)
-- Nico

>
> >               *lock_dropped =3D true;
> >+              result =3D nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
> >       }
> > out:
> >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> >--
> >2.54.0
>
> --
> Wei Yang
> Help you, Help me
>


