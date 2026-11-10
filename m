Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FEA60A3811
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IvAGxa4C
Received: by kanga.kvack.org (Postfix)
	id 9043D6B05B2; Tue, 10 Nov 2026 10:14:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886736B05B4; Tue, 10 Nov 2026 10:14:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700456B05B9; Tue, 10 Nov 2026 10:14:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3992C6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:14:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B75D81A0941
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:14:16 +0000 (UTC)
X-FDA: 85419555312.29.A5991CC
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB73C4000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:14:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IvAGxa4C;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323654;
	b=sxVvSN2vmJFAkVTJtWDxyimJzQO2909QNXY4PmEmk4XDxGeKwqzPm4F+pp7ZFZvr6OvTF4
	h7RY/zVWWQPdN/lvafpyziO4nz7kOFDA4QFPVoMsAn3QuK7sSg/Ke+Yj27taxQ3GTw6Ovo
	opBRBaN5eD083yGB+AnC/dObKM2pn5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13KTkyVNEIQ5V42TdPpP7NWq5YI0e8VPsfUukosD8Ao=;
	b=DJsoIFejL+Y4vB1duIZ613EWZSM2ibnqLBRiwkZGHndtcpyqrohKHJnFKsMqiqIY/QR4jR
	Q15EOsCaj9Bq5t5AUsutsmOxEkV6sCixANcPmpf7pmPsaWQxDMZCktbohe3t9Fd3VI9xwo
	nPfatc3d1vzwmSmV7Tvm+VMChVmWolo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IvAGxa4C;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b0d63f60bcso28431487b3.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323654; x=1794928454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=13KTkyVNEIQ5V42TdPpP7NWq5YI0e8VPsfUukosD8Ao=;
        b=IvAGxa4CDaxjqVKqz+0ah6V1DZ4NJ/N+3G06uu73rd3VUaGhFgIiLf+wku0bVwTN3M
         E1qkVVBmFk4w6Hx/Zfx56QWdkUeIJMtlNwzVdX+gWr+GE/MeAizWIItL8+DlUkP284Kd
         O1yVRaIPmZe+VU6DDWvMhpe6LzsEzMuQgkLS1Hilkm0/l7Li6PIkQss5WFXpIpjo4zry
         lapt8D6J9vXKL8tIBiOHStSA3KT/SqU701y/sa1Pciu1auLhjI/oNl3ui22Qw6mjlaKg
         ucIGFafA8OA4ehtiXgbrJNwcHvcNJOguFUDPvIL6LYSmA7bTM2O1Ok4nQju/7NQXUcTh
         U0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323654; x=1794928454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=13KTkyVNEIQ5V42TdPpP7NWq5YI0e8VPsfUukosD8Ao=;
        b=BZFmqnP6WJL93tmr8BLRpVm30q9yZmRmQZ7Z2O2VMTLTSshzzU0OwaT+8H3CyZg7CM
         54iOvlLTgyYfAx1277YoWYUUhI/NcjWt4td1gre4Mbjx30XrfYbu82NV7iIAJkc1mp4h
         gm1H+xXX+9NM5umen0X/WvtuNpBRRGTBsbp8C+AC1m/0dFFNtVJwh5IgRlx8jC+Akv/Z
         QvZaL069THYZ7TEzsEpDcPvq3RJY/4fuj1uMkCC1gNhaKUbzDBmPB1j3k701bx6tURlc
         0I7VBKAZ+YHI5baD/UvdluP5kRaNQ2Yg+uALvnz/Set8lerAj8UusJ5/65zmD1kT+QHm
         bj/Q==
X-Gm-Message-State: APuU4Z9acwCvyfPJV3llfu0tbYFMP73aGkHTacbcoGy5a8CWUNB9BweM
	hO9QGmi9wtcgBtNdrfA0GXghuzYkSUHMe115CXzHonGz6D9ZD+MtqaTYvk4EP3C0
