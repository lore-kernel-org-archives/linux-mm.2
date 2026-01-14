Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B81FD3CC8C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7636B0092; Wed, 14 Jan 2026 18:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBFA6B0093; Wed, 14 Jan 2026 18:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129776B0095; Wed, 14 Jan 2026 18:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02D8B6B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:51:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CBD55603E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:09 +0000 (UTC)
X-FDA: 84332217858.05.D054EAA
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id D06FAC000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c8WLg9HN;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768434667; a=rsa-sha256;
	cv=none;
	b=VYioeLX5EAOSOWQxbqmQagU8c0eUKlS9glUyYhmEZ9irbYQMBSXpIug5v3h2sC2k5MZtwk
	OdtX1z8FJ/FxroHwr1SAaU60jgHb/r6iuopmcAlTp3zrK9d/s3RpqWWhjCuPFAmGlnmcyF
	YB7io2Jl2jYftfuoIOPHDJf0NwjU4ig=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c8WLg9HN;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768434667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HO1V54BeeL6soGWklBzHc2sknfCRHcpjkYKQEUfGCuc=;
	b=rB+m6g77sYsKAwT+tJ858bx30S8i6dlrxF4bVw1PcNd9BfARLNp1wo7Rmb62AzsLeTuLMf
	aYFBL9uov8ALkn8JRXd8g+EbOKRtUL7ttkbKjPgSTT2bDTB3s5OCgfiViTw8MAAkcuF2xg
	MyOObFsvIigXnqvaa1J06RXFpffJVzQ=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88a2fe9e200so2695846d6.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434666; x=1769039466; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HO1V54BeeL6soGWklBzHc2sknfCRHcpjkYKQEUfGCuc=;
        b=c8WLg9HNnQC4xwy9/rWBFhXz8+lvOJcWoQBUJKJhg6rtz4+g8LXGpQNIZKDZzAfEuy
         XuBzmzZaGkTyAHGB9V5pzXkEVLqQnvFwH916fTN/mNnm4cWT0iKP3K2VQSdK6+VZ5cmp
         L2J5AlLYuZalWCpYdDEBYG4hVqJr+J3SRIA4UftMjyAw/13jHcMQUBhtgf/buNzKE8B/
         bjpdsuYWGtGPVVht5e7JSrQaQf/XotlMel+OogWwOnYiKWqMQ5gmrwRNlAo7pdneZSft
         gv6F9sMZd+u/RvmhnnExfzLU8FNEHkS/JtxopAjZ+sIMSwlaP8yjBO963QgEs3p7HoJI
         HRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434666; x=1769039466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HO1V54BeeL6soGWklBzHc2sknfCRHcpjkYKQEUfGCuc=;
        b=UU/Um/XPcjUMqyXl3ScbvxlFzrzTRwjtlH4vjwUM1kVhbkDd3iKZjPxifEUdvK4itj
         2zVGxk3fY/seYzdj1ZpROWYiA4SkZUas2IveytfhtACNbH8i/ympf/M2MXp+LC+Y+5Nm
         XY5WrrKw2HYdKEoMEKczcx7gdapmZd8+X+JgLN+O477q8+ag03JL4olu//39cvtKBOji
         VxaOYvvQP0uFVPB0yaxfS7OKLvdTEDwygeGDES1RxNrKKwo6FcLmoH/0afA6SkCp1wf5
         OygoJQzjnBif0Keimwepaq9LkEc3LuME+Oz0Zt7XuDS2/UDB6N4adpXx8U3EYaXR7kjM
         WpCw==
X-Gm-Message-State: AOJu0Yx21ugiCFOSPiRytBmODL6PXnd+Dttrsv9GqNkOWgP5gE+WDa31
	toHFkhkttmK6r9Jo0W+3Hy4AWlTaBUK1t378FVq+yT0Te8mNuW2UolTIcUioX854lJdcmE84JUh
	lE2q8VgI=
