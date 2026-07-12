Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A13C0C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86A56B0095; Sun, 12 Jul 2026 11:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36C06B0096; Sun, 12 Jul 2026 11:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63656B0098; Sun, 12 Jul 2026 11:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0A06B0095
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E22D0A0908
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:26 +0000 (UTC)
X-FDA: 84980549052.01.9716AFC
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2CF31C0004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XFRGa5iD;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYjx2PN1x6uh3R9+6IQFG7Hc6bZQLBpnO2wEgzswHD4=;
	b=OfD/NByWwv01+9c4QljoJ8+Siqhn8xWqcEJSAU2B8bUD198VZm+nwTHbW68l08MfdiL0AH
	khyGaIbBQJRk8XR3SfFEfRlDp3oFw6PwfvnA+4kPE0wqAMRT/1PFRZBl5XMuScdONqR5id
	+MgKZuXClKaWslj2naXRhls8oR1vsOw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XFRGa5iD;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871125;
	b=TQxKTGuAJORKQ//vXkS0qzItsEzmog6MuuKsK4TDDvuygMnC7eKtLpQI1dw0lMwUDG/M8L
	xra9yxDqx/9GfT0wRjDmwP6b8SoMGZCVU9Flh7l5XxNdfathfV8o56I7bUT3c5Y7jbpEND
	kWemmNe6FWeUp+tBxlpO8KQi9BQu0Jo=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e6c4a867cso129085585a.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871124; x=1784475924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DYjx2PN1x6uh3R9+6IQFG7Hc6bZQLBpnO2wEgzswHD4=;
        b=XFRGa5iDDtm9kOyqmjeCsOXfxJnUON2YKayesK3hiyuQxroLz/+3lKMqCcdgWMkMEO
         +3QCGOi3QjocY9lPuKCmgXYiKB9rWrQ0Uq2gwy2hXVADFz9PT2KabdiQlLqiUa1KsIRU
         deheE+O8ze3jK5fzaSFKw8uLelQfm2Y6rxTSRbPySOzE2ybiWzGbsrT4yi4lhyFOGRgO
         47lJ/y+EG0iYUBpS/3GJSWWDguoKjR0Ed80wfMcwOY5m0grlT/y1jU1P387IZX4Rf6SX
         2C8mqFPw/oTcDCmWqFiD/Dqd4USrGUw5Qp3tNio5EOHWdjAiwXXIkxQX0iQCoUGOSwU0
         E0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871124; x=1784475924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DYjx2PN1x6uh3R9+6IQFG7Hc6bZQLBpnO2wEgzswHD4=;
        b=YX3e4+5siKsbwvszTr6bihwegH1xzWctRkxLsOluo6oQPDQ/z9NTMgr2zvwUx0V0xF
         NGzCMqdcutIN95VnFY4meUsjRlfFdx1RskK6AagCgC+qTdk+w7ogp8fShdaQtndHMzOc
         j+PVEnK5c8yPOXd04ocqC5zRzedNS+LG/IGQwMKcU7qJ+cuoXD/vUvPFWs6oQnzzqUUk
         3Q1kkG+yo/3jOHou/4BB++56WducpZl9FeryiLm3I8TZS0gPVQ//uUoZj+3ga8xL/s/G
         ikTroHXMaD8MTAdZN9SkyYB7dqQHdm2XYEF0mqIMc23A+jRK69GCDuFcn4XNUpReWOUu
         t6lQ==
X-Gm-Message-State: AOJu0Ywp7qchpXWSXX97dG6lOvXBqhVhyDa7yXKvcrtCM7lDBYpsqPcl
	3xa5+b7uAJMeNjQBnoFYzc37bK34xf1oI17PIpLZOoUb261cXX5O+3T0mu2lWPOLlgSTVLHL/3o
	wItfz
X-Gm-Gg: AfdE7cm9U2uZmDTPyBO6mYsvVG3ZSrl5ZSg4AK125nuzyD3RMf9LhYsiorzP8vkDNSM
	eX2HSGOQRP6d4nBLcif5GfeZQ0ufSYfjY5jwfM1YiG7NDjsuSU8xIYW0aiaHCIGIxalf8MaAs/Z
	JCgppQOxNDptve0D4jRFeTGZQAM7ETnNL9mweh6KGRgubdEXLZqdSOQlxbOsrDDdKtG8ShU+p3c
	5EhfOzOx6uGhEOa+IPHyRJQIp4GpnwUeByZ7h4BAVg8ZA5vVekW/OJwYYivYY9ASJy3OK/8Sn/M
	DkBD7099kCMfEyARuT+63p26lWTGnEEd5ck5m/MksPKhyxlknFFXz8dT2usWfTNgbW59Vfi7FGs
	z+kUCCelHngK4yzdVJv7um0AYebcX2z2Iy/EbGbZggdvIoVgf6/qhf00VtSJmdTR4wS3fF0hPHp
	H9i7e52wKOez4qoKxYW/UIXCJn7QDPRnRjzC/FNiENIAlEu1n9CKR1lMnH6LZ3u/VoG2pHWngj1
	A==
