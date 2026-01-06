Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB3DCE9D78
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EEA6B0093; Tue,  6 Jan 2026 11:22:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739036B0096; Tue,  6 Jan 2026 11:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B9A6B0098; Tue,  6 Jan 2026 11:22:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA4D6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:22:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED915160467
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:13 +0000 (UTC)
X-FDA: 84302056146.13.656DA4A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 20FE1C0013
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SQbEgy9n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3sjZdaQgKCOUZTVZaHMHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3sjZdaQgKCOUZTVZaHMHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767716532; a=rsa-sha256;
	cv=none;
	b=4Cf1Hy1GSPNaPtL5gBh27SI1fdRKTei7CnnceMcok1PF9kB2B21eZR/SOzA0SiISFnqRNx
	1EFninXlaX3itQ549BKvGHSvtcmJ/dOZBNAjxxKzhXyHm/D45X9jwiAvRhoc1NHRJvthQC
	9OPwsm+mJ8NcJ805jgLgONfnHUgYAqA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SQbEgy9n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3sjZdaQgKCOUZTVZaHMHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3sjZdaQgKCOUZTVZaHMHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767716532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9X9rqTkWjrzThKptBrhyRL/ynMrRsQ75CmjmrFVf+E=;
	b=FPg+3Xso/qHgLZBdLVpBqX3/ur9AnzwjMibe0P/mAZUJ97uVcjeEZ348VaKsUQm9VeKmvJ
	6HYltab56IshdihFDqHrOupnMj1hW7NA+v9VbUlqjMYbEI1lDsTBV8sv2ieXMcy4Cj1fkB
	XTXUsckLhN7Q+nzZiMHd1ISFWxw+epk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47d28e7960fso13480555e9.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767716531; x=1768321331; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p9X9rqTkWjrzThKptBrhyRL/ynMrRsQ75CmjmrFVf+E=;
        b=SQbEgy9nEFgUcA3Gx3FZFHqn02qHskyCQO0NVGJTT+peLZByLHN8qzxaMNfmHsN0Tb
         1Eg6XMtVHx2uTcAveyeP7Ac2EqMbJ+1601dMFoYCpdoicpspL0avMrSQO6/ERsNT0dJp
         Xh6qsrMOGW9KRWlodeWcugpu5t8DnFpfaZN/ClEEYgv/Uo7A0AISyRWSCTth+ThoVRTm
         WKZBpCY9xqmYOsurVjRAl30FgVNbOb7N/TvZyutlvSQNjvAWLn2gPEKmDct6nbQ7CFYC
         V+eeogChq/uYVS0Y0wHIGDeWeuc5t81wP1asKK0+WoYwW6M6xtstEgRUUJYAP9uSUgU6
         LKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767716531; x=1768321331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9X9rqTkWjrzThKptBrhyRL/ynMrRsQ75CmjmrFVf+E=;
        b=M192goFheZIdFx4Jwxy9R9KjxNzNsdHgvB8yImoDUaAbMNlgacTEbs1VVRFSUUO8H7
         6kzD+ZmvUds6DVgTHSgxDbl5OOPFa4Yjt8eXyVEiaYWtVEOw/G9ZYlfBNt1UoRxctbrt
         vN6kEh+0gU/RaGG4y8h6hLe3z5Pzme75vK807OJgA0tczvQd6pkzoU1C/husflw3LGoK
         uGp5Lx1oTNfKKFyyVIdB80EoYMADIUYyhlne9vqS6oUOkNdW+0+SmohgOf9RojJsKZDz
         afdAgwMy85Yly0urSCUbQSXvTDTjbHCPkzgIz679xRXNU3X+a8PaW+SUsWyd8QqNhZHV
         BeLA==
X-Gm-Message-State: AOJu0Yzv9KkQDRkYh7G1HLvXiabmLTuDKQZQpH13wEbjdmDWo8JvksAV
	22JzpU3D2Pe6hMYbeLy98TnWZYII9Ddkw+GvNAkYimngtCVd73XNGuPVNlsTObwVUqsfW+Uc3FN
	oIscJhXjAVQhULghqgyN0m/ibpzHkmEMCMf7YRjocfsdIiXpH2Vbs3VOEx+6Pjs0B+cUW6DZLT2
	BzhieWUDg0Flb2meqYgRB5aYIXX37PnpYh+Uw5FLGKBA==
X-Google-Smtp-Source: AGHT+IHqvnTTwxVskrfx3Eg8hmFCGc9E3YGwzHwaaQ6Tg3cJl1Q59lJm5Ql2VwSPg4sK/MOiLULHClg+R28+Ew==
X-Received: from wmbgx18.prod.google.com ([2002:a05:600c:8592:b0:47d:5bef:a379])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc3:b0:477:641a:1402 with SMTP id 5b1f17b1804b1-47d7f05d451mr38748745e9.4.1767716530548;
 Tue, 06 Jan 2026 08:22:10 -0800 (PST)
