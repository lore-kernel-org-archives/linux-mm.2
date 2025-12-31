Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4BDEE6429
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 10:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7FE6B0088; Wed, 31 Dec 2025 05:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A64A6B0089; Wed, 31 Dec 2025 05:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1DB6B008A; Wed, 31 Dec 2025 05:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 731BC6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 05:57:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D40B31609F6
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:57:09 +0000 (UTC)
X-FDA: 84279464178.23.AF34B4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D33540006
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:57:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kn8DAoue;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767178628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q7mAJA/uizHiRyT1NRXXi4nDKUV3moR/EtSIypc37NI=;
	b=X40iBWvTVdfKrhuImzbcA4s9Gr9jWuMqOMG4OWglz1DkFnsOGHOmQI4hC8gUHD3arzTkBY
	E0otQ3LTyDk6GvOhwx4qMZj1tvH3iN8CLrVAKYn0X+tEJ3O5zyfvDhbyDFk8CAU5ABW/rz
	r6LUDHB1G/lUl9rGQ1OGAg6o6j3lQAU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kn8DAoue;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767178628; a=rsa-sha256;
	cv=none;
	b=rW2+9Zel9hxRBtInPxjxaBmEsMIrFc+DsXhJCMRDvbr7y3KrbZGdM+oV5WLgjVJBfZm9hb
	0OTK+0WHMshxWTo1ZkSHPzWSvWLVQUN10wFQiiWGZOYx5P4R+Wp2zxkriQyuj9lr1ZKW3N
	zn3GlBlYTtSF57oiJ3wo28094POttPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7C5860008;
	Wed, 31 Dec 2025 10:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF07C113D0;
	Wed, 31 Dec 2025 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767178627;
	bh=Md5yS/VxEgsDtseFUiUdjBGwg71pDr/MrKSVCAcacM4=;
	h=From:To:Cc:Subject:Date:From;
	b=kn8DAouex1gbnLOc/2JeogKfAy+YJMlixd9i4X0NdW1V1EKL9tsFSSbVBkp6r6ytS
	 XLYk9J0tVZ6HXH3qdy/V/gm7NDXgehDYZwTBFKwDKuDNwxh/EfePwil12YVbH+itN0
	 Li5neF9ODRvdhDmMmhkHO06LEWd8/d+n6knh7g1f6Zuivd4uD7TM+MWyzriCKMuAF8
	 sMK5MECbz3RfpruLY9l902Kf6ne8FzdrG47/s5gDeZTgEd0aV9leLEJOHZf8lb/RR7
	 O+UBGfY0pAoM1IKj2T3htNvgK+yMhA2X6oqleYSh3JPVIjCStO9zJY6G/kh30q34Ms
	 6SYZazAr5ZTRw==
From: Mike Rapoport <rppt@kernel.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
	Mike Rapoport <rppt@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	hauke@hauke-m.de,
	jelonek.jonas@gmail.com,
	markus.stockhausen@gmx.de,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mips: fix HIGHMEM initialization
Date: Wed, 31 Dec 2025 12:57:01 +0200
Message-ID: <20251231105701.519711-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: csroxjh87acntaqgsh5it1hsoijy31b7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D33540006
X-HE-Tag: 1767178628-391124
X-HE-Meta: U2FsdGVkX1+F49Nnb3AclnTdae6F6LeQdXPNpRRqdlGmB0sgy1NnDFk7PMFerZiuX7x0qTb4+hdrzzyhhMasBbqZAMButlTIt/isFB3JpmnB5p3RqybWZjmCQvIAQZ7J6mns1OfyqKTmFqbg1Rey18pjFey4qb73lj0ej39V1r08cX16V33Z6Kd0fZK+kXPM8CRiJ8OA6e1CG5OoFBJWXQ0P6UXhbhxNuk8/QImVKHZWeEmCKYKUFZjxj2h9jy1VH4RLGPsPs+hdaujFbZQdnVbVkaF2uski8+QaZv4frSx37xzufE75u1rV6AGjzjR+2UYPBKsajDxJXw/1v3EQvadOPYOV8A5NBFefv5g37skTE875AACkNrF2RGvqgNeM+J+zAi54yqO+noSNYAoLVIs6bAYJSA2Q2jHzXI0ApsIgybmISgdTOvxqlyU9XLRWeZG6Gbt/z3fQxHPAdjGdZyYzs9ZZooG+c34cG0QfBxtF6jHTnvGVajuKn1aT3e5o3nHPXOEqOVsQOtF4OCgXvd98qg3zQ7a7YshLIf2cKEBEpqJLcMoTKozdLD1FWRgnFcx8TKAlAWP43MVZbIphYUi7E97cthzm6E3G3OLQHb25MxvPF0OOKIq090cmoz9OYQAvs/G4yq9NP5KMmOFijOhgqj19u5kgxCPDZOe5jsm1rmCQaBlAfQscI6PTc9A8kOexCscUG7hTQFlbtlyA62K5XqdWXGaRBXUonLqUZBWWlVK22fPcaZ6NNqpd26N3AU8IqYawMvh+ddsMN9Ji+VfIoUktthWnIS3rrpBAI0GdPtv2KBtL2WcSPrQCAOH3bngPSFcSH69KKEWBEPLiuUUUaNYMB70pVQuXWan6WSKbneRbqMn5ylXO1mB3m0gNcvaiRzmlN/5ADXaENI58SkivVwrjCLnOqTNRX7YvPEc1iX62/cge4o1LaseBc/DEHF+5sj9Suc9ZKvo+4oo
 64co3MON
 vGiS8jPjk19zG0mdD+ZtL67zMNbv3wsP6Q5lS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Commit 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") overzealously
removed mem_init_free_highmem() function that beside freeing high memory
pages checked for CPU support for high memory as a prerequisite.

Partially restore mem_init_free_highmem() with a new highmem_init() name
and make it discard high memory in case there is no CPU support for it.

Reported-by: markus.stockhausen@gmx.de
Fixes: 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/mips/mm/init.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index a673d3d68254..8986048f9b11 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -425,6 +425,28 @@ void __init paging_init(void)
 static struct kcore_list kcore_kseg0;
 #endif
 
+static inline void __init highmem_init(void)
+{
+#ifdef CONFIG_HIGHMEM
+	unsigned long tmp;
+
+	/*
+	 * If CPU cannot support HIGHMEM discard the memory above highstart_pfn
+	 */
+	if (cpu_has_dc_aliases) {
+		memblock_remove(PFN_PHYS(highstart_pfn), -1);
+		return;
+	}
+
+	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
+		struct page *page = pfn_to_page(tmp);
+
+		if (!memblock_is_memory(PFN_PHYS(tmp)))
+			SetPageReserved(page);
+	}
+#endif
+}
+
 void __init arch_mm_preinit(void)
 {
 	/*
@@ -435,6 +457,7 @@ void __init arch_mm_preinit(void)
 
 	maar_init();
 	setup_zero_pages();	/* Setup zeroed pages.  */
+	highmem_init();
 
 #ifdef CONFIG_64BIT
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
-- 
2.51.0


