Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCC360A261C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dwyF8D+/
Received: by kanga.kvack.org (Postfix)
	id AC2556B05ED; Wed, 11 Nov 2026 18:27:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A7C6B05EE; Wed, 11 Nov 2026 18:27:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7BC6B05EF; Wed, 11 Nov 2026 18:27:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 788D66B05ED
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:27:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9C00120464
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:15 +0000 (UTC)
X-FDA: 85424426430.19.3AB3B48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E8131C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dwyF8D+/";
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fsa/3R0gWLm71S692DhPHCIO/U3uY5UaEpNYc+QUcok=;
	b=zFC+GD/PxfAV49Jv7G0dz5U+qKaYyXjoWuKi9VICx19fV2DvqYHmY2cB4ullFjEL29TKD7
	Ii/0ibqvUq8HO4dLLAjqzWo0kzrvPW3Ffqr6N2P2kJ7o7knkGOamUkGot5MbM5DsTuP4J5
	rxjhHtn5gz3HQU6wxgCxJYQ4//CHIqM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439634;
	b=vtNRh0mYCUoM8i8OMZdis5fUzmBdQCm6yr8AOqkRbNPwZOwmn0D6rfAQE2EHhd2C7jzcjG
	85IdAkDwPGoJ9a1U8dxShdA2vwWN/gGlbwDRv4BS2Sc8XMDsJEZ9IqjhkMilngTdyAcNqa
	g0fD0ImFpc0utzXNo7kXgcv8Hp19qJU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dwyF8D+/";
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F165963BD7;
	Wed, 11 Nov 2026 23:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005AC1F00A06;
	Wed, 11 Nov 2026 23:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439633;
	bh=Fsa/3R0gWLm71S692DhPHCIO/U3uY5UaEpNYc+QUcok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwyF8D+/LrZODYHsj7+QskkuOzeXpiO+SCzTot8yYsX0Viv/AoiXc+QqrXK9vD1xD
	 TZxy4ndtS1CW8Evw6X0g5IjYa92QfZkklXeVCDmmf1PaA2eJAzfcO657PjLh7RVD8r
	 ZRLxTJi7jjd2UiJI0pgoCVmTIMMXPvvcDVYGoMPEmu2kVaWYFAw3NPO1pETmSRxR01
	 uQxrJTTIlQY14ItIbOjB0wuMqUGRIrJbbGY42u3uggyQTkJWC3zGjJuJxY1TrOyozs
	 k2VtmhPNQarTTAVfTuzktjYeeru4aEgBs5PisBO4I2T/MuryDXWBlZzX6LzxNlA7dB
	 2AeWpyXPf8y/w==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v7 12/16] mm/mglru: Restrict eviction accounting to eligible zones
