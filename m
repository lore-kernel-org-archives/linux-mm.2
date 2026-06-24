Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC87CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3677E6B00AE; Wed, 24 Jun 2026 10:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317936B00B0; Wed, 24 Jun 2026 10:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191AF6B00B1; Wed, 24 Jun 2026 10:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBB666B00AE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:58:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4207F1403D1
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:08 +0000 (UTC)
X-FDA: 84915111456.29.B4806E3
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 70290A0003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=M7IB1aKz;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313086;
	b=qF41zy7n/MCYHAjIvxbphRjev9AWFlzJhBTtAqqLGBex9mU5CpeDKpAI0Q0yDxxjhxq5no
	WsdzH4UB6/S/DwEQzl+fM+igA2weQEgGXQNJxdf4CyewmKs52dFFkYvzWAqZAepKJdBL/u
	b5HQu4xEZJqhVNioEkwaaZoqol0oN14=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LbNsCaF8AqQRerBXt6jCH2X6FSKJPEhWXxoYu5Er/s=;
	b=8AA1IWD/p11LA4b4z6biA3+oAIYNwhHQtedEq0FEiONST/FOHGhmTPAq/EHcH5CvxSgMba
	n4xFeNZ+XY2kfQlDHVSA9/oRRPDNm+gkd7gMR8ET4xnrvKnoKRqGf08YAdqQB6SSOVFh8O
	+3yB5JEIKbZDfPpX8XjNFWPkYtMiCfg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=M7IB1aKz;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5177945a279so8445991cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313085; x=1782917885; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+LbNsCaF8AqQRerBXt6jCH2X6FSKJPEhWXxoYu5Er/s=;
        b=M7IB1aKznI1aR0t08nh0+8RttCRbiwg5QKgp7UbZ1BkzEu5AiIwRAr5CSNmHrtA1Fe
         HNGjRxhhkFCo0gjKUwJOlUuAjfGJNOTX3epQiaFPkbEaHNn/Zjv2JvJt8ojmkLb1T7LP
         NaHhXPUuQERcJpnDAiadkTdOrbnUSDZwGBGvNvAHnZffbWuQ+RwVq8zdPssA9Dc89DYs
         DYEW+3qucAVGQ3V4gD4kXHypINPLB+FJWfeRIJWJYt9HWxy4mQhiZV8bO+MZC0F3AylS
         2oUWtkOGq6sTPP3rbjZm7x6BgsKqRQr1bXyte0DCrTMP16/6hq8TE5yB8UPCzMARsOWx
         7tyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313085; x=1782917885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+LbNsCaF8AqQRerBXt6jCH2X6FSKJPEhWXxoYu5Er/s=;
        b=ZPVJKPyckVAqBIUPD1ncvGmsVy3nDCowZrXvWfHfyNqIfLxxj+vNK/CzBCkxZ1nLQc
         ZtCImZLerS7smG/BZUKY4U+sEK6XpUsb7qygMxSc2qGs2hozQUxnxeWLGsxgAOHsfant
         WKWKJmfLsnnUkYibzA68fkEVAuVXzY8oVLCe3ys6nJC8Efw0N5Ya+KEoJt0JAFZFCcNU
         N8edXhM4Yj6qhyy3I5M396R6VbNSVmLfcjIx60fH8q/OC1MzQ5crieL3bnIDVGy6nevm
         Dln+FqJqghI48VCNuf/kpFkzCS7MfBse03A23sBZPOU8PAM+YcyeC3drjINuLq2M5tIz
         CV8Q==
X-Gm-Message-State: AOJu0YxfnEyb/LbSPrBYpARsqdfrEdd4NHgsn0/oWfzEb2nqmVKQvHsc
	cYF8TabczUsBaQvxN7fiHV1Sg8khDzbJE5qPCzUIVk3/2hRh6skzARClQhw3ZEpUHWLy5WGiGje
	ukD/s
