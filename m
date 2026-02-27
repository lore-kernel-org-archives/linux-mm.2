Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717C8FEFB72
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3316B00C3; Fri, 27 Feb 2026 12:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3BF6B00C5; Fri, 27 Feb 2026 12:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C086F6B00C6; Fri, 27 Feb 2026 12:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA5626B00C3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73A351B7B0E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:38 +0000 (UTC)
X-FDA: 84490994196.18.88D2C03
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id DEE731C0011
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EuTJwogsRPxq98iUSbWob8jNy/WUZB+Z5Sl2GVPFxdw=;
	b=1Qbc38WwG6fe9FUI+lpA0/ZyrAZqQ+ZaLivZmbOPhE99fGHNmtmKrZTTuqV2q86uc7tvm9
	nYyWvNGX9Dnz9HVEkU27PGjynzlHItEsYc3Ld46pYWb0Usf5yNoBviGRz4DYSPxsb4WIMR
	uKMPf1hAU9tb2g6hATCg3QgjTO3qPJE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215057; a=rsa-sha256;
	cv=none;
	b=bMYxYqhRM9mD/LjvyUs/koUn6GxoqPSaug535KeoRkuIFC0YsVoz0PBU6v/fUCN4TyjP9Z
	Urr4G0h4Tzz9DpPDvE5WdUoBDFcV3ugQ2LVip8/4Ijmn833tVKb54JA+hcUm8Zjn3Dj5JR
	ZqB5jnWlj3mZ4TN0wz0lQHpPxuftr8c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE7E41516;
	Fri, 27 Feb 2026 09:57:29 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8C363F73B;
	Fri, 27 Feb 2026 09:57:31 -0800 (PST)
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
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 24/30] arm64: kpkeys: Handle splitting of linear map
Date: Fri, 27 Feb 2026 17:55:12 +0000
Message-ID: <20260227175518.3728055-25-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DEE731C0011
X-Stat-Signature: pzon76psq17seji1spxej85gb3nxbhzb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772215056-780856
X-HE-Meta: U2FsdGVkX19lsN8WF+24TTYhoehchioF5B57rOhoevAX03mB8dp5c5ruPIzt6wvPLNrXMsYdfQDs0e/QrQ2uCkuUn23YkoKAqqADhjYZgswhFJo6oTkLx59l9iN+hkhWt6POeCEJIh7jNbe+35zmoh5iL5NMNuyrVH/S9z4dcC6E1Cevdvi1149ClGacWRskGFa9b0Bizq1fx03evc7MK3iFu+MlQsKEHyDBROXyH05GvthfaV8RmCUyqj7Rws7LSZKkaksHszvEUca0AdWcwpHWV3WaPD8bW2F3JnQt1bgHibetyZQ0pV5AobHC08x/xWWSNh49yENdPbUMLtoCnmvefDu4+W3Up0KkLKHuCyXbgf92ufX0mpl1ABVEAYJ4vwjIgtEnHiP1G3bNgehLoKKmKo6VQEIheK6SWdLFvU/7IgU+c2Bw1PymWPyd0GWqL6AcMoXBSTrMHI6S9+Et83i8EghJKXcOI8PsHvq23j0n1SLd9N7nJUp09aKm4ixc0B7PK5AxUNFT3td+WwhynYPd64zJpRwQldGKF63S1f4Z3N7hMMze4jmQyB5s7BjpNsPd0ShXjFPmYzUp2PQopXrcODFqXgJBPEs59oeCVXEZ5Ui0Q+tuQlSCjMbHWCTPU+cLWET4jHPCIwtDTCG4mO/darneg3DEGxIKZMxs/crv853/gmOcB2N//b4PR9FNvrutqHdekPHCFiwWUhVSRteZTgY0s2xpWKB9Q385A4efWHekZC0ccrE48G2kpksdmutmL86FRTvS7D1Iw+OoknobtguM0jDoJFBGNivD/JVaM5vCG5qMG+bRTx8uMLhIAAqxP2Br2E1k52/kytPLHlnu+TqqYJPk+tWDzIztoztlTa2koa5CRblWbwyrRmy+kDcid/TNFxcXCvTiWGLnRTtlkqVF0K97ELL8JVSlHp7Ikf2O8VC1XLjeShmK1fRSvufOsT+BL/Et+zyuF4e
 Rocx11wI
 8sF0mr9ADCUJPgquF8FrZ0raJIdRAJlA9HjFMSMNwNyVOHJWAwnPTSq5KhM+BFl9DUjNqKWbnKah3r5XhxsbUg1ZMPotRWJzhr0l3D4729HBpBLUy2hRVGzYjRyyZI87AbRW7BsRbhXUbQ/xnx77qaznP+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the kpkeys_hardened_pgtables feature is enabled, special care
is required when allocating page table pages while splitting the
linear map.

Indicate that such pages are being allocated by passing
__GFP_PGTABLE_SPLIT and use the appropriate interface to prepare the
kpkeys_hardened_pgtables allocator in
split_kernel_leaf_mapping().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index ea1cb1875257..2cee0b7f8a56 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -707,7 +707,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 	if (!pud_present(pud))
 		goto out;
 	if (pud_leaf(pud)) {
-		ret = split_pud(pudp, pud, GFP_PGTABLE_KERNEL, true);
+		ret = split_pud(pudp, pud, GFP_PGTABLE_KERNEL | __GFP_PGTABLE_SPLIT, true);
 		if (ret)
 			goto out;
 	}
@@ -732,7 +732,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 		 */
 		if (ALIGN_DOWN(addr, PMD_SIZE) == addr)
 			goto out;
-		ret = split_pmd(pmdp, pmd, GFP_PGTABLE_KERNEL, true);
+		ret = split_pmd(pmdp, pmd, GFP_PGTABLE_KERNEL | __GFP_PGTABLE_SPLIT, true);
 		if (ret)
 			goto out;
 	}
@@ -800,7 +800,18 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
 	if (start != PAGE_ALIGN(start) || end != PAGE_ALIGN(end))
 		return -EINVAL;
 
+kpkeys_retry:
+	ret = kpkeys_prepare_direct_map_split();
+	if (ret)
+		return ret;
+
 	mutex_lock(&pgtable_split_lock);
+
+	if (!kpkeys_ready_for_direct_map_split()) {
+		mutex_unlock(&pgtable_split_lock);
+		goto kpkeys_retry;
+	}
+
 	lazy_mmu_mode_enable();
 
 	/*
-- 
2.51.2


