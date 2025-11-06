Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16341CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954658E001A; Thu,  6 Nov 2025 11:40:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905AE8E0002; Thu,  6 Nov 2025 11:40:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757ED8E001A; Thu,  6 Nov 2025 11:40:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 639098E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:40:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E936C8631B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:15 +0000 (UTC)
X-FDA: 84080744790.09.EE2F9B0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2615420009
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uHLZJ0e7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3bM8MaQgKCI09359Arwrx55x2v.t532z4BE-331Crt1.58x@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3bM8MaQgKCI09359Arwrx55x2v.t532z4BE-331Crt1.58x@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762447214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NM/GZbyZiL8bh5z49/8PTeWfbgNSwSL55H6jI2E+lmQ=;
	b=tVbafH7ZKay/8xmAtTgUeP+Us2YqLioIKxt4lHE1elHw9oOZrYRGXd9uqk91cabyVm4a4Z
	KFsPjErMfJruupyYghl4YpM2cb04ASyLawolLryeZ+UacSNMUj91ZlFI2sboy4DsvDz6Op
	KuboRw8jWxPOI9Knk1FwqBmOICcmDEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762447214; a=rsa-sha256;
	cv=none;
	b=IMiM5SuYKYLOOH622RMf9delNjj4D9f6x2RNgkrTau8J5Ty7PM0v4WpuMhPkrMC3rNJdC/
	bGaYY2HdxuUwsGChmhYFGy9R8aWGBk+MUpWvrl9DUM0m98Dx7ezTBPUClceH06NuydQM3o
	vL3N8YhGDwF+NZ7DP5FX/1Ovpcf9SJU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uHLZJ0e7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3bM8MaQgKCI09359Arwrx55x2v.t532z4BE-331Crt1.58x@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3bM8MaQgKCI09359Arwrx55x2v.t532z4BE-331Crt1.58x@flex--smostafa.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47769a0a13bso5159015e9.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762447212; x=1763052012; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NM/GZbyZiL8bh5z49/8PTeWfbgNSwSL55H6jI2E+lmQ=;
        b=uHLZJ0e7+6XCg2nXIvFsbiLeJyRfhjm6/c/F1rOGFrtvdRg2wzwW2Jl/MBTpRY7zze
         i7HzifxvB4+enT5dDbVMnNGk2SlVwz8BJVobGkEZeFNI1pU5PnViLmwTI+SzUNNn6+w3
         syWVF42sYFZ5eZ3Y6pa0RFdzp1z52HTg+E1rEnosYt+lFtyNLwMNXf/FtmJcCS7IIHVO
         HJf+e0Yy5zKyyUhXlCFuQtFUaROf6tCBLVyyIc4I0ScVYhtH/FBoUxRnPkfWDB1M8FVS
         2Bm2coTJ6h07QgmLr0UxOH9F4H0bPjzU2VBq/AX/o5HSwncgO6KjFzZx4PNLzq8hsmG8
         gG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447212; x=1763052012;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NM/GZbyZiL8bh5z49/8PTeWfbgNSwSL55H6jI2E+lmQ=;
        b=qIAu8j5jg4yua6o4Dha2p57zZUlbHeH6RxFWLHlmWSXpVAvgPfy0ajxXSjMk01rFL6
         Msm8vpwDazO+UcBQevmLLvKZuT0fQD00gPWTyqMwtFWf/VgccRX8K/QYarJAwjcLsgV+
         jzilXAHQL7qlulVPZyMJRY44UpHC/RI1Wr+H0xwr7mpK9gW7bJyywSHwqkf/8msEVusy
         iy6tctPG1J9stwwElzWOtSUgTcjlG0a9mHfYdy1kWUrYz4WiluPDdRMPOFD3elUF3iig
         LgYcItyvBqEUbdtES1A1UPdttyJ5JeVlAakStzW3DwOvtrNGnkUoZ4MW1Q1Z2z9uUfRI
         erfw==
X-Gm-Message-State: AOJu0YxNvvURX0v4UH2PPNQ1Ep2gjC6u0NEalQXS1ssXLmbmDf/uWc2s
	v4JbN97Mp55iRXy47iES+KI1TTDEyDivd0bpFsgpAg325AFEyznW/KADXFJMrCV381oWpy+bHOg
	YZB87RS/6U4zjbDE0eqYL4JOWP4XhFO2excxw7gVN70CSxB6UFEgjhASoHhy6zso9VI6IuCsTQ8
	xRLatdxMgPbgv/TMSxNTXv3Rw/z9hXWZCfeY+dqKXIiQ==
X-Google-Smtp-Source: AGHT+IFXE6Qsd8iIgYNiQDlI0sqI8FtMmoIupsqXvZU2YQ+mpshBBiH57cinC3fDVEftkTGmawxtksFJp1JKIw==
X-Received: from wrsy17.prod.google.com ([2002:a5d:4ad1:0:b0:429:dc18:dd64])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f87:0:b0:429:b7cd:47ff with SMTP id ffacd0b85a97d-429e33083c8mr6867222f8f.40.1762447212631;
 Thu, 06 Nov 2025 08:40:12 -0800 (PST)
