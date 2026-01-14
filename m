Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20EB7D31A26
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FADB6B008C; Wed, 14 Jan 2026 03:52:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2997C6B0092; Wed, 14 Jan 2026 03:52:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CDF6B0093; Wed, 14 Jan 2026 03:52:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E887F6B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C4741ADD94
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:42 +0000 (UTC)
X-FDA: 84329953764.04.49525E4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE5291C0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ROL/rOoL";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380760; a=rsa-sha256;
	cv=none;
	b=2zIp9wtf03Y5SbFFXzpYmz7HiaPrQzY5oUPT3cQm+F8IhD3prVoTBALepG5yd6zuKGpuQR
	aoh6RI8o+C94rDUgv93FXML69QgmOu5uiunFk0lXTHVWTv1tfCkK67YLqIrb7MMiuXQuSQ
	qY7J/voT4ctgW6+2GBBb0ZUngyEptZg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ROL/rOoL";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3pYyw670e7Ltu41laZTVJfsj8n3YRVUYoWc2KV2zc8=;
	b=yCAv/uql4Wv1oqc1e97eSM1AHAhE4Awr2btLmlKtgyRSJ26RjorZ0trfoi9tjeoP2Wc0U/
	iOlOabVx3NvEQzQ7Gk/eKO2ZV/gS1qhJYr9I7SRU/PMAr2u09zjzpz9UmYscHUvOQZHg2W
	G2cQeW7pLkTSHop26j+CPzkq5O4nKUQ=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5014e8a42aeso1235401cf.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380760; x=1768985560; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3pYyw670e7Ltu41laZTVJfsj8n3YRVUYoWc2KV2zc8=;
        b=ROL/rOoLE7Hd4mICMD61Rut4iBBxem3pyax2IHTNDn1dRUzFp3eMsHO1W4IQXEN57D
         a4/ukIjGqU0oRUWVBxvencN4mZO3/ul8I4x6lXF+uNLB5F63DHjwkGTzEJJszPtHV5jJ
         BKrEBSdHClGVPhqBbu4KiYZvYFj6na+HofbFbF333Xyj+FeP/Izqesqszb/Egaa/L4t4
         tjzVhZsJKy8rhGBnPrBjwzBHTiywDu5qeLZUwNS9h0VCXmzNbLPNx3Sa4b6+2qPQ12ym
         dO+p1Ry0c3ZQ5hXxjNo3GPh5+p7HyXRnZr9NUwdpP/s75wixRsgPOZXSbOMUfcY4A8cS
         5RNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380760; x=1768985560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v3pYyw670e7Ltu41laZTVJfsj8n3YRVUYoWc2KV2zc8=;
        b=gIBE93+f9OVq4/F4jbz4a13fPV/TzzcdooHlqoC8CAVUtFaUuGNTK1yiEMTAl38I7i
         VoNYSyZaYOcfm/JMe+ixszElLMjUC/PuU8+creRqGcvEZC2wS3+zkKgH60KrhsC2vDUi
         OzCi/9i9leb+gGYf8GhJr/898AdfN/7UR2J8rY3XjtMTm9HQ6ZueuWqayr8u/zKZbZpU
         MyqBamqKPOdYFtsl0/aD2GrLbG/yaN28u4l2MGUi77SpKfn45X8+nJ2ZnDbVoChgVbDj
         ouY2+j85wb3Y+rhUgJkeXEUheOwcUqO7Ov04B1Pmkq0mt5pftc3kMOzkyuRUAs1ZbF5x
         Nckw==
X-Gm-Message-State: AOJu0YxjgYBSZ6b39euWg0ilB2XGf5STcWwi2flJcJ8xsgg+u/8tNPeU
	OMjcK1erg6z8PsssFatM7TD/tritMB/3EQNKmEyKxmT+zHeqq+rbMucuAL8bvzDd5bBM7kl/3hX
	qkJoWN9E=
X-Gm-Gg: AY/fxX7REA/e6ufcB8XGytTwHE8Tm+TyXkagqKCHuV0BDHGKOkXDPUtvLfm9XbdsWoZ
	kG//n+iPY37y4khaSow5yUH8SM8USTNIt9qBnHUKM0JlZoMfYt3leNgG3BmCKXVkozE5a39GWU2
	/ufgBuZFHZ18qJZD1U/FbWeub7TPHlSUagHrULUYEplJnpKwGCIMq2foYjeaTFOPZx/N1pPlQ32
	PsixdYkMuoVrzUO22mM8Wgzm4ixpqbJ4Sg7oPFG+C+eiwbfCN9R9EEgITnkbXIuTC8KE8+c8DEP
	u7BgmWp6hDANaEj8Kv4A4udw1DIu0orouuLAwTYE0xvJ+ANpJRukGm9D+5Ex+1U3S4+dxgB2LBc
	sUe9CLldv6jknV0u/2dW3vLnvCKZQxhpa/t6cKDXlN59rNJ3zayX50nYK2lJFlM3sMYNxaxfof9
	gvVEKZPnAVFgGZwUldZE5WIuk6vtU80W5BZsk8l+V+Z4449lrovmPiV6Vq+bKcY6wXpda9vmKC1
	Xs=
