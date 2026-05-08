Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 769E4CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6D76B0285; Fri,  8 May 2026 16:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98D16B0288; Fri,  8 May 2026 16:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3556B0285; Fri,  8 May 2026 16:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B26AE6B0285
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:20:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B720C04D7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:49 +0000 (UTC)
X-FDA: 84745371018.29.D0EABB3
Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE08F1A0014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=C4Svgf+C;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf19.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.149 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+VsAe268AqTCt3bJy0GHLNrVxZajJrbaFUpnRg04rA=;
	b=qrnv4PkDD9HwoY0M0U6/M/OtiKQJC22Hi4qD+in1GXolJ0cEo0nDpR/UJxFCGYwSahjZgw
	QqnGXgLExtyfpqa7sjp0ZVcvfTYfXms6JXNV5Ha9HObTEO5U8YSQTx6JtGiylkFvefbi6Q
	D0FPYGJSyj6XQox3NXEoMRkNjs02T5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271647; a=rsa-sha256;
	cv=none;
	b=q/UB8et9GvMtKHQtWw1eAvosaYj/B26Hicv51DI2Z0AHx7qGazdrRHd3cddH6nlk1wGcB3
	JAD1nJYdvKYcb9quUmOB50c3iRAOyDDSqQqTBQ2aKgXlKjmeIACNRi5TbQvjvmp3Kr3pxp
	OwPTUMqJPbFzNOuHX2DSuq5AOd5ynz4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=C4Svgf+C;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf19.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.149 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778271643; bh=7+VsAe268AqTCt3bJy0GHLNrVxZajJrbaFUpnRg04rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4Svgf+Cua3obXizWlV2nGfPpWvCazlMA5FVVMQc5uN2z5eVznxDUyBmpdR1EctLv
	 3YDdso6F8BtdYh49Dc0G7UnLulbGTDM9vqJR8jZcXLQZwBGD+pZoRmD8Em2/W4o7oT
	 3E3GZTS4Nv4TbM0h41n07gGgDUOFm+AofYhi/nbI=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 52124024; Sat, 09 May 2026 04:20:33 +0800
