Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAB0EB3621
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7BA6B0005; Mon,  2 Mar 2026 12:08:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1953A6B0088; Mon,  2 Mar 2026 12:08:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7F76B0089; Mon,  2 Mar 2026 12:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB4056B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:08:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93ACA139E2E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:08:55 +0000 (UTC)
X-FDA: 84501757830.02.02B27F0
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5A17020003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:08:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772471334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eowVWkDZteLVme9HHQR/4HxvmzY9/BY2mKWN865L3QU=;
	b=eAMy6Xy5MlwOtHewPEUxXSA6xywjwn04K2cUOx2GhfnAh0KYL09SENBOj9fsUpuK2o75LE
	Wfr4lQp1AYMP+bgogUalV0y5U8sr7WgiBy6+I8nMid2BrSL+4vu9jt264MO7hBZqQphNFr
	EfxXQtyBhFRqQUgCs8PP8PBCTcs0N90=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772471334; a=rsa-sha256;
	cv=none;
	b=eWOpt0CNA6UZLTkGhCJYGFjPA3pYXPcVOMO4t+UYniGDl9iU7BVT1JiYQe9LUR6n/1WwcD
	dJ+JRPp+fTYGcgoscz8jJfCZ4jcHkYHPu0lJSDFo+MoBHxs0j7VaaNjzNiQV6PToLsTRLX
	wDCv19iay115kMzTwBuzpl43QM/u8FU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 3 Mar 2026 01:53:39 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: linux-pm@vger.kernel.org
Cc: linux-mm@kvack.org,
	rafael@kernel.org,
	lenb@kernel.org,
	pavel@kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com
Subject: [RFC PATCH 2/2] kernel/power: hold swap device reference across hibernation swap operation
Date: Tue,  3 Mar 2026 01:53:34 +0900
Message-Id: <20260302165334.1278479-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260302165334.1278479-1-youngjun.park@lge.com>
References: <20260302165334.1278479-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A17020003
X-Stat-Signature: nutzix6b16s7oys8mqsyamciq8bzxwr1
X-Rspam-User: 
X-HE-Tag: 1772471332-1326
X-HE-Meta: U2FsdGVkX1+e1trBFqXGVedw8dwHnk3pfray81J7DS09QAY9saX9KZel3RIPHZOvpmuxzg3+H3xQiP+5L0gHZ0L+mUcY5/jaHKK7lEJS9/s2/wffLR46FuovMfcQxWO/+93Ltge3aoYWcVjKHAuRXwrxzaZIHrz0LJNw83HEdH1emvC8lTGplA57ee+LT2rtxjrU4hl7FH6KAyuw+sWaL+W9Ycfr9Aa7Yq+qOrald7pbJfvHqzpneKf/qGpcnweBt1zTz9PA7kCC4NGshQ7pYdAo+6R1/DyqJ05P3UbzhfO78WDL8BYm8HsaQnfwL4OfGknAhr0jwV/iuyE39WNS7+sWmAGVrsV0fKW3QKb+Ec+u6I306sc7h+iL48GQ9M6pF7MWQAJzWkx1Y07YpU5/DQV1sl8zaxBXc3NVaWP+cZov1evdcC4jpcz8SWBYEUzPhYVWNLczUec/1Ry9F3hEmWwKBnJKViHYotua4m4QaaeHLpafloD89kF7LlCeB0zbZsoQuhoA4Y0ZNxFSWUthA5ptanbwtk0/XDNbOPORJAs+nlxAovuLYLM1OUh6uhDSNhwqhbIRjOiArEEMBXPvHJFCSKQjr+5OjEdEnio7TJyUf8YRRE7HT7mJ+pBp664gsrkAl5nY1/SzH8EHzwb2U2zcP8/zqRpyXMZGg3KT1ks+BT9Q08IAY7/hMKd2407vVXYWImsuACbiYsz5mVYBULz9b4piMSbeYfvZZydT8HzCe211Ig37IthtVx0NpVfsIesAxDLhEYYHTvuX0wp6hQeDXj/hWNqcYxZPnq12zS42cNxneiR5DN3GKm6TpMNXPg6un4yxY64+6pf+BASPUoekeNXw4qiM9VcqmGAw/9TPrEt1CkDZbhZAJMVKPJbIbDpXmeCtAeaFyTuSzOk/v8OM/baCaJhcRW+XtLj6B23aYtRUsuFkPtWU1jTpG7U1ddC5SeC+SOqFTgFbBVZ
 WQAcgqgY
 wWfdMLBnOYJPN8c/r+h90Dc6MgF/GzW4907SlQYp7a8B8Ef1VRl3iQZ0LSPl58Jl5pEySJ3X8nAN9BXGhZbYD4RUoD6XE9Bqxtm3Xjh2rrOTrj9WDdh/ntTpFueX252dAgfxlMzRPkHPqvq+CZ3j28eVIcGF40i37fS7U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acquire the swap device reference at the point the swap device is looked
