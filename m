Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09461F44857
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A2C6B0096; Fri, 10 Apr 2026 08:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7621F6B0098; Fri, 10 Apr 2026 08:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677E16B009E; Fri, 10 Apr 2026 08:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 579896B0096
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:44:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 273E8C1B3E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:35 +0000 (UTC)
X-FDA: 84642614910.07.EDB60ED
Received: from outbound.st.icloud.com (p-east2-cluster5-host11-snip4-6.eps.apple.com [57.103.79.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id EAB8940006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=KuW3bPup;
	spf=pass (imf17.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.69 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775825073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLXk0ExvSFKrM+8uRAGb/whtOA3pAADUVtDTnKG795I=;
	b=2jVvVAXnVrUSIs0yvc0c1QQe0a28EQbeCf0Vx+E3vIbAHWEXbNzznQxKSgmyTYZ/YsmBV8
	SYFiEX4r2PjsuGWEeKh2JoCQRP+zxqP39eb8g9BkHWg78mDCraZ7NspIse+jk98BbjIxhy
	eI94XC41AQqqbFquLW8PQzlNpvREwTY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=KuW3bPup;
	spf=pass (imf17.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.69 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775825073; a=rsa-sha256;
	cv=none;
	b=ID+n7Rwvhemt5heaJHkanrRUbwiXR3XauJyIZml4/mioFS150MxtZp9Ea4wbzn6lwVnQmm
	EQ27h9oPO5VGAKmPZ8dbJwuqrnOxEXm70MT/xwLImDTZsFZ/0jNaMFMuSuYrVWjqyILDKB
	0J7t4lLvG9JtJNqJ6dS3OpHrKk6JoM4=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPS id 8DAC018002C5;
	Fri, 10 Apr 2026 12:44:29 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1775825072; x=1778417072; bh=YLXk0ExvSFKrM+8uRAGb/whtOA3pAADUVtDTnKG795I=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=KuW3bPupyQTxzro44jBfKAI9gLAoBhmcUHmmd6KD3N0VUFUGUAncGSIblDX8ELLgjxc4DpLtPZDy4b2funZ8CEkBR0Tv3S2rxRSM/UDbnuRnfPXb9qPggbua0mJ0VHuKcXOtrVmXR7iTRUCEnQGOO+UAd8BrWuFp29inSGbzY72Ds+B7bnpF41L5kP+nqmw60W4xJ5q9i00515zH9cFr4UtzWsbfzMJK4Si27I6T+MI71H81VFcmg4WuYH1XKWXjoJvd4JgKFl/hqNf9MblxqgzmvSVRPsWHnt/KAEN/uk7Xa/fo5g7TeUzaeNI14jQHMkjNsn4bw9vzgCcx2puk5A==
Received: from [21.6.122.162] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPSA id ABC7E18002DF;
	Fri, 10 Apr 2026 12:44:23 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Fri, 10 Apr 2026 20:44:01 +0800
Subject: [PATCH v3 3/5] mm/vmscan: extract folio_free() and pageout_one()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-batch-tlb-flush-v3-3-ff0b9d3a351a@icloud.com>
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775825044; l=10277;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=tGKdWFwPZnHwuagsV9hFB2br3VeaFYCW4yO9KxlFTSI=;
 b=OFyHTTcEW4pb+CKG65b/skBmnsB++XD3E5sKI+f9WBVszMRb8k9PvzDjJIRPq1637T9bRYxWo
 CYRIk34R7/kCBu3gorVp0g2GZ7iJufkIx2Ovshlp1eSbYmEnGcemhTK
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExOSBTYWx0ZWRfX/37wF9CgZq3d
 w2RnsEXJLfaMe3LE2HbcDDr7gFacJ60oUJ8PpLKfOs+oBdjcisrSfpFXotJw1O+GhIgIlT68JB4
 qKMHbcD+NO1DYS1CozxnH8Q9IQMcho9NUfAamVutZmbYvDRZmr/iznILp+bALmouUNNpONJkFnP
 oJxnx/9348oqkSgnLsqeSuywrj7j8HiTEn06oXPcLQXJ5/U1w97Yfm9q0EmLTBj3VjCXrINCg2K
 ZJKxdp6uDJTIG5Ir7U7G0qPzxpsgQ0aEHEmD52PqZJ0V2ogvnE5ugqEaw7N40OXUZ+avZm1BrQP
 c44es404TSl4j67u1yygF3lsxkmpVi0YAaZBb/AavJF1M9ap7dCBmnOX1BJflU=
X-Proofpoint-ORIG-GUID: nfbvZmfla3ovqC2eWVzP1jBpxIzQDv25
X-Authority-Info-Out: v=2.4 cv=SIpPlevH c=1 sm=1 tr=0 ts=69d8f0ae
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=6kEm6JJsUdwq9LL28-YA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-GUID: nfbvZmfla3ovqC2eWVzP1jBpxIzQDv25
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604100119
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAB8940006
X-Stat-Signature: i7hp9qsq61ofeeasd6gjbiqfzkak9nwh
X-Rspam-User: 
X-HE-Tag: 1775825072-186573
X-HE-Meta: U2FsdGVkX1/CwnRGghhHpw2E2L8NB4Cn5hXXZufrHVAk5fJ5HC/1YDcA5uv8K9sBYjY/ueQ0RxgLhEHPKfNEQs9DQ3GvmkN9M/4i3HSvTbjOV2Uh4vwoS9xSNsJyqENmLRXRvnLnrEGtCrZ2R9fwbtLs4XIpS7kmDZ44TSPvNk2oWdxv/wv4EXdKOfpG/BeaNumT5fMomJ5T4G2bXqv/CQYJMHnlLSI4OUS7oJEqWN/NU6fhRs60UNa77CgYYz60KqQImf5elvE1/oUZocaW/yix4pGVrXDw3lBpUaKjF+byXJQxaKBET/K13O2NL3IibiJnScY+DkTspEnDcB12Pl8SzntDEc6iBIIVV15iZtTcd0Ev+hKRvxM64bHgE9DPQosKD5rEVIbHV+Bbz0tBYkUWBo9KXXptp6O2+gmqXoEOKMmNPKnqU3JtY6bEDxh/HeQ3lS5dKxAzLwzxHuyftwHf8/16T83D2Cu4gUmwqr1roV0G/0Lcs3WwEVuM2SvRNnT41VVoBdFwtyhELJ2l/9kpK4HXjkYgyMnCijjPIRV0lLbyiuhc68LXc2F13BolNy2ripOkQfiVAA12SUZ0zk3QU93dMY1sf0EXxyTW4S40k8+MyvpMv7mZG8c+wkenkFXh+4MEHJdpdFmqt1RQJSFn8Zgu5VmF6gSA2bp02Ep5l/AjqZr4qxTXrS96aghDwQ21VETY8gloWzYKKDGKDUdZ0cSXmDNsIm5kkPuNrgHzz3anGJSB3NVU49d9fZ4pqPJUlFhXxMq9+REySlL31gYO89sM/FYRBrHu5LRANQfvXujw0QlBHFXAJzLgm5IX/sz7M2g1eGTCfQ/tFDItQb1H7CbjMm9XOORtPbvMpBk83Z8qrJwg+BbhsMmgilr+qO3QLfHeFGehkSE/qxnwdScHBeMc6ex3mSgPDpk4onOVBNBIMR1Ro1UZgCvjvlDRpv/dN+/w597e7b7gOIV
 lzK7vGzb
 ODxXsyUXQ0Ox+o6bTtSSg7FBD7W4MjxbQAXqf0fBqUlNyItoU0zaHIMBcw810eRfpfddDBQlv+tP8czXtsv2ZFCuTlwEJEX25TGRIR783VoR7hq5dDayso18x/DnjvaKw5wPZj/5p7lJBbx2Ooi++bvkrlkKnzWWcyTCNu1+tj2Okitm7lsidOUh0KJhSVsnP7JgaBnXPdeHoap2LXG1th2EnmxqB3d1oU3DX7CjNjvu+lmXbbgS0LZ1KfatiYCSKdfyRM4xXlCCQDwAzD+EcB1REa8WmfDGVJSLB2S6FmXIrROHoDhPuckjUKS6C8dJ+r80dmFsYPvgLnF5pK2iIjdKSEyr/iWOVw/3nIjYQl8Ca0qHpyzBZ7buRsIaqF53QAzf1sQlsh/Uz5h8xTS9CdjjEcywZaIl0FMxLL52ijV2CbnzYlrez6XKDh2dxks39gqV6L/aVxw6lerBLSP1SfSHYpKMYAHB30sUA2SxYb8DtFgdi0mbrJ9ibzELq07nL0uayuKoip9KMJJ6w3rQXQP7tMSwk2rHElw5b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains two large self-contained sections:
the pageout() dispatch state machine and the folio-freeing path
(buffer release, lazyfree, __remove_mapping, folio_batch). Extract
them into pageout_one() and folio_free() respectively to reduce the
size of shrink_folio_list() and make each step independently readable.

No functional change

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 270 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 155 insertions(+), 115 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0860a48d5bf3..c8ff742ed891 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1070,6 +1070,153 @@ static void folio_active_bounce(struct folio *folio, struct reclaim_stat *stat,
 	}
 }
 
+static bool folio_free(struct folio *folio, struct folio_batch *free_folios,
+		struct scan_control *sc, struct reclaim_stat *stat)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct address_space *mapping = folio_mapping(folio);
+
+	/*
+	 * If the folio has buffers, try to free the buffer
+	 * mappings associated with this folio. If we succeed
+	 * we try to free the folio as well.
+	 *
+	 * We do this even if the folio is dirty.
+	 * filemap_release_folio() does not perform I/O, but it
+	 * is possible for a folio to have the dirty flag set,
+	 * but it is actually clean (all its buffers are clean).
+	 * This happens if the buffers were written out directly,
+	 * with submit_bh(). ext3 will do this, as well as
+	 * the blockdev mapping.  filemap_release_folio() will
+	 * discover that cleanness and will drop the buffers
+	 * and mark the folio clean - it can be freed.
+	 *
+	 * Rarely, folios can have buffers and no ->mapping.
+	 * These are the folios which were not successfully
+	 * invalidated in truncate_cleanup_folio().  We try to
+	 * drop those buffers here and if that worked, and the
+	 * folio is no longer mapped into process address space
+	 * (refcount == 1) it can be freed.  Otherwise, leave
+	 * the folio on the LRU so it is swappable.
+	 */
+	if (folio_needs_release(folio)) {
+		if (!filemap_release_folio(folio, sc->gfp_mask)) {
+			folio_active_bounce(folio, stat, nr_pages);
+			return false;
+		}
+
+		if (!mapping && folio_ref_count(folio) == 1) {
+			folio_unlock(folio);
+			if (folio_put_testzero(folio))
+				goto free_it;
+			else {
+				/*
+				 * rare race with speculative reference.
+				 * the speculative reference will free
+				 * this folio shortly, so we may
+				 * increment nr_reclaimed here (and
+				 * leave it off the LRU).
+				 */
+				stat->nr_reclaimed += nr_pages;
+				return true;
+			}
+		}
+	}
+
+	if (folio_test_lazyfree(folio)) {
+		/* follow __remove_mapping for reference */
+		if (!folio_ref_freeze(folio, 1))
+			return false;
+		/*
+		 * The folio has only one reference left, which is
+		 * from the isolation. After the caller puts the
+		 * folio back on the lru and drops the reference, the
+		 * folio will be freed anyway. It doesn't matter
+		 * which lru it goes on. So we don't bother checking
+		 * the dirty flag here.
+		 */
+		count_vm_events(PGLAZYFREED, nr_pages);
+		count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
+	} else if (!mapping || !__remove_mapping(mapping, folio, true,
+							sc->target_mem_cgroup))
+		return false;
+
+	folio_unlock(folio);
+free_it:
+	/*
+	 * Folio may get swapped out as a whole, need to account
+	 * all pages in it.
+	 */
+	stat->nr_reclaimed += nr_pages;
+
+	folio_unqueue_deferred_split(folio);
+	if (folio_batch_add(free_folios, folio) == 0) {
+		mem_cgroup_uncharge_folios(free_folios);
+		try_to_unmap_flush();
+		free_unref_folios(free_folios);
+	}
+	return true;
+}
+
+static void pageout_one(struct folio *folio, struct list_head *ret_folios,
+			struct folio_batch *free_folios,
+			struct scan_control *sc, struct reclaim_stat *stat,
+			struct swap_iocb **plug, struct list_head *folio_list)
+{
+	struct address_space *mapping = folio_mapping(folio);
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	switch (pageout(folio, mapping, plug, folio_list)) {
+	case PAGE_ACTIVATE:
+		/*
+		 * If shmem folio is split when writeback to swap,
+		 * the tail pages will make their own pass through
+		 * this function and be accounted then.
+		 */
+		if (nr_pages > 1 && !folio_test_large(folio)) {
+			sc->nr_scanned -= (nr_pages - 1);
+			nr_pages = 1;
+		}
+		folio_active_bounce(folio, stat, nr_pages);
+		fallthrough;
+	case PAGE_KEEP:
+		goto locked_keepit;
+	case PAGE_SUCCESS:
+		if (nr_pages > 1 && !folio_test_large(folio)) {
+			sc->nr_scanned -= (nr_pages - 1);
+			nr_pages = 1;
+		}
+		stat->nr_pageout += nr_pages;
+
+		if (folio_test_writeback(folio))
+			goto keepit;
+		if (folio_test_dirty(folio))
+			goto keepit;
+
+		/*
+		 * A synchronous write - probably a ramdisk.  Go
+		 * ahead and try to reclaim the folio.
+		 */
+		if (!folio_trylock(folio))
+			goto keepit;
+		if (folio_test_dirty(folio) ||
+			folio_test_writeback(folio))
+			goto locked_keepit;
+		mapping = folio_mapping(folio);
+		fallthrough;
+	case PAGE_CLEAN:
+		; /* try to free the folio below */
+	}
+	if (folio_free(folio, free_folios, sc, stat))
+		return;
+locked_keepit:
+	folio_unlock(folio);
+keepit:
+	list_add(&folio->lru, ret_folios);
+	VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
+			folio_test_unevictable(folio), folio);
+}
+
 /*
  * Reclaimed folios are counted in stat->nr_reclaimed.
  */
@@ -1415,125 +1562,16 @@ static void shrink_folio_list(struct list_head *folio_list,
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping, &plug, folio_list)) {
-			case PAGE_KEEP:
-				goto keep_locked;
-			case PAGE_ACTIVATE:
-				/*
-				 * If shmem folio is split when writeback to swap,
-				 * the tail pages will make their own pass through
-				 * this function and be accounted then.
-				 */
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				goto activate_locked;
-			case PAGE_SUCCESS:
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				stat->nr_pageout += nr_pages;
-
-				if (folio_test_writeback(folio))
-					goto keep;
-				if (folio_test_dirty(folio))
-					goto keep;
-
-				/*
-				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the folio.
-				 */
-				if (!folio_trylock(folio))
-					goto keep;
-				if (folio_test_dirty(folio) ||
-				    folio_test_writeback(folio))
-					goto keep_locked;
-				mapping = folio_mapping(folio);
-				fallthrough;
-			case PAGE_CLEAN:
-				; /* try to free the folio below */
-			}
-		}
-
-		/*
-		 * If the folio has buffers, try to free the buffer
-		 * mappings associated with this folio. If we succeed
-		 * we try to free the folio as well.
-		 *
-		 * We do this even if the folio is dirty.
-		 * filemap_release_folio() does not perform I/O, but it
-		 * is possible for a folio to have the dirty flag set,
-		 * but it is actually clean (all its buffers are clean).
-		 * This happens if the buffers were written out directly,
-		 * with submit_bh(). ext3 will do this, as well as
-		 * the blockdev mapping.  filemap_release_folio() will
-		 * discover that cleanness and will drop the buffers
-		 * and mark the folio clean - it can be freed.
-		 *
-		 * Rarely, folios can have buffers and no ->mapping.
-		 * These are the folios which were not successfully
-		 * invalidated in truncate_cleanup_folio().  We try to
-		 * drop those buffers here and if that worked, and the
-		 * folio is no longer mapped into process address space
-		 * (refcount == 1) it can be freed.  Otherwise, leave
-		 * the folio on the LRU so it is swappable.
-		 */
-		if (folio_needs_release(folio)) {
-			if (!filemap_release_folio(folio, sc->gfp_mask))
-				goto activate_locked;
-			if (!mapping && folio_ref_count(folio) == 1) {
-				folio_unlock(folio);
-				if (folio_put_testzero(folio))
-					goto free_it;
-				else {
-					/*
-					 * rare race with speculative reference.
-					 * the speculative reference will free
-					 * this folio shortly, so we may
-					 * increment nr_reclaimed here (and
-					 * leave it off the LRU).
-					 */
-					stat->nr_reclaimed += nr_pages;
-					continue;
-				}
-			}
+			pageout_one(folio, &ret_folios, &free_folios, sc, stat,
+				&plug, folio_list);
+			goto next;
 		}
 
