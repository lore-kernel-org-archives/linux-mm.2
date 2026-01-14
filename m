Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF7DD38FEB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0112B6B0092; Wed, 14 Jan 2026 11:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A706B0093; Wed, 14 Jan 2026 11:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75106B0095; Wed, 14 Jan 2026 11:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA1186B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:43:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FEB41BDDB
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:36 +0000 (UTC)
X-FDA: 84331140432.01.C5C2A8D
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id BAA6F4000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xik6Qm4d;
	spf=pass (imf12.hostedemail.com: domain of 3tcdnaQgKCDYkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3tcdnaQgKCDYkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409014; a=rsa-sha256;
	cv=none;
	b=biQ38QJLfVUQUV39soMH1r8gDTklNZ4XS6emC9BFQfBi2KcOMRUZ5bgdpGSFOa5KuLT/5x
	4UJiLKpI/f6uaP2E4m+UgYkbSylTJvnBnBZTGR1h9WzIRtkPgA44hb4k/qpUT8t+z8oVhu
	Zveeld+jugVkYv9X3VicnJP9FNAJJCM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xik6Qm4d;
	spf=pass (imf12.hostedemail.com: domain of 3tcdnaQgKCDYkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3tcdnaQgKCDYkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guvkPBegEDYZPDzaTTld5oNSHvfpDoo/mBDTxGLtjdA=;
	b=uOOOOn7zdAtv9CXctXRWlZECDYKvDgNBXz+xY7lPxx3RLCAcSw2QHvoz9DQmtwInlnAUTs
	dKHHeRhjN9gviDDbow8hrdcG+YAtOTG/gLEzk1bABuMPnJj2bWpA2JqOZ6WQGaQCwZ3YNZ
	Mzq29DOuVh+rP1vHhcWpv5iYayRP0Ac=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64c62f69defso10136492a12.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768409013; x=1769013813; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=guvkPBegEDYZPDzaTTld5oNSHvfpDoo/mBDTxGLtjdA=;
        b=xik6Qm4dC2Y0alYWkKPz9qXUjRWeVI0SRWW2AL6fHIqmvwoXBUa01rkWqeJ3jGTlHq
         dWIKNWRuZE5S5CD7Iq9CqSS74GB+JVfMkazNdhvnrLV7MwOEu1XAAU+Wk+UXk56HRKnm
         auRL963i6Uo00yRhWIBX9hNjBEGudIB/l3YLTuta5shpAlYRHp0Y8QmDCbvLe2NzFbUM
         DXXUPcDrMsByuv78Rzy7emthiyFIsKtZbTSBS5N3+SjN1DIVQbLBKQG7ePR+YkGIxxhB
         hxp51mI7RkTD2TuKLWQBwncATP33kae8hrlfo/zvz/4h1lNX17MInChJWDfVscbx6CUc
         /3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409013; x=1769013813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=guvkPBegEDYZPDzaTTld5oNSHvfpDoo/mBDTxGLtjdA=;
        b=cgedEWA4519+k1S4WUXcfLiAbKY/pzSNx50l1l+ihI62aU+g0GHhmls9ejAKtWvxbu
         xkB/uN+euFTxMDdfbnVQ3SWMfcXQVY5waaI94nrcwEKzr8voGPoM0XsJTCl4RGmzAHU3
         mEdJkaBaJTPJ06ulAH/h2iN8qPJ80DpF8oYZHjqDBAy5eilIclkqbK/dPUo79BTaf06C
         w7mXBss652H7Rbn6nNRsY97VxEeOipx1p1g+VA1/a/DOPtNNEhr1O0P9k0zdOvOgk72h
         K+ngonFhsnJzoFtzF9+pJ3Od2Wj/WaVKnirMiu6JMgdxujysH5WI62GvzxyLffq1jNrP
         LiHA==
X-Gm-Message-State: AOJu0YwrV3NBkQetr9XVEqRpSihqUFsBfK+8FJW9IkKRsjfSYJJQqnjY
	OE6fxINvzaZadif2E+ZxbBtBglU8TkVl5Tr9Vyb3Z7LLaaWQR24w4lZUz7rpxNopjPq7JThOoCV
	yZHcA+6rk7THwZ0u749/+n0i/Fh09onrNGKVVqw0SskhMqWLD5ICS8qlM/YhDiekuWjGqi6CnV2
	tfM4Pwp9TBsQswXd1PmoBJZ9ur4eUy8SVtiWtj4IfOdw==
X-Received: from edrl19.prod.google.com ([2002:aa7:c3d3:0:b0:64d:3026:fea6])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:26c8:b0:649:64d3:1554 with SMTP id 4fb4d7f45d1cf-653ec125e44mr2681693a12.15.1768409013075;
 Wed, 14 Jan 2026 08:43:33 -0800 (PST)
Date: Wed, 14 Jan 2026 16:43:20 +0000
In-Reply-To: <20260114164322.787125-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260114164322.787125-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114164322.787125-4-smostafa@google.com>
Subject: [PATCH v7 3/5] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAA6F4000C
X-Stat-Signature: dkrz34tzaws9fkehmurp3n888gp669fp
X-Rspam-User: 
X-HE-Tag: 1768409014-322101
X-HE-Meta: U2FsdGVkX1+/yWv/Sjpm3tECHQX9E8HuJOrfhF8ycCdE6Z/YGhSLgfolBrDmW7SeFaSQa6vfEc0foV/TZammtRclC3BW5zvW2WPZRGjv24rH4d/iFYLQ/6KVH6nO7MjcF78MMBoGwSKcFJr6BA3ux/aCFha9iJnDZDw47Bewzd2IPZVni9wSY/Cy7fWnrq3K0Dj9r86nSaLFRe+grm/Sl/5qHzohH9TS3hJF3bVdh0UWs357ydMPMI6RxwnkeM6MBr84H8kxqYnPaDU4+tZmbONta6EMdZYDr20N/zsNO97vUoSk6IHidQhDEiQ0Oj1PEjkF/ZG397rVJDMgU7m9sxiwyEbFGBGEf0aek4BAGNEfn8yEIqWhKxsxeBqrR8arTuVVF0EmGSMOp/NJ0yOtE7WhL2ahM1+8+UNgQO6G/X5v1HwrBsfrkYggSf9A7NGnM2ajwFUMvJNX6yEEmYuQJuUbcNT98x1O2cJTGbylAfSiBjZSlmsD1uU+wNn/rIdvC84croDky1TuwbovMFfnfsGazN3pq0HfGUidH2u57Lbd1zP2J/5ELpwQYbnLfJtOTzUpW51bKgszqCkf3gINs8yTwqIhjz8ocZ/AJ2GGVvl99qFDEQrPJszycFsBoI/Ao3Hc9BlCSMekMXrRkzzFMN8pKdGf1S9E6nGsbl/NTWT5TVfo4HvKR9G+GkmRsXbyjw94boVtZwwhShzVYPCUBsqYbmhfXURjHc+lOgTW3f96LeZpnMidq/Mpg9HsEAZSQ7w8ZUy1vWl4/u9wR7v2qAIGcLY8olX8PjgQ8IaiVpKtju8B5gZFVgg/D+miLs0W48BRvmchkK+PvXja8XuwN5gYYBHuw3aPcIg4fso0JoYZk6aEoCdX3txHHjnhOMl7muqoT3PXKD4USioML1DuucNJ8HqxGry1QglS6/lIpmciaGRtk93SJ28Tx8D0nhvMAzqMizJfgBXEsNN0nx+
 wJt6s0+M
 8S6r9mHPcJO7BRQIDFzXMd5pa+OzMg1Z02PyM53ybmVANDaxAkX9XPw9IvNexfNkmF8gkeRJkxQ9Y7u20HvKoAhtHlMKs/1VOX1fBYirHOWGgyF9ZMTMl06kkHEXEZP8Yh07m826sZx2TqiGwyETud5xq1sNEg9mJ1UZz4rudIDqmHKjs1iRYXF+hMQ+U56A51oqgieoIqSBDpK3y39SZUI4JSYxM05LuIJfWY/eB8VkARlFGgkw1tJIeXpdAAvGovYNT7+RLWnuL9qHSo9uUEYmBI3mAj2VSyFfYvsjnRH6v9x2xcqmIV1T4HqwrNia3f+oeyWFFxDLaiab6CKSf4jjceyXRzvafBYbGR1Q4nlbuDuO7SBTZ3yGau7rzktTjptPX6lns3ANKRcyTs2Ixq80tj3xgXJyCVcUch3tPn8FS7kQsBEEezTJSEGFwb5JfYy2hOdn0u7Hk1d80FAmNprotLJt/utuTmz787YM8UOQaUkJmiybtpLGkBs9Qv8RQl2JEQw9FsGMFY1A94X5JBKG6aZA/cKFfoAaUur/egfXX4dfYJ5HGX008BLRVL8DczvyOpRM45pEvcvHx/MfpaBxV6LkcnDRHcrbVAgkfb0u9lBQhCtSneZqfFF4EmYZYh175cGdxzPxUeo6RaWbQKQtkuEcTvUJtj+E1LjAybOVIUQjkMmOlUuCtIId3yUQfORuCaRC6v6mDpuEEpcjwB6Ls0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
- iommu_debug_init: Enable the debug mode if configured by the user.
- iommu_debug_map: Track iommu pages mapped, using physical address.
- iommu_debug_unmap_begin: Track start of iommu unmap operation, with
  IOVA and size.
- iommu_debug_unmap_end: Track the end of unmap operation, passing the
  actual unmapped size versus the tracked one at unmap_begin.

We have to do the unmap_begin/end as once pages are unmapped we lose
the information of the physical address.
This is racy, but the API is racy by construction as it uses refcounts
and doesn't attempt to lock/synchronize with the IOMMU API as that will
be costly, meaning that possibility of false negative exists.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 28 +++++++++++++
 drivers/iommu/iommu-priv.h            | 58 +++++++++++++++++++++++++++
 drivers/iommu/iommu.c                 | 11 ++++-
 include/linux/iommu-debug-pagealloc.h |  1 +
 4 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index 4022e9af7f27..1d343421da98 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -5,11 +5,15 @@
  * IOMMU API debug page alloc sanitizer
  */
 #include <linux/atomic.h>
+#include <linux/iommu.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kernel.h>
 #include <linux/page_ext.h>
 
+#include "iommu-priv.h"
+
 static bool needed;
+DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
 
 struct iommu_debug_metadata {
 	atomic_t ref;
@@ -25,6 +29,30 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
+void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
+{
+}
+
+void __iommu_debug_unmap_begin(struct iommu_domain *domain,
+			       unsigned long iova, size_t size)
+{
+}
+
+void __iommu_debug_unmap_end(struct iommu_domain *domain,
+			     unsigned long iova, size_t size,
+			     size_t unmapped)
+{
+}
+
+void iommu_debug_init(void)
+{
+	if (!needed)
+		return;
+
+	pr_info("iommu: Debugging page allocations, expect overhead or disable iommu.debug_pagealloc");
+	static_branch_enable(&iommu_debug_initialized);
+}
+
 static int __init iommu_debug_pagealloc(char *str)
 {
 	return kstrtobool(str, &needed);
diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
index c95394cd03a7..aaffad5854fc 100644
--- a/drivers/iommu/iommu-priv.h
+++ b/drivers/iommu/iommu-priv.h
@@ -5,6 +5,7 @@
 #define __LINUX_IOMMU_PRIV_H
 
 #include <linux/iommu.h>
+#include <linux/iommu-debug-pagealloc.h>
 #include <linux/msi.h>
 
 static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
@@ -65,4 +66,61 @@ static inline int iommufd_sw_msi(struct iommu_domain *domain,
 int iommu_replace_device_pasid(struct iommu_domain *domain,
 			       struct device *dev, ioasid_t pasid,
 			       struct iommu_attach_handle *handle);
+
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+
+void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
+		       size_t size);
+void __iommu_debug_unmap_begin(struct iommu_domain *domain,
+			       unsigned long iova, size_t size);
+void __iommu_debug_unmap_end(struct iommu_domain *domain,
+			     unsigned long iova, size_t size, size_t unmapped);
+
+static inline void iommu_debug_map(struct iommu_domain *domain,
+				   phys_addr_t phys, size_t size)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_map(domain, phys, size);
+}
+
+static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
+					   unsigned long iova, size_t size)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_unmap_begin(domain, iova, size);
+}
+
+static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
+					 unsigned long iova, size_t size,
+					 size_t unmapped)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_unmap_end(domain, iova, size, unmapped);
+}
+
+void iommu_debug_init(void);
+
+#else
+static inline void iommu_debug_map(struct iommu_domain *domain,
+				   phys_addr_t phys, size_t size)
+{
+}
+
+static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
+					   unsigned long iova, size_t size)
+{
+}
+
+static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
+					 unsigned long iova, size_t size,
+					 size_t unmapped)
+{
+}
+
+static inline void iommu_debug_init(void)
+{
+}
+
+#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
+
 #endif /* __LINUX_IOMMU_PRIV_H */
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2ca990dfbb88..01b062575519 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -232,6 +232,8 @@ static int __init iommu_subsys_init(void)
 	if (!nb)
 		return -ENOMEM;
 
