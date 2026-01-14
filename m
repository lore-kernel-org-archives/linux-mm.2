Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF8FD3CC8C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D406B008A; Wed, 14 Jan 2026 18:51:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83BB86B008C; Wed, 14 Jan 2026 18:51:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FA46B0092; Wed, 14 Jan 2026 18:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F28F6B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:51:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E86EC0442
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:05 +0000 (UTC)
X-FDA: 84332217690.08.9621DA6
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5E06F20006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T8VeSHr1;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768434663; a=rsa-sha256;
	cv=none;
	b=3GehOnneXfN6hm1gcUSiBvqSxR6wA6b325weY5pMgTrsFMB+pIY0mhSLPU8mvy5lPEdV4Q
	PE2qhJPj8oqFlrghIwCA2TW0GXaBTFj4W7R24c1ubbd3XiJ29PIXNDw+POazzZuumfYe3N
	1B3lXDO1HFoGUbvKINEdgslvUFc6SI8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T8VeSHr1;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768434663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXtSnfgPBjwiSCGU9CrPH4hnxnqEFEy6STkxK/VjbLc=;
	b=2eEQUQUuOGoRJ8TlouHS4WV9KVR3oPztLnMAPYoBzpNx7Ewb1rF7fVhsUIjIEb54BCARjo
	Sz2bsgJAgX4BAbnOJQr85YglOBRnGMuuEIRCRC+DqP7sl5wSzjfc8HlCmE/V+73JP6SHkk
	S0Zu9dBd81Ts9Y7Jn8WlG8zzMDrP9jQ=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88888c41a13so3862126d6.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434662; x=1769039462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXtSnfgPBjwiSCGU9CrPH4hnxnqEFEy6STkxK/VjbLc=;
        b=T8VeSHr1JN3vCl0OSKA19/lsTy+8PqW+Li9uu3OIIbT+GuFuR3YuSbLF14pb/AKZZ/
         mGf5CnaUEKSB/RPk2Tw/v5zUPQTjSv+VgHacj6pBLg3TAXjFWXpivHWV1UOPzauI6Z5E
         bqslr6M0NEHFRPpZEdHI10jhBL7QvNuJqRdGlvpgPn7g0BdfAQ9qbfL2/khSfLoXhxU6
         8H7Cs7d4KPVg5H/P1eic3GYjv+Qa+KELKWA+3k6t/495t6BnTdtdMzWveXc1wJw8OqrY
         Gf6QLsUrJa41sOkNGKwij0W6ooGWen26l19Z6L1V/1ZT5Z17GOJr90m/bQPlFU8kyFte
         +HhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434662; x=1769039462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cXtSnfgPBjwiSCGU9CrPH4hnxnqEFEy6STkxK/VjbLc=;
        b=riIGxFvRacybLo78AOZyshA79GJ9eFLQJVNIrhmJiBdqB0FDUwv89hPZzB+/qX+PQ0
         xz/fiAIMQTdTk+COgGCk0DF6Mnhy/zU1NR3aNF74bTe9haKnCI+87qd1m9ly51A88xmx
         Hx5SCRrvAFvVGiw/NyYvIS8tCA6eD4aEDqZwpxwfXfPugAN3wN+4EPP4J7nF/rI6VDfo
         4o/vYwldi14aVv1HpVoo8vRVlYvPSFwkgtqS8BZewfZ/mjmtonXrcAvqeIkgbVGJkj4r
         IVQPnZd1ykMiOSMg6Winh2jWC+C7haJ5jfexUqOQ8WOu9i6hCNYmSBwGWaQv4+BDyNb1
         V0nw==
X-Gm-Message-State: AOJu0YzcGjif/Kzzku4eB+7pI5MKlov7086KCShSfv6h/lPgFz/7vZmF
	ruE70BCfstkKLCyktA+qgs8hxFttIgglPms6lR2dBC3AaZrHpB0+Txmo/B+Lo3IvLjSK5DkLvkY
	FXgEs4sA=
X-Gm-Gg: AY/fxX7yOsBHeZBzz3mWu0siK7OUY8qpNVZ4oz/fcTiIn0N6NIwiB3/A2WyZ5MGRgHD
	52SDatfTxyeWrT11WIQ34RF5QcrLs5yUW4xdCpdZ4vWvXhSxr7SY90RCa3rsmW0r7XJ1wsrSGsM
	LGh82Nq35nWdLI9DGhLloYqTdyrbGqgjOkjkb87sLbgwVIYhthnGSNzV2IORZrVlTjj0wAM+21X
	d13zrjnFD7xNC6h+u+dkFzLdlmlzFfoaJZq/Bm1/KugtLwiFGH2ztKkfJl26Y5OAwFaN8EXvRbD
	2aoE6s2jS+21vs/7J29axszcXBa5zWls0860UaivhzMmCnW2OXutoq2dk+iEPbKV7BWY28Zunuu
	+xDAYiS6Y9ypbo6XBgAZycwwNWZ7MDnlmpAnuS6aW0TMnFp1di+90IfM9oDPWkHX1EdKtB0rzZa
	rCMn7uyiD+wP+XLjCgIl6vv4KEz2l01N6mRrfXczU2F1+OmZrMMJvg5n7qCE2VHhs0SaTHVr4NJ
	ZM=
