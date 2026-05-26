Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB7A2CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C776B00C8; Tue, 26 May 2026 09:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E2D6B00C9; Tue, 26 May 2026 09:05:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093916B00CB; Tue, 26 May 2026 09:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E71BC6B00C8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFEE51C02E6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:39 +0000 (UTC)
X-FDA: 84809592798.19.2B06AB2
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf12.hostedemail.com (Postfix) with ESMTP id 955C640002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="s p5MOaO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="YPurNl/x";
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9w4pHLlPPvdjComZDz50X3r+NiKo5s+M3QizcwB9Fmk=;
	b=ZlnpkI+9gh/RQ4t6wn4nQaigTHM8BJBKlD2U1hcMqwW2ebtMRx/N9Fd2rKH80BUI7tgQor
	Nv7tNZzVrjrGVs05/MrejmWZ29fR8UWfW7YIuwJX81UjTO2Eab268DsNLjpFeeh90PaqbD
	5l/UtG+FEXR3Lm6IESgCoxsgNGrErKE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="s p5MOaO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="YPurNl/x";
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800737; a=rsa-sha256;
	cv=none;
	b=nrwScv3eGMjYIPwSRCUZT6rntwvWc1ByG7xtWbbCEtoqXp8p86ZgSD+OfSv6n9Eje7EPwP
	UrTaw3fjZU579YTHUtcf+QkZG6P3q1PPN1Zs1JKWaF9JDPGDfqnhR/kvx3a7nCzl5f57vd
	ssyC99AsPjUmcwIUz5Tm68a5I8fTmfU=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 44C031D00138;
	Tue, 26 May 2026 09:05:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 26 May 2026 09:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800736; x=
	1779887136; bh=9w4pHLlPPvdjComZDz50X3r+NiKo5s+M3QizcwB9Fmk=; b=s
	p5MOaOlt2z7RlsxhdTm5k1xZ1XE2x1DpeirJ6+ycIV5u+vJZdpWUggwBTcQxDLt5
	qGSARuQsRVNxwgwrooUxNU+S9U/CLN5X553k6r9XPkWi+4bdqc13bEwDQMQqq4+T
	sUEW0MNKCMdT5ZmKLh5MqH3eoV0f4xPaDOb87LyELRl0/BbFebmwXbRRz80FVKwf
	2c/UM4FBG77Y9ajjuHcPvYgM0W2I1K/3eqixcvkERbwh+RfgJ4/vd6tfBSSausuB
	3AktF1t2L3RvinykPI/7327TYBXPaJfIoZ02hjjN+z0b9FkOqlqxJSOEYjfdqnhv
	GG1mWxpzZM3zVZXu+9Qvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800736; x=1779887136; bh=9
	w4pHLlPPvdjComZDz50X3r+NiKo5s+M3QizcwB9Fmk=; b=YPurNl/xKBgzKknNF
	GW5C/LdRYaMEFb/bYf4ZQ6SpaLkfhR0XjM2H8O4PO1KhErrdhgL/VY9I5pQx9FAa
	d6kUVgpMMJXL/64n9JEMEEt+X3poVFoEsevLLpYRNK8J7GUuYV1x4zJ2nAIWs8zL
	EzvAh9kE33QyOUdEDHrxSYXSmwLr3zrPkg9l4qOckV937OT7OnZJFRUHiXpufCsb
	eC8g43NMzcKIORg3T2ESotTdGib66bWuZQHocHhrNyV0IDwGlpcZMXl6H0nc31ch
	yNQWduLtkl6m31mjtx0ykQ1EA2h5q9j8O57VNlpY9CibOpaMt4XLyTWIgD1/aXDf
	+PVhA==
X-ME-Sender: <xms:n5oVanMA6rTYqOsZFsytFXTBv2oxa_yyDOjeu5c_4ktsGIIfh4TlTA>
    <xme:n5oVal7KNzaMuL2n3pjzw0kFg_1MGJ7vZDx7k2lb6WJQmknLNpmFHNoQYCrX2nlI1
    1TX18ArYtLuR1y1smdIe-cf4QDlI1EI11eO9BKZ_PU_icADa2hjLZU>
X-ME-Received: <xmr:n5oVauzd9pBoj3uC9ocG52_9wKkhBBVAuaYswVlz3q8ZkBQwregjWm_rvAN91w>
X-ME-Proxy-Cause: dmFkZTFqbc6fXhopwy+hAOgtjHy4pTGuHjfXZXlZdTx/k4tQMvhyI2vZzCnM5UZQOJLsQ6
    MBNN4KMbmYZdvz5T8cIgQbo11hylcsT72WGhRELqB/NWcVS6dsw2DuAcdzpihvUx/kC7Rx
    TXAh0tKkGSNzPC9MzCVari3WizUMLAhLPeZR8i+UtrjD8sUs4gbS3nJjyE6j7x9rQvwYKa
    Vo1Cdu33hYc8iqP/ATtq14j2/nP5x/Vq5r72hY07O9WQkAcMkY7hJXfuznzppNnRfPI/E0
    vXoMBAS+e5kQ5+gg0Sxc802FUu+VDDuhW3vvNg1v2vn17b0MDhDS2LwVSA9QGKzjnWPAO7
    fY0pUEUHHBT+q70bS3A+kmuFZddzhgabnLrzvvviD9/c31ZWTL80kWnAw9TjDwAkzTP0hC
    7TIi8JPWN6uZUTifKnmyA3DYt7pO0LfMTUUHuac2Or0tKSkMfiBlSzfO+dNxBAShrxzGfc
    gvrSfpuLLT8Fu45xhnqk8Qpb4OLIOUiY3pb+DmyXD+zBHa9Ie4Nj0VLIZfy7mcBN+3u8BY
    3pcaEPUdIA2Dlc+pL5DSAPKwOVXD6I1nlzIUTylTj4gVDpsES3MoIW+cGxOhHQIbYVXnZy
    3u/T/HKHMbz9qD0N4pytj96SOKndAMRcUaUSsk0/YlmfkKZIQM8MeFH/l0pg
X-ME-Proxy: <xmx:oJoValSW6jPEQGWdqUEHm5JcnIrCnGrcPgFaqSCSrJ0njKqgWXIW0A>
    <xmx:oJoVam_MKRocAJimR-quyJa0pxZJnk3OU4QVZjdAG6n4iu2CMKM6Ag>
    <xmx:oJoVaiLXFGlZhifQmG_ezJZNqWKM31nFQaDh5tSf_xmfkjRAunszBg>
    <xmx:oJoVaqtLcZZrTOwDdjfRaWYlswFP--gMShp9LfMAa-PvuQqNcIiVEg>
    <xmx:oJoVasKuX4YLr_w58hlx3H0tiNPrkabfdnCIwuazQuThyv8DHi8bnTht>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:35 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 07/18] mm: rename uffd-wp PTE accessors to uffd
