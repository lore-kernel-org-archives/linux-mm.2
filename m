Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8431EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0276B00BE; Tue,  7 Jul 2026 23:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085A06B00C0; Tue,  7 Jul 2026 23:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63C86B00C1; Tue,  7 Jul 2026 23:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC5AF6B00BE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 196451C83E3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:45 +0000 (UTC)
X-FDA: 84964134570.23.28CF6BB
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6A3BD4000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R8vc2rjC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 37r9NagoKCP0oymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=37r9NagoKCP0oymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avFc8g+L1eyCm5XCDbsRZSWjyRAAOJ2Cs9ZxfGGqCu0=;
	b=bH1Hx/Ifj7TZlsRTYIzX6bgN3V9m2fsxDrlr7LunWOVv/vCERz4LDn2Y3mqcjX8un3lcW8
	0Gi4vdvMacJ4EO1d6eSLIm0nkhvWlcIjgz67FC8ixoEA3MePIeJMuudQlFIea8Q3Js0KQf
	qzdSBTvyTb1WZ5zPcesfl1AU5EcgYzU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R8vc2rjC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 37r9NagoKCP0oymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=37r9NagoKCP0oymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480303;
	b=pkp8pKYhAnCIP33b7Knp4oovvNLZCRGWnvxJfaa7qwF7P+9fZdBhjanUOuFmhc4sxPXi8v
	pCT2csvpMQYwTtGphRtjMgEVcIVQ5aVhTu2yoxNHC3VEljaSNFZHn1uL32sqe3yYM5kVzb
	kFf9yG14FURGPFZOtJRpXzHGU9zy+C0=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ccea73f81bso4132845ad.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480302; x=1784085102; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=avFc8g+L1eyCm5XCDbsRZSWjyRAAOJ2Cs9ZxfGGqCu0=;
        b=R8vc2rjC4aq/1YfhRgKwK+HDE+p6D/l+KSvcYVjs4mcfFRdshuW0sCK2hxNs+I7Ckz
         8rgAGGWwKNyxBifXL9vE+bLUgSPCK9wfG0xRuaTDsUZ5sxKaYYgxA5PE4bJc2kQpJfcP
         mhxwcQqvL8znAizceBtkHSQ0Hj8CJcN4gVpla2Zj6TJrmoNE6evpp4+Z9NfrTsZaN/N1
         HOgHf0GykOstomFAGghLX6U0yG1MLrv24f+XVmRm89mlkJhGq1SppTvnVlHU885B60Om
         24rRGeW/NNqFtsHooEw9TkTmuZGmvW/07MfKbkQH91FaXf/YgnfCkei0Nsr+ZyZWCjtt
         hTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480302; x=1784085102;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=avFc8g+L1eyCm5XCDbsRZSWjyRAAOJ2Cs9ZxfGGqCu0=;
        b=rI+Ct8ILpqGV48qgfMeHDtMvc/ifSwLOaqVYINjGGYHgSA8e6QrpT4iUkvq3vL64Tw
         euf7p2EzOO2N77+925k8phY4IWXKZFygeep40dAqErMVJFxWdGP6Me2hSrtuB0wlCsvC
         jrbEP+RyoSBZrdrrFwVjRn2JLSwhedaOftxSHfUpZW4XiKuySWkNvZzp3p+fDKrOvA9+
         dM2cZHibEJjHYfpoceHuAMZQ2aDzTZlvtblbvVqvom4FdtxaO1VSEC5p8KK7Hy0qCuM3
         btv2sM8I4ofaW8PcQSorF651sFPib+vq/u4M2ouqokd2aWshVDTlmhz497yhqMOOrstL
         b5RA==
X-Forwarded-Encrypted: i=1; AHgh+Rqo3Lnx5Joqg/G1fSqQN5ZBGMQMKX5Nz9+b9T+Yy/I/VFs29zI4JEY5UECTGYTk5Y/ZSjnzANmF6A==@kvack.org
X-Gm-Message-State: AOJu0YwCZ49tBJJckIIOGGliaWafTmnrKFMO92gudG9fJZsM17HoeDY+
	+35xHxNpV0OFq0DkrLaFo585qkW21ud8I22vjgl3L2eass4csHyKor++j9zy2MzVY6zk99gWD5j
	0MbZtP9kVsoiZPmLZM2993w==
X-Received: from plcs20.prod.google.com ([2002:a17:903:30d4:b0:2c6:a770:7a87])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:32cb:b0:2ca:53e1:b915 with SMTP id d9443c01a7336-2ccea3b6c11mr7143285ad.14.1783480302107;
 Tue, 07 Jul 2026 20:11:42 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:20 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-11-jthoughton@google.com>
