Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9AAE9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83B86B0089; Fri,  2 Jan 2026 02:01:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4EC56B008C; Fri,  2 Jan 2026 02:01:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31106B0092; Fri,  2 Jan 2026 02:01:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE5716B0089
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:01:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5422E1A864E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:01:10 +0000 (UTC)
X-FDA: 84286127100.02.D3C6B12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A2F581A0008
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:01:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FFZ7SBqL;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4qD+cVO4njaR2WMTsE5cyiXB7W0CbhxQFlHvnJsSI4=;
	b=5BtD+jh5+OOiMY8HCUFyD3TfPOkozoPxTqZ3MRsrm2WxVW0OR7aCDoy6/ffpFmP6M9k37b
	nHOanUcoVObusQQNrlxazggM+UUIs2eo+ZW6GqaynojRa8nmyJTy/jTOs4IZBdTCZnCBDv
	pmqJHd/gulLolu5KVFl+jCzfTxAVbjw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FFZ7SBqL;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337268; a=rsa-sha256;
	cv=none;
	b=yabd7zxHWmE8ZhPdmHM4nZgRVWt+tReGNdm3TIEEolD3sN4qFQ/+XhQbvgUhLzALP7hLkF
	k1Pfc5WZDL4PvdVBQfQM48xkco6GD7Wfsi8C8xOgr2vFxCLN8bsLDKI1dOQ1D1Nq3hGVqv
	LfbWgu5qDVgoOvP2lqhUc/Y3ufkUUB8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6604417BC;
	Fri,  2 Jan 2026 07:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEB7C116D0;
	Fri,  2 Jan 2026 07:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337267;
	bh=sY65/RaZssilanqAkKMZORd+RGdNjje1eX8P0rlpw6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFZ7SBqLRszGA55Y0dcTAeVUAFfhPI1J/Zu+nhszyk401f32Bb6bWLRKqrB+W2AKm
	 N38QT5+aUkSxN75WEW+blTrdKEOqeUiAH0BX1iOcat59Cv/SoweGwGsDzNvWrsSMlc
	 3QSzDoZKQleHv/14oFELN4CDb8KsNap/u7uUJ7UeoPHZ3CgPa49XZbUQPGXWMVadAQ
	 iGDYvbAw7yh54e+JFc4Kkqc0pB207lzVasPVl3cUpS+igbsvBxYsRn7xuxZTZdnkDI
	 isfveZxYymcuq0kzbQxRSK8ezAytSigXlJWJalxOdK1KDDwocwk/lYGd7pPWjjMlNX
	 rJZb3YeomLfgQ==
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
Subject: [PATCH v2 03/28] arm: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:39 +0200
Message-ID: <20260102070005.65328-4-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: fq7pihe7rsyus4uoyshsmbr9sxy7ikrk
X-Rspam-User: 
X-Rspamd-Queue-Id: A2F581A0008
X-HE-Tag: 1767337268-469394
X-HE-Meta: U2FsdGVkX1850ooSp6y4/0V9hC5YYop2i49YyTU8d7qh3c3Aigq5Q+xxJ+0jRm9prJg53Tw/Do2BRHwadeL1Qgj+kM057hfeP7kDZ4nik2ur1/M/KTEKAEyYKQlME3MGu5fy5wBVkoVoYS114ZynxKEo8daQYaHwE3cvCMvqW4A6gd+ukP9+PHv+djIzEhb/Er8c/pfCJwVrwjzDhUuogHEz3iMmwgPQ/CXuboARZJ1YsD3BSX587d4QVCf/Zm1Np9BTNK/oIt9dlU4562RwEwSwIGKsRSV8Kx16yE+d+2jwDjdiSzLxJTGWMoF9uu1xsSE6CYQoSu/K3NQo3Umq1fKmfhWymY3caQ2+5bRF5our/VsxyYux4lB+or+zWjEqay6Y6i6U6o8b9yymz+XBSWhGMjVmoDnvoKJ9h004hfvPa6xB+t17wTO3d0KWAPRRQoHavHoT0KIBe80AQs3hv31ctv0YoRbV9pQvfH7fV0yulLz3dPMjppICameCrlzLdf/1dEFKnVCdhhdtHSGKCDADSw420xSH7F4DXFTDBTA+rUJObuy8E5AGuy6g2hLhByJotNW7WkzEinHq0RQ1BDcS6tTTX1tQelusr9Y4BZVK66uyZWt0rGI1LAvKnJoylKVPd2EOLDVz8WSL/bN0nkE16mP7PXVyJIVx7PTGjsXoa6ex6Sq9WJ4Ts+ZKVyxiuUOTCojkJhxfXVtfRqacPOh8OM6Dez/KNm+/YBmr2nD2jPAgeVfl5SgZArsCw8yFBoKuPt04KJk7QVnYsGlkFsfmoLf8mRclzw8bKdJ1BoM+ndVsfKLN3ZObz9Xzozg/Tykqktck1vUB8MnRpnp4IXafoRXXxqYdGt08XF3qmv5g8KXrl4ih+e1S5/w3Eb5EsWcsIWQlVJY+bXgK7fqRQXrDTtotxmETQ41E79mYR0oFzzr+NHPPthxtL43MLEqXs6QWp36YSAxC8LvCzc8
 IyQBDbwP
 5wuabp/ahTSoU/Va9QmOD+NYCKCh9P4tmdfjSpB7zoJnkxEsXj2ZD+vOZW6G9X/80Uv+GlRjnR/KftwVLm58/frLJQ6twBN/lPK4HINEPy4eaqQit1H2n+ixFbPnmgbjpfb3pOJ3hKdf2lvDYUypCMpayhxao3QE2/ZjvIjuI7Aq0WGefTXB0M+FQE/6wL5ZgMPNlBgTYdoP8KNOyUP37qGG1YFfojuq3rrIRyVki1jjwWG7ulreN7Q8QMS5H/j2Q3JMJW6C+fdhL4N0zFl0X5Y8mDA==
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
 arch/arm/mm/init.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 54bdca025c9f..bdcc3639681f 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -107,18 +107,23 @@ void __init setup_dma_zone(const struct machine_desc *mdesc)
 #endif
 }
 
-static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
-	unsigned long max_high)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
 {
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
-
 #ifdef CONFIG_ZONE_DMA
-	max_zone_pfn[ZONE_DMA] = min(arm_dma_pfn_limit, max_low);
+	max_zone_pfn[ZONE_DMA] = min(arm_dma_pfn_limit, max_low_pfn);
 #endif
-	max_zone_pfn[ZONE_NORMAL] = max_low;
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
-	max_zone_pfn[ZONE_HIGHMEM] = max_high;
+	max_zone_pfn[ZONE_HIGHMEM] = max_pfn;
 #endif
+}
+
+static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
+	unsigned long max_high)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
+
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


