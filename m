Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A453C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6721C6B00A6; Tue,  8 Sep 2026 08:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A286B00A7; Tue,  8 Sep 2026 08:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FEB6B00A9; Tue,  8 Sep 2026 08:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28FF36B00A6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:37:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD7D61C27E4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:36:59 +0000 (UTC)
X-FDA: 85190544558.11.A7D41BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06603100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:36:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+e1gF9H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871018;
	b=e4IzhQyosVZkCF+pMAH0gIDbVXdYaGBTlmWqBZYwnvMKFDNBwf9iucuI8ftwi61zYhJ6vf
	ct6BR8w3xZX94mtagGAmMxEMyVelnxQ5AG3sG3IBxt7hI4Rb9aLRg97wp4gUe2YM32E7Qj
	fje/YSubHVLs9YslxWWKRqwH4CMtj3U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+e1gF9H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CROMFVbCukyMBi3KsqVLGHf8AAALUePfF8l3vUCFXhE=;
	b=Q1+7gpo6Ib8nrOjbtdRL3Wx02oY/f0WmTiW53jNdoeG8xd0qjnCnFOHDYjv0i58TJJghxQ
	DC/ZrTu7UdsWy8AnLNhB5NAT6cujlF6dPFBFXeWY6THnlMXOp3rzbH2s9wWi8pYHLbk5Jx
	ZziyCMiStfzMGU9Z7FhhOmcDuiCknTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97EE4601F6;
	Tue,  8 Sep 2026 12:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B341F00A3A;
	Tue,  8 Sep 2026 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788871017;
	bh=CROMFVbCukyMBi3KsqVLGHf8AAALUePfF8l3vUCFXhE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m+e1gF9HAH60Vx1qwxMPowlrU6eO2azVERbApHj9g19Jub9o1b7t062ouaLe+afPM
	 Pdpz4mTfhvIL6ad9/ZbcEZa1dwcpR87PdVabIS2tKSCkF5a0TjwVBSS4d27bobKBog
	 58GgGbptltPuCClSQg/AH8Z3XN9kKi4dQbnmnRd95VmwpdTCkHuWJhGfGKqe/i/Q5L
	 AJA5urYfLM6QaO1Uqs0BMxOI7yfZ3eilA2ektqZGKdrwL5wGWFm++sZLa5Pjkngzj0
	 GPO21vSo38ptKCVdCHFOLCr2Y7aSnhpyq0PHDCd7vf6hJ32M5dclf0J0scZLQjSSbg
	 eMlmrLVvYoejQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:21 +0100
Subject: [PATCH v2 12/12] mm: change the contract for free_pgtables(),
 update docs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-12-1f60b64e878e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3183; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Z3Spp3yZf9MDP8GI9lcTMaFp7We7mSk3CHVti4eQ8Kk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMMR8PCxbzHxp/Yz1uQGnaswntkhbX2KLqyh2mjovm
 qNat1ino5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPxvMbwT/XufKusteKnNrtN
 sON7/H0yywOjjd/4r2xj0Qt5o76Y/z3D/+JLmldsiq8UVM993a39V05NdEGx2I24otIKkTsVeV0
 nuQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 06603100002
X-Stat-Signature: 79wnusp3mkh3amuiasqe34i3766umkbb
X-HE-Tag: 1788871017-231924
X-HE-Meta: U2FsdGVkX19cAzok2nCL+yj4LiXkWzlWbr7zfiGBqSXUYk9F4ssPSiIlMDJq0UkqcecVl3mG4ISZ9uBSlXrltQtkCK3XJkPAwVcdgO2lQ0M/Tbs9L8fy43me0gJIjDltUpEMb57+1DYrX1VoZ7cLaperyrZmJX8+Q1ACZqG1ruOE8MRXy1UTm9MMOwdcSw4DWSQK9w1V6R4LhVYvSsTLFmwRgprD0r6VnnZu6L6gDLyB7sfGSdNKzYMQf/ZQUg5tJ87iqoDdZcFeoSCheK6RhDaVzHLz/LOKgp6/W1UEe8F0vdN6fxfgXALYTNIHybkmHidaeCC6cUvDSsEIxg+5TmJdFXcY8q+umj3A2/LdrasV0RUmyoM9GSbBLHWRsR3u2W6cqtMUdBJtDPCjwb973jNfpb4CQqS2gY6T3KIZwZCviGF6mh1UeTU3uTayu2flJ+Q+f0rOxAf/H4TbQS77MXGnUARsm6Nq2ApH8475Io0t6GQnkKPpnCKSV+5LG8zEaTGwzJm5vtzisXkC8mDkFM5sNb0+3MEFDpypDfsRZJgdRaxiVYry3ipJpwXZMbGhCHxJWhd0HKU7KqhrJyf4tBC0XnDwnb3KEL3oxL9pHAWUtuRV+Qn5kv9vMzlzs9MjaFZP+HbfZdS+ih0utx4g+F8AjuyBrh1LtGAHxxll/AQwXgXfDOJqnBqYET4f6KhywPBHNnyu55nn0rcyGrILgF3ERAcDEHT9mtqc7fFe8zrNFIbJ9rx7/3I0oPxbv3591+1ZnIN2qB5vpEMueXFJ+IjM2veQEKoDbyb3DsgBT6IYF8vRgdGhewdsN+srGmo0VqjpX5Vb+dofBpsmRm9CtS4QczOvPmR6uygMMCV0bjnDFcDmV3ubLjzfYjkaGvbHJ8xdQhKtty24FXS8Mx8svK/taBsAKpKI7itDdLtiKeqkPGa+vHc/j2KLaI8FHRgqvwE6WIUCHfODJzFL51D
 +o5VdNg3
 QIf8JjIh2AylSVGAmeON+gxfh2A6ZdGqwTK0iCHxo3VIOvq4MGuXW7khrwHKsmfSvXi8+c9bCAsMV9hW+hZzJRFQ+h7aN36voE2DOdrdVObsNzr9LyUKblLxa2tNMTJNcy40dvTWzE+Y04si4WuoeK3k/ceTooHVihwbDNky0+ZjYsGWthDCfJyV88ceK0knXaYAjm4u1/is77c8dZlSRsxNCRbc+3of4UpyxWQzwzC8DdZRzO26S5SwjbAGah/sVE0IEW6yGEuuk4VR95oQCcV8vR3Viewfe/TNUx77ZvIT6UvQU8lJM24CJdUPkSXnFa61HVUoIFum70gPkFXJontShwgRvdQMl+iREO4KwTy9Q8jE=
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

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/mm/process_addrs.rst |  6 ++++++
 mm/pgtable-generic.c               | 15 +++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index a7296f251799..1e65b139f355 100644
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
+  before it is acted upon. Changing an entry always requires the page table
+  lock.
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


