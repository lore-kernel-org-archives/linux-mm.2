Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AD5D25037
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6859D6B00A9; Sun, 11 Jan 2026 03:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652E36B00AB; Sun, 11 Jan 2026 03:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569746B00AC; Sun, 11 Jan 2026 03:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44EBD6B00A9
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:24:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0ED4A1AC532
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:24:43 +0000 (UTC)
X-FDA: 84318996846.28.AE13520
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 59D7720002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:24:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mM4gqA+w;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4Huzw4vQWzU7fH6ZK6JDqF2BuozGGTADwuU/KDDhMQ=;
	b=0DQEKFX0REhGwXjOXSVEWf6/fj3PEfNxeKFhRmtUWgc3po5Wmd9qNn65GbYYCJ4FYguzev
	+GRxvE+ji8PAMZT6JqqsWsq1in9qiC5IuWbbYECCEIiTaI+xcycGoUIppVw3LfvlxqS4ax
	Po+pXmOeiHhMOOGEVcvCQE3YfYQTBGM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mM4gqA+w;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119881; a=rsa-sha256;
	cv=none;
	b=n+TleVMjPFjewsS7K+KHv7TNkQIYeTIp/NUgUNsITZUqnoIp2Pi5yiNXDw5X+6ltnw7k+E
	5Nn+7zaaTVrgndf9w/reUh06HGMJ3Y/t0Rm93tVwlxulZ19d2+eJXOcjNlHdt9q5it+4Q8
	RcLwhrOOQ6DzFah3ypEzObfiEXoEUws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79699438C6;
	Sun, 11 Jan 2026 08:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8137C4CEF7;
	Sun, 11 Jan 2026 08:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119880;
	bh=MPCX/BFx4rAVGYDlSF6Q7jr1d4V0F9NA7QfDXfFeFe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mM4gqA+wEauIWJ05bMigWXYtTWEEcyei1F4xEUgbq+RsfmmBoFF0o2GyqORORg1ZU
	 O/PYlnHLs5sTgxaOrCtPEumRYmzE68tz4XVKb4jcrkG7r74JwA2U4FKssm1FbXJ6xw
	 HYCTcGgnjPE0xv3HeS3AlJMYLl+WS5Pav/teScenNnOMDF4+Oi5hyxTIHvqQEBKyMT
	 LBhszlQ/gyTtQUq8WRDvcUevZ9GQ3Eg4UWOWAeBVjU1yDAFpJgs4IcDiZOwNaB6enz
	 UgD8N8DDwHSsVPXiavsWLV9g5SI2abirmq3NT4jYL+pitalVFi0JACgYgU7Jmtd+21
	 Qi+05xubHRvkQ==
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
Subject: [PATCH v3 13/29] openrisc: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:47 +0200
Message-ID: <20260111082105.290734-14-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8c4tcg5ricezpd3oyqrfkedigr5s7man
X-Rspamd-Queue-Id: 59D7720002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768119881-893159
X-HE-Meta: U2FsdGVkX1+CYwYe1nK7fEldXuPQBkE49HhxxoK+VLNfddCXOPvReghGTeOLQySvjhq7u7YPydJE0aa5Yo55cmQpWgqzaqBrBCpiKa518k88qMLqCQKZtZJVrOKzZ5gPDj+dEnUFHsrry9eAihmvNyoDNb7ZerrT2f96a+IONLOnvuqI1Hmx5Chfm3K14EAm86Ij8R0KPUaV4rjJ5tWjjFQ0Gz+sw/hf0u8DSBboFRVtVYjpYS8TzPJaCtFTlwiap3HdFgPndA+d+WWNO+svnpwgi4BLXOquUAVCJUPCzgEn5vNuaMDwO0fBvK96LOByBNRmXxaNjsVnRx8faFm20HZJM+53/N5YvMfjeW3pft92v/L9gXVX0Jpn4BP/SqLYdLhDG+40vWSzzkF2L1MPr9R3Bd3S9umWgGSkI4sBvLb/F/2cP2MRHXeNWgDSfBHJx5pkSFhT2fTsfkHE4OFUDUl0HlE9YpUwKiSvnlHl5yRg7hdQ3+UpbjxJfaK1MxT1xlentNfFgzzm35f9fIys+vTbWD8Ycp4P7Lr9yStF+brM5SBreErDoanxvetAbKhpiI1gqsnLG9aeufj0wZy8bXN3RCiquOYwfxMnUrYCAljEjQTtjSm3v3tn1nVukTN9UZuStTfEmb3rpkaRKttpn3YYOcCzGYLKDqaL9P5KOyT028k9xPN7AMqCQIQVYWU05ILh8PELe+TIITb9KMaiWMm9pbFwyJmIDwC4JyMCAqpGVjV84Ws3TGUa84ng28IRsb9M367Monpy3a0O2sWM5gogJxKVHK9hUUxXyKJcPY3K3cQn54lAOE1H9Dy6rKRmLyGgQFrvkGD7ZvcGUQEIqDxT+7RJ1tEkt+eSAoeixVJ0EPBeb1djgkr9ZQpkViraoNVxw03WK8OcglpVflNkwBe9en4lxyfYJClht2PCV89q3x38pZ5SzHsdkvGMhT6+ar2beg4Q9QbkKtVygxO
 3zIuineV
 9/2qSEbdRI27njlk0ZNNFXCcKcdyETS9RHhLMOqwmiG2+MS17bBjuLu2+LmsGxZmJN4xUjDpx8YUF2gRbv+b1VHyr9kORknxweXCqGyeHaBe3LCuGWfpyup9d715L6XAazCIVmrBm87yh3phqiMewwDE7DfEl4C6JILxwnl/TI90wvY+Kd5RSIRMdvna3oPmjbk1+AINWNzvRjrqRNaEFwivIOdgVC0LqXidt/AF2ENLjhbjKbFoYPwDk0b2cXE1wcjGJspVtQO1UUN/Ef/Qv3EFE+RK4XQxUGQbsNNF5Jymf2kriisOqNDLc/Lv1EZ7h/r/iDsbps7AlmfdGt/y3lchwuaiQjF1CGpxnd1cYu+9mpAtedSDVOtyzBw==
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
Acked-by: Stafford Horne <shorne@gmail.com>
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


