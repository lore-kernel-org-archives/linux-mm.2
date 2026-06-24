Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED3DCDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00BD6B00B4; Wed, 24 Jun 2026 10:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1396B00B6; Wed, 24 Jun 2026 10:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC396B00B7; Wed, 24 Jun 2026 10:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 911F36B00B4
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:58:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31D43402B4
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:15 +0000 (UTC)
X-FDA: 84915111750.14.68A3EF7
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 437DD2000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="VY+rYUC/";
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313093;
	b=KaR81yUsc/BTz2TPYbKdWewcfb/g4OvhcRaTFqV2vElJXpnttK6hwCdqFxSAm+SRmAavk/
	VVuxtIK7grMSGI10JAgrL5OtY+IRRBd2pyvYnsoSGltMrbBsBjLpPWvJIy/JnQFCUCRIP+
	1OmOOI+oNvY0w/e/VFu1OMSE8M+SB5o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLv7yvsJyJMTMKtB8MLtFXICrKv3HRFHSZL0ZVu3e8M=;
	b=LAf2iEE8kraFrzYQdf2I+JmgIb16snZQSSIbmPMFDeA3rfPfnVMfE3nKJlQY7q14+eN+Oe
	sT1QsEDSMA88cPfdmMMgzGjm6jo4L6ZGJlVsJBlzBgaCjA9K2RaGfVxSfRTJkUqksSpZ+Y
	TccWYan/aFdZsYctPGNr3WtTfb8xC58=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="VY+rYUC/";
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-519f6a10d9bso7350711cf.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313092; x=1782917892; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLv7yvsJyJMTMKtB8MLtFXICrKv3HRFHSZL0ZVu3e8M=;
        b=VY+rYUC/DJpJBzJ3EkO9OKM1CdX/Vt45lU1cddkxvLs7qitiKY2eHYHT7wd0rXELPR
         InbAS51NXAbFxDWiflO6FrRAywh5OGmHuj9UuxISPVJe0iWb2urKV2bN597lFLgDfLnx
         4+EEONzGSPn/EaGiJIYbakRQPLwkSh0X7bgPPY+ZHNFi+EeirrWDgQNtyZDKesYJ1Hue
         Ei+gHY/WsbGrgUTHff26E85yq5A6H56+3ZxLFuy1IuMLjudNATaqXfsNqmImJMCCUS4i
         67Jdwe3PkDs7KS3VL194xNwSsEPDutq6M5eKGGh27AWsMdNzzRx8RkV4+QUAyUrMDiLV
         D2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313092; x=1782917892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GLv7yvsJyJMTMKtB8MLtFXICrKv3HRFHSZL0ZVu3e8M=;
        b=c+Ru4gFPD3kgCSjfYqvvFYBcTmdW5KYWq9YV2bUhNecA7mWxZcytEGwGU4PE0zlB/F
         QukXxKC6NUGe3YXzyBMm6D+udNmk2eiGxCeReMZe4m+SrZspHkXo5iQkizw0lxuhwFeZ
         X51Mgh9HTr2XeetLhpMqdQuekJGzkaayEfNBpOdjA3FGTyMq6jE032zXhBCXxRHMsIXY
         P7RwyMdwiaQeEYzwihAucgKcyzUarJ1IwigDwnOF9yW9sPmTrDNsonT5ts6D2QbtlQPb
         8Ryo6LJE2aelPJUoyj4+ICU4Bo3Mcoc0E9kDV5TgKgeSbKW+rwkc4Cy1qPXQ63fiTqlo
         m4IQ==
X-Gm-Message-State: AOJu0YyiJZ0/lA2I/XQJib3UGu0zs1hKEExRjsrE5yGj1cgr6wY3psPE
	ZWjNZu6x9HK0oNRITwSOwqNRHuHtzSs1DeG/v6GL8q+N2I1lIkFgJMwAWxmPO1YYtnJp5h6RjuE
	6WOJR