X-Gm-Gg: AY/fxX6K37uDR82GThImu9hZP8nmGRwYsTwP9EediTERoW6fEmb8zsFZVMUNRScfpCd
	ECe6RzDc2cajvSbfTE/7e+/B/LVG1ekFNzLCBX43fYvMj58+QG6KMW8K1J3Xk0gmfmZiYZlzxoi
	wGVbqgPIaMNMlYhtjwjiv5g9LAAwUn10B3tQlWRSyFjivjYDtf3syBVaHa6qLOHGfMSx0p6QEv7
	/L0ZbVSqyPdPnr//z4L0n/QnLir8hIEBL+O8zv9s5jfwC6STclScEIP+3bpgF+wfSmr1slJWSMl
	MBG+UJ0RI5nk0CylCzrD98NyID5Utgv4sdgwuHpy/udsXiQoib9dxIIztOLrlC5I2o10tQ9npP7
	Aa0MD7Rg44JwphDQ+MqdeohtmL1+gIHvH98nqgMwYeyh1EaulNkjenwCW2Xn/qw0ZKEuXD0lz/S
	5G06uGkFMWltlV/qJozF2zpoKuOofJNyIhfOdsOWGOUot6HYvp9JwlqacbYE6pAYHpXxwtKDAIK
	O8=
X-Received: by 2002:ad4:5aa4:0:b0:880:48e4:198a with SMTP id 6a1803df08f44-89275c0aef3mr46108836d6.32.1768434666420;
        Wed, 14 Jan 2026 15:51:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:51:05 -0800 (PST)
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
Subject: [PATCH v2 4/5] dax/kmem: add sysfs interface for runtime hotplug state control
Date: Wed, 14 Jan 2026 18:50:20 -0500
Message-ID: <20260114235022.3437787-5-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D06FAC000D
X-Rspamd-Server: rspam06
X-Stat-Signature: pxbsw8bhhy797deyeb7g6ho73s7n4crn
X-Rspam-User: 
X-HE-Tag: 1768434667-687147
X-HE-Meta: U2FsdGVkX1/JpbBaAIvoKyCfaF1ty/5Vg4wdANSmkxYa8ePJaAI/qLArKUAkbQhMRgJIhUtP3I1O6juKhb1A+U0Ur6j4rIyQVDYlthZeHVPiW8/oen7z5KJ1x9cr6+y1shZqyR7B449fTYrQ4WmLhE0BlpqaA5V8A528KWvuMV1vlaWnxZlpyn+yRHsx5hesSt40bigbGSkorrWXgmXKbyFu1k7JPxmBllwxjvJNH87uWIOkIrAZBZIAHliKFBTrL9tIQEVB0vTkqnLfjx65kSlYYT71NXKBhmVSqMcu+iuPdxqQxzf2hQc87Mz6cMCX7Pbnf3ewPrHAXjiVf1ALe7QXRnU4HUOtoSNjUCjXYUEjyT2X1cKlnBlIG9wSGXEv09qzbyyt4KhDe56BpSkAnW91YwUzEFXgEFV83QeEndTsm3DLcmdaUtaHj852WRObi/fDSZZ9G45o/5eOJVwfRA5yzmMoYnWEvIOletkmQuaGQgoytYsMZUGU8/NaQIN22QtZl0tgbWKw2kcqpNjqgrdDu7YwQDt15h08jNJLhCwLPfVQvQEvqgQwI8ywDcOuVarX6zsFhmfPaqI1vk081zZhO4euA9dYzw8bXplQn1fHkPpq34MjzWR4rqD+RzcataJwd3OuEXw/5Aa9VqGW/UGuDivTSGWOqFd85k7e5Owx8TA93LTTHE6tGax+l1PNc/tDX3soJSLDJE+zp5OffWDPix+WkkYZj20eFRob2OLgaLSQWECSm3BK5nH/pb7boRYS6NM3CC/aBnEGoRnCWblOy1y59XfxH1qR+C8gQpVjHfBm9+npdlZ9nNzcW6Z1NxFVVgoLUr9xXbjNDZ/XRd3F/5YVmWf5A30o2V62zbibPbpCMISvapvMI/GPYRrK5+5esFiUBkTlcD4x2uE1tFZTS66MBNKydWo+SDnJuutWSR1X8RPW4iIWcNZ6oeiInJQbRIdWVbe0zws5iGX
 VrFVIakV
 xisGpumcyMMrejKNyaGTVyRI+KbfQ27RwCXSA0JGUkrmGzF0smAPXl1ecqMYpzdvfB9NP5iqd0f078HIlQRKoLeOc5tsT19/A1XqFV3e7mWMLSHErra8f5ON8D9KtJP5jM/a2t2Hkv0m81N40gRVr/D1S8a4GTDJRhWdT5BdSe5z1SZXCfretwAQpB100P1ymX1wPxErZUTF9EwNSy77+mbwxhDuFkLputeMmBGyIBq6aMZP+/u7sgr1uj3NZ51QnchTMcqoJrQnNawIV9zX1OZLAAdHOD0KnOMUeA8Aq/djuswizOETI1tLtpG/cEdAXt2if9ZoHUh4giAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the entire region state at runtime.

