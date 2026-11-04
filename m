Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B460606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=mEkANnpz
Received: by kanga.kvack.org (Postfix)
	id 938D76B00EF; Wed,  4 Nov 2026 05:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910536B05B4; Wed,  4 Nov 2026 05:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8004D6B05B5; Wed,  4 Nov 2026 05:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6251D6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:46:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02F64A7DC0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:46:19 +0000 (UTC)
X-FDA: 85397107320.25.D3D31CC
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id B87DF40007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:46:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=mEkANnpz;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf27.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793789178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=8Ms//SCjMBtZLtOk9KuIQ01hGHzi7dKhO5yJDKE3fuI=;
	b=sv16mLQZwhkT9Y3uEi95yHMDsTU0EjFpxwKPGbphvFIZZR60NYsK0nFyLxmP+FHmrQfJIC
	0dWub4ybDR0uI5mCHlvFvW8xmcFkIKdJV6gaU5Pc4ds/686wafMSQOk8HJyqbJgMYoX/nZ
	XHdKde3U4bMiBFRGKIRNPrmoLLwmMrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793789178;
	b=gCUB5n2GYiiz0A3luHSeUoQrn+T6LV06BdaA5DhXR1wmVCAf9ikHW+RVCLilmEwhvpLRsx
	/e7TaraeFxdQrY+ej9d28cg4+UejISxhbKmM0v3zeJpcM58Hm0+mIt5kf86FtgHz4jRHyu
	qNbou0hJYtSkuHO/EsrRri5LZDGcUjE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=mEkANnpz;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf27.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261104104615euoutp02f9c7c3f46399e7e21d7461a9be813afc~k0cBWM9gy2761327613euoutp02J
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:46:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261104104615euoutp02f9c7c3f46399e7e21d7461a9be813afc~k0cBWM9gy2761327613euoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793789175;
	bh=8Ms//SCjMBtZLtOk9KuIQ01hGHzi7dKhO5yJDKE3fuI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=mEkANnpzRYT8fuIt1XolCJnjpE/FK7WNHqpQlhOxxsEj9z90WlqQUd5tV4R44dHDO
	 Cmqt7Sqk6nxqF7pkpQWUCRxq+DvMCNFOj2baJJBAunjWKywRSHrKn71/CwMxvURV78
	 qo70suTDNKKHtYWBbmfUzChU474qnM/FZTLimaqo=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261104104615eucas1p2583cd5bc9ae36bd9ff2d28f87d6e7583~k0cBBCjGw2798527985eucas1p2O;
	Wed,  4 Nov 2026 10:46:15 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261104104614eusmtip1aebd75a70441e6179ea0b97d1d5e0155~k0cAXegGO2242822428eusmtip1e;
	Wed,  4 Nov 2026 10:46:14 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Conor Dooley
	<conor.dooley@microchip.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob
	Herring <robh@kernel.org>, Mike Rapoport <rppt@kernel.org>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] riscv: mm: reserve the DTB before scanning reserved memory
