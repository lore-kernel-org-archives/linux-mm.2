Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF6CCFD356
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C32A6B00AD; Mon, 24 Nov 2025 15:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A166B00B1; Mon, 24 Nov 2025 15:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8891F6B00B2; Mon, 24 Nov 2025 15:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7277B6B00AD
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:08:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BA3A890EC
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:25 +0000 (UTC)
X-FDA: 84146587770.20.0787A32
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 597C31A0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dqEaOkdl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3NbskaQgKCI4A46ABsxsy66y3w.u64305CF-442Dsu2.69y@flex--smostafa.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3NbskaQgKCI4A46ABsxsy66y3w.u64305CF-442Dsu2.69y@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764014903; a=rsa-sha256;
	cv=none;
	b=QpVL/ogh/2ckF2OPiEhkBaE+O4QM9Oshaz2Yf0NigsZnxYNQEkstsDCy+TOLIDA9wlEfny
	BxB3nHtrwmlSuGbxHs/4MjIKe2CPaP5SlkdN4Z5KOiflRXbthMHA9XwG8E8/VSQjyTyKzr
	V66ORXbhqyoGipFjv3/Im4O4MK4Mk1E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dqEaOkdl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3NbskaQgKCI4A46ABsxsy66y3w.u64305CF-442Dsu2.69y@flex--smostafa.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3NbskaQgKCI4A46ABsxsy66y3w.u64305CF-442Dsu2.69y@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764014903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xSmEu5ZIQLRYpzloFi758DLZmW8jyYxJ7x9EopwKAk=;
	b=XwFqxDGCjz2Xr2jPyrTUs8J4/rgqmgns26hVWE6zsAS9HICzWfRWT3xkJCkS1z8hOquF5T
	P55ga3pfwe6X/w+vwfRjEfA0FWizw5i0eOEDwCK93NqFhc3wVPaVI7pUacvd/8lBUdvFym
	TASlAaAxCmzz6Kk1EeyR3e+9iLnp2bg=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6411c626af4so4926304a12.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764014902; x=1764619702; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3xSmEu5ZIQLRYpzloFi758DLZmW8jyYxJ7x9EopwKAk=;
        b=dqEaOkdl8FsF8XaoVJmyXqE8AdHRjFur3Z+nu0xjyfNxIKUJiwC5nMT7k7eGu3I/3w
         4hDsChy03RSX6osvbLSzyIczSwCkC5RkBwbGi4KEM6Dx8urpCXf/jZ1J9IPmN63IabCs
         WjuhK4gmrYqXG1rNAGYR8O54XZ9+qD0BJKCJZU/Mg1Yz2EHJ3M5DJFK/79UbqJqy/3dM
         IFkOqoLluK7g1/QR9nCNQ4E4Z+LmA3HgP1Cl7dnALc0iq9kBqpUrubVNlGvd+MopwB/p
         U4LrSSBY63mZe1elGNV9jWliHaazS83mN0f7pnVXGkYXYvaaL0H2lnIu2YJpmvzPC+jY
         bOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764014902; x=1764619702;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3xSmEu5ZIQLRYpzloFi758DLZmW8jyYxJ7x9EopwKAk=;
        b=FJTWfGm8LTlE4y2QPbvt1GDoUztCVvr4G30Fsgke68e6g22WZ2eXWSlciHAxFjgBJS
         aYm6Lq3BHNLJnO/UENPWcZnR0Eqgy1PzZDt7iR/DdI+wgJ8CaUVx22Ks7uXc7Nnl8INh
         AWk54AEOulxZvyWDiepk9S7k9bYF6NpWM+KebK2xwtN0f1xVB/eDVaRbc3z9jP6pXVk1
         7glfXmGXBeCKKD9Adph7QLT38Yu985teEwtZv6SEgLWevgp/OkyA3BCagsdWwBXkj+Qb
         zUcxJ5PnRrQ+Y5aMVAIGr0FFmxDjhe9XRRNTbgcHbBp3O4MRE97sWsq9O5RyObzY/qKn
         A+lQ==
X-Gm-Message-State: AOJu0YzJvNHX9WRK9X0dyA4JxYAll+hdisV++H7bG/ztpBsqRO2gdB+m
	pYLkMoFevpAzYH1aE50/JvckhXS6dHg7zbeVwX2DqKoXOw12GlAACbDY+KOtyBlBLpR2ksULtzy
	TdrJ23vZ6PNfRMmxCkp48plBz+Rl3l8koUqnD6hZqjYqn8g38GKAuAdlnrNA+v1QXadK3+YVjuf
	Z+1/t+uxTf9zrhfUxjAEgQKlPgCQorZfe2ug2HIWzG/g==
X-Google-Smtp-Source: AGHT+IGX7qo6LNh60g3Sq15t12MDYxJDdl6W4Tqa/ummJmpe3KeIBfOpR/I35oLis22vg0LAmBuTLJWllweoYw==
X-Received: from edbin10.prod.google.com ([2002:a05:6402:208a:b0:641:6d32:a6d6])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2687:b0:638:74dc:cf78 with SMTP id 4fb4d7f45d1cf-645eb79fd02mr191410a12.34.1764014901656;
 Mon, 24 Nov 2025 12:08:21 -0800 (PST)
