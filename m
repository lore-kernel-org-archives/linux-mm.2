Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F5E160A5BDA
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MW3DPdZP
Received: by kanga.kvack.org (Postfix)
	id 0E02C6B05C4; Tue, 10 Nov 2026 15:21:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042E96B05C5; Tue, 10 Nov 2026 15:21:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C676B05C6; Tue, 10 Nov 2026 15:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C44136B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 580461209CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:34 +0000 (UTC)
X-FDA: 85420329708.21.04225E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BCBEFA0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MW3DPdZP;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342092;
	b=JKpzq2K7/DO6LgPCmxZD9PTZShOblrdh2nqwg0t+wwmJJpIazkK5TEXbi3J/fewmLZXhTV
	VxuYpEvgiERUZMuG6QMxJhEtYibJRY2JqDRfnO7GObdWzl8leGbT/2gKbDDSSe5ul/A22E
	HgsLWP3XHbXjalvqnr7D6Tyut/xneHo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MW3DPdZP;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkWfkzdkG8JnZPnLVaaxVwnhsNZ1KUyME4j3NgArqy4=;
	b=N3qIb5K9DD+Ow/SK+CUJHTdN6PwL2dtruhxbaL1kP4KyZdC//qq6EghzVZNL3/KBEnuTOC
	thet9tPm76m80t0xACTjEHm+Nd7dwiZ9lxHbvm8pkt+POnGvJ2BWFJlbf8NhYsYeIgj6t9
	8K0VvxDro8KMDcBq7Y3cEtkn8Ae/6ms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B6DF6182E;
	Tue, 10 Nov 2026 20:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD6E1F0089F;
	Tue, 10 Nov 2026 20:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342092;
	bh=DkWfkzdkG8JnZPnLVaaxVwnhsNZ1KUyME4j3NgArqy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MW3DPdZPavU+zKRqSawyhYFMiSgqkT05HfqhIhc/hG2TTRXLTF/D6CRbrp4k5Goln
	 dYyRAKxC5Dw+3r/FEDrqVZtoosqwMSrklxq5V4APE6lpQW+lgNsd2QPr3wpgRYSiW+
	 8qZIaQXjYazDMIRZ7/h5JIhvbH9rO6IhWT86Ft+A118dpP11bzod9Pm4ZkU40Eo/sc
	 Yu20a0HSfGxA9FJGUojR7u5VjQml7vg4fUHNrEtQP6cFXrpXbX5wvptGLGidcatdrz
	 /YJRfpUMnBnTZpIM3KdhOPIAWFbKf0imBZVxr/mf6AwiI/ZdDQuoJdVYMKNS8rQPRe
	 IK5j/F42nUO5A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
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
Subject: [PATCH v6 11/15] mm/mglru: Restrict eviction accounting to eligible zones
Date: Wed, 11 Nov 2026 04:20:21 +0800
Message-Id: <20261110202025.25736-12-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BCBEFA0004
X-Stat-Signature: zkyy5qrg5u8aoysjboh7qqbg6masjmfy
X-Rspam-User: 
X-HE-Tag: 1794342092-80973
X-HE-Meta: U2FsdGVkX19EIKe9QHqv6NwxTB45ad23vsZHYXqoT0IZ/6l5YahmM0fcTb4sa7SiV0oT8EIRP/sd8Xn89eLkNcBiUk9E7Ox3Mi9G4KU2mEqNJnYLnPao77fvDA+ye5IzaO2DvUutUvKsmmwahyM1URMJWD4El4qcjasPIvhAj8EHohC1bqs5HJVukdBVnV4s6OUMyFI+HpE7ec7SbazWM2g7dp1IaUXT8OWlCrrTifCdZRm7Ffg0X7STAH4h3ne6qUjsEoxJwD4N0IGE2EkdC26GJ1kZtazf1ghXVbCAVhEs6+1PNS1gtAPsR5cgWSPdDtUvHcZ84gtk/Y7CnLrmYJJykDt26mZb/HVwAm/lHBdRMOmeN3oth6dv5VuL/GJjTTl/eR0NkRQX7bd1El9Pqrm3JQeBf8Zf1qPimvLWrieK8Rm84XwOvH/JDhKmZePZw0VQK1P6Wmhs3bnsJbwxvc5kfKNMhoktA1W//Iiif1IJGqoBr/gVDdYEavq6UDHnMJyd87B7GC1vFJ0qSAhScba++jmnbigErcO0Tei66W4ccdmqncz19viXH+ESrZkAUYkj7AbeHlOyxGBADDjYf0PL7TWpJPPUAtz0EyOj25jMr8ShyG6nnL+39siqwptPippI/iM3e2+NuLU+uOjMvOhDhvD9JMJ2cvVsesd3r6rTjw6hPxGIw9kLcJENAK/6eby0OBlPndAs2E0qhT/YiqfddPp0MnvMktbpA/I9DbSBrCDEmXMBrtS8RiGOYeLdJCCp6PEOisOLypTSh5f8Qf7vHEpM8FCKuez808pBbR712+Bgx5TMDln3dMrkUBSpZ0moUUL0X4pozD+rYa1KagoNNIOC/CZAU2/XMPFGFmXQAWZRrVstkuyo0lMABAZq0zZlENxOBEhr/kqL3is3n8ngXPJzZsiOadoDhzTp7u1rQ7oiWFoVoe+rqLGd/Cc9kxzdMBVtnTPeY6ZyNYU
 OJEfQs5D
 tOdcetsRaCDxmNqZCzGWPejXVkuDTPrFK6hjltTNm4xaBE3xdYpy3mZ9Fss2u39PmkDj+VwHUqjPro9MD3O1eT6e0qwAspwm1/ifjHwVbooi2jCRBP0wcqBk5Q2HuepenqC323Z/8cNA+r+MhbN2x6XmT5KOj77jSB2/znHbXi/BgN01juXvCglRx1ef/SsCC0t1pLjqQv1PwfdJtYT6rkCb9Qkxyhpw3W/VOGsn8OH+2Crng1GBFDwLH3Aiq8zqxZ5vqdhvzGnMFTCduvicTA/2maP0PPv4JPd5ay5YuBFKH/5wXotwakZZU+w==
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
 mm/trace_vmscan.h | 4 ++--
 mm/vmscan.c       | 8 ++++----
 mm/vmscan.h       | 5 +++--
 3 files changed, 9 insertions(+), 8 deletions(-)

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
index 8014a90e4bc2..bfc9789a999a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4220,7 +4220,7 @@ static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
 
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			nr[type] += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 }
 
@@ -5080,9 +5080,9 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
-		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
 		for (seq = min_seq[type]; seq < max_seq; seq++)
-			old[type] += lruvec_gen_size(lrugen, type, seq);
+			old[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
@@ -5826,7 +5826,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			seq_printf(m, " %10lu%c",
-				   lruvec_gen_size(lrugen, type, seq), mark);
+				   lruvec_gen_size(lrugen, type, seq, MAX_NR_ZONES), mark);
 		}
 
 		seq_putc(m, '\n');
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


