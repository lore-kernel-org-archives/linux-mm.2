Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599C9D6CFDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFCF6B03ED; Fri, 23 Jan 2026 01:42:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6CD6B03EE; Fri, 23 Jan 2026 01:42:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8E26B03EF; Fri, 23 Jan 2026 01:42:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 552886B03ED
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:42:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFDA01AF766
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:42:50 +0000 (UTC)
X-FDA: 84362285700.21.1417076
Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C46F1C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:42:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eWJaYjyv;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769150569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RurLsspuwixyatIbkQyVE9ShmUOAQwG6MPVdwLrORJU=;
	b=uibxAySIQa531YdmcJJqtGbOYkTe5OvM/bs2caVnnRyG7p7ikCCydop8rmK1L2GYjRNPtN
	IzxU3kAR/pOVUwap0Ih4PnjXDkN+3aLbsS7pgWxIxjvSGtx5rCD42aHcyyrvc92XxJGlzB
	gwRHdORVG54vPbGiu6wNtHu/jlLXZZ8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eWJaYjyv;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769150569; a=rsa-sha256;
	cv=none;
	b=OnNZUjEv/rA7MCNzSF/DFhhrdnNbFQ7OJ0E+8pbYdHW3TPEvn65WMdGnSEUzw8Z+RSi42j
	aKaRooTy3oRcTNJdCs2Ks2Ji/BuMMbfzJPpsDI3pigdPzbFxQxbVvmwFuAqSbGZ8nA/wCG
	J+pTc279nioeDMiDwc6t4WJTQ1GINVo=
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-121a0bcd376so6535147c88.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769150568; x=1769755368; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RurLsspuwixyatIbkQyVE9ShmUOAQwG6MPVdwLrORJU=;
        b=eWJaYjyvhGNvYVMdXrv5G+AoF66cL5UJL2PSE/Qb+z+BDfZ2+BZNRshapuI7+D9GYu
         KHF4ylTeujz+YnIY6ZU3lxkwRxuSUI/3vghp7B8P66odXgHsY+q+Wc2GS9Sn7+Hkm1w0
         SfLYhBMbz73UE1dtnsMDj10g5lZ46HRlxtX7QuBK03lNgckYJKuztfwuGV25ZGHCPCDH
         WUVhJCT2Yq3gutJ7H5QJFJbLDt+fdUydflwD80PTBPtTLASdkcH6Uxx3Y8dgZZ+eDpTV
         e742URwNZNUPJ20VAOlfn8M/n5Vtxa9ax8AoS2ahDAZP+7qrkIjTf8NbHbozKDIL4eF4
         NdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769150568; x=1769755368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RurLsspuwixyatIbkQyVE9ShmUOAQwG6MPVdwLrORJU=;
        b=J4DEU2yXuDH+ba9Y5Vfg1ulsv+RNP+kes+QgJdvbauh9iUpGcAIlzvr9NVIkpGgPJS
         2/Ymzmnkfw1ikiJEbmm/498i+msa94sHglwA7ea/MD9+/G2a3Ju8eaHi9UY3NHhT6xOy
         0hDvcEnncHE2N8yEvjjS28oqgqzqq6oKwX5OFcVfoAazBzq99oZrbTprvLbcjVJOrglU
         Ab/Fk/1dnEZW9qrnV/oR/ieJdxWMzi4PDsxAsxkpQf9iy5uqyaPXz3YseoPQIoEE78tP
         fC51J0PDT/gOf5eHMWw4HHFql30RIK1ryjvb5JaF5oq0ysjXseostpLMSxi/L5yVIp7/
         A9cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCWScz7uKYNkzS1P0wCKot4hq5KjTX6uka78K1qTbSzKJcLa5urjHMakaD24CoHuznHA30Ol4KtA==@kvack.org
X-Gm-Message-State: AOJu0Yxo3LHRjl4L8kkgiPNc57tfZKrhJOd769oJHDsvgTrOQB4q33wX
	eC4X48cyvT+w/Jcdczb45HzrJmyHGdTZKueSJeLxsGNIv5dv4Wfcafwo
