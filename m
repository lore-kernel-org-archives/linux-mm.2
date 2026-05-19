Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52975CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 19:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7656B0005; Tue, 19 May 2026 15:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A982D6B0088; Tue, 19 May 2026 15:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986776B008A; Tue, 19 May 2026 15:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87FE46B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:04:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34B791C1E5A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:04:52 +0000 (UTC)
X-FDA: 84785096424.10.D2AED6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0FC1140016
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:04:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YYgoZEUq;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779217490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdK8pqH2D0m9mcbmDtYLUTUETzL6tUWdDDlDwj+C1AA=;
	b=huDA0KAJUqMbhthlz116l7l3Vx+4Xso78h2KWYzj8dYFc7/VJ/3jLJzXgMaJhL+nqCxgDp
	u4rPErFFixki9htYMs+8na1yEmHf+cUxZHZjQSBo9ph9PhFzl4KGYYcmXsJEgdzmhOimm7
	7jddWxDl4Tzr9mnRwsX7S+1N2Crm58M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YYgoZEUq;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779217490; a=rsa-sha256;
	cv=none;
	b=t+5bI4tGyh97fh4WgA5GMxQuWiS9BiF6tm1sTdgJe6AMbSWs6cPy/6mB5xnpZkKHCZ1twe
	PEwAGFhURj/mcwqJI2EXhsGLpQrM3zgiPZR9HvDsmOuNtLyS7ooe5LvcxDdKqcHVDxKkY4
	Y4Bg9rCz4uelC+mQ9Q420Ag4tRTsMkI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779217489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EdK8pqH2D0m9mcbmDtYLUTUETzL6tUWdDDlDwj+C1AA=;
	b=YYgoZEUq5nlicAl0QwjBKagKQSq/m0e7kUaXQmtM6jHxYmCkSiG82fHfTyI+uqNWBk6hNZ
	fJi+NnWYVWyQ5zr3aanMH2er6ZoPM/qTFay9JlB3LTmWNMCcZ+ENsSBk97NcVl9Is2mq6a
	OBVx+lRC68KFr8dRs3h4d8SVcdYE3/4=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-4YclIvnoMWiu5NIc0GsGNw-1; Tue, 19 May 2026 15:04:48 -0400
X-MC-Unique: 4YclIvnoMWiu5NIc0GsGNw-1
X-Mimecast-MFC-AGG-ID: 4YclIvnoMWiu5NIc0GsGNw_1779217488
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-651c92dd649so7959443d50.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 12:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779217487; x=1779822287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EdK8pqH2D0m9mcbmDtYLUTUETzL6tUWdDDlDwj+C1AA=;
        b=m2LcAk/8SQeeXrxRBCbKxdBJBs6dLSlqb+RAq+6IP1FygP7CFI4srXeygAR8t5IgzN
         rJjZAdkazh3pFNk5tzCUMzub4mQCZJETxXNtjTlyYPCr68XIO3J5n1HxZz74ENbq/AQC
         t2i5ys8E5GCfP1MhKz1CM+IOT9LrvG+oC5Q6yQZ7/j6Ei6KzvFnV3tvFoNWW1ivddQTg
         v2AI10jKaTYJ0eUB0kVTMjKAdUo0PMfWhgCLH0ltgyNA19XN0AQT4+0ToKP8mnrwwSMV
         LNblb4lNfpAOwR2vscfwoeg1MfxYiEXlHMeZ8jJYujSmJJoPbr9SmGZrj6UVjt8VLfvR
         kzZQ==
X-Forwarded-Encrypted: i=1; AFNElJ/8m6PEuXQ+Pr3rUGqMcGfHsSLSDmlnsL2LU9cS9su6xSKQaywPHrFAnW0aaoZ7R6Z1tOCNR68GGQ==@kvack.org
X-Gm-Message-State: AOJu0YzPaYSopJHo57tq2MiB5+2nbI3ZgE78HQzF+UuVTJOp6sQUClj7
	K4HVIa+muWYF1K6MqIgj6p98AaZorDWT7uglhUAthsfuWGSReYJw/kZyeQOM0/5WI8b0+yiH3AC
	uyX0V+a1hIfUVrNiX1KFG0/ubZkR3Ll5hXQfIscvoKHF4f7ULzoQFqxdN73h8xp+T2CszWjS5At
	aWeFeHqEllvRbKT0GoeL3ocihUI4E=
X-Gm-Gg: Acq92OFQkulIxpsyTTGhwqhyTl+fAsCgctS8cULwPD5jJjIlBRqCKjrAquWLBiQY+3A
	kSug/TgNq7pdGwJBqkl+HhanilNJp8KvUZo7b3CB5jaJE3lSb9WyEBu2Sut/38RXmVeHNOuax5H
	ZPq5zp9fjzH/DgSDg0emXIgqixNrBo02av5CvZIP9pxB1hu3q8BZ+r8eir37dvXmpRvPKI7m4gH
	VTx5Q==
