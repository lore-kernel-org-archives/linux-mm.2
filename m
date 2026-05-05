Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2183CD343F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CB56B00B6; Tue,  5 May 2026 11:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963DB6B00B7; Tue,  5 May 2026 11:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AF46B00B8; Tue,  5 May 2026 11:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 726CE6B00B6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31FB8140463
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:36 +0000 (UTC)
X-FDA: 84733775952.28.5271813
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5626E40011
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YSg0kVwP;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spNG7IJraDg4T5BsvCQ+9NVFqbAOm2jy1KvenC+2iQ4=;
	b=sZ0IUKGspiqr1gDw0vxWt2R/QiYi+wbsUms/dwC6lPEAOsd8t1U8qyrTEvs943gFloXaqI
	U1JUOVyYqu9JziDfds/yKu6wCs8oZa300Wu1pTyiJm+03Iixgea3hG4i9/dn3vuy1MZCzc
	NO279fOtlWhFBZ21LUqhT1gdEwx19QA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YSg0kVwP;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995574; a=rsa-sha256;
	cv=none;
	b=ojM23dOIv/M1y6ntHa/Egg/3meO0SsuWuOnPVckGTkOeVG8+ZJzsdXdQ4slJH8YEQxdkuf
	eKkYmUgQBOOctewEnJYuwKCLtrMQrnvh9eDFqvRiaUxVcwY2KcQSAoV5Sy6dN72IPb+p/e
	5x+MGNbWcm1aSM2blbMdGHQx/3dIbFw=
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-694891f8f75so2923235eaf.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995573; x=1778600373; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=spNG7IJraDg4T5BsvCQ+9NVFqbAOm2jy1KvenC+2iQ4=;
        b=YSg0kVwPQIbCxh+4ShgMGY4IjK47YPy2QDZmxQfFT8L2DHsLz595X/oFS/obgat0mX
         wAVHSpPqx2vbmOBZoo4lQlS47o7tjHgF6etYr7aGhu6t6qXIfoYr3VGICXRfTxzOsvL2
         /yasQSa0JKz3N2Fd1AGQHVUEAd2pnIyPlxgHMH35GSmXcMYQ5ccUw81PHGcvTr3fy1y/
         yQNdx6G/iAjlpjpr+v8BqtDSVK4ChNZGIvTOYYe9UQAXgI9ppeNyh5JdqeV93oZlAg1h
         xdFVxB4FAPWakiAGqdCosjMxDDpW2LvKtze4EPsiiYVioOg1n2LVvDpUxD32ql0WMabD
         dR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995573; x=1778600373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=spNG7IJraDg4T5BsvCQ+9NVFqbAOm2jy1KvenC+2iQ4=;
        b=SX7rgH4Yuw9cCYz7Daqho717SoL/U74zrV88ScIPT60ECfHxlVlxP3E8CbBk7mHrP7
         At557DHnrdWiCImXKbciUmOtoeB+dbtQDmh0rM3qUhAfjrSf28n1nGhi3tR6QYn8Q5ck
         z8vBvnEz7iO9UC0VkLWjPciS+B4rO+Iw2Rf2+8gZF33dO50jrhAye02m33qCHyVqRBpr
         W8T4M7cnOKKG790tuXJsRqbqvnfRfk2sv0mRohRO/rfOoIhAnja0a05xulrQFJOW8oV+
         0QNpZz7fgrTQ4o6xC29gOYHn2z6Swkx/bnZvPLg6YAOaQDBhzzAXtQg87KwJXbZW7Sfh
         3xzg==
X-Forwarded-Encrypted: i=1; AFNElJ/CzxUd+f7P/TaPbieken4IBemvAn8JzvIlZKrkjA3MAsy3LRWzDc8+khCQJ2GO6Lv9m5dKT21Smg==@kvack.org
X-Gm-Message-State: AOJu0Yze5gOeaXUSQMRM8g6mVsoPBbQGcZ//oMz4nvthGSaQKl/HvPA6
	NGV4Sq0pEuPIKLo13lkLdn8XVowA1hZr7MOq2u7ab6Ozoo4U08u1MQEZ
