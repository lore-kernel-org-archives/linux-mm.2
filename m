Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF102D3CC8B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D086B0093; Wed, 14 Jan 2026 18:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00AAC6B0095; Wed, 14 Jan 2026 18:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E569D6B0096; Wed, 14 Jan 2026 18:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D671C6B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:51:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 906E11AC9B6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:11 +0000 (UTC)
X-FDA: 84332217942.26.F9259B1
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id D2F2E1C000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XPv2CjW0;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768434669; a=rsa-sha256;
	cv=none;
	b=LUrjhJvMx8HtEf6IuaU0R8kOjQk+fyn8FiV/zKCo2Y6El15dcNCj2I2oiulLpM6eQtRwo4
	bN05TPr7kAD0rlE4ruu3yfdPoAdcE5S9n8W3M3v+LE57MpK/tcTeUJtc2QtMS84XiO58w+
	d5P3yENn4pcmz585FdskfZwlYan3hFA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XPv2CjW0;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768434669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6NjMNgXdh9z9NOdem2QceXvpTYCSkYsdbHZHUdgJ+E=;
	b=lG8n85TiBgiewjGF+b5L/Y6vSXFtoJt0zIG8KTVCalE6lm9N5NEJOL3W8RS+akj3fVfyfj
	SK7rLLijeAkpwf8g5Veqvfb/Y+VGB8to1PzGkYggDcrjpm7XYpoYr8JNAeTXyvcWt4o7Rx
	C7L0DJdgnxiVK+W8mn/Nxlc0bj6qvEU=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88888c41a13so3863116d6.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434669; x=1769039469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6NjMNgXdh9z9NOdem2QceXvpTYCSkYsdbHZHUdgJ+E=;
        b=XPv2CjW0yc7K0WrflVCGUTQfKPW7kX54EQ+bjmpFCY14LpJMdsD3LvizBBsjB+1eXP
         HU+rO6uX4yGx46DoNeFKnZhNVWS2b+rLeUmXR62YR9fZc8zSlce9/DxyojBnN2rwMUez
         vjLIyjiWXxxtSvotMastdPY+LdtPgI5YS7McNbcIvHHqV3hREZHtM86IUg/wG7fXQx5T
         8b2Grd0CZ/lph/hEJWTfTBDqUsUeb5HgIC7p0Y7k6VZLagTZiUXVWe85H/vY9E+Xd6XL
         4bd+y+gRsxMdjHt6aJONQW4O76CwuVwWgMp9dAGxohzE7q/akoDKupufN6ef7gXVj9WQ
         cpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434669; x=1769039469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D6NjMNgXdh9z9NOdem2QceXvpTYCSkYsdbHZHUdgJ+E=;
        b=PJJcemBG0ppZdY+7ezginEMbchG4hClkfrdBa+rG1nJ+L1tSHNnClWT5Ws/MbsxNbO
         S1c9qIxmc+z+8uI+cEcz3nbNoN1e4AadEEYvLGkVMnWJVrq9+ANkR5oLU9fcdYZV6zMr
         e31x3qvXRqvetZnH7l8H8HFhLKXQhlZMzr8GeBrpJ/whCzF1uM0stRu8dj3AIJYbXW4k
         kB+QWnrVjG0UY2dJU31K1BgEgCVoXlGd82IXkaLdYkhQODHYnd+25mrGabusdVrinEDo
         wrvGkHf/pLPWOdVU+EWLC2dnvKASFBCVmNEaR1hzV/awV54dIIRnPfLwK88gvJ+UTI03
         cYbg==
X-Gm-Message-State: AOJu0YwuT+k4zSpF94qlzxDyA5pPJ6r83QWEj9EgarFOpyvsOdrLQpbZ
	9k5lzCTgPh3ggY7bGj+o1FPSrOvwbYagR/YmwhcpQrDF9FoqlyA7DzCJjDSGfvPOZxEmQsYcyJB
	rutNc4B4=
X-Gm-Gg: AY/fxX4ymeCAL5A/wblZmjvcHeFFygg3djTpHqGrACkeoBW0LC5IPHzVaimTJr5gBuO
	CVHmCkh5nwEy18i+j8HDzJ/z4LeTWWzeVyV9Te/fKlywGX88rukwXVghg2pC/BGkW02YcVob5OV
	oDe/GDmvL1+YJ5Tl7M2fY5BQmz2qiz02spgdmg5i1y/HL4rg/sOyV42b7UGj6/PUB19HQ5vYOmH
	eRZBtDwpw+BBAdUW4oapenDFEXxOvyQDJcfQMX7WJmO//G1yIiWdETfzAes6zGTjIDTTRbTIBuC
	dKEWtE/fudMJa0nF6qgHrKFHJQ1AokvDDpmqr1An4gf2K5U/fwpUHSGicXy7UL375pS2bnovwpP
	OT9Ws7Uvz6FXoRweOuwVZ5t3bma/Qor/2U9Y/p3uXnnnolTRcOCRgjWmV1gKin9OHq53hTJn9uX
	hbwkZwzbSjazpB1GbEAqJu9MnAbdmld+hpmQkcggkN+3v4BC8Gl+Id5saFgKfCWC4+1jVzQX/qA
	AE=
X-Received: by 2002:a05:6214:2123:b0:882:6797:3a67 with SMTP id 6a1803df08f44-89275ad80acmr64527286d6.13.1768434668684;
        Wed, 14 Jan 2026 15:51:08 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:51:07 -0800 (PST)
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
	akpm@linux-foundation.org
