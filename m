Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DFA1EC01A1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EF26B009D; Mon, 23 Mar 2026 03:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6156B009E; Mon, 23 Mar 2026 03:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BC66B009F; Mon, 23 Mar 2026 03:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6026B009D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:50:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 341021E33A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:50:11 +0000 (UTC)
X-FDA: 84576554622.14.69111F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7942880003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:50:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aWVLvFut;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSrRbHdXi/ESSIllWcfDoe6S0Vd63YGulx1PIV/SCp0=;
	b=soLhpzjJvPict7ryWPQ7I2S1kyapYhZGoLGFcOfd6HQK7mBFi3z1NA9arvoh55+DdrakdB
	oWd7NFDracBjqWgnQ14b82OVeWV11f9MQ1QQlhghEfRlSCVEgTWfejWreQy0a/ED4acOpF
	DtsSksKS32twP4WCiLOI3Ul4On3dYK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252209; a=rsa-sha256;
	cv=none;
	b=W53vt32aJGGlK/np4SGt6C3ql/LFgyfQJ5evWmHBaV10FOQUJkY1Ee1IzhwhSX2o+t7jPS
	pijtlLD9chuGm+KaeHcj4776P28yGGqFKsVO8u80kj+3Huv3aR5moWrsGNpZrCXsvKwU2F
	C/1/unoM8n+Kuh5qcVYo2ockMMRQFFw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aWVLvFut;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 857DB4061E;
	Mon, 23 Mar 2026 07:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBAEC4CEF7;
	Mon, 23 Mar 2026 07:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252208;
	bh=JX9RHWZi5vuFIJLodu0lHA5nrZZIkASHjFmUizN2RBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWVLvFut4f6MYN3wwvVgBsvFdFfwPxFVLIxEnZF2GAp0JQd7HON8/QxygCU2ypG3q
	 85RF6aLIrLIQls+Z9PC1N5+z9V63pBv8iSd7N325b75nqcJrfzheijh13oNYSPPUHF
	 7H4UTJH2FCWdxQJdQJ0moQ/robJ3B0VZTNpPoyjWFkZEoeQUN2laq6KQhmOmXfYL+r
	 ATjY+R2jtWYZYg2H6wmqiRgYcaDRVxYkBHUXg6eZ2dnlzyU+afaaq90pMJbntP0NXj
	 8kFILSXJOVGHQNzneF/T6HYv7O2tYy9lrUVFuGHfpzFLaD+zWwYbsaZr6rNdr5t1Nb
	 oKdXVBglapLiQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 7/9] memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
