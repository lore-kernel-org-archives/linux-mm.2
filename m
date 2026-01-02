Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 994CDEEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A83D6B00A1; Fri,  2 Jan 2026 02:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052716B00B0; Fri,  2 Jan 2026 02:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D7C6B00B1; Fri,  2 Jan 2026 02:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9AA76B00A1
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:05:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 896FCB89E8
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:05:00 +0000 (UTC)
X-FDA: 84286136760.06.C68FE85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB600A000C
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T7gvefAb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337498; a=rsa-sha256;
	cv=none;
	b=YpMQ+RGxvGr5pglV8UmS7JYctBvVQgS079S5DDc3/ph2kIbUaKfaBotQHNWYCVyvmKG+NO
	nUeTvrp60UNBf8qdWTrUaDH9+S/KCLPFsw/pQuPVHOz+A4Lzu4BUYK6onEZGlbQXa2eMrF
	MJE2nEar3FRzXzcfZys0eTh6Eudnib4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T7gvefAb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUP8A0oU4o/USGU4JF7iSIOLVJ/2u6llFeNZ4HBfxOs=;
	b=v2BAOd6+3atIZvl57azrgFymMExx8kTFBqRuUzI6GL1rYFbcz7YNgWRM6QrYKjOzcFUQPJ
	hWx5vFPNsZL7ODrj7Fczf5H81bVlNbZ0tUBnY0kxTqSZYBoYOH+2Bm1C9kcnqyQoKe+6F+
	53MFx2zGnaQFwPvb9G4woyeDHVy0NUY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED24960125;
	Fri,  2 Jan 2026 07:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DB2C116B1;
	Fri,  2 Jan 2026 07:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337497;
	bh=2fA0ShJu41IpFxgmfkKiNARLhjMIlJQdtqcPZZQwJv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7gvefAbqeIT5CvtwMrVVTK3a8rwBZYgQQiC3jHQXzpJtttvm2Q6kTJvhapk6XZcb
	 BxF+dcRK4sWnZDHuyEkhkSgVzVSkGMHcSd/3KadF+TMHf4PFBbT6C4ZlsbwfSZyy+F
	 s+tJoke565QPqUJ3BSWynVtoU3vWCNU4D0WB5cy4Pj6qI7fE42bh/vZ1QFMsek2t7H
	 8KgpY0BjGMbdV/PjHSJG1h5Rp2t2bV2PF7HizyPVMFjuPeL5kHGynDuCznGy7tyi69
	 sNqgANgSfgAUJSU8eV6M1uaFWSVde2/T7fCS5n7hNnv/5BeiutkN335sYt5mdY+Y0b
	 IsCntvk5rQtpQ==
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
Subject: [PATCH v2 19/28] um: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:55 +0200
Message-ID: <20260102070005.65328-20-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB600A000C
X-Stat-Signature: byno36axtpawkiu9yt934ph5oia4nnpc
X-HE-Tag: 1767337498-292334
X-HE-Meta: U2FsdGVkX1/ziI5lRG7m8AX/5L8hVGcG6GYhVBohgjKNqcOUcdaHd0/QunWY94hDGyEDtHPoBSdWhvHcY6Qwp8mUNxth6radH7O/1IBOK9jw6VK+2thUPNODyB0M483IjprGwl8nUCHnFfLeBQoSHBFV8JHMHM0VD1qaEAgBBFmNShwToPojQk18ZujPQVGo7h6v6ChE5mJYaNXUa2T4RX1VcTWLa1snT2CiAc3Dk0ICkHo/AigUmJt8wBTnqo4GDJbIEkk31HSddgNfrSYgHGaBhXeojcGMaKaKxP2QknUAZ4Lj/9PlPTxs4ZZnZi+HB9L6LDS5/eB3zUdl3+RwyMabJZbSZ4NCBOZ/IkIKSgfPNHB5kvoFIC0wccy2M1G7QXP7dO9gEMrhrigHIrN0Szn/mvih9pmW+Rkn2VrmkzrSYEHPFkrYw19m7a9SOnILgL7/OUteShbhxnsHuo5MXY41eKpaRBn22UWbFyKuw4J9K8L7cXQKDauL//r/e5VHSdJDjIhKKzMQ1/T7P6PTGyGwlmPyZedhjcahM9bSchPDprF2djLG2vju+gSPqJrbPMQj8ig6mx3yr63Q8T0eDDdsDTKwI090HleLlz+bYALnQPhwFTy8JQXSkLXntvcnsKyBZgJyf684RLbuQuggX1CKUC6pmnon15TorOq9/HB3CpQl+PakIRjB2zkf3sdTvoUapF99e4DVwIPuG2uNWC2xpAV0HSFZrKs2ACTVWg2IQlXKYXa0JQ3+MWTQudZ4sKhpZ7prWjIixwlAX9wlMx5+oSJpYPwa4sUdQ77hVfgvBgqq++n7AkS+WKjkMKEfWemAmFyH4NrZHrhv/9heYTdYZ/8pcjSPltpSUafNyAxY4a5i3tXWJOi5zlfwurhgnnyBSD2DbNhIi26pzBa16VsUNQkrCXu60ireAwdyWEJnI2SRWUTaWjo+Q85KxCFRihhHweup8VP+fUbOt8G
 DFa6/jZl
 294QkYbeNenm1hRAE+pAFJuf2HeM1gOUUacp6OOxQe6Opi/EdrbsDMcxplEiAXIsMSLLQ97AeOgM/v+Pad/DvGxUdleckSQsvm0tb81HwJTPtOtjdfOQ7QRAtvgKDTKbfATOiuF3stGP/JhXeTiJ4kMGb8AC9eUKZZNxPsIArpDnjgaGvl3kRzaYuJWvSosa7mLwVJE/CP4/O6nT5X+zEdjjw/dgwC5+7Au65YfiRxeaL9sMJEeerdnHQ2k1KY9Wdv/MWpssvQQBavtkawIPTLC6Gog==
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
 arch/um/kernel/mem.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 39c4a7e21c6f..2ac4e9debedd 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -84,6 +84,11 @@ void __init mem_init(void)
 	kmalloc_ok = 1;
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = high_physmem >> PAGE_SHIFT;
+}
+
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
@@ -94,7 +99,7 @@ void __init paging_init(void)
 		panic("%s: Failed to allocate %lu bytes align=%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);
 
-	max_zone_pfn[ZONE_NORMAL] = high_physmem >> PAGE_SHIFT;
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


