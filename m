Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB52C5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB976B016B; Tue, 18 Aug 2026 05:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2835F6B016C; Tue, 18 Aug 2026 05:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1727A6B016D; Tue, 18 Aug 2026 05:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0DC96B016B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:24:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 553EAC0BB4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:36 +0000 (UTC)
X-FDA: 85113854952.03.41A6ABC
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80712C0003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CjDZK7Kq;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787045074;
	b=flKHb+zSr7wzmLb9yz2RrkZ5I/gBYXlUnpGrZXWG0YoW1LXHcrwCf9gOsoCw1vss9eXJu+
	rWbX4WLcUvJPLM4vnE9FW23XlrSlcBDDzDZhIbtkUjXGUl439irtIaQZkCW5+E458qkY3A
	wu//BYW/pfw031GZM4Ey2+XqnkZoobw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CjDZK7Kq;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787045074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edFBVCDZ8uahtaafghiqDdA2JkU9nFhvYVeD5bTaUSM=;
	b=1mJVdPuFM9eYdFGMyvH629+9phhwawIrIUlAVNYHhSGam7A5XqAlhh0rrkYByWWcW46qPU
	XuZM1o8+N29rReYDsvcz3LnnvgBBA708WuuoRCoKdASFZ/3qCgp3AOLO+Uq/+jT31Olc/5
	y8EXBjl9S1O04n1pnGcIjLLViLlseBQ=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-84847482584so606921b3a.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787045073; x=1787649873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=edFBVCDZ8uahtaafghiqDdA2JkU9nFhvYVeD5bTaUSM=;
        b=CjDZK7Kq4NIhZIKqrcJ8F4kA1MViusQ/hpgOEGLI3quxrkG2SofEuyBCImjInG9vDn
         +Cy3JRyCTiaWupDsnacTvTAAatU/Sc3i2h3As407imOgFDMV5GuVB7bjOHIsQc2c0OCd
         MoGOEWgNOK+c7+KbT83Lcpqa/vM76kxys6M+q2EzLfglbFgPIsMkbOx0WeQYB3gfUpwo
         15ood8kZzXdD4buk3hDU+LxjVUI+XbpFU5sD3ZkHHpqM0mUukTQY+U8zhRPzwp8aKzr4
         XHwJ0AQ8IF2ouoNxpDytLtdExVYf2eLFugMohIJqW2vp5eYsnRYfxHnIUfuYzct7p2VL
         H6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787045073; x=1787649873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=edFBVCDZ8uahtaafghiqDdA2JkU9nFhvYVeD5bTaUSM=;
        b=kWkEJoL7lXIikJO5hWACRoMwctc+8zy98oBwk1I33nCSECljIo+j5YNp0rz1OFVbf/
         DsT7if7jNd5va1tB7s/sDpA6JjNcTIXRH+F0v2XYn5KIugigq90UAsRMEh9pwYN9n/jZ
         Sk7/ETS6iAZqRQczmAfu+ptyFVugTKWlA0RpgLomp67HBG4nQNs0bUYHrqxZHIxyIjYB
         0DqwXPmYegOzrUlphg99KfhNlVk/GnX8KP7N+JLlBG57oyTmEwMKESivrGBIPMjDZNsY
         WLIczRyjXUYa8TUtIvI1E3bHHQcey9D8AvRAOX1Z+ApF/m8lOcNfa8IYx5o9Q5xsMtsi
         thiQ==
X-Forwarded-Encrypted: i=1; AHgh+RpQpZ3RvZe6TL3o9t8dqujymwjNqvjVlG8OBcc8nCOKVrS+dgsUrog5gdztDCCmjOh1hJdAjTV4sw==@kvack.org
X-Gm-Message-State: AOJu0YxUdCfDszAbiF55aBNw/x+U7x99MXkY7UKNLWiQmB2cw3Xu5AXO
	Q+MkRVAbTCa98OaigFbfvTr2cIGFuFcrZuznsbASUmM4qQUTPpSe98ukYHSEH2yR7Nc=
