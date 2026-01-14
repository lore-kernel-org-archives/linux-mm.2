Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC0BD31A2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FDFC6B0096; Wed, 14 Jan 2026 03:52:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBA56B0098; Wed, 14 Jan 2026 03:52:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574B26B009B; Wed, 14 Jan 2026 03:52:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 445B86B0096
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:51 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 137461BB66
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:51 +0000 (UTC)
X-FDA: 84329954142.27.BD3D31C
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6F395140003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TnTOApi9;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380769; a=rsa-sha256;
	cv=none;
	b=WgZgXezh/V++fYL0gDASXCQ4yRx5r47a7/fqAO1Uffs+KtvNqu+ef/DysA5cvJLJGsUMAT
	tFWLxCUsuuEffL/46pYASD1CYIl/uv3+63MGUHXs9ezlCM5cOh22Ah2ikQCRBdBxJCY20e
	bZu0KQRN211eGgwIayu3mCf3g5jHxEY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TnTOApi9;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkrYA1tOx7DkpeW8XgsApRQxl0EKaXZdk0Npo4TW1Lg=;
	b=3GrEM3pAeKMckeu5wBA9bhDj832FewchSS5RpTDpjEaT54hNPU2CLflCNnG1PV9//DAwTi
	3AobDr7QcVRvz7MfPm2emp8YOQer9G8dgwOyT+hTmbR3SURYcM6SuWIicrFMpL+KZK8Dux
	+KuyvQZ395yBBNakqG32p+bHeZdRJNo=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee1939e70bso94975731cf.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380768; x=1768985568; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkrYA1tOx7DkpeW8XgsApRQxl0EKaXZdk0Npo4TW1Lg=;
        b=TnTOApi9fvW/dBKevquc7H4xf9lTmkKXc6+BlIHfq60itiFv0jMaiVlw1GZl5E3mbI
         IbJ8iuYIGqVizmHvnThMxbdLWg3iuv2qcob2lniG3uYv2H3eWC5hBg2+13XaVb2lfhTr
         1H7NnVxPAfvfii2g9Ziwwaz+lMDbIaFUSil8klj5NGMtjRwFFcmm9UuXUcswcBIynNgi
         46H5hHr2OEtsD+bHjLQSevDSVhMBQO/QZXEiezcn0oBRh6CyW/imzGmSUZqKX2KLsJsp
         22KeTNdLi9Ciwpvy7wVx9mqNbwHDlIJuy5hT3YooDypwBkG1aHnjkv/5JCAbxuVCJstm
         3RmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380768; x=1768985568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qkrYA1tOx7DkpeW8XgsApRQxl0EKaXZdk0Npo4TW1Lg=;
        b=IywmoO97DyfNDhzBRCJZqOS7+o89OHibji7p92dgICbyFKDurDj9ZNzyfg8ZH1u23G
         09/U4ILYF/7YXNBGVVZ/jzmGc2p8fDrpIly6TIoTtvcR9Hz4d8rZ3Aovyl6iJCp5kFyw
         4wtlebRGtAQiIQI0jhOcxgtXR/qu49vK1dM7eVUNmg0vU+U1BFteVLujUBqgQ0zRcwZH
         86UmHt6wov+EkKTZ5TXS18YoVpqndkb6KUL75QbHEkemFEv5qZp0vRDt9X+Zgp/+pYUX
         X227cWdllyl8B5rVTTFbIRmahDQCe7Xctjc3xVharxxRG6VAQIQNdIcSRFHS3OiK45TK
         nksg==
X-Gm-Message-State: AOJu0Yz4uzeRLo1EKNca3MB8xJ+RbwNSpqIbiLcWqJADJ1lfgqTYjnWt
	EhdZrMGaQF+DIublDzWr3jQbjHBZi+pdHwDKlYXfLikcnu8Tt8goD7Za04ljhBF7AutmHqOlTkX
	foLznh4Q=
X-Gm-Gg: AY/fxX4eY7p6SsmbC6rb0p8u9yawJHCbbTp71jvr/dDd7/zpWXfpocN6Q6AIUUMBhGj
	mjHHLLhHGfT1g6hwkKo9Tv+r+Z4uO5K86lbNl5AaT7Us19e+piXPXSvOVjvIiNbiXr8FGZcNWFO
	9Su2JJ/Zuegktz+4dWxeNUbdnQu8ssr8EREn4qzNvYdjCYYLxfXseqOJoobOChejlt3pIaxuPne
	nIIyP+4vr61fmxXja8K7QC2T7GUbcb2OaH6MH23lj6mr57pxH2+keifVEqcH7CD8xE6bHAdTWHj
	zU7EAW1v5fUEzbo8txCLyayY/84A2LP1J8uZVAIckk9NWe1V0pmqYbjNxP9ALATQcPVnFvTWs0F
	6J+UgJNrV87RMgK8YUQsenzdc9n3xrvpZaP4GvY/jJJp+/MIWFcdw/9+4drP9xt1eHh72hqi6e0
	39nmiFDFx3Tr8sjdOXPYB1z1SJm462CXfuUSJB2OP0aWdvxF3Cjs5eReRFlzsQShwgBL1pCNZ0X
	ds=
