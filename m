Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACA1CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E246B0189; Fri,  8 May 2026 11:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06006B018B; Fri,  8 May 2026 11:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BE66B018C; Fri,  8 May 2026 11:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBD516B0189
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:55:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03C831A01EF
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:55:54 +0000 (UTC)
X-FDA: 84744703470.26.FAA6FF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C818D100007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:55:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=snBvv7ar;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255753; a=rsa-sha256;
	cv=none;
	b=gRWUTGiNdby9FKkgCGu7E1Xv14eOYAxaBZuDIv79xB2dSPY7EYsfrJFiigv8kIKKSnv44u
	Imjlta0KDhM2tXdgVTheDMy2Q+UwxgIdi4d3Zqglzrbdn4epy9X3siKErrMP/xDgUe4mGm
	ul+8HFzfl9WTduWTtAyUFmoQ9Zzck+M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=snBvv7ar;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLYpzXhEhu9MRkzutbypz52nSHV6z72fCs2li8RILPw=;
	b=JHhv3Bj7z9otpAwIKbIFDNlJnzHpwqEjvrJ0QRA4+vVOqkqbV31nhInWWZTMDlBlhINpnR
	/ajKn9Ixs+cLpuC5exXRylfYcx+uAZ0b/nTB/HprBg11riZvSDiKMcQlMbzk5uZtZqA7wn
	YqTVYOLsG0f6dj6W/QjMBsA6d9JhLgU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3C5844186
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56142C4AF09;
	Fri,  8 May 2026 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255751;
	bh=3chCHKd3DSXObk35exTNmgWVS2JwewHvCMU1XUf+/b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snBvv7ar8DdkadrIkEGUwZetrRAECjknR6i1ysQM3OofMs2uAVKynw3fhdIM+r5sz
	 nePMZMLviiWPxfU41BZH7QxO2Hqrl6Zbe+e0sfTzAldEydNqKwns7xPZtC7MD02A0R
	 9O0+y4KLR6/UFg111ENTuR1tTgYppL8QQYmc95Hcm8ymAXZeZ3vBIvVObdvVU+7gQ9
	 pE7Usbpo0x+X7h9NN1678CIb9tml9LjLjSGs2x8u/+76S5LwvbEKHPoRsdKvkKZxXM
	 1Ibz981pP2Fh9N3Jp0JtlP+hLRdXIwUzJIv1vOU9tu2O7k1XSqQ8qJOYhyJP7INgJz
	 kkuUsuqDpLYxA==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 971A6F4006E;
	Fri,  8 May 2026 11:55:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 08 May 2026 11:55:50 -0400
X-ME-Sender: <xms:hgf-adKfYQh3XEYnAOohrXdPmgglAnL9gna4Z298u1rhm_7O-hifPA>
    <xme:hgf-adH_6YY5h7NNdQU2YN9J_4O_atBfP3jOdmd4IWjRP9ss1BkJzlcfWXJDjbQfY
    xqVgtO_tj5S3olrEJOy0xdbSSXyubOO3yZLoJqvx2qR14KHIsaqZB4>
X-ME-Received: <xmr:hgf-aePx4Aj_qpFPs6vFsgh-dfzhenIEOl3JU1mPXudZlJWAegiyTf_rs5Zq1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpedfmfhirhihlhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcu
    oehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhephfdujeefvdegke
    fffedvkeehkeekueevfedtleehgeetlefgfeevveeukefhtdetnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtph
    gruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedq
    khgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtg
    hpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgt
    phhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrd
    hhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughi
    rgdrtghomh
