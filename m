Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D647CC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6B96B0096; Sun, 12 Jul 2026 11:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681896B009D; Sun, 12 Jul 2026 11:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5206C6B009B; Sun, 12 Jul 2026 11:45:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 257DB6B0096
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 922791A0968
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:28 +0000 (UTC)
X-FDA: 84980549136.13.86E1C90
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id DC5B7C0003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cEKiuZFC;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZHBBH+ENtj6q7i5GiJzA/uzY8S0pYXEvHqndwIIRnQ=;
	b=wKXmlDjfBRorLKxQTId0UWQMANaDDH5gZ8Oq1C/eN+u7E2FEH7Fbvfio2OXleta3iYom5/
	W5jFUKLawZRgOElyyP2OPbEJGynkanVEoOi1nAv/GpOW95ibngRBhOVEpyj6IvfmLaN6DO
	3dBE8PTy0pAKPbQD0VBC8rNLb8RMU/Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cEKiuZFC;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871126;
	b=zMUuGVpiYcNHMoMz1fwDJvnf9cWMMiWfBH554o0nofLFnUxobKhIAshIUr7UbAYNKL32gQ
	tcXccWTs2j+dCvzl2fxen2obhyXoVut1F97sOloB1HJ6zeSAoA7f6F8AkPkuM+N9suTo26
	mXdphrbKjiGp0KtSfE5PCW/whKBgTFw=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e602d2c0fso211811885a.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871126; x=1784475926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WZHBBH+ENtj6q7i5GiJzA/uzY8S0pYXEvHqndwIIRnQ=;
        b=cEKiuZFCuFhNPQLuvy5YprillsbLlQsmloqbw2/qkpFxStf08JiQB07wer4X+aUFRt
         0BK6urh+HTAePh+/D3CgwqFWsDoS7RayrwSsNvS7vp9OlfMfZXQfwb13zJ+iKSngHQsV
         SkZJs+klhn+JuuGYetDJ+8KlrmrVOdwO+wYQbAzM5oAsbxQX4qiP0cP607dsCZYNvgxV
         Jo/fg78jru97snIrwlEQ/Lc/pUYugvpqoK3BIqhFVZ1lacuwtIhGIj7mp9KwUoS+kAUY
         HUjp19lEyjV3tVQ1Bged8mAeRb0NEA6m8+xc70Qy43BkEfXiwBIvG3y5hAuk6IMRDeo3
         zj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871126; x=1784475926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WZHBBH+ENtj6q7i5GiJzA/uzY8S0pYXEvHqndwIIRnQ=;
        b=VXDJTwVRGn7fvfm6uP21RgqAjpZWj7Q2ziRTUBa+lNl4ruDHrt1P+NkH0rIlYNspgB
         ZwXIOgxyWFkQuOr++jAQBnoL71OHV0LRyOD217KBTV8jWFi+TS7Fh7veDFPHS6RItceK
         p92+7BOuUuFTk5GuH7YJeOKseAEK6HxGfE6JisKeoXtqQjjChehtLbVIMXAoq8Uy/Hnk
         AeRXjW/BgrlHlk2L65kYUWSaOj3MIyfSkC8NGi2u22P46ljT9JO308YNLhFy9g/AfVo1
         DGswzBMVpb8Ye46wDS53/CJiB0OVd77GZHL7tln2TVVGXyrY8Xc4Xj4c2GWCm5CX3/j4
         +egQ==
X-Gm-Message-State: AOJu0YwewONNbkIWXzl3MsyGilPLFS62TspWjDndvn0q3sf/uZlaVIV+
	RXQ3xT05P5xiG7nW1vge0TXrB1DspiLae37q7w9xNeJnR54GhCHzZg32K0xA0lAn04AXy8nkRu5
	MSoDb
X-Gm-Gg: AfdE7cmMoQE/BXujHtWmLovungU6pxWjbdurLGf2QfMFiuRp/NexLDB2zrzbnJuyoE7
	EpEkoYkP8/JceES3TiIeMqGd7j4joE4nH/KDH2UMQqqsTgaSFSIqZfmDQ10qMOzdmP6eIUoTat2
	4XwBZ0CSAass7IM25FhZAOvNfpvXX0xL+Qgaz4Lkv1p1imNzqbxUgiHFoLVEr80xnYc91g0VVYS
	ZACGzngpokp/iKHxbazNG0CuF59ZqTChe6ZjCocf8s+RwdwzteOIxSUP9KvZ7mSx7ieNhTLFHmd
	b86LADhkO4rE1vcpufPkksdTk/F662hg7z0XlspGEv0+2wn/r7i4Mvw41IYEN+9u0AVdZXwdll+
	T2t7j1rPTj9HcCtc6lVxRQGclzJJVV05EL4rnRrNqQaWPU1e85BTlBdUTJVF2TqdeCE9z21IDLK
	YxBCyehh8AIwoBgRHx1AgS06IlHNwCPug7sVwLzMvgi+ktiGhKdy9UMddAgmv37Kb+euGvCeaYI
	UV8JRgl/y06
