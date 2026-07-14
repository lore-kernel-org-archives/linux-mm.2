Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B467C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F066B00CF; Tue, 14 Jul 2026 10:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF7D6B00D1; Tue, 14 Jul 2026 10:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD4A6B00D2; Tue, 14 Jul 2026 10:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEBC6B00CF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3781FA0064
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:24 +0000 (UTC)
X-FDA: 84987559608.28.06E08C7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F07B14001F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tcs2QjbO;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038042;
	b=xTNhxQe4Wx8ClKXzx6/J+PjvgQxg7CsGjF8T+zF+Sr4FF1HQThpOjlkpcM3fRno1uJloJK
	lgjgRI3wXKIvsmh/C2UQfcJzANfLOq8rI0XFan06gc7erpcSQiACRmm7XCFamMzOWYTirt
	o6qgnjgOPw87XV7Zg22tkfUP7oQAnzA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tcs2QjbO;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2AtuGnMkKUmg5Fcb42sI1/yhBOPgS1GscsBtzFqMWqA=;
	b=vo/Bc54ui6Op/IUnw88ttY9I7wJg4FlgNgOMzGjsNoGj5Boy8jeZMuueQwDjBI8m8Zlph0
	/8njZ9ac5XcCScbmjlJKQl2k72H7+RV4iaAIYh2ucmDM+vdLd5oYJhjPzPJUFl7b9wyNWT
	Yku8bhfAfwG1K1wrZcUZvnBdX9RllBU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49CFE1CDD;
	Tue, 14 Jul 2026 07:07:17 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 211913FBB1;
	Tue, 14 Jul 2026 07:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038041; bh=W5yMHnXfWcnH1ZpiyUJxzPFiGyzR0nmofTO/4v3XglM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tcs2QjbOfi2UrOaEb3Be0yDpY6GZomCe7QbbhuAt79rvxsFv0nPzL+CWkgYpCVks/
	 ogkFHzzFifaJTeH1MCRm+XyD/611Im1Ut2kp5sQ9dzHO1o7eUkGFrrRiH6Z4V/RDtz
	 /vlFqoX8JwYVcEUc2qvYwpr+Gn4LoNg3DQ/uWfI4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:06 +0100
