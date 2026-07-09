Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC11C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7B46B00B5; Thu,  9 Jul 2026 18:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA2E6B00B6; Thu,  9 Jul 2026 18:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72296B00B7; Thu,  9 Jul 2026 18:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71A856B00B5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:43:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF47B12030D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:43:37 +0000 (UTC)
X-FDA: 84970716474.17.DACD285
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5FA8FA000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:43:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bTabu8rI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3FiRQagUKCPckhmjkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--linkl.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3FiRQagUKCPckhmjkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--linkl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783637016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oJx78Z8LFnN8gG9u1+4qNl1x5zV0JVCwAKu/BmzTVP8=;
	b=vIVoym3Ana+UQYqZ4bngtjchQ+h6IBgM5AaeuVWg48pJrRwbA4DJuE1X5lfD8ucqL9TQZK
	BPlEdqBpIJgbRDRx8UyEP0hHdixWhoY0esAn8N0dFNwhXtm0QbzeJDFG1n00WVQPmjx1DX
	hlGZS8CMQXgaAE7Fyqt7xgmL80UDUSE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bTabu8rI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3FiRQagUKCPckhmjkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--linkl.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3FiRQagUKCPckhmjkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--linkl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783637016;
	b=HICQsLHsGeA05LdHLnbzvKn2QHSkyRyt+7AOppE8zKqEF8fIjo+dCJHNBR2H1rWPM5gPZa
	dKQCBMtV6QJKkeDjl+o+wIU3EtJ8ueIPy+sc0HhtcdWPXSsHOArrxj6sE0f/xuhgOj1rWC
	ZIpnnzdPU9WBXKlpmndm8ZL7OZUNIKg=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-38c7de7ba7cso657330a91.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 15:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783637015; x=1784241815; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oJx78Z8LFnN8gG9u1+4qNl1x5zV0JVCwAKu/BmzTVP8=;
        b=bTabu8rILMAKlQYz4zh6EMXevfxmjumInrjJ0NTLxhuADdwxCDl2WD2Hu0Jwyfwsrf
         ljiGpcQ/WEisbMUO/2Rqt7tjVP1ivN9bIVq7hFFbzVwItSpnWYpxo5blQi5M9PbZ785k
         qMW4m6HjeWp7sVljX6pNtEWnKh8CzgBPdQEeDQ6iIj9EVz73mAOD6ZKXgkd0CjZrHpAt
         Pj3ukbOnkZuwpseBUWHV9fse7iL9dGCb7+R027Xs6D8nEqZTVk1uGLflt6WxyxlVWgOz
         wa+6JbIyhTVKxtkg4tzDof3u+pS/CNFhQQHvjKB/hZpPZwcglDDRkmAV274y87BONvsM
         /h+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783637015; x=1784241815;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oJx78Z8LFnN8gG9u1+4qNl1x5zV0JVCwAKu/BmzTVP8=;
        b=fhnnSNK3CF7xyArBWWCRjS+f5f7WeC8dz9A/Aoce8RGlzqpA1lP+SwjoBgSjgSnBem
         d5Uej6jdqNIL+gzUjIvquYyYe+tP3rwIG2eKb3ag3eUhZ3NsiGIRPuO8xsEwHGJFUe2+
         EASw/9A7isJ7kJffmSwIZxFDVaH7h/GeNnkwzgJjfsT12DO2e47towYHk383sisXZjpV
         OdgDpZefrkTe3abIla0zckpNmZmB2MqMTDe/qzrFR+YkhVJrWVma/a02OXev/zIifZnN
         NGTMXiu5BgE3Bkryv4NFKFdRHgQQ2ODqfAuuqID+1WURijBLmAIYeWZQh1m4UkiER/2N
         gM1Q==
X-Forwarded-Encrypted: i=1; AHgh+RqvyaIwEc0hXVOqB9IZgC6sbRZQyCXxEm9W8Irzsk4ZWy+nb0d5PmfSCigshoXhJ0l8WOao2XJaNw==@kvack.org
X-Gm-Message-State: AOJu0YyGUbU0tJRb1oz1G6RFC56GlgcYRpROQRb2KDnxW+fg4DxjK9Ix
	qURNOubQU8qy7MgPAI4vNlwe+3ZsdRSml0ReAIdrsT+Ha7xwnjWsCUrmR0MFUEj3Jw04+DqjfJQ
	naw==
