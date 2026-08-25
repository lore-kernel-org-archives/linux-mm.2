Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 354DAC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3D66B009D; Tue, 25 Aug 2026 11:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B6B6B009E; Tue, 25 Aug 2026 11:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0D56B009F; Tue, 25 Aug 2026 11:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF2786B009D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:32:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1599D160460
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:54 +0000 (UTC)
X-FDA: 85140184668.19.8D4A820
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4523880014
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JCxQIlqx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1juMVOhJOgcK/kg6XX4IK6P14Ov4AD2HCrXjeUjkxQU=;
	b=BT0lkW27X7DmP+S3BzkFmWXQXIcv0BP1b5+Bep8RdRPEhL6r7KgysHvDTh+NaUMSTCi5o1
	SYFfFbIEiZnwNihKnO2UcpUd8w9Bw+jUk5Nn164mF+C18rc0MfFdTR4DyLeAhf1tLI+XMQ
	njhntBR5QQBtKx73asR9jGdwwKub2Ec=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JCxQIlqx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671972;
	b=WJ86Ms7FfIDD/+h14rvRULhApYTOcqZqdWG3wxp91GibPMzb5X9Uw1tYSv4EB7BWUpb1bZ
	twig9YHXDHG3qWz9ZMAtwCSMA0v+1XV8L0CrdH4GrYoVMpVi86gpspODnpM0i6Eh4urZbo
	/ZRZ4Gdq5QIYwzy6ipIdz4EIrtGpXCo=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9f69ee6f4so6339857a34.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671971; x=1788276771; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1juMVOhJOgcK/kg6XX4IK6P14Ov4AD2HCrXjeUjkxQU=;
        b=JCxQIlqxqplVgpo1rEoO8iDzHhYE8Me2P3dM6GCHlePx8MzarY4Adm4KqcFSNNPsKe
         K+9icvod8qJ1BetqYoA6sDOYyioxr1kCHiwXIZpkknps1bSDX0nCVKEljY+CIB55vSTI
         hbnRR6J9aGeDrKzRf14yz570ITluZJUJZW6QgohhOWdbMWS1uLa77a+wvglGZNORX34u
         NJVGbhzCfWYtktN8bMG9Rfh6Gx50nSzfYgsNwuzd8+RTDENxFwFgWbArjv4BYKmYnOOt
         hFBwS8v4LFFP8FNXkGZEsQz0W+wudVnfmjIQger1Poc6fSns58ZykRJvhMIZZaESdEQa
         0F9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671971; x=1788276771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1juMVOhJOgcK/kg6XX4IK6P14Ov4AD2HCrXjeUjkxQU=;
        b=lxXmRYi/LYa2ZaFi5kxzacCXZ/CQxarLYcTJAX5Rl8y3t59LLP9ESqqzioCiQT+yP4
         2hk3OGCKpt8Ig04zVe3GhhF6cD3pl4c3r/Y3PIXLDi+t0hl4LWYZC0yVBn1p125/l9qh
         vxLBCLE5XaN02HaPnXuEJlklAcHUdgubGSnik46P6F9QoHlZUD7wB5Iwo40dryv+UWnj
         55yN7quA7gNWhLfsE0kKy7d2KtwkyoheVCXTXmMTWLlL4+Y8Zp359vgiM5YXfriLdP7u
         JmCy+XkbbMXXhDPVRODXSA1bCf/qyZI+LyUDyWdxjTjmzi/GwCt+we5SQRo7vhQashfY
         wK3w==
X-Forwarded-Encrypted: i=1; AHgh+RqinE4C9MSefzDPQBLKE2esqY9yrPc1WyxRzdGRQmXyYmsS538mBzRlz2B/r7vTZke8889Qlu6fZg==@kvack.org
X-Gm-Message-State: AFuF++mP6ckohdn7i7sSfleQkogfGf/UPYN1GPx3lK2kTDhmxVJGB8fN
	Hu6Zs3cfaYqPn5GVlOntwzCPvvx7o1mYT33ujpEFpyJiHz5bl7bnDuZB
