Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB42D41C33
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44926B000A; Thu, 11 Dec 2025 07:59:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CB56B000C; Thu, 11 Dec 2025 07:59:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32976B000D; Thu, 11 Dec 2025 07:59:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A56C6B000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:59:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CC3FC0157
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:39 +0000 (UTC)
X-FDA: 84207196878.21.C58809C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7153D2001C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ewe6y/0n";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3OMA6aQgKCPMnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3OMA6aQgKCPMnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765457977; a=rsa-sha256;
	cv=none;
	b=fLokiOp+epieNKM9AED1IqtRnAwl3MU53JPAw7GCFczHUVWgX3xKvx50Sianp/gRJoKF/M
	m+yvs9xiWb6h3oTHc4Bb1snnRF964Wn2kephqaIA/JyzJ8eVBkWjCiS/QhHaWe6HX1mRSX
	0pSWEf1cSxqJl55LgBrNjPIt5HekDpU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ewe6y/0n";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3OMA6aQgKCPMnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3OMA6aQgKCPMnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765457977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uczD8ZdQ8fTq7m0W4DWUDtOuBgHIj4dHD70uVwXhDg0=;
	b=7dwAdlMIuaj9a1kFT+un8eSyoFheRlOwmZHdBhkh8MqjAzd4z9BtKjxegmnOMrXFzjeleo
	mJS85rwY14zpuF2wzz9Kyzi1b349RVHXnbItFhsjeadwz9ikc1KEBles4PPRPxAt8y2ia6
	9YrxHdz4n5ZWx0pxsoW08d9xW4FSACI=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779393221aso324265e9.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765457976; x=1766062776; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uczD8ZdQ8fTq7m0W4DWUDtOuBgHIj4dHD70uVwXhDg0=;
        b=ewe6y/0nx8nlKBih6db/S/Oghi/2ZAAEuuyMmfQxtV+RWS8D9eltMdvSYjwccbYA3G
         SqMBNuutUX48fsZxo8CQTqllkyhSRxtB7tUtDB1N+5XLG7dEDAD42zzOFAsMsjmChhLM
         QBSnSkNoeVIUYWZM5VgT8kX/3EHdaL/EjFtStnEcHCXfASQnefoFXjjY9qrO3TEdgcfz
         BeB9cV2Viyv50YkzIBmwBbdVBI63e9GmQ9gzsyxHg3H9aLUtvLv3Wtt7991S3AK4gCMf
         crc422jPSl0cP5EONW1Ke3gC8aDIyBXIz9aPeE5oBm9sVnx0wHmWV1V9wdRrXNhGJttF
         DrZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765457976; x=1766062776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uczD8ZdQ8fTq7m0W4DWUDtOuBgHIj4dHD70uVwXhDg0=;
        b=RmLDXOCbc91u8nS+yg7aaobgjjIQ1wngRz98wOHo4fyNG/Kr65NiCHhJ6jaeIhimsw
         QddxNN7iiO8lq3KdiiURyUj+LVW6nqzYB/9kcJRz4YxVa+SvDAlhorxVU2u75wq3F7Jb
         RFn0B3In4KdUw4lzL/v1U/flBlZ9Q8xdQTPi3JTtvUx1xTcHxOC4hyPyvmBPdgIuzKhX
         zVq3gsoDguEUQz/x97KdhOPac601sSdo4GiH6tJFsvOuZOAgGe68/n5Jxim6A24Yww1X
         eUtz00ro8YeWRAS+0ecg6Tx/NYMvZgr9gXfPv5flANWVC7hyRlEMjJCPWUCaq0Fusn8d
         Mm2g==
X-Gm-Message-State: AOJu0Ywu1E+v7laVLGcLbmYdYeLSyBImZFNoPcRuDlCpSy6cJ9C0Qrbr
	s3KlpSMWmNd15OBP/GFUffZ0BfhIniv+494SlFdhp/4J6XFjFmZXSn0pwSt1oR7kkSFB5pdkE9O
	B4XfSkwUBmMFuivJONA2GrRKX3wQRD9cB746yspiHUCmVrTcNGtVtH8Ob3YFwQ9u5KKYGdkNAfC
	9Wuio1H89vsdDhAq8WZ/ug/0Iubli8xDhj8vBGou/ujA==
X-Google-Smtp-Source: AGHT+IErtrN5I/szVaeR7W3AXMtZYGQqpX/+3kBobuXH5Exs8vXtzLzu4Ae4t9CTgNjyphsP7lVmH3aKCM1T2w==
X-Received: from wmbgz10.prod.google.com ([2002:a05:600c:888a:b0:479:3624:3472])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6097:b0:477:df7:b020 with SMTP id 5b1f17b1804b1-47a838065f8mr64380625e9.18.1765457976087;
 Thu, 11 Dec 2025 04:59:36 -0800 (PST)
