Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E28ACA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C414F8E0050; Wed, 20 Aug 2025 06:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAE08E0003; Wed, 20 Aug 2025 06:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABAE08E0050; Wed, 20 Aug 2025 06:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9590C8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:30:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65984B992C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:30:58 +0000 (UTC)
X-FDA: 83796767796.03.8AD9C87
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 922EC100006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:30:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755685856; a=rsa-sha256;
	cv=none;
	b=FbrDhfwAMqicYZj2kFHTFId6XhgAHn3aY4wp1rGIwU2U3OtaaPoSMmT+Iz295QWcoiMUu+
	L6VvKZjLViF00u0zijMwi9EfswhwG3TS9ONRLpO/HTpLJmfNj8Sw5Xd4j06gbSJaFEr37V
	U6+v+oVjqzda2YxN/J4ykLulKV3yKa4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755685856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIMcFQUNBT/y4kaUGdf6TotNLXJDt4Sk2unZ7wGQjeg=;
	b=OY5D7fG6jw1EYkdXmvPmsrodORjVH1CX+aguBvzHbs2J39Rah1lMLMZI8PsvDEUcG0h189
	gsZP5EBNsTn7L4IlwvlrGcWSOS565Z1WoNTRLQuCTALMQmib6wqmsIjKMbHQLFwT4K7/hq
	BTRmiO6zxRQxF7Cyw1OSTeBXj76EYvo=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6N334QwLz6M4pc;
	Wed, 20 Aug 2025 18:28:47 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id EB362140119;
	Wed, 20 Aug 2025 18:30:54 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Aug 2025 12:30:54 +0200
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
Subject: [PATCH v3 2/8] memregion: Support fine grained invalidate by cpu_cache_invalidate_memregion()
Date: Wed, 20 Aug 2025 11:29:44 +0100
Message-ID: <20250820102950.175065-3-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 922EC100006
X-Stat-Signature: 17bjhh7wo936sf6xr6icificbiankntw
X-Rspam-User: 
X-HE-Tag: 1755685856-275273
X-HE-Meta: U2FsdGVkX18gN/7FwQ1dPYz1q455ibEx7gTD0nOvIITuV+W/obnZzkeaxGir7LNjo6gHS4/cWBvHM5LZQV/hD+tpAvfXmkLDFrQ8GI9xvB08qjQcTFZtj3yjZ/fCmk20ktseMnmEYighO9j2kZarZPJPGEDsphGbrv6QzPYb7xmS84QfsqQgkNf6MQHSNUMSTVCqR0GsgEog+jWJuSK3RDTPMWRrXQMKiS04bFhcB7R9lMrSbrfMBlxvaUYwIh/674OtHx+uNcmfKlluvWAQZxI3CLEpbBKS6fyOBhNAAfsG2Bf2XYAW+ZNljB6+TAwRIO1LoHtnrttxj0+Z241SsaKcdqQv0o/hxzlhXApOnBRnxS1NMXx6tQIqv+l7qvyfPb4utUcJFXfjkcgu/BVhpNPG9q0hekihOaG/xX6PS62N14R9X3BMDSH4Nwvrv3br4wEHbQB8nzVUtqPvrAYlR2jU1KhqwiGttKmkd5aJ1dTAr3PW0gO2IZABm443n0pSkhY+Yvd/V8A7t+MRB98JC6lclprmGVsxYdlycmEueh1OzNWA7vdf51w4lvUyOjINJFeWdzM5PaEpqxOwdMormdoV8fLf0OU4UwlokI+xqsCxxjTYD63p/cTYbCQ/2OXnUS/9HpPj8GEjFnTl0Z9QLJem6u13WMqEnqt855m6eq7wpufEiYQvCGVIUl/WpxPty0MbpNJY9HWTqS8aS4JQ0qvAz7efVMPsglYHKy4/KUiZPWrgkHyI4+nQ1Z4++SAAtScm75CRZWGdEyvN7U4NGqmGqZF0jo6xYDRh2iz3pDU64yNZk2bFijLAdmw/GLiQlRFIBs/YY+Qe7w+MW1m2pQot/BLbJALdStMqT58eJtYgO3eIaXoSXj3Yj12+ifyCSbI2HJnbADK/HOsJvAvlq+v2KcgsSLN8lFFVAcNMYaagtgNZN4j1Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yicong Yang <yangyicong@hisilicon.com>

Extend cpu_cache_invalidate_memregion() to support invalidate certain range
of memory by introducing start and length parameters. Control of types of
invalidation is left for when usecases turn up. For now everything is
Clean and Invalidate.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
v3: Rebase on top of previous patch that removed the IO_RESDESC_*
    parameter.
---
 arch/x86/mm/pat/set_memory.c | 2 +-
 drivers/cxl/core/region.c    | 5 ++++-
 drivers/nvdimm/region.c      | 2 +-
 drivers/nvdimm/region_devs.c | 2 +-
 include/linux/memregion.h    | 7 +++++--
 5 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 4019b17fb65e..292c7202faed 100644
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
index d7fa76810f82..410e41cef5d3 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -228,7 +228,10 @@ static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
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
index c43506448edf..62535d200402 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -110,7 +110,7 @@ static void nd_region_remove(struct device *dev)
 	 * here is ok.
 	 */
 	if (cpu_cache_has_invalidate_memregion())
-		cpu_cache_invalidate_memregion();
+		cpu_cache_invalidate_memregion(0, -1);
 }
 
 static int child_notify(struct device *dev, void *data)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 3cdd93d40997..7c1d27c75b73 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -90,7 +90,7 @@ static int nd_region_invalidate_memregion(struct nd_region *nd_region)
 		}
 	}
 
-	cpu_cache_invalidate_memregion();
+	cpu_cache_invalidate_memregion(0, -1);
 out:
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
diff --git a/include/linux/memregion.h b/include/linux/memregion.h
index 945646bde825..428635562302 100644
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
@@ -53,7 +56,7 @@ static inline bool cpu_cache_has_invalidate_memregion(void)
 	return false;
 }
 
-static inline int cpu_cache_invalidate_memregion(void)
+static inline int cpu_cache_invalidate_memregion(phys_addr_t start, size_t len)
 {
 	WARN_ON_ONCE("CPU cache invalidation required");
 	return -ENXIO;
-- 
2.48.1