X-Gm-Gg: AfdE7cmlyDNAkzaM2nbf2UQ5yxiSt9gCvcdI4/XMabZYFLdzXQmFTeTcOlAc4V0+6kU
	vCRP5Ks4uUx03i/Ng4/syPGSdgHBtLs6EkSdzrI69eUfjEkpPC3+7G+TPkh8JPP4MhlKAmP29Sz
	QElOhzKzoyVV3cZcE5E2uRIgApgKCAuPQjnUuxMAcX+j9h/Vt2bi8gc8EDBfuvOYDVG+I/tUpyB
	XDGkaYq3HKCHnEPue6+Is+8/5h09IWMiSTPltxCiExYETGQ5iU04awac5aPy5X/7x/1M/2lHnu0
	po8rTgAiPw77X8ULBo53eDDBUklZuCKPLtZEdQJ8yJLjATeaqKNm3eAOmaA7e6fwyrY7Z0FUPOK
	UbahTDjmbgooIhycJmIGmgENGbpsiG0/jNucC+Y1sYSN2cW3s0l8u6Ft/w5/pv4TkSFUPW1PQIj
	Oh1TtYur57CpiSnspu3Kc1os/dDVhtqKZcU5HYPg6dk07zUgkRGigp/eoGB4Bj82bhIm4AHAZdJ
	g==
X-Received: by 2002:ac8:7c41:0:b0:517:905d:dc72 with SMTP id d75a77b69052e-51a61d7e679mr54934151cf.18.1782313092082;
        Wed, 24 Jun 2026 07:58:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:11 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic whole-device hotplug
Date: Wed, 24 Jun 2026 10:57:43 -0400
Message-ID: <20260624145744.3532049-9-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hicrby9ybm8y7hdn3tdkqco17dcqcm41
X-Rspamd-Queue-Id: 437DD2000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782313093-923033
X-HE-Meta: U2FsdGVkX18b0fQRR/QXhC/DobFrlb7Lp3nahCmz8rVhDZci2SMJ21sKg4noIyGDyZR+9wbG01kP1m9kSSd7Elt0+gcLLvakt0mTcnAh9QV9QRf/yAYo6GM4if4KV1p03TaHOT1L+n6jOM+PxxT7R0OPyt4OPONhyTfm99LDgebCNSgMVTuKUr1ZK43hLIcofbydpQQodnJWq9rg0LSNby8HJe1gXaMzbI4e+yu1G9pKPvM8wwZwXp7UFtuHi8eo99gxjvfKWHv3o2E3fqkKgjrrqlij7wXwkVLmfMNeOiBqEMeFVx2CUfafN+KqCfu03MS+6ETY6T5w+TkhHq/ivryo1ilCWYiWXsa+l9kznSUR4Yth1679trXc/KJ/HzDO0ris6DJJebSZY+247Gm07imiTPqhAAuDN8BWqbLdyG0K1LIeAAg3E4ITscWfiP0mR/0fJW53wA2iFuVQrk/a4cAg11RZSoCw6oEXN1uC/Jo4ua7gHsmtqZRHB3NqWeHJO1HzDax5aRm6BV5mNVrLKhNeYNP3zxcadMQg49DhF51DPtLZTsJ0YBGbmdQlyy5gouO4fAWY0kjTj3e8tZLrSKKfawpZBm+lN43P8LHUAUgU2rCHLRkWMwIM+9r8pJDThPAMt9l4rNsFHCZsFp2dPeVCDHfkhy6Gm7sqRhXV9yoxbapZAzr/+qGyVA9zt7ah58drHYwQhHQ8E53QTM5LyXY5OICc3TADyUKfT+sHc6OTEngtfnmK37+umCCgIe/ZjIWMCah0AhZEsmJZM/1wm0VDx47D90ASALFBISgxXRfoM+AwI2BRKtp76uhsPhNv1xj1xDa7mYNvl81sZIlldp19aLKArLWnvqE6HV/8bjZlEihtCP2nUVWsJHVdlMSIHpzQ1BItheGNHX/Olef4ud6JaOEeGq2t5NohpSSHXZPXHWrxk5mtTOQqYIcIGRDjgEg3DL1alcFwK34u5ZP
 fYvugJJf
 MFKzwKyLtTpkQGzcs3+G+BH2tSZ+91WFmKZMlvUtVYIm9GJYbvFYrOAA3eHUkd0YK9Km4Esu3A0pi3dGM0T1KFm1I0XoteL4GXOvPxJvnzNUM6E58iE0dAqiHfGCWOX4xoW311uN/MNKKcD69a/VQCe37Z05k61VFa9lHsrDR2qr/eB4XUL7jFqv/6P6cvqUioHLnxrEk2lbY14EjJsftvWgsz7TQRvGJdkq0+YV+M0fc6j75n3UBuz7va4x+v1F7mpbSWh4MNSEHTQkUcAly05ibH7PrVI/+9HnNRagLXtE+BUW9d5chI8qnNARGCRRUNSxiIpadiHnjYbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no atomic mechanism to offline and remove an entire
