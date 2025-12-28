Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC277E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150A36B00AE; Sun, 28 Dec 2025 07:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1053D6B00AF; Sun, 28 Dec 2025 07:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010EA6B00B0; Sun, 28 Dec 2025 07:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E23B16B00AE
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:44:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0D1DF5922
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:44:24 +0000 (UTC)
X-FDA: 84268848048.08.841AB5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DAC7C1C000F
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:44:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PWcfZU+2;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tokfLp/e6I58cppZJNFjurjxkamTTnFniADDaVWJ9jM=;
	b=ESJiDQbaQQpdQkzgnUZihF3hen9olPRyNe7LYo0k5UpEewjuJeFFVMHhLI/nFPEcD1dQNQ
	mk3dKKIcSofcnCXpLfrlI3dwbfWy+alIYga/wsYeIMQ+YhNQ9x9UmxcKyXZCGYZrGy090W
	PfhAJ+UxvHy3Fx1rPswhgSZYunLA0PA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PWcfZU+2;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925863; a=rsa-sha256;
	cv=none;
	b=3T0GZW3GVrb20zO6hGBmDc+YOKUzxZ02AkRiSZDbiRRx6CmfKVDRKZyNqNiAA47roX7614
	64iUbFBlwfpsvwzIt2RPBvfmD/sqsGKP61f9m0dmOaCv5izMzQaybD6a36h+f1ef5bNOCR
	1xKIN/j6njc9FzUQXkbgT1D9bbiBE5A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FD2141935;
	Sun, 28 Dec 2025 12:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F5CC4CEFB;
	Sun, 28 Dec 2025 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925861;
	bh=8ogz7O8vNIuYttKuy/nGG2q6czMHDvEeQHxuChR5AAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWcfZU+2dfSmPonN+ojloWMuXR8wApGKZB56mwDUFX5VHDqcuYWfkB2bX/D9oSFOR
	 0/4roWdMJnvzzJzf2/eTrkvzh2m8Ranl98O5T9/k8reMXzVYA21HegvENCuvsBq2xU
	 qG+ShBZQemB5PNZ2frhyX7l2FipQQSyMIAXIHvy959DjDUdNwcZmQOEqNjZ9CXn2lZ
	 8IjmzKSaG5v7LKDCAZdyhWFOoApWbegXh+2OGuM9Zc7Jjq2vTdj2jypeSBoCNxvEsl
	 h0+O8HRS5CY7HUXj9i3o7zwjUEzUzUDixmaxM6vfcFq+jSkwy05oXfyvzEsA3l97iS
	 neRab7Culxx2g==
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
Subject: [PATCH 17/28] sh: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:47 +0200
Message-ID: <20251228124001.3624742-18-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: h8gbyime5g6pnu38exjym4sc5db4da9s
X-Rspam-User: 
X-Rspamd-Queue-Id: DAC7C1C000F
X-HE-Tag: 1766925862-955614
X-HE-Meta: U2FsdGVkX19ErX8wTy1uXEmqww8LZ0PjAwGDID3NTqMZfHW1gq5y4MGNxigCIePcy7ux7gkmRBO1PVRU/FXueHeDppOW3X69ftdMD+o7hhxWx3UqJbx8Y0fgMka/oxj3XUrVq0N6IMvgMNa1O1KU3Sstj9QGdnPOz5m5UsPZNBITHT2CgMKrcsoRXNalkRobdorMztZbk7vmwFMhvPMLFLfLAXAYrVXjGNEqneRdeqm48sL6vKgSb4kcX5KABaRMxAMLVuCeBYrNnrvl007vgdmL20aTNtzkuf8UI5JxelVUx0la9P8adbuURhdH9uZjKW+cTOLf6gbbyoE2mK/g7XRCygEbNoGLOWwGqi/U6dkP2XucoizXBFb2OAqOvFUMqc1ptlJXSJpjIkzJGxFrtWUoFM6kmXQ6Wa6og0pmV7iF/9dd+8rKT26QvvmwtpbKCPrxb8V7HrhzXK4qngYoputEEvPSm4ALa9Ylq/kI2uLBEdepE9bdSy0nGLb1j+YK9HjkbLrG75tJ3b5OxbKFvEanIenGZ87LjvMaHPmTelWrOdD+q6yGq5KxxavSLB6qbMtktiEW0oDzBS5botBmPJo2DtdPv4Voia/l5PZWPanOGCjqjSrQZE/DIom5yADNPW31JaYq24bFqTk5PKmUFeh7mRWoHQYrxMMgm25cDPo8566Ya1/1H6IZCtISUuurTGj3nICgz8v1KlkaGfbrtQFbNBqfDUeQZyI+e4nuAZqhgLyrcNv8T09sDX+wzYaE3dgMuL9nuYjAtIajblHd8CVgTrUcGgdFuJY3hQimV6LXWGGpyU7a/vj923/oWbDSHqV5NYLL8amVdJzaxjjiUQZ5u7Fi35Jhh1v8OJTOpspH1y3oxCnEQ4yMCnuYBtxWYVA37cYDZS09///Ns1uTh7w35u2ZRNOVuzwHnnszStYiUOV66V+LCKFFyHuahSvyXsZc9DA6u8VK4dhD6+p
 xww42Hju
 NXlGLvVEXU9AEiFOv4ezMPX5CEfL0hrPFrPcxL2kWZt5DpNFNZ8h+2M9KyaLbM26xLE3FSVaNIqsWSoq6KpKXFlBoe2O+WMjISuZy8khPe+RMBhBS9XeaV4jUDFD3fVsiUELU2QYEBEI5BTx/3QnXagjlTONZV0d/X0gW8BPG002djyakjbE+ZYz/O8266dFcCWWR/Tmg9OKWuQGkMPv4rtvifJNfovczwEVtsSvHtafTMD3gM3U0Uxkf1mejrtHNeOBlCeALx4AjObp/joLj+LGhFlNXXK4Wxq4k
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
 arch/sh/mm/init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 99e302eeeec1..5e7e63642611 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -264,6 +264,11 @@ static void __init early_reserve_mem(void)
 	reserve_crashkernel();
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
@@ -322,7 +327,7 @@ void __init paging_init(void)
 	kmap_coherent_init();
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


