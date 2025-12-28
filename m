Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B7BD3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4DD06B00A2; Sun, 28 Dec 2025 07:42:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20EB6B00A4; Sun, 28 Dec 2025 07:42:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D442F6B00A5; Sun, 28 Dec 2025 07:42:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C23D76B00A2
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:42:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95ECAA47A4
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:42:46 +0000 (UTC)
X-FDA: 84268843932.29.BF25044
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6655180002
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:42:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ViMMOSWV;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925765; a=rsa-sha256;
	cv=none;
	b=s44H+dna8St6JV8PMCoXcuudUpMHWXGb0I24VRrIdbsDEll0uhPLcpZNLGP05In4U22WcZ
	phEcO2Zc9uwC63Oivphye14NXthKkqgdxZW1JoZsSpKjcH+wz4zFYTHdT+RQtJaoCy18Ja
	ZWOfNc2vAvhmX0T+Xr+YdmAnMIg45nY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ViMMOSWV;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9pBPAmCex859p6JrPopJFcFxfKxR6uVnsR3JS1C8yI=;
	b=ehx3jpjRxB0e5TPoxmmPB5lAQnqqDSqDBvaPgNIM4aNjZdq83CyDDqNqMjcsGoJiVc0U6y
	DtHsF7zTnpOJfwF8ppzUBKtEKNKtKfPJhyo//stGQoQJ1hvX7u6tHv8C2OSGbYfxKCW9cZ
	vwpCdgvh8iUJzCx6jFgtmS5hqjdyFUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACF1941B29;
	Sun, 28 Dec 2025 12:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D418C113D0;
	Sun, 28 Dec 2025 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925763;
	bh=es+FUCZqCY2a3nIkrdLdpQV/rxxtDtuUgA954vVF+nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViMMOSWV+SO8Y1QT3gcfgTROcYwFDdhD4E62m2o7O5ml+SO6KR0W3xeLjN5LFh2L9
	 nTGoTBharuZFykM64XsrU8t04jRzTSXDcwZAEgk7m4EZdukkEuX4BhfaQ/pn024hi1
	 ITAf4N60nRRezJl8HFf6T2HuAVC8rNSDq/DQVZt0MKEDAU/XiCxHgBjoqotC/PfVSj
	 Ku/O3wqV7qF6z1/sIzcV4sMDzUxwcCKKgIiHrTOVQt9XruJ083ooQW+9LOgBSq0/xX
	 GexqjL7EcImHsQeMlZBU0JUB2VIoda101CBmLeeXfVeYbY1a9Nsh6YJQHJoiQitGSu
	 EHOjGCUswXkpQ==
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
Subject: [PATCH 10/28] mips: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:40 +0200
Message-ID: <20251228124001.3624742-11-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D6655180002
X-Rspamd-Server: rspam04
X-Stat-Signature: i9ncb6t7nr4ce4wf7i5qy9rq797z9n8m
X-HE-Tag: 1766925764-876692
X-HE-Meta: U2FsdGVkX19g5xZYonqv7aMw703qmwZ7aPKNimKDuDFjv1FZmoZ2LLtcYesEqrxBacGkWT/BvRNJUcdyJuP7KOyJ54Wl404kCzrjPx6vjHDJMvR+5D+cMVGFNacCvw5QABQRiOZhlKMw4jEDy53oCBEePAPiFFWwszz7e06uLjh+QlnPveVuMzcqmXtucGojTWGQ6RWbed8oe6yqmifGdQ4Wkih/PBd7ONEXLHYYyVRk0w4tzQcg07nkbmBHtS75Z7PMshDovqFlvlgbc0u25Af86MEFxxEllqmS0fKcssU2MCjt+vAa9YCMubmLuPiSks6e6bkHH4K+2EPZ9FqHzI8GbCx1C22vMs+QmrUtX5scqKbMjCYkERuutyfyOczC7x+rwTZ+OguhlkmIN1UlF2HV2g9eu57R0ZUuCJPzXZvtxpejY+EAjcnJx63+Bn9t1hFYkOp9GhJXSnI2Gwt5JPduwR/vY+H9LMj0oarPumDwKVv1LsNqU8ugXF6IfVQmaUv9XcfzxArNyCSBIl2tKE8ge+JUZ6QN2FDAzV9PJNqHsdAxN5bG1ZoEHoJhUCP2IHWqNkoeiUZAJsRlsp4fnJAhL2iKE/MZfAmXHthmRZnQyWPtPXfmLmkt/06U2okxZOOQ+sMT7Hy36E+yzgN9ZxWnlAc3swhCDeHFRTJDgD6ol8jn7lKwXjXf7Obr4FjT4ctGiFlnQ3jLbq/QDRbXg3qlbkBrDJrWfkj7SzOqDKHNNwqORP6K2M2gyqG+Rc+oAqdwJ21vXicvRhp1DXCoia7zuGKGh8ciBCuiGvxq13cUOZfNwdytV133lFsw3wXQsX6YdUa9eRN3hDpw9nqxZ+Mb5nxATxSJdRs3Wp44fQbTnmj2dWWHEkg9nAexItz+4w8VGCSzgImYDEfZMWoinq/u49flK3msyuO3rGCubBD4k7SoaqNh531yazbIOAYRucNymwwHF2CsDCsI5St
 2eXJ0a1Y
 puIqB2BcOMExfQ80NkJLxulCatvctjxmSyUsw0JoyrpN9poaonkUKql2aFjAoU9DlpNBGRKatNj355SSdjX2bk/N+og0y5hTzpd8Pw0vsuQDVq+5vDcy1fweFrqMbxOzF3T50V35quXU9K0C5EjOb3nCKt2Y0xS/SvF4oUv+0gUuuzUaW6Z47ATrD9l8LY/QuiIfo6Y7hjPHAsRUlYAE+cx2uSbEN/WFtt2DkwdNMZNlzbbi4oFp2yFzGumNqdV9Sk6VNJ2ccBz/Wvfqup7gpiqRNYDAWRCdx8c/U
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


