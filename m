Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 884CDC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DA76B0092; Tue,  8 Sep 2026 08:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E566B0093; Tue,  8 Sep 2026 08:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643FF6B0095; Tue,  8 Sep 2026 08:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3426E6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:33:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9328C04C0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:33:12 +0000 (UTC)
X-FDA: 85190535024.16.550F3A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F111E8000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:33:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLtpz7A5;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrlRHDKkKksSse2z7V875Db2PCZ3B/h/JK+Hse17ruk=;
	b=UEnOnei0qrasZPZ2FRMAJFUYPuLZH2XBQ3FsJkXrVU6hP5M+MJdANhfunRoN8sowfs2Jok
	KvBHOKJS0ReZSc8B4Yp/Can4Jqkv2/5j6sWkRDMa2ABpUOps4VCk03ASWRgjcJT9lcTBGc
	htQ4mkyORiaqkz0LfUuV7kY6dAibDfo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870791;
	b=stmMHbk+gI3FG4Dgz/jdReNEiUZN8/bxe5sEA/og9Qbf1y3F5+6V8VB7njQpHPEKqkUbsF
	LU4Re9NdPev449QcfsPqk0LJX56QksJ/4lAcoFYTrFg9Wa8MjgoKtTx54LUlHpmpwyHtht
	gEQvlpAp5D21o0s2f/AtvBsoio34vHE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLtpz7A5;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97086601DB;
	Tue,  8 Sep 2026 12:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC691F00A3A;
	Tue,  8 Sep 2026 12:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870790;
	bh=qrlRHDKkKksSse2z7V875Db2PCZ3B/h/JK+Hse17ruk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aLtpz7A5VymVqyE5xIUldqu4FEfYkW3C/kRkUKk7eS5Fd938lNBcUqjWIc4HUU61D
	 DVipoD/pdYsc76ZExc8Qvd07r0+EVBvsmN0INrIpBqY43rMzTPkA1y8XItRLueMgmx
	 3YOfOCnlih3OLyVjTsPc67cCII18Lx0cRR9hCnypeOHaV41VQzUaFqL6rwG0rnaocV
	 dq/wVeanPRwRB8LUnw28+2OE1zJ6OXYKiYMDTUC/ChepsXs8Tbov72fkpOZpN5UuX4
	 BnK+GneNUBzkfBv1WkAj2ZiQktcmuToqdhISbN/sVHSCyc1BsNQXmhbGQ6rk9lwLrr
	 h4poq5HhB3GXw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:10 +0100
Subject: [PATCH v2 01/12] mm/huge_memory: zap deposited page tables after
 an RCU grace period
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-1-1f60b64e878e@kernel.org>
References: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
In-Reply-To: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, 
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1907; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QsmXD4bhTqKAKkUCvIrmgq1QZ07I5df5Am7bAMtZYGk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMEQz2MotteNZL1imp//16Cr13zP57DKuWi88+/7V3
 rv7jPrnd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTGBDuDgFYCIdVYwMTyUVDice2bv+1N8t
 ptvOq5Z+sY5uu1n26MCPewUH//vl7WD4n9LEE+pReenVX+nclMY/0peKpct75+X5nPI4xSKj2PW
 GFQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F111E8000B
