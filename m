Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31399C88E59
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415FC6B0098; Fri, 11 Sep 2026 15:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6956B0099; Fri, 11 Sep 2026 15:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBA66B009B; Fri, 11 Sep 2026 15:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 045DD6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:39:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9480EA48B0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:39:00 +0000 (UTC)
X-FDA: 85202494440.24.94C4FD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E1D6B100009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:38:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wp7RN6M0;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155538;
	b=FIX7UOdsrnAtixaPxoAqh+A+2/q0m4NfGI4gkTZ68VdgJ3VICfiPxp7lSjM05vx8T1D1PS
	lCvt9SxUl1jiVfSLbEOtSpTdu0Q5HUusVJsa789J2xJ+Pp5Vrxi9i9gpbXiP9XTNvVTc+2
	KRHWX2WDuTPGyMNUDPdIuY5twsOppvQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wp7RN6M0;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWYqXXcVhqhum5QoL45NNyuXa4EfpjGCy/961eqdzvI=;
	b=7XT/h0zviO8rF5p1Jk4VdC+0Zga5wGlNm5pKsWFyGCocbdPw5Um+AuQ0C6Bgr2SdFcvrFp
	2bHqORT21S3mUwfPnkzEAdOJMgGk1HHDF5Q6bHv5rGgtS9XD0yD9bE4Ns5MZPC1rKrfCeJ
	GANlsr+pLpTt6L7vb4Ewp0h354xq06s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8237560008;
	Fri, 11 Sep 2026 19:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5FC1F00893;
	Fri, 11 Sep 2026 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155538;
	bh=dWYqXXcVhqhum5QoL45NNyuXa4EfpjGCy/961eqdzvI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Wp7RN6M0L86FeGpHvZcllj3vCIokf70FAQlmFb0my2TRWM0GhqqE6bZudKHCpCts0
	 5IpQHrKGnnWG+bIkcDmlhu5o/JmejMP+vlO9qxLub0WI2aj33y/PXCJPrlfzzfaxgG
	 wfRru/PZcDX0l+7ekjnU6l1mcPGVvMJ3mpbSQEgXseD9oWYK2HpnfidgjFf2FEnhUo
	 0d8m2F+SGkk1LtOVbi5bZS0uY/wJ9sUmdKZv/QDSEHHuEP8F2v6wnYIaJdzOnH1AwW
	 dXmazlu/e2Xtt/OtHX6TXnZmlwb6uGk3SvGj94GArHUevOjHDzBVbZ5E1AIBL8JCkG
	 O/bo7EuxjGmZQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 11 Sep 2026 20:36:50 +0100
Subject: [PATCH v3 03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU
 riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-rcu-pagetable-freeing-v3-3-7b8c86103821@kernel.org>
References: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
In-Reply-To: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1601; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ejk+F/Wux5yTvQzPF878nAZnzdraz7QYUlz/y227QJE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWRDQKqWW/WBRsHdFlr34u/0fhUyOJ1CeVl/kXd37xF
 rtp8OpURykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYiKMbw33PDqT2t9smPwr2+
 fZN8x6M9uaJfqklmR1VSWuBq1ukKixj+6Zr+mF/rtsZF4KVQqofE5sKjjVceMvlwNHzdO7fXPke
 EHQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E1D6B100009
X-Stat-Signature: xuss7f8sw6gi965sny914ggdzo4j987h
X-HE-Tag: 1789155538-981115
X-HE-Meta: U2FsdGVkX19teCBfLRWUErax3kuUF1rk5M4Qsb74Ufepm1esq+7JbQifv9jYvGDnTKIj5j35SaEHbgRqtG+HasRvoBsMJKaY4KxbpKN4x3S+gDNOjMxz74NI03NrFR2GZPWhsqv4JShD2tE/m297Mts9PyRpPIlyvOBkxdlgPVScOnw5vpEQGw6ZKpDG/BCkNdBs73iy2Hyhv0V4nlQ72nd9IssgsxHgTqLvpwPjoreaoZeI/zwOHQurJ4j4PLkhSCRO/C+DhbZLNtVe7ouxG/7ReK5/XGXwBaFsDiwhs53mvQsJ4shBe0o3J5nhPPpBn7P+Qw7wUGbufvQu42Ul/DZv7Nn2vjsZMcvtTmmQLsKkfvBqxCVGkDFLz7HHjosJSUDJX81zGD756Nj33fcauZ/JZn1lZxTGG+eP3N2ZEh3ot1+83evfI72XnHknL8j4E27UbXXYgRdzoNhkouofSOgvNBP6e7OEXUhfC9vW1ANexTgKdrLyaztTTSsFS6+hjikdCkdsehf5VfazlaRgD3jT9eyql77f3MX8uetuNYDMeXzD2lw67x6x6FMRxlb1LdpB+Oa8kLf2sryepl5nZGPbLj0ZzCU2L6LrQ20SEgwODEwFS2ZecU+gWrzgz+Ij6U0rT7p50QVcc3d1/hXfGzpChGZIjHkQGgTqcLzU/4TpeOwfSQCst/ZR7pJe9lZrgNtNSog83E6OnBvStJcke+KpIaAPVMMm4nbjynVaJzqoEGtyZEu4aoMWOmRfPZz/oKNXQDIJLV0m8DdV/XJXR/CG7n/A/ahhMAfGmkTgg+CrMGu9BjhaKiPpmRpvW+vKABv994hLerMwxVPMmTjwEDHWIWVKy9cv0SNKpUlS7AKcTrEa1uY8ndq7HQDbX8zUjwyBw4UtFIaDr7rqBQnW+u7XWZzxq+nQRKow0XvBqWHHETGPUmWqDN5eaDOwvqFHvPhcATOAFyJUU3gLo+m
 bZbYREkN
 CB7TKIQxUKXPwXkqLso9l6BDWhVJIhElGZn1uJc07IguZir/GKpfMvjOpOYi3DQFewf8hN1SBcHraWOKpxKku4I5GYS/nBIn+5iSaZyTOHvMo7WFAc7Fh5SvvuUzFFlIGg2vsvXIBy1RC9b+fQfFTtghdKm5axz8AvazZd49iU5xs+tWVu21wkmbcDYHWiNmOI8zAI5Um6pN9dBwIcfBJF7aEy1OTu4w1/JHDCq1OHkLKnUodEORDIOFRuSU6G9PUl8hVcYL+ETmYNtpJYx/AKhxbIQMKISuSAfROzJjF0JYM8jZBnMK+a7TODTJvAzU7/L96VbpRjBCNAjhHLiqaHUBxmLTdYbuVUG7Et+P068G6jBQ=
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


