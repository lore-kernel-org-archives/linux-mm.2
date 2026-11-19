Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2937B60A260E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIo1i7Do
Received: by kanga.kvack.org (Postfix)
	id 4A4116B05C4; Thu, 19 Nov 2026 06:19:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4820F6B0612; Thu, 19 Nov 2026 06:19:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9406B0600; Thu, 19 Nov 2026 06:19:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1811A6B0612
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:19:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABDB7A0A8E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:19:14 +0000 (UTC)
X-FDA: 85451622228.09.C484549
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E904340006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:19:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIo1i7Do;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795087153;
	b=GjPBFDJJV76tUy7eZVjuagYZ2hZqY68P8ST2HXc4N6Aez0GzLrgk1aXk1OF+eOsvcY0Q2b
	J+auEHV5vhJVlbXXUX9GT8iU+ADbvhQDLK+1FYHvPSMeOEy5s2IcbaD7/pWnpCSGki/5Un
	23damBvsHIw25Blt9pb5+e0D2p7+tQU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795087153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QXCxhCIleutXBUxzuaglIQL7kD3eVOH4wn3LnKcIbkw=;
	b=hlkp5JGzlYFsNk2rdaLohNpyLAkysgjxP+UcNu69NvfnJb3ZL6rYSRRIN1gH2N+fX1v7dC
	zE9m+JBi0dCpaBbkQVDlSGVhILPx0a4lrMj9QgwcJ0nS4Eq/x/haJ4HiDW4sbpc12IN8OQ
	ZYmexBzR9iNYUHP2cfSp0g4cT36NHyw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIo1i7Do;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A0F84119E;
	Thu, 19 Nov 2026 11:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016E31F000C4;
	Thu, 19 Nov 2026 11:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795087152;
	bh=QXCxhCIleutXBUxzuaglIQL7kD3eVOH4wn3LnKcIbkw=;
	h=From:Date:Subject:To:Cc;
	b=eIo1i7Do1xvfth7udZfgi5PNF/F0gXToNXLydb8EZqiuUieD5ZLR78jQgm7G3Vm4R
	 XGvZ4RWtCNA4BZvFLNo1pDS78EggAbg/tU/pjk9YR1ddX62in5utB1Db/FpuP6jl/f
	 YYdKCCuSY/jDBSIjNkMmUN/SFvVNTMpSQ43+4FH+w1pvxeCw5FqslTLNbZsfhTOY94
	 GGirhlNA2wZW5Z/WvZ9P/0Te3s2oyewF8zdI/Tg6xjL5PC9FpLgdESe5ofunXQcGCC
	 +PFNQmiLVum29mqxFo3+h4yYWkmekn8sdNWKMCIOXkCxd6Bvr148s8f72/xGYhcGXh
	 bSpYIGFum1Q8g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 19 Nov 2026 12:19:06 +0100
Subject: [PATCH] mm/mm_init: don't subtract managed CMA pages twice
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMTQrCMBAG0KsM37oBJ7b+5CoiMk3HOkJjSWwRS
 u8u1uXbvAVFs2lBoAVZZyv2SgjEFSE+JPXqrEMg+J0/MPPZxUFugyTptXO+qVn0dNyzKCrCmPV
 un227XP8uU/vU+P4VWNcv2+wFvG8AAAA=
X-Change-ID: 20261119-cma_managed-2541ae8731ae
To: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2012; i=david@kernel.org;
 h=from:subject:message-id; bh=6Ma9f4cQInBSteSr/WNtmNWvwrG6rrVXvnRyZnjUzyc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+3dadeEyfO2bbM57gWsfwh75Tjj2WdHWsZN50gD36Q
 PdXpzeGHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEyk4iTDP8tUq8jtby5VFy+I
 f3DFvF+UX/LmhQmV0rrFumXblheu6GNkmNk8yeOS4IebLHW5XxTeFidLLH5Uuf9W5z89rSSz15y
 SfAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: wrm556999pushynbhk95gbdzk96zoea6