X-Gm-Gg: AeBDietFGtbRBXOutG/1ezdyKvhS1UZpugEPe0FZT0IflQGs89yR4OOgklk1a+OsTvC
	RdtARpi1gBQovEEP8ooveefKBTmCI7L87RtKsk8305o6k9KmyDLdMwh96vWvff1Es7N2Gz3NjBn
	22Q+Ibk51I5Cg9cDeZwUd87iePGvtRQWymSSN4PLrb4+x0OTTYlgivu/Utdlsy//rxUI6bv+ERk
	nStGKMdjQPt1y0EHMac85/ld5uvEcFp9W69hUaIbmwcPI4cc5n7sykaa0A8G7BCBqoo0EXOnYtx
	UoSQIa/3IO0+3mz9XSLnJ6MrtOIZ6tieh9bxorHEyhVqFYkxiNPVpu7dCVTnup3yCowroGta4kx
	FZFwv9FAHnFUdm4yInF5tQCFAapQ9Br0i/uR5LKJLT0aC8/91fro2nSj1w4HsoCC6DK0iKXdlF+
	ErfW3MpiKVyDxKGJEOKw+1w0/Va+b05YNTdkR13nJ57TJuemjSVSQMPiYSG6wqfl5mSrY=
X-Received: by 2002:a05:6820:3109:b0:694:8ad6:245f with SMTP id 006d021491bc7-69697dd52eemr7034578eaf.43.1777995573227;
        Tue, 05 May 2026 08:39:33 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43454d324a4sm13945195fac.14.2026.05.05.08.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:32 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 16/22] swap: do not unnecessarily pin readahead swap entries
Date: Tue,  5 May 2026 08:38:45 -0700
Message-ID: <20260505153854.1612033-17-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5626E40011
X-Stat-Signature: ntpj6qygxos4q3k8shznigxmo1futq7q
X-HE-Tag: 1777995574-409975
X-HE-Meta: U2FsdGVkX19/BrHiGdHjY0aDIu5vvzvUg2PHz4Ralc3VB7LonzkeUrY4A1reLcnV5riCuCgTB3IHzYDa9KxwwynE8TKMgDUZ1GLw6MyiJmYshvkC91aUv7EkZvzCVzE9bVoedCcblBCQCD1vNL0+jqxT21qiHX+BMviJlEQchI7+b0xNgjra7+3kGjMq+tKeojFryQV6mEAaORD5wZnUocV2SKHpfjaeXHqtpMgyLiLWrI4CbGsQVvjBG+WBFOf6m+skRNsLD4xap1iELnQ4q0wcVa/7ldLfMmlM9yQKrE4nSS/mscWxanfokDQkXi7mmc45xvU7z3ux7I3AtN2P3yg4XQu/PgA8zzjJb+VWoybdKUpaGthOY3zskdsW0wh2wqSuucMjXba9v/XdFCZkfq5snnmGqLtGb3ysixl+buBq6+UT28JHPvLl/0YV063gIrqwV0kQVSUfaX6dNdT8hrkhriMHoGASfTpmDhPZpBByjfQwPm68owID1+3a1vC3PZfZZS/1NWSLx9E/ve9tS19JD3skC52N32nhMrKgnx6vGOmHtJuXMHkySL22YJ6AXmOR7Yv4o9ZtgJ4Oqg3iI4Y6d0sLou6g4nZcL2z/Ug/H28SN2yGYs1PKLRmQUxGpTN6foeukSULcKS/B91VcTdbK7xgjAHH9E1AqgTfFLZmDmpVeAtwzCZq+z6Vo7P22/e9fL6xMdT1D8HVFTfYvpR20/xJs9RpmkeIvCaHZKwtqgVIXcDLSExT0Vlyitq4ypTlN/e4s+5EbEtWBMOpSVwrZMAy5krKYgymqjpGKMG0xVurQzGmdvx0bZYtLRrqgoS8nTTJd76W00fQjth59Vt5vAo8Nvkrq7qBYC/5zkgeyBvR9+kQpXEg/KJT0vzLYohD07z3R5VtuE3tqGzOxWQGivkHX6vbforOuZHDOfYweiLh1VYtokdieaKBNXzJzgK8MTQ4T9h57WLgqS4n
 XagcEJHj
 R56o3oF/bn7C1qyr63yITBAoiO21zTg6QrO8IYyyVUlrIz9orcL4ROOWlxX10g9c/qw/yCUM+Y6Ym7e7lfEe2bxUgrujpNlXkYAxgJ7wV+mh0Y/sB2g0IZLWcM/tq/Df+OvbZRFD31l+B8xjkUP87DS1kWcOIHlGqjBwF0TOHqBmn07cywB67BM65EjU1r1OfaPCkXOjVmk98fn+GD5GXtu3QvWWbqAEwOidnBlkgn9fTiEWWh2e9gz9eYh+VJ/CpK3IlA6Aq7k50TmPGl7eweYHOWV+CiYTmu1wHxFjGZttIJPl+fGJFxZ/peQICpt/f3o31dH3IxBef5rxOuFW4gOtPwScqEbpmL+1AeXg75Z3Z4J28hVglznqDiZfC2oDkTtP1iM5Qp6OuDVRiYrn5ZABC8zf+vQeF2HFyZ4aEiwit9ildQTIRUlaq8zrAaqad08jk+Yaut+FSplySNVZl5/J1wI4gjjUNrc62mupGKAF9WD2k3DlI8Bnh+rhjuGKIVBQzqj5h7WiQ99eiJbO2dHqyOind8d92SheW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we perform swap readahead, the target entry is already pinned by
