Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64559D25037
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B1C6B00A1; Sun, 11 Jan 2026 03:23:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A728F6B00A3; Sun, 11 Jan 2026 03:23:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954FC6B00A4; Sun, 11 Jan 2026 03:23:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 819F06B00A1
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:23:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22B0F1AC532
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:23:42 +0000 (UTC)
X-FDA: 84318994284.02.E3A344F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B444C1C0005
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:23:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxotzz0k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119820; a=rsa-sha256;
	cv=none;
	b=Lvn0esaS5Aea6wmp8QESi29E5kt9SBmMS6eXyi1ZLwpaFzGCu2zo4HuB4W58NMI4p9HkbV
	j/5Sp3qiUbInGSRGurgAdNgxyMMkgGeiCn1GLmCnonOJ3OhB/A7Y556/IqqG4TwMhJp/Xr
	xaO0ODA6fHvbOzO4J0TolKZGyu0Ui2M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxotzz0k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJatOTiXEPNp/W52LlXUaW1EIsFN/BNV7MmBuJg1xZQ=;
	b=lK0WalVfXj0Oc63RUrfrNjyITX2C0Py0aW9gtv0hflqrEdK7R0qrHQVrbCrU+mXBrk18ql
	eGzS31kHxTgL28KAqAy5LuTkU0o49Rv/8+cfc6wYwRBJVPnc50OJbh1owdidAOeAhCOy3T
	PCdjUQm6S8aH79W8ki/Mx9HuEb+4NrE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B13F60122;
	Sun, 11 Jan 2026 08:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A52C4CEF7;
	Sun, 11 Jan 2026 08:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119819;
	bh=qGV3crV7vYfN1DCsmhF37VWmOXuApg3MmNmGXJVotqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxotzz0k2KwCNp5gWh6cgEcUYH8E0BhaEKKXTdT2pUdivBywvI4T+qXqHxIZASCzv
	 1gDvHJBccnnzMaLHh7DBlSuaqDoWKk743xL7Oou07E6HNfZWS0zPTWLM4rs5OOguuo
	 GUAoxRtqYBs/qxZg0L3WKkhSzJKWvFzo7bwsjWtl2FO4jLNuQVwJYrxBJFZgt1ghP2
	 0kdmI1lYTpCBQUUqGWKOjqYFpVyhQUuN851OKnj8uy6V7dRr5kMl9pPSzvbRlL8i0d
	 I2u0gSIfQN5q/tcK4hqFkCMxPsVumAIFJF5vuk9i0Tc/89H6zAhA9SuDwA9yercaDb
	 vOxbNKYOZaN5w==
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
Subject: [PATCH v3 09/29] m68k: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:43 +0200
Message-ID: <20260111082105.290734-10-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g74z3byewu8x1wpc6y1mj7dpnwjpnw95
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B444C1C0005
X-HE-Tag: 1768119820-940795
X-HE-Meta: U2FsdGVkX19EmBpi9lDvdxx+Nqf2++HxiEjPmjsk7Xkme0FCjZuJo7U6rC/3n5TFeTelzRYjkK9CpOdmzqHi1cMmhrpn1z6CFBa5h+ZDbGPY9CD7DfTV6W0eyAU/29yBXicot5Qn1tW/9oZcUTx1Bwl8W6x8I6aczJatG7odzN77EhB79nXhnDDrKDNRLhzm8UtVvlRMsZy5hIc3IalIM1riXFmiTMZNPJ4p3Q/jAonvDNLGRwctRGFmhBqA2uIpyG0I3Hg1d/vCI+0EGhpdvHqE19q3d8G7NO9w9N7hxFyceF49g+Xem1XdrdTOKlLVQ/lsRWLpRJcvezO4Srl/Z/WfeJ+3xHHJHh9IVgy80yRqawzdU0t/QPu/jryn12lwUDAhWfZJSfFtTBcJUkJus3umpknm61Se5ECMSAOjTpHLorRJQilvrvTFvRmGzd1colJ5yvU0tiENEc3VWEELrGM/kwff+DZDJjBvVsw6knn0KN/nuJ18cSBzioXpMrDd9yEIbbFrJH5Y94FTiAozHJRykIsdkcav7yfvxtch6yxZGn52OJnL09gGVz3dbSn+pufNTCDTbJfOXrI4xG+FE20W3pkIPuHFWrxr0WxYHJM6VsZWp3xDhisSJiaAB+8QLxZ8kPy54dPl/MZMJgdK7YLX28S4hDHitKqEyeMxJQ/P3hwW3x41391b6C1AYR1SVSux4aFUO6Z62aE9BkNPWcXK4y2hiqbOajMZSBR4Vp/ykf+XAxC/ohUMjs71Q+XpphpyvJRLv9VjkkJyG3IOhyi81/6D+mI8nP8tcizjCw07adcfZHrhYEmOP8C0QYSukKp0td5MIT75hqZuhk2u8OoJSfeE0e320xx7vefD7RIulP4V2EvHunXrJb42yk66tsBWnfKafYD46w8/DyuPJlp/eTtYazWQYgEn3xtKZapQQr3EMjo0lotOcPVKyegrBtNBXhCNrpFzQstwPui
 mPVOMepY
 BLdVB1x9rvWt02YCdoJgGgYpK0UDEQJ8+qj6Qivn8o+n0oeqFN7U67+hua5RADOW+RVX/9cqu99QHAUY=
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