X-Gm-Gg: AfdE7cmS8f2QUAK1Act0mDKSHENikGQlOoysVFgqyfBvW/hTkazWdcWzp6JtHEKO78/
	Rgpw6OaAmwbNPiV3w9XlB+VIj19VoseLJb+3m/LryYWSfXQMkUKsZBQUaVSzApbD+o7GnUWee46
	amRcFzq1hyRl7U2X+QWLxt5QQY1ibE08dPAcv6Idz9a4gr8fo9bqXvcUnlOVSXWZbUoafCEnVt7
	G2kiSdBxra1nuHJPTcIZV9rKD5Kls4Au07Gvc7p/nqPfrQ7sneOreO5UIFtEFcm7y4ZAYGb73Da
	HqabwkLVWwSuYgk3Ofd2eqJrp+isHm50OpBMuMQZbQSOtGwA6p0J/J9SDx4awiE5aYUvakRpXxy
	75VQQ/ZZ4EtFtuWWUdPpZDCVIgX90+w0nVAykIE/i2uwdAGuVPWQank5QCZLQKC6hjDpV/KwYk7
	Klg/K7wIMrnn7LVGCGTmmlb1/du5k3V1nNEwc1IdO9O99WhVmDOHeO4tFsmRxB8YVnOtVyKU/Jk
	w==
X-Received: by 2002:a05:622a:2297:b0:50e:6182:b4c with SMTP id d75a77b69052e-51a61e49d5emr54674141cf.25.1782313085460;
        Wed, 24 Jun 2026 07:58:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
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
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 5/9] mm/memory_hotplug: offline_and_remove_memory_ranges()
Date: Wed, 24 Jun 2026 10:57:40 -0400
Message-ID: <20260624145744.3532049-6-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 70290A0003
X-Stat-Signature: i5coc48o936t3gd3mscwbcqysjtqt7sz
X-HE-Tag: 1782313086-453657
X-HE-Meta: U2FsdGVkX1+9GA5ThPU24RS6gzfqyzH6ISRNNSZgLPtJGtOb+z4uEwVq2tUoO8UoWDH6eTzh7ytGyzciL6SokzePa4aQBKmZskX9jYbQojhUzBO0TTwawJw8Xsdxts4mmjmOlCHZ/ldo4LCymjV0JSyijihdqbZKyFI44wRtDBEJVU/MMwlFAS+FYpQ5V/S20WVVqrPOhbHNxgSrPj4IVwum0F2DW+BWtLlVMsZYwuFyq2oxK0Hi50Sm+ZeIyxcKfLZIxGOV4TPNXyhtT9uC5LRG33abxr6Oh6QvZNEFgSmjVmd/PFcQLm8uBeKh+RHYZCUdFnscToALYJzZYIbdN3yOpwJVZXzP+6URw7OmS/Lw6i96vbGgGPkyKB1UI0a9CkUJTEORc94pIa42L414mAb3l+6VMu/A9WvxiEoCde4ZYxb2CbJd3Jn462CTXE9lg8cb9l73hmATypA2o+467f57D1nxC982AHF+iPstyHg5YVxKfBkvo/zddVXfofBrrWCOR9xW4C82MZK7qlkv6qwwwJSY9o3BZoXN5ijZIjQRRwOh0RFeavgZaWVPECqwInfFLkM2GNJ8o1Zk0mO93CbSg8DQjWJXnxU15fgXU3z6LVj4OpltgUNh6FWwr3QvRKDrCnHoW+lpbbUwaOyuBDQ+r36o5RRgB84q896lMqiBwSezJGDuSWWxAdlkt+AHWTtzXgoDscxgzp8BTDUtaqiFxDEMjLs7CK5iK66JzHSU3qb2jBl49eyMI7ugxGcd97PAFz30WsPb487uRktxD8lJzxzBI5/RL/VxLne0kyVES+xOVx3SzBG4edRFFQpxLC76UqW9uBHqKsDOWEYX3V9Tq6wHGLyJlVqs+2DFkr6V2vXcstFj2I4J+cadFIwMyBk2q3n+dwvAlIJ13GwvUKMvRFvooPpI5H5ZxtNIAOtyy1SxLsTCX4yGXipYGO4yQJVjkOBXNDQ2WfpEnCZ
 oDZBT+EO
 TXfUDeQZ483cqRLCBpIdEbuzS78dVIG1YHVjB4zZUIpapPEQBK2w9jbMfbCMX4JzioawSEczkxqC4yhRen74CHnZgt1QZTnbjeHyxZ3uTDYZs/CS2kDvbuvqNpybmdy8L4tWBBof+Hm1ueCA+ea8ip/MNT0SgNOry5V9ayvUIkPtxagI36E8Ca9lIQlCi7iAxub9wmoVv2g03p1ZFRrIYE+jU0ftCrljkG1CMdN7idyqfBST3+8tnpaMnKwV4E+8v/zAKnCsHbzSQUQ2elBDNGx6lwKOsxh5qAzR45DM2Fzsh6aSkt3F2SiVKXML9J8wPq7mvx0/LdNNgK48WN0DDKxmOYsY+sHhbIPY2fiJDhdoceJovH9gWAXIsyA==
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
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  7 +++
 mm/memory_hotplug.c            | 94 ++++++++++++++++++++++++----------
 2 files changed, 74 insertions(+), 27 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d3edeb80aadb..7f1da7c428dc 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -267,6 +267,7 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
