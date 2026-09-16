Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D023BC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1050A6B0092; Tue, 15 Sep 2026 22:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B72A6B0093; Tue, 15 Sep 2026 22:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE75F6B0095; Tue, 15 Sep 2026 22:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B60BF6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:01:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADC021C292A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:01:37 +0000 (UTC)
X-FDA: 85217973834.06.FDF77BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E3EEB4000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:01:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HA4IrxR+;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789524096;
	b=IN/ebRBRXoyCseGIRXvFUOSvAVuK/wOxjEIBaRWhOGMt54Q14vXNZ1gc/MKBNSo3XeOp1A
	+/9dzNZY0dW3BSkjPHehaLoMmeCdLGQeJytgH4uTxX8qT5pZT+/Eyoowurs4AozEI7ISnp
	I3UQU1iivqPXxxTm2sUU1g7EnNG/x6k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HA4IrxR+;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789524096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kq4nX0CZWZvbBl1ewxdrR8njTtxJd2HKKhLZ4yZoin4=;
	b=naoBSRCiwplODOr0O16dPB+OMfveyWRvhroZDrvNUT88wsrKIeLkmSvKnbKTpkwlLemHaz
	OPk7tMdyRjdr0LinV07XFsUbEjLEOnQOsSRJbAMlnbz6cRUsHQyfDfRoR800+RvG2Ksr/g
	htw0pRx5VRP39VEBaeI03Xqa/3EQvms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDE3560214;
	Wed, 16 Sep 2026 02:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E999D1F00893;
	Wed, 16 Sep 2026 02:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789524094;
	bh=Kq4nX0CZWZvbBl1ewxdrR8njTtxJd2HKKhLZ4yZoin4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HA4IrxR+bH6KFYi5TWsVFFRj5NN/KsmXWn+L2rcKXslNm+h4O1+C0Mz1TX/mnbSd5
	 wNlo1vs7L/RwOu/p4JC+a32HO1/edlho+RmyG7M/c8w2xQw4dUW63KjVSNntMUP6xo
	 zHIhd6HWzSLYzzfxhv0JalmDYIqgVcBuZA1Pa2/U=
Date: Tue, 15 Sep 2026 19:01:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren
 <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster
 <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne
 <shorne@gmail.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich
 Felker <dalias@libc.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre
 Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, Vineet Gupta
 <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel
 <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, Will Deacon
 <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick
 Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland
 <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Helge
 Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org,
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng
 <qi.zheng@linux.dev>