Since all variants of m68k add all memory to ZONE_DMA, it is possible to
use unified implementation for arch_zone_limits_init() that sets the end
of ZONE_DMA to memblock_end_of_DRAM().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/m68k/mm/init.c     | 7 ++++++-
 arch/m68k/mm/mcfmmu.c   | 2 +-
 arch/m68k/mm/motorola.c | 2 +-
 arch/m68k/mm/sun3mmu.c  | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 488411af1b3f..6b1d9d2434b5 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -40,6 +40,11 @@
 void *empty_zero_page;
 EXPORT_SYMBOL(empty_zero_page);
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA] = PFN_DOWN(memblock_end_of_DRAM());
+}
+
 #ifdef CONFIG_MMU
 
 int m68k_virt_to_node_shift;
@@ -69,7 +74,7 @@ void __init paging_init(void)
 	high_memory = (void *) end_mem;
 
 	empty_zero_page = memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
-	max_zone_pfn[ZONE_DMA] = end_mem >> PAGE_SHIFT;
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
diff --git a/arch/m68k/mm/mcfmmu.c b/arch/m68k/mm/mcfmmu.c
index 19a75029036c..24a6f7bbd1ce 100644
--- a/arch/m68k/mm/mcfmmu.c
+++ b/arch/m68k/mm/mcfmmu.c
@@ -73,7 +73,7 @@ void __init paging_init(void)
 	}
 
 	current->mm = NULL;
-	max_zone_pfn[ZONE_DMA] = PFN_DOWN(_ramend);
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 62283bc2ed79..d6ccd23caf61 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -517,6 +517,6 @@ void __init paging_init(void)
 		if (node_present_pages(i))
 			node_set_state(i, N_NORMAL_MEMORY);
 
-	max_zone_pfn[ZONE_DMA] = memblock_end_of_DRAM();
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
diff --git a/arch/m68k/mm/sun3mmu.c b/arch/m68k/mm/sun3mmu.c
index 1ecf6bdd08bf..fdd69cc4240c 100644
--- a/arch/m68k/mm/sun3mmu.c
+++ b/arch/m68k/mm/sun3mmu.c
@@ -82,7 +82,7 @@ void __init paging_init(void)
 	current->mm = NULL;
 
 	/* memory sizing is a hack stolen from motorola.c..  hope it works for us */
-	max_zone_pfn[ZONE_DMA] = ((unsigned long)high_memory) >> PAGE_SHIFT;
+	arch_zone_limits_init(max_zone_pfn);
 
 	/* I really wish I knew why the following change made things better...  -- Sam */
 	free_area_init(max_zone_pfn);
-- 
2.51.0


