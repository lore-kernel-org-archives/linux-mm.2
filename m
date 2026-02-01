Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC0BE7C70D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 06:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767486B0005; Sun,  1 Feb 2026 01:35:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713C56B0089; Sun,  1 Feb 2026 01:35:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6256B008A; Sun,  1 Feb 2026 01:35:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0A16B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 01:35:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80C5F13BCB8
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 06:35:52 +0000 (UTC)
X-FDA: 84394927344.20.AE18DAF
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id B009780004
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 06:35:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dahkxK/5";
	spf=pass (imf02.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769927750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+k5sDfrzGc/t0c0Zqa3NksQEBMmv727qk80IVOuHas=;
	b=RS0jKrESCJHBF5cYDIv2J58baRAPeVQEPWFl9fpW6ijMiKZaj2FwwizluiriurMi2jI6Gp
	5Ur256WSlUnuKewu9u3KBXqCKvd1Cmnz7ybTqWwnQbpSA7Abf7Ai80pAv9/8/C5fsQvzWV
	xGG54ow0Yl/diEtBNCmb3JZuTpVGTKw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dahkxK/5";
	spf=pass (imf02.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769927750; a=rsa-sha256;
	cv=none;
	b=uyTk2gJxgbAk7V7kt/AziLStFL7t0OWRSFPdZR7aJiLuW4L7bQYKRwrSHWUNGbVzLjqHpu
	3wKW7hgU1XQknXGIVnDlUHYkzqPjvceJr3eVvIqirqOWmPSJKdS59Sl8LSGRPUpq08uS2P
	kxLBvsIQ0j+nvblRaapxJAzIo204xsM=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-823081bb15fso1772229b3a.3
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 22:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769927749; x=1770532549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+k5sDfrzGc/t0c0Zqa3NksQEBMmv727qk80IVOuHas=;
        b=dahkxK/5zAFBeYuKHu397I3DMVj0aABCS7o44OrJn61WKjSZyp6ey96aLNaynvwH3k
         2BgTJbq1JlKYWY6TxVahD+x6fWhR2xt0DnxTTuF2hEPGKTkz6ThepE7C87LY895xPBpd
         Zvi+zCVwRB4Ve2cy0zK6WLHl6s4hwxMojJWkBWIkfsQo1FYjZox9OZtKEaZMqRaxMwpw
         6lbuvMO6OQTV2cbW96OnCTYDy/tDMXFgK/xo+81qfm5i5DaPYoZQoFSSvQjeEmlXiwkk
         WnvDDOY2LKiPbU6/ivvHrVX2mufOmCIKeRzTz/exTgonGQtO1nWRnJx/j+fuYXhj8ZBj
         g5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769927749; x=1770532549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6+k5sDfrzGc/t0c0Zqa3NksQEBMmv727qk80IVOuHas=;
        b=uz5856P1hBp3FirWvI2DwefdXsbhBvPCjUuDpxBZNZ7Gpxcdt5NzUHrL9zcz/0dCxF
         EYaTyWO5ijGbfRRtFaxXPNtOdJyzoqh1Xx0QHhCvD+wvxb5dfoAUYbg5cwKOs+3644Zl
         tJsVPY+1ktSBgWdlERaWR46yl9RqAPI8ZWD5cCNY1PMd2IwtN88Nztxya+jpOf5cp+A8
         SVHb9GjuIyg6ZXQVhnrm0EBJN8g32aU+uiTE9Vps+rbzJGHP3OKI3wHbGAYgVQW2Romp
         DNrxaiSKbdTXxQsSWedvJo3ZLjUQ9Z5ZR/QIZ5n321a3pwtrJfQRg/C+cAciV37o+9As
         LRjg==
X-Forwarded-Encrypted: i=1; AJvYcCVdmBcobeq5g4vcumsIk+zKehdsQK55wc5gfteQN6Zeqm3Se4TQqE2R5fL9JNAYu90saJBpbDpsKQ==@kvack.org
X-Gm-Message-State: AOJu0YyMAVNr50FSGoTg9SqIm6rCy3jconGpaD/gwp3RgT9rFAhTSyWr
	LVRyLc58KACF/FOQ8uYtCK77i2mzLKcmlxxRklHGSJxi2fmnGjgxAqbs
X-Gm-Gg: AZuq6aJ7ms/wOc3Z8ofjvUXJvNMuvt4suDpYiPsuzUgUUUBsjhmQ5Em3Ir0Vr92rjzb
	ou2fWjVl976kix7bxmhKQsY5zQ95iGo/lHDF53Apxcly1Cg8WlXhd6lO8fyynOhwhkL9754W2O4
	kXE/q9BIkhIX5iBz3XbBu8Aykz2IGGOQ2Cva7Kogncz+oxNN1/wN5dNZz1oeNhyt2dX3EwBa9aw
	UzKABjv6px0vl3KdoZr4mJ7spQGm2KN1SedQ+aHGZH/R6X/2KGY2aQYLoZNm8WXQ8nEtRBley+v
	9HudSs9neqA8oerzQirddiAwIwvkpC54FoAJX4Yvmjrg3t7duSCLoUPGeP/ZO8dJc8nRnSCQOJZ
	tZm4l6fC/F1hJDRatH1A0BBbkocKh07E3yS1x1mhh8+AHsZjgEZM8r1ETWzf316Q+SpnpPPY0n8
	WFdJq7GmA6NKSv1GZ387vcIlRA1q/uLzOpHb6uC4t5vw==
X-Received: by 2002:a05:6a00:4b46:b0:821:70e7:b10a with SMTP id d2e1a72fcca58-823aa40d7e9mr9263325b3a.8.1769927749584;
        Sat, 31 Jan 2026 22:35:49 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.120])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6b2bdsm12149294b3a.30.2026.01.31.22.35.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 31 Jan 2026 22:35:49 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v6 1/2] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