Date: Thu,  6 Nov 2025 16:39:53 +0000
In-Reply-To: <20251106163953.1971067-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251106163953.1971067-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.2.1026.g39e6a42477-goog
Message-ID: <20251106163953.1971067-5-smostafa@google.com>
Subject: [PATCH v2 4/4] drivers/iommu-debug-pagealloc: Check mapped/unmapped
 kernel memory
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>, Qinxin Xia <xiaqinxin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: g9btpncgaxxainsbfdh47mhwaqfrauh7
X-Rspam-User: 
X-Rspamd-Queue-Id: 2615420009
X-Rspamd-Server: rspam10
X-HE-Tag: 1762447213-518428
X-HE-Meta: U2FsdGVkX19oFuwXTdn1btJHUHGEPaivJxE5eRs89dy7CHc3VEc5pA2D4JtSD5qMuL5NQKMNDLgQemV/GCQS62guBgSyFE+szWJAotBrUODMzJt74ReBCz0XvWaWHiB2sjN8B0+5MfsUvQPAKnbJmMMIiWB8Iuz1L7v/4sdjncR0OOr0ix00gyc4KNrbIlqXHFLFri+5ZQMih9XI5su/AT/j+NWzaZUn01Ripl8B8+R00QzP+0DEwuSEHrgtbonBDygXQXJms/hb+4mcathGzBZTI7Er50vxM2tAxri6xZA3aY4bgzcMlnQOgDS9sPFW33VCziGBba1Q+7oYEvRgKtUDYWrOa/AAvsIf6arRZZSfHnFXW3JP0i50/VdgDIc3nfP1PGyEs6zf5g8qX63Bxcpm1mgRzk/xUI3uP90wrhRH7ubn2123cPXwquZh0RveM6wM9pNI7dDFdv+dK7vbsKE6ViLKiUZc5Ap2snZyCCbc+AaTa1qnDdZ+kbRcwXsLmaJBQecmKE7cyrxb8vYX3RYFnU0Eq1D3ZDqW7hLBEQh4jDmqHpH1epCCJ1QNqAufNosw6V38nrog03eLvStmi/q9fcubs6hZQfDoAWg4qcbFGtPGOSWi84kRzfE328mDd9nfRU7nm4tYyNtjuR4oVl4pgbkUWYLWozS/EDJ4JMYoIcW1/2zb8wZhacnziM5/gsfy2sz/t2bbPCH6+muSfb92CudfJfVvI17pp4dBXoddTAs61gUCEzKKtyWxiKeGHvnxyaoenh0nJGhsohQ+sqe8EXKieICOJrfpr+qVNc9Be/siUBEuL18la4nxJurIaCo0Tn4QXc4YCW/x+PMm/98XkjfwfUt/xm7DH4Kq/iRvAQ5J94Vf/XzbhDXn36vDV+qnX1gu9mnRmS/Zk8HFwjMGH2fvvG1tMRoikikWuUNKIjhAnjpByOV6Flu3YX2TG6H+p8jDhRBpucxmIR9
 nbbE5fQi
 s0qJNBtk6on0hG3V3DmbtbYAgL8UJ22q0tSVhPXMJhZ+cwqD1Rt52TEOZzqkwdxpJJJ+s3xSmml4CTS7x1xNyqG9fODa70lZmivXwYPoRUUvKUQug0tUwYaRp+cxT/4TYNVE01uI/b2N/+KpAf8QWh4VuCF66Z98yry54MyjiY4LPjvIONOgSDEj2jWxU0q+BklJqk9UrnjSDPhFCkHtu3yb6iqDJNudHTaRkHTBVk6pyj+3NvHfvNL1MYCl8FiscbogklIO2i5ZUb53yVndvky1yfyZr4OgiCCL932mRXJfxL3Hm0HRyE+ys5BNKRx2QQdVXRtObBxrBmB653XY+9j9o9A1YJIqZC0sXCA6KLdfdMvcWdOdZFsHYUxKILIrKwD0f5Z9imvgjnMRA04SXJ/iHCRCfBdoV3x7EO/nbOvfFVXaSlM0WVk0/Dbu1vFgbBnq8fclft4HLK6lkjaYlg6gOm4kwHgRrL4TtI+2nnjB9UbPh6flh4A3jELliL4/ocQkk75WYYSi22Z/sGB8EQcucXFEv/5l/eLAJ7kaOnGWLSkiQbVGeNWEPwh6rZx1cwrKXQEF31CwT3cS/Ls/wHkOOdpNb1RZTydzkNAxnpqbiwmLSaCjmJK0iecpBGDlpKvAtzUXvDHOdfcPkwlcPpjttp18Pq/Kk0UAnSMdKYf5TImk=
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
Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 19 +++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h | 12 ++++++++++++
 include/linux/mm.h                    |  5 +++++
 3 files changed, 36 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-de=
bug-pagealloc.c
index 0e14104b971c..5b26c84d3a0e 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -71,6 +71,25 @@ static size_t iommu_debug_page_size(struct iommu_domain =
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
+void __iommu_debug_check_unmapped(const struct page *page, int numpages)
+{
+	while (numpages--) {
+		WARN_ON(iommu_debug_page_count(page_to_phys(page)));
+		page++;
+	}
+}
+
 void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size=
_t size)
 {
 	size_t off;
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-de=
bug-pagealloc.h
index 180446d6d86f..84110e4ecfaa 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -22,6 +22,7 @@ void __iommu_debug_unmap(struct iommu_domain *domain, uns=
igned long iova,
 			 size_t size);
 void __iommu_debug_remap(struct iommu_domain *domain, unsigned long iova,
 			 size_t size);
+void __iommu_debug_check_unmapped(const struct page *page, int numpages);
=20
 static inline void iommu_debug_map(struct iommu_domain *domain,
 				   phys_addr_t phys, size_t size)
@@ -44,6 +45,12 @@ static inline void iommu_debug_remap(struct iommu_domain=
 *domain,
 		__iommu_debug_remap(domain, iova, size);
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
@@ -66,6 +73,11 @@ static inline void iommu_debug_init(void)
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
index d16b33bacc32..895a60a49120 100644
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
@@ -3811,12 +3812,16 @@ extern void __kernel_map_pages(struct page *page, i=
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
2.51.2.1026.g39e6a42477-goog