X-Received: by 2002:a05:690e:2501:10b0:65c:47ad:26bf with SMTP id 956f58d0204a3-65e2273392cmr16423682d50.26.1779217487443;
        Tue, 19 May 2026 12:04:47 -0700 (PDT)
X-Received: by 2002:a05:690e:2501:10b0:65c:47ad:26bf with SMTP id
 956f58d0204a3-65e2273392cmr16423607d50.26.1779217486858; Tue, 19 May 2026
 12:04:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260511185817.686831-5-npache@redhat.com> <20260512074202.10253-1-lance.yang@linux.dev>
 <20260514031009.f66cgop3ctgiqxz3@master> <9b33339e-157a-45b7-942e-3be3418a5142@kernel.org>
 <agtpK1x27B-E7mMo@lucifer>
In-Reply-To: <agtpK1x27B-E7mMo@lucifer>
From: Nico Pache <npache@redhat.com>
Date: Tue, 19 May 2026 13:05:13 -0600
X-Gm-Features: AVHnY4LuRYw_wlCmtpeGYvsNgJpUKgBu0LIIMlaqigtwM5P2pHzw9Gmm6LpfRD0
Message-ID: <CAA1CXcCNT51jeXh6Kwg1QN9e+AJB-1hg21kmeY6fTTKr2GACug@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v17 04/14] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: Lorenzo Stoakes <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iPZ1sOcVje7vGeAQXBBI4L-41T4soPIfN2e7wva1kgA_1779217488
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6jm7gmxhqm3964aeojuaoqc6ijkuz9ki
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F0FC1140016
X-Rspam-User: 
X-HE-Tag: 1779217489-14450
X-HE-Meta: U2FsdGVkX19sEUeFoe5bn/4hcskmM1A0HTiyq/nznlsZRnA5QW4Lvb6fJu5xyfw7xG2dHjo3iBycMBD/KzuE5aR/TOFbJ1lGz2Ke+pEPcOtInls381V357a6PGMfQNdH6hjWSzle6Tpp7MGrfFFa5lsAOV3QcP2oL4c+oteBRHVS3J1dEsXZT6oKarsc22GFS18IK9/GsNYWiZOsAYKOf8KYZR4a+gw/qWt8sOOgQviQmBsHSG8tRQnaYk5f1tuTliv/Q6e50vlEPxt/5Zp+TLVCd2UTAoWjBMcyR+0onO08r8hacYOKEpSXOif6V1jipbtVk+mzbCf2nXrHeXbhzBawODX8G8AAT4+WFG03fI9mfQIlFmknP/8fWVcflxAu+dg2XN1B5EyBEZ35SbOiboFPKPPa0TUmQV7zA5xZFFjyJ4Gy34N5bdYt+o4H/Dc0UMii3JshGcTcYxkrH4E9xErv4FyCbCNnTwW8KBr1h2UH2ZwOrFsdKiLCySw5FoEZ99Y2L+V2cHyVPjWoqBuQjy4yEtOseBHn5iV1bTaJTgNPcUkWJjeVM4059skPPICqzFmv/BFAEl3HVH/mraHqVtyMBjW4/pUD/ZArTgCEakbhw0bKi6DH0PGz2yuQlVWk+b4DpCAdrAzsywUsh20NSpSFtemPSS54myPNKD+TEyIL9prCWNWj/E7htBBOVF7xGQRmdtWYARk186c9k4S2+osSjxSWCHB3TFK5CuJB15/7bDEkeMLuGQe0AXq168Awg82kI08JukrbEqT3zVtkibyNCMn1AN+3KdD1y1WzIUfnzqgOyDYI5aBaBXBxcYIshoXGXqkOi0AtNn1IWEdYiUfFswNkN6b892wRheu7kLGemKrH4G4PhDFbn3ZU16qzFC1EiSMS0VwS+OIoLI6bmTIdIi2cp3JNAz0TjUVDZUV8DSxsSoo0ANDM1GP0SooegwqiM2xYP54a7LaSH7V
 mp17p1+o
 qX9pKaXyQxalC8LxqS4RVmCZAu8vT3FNQ9m8CqYuunWYJbnAEXmwSptGg9PhBOP+PhpjZoxU7jBvdIXISX7T8G+rsWEsC10SCbsFTaLJw+Lysq92kWP0lgz2SS9kDSpUmGYvodVmMInRu4eJggce15fWYQWu1W0gbkerPisErXChEffREzNOT+oFi88xENE58o2oSlPTVSk8vP+RUbWBwyF5w7XLNdqYLjb8jgWTbKmiB6Enpl+WsLGcpgOOXgf4U7qzoIx+OW5uLj9YWsjtmV+EuTV9+y33NTW7jGEYWplICZOB/7OcOv7L2zgOF2wBcbSg7UP9F/e4twodD5qHRJgLPaFCLYX+dZ7vEQDDGpTXI4ZMN9RpvtqkN2m9BXRH4nd9pUQQIFjErgfoEJ/RjHEoFTHf3MjQG7NEJPXJutwZN/bXg4Kf8k3ak2M1OwF5SAy9kS4/4AugJJCxudfPGGyTOTH3YmrPiLjFqA2VV9XzJ8+jI/3buc32QnGoXpgDdDs4wx5ZyzsSsOYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 1:33=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Mon, May 18, 2026 at 03:16:11PM +0200, David Hildenbrand (Arm) wrote:
