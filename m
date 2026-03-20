Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F641099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5486B016C; Fri, 20 Mar 2026 15:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656AC6B016E; Fri, 20 Mar 2026 15:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F64F6B016F; Fri, 20 Mar 2026 15:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8D46B016C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:28:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 072D5B6E9F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:07 +0000 (UTC)
X-FDA: 84567427014.30.DC50DD7
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3D1AAC0010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bdkNhw38;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDjzYCMXOArzX+CdGGVkkCHbdkQXDMD21rMLRVh2D6Y=;
	b=vCOo0NNJhJBRDzCDYBhaxJt18DG7qURjZmGEiaNA9TyOKGWe/ombYHIA7gNXHS0TOwM/qn
	/hjH55Jp3pXvOoaq7bAnwPcNgSuulv675Z9s797ilYcSEYkiIh7FKpgQ3UPRTxyqbzPrUp
	h2nhoxXurlaEILTRe22l3sRDxUUd9nw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bdkNhw38;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034885; a=rsa-sha256;
	cv=none;
	b=GZeBp5ASjYKqje/ApsMudxF1lU1ZqUl4nlHZWqrt838lUKCydvQLu64K1tpi0fGxlmPPQ3
	gRD7xhdyZ3BgZEB6QwkwEvgYBj9CewEiOprWCVJD5MgsPnCm6bfMCbR9mIYrg2DyDKVFkm
	wDTXVk7ClNU7SaooXHqrVkCh2dmuBZU=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d75ed779bfso1815591a34.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034884; x=1774639684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDjzYCMXOArzX+CdGGVkkCHbdkQXDMD21rMLRVh2D6Y=;
        b=bdkNhw38IkyzuvasjwlWOn+/uN/HgaHf+SkEn3WXV+xaTKO9AvBgOHl3wPlQB9ksQr
         sKF+QxtMI3zGfDtb6jF7sPeI9ae5esSIfafXbqze/zbhnrNFU0FMLREFZCRt/2fV99fy
         e/Ryhps5SvGc2h/x6Yu1/miJVECgf0ebwE1+Sv7+Y9/dOXrHyCslV3FkglmQ9hYAqDz/
         DoG/NoF3cv5+RgBxs79SM+iZ2s9eS5KSzI+UkPlDell3lMzQzCY8zn5htu5eEV74ZSCI
         tUYP9wa2APePVLvxiVolQrewE//fleYjpjAFLQQ3hVZ2KZ/wQq9Vi3NHKhoePjirMZ7u
         9FqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034884; x=1774639684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EDjzYCMXOArzX+CdGGVkkCHbdkQXDMD21rMLRVh2D6Y=;
        b=D5SrX+5VfJeYJirWCMQe1JefdLm3Szmsf/vBT62UMCvpYQCDq45mhig7RMiEmFGHwj
         tgTrWfxDLCG02Wtvcr5hnsqZvUGkgy5IlBdc87ozdZYFFI8bcvGlkHGwJwUh30fmhv2s
         KZyliX5pO9OLi2TomF0jmab4XqLCA3cLC5iSjJWQI1JPQ5tOoITv0UVgvnnsHB9aAxyK
         h2orHyse1Zi9imaZ5nL0hRRELmDuykRwX8Xe4WXSDXp3hcSlcbS45SXvKwLSrIhWq/zp
         ZRwygpMJcan3devRHx0Y30MwNssrEiiczQa+5OphKsEyOZ1PX6hrtBQXxM7J41pQzkxN
         lRvg==
X-Forwarded-Encrypted: i=1; AJvYcCVbUDjssr6noOp+TR33ISlR7AkKxUoE7u1Vy/eedMjs+yHOqSdQT/Jkd9or2o5cl90oueVN9oQk8w==@kvack.org
X-Gm-Message-State: AOJu0YzzsxMY/357GQ/YGEsW7ULhUGfdaauPHr+Hw+1NIyLtgzrXZXYd
	9eNAxKjKd3Z+LS32P30zjxG0O+HYyD/ZDBMuJUowMTQkRmDu+pPxDt25
X-Gm-Gg: ATEYQzwqoRdOt7hEFY5cxnz1mkI3xTc++xe+fWqyZG1RGs/yaXCQCr1KikzQyK5FS7G
	qItEYpHxYSThlug/b3eaodXEm49DNdVdtvFIsTgr62uk4pGFgNJ9l93toJI8TiVME3ojXT7TTKe
	OLMeVDtGeplbhTPx8pSgQnhM7FKMgFvDB/IoSu7rIYLgDLUtR6CjKsHdKJqwu3VVSFcOPZORJlc
	xbNx/nhPQnw781Z1tWr4mg0yyPn5+earQKA5Lw4J3POb2W53tlN5mvmeFQkI3VAinS6A7ShkXJA
	isqtQc8olsReLFK6LswlCuzr7QOyByXhk1AI2tBB7eS7AjjGGwPFtJOV2F5jCOYfYZZ6/tLUZY2
	uG3Dg8royN++gLakFDmw7pU85C7bXsntSoV7aqF7SejMqDqE8g7ooJMoh/FbvMoRYXmNQlAYJEO
	VDnv4sI+JhR1hUqDMtv2FjawHsQy6ijP1os/sZHCqp+eE5Jw==
