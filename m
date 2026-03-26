Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD69106F302
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D588D6B0096; Thu, 26 Mar 2026 04:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30966B0098; Thu, 26 Mar 2026 04:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45E86B0099; Thu, 26 Mar 2026 04:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE6816B0096
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:36:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 710F0E114C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:58 +0000 (UTC)
X-FDA: 84587558916.05.5DAF344
Received: from outbound.ci.icloud.com (ci-2005l-snip4-7.eps.apple.com [57.103.89.248])
	by imf12.hostedemail.com (Postfix) with ESMTP id 57A9040007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=InriqrVR;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf12.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.89.248 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514216; a=rsa-sha256;
	cv=none;
	b=fOWoriEdzSQtoTrJX2OvLdRiEInnK9I/xksewcuxtYdNGGPMlmifmsyjSR6R1/jx5Y+M55
	yxDtCJkBYrG1W4HRgOHob2BxVafEx9tDEie/FTEpJ/XXJVl31VYZMIwZ58Ys7jIcsWuSSE
	j79W4SIsGGP67IuebsMIth1lgmhYpn4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=InriqrVR;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf12.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.89.248 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLXk0ExvSFKrM+8uRAGb/whtOA3pAADUVtDTnKG795I=;
	b=bjO1ZN2Rg8HzwK7Sq6y9ozYti12E13o/xF33uSghFRuFGZEcI9ALK3W95eV4h/KTmr3h19
	Zu2OomlUOaxm+2CNJ8ob8srSszZaZCW8Yydp9XdHL9WZEiM8iFlKwRM8goEwXCZyXND6oE
	3EyY7LKw8xGXbY5usZ1Rg/ZinvEIjsE=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPS id 2F1CA180021B;
	Thu, 26 Mar 2026 08:36:52 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774514215; x=1777106215; bh=YLXk0ExvSFKrM+8uRAGb/whtOA3pAADUVtDTnKG795I=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=InriqrVRXN+ao2dHfSY9otBp0V80Z8N9f2S/e+6JXttHjS/ywV2nytGKkJNkjSyLt49XEHLo42VcZyg6yasJjCWaHjnt/b4zLRjcSqRPC8jfvhZ/cxn3IkXtZz5aQhE1WoRLF71HY/w5ax+niIxOWXA34mKYOB8iqDOSDHeAVdDzRTD5hdPjTcr0+eKdzmvyc5H3yk+aPIPGW0vsDc6FdUtGoNVRKODbafjBvITfdXUy+6NLA1Sgk/6Kq9BFig1VD9u7pPPKz4HPgyBdp9B+357Gf/qFo7+t+8kz81neBU26aAVKIpngM9v3P7KIlEqhSBbSDteYIaPcrvWqpzudig==
Received: from [21.6.122.162] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPSA id 03D39180020E;
	Thu, 26 Mar 2026 08:36:45 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Thu, 26 Mar 2026 16:36:19 +0800
Subject: [PATCH v2 3/5] mm/vmscan: extract folio_free() and pageout_one()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260326-batch-tlb-flush-v2-3-403e523325c4@icloud.com>
References: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
In-Reply-To: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774514187; l=10277;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=tGKdWFwPZnHwuagsV9hFB2br3VeaFYCW4yO9KxlFTSI=;
 b=BfHYyYtMeMcvuuxKlM+EB/3NcQwptDx1pljihw1sC/Hgur/RIhDv8u61BAz1gGYS/n7l4PAoO
 So0OPSRtttqDubi9h5dOc/0f3T4anU7PCn2zP49TkNfQYJHT3C4xoo0
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: _FmElwohPil0BxWOL18C3vy9v1uORJtF
X-Authority-Info-Out: v=2.4 cv=PPsCOPqC c=1 sm=1 tr=0 ts=69c4f026
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=6kEm6JJsUdwq9LL28-YA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-ORIG-GUID: _FmElwohPil0BxWOL18C3vy9v1uORJtF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MiBTYWx0ZWRfXybuUeK+i1g/t
 wvRROGQBuy0Dkheqa3i6WJn9rDsJvNxzLG2VsttkNE0V0ShkM3KoZtC2JDYnEe9LyaBO37DO6Qv
 MhinLd6wSB+QGhydV2e1oU6vN9zYNTwi+JwFiqjpIgCsiCkg3HYtyMxWp2QJPJtbAtPaAheo5vp
 u4gmNtCVt16jsdhRCbj0rSZyHyB3w5fvClxqqABJsjaBtQPf3WGsc3Q7BcDIxwU4cn0LCiMhF6G
 mGKHQ/fr37I3eD3zwx8Fk1zhudNX/wkMvYV0Is2ESs20g8dwNW/rt64+kSNS5mj3G5FpamEmqbB
 GfifFCn9ZRlDIwD6dpOSwTnn/LRcO3I6AzqhMOU2mhrNUY2lSNX9byEqVfcQhc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1015 phishscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603260062
