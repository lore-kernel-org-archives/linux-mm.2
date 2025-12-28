Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D629D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51C56B00AC; Sun, 28 Dec 2025 07:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C576B00AD; Sun, 28 Dec 2025 07:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C426B00AE; Sun, 28 Dec 2025 07:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B543F6B00AC
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:44:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84BCEF5C05
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:44:10 +0000 (UTC)
X-FDA: 84268847460.05.555ADB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E72074000E
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:44:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kX1tH8xu;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8kExoTLliZANVxlSa71PKoJV58jVF11IqoI4S/DqkA=;
	b=po3IZ3hbTK3iU3eQUQviR12EcVz23LULjMZlniACi0iEsf9KtDQFwyTfMtwUORDbRy+xev
	a1fFcu0ogF58XMf89Cd33XEt6/B13RWFFFZM1VT4njTqZoJt8W0o0JVjagoJwpsMkCrcnF
	TKwDcfcBR+HmjGp0AAt7HTBp6FPxNzk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kX1tH8xu;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925848; a=rsa-sha256;
	cv=none;
	b=ZS2G4PrGrpFFb0SXhPxFNEXSQlztUgTbS1zCua2AvODSuOhMdJAjB8NRxcQ5ieFjGIJTnB
	TYhZpHdlY1f0nxQwWp6wiUbBzIBmTRDrnHtCD02f3e0d/1nGqzjCr7dq0r8euOwhYpCNwr
	v5r+TzELLs/CacdbehF1BoRB4ox7i3E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3696360055;
	Sun, 28 Dec 2025 12:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E76C113D0;
	Sun, 28 Dec 2025 12:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925847;
	bh=hFJveYfaCrIw0+iDVEP3vQL9fd/XBHyX+JYd2Rm0RhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kX1tH8xu8fKTmLElV+Ey//It2pZKIYbMncEH5eVdxPV2oIrkBu88dyLUy4m+tV/2+
	 4hRMLMU7QmhsnoNobK/9yAeGyjsmucFteCKibC0xXA2D/GG0XZtG/7MZZ2dvUpP7fC
	 W8a0Mxl9ueIBoaw/I5gZIktnQ0edykaozyvx1Eeas62HtaT5rEozwIEF2N/x5he/5s
	 p8aAbOXD0cWB7kkbmnME+Gv9/f1qNKTzq5XU6khJIYF7EwVq+t9l3mwp75QD1dLwhF
	 55GxnQ44wVtHP/8UGnOJUPZmXjfsBwUmWOgvrirlKzPliKnyhOhwnGaXJHl9rUecMy
	 NKxtq6wIqtctw==
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
Subject: [PATCH 16/28] s390: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:46 +0200
Message-ID: <20251228124001.3624742-17-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E72074000E
X-Stat-Signature: fdkztz6q4sqrf19duyhf9rcgumh153zx
X-HE-Tag: 1766925848-938708
X-HE-Meta: U2FsdGVkX19V1m20OQnw6I0Iag7JXkYbjvRk0UOMdFgZHPuXQIub6SE5ssUWrb42bnJAitCdycYD+MZQKxKJKujVh6A7QjoRu+NNvqeLJs6BcXQrKxoG1Pm6htD9CXWua0HA8qWFmc8ADh3WOxL2WehiDI/TTwnEtoibcv/W9SfwW0+hGQhdfCOT0M6rQlwfi8RdXyAaDsAtsZhR5Z4Xyapi+g2VDdElErDZAV+d65sEdO43nH++8dz6jQLQ3AvEbPLAm9KJj9LV4UyMGgy45prfWbl+QifafaAkik3Y4owevAAsV7HQzvqWscfBzHFcFRTl/aet0mDaTHJ6qje0hGrktipzYdytzqIP5dQfjg9qG9jmsXhlqvEDb1PeyNy2r32tGCVGnIrGPD6LIVkz+b59vkC0P+9cfC/6PyzjdaHu+K0/xY2sIY0lJlWxuNYTnWe8heDzaGwwMVUwDYO7UWubXb0hb9BBCzs143TRUmvFqPhCwe+nn/FezDUEf8k25v8z00clDzk4T8KR5yiDGZDEghSbEK0azwlB1rQh9Xv2jx2++IIfk6Ykaa0EI0KtsH8ki32mavCCTi8HMHlZ3HUpYUIpsG7V8N8KgY2hOxOez7mqgbmu4WDOp/ikB8zGdzgYOnqg9JS91kCfgZ0CRg8Dyx1/T4hMqADuWMNM25suqNk2pHphhnpKEqWQ1JWrH3HvLWKtElALBMV0zU56dKpk9fsTwy0Ldu+aYM90YuzY/d/HK0Zar8WXKHx0pJ9c04ZWgskAkMmqQwwZXN2S9aYeasg8LsPtgSLLjJ2cj4GZVz5l4kPGjwbe8ZYKuDcQ8SYLOfQwcR362lHynlIW+kbJ0fYgUoEeYboPD3dIhb4y97+M4kMn39RY3JCZ55fI9TATWA1ubICl3kSoIbeyNNKk1uwIjq0bLq/oJQq0tWyikP/JMEzVML3IfGmBrowggChz40wwoFiTcXAPrds
 0qG87dVW
 khMBAYVKHkr7f+YLEr6Z+wH4PKUwfiq69761PBvspdrdCYUsNdo5k+6gAd2O101RG8xkNd8RBqEX5+wXV5WoEGIzqi8qbxO3qbnBa0/C2YShk6Z4ZNvETiC0USWfCJySMWDp14g7JpuBQZE1gfePKcb7bQd31gbA2kEKv9gxDktTPhHb2fIKKO9Q4lDMxjODYixf8OJR566hkl/xA6C4g9x1v2QoVYEdnyhNuW4KjyFTA9hqr3/QkUTmKuF29MZnAq4jMlQSmmDOSnrsEk5x72iquxw==
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
 arch/s390/mm/init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index e4953453d254..1c11ad84dddb 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -86,6 +86,12 @@ static void __init setup_zero_pages(void)
 	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 /*
  * paging_init() sets up the page tables
  */
@@ -97,8 +103,7 @@ void __init paging_init(void)
 	sparse_init();
 	zone_dma_limit = DMA_BIT_MASK(31);
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


