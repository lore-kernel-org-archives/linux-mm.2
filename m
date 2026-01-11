Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81164D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74596B00B0; Sun, 11 Jan 2026 03:25:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21C76B00B1; Sun, 11 Jan 2026 03:25:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D03EF6B00B2; Sun, 11 Jan 2026 03:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C03A56B00B0
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:25:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 739358B7BC
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:25:58 +0000 (UTC)
X-FDA: 84318999996.04.DBF0E91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DAF63A0003
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:25:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vx9CZF9X;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tokfLp/e6I58cppZJNFjurjxkamTTnFniADDaVWJ9jM=;
	b=Ucr6C3aSlvAhupfOA76AJ3b4m9H76Wr0ST05IczKOW30+6TUX+8VS1mQ5XhRmVP/HeGJnX
	C+TsjslsBD7QVAef9httclsAebcDEwPcH5qaF0AwAeUtfaOZg7qXbl/HCu0Jo8yTxf+cbl
	T+aQ1KOOCz8X9MiPFRnA4lRuM4itpWA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vx9CZF9X;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119956; a=rsa-sha256;
	cv=none;
	b=NT50DwPB2rEijcm5r+zpcgvB87LEeJ0sNTrVCHrpkqMYiiU8X+AkLuLDDf4pjM/NgVxYXm
	DFJowOX5PiEJuf7o+zTI0I/7g69b09nww/vk9CoZro89y5mTqYLDZm0r1rz5wxtouKEZlf
	cq0lyw7QJ4IH2fVtuBNRhULLlHlehTQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4604560121;
	Sun, 11 Jan 2026 08:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D130C16AAE;
	Sun, 11 Jan 2026 08:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119956;
	bh=8ogz7O8vNIuYttKuy/nGG2q6czMHDvEeQHxuChR5AAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vx9CZF9X+r6FjCSdphAFLRUwQBjPzpcpTP1svlo74Z1zpu35asFTu76lv4/ExSZCO
	 QinlSs5dw1egxaQ3D6u/Wecjs4+oXzXRvVhgln/TIxyQ/SySTsoAPtUbEkqpHXgydE
	 o0hCrmlWxImpzttux7/U98aTXPChABKFYpihhavzXT97ij//8Nqr0v0/ZJZ0vcsmol
	 OsGtAGYp7WlLshpxExCRChU6we4lXZT0H7/dFupPg9DFhyYxm5kIqI5sjyM2gMQjUp
	 CVn/rfpc+W6EoH4dECwOXVOCVcWhHXWVAjMAdtnIQmuArEGRcdx8gH0LPFezkkSTO1
	 1Ryd+DGSCZgyA==
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
Subject: [PATCH v3 18/29] sh: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:52 +0200
Message-ID: <20260111082105.290734-19-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hzwsj9hhjrwm6xdnkgcubngprnc1siwi
X-Rspamd-Queue-Id: DAF63A0003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768119956-606071
X-HE-Meta: U2FsdGVkX1/mU1W0BaglY5WBiD0M7WWMXw7xQKYbV4IZypgvABIbPFiF3L01+U2UOBUS5DqVGHI2MEvO5Yq6SVfesD+X+9wKyaABV41KdRrl4z8gBz+1C1lCmdbC9RocjlR9FPdJXrtKZiqnktbhKIQSSXCw0T8iDAE2gCXbluu/sAR4QGZohDw81iVCenM8vSTdgVZx/+VqMSNlAYfCCWmUbCiOsNJ5SNCKKda6VyuRblyO+FkkmIukVRNcToZ06HVgN2sYuhIR4L/v1ROSYnal/rOg1DkPxA/9jIdBvp0Y2A+LjHyt9wyTG1ieqhfReRG3uf8auzV34SZn5jpAB0EyEzbOeELp5p6B8PiwbCfcA3GefoKtSy5+vWp32KCnnYcQK/z22K6207qsYrP1T+VLmO0en/7UHVaivYgkd7seOGxHTjE/AY5eeogKlXrIJzWMIrFTTiGhEI5RIplH8Svucoip+c5hpid7qMOVRD00M5ypJpeTXmS78oKSJbGfoJ2gxaCr0BV1Pqm2tvkodzqMe0lnxgCLusG7yJ1m95iulctPt370W0zRVRKPLwkxg0ckrWIvyLwFjt5ZWgP+tA1ZUrsgH8ouZDUqZlhkZyumv86KE5h7Wyx4wFksE3ogbXMTBIQ1v6/tL2tzBcy8VGREpERJ0oaPmqnFuXDkTnoQcIssTsPvcaTeaw8HTqb1AKk+glBvFSb/WDAiNBHgv1uF6D5S5affNCq4sB/zFgvywlhj0bx77uZ8E46IZGOTL7LdILcG5xDTK6QIX3/1C6NvrX+1UQGCcCMeYqL7CEJwCEEKo8i6D3n98noot/S/FH6EkPsq6A+Dc1FpYmsqX7U6Cn+vEOU+O0XQe0P6+tivtV/3PyvCDmwaOuSiyLMm3nU/41wIznUWDbSWFX2OXxnKnbQJRObn/wVWKccL88raC3NTjMGIaBpdPJZt6nbKy2DtwnP4avG80mM74+Y
 gRfgDjbi
 NdfWLboeWtdNcp+Dww+RP/YMeg2cp0ah/Xyc31Jw8Mp3ScK6V4+FpBaiWNcqFmD9I40gShniKhChC9rIdFRfdIXomVV70rlIjO+bICEnQG3fzqWaI2quj/USYKHPh2amYXtdm1BbmqDeboa+gB2uAodbMl62aj/gY8OmG8qxN9CkArLhjzhtBszif+TLrPivRWSFMwULp9VgKAS0YEsmVQavLesMC3s7xc79qn80ProrK27OmR/Sh5AsrmTVdOKynnYs2MUN5wz5j3bVTG2y9nalgFqE9VKZzkApR173AYNqy8SYdn/GY7rSoMbsKeaKZ/z0oMIgRmnBTncTNHsep4rVG8wvCGAyHR05n
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


