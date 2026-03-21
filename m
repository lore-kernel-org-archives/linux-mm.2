Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD3B1094480
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDA16B00CC; Sat, 21 Mar 2026 11:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966626B00CE; Sat, 21 Mar 2026 11:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743F56B00CF; Sat, 21 Mar 2026 11:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5459E6B00CC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE31213B313
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:20 +0000 (UTC)
X-FDA: 84570391080.06.36754F2
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id F1B0A1C0017
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=C8DUAEup;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vvnYDBDYSd91JS5VlgcZ1pjC7MUK2Lw1jakydB3PHI=;
	b=UZSp45WJF9TGWRp8foppm3vuQWuos3XypUS9uW07lz/a8MAnXkoGzyGuDgTCAxHZhTdibI
	WaKRbb3JeWHCcsS/0T5dQebI/oPUCLfFOI+iunz2mh8w+sFiTWrSpnMzYLNRWgQx2CqMRK
	Pn9mX3lzUgZ4UHf4tP/NiNdHzFm7JDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105459; a=rsa-sha256;
	cv=none;
	b=geSrhYIrtXqUcRSOWLkn3vT0uQLbbLy4WOcemHjpkIUtTu4sxHLYLCz6r3JmV9nnyEQmpJ
	kU/GNEhuIBIwYbHjqTDJgbo1Uxsu4r10Bp4RGrQeLnrJVL3Rnmgaim2Gyvw+HUCoC1Xr9q
	lmqcI0rLbTJCpuMcgVwuDPmReUSp4Jg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=C8DUAEup;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cfc3ca1922so226255285a.1
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105458; x=1774710258; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9vvnYDBDYSd91JS5VlgcZ1pjC7MUK2Lw1jakydB3PHI=;
        b=C8DUAEup85ZLCEQGuX4PgUI6/Es/p4vepXBkO0f6k6iNY75oCOynvM+eEQOaIO8+ek
         A6t6hLtCt+RkybBCVR8y927xz1ggtKvQAxh3Seeqp1w99oAPTWPbNsSPJMakR/U00Byd
         3cnMUFley5yxNSjs+GApsLHGjzADVNUPSf5kb6DTbGHEyooeXrE+sxa/Dh6GHIltASxf
         ScwKBy9Ed78DE9xwsZMpslN2hIelGzNgkLz0GP0bO/7XUYrdoCCE2mDsGgtNqPKq7Dti
         llohpdBuC5V1bPWtFfP2dbZUWSkVOXrSjX4nOflprcGlKNbDPODelv/hCjSgxdJOGieB
         TR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105458; x=1774710258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9vvnYDBDYSd91JS5VlgcZ1pjC7MUK2Lw1jakydB3PHI=;
        b=HPlB7kmzWlQz53LzckKdtjM3n6HaU4ZriAhx6GFJtUvlruz2/8Yvx8RvGjVx8rc37A
         mMzcjnfPxNksdh7lcBlKbfP6WqMo3hyy6O9GbumoNHCyBFbi0Kv6zBcdU10CUnMgz5zg
         X0D9i4dD/gWp+UgrlNyi0baytSlcfGG1x2fETg3TUbQGFwWlqLueMWF44P+rekXAZwcE
         PJhBs+ClcsDpT7QN6qwqsqkr/5pr5x9Kuz95fvCiV13K//22StfRVlpeq09HZoe8wDLq
         n9we80f9faEE+IJ0oCdjapYNZS2qHs0IJAtJy/bMg0R/5gpHc1V/1bW6QipAJ9KBy0Vq
         fnTg==
X-Gm-Message-State: AOJu0YxlJv1/PEPX8sTUcKGz8U8O9KxxotsTAYmeHz2fbz5625PhFakZ
	AVeDBpvBLD6DPm6FpjjrYyIMGVAqphhA8hAJRpGgtjANJPjh9M53ACLIRgJ5FQkJZ+lgwA/GuNL
	cQ6YK
X-Gm-Gg: ATEYQzzDUHj59BKdzQgb4OOAp/d896uLV5aUxhK4EFFfh7tsk4Dbai3LngNOp9rjw0e
	ox6ti+z00CqKNUVKQzkLda9ZX+Ko0CIc2UBLXQJgU1+tX1PqPrRqRT0GDoPcoqRZSQb4jTUZGgm
	Ao76c+RZ1Kg6cnNI2IxQVfWMOdHzBr+U0hCSSHXzic19o+Njo4JxYusBM0sd7YB7EHGkx3v7kCs
	/JZtpd8FivYQqUaPD+C6X5DAZ0QWxQE4hMscTRrUUAI1tMa9/G7Yp38pvGH0HkVz2SeG5QVAdp+
	EqoMQq58o0STnfIDxgd9XyyS0FNm5oaK6Hvl/YDIPNZ7ip0C7f0eAj0dA4u+DXzgGSylReLBVGl
	DJgC5KYb0gNJ6VwQhpFOfj+w4iDvN7AcWjESbGq+sKRgrk434R1zFKQ4aE0xJPWPiovvyg6zxK6
	nMnIz68/IUTGf2X39+XjgjYX8JhuoUnpfRc87YmzWIgTtzOLorNkl3PDi1xm77QrKxzvtjK4hjO
	syNhgJltNn6eetfgbib3DM5AA==
