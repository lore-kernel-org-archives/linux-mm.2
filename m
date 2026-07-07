Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF13BC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC816B00CB; Tue,  7 Jul 2026 02:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E9F6B00CD; Tue,  7 Jul 2026 02:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CFB6B00CE; Tue,  7 Jul 2026 02:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1A56B00CB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04C641A0328
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:44 +0000 (UTC)
X-FDA: 84961037490.02.C945EA9
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4454520005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z76tJDtR;
	spf=pass (imf03.hostedemail.com: domain of 34Z9MagsKCKweagdMhbMZPMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--souravpanda.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=34Z9MagsKCKweagdMhbMZPMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbIFtySlJ/B4vAMWak3mVgchLPUkdC1Nvsmy15z5aNM=;
	b=m7vDbxLYYGNZ0lIF8udJc1BaprZWaTWqo5qvWuLkYw3fIe68VqnBaWlmBRWNBFszTWGUyo
	KR8hROEu7DRnHXt40vZmO3nzXfsll2QkLlIK3a6gl0JLEdacRjQ8MKe4xfPv/eCVSMA1iw
	ZpGOqtAoWWsCTk6UUGKu4MpELyMSsig=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z76tJDtR;
	spf=pass (imf03.hostedemail.com: domain of 34Z9MagsKCKweagdMhbMZPMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--souravpanda.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=34Z9MagsKCKweagdMhbMZPMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406563;
	b=KGftp5Urgc17EpI/JmJ9SudmeMJoVx4aI4u6bb+2Y6InaCc6IdKJGDILUvP48BlwhDJfAr
	hFVuro07IG0PYz9RmdReuAMxxDW0c/3wT6iIM5r1uMOTaoaF53e0uujNHrg41BFHDHr1v8
	uKSK10WmzP9Qtv5kbeIAuViBkxXHM9Q=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-845bc2e658aso3514144b3a.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 23:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783406562; x=1784011362; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zbIFtySlJ/B4vAMWak3mVgchLPUkdC1Nvsmy15z5aNM=;
        b=Z76tJDtRM9wSQD2rl9CrCuWP3pye3wzugnVaCJ5smeCwevXe6ShT7f6RCq3gQQ8/Pv
         wkUS0qFemkVo+/TCyl2kJqphdmdBeUBLVFxfZoIfS4iCiCyZAsquzl1Ty2YU84kmcdgx
         9cEFfJ74WBNNjS+VaO7W1xnX35sAp19NvRWEdpIJ4hjO/HKNPjop5AJn9ApLp1VK9Aco
         sd8zBsEmtAu13O2ozz+dQtmwsyqjxyMwZDbahpyOctWX7k9vEmsKZTGnUrOucCvECuMs
         n4uSj4xFW0PUcsHCr+KU1crRUQmd4XRSsU3jrc+7qNwKF0ngwJSNuAHnr/ru6KtH4Kpd
         AJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783406562; x=1784011362;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zbIFtySlJ/B4vAMWak3mVgchLPUkdC1Nvsmy15z5aNM=;
        b=Oc5lEOPnjQphic2IDrotOaY87vo22V0fytAUMA/aDPPg4k9gWDOB6RX7J+zJ+UJDeg
         m7eE8xBh4NkO9aXulIN+8SlS4yFjn2G3Ujr9Eh8lDXFcvozjblrXE9PoUiEcBrsw7N29
         1S0SR/ePmDy39c+RYd/KW4e6Iu+XV/Ofxdd73G3F4bn5xfVs3kDha79hoSZOXSpUAupe
         nDF+IZVlxJQ3CPrMKVD5aomdWrGpU9vUhA++MtwsCSklJ6+hX4g9MwDSzBoOjdL8dyCN
         Nyxuj+tvsoHjnwbkBRlbhYDe9ZUCb854buQlPSESgPn3PKNYisjXe0yHrs13B6LVmHnu
         /eEg==
X-Forwarded-Encrypted: i=1; AHgh+RrE3/ELdA/MHjBi5TdTesq0Jx+S7V0SsT1QeNHB5VqqkEHyFA0XmBPj5ub36axVxKOJcy2Rwio8ng==@kvack.org
X-Gm-Message-State: AOJu0YxIpHG2hnSfinmzq0qeDKTmn8pJ3YG48N9rh1kz6aluikxEAFsa
	wfNCwt7Omf5MIx0MZZsZsSkvs1KYWXFQVUqxzahcZNfu1ZKMugmGD8KoWO4wlq1YfjfNG6Dp/BW
	0ZkGqBnvHT9/Dof0aI7V1LD07Bw==
X-Received: from pfbbx25.prod.google.com ([2002:a05:6a00:4299:b0:847:82b3:aca])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:94a4:b0:848:2e3c:9955 with SMTP id d2e1a72fcca58-8482e3c9a98mr1470448b3a.4.1783406561929;
 Mon, 06 Jul 2026 23:42:41 -0700 (PDT)
Date: Tue,  7 Jul 2026 06:42:33 +0000
In-Reply-To: <20260707064235.1386552-1-souravpanda@google.com>
Mime-Version: 1.0
References: <20260707064235.1386552-1-souravpanda@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260707064235.1386552-5-souravpanda@google.com>
Subject: [PATCH 4/6] mm/hugetlb: add memory shrinker for cache
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mst@redhat.com, 
	mhklinux@outlook.com, souravpanda@google.com, fvdl@google.com, 
	gthelen@google.com, mike.kravetz@oracle.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, riel@surriel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4454520005
X-Stat-Signature: e3u6oz4sf48cn6h88p4nttzj3jyed4s9
X-HE-Tag: 1783406563-567484
X-HE-Meta: U2FsdGVkX18iyIQJKeacjBFH6f7YdRmHAaHNY/sROA6smCFUj/cBlBLN9HXcnHFIVK82YcjsM+pWf0/9Nsvv/e+OllOcmKVScR99waRD4aTVD/W3TdrbrrcYkkEfImO08aemJA9F/pkRGD6ugkTXGgied2NxFD7VESW5epZ0oz5xkXRQkqcbgVrWYZAhMK4i/8kmSGhYqOgn9rqy/aDbD9U5mTV38YSkzste8mUZIzYA1p1bxr1cDlZF5kf8uVlF/YW2StjFH2Dlu5DI3XrcYfHmGahbqUxKYqvR433Kfb4RAAnxz8VOD/VtzKmxRXy5318Awl/a6TTRp2OHUr/ZMQYtW6W/qDRtLbQpHOu2wcB6gJ4Zyt83ckyK1cdjPfglNUGNgUY0m04HuWxavoPbdXrY/CJAcPND+dmqpLjc3fgUl44PE3McL9hQ/r2W2nv9CYipbcEuJGITErF31reALPacO9g/+7oOjOsLo4nVwhjhwBZ9n5IkkNywkVzMTEmEIcDdLwXfJqdK2CNewfoi7EweeJ95mjryp/zdQVW0tvBbeYMk2r+dkBp/ecgGg2U9VAcCmJCsRYr+v7xWalag0HpB6Sx0tgdY7bEN6xAnXpffXng5WlGu4k1UjEAGDFlfiYu69rpbUJhi566bLFO/8vhm8nZqzbTngLfG2FukqLIfchuDyT/4vvHfccdj7mnxEj6+NKJAzG32hMmCDXiq1TZcksB0na9WNnr7C8azdiiCePt88zmV+8fZ1qd+FzjPVr7tmpTdjKpD6HJcBmEwjBUCDsjIG5FpyKlr9MMCyoMaa5mis82jyrkDv3E29u5kvWSVUBQw+pmV6jC/AfkXzEDW84gCHH7EXoTF80+QCacIkTNqxm1ayJMaQl23u5oNulzSjTHhvqHn1sa6s6sygcy3BlH/sU47Y/g6Q+wVEHDl/w2YlVMdrQoSvq0UG+BKqSwiXnQ2+LWCy8E0rl9
 DaUlY50A
 yQDJAg9gP4irSmzFmZRvT2rt+x+f026ACpZKZhAj+V7srpdgZZ0L0sIrE6HiqymJm0rYHeygUfXRg+2zquvppABY/f7bCrGCRg7azhnEIVUwsIMmaxcvK+6T09NKLvAvkgBHxAYkFHrUQj1Mvy93kSa7kmfRXXEpmyPDTV8s2PfCsDBcW0FYn+WnwKCZDnhQ+HXm5gf3uzLmvEh7C29XWEyG1GqCsYpFZRdIyRFZQpmODMHmeAwyBdhEM/QvV0quhDTl3M0sH5eP/5Kt7nxyhW069gWmw7MFJLbBp1EfHhSl/KebLoxj8ERaexZMeqayw3at70pxLvo4IzLqljOZkNWLwjavKxdHxN0mtWQdD5mtxZaG8nCnSEywbktEq2frb3/DzbU5KUI/mfajCV+D/eUxSewS0aoO/h6TgyVHjV14ZyGQKfRVyILb8kQiqKTUhr1jnmztrB2yp6MzwapVqOi2slJblAIKpzhyU4ps4g14NNa64S6O3srH55oACGXW2kCOagO/Ph80bR+DR+VzalXYGDH3njz8MKs0YzGyztm+OXm1iFOnoYRZ+de21vROtosbAES2en6X3M+LDDC5D50NbUMDvPzXXRrog2h8+IKNEQ8Aodau70idFtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register a memory shrinker for the HugeTLB dynamic cache to
reclaim cached pages under memory pressure.

Implement hugetlb_shrinker_count to report the number of cached pages
(currently limited to gigantic pages in the shrinker) and
hugetlb_shrinker_scan to free them back to the buddy allocator.

The shrinker scan uses LRU policy to reclaim the coldest pages first.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 mm/hugetlb.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f18a3123cbcb..1bc0198a695c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4399,6 +4399,68 @@ ssize_t __max_cached_huge_pages_store_common(bool obey_mempolicy,
 
 	return err ? err : len;
 }
+
+static unsigned long hugetlb_shrinker_count(struct shrinker *shrink,
+					    struct shrink_control *sc)
+{
+	struct hstate *h;
+	unsigned long count = 0;
+	int nid = sc->nid;
+
+	for_each_hstate(h) {
+		count += h->nr_cached_hugepages_node[nid];
+	}
+	return count;
+}
+
+static unsigned long hugetlb_shrinker_scan(struct shrinker *shrink,
+					   struct shrink_control *sc)
+{
+	struct hstate *h;
+	int nid = sc->nid;
+	unsigned long freed = 0;
+	unsigned long to_scan = sc->nr_to_scan;
+
+	for_each_hstate(h) {
+		while (freed < to_scan) {
+			struct folio *folio = NULL;
+			bool atomic = true;
+
+			/*
+			 * Only do synchronous vmemmap restoration if the caller
+			 * context allows blocking and FS reclaim (GFP_KERNEL compatible).
+			 * Otherwise, defer to workqueue to avoid lock inversion.
+			 */
+			if (gfpflags_allow_blocking(sc->gfp_mask) &&
+			    (sc->gfp_mask & __GFP_FS))
+				atomic = false;
+
+			spin_lock_irq(&hugetlb_lock);
+			if (list_empty(&h->hugepage_cache_lists[nid])) {
+				spin_unlock_irq(&hugetlb_lock);
+				break;
+			}
+
+			folio = list_first_entry(&h->hugepage_cache_lists[nid],
+						 struct folio, lru);
+
+			remove_hugetlb_folio(h, folio, false);
+			spin_unlock_irq(&hugetlb_lock);
+
+			update_and_free_hugetlb_folio(h, folio, atomic);
+
+			freed++;
+			if (current->reclaim_state)
+				current->reclaim_state->reclaimed += pages_per_huge_page(h);
+		}
+		if (freed >= to_scan)
+			break;
+	}
+
+	return freed;
+}
+
+static struct shrinker *hugetlb_cached_pages_shrinker;
 #endif /* CONFIG_HUGETLB_CACHE */
 
 ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
@@ -4502,6 +4564,21 @@ static int __init hugetlb_init(void)
 
 	for (i = 0; i < num_fault_mutexes; i++)
 		mutex_init(&hugetlb_fault_mutex_table[i]);
+
+#ifdef CONFIG_HUGETLB_CACHE
+	hugetlb_cached_pages_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
+						       SHRINKER_NONSLAB,
+						       "hugetlb-cached-pages");
+	if (!hugetlb_cached_pages_shrinker) {
+		pr_warn("HugeTLB: Failed to allocate shrinker\n");
+	} else {
+		hugetlb_cached_pages_shrinker->count_objects = hugetlb_shrinker_count;
+		hugetlb_cached_pages_shrinker->scan_objects = hugetlb_shrinker_scan;
+		hugetlb_cached_pages_shrinker->batch = 1;
+		shrinker_register(hugetlb_cached_pages_shrinker);
+	}
+#endif
+
 	return 0;
 }
 subsys_initcall(hugetlb_init);
-- 
2.55.0.rc0.799.gd6f94ed593-goog