Date: Wed,  4 Nov 2026 11:46:03 +0100
Message-ID: <20261104104604.3370384-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261104104615eucas1p2583cd5bc9ae36bd9ff2d28f87d6e7583
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261104104615eucas1p2583cd5bc9ae36bd9ff2d28f87d6e7583
X-EPHeader: CA
X-CMS-RootMailID: 20261104104615eucas1p2583cd5bc9ae36bd9ff2d28f87d6e7583
References: <CGME20261104104615eucas1p2583cd5bc9ae36bd9ff2d28f87d6e7583@eucas1p2.samsung.com>
X-Stat-Signature: dqiyihdigrbr4riygj4xgiybmy5fnsoz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B87DF40007
X-HE-Tag: 1793789177-120543
X-HE-Meta: U2FsdGVkX18QCyeDzMKApNw6N5g0ayCQ3qQyBaDfu0bzh3vf1VWlj6+NsQ1Cx2v1eNTYqyApgUz8k1rHnlX33eob6BsqhVy9KtpxjNK4ufu/WXXiGLrKq57oLauY2Vt9pJfG/0g2z1sJrmKv52bm2n58PS9f123eibhbaLvNQkHFcaIcnjVA0khikKSGF5yRG6XoR0I7DtvPyL+vU6iKNvF5hyNdN10CXNvPmJntlK5HW1XAAaZaKhVZJYaWePmwQpOh6uRHvredsftr2y4a0HeMCGJTv6pknG9pZyfKiRlX2tjSoFcTWMHvce3HfmlIiO17xonm1N97mfUjlMouL/HvEpxpcQbYOSafQq7TJZxLQh8MWUUMzouvM+bzpVPyDByRR2NYDdmLMBmiRpCWF/+IQM/FhKaJD/0GHe+TWeUmsvuHKNpkIYPNsCGkn+ji5LjJNowHSjjzqf2HtfXHl7tnLy+4+4+4AyTE0cLb9/yxFkTrLqXPksYRtW+Nrb9FZmLsfxVU8tQix+pe5MWFO1TTgYQ110ZPDpOugkPtBFrfM+1bYLgexhSvcJ0LdzT5JTRuXubk/BbIgQnCRl4hrVv3iE2MqiM2PwDEjKm0aXiXtESFIX4DiA4jng6qm32Vk3hwKmjx7fQpyNvkTgN+KTtd0KG8WVHRlLkbNYhqjkKMhQb/EGInuL+gjSfdwWoWDiFts+gSup9IV4XGuc4adnV4Y65I3VhR2nIu0LGg2WDNz1t6FFozpUw4DgLGp4srqxxMrKIFwe2H4/Vq+ehV3eexaSUepTWKdOaBPR2+kdh6TlT+CqZxc0TQ6Wt1HzoTVqMTSguP0YPT6Q0n6lldKpemf1RWWMOROUA8BzojDFGng03nhJs01zfVBqduuEp+RZUhqoAIF72LXza7ub8k4yKYR1bmJqobEGw/+8BlCA8VnkD9AFZ4xfMWSD+ckV03ab8uDSZWxnrsCiR/1Nv
 sq4j2ovC
 SKxpePRkoTEhaPp6bFuLwk3E6GXxr8gkfNtjnWxSUDGoXc6XdRYTypw8pMP5d64GUYla6n6S9DW1jpVd40RMvTmw0RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

early_init_fdt_scan_reserved_mem() allocates memory from memblock while
it scans /reserved-memory: the reserved_mem array, and the regions that
are placed dynamically by size. On RISC-V the DTB was only reserved
after that scan, so memblock could hand out the memory the DTB occupies
while the DTB was still being parsed.

Reserve the DTB before the scan, so that memblock never allocates from
it.

Fixes: ef69d2559fe9 ("riscv: Move early dtb mapping into the fixmap region")
Closes: https://lore.kernel.org/all/b71ac175-fba5-4f61-bbdb-0b98dec9ccee@samsung.com/
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/riscv/mm/init.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e822fce0af4b..bbc2d8cb4627 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -294,13 +294,6 @@ static void __init setup_bootmem(void)
 
 	reserve_initrd_mem();
 
-	/*
-	 * No allocation should be done before reserving the memory as defined
-	 * in the device tree, otherwise the allocation could end up in a
-	 * reserved region.
-	 */
-	early_init_fdt_scan_reserved_mem();
-
 	/*
 	 * If DTB is built in, no need to reserve its memblock.
 	 * Otherwise, do reserve it but avoid using
@@ -309,6 +302,13 @@ static void __init setup_bootmem(void)
 	 */
 	if (!IS_ENABLED(CONFIG_BUILTIN_DTB))
 		memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
+
+	/*
+	 * No allocation should be done before reserving the memory as defined
+	 * in the device tree, otherwise the allocation could end up in a
+	 * reserved region.
+	 */
+	early_init_fdt_scan_reserved_mem();
 }
 
 #ifdef CONFIG_RELOCATABLE
-- 
2.43.0


