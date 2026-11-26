Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87469606A331
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNsQFQQz
Received: by kanga.kvack.org (Postfix)
	id 71A256B05E9; Thu, 26 Nov 2026 06:19:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1D66B05EA; Thu, 26 Nov 2026 06:19:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6077C6B05EB; Thu, 26 Nov 2026 06:19:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 408896B05E9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:19:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5BF9C03F3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:21 +0000 (UTC)
X-FDA: 85477024122.14.7F216E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 185DF4000F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNsQFQQz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691960;
	b=BS+E208U63aUZ6fDwFQtUsH+5Gvz1Cfg6+2KlLWO14SlIsjDipBTbv4U8mzBUcvTBajMc1
	qFPYnzWuWecakq83Gpv6lAfhtJSggBPBsWaQ26E3XUwb7TZuiMGXr4BiCJzPqdmXKI6A/q
	7nGYSaXl8Ou6W1LMw8PJE3e+E2fLnqM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLAnEU4rO4fcnrHELtjeHX6slJhEFWQGHKKApZ60Fc4=;
	b=MFshcDc6WZRQssodL9YLrLneJuPyGsHNw9Vl+Ek00rIFZZjK8aoVX0LjBWbYWbD+JyDafM
	ywzYV8uJ8PTdV3UW3BuojIfMBvwWEHF5dCe5IIm9GmG9JuZxR2jXJw7XqGQls1P0jG0YS7
	v1U+5mwKUD9rulLCOey5U1Z6PI+tH8E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNsQFQQz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB97E62D47;
	Thu, 26 Nov 2026 11:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54D71F000E1;
	Thu, 26 Nov 2026 11:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691959;
	bh=iLAnEU4rO4fcnrHELtjeHX6slJhEFWQGHKKApZ60Fc4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aNsQFQQzIyU0oDJ6kE0wDY/5N+D85rsC9dcGR3vVr338d3zGkmN0dsXGVVuSFEAV8
	 oTEYZLgMqucU1Fu7hhNNp/yLJzWYpeHiF/7r8JvCBa8kZDoKstZEw4H7kbnI8aQh6D
	 9CGAgzkzR1AfUB4pvPo49Bt8QOYpoZYaq4xYpvAR4p1L/0Cl24BbGBQoGwoU63qyx1
	 qwE75UrJ6O6rFWOFt+DxjdIIVM//Pf5zleYvK1o/QM84bMS+qpeAgXizRKQL+2xJOH
	 KyRei3fbOJDs84xcMc7o5ASUM5N6XBvC9Wqd9KXD76MdAopEEzyl/DShKPBPkL6klm
	 xsi3RfrDsbWdg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:43 +0200
Subject: [PATCH RFC v2 30/54] mm/pageattr: introduce arch_cpa_can_split()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-30-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: 185DF4000F
X-Stat-Signature: mkaokyenaikk7xuzsgnpu1akkp45iyfa
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795691959-349038
X-HE-Meta: U2FsdGVkX1+d7byXdaHU5VulTfN18ZffdaZ3tv2zNPam45oKNc+tlHx1M+LBteMDV2lhoXaRDssJFG66o9cGaFN3H1bXOUNI0AAv7oBMvk7QvIw5/PenXAxNQK6ckGsnq/HVRFE6K+p/1YOojfOP049V8IStGkbto0rN8G332R7k4v8D9zeqMWzFW8wYChgmFwm8Z7QUIC1s810mX1gehkFbRnzJ7v2gEnKkXUcbF9C5cXQZjPhu43ZZE4HNbmdOj5pc5hOjKtlIMtionXjzp347YJtZqoLBO8oqmxvrjNGu4mHbbTrU1LANXtQEh8inm7ookQfsXx7RxWejVIdwwSqCKF5BEpsjDJl/AFwlmJx/kovouLFpBa2IblYlQfBZI/iJiV1qwMhpYLAYf6Q3k2fj6M6LFBwjxPU0znpJGEe889AEKQxp7IBXGv5oSI9t8K4k4G5LzSFxRQs6/yxRgxPMb84xZlFN49Hdy1cumBmhBFDq/jVkTKrgTd2RWGaUOq8Iy9cvLQlq/jl66S0xjbpkEtvqF9hWknI0y+zJq8K/Uownw663QZN4RI3c2iwhF1jCs0dsM8VdnpoGYSVeEZ1Y5/zXWBhTk2giLL2PuSD5D/2LymtLkncRd8HgKVQ6Qq9N+xr9abkAfG0X1k+0nHFDCJI6WhSM+Xek0v+xHceLKUxEi+hn05twO9zbNW/353se0ueesbQ+HsKbAVP4ml+CSkA8UYbo8dJLcMiG9WPNqmIk00Ej1VnkTqdHt68tCDBoKJt034HMjKKQi1m2tppusRz5uTsp95YomNO+Ba4r6JbjysSHPITy/8Ldb2MHPyALhy6rwpGE3BPVNKlTG5PcPhmvfCiwutcw8murw4Bmm4z9OhSYTFC6UFQEJJWvUaQUwKgrGIh4w4jb49KyZO1q4XjjQCgZpOPxmPuNPz7K6cMOg4ZH4/E7S4gftxZwB6gSgzKVGbhUbU3O2aw
 bv0lLrnJ
 LUOQtGfxzEVH8Kqrk/skZT8ueaq6mbCJUOKLMVtjlgIJ8ncQBkKmJzUma6s6tb9KTn1Z7bX3hgK4Ne7auFEMYJIXJgQljdfyx+sdncDO7Do2M9yDuu+Mzzx5Tf2diwdAYNnz7CxNK+y711/3k4Qx+re0xdtk32ZRG/L72YqKpLchrjIFE8JgnESs3erdC3fAVAaV5CtZL1WJZQyjdxr227lnRRlzyyRVVNKthQx+CsHR3Q0zfTWnlXg05g41lcuGvTww3gpZYe4Om9OoD8PA5kneGDVkw/dPif5G2AqCW22Rg/3eT+nWljfq3I1YP6eN/o47CzB174lg0kbwlwdfm/66HIlEEZQkeAnfWvoiN+mIufvqzfbwa3FXBvPSGYObnttNFZeBlh3NnPjyGd1FWJCtBYxitqHI/WxYShM6f7joKZmLCMsK8K1XtSk+R5nl8sAtvDIqzcNV7nadTEU5mCyP713r55Wdh8x4xoxOeVRV/dr9YgtvDXnTuBndCFDEvb/BZg2m1NoVqX7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently CPA core presumes that the split of a large mapping is always
