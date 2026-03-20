Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E582C1099B43
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0CE6B00F4; Fri, 20 Mar 2026 18:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8BA6B00F5; Fri, 20 Mar 2026 18:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506406B00F6; Fri, 20 Mar 2026 18:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40D9D6B00F4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14EE11D9B9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:41 +0000 (UTC)
X-FDA: 84567846762.22.C8A3AA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73ED78000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TslszDhS;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/1ctJgZFjwJnEt9D488YF1w3aSO7eSWrdVytrypd5Q=;
	b=Jmm5OQjTEsZiZxgLEy0KtiQTJy889lms+W/kwQl5kMGgsjqit7R4skWdhpJTEiQ4+3uSsN
	rOPJh0UsBpB8WDg6DZ4LxTdGHJh/Gu4A11iMFIEYRtoTnpI1Ro77nRv2GSaPmxGiEpeSjG
	3AsRLP/27jA9/h7sYGkYdyt5/kVbAwI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TslszDhS;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044879; a=rsa-sha256;
	cv=none;
	b=2YVYEM++CBJX4l1kUkPcj5HrrlFpv/0COGxv/4+fX2N99EzEPnAiGO8Sq6Km96qfs+IMPw
	3qd/TcqOJ/yRZTCTRanJJNAj5r0agHwBu5FLi4lUjLlUG6T5aUurXVcPUsCvDRkINUvUxe
	MpNRMw/B77Uw5glFw7hPiYBhSK1xdHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1CE46111B;
	Fri, 20 Mar 2026 22:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B066CC4CEF7;
	Fri, 20 Mar 2026 22:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044878;
	bh=y3sgZkTrQ7ucF18Vg7qRa+O7aPCnDHgstTSd5M9UBOY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TslszDhSAzMDVRIyuMv6paGVgSsd2CzTi2m+XDZauLL+oMPD8nN2y19WOg5QAxcN8
	 MJkxnPJI13xWM/TQBuUVFa8i2WBfcrPqP1pN4JyiIYxzvSpK68kow0YUXzxMwjLIvA
	 PZfMcLRp38aeBp/XZ/scY6XOVW8u6R2Vl2bxg7ZCjPYl5+Zw1cWeOJK9ueZjsjOuBI
	 /f+WZSPbGmI8Ms+0wdaf/gI3Ef6Dwbp58ZS76mf9o54sv2J4dxehoWLmTRoayHRyve
	 UXsBVGWUjpn8Bff33KBzLTvQ6RK33x76NgUJDEqM9svExTt2X8h0wOTNQ+4FrOCJLF
	 6X7zc7Xpdr5tg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:45 +0100