multi-block DAX kmem device.  This is presently done in two steps:
    1. offline all
    2. remove all).

This creates a race condition where another entity operates directly
on the memory blocks and can cause hot-unplug to fail / unbind to
deadlock.

Add a new 'state' sysfs attribute that enables an atomic whole-device
hotplug operation across its entire memory region.

daxX.Y/state mirrors the per-block memoryX/state ABI:
  - [offline, online, online_kernel, online_movable]
  - "unplugged" - is added specifically for dax0.0/state

The valid writable states include:
  - "unplugged":      memory blocks are not present
  - "online":         memory is online, zone chosen by the kernel
  - "online_kernel":  memory is online in ZONE_NORMAL
  - "online_movable": memory is online in ZONE_MOVABLE

Valid transitions:
  - unplugged                -> online[_kernel|_movable]
  - online[_kernel|_movable] -> unplugged
  - offline                  -> unplugged

A device can only be onlined from "unplugged", so it must be returned
there before being onlined into a different state.

For backwards compatibility the memory blocks are always created at
probe - existing tools expect them to be present after kmem binds.

"offline" is therefore a reportable state but is not writable: it only
arises from the legacy auto_online_blocks=offline policy.  Onlining
such a device through this attribute requires unplugging it first in
an effort to get drivers creating DAX devices to set a default.

Unplug is atomic across the whole device: dax_kmem_do_hotremove()
collects every added range and offlines/removes them in one operation.
Either the operation succeeds or is entirely rolled back.

Unbind Note:
  We used to call remove_memory() during unbind, which would fire a
  BUG() if any of the memory blocks were online at that time.  We lift
  this into a WARN in the cleanup routine and don't attempt hotremove
  if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.

  An offline dax device memory is removed on unbind as before.

  If online at unbind, the resources are leaked (as before), but now
  we prevent deadlock if a memory region is impossible to hotremove.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  26 +++
 drivers/base/memory.c                   |   9 +
 drivers/dax/kmem.c                      | 224 ++++++++++++++++++++----
 include/linux/memory_hotplug.h          |   1 +
 4 files changed, 224 insertions(+), 36 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49..2dcad1e9dad0 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,29 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/state
+Date:		June, 2026
+KernelVersion:	v6.21
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Controls the state of the memory region.
+		Applies to all memory blocks associated with the device.
+		Only applies to dax_kmem devices.
+
+		Reading returns the current state; the writable states mirror
+		the per-block /sys/devices/system/memory/memoryX/state ABI::
+
+		  "unplugged": memory blocks are not present
+		  "online": memory is online, zone chosen by the kernel
+		  "online_kernel": memory is online in ZONE_NORMAL
+		  "online_movable": memory is online in ZONE_MOVABLE
+
+		"offline" (memory blocks are present but offline) may also be
+		reported - this happens when the device is bound while the
+		auto_online_blocks policy is "offline".  It cannot be written,
+		as it's not useful and creates device destruction races.
+
+		A device can only be onlined from the "unplugged" state, so a
+		device must be returned to "unplugged" before it can be onlined
+		into a different state.
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index b318344426fa..3a2f69d3af7b 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -46,6 +46,15 @@ int mhp_online_type_from_str(const char *str)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(mhp_online_type_from_str);
+
+const char *mhp_online_type_to_str(int online_type)
+{
+	if (online_type < 0 || online_type >= (int)ARRAY_SIZE(online_type_to_str))
+		return NULL;
+	return online_type_to_str[online_type];
+}
+EXPORT_SYMBOL_GPL(mhp_online_type_to_str);
 
 #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
 
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a45e50def537..340486586d82 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -42,9 +42,15 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	return 0;
 }
 