> > On 5/14/26 05:10, Wei Yang wrote:
> > > On Tue, May 12, 2026 at 03:42:02PM +0800, Lance Yang wrote:
> > >>
> > >> On Mon, May 11, 2026 at 12:58:04PM -0600, Nico Pache wrote:
> > >>> generalize the order of the __collapse_huge_page_* and collapse_max=
_*
> > >>> functions to support future mTHP collapse.
> > >>>
> > >>> The current mechanism for determining collapse with the
> > >>> khugepaged_max_ptes_none value is not designed with mTHP in mind. T=
his
> > >>> raises a key design issue: if we support user defined max_pte_none =
values
> > >>> (even those scaled by order), a collapse of a lower order can intro=
duces
> > >>> an feedback loop, or "creep", when max_ptes_none is set to a value =
greater
> > >>> than HPAGE_PMD_NR / 2. [1]
> > >>>
> > >>> With this configuration, a successful collapse to order N will popu=
late
> > >>> enough pages to satisfy the collapse condition on order N+1 on the =
next
> > >>> scan. This leads to unnecessary work and memory churn.
> > >>>
> > >>> To fix this issue introduce a helper function that will limit mTHP
> > >>> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - =
1.
> > >>> This effectively supports two modes: [2]
> > >>>
> > >>> - max_ptes_none=3D0: never collapses if it encounters an empty PTE =
or a PTE
> > >>>  that maps the shared zeropage. Consequently, no memory bloat.
> > >>> - max_ptes_none=3D511 (on 4k pagesz): Always collapse to the highes=
t
> > >>>  available mTHP order.
> > >>>
> > >>> This removes the possiblilty of "creep", while not modifying any uA=
PI
> > >>> expectations. A warning will be emitted if any non-supported
> > >>> max_ptes_none value is configured with mTHP enabled.
> > >>>
> > >>> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> > >>> khugepaged_max_ptes_swap parameters, and will fail if it encounters=
 a