X-Received: by 2002:a05:620a:2894:b0:92e:7533:ef67 with SMTP id af79cd13be357-92ef2be4e04mr657175885a.20.1783871124238;
        Sun, 12 Jul 2026 08:45:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:23 -0700 (PDT)
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
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v7 05/10] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Sun, 12 Jul 2026 11:44:59 -0400
Message-ID: <20260712154505.3564379-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2CF31C0004
X-Stat-Signature: qc8o6ishffxoy9jfo89kkawmkqtjxeyu
X-HE-Tag: 1783871125-631904
X-HE-Meta: U2FsdGVkX19Qq2RNSRgB+i7moW0RLcVtbV+kgcD9eiVCyRUTM49daWV3dyI4fB9W3D2MAgzkFMm9jifTknnKGebfUqmu7RxJGVCZmcPKtJCaAPItbj30CdwJAct87UTS8UMdrkjhHiYeN+0lFcfV+5xJ0DfgC973eeB9FLqxkQX+TgFlj7AiMTbTKHq2WFYKK87sYrjvpLyZkE4BLf2uhY6xYYNZgoQ+/eyYwU9JIjfWkGWgyi00Ls6ajd/b6xPcWwPlQtvu6hdSxmeQhEK579sZU1HCVtE2toRoTIocF5T7u76/GqKipA0xCc2XYVrLfvWiUPoOotRwWLZkOmu9rGKh5Qea4zfyUshHUlFT5fjH8tNEoU8ZMiKTYajEY9PBjo3/QuPi+9Kv9N3JM2hwZMqsIsF8MGS8JlQ6rI6mdKS7ZzVBtPObePfC2ie0/HLvYiBxZ3OJf2Aqn+hOJt7s5cbPU/SFNOEE3vv/Jr9PS99M8yuvlew038N+axr62dClVGPyaYeyGZul7o7C0qUlS9tnmL18PoNpuJh1nF4eHaReocHlHBFob4lyB2ZO7FfhcERDP39PYQUpDURWG/NCjWGkrAZhfwxKw0bE7PM4FIOGUtBTL8iUPnE2BPvGTxSe5o5MuQUGU1DMpAeGgjiX0Fo1SG2cQz2IVsuIbGVO3V6XsUr6gkUEbNTXWmHoZnKhE8AvNJZd6wHCbyigSICiNHgMuWYCUm03y0jv7/P8DwS0u4Knhbyl980orfhFy2t6B6if/eqNCXNyR/xfc9a2WcCHHSDku/RdCMBTgaOKxQ2A0h+6T4iNYln+MxSlHFBC2np0nUZlfirkTG5RfVaMnnLrmOeW61N9+v6PmvsZ8AbzSSw8V7f0Cemq+SuscYF5hVss9HavNCSxBywWfYqjReHPF2syfCT3aigMke5dc7JNqP1Dm7hHPSnXVJISj32H0TzZJ6x8MJmj4Yg0RCJ
 gANKLjMd
 Ru1M//HUd15peDS85MD5ldhtghpt7t/SO02JCdbCUgtIDBypa8219wjYjclgx65595RXFiitVYq4mKuNQi1fc24lkIc44Uq2Inn8E4+lV8sk0C783drPTUogT45PLxqiDErzN+tJkOFUZXJxms0vCBOd3EorfpiXa6SHptBM1aGcxRk0t0sPMSZ+E8lUlejW3OehRM/Gfr0LgxJHODmGxQamL8wu7G0vtFASC+ppYJZHwOoc+dso/y1YlQlohYo/hRUBKMlf2ZZQkMWRqZxdr7i5wrPWpP66PNcUVtkEOxGKzW5UrI+kGtDqsQXdZ02xyd63meUnD+zfD1zsecqw72RdJSukHxbh5FuTbpWbck5syaC8lhhnptaYTdmnNQUDcfqQ/kV0siN+/+1ixx24lJ/DMUPNMbBW7BG/lm8RNWuB5IPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Existing callers of add_memory_driver_managed cannot select the
