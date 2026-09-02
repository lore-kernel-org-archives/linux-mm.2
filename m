Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 029F4C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A356B00E6; Wed,  2 Sep 2026 15:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25A66B00E8; Wed,  2 Sep 2026 15:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15426B00E9; Wed,  2 Sep 2026 15:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C619B6B00E6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:55:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DA53A4291
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:55:20 +0000 (UTC)
X-FDA: 85169876400.03.F27CE01
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3E4040003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:55:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SO3BxjBD;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378918;
	b=pNSbpj9sMzaMw1hgQLA6eDKxIqq3BRJiBeC07FTuEIYM/4K0NQQHcm9OGPVPNM0GaKg8yq
	yDAYs9sZ0DwrUoZw1btYCML4YmKmVSwZJcy6hMMQDk3NLkovUNDMustt+9KsZDejIXcxzt
	fuIhPp8slpsV37HlRYY6TfhYX7QocFU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SO3BxjBD;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I1NZ9ZHcDjrngsqR4bYoxHCsiDBrtNaJ+UNE7jVFBRE=;
	b=STr+UQiZzP97a7rsAlDmdiW/zNy1zaINn1z39WeWJBEtsznrNQIwPo2YaqNYw5WId3D4gy
	fJX0WcU/MP4/9J6+eNBGoNArbJ8rSsUKYfQsRvEVCayX4N8kNMBKM5gitI+q/0LFT1IBd4
	VVJwBHdD4gbQeTqTelf3H73r0LsqVAU=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-936c02e58dfso143610385a.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788378918; x=1788983718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I1NZ9ZHcDjrngsqR4bYoxHCsiDBrtNaJ+UNE7jVFBRE=;
        b=SO3BxjBDYgYt8HhzTBwtzdacMUAdampGXhymd7iMnN4WKKYzpRfkdaTqtojbQfvMy2
         HOFzFyaT6iqPZApG/GkY7Eb0gjid72f/JRMTIHrc+9ixsn1PA2wYn2XmIn0fHVa7L6lp
         2DYIKp6Eaf4LmCcSXORVsOf4IqBGI9XbamWdO4UyjmoOWpbzU7iX1Dfm11rXuH+A+mSW
         HrTr/gFO8JkmtiVNK+LY4I5wCiodmEbN+H6HviWSITu3Z8eJ8YM71S17sHmxEfGOq04t
         9ODCyf/1uK781fXNfLXk4ePPi6JgjEYAdH7+eXvl2Bg+tUbbZEAu0YoGxM/BbfsmrUfS
         xXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378918; x=1788983718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I1NZ9ZHcDjrngsqR4bYoxHCsiDBrtNaJ+UNE7jVFBRE=;
        b=UrwFO6QgH+lhi8rzB2h9sbG5gSfmpiXy2iWyR3w8xC+fwROa1ormQmaP7TO0rUkZaT
         F+newDqHd3PHBSu7kVzJxhXeT4DyAugJcjqS7yDIYN+Gidi+5zlQeI/3tM8ACgbABPdl
         thkd08hTcqn6+ToWlrjWB/KINEzhX7bOtR0Y4l6Xxh0Jpv3iV6zTRR218csLCxm86XH6
         d/GZzxoPAuFeXg6qncAC4GM17gnJRrr7b97dIaRo6EAJnIsO9cUfhayKBur684dXQVsx
         ip3+6ThGpo44mg+oMP9TaB6nhIk59BO/8Gz4gTGQy63Ma7sTPIFPB9DLahJnzh3BiQ7i
         fEgQ==
X-Gm-Message-State: AFuF++lGSYmmOO+1kURZPuBHEWBtRgLQRRIKCTWi4KAtXXDVfEEUFB07
	lsC93z0fi3+9KldoQwnKiDcp3XMJT2GlR2/v8M2px5hRX58jm95CNWy8U8Zf7D+bk/1WPL3yNix
	6Hw3UtUY=
