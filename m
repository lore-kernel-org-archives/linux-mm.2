Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F409CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79626B00AC; Wed, 24 Jun 2026 10:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29B46B00AE; Wed, 24 Jun 2026 10:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2186B00AF; Wed, 24 Jun 2026 10:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85E3C6B00AC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:58:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F222F4031A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:05 +0000 (UTC)
X-FDA: 84915111330.11.0370826
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 282A5140007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gkwC0J+B;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313084;
	b=zm1uavKY5yNlrTAw/0VVlPRPbFE8b6uJXbDUWw+75J/EnokZdYWFDuAbgHtoThsZBcLD4F
	PxU/esEvzAMAie0J2NsqhpKRHyCIInnQOHmqs0v/EfrYuXuCZqurfmO2fhtRNva09GMMZO
	P1B3UTQT1U76GUbO+fMI4qj1e9/BjQM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+5ae8LUmAy5WSGBFjad2biDCNPqlKGypmJhGythNzI=;
	b=na1GNLR4SX8GqSz2WQuTzBkKZVxy2bsSFpIDa+rFYtcZmrmGmJFj9bK/blhoHYUL5sAkTe
	be8TJb/YKHYCpS7uNSo10Zttwh69PlDP5bYSY2X69TsOL4r3ysEK8zF27UZM/W3LQdMo1N
	pHtfEhsICVpRKd6ep7iGf9O/pvMa1sU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gkwC0J+B;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-519f6a10d9bso7348671cf.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313083; x=1782917883; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+5ae8LUmAy5WSGBFjad2biDCNPqlKGypmJhGythNzI=;
        b=gkwC0J+BYqxrARcqJbxaldtRKG2ZHKWliflgndd1Tt6YBrc0GKH+CZ4HpN6zAPXz7J
         hAcE4ONsU0WsAT0VQTsItNruqJpYso9B6I0n4Yv++wpfkDOFob//WPPxUCTGrcRFNw8/
         prBnIGBPtvWjAz9PMBs6I5xLcq/l09p6pKmeiQ4qHAfi+svFwUvTCtCbIW6Ry2+xT6z+
         AlGQL8RuxWyhv0st5+SSUVMK0YKewAfTNl5DKo0432z0Rq2vu63J+Rj8xuJrWWh5OtI+
         0IubdkHaDdKN/NuMqx6NIX38j9Oxc1VOTFMTviLyfBpjZy70ZsCTTr8FiVmrB1lB22WR
         ipgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313083; x=1782917883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p+5ae8LUmAy5WSGBFjad2biDCNPqlKGypmJhGythNzI=;
        b=RkRFac4DrhbMylikFHma61FEhzn/jWBchN10ELAMiZZcLWfHK2NPjJSZsFzfM/LkHf
         gpPF9eBCN3x8bt0vdDicsfCWMOuez/eCCuMeLMpMpsP4t80j2dJal8tX5Bfh10Cr/2Gt
         NJXVeTutQtxghmqiE+aLmDhF1LbIqIhx8PraXTnNPtZHDkiPKkgMQ8KynzLmAjhOuJ6+
         Ysp5IdJiJpVr6yK1BiX/R/Qq06mk/PtNa9/OgAFSVwWgOepjbP+2MH/eK1nZoaiTuWYP
         zaYh8OwbSdJ/h33xjMglZz/iqH1N4gSYU0ysc8a29XQFA30Dv5LfhWpIDL/HI41NZ75G
         u90w==
X-Gm-Message-State: AOJu0Yx7Joe64L8bfDBa6sSimU1WVDoxmdapl07au8FPeTUVx0CPMm0f
	/GAw6H1+1p84lstlfwALJfBTUBED4rJXummcofiLcie/er6Iudt4Z6189WTA2FW6B3P6AHRAT9v
	t/e+g
X-Gm-Gg: AfdE7cmvisRVv29qeUkRASx+N4fgG+6Nlj9L2sc1Wa8D3yrcbjk4UXF5l1oC7MwlBQX
	Dp6kcNlif//xi4eIEkLxXRe//nBhmOhLoSLrBQIUvdM7+9xovOVZ24BfupBojxZ/dwOK9/VXhqk
	DTFOy09G6Ad7yBrnENCK5qsYdE/3gOOhmu8p85nYwv8Kh7Oa4ukqPHrUL26MiJN42Wa8Za6nJxv
	DbtjB3XHxFmfZyEo3qUquzboElK6r54VsLHMjy9FxuH1DUx7Jb1cBQa7G356EbDKETMjPaMUI7c
	nj0XT3aq/2wpyiLhLhL1Oku5HlN7fIMgpW4OnkJVTudxgTGKHG/Y8qctZJCFf4D2DyAIxsR+R/M
	mLKxRvcZdGefj/d0NNbKVL79QIbBzxEQTcoviCALvbx4WWIHaHm/lTl6lZTn+pKMQJveUk83Urz
	XM5IrRMHq9L7B5z4d76br7oRsJHsq6pgwpsYZ8NZ5cqoClHzhQidSe/Fp6G3bCZK2sJxAUSU+f/
	w==
