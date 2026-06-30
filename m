Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65E3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015E46B00AD; Tue, 30 Jun 2026 17:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08846B00AE; Tue, 30 Jun 2026 17:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8EB6B00AF; Tue, 30 Jun 2026 17:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DBCE6B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:19:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 140041C4F22
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:00 +0000 (UTC)
X-FDA: 84937844040.24.A42E47B
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4DC7B160003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Zd2NaIg1;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854338;
	b=eriBRSOXhs6UYT70VFqy9J7sgFLpR5XIFYHXmhus3Iuk3KbaDl62p6RV+A3uWMeclaPuxf
	Hr7WxiE9b+q8tTXs5zFQGF7dKoXJl11ZXbCttnSTCj1M+OwIreHDmBNu06YuQgCADkm9on
	1dNK9Vt5B0BLRf2Re5XbIiq+hZoGO+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAW3T42N8LQZC9syVg1ZuijfUaTs4bm/TuOp9AH8qpo=;
	b=Rd6QifHhTz5+8PQSaI/EgVOID6Np5e5mms87U+9m4H4nMfjMnTj4BUPBYVys5b+42L5ld+
	lKyO8HS5VNyfXk8rh93INr+jmJMRcwnh9hH6GkNStucsQuqS00fhzQGFM3ARKAsPpg5Aa2
	NaKFdtzW1eevuqWTZnbM5rQmXTiXCvI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Zd2NaIg1;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e54f8c051so184113485a.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854337; x=1783459137; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAW3T42N8LQZC9syVg1ZuijfUaTs4bm/TuOp9AH8qpo=;
        b=Zd2NaIg1a0GJ/1ea3JJ2MWX4yfWakf7VheYXoEAEsQfBEP/kzIXO2+U6RrIG68KYyC
         V8rd06RBliKERQ5olQ+Zp27PWQ2iOKt+AZ19XHRm0lQa6xwlB2332dYBSkAH9jNmEVTg
         /FQgSoJVhEUAPSzAmtk69R/xNdlqUEIwQp1K6nLmpSMM5pfcs7bOI/kCTFnn1MNSnPpf
         lRyYeGX+nOvSCwG9peIOYd/Pzq/QzRSjoXfRE5HvVU0vUS/TXZPKEMYA/lO1fU251AYh
         5LXEC4fwRi/32zpS1uLxpTzSbaCcPMRqIBRIRxEXIqU5B2gwqRrFLht2LE70uSK3WMR1
         4I9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854337; x=1783459137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JAW3T42N8LQZC9syVg1ZuijfUaTs4bm/TuOp9AH8qpo=;
        b=eZInC3Ga1MJLGtlQdS7FhIcVD+IKXGgdfdt503t1Bkh15tIEpi1rNFWsvaFSfYbTO1
         8nU2KetCyBrJ7sHisA2ns/Jiy0hBhFHE/9JrMGWOqs/P5eDgd/080hpMBoojB1Rrw1Wk
         2b1dyuRLHEyi9D3i/2wgV6E9PfKnzPIK4ZOIddrJuF9MSZ9ibG51ilToe8Wxjdanso/m
         Tvyewz6lqhkdFFVfnA2BGQWnbK+JhrTiOotrchDHc0hpKJreNb5unGqXr70NniyPMDBl
         QLrbGh7R7zUR8FI5jAQffmcDsBoInvTKSywAwR6S7cZ9p3tvqj3ptBtvTWL9QaQ9GPoG
         Fglw==
X-Gm-Message-State: AOJu0YzUdpCQ9Ub+Zy+52RPRV+JtM9B6LD0YVQ+BVVe1CXKx7QKAeaVk
	UXZIkp9OXHiiwGzyJ3pDpCMnGBZN4RkTYvM70S8JC6nPzaUJGWzycyJEuFujHeQkBPt/RCXZHBW
	oH0gW
X-Gm-Gg: AfdE7cnaHDNNgZfG3BP3hsvOS0Yrd9DKV2xBGmbmfUqaVmW4Ni8PQCFyTNwVEC+mB7J
	eIYVwUcZzfgXP49XpkLfzfXPiMymK8br6CnHXqehOKjWLFOWKD/p7w0qkH5QCgylA+Vg9M/weMl
	m0Ghqa397A51JOUFP0C5ljSsyzano/HKLqcTjs/gfPnxvHC3IxG1tnA9cva5YQArl8NuWevpJEH
	ul7j7TsHFW7aGnksa6GGY92fcrbJxCDi9lao3oUbsyf0r3Riv551HivBtKhPdWwcKpu5PN+ay8W
	iwZjDfsO8+olXarqc0j1EVxcl1Ls7OKkbNYlaSM3xdr8K8ytkS+aNbuY6y24VwUXnwfB9upILEa
	q/A3Qf3efBow8U++OXVR5onymSZ2KNGu0vSLR8wmB38p0TBN/JVUVQ4ZYhNmyYpdbo9U4emv2Vb
	LH3lR0OkP8oSzXg0pFzh/zqof+EVgqBES2rEKT4StjNt1/F6pPJFkq4tiN5sb+hEwcU++Fkwj3o
	xce3WP//nSv
