Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82344C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D76A6B0095; Tue, 22 Sep 2026 11:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AED06B009E; Tue, 22 Sep 2026 11:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4AC6B00B0; Tue, 22 Sep 2026 11:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 633336B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:41:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D24F9140531
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:41:03 +0000 (UTC)
X-FDA: 85241811606.02.525E362
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id EF64880009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:41:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jI1Gy7Ri;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7feebBV+4w0SqCnHHPUA0WnsaaqlXi4RbYO862HspA=;
	b=fkeNescflv4ooBLAlXFGoJOUYD0Xtl5spgwMpZ7tsEQrVHSksVRtT04iEC2Y7OGl8WKXH2
	BeQwzHQ0+dJl2dhelP4ptktjn+8IM2lr6+fMPH7QvOOQHkD11IF5E+wjFfR2ttb1RjQ1lM
	155zvYG0aqqwGcYckC7DaNTSICuTu1A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jI1Gy7Ri;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091662;
	b=oDOieJRc+xHHrRpztmEJ++0gDsBY8teEVfIaKZXsr8ym3JZyLo1NLxdbYnha5DdHEcvbSu
	wGlrL+KXm5DQR78/Z0jn+A+bPU4znqh6YBX1zEqBrOilu/PscPgw34v76egEvZZjHx3Pk8
	ItkcTPFCRvnJ4MSs7MEJhXNpwL4xO+w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C97842AEE;
	Tue, 22 Sep 2026 15:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34FD1F0089A;
	Tue, 22 Sep 2026 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091661;
	bh=M7feebBV+4w0SqCnHHPUA0WnsaaqlXi4RbYO862HspA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jI1Gy7Ri0dwagnMGdXDueH8Vw/me/BZQMY1ZLvclBfYHE07TPWIYqEZKTOfDeKMM7
	 WWEYNmjHnqF3lwoScgBfUCpcP4Vzmd31Iqmg0Sox8i0+b3EzEc/kGtknRiFqelROnJ
	 wcbUogIVm7JOp0s23z9uLqzTc+N99mJYI/tD1tkVSdrEOCMZ8aSwT3rqdtSH2Hyz8Z
	 bOYZ6vTeWolpG4Fwfi6cgaTCqHY7pSa4UY721VzOIhSOaCjXR8xijEU4EtkTdNMAxs
	 dW8uW14KTDudI1kEbfNi0V+Sn1IfY0buJZpOX2Ea2f+GpSpPZYolfJ0Ii0rrzBB1ZY
	 xFRhD3RYFSySA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:43 +0100
Subject: [PATCH v4 12/12] mm: change the contract for free_pgtables(),
 update docs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-12-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3290; i=ljs@kernel.org;
 h=from:subject:message-id; bh=d4o8BvEhvbpmkAFDsmC7e/OS16AthPkW67coZubsUt0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2Lci5KhCa0NC7PfzCodRL5yaIOr81TeH4vvJq5rn/a
 t8KJq161VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJdCYxMkyx61z519qF/Wrr
 nHyBV2IWzI+aa9tvzQh+L+iflK2mVczwz8bMcIvqx7JdNwMKJ/810e10aW9/OveN8PQ/uWtXX9B
 nZQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF64880009
