Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE07D25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B5A6B009B; Sun, 11 Jan 2026 03:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9826B009D; Sun, 11 Jan 2026 03:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2136B009E; Sun, 11 Jan 2026 03:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBEC76B009B
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:22:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 629DE1A03C6
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:22:57 +0000 (UTC)
X-FDA: 84318992394.03.FE0774D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A7B334000E
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:22:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWkYgxC6;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYVousDSpw+811qLPmYYO+fHKcpA4yVaAONn/C+5QeM=;
	b=y/Fd5z98ZvI6OLIrXtnimKRS6BoCwZuY4+sKcVpAQDBgqUe64CumpRHWpUw90GD5v+TViN
	92ncS3aFMWQ3uKYe0LWOd4xqJmXQHj1PM5hh7i3be4MC4n3p+8juffu17cWaoRrfcVcHvf
	vNf5QMtC17jcjxlKNW+Er7AEa4eknL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119775; a=rsa-sha256;
	cv=none;
	b=JP32NbI/qaJeICh9AScwamakLNZ4ELfyfDqEd4KJE062tK0HyXad1iGkgpq21+nEMw26xi
	qZ/1B9fX9Xkx8ti3fMEbSZhE698eBLaBwGi34WinWtdG27BMIv60dHfk3nSku5Di5i/cqI
	tUvALc8qxwXztzEFAIBtRFZFkArcDoY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWkYgxC6;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C3CE403EA;
	Sun, 11 Jan 2026 08:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94FBC4CEF7;
	Sun, 11 Jan 2026 08:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119774;
	bh=beem9LtRR1HHqRgL6PattJCY9S8i8ATD31bTRr88sn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWkYgxC6u+l0vrWaonlzQlH5gQLB1FcuycynoPybUPeo4dvv7xXva14K52XEy7LMX
	 8fRn6/84WfNTIrDoAmNlHQTW/sq2Pp0UvtLIoxegKGm5e5j8XBH8kTWEyosbpzPu1q
	 GoRhJ+7+SZo6hD8Y3ZBI3LqbG2tt3rcBtbKpr2ZF2pWHt5tS0xJP8cvo6mcyroAa1S
	 0OeHyObWAKeISSESoLTXFOmsvQ3g1bLJpnbo/n+CQ28Ki4o90ppc7XGkpZP80EOCDf
	 Ve35dstEOEfIY1ywzAqMno+GXmIRLZeaDmLNIieGH2xbLUHJ4iNHvRWZ34zWnwrMFy
	 N9SXP8FFel3AQ==
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
Subject: [PATCH v3 06/29] csky: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:40 +0200
Message-ID: <20260111082105.290734-7-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7B334000E
X-Rspam-User: 
X-Stat-Signature: axm84xf5ora16pigcusofeqatoc9uxya
X-HE-Tag: 1768119775-528518
X-HE-Meta: U2FsdGVkX192+7ZcynGAKB7UQmHbk0rGRrLf1ygF5uXUf/6Q8MTE08vYDZJL8hSEquE4R+GDKtXvWuSI67S3f8xeWtRLfpHWXJF+6o89vbVfQ1h018z6HzmGzYtKN84ToN39pvYbTOKbV6PW8fyZs0Wb9YLIcWFxjAf7qO1ltOz18m4WYsjLp/W2oi27vKKeb3nw8lygtWQTGDSzceeF8QdPplnCCP0/HOkoRHclPzX+EOFCja/ZVNUz4TEls6HAcXDyuD9JUO2nJSi2YaYCkwBD0ms5i4ZsnNHgMm/D5Vy3Wp4SwbmqsSVEvEo4Ziz/mbBuWjXSspebexH3SHFQUqnqpYQoQAQI2tbx7rAwguE1IH3clow1rRe6cLdotOD/90fld84OgkJZklfR7hVmDVMeHtuBJVYp7B44wwLT7GSF2ZGk2+5MPftDXfBMvAcA5bkoh31EMc3XI0fMDvVYXLGx4SB8/Y/g/jqsuA3g+YRGWgxkKOM0OU5nl04WyU78kSqcE+oUDY8r+Jsa9mr4o68lH9m9zXMFP5LC3qXU50kKW8lhJNHYC/uO2mSK6QebeP5NytN+P4mSn/quTVP1X3UX57BtLn3G0/fpz8XCPXnSPt/ZslvlXyKAxl4H2c5S+puwgQDAzkOQ8yH0Gi1/SNRGzGcAQaxZQ9+Pyd+kLp8gf1IspqfZlTffc1Ut/pgR4OAwSF8L1Vx4Ch/Assdnasgl3yvXFLO6bim/XzkTf/lhFvfbCTMsodEMB1V2eHKoFbCZQnhSJykqpbcI0XDYKWh4bTmUQLQcxJlpvE3IlmOXxKX+jhF9X+5PM5f6C7B4h777klO3zId3o/tVeyFSuJdNlzkLAjIypAi8azPsYHV1z7VD3+B2nt1WG1yzfhkWCBXZrPsEn1IyNK6WbNghMbbbCYinaqMj0hHgcr1Alw+K8tMiEKwHhkadKDOH6V65h+UmTKrx5i7WwT+5RXr
 w80v7Sb/
 d1Og87nSXAudTRNJLpnBduRweitQpOEGPVss5BARyWV98egJ8b68jEK6IgDSOlmc/5wE8tAhDOziEbHUjbr8tqDcW6rOiX1NYDP2BfKTd+jBOY4tvNxWm2erX82BDwlIUJxCond7SNkAyK6ZhV6JZwkbqe8lYkk/fcKqypohxVm7SCrkpZViyLRksLaiVBv8bED/fIqM5uqQ5VXYt2x5dkbAh4wEqc2V/CC/pFV4x6nS91B5BKVoGXX8H8xN4VxJAtR8Ws3SdaaVSS0a2rHgkIYa2maFYU6nWYRTt/6JleUoS/U+OvemRXifpTDlvanr3SYEwew6BDxnpO0lW/nFY9hIAxS5gu5/uhzz5
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
Acked-by: Guo Ren <guoren@kernel.org>
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


