Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BBECE7AB9
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2F28E000C; Fri, 14 Nov 2025 06:13:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D631F8E0002; Fri, 14 Nov 2025 06:13:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C520F8E000C; Fri, 14 Nov 2025 06:13:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B07068E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:13:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EF5A4BA07
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:52 +0000 (UTC)
X-FDA: 84108952704.04.FCE958C
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A97640012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y9ji6TET;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CgIQM8Rm+rrIBZ65Gc8uDgVfjAkTSjqf1Ed4GSiWMI=;
	b=zNEbvITZNKcderLH2cq/vQp1hCmVsTg4NAxCh3EHN5RYajWlGgEHhgg8XpediVMBrx4cOu
	LxUc0vl4z53klE3/arVn7YGr5IDa+q6wMS7YvkgPKiu2U25YOU48FaxjHQoFXxaQ0dF6YZ
	bNYMj91qgaHWEedi9rHm+TwStzcgNao=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y9ji6TET;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118830; a=rsa-sha256;
	cv=none;
	b=VbWdlc5tc4PaDIUDDc1esGWZuWGug2q7hgc/pzRlQqpZKD5h8LMcIUBVgch8f64ArmaVIj
	Op7lfvTlJGHx3m58riftZ0zfDtEFe3JqCM1bjmACJ1VSuIO+kES8VjEtqVVWidNLg0+rRo
	pqIe1xCxccNG73YV+QLBycnZc1QK+n8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763118828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2CgIQM8Rm+rrIBZ65Gc8uDgVfjAkTSjqf1Ed4GSiWMI=;
	b=Y9ji6TETXOEdJtN7riEZs1egBNIfxqbBF5em7JWsQrRQR5gaeRiytwZ+sxyYdN3yN2wb0q
	Cp2WEDEqOTCXmA8Q46TPNk2xSPagvU9B7BFxShiJtemzQIQxjnYV6Z0rYNSFwfadUPgSEc
	hGyB5DAs7t2eEqKZwitvuD99nlUBcqs=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH 3/7] loongarch: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Fri, 14 Nov 2025 19:11:17 +0800
Message-ID: <146b5a0207052b38d04caac6b20756a61c2189b3.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763117269.git.zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9A97640012
X-Stat-Signature: wxok6bemujux6jxhp1y4wunne3nn8ean
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763118830-191353
X-HE-Meta: U2FsdGVkX19lR8VrfTupCSa9axOjHPWaKUAcQYfVAJsWM87Ojy+FjC8zVRw+MByPiXpoqQTvM+HBKGRydgcU5CT88jFzaKAhuEg/LZkDgkVRDpzhOwtFGPHyGHapILhnXGokkHQn8doE7LkVRTUv0QjClXjt40DIqtIRw+U2QLse6Sw7WwXzyzGl/qm59X1ROsobwPiTq9I1h2Fby05iFSPhKCXLlHEEtr2Gwe6BAJlCah5P+AXmzCvehN6GZa1+OqxPexatFQjzJwKxlD24Ddj7bviluJnd9FzsY1SpYKRwlmZVaQkRW8ocN2yC2dtQZEr3tlyH1sxixQXeLlohMSoUJV/W6AnHUsflxGog7wE/JAo1jzvfX4gLW3OohkFBf6pgc2kgpI/IrGakprNCHujkXNKgyk5b1yCoEzRnGfDN9UlguHjuMMYWifUAT6eygEyCo4Xa+GgDBKTDGF1v5VTAK7TlIJNfH+a+40lHpBLhzontg+DMotL6e86MTIEbE3qQVNen07OsEMm1xuNn8F95nCKdnD0IOEQI1zD/NOuRC7WW46APpMfXKFcsVGDeTnJf0R71ohRYzU+7tB9lITrjNXt3n+dzUcIqQU5UnKHFhwNJ6oMRgTAA6I2c+yMfDJHy8voPdY73y9j/B0ikS725trYK6GstjyLcPdE3o9ktlfcs0uXbVhTNQNCHtk6Rg1uJ7x+CFYW7QpjT79FNDfHKbcLd/Swfpwmul1eBDe1k9QDYH6io9DomCgKMqEOe2XBpfm4BJU6zC89TOpzvwHEQtLE3t66m4Fz4uFsnT2Zh5v+sObHpYc2JHV5ShtC3FUIGhzEaPuNrBq0/TwQF804ArfPIjwca691qLGFUwj8+wSMXySAq/yGgD7gJaqMgxZRnf1o/oa8pZ4rJTU486A/wC+WkHLbLW3sh/ra/Ge8edOE2z2Tn7T+NrzbPg658JbONkJ6br1v0+vV9hcM
 cZxje+am
 fDFgCUKADhKNjrWKBBzFfkPWbSAt6xAhM4ugtezl/PES6qT6atjo/IkmL7deMQ9MRCI8+5YLxZHH3eZfIZdD/Px4FG4HEtqa1sXbpLuoqa225FKpWPgob+cCtbDQp1JhU4f9SRTKCy9rqwONxws4r+caOn+ySCkAxzlp+BAC6ehxYHVe42LCN+cU0oHmJtR6RBH91UR1cZvcsu7mx46akw3eVVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
---
 arch/loongarch/Kconfig               | 1 +
 arch/loongarch/include/asm/pgalloc.h | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 5b1116733d881..3bf2f2a9cd647 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -210,6 +210,7 @@ config LOONGARCH
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select ZONE_DMA32
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config 32BIT
 	bool
diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
index 1c63a9d9a6d35..0539d04bf1525 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -79,7 +79,8 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pmd;
 }
 
-#define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
+#define __pmd_free_tlb(tlb, x, addr)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
 
@@ -99,7 +100,8 @@ static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pud;
 }
 
-#define __pud_free_tlb(tlb, x, addr)	pud_free((tlb)->mm, x)
+#define __pud_free_tlb(tlb, x, addr)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
 
-- 
2.20.1


