Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00E2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6946B00B2; Tue, 30 Jun 2026 17:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348716B00B4; Tue, 30 Jun 2026 17:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B7C6B00B5; Tue, 30 Jun 2026 17:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0ABA6B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:19:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B16D1C57A1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:08 +0000 (UTC)
X-FDA: 84937844376.17.D3B8BFC
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 621CD20004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y5f7Criq;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854346;
	b=QLEnbo2o8+LB/+Jwyc0cUg5tH5AfjVfG2jg4JGhXVFlGTNL6xIFrlFhsNP4in+uRPp0MWO
	w0T6VTuX3WM4h/cmg8U5niremGUpOqURO8Vq3lKxEVKPbWZPXZnSKwE6A5AxKuVcYO4Z4p
	YGYUp6yKpBLq5nTEhf3WjazQ35ftuBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8QKrKqISzDTiTy7CVkx59XQyhvZjgTrb9AQUt59JD4=;
	b=KfeaRB1MfoIzAtRKqiyVK/JUIESy9+QKvhdg/yOf4MzbpnpoP5W+WSc3DYxK3yM22fvXyL
	7Sp3PO3Knkw59GVL28BGjkOWJzYRr/3ZSlCs6QM0OomFdJuiByGkNUb7twC5tg13ZgHnPZ
	7OfsATypkHlA/FanNxVXFh8Z1omLY7E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y5f7Criq;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92b21f65b60so105623885a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854345; x=1783459145; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8QKrKqISzDTiTy7CVkx59XQyhvZjgTrb9AQUt59JD4=;
        b=Y5f7CriqWN/gHLoOXoqnsLp5u4flnjGMVjQBxEhCcL7+9P/uRtz1tyrXBVXlWskvL7
         LuXmcEeIbfu3tTYKJzkDy7Qk9TpPk5rkcvmuNYClNZn8m5fVHF3LpwAeAB3FIIc8o8d/
         VExuNSl7QUNfWsrRnvHOeSwYBWWEwWKfgNwVPlopILgpFIBnoh81BS4NoGP6tfP1M+s7
         XPfrjRaZWXurvJlGdd8T76tudxoW4AfieMsCwyq/KJu+6ubuZKKME5zTBYjiAj248+1b
         VeKuCawMYTnuGPD66jwLGmqJt24n26GeUk7IUR4QNUcrOrB+Stse+tUyGdUY3Czjzcw7
         Yo0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854345; x=1783459145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w8QKrKqISzDTiTy7CVkx59XQyhvZjgTrb9AQUt59JD4=;
        b=XNih/MP61atrYCgVIuBy6TWBzhRsTP6WVQp+HcymxGEGDUw8mjsNefteZhSV1rlPXw
         ViVcyDMvMlz4czb5RpjMTb98ASkC6/HLB7rPnbzt9iF04l5XDm2BFjLe4u/TvISFntLZ
         i6HHOX6r9JG1tBHi1Yu/byift2xDdipyP9N6HOHAi3jqsBBFTm2yrjgRsi8iseZqMkzH
         KzJfJ5CQLHiJOCHY64dPQ/Qd46WxqlQEH/bNplcsSlQoDoWqw0cBEQXkBuyX0cljHytb
         C3WzBTa6k87VAIcwPHjf/pKfo/qzrHLGcjUvi1f5VTNsEdHQEZCOAicesDahoz3XMiCs
         F/vw==
X-Gm-Message-State: AOJu0YxTOi8MJdb0uM2EB5PgJyiCRtObaEqcDDJ8DJStOhsN4JOTB87Y
	hLN5dVIxjdlPQtS8GRrVuS94DqkibJedBPdaRr12wXzajSyL6An7uCXFAvU3hh198rFPfkBMV4v
	dW+cW
X-Gm-Gg: AfdE7clo+LfavA2cgBEpqaEr1yb0TNdlLSKBgkuQU96h5RSI8+9c0fYEr+j4N7d5u6Z
	KoMv6R1i3MbNiUQBhFAzOMlpdawcOXogNmmrrUONuHCpoxym9A6T8vKPyWTCIfd2ZLaT42vtwy/
	/nnLP4yj5t5nzg3U+UMuAa+S3vhNfzo79c41fIHL90YRr9+EwbVjO2awFK+IAanqbqA3jN8GfIb
	/ILwhuEMOVkxZWUapOzIHVpHhlf2yxsCoQlsQNlUcsM3s3/8nil7J8aEvlzkk+ieC1MTtiwDvz8
	9xwYNcErfAzwNjrNMaEZQbV6fIEux7D4SSRiDsdc8hPKqgdqoegxkOEEAr+lR0X4dD11mPPgj7C
	q0S12GJU3CL1G0C85wpKIeD6jcXiAP0HmzGASMOqOjY+9V2jV4iMpQOPCmPxcpEckZ5KwUVvhBo
	A/MQBTOm5R2osfIhGxtzHkzRqnZ/PJx9Av+h9s9ryQdPgPpPsadrYE+QgUGWLnEXef8x1IgNb1V
	A==
