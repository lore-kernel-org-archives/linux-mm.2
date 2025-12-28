Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0D8E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FEAE6B00B2; Sun, 28 Dec 2025 07:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B26C6B00B3; Sun, 28 Dec 2025 07:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8006B00B4; Sun, 28 Dec 2025 07:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 576106B00B2
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:44:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C74C51A042B
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:44:38 +0000 (UTC)
X-FDA: 84268848636.14.A19F6F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15C9C140007
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:44:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GEARsU2p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925877; a=rsa-sha256;
	cv=none;
	b=IxzWFMuCCy9kOGQ3Zi7cPqmdx/xJE9x/5lCWORzcxJn+WuVCHIPlmED9j0TtzK+2Cp9bvY
	ejRwjX7hmmosXgyvuIWHuKn9bD83tc8SjXU4bSSWMxIOMZnK3ALMh5ZoBmzqWt6X59mmXc
	iXNjC8P7AitSSy/3YoZ5+L2UHuCcXp0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GEARsU2p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCeW4b5bx6EOK5QjFUW3uRjrRx8sG0IrVuSe7S4JU8I=;
	b=kmNOYQtiESjKDZb3sWbmyNQCeYB8l5dYC534x8GtFD2ptDcy6w4y45f8RV0IRMqyzWeg5x
	C1zwOdRDVHJDGIjz7b5qHhZqoTmOnOwGwE1Up2OshLOmxScDIS0/cUWpmA1peASZBxFmCT
	sXSkCnV3f5dspuam3AuEtujSDxmUweY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1625B4013A;
	Sun, 28 Dec 2025 12:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A573C113D0;
	Sun, 28 Dec 2025 12:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925875;
	bh=oB6QCqWGlUcVzO7N8KoxEGaOaNJpg/wuZYHeNsCpdgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEARsU2p+EZgFjCyr9uyzZ8hj2re6eD/C923QhGvMMzHuSCkKZytNmeZxflu9jkn+
	 Ppetcw1V5leg6VH3ggoT2pItHYZTxfo/oyIWHLFsGUZ8jPgjmd2ugFiVcvcbuH43oy
	 c94di+9wYXVA02fLVIEPud2jr2wZF6CazDTX4rNh22wu5gpZ7KtiuBI4xhIBXDOmSL
	 RRif8oZtzD3AqNLNQidA7D3P3awFsxGTATE8jB0P7elm42vJSPqaqhGg1UJnjG1bnj
	 3RnJniQjMgOHBMWKI7HkIR9dVwVy/YdaTbCkFX4tkcz8jitWxQWcWWx91604v63IVd
	 Ng+6vXu0vT9NQ==
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
Subject: [PATCH 18/28] sparc: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:48 +0200
Message-ID: <20251228124001.3624742-19-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 15C9C140007
X-Rspamd-Server: rspam10
X-Stat-Signature: m4i7oqxdiijfuzebcf3b3on186o3866s
X-HE-Tag: 1766925876-987287
X-HE-Meta: U2FsdGVkX1+1WI9TisxrZm8SdtthJRtdvtx9ZRtY4/6ndfnPTXnBCZ4NvTmvSc2jHNQnfo6VWgY/KAGol2Bil1rj7EBOSkZaIDLQglXTyfeuiLP+k8AfjbvZFX7oE9h/8lTNf7ib/yioLKJn+lorGWPMLM3xrfwFP/D3mpg48umrea0u6Slg/MhK/nQ3k70z4UV1bebhLfSCxClflgWf5A2fGHm/0TOTN7KH/E9JOEG+Hwu49IL0040jwn9wbJnkB5kSR/MkWr8930NIHsrORD8RXCVuos2lZh3PhUtoJHm9FyJKckemwDMQC/v4DUh7YuYCs2//0o+1Z9JoEJ5QIpKwM2zsrwIOpO/a7Ek5lMVkOiJ3ifa+76yZyDncB6NIf8ycqvXHcilhs3QnMG4kH0y5coNTp066W1MMTz4KqKCauV8BFe/iK4q3F37Q0uewJfP78fw0biI5W1leWVUNmjKupW2U+XSOjMatjyRSkgI3C+4uk6wHpPrNAIcOpeDtCwgMMrZa4DoEugGZavGJX5hoH47bwa3frK5ur8xmbdE6RX12yvadDsATbIqJMc0H9dyHX58ZnQ2Db5cpjy4z24wmLXph6Ao/vROkjKKMYIhlOmjMnfC++Yl/p5uKKUoGFPv1Jb8a3ZudavkJW2AsULRhbugEbFZwD6Dx8KvQOZxNKxHrBlSZY1cKwECTtxPwmsCDWNiJ9peJAE+PvRWKMMBFMeCfuXVBg4NE42dyYW1kWclV9UweaxyjxgMyjFigASi3IdXyNgMwByY98eq84fDC8UlBNMmfyMP0GlljsPrL/bulS0XkvXaNztz/T2+Arw7SJlcT2tyjfz7Vw6iNzubdr5vpR/ec+dJFKKFREX52z2zmW06Wz1GS+YtnZ9PPfglDF+nZa5PIuH5WD0H19WA2j1anLfAOZ4XBttLDCgfuFK3vGneuZJIJJn9c6ggE/BKyER9Ppacp9Gui8tW
 h/VkVzU9
 SqJ/1XkaQ83B/k0Pa/V3t4hTfbtZ/miGAv+GKOK5PiqUjrBWutFeeuI97u/3Z6c8+LDwUaXSCHn+pLhPXCU61BhZy7C2PX+rGt1/OeYkpHqeshQBt7DgfdxtLsyoJnAFy3J9/ijL+CarqnCe/c/LUEydU/s1YqJUTMS98oBeGmRVi/NJMDt1Bfs52wy9z5qbpenvUPXiWR2kpMP58AuT8MEDQsCtUJGG5LwXWIEnpvStyCRaNHM+xM50y3Bk93n3ndfxd2rR5sRq5Vbi56KwmAMfCZNF7zcOtaEOT
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
 arch/sparc/mm/init_64.c |  6 ++++++
 arch/sparc/mm/srmmu.c   | 12 ++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index df9f7c444c39..fbaad449dfc9 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2279,6 +2279,11 @@ static void __init reduce_memory(phys_addr_t limit_ram)
 	memblock_enforce_memory_limit(limit_ram);
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = last_valid_pfn;
+}
+
 void __init paging_init(void)
 {
 	unsigned long end_pfn, shift, phys_base;
@@ -2461,6 +2466,7 @@ void __init paging_init(void)
 
 		max_zone_pfns[ZONE_NORMAL] = end_pfn;
 
+		arch_zone_limits_init(max_zone_pfns);
 		free_area_init(max_zone_pfns);
 	}
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index f8fb4911d360..81e90151db90 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -884,6 +884,13 @@ static void __init map_kernel(void)
 
 void (*poke_srmmu)(void) = NULL;
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA] = max_low_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
+}
+
 void __init srmmu_paging_init(void)
 {
 	int i;
@@ -967,10 +974,7 @@ void __init srmmu_paging_init(void)
 	{
 		unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
-		max_zone_pfn[ZONE_DMA] = max_low_pfn;
-		max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-		max_zone_pfn[ZONE_HIGHMEM] = highend_pfn;
-
+		arch_zone_limits_init(max_zone_pfn);
 		free_area_init(max_zone_pfn);
 	}
 }
-- 
2.51.0


