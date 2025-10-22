Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A1DCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714B08E0013; Wed, 22 Oct 2025 07:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC3B8E0002; Wed, 22 Oct 2025 07:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6290D8E0013; Wed, 22 Oct 2025 07:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 528A08E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:34:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 083BCC03E9
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:34:30 +0000 (UTC)
X-FDA: 84025542300.02.7419247
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id F05114000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:34:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761132868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MC8gYDqs6l37PolYcxfLHZL87pjehypAe4Q6idyANrg=;
	b=NTn2LzB94Nh+bSC0n2QZ5yYIG0Lao75PPn4VXvDdJj0sjghhoZMzYKhXUg2DXnM3cLzOdn
	Oyn1SCq43ifRAktdl6XhXw+glnyVbyj37JmFzNL8h6eRysi9CAMNILTDQsLJKMbYcOqGcc
	Th52VknZVI2r7xq/6EUXkVraeNIrps0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761132868; a=rsa-sha256;
	cv=none;
	b=FwVXfXT4xlaO1HBdDXPsn0IGuwUn7uAh3cTIEUzpzw0FHrwRslBFz6TkAkcuPT+TeIqtp+
	iHybfjRL2esxTggMOVdQOF+eRa22YC9B6IaQ51i0FHzGODZBhlx9lkPCOonb2PO6o9aNgk
	FWVYJosVVs3m83cJrP+xzdHRCQl2Gck=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cs6V26HnHz6K6Xw;
	Wed, 22 Oct 2025 19:32:58 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 18B30140257;
	Wed, 22 Oct 2025 19:34:23 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 12:34:21 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v4 1/6] memregion: Drop unused IORES_DESC_* parameter from cpu_cache_invalidate_memregion()
Date: Wed, 22 Oct 2025 12:33:44 +0100
Message-ID: <20251022113349.1711388-2-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F05114000F
X-Stat-Signature: ret89yb8t45mds8j86kd913ipg1hmr91
X-Rspam-User: 
X-HE-Tag: 1761132867-254643
X-HE-Meta: U2FsdGVkX18Ocj2C9K4IY39/V12G9zVRAUUj/Bf4qNCOHqif1gtbGS3m3zewZ2u+T6+2vVbV7zh+7EWBm8L5lQZkeVhfyS0jzO8wJmtRvk68WMxOIxSAY1iWfraDwRL2IBbWsP1Ioymgbqz6dP8Zj7vWSEFYSmJH/UozoYZSUoKMU0sGD/n08K64WaUYWX9NeJ5/MMPYwaYZItdw1yS6o7V2odwWpE/0eP74pVogEZniCBD2GvfcT5VYLkZyapxUZJfe6qtMzjvqMsRBr8TKm/DHMrw92EzWgcv1EzGgi+6XRqMbAOmN1sY83NyRUzHRLlFpQNHwWopwUxmLM7+0TeiEjEEBypoooZMhPymUx80PMr5zx8Fyw+Be5PvTAM+czgUvP7GEIe3qlmlqDNpLOHxsNzsoc5rRKExOS09nurZzBWhJUcMe6Ee40opyvrZL2N2SZArGgsY8RaGM2+hvsaV0bAJ6UEAQKTbnFFhB+Hm7YFerl2REiVgx0snKGfVSuVrt4lZ+cyG+nKtKmDYR0MV9OSLhTZY/svinB7MecepOcAfOVNO9aLBRG6nfydz9A9xr78wZxBirMQY8HoTCvhDcGWsWPQ4K3F8fSM58C9e1Q1uOKmKVU5RwJdrshB9Q+zR5goHeTernpo0Pq2ZHvvMc2uDo9UzrPTDOMz/phkWNbZZpSpn0/E2nfxKEdC8QJ+l5CfrsKZMOcg0wh9+n0Lx4PMzCmyNqb52Um6NLgL6YQ6SFO1cYuKhEL1vJenllDbTDT28KH0X1ZjaLZKF02xO5Jda1kSwdVtpn1yl7cgsdJgIVW2lSIqDhUqjn4fANwMgOMj1YQn+jQttzq950iaEWCQEdIqgTboqv348O74HUhpjwa6nqs6fkVoU7cQSSPy38ac6xagCYH/11XbL8jKXFHFJA6AlE9hK/PFSms1eSji1cDAKw0QCpdXp2U7V55cZM9YzLt5svE28fqDu
 FMuspSSw
 7zhkJ2GaNPcdRR3nPbWF0xIxXpgYcoJ+zDfTllVjWZqy29zSJu1hUAqn+ObLjxyL4s+wZ/DhTJvfe0voVtar/ByGSZCmvdrxoc51liU9XeiiCdhLv1LOw2/nj/ZF7Vs4b+Vr7miNTrUrPc0rsEXe4v4e5415GS4sVbjl8IYsufIdb9EP9AvNbb0/3lzsJ9tBJRneGduzMVEvjCdTVRcHOmJoSksgvf7d0dWAOqY1CMZHYN8f4P3f9cRk1sFylJDNtB6h85qDkVRandxB+ekOZIgaGAQ==
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


