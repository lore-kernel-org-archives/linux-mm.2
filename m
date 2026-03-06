Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E38F513E9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 02:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A0A6B0005; Thu,  5 Mar 2026 21:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A317D6B0089; Thu,  5 Mar 2026 21:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DDF6B008A; Thu,  5 Mar 2026 21:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 855356B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 21:46:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D650B5867F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:46:18 +0000 (UTC)
X-FDA: 84514099236.05.8311B31
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf07.hostedemail.com (Postfix) with ESMTP id CEC294000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:46:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772765177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=IsqFA7t28SH6KGBE7qSp1y/8W+19i+dT2UaSAjzvihs=;
	b=F+vTNAd6R39L/6cF3nljzVVWm62wP+W32/8IGeIzx9X56hHuGuM4LhY+VInyvIpA875uzG
	0L8Zn9GSgvDaWD+w+8P8npw6G/5GXFIkYfVIPqUVt2HNwkMZy2PkGLRrSR1TEnYtj90CZL
	6x9AcQo7w1CXBAax/YTB45iEhtdN6bc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772765177; a=rsa-sha256;
	cv=none;
	b=7ZcmH1LppbqjiM4HBwomCTd4go6wIKq546ZAIrIK33cAlsTfguindmz09UEcISXWxq5tD+
	ADleVB9n2tPbcrHgZshgZ81MojtpUhVzoBu/6rmeql2+t2U8Bl8PaUcSrlDr4RWFCloYXS
	RN02vBer35Wobbom/Lo8VcJhfB0YIm8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 6 Mar 2026 11:46:11 +0900
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
Subject: [RFC PATCH v2] mm/swap, PM: hibernate: hold swap device reference across swap operation
Date: Fri,  6 Mar 2026 11:46:08 +0900
Message-Id: <20260306024608.1720991-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CEC294000B
X-Stat-Signature: kaon6bxe6fhx5aheaurjck9b6s3hbgrj
X-Rspam-User: 
X-HE-Tag: 1772765175-351970
X-HE-Meta: U2FsdGVkX1/J7TAjhsyMdFxDwkE+a29UAlaXMzJXdFvKM44qyHMho9krXnRx1jizMmySKYssyd87VHg2K4rrKJbLqMpzBCMGgaYtVoiSOhWPQE4KiQu+pCpls36Y/nME+G0ru2ZxxRDuvkK91E0se5I9G8nxe/UZAk5GvsyzTgVW9sY5lh0Y1CSK8LU/7YtEsiyvvTiCUec/i+Q3KLDIrNxS3edNeMRugpdZSBZivZOJyYOcNY0v+mMO2k6hGkYHCSj+PBecJJPEtp1v823qZ3BMWIPMCTrkRDqLDcen5auI8GTT1VVsrfLqpItmJgdyoOIn2Omz75uN3xNOnHYydFncaMfP204opAlvUX63x1VJ/d/kM9rAnMiq5pCs+YdcWSb7a5xmJdwJltUW+YY1BcEO0gXBqehZTzq7Oa+migr/scUeK3bqnFTOB8ipNx5FAbLO9GmBN+0cHYHpG7aCiibvK0it/RcZ6GRlcfiR9sjRqIkn0h/4BWowRfpL0vhFXBEuLEA1IOA9pTqfe97rNx1LH79tKG7WNE02ixrzdfpOVdo01zzoPK8Bq8SckdmUR/gBkWLh8V5HpF6qvNM7fpc9UQkho6llkDmuSbedI4bISwpgp9Fd6bhVjIeFvpdd6jgz1tgFQdCyZ9udQuIeoPLqvd77FvKM3EKZnSzIfnCjn4gxuAMzTx/mRw8x+Catb3LuNvAj785X60fzbzDlQ1fEZAxr0RDqxJu1OwnGV0Zvj+oXx6fh9d2y3Z2BpSBXIbADhGUCoZa56EsDc2rJCb3xhPl7B0ENOHhD5GPAsnEavtC3zvSp8qzFhYqO7a0CkAc4/TdE5sShrYGLIc+Nl94SJB28OCTIjq7NAGR6R92deeUTLmz/IkWbQQaT4puoQV+w5Bz08jCwzB7olGqq91iAd5u0mahybzyv/ubbmyML0atuNyhOjmoE1EGJqTZC8EHVho4UQft7PLI6lUo
 P/t58IUq
 1t7peEu/UQ7viq8rxLfSHsVbvprs2Y8qScoGgaWYBYc1DOWfNsuxk8EqCdVt/pkQXtKW1MsoFVLNxJPBQW70NdQivmdxHAda8llnIHj1zIj0GwzgusNfNB7T7KrjEGTd96ucVi/yGS867JFTN2bc3fLwm5ilBzNtboiNVfFcAk8WJXL1BUQaJQPnEMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, in the uswsusp path, only the swap type value is retrieved at
