Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C28A1C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD516B0172; Wed, 29 Jul 2026 10:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4006B0174; Wed, 29 Jul 2026 10:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA4D6B0175; Wed, 29 Jul 2026 10:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB4BB6B0172
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A8F0A1B51
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:06 +0000 (UTC)
X-FDA: 85042116852.20.289303B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A55FC180002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MhapCwHx;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337024;
	b=hSR4uOCoGW7T7dWH/BxUM5KJQpLw4N3JJhrR1dBpoMWLZkXDMrvj8x6JEeoMpm+c6In6f0
	fpR4pIXlAK9SN+sWXT6SMfRb6ndhD4YCfc+eHUJnnTU6LjAjLU9rL5f7vCtWZnFzuV/4JU
	t6eI53CKsOlh2JcuSC6FxVqKtXAaeks=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MhapCwHx;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+Xn6VUZ6Kfhz9bczNUgILfyECyV5wQxLhcebZe0lTI=;
	b=Li6FI+ZbEwl0MmyXCdDc48d7FfsesFcgSHq4KS2iLU0iSbzHXsEwZ+nKOQZi8BGMzdU8mS
	NZjvXamHT2c8f4CwfgMNm44OB1ghQIjHLiQRzYeaVCUaV01h0obV2Rwi+wIRipkaAAkObS
	0Yqtk6XRPS0l9GT5duWFSoAOsTCnavM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06FCF403F9;
	Wed, 29 Jul 2026 14:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914191F00A3D;
	Wed, 29 Jul 2026 14:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337023;
	bh=I+Xn6VUZ6Kfhz9bczNUgILfyECyV5wQxLhcebZe0lTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhapCwHxv0nH0JF6WE9AvGsKtFs+Ve7AZ8iiXOz1JqMBlRKafTdn6sI9FtGuADKY2
	 uoDVXNdZGMzHnQPkUFtMKNZA8KVV7vaKEgwIEgeYgqmuSCN/1gHe0EgopuBveuciYY
	 Ucz8JYAeRsaYrXlVMreGY+VqgWnMTbWLjxzKf57I8vV/eiFCk7v0iL+ebPm830lSHz
	 LfRZjUaVsj3rm3/4v/PvuTlNATW/PWc8QpBu1+5XWHWJ+2IrmHBubbAt50g7T+rzjI
	 Gh0BieGHO3VyOqgHUl+gTFrv0yJw0I9W+LXFmsbDgYbPtTx4LJVTuMzC1B6/ove/0i
	 lWkWItaSe5bOg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 16/22] mm/mm_init: simplify deferred_free_pages() migratetype init
Date: Wed, 29 Jul 2026 16:56:01 +0200
Message-ID: <20260729145610.2827231-17-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ohtqbhi7985orfgh85i8u7941ei1i5x7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A55FC180002
X-Rspam-User: 
X-HE-Tag: 1785337024-70318
X-HE-Meta: U2FsdGVkX19kdVwTH1PqdnwUTTS3iPVJl2cUbMj/QAK4EiJf96kP1BArz5P+KUibsRncWA7AjHTAEPD5yf24Lv+W0h3W3zeDohkNO+BpPcE7sHtZf1fbjZ82xFaoPAY5UL/4Sj1ddtMJp6zbuxRpeRfMKIXLlboIoaVE961/faffiBwUUTu0cDc0eCNPvMYgw2DC0jCswa1i0Sc71x+22tja33rYdLbtjFTMbgxSNuGSZCTinwpXOGKu2LlGPH2ZZHb89Fk7kyKtnvDgiv+aZU64UVzi+WM4yqVA4KPZwduFMc5vl3NK8jjq7UDLPWtT3rCZnlGIeWiUCXj116oHmJ5XNuaTpZcSslX+MohSsml8IP7LOKIRiUR5RMjJyye2kXUCt3d8niB2WOkMYnTQX6piUIfxY7oAYqS9nT25bqgMlaRUs5JlYv63l3vfOhwTEL6Jh9xJNiescOiUEYzhC9N0rt/y0rrz69Utpm/5sMNQ4pygU4teGO45/7mr1Fd04iQJ8fv+geMv35s/R/+z2ltZCfy4ih+zlRF38episn8bwFOqe2ARK+t1M35DGGQFYKY6Sr+WlAVk/EBG/xqCfLFweVs+fvYOV4VCTRHXnpSF91r9zdNFIIXjBVzWhm2SPGP3/T8xQmz/vNqiU9J9aZP+nGv3mJaHDm3APMLg2PdEa/gGVghuS80GcYS4GMINf45B9qKblzQovIJxwxu5+WdKDlt2A4Kelpjs8+MN3e1wv5hDtSKspLtr8AjhRqVo4WGNMSIMJuQDPp9uQTuQP4HisanDoiImkPF/1czFf13in7CAhI2Ta+scZ1m9X+xLxAq+TkKJcPghvPVvlHnJvW4rTq5RwTVnic/UGRuJTsPpGt3A6zxrkcd4RIBB+GZliqZv9lzTFiSgODeqgPHxtx+bw+HMt+5lKGWTxWcWWyrIm7+5bp1W+qZVEgl5PK/LoZ/RVplFv4PGDJP2O7B
 Q36TQ3xZ
 utKc/PcE26vIow5r+7RMODpeLDCEcSipthi8iqSXhwjmxD1LX8M9KGCpIwRKg4H38cBn2xDUDdI4bYNuxCwdIcq7ktCrdvaA4PFKHi92zhEAXmUV07E6goGU6S7Enyy+3ZCYFGuSm/aGGg11Gyt5OKXwsP8xggPw8470LCO5oLjLcN2pJEzs2wO+lfJXsGdqtXI/4EoPEC6jt/foGGIWN6oeB1m5/h3FYP4kQ5EV9ZaNxCnpSvtxMi3HXVnwKrSPP8A1jZ1fppllhWwU0jKxCg6hFNduQVaKdQPYxaGwXwqwArTTanlWpGGWi2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

deferred_free_pages() open-codes two loops to initialize the pageblock
migratetype for a range of pages.

Replace them with pageblock_migratetype_init_range() to remove the
duplication and make the code clearer (Note that deferred_free_pages() may
be called from atomic context).

Link: https://lore.kernel.org/20260612035903.2468601-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    This patch is taken from Muchun's series [0]. The patch as of today is
    in mm-unstable.
    
    [0] https://lore.kernel.org/linux-mm/20260612035903.2468601-6-songmuchun@bytedance.com/

 mm/mm_init.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 84d4b1c997bc..30355effe1f2 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,15 +674,15 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_ZONE_DEVICE
+#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype)
+		unsigned long nr_pages, int migratetype, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
 }
@@ -1142,7 +1142,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1981,12 +1981,12 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
+	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -1994,11 +1994,8 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, mt, false);
-		__free_pages_core(page, 0, MEMINIT_EARLY);
-	}
+	for (i = 0; i < nr_pages; i++)
+		__free_pages_core(page + i, 0, MEMINIT_EARLY);
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
-- 
2.55.0.508.g3f0d502094-goog


