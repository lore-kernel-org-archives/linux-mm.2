Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEB7D25037
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B546B008A; Sun, 11 Jan 2026 03:21:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC0F6B008C; Sun, 11 Jan 2026 03:21:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADAB6B0092; Sun, 11 Jan 2026 03:21:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECDAC6B008A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:21:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68DE8C1B6C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:21:56 +0000 (UTC)
X-FDA: 84318989832.21.2B7C51C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D69721A0008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:21:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DdukbAEx;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuAgXuWhuh/4/DqNt5iu0tb5y5LsF0sumazLqdyIUYg=;
	b=gP/eNKMQzbOIEWRIdu4B5XsnEUQ4amoBtm1i0oF4we6+ZbAhXD13TAKACIgt4xGVmroF1Y
	gJdjkZ5MG5PLPBh5zo1I+5xIQOU53XIDYJIAK7QmQpjMwEhdVGVY34TlrHtY6jM+RgcqWd
	NAY32UltB62UijylVOeV+raXZIPYD/Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DdukbAEx;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119714; a=rsa-sha256;
	cv=none;
	b=HS/NkYEFQ2CDNqDOWVY21/xsaugIPaFHnn8JNfPHydS4KWuvZDkZH89VpZNIw4g5RWoFsM
	GefCNhSIXn9Pra9lZUyStvUzyPUYhd5jSYaVo49hidRk0v/q/eTpCVo6APstSBb6L6SrYz
	uuwpZ8D3HNZZbzjF4u28sn1xAu8nNR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A27D60121;
	Sun, 11 Jan 2026 08:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C598C4CEF7;
	Sun, 11 Jan 2026 08:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119714;
	bh=8QBv9t8LGsuSX+POQQCKwB4fxaLECpliYPuyEC7/9g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdukbAExezEnhPD7Fz3wOiEU/vc0M64uJEir3HYWzx4ftF18Ax4Kx16THz6QJsu7G
	 E7jlAsKeMb+AkrIybQ34sKwp4Ag9HkaBJWByLQtL3mH+3Os/7fMJxySVZHiRW4xVe5
	 k3QE5dTNYYB+M/SfE0t1/i0VxmYp0VwLJkLcAkEp1g9/uWrRVlpTzL0cbkcs5a3pLw
	 UwuXLA0sVTL9DaDVBg4Sl2xRgUWXVFQ5KYtJQkT0kDc+lIR7wua8QQPkpV0/Pwyplx
	 WYfk3IAtXbovl1JeV9CqcFYijlKtF6ZPmguYMVbTa+3iCmyCADI4Ifhnu7KIA4NkzI
	 ybbHzamQouxpQ==
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
Subject: [PATCH v3 02/29] arc: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:36 +0200
Message-ID: <20260111082105.290734-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yk745ywf1t1eq3yys67gk98yco9buq68
X-Rspamd-Queue-Id: D69721A0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768119714-10060
X-HE-Meta: U2FsdGVkX1/u/XrIJFlnSCIM3Rd1ns+PaP2D2mI8AlLgu73nMUESVPP3YL+C8bM5l1XMvK0jLk7jyuJogkIdyeqKB86opeISNMyXLnehN9SIufhourpR/6gKglxOzJTRymXUFtMyVwnmruSNBuuTtrbE//rhgrVVP37Y3Q8j9QM+8voCzXKTDI7MX0Fkv56KyOH5Z4XKQ1/g00oul8Byq3zb39ZJgnbJVPAKXBJiFH43tGeb7TiwWI8xXgADFUyzU9UrdEbtWp+Djs2RBymHwK8z4C1gY7S2Rjex2tQSGb7MgG6jdCSFhxVqky767cQEJnKXp4PKGSXEdBeWj8FD5xX03NcVFZX9OmYkwlTDazgwsyC2wXIHm6gT0a3tU7nJkir27dKZkipO7beMwyIR5wySG1W5ZTbwn0iX7siWFR4hpVro91QH/VMuv5DstwiQdc65H6JxSgg0ck+lSTS3ilMaj/rGcsCNiTbpYXTDZSvJUDipY3m6pPqWfNOSpri8nnvcQvmfvDQfciw0uGPA+XAW/HzxYzEeI5P6tiFamnlHrgCbJ4+3a741xykWkdddeNHKjnjKK7oMjYlNcfVZHk2872jz+w4Um0k9lH2PO8Ge3uS9Jzn48ftxPLR+aDRIy8EFh7Z6jA2g/NgQaVnpY3P7ADCK7SL8q/kuxuz64d4nvGQTYCq2SbpHQxH6sI0viZqinX/qSFi0oUPGPc7iW9IJCsYUiHm/DOmgL3udcHkQQdsUgGunLuetduzsV5U3dKeeHqcdBex+WDo3K6J79M5WYDCxvgk21rJ60SziT55U0qWe75L4rtjRd+l4n8E3L5gkYgnMJPuiVDYbI7YDub0vgKL7CsPjK7PZq1PeB3KvRf6ieDw6xv2iStyuZtG/i70zhKRMA7oKHe2I3YRUzzTzhar+WIFlVFxX/wWQVe1+9HAgMBBHRQ+COpiRVi8UemeN+v6LFZCDT7fIq6L
 JOc+CATc
 EtOibEDm64PLXqzL2cVguiI3qUZQzZB3mrBnfAOxPDeaCUyakvwZQztQ66fk9z3wPEzKQvGddgMNbddYnRtc34EEv7YFG/M1UZltHqPIiL8oZNA9cpsQRuxF2fICdixoWRIiNCeJvA8r9J/m670dfy6/TWINuVJSdX5UKrLFcEzXfnJWTA2w16PFVRANRgylh/akDfWGazF+87X2kJit4n2TnMB28hjtCiMwQZozAX73ZwUPvqbiQUQBGQlVEq8nME7xKlvALWIypo9m6clI1ctjjt3D/F+mlgXmwQota5b11KSl7fWSdoAiSnHke0w32vENZRMfB1omDp83XRnV0UGZlSNoeE9flsQ3h
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
Acked-by: Vineet Gupta <vgupta@kernel.org>
---
 arch/arc/mm/init.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index a73cc94f806e..ff7974d38011 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -75,6 +75,25 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 		base, TO_MB(size), !in_use ? "Not used":"");
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
+{
+	/*----------------- node/zones setup --------------------------*/
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
+
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * max_high_pfn should be ok here for both HIGHMEM and HIGHMEM+PAE.
+	 * For HIGHMEM without PAE max_high_pfn should be less than
+	 * min_low_pfn to guarantee that these two regions don't overlap.
+	 * For PAE case highmem is greater than lowmem, so it is natural
+	 * to use max_high_pfn.
+	 *
+	 * In both cases, holes should be handled by pfn_valid().
+	 */
+	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
+#endif
+}
+
 /*
  * First memory setup routine called from setup_arch()
  * 1. setup swapper's mm @init_mm
@@ -122,9 +141,6 @@ void __init setup_arch_memory(void)
 
 	memblock_dump_all();
 
-	/*----------------- node/zones setup --------------------------*/
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
 #ifdef CONFIG_HIGHMEM
 	/*
 	 * On ARC (w/o PAE) HIGHMEM addresses are actually smaller (0 based)
@@ -139,21 +155,11 @@ void __init setup_arch_memory(void)
 	min_high_pfn = PFN_DOWN(high_mem_start);
 	max_high_pfn = PFN_DOWN(high_mem_start + high_mem_sz);
 
-	/*
-	 * max_high_pfn should be ok here for both HIGHMEM and HIGHMEM+PAE.
-	 * For HIGHMEM without PAE max_high_pfn should be less than
-	 * min_low_pfn to guarantee that these two regions don't overlap.
-	 * For PAE case highmem is greater than lowmem, so it is natural
-	 * to use max_high_pfn.
-	 *
-	 * In both cases, holes should be handled by pfn_valid().
-	 */
-	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
-
 	arch_pfn_offset = min(min_low_pfn, min_high_pfn);
 	kmap_init();
 #endif /* CONFIG_HIGHMEM */
 
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


