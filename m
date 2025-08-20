Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EF5CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B156B0011; Wed, 20 Aug 2025 06:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C666B0024; Wed, 20 Aug 2025 06:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00AED8E0050; Wed, 20 Aug 2025 06:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF90E8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:30:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E374C04A8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:30:28 +0000 (UTC)
X-FDA: 83796766536.08.A44C7DA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id AA041180003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:30:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755685826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IpyiTcZVQlMk1owwyFHbpGPPLfN8oJiU1QbrSEp//Ak=;
	b=to2BBkZFReZED5BWGp5zlhuFvY8CrJBX9qW7UA4Eo8GwMjgbc7pmC28JDQ1VIxHAj9cUvp
	UC8hQDGgoE6dlGWRIMJ5YiOtwmblBAK1F67B5Vshpxe9vQ662/qVGGlWs9JDvpYpTERF/r
	6nMXGyLVOpXyo7wJx5JxXfBCmNsK+aA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755685826; a=rsa-sha256;
	cv=none;
	b=gJHEdz3NWaPdB6/UNELHKW83UYfWqKtXfg+Pt0GOn+yRR4Hw0ZgUf8VER/r9F1Rhawn4yg
	uIOpY7IH2CAEbaxcqbJrVaGJljUFaUXWEjIqm4b37zz/mFWZZxqYc/9XrM+ALGATGwagnA
	fyhu91tnPI196VcZzl5Jk352v4mG+MU=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6N2S16GWz6M4q0;
	Wed, 20 Aug 2025 18:28:16 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 858AF1402F4;
	Wed, 20 Aug 2025 18:30:23 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Aug 2025 12:30:22 +0200
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, <james.morse@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Will Deacon <will@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
CC: Yicong Yang <yangyicong@huawei.com>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>
Subject: [PATCH v3 1/8] memregion: Drop unused IORES_DESC_* parameter from cpu_cache_invalidate_memregion()
Date: Wed, 20 Aug 2025 11:29:43 +0100
Message-ID: <20250820102950.175065-2-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA041180003
X-Stat-Signature: f1x4zaxr8iwrktb5e38x695mzc95tjjz
X-Rspam-User: 
X-HE-Tag: 1755685825-366534
X-HE-Meta: U2FsdGVkX1+ua6IkU6z14H4CGScjdcJccdx7q912My7O54uzbcVOvS4HvxXJ9uBePAAfJpYZsC/uwQKzLxF+hA1nik+VH0NWrfFUDl5catjbHn0879zMoQKYioaItbWgHXgA5EW1l61YAnziBgHNgTMVrQNVAD7AL5xzWg5iP1E1GZdjuBgdrAFAXC94pQN/c6N0OPfkDMUAir73cZiuBU6ulDclgJ2Hme+BZc0NwmpQ2ewrfKFkHHQQF5D38Z2BfEdjsEpi35uC7GMB43uJQL7QC4e3RKXGJxFHv+Qh5YLGZ+0+vI3u0xBFPunkwwnkO/nX60uBBVHNyDo9PN+VU+ycpMuzBi57LTosgMxiuocjqJLy1ZEYknxTVndDUaIE42okB43Z0FZsuPlaK3EaNxmJCmV8hxETNrkc/8+/e05IPajKt0O+7+JZLK6NLxOnVvp4+jnMgdeSIYyMeNsue3byPVPPxVSn6EgPL0toAPHbbbv3Jw/+tlPC0zlOx2Aw7XDrMOat/dOsW6QWLOLum9vchdnz5hbExIs3eQHEcEgTCwhPvjhZQV4rb+SPxRQrs/rZ+NwG7i43RNQlbwulPWCcNrJ+KlbbKI/HBqn7clErmNnMejyYCbsuqfbgiabDCRgRpJnzT0ubXTuR3CSos0XTb2zI0ZGHG0d4hAtmUmJxVsCfaSp8fkNNT8Ghj09nQgTtJxs/RW7Md5Blznzo1NFQzIGS7yXH9ornTCPDwjfg1XHleolZed+debMcUait0e69CRebWopDLuV4khn4fcX2QlbW/WllWKR73kr7dldg/mUSZ5xGRb8+B9HAo2e7bFMZpgAQpbeTCn2gAxcduV6QhARoI6kwzQfJbFzSD79L3dkHoJy+8P3PcAl6X8h85CoRAZbWm8L/pbSkfMhFPR2ydHyNIqscLxfELRehG+7MQPiayWExaIuODaTp3xBNqPWvscb8xGXiBei+upG
 NXKYPWP9
 8EdZxgC6bGTEsrC0VtZzAq02X9WwrGYEymNve4S4XFjAsDdqM+DPAVK5lPyUJf0U0LoFvyfzN5+diiKDRcx+3NbzZVu35Ppj/w9JUcV+e506ytPR9i97Y58zPVp6BWzotYhPALtsyY5ciSvh/r52v1TQtsvaSkl6opAY2WUFtKQu3XRHXMChNn54zn/cziFoRxbVHBHTgMTaTrBBZ4heU4vXwc/PCZuGccwpjaTkVlQbfB5cD0gAQuX73Ag==
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
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
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
index 8834c76f91c9..4019b17fb65e 100644
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
index 71cc42d05248..d7fa76810f82 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -228,7 +228,7 @@ static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
 		return -ENXIO;
 	}
 
-	cpu_cache_invalidate_memregion(IORES_DESC_CXL);
+	cpu_cache_invalidate_memregion();
 	return 0;
 }
 
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 88dc062af5f8..c43506448edf 100644
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
index de1ee5ebc851..3cdd93d40997 100644
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


