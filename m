Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC56C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBEB86B009E; Sun, 12 Jul 2026 11:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95A96B009F; Sun, 12 Jul 2026 11:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F296B00A0; Sun, 12 Jul 2026 11:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90E0C6B009E
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A1B4A08FC
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:34 +0000 (UTC)
X-FDA: 84980549388.16.FCED5A8
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4831B100004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iZvRONhH;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MtJTbfD/+62uyC9cmiI0PZLLS77jY7zlTT5oKim0nk=;
	b=rrxVohuweqcTGAGW3Teq7X/JnesvE9SBXmU6qM7mf2ot+qQuHkapL0911dfeKe046yjvIN
	UWs0vWF01U/mCYahpauhtO8koIKrxF/wdzPBOmRWsOaXhPykoLVnZ0lT+IH3zs06FqQBbe
	d9O5ENA+y+oxg8WeimtNHKLkDDj/gH4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iZvRONhH;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871132;
	b=gaqk21GqPl11vfCFD4knD1+OyBwoT/oWpKvngPhG9QzhSba+aZxsDFHEoUK+LjYJiFk/uD
	Mq6IG5Qxwp+jaXF5NdIFzmmfcZQSijBesBx1WlXwpqZ2YrCP1+S/uXeytc+M/ELlobianF
	6nVpTWq59bZxExE3aHADxaGS6H1ZuYE=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e50a650a0so114563685a.1
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871131; x=1784475931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1MtJTbfD/+62uyC9cmiI0PZLLS77jY7zlTT5oKim0nk=;
        b=iZvRONhHjbF//441lO8Edihzpkb/DTROEkvWa2Hdyc5aZ47vdG6F4haVCklHE2i1qf
         qLgtb20Dnisy4JMXd968u337+60PRrPfQZeTpx1SdF5NXww+dJ79nBaRCo9H6zUVRtIw
         uiZaAxbHn+Pa+1tb1ejZzdfEmGqWnRjZBzvLnUyfmrx5YbAI8ezLwLkPeJ5pNXlTOxgv
         5/qIezGjyjii49j5x8JONGXWbLSYTurkTqNpdmCDXWwLsIKsZ12xx+Ea3imukL9PpxFt
         JxvuEEXgmS77c2kiS8tM/7brh+2oXOK6gdb9FReM68SVFmgzz+06Z6//PsF66ef/X3yl
         JxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871131; x=1784475931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1MtJTbfD/+62uyC9cmiI0PZLLS77jY7zlTT5oKim0nk=;
        b=H2NMeMeCZedLRjXd6smBDP4bjpEMU+9LPKFludRPGKc7K+R35/M+KlKDIssj/bThTK
         rHgZW24+5NAPdXT5cRNr2AmENfmEfaJ+V62425m1ViKjalqigo5nnty0pZSq6MPIWjTp
         Dp6JehWT4sXbvA7uxzCCXYO7of7seVDeTrzrGfR0oDWOrcnt/bl9ekTwMr2p2yedhaR6
         tXtu3UP4oSoCM9e39x30S5Cerbo6asudGppxdlZ9+us+ywlmKJLXKQg4GyyankqIIj81
         nfE+0vJYUNFJX6nVFzURUNp3aHwP6DSS8ZXZs/UwNEOICKrZm3+0lKKJHpUYzHAkAAVm
         DPbQ==
X-Gm-Message-State: AOJu0Yz45l3WVf1hHa3TVGWVjvFjTdedkRawuQy7qJjR06O7yXP//5SI
	saCCiwRtD4U6izFTmr8oiKUFDORPzkTFUB7faTFMilrHcxn9onN+9oxL3QvT72o1bbgfvAWROsk
	7N56g
X-Gm-Gg: AfdE7cleyiUMA4gqBHG3DpssoZ25Qr9dINPqkfwEb15F+6f8L0J/FhKcoy45SN4zKX3
	nRHjCIGyF26J2fh6QxbkO+WtV1qaMpLDj4ahG64Iyre9edTwP8XePuByvZQCPVvL3f1Yvzooi06
	qqFr39IgqM2939zp5E+EqLCueOS+qNB1g94mzhsGSRmQ4rqbPswbdRrV3DYOxaThD2vTFjKHfH1
	jI2tK5j5+8F1ie4GeFl7FiB8p/9Lw0R8zdegFOfTH3Nmvgr/slQ0Hudgd2UwlS2as7cARIiFUnq
	TmQdYj3/hQ5u5ar+wgwT2ZPahS81GfontCj/zJ1AFJC4h/RjLBtCsBg0xe7DavAEouSgzNx7Alv
	6dtMSS7V5JL9IKSU+mWKe+XSV5jTtmcysyuQiHQuU0Es501plqi8zKgDMNjMhNfr/1okPebhGZv
	wkCV7qIFjT6S/0O4vtIyL1nxyebcO4yIaUsxd9o59k2KmBPLqSG5m0teBxUpE/6i2Ecj7ZNeR77
	g==
