Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF97CFD352
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667596B00A6; Mon, 24 Nov 2025 15:08:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2386B00AC; Mon, 24 Nov 2025 15:08:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BECC6B00A6; Mon, 24 Nov 2025 15:08:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEE96B00A6
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:08:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3067898C4
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:22 +0000 (UTC)
X-FDA: 84146587644.23.7C26071
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1BA1B1C0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DZRxIUiK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3M7skaQgKCIw82489qvqw44w1u.s421y3AD-220Bqs0.47w@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3M7skaQgKCIw82489qvqw44w1u.s421y3AD-220Bqs0.47w@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764014901; a=rsa-sha256;
	cv=none;
	b=K1L4JSV1+45rl0XNJ2leB4N8979rVtMn9KPOGX1Jqmo+CFWUTiFDKe66TRv3bRHwx6JAPJ
	IU0VU10YijzgI54GUraLcUiOEYPkwpnZZoE/KYC/2nuURPFfpILbHsaFz0TfbdsSenmlFp
	Tzaml04nJoOX4d/0nKrtbZqBeGO9tbA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DZRxIUiK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3M7skaQgKCIw82489qvqw44w1u.s421y3AD-220Bqs0.47w@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3M7skaQgKCIw82489qvqw44w1u.s421y3AD-220Bqs0.47w@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764014901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ngu03ozlByRiFoMKVX4H/wPPA/ikA9JmIOYfKZmpaLQ=;
	b=AQi5J0T2OGIp+Rr7xQloKglpSLl/bq0v2MQifIIRTdxr/T6soeDXbPZpF3pBpaBwGJoo7i
	9uXedwcDdAXhRA70pGqWVS7FvWHXG+oqsAvhby0fw4ewZyNTqhNvnQB8qVWbsfwcZkjOBt
	HZsaKATntKikNgLxmqt3LF/vdRBrUcw=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42b56125e77so2236337f8f.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764014900; x=1764619700; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ngu03ozlByRiFoMKVX4H/wPPA/ikA9JmIOYfKZmpaLQ=;
        b=DZRxIUiKF/0DuS9BgHtnBQgn0EMhPofq/knlgibHfJEYz8bKkyQSxUt5zQodpjty2s
         kxoqFREXfSMLcMAruJM+0oHaj22vdn0llr41cDLbY0WII4xykNvK/1yW0Qof21U6JDEu
         zbxeBPiL5Wl3il9/ze/cHPbL7tPZdxIgsWbOd7+cS715egZ5udsQM0W3WS5xLOdA+MuE
         7w7D0JIIobzHW+06XrHML1PNamkBMbwxsVSWKiQKWrxYQIOiMuvawyHLbQRjnrNx6vQC
         hkR74YiPLGQ6ngW2/fGauTlkinHBl8XGpP0badaWqBoOedAKYHA8uVmLKgjU655H9B91
         TC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764014900; x=1764619700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ngu03ozlByRiFoMKVX4H/wPPA/ikA9JmIOYfKZmpaLQ=;
        b=kNlPyjNxYYA/8so2lMH44wcChyKgn0Ydk9+NIbZpBxPCUvIkQjZwZhW4CBVp3FU8RX
         wquU6b5+3TMUsZBkckqiE1exwm469YdIu3LZ0NWEP53Aj4WjADnisePg8WRV1o/rK5k7
         astLxwJnMLbBwr5sVarKH3gM3KXaUEV7ziiW6qg3/kTJS81znoGkmGPvchAbvVTqXrOX
         MvMhnuDB0cmDF3DOA5XwA+qOrTidazQHgdmNC9Cj8KKfk0LP31CMPW6edc2EaV7IEy3A
         YYGg3zzQZflvymQdLpVZ7ENJxTTXwBF+HCyb4aeA8H4ZKSfGGCi3Ba19VFM2VEZEFnHK
         Syeg==
X-Gm-Message-State: AOJu0Yz737rvfl7851M0vKQ9AFUZ6cFJ/XErySKbFiqd5OU8keXbaZT9
	qahMDQA2eurtzOS6EYmRmX6JPWIGmumw3UsXTJN6zILQ7jwnu4pR7tcp7/PGjGOWqQ7KCkKUV9T
	8IE0UVg8oR4FXPdR9B6ZkrwhJrzdSr6f71wRyNT3TppBb2yWxvUSyMjLtH2GDkTQLkNMnWwnO0n
	yBEASpUTTxoQIh+RwE6YzPCL0whb7fSCAKeKjrHSUMkw==
