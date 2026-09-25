Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D0DBC9832C
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DF56B0096; Fri, 25 Sep 2026 16:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91EDF6B0098; Fri, 25 Sep 2026 16:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835046B0099; Fri, 25 Sep 2026 16:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59D3C6B0096
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:11:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1A6FA0786
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:11:32 +0000 (UTC)
X-FDA: 85253379624.30.728B3CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18223180002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:11:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FacUV9BP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpjNlRPwIAtS3js/JnPceE3s8JjHMWfCJIUHwD2Ubsc=;
	b=CNjKuWkmQDEkw2n/EhITX/CMrZw2YGqZa9wz93KkRA1Rnp3TkcsEHzIf6k6fKej23+hC3F
	0w2MzCDQH1xixqwps3gIYBBpklTWx5kHywFTqYlRtNNVYul7buq4/gvSSVu42zdi2ibz8l
	+fR/y2AxGigtdIbESi3IuH6FaleYrbQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FacUV9BP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367091;
	b=zffU+m2xEKITg0ybD7bxpfFRjs8+m9TQy+maN4Ms/+ZxAZrkFIBcdMTwsveu5segOZ1BHK
	9NTZRGiqUPpWPmL6d4ZTPm9g3H3siz/S7q0uX6lvO88rcRqTbDfTp1mJQil4h8su96dQb0
	hsa5SdO/SxasCdjohGdJdhUKyio0Qrs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E8F1416EA;
	Fri, 25 Sep 2026 20:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBA81F00893;
	Fri, 25 Sep 2026 20:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367090;
	bh=cpjNlRPwIAtS3js/JnPceE3s8JjHMWfCJIUHwD2Ubsc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FacUV9BPJqMfJRC1NC0NOpYVhoUwXKKvZuvM9c7plwDh75qmBgWTzXYvqfVUSgrnN
	 Lv61A7S8oga+lX0oaCcJo3Pzi4qyy2M6f3IdRcVaOZfBBWgYfdCtFSEX+vEtdES6TA
	 YcwMGXq+8BhhRTtKm+nGmOhqMzwP5gQnfhbk6rVGlTTl7I8Fm9Uk2PmHfBrnunJO7I
	 eaMwzL/N3AFZ7OBnh6gWg2mmTdTyCyf4muITET7WiCPBcUqqKRYsDah/GnM6ZN7dXp
	 VyVTqU1JxRrAo+bEfmwy5rR2U0DtrKqO28avZ0yPOlaT2RYQXU9w+ri/JnlIzx5ttH
	 NaK3uZ2E3jqrQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:39 +0100
