Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104E3E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C4B6B0005; Sun, 28 Dec 2025 07:41:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726B46B009B; Sun, 28 Dec 2025 07:41:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C6F6B009D; Sun, 28 Dec 2025 07:41:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB726B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:41:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 198CB162C61
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:41:50 +0000 (UTC)
X-FDA: 84268841580.21.9291184
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 68208140008
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:41:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZjbD+MQ;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9r49gF1239seYn0EXw4a+FTKxA1x4OYVZ+hhz2pvoc=;
	b=2PAQW+3L8JOxcFcWCblX1DDcvG9tdd5WYorH2lcsc01a2zomC2FQr5d0AfKPsVyYwTK041
	mAETMAnqRswMVRbfTmmKv70TA+fC0s9Srfb3XdVqm49aFvVAjTbTfcag7JFROoIqaFp98B
	szOE8Ahlsphn9FAPIc85/tNHjcxTEe8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZjbD+MQ;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925708; a=rsa-sha256;
	cv=none;
	b=IChHX3/uj3ptLFZovxnYrdNTGUhFoDP7ZrmtAlJb8qQRe9OAT4/p2fVvQSELpPMfozRSxQ
	AYdrDk4n54LWytqyWfaYLDTMTih66xEQoW5bagpJbQcHDXADe8Xnb/hh9FWD+/1H5Vwj7B
	gSqcOP5aVNeLKU+c02kKBxF7Cd8iAqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C19F8600AA;
	Sun, 28 Dec 2025 12:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA494C113D0;
	Sun, 28 Dec 2025 12:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925707;
	bh=eqWldmxLZQ+MuA70zzUt7CpIfBT1PwNgoY4RoneYtY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZjbD+MQrWxcfBpvPSpYRAHix6i5JMPKqqWjug6L9k4tMqPiNxBtk2ZEPYrx0iYxa
	 lPDWL97x3gfgGtVSk/EXS/mFYzkmo6e7uePyonoH0agWw7NO0FW043zsRKfg3Mc7Li
	 AeJJJdxb868nBOQ+F+IWq/zfI30jwYv2QeoLL2LmynOKi0hE+EdkeXd17Gk4ByiGt3
	 t8atKxv/+snc5y717GK/LGz98n9yUfG6rDoz7DxJ/bGj0E7dEiuUJIW1v4O1g45Q4X
	 ZsWwGAz2zPOATBD14sHotb7AupNiQ7ojVTj0X9koH39OA0OTd6M4bjQCFHfyLwKfsu
	 XSuFagWnrbklA==
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
Subject: [PATCH 06/28] hexagon: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:36 +0200
Message-ID: <20251228124001.3624742-7-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68208140008
X-Stat-Signature: 3ob447bwciucspawxaewb4kc18kefngx
X-HE-Tag: 1766925708-541644
X-HE-Meta: U2FsdGVkX19W/9E/kRMfDBB0sYzLmww+Ni5ywRyiDdC/9eCMog0YumiJge5BOWHDCIG6sZs4lbFjHFvPsKZQBPLetnSJM9SQfG5wZX5Atox4mrtKmh08VQDYk4Md6e4h+RkcKyiB2VzeDsrK8GLRA1cH9EaIyciR6e6XCionqLFBCkor+GIAmv4D6OzNQNih/+5ga6Af2wOf26gTwEWJ6L6e6mokmSz8NJhWJssy5F3HoRdZenYwXDVH0OTZZOf7WCo/6yCTlju09im4pvBBT6WGJrsdcy46cKC5UBHkrREKJZVx8ZOsubY53GgiupoLfbex+jbQBcvbzHaxpYkC657wHu/gyNVeH3eBa3Il9oIf7DhMbvICVJSPlhODv+TKDkXL4DnzjIZbNPJ2KeDptqi1pq2fd4nChD6FSzCZJDgP0KF7pVNrRyWkrARxh++Hdg5C4gTFRakU/07BgXpW1sFEtgRjAbYH5mZ5Su/uDGsBMtN5Oz/jn0LXmkRogMFHUpCgI/qss4PHQl0F1KjtbYiiGSvx6+t0X8tAwXuMM3Gdpcwcnyk7mllTa1Esc2Vhb3Dkk7EWGgmcCHzgjGiigw4BWN7HIuT7vX6H9ANV2ozlcS+vARJZQuSVlwAQaRH4iRq3yaX32juOynlYqqrQUsjnzX5GXb+aKBjR7a/4SqyFWKUUPAZZ5T6nu7KkdFP7Z2IB0VKpQ0FYUj2OkT2YCpEJp4AuBknyBgU8ylJg7veavSCxBFLwogfCgJZ3nGOKDYmH9a38DkXvZxq/S01u0IXInws5dCHD1IOnFoZxGWVBfjBJl63bJkNm+lXQ0jDsNh0eOsPjxdSd3FIaogj3oVQeLxPRQXNTckebNPdOrUbN2L8M9nIYjVuF0Wx9fE1C2SEpjrsHXXk1EJnv4uPTrz1HqBJRlIR1IG2sl8eSrRI1UjLL+L6vHq5byy2HwwzWDMcLDdofmtFj2pgUKym
 CwNKUvpu
 CpIU7F6oXmPv7y/eZ0gy+FKhqmoIkrZUgEL2gCW0cu6eyXzECkTy/uL+h5VVZT2p6xDwS3XjORLiBjs9BpfxPPebvIMzN8bx/MizOn1GFKgDgAnd9PPDn7ktUhLJuH2E4UPVcMmalLdS2VlGHP3IaozKkCiwM0/8+fZeDj7+9NQdi1C8ykjrSs5tv8QPdnIbMRckPiMgML9V+5xFBqowt9Z/aGpZOZ7V3W+lFqMxIxTtbYz3TatOAUUjon1jUN9kFXX54FFFIBSq1RAk/JkRguszzdA==
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
 arch/hexagon/mm/init.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/hexagon/mm/init.c b/arch/hexagon/mm/init.c
index 34eb9d424b96..e2c9487d8d34 100644
--- a/arch/hexagon/mm/init.c
+++ b/arch/hexagon/mm/init.c
@@ -54,6 +54,18 @@ void sync_icache_dcache(pte_t pte)
 	__vmcache_idsync(addr, PAGE_SIZE);
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	/*
+	 *  This is not particularly well documented anywhere, but
+	 *  give ZONE_NORMAL all the memory, including the big holes
+	 *  left by the kernel+bootmem_map which are already left as reserved
+	 *  in the bootmem_map; free_area_init should see those bits and
+	 *  adjust accordingly.
+	 */
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 /*
  * In order to set up page allocator "nodes",
  * somebody has to call free_area_init() for UMA.
@@ -65,16 +77,7 @@ static void __init paging_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 
-	/*
-	 *  This is not particularly well documented anywhere, but
-	 *  give ZONE_NORMAL all the memory, including the big holes
-	 *  left by the kernel+bootmem_map which are already left as reserved
-	 *  in the bootmem_map; free_area_init should see those bits and
-	 *  adjust accordingly.
-	 */
-
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);  /*  sets up the zonelists and mem_map  */
 
 	/*
-- 
2.51.0


