Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37E2C79FAA
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B580E6B0095; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA0E6B0098; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFE56B0096; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E46A6B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5AAD120267
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:18 +0000 (UTC)
X-FDA: 85187760756.11.5AFC672
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id DA27714000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JHFXxPay;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804737;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDQCuXmLLjrAeZ5Ox+lmn5e7IknucLz2jYKRC140ai0=;
	b=hY+F78R4Fc/GMiHjJJl3ZDPZ9n1gFpPjAjPLp0PRYyLPM9R2Uhhf2fnbE83HperOpHHlV/
	5znWrWADJXJa9vKw+aIpQ0a5ZMMSI0r+3ZyZ7vINE60ZX0PKPTxRvkJnzdVt2KG6p1da1y
	7ECC7ZzTPcnKfeBjvK6hwY2cMWXFcAg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JHFXxPay;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804737;
	b=3QSQIDAdkXZe5gBgrT55iNdagrAWTLJCKoU9wmVpxy99rCIjNWVX0d5jqKxxr3X+w0uKF5
	3OU93P5KZlK9bNKC2wlQY2WWr6ZGTfkaUcj9NfEvqZagdHVAc9uy47MChJ5G3xftVZbqr5
	xLHuhf6RGxy9/cid6Uk2RESARn4HgRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D9B864411A;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA7BAC2BCFF;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804735;
	bh=eGSL2SBpTQ+mXwcDKZqFvaInRtYaF2PnawvlGiffnQk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JHFXxPayLPq4e6Jy7OXAMznpP8/Io2Oo2Ou6J1Dns691iZbZIf10NZolXZkiN98Ln
	 G+8Bbg2omnVGlp6y9MPYgfoaRxqyrquoeIBSGSrNVp9pivjC3+x0+ZGTOOg7Mae7lX
	 4Ah/Klg5xDsA6FBFNX00j8MqrbO5J9JUjiMeeM9UxhoqyUCTMMhbLMV8cXCnGHE3kd
	 0nqKCNQWAAR7Juflq6H41XDpz3pwp7dEOhCUypdXB+ol+4uhoOFVvYTREGT4VTOxMW
	 dhgn4Kw12h0tkY1Xv9IoOWu5NZmL8Ubg6WbWUYhPk7z+g44KvhiZRFcDbFaXelQZZw
	 bz4paS0w9IgGQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3402C79FA7;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:07 +0800
Subject: [PATCH v4 03/17] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-3-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=8106;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Dd/0CiPPVaIxMOajFfYFtI4g6AN9xcx8WFIdQNPC7lg=;
 b=wRErGQ6z/S+OZ3gj8UV9CJMQjToRT30bM+DHIGkUGcyhPfnLrZXExisnXAbEEu/0RTBzfoXMR
 u0T37t6GIugBY4RHht2ejU9+Kvm049YwWv0iFkXMFWfws2FdNHf0qEj
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: m141izxqkawz59d73xazty71ktszu1jq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA27714000F
X-Rspam-User: 
X-HE-Tag: 1788804736-708014
X-HE-Meta: U2FsdGVkX18qq7GqeaRiUX1jcf/wGfhw0dt2uljolj1jd9xLXkw2On4he2OE76SyWWOt8qD51EyaJvS6S2WTLghnH8iTQSLEHksixsXssrdCCOcVslVcPZrQ933a3p6zOGpsXbnWoIybsXBJrGKj1FPzbnGuy/rzMI0ETe2kKD5B3Fnd9Dgm7g3Yv+/Njb7UlhgaAIY2/ZwxuRrmREvjhHZaE8Fww29gvp1xIQ/pqKg9H0sJkhF6Rgr12dYYWTaRaLI1ls6AlvYOc+A27tPKLuJVEIBJSW2DFu+yEtHaU1BWWm8cNk1FY++idfoNZzYrptgBfk3Z5MMazjseP4sTchPKdYXkKjzvEYIzmRfGkiRFTUGOACy3U3xfnrTJbuBq394ECNoYxmjKcaQJlwYUQr3PIXjooJq1tegQ/bpv+uk+Q5E1CAg/oPEbc/86gkoqXLnX7Tt5BXs9TB7IFYGcwqLGeJVlqxA3mhSAwA2zpCMKXTaXWkTqt9TwszRqkfOU3ChBqd6EbIe8oGt+k0PQgOwX+OwBD/AjFEOnv3yavVdneSZvKH/0AkZOdR7QatJI19VVSdZJPuxoTNq9rVdkaQOwcvhsdHJquCWZinNoTxm9a2euxWLtmMMpJ4DCwZOawaR5deu4aHn+BIDPFkW9x1Au4HTwltnmQsaDFRWuEMYP1ak4SYqDoOvj80YMu1VIz01Bf4J7s7Ox0LYzRThObJp+iVWf2UHkff8LGozHB/k2v38TQcBYJeUEEZkCNg+xlAeKfJC9dI+Ei83FBIWie2iZEVKscxnnyxezA8rnfvv78v2CVN1iWalDTaBiCK+EcZS5emmVx1cj1gW30MkzgWP+/Ixd/+NdgoVRnPp0L6xlTcLL1z221aWKZHvJhU6l8SyGGm0DXmsvyh42anfZyRWr24INApTwfBICXDwzRf64lZbkTSP5AtdVe3lMKzImAHclg2JKLixCvBQvzwP
 /tnP9akV
 xU6mdimpVsLHhsheonHRzfKFZmXBGS/fyYcYKKpIQ3fIkZp6gcyc/1onfq5lrhTH4acDyVkXK6MEBew6CM10+ZmEpU/9+gQ1jRuFZLJO1YCFJuKlmVfyCoBZfodXyuUkLW4DAzPJ4fctfWU9aJlrdde5A62/En0/CX1GooJtEbQmiAuxS5jXnAsWnfnFJhwrk7lwstkePOPx/v2391F8LvcHa1fnOwz5w8VW2SKGP2qsDfMSaoTGYUZD9UTcbHBoJmJnUzccJRcsEpQjnRCwT8sweWMhVOz8RQn7X2mc2Gkbk7q21rI+KGS2Kwpsa6jaUMw5Zf2eJNCm1grl5pjgACrjGx/rdyDGyKbr2jubl2dGM3ZVMXppJumpWk0CgM6o8pKzO86hBnJQ1tR2Emu8Y6o3GeojYUA1qmM4XyezWAkgQW9BJy03K1eQiCtMDPEgLmM2qweC5bjbNLJgbBqGpPRj4aFjxGbtD+iCVGUXvd4hodxnG1ZC3eTA0EMX5+zAI15nnd9t/icsXD8HG1NBk5hNZ8sc8LkuA5NSFnPy02o4vSahiD1r3iQvgSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Invert the folio_ref_freeze() success check in