> > >>> shared or swapped entry.
> > >>>
> > >>> No functional changes in this patch; however it defines future beha=
vior
> > >>> for mTHP collapse.
> > >>>
> > >>> [1] - https://lore.kernel.org/all/e46ab3ab-a3d7-4fb7-9970-d0704bd5d=
05a@arm.com
> > >>> [2] - https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c826869=
8e9@redhat.com
> > >>>
> > >>> Co-developed-by: Dev Jain <dev.jain@arm.com>
> > >>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> > >>> Signed-off-by: Nico Pache <npache@redhat.com>
> > >>> ---
> > >>> include/trace/events/huge_memory.h |   3 +-
> > >>> mm/khugepaged.c                    | 117 ++++++++++++++++++++------=
---
> > >>> 2 files changed, 85 insertions(+), 35 deletions(-)
> > >>>
> > >>> diff --git a/include/trace/events/huge_memory.h b/include/trace/eve=
nts/huge_memory.h
> > >>> index bcdc57eea270..443e0bd13fdb 100644
> > >>> --- a/include/trace/events/huge_memory.h
> > >>> +++ b/include/trace/events/huge_memory.h
> > >>> @@ -39,7 +39,8 @@
> > >>>   EM( SCAN_STORE_FAILED,          "store_failed")                 \
> > >>>   EM( SCAN_COPY_MC,               "copy_poisoned_page")           \
> > >>>   EM( SCAN_PAGE_FILLED,           "page_filled")                  \
> > >>> - EMe(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")
> > >>> + EM(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")     \
> > >>> + EMe(SCAN_INVALID_PTES_NONE,     "invalid_ptes_none")
> > >>>
> > >>> #undef EM
> > >>> #undef EMe
> > >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > >>> index f68853b3caa7..27465161fa6d 100644
> > >>> --- a/mm/khugepaged.c
> > >>> +++ b/mm/khugepaged.c
> > >>> @@ -61,6 +61,7 @@ enum scan_result {
> > >>>   SCAN_COPY_MC,
> > >>>   SCAN_PAGE_FILLED,
> > >>>   SCAN_PAGE_DIRTY_OR_WRITEBACK,
> > >>> + SCAN_INVALID_PTES_NONE,
> > >>> };
> > >>>
> > >>> #define CREATE_TRACE_POINTS
> > >>> @@ -353,37 +354,60 @@ static bool pte_none_or_zero(pte_t pte)
> > >>>  * PTEs for the given collapse operation.
> > >>>  * @cc: The collapse control struct
> > >>>  * @vma: The vma to check for userfaultfd
> > >>> + * @order: The folio order being collapsed to
> > >>>  *
> > >>>  * Return: Maximum number of none-page or zero-page PTEs allowed fo=
r the
> > >>>  * collapse operation.
> > >>>  */
> > >>> -static unsigned int collapse_max_ptes_none(struct collapse_control=
 *cc,
> > >>> -         struct vm_area_struct *vma)
> > >>> +static int collapse_max_ptes_none(struct collapse_control *cc,
> > >>> +         struct vm_area_struct *vma, unsigned int order)
> > >>> {
> > >>> + unsigned int max_ptes_none =3D khugepaged_max_ptes_none;
> > >>>   // If the vma is userfaultfd-armed, allow no none-page or zero-pa=
ge PTEs.
> > >>
> > >> One thing I still want to call out: kernel code usually uses C-style
> > >> comments :)
> > >>
> > >>>   if (vma && userfaultfd_armed(vma))
> > >>>           return 0;
> > >>>   // for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
> > >>>   if (!cc->is_khugepaged)
> > >>>           return HPAGE_PMD_NR;
> > >>> - // For all other cases repect the user defined maximum.
> > >>> - return khugepaged_max_ptes_none;
> > >>> + // for PMD collapse, respect the user defined maximum.
> > >>> + if (is_pmd_order(order))
> > >>> +         return max_ptes_none;
> > >>> + /* Zero/non-present collapse disabled. */
> > >>> + if (!max_ptes_none)
> > >>> +         return 0;
> > >>> + // for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_=
PTES_LIMIT,
> > >>> + // scale the maximum number of PTEs to the order of the collapse.
> > >>> + if (max_ptes_none =3D=3D KHUGEPAGED_MAX_PTES_LIMIT)
> > >>> +         return (1 << order) - 1;
> > >>> +
> > >>> + // We currently only support max_ptes_none values of 0 or KHUGEPA=
GED_MAX_PTES_LIMIT.
> > >>> + // Emit a warning and return -EINVAL.
> > >>> + pr_warn_once("mTHP collapse only supports max_ptes_none values of=
 0 or %u\n",
> > >>> +               KHUGEPAGED_MAX_PTES_LIMIT);
> > >>
> > >> Maybe fallback to 0 instead, as David suggested earlier?
> > >>
> > >
> > > It looks reasonable to fallback to 0.
> > >
> > > But as the updated Document says in patch 14:
> > >
> > >   For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1) are supported. Any =
other
> > >   value will emit a warning and no mTHP collapse will be attempted.
> > >
> > > This is why it does like this now.
> > >
> > >     mthp_collapse()
> > >         max_ptes_none =3D collapse_max_ptes_none();
> > >         if (max_ptes_none < 0)
> > >             return collapsed;
> > >
> > >> max_ptes_none is mostly legacy PMD THP behavior. mTHP is new, and an=
y
> > >> intermediate value in (0, KHUGEPAGED_MAX_PTES_LIMIT) would implicitl=
y
> > >> disable it :(
> > >>
> > >
> > > So it depends on what we want to do here :-)
> > >
> > > For me, I would vote for fallback to 0.
> >
> > At this point I'll prefer to not return errors from collapse_max_ptes_n=
one().
> > It's just rather awkward to return an error deep down in collapse code =
for a
> > configuration problem.
> >
> > For mthp collapse, we only support max_ptes_none=3D=3D0 and
> > max_ptes_none=3D=3D"HPAGE_PMD_NR - 1" (default).
> >
> > If another value is specified while collapsing mTHP, print a warning an=
d treat
> > it as 0 (save value, no creep, no memory waste).
> >
> > In a sense, this is similar to how we handle max_ptes_shared + max_ptes=
_swap:
> > for mTHP: we always treat them as being 0 for mTHP collapse (and don't =
issue a
> > warning, because we would issue a warning with the default settings).
> >
> > @Lorenzo, fine with you?
>
> Yes 100%, this sounds sensible both in terms of the error and the default=
. Let's
> keep our lives simple(-ish) please :)

Ok thank you im glad we finally came to consensus on this! phew!

>
> >
> > --
> > Cheers,
> >
> > David
>
> Cheers, Lorenzo
>