lookup time without holding a reference. If swapoff races after the type
is acquired, subsequent slot allocations operate on a stale swap device.

Additionally, grabbing and releasing the swap device reference on every
slot allocation is inefficient across the entire hibernation swap path.

Address these issues by holding the swap device reference from the point
the swap device is looked up, and releasing it once at each exit path.
This ensures the device remains valid throughout the operation and
removes the overhead of per-slot reference counting.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
Hi,
    
This is a simple RFC quality patch to verify if this approach is suitable.
Per Usama Arif's feedback regarding git bisectability,
I have squashed the previous commits into this single patch.

base-commit: ec96cb7e4c12ff5b474cf9ab66f2e9767953e448 (mm-new)

RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.arif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d

 include/linux/swap.h |  1 +
 kernel/power/swap.c  | 12 +++++++---
 kernel/power/user.c  |  9 +++++++-
 mm/swapfile.c        | 55 ++++++++++++++++++++++----------------------
 4 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..37bf7cf21594 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -442,6 +442,7 @@ extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+extern void put_swap_device_by_type(int type);
 sector_t swap_folio_sector(struct folio *folio);
 
 /*
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
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 915bc93964db..f505dd1f7571 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1860,6 +1860,10 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
+void put_swap_device_by_type(int type)
+{
+	percpu_ref_put(&swap_info[type]->users);
+}
 /*
  * Free a set of swap slots after their swap count dropped to zero, or will be
  * zero after putting the last ref (saves one __swap_cluster_put_entry call).
@@ -2085,30 +2089,28 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		goto fail;
 
 	/* This is called for allocating swap entry, not cache */
-	if (get_swap_device_info(si)) {
-		if (si->flags & SWP_WRITEOK) {
-			/*
-			 * Try the local cluster first if it matches the device. If
-			 * not, try grab a new cluster and override local cluster.
-			 */
-			local_lock(&percpu_swap_cluster.lock);
-			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
-			if (pcp_si == si && pcp_offset) {
-				ci = swap_cluster_lock(si, pcp_offset);
-				if (cluster_is_usable(ci, 0))
-					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-				else
-					swap_cluster_unlock(ci);
-			}
-			if (!offset)
-				offset = cluster_alloc_swap_entry(si, NULL);
-			local_unlock(&percpu_swap_cluster.lock);
-			if (offset)
-				entry = swp_entry(si->type, offset);
+	if (si->flags & SWP_WRITEOK) {
+		/*
+		 * Try the local cluster first if it matches the device. If
+		 * not, try grab a new cluster and override local cluster.
+		 */
+		local_lock(&percpu_swap_cluster.lock);
+		pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+		if (pcp_si == si && pcp_offset) {
+			ci = swap_cluster_lock(si, pcp_offset);
+			if (cluster_is_usable(ci, 0))
+				offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+			else
+				swap_cluster_unlock(ci);
 		}
-		put_swap_device(si);
+		if (!offset)
+			offset = cluster_alloc_swap_entry(si, NULL);
+		local_unlock(&percpu_swap_cluster.lock);
+		if (offset)
+			entry = swp_entry(si->type, offset);
 	}
+
 fail:
 	return entry;
 }
@@ -2116,14 +2118,10 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 /* Free a slot allocated by swap_alloc_hibernation_slot */
 void swap_free_hibernation_slot(swp_entry_t entry)
 {
-	struct swap_info_struct *si;
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_cluster_info *ci;
 	pgoff_t offset = swp_offset(entry);
 
-	si = get_swap_device(entry);
-	if (WARN_ON(!si))
-		return;
-
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
 	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
@@ -2131,7 +2129,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 	/* In theory readahead might add it to the swap cache by accident */
 	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-	put_swap_device(si);
 }
 
 /*
@@ -2160,6 +2157,7 @@ int swap_type_of(dev_t device, sector_t offset)
 			struct swap_extent *se = first_se(sis);
 
 			if (se->start_block == offset) {
+				get_swap_device_info(sis);
 				spin_unlock(&swap_lock);
 				return type;
 			}
@@ -2180,6 +2178,7 @@ int find_first_swap(dev_t *device)
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
 		*device = sis->bdev->bd_dev;
+		get_swap_device_info(sis);
 		spin_unlock(&swap_lock);
 		return type;
 	}
-- 
2.34.1


