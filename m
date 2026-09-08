Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79254C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881A06B0096; Tue,  8 Sep 2026 11:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832226B0098; Tue,  8 Sep 2026 11:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720A36B0099; Tue,  8 Sep 2026 11:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E777D6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:56:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7664716067E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:56:56 +0000 (UTC)
X-FDA: 85191048432.30.872B36E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E01E92000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:56:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GnNqH/UQ";
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tcijen+XrkE1sKKJX8CkIKKooxVBnQd0uzlIx9kSVSA=;
	b=n4Lrwv0H72A0inLdgq1/Wmyg/QaguETRu+YAVwzM39xHwb+e3e+rlm9CnqALAA24oG2gCV
	ZVHNwINtrktVrnE7/9RbfPIp2DOp2X+qPX5DswcScVGzrlaVtnU153mzqXxiPHVD8AxKJZ
	KQ2VgfTOPdNfT3F8yAWJkmpftbWoRQU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883014;
	b=QiRrG0d342OH/tBtSFWtPEd6Kko8VPylc9FkVmrgKCuauiRoPrSISoMkWxtteDNh5tzb8Z
	a58Cqc6eeRgjM4PpztrQ02qAWKeWT32kZN8hG3ji4vSZa0AmGR7xud8KN7zZOh173zMZQk
	vvLLghWstfRd7ClZ781JH9DoXFRGbB8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GnNqH/UQ";
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85FD3601FF;
	Tue,  8 Sep 2026 15:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457E61F00A3E;
	Tue,  8 Sep 2026 15:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788883014;
	bh=Tcijen+XrkE1sKKJX8CkIKKooxVBnQd0uzlIx9kSVSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnNqH/UQFVYnXra3IOHQ/cSX+xcE9Gtflza4237iNzbU/emeQIcdFaFSEbmxT34Ah
	 7Mc7hfUaC0iEvJlhSwl7XOxg60TDmRvikCOiTgwVLAM5VImOq6qIMbukd03QYVSwPJ
	 PmgeFd9GIF66wvENo0/46QR8MbGs6TlXSePQaUiBaf5EWrtEPtoE0/zKps9Qb9G8J8
	 ex8McOjWWn7qQoI5U6se5codMlXNQ6NR7YEHTlNmH6C+qYSrLgXUwdbSFeZXIO8Hu2
	 0YL9+81ECY8oWT45na2qdN4jrVvWW+FObaNB764wG4B/ajp8jvv5E8PgAPd0efZBVB
	 xPDJ103/UfgbA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH v2 1/4] memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
