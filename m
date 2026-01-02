Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BAD2FA3729
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F616B00A0; Fri,  2 Jan 2026 02:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A0C6B00A3; Fri,  2 Jan 2026 02:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603636B00A4; Fri,  2 Jan 2026 02:02:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1826B00A0
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:02:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27747C1677
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:02:51 +0000 (UTC)
X-FDA: 84286131342.07.B73D998
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 76EAC120009
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:02:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dFiMKhjq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337369; a=rsa-sha256;
	cv=none;
	b=rcxeAprwTyU/HON0jtp9UqMmGmesj4ku1PF7oUVzJV6QdQUzxvKbWc8wcpwvvoaXyTOjNR
	Yc7ATL61VhL39BjHrAILNNQ+koCQdMgsPG7V35lvZFsQnlpZrQMc2LzrGZNwa01CfcfAmS
	HnFwViYr2MaGIxSsr9/VH8a+spSyHRc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dFiMKhjq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9pBPAmCex859p6JrPopJFcFxfKxR6uVnsR3JS1C8yI=;
	b=JuYj2H8/3w2bkH8Rx5ChTGtdYmA56DzivAxi+Qnw58Nj67l4UndpW9CELLypWC9ybx4CLT
	pNjdrROHb27LyLzsj124cEkWWGdhHOi47J768aajHYpiC5U8vrMfBq1P7Rn6EAIOC9FLim
	+nlbC/5ojNzpoB7p96JqLiBSe06ohqQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D3EE43396;
	Fri,  2 Jan 2026 07:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BECC116D0;
	Fri,  2 Jan 2026 07:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337368;
	bh=es+FUCZqCY2a3nIkrdLdpQV/rxxtDtuUgA954vVF+nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFiMKhjqyf+PfkCOMts11njbpfGwqQefsvvZvfGAgXrmmyP02aiCpmX8wvtgXmjh2
	 JGcds5OsjQOsg8MVVqzy4zBA255m75qdXO1si07Ky/r2zB4hmu01u39hsqm0ewanZN
	 LSjxiEoJP0frsXlr6bA5f68JZ0ShXcr0PT6HvGZ0JX23uSXRxwIaNc/T1RSWoD84TE
	 DI6A7tJWLRiX8jI6Ss9SIxVHDO7YvahppzQZFaJQT4eHA/41c1EOHZ979ycVclWE56
	 dcJdXB2lF+KLdNfaYQTsmd0q+sw9v0hQGXGsrYx/8NwnWCiyzXxykXpWhWDh/oVgy4
	 FJ6eCa9gtAd0g==
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
Subject: [PATCH v2 10/28] mips: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:46 +0200
Message-ID: <20260102070005.65328-11-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 76EAC120009
X-Rspamd-Server: rspam03
X-Stat-Signature: 7iw5jh97sksf1yrmxj41sypn1ng4ekog
X-Rspam-User: 
X-HE-Tag: 1767337369-997958
X-HE-Meta: U2FsdGVkX1+Zn+QIUYZ9X8lPhRgag20Lg589bllvfCHq2uQlz28xBV3Njj1dbj2s1zsbARyjnatOWUpm18M/UNewq6PzrH2w08I6W5QFGNDAiYLBKCXryNaAXqoN4IOV7NYtiwKwRB2JCoG+GyS7mgRwD4AQaC7LKm4Sr1IsA5lG7mqkEcqGiHZnCmQzwyBip/kUd0DW29zjD2i+SODnCwE54nhGSl/hHRC9lwjXpFeP8W+gBbLfuhtIlV8plgWj8SeAiaenIRtaKsc8saZJ6+CFlBkuB66WuuBpIU4UPA+AVfb2Lt11jjYRw/pKh7auBLAsZK9bez0BGWvKUv5oMX+LgLDWR5JePfB5GjJrKogzmk5ME0l/SxkVFBREjpx1myvRaJPNYDEywlSvD7j9+z2kFwipDRznOaoWvdwUh1QaRpCwSqgM0RmPoC9wJB6gJDA5s0mZ43rH7X11woWZOQ8Sm9zkB62/VtPpeFU6/hW7LgsQRHTMVKKOhO1548pfBKgNRBevWyozc5FKMKfzl9AzYEpAK8DmkM1I9UJz9tNNXXcOPLLD5IjouTRuzNtgQ4clWdPegHYLWslJVWXhHhZYJXmSV4/VgNdm6Gylzmb3b014ZJDo5Xga/Tw/twMElx1/rVr47TboDVoI7LKMmj6T/fqNzffs6CH+IMDk0ZGV/CLWf3iHZAvgZV2hqOW/rBegRjM9mpdSbnygpUOuJruyEJZ5H6liTHU7NwTofgLSuQEvoqqX6XykQmv3Hr2nTldKABrDnqhKl47P5MHcx6yODtTIjjFMAPG8aAkJTqfHaYL+tZUovGYvbEuOyUc1kTraUI9N+/7aY6Z/JhsIUKDVu8O1f4H7OGS44FFGFw/irZuknQU9/KvoNkcM3fRYv568e4NW8FMCyEZDyFzclpsE8d7uVr+1QVDBjZrC0C0FzvgFjitQuk7W8qpaUOGauKwhqQgR+Pg/phCI1h9
 YID486pf
 UMBpQvJs5JK+XGERXTZ373dEQlFw5q7TnVazvGbfsYj9WxUmoRIaaklepJXFW4ZrroA1hEv2tX5NL4cpe/gJLdmstvM416MDdJ36rpmN6vvTTaht5qxC2KY0neAEjvdRQb6o7xJU4GDbmZzeY6kWEfPi8pOMVi1pzvHpO5bnAwGmcQ2D/o92pUoxFGR1pXf8ChlPbp7qQTUUFF4whyHipvfdunHlb+6uWxEOXKu7EO+Bk2FFbHEpwkh15KAgqsFPrmDqL2OquCtjXMPeZkzDtYMuO2w==
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
 arch/mips/loongson64/numa.c      |  9 +++++++--
 arch/mips/mm/init.c              | 14 +++++++++-----
 arch/mips/sgi-ip27/ip27-memory.c |  7 ++++++-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/mips/loongson64/numa.c b/arch/mips/loongson64/numa.c
index 95d5f553ce19..f72a58f87878 100644
--- a/arch/mips/loongson64/numa.c
+++ b/arch/mips/loongson64/numa.c
@@ -154,13 +154,18 @@ static __init void prom_meminit(void)
 	}
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 void __init paging_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
 
 	pagetable_init();
-	zones_size[ZONE_DMA32] = MAX_DMA32_PFN;
-	zones_size[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(zones_size);
 	free_area_init(zones_size);
 }
 
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index a673d3d68254..ab08249cfede 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -394,12 +394,8 @@ void maar_init(void)
 }
 
 #ifndef CONFIG_NUMA
-void __init paging_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	pagetable_init();
-
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 #endif
@@ -417,7 +413,15 @@ void __init paging_init(void)
 		max_zone_pfns[ZONE_HIGHMEM] = max_low_pfn;
 	}
 #endif
+}
+
+void __init paging_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	pagetable_init();
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index 2b3e46e2e607..babeb0e07687 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -406,11 +406,16 @@ void __init prom_meminit(void)
 	}
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 void __init paging_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
 
 	pagetable_init();
-	zones_size[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(zones_size);
 	free_area_init(zones_size);
 }
-- 
2.51.0


