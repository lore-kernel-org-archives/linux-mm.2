Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A44C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA05B6B00A1; Sun, 20 Sep 2026 05:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A518D6B00A2; Sun, 20 Sep 2026 05:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967616B00A4; Sun, 20 Sep 2026 05:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB5F6B00A1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:29:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEEBA803C6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:24 +0000 (UTC)
X-FDA: 85233617448.29.9F8CBCD
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1E4ECA0004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N7PoYT0A;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqWx8mKAaudoHgwpRkE/5/zADaw3qTiUOzjXR8usL9g=;
	b=to9LVB/YAty+2+1RbwxX8B8DBAFU4TQyZMTr6JSMiwUx+L3z3HaldNuQBR9OcR3D5AuFHL
	QwAADngmC8MjInW1HukUboPLLBrQ7LgsG6nqTZg8Uqmlz0tv61qYBwCXwXz+ErZJXRNMiX
	7FZS/iTcu7/T7hZRh2jvg32dSlVe9Ao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896563;
	b=G+IAR4wb3nzzzox53feSJhtwnkhX2BQGOODCCaF8EU685FCsmWz1C9i1EYaG8PynBnrjvl
	kDwjmA6n6282XPjRf44w0uSVEXlaQWBVDU1e3cZGZEPqPP6eI5t0JIRFMpIpv3UJyS9ZP1
	M5RAP0uiOqt9Wj7+IKQw5wfIMBbX9Sk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N7PoYT0A;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f5.google.com with SMTP id 98e67ed59e1d1-3965683e9e9so1587825a91.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789896562; x=1790501362; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fqWx8mKAaudoHgwpRkE/5/zADaw3qTiUOzjXR8usL9g=;
        b=N7PoYT0AduafH12EgE9M1jKx83HXJkf14GNCAljrL8/tVVBdMF+0Qy1eIDBPMVmjzY
         5pPsed+O2wOVlGWR8o1+0KaLFlhRksuGhsuyfop3PcjXGIBxQP8jol7tBA4CgtpDP3ut
         ABb5qYHTc3HWfHpE0Hm7fVYYlnOgDL3c+RVKSIkJURVZIQTlHl8V82dBpCp2bd+TOy5O
         JxaWhOzZ4Wj5cByKwHLAOZVvSFAcXOO/MB4Gdy4Pio8iO+F/I84XveY2CB/u12nnp988
         AwDrE2wjieR4G5DozJdv5TN5WhWTf1cGv9N4b81n1Glv4OAvdmNDFcjROSKG4DGvU81x
         xlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789896562; x=1790501362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fqWx8mKAaudoHgwpRkE/5/zADaw3qTiUOzjXR8usL9g=;
        b=aDsjJCPi7I1MvS9SUICdWlhSpfUiTX2PR7y5B1MRouZPZ16kRt/cuRX/zWpMectKXM
         Q86fUq7B5kdwq9DyoRlmJV62bEyEePhfnMyRwAmIT5RZBDpSdsH/1QODnz5eIP4H+j0V
         x/mR9H3elMgvSwQWrJboEcGCRiVWuhg3KC1VQ4/VTTAboJtufgHDtp8zJTukOv0onflu
         QKVjTbb2/79DgPJwCBYW75yWH/PFhaI/wS5y0MJHgqE5I8qkvftdzFlMFWRYq0XBHAQl
         Ue5n/CRcheYPsmNzhixSDo4Vh19pyyOKOcqmnr6Zx0moJ6IcAJNXsH0+75J0TPiLWRIs
         n67g==
X-Forwarded-Encrypted: i=1; AKwUvBwyY0ntXETDvZZqA7efUNG0TekzeLH2NHMKvkHE4HT/dZ4KNjJbfe+sNBNeZL6dt8H+glo5XKn5LA==@kvack.org
X-Gm-Message-State: AFuF++lcT6m5X+oX5RwUWy+7vLcs0pthkPae7nMa4TKhUyCyh8WRu8Zw
	ULDesB6gVbBJRHPCTUjURLYZk/9WieZ74CIE/ia0dCGGw/veccmguRnP