Date: Tue,  8 Sep 2026 17:56:35 +0200
Message-ID: <20260908155639.2496551-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
In-Reply-To: <20260908155639.2496551-1-pratyush@kernel.org>
References: <20260908155639.2496551-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E01E92000C
X-Stat-Signature: ts1wg78etkmi3393juhj61rkxngo8c8c
X-Rspam-User: 
X-HE-Tag: 1788883014-795626
X-HE-Meta: U2FsdGVkX18SE5W0sYXwTet6eSs/QgFMPn9QSZT/Bq6Bufu4CkOaJdBEaTwZh9Y4T1Y9xcgPTifdpBmP7QvmmI/4Gc+k+Qjb24ggva8wERhwOsfY2rnMjM5yz4LgUalP9wZfTYmHU4LYk9ytsBy8EGhS0xsFe75C4Vxw7iA3DhYnhBqscityuYwjm+OMDamGx2s5h5Pr61K9SHANCG2686Do4mXxY5BDiLAiN7tXpP/IM0jzZs9OEzXU8aEC78ckaNsEJhFPnVyhDK4cPrCtxWe8/Jfqu3SgP7SJZGcYuV4SAPHMsEsgtdih/EKtpp/bcddETc5y51AfvTz5XsIRS73sXeA5qHsJbaKjJ/Jg2uVWKzTAFoA2KjB60Qi5c4oEaFziMtt6BxOEobdaAauwaA+eSFYUgciNtq8S9eG0pd46t1a0nkAuNDwBXhmtBwGEB1nrNzi/nOIXy6iLKDOrRTnEw8L7WYFUNBMM1cyNjq/wIiKjMiGE7TCPJyuBFzTaQwrvIq8tmIY+PDuXrdj1SuD2fe58zIj763+kP+ZLFaE2LYdc+aHNpLS5K+Nob3AaUT8e9Uv0NUNwNuUIOgiLYQwntqNuZpHSevW2aNCQvpFYk8MUyxfq+3SQIqxuVlamc1C9phtDoJm4sqxhxkK/i6VI4aZCtfsnmc+/+W8K4NCAenFTuSWJ6RqWKRovuavXbG3Hs5USb6fxE/359GPNPtZAt4E+mTgD59+K5MQ6Bplio//Dg4Hyt2nei53w+6rRGgrQkg3vpTJFNBmIVvL4nzsQ0BvnsqvLAk9/jTIW2FBLHxSP0xl2qy1/18y0CXzEhcooq1LrsOL8nToJIYlutHDqIFzs0Pjtfjjn8xGwl5rr2Bx02fbryyI6xGTZ8btDRz4lRIgDccmgG4eOKdYC0ij1htpi4pX/EzwpP/NYxn6pgL0gYvFKrBZlmEiypiXY8wajicLCxjWahEtJ3T5
 PtaRHqM5
 zvaZtlKtFSSW3Zfdod9CfVaxMpnoXeBbYZSVq3iI02voM9yq4n8ErEHw3xsyDzPamyMRu5ebJBR1n4ENkExRRTbiHaQMC9lL6UVEeFuheNqTNxGRJtR1XcJX0dj52PFj9YOkGkmnaMm+62qZ9qbzfxAoutgV70OJFrBcFYCdG4RTJ4RQ30+3tlpI8cptMhMhP3Wm1Lmywd6iwF10YC9PF9ZyilPPe5omoGoAeeQ3gQjpCh+j/EkSzgdpu7mC20iHy41e8OX3iDqGSDOL1ZTQ1KlU/vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

This config is only a proxy for CONFIG_KEXEC_HANDOVER. It is only
enabled by KHO. No point in the indirection. Use CONFIG_KEXEC_HANDOVER
directly.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h  | 2 +-
 kernel/liveupdate/Kconfig | 1 -
 mm/Kconfig                | 4 ----
 mm/memblock.c             | 4 ++--
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d62db9e776cf..db3b106c6335 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -614,7 +614,7 @@ static inline void early_memtest(phys_addr_t start, phys_addr_t end) { }
 static inline void memtest_report_meminfo(struct seq_file *m) { }
 #endif
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
 #else
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index c13af38ba23a..f50daee8eff0 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -5,7 +5,6 @@ menu "Live Update and Kexec HandOver"
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
-	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select LIBFDT
 	select CMA
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..631a410eaee9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -483,10 +483,6 @@ config HAVE_GUP_FAST
 	depends on MMU
 	bool
 
-# Enable memblock support for scratch memory which is needed for kexec handover
-config MEMBLOCK_KHO_SCRATCH
-	bool
-
 # Don't discard allocated memory used to track "memory" and "reserved" memblocks
 # after early boot, so it can still be used to test for validity of memory.
 # Also, memblocks are updated with memory hot(un)plug.
diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..197d854c18d5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -113,7 +113,7 @@ unsigned long min_low_pfn;
 unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 /* When set to true, only allocate from MEMBLOCK_KHO_SCRATCH ranges */
 static bool kho_scratch_only;
 #else
@@ -2596,7 +2596,7 @@ int reserve_mem_release_by_name(const char *name)
 	return 1;
 }
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 __init void memblock_set_kho_scratch_only(void)
 {
 	kho_scratch_only = true;
-- 
2.55.0.979.g7e5102b832-goog