X-Received: by 2002:a05:622a:341:b0:4ed:b5d8:a192 with SMTP id d75a77b69052e-501484689b1mr23203311cf.38.1768380759657;
        Wed, 14 Jan 2026 00:52:39 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:39 -0800 (PST)
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
	akpm@linux-foundation.org
Subject: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type control
Date: Wed, 14 Jan 2026 03:51:55 -0500
Message-ID: <20260114085201.3222597-4-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CE5291C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: 17qinmt5i13nr17j5oebsfpw5scnzo6k
X-Rspam-User: 
X-HE-Tag: 1768380760-610179
X-HE-Meta: U2FsdGVkX1/JP7ex8/wEajcItindLkVhUtb6kEHBOx2s/LL6p45p3CfzA94KD4u+lvsH3JoJHjzFxKwxJ/ecVZdnNIOswB8EfzgDpLjEFCHuWMtT5JXLUMKnq3K1PBAf4tjNE+M7WoWYMiPcuUyoPhDe9VNa82IXXSZNF8U8d1sFxXCqXqnb1YNtBPEaO6x7BFsrPmS261GGU4Hew1+TUoMOrZkr78mrAB7uvzkACoCTuBml/lhJlYu1+h4DJQv7du93tEK2dV3dhEaJkwTugQc0kIBUAerLqGrpMGNPOiT8ec8bV/WD+Yv0C4NvzIWdFj0bWde9EI+QYAp5b+ckKc3777qNvIVZMtsw0AFyw8hOen3i5NLdBq3nVbJVgAS5IbDZQOIfAEshO3LZpoxTY9grvUUNHPyd72auFhIPSK0q38YEvg//EUUxVoZiMIWqiEYf4Gira0PRJzjse33IKMdnpaX8B8vvbXhHP6pCa7iBL/6vQ7Bt2P46U8d0Px4SfY7ii0guNQwJCT3IrvFPXAN6qZt17AZqeMYs962sHvvaRbBj6JXV7Ik2Nf4NulucNZkc9Gu394CVgdiB8xaBYFQJ9rXbVYbnvpyMylRJAK9vPw8IqRpIHpczz9nS0FGfACLAQxn1MVO2Md34PL1IfuQYudu4v5f7vVBCIYnYJt04ULYGW+6zcN8hQOvRpsAW6RPdWpPjbNyoLxuVEy7sSaenkeWqmQNTqvMpjFNEAt+qd1II6lx8I9nt3Im5/2j9CX0W49I56EVYD43FHhrsgfB/4+442JkPl5lcmfvLG15dxdsSseEEoEnuWl5w7GvEVZKb42AeeXw3EMgIA/NcHFzR+YEj37Lg20kaM5VfhoQc7FaGqCFrLBIoyPaO8Mi054TttXp31M4uyq79k9HwCx2ydEEkG+dUdbDh0QiDlFnwiNurDZequzQ4ovx8gSfgovi7C2dtajK273FkKRc
 9O1JrJw5
 /fcCjI9visuK2zGhzsdKg51fhmsXKeqGhxoWiwcnxQWpCmkjJnpoyQDRnJsXsVYbLbUgGc6lqbOD01KuPt2mhb+o3u4ERXDtnDv3isoVkgD9yizCVko165PanC0EFEjXLWMGg/Ug1KBFsPuBC04cW1bYk2ToT6Opl+6aM7oVF/y4j5eTWPiM5h+ivIEabja3N13Nn1HmaK50xCVVAil6lZzeF02ehbhu+mnilR+1y+kd2Y6/XAJwLUHfI8vJ07Uhaoa2omBtLLApVqnnuUpY+Z85EaB6yPq0R6qZy5B+ZZAtcg8pX8iOztE3iyI05LQJ4qIfsT9jk2p73xfGst17lRtcRcJJNSlVXI+9m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new memory hotplug APIs that allow callers to explicitly control
the online type when adding or managing memory:

  - Extend add_memory_driver_managed() with an online_type parameter:
    Callers can now specify MMOP_ONLINE, MMOP_ONLINE_KERNEL, or
    MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave
    memory offline, or MMOP_SYSTEM_DEFAULT to use the system default
    policy. Update virtio_mem to pass MMOP_SYSTEM_DEFAULT to maintain
    existing behavior.

  - online_memory_range(): online a previously-added memory range with
    a specified online type (MMOP_ONLINE, MMOP_ONLINE_KERNEL, or
    MMOP_ONLINE_MOVABLE). Validates that the type is valid for onlining.

  - offline_memory(): offline a memory range without removing it. This
    is a wrapper around the internal __offline_memory() that handles
    locking. Useful for drivers that want to offline memory blocks
    before performing other operations.

