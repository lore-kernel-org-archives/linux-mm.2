Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B02FF483C6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5F96B008A; Mon, 23 Mar 2026 12:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266A26B0092; Mon, 23 Mar 2026 12:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD726B008A; Mon, 23 Mar 2026 12:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E980C6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:08:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75DFD8CFBC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:08:31 +0000 (UTC)
X-FDA: 84577810422.06.AB0F21E
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4465940013
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:08:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774282109; a=rsa-sha256;
	cv=none;
	b=Hl6khna/rez7O5zgIhyUYxkl1lOrhOqJ5bv/5iwfJ++yLxSbk8b+vxTrMbIlNgnVH7Ve7A
	P4HWZXWBs2BwfpgJO2ctyToVmWt1C1cFsvlyCR5m8v9RMMEf7/TEOZ8P5vb5J/2QMcFAYC
	hSYonc8UxP1FJLY/DlvHOHKXNx90Zrs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774282109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h5AIqM4SiFKfpZg1cVItYk1tLZvkffCcFc95HVGclhQ=;
	b=xeivv4QbFzUwCL4AjVRz1ghHDd9FwIE5VsJusd+6N8eTpDSM9sllvW5Vz/tOn4UxJJZqkf
	gUQBVnKnkUq7xGk9RsOeG/BLJg9Jac2nF6g4xUYRbiWISCbpnE98eZkQ1Q7YZzkLiffRMH
	IrCM8vIZC9F/aoCgcv5ItUpt/+LDjGU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 24 Mar 2026 01:08:26 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: "Rafael J . Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Pavel Machek <pavel@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v8 1/2] mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device
Date: Tue, 24 Mar 2026 01:08:21 +0900
Message-Id: <20260323160822.1409904-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323160822.1409904-1-youngjun.park@lge.com>
References: <20260323160822.1409904-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4465940013
X-Stat-Signature: mfff53szp6yg1aehayb644wttk1mfz3o
X-HE-Tag: 1774282108-463389
X-HE-Meta: U2FsdGVkX18jYdAqRgvO0V3eUvt2OyZFv5DpyhUIuwpMOPP3AG3dOoVEFR2a2bNkZk3CkWeEEKkNV6GcCtN1PWM49S5fQfsSXeQBxa9vImKoxGH4XpnSRfGEmC0Ygi3RgctR5Fjpo1qmiLJH6JziK/2rkIhnMl9yFOJWYTom073esMQyvSKjBBwbDI6A4kF4dOLm9TNVIQN48gOP5pKNIWcXUXXdZsrEHm8vrB/6jB+8wtfWvP5iozAEi5+aEzT0PPlRd2Rg7bTtnIPI7zKqNiVAEs9wPYpgKxKVXLeFKePzvSIQiLsdHRxfrAvAiBohgbUV5ijtqRuf1f70dJrsz+dc9QybRxOsPD2Rxf9rQGLrWuswcZ29f2s0nGl9cexIDyiz7qPDLH6cC/gAYlvbldeCAwmfe+rWcU/nxMw5EcloDiX7JSfF9uRnw8MLombIZ7Ln+v+aAwfPZvEuhGBNlaGmFjQaGv7xZQtCtoOd9/gcK3xlJeJ0CX/FzuAhZgnz7aU7qDJke/bOUtdL+pWx84HCZmVHXfBbPlF2CQRXFxk+bGwt/UuigsC3i3vBoQ1n/Ut9UP0sLqlOhNlIYZaz6LfD75rOb0uLaPFZziyxtfg9vdwIRt1ZxTqryEoZbB85Eh6kCXKm6fXYi0qb+MyERyzdkO37d3RAClBgcjaIxuWq/Dy+Yh66GnbVeTd7B+/j8a+9t8bw9j7QPp0Ko/F+RA/o/+MVC774UHlGaDdQVpIDjV6bKcuygHk46Mm8qQd6247ZRAU2Y+oDy1HPjnugftXnHSHgPf9LMPurQ8kmNaAASub0qgW7jLpDf7O4BG/SG88FSvEk/E7rFJhJbgPdsZ2btdrPHRXz8ALUddwNbqJfZaBQ8nq9EajdX1kqnYa/485Ufg2GugWDL8GuihgX73+4NxjSc56lpwIuvd8sG/6wNNXgrQtA+eVGSq3Kd9wg4kfLJWWR9sGNnr6qtnf
 9Rmk6FWK
 uGxWoVSfLe5UhHU8ZTmvqA4XcQh8NBWJR7bMWhTgDNFKg55fe6KwAdtBrTjNLZ8iMN1RqNub0Q1VaW8fumsDssTz/W1kO8A5SEU0airWisb7ETAK8EDKENioRhe4mje9YcowQjF+ob0PhcUYKVHWZXyuHs81BBr4F45jr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hibernation via uswsusp (/dev/snapshot ioctls) has a race window:
