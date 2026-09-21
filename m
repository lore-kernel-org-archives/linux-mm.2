Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4E7C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876A76B00A9; Mon, 21 Sep 2026 16:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF626B00AA; Mon, 21 Sep 2026 16:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEF16B00AB; Mon, 21 Sep 2026 16:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 454CE6B00A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:00:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42577A02B0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:35 +0000 (UTC)
X-FDA: 85238836830.30.9EEE542
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 880804000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiceSYwR;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020833;
	b=bHJPKF6nBL3YylSvfKsFSHG4OXForj2tsIionhKRJncLApKGGCzQb9ycflKycFZbKy/dGE
	iOXQPaSSgJhxNWpakJTUkwfq4AJ/+5tFT+ciAgFwyOnAibpzmtVRn1gUdUhBC0GDAbl1rM
	t6PmK6XrIqxeDHNvun4mpcWK5r6ye9Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiceSYwR;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBc8LKQV5IFSgEgJspkfgYC6oU0VoqbkBUUOKxrLma4=;
	b=uV7PYJ4dOQ/8QdFc37Vtu/HkIg4PlYpMR3ZBZcbvukdfcwFC3LMUCcg/kHnFX9g/QGdElJ
	NQicnGtmhS+Z63foga8uTcuD9F3UF72Z7oDBWtXppWnOOgzMv9rluCI1Fl2vhgqr2aYbxz
	A4IOfyowt4obn7kOE2BbXPCPg9R3fV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03CBE60008;
	Mon, 21 Sep 2026 20:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DC41F00898;
	Mon, 21 Sep 2026 20:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020832;
	bh=yBc8LKQV5IFSgEgJspkfgYC6oU0VoqbkBUUOKxrLma4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CiceSYwR28kIPNtzcNquf4Sh/wpB3CCKPRYksMJN0pwKLDxPCWxVukiYM4DxQ1uTQ
	 SEyzoPrbJ5ELSiIrtANuNkJV7S8MtyUoCOp7LEpkk0/CeCf0gAfnzuyNRun28aUl2j
	 S6CCU8Quz/caod0JWfTGcdm3JUBY16Pb6xp4qcZU7zUdDsZa9t4mvzMswZ9fekHhR6
	 /3NCDf1sJ1RTAEEAmjXdgnYnkuYzs1MMFkx2WTFgquIsiNO9qpO8nQKx/JvJkFbVyv
	 qGiLYaZ0JvQTPplNs8Ap8BLhHKMLPDtU4sieD9ykGvDQxG3G/uyKwav/Z9fRcRZitD
	 PnfcGMkZvExJA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:59:00 +0200
Subject: [PATCH v2 08/13] mm/sparse: move __highest_used_section_nr
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-8-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2996; i=david@kernel.org;
 h=from:subject:message-id; bh=MAPvsLwqeTEpF0LPG4Zd4p1dImR5G5txQSW8jy2p0x0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rSFGC3dkXbvkGKa5dnAUxud6j/kdO5f0lJlNf33V
 6bTWfXyHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkxxtGhhXfSo9k71N907zI
 a1FqCS+DwBsOMZGuHsngK3bK9fNO+jD8d095IxFZ8c9UN1HWXURgtuC0Cw/57nJPsVL9b9j8awk
 XNwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 880804000E