X-ME-Proxy: <xmx:hgf-aX8AOSpuX7U6YrjymmeVbAMktkQWbTZ_zROpQuKb5Utslyy4BA>
    <xmx:hgf-ab6ik5bvYi3xkm_NPba69BUT17iUsV9Fqlk7_f80FKlu5v0PpQ>
    <xmx:hgf-acUQhIsktF4p_Q4BQCPt-CAfgPI2nSIFhKe5dC6u_wbks91obg>
    <xmx:hgf-aRJI2am6Dsj1dbvAn0MW3eQV2oZIaCRBjrxGpOWdt91aZMl8eg>
    <xmx:hgf-aZQKfu1UVkQgCGXZUagw9UGMl3dA4Xq_8tt5rJdY9y2qvfCu-Bdt>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:55:48 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
Subject: [PATCH v2 01/14] mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
Date: Fri,  8 May 2026 16:55:13 +0100
Message-ID: <c0234d6796628248990ecd94a9d3f849ee8abc66.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1jb89efdwrdnxbc6qcugdpz8u8bghd5n
X-Rspam-User: 
X-Rspamd-Queue-Id: C818D100007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778255752-917527
X-HE-Meta: U2FsdGVkX19Rt1zjlZkHZjsw/s2vaa04Zx3DlAvPKfgYu52WTZWajTt5wyX4eBBSNXRDsrmxlUUH2egqNQjxzP0gK56OJJ4CCKf0OmKLXdzZw90mR32z1wip42w8zwfFnsaNSFXyO4TLXo9TGN+JLS6vO8AMchdKKWNaBnGehiLyEyvBC0X5mSPEcfjzG9BIdTuqYNjpHu6L6+2K8Y8SBB3bv/J4GojY0zmM88qNdcZ73ZHxIocOzAAsQxFvLfox24UUwqEZfX+Pmjmsye2QxFO/4eoVTlnZSIiPGQmOoamyeESQdS7//fw1x6Cgp7GI41zi1Xc3ERs09XvW2tcImflN/Fwfla3BOmStSWPZjV4EA3mMcnA4T/MW2lS7OI36h9JWh7E0rmWD3YuZJCoIz1peDX+MG2QBq14v6PICzfgJgymqnL7QEORdm8uADrOtOuLvwkI5BA7YhY2It1Jy4ksZdw+zlDvEkZvh5Hml1D3E6GJOBlQuG8Qr/7R47ZcWFDn8+24x6Axq5ejh/eUNhKWvitpH3oU1DxFr2W3gI3ODDwHloKmVsSpkFd8Epx+Y10lhfh+7SSEK06C311/6xGTyM5Eg7Un8wUccFAktvP/iC6FRTGz4szh9OfjgmcRWNLQPrMqmcKvohIULR+QwWyhfWq7ZOuA4fZRbrVyjBGqqLCPzyBA4iacjX1zPluhzXvpR8n5s8hq2Y3z5hNnDAuRDWmtpJY1s+ZAuxhCAGKbsoWE/IyswT8ovgau8jD6aY+4s83536Z5FT/OgBac5mgMqeTwcQW5PQpplFUHzi9Wk7Qd5ooKk2CxaKwQqZrEeSfm98DAsmspAdGp6jXk8UaiHnG02tX3FMsaXDNAVypay8977snhJSp9zCo7Aor5FSJL3LW3ldyXBelSN4MoBp6rzPgFjJnxXhSdAWswROcE3HksK26zD9WPxPKiENPVcKI9NVEvp6pchY5khLXb
 TIcNxAJM
 m+ValgtQCl/yffMULNJ2BCC9ndRVEAIRXUxhj/7RBa/+smIRwHaRX73TTo60mEa8NIWO9IDGCIizmUxFNv5MKsNbIyacZ5j99272elcuvN9B+olafbyu9rc/I20atr2vtXeByGj2PZCbJMOL8u9agZltiVw+Kqat3YhVFbNrWPZs3v3ZgjRs0CBCgubMoHElDFbhvi7BSzLKi2x9lUWJKzRVTuz3dbvPf9xVPxJR56/981kYHrTgFUgRXOyRY3z8msRixYngfq3KjvpIDkXYoHIkLuTySwuB5M/QeecW4wPSYEIwL1g57gYPlFAMWtdO06b5xaIZOn3XFvb5PlryRM+6Pt251TYV11meULcdy+umPJ//Pk9HDGdhlF5e8xd725tF+vmd6wMzhS1PybsYZDK9daA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_protnone() and pmd_protnone() detect present-but-inaccessible page