Date: Tue, 26 May 2026 14:04:55 +0100
Message-ID: <20260526130509.2748441-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1j97fgjhans7ju91qz1nj7njbc4xxdyr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 955C640002
X-HE-Tag: 1779800737-30918
X-HE-Meta: U2FsdGVkX19urnBeyTgs9Pn5AFxodcJCEoiwoSywd6CSJ/Lzj82oynKbIG60UKGgMRTN9upy+6+37d0GnENQATQqjberT+KMESxGtHnTxfzmPdRJhdpgQL518WpGZ2nxaZmQEA3PQSLV7M5icdY+MVlMKUQwJ1BlwmYG4K7a2YhzNoDHD08fM0zTL1PiYDr62fFdPNGv30GXcqZIvg+kz7t1FcF+kOCMO5E2daZ4pBZbjaUz7CoxBTLYcWAT3d5hySierK4t1NQIkzClVDC9Ok48DNq3+/ho+ArpHP7qs7HLSErfK7NkVCCP5lNsILairhshoADfupHiB7ZcXchvf0tD1MEpqJbPca7uJ+XuFZ2TZAlsIpfyLjMF7Q2zD4uK0XduV/E2F1fJilEZrmhZqW0WpRx/rfwN9HsRveQ18gUIz+8f27G2+lTPA5Ls9hsZdn3uWxSvjmpqOz5qsJErH9TPnDletLis8ilbCwANeD+IWEtNfC7/FJgo2j9aa0zFRaBzz4m3+kzhsOqlrYdpt6ava5yENLSKqVksq3tzb47aCy/+8tJgyO7W1l32/bdLcU1UZRndcU85lLir6WEY42JxF2YAfbDTqflvv1Ygdb8FqByCSQ36AzrRgJ06U4yLERWggZSxgiNPXnonhj/hw2WUQeXmHjDTPhZd+AyILaJEyZlx8o7+HiCCHphp3c6YZmlCu8AIogXWIL7G/A/NUj4XzWMpqRQ7sisg9HK5COUe/5RqhhlPcHj2gMdJ7XfTqJfpek5ThQFygy6Reg7FEsLgWdAIcsfPrj6rWw6eErje1Ngdg3ISOtb/hWiRl+Gsqn9RBW7xHeorm5HIe/WfI1UgOO50i0A/zm2uepl4cioPrm2A02vMSvtipoLw880Pfk47Op0ebPlI69yOpxtB1HUCvXeiZXqS+Z7qTBki0VB988quK94VZRq1T48/+mF9OveIj/FhMLciYsezTS/
 MUGwY7rI
 Y15Ieuz5uRBALzl2aN5ERoSICo881V+cHoH4bGEQrkK1WCxR8NyQFLj7fD3R6SmD93UA+z+2TmaB+9vp4BAJSjfCFhNiCK/WwACP97ZHto3Kt7W6NoWMV/geaaeCo+qisY1hsFEuv8yEKT775oBT6VjnjbekmiAf1UPoHgNWJMCW2Gnhqy8bnLk3xGMV7ISDhpIpQ+1QpT5VUDelmMioFuwi8x547nXmBf/b+OI/DSj9sYPpWM/61KoxL343kmLbjM3G+OoFbaxXmbP5PfaFW9UowvxlYhumNIM+BNgprqYkeeA+ruRcmLSCxeNDiljBJyFfWkQzqXp76yw6TlFRaWqYZ1q9oeEqlXfEAr1wEBYmdMCsI7KoKqfu1KXzR/BR16Z0It8ZdY2nBHW17NxUvi/IO2AhFx4Nvd8I80ZkE/HAMrLrHMCXWEOp8moCeJCZBplkHVd91QlifGtUyaXqz+SVP7XUno0AchVdbGlKMV/zOoQGlzWwqDP4MRrJLcJ3rYJ58EkAL4muqDZPmj1XcaFIfrMATY+7OoaWA/mVXXAPMnpD2QHmA6zwp48rVQp8qgTDPGqEVmtgPPH7xKpaMdI1CI+TUV6AcS/e8WLloxGRYHvNK7NxcAWCI8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Userfaultfd RWP will reuse the uffd-wp PTE bit to mark access-tracking
PTEs, alongside the write-protected ones it already marks. The bit's
meaning now depends on the VMA flag (WP or RWP), not on its name.

Rename the kernel-internal names that describe the bit:

  - pte/pmd/huge_pte accessors (and swap variants)
  - pgtable_supports_uffd() capability query
  - SCAN_PTE_UFFD khugepaged enum

The ftrace string emitted by mm_khugepaged_scan_pmd for this enum is
kept as "pte_uffd_wp" so existing trace-based tooling keeps matching.

Pure mechanical rename -- no behavior change.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 arch/arm64/include/asm/pgtable.h   | 28 +++++++--------
 arch/riscv/include/asm/pgtable.h   | 38 ++++++++++----------
 arch/s390/include/asm/hugetlb.h    | 12 +++----
 arch/x86/include/asm/pgtable.h     | 24 ++++++-------
 fs/proc/task_mmu.c                 | 44 +++++++++++------------
 include/asm-generic/hugetlb.h      | 18 +++++-----
 include/asm-generic/pgtable_uffd.h | 32 ++++++++---------
 include/linux/leafops.h            |  4 +--
 include/linux/mm_inline.h          |  4 +--
 include/linux/swapops.h            |  4 +--
 include/linux/userfaultfd_k.h      | 14 ++++----
 include/trace/events/huge_memory.h |  2 +-
 mm/huge_memory.c                   | 56 +++++++++++++++---------------
 mm/hugetlb.c                       | 46 ++++++++++++------------
 mm/internal.h                      |  4 +--
 mm/khugepaged.c                    | 22 ++++++------
 mm/memory.c                        | 34 +++++++++---------
 mm/migrate.c                       | 12 +++----
 mm/migrate_device.c                |  8 ++---
 mm/mprotect.c                      | 12 +++----
 mm/mremap.c                        |  4 +--
 mm/page_table_check.c              |  8 ++---
 mm/rmap.c                          | 16 ++++-----
 mm/swapfile.c                      |  4 +--
 mm/userfaultfd.c                   |  6 ++--
 25 files changed, 228 insertions(+), 228 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 3eecb2c17711..c41e4d59dc9f 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -341,17 +341,17 @@ static inline pmd_t pmd_mknoncont(pmd_t pmd)
 }
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-static inline int pte_uffd_wp(pte_t pte)
+static inline int pte_uffd(pte_t pte)
 {
 	return !!(pte_val(pte) & PTE_UFFD);
 }
 
-static inline pte_t pte_mkuffd_wp(pte_t pte)
+static inline pte_t pte_mkuffd(pte_t pte)
 {
 	return pte_wrprotect(set_pte_bit(pte, __pgprot(PTE_UFFD)));
 }
 
-static inline pte_t pte_clear_uffd_wp(pte_t pte)
+static inline pte_t pte_clear_uffd(pte_t pte)
 {
 	return clear_pte_bit(pte, __pgprot(PTE_UFFD));
 }
@@ -537,17 +537,17 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 }
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
+static inline pte_t pte_swp_mkuffd(pte_t pte)
 {
 	return set_pte_bit(pte, __pgprot(PTE_SWP_UFFD));
 }
 
-static inline int pte_swp_uffd_wp(pte_t pte)
+static inline int pte_swp_uffd(pte_t pte)
 {
 	return !!(pte_val(pte) & PTE_SWP_UFFD);
 }
 
-static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
+static inline pte_t pte_swp_clear_uffd(pte_t pte)
 {
 	return clear_pte_bit(pte, __pgprot(PTE_SWP_UFFD));
 }
@@ -590,13 +590,13 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pmd_mkvalid_k(pmd)	pte_pmd(pte_mkvalid_k(pmd_pte(pmd)))
 #define pmd_mkinvalid(pmd)	pte_pmd(pte_mkinvalid(pmd_pte(pmd)))
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-#define pmd_uffd_wp(pmd)	pte_uffd_wp(pmd_pte(pmd))
-#define pmd_mkuffd_wp(pmd)	pte_pmd(pte_mkuffd_wp(pmd_pte(pmd)))
-#define pmd_clear_uffd_wp(pmd)	pte_pmd(pte_clear_uffd_wp(pmd_pte(pmd)))
-#define pmd_swp_uffd_wp(pmd)	pte_swp_uffd_wp(pmd_pte(pmd))
-#define pmd_swp_mkuffd_wp(pmd)	pte_pmd(pte_swp_mkuffd_wp(pmd_pte(pmd)))
-#define pmd_swp_clear_uffd_wp(pmd) \
-				pte_pmd(pte_swp_clear_uffd_wp(pmd_pte(pmd)))
+#define pmd_uffd(pmd)	pte_uffd(pmd_pte(pmd))
+#define pmd_mkuffd(pmd)	pte_pmd(pte_mkuffd(pmd_pte(pmd)))
+#define pmd_clear_uffd(pmd)	pte_pmd(pte_clear_uffd(pmd_pte(pmd)))
+#define pmd_swp_uffd(pmd)	pte_swp_uffd(pmd_pte(pmd))
+#define pmd_swp_mkuffd(pmd)	pte_pmd(pte_swp_mkuffd(pmd_pte(pmd)))
+#define pmd_swp_clear_uffd(pmd) \
+				pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)))
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
@@ -1512,7 +1512,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
  * Encode and decode a swap entry:
  *	bits 0-1:	present (must be zero)
  *	bits 2:		remember PG_anon_exclusive
- *	bit  3:		remember uffd-wp state
+ *	bit  3:		remember uffd state
  *	bits 6-10:	swap type
  *	bit  11:	PTE_PRESENT_INVALID (must be zero)
  *	bits 12-61:	swap offset
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index ca69948b3ed8..b111e134795e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -400,35 +400,35 @@ static inline pte_t pte_wrprotect(pte_t pte)
 }
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-#define pgtable_supports_uffd_wp()	\
+#define pgtable_supports_uffd()	\
 	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)
 
