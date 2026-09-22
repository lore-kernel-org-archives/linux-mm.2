Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D907CC98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A916B00A4; Tue, 22 Sep 2026 11:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032956B00A5; Tue, 22 Sep 2026 11:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B2B6B00A6; Tue, 22 Sep 2026 11:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C322A6B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:37:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4DE8EA0520
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:37:45 +0000 (UTC)
X-FDA: 85241803290.26.29AC733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 92070C0008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:37:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNlcNUEG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWYqXXcVhqhum5QoL45NNyuXa4EfpjGCy/961eqdzvI=;
	b=I9XvRPZOrgav/DJGyex0ZAwA7Qlkmwsa5mM7LK9H+OuTHMvR5XRG09y5fPURAkYMr1bzVi
	J1fVfWPc7decS616nbLuvv0gmxgL2ryaFXjMTigM3guLVMdhja2WH1KEpmZevfRFCHg6KQ
	XVwj9ONKSyIdCGPRpjdZRbdvMYO18Ao=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNlcNUEG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091463;
	b=untMwqrEoTLw2/U9wlQWtEBDTFteePTI1+FA/nJF7WeLmUbGFP06vYmqIWtk/8aIB7eib4
	bfdHmq3/ykB4m4WUJ7DDMKDWumi/Gfho1M+6LJAWlqcjFG746Pj0FveMmJ/mVAowrVEYXE
	xef0zyqCf+Dn7TsTnm5b4FcafJDAQAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AE2E60E25;
	Tue, 22 Sep 2026 15:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA911F000FF;
	Tue, 22 Sep 2026 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091462;
	bh=dWYqXXcVhqhum5QoL45NNyuXa4EfpjGCy/961eqdzvI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UNlcNUEGwtkyvsYR4zmSeGCvMkPLe+/ezusdX20O1bWYskX7cvdvIJuhhjuVtChmb
	 L5+b54M4DXoNchVsv0nJ54pnhIsdEfA5oI47YpiDtjUztTpT4qzogzlKrUnLoaDon0
	 Hi/50oU8SeABFn/+BsGw1RL0cXsZ9uni0c7ibjurbKnftlBLuqaA2M5V5zWFn9PE1b
	 n2j5Mady9bfFc8fKJ22XaOT4EwjJPIZOiQbv+8Od9Wmuwkvc0lPJh+Kjy/qRzctIDv
	 BhT9VIJmX/JVBTgDo4khmxS4qLbtj4ncYW3ywiP/LSPDFHak7FA0nynQk8qUTpmRo7
	 4FhJkMkThxUjw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:34 +0100
