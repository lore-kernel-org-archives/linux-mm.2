Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E66EC01D4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4624C6B0088; Mon, 23 Mar 2026 07:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412A96B0089; Mon, 23 Mar 2026 07:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328756B008A; Mon, 23 Mar 2026 07:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 225266B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:45:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6B06C3516
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:45:27 +0000 (UTC)
X-FDA: 84577147494.23.D8CEA1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id EAB8C80010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:45:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IaO2ZNaY;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774266326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXqhPFyOIKbs9TNwHbBifRArE30hNwjemGxtoFG89sc=;
	b=BZ7QBMVB5l8s+y1fcQ8jO8RKNvTQi/r/HuWn42Pe7BV5DH5AaM1ZwRNUiH7fIJnIZ5unme
	5s/D4qLfL7Qpi79HIaoCjC52twLhmAIy/ecPu9Vd4O1JC0xpnAE7epn00Eu4f1g7anD3Xa
	Gjq/o/g274vYrsgfrBNQISZIXZpKN88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774266326; a=rsa-sha256;
	cv=none;
	b=r0lIyuX8SswnpOK9w1FxZ44Jl7qDTAg4h8xxrxKn16Wo4HmarhCh8gQpbYxZkEuVqqwmvx
	htQXJb9DaFQFjj/SXQGMVTLbYH6IMg5XNlpFhVHZVWs4Yac2J5JHpx2T9+advYDCA6OvEN
	PqKTSEcsfqgXFAPK3JkNWWNXJvrzmiQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IaO2ZNaY;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0223643F47;
	Mon, 23 Mar 2026 11:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7A6C4CEF7;
	Mon, 23 Mar 2026 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774266324;
	bh=EFrQNo4nBOFwBb3nQYf8p6c6hV1JNXav5FiIm59Enoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IaO2ZNaYIvbccNI9QdODEObUue2cJ8BO9thS2A+s9DDgh1OMeJMwZ4sh/ckR9LA0u
	 H/HQwuqYVHsN1kQ9p2V70R5rXLN3s6v9tOE1Zy6hjoU0lv3dfCLLdFMK4utH09nxvb
	 2qx+A5j1xefi4pYc5yJKMBVK+P+KlQQM7/TPlqJfWY8+8sgXkDqvKZx188sD8riEVw
	 D6J0oJZrd4l6k+fAfwPIbtT7KnJzuiOYF44VeOzxpYcI2gHgyp7dNnqM+/2zucmz5n
	 kKMit0gdgX3YY3ttwhBmy5/hZfTi3okpsmxAH52Icl1kUMIrnsSbXQJMqFKIguYNuG
	 jWJ64Bw15VXJA==
Date: Mon, 23 Mar 2026 11:45:23 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
Message-ID: <97a35411-3482-42d5-b0ea-31a5994956b2@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ehta3ickbwdgcn3hufd6ddartcq87w5s
X-Rspamd-Queue-Id: EAB8C80010
X-Rspamd-Server: rspam03
X-HE-Tag: 1774266325-559310
X-HE-Meta: U2FsdGVkX1/7dhVW4zUxeSO/7N1JZjPifH78U0siT1cp/HmpM5YKYcG3sfifz3OVcZ6z4cAiaLEAwHw8YeVyIvoXX1KjBS+WmZHYNznsXXIEmN3pKTBezSFW6nVK/SwTqUjcCGcDSnnuJ04wcJOuBw7CyUVkwy6MjxipkZGvxbyf5piU/UM5OmL1PJ9WfvIiskqr9PYA9fdtOXkkZnb4BFXLMVWLKLlhfuy4xulEAjktFcGldcB+jcxYBkmm+A+DHmJUzPF+TTSTg8Gqos39eKjYGKvea6P86iXmFB+TQ1kvU7Py4dE2ADvssgJa77rkvNhydrs9QgmlnoIMm8pf/bqM2XdT7EiAbbSt8DSHNDlwR+FA6pDPVExgmDwMcKAzuxTVejoRhfd3Z+S1t3lSg6ivfRrIsYiJlQ60BmG52coCE/f05SrL25ylXPCtaovCJoZDxWlNICvjoiWgYAgHs3KnxeMOx0c+sxtkO7e1vKi3o1GIoxuqbWxwaBq0YlU+hZsQ6zySFoaJoFxKxm32b62bkKhSi81HCz5m9og0SxwwOSbl6EXQTY0+B/fZO7LKrt6qr9MHbGDzgY24wj1SsoTDC9vdWs52UpeZKgzghris+Zl2llxPQTOQlnZuQ896c6L/q9SuEDidOOQafBYmfOYYovRZCmfpp0Tte93F2lvRn2O7Mn2sJXWcOtl7OWJzRNm4zMUwVxje9DGxrJ8kQGO+gslt8ZJiBb3YglbIRlwvKIV3kLmJnMWctGBG3+Vv8+UhpXqYaJUpeXx1dCrc3LEp62mzjhe8jc1Fdcgrx508ehf17RYpswV7RRJrwT7KA5ifelIbf/RKN2X4tllxA874BtPrCAr92TRgmPBMjwXq4xyECnwKnNHULcCFNNW/yqRsBPXu8L+gZFzXrzgcsaxjCQO5AVrDDRQYmUUcft+ifTyl2/P4DbalhJTTseYDfN05yWMxxfobqCvkoKw
 lIDmIV5M
 M0hYADKhoZm0wkYFRCEICtrH7/v5VfO0qRg/zjwqFCSoKtFDPKs3jJyRz0lKytxsCQ9kuron8x+9OdR+6dqYU3n+N5eNyzMxLC8mfn/JlRhKb4yZ2jSsF9UURruoi+vpRfMQlVNSP7BYmsfsIS7rQuV49mkfWy1rJhtL/Q3qj5BxcsTdUWiYklcGVCv1kYcEYVFI+9an0WvEsGUP0NidnpnIN4ULQEXQ8JqfZKhXFVkxyyhuSQ3ezH4DUzLRicmVAVi01XYU4cqNHBXeFvpL4OuQ+N5F4DgsTfv45
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Could you apply the below fix-patch to resolve an issue with us performing
folio_put() on a folio before checking it again to see if a table was
deposited, as per Sashiko.

This patch resolves the issue by storing whether or not this is the case in
a has_deposit local variable (as used previously) before invoking
zap_huge_pmd_folio(), then using this boolean to determine whether or not
to zap any deposited table.

Thanks, Lorenzo

----8<----
From 009f8abba834b49f8285b03a680dbd04d953a528 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Mon, 23 Mar 2026 11:42:01 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 610a6184e92c..4585465eda0c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2397,6 +2397,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool is_present = false;
+	bool has_deposit;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;

@@ -2420,8 +2421,8 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	if (folio)
 		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
-
-	if (has_deposited_pgtable(vma, orig_pmd, folio))
+	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
+	if (has_deposit)
 		zap_deposited_table(mm, pmd);

 	spin_unlock(ptl);
--
2.53.0

