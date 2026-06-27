Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83968C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 02:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD576B0088; Fri, 26 Jun 2026 22:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F036B008A; Fri, 26 Jun 2026 22:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028426B0092; Fri, 26 Jun 2026 22:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0CD06B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:07:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48C254065A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:07:25 +0000 (UTC)
X-FDA: 84924055650.28.53539A4
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F15C20002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:07:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C3vIod4V;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782526043;
	b=mxEQbNDQt8BmaqGNS2xhPNtLBcIrDTyahu49t2Uh0+E2fJeLh8SFoMqjN6+E+jZ4a6rhBC
	c9WErh05YKZWvZ9zA/QXahUBJ+XA/X3BeFXNP6C2A7Qgbmbvqe5ezsgxbRupz0vIZ+bD2r
	Mmh8UeiaVFet/v2q4KpX8o/06DjF5Gw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782526043;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6iWoHyT3Z02ic2G+1Q8eT2akEj38fCKCoF6qFakARc=;
	b=Eq2HsDUzR9Kao1d4Gdgve1fFUzPc4FGu7tFw+zN5McSIUPd/gRk03GS2ILjF9/UE1z87hS
	s3yT9R0P4cMAuq5mMuZeGnCs1ieQ1/hOEOnH7BOH9kjcjPl7aBsTukgOIk8FgbpKR/6gkc
	rYPwpjxO9gucaYcflRi3PNTNsiMVB1w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C3vIod4V;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-697764213d6so2695178a12.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782526042; x=1783130842; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u6iWoHyT3Z02ic2G+1Q8eT2akEj38fCKCoF6qFakARc=;
        b=C3vIod4VnO+NNb8vqSkzNOh+I63pXJHH+JgfitOxSrmWiFedSwF2nw9vt/Mn4n6H4u
         DvEF89NpXO1uwDaZVRda7+Jdkovd6AL+GGL3tPY/pb5BIDS8ajp8cMrX70sr6e4+qhHw
         a5QdOIsFXufbW3RJgOqr2tBORdVvfuLFxvwYeYP8o0axE9mtLmAYEFGkR+1pwIYsJmVB
         HpOOPnY8TBA+tFm0GQ9sQy3tyyH57cjER7KMsKirWWfV7tN3JymGgma5mxaTVeVxuhm+
         Zd31EfC/HdgTVQ5OfF0YksBUlnvlxidgF/g8kgRokCFhQA79KT+FUfjgBo/g8kGq7NVH
         BQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782526042; x=1783130842;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u6iWoHyT3Z02ic2G+1Q8eT2akEj38fCKCoF6qFakARc=;
        b=qffkJZVr0P/EthFrXYZ7G4mFv14ax95s9BHciHhwI7h+k8qsy15BYvoOmPvtKFU5Ls
         /t5dtXEQ2mYc1jF6Uj/zldbp4CakWMgZCImyeBgHKUBrO8os+pBEBcpfvKb79cpWFEiW
         xTZPq/v5gSF3BtD6/XceQupBdEsu6B8Vj/A01GwlIPAmxB0tkkFKSIRfj+moFNr//5O0
         6BWgYKaPY9T2cLSKRDcj3y5JcJHybOZa3JJWcAEV5Mf7U/UXCNu4Vhrsry+QWhnt3Jrb
         C79L66LMDxCokMXujLBOeDyvgzaMBkVDW+q3mbCepe1UwhOH7G8LLziuXIyaCZijCGnz
         DzHg==
X-Forwarded-Encrypted: i=1; AFNElJ8Br2XTOJjv36f5o/fJzQA0wO0CyFqPSeQJCf71wpIVDxybYnGSRz7K9c2ZvKbGJhJzHI2oUVYDlQ==@kvack.org
X-Gm-Message-State: AOJu0YwCHQR6fN49GqMnNLBrz25GRcKaP6YoIuf9+ZdZL5inKcnBDi7B
	zCY2AzIkNZR513+zIA2mK3ZTrkff4QiXoYROssLjIq/INHr1PGFVlJrf
X-Gm-Gg: AfdE7cnG6nMWVa9yRpIsR+M/WcUeo3kqSt/bIRijPwBNQ+JliRrfBGRie5RmYL8XqNp
	RDuHzyvifeorbA0ZE4nOCq7TXDkcNFCNDZD84Iec7lr7akLxCn5tUPr/EEfYCC1+8gDTpLZfIph
	NKIPoy2wXSqCpX7bTaCJnX6yXQ+tib7PEUzLd5EsONDXxn0wg6fm4OMAbJhxxBsQpNETM6sYxed
	d/FTaVHDlinwxx3t1Lsma/VRRrLJykQaiUBaicmiRI//Q0DF5DHYJg+F5m1Ma0q3qVQJPxoK3cS
	szogK/IJEvIa+8qp5MESm3NJu2WujErs8iFiWbc7L+Ouq7aNqNADALsaSM7bY9WZhqDdq59UBiw
	oCgI+MqxVr/IOq8GT2wNUnMyQ3sByBSjlB4UeRDgCX2wP8ATqhOuz2718S/mI95S77u6zx7VvRM
	rONPUSIvYBe5o=
