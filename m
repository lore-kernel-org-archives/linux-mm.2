Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D201D105A586
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EB636B0088; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8F26B008C; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3026F6B0092; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC626B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0AD51A0190
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:25:19 +0000 (UTC)
X-FDA: 84537179958.09.3603B81
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf10.hostedemail.com (Postfix) with ESMTP id 35650C000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:25:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=temperror (imf10.hostedemail.com: error in processing during lookup of youngjun.park@lge.com: DNS error) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=temperror reason="SPF/DKIM temp error" header.from=lge.com (policy=temperror)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1ao8zdQrY2D5J5NFZFmGI49p2i3NwTYitYNy38HwEU=;
	b=eSdCiwK7pYxQCxJ0kwQDcUfOQ2NJB3ANPyLKsZGy9m68eHzyX6sCJZ595M/wIx/X3ZZKoz
	dR6qYiTSnZs1K8Efaw9im9dMreyp6o97BcwBzKpq0CGnEdDXU1tSZhvetuconXRM6bs9XH
	QpLY6O8ru2sztvwG2at1ss4ke12ODsk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=temperror (imf10.hostedemail.com: error in processing during lookup of youngjun.park@lge.com: DNS error) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=temperror reason="SPF/DKIM temp error" header.from=lge.com (policy=temperror)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314718; a=rsa-sha256;
	cv=none;
	b=c+oaQoDZaRvmDBO8w0HsX3kT7NZWvkOP4o3BkomvlgcbqN8F2GdRJz8LSQ0WPxzX91ok0J
	xyFSTIBhEwdf9fHfT5FlJRQWHmuoUKJ8DQbQPcwicyXPmHYilXcut6g9jD4ADHb9TwnVel
	+7nXWjnec2pVpt7kSSIufu3x1FjH2PI=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 12 Mar 2026 20:25:13 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: rafael@kernel.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	pavel@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	usama.arif@linux.dev,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RESEND RFC PATCH v3 1/2] mm/swap, PM: hibernate: fix swapoff race in uswsusp by getting swap reference
Date: Thu, 12 Mar 2026 20:25:10 +0900
Message-Id: <20260312112511.3596781-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312112511.3596781-1-youngjun.park@lge.com>
References: <20260312112511.3596781-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1pote89gyr51f6zxioito14d7gz1q3gm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 35650C000C
X-HE-Tag: 1773314716-614249
X-HE-Meta: U2FsdGVkX1991hjFpoWVeG8eTZFziH50jkAYuFUX5b5J9v+ttMBZwJpOysvBlXr6cOgFLPT/TGGhItNizCb/ASZ4RFBP5nt5UGTbix4mVcN8fZf1kHnn/Hkf4f9t7yPXczZo7cndrBxWzcbwh1V81/sCa3HyrEDvvAL63Fe+KRxyCRBMpXsbiobrOoZCPZcSVrYwTzb9SeGXfZCt+sY/gQWscTxLNUeNUd44v+dy41tpGMbCGZphFz+DdRL3LrsiY9v2OvmWjjb5gTFBVDb4NrW+YZ5vOWw/pg5T+9hWUa7+qJHSZKcO3ZkIIUplcbWYu1lHwaoDNy5ssDUCLNrVmu7smzej/InxLlCMT78Y4DdKa2o2gU9d7moUwjknGvvgJ4D5Qa8kw7UybcV/v/1lbk4Vh473ij6/ttiviRw5kuhY+cDNt7w4nFoIsFKiFmouLb4NYwPC5JQ5h52ya0w0neJVy2NiF5w2KpVghMBTTr4u6z9I26RzRArfPMEp2Rz7hhBuC+cKy1DbLsMZM6s/qY2bjiNv8eNQvmmEAFm6HIfHCOA6lB2Kvy8oDl5ChY17fkVx5N8eKPtR5N4iAw/327J3kLmDAVJxwZNjrYL44+nyDv7iBa90Qj9dvaN4uFGCmCaM7/2fZUCAC2UJ+jEbRYeZRVNcDNo2K44QQh3VrTp+4IJThbPozjhvS4bTsjqMRtdRWQXJCUpmTjdDj6KwooiTf4R2+/tcVMMe/5VfUWQLRU0vrC/sdhBdnF/0ZPjvKiQ00lpZ2M2pRvDaG9Jd/E977XXCh6m++sSzE2Nu1QjMXB5C41XXpbeg2OjQ7SlNvvstP18yJ2BrSip1Wn6ByTxoBhkm9P2wTG6jnbP34f0sITjmybeiiTGTSfIBVznh3/b60KI6Qc1r2s43rn4BJUglTrJYCn/HGYfOkRx2Wo0ShRZInaAEm/Z55PVvBQGGodqBEgCFcX/kHRYJ0KL
 VJeV5NDq
 4vhrpaD+2OfaalZWjC7q7Vbn1Wxk/9RGMmNeytXDRiikhpoBGLqTBI0QQBKTUDWjBMdTQKhZiV6bp6iljqpYhWBDauF1YUX64qBKT6hGuSvE9d/hvMhk05kM2l9w4O48PHjbEFuMeQdYy2f4hYxpj9WR8nNcIQI652Ot9ZwlFnlpvrqYBAyygYr52Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hibernation can be triggered either via the sysfs interface or via the
