Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3154BC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEF66B00B7; Wed, 15 Jul 2026 09:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F586B00B2; Wed, 15 Jul 2026 09:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E5B6B00B6; Wed, 15 Jul 2026 09:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A37B76B00B2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:27:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FA331A015A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:37 +0000 (UTC)
X-FDA: 84990889074.23.5398500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id A419C1C000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SGWpe6Kk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784117315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3KNxe0yLoF7PUMUYd/OqmVO3pDmLAAWwOynTW5KQ9A=;
	b=OW/WG2OG9bu+38J2HJTHuLAEQD4sEC6cZuMkqFjkGJWgM86xtyVJf29NC8tsEXnjWRTZJP
	+35qRbsms8I+rNssJcu5yuiAEVtOEPIuPTTuvUnELH8akI4mzSg49VPKnEcJEXvHXzKxkv
	+SAwF+0GykvQz+jPhhoZOwfXNsQFrd4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SGWpe6Kk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784117315;
	b=yjJmk40VmjXAcN3dbYXK1eXt+RAs6Yd8qvsCqAVcuVxmCp/Hlr7TC4T8t7GM4dOlzzwiu3
	qLO46sdT0LOUzTkbxdt4kvmipyhAWqoKCL06PgMvmfwD9SwUeyD/jWDlur3NVxSKZebCZE
	oTANc89uWFrx3/Qij1hoRWinn+dm3uw=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2caed617615so60261725ad.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784117314; x=1784722114; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v3KNxe0yLoF7PUMUYd/OqmVO3pDmLAAWwOynTW5KQ9A=;
        b=SGWpe6Kk8d/ePZj4taAy9Oj03EdEotiuUWz+RUFVbyFRhwnjxUQzoNiy8zXNSHjgRP
         aYaJBofT7LVvCIXNNmtZRPgp0uBN9bhyjzBesHqgFzfZgPmxQGQDDB6fLkVX6QGc8KgW
         er4zRzkQTSb873ipnUudBBSLgHWgrBBL408U94s1+3N9X45OKGtHAgRqClHqCx+xTWDz
         WkX3WG64eGw6v4bYr40rafmnfXtr7CAZTA+U1L84+ZImzWIvZ9oeXzYRb4kiq31zoMWw
         Go/FG9CsNtvQ8vnPjn1hGefKWQljWnEfqIWIQ0/cL13jQ7/dASIhGoWY+KYrfFDAZiBl
         Dk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117314; x=1784722114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v3KNxe0yLoF7PUMUYd/OqmVO3pDmLAAWwOynTW5KQ9A=;
        b=POPZgtQEUeEde8AYYHfqvjHSL7RAtw8Vvd0plpLb6m6STdS2BCvnLcnILv9u+HHjfT
         QkBujZYKSyTzK09DgTyzLtLEbPAndwTmLYDqxL8mwmx9DOX4N+ODYMEsC+oNIsXjtLmU
         ECsGqrznb60o2IPL0KUXdudAiM/5KVZH/Y4uJuI/mjGfX4SLV5bYcnArK1vKFee55b2l
         r2xqqAZFbxDNulyx4XI6Di8NiIOC3ChMonMCgad1kXBGksU7z8wMs1sn6ZmqLy8cRWhz
         RnTrH6etsLZaEvCtH0UxPjPPvxKn1g1GfoFRE54XgiTA3olUaGRF27Ci7+lLhx7rP07q
         n6kw==
X-Forwarded-Encrypted: i=1; AHgh+Ro5GNghTmJQbreQXuZZTYtvgSOdvhZ7G1MPkD3CTBKhAS06yx7e17k29JcGTicSHxUQ0R4WgMdBGw==@kvack.org
X-Gm-Message-State: AOJu0YzYYZGSxvuyl6iZxttJQqp7XBthapuW2jryQf511WMAzG6IzUHG
	9jsP8dJAx464Bu4B+IJxQcMWELp3At1/nO0QvBWqXlVsTL1H8X4hpNsO
X-Gm-Gg: AfdE7clFzI85az05ixnNHar1bYN0bOdCoarMTzMrHCL9VKeb1JW7CdVW7wv48tEIv1X
	yYCyeGjirPeFBUx0CN3Bl0gI3DkaxnnyoXZkgeko3rMkqc3OQHPUYNcRmUyTLBlw2szId7a8rEB
	kevz9cjzQkUV7ffEBW5R79XYDiFxVDSULdw/3/xi/E02QQm1YTsU9FGSIxA6DheAyhsudHLFiRc
	fSFchlHqlotcfStChKceH01KAcA+jNVQ8iyvKLJnv9BFps+qzwdT2nZD+1vTaLMmyVLk58AnvlF
	xEqHlR3oOJ3qW1chMFBOsAJvRtU7E9SSMrNZPMKmFoqHCfZsIqTr8+APb5uPZc9HvdO88IKFXP+
	qaAP3H+EjwcdOsBwUrshl6GON8nCfNU/TVXzwC80ozzUAbi7lv+9LX0r36buvBnajC52gekXQ+i
	1nL9wjNdZBKFgulL3OC485mH/f8m5kHCFCjYg=
