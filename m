Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF10CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 04:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC1A6B008C; Thu, 18 Jun 2026 00:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2E36B0092; Thu, 18 Jun 2026 00:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2126B0093; Thu, 18 Jun 2026 00:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD336B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:49:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E94A71205FB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:30 +0000 (UTC)
X-FDA: 84891804900.12.1A6D952
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id E878B1A0009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FBgKgzod;
	spf=pass (imf19.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781758169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0Hrp4ly7FYGNcwCz9cInOYn+lLT0zH/zJYZGhEA7lk=;
	b=iGEaDu1gRWx9EIg9yINp4uXLDB/fLcRjEI56KuyLop9WcvARIkitBG4LvnFRstK1ETCsKT
	qu2wyu3tgQ2e8AOkUbWwSECryZHuLzkOTqGfvHSupqOrYinM1mqvR2MpN98Mgyc4FFom12
	4Twk5GoZ4xZpAdoizyD1QerZ76lwOR4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FBgKgzod;
	spf=pass (imf19.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781758169;
	b=ch5tguAibsR/Z/8ZbYyh8+Xj/nDMaas4n8lh166ZXWbJUiBEnaP0ODA3YH13hBYgubAXtP
	CjOE2Z+nlrJb8ZiNFTsdaULyagMTYdWnq7z/1AldesLiSJXobnyL/OD4ORxJMdYHGtDZfz
	AHhFMNRidqcKTOh8C7dQ0gsS+BibBgY=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-842848fd613so338836b3a.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781758168; x=1782362968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0Hrp4ly7FYGNcwCz9cInOYn+lLT0zH/zJYZGhEA7lk=;
        b=FBgKgzodaWus1u2PkvHktySVl0/X/hblKInO+sMDPOaLSCFOSMG/AtgIN4CFsJ1R0G
         HLIxuf5S2lxFsfAnEP0oYb8MXQbz3Oj7+IXM1I+2ur5e1ioa3jvc+yYkzOCfF/lmD5XV
         qILy4hl0wOwJdYE/uhqgjO+VU6BaZYnKrNMsUv2FXkGT+YE7SH+/Tw5R2vgBhG2tpxaJ
         49FsSlRo//GTFNmQtokPs2Sj6uOPAiK56cL/IjZqseoNMdEEuERpDmD8M2MXtXAhNf23
         pURoQeist+QnpAvbP/yj7Rs1LyQe/UBDMhJiWvlx0AqltL0ilhK0EOnA0l6mnJwO51uZ
         x+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781758168; x=1782362968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C0Hrp4ly7FYGNcwCz9cInOYn+lLT0zH/zJYZGhEA7lk=;
        b=JTbNVuWvP/TRltE5pT1LbQEJcdIz2WU3nE3XrZBdcOly8in9r/CVea2jVM2BD7MxOU
         zHrLINOTRH3aISmdhzH+mJgEZDbXoZLX/yVFKk12WJkvbp2TmVa9SN4Cboxi5eD+6t3N
         shHbo7k99Z5EZrNjKg39jMHB+6i0n8tp6hHKg6MoV1Ew74+uWRqY5FIZPl4zroDhVnxG
         QIXpGh0QanfblUTSjjqqvMBSPyalgjTc+bVn3ADJC+dL91VqSMHxyan22jaSjkmxtX9x
         jxZ/DheE5NpckM69KtZNHjRXao7ixw2qTUPPe7cqp+rM1NZ2kRf9ynQx1mNzEvmXfQjt
         jvvQ==
X-Gm-Message-State: AOJu0Yxdax+xmQubEibS850znub1lthDnrNM2xZt1rrdb8H1mmP+mE2O
	ypp3VHy75I1ssT1pZMtmfXWZJacjdsYbCYi2cViqSfjpr8QXUNX2UUJ3bqQBEw==
X-Gm-Gg: AfdE7ckw2ikLjRGsthueFtLuoUUHlLWof/7F8T70aU9Y357ZMKBFc1iTicSb898DQmS
	939hcl9MSA5DJ6UXfckFtMvT8SZ+iE0ruJTzEj4guekq6pMyIDlIununK7azYe7plPj7WWhTqMo
	heB6HIy0ddtVRGAn+sxMbEvj46InM6Te1KoK98egzvMnRUIWJf45xu2SY9Eef5CdrpOGimNOtno
	I16Jb3Su7fdSEaD2mJA7EuZAZsWI5v24nimUldokzQSy+fyF5NbdaRw9igPeLi2razUi4sZ4ir8
	Nwuab5tkA8486bX6aezSA7XqvpX0oZ8ZE4Bjpy1gE4j+vCkTwHB6y7Hke0lqo/FpV02PtDYK1tS
	y4/TrhPQ7bCyZeGsjsEMz5YA9J23c7rpNH8NYN1FcvbWotbGqNph+EiTMFCu8cp46CuFjD4YlvD
	Z2Joau97fZ0gEStLNds7gXCPAEMxj48xoWZBXJlol+
X-Received: by 2002:a05:6a00:27a1:b0:835:405a:7e6f with SMTP id d2e1a72fcca58-84541ba8066mr953371b3a.14.1781758167819;
        Wed, 17 Jun 2026 21:49:27 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b020b53sm17214781b3a.47.2026.06.17.21.49.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Jun 2026 21:49:27 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v4 1/5] mm/zswap: Extend shrink_memcg() writeback capability
Date: Thu, 18 Jun 2026 12:48:53 +0800
Message-Id: <20260618044857.69439-2-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260618044857.69439-1-jiahao.kernel@gmail.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E878B1A0009
X-Stat-Signature: 11nkqxxkio9ocsmgudskswsark1uhr8o
X-Rspam-User: 
X-HE-Tag: 1781758168-625121
X-HE-Meta: U2FsdGVkX1/WPKJmkiXGhgQ+slyxBFbKxqA52eHiYTzUiqbOgA5BE5n3MLN1JP4MYom8LtMRLaSXRtqm1TBnOeEK7vMmJbuaB7F8cU7kuTYzlLpY1rB8NLLvHCOVT2xTWv5PaIK534uir8xFXFGlF7MziAaQ/NMrSd1g2rrGVSfGhGyiy13jmsPPV8qkj+lt7wXkpAVm5jSFE0ewTcG3TahNWoAqkWm89ytRmdEYOqwwcsoTLlXcmjElyeSMwxnvij/JbCiUzX889CuhiDoUUuxV4HIaHIg9zmAnVdiHZxiXA0Zvuf8/dVQbLalQa5tWJVyChqTQOTVKiENU6gfzCgpZ2CxDKGLlY/kSWVp+9z+WiRbtg4r4TtRXTDqpGKGIHOBATR23mmOE1JY3Cktw8M67eQPx/3JURQmjVahyBpN6+lF/9142BjNPmpEzO1zs557Ut32kbmmNoRtaDN3i/W9TsVns2p77maNEdBss95vocePfK1MwzFtncawYgqR6mmuj6U9DxHUvgc3IR1klufvZPHpInpzsUmm+j054JuGUcWGrkZZthnHXGjfp3OhjZ2ZWVAl9z7lG09Q3tN9JNmMfbEqYmMqtTinDU8zb2wToYN3315IOml6Y0Yl94HSViYDAskQ3KMNugyfyWPnRObHKSw65X8leGTiEDVtHgNIlzDZlXUtN8loJ2Hpeu9RIJZl0CA4WdUOcyXhU0Tn1FHbqWI78w3W5QHqkyOqx1ds0lW0JkHljsVX6DKL8TQVKw0CRpJwtwvm//eQ/yAta9YFB7jWbIi1svQlTzHwb1ed4V3ZOf6oOTaed9RNebM70B+JwkrbXHNxFfFSZ8x3CzoE66N/owq1XOGVKU7qhBJqae3IbQZEEyMWPFcqvK4wsO55loi37x+8Kdd11CIPEX2QRsCEKq7dYPgJD630v9AiqR4XB6ag/mpfREencdjz2QVXHOZINrW/1WhA21U/
 LLGauJ5o
 pcfWwb2Hw4OIHDwS3oY6ImBWcxx5gK05fU5W1opYaqSPDhnFqb78+qYe+h4tPLyhJIlVTfVzHhQ5l3xFgsDqsrE6Diz8ePlChtlEfzwp8WnSa6dJr9VD+6bTs8lTvsJr5ypnF/qxOZrue/zHRK81xIW+I2dBHHZAzdvci5YxWTEQTLstlfEeGUa2eBuOPUGyl4ELXVvvl/Z2/Tq+YjQoHCA+i03pZsuyxkbGWO82q7V1fLFIbseOTmfano2X4WV36pkY13cPZe9MDzmEzxigBgCz9cuGBTtOeuHuVMU//g3XdcYrUVD3DBm5igX9U8RBX2sIfjN2F8rQ05uB6V7TgrNjjsW6fDmkypXIr/ZJd0FKA1QUAaKu0wnF6w9Jt0EeaIef9CYIvyzVDYFgD/QHNGSQCC9nD9N2Ly6y4h5Me0s6lOGfmDNslL+DK4BNT+xVAERPdw0JsUPUGbp17wUfdsoRgD0Z3mX5tJ1RCZtEDM7I6687RCiWoAQjb1LncATybqLLnS6kK7yZ+h9Ncse78wCUCjainl9aHFztbPmMrWmZGtYu4pfBswRyxUpmGlyj0jwQe/9U9Kxb9lDSbuk533V3y3AY1Z95cJdQicUXVfZuC/cQEhs/sXFnCfEO1O5JxRlMqFucXiNVjbtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Currently, shrink_memcg() writes back at most one entry per-node
during its traversal. This makes shrink_worker() inefficient, as
it must repeatedly re-enter shrink_memcg() to make any substantial
progress.

To address this, extend shrink_memcg() and rewrite its LRU iteration
logic to support batch writeback. Introduce the nr_to_writeback
parameter to support a writeback budget based on compressed size.
This enables batch writeback in the shrink_worker() path, while
maintaining a low writeback budget in the zswap_store() path.

Additionally, to prepare for future proactive writeback, update
the return value semantics of shrink_memcg(): a positive value now
represents the actual number of compressed bytes written back, 0
indicates that candidates existed but no writeback succeeded, and
a negative value represents an error code.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 116 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 97 insertions(+), 19 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..d7d031dee4cd 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -160,6 +160,11 @@ struct zswap_pool {
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+struct zswap_shrink_walk_arg {
+	unsigned long bytes_written;
+	bool encountered_page_in_swapcache;
+};
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -1089,8 +1094,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	struct zswap_shrink_walk_arg *walk_arg = arg;
 	swp_entry_t swpentry;
+	unsigned int length;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
 
@@ -1135,8 +1141,13 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 * Once the lru lock is dropped, the entry might get freed. The
 	 * swpentry is copied to the stack, and entry isn't deref'd again
 	 * until the entry is verified to still be alive in the tree.
+	 *
+	 * entry->length is also copied while the lock is held, because
+	 * zswap_writeback_entry() frees the entry on success and we still
+	 * need its compressed size to account for writeback.
 	 */
 	swpentry = entry->swpentry;
+	length = entry->length;
 
 	/*
 	 * It's safe to drop the lock here because we return either
@@ -1155,12 +1166,13 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+		if (writeback_result == -EEXIST) {
 			ret = LRU_STOP;
-			*encountered_page_in_swapcache = true;
+			walk_arg->encountered_page_in_swapcache = true;
 		}
 	} else {
 		zswap_written_back_pages++;
+		walk_arg->bytes_written += length;
 	}
 
 	return ret;
@@ -1169,8 +1181,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
+	struct zswap_shrink_walk_arg walk_arg = {
+		.bytes_written = 0,
+		.encountered_page_in_swapcache = false,
+	};
 	unsigned long shrink_ret;
-	bool encountered_page_in_swapcache = false;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1179,9 +1194,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&walk_arg);
 
-	if (encountered_page_in_swapcache)
+	if (walk_arg.encountered_page_in_swapcache)
 		return SHRINK_STOP;
 
 	return shrink_ret ? shrink_ret : SHRINK_STOP;
@@ -1275,10 +1290,32 @@ static struct shrinker *zswap_alloc_shrinker(void)
 	return shrinker;
 }
 
-static int shrink_memcg(struct mem_cgroup *memcg)
-{
-	int nid, shrunk = 0, scanned = 0;
+/*
+ * The maximum acceptable scan cost factor for writing back
+ * PAGE_SIZE bytes of compressed data.
+ */
+#define ZSWAP_WB_SCAN_FACTOR	16UL
+#define NR_ZSWAP_WB_BATCH	64UL
 
+/*
+ * Iterate over the per-node zswap LRUs of @memcg in batches, writing back
+ * up to @nr_to_writeback * PAGE_SIZE bytes of compressed data.
+ *
+ * Return: The number of bytes written back, or -ENOENT if @memcg has
+ * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
+ */
+static long shrink_memcg(struct mem_cgroup *memcg,
+			 unsigned long nr_to_writeback)
+{
+	struct zswap_shrink_walk_arg walk_arg = {
+		.bytes_written = 0,
+		.encountered_page_in_swapcache = false,
+	};
+	u64 bytes_to_writeback = nr_to_writeback << PAGE_SHIFT;
+	bool memcg_list_is_empty = true;
+	int nid;
+
+	/* Memcg with zswap writeback disabled are not candidates. */
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
@@ -1290,24 +1327,65 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 		return -ENOENT;
 
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
-		unsigned long nr_to_walk = 1;
+		unsigned long nr_to_scan, nr_scanned = 0;
+		unsigned long remain;
+		walk_arg.encountered_page_in_swapcache = false;
+		/*
+		 * Cap by LRU length: bounds rewalks when referenced
+		 * entries keep rotating to the tail.
+		 */
+		nr_to_scan = list_lru_count_one(&zswap_list_lru, nid, memcg);
+		if (!nr_to_scan)
+			continue;
+		memcg_list_is_empty = false;
+
+		/*
+		 * Cap by SCAN_FACTOR * remain budget: bounds scan cost
+		 * to the remaining writeback budget.
+		 */
+		remain = DIV_ROUND_UP(bytes_to_writeback - walk_arg.bytes_written, PAGE_SIZE);
+		nr_to_scan = min(nr_to_scan,
+				 remain * ZSWAP_WB_SCAN_FACTOR);
 
-		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
-					    &shrink_memcg_cb, NULL, &nr_to_walk);
-		scanned += 1 - nr_to_walk;
+		while (nr_scanned < nr_to_scan) {
+			unsigned long nr_to_walk = min(NR_ZSWAP_WB_BATCH,
+						       nr_to_scan - nr_scanned);
+
+			/*
+			 * Account for the committed budget rather than the walker's
+			 * actual delta. If the list is emptied concurrently, the
+			 * walker visits nothing and nr_scanned would never advance.
+			 */
+			nr_scanned += nr_to_walk;
+
+			list_lru_walk_one(&zswap_list_lru, nid, memcg,
+					  &shrink_memcg_cb,
+					  &walk_arg,
+					  &nr_to_walk);
+
+			if (walk_arg.bytes_written >= bytes_to_writeback)
+				return walk_arg.bytes_written;
+
+			if (walk_arg.encountered_page_in_swapcache)
+				break;
+
+			cond_resched();
+		}
 	}
 
-	if (!scanned)
+	/* Return -ENOENT if all zswap LRU lists are empty. */
+	if (memcg_list_is_empty)
 		return -ENOENT;
 
-	return shrunk ? 0 : -EAGAIN;
+	return walk_arg.bytes_written;
 }
 
 static void shrink_worker(struct work_struct *w)
 {
 	struct mem_cgroup *memcg;
-	int ret, failures = 0, attempts = 0;
+	int failures = 0, attempts = 0;
 	unsigned long thr;
+	long ret;
 
 	/* Reclaim down to the accept threshold */
 	thr = zswap_accept_thr_pages();
@@ -1368,7 +1446,7 @@ static void shrink_worker(struct work_struct *w)
 			goto resched;
 		}
 
-		ret = shrink_memcg(memcg);
+		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
 		/* drop the extra reference */
 		mem_cgroup_put(memcg);
 
@@ -1382,7 +1460,7 @@ static void shrink_worker(struct work_struct *w)
 			continue;
 		++attempts;
 
-		if (ret && ++failures == MAX_RECLAIM_RETRIES)
+		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
 			break;
 resched:
 		cond_resched();
@@ -1492,7 +1570,7 @@ bool zswap_store(struct folio *folio)
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (shrink_memcg(memcg)) {
+		if (shrink_memcg(memcg, 1) <= 0) {
 			mem_cgroup_put(memcg);
 			goto put_objcg;
 		}
-- 
2.34.1


