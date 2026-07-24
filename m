Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 047C4C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4CAC6B007B; Thu, 23 Jul 2026 21:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD8D6B0088; Thu, 23 Jul 2026 21:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED286B00A1; Thu, 23 Jul 2026 21:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92D176B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:46:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13BF61A01C5
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:46:21 +0000 (UTC)
X-FDA: 85021980162.25.AF2453E
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67351140004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:46:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="FUIN/LLY";
	spf=pass (imf26.hostedemail.com: domain of 36cNiagUKCFY96B894CC492.0CA96BIL-AA8Jy08.CF4@flex--linkl.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=36cNiagUKCFY96B894CC492.0CA96BIL-AA8Jy08.CF4@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784857579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G+1WbU2W0Xow25CzRoAw91vdRYKBdi1C3Nbcp/adKJ8=;
	b=MmlhHXxoxLuyfZnVlobpqaWMmupnvt/Jk2teVbAHGB6zLgJvldNpucCs7X4vdki197oT3d
	BZmJlzRFjbtmELYrjWYwoB3Vzu3cVP0He6qs3X+lXb9MbtP9DtB+h7VzbeNgmv/KhIGEN7
	qqiK2iOZh/oYrzYpbzf6KPZtLn62OPI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="FUIN/LLY";
	spf=pass (imf26.hostedemail.com: domain of 36cNiagUKCFY96B894CC492.0CA96BIL-AA8Jy08.CF4@flex--linkl.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=36cNiagUKCFY96B894CC492.0CA96BIL-AA8Jy08.CF4@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784857579;
	b=onGEWrATfJWLLZRFKcuRPqsAd792ylgygEjLLgs4uIAyxBCmaMmfw93WYF5NOEydQB3buY
	HU00r9QFPY5ggkIJ0OxnctES14KBQRlzKoMY+feuBO4p8MMMXOudenOxbCjXbyH/F6k5FU
	Bz1ChElCzu5mr7DF8tx1hvgJ7M1x5CM=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso2293426a91.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784857578; x=1785462378; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G+1WbU2W0Xow25CzRoAw91vdRYKBdi1C3Nbcp/adKJ8=;
        b=FUIN/LLY66nqPcFslzn+ZZUP7NVB36P4tMFctnD+2kE6lMnILpZ3T3yTe6rM0ZM1JI
         Bp7nYyAxrOFRhUmMtDqB1spedAiK5U1gt/FYQKgDbNH+n2st1K4FU2A9KuIUc+Gfkbdv
         B3/mPiWjtkBQUc5GtGIiy6PaP9ZLaTfSznXmoVTFo9TNfmrOkZHCvOAmns2pE0uDLs0p
         emfEy33+xcz4V/RELyw3TZkx8WnSqXNqAT/NuU4EeJz3TJtvM7lNezsZ1LCAGdDmpFUX
         wzspok43uQkYXuZli80ZrcIfxxW9zi1UrGlwZn+ZQmnP6dltJEz5q8aKY3XQNeXV3xtE
         Yhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784857578; x=1785462378;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G+1WbU2W0Xow25CzRoAw91vdRYKBdi1C3Nbcp/adKJ8=;
        b=PJHkY9xsbaPdz+4sSO//Aq0PWYb1OnGhO6LGNzz8XdCMfW2ic5OLMH3pB9DDIaTt5Z
         bEbRHDUjpKmnOXPBLsx9/D9w7oj76fj7WoaY0X0pmxFJFNSAAWjWud9RWn1eFTzlIswQ
         94Xj/99kK9nb7bXQI9mbeJzKE1d3BxswqR6Yy6iewd4jPS6u9RmSP2xd7PZtyhfTe8O1
         DXK0i/kBxV9Zwcg9EzmvPTxBmiWrBakYjvqjYgXgyQjbB7umrA3SmPxMMBbOezrigFoC
         zMeiBfAiGMgaADskAcEIjG5icSHHWDSX/tM/E/njEPSSfqf8IvhP190rhANvV2P1QsXo
         /tYQ==
X-Forwarded-Encrypted: i=1; AHgh+RrGNA0H2Dcb+8hfw+dX4tJhYr12Z49GeaHEspGdB3HW3ax1WFxzxaOsqfz8Ew13TWBshNE6Oj2jkQ==@kvack.org
X-Gm-Message-State: AOJu0YyAkbpi58OoVvjjN7sqr5LOwYGvDqxe8zbxUAgkSSEdal6unAwz
	0gS/oH0EfI9LfozzKAJP9RyoLw/DHkRy02g9TvHvLsyMwSLLBhFgdDgKwsGy2KyVCPk0dgDS6ls
	inw==
X-Received: from pjbbo4.prod.google.com ([2002:a17:90b:904:b0:381:1d7f:b8db])
 (user=linkl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35cb:b0:38e:69f8:cc49
 with SMTP id 98e67ed59e1d1-38ec65e374fmr5127138a91.40.1784857577957; Thu, 23
 Jul 2026 18:46:17 -0700 (PDT)
Date: Fri, 24 Jul 2026 01:46:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260724014605.3377283-1-linkl@google.com>
Subject: [RFC PATCH] virtio_balloon: add VIRTIO_BALLOON_F_REPORTING_PM_SAFE
 feature bit
From: Link Lin <linkl@google.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org, Cory Maccarrone <maccarro@google.com>, 
	Taylor Scanlon <tayy@google.com>, Link Lin <linkl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 67351140004
X-Stat-Signature: f4dttg9ejum83e46fm7t38r7pxffncfa
X-HE-Tag: 1784857579-102062
X-HE-Meta: U2FsdGVkX1/F+89CJrJlxJ02PI1QUJrxMdrDoVn5z/XykGyLOHQeosEmVvjPP/7SwNYmSpcJC4CkTVXBNamjlVgPFfHERKrnLr8wK2PHJxFCPcHu5Yhtxuz0QNv6/aS24buRleN+4ISvL+8Q4A4p9IkYFllsab6bNqQj1vF6PtYyQAeWLYIhCiA0SwyCFR/2LF77vDr/RXgJ5VCaGytDNzVsJic3Bpyt/yst07tklNM56PPkjTeKaHBhNpEhFOw/krksTAupVkGO3OvoyisQbgl0xvoj/xthMDmhv5TWqPjIE2C+vJi1tJYTlwGKovR7r+ZMj0mr8jNpU8rO0cRVxM6mg/IR6SOMCs6tx9SVnDHqNLDhD6glUt24hoSdB0cdoZ5sOtzY+wSN1xgZA6Xp/nnR8x6QvUntKrnmkDJm8O6lbiPg8ty5XeoCrcafJS2jeik0LyGzwKPj9pe1r0u2IOBozd5J9ie7QG5VJui+mBgG5DgL+hEf9aAEw26iF4gRqPGoBfomgKYLpnzAQUlJ8x0StN64bkUntYqp00ioUbYj0O55lJcHIenQZWP1EsrtXljmJAJhIEpRruyEALp7jiV4bDUWetJnRodH4QEZsfYkPsQXj9Xy2sXajuDeMZxj2n/FfNypWjjWVYodcWCJD3CMx4OLFdhhKHy7tDf6lN0era4nG3bO1+4Ndsl6DW01NJDF0++qqSESw0Jtbh1X2UA/NSiCCXS61LxjfV1YV7b3gJqBVYiPSNaNDYZvZ8FLAqRAMNhry6KDIj4K6sn+lGZtyAMGKNW0o0TSiyvGldfGJHgzfBhxWK5CQGacrzNZ43mSg1YJl+yXgAStacTKuYjQU4L5ZuHR4nirykMKKrulUvRnfuSpqEZKpLHrK/qSiMLPkHAkx2kEXSb84YKN5LV2d7C4/gp35tvCr2NaRn5874kiTX6BTJ+Mp+KKy4B0XVSUO7i8Vcx4LoVLyWI
 k0nPy4et
 JOlQmjgitBY6dQSyYqROcgXQjRsPQ8y/1eJs10bHeWc6zFxtftJVZG//JA244K84tOkV/59zqLLEBbr4JyUw7Xpq1QC/SKk4vlmAPDlyiT6EeHJ1avEyRsmQemSNXE4HAmNrZQnR8jbWwNIEaPIDNAEcGOPsZrP5Etl9CHV30qtZTjjXetCwlzYvuu21J4x2VosdZRFyYypacDpyFmws3I7sh9i+CvTwsZAC+6yc+zRMEVfZJFXSW6MCzdBekh80/VasNXu+gt8YMp+MuGpmLn3OrH9X7/PCAJk46Ucr9oNlZhVDGxkp8qnFQl/oDRTaG/D6oN44ukUqWNP7xXeCDia7XeyNRtS2UKPgswwkqTyaS1gOlVPlENsdmWpL0Hi1MULPAeaA2qt9DauhbDovxkWY3jL5y0/5KxGqZeDyG9eYQxD1vmtn97TO3qpyRUTnb2Jvo4qEaWY4PtIh09DCCaUJt/9mKdh31HyZtfWegwiLrnWUT3XdC8/VC1PY6pYVE7onuXPS5xYPa6pFjWx/j66n9jEyQeaJt7mpt4aBqcAlhj/a7udBgtdSCp49YYetZyiXGDnzB9e1P6uYLpLbOaGpdZiUhnYobDsEmPOYFv3KKyMRVfXEHFX8MYuC0dBf8RWVmM2mmiyVwIiqt4G8grLrbeuU0CZaq0b6o09EBcp54UAoYsh+Fk1jYzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Following up on the fix for the PM suspend Use-After-Free race condition in
mm/page_reporting (merged in mm-hotfixes-unstable: 
https://lore.kernel.org/all/20260723003650.CAAF01F000E9@smtp.kernel.org/), 
we face a hypervisor-side deployment dilemma.

Cloud hypervisors want to safely enable the Free Page Reporting (FPR) 
virtqueue across their fleets, but enabling it indiscriminately on guests 
without the recent suspend fix exposes them to UAF crashes. Relying on 
out-of-band metadata (e.g., OS image tags) to selectively enable the 
feature is fragile for custom user images or live-patched kernels.

To address this at the protocol level, we propose adding a new feature bit 
to the Virtio Specification: 
VIRTIO_BALLOON_F_REPORTING_PM_SAFE (Bit 6)

This establishes a formal device lifecycle contract for power management:
If negotiated, the driver MUST guarantee that all page reporting operations
are halted and pending requests are flushed before the device/system
transitions into a suspended state (e.g., ACPI S3/S4).

Deployment semantics:
- Hypervisors operating in a strict "safe mode" can offer Bit 6 exclusively 
  (suppressing Bit 5 / VIRTIO_BALLOON_F_REPORTING).
- Older, unpatched Linux guests will see Bit 5 is absent, ignore Bit 6, and 
  safely skip FPR initialization, preventing the suspend crash. Standard
  ballooning remains 100% functional.
- Patched Linux guests will recognize Bit 6 and safely initialize FPR.
- Note for fleet deployments: Non-Linux guests (e.g., Windows, FreeBSD) 
  that rely on Bit 5 will temporarily lose FPR if the hypervisor exclusively 
  offers Bit 6. This is considered an acceptable trade-off to globally 
  protect unpatched guests without relying on OS image tags, until those 
  respective virtio drivers adopt Bit 6.

Implementation Note on Upstream/Downstream Dependencies:
--------------------------------------------------------
Because it is critical that downstream Linux distros do not accidentally 
backport Bit 6 without the core MM UAF fix, the final upstream 
implementation of this patch will enforce a strict compile-time dependency. 
We plan to export a macro (e.g., PAGE_REPORTING_HAS_FREEZABLE_WQ) from the 
core MM fix, and wrap Bit 6 behind an #ifdef of that macro in 
virtio_balloon.c. This guarantees that compiler backports must consume the 
entire dependency chain to advertise the feature.

Below is the proposed Linux proof-of-concept based on upstream master. We 
introduce a helper virtio_balloon_has_reporting() to ensure virtqueues are 
properly allocated, torn down, and validated if either bit is negotiated.

If this architectural approach is acceptable for cloud deployments, we will 
formally submit this patch and open a corresponding issue for the OASIS 
Virtio specification.

Depends-on: <Message-ID: 20260723003650.CAAF01F000E9@smtp.kernel.org>
Signed-off-by: Link Lin <linkl@google.com>
---
 drivers/virtio/virtio_balloon.c     | 15 +++++++++++----
 include/uapi/linux/virtio_balloon.h |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 581ac799d9..00e8273dc3 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -39,6 +39,12 @@
 	(1 << (VIRTIO_BALLOON_HINT_BLOCK_ORDER + PAGE_SHIFT))
 #define VIRTIO_BALLOON_HINT_BLOCK_PAGES (1 << VIRTIO_BALLOON_HINT_BLOCK_ORDER)
 
+static inline bool virtio_balloon_has_reporting(struct virtio_device *vdev)
+{
+	return virtio_has_feature(vdev, VIRTIO_BALLOON_F_REPORTING) ||
+	       virtio_has_feature(vdev, VIRTIO_BALLOON_F_REPORTING_PM_SAFE);
+}
+
 enum virtio_balloon_vq {
 	VIRTIO_BALLOON_VQ_INFLATE,
 	VIRTIO_BALLOON_VQ_DEFLATE,
@@ -598,7 +604,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		vqs_info[VIRTIO_BALLOON_VQ_FREE_PAGE].name = "free_page_vq";
 
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+	if (virtio_balloon_has_reporting(vb->vdev)) {
 		vqs_info[VIRTIO_BALLOON_VQ_REPORTING].name = "reporting_vq";
 		vqs_info[VIRTIO_BALLOON_VQ_REPORTING].callback = balloon_ack;
 	}
@@ -635,7 +641,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
 
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+	if (virtio_balloon_has_reporting(vb->vdev))
 		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
 
 	return 0;
@@ -1013,7 +1019,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	}
 
 	vb->pr_dev_info.report = virtballoon_free_page_report;
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+	if (virtio_balloon_has_reporting(vb->vdev)) {
 		unsigned int capacity;
 
 		capacity = virtqueue_get_vring_size(vb->reporting_vq);
@@ -1099,7 +1105,7 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+	if (virtio_balloon_has_reporting(vb->vdev))
 		page_reporting_unregister(&vb->pr_dev_info);
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		unregister_oom_notifier(&vb->oom_nb);
@@ -1162,8 +1168,10 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	 */
 	if (!want_init_on_free() && !page_poisoning_enabled_static())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
-	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
+	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING_PM_SAFE);
+	}
 
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
@@ -1176,6 +1184,7 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
 	VIRTIO_BALLOON_F_PAGE_POISON,
 	VIRTIO_BALLOON_F_REPORTING,
+	VIRTIO_BALLOON_F_REPORTING_PM_SAFE,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index ee35a37280..d206f156d6 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -37,6 +37,7 @@
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
 #define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
+#define VIRTIO_BALLOON_F_REPORTING_PM_SAFE	6 /* PM-safe page reporting */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
--

