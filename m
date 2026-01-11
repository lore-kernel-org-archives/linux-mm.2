Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F52BD25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A428E6B00AF; Sun, 11 Jan 2026 03:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19316B00B0; Sun, 11 Jan 2026 03:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FA36B00B1; Sun, 11 Jan 2026 03:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81EB56B00AF
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:25:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F3971A03CB
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:25:43 +0000 (UTC)
X-FDA: 84318999366.30.6F855B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B5E4F40008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:25:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejea3zjx;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8kExoTLliZANVxlSa71PKoJV58jVF11IqoI4S/DqkA=;
	b=DaPmjswEZt+EPQVw4/5+1YCP3YQ6dPDkZefS8pr13XaMNV9Dlx07baxXli8QXirQMxpA6Q
	bpLPAXJ7tdCCgeNPk7Wute3k3Y26eYP9AtOAPOP77tULNMDpHJnsSCZblj3FZYZHcYuvLY
	fLlQCDvxzeJ8s1IBrNgvyrNzuHJ9aaI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119941; a=rsa-sha256;
	cv=none;
	b=Ufw+0YkZ2HABgzJWHFuuXa89/kmv7lBGPbuLKYyWLTuiP+rQRmvcUVbN2pFEGhgBiPFcgv
	hIe3z+IM+dmwXRBuGJttTiYzHdPmCftVYMPjdQKPNs23jogTt/8bF6CPiBqNieJVMX3i7V
	ArnG1wbU79mBZUwP0WwELWhIjVzKrf4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejea3zjx;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28AAD60121;
	Sun, 11 Jan 2026 08:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E397C4CEF7;
	Sun, 11 Jan 2026 08:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119940;
	bh=hFJveYfaCrIw0+iDVEP3vQL9fd/XBHyX+JYd2Rm0RhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejea3zjxcNk55gNO0bbLBhxe4NsBzp6h2dbs/uOwmj7bbdTrm/aLn1CsdSYQKFNyy
	 MIgW724HlUOkhiogpK1xlqx1PfJ9vKR44ePzsM2MgEMnwLOTLYReW2B1UTZtcIh8qV
	 HscmT3ORaZ3YNpVrsvYWLb9xhAvf3GwE+1yTZ8bLpTWXBeJ/ZCly/j0T5NtIzfIx6y
	 1wPtCTY7OtWi8bK+mO5MGkaG9OvtDG3md54oVLJwaZjJezEVKKVPB/mpNay0l7xI6c
	 OP0eAip/WOsG1W062M/zkogcxJrAkYPvW6p7Fzk4WPU8E58buvamLYO9CoxJxr46de
	 UnewUkKtu81TQ==
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
Subject: [PATCH v3 17/29] s390: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:51 +0200
Message-ID: <20260111082105.290734-18-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B5E4F40008
X-Rspam-User: 
X-Stat-Signature: b99g3b8bnok6hym5zd5h3zu7jkdktrk3
X-HE-Tag: 1768119941-868742
X-HE-Meta: U2FsdGVkX1/HHh3/cSRi+/k3XBdo2VSdlN2SL9tjLoual2DGOE+GBJUPcy330c4V6R+DmW2vXZXp+AnbOrRwQ2pTEaY7lErGUCMn1WdZq/ebvWlXKqYUcgMaAnOlkr4L2kK48/8ikI509EXHDx4qTjBXUUaezjPCGeh+y8OfLdVzFZfkvzaJPgYEJa6jmHsW+ZBlo/dV8K3gkf/mLjuU5+tQ802zZG1lHQdFtcI0f3T/IiteJr+MIk9KAxOfeGY2uPf9UMw4gpFWUsMO2o5HZAfiRxty2QauOMfKC+eQ87fJ6O8xBPBhHz9GIzMohSFEZ0Zj6D2pCqZcCE2LMxxT29AEvethMttZ4xEiA3XMPtOsomC4u8QsYgVm+1yBtOAuXwdEZMxAzHhYkzotUsiVeTGxPW2fT47LXazGo1ks4XwTDj9J+D9AjY/HaLmJCXc0L4th9gpdFKZczr7ZoFgKgAGb1sEN5BVwj9CFILNy8//kITKXAq9FRRO6q116C7CZzf1D5AdjnGb5S0QatiNjOLGUo3ttLA87ShSZGBMXhm3oL6y+YRQ3IYyBC56HkjQV/B5wVeQdg2tQMy0DvLl0smgWMEqKBhfhgIFD6uYt7ZaY8yFeRRBJK33Yh8rLQdfHSFFavqKzoH0ou91o8TUEALBcsoZ82RwcgLcBiIGxXZOlFzMr86FNVhcaoyvzFYrEzTBg83/EvwtGFzrMtVJChh+qru7wbto17ADmE2dx/MWJ1xm4Rt27wUzgs6+4NMnwPfww5yPOoY9vIh5wbbqaGXbcqSA4qIKLJze3iRmPaN08TN95VXKzESBWauXVveuDQc7uK1d85dk2OeAlmyYnOQTaMWKxMCMY364fnhAIcUJ6p23X2DYH30Ec5tbzLcea84eYvdPdFHJBuM5rYT/MJ+fvF1lcrNOxFe+B0z9GnvPscH6/ZKsFhSgsTVua5ToWtTi3MoWP4qAo9xeDlqQ
 rD1sNhWQ
 YTWJ7Nk4qQaYpsqOKviyEO6EKt7fAtI5Yic9txFTsu2JAIthr4zN7m4nrDUZ1DydCsgC9gUxkW/Vqcskpg0B7wfmNcVyEeN/6t8n2SH33kTfG9BB4mJHaTH45E/sO0ifCJRTmO9Uo/nEJf+i2jCuCnf9bNm4k/zko9mVD9iJnWsYnFdBGC5rxfa/WmMsF5VlTxvumv/LNTIPUqelfvnhwjRntqhBnebZtCZx3Aft3vn9mgVtLIDDmhLnmxj2DQenh7PXwCPMEncB3m1zr4Z+awINd8joPiEMNguEovPulGO/bUMgUUPKvPZr9MLktGLkS+hSIL5E3CGi5D/cl+ItYvcXuzx0+F2Xcgo0D
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
 arch/s390/mm/init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index e4953453d254..1c11ad84dddb 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -86,6 +86,12 @@ static void __init setup_zero_pages(void)
 	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 /*
  * paging_init() sets up the page tables
  */
@@ -97,8 +103,7 @@ void __init paging_init(void)
 	sparse_init();
 	zone_dma_limit = DMA_BIT_MASK(31);
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