the caller. No need to pin swap entries in the readahead window that
belongs in the same virtual swap cluster as the target swap entry.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap.h       |  1 +
 mm/swap_state.c | 22 +++++++++-------------
 mm/vswap.c      | 10 ++++++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d46b2f243f83..f3f2afc6751b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -156,6 +156,7 @@ void swap_cache_lock(swp_entry_t entry);
 void swap_cache_unlock(swp_entry_t entry);
 void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 			   unsigned long vswap, int nr);
+bool vswap_same_cluster(swp_entry_t entry1, swp_entry_t entry2);
 
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 7fe4d9529e4a..39daea7bed66 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -553,22 +553,18 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		pte_unmap(pte);
 		pte = NULL;
 		/*
-		 * Readahead entry may come from a device that we are not
-		 * holding a reference to, try to grab a reference, or skip.
-		 *
-		 * XXX: for now, always try to pin the swap entries in the
-		 * readahead window to avoid the annoying conversion to physical
-		 * swap slots. Once we move all swap metadata to virtual swap
-		 * layer, we can simply compare the clusters of the target
-		 * swap entry and the current swap entry, and pin the latter
-		 * swap entry's cluster if it differ from the former's.
+		 * The target entry is already pinned - if the readahead entry
+		 * belongs to the same cluster, it's already protected.
 		 */
-		swapoff_locked = tryget_swap_entry(entry, &si);
-		if (!swapoff_locked)
-			continue;
+		if (!vswap_same_cluster(entry, targ_entry)) {
+			swapoff_locked = tryget_swap_entry(entry, &si);
+			if (!swapoff_locked)
+				continue;
+		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
-		put_swap_entry(entry, si);
+		if (swapoff_locked)
+			put_swap_entry(entry, si);
 		if (!folio)
 			continue;
 		if (page_allocated) {
diff --git a/mm/vswap.c b/mm/vswap.c
index 01c336ae252c..195ba3520e54 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -1542,6 +1542,16 @@ void put_swap_entry(swp_entry_t entry, struct swap_info_struct *si)
 	rcu_read_unlock();
 }
 
+/*
+ * Check if two virtual swap entries belong to the same vswap cluster.
+ * Useful for optimizing readahead when entries in the same cluster
+ * share protection from a pinned target entry.
+ */
+bool vswap_same_cluster(swp_entry_t entry1, swp_entry_t entry2)
+{
+	return VSWAP_CLUSTER_IDX(entry1) == VSWAP_CLUSTER_IDX(entry2);
+}
+
 static int vswap_cpu_dead(unsigned int cpu)
 {
 	struct vswap_cluster *cluster;
-- 
2.52.0


