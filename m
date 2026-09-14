Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE916C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E386B0088; Mon, 14 Sep 2026 07:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735246B0095; Mon, 14 Sep 2026 07:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C556B0098; Mon, 14 Sep 2026 07:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 413116B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:43:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BC0DC0330
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:37 +0000 (UTC)
X-FDA: 85212182874.07.434A8BB
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4812A40007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uoLJw7eY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386215;
	b=jNySMHpdC90H87+bRVM1xYUnOlpQqGKruLvqHQRMjVjQqwAgBn/S9K2xOZODiUApiuZ9/v
	qWgw33r3fjN5lra9fAwM0z92c7aKpkgAeCJaJf7sZpSOQxuVrYB6b1EaE5QDkBSxjGJi/l
	qvh9jPYEKlEb6wG84nf+zgwPNF31ePc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uoLJw7eY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh2CaV3HTSL+pXGerZZn+jJw5LbMQzFJUQAW2lEC2Zo=;
	b=1ISMBUlRGaFlL4trbxnODjo9PnfWIgRE5pjsSTXfNVjODR5EAQAi/kVbThNbu7pPtj8dtX
	uHBe5OJ/JoDVFxT6Wy6R3FVGaH9ejoTpHt333ictPHromwuTeMjNfhBgmg+UQOImlZFDKo
	pH7wTfy2mRaDrQyNmzwQM+F0CLahc08=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tuISWPJ3M4ynpVPzFp7v67YsNxfpcndtSeOMAgkqq08=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386213; v=1; x=1789991013;
 b=uoLJw7eYjl6XgvWe0bv+jIg0e6AbExYlbWiRbgMS1AYSGQPz8RRi7VpCz+4Nv0kixfXx3dBc
 xKkuVm8bt5VEHZtOytQigsg3/dnukdIF7BRHCHRfdAVSRRPt8T0W7FncQm98mLwYjcQo235Im5S
 IQCGJelh1Eorz9DOg2te0sek=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id bed498ec3e35e2b2;
	Mon, 14 Sep 2026 11:43:33 +0000
X-Mizu-Trace-ID: bed498ec3e35e2b2
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
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
Subject: [PATCH v7 01/29] mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
Date: Mon, 14 Sep 2026 04:41:53 -0700
Message-ID: <20260914114320.12988-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4812A40007
X-Stat-Signature: ng6zcw1tiuhwbds7id8te3rb1wtdgbay
X-HE-Tag: 1789386215-263900
X-HE-Meta: U2FsdGVkX18SvpAKJ3g7n63ksXaY+H1cvDbn1KmRIGeajvZVzDJS2d9GeHJIgYAhQWNa1taPsh5iiNn1tB64tkDZ/CpyXA89qbHVHV527f1gm+m8xcuHqBHuzPs7IIZ8aB87mbcOQwepPsw8Biut45eJBkbslk8A59fJXnlPqzM969acklJFKr0ExVlG9kpV+c+HaHUy0jU60CEfwOOz3IAmRVTxrhUlInlUUKvsp7m7ruD8VqNMKN7QVAfrYHCECTU66TotrWsXBdPm9wNg1AsitrQJKrcRy57qa24nI0PQIyXUrlIo2pTGMqRoJm0WvnFjZHqmizEfI1R3r98yjK7fSmmjoD9vMHFIUDIh65oaRFwftwQBzhn4wpDG5jvpm8WIItjuWq3eaj/zr0444TJfPQKOjZveqI6Jojk5uqzlTOIOIddyUik69Y7fRDd1dSxJyw/LnWF1+jIdUKia6m/DvXXauiYXkM0WedKHVxHJAONWU4O4zzSjzZXRIQqw/RWYl1a41ic1/FzLolpjUw5cq+3DQGvUTFRxc/xJiih+xZznP78czMtMEbOcdpfBD0/fhyrbr7cvwPkypPwN/1wwQ8NdaxpA25gF9L8CHFASiJcvAL6WjaVS71joU+VXW/CeGIcYFLw+pzN+PcBboPD9Z6ILOZKDCa4aBm7arEvDh1hSGqDn5XZPl7VtQfAne9bysAPxyGQB6hXMAMlUNoupORNU6YxQUrj/IRhepGKwzHFHfsnr65l85avWeaXwavfC+i5vYHG8/PWlqEHTwpHB1Mt8lsxso+3pEu0tQla89+wQzlICI1aaabAGRhJKP4uccP4liRC1EM4t/wc65RiO7zCitm7xo2by1irMx/Zy13mdl4AOsruVMFcbhFEtIGzmf8yWbbQdejrmDHTGiSFBZ9ZYTtwco9dXUhSmBvBuBBly1/wTRlyIe8Cz0+u9bMfVgfDRR7JwPZQV0ef
 Wuv7OZiM
 yc3qGhlp6NdVhgT2FRVNPPAXn+y1lFmNrFS7/79zOwNGLbf4aZO+rP7Z+tRnqUKgRfgCUoUo47NR8XHTEaN2/NdS/lpCN4BT0lxp6s0TAgXnp7n1bVKxbTK+wnLAlXafEbiZ73xfdOsdBK9svjaF/6hwSjDZ/FxP+Fp8zr9SwGSZsBufFcfu5I0OiA2q6UTx5FTCX4NTsjss9W/4Rk9NN3FxM0CDJ8wQ9XSPOVFNMBtyC0jvoiV4dzIwUg1XU/eRn8MmHtAfgnJlNbmxzPXm955jBQMJw1rqyRXLhws7b0RRhqXDGJYGiS2nphP4BFWlMRdp1T0Vd4y/KvoCknfvgJO4njLKkDC88UisyVDVQ2Jgywl9SflliDZIC/ZvuHRGEQFzt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 7140a1031fb2e..ee8d46827ffdc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2518,7 +2518,7 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
 
 	if (!thp_migration_supported())
 		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-	return pmd_to_softleaf_folio(pmdval);
+	return pmd_softleaf_to_folio(pmdval);
 }
 
 static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
-- 
2.53.0-Meta