Subject: [PATCH v2 13/15] mm/sparse: move sparse_init_one_section() to
 internal.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-13-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: kbuxyhdidwpoq9scdzoyyy9pq779zk1m
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 73ED78000F
X-HE-Tag: 1774044879-446762
X-HE-Meta: U2FsdGVkX18s9IlKCpgy540hznynFOdk0VLVrGbt27pBh/S/98rzbfo3mcagWas3MvOpvqHZ91rYER6d2UC7g4RwAkPNjgo84lnbHPGwPXuUnQyEViGoMlJiSI4QGTWuFijeUyt+n1ojdr5nF3LcUOhdrXL/jLUMrKD1rwA6ktPJcpslyMbuWXrBMUrcgFHMp2pBFXTjyQ7qRFu1cBQfIqv53wH3eXZ9Mo0f2/umyj7nk3nSBwi2USsC3OI1fzrSPku3D4kMb9SjWjAeiYseIrlg+IEhgXe7e4FVJUfk0eoov13F1c+KFks6G9cynQ70r6HCfE0TRS/R1VomFcmgYTylB5Tm5TRTbUxiZaVUjOUSVcvHYTp9bamEj/OjzZgv2i4kySqnzYvAT8VLmn/FaMtCKc5Qkk23sIlgwZT4jBB0oDy1cPR013ySBmBak7Ozo5G0gk1gV2VjPsM5PBMrTqns85N5zIUbcRbaWU6zJBIS8ZLWAKTwY4z62lQcaVI34yHMv1/A05+w347Mlm/0LosPeFSUbcUbeUqm3WCXPQ5OlxxAV6d7G0ig/fcI7CIAr4aggNcV4Lrz7UwCeE2/Ng2541vBiBI1MQuQSKsegZZAlp5pHYh8uQ2TU2KMCA88IxVgFDWoDnOax7amaQcUubCQ0h4oP5RvaqNefHTHDn19lGfYw0kh/kMARgdh3eWShIxZlY8sM22mjNAetXjrkRWGtlQYGhtw93vih6pPXQIuW/1b0Vv4SJWasoJ5oQHgZZu5eFoxp1jr0CM1jIxWAH+BY92JRUpkRehhvGEZnmW4M3uwo0zLfawMbcDwrXiymyPFu1YcCYYfk2O8GGANESfH1CJkprOySO8FnFIxY5P59Cb6Lo+VLeMm4Ri5mk5k4wpKWQJ0NAlpwT/q/jedp+KQadzpwubYDef6gYb0E+dBzg/wjAkAA5MS1SRW/xGcZf9GDjBqkmhE/CP7Abf
 9nZJvXEW
 ZEiw0wPAKC531r6HZtY3i5Rgvt25//mYsi8M4+Iv1zY1TxsPRFJIXagd57fLlb2C3ZZgRAKp/UuggoKjE2KrlGPfWfAoP+keXLcAAsWkbLzdgj/p0Fzcicc+IWsjH5jwojAy08MD3LJvlfwokrM+llSCADuiQaroVzivg1w5NRUTXlVmcB8QrhNoufwdAdDXQAEPrIbHXKaA29rDVz1nKunvQxpNu3v5g/RUDS9PlaLEzg4u3Aeh+1i6oLMq+qKu4IFaL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While at it, convert the BUG_ON to a VM_WARN_ON_ONCE, avoid long lines, and
merge sparse_encode_mem_map() into its only caller
sparse_init_one_section().

Clarify the comment a bit, pointing at page_to_pfn().

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmzone.h |  2 +-
 mm/internal.h          | 22 ++++++++++++++++++++++
 mm/sparse.c            | 24 ------------------------
 3 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b694c69dee04..dcbbf36ed88c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2008,7 +2008,7 @@ struct mem_section {
 	/*
 	 * This is, logically, a pointer to an array of struct
 	 * pages.  However, it is stored with some other magic.
-	 * (see sparse.c::sparse_init_one_section())
+	 * (see sparse_init_one_section())
 	 *
 	 * Additionally during early boot we encode node id of
 	 * the location of the section here to guide allocation.
diff --git a/mm/internal.h b/mm/internal.h
index 5f5c45d80aca..2f188f7702f7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -965,6 +965,28 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+
+static inline void sparse_init_one_section(struct mem_section *ms,
+		unsigned long pnum, struct page *mem_map,
+		struct mem_section_usage *usage, unsigned long flags)
+{
+	unsigned long coded_mem_map;
+
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+
+	/*
+	 * We encode the start PFN of the section into the mem_map such that
+	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
+	 * from the page pointer to obtain the PFN.
+	 */
+	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	VM_WARN_ON(coded_mem_map & ~SECTION_MAP_MASK);
+
+	ms->section_mem_map &= ~SECTION_MAP_MASK;
+	ms->section_mem_map |= coded_mem_map;
+	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
+	ms->usage = usage;
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
diff --git a/mm/sparse.c b/mm/sparse.c
index 5c9cad390282..ed5de1a25f04 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -256,30 +256,6 @@ static void __init memblocks_present(void)
 		memory_present(nid, start, end);
 }
 
-/*
- * Subtle, we encode the real pfn into the mem_map such that
- * the identity pfn - section_mem_map will return the actual
- * physical page frame number.
- */
-static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long pnum)
-{
-	unsigned long coded_mem_map =
-		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
-	BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
-	return coded_mem_map;
-}
-
-static void __meminit sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
-		struct mem_section_usage *usage, unsigned long flags)
-{
-	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum)
-		| SECTION_HAS_MEM_MAP | flags;
-	ms->usage = usage;
-}
-
 static unsigned long usemap_size(void)
 {
 	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned long);

-- 
2.43.0