X-Received: by 2002:a05:6830:82d4:b0:7d7:f90c:5833 with SMTP id 46e09a7af769-7d7f90c6a69mr1201918a34.27.1774034884181;
        Fri, 20 Mar 2026 12:28:04 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eac17471sm3081723a34.7.2026.03.20.12.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:28:03 -0700 (PDT)
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
Subject: [PATCH v5 18/21] memcg: swap: only charge physical swap slots
Date: Fri, 20 Mar 2026 12:27:32 -0700
Message-ID: <20260320192735.748051-19-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D1AAC0010
X-Stat-Signature: nco8uak4y3qhtsgmaoinr7g4g5zmra1n
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774034885-555927
X-HE-Meta: U2FsdGVkX1/fMsv4ZHitqFn8faVBz5ptS7DpKAkIcHaQx+hhUwEFFIPCya829fI7RfiVAZO4+h+s2zLZXVEwvJnkG+lmiTh9VAjhWjdtIFmySAl9gYRFY7JwuFsO6D9v+ujhcCWM3YVjJ8cG9pIaYJ/zzzGivDXMzB9FvZ+gnfrNVYfT3RsVYZ/GFX81D4whjvOP3pM2wxtvxxU/lE5rHF8TKqcChXSSA6YXoDoYnDfkyMiZ1dTRZjL+9hzU5UFgjdT3OCgr4UFVHFKSnT+GisU+4abpyQR3ZQ7RBlr9wfCFBHVok6cMrwe3htrZ/G+If7v4sKNnWZu3en6nXWTjVPNEid05KIsfqZX6lmEafQMwdA75b627KTKqNrCfFlEIyWIV3nP4RqW5x1hTEbvRbKa17O9gObPkCbPXK1uhCM8MCzATHSxipPkjswHbdq4aReJwhUFXemt76UYb5R7tlGxamqjSbAT6Syj4Ie8vgJNMvEio+z9dbnElMy8MyxIF0vFyQ8tlOguufdtNOSoeqeXmJR+XOkIMaNHP5lrJMDEOGa8fEQM97EJOVbZt6aKIxEF6i7LHcrDAsM4x9uKUXGaLKAxEN/8FR4pY+0K5NQ5T63E8cnaQ/Mi3TasuwCPPHmPV213SkY9gwp1bPmiTLOM9ZQwPYScbf48cDz1Ggy9w/ZMxwn15JIPp1DX/eExUKHE2vTjIC90KTS3SpvkFyi5OScY3Jin9Yr32nm1RhMs5x9lJlTkU9IQXZaEphtre9tR0P390AiMwzdtleVGMx2kITE9+8PbpWoc3yKnkYqtdgHwu7bunmcdpMeSQao521aeXVQIEBJn4f/Dx+K6sQ0eh+N6Rziwtdd61V3I4j9zxqLvmLSSquQaRs2fzrQ1SK4wHh5z6CJiYLevM4EEPqMc0VUFfCayaOLd7LrTyXAd0nYM/GygQ+tRZS0A+HwolH72zf+AYYIwS2HG2TFk
 ZRiFYe5l
 mn0Q8qlgglvBN46zLwIq62yxdW6PJx02+sQrSeTstSW2iZqJPCQ8Ei255rVP6AW4QG8LeEDoVcoH+Xpyq090NXaWZjULDu31bXrkpU7qIQ+3ofz70OkFRwlFN4yf0qNMDHnP9Yn281sTpDWsvcLkZ3pykQUXa7F1S9bTUnJ0JQrgOVzVFhbdPxLLIAJF3gW/pfas4BzWLNCNifY4ogLC9RBxJGHaJfyU1tIrSrlvKtCSJXsAbDKaEFfU5aF2BaxyNftHetLK2kMc7XwdQI3UlObI+o7NZKj/GHGsMxtQHB7sU5sXIcuJhSl9unhC5f0e3/I5tSFtxyAATkqa2ltfHG5MqvlR1PQmatVDkeetDHWycKTqqAamIbmooCGSWIu7JDGuoz7GFbxnMQrURVC9XHDUdIhPtcd2jmMeVajia3KrqIXIajnTkPkB8JsBG+VKs7oVPGIEldZiEb64FxGSp77GhFOSQtscbCB5C1WFGdOAbcEg8fUs+RbLKHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that zswap and the zero-filled swap page optimization no longer
