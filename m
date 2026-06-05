Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09724CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611966B0096; Fri,  5 Jun 2026 17:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B1E6B0098; Fri,  5 Jun 2026 17:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48AEB6B0099; Fri,  5 Jun 2026 17:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC236B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6B491637B5
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:26 +0000 (UTC)
X-FDA: 84847125132.26.7180919
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 140D080010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pX81wjnj;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dc8rrr2XcrLtsxKN6sh//CYz2F36Y4vG25xCNA+gt8=;
	b=zeE0UCJH49Q0dUduCZ+8Xpnjibf4l6DtbvaYA0JPAAHYQvvH241vByp2nnAGYgkJ4pRagr
	FIdymsw8O62n5cyCUiAGuC91MLXfb+MlczWSfTJ3b/tf2jl2KsTZr+XIE0eExHaRhRzoKY
	paqw4G7yXPjnUTpWJ+c5y664My5J6/4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694365;
	b=RiG9L8vqcWvxMT7suzhAXi5u/FlKWT6C8/OYE13Az1TOIEqS6HuGcFrk40QA2svJrNTRoL
	ZSAPShWO8Cn+xsCAVuO5T21qRBLu0o04t9FFQnzbrchL21oN5wDx4Kp6af6bZ+EyqpGtJu
	izs6cydvEzETF/EnwetmoXmmnw9+zq8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pX81wjnj;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8cce87d7995so24709976d6.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694364; x=1781299164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dc8rrr2XcrLtsxKN6sh//CYz2F36Y4vG25xCNA+gt8=;
        b=pX81wjnjaSzyCEHVTQzfKN6By3UuxEb/qMqM4166kLYwanGu8PBndTcj59QwDGV9nD
         yZz5RSr9ZN0AF484VmKfzHhwWt/8yPVqozPZ7/Ga2Vqcu2Wa5De33QOmKN++0X317K3z
         5FgmbQ9MaKxzwtkdFjHkGg4Ew338UEs6p39EVPyjI3WffY3sviB23wX366bK9mvZw+9W
         vQ6WGun9f5mGoYOMi+2YvuxJ7ehc25Gj0JqVr2R08fel3bbLFWJYxunkyP45hGksX6xx
         0dc7JFnSYKqrjVJi/mKZVTrGlv+W0doW/HMzb7/JwFeDPFY5cra95DmQbKqdAn7C23Mn
         rPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694364; x=1781299164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/dc8rrr2XcrLtsxKN6sh//CYz2F36Y4vG25xCNA+gt8=;
        b=qJofgvgBpjW0lfvo2uLAYdhj89DwNy5X7ZJK2XA1GAq1W/M6ItWoM1IUoU7653uNRU
         7OfDhFxEQMwH66rs54NacmHzB/QHhLbExHfdA9l6OkKos55mW9xzX4AvUDaIf14rNj7h
         84mdPPPBhZTaD5hInJwjCuHbuRp4Tqcsk00+aZAv6NreYX99jYPdD4+Uq2hbhEpAlv94
         hlLUHHEE5qiXUmDUHoWisOobpg71BYKEB3GUOwmYkY6ANtO4qSM09zkQjU+1GceIIOY/
         YBar0l0IgAciR3r2b7b1cEzLiMEw5YwAiKG6AH/hLvFMcO45055aVdkLp5NkmCYtofjY
         PH0Q==
X-Gm-Message-State: AOJu0YwpEgPeXEDiaOdblSam3YLqzVj2qyIt9iV+os0OW/mmVlFs5dHg
	oNerOCYut4Eebnm00zZvnXZvDtC+751D9e4MXf2pOsgyd+3YkVGJX5xmMREGv+KHpTq83N9h9c9
	mmByi9myQZA==
X-Gm-Gg: Acq92OHoNPdrwbCtCuEMWLBEPqFscNOg9XNEU4aBvBFcr+4d1UXFHzB76XhpAHUAHX6
	R7BhcYAcY++s8i7x1mH++mP91EnYbNEGA/J5D370MIMxxSAbktz966IkbAqk9/I/iyrFc0dr82Q
	wrUOGyWctIa5uaxOajncC048uo23RlqF5OyGyWSAwVLAnIPkAnNNdClS6c2q8l2fewMQhkg09RF
	zg2THpuklGSOqSc60YywJ6sIAWLzXb9TvN0JJ0c/OGieDugcoreSMbonfm5A5cj6sqUndEY80ai
	r9n8VxU6UcXQZ8iVlR8sS50nDlSlEgCt+GvCxMCJrgwTyDxrgPayEAm1Fk3HOCkrfIx/ddO3j3a
	Q91C/WrWExztlHAZuKf31bWravAPXXSrbANTZ+q6vHLgKPKZXjFNqKOWMTXbcx5ZgOTDSiDmM/Q
	ZtiktJe/NQyTpWlJKU7fyl9FD11KhY9aErqwqq5UxfW947M9g/yTu9XL6Ys7e2lEzuEEGCzdbgQ
	mjcGahfpixKFGWMpTbuCtV3ZO8gMqHIcg==