table entries. This capability is useful beyond NUMA balancing -- for
example, userfaultfd working set tracking uses protnone PTEs to track
page access without unmapping pages.

Introduce CONFIG_ARCH_HAS_PTE_PROTNONE to decouple the protnone PTE
infrastructure from CONFIG_NUMA_BALANCING. The six architectures that
support protnone PTEs (x86_64, arm64, powerpc, s390, riscv, loongarch)
now select this option, and CONFIG_NUMA_BALANCING depends on it.

No functional change -- the same set of architectures continues to have
working protnone support, but the infrastructure is now available
independently of NUMA balancing.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/Kconfig                           |  1 +
 arch/arm64/include/asm/pgtable.h             |  7 ++---
 arch/loongarch/Kconfig                       |  1 +
 arch/loongarch/include/asm/pgtable.h         |  4 +--
 arch/powerpc/include/asm/book3s/64/pgtable.h |  8 ++---
 arch/powerpc/platforms/Kconfig.cputype       |  1 +
 arch/riscv/Kconfig                           |  1 +
 arch/riscv/include/asm/pgtable.h             |  7 ++---
 arch/s390/Kconfig                            |  1 +
 arch/s390/include/asm/pgtable.h              |  4 +--
 arch/x86/Kconfig                             |  1 +
 arch/x86/include/asm/pgtable.h               |  8 ++---
 include/linux/pgtable.h                      | 32 ++++++++++++++------
 init/Kconfig                                 |  8 +++++
 mm/debug_vm_pgtable.c                        |  4 +--
 15 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..319470b3b1bb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -78,6 +78,7 @@ config ARM64
 	select ARCH_SUPPORTS_CFI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4dfa42b7d053..873f4ea2e288 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -553,10 +553,7 @@ static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	/*
@@ -575,7 +572,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 3b042dbb2c41..229b3d1b7056 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -67,6 +67,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 2a0b63ae421f..d295447a2763 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -619,7 +619,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline long pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_PROTNONE);
@@ -629,7 +629,7 @@ static inline long pmd_protnone(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _PAGE_PROTNONE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index e67e64ac6e8c..53a0c5892548 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -490,13 +490,13 @@ static inline pte_t pte_clear_soft_dirty(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE | _PAGE_RWX)) ==
 		cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_hw_valid(pte_t pte)
 {
@@ -1067,12 +1067,12 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #endif
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..36b64a24cf30 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -87,6 +87,7 @@ config PPC_BOOK3S_64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_SUPPORTS_HUGETLBFS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select HAVE_MOVE_PMD
 	select HAVE_MOVE_PUD
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d235396c4514..9eb4a9315bdf 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -71,6 +71,7 @@ config RISCV
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
+	select ARCH_HAS_PTE_PROTNONE if MMU
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_SCHED_MC if SMP
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index a1a7c6520a09..48a127323b21 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -524,10 +524,7 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 					PAGE_SIZE)
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/asm-generic/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) == _PAGE_PROT_NONE;
@@ -537,7 +534,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 /* Modify page protection bits */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ecbcbb781e40..bc5bef08454b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -151,6 +151,7 @@ config S390
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && CC_IS_CLANG
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2c6cee8241e0..97241dea5573 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -842,7 +842,7 @@ static inline int pte_same(pte_t a, pte_t b)
 	return pte_val(a) == pte_val(b);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return pte_present(pte) && !(pte_val(pte) & _PAGE_READ);
