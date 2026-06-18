Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE4CCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4B66B00AE; Thu, 18 Jun 2026 04:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5732C6B00B1; Thu, 18 Jun 2026 04:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4618A6B00B2; Thu, 18 Jun 2026 04:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14A436B00AE
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:47:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62D071C4B63
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:47 +0000 (UTC)
X-FDA: 84892405374.08.4620019
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 911FA20002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hLUP/W7D";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bbcoKjOxWp5rK+koIv3oGOfWy9Ig7vlkgEF+yecgH8=;
	b=3PwJHwPiCbou+QdH4OLFiQO9TMFK4UGt8XlWYITyAG8C1/Gl4k+uU6OPCF36GuBt3UyvNC
	EvxHKSXDcCImgdbkw5ipbccZ9tIkawq6ujyvlHRC+zkEdJ1a+flD0LSiG1mRaewzW/1qUi
	jt1M9XRd87MJhhjxoOm3TXXv8Lha+zI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hLUP/W7D";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772465;
	b=NaQ6bjwQRHeuyO2aNZcLxPvaBxaND+wU53tO6KmxlR1Qa2Log5ocTniOHX8gAo7pcM1T7f
	m6jbOHIZuya73x61RId2IeXhn4iOQwVxYVs8KNqian71ikBQTNZlup3V6x4MeAJBfiQUT+
	Z2F74G65/s47LDCiUla9WETbUkn/H7U=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36baeec21dcso344949a91.3
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781772464; x=1782377264; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bbcoKjOxWp5rK+koIv3oGOfWy9Ig7vlkgEF+yecgH8=;
        b=hLUP/W7DRStRWdgjPVeeCMs/ScHTpFNLIO4W/+bno+cZo1bWGOAtdQWz6nCvVAX2ZF
         iWGIRx3dK3WLlBcUkBbg5PHEXYgvJYwxDdrEMwuEKvAwJeGo4RYC3S1S67n+uidCwfQT
         SVnLLIDxnwRg59/CDMjFNOS/hMVYnBa0GaXyVs7GadJI3u66t2BYSraGbrgO0A7qrPtS
         0/xy29oBXEbuie7I1XT7zEw+fbgW2C1Fa7zF9d2ZFDu+jUUZVXo8avDrLHnBhFpG1yAb
         olpYninS8FkSIXX5HrvKDTs8yWfJTCUTXKhHCE+DfZi7/RD8nATEonZrSzmedGLY2lJO
         ucKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781772464; x=1782377264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8bbcoKjOxWp5rK+koIv3oGOfWy9Ig7vlkgEF+yecgH8=;
        b=VGJPlUIyNV2yEQihq0/2hpiUGE7nnI8fOZK52pIHS17cN2bmH11ZwfGNKgeHN3wrQy
         FIGgg57SVJUhZlvVsU50PUBM706RbFTwVxcX77LXpyi8Y1QwsS9hnveamKtGYKoROsPM
         OnEWUb7rDJiUC+tzT4mv0rv+IQYR3S63SuixxxM6emy6z3e3wUWsS04E4eFD7nViO+tA
         JjOYVQnewF4g5+U6n9txRr3mjJmOTsykxcNjcWGmEWzifj3Hlri0XlaHjzsaIdEwLNke
         uSmN0twvrqS8K7eLXBhxOI0+Mz4cMGzAaTE0ddIupRVTRub6DzHw1j9TcDNFKkmw10Zl
         /GIQ==
X-Gm-Message-State: AOJu0Yw9wnmKogD17AUdf/1cfE9r2K5UltrP416Og6U5qS3S3T3SyKV9
	JPIApIAVYkA/OOz9E1tBKvstdAP0s80Ve3/94bmvorAcVhVH3zETs4xldSO75Q==
X-Gm-Gg: AfdE7cnUE3FnP/hkCm3RGwqbtV02+3U21bCrussv8if27AU7FMQH9CtQDh6Zx9zQF+t
	2L83Q/S107yb4f/0McKDoaQoteUImYHSLK7HG2Zheg9xDhpeLHgzKdgXv2J/LqL+kcdq3ZPH1Bb
	NGJzbwwDja6KwWxVcRJ+ZY8tA+v5QC0VYSPXfrCnCnMJQovxzPu95wBqHyFLqrVsjod9si8HccZ
	MyE1Fm53xl6v6SkHlOXuhRPNM8CBXlncwZWMJHw3bhx7vu+ZQkJ/0uNRpXnDjUw4/NwhZTbS8Rj
	SV8wLzdwvhX2F3AC8mIJSdDU6rx3+e4xFdGoBoCRTCJC5TzLUxPq2ZXa+xW8UG2amS09wH45efZ
	8Lad3ezCpI+KUgvM2H0f0pYz5y3gdj7BHarKtUhl5uCXjvnbmCVv67XV5htT/xyKVzBSsLGqQTF
	BVmz0OpveVc1u5WmdGzQ+hkSx6Jozgvj5Ii/U=
