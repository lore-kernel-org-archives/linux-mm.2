Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B586BE784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C106B00B7; Sun, 28 Dec 2025 07:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FAAB6B00B9; Sun, 28 Dec 2025 07:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107346B00BA; Sun, 28 Dec 2025 07:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F29466B00B7
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:45:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C02F61A2B43
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:45:20 +0000 (UTC)
X-FDA: 84268850400.20.4A25236
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 035904000D
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:45:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dgCP0kFP;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925919; a=rsa-sha256;
	cv=none;
	b=54dVTUbZbTat+BhHStjH2nPvOf6liH3B4TEcSXwVe49mQ665rVfxrdfkXPGfQlAORWet4A
	H5mLNjNA/dWPvrABhNw+qzDsuvS9+yvCpB0Yz+YXEole3Js4ybw0c9UHUSTPDqJqJH51Px
	U+iYmz7qE4ue52CWuYdoX4Jg2gb5XPU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dgCP0kFP;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1chzHxsrADOvWvHnGxP4KUnDWT2YzEh4P+Cw7lJ2EsI=;
	b=qmP9f9syPhdC6kzKnT7qHoAGITOC4fLmE5UtGunBWL/zx+JToeGe7oH9GTLDt2m6ALrxci
	2P5KBaejQrCAwKSn4ZPbPnvspq9EMO85xiLBZRtP4m0s8X3qJBrZaPzdW0SleMtL68qBHn
	XiU1gWcrUFwPH7CjjdglO9bcTk1/FIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2212641967;
	Sun, 28 Dec 2025 12:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFCAC4CEFB;
	Sun, 28 Dec 2025 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925918;
	bh=RfrVgNIj9rxp9R6SGMWNq/5X+PJ8wzbzZyqbje0LIeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgCP0kFPdQv5QW7TnGA+dgTHOHx2YFjqPAW09kF55dY+QSD6aOgaRHIC58u58cJS9
	 St3A99X1TYnc0mmyYGTJiavJEZ5kF4DORYVVcG+tjBvS9Z+9RQaK5L8S81H3BAhXSS
	 0r8WBeT0lawPsK+UFo8mkUvnpgm8oZGCFCU+vkhGvOptdr2SAQnRGSfZmfonhWeo5C
	 4IvcQVNgOmdZxwNG9GCcfpf28fcpEOWvha9AgJ7EBPiWWOEaScrlyNUFehOY5mXtne
	 Wig5b6IheAoBFArba8Of/gu1bUbGrWZjXa/jAcwnKyRuFDR6ycRbAYyqau8kipGjYW
	 zqUHgvIQ2U+Ww==
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
Subject: [PATCH 21/28] xtensa: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:51 +0200
Message-ID: <20251228124001.3624742-22-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 035904000D
X-Rspamd-Server: rspam04
X-Stat-Signature: r1hxhpwrjbpr6antd5xofj9xcnii9mn8
X-HE-Tag: 1766925918-137067
X-HE-Meta: U2FsdGVkX1/bc224YPNFHXVh0PVbjcmDjaqcW6Wk+hLo2IB1F/xQem3HVSi7n7UWJIow6NxNFxsUgGdLzO1QWxseXQjICXiO5oGTjmABQZzTLRSNiyYS7jNJoX8am8u6MIw8LiFPQeOk2HF0k5VSP2tqh5d0DE8Msufn8DEAo/In+eB5e49RFdHQbwLO6Sq5gMadBiTTi+7Cao3+9APq1oYieitT/lKMVdI0v04vTBtG8Iu23Cjxil/d2efgCXDg6L1LKbwh4MHCQah+U9wX/PUxBQ9rxdt4dqPqUjMqT4zh6u+/inJB+Yi2HfmhZopUuu0ZC0QCbPShAxFv79kc/Gb2kWO/J/TyTkAwnUucrVtGanmWS2VzShlsFNhMl/dAOikDUZ/yCqOsSeYa+R1xvxAebjTpX4N2n5YjpkNhuvvT7T8X0nnEV8sobo42dO+3EGMyZBKeEyJf2JGZyEdPpIqKIrd8+6qQNInc5T7V8cxM/x584gOjGQyaq2Z27YGpHMf+LC8y3fggC6x4fFLXc7OvPW0ehfPYoNXQpGeFNarUC/L/ni4SLBuLAe9K2X5PXiKIWyo4Ca3O+UMYkHmRfP6LbgJW2P1CkdOuf20bbk79apOMav9v2MGwUOncNaePKZE94d0OYeYWhqcKcqKzlHB+hI3Cvn5WQGoy4IxTl2zzggZI6JA1nKFVPevip+OnS4V/1kuWxRdcz0W7n/mLAQfSJ5DYAaBxCIdnk6fsVUJfpf9PClUGJUTtoLomwb9smU0R1dBr+7aMwN6ixgltK3JaSJK/nkhfEM0XnsyWCU2s9vc1/xVRa/LGILXSigVPqRouZeCvt3Iv6gK/RnXkbVbmau0mKIMiSMhPWYXzngw95JZafxZ0TqoFweuaSb39977iOu+nQkdeJVDwYniqbDUatxfja/KeipGesWmj3Mk67OUHu1ZZcNxmgRlZTL3cYyuPnnqIx+VyHb+X2W0
 3Ib34mpH
 tOroZ0IaMAHiLdOv/YveVTOjMlNniIs+y9uhPRzDYkTDypQOT9nCOvqx4qjHSKZQFykAEWWsWex9eZ757H1XFUtFPPYMBYfS5QgstJSdnAnj8tUiRzKC+aGHf8KNS/3bHoWvW61OKPCmBAhV7CV5AygIFVyG8y29IF2K3Tsmv7ZmblMuMfbVCIVInTC4dXuWxx9rJb1rEcTHz9wXFLcYWoPW+pckkJF09mIibSm/oyW32MNqe8PJ36xX0V47neaFuVuPeUTJgmd2AbwOExWUy4YEBZQ==
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