Date: Mon, 24 Nov 2025 20:08:11 +0000
In-Reply-To: <20251124200811.2942432-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251124200811.2942432-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
Message-ID: <20251124200811.2942432-5-smostafa@google.com>
Subject: [PATCH v3 4/4] drivers/iommu-debug-pagealloc: Check mapped/unmapped
 kernel memory
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 597C31A0011
X-Stat-Signature: qstg3o6mccdjyyhs8idqxhbnhcdewu4t
X-HE-Tag: 1764014903-329653
X-HE-Meta: U2FsdGVkX1/nb+/PTwhRumCimXUgGZpCFD8Fbch5U9vXEv8V/FcoNfCFLJoVIhOhpDfeWV1IAq7LQzIztQ4rY+Y7WfuNV1PZdHZE+LlVy3unD28mx3SrPV1uTZIymK4f4E8/Qf96vpG4MCnZxrrMxgcimyUohBzJSxUAZ1CQ9y4ocs51T/gU8/Q3/5635N32bU3MIGG7HFM/U/rwPK18PIIrOYrK0sdMhefy/B87p3lDLv+i31TvIALi04eUH1BSFMwvyQAXOUNu+J5IvnMcALgyxyz+TMv0y3DJWTDXo+gzsndafI59/4GoAfdRyw/SlOrRZoKAUb4yO1ZQQoxKt0ZmyLqtTKyomvXT4Qo3aWfCAwwEiG9WCXDpcYk8zGADxAbnHtjAe3Yua/juT55oWQWmmarkyuI44JP+KCwBBDOBQyHOtHuOSMbaQBDVFiJHMA4sZDdmbyaaMOXNPVAibopzo9TqaR5Ic9HgKEWy0XjsL2k049sF6xu3iolFXapkmhOXC10WItZs7EZV0ZLxPoUfTQPHLsHlrPkYfYIQVfr6dJPuJpGNsPc8+j2ryzhSNfHSr3ReUanFo+iKasB+64LP4rs0V1YDetDQTVHrnGvhUWCRPjlN2nl6RGG8l5pkD65H92nrb/pwOFcV9b/X/+db6EEJ/0H46HQAvY9LAvuy+XPi7ehkH+2u2d9/o94I7PhWgyFenDNYJQDszqqxcatXWCcqLRZ2UvVQNxCRX/gA2y/2cDNpX/t81hYIGeH2K2Vb4kUwYoP5JCH6B2tbb9zGL7088ZsskzH3WxQTn16xvcNMvSChopTJIb/e8y63K/9EJqNDyAb7ynL45DDspOv1j2Hq1cENxXk3C8T5x0+n4Hqvbxms9AV8rQZVcMUHi1G1ohdlpaPr49qcJFUeJfWa3QkAX6Mm4DzTaEGIbwA1st9yxLb6IEIs9Gb9azDVzgHLcSAMqyjSNKYImmG
 h2qxLrfe
 XL7/z37UPyP7NJbWMaKu3W2JRNPx08Cddm0HXx+mJC2Y0GzaxBsvxkk4Ftr4U53L0f6vhdlRMSwkG97LLWk9GeVPA2DvYU7WPW8XvE4ZcPOFF7MS53aKC+OYPxw009OV3dp46b/ualz5D7NemUYI5PCM/qx8qD7UqW5OXlgLIxBtfuLp+L3DpCZ9FcfmArW54tFM1iTcj3py+GLzBbCAwpYvy1OQPnnCcYwNCmqPvgv+PKynam8oRq/EIl19pym2qjvWvMrvY2k4fp2kMM922I0IXyr1L0jFDmIpuLueyFUQseov0gpo9JXnzkY590eXEowUptnqJNoD5d9LalUEDX7JnPWWQItqsHz6y5AstQNuvihV/PMplJDW87UuIcGAXD9zTMvj5jVgj/IzKMm73oh2vamVHtrio8v08FsJqXm/c9fAq/UMpjVcrjNbsWTBTYwUO8zF+h1j/eIyBZ9SXn5xBYrgD8JixGaeziIpR/223kGxO8/J9uS38ThDvJ/SqL9UU1m2hMPQGsprK1NGnyX+E6DMszSoUnaEzmGk8NesuLIgbK8MwI+S5YsAW5Debvh1FuI15/WDVwrMmZ2veSm2Vhw==
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

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 23 +++++++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h | 12 ++++++++++++
 include/linux/mm.h                    |  5 +++++
 3 files changed, 40 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-de=
bug-pagealloc.c
index c420b006ef08..8af11630d0e3 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -9,6 +9,7 @@
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kernel.h>
 #include <linux/page_ext.h>
+#include <linux/page_owner.h>
=20
 static bool needed;
 DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
@@ -71,6 +72,28 @@ static size_t iommu_debug_page_size(struct iommu_domain =
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
index 454303ec09c2..87f593305465 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -22,6 +22,7 @@ void __iommu_debug_unmap_begin(struct iommu_domain *domai=
n,
 			       unsigned long iova, size_t size);
 void __iommu_debug_unmap_end(struct iommu_domain *domain,
 			     unsigned long iova, size_t size, size_t unmapped);
+void __iommu_debug_check_unmapped(const struct page *page, int numpages);
=20
 static inline void iommu_debug_map(struct iommu_domain *domain,
 				   phys_addr_t phys, size_t size)
@@ -45,6 +46,12 @@ static inline void iommu_debug_unmap_end(struct iommu_do=
main *domain,
 		__iommu_debug_unmap_end(domain, iova, size, unmapped);
 }
=20
+static inline void iommu_debug_check_unmapped(const struct page *page, int=
 numpages)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_check_unmapped(page, numpages);
+}
+
 void iommu_debug_init(void);
=20
 #else
@@ -68,6 +75,11 @@ static inline void iommu_debug_init(void)
 {
 }
=20
+static inline void iommu_debug_check_unmapped(const struct page *page,
+					      int numpages)
+{
+}
+
 #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
=20
 #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..739cd3e168d7 100644
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
@@ -3818,12 +3819,16 @@ extern void __kernel_map_pages(struct page *page, i=
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
2.52.0.460.gd25c4c69ec-goog


