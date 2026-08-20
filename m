Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2288C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D31A6B0092; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9B76B00A3; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1361D6B00A2; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF4B66B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4968E1A025A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
X-FDA: 85122551262.07.02D9A47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63455C0006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YDd2/6ag";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IudD8tw3hf6hLO4PQRNG6d29EgGt9kd6HHGBtQl2TV8=;
	b=k6hS/lQ1dzD0FX7RhIfOTNmaCKVo0VeJLe0qe7lJKkGxbf38A9OlSxyqJt7kjILUrHfUs0
	FZHZicBzJ7Pe4Ze1j1qQIfyujcpG9QtGneVDZXBmm/IyKCXlGglKuiEx5pIu6Uqbneu3VI
	s29dIErZVy7RluMuU4mYjehtHY1Szhw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YDd2/6ag";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252129;
	b=opOPp15MCaUpXPdSZPOFne6C21TE+cmTxDNyhScbCIaGLgEk+ER8msTxzzyacQHNd8rPhe
	luHc141SazuuNoFLj9drIaEnVOoIWxM8O6ZriRcZHCvm9ypJrW+Kq6a0b43vKzYx+lc6JH
	mHgFbJcpsXUUqMqocas3mLN7H1tiWJM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7ACD60A7E;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 914E7C32781;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252128;
	bh=3CfMcjiNddwe9dRGubBMNv3C8JR+aOzPu0U1+6Cwm3g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YDd2/6aglrFrnhykio9zu4YpGvhI0fJsC6GGvNiVF14v079/j52yG2dd17UEMV/rz
	 WQn7m4EHRU1r7Ie0OPg/ez1GOXn+h0H52D4FhvVLsoQqiW1solvnS4In8i+H26BI5L
	 T2vbjmdZ5I4AoBAxjFMFTmjSwMl7EXlHpT2WxCVJrKbftCvoXpq4oPjxZbzn7cgh1m
	 Ov4tqivLH7FOt/Vxtv1TruNM+JiFgxmguk22/A7aVYsfqqHPMrotnulk5NNf916cSO
	 wW7AcEwzPNDSuwMRUOsA8faspE6OdeXU1ZdvE/Qqpzp6JVgpvHYKGXmi/OsDWyhvNz
	 i4tO78nQtXXVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D974C5DF86;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:20 +0800
Subject: [PATCH v3 07/18] mm/huge_memory: move EOF trimming into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-7-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=4165;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=iHc7pAaIWrvecdrYUZp632jxrrl7JCpaJ3/M1UaVKXM=;
 b=SSoVa7oBxRV5XNOTEkWS5QvNz8DmMOLpNiHcpSpatLmWJ2BgTT8vxBo1owQndnsF1GBNZS3PT
 H4ECfhrdcmICJ5mWGv51TZGUXGuzoZX1tVVARrbzwXTEMIpX34esKVJ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 8p7eswpiyp9u7w8gsjeox1ffi8h97awk
