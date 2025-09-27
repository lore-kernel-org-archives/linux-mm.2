Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845B6CAC5B9
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 08:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1CCF8E0003; Sat, 27 Sep 2025 04:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC2A8E0001; Sat, 27 Sep 2025 04:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94128E0003; Sat, 27 Sep 2025 04:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2B08E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:07:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4023211A628
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 08:07:53 +0000 (UTC)
X-FDA: 83934301626.26.A757BF8
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 760BBA0008
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 08:07:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xb4R7Bu6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758960471; a=rsa-sha256;
	cv=none;
	b=7RuuBAGVVHq35JYAe9nlSHZKzZitA9KexP9Dpw7UkBMUYwf1gVV+xRtq2zaOGvRcVPcg8D
	oVBLsugKSQv5EsRen8Pkk7ZAnOq4bm373aMPIY1J0RXtsxZPPq/mjewr3pHdHuHopg7Vpq
	809pPB6xy07ON30g7YJt35+9TGOfnP8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xb4R7Bu6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758960471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2pnX7Z7v528RTOngSyYskOdERrXRUZlzBZkjWOik6R8=;
	b=5bRRSHGtzf0pPQOTmEEtcmm56z4F8x0j9d0TjcTA0NSmBC/cHMDTGIkbCDTG6n1jtlnlqZ
	jGWH53WwOiMw70eJiJs352gejvcUqMgwhSCJGQkUg2GPUzmsJV0lcrcpxLU9e7UDfDk5yl
	dTvL7gGKd1bdu6ACIqgVhOzEb3SEFQI=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7811fa91774so981936b3a.0
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 01:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758960470; x=1759565270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2pnX7Z7v528RTOngSyYskOdERrXRUZlzBZkjWOik6R8=;
        b=Xb4R7Bu6uW6v9FKvAC8gxFKuyDEUSm2RChT/DJZXczhZahVmfFnBMSu1zuLAS9ofz4
         4O3vVHkI97GjijSsCcCHwDulHv7Y9NxQFzBanoXky//GY9ITYWHu9GecgXGM1EZewReb
         hKl3PTE3xTdUTq/snF/80RzNcpIYuHSYZEBfFNJExnP2GbZ8Mr0WIRZGwwtJkgu+QcIv
         DIZ3BJHnxDcM3zX23eq4R0ywcn2vyXuOFk68rV5cfC+tMUwYYzQZ/M8wa6iCL1BB5YkF
         kgsR5eeTz9p+Q/LBiOpioPmp4hv/x3fxTxwvAO9m8W8b0ljg3Nk0d6iGweV0c8xiggu0
         NTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758960470; x=1759565270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2pnX7Z7v528RTOngSyYskOdERrXRUZlzBZkjWOik6R8=;
        b=UwAPVk964DvEgMhg//EdO96rCFTLyBrt6asWPmAietO8Ny7Tt/TDmKgJu6GwAr0Kum
         v32FmiToAvNAbuQOUENnkrHBJb8xqvPCfWOpL0j8qezcl3kfpWRgABHPOciQ7DTBADhd
         m0qEyaFRw0RfA+bH5PBP82QgtDZF89tzyOQiilMvWwj6QnoDb8qvHdgka+WNM6VdzKdR
         avWPTT4gFmvd5blFiD8rjKIIFubjcPRxaKcj1JZt+EEnTwJems+g2QA31MJ0DZgbH4sD
         e7g3EqWnZ6HRcnwquyoDVNP6ZbYXmULr5aKY3Pc5mW7F5kf47HqJcZDqFycSfKmLRsFC
         YlDw==
X-Gm-Message-State: AOJu0YynXqFvnfvnM6CrjHuWjczE72muEzZuWRBgnW9iDE4HFgDP4gjN
	78hTsOjCEDjVS1fHhSlftJQFINt1UXWzhpxvsBO7LLMWGhoRa1M7WDWBB54e3EBp
X-Gm-Gg: ASbGnctGmAwzFcUpNT+hKlxfY8LoyfwPKtQLIC04ogrr5ocCr2mlWBbxuzdtbP5Vnks
	jPFXhVBA/k0MW6qa0whlQb5TZv2RILsmaaNrB0btsi1r/mAU8bDI0f2NyZBCmPeKpB43GEsNBCg
	9h/zp8ex3kkcq5ORgQvcXpUfzkZ3DlYF07QvFTpT4IaSaJlu15r5OpzWg06KcAyMWzZJ7YH1jGd
	OX2383ftxXAU72VBGKgH4CDIFX7NEjiWEZg8+O5oaFpq5R9ucqaXzTIb8V06DahUtRd6/BJ+2Qd
	8WJFhmVUcU+JDAvRgn+kudbb5d/x2o3AqsW+aSCSoKyhb63eRefv4h++I2p8SLYbyYuK07Tl5Ms
	FiltgJDbBGpJJ7aPZtJLmIBTaPgWx+Y9HunjUAdCW
X-Google-Smtp-Source: AGHT+IHa8OtN7NuIoR42xaLkir4lydhP4OP69ifxN66GwwvL4dolRG1B/QZf4EvOu693LGSGG6zhKg==
X-Received: by 2002:a05:6a00:14c5:b0:781:d163:ce41 with SMTP id d2e1a72fcca58-781d163d14bmr599623b3a.11.1758960469954;
        Sat, 27 Sep 2025 01:07:49 -0700 (PDT)