X-Gm-Gg: AYBFou2+yVsjptfmXLhUjVYIaczAuwV0EMxFqXrEftxpGSfWD2EpygLL7cE6exb0qMo
	w46+tPNn5IGw+7uyyda/30e8Pw2QcmXoc/9DOmveSPc6dnXzk8H7LIdEJg3/6jMpPbN24Abt2Ix
	c3KEdcUNtaJjkiBOchXFXe7qki5SITI+O6qdH3km98eGbiTrPNEWDB+nDikZcUpSSWo4XvpquBt
	0mTBiDLAN2tuEzcwZMMwdyLa8I8Ms2M6wX+LR1Bt6XKLua6Dw2vQJE+Q8Wb5ESy70x669XEfeZ1
	mWW/NtSCk+gg4mE+JIlRx8f3qwpuL/CpoZsEURGVp61yfOHFX/VOKEldc2WEkFscDGX1Gu1Zc+a
	xasu1xBYVH6dWTi3nv08VqVdbgYlAGfQ/CHruWapSDPLP05/yIUby7VpWsbFmIHN/S+0p8SdOID
	MRZjkMzwcEb5ILuxgP6vUfa68+mieYIrUsWKgGnO2QvEyxScPgMF/5kibm3uTvS3huWkyN6VGOI
	kUdLaAtYxJkEmuuM8xloHLkp7+SAQP8rZFIfr3TJeA98b7yFOZJT46J5Lzn
X-Received: by 2002:a05:620a:148b:b0:939:6de8:43e2 with SMTP id af79cd13be357-9396de845d1mr170355585a.47.1788378917712;
        Wed, 02 Sep 2026 12:55:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f187083sm295334485a.15.2026.09.02.12.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:55:17 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH] mm/memory_hotplug: factor out node_is_memoryless()
Date: Wed,  2 Sep 2026 15:55:07 -0400
Message-ID: <20260902195507.88655-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B3E4040003
X-Stat-Signature: 3618p5jux9ucjq1nooumk6iiy3hw7qdr
X-Rspam-User: 
X-HE-Tag: 1788378918-100898
X-HE-Meta: U2FsdGVkX1/5NkfYESPfEZW4gM6/vdDvRa2KuvesgE0lEyyAuHOzdCwn9H2p1Nwx3I3KOzYuOKvsq6TB10bScDlOoTlElin4KXj6RPzOL+m2zIg6gGqHZkQWnD1jvTHnHadaasqaX8bUWtWE5/4lt5h+bUL4wzPyn8rQ3C95eTQj2Fhm/r/xCMk3aMAfUmI2bp7ZoxJCfar03U0CEF16Nxz3ePC1H6WbW0cKCzCKM6oh0KkhyFkGaBfbmDbU1blIZZ8b+uTrMSkyKL6qAe+KYWVeJCjz9PU3hkdwoC9wqDwKQZZshVC7fWhBbLQbfv7Ar4PUgHWHFgpEDiXr8H3Og11AWW6EIZggXpHJGU9yJNdSwD3sPgutQl83wdELaOAKR4wmYZcpMjvvXBNIdZlwF//qy0vD3lc42/5UdI++ovrbDNwR4rmu2u6tZefCL1RMQcdVrq6HT71Hc+H4exg52Ix2c7dJ/CRd9AwiIxw4tt279vXiX9ywPJepcn+yFyEmewSjLXF/XV1we+jWbMjBQPl7piXjAfWlScJzezTyJGV24eClNz6ty1s0cAXDwKe4pivi1m5yr19Lpffd7GoIKrbJBbzKzBio4GVBTC4yBLniK6jUuqSTmDu+hWMQHZwtivq4uL+XFX75wCp/DCQEi61fz2klK+pn4SfChQSfT0neLed8MTM4bEykYB+UB1VHO2w6Bo3FxCQ2yDyVzh/nSBrNlwf1FUQvD48cHIf728txnWjcra+cMSXjboez0Y2E+IgNEbHU7EKC2/aAhVQvjScge9nWx/VEeN66KDs+u0kYJrJPSl/q2gIT4E6ywSN820LwXhuJ83BUOFqsoJmH4LcQBZvQapHEeNCHxgIYol1G2R0mL1H9Dw85HxiAo13OD9TMw54H9MzFUQuT9rXLrZSflql362Ku03OpL20SRTbKiAlkTf0uptjt5MKVF0yCeHgF2VhbldsrgFfl3Pi
 aOAVE2iw
 0VqF0pBkZysefPUs2rwSUWdLogHxEzlgaV8PNX38hHqrcVJkGpeEYVxyZlkeuA+nJILkK2uYUMSYl+4T3aawCAUyi3g5eNdbOf9/bkTxmxFVZTnuoRhql/ccGJQaIgVkiI8UiLHlvOLubOJPvhI4vkIeJ5yRU/q6ZC3djZQusfKM/9pAyQI/gU/TCKm/9VEMql0Y3o8tHXiq1ocuoJjdfYOKk2eJIS9HDY6kif39QQIk0pJpIR6cpO54IsQ+udPAr/RNeWLGtERFWq6GtbVabhAs63UzEU94pErF4aYq9LHJrGY5KPjpQNKV6UY+c9oapPRJj4XIdY0YSJYvJzyDB2mUkvMnIpo2cVlZ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A memoryless node neither spans present pages (populated or ZONE_DEVICE)