preferred online type (ZONE_NORMAL vs ZONE_MOVABLE), requiring it to
hot-add memory as offline blocks, and then follow up by onlining each
memory block individually.

Most drivers prefer the system default, but the CXL driver wants to
plumb a preferred policy through the dax kmem driver.

Refactor APIs to add a new interface which allows the dax kmem module
to select a preferred policy.

Overriding the configured auto-online policy is only safe for known
in-tree modules, where we know the override reflects a different,
user-requested policy.  We do not want arbitrary out-of-tree drivers
silently overriding the system-wide onlining policy, so restrict the
new interface to the kmem module using EXPORT_SYMBOL_FOR_MODULES()
rather than a plain EXPORT_SYMBOL_GPL().  Other in-tree modules (e.g.
cxl_core) can be added to the allowed list as the need arises.

Refactor add_memory_driver_managed, extract __add_memory_driver_managed
- Add proper kernel-doc for add_memory_driver_managed while refactoring
- New helper accepts an explicit online_type.
- New helper validates online_type is between OFFLINE and ONLINE_MOVABLE

Refactor: add_memory_resource, extract __add_memory_resource
- new helper accepts an explicit online_type

Original APIs now explicitly pass the system-default to new helpers.

No functional change for existing users.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f19893f5fa948..593e42c221ada 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -295,6 +295,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				const char *resource_name, mhp_t mhp_flags,
+				enum mmop online_type);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
 				     mhp_t mhp_flags);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index be8e8e2cd1535..aaee8470eb2ad 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1495,10 +1495,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
  *
  * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
  */
-int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
+				 enum mmop online_type)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
-	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1586,7 +1586,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
+	if (online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, &online_type,
 				   online_memory_block);
 
@@ -1604,7 +1604,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	return ret;
 }
 
-/* requires device_hotplug_lock, see add_memory_resource() */
+int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+{
+	return __add_memory_resource(nid, res, mhp_flags,
+				     mhp_get_default_online_type());
+}
+
+/* requires device_hotplug_lock, see __add_memory_resource() */
 int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 {
 	struct resource *res;
@@ -1632,7 +1638,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 }
 EXPORT_SYMBOL_GPL(add_memory);
 
-/*
+/**
+ * __add_memory_driver_managed - add driver-managed memory with explicit online_type
+ * @nid: NUMA node ID where the memory will be added
+ * @start: Start physical address of the memory range
+ * @size: Size of the memory range in bytes
+ * @resource_name: Resource name in format "System RAM ($DRIVER)"
+ * @mhp_flags: Memory hotplug flags
+ * @online_type: Auto-Online behavior (offline, online, kernel, movable)
+ *
  * Add special, driver-managed memory to the system as system RAM. Such
  * memory is not exposed via the raw firmware-provided memmap as system
  * RAM, instead, it is detected and added by a driver - during cold boot,
@@ -1640,6 +1654,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * Reasons why this memory should not be used for the initial memmap of a
  * kexec kernel or for placing kexec images:
+ *
  * - The booting kernel is in charge of determining how this memory will be
  *   used (e.g., use persistent memory as system RAM)
  * - Coordination with a hypervisor is required before this memory
@@ -1652,9 +1667,12 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * The resource_name (visible via /proc/iomem) has to have the format
  * "System RAM ($DRIVER)".
+ *
+ * Return: 0 on success, negative error code on failure.
  */
-int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name, mhp_t mhp_flags)
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+		const char *resource_name, mhp_t mhp_flags,
+		enum mmop online_type)
 {
 	struct resource *res;
 	int rc;
@@ -1664,6 +1682,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1672,7 +1693,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1680,6 +1701,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	unlock_device_hotplug();
 	return rc;
 }
+EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem");
+
+/**
+ * add_memory_driver_managed - add driver-managed memory
+ * @nid: NUMA node ID where the memory will be added
+ * @start: Start physical address of the memory range
+ * @size: Size of the memory range in bytes
+ * @resource_name: Resource name in format "System RAM ($DRIVER)"
+ * @mhp_flags: Memory hotplug flags
+ *
+ * Add driver-managed memory with the system default online type set by
+ * build config or kernel boot parameter.
+ *
+ * See __add_memory_driver_managed for more details.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int add_memory_driver_managed(int nid, u64 start, u64 size,
+			      const char *resource_name, mhp_t mhp_flags)
+{
+	return __add_memory_driver_managed(nid, start, size, resource_name,
+			mhp_flags,
+			mhp_get_default_online_type());
+}
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
 /*
-- 
2.53.0-Meta