-		if (folio_test_lazyfree(folio)) {
-			/* follow __remove_mapping for reference */
-			if (!folio_ref_freeze(folio, 1))
-				goto keep_locked;
-			/*
-			 * The folio has only one reference left, which is
-			 * from the isolation. After the caller puts the
-			 * folio back on the lru and drops the reference, the
-			 * folio will be freed anyway. It doesn't matter
-			 * which lru it goes on. So we don't bother checking
-			 * the dirty flag here.
-			 */
-			count_vm_events(PGLAZYFREED, nr_pages);
-			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
-		} else if (!mapping || !__remove_mapping(mapping, folio, true,
-							 sc->target_mem_cgroup))
+		if (!folio_free(folio, &free_folios, sc, stat))
 			goto keep_locked;
 
-		folio_unlock(folio);
-free_it:
-		/*
-		 * Folio may get swapped out as a whole, need to account
-		 * all pages in it.
-		 */
-		stat->nr_reclaimed += nr_pages;
-
-		folio_unqueue_deferred_split(folio);
-		if (folio_batch_add(&free_folios, folio) == 0) {
-			mem_cgroup_uncharge_folios(&free_folios);
-			try_to_unmap_flush();
-			free_unref_folios(&free_folios);
-		}
-		continue;
+		else
+			continue;
 
 activate_locked_split:
 		/*
@@ -1552,6 +1590,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 		list_add(&folio->lru, &ret_folios);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
 				folio_test_unevictable(folio), folio);
+next:
+		continue;
 	}
 	/* 'folio_list' is always empty here */
 

-- 
2.43.7


