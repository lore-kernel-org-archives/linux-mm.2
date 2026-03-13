Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D04CD105F7B1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508C26B0093; Fri, 13 Mar 2026 11:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA256B0095; Fri, 13 Mar 2026 11:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC3B6B0096; Fri, 13 Mar 2026 11:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08D3B6B0093
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3D9D5621E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:16 +0000 (UTC)
X-FDA: 84541370592.14.7242EB8
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8E5DDC0013
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=q22VrTYk;
	spf=pass (imf28.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVkBelu4nOXrCEToHgpxpbJSmoGMYEfthgl1FCxyQ+g=;
	b=qXBz9LK4z1HGLgdxOcHe1XB94GD9KAnkZrvHQt96d6X0d/UM7Opu/tAeRc0zW6wGO7f54o
	ategvfT0P8VKp090Mjh1weiEOeAl+c2QiQOQNfMZb+A+QdPLpAF/3qNv1ElA9mL/9k/vpv
	Ywwynj0KhlpMSyI326fDn6mFuP1zXPk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=q22VrTYk;
	spf=pass (imf28.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414494; a=rsa-sha256;
	cv=none;
	b=qDirqoZqQeoUdjhGyTWlvfuTPvnBbFdwmfcOnnoC+4vUmk6EhKxB3zG0R0om9HFQXnmo83
	GkspEjwacTOttMlKe13HjXBgen9fpD2Fnp/yOOcQ5rVWfe8X/vMKSBWJmu+d5/ioVVR3VN
	cEzAFhUq5MyQqzTk3b5GDLM89eJIJ0Y=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260313150813euoutp01edcf097ed0eb61d757898a6999a53d13~cbxX2cDFw2283522835euoutp01k
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260313150813euoutp01edcf097ed0eb61d757898a6999a53d13~cbxX2cDFw2283522835euoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773414493;
	bh=uVkBelu4nOXrCEToHgpxpbJSmoGMYEfthgl1FCxyQ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q22VrTYklKwPz5/JUqBj9GlCybH44mKnzsqxbuQeM7Q+Dxgim68qajX6YUUQAqD2j
	 AL2nhwnFGFAV9CVHv0Is4nSOqo8rStR8BQ89P3QD01n9ImKgzV0yFTv0m2tgbC1eel
	 3h5azmza+8NyP9CBRgXJElbd2wCwCZh7CG8bhnZI=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260313150813eucas1p2486c45e5d13f297dac9db334caa258e3~cbxXjVsdn3023330233eucas1p2i;
	Fri, 13 Mar 2026 15:08:13 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150812eusmtip14ffed3f78a2a054589ad25419ecaccc7~cbxW_dEa-0187001870eusmtip1G;
	Fri, 13 Mar 2026 15:08:12 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 5/7] of: reserved_mem: rearrange code a bit
Date: Fri, 13 Mar 2026 16:08:00 +0100
Message-Id: <20260313150802.1121442-6-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313150802.1121442-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313150813eucas1p2486c45e5d13f297dac9db334caa258e3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150813eucas1p2486c45e5d13f297dac9db334caa258e3
X-EPHeader: CA
X-CMS-RootMailID: 20260313150813eucas1p2486c45e5d13f297dac9db334caa258e3
References: <20260313150802.1121442-1-m.szyprowski@samsung.com>
	<CGME20260313150813eucas1p2486c45e5d13f297dac9db334caa258e3@eucas1p2.samsung.com>
X-Rspamd-Queue-Id: 8E5DDC0013
X-Rspamd-Server: rspam07
X-Stat-Signature: 55agge5eqpe1pcakp1w9bygho3nzgbdj
X-Rspam-User: 
X-HE-Tag: 1773414494-201663
X-HE-Meta: U2FsdGVkX19gMke2dH/yszRdiNbDDGx2fcNJQ+LSYIBowGeaDZzv7Q9OwJfoeW0F42LQ03ZBUmWJxMYr+3U1O5nCjSgToBk7ZRVGR+WRgy1Yi80lMfPeysJ6rou+L/9VltZVHwJ1ojkPbBBnvlRQjdtC0Qpgjwii0DJBOj7sqdcQsfeCA7jdpNQZOukFlToUetmqRYyWrNDoQfzWVSTxeXt9UirPeHQeC+EdxWcmNli5DNGVt7nIjQoPkC1snOi7+6ukYiJA7zG3u3+VfQw06hb4N57e0kBwvMl69Ur+vj4lYFcyYuMKGFQONnEPXjP+Co/jkzXQdV2tfTBRFj4GEtc1FGOvDM36GjNz67dUa3BIaMomTt8WUJgC9ocuWnvkuAQJUIkheg03zYLyUxtlD0g7NB6evxPQoDdEqbREBcIshE4jik8qqsSm1KzsjZNtuRJhz70iKQ2hHSMESxBnQKV2YvjofNb81LyLQaN93UpseOvpgskVCqMgf0c/RyfKXkfzQ0c5CxNAUTe0mf7VeoXjB1lj3cdbzgo4IoyIMC5+f4KDGPb3K4qwQ/epnlWHty6b3RDPdm2zQ7zSKuUKqRpoVztf0N7lf165jGUUbO7rqTR0CtZ5ctZbsZde1liwhYyhZWRsnmumCnKet3hGBRYXGSKT2Czl3UnVaWtvo1ePmwPoVamabRoGH5evxRpoUifYUF1bBTJHJHh4Ylj5votbTPDNIUGUNnCF/0uusnAV6gBIB5pvWSSIDxbmrkPabShpOtPSgSHW5AOi2nC3Nl97jg2iKDnCQN3dFFEGFSiszWFoaGz21ag6Fs3xu6OINyR2IaCNfouMLv8/OZiEilcnnIUYxgOehD/5JdAJKxF9NYRf1sQ/xUd+SD7MRZFRWJa8IQN6uSSd3w5ZcHoBGdunZR1IoB1lQSYzMSVIhhHjfkndl3UAETvghgSErWdgC9l6cvwA5Th9fopMB01
 ZJ4W/dti
 bjWXAYRtklFQ7ijizCxey17wav/RZbaUgMS0rMhBm11y+qguVrFcvb55b80ShnpNKaZ5pnu9cGWLoXyW5RmYd/jiNDmTQI628xE2Ufa6TEoMpvjsasbfrI6jaKj6WP1YLnegJsSKBKjRqXWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move __rmem_check_for_overlap() and __rmem_cmp() functions before
fdt_scan_reserved_mem_reg_nodes() to avoid forward declaration and keep
related code close together.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 99 ++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 399cdd11a9ca..b8d4fbcde3b1 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -214,7 +214,55 @@ static int __init __reserved_mem_check_root(unsigned long node)
 	return 0;
 }
 