Subject: [PATCH 17/22] mm: pagewalk: drop redundant address check for
 kernel mm walks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-17-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=1902;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=W5yMHnXfWcnH1ZpiyUJxzPFiGyzR0nmofTO/4v3XglM=;
 b=TFBgeJD80Ix+w11MAOvfP3+Vh87dI14Hnq0FHr8NrSRBwD9XPKoZw/aAqVJc1+sG5OV8cIA+P
 hlg2L1E8nGiAdR9B4tzknmDLhA26Dhv64+3Fs4YGAcZ8Y3UcdoWIKP6
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F07B14001F
X-Stat-Signature: ayqu4ya3ugz1cfhif76hdme9s9m8oig7
X-HE-Tag: 1784038042-616183
X-HE-Meta: U2FsdGVkX1+EGqqnRp6CsE4X7IW6tzsn95Oer6gWku7d3v4NxbU9j87zQhr49GVr98NsGqb7wFtdqMUfH3+ytTZwrXQY744Di7Z1FZMw0MLSJ98W/hnhfP3gROZ3Al6Dw5E/3aeuuagNmriBOTDU2XOHSGiWDoZTeYDFrKSao2xffMDgZrOxHfM80jR6xgm7oSgaaz2nPvjNXm0OarlfmJSIci5JJTrw58dh89UjyJkxPf6Jt/0DWIpzO4qC5bBWOPanopKBfvIcSBvGCyUXw5YeIBz41b9omKjTaaSSnJG4uHj2EfgPCFF51eK59i3O0iVVZh6Ynkyo4W8TvJucqatBaVBXjsDyOZpCnSzGkCpiXwci5SC1vOoaM8NOgzK5ROVzVT073nwvIKz5knaVn+4ybdFl20Vpcv6YAe7u5GdeJY7DqsTZzLOb4K8SNQzIJV04VdV9rZFB58k/hC4xhQUaw8t2J13Il+nlI/7SSoXTayFvliwfi63edmeLAwS5YsEFObmbcB5sVLaVvb9ulXmpnTyIylmaX1IVo8mbBJ/gsDmD8vyTp/6pMUsk2afN2tr4dfi7l+na7ee3/MHGO+7DStF2wOWfdLAw36mygnXNdMCclmbQUaOChLR2ASzNsl10h1CVrG89ZzMuNb5j5+xZlLGkTxVvcpNd6gkz6b6mEPuWWa2YGgxIswIE6LJnGriTiHFK9AqPbAzEMjQGbUjk6CMQw5X438jwNuV7a7orOiyFXcSrx67TfsMm1QFbTJ0y6K9hkbrAoF4hhUczzTswMM5Q/tdMcoShEVnFpl3cyRk/zZbuZqB/rqjhmgr8DiOsou9nIaMiQhgs8MEnnsjdk1eqq1/FxiCHx6vCKOuKYLr2rkQPnfhofYz6oFDb3Y5yyrYX6s84WgeNBPK1psyKa27b+bEn6M244CGok/hgE52f0RX3Kr3N+Cwc/xp4s3jepawD7n+79iwOUnW
 MYJNa6yZ
 B9If9gp8DIKKbAT0y2VkDSoAuUI3wx+2+boDrJB3moX1gnMG1c6icbFmyrD+zijr/L96opG/LjYcOnTStyNSIc5/KKFMTVzqsScs9bH5WyQPgsY/Yj9cWPojdUUjhE8JW3NuwtvU2LI9ID81J11UFXduuaRSNSDKjbrGM05SBAEPzd9749jCRCY6Wzcium2UiqOfJm52r40kXQcSVXGDp44+8wiSJnmGLQgxEDf3WeRWf+x24CA27OUvBU61yxoZqpeeVu3yQ83wMiToJu5iVNs6CRhi9qs4FgI/1dUu7/RW/qv15GC0IOYyx/eSW5tOwX9bE2raNgEaUG7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 8b1cb4a2e819 ("mm/pagewalk: fix EFI_PGT_DUMP of
espfix area") made no-VMA page table walks use
pte_offset_kernel() for any address above TASK_SIZE. This avoided
pte_offset_map() validation on EFI page table dumps, where efi_mm
could walk x86 espfix PMDs that intentionally look bad to pmd_bad().

efi_mm is now marked with MMF_KERNEL, and no-VMA walks use
mm_is_kernel() to select pte_offset_kernel() for kernel mm's. As a
result we no longer need to handle the EFI_PGT_DUMP case explicitly.The
address check is therefore redundant for EFI_PGT_DUMP and makes the
condition harder to reason about.

Remove the address check and associated comment; mm_is_kernel()
should be sufficient on its own.

Tested by booting x86 QEMU with CONFIG_EFI_PGT_DUMP=y and reading
/sys/kernel/debug/page_tables/efi.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 mm/pagewalk.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a3f47d1de3c5..0dd9d4ad9b68 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -68,17 +68,14 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	if (walk->no_vma) {
 		/*
 		 * pte_offset_map() might apply user-specific validation.
-		 * Indeed, on x86_64 the pmd entries set up by init_espfix_ap()
-		 * fit its pmd_bad() check (_PAGE_NX set and _PAGE_RW clear),
-		 * and CONFIG_EFI_PGT_DUMP efi_mm goes so far as to walk them.
 		 */
-		if (mm_is_kernel(walk->mm) || addr >= TASK_SIZE)
+		if (mm_is_kernel(walk->mm))
 			pte = pte_offset_kernel(pmd, addr);
 		else
 			pte = pte_offset_map(pmd, addr);
 		if (pte) {
 			err = walk_pte_range_inner(pte, addr, end, walk);
-			if (!mm_is_kernel(walk->mm) && addr < TASK_SIZE)
+			if (!mm_is_kernel(walk->mm))
 				pte_unmap(pte);
 		}
 	} else {

-- 
2.51.2