X-Gm-Gg: AR+sD12sBfJdwKm0KV5Fx+pZgSGYav22gKhGH3Uz9PMqGfb8MoPzbRLMlZPYKMRlWTG
	0Tz+jKqhKeDo5Mj0s474dEOv3O8OTfjG2k0H86bG7XOfw4Zk89NpJociba8b2kVMzO4UDY2SZEH
	xAwpPsGcDYVpMwbKvkh2s7b38JwLesNrAaPfAusx5JTqtRkp5O6Mp7f8T5sHRaCwZvmxr/GblFM
	TW9d8xYSyW5XsCnZGVXiK+SO2Shav5U3jG/eU3eXL/RwqQ7OO47jFLxk85Jm4I3/+kPqvPjE8Ry
	VLGaJ0NdQrjOGTf2Ma3bw8W0fd+lp9txy7xDvraIbSCEztWdBoYu9DV+1UjHiM1c1ZpVtbpMkj+
	HSqQyhBntMZqSkT3QMFbI2agZPrwrFyfVYRR45tx1+VzR6DeTjFe429egQ/GxNWNIB4IwEXDXIO
	UQyOALpfMcQQ1VqGzVWOChhFdcH0x9GHrB8jxjVHOnpGUjMtKK5+ec3cy1gxd1rcbTxAo5RPp0
X-Received: by 2002:a05:6a00:3a13:b0:84e:ea49:8899 with SMTP id d2e1a72fcca58-851bc2cc6b9mr4442181b3a.6.1787045073210;
        Tue, 18 Aug 2026 02:24:33 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13c036c50sm1855975a12.26.2026.08.18.02.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 02:24:32 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v2 1/5] of: reserved_mem: skip init for regions whose early reservation failed
Date: Tue, 18 Aug 2026 17:24:16 +0800
Message-ID: <20260818092420.2859026-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818092420.2859026-1-chenwandun1@gmail.com>
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 80712C0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: et3irces5hpxw5mhjf41qg34s3aqqa61
X-HE-Tag: 1787045074-605198
X-HE-Meta: U2FsdGVkX19GDt3CeyPsuzq7/ZsuMIe6G8JBY/Sw2AZPjBZ+Q0huicvIHaWobfxdOkYy0nyFFc1WGwDqdSOiRpsXiIvH9NeMhpVE6e/3U+fmTeyqy/UZeVXSYPZMWoQ+9y+7g0GwBT+tBfyNymAXOXTgRi772uc9y8S5srnb+ZsH3ICSwD82G8ZTbrsBM44z1KuHgjzlHv/1fVrzWIKWj/EicPwhNuESOQmyBApSyjbPrDa1IQaVRK7OlG22LFh21R3pQlvlgccA6AM9CQBrDzmHW/Wml1YViU2AtA5PO5bPdUoW8e3Wi1hnFGAxfNTLD87pkBFRnwJwvJEHF97hYQbb7b4WPpXbDv2LwwchEZCp3v3Gi+zULqYbfIQcYqTuYzDkCE5a+RXA76yvmKKvtciUyxwqCt9GzSueHcYFoTMaTBZ0Etzn3CUjnS8BFesg930uiXW0ck/cR8X4RpZcNQ8nnsputI6Hw2ZlmpmXgwvHOT/DlbsHdFy62AjeJAJRXnlqLWQ4LpsoZkdTxJLKt18JIF0lB8vAn2vpuDU6uIUb4ypgh+e9KSmMVKGhKjYHnXnzp/C+bjEtr6RLt8RgQ16eqFLESY7Jf8Db/sy68EDuXRIqTwYC0RwAorxwyNd2+U5wiHOaAt1UNepc6H4En9KevTGaw8l18L44iujnId0jqYM9SQ/bnwgFCbaqx3CWa34VDJtsRNRaOA+HrV2fbbVLToa1a/DGxSeP3ZkTTan2iJ/4NeIHG4rbpIEyz0eSJxB1RpqH6yYAMxsusb8VvUHwOBMHjy8b+TSOGnLBVvJPqvEBbsD0OfjFvSKpPqvlTRnhUR3JjJs8xLOlWzpI89abISvotk4YuVKnjzUhtaf6f8ZTp3rbjpbXwboUOllViWTIJpqAkmMiWAh+c6AZbVb36wz84qruDR3abEyHCAKT13m8HYhVcY8CFVOToXApa/RTO0SkKilYS25paxl
 TzzztL8A
 q1DEedVpisxMzv9yDSAfAS+Sobh7Mk6Wn6P/I9zdi27+FvBhfJ2qKRiBAPlCK0wL9OcTjJFf+um/kLJF6afce12FPs61Wm+RamP1sHVS022BKkRmGr+OAdFCVIhzzN2Qkz0czK4x7hCufvB8tx8uiYKokp73xiex/VgiHZtGYNkPW6WPIHJPDbUpQFPtaIUwJIEiYn6DvPNAkM4ek7qGP9GusALGxLiZR70KR+4RdpT8552m1UYQBemGSej496n1mSi7ribqfn/xaXGaFN9hH0p8+DpIJ9JaJ67QdAUNhTz13dI3q2q+BXMFNqNkgA+Wk7xtrQSNEnt7gP50In3Oijo7TM7Q9bZc7+xooZicJscUVF4wUT6+5G+WqAqyXMy/sZ8iac0XfTK6w7WbF2W/iG6A0yC1TZGjhSNQkwybwcxPkm2BjnhFfIyJCKKzOK0hL7OQ7hCcqy0VRgT1NdsuqE8fFelxnrb35YBHQLGa7uqmKmn3aSyWJhk3QVA==
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

