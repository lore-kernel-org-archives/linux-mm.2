Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512BC606D815
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=cFDKcD8o
Received: by kanga.kvack.org (Postfix)
	id 57D726B05BB; Tue,  3 Nov 2026 06:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52EDC6B05BC; Tue,  3 Nov 2026 06:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6A06B05BD; Tue,  3 Nov 2026 06:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9626B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:37:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AE6B1603D2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:28 +0000 (UTC)
X-FDA: 85393607376.29.7B1B53A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 96BE740008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=cFDKcD8o;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzSkHTcO0a3HdoBG47R7ltqRhcp97RPhOPTJVt3x6Qw=;
	b=NAq/KMe+eHfNPofBEQLq+laUuNY2Wo2ShtJ8chbgPcVYtFK4qnaFCrCR5iuKSXBqPU4mEo
	zmdCnWFR+kcuFqBg4MwoizkYwWyWz+RfHXcdrCNWR/IPV9zZSdBVn+aVu309hfCckJYepl
	/k6i/30VgoQ7BZwGM/wseBvsRNBzZQU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705846;
	b=sq0citWr0FANz1jROmbFgXQF/MBXJnte4mJNALJO1WOWffcuGvSoLjF6VNB/5xccZhoBC6
	73SxIqdObKszY+dpdYLoehe2+RwsU7Kk9wlTqMF4Gu4IlrFmmDT31N24avOlvrMgtFiAbP
	DTkHHNSDgwMA6OzqJtvvtE3pVu4RHHs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=cFDKcD8o;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so36271665e9.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793705845; x=1794310645; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WzSkHTcO0a3HdoBG47R7ltqRhcp97RPhOPTJVt3x6Qw=;
        b=cFDKcD8odXrhRnQxr0lIFr/tTEOxzBzSd1Sqt9oJCouWdDHiVajpCf1+AwN4JmWHgz
         C8WMeVHN0TH2AF/mTL/DD89LefqId3a8Kdo/8cYGczOu2usLZkVdZncvEfDPkEUht+Q9
         fg/wcqaZqRrehugHuFTrjkKEmKF9L2mo1H+523CE3bcNoCZf/VDarMOLVolmrSLVI9fB
         NrkZieFc/qu1Fa6Gy1LKujRMOKRKCkwoVltn6iPeRgWcwQ/VRpcV3IfD5BEPyO+czmV+
         6xm/qQSJW/BYlCbNeH+yWMeTVzrtBQuDiwzXrvCbqqeGYr7WjU1+R5tKjlBziyZFyDX8
         BvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793705845; x=1794310645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WzSkHTcO0a3HdoBG47R7ltqRhcp97RPhOPTJVt3x6Qw=;
        b=GtKwj6LGHAPY4q+AltIZGlm4s0R0QhQPMUh8SdxWkXzvFVkqXqFR0o5kG7tL2z0ag1
         +GcMEXjzi4S6cdyFZI3jys756Q5BzwVRbonE5VfQvFIDJuBXF77ar0h/BbyxuBXUjrwi
         Fiy0yAz9N1OjkhQpgU5Cljk09+6VouLzxzGM6d7C3RFgZiY7BgGtqz8u1v9d5y5d0iYw
         GJsC17sMq2UIcytl9QLQZ6MrRPSlrFcQesOPq6QwPgzv6d7m7yakh42rHPeJ0h6HcIUL
         BapGBsYMHL5DALliYAhPjIhiotFpcyI1xPJ+xDK7GpqpqCvNsxsA/EtaDPFiPAGJ9Xd9
         tiiA==
X-Forwarded-Encrypted: i=1; AKwUvBwpIaxIMFLCNZ8ps89fKh86STkTIZ68KqOOsfxWDX3TxQ80uFwixnT2lVnaq0Xa5212XdQaXPdEaA==@kvack.org
X-Gm-Message-State: APuU4Z9Gs0ADXVPpl4NK++wN500QlePJlvTdpU5sYkelAOPMI0syB+5d
	GAWoDF4TDpvQBWT3NOI69pznna+XeKIsepTVqB+2wtFLdw+rq+sKdk1flBsUkjra7iU=
