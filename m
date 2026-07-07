Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D52C7C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDA096B00A0; Tue,  7 Jul 2026 08:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B916B00A1; Tue,  7 Jul 2026 08:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BEB6B00A2; Tue,  7 Jul 2026 08:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5626B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:59:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D44DF168CDF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:59:56 +0000 (UTC)
X-FDA: 84961987992.18.1FB2595
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id 01F7880008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:59:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bS83L0eH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783429195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RSA218qTv4mgdJzlBuvqRuFwwy+LpVW2vHjrCuIOTHM=;
	b=bWgKPcB3mY9n9LQ8XkSU7QjYFVYPTBclkvvqXKXlRpCCpickx28amO2Lv9ZTv+F89ic/gh
	LAxDIjlEXjtSSDzCaaPGpcsscyRv1lo46gm3PL1AhpS/ZtZLGR0lFN3NWdlUYmmbZjEmN/
	98IkJVHTlzbVv+NmzqLGNTxbY7FeE4g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bS83L0eH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783429195;
	b=loSqdpBCTgQN6DunVjKTRdOKolvCIZ+sQWYlhy7l1SB5swdjvPb972kfvgcJ70rv4gtBiw
	gGEpHQU6TDXjtJTJrGTIWe9PL40E2c2FCkiyqJV7IH0Yht/kz6HtlzAnP9QOk4WMiKmrgW
	Tt6M7iNEgrRjPk1lo+WtoXNBdbs7Jgw=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca696c4b152so31715a12.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 05:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783429194; x=1784033994; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RSA218qTv4mgdJzlBuvqRuFwwy+LpVW2vHjrCuIOTHM=;
        b=bS83L0eH9w65hm/21Xm9mdwowpLJpnr3U8oNIZ+mNuK9QnHwD0wo2Lj2ntVLDuWa9N
         MOBIunglCreEM11e1HKeU7J2nQzuB7oUN06R7HvJwsSfzbzrE7E0cBeMwapHjKonp9Ab
         cvsaYYsDRJlPEiCoQr0Ja23dEfGflJwFrfB4hBHEv5u8eTR0cuuij5/HrF4z9URH/wkx
         NLuem/+qCw1AanjffFQjrzN8Wyg1GiEblM4XaKEpc0vc+SdGIoi2YHGIKQGpqyaHDbau
         yXLY+IuvuFXQBviH3bwIIDxYFa7kUO4i+eDLzQaUYY6reYNYeLADlyUiJIJV+sk02gU2
         kVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783429194; x=1784033994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RSA218qTv4mgdJzlBuvqRuFwwy+LpVW2vHjrCuIOTHM=;
        b=kXqv1M8/9O3TzmM2SjLK9zNJieCvBhzG4Ba3Wd4B0jXjGwiFpxSaH34MU1le5WrGAO
         A3RvkwuOQmng6Coam+SV3yWOX5iKsMAt4IVaSpc4PQL7x5yZOv0TOyrEZiK7/A++Xier
         3YwOS16IpIAlCASAY3K0VyCs9AbTDlTjcilDne9euxCu65CEnx/bDvSizm+jzApEnop/
         ObY0U26gBYGtvNWHwFLLU1MNSzI2W5Th/q84iIc8WR/o35BpV+ANPRXNHFkeV2uGKqLu
         ohGzZOwd1WSee4CAkg89/oTMCPMNRfDJajnu9qvn8vVuZkbCtAhJV/6l7RqQ6wTVyq7W
         e6qA==
X-Forwarded-Encrypted: i=1; AHgh+Roeo9p8uvwl1ZV+TUmhh02pgE3BXYHbJUSgc8fu2N3ew0WeVV6Edjbvw8X+UrERpPsWSNWjr5yRrw==@kvack.org
X-Gm-Message-State: AOJu0YxuoyJgT1n83wq70V1IEdSJko4jKd4mYIJnpRbcVuiQg6BKwgKe
	RqivNp6KtricCiFnvApXMpzJoxzDVKQoVu3LWaiOGbILWxqi+AYftfex
