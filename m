Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAF1CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7B36B00B4; Fri, 15 Aug 2025 04:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD376B00BE; Fri, 15 Aug 2025 04:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FED8E0002; Fri, 15 Aug 2025 04:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30CAF6B00B4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3557BC003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:31 +0000 (UTC)
X-FDA: 83778385782.24.1BBBC39
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 684F14000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248190; a=rsa-sha256;
	cv=none;
	b=7YQf7DYlI3xr8B9Rv0Vzuxl8JsqU3q7hnIKylcKEO+qiesZvcfonpBFUxpAFZg6NCA0aqU
	niZOQHiJ5TchYKlzE5Ojaw1Hb72qWIDd/CmtF1slw0CbOUcdEzzipvCwgHPPM59ag4bfDd
	BsyAYDJ30h1x9bxNaOTuMhaUZUA9E88=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jH6upNyi8b3O4Ypl4uBmnNawWvdJaZoKkwJtIcfQLw8=;
	b=fc2kpJdut+f4X2JAp9XqpkOaVsxZYmwzQHlGGWxu895+nnqXchP43kVmXrwnARMKSl71ka
	YN8CcL++FFj1/HPZ3LPDBOZeQM5xdBmNMfu8rEmXxMu6Ial2lN5fHnS6tBu9CX1TxnT2xE
	uyxgYsO6p5xJpd6wDcmBbidxELAcT1k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72FCD1688;
	Fri, 15 Aug 2025 01:56:21 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 053E83F63F;
	Fri, 15 Aug 2025 01:56:24 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 13/18] mm: Map page tables with privileged pkey
Date: Fri, 15 Aug 2025 09:55:07 +0100
Message-ID: <20250815085512.2182322-14-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 684F14000D
X-Stat-Signature: dsiw978e3upkzkkit1hwjz4sk4kt75sm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755248190-654831
X-HE-Meta: U2FsdGVkX18ysEfbbn6iuSUh8O1NyF0G4dR+0ArYBQoHZSrbW7YihErRrM3bRffzRXEGmrkS5CIFlpIvHV5o1Mam7HmY/w5DOrwQHMymdo1rdPfj+af/loFMLXap51EPKtF+qX1WADY9zxwvugviajSdnfwHf9h5ADVlgLMcK2KaQ6+7ewb9/GIvM8FAovGe1ysoE06iuCzG8lyHQASChCf4/PSPig0UVDtiAAqT9w1T69w2eIaeu0O6wDQAzqDTpY6msqT/uT4uwgD8h/WHcHemFgKoSit/gMEEJrDBSx6hQFjTfbH02lcYkeRkDumDM0PBdZ1p5JfOi8vcQ04NIZIJFo1qnXaS6eN5QEYwsKWOgMzL5IZxF04g+VoiSCa3ahefjFojoJpZ4Bh/Elfi2Fo20JZEfY3iHNlPN0Z2B9/vasA0s+/mwjbvoBhjs7+f8Uy4GerdP3Ys7vwEaC0bm2GrOk5yRKvemGQj7L5o7kostFYzuC9gjjiE4UfsDaLrD/kzILUN1zvuyNGjoB6q8T8hwGabsD3NDk4RzKx3C5En3FmHKdcwEaiUseIQEPv15+op8CfkjY9WufoNTG6vabJ24mQa9g5poLud4FjlwgiSO3lW+gOZAzTt0HjgI6nfBCEzm15K8WHQubEpoWoHo2/1G4+AU0LprZSbKJ5uhPVGENDkqmRCSDpecI7YmC4T2R4fBHo2bQ6LgwAfDZJVPtNW5DH1NS6RiLqYPtejOhKUo3QF53WW3lAXNTZoNAzICaN+1vVIIS/tPKWktCSGioD7hdvOIydX3bZ2R3eAvgdSD5A6A5MD3eABfctdPBbb6hr6hmmpmcsGpY3fse9h2q/TbBoBMfHV49cBGiT97U04hdeTYSnZDWh0IiWL/VEzkqxz4mn9h6yBRYlX4fKY7HAqgjLFASqZDVgzTqdcHt0MbW8ZJbWVRWmXQiDAJ9Ct9+kG3e2RVNWHSQILcoO
 9Dxtb6CN
 hOqs44eHXPfrzNUuS+HX6ZXElEgeXG+DdUtwnXvmNQ05jm1MD6OPhweGoA0pTe4ys1NOOG8HL4gUNh+RWAg8m+PApisgiMcGO/yFjlAY1YtDUuALWfMRVIfg+GCX5D8Z2f8/haJgbD8M3JHIfdlFDS1ECmBfFsS/rQOatgmRcrjx1VOoVS5/SsqxSK6bEAkTF8jHMotw2CrK2+1BxeezjpdHDBgyD3JxJ+9iL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If CONFIG_KPKEYS_HARDENED_PGTABLES is enabled, map allocated page
table pages using a privileged pkey (KPKEYS_PKEY_PGTABLES), so that
page tables can only be written under guard(kpkeys_hardened_pgtables).

This patch is a no-op if CONFIG_KPKEYS_HARDENED_PGTABLES is disabled
(default).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d9371d992033..4880cb7a4cb9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/cacheinfo.h>
 #include <linux/rcuwait.h>
+#include <linux/kpkeys.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -2979,6 +2980,8 @@ static inline bool __pagetable_ctor(struct ptdesc *ptdesc)
 
 	__folio_set_pgtable(folio);
 	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	if (kpkeys_protect_pgtable_memory(folio))
+		return false;
 	return true;
 }
 
@@ -2989,6 +2992,7 @@ static inline void pagetable_dtor(struct ptdesc *ptdesc)
 	ptlock_free(ptdesc);
 	__folio_clear_pgtable(folio);
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
+	kpkeys_unprotect_pgtable_memory(folio);
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
-- 
2.47.0