Date: Tue,  6 Jan 2026 16:21:58 +0000
In-Reply-To: <20260106162200.2223655-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106162200.2223655-3-smostafa@google.com>
Subject: [PATCH v5 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 20FE1C0013
X-Stat-Signature: ky9exut8ho64836h46atfqbmmk16ast7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767716531-380805
X-HE-Meta: U2FsdGVkX18nU+E2xmbhHjEHGuSmdABmldtKtLTWJUhuVkOTCqN4dbKnxNpGPtTythhzZ6fSqe6nHLp3urj6OsxLLKQTF1wjgDK7SfF3P7kSL4l+9qeaq4W7kt3/DoNzqUiT5r8AUHtm+wVpA3X5TEeHxtliBpfzCfgHW9M8INROu/zvtNO3etXhxPcSCS5yshGTOYRBnonsHoHsrXTvbvv0O/+m1SLis15lOjJ+GfD+u9L13QEGVK+P+QKFLQZcym/gBORCLdN2HclmWndwt3ysxe2T9lJwQignIqMp4npFJyyADCjUbzYPd81OVcqJEaYjlt4wOCR1UEILiPWHrpadcbRaxddNHoy+ISyR2gde4zLsLdWN2xdX5vZLup/gMGz3qo47KjNjoCLV1ni9ZqZzpekhGfmwpN+0SjxULQAbQzz/ExSQ3Uv96MmpaLl8oPA3A5Oi6py9noj+eXX8u/qXz0dHCH9ZcU7X/849HvnVUrqUg4VSxhcfQZ/IDSxECtulvouWvDfEvjRtRTZ1V5EsoLIVxMozB9ymJJP/2LXjaZbcCR7pv0q6f8sZsbIG93WoJc2yEdOHHnQHlbsaRa9DnubOF5T5Wkk2jF6Rm4nn+WhKbczGS/ZCgn1abQhCGj4TXRb/XYomOR0UT+tRQefDi8uJwdFAbBYCGdxf8osJ1zRuVGmXK3vvSgB2dWYefa0iCAm8CCZ8R3M2SeINcEOt1W/RtELEGd9DyAx6pyD2+vyKOaYffB91vTbuqh9CsY0+y5IQAJppuEeqikK6dyScphAdkz/Uln/E6TZoopvhJRp0oO00PdtvyEoo8h8KBgUD3Ywh8fAGLROk7FyrDLOPsSlGzEY4ABVJxTf6iZ/0c8WHIoZ/12teTdCOuluyyK3T28f5RnWDY5HTI4BcBx+pEC6Jf+c09s2syhBHcTVD7sqVrnyNzasx4WTBdFkqxyIfmf9FqW5L2xjFNHP
 ena12gZe
 +ihxXN/M+9ytw62e2pBAzUK+HO+ys/fDamHGc4Vqa9cuw5xqiQj+YlH9Lz+ehFNHLoALwnjSUYFPeAChSNMeQ+vGqqkvOS5AdggsS8ARJe9q0IaDLdinbPz6Y4IceV0KgZUrRa0KS59tMN263qcmxe36OGu9G+PHOiKWtrPSxU/ZwgowF9FCG9NmS59oNjnBMGcHfZC6+au6MhgRVT3JTkUMSkpWWJe8aoPT7ZdHNnxDKLNR0/6J2k4ZmcDWA2NdsQR14VeJhjxH20dKt2nCU5nHifVd5lpsBvn2f7ET2w+cY8gFVd1Xk4SZL8jb9LbNJBFxlriKXYMlLIw2pzcgaiz+Wa/MgBFTaA6H5Fu4Tt9iigMLC1hbJhl79mM3mGs7DLUyCH/OVy0oAwJQ3xiGkSqhE87BvREg0RZxidYW+IvhvnoK8XrMaqs5X9DxS3MFPsMttEDNcarE5fMWdDAfNAyLd9xNVTiAWNwtRMakxMFOCghgzhbc/YFCqH7Gps4LTrmbpfaJ+ehxFBdzcl7i5cfczZxJgCzZSZYRrjYe0IBt1ztFUllNMS8gu8ho5/oGPtJaZJtVBEqLFuiGK5QhjyZwVqeOWOhp6bV9wDTleqqyPQjQ5SYK6kq49EX4aMfMMI/kVZtvhzbi07iA=
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
2.52.0.351.gbe84eed79e-goog


