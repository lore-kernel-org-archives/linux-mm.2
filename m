Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16ADCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4348E012E; Fri, 31 Oct 2025 07:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154DF8E0042; Fri, 31 Oct 2025 07:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C6E8E012E; Fri, 31 Oct 2025 07:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCD4C8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:17:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9851A14047B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:17:51 +0000 (UTC)
X-FDA: 84058159542.10.E3655FF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9280E1C0011
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:17:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761909469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uqwy5Gj2kNpsSnSSKXpIG3TVY9FHe3IIzyhUgcKYRps=;
	b=5Tx/8qceHbMfg72S2jk6arLGHzBc/ypV00MhS4YTyEshabpM0sfUQ+Ios0GiyKXOhVaqM9
	HiUA6RiLEpFT1zIDWG02C+FvQEKRVknVNKZZhRPGgE72L2+yBUyS5wuIuakaIgLAAIMkhA
	3zYD3JB602u5bOvgTxKBzHf8wCEl6wE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761909469; a=rsa-sha256;
	cv=none;
	b=Pg/6E00xaWYjTXcmHZ6owtvlhqOnF6c6OiAL6Q38y4pI9/LgprAYuQA1JuHbYZmgSDxapC
	NsRV8aArhEYZR7+xLjLSm56S9+8hAgUScm7CRZv/t+nB5MmVkUZGTQ1/nu2f88+ViBhJ4s
	j3jNxCzqe/LApJ0iEmJOOf5RpspNXWA=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4cydjD0vJMzHnGcp;
	Fri, 31 Oct 2025 11:16:48 +0000 (UTC)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 6EE621402E9;
	Fri, 31 Oct 2025 19:17:44 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Oct 2025 11:17:42 +0000
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
Subject: [PATCH v5 1/6] memregion: Drop unused IORES_DESC_* parameter from cpu_cache_invalidate_memregion()
Date: Fri, 31 Oct 2025 11:17:04 +0000
Message-ID: <20251031111709.1783347-2-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9280E1C0011
X-Stat-Signature: e1j1jrgdxebz6oaf57bc6fspdgzu717d
X-Rspam-User: 
X-HE-Tag: 1761909469-977069
X-HE-Meta: U2FsdGVkX1/g7Wb+G1tSUyk7P5SuYc6gIaoE5DtWaw1ijkVTdoQl5du5bDAk5Jbfp8t63J2FtMFQaC1GvMBb8xmTqspKMAO3NDZa6J8YcHeaD2I5UNd3weLSXuaO51UijCo5ym6tAQiMTzuereh+xVDqx71yueYyJcVn/KSflIh5gOXKcRAAhxYGo264lPrQGOyCADGoaAfVBrVcxKCCTpY50RtgwNx5fRE52yYCljJZgjeulTwoEEeKAYcwH7QWPlg1Z2extPqKUurF7H0lgIIuCk+WiGXk1RqTu4+BK2cbbmFn2j+0TSOeFyrW82sV2FdsbRcbmYIEsHHe5ThKnS8l9ITgDYT34XWaIoraiwbw52iO4+202irQDW2HCu/JRiyd8SDd5qJYBnJe6m162omuoESyEqlKCmaAOzRV4+9j7fpHa7Ahk3ApoF3UkfYbcF45hFarYUO7YJPYHke3jbjvIPN3IXUHgb2VZOJbsfhK9Egkx4kYrbzGcI7VN9W8nYm3xSIxCNj+KN03lIy1stABzI+ZeNGSGJhYMQeSFECmqufz6ELSt0lOh3WlufuHhbXG3QFJW9bL5RWDjZ0RYcyBccCQZIVnyCiZuD7oDqQa0AYf8O/LJeg2Jw6SDqBH/8KY4lPZXkWLwcYTerBqa4I/j24SfSG3kSRiKfWHPvNzWOrVV7f9rkXdRDzf/JUMo3C20Du60JndaHsNYPLZiL+4u9gXA8LBXxYcE+W2jBYcUPSE1nYdduo5Mam+VFrGZllc9WT6lbj8NXc93PtOPzHM38e4zngvGgnqTxNIVg+q3F8vqt40u9vAkcdjbv3txgq00/fFCA0BYPdKBQDoBvPeo7aBjemDrUX2rGmQgqeSXvZTcImkNaYUhy+O4J4Rcn/WjeOxwmcG+m/Y0PkMla8PXf6hxPju4IipKpBUhr67LZqxmH7z6buwpvSqSLUUN0T6/eidYxfh8m9uvue
 /+CNjJOC
 29eyj9ogJuDAOD1nmBtfxZlhmjtczOcSn0a2XkWuhRIDm/UXSmGsoyP2DlXfvkiZNTg9h0wfk3Pn7X25MjngeRSP/ztTK89grwozMH9LeV8MucT/cMY5NaXi4dTKOikKfpQCQLgxoMwX/jBhcLm/0RkgX+AOeBT9GdxWkuSF45Msh7K/48LlE7oUnOq3an572R7K+7kgqfJbZEtjtc/f+XgErSMq5k3ISIwJB5H8mf/VuK5MvM9lT/EzivyvQml8mzBQKiR2CRVYgpTd/aeYT4SCeiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The res_desc parameter was originally introduced for documentation purposes