X-Received: by 2002:a05:622a:50f:b0:501:4996:8e73 with SMTP id d75a77b69052e-5014a967795mr12209691cf.66.1768380768198;
        Wed, 14 Jan 2026 00:52:48 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:47 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] dax/kmem: add memory notifier to block external state changes
Date: Wed, 14 Jan 2026 03:52:00 -0500
Message-ID: <20260114085201.3222597-9-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m6783dmh89s66wnmn8w6hj71yx1yex11
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F395140003
X-Rspam-User: 
X-HE-Tag: 1768380769-892932
X-HE-Meta: U2FsdGVkX1+DJXlICXwye79C1ZmH7YGT+kCYV0MuUfuFqaGYPts0t1Qmao5qtRqpCJT/PK9CroKMPyYZxbS0wHHkeEzKoLpDULmu/rDHbs6NwN+pXshiJ5ub1y1XUW58zyR8sqz3R95/2at+SjdWyX6ifhIsNjG3DYrsT2kP4+s7aO8vYcRKdYH/0J7R6pMsfGI1HDk/JkkoyOj7chySz1Z0qn7gJWhoAbW/JdImjgzheuvfZJsQrBGYkewcEzDhzaSGevSVip7gUMCDBwmyY9JoIZlnbKdBdBvgHH41tx4p9cLj1OD+WBpwgyWOc6LrIB85VvAVIrKoW3V2kg/qcQbEQs0iFFSf1a2B0aZ/w0DA/Pes1dAPhCzkW1YmfEAW5DtiGGdRUZ6Fu5y4MtEcfI5ChGsMkVGDJA/czoBqvmeuBZgtIz9AIBhi18PT+ApykLVa9axRcgtg8NJR6VzPE7ej77fWqkpSwx/DDbeKOWW6eds6JuwetuTdfSD4JNJsDvOi9Vpewyd332PhNkD9XMT/ppYuG7sTEEcvtiGKvB85GmQ8usFagPCKlZx9MjChRLmLgJlO5UvaatFjoTbi9fN8gNbLoyhk387R76TMCbaeEWkWutvBR+K0IENmP70JJAn9gyaXQRryONakNcdoqa9/rEGG/yRm4hBg0rKoB5L+gFbL2swLGq+PrHJug3iRl7vJcthExIyS+aETdlnDfCcNlXaO0/2Yx2k0qrwYrXuo1B0ByHsbxTmCjXYg7Zr8gdyy0o7NEe8vNPPLe6PzIEGSBbWbbrTUiOxBwz9kzEvkgaD5633QpCxJZVPqt4RuurO0CI1PAcCaJzFG/o4Std8ATFvDlyvD3VntygslKlsJpZnRlhQOVJe35SAglzIRg6MbS/MdMH9gyGvK7DrSTUyTp47+jTyLnM9KVjJltZcQ6e1ziMpCbZCY9YyHGtSNT/JqfcFqGqGiFeztK5l
 Oow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a memory notifier to prevent external operations from changing the
online/offline state of memory blocks managed by dax_kmem. This ensures
state changes only occur through the driver's hotplug sysfs interface,
providing consistent state tracking and preventing races with auto-online
policies or direct memory block sysfs manipulation.

The notifier uses a transition protocol with memory barriers:
  - Before initiating a state change, set target_state then in_transition
  - Use a barrier to ensure target_state is visible before in_transition
  - The notifier checks in_transition, then uses barrier before reading
    target_state to ensure proper ordering on weakly-ordered architectures

The notifier callback:
  - Returns NOTIFY_DONE for non-overlapping memory (not our concern)
  - Returns NOTIFY_BAD if in_transition is false (block external ops)
  - Validates the memory event matches target_state (MEM_GOING_ONLINE
    for online operations, MEM_GOING_OFFLINE for offline/unplug)
  - Returns NOTIFY_OK only for driver-initiated operations with matching
    target_state