X-Gm-Gg: AYBFou3+jDDgvqYrI+Nd3ItoPUirR38qtB00zKm9ySaTeSvbXSVttI686QNxW1lCcrD
	5HkotGPdDyKm9ovHfWm8pp/SWJM+tQg4MpsPUFhC0/8M+yXmlUkox7sZrxtjJBTfaMs1jDeKhLe
	gR8gK4RAq1l+9yNSKWtqv3LQOjE6h2H04sl/e3c7V7HavixJh/IVfN0Y1U2zf1lLbgRhPGjLFxV
	pxXOs5dh8e7+YQBlRnb8SdZqygqfIp+iWbCJJ6fm+JPP/U4ScDI9nbVWlcm5mx9FCpNtjOOud6M
	2P+JmaoEq37NQ+7efNiC+o/k9ckYGsaJi5iNWPnKQTRwQDnr576D1xE1HXRGKWQpMukYtma25fk
	Fdjo1+LBTMRsi6h0dm/reTV84tVGwLeQQEKNgoaMc4gAKPsoIkwN3AyWPrfyji63hAGIjnhxqX2
	phDUn6uBSXpo+0gYAmojsZyiluWYRBWtr+6htVviAQYi5E8UiFHoTYueh+v0CC/TkX0HTLWt9qh
	LfsTfpdtdcIXvuaqTpiG3D6WYBLPvY22/4CAul4FH16TvLdv1bmNYehDJb/Q6unQJqZqQ8IYApA
	DBuXOX29U9TbmFb20gCmLQoh3W/g+RLaIEWVslYEwS07UN5Kp4tHLHIv8J05h+57TB/eWicLCDp
	eP4PndD5a986JBVDpcd3KY8gGmkZMxA==
X-Received: by 2002:a05:600c:628d:b0:4a1:9663:7633 with SMTP id 5b1f17b1804b1-4ac17d16b99mr288398315e9.11.1793705845239;
        Tue, 03 Nov 2026 03:37:25 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78f95sm23000997f8f.28.2026.11.03.03.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 03:37:24 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 3/5] mm/mglru: cache the last memcg node, make tail insertion constant time
Date: Tue,  3 Nov 2026 12:37:08 +0100
Message-ID: <20261103113711.1832834-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103113711.1832834-1-max.kellermann@ionos.com>
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: i1ep7isutwsri3yib5bsow7a3798gtfr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 96BE740008
X-Rspam-User: 
X-HE-Tag: 1793705846-141138
X-HE-Meta: U2FsdGVkX1+TSYr/wMRBh7wg4p0YNXbe+pw1dW8AfcOAsSLBWq2PrEE3fJgXY2uUpAWOYBUJLeh2HjiNs3f74+Bx6NbPQOoFnzJWnEGFjcMPxXHCtk2MdOHgOVvKHkLxCXlIjAzPAKdNQCpsLW834SZOIKW8Ah/luc8GB3jjhmZdkC11cGW0dAkBUDUrWNSg5wyEKNV0rJB+sjZ/8Sf4z9QsZHC/wbTmHx1Kjd4U6++I/bpf8Tcq6wFcjoGByxbKDFTQWmxGxqPuh1ChYo49d9affAC485FO/zuo9qcCo3AfmV9dNPiZr6d1ZiWXpVvO1WZAnPYyY+QqoTN8iRSYAUC399/KrHMuKT0cRiCEVbWArV/eGUeDrdrBw4lacuVbwtioLL3M3ToF1AeGnqBptofOKRMuJ5V1M3UA0hUKDeTrWa8j8m4r8N3OlzJcLifNyQ+WibPKeg7ZPLbO7XPCSfQmylFAzBjFdG6ZnzZjPUKMv9TA6uHnvOLde6chQD9qwtJ9aetwjRvGzvjRqikT6H5yjk48EkUgoo4JoW+9XkdaSjtBJTTqS/+fXWQ3aX9srLGRnOYyConwQERRLG2iB13SrApEgXG+iYiM4Z1MVQ0qEIkQMy4Td0GafLtzr8S6YwDjYv4wYj2dIsLQfRQW+dhZXZqwZvO9MH9uaiZzMBU6T/zXYWJ8KmeOTlw7wHRUBN2XVhsFYdRe/WkX4Mt3RmAayv//gBDd5mk8hnsqPMFxfMChLtxJxHmKarY2KxbQC5xFNiS15VOeLu2Ws+07TfPkY6Z1G02cst+0CeauFr0oTq/Dex5B+0BcTD5/j1hwMNKcPNHgrouRAc1MS9Z5Jp7Ktar6g27vHoI3bqvtIXYI5LYfaLslJBKDKmHBz9GVAcGTWYS5z/4n+edbnp+EBVTKyi05v2N49wygwsy8WFnYxpC2/KsRgy5nqOIExvycx2Y5kfqAR5mLwXit0mk
 q54kM0t4
 e6q5Uf7PA0sViAWza/rf/RYVcxrxrHfkKafe1nx22PRz0dfEW1nNIIRf71yWeCXIjBbP7ZaDUWMYXHdxcZcSD+kCb3dBGB27flz0EXjGwHcUfS6LLm7wkVGoaKkbsxyfPQ5JqYfv7KXlFEoX8reDDA7eoNGPD+u1RdG48/UumctoEsypRITz39eD+fbf5PpUC6WjSg+ySpSWqzycVRjxUBG81qYfhC5qRfj+2GH/fCGqL8u3iDh4EDqikTF9loDu+5UyLtJT+rZme1w8NLuK5jnzqrnHe+ZEBD0nvWFZTHe3T0fmX/Mdd6aJs4Sx8jPV6H/mcfSpWEat4SDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu()
