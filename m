Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F34FD2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F166B00B7; Sun, 11 Jan 2026 03:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9C86B00BA; Sun, 11 Jan 2026 03:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED906B00BB; Sun, 11 Jan 2026 03:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D40D6B00B7
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:26:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29D2513A3EB
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:26:59 +0000 (UTC)
X-FDA: 84319002558.19.3DE0B73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 718A740002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:26:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tHSEbt3X;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768120017; a=rsa-sha256;
	cv=none;
	b=sSctS+bD6ys5aij0XYhR0G87F8MN5slbVBn90JP4GDmU7W77caXc0x0xgCXFJQGvm6nveg
	3XbhxYiyZqcEdXschUD9S47zRbmKNtDETD1iF19ZIxLfAYhtK707s5oFOfXm9WVhaPc6yy
	d4GZ1CtuSMWJHhnHjPGqufAQRBBvsac=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tHSEbt3X;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768120017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1chzHxsrADOvWvHnGxP4KUnDWT2YzEh4P+Cw7lJ2EsI=;
	b=uqOk9IBnq9v5p4feJdjUq044/Emk0OAmE+2oK9q+GdXD6dV0RpyfQahy0mTbytai7IX/Kh
	cmZhyVEQg8+SfUOlKMWpupQCISviQaKdVbSWVK9vbG0ZDL4GIffUfh/tkwLKxBDU2SwaC2
	wPqk4+ghLsN2E0dWh8dkHjTr7Hm8Ntw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9725643354;
	Sun, 11 Jan 2026 08:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7397C4CEF7;
	Sun, 11 Jan 2026 08:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768120016;
	bh=RfrVgNIj9rxp9R6SGMWNq/5X+PJ8wzbzZyqbje0LIeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHSEbt3XxwesdgJT2Z++WyePhEbkb+nyGlySy70wfQIT+pflbmIM+GlvXBDyguftQ
	 2Ys50/4b35j+sjd/5kOOfnQe9IRS62imFv43uLXTkPi7zlQWDQJhP0rM0GConiSwLT
	 YAJe8G4i0PUEqA9Vhb1A/zxzlCac1EGJ3SkmyzE2q3wvxKzgQrYsEr/jdyruVb22A0
	 3FaETYR9/LhyCiHKAf2u2gJBT5CTbGbIpUbNnnC3z+VpljRwtitYbbzQu5H2ZQySmf
	 k5iK+NQSGRChTUOxlwP8dr8FwmdRY2QLpmlxVejSsecyS6O0WhjimFYRzzvIKoB0dz
	 r7d4tanYl4nFQ==
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
Subject: [PATCH v3 22/29] xtensa: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:56 +0200
Message-ID: <20260111082105.290734-23-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 718A740002
X-Stat-Signature: dkm13u9us6owychfdx5xi5jiznynrxmn
X-Rspam-User: 
X-HE-Tag: 1768120017-983652
X-HE-Meta: U2FsdGVkX183U82/ebgAqcXfp5rpQLx+WpQUwNqqVU/70kk0ibt9n6yZ0F/kP/ut6VE0kk6g0zAs7UrO3Yqb+ZYy8ONLZnI8vy7ci75YKcaS9wpy1foQFIfT5HxsuFMiGAep/4aEqQfpHQPiYFyKpu2HR2mRX8Oz1iXwQ90CKpdT8c636tglgUSvc65injRkIbWZGOdZWN8z/ipdLIhbe5bH4yp69hqA+nM2SIBuB4rjIZoMCzoIFmcqaHATP2v2d6pQIrLADtVCCPg6HmqtSpmGjTqZMwQM2W+oO3kwK87laLKZwCFrqrw/Zxzb3f1pFLbpzDmDPU8wxCl2ZEcALLGg9enMhe3XSR20UUVP6q3IifuXbKSAXVXr49cclMOVWHNUYLEmtL3bnY5AsJV/KcrwQseTfiRG7rKbsedLaSIxkXMPQndTIDLEiv33ME90PmH6vZyznttOM8SkVgqOlQNu5l3tnHbdb4aZ1MDFgKq87Eyir9b6CoepdfBqEd2CqTN6jmi7PlBjbjPFVhAJrblv2wNf2B3eARCI7LxeqzMJYRhgoDBXTMv38T2tLn71nKolDezt5+4jrFlYnSGQRSiHRdbZrm5ZC8sI62Y7SsZBlhilFxOiq6oyPeoEvLnUrk/umv4Xlh18JQi8iKKyX/3qFpPKqR9Tbfri0I5hpvUouvTs45tWA84Z2cXGEqpPaKKpFSHaaRyf0mDZPFaiRLhRLIpotJCfiQ4ih7uE8MtXUknv5eLdTfIcxrDd+LzSKv8IDmSKMqEs4XK/QZ8VLBK07fwFSqh7rEURYpFE8rnVjOtShARH3N6jvRftaZY9UUQ4rhDO/xvBlU7QFVRUgurTv8cRLQ6nFOQl7YbS1hnEPZF8VgEReVKv1/20lcAdBwJMssk5qkXYxbbpUB9rahxdXBbQTQpHhJQY4hGr+/FGiIw3wf1u3FSMbOEuMJPrLtEjduZIrBTpbWpyXpX
 aCtQHGqt
 3WEQdhxhDMuDulOEElFGw9zwsXRst5WyXzvSPn/jMb1IrjqJu0F5+M3sMgEU7IN05uuTd+lRQS8Q18ZHNIiYJs/6nwqsvqfbdWYvIRUF4Jru2pGcUatQQJNw/7DlMkKLGXOEnJ/y04kzekTOslKjI1eqRlz4ysGPM0Pdu9fkz7gYQpksGDkqVtWtc/+0GHOjw+PM6CJQTAAqiQ7YxNozu9P9mV1cY0yMmNA7S+kdJvoRWxMNGWdoqwJIN6ycPtaEi5QagiJD9XX2YdAYe/CixsfRm+2Qvt948nQkgsmk/FAJNwGbabB0rYiH3kidOa3GladYN25Rhk/yAylAfxmfgQGXyjACfLH7FMYZ8
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
 arch/xtensa/mm/init.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index cc52733a0649..60299f359a3c 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -116,15 +116,19 @@ static void __init print_vm_layout(void)
 		(unsigned long)(__bss_stop - __bss_start) >> 10);
 }
 
-void __init zones_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	/* All pages are DMA-able, so we put them all in the DMA zone. */
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = {
-		[ZONE_NORMAL] = max_low_pfn,
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
-		[ZONE_HIGHMEM] = max_pfn,
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
 #endif
-	};
+}
+
+void __init zones_init(void)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0, };
+
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 	print_vm_layout();
 }
-- 
2.51.0


