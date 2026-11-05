Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29DC606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hE2WxQ19
Received: by kanga.kvack.org (Postfix)
	id C387C6B05B4; Thu,  5 Nov 2026 13:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F916B05B5; Thu,  5 Nov 2026 13:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C9C6B05B6; Thu,  5 Nov 2026 13:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92AA46B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:39:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 302FDA0BE9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:57 +0000 (UTC)
X-FDA: 85401929634.03.E2AE851
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2B21A40008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hE2WxQ19;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793903995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31fzmOt0FaYCeiQ/tx8wUE7G9kVsrSfC5pQ2mgLEW7Y=;
	b=yBUjp1cmiLqG8Wn1Xvnd3BMIhitUmPkZrdrsJO1bpv27tKxmO0kYWJ6npiEryLLgJ1KN7x
	gsCfwkpPr8bvPUV8maGc4Q+fxiTA+G1NZKW4augnKbEPe+dsvSq/Mxi4gHobsfCGsGTJ4E
	aaPXGduZ/G4MDkEXOEFoG39TdMHNT/k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hE2WxQ19;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793903995;
	b=OGglTuRxqmympOlWoXtbSpnebhO8BM/z0umEcjlxccy0H3Zj6/4stBULjz7ehNMsjQ6j6g
	8VvCRCvDdoQLDQiNcipqY4ocL4WcnzlIXIoMy+YpxWWrx+Djxcg5MqWX3Ps6cCk1rg6VXU
	s0lSpbFrpqKZeBMeUsvvuoSErrj8o3M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NVSvaau1XB8Yml9Wa3VUU7m/rYm6KsytcRcD12Fn9UI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793903993; v=1; x=1794508793;
 b=hE2WxQ19C/7BXi0JBo3cP2SACLOm8qPtTBDKL4qNwkfQwkIZxBkY6MetGV+H+JqVGssDtcA0
 ZXEz+wQUR7vZufy1lta9/hGgFDudbH2jhXEnkLNQRQfqQ+06dlNcNf20boTN2MuNCZEOR2QiE00
 oi21vQC6YybEDBHw8usBckMM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 64e6de2e787aa644;
	Thu, 05 Nov 2026 18:39:53 +0000
X-Mizu-Trace-ID: 64e6de2e787aa644
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 01/32] mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
Date: Thu,  5 Nov 2026 10:38:45 -0800
Message-ID: <20261105183940.2236717-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B21A40008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rptwfw1qeke1cffnis4zhh5854tfh98g
X-HE-Tag: 1793903994-702873
X-HE-Meta: U2FsdGVkX193f63ZtoNHbEEwYhIk/gY5jjgce1zq1FGkHIlPBQitYqMlHBeboKGufzx1GU6hrBi6S72Kl7BjOsfDywMenqcHvn14J5V/nnr61nZFZA/Ph+qwouy6OdJfB7X25pvWC4e9/DU/O/si5AE5ZC689O8rBH36QjzOmn0wq5mzCe95e+VEAb55gx9qFyYAhh5LVHIgt47jsNhpW3LN2k08f4gF9Eh66oiUltTbaimn/xxR0ooDqRfGkiiw/wy8yuohL3VbHtOWTw02deWfpPWEDLaNhm4SQw4eN+dftsVTM6Ljl24PvnxTM/pQzsXbYx2jrlu3rFSrD9njtqlSa9DnL1e5QBJ3NE0lOOQzlRMFGvswoo8tbWjeT7p61pwE1/FMu4F2OR6dRDzNHq05dsgD/DTpwAgnjQvEHK6g/1jRfpzeZ9JpfbkN7y1guJ25ihrXeWxWNBY9kj0RJM8M2piP34T6USxkbJl7NrnCe/ZTkFsOwSzmQ84g2AMtcYAL0Qj921Mu1R/GMnheERBP7ztWj2cmvLzBJQ8CT74TX6QKqjemaCVDgnVdULM5nzddnTas1QVrLlsvykwvYbEltO6lE5/q/0XfdQQhjcTfcGapW/KSmKr8qQ4XDHXZLMKNSjINEi6IMEBHr2fc7XIMNGzaxUexs1veE6wjolnpxtbTezTtP1RLULjaASOqhOJwIUv9bxZkoEZE34gUU5JL2725mMgLjDWK4mFcpwXJueEZjgV4tqepp5f2TxUkk0uNlsp7HKeyqiw57FijOFOnDsnmLNhwx8suu/4wuRCcWxwQKUQUyDZHbXbf+lbqLIUv1C5s8522VsAjH1IRfU46Pf0weDA1Mdo8A41+taJO5LomKeJtn+e/yuAv8N7XyvSjRprnQfV0Nhlwwakskq+ItdcuyjtFnsoLsHO1j8Dzm2XbOQgVqFloapEbn1DDqFFMl6JgF8wvDxBA0m8
 XF+1des1
 ri47rdGIBajd/fd4fIGiMzr+BpSwAzLzJF0B1KTY7pU1iqiLduZb9gE9+2XnW3OH+IQ3jaVmfH+E5cjiOf17PZm7/AyS5zbUUcUBLiG4vRGRKPwFy7fYd7OXtf1k+FFnvxWK3nf0WSJMwkgm90nCAEJO5G9gTWH3KZjIeO0YM8RKhrGoi7oGehU3ojIRNVPstKW8k8r9Mfn+qD7DF629qR5r8AfX6VtzznSOEACqK7OQBeNPA0gIAowoc92V7GJ1JK30+bJu1mJCsQ68yLB6hCKeIiz8XYeNfk7EzsfSBW3kXRjnFY0lqoJTXuOjLNIqesvopYh2H0Kextul4gkUj3Uvg7Wq/PT0DqHXrdYMM5btgthK8icpXR2DOH+5cyjRiEDc1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

pmd_to_softleaf_folio() reads as if it converted a PMD into a folio. What
it does is decode the softleaf entry stored in the PMD and return the
folio that entry references - the direction softleaf_to_folio() already
spells out.

No functional change intended.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
 include/linux/leafops.h | 4 ++--
 mm/huge_memory.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 4c1476ae32343..7c13c58a5e218 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -657,7 +657,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
 }
 
 /**
- * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
+ * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
  * @pmd: PMD entry.
  *
  * The PMD entry is expected to be a valid PMD softleaf entry.
@@ -665,7 +665,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
  * Returns: the folio the softleaf entry references if this is a valid softleaf
  * entry, otherwise NULL.
  */
-static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
+static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 {
 	const softleaf_t entry = softleaf_from_pmd(pmd);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cda3c886ec533..e425a5b05aa2e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2516,7 +2516,7 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
 
 	if (!thp_migration_supported())
 		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-	return pmd_to_softleaf_folio(pmdval);
+	return pmd_softleaf_to_folio(pmdval);
 }
 
 static bool vma_has_deposited_pgtable(struct vm_area_struct *vma)
-- 
2.53.0-Meta