X-Received: by 2002:a05:620a:290b:b0:91d:6ac3:565a with SMTP id af79cd13be357-92ef2b3865fmr597461385a.12.1783871131232;
        Sun, 12 Jul 2026 08:45:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:30 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
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
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v7 09/10] dax/kmem: add sysfs interface for atomic whole-device hotplug
Date: Sun, 12 Jul 2026 11:45:03 -0400
Message-ID: <20260712154505.3564379-10-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4831B100004
X-Stat-Signature: ykcnxtsmzrncco6b96zidqwhfbp4piay
X-HE-Tag: 1783871132-375272
X-HE-Meta: U2FsdGVkX1/wcpt+SFg+LPnAjI6E68KPlpW4NgnmrMvjFpFhFVTaZq33Xs8IuPEaxIWUXLft4nEA228hGitbey6RjnqfTxuH4x2vQufOSyGoAfwWPJctCzefhp1ot6dOxUJ2f2/1VChkODykQYM8eaXTCWIUQssapBqT0MKXbpYM825mJY2sd5OsscZ1DU2JMtNO1uWPirzenb6Ky8L1XjqLWOcoI/chVd0JLHNqchRU6anQ4HDZgBokrVQlr2PFkXv0KgKtv3LmGUYv7MKiDIuR2NMpCJG0e+vO1zB3gxpw7EIyEJncAYiyf2Hkk/fBi6raqzixqU1T4zxpNlVZcVG/GPB8KFOr8yn/3mFs2uE+dFkrfx2OxGZmBdgtGbo1tW+/HT8zeU800QHvumBEgLjZxrkifZX9iCsNKtiYDIYlnjYewCrMWfZFY0b3ylfp36OvP8ipvinzSClgOW0fY8jtsmt4p/wIzAMpIv91AkwrQc3COkeEYz9/kr/aRjpGxaHp2C+P9N/QIOBHdOwCpCJyJcKdHUE+XxSYDfTO6LZ0xmDkPmXAJRuDnB5dx0/sThNmahdoxDwYjDj4fv+UIbLm77uDnUVhapxObrsJcQKzoupl4JSvVoKWoZ8KlGqI4fViWShJZMqb4VTmW3XWmOUzPxfAhTexLys3IdA5ETMXhobvz0eIjd3sf0T3pwj2LlIwMKjmYqDUK1xH0xEwVtLEAg27V+iawBClcNlHiasmBaCZBpHFx6yzqvZ46CRbE0PehxjCVh32dhDyOq5ouhnOoq99XldaLZ2UJHNF1wgA4iVLoRT2/4eVTBOOvKjCl58tIJOx7AfQp5Javn+IDWhZLBmBTUzfI+1UBb0P5Nr+ExO+TcmSjEVX0hliTs51awyOC6FIJBnhdkmX7bXgJpD857ZXN2kW/j1/tZwErQjgZesqGWwU0IifFuwwXVQKIKdTeH1sZ5t36BYeeiu
 g/1LQSpy
 Q+5ytiTpZqTmEQVHcj8nxvKXEr0L9mZOV0hUY2nTDrhJ53Hh41AHX/HFu/C9a08SHTXMoAxV9qBrT15aU/oK6MZNY7ECuoxCI8NakxEXB+KImjy0bj6PruVfpOJ6Fxv8KnuDj4e+YCQNzdXqclQaC0Qo7Q8Iml0YhCpUXVIBxgQHZgUot2PrEnr2LzwigTuQPycU6Qb0QYQ7Qr+GeyLqlWJM0XxJMZ6qZSTNtpSR81/lJ5KB0mfsTmB5KFyvD8EA1rgZRKLmAtJcF5ANkG/DFDyhNSFXwneJEP8mWaQWKYxahUnOlaTkeH2n4bVYKNuM6FC9XCyFa2fnEsEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no atomic mechanism to offline and remove an entire
multi-block DAX kmem device.  This is presently done in two steps:
    1. offline all
    2. remove all

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
  An offline dax device memory is removed on unbind as before.

  If online at unbind, the resources are leaked (as before), but now
  we prevent deadlock if a memory region is impossible to hotremove.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  24 +++
 drivers/dax/bus.h                       |   2 +
 drivers/dax/kmem.c                      | 243 ++++++++++++++++++++----
 3 files changed, 233 insertions(+), 36 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49a..60703fffa99e0 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,27 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/state
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
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 5909171a4428b..bfc31923f3ff4 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -16,6 +16,8 @@ struct dax_region;
 #define IORESOURCE_DAX_STATIC BIT(0)
 #define IORESOURCE_DAX_KMEM BIT(1)
 