X-Received: by 2002:a05:6214:5904:b0:8cc:f135:52ab with SMTP id 6a1803df08f44-8cee625b0ffmr97629096d6.39.1780694363997;
        Fri, 05 Jun 2026 14:19:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:23 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 4/9] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Fri,  5 Jun 2026 22:19:06 +0100
Message-ID: <20260605211911.2160954-5-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 140D080010
X-Rspam-User: 
X-Stat-Signature: cjqjakchxc5fqfwohmpnqggeiyx56axq
X-Rspamd-Server: rspam08
X-HE-Tag: 1780694364-602140
X-HE-Meta: U2FsdGVkX1+jtGTLuKJI28Uk/+gj4dnpaX5zdab152Sc55OfHvJP+oCTSRUa5fjLfDDd7viKvIFyHnDz0RJEu3UGPDZ2mUc1TwU0ll04+q2MWpIoS0p+86NlKPLm5Al0T3PaA8g0fRUXoTJ4hWYG5tX9pP+bHQkpbt9MILQesSNl6BGMK/e/C6b9B7KUry1oWSCzwSQpHGCRQt3JgVk8xpWpcpgf/3Sort6PG44A7NPOUx209S8+K+cqMbupli7FiAvEP1hRn74RX+GtJdiBxhzXqhWRmXRQ/pzJ8HQdtxAdBIqcml549W3b6dJFmL6P5Lc/w/dyiLhFXcB4ZQMIAZwXe0IMEsfOvtEsARsTeOZOIll6p1mls6/KSLbKgfjoeeQja+I3f1kKwD04PILSbeiKEkupDCuu7/G7MdTdY0lyR0s254kqBNXpLdMM5xw3cifOZSL2qFz8pohbvx+rBO6GtC7sO9fsj2+/pTD6DmZC3Q6GWrE7pyqY6VBLR26L2OERLKq0JKatDx6TBcFIgaNHJPv8EagGslB2hHuE8LNQETIIpo+KWzmwavqWE0N9zo4okZQT3YXO7VhKp8Y9xuafhJvMoH3kBWfCJcZ7Ip4cj7Q8bUM5hNIMZXsyY/euPQXUNlw8kcNxSySnAhGih9elvj50Tn39lsAzjMibA2uyMgVe34CwAv4BFz19rO4SFO4pD5enfOhWW0mrMI5aI2YOZCKd35c3z2e/HukJR7ston33PkSCTpAIzsVzVFFcoMJ5uBCpzHT248Zj9H88jC2lmFirbmf5saY4irR+TPOqDZKsQhfcoYnxDU5PHlMjrgRVSarwHFoqQXcSolAUU1e5FOj71DAQnRvVufWNUS1K/WtLhSQqcq5dkgzyTvjyKpG5UCbeglkhzGEGXCnHuffk6GeSP72KtQfcnBpKFlVbB0+ZtUB4DjrUTWJxGjUKWhDFvDxxpXVI5uX502a
 qdvyHma9
 88S6Lt/K8Foo26Ukq40lmXY4qQ6+O3kKI9alK8SqOLUNAIk1iOlGUmXmmhNvvd/6yvqdUWI1EQwB+W7ZytoRFGgqEeBXk1XiGviL8LCqaKV4922HN9o6HgeV0Gz7MLsWZk6os9hZsaNhGw1xS0P9riZcRLOhEBEQJPe7f1U8gRuUF9VqPPkFg+7H+4msjKQAhxewDCr6VzWAbKSwbWqxTaTi7ZHYKhy1ZrDjpC2kKx1xwi3MkY8DU8Ta3s8sPKPCO0q3xLynDkc7iKM8NZsPnBbrbURLp8+wHm3j+oAL4CmwKXrzq9FFrZHnCtMQrIECMrThajPQ8dX05fEgvtdCIZ5d8R58mkcUX9iVAOaLsIjUqieUmHY+oI/W4MR5HmiGOkRgD+mn+06BJBGMVHoBmoBHtARYO3Sh3ssVozFE4JNu1n5Va5ZnWypEvtg==
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

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
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
index 494257054095..7d145217adc6 100644
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
+				const char *resource_name, mhp_t mhp_flags,
+				enum mmop online_type)
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
+					   mhp_flags,
+					   mhp_get_default_online_type());
+}
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
 /*
-- 
2.54.0