possible. After deciding to split a large mapping, core drops the locks,
allocates a new page table and calls arch_cpa_split_leaf().

If an architecture does not support splitting large mappings, the only way
for it to inform the core is to fail arch_cpa_split_leaf().

arch_cpa_split_leaf() only updates the page tables, and normally shouldn't
fail. A failure there means something went terribly wrong, so having it
check if splits are supported at all would mix capability and corner case
checks.

Besides, if an architecture does not support splitting, the locks and
allocation dance would be there for nothing.

Add arch_cpa_can_split() and fail a request that needs a split the
architecture cannot do before the allocation, with a warning.

By default an architecture cannot split large mappings.

An architecture that can split must override both arch_cpa_can_split() and
arch_cpa_split_leaf().

Since x86 can split all large mappings, hardwire its override of
arch_cpa_can_split() to true.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/include/asm/pageattr.h | 7 ++++++-
 include/linux/pageattr.h        | 8 +++++++-
 mm/pageattr.c                   | 3 +++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pageattr.h b/arch/x86/include/asm/pageattr.h
index dea7141c3713..8a3e2a35211d 100644
--- a/arch/x86/include/asm/pageattr.h
+++ b/arch/x86/include/asm/pageattr.h
@@ -14,7 +14,12 @@ pgprot_t arch_cpa_new_prot(struct cpa_data *cpa, struct cpa_leaf *leaf);
 
 int arch_cpa_split_leaf(struct cpa_data *cpa, struct cpa_leaf *leaf,
 			void *table);
-#define arch_cpa_split_leaf arch_cpa_split_leaf
+static inline bool arch_cpa_can_split(struct cpa_data *cpa,
+				      struct cpa_leaf *leaf)
+{
+	return true;
+}
+#define arch_cpa_can_split arch_cpa_can_split
 
 int arch_cpa_process_fault(struct cpa_data *cpa);
 #define arch_cpa_process_fault arch_cpa_process_fault
diff --git a/include/linux/pageattr.h b/include/linux/pageattr.h
index f8b6b17e0b0b..25f04e61ee85 100644
--- a/include/linux/pageattr.h
+++ b/include/linux/pageattr.h
@@ -96,7 +96,13 @@ static inline pgprot_t arch_cpa_new_prot(struct cpa_data *cpa,
 }
 #endif
 
-#ifndef arch_cpa_split_leaf
+#ifndef arch_cpa_can_split
+static inline bool arch_cpa_can_split(struct cpa_data *cpa,
+				      struct cpa_leaf *leaf)
+{
+	return false;
+}
+
 static inline int arch_cpa_split_leaf(struct cpa_data *cpa,
 				      struct cpa_leaf *leaf, void *table)
 {
diff --git a/mm/pageattr.c b/mm/pageattr.c
index 6fb89632b679..dcece32ebad2 100644
--- a/mm/pageattr.c
+++ b/mm/pageattr.c
@@ -421,6 +421,9 @@ static int __change_page_attr(struct cpa_data *cpa)
 	/*
 	 * We have to split the large page:
 	 */
+	if (WARN_ON_ONCE(!arch_cpa_can_split(cpa, &leaf)))
+		return -EINVAL;
+
 	ret = split_large_page(cpa, &leaf);
 	if (!ret)
 		goto repeat;

-- 
2.53.0