takes up any physical swap space, we should not charge towards the swap
usage and limits of the memcg in these case. We will only record the
memcg id on virtual swap slot allocation, and defer physical swap
charging (i.e towards memory.swap.current) until the virtual swap slot
is backed by an actual physical swap slot (on zswap store failure
fallback or zswap writeback).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 26 ++++++++++++++
 mm/memcontrol-v1.c   |  6 ++++
 mm/memcontrol.c      | 83 ++++++++++++++++++++++++++++++++------------
 mm/vswap.c           | 39 +++++++++------------
 4 files changed, 108 insertions(+), 46 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index cc1ca4ac2946d..21e528d8d3480 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -676,6 +676,22 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
+void __mem_cgroup_record_swap(struct folio *folio, swp_entry_t entry);
+static inline void mem_cgroup_record_swap(struct folio *folio,
+		swp_entry_t entry)
+{
+	if (!mem_cgroup_disabled())
+		__mem_cgroup_record_swap(folio, entry);
+}
+
+void __mem_cgroup_clear_swap(swp_entry_t entry, unsigned int nr_pages);
+static inline void mem_cgroup_clear_swap(swp_entry_t entry,
+		unsigned int nr_pages)
+{
+	if (!mem_cgroup_disabled())
+		__mem_cgroup_clear_swap(entry, nr_pages);
+}
+
 int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 		swp_entry_t entry)
@@ -696,6 +712,16 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
+static inline void mem_cgroup_record_swap(struct folio *folio,
+					     swp_entry_t entry)
+{
+}
+
+static inline void mem_cgroup_clear_swap(swp_entry_t entry,
+					     unsigned int nr_pages)
+{
+}
+
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 					     swp_entry_t entry)
 {
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 7b010e165e1ba..12bc5c680b03a 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -680,6 +680,12 @@ void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
 		mem_cgroup_uncharge_swap(entry, nr_pages);
+
+		/*
+		 * Clear the cgroup association now to prevent double memsw
+		 * uncharging when the backends are released later.
+		 */
+		mem_cgroup_clear_swap(entry, nr_pages);
 	}
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2ba5811e7edba..4525c21754e7f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5172,6 +5172,49 @@ int __init mem_cgroup_init(void)
 }
 
 #ifdef CONFIG_SWAP
+/**
+ * __mem_cgroup_record_swap - record the folio's cgroup for the swap entries.
+ * @folio: folio being swapped out.
+ * @entry: the first swap entry in the range.
+ */
+void __mem_cgroup_record_swap(struct folio *folio, swp_entry_t entry)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct mem_cgroup *memcg;
+
+	/* Recording will be done by memcg1_swapout(). */
+	if (do_memsw_account())
+		return;
+
+	memcg = folio_memcg(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
+	if (!memcg)
+		return;
+
+	memcg = mem_cgroup_id_get_online(memcg);
+	if (nr_pages > 1)
+		mem_cgroup_id_get_many(memcg, nr_pages - 1);
+	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
+}
+
+/**
+ * __mem_cgroup_clear_swap - clear cgroup information of the swap entries.
+ * @entry: the first swap entry in the range.
+ * @nr_pages: the number of pages in the range.
+ */
+void __mem_cgroup_clear_swap(swp_entry_t entry, unsigned int nr_pages)
+{
+	unsigned short id = swap_cgroup_clear(entry, nr_pages);
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(id);
+	if (memcg)
+		mem_cgroup_id_put_many(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
@@ -5190,34 +5233,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	if (do_memsw_account())
 		return 0;
 
-	memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
-	if (!memcg)
-		return 0;
-
-	if (!entry.val) {
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		return 0;
-	}
-
-	memcg = mem_cgroup_id_get_online(memcg);
+	/*
+	 * We already record the cgroup on virtual swap allocation.
+	 * Note that the virtual swap slot holds a reference to memcg,
+	 * so this lookup should be safe.
+	 */
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(lookup_swap_cgroup_id(entry));
+	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_id_put(memcg);
 		return -ENOMEM;
 	}
 
-	/* Get references for the tail pages, too */
-	if (nr_pages > 1)
-		mem_cgroup_id_get_many(memcg, nr_pages - 1);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
-
 	return 0;
 }
 
@@ -5231,7 +5264,8 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	id = swap_cgroup_clear(entry, nr_pages);
+	id = lookup_swap_cgroup_id(entry);
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
@@ -5242,7 +5276,6 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_id_put_many(memcg, nr_pages);
 	}
 	rcu_read_unlock();
 }