after selecting the resume swap area but before user space is frozen,
swapoff may run and invalidate the selected swap device.

Fix this by pinning the swap device with SWP_HIBERNATION while it is
in use.  The pin is exclusive, which is sufficient since
hibernate_acquire() already prevents concurrent hibernation sessions.

The kernel swsusp path (sysfs-based hibernate/resume) uses
find_hibernation_swap_type() which is not affected by the pin.  It
freezes user space before touching swap, so swapoff cannot race.

Introduce dedicated helpers:
- pin_hibernation_swap_type(): Look up and pin the swap device.
  Used by the uswsusp path.
- find_hibernation_swap_type(): Lookup without pinning.
  Used by the kernel swsusp path.
- unpin_hibernation_swap_type(): Clear the hibernation pin.

While a swap device is pinned, swapoff is prevented from proceeding.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |   5 +-
 kernel/power/swap.c  |   2 +-
 kernel/power/user.c  |  15 ++++-
 mm/swapfile.c        | 135 ++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 136 insertions(+), 21 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..1930f81e6be4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -213,6 +213,7 @@ enum {
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
+	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
 					/* add others here before... */
 };
 
@@ -433,7 +434,9 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
-int swap_type_of(dev_t device, sector_t offset);
+extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
+extern void unpin_hibernation_swap_type(int type);
+extern int find_hibernation_swap_type(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 2e64869bb5a0..cc4764149e8f 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -341,7 +341,7 @@ static int swsusp_swap_check(void)
 	 * This is called before saving the image.
 	 */
 	if (swsusp_resume_device)
-		res = swap_type_of(swsusp_resume_device, swsusp_resume_block);
+		res = find_hibernation_swap_type(swsusp_resume_device, swsusp_resume_block);
 	else
 		res = find_first_swap(&swsusp_resume_device);
 	if (res < 0)
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4401cfe26e5c..4406f5644a56 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -71,7 +71,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	memset(&data->handle, 0, sizeof(struct snapshot_handle));
 	if ((filp->f_flags & O_ACCMODE) == O_RDONLY) {
 		/* Hibernating.  The image device should be accessible. */
-		data->swap = swap_type_of(swsusp_resume_device, 0);
+		data->swap = pin_hibernation_swap_type(swsusp_resume_device, 0);
 		data->mode = O_RDONLY;
 		data->free_bitmaps = false;
 		error = pm_notifier_call_chain_robust(PM_HIBERNATION_PREPARE, PM_POST_HIBERNATION);
@@ -90,8 +90,10 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 			data->free_bitmaps = !error;
 		}
 	}
-	if (error)
+	if (error) {
+		unpin_hibernation_swap_type(data->swap);
 		hibernate_release();
+	}
 
 	data->frozen = false;
 	data->ready = false;
@@ -115,6 +117,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	data = filp->private_data;
 	data->dev = 0;
 	free_all_swap_pages(data->swap);
+	unpin_hibernation_swap_type(data->swap);
 	if (data->frozen) {
 		pm_restore_gfp_mask();
 		free_basic_memory_bitmaps();
@@ -235,11 +238,17 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 		offset = swap_area.offset;
 	}
 
+	/*
+	 * Unpin the swap device if a swap area was already
+	 * set by SNAPSHOT_SET_SWAP_AREA.
+	 */
+	unpin_hibernation_swap_type(data->swap);
+
 	/*
 	 * User space encodes device types as two-byte values,
 	 * so we need to recode them
 	 */
-	data->swap = swap_type_of(swdev, offset);
+	data->swap = pin_hibernation_swap_type(swdev, offset);
 	if (data->swap < 0)
 		return swdev ? -ENODEV : -EINVAL;
 	data->dev = swdev;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 802332850e24..c5b459a18f43 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -133,7 +133,7 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
-	if (type >= MAX_SWAPFILES)
+	if (type < 0 || type >= MAX_SWAPFILES)
 		return NULL;
 	return READ_ONCE(swap_info[type]); /* rcu_dereference() */
 }
@@ -2138,22 +2138,15 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 	put_swap_device(si);
 }
 
