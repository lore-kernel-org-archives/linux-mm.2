Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EE4D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155646B00B5; Sun, 28 Dec 2025 07:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A816B00B7; Sun, 28 Dec 2025 07:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F226B00B8; Sun, 28 Dec 2025 07:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2F146B00B5
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:45:06 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE95613C36C
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:45:06 +0000 (UTC)
X-FDA: 84268849812.01.5BD5466
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 05FE7140009
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:45:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxPNjOVV;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azukzfgsXgu/EZDimou0ymklRTxVzT+QThHCfbcQvB4=;
	b=7wWRcuL2S4/7x3PXQyYtKemEyYxCxsHcR/l/EhadrQnpb2fmX9CyWiyif6CU/yeWkrqXDw
	vDDN9+3GC7sUAS1F1R01Z3zc6foHiaKv6Am+FdpXsICKylyAVMMRGCsSB/pYtE2yX+1TVa
	AXg60x2aYHJZM1h1fvmlSdqGX/4aj1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925905; a=rsa-sha256;
	cv=none;
	b=LOlipfnYf0aIJfHOTrugX5PoptSSJHDSQODX/ZBRWLmyKvmSNi+zbplEiKQlXUFmfc2ZAj
	WBHpG648+F/WfdaOaBgCwaxiH1jEKo++x+4NDGHMsNF5YJeMgVh4m5JC80beCoehwKXWxY
	CW04+6QhDidHccV15oBpLvHuK9qRINw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxPNjOVV;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 284DC42AEB;
	Sun, 28 Dec 2025 12:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77041C4CEFB;
	Sun, 28 Dec 2025 12:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925904;
	bh=4MJzw8wq/vYacVlPos8SheQzjEj4nCDptI3YxDfhXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxPNjOVVd0StOxavRFUsVhEOWsAS8OrNcL7iTTpWZTXAvzmk8IqRe7bfh5k6lFUyv
	 8SQa4EeE6FYeLFyNhdG4wCVlnIfnaa5C3ZbZnS+pV1zmbNvkQ0JwMdpt7jWfVmM5Nx
	 tKzTB0VZD6MNq/AcBYYo/PYix+seShT/lM2/4uWm6Whjy8AqFAbCGHw7an3gTOWPoN
	 bHu1VKUJ5qIwVNKjw1zwaDwuA65JNBEr+b+0NrP+raiP6/vF7osPeWM8T0aedu6Jo9
	 RLrCGjKAcSbq0lZDjhY7IPyid/QSNKMz4Hpx3OO1IMo5WzR5M+p8pGf5KnEPcCwWvP
	 llIvW+yUdRaaA==
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
Subject: [PATCH 20/28] x86: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:50 +0200
Message-ID: <20251228124001.3624742-21-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fktkr79rztyjdy69huo8x44u6tg5gq8u
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 05FE7140009
X-Rspam-User: 
X-HE-Tag: 1766925904-816007
X-HE-Meta: U2FsdGVkX19052HVnspRL4iBHNHfyYljARppn5REL3YdZiChtNMi03Rl+y/0I/ztDmH4yD16hfArn8bqCrOt7wbvpNCzH0/FwGGCB9eQA2olJOnVeePWqrhcVcZDG9ydt1QYT6EMSs+zCdNNp+26ROpj0mvCUHYzmq8FikSyh3/zYfbOc8I1197/7Nz8MsmDFZgqGwvDBQFzXObyihXoUz1c03N2+PLQ9hYU1Hz4KbhfEPf+Z0AFolNNRCxAcrxYf7c2MlrG+fAQ1nljOqaasNz8Z/oEf4PgcaQlLJ+fm/3hevhdevbgt0YjziS9F6bTVRm3P0N2tZLHASSRG+WuN19RBlooYIW0231sFy0CxQys352pHXiUtDeji0oZ0oKqKtD3E+zF93co/kT0RDDOgIAxp0pkkPTxmFK9d7gvqDcRf7wf0txJbZW3knHs9voICNC1Y/4VtS1buLTzUBPae13LHb3irsg/OAaaRQNy1g0LiUnl86nlU3Y4v1g7CVDOnRqh+zkPNu81KSP/BXaib3HFmos0jwqNUNSNpOJcRADVwC1rnW+TKkSPJI+qrzbr9qjUJawpyoASqXa60iWNqfkb5wLN8SAyG/lkUGMwcFns0mRlxYL+mJWQ87vYUOG/8reTdYZQhbu2a8TSNkpgg9QNQGDlGfSbu1CpsHBgwVA4PUE8hpa7WqkUXGdXg7LFSG2diKlKrN7/D2AqBX4nAsN0zPlxHANLxTpRdjCONsd4UFC5/LNr8LVSqqbFZ+DvFy5AjE8F47m4Mor+5Pa/XbJWuw+Az7h5vQ4m4l2jCKqwldaYEdqxH0SD5Hu68ckOCl7CPPKrm2YEgmcbZRyKi/sckhgzUtXrQF8k9xA6jxS3s7CByZSYaOx61bzVzAeALNuhsrK4QzigT71vth8jfrs8qancO9WhEE2JOnjywE+OGGjVrUXVCp4Fe+idRBGQjLT6U5Q4W0zVxiyvOEY
 Wm127uUT
 LsOVhxGtweQplQCE4pxAROWbUyLdl0DbBncGW1iakhZ8PYbVoKcY9HmaEBVxxM3jhg8RRyfTSlNnPaOrlhbDaIt2bWGaepMQYGZ1jjYzNX+NPZIqXKnuV9PLDNW7EP0iloHjKKcpr8N03RON1yrI1IVIa082cF5VwM8W0bBGl97Y/a7Ds+tWHBVrKw3k0yQxCpG4eBPp9i9crv4hpdjG2WVYKMr+vo1qa8Dc4TIgi4Aq0r1goRWrFQeTJyji7UGo9EO6Qfscyunz3icS+DljkiWrmrA==
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
 arch/x86/mm/init.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8bf6ad4b9400..e7ef605a18d6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -997,12 +997,8 @@ void __init free_initrd_mem(unsigned long start, unsigned long end)
 }
 #endif
 
-void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA]		= min(MAX_DMA_PFN, max_low_pfn);
 #endif
@@ -1013,7 +1009,15 @@ void __init zone_sizes_init(void)
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM]	= max_pfn;
 #endif
+}
+
+void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