X-Google-Smtp-Source: AGHT+IECVEpnx2vzM6OsM8NmV1jTz+svgzK08aynDQT0IzGD5OgDIXmVO/7cpeDrwW2l1WNEm+YJw4E2NM/CVg==
X-Received: from wrqo3.prod.google.com ([2002:a5d:4a83:0:b0:42c:c2d6:28a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:3106:b0:429:cc1c:c2e with SMTP id ffacd0b85a97d-42e0f1e3499mr164660f8f.1.1764014899687;
 Mon, 24 Nov 2025 12:08:19 -0800 (PST)
Date: Mon, 24 Nov 2025 20:08:09 +0000
In-Reply-To: <20251124200811.2942432-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251124200811.2942432-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
Message-ID: <20251124200811.2942432-3-smostafa@google.com>
Subject: [PATCH v3 2/4] drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1BA1B1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: a5j1sgbbcqd1ynkurn8d98sig687zmnd
X-Rspam-User: 
X-HE-Tag: 1764014900-161827
X-HE-Meta: U2FsdGVkX1/xzRlZKjELgJ+wq4oFJCbNNSL0t6ZShMZSTvHSoabuGgmRVDfYEW49mKnfp0qvjkFhDYHIBUKNGXcvX+Tx7rI0YE3mCG4a9EbZ1ydFdPqtKo0P6bDmhVfHD9TY8posIrxUlXy/nBGXcGun89Cf8OwYnEVRsjkPE9pFvRA3X4FNmtSt4xKFWSfl9SQcIZwm/qPV9jQeZ1+eh1YxT0073wLdmI9EIke3IRwO5H4lGfG35n/ifJjBvPZ+OzUAIiMDMDCe9R/IB3lPlF0DG4rvcktIaa8EkaQ4RNGxNLMv5/my9RQbiU+FJmWN1Z+Lj82ehcYmeo/KBa/2A5pzTE9N8UtOIzo9mjWvDIxcsIth6jJQX5sNUT1romHM6YIfG3zKhyqYJkj0EtihB/z4uoV6s2t95hzKLzU+R20HrTGXo9csqjKV2SuvmYb8Ci90CSTJVkj1zMLM9JtEL9P6Y/zrJhQpRIsRXBJQlCruYf3QyujgpfB4Ny5XMhu8YgQ0CtNEqx6nqt4yzVOeo+eRJRKDXPifazthDfA2eZGD9AdLflJRuCy6SXVsOTJdL6SV3MNRpcmNXKQjedkVRVpJn2w8dmYKjW289Jb4Nm52FombG6DL570g7RrgaN7cMNDX0mRCehiSEvU3WfYWa3S+FbY9U2psRfmN30PNmBt7GUZ/MX1raIgMPwR+q8LJX6D0Y8sgYXD5meS2yXzc7DURhfMtm8X3f7+E6BrygRaAcqadM5G9runK592bM33rsV+a39I7NQNu4HNLrpP+RPpZ+fx2MgK5jJq9g3YgWR4eiFKrIA4QaV2u4bNmgLv4a9eqZANM+NiNxVVkwC/eGwwVFLDKB+480bzmWyoDEliMu7TKBOwFCidYH4HNs6Pm+yKAVCdkDy/GCybHTUruYXXyykTR89oPBEQP79qKBJC48O36kuctt1y88Ex2c0P+fkNNFfLywqjpCRPjndn
 /AKIyYTi
 f5+bnxE0l3MzwKf3FPQuOlv+JvpIYscFJtuHzC7fin2Jyu5liIIejEzYPX/Hie+c6JQ1gfRcXzUNG1ekifHudfBNaOfX9sWbptNBxLSQ01rva0RofQmDtMgxcHP/i45LEbJ6AIptcL61NJMjh6cqQtS3Sl64L7eKGF1O6iYhqDZdxdaJWzTp7IiB8XgnKwI70pBqe12iRPHiSaz7uQRU98Htse3t8YcMNRbvtDDoQjyot/RIxQnK6CI/Cc4e40L+oFGgAwrDTRTZm+IxmMO00TP2ygoHJWe4BGEsc/Qo6TciE31X9sbtN9lrpISMSErYqGGoWx7RGHBxZLogQ6Ag/WWbbZB2UXW8cPs2zNwsyK+D1Vm62S64efmzvkOMhESn2hwnwA9RQI2WcluYup545bTr4tA+gPDV6aaSC0qANuKOKTQUjzxGCTwozSeow577mhRQPLopa2UbBb7PRsDYtCh9oPv066cZX2TxP1JXIIVUHdQ2amWhF1hyJyWGD8adjCpl+KthhlAzgl61pmAUBGVEpn5dtJ0W2TXIen3G+atjWOQPk7++FumQCXm6gqjXJF+/uIz9HmyNrjh0ytzOaevKJKEKVk/mfgBRmM4CYFhGsTUjyVyKeH5p4s4cXRYj7kibfGFyasyuj0po=
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
 drivers/iommu/iommu-debug-pagealloc.c | 26 +++++++++++++
 drivers/iommu/iommu.c                 | 12 +++++-
 include/linux/iommu-debug-pagealloc.h | 56 +++++++++++++++++++++++++++
 3 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index 4022e9af7f27..5665fd7360e0 100644
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
 
 struct iommu_debug_metadata {
 	atomic_t ref;
@@ -25,6 +27,30 @@ struct page_ext_operations page_iommu_debug_ops = {
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
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 59244c744eab..4d1dc321e400 100644
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
 
+	iommu_debug_unmap_begin(domain, iova, size);
+
 	/*
 	 * Keep iterating until we either unmap 'size' bytes (or more)
 	 * or we hit an area that isn't mapped.
@@ -2629,6 +2636,7 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 	}
 
 	trace_unmap(orig_iova, size, unmapped);
+	iommu_debug_unmap_end(domain, orig_iova, size, unmapped);
 	return unmapped;
 }
 
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
index 83e64d70bf6c..454303ec09c2 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -8,10 +8,66 @@
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
 #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
 
 #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
-- 
2.52.0.460.gd25c4c69ec-goog


