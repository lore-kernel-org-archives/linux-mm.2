Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFB8FA372A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7204A6B0088; Fri,  2 Jan 2026 02:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA906B0089; Fri,  2 Jan 2026 02:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C39F6B008C; Fri,  2 Jan 2026 02:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C92C6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:00:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D94D3587E5
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:00:55 +0000 (UTC)
X-FDA: 84286126470.08.56754FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2EB534000B
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:00:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KFtENWfZ;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5gBzVEKGZBYJG6a1xNcNq9/H+kuM96Zeopb+7R3cQ8=;
	b=ukReatB5pfS4Jg2Ttq67RFOCyVyi/lazEFDZ6M090NAHxjgPsEtvPKrxcOqeE4o4V95DCH
	Z6zfmBziWpQS+5SQhqRKsas0HSJ2tXipFXsT4dSuGdbiQZ7UH6dCqaFmucPCnIlE+KTwMd
	b3IMX6QSE7fEz3yrdARKF8XGGmy9V+I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KFtENWfZ;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337254; a=rsa-sha256;
	cv=none;
	b=1WiyOW00asDs5obTT9udhK4972ezuXqYYmnwVV2L+1NBXaW2i5OK4HRYH1W9WXBQwkGL3F
	6XK82M8z2v5JHhuPherUrz6br67d6LV+m7kqa1LdcNojtujC+dK2c4oUaJbfAkZf264Yph
	avwwgKVxDDeCLN1kRqk06d9B5VXjChI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50E8040427;
	Fri,  2 Jan 2026 07:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559E1C116B1;
	Fri,  2 Jan 2026 07:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337253;
	bh=2qjSzGfqzjt078/1pNLigg8dFf1Az5AvC+tppJFEDck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFtENWfZMb5TuBecSaQ0Q2MKmCLGH6v0QEHKZX84IK3pfUhKBgywnosKCmB3W8t5G
	 qcWLiyjLanC80Ehh68T+LRGobCK5j+EiNBYYTo9i5Ro3ij20PlWwmYaEeA5Mg/BRlM
	 rWyLBz56EX+UilXjE3gFlZ/lKIaI8dZPKh7/iKGLvHv9ZuEVr5QQ+4HijugrTlBUnZ
	 Od+g+b4g0KkQvzKkwkMj8ljvQhVaDeKMUNoNtRXmlkvL1fFF1X5M0F7Appw6K6doqh
	 /hOgbN29wpQg1mVHUojuz3tbEcMj91u7W5GWcOIXlcs4d2WmnOPBmBek/NIXhdQO3y
	 GPAEZyHonWkAA==
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
Subject: [PATCH v2 02/28] arc: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:38 +0200
Message-ID: <20260102070005.65328-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y8ispxz543p4u1deqnsh8x7ixusuzkdy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2EB534000B
X-HE-Tag: 1767337254-564715
X-HE-Meta: U2FsdGVkX1+9bGlCYhkJTjAL1tIfwbroVIUVcXb/5vIxZPDy0Ea+VUZD5qDtOZPJ2zhUMiMzrvhxe3Z5uTcJMQ/aN9mv5YdGlMOEwm9GfTRJ3YQ+8bjSlF6evoNsER36hUtaOwM8Bxe/0U84SkGFSac3UWopMaf3Ez8LVd3YT67oZBhnGlZpsUoSSvwWhIS5T8OZzXAPNKpitpv1UHfzxP8NvVZDLxU4uiSZGg1cMs5qQyrs9UYMkf1/87g9rQvYOXjgxTULRRUnTBYxPAl9iX5Ed5ib13IyRtqYzLhn+5czDlVcEVeaUuDMGhsmqzuZjY72aB/PHoAI1+mTSXWevR+hilxaTiA6R6ff/rgAYj7OReiFxAYSbVLQXsUYxF0jYnL1nS+435X7O2pFquaWFyBQiwv1gUus/MF5SILW1taSuFkDrgDWWJafrOTaKQuh5OBxvv9BG3LVJs9XCJgq5+URFhcoPgkqpHwqybiq8n1QMeipr5T1S0L+9nNh09wdZrghHf59VooQ5CBfPz4D7J0nzhxhivkMnQEyWrmM9bSor7R6yLQnh6t08YxWYuNIH5egZhR6ZBJ2D5BUJOuR19YjMKldVIRM8Y35oclYctrTyY20w+8zvgoCqiWdBLKP2b8X+MnRZM0821ENGXktmHS26gR+65UQqYg61EaQroZiySgY722prpQJSyJbePptOybUDKRohCqTBwHU9BQW5VUljs4VHRkC4hYjJ1VOs4guTzv9lMckeaeSiU0jThbfDEcMqDS/VCSW1dpc7pB8Uzr7sdjcUgHWQWvXcZNOu2EMGSA+1Lfj1nENgKEeLhXuuON2b+zW+MimYPHjNleBq76Cs3ddaG108Vl29UdReppWDutYTt0R5gY4DvwFz7dI/dCtQ4MboO8WM3gCVQn17NdmJf6xgwQwDpMSvM1ree6EkMQ6pmFKYfKSFTZYXXJH94MqC6FP8gKqPZ97fDs
 lRZ3m5vU
 qRZdi3Jh8vbwIDXF7pvj6VeuHU117EMizjWnt9hD42dJ9TJWknwywBcuGt0Yd0O1AxKrGLv0wO407c1j8h0qfV8pgDuaKjadV4d+fuwYUt4vIkYuNsQk9/lDJc1b92WBOaR4G02TQJRwERNQN5xh3X2Dsz/dhuS+7V9OO/gINO0Qiv7Z+QbFm/z0zW8pAXYl4coGIZDztawyXlj0cTciwJ//fVbrBqqAkup+bnamB2YXI16UZ1Z5b+A7evtdp+r6N8LfoAudSvC/nTH1C7JrN+kSM/Q==
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
 arch/arc/mm/init.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index a73cc94f806e..ff7974d38011 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -75,6 +75,25 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 		base, TO_MB(size), !in_use ? "Not used":"");
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
+{
+	/*----------------- node/zones setup --------------------------*/
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
+
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * max_high_pfn should be ok here for both HIGHMEM and HIGHMEM+PAE.
+	 * For HIGHMEM without PAE max_high_pfn should be less than
+	 * min_low_pfn to guarantee that these two regions don't overlap.
+	 * For PAE case highmem is greater than lowmem, so it is natural
+	 * to use max_high_pfn.
+	 *
+	 * In both cases, holes should be handled by pfn_valid().
+	 */
+	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
+#endif
+}
+
 /*
  * First memory setup routine called from setup_arch()
  * 1. setup swapper's mm @init_mm
@@ -122,9 +141,6 @@ void __init setup_arch_memory(void)
 
 	memblock_dump_all();
 
-	/*----------------- node/zones setup --------------------------*/
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
 #ifdef CONFIG_HIGHMEM
 	/*
 	 * On ARC (w/o PAE) HIGHMEM addresses are actually smaller (0 based)
@@ -139,21 +155,11 @@ void __init setup_arch_memory(void)
 	min_high_pfn = PFN_DOWN(high_mem_start);
 	max_high_pfn = PFN_DOWN(high_mem_start + high_mem_sz);
 
-	/*
-	 * max_high_pfn should be ok here for both HIGHMEM and HIGHMEM+PAE.
-	 * For HIGHMEM without PAE max_high_pfn should be less than
-	 * min_low_pfn to guarantee that these two regions don't overlap.
-	 * For PAE case highmem is greater than lowmem, so it is natural
-	 * to use max_high_pfn.
-	 *
-	 * In both cases, holes should be handled by pfn_valid().
-	 */
-	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
-
 	arch_pfn_offset = min(min_low_pfn, min_high_pfn);
 	kmap_init();
 #endif /* CONFIG_HIGHMEM */
 
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