+#define DAX_KMEM_UNPLUGGED	(-1)
+
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
+	int numa_node;
+	struct dev_dax *dev_dax;
+	int state;
+	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
 
@@ -63,12 +69,22 @@ static void kmem_put_memory_types(void)
 	mt_put_memory_types(&kmem_memory_types);
 }
 
+/* True for the online states a kmem dax device can hold. */
+static bool dax_kmem_state_is_online(int state)
+{
+	return state == MMOP_ONLINE ||
+	       state == MMOP_ONLINE_KERNEL ||
+	       state == MMOP_ONLINE_MOVABLE;
+}
+
 /**
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: the online policy to use for the memory blocks
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Hotplugs all ranges in the dev_dax region as system memory with the
+ * provided online policy (offline, online, online_movable, online_kernel).
  *
  * Returns the number of successfully mapped ranges, or negative error.
  */
@@ -77,9 +93,15 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 			       int online_type)
 {
 	struct device *dev = &dev_dax->dev;
-	int i, rc, onlined = 0;
+	int i, rc, added = 0;
 	mhp_t mhp_flags;
 
+	if (dax_kmem_state_is_online(data->state))
+		return -EINVAL;
+
+	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
@@ -112,14 +134,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 				kfree(data->res[i]);
 				data->res[i] = NULL;
 			}
-			if (onlined)
+			if (added)
 				continue;
 			return rc;
 		}
-		onlined++;
+		added++;
 	}
 
-	return onlined;
+	return added;
 }
 
 /**
@@ -182,45 +204,64 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
  *
- * Removes all ranges in the dev_dax region.
+ * Offlines and removes every currently-added range in the dev_dax region
+ * atomically: either all ranges are offlined and removed, or none are and
+ * the device is returned to its prior state.
  *
- * Returns the number of successfully removed ranges.
+ * Returns 0 on success, or a negative errno on failure.
  */
 static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 				 struct dax_kmem_data *data)
 {
 	struct device *dev = &dev_dax->dev;
-	int i, success = 0;
+	struct range *ranges;
+	int i, nr_ranges = 0, rc;
+
+	ranges = kmalloc_array(dev_dax->nr_range, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges)
+		return -ENOMEM;
 
+	/* Collect the ranges that were actually added during probe. */
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
-		int rc;
 
-		rc = dax_kmem_range(dev_dax, i, &range);
-		if (rc)
+		if (!data->res[i])
 			continue;
-
-		/* range was never added during probe, count as removed */
-		if (!data->res[i]) {
-			success++;
+		if (dax_kmem_range(dev_dax, i, &range))
 			continue;
-		}
+		ranges[nr_ranges++] = range;
+	}
 
-		rc = remove_memory(range.start, range_len(&range));
-		if (rc == 0) {
-			/* Release the resource for the successfully removed range */
-			remove_resource(data->res[i]);
-			kfree(data->res[i]);
-			data->res[i] = NULL;
-			success++;
-			continue;
-		}
+	/* Nothing added means nothing to remove. */
+	if (!nr_ranges) {
+		kfree(ranges);
+		return 0;
+	}
+
+	rc = offline_and_remove_memory_ranges(ranges, nr_ranges);
+	kfree(ranges);
+	if (rc) {
 		any_hotremove_failed = true;
-		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
-			i, range.start, range.end);
+		dev_err(dev, "hotremove failed, device left online: %d\n", rc);
+		return rc;
 	}
 