X-Received: by 2002:a17:906:e10c:10b0:c12:222a:9864 with SMTP id a640c23a62f3a-c12222aab9emr224537366b.51.1782526041535;
        Fri, 26 Jun 2026 19:07:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1226a58d0dsm163048366b.35.2026.06.26.19.07.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Jun 2026 19:07:20 -0700 (PDT)
Date: Sat, 27 Jun 2026 02:07:19 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <20260627020719.ipzfrlhfbvr6ac35@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5F15C20002
X-Rspam-User: 
X-Stat-Signature: ki8sqqd4ouff45mum834jksw3ww6j763
X-HE-Tag: 1782526043-344426
X-HE-Meta: U2FsdGVkX19XGy763kxcoG3i76rqqQya3gJl+5iuet/5mxY0x24SeDrZcm31IBvnTau0+S3c54rLMQF8NUeUmKQoUO5da6cHdhNgs6XEamwl/F3tW3v+e9lm2SGsWoLI0vlG+WleA07zudHgB2jIBxVRsWkikbTiIXersaE30MZjg7ffnBLm1WNzA880dhpQUVs0xRBzd6KGoPa71hG4z1HD/twuNftwe9z7O2+c1/L7Jr64HSeI/lqGn59AkMMgdKpgZ7r80O6djNjOYDjUTbRhg5O3zFACcKrBxc61io53UsxC0Ylt/AnOkawNB2yftk2MbdnV4yGDRIACsjq8ffb39IedbUXh3Bu9PW6QDQBMHiaFkXPSj4HVte/xKU/H7xP7XyM+MfaPokkSkTw/3cj5jC0y3xK9U0L15/IL88uR3safvJseJJAWYOF5ndwd3SC9vKXzzpuxEx/ugIKb8WCJAVFBV7vvXILWhT9TZSOYubskGovu8h7DssaawmIo6T1UW6B3dUKEYHut5njJ2KzfjK7PCGfhHMrvnN/l2UxyukM0y1sM8glmIcc9dCjglcAAeXuvT3zrcCb40T0XSWdcvTZD/8WAN+JDxkFx/mZRuIeGcf0MkNgSuPNu4gzJrTsxPxSc9gDIkf7bzVM9BtLBYlBU5ywYf7CLxbAYk4+RoYWFy1Osvl0/ugVygsdeSFJOx3H18NSAUAalAoyNGmuUbrIVPU/pWwHCikYce8Y/rRm3knzqImOalunWIyl4jvvRZFaKz3nyuWfG463Cpq092DBg9AVe2/L7sYJBWm/XvpHOY3UxjhcwD06MEm3+Pn/4tfwG33sGDPwoWymLFRICbCuRfZ2Qm0TD0UfO5gfWWoihSSDhXwWFHJNqCs02IRKC+KOW5yakf0+ez672ue+YSQDQbSZ24AYV+Y21PEfpFMfOtsZBsK3pe9ko0wyDGtew1irPXn/IZc/SeKx
 SRJFjmTl
 pk3gThQqKcG844YSpwFOGZdfgIKqY/RCQtIQu9wFNSS/XzVotyUkDV+KBBM7KfrVTzmeIG2KU68jR+StTaZvJD1vaz9p9Pu5BNBAW1T6Z9jnfGJkJ2KKyQIcfZA+VldLigouBQJ9szwf3TCReigXrmjlmsxL9iwX8i54SfVPqTi8ow5S6WwoZYyZtJum1XDty9Ri9j8vNNDUDdc5H9rQIv7XodWBZnALiF0Frl8w01PSaUh0z70letW0R1fGmMzpXNJDPn1jYW2DhsrhIh+Ecnl8JOii/6ETY5pHyEaQSmFXmvJYfd+Dfbd8fSAsPMYBSGP6sh1Rbw3iNczBOxGsfCtNiSQul8/2SQMKscTKFcdpxWwO8VpBf8biDJYCei0BQcGPXGqwLXQOOGjgxFVqxJJnQ/hr39gzOBNEnZrsVuFbhTb+5xfAUPUD7UgZq1nnp0nQh7bbu0aZVGgLaomcIn26YmiBYQSPEKq2Hyze7lBsVqPTvi2dCTeS1wSCv9JoFh1rEGupjLiFIfDzhSeDMNY7Bzl7Or+IHS+mWeX9HZ6PcxOfF11BqSwqmf+U6B8lKo/gaxE8SJBjnkAE/3Og6z7bcqFymZ6+l3VlYG4O095XeqTnS8agqhr4ABAEAfG3NT/FUijnN/+IT4eBeDikcyAThZ5ReJj21pL2ZbY3riUpPaXy68DzAefw5fiHR2jN1w3Au34He2wj3jeZkhOzFGwlJmhyFDGS1KdvmlsfLVdlRgTYX8JCAS2O7igIBo3h08Cib
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 12:07:56PM +0200, David Hildenbrand (Arm) wrote:
>On 6/24/26 08:53, Wei Yang wrote:
[...]
>
>This is extremely hard to review given the existing crap handling here. I'm
>really sorry, but it makes my head hurt (I'm not kidding :) ).
>
>It's completely unclear why we only have to check for a subset of the cases
>after taking the lock.
>
>Could we simply extend the existing migration pmd handling and leave the
>!pmd_present() case for pmd_none()?
>
>That leaves no question to "which transitions are actually allowed", including
>"could we accidentally assume something is a page table when really it isn't".
>
>
>So what about something like the following?
>
>The "thp_migration_supported()" is not required when checking for
>pmd_is_migration_entry(), as that defaults to "false" when not compiled in.
>
>Untested:
>

Hi David

I did a little adjustment like below. Want to check with you at first.

>
>>From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 2001
>From: "David Hildenbrand (Arm)" <david@kernel.org>
>Date: Fri, 26 Jun 2026 12:03:40 +0200
>Subject: [PATCH] tmp
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/page_vma_mapped.c | 29 +++++++++++++++++------------
> 1 file changed, 17 insertions(+), 12 deletions(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 2ccbabfb2cc17..ed2a23a90e8dd 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 		 */
> 		pmde = pmdp_get_lockless(pvmw->pmd);
>
>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>+		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>+		    pmd_is_device_private_entry(pmde)) {
> 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> 			pmde = *pvmw->pmd;
>-			if (!pmd_present(pmde)) {
>+			if (pmd_is_migration_entry(pmde)) {
> 				softleaf_t entry;
>

How about:
				const softleaf_t entry = softleaf_from_pmd(pmde);

>-				if (!thp_migration_supported() ||
>-				    !(pvmw->flags & PVMW_MIGRATION))
>+				if (!(pvmw->flags & PVMW_MIGRATION))
> 					return not_found(pvmw);
> 				entry = softleaf_from_pmd(pmde);

could be removed.

>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+					return not_found(pvmw);
>+				return true;
>+			} else if (pmd_is_device_private_entry(pmde)) {
>+				softleaf_t entry;

The same.

>
>-				if (!softleaf_is_migration(entry) ||
>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>+				if (pvmw->flags & PVMW_MIGRATION)
>+					return not_found(pvmw);
>+				entry = softleaf_from_pmd(pmde);
>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> 					return not_found(pvmw);
> 				return true;
>+			} else if (!pmd_present(pmde) ){
>+				return not_found(pvmw);
> 			}
> 			if (likely(pmd_trans_huge(pmde))) {
> 				if (pvmw->flags & PVMW_MIGRATION)

How about merge this with above? And put at the first case?

Below is what it looks like:

		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
		    pmd_is_device_private_entry(pmde)) {
			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
			pmde = *pvmw->pmd;
			if (likely(pmd_trans_huge(pmde))) {
				if (pvmw->flags & PVMW_MIGRATION)
					return not_found(pvmw);
				if (!check_pmd(pmd_pfn(pmde), pvmw))
					return not_found(pvmw);
				return true;
			} else if (pmd_is_migration_entry(pmde)) {
				const softleaf_t entry = softleaf_from_pmd(pmde);

				if (!(pvmw->flags & PVMW_MIGRATION))
					return not_found(pvmw);
				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
					return not_found(pvmw);
				return true;
			} else if (pmd_is_device_private_entry(pmde)) {
				const softleaf_t entry = softleaf_from_pmd(pmde);

				if (pvmw->flags & PVMW_MIGRATION)
					return not_found(pvmw);
				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
					return not_found(pvmw);
				return true;
			} else if (!pmd_present(pmde)) {
				return not_found(pvmw);
			}
			/* THP pmd was split under us: handle on pte level */
			spin_unlock(pvmw->ptl);
			pvmw->ptl = NULL;
		} else if (!pmd_present(pmde)) {

Test with split_huge_page_test/khugepaged/hmm-test/migration in selftets,
looks good.

-- 
Wei Yang
Help you, Help me