Date: Thu, 11 Dec 2025 12:59:26 +0000
In-Reply-To: <20251211125928.3258905-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251211125928.3258905-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211125928.3258905-3-smostafa@google.com>
Subject: [PATCH v4 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
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
X-Rspamd-Queue-Id: 7153D2001C
X-Stat-Signature: t3qggk5f8rhn51krfm8h66as754pikxo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765457977-98307
X-HE-Meta: U2FsdGVkX19U5oPXO8m6YQOZlDrWstsl7jI2FiD1plKpVUmFVcZNT04n8OfH5zFTo57GUXCvLnVlcjHR9Op+BYqLv1jBwvTB4LnLYb50U3js41gJBCWIWwv2W7aJ0LV7nLjd76yzSswVrFvPIwouMZOFCdmFD7hjXFU/wJ9tUwpUzxAGEDJcKttC7kQk2IAPQNB2sAv/nV9vx9Gi/vjphGcqOtquqUKiiQJtFSgyyjBJYeX5VYd58dTx79eccbDDZitKlnrUur9SGOQnKifJX0FIHNblLWcv7TMp+hhNCOdJtGh0TM6I3+AxenreC3F4b+exjEdIQkEfVRonAneYMb3vwesEcnY4Td2ITG9KgsoWhQVf7Xr5ybBUq76Oeh/Xms1HZziCI0Rtmu5gcQGK3yv67wlHVYNzTF+oDqYkunSrH+MfsGKSD+HOh34BeRO7OxrVVv+zkX9MRY7J45bgF9E3vU2wjUKmkeiQlgD+cl0UlKMD3baUkxoJfAf4FGuixdwUHwP4ms/qeAZevrTS0GKpiTzOnmC5mKxa2jlDwrEcLZgyaW4WHlds1NmMv9tZ2BZPm/1BgKpGQxh3mQNNTpLx1KY6PsdIOWX/4wThP/IRw0RM3Gld7rXQ6MvVv0RZXYRZ8Nb5kj7JqXO7PyKKaVw++yQvouNS0gDk9U2k9okyInhUPA3KCj6NmFVuZpREYCi6HrS7L3Q2T0NC4jBgl6Bqh9GFhf7TpEfQva9ZZdZJALCCUKq1Bvo5g/8uBjItLZlei61nkCE3uf2gEpahm97HJ/Bq+shZtLkzXPB8FIr47xFwzLB7/FVcdV1dBiSRbMsmhnY/VwRNlQtZjjrWE9Lo+gZq6xwnFzmS/babedTTg8RMc0hoOp1IDcBpqaFCCNZK2XCEi9R3PJV1oQqwjO9KgZ55aAdSfKOSl584IZN55osavsTlA82csv3c65LdB/YLro9c42+UtH21z1g
 JknOrJV3
 b75JfREm2+yp1Tnw6KgD+9sOtE5tY1vuf+XSRRQpnw5e9MYt4LnKgNy1JGaZdRS7lcMZffAi+DomtTeOxw+5LK8zJBPnhspzserG7cf6KgWlWF8dvvOhdG/Pp3XuOxndNgS088O4gjEcj9w/gtAs8HJ501Nnz4NRht2jf7E8BSwQGFGw1mNoXwgENMygNvaPOu/CTYUAkC1njoTBJbgQ7JT3ldj/kzfNc2wK9NgfY5tpbFczOxytCAGE0PPfh0MvW0PaT9FYT/hRtHQkomekLJzwu3cy8Wa3Obc61UYJmMPX0a2zFtXYC2wvHxt7Hh+I5vKqwLwMEgUIP68rKKKRCJuFXH81HBPtFHJ3p/OhV/hYQ9Vmdn9sFxdaWS3Gd+7o6QlUTWlY1YZbDRAY6IXJJO2dNeZKA7+Aw4mqlwUzjpzYQGfjPfN1oU7ZsGQa5JH0HMP8R/HRCu3KprmKhnubtJVSv362j2q0k5E0yAOk22i/0ClhB3kAX9UNcD7cEFDYbTUxWNjUSQVZZsVynevav74lmr+SaW23u1FF6gqsvg35Fo2w/JWLw4H3kosGLi2M5vyWdAoQePBGGJOpRsO1wH06Xo6FK6thWQEQj6oLmaoX0xwfP/nPyBLjyn/VPgkFqQol1s5kB3mXxY/U=
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
2.52.0.223.gf5cc29aaa4-goog


