Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF8BD31A25
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56D66B0089; Wed, 14 Jan 2026 03:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F87E6B008C; Wed, 14 Jan 2026 03:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868096B0092; Wed, 14 Jan 2026 03:52:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71B146B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 172561BA01
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:41 +0000 (UTC)
X-FDA: 84329953722.16.2F09279
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id F344C1A0006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ApdWh5aM;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lttic/N6u5GXxgBUHet1PhNEmYleRIF6n16Y0kYNwPY=;
	b=Vm5BbJTzTnGjgCSFH9tZ6jtrnELrfOmrWL3oX/SeM98Z78rlfzpQzrACCy45EI8AN5X78p
	0hrv4iuL4xxXYEMYkHZbFII0s3XrSMezEaRpBLk9sqJH8AHEapR5hnruaBRV3BPf/GRz9o
	epqEIIMa5VaaJeSpRgPKPutBS5jHmvQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ApdWh5aM;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380759; a=rsa-sha256;
	cv=none;
	b=ADlURhsXhsbaMbg9piJAEqWIaGWWG4k+L5Rkss8gLTu7/rQhh5kGfv01vapRuheICRY+W8
	Z03KVZ6mq0XxENE44+AH+eIvn58Wdz/sD1LorAht2is6O9eqG//aicAJkyDzCmW5inwDr4
	IrYL9O+6CbK+Mhh6MQfk06ADdCivce4=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5014db8e268so3046091cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380758; x=1768985558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lttic/N6u5GXxgBUHet1PhNEmYleRIF6n16Y0kYNwPY=;
        b=ApdWh5aM+PJKZsVMZ+ycialk8ofMRQ41QROJaC3irsnjJZ2DTXQitTAgHmNvrWq48g
         IWhy197+t39t3RGLP1AVHuZnrxb+tYxdWNAbz5pn0oo+JbJtLpo/h4nekjlSjIE4G4gD
         7Q7OhMKpRYc1BTkP9LAaAm4CcS6HYWPui7a6OSM49uIawNKbJp2ysSzZoHMGwgHgdM56
         VS/VYkB0D54brMFHwasGCqTgbIuNU/Ot3O0Cly7nbV1qhuuzb4kMEGmSf9lmA//TKMuc
         TI986e7Alz1KNJOPxkyjWDeTzyRRQIiDX317wM44nShVsb4PLVPl6Dj5kLg9zhMFRC5z
         b5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380758; x=1768985558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lttic/N6u5GXxgBUHet1PhNEmYleRIF6n16Y0kYNwPY=;
        b=Ikodty4ggjYHHH8d/uAbgQHvtnX5nbe6g/yJrgdM7Vky8WryaDMnaxtvzTlrGzFl7/
         NV64qFd9VG5tZkuMs+ClzRlaiVQROO2oNX9hOI5VhFOzRCum9hC2RYEr9PsIYzwD1MqX
         M2T7oI2n/edFMENWZcLs66vlLaSu3P6Opf13f+0xo8evZQlS0IDt1kUYjFfHXMG3oxVJ
         vPtHW7ueeq7XaUpqC94q5kREfJ7SxHiW60x+fSEZ2z0U3SiIkh8EuYfM5dQZneot/3xD
         mm4z22F1gAQlptVtArQHUqhYGw2T5sAjoddhx5WZFRnbYhyDhEHGm1EbK+Rl57pAKmf9
         VmzQ==
X-Gm-Message-State: AOJu0YyrzdcMuhAzME2SZ+inVPZEgWQWZzd1C750x05QfbkE7NpKBT3g
	v2+3OXtBagSMwTai1vPxivUgkDsD4mhjTuAQA1QPZgMMmwesI5hrgypRbx1Qq2sLexxV+51O0+F
	ehJf1ZNU=
X-Gm-Gg: AY/fxX533gFHgy6HrgmPSsPdC0kKR86o9q4O1htS5SGSizHBkPHna0Ou5v+nLZ3ozUX
	g0DAMYB8JNxXGqu+Pfg0o7sw7FEC1MBqZgatfKfchw2GcQ69Wxc81ntmuUdpkDRORHnjcfi735V
	xC64M/a4n0YF9TyI62o5iD8Okq34mAXCvj515K+gwMGFtcEUq6CEHX7bZjnrE7x8kECIRmefE/f
	meTDxXbgGfAvYjPdnPExsCFfSKuda69Kwh5nSZHcR4PieOXpGwdNVroeohCMhG1NbRgY4KzPYO1
	icg7aaulifa7bmCDQymIs9dSZhPnxal03Tqq6YB29b/rhpkHYK1WRKbSOit7zJHwn8x9gnCHlDS
	aaBamOM22lYwFlO5A03rmvc32hafk2dSj7Rt4VLjyzCi5lRP6ffEIt9YvzXn6cKqDLu3mXQXeYl
	WWJCxYZ3BWPWJO2s2eFcejHs9LftIBFgy1oKLyH5mLGAB23DQKdYjDnQKBZpytCkXNpV/jwJO+D
	M8=