X-Gm-Gg: AfdE7ckcciE8Q4htE6vefXJrcSual7otzExf+7vZDPPMMdZ44QI5ofpK4dZJ9yQaE/l
	q1xT5XoeyMv+pOMLzt6DHbMO1kovFV1WNR9zkr64RluO8mOYY8JEQSLeFIPAOaWA1NI5tzrXCoR
	nuG+jiYYwbjtwkxReNVWC0ZogewiWHBvE8DOpka0lHXddF35J7L9PSMpxejtRtZ2RLWN+zmhmuX
	NmWDQGqyqmlOvAzyi7h9U7BPum9OpJC6oGjse7/1qG9P7zAVF04vp11NzdHQ4hWOs/BW8wOT5dF
	Htk3iOe64Ao1+KhSGrduEkM8cXn/oKEcKDopkEYz6MQqYdzljrvlm6MSipQWlojrr6w9nuHPUcy
	8tayJjhri+4sj6q+r0dMBwk30higFprqVWBesxzH8RvqEIXksWKVV24it/Hvi+yEF94epB06t+z
	2j5gXU2rHcESvuQiFx7kHrCuQTrQ==
X-Received: by 2002:a05:6a00:760a:b0:848:2f74:d8da with SMTP id d2e1a72fcca58-8482f74dc6emr1994798b3a.75.1783429193368;
        Tue, 07 Jul 2026 05:59:53 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5415983b3a.3.2026.07.07.05.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 05:59:52 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: vbabka@kernel.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	Alexander.Krabler@kuka.com,
	hughd@google.com,
	fvdl@google.com,
	bigeasy@linutronix.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	pfalcato@suse.de
Subject: [PATCH v2 1/4] mm/migrate: do not migrate folios mapped into VM_LOCKED VMAs under compaction
Date: Tue,  7 Jul 2026 20:59:22 +0800
Message-ID: <20260707125925.3725177-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707125925.3725177-1-chenwandun1@gmail.com>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01F7880008
X-Stat-Signature: u18mdraycgnkrez5swbxbrzwzkopg9ec
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783429194-614136
X-HE-Meta: U2FsdGVkX1+FqBJyzWWNzC5zx4TzkoANvG6xhIKp1Y23mFXgTUxowfzDnvQ3/gZEU6BvgNSEz8hV2Hv8ux3cNCV21yowwVjF8GwoaqxKTEv6ddFc1Cj+ALstklK08TiMQk3xMCz7LBzpOCQSAtVR6ZN9DYQ0noG98e5qj510xb6gWOzCe4jRchBqmam6Hyj1ZvmGgrJY6o1TexgU4sVlm8xWJuD6T3h4n2RbzDP97Xq9fKj0HJ01LYWmcyfHC1qYZmi6jlumeFR+4bUkfTgj6teYPbfFq2KNhsFLRCm2jjn8Q+Mm3lH+uA6gBp8RfzL7S12ae9pe8f0N1773jz2qDqRNB3YKOElSA0yLODe66w8Cch0+Cfpf2d3M/zmNHjjICx1aU6LaMf9Q9+2a7QLwWcyB+8UFTjcHWYTUrm13kp618yZHqndfsWilgtJG/sR/3nH2x9Tbt9UOB5mjbg5kaKVFWZpiFAZw4SZ2Sq3pTN/D088MTROZiXBOpHO0opyE4n5cD4xXaa16IYTdEEOyBny4+gHPR0je9R9WCQusARuOMW4xwR1l7NxvAiKsHIO5fCMRM0FS+HirbNUi9nuupPKBwp/axEj7+MeJ9wNnL1gIEZjOtXBlTejMwXDCNpuQIC+PHxhxNev0f/onPjuj8UDlMjxvKC04kx7fW3viSN8wOWsMZ1/4f1f6o+T12ke2AabCXJ71puhBFECexqCQ1VHpRNTLPkM34YfjQyu/p1hiS/bpCsN+2wVyxUwN5Ksb24CDZmRUWQEmykblbHrGFinXqBBqdKmvnJ8dXYL6Qnb1V3o8ZdjhQ/A5zu0gxGPzm51k3Dlnm9PkC7uHkjIkThLvOCdW687yYMb/8YSziCvogjxfBDGbSRbzPfmoMcm36IAUjBbxzDGevyuX09QDvbpicdZdqUWptLQQpU7srYH5/qAuPeuMLJFhNJGrV5LsFl2i8pHfcLdhnUF1YWi
 Hf2PoO0Y
 vacouhcZmStjeBfTFVO3C0oP5KuDqnCPIJTfyLZY5/ci8rCeVrFmTCQc5ZkC368nhqdPdCusXCPq1YG6OpGAk095/iFuzw/4OX7zqoISoLpZEZGNyXqPIGa/n3gROTjfO1Ar6mt067RS4l/UYJHIYBJpYZpbwgrFiQyy//6o3jAzN7Qgn5ZUw7+SF4WLXWGmZSPQsJXIz03DEsMsTcPfm0+ZjNInH0kud1MShT3cryrOEuQRMTSPLw1/RY0RI0TrkVQCd4fsQuPxrnCZwNjLI1W66E6sAtTe3T4Nj8hNoIe3m6ATEIwa2ccNGWvN64COedydpStKIgrtn+6ntOEOeE19OBpBZYYmfkZdfn0FPH6KOt2gFxGxA9R7dtSE2T4czrrbB782Tj+lD44ob3/9d5404SIevKEvOO1eA1Mg5ji9lK1NwWX1RRJ2v5HDtA2pBO10qvGRQFsanwGtCCT+XnhkG/1CZkF3VeF6aa/912NJptBT4ND3jxe2Roi4ScN1C3UV5v2LlXCYuCZPQJTc5KWhJijmKu4ckEzKrREwqgK6uuyoadFIx5C+Iqvujetso8MviI964BX5xDUVzGB7KyvNB3zTd1/Ju4Cn/+Ey1uNkZYGu2Gu4NHICPgp+twAK3kNwUHWpWZMZbWQidxSLZfHQIlrJ/OaSljBU5MmXkHqOsVktH4vJbbAshDH2e96lOF9Zgccxt9dcxA5FruBT0ZkQSxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