X-Received: by 2002:a17:902:ced1:b0:2ca:ec6f:aeca with SMTP id d9443c01a7336-2cf03c76231mr23240965ad.8.1784117314292;
        Wed, 15 Jul 2026 05:08:34 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf105bc642sm1216325ad.63.2026.07.15.05.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:08:33 -0700 (PDT)
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
	baohua@kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v7 2/7] arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Wed, 15 Jul 2026 20:08:08 +0800
Message-Id: <20260715120813.3609949-3-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A419C1C000C
X-Stat-Signature: 9eyqtt48ijzf1rbwuiefoyza96tgqrm1
X-Rspam-User: 
X-HE-Tag: 1784117315-282799
X-HE-Meta: U2FsdGVkX1+hQwBLPcocL/nMT3azCtdN/cH4yqt8GbJL6irR33UfIjiuxTl+2OC9yZSbu4WSOU8iON0FZBngsW8fdnhzR3ezT2i4v8vIZblEFYKn1LKSQFvOHkZS8SFXIBQ7GISf66N7y3mG9x8G0x3jBh4JLuhMJH+VpWMxehP4HvDgacJij/LtAuKHgp0QZIqZX6yjqiVAMmFoXtyMa1R8JwO5LMpLCvnG5IxALMar81Me9d44f06Pu2S/5BciE1fBLLTJvQU/cV+sAzwqZJLztezvuLgdGIL97TzFDF2MwFAhffhnti+c4ReFJd+cUs8HVPR1iccMMsw9NdLTtCVG2V7feS0iCEYKAK4JeRV+UY4hlQYBJPQ6Vrlh2IgovcP0FtelvxN1B5vr0q2eWmEU8nL60yuZSuv0jSLH8ZGD2zSG0MkNdOdDrXjTa6gYxpdip3CG/rTumDnAkVCeyCrpemLRjHtootwo4PyjmqpbKnoK0VtoKg1GhkqUH0aa5CaBZUMihO8iQF0EU31AVfN08YRVGCASLnnV7b/YtociNrkabPc53VD0uTp6krx0Aazz4+hwok1kl0Xg5qZo5r9y9E4b4HVAYztasUBNnOczKbNt1svKsc0MsoCEIMxOUt5R2O4nhDS2Z/RBRrXkWUuEbjDooV9QhWmhyO99fFo8AF67k1ET5VNoWy0E6I+ek1Dwm1K0XB2q0feN3YQwM14TIsZ8oOkD/5KSWkYHgVS+SCSucgrK2Djk6+WKBkraMAg2l5gZIkH8RKJnc5yEZeEkzl2sfrc8R9PA7ezplqlo1Aixq60GiytUngywcJd8tMaPaF1VBQUG7N7sAAjIJc62JMdj4XeSjeQ3XaYCajnZSQ0baNHmrb8yeitYVZTmCNJIfyUGRcSvGHeEFstJ8e77ljpT+Ul07VTfTIjI5etB16Lp0lDZ3FtlA+1IkV/hTibGN8usiPz6gfE/TTi
 tgLoDaZ0
 MA7nbfUbRmcq1P5n8aJx9iP5iaHy5Sf8JqlBFKNOQIPSVvJzS7wwk8XEezSa1+YiDhZpZkVb/gn1rKWriEa4K0D8ETF2uTg8eHmx7uqrVMvUaify4ievgHIVYoCJcZ6bUdBlrBF6x1U6jafUs4xkrCYiDmkcS+nS1QR/pwpbTWHCtBkHc+7VxPCNVcfDnSPWcpIEXDoplpJjHK2KDekr0j6ncnY76e/M0HolNR9g15C01RgnKo2IjwqpGqadzRa5fva6WFNDUo5TGDtIcLRRcnH1OKwH4y2KxFKut/k/DSAjHLISM1gVLYMO0/s7rwGjKqknDDUv+gjQLxyuQQ+RyRlX+AhthGhAMooZQS9ITpRUBq1zcDw8Pnlpk4dTDvPBPgc7DKW/zVstNj0ZQElEcdPue0I+STQHoFfyIMTrcWTvgpWmCJAQNwFFEI48hYNMAL3ksgEmoEceCsnkKKaEhNEwHa5QChDuXbaVQORBXotO8cgfdw/sk580z2d0eBw7x0ltt2sDC9JVh3Mms/YuqAJHOFD82id0S/VCmfLnvc8toiCK361ZkfNYdhBnA0FJ+kiLoKA9IylZ1bdX0owqiOEg+Aje+ScUrLR0u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

For CONT_PTE_SIZE-aligned ranges, return a power-of-two mapping size that
may cover multiple CONT_PTE blocks, capped below PMD_SIZE. These sizes
are vmalloc mapping spans, not HugeTLB hstate sizes.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/include/asm/vmalloc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..d665f9d687422 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,10 +23,14 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
 	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
+	 * capped below PMD_SIZE.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
@@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
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