X-Received: by 2002:ac8:5701:0:b0:4ee:1727:10bd with SMTP id d75a77b69052e-501484c531emr22881881cf.66.1768380757853;
        Wed, 14 Jan 2026 00:52:37 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:37 -0800 (PST)
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
Subject: [PATCH 2/8] mm/memory_hotplug: extract __add_memory_resource() and __offline_memory()
Date: Wed, 14 Jan 2026 03:51:54 -0500
Message-ID: <20260114085201.3222597-3-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F344C1A0006
X-Stat-Signature: wmfoy49dautj8b53qpu9af1qko4i3z8b
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768380758-207657
X-HE-Meta: U2FsdGVkX1+qm+qPUdvxpsXOgynd2AUvn9WWcm+oHWJrvenSe6vManHYl7CIQs3onqpWLHaHIqSKHxUEPfYH8DHWP5uL2E7sIhHyM00OYqqCEFC5ps7PtMn6wY6n7OjfnRfLWLVuUzqtfF+Lj7jmLDAlEDHxx4fUj9UH0xH9HMPXusMgxXmA97Elyp4VXlukWWR7KCD/htLO+0UHlZhgIEaC6Y6DP/vWpJYVoi4xR0Wl33+hqsv6W5GVCFfYspK0bJo143EZDzj4s2beFIV1bvVY97vN8HwKrg7famrMvnuCQdaAoDTCmsSEuUZYuYkq2fDMWzRvd3ZRfO9QX2oOk4NZNMffC8OxgJTiUoZQNxU54VATxLQnnD4IKZomVNrAngph3nFNzrh1Vc0RRsMIymkCTi0QZcttMADdSVXkjZ7/RQ0f5tFJQDEcZbemTAYp1bNhLWczFsGRnqJ/GMAQm4CIO5aKXch9NBd1U72+xHWGFqGhsUC8tJMr5QUb0d3wY/DN9RQehAISD/VRcZXfdTG7hZl2NvPMRd59R5vjA/LZzb/BqAAfLQS/WgTkzxRwycWcqjeOXxW53csWx/vSLSeIFRHraqDv7goaT78CY+4HpcP0lpptf7B6MYAHr/sK8FTAbOhHaEFeJQMs928sCUnht1wDYL4wHOsj9KGzt+XbXz/eQ0szOxiy3lwhcz4k7Pf90LL2eyMZSMnY3LJNKwyvq+873SyzVzV8qCoBrLScAHzdgKXk3ypl+F95MTFkiA7KSUYQ/8pp52FLXkDovIAuvff9ndeboel171is3pCJjFeH0qrDrtIM0FUgccUclYSHAuv3eBdlJmW0tx9gs0uZLRuOSfQ22xcsDmk9Z6cgn3knJATXQmJcYW+asoZzgwMKg6lDt8Zmz12P3P1J29XWsdQaF4P0VX4hVQ45FwWy+bkFGtGq7JSvp1/NbPyDWbSVvT3FVS93imfJLVK
 8tJp4v7S
 OFqEUiU9Maf0+7mc3vPstdNMDtf157wU10JrdG3/6Mq3QuPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract internal helper functions with explicit parameters to prepare
for adding new APIs that allow explicit online type control:

  - __add_memory_resource(): accepts an explicit online_type parameter.
    Add MMOP_SYSTEM_DEFAULT as a new value that instructs the function
    to use mhp_get_default_online_type() for the actual online type.
    The existing add_memory_resource() becomes a thin wrapper that
    passes MMOP_SYSTEM_DEFAULT to preserve existing behavior.

  - __offline_memory(): extracted from offline_and_remove_memory() to
    handle the offline operation with rollback support. The caller
    now handles locking and the remove step separately.

