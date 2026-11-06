Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CE6606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P7cTp5xD
Received: by kanga.kvack.org (Postfix)
	id 88AED6B05B2; Fri,  6 Nov 2026 11:04:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814E16B05B3; Fri,  6 Nov 2026 11:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704186B05B5; Fri,  6 Nov 2026 11:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48F726B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:04:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2B5BA00FB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:04:43 +0000 (UTC)
X-FDA: 85405167246.06.B068C1B
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 141F780002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:04:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P7cTp5xD;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793981082;
	b=zgclnEXtYt44XWVt5qWu5BJbaUbP2QEYPLXUtC2BKdgQJRU4iCvHr1Y0m7gR0OBKsTMA7Q
	MzYxwatg5cz9VXUK7hVwOdDaySEI2CNZVAuq66KvXqLR9PSSp6SPDznJoZgFQLxV6ZXsh1
	jMDKrj57o1fp1hwoK+FRveOveboKr2w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P7cTp5xD;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793981082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbAo/XVll2SGDEss8QZao+7wapwcfSzf7Q09tuS5w64=;
	b=YadrMrvUnkqtIdXBeKu4dtYjJS2ZITi+iSNOD8IyVRVepdXaK8GcpX7H9DXbcdybE3Xoe6
	EsA0u6LlAWoRZGvR57A8NSrSl0W9I/UAJceiEk6EtSENU1LetoCIohDMMEiBSX6Tc0B9Ce
	CnYPMjT18hrEjau6EVp3KoLaBM1LjGE=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b305d38bafso6698037b3.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 08:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793981081; x=1794585881; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IbAo/XVll2SGDEss8QZao+7wapwcfSzf7Q09tuS5w64=;
        b=P7cTp5xDu8f9KvKPW4Og3PHbn6zuH5SIiuWfp/xmO+fYDOhsQUxLyos1c/4WbVRWPi
         3qC+PbmXagW2abArqmvLzXfKY5EC9g7xaVaGoOG81h20QS37islH3smyQbfia7PuzLDn
         98ESvSCIyOxcqlpVAJn5lIeZCPa7RBqCTbWPzlNPcIq1AOd8iFSHES3+fcjhm5s0D6Lq
         6tmkwkSjs8gV7caV/4RW8sBv9cAFYNTg/Lrmlma8Fk2S9rvRt7XMx2h8Ho9KFy8yEgsB
         3sAVHj/vHo5rLQqy+Ul+IgR/5E6NOdBSOZO+SsOqs5YXeeS3n1WubTDz/ecBnJEkxDZB
         oWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793981081; x=1794585881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IbAo/XVll2SGDEss8QZao+7wapwcfSzf7Q09tuS5w64=;
        b=x1css64kG9sTwl9Mhpxc3vfgzK3RDAkDEWvyv0DtujQHjPJRp+tyx7KV8UC4W9is+7
         sPWs01uQ7w3MBpi9aE5Jx8ek6Y7S9RFGNTliG1tjyinPejJi1R8qTbttIjnZXD6KF7Kl
         JzzfwF1rJKCB+Ej4OdH7u7g7Sycxs/7CgF1OAYuUeetk05z5CpLn/rrGet7S3zkvWBdk
         mBIB2cn5fQft24aemiBm7/2Z/I27twgigi7VA+Cetj5JHXn92pa4ARUKivE2jxSGxNwr
         v4ycPZx8Z0CwEbAu9TjBtg7TrEu4SyTPQ928knyeZoVdoc94HcyrqzSK+ve4MKs5qSCA
         JWVw==
X-Gm-Message-State: APuU4Z8cTELYZwbYGPao6FAjMh4p1e/1T4txL5j1S8lDO95r6PzCK1dL
	Uf4KP648q6L6AuHUGlB6hNCTy1f2YHnseElEW6QfECtijD8GvsS7cfZPvMX6EvbO
