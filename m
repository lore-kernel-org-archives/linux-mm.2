Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B9FCCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF368E0014; Thu,  6 Nov 2025 11:40:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E838E0002; Thu,  6 Nov 2025 11:40:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646278E0014; Thu,  6 Nov 2025 11:40:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 448958E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:40:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12565866BA
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:14 +0000 (UTC)
X-FDA: 84080744748.09.FE85A26
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 304174000E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t45mOoe2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3as8MaQgKCIs71378pupv33v0t.r310x29C-11zAprz.36v@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3as8MaQgKCIs71378pupv33v0t.r310x29C-11zAprz.36v@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762447212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSiZ7a1SAJCcKkBVDBEHEQqlSOfVk/u+1v4U8UB7ILg=;
	b=lxnMB2+p6Cy+16vTLSKRs+UFFHxbF+BXD2rb1/4WLDq82FBf5SM935aIyIOY++HcPv8hh9
	mpIpEi33m41G6c8lEXyvJDUbhTwZaVe/NjFfMUnorRSCNZsHrMutpuPu8r14DqSnt0VoNk
	PHSjKzEPSMLbBxR1OVRWv4L7kay1ltY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762447212; a=rsa-sha256;
	cv=none;
	b=Fl+V7nxhI4AhfoUqbsp6BXszSHEK8cH4crxewQh1wTbH//HR0dzVOXRpcivCkwoc3FD+mz
	HhNkQEX9xo9bq5mxry3EftO3oaoNAYdVp232agSTws4DDWo0JFB8v2ZLmdSiEr5HlcLVbC
	4X65ktz3Q6TMiNTGSKNVESMEU3tqCYw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t45mOoe2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3as8MaQgKCIs71378pupv33v0t.r310x29C-11zAprz.36v@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3as8MaQgKCIs71378pupv33v0t.r310x29C-11zAprz.36v@flex--smostafa.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477632c240bso8580635e9.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762447211; x=1763052011; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tSiZ7a1SAJCcKkBVDBEHEQqlSOfVk/u+1v4U8UB7ILg=;
        b=t45mOoe2P/6IwbrI0NPBb0O+DGw7pjXN8kq50ehi9ipLy5UV59Y1WGj4Rl4AjlezRb
         WU3L8Hv9DSMaMaOHFrkL1p73N4kVRoKtVM1TpCm7BQesp4XIndKaKmHjIen88CB9A595
         l7d9oBWpH3xyjVsREt7V0cUtFDuU1yHFr1AS53w/admkuhncbXF1G4uPD+Kp1MaDOBPt
         I42ZhRtj7HBau2OcZ1zgZnM9ta3hz9wqZx5vhaXRJGxILHv53gjhdWxMtkucM8dTTyCn
         FyqxNEvXIDxvtL7rdGdbGLzE1v8EOgjuRvn9IbIZTIWPG2DBOiXt/4QgENhvUgesaYHY
         wTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447211; x=1763052011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tSiZ7a1SAJCcKkBVDBEHEQqlSOfVk/u+1v4U8UB7ILg=;
        b=eced+JbUcmuufzlM9JpLMYmF0ObU1onTdf67WaduFLFKo7226wKqkbhF3e5hAMCy2b
         26AJt9GdhDya3BF5yyRdqLqZ7CKD1lKqXA6aMF6sPXxVGOmaGuKUxSWNKO8tTyQLK/Xs
         9bzXM4/wahZGo31Djn6G/3ThzAp8sIR4bv/QRmzzQKzKJl3ipo5USHU5/I7WqueBQfFB
         i97hnw+VbxtNWRWNimGnLnXnrPPLhRHP/gWF0vU35Aci+T6GAXS7ZRSk9axKRjzC8MXI
         hiq1caWP8ANpAnB+Jv/OT5NtoldcOUPJnXtd6zeBQBNmFSu7bn2KlG3R1aPO24+4ZutA
         ZQ1w==
X-Gm-Message-State: AOJu0YxvCThZu9dnNrGalmDhMKNd/NbXZc+pkMWD+f6V34Akzca1bQhc
	CWvendSYXIrYm2ECDhHBOBwVcWTSOyL4zdUZKsrcCrlSfQnWmImJVgiZsRY4VDU6YsRA0bULxiK
	/TiVxouZ06tNS3Dg483w1ReCt47+Jt48iPZnFADhrA30gT4bEQpSWmU9aMMU5Y2JSInb7YFmMeh
	FcWaFPdGO/wMzo+iLmW8c7Fd84BGB6Oa2lHAwJtChxcw==