This refactoring enables future callers to specify explicit online
types (MMOP_OFFLINE, MMOP_ONLINE, MMOP_ONLINE_MOVABLE) or use
MMOP_SYSTEM_DEFAULT for the system default policy. The offline logic
can also be used independently of the remove step.

Mild functional change: if try_remove_memory() failed after successfully
offlining, we would re-online the memory.  We no longer do this, and in
practice removal doesn't fail if offline succeeds.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  2 +
 mm/memory_hotplug.c            | 69 ++++++++++++++++++++++------------
 2 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f2f16cdd73ee..d5407264d72a 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -29,6 +29,8 @@ enum {
 	MMOP_ONLINE_KERNEL,
 	/* Online the memory to ZONE_MOVABLE. */
 	MMOP_ONLINE_MOVABLE,
+	/* Use system default online type from mhp_get_default_online_type(). */
+	MMOP_SYSTEM_DEFAULT,
 };
 
 /* Flags for add_memory() and friends to specify memory hotplug details. */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 5718556121f0..ab73c8fcc0f1 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1490,7 +1490,8 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
  *
  * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
  */
-int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
+				 int online_type)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
@@ -1499,6 +1500,10 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	bool new_node = false;
 	int ret;
 
+	/* Convert system default to actual online type */
+	if (online_type == MMOP_SYSTEM_DEFAULT)
+		online_type = mhp_get_default_online_type();
+
 	start = res->start;
 	size = resource_size(res);
 
@@ -1580,12 +1585,9 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
-		int online_type = mhp_get_default_online_type();
-
+	if (online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, &online_type,
 				   online_memory_block);
-	}
 
 	return ret;
 error:
@@ -1601,7 +1603,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	return ret;
 }
 
-/* requires device_hotplug_lock, see add_memory_resource() */
+int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+{
+	return __add_memory_resource(nid, res, mhp_flags, MMOP_SYSTEM_DEFAULT);
+}
+
+/* requires device_hotplug_lock, see __add_memory_resource() */
 int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 {
 	struct resource *res;
@@ -2357,12 +2364,12 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
 }
 
 /*
- * Try to offline and remove memory. Might take a long time to finish in case
- * memory is still in use. Primarily useful for memory devices that logically
- * unplugged all memory (so it's no longer in use) and want to offline + remove
- * that memory.
+ * Offline a memory range. In case of failure, already offlined memory blocks
+ * will be re-onlined.
+ *
+ * Caller must hold device hotplug lock.
  */
-int offline_and_remove_memory(u64 start, u64 size)
+static int __offline_memory(u64 start, u64 size)
 {
 	const unsigned long mb_count = size / memory_block_size_bytes();
 	uint8_t *online_types, *tmp;
@@ -2388,11 +2395,37 @@ int offline_and_remove_memory(u64 start, u64 size)
 	 */
 	memset(online_types, MMOP_OFFLINE, mb_count);
 
-	lock_device_hotplug();
-
 	tmp = online_types;
 	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
 
+	/*
+	 * Rollback what we did. While memory onlining might theoretically fail
+	 * (nacked by a notifier), it barely ever happens.
+	 */
+	if (rc) {
+		tmp = online_types;
+		walk_memory_blocks(start, size, &tmp,
+				   try_reonline_memory_block);
+	}
+
+	kfree(online_types);
+	return rc;
+}
+
+/*
+ * Try to offline and remove memory. Might take a long time to finish in case
+ * memory is still in use. Primarily useful for memory devices that logically
+ * unplugged all memory (so it's no longer in use) and want to offline + remove
+ * that memory.
+ */
+int offline_and_remove_memory(u64 start, u64 size)
+{
+	int rc;
+
+	lock_device_hotplug();
+
+	rc = __offline_memory(start, size);
+
 	/*
 	 * In case we succeeded to offline all memory, remove it.
 	 * This cannot fail as it cannot get onlined in the meantime.
@@ -2403,18 +2436,8 @@ int offline_and_remove_memory(u64 start, u64 size)
 			pr_err("%s: Failed to remove memory: %d", __func__, rc);
 	}
 
-	/*
-	 * Rollback what we did. While memory onlining might theoretically fail
-	 * (nacked by a notifier), it barely ever happens.
-	 */
-	if (rc) {
-		tmp = online_types;
-		walk_memory_blocks(start, size, &tmp,
-				   try_reonline_memory_block);
-	}
 	unlock_device_hotplug();
 
-	kfree(online_types);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(offline_and_remove_memory);
-- 
2.52.0


