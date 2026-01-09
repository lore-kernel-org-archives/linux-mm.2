Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8490D26D7A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6B96B008A; Fri,  9 Jan 2026 12:18:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1286B008C; Fri,  9 Jan 2026 12:18:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2B86B0092; Fri,  9 Jan 2026 12:18:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 499D86B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:18:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B52A013B196
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:18:17 +0000 (UTC)
X-FDA: 84313083834.01.C7B1637
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id D3B6E40016
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:18:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zy2avLWW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3VjhhaQgKCJ0PJLPQ7C7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VjhhaQgKCJ0PJLPQ7C7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767979095; a=rsa-sha256;
	cv=none;
	b=AVsimuwLwMr4yo9MRTAJ2zLqWkmSSJUbhGG/m5f+AdfbfNWtSWD0c1wBbKCZQzQuqGhsCE
	nm+zJuILAYHgm+c8okowobbh3F6NMCdXPuCq1t6LQ1hbjO4HZSVLGruHmcrfhMUuh0aAhn
	2YRYdBtcR1RfF1v68uqeBQQlo+kUFwc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zy2avLWW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3VjhhaQgKCJ0PJLPQ7C7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VjhhaQgKCJ0PJLPQ7C7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guvkPBegEDYZPDzaTTld5oNSHvfpDoo/mBDTxGLtjdA=;
	b=XvskIT0GfWUbP0mn36KJRJY9sD82FbjCvuKVY0o1yYUiTpRldV0GNrIxIDPPBsbeX7L305
	mx5QgUn/WunKE0ide20or8snQZY7YmJLPQCR+WCZi7o0mb4ae8aJ0TaeYAKcOgSzeh2aR+
	kOBUZGEPEPSjW7kvIL0K91YOx7sjGC4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so44667555e9.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 09:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767979094; x=1768583894; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=guvkPBegEDYZPDzaTTld5oNSHvfpDoo/mBDTxGLtjdA=;
        b=zy2avLWWvMZeYAXhQKuFEXFE8Qsz0pfgSeseUj88j1C77D/H60HSKbD42vMGNlTlXx
         vm8lW/df0+2AGsgq12hiEGh//Sv3sn34K+dBykmlX+iTeF8Rc25adbxJFOca5zMjgKJE
         hKiL0htz2Y7G6F+J2naCGgM+LURMOirAHLDDt+1OB9UfhbnLeyiK3F3xeCwyMwtvfosK
         9WNjdXX6aRmFohA5d48ky3vipwEbigRHKAu1o2o66sNn+26JZqBgFPlaLcBpgtboUaWb
         x/PvnnUsN6Bw+/T3uW46jKV1eRSNoi5CE5bR5NWpUzoBg6b4ZG+Spfn9ByvCwn2NH0Wc
         mGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767979094; x=1768583894;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=guvkPBegEDYZPDzaTTld5oNSHvfpDoo/mBDTxGLtjdA=;
        b=QyYBuQDfJRZUuAS+AJ3WXRkq9G/tIMo4RNFNL7eWQZCJ9yYDBr9a5a6xvE9utUjV24
         DK+Up7blwkry7Q8+cb3n9K0nErxW8uP5EhVsfRPPAGG0lSeeNuJHLexG4Dxuirno+5Re
         GuDe3So4DRZkwiM0cKME9a8/BWpDw/9bx+S93AhgvxZ3eoClzCA9xdSD3vAnVwF19Fae
         9vAGwi7WsUehX5G6ztnZ95UvbKIKgduP4YuEylAYXpja2HEnSc8pTG8TZKn+o49LCQO9
         YXkF9XAQmA2InRjS6KHU613cvBJhyLOvhJQtXYUpOpUVONEtqgjmg4bzWSekDRzjkX0T
         Baew==
X-Gm-Message-State: AOJu0Yxz9gk7oFVeZpu/zmB1I9OlHgVX1jK7F7zhiOIpGop2tj/bxJOb
	dGMJwdTexKLE/9rmD/S3gjIMFHGrEf9xnOUEvfK6o3yvOmbn61i8az+P7aI9JsKHbp6nfEGubDz
	d8OHAKbKUFCt6NQfigEolffoq0e3qvTG3VLenG4TclfosWEJi8/5SMhcoctiGZHZSESqgHTIt7f
	MtDTMXOAgI6eA2J23ZVlm+oe7ZicLHV03x9WOUayBgow==
X-Google-Smtp-Source: AGHT+IEBrg+YqeYEJ2M7D0lJnTSEa6qXe7po9KhFZWeBWPF3GO7tA7upEM5MN29g/F3xM/Fg51UOl4g9PnWT0Q==
X-Received: from wmgf14.prod.google.com ([2002:a05:600c:154e:b0:477:9dee:b5d5])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d19:b0:47d:5089:a476 with SMTP id 5b1f17b1804b1-47d84b386fdmr138392485e9.31.1767979094365;
 Fri, 09 Jan 2026 09:18:14 -0800 (PST)
