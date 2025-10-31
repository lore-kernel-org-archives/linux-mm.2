Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E02CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 19:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9D78E00E8; Fri, 31 Oct 2025 15:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A16C8E0068; Fri, 31 Oct 2025 15:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE2B8E00E8; Fri, 31 Oct 2025 15:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF398E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:36:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00EFBC0626
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:36:15 +0000 (UTC)
X-FDA: 84059415552.20.3B7C366
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 14BCA2000F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:36:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AdBzOUbl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761939374; a=rsa-sha256;
	cv=none;
	b=jVoiDlU8M9KHuI3rSN+NU+cAFM4AM5e3ojbVVIinxUH4iRj/M80iPy/pgYcJ8ske7Jixwj
	o9guMghOUNBlTVyDlNFYKdmThDZEuYigcgH7d87Ospe8uxrJ2PZ9MjeRGWF7zeVEbhKyE+
	GsD7lAeAobkpS36Wg16Q5ZTM+OzBK5c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AdBzOUbl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761939374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hs8WAha7zUb9hjupyXXbSI5TRA2qjGP9C7xrWD4lf7E=;
	b=muD6Y7LFGNYwikTtuDOhKSkQmdjQyywqhxH1Ijy2jsKBvPSEo/JDEB/2FX9LP8echMNJTG
	yqkRcCaS8EE5g2J50aXwl1VPP1n3jGtxU4yCbtURBrWY8WUwwTrlM/hautDLVtoJC12zJ3
	sB0UCeaOGABU0uQPDaDoQyJdXaLr1PA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761939373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hs8WAha7zUb9hjupyXXbSI5TRA2qjGP9C7xrWD4lf7E=;
	b=AdBzOUbldTp20rIpXEzZKaKLqb7/IMHI8KquX9KYFqb+dIH5J+NX8DvAW+Bh7tC77GXmOe
	N3B9HDdeChLIaOo34SFaikBo4ib6UmtpBIWUmJjQx2bxz1wxp5rZHTRieHOXGMqxJFPtc0
	mAAitaZjf/Kw/5GZ6lCIuc5ayxtWabE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-pxx5Wq6vOeu_hBgBjrPreQ-1; Fri,
 31 Oct 2025 15:36:09 -0400
X-MC-Unique: pxx5Wq6vOeu_hBgBjrPreQ-1
X-Mimecast-MFC-AGG-ID: pxx5Wq6vOeu_hBgBjrPreQ_1761939367
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9970E18002C1;
	Fri, 31 Oct 2025 19:36:06 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C2C430001A1;
	Fri, 31 Oct 2025 19:35:59 +0000 (UTC)
Date: Fri, 31 Oct 2025 20:35:56 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Askar Safin <safinaskar@gmail.com>
cc: Dell.Client.Kernel@dell.com, brauner@kernel.org, dm-devel@lists.linux.dev, 
    ebiggers@kernel.org, kix@kix.es, linux-block@vger.kernel.org, 
    linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, 
    linux-lvm@lists.linux.dev, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
    linux-raid@vger.kernel.org, lvm-devel@lists.linux.dev, agk@redhat.com, 
    msnitzer@redhat.com, milan@mazyland.cz, mzxreary@0pointer.de, 
    nphamcs@gmail.com, pavel@ucw.cz, rafael@kernel.org, ryncsn@gmail.com, 
    torvalds@linux-foundation.org
Subject: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device
 mapper devices