+#define DAX_KMEM_UNPLUGGED	(-1) /* Do not create memory blocks */
+
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
 		unsigned long flags);
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 6174f7d3d05bd..a48d699cf344c 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -45,6 +45,8 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
+	int state;
+	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
 
@@ -63,12 +65,22 @@ static void kmem_put_memory_types(void)
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
@@ -77,9 +89,15 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
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
 
@@ -123,14 +141,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
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
@@ -193,45 +211,64 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
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
+	ranges = kmalloc_objs(*ranges, dev_dax->nr_range);
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
+
+	/* Nothing added means nothing to remove. */
+	if (!nr_ranges) {
+		kfree(ranges);
+		return 0;
+	}
+
+	rc = offline_and_remove_memory_ranges(ranges, nr_ranges);
+	kfree(ranges);
+	if (rc) {
+		/* Recoverable: the ranges rolled back, nothing is leaked yet. */
+		dev_err(dev, "hotremove failed, device left online: %d\n", rc);
+		return rc;
+	}
 
-		rc = remove_memory(range.start, range_len(&range));
-		if (rc == 0) {
-			/* Release the resource for the successfully removed range */
-			remove_resource(data->res[i]);
-			kfree(data->res[i]);
-			data->res[i] = NULL;
-			success++;
+	/* All ranges removed; release the reserved resources. */
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		if (!data->res[i])
 			continue;
-		}
-		any_hotremove_failed = true;
-		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
-			i, range.start, range.end);
+		remove_resource(data->res[i]);
+		kfree(data->res[i]);
+		data->res[i] = NULL;
 	}
 
-	return success;
+	return 0;
+}
+#else
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	return -EBUSY;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
@@ -247,6 +284,18 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
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
@@ -256,6 +305,81 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
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
+	if (rc < 0) {
+		/* Total failure, drop the reservations we took. */
+		dax_kmem_cleanup_resources(dev_dax, data);
+		return rc;
+	}
+
+	data->state = online_type;
+	return len;
+}
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -324,6 +448,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -334,6 +460,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
 	if (rc < 0)
 		goto err_hotplug;
+	data->state = online_type;
 
 	return 0;
 
@@ -352,26 +479,59 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+/*
+ * Remove the device's added ranges with remove_memory().
+ * Unlike the sysfs unplug path it never offlines and fails if the blocks are
+ * online (-EBUSY), so it is safe from unbind. Failures leak until reboot.
+ *
+ * Returns 0 only if every added range was removed.
+ */
+static int dax_kmem_remove_ranges(struct dev_dax *dev_dax,
+				  struct dax_kmem_data *data)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, rc = 0;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		if (!data->res[i] || dax_kmem_range(dev_dax, i, &range))
+			continue;
+		if (remove_memory(range.start, range_len(&range))) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx stuck online until reboot\n",
+				 i, range.start, range.end);
+			rc = -EBUSY;
+			continue;
+		}
+		remove_resource(data->res[i]);
+		kfree(data->res[i]);
+		data->res[i] = NULL;
+	}
+	return rc;
+}
+
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
 	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
+	 * Remove every range that is still added.  dax_kmem_remove_ranges()
+	 * uses remove_memory(), which never offlines: an online block fails
+	 * with -EBUSY rather than deadlocking an uninterruptible unbind.
+	 *
+	 * data->state only tracks daxX.Y/state writes, so it can be stale if
+	 * blocks were toggled via memoryX/state. Do not trust it here and
+	 * attempt simply remove_memory() - which reports the true state of
+	 * each range anyway. Anything left online is leaked until reboot.
 	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
+	if (dax_kmem_remove_ranges(dev_dax, data)) {
 		dev_err(dev, "Hotplug regions stuck online until reboot\n");
+		any_hotremove_failed = true;
 		return;
 	}
 
-	dax_kmem_cleanup_resources(dev_dax, data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
 	kfree(data);
@@ -399,10 +559,21 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+static DEVICE_ATTR_RW(state);
+
+static struct attribute *dev_dax_kmem_attrs[] = {
+	&dev_attr_state.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(dev_dax_kmem);
+
 static struct dax_device_driver device_dax_kmem_driver = {
 	.probe = dev_dax_kmem_probe,
 	.remove = dev_dax_kmem_remove,
 	.type = DAXDRV_KMEM_TYPE,
+	.drv = {
+		.dev_groups = dev_dax_kmem_groups,
+	},
 };
 
 static int __init dax_kmem_init(void)
-- 
2.53.0-Meta


