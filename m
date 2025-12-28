Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C36E92724
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B843F6B00B3; Sun, 28 Dec 2025 07:44:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B381F6B00B5; Sun, 28 Dec 2025 07:44:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44B06B00B6; Sun, 28 Dec 2025 07:44:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 915656B00B3
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:44:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ADA813C272
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:44:52 +0000 (UTC)
X-FDA: 84268849224.04.643296A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BB40D1C0002
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:44:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mEm8Nhjf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925890; a=rsa-sha256;
	cv=none;
	b=Zxut04biV8yZ4/SpqUh1LFI4SeThF64ArK31beuS1MAvd8/vAfxttkIGhS6Wo+vEDQxP7/
	SZAsVOP4iqdzKxrtm2eUGsfFeOCksnUd4Fbui5Fb4eT8slOPjl7c7PkbCTe2vzmTRScew2
	FJi9EnOMbyOz8XlSa2lwD027Jc5fRW4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mEm8Nhjf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUP8A0oU4o/USGU4JF7iSIOLVJ/2u6llFeNZ4HBfxOs=;
	b=gwF0j14/B+fC+BsLkgdLePfFr7MeebzsID6kF+fkT7c0zRGIELNiILQXIj1WCM68Ics+29
	PWHSMDHqGVAnXjB9Sn3drr2ABhPT/rX3Xklx++18BQWKmfuHmQ+T4lCu4hCfbabiYTEsdS
	c0AysavDcNpfFwYLCF2bHBmQR1OAi/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4799960055;
	Sun, 28 Dec 2025 12:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9D2C4CEFB;
	Sun, 28 Dec 2025 12:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925890;
	bh=2fA0ShJu41IpFxgmfkKiNARLhjMIlJQdtqcPZZQwJv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEm8Nhjfa6WWs8SePkiyzNds8GzMMs1SPN2jgDBA0dfwWgdDDslcRJD+GKgSW45/y
	 GbOIkT3BV+fa0vU0kDDKhS3+67JuiXWIW4Jsc1AdG/WqHKxcYGMJ2iho93EdLWkZ+8
	 7mLE0tTFcfOqarDYFmF/qKg7Lu5I3f8nFV59M5Cxc1IR5mODrC7xvNCnlv31ejHDTp
	 rpLdvktJ3vP3bXGEZcAI0t9PA3nYG61tLbt8rOZz3BeRqoMyqdkKWS7HkdolRjw6xP
	 eMud/Jg+SPNHEg6cwsztEiHEgwUj3LbkXHwARzJa2ZS3UUDjlhRzvC1p8pt/D/jIhJ
	 fb4ImkZ5vEPpg==
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
Subject: [PATCH 19/28] um: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:49 +0200
Message-ID: <20251228124001.3624742-20-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB40D1C0002
X-Stat-Signature: hdwmd8n1patnupe7k3ghqkxr5uqyb9u5
X-HE-Tag: 1766925890-429390
X-HE-Meta: U2FsdGVkX1+sA5dmcYPbLLh/X9emMRBYU5QShblSRZqycbHkPZd6VOBdVXnzDnvyf9F8SHVgEcun8WbCbOtEZkqXLfQnyE9R1X56wLOprZEPcRqQbaMduvOc2dFethLSH+CA054tDsiXAHBAhlyAAKKKOW8KVgdq1E1NDrA69P3QFNAlD1TKdWu3LvcP8GGKbNyemuUlHg7SL14PTKHwe0ZJBAAGmk/i+17O8cg1Ej4hqnvtF9nASKdrpOachWj2PNSpMB+HISifBS1JdX+WopStWX5OQsjF9WtzORuhgJTf9uKp8b70F1l1BVdUztJBhX1oH/GxSdkvDybvzyF++KvYGn2gZHjhVjsr+4qyoJMG1CEc1nekmnKtywH6rKv2AZc2qN1Wu90KJnpi9VBZh7jrgbV2QFw3LM9+j2/25KFJzrfybJ6EQVdJYtLbeD0fbH0MWhwoMoeC0A81Tf3V2wFP2J81IUT3NnWC5M5NQJ9tpsWo5XCdGG0TuYioUSVwLpnsuRSJ9/aQgbJaodpAf72H1Lc0VVA8+z7fc7M5trLnSvHJrj69yMuRMNYLPTac+VrRIASTMuv8e81plgarQ68i+bTfoeFst7/gWxfZYhtJvUauNPgUyq1QeFOho3X0xYpfmAz8QfMeYfyDWsPD9adlbjCs119xoJ24AWa0cVFopZdB1gXsekNYicqHU3hJx1DDWkThii4pbbpik4FvmlOCcy7FGKruPIssmFw8hdKQG+a++LE9kJos4UD/v+X+f+jPPvrwSUiUKFXGF6ho3TK05SpuUyHDQAeD5l59nlMPWQ8vtzuEOBsJ4c45uRq8JwGWRWH9FhoMjvdAkLKfwFjCr9Ashd62xP85LgSh+tsbVcvCb1xY819rG9fdy4Uth4sPHFNpIEFNWwTr/SYb+dhp7k9UG0eQB/XUZMKplhk9uLdKA3rOA8UFZoeLkUOTtqYUeauxoeLBCMYgkzz
 MBloaGlW
 6tGLaM9Wy83pKi15RIJytK2tb3rrn7j4DCB4dXItgyleAtEl/Su68dVNDkiLePhGsAMTmmAvzTVeonKH7XEM71xf5b3Rzaz3cSaCy1MhJhTWUS8pFFohnE57FNw0DVYn20ZgTjsW34puLjlLmdj465rFhylDreNHiAo59EDpdRTlwB9wnn35M1RH4WCq8GKvH/y+qpV/yw6c0DBWpp07zwug+sNcrbv+phdixX5Dl6+8bXfnfoj0q5fadoRPHMVyL4gRwafuLhWTqPA8ZPMp0/f7EDg==
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
 arch/um/kernel/mem.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 39c4a7e21c6f..2ac4e9debedd 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -84,6 +84,11 @@ void __init mem_init(void)
 	kmalloc_ok = 1;
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = high_physmem >> PAGE_SHIFT;
+}
+
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
@@ -94,7 +99,7 @@ void __init paging_init(void)
 		panic("%s: Failed to allocate %lu bytes align=%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);
 
-	max_zone_pfn[ZONE_NORMAL] = high_physmem >> PAGE_SHIFT;
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