@@ -5251,14 +5284,18 @@ static bool mem_cgroup_may_zswap(struct mem_cgroup *original_memcg);
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
-	long nr_swap_pages, nr_zswap_pages = 0;
+	long nr_swap_pages;
 
 	if (zswap_is_enabled() && (mem_cgroup_disabled() || do_memsw_account() ||
 				mem_cgroup_may_zswap(memcg))) {
-		nr_zswap_pages = PAGE_COUNTER_MAX;
+		/*
+		 * No need to check swap cgroup limits, since zswap is not charged
+		 * towards swap consumption.
+		 */
+		return PAGE_COUNTER_MAX;
 	}
 
-	nr_swap_pages = max_t(long, nr_zswap_pages, get_nr_swap_pages());
+	nr_swap_pages = get_nr_swap_pages();
 	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
diff --git a/mm/vswap.c b/mm/vswap.c
index 1040bb8a9f320..fa37165cb10d0 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -544,6 +544,7 @@ static void release_backing(swp_entry_t entry, int nr)
 	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
 	unsigned long flush_nr, phys_swap_start = 0, phys_swap_end = 0;
+	unsigned long phys_swap_released = 0;
 	unsigned int phys_swap_type = 0;
 	bool need_flushing_phys_swap = false;
 	swp_slot_t flush_slot;
@@ -573,6 +574,7 @@ static void release_backing(swp_entry_t entry, int nr)
 		if (desc->type == VSWAP_ZSWAP && desc->zswap_entry) {
 			zswap_entry_free(desc->zswap_entry);
 		} else if (desc->type == VSWAP_SWAPFILE) {
+			phys_swap_released++;
 			if (!phys_swap_start) {
 				/* start a new contiguous range of phys swap */
 				phys_swap_start = swp_slot_offset(desc->slot);
@@ -603,6 +605,9 @@ static void release_backing(swp_entry_t entry, int nr)
 		flush_nr = phys_swap_end - phys_swap_start;
 		swap_slot_free_nr(flush_slot, flush_nr);
 	}
+
+	if (phys_swap_released)
+		mem_cgroup_uncharge_swap(entry, phys_swap_released);
 }
 
 /*
@@ -630,7 +635,7 @@ static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
 	spin_unlock(&cluster->lock);
 
 	release_backing(entry, 1);
-	mem_cgroup_uncharge_swap(entry, 1);
+	mem_cgroup_clear_swap(entry, 1);
 
 	/* erase forward mapping and release the virtual slot for reallocation */
 	spin_lock(&cluster->lock);
@@ -645,9 +650,6 @@ static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
  */
 int folio_alloc_swap(struct folio *folio)
 {
-	struct vswap_cluster *cluster = NULL;
-	int i, nr = folio_nr_pages(folio);
-	struct swp_desc *desc;
 	swp_entry_t entry;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -657,25 +659,7 @@ int folio_alloc_swap(struct folio *folio)
 	if (!entry.val)
 		return -ENOMEM;
 
-	/*
-	 * XXX: for now, we charge towards the memory cgroup's swap limit on virtual
-	 * swap slots allocation. This will be changed soon - we will only charge on
-	 * physical swap slots allocation.
-	 */
-	if (mem_cgroup_try_charge_swap(folio, entry)) {
-		rcu_read_lock();
-		for (i = 0; i < nr; i++) {
-			desc = vswap_iter(&cluster, entry.val + i);
-			VM_WARN_ON(!desc);
-			vswap_free(cluster, desc, (swp_entry_t){ entry.val + i });
-		}
-		spin_unlock(&cluster->lock);
-		rcu_read_unlock();
-		atomic_add(nr, &vswap_alloc_reject);
-		entry.val = 0;
-		return -ENOMEM;
-	}
-
+	mem_cgroup_record_swap(folio, entry);
 	swap_cache_add_folio(folio, entry, NULL);
 
 	return 0;
@@ -717,6 +701,15 @@ bool vswap_alloc_swap_slot(struct folio *folio)
 	if (!slot.val)
 		return false;
 
+	if (mem_cgroup_try_charge_swap(folio, entry)) {
+		/*
+		 * We have not updated the backing type of the virtual swap slot.
+		 * Simply free up the physical swap slots here!
+		 */
+		swap_slot_free_nr(slot, nr);
+		return false;
+	}
+
 	/* establish the vrtual <-> physical swap slots linkages. */
 	si = __swap_slot_to_info(slot);
 	ci = swap_cluster_lock(si, swp_slot_offset(slot));
-- 
2.52.0


