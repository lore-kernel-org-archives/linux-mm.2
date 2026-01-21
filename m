Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E9AC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115C56B00A0; Wed, 21 Jan 2026 11:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044D16B00A2; Wed, 21 Jan 2026 11:23:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1B166B00A0; Wed, 21 Jan 2026 11:23:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C3C0B6B00A0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 350EA13B95E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:27 +0000 (UTC)
X-FDA: 84356491254.15.6C9F7EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A4E120003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t0UiE6bv;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I0nNJxNzYL7C3daqIGejplAJeu65vrYqe9uQOQHOPSM=;
	b=dW0f4ndt16gic00kwNFcJcWoBK/EgcBavbomAUI4pIaLAZOeoPToOPMh9RrQHjgFDqQnz3
	dkALg1cAW4orHHpXncyl4kqFb+8UZIEh0HJSbfQXPU41DG7BHbtqw5td8kd/0UrMLO0e7J
	iScgJsi+r8zceJgXBEmMjHhDqsPdkCw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t0UiE6bv;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012605; a=rsa-sha256;
	cv=none;
	b=5mElyYfvVNLgvrliyvPo6G6Ax+A2qTDr+ToCinAl1YF/sRhMjkUO4XKTGadqSSJ8uVks80
	T1YuQ/1zvENN/b9lsa5R0/egYZxJ8dUjpJ1iiMAJyPCuYSlzTscx6/KqFXcY7zrEj7l9lO
	LCQZxkMcGxxs1JpWw9WBJaaKDeoSSVI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1B5860130;
	Wed, 21 Jan 2026 16:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3172AC116D0;
	Wed, 21 Jan 2026 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012604;
	bh=G+MNU7DgEj1sJhXfeeHNFOyPFz1DCwEooo5Fb5WVje8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0UiE6bv8f+PXXOPMzCiP95b0GOq5UC6rU7QbO2Sa9zYWze4hreBBdDNRBhOcU3tP
	 i9SaBhxLqiocz8mixlkjKuixQH9R0AEIMAK5xu+P9vlftTXdt4w078kzuz4DZgWaK3
	 0ejuINFTR9I1NAjLGdCgy8VDb2SGhihwYP5KOFJSB/xtIrRQyE3xU/ehNRcEPY7AsI
	 fhwob2gUV+aGc2n8e4EtoACAGYfTmbXXOU5ia9tNiXoZRv4Tm1PMmcyXbGB9anki4B
	 Wz/4X+MRgYOIwK2uHGaLV1ubf/a2x9CBFgm0nTL01q/1ZW++gDmy4WH1RPt9RzwHQx
	 HNidvDd7iaH0w==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 69871F4006A;
	Wed, 21 Jan 2026 11:23:23 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 21 Jan 2026 11:23:23 -0500
X-ME-Sender: <xms:e_1waaIRGXem0bx8iG_3QfLRUNEy_WBX74IpPIiGRGgjaQg8egIcYw>
    <xme:e_1waXQCOxOUeyXPwNjywubSL_7hBoD2yZnN7uTiAS5_XKtTNdyWGLz3O9vcjvDDL
    rKoGhm7_9iwjuLwSCGC2ZU7xUjHhRDItjErpJfYhdx8ncEwcoA_Crg>
X-ME-Received: <xmr:e_1wadoaFoy6I0tsZ6MhgAU8bPnE21Ssk0G6C1VzdLAlw_p11lcLtmS17LmOqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:e_1waVaTzYGafPWupelOvSd9QsFm8fy3wgjGPHFEcc5geWru_P8sZA>
    <xmx:e_1waYROMjpu0b23YrY5iLqH-auca5B7Pyk4ZtmJBlUAqrqWejG6PA>
    <xmx:e_1waTftudyh34O1p0wQp9CffgBRA0WZ1io8tzKT7H02tLIAtvJFTQ>
    <xmx:e_1waXlUcLqpvIjvfICQFoLnilMfFGGu9rKGeRDGgqyZAiuCBSPpmQ>
    <xmx:e_1waYhmsJaXTEJWwGGyUrLuoW86a4EuIXnNZobCxWGGm5zB8rsG6zJo>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:22 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv4 13/14] mm: Remove the branch from compound_head()
