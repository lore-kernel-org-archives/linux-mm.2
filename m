Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED891099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFCB6B0168; Fri, 20 Mar 2026 15:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323006B0169; Fri, 20 Mar 2026 15:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9716B016B; Fri, 20 Mar 2026 15:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2C7E6B0168
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:28:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCDDE5839E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:04 +0000 (UTC)
X-FDA: 84567426888.08.858326F
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCBEC40006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Su7Xzsbg;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRgUJ4HYnVe4CBYlwtFXukX7KCRZK3pYV2dpIHw1BJw=;
	b=F9d841qOt507nRgdxFMwvbEIBLwWlRUuNKTRPfkezt0UiN178LZKiUFVZAXbqKJ7JUf98m
	aINImZoja2QHfdugPG9hlteCA1iPOfQ+aKfxDbStUUla6dYU/WoLaoeVW7TqMYNtD6XfkC
	1baZQZbIdsAuhEhjCUXoUVjAXXukoxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034882; a=rsa-sha256;
	cv=none;
	b=kq6A2LJndOFZMPvZ+igARZB3RdSyqeKMrqGq8B6CRpfAUItrSZEIbCHvUZipVWMEmctnBb
	SxT9YgCdlGIFHro42sfJxjMHeGY8kNTJlRZ0MoUexGHtnONRo/2dzHP5fTCe5ky01dbjA5
	I9o9Dg3SAHc/sPzKe8f3cXrkOXKDdiE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Su7Xzsbg;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-466ec4c6852so1298726b6e.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034882; x=1774639682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRgUJ4HYnVe4CBYlwtFXukX7KCRZK3pYV2dpIHw1BJw=;
        b=Su7XzsbgEBtAdeOYQPCo/zOZjA2jqQR3/OBMXOQnT2kgYBAaW+Z3cpFPowR31vgvGf
         /oM4ZlN9WFCoCQs6XqaNpCxhszsCmW9695f4XeBXNjRyYWN1zNg6Vpqa+gA0UsCJ3x3P
         Wmqx3W0egyDHZW64AjExgo5YuEVahudSs/Lritjq7OPYs+jX6Y3uWOMIb1HnKvWCMBBO
         7wRaGWwDFqRAINKXz4C3P9XIsXGgrIIJSlCjGohqgOmgJTscje26r+PDuwnoG7M3s3KX
         jkAJvlPnyS0xhnLdH/2q2PvU9ANXaoq+WdpQ9pZfbI+r6nZlOI2ESQboetSNOVVW2vmR
         zJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034882; x=1774639682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kRgUJ4HYnVe4CBYlwtFXukX7KCRZK3pYV2dpIHw1BJw=;
        b=Q0f6JlMBqMVRmWRuIUlrc2r16wEF1wh6r53a74eS2Db5Lg5dwh83MV582ZQA34FoLN
         3zFPebDuS9LEcLYaiPItOqtVVfoGF65+HLspkOoTBlhN69Ufaz3u03JUbH0M0rW9q4I6
         31Eef8LoDp/slJU0e9Z36mphfHEZSnwu00ytxjBwxropS95wLU1HSobupI33wxCCBbFn
         Z+yJDamjh9uczPoo+FbjnkIEpyrNDuhI0dhbrjzeeDPQj2Oo7jFia/FN7FtbTnyqwdnH
         +4t07mtQHZ17u3L4SsTZ1pbVnwSljrnJoV6klDhg+bkfY0sQgi3nh6L9fGI0NZ/Kmsw9
         J3gA==
X-Forwarded-Encrypted: i=1; AJvYcCXRpm9l3EySO/K3JQNrP6i9pa1PjLvYJzcNYvPDxRUec5DCQ+/gyN1KBe18YlrCxn0jZtd1Ub4FGA==@kvack.org
X-Gm-Message-State: AOJu0YwdgcZH3HA3HnJFs09WA8zKfNam7qt/CYcugNTXSnjacxVVLSgW
	Dt3DiZz31mVnm/I+AICiZrs9tvRH5+FzlUZ8+C4kJLVKsqMdCRmNDN4t
X-Gm-Gg: ATEYQzwgbzFyKCil/vx5EmDmmooAIchmFsHrZe48kI303aEM5Rd4HUORrk4toa5kC1P
	Pb2AXaghWuPjozIBGV/d/Sz+GfxsRH/dmc8NQILYk0yZaTbnOw9ndK8N2bxY+cY8ncV/cDE2WiO
	5xXyb2wN0ns7z/FIeScrjk5Qv78kxXUrLo9cDeHqNwjWkLmoeU+GQ0M7I4OYiy3eomB/J7wL2q2
	PMoCm/zDl2iLNUGk5iEcCWwdvlA5VAbql4dYyeylb8R84Jhs9zPMqBohrdov2Ly+X5/GImu8qmj
	WeqXKFU0Z7jMGC2zrKN9cCj/VYjxGKvROMBCriP6VuHi7u9qzjkudRfHF3JqbF7b1mBdTXpI9t7
	ntyKSM9zS6tdYIFopvVMfHgf9+wnGToiPPo5IMcT0xh3cQcBmbAW8lW6fj5npDk7lmDOJaQd4nJ
	6XdAq5zxkKHB40XEKpv6gNPDIht/2SHWkk/gsI97KvlON6Vw==
