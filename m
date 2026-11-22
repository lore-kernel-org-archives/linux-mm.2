Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3234F606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ohEaID/L
Received: by kanga.kvack.org (Postfix)
	id 2B79E6B05BE; Sun, 22 Nov 2026 13:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F88F6B05BF; Sun, 22 Nov 2026 13:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B156B05C0; Sun, 22 Nov 2026 13:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6D8D6B05BE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:13 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 566911A070A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:13 +0000 (UTC)
X-FDA: 85463632506.26.97CD633
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8B53E1A000D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="ohEaID/L";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3NjgDawoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3NjgDawoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373111;
	b=FOkhbR5x6d6KzlBY2TGJmeMvnWDFQMMsCsUU8pknGyN6tz50LzAV//ndUv6QoCQPsQDFY1
	KJOlyhD81NDblGfXbSgxSKC/jz/BBEMwhwwBoSNcNVCJ7MBV8SEgOXkhTWX4+qAFuYWNhY
	hqCNnxWFPDtZaOXjQjJ/XOdk0OuaNPg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkLWabiVP2N6o8/3oJvFuhS7Z3IRmMXaOcCIdqoyE3U=;
	b=uiGZVzd9GTVoYrmlDV3SRkgG/G2g+f7Bmw1jkURHsGcgaB1Mi8j8LDWdybFdAZXv3p4h3O
	v7ugQvkLimj5zpujUx2VIeQRMk7v6W3As11jm6+VCXHC9WcUX3te4aeTOlomZ/Rd/iQFkv
	CGNycd1ATHItzgdYAUldWaidPb2Ufug=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="ohEaID/L";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3NjgDawoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3NjgDawoKCBM2C07Dz0C76z77z4x.v75416DG-553Etv3.7Az@flex--jthoughton.bounces.google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cddf34086c8so1521334a12.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373110; x=1795977910; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BkLWabiVP2N6o8/3oJvFuhS7Z3IRmMXaOcCIdqoyE3U=;
        b=ohEaID/L3qpzhB8zgZQSvAb/UmiZDffGrSX48msMFIedqHonO4SFesokPOPgfC2l7q
         8uuokU5d02qkM5QSbr8pCvnD6k2JISpMvLiqnjPjMndK+oiuQz9PB8lCIWQTtQf6lDM5
         Ou8vUfBIcnPfNIZXYw+5AafV2wuV9ysE67Y61ccmAGL3W3lm6z+1tp7WB+qgjsdzXmR7
         1KDeMMaYOGB7HTmWxQNAeVZGwXn5bzfMOM4cC0nzIEKiL4YlJLjhkUEEVhNdc7rkgBGA
         XydDxgZhEwvIJWmY9x7a3/eTcMFnBI3T64a0jEIAEXY/rSljQaYZyAo+1G/HizTIEXJn
         xlWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373110; x=1795977910;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BkLWabiVP2N6o8/3oJvFuhS7Z3IRmMXaOcCIdqoyE3U=;
        b=aLNLolvRXnMlOadAOYlUSoGBfY/72K0HSHymjHUX7zgo+vf+IXLp85cYxGz24BwGE0
         5athb14vtTryo82+GyN0nF5RB9Q6pYr+HKI2x3gNbNIFJ0t0uzFeXigR/XyAhT49lSCZ
         wtaOgG5Ldb6ox3hFBcp7fCkmHojAd/5kNIpm0DjgU2Et2pwcserE8Qxg3wHYEILhgh66
         YQesthwoRrGWzELGBajY7FcnpdEz0XcnmHT9WM4yyPSMeSFqiXQ0rOEhXeYjBetNCLJd
         rO+910/dZeZBw7erCjlxdMwVZkq49WDIKFAvNosa7EimkvmMLsbhJQwNz/WUHl34Kper
         dCSQ==
X-Forwarded-Encrypted: i=1; AL+hErFQCvr0j0+acaBgxbquv7orEmz6AEj8F30OI1IOBJlK9lwqDZrCtkQGRW2HLDZyshgHru9dGKHEpQ==@kvack.org
X-Gm-Message-State: APuU4Z8o+L8OHypCyyKNoJ3IcX2Qe2loZchjUz2J29wUyBpOip3zr35b
	Yj7K0qWAsWRp6liRBZzfzfNhpu5Gglxki6RPDvECLBnne14xloYT2L4rCjGzH5FE88fmW4u06o6
	22dxwjczhpu1GqmLBy3v8Tg==
