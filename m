Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319ADCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA0B8E000A; Mon, 17 Nov 2025 05:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1928E0002; Mon, 17 Nov 2025 05:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE3B8E000A; Mon, 17 Nov 2025 05:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE0C8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:48:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 280131A0CA5
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:48:38 +0000 (UTC)
X-FDA: 84119775516.10.2D4C390
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2DE0F120005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:48:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763376516; a=rsa-sha256;
	cv=none;
	b=8iIoKB0KxR8H186z3dMY+bYb6nonEHhfw+YJjLTWU/IOToSksCxku7t6UkInZjZhlUAN1+
	ETs5/8Hz9ondFzEVNAm0IipwnbhRJyYi1PHhKUysjlzP1sXkaiI1NWA6zBX0erBxjclWsx
	iSJccmcN9h61J4dE34xioi7qDxQCdNI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763376516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxNzN0ZapQ1Gh00oodcdyvsRLgrNv9RugztmUS5jUxg=;
	b=aFh9nfYowRrbsDVoOLiVI/Gt2ccPB81rmowa7kZy0d/nAhU5WdAn/dEAkZHSaqlQmGYWTS
	NgfC61QiUCVVlVLt4Qz0wuXnwcadd84bV7sshkFytn0+gtc+W4ubH7iWPeSgrs4X5mJIR3
	sSKQOMrqNknYr5BC67avavioA2K9umw=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d94GF3pJgzHnHDn;
	Mon, 17 Nov 2025 18:48:05 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3677B140159;
	Mon, 17 Nov 2025 18:48:34 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Nov 2025 10:48:32 +0000
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
Subject: [PATCH v6 1/7] memregion: Drop unused IORES_DESC_* parameter from cpu_cache_invalidate_memregion()
Date: Mon, 17 Nov 2025 10:47:54 +0000
Message-ID: <20251117104800.2041329-2-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2DE0F120005
X-Stat-Signature: it9t36z3iq3ua3uf7jr1mz6qtp8bdw35
X-HE-Tag: 1763376515-227274
X-HE-Meta: U2FsdGVkX1+vZ5TsqIvADi1GsZOHcC9AGgGa1rBKQNPzkLb7YQIK+VLgDbScAE0So4FBtrMWM6dLOP3G2b6jC1lPjtBfTSu04sShvVxZRBV0rcI7GlIofKQWLhuoXQdIf7/pyh2KsWw4lpJphc6wPqJYz57+C+12s/yHbbuITBv6pXPCU9fg49FXssgtY8nSBZrSqFCZ6c5hQG+jp/UmUE7LpGA7egTNogc2FfNZ6QaIOO3k0WMv1BPGMCG1mFgr3/1uzUNMWtdkrsYLcwKe86DPQ0+veV/ntGDAbCmIxEm5aK25/POcoeA83CGNzAvMJ7iJO0fZsPjJS9InwC66p8dUJLlmSTKqA7woV8R83zUxWc77Mze0xJlaDfMsvX2PYaTdqGsYSyldCxMKPOYen/uqiRm0NURfY2kV0ovetXXxAhhmqf5Ouvc4WPhVBmRyMS9ncLtNXv+yW1Fzxy/La8k/+WFgb0U5hzAP9F3SvuWTwRUHF0XasdFxb9soQJDY3udeU5NA6TOCy8/e+H+yP/F3KYjGNrWD+tN0lD7alfR1eEMqO6XEqM+kiloyy6PC7NH+2gmYErY3gAdGIkSiJclso7SBzOwvyUjWNbHH+SDnsVUdrxU6xtfdM7oBiVmK4RyKxEbebyZVtD2Ca0uzMpfStCRsuyxyp/VPXIhsdyfuKRAN4Cxp1GQqhqGEkHpED7ykj8DVdg5pAZ6M1XKaEYF0nRqo1lOADXstJpeOvo57SK7N4uT88DUGTHUCBpAjJP2mFgJNzHeSvu5o4p+GdxVHU1liwnQgO1N/5BuEs72pav0GXnt0+fB6LxKLOhvHDmi1KC3+SNVhHjzm226LAvgFLyjs0k8YOuKy1WtHytT+8ygyGQcc71yjgULqpUNm7TFnd6IVc7bkcfJApQmfyKVMqe6ll2PFIkxDcd68QNqvw3JDONynJkueS09SSJw1FTBt7E1fpRmb4LkPnCb
 fr7RvcIZ
 KVwZTvuEeRO1VeCVxSnq9qcmft0WWmoGGANyoFnyBSfcLlF7aiFZebhjRu6T9oFhXTaXi3xOOwnXWWPFpvgwDEuJLvgVQ/veX37Pmuh3evmdQgXkptx6FHTRXFwZK6JXhHOoYXEgHWnb3olKkd5sZTx7dibC6bIG3l1S1fgVDlzzeFsKvZcN6GddPPRXvlo+ts0KxHUjDo0Fx4vcasFImPft8tLo8qxSqy8TbzXZhbX4JuQnq0PNV84kvh1m1WstiNGan0BBIRKEMS6Mf3pQMGitrPw==
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
v6: No change.
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