X-Received: from pluo8.prod.google.com ([2002:a17:903:4b08:b0:2ce:6df9:bda5])
 (user=linkl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f4f:b0:387:e0db:3fad
 with SMTP id 98e67ed59e1d1-38942799755mr9097424a91.38.1783637014957; Thu, 09
 Jul 2026 15:43:34 -0700 (PDT)
Date: Thu,  9 Jul 2026 22:43:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260709224330.946683-1-linkl@google.com>
Subject: [RFC] virtio_balloon: fix Use-After-Free in page reporting during PM freeze
From: Link Lin <linkl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>
Cc: virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, 
	Link Lin <linkl@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FA8FA000B
X-Stat-Signature: 6hpb3b87dsrsk1aiomsefr4p4o45eg17
X-Rspam-User: 
X-HE-Tag: 1783637016-416064
X-HE-Meta: U2FsdGVkX18cywr5yOP/DzBEsHIXUsgNOFYuEHjY2lK3psqbdT37OIuH/Dw0xRbbH7EHleFgzdhMAf0GM4QWoRG7q6wgbS1dZ47e3bz21HKdeMOvD/Nr4/CxuYRPdzF9W+/f9GFSdlDJ6Y08C1PfsS9nOdXLkRfDdNEMO+H5ibrviFKkdrbukTvyScndIs4XGXq5BIBGgxIZeVBDlRlUv+ybCELlKjXf2VOv5yneA5+1vGfxaBvBpkDVOheo6zgFMCBz8Jb54FoA2P3/gfivtl/TJJAc49AuXHCpYo+H1SKnvgKguPJ2x1/aMPb6/TaukknMSc/cgzGdTHu2MICHeqxmUuJT2ntsmEaiwi69fwxlpG8c07k2dxb0XlCXbwU5lvBNDkuRASQuXPyzAPZ57Lo3QsOfihuTK3NdJfY2xdCtGKKvBzv4M0pRFTHN7MBjTCM/xDgqSsEXjpL+GT5cT4RoInhWphs2Vnbmn0cXUazxl0BU6VGy35BrulWpLjZd8xcdIPXOyF81SFebobSoeuTQZbNbgET/FKh6JeBDMOq0+QrOk3HxEbKUqYRnBapZOELTFQsdTftqUOpKk8uMQszncCP/sZDrJYf7OU4aK4VVO+hlrOMcTg1ebB4pfBmxIAsBD4TkLTh6KX1PUqDzt/CCn9C7YnqAB7St+TdnOCxn4zTLcMAEXPkTMpvbtJpouAXWNDTDW5XP7P+u5AzjQGyjK/xlkso3kvFR9pbPZpBaSlhfMw4Zli42oaCQ22KcCAfV2du+U9jSR1lZjiCPS1zT8Sx6XK1NstOxx+H3kOzcDmX5E3rVLOk3oAhMKK1PFbaY4tuI5NUrfPMEZnxJ7kmZG3X1PJX2FQtxFpzyj/cJGch2FVhJjjUkMhP2Yg/bFnIRBxG6wcTHS64shK/mrY9DqPAmSB4lIIReG07eV+SNOFxh7AEmNgFQsMSALHT2ScydXhkpHtDZ1GH+ZMR
 VlXEsb5p
 EVPfkQv5YHn4nhmdNn4SOtuuyyIH+wLTIWImkLJKDryNvuqCH8XBAA1fp0LE7YLpmZsLJfF0hgBGobdytBRKj/Ptg0tw2Y1oNG9wzpXWkY/F8fZwg5q+GMqKTzrurqJq5pqeeyBLn/FR3EmXRgECleqnGq2y6kNB8TVay4cp0k8lW5aV26/cy9f5NgpgK7pYctcWbDbO6YjByDn0wZJVkGY+I7+up9dnao45W+8VP+VTndX3/FhwjaKpLScwfbLC8Mpa3Inrey7xNvOt2Ow7taClyrV/Re12c4cGC0xtnxHZZX2mJ6Wn6plhJs3uISmBsLdgrDFi1C1fx0MKBjWGjm5Q9WmjYVRYX84n8CJlPWKXfA1GKdRhxMHxH6mecmi81n07+ABeAOAfYid0jGPuvqRQ1+YQ3kCCj8goJLhv+bpm/qu2SKxh5S53tITmTRkAF59H2/VZhKgWLVlDTNaFXfdij4GHb8lUIj/CYhzMWMdr+EMXoRlC8NOaXfKx3CF210y3kVDiWsVLbBMPXVYRaI6QP9QigW0yxeefTECIsAhqEnAqWX0reMPWENnuEoqBvCCyCKxoqJ+aqNxoM4tjmh6zksPANI57D7JQlAxQW+mBVV7WubM8TtDYi+d5O/7VOF7Ol3DBTi9e9RwLJ9UuwXzK7XRLKOlfGBW2GMq0nqQ1+phz7YpzqE8ZoC3eAgr49FRzarbzPaO6ReFerWzS5Tc3aNTTR2zOlBO/UsXJA+pjBoMm5YeXbj/Rqg/2x/yzIKuOVlkBSwPFOi1bZ1RgWXu++zUNeCwr35qp5jpQdPBcNGWwfNv+VUe1wQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During system power management freeze (e.g. ACPI S3 suspend or S4
hibernation), virtballoon_freeze() calls remove_common() to reset the
virtio device and delete all virtqueues via vdev->config->del_vqs().
However, unlike virtballoon_remove(), virtballoon_freeze() fails to call
page_reporting_unregister(&vb->pr_dev_info).

The comment in virtballoon_freeze() states:
    /*
     * The workqueue is already frozen by the PM core before this
     * function is called.
     */

While this comment was accurate in 2011 for balloon-internal workqueues
(such as balloon_wq, which was created with WQ_FREEZABLE and is paused
by the PM freezer), it is invalid for Free Page Reporting.

Free Page Reporting (mm/page_reporting.c) schedules its delayed work
(prdev->work) on the global system_wq. Because system_wq lacks the
WQ_FREEZABLE flag, the PM freezer (freeze_workqueues_busy()) explicitly
skips it. Consequently, page_reporting_process() on system_wq remains
active and unfrozen throughout device suspend.

If memory is freed into the buddy allocator or a delayed work timer
expires while the device is being frozen, page_reporting_process() fires
on system_wq and calls virtballoon_free_page_report(). This function
passes vb->reporting_vq into virtqueue_add_inbuf() / virtqueue_add_split().
Because the virtqueues were already destroyed by del_vqs(), this results
in a Use-After-Free / General Protection Fault:

    [  250.709271] general protection fault, probably for non-canonical address 0x7f728084daf08d5e: 0000 [#1] SMP PTI
    [  250.732967] CPU: 2 PID: 38 Comm: kworker/2:1 Not tainted 5.10.0-44-cloud-amd64 #1 Debian 5.10.257-1
    [  250.751575] Workqueue: events page_reporting_process
    [  250.756665] RIP: 0010:virtqueue_add_split+0x233/0x4c0 [virtio_ring]
    ...
    [  250.867678] virtballoon_free_page_report+0x3a/0xe0 [virtio_balloon]
    [  250.883446] page_reporting_process+0x225/0x4f0

(Note: The OOM Notifier and Shrinker/Free Page Hinting features suffer
from an identical lifecycle flaw and are also vulnerable to UAFs during
S4 hibernation when memory pressure spikes. This patch focuses on Free
Page Reporting, which runs periodically, to ensure clean backports to
stable kernels).

Fix this by:
1. Unregistering page reporting in virtballoon_freeze() prior to calling
   remove_common(). This clears the RCU pr_dev_info pointer and flushes/
   cancels prdev->work on system_wq via cancel_delayed_work_sync().
2. Re-registering page reporting in virtballoon_restore() after the
   virtqueues are re-initialized and virtio_device_ready() has been called.
3. Unwinding virtqueue initialization via remove_common() in 
   virtballoon_restore() if page_reporting_register() fails.

Fixes: 924a663f75e2 ("virtio-balloon: Reporting free page reservations")
Cc: stable@vger.kernel.org
Cc: jasowang@redhat.com
Cc: xuanzhuo@linux.alibaba.com
Cc: Ammar Faizi <ammarfaizi2@openresty.com>
Cc: jiaqiyan@google.com
Cc: ahwilkins@google.com
Cc: Greg Thelen <gthelen@google.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Link Lin <linkl@google.com>
---
 drivers/virtio/virtio_balloon.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index a1b2c3d4e5f6..45a90fb3abf8 100640
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1055,6 +1055,9 @@ static int virtballoon_freeze(struct virtio_device *vdev)
 	 * The workqueue is already frozen by the PM core before this
 	 * function is called.
 	 */
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+		page_reporting_unregister(&vb->pr_dev_info);
+
 	remove_common(vb);
 	return 0;
 }
 
 static int virtballoon_restore(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 	int ret;
 
 	ret = init_vqs(vdev->priv);
 	if (ret)
 		return ret;
 
 	virtio_device_ready(vdev);
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+		ret = page_reporting_register(&vb->pr_dev_info);
+		if (ret)
+			goto out_remove_vqs;
+	}
+
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	update_balloon_size(vb);
 	return 0;
+
+out_remove_vqs:
+	remove_common(vb);
+	return ret;
 }
-- 
2.45.0