+	iommu_debug_init();
+
 	for (int i = 0; i < ARRAY_SIZE(iommu_buses); i++) {
 		nb[i].notifier_call = iommu_bus_notifier;
 		bus_register_notifier(iommu_buses[i], &nb[i]);
@@ -2562,10 +2564,12 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 	}
 
 	/* unroll mapping in case something went wrong */
-	if (ret)
+	if (ret) {
 		iommu_unmap(domain, orig_iova, orig_size - size);
-	else
+	} else {
 		trace_map(orig_iova, orig_paddr, orig_size);
+		iommu_debug_map(domain, orig_paddr, orig_size);
+	}
 
 	return ret;
 }
@@ -2627,6 +2631,8 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 
 	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
 
+	iommu_debug_unmap_begin(domain, iova, size);
+
 	/*
 	 * Keep iterating until we either unmap 'size' bytes (or more)
 	 * or we hit an area that isn't mapped.
@@ -2647,6 +2653,7 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 	}
 
 	trace_unmap(orig_iova, size, unmapped);
+	iommu_debug_unmap_end(domain, orig_iova, size, unmapped);
 	return unmapped;
 }
 
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
index 83e64d70bf6c..a439d6815ca1 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -9,6 +9,7 @@
 #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
 
 #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
 
 extern struct page_ext_operations page_iommu_debug_ops;
 
-- 
2.52.0.457.g6b5491de43-goog


