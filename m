Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E684ACC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8395B6B00AE; Wed, 14 Oct 2026 05:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810FA6B00B0; Wed, 14 Oct 2026 05:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8EF6B00B1; Wed, 14 Oct 2026 05:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 42C9B6B00AE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:37:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB7BFA04AB
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:45 +0000 (UTC)
X-FDA: 85320729690.04.8265990
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id DACDF4000B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W9sZxD8P;
	spf=pass (imf01.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bE4GOYNuN0L2A43+aeT8XcVziQfGC7lOtj0K7aqEDA=;
	b=zWPmAkot2laAEtBy4Cu6iq51MZq2WxvTVTRSlk372k67oy4l9hVGYVhXeW0zJVU3ltntm2
	A2cd0bdPk2Q6PKNr6p5GvT9NMZGEs5Ia+q+IuyQPVgpIOoFsQRdbwz0DEOXO9Kk6xgaWvu
	C2JeZCgMn4wx5MXZXyPHguKqxLoBaSw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970663;
	b=MkUNPM/8oG3RLpCCsqwUeHecpti/amph19HAM8YcqpliR5J/RDddL46vJl7DV+AvDHujtq
	4xeGUC9edIa041wiVAnnZWlOuST3Eu3v56SGR+smuyZQ51dEz6EW2YffTzWOqNcu5baKg8
	ti8jhZ9lAjZmWmBcjCBSXnFTQkml378=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W9sZxD8P;
	spf=pass (imf01.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1ad2e2391so11961035e9.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970662; x=1792575462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2bE4GOYNuN0L2A43+aeT8XcVziQfGC7lOtj0K7aqEDA=;
        b=W9sZxD8PHGyQwql4YXfRLpb7KGPtc+MQ6DiqCGAKd2Z7MxuRuJitQUth7kCHmqPmYE
         0uPGht9U2ialy30iQG4siXKC67DbVr5o+numtEDWnBZSLAf0fwz/U2CApCDnsEmucFPD
         9sTDgR4Pmes/sZctYudng4xmU59mcDInnrESnrOrOT2d81iKZO9XbX19/DX614WeuHmC
         tcmQRfl/fe0sucAbvQEIelE/gApeqweRnTOGnWYQ8sEGuWXA1cPna1vFq5Ig4E8JLgnc
         gnBcnpbRMmb2UaHloz5ysitTnbzBehJcW8dT7dqmWusFqHtqh1LHA6n4DAI0ykhmkUaS
         yJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970662; x=1792575462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2bE4GOYNuN0L2A43+aeT8XcVziQfGC7lOtj0K7aqEDA=;
        b=f9btKvJqVYjZ2BFA4MfspKDwmTAR3AbKDTAjJZ+KVFEQBUS775HO+Uq89T5Av7AlFZ
         vm/QBMeISptvpsBu1k9h7xm8jzbd3pr/Cb9EIevAWYPd7Y3SpbRfQRBYIofmKPDmhv17
         Q1yn9pudp25zDoMrO//VOleKkF/NNx8ne4owegYtJrLGQAnauOLeF9jEPjUkaUeHoz0o
         ywF7Wmn4mtlJoVtZjhQyRrE/h/UaJ8ayZcqj5M4bYBHMYwyHcPN2E37EqL/qcwGD+ajG
         M17JKm6ESBwShR0d4J0pNhPgU1jnwTBaALptOH/6nS1u28ef/Z9V2BEVsaG0sKROHeeS
         YzWA==
X-Forwarded-Encrypted: i=1; AKwUvBwaAklDcsS5+Cz89kf9oBPKa1fQLzuM+mZmcFOIMxAiUkV7l1SsZPr3kzm/Tt9S+TEggqTsgXoy8g==@kvack.org
X-Gm-Message-State: AFq9FYKg3ajzd50U4zxGXlg3kcSaiahKomSxC3DfPaGujsAYxLAm7paf
	euIdPCFnINYmNhpu3fAZOxVhpFigXyctUgPc/GK7LrkrAtwfbLoHK0S6
X-Gm-Gg: AYBFou1fkQgmKU+MoeDSRVJUpMvGBiDZLz0KuezZ8aioMx8VqZbkAoED4itqnNkEt0q
	sE506o1vH/0zB+5RAnkQyyDa7OiWKCPmZ49UJNedpFr8VDAGaWE5nAQzx2rp4K1j7D50cjoFQiy
	U2FZ72cx5TbYCjbDYbHILZE/7ygW7zYb1ssNf5GoHLRpRROPS/L+WWKmwrUiGhK/cQm+O43Im5N
	cZ27GU3BA4mayPhp/PauTvsc+75SJjpxmw0XpXeLWMuFUICGbPZZSDaEUJibY/n43uYQ0nklvO3
	Q/8P8269r+adcEDafbUucLiX8pbNixGqsKOzHCOqboI65lM7YVbfvsgcLh1C/rbvN1naoxzJGTy
	Csj4AS+MDCuOvPBXPPa6nKltuPEYeuObqQcCOf//6L+78biQVrMTiC3WrVIustlgJYL9J9E1HtR
	FCdJna8bZQIpI63H+591vovgIWdAxfd1m0Lh0kCBxf8HXXVT8WT+kFtq7lYwR7DCa+a4sMzdS/5
	Zc33BNUUMupESfTKVrJ43jhRJgCBch4+t+QL3fNOD/Nn+rS6DU+jA6Kw82j4YJrV/soXRcqHbRq
	biCBsvHhV+pdRJ4EAQC58PJ0liF29mEneJc=
X-Received: by 2002:a05:600c:5493:b0:4a1:78da:d271 with SMTP id 5b1f17b1804b1-4a18e4ee976mr332971435e9.30.1791970662375;
        Wed, 14 Oct 2026 02:37:42 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:41 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
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
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 05/11] iommufd: Track the domains of pages that are not pinned
Date: Wed, 14 Oct 2026 09:37:27 +0000
Message-ID: <20261014093733.90312-6-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DACDF4000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6d1dhrain9rbs71gux6ba98hbjkum6i9
X-HE-Tag: 1791970663-122919
X-HE-Meta: U2FsdGVkX1+J0dHQzxLfEySsYiI/chILM5kfuO8qCZCTh+p9Oi78ikiQJWfPQ9a6vpzoj0bUBZwiS3d9olQ/Sk8o+q2ZnITVImdphvQLFpFITRiAewq2uGpMnR3/d8TYRDnvV8tkwKGKy6f/CNKClJ0NZ+gKumF8qP+e2iS9NNC5xrDSxDXb47GuRa49i6yu3YwL9JuvNEPa+uwXjJptfN7GP0D3p+HA36YgIfzeKgQcdZ3rWpSzBP5w1rhf5p/iJmO5OtRBuh4vCNXAhSZ/D9mZYqOC+mDtFk+6v/UY4kIaW+vwlfvxG0Au2t4CdFVM4Ov4zP4IbaNB6wBFsHeWYIJRGRYvUmLGOllTbY8wt87GeIhnd7TLK9pcz1UcfjCVaecWPcPQf37i+HLdmeUFexixKVtnBjDLCt7D92EDMZyEm0fRKiLbxZxTlkfqTfpNPbTS6xNUsGbqO6G6/70QYXjrg+saRmLPiMS6XPUt/RrJXOt1M70W+JbAc3fOCC1pLOCHyiM0i4PUOtPTeOFBIsKLEFkZU+zHijmp2YvDsM03AOvsNP+jW8EyLrCrXhAqBr6aY/91CnkRC8GSr5RUA1S9wA/6gGTAIMoCoWhdddDKkxefRNIvixPz6wk8tlZIF6Q4C0HTEzPmSuJbuWmQAJTD1b8a4oz0mLVCo0pp+Ftelj9+eCj5XTid6JORBEt/FPHjbsjcVPCEiLkWZ7376uz+jTqDTDU9Mba8acddlFWkScA1VVnpXjWJwN9GfZNip+UbeB2qTA4LlHQ2JM9WYbbeYyoK7jckqreQhPpJR7P3vCjpCFIHmIg9rWF4aku37SQ4zf93xtFe/dqG4NMTZbCJBMyGjVYGz65tvePgCbpxFsKUtdWiu0IEoOZOiJ0OHoh/KUmOI9xq4DZsMo3R5VUdHxgbA+aamkjH9MRZ71933HaU7ZhKusoBDuNK7UZ4aoidOmU69KPemzCvzwQ
 TBtz+ycd
 I9PVQuw/jkxRGnjwKHhW1Hsf5Am1hZEmC+3WbmcDS0naWGEFQFJCJ/MozSe9o3q8FZTXNQ42uLSif6Zw3t4KXs3zNoa95Ixw7+PdwN4x7mdpOduFtzXJQuShlXjpKHqJfhrgMfHrTQYBMMi3g9QRXfxyrVQUZmUFlMFZjIMlPy4GTKRdGoIyWKXYf/oDuK/UOhXZfV3cv4IqRpUyEw1C58dhE4FWgVsYmkWqnR69FPJ1sqoogr64fI6dLEdw2WpDOLaunggbPsbt61rhtXdYaag9WGZWCJarz1rG+lYiqJm7E/duSIM48l3bGYZyeWSpZxHmtz34+pIFEsTF6WTEaChvQbeJKdbzaSiIujckyngXCQtNB8P3iIl3HWAdNAGQ+JTSv8jBo9E29qx2KzF9C4RlEIbQUINGB6RBaH9WWP+FSfa6ZBBo/AnrPknThSMqXsdwRcqryJ312dP91/KB+ZDpf4KDnByoCShfVaR82hvC9BlHdE6I/wJZDU6SaFgJEkq3b3qFmyWnz7yHVHZJBu/5NTyWux32LX/vh
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

Assisted-by: Claude:claude-opus-5-5
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
index 27e3e311d395..ba539bfaac31 100644
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
 };
 
 /*
@@ -246,6 +245,12 @@ struct iopt_pages {
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
@@ -255,6 +260,12 @@ static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
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
index 03c8379bbc34..660af3d46f5e 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1384,6 +1384,7 @@ static struct iopt_pages *iopt_alloc_pages(unsigned long start_byte,
 	pages->npages = DIV_ROUND_UP(length + start_byte, PAGE_SIZE);
 	pages->access_itree = RB_ROOT_CACHED;
 	pages->domains_itree = RB_ROOT_CACHED;
+	INIT_LIST_HEAD(&pages->tracker);
 	pages->writable = writable;
 	if (capable(CAP_IPC_LOCK))
 		pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
@@ -1434,13 +1435,13 @@ struct iopt_pages *iopt_alloc_file_pages(struct file *file,
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
@@ -1557,7 +1558,6 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
 	pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
 	pages->type = IOPT_ADDRESS_DMABUF;
 	pages->dmabuf.start = start - start_byte;
-	INIT_LIST_HEAD(&pages->dmabuf.tracker);
 
 	rc = iopt_map_dmabuf(ictx, pages, dmabuf);
 	if (rc) {
@@ -1568,16 +1568,16 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
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
 
@@ -1586,21 +1586,20 @@ int iopt_dmabuf_track_domain(struct iopt_pages *pages, struct iopt_area *area,
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
@@ -1610,36 +1609,36 @@ void iopt_dmabuf_untrack_domain(struct iopt_pages *pages,
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
@@ -1656,6 +1655,7 @@ void iopt_release_pages(struct kref *kref)
 	WARN_ON(!RB_EMPTY_ROOT(&pages->domains_itree.rb_root));
 	WARN_ON(pages->npinned);
 	WARN_ON(!xa_empty(&pages->pinned_pfns));
+	WARN_ON(!list_empty(&pages->tracker));
 	if (iopt_is_dmabuf(pages) && pages->dmabuf.attach) {
 		struct dma_buf *dmabuf = pages->dmabuf.attach->dmabuf;
 
@@ -1664,7 +1664,6 @@ void iopt_release_pages(struct kref *kref)
 		dma_resv_unlock(dmabuf->resv);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
-		WARN_ON(!list_empty(&pages->dmabuf.tracker));
 	} else if (pages->type == IOPT_ADDRESS_FILE) {
 		fput(pages->file);
 	}
@@ -1749,7 +1748,7 @@ static void __iopt_area_unfill_domain(struct iopt_area *area,
 
 	lockdep_assert_held(&pages->mutex);
 
-	if (iopt_is_dmabuf(pages)) {
+	if (iopt_pages_tracked(pages)) {
 		if (WARN_ON(iopt_dmabuf_revoked(pages)))
 			return;
 		iopt_area_unmap_domain_range(area, domain, start_index,
@@ -1917,8 +1916,8 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 		return 0;
 
 	mutex_lock(&pages->mutex);
-	if (iopt_is_dmabuf(pages)) {
-		rc = iopt_dmabuf_track_all_domains(area, pages);
+	if (iopt_pages_tracked(pages)) {
+		rc = iopt_pages_track_all_domains(area, pages);
 		if (rc)
 			goto out_unlock;
 	}
@@ -1983,8 +1982,8 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
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
@@ -2024,8 +2023,8 @@ void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages)
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
-- 
2.47.3


