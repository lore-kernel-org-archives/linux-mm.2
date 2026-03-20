Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628D11099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC90C6B00AD; Fri, 20 Mar 2026 14:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46776B00AE; Fri, 20 Mar 2026 14:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BD36B00AF; Fri, 20 Mar 2026 14:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2D976B00AD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:08:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69E808B411
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:00 +0000 (UTC)
X-FDA: 84567225120.11.846E50D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DDBFE100011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UDqhQm1y;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YXZra5Ywx0rVkHWkRDYOa4yJ8vWfl+dJd8SQWc6LbM=;
	b=blFE2Hc2mWJAUHk59cCNgBV3eCSME1xvKS2W3HSR8Tdjs70upNmTFHciWfNvBqidBHnJZ4
	CLx+9Qg4i0WrMKTB2pmMuy7d3OSk+9KF2J+lPpyixV+lc3Ly2qUPWLmNGm+5HoTe1bCj4d
	VX9wE1wk5Xj8dZ052WFY+LV9gqb78kg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UDqhQm1y;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030078; a=rsa-sha256;
	cv=none;
	b=VwDx/2V0wIMPxtvPHWXguk2tsRmqm2vr5//sr9ADE9V9lezbgXDmEb8T3H9LqYo4S0zw1m
	ylAALamG685VUiI4gdSIlx3gOizN43SxUV3reSDtZqRqyugZ/v7nAQ6YTUiBMiEnJEa1Tb
	51o3lLIGfBZ0R5zHr7/KOdwJW3aPpbQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50B876014C;
	Fri, 20 Mar 2026 18:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9697BC4CEF7;
	Fri, 20 Mar 2026 18:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030078;
	bh=5aAgSxBfwNEPHyvo5LTABZZaCkcbiSMEvIABINFNT8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDqhQm1y29Cmsi9P3gnEs+qHGcMHG5+Uhwg1sINVZP2y+zKd1XupmbUYz3ckzXgK+
	 sfA0ewGLSJ7CdBRwLrN0J5pLoEb9mS46ZQxFDujtl/FLCMLlCQGlc3+20EDWHV2k7e
	 a65NnEvZ3qkCVZlKy5j13DRyxJ8zjtfe7hvSs9uhH1xxkO57heI0Drv6xwoutmh9OB
	 SGbuqeZ7wi1ItwipLTV0AHtftzfjWQ2ic2IZf/LlTELTon9i/WBMvItLGcZjOTKlHf
	 kl1j/ftoWWTQagUw48aDtJnGjk2VpM3NnC4tH7M1I5LHuE+xs5U++Mcqnx4izgUPqs
	 +FzD10CdBNnOw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/13] mm/huge_memory: use mm instead of tlb->mm
Date: Fri, 20 Mar 2026 18:07:26 +0000
Message-ID: <98104cde87e4b2aabeb16f236b8731591594457f.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DDBFE100011
X-Stat-Signature: tefye6fh1sz7wghgji3f5zi5uexnaqrt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774030078-758080
X-HE-Meta: U2FsdGVkX18cHZ9IGCuEIK+Ltj/ieUJNwDim7+FXlpyECQ21Li9Ij45o2U7Yvt86rZf5SSknwbc2WZIg8+5yzX01d8xyCN0zHYY5N85a3oFFPwh9jYdf/H/sSBAQGIb5IRDLdKURX2MBVBFIWN0E0igMDVlWMuAVdJE01NUspp+21ym/9jxQyrNMxteNzEl7XZnZItexWmkRGQodLbho9PydgJ2wSjxTfcxA5lEDRLyyMZ7EMdA7aM09YfVGSBeacA5IeCbiO7oDmJ/VI6mRdYLhgBZKK3QmCK5v24gxJq+vI+oSkNyoI+kn+8K/cVxQ93aJCwtxHdakTIAMz0yjKGhtf8c71D5sKPujMBmiW8D50qdl6AdmWNanHZKuBWGVrfMSmJN5H6o2hqcx5SqdnYMiL9aIa8nCjqcLWmW8aaGwV00E/1NYvPa30ahg3VZmh4p74/qLHGLv2lTVor2xBUI+MVKQDUD1idp1odSRljUKGbIV//CLEumPgRsyctWDMB3FGefWA12/t5ZlncTGY1BcAVh4ZzbNR136E0eUfImowxNMmd46naWq4TyJEtoB3qOHBgGNOcy/fqnSw/RvTeP6bs0lQAF7GwZELLCSLzDinRsVBbFD1zFaHxQwFYeuShdUj6PRxLWdIaE8acv1OYfSPH7H6MTRtGw17ZHOdXzhjtipsCBfyUsnULYh1OFI04VWhlTst2ieIEj4Sup2oVZXZNX60dBZo3MS6o4xpR074v+LDgii4rIqePbK6NhEXakk2Bc0B7Run0ccDXJ7h/cDBetRVbcT3oKUyLuMAfK3e8ZzvElvjhFi0aldPZuFzxdVNh/m9tk4G0vZfnCkqiICEVZFpWb3exepI4BviVN88D082jcgr5pGxZjnhvD0Q46SnFg+xfCG67pQ3D2ZhECxp+e+SfUQ4kAqUHSRoiEqwfDQadxvEJg+2PV7t2ZjkXt7jK5U0TcDwh823m3
 h4SICslS
 UbHYgOqL9r8jh+hN3LczPRYxhBaFf8wfyGKt+OI0Wt4VhBSwG6GvxQbZMkcyD2qGgi/3KNCRan6Yku90NXG/4szBhBhovvDd4Bir+A4w1frwIM7mJQComOm7nk4/ah1b88oHmWjQ5XiamNCMhr2n2fmcs1i2LNKKLo8lboVsme898p+6lUNGL2g+wH+R5NC7/vQ8CZv1fNygsf6ivlVFEcncEccdIZtuA7DH1SO37OjgJnUd5kr8wvIAP9E/zQAQ/8IG0ArbOBNhyHpyT/DIaZZdJdrnIOblwW4fq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reduce the repetition, and lay the ground for further refactorings by
keeping this variable separate.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c5b16c218900..673d0c4734ad 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2338,6 +2338,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	bool has_deposit = arch_needs_pgtable_deposit();
+	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool flush_needed = false;
 	spinlock_t *ptl;
@@ -2385,9 +2386,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	if (folio_test_anon(folio)) {
 		has_deposit = true;
-		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
-		add_mm_counter(tlb->mm, mm_counter_file(folio),
+		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
 		/*
@@ -2406,7 +2407,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 out:
 	if (has_deposit)
-		zap_deposited_table(tlb->mm, pmd);
+		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
 	if (flush_needed)
-- 
2.53.0