X-Received: by 2002:a05:6808:130b:b0:467:24cb:c00 with SMTP id 5614622812f47-467e5fbd406mr2192297b6e.57.1774034881749;
        Fri, 20 Mar 2026 12:28:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467e7d4c447sm1921168b6e.6.2026.03.20.12.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:28:01 -0700 (PDT)
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
	riel@surriel.com
Subject: [PATCH v5 16/21] swap: do not unnecesarily pin readahead swap entries
Date: Fri, 20 Mar 2026 12:27:30 -0700
Message-ID: <20260320192735.748051-17-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DCBEC40006
X-Stat-Signature: 43rdpfkm1zksmbyouqcc36ctin4xa37y
X-HE-Tag: 1774034882-238073
X-HE-Meta: U2FsdGVkX18SPR/t1uUN5/AKZS0HZzmQkOeiBPd0mp2uigJ7pGxENXguq3ZbGXXw5V/rZcBcPgfN+5kkdvVtRq8cFSU5r8ARFf176NMJcr6W4taYNC5jG5Ltb1xMyGAAZCeQNkSU1wPRvGkP5fpUqtMRojnjOIlTA5xuVT5/Z4Dj3hBW/7bmgHdDRV/fCP6TW5cjI23ITTSaPMZ+vrQkfKB3v7PHgyomlrzZ3ukmv7sLwd+Mvqj9BZjvQzwimcaeBMaOxCSCzc198sL44oZgVCxBWVypOdt7NzkiG3wto6XHL5Sr4nPiljI2bLkKpFGRQiJoCBhXBsqoIxGLBpClExM177LsCR4NNuMMSmKs36N3qKKZgKXRIGQyVKHQwa+xm3fhk1yAyrHYsW7bV7bLFPvEDY1e8mWLh6Ob9npOzGE7LbbPT2d+5DqamcxlTUvm9dzAnifCoAFJFJfyMyenZP4/K5673rHOzdFwho9oxRwm5LVlR7G11uthDUHw09Ci9TveqLjZxmzBelgT2I/VZJv4s4mMJqhJQHTfO5RvxDrF3f0of8lRVrfur+jOi0TmMN/nMyiGV8X46c+rJrAc6RkUNRqD4WSHtv3u4MgeYllp7GMTLCVyWncjvLOY0OFzJukMQTRKqB81sGzRJIxA2GWNvpO/t7GLNNilTaFufJkynwotUT5K1AjydEACD8Wy++DLb6XTle2d3A+iDKj9O7hrJB02/F8fLYcU/1DJvHjMVAjmwDEJ6e3W3Xm2E99CZQNCKfOoLeNOCO0tHcbVv7KXkkuqclriaxPkVFQrmu8UK2FZuuaPibV8MGHEwDvrgDu7Djpzh4pab1HtC72aOgt1PMN2IfF/py3ulZZAjyjP1iNihx1kjkwRWh78az8/+fajNRdJ91rVrllIMr0ZahI3wh1KCVBWS7y7tiJZyDdoqWt4+JcGI+C9Kll6lctD24GPXiGCNTi/T1PFmvl
 T356Z/ew
 ORpMBiLjsPrTakY9f1pH0LPoNMr6+mXDcUbXLD6Nxyz4IlQ0wf4RBD0bjH9YIDWkb47yLY4n4UV+KlYNA/7jkwZPXYebtP4El7pG/9gN6zNDn3i+pUjAm2+K/9pddHryHSSiTpdI2rac5gp9Qs7nPJCXs/a6DyYnjL6OAgYYHtaJhRdG1lhb1vy9cmljaf2U2hSRTtF/GbXmRs7hicjXBbRUrypyjlWrKInze8hHi24ec1Pekr7TaXiXmipIfnc6g7LsNn+eFnuusN4S628vw/NZeQqsqrUqCZp2ekirxbec3AIDQfgIxsoxwVa+RgS/+G+R2sN/eL9eFhx3E6n1R3uhMZhZ0cZvmfT5+2bBzDbPfNBwnjNBNQoQKlVxlNld3tSOE3mdk1NJO7UHLwNshHL6cKmRJKIw5nSV1FzWf9r9Vu4IP6GWMH52LLQvFO3EzXCV/4XFisBYnvKS5yeR9BVrRSGaBdNAoQnOuDNSPG30L2AvU8ZJx6i/EQBP03COQdD3jwEIRUu/vrtXMbf8/aoA+9ks95x5SHypH
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
index d7981ec82cf49..2229c3485b7e2 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -213,6 +213,7 @@ void swap_cache_lock(swp_entry_t entry);
 void swap_cache_unlock(swp_entry_t entry);
 void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 			   unsigned long vswap, int nr);
+bool vswap_same_cluster(swp_entry_t entry1, swp_entry_t entry2);
 
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ad80bf098b63f..e8e0905c7723f 100644
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
index 861a504c9fbfd..1040bb8a9f320 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -1418,6 +1418,16 @@ void put_swap_entry(swp_entry_t entry, struct swap_info_struct *si)
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