X-Received: by 2002:a05:6214:246c:b0:88a:2f46:8224 with SMTP id 6a1803df08f44-89275c89a31mr55155636d6.68.1768434662147;
        Wed, 14 Jan 2026 15:51:02 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:51:01 -0800 (PST)
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
Subject: [PATCH v2 2/5] mm/memory_hotplug: add 'online_type' argument to add_memory_driver_managed
Date: Wed, 14 Jan 2026 18:50:18 -0500
Message-ID: <20260114235022.3437787-3-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E06F20006
X-Rspamd-Server: rspam06
X-Stat-Signature: oxirhrsxmrqtu8e99e3uiexa835xuch7
X-Rspam-User: 
X-HE-Tag: 1768434663-137248
X-HE-Meta: U2FsdGVkX19O9CeFcYW7vvBiQcSW5ez6wEpYsRIfNmTuF4J6++sAHyUAzX5IK2thF77+yx4x8DWRQwGKXQf6Bo6g3fl7gxsmuiswQcfv32i3hswvXTuU5Oh1+wkmUgs2lxLIgr5hLQC7RZAkJ4gQidRdBTFfDOzufiPX8HFUPilRmnvNbLCRSHnvfW24q2U0j5PnCzci1jsaWAXY+o8iyOWjENcWSjU3r8BkFCSJqp0V+rdYEQkUHgMnIzlZT4YZYm6cfeF+dYEtKenAUerB21DFFVb7rKqyMPVy6g8fUL+exA9JFgVO1KfuVzGr6sz2ZmJW0AVRnlb5+5BCrFugwYyaL3srneaVAT1x08J9nsQTVbNuJaeYij0ZR6trtThAVRTdZEkGJN6CpkN6Xljvogj6W/5xbUSzPa/CvIgBxJjWTBTLO3MQBBhm0Zu5mGzHuyQqM/pUW3b958AfmQcr3oq7DhVp7jBZD8EuZtJB5ELHMswwFmDS5GWQ4Yd0Pn5GNW3LrctcWNNxq5VFCrW864V+QRqvr/Wc722fj+vGGPeke65BDPixAU7pueXSWdKqiO2GRgd/EDJM14X7RbklFp3PjGTp0domFULWLAtG+3EflAe8RTHQbNqnNro0kWdXzW2qT/SVuVQfOheIzOIivzeamNfI3d+Kpt11dgSovi70IJ3MfIf/VWZymAoVObLXvZERcFWJs2wNY8HmqOF4jeEZ9RsZCEUOyxYG5a4LDIVYDRPwldh86ghHMpz63bE8Bhh1MjbSriyU5sRIbCD0ryAUJuSXA7N+IKbX7c/oPj4hXGVYQRzEnx27pzf1rwdA2L89ez9au6+iSANN83O1GULb5rKz0KrMdkoxL2FacFag7OBBL7SJQ9DNGBStnM6Iicu+EplvOy0S+SnesZMsNWZdNNxhnpy0GPy8fjErHGFdQ9CY+h/KQqKUASyxhz+bO/yQN2bgviLF4u4lwPi
 y/ukmojd
 kd7JBvQ3yMKrtJykmlWnl2wOQgSktOqQuyks0cTP8anPscdnBF2eEAxJI+IteW/9WLQTyz3ztF47mzh5VqadwrPwodAQ36rrksfsC1ExSm9dYDEjnkGw4lZSr01+ok6z3a+ZFY01q96G0sp6ioK/IwLUMDVyRwnxRmFJW3ICSGoEKsYr8zdbt0u7R4Mu9UpWLOb8GM0ko/HnACFAeKLII0VMMIGODAgWLMtW7uZH/nw4YR7eMKMbbTfvhAcOAx71s70tnobygljvinzYwqcpnxwuR7DdhuWzRDxkv+00h+qnpTzAjmHw6spr8LjWcTs1UBwrgod/IARuADVKlu9UY1hgghumajrP4hSqX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable external callers to select how to online the memory rather than
implicitly depending on the system defauilt.

Refactor: Extract __add_memory_resource to take an explicit online type,
and update add_memory_resource to pass the system default.

Export mhp_get_default_online_type() and update existing callers of
add_memory_driver_managed to use it explicitly to make it clear what the
behavior of the function is.

dax_kmem and virtio_mem drivers were updated.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c             |  3 ++-
 drivers/virtio/virtio_mem.c    |  3 ++-
 include/linux/memory_hotplug.h |  2 +-
 mm/memory_hotplug.c            | 31 +++++++++++++++++++++++--------
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..bb13d9ced2e9 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -175,7 +175,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * this as RAM automatically.
 		 */
 		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+				range_len(&range), kmem_name, mhp_flags,
+				mhp_get_default_online_type());
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 1688ecd69a04..63c0b2b235ab 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -654,7 +654,8 @@ static int virtio_mem_add_memory(struct virtio_mem *vm, uint64_t addr,
 	/* Memory might get onlined immediately. */
 	atomic64_add(size, &vm->offline_size);
 	rc = add_memory_driver_managed(vm->mgid, addr, size, vm->resource_name,
-				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID);
+				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID,
+				       mhp_get_default_online_type());
 	if (rc) {
 		atomic64_sub(size, &vm->offline_size);
 		dev_warn(&vm->vdev->dev, "adding memory failed: %d\n", rc);
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f2f16cdd73ee..b68bc410db67 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -295,7 +295,7 @@ extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
-				     mhp_t mhp_flags);
+				     mhp_t mhp_flags, int online_type);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 				   unsigned long nr_pages,
 				   struct vmem_altmap *altmap, int migratetype,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 5718556121f0..2b4e31161fc1 100644
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
@@ -1649,9 +1654,16 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * The resource_name (visible via /proc/iomem) has to have the format
  * "System RAM ($DRIVER)".
+ *
+ * @online_type specifies the online behavior: MMOP_ONLINE, MMOP_ONLINE_KERNEL,
+ * MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave offline.
+ * Users that want the system default should call mhp_get_default_online_type().
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
@@ -1661,6 +1673,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1669,7 +1684,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
-- 
2.52.0


