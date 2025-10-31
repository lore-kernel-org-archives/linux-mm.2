Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B5BCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0028E0159; Fri, 31 Oct 2025 07:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770248E0042; Fri, 31 Oct 2025 07:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638C08E0159; Fri, 31 Oct 2025 07:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3ED8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:18:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3CB613B061
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:18:19 +0000 (UTC)
X-FDA: 84058160718.10.6AC42B1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB82318000A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:18:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761909498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6nN8rc00CYhDUwygyVApWYMe10CihZ8Sm+6/32Xb140=;
	b=OqdgkgJWGoK4vNTvnsjnyao5AcobKjSlFHPzu6oVZiBvHyKN8fJEz1urnNaxjuGU61gnm/
	WNarUBZx0kNHyA9jkMcqQ2L7OR5T9LnRaNxM5UMUzwpaJdkdiProTuOk8wPp0pSJfX1HLl
	S3uM9QPpJceZrAUBawMNTSCSfMlQG0s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761909498; a=rsa-sha256;
	cv=none;
	b=r65NG5UEhWGs58Wne7YWnhLC5rmHf7jyaejFO8FILO1OvE6+AdhE6IpVnnLJolxx/3zv6n
	CJcBjCdtWbaQA8uQHh54Z/HsO+pKOXWRyOpwzN0iqiRic4h6NBVUqcD84pj8CANtmrp8pv
	Yxx6KU4IAdFiuNzQ9PlxBVSU9wPjjyo=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4cydjq6GGszHnH6S;
	Fri, 31 Oct 2025 11:17:19 +0000 (UTC)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 348B3140370;
	Fri, 31 Oct 2025 19:18:16 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Oct 2025 11:18:14 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Drew Fustini
	<fustini@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Alexandre
 Belloni <alexandre.belloni@bootlin.com>, Krzysztof Kozlowski
	<krzk@kernel.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v5 2/6] memregion: Support fine grained invalidate by cpu_cache_invalidate_memregion()
Date: Fri, 31 Oct 2025 11:17:05 +0000
Message-ID: <20251031111709.1783347-3-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: a8kbzmj378za56fnc61dnqtjadgdqatr
X-Rspamd-Queue-Id: BB82318000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761909497-125778
X-HE-Meta: U2FsdGVkX18Sco2p7UAqlEzymdOFG08V8MQgZkc3HtSJ1JsDABvgTKBCtxkdtbNu2SB1dY2KHWA/8eo0eLZKS0seRI1FayNtl38bz97f2tnI6E1yUksyaonyJs1ze6SNjBGQS63B86E+wZJ+PiPjctori4PDn9TS/XeoKREjWuAfd1U05h9jkwZKKZiU8PRTJGeoHvbKhWZnCg4btGSMlCbejddkFgMhF9MRDC6mmWR7qij0wPZbbjJXjrSuX0VsQf4yTtdFdhP4EwgkaHyuRnHDY6hif/DWX1HqdwV7rhau4T1nQBANEDzpf1eMJrdxvHsLDExMO6h6V53pj5yb8jRWeRX8KLDqihWroDOZznuLi/lf8OCOczeOEzrxVheYimG2qKJx5+XVmcyFDZspP6IxOGzuHKSGfbBfERsBvnOTvxdYTWVWYC/tBOnwke6Dmm7IWGsct7mj1ZcIC5vOiC/8oRlR0f5i7QxrG9TMl08sUF2MDd+jSJvL06wt07M9i8/OGF3uAi94/WqiKGUu1ts7gEsb1UHxI0KebdssIvp9AlUSUaZKXnQ7OmklmNAHJwWw41g0+QIKmMNpWGwwt7HJnzLlqKwPGfON1TILXiydCm5UDTyUFjn1fzxWw9E4bBBBZF0q9adbgpTzhNAI7DX7kzNH2PuaIsfsMzjwikAdm4Qyny8t9Te5nl9teQTOJ+thjoJA9YvUnU7bNeCazPxRr7imH3/C3nLn6+31MheOYX+vBPKCXlzNnUbddHXThK0DDcVUXWze0xConbNFEBtXUP/4ImNStwuoOzu9VCAYpJWRX29w5aJhf00qaCXNpVKoPaQ0NuohXteoWTxhk7H/Erhgc4TXLAeaPaxv0equBAFWmV3HTFXbPhA1o8V1Fs94+8p2Scux0/ggT8N259pESY1WIvksfDJc0Um0c//R/R48jcbSEPkLzbIc4rg1sa7sOgEqJuSLc/CMrYL
 z4poDLw9
 qz1W2L/OW+IOYYk8k8HBr71d0VAzeJxSrY0Z/SeBAlU1xS4BEhpqCy9r/gmc9r8l1RJ38uP46ml9Z8J7ssTR/D4kEpL/c0xwa2sQPdW8dnDdOJkzXm8H5ap3V0ZZR/nxV+oJLfUEr5HgaaSzlmmHRZbJbu9md4oOx8y6xueEjLJ2Qg74e8D6BFrGuiqQEZZ9FnAr9p2mT1znIhF5OcKflGvoaxKBWvRS8cucRjl3xEb8JajJeEe9Gnl2cPL/Xr9VDLgUQv+GWPa6hrdjwwy/TcMKk5mcCMdLMP2cmXzZiVY1D19bMkCrAMLESzn8xmRzNNchYP/pjwAH32JI8JXvxO9/LZLT23AlhITPEVMKfM9RS5PvoyuTEqjIPEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yicong Yang <yangyicong@hisilicon.com>

