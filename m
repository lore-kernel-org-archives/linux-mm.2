Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD898E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4EC6B0089; Sun, 28 Dec 2025 07:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F436B008A; Sun, 28 Dec 2025 07:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092226B008C; Sun, 28 Dec 2025 07:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE1096B0089
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:40:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DAFFEDBEF
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:40:40 +0000 (UTC)
X-FDA: 84268838640.08.7FADA1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B3BB40003
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:40:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ny5n8bhx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925639; a=rsa-sha256;
	cv=none;
	b=mdIjQ0FabmX4IT49cQcKyHbqiTMt3dftS+517CwiX86cpUjfF5szjiOH1dX2i1+k7dFxzg
	yroVyxnmLTzWSDChZVmSmy9FHKVNIUONuO1hnHrY9jVBI0n2pvUJ+MDKux1jsPzjjM+F84
	KE2EnphB64qfV2OlIEIbpdH1LNxMwjU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ny5n8bhx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDKGVymK57uzH9g/ob69grxMs4/CHVMEy4WJGOI0ovg=;
	b=pCrtw7GqovI9o2juy0R+Xvsh38p1EjDVlh8Uqm7xyktB4CD9xiw6UAyNymRE+w2fvKMxIb
	T/9W+mL0DfmBrQYKkJDqUAtqcASt6nrWXABcnB2BkGo53Uz3bCHZc1ykhy97OQIWYEgsTh
	25c+qvAHA4hM9e/vjUg2/BURBNQI7Kc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A04C560055;
	Sun, 28 Dec 2025 12:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A2FC19421;
	Sun, 28 Dec 2025 12:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925637;
	bh=pGrH7LSUy/RWWaEZflrH8bSRmOyGysCgjYGTdbg1VRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny5n8bhx4lGhdGkVESizKnB9s5NjTXyCzl/BNa3Ba9ZKpEvM/CZIdOIL7SOU9jff2
	 f9d7/RukDwQyZrvibX87GAMUHRnuu/jtE9lSsKII3JWBEOTYX6j4sd74c2ECetV/1v
	 efQADf10esO0n890dt3sP+OjZZ5uE3wI6PVBS5SExv55d39h4H7myjY/QFX0EizXtg
	 HUNJvz/qP4wR81roHy4qlL+10S1f9sDiJSTgMup03fwig5pGyQw/EYhxfP+eCAenCJ
	 7aBgLKnMx0G4Zdx1Cpyfjl9xvXr5bgSz5ylt3rHblj4ACGNjYm3Y/wasBOIdAic2Wg
	 pDiCOhnxJVisQ==
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
Subject: [PATCH 01/28] alpha: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:31 +0200
Message-ID: <20251228124001.3624742-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B3BB40003
X-Rspamd-Server: rspam10
X-Stat-Signature: mf4frbsieu9eo1ww6dxrqt76kortpnta
X-HE-Tag: 1766925638-626170
X-HE-Meta: U2FsdGVkX18iw/YQAr24TByomyUWP+oHR6WIQDsL/PGoqvAUW5sInXgaFCSzJ0oXBkDt7K7+lkwZS0LyoxfjaTpXYSpEo8cSW1j1RJiSni5QbtSRPcifKWgUQMtWasFt6pBDcw8/wJGYPYyuR7yW6qsPceIeITAKo9w5yh9odq+ene2U5GnpKu8BMLPiWE/scU9gQ/AcGGWnchSx9ilW9khUmHFGZsSJEyUPwiDe8wLDy5+eQBrN6/F1rifGkjpSvenF39HsEi5AYrKUd4ZCTc/3EeVv/V3G3MZCKWLYMX+Q5yy+lf0NT/rGPF4AsICQkyfEVbCv/EaiTQMhXkb9D9kubhTA2ISS61tREyXMB5LW1mFNFaWL6NmsM66ab3h+gMiYyxvvalusk5RjewGUi4cATvlHBTqdKToWlH6limU0m4tCU23+7VFlojmNNZ/bq8UlsROBdHCPkoa5O8QSB2sK8ZbauwPbgEmoQIwYCQLX/byf1LCW7Lap1UXqFQkBLNJASZP4nPXQbGbEMEXxkoZbMTYV8GmYb167s/hzkM8MicGYvc84xQAZIhP2URzQQMMRQ18KdeiNI/9/erD9+hmT2HqfB9H6oQsIXtXTdQttOObA3Z6XjXsOXsRlAndBl2iduj7xOgt1TMbZTItqneCQ2UQhcdEBjtYTGP76IDyvrcGSKjYKAxZO3MWhdshXOoObDWN+JKEBysJolbCHMqbY4BAWpTkZVfLv5aPDy+dKK2RxtkpPNeWV3MNaxfEi51Pg57DId6jF8qQ+Uy3WkPiHVj1T0uu0rT94w7WI/UbE7/cfXbMaQxyxCXUzA3XwqVM6asmAqnbl8k1GbRnE0utUgfTo6/NuMOcmxvZYHYDvm1I01BwAxqyNLGp4FPdL/kdueQ6uIavKelWUW74VYm5VPFwxwDz25m9M5UPTmI6yXCi6oMpEZ2H9DePhOQu4a6BEVBOdPHaf+sqXFP9
 Johi/VCJ
 FNISYm11xk2yScpluRvl44iUR+3lmdhssmhfl4F/iGo/5zQcGkuiYTcvsa0gGh7jYrjktDXCdxPpcII5T3ND/sHyohvedp/IBaKY32YLRW8jPnSJ9GcWik7xqn4emRZpcx2pW4WGWcby6YCB033agwBQRFtVIoUf79WjpZ5mbdB9PSnSNTLAvoIxYZTdJiyV0B91K6+J9aF7SaAQxlS2UT3adFtuTsF7x9Rs0mKIwbaupKa/MDGQuRVBRgQSJB793nzMjafr6yqCy7kvAog6iTDnLa4ITjKBZDby1yhS0lr3YgJD20RBw8BSvUQ==
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


