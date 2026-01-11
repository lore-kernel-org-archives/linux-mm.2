Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C67D25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A246B00A5; Sun, 11 Jan 2026 03:24:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341BB6B00A7; Sun, 11 Jan 2026 03:24:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2234C6B00A8; Sun, 11 Jan 2026 03:24:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 125B96B00A5
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:24:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A00A7B8A64
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:24:12 +0000 (UTC)
X-FDA: 84318995544.11.C98407C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0DBF0180002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:24:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="omxz2O/a";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9pBPAmCex859p6JrPopJFcFxfKxR6uVnsR3JS1C8yI=;
	b=2uVxihdc7k99ihPIDlr+kgAhXGp1psIUoDKUmL2w/V4a3WaFAZLnHocrEHceQ9JanRhnCt
	KMSLKcXm9Lji5ZMS82ye8WqHCDiJcXO9oxQR6ECSYmiPlAnIk6pUqK8ynJBjMuc5rNbKfY
	jZqaPTBHRwR0x0nEc2fSGC8tSRxvd4c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="omxz2O/a";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119851; a=rsa-sha256;
	cv=none;
	b=lsUNPwLQN7GMxzIogqYcqCS9uxRPUeQ28yV0SGOfSCmd6RwIsT6hyaCGYqWYap16tjtaYG
	lRXsACznTJnnXHp/3PLKWGl7EIN03FQNVLGjnyKPQ7Urh2Q7LFYW5rwo1NUpyFib3l83ji
	MnG31Pf9ry2VIHJk2K8oDYwjuboSWys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64E9F60121;
	Sun, 11 Jan 2026 08:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDCEC4CEF7;
	Sun, 11 Jan 2026 08:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119850;
	bh=es+FUCZqCY2a3nIkrdLdpQV/rxxtDtuUgA954vVF+nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omxz2O/aNi5ef6cgYnp+37iqiEb04KQOncjs53j7rIMU4VDGgOX2pBVK2nRapJSSP
	 k1CuMOi30eMl+WQajuUXdkhrkdF/m7Tjfpi1B1LrHprBPHjP3Zf1UIt9glL5fkqxUL
	 QQZKUWdSoT9RE+fnq1mBm4qFs6cY5r3sDiVaFaCuBFzDu81I1W78bWXIWVFE2q2L3O
	 YclKYARGBbQMefEdS0nlKYU0XZKLXlE5121MF4WFj42HdvBhME3uC89Nz4eJFFnmrO
	 wu9spXNqayKnIkf8mX9sEG4xfajwEuCKqQPc6BysjXlagd9N7BdqHLEKZvZtn8KDOr
	 Z9iZjeEhDIZ/g==
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
Subject: [PATCH v3 11/29] mips: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:45 +0200
Message-ID: <20260111082105.290734-12-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ssoqxhcay1jsjci3a8h7mzbsq74abnkx
X-Rspamd-Queue-Id: 0DBF0180002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768119850-281878
X-HE-Meta: U2FsdGVkX1/aSgrOYJrpCDwF1pd1Mgu63INvZYFPRExQ6vVdfz/X7REt2ceyKQTPZelMLY1Qac3U4nBf61pq79DlEu/vlJbpUzszY1FCuamIQRtHsUpDas4H2USLnRiRjCtfVfxSGUCSsBQAdH1vLicFqfSdAETzkGXHww/IR/FFN133FDG1aGfuYrm5r/DECCmCwhJcn6RQQOWHGsaAWrd3LKh3uapO9EK5HlJFOLg1JzsK2h6U7MzQ22+F01rffosqZJWFg5nreGxt18oHNCI+VrNgRLX1g8beYzSRusSr2s06wvOF7zhCgZZWyvMctKNixWhU2Pr+FdykZZPONsO7tGfrt0CIiWS1CU4NRQ8TVORzC2TOXO05a7mHdeKexXrBl/II6/Y8QpxVOi/IwhCn6Tfrg57oMRt0YX+mpZ1XSn16lus5qWagleRUDrHoM/CVgR7YELy4YD0FfEfBAP/sE0exr63GkpN3dKbF3eAPbQW0c7bYaPgHOrkT5GMKeywXDr+zYfbZ5pxCGXJX0tH0bcedGelvQe48skYw21PKLq8ruVZuHZafyvdC49VPQa3Brhc9zG1hXKdjdN2fLtJh1E8pCZG+nMXqJTd0xMlcY8BvsoGWA44aD5wQ2xNZDloqvX2Pd+Rr91JT7osflKp35Rx4mj2G6MKisoqWtD/qt6YuuRKcf1tJWxMHoRL/sW1F/ojq06IGfGggUGNDL/QdNNgTUy+S9QrFW29ujKyoEWcnpv5EI030dCFouuSlPT57SzTNZvdpzlpqHe0SnhvUlQa9WuJYWBVLb0cPipC166/8efMUpNOKK4pPMMfQPqBlx/q+G8Ehtn9VTp0QV0jCerwXGUxZi2Enyh0vl8xXk2aASeAcpuWIFU10PqO/dA+K4ZJVqwyDUACRlB8WZglHUIeUlKemXpBqC6qB/C1fAg+KxI19ebPfsWEX28UVCA4SsJCQI29F9F68C1K
 6y+up2EF
 EwrJ4eTP1Ujrsi9+K6m91LA1I1rJNruDKuYrhraY6eiK3avyns6/jmEN8MYp3aN6LFtUdyAlhWYK8OI9O14AUMWFWd9p/UqkDnwad2bvKtNBe6+JUsWzIrDx+JWyKdsBwgsMe2/q5CUFUzMg/y1HthWWb9QTpRR6eYgIoHhsOJo+zz7JvJeeuICGxRm/AIsziiuXQtGJszPxSO+NRp0xii/sRMiKOirJPUiCVrjRKtW2RyN9aGR0Ed1v9io33ye9p5DFHyUMV81razkQSi4r2mpfDnYlli0GDrTMIQsBDWq0JsSV9B4oormbqPAYReDi9e0LK3lt3V955DCpy4jLXZkNkoB75H7rAaCcD
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
 arch/mips/loongson64/numa.c      |  9 +++++++--
 arch/mips/mm/init.c              | 14 +++++++++-----
 arch/mips/sgi-ip27/ip27-memory.c |  7 ++++++-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/mips/loongson64/numa.c b/arch/mips/loongson64/numa.c
index 95d5f553ce19..f72a58f87878 100644
--- a/arch/mips/loongson64/numa.c
+++ b/arch/mips/loongson64/numa.c
@@ -154,13 +154,18 @@ static __init void prom_meminit(void)
 	}
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 void __init paging_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
 
 	pagetable_init();
-	zones_size[ZONE_DMA32] = MAX_DMA32_PFN;
-	zones_size[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(zones_size);
 	free_area_init(zones_size);
 }
 
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index a673d3d68254..ab08249cfede 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -394,12 +394,8 @@ void maar_init(void)
 }
 
 #ifndef CONFIG_NUMA
-void __init paging_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	pagetable_init();
-
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 #endif
@@ -417,7 +413,15 @@ void __init paging_init(void)
 		max_zone_pfns[ZONE_HIGHMEM] = max_low_pfn;
 	}
 #endif
+}
+
+void __init paging_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	pagetable_init();
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index 2b3e46e2e607..babeb0e07687 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -406,11 +406,16 @@ void __init prom_meminit(void)
 	}
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 void __init paging_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
 
 	pagetable_init();
-	zones_size[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(zones_size);
 	free_area_init(zones_size);
 }
-- 
2.51.0


