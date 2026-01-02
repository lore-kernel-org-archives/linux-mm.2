Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02CE4EEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662DC6B0099; Fri,  2 Jan 2026 02:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620746B009B; Fri,  2 Jan 2026 02:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530826B009D; Fri,  2 Jan 2026 02:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 432566B0099
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:01:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 172281B110
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:01:53 +0000 (UTC)
X-FDA: 84286128906.23.053DF14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7DFDE20003
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:01:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BpS/vYy/";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337311; a=rsa-sha256;
	cv=none;
	b=XfAF4SqhjhXJbQ10MucbCOx78SUQxChbypRGPMd57VEeNxau812gZa8QIlLJPA+udjSlDd
	0IigOjthtgYPqnoq1jG6QLdZl2aG4qciqjNhn/1S453dBgRtXvkSyZXIVvPGHccSNDZpsI
	sNTQ7G/NUm0wYAknXpZksrnVTX32XDA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BpS/vYy/";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9r49gF1239seYn0EXw4a+FTKxA1x4OYVZ+hhz2pvoc=;
	b=Rrn9sEv9NCmRBvzjztStkIXCG3DIcod+fKQF1BQ3Bgoar/BuK4J1t8wi3srnt5L/08GRmg
	BWjIbrUsFW3GQ8AsKinq9JXu5K7UwTjwFaic/XV2Mh5u3iH9Oij6/H/o1lEU3t1PmXu+fi
	MJeH51TyVtGo4oaYslov9FHPemyx+ZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DC71360017;
	Fri,  2 Jan 2026 07:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87CDC116B1;
	Fri,  2 Jan 2026 07:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337310;
	bh=eqWldmxLZQ+MuA70zzUt7CpIfBT1PwNgoY4RoneYtY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpS/vYy/9nyGIKafFE9V+r4HIaDTnoFUO6BTxQPGX0+fK6kCr7xShS1cvyBf0N0yT
	 CerQRZQXT7MbCqIrnCsgOrgv2Ia55RleKWDmaMs2irjPc6GjTnGGw+wLnXomD+vLNI
	 KSkl/U2dJXx7h9eXgJ0JskjtaWXluWjpg/x0JjdxvJeKsUnPXMXMkszXrGJ82oXAX3
	 YZWN0c2pAwx8Alfig8i8HbWRbmXbfiG8GoDVdegQc0Cg6X09COblKfsTjZPB14TFdd
	 QC/bQ1qfR0BgMcXAOfnQocx9hjiqjc4+pk0Vmnp+5k7ZzBLlasAVGNh5Q2wgUjvSxI
	 GMTmo8jn11Vdw==
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
Subject: [PATCH v2 06/28] hexagon: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:42 +0200
Message-ID: <20260102070005.65328-7-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DFDE20003
X-Rspamd-Server: rspam04
X-Stat-Signature: k5cox9spacnzzoew5z77eej4habxjh75
X-HE-Tag: 1767337311-472894
X-HE-Meta: U2FsdGVkX1/wd42h7S1g2nrKIGlZFmuei261wm2ji3MdiMH54F7XaA1/Aix9yLvW4tDd9yE6Aful5B2hKDh5XybNijESDMLlcioM3blX0zqjNKtTsWnC6BHX0M7uSMCc/5so6sGu+73t19bhQS9hZ7CNwsPH4EP/MlRnaUTdgU+e2ZOuQSwZrUQXgAkEfSx4Rgyn2Ga3kVhsI+bNDe/ekQ/rk8Qjppj2hemqbVAFn4id88kT8+bhLWTKcqFIZfi/TP0tibtUyNNZ1FJJGJEQ1P6tEqNSKQnKj4/1f/9GpX89FqJjkw+OplClImmwvOztrrBI9CMX1e2Nd6xOYGGLupZjYLOdRBEBshz3EQGHkmSKZOzrwUboIRwCZkHC6g42SG48829uUBY1zgCPHC3CEXAlwJn+Cgg+3aPiDULmSsUpFcq3kBW243Fm2/F5oPkAgbi+wgJUYGhLmual5GQVnFh7/8WrMQsueeidvr7dnRVlqQlm+KYaid0Su637k+agxO1Qx/sxVxnL2ZQLYiynQkAVCN7oQnV01OcCkhWPThespHnRroTuPUV+mlpyUfBmsN/wmdyWXnGTDNBXyN3HWIuFGEPFJfEiz/4+MVzFrfkxsLlTzjsb0j8oNR6uU0+gVVZdB9LzRYWXCmi1XDRYJjtyyTKglpnFy33KrBSPi5NAxYBTLyHuknBHnie9uTG8S/hcMJxFGNAeK/IWVXcmInCPmKQp4MiuKnaW14EIaBef1cxmSme3KRnwKFOn7v2+KBIvYbHsSVH75TgtMDDdtw6Uoin3QJc3GfsA1zxUYQJ4QelvarqEFUKSaWiZP0XUAcWEAsfVNYh1dixE+yIkVKexXfWE8xESgbw8zgpf7StsLt83gjUx0dhQwQOkLLw6x/OZQ9ATyuAjpBVcoTWiDM4dseN7N445xFl2WHPiHnFn71cdOuwixvMeYgKKpzMnhkQiWZ7Srk3ZUPDL5Xt
 kE9j4Skf
 afp22ZipDPb99kZWFvRPTCzOfkQrukIjjYrWhfCtAsam1thJ79xthYjkLaaMnwfK5duO1HabTLrSWrKo92xQ1/hhiDMXp83tua4uAiS7eziRGGNaGHQjMevF8laLDVTR8IXgGRBitANYgcxjl8WkfKhfnzVtfnOWhp3dWlu3pTcbWDgArW+TacfazG+T4frO9v7unURc8R9Z5Islyk7HG1caf7yAS3wa05ZhDEbJgfD4ulmCdRtmfsBmvRrP0avhuOL/9WmG5/8Ss50qgwBpWVXtYFg==
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
 arch/hexagon/mm/init.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/hexagon/mm/init.c b/arch/hexagon/mm/init.c
index 34eb9d424b96..e2c9487d8d34 100644
--- a/arch/hexagon/mm/init.c
+++ b/arch/hexagon/mm/init.c
@@ -54,6 +54,18 @@ void sync_icache_dcache(pte_t pte)
 	__vmcache_idsync(addr, PAGE_SIZE);
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	/*
+	 *  This is not particularly well documented anywhere, but
+	 *  give ZONE_NORMAL all the memory, including the big holes
+	 *  left by the kernel+bootmem_map which are already left as reserved
+	 *  in the bootmem_map; free_area_init should see those bits and
+	 *  adjust accordingly.
+	 */
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 /*
  * In order to set up page allocator "nodes",
  * somebody has to call free_area_init() for UMA.
@@ -65,16 +77,7 @@ static void __init paging_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 
-	/*
-	 *  This is not particularly well documented anywhere, but
-	 *  give ZONE_NORMAL all the memory, including the big holes
-	 *  left by the kernel+bootmem_map which are already left as reserved
-	 *  in the bootmem_map; free_area_init should see those bits and
-	 *  adjust accordingly.
-	 */
-
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);  /*  sets up the zonelists and mem_map  */
 
 	/*
-- 
2.51.0


