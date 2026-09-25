Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF5DC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2480D6B00A9; Fri, 25 Sep 2026 16:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F1A6B00AA; Fri, 25 Sep 2026 16:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135E96B00AB; Fri, 25 Sep 2026 16:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E40B16B00A9
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:14:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71C7816078B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:14:21 +0000 (UTC)
X-FDA: 85253386722.13.B53EF09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 91ACD4000F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:14:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tu8dpede;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EF8OyDut2rayuYx4pymsb162cHu8KROP/4zU982aGoA=;
	b=2hwcPC09wZ4bc8nwxPC9OsxDDrIggtEUUz1izTZDFJFj4zdpKn4eeCSF51Qt8jVTgNod6q
	vsQdf9s3Obnpp7BzYX8Ha0qPl7dd/Bjd4qvA5JwI6LxAA3C8ykGX30frn6PYVpNI6HAZ4w
	32A3372H2rxn1kV0q9lXM/CqyOqEB50=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tu8dpede;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367259;
	b=XTpzjPmgtXrzH5RnCdgrhvDPelgdviACEQFtAKqt9vf8bYO71TG0Rr33l/Qv+RTaawcKcx
	XILhQDrHGELM7sHgdnDCQY9gpjCwvTopQAIcQtJZoSb+BGqva+dKBWCcbn5e7/9h3w6qUL
	8Ug6vJl66zJNQbNn/OvQgpxlvH/xX7E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB80C43927;
	Fri, 25 Sep 2026 20:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7DC1F000FF;
	Fri, 25 Sep 2026 20:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367258;
	bh=EF8OyDut2rayuYx4pymsb162cHu8KROP/4zU982aGoA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Tu8dpedeUynCnlq7Wxf4f9JCPrda0/Y0Tmaz1KTS9GhPwPBdedBTQWw3UhI8XcXMN
	 qrjOjBi+3lRlLTda3X+1K4Kudkf8/gcJhM/wzaAhMXThsSmK+fW9duXf2WLFxNYtWb
	 89EFQ+Pb3CZgoB8haOE2CvuTiR0Fx3WHrIzKr1daiy+pKbIyD9KemfkSgwf+ftcchJ
	 1ZDRuI+H747LYk47f0YOz+UoLOH+bqQ55biVx1Y75rv6aIuCzcus4e6lAz/qjtmRor
	 x0R3nx7I6Xd2o0CoRbj1AuDam9d9DcnDUvzaGWQfs+CUpemegdemifjfX7ZQcmzWhq
	 APU1v55lYeH5A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:47 +0100
Subject: [PATCH v5 12/12] mm: change the contract for free_pgtables(),
 update docs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-12-31e91065fea4@kernel.org>