In-Reply-To: <de1f0036-84f9-2923-2c0a-620e702d850b@redhat.com>
Message-ID: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
References: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com> <20251027084220.2064289-1-safinaskar@gmail.com> <de1f0036-84f9-2923-2c0a-620e702d850b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14BCA2000F
X-Stat-Signature: 6znng66q9sw3nd35n7gouk1dfnzpgx5g
X-HE-Tag: 1761939373-179760
X-HE-Meta: U2FsdGVkX19rwSZb3CkfoxblGeMhSPKDPrAjpNDyIogpTnCRYeXaU0r2B+AxX8esSzgns2PwzNGO9m/p3JAAt0pJSi7om741xA8Q6vouHutdX2AMq3aWrXS8QTG43nZc0jNPhbgKMMDcUzQCi7mqP6sFCIrUlrLbE9o8GSyMpKCMjBOD+kdoeWEeGjIijLh/aNSgGtEt2crAoVPlOY1mY3RiAxdT/4veTKrTbIVIzXagnLfauvp1DTeqQhtUW/xwMgWr3P4oT6y7SqDxtdpZkt2Ua5a423fmBMpYb7CvCckwCj2N/iY40FQVDKt0IwERZ5inDVOB/oxIynR86uzBRCnAwsGo2ACXYm9m1AB6bTlcCTpdjy7RMn+K9jhSavLghAJf/mVvkaKR1WkP5JU9F7oubWx9jyMLoY1m4dD+1hriGa/bxY50ejf/3wg1KVW6hRdF2gOsQ4U79v2tm0lLNKNvrhuRG1lhthHguRox/G9/cMpW0aOVLXyQuv07ZS9zSmR+uEnEDCid5x3nGntSACpEUCRMSwtoB2TuNd+//MQh/m5rdVhY6by+3TxqkdBSKMqyDJUo5Fp25ORpPPpQeW9cmtp3xevFbu4SkNALjUykrmPi+nd+4uM8x48nvaOn8wT7quWkojQg6/QyWtibwRJ6YV/1CiXIZU9A3N4uy+aviBsUk+3ec8aPPlgjRtNvuNV75n43UuiYAHwoFLIICUpUkNSQ2TzWd/62JkjGeGHDjqf+JgWhC3L8/20ttUSblZOa4v9gieAUvNdBfNVN68zc7A0GzSaRUd+RRWKhKILmjQCVGvLLNqP8hIjSEqwybTtytPorP+ZyCOewY8AQn2/9PPJI5DZADPIz9/BR3wVgMgcuawYYh0STg6GtYiXJ+auHHSLhsiGR1+Ac0t8f4yxakRNe/5u29aEMs3l/J3eXtd8IO6VKQ1w6q2kHC5RhmKCk1vB4ylysRX61gGx
 jf+2vIsb
 vC4lgjqy7oQwVoNxHFraXJdmfqmAEkyhug+Dj92MNsLcCLKD01RbgNHVjegtc27xvuBvIBcqVh8i/WJvlbN6thnhSvBvQpyP4CkgoYC0wfQZ4JJ9z6CCraUZx37uhDpFSbrJ7dYN50IdqB8u2398s/7BPRLAyfUhmyHfyax7zV/0kCffbC+apUMUlG8o4ASjESKVOui8mdrnL715c94Yd4+Hs+pw8ggu1VS+O4YAtpOe5CDzcEFvUHIcRWFRtFLBWsQFjKodvHS9YhZ7Ci2Pmj7H6C3AUbxTwF6e1EjZF2imjNQa3t4QOVKREvc360GZpqYUgpg1YQwJ5ohji3949lMH8ecCpxbYD1IlddxUJgk5h4nUg5mZW6iwP8cvie7gwn0fbV9ye56chOQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Askar Safin requires swap and hibernation on the dm-integrity device mapper
target because he needs to protect his data.

This hits two problems:
1. The kernel doesn't send the flush bio to the hibernation device after
   writing the image and before powering off - this is easy to fix
2. The dm-integrity target keeps parts of the device in-memory - it keeps
   a journal and a dm-bufio cache in memory. If we hibernate and resume,
   the content of memory no longer matches the data on the hibernate
   partition and that may cause spurious errors - this is hard to fix

We cannot use register_pm_notifier - the problem is that device mapper
devices may depend on each other, forming a directed acyclic graph, and
we need to suspend them in the order of the graph. PM notifiers have no
notion of the graph - they have priority, but mapping the priorities to
the device dependency graph would be hard.

So I added a new method "hibernate" to struct block_device_operations. If
the method is NULL, the device doesn't need special treatment during
hibernation. If the method is non-NULL, the method is called on the swap
device where we are suspending - the method will clear in-memory
structures (in the case of dm-integrity, it will flush the journal and
invalidate the dm-bufio cache), so that when the machine is resumed, the
driver won't use stale data. Finally, the "hibernate" method calls itself
on subordinate devices, so that complex stack of device mapper devices is
handled correctly.

Hibernation is allowed only on targets that have DM_TARGET_HIBERNATE.
Hibernation on other targets is rejected because it may cause data
corruption. Previously, the kernel would allow hibernation on any DM
device, causing potential data corruption if the in-memory metadata
doesn't match the content of the swap device.

I am submitting this patch as a request for comment - I'd like to know if
you consider this approach correct or not. If you would like to solve the
hibernation problem in some other way, let me know.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Askar Safin <safinaskar@gmail.com>
Link: https://lore.kernel.org/dm-devel/a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com/T/

