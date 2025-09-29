Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A24CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 00:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191498E0003; Sun, 28 Sep 2025 20:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142438E0001; Sun, 28 Sep 2025 20:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030818E0003; Sun, 28 Sep 2025 20:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E30738E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 20:26:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 558F8856D6
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 00:26:28 +0000 (UTC)
X-FDA: 83940396456.13.5AE0976
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf27.hostedemail.com (Postfix) with ESMTP id 86D3440002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 00:26:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c9raMl1z;
	spf=pass (imf27.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759105586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZrb9ZvwMY4YVa3pVe0HMYNnPnxeY8/s3k+/iyrjb1c=;
	b=35x7KiXQQJ4nb4/grjt3XszMwkLUwT+Uac8GmAFfdaqxwahRT0G9/llgDkMp0IeE7DQimh
	gWEHtDwj8+t/skFR28p1mgRmdTTFAsYjYv1/e85A0azvZuwxsZvoSqUxYvg7fLbHlxPk87
	MkdgB4Qgh3t8LqTX7vWq4EtCQ7LIFTg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c9raMl1z;
	spf=pass (imf27.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759105586; a=rsa-sha256;
	cv=none;
	b=dAJ/ukkG7KrIN0Pi4xlUE3vIgYOdQMrNGL8L1S6rlTW3XgJ1Fr3XwzbBYRi5rHu1ipyUSP
	uxhqwTCdTA06hnjzpS9pQ0NKG52RdIq4wtJFwYEnKNTuvySEIRUJ20MMaPbes85urppCBb
	tuFEhhnK6ojwjczhRga/7NUWeD6OxJw=
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-27eec33b737so37798635ad.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759105585; x=1759710385; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZrb9ZvwMY4YVa3pVe0HMYNnPnxeY8/s3k+/iyrjb1c=;
        b=c9raMl1zwBI5XCRzx43WxtylQ/qXfBe9kRhaD2Ghu9CMdaJH7V1KMj7j7DT4IYoxjQ
         QGxEtBswHoxfbtIqeGfKgHZIVyEyKEon8Q6HsY/wUkVpIKYsfWgBRDggo+fSRhpnvgc4
         3W3x2Yz+L/TolQV/YAimofRjg62060WFZViGZhws7btmIzNBpYhcF6p/uWthFfl2IHwa
         0lToiBfqkPXUE8SCYGtpSaRZYHWLDpkVYIqnxrHZzBNwR2JYahIwYW+qqAAHlqyc++kM
         lbi9lYhwqEYcdY4P/ZFyKp8xorTVVQ0QFQ9ztwm0qdsCHjMqFcR8IdPBuoCRQJb//79Q
         KG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759105585; x=1759710385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FZrb9ZvwMY4YVa3pVe0HMYNnPnxeY8/s3k+/iyrjb1c=;
        b=vfXzhGQingwXFc7VzDpKSJYOr7KRiUABGxgBrjhrOIRB2E2OA/TMXriu++8ywWCl1h
         tp5REGO8evFqFQyisd3G83bUX0UicvX1Daxgax0IUb9DY+k2wFeKLUanx3L2XORoqr3M
         jtyMug1zDVexUFk1SO5cCKRQIMM2rzl06icdyApA7/XDdVVSn6oW3Qg1AX8c8n6GTGQS
         Z3aptPlOZirbHBIwSWhP4aGLcCkXAIxrXWZ0OVed2WZm/wA66NL+j3ocypFpdBtr13rf
         FsmuSNPQWEn4s003As9ziQ6ctWZSmcnzWLNG1dQ35L8gwrT0Sw97SiN+U07rq7XcPlVU
         rAhg==
X-Forwarded-Encrypted: i=1; AJvYcCXcQuDP6Gq9bHegDpKsEyApZ/ByqKs+MZxfh0iy4zIM22JmkuwhQUu9RzCgxd7OtlTkjz/JXRvTXw==@kvack.org
X-Gm-Message-State: AOJu0YziKy5F5GfhpzM4Ea7pCgRtMLyi9fyQ0o+hRkY2foVdACXdshjz
	vs2I2Gv/A1DmHJXjLECfP4CqZgdTQTXpGSNBieYPOvt3qMwuSvJxB4ub
X-Gm-Gg: ASbGncvR5kAAPb2xK2PgBcncb0iteRNx/Mg/6M+2m8IWrKR6tvu6qsgG8pKXE5CDtV3
	dPw75Bl47IiDZNQog7WZRf/nU8nVpVZoiwaYY2dlRkrPGn+RDYpCaaiAi8w+ZhYsUn73bymbKbM
	IakBqe1XmAr6B91iCx/+E7Wqi3qTt+7DVMHypJkIs8QB5+RSHPO5zSXRuChV/AUsP1/Ab+4TYub
	OaxcWLBgZf8xeq8Y1zNrq8VLVrLwQf13J+Ync40EdjMh0O4AO4WOhey7KGpWQPlph/tnfBxqXQm
	gItk6CCNGd7EdVorHNAjkGlZ15QZ4sFk2LU23wvH6viwdbAOOf8bC0AOpn9z8xyplq8aiYoNYLz
	ET5BZ3glrilcIzOuM7Jnm0IPMvBrcvJNDa7sXexOS1sw3f+V5UAAWItuOmKGJCA==
X-Google-Smtp-Source: AGHT+IGrz7KB/SLZGGqdC4PjQh6NI66U1D6gdU3o+zPe+ACkknBSABitdv3/6WSkVWyn8RC6rByWxA==
X-Received: by 2002:a17:902:e806:b0:267:6754:8fd9 with SMTP id d9443c01a7336-27ed4a3cfedmr156764855ad.39.1759105585085;
        Sun, 28 Sep 2025 17:26:25 -0700 (PDT)
Received: from E07P150077.ecarx.com.cn ([103.52.189.23])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6882160sm111191395ad.71.2025.09.28.17.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 17:26:24 -0700 (PDT)
From: Jianyun Gao <jianyungao89@gmail.com>
To: dev.jain@arm.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	bhe@redhat.com,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	cl@gentwo.org,
	damon@lists.linux.dev,
	david@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	glider@google.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	jianyungao89@gmail.com,
	kasan-dev@googlegroups.com,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	nphamcs@gmail.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	shikemeng@huaweicloud.com,
	sj@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	xu.xin16@zte.com.cn
Subject: [PATCH v2] mm: Fix some typos in mm module
Date: Mon, 29 Sep 2025 08:26:08 +0800
Message-Id: <20250929002608.1633825-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <3c3f9032-18ac-4229-b010-b8b95a11d2a4@arm.com>
References: <3c3f9032-18ac-4229-b010-b8b95a11d2a4@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 86D3440002
X-Stat-Signature: ijw9w63kfyrg4kzoyxkbgeimgm6fnpwz
X-HE-Tag: 1759105586-876772
X-HE-Meta: U2FsdGVkX19dIT+4G5wZeYx4EC+gGrjuXsWTt7qaGd3FjvlA/98zxMU/laOgPNXDGTTgWv9YfrVvrwrJp3KgAvTNe0Xcfn57yg2RYAi0vauAPJTyElRzMqrvVDujlwg8yAcDoYrAcYK+MSg881S/pZkIItRsHmR/OKsVsTlX3GgmZ8wLI9siAt3XniMvsgqiTGQvaMlWAxfkHh5AjfI+2la1rQ8uA1d9BUqiypoXPdn/KcADolQQqF26k66GBZ/0CFdudjeU6dzfQB6QVWlWGnOAuHgKIrWi7WIUGBJvBucE4cPF+LpWtcTpoPh/iOq7LQsy9DTAFqPU41wGHaizuKmMxfNA0w/kZAV5Qac5GcEd647MRap6joOVGpW6pNpy47wcZgIzruJmGA4eYmJ80uRCvOmpz8GtfG1X+AJ5bu5uxawqsYQdHLJpA3ATqnJsiH1pftQqNaNGVbUV+/0Q/MYv7FNJi+T50GdxQ202tyzgKlV6yXP1VTKdCbTna5vMR4h58iHxSKgiXzNJAyDGAG31kl6qNUTWeuML/awuzU72aJuigQ620McJX2rFXkDDRHyGWnhxvyAae2A7Xg+84u6nf+vMcBgPpEiDrYvvdk7CRXYoY8AtukPjWhRIdfzPn0f1xt7LZMbL/0dgMCUCW6yzdBxGAXWsK0ZXCirN7ycQRiRMi1yzR/eK+7gGm7Ruvhf2YqndqN8rG1iQYV0ngsDPGPq+6RPdkDO2YsIz5l9eJuJ1MjDIiL2u8hnYgwoScyVrroiRx2G/RpSwQ0Xpa5X0Gqj84dAgbJ24ZxGX4zTNBz7zFkuFP7I4QNv+Ktln3Mpya/4vGhKfuvIq88ynVVUhn7oPFYf7bDj+KGwIi1pfCJHWS/pSQrs8TmBzFdYo86nd4mp3BnTfaI4YCb5v4R72DA5sKTpJsXCqYhmi9jOgpXfkD5uoQo7LSxyRyXFIeP15l985RjBMB6TeV1g
 M/eUCkQ3
 VW6CDOEvUauhwQQso3dUXmYUoVYJffmx/uei7YCV0sEqrM2VIqmqbbabemA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "jianyun.gao" <jianyungao89@gmail.com>

Below are some typos in the code comments:

  intevals ==> intervals
  addesses ==> addresses
  unavaliable ==> unavailable
  facor ==> factor
  droping ==> dropping
  exlusive ==> exclusive
  decription ==> description
  confict ==> conflict
  desriptions ==> descriptions
  otherwize ==> otherwise
  vlaue ==> value
  cheching ==> checking
  exisitng ==> existing
  modifed ==> modified
  differenciate ==> differentiate
  refernece ==> reference
  permissons ==> permissions
  indepdenent ==> independent
  spliting ==> splitting

Just fix it.

Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
---
The fix for typos in the hugetlb sub-module has been added.

 mm/damon/sysfs.c     | 2 +-
 mm/gup.c             | 2 +-
 mm/hugetlb.c         | 6 +++---
 mm/hugetlb_vmemmap.c | 6 +++---
 mm/kmsan/core.c      | 2 +-
 mm/ksm.c             | 2 +-
 mm/memory-tiers.c    | 2 +-
 mm/memory.c          | 4 ++--
 mm/secretmem.c       | 2 +-
 mm/slab_common.c     | 2 +-
 mm/slub.c            | 2 +-
 mm/swapfile.c        | 2 +-
 mm/userfaultfd.c     | 2 +-
 mm/vma.c             | 4 ++--
 14 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index c96c2154128f..25ff8bd17e9c 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1232,7 +1232,7 @@ enum damon_sysfs_cmd {
 	DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
 	/*
 	 * @DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS: Update the tuned monitoring
-	 * intevals.
+	 * intervals.
 	 */
 	DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS,
 	/*
diff --git a/mm/gup.c b/mm/gup.c
index 0bc4d140fc07..6ed50811da8f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2730,7 +2730,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  *
  *  *) ptes can be read atomically by the architecture.
  *
- *  *) valid user addesses are below TASK_MAX_SIZE
+ *  *) valid user addresses are below TASK_MAX_SIZE
  *
  * The last two assumptions can be relaxed by the addition of helper functions.
  *
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eed59cfb5d21..3420711a81d3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2954,7 +2954,7 @@ typedef enum {
 	 * NOTE: This is mostly identical to MAP_CHG_NEEDED, except
 	 * that currently vma_needs_reservation() has an unwanted side
 	 * effect to either use end() or commit() to complete the
-	 * transaction.	 Hence it needs to differenciate from NEEDED.
+	 * transaction. Hence it needs to differentiate from NEEDED.
 	 */
 	MAP_CHG_ENFORCED = 2,
 } map_chg_state;
@@ -5998,7 +5998,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	/*
 	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
 	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last refernece would not be dropped. But we must
+	 * guaranteed that the last reference would not be dropped. But we must
 	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
 	 * dropped and the last reference to the shared PMDs page might be
 	 * dropped as well.
@@ -7179,7 +7179,7 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 		} else if (unlikely(is_pte_marker(pte))) {
 			/*
 			 * Do nothing on a poison marker; page is
-			 * corrupted, permissons do not apply.  Here
+			 * corrupted, permissions do not apply. Here
 			 * pte_marker_uffd_wp()==true implies !poison
 			 * because they're mutual exclusive.
 			 */
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ba0fb1b6a5a8..96ee2bd16ee1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -75,7 +75,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 	if (likely(pmd_leaf(*pmd))) {
 		/*
 		 * Higher order allocations from buddy allocator must be able to
-		 * be treated as indepdenent small pages (as they can be freed
+		 * be treated as independent small pages (as they can be freed
 		 * individually).
 		 */
 		if (!PageReserved(head))
@@ -684,7 +684,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		ret = hugetlb_vmemmap_split_folio(h, folio);
 
 		/*
-		 * Spliting the PMD requires allocating a page, thus lets fail
+		 * Splitting the PMD requires allocating a page, thus let's fail
 		 * early once we encounter the first OOM. No point in retrying
 		 * as it can be dynamically done on remap with the memory
 		 * we get back from the vmemmap deduplication.
@@ -715,7 +715,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		/*
 		 * Pages to be freed may have been accumulated.  If we
 		 * encounter an ENOMEM,  free what we have and try again.
-		 * This can occur in the case that both spliting fails
+		 * This can occur in the case that both splitting fails
 		 * halfway and head page allocation also failed. In this
 		 * case __hugetlb_vmemmap_optimize_folio() would free memory
 		 * allowing more vmemmap remaps to occur.
diff --git a/mm/kmsan/core.c b/mm/kmsan/core.c
index 1ea711786c52..1bb0e741936b 100644
--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -33,7 +33,7 @@ bool kmsan_enabled __read_mostly;
 
 /*
  * Per-CPU KMSAN context to be used in interrupts, where current->kmsan is
- * unavaliable.
+ * unavailable.
  */
 DEFINE_PER_CPU(struct kmsan_ctx, kmsan_percpu_ctx);
 
diff --git a/mm/ksm.c b/mm/ksm.c
index 160787bb121c..edd6484577d7 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -389,7 +389,7 @@ static unsigned long ewma(unsigned long prev, unsigned long curr)
  * exponentially weighted moving average. The new pages_to_scan value is
  * multiplied with that change factor:
  *
- *      new_pages_to_scan *= change facor
+ *      new_pages_to_scan *= change factor
  *
  * The new_pages_to_scan value is limited by the cpu min and max values. It
  * calculates the cpu percent for the last scan and calculates the new
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 0382b6942b8b..f97aa5497040 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -519,7 +519,7 @@ static inline void __init_node_memory_type(int node, struct memory_dev_type *mem
 	 * for each device getting added in the same NUMA node
 	 * with this specific memtype, bump the map count. We
 	 * Only take memtype device reference once, so that
-	 * changing a node memtype can be done by droping the
+	 * changing a node memtype can be done by dropping the
 	 * only reference count taken here.
 	 */
 
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..d6b0318df951 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4200,7 +4200,7 @@ static inline bool should_try_to_free_swap(struct folio *folio,
 	 * If we want to map a page that's in the swapcache writable, we
 	 * have to detect via the refcount if we're really the exclusive
 	 * user. Try freeing the swapcache to get rid of the swapcache
-	 * reference only in case it's likely that we'll be the exlusive user.
+	 * reference only in case it's likely that we'll be the exclusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
 		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
@@ -5274,7 +5274,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 
 /**
  * set_pte_range - Set a range of PTEs to point to pages in a folio.
- * @vmf: Fault decription.
+ * @vmf: Fault description.
  * @folio: The folio that contains @page.
  * @page: The first page to create a PTE for.
  * @nr: The number of PTEs to create.
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 60137305bc20..a350ca20ca56 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -227,7 +227,7 @@ SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
 	struct file *file;
 	int fd, err;
 
-	/* make sure local flags do not confict with global fcntl.h */
+	/* make sure local flags do not conflict with global fcntl.h */
 	BUILD_BUG_ON(SECRETMEM_FLAGS_MASK & O_CLOEXEC);
 
 	if (!secretmem_enable || !can_set_direct_map())
diff --git a/mm/slab_common.c b/mm/slab_common.c
index bfe7c40eeee1..9ab116156444 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -256,7 +256,7 @@ static struct kmem_cache *create_cache(const char *name,
  * @object_size: The size of objects to be created in this cache.
  * @args: Additional arguments for the cache creation (see
  *        &struct kmem_cache_args).
- * @flags: See the desriptions of individual flags. The common ones are listed
+ * @flags: See the descriptions of individual flags. The common ones are listed
  *         in the description below.
  *
  * Not to be called directly, use the kmem_cache_create() wrapper with the same
diff --git a/mm/slub.c b/mm/slub.c
index d257141896c9..5f2622c370cc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2412,7 +2412,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 		memset((char *)kasan_reset_tag(x) + inuse, 0,
 		       s->size - inuse - rsize);
 		/*
-		 * Restore orig_size, otherwize kmalloc redzone overwritten
+		 * Restore orig_size, otherwise kmalloc redzone overwritten
 		 * would be reported
 		 */
 		set_orig_size(s, x, orig_size);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b4f3cc712580..b55f10ec1f3f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1545,7 +1545,7 @@ static bool swap_entries_put_map_nr(struct swap_info_struct *si,
 
 /*
  * Check if it's the last ref of swap entry in the freeing path.
- * Qualified vlaue includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
+ * Qualified value includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
 static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
 {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index aefdf3a812a1..333f4b8bc810 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1508,7 +1508,7 @@ static int validate_move_areas(struct userfaultfd_ctx *ctx,
 
 	/*
 	 * For now, we keep it simple and only move between writable VMAs.
-	 * Access flags are equal, therefore cheching only the source is enough.
+	 * Access flags are equal, therefore checking only the source is enough.
 	 */
 	if (!(src_vma->vm_flags & VM_WRITE))
 		return -EINVAL;
diff --git a/mm/vma.c b/mm/vma.c
index 3b12c7579831..2e127fa97475 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -109,7 +109,7 @@ static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_nex
 static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 {
 	struct vm_area_struct *tgt = merge_next ? vmg->next : vmg->prev;
-	struct vm_area_struct *src = vmg->middle; /* exisitng merge case. */
+	struct vm_area_struct *src = vmg->middle; /* existing merge case. */
 	struct anon_vma *tgt_anon = tgt->anon_vma;
 	struct anon_vma *src_anon = vmg->anon_vma;
 
@@ -798,7 +798,7 @@ static bool can_merge_remove_vma(struct vm_area_struct *vma)
  * Returns: The merged VMA if merge succeeds, or NULL otherwise.
  *
  * ASSUMPTIONS:
- * - The caller must assign the VMA to be modifed to @vmg->middle.
+ * - The caller must assign the VMA to be modified to @vmg->middle.
  * - The caller must have set @vmg->prev to the previous VMA, if there is one.
  * - The caller must not set @vmg->next, as we determine this.
  * - The caller must hold a WRITE lock on the mm_struct->mmap_lock.
-- 
2.34.1