There is no atomic to offline and remove memory blocks together.

Add a new 'hotplug' sysfs attribute that allows userspace to control
and query the entire memory region state.

The interface supports the following states:
  - "unplug": memory is offline and blocks are not present
  - "online": memory is online as normal system RAM
  - "online_movable": memory is online in ZONE_MOVABLE

Valid transitions:
  - unplugged -> online
  - unplugged -> online_movable
  - online    -> unplugged
  - online_movable -> unplugged

"offline" (memory blocks exist but are offline by default) is not
supported because it's functionally equivalent to "unplugged" and
entices races between offlining and unplugging.

The initial state after probe uses mhp_get_default_online_type() to
preserve backwards compatibility - existing systems with auto-online
policies will continue to work as before.

As with any hot-remove mechanism, the removal can fail and if rollback
fails the system can be left in an inconsistent state.

Unbind Note:
  We used to call remove_memory() during unbind, which would fire a
  BUG() if any of the memory blocks were online at that time.  We lift
  this into a WARN in the cleanup routine and don't attempt hotremove
  if ->state is not DAX_KMEM_UNPLUGGED.

  The resources are still leaked but this prevents deadlock on unbind
  if a memory region happens to be impossible to hotremove.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  17 +++
 drivers/dax/kmem.c                      | 159 +++++++++++++++++++++---
 2 files changed, 156 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49..faf6f63a368c 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,20 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/hotplug
+Date:		January, 2026
+KernelVersion:	v6.21
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Controls what hotplug state of the memory region.
+		Applies to all memory blocks associated with the device.
+		Only applies to dax_kmem devices.
+
+                States: [unplugged, online, online_movable]
+                Arguments:
+		  "unplug": memory is offline and blocks are not present
+		  "online": memory is online as normal system RAM
+		  "online_movable": memory is online in ZONE_MOVABLE
+
+		Devices must unplug to online into a different state.
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 3929cb8576de..c222ae9d675d 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -44,9 +44,15 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
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
 
@@ -69,8 +75,10 @@ static void kmem_put_memory_types(void)
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_ONLINE or MMOP_ONLINE_MOVABLE
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Hotplugs all ranges in the dev_dax region as system memory using
+ * the specified online type.
  *
  * Returns the number of successfully mapped ranges, or negative error.
  */
@@ -82,6 +90,12 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 	int i, rc, onlined = 0;
 	mhp_t mhp_flags;
 
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
+	if (online_type != MMOP_ONLINE && online_type != MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
@@ -174,9 +188,9 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
  *
- * Removes all ranges in the dev_dax region.
+ * Offlines and removes all ranges in the dev_dax region.
  *
- * Returns the number of successfully removed ranges.
+ * Returns the number of successfully removed ranges, or negative error.
  */
 static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 				 struct dax_kmem_data *data)