X-Rspamd-Queue-Id: 63455C0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787252129-473770
X-HE-Meta: U2FsdGVkX18Jo7rUWEPIMQ1e14a56fZik5v8unnzIIPy0Q67VPpy2pys/nvnUjVY9RNZ78+50LG6FxauegANW9Dl9PmTBuvBIai2t91IGggVoIsaCV79FK8Ksn7YXB7nbj2zSuIn4Cu2j/cAMj6zglOeIq+KlUfc7A1HB6OvFfjm2/kz/RtsVp1QpVAsvVCcWay9N8p6DomxjkCPumZpt1Q/Rp1JKNBTzGhEg78MjKbASEKAMRIsSb7sKhw2VWIujrx989KEFBryN/LD37bDy4wc0nMS8TZ+59/gPHg9t6R8ZjVEylSRpDVgCWutdVFYPHSIqHvtN6ZKKC+BbPOy8fpVQWi6ZR4OtEq4+xsi+VhNCzjADoKHxuSyaXvzfyMDzd1WU0FwzQhnCCNvRxT/Lr+ZxpdGC/jZpqeCLx+rzKvU+FZwH/0GSVvKXJ7OQc3CIuaZJdYFckvHwZ91Gho9khl03aC9Ato+6mnXsIjCkhVCq/R+RDoXn34874XNpnVean73LM8vDwQrosXBqVBF3hiiMX7t2P8JJ1JIoo0UUCI6EljTu5R++Ayp7FMiEyqpXMNBZ8d8NnpHwnvvKzNoLAvLa0cUXZ/CXNcxP9g1bPgRNgpLaob/WHzIlvotydRYrVBEdFPu5Hx1R+1RE6Zza2yma/kYhNI1o5IKCy03WyzHQkh7QsY6SIbsN8vSPzUIAkKQsUe0fDBUlzei5HhHveRBfFfY0YSO8AHeOFJugLuCuGO1NLBw8TImQOvySWaD33Y3y/1ZM/7pOyYLmVPX+Swa+b+7ejyWaObCCqd1GdOuiDMxUB6PR9uwv2olZf3/MVA9Spezr4iy9AirrffipETD43PRFOOLo5Mp6dxMhptSfpNxXR7UEFxxIr5Crf/n/L8kJLewhRo7nC+A0CLgDefkdQ9Dv9fCCL13cTLXS+B4zEn21y+z+Cfm5LvWELKJi6fsusVI8eePzX3Gi1l
 RzHCzQrY
 hnmltiJooxCwnMcui/ypz8s/Dt8jQ716mPg/4F5szJQn/HV8y2VIUf6nkSJ8sdyEOvljPf32fwtsnPA8cHHqE7+kgESSkxubk00/4b++hWafua7n6x0y18jxpMiNpi/KEHSwa4izIa+LwKgmMFeX84+DfBdwzrzK6CcmbE56cQk/DoFJhtP4/DjmwORlWD8MEu2hedazXnpIEsRrVxHzerdUkAj5HOfenqst3MAB+1wh85F01kNczxFOW09+066ZbsHs2YsMiROw7cYDYaCz+LNLIBcsFxBSXedPzOA/EqRBFN1U/JSJ+vT2r69z9LC3CXwVuSgalGPfvdzoMlANvFp04GY8NCxlkIT3F4lQqKnGAMQC4fSM59ry056dSq86ISRDJn7LI7niGffbVZhr2bUZHZp9t1cU8GmzaiKm5KSGilGQHd7r5yUiYZA+UlEAcMFc+lxWX1hdPnJTC2Gcl8adaJTpcFA//kpYm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of receiving @end and @nr_shmem_dropped from the caller, the
file split helper now computes the EOF boundary and trims pages beyond
it itself, as this is only needed for file split.  This drops the
redundant parameter passing and sanity check.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 69d3a6889f9e..01c8cf428595 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4029,14 +4029,26 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int new_order,
 					      struct page *split_at, struct xa_state *xas,
 					      struct address_space *mapping, bool do_lru,
-					      struct list_head *list, enum split_type split_type,
-					      pgoff_t end, int *nr_shmem_dropped)
+					      struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
 	struct lruvec *lruvec;
+	pgoff_t end = 0;
 	int ret;
 
+	/*
+	 * __split_frozen_folio() may need to trim off pages beyond
+	 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
+	 * seqlock, which cannot be nested inside the page tree lock.
+	 * So note end now: i_size itself may be changed at any moment,
+	 * but folio lock is good enough to serialize the trimming.
+	 */
+	end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+	if (shmem_mapping(mapping))
+		end = shmem_fallocend(mapping->host, end);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4101,10 +4113,9 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 			continue;
 		}
 
-		VM_WARN_ON_ONCE(!nr_shmem_dropped);
 		/* Drop folio beyond EOF: ->index >= end */
-		if (shmem_mapping(mapping) && nr_shmem_dropped)
-			*nr_shmem_dropped += nr_pages;
+		if (shmem_mapping(mapping))
+			nr_shmem_dropped += nr_pages;
 		else if (folio_test_clear_dirty(new_folio))
 			folio_account_cleaned(new_folio,
 					      inode_to_wb(mapping->host));
@@ -4125,6 +4136,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 
 fail:
 	xas_unlock_irq(xas);
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
 	return ret;
 }
 
@@ -4161,9 +4174,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
-	pgoff_t end = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4240,17 +4251,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		anon_vma = NULL;
 		i_mmap_lock_read(mapping);
-
-		/*
-		 * __split_frozen_folio() may need to trim off pages beyond
-		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
-		 * seqlock, which cannot be nested inside the page tree lock.
-		 * So note end now: i_size itself may be changed at any moment,
-		 * but folio lock is good enough to serialize the trimming.
-		 */
-		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
-		if (shmem_mapping(mapping))
-			end = shmem_fallocend(mapping->host, end);
 	}
 
 	/*
@@ -4266,16 +4266,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	if (!is_anon) {
 		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
-							 true, list, split_type, end,
-							 &nr_shmem_dropped);
+							 true, list, split_type);
 	} else {
 		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
 							 list, split_type);
 	}
 
-	if (nr_shmem_dropped)
-		shmem_uncharge(mapping->host, nr_shmem_dropped);
-
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 

-- 
2.55.0