+int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges);
 
 #else
 static inline void try_offline_node(int nid) {}
@@ -283,6 +284,12 @@ static inline int remove_memory(u64 start, u64 size)
 }
 
 static inline void __remove_memory(u64 start, u64 size) {}
+
+static inline int offline_and_remove_memory_ranges(const struct range *ranges,
+						   int nr_ranges)
+{
+	return -EBUSY;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a66346def504..7d56e0c6ede0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2429,58 +2429,98 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
  */
 int offline_and_remove_memory(u64 start, u64 size)
 {
-	const unsigned long mb_count = size / memory_block_size_bytes();
+	struct range range = { .start = start, .end = start + size - 1 };
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
+ * Return: 0 on success, negative errno otherwise.  On failure no range has
+ * been removed.
+ */
+int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
+{
+	unsigned long mb_total = 0;
 	uint8_t *online_types, *tmp;
-	int rc;
+	int i, rc = 0;
 
-	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
-	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+	if (!ranges || nr_ranges <= 0)
 		return -EINVAL;
 
+	for (i = 0; i < nr_ranges; i++) {
+		u64 start = ranges[i].start;
+		u64 size = range_len(&ranges[i]);
+
+		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
+		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+			return -EINVAL;
+		mb_total += size / memory_block_size_bytes();
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
-	online_types = kmalloc_array(mb_count, sizeof(*online_types),
+	online_types = kmalloc_array(mb_total, sizeof(*online_types),
 				     GFP_KERNEL);
 	if (!online_types)
 		return -ENOMEM;
-	/*
-	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
-	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
-	 * try_reonline_memory_block().
-	 */
-	memset(online_types, MMOP_OFFLINE, mb_count);
+	memset(online_types, MMOP_OFFLINE, mb_total);
 
 	lock_device_hotplug();
 
+	/* Phase 1: offline every block in every range. */
 	tmp = online_types;
-	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
+	for (i = 0; i < nr_ranges; i++) {
+		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
+					&tmp, try_offline_memory_block);
+		if (rc)
+			break;
+	}
 
 	/*
-	 * In case we succeeded to offline all memory, remove it.
-	 * This cannot fail as it cannot get onlined in the meantime.
+	 * Phase 2: Remove each range. This essentially cannot fail as we hold
+	 * the hotplug lock . WARN if that assumption is ever broken.
 	 */
 	if (!rc) {
-		rc = try_remove_memory(start, size);
-		if (rc)
-			pr_err("%s: Failed to remove memory: %d", __func__, rc);
+		for (i = 0; i < nr_ranges; i++) {
+			rc = try_remove_memory(ranges[i].start,
+					       range_len(&ranges[i]));
+			if (WARN_ON_ONCE(rc)) {
+				pr_err("%s: Failed to remove memory: %d",
+				       __func__, rc);
+				break;
+			}
+		}
 	}
 
-	/*
-	 * Rollback what we did. While memory onlining might theoretically fail
-	 * (nacked by a notifier), it barely ever happens.
-	 */
+	/* On fail: roll back. Blocks that were already offline are skipped */
 	if (rc) {
 		tmp = online_types;
-		walk_memory_blocks(start, size, &tmp,
-				   try_reonline_memory_block);
+		for (i = 0; i < nr_ranges; i++)
+			walk_memory_blocks(ranges[i].start,
+					   range_len(&ranges[i]), &tmp,
+					   try_reonline_memory_block);
 	}
 	unlock_device_hotplug();
 
 	kfree(online_types);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-- 
2.54.0


