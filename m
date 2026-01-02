Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC6DFA3729
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497FC6B00AB; Fri,  2 Jan 2026 02:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442386B00AC; Fri,  2 Jan 2026 02:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339C76B00AD; Fri,  2 Jan 2026 02:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 227776B00AB
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:04:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D85F2140368
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:02 +0000 (UTC)
X-FDA: 84286134324.16.A06E7D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 28D3040003
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sOxNgN6O;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZI4KGl4ZdlhaKQtFg5N51ionZ3BEZaRGa8lZ5haxR1I=;
	b=XiuhpAamGg9MSZ8WwOEehCRrFte8HLyyGydg3pMV1g34ObIFc02CT6FSKs/INlnhz8fOQj
	hRHMei1bVRl0/GK2N4n10dm0dWSejpHWdWqskp88+b2rl/Nld47HzdUdQxX36wMdKZFYA5
	E7vdZUnjq2C1f21PWWfl15YZi/VsD2g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sOxNgN6O;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337441; a=rsa-sha256;
	cv=none;
	b=FeTSurI+29GqJZD5lqVkYwBPCW655sWgMv4CmeuzK+KFM5B/xPZG8IHzCmsBH62Coa62ZO
	F+4xjuVgcJazBQeI8ECeYCRhtrHRRaYJ7AyNH3x5cSEqchEKUOid2zUgRY3rmgCMEbw4fV
	FvDSbesHbfN4+sLf7ylYansD/svEXSo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B3DC41912;
	Fri,  2 Jan 2026 07:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB77C116D0;
	Fri,  2 Jan 2026 07:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337440;
	bh=qZJ/kX6852xy97RGj2L4BqvkwDGVySCnfrT6X/8ZHF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOxNgN6OxtsnaYgnDLzUYrAYFYyADUY11Yh+tEH+dcdMl9gt5qcaKLXDyLZdpxPkH
	 ZsoNpPJXB9RxVLR2u3dPQnvAw4HtfdHQNMiYV+Lt2AoNYuX/a5yuatZR7XSwb6LC/M
	 31CTS3ZnrAOkhmQMEa0ob3gvNpQzz+og2EL2L1n8pn/XpsDAGAxtdMaDR5l7wLa2sR
	 zjP4bAdaKXqEInAeZEAYgq0LKXfmnb4xkodXbn/BQnjvu4jdKyiT5I8depNd4fiBAT
	 M3xCEoxnLREi+xwHjLHBz8KBkVu1CT6/LfBAiGV5C6nzSCefhTXY6MzfJvVsB9dWNq
	 WGBYdl2odF8LQ==
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
Subject: [PATCH v2 15/28] riscv: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:51 +0200
Message-ID: <20260102070005.65328-16-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 8j6mcoqicm5qkkuc67smrk8ebqdbz8t6
X-Rspam-User: 
X-Rspamd-Queue-Id: 28D3040003
X-HE-Tag: 1767337440-598535
X-HE-Meta: U2FsdGVkX19dzxTEurJzffhVN/XwSF/hbTysnhflFEWA0FKjRMP0WOCtm/QkSuxNS5f44Q7fa3J9UYZg7xQt4+X0dXv1uu5ulRaXNn/u0FyS7xFnFInAR8ayvV61VtvIZEu5eNGKMy1q3+UcBkqcWCo3QhXI3tnvS7GVFPQG2N+ALMf9UDqWZfg2npvWsdfzxfke0XD24wqgnXHVOaQLhODcwF7G9RaeN2m/a2firLzgCsQwVBnDGITnm47mRxRpOr8KGCtZ3S/tbGw6eDT4nds93ccAJbPwHtnUWpm261v9MNelXeAM/pF3bAAjvFaglXjen+0QhHbSTInbdhOS/fVIC7ZARJ1CcGSQQOniX4w7jsKVm0F5huPsY0E8LSvSt/Z1v5jCpN/EvMuNt7whp+REh00w1zwY9noMzpa2nBfidEuiqibCS8ESeAtXGuZriJht3DVVO/ZcZa8Nw6P9OE7Yax1btM9a07JRBnmdUpMJcXJNW9JDEwzM20udYb22dX5EEL/9CebvYxSZChD9Nkc5PdiGa2k1Ci3hyrMt6mbZZxJcbJgxmRHVem+SyAq0sA9SLSFKaOSba1oayZcEYt+96W7N/Wr46qkfpK0PHv171BXQhxk1BV0Qky0Cd8MoyRcgGhgdyMKeaKHZmdxEK1kXJJZdfovWluI9JZd+e9yehFxOq6SvK6n+bFDscI12CX82MCaVUm928Feh+f9HOOu9YJIQeBd9CX8Yj1WY4s1yARJTRKXJAJ9sQselblvRXMblY1gGGVyWH5fKlK9Zf+rGArbbamoZ21AUTMnTwalsF2QhQ2Lig5sObe37xaMRlz9B7QlhIUSQO6G+wsNzlcuCVxnAEXKVpq6jsyUkUNomxwpXWLusqiw6FdsK3aHWIWQ4MWGIi5FXedgCXJ/QtJum50X7lUsTgOI5XxCdQP+0p3EsbGWkWP9Zv5LluvIvHGEp7CBg3RuYrxJJJsC
 /VVNAUko
 zSJHcfUZKL1jR7bpU37VcLeTHbfgyT62tnk0P1RPnlI0+SpBCJlIu2oUs2zeKnetODfvETKximDxYpxqYWI0C0XuyvNXvobbqVM/cz0iPjDsFT2nAhodv9UnOWJxF3Iqc1EudTtoyWZIvxfh4T1bFB8dDk/38ncHvBu4RAHRqbnRywg5KAJI5QoZi96NLoD6EPfBo6Gmn5uEjHJl26zhzuiJMEsxFDR8jfrHy0Hf3nZUQ3Wdk/eLoJGLRx5Eom8puYqLd1g9S5nqKi6yuBgj8BQ0pQQ==
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


