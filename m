Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF1D1E9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521446B009B; Fri,  2 Jan 2026 02:02:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC3D6B009E; Fri,  2 Jan 2026 02:02:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E47B6B009F; Fri,  2 Jan 2026 02:02:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4616B009B
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:02:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0ABDC192F
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:02:07 +0000 (UTC)
X-FDA: 84286129494.20.F7867DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CDA9A0003
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:02:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I50MNQ79;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337326; a=rsa-sha256;
	cv=none;
	b=Je8DEjXkKFwukJGq589wlpybaBAvbKNDGGYeHJjADKeuZ2vfk1VuYbn2XoXDiLRbLjXABg
	852C7S+SSxJ0gQ4Yq8AUJf5pHhocXbRLFXVmj0w8tLHlK5Fl71Yf+eVHKOMdHC21X4MWFC
	xLyef7nVCLxzyhF2pFHxq9HEuLxPYuQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I50MNQ79;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfcqmLQbnSJvVIv+k+pxkWmR5Wm/caGZYknBWk1pJXo=;
	b=QHkHkK59E3MoTvJKdu0lHX5fibMxC1epnRYp37j6aHIVy/cPg5Yg6d88YnuOITZeujynAh
	OyL36TeTJcIsrFpJGF5wZ7z8NBFzrEupnAAM7A9Mexj0FX/MpgPcpZmpyjswY/mEEDw86Q
	CiLk+cYuyQdqRYisba/k/B/LR7xfckM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5974D404CB;
	Fri,  2 Jan 2026 07:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192F8C116D0;
	Fri,  2 Jan 2026 07:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337325;
	bh=3bBcyNtfu29ffLXJ+V2J2og1TMjw9NsnHxGDp+htXro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I50MNQ790Zq95b8S0yQ0CXud0hBoT6XVttorK01jD4dcGhZcOfyErKBL9h+EZnFDK
	 JHpZbgNFfrGqSCJsvV0SuvqTBSorWby5FN0AQbHPlcZFbXZg8iRp4E6Op8x8VrlW3g
	 9NAxGlLvXsqDB9F2a65PIkUijJJKGfTVkxyw2aMxSTILIXs/q9wM+VKBXV3SjlSswf
	 pQqujD2MT/xKyGZT/PmnUKYz5qbhZkyAKaa3W7rRWzAn7mVMvUA3plpREVkon38b5U
	 e2uX7Gr1v3oz4QsDuUSPNQrfRFHFJmPdNoVSlmks4iPatW/a/34a2AYSRwM9QtV+LJ
	 dAmwK3MJ/gIkQ==
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
Subject: [PATCH v2 07/28] loongarch: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:43 +0200
Message-ID: <20260102070005.65328-8-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CDA9A0003
X-Rspamd-Server: rspam04
X-Stat-Signature: sr9uo5xd3ohsjkc4zkorgauihyehrjng
X-HE-Tag: 1767337326-249953
X-HE-Meta: U2FsdGVkX1+OaJPbQoQ8NVPzQzjnexP5pTcYc58X/jdgjNBl8ztNWI5hJrGTbuii3DZdPA/HeXN5SJQotZuOst2A92XFqDtJOZv+Kfyx9UCw7Jf1kyq/dI1c5D/rlBB4Iil6GNMn+hKqi5DYEG2/NwHDXHt3ZqgfxxqOWKPQILda81+mAHwl06bDtaHJhdANMYfWZVCzrfc/ieqh7KNB+qqw5kmVsqJ634bIMCJxsaJ9mHdRJBhtUom3rjNR0Rt9cqo+n8nZt/gIsuq3DZHpzc3VqsPbyL8ZRVPj4PAid1esAGM6mOd1W59977dPP2LA7/MHS1yF03GLOf7CVj738sL13lWfvrG42nsljedd35/GiCXAKHDGLh1n7MR6O5P1KU6/qLdXZEem4LHN5Ll+x6wurE9i3WpcVNc7peR7oD9CUAQFbQ4S1tUEYNT0BashgaNMLuqqL9YOynFCe/9BtJEJkEc9At1/D4K6ArknhrbVlJDlX6TmjSS1KuGclCHjx9THfCPIqpSuxbBWe9qBgGBs5qDTH+U8VcMAVU4uPJmL3wmbTtLhNowAvyCJHd96j7p4yXQOEJHREq4Pgc4nX9sXmCj93OsHP9s0ic3DBauzLA8p6xhP0GeZKCbFhLH5o8cPbh5bjqcFxux4O+ZxzjcoUwUBKIy4DaYRo4sN+MVMpPrtf8J9RNOfvwLKDJDDBdu7mfJMDGApc8NI+WcVYjO7kNbvWJgXGCoLZTh3bmN+/A5Snu9QW87H/jRvbhLIwW0pQdQ5q1SQp2exz7Yxh+Xvma/pd3zIEeEU2mOhJzvTeP04XC66KS0vMJM3nVwk/bhnhd372K90Q5q8hcysO3pzDanNI/sNGHIW/MQExv5xQppo5DgqcpRvHnB54pg6E7Yf0afNmUDIxLSDNiH73G+mqx7anMDetwzZ+h2a4cpDlFVvq46NHFiGgBIkDiofP0F28pDNPm9PRNGpXzN
 hlTkZ7sR
 Lett5crMDvso3ZIJgF1HdUTtA1g6NvGrscV1Onz6jMaguZ5PFPjwQUT0vpfXkEc2Zs5Etc2mMvfY9cuhIqFDZVmdbsLqsnemvT60jiwnlvkkkHbdNMSLAr877uDtKoudHPwjNskFbRUkGDDo6Z5Y3bgQ4SPW3B3l9fpAmZmJVxy+hqBQrbPmAX2p1IXCFF/oZzm0dIuEnhrMB1mKMhHwORIi+192tHVjxdPd6gc0SngeXlIYZ6hqMO3qnkqbVs4j06JOV7yF0baX+j9KgYcYv9DXhRR3WQvh7yXDf
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
 arch/loongarch/mm/init.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 0946662afdd6..17235f87eafb 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -60,15 +60,19 @@ int __ref page_is_ram(unsigned long pfn)
 	return memblock_is_memory(addr) && !memblock_is_reserved(addr);
 }
 
-void __init paging_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
 #ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
+void __init paging_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