nor has an offline-but-added memory block still linked to it in sysfs.

try_offline_node() presently open-codes this memoryless check.

Pull that into a node_is_memoryless() helper and pull the existing
check_no_memblock_for_node_cb() helper ahead of the add/online path
so it's clearer what is happening here.

No functional change.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 60 +++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078ad..d0e94057682af 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1491,6 +1491,36 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 	return ret;
 }
 
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
+{
+	int nid = *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid == nid ? -EEXIST : 0;
+}
+
+/* Caller must hold the memory hotplug lock for this check. */
+static bool node_is_memoryless(int nid)
+{
+	/*
+	 * A node still spanning pages (especially ZONE_DEVICE) is not
+	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
+	 * e.g. once a memory block has been onlined.
+	 */
+	if (node_spanned_pages(nid))
+		return false;
+	/*
+	 * Offline memory blocks may not be spanned by the node yet, but they
+	 * link to it in sysfs and can be onlined later, so the node is not
+	 * memoryless while any remain.
+	 */
+	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+}
+
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -2214,18 +2244,6 @@ static int check_cpu_on_node(int nid)
 	return 0;
 }
 
-static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
-{
-	int nid = *(int *)arg;
-
-	/*
-	 * If a memory block belongs to multiple nodes, the stored nid is not
-	 * reliable. However, such blocks are always online (e.g., cannot get
-	 * offlined) and, therefore, are still spanned by the node.
-	 */
-	return mem->nid == nid ? -EEXIST : 0;
-}
-
 /**
  * try_offline_node
  * @nid: the node ID
@@ -2237,23 +2255,7 @@ static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
  */
 void try_offline_node(int nid)
 {
-	int rc;
-
-	/*
-	 * If the node still spans pages (especially ZONE_DEVICE), don't
-	 * offline it. A node spans memory after move_pfn_range_to_zone(),
-	 * e.g., after the memory block was onlined.
-	 */
-	if (node_spanned_pages(nid))
-		return;
-
-	/*
-	 * Especially offline memory blocks might not be spanned by the
-	 * node. They will get spanned by the node once they get onlined.
-	 * However, they link to the node in sysfs and can get onlined later.
-	 */
-	rc = for_each_memory_block(&nid, check_no_memblock_for_node_cb);
-	if (rc)
+	if (!node_is_memoryless(nid))
 		return;
 
 	if (check_cpu_on_node(nid))
-- 
2.53.0-Meta