which walks the destination bin to find its tail while holding
`memcg_lru.lock` with interrupts disabled.  With thousands of cgroups,
this takes a long time and causes severe lock contention.

Cache a pointer to each bin's last node, making tail insertion O(1).
This requires remembering the bin number (but the new struct field
occupies a hole, so it does not grow).

In a micro benchmark that creates 1500 cgroups and repeatedly writes
`1024M swappiness=0` to `memory.reclaim` in 8 threads, the request
rate increases by a factor of 9.5 and the average duration of each
write request is reduced by 89%.

All writes return EAGAIN in both runs; the benchmark measures the cost
of reclaim attempts that cannot meet their requested target, not
reclaimed throughput.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mmzone.h |  4 ++++
 mm/vmscan.c            | 24 +++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ecd1ebd49756..08928179b8aa 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -570,6 +570,8 @@ struct lru_gen_folio {
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
 	u8 seg;
+	/* the memcg bin, protected by memcg_lru.lock */
+	u8 bin;
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_node list;
 };
@@ -664,6 +666,8 @@ struct lru_gen_memcg {
 	unsigned long nr_memcgs[MEMCG_NR_GENS];
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_head	fifo[MEMCG_NR_GENS][MEMCG_NR_BINS];
+	/* last entry in each bin, or NULL if empty */
+	struct hlist_nulls_node *tail[MEMCG_NR_GENS][MEMCG_NR_BINS];
 	/* protects the above */
 	spinlock_t lock;
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index aed56d452881..3075949bf641 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4561,21 +4561,37 @@ static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
 			      int gen, int bin, bool at_head)
 {
 	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+	struct hlist_nulls_node *last = memcg_lru->tail[gen][bin];
 
 	lockdep_assert_held(&memcg_lru->lock);
 
-	if (at_head)
+	lrugen->bin = bin;
+
+	if (at_head || !last)
 		hlist_nulls_add_head_rcu(&lrugen->list, head);
 	else
-		hlist_nulls_add_tail_rcu(&lrugen->list, head);
+		hlist_nulls_add_behind_rcu(&lrugen->list, last);
+
+	if (!at_head || !last)
+		memcg_lru->tail[gen][bin] = &lrugen->list;
 }
 
 static void lru_gen_del_memcg(struct lru_gen_memcg *memcg_lru,
 			      struct lru_gen_folio *lrugen,
 			      int gen)
 {
+	const int bin = lrugen->bin;
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+
 	lockdep_assert_held(&memcg_lru->lock);
 
+	/* pprev points to head->first for the only entry, otherwise prev->next. */
+	if (memcg_lru->tail[gen][bin] == &lrugen->list)
+		memcg_lru->tail[gen][bin] = lrugen->list.pprev == &head->first
+			? NULL
+			: container_of(lrugen->list.pprev, struct hlist_nulls_node, next);
+
+	/* Keep next intact for readers that still hold this entry. */
 	hlist_nulls_del_init_rcu(&lrugen->list);
 }
 
@@ -6101,8 +6117,10 @@ void lru_gen_init_pgdat(struct pglist_data *pgdat)
 	spin_lock_init(&pgdat->memcg_lru.lock);
 
 	for (i = 0; i < MEMCG_NR_GENS; i++) {
-		for (j = 0; j < MEMCG_NR_BINS; j++)
+		for (j = 0; j < MEMCG_NR_BINS; j++) {
 			INIT_HLIST_NULLS_HEAD(&pgdat->memcg_lru.fifo[i][j], i);
+			pgdat->memcg_lru.tail[i][j] = NULL;
+		}
 	}
 }
 
-- 
2.53.0


