Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E534D25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C031D6B00AE; Sun, 11 Jan 2026 03:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0036B00AF; Sun, 11 Jan 2026 03:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6236B00B0; Sun, 11 Jan 2026 03:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAAC6B00AE
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:25:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 714EB1AB1AB
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:25:28 +0000 (UTC)
X-FDA: 84318998736.23.5987B3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B85991A0004
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:25:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c+P+a//z";
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZI4KGl4ZdlhaKQtFg5N51ionZ3BEZaRGa8lZ5haxR1I=;
	b=FDT+ondO16U0+GUM8JUpDWQd1G/latdsU0olxkzHckG+Z4JQdE/P7OYwO2iTOxMuf2k0rF
	ucTSIAOY5py7Dx5sbQ5IlpEvQtru/rb4rERe7Oxi9sr+73AMUf/VhpfV/CHHLi0cd67BeK
	0emYLXnrSAJMJej8HS7ZFijaZrgEG1Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c+P+a//z";
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119926; a=rsa-sha256;
	cv=none;
	b=Gk8MSFripgF3aGTW443vdUlgXgvOT2zx7+8pU/CEueZLba0bI5sZEorHJXzvquN5yYfgqo
	Fy0BwnmQDVgD9JnrcoL2rxCpUeFqqjNLEZwqRJYVj9CAKM2bMgPi5VM7gOxSJU8Yf7r6Iq
	2UZEA2aHuS6Xw7pwI5PMfiBuzXExPhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D50E440557;
	Sun, 11 Jan 2026 08:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE4AC4CEF7;
	Sun, 11 Jan 2026 08:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119925;
	bh=qZJ/kX6852xy97RGj2L4BqvkwDGVySCnfrT6X/8ZHF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+P+a//z4Nd5nIw0v+f+shPEprkJC1dixcExDF6DS8B1qCxJNhAn9gpWgY3+8tYux
	 5S5M6nBwReivNwSNXdn/8vuT0YA2vEEo0MxOaXXZ7/PYTBLJ22IqjIFsWf6fSvFriU
	 Xp/PcxtxdPH7dMXA6/y4k9GPtvHylLYxsywRRRuXL+oes1SFX8LWWJf3/H/FCWaM5b
	 3/5oyLuN+DtN5k0D9u+ZZMiZW5jvG2mpiqt2m0hga5FUwHpEnfNSjZsML4vSpltVef
	 8ZMgZSSbpINkDwSUrZONYkFT4OT4WwQePp6Vv669nytS4Ymj4bdmUg/4ZkvKpXSVhU
	 wY8POksQVxL1g==
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
Subject: [PATCH v3 16/29] riscv: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:50 +0200
Message-ID: <20260111082105.290734-17-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jtfyedatzfg6b5r9pbfus6wd3hcz57en
X-Rspamd-Queue-Id: B85991A0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768119926-312340
X-HE-Meta: U2FsdGVkX1+j/xc6oYRyZdVzTSyzyEdw/n5G/qjN+eUA+aA4TOZ9QCk+7qPkmc2S5bMKP5H7MetPmS2GFKDF3m39y5avOaKqa4b5qcl9ZOc4zikTF+xi2Uh6UGVp6fO6PgBN6K53k09MC68y+EtOxUiO6WIBcvpMGw75/XSUDNshNwGpostgfmAF+gXlj6KAv4UmVTCOi9moveanGUmfQdvort/zsvB7OMGdK83eb+egQOi8vV3I9nLz0raY0ZmmxHnC5lGxH+Sd0gWCRWdZF3W6ybC9jJZr1qPPtmkSlUtOC4/sSfc6qyTqw/hTNC9ypmsN6iYQdlNKf/CSYUA04bmgHsYOBQLejXgFb4ytNWg6d/lxBguldsF1zGra8vkIU0DYCEso/j0niFrAEoEy6JdVktnqJ/aW/oTuEEJCrP/IVmA5Z+5t82aoFYzGV3wBkYpH0mbAf7QotQcxk+DH7uAnYcn+ov8/4h9OryVzfl5d9Bzjb7q7eNIhavnERxD8rrrpe9rXTgoQRe9UmO7BEXacSCRVU1rZzBlewf/Fz9CZFJzJA3YN3hkE5NBQg1w0kU0wgMLq6IRwS2/fCCUrP3CbOiRuZx+sE/rneQnhCj/OyfNfblDDuGbkaBR17If1Dwtx1MwSRdbo5u+cIYiaW4K7AjWLy05pF3Z8o/Tj1XDBOLkXPCSc5IssLy/h1pM9elrFKGBD9jwjTZAw8/NOaWUgwh8JPJSX8ePjL40SfC4Gi/fWUqd6pg57pcWIQ0ru1s2ArY7fDFB13jjz+HldaYeGRumpaF+AjHBzcaXQTFBP2n7CZwRH2vw44vv/R8Kqm+HW/YJrjZzEYGws7Kl8dHxHoAxdGugw5InJGWOwzIwLZNinBOhXaO1Ta3h0i++HbeF0Q4wOPCk1xVWtmEnAWoLcDDCHlFGVxZbOInavNqP3LWn/znkP/lmLrSC3GACV8xjjkqsE/4isYZ7kVMn
 I8tsTlQD
 45B/nt+AyTEWPgeJDfMZ7ZyNehhmyYqR9FIxDJmRzEaFLvG88cXCt27WQsLpAGLqG+qGz/durhowK/TRDIs/gryX+ETm9pAUEweT3mFTnOObUDBpkuD03oHgkA7GpiofTc19r3N+JKq+s63zFAzyfP03TGFzbR91j3OdOtVk+QDZi52VN+3mzx29CtEXEL0JvP7lku704AQ1ka/OoqiQXzfUjg/kzumLA9MYCKYfbfeaP/7qUmp/89V+MgtStfvyY09Jqvdu5InKas3hVZy0fs0caO/Q9RO+eP/nVfu1cQZru5xmiVbDWoLo5UgTG4XVzhRnTVwGV9IClfawZIL/sdsYAm8LdTh1WEPUN
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
 arch/riscv/mm/init.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index addb8a9305be..97e8661fbcff 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -79,15 +79,19 @@ uintptr_t _dtb_early_pa __initdata;
 
 phys_addr_t dma32_phys_limit __initdata;
 
-static void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };
-
 #ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(dma32_phys_limit);
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
+static void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