---
 drivers/md/dm-crypt.c         |    2 -
 drivers/md/dm-integrity.c     |   42 ++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-linear.c        |    2 -
 drivers/md/dm-stripe.c        |    3 +-
 drivers/md/dm.c               |   45 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h        |   12 +++++++++++
 include/linux/device-mapper.h |    6 +++++
 kernel/power/hibernate.c      |    4 +++
 kernel/power/power.h          |    2 +
 kernel/power/swap.c           |   20 ++++++++++++++++++
 10 files changed, 134 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -1676,6 +1676,11 @@ struct block_device_operations {
 	 * driver.
 	 */
 	int (*alternative_gpt_sector)(struct gendisk *disk, sector_t *sector);
+
+	/*
+	 * This invalidates the device cache when hibernating.
+	 */
+	int (*hibernate)(struct gendisk *disk);
 };
 
 #ifdef CONFIG_COMPAT
@@ -1875,4 +1880,11 @@ static inline int bio_split_rw_at(struct
 
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
 
+static inline int bdev_hibernate(struct block_device *bdev)
+{
+	if (!bdev->bd_disk->fops->hibernate)
+		return 0;
+	return bdev->bd_disk->fops->hibernate(bdev->bd_disk);
+}
+
 #endif /* _LINUX_BLKDEV_H */
Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -4053,6 +4053,45 @@ static void dm_integrity_io_hints(struct
 	limits->max_integrity_segments = USHRT_MAX;
 }
 
+static int dm_integrity_hibernate(struct dm_target *ti)
+{
+	struct dm_integrity_c *ic = ti->private;
+	int r;
+
+	timer_delete_sync(&ic->autocommit_timer);
+
+	if (ic->recalc_wq)
+		drain_workqueue(ic->recalc_wq);		/* !!! FIXME */
+
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
+
+	queue_work(ic->commit_wq, &ic->commit_work);
+	drain_workqueue(ic->commit_wq);
+
+	if (ic->mode == 'J') {
+		queue_work(ic->writer_wq, &ic->writer_work);
+		drain_workqueue(ic->writer_wq);
+		dm_integrity_flush_buffers(ic, true);
+		init_journal(ic, ic->free_section,
+			     ic->journal_sections - ic->free_section, ic->commit_seq);
+		if (ic->free_section) {
+			init_journal(ic, 0, ic->free_section,
+				     next_commit_seq(ic->commit_seq));
+		}
+	}
+
+	dm_bufio_client_reset(ic->bufio);
+
+	if (ic->meta_dev) {
+		r = bdev_hibernate(ic->meta_dev->bdev);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
 static void calculate_journal_section_size(struct dm_integrity_c *ic)
 {
 	unsigned int sector_space = JOURNAL_SECTOR_DATA;
@@ -5414,7 +5453,7 @@ static struct target_type integrity_targ
 	.name			= "integrity",
 	.version		= {1, 14, 0},
 	.module			= THIS_MODULE,
-	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
+	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY | DM_TARGET_HIBERNATE,
 	.ctr			= dm_integrity_ctr,
 	.dtr			= dm_integrity_dtr,
 	.map			= dm_integrity_map,
@@ -5424,6 +5463,7 @@ static struct target_type integrity_targ
 	.status			= dm_integrity_status,
 	.iterate_devices	= dm_integrity_iterate_devices,
 	.io_hints		= dm_integrity_io_hints,
+	.hibernate		= dm_integrity_hibernate,
 };
 
 static int __init dm_integrity_init(void)
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -3439,6 +3439,50 @@ out:
 	return ret;
 }
 
+static int __dm_hibernate(struct dm_target *ti, struct dm_dev *dev,
+			  sector_t start, sector_t len, void *data)
+{
+	return bdev_hibernate(dev->bdev);
+}
+
+static int dm_blk_hibernate(struct gendisk *disk)
+{
+	struct mapped_device *md = disk->private_data;
+	int srcu_idx;
+	struct dm_table *map;
+	int r = 0;
+
+	map = dm_get_live_table(md, &srcu_idx);
+	if (unlikely(!map))
+		goto out;
+
+	for (unsigned int i = 0; i < map->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(map, i);
+
+		if (!dm_target_supports_hibernate(ti->type)) {
+			r = -EOPNOTSUPP;
+			goto out;
+		}
+
+		if (ti->type->hibernate) {
+			r = ti->type->hibernate(ti);
+			if (r)
+				goto out;
+		}
+
+		if (ti->type->iterate_devices) {
+			r = ti->type->iterate_devices(ti, __dm_hibernate, NULL);
+			if (r)
+				goto out;
+		}
+	}
+
+out:
+	dm_put_live_table(md, srcu_idx);
+
+	return r;
+}
+
 struct dm_pr {
 	u64	old_key;
 	u64	new_key;
@@ -3768,6 +3812,7 @@ static const struct block_device_operati
 	.getgeo = dm_blk_getgeo,
 	.report_zones = dm_blk_report_zones,
 	.get_unique_id = dm_blk_get_unique_id,
+	.hibernate = dm_blk_hibernate,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
 };
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -142,6 +142,8 @@ typedef int (*dm_iterate_devices_fn) (st
 typedef void (*dm_io_hints_fn) (struct dm_target *ti,
 				struct queue_limits *limits);
 
+typedef int (*dm_hibernate_fn) (struct dm_target *ti);
+
 /*
  * Returns:
  *    0: The target can handle the next I/O immediately.
@@ -219,6 +221,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_hibernate_fn hibernate;
 	dm_dax_direct_access_fn direct_access;
 	dm_dax_zero_page_range_fn dax_zero_page_range;
 	dm_dax_recovery_write_fn dax_recovery_write;
@@ -309,6 +312,9 @@ struct target_type {
 #define DM_TARGET_ATOMIC_WRITES		0x00000400
 #define dm_target_supports_atomic_writes(type) ((type)->features & DM_TARGET_ATOMIC_WRITES)
 
+#define DM_TARGET_HIBERNATE		0x00000800
+#define dm_target_supports_hibernate(type) ((type)->features & DM_TARGET_HIBERNATE)
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -832,6 +832,10 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
+	error = notify_swap_device();
+	if (error)
+		goto Thaw;
+
 	lock_device_hotplug();
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -68,6 +68,8 @@ extern int hibernation_snapshot(int plat
 extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
 
+extern int notify_swap_device(void);
+
 #ifdef CONFIG_STRICT_KERNEL_RWX
 /* kernel/power/snapshot.c */
 extern void enable_restore_image_protection(void);
Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -1591,6 +1591,9 @@ int swsusp_check(bool exclusive)
 			error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC | REQ_FUA,
 						swsusp_resume_block,
 						swsusp_header);
+
+			/* Flush device-mapper related metadata */
+			bdev_hibernate(file_bdev(hib_resume_bdev_file));
 		} else {
 			error = -EINVAL;
 		}
@@ -1630,6 +1633,23 @@ void swsusp_close(void)
 	fput(hib_resume_bdev_file);
 }
 