X-Gm-Gg: AR+sD12fmMSNqoSF2525Oa86MRa/5HamJQjcXsokS7qXHnTmccNfY7/yr3tDeJTBm77
	i/DonqU0smXI6LyCf4Wzmp8ZLsJJg42l7Wr7/DroJcvs5rnChSjY45/6eKfqBTwV8O4OrvNO+aN
	2XEo0bVgqmJFTsZO4B3UpWI9VTWkylpi2Au9un4n6VLdINeBYEfUYN974cdEHp8G1EQlGlCjdMj
	MhQTL5KtE8A8tEp1aY2441l0+pAhIpwHdQYsoC+QzHEG3a6ZUVKS2pBrRQJIRiscB1wQ41koUaW
	k4UchRgvzg2hBlq24dBIb0WNNeieqknUboZeCP6nencdtjQIwb3RgBeMpW4HWkb+9tAp++7N+ip
	3CAaIx5nXMK9lu9Sl60vWLcYQke0szj1H40iIruI9C3Ta/sdpQsS33GJd4sNCxR9GWzU2TQCTgs
	w42i4jA4fsGgNNf/ZzswN2UkUpZoayyYHqm8ArVR/b2LWSAMcFUWWb8nerpsMn0OcP7KKeW5+PI
	HcolsKagY4=
X-Received: by 2002:a05:6830:448f:b0:7eb:3af8:8c1a with SMTP id 46e09a7af769-7f4af99833dmr6541276a34.9.1787671971139;
        Tue, 25 Aug 2026 08:32:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fc4f427sm6969227a34.16.2026.08.25.08.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:50 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 06/11] mm, swap: write back vswap zswap entries to physical swap
Date: Tue, 25 Aug 2026 08:32:32 -0700
Message-ID: <20260825153238.2695446-7-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4523880014
X-Stat-Signature: 9bobjg99umy3y1getbo8gouhwyrbpjcb
X-Rspam-User: 
X-HE-Tag: 1787671972-487524
X-HE-Meta: U2FsdGVkX1+Lyv59CoedYWgQMzE1Z4/Kia9YVd83vN+XPuQ6xO34oIitDAT/dOh+PdeEw4OTqd6xG1+Vo+QRPxRab/VaeOECZEpkaGtfVYWvYOrb4E5oe1PnaokYjxCzEYHyx+owBZlBxOAPRqn8rXn9Kh3DYFCrwmJdfmyU9UF2l1YCetKO4eLcwLYMwvcbQbBNkQSOhZsCoXUNbRJ8WZv6GyAOiri/JwZ0DDP936n5z77gn4zAeqv6Jyh6Z2WAOme5fGQQZKj6cLCe9rny1QTFmplTJrCZIZLOm12NIde6DK4F3NUHg+AzK6l+dt0PZ7qRjx92I+TLeBTrgBbby2nIhBsE2L5IqhW6Gr/pROLhC7lrZxuDvI+RwZH3VPM8aJHIeNKIn2lxaw7oxiwIFJuOCvPDlGVlGWB3nnz9OrXk2Xn51CPOzBvv8TYQgMHQy1BHog5BSwTjKQh83yRecyIfeND40sLIK9NpmMgMsuqrrAm8Fq8hxA14qa+HS/dIuvHhIfQlMJoT8iQTs3MysFHo4zhIlPFZWTMFvRNp4U1rOsPtTfUyoPdeXQlIHoVtNGpIAO5QPQ+zxyI6BfxkXP/KjZy+vmMBcO1CyA5NuJbQSGytIMPYQ4EyLCAcsxs+YHTYsKXpyxwGEU4jGdNxepi5QaVZf07Das0r6ah1H+cnVMhmmYPhzn024KNKyR7hX3qr4Q+ejNm7Hayjg9ZwGf9qmcf7mzIfqViVDj5vRK4wIUswLd4vy4VmuV8EuDp6eyvz1QEk6Orj1ZU8J9KC0rB3U72SYuBH8ajdvEBDmqPAye0qfhimiC1Vr7b1vCBeq1uM3U6w1qYK02Q6vk9pK8H/U9G5lszhoVqwlz1T0Yf81S+YjnrmUAIG5qfVGaGZxyeiz+x893Pm/KSUJoF7jE53fuMm3ec5NYBLn2ciVYB7gA3rcryT99xqfDeTKCe9y2FEhd1STBwAox7N75n
 EZgWGJUB
 qyEGcof2sbKZrbaovpm5wcAoUwUiZed+nY9YALWxDzAZSrNCQkadbHituZOVUujiiBy+MarfoJDN0KSSiZJxub6D3ijc3RKtYdyONEAA61+/3hH9NcwJwUEF7DenCbaa2iSFibb4RJW9z2BpH5KQtlmw7yCAIPVxl9JnbL20garSt9MA5F9HF5s2DErVAG0xqzCB6g0N3UThUxQ5FxSYEaderBt9o5NtwAUXoQlkTrqszlcR8l1CvSFcPTOLDxFJQxvNiGfWwQhmpYP76dSNPFAyLs1vPW18fto/qNqQgRqu3lpudSDCh29v8i/SWAtCGfjgDNR31miAwfUXnRz1RF9DXXeNRFiRjVAE/EWCqeIuJDQumW6nnBymWQnNGl0RgZwpXh4GpDRe6fJEZ0RxtXUXUakbgOHb0eBSG+7/uc56b2a2MuHWMcCHQ+cPI+TerA7G/uNOvf0iorC6sC/VUfq6Png==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for writing back zswap-backed vswap entries to physical