Date: Sun,  1 Feb 2026 14:35:31 +0800
Message-ID: <20260201063532.44807-2-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260201063532.44807-1-pilgrimtao@gmail.com>
References: <20260201063532.44807-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B009780004
X-Stat-Signature: 58h6gyoorf6oheqkx81aisndh57rkkdw
X-Rspam-User: 
X-HE-Tag: 1769927750-989445
X-HE-Meta: U2FsdGVkX18FYYjr1OklnFWk9tdjW63sOKs7wLckBZm39LBH5258m045CA/oyFh0j3KLa93saHnmr50IPYMlwX4fVmdy3qh6URIzFEaO6S4dWMk6HnRPZHHR+ZgzXioXPoxwB2I3VHPdLmOZgZh5oP3AEiDlvaijyw51J8wXI9beXrwlnEyLpPi0Ag38A84bz7mNhataem4mQvMpGtYGnz2mzGzm8KSy2+DZnwpLJjRzwZy+0b3ZSgH5f+ZXwrAgaPFy4AuGSA11237GKiALmKRIM2ZlMuyMG6irPR9mCCYCPzTbZUd6uPei95JlAJWWTmRG91oFJcPiGXlsUn658FecBLBL5oqgGYKLw74c+lhlwLKCqv0EiNJUPJNi0ZXBt/RqFFVWdqFgDFoSaKYH/7WxD6nvIUY5VowyoiWFyDXOZ/YBT9KqYG3/AaSow8wZD+0TqEtpeHovzIhhrripdNj6s+e7zV2rMnimNCPKlGZI+OrMLM23BIMkQQHaVWeri7C+2xFSzbmFsFAIHaouWIeo+uuxlG2K3JisIeN/2CK/LkZOM5+UmNgpbjLPior4bd8t7fI9UrTRrLpkdvgoh13AvdbcIqoW8uPOKiCP3tAJT2eglVQel9VBrLwL/t9EC845gayja3uFhjU28Wh+dsu+wnM/sYEThDFq/Qba+VdoLuyyxWxoBDFya+TZkn+cGxtNtS3QIMHGOLgxctum307k90SqLfjh5XOVy3X4+GPfDyzGE3/bTjbIVpnzfb4Qu27vnp26iqPN3sbSdZDTH3cocumrFlf6qWUkM/ZSQRZoRFacS0M8At6R3w9/bTUJ18QgUg+xgX43LpzFBfYLU1uC9gqWMSxaE5LjEy/AQgnYqqea8yYEgVM3FjVbiiS4UzxLSHd5ut6DTr9cFPR10heSVNgO8n9WW5VkVA55mRT1THyzX6Ih9Jf/hMcEES6XujNokwD0q5A1g+1o9uL
 QiiVsFJs
 baqU/J0YrTsJs79ndxY6VpTcOrOLmLPbWW4ITu30T29aB5L0C43tbx+qCdBaJU6xePt4D2CuqyL38l92FQkQmAQX7iVk5TqaqBpP7ilpVJYsaO10eQUOVY11iM6ARbeiDAcoPFYWizj13q7Ih8dSqN4n+da40biiznOkSFpMwHcbnL+FPysEl7ZW+tNw+xj/Qqf7Nda/k4w84EXocm2K3eDOOga8BcMC9VBbvg1Ubp9G3csRRLUIGJBJ4KWlqLDbGllzWP6+JoHk7bspC5dSDZMFrmyBA6sKHWue+2ytHXJApxzlWJj34MSR9ZqYMsE0Jq8J1N5g2+sc/N1c73xYRON3tx8u+KF8blOhSSdYHaUkRoXsNFubx5uVHnnGTRQY/ZPNwtANbaNfyKvEvVK6IYaPSHRHUi39ANKqZsyBKhMHsp6jq6NDrNX5BGDEGLKY0hhWjZ6lXwKx5315za8Zt9DS8gDCUxHrFfi0lfXerPkzNUUVHre4lzkkJPWxanWR9Z6WpsH4J3zF9JNedkQp7RevI3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

