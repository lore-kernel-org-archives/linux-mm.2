Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C8AD2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F366B00A7; Sun, 11 Jan 2026 03:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C946B00A9; Sun, 11 Jan 2026 03:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E8D6B00AA; Sun, 11 Jan 2026 03:24:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3C8A6B00A7
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:24:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA3991A03E2
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:24:27 +0000 (UTC)
X-FDA: 84318996174.11.025DCA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 32ED6100006
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:24:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2z8eOMb;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Amvc2bHxtbhQlfK6qJaZpELNOKeDaTKBZTuouOmWWwU=;
	b=yiG63/IAAPq1QdfX633z92t1FBnVSoqRXATg2TewG0L0zPwXic6M7PPEkePJSt14Ve06TK
	c/socccSkmrKYXU04sJFMyhqFxAxHoUKoLTld/uErZkxYCB5YeY6CgV9JmWJWqM35gPhF1
	Mg3b1HTlzTrsbN9mHa4D7NodTs7l3Ik=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2z8eOMb;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119866; a=rsa-sha256;
	cv=none;
	b=ahf5vU63oO4+3Ph3VclL/C5p6kDkkd0K4dpSE69HL1SLjFeqrC18bCxG5qZJ3Gs81uZ1jz
	C1DwgpIHC08pR+jxT1ut3ZJM81Y+KfpXuDCcycJjfdgRtMnBtx7TSYHqRcEtwWfllWLe6w
	dpi10LQJeJh6HqF3eYAiYppVyoJBT44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C2BE40317;
	Sun, 11 Jan 2026 08:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99471C19424;
	Sun, 11 Jan 2026 08:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119865;
	bh=5jwx79jcXEjB7Ff6jLyMimZz3LM3kE0UW0s3xt/n05M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2z8eOMb9eyd4wabnDTuPvI6RxfYEY/JPPF9DcHEsS4Bxx7OOqdDRpJwLjy5GTef4
	 JX3E3wK7FvEIEDc+4gp2ac5AR8qx6fjBRr7EvCDi9BOZG7dYlNGVKk3+1A2sXe4uV3
	 QtSlpeZBvuA3HQTAUWNJ1nKZb94PTMd5ay5D7adLCwYMblGK44uysSp4hLaaLnxOBU
	 cjDBn8SojAUPdfeQin51Je8ea3GoefARGfhe5urhFjWdwoln4droQx6NMI0XAK1yr9
	 zLzlOIoym+7m3KxOZ+uROjUszAp6pkozGohHu0HDMUT+/UAiR82BRRKgyi2q6NIqVy
	 jwTaGvloNEqfw==
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
	Klara Modin <klarasmodin@gmail.com>,
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
	Ritesh Harjani <ritesh.list@gmail.com>,
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
Subject: [PATCH v3 12/29] nios2: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:46 +0200
Message-ID: <20260111082105.290734-13-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32ED6100006
X-Stat-Signature: sijaxh6nzky5k66j9kks7fet8zy5t4r6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768119866-390449
X-HE-Meta: U2FsdGVkX18AunYjil4A8z3sTXNCZH28g5dDytVwJlEi7mRdlWcMIkhjmXUJ/YsN/R6XcHfrb8ZrqWkSC6o6B9+oWyL8SCHGY5FGmCL3m3CjHVvEkLSUkgKsKTeBFF5yhLoydx3r96tZamfY0sxwrJa+TED85bqPbyETnyfGB4Ts6BF6Gm5eQ+x6AVeXxjp/+Tt8QA5kFG9+oEnjEEbk02IgBDbkcYdwpTJ/tDc1gHV4m/dqcw6zAMQo8GZz9UsfMVZD6jmOHC9XmtpTjBSWEeC9gQPO2o66RC2mAdZ+fkClm+26ey8uNRkKucgiBM9+RJaOFZZjAUL1tH1SF552Qc7GzxFKf/4GVZdVxym1o5EUVY2hcygZYp6v8A7DAo0s5IvaLSEFKmj1nhzrUveqdT9zuj2g3ia3dr30Pu5rAKssmW0ZmQXLhtsQilg1o/UBpE8QTS3KqEffc1rZO9c8hkHFOv7u5/ux/rdY5+sR2Yg4vgS3uKohiAMFOFoseqlVnx95Rvyoea3X2TReTLPR4UYI95s5m5xJuSYyYdXf+NVCiUOR6+OonVqYYs8WGvfCzblYqmMYb887uQWJOCsb296ugJhUGP04pndXtEKv6eiVCJeL4t8qIDG4Rgt5DU8MFsx8f5nEpltkign2MJR5vc1Y5FzpoY8tkMhGJD6y4hzHeNDSVPP3sS7YZw/ItKI4/IWhsjdJnvrHAfMaC58m/Ejeix+p/ysTtRcaJfQSRD0bkaQaGfIyLujIFDrfLuNeZGnFH+MTNgwSZ9XD+eUFMUEDQ/8ICxx0t9ah1NO6eyeL6CoCOaMHVGsaosPb05ta77k99KBRPKE0j/t7KZd1uif9hWCjAZCWm+bHCrgI2KdcbXN31j/yrh/h8kKXAy5qjUAZaprKYHglEOBzTtqpcaZtQ6T5VahSuMP4ce9SRDMzkk/QKeYmUTUw8AW8uroDuhI3pvJd3ZvTh/kErPD
 HAz8gKuS
 PtokynzaNTUkn5njS0aLM1Ec+BuhpT7ipRXEJiyWSqcl4Sg2fm/cDkjjnMkwxVFukbK9yXbYm4ETHITM=
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
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
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


