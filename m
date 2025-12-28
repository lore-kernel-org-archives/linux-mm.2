Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC247D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE5A6B0092; Sun, 28 Dec 2025 07:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176406B00AC; Sun, 28 Dec 2025 07:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BCE6B00AD; Sun, 28 Dec 2025 07:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF8C06B0092
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:43:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B214113C2C0
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:43:56 +0000 (UTC)
X-FDA: 84268846872.23.69C6E12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 033CA40002
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:43:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NjUK2c0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925835; a=rsa-sha256;
	cv=none;
	b=kRuxMkA9Z1V0YN7e3/QycVfx9IA0idEjBDF7r3hHcicrmV8WlcRarRJoHdr5s7u3o4u4gj
	lmVQgBPEQEscdSAgr24xYAEu1XHZYs7qWKCGFvr38OGs455UCRkZFZkXwNbGiiWBzTx+uL
	TJtW9Pg5tr0ZIgE1NqXQrV2mQcBVlSE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NjUK2c0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZI4KGl4ZdlhaKQtFg5N51ionZ3BEZaRGa8lZ5haxR1I=;
	b=bmhS3BTwBcehqUX4uJTCqlkWv05hP9fpt00TqWqkq+efIm8FF4ROsGtHWgGKWLarhfFwO3
	Wi2/xP81tQCsugdilP+OkbWd8o2XRXaudSXBBARaw3XU7W2E9f49DkG1jlM3b5bxMngtf1
	YvvoTZ8BOux+Ehp4kFiUhmRRJCgJt50=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3FB441B29;
	Sun, 28 Dec 2025 12:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553ABC19422;
	Sun, 28 Dec 2025 12:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925833;
	bh=qZJ/kX6852xy97RGj2L4BqvkwDGVySCnfrT6X/8ZHF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjUK2c0Oth1aT9uy7WepSBxSdJkWVOkQe4cZgbJUt/3Vk5FeDofSSUXs7RotBz8Wk
	 WaTLvkRkluqf+y66UnI3oXL0FYu5VrSIsM+5fw8Rh64uDjtJFSbNejXFgJ6oSQCGPW
	 36hVyhULsbiadYoo654yaVyVkF6aC6QQ9oBJHZmVa8nvtJ7apKVXoF0gtpyVjTlGuN
	 yeEVpKigJk3cL1BDA6uS/GqiAC0lDSxisdpRXWOAeIL5/ItWE17ThTMuTUsUM/ix2B
	 pELYbkvzsLbIWDEv5oLDAJ5KGl0MrdQxizR8poPHvYrGWXRWccyiPRtl+ihH2OH6lR
	 3bjsE+qiqTuCw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: [PATCH 15/28] riscv: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:45 +0200
Message-ID: <20251228124001.3624742-16-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 033CA40002
X-Stat-Signature: ygrznn3qitqrji4xnfca61m1ism6n7my
X-Rspam-User: 
X-HE-Tag: 1766925834-193694
X-HE-Meta: U2FsdGVkX19QpjGip/+uA+GsrPghZeuJaRQ1UO8x/a6IZgnUs6NZbqLxCKnvjEsy0vmq16YW6ThaT5ETF7JseZjjGKfpBTXcIW/wxN0YrQr6f472i/4/qwNVH1TShF12phzKDvUwc8L15cF4Bwe6S+6mEXaDu4uiIWNWoOjNEBrsK+6+Fy4jC6WqpSOUeS+3nY7GRk8Xu2G4cLr0uAjhFRMs2D8Zn9zEqgrzagloOxgnyIIvQZ6vpS3mjJ/Jdhs607GodNg1GYPhL8xU8OqrR0/lZt2EOqulVlBxYfdHsbA0WBSMV4ZWP4sPXoB4AqOGLRZ7OjVKJAmksGajBHQCkaDIII6xAitecBMQ5+YWE8QCUMLRp3kuQEb60sWZO00QEwSpQh7t4GBc4fuIPteFLUM1OqprpQa9HFF+CciTpZxKNYT3yAYkC8nJTtnAT0KtdJEZnznsqcc6KYKtthLxD/H87u2GfK8T70Fq/o9eo3qyur2vzkU1e5or1GeTg052gMPHJGme4xrs+vMLao1Hbeqn+TnSVNIJX3jHIP+gd5Vsq+RwEfjglExYFWDXoxdVlXof79HAV/1DcM655Pz0yaiD2ACC/JmISxxUAglKwiVYQoiQtecYwt7wd5fmufIkCqIh+o6eeR4G5X5s43nyAD3akgzRwQXIZzrBnI8Su15sa42wCrQUq5m/hDbFaVQ2vvjzZ3VXCwgbF8DjMnwl3pwEoLwsWu1k2AKXRmKeCoi4B/xSvXteiJk3k4BEUZwzr6hLvZ7SYZzSI/SZyetsATrLVyWZfvg3ZUK6jos7nfI1R6g98OaKexHxmPqZKNIs6jXwwNZaHNoonje+ipOcGQf3RJQXWwKwZYMdZ0p8BrTBO+V+8EBaeMR/RbQuOWkGmSliOOTiOP4DkJB4q2wm8mXXiiuTLZCrq1gwfXGGRTq4SH3pcd6brrcwof8UFSeSDxKOg5ocqjWcssjXbth
 DcZuNP5Q
 A7BzHNoagSc/1kRhVnrZF4dRX42VeUTDJbF3QZ3Dp1V0pDaBP+QeFPZifKFXWifZDEzcF4ou0gI1PL9OksyY0CIBbisX/qQfBq9IFHNSgdMuTeW7LoaICNT1VYEu1rNGczB2DK/RSv7lI3Q3312uFqm5Sb1Z/LFy4G+dQ27NfEnVum+2GNXr2JL4Iyu2aCTlPWl/DStXEmT118NRc1Fpf9UON7rjuClPjgT5Oq4j6cpU36F/CXioyYdApj9/lagq6nHw2S+iUQfSIq6FE2KjMOXdf6iDNU1Xps+Uq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Move calculations of zone limits to a dedicated arch_zone_limits_init()
function.

Later MM core will use this function as an architecture specific callback
during nodes and zones initialization and thus there won't be a need to
call free_area_init() from every architecture.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/riscv/mm/init.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index addb8a9305be..97e8661fbcff 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -79,15 +79,19 @@ uintptr_t _dtb_early_pa __initdata;
 
 phys_addr_t dma32_phys_limit __initdata;
 
-static void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };
-
 #ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(dma32_phys_limit);
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
+static void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