Date: Thu, 12 Nov 2026 07:25:59 +0800
Message-Id: <20261111232603.9934-13-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jjm74u15hxzp168qgsz5yp9yw6d781m6
X-Rspamd-Queue-Id: 5E8131C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439634-627667
X-HE-Meta: U2FsdGVkX18QK3D1JhRq005ZTADebWM4CF1U4LfOyjX3ALwk4uLjWxkZBSd7uc9MQkybPgvmnuQP8J9wfi9nFIYmQXcX+xUKOVbAaVEtg+4W0Fd5GmFpFy04HleiA9dQQ/DWlKbJxHXY9+BFvqb6QOfJS3tTQ0fg+X+f9s8ZmG60IFyQEMTUolzAvs+biPu/M0O7GkiRfRBHReImHbugTzzpvY22+ubKBL1l1E/mabsBH7Yoz2LXSCQFAOWt0xH6A9XzcAR5/7iE/PmhcSWIH694b/IWNKxodEFtsN63so+m4zy034QOKFKdO00gW+U0y2RbW7Auf+L895oOKn77UbWgfKeHh6dty6a73deX/mN2xnIKn4hw50zZV4KEJXCm7LvrMO+MOALbx39k0q11BUIY8v8KiNGd4cnWbk7puoH6rBsFyGPdniP8+jwggFU1Cwyo/XgQ+NiAweJBSPttzRPLtAohkpEIkPTt7wENvQjFJIebEpUPDLw4l/Mnw6WmCahCmTW5kXEJ6SVEqBWJ6CiO+eNGifGsBLwoxDt5D5lBR7U9weVskMDzSMxVsInxI/z0pOkPpYcxaNihDStAGfCEY9AUXrW8pPGL7vFK+PQ9oNJfdcD9Tfe1Wgp4mDm4Zafr4JKglVjbf6Iy8do6/8IPg+82RbpWS/gYJpHmQoRyfj6dT5K58MnBGCaZyVVH43cWU8lrxmvhf8wsQkeBCVQhaKdwS+0EGEOc6E8k11UBvVYKe1bHCTSa2LLDhUsmda2WLNsMJbRvE0XVk7mz5+YcFdvUsBLiAaOw2Xh6+KaMp8fqGj2ZlhHa4Ap4Gzsg0iMreKKsCjGlxxn6y0ZiS681BxwEy7lXuci2l9SfBWBxjYpEAss4Pt18uCbXKce+VX0L0nLqAKcy1ukYVSFHAVNnAhLw7uL38mK15CGngosOKLnhrJcE75W7cmg+WRNHVFoncv75+T4lcX3QLyY
 eGljzfeJ
 YHimO3M83txRYiUSXVWBKFVU2DQD1JbEl7/KUDuLZ3IRyF6l0n1ThPFhNF/3fz00E7FHsjWK2m9jX8P293afq3IeguhJEVXTgtufrW9HggBgxR1gstJZu4oWT3navCbIqK0rOPdCTRZgGhNcbTfO1IZOK9iJ7Vg1Oc0TD/BcIDhfWoU9FLd3bxW5T1yc1rsXVPpUYiM3Tliqi7+w72FgJrfpFFqfRk8gGoPxhS092G+9qVApcPmOliOIF/wFxg9eRUn1akBVVSIleU+JBZj69EPvsRvK73Z4jQXOQc0P2AkVJP7QdpvHBhBqqgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For both lruvec_evictable_size() and lru_gen_imbalanced(),
only count eligible zones below sc->reclaim_idx. This
avoids inflating the number of scanned pages and allows
aging to proceed more promptly when eligible zones have
few folios.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/trace_vmscan.h |  4 ++--
 mm/vmscan.c       | 18 +++++++++---------
 mm/vmscan.h       |  5 +++--
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 565c56428364..9dafdb5bd3ce 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -488,9 +488,9 @@ TRACE_EVENT(mm_mglru_aging,
 			unsigned long seq = max_seq - MAX_NR_GENS + 1 + i;
 
 			__entry->nr_anon[i] =
-				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq);
+				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq, MAX_NR_ZONES);
 			__entry->nr_file[i] =
-				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq);
+				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq, MAX_NR_ZONES);
 		}
 		__entry->nid = lruvec_pgdat(lruvec)->node_id;
 		__entry->priority = sc->priority;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 27c1547012bf..7a48b82ea4c1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4206,8 +4206,8 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
-				  unsigned long nr[])
+static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
+				  int swappiness, unsigned long nr[])
 {
 	int type;
 	unsigned long seq;
@@ -4220,7 +4220,7 @@ static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
 
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			nr[type] += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 }
 
@@ -4229,7 +4229,7 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	lruvec_evictable_size(lruvec, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
@@ -5083,9 +5083,9 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
-		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
 		for (seq = min_seq[type]; seq < max_seq; seq++)
-			old[type] += lruvec_gen_size(lrugen, type, seq);
+			old[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
@@ -5138,7 +5138,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	unsigned long total;
 
-	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	total = apply_proportional_protection(memcg, sc, total);
@@ -5836,7 +5836,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			seq_printf(m, " %10lu%c",
-				   lruvec_gen_size(lrugen, type, seq), mark);
+				   lruvec_gen_size(lrugen, type, seq, MAX_NR_ZONES), mark);
 		}
 
 		seq_putc(m, '\n');
@@ -5889,7 +5889,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 		lru_gen_balance_scan(lruvec, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
diff --git a/mm/vmscan.h b/mm/vmscan.h
index c6b583fc7493..2599d7c614ac 100644
--- a/mm/vmscan.h
+++ b/mm/vmscan.h
@@ -119,12 +119,13 @@ struct scan_control {
 #ifdef CONFIG_LRU_GEN
 /* The number of pages of @type in the generation @seq, summed over all zones */
 static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
-					    int type, unsigned long seq)
+					    int type, unsigned long seq,
+					    int max_zone)
 {
 	int gen = lru_gen_from_seq(seq);
 	unsigned long size = 0;
 
-	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+	for (int zone = 0; zone < max_zone; zone++)
 		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 
 	return size;
-- 
2.34.1


