Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FAD8CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF8C6B0108; Thu, 25 Jun 2026 07:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F646B010A; Thu, 25 Jun 2026 07:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C7B6B010B; Thu, 25 Jun 2026 07:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24E566B0108
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:30:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B34501A0629
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:50 +0000 (UTC)
X-FDA: 84918217860.09.6D893F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 11B95100013
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lPhXMZix;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387049;
	b=VS6Acv6woGLvAnePdC1DRduawb4U7AM/MgBmwQdCzEmoskvLHuWPpz/0lirg5vAS/9Ts76
	hhCCkUgkTLi3Bpt1P8o813LOT3FrcerzYKSn4NBczBCac5qqyDGUUnBhlMJ7k6vyt7q+po
	13nQwUOSlxscmQ+UKUa/FHNIxTS43HM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkWkBkX560vkT/ZNr93r8SvU+E+F6Z2wGoY4R3XW+08=;
	b=BZR9fHY5ze4MlzcqHmS9081OFfQp/e2LVSf697MDXe3HbjuYuMfdZRDsrBKwlce3sPkIxP
	dqBxyaAZG3acHaF4qaE01d6yh8WsNLETjujoWagYUIOFjGYPH2t51f0nzvdqfOiXYzAFkS
	ufDZwJ60VWIcgek7++idJBGETTMT66s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lPhXMZix;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3B9932C5;
	Thu, 25 Jun 2026 04:30:43 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 62A6A3F62B;
	Thu, 25 Jun 2026 04:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782387048; bh=YVYXx7DeCmRXI/6Xkq+kjiu0y3ZMotg0IHB7MU6Rf+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPhXMZixeJNC/52qJLXM5cTBoxRiSy5jpouJtE3546YakjPVG02EkqA0y0Pttu6f4
	 vEubb3v+HokNHqXS9u+EdjoFlvwz0SEaMIbm0h2LhhvM0p8h4sr3ODmRvGEXhBb643
	 TyLvs/lWTDqBE7EgRklZegpCtyYIMNccFix02v8M=
From: Dev Jain <dev.jain@arm.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcampbell@nvidia.com,
	apopple@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	mel@csn.ul.ie,
	nao.horiguchi@gmail.com,
	ak@linux.intel.com,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	dave.hansen@intel.com,
	tglx@kernel.org,
	jpoimboe@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Date: Thu, 25 Jun 2026 11:29:53 +0000
Message-ID: <20260625112955.3254283-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112955.3254283-1-dev.jain@arm.com>
References: <20260625112955.3254283-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11B95100013
X-Rspam-User: 
X-Stat-Signature: 7t3rpjasbtjssz79sfaezhjth8k4dfff
X-HE-Tag: 1782387048-202669
X-HE-Meta: U2FsdGVkX18biXx5LGw0ocYardiYV/foNGEvPpZfMfi9naI/tX8a5JME5wOuZHftcwF+XtweUbE4DwJQB2IjHC3tYj2vBp0cHRawZTW1bhnU5EOA4i5LCzRaFkuUMdHsB9wGb45wsE2Cqa8rxQ5BQabFL6J9Tnn2FOjxYgmhLO+1cec0tArrGVS4VYVKvGJfSFERUDzgmlmDVxfw+0lQZY23Sj1S2gIDTC6gQmpslcpXHQen+0MD3iT/M7aQF2cn/5RjTd+oKyZNmobjcoL4dpJluWsghPwlLMd4Uf1766jjTycqIfh0VluQPm6NXCUfcNwIQ/04aCpbfztUib76R5iLNz0U+oFH9YUYfN9tyMgvMuE2qnbeRE1r3qzwmi1ciizND22718CaM+KY96GjrqCDVcvgQ/IIukzrqpAEl1Zr6H8sXYvjSdnulm/D1q8G1ZxnUnM+M0V0ISr72ahPP3/du2XosKAAnUypG7KSCmLZdiEFSmPK4JyPoo0d+lMcHEbQpAmh0ALH8ZGWhL6YbaamsambwEaq6R23bMxbPJnMKPmaCN3GMjXFHCL2Ld447ju5n8SvqqxO794t+Uj+5NbJ7rCMFxag/MI29U+/++tDtzZrgCyIsvLvZgS3McWRuI6UQ9YMVN9h4ItSoE+DVckkOhnn8pRfw2sy2eZx+G3gL9xW9GslRPSngDpWCQOQZjWr/5WR9coVCt2/Ycd4MIEBJ47wM2lYaJSAywaux9+dsk30VWyyQFbsPfvMFRINltldXjPLmHwHTPzeses+vBnV4ss44JoZytfJTgnRaJPmpXae+48F1uRNymuyDgnSELDyLTmlQUe6HRdMWRsekRacvYSARtdIoac4zmYpYdQ9yBQR0HF/2dGaMYZPVxvW7KTr7sNcFE2bjq87XIXVa6WI8KyoFI/mVibC7iRy6BwpQQgeJ7K9KGBN3qZvVdjTTwT5Ezip7YkkOiKbvzD
 52pJvfKr
 jlEF6HPt9FOKiuceRWPARmWw7YfWAtlBt+APgJAw6XYw6j5kmVxlYp23TaELiYNRQBMy3LzmU4/GWmm15qC7izOk8teRk8cnATwc/hck/7PffEyoSFflN38GMOHxrLaTJuh+6bqOV+lZN/vWG8CiPdT3A5IfIkW9w6K4Rj2//ZM0+3WIdi8DqGBItEUXTRo4UO3jWBU4JObfSbX+VnK5uVKzlIPY0DcHY+gU9LXyQ77brXapTMuVmSHxsT69YE7uV0GGzfVacyw50fgwa24OrQpCFqx34faaVPG8y5evdNWhUCeKOtWZ9MFZp55/V/86B1nb4SBF+BwXKFljoBzLl+NFi93cwxwL5SvRfzxPPgykgR/deKXEqR8ZBu42fMbTUaBIfrwmn9R08BCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_pte() is the final validation step in page_vma_mapped_walk().
It reads pvmw->pte with ptep_get() to decide whether the entry maps
the PFN range being walked. For hugetlb VMAs, that pointer refers
to a hugetlb entry.

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(),
pte_present() etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Cc: stable@vger.kernel.org
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/page_vma_mapped.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2ccbabfb2cc17..18e1d341f463c 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -107,7 +107,13 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
 static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 {
 	unsigned long pfn;
-	pte_t ptent = ptep_get(pvmw->pte);
+	pte_t ptent;
+
+	if (is_vm_hugetlb_page(pvmw->vma))
+		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
+				      pvmw->pte);
+	else
+		ptent = ptep_get(pvmw->pte);
 
 	if (pvmw->flags & PVMW_MIGRATION) {
 		const softleaf_t entry = softleaf_from_pte(ptent);
-- 
2.43.0