X-Rspamd-Queue-Id: E904340006
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795087152-335340
X-HE-Meta: U2FsdGVkX18rUNLzYoT0EMsOMwKBzlix7QGYSsW2/3qpwCS+z+mzo+YLXt728xN1AYxuCtjyIPxF+7C8dSLg1uRuOKOwpCZo7q18e42/pqfxSpyzTXDr5WmpgjmKkLIqHvEI27Rhc/fBYh0WfsOcgGJcQqPZg2OP78uPY+PTciECna0zQ18r1zB8JEvbMrbg1J40jXWjeGY0xjvMTrFKwsHbv3Gbmku5IlSzpr1iSDudAgd+msCqLHAWn2Gi+HoHtOoMxzMqwjevSFX7XqbrnzHhf7J79wV5EW95mNJjh0qam1Z3ex1Otg1w81Ycl6p5whAJJFg3DaarVqqw98LT8/nBAx1ZWheJ1oyEs1Ce4eKVyacxDNfRpXqcsYj1J8oHGMRCGMETc5R1Q9dz6M11iYnITdAHRatI6QDtroVs7ehXEdDw66Jdr5MrwT2TMiz7RTD3Zt1NXAp/2K1E9+WNkb4c+uNfan8f9/QSZNQ17Bv9z4DLDP01wOAP9LEmeAlxzAPJAU1jPhAPjBPCDX4S8IVtz+/vx/lQfyM8SARccf8Jwh5f+c/1iJTnCr9sPc6SJL4CHGnktae72vHtJ7GtI1vw7mJSSUOzGECmhHPhVnlwLOgDkWdXErCDcuqq0zDwDEygBBmCBDAKEDY1aQyJ0JYnQvGGm5i8J8y0uT4VVyESUXXDpFNqP+s1LhcR9HUW6pIaadVuchmIn7ZPL+Wh/ALWYfnxZCUpLmXzDoizsv5IL6IurdoOx3c/h3kFnOGDs5n2yHRqkfiHNYEeWFvdQI4KfUUvOU1Fa0iuDL78vw3GVkzFyFdasgGXKNn4QewlsPwOj780sHtNBeLQT/0PxvcC3jGhORYxscH3zUmj1gvLys0XkVFq00WjKC17Pc88omJLpdNCXZpfyxlk98j6reDw62bQ/ULbIyPQnGUZC1QKmtNfMockdtVbvPh9wq78Af2FZGA2KHhHAVI0Hze
 z4YJETU3
 F0kZtaE7Lzs9ajCnHEUekVI0vqf6/Opa/jgliIY+SdnDfHNKRjQDfFUzdCksfpGgxtWfhrouqmmwEESBFIer62gDhQBbTBR+Sgyk4i89XAt4xnUNyfRqsRZ+IT89dbkKR/P5PBIWBJxI8TCd6IJZMkvTya0QijGzx9OxGfBLeM3PNag+iWIYkA/bcdqqpxtsyizG1NMSQ3U6WYFNmiO0UC8c12ffF3fdAA/BzdM0hcUc+6oTmIb9ECTVhRjryP/SsQbQ43p4cznASzCuIW9AkZ6e3wyKDRMMC6jZzlEMOUsayWsrjXU9W2Q7Vgyo4YR6EzUAmUCWTdCA8IYKEJhrFq1/MOAo5v8NfmzXMQQx7WWK9JCvrDadINH43+LqI7iXxiMz8QFTxEtQTp814SO0JyJ90QfwkLtv6cyoOi626R6x3HLenfBm3zelp3HovbqX5CJUS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

With hugetlb_cma_only, the "reserved" value in the "Memory:" boot message
can be wrong (small or underflowed).

When mem_init_print_info() calculates the reserved memory, it assumes that
no CMA pages are managed yet. However, some CMA pages from hugetlb might
already be managed at that point, so we end up subtracting them twice.

Fix it by only subtracting CMA pages that are not managed yet.

This has very low urgency, as it only affects a boot message.

Fixes: b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier")
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: improve description and comment ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
This should go through the memblock tree.
---
 mm/mm_init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 27a50ecd5c20e..26033afa9bc05 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2608,6 +2608,12 @@ static void __init mem_init_print_info(void)
 {
 	unsigned long physpages, codesize, datasize, rosize, bss_size;
 	unsigned long init_code_size, init_data_size;
+	unsigned long unmanaged_cma = totalcma_pages;
+	struct zone *zone;
+
+	/* Some CMA pages might already be managed. */
+	for_each_populated_zone(zone)
+		unmanaged_cma -= zone_cma_pages(zone);
 
 	physpages = get_num_physpages();
 	codesize = _etext - _stext;
@@ -2647,7 +2653,7 @@ static void __init mem_init_print_info(void)
 		K(nr_free_pages()), K(physpages),
 		codesize / SZ_1K, datasize / SZ_1K, rosize / SZ_1K,
 		(init_data_size + init_code_size) / SZ_1K, bss_size / SZ_1K,
-		K(physpages - totalram_pages() - totalcma_pages),
+		K(physpages - totalram_pages() - unmanaged_cma),
 		K(totalcma_pages)
 #ifdef	CONFIG_HIGHMEM
 		, K(totalhigh_pages())

---
base-commit: d9a27fa1050902a6e38bdb780b0277cbf1dfa5a5
change-id: 20261119-cma_managed-2541ae8731ae

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


