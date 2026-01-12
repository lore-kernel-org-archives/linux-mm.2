Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9E8D25039
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 06:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DCE6B0088; Mon, 12 Jan 2026 01:59:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B956B0089; Mon, 12 Jan 2026 01:59:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A7C6B008A; Mon, 12 Jan 2026 01:59:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF37B6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 01:59:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F3C9B9097
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:59:31 +0000 (UTC)
X-FDA: 84322410942.27.ED5EE12
Received: from esa3.hc555-34.eu.iphmx.com (esa3.hc555-34.eu.iphmx.com [207.54.77.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id DCFA4140004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:59:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=mobileye.com header.s=MoEyIP header.b=AbN1YMgO;
	spf=pass (imf09.hostedemail.com: domain of vladimir.kondratiev@mobileye.com designates 207.54.77.50 as permitted sender) smtp.mailfrom=vladimir.kondratiev@mobileye.com;
	dmarc=pass (policy=quarantine) header.from=mobileye.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768201169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnXBn3WDzfudQPIyCqhNQOC+kKOEUjYI4qPJHAlpQnM=;
	b=b7KPFI0hQWnUJi4+xqR195xnToCZrDkYfwpY2K5Yxo82TjjVIwBUW9gbPzI0vAMY3dFWIc
	aHClulGkFsz8J5NKWlvqMJ4TY+A0JUdDqQZ2BB5SqPt4tYdUm6jrNECHq42dYB5SI352Iu
	8Zh1YPOm8r4dTRpYt/z1KmVIw3DyN1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768201169; a=rsa-sha256;
	cv=none;
	b=Q234qW4FfU8YbXhR/4P8doJNzYV38HucgRIwkSe8sY2UpLJWAUaeyKqwn3g7is8XvMaH/e
	ECblS/5FAH9WseHh7fePru1TmP9imMNp2M4p0xfV9lIP1xj5uDaQl75PO5ncIeBXGcKaQP
	dWq9oH478GlmfzkxUPwMrTPxr2zd2y0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=mobileye.com header.s=MoEyIP header.b=AbN1YMgO;
	spf=pass (imf09.hostedemail.com: domain of vladimir.kondratiev@mobileye.com designates 207.54.77.50 as permitted sender) smtp.mailfrom=vladimir.kondratiev@mobileye.com;
	dmarc=pass (policy=quarantine) header.from=mobileye.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=mobileye.com; i=@mobileye.com; q=dns/txt; s=MoEyIP;
  t=1768201166; x=1799737166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S86iPthB8Mz0CkECZazPVHa80rEM1013uyEDwE2IV5A=;
  b=AbN1YMgOPfxPRlL2gwLOMayuY7hamS7EvkuRSQHOnUhAfamdS8gUsIeI
   LE60hDRHyk+EpLZDPQCDBpCEcAD/PmEOfxXApLl4mokaEkIM2/K0TuX8s
   mSTEDn9hsIi6PWNuFC5tpKn59Wvy/4+GnlmvE0fzQd0sri7OyvXeGsQGq
   f2mo6mdKN9mmvND0rgXCwkrklHhR8J2zD4swPqebML0C8BUVYdGRnYyMQ
   6Ze8zPDrj04HUMAB/aMogSowq44fnY28Lab3BhgDv3mZnmA+qAbK+Lfme
   Gow46ZZtJn0X2jlrf0zLB7X4LCb3i7DoGMWqNA1M+FwDhoqA/Mooh4V3Z
   w==;
X-CSE-ConnectionGUID: oq3DufFNTbeuV2HBqqDJeQ==
X-CSE-MsgGUID: EmVyz2H9TTmg/vUbFg40pA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from unknown (HELO ces02_data.me-corp.lan) ([146.255.191.134])
  by esa3.hc555-34.eu.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 08:59:24 +0200
X-CSE-ConnectionGUID: EsrqnE3ATQuiZ4VSoKzRGg==
X-CSE-MsgGUID: qZ26/BZARpCbFJcbJb1pDQ==
Received: from unknown (HELO epgd071.me-corp.lan) ([10.154.54.6])
  by ces02_data.me-corp.lan with SMTP; 12 Jan 2026 09:01:12 +0200
Received: by epgd071.me-corp.lan (sSMTP sendmail emulation); Mon, 12 Jan 2026 08:59:24 +0200
From: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>
To: lkp@intel.com,
	mick@ics.forth.gr,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	vladimir.kondratiev@mobileye.com,
	Vladimir.Kondratiev@mobileye.com,
	akpm@linux-foundation.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	hch@infradead.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com
Subject: [PATCH v2] dma-pool: don't allocate DMA32 pool if no 32-bit memory
Date: Mon, 12 Jan 2026 08:58:56 +0200
Message-ID: <20260112065857.3137331-1-vladimir.kondratiev@mobileye.com>
In-Reply-To: <202601120747.TAMpIDnI-lkp@intel.com>
References: <202601120747.TAMpIDnI-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DCFA4140004
X-Rspam-User: 
X-Stat-Signature: n7n68761n6f5d4t1gi18rzreycxxwto8
X-HE-Tag: 1768201167-263935
X-HE-Meta: U2FsdGVkX1+CQ5XmwJE3NQoJXEGA002oSB5Cd2uD3J6MTTOoeW14YtjFAdg26v79SOIYU3S0KZ9vrluz2WxDEx1XdyMy68HXx09huNY28BxQYodhuOxvWGYIEQ2puIwlFf63SiUwla+65wgHcr6o8fQOlar8E2KNqdxzyHsyNkOlzy490WoHBA4OBJPAlDO8E6zB9xAEtnA6WLHhINPHczC57HIaA5p/p8rtQYJWI6KgWDWBfkNpMn16TSUiBXfc6LjRPTpNLXwSGDyUMTcyLVhLSZ5L6PsUu3ep12HVQZI72kBe8BDTwTTslH8bfYTSx9uMaAJhXPFOGBGhE5rZwyaFfE7A/utnNIdRiSLrk6ovPW6zIm8hAjgKp04psEb8nSgCEwvlpo9rSy4NAc6JWuqTyRpJsNs5/1K6eI349gkpVE8GQq23LhvWJgLrONEnafuaM8XxIP9uNfruBOMjhuCrf6bT79yburV6inZHcTDIl5+BESWmYgj7dqI0F2zL/WhgfPJ7e5rEOAg+wwNVkWVwcIShz+FsK0Dv0Yb2uD7hGRJZjztitvBtPh7R/K28abOdlN0Z+i5KfOc7oaWnY0/No6NZS03xHh40Lb+xS5Bi+sK+yPz89GN9sOkhdgdlBQL0yzUhh04a1SPqLJLz9PkwfKO7pX0BYpVMfBpbAcuFar1nqUV/Ie3Zx0fiXlNznR0Q+fuTLKqroxJlsZcn1BEq0dzfLIKOj44TM4aARoWVZAU9oGwN6iaq3qNePAmYavv3uEWeOZ/BZcfN8H78weE38Jo5MYnIDW58z7Gv/74ZAgmCU5VnYk9DJjAlRJaj0FkTExvPyGRKuPVvivHr6rtECa48r013JCReiA6QglMekDf8fyOsWYq5DPp0ePOPAnD91WBrI7Lj5EWHjylitH+QY8tJysWs0qElu/i+pItfZDWGrwxpgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If system have no 32-bit memory, GFP_DMA32 pool allocation will
obviously fail, so skip it.

Changes in v2: use arch-independent "memblock_start_of_DRAM" to get
DRAM base address

Signed-off-by: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>
---
 kernel/dma/pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index ee45dee33d49..ecd77a0272f2 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -209,7 +209,7 @@ static int __init dma_atomic_pool_init(void)
 		if (!atomic_pool_dma)
 			ret = -ENOMEM;
 	}
-	if (IS_ENABLED(CONFIG_ZONE_DMA32)) {
+	if (IS_ENABLED(CONFIG_ZONE_DMA32) && memblock_start_of_DRAM() < BIT_ULL(32)) {
 		atomic_pool_dma32 = __dma_atomic_pool_init(atomic_pool_size,
 						GFP_KERNEL | GFP_DMA32);
 		if (!atomic_pool_dma32)

base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.43.0


