Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C30CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A535280039; Fri, 19 Sep 2025 01:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D5B28000F; Fri, 19 Sep 2025 01:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215EB280039; Fri, 19 Sep 2025 01:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC2828000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:42:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCF6286FA7
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:58 +0000 (UTC)
X-FDA: 83904906036.09.E1C8C06
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id 753F5100005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ABsBFlPX;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZM5r4OevwjFKvKB7y2ePSx5NHfL4r3el6zwT5s+bqc=;
	b=dHzDacLf1nHA2pwJpQzzn6p8VcTUa8fQgiOaZPB6YGBchuYXTyVKJ3Z3UhHleYpoHdrRfE
	jw9Lga8rqscKUyd73Pxe7PI3VKD909uMERVElbyySrqJggNQS4mlIps1eqSdhfgz3GWEqT
	g2vja/zkwXNDfB8mw2SgXLug0P+WLLY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ABsBFlPX;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260576; a=rsa-sha256;
	cv=none;
	b=Trmi6cWnvRyaPaIbu6dngdx9rRfWwLsAUGXGCRumM39YjBk9ZrIXFEOQWBkxBYOtk63E9i
	zp0D6hr8mqY+ccOcjt6f9wjPwZCsSXNx4bSpHLuDwQulPLm+HNSOqDi4tESyDbSp5bnodc
	Cm5BONEkrQKdvWR95oVBUQQ8EEZpfIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260577; x=1789796577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q4orb/9TcIzBYjB1lAxgyFEtZV3WTz8lFO2q41GLlcw=;
  b=ABsBFlPXlX9ry/oHeUw+HWZ5lCioTLJuH0AZZGaBSLePwJRl3nuFvh0a
   qrWH3LV7NX0kButbLHNtRC7HzPM83kNr5qoVlcHG7K1bnPG//ardLSiJx
   RglIvZPmIylxRtWw+W32VxXRto+MI33s3lySk2qYBN1cs0H4pgZ84qQB1
   WlNeonqD9FFeLZVlDryWSnxaunwALeHOtisFIeaYzUq4y+/5lE4IJZcgE
   qv8MGSjcTPP568EjCSRZLmN2nDe3mnkVWudRGuD2VkfSzVHRCqVoRvEX3
   oxmiCY7viPYV2R0Ryw7uKeQB4mvSglSi5kA4XRxW9ZixJMFXOmyeF3SpA
   A==;
X-CSE-ConnectionGUID: Lpu6AwVnTN+R0a4r7PU/jA==
X-CSE-MsgGUID: ARshwsA7QQ6QX3r3X0Dx+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235798"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235798"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:42:56 -0700
X-CSE-ConnectionGUID: +Vms+rOBQSqxVfmiElkoKg==
X-CSE-MsgGUID: Q6CmgcwOT0Wklf9A8kA2kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858678"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:42:50 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 4/8] mm: Introduce pure page table freeing function
Date: Fri, 19 Sep 2025 13:40:02 +0800
Message-ID: <20250919054007.472493-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 753F5100005
X-Rspamd-Server: rspam05
X-Stat-Signature: 8b4augfb544ypmogqs6ca9enz8zncde3
X-Rspam-User: 
X-HE-Tag: 1758260576-198845
X-HE-Meta: U2FsdGVkX1+wBKonnQ9G22rDa1+Y7FQqptcDolld1fUcKZ4ZOlZuYJbs61bAQFyZYj2ofl4lXAkGD/1Jfv6ivOQCpmYzm+sXaNPLxWhHVvYarsK8lg1p3Q9dNGQRl+VBJ8WJhcfkIzUkSz/y4/A4f8zVtPDKfdwlFq0ZEob9Cc+/+hliHg+zxHAdf/K/HeV73Ul0MU+CWKGb88ylovr3AL2oJhlZv335OBlpPZfSK0B9G8t7IdKat/z38b0mBJ2+GXZ5Aj7u/jhfNTSznjfruXkFceNQBYXfejlef96L3RusNp+DzYL681ndjVGA6AlMbqFJkREDj7PPx8DPL62GlNq/u75ggyZv2+RdA4j12GBBk8zbYnu/7uiuKmrkzakF9ObzNSGdlB/Wl/M3hYGbFxnSTihD4f7b+NUvB8n9l9BJ3FxDNm17XpexY5mdhiRdtpOtLdGnglQVZTeEODp4FjUzfWdsImddxIk5s+Jt0l3a5+aUPIJxV8L6ZMHKoh21uHyPzsqx19QqYEozkQKXQFuYRIfV9UEQWcflDw2c1hJcBxt8MgtjnJQMUph2xm29wjrw4WX9GGddN+akGvKlayhXtXJ++Uir0xxOGE0gNbyng9sk+lD1WdWEC75grNkHbKFaV2oSTxalSAZ0BlCNrSb1PB/W4BkbBXoZTzcmh0L5e6xbbpNEpKDf+xzv42qOc5SDdnVG1W8cghW5NaS1Ja6yY1UMcRm2/5hnVgSN+x/0Ij0/UprsJZjy5PXEtxA05SOc1zKtDbziTw4dncB3HuBbQKPOchfbgXgaqWQWg5zXUu/PURxelB40Ny3hzSUMTJCVaUmrmjG6LEIPJ3vkSX4tDjdlBgR9xiLAMksuEbNYx2WbUvIq5IwEBvTCQCwobw5RTKlG6eO2hwnlpv6ujeWEAV1E2N3PkMTdoD3UvsdVh1EmyZtIFdUDsH7dH7m+c+Rilf1WUCa+aqYyNFC
 cd3fYdwK
 AOqz3j1/BLp0+OZ2zy9GufWuvSkyYlc3+SH1eoNzE6rcwbjJJWaBoC0RP1EKtmL+KCm1DJARYkfveFnBkooJVGZj19lrK8IIj3GxaBm8/IXd/X5TK29h7gDTBpFp6JHPj3hiGGf48hgZQ9ff15q8pXJO7jF/hbliYaw8yVs8zt+w8U5ny18lpXUhOjHGbAXUmlZuL84JNGzYB6/JkxeNzXuIaHhuQ6wc3A6Nd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

The pages used for ptdescs are currently freed back to the allocator
in a single location. They will shortly be freed from a second
location.

Create a simple helper that just frees them back to the allocator.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/mm.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f3db3a5ebefe..668d519edc0f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2884,6 +2884,13 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
 }
 #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
 
+static inline void __pagetable_free(struct ptdesc *pt)
+{
+	struct page *page = ptdesc_page(pt);
+
+	__free_pages(page, compound_order(page));
+}
+
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
@@ -2893,12 +2900,10 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
  */
 static inline void pagetable_free(struct ptdesc *pt)
 {
-	struct page *page = ptdesc_page(pt);
-
 	if (ptdesc_test_kernel(pt))
 		ptdesc_clear_kernel(pt);
 
-	__free_pages(page, compound_order(page));
+	__pagetable_free(pt);
 }
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
-- 
2.43.0