X-Stat-Signature: xjrinafcyt6abs6hcqyzsk1dkjpfhptx
X-Rspam-User: 
X-HE-Tag: 1790091661-761349
X-HE-Meta: U2FsdGVkX19n1Z9iP73dM/db+D92JmwlQUKUnZ7eD1G0BcRx6fxVsXWlXZ8vZ18btiG1I1pzvwR3M946HRT3cgc/CyNU0O6me1kb73pN2zh6BnbPYFUQEg12KMHGyko3yCrZtHRytQvNgTHmhaV5AnH6JDQ40Mgg7OF0jd2XTWfl1GhoC1dYaOLppW11Zsetf2/n2fQxCBDQBzKDBnOL8aXSdnQDbhSasxzWhlmov/ghyy10lERumnMyN53U3EkR3d18ZyGNWHJZbmNNHAlSx8ShItKYuC80fyEYOgWyxi8uTVRIPuIw2DSb0ZWzvaT4MfsGqMLddN7YVAMG0r3M8OqIPNG5c+OjHKDUB6ZSu67DifCJu9sLIjbq3IWjVJ4D3w19J3vxUJGKZRtIRvqiPs2O1jjQaJfyj251giQ8D77QjVfrh9tQFjrUvvxCPnSYVOf02Vm8lth3M2tCXOdPSO60LH+ov3uUljJq+4yvhbqVw5Mls8epi49q4M1dNBfjDN0QTi+ySgzQalVVWzTFt/VFrW62TM3x2G4Xi8w8P6u0zCP4oNw1trdUllpYF3fbyjE+uAg1hL8Bs31kJKn/c+O83ArngqDbkKVrPXGkEVo+HFdk7pN4O9Shg5ubkYAYLDPSrJtqk3s+vd7lzbUZRPC38fnzBVdu2FP4QKvz2U+aQuHznIKhQh1FRDl6Pdzc+wVl5gmzmnrrGWbTiRhrnlPph1dQBy7oljHzkvGmf3wc/WyG7f+F0qPzrXqmS56ZgVL8BGJTQbPvwnzqS7YGgSeppiRkSXfP6rvR+bJCcn1e7SWJ+R/EuT5UcutKfoZnhxHP3E9HR+qG2ckeYPBga7HuuL2CP+HHbtftDWtjsFFI1tr0qo+aF2UnrZPTYU2C00opDWK6yX79SJc7saqZNRiIhHOnNeYFkbDrMC/wT5A5CZThR9UmfjHVg13FGf4LH+U33Q64SAHSoN8XaHW
 DhhUO8uf
 hvpkYnxMjH4GHnAlmZwi/UJ6lq0aK5DPK0GXEITANhvKfBWcY30oiIwRtn+EZRlVmtDtERE2sMZJa5pPBDBPnlwACfkEdN7HJEXHpn22Xw24NQ/25zafpDM+6HRJ4FTTX3GCQkkICCvfv2y/XmeQqZFAlrwjJ2kDpOFdHeFTqn6OVv6i2ZNN1gaiweZUUe9wzkwtgEPx0UU2IcdE47u7eykwN2dZv+qBR0ibaDb2dn9TxdP+UcLPVgQ/C+bSPTIbzZxLq7S51PQafH4LAKJTp/x9zy0rrJxm5HlciDpPV1ySkhUp47X2FdB7Nwg8tYMIC3L+lV+tGbSWrVRh9ASlwnbfWMfc/gSGBEeGijoUh9EMNf0B9qhcuTdqJqDzui/3F0ItiRgu38j9OmoKELz+GbZAeST0Mhu4Ldln/HG3rO6BoxknE6oiEe8gAcn3WQGMDi0u8CDKYQjSr0jSaaDPY1iQFGWBfw+mIYK/lPleCWMSyawU=
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
 Documentation/mm/process_addrs.rst |  6 ++++++
 mm/pgtable-generic.c               | 15 +++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index a7296f251799..b1f4f44d75eb 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -537,6 +537,12 @@ We establish basic locking rules when interacting with page tables:
 * When changing a page table entry the page table lock for that page table
   **must** be held, except if you can safely assume nobody can access the page
   tables concurrently (such as on invocation of :c:func:`!free_pgtables`).
+* Page tables may be *walked* under RCU alone, as page tables are freed only
+  after an RCU grace period has elapsed. However, any entry found must be
+  revalidated after the page table lock is taken (such as the
+  :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
+  before it is acted upon. Changing an entry requires the page table
+  lock and one of the locks that excludes teardown (mmap or VMA lock).
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