+int notify_swap_device(void)
+{
+	int error;
+
+	error = swsusp_swap_check();
+	if (error)
+		return error;
+
+	error = bdev_hibernate(file_bdev(hib_resume_bdev_file));
+	if (error)
+		pr_err("Swap is on unsupported device\n");
+
+	swsusp_close();
+
+	return error;
+}
+
 /**
  *      swsusp_unmark - Unmark swsusp signature in the resume device
  */
Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -3770,7 +3770,7 @@ static struct target_type crypt_target =
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-	.features = DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_ZONED_HM | DM_TARGET_HIBERNATE,
 	.report_zones = crypt_report_zones,
 	.map    = crypt_map,
 	.status = crypt_status,
Index: linux-2.6/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-linear.c
+++ linux-2.6/drivers/md/dm-linear.c
@@ -204,7 +204,7 @@ static struct target_type linear_target
 	.version = {1, 5, 0},
 	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
 		    DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO |
-		    DM_TARGET_ATOMIC_WRITES,
+		    DM_TARGET_ATOMIC_WRITES | DM_TARGET_HIBERNATE,
 	.report_zones = linear_report_zones,
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c
+++ linux-2.6/drivers/md/dm-stripe.c
@@ -471,7 +471,8 @@ static struct target_type stripe_target
 	.name   = "striped",
 	.version = {1, 7, 0},
 	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
-		    DM_TARGET_ATOMIC_WRITES | DM_TARGET_PASSES_CRYPTO,
+		    DM_TARGET_ATOMIC_WRITES | DM_TARGET_PASSES_CRYPTO |
+		    DM_TARGET_HIBERNATE,
 	.module = THIS_MODULE,
 	.ctr    = stripe_ctr,
 	.dtr    = stripe_dtr,