X-Received: by 2002:ac8:5fd4:0:b0:516:e74e:cc51 with SMTP id d75a77b69052e-51a61f3444dmr55235611cf.51.1782313083037;
        Wed, 24 Jun 2026 07:58:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:02 -0700 (PDT)
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
	apopple@nvidia.com
Subject: [PATCH v5 4/9] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Wed, 24 Jun 2026 10:57:39 -0400
Message-ID: <20260624145744.3532049-5-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aemuqfd9zwwfg4fiw1izbjqhkzmynj3r
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 282A5140007
X-HE-Tag: 1782313083-531787
X-HE-Meta: U2FsdGVkX1+66rmRZb083iSnOcuwxOhSd2+4Dtiv/U38a2cVXqLFXvRFkGp3UP1XLmwuvHaNhwVCe9syCm3gFwYwNat/UDUUYQHGQKyl0FEolcnh+6ShSGdC2nA98mthbTfTKSBbSPRcWpDMIuuOgEkYuxpRMxWughRjgJvhZgv1Nb7VnUtfmzYI0o9ImXjDYYw0CeX33clRCdG03QYMLkYhkwn5Yv+Dz7nKRFIZ/PJ4ScjXayKSeaFNFxq8x4N/9hL6dieMhvqefoij+jVPmkPvrnJXYj7hntdtl5GB67ERVZHeawpodNAsoPjRiUa9dSVqSKqFVGXgXw76I8xWEGeYAuuf9S2Spr467DT3c04+DfLDr6GPXyCnZbScRMEwwyk8r7h8Q+8P8mtDu86LM52O+cgEHIPHTduSIl37gCPNP7cfBr2wZ1D4EaMUIo6SQYNlLBatW0NN1c2iuTY3gl8UgObf3Kwpe2/xl5sa+mGsqhGz28+MBeB0Q65KDsqEbP8CkwtKj5AxEokEZ6oIEgWdUmgHMRRt3QYzmefVeNjHLXFGBEeIYu9PMxCCcQFcUrc5p/WXTIkzAhDFBf2fBEXVi+BRrZUMmsk2zWrBak5bt+jBEmfk4REFbNkD1Pvh1I03Llfq2751PiTN8TTD0nSHxG70hW+QyMScLMXu3x9rrrFTBz4yrv0mEBUBFqhoXRJVMpV87n2EH8gJUvOmXoRDdBDk3tiyHRrHp3QXiYE02XjPXPwrLN4ha+goPTjMxubYIMaGa/ZFqW0C/FyxNg9OYFq+3U9UJxvNWMXL2mqW63nPenlFbsaCh8SM0lZh+Jfx+AkG0o6muyn2cQpeiyDl9wLWnkwMs1ez0h5ZRvTyXwAof5ZuDN4yr/fLyJh5g4TPeJG/HzrC9FSck6lRPmJLeQR9BVsm+J5vJBY7BVBIzIzovpUsYJ9WN+WZJYIAf6Nlpomb++Hb1lin2YS
 +ubO5T13
 3w1hFbWaB3kJtzQYyWMK74dcXgV+bHqO2/jlbSzTB08jHo99BXeIF6uM+IHhfR7RB3g+Z4qSn4niJn7ayVqVFQqPqYnzJxKMF4RY/vHkbawghqxVm18hovMhXGPNJpM1RismJWOIXJrmbFuFsAbDEZe8HP6kQdZXGT/wY2Ecp7ooCq3s61q4sDnnQz17doxZAGDZHY1TRLUvNqaF9IiJMrrTRCKNQLswQrdg3oD4O576PapavZv0elNQFQah/BhY5Kq+C30NODDGjw0se7S1kx5CKD2nOuhnofpWwatK8EIv6w+POSFrEtBEUuYAJXSTvdkeU0TFn0cO2PoVQUj/48bqr7kOmSYVc3otzgq5qTTiSzySFNVHZFqlWUg==
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
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f059025f8f8b..d3edeb80aadb 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -294,6 +294,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
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
index 494257054095..a66346def504 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1494,10 +1494,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
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
@@ -1585,7 +1585,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
+	if (online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, &online_type,
 				   online_memory_block);
 
@@ -1603,7 +1603,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
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
@@ -1631,7 +1637,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
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
@@ -1639,6 +1653,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * Reasons why this memory should not be used for the initial memmap of a
  * kexec kernel or for placing kexec images:
+ *
  * - The booting kernel is in charge of determining how this memory will be
  *   used (e.g., use persistent memory as system RAM)
  * - Coordination with a hypervisor is required before this memory
@@ -1651,9 +1666,12 @@ EXPORT_SYMBOL_GPL(add_memory);
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
@@ -1663,6 +1681,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1671,7 +1692,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1679,6 +1700,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
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
2.54.0


