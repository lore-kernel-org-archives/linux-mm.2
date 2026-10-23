Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70964606A333
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lEppA5lV
Received: by kanga.kvack.org (Postfix)
	id 932966B0BDE; Fri, 23 Oct 2026 15:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2E66B0BE0; Fri, 23 Oct 2026 15:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8B36B0BE1; Fri, 23 Oct 2026 15:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 565456B0BDE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:54:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA4F1A76CA
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:54:48 +0000 (UTC)
X-FDA: 85354943856.02.C43189E
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20EF818000B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:54:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lEppA5lV;
	spf=pass (imf06.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zwi3GYLBUBlxRf6m2NubJmhIzNf7qgE5p10VsGudk4o=;
	b=XdL5Ty+ZK5Lk7B6Gh2lzhCQUny8g304Vn6iiMB3d3cTQ3hV/ixoXJ+wE7fv7OPcS5apDnH
	wTY064yDDVjbboi2ruUlVHWCZ2L7HY03uKG/vZmOMYEu1YpxqtueD0qWPoDVtE6QXWPb1T
	Wss+NqCb35Tyi8sU141lSV7Y+/sVdYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785287;
	b=LwmL5uK6r6Ms2K3wfwsuqyri6CFgCUBE4FiW4F6fJU/pHrbjvvd0Jr1FBKtCq2i+xns+hQ
	K9v6WrczMtki2HAGs1doP2SJUqoeFXOQNegr/ZyKv3/JXCyD9hGITLg5ujOIIFbbsml0EU
	/UlyDiIuBhFYBPjRnEhWK46da8roaW8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lEppA5lV;
	spf=pass (imf06.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-675676afc3cso1528991d50.3
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792785286; x=1793390086; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zwi3GYLBUBlxRf6m2NubJmhIzNf7qgE5p10VsGudk4o=;
        b=lEppA5lVsH3fH6T1/pvYfPz+l2gXndimr5F38DxcHbASIQRf11Nsx3tROWtZsrbWhR
         7czXWchUnLXxXHDJT7VpUuNdJVmtDaVBW8S7CYUTpmvWsWC2JCU6GoNLFifr3kezPryu
         k+N9S3Db67YZmlQfGcFQ0SamBstIrHVWJsdzrY3Uo3cUTMUuuziHMGuOvxR4XiSIF430
         4iEBBCrw9Yoam50AL9hCnA6r0jfqqS5VVOf1aTzmSqWqOdIomAQXR64Eir///TnBMOH7
         YxOPFt1FrUONOThiXMkkj1LqOqQ/HH5Tq5m/+H2qk3dSiWVMKVC0IR5kkCd6nW3NjpRe
         kcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785286; x=1793390086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zwi3GYLBUBlxRf6m2NubJmhIzNf7qgE5p10VsGudk4o=;
        b=BEXmdyONjfqXFZUGtaskOBapys3KqMx7fAszOvOV7n23pNc/8QLkLPBVgqH307ZsOx
         4dB9AE/Sn5VoDDRR1jMKVvikaE9vD6CQ8zUrMsj2wy/alw06tN4/mAivScI8Acx4HmPQ
         MkxDTGonr812epsyudUwNs1IN/W+1ZkvNaLk4Epa7mXQxByvAwXxb8fYTUneqw8obJo8
         jXDHbgSwPnsk017g72dQTSNTXVJ2Vk2XwpGDc9foPxxRNLXnTj19d+R/72CjapMQ8EVQ
         wr1E1/mEmjScBdU9C6Ddc6HEQOriam68Leg2B7ZVesSuNS0VrTd33fMw28v3WhBz/rfu
         mcog==
X-Forwarded-Encrypted: i=1; AKwUvByF5pNRpAti3nOW2RzKM3qPu+JO9N1WIUdscGKkO3EGJdWaZu53583X3AaG0vTwtC1uBWKkYeDxHg==@kvack.org
X-Gm-Message-State: AFq9FYJSOzpJg9pbTUZFjdhSEbE1M6LI2DQ+ysDU3zem/EP2Bze0sxaP
	h85w/7Q48pHjGE7AeFyFl5k0o6HyAdJkmEUed0XTwa01UkxPFaTFv3NM
X-Gm-Gg: AYBFou3jxW1CE+NFmIci53IC7i9DDtv0is/zBCFIfbbtnaLcxyocSGr2R3w0LL6OPXh
	oO6rnnFfIsKxutcEhvee16HUBkDOt5AUONY2dSFjk3R/87LNlCHKXXXOuYq5DxJd+VAXb6qgAfY
	acglywysQeV4O97StxVyLHOog+AkmL2tqjv8eXLSkicjf0UtxviKQnK9G7vdeDTkeJuylCKXZ0d
	fdfl8diQiYmZCmQ4AmJbDaZywmuPawIEI+8bo1BjGGoa2XuutoLIjmVQIFovIlbg43lKMz5n52X
	/HoXnTjF2eunqx008N/L5Rndh8/eIfiaOBwWomHXUS6p06nw0lEzH1Su7/PDNqk2i+9ilhTwWYF
	8FcX9ORcsE6Rs9Fjbk7BxZAAlfb451Ftr7bY9SyF1/s0jS6qhCHIge5b4pdvyVd7xpDx3WOirsG
	cl+ZJJkumOuvM0wZSptcFVwn49gtMedhcVKwmreApRbD9ChdjNbsbnTSEE9XvnSltzZWmqahhjU
	ill8jALKqPse6g7JLsrxPgrxS/IQpY+hFA+9kWqXy2yDpseVD5AXGf2d1ID/VfjCSzOexNgrWZs
	3Ut/K2FLux6vRW9TTrbnkoG74kYLwN/r
X-Received: by 2002:a05:690e:439a:b0:672:a52c:daf3 with SMTP id 956f58d0204a3-67a454d11d4mr119886d50.102.1792785286111;
        Fri, 23 Oct 2026 12:54:46 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a4622e78esm11114d50.12.2026.10.23.12.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:54:45 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/2] memcg: reduce cacheline contention between lruvec stat updates and LRU lists
Date: Fri, 23 Oct 2026 12:54:16 -0700
Message-ID: <20261023195417.1391216-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261023195417.1391216-1-joannelkoong@gmail.com>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20EF818000B
X-Stat-Signature: iqq9ozsey3t8oei3t5xh5qnyy67g7ymg
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792785286-344153
X-HE-Meta: U2FsdGVkX1+w/sVgokPYxHH7V/aDGsAGXXqY2OmQ4RlCo1/U2E+8CgseL36a0JXEvxbYGri3HCfZG5sfYnvUgUSXG/e1p9quz3kq1zBAd3t5WBEi6mnRvZB3DeTZT9FGSVXH8umpOWjmkdSe/8xOjwzr94XdXKy+GeBXXkYuiJYzF5i4wEZo2uV+CY9nSbFBsFXAvCa9R/9ihRDZFDeffT9OWP9d/k+pMnz/4yr7EUOe1/jcafJHDdDOQMRi+RrYjTav9ySmLuaEod+teradP7RuROIQz3AH4r8VnrLeN4NZwy9yPOlVh4mnCPhYFFB7YOw4oxHnZKh3zGsTJyHtNpBOPPCogwXVta0K5vYKBM1SwMof0MmRB3HvJf7XrsKgpP24Q2/kLzu7qv9ZAoBCS9LGO6xUgpfmAvS2q78eXivXKKDP0bWpVmxXO0h3/NosyFs82RLrrlfzp+Ag4jTn6/aYtaCRll5PYqsO8HBls+jfjee3zhy0L0BcagJUK0b/uEG/MLeY48nNQfaMoB151galEZSlRTq+OLiCDH7Bl5tkoZZnGTI3FDVPTcsOVRB2SFTM97+ZovAGv5Y8mBkn/WF3AlLWcWP5Tt2gDPm99xiJ3BABKScnnLoc8xw8lq/bO5EhGzCI6YZA+XIjmMMAPeBGwE4VxubnoPqFEww6DZJ2y8KPTrqFZE4osmt9ObfdXnhf0od53yZZ5+YdrP3hbMeSpSgc1EvcLMqLqYVC8WvCN0t1BnIMjI/UuSRjwVOtgxhR763/an1i6+y+lx3tQwPqkoGwnNl4sC878DjdWLSlCLjev2LqfalX6JYNWUQ28Ytdi4u5PuXylna43T0MH5sbSYBm6g6qK63SoMu4oXxrCZbPCE/ueK3mMcU4Sub1lx3NN5drrtZrxxwl2e9LeCryXeJ2Xq4p7NpCYYf6j6V6MHWjOLAhuTl50VsmQ47nZsIv0YdK6I+8VGWdbWN
 ZaX9ah5S
 WH5M5utwvMA5uwnx2kgjI7+HTDEvZSFAGRjjlxxAh1NlDcKPLxM2h2KmkXbl97blWQnXbG/uBu3ABpqTcxoYTgFE4ETEACyiV/Tq1Nc/jylpYYbVn/z2cIjcDuBYclM27xSte2R0l5cwhQczRMYmBzsDdFfvRplidBaPTaltaQ24hxS05yDAVRxGO1wJCAY0ZMfsFNo9bRRz7nnH34+HD1LAUFpw/FViJBN6LzokhARrAbO2X9zhVd4AjS1UxFK8FldyWJ4I/mhqHb/r0tb8wGCKKugIf58dc5fhX3/m815Zjp4VgYxhHrYu2NZ/vQTEQCLbRtCIDfxzb6YjsKm+s2MmZ+obyw0dPn6978a/+uRGvW6LAB2JFVEmphHTq9kepuGxuOwQBDKgdp62QzKjGXzGRBgCCOo0HuzWjTnjOsrG6JpoGifUpFbauB8hiYQ91pSAPy+YmDSMkdYojrINlDgo3rDaPe7E+Q1PH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every memcg lruvec (per-node) stat update reads the memcg and
lruvec_stats_percpu pointers in the first 64 bytes of struct
mem_cgroup_per_node. These updates are extremely frequent (eg these
updates happen several times for every page that's faulted in, freed,
dirtied, or written back).

The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
on a different cacheline from the lruvec, but Intel CPUs do spatial
prefetching [1] and fetch cachelines in 128-byte aligned pairs.
Depending on where struct mem_cgroup_per_node lands in its slab, that
cacheline can be paired with the cacheline holding the LRU list heads.

When this happens, every stat update also pulls in a copy of the LRU
list heads cacheline, which is written to constantly by other CPUs under
the lru_lock. The stat update has to fetch it from another CPU, which is
unnecessary overhead since the stat update doesn't use the LRU list
heads at all. But even worse, the lru_lock holder then has to invalidate
those copies and wait for the acknowledgements to come back before it
can do its next write, which makes the lru_lock critical section longer
for everyone waiting on the lock.

This was found when analyzing the output of perf c2c for a benchmark
where many threads fault in pages in one memcg. It showed the first 64
bytes of mem_cgroup_per_node as the most contended cacheline (over a
third of all HITMs and 5x more than the lru_lock cacheline) even though
there are no writes to it. A quick experiment adding extra padding so
that the cacheline no longer shared a pairing with the LRU list heads
showed that this removed most of the contention, which confirmed the
cause.

Fix this by moving the memcg_pn_cold group, which is only touched when
the memcg is reparented or freed, right after memcg_pn_read_mostly, so
that the read-mostly cacheline is paired with the cold cacheline
instead of the LRU list heads.

Results from a multi-threaded fault/free benchmark in a single memcg,
run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
pinned to CPUs showed average pages faulted in (and freed) per second
across all threads, over 7 freshly created memcgs per run:

                     before    after
  shmem, 20 threads  4.74M     5.59M   (+18%)
  shmem, 80 threads  7.94M     8.66M   (+9%)
  anon,  20 threads  3.04M     3.08M   (+1%)

[1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
(bottom of page 62/800)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/memcontrol.h | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..6139195b7fa4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,6 +95,24 @@ struct mem_cgroup_per_node {
 
 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
+	/*
+	 * Touched only when the memcg is reparented or freed. Placed right
+	 * after memcg_pn_read_mostly because CPUs with spatial prefetching
+	 * (eg most Intel CPUs) fetch cachelines in 128-byte aligned pairs.
+	 * This keeps the read-mostly line, which every lruvec stat update
+	 * reads, from being paired with the LRU list heads, which are written
+	 * constantly under lru_lock.
+	 */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
+	/*
+	 * orig_objcg preserves a pointer (and a reference) to the original
+	 * objcg until the end of life of memcg.
+	 */
+	struct obj_cgroup	*orig_objcg;
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
+	__cacheline_group_end_aligned(memcg_pn_cold);
+
 	/*
 	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
 	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
@@ -114,17 +132,6 @@ struct mem_cgroup_per_node {
 	atomic_t		slab_unreclaimable;
 #endif
 	__cacheline_group_end_aligned(memcg_pn_write_hot);
-
-	/* Touched only when the memcg is reparented or freed. */
-	__cacheline_group_begin_aligned(memcg_pn_cold);
-	/*
-	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of life of memcg.
-	 */
-	struct obj_cgroup	*orig_objcg;
-	/* list of inherited objcgs, protected by objcg_lock */
-	struct list_head objcg_list;
-	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
-- 
2.52.0