Received: from E07P150077.ecarx.com.cn ([103.52.189.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7810cfdb99fsm4744233b3a.31.2025.09.27.01.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 01:07:49 -0700 (PDT)
From: "jianyun.gao" <jianyungao89@gmail.com>
To: linux-mm@kvack.org
Cc: "jianyun.gao" <jianyungao89@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	damon@lists.linux.dev (open list:DATA ACCESS MONITOR),
	linux-kernel@vger.kernel.org (open list),
	kasan-dev@googlegroups.com (open list:KMSAN)
Subject: [PATCH] mm: Fix some typos in mm module
Date: Sat, 27 Sep 2025 16:06:34 +0800
Message-Id: <20250927080635.1502997-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 760BBA0008
X-Stat-Signature: ff1nec7fhds76i3htqf5mngn9efqywz7
X-Rspam-User: 
X-HE-Tag: 1758960471-318962
X-HE-Meta: U2FsdGVkX1+v33iiWWPZDhTVOKOWlIbQIp84OAjf1JVgrc1sQGuTMFqnKW80Z59wJ/ch0Jv+98KomoJzFZUjkirGchqD0R5r1RZzHj0BsdOGPz9eMar2OWJF1ctCE5cQqCcPUL445AeUBvlIijK9cX19q9PbRJbFAuvj/qHGH5dJabzguWa1YaZmi8CRiaccpTwm5KD0lAYinmj0LYXx8d7szdGlb0zVbtXXd53oioY+JQrPpwhoZzrm2WhpR5+Pm2I9uiZAwN5jLNKqgsVoELcQgpE1Ie+IHo9ZUG5ddnPDWEfDGGKz+KOjmo569jH9pyyS6OcreN+ITgqrrWg5/ye0jhAp7+1MOn0KOkZtMV1Y+IWEfhYhPABauDo/bLqWir2Oh7yIyLIfbySQKeTUpQ9Bv2DcW1ZNPvem89KAbOTSJhWUFDrAAXKo1dmH6bRR/ZbqqiakGpSy3/ChEU+ykA8xp/dkxyun3eAV0nP1vTbo97oGTTMN+wOEZYTjYm5yT7TVYSCQk2C0RTuNn4CqAfOt4ne+OArWqBtUXm5TG+peHtNH6bMsYPycBTiDK5jpbj0eOa2pHAyL/78zzxWxSrEk7CAIX7w9I3/e+4noCUlgarDbrbmRxYv/0167HU9FT+i0X6GZfwOnFXpYGeFJnIfiIZQSXIHHCH6xpSGULnyhoLutomnaUSlMIE3tI67O78/m7wtx4t/zEpzlXQKvc5XMiAb9pExOvjTQSszp8P1hiXfQWLxFq/7AIg5LGzbgDTYZEI/pLuoK18+Yw+gZgpn5SNs8KISsJuru17U/t62LTyHO+DNRuhZrJCDoFPr2xXEZbTmPu06xgPvaAvyMe1IJv3KuZvvw3nuSa7ci4u3v/VUygVtTRlWw5QihWXcbUwtlOi/vv4+wLImt4K2Utpgqknvc9V4lPF1ZNsRcE0cISysz44Z9SymSbTfvTAXFmKqKBF8R/ubGVMG3/eH
 khY3PBz1
 zZPSKe73TaIzd5w2+yDOa6RwKq2DUiU2QS1KRqkDNL3QlyOZKHIU79l1Sfmq2+kXAW8mSPS1aBNEPSMgMVGzIH1JZbF2yftb8ViCkuAFzy/PL7alaaeXFAGMDmlgKZeUfaD8XByJsGZQYtZyiFTyLypoqzVu80svqHWXoNzyufL4fTbWSc53DqTlRLTaPdK6+tbI8p0FsBVHIkkvrchZazpaIcZVZMumjzsEoAdYroknt02McLCgUm+z96MiZCp77Q611eR1UFu7kroxkbEwd9e/jQ1jWHi753gpi00XsChs/ljWE8sGH6TjhXvByjUKGQIGPsDTZpyoTtr3Qlhp+8YqIgxmdpxv0eXMuMNCx2nRrHxl6PM35ilO7w5/8qAmIFp4ZXr13wFyha/7n7I4rObflCdhbRJtwYJL+QdTKCFEzBD8KspxFt2INF+U4kyokFQZyIx2WiN/z6wkGOHsCmP0YcMHF5ldJQDhHv7CcL9f4QYdTmNTNVO8yww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Just fix it.

Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
---
 mm/damon/sysfs.c  | 2 +-
 mm/gup.c          | 2 +-
 mm/kmsan/core.c   | 2 +-
 mm/ksm.c          | 2 +-
 mm/memory-tiers.c | 2 +-
 mm/memory.c       | 4 ++--
 mm/secretmem.c    | 2 +-
 mm/slab_common.c  | 2 +-
 mm/slub.c         | 2 +-
 mm/swapfile.c     | 2 +-
 mm/userfaultfd.c  | 2 +-
 mm/vma.c          | 4 ++--
 12 files changed, 14 insertions(+), 14 deletions(-)

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


