Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C137DCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294E68E0028; Tue,  2 Sep 2025 11:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C338E0002; Tue,  2 Sep 2025 11:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182768E0028; Tue,  2 Sep 2025 11:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0856D8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:46:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4063160256
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:56 +0000 (UTC)
X-FDA: 83844738432.11.E9D8169
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id ADA5680006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J3wc91pw;
	spf=pass (imf02.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/5Ql6ePEZB3sncY9PXrRkrrrgHDmfb5EstPCmtwQL4=;
	b=FZDfxhW/wDX1LEzYB0SjVn1d2DlOTUabxBnU8i2Ao+2rAb/TdZ7u6Ey9UpdQzFMko7/nU3
	sDNWPbh1pxY1BSmzrPDHE0UCK7hICCPJ2NgE08HBmBJOS9fsnMuSRdc8yKyV/0ypS4mII2
	KIkdJ2nETENbLbqodgwuKn73EpapYXI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J3wc91pw;
	spf=pass (imf02.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828014; a=rsa-sha256;
	cv=none;
	b=0f8RuWtlfe5DaDgC1SUmFp7ec0vTEurLZUVPu04NCLSS1oQE/zb1VUN8saR6mUnNlfdOB4
	lTSA1a20i0yrKlyOCRBH4NyJ4DHVRUnTMPdmPoTZNfhQ0fgiRUD7WgS45knOgvTflT59/m
	prjCPGWe5lqN6VtmTJ0vsl+S21uTx2o=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3d965477dc0so951912f8f.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828013; x=1757432813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/5Ql6ePEZB3sncY9PXrRkrrrgHDmfb5EstPCmtwQL4=;
        b=J3wc91pwTu5RKTox8ghGsswZ0W8494wUuOlhGD2qr254iMx2Y/AoAyA18LUUgpBEiU
         oo/MTbf4eGnRE3I4Y6aDqDg/vgGNukX+pxTQYi5AAJgRKBOa5GTHa7rGFaAFOyV0HSyN
         tdaHmuI+u5z4N3uX6zTXHYfaM4wTeohTRls+Ch6WskYrjk3y5HuCqpuR9rELKrF8vKqG
         8U7HaXyS1EeDFsgibAIehOfx2bV4D+IsnBvRw70PphEYqZfroEhwvJ7ZiEPb7BzDevcO
         MyMCzINY/6svKnP5MPqbuHui2rbznQGEbUMpF5YMcBORyRxrfhi3n6vNT9Itmy+Trxpe
         bdYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828013; x=1757432813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/5Ql6ePEZB3sncY9PXrRkrrrgHDmfb5EstPCmtwQL4=;
        b=avJAtmmKFJfa3Hhh5W2KIHOzytYJo0/a+SGV9UHU59KnaHb2bPSlt6513FQ1obHJcS
         8UwhyBkFPwJzYfgPERAYae1LKWakGytkwS9vrZhBy4c8pw5NygFNQXjmDd5Lomf1URJ2
         FKKrEntZLQPnP4JzBP9q4Gauzqab5e/rXUVceJxikrb1k7SL5S87xEYjih1zz3l5nMWU
         dvJ6vnJ8D+lKLPJLMEz1HGDUuBULu+/6q1siX5oGIQa4XMneJNpmnsW9DwUTaakQs3QD
         1dPyUw147ISZk4jeGX1hEV1UmVrkkNldKcfeapkNGLS7UsMK+32qzzN4SioXTkl9oZsi
         Jpgw==
X-Forwarded-Encrypted: i=1; AJvYcCUir0/l75gzY+vrLcr53C+fwFUBqjk0EevDslmgjaCOPDz8fOr+tTSkiZ9W7zAOk2SXotGx47aJsA==@kvack.org
X-Gm-Message-State: AOJu0YwpErcNq6C8nkKf68rLTS4YTCaY6moF+pL2D6MHZa1wPhAbwS4X
	8CreuBXGet5RiAfm+P+lmyZzT5JUAlslTLD5Sn/qEYPQ9uuIE53BuiFW
X-Gm-Gg: ASbGncsI+PUqSQFpw6IeujtPhbWF+IlS833LKqGxf73NYvgvt/l3FPuYni2FhurYV2m
	B4SS50f85InIk6JsIzMcOJJ/1KTGcEVW/wZGjBDpiRPSf+YZ4HfQfzLMQhz4uW0RiJPxMllSf+2
	04JCLo39ByVcQocM5/1IaUdmn8ieEq44xNe8Gd9KMVVX2UABOcW/qRYWjiMAUc7axb5XMKTva19
	yjzy0va/Vs2n+BYPxMgTmLgYgKGzbwaCR+8GBk4Zs34v8izMXf43sKmuTPNo3zfI0a4+7SXZYF5
	xw3kIjyxTJns18z991svVtOMkBCBbsaZlZqUJxdH4gjpRsjb/fwGTlY28S0peUY4PW01xMKsXKU
	M7H8iqnwyPHJg19+1/S5F6I022y4xvXnsMCgZ3AJvmw0bEzVEOXuZfYrKKsTm20jdGi57Ae0sZs
	P+sdCGecXkgfVwfAaZsNZ49SEc
X-Google-Smtp-Source: AGHT+IHq43AbE5VkmkapAR0tzhsq3zXTXrsk3nysd56WKEVtoZpJPwZ7v6YnW4KfZ38+U9nLscJHkg==
X-Received: by 2002:a05:6000:25c6:b0:3ce:f0a5:d598 with SMTP id ffacd0b85a97d-3d1dca7bfdbmr10337054f8f.10.1756828012868;
        Tue, 02 Sep 2025 08:46:52 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45c447244c4sm4765415e9.6.2025.09.02.08.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:46:48 -0700 (PDT)
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
Date: Tue,  2 Sep 2025 17:46:23 +0200
Message-ID: <20250902154630.4032984-4-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ADA5680006
X-Rspam-User: 
X-Stat-Signature: ogobedfrbt1c67pryezepawqfgkjo7bg
X-Rspamd-Server: rspam09
X-HE-Tag: 1756828014-395900
X-HE-Meta: U2FsdGVkX1+C3pES2aiX6ooPVnx0oQJmFxEsI14DdXUp1GO2wQ41foVEL+n4XuywtwpkhpbLpQzra7Bwu18iAkJmWM7LI8N3SZFBoPH1s1KvOpK0wTi5djUtOJGCQipwxXZw19FYtQ+wJLOZRndv/U65k6HWLwAAfiiRdEdk6BhzPSPRahlJeZ06+RTXrMxh24OXJiTCBFFyTAVVDwfGiesjESni/MJPKpP11t5rSpFS6vxOaD1fwaZHYSC+ZnZKg9di3wxGciRTV5hgCc6si3K7w/ttHIEUTOaXxGUUNVHoF2iNzfZUYI5oIvYvUPX/i88NVM1McxxXz+LKuZzGyzWzzUziGVa8+NKxtcLMlIae4xf5faSUzIqXhvGYjZoS3uyjpgqdQlWxJa81u7+/4gjFl+t0TShTGZtvPxh/rae+fuvDRJbXZ7y8dv7gofW75gvNm/oOoe7wTwoiN+LRB0dqBSY34uHBmBmiSOPrd0bCWAtCHNczy9ki+jRHan6VLLVT4y+B4Uu9E5/0hpV9cjlnf06lTksYqOamlX84JPFnRjSCLdSPeBQ+PHhhAvpwvhx2wsZIlDXrKiKJ3MhMS1r84eP1HtZzQJ3v4clsULlWBXFSla6bi+5p+215G+rs0tY9RCkIyMbR7ijcVv4bpotoGZigoEn5nt9u4SrW5kdCGe/BZiUx9KaZ34IcmHFrkTHCMDGTLTcTEqUviAHgOnqLcgu7v+ixM6vZ5m8oQ0nyljMnEJTr3JPXN1YvFP3mvRTwi2dCr9lSUO5qrMhEUfdpnFmILFIQVPdviL+Zh83+do7tYj0bLo1OVT2mUKo19QSN/NlUULgNhY1LSrHnjWc3IsIStKWqRROera9yQlmpNSXN0ufWR169FMGi7jq7XmkPxEkKEWdydfdf7NIDRJ0yyuqxBW+cYqoZJS2pr99SB2QGK0VkCrwC9Ex26o3kxTsvmhXEaCezVk1Lx23
 cvrbyHZo
 HOMBkREt5p5cl69hCDs3bAvFXp5BVne+1PzKwLlcMyvcS/y+64WCwDe/vw3XnPNtCL/YpRS3O/6RZzIC8l703Q020TjtlLwA9Wdxdo4I3L8ot0B7wdanaZsLoSgtxfedeywITJDMFn3PB0zla+hd/cKaZk6qyFQvpkWFc34CsmXx4UZsLrcE+GM3ukbpZOHMN8Iy5cP2SwVhGWbKU+6YfC9dL13Fo7+xXHGUNXKKbQXCG/CWUm+gwQJu0ohvBAyt7B+KWzcW9tw/0cbPLX5Qt5f4vYDTCQ48Pmdom9uftkb4fFs93rf+juNHgSDHxYotaqowo4zVX0Nf7QPoOZqmjvrHsu3Ea939VG63tYKhqFbKSG9YxeucIRw6rQfi/kNABRywlde6fCytitYuUAYFlrwOjgRSqWo4Z4388z28yx3RmATOF0Lr4USzYdjp+hhomxZXcIdIyB+4CqJ1CIkqBwr5wj822uLK2aJi9Sv91cIlJwtIFHocQ8yaBv8RuJwNuUt3WTXqHHhQNn4f48O6ZApujZOcZgH+9kvzcO1OAkkhr/6pC1yRJEo4fgv/UrxHAdLVy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

There is no technical reason why there should be a limited number of CMA
regions, so extract some code into helpers and use them to create extra
functions (cma_create() and cma_free()) that allow creating and freeing,
respectively, CMA regions dynamically at runtime.

Note that these dynamically created CMA areas are treated specially and
do not contribute to the number of total CMA pages so that this count
still only applies to the fixed number of CMA areas.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/cma.h | 16 ++++++++
 mm/cma.c            | 89 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf6326..f1e20642198a 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -61,6 +61,10 @@ extern void cma_reserve_pages_on_error(struct cma *cma);
 struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
 bool cma_free_folio(struct cma *cma, const struct folio *folio);
 bool cma_validate_zones(struct cma *cma);
+
+struct cma *cma_create(phys_addr_t base, phys_addr_t size,
+		       unsigned int order_per_bit, const char *name);
+void cma_free(struct cma *cma);
 #else
 static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 {
@@ -71,10 +75,22 @@ static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
 {
 	return false;
 }
+
 static inline bool cma_validate_zones(struct cma *cma)
 {
 	return false;
 }
+
+static inline struct cma *cma_create(phys_addr_t base, phys_addr_t size,
+				     unsigned int order_per_bit,
+				     const char *name)
+{
+	return NULL;
+}
+
+static inline void cma_free(struct cma *cma)
+{
+}
 #endif
 
 #endif
diff --git a/mm/cma.c b/mm/cma.c
index e56ec64d0567..8149227d319f 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -214,6 +214,18 @@ void __init cma_reserve_pages_on_error(struct cma *cma)
 	set_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags);
 }
 
+static void __init cma_init_area(struct cma *cma, const char *name,
+				 phys_addr_t size, unsigned int order_per_bit)
+{
+	if (name)
+		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
+	else
+		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+
+	cma->available_count = cma->count = size >> PAGE_SHIFT;
+	cma->order_per_bit = order_per_bit;
+}
+
 static int __init cma_new_area(const char *name, phys_addr_t size,
 			       unsigned int order_per_bit,
 			       struct cma **res_cma)
@@ -232,13 +244,8 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
 	cma = &cma_areas[cma_area_count];
 	cma_area_count++;
 
-	if (name)
-		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
-	else
-		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+	cma_init_area(cma, name, size, order_per_bit);
 
-	cma->available_count = cma->count = size >> PAGE_SHIFT;
-	cma->order_per_bit = order_per_bit;
 	*res_cma = cma;
 	totalcma_pages += cma->count;
 
@@ -251,6 +258,27 @@ static void __init cma_drop_area(struct cma *cma)
 	cma_area_count--;
 }
 
