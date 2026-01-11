Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE75AD25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617A16B00AB; Sun, 11 Jan 2026 03:24:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C46B6B00AD; Sun, 11 Jan 2026 03:24:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1D46B00AE; Sun, 11 Jan 2026 03:24:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 393F76B00AB
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:24:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CD8E1AC532
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:24:58 +0000 (UTC)
X-FDA: 84318997476.03.D9ADFB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 73D9F180003
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:24:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JbmIeyB+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0e1TP9uHkBT01ZDJQE0AgwbttmTnnn4XmEl6uPF92cY=;
	b=R0E+tYxxv8J/WF5dz/3O7oQ3CRfJcL2CPVeKhM2ctLo4ypuB60cpP32Yx7j7ZpBxaK6VuW
	DtT/Z9BIraFCETPFyxDOhm9M17LoFbyQxfIE4BlCA6DoHVa99sYTiBVQS4kZ3oDyx1bWF2
	xbODru5DHHxHJ2Ppap4qQLf/kOGsZ4E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JbmIeyB+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119896; a=rsa-sha256;
	cv=none;
	b=ycDsqH5Bf6X5qofxcvm85KACsERoA0XcrYwaGQnJnCyHWXb/W6yX2vyeMhQZSCS4kZm6AP
	wPhTrXLnx4lwHj2bWMDrn++VW+RTbBbcn9LlqusHihtwsSaIqrccHRCFVRU1NVi6XfrTfu
	XDTqq0ztEZ6+eAPvvNz6hyAHyF2cUXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF3A860127;
	Sun, 11 Jan 2026 08:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B12C4CEF7;
	Sun, 11 Jan 2026 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119895;
	bh=QDpPHL1GPSMeFEARdEipDTbBSW8I0pBG6cArIIAQB88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbmIeyB+u7QkZj6qhtq/RYPBACW8/J3QYP71qg26md1ze7ZVI63PZ7qe3QaiXkEHF
	 r8KZGenP3ELsXuPvs8MMgOHJM8z1T3vG79KdN6mZHTQBPdGcenGgcVMTGHLvsceAtt
	 yvht6Jt1mY0GtyMhipKb0uJWYDcIkGRrJTqA1Bm0C2zDFc2Kqe4+JNfMX8LJ1ETMEF
	 fpZ1v5ihFBLp9INfRx290adKTQ6kPFVxD/+GRYQE9PpPUOPUEkBpAxTZDOYnoh5FvJ
	 e36Uo0tt8JgHhVanEsu/T0TDpFFdJVqY6i7ZrcFIRE0R77IlH4Mm/qSGqnYu7lBt2g
	 kdWy+/ninWeNQ==
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
Subject: [PATCH v3 14/29] parisc: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:48 +0200
Message-ID: <20260111082105.290734-15-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fn4gq1xuyrzrxitusaw1nj7m8jrn7ggo
X-Rspamd-Queue-Id: 73D9F180003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768119896-199988
X-HE-Meta: U2FsdGVkX1+KT+iOcHFxn/ol5z9H6H0pJezC647pXJPL3SF0bqNqGAEFBMLMh4ba4G3Rvzthk5F0kejZywOepuFimSVUeD1Ky1m5UQmhkbmrw8GgTFRGmvOKApJUbMf6cWTF2gWCnCMQCMFBEi68U0tyxfs+fZYlcidnuS/RE0AHjjHltK3feRn26TW6GolyS9zuOQcQienksnx0R6yvFnJbc7BnJ24fjrvb25NfwTygdRpaFNP82I8n3igL4hkAlqoiI1jImk34n6brX/vM0soVasDuXPWF2aszFI7+QHDZ4uxag0USsEa5Ox/o+/bWp2SQN5EI7j4kJZWfSoEzfd4qCFaLuGKbe5PQRP1+/qeVzJ3YTl4z7B1Ji1+VF68ECJlTD/pg+aEDk5PxyTHiY+WBkPcZBnR0VJqxIqqOqVW0lezCrJUDjbFMItR54Ii+9f1IlwlRzYjYDi+aeye/jYxyesyXRTmpzuVGYiZdlz+GOnBlzEJi3SkeGul+43rFwWvVUcWwQ+NKELMR6oBX/ouWTDjJFMN4AGRLx0hUIe2KxdoT9uTgJKoRW1TiJxCJL1EZPe+c0/SF9rV26TROx7JW+KCw27umioL5/Sij7CczxJOXAD8kw+UViFcMCjOC2x1rFJ7tLpz9h3+nV9UJwAzINcQCft4APa0flxs9Se1nAezGnwytkFlo4RlX1pSmByNeeVbdYmbh2ZpxxXOkwbb+8XFA9tXdOX53fAGZ+WXzGglB4yaDMhBNtKm+UhHlo8hWC6/P0XHEfjdvkU69vpy4LqwbLunhC725pOieWaPcSfxEgMXFJh/IepYyd6XSVNOWOikNWtpIzOvPL3vEK6AzPKFA069dY/GRVU6FB1c8Oa6xTIjXW+KYoyJXVGamcMzlkqnw48brokse5E34zUkiX/19g7w6a6HdVOSXQ2iaRaBBco21dSWxDYGzEG9l3FoDFC/gWuxnsn3xoiL
 Z/QN+BTz
 qGAHLRWQT2c0zOM/Apo0RR30f5NJuwMrRKA/AOi44ZBiGFzHZ5lVbpHVFLOl/YxA4bOYcGhZE87Kligo2JvpuZJ8TCKAkxr0f2QNFo5UCOn9PK9qqo35Sz/jiB1BjotY2cX1LDB+u4ZWnHOmsFrPJXYCdQrWnwD2BVxplm9AF0XrXKtdG42yCuMWQKq/b5L38F0D9j0A/voVwdYspvnq6gfsk9n5GmOEvsaUCpDMhSDz11doc2QixkhsHY2TEHfnv8knMx2Vn5dzRAr9NHtJndFurl8k/2xRgXOPSnBqaS1Sjfqhl/ph2rnOP/O/qyMqgmLwgVzBF/N+DftMiANzWFQf1TldzjOTFb0yR
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
Acked-by: Helge Deller <deller@gmx.de>
---
 arch/parisc/mm/init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 14270715d754..dc5bd3efe738 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -693,12 +693,16 @@ static void __init fixmap_init(void)
 	} while (addr < end);
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = PFN_DOWN(memblock_end_of_DRAM());
+}
+
 static void __init parisc_bootmem_free(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0, };
 
-	max_zone_pfn[0] = memblock_end_of_DRAM();
-
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