When compact_unevictable_allowed=0, unevictable pages should not be
migrated. However, mlock_folio_batch in the mlock[all] syscall introduces
a race, mlock_folio() sets PG_mlocked immediately but defers PG_unevictable
to mlock_folio_batch(), causing pages that are about to become unevictable
to be migrated, which violates the intent of compact_unevictable_allowed,
and causes spike latency in RT kernels [1].

In order to fix this, migration is forbidden for pages mapped into VMAs
marked with VM_LOCKED. In addition, two early-return paths are introduced,
filter out mlocked pages, return early to avoid unnecessary operations.

Fixes: 90d07210ab55 ("mm: mlock: use folios and a folio batch internally")
Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/ [1]
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://lore.kernel.org/linux-rt-users/33275585-f2db-4779-89f0-3ae24b455a67@suse.cz/#t
---
 include/linux/compaction.h |  6 ++++++
 include/linux/rmap.h       |  3 +++
 mm/compaction.c            |  8 +++++++-
 mm/migrate.c               | 23 +++++++++++++++++++----
 mm/rmap.c                  | 12 +++++++++---
 5 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index f29ef0653546..04e60f65b976 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -106,6 +106,7 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 extern void __meminit kcompactd_run(int nid);
 extern void __meminit kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highest_zoneidx);
+extern bool compaction_allow_unevictable(void);
 
 #else
 static inline void reset_isolation_suitable(pg_data_t *pgdat)