1. In the SPARC architecture, reimplement vmemmap_populate using
vmemmap_populate_hugepages.
2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
when vmemmap_alloc_block returns NULL.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
---
 arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index df9f7c444c39..f1981adc99ac 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
 	unsigned long pte_base;
 
@@ -2595,39 +2595,24 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 
 	pte_base |= _PAGE_PMD_HUGE;
 
-	vstart = vstart & PMD_MASK;
-	vend = ALIGN(vend, PMD_SIZE);
-	for (; vstart < vend; vstart += PMD_SIZE) {
-		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
-		unsigned long pte;
-		p4d_t *p4d;
-		pud_t *pud;
-		pmd_t *pmd;
-
-		if (!pgd)
-			return -ENOMEM;
-
-		p4d = vmemmap_p4d_populate(pgd, vstart, node);
-		if (!p4d)
-			return -ENOMEM;
-
-		pud = vmemmap_pud_populate(p4d, vstart, node);
-		if (!pud)
-			return -ENOMEM;
+	pmd_val(*pmd) = pte_base | __pa(p);
+}
 
-		pmd = pmd_offset(pud, vstart);
-		pte = pmd_val(*pmd);
-		if (!(pte & _PAGE_VALID)) {
-			void *block = vmemmap_alloc_block(PMD_SIZE, node);
+int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
+				unsigned long addr, unsigned long next)
+{
+	int large = pmd_leaf(*pmdp);
 
-			if (!block)
-				return -ENOMEM;
+	if (large)
+		vmemmap_verify((pte_t *)pmdp, node, addr, next);
 
-			pmd_val(*pmd) = pte_base | __pa(block);
-		}
-	}
+	return large;
+}
 
-	return 0;
+int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
+			       int node, struct vmem_altmap *altmap)
+{
+	return vmemmap_populate_hugepages(vstart, vend, node, NULL);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-- 
2.50.1 (Apple Git-155)