uswsusp utility using /dev/snapshot ioctls.

In the case of uswsusp, the resume device is configured either by the
boot parameter during snapshot_open() or via the SNAPSHOT_SET_SWAP_AREA
ioctl. However, a race condition exists between setting this swap area
and actually allocating a swap slot via the SNAPSHOT_ALLOC_SWAP_PAGE
ioctl. For instance, if swapoff is executed and a different swap device
is enabled during this window, an incorrect swap slot might be allocated.

Hibernation via the sysfs interface does not suffer from this race
condition because user-space processes are frozen before proceeding,
making it impossible to execute swapoff.

To resolve this race in uswsusp, modify swap_type_of() to properly
acquire a reference to the swap device using get_swap_device().

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |  3 ++-
 kernel/power/swap.c  |  2 +-
 kernel/power/user.c  | 11 ++++++++---
 mm/swapfile.c        | 28 +++++++++++++++++++++-------
 4 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..ecf19a581fc7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -433,8 +433,9 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
-int swap_type_of(dev_t device, sector_t offset);
+int swap_type_of(dev_t device, sector_t offset, bool ref);
 int find_first_swap(dev_t *device);
+void put_swap_device_by_type(int type);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 2e64869bb5a0..3a477914a7c4 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -341,7 +341,7 @@ static int swsusp_swap_check(void)
 	 * This is called before saving the image.
 	 */
 	if (swsusp_resume_device)
-		res = swap_type_of(swsusp_resume_device, swsusp_resume_block);
+		res = swap_type_of(swsusp_resume_device, swsusp_resume_block, false);
 	else
 		res = find_first_swap(&swsusp_resume_device);
 	if (res < 0)
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4401cfe26e5c..7ade4d0aa846 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -71,7 +71,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	memset(&data->handle, 0, sizeof(struct snapshot_handle));
 	if ((filp->f_flags & O_ACCMODE) == O_RDONLY) {
 		/* Hibernating.  The image device should be accessible. */
-		data->swap = swap_type_of(swsusp_resume_device, 0);
+		data->swap = swap_type_of(swsusp_resume_device, 0, true);
 		data->mode = O_RDONLY;
 		data->free_bitmaps = false;
 		error = pm_notifier_call_chain_robust(PM_HIBERNATION_PREPARE, PM_POST_HIBERNATION);
@@ -90,8 +90,10 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 			data->free_bitmaps = !error;
 		}
 	}
-	if (error)
+	if (error) {
+		put_swap_device_by_type(data->swap);
 		hibernate_release();
+	}
 
 	data->frozen = false;
 	data->ready = false;
@@ -115,6 +117,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	data = filp->private_data;
 	data->dev = 0;
 	free_all_swap_pages(data->swap);
+	put_swap_device_by_type(data->swap);
 	if (data->frozen) {
 		pm_restore_gfp_mask();
 		free_basic_memory_bitmaps();
@@ -235,11 +238,13 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 		offset = swap_area.offset;
 	}
 
+	put_swap_device_by_type(data->swap);
+
 	/*
 	 * User space encodes device types as two-byte values,
 	 * so we need to recode them
 	 */
-	data->swap = swap_type_of(swdev, offset);
+	data->swap = swap_type_of(swdev, offset, true);
 	if (data->swap < 0)
 		return swdev ? -ENODEV : -EINVAL;
 	data->dev = swdev;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d864866a35ea..5a3d5c1e1f81 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2149,7 +2149,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
  *
  * This is needed for the suspend to disk (aka swsusp).
  */
-int swap_type_of(dev_t device, sector_t offset)
+int swap_type_of(dev_t device, sector_t offset, bool ref)
 {
 	int type;
 
@@ -2163,13 +2163,16 @@ int swap_type_of(dev_t device, sector_t offset)
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
 
-		if (device == sis->bdev->bd_dev) {
-			struct swap_extent *se = first_se(sis);
+		if (device != sis->bdev->bd_dev)
+			continue;
 
-			if (se->start_block == offset) {
-				spin_unlock(&swap_lock);
-				return type;
-			}
+		struct swap_extent *se = first_se(sis);
+		if (se->start_block != offset)
+			continue;
+
+		if (ref && get_swap_device_info(sis)) {
+			spin_unlock(&swap_lock);
+			return type;
 		}
 	}
 	spin_unlock(&swap_lock);
@@ -2194,6 +2197,17 @@ int find_first_swap(dev_t *device)
 	return -ENODEV;
 }
 
+void put_swap_device_by_type(int type)
+{
+	struct swap_info_struct *sis;
+
+	if (type < 0 || type >= MAX_SWAPFILES)
+		return;
+
+	sis = swap_info[type];
+	put_swap_device(sis);
+}
+
 /*
  * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
  * corresponding to given index in swap_info (swap type).
-- 
2.34.1


