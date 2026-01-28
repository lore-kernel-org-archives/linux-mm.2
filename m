Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5F0D46C0A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 22:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED866B008C; Wed, 28 Jan 2026 17:41:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7775E6B0092; Wed, 28 Jan 2026 17:41:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1766B0093; Wed, 28 Jan 2026 17:41:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 479496B008C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:41:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B0E01A013F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:41:13 +0000 (UTC)
X-FDA: 84382844826.25.B5DE706
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6484E1C0010
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:41:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ih3Yg+Az;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769640071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/qZms4umPrmH3dxBCuCVdp5swlmJdrl/x+r18MSy/8=;
	b=KPFBHIbMNAoBvVGdpdXQkRuxLmQ2zLDEXwLpn4e09k8q0xNKZfvds8uAd1v15dLuKJjwC8
	gcw621OUZ8w+kojmtgol5pYYMvs4vksxetI7FlPsFq1+niatq+H43xmvGDErG5t07Z9+Dz
	R0oS2XpYmSdEg/rLjerC+7/spJipKwE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769640071; a=rsa-sha256;
	cv=none;
	b=qY+aH+1eo7/EoVxzvhLpPWKbWWf6dcXZVXGq9BeZcvHK0z9pTtm0+9Hb7NJvuhIZBDaRi4
	bYRErFFkNx1CtX78r3uSN1bK+NSCcqQvDGU5hpBk81hcwhCEBuulCYVs7tJqHC/PbvGtKo
	uwstvI/vSA5SaFvO0f274ylcfVKcNOs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ih3Yg+Az;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2b704f08e73so240400eec.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769640070; x=1770244870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/qZms4umPrmH3dxBCuCVdp5swlmJdrl/x+r18MSy/8=;
        b=ih3Yg+AzqlLULJiz/igW0J25PlE+C1t4U7O2alHQ5FRMOkOXWiUAgKnnIFWc/MHCPd
         INHnCaNXYKqqeXpNQoDysFhNeCGQ2msiOVRIUPeIE6SndM17vuJbuRjpLf3xqw7jV+Y7
         V3JSVv/URlt4DxdFHaGMENQBL8XytY7jMLI4DU+cDvI/kCOm//+o6cmrFs5mnFgsSn24
         4Kbkn3K4Vm4AKce5qnJJp/jfpTupupyTocubW18DAKLTYEpqMyR13d1hgyAcFDHb2lJj
         HMM9/j4CfXGtT3e7fV0IfhxmJ+kIlUsyrMeajqTbIDFz40CgwIvNvgXiloyJLafTPwf1
         pAgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769640070; x=1770244870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n/qZms4umPrmH3dxBCuCVdp5swlmJdrl/x+r18MSy/8=;
        b=EXOtSr6XDzctS0UZKwPGX2OVFJi5YS4/tVIdHcJdnlfhNhetQQTAswFe+MVnsUFGw2
         FVZxHw7q4jmHSW53gihPKzStk3Dyx1Avn+eO4IJSm0VAZ39579jYwRkWD4FwAkwKi0mK
         YvZDZBLjafRogG3+TDn4hYvVtwmucuVHJ1AzL5pctxLUIA+C74CrFaA7KHZk1hPI/y5T
         hHGx4Y+FZCa4Np8UECq4OmtClfVfNTHiso9CTw2rG7nLAkkZYv+nSTPZq6wZQqYeZ4to
         f73wFQdtDyr1mLK8KiLaWHheDDp7KtsPn15BY2TlOACml0fs59p+dqmNuBeg4d3salb+
         FaoA==
X-Forwarded-Encrypted: i=1; AJvYcCX7UUdtEjvR16RXlTPZyQsEWKmTEQKCMAJaSBFqgvSK0MwoCCYW7yRceJI+5RdNEoDu+IdnXPAB+Q==@kvack.org
X-Gm-Message-State: AOJu0YwGIJRRqSxUewwFRnALgY3l0wwuldT5QhiwN6lxE3AVEUkYitvo
	mSXBOq8csMgIYt0n7HbGCmUeHbp9hzre0ILzuZcSyNiRFF/cNibuFkAj
X-Gm-Gg: AZuq6aLM/yyeP/jZ73ClGwejk19dOKyF6yFaUitPH0g4ZUsHd5AOcMjaqZG4JRVrLcO
	6ug5Ciz1Cc/txEo06szNE0PHnkwgeeT4SXynn9QyJV58bTH/Rg8Hl+93m5No14dsgWo2YLF0CsR
	ZmcPKMwl4XNmyXTrqTpYHfU3cWbQlJLVt71JGGvSvJNJdZjIAX1ApsoPNmHxejDLPlZYGKSz7vF
	PbJQ/DU7iKSZPPgJzWSyqo8+y7yQ03+azXQxrm2mI3v+4fXNZHBYytdCmd+/s334v1/fQ12F6kz
	l3b9z6dvx0GPzhXaYO0Rc/Ek/UgV7uOsr+oAOZfxqhAbaHkGsK8RzS0cvAJtfK7I1DzS8r31eO6
	f998MOHwpQm2zsy0sJi5h16kGBH/ZPZppeqzHA8ihERMMIdtYeS34SFqjbA3OkQrryzjIP8aarr
	8j0hBHlGXwddLv61MTn2nBQ1Uc8kKOAkASiSaxkqB3IR5ThuWgdajTgw==