X-Gm-Gg: AYBFou2jR0+eBmNXjWO/HKD5frxj5/xzkWi6qvdnBriQ4N6Z5MuFphwq3HfNYAqwdg6
	SZ0FZZqFBOBm35lRzZroMeUseKVkPmD7VtzUnYTZlWHCC/BO+AF3lL6iDpNeHZonhqLqKbbm4VD
	F1WemQv8i5s5/wUYMpKUKUuEksUcuugW3jdlJ2h15J14KElslEYPA9j+9a9AF9SZ0LrspPWmIIp
	bOh+5LmzrJoCF5aw4/ueyj/2q8JrZPHa5y4WR8bzIfQdzAnTtEln56cYAV5ik8MJu4ZqAbUaPja
	qpIq8w1GhvAoiQQr0l3vlEvjks/0TrRR26TVhny6IgF/Bdd2FP5GELHaXYxMsta3ABxibe6XeYi
	oXY4Eja1Ge2KvMdjY5GyYHUbno3XfoyVnj1Jx3ds9rN3DDfEiw3ySXQxYks6sLJVOA8P7xbCETB
	nhuXlO3oWxhzWBZObw6ygySOuVbxO7MsIAyw8Wj+YPzStOWy+hUlpYlSsocZFbhNkKQIiDq3cIc
	5RmWR2kkzE=
X-Received: by 2002:a17:90b:4b85:b0:3a0:42a9:9c73 with SMTP id 98e67ed59e1d1-3a042a99fd2mr465493a91.38.1789896561858;
        Sun, 20 Sep 2026 02:29:21 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c64csm8154917a91.10.2026.09.20.02.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 02:29:21 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v3 3/5] of: reserved_mem: skip init for regions whose early reservation failed
Date: Sun, 20 Sep 2026 17:28:50 +0800
Message-ID: <20260920092852.614973-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920092852.614973-1-chenwandun1@gmail.com>
References: <20260920092852.614973-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zgo9nxcjnaazuknrjjdmnxdqn8fa74z7
X-Rspamd-Queue-Id: 1E4ECA0004
X-HE-Tag: 1789896562-875853
X-HE-Meta: U2FsdGVkX18qiVeOctwGFnNf3M3nRH+OT/N+oqz79HIzAXO1Qj0M92XeKs/Be5K3+eEuWZhG6USDZhUMPzA4vcsAzk2sBzWUrdi2fXwv8/t58hTOxtha6Aq8kM4qgS6Y2feeKR8lYw2sUUaELj+bNkz7/6ZWP3dA66sUntvenYJZ26oOIMCNqfd5M9PRzfl+52tAaOszhKpGzriRySJ1hNrMm3d09zyZaDwErdUrr3pa2pAVGjuKJ7MPk48agsbVIp4kHFU50ZIYzRP2ClScKzVZ0UgsvX0MPS7sAJPci+w3ArfAX3FX9vVnlAAifDe6WxAtjSJnWTo/a9n6mkYTPLLI+HEkcb4bRTnDH+ueBnwBe2E2HrprWf6dYxbhH033W2gLqs0gjDI6k7+Un7pchaCz3m9MViYdihu2mJXQrQcmy0e+ucAw4202nQRIgT72leMliIVXBlZgMvSURLE//Zvxxheq6lLtOVP8rcLmWiQ2X7U94W+LPt6B+GaNgVZEnAtarZUAh41hKVf57qbdkRr2xiWxlstXvBLaoAGjUgyvFdP8l5wk4k86OzezeVEZYTzMbJAhC2ZnQi5UX4xjVBPyTkRCR7nh1YovacPUgv+S/KuFYoQ8MsCFQurXd2abgxS5v0L4xJteM242YN0DsO+1AIHFC6XGaPrA/JTssP/tb4vSAoX+ax3uLccDBdiQLekxQiHu6eM7LQseXyejowZyam2WFf+M0k6PGE4x9ZI2J9y0Sp4Xf7UqjF7f3wcEQOHiywl3uBFmeMjnaRPHrkCqwxrwPjiR50O5rD61DdciYNQzmPV39/jyDmUvk+7+OW9ujX/0q/fD17xSws/OxtKGdgxUeX+IQ+XElEVYWJW0d07bjwVPD6pQWrT9kRN1V6uyfBO6TyPA5V+SW1Dlv/rWb0tJaVQSvNWy8BaBN39VMfQPNapC/o+ObxlmhPpqgzTkxjqTVroYjZrc1Zy
 5hWCaI+P
 e46w+4zAw0NBYzL5m6+ANnVTo9k46Hsv3lYfw+u1HuT2bksxRwRF1d3Y0WqasCsdqauprhZ4JBsd/ReOY/sUx/mQOteDO93HVOZNzEU9OtLF+fWTJHrjttbX8H7dioCB0kFBBZ155aEVW3wQ/s5qsFDZMlAsAjZydCtoNI32HvnIBlgMgT9shD5AZDEQBt/AOdF5HCZ3yjJq0+geWJ+xVu0UTXN11yiPZP7rw6fvJ+1RKGUosXaCvXCTP3TIK0Wdm3fPU6As6ASy+FY4Wfepma6/4gytV66w2cG6cGYlpVkf6O/t+EHox/f2tiHgh++CscbDAT7BLyk6FqEUi/Ih0Xlt5g5pqVPXGrRZXa4g1GwlTZsUp1EIjsElYLQGXsqNjScyDUZQ1J7bf89Zs5aZwi16/dGa9+Bx9FFULhwqqGe8XoQI3DqDV7Jm1RrXt1vC60XoySD4X/V2TzEHFJ6gXxA4DKBZW4qhDU6vceZmO4ryk7T5zSCIKRd7kS/kWhqRG6fhwd84mgwN9Wt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