X-Received: from pjvh9.prod.google.com ([2002:a17:90a:db89:b0:3b4:1549:36a6])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d10:b0:3b1:b66a:c05 with SMTP id 98e67ed59e1d1-3b41c8e0c5dmr7640072a91.14.1795373110066;
 Sun, 22 Nov 2026 10:45:10 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:45 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-12-jthoughton@google.com>
Subject: [PATCH v3 11/19] arm64/mm: Align vmemmap to maximal folio size
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B53E1A000D
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 6uzf813xozayg1ikj1choc1886z1gi4e
X-HE-Tag: 1795373111-709375
X-HE-Meta: U2FsdGVkX1/eSSZN/lsAZcnQ/6/2HB0AaA3e7Qbl9XJ+SOGtHwoC0XBEPx10SRYNPCyj6vkQ1OlsRoCUSZrg2K3mPw/6lNa5SMJE8gtsM6a9yg/b5krlH5zypPYATUusFa0QuqQwB2AZjqnup3HnIdyybRcIN3l3cZRmcvZwTenXOCqddFbtZEfD1tWRASoN7G6ZGQh/WNEw7Cfszzj4OprJyTZXG3U56M3Vq3Udd8mgluaFjpEj3W+vJTeGPyfq57W/XHSFYKSa1YwUkes+eqmcoe/ALa4LUNLugNoHVLqI0rVbBJn0XgZ+dm7TblyQDEaQiNC8zBjAZgD9HaBXV2Byyxf9wpTpdAlNanh/Vdl1rZhelfPEl1e6YUj+msBzpDj2K1wyJ9y8g0xM3M5+ey3aVoq2ftzptKXuo9I6XkKGGB4XGStafZ0/cqCbH1mWb/wJAijIKDjZBos+QmPTgpBKBxvtD+6tDWiPA24WzQxKfxKbTsiRLl269J9ircAlxsgs9F3hav5p89TVwBb9jlLy0/wRQ2hF8N2Mx2Io7khRMqnu4vR8mTX7wErSpy/dRyBatUlWGaSS6rQfOuqR5VzWSqJE3x/cfAAm5kans2GJYJqqtkcLmDZFfSK9N57Fw+dwYlEhZ3hscJc0GqqCp34cytT6zPiHXxK7r+kQzSt94/FzF1HC8gTObHnJ7gMCG3T9LvOXv9sQXuqXFFJr+6z4ZXY2ZbgcT/xLYFS5nj84jFwly1fzwS11Vvx3GKRV38BEPHcYSbhz7HMfECSU4nTPbT4x1qs/UGL1aZmgb4Lmcgs2pvh6S5p9uOHmX90s9YsP1hQwEHflxu3KkpO2FFyRP+/JkM5NQT0Fw7HKzJkGuWjidEAvzLdIAt8m5A1J72Wpo/AE6YwrcZtFCRXfSQITlGbXlYzUYrIJOVgHoS2O8eCS5zOCKDMg93jP7tAETDw9UAMdvyo9cavR9Hc
 K/scPOc8
 aisC/xJQGWdENKZeL1sVJqK2eoyOCAepZ1xErc/6W9+VuKENGUgpL6408NE/7wblqhqNESzJvh7NfHJJdo5t3LScALgGvZiHyQjmgeFtIzqC0OCdPNI+LWBKCiiHAavZewHSg5yRz2Dhx9Ii6Iow9k/kExTUR9q9L/sLs3LVacqm97ohGvwjVR1gEM5eD6sPQH92b8loRXH9OdOnWRArItdW09gUFTJWXP3Tn+2VLE94yFMnxvYDasw1st2OBh1uoxFIcpIu4xZvwXyTXuBB+Aw5W2sPnjRDweYyCMAf0BwI+mj0bbYfD3w8tEMWA6zhihv1MaT8UWrARN4RspyWfGGqeJzadHKC3Brp4kStjvyo8kRIVIH+KnLyILPkO5aYLd3hCB9OPA9Y2gjhZ0TAj1juZrY/qxQ64k34eqm3uaYrCCNAUQKfUFrD9KHSBRQbBWIGYwoevUI/GSQek3o6L/QkFVGEAooQ/ezTn0681fLFuuedMwdj1x1zx/0cCWxmqs6FVSGoMtgAO4ctWoJKwmauP86VK7yCJGlJ5CTGoGGL/HhZA+2+GlQ7I/vAgbhWmMDh7lviupnksJ/Bxa9VxAl9vXr+isSvZKQFloxw0l5YqYGxS72hgWI/E/81HnJ1ob04bKg3zptR1XN0pidTUPvtSQpbTiLnm8DQASHd7rW1Cgr3Fl43ccBVbzH+AYOIQpVd0JhRnDE2M9cC6pwGUsKxv2m/IOtxxjCB2Ozrn8SnOFNIAOUrMNmzlJYPozKLKCBh9vHiBIKR6Yu+qVgK/7DMpJgr+bBdd+aYU6IM+sdwcPeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With CONFIG_VMEMMAP_OPTIMIZATION, compound_head() derives a tail page's