X-Received: by 2002:a05:620a:6017:b0:92e:c0ac:aeb4 with SMTP id af79cd13be357-92ef4109ce0mr592095785a.38.1783871126035;
        Sun, 12 Jul 2026 08:45:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:25 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net
Subject: [PATCH v7 06/10] mm/memory_hotplug: add offline_and_remove_memory_ranges()
Date: Sun, 12 Jul 2026 11:45:00 -0400
Message-ID: <20260712154505.3564379-7-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zaxn18e4k4kog1ra7j9m858fupo5yq9b
X-Rspamd-Queue-Id: DC5B7C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783871126-635985
X-HE-Meta: U2FsdGVkX1+pfZoQ5I6KHmlcOVUvvOTWj07MqP9VuwikZ3F87nDBdHWNYDYxDQzos6g0QqfzxbsOCP5IOpCwi8ETgFCB1OmKNekcsBLUKT8xOFym/V7D1M+hdMZW9j0f0gnrcgqcBKQYJnMQWRA09v8+I1LsqelntGmzTztm85N6BHyU/RcDHBlfIwafRomCcFNQSU3bO0dWPQS52UxISmG4++bq6PbnSpK+trzK9iIyVbluzXVfRlXI0FxIf39PhRhBhrVWHk5chg7dTeLq7UBciojVf+P1EVhk/eP/aGvXxEg/l7HP96e9uECn4qoHbIOFHxQuwDV2i4cODuOP4l7KKAKFb4mZK9eXwmJbQT6K+3UstPIK6RQpuh1OYqc1o6tRxcFfN7r+s+crwe1aOY3OV/uejyPZJA/gBemhKSWvyDkAWl8jhRi1iDBltDJH4HNXU6ZFQrvzzfVVQ1iKqKHSOKfXb18P4aD1PFiJvLAvYQTb2UuXTroAz7TrkXlKSigFbLTUWuf5MxID5MqXgIpYRGzTzxlxIuGtsFYKSVaQiS035oUFiDRcEBh2yk93vfaZNEfisnr3Fsb+dxHQ0ZobeXtYf+kYpVFLCvZ/30OjSrudE7Hs2lBzrqrgxxiHqDI5cOeL22M3JWsP3/hCMoUXnhMtVE8a4FIbu/WvVt/DUrquTjNabq/v2GOvwMoUk7mxXB7RB1Bb62JnoRjx4eVMSMGLj4Zm8Y7yYlTZ6P/AWSnb6OOq1wULYOMGuINYCJ2WePN+L+ZIwTVWe1Al8zuXgVW+ICquzmy3cU51iL68P0r07WAXjdO0VFg8kxpikhRJxc3QKr/MukUhMeeHKqY/U4o++FjnQlWSQZthhAAC1+Ke4i/XlCfOWB2dSZhTKtnk6Iq+ejmmKxoY4VSKmvVi0F9QV/icbOWefjgbRU7Kf3fjJ8/DBwAp7L+oXLr/ZLIgX8A89/GY4xJqrr9
 qctV7wu2
 emRJWVmNXI8+6OUw4g8U1co2pDm9SaffPcI+EbUNeNZb4/v2JTy0WbgN5L2BdBvlqs7jmG9T6muHEdl8tb6LfddNg5LU35ffu9MJ8JrYOhkehqSW9cdMzE9O4KfDvm9H7uvyN2s0EE5CpKwwLYuYzyLy9SJfUdf99xcc7H1hJWQpfawut8dhmZ8l3vBP6iIzryjPSvn1cPqqfTI1wgdhyj4xKmH0ybOa1+Nru2l41SjbD5dbTF0XLMZqagOGei7Ed0Skp/N1L/3Ykc0PvYFWUkkvAgrEmf//hyCI8WtQrqH5xG1KjwXbszh1Wi0R29c/b6vqZ30HfhYBweRUfhuvTYHXxwTOJT3zJre4zXFToXZNcV9B7CY2ThxOusryVa4GKyGvEQJACjxq/JQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

offline_and_remove_memory() handles a single contiguous range.

Callers that manage a device composed of several ranges (dax/kmem)
currently have to call it in a loop, which gives up atomicity.

In addition to pushing rollback logic into the driver, the lack
of atomicity creates a race condition between system daemons trying
to manage the same resource:

   - Manager 1:  Offlines memory blocks.    Removes device.
                                        ^^^^
   - Manager 2:  Detects offline memory blocks, re-onlines them.

Add offline_and_remove_memory_ranges(), which takes an array of ranges
and processes them as one operation under a single lock_device_hotplug():

  - Phase 1 offlines every block of every range.
  - Phase 2 removes the ranges only if all ranges are offline.
  - If any offline fails, the whole operation is reverted.