Date: Wed, 21 Jan 2026 16:22:50 +0000
Message-ID: <20260121162253.2216580-14-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A4E120003
X-Stat-Signature: yzzh3347d4g1h7s4dakagte814zm8e4f
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1769012605-178526
X-HE-Meta: U2FsdGVkX1/dSF4ezbTgYa3Meyb4GSlHBL86reUdxd5CBqBdI1cBa4owWldbZvY2IbffGbkmHULWMdqitVmqciVbCcYUVY+7aEWpHitsG4C+cwmxsG/VK45DjOLs9Uzz4Ta4nmEtotTcWP3WRgQzWnAcN2HlgIGvvclQiLwmqWH0eiwJTa3UQ4XzpgFMd8PQ2D99a2jpoASlDkNOexIrc2+7aqO4Me4dPd/Q7TxELaxvUVS2LxpzUjQrDQ3hnMDT/4fJYR4ekHrojxAvL5vDNUomryLtvjpQJkZz55XpFoyG/cBjlA2EDogJFLz+Xfmh48S+wA+NnZuEi68qnS+SQyLp4p7Zq8+RUVVxouV5koqmE3CzhX+IUrA8nWz8UvglfPdE+pix/s4nEYxJWgwN2r9xuwE3i8v47MBhLZ7prJhx5CHN/S8H8BCVuhleIkWaLxBvK9mbN37PnH7EQqIpZEdM4dJjrt0qPAMBzGzP/X/4xSmbiexXVGDcrSY+d2xJJ98E+2jHZikEPXeeFtLWw54KthKxBdbdx0hU3IG0Rzf45XLePtbIosQbgr1/9jyMGcTAPzGLyLu2Jvsi0I0YSEM3ZAUKBVJBjxfBBObezFbHy2JY3CmvEhpEVP+vB70DPowfFz2zwrTWBK9zx5LntgC9vAUGJ/MDdCjUurQiCCG81aG0r7RULo4+/Pr1Kq3Q9OiUwCDb+9cpQYDL9t8fiKTQQadYilelp5brQoqK7GreBC8G/83kk9Umz4IMbLWq80Jv/Sl9/a0PIEbQMVM39qnimdOsoZrr/El1Nu+GzT5qjUPwH2wnsLBtWA5hPJl+BFCq1/fdcF39lXMPfG/SYQlvirtQEaUZLzxFmzPbiiiA8fTD1ihjTACB5cOsX3w2s9yeK99ndEnBSficxN1X9okZJkQ6obEtgtJAcpUizpVqFmFrjV7a5v9PBHsfL7xoYAvY56KRK5x0pfTGlSM
 8NCooqaP
 6kCbKE6MWqcsUXFEkaE6kZNyFUo8lHjot/1o4fwAgxLtX/4sGcNWLo8eooBOo06Dfg52+84VA+Zw0Pv2mlhnVtlGFNFesyvZYLjZ/UVXLCgDUALnxfCSVp7LSpVrQzMpnu32Hz4b/iXhv1zJ1xczO1lhg8Lu1c29375BqLrTs7aqYXIofEqcwUBOiCS5k6eQVFmrcG8w1b+6kZ6za43KGuLuP75oGpNSmOqXYWi/Z9ZMHYuQesaIk6+GdSmShrdnLO5mAE6ogZpAmCY0V331+FDsat3citIia31gBzrkiauLB66M1R46QNGtkqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compound_head() function is a hot path. For example, the zap path
calls it for every leaf page table entry.

Rewrite the helper function in a branchless manner to eliminate the risk
of CPU branch misprediction.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f89702e101e8..95ac963b78af 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -224,25 +224,32 @@ static __always_inline bool compound_info_has_mask(void)
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
+	unsigned long mask;
+
+	if (!compound_info_has_mask()) {
+		/* Bit 0 encodes PageTail() */
+		if (info & 1)
+			return info - 1;
 
-	/* Bit 0 encodes PageTail() */
-	if (!(info & 1))
 		return (unsigned long)page;
-
-	/*
-	 * If compound_info_has_mask() is false, the rest of compound_info is
-	 * the pointer to the head page.
-	 */
-	if (!compound_info_has_mask())
-		return info - 1;
+	}
 
 	/*
 	 * If compoun_info_has_mask() is true the rest of the info encodes
 	 * the mask that converts the address of the tail page to the head page.
 	 *
 	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 *
+	 * Let's do it in a branchless manner.
 	 */
-	return (unsigned long)page & info;
+
+	/* Non-tail: -1UL, Tail: 0 */
+	mask = (info & 1) - 1;
+
+	/* Non-tail: -1UL, Tail: info */
+	mask |= info;
+
+	return (unsigned long)page & mask;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
-- 
2.51.2