@@ -196,7 +210,7 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 		if (!data->res[i])
 			continue;
 
-		rc = remove_memory(range.start, range_len(&range));
+		rc = offline_and_remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			success++;
 			continue;
@@ -228,6 +242,21 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 {
 	int i;
 
+	/*
+	 * If the device unbind occurs before memory is hotremoved, we can never
+	 * remove the memory (requires reboot).  Attempting an offline operation
+	 * here may cause deadlock and a failure to finish the unbind.
+	 *
+	 * This WARN used to be a BUG called by remove_memory().
+	 *
+	 * Note: This leaks the resources.
+	 */
+	if (data->state != DAX_KMEM_UNPLUGGED) {
+		WARN(data->state != DAX_KMEM_UNPLUGGED,
+		     "Hotplug memory regions stuck online until reboot");
+		return;
+	}
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		if (!data->res[i])
 			continue;
@@ -237,6 +266,91 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 	}
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	if (sysfs_streq(buf, "unplug"))
+		return DAX_KMEM_UNPLUGGED;
+	if (sysfs_streq(buf, "online"))
+		return MMOP_ONLINE;
+	if (sysfs_streq(buf, "online_movable"))
+		return MMOP_ONLINE_MOVABLE;
+	return -EINVAL;
+}
+
+static ssize_t hotplug_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	const char *state_str;
+
+	if (!data)
+		return -ENXIO;
+
+	switch (data->state) {
+	case DAX_KMEM_UNPLUGGED:
+		state_str = "unplugged";
+		break;
+	case MMOP_ONLINE:
+		state_str = "online";
+		break;
+	case MMOP_ONLINE_MOVABLE:
+		state_str = "online_movable";
+		break;
+	default:
+		state_str = "unknown";
+		break;
+	}
+
+	return sysfs_emit(buf, "%s\n", state_str);
+}
+
+static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
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
+		if (rc < 0) {
+			dev_warn(dev, "hotplug state is inconsistent\n");
+			return rc;
+		}
+		data->state = DAX_KMEM_UNPLUGGED;
+		return len;
+	}
+
+	/*
+	 * online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE
+	 * Cannot switch between online types without unplugging first
+	 */
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EBUSY;
+
+	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	if (rc < 0)
+		return rc;
+
+	data->state = online_type;
+	return len;
+}
+static DEVICE_ATTR_RW(hotplug);
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -246,6 +360,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	int i, rc;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	int online_type;
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -304,6 +419,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -315,9 +434,17 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	 * Hotplug using the system default policy - this preserves backwards
 	 * for existing users who rely on the default auto-online behavior.
 	 */
-	rc = dax_kmem_do_hotplug(dev_dax, data, mhp_get_default_online_type());
-	if (rc < 0)
-		goto err_hotplug;
+	online_type = mhp_get_default_online_type();
+	if (online_type != MMOP_OFFLINE) {
+		rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+		if (rc < 0)
+			goto err_hotplug;
+		data->state = online_type;
+	}
+
+	rc = device_create_file(dev, &dev_attr_hotplug);
+	if (rc)
+		dev_warn(dev, "failed to create hotplug sysfs entry\n");
 
 	return 0;
 
@@ -338,23 +465,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
-	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
-	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
-		dev_err(dev, "Hotplug regions stuck online until reboot\n");
-		return;
-	}
-
+	device_remove_file(dev, &dev_attr_hotplug);
 	dax_kmem_cleanup_resources(dev_dax, data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
@@ -372,6 +487,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
+	struct device *dev = &dev_dax->dev;
+
+	device_remove_file(dev, &dev_attr_hotplug);
+
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
 	 * device-dax range and return '0' to ->remove() attempts. The removal
-- 
2.52.0