-static inline bool pte_uffd_wp(pte_t pte)
+static inline bool pte_uffd(pte_t pte)
 {
 	return !!(pte_val(pte) & _PAGE_UFFD);
 }
 
-static inline pte_t pte_mkuffd_wp(pte_t pte)
+static inline pte_t pte_mkuffd(pte_t pte)
 {
 	return pte_wrprotect(__pte(pte_val(pte) | _PAGE_UFFD));
 }
 
-static inline pte_t pte_clear_uffd_wp(pte_t pte)
+static inline pte_t pte_clear_uffd(pte_t pte)
 {
 	return __pte(pte_val(pte) & ~(_PAGE_UFFD));
 }
 
-static inline bool pte_swp_uffd_wp(pte_t pte)
+static inline bool pte_swp_uffd(pte_t pte)
 {
 	return !!(pte_val(pte) & _PAGE_SWP_UFFD);
 }
 
-static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
+static inline pte_t pte_swp_mkuffd(pte_t pte)
 {
 	return __pte(pte_val(pte) | _PAGE_SWP_UFFD);
 }
 
-static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
+static inline pte_t pte_swp_clear_uffd(pte_t pte)
 {
 	return __pte(pte_val(pte) & ~(_PAGE_SWP_UFFD));
 }
@@ -886,34 +886,34 @@ static inline pud_t pud_mkspecial(pud_t pud)
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-static inline bool pmd_uffd_wp(pmd_t pmd)
+static inline bool pmd_uffd(pmd_t pmd)
 {
-	return pte_uffd_wp(pmd_pte(pmd));
+	return pte_uffd(pmd_pte(pmd));
 }
 
-static inline pmd_t pmd_mkuffd_wp(pmd_t pmd)
+static inline pmd_t pmd_mkuffd(pmd_t pmd)
 {
-	return pte_pmd(pte_mkuffd_wp(pmd_pte(pmd)));
+	return pte_pmd(pte_mkuffd(pmd_pte(pmd)));
 }
 
-static inline pmd_t pmd_clear_uffd_wp(pmd_t pmd)
+static inline pmd_t pmd_clear_uffd(pmd_t pmd)
 {
-	return pte_pmd(pte_clear_uffd_wp(pmd_pte(pmd)));
+	return pte_pmd(pte_clear_uffd(pmd_pte(pmd)));
 }
 
-static inline bool pmd_swp_uffd_wp(pmd_t pmd)
+static inline bool pmd_swp_uffd(pmd_t pmd)
 {
-	return pte_swp_uffd_wp(pmd_pte(pmd));
+	return pte_swp_uffd(pmd_pte(pmd));
 }
 
-static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
+static inline pmd_t pmd_swp_mkuffd(pmd_t pmd)
 {
-	return pte_pmd(pte_swp_mkuffd_wp(pmd_pte(pmd)));
+	return pte_pmd(pte_swp_mkuffd(pmd_pte(pmd)));
 }
 
-static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
+static inline pmd_t pmd_swp_clear_uffd(pmd_t pmd)
 {
-	return pte_pmd(pte_swp_clear_uffd_wp(pmd_pte(pmd)));
+	return pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)));
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
diff --git a/arch/s390/include/asm/hugetlb.h b/arch/s390/include/asm/hugetlb.h
index 6983e52eaf81..cf8a176ff3d8 100644
--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -77,20 +77,20 @@ static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 	__set_huge_pte_at(mm, addr, ptep, pte_wrprotect(pte));
 }
 
-#define __HAVE_ARCH_HUGE_PTE_MKUFFD_WP
-static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
+#define __HAVE_ARCH_HUGE_PTE_MKUFFD
+static inline pte_t huge_pte_mkuffd(pte_t pte)
 {
 	return pte;
 }
 
-#define __HAVE_ARCH_HUGE_PTE_CLEAR_UFFD_WP
-static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
+#define __HAVE_ARCH_HUGE_PTE_CLEAR_UFFD
+static inline pte_t huge_pte_clear_uffd(pte_t pte)
 {
 	return pte;
 }
 
-#define __HAVE_ARCH_HUGE_PTE_UFFD_WP
-static inline int huge_pte_uffd_wp(pte_t pte)
+#define __HAVE_ARCH_HUGE_PTE_UFFD
+static inline int huge_pte_uffd(pte_t pte)
 {
 	return 0;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 038c806b50a2..d14c84b2a332 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -411,17 +411,17 @@ static inline pte_t pte_wrprotect(pte_t pte)
 }
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-static inline int pte_uffd_wp(pte_t pte)
+static inline int pte_uffd(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_UFFD;
 }
 
-static inline pte_t pte_mkuffd_wp(pte_t pte)
+static inline pte_t pte_mkuffd(pte_t pte)
 {
 	return pte_wrprotect(pte_set_flags(pte, _PAGE_UFFD));
 }
 
-static inline pte_t pte_clear_uffd_wp(pte_t pte)
+static inline pte_t pte_clear_uffd(pte_t pte)
 {
 	return pte_clear_flags(pte, _PAGE_UFFD);
 }
@@ -526,17 +526,17 @@ static inline pmd_t pmd_wrprotect(pmd_t pmd)
 }
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-static inline int pmd_uffd_wp(pmd_t pmd)
+static inline int pmd_uffd(pmd_t pmd)
 {
 	return pmd_flags(pmd) & _PAGE_UFFD;
 }
 
-static inline pmd_t pmd_mkuffd_wp(pmd_t pmd)
+static inline pmd_t pmd_mkuffd(pmd_t pmd)
 {
 	return pmd_wrprotect(pmd_set_flags(pmd, _PAGE_UFFD));
 }
 
-static inline pmd_t pmd_clear_uffd_wp(pmd_t pmd)
+static inline pmd_t pmd_clear_uffd(pmd_t pmd)
 {
 	return pmd_clear_flags(pmd, _PAGE_UFFD);
 }
@@ -1548,32 +1548,32 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
+static inline pte_t pte_swp_mkuffd(pte_t pte)
 {
 	return pte_set_flags(pte, _PAGE_SWP_UFFD);
 }
 
-static inline int pte_swp_uffd_wp(pte_t pte)
+static inline int pte_swp_uffd(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_SWP_UFFD;
 }
 
-static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
+static inline pte_t pte_swp_clear_uffd(pte_t pte)
 {
 	return pte_clear_flags(pte, _PAGE_SWP_UFFD);
 }
 
-static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
+static inline pmd_t pmd_swp_mkuffd(pmd_t pmd)
 {
 	return pmd_set_flags(pmd, _PAGE_SWP_UFFD);
 }
 
-static inline int pmd_swp_uffd_wp(pmd_t pmd)
+static inline int pmd_swp_uffd(pmd_t pmd)
 {
 	return pmd_flags(pmd) & _PAGE_SWP_UFFD;
 }
 
-static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
+static inline pmd_t pmd_swp_clear_uffd(pmd_t pmd)
 {
 	return pmd_clear_flags(pmd, _PAGE_SWP_UFFD);
 }
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e21a38ac745b..1e5f6ee8a3b6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2035,14 +2035,14 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 		page = vm_normal_page(vma, addr, pte);
 		if (pte_soft_dirty(pte))
 			flags |= PM_SOFT_DIRTY;
-		if (pte_uffd_wp(pte))
+		if (pte_uffd(pte))
 			flags |= PM_UFFD_WP;
 	} else {
 		softleaf_t entry;
 
 		if (pte_swp_soft_dirty(pte))
 			flags |= PM_SOFT_DIRTY;
-		if (pte_swp_uffd_wp(pte))
+		if (pte_swp_uffd(pte))
 			flags |= PM_UFFD_WP;
 		entry = softleaf_from_pte(pte);
 		if (pm->show_pfn) {
@@ -2108,7 +2108,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 		flags |= PM_PRESENT;
 		if (pmd_soft_dirty(pmd))
 			flags |= PM_SOFT_DIRTY;
-		if (pmd_uffd_wp(pmd))
+		if (pmd_uffd(pmd))
 			flags |= PM_UFFD_WP;
 		if (pm->show_pfn)
 			frame = pmd_pfn(pmd) + idx;
@@ -2127,7 +2127,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 		flags |= PM_SWAP;
 		if (pmd_swp_soft_dirty(pmd))
 			flags |= PM_SOFT_DIRTY;
-		if (pmd_swp_uffd_wp(pmd))
+		if (pmd_swp_uffd(pmd))
 			flags |= PM_UFFD_WP;
 		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
 		page = softleaf_to_page(entry);
@@ -2233,14 +2233,14 @@ static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 		    !hugetlb_pmd_shared(ptep))
 			flags |= PM_MMAP_EXCLUSIVE;
 
-		if (huge_pte_uffd_wp(pte))
+		if (huge_pte_uffd(pte))
 			flags |= PM_UFFD_WP;
 
 		flags |= PM_PRESENT;
 		if (pm->show_pfn)
 			frame = pte_pfn(pte) +
 				((addr & ~hmask) >> PAGE_SHIFT);
-	} else if (pte_swp_uffd_wp_any(pte)) {
+	} else if (pte_swp_uffd_any(pte)) {
 		flags |= PM_UFFD_WP;
 	}
 
