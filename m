Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC97D41C33
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C5C6B000D; Thu, 11 Dec 2025 07:59:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BCCB6B000E; Thu, 11 Dec 2025 07:59:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9256B0010; Thu, 11 Dec 2025 07:59:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0162E6B000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:59:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B8F11386DC
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:41 +0000 (UTC)
X-FDA: 84207196962.09.60B7DBC
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1D61120011
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DyYFBurR;
	spf=pass (imf29.hostedemail.com: domain of 3OsA6aQgKCPUpjlpqXcXdlldib.Zljifkru-jjhsXZh.lod@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OsA6aQgKCPUpjlpqXcXdlldib.Zljifkru-jjhsXZh.lod@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765457979; a=rsa-sha256;
	cv=none;
	b=Moz2blkTd6dGKRJWXikw1T+a2LhqYiOVccLqjOX0mY+zdD1XRkvKdgPrbGwW6hFSmKiBI7
	NY+4B79Jh5+4jWT+57dleFH0vUm6giDTh3Hhrd/2WaC1WBaHN3oU804Z+1C9pxNURvx7AV
	1TAqUhY5t17Bt/lbdA+gms50Hsm4/lQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765457979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5uF5F4n44uHHmtIbXF2UG9WJO+vO8dPMrZl97vxG7I=;
	b=6vYHXq4DVVhBWU67iqbGCulSd1lx7RHFXNY5uPX9Yo1yn09zOMvMo3h8bqvvqQfQEt1LpF
	gIS0ds9BcwdTXCgzvkqSW11dkCTROiUYLd6CZv6J2024WWS1TdaPEpdykWcq7GeZ+I9mYo
	0QD1tPXi5GkMaqJuRt2Z2oWw6tnq8pw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DyYFBurR;
	spf=pass (imf29.hostedemail.com: domain of 3OsA6aQgKCPUpjlpqXcXdlldib.Zljifkru-jjhsXZh.lod@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OsA6aQgKCPUpjlpqXcXdlldib.Zljifkru-jjhsXZh.lod@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477563a0c75so354225e9.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765457978; x=1766062778; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z5uF5F4n44uHHmtIbXF2UG9WJO+vO8dPMrZl97vxG7I=;
        b=DyYFBurRmjGFypQVrQy1gJx5aMG1N4Rg1bnZ4YhIH0mI6H4X+Rc5J9lh8LIwUHAE7G
         LM9baLD0XCvXaR02qlF8LE04CVGXAmGq9WkFYxrxUQl4J2IBKFkQfyFjDqwxNS4vNNrs
         S7UjA8LBqaGrDWqcg4BUB8F0kxwbVAr9ClFmt22E0dRAJuT5A+eOcsvJ7o186addV4Lp
         q8m4UqyJsvLjZ+bISHTp/QQTnSsbRnldGE1us5QO19x/siIGVt4Fok4+Uli3sA1+x+pR
         WXKlzR2VstD5cMhlRa/WLPcsYP9MbYLXnjoYe2XQjO6IxE8YiZqFM0L3TjmE7NKITslO
         2qTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765457978; x=1766062778;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z5uF5F4n44uHHmtIbXF2UG9WJO+vO8dPMrZl97vxG7I=;
        b=TRw6YjSMh0Pdzy4nDqE2nXMBoAaInoHG60IZSvj9DRvWJldhifLgR9DdwL2k4YTGWK
         LMp+CHjZ1hXYx7UJDmDSGEvgiJHrQTpwkMuLstjJATvMk0jW92oMLdTz0pyEDEc3kI2Z
         dcYZjgTiVXBOuUjt2hyekJe/6p1A2rr8HDQm6C06D6mAAA3LAks6MsBNlzX4pGv+yojR
         6Kbu6Pmnjq9wkiUoxk5gKeQf1OZ3Wqh1Vt1pqvTFMP4zI58yZ6mwFjR5i5OgL/NPM2Fu
         NL72L9W9OftgQpkMnM/kH1UqX8ndb3pbNZd2JuhefpvbUuzsQMNyX90ia448vQqLrDBb
         IF+g==
X-Gm-Message-State: AOJu0YyzoXMRSlW5hn2M1RNQ9kynTAKyFhN1RMXsKzF6PdWw/7C5gQF9
	tp0qX2Inl+K+qPRAOA5xkaanzRaAfGBSeFbvYYm7ZR8+i9vBTrWJYgb/6q2j98BMlCBg46GKQxW
	8P6xRtMLNQcJ4lDVzJf02V+xX3G1F36keaPRGi004TV/xweIXSHLHiOSmG7d/u2h+mP95maEzqJ
	HnpL+3G7tTWTkAdqPjHRIb+O8D0qCxHhMZO1yYAM1Cgw==
X-Google-Smtp-Source: AGHT+IEzrlA/D2+Mzh+inyFuHFFtWJkme4dxyA7uMTZWAlUftjFK9QGFcKLMuEzVGMzE2aQGlGAf5icqRkZxhw==
X-Received: from wrvk5.prod.google.com ([2002:a5d:5185:0:b0:425:f04a:4d91])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2087:b0:42b:4177:7136 with SMTP id ffacd0b85a97d-42fa3afd48dmr6497099f8f.32.1765457978004;
 Thu, 11 Dec 2025 04:59:38 -0800 (PST)
Date: Thu, 11 Dec 2025 12:59:28 +0000
In-Reply-To: <20251211125928.3258905-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251211125928.3258905-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211125928.3258905-5-smostafa@google.com>
Subject: [PATCH v4 4/4] iommu: debug-pagealloc: Check mapped/unmapped kernel memory
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D1D61120011
X-Stat-Signature: o4wzieyhrkkm9tu9csrmfmpmaacaspox
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765457979-803968
X-HE-Meta: U2FsdGVkX19xPFcwWkvx67fHOYVSZlliEWBLvPp4aw/lRr0la/cJaz9XiD8y8X5nko8k/SE7WhiI5jMrnWJaVdqTNPs+cr+caTnoLzCigQnGjpaA3UHRoxwgCTrMyabsDk4QcsL/npiaeJb/qf+vpKpZesb2ayvV8SDXzcGoxVldbA5DG9F3CL5+L4fPrpUxB1GsNWF1Js9Ce2KoZ1jsfcZTxZmYA9DSwTJM3Sw+LzYSV30ecDawICBpSELlroWXPBSUpLp3QZsCgcyR9iRpLYSnURdCsZuliQyPxMST6B83NEhMfP5H+ZeCm2x52s1nGQPzlKHzDEnpbBpb07TV4B0iPzrL+kPrRghDC4wt1rFBNWqoEQU38tvkLnfBD4oqn0GGGPg93Ryu+2EyIrt5aJ0esGAArY4wnRq7D4C4d+1FXTfrrw6TVtjAsgTEE7/VCy/Zqju1EURBVqUbk7gvrzpEhxgfOasdGQ3H6ZBjKf2EK1KyF1X0PaLTuV9Jg8REhtYSh9djOQs/bq/dsQZegshNyinzC7HzO1QZiUFc/jkUv1z/k93drUwXMHRRdR3AHAaSsnBqZIoJwC7QsHrMnHkd0KZOKZYvseKFt22Km5RsBwmMWZaL1CaR0qbesM9V6Tog4OgP58gO1Q5vWnM4HE7/Txq1D+4zMWRGKw8JeLS1wEKQ+svR5UPtP5vnNfNvtCQ9sni/TP8w6RMKi/xBXScb+Riwh2lytTE81zLu9ptjWRQydxbQFGw2Oy3yGNhvnh0Tz7WuXC6vDtjaEyFqbCM/ZNvFvwPA6vfBdf0ASlRbdSeoev3J52MBTidb9ssUIkqEMwiTBF2AtUP6TUNyM+8/VN0X4ysErzOBTxRV6vyqk/8bSkOOCrScVqfFJw7j2BovwVPReUvIkG/mgng40aSQH/HY6Z0NkEMxamZIh7/L2ym1t0gr1AIRhVA9RDBQLy+kXJu1Oy5mjxo41qY
 6srsEXEV
 f3CyVkhXhFDrlValplWcgXspmfi+fp0YX3E9woU56RslmNnQQCxo1k6DP9V02XDvZ0/L6xQypC8fXTP8h1Tgtu+uF7DmFDhHa98eLwfObizWnAJRFpirkOSy3ya6XRIbcvs2j+YiPmh0mP8Q/eroivgU5FVb2LozVddYRwvLtLMccd57XeB5hN0wl4eRQ8NycqGn2f8dKmAK/YXQztahrA++bm9jKRtL2mGZ+OwUK8js5wHvVGey34E1dkJnt92R3rWiMKWs2NbksK2W40qBdLFXE61h2zbzhTRW2c2UK0dYrBwjuPyZRJtIE1B6aSV2itPZtwdvVwX3N9Gm4MqBsz75Et+4/uR2VkZCvSaWtAVaOPyAdL+fDCVu9NahvR1JmvOwATj/QUFC6lHsLW1sJr+847Cx6B5CSLu0lIzNK1tlv/okPiQLih54iN2PmWH6T11qV+SS9U7P1wpH8DbJGNBzcVSaehf+n4vPsX/eaWu/edJ/H0f5t6O3wOS0HaVAeka5sMVTtcAbJVdPAQkm/43QFw7wbviS1KSSCVUBIEvRgbfHluOaL4MoZVa9GVMRIZ4tadtYXlWO7inu0VfYwAKI1qg==
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
 include/linux/iommu-debug-pagealloc.h | 14 ++++++++++++++
 include/linux/mm.h                    |  5 +++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-de=
bug-pagealloc.c
index 4639cf9518e6..424e00cd103b 100644
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
index 7a1819c20643..3763b71a7d3e 100644
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
2.52.0.223.gf5cc29aaa4-goog


