Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00075EEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659266B008A; Fri,  2 Jan 2026 02:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624126B008C; Fri,  2 Jan 2026 02:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527296B0092; Fri,  2 Jan 2026 02:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41CFF6B008A
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:00:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C338958884
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:00:41 +0000 (UTC)
X-FDA: 84286125882.15.D079C73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 314F7A001C
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:00:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ApU/C+wN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337240; a=rsa-sha256;
	cv=none;
	b=TxfZHQmrnVu1NxJejnTlscRc9+Ul+jY3ZwWyPADHOWtZ/z15Oax7W6SzlGrOqmQbKkNm2k
	vU4mRxPNxEC7eGbitGdt3vQNfDXv7aoIZfBZJqCvIgNevAVi1xdli4M9TEOPx2Xo1oHjmG
	0DuaxDCj6v0orTygEu1cRLfz/zfPpgc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ApU/C+wN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMSeghU9mFb/iSGNjAJ2/WETrT3nayTRWjrK9prgUyE=;
	b=c5UOxa1x2FZWKk07zVCpEazp5u7TptyccwjHAKMVw83jfRhV2igdMAbSwN1X0xFtAHs9V5
	ghiiAQJ7eaba/VJLRVqvmOaBFa4S3bQc35dA4tCG++AywTPScPy0yx//IKae5oWAGhOIpF
	35sjSXqtTbvTQB/MAm59nNnQxRTrw30=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22B9160125;
	Fri,  2 Jan 2026 07:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F09C116D0;
	Fri,  2 Jan 2026 07:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337238;
	bh=KgO7SaOs49km6xau9XjjDmzydPHNaHbDsqRu17wGsEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApU/C+wNb4idNTK1zz1rLmf7qMnQiTC69e5uyInO+Kw/+8zgij+cWb8B1RufqXU26
	 1wwAkDpliKwcZM980+Xgpsrz9pj1f3b4c4DAWujjPkDCfQWq4BkvD/f8FippBrzSQO
	 KbiqOWCGO+PDtGqsU79y82rc/RtNyo6RJJXmHSxwe5v1EVVeniyX4YJ8VYClntcefc
	 6bNEl/xqs/e7MJSfTN3oSKRvHYgLidvtUF3HM0HkqeXsKG9V3CNaMeRVAp10jZFrHR
	 a2+yXy2rd/ds/cJTsRv4zQKRp7NOtOqrhkbdkQHjNFRSNKPR8+JeTwPjQchjqqMdSB
	 O39qW/PrqZb6w==
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
Subject: [PATCH v2 01/28] alpha: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:37 +0200
Message-ID: <20260102070005.65328-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 314F7A001C
X-Stat-Signature: 8t9taa4br9akdachw6p1957z8rc5k11m
X-HE-Tag: 1767337240-889970
X-HE-Meta: U2FsdGVkX1/18eNdx1MHyUo9CMKpGw/ebhI8Fo2qQNhTIV5Sx64ax86KaS/fscp7OB4AdarBjXGwrafbYSiNYN5mlgZql3o26kp0rSc2hZ70ay17K+kiTnVEIvy84jvVvvpr4Hc0p9ZCePTqh/x7xJfiEIYRoy+aXXiWqIw+Zfx8JQtB9RG9267UbUcBOZIS8SosPb3IiZknll9csKJ1uh/EIDnpYgKZLb1VGouDVdvXqol16V9PYQ4+C1BHy3xt/c0WBJaBJt61yMzdWbrVfzSV6hUylMs/TsVPCmstluOIrt3jgir9UT9KbATp2mHzBHQwPJ/MNiUBZksoE5tuSiiTZTpNvVq6QXmDpFOWgMN36LWOUB22W3pioEuANY2zPFCvZ0SA4MD9+1TrjHK21IUmWi0HDnsOgkAHt8SmOWn7j4OkoQMx0e91bKmNaWhB9q+XspxgYBRVXP6xGFlLIMLtOewm8ubZQkAVPelb2KPKprUTaio8y0TP5MUPqXl7suYxCToyvtd0krJ/KWyQ6aTZibLbtdFoP8r3vCVRft+LjN9N9KqRk8flpsO2Vf47l3+sYvW3fZK9PRGPMvx23xX2LDLChcSXyv9YH3vwsZ2Nd1m6HLBmBggKKSQJKdmDQHmsci8Vai7MhY5Z0OrCDLy2TviMCrYZYxrXqCSQY61/oA8HHhSIWszPCe/HFPy3jcS0AOADdSCrGOdi5f1YYGbzYT7wMUNVl9ZD1Fo439JCmD9fDvjciFeDEf/lRIPNuXNyROOKfAZl170Vel2/bG/zfL+mcBvu1Cy4Ovcf/sXfqM+oigL7+7Vviq7IpEnc39bXi0GmcaGrVo0uXPMknRZAxxB8K5+nPR14FR/EOlxXXtNI3xwGDg+lPOhHPSFv9Re+KA6RlbB0G8PvOV2KkeuCw9tuXp7YiPxMeklbLuiH6LL0POcZC1qZjraMAQ6hmqGAY0PRpAe+jWWiw1P
 e4fjsgaB
 STlYGcOLewwFPcZOAM0u5hTLWV27h3OxdhakjHGPUIwZYvAO+8e7I42q5ejGhnEYUj22ojVYx6hiwczThGIpHi/PMyrWhN3jsklembn0wLiYTZ/WeIpqyJpQQ450P0fhjfr1Iy9jUmIdBr/nJBnxrvBOuLcaIMCylfEO5/lOdB20DKqD508WC5fRMzxZ0zkhWDx/VEDGWHrl2CD9dm3fP3yuNp7HmmRCI4scEFzMVQ+k+Z7lSwryUuyzfHUkowQZZG4YeO/Ltu1QssOHzAIeNdtipZ9w5sFzZwx0vvjBy+8wW/o4uYeaBvX+PeWu9J/eTMT94T+U5VaRO0RGOxGhedmM/Cg==
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
Acked-by: Magnus Lindholm <linmag7@gmail.com>
---
 arch/alpha/mm/init.c | 15 ++++++++++-----
 include/linux/mm.h   |  1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 4c5ab9cd8a0a..cd0cb1abde5f 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -208,12 +208,8 @@ callback_init(void * kernel_end)
 	return kernel_end;
 }
 
-/*
- * paging_init() sets up the memory map.
- */
-void __init paging_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
 {
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 	unsigned long dma_pfn;
 
 	dma_pfn = virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
@@ -221,8 +217,17 @@ void __init paging_init(void)
 
 	max_zone_pfn[ZONE_DMA] = dma_pfn;
 	max_zone_pfn[ZONE_NORMAL] = max_pfn;
+}
+
+/*
+ * paging_init() sets up the memory map.
+ */
+void __init paging_init(void)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 
 	/* Initialize mem_map[].  */
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 
 	/* Initialize the kernel's ZERO_PGE. */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..628c0e0ac313 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3552,6 +3552,7 @@ static inline unsigned long get_num_physpages(void)
  * free_area_init(max_zone_pfns);
  */
 void free_area_init(unsigned long *max_zone_pfn);
+void arch_zone_limits_init(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
-- 
2.51.0