@@ -2441,7 +2441,7 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
 		categories = PAGE_IS_PRESENT;
 
-		if (!pte_uffd_wp(pte))
+		if (!pte_uffd(pte))
 			categories |= PAGE_IS_WRITTEN;
 
 		if (p->masks_of_interest & PAGE_IS_FILE) {
@@ -2459,7 +2459,7 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
 		categories = PAGE_IS_SWAPPED;
 
-		if (!pte_swp_uffd_wp_any(pte))
+		if (!pte_swp_uffd_any(pte))
 			categories |= PAGE_IS_WRITTEN;
 
 		entry = softleaf_from_pte(pte);
@@ -2484,13 +2484,13 @@ static void make_uffd_wp_pte(struct vm_area_struct *vma,
 		pte_t old_pte;
 
 		old_pte = ptep_modify_prot_start(vma, addr, pte);
-		ptent = pte_mkuffd_wp(old_pte);
+		ptent = pte_mkuffd(old_pte);
 		ptep_modify_prot_commit(vma, addr, pte, old_pte, ptent);
 	} else if (pte_none(ptent)) {
 		set_pte_at(vma->vm_mm, addr, pte,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 	} else {
-		ptent = pte_swp_mkuffd_wp(ptent);
+		ptent = pte_swp_mkuffd(ptent);
 		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
 }
@@ -2509,7 +2509,7 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 		struct page *page;
 
 		categories |= PAGE_IS_PRESENT;
-		if (!pmd_uffd_wp(pmd))
+		if (!pmd_uffd(pmd))
 			categories |= PAGE_IS_WRITTEN;
 
 		if (p->masks_of_interest & PAGE_IS_FILE) {
@@ -2524,7 +2524,7 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 			categories |= PAGE_IS_SOFT_DIRTY;
 	} else {
 		categories |= PAGE_IS_SWAPPED;
-		if (!pmd_swp_uffd_wp(pmd))
+		if (!pmd_swp_uffd(pmd))
 			categories |= PAGE_IS_WRITTEN;
 		if (pmd_swp_soft_dirty(pmd))
 			categories |= PAGE_IS_SOFT_DIRTY;
@@ -2548,10 +2548,10 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 
 	if (pmd_present(pmd)) {
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
-		pmd = pmd_mkuffd_wp(old);
+		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	} else if (pmd_is_migration_entry(pmd)) {
-		pmd = pmd_swp_mkuffd_wp(pmd);
+		pmd = pmd_swp_mkuffd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
 }
@@ -2573,7 +2573,7 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
 	if (pte_present(pte)) {
 		categories |= PAGE_IS_PRESENT;
 
-		if (!huge_pte_uffd_wp(pte))
+		if (!huge_pte_uffd(pte))
 			categories |= PAGE_IS_WRITTEN;
 		if (!PageAnon(pte_page(pte)))
 			categories |= PAGE_IS_FILE;
@@ -2584,7 +2584,7 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
 	} else {
 		categories |= PAGE_IS_SWAPPED;
 
-		if (!pte_swp_uffd_wp_any(pte))
+		if (!pte_swp_uffd_any(pte))
 			categories |= PAGE_IS_WRITTEN;
 		if (pte_swp_soft_dirty(pte))
 			categories |= PAGE_IS_SOFT_DIRTY;
@@ -2612,12 +2612,12 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 
 	if (softleaf_is_migration(entry)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
-				pte_swp_mkuffd_wp(ptent), psize);
+				pte_swp_mkuffd(ptent), psize);
 	} else {
 		pte_t old_pte, new_pte;
 
 		old_pte = huge_ptep_modify_prot_start(vma, addr, ptep);
-		new_pte = huge_pte_mkuffd_wp(old_pte);
+		new_pte = huge_pte_mkuffd(old_pte);
 		huge_ptep_modify_prot_commit(vma, addr, ptep, old_pte, new_pte);
 	}
 }
@@ -2850,8 +2850,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
 			pte_t ptent = ptep_get(pte);
 
-			if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
-			    pte_swp_uffd_wp_any(ptent))
+			if ((pte_present(ptent) && pte_uffd(ptent)) ||
+			    pte_swp_uffd_any(ptent))
 				continue;
 			make_uffd_wp_pte(vma, addr, pte, ptent);
 			if (!flush_end)
@@ -2868,8 +2868,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 			unsigned long next = addr + PAGE_SIZE;
 			pte_t ptent = ptep_get(pte);
 
-			if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
-			    pte_swp_uffd_wp_any(ptent))
+			if ((pte_present(ptent) && pte_uffd(ptent)) ||
+			    pte_swp_uffd_any(ptent))
 				continue;
 			ret = pagemap_scan_output(p->cur_vma_category | PAGE_IS_WRITTEN,
 						  p, addr, &next);
diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetlb.h
index e1a2e1b7c8e7..635c41cc3479 100644
--- a/include/asm-generic/hugetlb.h
+++ b/include/asm-generic/hugetlb.h
@@ -37,24 +37,24 @@ static inline pte_t huge_pte_modify(pte_t pte, pgprot_t newprot)
 	return pte_modify(pte, newprot);
 }
 
-#ifndef __HAVE_ARCH_HUGE_PTE_MKUFFD_WP
-static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
+#ifndef __HAVE_ARCH_HUGE_PTE_MKUFFD
+static inline pte_t huge_pte_mkuffd(pte_t pte)
 {
-	return huge_pte_wrprotect(pte_mkuffd_wp(pte));
+	return huge_pte_wrprotect(pte_mkuffd(pte));
 }
 #endif
 
-#ifndef __HAVE_ARCH_HUGE_PTE_CLEAR_UFFD_WP
-static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
+#ifndef __HAVE_ARCH_HUGE_PTE_CLEAR_UFFD
+static inline pte_t huge_pte_clear_uffd(pte_t pte)
 {
-	return pte_clear_uffd_wp(pte);
+	return pte_clear_uffd(pte);
 }
 #endif
 
-#ifndef __HAVE_ARCH_HUGE_PTE_UFFD_WP
-static inline int huge_pte_uffd_wp(pte_t pte)
+#ifndef __HAVE_ARCH_HUGE_PTE_UFFD
+static inline int huge_pte_uffd(pte_t pte)
 {
-	return pte_uffd_wp(pte);
+	return pte_uffd(pte);
 }
 #endif
 
diff --git a/include/asm-generic/pgtable_uffd.h b/include/asm-generic/pgtable_uffd.h
index 0d85791efdf7..30e88fc1de2f 100644
--- a/include/asm-generic/pgtable_uffd.h
+++ b/include/asm-generic/pgtable_uffd.h
@@ -2,79 +2,79 @@
 #define _ASM_GENERIC_PGTABLE_UFFD_H
 
 /*
- * Some platforms can customize the uffd-wp bit, making it unavailable
+ * Some platforms can customize the uffd PTE bit, making it unavailable
  * even if the architecture provides the resource.
  * Adding this API allows architectures to add their own checks for the
  * devices on which the kernel is running.
  * Note: When overriding it, please make sure the
  * CONFIG_HAVE_ARCH_USERFAULTFD_WP is part of this macro.
  */
-#ifndef pgtable_supports_uffd_wp
-#define pgtable_supports_uffd_wp()	IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP)
+#ifndef pgtable_supports_uffd
+#define pgtable_supports_uffd()	IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP)
 #endif
 
 static inline bool uffd_supports_wp_marker(void)
 {
-	return pgtable_supports_uffd_wp() && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP);
+	return pgtable_supports_uffd() && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP);
 }
 
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-static __always_inline int pte_uffd_wp(pte_t pte)
+static __always_inline int pte_uffd(pte_t pte)
 {
 	return 0;
 }
 
-static __always_inline int pmd_uffd_wp(pmd_t pmd)
+static __always_inline int pmd_uffd(pmd_t pmd)
 {
 	return 0;
 }
 