__folio_freeze_and_split_unmapped() to return early on failure, which
removes one level of indentation from the entire success path.

This is a pure refactoring with no functional change.  It prepares the
function to be split into separate helpers for anonymous and
file-backed folios in a later patch.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 185 +++++++++++++++++++++++++++----------------------------
 1 file changed, 91 insertions(+), 94 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 09cf40357557..ad45b86819fd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3991,126 +3991,123 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 					     pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio = folio_next(folio);
+	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
+	struct lruvec *lruvec;
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
 
-	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		struct swap_cluster_info *ci = NULL;
-		struct lruvec *lruvec;
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+		return -EAGAIN;
 
-		/* Take off the deferred split queue while frozen and memcg set */
-		folio_unqueue_deferred_split(folio);
+	/* Take off the deferred split queue while frozen and memcg set */
+	folio_unqueue_deferred_split(folio);
 
-		/*
-		 * deferred_split_scan() takes the folio off the queue before it
-		 * splits it, so the unqueue above finds an empty list and
-		 * leaves PG_partially_mapped set.
-		 * Clear it here: the flag does not survive the split.
-		 */
-		if (folio_test_partially_mapped(folio)) {
-			folio_clear_partially_mapped(folio);
-			mod_mthp_stat(old_order,
-				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-		}
+	/*
+	 * deferred_split_scan() takes the folio off the queue before it
+	 * splits it, so the unqueue above finds an empty list and
+	 * leaves PG_partially_mapped set.
+	 * Clear it here: the flag does not survive the split.
+	 */
+	if (folio_test_partially_mapped(folio)) {
+		folio_clear_partially_mapped(folio);
+		mod_mthp_stat(old_order,
+			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+	}
 
-		if (mapping) {
-			int nr = folio_nr_pages(folio);
-
-			if (folio_test_pmd_mappable(folio) &&
-			    new_order < HPAGE_PMD_ORDER) {
-				if (folio_test_swapbacked(folio)) {
-					lruvec_stat_mod_folio(folio,
-							NR_SHMEM_THPS, -nr);
-				} else {
-					lruvec_stat_mod_folio(folio,
-							NR_FILE_THPS, -nr);
-				}
+	if (mapping) {
+		int nr = folio_nr_pages(folio);
+
+		if (folio_test_pmd_mappable(folio) &&
+		    new_order < HPAGE_PMD_ORDER) {
+			if (folio_test_swapbacked(folio)) {
+				lruvec_stat_mod_folio(folio,
+						      NR_SHMEM_THPS, -nr);
+			} else {
+				lruvec_stat_mod_folio(folio,
+						      NR_FILE_THPS, -nr);
 			}
 		}
+	}
 
-		if (folio_test_swapcache(folio))
-			ci = swap_cluster_get_and_lock(folio);
-
-		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-		if (do_lru)
-			lruvec = folio_lruvec_lock(folio);
+	if (folio_test_swapcache(folio))
+		ci = swap_cluster_get_and_lock(folio);
 
-		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-					     mapping, split_type);
+	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
+	if (do_lru)
+		lruvec = folio_lruvec_lock(folio);
 
-		/*
-		 * Unfreeze after-split folios and put them back to the right
-		 * list. @folio should be kept frozon until page cache
-		 * entries are updated with all the other after-split folios
-		 * to prevent others seeing stale page cache entries.
-		 * As a result, new_folio starts from the next folio of
-		 * @folio.
-		 */
-		for (new_folio = folio_next(folio); new_folio != end_folio;
-		     new_folio = next) {
-			unsigned long nr_pages = folio_nr_pages(new_folio);
+	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
+				     mapping, split_type);
 
-			next = folio_next(new_folio);
+	/*
+	 * Unfreeze after-split folios and put them back to the right
+	 * list. @folio should be kept frozon until page cache
+	 * entries are updated with all the other after-split folios
+	 * to prevent others seeing stale page cache entries.
+	 * As a result, new_folio starts from the next folio of
+	 * @folio.
+	 */
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+	     new_folio = next) {
+		unsigned long nr_pages = folio_nr_pages(new_folio);
 
-			zone_device_private_split_cb(folio, new_folio);
+		next = folio_next(new_folio);
 
-			folio_ref_unfreeze(new_folio,
-					   folio_cache_ref_count(new_folio) + 1);
+		zone_device_private_split_cb(folio, new_folio);
 
-			if (do_lru)
-				lru_add_split_folio(folio, new_folio, lruvec, list);
+		folio_ref_unfreeze(new_folio,
+				   folio_cache_ref_count(new_folio) + 1);
 
-			/*
-			 * Anonymous folio with swap cache.
-			 * NOTE: shmem in swap cache is not supported yet.
-			 */
-			if (ci) {
-				__swap_cache_replace_folio(ci, folio, new_folio);
-				continue;
-			}
+		if (do_lru)
+			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-			/* Anonymous folio without swap cache */
-			if (!mapping)
-				continue;
+		/*
+		 * Anonymous folio with swap cache.
+		 * NOTE: shmem in swap cache is not supported yet.
+		 */
+		if (ci) {
+			__swap_cache_replace_folio(ci, folio, new_folio);
+			continue;
+		}
 
-			/* Add the new folio to the page cache. */
-			if (new_folio->index < end) {
-				__xa_store(&mapping->i_pages, new_folio->index,
-					   new_folio, 0);
-				continue;
-			}
+		/* Anonymous folio without swap cache */
+		if (!mapping)
+			continue;
 
-			VM_WARN_ON_ONCE(!nr_shmem_dropped);
-			/* Drop folio beyond EOF: ->index >= end */
-			if (shmem_mapping(mapping) && nr_shmem_dropped)
-				*nr_shmem_dropped += nr_pages;
-			else if (folio_test_clear_dirty(new_folio))
-				folio_account_cleaned(
-					new_folio, inode_to_wb(mapping->host));
-			__filemap_remove_folio(new_folio, NULL);
-			folio_put_refs(new_folio, nr_pages);
+		/* Add the new folio to the page cache. */
+		if (new_folio->index < end) {
+			__xa_store(&mapping->i_pages, new_folio->index,
+				   new_folio, 0);
+			continue;
 		}
 
-		zone_device_private_split_cb(folio, NULL);
-		/*
-		 * Unfreeze @folio only after all page cache entries, which
-		 * used to point to it, have been updated with new folios.
-		 * Otherwise, a parallel folio_try_get() can grab @folio
-		 * and its caller can see stale page cache entries.
-		 */
-		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+		VM_WARN_ON_ONCE(!nr_shmem_dropped);
+		/* Drop folio beyond EOF: ->index >= end */
+		if (shmem_mapping(mapping) && nr_shmem_dropped)
+			*nr_shmem_dropped += nr_pages;
+		else if (folio_test_clear_dirty(new_folio))
+			folio_account_cleaned(new_folio,
+					      inode_to_wb(mapping->host));
+		__filemap_remove_folio(new_folio, NULL);
+		folio_put_refs(new_folio, nr_pages);
+	}
 
-		if (do_lru)
-			lruvec_unlock(lruvec);
+	zone_device_private_split_cb(folio, NULL);
+	/*
+	 * Unfreeze @folio only after all page cache entries, which
+	 * used to point to it, have been updated with new folios.
+	 * Otherwise, a parallel folio_try_get() can grab @folio
+	 * and its caller can see stale page cache entries.
+	 */
+	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
 
-		if (ci)
-			swap_cluster_unlock(ci);
-	} else {
-		return -EAGAIN;
-	}
+	if (do_lru)
+		lruvec_unlock(lruvec);
+	if (ci)
+		swap_cluster_unlock(ci);
 
 	return ret;
 }

-- 
2.55.0



