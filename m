Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C6CCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8EA8E0018; Fri,  3 Oct 2025 13:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254B98E0016; Fri,  3 Oct 2025 13:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143338E0018; Fri,  3 Oct 2025 13:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 003368E0016
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:32:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2B9811AD9F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:53 +0000 (UTC)
X-FDA: 83957498226.12.911CEC1
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD34BA0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4gW15LF/";
	spf=pass (imf15.hostedemail.com: domain of 3wQjgaAgKCKASMOSTAFAGOOGLE.COMLINUX-MMKVACK.ORG@flex--smostafa.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3wQjgaAgKCKASMOSTAFAGOOGLE.COMLINUX-MMKVACK.ORG@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759512771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsO4Y9+CDsR/9B2sBMziOZN6BaFGbVnMznIuFrkfbBE=;
	b=uDOlycxLu56TntqFPTXJvC6cq9f19tqOxC2So+ddZA5nvq8uZWaOATYzWraUjRzmxcQDjL
	CE6PQ9VhXbcINDBPxGuhIOAJg46Fwdyf7QC4AXARs0fUhI7TumTQrWaleMW1dAsyiKoJ4U
	/bIp4U+TyNJbApqbjPvleWarx4tSNy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759512771; a=rsa-sha256;
	cv=none;
	b=pCfT3NwcX5ajeD4UdaMe/6d9qAZs4139UH2m9Q1Ld2TbRcsl8L4OZKGse/nXE28fPgy0jB
	dPtPn0tmggXn6S/H6n5o7hJHBITNyZjHdKYl9IKZWoEi9MYilNThTBcxS4nTFar8GgH4IF
	lPODsL51gGqFvdT9XeIlHn4q9WGmb6s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4gW15LF/";
	spf=pass (imf15.hostedemail.com: domain of 3wQjgaAgKCKASMOSTAFAGOOGLE.COMLINUX-MMKVACK.ORG@flex--smostafa.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3wQjgaAgKCKASMOSTAFAGOOGLE.COMLINUX-MMKVACK.ORG@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6305c385adbso2706623a12.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 10:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759512770; x=1760117570; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rsO4Y9+CDsR/9B2sBMziOZN6BaFGbVnMznIuFrkfbBE=;
        b=4gW15LF/cQnxGerymTvIuW5n+P6NxD2NpgyfcIHCOq4krVzBpKjsTvJEvTkcK/FJZo
         bz3ca4ajXAcOjSlhpmu3OWtIurr7pYkgm+AEKL45fGs8aFely4s6DWXDj8IL7SV/1v5l
         0fXAIp1A9SplwmwaZIR3NzMOKfXVuCkTx6q0IrzHNec62FRAzoZhQPKlP4j4yahugi86
         mBDz6e0sbn4n9Ns74m4MdvErUfWrg5vuslEcktrJawn2ry48sMjv+HErANr3tLLF7uZJ
         8QJGwBy8Cm8R6YhHSYyQTurZiDTdcrXVqjZBx89vJ7PrxjCt0rniPTfkGiNx/K+A/VS4
         5qvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759512770; x=1760117570;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rsO4Y9+CDsR/9B2sBMziOZN6BaFGbVnMznIuFrkfbBE=;
        b=EF1vswc6x1eHLOgB63FcXF53IU+QkqLPfZqJsdpLviHulWJvOnZNRRRLPnKEnvYu2S
         /9AnfBSb3O3IMsAOh59YNipcI583Tj8+jBDcm6xI8kkRACxZnFfqLq3Eqxlg27d733Cp
         B1B2U335BMGKTbtqYnsUIns8PiJe41IclOwp4TquDoKvgVgd1wqV+vr6Y4vcAYoSBkNX
         uqWMwcCI3ZMQbPlEb3166oIMJOgQ0QB/P3pYvpmiSkhtCAeTu75+sRVh3z9/3eb69Gci
         w/LcmAwEyytdeAVD9vPx4ReiJZlvRZ6vuJmggsZHQobrdULfC+hTNaY+bMTiuy489hkC
         v0CA==
X-Gm-Message-State: AOJu0YxsPR8uwhJsEvsNAO9pCxAT3v8kMrxrHiLYmPnrA4ImOQogDIA3
	OL5m3zuVy8jWRPwNBn7k11a5eS4qUv4s029P6yxfWV8IVNJGJg9RtTUyZx/o9jhftWiZDm6u8j6
	/hkZHKPRXOHzt1gCmwbVwPSQIB/QGYDc1rbHPmi4AxTTcYslO3zEh0gTFL8unm3oWWSUfVj43Bu
	1SRSTWx/KbPzp0CNoIrhMVJD4dgQWJi6+7B1GX67zxpw==
X-Google-Smtp-Source: AGHT+IEICQMptfCkkk6D3e73QyAc9gpdDen9PXr6jWCu1S1AfhHO09M/A91ku8VJ/Ju4zq0R9Vac76YEgDbAjg==
X-Received: from edqm10.prod.google.com ([2002:aa7:c48a:0:b0:636:871c:c865])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3508:b0:639:102b:b8db with SMTP id 4fb4d7f45d1cf-63939c20419mr3602021a12.24.1759512769531;
 Fri, 03 Oct 2025 10:32:49 -0700 (PDT)
Date: Fri,  3 Oct 2025 17:32:29 +0000
In-Reply-To: <20251003173229.1533640-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251003173229.1533640-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003173229.1533640-5-smostafa@google.com>
Subject: [RFC PATCH 4/4] drivers/iommu-debug: Check state of mapped/unmapped
 kernel memory
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 66s384dtq3w55h5jgx8fi9y8ikr6nyc9
X-Rspam-User: 
X-Rspamd-Queue-Id: CD34BA0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1759512771-342446
X-HE-Meta: U2FsdGVkX18chHaKe1D9YyEPsGdWaBm/eM9gphZglNPsAluWT3t0vA9z7jRHmAhOG+sqvujn2B9s7B0tbHW3jAJeZqgOYVSqf0dn5ma7DHcIJTb30tNCJgdRx1TlWcJKhMdZsV1Gw1ecdVYbjuLNklj7LgJDDFwb5C349PmmuuEbL41r+SFjIr0MRh39FsHhi3AEs96GOcsyC3utgxz+49V7i2MjNjVGFj6PMGdbeqXS9gQwaxMOJd0t4noFu2hBmoX4UHeMKCe+CEXieVS/1L1wQx8+eGqvHMs7FvFpR3L59O4UImr/PFPiXo/yLqCzNRHXjggqNZ7BOyaQdeJxqoQXX0STbNIOdKc/HOCsmGaUKEX1HVU4Tt0obVc7jf9+WpmyudEtVG0gbAw+RUqBb8EViJlVdNz+mGtwAskzvVJOjnM4gwXK/mpBKKzgyY6LvDP98GVRMKzVSs2wSDFLBfgXw9Hy1h6rvB/isVG2jUME915Ctf5Xj/vDKPpxwdHCRfXe4ZSy2HL6hSpGHhveJ1JvwTeVaP5jdhD6B9y3pk1grjUv5nVCufJERJIIl21rFxA3/aplAy+d80cb9E0l2yzhGi2xzUn/RPklG3m6yVQfhM7VD0ErEjZcIt5wL3SMyVYqbOItjKcFIkLMoWHSn4L4iJhWzUMpfW5ycqauBzkn+bZxb8BZdVgSrkSH416VCbWpHVvYvGQkJHbtopcH/C5pDPRDZjH22/ZrBwE6uBWVS4YEEyHD3VlX68n1ASIxXY3hlNIxLlKi0DqsiUtpgtMHjQVoutw68W9z+cFKfpV9BgN8j8ugv5FM5Vut/0lafJfALuhxBh36wE2nxNJUrL+7lxbGA8RuI8Tnf8jZbUW12CmrM+YR8KIhrDCxHH2i+B+bnwzJdX7vnn5uUeNyQMwXP+WsW09QNrS3uYTkyr7lTF8x0AJmghcLpex7iU7oYzc33FRMk+VpcXXSsBq
 BH/3Z7Us
 wKpITg+Fj0/E9FXz1G5/p61DfBD9SqyGkRfXupSEyNsH8AP05jd3/UD6EsAbLK/LXHI4ZtZ4evBAnq4tbZ5UTvcz13ALZmrp9vNS8i+aT6O2bwSRvsuN/bxQJWJjKELL8IKRrC4Qn2bqcGuxvgqyy7DlSK923gP3aEo9Q5QbWdBSYZOm0yROhInraH6AUUGEpeL319lHs+coAEhQPcH0cPv/OHkDii//yzY4Ax0yWiKdBxYGqwas12H4StGV2/kn6/dGqp6Q57i0QO5TLZqJqlJ2UYPVr/1IyZzJPcQlMu3sPN7Gk9pe44Qvx/iT2q7viiWHyYpU7KyD3F+9gYz9SYQllkB3gKQAG06TVP4ShebZ6SfdGg1IgVNagWBcsfmILPqa4p1jfPLUwQ2J4raJpuWwSiw2iSPeXhDDES8kzf8Vbh/gXBChOM9yYSEAbdDEJy3MnaX8jy8VDjAPbvfJ4aGnc0pcHo7M7vVQbT88FjpO1nC980h2bzttGSp+Fsy9dluw4Ca7n5YCfr2MV23Rs1EfYuS5r/uK9zwT+Wp36ixXXJMJault2T08AQzXHKzfGi3h57+quo0AgY9vKsZ9K2PT/MK5QcK0eZDMgdqINNK9IeV1Rm4/SEG2mUYaJKInIumqNCWbqWrNQ0laNk69/B+lLjA==
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
 drivers/iommu/iommu-debug.c | 22 ++++++++++++++++++++++
 include/linux/iommu-debug.h |  1 +
 include/linux/mm.h          |  7 +++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/iommu/iommu-debug.c b/drivers/iommu/iommu-debug.c
index cec8f594c7fa..09157fef697e 100644
--- a/drivers/iommu/iommu-debug.c
+++ b/drivers/iommu/iommu-debug.c
@@ -71,6 +71,28 @@ static size_t iommu_debug_page_size(struct iommu_domain =
*domain)
 	return 1UL << __ffs(domain->pgsize_bitmap);
 }
=20
+static unsigned int iommu_debug_page_count(unsigned long phys)
+{
+	unsigned int ref;
+	struct page_ext *page_ext =3D get_iommu_page_ext(phys);
+	struct iommu_debug_metadate *d =3D get_iommu_data(page_ext);
+
+	ref =3D atomic_read(&d->ref);
+	page_ext_put(page_ext);
+	return ref;
+}
+
+void iommu_debug_check_unmapped(const struct page *page, int numpages)
+{
+	if (!static_branch_likely(&iommu_debug_initialized))
+		return;
+
+	while (numpages--) {
+		WARN_ON(iommu_debug_page_count(page_to_phys(page)));
+		page++;
+	}
+}
+
 void iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t=
 size)
 {
 	size_t off;
diff --git a/include/linux/iommu-debug.h b/include/linux/iommu-debug.h
index 8d3ea661660f..aaf893cfafd0 100644
--- a/include/linux/iommu-debug.h
+++ b/include/linux/iommu-debug.h
@@ -17,6 +17,7 @@ void iommu_debug_map(struct iommu_domain *domain, phys_ad=
dr_t phys, size_t size)
 void iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, si=
ze_t size);
 void iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, si=
ze_t size);
 void iommu_debug_init(void);
+void iommu_debug_check_unmapped(const struct page *page, int numpages);
=20
 #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
=20
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 06978b4dbeb8..00f5de44faa0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -36,6 +36,7 @@
 #include <linux/rcuwait.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <linux/iommu-debug.h>
=20
 struct mempolicy;
 struct anon_vma;
@@ -3806,12 +3807,18 @@ extern void __kernel_map_pages(struct page *page, i=
nt numpages, int enable);
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static inline void debug_pagealloc_map_pages(struct page *page, int numpag=
es)
 {
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+	iommu_debug_check_unmapped(page, numpages);
+#endif
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 1);
 }
=20
 static inline void debug_pagealloc_unmap_pages(struct page *page, int nump=
ages)
 {
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+	iommu_debug_check_unmapped(page, numpages);
+#endif
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 0);
 }
--=20
2.51.0.618.g983fd99d29-goog


