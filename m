Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA76D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7D76B00A3; Sun, 11 Jan 2026 03:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67EF86B00A5; Sun, 11 Jan 2026 03:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DFA6B00A6; Sun, 11 Jan 2026 03:23:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45C636B00A3
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:23:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC080587E2
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:23:57 +0000 (UTC)
X-FDA: 84318994914.23.8E2348C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 23FFC80007
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:23:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g3wHwPoc;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119836; a=rsa-sha256;
	cv=none;
	b=0fvgitIgwQC/FZMFKU6gTu8Ks+fSQBUttwK8PbAuIIANHnTPKGAmvzlJ5Z7NuV06vju2He
	WKJ2jxm8+CYcZ1rMD5Bz4VC/dMqgdB/XKqWejw/WkJFbnOtldALBx/0GSnMXrNTNaLAE3E
	2TeDOnQdk0vDA0hr9MYUaJ+SZu3ksdE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g3wHwPoc;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyJA9x7hsheLXPu5a74j6NhGqDdAk1HT6a+T9hWh9As=;
	b=ot7+O4KGZoEp4JKwQ2P3O5o3uBhsQ2t1MYs6HcD6ySTJZwGIfVP3xcIuER8PsloA6tUmir
	fpHFo46Zsom7MdsezGQFXEgTklVbtiOSP4uPJ7jL7g6JuEJmwNxXyUueINqUlQKjqd7hCz
	14lLlNN9v84Aa/XHM/0yJQcqZyOug1M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EBF4433EE;
	Sun, 11 Jan 2026 08:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDF1C16AAE;
	Sun, 11 Jan 2026 08:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119835;
	bh=BaQP+Uyb/5HYpSHuMHqe6vNV+NfiesFf3EGC4lY1beM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3wHwPocaQXOnS8cXHgOmX12aHCxvtlLv70zRh12gWdkID9iDhtW/M31MNr0CmpW/
	 OowJMTg2aWmS26IEeqWDUvMwf+2LiyPBSfKQuBap9dt78myiwkFcqpKCAmGm35wJ6q
	 3z82c3/N2GJI7+GiOAw9w6S0UM0kmMClrmm/5o2QcwaFzSSsg/0gNjiqdXQnTjvLGE
	 IrMAMMU2xQivcvGmYkOhzMVAwM5VPKlckGbnYTdOtMh9ZhMUdOj+tOZ2i96vt/iq0g
	 YvrbDjeIX1Dn48J/V7fFLspSgLvrm220akCtZVLJDpVdhhH0iEsLFs7uJJB3YPxvHs
	 h9VPQjmlr6wdg==
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
Subject: [PATCH v3 10/29] microblaze: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:44 +0200
Message-ID: <20260111082105.290734-11-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 58yte8hoj78hh5ie9iidj9e5x6uzum7h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 23FFC80007
X-Rspam-User: 
X-HE-Tag: 1768119835-739260
X-HE-Meta: U2FsdGVkX189jmBWU+Eh77GZpTUxvnAVd5/KFbRcFEDtleD5QFntycldUIpSFUslK1nP7wa+UGraRdm7OHSGxSiamm6vrq7C2zXb0jrup4fdAEb5QxQ6DWDT5vKgMSdTjcWD2yqoef0JtK4DCVWknpTbA4UHl+TEGkQBHLUUfNWRkQZK7Zl58SlgGr9ecyhW9UtGLZsz6V54sFRWOA0J8lOcqkqWQ/PFV8AvbbY7yyl8zDe+D2UX7iVA3oEvb+hgm6WRBJhxvJWBvlUPw1gXt3kiy315mtk9WQC3l4TwPL6RglXgHtdZDxCG9LNRy93exyn14+NDMAkx9M2SRD8WZnnfU1QS3smxB9LeNpt+m6MyHFP34zY8bxRI57XXzo5etuulVJs36Q+lDkzhcrFw2oRL6Yf3xopoe+/78UYNQ/5KCuAm+jd6Kc/DK5LTaBFCPSfqfxuZ3WAPmu+nXgMbgsYp9XUR7dVDKbRYDQrMwxv9CXaxlNxuMJwFoq+/76AqNNK813pcldznQ7LgT5Lyx/IwQRJ0WEEsTOi8OYOzs/9AHLG8XQW3beJ7W749x8tVScmgUGk5TIdgRgmRiUMkJOryCmskdaVwR2gCkWMHcTUVCjgM30jGbJzkHjam/Gtzuy/+9QWfRqFrgXxjtzDUYKd+bQfA5nSIWA3n8sOxdmRrXECyEJ4gzl84XPkEUhnNgQbPRpZyZlM7ZbFoYKUCylBiH5/0N4ouAuNfM4BGxeDRV/LvvnVM+yCsLEad966g6nz9Q8cGRVDwFWrlnsJCQX2ulAcZqHpgR/neH0gzo8Yj5X6jF4S8lIqb8aKuEuvjiTVBPOLY0zjbBknlJGv8rgylAh+/sJahyg2bmnJPVxL7qLlXaag+nFJ66/uOa6+t9GxevX7lFSAnxkCBulhIV6e2p8a8A1bDp+O12XkOp5G828zLKv1LT1EisDTcZgjLG7k46UL6Hz/3Wc/bHB9
 nEPqK0Po
 Ry/PT/jFA12IxNAQyxEQAxxaj+m7uQ6bSgVEHN4NEUWuL5R9KtzqHXQvILnDqO5Bz6ETkLL28ttdN8KwzXzq1MxF7CBUmPlORJqp2kJsBbZdZHw2SoJomX/FqcPLCSz4iZqj7nZhS3DdEkqRnp/td+oS+RPADjQiuzPuUFp1Mfn2LHjhBhMIeGGXjNQXR2yGNPEtSA+2arE1k52yItofunRpFlTJ+J+NV4BLPSaKopQG0bFHxIXLFAqWhUrTQUbQ5Ia85Hf3aWfr1yo67dAV9F68Jhyq8esyHLQgmYytB011NNN70tpvu2LT0lON8htK/Ok1yLIGSx2S4e/bbESX695WhUfL9NpSJCTwz
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
 arch/microblaze/mm/init.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index 31d475cdb1c5..54da60b81094 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -54,6 +54,16 @@ static void __init highmem_init(void)
 }
 #endif /* CONFIG_HIGHMEM */
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_DMA] = max_low_pfn;
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#else
+	max_zone_pfns[ZONE_DMA] = max_pfn;
+#endif
+}
+
 /*
  * paging_init() sets up the page tables - in fact we've already done this.
  */
@@ -71,13 +81,8 @@ static void __init paging_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	highmem_init();
-
-	zones_size[ZONE_DMA] = max_low_pfn;
-	zones_size[ZONE_HIGHMEM] = max_pfn;
-#else
-	zones_size[ZONE_DMA] = max_pfn;
 #endif
-
+	arch_zone_limits_init(zones_size);
 	/* We don't have holes in memory map */
 	free_area_init(zones_size);
 }
-- 
2.51.0


