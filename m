Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D64AC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812D76B0088; Tue, 11 Aug 2026 12:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA6B6B00A2; Tue, 11 Aug 2026 12:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727736B00A3; Tue, 11 Aug 2026 12:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59B426B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:27:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E81ACA0064
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:27:03 +0000 (UTC)
X-FDA: 85089517926.30.A32C42B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26BF6140016
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:27:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WB6oAKSj;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465622;
	b=FBR7KgKf1Ns8z1aD5YkHrAeeLr5+m2aJTwHQL9ARuaNJAbhD/QMqLp9lsb2wo147dt1x1p
	DqnnuKjl0jqbhzc3SQFBu5qyyjAVFcewZnQ67Q0vixcmfkfC3J7bRTZA8EbfNSgzWJuAqy
	IdV6l81dUx3TPlppbEXnIhpXmt6DYEQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WB6oAKSj;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCTSbjH+AbQqxolqBee1+aQwt0omi5VUnJSkZiGnZF8=;
	b=YkZtlTbJ/6qtaiKIWcyGQ3bGGuPmBHLQ5SvL+RMCwqHPOfZFBix8nsc3DqOdtJACdkKiv/
	hZjf6sa2lou6kwXBKz7uoJ6gsMkCJY52C/Ba+4RVmBxOJjo9Y/3RRa4mmDpzEN+Q95osL2
	R0WUq1WMFwbEuFFHoktHG4e8+D2wYV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 614CD43F95;
	Tue, 11 Aug 2026 16:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306711F00A3F;
	Tue, 11 Aug 2026 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465621;
	bh=cCTSbjH+AbQqxolqBee1+aQwt0omi5VUnJSkZiGnZF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WB6oAKSjESjeGTBWIaFg2Vz80ThcWdcNc2PPEL6VBsod2UdMjfrko6q/E0sjykUte
	 6mD7MLWnhAzolIHI2EbfKgajXhMSmsgDGKMmBRj88tvW+HM+cdnIOs62Pn7/DR2TOe
	 Nb0ECAbcH6l9mJhl3ShiWdATBjF2TyWlC7CWORVjG7Ha4BNLkjmPTwUea0YDbx1vHG
	 useowan7Pb0zS0OkHo1eI+YGo9ig9bp1J2XQYhBM1D3OQTiMjCG94Y9tzAMZdtwH1B
	 FOxdzs6svGvf7QDDWxH10dF9KyiZ/qcp2LdSdfbCPX4RKhk4wcGc6be/CyndAfnZXO
	 JD4H3Pot+cLjA==
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
Subject: [PATCH 1/4] memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
Date: Tue, 11 Aug 2026 18:26:37 +0200
Message-ID: <20260811162642.3504565-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <20260811162642.3504565-1-pratyush@kernel.org>
References: <20260811162642.3504565-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26BF6140016
X-Rspam-User: 
X-Stat-Signature: dsnh8m351gmoaq7rc6ti4o3epqp6akmr
X-Rspamd-Server: rspam06
X-HE-Tag: 1786465621-997476
X-HE-Meta: U2FsdGVkX18YU+HWYiHnoenvJyhIhQaZnQZOIl7J9ROGO5WDLFfB5QNiu0qYIV9vQ/HozlcF+VlqPbOkiiixGSmSdfWVAHBoYtHpt8FQnOP9kvnc2wUYNh7RpzxeaGlabl9nVMVTSdMoBVjHDpenugDW+ABy6qY/6HAnor1ocpm3mLkkJejibfUUFLmTD5eHEKrphMr7GJAWSizTHItvDDZiKp4gFtATN8kOylD/oktL7SgV9RdYUzq3F24K8ouz2vicxr+vbV9h/7ONUEPPiialS2b9A8CUYJxLlWio2LZPKWZUBwfUQ3aO+TZOdEV4+525Tdlov/uwoPB00H8oaGoY1zbGPbGNd0E0saaHUVjczaQ8cwW7zns9S0mEg1SCGscyfRQASsT2jZeiQRbRbdKag+dbbZ5xo4z8Y73I4dr8X4mEHA98tCj8JTLX73xYiO7qwuef1RsHXc4YuXVJzuU9IQnhwIJdvYNMryJ6aiThSeqzldsAcCAEQjDWuLOUiKqAyrmRBehD281ugAsroQFdPrcqqe6gvLXQYs8srS0qzOXlfulmRFJ9ne4WQhtUKHjS2SDum7+mbZ1qYInMvhktVDaCwdXm4quC4yJv7ZazoCwWQl2AU30sRGsNw9P2On08b2W3Tunya1VoDV1SYwYCnJfMoVoDgpRDi8QlEAuWGa5HHPkNEeW9oqe65YHP85gIf0wDptYazsBxYNlJZa4+wb2k6ImGA0iE5ZUwEdsmzYU/5KfLPLkMYRS33zEEq5OeWb8ReBZUIM1NZNQ8idJcUH6cayDFrLNtX4eUD3c5uCrRL4wt2MGBstw/+IDCYO58yzbVIQziYoGEFgRNHmi6zd/4re7cbyeaEWer4FeIS43CVJZ4h6xl1G8o11W68zN/a4IU9UGm1P0FT2MFMvOx1kQSwgdHwXaIsWppHFandbvV8H+TZM6gRDJhTBi47XNavo14bvQRDHT6GB4
 zt11LO4H
 q1+MVHg4F0u+ledwmfLPaQbReU19hQ4kkeP1TWQ0N9dij4+WcMHlkpDh6bNnOoNm1ktqUWPXQbmNhy5i49sNrrTSZ9r9W3bwSCfrnh1vNkECbbCpkP3S9st9n4zilmamPQfn+vEoRtZZHGNww3Ki1qvG1BzqDRSiTdMFl49zmNhLoBHm5hQSOVo3qagc2QXMELnClHeD+NU+GEMaI2EzuaduUIcXqRWn5O8BmPTmvFd1ghZ88NLY6VK2VX551aD5OC4n/x3c4VXuiX1r/ZB7ex7g68BpYDq4RMCVN
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
index 9e0ca4824905..5415e0b38b5d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -485,10 +485,6 @@ config HAVE_GUP_FAST
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
index 37e06e70c1d0..8e425791ad66 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -112,7 +112,7 @@ unsigned long min_low_pfn;
 unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 /* When set to true, only allocate from MEMBLOCK_KHO_SCRATCH ranges */
 static bool kho_scratch_only;
 #else
@@ -2597,7 +2597,7 @@ int reserve_mem_release_by_name(const char *name)
 	return 1;
 }
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 __init void memblock_set_kho_scratch_only(void)
 {
 	kho_scratch_only = true;
-- 
2.55.0.679.g6767b8d81c-goog


