Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB39CD26D7A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8DD6B0089; Fri,  9 Jan 2026 12:26:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA836B008A; Fri,  9 Jan 2026 12:26:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD336B008C; Fri,  9 Jan 2026 12:26:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0855F6B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:26:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A59AD13B26C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:26:10 +0000 (UTC)
X-FDA: 84313103700.20.8B2F76F
Received: from mail-lj1-f202.google.com (mail-lj1-f202.google.com [209.85.208.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id B84D8140018
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:26:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UkhJp3p0;
	spf=pass (imf09.hostedemail.com: domain of 3WDhhaQgKCJ8RLNRS9E9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--smostafa.bounces.google.com designates 209.85.208.202 as permitted sender) smtp.mailfrom=3WDhhaQgKCJ8RLNRS9E9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5ROaQbDPNg/Pz9koleFUeugi8CxogCP+iCj0oWGRhs=;
	b=Njc8pHfv2DS/cJ4yeTAfzj46bENfOfNpcUybSgUSMhPddwffQruVf1740XXF4Hjm0Z/Jpe
	Dpi/Tw5g18aXNWwsVNlq+KelQlH7Tbq/I7/kbrs6niEoqwTRE6NgFfN6tnMnBbVVTabvEb
	V7VkU9E2zqAHQZAsApJ0Z7p0JYKIEcw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UkhJp3p0;
	spf=pass (imf09.hostedemail.com: domain of 3WDhhaQgKCJ8RLNRS9E9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--smostafa.bounces.google.com designates 209.85.208.202 as permitted sender) smtp.mailfrom=3WDhhaQgKCJ8RLNRS9E9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767979568; a=rsa-sha256;
	cv=none;
	b=URHjrCmTW/AHNDqRMywc+i2JcjjDsNa5wmAxRivLJvRTLg/4/b9UdUHo3PLPu3fKKo6jSM
	vcTkv2sZL3WsdThBLMZb3+Xbt5pG8OhgBQ5OwbmGifNP+q239Hrd40f0kczZ8XE8k1D95/
	vQAS/AcRmZmlR796Q1ONriqjVGUDb6A=
Received: by mail-lj1-f202.google.com with SMTP id 38308e7fff4ca-3831426aeb1so8726241fa.3
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 09:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767979567; x=1768584367; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z5ROaQbDPNg/Pz9koleFUeugi8CxogCP+iCj0oWGRhs=;
        b=UkhJp3p0HhAbagFnzB3+qLiOcom33705K8y1FqFR79SOvXBCJgLOk/lhb+o/db7xqS
         TeZcmLkDjHyGnFJle96Bz9stQraykra3stxv0vogNW96CePXE1ubTaFtg/qMBLb0cyg4
         dimyA0n462bEetyONT8royslnxuktb62JCO09bnxqHV9GLC2QwxulSqh7RWDN1UPaEWS
         TI30UUkksyoh+02YMnuLayeYuClMTd6eU583B07wg9k1DZeERIW2onL6AMRDOhT9UNc3
         sGrzzYWX3bgvC5XbERCTGqGDJRcWDZeJ4yquz+I3rmmyxM9EjKpYQ4CSmPLbcwvV1uUA
         sKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767979567; x=1768584367;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z5ROaQbDPNg/Pz9koleFUeugi8CxogCP+iCj0oWGRhs=;
        b=OYIpjBaqX9wbhJR5bCLqvExRjmC4R9/Wcf4P7HaRyA7Ws3GF6PBl0Mlio8EXF/iqwr
         nWwxG2vOESXhRsGgObN00V4pGg5GlL3HM5B+NyrtypP7L2P5iJ+1BUYs4QgrxsMowojg
         QNtQYNJLH5SebubOMuYELpoWvyPRGZOhmXuj+FxncgvgwN68zyo2e/SMoznTz4c4bt1N
         DZmZ7t1kSASdCQGJFJVZedxAd1mAoQ7VCYaNAXYL5H6VhWCmmFcrEmRHPLFIcRazyYdh
         fII3BPE7efBoBq1NnnEENIkrugBzZGMJuEnVmXrqbE0yXA2CZBbJVpnKA4laY9fOy6Iw
         vcXQ==
X-Gm-Message-State: AOJu0YyTk/B98Y0jcPml8Bnn4mqWreB1DoHARhqUzCDOcmCv533Winoi
	SOtgMBYOTkI/mG324ZNyo4XT7lob6iyBaH9gwYa/PGECf5A7gAmawkZsxIcoly77E+qYP8GUClE
	sC4+6p8ByMmc/FX3OAM5kZPXnK9rDuBxs3vHCBH++Go28yY2D0yuihUkXroi4ixI4S2hljeE0E/
	LvBo1Q0bknutR6vJ6lhoBXLAeEGUd28DFD5EZj+9yngg==
X-Google-Smtp-Source: AGHT+IGOoyMNz9SX5heA0+Ad8u3Mb3ue4F3q3Dm7Zb68ZiR2w+PZXKYiFFyi252YwvzslTXfx08Zaf+yul64YA==
X-Received: from wmcq2.prod.google.com ([2002:a05:600c:c102:b0:47b:daaa:51cf])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:458e:b0:47b:e29f:e067 with SMTP id 5b1f17b1804b1-47d84b0b21dmr111247725e9.6.1767979096375;
 Fri, 09 Jan 2026 09:18:16 -0800 (PST)
Date: Fri,  9 Jan 2026 17:18:05 +0000
In-Reply-To: <20260109171805.901995-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109171805.901995-5-smostafa@google.com>
Subject: [PATCH v6 4/4] iommu: debug-pagealloc: Check mapped/unmapped kernel memory
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B84D8140018
X-Stat-Signature: jmuuqp7phjyqwk1kz9a7e9qtqpmt7d5b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767979568-18685
X-HE-Meta: U2FsdGVkX1+lTU5oOKAFjS177aKWL1h74bOlDab/Uj2B/UitLDc3QaZeD4Qf4e1ybUQ9G0YM57hei/R0B8hXjz7oj9NAxkUk4sh4Bjs0bUCSCmh7yPC8PaeDq2lLodIBH6POTA4M63Bs9kU6Ta8U1lEZIVwBQBpgdItdjvs6G193k+xVL7/wGOPnjs+/VD4KLGCGTwPc2vMtO+rnm3BGNW86KBCBjsL5IEanqnxEfqcS8huC4oIvLkLDbGscXJqER3tOI1VkkvCXstR0AeGTjTYXjR+/0WJ3nic1e1S0HeEWF/kFzYa3y42WrYLfbkS29LsDy5p7V7lyjFnGiI6jneCtDN4n0HrCH4ssASW+t/LyYIf43ONYzOrJ9tqfzPq8VlaMfqHnZVDnGyuplOJcdEyeLIy5U/Wg85oK9Nu4vhrOS4KANXecbNB+AFpEpcvc4lpwbdCua0YMzwc8HrSeT/SC3PKI8ZWYm49WSn0jNpONL7qtBK3WPGzBBi8kBn2nK0sFFVg9tUQBDUrU2A0mKSC2B5ydUNpiy6BDfuOdOHQN+LTH9CPlx+VdbHka7O8GBdQYocC44TyqVwCL+f6beCIFZW6efGml8BqrOhM1EwzF+KeADtHrQKpLlaw2myBIWWfbCdomPmDJRACdYvXYd68p/YVT/WWnxl7CGXPIEKx+cU3jUe9uo3ipS8kR2DlgO/zbxuSKe0BmmtgIH4lXLSBhjt8e0c1tTmSjUTWNAsdcGGuLpTbLxKWRq8XMptyIlI+dMFAwt+CvzyWEdGeno7HTH6gUFQLfu1g6HGQxrYGRacHLZSv9NHUHbhDT7ibBLHcKOkIO0Sb1WeN7vQ79LpO6JXiofoJhxJH+0OF0DIBM6RbQ1OxmottyRSMrndIK6nv5SXVkLOVc6HBr0zLj8UVr7VDybLORPNaLiBrKIDzrsvCnfyAGH1YDBHBexKHD2TgxL3KUzmeD8qNU0nR
 2PMEcmBH
 YgoBUNrHqL5RvAJKLcm4xZYvDbCDWTAsV0sKoXywEDHcbUUeD7O/CfXgFQ98j4PQUv8FVThfk1E4OFpo35Ar1q/icuCK4gX/WRc0yeK13FA0vAF0sTKEo4wxn3LbFjIQdy3YdMx2kwSffgpvCTPzmHWy8JwCGYFirBRYLthYdbGijziSWpZO+bKblbzWQZdOELwjiBIUcD9RCCsY5Mo1WCQbzi4t7Gd8hN8hFp7BT16HfGm/DmwyjdoIpAxR5iy8nJcIbCEmqSvTn8Ybj/Pk+8x4VlxDtmLUQWa4Z2Btmb2t5XF9W7dHXWKxUuZZaTnTe0YmW0bpXzaqUDtRRwnX7x8KKF0w/tbAg6HWVFhGa4nKc7N2BhwwDwfPCQVDcPFRw5AXsIqs5T5DE3rSWVIr1ORPzlwk3LGuMw2JzEQon4jR3678durlcrEe2eZdkV9cghSD6aR2ymaFNuGQIsOVhhsO7RvmA8elIJzQdzFgxkAwdK090ak1CZfFL9PBrc/Xlgeo04sPdR0MkEGnKYVWobG7ef12dHq2QjWsSgRH+wUSmlIuxNOrO2C8MUd1YUiyMMOa/oRiREIuh7l6NasRNsdmsgxUFuP3ojPTI0q6ySSCy16Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, as the page_ext holds count of IOMMU mappings, we can use it to
assert that any page allocated/freed is indeed not in the IOMMU.

The sanitizer doesn=E2=80=99t protect against mapping/unmapping during this
period. However, that=E2=80=99s less harmful as the page is not used by the
kernel.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 23 +++++++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h | 14 ++++++++++++++
 include/linux/mm.h                    |  5 +++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-de=
bug-pagealloc.c
index 9eb49e1230ee..c080a38f45a4 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -9,6 +9,7 @@
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kernel.h>
 #include <linux/page_ext.h>
+#include <linux/page_owner.h>
=20
 #include "iommu-priv.h"
=20
@@ -73,6 +74,28 @@ static size_t iommu_debug_page_size(struct iommu_domain =
*domain)
 	return 1UL << __ffs(domain->pgsize_bitmap);
 }
=20
+static bool iommu_debug_page_count(const struct page *page)
+{
+	unsigned int ref;
+	struct page_ext *page_ext =3D page_ext_get(page);
+	struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
+
+	ref =3D atomic_read(&d->ref);
+	page_ext_put(page_ext);
+	return ref !=3D 0;
+}
+
+void __iommu_debug_check_unmapped(const struct page *page, int numpages)
+{
+	while (numpages--) {
+		if (WARN_ON(iommu_debug_page_count(page))) {
+			pr_warn("iommu: Detected page leak!\n");
+			dump_page_owner(page);
+		}
+		page++;
+	}
+}
+
 void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size=
_t size)
 {
 	size_t off, end;
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-de=
bug-pagealloc.h
index a439d6815ca1..46c3c1f70150 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -13,6 +13,20 @@ DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
=20
 extern struct page_ext_operations page_iommu_debug_ops;
=20
+void __iommu_debug_check_unmapped(const struct page *page, int numpages);
+
+static inline void iommu_debug_check_unmapped(const struct page *page, int=
 numpages)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_check_unmapped(page, numpages);
+}
+
+#else
+static inline void iommu_debug_check_unmapped(const struct page *page,
+					      int numpages)
+{
+}
+
 #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
=20
 #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..32205d2a24b2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -36,6 +36,7 @@
 #include <linux/rcuwait.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <linux/iommu-debug-pagealloc.h>
=20
 struct mempolicy;
 struct anon_vma;
@@ -4133,12 +4134,16 @@ extern void __kernel_map_pages(struct page *page, i=
nt numpages, int enable);
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static inline void debug_pagealloc_map_pages(struct page *page, int numpag=
es)
 {
+	iommu_debug_check_unmapped(page, numpages);
+
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 1);
 }
=20
 static inline void debug_pagealloc_unmap_pages(struct page *page, int nump=
ages)
 {
+	iommu_debug_check_unmapped(page, numpages);
+
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 0);
 }
--=20
2.52.0.457.g6b5491de43-goog