X-Gm-Gg: AYBFou3ZsDUGgVQFpIdlcKmN0dL6l4gAl8GSuY/FeTa+4AZUkBftP74/PetZYEbqw46
	UazJ6LOTNQS5KbrxsaAIpau21RTM5HRg4QpGJfZEfx2iFimd5ennro9r4cyHozCdumVloxIo3Cl
	YFin4Jp8fgVVvMj6nl7ANG0YFnm2jNos3sm+3G2OEh2jcAfSTOKts7+7N4BzE1e/jz7qFUoX70C
	cJ3LZ0QFbOLfeQ/VuMXoniMSyx+sCYUfnwen4u+gLuuCRpuU72wj8TZ1SEWItXepeWPEDNDpxDC
	9BChujI90r7i6BHlveT2KHP8CZ7F7qotNZl7BxI3qXVp6xVLS9j4qxBTpWsDxaDf1GVzeCYg6bb
	+jGa9gBdDUIiG3Qq77OeVwGxzHZOUWF2XWX8EPPvCcAuDbV5XXTR2ssOA8zPAfrUB4Bbdwv9rxI
	YWG7yHVDRgWdsn18H4eGvjhHvKljVoFPpH38PyP+AJ9LV2Ke4ygtnWGg/HWooCZBoU81uAKMBSo
	mUpSGJvul41X/sjBdGU3vvcSPf1tpUfONH3Nw39MG0OI1evG8xKzrh1TCtMp6aTJgG5cJ8MXYAw
	mbW6RpVwQChSsLr6Gld9DZcRPttSjzVdkE2LHfK1hYhU//STvTKlRsUIYFpAtHRDFIpBLzuu5LN
	hVDOHtZBd87LDCaUWLbfct2dfpuvAgviYdq3bEA==
X-Received: by 2002:a05:690c:9517:b0:8b3:3fc5:2be with SMTP id 00721157ae682-8b341947d76mr12228297b3.20.1793981080879;
        Fri, 06 Nov 2026 08:04:40 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f7fec67sm22059507b3.22.2026.11.06.08.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 08:04:39 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	brauner@kernel.org,
	chrisl@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	ljs@kernel.org,
	mhocko@kernel.org,
	nphamcs@gmail.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	weixugc@google.com,
	willy@infradead.org,
	youngjun.park@lge.com,
	yuanchu@google.com
Cc: stable@vger.kernel.org,
	ryncsn@gmail.com