head by masking its address. This requires the head struct page of every
folio to be naturally aligned to the folio's vmemmap size, up to
MAX_FOLIO_VMEMMAP_ALIGN.

On arm64, the vmemmap is offset by memstart_addr, which is only aligned
to ARM64_MEMSTART_ALIGN: as little as 512M with 64K pages, where 16G
CONT_PMD hugetlb folios exist. VMEMMAP_START itself is sufficiently
aligned for all supported page sizes and VA sizes.

Raise ARM64_MEMSTART_ALIGN to cover MAX_FOLIO_VMEMMAP_ALIGN, and assert
at build time that VMEMMAP_START is suitably aligned. This is a no-op
until arm64 enables HVO, which selects CONFIG_VMEMMAP_OPTIMIZATION.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/mm/init.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 4e7682dfe366..7186d86afc41 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -35,6 +35,7 @@
 #include <linux/kmemleak.h>
 #include <linux/execmem.h>
 #include <linux/arm-rsi-cmds.h>
+#include <linux/vmemmap-optimization.h>
 
 
 #include <asm/boot.h>
@@ -92,11 +93,22 @@ phys_addr_t __ro_after_init arm64_dma_phys_limit;
  * in the virtual address space.
  */
 #if ARM64_MEMSTART_SHIFT < SECTION_SIZE_BITS
-#define ARM64_MEMSTART_ALIGN	(1UL << SECTION_SIZE_BITS)
+#define ARM64_MEMSTART_BASE_ALIGN	(1UL << SECTION_SIZE_BITS)
 #else
-#define ARM64_MEMSTART_ALIGN	(1UL << ARM64_MEMSTART_SHIFT)
+#define ARM64_MEMSTART_BASE_ALIGN	(1UL << ARM64_MEMSTART_SHIFT)
 #endif
 
+/*
+ * With CONFIG_VMEMMAP_OPTIMIZATION, compound_head() masks the address of a
+ * tail page to find its head, so the head struct page of every folio must be
+ * naturally aligned to the folio's vmemmap size. The vmemmap is offset by
+ * memstart_addr, so memstart_addr must be aligned to the largest folio size.
+ */
+#define ARM64_VMEMMAP_OPT_ALIGN						\
+	PFN_PHYS(MAX_FOLIO_VMEMMAP_ALIGN / sizeof(struct page))
+#define ARM64_MEMSTART_ALIGN						\
+	max_t(phys_addr_t, ARM64_MEMSTART_BASE_ALIGN, ARM64_VMEMMAP_OPT_ALIGN)
+
 static void __init arch_reserve_crashkernel(void)
 {
 	unsigned long long crash_base, crash_size, cma_size = 0;
@@ -218,6 +230,8 @@ void __init arm64_memblock_init(void)
 	/*
 	 * Select a suitable value for the base of physical memory.
 	 */
+	BUILD_BUG_ON(MAX_FOLIO_VMEMMAP_ALIGN &&
+		     !IS_ALIGNED(VMEMMAP_START, MAX_FOLIO_VMEMMAP_ALIGN));
 	memstart_addr = round_down(memblock_start_of_DRAM(),
 				   ARM64_MEMSTART_ALIGN);
 
-- 
2.56.1.809.ga0b61035b5-goog