X-Rspamd-Queue-Id: 57A9040007
X-Stat-Signature: wap6qxnpmynp44airm9xmdejc13zh1ai
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774514216-614390
X-HE-Meta: U2FsdGVkX1/w3isv8+gTeZXsdTMobW6d1lgLqWK3LkoEcvQC1iyJVaRRGSDgvrzmVUxf0j60FSyiz5ieTD+wytlkSN9VdLp/YpDmLeF+xD4T7WUo8teP/kobw0QjpZ0mih8iUvq0hCHeDBr3Mgb4ZlJ1W37Je/nfzKTTfwlrTbcRsxlYi7d7G8fVd+X0g99yJRu2S0tOi2gR1VHWf6E8rVdtihjCp0WE0C/8plyZocuM7tzHMEmdkWsLFsO9x3Ta7uSE/taTBmd81PxmQw7IgqphcZ/+CPXdudvB+GNGD/OIq9C8D29IlHeFcfmh6uF9FmogC/FVFaJDpAa1NoezUXqP5l0m4GHygJLoji1iwXPRkCbU6FcCsxZuHn1yLp57vZTBIvSWaYpFtqHbJCMp9Udm2hP0XBOnSQPnhv2ROG4e1303EofjtbX/W/Peh8mG3U6q+5ieVzjLzqW34zDXxHFg5l+3eKEruQyQMyixdHEGLA8yaOrvBasGSGhmTjJ2SONNQG09LOFHdC+Vdlk6x8Dqly+5HxA1VXRkEbCEyU7JY3HzR+F10qWuQAJcX51y8s8flPN9DcE/yZb+RE6wToH8bHhPrPgmIVsIiMLBRruE+nJdERSOJObk+GvZf3+YyC50MDSmS6LPTTyoMMR4JnitNpZqE6JEPSGThqlre0hJGPitP+5h0XaNAId2wDLZCyKOQW8xF59oMPV8NhJ0AyKjx1pcIXvkX16m4x+4+WQow66nTFENnv6xCRE8xrs3itLDJcYdDVfCWLKDNkxQ4XTmrpe/fScGC4VQ0gpxZ5+Ex1VB50xPWBOP0barujM4qa65BtRvfrH2AJly88W/w562UFhdsGVRm+m9hTFDNbHm3pRd7p8qDEUsvNBd0S0zSUhucYyzPaSSzs+nTZGrUyBaIIe6PZkt1vmIZ7bDdt7MfCZLj1QzOIFDdKYVPYVXAJ0KxWPc/Pq1TM/Ljw+
 FkkwbV+c
 kySsXmK5CiuBAzSsrNk2ghbjesXcauT48Ys9afch++9+mlzjITlgOhlOcN1DNyjDZ96mDKYclO63N6UvQQWPDP3OmedoUY6HIMZ7UXzc44m+bJJZkqXbe1pw/ie0ZHLpjl05XDOnxz5DMArjSv0fqvHX0v3TlU63B/tu3cSleIirtpelU9pZ3zapmRWbivQXwlGPgqqG9k62obGfXZYYYK8T5WE0+sbvsAOhVKDCp3cuxHjw6rl2hyu0NI9sqWeUheJE9N/F96ASeR/8htW1/MSQtQUb2WHvsNHjK1Tfk1wHNvuioDUEn4ziKRVO+1jGqXnsPKjGcEr8/R1LlVCVijPf1uaggfa+w/7uurNOG3mwCTqsIDT9mnZLqFDq3upxbDzPw2HGx/WU+znWdgaCabaqQ6PR8zQeJDHg42wXP74Uw8EIcZgyCokIxV+eFIh11I/Qk
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