-/*
- * Find the swap type that corresponds to given device (if any).
- *
- * @offset - number of the PAGE_SIZE-sized block of the device, starting
- * from 0, in which the swap header is expected to be located.
- *
- * This is needed for the suspend to disk (aka swsusp).
- */
-int swap_type_of(dev_t device, sector_t offset)
+static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 {
 	int type;
 
+	lockdep_assert_held(&swap_lock);
+
 	if (!device)
-		return -1;
+		return -EINVAL;
 
-	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
 		struct swap_info_struct *sis = swap_info[type];
 
@@ -2163,16 +2156,118 @@ int swap_type_of(dev_t device, sector_t offset)
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
 
-			if (se->start_block == offset) {
-				spin_unlock(&swap_lock);
+			if (se->start_block == offset)
 				return type;
-			}
 		}
 	}
-	spin_unlock(&swap_lock);
 	return -ENODEV;
 }
 
+/**
+ * pin_hibernation_swap_type - Pin the swap device for hibernation
+ * @device: Block device containing the resume image
+ * @offset: Offset identifying the swap area
+ *
+ * Locate the swap device for @device/@offset and mark it as pinned
+ * for hibernation. While pinned, swapoff() is prevented.
+ *
+ * Only one uswsusp context may pin a swap device at a time.
+ * If already pinned, this function returns -EBUSY.
+ *
+ * Return:
+ * >= 0 on success (swap type).
+ * -EINVAL if @device is invalid.
+ * -ENODEV if the swap device is not found.
+ * -EBUSY if the device is already pinned for hibernation.
+ */
+int pin_hibernation_swap_type(dev_t device, sector_t offset)
+{
+	int type;
+	struct swap_info_struct *si;
+
+	spin_lock(&swap_lock);
+
+	type = __find_hibernation_swap_type(device, offset);
+	if (type < 0) {
+		spin_unlock(&swap_lock);
+		return type;
+	}
+
+	si = swap_type_to_info(type);
+	if (WARN_ON_ONCE(!si)) {
+		spin_unlock(&swap_lock);
+		return -ENODEV;
+	}
+
+	/*
+	 * hibernate_acquire() prevents concurrent hibernation sessions.
+	 * This check additionally guards against double-pinning within
+	 * the same session.
+	 */
+	if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
+		spin_unlock(&swap_lock);
+		return -EBUSY;
+	}
+
+	si->flags |= SWP_HIBERNATION;
+
+	spin_unlock(&swap_lock);
+	return type;
+}
+
+/**
+ * unpin_hibernation_swap_type - Unpin the swap device for hibernation
+ * @type: Swap type previously returned by pin_hibernation_swap_type()
+ *
+ * Clear the hibernation pin on the given swap device, allowing
+ * swapoff() to proceed normally.
+ *
+ * If @type does not refer to a valid swap device, this function
+ * does nothing.
+ */
+void unpin_hibernation_swap_type(int type)
+{
+	struct swap_info_struct *si;
+
+	spin_lock(&swap_lock);
+	si = swap_type_to_info(type);
+	if (!si) {
+		spin_unlock(&swap_lock);
+		return;
+	}
+	si->flags &= ~SWP_HIBERNATION;
+	spin_unlock(&swap_lock);
+}
+
+/**
+ * find_hibernation_swap_type - Find swap type for hibernation
+ * @device: Block device containing the resume image
+ * @offset: Offset within the device identifying the swap area
+ *
+ * Locate the swap device corresponding to @device and @offset.
+ *
+ * Unlike pin_hibernation_swap_type(), this function only performs a
+ * lookup and does not mark the swap device as pinned for hibernation.
+ *
+ * This is safe in the sysfs-based hibernation path where user space
+ * is already frozen and swapoff() cannot run concurrently.
+ *
+ * Return:
+ * A non-negative swap type on success.
+ * -EINVAL if @device is invalid.
+ * -ENODEV if no matching swap device is found.
+ */
+int find_hibernation_swap_type(dev_t device, sector_t offset)
+{
+	int type;
+
+	spin_lock(&swap_lock);
+	type = __find_hibernation_swap_type(device, offset);
+	spin_unlock(&swap_lock);
+
+	return type;
+}
+
 int find_first_swap(dev_t *device)
 {
 	int type;
@@ -2936,6 +3031,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
+
+	/* Refuse swapoff while the device is pinned for hibernation */
+	if (p->flags & SWP_HIBERNATION) {
+		err = -EBUSY;
+		spin_unlock(&swap_lock);
+		goto out_dput;
+	}
+
 	if (!security_vm_enough_memory_mm(current->mm, p->pages))
 		vm_unacct_memory(p->pages);
 	else {
-- 
2.34.1