Subject: [PATCH v4 03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU
 riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-3-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1601; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ejk+F/Wux5yTvQzPF878nAZnzdraz7QYUlz/y227QJE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2LchuC1lS+yl/saWZ4KXsS/+f/mMRKmHc9UBbod6B2
 YU98CxHRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYiP5Phv+8ioR33clR2yb5m
 l1T66KMtEtO5qfBsf+mk6EU66XL/njAy7OdZ56cxmWV7qvxM/cnbUvUPnrh05fThTHmL9/6/nNY
 oMgEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: frybiforbdqqu76krwpybfk7wcbfqfuz
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92070C0008
X-HE-Tag: 1790091463-232051
X-HE-Meta: U2FsdGVkX18N6tktemXnO75ENr1SPuSPMWye5xhJKGhdixYP0TAQrgDZa76PWExMX7zdZdxgSyGmQCfC2pUY+4hFy7c8g/HP6IZjcHLzqIJFIdSR4OrJjwMnhir6NocVDkda6k3mdSX8BPBzI9wbaeB2Yf+6xIkzmfokvzByApNFTmmG5FG/yHV7P3vQ84x7oX/mGxehbTMRITdy68UjAoCbL4XqNQ3kAG/iPC7HL4CWTTKF7ff3DLDMkha1+kuNzy2puXEqzkF5UmKI1xGQQV5BAnxABDeUDo1qJb5VLbmwlY0ZPdxhi5dTS2I6w0nYy0LS8xx3AjvF17OfUd0Xs9vUz16FRzqNRJPYFzfYmbo8wjk/44xLzPXZEN4hq8XeyH/Zs4VSdR7V66tLqLFfMxbAtex3huJYPBSZPUjEaS3nOmYsSnE3taBI5UNZiOcYfMrYXjnH09aZdUlmXM3Emn4IMzzNLQMPozUR7vPFRbs0h2amSEi9OFsh0iffviZ7dD0y9/rFh31wK6NaO6gf1DXYxyhJu1zNdec5F6MfsXpAD0gwqlvTKs3rIXC2Fhw7263Abp5uQBmOew+o4Nj1zs4yYWuMWekZDLodbUpQley2AX6M6T8+xqMuAJg/9KBd/u/M0X/J0aHwtqYzM1JkZlTUYzeLdz3VXmriqEAvWNFRA/dTANVoKtsrJGTVxp5Df+chJS8sb8oOJ5g1rrCZ59C9gCtbdsmNIrTV787f16jyhyJFrYZkK6L4UVWp+UWcpTcFueTdUItV/DMLAThBFjxzVOPiALeKjC57MCii4C9A4JFPr+USgTKNPWyRFg2Qxzv3BIny+9nfPNNS78bf4gwwaCXdB4ETeACbsgRTvOYYfqX+gSE6e8sbprmwwy111T/ODfnwxk2aTZNJFv+2ME87YTO1rYMT+85XwAp6+8xuJJp8UVuwx7N7Jpuux/VUOToojXV0xudU2haLPUh
 Aq+WHwLu
 DX61uLL5uEtwSrPQ+yCG7wqPY/v+s9LyLfWTv7tum5LiBRabedg9hBcyXSN7wbtoFMIa5yNuBW1y3Z1xIQHvmCQXUdY9dt+Y1G116x1ulIA2JcEl4mEKteXcTnx4A+etaaq2TApwcxSQeiKEneDfDPtiGi4uMUTX4fOASyvEXC9OIQTRUucmUB+B+an3/dMfJgEx1x5SRPG/wqG8LLpNV4JkA0Vb+LvxC2m6dpA1C0iovS9O2MaqTYOee67NH2AN7RqnUEJyMb+uPhOjHnnqAFA9DVjWOjHg/kATg8tlb+5zEfDBV5kBrmxBFEgHovTkSPjPqixEZTr1VklJi+MI0PjIIwVOrpbWE+XJ+8x1LQ0woqqxZ1V50yDjdu6ejxQlxXzp0fKYX+Fa8dF2oWHLjXou7Lkd6/Y/FmSoM1E0tbiIipc4L0Cwz80hkSG0f+8cG2bmcnrQT2/NsQwyWfU2iljgBzTnOG0EOPPo+dWcgGwtUoYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently riscv gates MMU_GATHER_RCU_TABLE_FREE on CONFIG_SMP and
CONFIG_MMU.

Commit 69be3fb111e7 ("riscv: enable MMU_GATHER_RCU_TABLE_FREE for SMP &&
MMU") enabled CONFIG_MMU_GATHER_RCU_TABLE_FREE for CONFIG_SMP, CONFIG_MMU
riscv builds.

This is expressly for the safety of GUP-fast walkers (CONFIG_HAVE_GUP_FAST
is enabled if CONFIG_MMU is enabled).

Naturally a single core system does not encounter issues with software page
table walkers being correctly synchronised across cores, as there is only a
single core.

However, CONFIG_PREEMPT_RCU is still available on a riscv UP system, so for
a future RCU-only page table walker, this guarantee is required to prevent
concurrent page table teardown.

All page table freeing is already done via tlb_remove_ptdesc() so the
conditions of CONFIG_MMU_GATHER_RCU_TABLE_FREE are already met.

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 505eed4af932..3529ed1861ce 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -208,7 +208,7 @@ config RISCV
 	select IRQ_FORCED_THREADING
 	select KASAN_VMALLOC if KASAN
 	select LOCK_MM_AND_FIND_VMA
-	select MMU_GATHER_RCU_TABLE_FREE if SMP && MMU
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_RELA if MODULES
 	select OF
 	select OF_EARLY_FLATTREE

-- 
2.55.0