Subject: [PATCH 10/18] arm64: Support hugetlb vmemmap optimization
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6A3BD4000B
X-Stat-Signature: 6daiwffby3hwhoaqkzzqrh459e3mrz81
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783480303-375630
X-HE-Meta: U2FsdGVkX18ZTwZt9F1QxSA58HBiL8AEAFnX+rmMc4aXw63LamwbAq6ZkzjJTcDEI/pvgvARf+X8ebEdv4I80434mb1qlVIIMwf9UkI35kUK5ctfv8Q9lQ+B30L5CMKvYjCY6NOHlmsEqOx6suHUsnJeFQ3xMTlnHAaCKMwLNffeOAwLzllUhdI3xPk9kC6VkIplVMGOxue3xPhjh+M6aFle+Aa4r7tKMKkiZcpBOKqfJFN13dQEtPdAEOg81GllmerCivN3t5pFmvQTelbTuzXzSSRk9kvBgeFTSdrbRqqrh9e8gdeCA8DLdvfvcvByCJDWwqWBXGus9340FT800zq7eUOOzOFne/vSflEJh3C154gcvkn0irI/UjbAxWPBZanTPtMI/FxuTTxxxnpKJY7D4MlMYgUNzDlfQOhllcmFuI0BWurdMWx5yphgkRLfQSOuWI4z3z2rQRlzoqt04wbXyAjF4tUTd7RVBG80aKGwd7jdtBNXfUXjhA2oBmjJ1gS4DCibQW/4vvyyLFK46AFUI6SXNlYPB30SJwz8ZZoJtsWWdN0/kRC9xqxnVfIwnEhPY76HK6Mxw8RiXKgBCEuB497Hdf8peeuAT02BnHCkuCSJedkqzJGqnE0TaJh/qWHLEClSELaeSkM9kamjotRB9m1yJiI6bu+1QDfddyxTV7FtMiuyAajAijbPomkQu1sUmD9unX6SGrCzX4zc2P8PZLxNsS+H0lzNSsrIo8OOWpgYnfdYvrfCdM8PdoiRgCFoSRArmwOpb99TtuewhbUGma61wWsbIkqet2qYBUa43Ed4FmnMT3Ljo6SSPBSGUceKuhTxpoomNYQqN4vmampSIHd3C0XsgIGL2rUY/XpAgFRD3zMyLxlNZGJ1gyp2hDkHWMCuc2aEzi2RWPKZeovJF+yW18/jZfu8psa3kGSu/1LSHlnvvU4oeNa1Z1kmO3iIXd+b/FbeklSjIl2
 EYIgBx+j
 c6ajRwP8jf5GgT4mmYGdhboSf/e/pqiXnrZUILiFosHjm+FqWZOtmk205HVuQdXmC5lrIjiyePeiYyqvY22hLhb8ySCXe2chDtT2NHXCBev35/z2I7kqtCDbOFr4+QzS7+Hswe4GV54+nc0J5OkoyGpYB/PkVXOTQ5xlTq/4W/myDJuhCHzN7fNOzS57QFO7ca/OJffqcY01fn5FwgQOFKre4Ir9J4H+VSoMNPOYDSzMDK3QTynCqK5gPU46JFsUcXIGUPzOs5t0ou508wIwPBLvqCmHHQoP/q4CCHX0bFOTp7R63DD5GqCZe8MyDoK0tm6aBXNgwoYOOI6V3LuhSj+yeszSAUCYFilVU2rTrVHHUlUuye7NcBcysogUeOHai5gG45WcdUrJD9JNBxawPNcct5COyp6HGgz4n5I0SLBj5V+hmN8A1FeKAUoQe6T8NNbd25AY1epsAyjjl6Af5ItZFVHAxPHYaRN1dPezi958TStd2ps26cWyjxbte9tbRENSUBbcPMp5y09akMpCDFMJinIkbeiRmRNTTPdRi0kmUYM9jNtXkJOFl+kB1ecXY8jFFd9L1MF7J7uOpSoAqMjNQk7+5OgHAQVEQaL9WtQaEc4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that HVO is architecturally sound for arm64, enable support. Add a
new Kconfig for this support, as it comes with a regression, described
below.

Add a comment about BBML2_NOABORT where HVO is relying on it.

If a late-onlined CPU does not support HVO (HW AF and BBML2_NOABORT)
while all boot CPUs do support HVO, the late CPU won't be onlined after
this commit when a kernel is compiled with
HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/Kconfig   | 12 ++++++++++++
 mm/hugetlb_vmemmap.c |  4 ++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..cf4bd6bd7f11 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -259,6 +259,7 @@ config ARM64
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select VMAP_STACK
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -1607,6 +1608,17 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
 
+config ARM64_WANT_OPTIMIZE_HUGETLB_VMEMMAP
+	bool "Enable support for HugeTLB Vmemmap Optimization (HVO)"
+	default n
+	depends on HUGETLB_PAGE && SPARSEMEM_VMEMMAP && ARM64_HW_AFDBM
+	help
+	  Enable support for HVO. When enabled, late-onlining of CPUs that do
+	  not support features required by HVO will not be onlined if all boot
+	  CPUs do have such support.
+
+	  If unsure, say N
+
 config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 21377f795293..977249e22ed0 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -86,6 +86,10 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
+		/*
+		 * On arm64, this requires BBML2_NOABORT. Its support has
+		 * already been checked.
+		 */
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
 		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
-- 
2.55.0.795.g602f6c329a-goog