-	return success;
+	/* All ranges removed; release the reserved resources. */
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		if (!data->res[i])
+			continue;
+		remove_resource(data->res[i]);
+		kfree(data->res[i]);
+		data->res[i] = NULL;
+	}
+
+	return 0;
+}
+#else
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	return -EBUSY;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
@@ -236,6 +277,18 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 {
 	int i;
 
+	/*
+	 * If the device unbind occurs before memory is hotremoved, we can never
+	 * remove the memory (requires reboot).  Attempting an offline operation
+	 * here may cause deadlock and a failure to finish the unbind.
+	 *
+	 * Note: This leaks the resources.
+	 */
+	if (WARN(((data->state != DAX_KMEM_UNPLUGGED) &&
+		  (data->state != MMOP_OFFLINE)),
+		 "Hotplug memory regions stuck online until reboot"))
+		return;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		if (!data->res[i])
 			continue;
@@ -245,6 +298,85 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 	}
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	int online_type;
+
+	/* "unplugged" is kmem-specific - the rest map to MMOP_ */
+	if (sysfs_streq(buf, "unplugged"))
+		return DAX_KMEM_UNPLUGGED;
+
+	online_type = mhp_online_type_from_str(buf);
+	/* Disallow "offline": it's not useful and creates race conditions */
+	if (online_type == MMOP_OFFLINE)
+		return -EINVAL;
+	return online_type;
+}
+
+static ssize_t state_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	const char *state_str;
+
+	if (!data)
+		return -ENXIO;
+
+	if (data->state == DAX_KMEM_UNPLUGGED)
+		state_str = "unplugged";
+	else
+		state_str = mhp_online_type_to_str(data->state);
+
+	return sysfs_emit(buf, "%s\n", state_str ?: "unknown");
+}
+
+static ssize_t state_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	int online_type;
+	int rc;
+
+	if (!data)
+		return -ENXIO;
+
+	online_type = dax_kmem_parse_state(buf);
+	if (online_type < DAX_KMEM_UNPLUGGED)
+		return online_type;
+
+	guard(mutex)(&data->lock);
+
+	/* Already in requested state */
+	if (data->state == online_type)
+		return len;
+
+	if (online_type == DAX_KMEM_UNPLUGGED) {
+		rc = dax_kmem_do_hotremove(dev_dax, data);
+		if (rc)
+			return rc;
+		data->state = DAX_KMEM_UNPLUGGED;
+		return len;
+	}
+
+	/* Onlining is only allowed from the unplugged state. */
+	if (data->state != DAX_KMEM_UNPLUGGED)
+		return -EBUSY;
+
+	/* Re-acquire resources if previously unplugged, otherwise no-op */
+	rc = dax_kmem_init_resources(dev_dax, data);
+	if (rc < 0)
+		return rc;
+
+	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	if (rc < 0)
+		return rc;
+
+	data->state = online_type;
+	return len;
+}
+static DEVICE_ATTR_RW(state);
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -313,6 +445,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -325,9 +461,15 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (online_type == DAX_ONLINE_DEFAULT)
 		online_type = mhp_get_default_online_type();
 
+	/* Always create blocks for backward compatibility, even if offline */
 	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
 	if (rc < 0)
 		goto err_hotplug;
+	data->state = online_type;
+
+	rc = device_create_file(dev, &dev_attr_state);
+	if (rc)
+		dev_warn(dev, "failed to create state sysfs entry\n");
 
 	return 0;
 
@@ -348,20 +490,26 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
+	device_remove_file(dev, &dev_attr_state);
 	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
+	 * Online memory cannot safely be removed (offlining during unbind can
+	 * deadlock a task as unbind cannot be interrupted).  Unfortunately we
+	 * have to leak all of [resources, memory group, @data, memtype], until
+	 * the next reboot - and the memory will stay online until then.
+	 *
+	 * offline blocks are removed on unbind, but may leak on failure.
 	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
-		dev_err(dev, "Hotplug regions stuck online until reboot\n");
+	if (dax_kmem_state_is_online(data->state)) {
+		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
+		any_hotremove_failed = true;
+		return;
+	} else if (data->state == MMOP_OFFLINE &&
+	    dax_kmem_do_hotremove(dev_dax, data)) {
+		dev_warn(dev, "Unplug failed, resources leaked until reboot\n");
 		return;
 	}
 
@@ -382,6 +530,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
+	struct device *dev = &dev_dax->dev;
+
+	device_remove_file(dev, &dev_attr_state);
+
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
 	 * device-dax range and return '0' to ->remove() attempts. The removal
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7f1da7c428dc..46c796570692 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -127,6 +127,7 @@ extern int arch_add_memory(int nid, u64 start, u64 size,
 extern u64 max_mem_size;
 
 extern int mhp_online_type_from_str(const char *str);
+const char *mhp_online_type_to_str(int online_type);
 
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
-- 
2.54.0