X-Received: by 2002:a05:620a:394b:b0:92a:bbf6:717e with SMTP id af79cd13be357-92e6279c3c2mr869717085a.34.1782854337312;
        Tue, 30 Jun 2026 14:18:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:56 -0700 (PDT)
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
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v6 05/10] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Tue, 30 Jun 2026 17:18:37 -0400
Message-ID: <20260630211842.2252800-6-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4DC7B160003
X-Stat-Signature: ykp716wjdrq1saz7tss6d6iuhxt1tq7f
X-HE-Tag: 1782854338-403403
X-HE-Meta: U2FsdGVkX1+gq7w/6uqLImNF2/93pd4sXsJR9pib/PBZOD+HoQUB4oCqipkAo6b5Vim1U979zeiD/dqkF+luuhKOInwc0bHQkzFl0UNieNQFmxVkcPjJP4Bxb11X9S1LER5N4qJrTcpgoYsYMTw/8rJtNbGWAlFFblFWV1nHnlSeLfBuo5XEDGxXeYdEDlAXs1QZVpB01frw3Dg8YijYgnBeYU/dpxs1dTn65Z0OCfk9q+u6aIKDmd66YVQkERp4QLT23MF13MhlO/fA/SYnQqrsCj0XtCdmd/LA6bYXf17BkFz9XLD4YkgzJ89BtREkgQG36vhDA1dYsNPkr88YyIdcxJVzY336U7Ba6zkakl239YawIUjDRD7hdo0tkKGWL3kJ9Vdf6v9VHJLK+3oxh9hNzrDZfiPgFR+nDKp39/mDABlS4A3o9RVCJE639Eq8F22j/1YhNtoDUOPrMv7qh6Ek6YCF8DI82+O7cbhVxO7pJNhWB7qacHzFA/CK6HnPSNs1jMgr5DEmbyaLtz+WqFLlLimy5mHTdGH4MgaeRxysnbiYtwMylvFM0aLuBxUANWnMvoBJTIVXYgz3Uqffb70UiWMw0Irum5Csu4HdIEzlzw+Typ7Jis+9k3Px3HiKF9xk3nC3RVJJxEC3cNVGCNPWp+A+wU2/oCRccPlrXdtXcTs/lATGe+8cqzWt8B60xpmIcwcz4MKgGZm9KR5H8WlQGChejKjwRrzbjdRbOOrNuxFPO+KTE8qwN11do+jpEW4pGTzeMBXdcQgZcv8SAYOlBhhBUncHxhOJGwYNx9zMUizVud17aOA0nzBls1vqBUZa4GKkESCO2/CuwOFABqrP3p1NAh3R6WfU7h1l9anpqa/EhNmkfEhkxBoFQVsraI49qF2rMsxqqgkl5JLtx6efbvzVyFSC97e27zdRP6j6vGw//w3qXjvCObL7CefcNgsw2CblW+85x7GwknY
 Mgnt1kdH
 C35Kazyn5xAlu2+O5QeNj3ALuw3Ww/lIUqKlrHvFRLQjAkjwpwBBekaiD11UXNsIpoLASTgPu7rEPp1bj7TRVMVs+FEF0dJDFSncwSjpWqyCDHZsjuCLFGbDTm1bKd9ixVdUXD+7zGavtIL/C5H9qPJSFEqAM5+Eu3gkLMAISu8ztgadrbEL0RMz1ay+H3+7b8gXZlLHdiNY65mgEq3uoi6T3FM+85kXrpCbHjgPD4dDYXeU2W5+OHrAz3ATD5XzSzspvUK8DOtpm9p1cQcS1/pAfe3lV4wPK1R3bggWN8I8jZ2EuTtNMXhg54CqUtxSqAeNPE2dNP55Yl+AXHi0cq2xMhmcRPhxGJBt566qqL6vCWgLmVQj59C+H1h97MTPngxiO3T1s5xgQcdA=
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
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 4d51fcb93a37..ff3b865ea7e7 100644
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
2.53.0-Meta


