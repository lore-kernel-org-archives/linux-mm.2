Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA106EEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEB76B00A7; Fri,  2 Jan 2026 02:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D346B00A9; Fri,  2 Jan 2026 02:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2830E6B00AA; Fri,  2 Jan 2026 02:03:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17F8A6B00A7
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:03:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2EEC160398
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:03:33 +0000 (UTC)
X-FDA: 84286133106.21.DDAE65F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 504D24000E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:03:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+po2WfJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337412; a=rsa-sha256;
	cv=none;
	b=bdf2ukVLurzjL9i+Sws8FuMNFESVU3yQO7gGN34Gq+6+SaI42tZ/EPsLIEx1a2OxgJKvtk
	LV6SV0nnSeOZwbLOZGID/TKh/krr+NCywQjudvNLtwgkGgz2+OYv5E9TndVSn51LZ6CmuT
	1D/gg2yMvYsPwm1q8fx2WFVDPgdecxA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+po2WfJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0e1TP9uHkBT01ZDJQE0AgwbttmTnnn4XmEl6uPF92cY=;
	b=lHfHtAIRJMZksQye532tzIMyNAZ4489u0DWjQU/EEh7WDW/y1yVito1L+SKt6eW6uWnQq1
	dyIMkVwq97QL/eDMljt3CHyUvorJKchgYOgn1Kd4KPZfXE74nHDwINtV+Ir2Ub98ReeAi2
	cd68x5VVp5X+3d1O1Z/GAZk25g8ersA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A848C6012A;
	Fri,  2 Jan 2026 07:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A1FC116D0;
	Fri,  2 Jan 2026 07:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337411;
	bh=QDpPHL1GPSMeFEARdEipDTbBSW8I0pBG6cArIIAQB88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+po2WfJ5cf6Y//AOAe02jsKCXLL1vmZoxuQ1QHcBvThXBKTFEQQ2OnGwxTOkmmIw
	 j4tzubZIqYEK7dRkiyIikFmnnyvXkd7McLgLBkp+K2QPwvdpxhnyk05gqTi34xwrvH
	 AUQTsnMF8v0vz/rUkG/myY/O6NPP9P6zB5AvSlXDH0jyaAXOaCAmujV+5S9z64t+Zc
	 z1uw8GcOCKnLIlwsVK2vFCMVLFiCIxxqeq7T4jQ6ku69bwg4Bo+lmmqqz+ng+UMbt1
	 xT/vHjxJBRXmMHCojw/k2DTg6RnLsqUbGkQVdt0owk5pNwGBzW2iAePwwxGNIYhBx6
	 z4vj6qkfA9hdg==
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
Subject: [PATCH v2 13/28] parisc: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:49 +0200
Message-ID: <20260102070005.65328-14-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 504D24000E
X-Rspamd-Server: rspam03
X-Stat-Signature: krbsq1h4gfbgkmorz3m95o67jr1fnatd
X-Rspam-User: 
X-HE-Tag: 1767337412-170888
X-HE-Meta: U2FsdGVkX1+L7QZEYxZ8OMq9RrQcZPjKCVWi3GSUC3D7JX0B6u2sUC5B7Nq7WArtOo2v/m9O5bBoEmwnH3N1pmizLVbvCq090boe8OZD/BdIkznUYkn/6k7/0a+lqC1RBz9GlislSFBAL8vELEq5WTLMiTgW0eZ9ZG/eYC2VYiss/XJ5pnasBTxmMws97HzqT9UsFoDiClhYKy1uWF6dO1p+Q18qJTL9f3axvdIgMHLIYt3m22+WiqZwO8fZZUOH6U5yiY3s0pl1MVg9S2GRoA0Qu3hAnVrY1tk7/TZQgrrZdEhJWKRf3BUJdGnfPcvGn5Z3/qoAB8Q9qDDJhY8LL9P84KLlkJGCWE4pV41ANyMMZQ5JZYMAuw4gPYN1sNzJZSPkQ9KYTFwWnEbG0xdjqDHNUAy4nbsQoLUV8+wAKWbFu0GF8eEUq7orY7Gl/fpwCcwqCjtR1U3JLobrWt3g42rmLjWNfglaFEipkwtCTxwEzmRBEzuY96IpRe+OifkrB6SNGgvlcANaozi9yoQE/HKE54Uk1tRIlOY3DHF+qo6ehMRoSZMcOqOpqDoXPnRszqryYAi6KU0ZoEWKohdNX9XZicJpwuc45p+laDs8K/sibiWemggsajewm6k3m6+3RZSV92sejdv4627p3uN84WSyaB+IM7WwQq7oATuTOaChdEfmjeOoyykXx2vXGm9cH8cpYqVvJjcd+Dt4v9eeTIK+yGrqWCGfnBXTaFxnDlQ4W0hD88Iexb3C+yQu9tF4P/pVX09hria8V9Z4c0JbgiCbrrad3hsskY3UZeLTIlWNWnKDdeKqeSaYIqLntIgchAxAnNuktgK6p+5+heJDyanFYqbnPlYWjSDCKrA7jaCNKyaWxU1O+tYEo+jM3w39ESBHFxxVVq2JYCK90kV2+U0oT61XFzAAhqlSLoB0gwGOg8FnNOyoz8Unsz4OqJKz/K8G+XHGqON5+n6uJKg
 h5wlmGBq
 znxHeoY/zoc6jqzZg3r7JB71d66Wtm5AB2x6yMMswzVQAnxhCga6EoMDHF6XhBuF3ELKOrWyE6vU1lGI8zpL4qMfeoCtnsns342Ayx8bjFTXmMQYlcw6ob7GZ0h+MtEUbvmMgKVjsAdiraj+HsmUHqVv8WBuSiGkEc1tf0DcoW72taj3As5OCA0wLAjApnxQu0fIeKXz616CL5o9n3K6itkuwX9XmjrGeK/LhZvVEk/EgqPP/NZrdu3nBzmbjMOoAmAe0me3+XzMcAoQ97zBJ7WPGhg==
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
Acked-by: Helge Deller <deller@gmx.de>
---
 arch/parisc/mm/init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 14270715d754..dc5bd3efe738 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -693,12 +693,16 @@ static void __init fixmap_init(void)
 	} while (addr < end);
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = PFN_DOWN(memblock_end_of_DRAM());
+}
+
 static void __init parisc_bootmem_free(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0, };
 
-	max_zone_pfn[0] = memblock_end_of_DRAM();
-
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