Subject: [PATCH 2/2] mm/swap: publish cluster tables after reacquiring allocator locks
Date: Fri,  6 Nov 2026 08:04:32 -0800
Message-ID: <20261106160432.2552507-3-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106160432.2552507-1-nphamcs@gmail.com>
References: <20261106160432.2552507-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mdj7jqx45s1tbbhq6euaor7zjssh34jc
X-Rspamd-Queue-Id: 141F780002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793981081-655931
X-HE-Meta: U2FsdGVkX19hb4utOZXvz3rYqA9qZ0Wu9Ak/le4impT956PpPFbYAxtEWIhBe1K10L/UP8sTlGC+aV1DoREwrdEor/087tvvHQrYTPoh4ZEF6aKbyYq5dB9N9AB6nw5ElXCGlq9FPhYKVwXXkWPSdjeEquQI/mrnzkr1dFXaoR3fBvjNFp3sLrE0Sif2v+pOfYAoTywaMUpEyvR0aEnstRA/xJxryBfpfyGyxKHY/wZCHxLfF+IsWuJr0tpMqKKqr+jQMoUGbZuAYcd219SPXbwxHB5iALTFbFEqPcxvNqL7Y8QOlLhqeMM7ZgGjyYE8E8BmkP8gVzUbqpLnKGaN2uyeu3MX+Ml3GTpOvs1TYlr83V6G8j27nHtAF/04Lw+NDYAJO1Vsd/lsRb5ZnQeeIKgTwc1JcGT1isob3PcesOybE6OB0SEnyyphgK0jrETMdODKyR+9jX9eGjJqNRpD25eyB6kuelWeCGcGJDDVJ4xKo3sNsP1gqBTUcfGcRx6/w+pu2sdbCM9+EXH/TJooo1WULrJsx0SaPgpOkgNel080q5ruzduZwDeA4zXni8uCyNaZ0S0l6VI0ZeVkB//A/uC7yDJE0K3pXZmEo0rutprH48PvtP7NrlwG2nInJ05jPPeHJqgMJdqBV23JKr2SZd4jajJMH7cx72BFKTbXv3MUSIxUONa259bg4bTrqWhIR0gmRsVdJdEqr6eN4VIqLVixxKMpdV1ecY1ouVBB/p/eDuZxQeh7GgpcHrumKZz/cnd4+87U6RG+hNsWG1Z3QmZVgAzfDz4AZBFDI4X/mx8UMIZEcpwtN/Z2un3wZxN1Bq6QmKbgZYSJlKEPR0biDdbh27G0jdnj/gymoo57hIrZ8FwsRuMyhAHTHdDFA2UHt+bzdr5e1DvtQzhkwD3520yaJs6ZcwxAtjnwf+T0mAeDaR7zcx8PrbbTV7Gn93Uq+1KA4VFjiFk1DthkFPX
 dllLqall
 NYU7fz5cnu17loH0GWYEX2QHEQNMpZOBE5mpN5Ov1VxtCRV32/A/Vul8k8xqMVXc5DpTlf4Xl5SiOmhssr6PTN5e71RvYmIZLl6ARHooV2bcOg6qXVt5A5JWLJKoFZfWTI+F9sCaY86h211eKPgv0H5MKBxxsDxU03XQUCw61rPJcl9lC30T+HH72wNcc8OrRBMLvucBIKtBTGqgsT3hP2mIz7XutkzzSlku35Spj1QCMmbJKiNAkyO57EcQVSqPjNv9vhvpeJMb9jm/1yYIzGsSe0VrwyHNu6lqnjsVSld3tFid02Pml90VnuQKpnYOhQ0GPViFgP7sAnmEOnlbAJ1gQy8qkftbEJFlWfJdo98MD0uyhEYhYqL+xNFeeRdjJiRSs23wVvBMZzPFk3jU55IMIsqT3zgZB1BROTrKu1NYQ5HcWnPMhkokxRci7KHs0UIaYBCp2NwfWnJTd4X+MqeR0HJoz7uwRt0B9bF3vLEX4rLIv2UKzbwYRNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Under memory pressure, swap_cluster_populate() can publish a table
while its locks are dropped for a sleeping allocation. A cached
allocator can consume and free that table before the populating
allocator resumes, leaving the resumed scan with a NULL table.

    CPU0                           CPU1
    swap_cluster_populate()
      drop local/global/ci locks
      allocate and publish table
                                   swap_alloc_fast()
                                     consume the table
                                   charge failure cleanup
                                     free the table
      reacquire local/global/ci
      return ci
    alloc_swap_scan_cluster()
      read the missing table

Keep the count table, cgroup table and zero bitmap private until
swap_cluster_alloc_table() restores all allocator locks. Install them
under the cluster lock and retain it through the scan. Initial bad-slot
setup takes only the cluster lock because the device is unpublished.