References: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
In-Reply-To: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
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
 Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
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
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
 Randy Dunlap <rdunlap@infradead.org>
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
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3600; i=ljs@kernel.org;
 h=from:subject:message-id; bh=PnRbJJLEs7BWuuMfKr3yc/Hi0NQ6wkh885+GUnZfEK0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XeWINjBRU37zm32Wbs8P7izmFYt4L0/ebb5Vs/hB2
 tO/W64wdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAifF6MDJePGHHv6hU8Ze44
 1fzZijY7DVWGH3IB127aH/2f7sG2wYThN6uth35MleD6POFM1mvnpzi7vDeUYklY/u9rioI45/d
 9/AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: ptpopqbo1gzsa4ufsqxw1zgmnt18qmtf
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91ACD4000F
X-HE-Tag: 1790367259-678706
X-HE-Meta: U2FsdGVkX1+OO3+e19AKRLO6O9pxJURWOk/TgRflAan3k9SCUnBrexVPPKheh5I4fr43S30EVxB/570aeZ9XKlTzV4yiYPnyzAHZ55bDvJGjybui8mAHV1cUr7sfTQyGsv20OQsK1SN1WsLzcfKT3Vk/yHmg5klJQ3nLSWnVzOrt0vDJkth1Qgyo/OsTCL5w041MzFhAZwIbzv80BGnw6QpR+8JhQV/fdrvg5zqWqljBwRIMOJz8XoiLZbRxcLv9Rk4APfZv7uh217tAZukygjPFd2aoA4VM77Vs1gWJk6XvdruYOVaPnztDMWsnhffDhgwTbizU49OZc1Xr8RGpCUuISl1kKk04/MiQ6JZoRgPk/1PtRNNX7bmaqGDiw33eWhkhp289y/uUGvvRm4VCeadvi/lL0SVcAPuk0HtX/R0/z3U+GQvLPKu7AZ+/oRbtdkfdYPl7yV4XPmONYRB7Im5AlJuyONRK2yHtiafG2UiPkd86JVzutrPaghvQcfJuK7nyFRiSG6Y5ONL7HM0fANL4mFiu+cVdmHve2n+sBW+b8MNEL7F391RAwJtb3ss1JhlIyD1/kBUTb+2kSzUI988Flb46L/UAr3HTqy83SOmNawbLmLlZ6TpnURi2ZbZe/pdu/FnoLS24dw4jdMhHsAvD6bwVSk+ffCPueUth4Bb1LEvVXZrMT9z+lG8XmIltQeo1dvJ0h8VzffC6dCR0FcCIJn0InGDxTi+kkduADIT6v0+pUX75unNU2T534XRB+XUENOOvOdJko9k1SMw2ZryUR0Xx/AW822yHZpl6bwail3H4jLxQBd7QUyVFvhzf9VhJ70gp/wfY11BKkfw9iQAWhI1dEb+uwQEj7cXMGjUhn7jNUfuMZoq/n1h3M74NtWUe/opGMNePtyZExXsMS8pDV6bz8MGozVx4oX5n30O5gF1lCZm10IP7Y2CCydEqUrlvW33VNRGT+PkQkSO
 7wHayR+F
 alrndTJ2t7JgfvKD6Sdl2oolBkZGU00m3ruQHpV11OycltCQ4UyI183lzwCKPFeuqQVcVrtdKb3WP/A7aZzxTT8HjMUid5rWJcAPjVthFaTvgcj0fcaMCCvQBGktYiniXw88LsDY3lYsoCxSjZoOe5J8GU/I4wIm0TFmT0KJUAGXxS1LhJ3j1rFqlbHEgH0FYSWaPm8bUtTJpjV3T8yPbqB2uAkK2Glp+17mlhnM9lXMU/+z+1edLsKAkZh/rCKDiYUUyaa6VsyUSYJfTkcde+QMn3foFEdYsjzM+e3pZJlvW0tuKbX6nuvWCieAQGi6qeYDG0If19BtupFZMQhN3IZaxGdQ8/SacepEoSPsMJOeyYMXWgSnMtX9WSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that page tables are freed after an RCU grace period, it is safe for
read-only page table walkers to walk page table ranges that are being
concurrently torn down, provided the mm is kept alive via mmgrab().

It is however unsafe for writers to do so, as they must obtain an
appropriate lock to do so safely.

Update the pte_offset_map_lock()'s comment block to reflect this.

Similarly update the process addresses documentation.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/mm/process_addrs.rst | 11 +++++++++++
 mm/pgtable-generic.c               | 15 +++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index a7296f251799..78231995e490 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -537,6 +537,17 @@ We establish basic locking rules when interacting with page tables:
 * When changing a page table entry the page table lock for that page table
   **must** be held, except if you can safely assume nobody can access the page
   tables concurrently (such as on invocation of :c:func:`!free_pgtables`).
+* Page tables may be *walked* under RCU alone, as page tables are freed only
+  after an RCU grace period has elapsed. However, any entry found must be
+  revalidated after the page table lock is taken (such as the
+  :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
+  before it is acted upon. Changing an entry requires the page table lock
+  and one of the locks that excludes teardown (any one of the mmap, VMA or
+  rmap locks).
+* When traversing page tables under RCU alone it is important to take care
+  when operating upon leaf entries - if the value is operated upon (for
+  instance getting the folio associated with a PTE) an appropriate lock must
+  be taken to prevent concurrent modification.
 * Reads from and writes to page table entries must be *appropriately*
   atomic. See the section on atomicity below for details.
 * Populating previously empty entries requires that the mmap or VMA locks are
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..a127e3e8f9b9 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -385,10 +385,17 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
  * Note: "RO" / "RW" expresses the intended semantics, not that the *kmap* will
  * be read-only/read-write protected.
  *
- * Note that free_pgtables(), used after unmapping detached vmas, or when
- * exiting the whole mm, does not take page table lock before freeing a page
- * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
- * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
+ * Note that free_pgtables(), used after unmapping detached vmas or when exiting
+ * the whole mm, does not take a page table lock before freeing a page table.
+ *
+ * As page table freeing itself is RCU-safe, page table readers can safely run
+ * concurrently with page table teardown.
+ *
+ * However, writers CANNOT as, without a lock being held, nothing prevents
+ * concurrent teardown.
+ *
+ * Also note that the PGD itself is freed at mmdrop() time, not under RCU - so
+ * the walker must keep the mm alive either by pinning the mm or the VMA.
  */
 pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 			   unsigned long addr, spinlock_t **ptlp)

-- 
2.55.0