Extend cpu_cache_invalidate_memregion() to support invalidating a
particular range of memory by introducing start and length parameters.
Control of types of invalidation is left for when use cases turn up. For
now everything is Clean and Invalidate.

Where the range is unknown, use the provided cpu_cache_invalidate_all()
helper to act as documentation of intent in a fashion that is clearer than
passing (0, -1) to cpu_cache_invalidate_memregion().

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
v5: Tiny tweaks to patch description for readability.
v4: Add cpu_cache_invalidate_all() helper for the (0, -1) case that
    applies when we don't have the invalidate range so just want to
    invalidate all caches. - (Thanks to Dan Williams for this suggestion).
v3: Rebase on top of previous patch that removed the IO_RESDESC_*
    parameter.
---
 arch/x86/mm/pat/set_memory.c |  2 +-
 drivers/cxl/core/region.c    |  5 ++++-
 drivers/nvdimm/region.c      |  2 +-
 drivers/nvdimm/region_devs.c |  2 +-
 include/linux/memregion.h    | 13 +++++++++++--
 5 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 0cfee2544ad4..05e7704f0128 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -368,7 +368,7 @@ bool cpu_cache_has_invalidate_memregion(void)
 }
 EXPORT_SYMBOL_NS_GPL(cpu_cache_has_invalidate_memregion, "DEVMEM");
 
-int cpu_cache_invalidate_memregion(void)
+int cpu_cache_invalidate_memregion(phys_addr_t start, size_t len)
 {
 	if (WARN_ON_ONCE(!cpu_cache_has_invalidate_memregion()))
 		return -ENXIO;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 36489cb086f3..7d0f6f07352f 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -236,7 +236,10 @@ static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
 		return -ENXIO;
 	}
 
-	cpu_cache_invalidate_memregion();
+	if (!cxlr->params.res)
+		return -ENXIO;
+	cpu_cache_invalidate_memregion(cxlr->params.res->start,
+				       resource_size(cxlr->params.res));
 	return 0;
 }
 
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 47e263ecedf7..53567f3ed427 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -110,7 +110,7 @@ static void nd_region_remove(struct device *dev)
 	 * here is ok.
 	 */
 	if (cpu_cache_has_invalidate_memregion())
-		cpu_cache_invalidate_memregion();
+		cpu_cache_invalidate_all();
 }
 
 static int child_notify(struct device *dev, void *data)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index c375b11aea6d..1220530a23b6 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -90,7 +90,7 @@ static int nd_region_invalidate_memregion(struct nd_region *nd_region)
 		}
 	}
 
-	cpu_cache_invalidate_memregion();
+	cpu_cache_invalidate_all();
 out:
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
diff --git a/include/linux/memregion.h b/include/linux/memregion.h
index 945646bde825..a55f62cc5266 100644
--- a/include/linux/memregion.h
+++ b/include/linux/memregion.h
@@ -27,6 +27,9 @@ static inline void memregion_free(int id)
 /**
  * cpu_cache_invalidate_memregion - drop any CPU cached data for
  *     memregion
+ * @start: start physical address of the target memory region.
+ * @len: length of the target memory region. -1 for all the regions of
+ *       the target type.
  *
  * Perform cache maintenance after a memory event / operation that
  * changes the contents of physical memory in a cache-incoherent manner.
@@ -45,7 +48,7 @@ static inline void memregion_free(int id)
  * the cache maintenance.
  */
 #ifdef CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
-int cpu_cache_invalidate_memregion(void);
+int cpu_cache_invalidate_memregion(phys_addr_t start, size_t len);
 bool cpu_cache_has_invalidate_memregion(void);
 #else
 static inline bool cpu_cache_has_invalidate_memregion(void)
@@ -53,10 +56,16 @@ static inline bool cpu_cache_has_invalidate_memregion(void)
 	return false;
 }
 
-static inline int cpu_cache_invalidate_memregion(void)
+static inline int cpu_cache_invalidate_memregion(phys_addr_t start, size_t len)
 {
 	WARN_ON_ONCE("CPU cache invalidation required");
 	return -ENXIO;
 }
 #endif
+
+static inline int cpu_cache_invalidate_all(void)
+{
+	return cpu_cache_invalidate_memregion(0, -1);
+}
+
 #endif /* _MEMREGION_H_ */
-- 
2.48.1


