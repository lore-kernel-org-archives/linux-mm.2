Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D46FED9E8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09266B00A8; Tue, 17 Mar 2026 12:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9326B00AA; Tue, 17 Mar 2026 12:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE736B00AB; Tue, 17 Mar 2026 12:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5DD16B00A8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 790858ABDD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:53 +0000 (UTC)
X-FDA: 84556162026.28.C4A0A39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D7FD64000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qFaMp8J3;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VP+vo4hnI+8PiEumHkHWlyXnnkOt6OzU1YRiVkUo2os=;
	b=PUMNlwI0iyT2UeJCBvGOTg3Avsu4kQUfU1mH9mO5uIEDVJD4aYsVLj2EjNKDa5c8Njg1ce
	G2u3c+WZVA1qdAJt9Fp+Cmb7bUZm5ix72AW7Vhk0TNlED5uasL7Ybee9oGWuGvKJHZ/xJA
	dmKWQPgOd0nnJ+URbNLo+XLHkwilUUc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qFaMp8J3;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766671; a=rsa-sha256;
	cv=none;
	b=a7O5iOAs7ho2jlhA9pw95t3XrWEcvIvYK3RIknPP2tCQ8h20tBQYvO1ZMEYR5pdEa8A7A1
	vEbadfHR8cHM2mG4XhNzel7pFk4igq0D+ucmQPBiaC7W6p9ZBDyFnWB+5OTpWEjQn6P+x6
	FoqdGlwHaAdL5SVh9BiADL4Ku1JEO3U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52DEC6013C;
	Tue, 17 Mar 2026 16:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7784CC2BCB3;
	Tue, 17 Mar 2026 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766671;
	bh=Bip5aS2Q/tCY3dJyBk4Fs5dKG63YEPL2XgTfzOnLk/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFaMp8J3h6JOzr7rbOeTOYOK/GYkvLK8VsApl75PUwJtmsISNYD4yXcM1jTlZtOyS
	 6QUsA6N4pt6A0vyltmwEuqpd0PVsjYB8DN+FfJE/RI1AEOUn746O2LL48LlOxm2jHi
	 LkEqSb2ywOlAiDfBzi9Px/MxwS6Lk8ofbJkl0CibC48PbNuFIeBjGnbDBjhxhYFJdL
	 dS7+rCrenGPGw1k1gzHlX9qyAutHDQfjbciY3bY9j8Yt/9XqHc456BsUvXjs7NUvSU
	 3Kke/jH0KX9ggRX+MNKpMGzCEbVEp/Us+6guRKZrJIs5QIkEXp+3oD39j8g5uPrQHn
	 L96mGSXBg5mBA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 12/14] mm/sparse: move sparse_init_one_section() to internal.h
Date: Tue, 17 Mar 2026 17:56:50 +0100
Message-ID: <20260317165652.99114-13-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D7FD64000E
X-Stat-Signature: wwjsef4hfc8oir8e1jcju1sxdirconei
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773766671-728485
X-HE-Meta: U2FsdGVkX1/eT8TcTkw+weOr973BbPg1x7gwUJYs9kgdcAx553jdysyRrWAl2U71pzEW8Q/buCabJBGBQ+f8WqbvmbbBddchh6HElqUF04M3KZxGF7p+qK3fmHXhR9tW05dpGr4dWoIS/n+FD41SnwBa4d3B224lUwZ+Ob7aKzAKrA/sG9lGO5owljJfegiJXY9Xcq7IIQKhzjxFuudrBBDHOWCrtNA8aQU6Ac8uZLiN9vgnJ+5mf9CY4pxnNM3kobR0ln6inApjPR4uJZe2Q0wUX/BjA5VGTsXZBbvwSksmPb5c6MBKH7/AXXwe3DWQbxqzQWN9YBo4PlUi6di/AV0LYEzhEBo+3PqLQANnvGH3e7e7d9hGIYJXEmIQx9HIKkOIJSciaWxc4XZSZLoxJZ9BffS4eR0OSxX1LyC0EYrxUBiN3rdqq3GLvUGiAs8jEL9sOxQfIwHsgDXFx4vUlc/iktEKt0D0qOC3KQ2UgtchVQeUa1Q0/b3qHb5Fo0Suf/XTRasf5IrqraKnSGIpjGTqChPDA5wHeM5d2Fr8msorC9efTKS3ajxoGCR05Pb2Pm87CPmFGOBBPKhvYxyPtmae+UIufupbXHPunEbjihUK/ibH4I6yBmC3ajOl5IrBzmfhfokbmp26uLf/JFcul0PS1LxAvZBLT+DskniZzqwMIgxbjETXOijAYWVaLfUAp1VyW/unZmaERbLOjHOLu/bFDuAyAmaUPLccr+nu5j+JGZo8jmY/BXYQewQYD0yIOxr7Dyl8Qh9DFi5RU3rgKrnBec952MIfMaWMBa7l+wGQUjyFXtNQ94K0Zx1KN24xr6R3GoWbgfBSL2yBGPu5IxHGPGpdLFv6ECD3ycrvqKVATGEtLBSGc2xoEM3tnJ7b4O2jyGwCXOJg5NOn2E3qgugm6+IP5FYm/XCgflDTHE53K80i6PpR5vb5HfAweX/T6LRjv5JUrodvpi+YXMp
 DuR8zP8X
 vjmMynrFwRmawOis5sNkDvuw8uxSk4dozaO/Uh6SEm5CdOJViScxsFNIPrhDvAIxQcJdngYW2CdNF71R6ruskx0m7sDJhNjANG5tFx6U7/A45aqzQ4lCGRgyfYhGfGXZhieQb2b5dyn2XjI8Ps4ukxuVFmbFNqVwNGxgMGFw/cXzH84z8k6K4m5WwgqpBlm0U6Ia4AN36AfHxZ0DL31BV/Dqpvb119e54zbI6SOkbn/eAvRt2FyzfyjFe+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While at it, convert the BUG_ON to a WARN_ON, avoid long lines, and merge
sparse_encode_mem_map() into sparse_init_one_section().

Clarify the comment a bit, pointing at page_to_pfn().

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
index 5f5c45d80aca..bcf4df97b185 100644
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
+	ms->section_mem_map |= SECTION_HAS_MEM_MAP | flags;
+	ms->usage = usage;
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
diff --git a/mm/sparse.c b/mm/sparse.c
index b5a2de43ac40..6f5f340301a3 100644
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