-static __always_inline pte_t pte_mkuffd_wp(pte_t pte)
+static __always_inline pte_t pte_mkuffd(pte_t pte)
 {
 	return pte;
 }
 
-static __always_inline pmd_t pmd_mkuffd_wp(pmd_t pmd)
+static __always_inline pmd_t pmd_mkuffd(pmd_t pmd)
 {
 	return pmd;
 }
 
-static __always_inline pte_t pte_clear_uffd_wp(pte_t pte)
+static __always_inline pte_t pte_clear_uffd(pte_t pte)
 {
 	return pte;
 }
 
-static __always_inline pmd_t pmd_clear_uffd_wp(pmd_t pmd)
+static __always_inline pmd_t pmd_clear_uffd(pmd_t pmd)
 {
 	return pmd;
 }
 
-static __always_inline pte_t pte_swp_mkuffd_wp(pte_t pte)
+static __always_inline pte_t pte_swp_mkuffd(pte_t pte)
 {
 	return pte;
 }
 
-static __always_inline int pte_swp_uffd_wp(pte_t pte)
+static __always_inline int pte_swp_uffd(pte_t pte)
 {
 	return 0;
 }
 
-static __always_inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
+static __always_inline pte_t pte_swp_clear_uffd(pte_t pte)
 {
 	return pte;
 }
 
-static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
+static inline pmd_t pmd_swp_mkuffd(pmd_t pmd)
 {
 	return pmd;
 }
 
-static inline int pmd_swp_uffd_wp(pmd_t pmd)
+static inline int pmd_swp_uffd(pmd_t pmd)
 {
 	return 0;
 }
 
-static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
+static inline pmd_t pmd_swp_clear_uffd(pmd_t pmd)
 {
 	return pmd;
 }
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 992cd8bd8ed0..2ce2f37ac883 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -100,8 +100,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 
 	if (pmd_swp_soft_dirty(pmd))
 		pmd = pmd_swp_clear_soft_dirty(pmd);
-	if (pmd_swp_uffd_wp(pmd))
-		pmd = pmd_swp_clear_uffd_wp(pmd);
+	if (pmd_swp_uffd(pmd))
+		pmd = pmd_swp_clear_uffd(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 
 	/* Temporary until swp_entry_t eliminated. */
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a171070e15f0..2811caf4188d 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -600,14 +600,14 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 		return false;
 
 	/* A uffd-wp wr-protected normal pte */
-	if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
+	if (unlikely(pte_present(pteval) && pte_uffd(pteval)))
 		arm_uffd_pte = true;
 
 	/*
 	 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
 	 * existing pte marker with uffd-wp bit set.
 	 */
-	if (unlikely(pte_swp_uffd_wp_any(pteval)))
+	if (unlikely(pte_swp_uffd_any(pteval)))
 		arm_uffd_pte = true;
 
 	if (unlikely(arm_uffd_pte)) {
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8cfc966eae48..15c6440e38dd 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -73,8 +73,8 @@ static inline pte_t pte_swp_clear_flags(pte_t pte)
 		pte = pte_swp_clear_exclusive(pte);
 	if (pte_swp_soft_dirty(pte))
 		pte = pte_swp_clear_soft_dirty(pte);
-	if (pte_swp_uffd_wp(pte))
-		pte = pte_swp_clear_uffd_wp(pte);
+	if (pte_swp_uffd(pte))
+		pte = pte_swp_clear_uffd(pte);
 	return pte;
 }
 
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 3ec8e1071673..f4cf5763f92c 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -211,13 +211,13 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
-	return userfaultfd_wp(vma) && pte_uffd_wp(pte);
+	return userfaultfd_wp(vma) && pte_uffd(pte);
 }
 
 static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 					   pmd_t pmd)
 {
-	return userfaultfd_wp(vma) && pmd_uffd_wp(pmd);
+	return userfaultfd_wp(vma) && pmd_uffd(pmd);
 }
 
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
@@ -272,10 +272,10 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 }
 
 /*
- * Returns true if this is a swap pte and was uffd-wp wr-protected in either
- * forms (pte marker or a normal swap pte), false otherwise.
+ * Returns true if this swap pte carries uffd-tracked state in either
+ * form (pte marker or a normal swap pte), false otherwise.
  */
