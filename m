Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13F5E9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D2F6B00B4; Fri,  2 Jan 2026 02:05:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511CF6B00B5; Fri,  2 Jan 2026 02:05:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414256B00B6; Fri,  2 Jan 2026 02:05:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 303A06B00B4
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:05:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC1CC140386
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:05:14 +0000 (UTC)
X-FDA: 84286137348.12.2C0DC2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 33DC7100013
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:05:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X4nEWJ/0";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337513; a=rsa-sha256;
	cv=none;
	b=WkLu013wbCqbd3mXeCZzCEbH1r8Tmibw+qjj0m9FzqVT3v+/CzIGuBXfzL2zTvQIi7DAVv
	twz0zKOqWlMERmXZP34jNTOXM09fKoFtjNcyLN5uSy+KV8hkbqePIlP82Se5UARLUANDHp
	SQFk+n1Pb42eIbsVuRZb8D5rq5H/k3I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X4nEWJ/0";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azukzfgsXgu/EZDimou0ymklRTxVzT+QThHCfbcQvB4=;
	b=2w3Tyi0+mLXT8sqJRjifZ4NGMJHxGKmgYeD92ovwvM+Zdaw4OSC5xCqMCKSz4lZZOkyiaT
	kuWfcAMjLtIQj+1/+lQNKNvjzBNqxvI5B8GL0CGMpl2o++rdtJbBTo1q9mhncDKMC+E3Sq
	VGht0oT1lb53pwWbzQc/h3oSc59iaHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B0B541912;
	Fri,  2 Jan 2026 07:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5C2C116B1;
	Fri,  2 Jan 2026 07:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337512;
	bh=4MJzw8wq/vYacVlPos8SheQzjEj4nCDptI3YxDfhXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4nEWJ/0L+n3VAFD31SZ9u/rL4Rw0XhJxVYC7R+OXsmo1R+f6/lf31rINifRbzeb+
	 E7q+YbYslJsdX+mgT/DJOnTzdA8r1GLCYhATQ/6o7s0IJ73Te45CcPz4wjEFvvM/n3
	 ThGwO2GIstpYmbDXYc1dqebuTUIdt2HiOryT/ZvS5M8ujm1ShtTfK4zRsWEwkJ/FNF
	 8m/LHQ3fd5LrjZY8b6caOj2ahTu9OG/0IsdS9Q3L4EJW65MYUSuOxby2ogAIsiG7aF
	 EFowjrwFr63a8VLMXiTaiTSYHWDOX7bOW4u2qYH3Zafy+sjM5mjfd7Q7v9egCc3YOp
	 jgbCi3HZCBEVw==
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
Subject: [PATCH v2 20/28] x86: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:56 +0200
Message-ID: <20260102070005.65328-21-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33DC7100013
X-Stat-Signature: jt6osuqoyy56naaf7h988jch5so33cxi
X-Rspam-User: 
X-HE-Tag: 1767337512-67982
X-HE-Meta: U2FsdGVkX1+OibGL9LbAL6f2ih/CsnFJZdJa4ZRTNHuDMpiXwgm4Io9NDAO/bU4/ceXOLCN+ERFLp/JegR9A3VZkluz8hsfk6DUsTPwjblhzLSpPgLk8+zDgik8PxR9SmGpGTeRFbOkptIbcZw4S04+uM5wmER0OmEXqpXgg9NpgIQHn0+yv0ms5OqGOTgMbTWkkWhJv1/7ahikD0CR4F32M4U+yHPszV+rQAT7YYITlEykmu2viAEDhlaQOSp4wjAxM6qiVjWAA7XPMpLFX+2qrPOp+8sKaIy75voKoPuuHf9jhZD8sopMMdxl9qEEqokqP4Wt7ptO2v3YleZv1AhLuAlEBDTw/bD8K/L6SjUfAn7RSlbifk9hjkNCzHO49Mjzcih/x6HzFXX0R/0iX/SZs6RwvTGcKuRdhwxHI9ILF4WhiPylpVyqxLJlxgssfiujDQvls7Mn5MH8r3pCTNsGjddWJ/m55RTkvjxj7lTZwV8vrBQotMFHkH+fB/lNLeluzX/GE1Fbksy5g5JppWG4rSAYekGJVmev8Yxozavc2APfoahtkylb6FkxD+C5lep+JnWenVKm5WM4DygJqw5wYd1cblbypcU002rD7weGK1SDJYOhJG3RosJWFirk+Q355Tgp/Gd33YHvEPS06mKv15xE2kjs7kixdAFnXnFsyw5sD6WozdVDkB3/Vo8i9ykBhy5CGC7esDHFEZJA8gu09g9/vG/TYfcPMtJu87ip0lzrxtQrFBxU5Bb5UU3c2JbGmG/ZQEAWgXwyu/akun6Vx1df87POZWZmvEK7DdsAnO2dCP4e69xJSxbQHKfnJ+lJ/DxIrHw5fFUVNy4Jw7wEYbme6o6OEuKrV0zglDdbCoCOBXdppyZEUBG6EFArGCDciq7mnKpUx/zwJB6XHjFBkzywtqy+YnrEFQ0mxrNoVO4JfvlSM9dvzch7W5w0DKIdhc3ZuuumolNxxFG1
 G2OAbAJN
 4qKqdA9SQvqP6O2I7+1NAO6JxeNTNZwmZaguF0PuPdLATdxzlEy/QMEFj8FvbMSojKO196YLiyVXALpsRMNEFdptZIGOzHVVSEfnCUnpLYD/nbGk8GPsafx/Y7GXDPh5nzgT8PL0zdat6Z/1TnKgW9RqiKptj/rzh1rTHP3Wy3nGduwsvd/j+W5nNaOwcZ8EHAVnR2yyr0rbTeNVxm9y23yI907Y01O1wD6/CoEyNBf9UFULzOK5m2AytqBo6m3OfW9wAA1iIKdFeJZH3s/ME6xx52g==
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
 arch/x86/mm/init.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8bf6ad4b9400..e7ef605a18d6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -997,12 +997,8 @@ void __init free_initrd_mem(unsigned long start, unsigned long end)
 }
 #endif
 
-void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA]		= min(MAX_DMA_PFN, max_low_pfn);
 #endif
@@ -1013,7 +1009,15 @@ void __init zone_sizes_init(void)
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM]	= max_pfn;
 #endif
+}
+
+void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