This prevents scenarios where:
  - Auto-online policies re-online memory the driver is trying to offline
  - Users manually change memory state via /sys/devices/system/memory/
  - Other kernel subsystems interfere with driver-managed memory state

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 164 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 160 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 6d73c44e4e08..b604da8b3fe1 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -53,6 +53,9 @@ struct dax_kmem_data {
 	struct dev_dax *dev_dax;
 	int state;
 	struct mutex lock; /* protects hotplug state transitions */
+	bool in_transition;
+	int target_state;
+	struct notifier_block mem_nb;
 	struct resource *res[];
 };
 
@@ -71,6 +74,116 @@ static void kmem_put_memory_types(void)
 	mt_put_memory_types(&kmem_memory_types);
 }
 
+/**
+ * dax_kmem_start_transition - begin a driver-initiated state transition
+ * @data: the dax_kmem_data structure
+ * @target: the target state (MMOP_ONLINE, MMOP_ONLINE_MOVABLE, or MMOP_OFFLINE)
+ *
+ * Sets up state for a driver-initiated memory operation. The memory notifier
+ * will only allow operations that match this target state while in transition.
+ * Uses store-release to ensure target_state is visible before in_transition.
+ */
+static void dax_kmem_start_transition(struct dax_kmem_data *data, int target)
+{
+	data->target_state = target;
+	smp_store_release(&data->in_transition, true);
+}
+
+/**
+ * dax_kmem_end_transition - end a driver-initiated state transition
+ * @data: the dax_kmem_data structure
+ *
+ * Clears the in_transition flag after a state change completes or aborts.
+ */
+static void dax_kmem_end_transition(struct dax_kmem_data *data)
+{
+	WRITE_ONCE(data->in_transition, false);
+}
+
+/**
+ * dax_kmem_overlaps_range - check if a memory range overlaps with this device
+ * @data: the dax_kmem_data structure
+ * @start: start physical address of the range to check
+ * @size: size of the range to check
+ *
+ * Returns true if the range overlaps with any of the device's memory ranges.
+ */
+static bool dax_kmem_overlaps_range(struct dax_kmem_data *data,
+				    u64 start, u64 size)
+{
+	struct dev_dax *dev_dax = data->dev_dax;
+	int i;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+		struct range check = DEFINE_RANGE(start, start + size - 1);
+
+		if (dax_kmem_range(dev_dax, i, &range))
+			continue;
+
+		if (!data->res[i])
+			continue;
+
+		if (range_overlaps(&range, &check))
+			return true;
+	}
+	return false;
+}
+
+/**
+ * dax_kmem_memory_notifier_cb - memory notifier callback for dax kmem
+ * @nb: the notifier block (embedded in dax_kmem_data)
+ * @action: the memory event (MEM_GOING_ONLINE, MEM_GOING_OFFLINE, etc.)
+ * @arg: pointer to memory_notify structure
+ *
+ * This callback prevents external operations (e.g., from sysfs or auto-online
+ * policies) on memory blocks managed by dax_kmem. Only operations initiated
+ * by the driver itself (via the hotplug sysfs interface) are allowed.
+ *
+ * Returns NOTIFY_OK to allow the operation, NOTIFY_BAD to block it,
+ * or NOTIFY_DONE if the memory doesn't belong to this device.
+ */
+static int dax_kmem_memory_notifier_cb(struct notifier_block *nb,
+				       unsigned long action, void *arg)
+{
+	struct dax_kmem_data *data = container_of(nb, struct dax_kmem_data,
+						  mem_nb);
+	struct memory_notify *mhp = arg;
+	const u64 start = PFN_PHYS(mhp->start_pfn);
+	const u64 size = PFN_PHYS(mhp->nr_pages);
+
+	/* Only interested in going online/offline events */
+	if (action != MEM_GOING_ONLINE && action != MEM_GOING_OFFLINE)
+		return NOTIFY_DONE;
+
+	/* Check if this memory belongs to our device */
+	if (!dax_kmem_overlaps_range(data, start, size))
+		return NOTIFY_DONE;
+
+	/*
+	 * Block all operations unless we're in a driver-initiated transition.
+	 * When in_transition is set, only allow operations that match our
+	 * target_state to prevent races with external operations.
+	 *
+	 * Use load-acquire to pair with the store-release in
+	 * dax_kmem_start_transition(), ensuring target_state is visible.
+	 */
+	if (!smp_load_acquire(&data->in_transition))
+		return NOTIFY_BAD;
+
+	/* Online operations expect MEM_GOING_ONLINE */
+	if (action == MEM_GOING_ONLINE &&
+	    (data->target_state == MMOP_ONLINE ||
+	     data->target_state == MMOP_ONLINE_MOVABLE))
+		return NOTIFY_OK;
+
+	/* Offline/hotremove operations expect MEM_GOING_OFFLINE */
+	if (action == MEM_GOING_OFFLINE && data->target_state == MMOP_OFFLINE)
+		return NOTIFY_OK;
+
+	return NOTIFY_BAD;
+}
+
 /**
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
@@ -375,11 +488,27 @@ static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
 	if (data->state == online_type)
 		return len;
 
+	/*
+	 * Start transition with target_state for the notifier.
+	 * For unplug, use MMOP_OFFLINE since memory goes offline before removal.
+	 */
+	if (online_type == DAX_KMEM_UNPLUGGED || online_type == MMOP_OFFLINE)
+		dax_kmem_start_transition(data, MMOP_OFFLINE);
+	else
+		dax_kmem_start_transition(data, online_type);
+
 	if (online_type == DAX_KMEM_UNPLUGGED) {
+		int expected = 0;
+
+		for (rc = 0; rc < dev_dax->nr_range; rc++)
+			if (data->res[rc])
+				expected++;
+
 		rc = dax_kmem_do_hotremove(dev_dax, data);
-		if (rc < 0) {
+		dax_kmem_end_transition(data);
+		if (rc < expected) {
 			dev_warn(dev, "hotplug state is inconsistent\n");
-			return rc;
+			return rc == 0 ? -EBUSY : -EIO;
 		}
 		data->state = DAX_KMEM_UNPLUGGED;
 		return len;
@@ -387,9 +516,12 @@ static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
 
 	if (online_type == MMOP_OFFLINE) {
 		/* Can only offline from an online state */
-		if (data->state != MMOP_ONLINE && data->state != MMOP_ONLINE_MOVABLE)
+		if (data->state != MMOP_ONLINE && data->state != MMOP_ONLINE_MOVABLE) {
+			dax_kmem_end_transition(data);
 			return -EINVAL;
+		}
 		rc = dax_kmem_do_offline(dev_dax, data);
+		dax_kmem_end_transition(data);
 		if (rc < 0) {
 			dev_warn(dev, "hotplug state is inconsistent\n");
 			return rc;
@@ -401,14 +533,18 @@ static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
 	/* online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE */
 
 	/* Cannot switch between online types without offlining first */
-	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE) {
+		dax_kmem_end_transition(data);
 		return -EBUSY;
+	}
 
 	if (data->state == MMOP_OFFLINE)
 		rc = dax_kmem_do_online(dev_dax, data, online_type);
 	else
 		rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
 
+	dax_kmem_end_transition(data);
+
 	if (rc < 0)
 		return rc;
 
@@ -490,12 +626,25 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 
 	dev_set_drvdata(dev, data);
 
+	/* Register memory notifier to block external operations */
+	data->mem_nb.notifier_call = dax_kmem_memory_notifier_cb;
+	rc = register_memory_notifier(&data->mem_nb);
+	if (rc) {
+		dev_warn(dev, "failed to register memory notifier\n");
+		goto err_notifier;
+	}
+
 	/*
 	 * Hotplug the memory using the system default online policy.
 	 * This preserves backwards compatibility for existing users who
 	 * rely on auto-online behavior.
+	 *
+	 * Start transition with resolved system default since the notifier
+	 * validates the operation type matches.
 	 */
+	dax_kmem_start_transition(data, mhp_get_default_online_type());
 	rc = dax_kmem_do_hotplug(dev_dax, data, MMOP_SYSTEM_DEFAULT);
+	dax_kmem_end_transition(data);
 	if (rc < 0)
 		goto err_hotplug;
 	/*
@@ -511,6 +660,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	return 0;
 
 err_hotplug:
+	unregister_memory_notifier(&data->mem_nb);
+err_notifier:
 	dev_set_drvdata(dev, NULL);
 	memory_group_unregister(data->mgid);
 err_reg_mgid:
@@ -538,12 +689,15 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	 * there is no way to hotremove this memory until reboot because device
 	 * unbind will succeed even if we return failure.
 	 */
+	dax_kmem_start_transition(data, MMOP_OFFLINE);
 	success = dax_kmem_do_hotremove(dev_dax, data);
+	dax_kmem_end_transition(data);
 	if (success < dev_dax->nr_range) {
 		dev_err(dev, "Hotplug regions stuck online until reboot\n");
 		return;
 	}
 
+	unregister_memory_notifier(&data->mem_nb);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
 	kfree(data);
@@ -561,8 +715,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
 	device_remove_file(dev, &dev_attr_hotplug);
+	unregister_memory_notifier(&data->mem_nb);
 
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
-- 
2.52.0