X-Received: by 2002:a05:620a:410c:b0:8a6:92d1:2dae with SMTP id af79cd13be357-8cfc795a1famr877339485a.5.1774105457588;
        Sat, 21 Mar 2026 08:04:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:17 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 5/8] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Sat, 21 Mar 2026 11:04:01 -0400
Message-ID: <20260321150404.3288786-6-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1B0A1C0017
X-Stat-Signature: 8634cbb4x7ztzf1n3i69qab6e33nuxke
X-HE-Tag: 1774105458-658866
X-HE-Meta: U2FsdGVkX18AJcXAUpZPwBcFrPPXN8STv67DRa0DltwRd74cO/OKN0YXqqb8MdBh3BHeJ0oYDEc4nYQRpIdmKdKdhKCP5Uv0ixvisA3jTtN83k0b3/WBy9Vp/DcfLpD2kMHyjAMN6PxxiFleMITfaa753i31nbsh8eNxoAMoiS9pRfkxIvaw6xYZo6C288d9UJbpscfgW8PV7cX7I/8LsdJ6ez7z2BU1ad6+Nq9t7cnHj/R2Ao7XcxrkRkXRepT7FU6PvaGMwA6sTQ5UT9xsu8hFeIGV66GXQ0VBzTRadIjlJ8aK1BJ4fR091F5MvBABuBix8dbaWygChgZdv45jHmsfPIo8oAEprqI/YEGFrDyEn1+4l0xEHgjr2ZOJYbXWQ1C/QvZDPlzIWVZIfm4SvJKspOZkw9rRIfIzOFWCmCyuVE0kl1BJXRUBjDJ9MqircN+SMQyyJHq5EkDNMlNIPpmJ52WL/+q7ZnCRVjrWJGmPbDJV4Vaqz4uiGFHTYhC+RajbWh76Eljtt7l0TIQpMT5cPCGp+lh18ndI3U6ovtQLRAudxAL2GzYP3qOEbuIOlWrWHGHh5rK+0R3EVl3zCc5rnHISCmbpmRplYFqOB0WYAtUEyAnHgyd+Q5ynfvYjjEN5ws8UzizDUqIILCXSg74ppZvRJ1C8ehR8HtcIfp5XYpYglt5lU7sIiDYWq7n1AIA/Y5/kqg0BJfRNcAiCZoFVv8oXAz/h2VVmhWqCS4b/JRsa3n9BTbe4A/xAjPIKhFYcVkeJfbvgpipxYEKIwMZwouWNquYQXcMfYUPCD6FoGd/kT17Jk17unUbq57hXeafXl6LeyiuappiMqFV2noNjJsGMTDKz+P2PZNN/IT2metkYb5ZHpda6bML5Jf+PzI4WbU12dRsSfkOCo2HMmF35sLiCaOTDiZQyyzkZ66FqXogkAPBb8r33PxudKeE8BReLiq2uFjRfRNNwhRM
 uXN+nVUn
 0LkqENrKHLJzOmijSwsc7az2oMnuzCeDUygyV5Cq14PihYsPZb6d73w+NVJIsLAWQsIAW3vCnnzIbJaE56WmKhNTTxohvWBGVRC13VdoeqiieR1ApYe32DKpeBdDlBbJc3svGmyHTvUgNxdptTWP1sQFPGJLXWzA0y7KHzavMPE3nsA+swTe7KOEu9hEbNTyq1oH2K41lpyXzaI6a833+Amu/uK2NLnU5kRmq20+AQlelVNt6nTxSvOST0Hfbs+qHrzEhtV7aUP7w/iAxUve0G2Ha2v5FDYr0JhDUYjVmxJkALxC2J4tnusadwZTgJFZdZFd2ee8YOiXPksp51kRwt9AexPX+c0Mz/1GetXPjmIEIO0h9IaposXtUf7Uz4iTlBueQBoVvL89Fatnjsza6NgTrfMOCKa1i1iJTviPcUv3AHdiRqwDeunSDaA==
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

Refactor APIs to add a new interface which allows the dax kmem and
cxl_core modules to select a preferred policy.  Only expose this
interface to those modules to avoid confusion among existing API users
and to limit usage in out-of-tree modules.

Refactor add_memory_driver_managed, extract __add_memory_driver_managed
- Add proper kernel-doc for add_memory_driver_managed while refactoring
- New helper accepts an explicit online_type.
- New help validates online_type is between OFFLINE and ONLINE_MOVABLE

Refactor: add_memory_resource, extract __add_memory_resource
- new helper accepts an explicit online_type

Original APIs now explicitly pass the system-default to new helpers.

No functional change for existing users.

Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 60 +++++++++++++++++++++++++++++-----
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index a8bcb36f93b8..1f19f08552ea 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -320,6 +320,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
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
index af9a6cb5a2f9..9081aad5078f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1492,10 +1492,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
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
@@ -1583,7 +1583,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
+	if (online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, &online_type,
 				   online_memory_block);
 
@@ -1601,7 +1601,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
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
@@ -1629,7 +1635,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
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
@@ -1649,9 +1663,12 @@ EXPORT_SYMBOL_GPL(add_memory);
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
@@ -1661,6 +1678,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1669,7 +1689,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1677,6 +1697,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	unlock_device_hotplug();
 	return rc;
 }
+EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem,cxl_core");
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
2.53.0