Propagate the error so failed reservations are no longer counted, and
record the failed nodes so fdt_scan_reserved_mem_late() can skip them.

Recording the failed nodes explicitly is necessary because
fdt_scan_reserved_mem_late() rescans the DT independently. It cannot
tell from memblock whether early reservation succeeded.

The failed-node array is bounded by MAX_RESERVED_REGIONS, the number
of static regions is not bounded by it, so on overflow the extra nodes
fall back to being initialized, which is the current behavior.

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 drivers/of/of_reserved_mem.c | 65 ++++++++++++++++++++++++++++++------
 1 file changed, 54 insertions(+), 11 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 8c9d6395d6a3..c6e73d710ee1 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -32,6 +32,30 @@ static struct reserved_mem *reserved_mem __refdata = reserved_mem_array;
 static int total_reserved_mem_cnt = MAX_RESERVED_REGIONS;
 static int reserved_mem_count;
 
+static int reserve_failed_nodes[MAX_RESERVED_REGIONS] __initdata;
+static int reserve_failed_nodes_cnt __initdata;
+
+static bool __init reserved_mem_node_reserve_failed(int node)
+{
+	int i;
+
+	for (i = 0; i < reserve_failed_nodes_cnt; i++)
+		if (reserve_failed_nodes[i] == node)
+			return true;
+	return false;
+}
+
+static bool __init record_reserve_failed_node(int node, const char *uname)
+{
+	if (reserve_failed_nodes_cnt == MAX_RESERVED_REGIONS) {
+		pr_err("too many failed regions, '%s' reservation failed\n", uname);
+		return false;
+	}
+
+	reserve_failed_nodes[reserve_failed_nodes_cnt++] = node;
+	return true;
+}
+
 static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
 	phys_addr_t *res_base)
@@ -141,7 +165,8 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
  * first entry in 'reg' property
  */
 static int __init __reserved_mem_reserve_reg(unsigned long node,
-					     const char *uname)
+					     const char *uname,
+					     bool *should_record_failed_node)
 {
 	phys_addr_t base, size;
 	int len, err;
@@ -149,6 +174,8 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 	bool nomap;
 	u64 b, s;
 
+	*should_record_failed_node = false;
+
 	prop = of_flat_dt_get_addr_size_prop(node, "reg", &len);
 	if (!prop || !len)
 		return -ENOENT;
@@ -167,14 +194,20 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
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
+		*should_record_failed_node = true;
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
 
@@ -306,10 +339,14 @@ void __init fdt_scan_reserved_mem_late(void)
 		base = b;
 		size = s;
 
-		if (size) {
-			uname = fdt_get_name(fdt, child, NULL);
-			fdt_init_reserved_mem_node(child, uname, base, size);
-		}
+		if (!size)
+			continue;
+
+		if (reserved_mem_node_reserve_failed(child))
+			continue;
+
+		uname = fdt_get_name(fdt, child, NULL);
+		fdt_init_reserved_mem_node(child, uname, base, size);
 	}
 
 	/* check for overlapping reserved regions */
@@ -349,6 +386,7 @@ int __init fdt_scan_reserved_mem(void)
 
 	fdt_for_each_subnode(child, fdt, node) {
 		const char *uname;
+		bool should_record_failed_node;
 		int err;
 
 		if (!of_fdt_device_is_available(fdt, child))
@@ -356,9 +394,14 @@ int __init fdt_scan_reserved_mem(void)
 
 		uname = fdt_get_name(fdt, child, NULL);
 
-		err = __reserved_mem_reserve_reg(child, uname);
+		err = __reserved_mem_reserve_reg(child, uname,
+						 &should_record_failed_node);
 		if (!err)
 			count++;
+		else if (should_record_failed_node &&
+			 !record_reserve_failed_node(child, uname))
+			/* Keep a slot for the untracked node's late initialization. */
+			count++;
 
 		/*
 		 * Save the nodes for the dynamically-placed regions
-- 
2.43.0


