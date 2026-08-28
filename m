Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABEEFC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3E46B00AA; Fri, 28 Aug 2026 14:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37BA6B00AB; Fri, 28 Aug 2026 14:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900216B00AC; Fri, 28 Aug 2026 14:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 696D76B00AA
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:38:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD7BB120399
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:38:01 +0000 (UTC)
X-FDA: 85151537562.28.91F152F
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 22687C000D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fvCkL4uj;
	spf=pass (imf22.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942280;
	b=QIJQ2h/M7chVgFehgKTVPjzb0a0kFaw438UnjmhF7mEyyxl4d8Hkk7oxZXDDonf6MQmvn+
	By17LKdd8/0qx23q94ZlrVj7tWiSm1nuC8CYDJwjEKR9MgAnFXIWlvF9d/59Z+fwNcVxzF
	Wizn3cSmaynE8J+J2+cMGmSZD+rWj/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ohz0fKfBZAA1QqDfzvlZw08AYcaw1ZYCfP9nCow3TI=;
	b=WBRKN2AcSs1A00riMnh/LSVBzCCwWxu2mHT9ZdSGSxRrx+VWNTHPeaqxgP/UY6hziX61Nk
	P2uHCq0vS6wS61WTbjNf3lG7abSA/l9Tbz75JYIswkLbqYGox6Ro/sRYti814ZqVjMq7c+
	edX70QoT2aNiGI/LWLyhVRzcVxShVrU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fvCkL4uj;
	spf=pass (imf22.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8568e3ed034so764416b3a.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942279; x=1788547079; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ohz0fKfBZAA1QqDfzvlZw08AYcaw1ZYCfP9nCow3TI=;
        b=fvCkL4ujaY24cIO0M6/mXEU/QuEMTLrwrjGVMID/gF0Y/vo5l+OXXhBKPefNboKZdE
         ighg/MMUdV6gD7dXU+eUGkFIslL9NjpZOlnQL4s2E5mGNTHTVGxfa6jjbDLKl7AsqO22
         nww9plKs9acSCPsVHZqHQpCONS5q1o1xJkKIBFoXh0Br9sGfwEH0fxOlcS4qg87+dIts
         LvZLJ38E8vTr69ensZd7htOWdN3eq479qHrNi/nBrpPOVr5qJEN8Unzdd53UYXijD5Ts
         q56kiSdeQ7KHeFUpwxWuuP0UQTtIP5yNnmKNeenoIKA9Xwfbe6I8nx4m/YBQNbakXLLW
         OgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942279; x=1788547079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/ohz0fKfBZAA1QqDfzvlZw08AYcaw1ZYCfP9nCow3TI=;
        b=pPNfNzmNvownS048JF/jL74RfnqA92QPJ5thpzcdyFGSpGCMOaWPlwKOnJf1Qx+9TG
         R4R4zZP+4DQ0Rq8YkL+J5W5a7PEiQGixy2W8OR3cZk34pUGTG640ev7KXigWmT3CazGE
         b8ZwThsayG9/+BCu3l0CDdg2v3J1lQvUJerjzLKU2YWGQAfV6VfhsmkXMLwMYmIBsu/G
         urVcdBmlDHWchREgRNNrpXM2Eyymvl7m/zS9YYPvBgXKvdQvl2bOQ34D+mgI0MZCKDj3
         jqCR8enFX1AAW6hQSeIAnP0RVf9WoXi87p8M3wKTW19GgTXlw79DI2Vwx7KOKUzRAdXH
         zu8Q==
X-Forwarded-Encrypted: i=1; AHgh+RoxzzndywfhirtiXhlRisHmIrMLWzf+vC/uskZYqxJ7gc3kwF4lkqCNiqj1SBh02bwns5R21btNgg==@kvack.org
X-Gm-Message-State: AFuF++laRcld0dQw1f3IPB2NHYGF5Y13y0dOZWVbUfa2I9l3Y1XVMro8
	4HpK1NFK00kIpi2WNbsIUsA/6J95WNLc0NBttbOgm5PNL+UbJxr8Vd3w
X-Gm-Gg: AR+sD13rSatsx7cDrm7znoowoobpirekoTfSfpGhuIEQbrgYq6drZsFsu4/yO9ePYNd
	b70y/MLDEa0coPl+1ep6a+K/NGaCLsmuKpcPImMVRtjY8ztM7LWBpzwEuKEs/MllDOo5/WcFpU9
	/7+wWGohFu0zkVah4We53BlJakyD4/XPZupQct/XUiJQ7DRANAkkFFoF299xzE6qpuFrBIvVUiP
	Hh+IfotKyIFxY/3TSqosqIUGNYMgbfov0EpKNrNgtsuvzJYnRZgkQfWrF/6ladcJVmlL3qWCE2T
	gRfn/1pr+cFPbXXAMBDdDRNCrNk6nCmSlr4kYPyK5jwOqrurCB//xGCI2NpFAKHWsgjWQ3oSIwz
	o37QFE9A/6n41gEavW2ssLIOLgONMBdXmcR9xfpY3jXJNLDS+XID8A4c29a1YYgx/XbWjFF0882
	1AeImy0h5L/vouKiOTUOQBxOiXqIKAkmoq14Qs6ufGhwku5FVMXq++Wf8QEijclxcLxlEc8TJnF
	fX8Yq8TWapi72TtpQ==
X-Received: by 2002:a05:6a00:3694:b0:857:7317:cff7 with SMTP id d2e1a72fcca58-8577317d16dmr2447151b3a.24.1787942278878;
        Fri, 28 Aug 2026 11:37:58 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:37:58 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 7/9] mm/huge_memory: add struct split_pmd_state
Date: Sat, 29 Aug 2026 02:33:17 +0800
Message-Id: <0ef68612bfdbe340e8c7f142c12b7f9998181a54.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22687C000D
X-Stat-Signature: 3gdpo1fzgw4z18trnhgwqutase1wgwrw
X-HE-Tag: 1787942279-98039
X-HE-Meta: U2FsdGVkX1+8KD3SPzMsqbRlIs8WJekfop0yA5lkzdNVspbPcZcNzv+Hr90FrP7EAcFL5MWpAjTPMxPj+9UTya3qS5Sz0+IJXRdyOgcQzHy9pS0CGt62ilSk49IGPWiYdJs8kiVUVFErUNmhDxIMwbNDLE4Cj1J9sbmHUYjFv9YHFLCBcScl/StlDeaF5evDnJbpcxH0jhaIhAFOny3K0Vl9TbwmYmW/EV20haqmcwU1+YRuBF5jmEUBsVVuvuQQnTzKSgLX6RUjHXlrr8baK50lrAfreBewzcHXwziqAkCak4Yv2HChZ7Ge4xuxRdUrkj+qP6fZjlLT4XDGtmw3eORN4MGJEWtRQ4gaXjfa72PnNTvZDghfg+09wLXUJm8F5NpeL7VuDP/lo+ESSox4m1JXb06lDOK6gyQzn7YX4YCsPftohGB4ZD+U8GP2yYurPSSDcFbTNv+Ous/D1b4fxoEWen4EtA/+PdJtY7GQPRbsowvtmAxdum8J9ZO01JEYUgw8hF4h1HADb2eVnOBrVDZJ3DrNdJzjKTOhJFXd01GzP2WQVtqExrHONkgTjgD+ajalnNWIt6fnseFTNnyUYeX9erdx4n1FLq7ByLexyLarmfMZ035Di7jYf2MXslIXB9V98HB6X557UJrLO8szva+iJIrUR7DcXKCWRKCraqKM9iF0rw+efSizY/Gp909cTuErEVSNyy7LHcBB1NmkcQmQaTcYKesd0NSOk2q/YQZpOvOVpmvGYDjcmQM/3GnUJGgu1TNcZ4Hpd/5prT3dZIEl028hOOwOyqZAGBzye24bYZOsIMNIYNX4dbD97u4qG8byp987Vrx10XWCziRtTBYwvCCAHq6+HsP1HT7k5jRn31orrpIKUN0znd4HUUPVDJv1Xk12MgyqPICeYEdGnyQKm9kNt+wWYqe9U1hQsjqhQoT/uMzqwKxR+sbCsflh43Tn3NjEIuUAgyOnsqf
 RKY6LN8H
 UyaJEsITlXh2EEneuztBnvo/yGV8yoh5qaVJbjvRXVpU5oH/0jTQ9mBBgx0RejExU0QcSBywGZGIcefnHWJmImEqGUkHskxFaVfvgSfaOQkt8Pn1iy1/7ui+mEuyafYGO/5ITqljXTQ7I7JP1KMGyEo/qh3MosGY9LukfcE/d8dtglTEkcNo9tex1Yts2jz6f4JvgYzGlwMv/vv6o9/MUNa04KG7jk2ZFlZ0qqxjt3o5gCII+UJtXjKSwgDIfYXdLxg5f4tqlwuOurSICIm9G2kBYLZXWfCiez7G0GjZnmgxKOgn+lLmISF4UU7hX3uOpdNXimlABd3wjwrXLaXouKPMTIZPSa4IfbL651rjLlxUSc6bSIbhXx7Pe9YRo7m0W85hsAyEYimMNWoVuZFG/5y6+gTA/m7Beo4xmypyxKIOIzYz22VCLTXGUeKjWGxsuByhMl8wKpAPR9qA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Put the state read out of the entry being split into one descriptor, so the
read and write paths can be separated without passing a long argument list
between them.

No functional change intended.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 160 ++++++++++++++++++++++++++---------------------
 1 file changed, 88 insertions(+), 72 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e0083a9e89b8..72e2cd1d7672 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3194,6 +3194,20 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
 		folio_put(folio);
 }
 