up and release it at each exit path, rather than grabbing and dropping it
on every slot allocation.

This also fixes a race where only the swap type value was retrieved at
lookup time without holding a reference. If swapoff raced after the type
was acquired, subsequent operations would reference a stale swap device.

put_swap_device_by_type() is now placed at all relevant cleanup paths in
both swap.c and user.c to ensure the reference is properly released when
the hibernation swap operation completes or fails.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 kernel/power/swap.c | 12 +++++++++---
 kernel/power/user.c |  9 ++++++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 2e64869bb5a0..c230b0fa5a5f 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -350,9 +350,10 @@ static int swsusp_swap_check(void)
 
 	hib_resume_bdev_file = bdev_file_open_by_dev(swsusp_resume_device,
 			BLK_OPEN_WRITE, NULL, NULL);
-	if (IS_ERR(hib_resume_bdev_file))
+	if (IS_ERR(hib_resume_bdev_file)) {
+		put_swap_device_by_type(root_swap);
 		return PTR_ERR(hib_resume_bdev_file);
-
+	}
 	return 0;
 }
 
@@ -418,6 +419,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
 err_rel:
 	release_swap_writer(handle);
 err_close:
+	put_swap_device_by_type(root_swap);
 	swsusp_close();
 	return ret;
 }
@@ -480,8 +482,11 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 		flush_swap_writer(handle);
 	}
 
-	if (error)
+	if (error) {
 		free_all_swap_pages(root_swap);
+		put_swap_device_by_type(root_swap);
+	}
+
 	release_swap_writer(handle);
 	swsusp_close();
 
@@ -1647,6 +1652,7 @@ int swsusp_unmark(void)
 	 * We just returned from suspend, we don't need the image any more.
 	 */
 	free_all_swap_pages(root_swap);
+	put_swap_device_by_type(root_swap);
 
 	return error;
 }
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4401cfe26e5c..9cb6c24d49ea 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -90,8 +90,11 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 			data->free_bitmaps = !error;
 		}
 	}
-	if (error)
+	if (error) {
 		hibernate_release();
+		if (data->swap >= 0)
+			put_swap_device_by_type(data->swap);
+	}
 
 	data->frozen = false;
 	data->ready = false;
@@ -115,6 +118,8 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	data = filp->private_data;
 	data->dev = 0;
 	free_all_swap_pages(data->swap);
+	if (data->swap >= 0)
+		put_swap_device_by_type(data->swap);
 	if (data->frozen) {
 		pm_restore_gfp_mask();
 		free_basic_memory_bitmaps();
@@ -235,6 +240,8 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 		offset = swap_area.offset;
 	}
 
+	if (data->swap >= 0)
+		put_swap_device_by_type(data->swap);
 	/*
 	 * User space encodes device types as two-byte values,
 	 * so we need to recode them
-- 
2.34.1


