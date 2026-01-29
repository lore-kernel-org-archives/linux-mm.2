Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C86BD73E8A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B6E6B008A; Thu, 29 Jan 2026 16:04:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7F66B008C; Thu, 29 Jan 2026 16:04:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C146B0092; Thu, 29 Jan 2026 16:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86F566B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:04:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41E7E160297
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:56 +0000 (UTC)
X-FDA: 84386230992.20.A7ACBA5
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7DF92140007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DnVtFwAl;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Szb3YY2E1e7FJPUVmrsEdEEkJjq+khES1iOhgbFItPA=;
	b=AxlkcX3efnVL3Vh3UuZQhGvYjxU2eD51jq9aXLh46BvXI9OKhnb7uj2xq+ICPEypxkACil
	CUvMQC6MSbAbsmohoNpAu6hBJ6ODFEjOkgMSUsSYbhMDAG/Wq1hqE9xU07e5jJYBLNjB0a
	wMuXCs/1vOMzc04QcmDCbO3MdzZNgsA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DnVtFwAl;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720694; a=rsa-sha256;
	cv=none;
	b=pjgRjy9z0USFEFw0mpu8DP7bHuCSuLMsr/PDMC0hA5DgujJ0ugvSZT+lBlinvWUCsOknRm
	rxs4rdBgrDWQupueGc1ToUXP6y1nRgii6DkrJSHYOHyI7cyKDtNpXM0NksY+bNS9KBd/lz
	EyXvrWRLw7GFZlfP20BTzLE7cn8u6eE=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8c7146b0854so155240485a.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720693; x=1770325493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Szb3YY2E1e7FJPUVmrsEdEEkJjq+khES1iOhgbFItPA=;
        b=DnVtFwAlvJNpKrk2U/kXih70atrbQmWm7N5PtBlxivgfYuqE1PN7C7ir/y5h9wEMQx
         cof9q0s56oOqwH+XwB84QOD0IIg3X19pgr2VNf7TFeRkzNAiFTP/Zc8SkcE9UfxCtqib
         URW0dj394qTITCJQFbTWUCyBtxUVoyizH+YBf2uMM6lg9c7g/Uu3T1LbckWOoHcZB7aR
         iJmJ7PAZjWZVSLhFZX7Tn6Tj+vvXnBIqqp3OFhSasIZQ17YGXMTscl2JnTw8iYwdVK+h
         4Jo1kbiV+a/8KAsvW3u8Q7okCdv9KDuszF+jzcqRMtQtvGW20yBPhs00vrWhkbWtk8vD
         QBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720693; x=1770325493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Szb3YY2E1e7FJPUVmrsEdEEkJjq+khES1iOhgbFItPA=;
        b=YJvss+ST85vDwF8znRY+jzE6SN7eUcY022FpFHowQ4uzHScNH1/UGQ2W7WnRO0K554
         X85HPzmutI/VZ5v6Zy07cOAFOkZ9Eol45z5Myo0RKolJNL5XPqKP+94PyzsqZ4T2iAmb
         nNm3mN6qBsFZJUzWKXvFgX07kQZtfDHR25KAtucM3KoE6XNSHv109yvJ+EkxkHBDDUAY
         4JfMqoAYJ6VyYPHw657kHonqIgqWWDzJRbfHqsyeFImH61AHzIm9y7VOXNVEZsRhBRGn
         ZeW2c4EeY7sr/pkbat2ACExbp4oYrdH0yFgtq2RWy5olc3X8HYEOv3xFS+CHvikQEDG4
         7XkQ==
X-Gm-Message-State: AOJu0Ywaqbib2IKOzRnJp84SL3liAHvZRIg29AkKnBae4FMkq/AYMEAt
	rM9p9BWIcbC6gtECsbMRcPDnoN9hpmrtFFBJoSNeuNkb7xpyFxcmtgUphxKcuall4yLWXyEqw7a
	gpfb1xMw=
X-Gm-Gg: AZuq6aIMQba1++ujOTZ6YnDMACgZemBSBq3gdEfzxFInmJJqsHhidOR9fZoQVGpsypJ
	4+00QmCA+G9ZkQAypUqvltnAVd3PIZEqi8ew1CxO5GVOY+oou1OpLyTXL8Yl8aQbSc2BlOMWhz8
	EEWuRXVt/zsR3c8wOsXql+J9nXGBcGTWxHpc1gdEuSHmw1H0x5XoRBDUYW4fCy9gJieRb12FtpD
	uEJCGG9IgLnAiyPhAJKugwziFVQpJ20BSl1/4ST6lvwpmKpY/jAV8KP4/Ngrkigg6es8Jb7Xk7i
	9g5y66Ay0CXZ355jGNHAXpOI5YODWrb4qMGxCwUlqC9zCPSUnF9ZkRePW1dfE7Q/9DwUL87Zbdr
	W6+QjcKplFwy8zj10O/zfA2T7HWv8HvJk2qVV6rdPnGjOdE5VuFrhzhhkSunlfk3LWsfcG4/6sD
	sS43IlooCJIvTnSi0TNNjCVF8a5Cr0Q+ROMC06uvQua7LehsvGMpgNxZzSGXM9CS9dIJQxu53ae
	7EZWnfXF0YqNg==