swap. The mechanism mirrors the existing zswap writeback path, except
the backing physical slot is allocated on demand at writeback time
rather than already being pinned by the PTE.

The zswap shrinker no longer skips vswap entries, unless we are out of
physical swap space.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 67 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 21 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f16c0b44b5d5..70ad8010f18a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1007,12 +1007,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
 	struct swap_io_ctx ctx = {};
+	swp_entry_t phys = {};
+	bool is_vswap;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1020,12 +1021,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
-	/* Vswap entries have no physical backing to write to. */
-	if (swap_is_vswap(si)) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
-
+	is_vswap = swap_is_vswap(si);
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1044,24 +1040,44 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/*
 	 * folio is locked, and the swapcache is now secured against
 	 * concurrent swapping to and from the slot, and concurrent
-	 * swapoff so we can safely dereference the zswap tree here.
+	 * swapoff so we can safely dereference the zswap tree (or vswap
+	 * vtable) here.
 	 * Verify that the swap entry hasn't been invalidated and recycled
 	 * behind our backs, to avoid overwriting a new swap folio with
 	 * old compressed data. Only when this is successful can the entry
 	 * be dereferenced.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
+	if (entry != zswap_entry_load(swpentry)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	if (is_vswap) {
+		/*
+		 * Allocate physical backing before decompress so a failure
+		 * wastes no work.
+		 */
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
+		/*
+		 * The phys allocation above took the entry out of the vtable.
+		 * Restore the zswap entry to the vtable, which also frees the
+		 * allocated physical swap space.
+		 */
+		if (is_vswap)
+			vswap_zswap_store(swpentry, entry);
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	if (!is_vswap)
+		xa_erase(swap_zswap_tree(swpentry), offset);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1076,7 +1092,10 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&ctx, folio, folio->swap);
+	if (is_vswap)
+		__swap_writepage(&ctx, folio, phys);
+	else
+		__swap_writepage(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
@@ -1091,6 +1110,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 /*********************************
 * shrinker functions
 **********************************/
+/*
+ * vswap zswap entries get a physical slot allocated on demand at writeback
+ * time. Skip the shrinker when none is available.
+ */
+static bool zswap_writeback_possible(void)
+{
+	return !vswap_is_enabled() || get_nr_swap_pages() > 0;
+}
+
 /*
  * The dynamic shrinker is modulated by the following factors:
  *
@@ -1228,7 +1256,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return 0;
 
 	/*
@@ -1314,7 +1342,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * were scanned but none could be written back, or -ENOENT if @memcg has
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  *
- * Also returns -ENOENT when vswap is enabled.
+ * Also returns -ENOENT when vswap is enabled and there is no physical
+ * swap to write back to.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1323,7 +1352,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return -ENOENT;
 
 	/*
@@ -1354,11 +1383,7 @@ static void shrink_worker(struct work_struct *w)
 	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
-	/*
-	 * When vswap is enabled, zswap entries are almost all vswap backed,
-	 * with no slot to write back to.
-	 */
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return;
 
 	/* Reclaim down to the accept threshold */
@@ -1439,7 +1464,7 @@ static void shrink_worker(struct work_struct *w)
 			break;
 resched:
 		cond_resched();
-	} while (zswap_total_pages() > thr);
+	} while (zswap_total_pages() > thr && zswap_writeback_possible());
 }
 
 /*********************************
-- 
2.53.0-Meta