Subject: [PATCH v2 5/5] dax/kmem: add memory notifier to block external state changes
Date: Wed, 14 Jan 2026 18:50:21 -0500
Message-ID: <20260114235022.3437787-6-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pq5w6tf7x4wmabzkxjogqi7xdb7txxx7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D2F2E1C000D
X-Rspam-User: 
X-HE-Tag: 1768434669-828930
X-HE-Meta: U2FsdGVkX18RiCCIsiR32sjjrnPxgWxw2wQUckLkToqTIWvGhunp4sC6fVfpngkcO6rawkFkAOGCA8ItqdRM6jJm0AW4W6lzNb/QhqCfzaa1E5WEaq47FSiDwVZy8xpRkps3xiAbUhXrL1AaZp4AivzWzfRaPOUjcuAF/SrV3jkkYTQzp2W5B5/ijQAc+E9EbYgxFAYUWMSGvnEvaeHJJSXPKMiMxC1S7FRiRrNz/NxNmtRXE/EhJUaDqcXjH8Ujc5dtcNSRs95es+uY7g2Zp2Q7C45o3B3jZoQo0CMPvQ29hoGI1knX9pXyphDtxzUdKXFXYy9ZeLnBK4emTyb0VTgkeF5TYHlh2SR3Kpj/E8MbsAYMQVZDlYJhPe2HQxquQPwt2FzLXSE3rzAxrB6PHpqUY+heOlfOGLKtGbEKnDtDU9vlxWLwzkSxrQP6V6s6Wke902wZ0BGyG8fgVlrs9/VEDzGhY0J7/2iDDiKeM8+azoiNQ5X/+Z2tKU0/AMQ0Di83byM5WX7TYdBkjM4E8Lv6dIQvdeZUP7mzJApDq7eatXw/8d3lfbC6UaWCBPSLZyjw8E8HandI1uSZtCRxH4sREEM5MuULVFmKzKOdcQsmf5iDDO0aTwQrtycruTjsQilbZUWxKGBX0Q/5kP9JiOU50UlOIRGRon0cWI/BOtTb+LKaOk987/DuZhpzr5Kt0414xsCJRJ70yAFGI6BLxOm2obeS11cDjaZZt62Ywg6r+8wzFa8cgbJa6Np9zWHp89T0SxB68K3v1WS6Q7rVNNkE+GkcfhlY75VYoOxk+PUnvEYb+xH5Yhqi08xUNgWOJVaOUSHcvfnx+mX2Vr78uzrjzgdlgXyWpRLJg/tnJz5P0PQo1YjPq7XXyicI9GXtv7eJJctAFHapeJbBkHr5nldtBMnBAoOgF4Su1GIRuSA4JCAmoftsZdyu+88hyYKtru/qYSJz0+SClW82MLr
 FWo1jGmD
 AGD9r5kl9ch/+Pa4+UMqcTMOciU20ZqcRfKUKZqZVmXQhdrrSIROIZC1n/DcPCWp6bCgmBI1sVDCfzgUTya6kOY5mijijirL0Ce4NZN96MG3sjlb6HorNj14uYev082ax/Nd07WSW1x5ne/uwrQoVg/a6m9i57rOOJcNU4iYJFGniKjic5KnIzQNlJbmDpQznD1l16t3xZxBpqMifhLofWdtPeH3c25qeSYwF7Jl3LhSdQVgWlqw6ezxnVW0ejF4QiUO2vHKN2+3RSQ5WRlH8cQjWNq3oK1fFFjdj6sMfXxA0zayNaca5UYRnsA==
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

The goal of this is to prevent `daxN.M/hotplug` from becoming
inconsistent with the state of the memory blocks it owns.

The notifier uses a transition protocol with memory barriers:
  - Before initiating a state change, set target_state then in_transition
  - Use barrier to ensure target_state is visible before in_transition
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
  - Users manually change memory state via /sys/devices/system/memory/
  - Other kernel subsystems interfere with driver-managed memory state
    (may be important for regions trying to preserve hot-unpluggability)

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 157 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c222ae9d675d..f3562f65376c 100644
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
@@ -325,11 +438,27 @@ static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
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
@@ -339,10 +468,14 @@ static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
 	 * online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE
 	 * Cannot switch between online types without unplugging first
 	 */
-	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE) {
+		dax_kmem_end_transition(data);
 		return -EBUSY;
+	}
 
 	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	dax_kmem_end_transition(data);
+
 	if (rc < 0)
 		return rc;
 
@@ -430,13 +563,26 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_resources;
 
+	/* Register memory notifier to block external operations */
+	data->mem_nb.notifier_call = dax_kmem_memory_notifier_cb;
+	rc = register_memory_notifier(&data->mem_nb);
+	if (rc) {
+		dev_warn(dev, "failed to register memory notifier\n");
+		goto err_notifier;
+	}
+
 	/*
 	 * Hotplug using the system default policy - this preserves backwards
 	 * for existing users who rely on the default auto-online behavior.
+	 *
+	 * Start transition with resolved system default since the notifier
+	 * validates the operation type matches.
 	 */
 	online_type = mhp_get_default_online_type();
 	if (online_type != MMOP_OFFLINE) {
+		dax_kmem_start_transition(data, online_type);
 		rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+		dax_kmem_end_transition(data);
 		if (rc < 0)
 			goto err_hotplug;
 		data->state = online_type;
@@ -449,6 +595,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	return 0;
 
 err_hotplug:
+	unregister_memory_notifier(&data->mem_nb);
+err_notifier:
 	dax_kmem_cleanup_resources(dev_dax, data);
 err_resources:
 	dev_set_drvdata(dev, NULL);
@@ -471,6 +619,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 
 	device_remove_file(dev, &dev_attr_hotplug);
 	dax_kmem_cleanup_resources(dev_dax, data);
+	unregister_memory_notifier(&data->mem_nb);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
 	kfree(data);
@@ -488,8 +637,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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