X-Gm-Gg: AZuq6aJZ/BqGW2Zp0oXVq6bk2uUeT5Iytfm54DhfKFa468b+mMuS/XlwdRHg2HaOdZ/
	CqOTBoWRQPQVPYn84UTQCDQi20+8JC32SNWX/S4Af8w/Lfmsd3UceqdrdetO+oC6oQEfiPUYP6j
	Qss3WfP8Jh+uCMd3qa2cy6eOQUI+7x1KHQAB8tvsOb0UQJe3laAnUBqb39yorAE4mwN92+OCVWi
	0U8pF6jP3RJch0fDdJqTdbzBCEaFgyP6aqsVc93nWDoSvO09/LKZ05mINiptfft2gAh5i1Pa0aM
	ow1JCOsr5wijEPG2Fh75rIC/d5fr/D/IVFW2Z/qGpXSYznmV+8epEnbYm0TcHXG57AaKhhKuRI2
	gk8nbzhVeCPqEFcSEvafY8lkcG/aZAok95xd9rr0o1aj1iWYF8VjE3Ncn6c1X28O2uHCY+lgj0W
	wQMYk=
X-Received: by 2002:a05:7022:102:b0:119:e56b:c74b with SMTP id a92af1059eb24-1247dbb463emr967983c88.16.1769150567825;
        Thu, 22 Jan 2026 22:42:47 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1247dba0135sm3130527c88.17.2026.01.22.22.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 22:42:47 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: vbabka@suse.cz
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	edumazet@google.com,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jis1@chinatelecom.cn,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liyi1@chinatelecom.cn,
	mhocko@suse.com,
	netdev@vger.kernel.org,
	realwujing@gmail.com,
	rppt@kernel.org,
	sunshx@chinatelecom.cn,
	surenb@google.com,
	wangh13@chinatelecom.cn,
	weixugc@google.com,
	willy@infradead.org,
	yuanql9@chinatelecom.cn,
	zhangjn11@chinatelecom.cn,
	zhangzq20@chinatelecom.cn,
	ziy@nvidia.com
Subject: [PATCH v7] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Fri, 23 Jan 2026 01:42:30 -0500
Message-ID: <20260123064231.250767-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <dfdd0648-a7da-4e8e-8781-cf094da4844f@suse.cz>
References: <dfdd0648-a7da-4e8e-8781-cf094da4844f@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: imy5wpf4oazp8zghyhhqa7gxouuh7fod
X-Rspamd-Queue-Id: 2C46F1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769150568-757533
X-HE-Meta: U2FsdGVkX19WaG450cIpplcbTes6d8IdSRv/kZETny7NsDIhQ4G+GVXc2MpEGKg43B8SnsFyb6jYvmgrUVjCS/7+thOJ/3Bsba/98m9MhQzr1wIt01lJGohtAXlBpnq1pU0/dDN8PWB3Fu1qWbvy8k+b/JMiZTUBakmTQ4gX6ZJCOmjScEnc/93T1I8SIEv21ydnNftVCQKxXZNRbWX7JGByJ0PEKzPAj0Ffaac5gdIxkaJTEHclgM0MT54gQ3G0V0SdS3E4sor2QPSJJucDdlGcRh416O6VCA51XntMAoXwiU5BEmoyhxM3ng4z2reJeFhTafkTnj4iZsIN/9d1fctloiog/HeUxK9lr+aYRm8qqhjlWGgf+ktNuedBHZKVtRDDi4D1f/NcugaL7W+v9A/NEw2wM7/HbBzp8zTxuiGZkEC3SWTYQnV8bTW7hrCIM5RhmDVRIuFI4htaFdGAlvWYLU1xJbO6G1iXfCqe7EHFdwomr/6XHT22iPewRon0LfgaIH7ylnVePdO1GZ1ilVFsnZzjYuPmiYjoBkTcKcZju9ceK/KNZiFmB1WwMViJjNBL+Rva4C76fxs3evv9ueFaYtWmo3hwnNnZuFs3kzvDHjtBTPeO7IXPMajRSZnePHwqD2zOFJOaIGCblmUSQkdLAaZ8xHbfWxKkWWDC7prYpkNLq5rtukf7lrdwP03lofAOZve28772fdutESSWPk/ombd40K5VJK5pygwdP+M8IZUVjbJiIC3O0nwKEthf84Vp01kSZFLlaYBXrIT7OQxfJJ9mSx6UxAVm5CBFYcVw8GWaNrVIl9ICejf+5F21fk+Nae0QEO7DcqeWe1tkK9fooGHhcxqdSsNkLKnNbrsX3dIwOyri+ZSqL8uSnG5e64OCRvfWRx4Fnp9+prnER2qrkA6cQRHz4c3uqu0+bG6ML0p4eV04TK1qfGR5R9Jg+c1B/nbL8BtVO8aMfip
 fRLYWURo
 sUfP5wreIrMKn8UNlbn1aMNUOpMt6IDqFHbq+NjZMs88MsyO+/paVz8G8ezIWKcSJPSQVehH7Q0G/OKaT3Ngp4tYPGIlxyOe3UysZYK5bG4Kff4jGolwS8CwI706jWl3hllq03Mk6h1rCEH9l4dLFu9tA83Cb6baRdvtJtkX+ENPIvOigmkcmaa8Ph16q6hDtXMgCI5jiKMTin2iIAU2QY+sd7mwqMwt/3oIGDHtDR12TR8QUMSWQVfMvXOqhEIdylCbLgGxJ0LfABJQD5DykpDFHMrUY8OYpZM9FoNA6jPP9ypxChJjwVFKBdTpP0AKBITbk+g8bYes9w4tRLdNXH/iVBMPBH3EMT695fRcP/n++ZerU9jtPzgBPkrO8aHk8islbVhurBUi5tBxOdv5ljz4GhxtfjZqv5cTJaVMtvEaO8zOUoYyGrr/8bikpauec2JbgSAdpxsfoDWf1mZTfD/zfo2sGY3eoQTswtDOhHBrDmOkIWp2PsfWxMRGEm9cGycxxrKJ9ZHsBybOuAkySxewePccCcFd6JuvW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim. This patch introduces a