X-Google-Smtp-Source: AGHT+IEulRepKpg83hX8wGoEp36I0gmjB5yebzIOWO3BeWZ0yZNLjb0D/EtrwnuCx8tGevmN/RGY3y+bKKt1iw==
X-Received: from wmnc9.prod.google.com ([2002:a05:600c:1709:b0:477:31ea:6473])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1987:b0:471:56:6f79 with SMTP id 5b1f17b1804b1-4775ce3c5b5mr66270665e9.41.1762447210611;
 Thu, 06 Nov 2025 08:40:10 -0800 (PST)
Date: Thu,  6 Nov 2025 16:39:51 +0000
In-Reply-To: <20251106163953.1971067-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251106163953.1971067-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.2.1026.g39e6a42477-goog
Message-ID: <20251106163953.1971067-3-smostafa@google.com>
Subject: [PATCH v2 2/4] drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>, Qinxin Xia <xiaqinxin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dsetay6fqdj54zk1ckojb7n1hrmcryf8
X-Rspam-User: 
X-Rspamd-Queue-Id: 304174000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1762447211-352855
X-HE-Meta: U2FsdGVkX1/dA1kap2eKSRsKP0WUiOZDyz2aB0sSsoubjUIVKf56YcsfQ8UMhirOWXDF8lcAne9kWFYRFeTqBCv5nTdDgocW/AxZpXLyF4vkmmLrlY/URZoDo+bPNtelMw7s588Ug/KZTTVTj+YLWcwoumjpBVv7G3k9iT83KbIvZTAt6Lwc39JO7XlhCZUBxtKPxraBRNu+Ak0Lko9WBhfDf+gCAm+35P3ucZrg/+9ivOQy+vZZ6YmAMEesCPXd5IbLDyS+8jztlCXMiX5nl/z31koQEHDJGPRpuOnFquFXmg1N8iQ0CBZRse3AbZQztN3dE2Nmb5oJdgsEBD7k+fSVJCe/eeXL/Od6lXPOOWdoiXPjxIsTpTq9XVhVXgXsyt9IwzhrMhU8/6x2ZRPnLtUEj1DZ2CuJNb4kK+rhLmRzZhCJBFOSh9kER0s4eEU8XONF9NuPYQ/ynrBDSg0oG6VNmp6W3ZFA9x2WvvFYSDk6yKT5gbmlp9uao3xbubn3/0kCD9KBGwP84T32bgOKibpfpdPob5Qof4pHNn1TO/zaJqiK3HLYJI8oXFsLRHA04WIRtmoQwUuyKDy7Jr9RvWLN7dsCSUleSgoFWjN/83QrSCp2auiUXjCHwYomevBh8bTjXttASK5hcTMumct6l7aqx0BAznuVdbIyg7gN4bpUPgvzzEmlzVHsC7Gj4WeQEnfPCtUVK2zBu/wmUhouTj3+X6V4N3neLsqorcZ02qhYcAVyN5EemHUuM5xVUqsAmU2vPeFMJlpoUhQJ2jXFwT3rNkMJjSMdjavnLUqhYicH7w+8bm7N0dF2YkBrsCMjyH9Z8HTnMlUnIcg5cNulwWrbi83/vshrzw4+u5WmHYe6x5z6XiNGLmrPo0DxiSaGNgRI/3mk31jTOvpdXKlRfx39CAd8rQxN/TIaQaGDmt+LVyke3pxZY1n1MnRyqTE95Zkzs9XxRw/KKguoWBu
 B3EN92UW
 zBstRwPLZOBKZ1S9wUoNMQb6yjDY6jMN92UiCGxOPJES3ucDzp9PB3fymLfDHGUXVj3+louvXhoDy3yxt/KX5seu4iM/Jmhb1Z48mgePKNJ7eOrRiTpDUyeOQfHWaGE2TiYtl2QFoeJflu2SaQfaumi9OR+Da6ixkjcdIS2C4qAlwj7d7HVxNGck9BR7RhP9+aKr9NAt8ZwbE9gJnMazK/Fl2zhgz8kMddVpR8glFkCWWWaZo/NIKaLS/A9xPfFVomOMnClO/WPoJK1el2sCXkw/S/vRMB7L0SYrP1mRov2Da17CrMJTqtwCctpOmDgQK1q99+M1RwHg7RxZO02cCyneq32EVYQLeUlHIMZcCqAwtf7HypcL+6O00xeWQ/XRZpfgkIhTyIdpH4IP5A1wFQRoHA6Pb3pRWtF9dqVwp/UDIIk9NhkREvktNi7T/ciZcZ5Dk5hbf2UCCM/CBc7Tasy4RBPQHVVI2M1cN2ur4aAbgcsDbJURfV09NLTNlcvF5nKJkhKu+l5vCXR5Wcjch7yKTnMPMDA5xBhGS6eqTDCWp/hcwRdPPQQt6G9Z66Kf1y1rwyXsPWVE9tP9/izkv3wZYHk+mkOqATSXqg01T8JFC7xfqvY6XA9SOSBVDawCi0jVU1Kqakv7SIJFLjIdXI1hTNEjWPawCHRFwtyDmy9m3PvqI3YQQ7ppJROS3Sntk+bmK2PbEnNqtEu1gS3UhHo2CQU1ymWFMMMdLvE3Xe3z4J21WCcAApQr8xA==
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
- iommu_debug_unmap: Track iommu pages unmapped, using IO virtual
  address.
