Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7551E92724
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56D2F6B0095; Sun, 28 Dec 2025 07:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537EA6B0096; Sun, 28 Dec 2025 07:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A6B6B0098; Sun, 28 Dec 2025 07:41:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3569F6B0095
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:41:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E45E9160774
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:41:35 +0000 (UTC)
X-FDA: 84268840950.10.5D49BD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58805A0009
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:41:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FfgQ/vc3";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AP0KxVQKlHlLZzBbkI5QvPGqFtczppI+IyG+yF+hUQQ=;
	b=Uj0jnk22IfT+yJhTNyUUfIi11J5z6eLKg9BZ8LMDbul4qu2WtR1U0aMXeLNy6OXld0MuhT
	3dbgcpCA0YE3cTkMpzxkliC455654KFyZXTmGRJc8MCQzcT4lgMxAbKykplUWezn+Nc724
	pNvg1wS3EV5jz6qQiRrbDqAextYgJ60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925694; a=rsa-sha256;
	cv=none;
	b=nN5l528Aj9VxX+A3xsU1OqhXBnGVDNAfWQZ/uGM9ItA2vQzNgtkZXF8V8AibDLcnbv3YKx
	A0Ku7K8TI6j/ecuWvDprlHCbKVr9ydE5UljB4SS4b3Vpq09TZFItFM8P16l+9UO5oH4b7F
	K3PoQiAzZJi1YlqiY3NlYimhSNlmtaw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FfgQ/vc3";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA2ED60055;
	Sun, 28 Dec 2025 12:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4327C4CEFB;
	Sun, 28 Dec 2025 12:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925693;
	bh=kW7jFO+a0HNCHZzYrQL1gmYZj5c/PO8Gu3w/sSZkgeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfgQ/vc3RZBoItL5pKlOQ6mJvnoQsAGeqpPpdU7zRYHFQGex7i+QdZtMRI3l5Rllw
	 ZrLFvQk9qtWsq6RxUpeOr8prh4q/CdhYAqVHvRtRwVjHkO43GX/qFXaS1qVYcGb1FD
	 qzL2dObl3ki9QvEKg33KBxrNT/j6nPYcZooual0AXhe3vFD8CcA+OOiUuJx0mf1OxA
	 WVLdUC1rJWxouQK5crZX45MUNiK05jCNTvxIYRAmvOUlz7ERTG0JunqJxBP2amG0TG
	 y7+4AV3PANzMZAHRGKed6SN43VGK8AUvIHNJN3y7KKpPCFNAO3P3vfptV4kyFay/sY
	 pPa+fs43iWi4A==
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
Subject: [PATCH 05/28] csky: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:35 +0200
Message-ID: <20251228124001.3624742-6-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rg5jx8ddyzepfsnx45whw33b1hb6jnz1
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58805A0009
X-Rspam-User: 
X-HE-Tag: 1766925694-679488
X-HE-Meta: U2FsdGVkX1/aGApxKuppDIEMKdDzQFj5lx0aQ++0a91ekflg7JI0Cxxpx8dDLgXnj+J6/qPzNWv4CNoIK+P02JftxcC5AM+egdioe7wmU84iSBmxPhh366IYpyR5CYvqDYNz9nxJrMReCtS6/Fbq8wWFnWkbSQDeQOAKpe0i5jVF/5CmultFpPmofoyEko0lU+SuWvgIBoc/4Fwznd2RFJlPWcwy6la6krUjGeR1nOfKYZ22Ko0uVa69cbG9JEDU43iCFnH8QMoRE3cCGrxysl69a0Wzd03ZknK6ffwoD4s97uUaT4xZ1bWDBZY0NwuOIMAUupgROm48QpJ9gN1z/M7H3HsWGL2nkSVqcguBxlM7JjLOLvgXm210yE9bfkhEUbDLHHwdzqiVbH0JihZnL/rWZ1cTIAquNdso23vPsEbbdQ03x8ZDpxAMoipf5FWRMCoratJ3qd4J1z1tDfia7kSZijDsnbky2kSIVdF0yAZIuVxgiqTGbYtYnUfMuzy6UjPrfwaoKZ4Hz7DMpvNdsWGyLovnnIUchu6WIHYOAStIVAig56jIG+lM375S7UsodJmfXFMo7xrwRfAiQ7qZmxoShVUc6o1nOclpzfCYVs0OQIx+fyPqZLffX2HGIUDT93e0A6RBa1e26GNJcYe6p/YkzX4O5S2h7njUwKN8UtAyahveQam3Ccdg230ElkYsGGkfMKRkBbug0/6GcZtOFPKbKgE0GAWuhdhEkG0DVfH1NjS5ibfT9BnhWfYYKavZyj5X5fkYW91Mb3EVUMC/15NN20spc8XQBikSldwuAnzOPMZIGRJ48JIo3WM8Cj3MQxb/c7U2ZFuV06oeBmGQbIFymjuTPFwIw1zmF1EN+eQdc+Lf8sYYH5y3RE6yIHq6sMhuqrmhNSDBrAHU0/Uy0kV73o6mokZUiGfKE2dRLi3ivQ+TMuZBgZE6hpA0uDQ4fbeAE/5ZTKAB8j7jgRE
 ukezqi/k
 gnLRsS/GnmvOU/PVOyq+hGlhpDJmCQTvh08zcj8KWnhv8fppRVWbQDLqAMCMrGoMx9dNfMP7yxRZpS20qkJrjvq8exbNIh0I+7n6u0Hzj9jXDHL7fU/wz3OD6OmXtYMSd2yjCUqHcZC+8nmbENUiNU95LVkLaQUOHA8gEoIJuRtgrEFnjMc8igAr+ZaGa0MLhpjJmya75pj02WJriCHN2CUHA175x4ER3GAYroxibQxIUzA8OnA5DtpBt146BXDBACUqa2E/hbkC+2jG8m1WUWvnVWg==
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
 arch/csky/kernel/setup.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/csky/kernel/setup.c b/arch/csky/kernel/setup.c
index e0d6ca86ea8c..8968815d93e6 100644
--- a/arch/csky/kernel/setup.c
+++ b/arch/csky/kernel/setup.c
@@ -51,6 +51,14 @@ static void __init setup_initrd(void)
 }
 #endif
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#endif
+}
+
 static void __init csky_memblock_init(void)
 {
 	unsigned long lowmem_size = PFN_DOWN(LOWMEM_LIMIT - PHYS_OFFSET_OFFSET);
@@ -83,12 +91,9 @@ static void __init csky_memblock_init(void)
 	setup_initrd();
 #endif
 
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
 	mmu_init(min_low_pfn, max_low_pfn);
 
 #ifdef CONFIG_HIGHMEM
-	max_zone_pfn[ZONE_HIGHMEM] = max_pfn;
 
 	highstart_pfn = max_low_pfn;
 	highend_pfn   = max_pfn;
@@ -97,6 +102,7 @@ static void __init csky_memblock_init(void)
 
 	dma_contiguous_reserve(0);
 
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