+struct split_pmd_state {
+	struct folio *folio;
+	struct page *page;
+	bool is_present;
+	bool is_device_private;
+	bool freeze;
+	bool write;
+	bool young;
+	bool dirty;
+	bool soft_dirty;
+	bool uffd;
+	bool anon_exclusive;
+};
+
 /*
  * Convert the folio's PMD-level anonymous rmap into PTE-level ones.
  *
@@ -3213,37 +3227,38 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
  *
  * Returns: whether the mapping may still be frozen.
  */
-static bool split_huge_pmd_anon_rmap(struct folio *folio, struct page *page,
-		struct vm_area_struct *vma, unsigned long haddr, bool freeze,
-		bool anon_exclusive)
+static bool split_huge_pmd_anon_rmap(const struct split_pmd_state *state,
+		struct vm_area_struct *vma, unsigned long haddr)
 {
 	rmap_t rmap_flags = RMAP_NONE;
 
-	if (freeze &&
-	    (!anon_exclusive || !folio_try_share_anon_rmap_pmd(folio, page)))
+	if (state->freeze &&
+	    (!state->anon_exclusive ||
+	     !folio_try_share_anon_rmap_pmd(state->folio, state->page)))
 		return true;
 
-	folio_ref_add(folio, HPAGE_PMD_NR - 1);
-	if (anon_exclusive)
+	folio_ref_add(state->folio, HPAGE_PMD_NR - 1);
+	if (state->anon_exclusive)
 		rmap_flags |= RMAP_EXCLUSIVE;
-	folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR, vma, haddr,
-				 rmap_flags);
+	folio_add_anon_rmap_ptes(state->folio, state->page, HPAGE_PMD_NR, vma,
+				 haddr, rmap_flags);
 	return false;
 }
 
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	pmd_t old_pmd = *pmd;
+	const pmd_t old_pmd = *pmd;
 	const bool is_present = pmd_present(old_pmd);