A stale reclaimer can return the isolated cluster to allocation while
its locks are dropped. Abandon installation if the list state changes or
a table appears, freeing only private allocations. Restore locks on
allocation failure too, so the caller can return a still-isolated
cluster to its free list.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/
Co-developed-by: Kairui Song <ryncsn@gmail.com>
Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 106 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 74 insertions(+), 32 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 189f04d8838f..162a73a9e663 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -449,15 +449,23 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 	swap_cluster_free_count_table(table);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+/*
+ * Return with ci locked. An unlocked allocator also needs si's outer locks;
+ * initial bad-slot setup passes NULL because the device is not published.
+ */
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci,
+				    gfp_t gfp, bool locked)
 {
 	struct swap_table *table = NULL;
+#ifdef CONFIG_MEMCG
+	struct swap_memcg_table *memcg_table = NULL;
+#endif
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	unsigned long *zero_bitmap = NULL;
+#endif
 	struct folio *folio;
-
-	/* The cluster must be empty and not on any list during allocation. */
-	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
-	if (rcu_access_pointer(ci->table))
-		return 0;
+	int ret = -ENOMEM;
 
 	if (SWP_TABLE_USE_PAGE) {
 		folio = folio_alloc(gfp | __GFP_ZERO, 0);
@@ -467,27 +475,49 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 		table = kmem_cache_zalloc(swap_table_cachep, gfp);
 	}
 	if (!table)
-		return -ENOMEM;
+		goto lock;
 
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_disabled()) {
-		VM_WARN_ON_ONCE(ci->memcg_table);
-		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
-		if (!ci->memcg_table) {
-			swap_cluster_free_count_table(table);
-			return -ENOMEM;
-		}
+		memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
+		if (!memcg_table)
+			goto lock;
 	}
 #endif
 
 #if !SWAP_TABLE_HAS_ZEROFLAG
-	VM_WARN_ON_ONCE(ci->zero_bitmap);
-	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
-	if (!ci->zero_bitmap) {
-		swap_cluster_free_table(ci);
-		swap_cluster_free_count_table(table);
-		return -ENOMEM;
+	zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
+	if (!zero_bitmap)
+		goto lock;
+#endif
+	ret = 0;
+
+lock:
+	if (!locked) {
+		if (si) {
+			local_lock(&percpu_swap_cluster.lock);
+			if (!(si->flags & SWP_SOLIDSTATE))
+				spin_lock(&si->global_cluster_lock);
+		}
+		spin_lock(&ci->lock);
 	}
+	lockdep_assert_held(&ci->lock);
+
+	/* A stale reclaimer may have returned the cluster to allocation. */
+	if (ci->flags != CLUSTER_FLAG_NONE || cluster_table_is_alloced(ci))
+		ret = -EAGAIN;
+	if (ret)
+		goto free;
+
+	/* The cluster must be empty and not on any list during allocation. */
+	VM_WARN_ON_ONCE(!cluster_is_empty(ci));
+#ifdef CONFIG_MEMCG
+	VM_WARN_ON_ONCE(ci->memcg_table);
+	ci->memcg_table = memcg_table;
+#endif
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	VM_WARN_ON_ONCE(ci->zero_bitmap);
+	ci->zero_bitmap = zero_bitmap;
 #endif
 
 	/*
@@ -496,6 +526,17 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	 */
 	rcu_assign_pointer(ci->table, table);
 	return 0;
+
+free:
+#ifdef CONFIG_MEMCG
+	kfree(memcg_table);
+#endif
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	bitmap_free(zero_bitmap);
+#endif
+	if (table)
+		swap_cluster_free_count_table(table);
+	return ret;
 }
 
 /*
@@ -546,8 +587,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN, true))
 		return ci;
 
 	/*
@@ -560,8 +601,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					     GFP_KERNEL, false);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -571,13 +612,9 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_lock(&si->global_cluster_lock);
-	spin_lock(&ci->lock);
-
 	if (ret) {
-		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
+		if (ret != -EAGAIN)
+			move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 		spin_unlock(&ci->lock);
 		return NULL;
 	}
@@ -825,9 +862,13 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
-		return -ENOMEM;
-	spin_lock(&ci->lock);
+	if (!ci->count) {
+		ret = swap_cluster_alloc_table(NULL, ci, GFP_KERNEL, false);
+		if (ret)
+			goto out;
+	} else {
+		spin_lock(&ci->lock);
+	}
 	/* Check for duplicated bad swap slots. */
 	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
 		pr_warn("Duplicated bad slot offset %d\n", offset);
@@ -835,6 +876,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	} else {
 		ci->count++;
 	}
+out:
 	spin_unlock(&ci->lock);
 
 	WARN_ON(ci->count > SWAPFILE_CLUSTER);