X-Rspam-User: 
X-Stat-Signature: gxu1ixeixa8hrc49tp1xis9hgk5bf4hw
X-HE-Tag: 1790020833-833243
X-HE-Meta: U2FsdGVkX18Uk8e2FpYKiUvdLofYiKyl2oDXyJsNBPpUKGAyFUOpmAH0P7tMix2hEJg2QpyuZYOge5r1kgQSfk8KNHAAGus2OaEkUKAxSsrmZcu+kdDIP+GbF9ALXvBmTTgAKIOg9ps308z1/ruZQq2MU1bMP9TWzpmOXS9FTTMHsg/I7LejFa54xKabdmOI12jKtF5ffFLNgzyk5Rgru2wpn7Dz/+P5n0Q6VpC3ZzHsCA3wqMLfouHxUWYLUAJIyr5cIKbsyPvH67DxufvCS/o7bCSQSIUnmRGJ+sUo/rHHq84YgXxKx1l2VYu2sXoHhHYFaNakk8aVzjevowtDnArI25Dk9vfB/YbQVPGfq1Z88Y7FUWxnza+oSuswyogyCGf5DHdk50K087KlKXjCr5AkkKKad8e9j1/n8GlxX4M2kE+XLALeNiW4UIxF/wUMwBDmN5dYtkfFRMnn9myTY2Lbvkpjs3b5WpNHBfM+KKo8CszC7+vHUzIfJI1qemLXEq2fZ5i6KrT3kJS93g78+bVZmWejuSVii4GQbUkO4Q5Y9HlcC4mWcLMaOmo6txZiwG4brbdjInJdBESEpkk3c2m5ucfTgg8tUrUEP2xY76Gv44zY4zSuyBH5e+E85gxY+9VnL7MKeHuD6fnE7SY7ef2E+MvJHcxY3HdMxcACsWIJXO5KN9anLRq0rC/7nRgQcEjXlL8PuxRrjlqG7H6p7iDOaKFj0FpPuwCxCqzrrkqquZxWyeNOWXM6WWC9lmUz3KuKO/egGPmjMhQoNM9CZrIHU1pYk/gIZ5cJ4dWLm9AVCWn4t2PGygwpMLq7xXZ89fG9lUcppqAXcJ4sKDPoXjyicHWOt1yOtYXrEjuJR2CwYDDQm3PsyuToRoGentKVK84GqOn6E7s/JbJgudoXtpCIV7GGCjKHbs3VMRs7PspcJncUdaKcpFpG2RCVApQnGY//A4kgJ7AHU+32bXD
 OPadEQD7
 ySPD7RL9gwO2SJW4LQ4JagHB9mwNBe8X09FxRmV4HOd6+3xBGoZdri1eo+cf/m4jDHvkPtu9vvtXnwlaZJQDc0aJ/TBGHG6B5ZORq3UdvwFsvQ6iubQ4gBm6n39tkzPLx8mJ3jCTZlSkwL2wBnta96CX+3r9tAqF5zAMXk7UNAUfXSdtPjjaPkHYaTKkCKEB2Fhd/f5+DbHubUFvWYZh+rfRw7A83weWsDpH1IQFFqtYCgCMzQxGjaU4rYF9Mn3w4zo7NTXnH7IxAsjk6qNkayV0h/KGzUOn7yjFf8vP7cQRk+oVPs28uggfbadWHoIZ5wSoPSRhYPCx48NY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for removing __section_mark_present(), let's move
__highest_used_section_nr handling into its callers. Verify in
sparse_init_one_section() that it was properly updated.

In sparse_sections_init() we can just set it to the last processed
section_nr.

No functional change intended.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse-vmemmap.c | 1 +
 mm/sparse.c         | 5 +++--
 mm/sparse.h         | 4 +---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 96506f594924c..e89efb67e8e6d 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -865,6 +865,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	__section_mark_present(ms, section_nr);
+	__highest_used_section_nr = max(section_nr, __highest_used_section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
diff --git a/mm/sparse.c b/mm/sparse.c
index bb89017254f4d..a0f50ca5acf5a 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -177,7 +177,7 @@ static inline unsigned long first_present_section_nr(void)
 
 void __init sparse_sections_init(void)
 {
-	unsigned long pfn, start_pfn, end_pfn;
+	unsigned long pfn, start_pfn, end_pfn, section_nr;
 	int i, nid;
 
 	sparse_extreme_init();
@@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
 		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-			unsigned long section_nr = pfn_to_section_nr(pfn);
 			struct mem_section *ms;
 
+			section_nr = pfn_to_section_nr(pfn);
 			sparse_index_init(section_nr, nid);
 			ms = __nr_to_section(section_nr);
 			if (ms->section_mem_map)
@@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
 			__section_mark_present(ms, section_nr);
 		}
 	}
+	__highest_used_section_nr = section_nr;
 }
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
diff --git a/mm/sparse.h b/mm/sparse.h
index 242b7bab0013c..c396d5c05cfc8 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -26,6 +26,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	unsigned long coded_mem_map;
 
 	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+	VM_WARN_ON_ONCE(section_nr > __highest_used_section_nr);
 
 	/*
 	 * We encode the start PFN of the section into the mem_map such that
@@ -44,9 +45,6 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 static inline void __section_mark_present(struct mem_section *ms,
 		unsigned long section_nr)
 {
-	if (section_nr > __highest_used_section_nr)
-		__highest_used_section_nr = section_nr;
-
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 

-- 
2.43.0


