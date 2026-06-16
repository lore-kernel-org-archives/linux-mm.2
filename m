Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D73CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3506B00AD; Tue, 16 Jun 2026 16:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D086B00AE; Tue, 16 Jun 2026 16:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4BF26B00AF; Tue, 16 Jun 2026 16:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94FB66B00AD
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:45:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0CC00165723
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:45:57 +0000 (UTC)
X-FDA: 84886957554.08.0BC0377
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id F338AC0007
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:45:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BDLtvHYb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7Yshx7diMX1O/OKyuwR/SBp/Kaw8zYRlyF2SsJvqRA=;
	b=iF5Pq9SycnA+Vhn0NTwqRAe8b0Tf0sHtKIRu4E2EcRL/9nwQ/7jZl/KVGBkxVBCPuzT72E
	ZGdHeq0bPRhLVJhVZWzjlZP4wB3fVOW2PCYgRZYrhuQrAg7O7EUa0mznNBJXocDflSAFXb
	FSJ+PQedj9W6c86YBRfiUsqrNmkpsx0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BDLtvHYb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642755;
	b=2PEltjTe7Zmn0YFIvqQ2W8N8EXGYPv3dM12h1KyqSfZO7pdgmtUduVQ1cgkIoKg8+Bt8uI
	YUvpTUskNzTJLY75WlE0auN2dxoPdqpX071taNftGIHJWOyg5ulLchtt2aJGB9BqLnaCI9
	EUemfPYNsIODtumD4Jcxp3AxZebgWl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781613032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a7Yshx7diMX1O/OKyuwR/SBp/Kaw8zYRlyF2SsJvqRA=;
	b=BDLtvHYbtbBl6jCK8W2J5U0MaZ+1oaEDCCnJQ5XN2nOHOb6aWrop/Ja302qc7D7mNgSFTC
	JhIIPs9BWClMLzVyKktOsLn4D0CWfbprCz/ctP+BoNqWfwJ0yJmum4cSwIH2ADDPypw0OF
	nlVgsdz7pcnHRW7oy9djaeQRtFiomBg=
From: Lance Yang <lance.yang@linux.dev>
To: richard.weiyang@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	balbirs@nvidia.com,
	ziy@nvidia.com,
	sj@kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check before return device-private pmd
Date: Tue, 16 Jun 2026 20:30:01 +0800
Message-Id: <20260616123001.6501-1-lance.yang@linux.dev>
In-Reply-To: <20260616063436.20455-1-richard.weiyang@gmail.com>
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5igqz8nj3shwgbp5e7mtcfzck9tp8syi
X-Rspamd-Queue-Id: F338AC0007
X-HE-Tag: 1781642754-490833
X-HE-Meta: U2FsdGVkX19BKqvvn08wlGBzHWP+Cqb/7WduM3kJQr0WSXxawqcXM+vvek1xPvBg1TQE4g+FD6HDfLhFkha0Rnb9ybBdjh2ZdzRkj/xPdUZazLE8MjhVf3NeabZ+z6UyAy8CBzH8M6cfJ3vF106RFT7fLubN7HZ+ieo46hNpDa1N3zIhuKGPsFYmsL7ffnOqtinJOVbgGX2orvCrAQRHVU4nv/53V5KEZm1wdk1KPTYBtigMN1Nwd+wD6w7Cefheptpuvr2K0cKZ+WEvPeg54kz/Gp8lRFDRl681pm9gC0aR29HBmcpVzTC2nDieZtTpkqGBw9SP4cIvXvPnoKPOEFHH5W0UmoCVmKA2qg3ymR9PX/2BHmtwZbP+pm82t1qaS7qqL4zn8/jNJZqE0UeP5L65FlERiG3Wxuwmism+59vc3AE9mV+zhRFge2vtrfH4jd0HeoAM3mCbd8T5synHtr7Tk0ODNoqyc2crxah9IO3kPzgAuU5vTaB2rHRfJhu1lSoQz8p19sH11eNlYrawO5Kr2UrXpKm/Bs68Oo5XAwtaxA1G5/5FKmkZ7XI5OhIZX/Kmjvk+cLcxle4GG9G2eM087QzvCqVilMXlTq8nbBMYMWsYd7tjdHkW+f2JNuWpQBmvggpxWbpmh2gA/1ECh+KITfRPnL/QK+BhO6LQOFDSXfFt7+ewUXmWkaxegrNr6U8e7swFS5i3Jj89PeCWscYroWivCJNrU/lkIeUrr11h58j4ZhToM343mDXwZoR9DNxVQlM/yuZiunSeEkWERx1Q4rmcaIDTEBY4tETnCr8ASGaWaO6XgVaBFlJwZH9aZrl4Q+jnKAbmYrB2BK1VPGRD0r5OsjIicfwxDlAj0atMnOZGaGAANBgLUuZNF7F7lF2G/L8SD1lDT2VOZouNey7MVTf+s6mYCY75otITnyoJlsmNek9VLVFaKutupyKvKgDwryVah8q85xxKgQe
 KqCIQrvh
 HpOsdI5ozJBzjslRNM4rV0C3ws2Tvd1VKXyrESiJP1TjN6NyyScb0KCQ3wDIZoGFlnY1n3jj+OLFXMQgK5sAK/5pWmHtyRYa2+DrP72SLRpIiyCWePh0rNb3n7lXOnjG4B45SeVVrEqjN4tNFOtVoV7ReJh3yNwe+ocEaADA1RO+OXhPSVotf/dXILGy8KIJxHOXzbE2fR0Ptwkuve2Ns9vNU4MTHNZcy4K9nIZPQyuz229C7rGsbTMikq9+zPfCybI7RNOVykc7NxDqu4gIqcu4gzIfzfqiY8zVafAiLYOHnNa/4oYIiFkkorzaB1LLlZGkUVPBM3+gx/UI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
