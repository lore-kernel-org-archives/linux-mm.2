Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ABAFC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038A86B00A4; Tue, 21 Jul 2026 12:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010606B00A5; Tue, 21 Jul 2026 12:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68CA6B00A6; Tue, 21 Jul 2026 12:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C37196B00A4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 556451A0204
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:32 +0000 (UTC)
X-FDA: 85013306784.12.57A46A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9D63D140004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhVsU+dw;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3plug0lpgCKrfv29ZibOjCkE+S+2rGS3Cp9/6Aa2Hw=;
	b=31NJhtboyZdxyz94IxE92ZFMbHpi8f9lLeVNpdu0j2fXVFReK1NEbk8SlNwgpaK1/JczVF
	ym3d8Vl3i+8iOeBXNNYfQ2WN6ydAxkcCwucV5g8vjqHXD9Cv09YUrHWrjogmPxtXe6Tv1F
	NzwMuiF04lAng3wv1RGUhnGbw4Md8jc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651070;
	b=cImIdC2YMNFENksHGwC03vMLOpNCLCyOqzIlxPZYtWFAyxFUuDqJP3KcFc6HHnludk+PPB
	gWVyqk6cJneOxYn1HtZkdM2DJC8pF0Y0gmEXbIFozYBdtOXpdgL5z/+91EIdrH0dyMT0YZ
	5AeeNOurt+M/ZO9R8TMRPuT8C+h2jEE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhVsU+dw;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9E4A43D98;
	Tue, 21 Jul 2026 16:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF361F00A3A;
	Tue, 21 Jul 2026 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651069;
	bh=N3plug0lpgCKrfv29ZibOjCkE+S+2rGS3Cp9/6Aa2Hw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JhVsU+dw1uwxmH+EE0axkr86r9H4Da8cc7CfnWCI4wWPzlF5gUGtel5DmYZ9NErCS
	 XCKTR6iq7tkNHolyed9vXfwK3qbIarzEac15Db3nrnBnAG4uRipAWCZkqSJzfxRXF9
	 RcLT4nTwwlotjyOqY+NRUMsWXiwXX8py7JLCE9CYhay2srofX1xLhpmO7N8VDLJDIB
	 Vg2DnuMbWSwC+kAoJpfiIiq1LniqN/W9Wdr5VH0LjFr3rE24wGTjUnarOu7LxSybaX
	 m2pvdkDDd1Qr1gwirFPPNEW6TO3uzcNKIXQjoIqkG2nqlKt19gnHV3wZcVJCxLkt0M
	 GaSPW60FCIAEg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:30 +0300
