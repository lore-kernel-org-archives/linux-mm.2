Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBD7E9272A
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90CCF6B00A4; Sun, 28 Dec 2025 07:43:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC1E6B00A6; Sun, 28 Dec 2025 07:43:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78EBF6B00A7; Sun, 28 Dec 2025 07:43:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6342C6B00A4
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:43:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFA47A48B2
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:42:59 +0000 (UTC)
X-FDA: 84268844520.30.B64C7FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 51C3A40003
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:42:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UD2BERPl;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHem1jOpdanhU4wzja5jbwV5wSMJ+IR8AM9Fotb2ptk=;
	b=bIPbnl8SiGHT1rXO8z/YZ1CnuSegheyd/OPkjUM/cKpIAx5y+/eMap/psP+Q92rwkeoPxT
	xhEK0+ylilZ9gFHtHDUQjYvhZsUF+QSAM+b1xfV/DzWjEBibD8SScIm6tZ8V/SdL2GUPIa
	g/FM36Vaffhcd+MHSySBGzTDZ/xjsOw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UD2BERPl;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925778; a=rsa-sha256;
	cv=none;
	b=O7qFEZ0qDd1l4Yi4MdmOoMztmFsTtiVngQmtmXwYZ2YDievOkhELSpgK0Tvzp+fv9BNIuA
	mWghbOb99RjuYJC/ykGaryEFzRj4XnKCMluTaWWDRzStBpFE2jRLzG1kOdfos04vSQL9ou
	Poih5t3TmgXXfgqWNlEsnNpykOSVA2U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DCDAE60055;
	Sun, 28 Dec 2025 12:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1380CC4CEFB;
	Sun, 28 Dec 2025 12:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925777;
	bh=7/XO61OP3oJL3oXo5SwiraqhSSBSqBw3/hQeqUzArSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UD2BERPlZ3ba4OSn/ykAf8NN0SaXrPzwsTk5aklWZwegjHk4YPqFP+mPCH1Og4nl2
	 wtcJ2uIyxWlfn1ediLSSmTIsfKU3/ze9Gq7AgyseaWU/v8PuZKG/ibcGLHdaqGs/XI
	 1Wx77f7NgvP4aGd9BtfQN6kCMWnqp0KZ3GSCAOLYmW8HRNtlSa6XTWWpkt0gSZPOUh
	 JnxNER3OfiH9ng60Vlm/awFv8D6oyJR6moDue9xFg+0rJO7htyIPTEKQD4sJJiYkPu
	 IYpzRIxBkyogdh33QXcABVHe6ViOEpZtcC7KoONKuCr6PTH+VdpveD1N3juKNj518C
	 j9t2gzzEoApfw==
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
Subject: [PATCH 11/28] nios2: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:41 +0200
Message-ID: <20251228124001.3624742-12-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51C3A40003
X-Stat-Signature: h875bzyj9ark1f5331keuc5taq88ougd
X-HE-Tag: 1766925778-318695
X-HE-Meta: U2FsdGVkX19fRexs/BXbsxR2gCBkaJfInxf83FHWd/lL8tLAfmdnJUG6H83Z6Td1/fUlypSrgMz6+Vk2H5JavuQyTltmzvioNMn6aZqTANS6IQa49liS9cXvGGkeKVo6XYES96zOIUEmxsDnaNKzr3RBXiKvxGXJcrPczawmytgP8H8Uo8Hf+/TlERf2zMZVhz3xtAa3wlfHSVXxD5AI2cUsPmf0pSUv0TjdBH97G7j0RafDpYp4+FHIYwiemLFvVj+X4F53i1o39qCAEYZgDthvGenNcUwODP9iq7GbGQPVWguoTrivRPvYwKyyldkIhG+vfgn+lUkfHFPchbHzVpg7siEYcI7WI3yqndY2REYDiKRv5QEZ/bjjnXFSAdF7FgU8PrYTry3KOCsZ7VPRwT98JebFNu8n2Hhz1d5m+PQE0utOp0NzR4/oU2hlB8kQPXWE4O3RyjnWd5P2PQ68rJeeEykEbMXE07Y2lRCwx9cUgN6PhOuk9/mww9kdYjU1u6vK/cpGWVFzU07/6qZdUyDdVKaAMEqa4YH+OOfsJxjwQLbIGWMkzN1PqFnm6zRYIPehYX1HjcUBQuDmeS/THQfWUn3cJYn2Np8fRgM+ZPlGM+OW9DGyYjJd3v/4MV0hleusTbqvLXOsDsFcE6vIRurKAUDPiIRkXoWhib1LU1jsqdHhuTKH/tVG0cMEIrXrxxXuaLJj2mPEHja9/IIBwk/B3SzhpSDZZbANBhVvXJeHrNcm+HyFH8O/nMpt3T77dHDBfcYX7Vo4aQ/99tMxrG1xL5baPFR7yppX4F/jyyDdAm0HxzESNSv58x5MKJfxApGlymWkwh8IHTNzOWEs8yCCL4kvggjwS7FrXl1I3ZDgSPBuwx9pcoV8awFvkkVYkVJrLkVc0CGL8jqjcJlujDOzpMhKW6S0UAoEv7DBVvnwQdRIDsqGEprCtc2GMD/bvIgSKMdxvN2G6j7cJl6
 hXBaZgPv
 DKeZFFfnYdJX0keAZjzK2Xbfa0aSIOGbmdS9LrZvByJmREGRb8OBrBLmItX6sb+mMSoOAtoSI51wqh0tYbpLLQZcw/OVbruTwkLM3JnFCLc4ADey4GTgAQj/azSok1UyeeNPbDRaN/9lioXN/U1Xn3J+r+3I7LmD1PHhmlG4UF9O9HfDxexR5Gf12pUl/BHZWSiZ7Tcei0SXOols5g98rvGUnNYa5KjbB8ndgQlo6IpShwnmRPeLTL5sfwzglysigLRBQtWtwvSgkq8Y7fnq8XAGD1w==
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
 arch/nios2/mm/init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/nios2/mm/init.c b/arch/nios2/mm/init.c
index 94efa3de3933..2cb666a65d9e 100644
--- a/arch/nios2/mm/init.c
+++ b/arch/nios2/mm/init.c
@@ -38,6 +38,11 @@
 
 pgd_t *pgd_current;
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 /*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.
@@ -51,8 +56,7 @@ void __init paging_init(void)
 	pagetable_init();
 	pgd_current = swapper_pg_dir;
 
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
+	arch_zone_limits_init(max_zone_pfn);
 	/* pass the memory from the bootmem allocator to the main allocator */
 	free_area_init(max_zone_pfn);
 
-- 
2.51.0