[...]
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 2ccbabfb2cc1..21635fab209c 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 		 */
> 		pmde = pmdp_get_lockless(pvmw->pmd);
> 
>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>-			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>-			pmde = *pvmw->pmd;
>-			if (!pmd_present(pmde)) {
>-				softleaf_t entry;
>-
>-				if (!thp_migration_supported() ||
>-				    !(pvmw->flags & PVMW_MIGRATION))
>-					return not_found(pvmw);
>-				entry = softleaf_from_pmd(pmde);
>-
>-				if (!softleaf_is_migration(entry) ||
>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>-					return not_found(pvmw);
>-				return true;
>-			}
>-			if (likely(pmd_trans_huge(pmde))) {
>-				if (pvmw->flags & PVMW_MIGRATION)
>-					return not_found(pvmw);
>-				if (!check_pmd(pmd_pfn(pmde), pvmw))
>-					return not_found(pvmw);
>-				return true;
>-			}
>-			/* THP pmd was split under us: handle on pte level */
>-			spin_unlock(pvmw->ptl);
>-			pvmw->ptl = NULL;
>-		} else if (!pmd_present(pmde)) {
>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>-
>-			if (softleaf_is_device_private(entry)) {
>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>-				return true;
>-			}
>+		if (pmd_present(pmde)) {
>+			if (!pmd_leaf(pmde))
>+				goto pte_table;
>+			if (pvmw->flags & PVMW_MIGRATION)
>+				return not_found(pvmw);
>+			if (!check_pmd(pmd_pfn(pmde), pvmw))
>+				return not_found(pvmw);
>+		} else if (pmd_is_migration_entry(pmde)) {
>+			softleaf_t entry = softleaf_from_pmd(pmde);
>+
>+			if (!(pvmw->flags & PVMW_MIGRATION))
>+				return not_found(pvmw);

Looked at history a bit, and I wonder if this changed something old
here ...

Since 616b8371539a ("mm: thp: enable thp migration in generic path"), PMD
migration handling took PTL before doing PVMW_MIGRATION/PFN checks,
including not_found() cases. So lockless PMD read was just a filter ...

With this fix, true case gets final pmd_same() check, but this
not_found() case happens before taking PTL.

So a !PVMW_MIGRATION walker could race with someone, e.g.
remove_migration_pmd(): we make the not_found() decision from old PMD
value that still says "migration", while real *pvmw->pmd may already be
present again. We return without ever taking PTL :)

Not sure about practical fallout, but should these PMD-level not_found()
cases also take PTL and restart if PMD changed?

>+			if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+				return not_found(pvmw);
>+		} else if (pmd_is_device_private_entry(pmde)) {
>+			softleaf_t entry = softleaf_from_pmd(pmde);
> 
>+			if (pvmw->flags & PVMW_MIGRATION)
>+				return not_found(pvmw);
>+			if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+				return not_found(pvmw);
>+		} else {
> 			if ((pvmw->flags & PVMW_SYNC) &&
> 			    thp_vma_suitable_order(vma, pvmw->address,
> 						   PMD_ORDER) &&
>@@ -286,6 +274,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 			step_forward(pvmw, PMD_SIZE);
> 			continue;
> 		}
>+
>+		/* Double-check under PTL that the PMD didn't change. */
>+		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>+		if (pmd_same(pmde, pmdp_get(pvmw->pmd)))
>+			return true;
>+		spin_unlock(pvmw->ptl);
>+		pvmw->ptl = NULL;
>+		goto restart;
>+pte_table:
> 		if (!map_pte(pvmw, &pmde, &ptl)) {
> 			if (!pvmw->pte)
> 				goto restart;
>-- 
>2.34.1
>

Cheers, Lance

