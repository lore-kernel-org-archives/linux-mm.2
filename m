Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AF1CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911AE8E001F; Mon, 17 Nov 2025 05:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9698E0002; Mon, 17 Nov 2025 05:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FEF48E001F; Mon, 17 Nov 2025 05:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6717B8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:49:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 234845D46C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:49:12 +0000 (UTC)
X-FDA: 84119776944.04.14B3DA0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 22D2B1C0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:49:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763376550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5m2JTGutddZPS59MX0GXC05NXARwpl5STY5NEfdxd+8=;
	b=LCEoLXd7RdOpkMJzpicZ9r4Yfo0Xgdix8EdDUTkw3wm2czq/SM3HlzrhL0wZx+/BoYOTuP
	S8sm1iwpRm9Si4V13juZ449cahwF07zpeYOa6BH6KUR530HxiS3bcUuLwV3CV0oWAlWxPG
	F7/rJj7fMk/pgZxPTruNvogRGUEtKRs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763376550; a=rsa-sha256;
	cv=none;
	b=jpgxX9Twf9d2OW7V0KZHSNv/bEDBTSQp7LZ6bpBv4Wi1juwUIOrgd86jTfvkJ09MJASC2R
	OvWjpeKXyqUkd4Mj9qgZ/XjsELeYVyEm9KLvA3JSbj/EhkCwx1wGaTfr0/ZkriSn+2/qYR
	zyz8RhocFRuqRr02jiWLXk8HSDMHSKY=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d94Gd1S7BzJ46tC;
	Mon, 17 Nov 2025 18:48:25 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A6B1D14038F;
	Mon, 17 Nov 2025 18:49:05 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Nov 2025 10:49:04 +0000
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
Subject: [PATCH v6 2/7] memregion: Support fine grained invalidate by cpu_cache_invalidate_memregion()
Date: Mon, 17 Nov 2025 10:47:55 +0000
Message-ID: <20251117104800.2041329-3-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 22D2B1C0007
X-Stat-Signature: hn1o3jgtyjdnrqhgi5mdo3mt9q658tn1
X-Rspam-User: 
X-HE-Tag: 1763376549-145361
X-HE-Meta: U2FsdGVkX1+GYmNGlByZu6S8Mnf1cJhIUpQFXIMKVwZEsB6mSCuL1GldPVgDpBY/K03DEEZzZap9puqYpBWG/oMR4JpOnRLIe/Jq+EIRGYt7R+im+vx3ltWuMXl2mysXKgODPOkAD2k0QuK26PsLxWwl+tPUmfGQrxjnUIkDDBix1PCgf5/NyUcO0ngS26s23E7KuTYe95IYX9p2Q3WuPt0Pk8Gria4dU9ZPqiN6dtXcHFZkD56yJjHwOYBjUHNmCzPvh59VXArSSY5xSAUNc+d6tVeVpO9EXlZqyrYHWymQzxZop7hEZk8xPVeVsGd5VnxYC0nZmT6jdPg2f33g03fIZVayoZ1pyCJgcH/7BLb8AtVxoAAMCQnJDqDW8AlL9EcJ2riqZuNTv+wDmYhMZIk6fBREje+HQBwrMizGHmvoYKA7Nj0/A4nzns9XX/dPOp1c0XkJSXylacJa88R0tKzw7E2VESuFELCpQLc7Dow7PZrvFqaB2OvVOZW3qEqZqdPASmWKUlY1d8fH1GucerJh0NsNDy/W4DHRPgsUmbgUUBIJtviHQP6TO+kzI+1eaMeiHVchhNqIX203hGDb0TYNsfsMyzlq/P8sia181zFD0Niyge16Ak6+TzEYr0qvszN30mkt5FV2ywC8cXVIRD4egtVTlSR9ywsqzvLv2OgQF1eiuEnhy8GhWGNQE3ttvmSWYU74AXJwqXu8SCeRf8sX4b65fxc3qkK/tqCtKiZu088z10x3YLUIcK5Wugj2rHrN9AD5VP8LpIiw8P5pngWVQCeHHZORjrAyAchXOaSr/iPkCUToyQ8eKlGajyVwoPn7P5sObA9Ykw1jOKlXZAIioTKKMCbCEC1jNR3AXgcuJscWCgMEgOwSX4yLWeUevCqKyr8oSWCRzSKhc94PLDiLgmxJ42Pvy3bTn1dFbyMvpSep2DddcL+25yLPvK2TDfAhzE8IPpdgcr3j5RF
 yY8Gs4mH
 6Ed9TfgYhZLhRGKg+wB62+6nVpJULPgfb9tRhgv5xVp9BchVuUl2PpejuXIF4LYAkiy3+yfbFofHE/EscDvbh2CgnaiqyJ3OTiXu2rPo6NjSxAqdFEaYP8lluoYTHG0uE1V6PMKAB6r+97L3KJM3KbbeCSomycDNjQI3WbsFtlTmuFgLETolyv2Ssb2x1WM1XjIGkZMxLrsR4f9SobauHczTIo4i1wTvoIxeYCKdkEoz6gUpzK20WWaP5Mu0YT7X6HR71C03CPrXxByWzioGgVBPRvjlwNoQjU3vytMWgI3S9M3ayXYK5K3/tXbZe7aOmscMSawxL7esN0j33CUlRUV34ZlvceN+HLNVQfIkdui2iBVm2LEsbU3+YdQ==
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
v6: No change
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