X-QQ-mid: xmsmtpt1778271640tmrmaao9o
Message-ID: <tencent_CD11FE9B4A0B362E95E776C5F679598FAA07@qq.com>
X-QQ-XMAILINFO: OATpkVjS499uoZq1R1mcC6Jb7yeLTJbbmAfMYJ8QqsiQrPoRXtIk/dAtVzCvNu
	 YH4XmMQyzr/Zi6/QFcszsPO8FVD/417uIaBeVCyABHrm1lqRt6gp/EMGG6hL0GDY7QMzsHZEzrKr
	 5aiYFn1muYUnHC5nDw9zogMmMYNduVIsEqPjrxlKUiE95THEL4mQzyDOf16Bh/idM1ozDn2nnLIc
	 u4TP9X45EBo61+7csmKqkNnNrTvW3Ny+lk8A0KQNr9rJzZwBdt02xuplMF48tjZ9sMIG6pKLM2IA
	 5PlCvduFrUdVcuGkV/OcJjD1ltjZf+HbuuLRYgAUnanPM6XzPbrzsyN3h1Ngl1kN8PLZ+4bLfJeP
	 4TWv78/1bFqcgcXZIEKZwtwsV1EUOW1vRK8YyKGivI5wg/xy4K8tGn6Fu4LBFWHBVN82F4rjz+4Z
	 R9zAy/wrRlh4RiI6xwiIf2si1EETe/lQQ9k5GaDN/Kw+HLmXif6UwccKsGeHHwjJn3ORz6mXT6N7
	 jsQRE8SIdq00db+ZwSeqnYDPWqYlDdy1LMtrxmg5ODfEHEA3fIzC79HyWTs7ROuH978XDkSvDLTP
	 kHkLzgkcrer4CY0E5FaTDiT1bY6cNgz09Ds11PKfzwpyDjR0u5q1RVFgMabn+wP8eutkhT0N2SZV
	 mYRQHLqaN9JPlkLu3v+kUigyfZ0qoETkV0lizuwU9I2pZDMsJC79KGmcUtRbbknJY3G4lgeHA/Lm
	 DQYPpPnXOYPfwtl7iQR3+Wcfb7AL2BbKAavXSWnmX8nz0Fwk1uVUzi3U5QKKjmE9ceXLwNFxADey
	 8qBRIitATtl4os38v5ttIF31UUUn8+kOjCfu0lQ0qClI8FuwLoAbmM7eT76kZCsGNAWxV77aa5kK
	 jjkgpJQuGITnTHZ6HZ+ELQpTsgFasU0AiwmmY+cFo3193QgWY2YBdlzPVl31jNJvK63dsq3e45nC
	 UAA7HLsv/V3g9tovlugrvqzPMs8g/Z1+YBboemzQxzzDYB5VidpEl015kzEfhzdXpCYF+qZIHw6I
	 W8C299uLZzEcQYXcMs3gUmJMjklf6AxUOaydthB9P0ImOSG55SIgj3c5U2EUSRO3vZHTOmXIAnR5
	 kEelkJ
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baoquan He <bhe@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 4/5] mm: swap: fall back to order-0 after large swapin races
Date: Fri,  8 May 2026 20:20:32 +0000
X-OQ-MSGID: <20260508202033.1834876-4-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BE08F1A0014
X-Rspamd-Server: rspam04
X-Stat-Signature: wtc1x9uz148q8pby1e5nbnxnhfhr4ahb
X-HE-Tag: 1778271646-875885
X-HE-Meta: U2FsdGVkX1+5Q4OQ5cmcG3+SMz3qIa8OnLv4+elJjcKBfG/uH3ahI0gk+4oxruUlEaT3WjSK7ycSkJXs/O5fJ+GCsaI27zQ/fGm4QbWHPNZsO6QeDCpI60Hhb8+MnLLcJanrR1iG6MzCaODU2TLr347BLiltXcMbAuiqkDEBV3JQd0myyzZyVd3v/aYt0Ts8UvjG4CaupkvYjkski/HPUcKA7/oLlvaorCPqlvnUnrM5tW0kvbNfgL/HXWfWaCkrAkMvAEDPxJ2StPfIzdD4/IK7NbNFxxgnx93DpyHOhEFzj9I7xs3Pe51D5exz07lvud+PVqbACAP86yzipwBysOfzJbDjhMrin6jRh6SK634Yvu7RyJGFR5CMXyWbcSOTnc3OQM2ANMzgcdJNVPGDlaC1IZLKlfzCe+wjfG5PRLDel/dQzmEcZ5WE02tpiifTGUqpOmtAx7GQ/i5Je5EqSU4tO3JRLx3ZSwITlfP548eQyJiETVp1pFaQWFcd7TpHxlaRQbglfkLp1VdjsMkY8deOm4yYv28TaG7bOmAaf7Fr0BeIeNK7Vgf4b6ZQxR1WYPK8/VyHXu6ETFPOVwVYC1+M5uI/T9yMD+z3Kfa/QNTiqOHx+BD40Un0MJG4RhTq9unjBY85hhKzcdgsmry0EwYodtLY32TRjG9XpLtbEs2WvVgigDmJNeB/mdD/X7y5IlpDM1G/exITyLwTHz4ef08re605bjrBkjW5sgwYSEIB8wYnWwQON7wXYYZnQHdxzK7eKdmU4E0h9T+eQfM0Eb4gYXVZ6wG0KCP7Jn/4SUvHoV9oiBC6IpG0+NNpF11ZAHcwkG2n9/KIjXxAkMbHtntP5zKuaE9Ocf2O5CnLyeKukr/yn2XXBRG1TSOe5KaSxKE/Gb5NKLkjLoPmlvuqXj0LoPRJHUQu5Niw6P3oP6zVhUz8FC2H8LYmGfLrPUWzkQ4fXA2l7h8PD/1yh6T
 Iwyk/f85
 AuA6MqfqmGIXufgyCqKCbRrJHtHsTwVLPbsEcXj1wjuFag8sl0YvxRruOGGcT4ct7t2w9ewQ2xUZUdL0tEgOwkvIVGsAkZRO4C1qmg7pF3jZ9Vkxgo/TIS8A0eGjEtj1R7vgzxj0YVgHowAYQ/31k9nV9SvK1xKm5n0oGcMjgI3NETjI/vS2TCSzzNPFMbmCxcR7ofIKHdor+T3FKKxnc/4JnamgXjlVu51M1GQFFaYxYVrSGDjPgw+6q3CXFsuRmNtdNVss7+/oH+d/P4kSXmC07qS+1kM+DX0aUuVRlM8ixen0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swapin_folio() documents that a large folio insertion race returns NULL
so the caller can fall back to order-0 swapin. do_swap_page() currently
turns that NULL into VM_FAULT_OOM if the PTE is unchanged, which is
harsher than necessary and gets in the way of rejecting large folio
ranges for backend reasons.

Move the synchronous swapin sequence into a helper and retry with an
order-0 folio when a large folio cannot be inserted into the swap cache.
Count the event as an mTHP swapin fallback before dropping the failed
large allocation.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/memory.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..84e3b77b8293 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4757,6 +4757,44 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static struct folio *swapin_synchronous_folio(swp_entry_t entry,
+					      struct vm_fault *vmf)
+{
+	struct folio *swapcache, *folio;
+	bool large;
+	int order;
+
+	folio = alloc_swap_folio(vmf);
+	if (!folio)
+		return NULL;
+
+	large = folio_test_large(folio);
+	order = folio_order(folio);
+
+	/*
+	 * folio is charged, so swapin can only fail due to raced swapin and
+	 * return NULL.
+	 */
+	swapcache = swapin_folio(entry, folio);
+	if (swapcache == folio)
+		return folio;
+
+	if (!swapcache && large)
+		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
+	folio_put(folio);
+	if (swapcache || !large)
+		return swapcache;
+
+	folio = __alloc_swap_folio(vmf);
+	if (!folio)
+		return NULL;
+
+	swapcache = swapin_folio(entry, folio);
+	if (swapcache != folio)
+		folio_put(folio);
+	return swapcache;
+}
+
 /* Sanity check that a folio is fully exclusive */
 static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
 				 unsigned int nr_pages)
@@ -4860,17 +4898,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			folio = alloc_swap_folio(vmf);
-			if (folio) {
-				/*
-				 * folio is charged, so swapin can only fail due
-				 * to raced swapin and return NULL.
-				 */
-				swapcache = swapin_folio(entry, folio);
-				if (swapcache != folio)
-					folio_put(folio);
-				folio = swapcache;
-			}
+			folio = swapin_synchronous_folio(entry, vmf);
 		} else {
 			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
 		}
-- 
2.34.1