+	struct mm_struct *mm = vma->vm_mm;
+	struct split_pmd_state state = {
+		.is_present = is_present,
+		.freeze = freeze,
+	};
 	struct folio *folio;
-	struct page *page;
+	unsigned long addr;
 	pgtable_t pgtable;
 	pmd_t _pmd;
-	bool soft_dirty, uffd_wp = false, young = false, write = false;
-	bool anon_exclusive = false, dirty = false;
-	unsigned long addr;
 	pte_t *pte;
 	int i;
 
@@ -3286,38 +3301,39 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
+	state.folio = folio;
+
 	if (pmd_is_migration_entry(old_pmd)) {
-		softleaf_t entry;
+		const softleaf_t entry = softleaf_from_pmd(old_pmd);
 
-		entry = softleaf_from_pmd(old_pmd);
-		page = softleaf_to_page(entry);
+		state.page = softleaf_to_page(entry);
 
-		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd(old_pmd);
+		state.soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		state.uffd = pmd_swp_uffd(old_pmd);
 
-		write = softleaf_is_migration_write(entry);
-		anon_exclusive = softleaf_is_migration_read_exclusive(entry);
-		young = softleaf_is_migration_young(entry);
-		dirty = softleaf_is_migration_dirty(entry);
+		state.write = softleaf_is_migration_write(entry);
+		state.anon_exclusive =
+			softleaf_is_migration_read_exclusive(entry);
+		state.young = softleaf_is_migration_young(entry);
+		state.dirty = softleaf_is_migration_dirty(entry);
 	} else if (pmd_is_device_private_entry(old_pmd)) {
-		softleaf_t entry;
+		const softleaf_t entry = softleaf_from_pmd(old_pmd);
 
-		entry = softleaf_from_pmd(old_pmd);
-		page = softleaf_to_page(entry);
+		state.is_device_private = true;
+		state.page = softleaf_to_page(entry);
 
-		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd(old_pmd);
+		state.soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		state.uffd = pmd_swp_uffd(old_pmd);
 
-		write = softleaf_is_device_private_write(entry);
-		anon_exclusive = PageAnonExclusive(page);
+		state.write = softleaf_is_device_private_write(entry);
+		state.anon_exclusive = PageAnonExclusive(state.page);
 
 		/*
 		 * Device private folios are treated the same as regular folios
 		 * w.r.t. anon exclusive handling, see
 		 * split_huge_pmd_anon_rmap().
 		 */
-		freeze = split_huge_pmd_anon_rmap(folio, page, vma, haddr,
-						  freeze, anon_exclusive);
+		state.freeze = split_huge_pmd_anon_rmap(&state, vma, haddr);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3345,22 +3361,22 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * This must also happen before PageAnonExclusive() is read
 		 * below, see folio_try_share_anon_rmap_pmd().
 		 */
-		old_pmd = pmdp_invalidate(vma, haddr, pmd);
-		page = pmd_page(old_pmd);
-		if (pmd_dirty(old_pmd)) {
-			dirty = true;
+		const pmd_t pmdval = pmdp_invalidate(vma, haddr, pmd);
+
+		state.page = pmd_page(pmdval);
+		state.write = pmd_write(pmdval);
+		state.young = pmd_young(pmdval);
+		state.dirty = pmd_dirty(pmdval);
+		state.soft_dirty = pmd_soft_dirty(pmdval);
+		state.uffd = pmd_uffd(pmdval);
+		state.anon_exclusive = PageAnonExclusive(state.page);
+
+		if (state.dirty)
 			folio_set_dirty(folio);
-		}
-		write = pmd_write(old_pmd);
-		young = pmd_young(old_pmd);
-		soft_dirty = pmd_soft_dirty(old_pmd);
-		uffd_wp = pmd_uffd(old_pmd);
 
 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
 
-		anon_exclusive = PageAnonExclusive(page);
-		freeze = split_huge_pmd_anon_rmap(folio, page, vma, haddr,
-						  freeze, anon_exclusive);
+		state.freeze = split_huge_pmd_anon_rmap(&state, vma, haddr);
 	}
 
 	/*
@@ -3377,33 +3393,33 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_is_migration_entry(old_pmd)) {
+	if (state.freeze || (!state.is_present && !state.is_device_private)) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
 		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-			if (write)
+			if (state.write)
 				swp_entry = make_writable_migration_entry(
-							page_to_pfn(page + i));
-			else if (anon_exclusive)
+						page_to_pfn(state.page + i));
+			else if (state.anon_exclusive)
 				swp_entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page + i));
+						page_to_pfn(state.page + i));
 			else
 				swp_entry = make_readable_migration_entry(
-							page_to_pfn(page + i));
-			if (young)
+						page_to_pfn(state.page + i));
+			if (state.young)
 				swp_entry = make_migration_entry_young(swp_entry);
-			if (dirty)
+			if (state.dirty)
 				swp_entry = make_migration_entry_dirty(swp_entry);
 			entry = swp_entry_to_pte(swp_entry);
-			if (soft_dirty)
+			if (state.soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
-			if (uffd_wp)
+			if (state.uffd)
 				entry = pte_swp_mkuffd(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
-	} else if (pmd_is_device_private_entry(old_pmd)) {
+	} else if (state.is_device_private) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
@@ -3413,19 +3429,19 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			 * pages corresponding to the pte entries when freeze
 			 * is false.
 			 */
