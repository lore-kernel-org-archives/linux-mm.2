Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A5FDD3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E23B6B00A0; Sun, 28 Dec 2025 07:42:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD276B00A2; Sun, 28 Dec 2025 07:42:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFAF6B00A3; Sun, 28 Dec 2025 07:42:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C59B6B00A0
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:42:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 212D9A4677
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:42:32 +0000 (UTC)
X-FDA: 84268843344.21.30281A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 80E55180005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:42:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHJ3dbmw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925750; a=rsa-sha256;
	cv=none;
	b=bJlvFYND4tlrGKJSIfiSH5m8J/PS7LVOwKp4piTSQrYH8ykivCoTkgMjkhLbZaBxN4qRP4
	OA+jGVyMBt6CAZDR2WR3BqXnlLAiTAPVT6w+fwoGrzUUPHlOWBiKprYIo9PHOZsbsBl5JY
	R7JGddPranU68l7A8TRBgvEzm5HLyVE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHJ3dbmw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyJA9x7hsheLXPu5a74j6NhGqDdAk1HT6a+T9hWh9As=;
	b=Mmg4tULfMirNecvhrQDbLMF2fw9ekbEZ5FAcAIdlkrvNjP8tLfIfl5rpGdARYh3iyAEbFX
	mWdXEiR1eHp37NmkW3Zifq/X5orMHop7pv1jQOeq0s8+lCkKwQbWDaouhBzttiDHmq9sOy
	ZLNl5orxmm/B3gAs23oPz9hFaDu50wM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3BAE600AA;
	Sun, 28 Dec 2025 12:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E4CC4CEFB;
	Sun, 28 Dec 2025 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925749;
	bh=BaQP+Uyb/5HYpSHuMHqe6vNV+NfiesFf3EGC4lY1beM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHJ3dbmwdf8ldQjTk0Sqet4jPrQ6QPN98EKtFOZ+ri4TC9nLH4wsY0AVA3Q7yL5VS
	 /dTR4e1hOesk9QVpWn+uOwXENpCC2QvHB9dcDFkindEOsnXEKyncHyaC17TfsHkOK8
	 X0yBRV+QP9Enh1lPtktzHe0GdlxaK6kqqC/MvkK+lzrhYVpVcWJ94HpYKr5IifvxkZ
	 7AGwltnT79H9sqNoG05NWa8PNTe3BDb41dNbfWE9ej9Wzoz6P1vr2c6Q1vAOzdd4pH
	 Go8shl9og3tFXmAXVQdxczrbgbU79HqP3y8rKEazgg3UyT5b3Bxk0GSNom6qnUTthP
	 rIDtO3E03AMGw==
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
Subject: [PATCH 09/28] microblaze: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:39 +0200
Message-ID: <20251228124001.3624742-10-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80E55180005
X-Stat-Signature: kw6966uz9b4en5wtcea5do3kanbnc4z7
X-Rspam-User: 
X-HE-Tag: 1766925750-550832
X-HE-Meta: U2FsdGVkX1+rpbt2+19uT0vJFJuerscf6Prpu7pII1Fv9j8Y20ZYmlrnoqvPiRsw7WNKvCctoZQw11x2655xjaYKOPUKadt+4mlsYd5A3/EjN5n37T+uocpU5XHLGFOxs+EK+fHjqqIf7KHURbbErZxu9bhxiQzZ/G4Tbo+h6aW9GSisvFn6t9UW/zmJhpZBQ6uxGIlvJP4PnWGrBk+jvh8WqEaQDTr1rSARtJ10N9udRM4X3liuPgtSwXwwEDmQQXm2NjpWQJORypgaaBIRHFFXcmTe5bqgfxA+aXt7mHuPPMzJmF2ymfvQq/Q+fwqvc5U+VwEEcjC21UQgFpwL1vEwG2AZ9kUduymXSzyWIngGHdxLw0qaP0AGyRbp1NBK7nuhxDbHKmuvHuXWE8wgwFMcgvk+GUQx94vBK38fVjDBhkjb8x8Yr0MsWv8HPmNOtMD/YSPHmUydyMC5s5RvCE9N9Px3pkV/yAm9OMt6x0WC+wnlOVnpxT+NzCUl3WSdEr+C81xboRAgGloNsqaXEY8JE2PF37DJp6tIMFt9EALmoae3PE0UCq95jlAhIl7YsumKwV563JPOHWmANRIo4bfBdDqodlr8wc1VHfAnWGvspNCHBrYzNeBXp/Kqs7Q5MW75IGmQ/E6EZezguSZS7hBbc2Ownw7D4mspH4gFvMbW4X7O0aqbuZLreBz6U+G2FTHmtW+AQSl1i2nD6J2VDWJGuqIHigASWY8nlhS7fDbYTwGar6lUuMdwQtpr/fo+HAq+GldeDaOrGMdy+7mW5lP6Va9m78JPxzi2z2kZ1I2tnYyng4UQHzKNRidoRAZkV6iSOhrrh8HEv/rE3zFkoHvNOo+5Zv1n8e93kJ/3qGnCyHqfowWTMPiOfiu0IJL6hZTk/WfQRG5hN397KJAJ8kcudoWL3PUngbkd7M1H5z09In3oHPK+VQjnEkX5K8PDnbFkcf/sy2TAY6kIyyS
 zybEblTz
 jeR7EH/DGI5nlSt+XUnZ3y0eJUUyfgQ5nIEXCbQ61xGOgA2Z0Iu8D1N3P276zb+xVUm/4R7pusYOaBxq+dguJDY+Lx+WR6Zo/yvsrNl1n8VDICNiF2QsxS64cheaEtBb0p6TSo7SRE+K+Eh/DlVG3NsVURw0eIvti3j6vYq90pnxHGJU4PW/RAZS7cmkifM0cwD3DdwHZBn0qFa0RRoHI97I9uYSI0qTetbchkjCns3tU90XJ5bh2Hve1+Md4IqwyICAr4a24xQLT4ajPZ3Zw4728DA==
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
 arch/microblaze/mm/init.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index 31d475cdb1c5..54da60b81094 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -54,6 +54,16 @@ static void __init highmem_init(void)
 }
 #endif /* CONFIG_HIGHMEM */
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_DMA] = max_low_pfn;
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#else
+	max_zone_pfns[ZONE_DMA] = max_pfn;
+#endif
+}
+
 /*
  * paging_init() sets up the page tables - in fact we've already done this.
  */
@@ -71,13 +81,8 @@ static void __init paging_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	highmem_init();
-
-	zones_size[ZONE_DMA] = max_low_pfn;
-	zones_size[ZONE_HIGHMEM] = max_pfn;
-#else
-	zones_size[ZONE_DMA] = max_pfn;
 #endif
-
+	arch_zone_limits_init(zones_size);
 	/* We don't have holes in memory map */
 	free_area_init(zones_size);
 }
-- 
2.51.0