watermark boost mechanism to mitigate this issue.

When a GFP_ATOMIC request enters the slowpath, the preferred zone's
watermark_boost is increased under zone->lock protection. This triggers
kswapd to proactively reclaim memory, creating a safety buffer for
future atomic allocations. A 1-second debounce timer prevents excessive
boosts during traffic bursts.

This approach reuses existing watermark_boost infrastructure with
minimal overhead and proper locking to ensure thread safety.

Allocation failure logs:
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
v7:
  - Use local variable for boost_amount to improve code readability
  - Add zone->lock protection in boost_zones_for_atomic()
  - Add lockdep assertion in boost_watermark() to prevent locking mistakes
  - Remove redundant boost call at fail label due to 1-second debounce
v6:
  - Replace magic number ">> 10" with ATOMIC_BOOST_SCALE_SHIFT define
  - Add documentation explaining 0.1% zone size boost rationale
v5:
  - Simplify to use native boost_watermark() instead of custom logic
v4:
  - Add watermark_scale_boost and gradual decay via balance_pgdat
v3:
  - Move debounce timer to per-zone; optimize zone selection
v2:
  - Add debounce logic and zone-proportional boosting
v1:
  - Initial: boost min_free_kbytes on GFP_ATOMIC failure

 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 46 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..8e37e4e6765b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -882,6 +882,7 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
 	unsigned long watermark_boost;
+	unsigned long last_boost_jiffies;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..94168571cc38 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -218,6 +218,13 @@ unsigned int pageblock_order __read_mostly;
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 
+/*
+ * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
+ * This provides zone-proportional safety buffers: ~1MB per 1GB of zone size.
+ * Larger zones under GFP_ATOMIC pressure need proportionally larger reserves.
+ */
+#define ATOMIC_BOOST_SCALE_SHIFT 10
+
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -2161,6 +2168,9 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
 static inline bool boost_watermark(struct zone *zone)
 {
 	unsigned long max_boost;
+	unsigned long boost_amount;
+
+	lockdep_assert_held(&zone->lock);
 
 	if (!watermark_boost_factor)
 		return false;
@@ -2189,12 +2199,40 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
-		max_boost);
+	boost_amount = max(pageblock_nr_pages,
+			   zone_managed_pages(zone) >> ATOMIC_BOOST_SCALE_SHIFT);
+	zone->watermark_boost = min(zone->watermark_boost + boost_amount,
+				    max_boost);
 
 	return true;
 }
 
+static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+	bool should_wake;
+
+	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+		/* Rate-limit boosts to once per second per zone */
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			zone->last_boost_jiffies = now;
+
+			/* Modify watermark under lock, wake kswapd outside */
+			spin_lock(&zone->lock);
+			should_wake = boost_watermark(zone);
+			spin_unlock(&zone->lock);
+
+			if (should_wake)
+				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+
+			/* Boost only the preferred zone */
+			break;
+		}
+	}
+}
+
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -4742,6 +4780,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Boost watermarks for atomic requests entering slowpath */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0)
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-
-- 
2.51.0