@@ -853,7 +853,7 @@ static inline int pmd_protnone(pmd_t pmd)
 	/* pmd_leaf(pmd) implies pmd_present(pmd) */
 	return pmd_leaf(pmd) && !(pmd_val(pmd) & _SEGMENT_ENTRY_READ);
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_swp_exclusive(pte_t pte)
 {
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..9da1119e8ff6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -123,6 +123,7 @@ config X86
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
+	select ARCH_HAS_PTE_PROTNONE		if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
 	select ARCH_SUPPORTS_CFI		if X86_64
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2187e9cfcefa..c7f014cbf0a9 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -985,11 +985,7 @@ static inline int pmd_present(pmd_t pmd)
 	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * These work without NUMA balancing but the kernel does not care. See the
- * comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
@@ -1001,7 +997,7 @@ static inline int pmd_protnone(pmd_t pmd)
 	return (pmd_flags(pmd) & (_PAGE_PROTNONE | _PAGE_PRESENT))
 		== _PAGE_PROTNONE;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline int pmd_none(pmd_t pmd)
 {
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..b6516a11adfa 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2052,18 +2052,26 @@ static inline int pud_trans_unstable(pud_t *pud)
 	return 0;
 }
 
-#ifndef CONFIG_NUMA_BALANCING
+#ifndef CONFIG_ARCH_HAS_PTE_PROTNONE
 /*
- * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It is
- * perfectly valid to indicate "no" in that case, which is why our default
- * implementation defaults to "always no".
+ * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It
+ * is perfectly valid to indicate "no" in that case, which is why our
+ * default implementation defaults to "always no".
  *
- * In an accessible VMA, however, pte_protnone() reliably indicates PROT_NONE
- * page protection due to NUMA hinting. NUMA hinting faults only apply in
- * accessible VMAs.
+ * In an accessible VMA, pte_protnone() reliably indicates a present
+ * PROT_NONE page protection. Today the kernel uses such PTEs for two
+ * purposes: NUMA hinting faults, and userfaultfd RWP tracking on
+ * VM_UFFD_RWP VMAs. The two are distinguished by the uffd PTE bit and
+ * the VMA flag; see include/linux/userfaultfd_k.h.
  *
- * So, to reliably identify PROT_NONE PTEs that require a NUMA hinting fault,
- * looking at the VMA accessibility is sufficient.
+ * So, to reliably identify PROT_NONE PTEs that require kernel handling,
+ * looking at the VMA accessibility (and the uffd bit on RWP VMAs) is
+ * sufficient.
+ *
+ * Architectures without CONFIG_ARCH_HAS_PTE_PROTNONE get the always-zero
+ * stubs below; PAGE_NONE references that survive to runtime fire the
+ * BUILD_BUG() fallback, since callers should have folded such paths to
+ * dead code via IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).
  */
 static inline int pte_protnone(pte_t pte)
 {
@@ -2074,7 +2082,11 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return 0;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+
+#ifndef PAGE_NONE
+#define PAGE_NONE ({ BUILD_BUG(); (pgprot_t){0}; })
+#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #endif /* CONFIG_MMU */
 
diff --git a/init/Kconfig b/init/Kconfig
index 2937c4d308ae..58abb7f19206 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -944,6 +944,13 @@ config SCHED_PROXY_EXEC
 
 endmenu
 
+#
+# For architectures that support present-but-inaccessible (PROT_NONE) page
+# table entries detectable via pte_protnone() / pmd_protnone():
+#
+config ARCH_HAS_PTE_PROTNONE
+	bool
+
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
@@ -1010,6 +1017,7 @@ config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
+	depends on ARCH_HAS_PTE_PROTNONE
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 23dc3ee09561..5e9f3a35f924 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -672,7 +672,7 @@ static void __init pte_protnone_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot_none);
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	pr_debug("Validating PTE protnone\n");
@@ -685,7 +685,7 @@ static void __init pmd_protnone_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	if (!has_transparent_hugepage())
-- 
2.51.2


