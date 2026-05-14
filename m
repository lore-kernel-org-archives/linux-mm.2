Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B6DCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6755D6B008C; Thu, 14 May 2026 05:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D556B0092; Thu, 14 May 2026 05:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A206B0093; Thu, 14 May 2026 05:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC856B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:41:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19CAB16089B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:51 +0000 (UTC)
X-FDA: 84765533622.27.104CFAB
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 489FD14000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ehT8v1fU;
	spf=pass (imf09.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4izeGUE5yc6CqsffIoYTcEPD1HGMIlHVDl1/1KC/ZM0=;
	b=Rcz6CUY8Mxwz75hFQg6D7FKnnCLhhMC8QqZD9cDUy2yPXUujQC1qb/oUgErziUAB0yHj5F
	0fz/hu2WSckdQEctEIV7bGBnlQrg2l7Zy4IDfxIQY0FMcIGAN77sYobOlwMLpt19dVpOuW
	01L90URbu2aOlZ4iKviNtPAKnpduAuw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751709; a=rsa-sha256;
	cv=none;
	b=mXX3P+9fkJsYOHw9bFP2TyKLeUDcdNWIyGWKno4YwiZg4OcrUdk7wkMEwVXmJBb+ERqB1N
	oJnZBVz+EqWsvM0wB6IrZD4/HnTwSh3dOxHI1Av/6R9B31nAyLs8QAbcf7thZFb4Ya8nYz
	BF5ADGgxSsQLEr4foXs8ZCvVbIKwwgo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ehT8v1fU;
	spf=pass (imf09.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso3180076a12.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751708; x=1779356508; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4izeGUE5yc6CqsffIoYTcEPD1HGMIlHVDl1/1KC/ZM0=;
        b=ehT8v1fUNbNxFErluVJAKLCT+9YNWtu720D5QOYHHGbhSbPGaANIBW45UYrRQCYRbs
         uDEWWyhR8tSunRcWrtyAsVJcBvm6fIRAY3x6ASz4YWxcokqJCte9MfmDwW6p3iHrgCdD
         OE6Xr4tzTzFnOwTBebRwFANXp4IizLx2JKLajODYfxjuAfABguJZu8SBy8LZF5TCBZfR
         HsGD4BQZ/66R3iXPdGdKdGh7CVrCNARt5KP9g+8O+MltF9kz79b50NryquEPOWm5iU9Z
         nlm5nE4tKb49p2YMdVmRpVff1nDNyohARNYOidewYZ22E4POn5sreUKy08BgOvkPS95g
         SeCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751708; x=1779356508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4izeGUE5yc6CqsffIoYTcEPD1HGMIlHVDl1/1KC/ZM0=;
        b=dCqwxMf5Icwo0tBwgrbcN4aea6D/FxWdqBOej0/PJy2MvIZoEr3k85FF6oo4l5JuFU
         VhnnFwuS1nQDsbPSHF8Hi28ATJMzn0vNHBB3OoITTc4PvL3gu+yRJLZ9Ifxnc+rasy0T
         4QwxTprYf7928/c1znn5BCYM+RR8cYtxEOxRji/H/5A2uDD0NNMZx3SJwGzFg2EVvBWk
         WR1NdzNBa8BEaBuCY946brpPWTJVtx8x1LtChEKkCmGz3pY5xz2VRfxLuNxAERE3q3rw
         C0XAgVQ3VfhstLO7pb3ovAvYVW7Zfy8s7Qqyj0qv05fJZIvIqUmhocT9owr6aS1qsKtg
         H0ww==
X-Gm-Message-State: AOJu0YxAo9Hb9H10HdmNQDmUd3vFqWqpwudscT7bF1xPAlIl5LA5W+zA
	dS1zgs1PldsSrm+WXZxzaKenCqOD8uH8hICvz/qrklSt83f+38U4gE8na80WcRp8onE=
X-Gm-Gg: Acq92OFTajmGzNLKe/t44779s/6+CbuPchA/hr+3jULvJocNklPCzZim/i9LZ8G76TQ
	JYpuXjk5aI0zI2bbt0vGcQfnF5+oQKgLRJVBzGurxH9zjQSIcQp/VwMAmVandZ5DQh7OPgklaPE
	GEQtgd3o4B9yQj24v7NapPB7pr/L9rhvkz9hfba1I+XZ1Eiu6G5wVLMdC0fSdRwydFm7+3YhlKP
	kTHwF6GB0hgyI33mw/Z7BM6tMT95NvYIhv5rqsiWf/vSDwvcgBjwrZTQ1e2KEb/zFXqCAzJXRgc
	WOiKhs+HAThP0mk3pA7dE6xJYsIUNED2F4HwinkLXYwfrTdHmPpU3Mgw27nmPyEIF/yrVtoBfzB
	Dt9jFm5xEhavi07qI6+UV9GuK9TpRXd9ZB26ZsKLBw9LTvK1EuwwQTauxOqkf7DiH2HfNThlF4U
	/5nMmpp2GmDgh9qdFe4gUI1hH81sSucaPhOSyyjs2lfUTTGSIP7D/fea5+
X-Received: by 2002:a05:6300:6c07:b0:398:abe1:eaac with SMTP id adf61e73a8af0-3af8137634cmr5712299637.27.1778751707654;
        Thu, 14 May 2026 02:41:47 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm2351244a12.22.2026.05.14.02.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:41:47 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 2/7] arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Thu, 14 May 2026 17:41:03 +0800
Message-Id: <20260514094108.2016201-3-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 489FD14000F
X-Stat-Signature: rdhdjypocpqbrczohhyk4k1pi9k6kpiq
X-Rspam-User: 
X-HE-Tag: 1778751709-249763
X-HE-Meta: U2FsdGVkX19V3lOJJgKusYpL3CCdCRE19VgM7Ka6nHHGHpazj3z76FcB72HJV+aumI9BzSwCYngcqusnecErkheXPf7bmmBxWhyR1RsoZ9P7cDvHd/iDNLkGxoZm27rZ8v9sqIBeiUp7yzqEVyzeax8TCHWUbQiMrctJ1of0bXbFlziOJg9eOByZ9QnBCN0gsT8h0Y7eEpoUyNGC1DdpvMnT7XTeoXOSxxGHOWBCoafVwXsvLIWcynbXseOxzI2j9bpbAdk3extMB2CdgBo/pBvzpUZv3kVMT3eFMfO38rjMdeFEZpHKe8P5oZlBAq16ej8+7avDxrBvUzvrQ8WQ29vOjj/TRvKqLhHSbAtQd1AuLP84FK7cNe5c3ROASz4dq1WPEy24wiQXvgCTAXUFFDJrvHxSkrmPTJigK62rvrh2vEcFni35D2wPVEd5JTn/A7b5xDCaXLR0ucYiUUUOOeCMw7k0vn+rOociUjVI5Q1gur3AvjKGqUvRQyKb1GcSIOcGSc6TQKsyUtPVx2TzIqaAsHmvPumI8dmOpthWmMI4LFeWcnR/BCci0PF2SDMHGDvbWCaYNdarpDi9NY4qm0zhyjtZ2PkkSKzdwAsjGgtSlL3oyw0z8MXOhSn0VerYCpZ6C+BT5Hm7t/UH7WJ2PQo1ojQWN9WQSnuNHiLWdAnkwDYYTEjjjySL97/1WBafwnMr1IBERWmOYHQZ0vrIvPt3xLMdI4+lAyqAIfVmMoXb+nN9F7sFDQDdyl7oKGt9CFDFbkljeOQ2QqaM2NBqFOConkJln+x1dShzkjLRUFWwP7yistf8y7q45f6rCDlZKpWOtGVMLmojlpZBj7GqJnbtjbi+Jf6LlRyKEX/DM4B9vP+5p+8d0NvszZcMyi4zqpwQaDPTn29SgWZ9MJGw2UAztBFDip+5A7o5VMb8jIQaJkW0K1v486HuCv+dQX9bVAPW9FWpT2/bzESI+Vs
 waxfabIW
 MpYjAXca6naLHqKPAPNLWEQXUFL6MJjR36e9Fq4z4Ryrp9eYCjHEXHscMKvSDdkfZTvr/wYBAoeVGATFAN86F3zjldG4aGMJyxiR07CvwOiELyO4QgViusD1Ez/qupPRnLNmZyme3QPNgmKFa31+UImKbb72FjuNHOE3SXoo45bcNSu9OzmlTzJRHNZPu//cdUKIEWzyeu/ykx0YwJLvIfg3JCG6hI/dS/o3t6VsTDtXh6JXMiJwpy7+8qvOn5v10PiZiQVPHd48d0gOvRLfuq+Imgwk7v/9nv47Ndzgx+PwtsMws1AP9f4ImnuhEGa2KlEUfxpxcclTfYOspEOI5Lt3HKuZHigzIa3Hbi70breElyiZUMBzjWfESYbaVLLVRK/dJQit8bA235XvNL8ElVbiTq261I2EcuWED9OPTmPwQ0Gji6Je4uUBBno+pE8j4KguqiQW4Jv61EX1Wns1/XsLsWsBGQBEVY5iQkUZ0riUN83drJSLXEZarnnGQS78hhroSUiK4iPcWjRRoVKdw89hNralSHFjqYCbg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE hugepages,
reducing both PTE setup and TLB flush iterations.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/include/asm/vmalloc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c..9eea06d0f 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
+	size = 1UL << (fls(size) - 1);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