Date: Fri,  9 Jan 2026 17:18:03 +0000
In-Reply-To: <20260109171805.901995-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109171805.901995-3-smostafa@google.com>
Subject: [PATCH v6 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
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
X-Rspam-User: 
X-Stat-Signature: 7bfbc47dooot3y6qtcmbq3atn9zadd5i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D3B6E40016
X-HE-Tag: 1767979095-182641
X-HE-Meta: U2FsdGVkX187Y28fJUFLn6ngel82bTK07wMk5Q0E3myP5MtK8wKfbWUqtE4rbdoPaLAZVg60+LX6BClPW+2fkrTKD6STlEhrfXCW08XffUJANPusf0EwWDccSPt3rY4iZhauodaB0HutMrmJ507F/9dMRb+psbO53s1nQvMp0vLcmfQ9cmEZkeWvj8sc2UAO2KvnB6Aq2fGNUoS2gyWhz1hPJw46DlkGnJ8Q/hP/nKnL/SrI3MsjAonrET1JQatwPB9KfGopqoVIgDYa6I+d7jXiZMCTcGY6M4Muxg0w4SL9GyEHelcP3i37evTgBmqBZq+7ZKzDA5HioZueYcV7GAdPiWtxs04d7CUtvnkIdM0wC3BKA9vUzjvOERKLGdPQ8g2DlWi3s4eXjRrdH3JJ/jUIRH6ik3goJemd6Ek9HTOMG8KGdD6verfDVQWVanztogDnGfTWr+c+nwSVjnhScZMuFdDKwUEgGm7BmzuL6o9gjTvhHVsqjhy7Od1qDQ0rAEvynDgT9EpO8cIMFTAlexYzCx5CVRK3a8psroGX/pV2xhHIrkWPq8FufmBM7vZ7OKAzGxCDQP+JBYbS71GY6bcrZp/46FRjRZtqyF5Mm2aJUCRYqGda9HJ/QX5TWVlMe6G9j7uQBckV5frF15IrGKWihDHvSMz9r0in+RsneAxu6ukWdnMpFzHKsnp5g6VGraWcUGs346AI/chRaJU74eSoRGgaUIrI/YcNzPn1eFSMKiiWJkaykg2aTRZ46rbJbdYIARGjcnTW5r1AD0sd30ubWBXpweynZSUu/itQh6q9wvVYsxkFsI20UtXxMYYa4UU9+5O4JWZ5LQYxs/MwkmBTaeTu9qgO5fFGx/nTPX70bq1Atk52dk/teWXfBWHVwv8YVv7OJfHZJI0FHyhLrlRbTo0x5iK+fBfYyAzv9HyiVf5PFXwIRr5m1dMtWhUd4mHbWrvq/r8Yk2i+YIB
 QV77eNqt
 tPi63r9Wz7nK1xe9L/gJPgrjfC/AfBuKHIj4jGjKReHDsStRlQgYLIRY//HbMMoDHyHobAlp5t83sjYG5ycafa2S9DXZfO6OYuPpDgIxtuWPJKfj+oTFkjQyld5Y8/IbOLLDzqI0bzp7yMYVgkuxlPEvrkSyZGuvOS2H0GIEUDtBckkM9uEWOQRaw0PWm8HxhHjq4YwY5oRJsjefyNw4TLDWFUlaK4x8Zg1Jj+Pe+SBVRVmpgU3Lwq0TuI8mLi+uhQl35vJAWsqnGWwRMn9KG3/dLWHd9qiG9+nMOYariHiAnjEZM5kGSsWI1m9DUYePNTJ5tUdkJinytRKhEbYxMcMIVLRB+0ocn2U7PeuqGUL21WW7gFFGJf61USOQkLh4FG5OTc/FkwXrUGA4bc4bNwL/rY6SeXQniEhKZRUWoqoiL+NM+GE/kuTnxLZsqP6Zt2F9dUOoTXdA4dIYLWCm5t6NTRK3MH9buMIxZ/wfAkUVNK/JxVIg2u6QTAknkqUShJY32bYeB1KqjogH6KBsmDEL9nNQ0e7RKJgCS9qJNRx+vDggnQBzCqIlQbHXUYsLsQStBr/E4RQsX5oNCEtSHnZ5nAFbjtsiJyZgQBfRoE7gQ2dRh/eOEl19ObJ8NBCAulIVzdNQAjAaLdr+PVmmR+4a+eD52sqdcv89f
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


