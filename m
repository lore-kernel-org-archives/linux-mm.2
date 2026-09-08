Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA04EC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD546B0095; Tue,  8 Sep 2026 08:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD50B6B0096; Tue,  8 Sep 2026 08:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED886B0098; Tue,  8 Sep 2026 08:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98F7B6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:33:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B9931605CA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:33:54 +0000 (UTC)
X-FDA: 85190536788.19.FB1ABF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 821B14000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:33:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=llQX4MW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870832;
	b=JjJkrr6myxyZ0yJVPM89JGzbH9xnOy4s+rq8e3QlpuGi36ggEUYpOiRytVoi1k1ZSzfBNR
	nD8FBcwqS09t96FgDJ4RT4mnJLg+tVXc6u5T9C29e+y3FthCv2Pgxwv1HP/ix4AFo7ySRK
	00G1sD+RSeI4TtyWrcFnUuGgw7N238Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=llQX4MW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MMfaleDm2ce+ucIbxA7OEsrjCLcZrtuUhG+cgJq5Q4=;
	b=wzrivtyOjkCtffH7e9oWvnlhGA1gFeSFKMEvRlbZhb0sFJT4JsQBHqI64ShX9dtGjKYM+b
	O4HVrbp7pnh3PIPQZTu8+2pEATwe5jD6t4YHUP3MwK4QxL2E0q0K8ic0zZSMziCYn5tp1t
	YrNtGfaB08MLbPpiv2fuIafXh+IbVAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01B83601DB;
	Tue,  8 Sep 2026 12:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E821F00A3F;
	Tue,  8 Sep 2026 12:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870831;
	bh=+MMfaleDm2ce+ucIbxA7OEsrjCLcZrtuUhG+cgJq5Q4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=llQX4MW5oCBsfa1bNRnJU4DEvCvhPnI34ch0k0V9oeZcYx+cu4YdByza/2aSoCr/G
	 CfKP5R2/194SkhjsLiDuF4q4rjsOGl5KRdxEMwR0IXQhsFfIOyBe59X4G7g8LM/dfc
	 yD0HDu8VUB8mzYeVQsTdJd8B4y8T4ec2nV110GkhlYVT3ver1LeS+kzS1s1vK8HQ7i
	 4s4fqrS7vIzDShvOFV+AdxVL+6R/SgQtPPZla750Bv5wgpnWFIWUQ85x5zEui6gtNH
	 f+OEXJBeMwjnPby8KeTTneiAnFyOfMUP8dx9E7U0Q3GWJOHAXQDVVBIovssZ0RTYcT
	 7IV4kIHKxD9cQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:12 +0100
Subject: [PATCH v2 03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU
 riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-3-1f60b64e878e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1550; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mgr1uJE8DIP+D2hAcn/4VQ8oaO28pfdyIohSciDSfkU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMETbXblq+9Ih1fKpoW6rqWr7Fish54Yr7Y/+bb81/
 9D7DD6FjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzE9B7DX6EdDA/kVnP83WYW
 d265mtIhyUU/Z/HO55j4ucyQ+eneN2aMDFNOXFunsOPssb3qfSlrPCwO3U+8JzlN3On28eWhk+y
 WhbEAAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 821B14000D
X-Stat-Signature: 6c5cte9jic499pwk5s7awen7p3u6peeo
X-HE-Tag: 1788870832-480576
X-HE-Meta: U2FsdGVkX18aqXs9IZAeIGErr/F51/xf6KSozXY87ePqfeBBXc8/TArcTi2f6/B10ig8BmGkWMlDWOzMbjeUbpq5JX7bHpnZ1k5bnklImTHEsPIxkkTFXZqiDDjr8W9Bx7RrBcOi8+r3PFcXeHmBybJNEGmI8A4dU+IKZXe4Cc0CEjD6bSQnZKCVegkGlW75m8mEP3NddEMXZArpuqeHO0CAcjKrgkrn5EFHbVEmzZsz7LUl4uYm5IsgrLL1Wq8XVbm+SgvAKxzZ2GdBjRRKNP8l5FVHU/NTXZBS8Ru9lebYOx0WdfUNlOzWLvzmNp92fxHp7lhhRbpFWjxY6eR8XrAuPBf14lZq1ovVLOjHifuBStjoo+WAq6qDg4B7Ovhk3F7ke04wTX5uIXmy07aWlfJ1HrnjeKHkZFY304xvKr1D0LzZezA1W+VD/1vxFh2TVcTpvo36yZRlaIO9ysYaP+Pzz6Nj9uOfNK7wDHCCzs0xSHwH37U8njsjUnKKX8wgAx7Nmo8u90+aULSK5l+HlNlvNaYaP/UIEt3zRLdr4sI6KMSNk0sbvYLxaRtdf58uIoUurf5QY7KQ3e3gWdnYM4z8bRKJnQYNHt6k1RQpOrBsUEy8kQS+KhZZVdQkHPAOFjT5YpJkDzKIppJ8m2KKIGaqc1IUP5y8lqQKG6dlQfKOq1pVn8PAJXgaI13g0MG0SoqW5Z4e8JC5b/8tegF/g4QbgM2xnlHKisAkW7HJwdFMKrxN9vLvtFwmRWZwWjOExaQDg08kU6UN7+F+SXBLvPcf+kzyfNNEvoEQc9iiqwtvdGPGGTlFVl2kAhbsOgbUPWooFEC7UzI61LA2Cz1TR7u8wid/GJ0/8dEKz5avPY6QaPQQQhLbGNJtael7wAaI0lM3BFljw9Mbnt99rQtNcRTMUrGwPom5yPNPCCPDrCgTZ5bNWWz/5dl5/omifNAHNqA5ksw0ZkAtmmqdh1c
 5ShcEhyy
 VOl044nrcbF0IKoQsZsMVEoqa/FsgFWvKqhVM//ziJvgzMatrye3ETkZzSNW4sq+I0mDhaea2JIMiRvkUmUsNCQGk5iO06wF7Kcb2t2CKbpwgauRP0RzNPXTCNPF3GcbDVkA9OIRArS3rlbp9HKSI+MuEYuCDjDM+7Eq/llzornQRP6K8seAsW8dTLNxXpnelDIK1Lefnq8JUT6tiWXsO/AMd0xxpdx+cZVbxjYChPDbZpplundiDIcyNjp+CrwFH0MFWp33h6mZbGdaZzewVgyReW1pNYK9a93AGPt5Fa93U2emoUHByv6LZW0Aa2jz5x/BoAonTTv7WrxvIWowfChf2vGCpHe1IocP7jlIpFJsMKC5RFqFht/17wS4qrNvcuG4vRlk4dUqGYMHcKkFcG5ETpW3WUPq7w74YlStmNJXJDTOM2Sglteol7dRilB1uzsNmjP0wLNwzrpmwDdQQLGt+qOON37LpQHZAk7Um8O6NCko=
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


