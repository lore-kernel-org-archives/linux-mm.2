Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8F7E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E569B6B00A6; Sun, 28 Dec 2025 07:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B4D6B00A8; Sun, 28 Dec 2025 07:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D746B00A9; Sun, 28 Dec 2025 07:43:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAECF6B00A6
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:43:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78E3BB9150
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:43:14 +0000 (UTC)
X-FDA: 84268845108.14.A017170
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C46E3180004
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:43:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrkxuRje;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925792; a=rsa-sha256;
	cv=none;
	b=TxvLF3gujtasV1DLO1Nl1McqIUR8Ye4OTuXth7sd4sIbnlP4lk4lElklFgYLzNNyhfSCXx
	ffq6mvFJQTabrcKi7Xp3Nm6QglamA8IEmtsE1GcfycqyggWY0OUy4JOezBqvJPDUXA0z4X
	/FfAgOMalOmpkFhJ74tJEnqfOkFG7Vc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrkxuRje;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tzZHLZRN3jOrlP1D8SLHHdCfMJ27h3Izx64Fi3A5HE=;
	b=DoVhU5CxCwkTiyX4qk/1TFaBf3Nvc7FOMwLYw+IecdcHqkmH15yHC2KtFCrXyBk8gLxKuc
	f7FIUk5e18bygOcRIa6Z1Er3IiAYJ6xi72mVFSuCAYDaRqtTAR8dPk9nb46Gk0EBRjQbz1
	MNTSiZErYzYXJ7JqmytgaAQqEGMq0QA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB29041B29;
	Sun, 28 Dec 2025 12:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18212C113D0;
	Sun, 28 Dec 2025 12:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925791;
	bh=YC7hFXptZV2vdW9aMAEwYEJyXUoPJivVkcdf9qZf+do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrkxuRjeoBqT45eWaWTb4GyN5mvdPvm7P/ypq3b7ackOraR4PTpHd9pRbZ6i6kO4N
	 97hmQlJlJx3RR4oGwFEqSIecIjyWdldzVJrezh4/O3IlJFDwvEfZFQhdWYY4O7Ps+s
	 kACkB1HXzlzU/AMGBfP0XWzLsCttaOuvlAqNZVnnfZmNdk1yb7CdgatEFSlqpjw4yV
	 1izKUT566ScNJsmJy6w6R3+EgIwlD+sdx2tXndUSgJ8SgT+cdpxegWpGNdiSHyMHE/
	 N572Ve1tnKWow+M2vFlpUlHDmcNe3iyu6yt5R86wUIb2hZT7G3KKfbWLkf7toUIKdF
	 em9WX24oSmkWA==
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
Subject: [PATCH 12/28] openrisc: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:42 +0200
Message-ID: <20251228124001.3624742-13-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C46E3180004
X-Stat-Signature: wbh9nhni1ntxe5yr5o8qxj194bp98us1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766925792-939427
X-HE-Meta: U2FsdGVkX1/z75oQdXJ+D+1j9njlEcPi58t9IwcFBe3SaX5ps1XNhdGeMrrv2JW7RHb+EWQVy76nziMh8IsPY4DSK0qCEORigXxqyxsI+b2dF/a06sntRx1x/wmI0MxWpkyTwFg4hYao+m6KDrZmB6qix0S29CEnB+nUiyjt21FsEZ4s4KjqxXaLr/DnDcjeUV/cAV4yO/IdmijZIKWrizyHftMUfaX9Ha4ZY4I+DMlMVbqmu1yyMo0UjQiHWb7RTdB/bPo9pqVnZbip6RNcSCsnXlmiQUJUe5+Am1RYPBRgHkzduAIZG4OSMdMV8XeeIHP3wypvAlr/BpLK81bKKRwClKIseqvQwTy8QR4PxVR3ayFkeahu9Oa+egjsxV3/3SEgLqkqsYdp4IxZqJoEwbCZctzboqWf0MldFsoQL1r0m/zAVI/A8ExGDyR6WKZjjFJ6TxCMc6yoYvmWoi9qI6M3U5oSXYY90SZNZJMVdkCxnhc7Bv/qFhdYKBlPL/Kmo/aWYnON/pp1STBiHQnDdUFuoD+wm3qiwBjgzKZiGVK149xzueCRbgbyrYXJv+lJLQ3njt67GgPM2Rbv5/estGWlr4dHxWZZhp9QmWOwujLWdQ4T/9CtQVTbnEysz33Hf9hFvAmQfRJKYKZWCRwiHL1HQoAxyYkQNLbw6pPdYTHDTvf9R1VTT/aA8hGFihcpDRvoJEJKkqOFL3b3G651Nf4IqsLo9WGVnJczXo6cRNt5O7rs949119rl6cMvYSMBGc7STG6rM8Pcu5LmnUGMRJEEK3A43uyRavkkYQsP/CK4cRiCFFiGMJQqMegB50L0G772Q9bHPI2dEB5rrWTJCM4Q8dJg3kpvQEqrbz9HpOOMBxqtamBR28wtDa1Pjcz7EkoMVGzmCDINsbyudR0cdt/LI7DAf26mlJ4FThsYqR8GIRqSDZBgURGbR9xnOx+unpPQ5zteitRR443ASgc
 ztgG3tV5
 eifLQ0FuyEm5Hf4t7w7oiqx6bpZdL6dqRcYHmbWvi0o1K8K50cMe7C8uB3RvMeBmOqdzy+wEA+SKlrhkdow8sOK/Vh9vZVcIZOTMSk6tOIUvPNu9BuP33/gkAVfK2In0uScZhxi2It+yQ29c3CbE38C46g3a2wTJfvSgbt1CqyPIFgeEdl3uF+dyRmNnYjM9WxzWtELSYcsL+s+bh+8aJrEFQ6FSwPNbSFuTq6RgAK1rEfEG3K7M4f1nC+ijKlkEF1DFxJOeQAHjzHRBINDj15oIMBQ==
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
 arch/openrisc/mm/init.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
index 9382d9a0ec78..67de93e7a685 100644
--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -39,15 +39,19 @@
 
 int mem_init_done;
 
-static void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
-
 	/*
 	 * We use only ZONE_NORMAL
 	 */
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
+static void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


