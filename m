Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6345ECCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6BD8E0014; Wed, 22 Oct 2025 07:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDFD8E0002; Wed, 22 Oct 2025 07:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B008E0014; Wed, 22 Oct 2025 07:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A16C88E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:34:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4822A5B6EE
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:34:58 +0000 (UTC)
X-FDA: 84025543476.18.F2C4AF4
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F617120002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:34:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761132896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FXlrzBCMamjHmGtmAEIZStsfrt12b8LW2N5iogEp644=;
	b=iFjsvY2qGK6zirvnBY7vH4zmv79KJkQzxndBI0RyJ1VLhT3tcV2+5GgyUDMEx71nCvpxup
	cSu8jiG/GZnPVNoCXZ42DzjDVgpjq4Pp76oYOungheAZjMH55URXLkm77DtovyfmKXfhEu
	mSJdjoFuuwtkn+FA0HMsT0c84dxWEZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761132896; a=rsa-sha256;
	cv=none;
	b=Y9ctl3o/5Sc9gc/NQqIp7m1jL/t7yW6Osw8aki7Im91TOGcW3fC06cff9AezobOn9+7BTx
	vkq7YN0KTezonJ4ee/NsefOJ3FSpqY5UnM/ZNykSxjVt4rK95XZOyhGJFt/gGKyYTjc6wC
	LGwxc+HxDC+Tk5GUfjI4zq+zQmRHNyU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cs6Vf3z00z6K6kK;
	Wed, 22 Oct 2025 19:33:30 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id BD332140157;
	Wed, 22 Oct 2025 19:34:54 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 12:34:53 +0100
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
Subject: [PATCH v4 2/6] memregion: Support fine grained invalidate by cpu_cache_invalidate_memregion()
Date: Wed, 22 Oct 2025 12:33:45 +0100
Message-ID: <20251022113349.1711388-3-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam05
X-Stat-Signature: i668zgorp9tk3m4c5k1t89roow6ok8ph
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F617120002
X-HE-Tag: 1761132896-528765
X-HE-Meta: U2FsdGVkX199eNn75lg6IIdY+1Ezg0ZlOHccW4ebvUbUKR2Hk5nBgWQ9aTYBhvmDfx5mcSNg3T/nbN4byP83Ky35A4IoT5+jSGmOhXtkebZW4pQTDzUPG06khPFO1PzLgk8nw6pOPiUkoqapZmJFvod8IykryTg9uQgH1RLiYNNK+zUMwF3nIncrGL0TY81azUURNpah9qhOgNw4aQxDTdPZBao4UORNfr5GMQvGzuBWtPC5k5akkSN5ntRV3Urxh6uaKMdo3PYhCJsAAfZKqbq5tsmW+gj7gctN9Xb+9kTtJ49uCtSUEsC8/QvzrWk/GouKB0YPdOZky6YBrMsjyyBr8BHstsQBvUr0VXGLeDNCKD9/5v5TZWn/reivBamFT6XueQJzF+Gu0vm3xRM9ngIvwxrBDf85eHWeAX3//ZpQuQTVeyd52sohzzGop89JTZ0pQ6lI5vzXoNx1h+EyL62ZhLq+IA1a0PhK8ymDvbKtozpfYXSolrmVDi9XLFfDg2Hd2ByhQjRplwHIXZeQy69inwHsiFuXOOj5wsHcpyaPlG/gmSeUEm8laPdz0HHA4OS8mdWyhFJJAQA/oPIjEPmGkC3DXoC3cit6IDhxwHm19iaYTNltjYerfisBLN5H7R/N0H7ZgaOrRVJSDhLAZtcr57iCKgdkaJwosiHW69hbRjXjmrJEY29RlM5OhkV2OY0Mpjqg9v1NoVb6BADVR3WeVr9gJ5poxS1vWWopKFpMeLtIVdMt0T8CXBC+YpiFELJQjPuCugQSNn4jyfrhZ6UORPJnwNvEdxRqy1EkvODccjt0ZtFH6WRX8vQTEtMbxRn8cpVV7CWwHptcVZO9YWQT4009phmR2qEF5j75SQmRd7M5Pt+zwKTIaBjSl6q40wnFaQ76qqlsfH1kcUuBs4L2NB1YAT9G8aDLhiYN5B/91o3L40IGam1S9fcfMD+ZlYJg0TsOLh10oOyYVvV
 MjH566xR
 8jOrdNf/mK7kbYYi2e8AehBiupiD4YKdE18mdXuISnWl/aQZn54kUJ+sd9z44TxAlwimDgsqpUQANduVKZsIvNsk4oFddXVt0SrpSkrXXht6bhzMDn32jX0bYjVNuMJwCg0LB0l3WkRRxyE1hbetHdtmWnV9f8ckHizA7wDWDmZYbgr8V1O2GvOguhWOhzdMokmNtJifyrv71q784Rb6PTgOflAu5fSemUvUrztmFeYbm5nD+K7CXNpQ3WnSf7tbntojfvg5vjbr6dUfp1A4h+TIULEHC8mFqK95oxuTiSpvBGyYAi2a/aKEB8myHNVEdUEEmXrwDdt/S+prJrMrh6MZRcwUWKyxvJ7WJz28/S9ukQhNR5NmZzYP7Pg==
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

Where the range is unknown, use the provided cpu_cache_invalidate_all()
helper to act as documentation of intent that is clearer than passing
(0, -1) to cpu_cache_invalidate_memregion().

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
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


