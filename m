Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F0EC44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0186B0096; Thu,  9 Jul 2026 03:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7B06B0098; Thu,  9 Jul 2026 03:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4FD6B0099; Thu,  9 Jul 2026 03:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 711936B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:38:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C843120410
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:49 +0000 (UTC)
X-FDA: 84968436378.11.0F7AF4B
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 353FF40005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j6nG9jK1;
	spf=pass (imf12.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jpuDRDbi/4o3nLvS/PJuVqgep/rW9uImCbTAY/NJ00=;
	b=TuyR5vX6dSfymqV1OJ6rDPccOu/pZVDk2eLs26yKvFrO9jaX9bdx/qzma0hw5ulaHSlssG
	Uk3BLNi09hHokYenHCXV8A2DTjyUDiuWd+wmFRb5EqNJd7WlV2tkP60aenNqSreliniWup
	IjAR9sTPPIzhdA5xQXKhqkJsARb7WAU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j6nG9jK1;
	spf=pass (imf12.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582727;
	b=dGOAXB25mGd/WlPfkBo4W8vsBc1E161bsU4b396pOrttQ3W5dBtzAMJGGgxtLJtoeqb60n
	pU2BSgMaBpf8/3jBxBpx2DLllgCKxiCj7MqkfylucsrkV0/sNVoLIcRmAQZLO8+GE8ojsl
	EQ1BLDIWwTz/Ve19nuLoHaXLLm13QBo=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-848595b338cso502711b3a.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783582726; x=1784187526; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3jpuDRDbi/4o3nLvS/PJuVqgep/rW9uImCbTAY/NJ00=;
        b=j6nG9jK1bpo1yfSLbhOzZBhAQir3h+OTqwcGNMEXGuvo24e+SBUXeUx22XTIDFKWxB
         zyymUihRPTdnnbIOwEOf3OZC8DNJVLKTgvpBoEzSqibB+t+PSbsWTEXleGDHy/sQ11LH
         13xCo2cO7bWyvhhyCtPfz9SgL100+GiJxyNTc61heX92GmPY9AWSmRmf6w/g32z/p8bJ
         Kx3wD1z8kjFLjrxJ1VVRrw3Gc0YFm1eGIOXLGBph3G8FQnTRxDj+bTtjuF0dBkviI13d
         A6U4vocfbOwZEXzgWDI8L35/6riQ/uYxnI694P2fGmpDwvjim9MVptWLPwTtH7I28t3/
         Orkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783582726; x=1784187526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3jpuDRDbi/4o3nLvS/PJuVqgep/rW9uImCbTAY/NJ00=;
        b=bZK8nnpLo7GZmD05hai4cFolGcYdMYBB/EoMDB7894DlmrgdzAQnWGOHKgweAk6HgP
         pvSQY4L6f6AFW3SKlR7uQLVx6MTnPxDbzAs1XvbtHUpZPaInmWrEM4dC6mpocjudoz71
         LgVziq50rwE6HsVONgfIaIoemXPFW2m8d8FTQfQLsXUdVN0kfd0yDQyFpcICRSC0DVPL
         NAAgK1uim8Qgj16cId7aV2nBlQXTRIj/17pvCYZAH/oeQ44zyxbwOqrTI08qukTWzKDe
         SlVMNNWu5PLWecokgl3hZSZa5juZr67D6gKXUjaW1SLxB05a5sSA9k3ZDxGFytWmNYL6
         N60Q==
X-Forwarded-Encrypted: i=1; AHgh+RrFj0IdYWidJpYty7KF/vZ2+VXtE2T9WpyYuFTrowCCRahTsAIUHvqPKQ8KXgxBGECvridKQxnxoQ==@kvack.org
X-Gm-Message-State: AOJu0Yw914Jfp5B/36URYKnCN1gsAiw00ADzgvCjuYTnX1/2jZbbpUn4
	R/Jd3B72qywY46V9lijglpYRn7D9nW9rlmQKxDkyLSZ8ShM1Nvpc/Ycj
X-Gm-Gg: AfdE7cmkvN9wHvkTucxtgaX/CXRtxB32RBkxZoAfbIlR66APMPP0jNDQjad5EF0+yh6
	MGZTQoj+ZMfJAGfpLINVTwH2+VQrYLsXVH+mBmzFOOncEtPT4jSlfA6NIfqF+A+LxPasKt3FR6+
	ZLyq9cW4UWaJVbhLnae0R85BRtcUYsjzccKzqbSeBJxRdswPttyvtcJEUrejPE0QFcJZ1oNIk43
	zpfUJoD+ykbaoCRVJhGwJzgEJWWUu4bru72xVsrDu4B2GBlAeFQeyk+XXlsJTQ0h3D1gtfsA+Q/
	gScpPSBuGFwU+wjM8hsegilCwJJAyfjLlNNPcxGuApx/HLHAvvRsIHsP1V6Zo0eHDp+kWn3G6UU
	T/VtW47E2hrYValz0X6iKqLPLwmLGSJQVVx+N4xlVE5NpCgM4CluBUAlbb1gszqqat8VIdp9lbO
	wgyLNHPHGwX9jTElMnM5NlncIHJQ3n4b4vhmc=
X-Received: by 2002:a05:6a00:bd81:b0:848:2f6e:e532 with SMTP id d2e1a72fcca58-8484303809cmr5421671b3a.70.1783582726083;
        Thu, 09 Jul 2026 00:38:46 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3162a49sm3334902a12.15.2026.07.09.00.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:38:45 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v6 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Thu,  9 Jul 2026 15:38:19 +0800
Message-Id: <20260709073823.6643-3-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260709073823.6643-1-jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 353FF40005
X-Stat-Signature: kpwdxhdswkx6bybigyf9gx58ksx6tyod
X-HE-Tag: 1783582727-239885
X-HE-Meta: U2FsdGVkX18WgxZMEGDz5vReDQTyGOuWcl2TA9R6ZoAUhRTA0u6DHPf8ENIj6Qfnv0xM4yPnsEJM19vZ4xZcwsnDPqyxwTz27KqU1EVOeemX6rDjd5Zx8m8LtxQtqnK3XJ56vUqTZl6uYX2kUHmqM5+tVd12hIdGi8Iz6p+MMKPdKG7VNhCS3LeygGOCANSyxT8bBUkfIodt/65q/MahiIfmSFcGOnvjO0x/vX7agRywXXpNpCstXnAR0ShdTHH6Axbb/BaAvgiuhyTud1cQRRg5Sjyb4wEql+ntCtO25Kla1oRr1Bx67bdcnoyYg6+RQE4aGU68JJzsO7Y7TJfarq07TNIWLVGC8TGQ6beAGP2QNJ994EHkP7WSoUFf6cAgER+qON39mP0FQnP2cHw4Vzpt4c8mijFkfS0kVmYsK2xh4DKpXRdoPu2y8uvOeUds4IyfScLW0WLh7FCCH376yBdx3XC8FiO04t5TdAUagp58ZTo7XnAiuUUHb62vOaHxZoZECz9qrbn1AfDFvAaXnUEqqhj1qTFM5i/Eg3Q3kLYb+bGKrQsD9cCVyxpz/ANJYK32u5/snvKAdw4OUs+7j3RTwRkq90wFG5uGzA9zxxHQriKPxev9+9cOrzqneLtkTEg6RYB5C15uCyR4mSD1k/srZF61ao5HDzwORfefCgR+fvWHukjh0I6TSQhpR6QgdccnLtWzFOKbSB08iamkJAiUffmn76u9WMTtz1QgGYfw24YKcAcSFvHgHMYAJLAdcO43Z9kYuk4xR+3rANOdyDoWV4xg2LwzGAuB8iVFFoOKiut4wBtVmBpGGBObMAwu0h0WHKmzRxPBLL/o4aVgDsEfHKVsgnmTCpSK0ljlqdmYx4UpFitxlFuttKuqilnZCJw8M53Y1bD17s5gyyeCiTDA9EMoUzwZBKkHqwKhoHoATxv4V+Ku4VexT+2CSyJCt9loznSrC/v5Q1jem44
 j0z7VZaI
 gWM+bZ2fDtsagHdv7Jnypj+v7Loe0pI6SQETdXyVA/dN4kL6uSnpy7zS73OvykVbun7sZJi8yS+iRqntPGwqxOhPeX5yR2tyflSKPskbKQxLp8EFbS+ZcSsxsqsZEMq2lRYB5sJ0NGI7ZwMEidzJdjR052Dtpq44eEWgTMHZSXp/R6/+eQy2PruRZ3w2vUiyOfF4oFZQVlUn53PRFTbiggREoDtqPLQXrLUx0gNRmUtYt0yjFMR0AjdoFepdJKX1lSde7nRDJ5Tu/J/3uprMPlMSM+myRmfP3Hcbirrz0tc01LxDKP8AL5dbwv/L23AdUbIbjFO2BI0Jt2Pk1sBYfe2LHOayIRPH6GCgu5LE+7ye3HS0Wg+cfVaB9hjVcx7IrQpnF2hR+ieiwwvlZU9jfo7F5L5Z31enu5gzw2fu/AYI7+OhYPYE8jstgMRJYQGsqlK2Z2m9uaOvWqJHXQUZYtFSj4Dc53OAnYEoysOp1crnjeiTc+DP5AwrUnYZOp78uOR4uE+lqjXKVJl84XJNqnZR+SanxkjMcNGm4nT8x98CAdTClAkzhc/NAN+Tg4PVHgXOVmZN5hDLHSL6Cu5ZQdPmOtNxkronhv8L/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/include/asm/vmalloc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..7d9c7dc795c42 100644
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
+	size = rounddown_pow_of_two(size);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