X-Received: by 2002:a05:620a:690d:b0:8c9:ea1c:f21c with SMTP id af79cd13be357-8c9eb2fd583mr157489485a.63.1769720693221;
        Thu, 29 Jan 2026 13:04:53 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:52 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Thu, 29 Jan 2026 16:04:35 -0500
Message-ID: <20260129210442.3951412-3-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DF92140007
X-Rspamd-Server: rspam07
X-Stat-Signature: ewcnqmkno3yx4zdwdemddpe8m55zpj33
X-HE-Tag: 1769720694-241487
X-HE-Meta: U2FsdGVkX1+sclJX/GIElb2as8NjkPddxN59KiVOpixqzx92nGh5X2DpZD05mLhWMvIvAdbxE2TbLOJZpbqG1ATF/y/tyIvCrwB3EfkkNrxmP1xK+8MHpN903DGvaMM0/O+kryNdAUnaCeS5maXh1TCdL/t8poeUxnGiTi5OWo+gJhEpFZby3tuYIP0aBoQO+QUKFLHlEVBPSJuX757n2Ft5bUYJkKWOtomQ10tWM06PWBN0ECKxSOI8ms6iQWb+Jb2Of7k0ESoN36huuf5uYD79EjpoPckeqvz9MNpH/e7I41A5NthQ8PJ3yERFdGgvU88Im1Z2iNPWK8csn3Ry1BIOUvJn8PrkEkP+gK4zTblrgxLOpOmOyUNvTjJLQr0W+pYxluHra+L3xCR0X072U/Ia8qKFclQkpJXW9NHDzzweh1P364OIFLJiEvb/L4ymxuUtyLnwQQ/KCnIRvd2D6+ZFpDy9rRwWqHIWNw5xWHZVaW2Uf36X50fAjgX2lDKC8blHXUcuKtJOcTSN/1XMD+NeKg2J4BCNobUp3hE3oEYRG4VY/nvzXYcmzuCdGzXbNV3FgU2eBSup7KeIZk3mJb8/TW9O2tqcNtOW3U8oibsy34cZSrxBZ0nZ3vWCkF+A3Bu4o82XHZj7fFNoNugaHOC1WNeIxUgvY5iBMqbMKuAvMfamE+0wG9BUA74/JrsNMUj+mbnadRRtjmnLmkAiZwTGRkgO2e4dheUUaAMiUiW7QBoLbwaCjqWx49pieIz2YYAqv0v+wwK+DL1zl8wl4c52lN44wjt/mNkEtYEtFC8NjlUAtX41XQ/XKZB28N2fXiyls818DPkCfHURPzfOKfh1IckUIVHI2TsfJ0luLtjKzUsvrMrxliXOZN8ncHfEWokp5c5rtra/Tikq3iTf0Q2a8n4q9EZO/COX51OMHan+UpYt34dR6JFe38RNAu0ZqxEIi1w/4/OPaxoDCIR
 c6Qy7j/D
 SypRP5BQOpf8jXb4Fv88dayN4oa0SOoxNQCUzHe1jThQZd8FcHzzJMPAUH/Qyi6deoroYgdu65832Kej10j2o1xTUo8P8t91Td4xhUxmUakGatdRw+wUn4PHMoMtinysSGVw8NHT9zqGnDjB2PIFXubF3s3PDL14L9RdSWXytM62Ouazsu2vFFrdgWY6i+ZW17qqPnKbvnnXc0s6PvPwmFA4aymspv+nOyJvDUxTw7zWwn5NjElApPQ1ySbysvczgO25jH/q4aETrEtNedYomoot+yHShoetfe5Z0yljwDxiye2vUwAhOdByeWnsVLWQ1eMZl64nmBzSFrXiwjuQwhwVm51cjMLCIrn0mFtNWDhURdOXaRFKVZRNjU0V+zyi/0oPnf/6B9eQdkDSQ1OZRfK9cLstTKm/XDHQjy4vLi5MbEcE41z6byZKFEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable dax kmem driver to select how to online the memory rather than