@@ -131,6 +132,11 @@ static inline void wakeup_kcompactd(pg_data_t *pgdat,
 {
 }
 
+static inline bool compaction_allow_unevictable(void)
+{
+	return true;
+}
+
 #endif /* CONFIG_COMPACTION */
 
 struct node;
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..359c7426b6b9 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -102,6 +102,9 @@ enum ttu_flags {
 					 * do a final flush if necessary */
 	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
 					 * caller holds it */
+	TTU_RESPECT_MLOCK	= 0x100,/* leave VM_LOCKED vmas mapped instead
+					 * of installing a migration entry
+					 */
 };
 
 #ifdef CONFIG_MMU
diff --git a/mm/compaction.c b/mm/compaction.c
index f08765ade014..5d256930e389 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1116,7 +1116,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		is_unevictable = folio_test_unevictable(folio);
 
 		/* Compaction might skip unevictable pages but CMA takes them */
-		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
+		if (!(mode & ISOLATE_UNEVICTABLE) &&
+		    (is_unevictable || folio_test_mlocked(folio)))
 			goto isolate_fail_put;
 
 		/*
@@ -1898,6 +1899,11 @@ typedef enum {
  * compactable pages.
  */
 static int sysctl_compact_unevictable_allowed __read_mostly = CONFIG_COMPACT_UNEVICTABLE_DEFAULT;
+
+bool compaction_allow_unevictable(void)
+{
+	return sysctl_compact_unevictable_allowed;
+}
 /*
  * Tunable for proactive compaction. It determines how
  * aggressively the kernel should compact memory in the
diff --git a/mm/migrate.c b/mm/migrate.c
index a786549551e3..3a15eb13e82b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1202,7 +1202,7 @@ static void migrate_folio_done(struct folio *src,
 static int migrate_folio_unmap(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		struct list_head *ret)
+		struct list_head *ret, enum migrate_reason reason)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1210,6 +1210,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	struct anon_vma *anon_vma = NULL;
 	bool locked = false;
 	bool dst_locked = false;
+	enum ttu_flags ttu = 0;
 
 	dst = get_new_folio(src, private);
 	if (!dst)
@@ -1249,9 +1250,15 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		folio_lock(src);
 	}
 	locked = true;
-	if (folio_test_mlocked(src))
+	if (folio_test_mlocked(src)) {
 		old_folio_state |= FOLIO_WAS_MLOCKED;
 
+		if (reason == MR_COMPACTION && !compaction_allow_unevictable()) {
+			rc = -EBUSY;
+			goto out;
+		}
+	}
+
 	if (folio_test_writeback(src)) {
 		/*
 		 * Only in the case of a full synchronous migration is it
@@ -1324,7 +1331,14 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
-		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
+
+		if (mode == MIGRATE_ASYNC)
+			ttu |= TTU_BATCH_FLUSH;
+
+		if (reason == MR_COMPACTION && !compaction_allow_unevictable())
+			ttu |= TTU_RESPECT_MLOCK;
+
+		try_to_migrate(src, ttu);
 		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
@@ -1905,7 +1919,8 @@ static int migrate_pages_batch(struct list_head *from,
 			}
 
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ret_folios);
+					private, folio, &dst, mode, ret_folios,
+					reason);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,
diff --git a/mm/rmap.c b/mm/rmap.c
index 0fb7a1b82cf3..3cb7f6337d38 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2420,6 +2420,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	unsigned long pfn;
 	unsigned long hsz = 0;
 
+	if ((flags & TTU_RESPECT_MLOCK) && (vma->vm_flags & VM_LOCKED))
+		return false;
+
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
@@ -2741,11 +2744,14 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 	};
 
 	/*
-	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
-	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
+	 * Migration normally ignores mlock, but TTU_RESPECT_MLOCK asks it to
+	 * leave folios mapped into VM_LOCKED vmas alone.  Only TTU_RMAP_LOCKED,
+	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, TTU_BATCH_FLUSH and TTU_RESPECT_MLOCK
+	 * are supported.
 	 */
 	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
-					TTU_SYNC | TTU_BATCH_FLUSH)))
+					TTU_SYNC | TTU_BATCH_FLUSH |
+					TTU_RESPECT_MLOCK)))
 		return;
 
 	if (folio_is_zone_device(folio) &&
-- 
2.43.0