X-Received: by 2002:a05:693c:609c:b0:2b7:b4f7:27de with SMTP id 5a478bee46e88-2b7b4f73f47mr132272eec.6.1769640070200;
        Wed, 28 Jan 2026 14:41:10 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2b7a1abe57csm5439115eec.22.2026.01.28.14.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 14:41:09 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 3/3] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Wed, 28 Jan 2026 14:40:49 -0800
Message-ID: <20260128224049.385013-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128224049.385013-1-vishal.moola@gmail.com>
References: <20260128224049.385013-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6484E1C0010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4oys87wfwdyo5idthszzdwgf1drehxpp
X-HE-Tag: 1769640071-718688
X-HE-Meta: U2FsdGVkX1/xLwyfKmQF/IpQ6lyjCDthvbXFx8ohRKSUFKw3S5hwiVHFjBf33B8Qg4kzSj2Y/K6o5AsmvqYhugsUUf2DEon53+SV7+LpLFiJAP4aZ7R6k7YoefW03vTkvax+R5IgY5ZR3mBps2xlPBtM6Wqh6HlV4/Px6vVD4cZhw0lLgiXkeyCOOb1jrJMfoUxIkSaRv27nrb+pJKIIpPXqWKtQ3DwaLIybFvYCBrgJUZsYgyoJ9rkZqA1fD/uFS34XNGr/ZdStPXeAUTUByV3Cpxbc52Akb4hwXAD5zSHy9On04QKlcoHTNvOU0nyIBv7qz5oGQ0atuI2Z9WCagfdzNyYfyU1TatPzmMqnKyCL4LRF8V3/oVdOLP1Yfz7llXv6qvdAoQycJ7GF8X6EyupX9vpX06ssIiGMBOjDMcOheyMS0KXqF3g7T5WDwJLTy5WH/uUyzE/6V+OalkYSKy6FDzxpFMJ7BDxyMNuGyPRfjvN82z9WQqpyC4SfyicuWnArMdYLu9qnt2XoaBmqSXiJly05/v1W/Ur1EZdh4C1Is9Ux+E2w+evkk5kl+mmHFuVsi2hz92YoZDSX1d7mwawQcakzbm0gsF54YqbuB9YMuDrCzdXT5ogYa+svJrNciTeN218AFYK/jK6FpMm4rnmYOIWOIu5QS4AEVbjsu9g7C+cVNwQeOZT4TmQISOPM+TH3TJDfGunIPyKhOykU3a6cm1Zs9XPQ0Q7vni/BM160njjulYCgRGWMhd56pFtdrrtSimnNRWofwoi7M4cfvDgohYjzSN6Ii841TRMddDg6fyTNa4ul7iuCW/n5FHkQgy0C25L+ZlcIAeUAQ74R/QHadoq4zT6sopWgSJiigSPNRWulJTSg3cz0yHGIVyabCah1H9hH0pGyrdV+0L1ZzOg0eSUWGBrHJHnHhw2YV+BHxjem8TUBckleXcmECSmn8Te1SSNkSVvMZlLXo5c
 3UxOZIw0
 LjMJFkiS64RVWcnhIcwEq37Kkn0OjopLjSmeaSnPE1gW6UXJnITLiHQ46wMtiINHX+0yhDnELG7FuERu57VsKFWX+3CFPx1fiXgB9fvF81fV3rFr+P8kMBP35f8o4Wya+6RrjUuNrT6BeywWSMMdV9vedUHhfFGGiJvgRXxW0Z6E4DuiqezUfIAfIy7C3SNcx9GRpLX6YoCqRDvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions.

split_large_page() allocates a page to be used as a page table. This
should be allocating a ptdesc, so convert it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index ee3d0067aeea..90ddd064c8c0 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1119,9 +1119,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct page *base)
+		   struct ptdesc *ptdesc)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned int i, level;
 	pgprot_t ref_prot;
@@ -1226,18 +1227,18 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct page *base;
+	struct ptdesc *ptdesc;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!base)
+	if (!ptdesc)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, base))
-		__free_page(base);
+	if (__split_large_page(cpa, kpte, address, ptdesc))
+		pagetable_free(ptdesc);
 
 	return 0;
 }
-- 
2.52.0