X-Gm-Gg: AYBFou0/P2/UmpDlNTeuB+xJXUQXg2eAlIdlGVg+ZuNcvtbCu5j1niXEMRV2f9HZn3H
	2QWVk94uLRGJCq+5l5q6bnxm/B4dCAJ+URcmfe9Y1y+wxCDMhmSTN3/0hIj1cidoJlJgODgKOmB
	1QnS+zAG0IUUStf1nXLv6fDP+yiCe2xAHtyYuzOBXq25I4AWRGaaIImywERFrUvVnZ8/bwGR9cA
	wJTNa57IIlTOvyn2kpWCpn2NzIVYhRwsxfdu5IVjC5dnj28MALcYit5bsqSXrftT2gJmfdt0uyp
	Wdc+kXbG9FaOPSaoSp280j1cxLT0OsdWFSgnfbWG78r2gHtBVFNTyIwQm3RoontlGYEpbltpqUX
	hvHZZ2spssIDDQr7x9yCfo06Zy5FX+45MoYNc4ryybaULlLrwtSLmRkMsw3V9DUqvpVI/c3n0UL
	gDXwoD3pQ5JKh3GvVZEJJxErkecYzfGjRYHBkHEniSZH+7zwmEeJxgwsqMQGBzcUGa+zOkLYwQR
	+GpnryadQNColcGkD1DnL0CcGq+YLl36J4QzKNRs7E8e/wXYpWe0510MZzc/NAqbTta0zjGBfYx
	AJBwpnHimOKIneaAzcFP86XNdXtJFFdHOe0hLnc9Ez8Uu3ab3BUvNsFu7BDAVJlnIIsUzJdqKL6
	bEqmrOlFMA778X99ykg/Um0TZhI6k89ytGQ6Y7w==
X-Received: by 2002:a05:690c:399:b0:8b0:dd35:7b9b with SMTP id 00721157ae682-8b392b8dd13mr18540417b3.67.1794323653650;
        Tue, 10 Nov 2026 07:14:13 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3934542bdsm21415477b3.38.2026.11.10.07.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:14:12 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	sashiko-bot@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] mm/swap: publish cluster tables after reacquiring allocator locks