- iommu_debug_remap: Track iommu pages, already mapped using IOVA.

We have to do the unmap/remap as once pages are unmapped we lose the
information of the physical address.
This is racy, but the API is racy by construction as it uses refcounts
and doesn't attempt to lock/synchronize with the IOMMU API as that will
be costly, meaning that possibility of false negative exists.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 23 ++++++++++++
 drivers/iommu/iommu.c                 | 14 ++++++-
 include/linux/iommu-debug-pagealloc.h | 54 +++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index 385c8bfae02b..a6a2f844b09d 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -5,11 +5,13 @@
  * IOMMU API debug page alloc sanitizer
  */
 #include <linux/atomic.h>
+#include <linux/iommu.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kernel.h>
 #include <linux/page_ext.h>
 
 static bool needed;
+DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
 
 struct iommu_debug_metadate {
 	atomic_t ref;
@@ -25,6 +27,27 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
+void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
+{
+}
+
+void __iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
+{
+}
+
+void __iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
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
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 59244c744eab..f374ac0fdf95 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/host1x_context_bus.h>
 #include <linux/iommu.h>
+#include <linux/iommu-debug-pagealloc.h>
 #include <linux/iommufd.h>
 #include <linux/idr.h>
 #include <linux/err.h>
@@ -231,6 +232,8 @@ static int __init iommu_subsys_init(void)
 	if (!nb)
 		return -ENOMEM;
 
+	iommu_debug_init();
+
 	for (int i = 0; i < ARRAY_SIZE(iommu_buses); i++) {
 		nb[i].notifier_call = iommu_bus_notifier;
 		bus_register_notifier(iommu_buses[i], &nb[i]);
@@ -2544,10 +2547,12 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
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
@@ -2609,6 +2614,8 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 
 	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
 
+	iommu_debug_unmap(domain, iova, size);
+
 	/*
 	 * Keep iterating until we either unmap 'size' bytes (or more)
 	 * or we hit an area that isn't mapped.
@@ -2628,6 +2635,9 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 		unmapped += unmapped_page;
 	}
 
+	if (unmapped < size)
+		iommu_debug_remap(domain, iova, size - unmapped);
+
 	trace_unmap(orig_iova, size, unmapped);
 	return unmapped;
 }
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
index 83e64d70bf6c..180446d6d86f 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -8,10 +8,64 @@
 #ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
 #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
 
+struct iommu_domain;
+
 #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
 
+DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
+
 extern struct page_ext_operations page_iommu_debug_ops;
 
+void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
+		       size_t size);
+void __iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova,
+			 size_t size);
+void __iommu_debug_remap(struct iommu_domain *domain, unsigned long iova,
+			 size_t size);
+
+static inline void iommu_debug_map(struct iommu_domain *domain,
+				   phys_addr_t phys, size_t size)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_map(domain, phys, size);
+}
+
+static inline void iommu_debug_unmap(struct iommu_domain *domain,
+				     unsigned long iova, size_t size)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_unmap(domain, iova, size);
+}
+
+static inline void iommu_debug_remap(struct iommu_domain *domain,
+				     unsigned long iova, size_t size)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_remap(domain, iova, size);
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
+static inline void iommu_debug_unmap(struct iommu_domain *domain,
+				     unsigned long iova, size_t size)
+{
+}
+
+static inline void iommu_debug_remap(struct iommu_domain *domain,
+				     unsigned long iova, size_t size)
+{
+}
+
+static inline void iommu_debug_init(void)
+{
+}
+
 #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
 
 #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
-- 
2.51.2.1026.g39e6a42477-goog