X-Received: by 2002:a17:90b:2b47:b0:366:132:fda6 with SMTP id 98e67ed59e1d1-37c9dbbdb5cmr7450798a91.11.1781772464450;
        Thu, 18 Jun 2026 01:47:44 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521d8e7bsm8628856a91.5.2026.06.18.01.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 01:47:44 -0700 (PDT)
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
	jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: [PATCH v4 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Thu, 18 Jun 2026 16:47:22 +0800
Message-Id: <20260618084726.1070022-3-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 911FA20002
X-Rspam-User: 
X-Stat-Signature: ttjispnggix54zhouht43o4ok1nuyzow
X-Rspamd-Server: rspam09
X-HE-Tag: 1781772465-616690
X-HE-Meta: U2FsdGVkX19xtHonNpvfZ/nq+i2wsTVwTEM4U7HPSzarzCQT8QxQ5rsYuOpLYe1AQoFy8+6HyjalsmiifHsxtFfKAQpjpoRV4hKsS4qve9OuoVE+Ni1NnVEfaF1UyRGaxde+j0gpjDJYEebvfEKQIgkPLa3k48uXepwkPRa/TQJW6Uf9tTlA2bGbsoeyepMJm4+GnAbg6r1bN9Jg/1dSaQ0AcIZnbGKHKrAuJrobuuIJjILTPRPx95fEQ0I+mUFf36eX0QAd/QLcTs5gtzBDZVUZIzjqm8W+aqJPpTjjEiwL2D18pRTgJ2qz2USa1xQ3MfwOQOh0u/kiPIwzA8z5TJOdQwT0hhjHn55pD/c+vU/+oYGniNYguRjFPs+NOhGr2CPTX4KKdNA2PJoPERPLI72X4VJyJAIHUVmZBT/25Pd6nZpyKjWLrKwdksjdKve35mHrhvmblff5LWl38sb6tLk0QNkz7nexoqv/6wFNiiwO8Yx3a5OFgnOHOh9VlT1G1G+Qp/DlQSa6BTPlHavIai3ctQq3sYoJgoYmH9B9Ml3nkZvScxaaPZkQFCfNgTD3kDC8+YcirZo9LG2TYw0SeJrINgGrICy6JSfJ2EYRTXQIqrvMR5IJYbOmKugqFWjY4Pp3uRc9YupFhhHlp+UmS9mlce+640p2cqfSG+PNRdudsvca0Zc1YxQkA7iR6Xqu7YXKhbHoYRkcEpSEJMjrbrdgMJnbVcxvUvv8aYB4XG6I0PmsIyWrNm5HXzt4Zfce8FOxh3JuVeOFDY9Hum6cVLq7FO37LJAJfRKzD6nfAxaL7PQnEKDIp+E5juJJsBboxZBzSs3eKkK+lKmayJaYcJ1ZriRi3pTBBGPtQwWSpTlBajKYj9NQlEN2pqBAFCmKrNtZlSUfCB4blWFE0xdabh130C7E/mhv0R+M7a263Jdpy6C1nWn/timWXwkKNBkKGv1XoaocUn5gLZ+K57H
 LUUfgEPQ
 Tx5iFzwt6UaiVnOBolRQMxqaf6qQGqFjdiMQILp/kgUwFu2XFOi7Fsaq+lc/e51VXR6Hlde1b71J/8oP1H6AGZt9GN0TnsixSo+6Ouf9K1llPCX4Y8lL/w+uQG0yaRFOqKQVwIJQFl+SHdXfuWcoxmkWI5avUdmDNHqsnzHHpsPpWbVWU03o8m+wp4fQaZBktqwanxWDIFcaTEy4vDVup8Qj4BLALEFcRicyoTkm5/UH3kE5DChHc9BqoYO/AH+tQ48AMLG4Xi0EGEvFplrmwVDoa1gy7VOI4bcK2o3K4Lt8cEqERNNguX91h/S0bXZtV7l1ZwyddY1hq0HqFOlW09v9tnjJQyWKdT+bsfVqfexsqBTVTcoSGQ1YtEOVD7lg7P2qrwteYHGTAgxHiUyy/5msV9lmcQlntEJr4SsZf1HFjYQ18nIbECpiU03wDHrozxrVmq3e4vxg/dr8kQClgHKGXqXIBvJd5UCyBRPLeo69P2dXM1PV7/EsPrvzCCr/XSJ24t6taThzymVGGZBqdxnZUwG5D69XtrLpA
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
---
 arch/arm64/include/asm/vmalloc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..787fd17b48e2c 100644
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
+	size = 1UL << __fls(size);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