Date: Tue, 10 Nov 2026 07:14:06 -0800
Message-ID: <20261110151407.789960-3-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110151407.789960-1-nphamcs@gmail.com>
References: <20261110151407.789960-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB73C4000C
X-Rspamd-Server: rspam12
X-Stat-Signature: kd5ys48daokfoixn4yixb6iimtkjhwk4
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794323654-342029
X-HE-Meta: U2FsdGVkX18pohq1gSjeYo2zy8Nd9SYJUZKcdtcknW1s8BHOvtD72kMZqpvVA13MntIJkWyorqDbZZP0LlS/acVdD5OxZMjWulx2f16PIb+RKXfllCh1/pQFBjOs4gYYxOYdAchExeNPJXZAxAgTtpDnNakrafFig8POWs4ecqZ1dRNy4gdggpr4Ukk4BeId4/Zn0jJQjorv6WEpkFybnpVf11yvXvGeztIIEvAACKOx0akizPGoRjs844OdD+x28Iq0xb5kOViMqeKY7GQ9MNO74LKkAlIJUX+tD28IaZS72LX23uG8T4P/wCQa/BpgFx5r1ejkcegAEmXXHShLjXTlrx1UJfQJBpYIaEEWMY9kuzM1D4PdNtaynJhLM+nMFtFF6rWdFItSiliHQXDtzs/IK14DH84CGRn/2kwvJ29x/LCQLrjhdi9/K+eGcZ2QXNbj4C7D/E0H2NKPqOEspuhuVlPgo//TL6Sh2vfROy+RUog+UMwvaENe5EKAVDa0BiMpoCKC0+H1fHOKCFiyLUyXY/6Mt6hG/92ez8uda2g2oEeBXpwFH4ZsS7TmcQLtgSlHnaG/HRH86MxjbiGQRjPbK788k3ToCMWAZzSKt3/CE0BffDHG5SQyB1TTU/fN64T3odo1dzilaOlS6li1AHxh54uWG6C7loOfZ31OgeuOUoMapZ7mEJ2xYGr8VVwgG1T38YbRE5YdfAAKQrMEA9Nrp9ilxG3WWZDi+SigRqyiyYsYe/X/DwFZP2GMTGOT73JcGWqbCbtkA1tUFOj/0WssyBM228GREgAVA9NxIsOeQkR7tCklbXDXoFFfSAfGeAsP8jsJIqc0GxMQFnTueuXfol/ZG1TYLu1M3iDbRlVh0AkLN14PDKk5q3jpw2VHe0BGkeyJyA974QVNDVOpOkAQrAUv7HB2pkymTor/5LJD0pqBIv5QDJZE+qwB8OVNDx2rRRSXu8XcBE38zhi
 B2Ewy3YQ
 6X0NymTX9lJdu/XRZXWlN9uGDdKsAPV2nrDU2rf3iSO7ypO7hCZLUR2tH5OPH6vRpByt5VV6ZJZWHeJwu9zfyfgNyu3PJjckuHjL2mxSidMe+vtwc1ItzHaIsLeY2T5pyipeF10kVlpVNXVxEab7r0ik5HRlaMoSQybDCsJcTFuFxZhlDwVSgy8vObh3W9U27WKmeCrLzjOcDyaS7siIwdnQa/59/rSauzBdY53kwf5Z7s+WKbNxfl0eLFMwzYaGXzAgn8KydmlUH3VCDUpg2Sf7+HEiY9yj0ZmJVMrsDa97qjr4qYOy/mVbn96V5ZUsGzQlcaS4X3Jb1HQrEbbv2rjQDH6XwgkvEl8l0yl1WXChSux3pdvKKxSVASycVsJMahbKNZmkltb+GuDAEdT4RJlul2FHfnMQD/2VpU0si7lymghxOrQ7q9rQ8MRzI6D26EledPRmmyg8qwJDfBnpBPVSwNBwcgYs606D7x5Ghj0Jl8+U7dLB2y47S+m3Po02BIsHoj//iC/beJTYvzPp3Bllk0YEBdeP5AYk3OqN8mKhSvcg3RJ8RGJ0GZ7Ww3edJzSiduq8j2MRCCNXDx8rTVHFNSlasJFnyQ7bNqh1Z4uxZFZ8=
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
    alloc_swap_scan_list()
      isolate_lock_cluster()
        swap_cluster_populate()
          drop local/global/ci locks
          swap_cluster_alloc_table()
            rcu_assign_pointer(ci->table, table)
                                   folio_alloc_swap()
                                     swap_alloc_fast()
                                       alloc_swap_scan_cluster()
                                         __swap_cluster_alloc_entries()
                                     mem_cgroup_try_charge_swap()
                                       return -ENOMEM
                                     swap_cache_del_folio()
                                       __swap_cache_del_folio()
                                         __swap_cache_do_del_folio()
                                           __swap_cluster_free_entries()
                                             free_cluster()
                                               __free_cluster()
                                                 swap_cluster_free_table()
          reacquire local/global/ci locks
          return ci
      alloc_swap_scan_cluster()
        cluster_scan_range()
          __swap_table_get()  /* NULL table */

Keep the count table, cgroup table and zero bitmap private until
swap_cluster_alloc_table() restores all allocator locks. Install them
under the cluster lock and retain it through the scan. Initial bad-slot
setup takes only the cluster lock because the device is unpublished.

The allocator releases its locks before the sleeping allocation. A
reclaimer that dropped ci->lock earlier can then resume and put the
cluster back on the free list. Abandon installation if the list state
changes or a table appears, freeing only private allocations. Restore
locks on allocation failure too, so the caller can return a still-isolated
cluster to its free list.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/
Suggested-by: Kairui Song <ryncsn@gmail.com>
Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 106 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 74 insertions(+), 32 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 038d2efe26ad..32639f65f13c 100644
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
+	/* A stale reclaimer may have returned the cluster to the free list. */
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
-- 
2.53.0-Meta