-			if (write)
+			if (state.write)
 				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page + i));
+						page_to_pfn(state.page + i));
 			else
 				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page + i));
+						page_to_pfn(state.page + i));
 			/*
 			 * Young and dirty bits are not progated via swp_entry
 			 */
 			entry = swp_entry_to_pte(swp_entry);
-			if (soft_dirty)
+			if (state.soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
-			if (uffd_wp)
+			if (state.uffd)
 				entry = pte_swp_mkuffd(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
@@ -3433,21 +3449,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	} else {
 		pte_t entry;
 
-		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
-		if (write)
+		entry = mk_pte(state.page, READ_ONCE(vma->vm_page_prot));
+		if (state.write)
 			entry = pte_mkwrite(entry, vma);
-		if (!young)
+		if (!state.young)
 			entry = pte_mkold(entry);
 		/* NOTE: this may set soft-dirty too on some archs */
-		if (dirty)
+		if (state.dirty)
 			entry = pte_mkdirty(entry);
-		if (soft_dirty)
+		if (state.soft_dirty)
 			entry = pte_mksoft_dirty(entry);
-		if (uffd_wp)
+		if (state.uffd)
 			entry = pte_mkuffd(entry);
 
 		/* Restore PAGE_NONE so an RWP marker keeps trapping */
-		if (userfaultfd_rwp(vma) && uffd_wp)
+		if (userfaultfd_rwp(vma) && state.uffd)
 			entry = pte_modify(entry, PAGE_NONE);
 
 		for (i = 0; i < HPAGE_PMD_NR; i++)
@@ -3457,10 +3473,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(old_pmd))
-		folio_remove_rmap_pmd(folio, page, vma);
-	if (freeze)
-		put_page(page);
+	if (state.is_present || state.is_device_private)
+		folio_remove_rmap_pmd(state.folio, state.page, vma);
+	if (state.freeze)
+		put_page(state.page);
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
-- 
2.34.1