-static inline bool pte_swp_uffd_wp_any(pte_t pte)
+static inline bool pte_swp_uffd_any(pte_t pte)
 {
 	if (!uffd_supports_wp_marker())
 		return false;
@@ -283,7 +283,7 @@ static inline bool pte_swp_uffd_wp_any(pte_t pte)
 	if (pte_present(pte))
 		return false;
 
-	if (pte_swp_uffd_wp(pte))
+	if (pte_swp_uffd(pte))
 		return true;
 
 	if (pte_is_uffd_wp_marker(pte))
@@ -424,7 +424,7 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
  * Returns true if this is a swap pte and was uffd-wp wr-protected in either
  * forms (pte marker or a normal swap pte), false otherwise.
  */
-static inline bool pte_swp_uffd_wp_any(pte_t pte)
+static inline bool pte_swp_uffd_any(pte_t pte)
 {
 	return false;
 }
diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 291fae364c62..5a48c5406cce 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -16,7 +16,7 @@
 	EM( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
 	EM( SCAN_EXCEED_SHARED_PTE,	"exceed_shared_pte")		\
 	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
-	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
+	EM( SCAN_PTE_UFFD,		"pte_uffd_wp")			\
 	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
 	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
 	EM( SCAN_PAGE_NULL,		"page_null")			\
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b7c895b1d366..d43c2255f47d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1909,8 +1909,8 @@ static void copy_huge_non_present_pmd(
 		pmd = swp_entry_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*src_pmd))
 			pmd = pmd_swp_mksoft_dirty(pmd);
-		if (pmd_swp_uffd_wp(*src_pmd))
-			pmd = pmd_swp_mkuffd_wp(pmd);
+		if (pmd_swp_uffd(*src_pmd))
+			pmd = pmd_swp_mkuffd(pmd);
 		set_pmd_at(src_mm, addr, src_pmd, pmd);
 	} else if (softleaf_is_device_private(entry)) {
 		/*
@@ -1923,8 +1923,8 @@ static void copy_huge_non_present_pmd(
 
 			if (pmd_swp_soft_dirty(*src_pmd))
 				pmd = pmd_swp_mksoft_dirty(pmd);
-			if (pmd_swp_uffd_wp(*src_pmd))
-				pmd = pmd_swp_mkuffd_wp(pmd);
+			if (pmd_swp_uffd(*src_pmd))
+				pmd = pmd_swp_mkuffd(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 
@@ -1944,7 +1944,7 @@ static void copy_huge_non_present_pmd(
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 	if (!userfaultfd_wp(dst_vma))
-		pmd = pmd_swp_clear_uffd_wp(pmd);
+		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 }
 
@@ -2040,7 +2040,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	if (!userfaultfd_wp(dst_vma))
-		pmd = pmd_clear_uffd_wp(pmd);
+		pmd = pmd_clear_uffd(pmd);
 	pmd = pmd_wrprotect(pmd);
 set_pmd:
 	pmd = pmd_mkold(pmd);
@@ -2581,9 +2581,9 @@ static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
 	if (pmd_none(pmd))
 		return pmd;
 	if (pmd_present(pmd))
-		pmd = pmd_clear_uffd_wp(pmd);
+		pmd = pmd_clear_uffd(pmd);
 	else
-		pmd = pmd_swp_clear_uffd_wp(pmd);
+		pmd = pmd_swp_clear_uffd(pmd);
 
 	return pmd;
 }
@@ -2663,16 +2663,16 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 	} else if (softleaf_is_device_private_write(entry)) {
 		entry = make_readable_device_private_entry(swp_offset(entry));
 		newpmd = swp_entry_to_pmd(entry);
-		if (pmd_swp_uffd_wp(*pmd))
-			newpmd = pmd_swp_mkuffd_wp(newpmd);
+		if (pmd_swp_uffd(*pmd))
+			newpmd = pmd_swp_mkuffd(newpmd);
 	} else {
 		newpmd = *pmd;
 	}
 
 	if (uffd_wp)
-		newpmd = pmd_swp_mkuffd_wp(newpmd);
+		newpmd = pmd_swp_mkuffd(newpmd);
 	else if (uffd_wp_resolve)
-		newpmd = pmd_swp_clear_uffd_wp(newpmd);
+		newpmd = pmd_swp_clear_uffd(newpmd);
 	if (!pmd_same(*pmd, newpmd))
 		set_pmd_at(mm, addr, pmd, newpmd);
 }
@@ -2753,14 +2753,14 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	entry = pmd_modify(oldpmd, newprot);
 	if (uffd_wp)
-		entry = pmd_mkuffd_wp(entry);
+		entry = pmd_mkuffd(entry);
 	else if (uffd_wp_resolve)
 		/*
 		 * Leave the write bit to be handled by PF interrupt
 		 * handler, then things like COW could be properly
 		 * handled.
 		 */
-		entry = pmd_clear_uffd_wp(entry);
+		entry = pmd_clear_uffd(entry);
 
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
@@ -3103,8 +3103,8 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 
 		entry = pfn_pte(zero_pfn(addr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
-		if (pmd_uffd_wp(old_pmd))
-			entry = pte_mkuffd_wp(entry);
+		if (pmd_uffd(old_pmd))
+			entry = pte_mkuffd(entry);
 		VM_BUG_ON(!pte_none(ptep_get(pte)));
 		set_pte_at(mm, addr, pte, entry);
 		pte++;
@@ -3188,7 +3188,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		folio = page_folio(page);
 
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+		uffd_wp = pmd_swp_uffd(old_pmd);
 
 		write = softleaf_is_migration_write(entry);
 		if (PageAnon(page))
@@ -3204,7 +3204,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		folio = page_folio(page);
 
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+		uffd_wp = pmd_swp_uffd(old_pmd);
 
 		write = softleaf_is_device_private_write(entry);
 		anon_exclusive = PageAnonExclusive(page);
@@ -3261,7 +3261,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		write = pmd_write(old_pmd);
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
-		uffd_wp = pmd_uffd_wp(old_pmd);
+		uffd_wp = pmd_uffd(old_pmd);
 
 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
 		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
@@ -3332,7 +3332,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			if (soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
 			if (uffd_wp)
-				entry = pte_swp_mkuffd_wp(entry);
+				entry = pte_swp_mkuffd(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
@@ -3359,7 +3359,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			if (soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
 			if (uffd_wp)
-				entry = pte_swp_mkuffd_wp(entry);
+				entry = pte_swp_mkuffd(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
@@ -3377,7 +3377,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		if (soft_dirty)
 			entry = pte_mksoft_dirty(entry);
 		if (uffd_wp)
-			entry = pte_mkuffd_wp(entry);
+			entry = pte_mkuffd(entry);
 
 		for (i = 0; i < HPAGE_PMD_NR; i++)
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
@@ -5018,8 +5018,8 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	pmdswp = swp_entry_to_pmd(entry);
 	if (pmd_soft_dirty(pmdval))
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
-	if (pmd_uffd_wp(pmdval))
-		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
+	if (pmd_uffd(pmdval))
+		pmdswp = pmd_swp_mkuffd(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	folio_remove_rmap_pmd(folio, page, vma);
 	folio_put(folio);
@@ -5049,8 +5049,8 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		pmde = pmd_mksoft_dirty(pmde);
 	if (softleaf_is_migration_write(entry))
 		pmde = pmd_mkwrite(pmde, vma);
-	if (pmd_swp_uffd_wp(*pvmw->pmd))
-		pmde = pmd_mkuffd_wp(pmde);
+	if (pmd_swp_uffd(*pvmw->pmd))
+		pmde = pmd_mkuffd(pmde);
 	if (!softleaf_is_migration_young(entry))
 		pmde = pmd_mkold(pmde);
 	/* NOTE: this may contain setting soft-dirty on some archs */
@@ -5070,8 +5070,8 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
 			pmde = pmd_swp_mksoft_dirty(pmde);
-		if (pmd_swp_uffd_wp(*pvmw->pmd))
-			pmde = pmd_swp_mkuffd_wp(pmde);
+		if (pmd_swp_uffd(*pvmw->pmd))
+			pmde = pmd_swp_mkuffd(pmde);
 	}
 
 	if (folio_test_anon(folio)) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..d0c81a056ae2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4843,8 +4843,8 @@ hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long add
 
 	__folio_mark_uptodate(new_folio);
 	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
-	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(old))
-		newpte = huge_pte_mkuffd_wp(newpte);
+	if (userfaultfd_wp(vma) && huge_pte_uffd(old))
+		newpte = huge_pte_mkuffd(newpte);
 	set_huge_pte_at(vma->vm_mm, addr, ptep, newpte, sz);
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
 	folio_set_hugetlb_migratable(new_folio);
@@ -4918,10 +4918,10 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = huge_pte_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
-			bool uffd_wp = pte_swp_uffd_wp(entry);
+			bool uffd = pte_swp_uffd(entry);
 
 			if (!softleaf_is_migration_read(softleaf) && cow) {
 				/*
@@ -4931,12 +4931,12 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				softleaf = make_readable_migration_entry(
 							swp_offset(softleaf));
 				entry = swp_entry_to_pte(softleaf);
-				if (userfaultfd_wp(src_vma) && uffd_wp)
-					entry = pte_swp_mkuffd_wp(entry);
+				if (userfaultfd_wp(src_vma) && uffd)
+					entry = pte_swp_mkuffd(entry);
 				set_huge_pte_at(src, addr, src_pte, entry, sz);
 			}
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = huge_pte_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(pte_is_marker(entry))) {
 			const pte_marker marker = copy_pte_marker(softleaf, dst_vma);
@@ -5013,7 +5013,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			}
 
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = huge_pte_clear_uffd(entry);
 
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 			hugetlb_count_add(npages, dst);
@@ -5061,9 +5061,9 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 	} else {
 		if (need_clear_uffd_wp) {
 			if (pte_present(pte))
-				pte = huge_pte_clear_uffd_wp(pte);
+				pte = huge_pte_clear_uffd(pte);
 			else
-				pte = pte_swp_clear_uffd_wp(pte);
+				pte = pte_swp_clear_uffd(pte);
 		}
 		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
 	}
@@ -5197,7 +5197,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			 * drop the uffd-wp bit in this zap, then replace the
 			 * pte with a marker.
 			 */
-			if (pte_swp_uffd_wp_any(pte) &&
+			if (pte_swp_uffd_any(pte) &&
 			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP),
@@ -5233,7 +5233,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (huge_pte_dirty(pte))
 			folio_mark_dirty(folio);
 		/* Leave a uffd-wp pte marker if needed */
-		if (huge_pte_uffd_wp(pte) &&
+		if (huge_pte_uffd(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP),
@@ -5437,7 +5437,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * can trigger this, because hugetlb_fault() will always resolve
 	 * uffd-wp bit first.
 	 */
-	if (!unshare && huge_pte_uffd_wp(pte))
+	if (!unshare && huge_pte_uffd(pte))
 		return 0;
 
 	/* Let's take out MAP_SHARED mappings first. */
@@ -5581,8 +5581,8 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 		huge_ptep_clear_flush(vma, vmf->address, vmf->pte);
 		hugetlb_remove_rmap(old_folio);
 		hugetlb_add_new_anon_rmap(new_folio, vma, vmf->address);
-		if (huge_pte_uffd_wp(pte))
-			newpte = huge_pte_mkuffd_wp(newpte);
+		if (huge_pte_uffd(pte))
+			newpte = huge_pte_mkuffd(newpte);
 		set_huge_pte_at(mm, vmf->address, vmf->pte, newpte,
 				huge_page_size(h));
 		folio_set_hugetlb_migratable(new_folio);
@@ -5860,7 +5860,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	 * if populated.
 	 */
 	if (unlikely(pte_is_uffd_wp_marker(vmf->orig_pte)))
-		new_pte = huge_pte_mkuffd_wp(new_pte);
+		new_pte = huge_pte_mkuffd(new_pte);
 	set_huge_pte_at(mm, vmf->address, vmf->pte, new_pte, huge_page_size(h));
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
@@ -6058,7 +6058,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_ptl;
 
 	/* Handle userfault-wp first, before trying to lock more pages */
-	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
+	if (userfaultfd_wp(vma) && huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
 		if (!userfaultfd_wp_async(vma)) {
 			spin_unlock(vmf.ptl);
@@ -6067,7 +6067,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			return handle_userfault(&vmf, VM_UFFD_WP);
 		}
 
-		vmf.orig_pte = huge_pte_clear_uffd_wp(vmf.orig_pte);
+		vmf.orig_pte = huge_pte_clear_uffd(vmf.orig_pte);
 		set_huge_pte_at(mm, vmf.address, vmf.pte, vmf.orig_pte,
 				huge_page_size(hstate_vma(vma)));
 		/* Fallthrough to CoW */
@@ -6352,7 +6352,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	_dst_pte = pte_mkyoung(_dst_pte);
 
 	if (wp_enabled)
-		_dst_pte = huge_pte_mkuffd_wp(_dst_pte);
+		_dst_pte = huge_pte_mkuffd(_dst_pte);
 
 	set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
 
@@ -6476,9 +6476,9 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			}
 
 			if (uffd_wp)
-				newpte = pte_swp_mkuffd_wp(newpte);
+				newpte = pte_swp_mkuffd(newpte);
 			else if (uffd_wp_resolve)
-				newpte = pte_swp_clear_uffd_wp(newpte);
+				newpte = pte_swp_clear_uffd(newpte);
 			if (!pte_same(pte, newpte))
 				set_huge_pte_at(mm, address, ptep, newpte, psize);
 		} else if (unlikely(pte_is_marker(pte))) {
@@ -6499,9 +6499,9 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			pte = huge_pte_modify(old_pte, newprot);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (uffd_wp)
-				pte = huge_pte_mkuffd_wp(pte);
+				pte = huge_pte_mkuffd(pte);
 			else if (uffd_wp_resolve)
-				pte = huge_pte_clear_uffd_wp(pte);
+				pte = huge_pte_clear_uffd(pte);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
 			tlb_remove_huge_tlb_entry(h, &tlb, ptep, address);
diff --git a/mm/internal.h b/mm/internal.h
index 5602393054f3..9325eefbea6a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -412,8 +412,8 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 		new = pte_swp_mksoft_dirty(new);
 	if (pte_swp_exclusive(pte))
 		new = pte_swp_mkexclusive(new);
-	if (pte_swp_uffd_wp(pte))
-		new = pte_swp_mkuffd_wp(new);
+	if (pte_swp_uffd(pte))
+		new = pte_swp_mkuffd(new);
 
 	return new;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4549a020bf73..afa218be15de 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -37,7 +37,7 @@ enum scan_result {
 	SCAN_EXCEED_SWAP_PTE,
 	SCAN_EXCEED_SHARED_PTE,
 	SCAN_PTE_NON_PRESENT,
-	SCAN_PTE_UFFD_WP,
+	SCAN_PTE_UFFD,
 	SCAN_PTE_MAPPED_HUGEPAGE,
 	SCAN_LACK_REFERENCED_PAGE,
 	SCAN_PAGE_NULL,
@@ -712,8 +712,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
 		}
-		if (pte_uffd_wp(pteval)) {
-			result = SCAN_PTE_UFFD_WP;
+		if (pte_uffd(pteval)) {
+			result = SCAN_PTE_UFFD;
 			goto out;
 		}
 		page = vm_normal_page(vma, addr, pteval);
@@ -1566,7 +1566,7 @@ static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
 			case SCAN_PAGE_NULL:
 			case SCAN_DEL_PAGE_LRU:
 			case SCAN_PTE_NON_PRESENT:
-			case SCAN_PTE_UFFD_WP:
+			case SCAN_PTE_UFFD:
 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
 			case SCAN_PAGE_LAZYFREE:
 				goto next_order;
@@ -1666,15 +1666,15 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			/*
 			 * Always be strict with uffd-wp
 			 * enabled swap entries.  Please see
-			 * comment below for pte_uffd_wp().
+			 * comment below for pte_uffd().
 			 */
-			if (pte_swp_uffd_wp_any(pteval)) {
-				result = SCAN_PTE_UFFD_WP;
+			if (pte_swp_uffd_any(pteval)) {
+				result = SCAN_PTE_UFFD;
 				goto out_unmap;
 			}
 			continue;
 		}
-		if (pte_uffd_wp(pteval)) {
+		if (pte_uffd(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
 			 * PTEs are armed with uffd write protection.
@@ -1684,7 +1684,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			 * userfault messages that falls outside of
 			 * the registered range.  So, just be simple.
 			 */
-			result = SCAN_PTE_UFFD_WP;
+			result = SCAN_PTE_UFFD;
 			goto out_unmap;
 		}
 
@@ -1897,7 +1897,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
 	if (userfaultfd_wp(vma))
-		return SCAN_PTE_UFFD_WP;
+		return SCAN_PTE_UFFD;
 
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
@@ -3244,7 +3244,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_NO_PTE_TABLE:
 		case SCAN_PTE_NON_PRESENT:
-		case SCAN_PTE_UFFD_WP:
+		case SCAN_PTE_UFFD:
 		case SCAN_LACK_REFERENCED_PAGE:
 		case SCAN_PAGE_NULL:
 		case SCAN_PAGE_COUNT:
diff --git a/mm/memory.c b/mm/memory.c
index 7c020995eafc..c4fd5cb4a08f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -893,8 +893,8 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
 
-	if (pte_swp_uffd_wp(orig_pte))
-		pte = pte_mkuffd_wp(pte);
+	if (pte_swp_uffd(orig_pte))
+		pte = pte_mkuffd(pte);
 
 	if ((vma->vm_flags & VM_WRITE) &&
 	    can_change_pte_writable(vma, address, pte)) {
@@ -984,8 +984,8 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			pte = softleaf_to_pte(entry);
 			if (pte_swp_soft_dirty(orig_pte))
 				pte = pte_swp_mksoft_dirty(pte);
-			if (pte_swp_uffd_wp(orig_pte))
-				pte = pte_swp_mkuffd_wp(pte);
+			if (pte_swp_uffd(orig_pte))
+				pte = pte_swp_mkuffd(pte);
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
 	} else if (softleaf_is_device_private(entry)) {
@@ -1018,8 +1018,8 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			entry = make_readable_device_private_entry(
 							swp_offset(entry));
 			pte = swp_entry_to_pte(entry);
-			if (pte_swp_uffd_wp(orig_pte))
-				pte = pte_swp_mkuffd_wp(pte);
+			if (pte_swp_uffd(orig_pte))
+				pte = pte_swp_mkuffd(pte);
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
 	} else if (softleaf_is_device_exclusive(entry)) {
@@ -1042,7 +1042,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		return 0;
 	}
 	if (!userfaultfd_wp(dst_vma))
-		pte = pte_swp_clear_uffd_wp(pte);
+		pte = pte_swp_clear_uffd(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -1090,7 +1090,7 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
 	if (userfaultfd_pte_wp(dst_vma, ptep_get(src_pte)))
 		/* Uffd-wp needs to be delivered to dest pte as well */
-		pte = pte_mkuffd_wp(pte);
+		pte = pte_mkuffd(pte);
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -1113,7 +1113,7 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 	pte = pte_mkold(pte);
 
 	if (!userfaultfd_wp(dst_vma))
-		pte = pte_clear_uffd_wp(pte);
+		pte = pte_clear_uffd(pte);
 
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
@@ -3925,8 +3925,8 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		if (unlikely(unshare)) {
 			if (pte_soft_dirty(vmf->orig_pte))
 				entry = pte_mksoft_dirty(entry);
-			if (pte_uffd_wp(vmf->orig_pte))
-				entry = pte_mkuffd_wp(entry);
+			if (pte_uffd(vmf->orig_pte))
+				entry = pte_mkuffd(entry);
 		} else {
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		}
@@ -4261,7 +4261,7 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 			 * etc.) because we're only removing the uffd-wp bit,
 			 * which is completely invisible to the user.
 			 */
-			pte = pte_clear_uffd_wp(ptep_get(vmf->pte));
+			pte = pte_clear_uffd(ptep_get(vmf->pte));
 
 			set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 			/*
@@ -5038,8 +5038,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	pte = mk_pte(page, vma->vm_page_prot);
 	if (pte_swp_soft_dirty(vmf->orig_pte))
 		pte = pte_mksoft_dirty(pte);
-	if (pte_swp_uffd_wp(vmf->orig_pte))
-		pte = pte_mkuffd_wp(pte);
+	if (pte_swp_uffd(vmf->orig_pte))
+		pte = pte_mkuffd(pte);
 
 	/*
 	 * Same logic as in do_wp_page(); however, optimize for pages that are
@@ -5255,7 +5255,7 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry), vma);
 	if (uffd_wp)
-		entry = pte_mkuffd_wp(entry);
+		entry = pte_mkuffd(entry);
 
 	folio_ref_add(folio, nr_pages - 1);
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
@@ -5322,7 +5322,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 			return handle_userfault(vmf, VM_UFFD_MISSING);
 		}
 		if (vmf_orig_pte_uffd_wp(vmf))
-			entry = pte_mkuffd_wp(entry);
+			entry = pte_mkuffd(entry);
 		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
 
 		/* No need to invalidate - it was non-present before */
@@ -5572,7 +5572,7 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 	else if (pte_write(entry) && folio_test_dirty(folio))
 		entry = pte_mkdirty(entry);
 	if (unlikely(vmf_orig_pte_uffd_wp(vmf)))
-		entry = pte_mkuffd_wp(entry);
+		entry = pte_mkuffd(entry);
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		VM_BUG_ON_FOLIO(nr != 1, folio);
diff --git a/mm/migrate.c b/mm/migrate.c
index 0c6a0ab6ecce..4bdb5be7afbf 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -326,8 +326,8 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 
 	if (pte_swp_soft_dirty(old_pte))
 		newpte = pte_mksoft_dirty(newpte);
-	if (pte_swp_uffd_wp(old_pte))
-		newpte = pte_mkuffd_wp(newpte);
+	if (pte_swp_uffd(old_pte))
+		newpte = pte_mkuffd(newpte);
 
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
@@ -391,8 +391,8 @@ static bool remove_migration_pte(struct folio *folio,
 
 		if (softleaf_is_migration_write(entry))
 			pte = pte_mkwrite(pte, vma);
-		else if (pte_swp_uffd_wp(old_pte))
-			pte = pte_mkuffd_wp(pte);
+		else if (pte_swp_uffd(old_pte))
+			pte = pte_mkuffd(pte);
 
 		if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
@@ -407,8 +407,8 @@ static bool remove_migration_pte(struct folio *folio,
 			pte = softleaf_to_pte(entry);
 			if (pte_swp_soft_dirty(old_pte))
 				pte = pte_swp_mksoft_dirty(pte);
-			if (pte_swp_uffd_wp(old_pte))
-				pte = pte_swp_mkuffd_wp(pte);
+			if (pte_swp_uffd(old_pte))
+				pte = pte_swp_mkuffd(pte);
 		}
 
 #ifdef CONFIG_HUGETLB_PAGE
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 554754eb26ff..17da1bab0248 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -445,13 +445,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			if (pte_present(pte)) {
 				if (pte_soft_dirty(pte))
 					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pte))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+				if (pte_uffd(pte))
+					swp_pte = pte_swp_mkuffd(swp_pte);
 			} else {
 				if (pte_swp_soft_dirty(pte))
 					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pte))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+				if (pte_swp_uffd(pte))
+					swp_pte = pte_swp_mkuffd(swp_pte);
 			}
 			set_pte_at(mm, addr, ptep, swp_pte);
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028c..8340c8b228c6 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -240,8 +240,8 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		 */
 		entry = make_readable_device_private_entry(swp_offset(entry));
 		newpte = swp_entry_to_pte(entry);
-		if (pte_swp_uffd_wp(oldpte))
-			newpte = pte_swp_mkuffd_wp(newpte);
+		if (pte_swp_uffd(oldpte))
+			newpte = pte_swp_mkuffd(newpte);
 	} else if (softleaf_is_marker(entry)) {
 		/*
 		 * Ignore error swap entries unconditionally,
@@ -266,9 +266,9 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 	}
 
 	if (uffd_wp)
-		newpte = pte_swp_mkuffd_wp(newpte);
+		newpte = pte_swp_mkuffd(newpte);
 	else if (uffd_wp_resolve)
-		newpte = pte_swp_clear_uffd_wp(newpte);
+		newpte = pte_swp_clear_uffd(newpte);
 
 	if (!pte_same(oldpte, newpte)) {
 		set_pte_at(vma->vm_mm, addr, pte, newpte);
@@ -290,9 +290,9 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 	ptent = pte_modify(oldpte, newprot);
 
 	if (uffd_wp)
-		ptent = pte_mkuffd_wp(ptent);
+		ptent = pte_mkuffd(ptent);
 	else if (uffd_wp_resolve)
-		ptent = pte_clear_uffd_wp(ptent);
+		ptent = pte_clear_uffd(ptent);
 
 	/*
 	 * In some writable, shared mappings, we might want
diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832..12732a5c547e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -297,9 +297,9 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		else {
 			if (need_clear_uffd_wp) {
 				if (pte_present(pte))
-					pte = pte_clear_uffd_wp(pte);
+					pte = pte_clear_uffd(pte);
 				else
-					pte = pte_swp_clear_uffd_wp(pte);
+					pte = pte_swp_clear_uffd(pte);
 			}
 			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
 		}
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 53a8997ec043..3fb995e5d40d 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -188,8 +188,8 @@ static inline bool softleaf_cached_writable(softleaf_t entry)
 static void page_table_check_pte_flags(pte_t pte)
 {
 	if (pte_present(pte)) {
-		WARN_ON_ONCE(pte_uffd_wp(pte) && pte_write(pte));
-	} else if (pte_swp_uffd_wp(pte)) {
+		WARN_ON_ONCE(pte_uffd(pte) && pte_write(pte));
+	} else if (pte_swp_uffd(pte)) {
 		const softleaf_t entry = softleaf_from_pte(pte);
 
 		WARN_ON_ONCE(softleaf_cached_writable(entry));
@@ -216,9 +216,9 @@ EXPORT_SYMBOL(__page_table_check_ptes_set);
 static inline void page_table_check_pmd_flags(pmd_t pmd)
 {
 	if (pmd_present(pmd)) {
-		if (pmd_uffd_wp(pmd))
+		if (pmd_uffd(pmd))
 			WARN_ON_ONCE(pmd_write(pmd));
-	} else if (pmd_swp_uffd_wp(pmd)) {
+	} else if (pmd_swp_uffd(pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(pmd);
 
 		WARN_ON_ONCE(softleaf_cached_writable(entry));
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..546bc1cf9391 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2318,13 +2318,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			if (likely(pte_present(pteval))) {
 				if (pte_soft_dirty(pteval))
 					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+				if (pte_uffd(pteval))
+					swp_pte = pte_swp_mkuffd(swp_pte);
 			} else {
 				if (pte_swp_soft_dirty(pteval))
 					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+				if (pte_swp_uffd(pteval))
+					swp_pte = pte_swp_mkuffd(swp_pte);
 			}
 			set_pte_at(mm, address, pvmw.pte, swp_pte);
 		} else {
@@ -2692,14 +2692,14 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				swp_pte = swp_entry_to_pte(entry);
 				if (pte_soft_dirty(pteval))
 					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+				if (pte_uffd(pteval))
+					swp_pte = pte_swp_mkuffd(swp_pte);
 			} else {
 				swp_pte = swp_entry_to_pte(entry);
 				if (pte_swp_soft_dirty(pteval))
 					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
+				if (pte_swp_uffd(pteval))
+					swp_pte = pte_swp_mkuffd(swp_pte);
 			}
 			if (folio_test_hugetlb(folio))
 				set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e3d126602a1e..15fdca2da1f7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2557,8 +2557,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
 	if (pte_swp_soft_dirty(old_pte))
 		new_pte = pte_mksoft_dirty(new_pte);
-	if (pte_swp_uffd_wp(old_pte))
-		new_pte = pte_mkuffd_wp(new_pte);
+	if (pte_swp_uffd(old_pte))
+		new_pte = pte_mkuffd(new_pte);
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index f6d2a1c67019..9d74be69873a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -394,7 +394,7 @@ static int mfill_atomic_install_pte(pmd_t *dst_pmd,
 	if (writable)
 		_dst_pte = pte_mkwrite(_dst_pte, dst_vma);
 	if (flags & MFILL_ATOMIC_WP)
-		_dst_pte = pte_mkuffd_wp(_dst_pte);
+		_dst_pte = pte_mkuffd(_dst_pte);
 
 	ret = -EAGAIN;
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
@@ -3591,7 +3591,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
 		vm_flags |= VM_UFFD_MISSING;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
-		if (!pgtable_supports_uffd_wp())
+		if (!pgtable_supports_uffd())
 			goto out;
 
 		vm_flags |= VM_UFFD_WP;
@@ -4301,7 +4301,7 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	uffdio_api.features &=
 		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
 #endif
-	if (!pgtable_supports_uffd_wp())
+	if (!pgtable_supports_uffd())
 		uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
 
 	if (!uffd_supports_wp_marker()) {
-- 
2.54.0