__reserved_mem_reserve_reg() discards the error from
early_init_dt_reserve_memory() and returns 0 unconditionally, so the
caller counts the node in total_reserved_mem_cnt and the late scan
initializes it without checking whether the early reservation actually
succeeded. A region whose reservation failed is then handed to a
device assuming the memory is protected.

Tag each region in memblock with MEMBLOCK_RSRV_RMEM when its early
reservation succeeds, so the late scan can check whether the node's own
reservation succeeded and skip those that failed.

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 drivers/of/of_reserved_mem.c | 46 ++++++++++++++++++------
 include/linux/memblock.h     |  6 ++++
 mm/memblock.c                | 69 ++++++++++++++++++++++++++++++++++++
 3 files changed, 110 insertions(+), 11 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 2c64d85cabc6..3a6c6dbfd7b1 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -122,6 +122,8 @@ static int fdt_fixup_reserved_mem_node(unsigned long node,
 static int __init early_init_dt_reserve_memory(phys_addr_t base,
 					       phys_addr_t size, bool nomap)
 {
+	int ret;
+
 	if (nomap) {
 		/*
 		 * If the memory is already reserved (by another region), we
@@ -132,9 +134,16 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
 		    memblock_is_region_reserved(base, size))
 			return -EBUSY;
 
-		return memblock_mark_nomap(base, size);
+		ret = memblock_mark_nomap(base, size);
+		if (!ret)
+			memblock_mark_rsrv_rmem(base, size);
+		return ret;
 	}
-	return memblock_reserve(base, size);
+
+	ret = memblock_reserve(base, size);
+	if (!ret)
+		memblock_mark_rsrv_rmem(base, size);
+	return ret;
 }
 
 /*
@@ -168,14 +177,19 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 	base = b;
 	size = s;
 
-	if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
-		fdt_fixup_reserved_mem_node(node, base, size);
-		pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
-			 uname, &base, (unsigned long)(size / SZ_1M));
-	} else {
+	if (!size)
+		return -EINVAL;
+
+	err = early_init_dt_reserve_memory(base, size, nomap);
+	if (err) {
 		pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
 		       uname, &base, (unsigned long)(size / SZ_1M));
+		return err;
 	}
+
+	fdt_fixup_reserved_mem_node(node, base, size);
+	pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
+		 uname, &base, (unsigned long)(size / SZ_1M));
 	return 0;
 }
 
@@ -288,6 +302,7 @@ void __init fdt_scan_reserved_mem_late(void)
 	fdt_for_each_subnode(child, fdt, node) {
 		const __be32 *prop;
 		const char *uname;
+		bool nomap;
 		u64 b, s;
 		int ret;
 		int len;
@@ -307,10 +322,15 @@ void __init fdt_scan_reserved_mem_late(void)
 		base = b;
 		size = s;
 
-		if (size) {
-			uname = fdt_get_name(fdt, child, NULL);
-			fdt_init_reserved_mem_node(child, uname, base, size, false);
-		}
+		if (!size)
+			continue;
+
+		nomap = of_get_flat_dt_prop(child, "no-map", NULL) != NULL;
+		if (!memblock_is_region_rsrv_rmem(base, size, nomap))
+			continue;
+
+		uname = fdt_get_name(fdt, child, NULL);
+		fdt_init_reserved_mem_node(child, uname, base, size, false);
 	}
 
 	/* check for overlapping reserved regions */
@@ -662,8 +682,12 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 
 		if (dynamic && nomap)
 			memblock_clear_nomap(rmem->base, rmem->size);
+
 		if (dynamic || !nomap)
 			memblock_phys_free(rmem->base, rmem->size);
+
+		if (!dynamic)
+			memblock_clear_rsrv_rmem(rmem->base, rmem->size);
 		return;
 	} else {
 		phys_addr_t end = rmem->base + rmem->size - 1;
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index aa845f488327..03613fa0c894 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,7 @@ extern unsigned long long max_possible_pfn;
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_RSRV_RMEM: memory reserved by a static /reserved-memory node
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +64,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_RSRV_RMEM	= 0x100, /* static /reserved-memory node */
 };
 
 /**
@@ -160,6 +162,10 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_mark_rsrv_rmem(phys_addr_t base, phys_addr_t size);
+int memblock_clear_rsrv_rmem(phys_addr_t base, phys_addr_t size);
+bool memblock_is_region_rsrv_rmem(phys_addr_t base, phys_addr_t size,
+				  bool nomap);
 
 void memblock_free(void *ptr, size_t size);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index ea0de4b5f356..d88e926e2ea5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1204,6 +1204,39 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_SCRATCH);
 }
 
+/**
+ * memblock_mark_rsrv_rmem - Mark a region reserved by a static /reserved-memory node
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Only called for statically placed reserved-memory regions (those defined
+ * by a "reg" property), so the late scan can later tell such a region apart
+ * from one reserved by unrelated code.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_rsrv_rmem(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_RSRV_RMEM);
+}
+
+/**
+ * memblock_clear_rsrv_rmem - Clear the static /reserved-memory node tag
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Only called for statically placed reserved-memory regions whose late
+ * initialization failed, to undo the tag set by memblock_mark_rsrv_rmem().
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_clear_rsrv_rmem(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 0,
+				    MEMBLOCK_RSRV_RMEM);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2154,6 +2187,41 @@ bool __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t s
 	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 
+/**
+ * memblock_is_region_rsrv_rmem - check if a range is tagged by MEMBLOCK_RSRV_RMEM
+ * @base: the base phys addr of the range
+ * @size: the size of the range
+ * @nomap: the expected no-map state of the range
+ *
+ * A range with no overlap in memblock.memory lies entirely outside
+ * declared system memory, where the tag could never be applied, so it is
+ * treated as reserved. Otherwise, every overlapping region must carry the
+ * %MEMBLOCK_RSRV_RMEM tag and match @nomap.
+ *
+ * Return: true if the range is reserved, false otherwise.
+ */
+bool __init_memblock memblock_is_region_rsrv_rmem(phys_addr_t base,
+						  phys_addr_t size, bool nomap)
+{
+	phys_addr_t end = base + memblock_cap_size(base, &size);
+	unsigned long i;
+
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		struct memblock_region *r = &memblock.memory.regions[i];
+
+		if (r->base >= end)
+			break;
+		if (!memblock_addrs_overlap(base, size, r->base, r->size))
+			continue;
+		if (!(r->flags & MEMBLOCK_RSRV_RMEM))
+			return false;
+		if (memblock_is_nomap(r) != nomap)
+			return false;
+	}
+
+	return true;
+}
+
 void __init_memblock memblock_trim_memory(phys_addr_t align)
 {
 	phys_addr_t start, end, orig_start, orig_end;
@@ -2880,6 +2948,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_RSRV_RMEM)] = "RSV_RMEM",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


