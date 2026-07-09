Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD46C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224CA6B0095; Thu,  9 Jul 2026 13:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC406B0099; Thu,  9 Jul 2026 13:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139716B009B; Thu,  9 Jul 2026 13:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A99436B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 089B41A0250
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:45 +0000 (UTC)
X-FDA: 84969948210.20.F0365E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F52118000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1Y97Jra;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdR3sfWoKe3cnBBg7L3z1+zE6eZi3SJfP8R+a0w376E=;
	b=BsyeTnGZbk5Gzir+vY0xeAeqxK0teyBmErcfeZuNLn1kvgQ2sGeXd9B8SEBFKHIqYw8rTk
	Mj6SqxmACrzW7Jo+5u9ihnzM3Fk1ucsSoX3o5VMf5Z1n9VT/GNyQSZtXqHg/ez4oE4Xbqi
	lt8L0OE6nnJPC3uOrYDsbaC8UZjtY/o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1Y97Jra;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618723;
	b=v6U1f9vSCfZ9raXXUgfE8/RPdcp9v8a30qFai5Q9+hR0RhaAFwM12EqdBbB8jTCPxWNHnh
	Urns6Cx0Jl6pUsnXSFyLe9d4T++7M5/mcWue6QawCI6xQkFfjwc1VoLNwX+3vonfncmM6+
	Oi6p7RMdIUqRnM91TLNfu57LmPwx3Qs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B181440125;
	Thu,  9 Jul 2026 17:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE331F000E9;
	Thu,  9 Jul 2026 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618722;
	bh=OdR3sfWoKe3cnBBg7L3z1+zE6eZi3SJfP8R+a0w376E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1Y97Jrahs8hijJTCASPXnmlJiKUoiDP6LV1Xv047Hm9DwwiT5rhMHZw0xgMpmbWd
	 mc6R2mkHp2mqY5XK9SyoSLjISgCDlUbfLhJ2k8iTlKS1m8nsEv77Hf3fJU+gfqgMwM
	 lL4cXCNbMtg2TkjNaDaDPC/a+3qyDQbJezObq5pMXAyLkFV9UINwK/LYFJhLGuqlnv
	 39TqSrDFUVgeXfi2jmdkwqAx0VT1CysRe2z2Z/R+fLi1yPSYxE4EviTMvTsjxLppfX
	 9nhzYy85aBfE1OWke3RQvFWic4FUU47hgiYJ6w6zFjG+Q7bmAFWxI4KOajnLYvIoUJ
	 4y7mZVXIIHhHw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/21] kho: return virtual address of mem_map
Date: Thu,  9 Jul 2026 19:37:53 +0200
Message-ID: <20260709173821.429921-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F52118000A
X-Stat-Signature: kfeztddu4dshnu37j1zacskwzmhojbng
X-Rspam-User: 
X-HE-Tag: 1783618723-403905
X-HE-Meta: U2FsdGVkX1+cXM6riXalW5uG81Lv0x4tCV9UL94DMrPNoYW9Ekm4LMu8mvhB4lvOT9Q4X4X/AnV2QRFNVqwVTNcYgSHTwHa0KWOk68ZS2MlErnkPLnsQl0SFKxXa2sxlOic+s+337Ae+7yO0BIHpR6Uqb4mCBgBlYez7EycLP8CLrbCTCPB/TvROGgT4qzY1MUz/Evb5kqvzpwVKHQjfSQ/BudryK2IYwpdWgqonC5NERKRgZBbr9+tpeV7LOcv7TqGjQ8c2Tt3RrZDjeC0y9EEfz/1ezfpB+YHodw/mWzW+h5tmN3nT5zsL12hh1hT8KsmJIWtgDtjEcZ3nQLNDkEgb6JqH2e0vN7zPCbePNZlFIxDolVg4EzLuhYEMjIfU+pqBexQt8597fl+IFAaFsoJU4r1dhmG3zqmfglfmbSpOYqNcWAJ7DfBKLuwwq11JGBZQ/Ole468C5CFxwVASPrjnJezTL1OB2Sw4XhktEwZpmH+LV/XCslncSsT5afDWdhxfp/ghHb7VKgOOIJMCbQ6ynR8tovueXP1XN6ZQa7HmVX1tgY00bW5cNLwKeqwf7tn7COJMR9dh5MKdmiada6YuTrg9E+wmu5xx8v183yW89knQbKRbmGcns49OE0sYeq2C1MLB7Jnpt2aCW4fOEhjfFFJ6iDpjPevaPAAK0agQaPWL3zIoNDsLcUV9quy9u4O/ACT2TF2EAR+nGUW1Zm5Xayuk9V9pOhm4IHiE5VpHQU77L26PnzN8W/hdE1siRLm1JvSvFNf2Mn6V7n/y/ldXQpvlGAvwG7uMHpchVahGXHKeuKHzGlwfYu6Lm1QICP7tpQ4Equ+STLH3X2yQd4y9PnvlEARMuzPr16QjGgFF/Qsaol9GketeK7gb5r+EUNalasdFGbwMMsY049BowrXw4Dky2ksioiB4pLRnlueccTmjogD6t83uVBEo8uB2mz/eTEkLyko1u8P+O8E
 AjaTpMEE
 3lpnGsWyUS6C1i9ztLTNQsbcEirVSnolRhqatEG400HwjlBMu35HwilYrJn+WY0YH/E+r+KgnBV35/qoMJuYRSt2bJnpDFLQmw1nYZg77aQmGpqhKrd4bBj4HLOKiFbyqOTBw3vX/s9frfKj99OXWLPmYFWTNba/G+IeVcGo4ZsGknDvFb1B9+7mLJS0gMTPdW6uXskiKdo8qYdo3fujZU8R1W/Wo0DEg60cEXEeHG0U1CRVv5Qo3S1rV9ub4w6H4Bc/f2rdUPtpXbAu6KUYMnCKPyGSTwAGflrqk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently it is only used by kho_populate(), which doesn't care whether
the address is virtual or physical and only cares that it exists and is
valid. In coming patches, more callers will be added, all of which will
need the virtual address.

Make things simpler by directly returning the virtual address. Rename
kho_get_mem_map_phys() to kho_get_mem_map() to accurately reflect what
it returns.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e7451743b87e..5c35c11c273b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -512,19 +512,24 @@ static int __init kho_preserved_memory_reserve(unsigned long key)
 	return 0;
 }
 
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
+/* Returns virtual address of the preserved memory map from FDT */
+static __init void *kho_get_mem_map(const void *fdt)
 {
 	const void *mem_ptr;
+	phys_addr_t mem_map_phys;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory map\n");
-		return 0;
+		return NULL;
 	}
 
-	return get_unaligned((const u64 *)mem_ptr);
+	mem_map_phys = get_unaligned((const u64 *)mem_ptr);
+	if (!mem_map_phys)
+		return NULL;
+
+	return phys_to_virt(mem_map_phys);
 }
 
 /*
@@ -1647,9 +1652,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 {
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
-	void *fdt = NULL;
 	bool populated = false;
+	void *fdt = NULL;
 	int err;
 
 	/* Validate the input FDT */
@@ -1671,8 +1675,13 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto unmap_fdt;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys)
+	/*
+	 * At this point phys_to_virt() doesn't work properly and so
+	 * kho_get_mem_map() can return a pre-KASLR virtual address. But here we
+	 * only want to make sure the mem_map is valid so the actual value
+	 * doesn't matter as long as it isn't NULL.
+	 */
+	if (!kho_get_mem_map(fdt))
 		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
-- 
2.55.0.141.g00534a21ce-goog