Subject: [PATCH RFC 07/18] x86/mm/pat: introduce cpa_handle_large_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-7-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9D63D140004
X-Stat-Signature: ysi3i98qk66ym6j1weri1i5gka3st85g
X-HE-Tag: 1784651070-709349
X-HE-Meta: U2FsdGVkX1/Pv/8NKRTrc7lt8/fyZ+pzRpokZ/1Wa9X8LCXMILkhYgxKtpZWa6TCJL3RiHL6ts8X1x1dlNh5p4IE4zB1MswjXdHdWPUTc7HpVGKNZKXJV2VWIdr1aZDn4S5iTrmA+Xqg0L2xvEGpW50j4ddcaGJa4plx4kTYEajzsxz/vnTQq5NCub9dd4PndljljvbDHS1TPNeH/HLXHmpEhL+VJgNGcg7ws7qK+J8bN3U8DJrPvEsn38K+mkJSezVi/6m5sQmGTvMOqGbC2VX2vrdt2Mv8O9E/jfakqtXxmx7x1zWhkWskG5w+8qTYJ01lN5HjA6M8hZQBcFxBQb/5/sCwbZNmzn+eK8K0Mm26P07esmcvyDrlmFJ992LVW4moZujgA49im9KzzSBm+SACRdeDi+r9eKKLFoUmXCG7JUEw2caGZxzPLi+jLXG7R4nwefEA5KxP0xV2NN25p5z8qZaDGdT7ku5gmiWiIRkVKv5p4vdLIIPi8ERgDN1r8cJiGqBa8mh99W7EWveMwstyCMUmJ4VRQOb9hWHBPaoJPj429oZmtnkPcyr1QLl4DuDqPHENxSo1T9eNVyO9xq/E1w3Q/5976ouDnEhVecr6OEUIrw30/bxwir6Aabtfbr4n5wngTPEbG3cYhhXuyapO+bxtbW3Ik2XDkQ8mEZsm3dpnq5cg2aawFz93ExN7YuyOpelLjF9Zio0K78dGjd3/qkVJe7dt5N/crdG1OBpYvt0zbccSgF6c+OfyjPdF1kr80fDaIfdqPzO+lApSQVkZxDI0ylxKDvSD22QXSmWo8LMDW6DoeiBIYBHQULrfht33rkz3l++Jhp92ZZxSvO6Ofq4CqoaijDREq6WMbFnqDKnMR6j6CCvGWn8RIg6XhN2m9q8BVDGm3IhdqIDptpPArbkqm8MPy+MjjEp0EzUfEkNm1b1qkh26NK8pNYsZCa2tOQBjXfKf7zhRJh6
 JY7u8ESH
 8vIyvmrhsl3tur+QVxilZxRE11ZHqhymEnAajUEeegh1777IE+FUQz9NKfUdup9iftWhfz0gQ3gWTffwpamlVEmSiFMjmEot16qVCSizQdA2cFgiMuQnbALWkwV67ys2vAUijdZ4ycLIJ+bvy7snxQF6J2QrSwGV7IyUMW3b7BZcYejWok2OpGd9pX3ANK8V1jh/ji/eLcvB2NymUu6IfgsJA+b4B1q2mPL4PfcJqWvXasH8YvQSVVLco5LDS5QOanQ+Ka2PAqPRl6J7D6LRLI7khK3fjIXYbZdkg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently should_split_large_page() and split_large_page() duplicate
some of the operations, like PTE lookup inside the lock including
detection of NX and RW bits and large page size calculation.

This duplication can be avoided if the split parameters are passed
between these two functions in a structure and the page table allocation
and locking order is slightly reorganized.

As the first step in this refactoring, introduce cpa_handle_large_page()
helper that wraps should_split_large_page() and split_large_page().

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 54 ++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 2a087dcedf84..a9d270e986ff 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1191,6 +1191,35 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 	return 0;
 }
 
+static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
+				  unsigned long address)
+{
+	int do_split, err;
+
+	/*
+	 * Check, whether we can keep the large page intact
+	 * and just change the pte:
+	 */
+	do_split = should_split_large_page(kpte, address, cpa);
+	/*
+	 * When the range fits into the existing large page, no split is
+	 * required.
+	 * should_split_large_page() updated the large page attributes and
+	 * cpa->numpages and cpa->pfn.
+	 */
+	if (do_split <= 0)
+		return do_split;
+
+	/*
+	 * We have to split the large page:
+	 */
+	err = split_large_page(cpa, kpte, address);
+	if (err)
+		return err;
+
+	return do_split;
+}
+
 static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 			     struct list_head *pgtables)
 {
@@ -1790,7 +1819,7 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
 	unsigned long address;
-	int do_split, err;
+	int split_res;
 	unsigned int level;
 	pte_t *kpte, old_pte;
 	bool nx, rw;
@@ -1842,27 +1871,12 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 		return 0;
 	}
 
-	/*
-	 * Check, whether we can keep the large page intact
-	 * and just change the pte:
-	 */
-	do_split = should_split_large_page(kpte, address, cpa);
-	/*
-	 * When the range fits into the existing large page,
-	 * return. cp->numpages and cpa->tlbflush have been updated in
-	 * try_large_page:
-	 */
-	if (do_split <= 0)
-		return do_split;
-
-	/*
-	 * We have to split the large page:
-	 */
-	err = split_large_page(cpa, kpte, address);
-	if (!err)
+	/* Update large page or split it */
+	split_res = cpa_handle_large_page(cpa, kpte, address);
+	if (split_res > 0)
 		goto repeat;
 
-	return err;
+	return split_res;
 }
 
 static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary);

-- 
2.53.0