Date: Mon, 23 Mar 2026 09:48:34 +0200
Message-ID: <20260323074836.3653702-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7942880003
X-Stat-Signature: ytbkgxg9hzpj4d3jn5b4hyir75t1pn7e
X-HE-Tag: 1774252209-105160
X-HE-Meta: U2FsdGVkX19HUhjT2xhfiSnDn0oixgokYUzHsPor5hHl28LBxKY/pWK47nxMwEUMbp60YGZWDa1QWT6jD6fz1goHqXN5MArWPWRT8fKhjjQH2Haew/AP/0uTdtqR0WjDA9pWXjKP/VsTegC3OVPxONWhO0/ewQthtDMFQJO7ECu2OGaM6ZIwrsc2O1/XRyB6Qi0Cm+XJl70bZzyOBbXKz58WsIqhMad8ku4UqUKHFwkcreyckM5I6x0scDcQtDAEiQrZZQ8c9fMZycZJClXKivZSspdqngJgQ3yqh6aC+ucmwqtm7LCV6BAXBrrGqAGSn1XwrvG3gxwDC48DftLXy3YxyOtKAby4LikVbMIgSVZ8xX4Q5u3K2RU+05/iHVMX4MgGri6SyNVDLXO+JhHWI2Dowg/bPja8Wp5EZJew7RcYGeYM173q51c9owEjoajjyvp66FlZ7MrYTJj7mYq7jLEYtvCdn8FiK+KClEVDLQRQoeA4T9BzXjugn0XUMnrcwr9zJiJ36Jt2V3N2ReJ7sqYoOVEA0wdIhHwx2cyFT6a0wJVrShBsgqmZ13IvYOtfWlx/vVCZk05N0o9q5FYb7nKS7hfZdp5v/DMXA5jx8LCF2UtTUPvk0WhRZRx/LKRp4/BHo80erqamGMzk5b38uasKcg7eQq8SIz7jyA7A1el/Vrczm0aFDuXmcQiYrYAyx87dsetYwiGtBZC+soaOa/lAaZnmlXdQBCTEsu+HFXW3GYYxoIUnUpjJDAESFJS325EL+2cyPz8URDKCg2aSpaTbs0gEEgM3dipuk2WoBOQJGh+v1TI2oftpPptvhhoar550izZr6vXzwwc+afagmdQ4soRXpRTRRzdEHKnJXYi/X0xob5X4wKc4q1+xAtlAbalXCV10f+5rUoS065D6twywmaeu/iuShRUrXIUQSfhRNqhlEA77nYLxKe8udRUQyrAAk6eEKKkMTPU8Id2
 ASJA8SYg
 VdYh8+atpnunlDxjcEORnl6vK2aOy0ituEcOwVD9DtL/zaJy9wXxd0V3lWfiZZFwMGIwIhQrzBaiS/kO19EnRn1DXEOSL8Az19/QXZ8CsTh338gW3axYNeX9Ymx1eyJHyvosrzYFE4UYIyUjPQ0bLNT04WzRssSMo1WHvJnPP6xv+3eW+fA/WMf9AyNR3mruRwL5qD/9HcSDrHKWque5fpirlVpEgoHhnrOYNuED24kYNW65VMDtevtoW1Fet+7hWiOKUnkDpZM+eQyPbDW9hPqrVyEW8nH+yL9UZI3DhPZQp2XULqd93C3JRIFdjkD2bszfjBsWMmWBYxPVyFhhiIBWwP4YA0AWNUjt210xg8HRbjwF0qFEOEaX3WUJ66a/XRfGXG/ARsm2tcp06vR5CvoH4IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

On architectures that keep memblock after boot, freeing of reserved memory
with free_reserved_area() is paired with an update of memblock arrays,
usually by a call to memblock_free().

Make free_reserved_area() directly update memblock.reserved when
ARCH_KEEP_MEMBLOCK is enabled.

Remove the now-redundant explicit memblock_free() call from
arm64::free_initmem() and the #ifdef CONFIG_ARCH_KEEP_MEMBLOCK block
from the generic free_initrd_mem().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/mm/init.c | 3 ---
 init/initramfs.c     | 7 -------
 mm/memblock.c        | 6 ++++++
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 96711b8578fd..07b17c708702 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -385,9 +385,6 @@ void free_initmem(void)
 	WARN_ON(!IS_ALIGNED((unsigned long)lm_init_begin, PAGE_SIZE));
 	WARN_ON(!IS_ALIGNED((unsigned long)lm_init_end, PAGE_SIZE));
 
-	/* Delete __init region from memblock.reserved. */
-	memblock_free(lm_init_begin, lm_init_end - lm_init_begin);
-
 	free_reserved_area(lm_init_begin, lm_init_end,
 			   POISON_FREE_INITMEM, "unused kernel");
 	/*
diff --git a/init/initramfs.c b/init/initramfs.c
index 139baed06589..bca0922b2850 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -652,13 +652,6 @@ void __init reserve_initrd_mem(void)
 
 void __weak __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
-	unsigned long aligned_start = ALIGN_DOWN(start, PAGE_SIZE);
-	unsigned long aligned_end = ALIGN(end, PAGE_SIZE);
-
-	memblock_free((void *)aligned_start, aligned_end - aligned_start);
-#endif
-
 	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
 			"initrd");
 }
diff --git a/mm/memblock.c b/mm/memblock.c
index ccdf3d225626..0ad968c2f2e8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -942,6 +942,12 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 		end_pa = __pa(end - 1) + 1;
 	}
 
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
+		if (start_pa < end_pa)
+			memblock_remove_range(&memblock.reserved,
+					      start_pa, end_pa - start_pa);
+	}
+
 	pages = __free_reserved_area(start_pa, end_pa, poison);
 	if (pages && s)
 		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
-- 
2.53.0