+static int __init cma_check_memory(phys_addr_t base, phys_addr_t size)
+{
+	if (!size || !memblock_is_region_reserved(base, size))
+		return -EINVAL;
+
+	/*
+	 * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
+	 * needs pageblock_order to be initialized. Let's enforce it.
+	 */
+	if (!pageblock_order) {
+		pr_err("pageblock_order not yet initialized. Called during early boot?\n");
+		return -EINVAL;
+	}
+
+	/* ensure minimal alignment required by mm core */
+	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * cma_init_reserved_mem() - create custom contiguous area from reserved memory
  * @base: Base address of the reserved area
@@ -271,22 +299,9 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	struct cma *cma;
 	int ret;
 
-	/* Sanity checks */
-	if (!size || !memblock_is_region_reserved(base, size))
-		return -EINVAL;
-
-	/*
-	 * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
-	 * needs pageblock_order to be initialized. Let's enforce it.
-	 */
-	if (!pageblock_order) {
-		pr_err("pageblock_order not yet initialized. Called during early boot?\n");
-		return -EINVAL;
-	}
-
-	/* ensure minimal alignment required by mm core */
-	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
-		return -EINVAL;
+	ret = cma_check_memory(base, size);
+	if (ret < 0)
+		return ret;
 
 	ret = cma_new_area(name, size, order_per_bit, &cma);
 	if (ret != 0)
@@ -1112,3 +1127,33 @@ void __init *cma_reserve_early(struct cma *cma, unsigned long size)
 
 	return ret;
 }
+
+struct cma *__init cma_create(phys_addr_t base, phys_addr_t size,
+			      unsigned int order_per_bit, const char *name)
+{
+	struct cma *cma;
+	int ret;
+
+	ret = cma_check_memory(base, size);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	cma = kzalloc(sizeof(*cma), GFP_KERNEL);
+	if (!cma)
+		return ERR_PTR(-ENOMEM);
+
+	cma_init_area(cma, name, size, order_per_bit);
+	cma->ranges[0].base_pfn = PFN_DOWN(base);
+	cma->ranges[0].early_pfn = PFN_DOWN(base);
+	cma->ranges[0].count = cma->count;
+	cma->nranges = 1;
+
+	cma_activate_area(cma);
+
+	return cma;
+}
+
+void cma_free(struct cma *cma)
+{
+	kfree(cma);
+}
-- 
2.50.0