This gives callers all-or-nothing semantics for the offline step, so a
failed or interrupted unplug leaves the device in a consistent state.

This also resolves the battling managers race - the second manager's
operation simply fails when the block is destroyed / cannot be onlined.

offline_and_remove_memory() becomes a thin wrapper that passes its single
range to the new helper, so the offline/rollback logic lives in one place.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  8 +++
 mm/memory_hotplug.c            | 94 ++++++++++++++++++++++++----------
 2 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 593e42c221ada..645d781b36a6a 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -268,6 +268,8 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
+int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges);
 
 #else
 static inline void try_offline_node(int nid) {}
@@ -284,6 +286,12 @@ static inline int remove_memory(u64 start, u64 size)
 }
 
 static inline void __remove_memory(u64 start, u64 size) {}
+
+static inline int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges)
+{
+	return -EBUSY;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index aaee8470eb2ad..8bfcaa9517bf3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2430,58 +2430,98 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
  */
 int offline_and_remove_memory(u64 start, u64 size)
 {
-	const unsigned long mb_count = size / memory_block_size_bytes();
+	struct range range = {
+		.start = start,
+		.end = start + size - 1,
+	};
+
+	return offline_and_remove_memory_ranges(&range, 1);
+}
+EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+
+/**
+ * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
+ * @ranges: array of physical address ranges to offline and remove
+ * @nr_ranges: number of entries in @ranges
+ *
+ * Offline and remove several memory ranges as one operation, serialized
+ * against other hotplug operations by a single lock_device_hotplug().
+ *
+ * This offlines all ranges before removing any of them.  If offlining any
+ * range fails, the entire process is reverted and nothing is removed.
+ * This provides a fully atomic semantic for unplugging an entire device.
+ *
+ * Each range must be memory-block aligned in start and size.
+ *
+ * Return: 0 on success, negative errno on failure (never positive).  On
+ * failure no range has been removed.
+ */
+int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges)
+{
+	unsigned long mb_count = 0;
 	uint8_t *online_types, *tmp;
-	int rc;
+	unsigned int i;
+	int rc = 0;
 
-	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
-	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+	if (!ranges || !nr_ranges)
 		return -EINVAL;
 
+	for (i = 0; i < nr_ranges; i++) {
+		const u64 start = ranges[i].start;
+		const u64 size = range_len(&ranges[i]);
+
+		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
+		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+			return -EINVAL;
+		mb_count += size / memory_block_size_bytes();
+	}
+
 	/*
-	 * We'll remember the old online type of each memory block, so we can
-	 * try to revert whatever we did when offlining one memory block fails
-	 * after offlining some others succeeded.
+	 * Remember the old online type of every memory block across all ranges,
+	 * so we can revert if offlining a later block fails.  All entries start
+	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
 	 */
 	online_types = kmalloc_array(mb_count, sizeof(*online_types),
 				     GFP_KERNEL);
 	if (!online_types)
 		return -ENOMEM;
-	/*
-	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
-	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
-	 * try_reonline_memory_block().
-	 */
 	memset(online_types, MMOP_OFFLINE, mb_count);
 
 	lock_device_hotplug();
 
-	tmp = online_types;
-	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
-
 	/*
-	 * In case we succeeded to offline all memory, remove it.
-	 * This cannot fail as it cannot get onlined in the meantime.
+	 * Phase 1: offline every block in every range.  An already-offline
+	 * block folds to success, so out-of-band offlining never blocks unplug.
 	 */
-	if (!rc) {
-		rc = try_remove_memory(start, size);
+	tmp = online_types;
+	for (i = 0; i < nr_ranges; i++) {
+		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
+					&tmp, try_offline_memory_block);
 		if (rc)
-			pr_err("%s: Failed to remove memory: %d", __func__, rc);
+			break;
 	}
 
-	/*
-	 * Rollback what we did. While memory onlining might theoretically fail
-	 * (nacked by a notifier), it barely ever happens.
-	 */
+	/* If any failure occurred at all, rollback any changes and bail */
 	if (rc) {
 		tmp = online_types;
-		walk_memory_blocks(start, size, &tmp,
-				   try_reonline_memory_block);
+		for (i = 0; i < nr_ranges; i++)
+			walk_memory_blocks(ranges[i].start,
+					   range_len(&ranges[i]), &tmp,
+					   try_reonline_memory_block);
+		goto out_unlock;
 	}
+
+	/* Phase 2: Remove. This should never fail holding the hotplug lock */
+	for (i = 0; i < nr_ranges; i++)
+		WARN_ON_ONCE(try_remove_memory(ranges[i].start,
+					       range_len(&ranges[i])));
+
+out_unlock:
 	unlock_device_hotplug();
 
 	kfree(online_types);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-- 
2.53.0-Meta