implicitly depending on the system default.  This will allow users of
dax to plumb through a preferred auto-online policy for their region.

Refactor and new interface:
Add __add_memory_driver_managed() which accepts an explicit online_type
and export mhp_get_default_online_type() so callers can pass it when
they want the default behavior.

Refactor:
Extract __add_memory_resource() to take an explicit online_type parameter,
and update add_memory_resource() to pass the system default.

No functional change for existing users.

Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 91 ++++++++++++++++++++++++----------
 2 files changed, 67 insertions(+), 27 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f2f16cdd73ee..1eb63d1a247d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -293,6 +293,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				const char *resource_name, mhp_t mhp_flags,
+				int online_type);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
 				     mhp_t mhp_flags);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 87796b617d9e..d3ca95b872bd 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ int mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(int online_type)
 {
@@ -1490,7 +1491,8 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
  *
  * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
  */
-int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
+				 int online_type)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
@@ -1580,12 +1582,9 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
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
@@ -1601,7 +1600,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
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
@@ -1629,29 +1634,24 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 }
 EXPORT_SYMBOL_GPL(add_memory);
 
-/*
- * Add special, driver-managed memory to the system as system RAM. Such
- * memory is not exposed via the raw firmware-provided memmap as system
- * RAM, instead, it is detected and added by a driver - during cold boot,
- * after a reboot, and after kexec.
- *
- * Reasons why this memory should not be used for the initial memmap of a
- * kexec kernel or for placing kexec images:
- * - The booting kernel is in charge of determining how this memory will be
- *   used (e.g., use persistent memory as system RAM)
- * - Coordination with a hypervisor is required before this memory
- *   can be used (e.g., inaccessible parts).
+/**
+ * __add_memory_driver_managed - add driver-managed memory with explicit online_type
+ * @nid: NUMA node ID where the memory will be added
+ * @start: Start physical address of the memory range
+ * @size: Size of the memory range in bytes
+ * @resource_name: Resource name in format "System RAM ($DRIVER)"
+ * @mhp_flags: Memory hotplug flags
+ * @online_type: Online behavior (MMOP_ONLINE, MMOP_ONLINE_KERNEL,
+ *               MMOP_ONLINE_MOVABLE, or MMOP_OFFLINE)
  *
- * For this memory, no entries in /sys/firmware/memmap ("raw firmware-provided
- * memory map") are created. Also, the created memory resource is flagged
- * with IORESOURCE_SYSRAM_DRIVER_MANAGED, so in-kernel users can special-case
- * this memory as well (esp., not place kexec images onto it).
+ * Add driver-managed memory with explicit online_type specification.
+ * The resource_name must have the format "System RAM ($DRIVER)".
  *
- * The resource_name (visible via /proc/iomem) has to have the format
- * "System RAM ($DRIVER)".
+ * Return: 0 on success, negative error code on failure.
  */
-int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name, mhp_t mhp_flags)
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				const char *resource_name, mhp_t mhp_flags,
+				int online_type)
 {
 	struct resource *res;
 	int rc;
@@ -1661,6 +1661,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1669,7 +1672,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1677,6 +1680,40 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	unlock_device_hotplug();
 	return rc;
 }
+EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem");
+
+/*
+ * Add special, driver-managed memory to the system as system RAM. Such
+ * memory is not exposed via the raw firmware-provided memmap as system
+ * RAM, instead, it is detected and added by a driver - during cold boot,
+ * after a reboot, and after kexec.
+ *
+ * Reasons why this memory should not be used for the initial memmap of a
+ * kexec kernel or for placing kexec images:
+ * - The booting kernel is in charge of determining how this memory will be
+ *   used (e.g., use persistent memory as system RAM)
+ * - Coordination with a hypervisor is required before this memory
+ *   can be used (e.g., inaccessible parts).
+ *
+ * For this memory, no entries in /sys/firmware/memmap ("raw firmware-provided
+ * memory map") are created. Also, the created memory resource is flagged
+ * with IORESOURCE_SYSRAM_DRIVER_MANAGED, so in-kernel users can special-case
+ * this memory as well (esp., not place kexec images onto it).
+ *
+ * The resource_name (visible via /proc/iomem) has to have the format
+ * "System RAM ($DRIVER)".
+ *
+ * Memory will be onlined using the system default online type.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int add_memory_driver_managed(int nid, u64 start, u64 size,
+			      const char *resource_name, mhp_t mhp_flags)
+{
+	return __add_memory_driver_managed(nid, start, size, resource_name,
+					   mhp_flags,
+					   mhp_get_default_online_type());
+}
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
 /*
-- 
2.52.0