Subject: [PATCH v5 04/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-4-31e91065fea4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2074; i=ljs@kernel.org;
 h=from:subject:message-id; bh=O/BF68fbkrxSP0Au3u7quwRgdMj7VVK1pUJRmhryr40=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XWWbo3QuRJXr+pUS93VLpgb212iEnymcoap4v+g6a
 /6qk5l3OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRJzcZ/hdoTJFPe3Pw1eeP
 cXMe3/RVtJv0xfitQOHEErlrfVvcJNoZ/jtMurN/3TuXC6dU9l3/lO9mOGObyTlttTP1n6+c1m5
 38+QFAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: nrybrmzbbpics713z7gu3tk119s45y68
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18223180002
X-HE-Tag: 1790367090-181107
X-HE-Meta: U2FsdGVkX1+YGvSlIHdcm20JnqKmXnLJ6aaumgZMU1IjHjaE0FRzcrajvESfY9CSTK1GK+8rB+WYJ9zEkjlZ29slsBM7MVQAUAEXY7RPLo9raPnquVff69oqY45JdeNnhKz2ULtzRCAWM7bg9GvK598OP0grBgQVN25TIOBTPL1zJGj2jJLVZNQ9ferPoETvd5DGCy6yE0ghBYX/eBLU066Q8TI3ZmuedhppJXBBD0zW3doxO+CNlZmSCH/lB063WZ9ZMqdVU4R8dLmP7Q9FtGJL7yQgIZmqb/FKXZZWZ6gSsajtVWwRCHnZojH+AXxAksD5Eq/JCNzZVsvD45WqJ6wg/8X/beayuCzYqd87LAJv1bcYenP8+gRSy6M1pJBp6Uwhfi3o47ogFMblcNkYSpd1ZcCCp6ntAONsea30mireCU8n48zo9vRBy3RWSPu9AfB0QkGfF0PH427HWrsHC+DDWF/o7M6MLs+0N2v4uAnVFLWTwugVC6OSNjkvFSLgDMs0puqjn6/qH7dk335tKmGYHeclMsluym8Xvp38+y1MojQYO4O71LdQfIjV3/LYWHv/DfSHYEMy6n57B4yQjkepREY+vPBrfltnAquzLsxkQcZ1xQ5s7OzoyxD0XkaZmhQr9ohj/L//Rw/1fRbP9TnJsR0aL8ZKww61sJdHAPh3mj1JLQTpvDJaDLTVtRaEkbgY8UwuaNE9wwkbVV6IHNQG1CsYbCKpF2pQ90MMEOjhVIv7cwljULpY0l6oTKtTVA3VoK/K721SJ27iOu3rJzzOkisYAY0ziAMhGYZLV49LqGnlnLWxibhxV9wQmM1iz7tTU9HJrQe+upWtzdgO7cZYD4zPc5lJ139QZGJx7Bkki2BOMIRgwkj83vwidWZDbyRevGEWWEkoIz79mQKn5gngUKf+J7pSJbLpMysoUdEMQlUdB9CQZygOXeL7I4IjytrrmJXqSBHf0IjWxt2
 qLoMvN85
 4G82aN/conc4M1Cc9evNvZa/GnRvXPJJiOEbcq+YIzQ+DMt9c4LYs0+TpCoAfsd3+i2MRni0TASD/Usz0PCV7beCEyA+cRyuygiUUBT+cJ2x+tIy4Xh+Oe4mw/96iGkGPeGtrL4GnPpf2WgtqsywetyeU+jkMY1fKns7nBtX+Oa12rW2qgTkpBvVwYlPtML6c9uy+MbtzplW19MYzY/AqgQ4eM/jMewb5HaCAFi1qZfz/bQjFevQ9ltQWws8IbbX+NUWkqZFjM6GWFVVxbkMYXgy8zM+bI75dc++YKA8PXY3eU7nPQOzd2IKwONdbDiYAEX2aELY7Y8/MQH4CIQDZQfjUFJ/tWBulu/nOMviOMA88D8mj8DdtYMUudLa3PuwDLMJfZjOlgW/lPzsTBuSpy7i7Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a0ad5496b2b3 ("arm: mm: enable HAVE_RCU_TABLE_FREE logic") enabled
CONFIG_MMU_GATHER_RCU_TABLE_FREE (then named HAVE_RCU_TABLE_FREE) for SMP
arm architectures with LPAE enabled.

Regardless of whether CONFIG_ARM_LPAE is enabled or not, the same page
table freeing functions __pte_free_tlb() and __pmd_free_tlb() are used.

Non-LPAE PMD page tables are folded into the PGD and freed by
pgd_free() (PGD freeing is not part of mmu_gather page table freeing in any
case), so this is a noop in this case.

Since commit 358d1c39c82a ("arm: convert various functions to use ptdescs")
both LPAE and non-LPAE PTE page table freeing uses tlb_remove_ptdesc().

Thus all page table freeing is performed under RCU with
CONFIG_MMU_GATHER_RCU_TABLE_FREE enabled for LPAE and non-LPAE and thus it
need not be gated on LPAE.

A UP arm system can set CONFIG_PREEMPT_RCU, so a future pure RCU page
table walker requires MMU_GATHER_RCU_TABLE_FREE to be enabled on UP as
well, even if concurrent GUP fast is not possible there.

Therefore, it is both safe and desirable to set
CONFIG_MMU_GATHER_RCU_TABLE_FREE for all MMU arm architectures (nommu does
not perform mmu_gather operations).

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 408aa58a2a5b..72b9afc6ae10 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -134,7 +134,7 @@ config ARM
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
-	select MMU_GATHER_RCU_TABLE_FREE if SMP && ARM_LPAE
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RSEQ
 	select HAVE_RUST if CPU_LITTLE_ENDIAN && CPU_32v7 && !KASAN

-- 
2.55.0