X-Received: by 2002:a05:620a:2315:20b0:92e:6286:d57 with SMTP id af79cd13be357-92e696c2f25mr346923085a.7.1782854345341;
        Tue, 30 Jun 2026 14:19:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:19:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
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
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic whole-device hotplug
Date: Tue, 30 Jun 2026 17:18:41 -0400
Message-ID: <20260630211842.2252800-10-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 621CD20004
X-Stat-Signature: 4cwqphzoykey3wgq38buxdfp1d4m35rr
X-HE-Tag: 1782854346-86704
X-HE-Meta: U2FsdGVkX1+XH79eHVGOSXNmdT2uA0RHHGdhR3e1D/lG08bGn1K8tFKm7EplKkGtSsCaDQqxU2zkg5ejKriZdKPPvMNWSNRnMVG/Bphdvgfs3Vv9SfngX6J7BWTKPhXG9ya6CLintHfNLlnCyphKZT5aXjsydoLWSGbJFRFfc4WyRARZi3RD0G/gPcKArFnajYo+5rFX5B2MW8B87a/xHlCrIB7tl9p+2dEP0KTSFkpos4zssnVTrwIferl5Xf+RyYqdnxhY/Ren+fgPJ25bHrvPKoDEt4v76ZJt7RC5dW6EYNGijfvAWDqPoqeJlpE37L7KuyiTsOmP8Pb/bONZMz+97XW9ZOBa9J1Na29cm4qaWOEgcchJVgnf0Amiah6LCsfEuOSAGFGp3PgKf0PRS6weBwQB4bTh7lGwY3ejas5cQPHvWXLbFuv/F8X98iphG3QK48ieN38SMJeyiXAQbSu+EEhbaXS3cIsCxkvvFemzosUPj87WFbyUSnFen9kycKcRUDzvWGM64UxrBG0UMB0/WvTTBrwzickg1vsD2PYDrhMJcLBiBYQ5ox3vEIw04q8FHGleq1B4Dw9zAspSg4mo3Ezh1L7byYpCjJqyBZkweqlM5ifnQpX7IVUf+opswCM+rNcxlZFIbmaDdVJnfdlyJ0Uvz2ntxiQOaMq3q5HdWOgoGd1+XQGmtqGgd/2cf94DbjO1delNrjpHFDusleKTgvNn5oQ+hMUwgkYW5E61tlMaepQmwC1RapDiNqtDBm9mABnui5869xQYI8u1iP3TVLSruNZCBEX+sm5CiJdgQguP3F0GJu1+3XgxfmWwufVJeH9h6htQnCWe4uR6vGqx2UYiNutXblPlrPdcP9J3xrmySbryEvB7xUcS9Fm+YoOrVOcYQFvz2AKCp5uV/YVbaqTI382tk8XOiFz8yAjJWWrb7nVbmmxTaYCofaChNkq8V6VAvo64TDULBDU
 HKVL/45L
 PYgg2r7FTVoKs6w6tygeN/8PiYGj4sOqKbXUowPwz4kj/Y36cto5ZlWRyBevJYkTKm7sMTm1jp9sQVDMhjH5f7FYJQ4jM142L45oqZV2RZFftXhcPryZOG2kxqWDvpemU9aGyKIkXjQ/CDg9JqU6GNu3YEgojevAp7XBgaiKeNJCwUoLYmH65CVGZ70hUPUmNWnl3LYD9j9hL/Kf8VbZFcW0nWG5OBkXE3mUIi8nZhi8uSqwIwfusD2ZBg7p7g7NgCig+u6mwGJ0uivIhF38FW82aUOXIOIZYG0ICDWklrJRF6gUXJkrxKFnBMF0aKxPewz51GiTHq7sIpGA=
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
 drivers/dax/kmem.c                      | 258 ++++++++++++++++++++----
 2 files changed, 248 insertions(+), 36 deletions(-)

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
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 72dcccee41e1..19effe0da3dc 100644
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
 
@@ -123,14 +145,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
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
@@ -193,45 +215,64 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
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
+
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
 
@@ -247,6 +288,18 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
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
@@ -256,6 +309,85 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
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
@@ -324,6 +456,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -336,9 +472,15 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
 
@@ -357,22 +499,62 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
 
+	device_remove_file(dev, &dev_attr_state);
 	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
+	 * If UNPLUGGED: state is known clean and reboot can clean up.
+	 *
+	 * If ONLINE_*: memory cannot be removed here: offlining during an
+	 * uninterruptible unbind can deadlock. Leak the resources until reboot.
+	 *
+	 * If OFFLINE: blocks are attempted to remove with remove_memory(),
+	 * which never attempts offlining. A block onlined behind our back
+	 * fails -EBUSY and is leaked.
 	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
-		dev_err(dev, "Hotplug regions stuck online until reboot\n");
+	if (dax_kmem_state_is_online(data->state)) {
+		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
+		any_hotremove_failed = true;
+		return;
+	} else if (data->state == MMOP_OFFLINE &&
+		   dax_kmem_remove_ranges(dev_dax, data)) {
+		any_hotremove_failed = true;
+		dev_warn(dev, "Unplug failed, resources leaked until reboot\n");
 		return;
 	}
 
@@ -393,6 +575,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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
-- 
2.53.0-Meta