Subject: Re: [PATCH v3 00/12] mm: make userland page table freeing RCU-safe
Message-Id: <20260915190131.adee185f2ce04a8ec821489c@linux-foundation.org>
In-Reply-To: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
References: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E3EEB4000A
X-Rspam-User: 
X-Stat-Signature: wd93kmnap8dcfw8kmshhux5ifpo9ccpm
X-HE-Tag: 1789524095-495377
X-HE-Meta: U2FsdGVkX19fYuJmZ9P+2hstZR8PIIg+fTyOllFKbkFonK4f4SlofD+Iy9O32Z4YT1crXGIsrjh4trQwkfa/+zFXuTIJLkDKWb3XeaQyo6bN3JbQCfcPAdEtsMG7mRWO0lrAyBjjatBIBCjAsdV8kM3NgwSegZ5udVfZh8gyiCZfHjhlw0+JdGd8myfnkpsOncxPMZFSqBwVXxFYkrl5J36BlxqQCpq9RdvBvZ7GBa7zjZaBldAVzukoH7bn/auZsrNOkep6PTfdsNVHzfHmWMJnuzOLhT56ZF/n1lBW8Qc7dfQtUeUwpr1gfNekNSXmx5yKwZk/w42MsUEtkbRZHOs4k+CdBpbJ2SfJv56Ipo+Rli8ymm+59SIiYINr7K0Yq4oiQdjBoxZwKQuVY4g0wpfqYaTdHZRJrdOWRYlpUlaJZmOQtJL8jZLxlQaA3i9bwfQlJZCg7iUuCZ+KOsU8GBzNxHJ8i+FVqqt1Ki9xkM2D5fsnqXv8zzzetDEkSqg+ufB1vfN4k+JftDYs/W/S/Z6X6dhrQZ8SslJgUKqH+zSZVgM7Rdx++GWbA035TWFgEsw1lN/zHExEHkxgLI5yuraMyv0gKIe8McIIZVe9h9WFbrao/yFqXxzA3JDJHJCJiIcYxkS95acjIVRwVMmztQQwxCQZLgfWof9DcMvC907zf/3RerCfi1j2B0tdTqDcGeDpnhoGmd9DQMG2Jm0GDnRTaHnkt8jKNzCqROJU/fqH6r+bMVL3DWvpofH8TwL0+GknO1DCU+rl86ZeHoCle6zboF6BmC2dJmT4YMgqFqF2btDVMARpOr+o9Dt1dVpF9yH5ia2GRrTeF1LG4BTpRYvuRiR7eWTU2tnM1Z03Pl2cLxVfdEg+OmsobcWa42hGabZOJTQ/yZ+PGKcXU42AC+Zrm/x8+RdeQqaQdrg2a0orvwYgFsBd0jEwL+u4H/Uz7QWwosTQfP+bsamqdJT
 eAdVfEdR
 LfXx5+THod8lXitLhK9XoDvMd8M+t1VW6zYWCRrH5r7VPYOE45E4omX8vdAJniflis9eLfqGkF7HqISudaIwri+F1RP2X3mzu4JfzCnI+NN8qZ03f8FHrKEHwvlwjeEhkAfytL2r5LNP7+TGc658jGECI0GZQI5Ha6fn+JZ16wI2z2xKW4qzwOVYFCc8nZI5XkgxRgxPPR/PnfR3tgIp2ByB40tSilYxWR5ge9Qp+s2gwIJ7QG6ZsHh4TMapY0YhpWXzAS7aNnwT0mQTqPpDGI8otjcSBgBfUbfzw30sFYdl/bRC+PID+Wj3Xo+VdGVljfeIqiZSOQGTZbgQVg8wd5YwdKar/rsrrycaC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 20:36:47 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The majority of architectures in the kernel defer page table freeing until
> an RCU grace period has elapsed, this series converts all remaining
> architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> altogether.

Thanks, I've updated mm.git's mm-unstable branch to this version.

> v3:
> * Added Kiryl's tag to series (thanks! :)
> * Corrected commit message, comment indentation in 11/12 as per Kiryl.
> * Corrected 12/12 documentation as per Kiryl.

Here's how v3 altered mm.git:


 Documentation/mm/process_addrs.rst |    4 ++--
 include/asm-generic/tlb.h          |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/mm/process_addrs.rst~b
+++ a/Documentation/mm/process_addrs.rst
@@ -541,8 +541,8 @@ We establish basic locking rules when in
   after an RCU grace period has elapsed. However, any entry found must be
   revalidated after the page table lock is taken (such as the
   :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
-  before it is acted upon. Changing an entry always requires the page table
-  lock.
+  before it is acted upon. Changing an entry requires the page table
+  lock and one of the locks that excludes teardown (mmap or VMA lock).
 * Reads from and writes to page table entries must be *appropriately*
   atomic. See the section on atomicity below for details.
 * Populating previously empty entries requires that the mmap or VMA locks are
--- a/include/asm-generic/tlb.h~b
+++ a/include/asm-generic/tlb.h
@@ -151,8 +151,8 @@
  *  Page directories (__p*_free_tlb()) are always freed via tlb_remove_table(),
  *  after an RCU grace period (see mm/mmu_gather.c).
  *
- * This serialises against software page-table walkers, including architectures
- * which do not use IPIs for remote TLB invalidates.
+ *  This serialises against software page-table walkers, including architectures
+ *  which do not use IPIs for remote TLB invalidates.
  *
  *  An architecture is expected to provide __tlb_remove_table() (see
  *  HAVE_ARCH_TLB_REMOVE_TABLE) or use the generic __tlb_remove_table(), which
_