and with the idea that with HDM-DB CXL invalidation could be triggered from
the device. That has not come to pass and the continued existence of the
option is confusing when we add a range in the following patch which might
not be a strict subset of the res_desc. So avoid that confusion by dropping
the parameter.

Link: https://lore.kernel.org/linux-mm/686eedb25ed02_24471002e@dwillia2-xfh.jf.intel.com.notmuch/
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
v5: No change.
v4: Dan's tag (thanks!)
V3: New patch.
    As Dan calls out in the linked mail, an alternative might be to lookup
    the ranges and enforce the descriptor but his expressed preference
    was for dropping the parameter.
---
 arch/x86/mm/pat/set_memory.c | 2 +-
 drivers/cxl/core/region.c    | 2 +-
 drivers/nvdimm/region.c      | 2 +-
 drivers/nvdimm/region_devs.c | 2 +-
 include/linux/memregion.h    | 7 +++----
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d2d54b8c4dbb..0cfee2544ad4 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -368,7 +368,7 @@ bool cpu_cache_has_invalidate_memregion(void)
 }
 EXPORT_SYMBOL_NS_GPL(cpu_cache_has_invalidate_memregion, "DEVMEM");
 
-int cpu_cache_invalidate_memregion(int res_desc)
+int cpu_cache_invalidate_memregion(void)
 {
 	if (WARN_ON_ONCE(!cpu_cache_has_invalidate_memregion()))
 		return -ENXIO;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e14c1d305b22..36489cb086f3 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -236,7 +236,7 @@ static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
 		return -ENXIO;
 	}
 
-	cpu_cache_invalidate_memregion(IORES_DESC_CXL);
+	cpu_cache_invalidate_memregion();
 	return 0;
 }
 
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index cd9b52040d7b..47e263ecedf7 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -110,7 +110,7 @@ static void nd_region_remove(struct device *dev)
 	 * here is ok.
 	 */
 	if (cpu_cache_has_invalidate_memregion())
-		cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+		cpu_cache_invalidate_memregion();
 }
 
 static int child_notify(struct device *dev, void *data)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index a5ceaf5db595..c375b11aea6d 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -90,7 +90,7 @@ static int nd_region_invalidate_memregion(struct nd_region *nd_region)
 		}
 	}
 
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	cpu_cache_invalidate_memregion();
 out:
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
diff --git a/include/linux/memregion.h b/include/linux/memregion.h
index c01321467789..945646bde825 100644
--- a/include/linux/memregion.h
+++ b/include/linux/memregion.h
@@ -26,8 +26,7 @@ static inline void memregion_free(int id)
 
 /**
  * cpu_cache_invalidate_memregion - drop any CPU cached data for
- *     memregions described by @res_desc
- * @res_desc: one of the IORES_DESC_* types
+ *     memregion
  *
  * Perform cache maintenance after a memory event / operation that
  * changes the contents of physical memory in a cache-incoherent manner.
@@ -46,7 +45,7 @@ static inline void memregion_free(int id)
  * the cache maintenance.
  */
 #ifdef CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
-int cpu_cache_invalidate_memregion(int res_desc);
+int cpu_cache_invalidate_memregion(void);
 bool cpu_cache_has_invalidate_memregion(void);
 #else
 static inline bool cpu_cache_has_invalidate_memregion(void)
@@ -54,7 +53,7 @@ static inline bool cpu_cache_has_invalidate_memregion(void)
 	return false;
 }
 
-static inline int cpu_cache_invalidate_memregion(int res_desc)
+static inline int cpu_cache_invalidate_memregion(void)
 {
 	WARN_ON_ONCE("CPU cache invalidation required");
 	return -ENXIO;
-- 
2.48.1