These APIs enable drivers like dax_kmem to implement sophisticated
memory management policies, such as adding memory offline and deferring
the online decision to userspace.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c             |  3 +-
 drivers/virtio/virtio_mem.c    |  3 +-
 include/linux/memory_hotplug.h |  4 ++-
 mm/memory_hotplug.c            | 63 ++++++++++++++++++++++++++++++++--
 4 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..5e0cf94a9620 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -175,7 +175,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * this as RAM automatically.
 		 */
 		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+				range_len(&range), kmem_name, mhp_flags,
+				MMOP_SYSTEM_DEFAULT);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 1688ecd69a04..b1ec8f2b9e31 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -654,7 +654,8 @@ static int virtio_mem_add_memory(struct virtio_mem *vm, uint64_t addr,
 	/* Memory might get onlined immediately. */
 	atomic64_add(size, &vm->offline_size);
 	rc = add_memory_driver_managed(vm->mgid, addr, size, vm->resource_name,
-				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID);
+				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID,
+				       MMOP_SYSTEM_DEFAULT);
 	if (rc) {
 		atomic64_sub(size, &vm->offline_size);
 		dev_warn(&vm->vdev->dev, "adding memory failed: %d\n", rc);
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d5407264d72a..0f98bea6da65 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -265,6 +265,7 @@ static inline void pgdat_resize_init(struct pglist_data *pgdat) {}
 extern void try_offline_node(int nid);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			 struct zone *zone, struct memory_group *group);
+extern int offline_memory(u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
@@ -297,7 +298,8 @@ extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
-				     mhp_t mhp_flags);
+				     mhp_t mhp_flags, int online_type);
+extern int online_memory_range(u64 start, u64 size, int online_type);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 				   unsigned long nr_pages,
 				   struct vmem_altmap *altmap, int migratetype,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ab73c8fcc0f1..515ff9d18039 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1343,6 +1343,34 @@ static int online_memory_block(struct memory_block *mem, void *arg)
 	return device_online(&mem->dev);
 }
 
+/**
+ * online_memory_range - online memory blocks in a range
+ * @start: physical start address of memory region
+ * @size: size of memory region
+ * @online_type: MMOP_ONLINE, MMOP_ONLINE_KERNEL, or MMOP_ONLINE_MOVABLE
+ *
+ * Online all memory blocks in the specified range with the given online type.
+ * The memory must have already been added to the system.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int online_memory_range(u64 start, u64 size, int online_type)
+{
+	int rc;
+
+	if (online_type == MMOP_OFFLINE ||
+	    online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
+	lock_device_hotplug();
+	rc = walk_memory_blocks(start, size, &online_type,
+				online_memory_block);
+	unlock_device_hotplug();
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(online_memory_range);
+
 #ifndef arch_supports_memmap_on_memory
 static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
 {
@@ -1656,9 +1684,16 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * The resource_name (visible via /proc/iomem) has to have the format
  * "System RAM ($DRIVER)".
+ *
+ * @online_type specifies the online behavior: MMOP_ONLINE, MMOP_ONLINE_KERNEL,
+ * MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave offline,
+ * or MMOP_SYSTEM_DEFAULT to use the system default policy.
+ *
+ * Returns 0 on success, negative error code on failure.
  */
 int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name, mhp_t mhp_flags)
+			      const char *resource_name, mhp_t mhp_flags,
+			      int online_type)
 {
 	struct resource *res;
 	int rc;
@@ -1668,6 +1703,13 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	/* Convert system default to actual online type */
+	if (online_type == MMOP_SYSTEM_DEFAULT)
+		online_type = mhp_get_default_online_type();
+
+	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1676,7 +1718,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -2412,6 +2454,23 @@ static int __offline_memory(u64 start, u64 size)
 	return rc;
 }
 
+/*
+ * Try to offline a memory range. Might take a long time to finish in case
+ * memory is still in use. In case of failure, already offlined memory blocks
+ * will be re-onlined.
+ */
+int offline_memory(u64 start, u64 size)
+{
+	int rc;
+
+	lock_device_hotplug();
+	rc = __offline_memory(start, size);
+	unlock_device_hotplug();
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(offline_memory);
+
 /*
  * Try to offline and remove memory. Might take a long time to finish in case
  * memory is still in use. Primarily useful for memory devices that logically
-- 
2.52.0