-static void __init __rmem_check_for_overlap(void);
+static int __init __rmem_cmp(const void *a, const void *b)
+{
+	const struct reserved_mem *ra = a, *rb = b;
+
+	if (ra->base < rb->base)
+		return -1;
+
+	if (ra->base > rb->base)
+		return 1;
+
+	/*
+	 * Put the dynamic allocations (address == 0, size == 0) before static
+	 * allocations at address 0x0 so that overlap detection works
+	 * correctly.
+	 */
+	if (ra->size < rb->size)
+		return -1;
+	if (ra->size > rb->size)
+		return 1;
+
+	return 0;
+}
+
+static void __init __rmem_check_for_overlap(void)
+{
+	int i;
+
+	if (reserved_mem_count < 2)
+		return;
+
+	sort(reserved_mem, reserved_mem_count, sizeof(reserved_mem[0]),
+	     __rmem_cmp, NULL);
+	for (i = 0; i < reserved_mem_count - 1; i++) {
+		struct reserved_mem *this, *next;
+
+		this = &reserved_mem[i];
+		next = &reserved_mem[i + 1];
+
+		if (this->base + this->size > next->base) {
+			phys_addr_t this_end, next_end;
+
+			this_end = this->base + this->size;
+			next_end = next->base + next->size;
+			pr_err("OVERLAP DETECTED!\n%s (%pa--%pa) overlaps with %s (%pa--%pa)\n",
+			       this->name, &this->base, &this_end,
+			       next->name, &next->base, &next_end);
+		}
+	}
+}
 
 /**
  * fdt_scan_reserved_mem_reg_nodes() - Store info for the "reg" defined
@@ -536,55 +584,6 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 	return ret;
 }
 
-static int __init __rmem_cmp(const void *a, const void *b)
-{
-	const struct reserved_mem *ra = a, *rb = b;
-
-	if (ra->base < rb->base)
-		return -1;
-
-	if (ra->base > rb->base)
-		return 1;
-
-	/*
-	 * Put the dynamic allocations (address == 0, size == 0) before static
-	 * allocations at address 0x0 so that overlap detection works
-	 * correctly.
-	 */
-	if (ra->size < rb->size)
-		return -1;
-	if (ra->size > rb->size)
-		return 1;
-
-	return 0;
-}
-
-static void __init __rmem_check_for_overlap(void)
-{
-	int i;
-
-	if (reserved_mem_count < 2)
-		return;
-
-	sort(reserved_mem, reserved_mem_count, sizeof(reserved_mem[0]),
-	     __rmem_cmp, NULL);
-	for (i = 0; i < reserved_mem_count - 1; i++) {
-		struct reserved_mem *this, *next;
-
-		this = &reserved_mem[i];
-		next = &reserved_mem[i + 1];
-
-		if (this->base + this->size > next->base) {
-			phys_addr_t this_end, next_end;
-
-			this_end = this->base + this->size;
-			next_end = next->base + next->size;
-			pr_err("OVERLAP DETECTED!\n%s (%pa--%pa) overlaps with %s (%pa--%pa)\n",
-			       this->name, &this->base, &this_end,
-			       next->name, &next->base, &next_end);
-		}
-	}
-}
 
 /**
  * fdt_init_reserved_mem_node() - Initialize a reserved memory region
-- 
2.34.1


