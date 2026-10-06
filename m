Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E65ECA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87BED6B0098; Tue,  6 Oct 2026 14:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D4C6B0099; Tue,  6 Oct 2026 14:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5E76B009B; Tue,  6 Oct 2026 14:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4554E6B0098
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:32:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3DD8A0309
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:46 +0000 (UTC)
X-FDA: 85293047532.25.2F7BCB8
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0DA0180007
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qO8EqN5l;
	spf=pass (imf02.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791311565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oSZUxao1RfQULD3rGp8RyuZAgKuZ2Qm5VdphDYSiGw=;
	b=JdCKV8xY0d3LirrxK6veXW6asuqI7l8LE0n53IVxpbgJe5KZAfjfvEv/Rj2+ePfTMfhH5L
	Uz3uLdGBVVJ4c27udQEgpD6G3tyQXEX4Mbhcy129z1eI/tucnz2hyyAIIAtkTeJUjzpfuK
	9KmU/yCUrfVuOH8T5QSva5yhT6MYaH8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qO8EqN5l;
	spf=pass (imf02.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791311565;
	b=3GfwdbvoNidUhSmsTQAMSCvKMYdlraYlXpVbM18gSbqz/R7F7DlnHT+g0XP7F10ns5XVk6
	yYN6ktMvbP8mU47H/izRdXXYlsYIQdC05iSPbXHoEk7s351SFc6RWTB8XiipEkhtwmjj7c
	eL89PrkUt5Exz4RYg4D0rSfnhW/KuJ4=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2e8c710847so127263366b.0
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311564; x=1791916364; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2oSZUxao1RfQULD3rGp8RyuZAgKuZ2Qm5VdphDYSiGw=;
        b=qO8EqN5lZFMAMj8oUeAFv6oXOCMlgnAYCnFPEvsz5Q9y2Gv9sD7uFALTX6vPLoYtgX
         X9t1FSLiJvstDj9bGAPgPKALk+T1rSYT7d125lQPzbsb3UJCkDGHL/tdUphQeqgXD+cB
         L3Q1y66/ZGLGBWcmCzBZ6iIGF9S5JUUYlzB9CBgGkswmTudboGuDIhp+0Sxxz5p/IGnp
         ANCIWTYH0OFLA4bECpKhgp3XVyXOkR/FxbY7EF/7kmHg2cRONRhBDNewZFD2TlzEog5j
         k3edKHJ5UMFIsmuzExaxCRHUXRoenPNW7L24tbroEE4qH1XXuQEr1HN6t8eMmiPZxenT
         29/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311564; x=1791916364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2oSZUxao1RfQULD3rGp8RyuZAgKuZ2Qm5VdphDYSiGw=;
        b=V6mCm9kfPhShUluEF2aT4X5IrQLHx0OxR+ObmBM6OFdEr2D/hwH/6tsFFyABGNgwEv
         FWgyDmteGynuu6PvdouuYfGZfRxFxRHp1UulTL3DDe4Zo8xAqV5aGMYXl5q42DYtEePN
         v9J8exf2ZX2snTAw9OEBaePZL7vyjXCFkvo2vTSyKV8uvf8wQla5ZctZ+ljdbGjd875S
         X3exNI7YF/wQks9RmPKoi8EbDXbHnB76a2dzrG12Fzs4Tm2ZaANkqJygsz03dPc6JX/z
         pdSNySuXvAcrVo/HwFU9w91RB5ZN1XSNJTHbaaBUEEN4ZDbh50MTR4Inlkzwj4PuNHGu
         jZ/w==
X-Forwarded-Encrypted: i=1; AKwUvBwsoka2eYf76PW/qmhRLuoKQbPvwjC0VUjefQDCR6QSsJegmbe9/MIDBeIuRH1LkFVtbYDbTHiZgg==@kvack.org
X-Gm-Message-State: AFuF++m1sfYHpc7Yr2Ced0qAmpwlvWCRosTiwz6jNoa9rS3UdEIdbMTA
	5w+MO/foeMc/4ojwPCv6NaurY2fmhhlpHSIldJq8pK9g5xqhEGMxlXsP
X-Gm-Gg: AYBFou30A8GFoIcy8QfTkGDem6NujaIuqRWeyWyNufEIVaRCJcjfK2Egmkg/HzsOI9x
	YBCJoyX2Iz98b1hHvG6qyha1SrI1ST738KUx465I2/dIeZiCjfucVaML4mHDZEgP6VzHL0f8Mqd
	0NYTmy7GiZWzJdhqNGbAG7w6oQofVFefkPD91gflx+zpgnT1LIKKRI50Y29UlZiNEBr0FWOtrOp
	Qdt8EkRnKV1BFinNTS0LIuTln/UveA1UtODOeZf4b9PzX5TgBAFQPxU0Woc0IfR6T6Bs9li3Afi
	6N+1NVueY3b6bI9XyQxHkO194bnoRRnV0yRWnt4PxEbP4Oy3TEOALBCDadCOTPVYibvMm4L4v56
	AmvB2AbfVkZ0M++ScRa80/MyNlSmZmEh8m7X7/D0SdE4B1BfNxIep+W4Nka5xr5Nkb8GqOMyTFu
	Zd7efm9+HV2hyoU1L1sY1yt0EeILAOLmapmem9VRuVHezij3taWofDwJXXTA3t16auzBGTzLs81
	RwBmEc/skWjQ828YMZpyiPcN/QBrhPhdMx8O1BjXr2tAJjyNrPjCoXBJvThrbU7pUEYM/stJEX8
	R78/v9UW02/Ptd9rykriivCp4RiiXvVXEPQ=
X-Received: by 2002:a17:906:ef0a:b0:c2a:f571:312f with SMTP id a640c23a62f3a-c3169fb0c2fmr247672166b.20.1791311563344;
        Tue, 06 Oct 2026 11:32:43 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:42 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 4/9] iommufd: Track the domains of pages that are not pinned
Date: Tue,  6 Oct 2026 18:32:30 +0000
Message-ID: <20261006183235.16576-5-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DA0180007
X-Stat-Signature: hmqy7sdxuwjuean9wdcbpdpyzsrc8ni3
X-HE-Tag: 1791311564-206032
X-HE-Meta: U2FsdGVkX19bfLgauqRi5ShtuZWoPTLVuO69oofpkWikiV8MbYkmn+2lVoxqgvPvRcEhC4HZRenDdCNFmT2ECN2g6ezpRA24+OGrUpEFmyWkxjBFu0iNooTDU5L5QAGAJNQ52Gs/DG9tXzy2EO+E67EGLK7dLJD9Absih4NNaE2ZqhHgQzn8+kpRuTbEQ23voA0rv5AyRbUr59K9ctBYzNt2IXfIWqJ/csrzB8TWa8b/P0bnIABJTGCcN6HBMGosPL/Rw6VjSDledA1gKmfL+YjejGMRLPNmWBdm2fhGbJSaqxU9KTB5+DLj1NFYAWQJt9UIqeSFRvnpj6IVUagSYB9O1GP6z6C93UY9e9zWfd5raM58s4LvVLpYQxET55cPrLSexSrrtN+sx8ksu+MuNcpMXSKiopsbx2WaAu8ixabzOt1DO2vXkf/bf3h3akKGX56gG52lirCXAp04RKAcQJUgW6z+sBnV4UHzYnYScXxfmN30tfJThmm/iaaxWUqKr1FpXe6XdvPEOS6nt2carse+VLS/igAry+vjxS40Nt+B5GLPOlTY9vrSw++/RIPVJWUL1l3mcrJRofLq1jGzgi1jCRsCA2sjJ/zyHFPvWiiogfvk+h5kkPejql8VU4krQZlyO4lJ3BDjDKd8B0fLQ15BN65mzFdSr4U6SRdKgEOvASdivUDxx85XYQ2sKXEafgOFcXu9mzLZMnwDycsKDwMSpInl68YMiIABzbsv+nDE8/JcMjGCVJQcMSPJW8AVb2BLg7QkgQzKKUzCGww20AtARuebfCdt2fvLvYy2R3WdPHXq8SVzxWhGPzXZ7cYHekkX92I+rrC9I/WmqJwc7mvkyYSdCUiQ8eGKJNflHbkzWlSL44qOE0qSdtOdnvaHSZZzu8ZrtbLSeSVeSLXd5foeUOugl+0jV+mrZib6LAXpqvqBoPbZlysZYcrP9o/Opdd2HRTxI4mtXqinHyC
 eTyedQ9M
 PC0NCM2zagDYqZT7nBLni6QSSwaCOgEfXxtMC+dolrBgzikYVM1EtMmryaUujbne0+g9EjiOqbRdFAz1jnHH/uX6yYlnyoB19ciaCgxmwzYg+J4GQ8QdBoJlxOXDsoYMvjElY8+pxCzu0pyYCJxnf9CnF+dUdlJ/sn+icDAqNlYUi1t/dI5/m31yh3jOtPHkLPxZvpa2+9qnoSL3YbrxzWBh1X6hN2FKv7DMItkgJrnEGS1m0pQxEK8IpewNIhCnUXXKRrxaTYM3ORzrwMDCKHJIvaLwteDTJePvDYueYZmeg91zH2NlrKWafYjzKiPUwDaX0UM+xzqw90sZpeMLbDAnE7PBUmm0iCubceemelPPNafGcDTTMFC2E7TRPTM2stheFxcAbT1K6ovznk11oYUqwQQw4d8/jnDmKPWhziKcfSXP1rBObLbZKxUha6VynF6JNcKKjY9uhPU4SdibYhXnd9vyKcUeQK4ym6AhaZUOVonUaACcj5Tqev6eUwZ9srgFhFKhzAh85zCW5V02QRksWYR9uv953lZ63
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

Memory provider pages, added in the next patch, are not pinned and can
change under the domains that map them, as a dma-buf can. They need the
same list of (area, domain) pairs that the dma-buf revoke uses.

Move that list from struct iopt_pages_dmabuf to struct iopt_pages.

No functional change.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/io_pagetable.c | 24 +++++-----
 drivers/iommu/iommufd/io_pagetable.h | 33 +++++++++-----
 drivers/iommu/iommufd/pages.c        | 67 ++++++++++++++--------------
 3 files changed, 67 insertions(+), 57 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 24d4917105d9..bcd531acc9dd 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -1008,14 +1008,14 @@ static void iopt_unfill_domain(struct io_pagetable *iopt,
 				WARN_ON(!area->storage_domain);
 			if (area->storage_domain == domain)
 				area->storage_domain = storage_domain;
-			if (iopt_is_dmabuf(pages)) {
+			if (iopt_pages_tracked(pages)) {
 				if (!iopt_dmabuf_revoked(pages))
 					iopt_area_unmap_domain(area, domain);
-				iopt_dmabuf_untrack_domain(pages, area, domain);
+				iopt_pages_untrack_domain(pages, area, domain);
 			}
 			mutex_unlock(&pages->mutex);
 
-			if (!iopt_is_dmabuf(pages))
+			if (!iopt_pages_tracked(pages))
 				iopt_area_unmap_domain(area, domain);
 		}
 		return;
@@ -1033,8 +1033,8 @@ static void iopt_unfill_domain(struct io_pagetable *iopt,
 		WARN_ON(area->storage_domain != domain);
 		area->storage_domain = NULL;
 		iopt_area_unfill_domain(area, pages, domain);
-		if (iopt_is_dmabuf(pages))
-			iopt_dmabuf_untrack_domain(pages, area, domain);
+		if (iopt_pages_tracked(pages))
+			iopt_pages_untrack_domain(pages, area, domain);
 		mutex_unlock(&pages->mutex);
 	}
 }
@@ -1065,15 +1065,15 @@ static int iopt_fill_domain(struct io_pagetable *iopt,
 			continue;
 
 		guard(mutex)(&pages->mutex);
-		if (iopt_is_dmabuf(pages)) {
-			rc = iopt_dmabuf_track_domain(pages, area, domain);
+		if (iopt_pages_tracked(pages)) {
+			rc = iopt_pages_track_domain(pages, area, domain);
 			if (rc)
 				goto out_unfill;
 		}
 		rc = iopt_area_fill_domain(area, domain);
 		if (rc) {
-			if (iopt_is_dmabuf(pages))
-				iopt_dmabuf_untrack_domain(pages, area, domain);
+			if (iopt_pages_tracked(pages))
+				iopt_pages_untrack_domain(pages, area, domain);
 			goto out_unfill;
 		}
 		if (!area->storage_domain) {
@@ -1102,8 +1102,8 @@ static int iopt_fill_domain(struct io_pagetable *iopt,
 			area->storage_domain = NULL;
 		}
 		iopt_area_unfill_domain(area, pages, domain);
-		if (iopt_is_dmabuf(pages))
-			iopt_dmabuf_untrack_domain(pages, area, domain);
+		if (iopt_pages_tracked(pages))
+			iopt_pages_untrack_domain(pages, area, domain);
 		mutex_unlock(&pages->mutex);
 	}
 	return rc;
@@ -1315,7 +1315,7 @@ static int iopt_area_split(struct iopt_area *area, unsigned long iova)
 		return -EBUSY;
 
 	/* Maintaining the domains_itree below is a bit complicated */
-	if (iopt_is_dmabuf(pages))
+	if (iopt_pages_tracked(pages))
 		return -EOPNOTSUPP;
 
 	if (new_start & (alignment - 1) ||
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 887ed94474c7..5389227eb6ff 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -70,15 +70,14 @@ void iopt_area_unfill_domain(struct iopt_area *area, struct iopt_pages *pages,
 void iopt_area_unmap_domain(struct iopt_area *area,
 			    struct iommu_domain *domain);
 
-int iopt_dmabuf_track_domain(struct iopt_pages *pages, struct iopt_area *area,
-			     struct iommu_domain *domain);
-void iopt_dmabuf_untrack_domain(struct iopt_pages *pages,
-				struct iopt_area *area,
-				struct iommu_domain *domain);
-int iopt_dmabuf_track_all_domains(struct iopt_area *area,
-				  struct iopt_pages *pages);
-void iopt_dmabuf_untrack_all_domains(struct iopt_area *area,
-				     struct iopt_pages *pages);
+int iopt_pages_track_domain(struct iopt_pages *pages, struct iopt_area *area,
+			    struct iommu_domain *domain);
+void iopt_pages_untrack_domain(struct iopt_pages *pages, struct iopt_area *area,
+			       struct iommu_domain *domain);
+int iopt_pages_track_all_domains(struct iopt_area *area,
+				 struct iopt_pages *pages);
+void iopt_pages_untrack_all_domains(struct iopt_area *area,
+				    struct iopt_pages *pages);
 
 static inline unsigned long iopt_area_index(struct iopt_area *area)
 {
@@ -194,7 +193,8 @@ enum iopt_address_type {
 	IOPT_ADDRESS_DMABUF,
 };
 
-struct iopt_pages_dmabuf_track {
+/* An area of the pages mapped into a domain, for pages that are not pinned. */
+struct iopt_pages_track {
 	struct iommu_domain *domain;
 	struct iopt_area *area;
 	struct list_head elm;
@@ -205,7 +205,6 @@ struct iopt_pages_dmabuf {
 	struct phys_vec phys;
 	/* Always PAGE_SIZE aligned */
 	unsigned long start;
-	struct list_head tracker;
 	/*
 	 * true if the exporter's phys is CPU RAM (map with IOMMU_CACHE, no
 	 * IOMMU_MMIO); false for MMIO/BAR memory (map with IOMMU_MMIO).  Set
@@ -253,6 +252,12 @@ struct iopt_pages {
 	struct rb_root_cached access_itree;
 	/* Of iopt_area::pages_node */
 	struct rb_root_cached domains_itree;
+	/*
+	 * Of iopt_pages_track::elm.  Pages that are not pinned can change
+	 * under the domains that map them, so every (area, domain) that maps
+	 * them is listed here.  See iopt_pages_tracked().
+	 */
+	struct list_head tracker;
 };
 
 static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
@@ -262,6 +267,12 @@ static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
 	return pages->type == IOPT_ADDRESS_DMABUF;
 }
 
+/* The pages are not pinned, so their domains are tracked in pages->tracker. */
+static inline bool iopt_pages_tracked(struct iopt_pages *pages)
+{
+	return iopt_is_dmabuf(pages);
+}
+
 static inline bool iopt_dmabuf_revoked(struct iopt_pages *pages)
 {
 	lockdep_assert_held(&pages->mutex);
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index f9b2ae6d7e96..d68f6eea836d 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1392,6 +1392,7 @@ static struct iopt_pages *iopt_alloc_pages(unsigned long start_byte,
 	pages->npages = DIV_ROUND_UP(length + start_byte, PAGE_SIZE);
 	pages->access_itree = RB_ROOT_CACHED;
 	pages->domains_itree = RB_ROOT_CACHED;
+	INIT_LIST_HEAD(&pages->tracker);
 	pages->writable = writable;
 	if (capable(CAP_IPC_LOCK))
 		pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
@@ -1442,13 +1443,13 @@ struct iopt_pages *iopt_alloc_file_pages(struct file *file,
 static void iopt_revoke_notify(struct dma_buf_attachment *attach)
 {
 	struct iopt_pages *pages = attach->importer_priv;
-	struct iopt_pages_dmabuf_track *track;
+	struct iopt_pages_track *track;
 
 	guard(mutex)(&pages->mutex);
 	if (iopt_dmabuf_revoked(pages))
 		return;
 
-	list_for_each_entry(track, &pages->dmabuf.tracker, elm) {
+	list_for_each_entry(track, &pages->tracker, elm) {
 		struct iopt_area *area = track->area;
 
 		iopt_area_unmap_domain_range(area, track->domain,
@@ -1598,7 +1599,6 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
 	pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
 	pages->type = IOPT_ADDRESS_DMABUF;
 	pages->dmabuf.start = start - start_byte;
-	INIT_LIST_HEAD(&pages->dmabuf.tracker);
 
 	rc = iopt_map_dmabuf(ictx, pages, dmabuf);
 	if (rc) {
@@ -1609,16 +1609,16 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
 	return pages;
 }
 
-int iopt_dmabuf_track_domain(struct iopt_pages *pages, struct iopt_area *area,
-			     struct iommu_domain *domain)
+int iopt_pages_track_domain(struct iopt_pages *pages, struct iopt_area *area,
+			    struct iommu_domain *domain)
 {
-	struct iopt_pages_dmabuf_track *track;
+	struct iopt_pages_track *track;
 
 	lockdep_assert_held(&pages->mutex);
-	if (WARN_ON(!iopt_is_dmabuf(pages)))
+	if (WARN_ON(!iopt_pages_tracked(pages)))
 		return -EINVAL;
 
-	list_for_each_entry(track, &pages->dmabuf.tracker, elm)
+	list_for_each_entry(track, &pages->tracker, elm)
 		if (WARN_ON(track->domain == domain && track->area == area))
 			return -EINVAL;
 
@@ -1627,21 +1627,20 @@ int iopt_dmabuf_track_domain(struct iopt_pages *pages, struct iopt_area *area,
 		return -ENOMEM;
 	track->domain = domain;
 	track->area = area;
-	list_add_tail(&track->elm, &pages->dmabuf.tracker);
+	list_add_tail(&track->elm, &pages->tracker);
 
 	return 0;
 }
 
-void iopt_dmabuf_untrack_domain(struct iopt_pages *pages,
-				struct iopt_area *area,
-				struct iommu_domain *domain)
+void iopt_pages_untrack_domain(struct iopt_pages *pages, struct iopt_area *area,
+			       struct iommu_domain *domain)
 {
-	struct iopt_pages_dmabuf_track *track;
+	struct iopt_pages_track *track;
 
 	lockdep_assert_held(&pages->mutex);
-	WARN_ON(!iopt_is_dmabuf(pages));
+	WARN_ON(!iopt_pages_tracked(pages));
 
-	list_for_each_entry(track, &pages->dmabuf.tracker, elm) {
+	list_for_each_entry(track, &pages->tracker, elm) {
 		if (track->domain == domain && track->area == area) {
 			list_del(&track->elm);
 			kfree(track);
@@ -1651,36 +1650,36 @@ void iopt_dmabuf_untrack_domain(struct iopt_pages *pages,
 	WARN_ON(true);
 }
 
-int iopt_dmabuf_track_all_domains(struct iopt_area *area,
-				  struct iopt_pages *pages)
+int iopt_pages_track_all_domains(struct iopt_area *area,
+				 struct iopt_pages *pages)
 {
-	struct iopt_pages_dmabuf_track *track;
+	struct iopt_pages_track *track;
 	struct iommu_domain *domain;
 	unsigned long index;
 	int rc;
 
-	list_for_each_entry(track, &pages->dmabuf.tracker, elm)
+	list_for_each_entry(track, &pages->tracker, elm)
 		if (WARN_ON(track->area == area))
 			return -EINVAL;
 
 	xa_for_each(&area->iopt->domains, index, domain) {
-		rc = iopt_dmabuf_track_domain(pages, area, domain);
+		rc = iopt_pages_track_domain(pages, area, domain);
 		if (rc)
 			goto err_untrack;
 	}
 	return 0;
 err_untrack:
-	iopt_dmabuf_untrack_all_domains(area, pages);
+	iopt_pages_untrack_all_domains(area, pages);
 	return rc;
 }
 
-void iopt_dmabuf_untrack_all_domains(struct iopt_area *area,
-				     struct iopt_pages *pages)
+void iopt_pages_untrack_all_domains(struct iopt_area *area,
+				    struct iopt_pages *pages)
 {
-	struct iopt_pages_dmabuf_track *track;
-	struct iopt_pages_dmabuf_track *tmp;
+	struct iopt_pages_track *track;
+	struct iopt_pages_track *tmp;
 
-	list_for_each_entry_safe(track, tmp, &pages->dmabuf.tracker,
+	list_for_each_entry_safe(track, tmp, &pages->tracker,
 				 elm) {
 		if (track->area == area) {
 			list_del(&track->elm);
@@ -1697,6 +1696,7 @@ void iopt_release_pages(struct kref *kref)
 	WARN_ON(!RB_EMPTY_ROOT(&pages->domains_itree.rb_root));
 	WARN_ON(pages->npinned);
 	WARN_ON(!xa_empty(&pages->pinned_pfns));
+	WARN_ON(!list_empty(&pages->tracker));
 	if (iopt_is_dmabuf(pages) && pages->dmabuf.attach) {
 		struct dma_buf *dmabuf = pages->dmabuf.attach->dmabuf;
 
@@ -1705,7 +1705,6 @@ void iopt_release_pages(struct kref *kref)
 		dma_resv_unlock(dmabuf->resv);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
-		WARN_ON(!list_empty(&pages->dmabuf.tracker));
 	} else if (pages->type == IOPT_ADDRESS_FILE) {
 		fput(pages->file);
 	}
@@ -1790,7 +1789,7 @@ static void __iopt_area_unfill_domain(struct iopt_area *area,
 
 	lockdep_assert_held(&pages->mutex);
 
-	if (iopt_is_dmabuf(pages)) {
+	if (iopt_pages_tracked(pages)) {
 		if (WARN_ON(iopt_dmabuf_revoked(pages)))
 			return;
 		iopt_area_unmap_domain_range(area, domain, start_index,
@@ -1958,8 +1957,8 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 		return 0;
 
 	mutex_lock(&pages->mutex);
-	if (iopt_is_dmabuf(pages)) {
-		rc = iopt_dmabuf_track_all_domains(area, pages);
+	if (iopt_pages_tracked(pages)) {
+		rc = iopt_pages_track_all_domains(area, pages);
 		if (rc)
 			goto out_unlock;
 	}
@@ -2024,8 +2023,8 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 	}
 	pfn_reader_destroy(&pfns);
 out_untrack:
-	if (iopt_is_dmabuf(pages))
-		iopt_dmabuf_untrack_all_domains(area, pages);
+	if (iopt_pages_tracked(pages))
+		iopt_pages_untrack_all_domains(area, pages);
 out_unlock:
 	mutex_unlock(&pages->mutex);
 	return rc;
@@ -2065,8 +2064,8 @@ void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages)
 		WARN_ON(RB_EMPTY_NODE(&area->pages_node.rb));
 	interval_tree_remove(&area->pages_node, &pages->domains_itree);
 	iopt_area_unfill_domain(area, pages, area->storage_domain);
-	if (iopt_is_dmabuf(pages))
-		iopt_dmabuf_untrack_all_domains(area, pages);
+	if (iopt_pages_tracked(pages))
+		iopt_pages_untrack_all_domains(area, pages);
 	area->storage_domain = NULL;
 out_unlock:
 	mutex_unlock(&pages->mutex);