X-Stat-Signature: bqtrziyokhpegdq5d7wnktbaty8f6mer
X-Rspam-User: 
X-HE-Tag: 1788870790-807610
X-HE-Meta: U2FsdGVkX19Cf1dNf/ig1mz60okSGp7rqK3NHZc43cavTfHDXXspaP19bVXd2TsTeKsOzsQZOSv2rEanHIQUNy15JhnxRzmDHrjfITgEOss2fvucyRXWdYsdks9J0AxlI1p9KA+KsdGeKY811SgrsVXzrP3SbhY3fwMncPi/BHZFBeJwav9HEwugo7mtXHMJC/KoI++L2hLV0CynmtEFHVP3ZO6+1tBAtAyLIUGQsmJrnj+ic17wfoug5z5c4TyIfUOOAt4vBLQMOMDynZQMNjj8O+UvrHEdUnkEGoe8P0tAy2eyxfW+gTeHEw53Tw1zFe4Cs+R2H9YpRpcxQ0Ec3bgikNgorzRbW0O60yDBfa+F0yYdiVFkIMiwA0k2pSE/eC8NcJc3LbIal3mJeSUAGkkA1u/g4fbEVRpPkwDpfu6OMEMG9BylmJHqNc/lDohku4o0qo0JFIjug6bDGtz9UtXrcdv4hPUONoFAFJra0cjkelyrJPzfUJphurWT7/Crx05uM++1jCOVWqXCWOJJGrIqY3F5feTWGM5PaF1nuLCDfma5er9Munow2abbl245o2OHJCOU+U3y+4Zkxo+GJWPel4q8CkjngvXLlUTiBr9VPWDsDxdRKtMxRDzwCGIviFiROunxXytSWvgaPi5f5oPnjUAEcFWfklxRJwxPNA3aLAnLtZc9lv+sZNT/HRfdoHw9hiw7tRIrZd78stJ+a9+9Dx1a3RUMY0puSYpYAcBo8jnNngbAxr91moEPyri3JDEt9Nc3s7jfjZZt+VmCyimIwvVHXg4SMnE6qdwrwgI8RbrQk3SDTzjEpVi6L/vGfLM9HqcX6a7Rz8dHIt1Y8HbQ50cRZhV0jaFDNeUrPWn3rsNR1uTSpsPfcq069wIIKrbEtlYmbH4wG38Mhg8i+eXaZztqqK+X+pWKztR5T5YojFsWlTz6GaQsB7XCRG08Z8TLV7RM9wfLyhEw7tL
 FKedvsX3
 wb35bnrpphqKHGnmOeOH8dNYaxDXOVHjEB4W7WO/k9mIGUHI0DAfiDHoj4quyBIjR3Hq10FA0yi4NQkDEg3aZXvZhPK+ubMdwjRKndcWawCTpmkyVA/bbhUPjeWsIIPWf+lYrC8uVGUXl7GCpI28drf09LWOcl39ZxNKYCXBJ4arTmeZNYqpOFxacZJkJ9iMSQwxkL+FpAI8PcTmGrJpDCB/vJHPe6Xlpg3qMAfaPcaQQ7oDQX525/fYku1lSwaUiHWVm/q1CxUrMsLsy72sJcX7kxFQ0sisNmKpLUJlz4AUHTTpvIxaUA54i3Z93X5XJFAWOXRJKjQhlxVa/nFUA9VKAH8sRHaLBxmPyzZiKL3To9VSsEQ2rPy/lRAFHZ+FEWVctSiy7a5CjHpFt0f8b2Rcw679OZlLNHpMxoamaPLcJ8S7VSIlvkgL8LX61yFGuQemSbQ47xUseBZ7D00FFL3bkNFTpSqz4qt2MJRBMnftg+PY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an anonymous mapping is collapsed for THP, a PTE page table is
'deposited' with the installed PMD entry.

This is done in order that a split can be performed without needing to
allocate additional memory.

The freeing occurs in zap_deposited_table() and is done directly without
any delay via pte_free().

This is currently not a problem as existing page table walks are protected
by the mmap or anon rmap lock.

However this becomes problematic in a future where RCU-only page table
walkers exist, as there is nothing to prevent a page table walker that
started the walk prior to collapse having its PTE table freed underneath
it.

Commit 13cf577e6b66 ("mm/pgtable: add pte_free_defer() for pgtable as
page") already provides us the mechanism by which to solve this -
pte_free_defer().

Therefore, as a prerequisite to a future commit which will permit fully RCU
page table walks, update zap_deposited_table() to use pte_free_defer()
rather than pte_free().

Note that the IPI sync in collapse_huge_page() is still required to ensure
refcount correctness against a GUP-fast operation.

This is because GUP-fast might increment refcount, but
__collapse_huge_page_isolate() determines whether it is safe to proceed by
checking folio_ref_count() against folio_expected_ref_count(), so the two
must be mutually excluded.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54494c3fa983..505f7b62ff28 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2476,7 +2476,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 	pgtable_t pgtable;
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
-	pte_free(mm, pgtable);
+	pte_free_defer(mm, pgtable);
 	mm_dec_nr_ptes(mm);
 }
 

-- 
2.55.0


