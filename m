Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15F2D41C14
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260616B0005; Thu, 11 Dec 2025 05:25:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211C86B0007; Thu, 11 Dec 2025 05:25:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127026B0008; Thu, 11 Dec 2025 05:25:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01E066B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:25:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1679135244
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:25:21 +0000 (UTC)
X-FDA: 84206808042.26.0CB1C0D
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CC8F4000E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:25:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=dkkUE25B;
	spf=pass (imf27.hostedemail.com: domain of 815559068@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=815559068@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765448720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=muJJnWMBp9xL4OG/hh7aijxOXwNHCLCBN54PWmxRRdE=;
	b=VY7/RxLP9zjdLl24no23Hc3AByH/Mni9NM/cooEzJWYPvkfb6lGJ+Uhaq5XS1E6UiVIVp9
	h3cmXYVbfmALBJa868YL10zd0I3F1GN0Ur0kf+sdzvM6/jqKrHsBuV10W4/Gc6dhDF/H0B
	cI8tsfpymvAzYlrlnJQAd2CnWRsa470=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765448720; a=rsa-sha256;
	cv=none;
	b=dgJizrzKrlf/EdErSIgNirXkImp2SmPDX/tiDPAa+n/DgQvzp/LHah7NRGFi4q3JovZzWs
	aYr9HXw1BF6mdEFFBTW5ZZv7tWvWcQtNX5DTH1iqD+AWt86M3JXYGiXc9HaIqzxOEUOIpA
	7hp5YKhpul9BjbA5Tj5VCyF4lSa1wXc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=dkkUE25B;
	spf=pass (imf27.hostedemail.com: domain of 815559068@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=815559068@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765448715; bh=muJJnWMBp9xL4OG/hh7aijxOXwNHCLCBN54PWmxRRdE=;
	h=From:To:Cc:Subject:Date;
	b=dkkUE25Bz1pmb6Jmtqco2Wszb1yLEU55mouR7qShwKv8up3TtCkWHs5fgrQ/d06Hx
	 G7pJPqGPmN4Nnozwrkykrnz9MM5psKARngBe19+d8RPo7NDOB3rm+eqqHO3UplS5kJ
	 9W/5DaqFf0fuGu7NxVr/jceqtofv21DABe92SUEI=
Received: from compass-pc.sustech.edu.cn ([2001:da8:201d:1107::a52e])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 64DA56C9; Thu, 11 Dec 2025 18:25:13 +0800
X-QQ-mid: xmsmtpt1765448713t9xkouwxs
Message-ID: <tencent_917BFA629ACDD8A2E6A32C53CEA147C66409@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNzndnV3ibA/KhHwsNIP1a+wO6MLVMRVgTqboTDPEHdfz8iY3Fy7vb
	 9EE4GyPQp9UMnqSZJ7qOEMz6jx71hlQ8eIg7nBJqEk7aBZSuaWiUAPw8IVg1BoQPefvBdYJuwTBN
	 qDc/cnwR4iX6hkbSbdDLILazoJ6aDYxJBH52MyH3TbwEjDZDGsDdTwlGdG6zX0ZRZ8SzkIxyCzU1
	 uyokvXkWmFmAwqoE+VGSnZ/JwMMnjmYpG3zCQlYpxk/cOFjJ1TlHuA44uAo9NRER0+Vu5K6/8XT8
	 5OJVdt6rxaUBVhRwMZ6HNZqR7oPoahiU+SwQMeZ4ZAbzxZoiwegKQpAl8ZtGTs5mVYjBpG1EeNNR
	 ux5WZvsOoAOlvr+n/RLpImV0/y+5HpVBnooVza1GWBRDuhJ7CI4/PHc1sGxSqwd/coZpHhBqb41B
	 6MdrElfCk511WZPPQdhV3I/0uEXDgbr1qENugI5tcV8VqXh3GjuK2p+FBb9+OAYLs45OmOTOq9Go
	 avLfqgTRTpgmeVxc3ypbZPJcYSZ9xIv/Tlq5pIM7sjT8vMrmYyFccHdfXo6pqKIFM8DYHnoeVuTS
	 Yp6YmwE7Rx5SOufBemTCjinVe2BQZ7ZmmUh55uQtshpbYqjTdEhMILJ7LVjZgcLRn1PjXQTs7u9z
	 2P+db1BepT6zNIbf1Y+Jrx8ESHkicnVGTwmYBgRUk/Bsht7P0pGACEsQ1wm8YJMoYZbMvYhB+4OT
	 CslSAc9NPbDplqjeBz5TmIA/WhT8Xnj+Fy2qU6lMEfAw9SqhF3XNj2zDqGocdSg8LWVHpGRpUPY4
	 nuMjOquN1fxH9p0AT36sCT0AVfbhyiC8UYhTEq592H9lBxaVm3poQOK5H8/C3RxpQ0VCvE5DUO+T
	 BnUa0Ow+IR75puE+k/IBVnX5wzGM7J033JNhqSTI234iM6PgnanzwNwbvGMAByqowVZWVEYwxHav
	 SQC8GK8xAaaTu7T3TR9fY85vU1Q7K21Mg0kiSTvlw3jJZyNSizwWVCZZYTVI8BH+fdBTzMzo3xVZ
	 iEbrB4Jbc/qT88YUd9
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Yankai Xu <815559068@qq.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Yankai Xu <815559068@qq.com>
Subject: [PATCH] mm/gfp: cast GFP_ZONE_TABLE entries to long to avoid shift overflow
Date: Thu, 11 Dec 2025 18:24:05 +0800
X-OQ-MSGID: <20251211102405.1102836-1-815559068@qq.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4CC8F4000E
X-Stat-Signature: r94jd9fpo116erhjtqxanwa3breyeo1m
X-Rspam-User: 
X-HE-Tag: 1765448718-964219
X-HE-Meta: U2FsdGVkX19u9YkYPsHUHfsmoTJ7Qci6wnOU+fjazJgTHwOhFZ0TLW8jPUxHR5VPM0AS3ag+65lEVKoupbMISMPv9CpYY0ARUSXnDlOsxwh3aVtxH8KNWx48BzKyRnejL6eWqeeAK8kARl+YIQC+++O9aPn35nTRXJs/eJgdeltJ1C/LmO4Q7wdxB2oBcdty7QCryTNrjjqgk2ruljtk/brLVyINItgbMHb2AId8vVNUQdp2xxLKn9AJxOcAAYHMQ1Nzjk5Ysl5YJze3pZRS1/NJvsH1KNDrE/1mBbbpEPfoWmsad6AzUpFi0kysWfZAIemKFIU0F/0wxXlI10Fb7AUgnzj2JMnaoLmPMBCO+PrL12tYJ45fpjMD6gJha0qGfhnNbynEQ87pYNEHRwnqCeCxhZSDlzTyhJQ6aKelw+2xShDXq2P+hX1TCSEXCf7vv5VcSVHTc94LlIEg25H4jZ5s/UjEI65l5fno3LrOgwD4nTPPUmU19AhDR33pYDWA8h1jPFiAB/rBAIyc+ymbIkIwr/kVH58yf453a4KDdRB65ny7y6RIwhY690IFieagLTqWbDRvaFNe8Dhrm9x8mglmZz6juVrSB0eUx+Vle6RBnycefTad+BixJAm6UD4Ah8q6V/xgLauaaLoU9eXS9aGLYGaKlNIFMDdfSuG0xRiu4rVLV/LHwF4wyCa84d6WTX3ynCxWQ/iMDlZ0httlbo3ANCbY9Aob/2CCPmrNxgPGOeasi+o++C84giYQYZAMVfLU2icwUDBLNq5Nx/dmxVwcJbeFDKClFFZlojHft3CvcK4nwOTOAowdIm5fo2rl6UheZ1ZcDyZEWXu15UQuMZ9q47eByKStcWDJKOera0e7Soya6y/LQXM5/ic9vtmdAgZhRa4MqmTZMNDi7EaGwzktjv0egNaGyQBZZCSBMFXNdduutL/OKcnMugle/ECHCgywh+aWUsCcnK8Zhbu
 qcpDb1zt
 mkRfO/FdgvQyiPPkryyKI0TT0WLxPM/rKQX59nyMo1VhEQmb0p2Hu6cFODnH9idvTzkyNI0yOFsCzkBxHzy5RjKdMkzayoQSDRnsIk/ipNco2NtWs941peqYjKLN5R+yMrOsfGebdwEVSwqICy+KuendfzNk14xg2tfDuQM63Pjh0XiW7MMOICvHw2yrUK/UmKStFrOyuOwVOyFfk4tdnjKlHpyiMZr8piA0DFTMjzpR2dLzrhfbhrnIdJxAQwIuVUmMQ3uucMPghdFz+Ot9AdsbzlWvllN0sbv8Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a new zone is added to enum zone_type in mmzone.h, the existing
GFP_ZONE_TABLE macro causes a compile-time shift overflow. This happens
because enum zone_type is of type int. The shift is logically
valid because it has been checked by 16 * GFP_ZONES_SHIFT > BITS_PER_LONG previously.

Fixed this by casting each value in GFP_ZONE_TABLE to type long.

Signed-off-by: Yankai Xu <815559068@qq.com>
---
 include/linux/gfp.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b155929af..e694f3103 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -122,14 +122,14 @@ static inline bool gfpflags_allow_spinning(const gfp_t gfp_flags)
 #endif

 #define GFP_ZONE_TABLE ( \
-	(ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)				       \
-	| (OPT_ZONE_DMA << ___GFP_DMA * GFP_ZONES_SHIFT)		       \
-	| (OPT_ZONE_HIGHMEM << ___GFP_HIGHMEM * GFP_ZONES_SHIFT)	       \
-	| (OPT_ZONE_DMA32 << ___GFP_DMA32 * GFP_ZONES_SHIFT)		       \
-	| (ZONE_NORMAL << ___GFP_MOVABLE * GFP_ZONES_SHIFT)		       \
-	| (OPT_ZONE_DMA << (___GFP_MOVABLE | ___GFP_DMA) * GFP_ZONES_SHIFT)    \
-	| (ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * GFP_ZONES_SHIFT)\
-	| (OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)\
+	((long)ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)				     \
+	| ((long)OPT_ZONE_DMA << ___GFP_DMA * GFP_ZONES_SHIFT)			     \
+	| ((long)OPT_ZONE_HIGHMEM << ___GFP_HIGHMEM * GFP_ZONES_SHIFT)		     \
+	| ((long)OPT_ZONE_DMA32 << ___GFP_DMA32 * GFP_ZONES_SHIFT)		     \
+	| ((long)ZONE_NORMAL << ___GFP_MOVABLE * GFP_ZONES_SHIFT)		     \
+	| ((long)OPT_ZONE_DMA << (___GFP_MOVABLE | ___GFP_DMA) * GFP_ZONES_SHIFT)    \
+	| ((long)ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * GFP_ZONES_SHIFT)\
+	| ((long)OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)\
 )

 /*
--
2.43.0


