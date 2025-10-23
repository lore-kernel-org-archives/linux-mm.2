Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B933CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 18:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB3A8E0008; Thu, 23 Oct 2025 14:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2CF8E0007; Thu, 23 Oct 2025 14:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C84F8E0008; Thu, 23 Oct 2025 14:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18CE18E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:12:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE5CA5CFC2
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:12:09 +0000 (UTC)
X-FDA: 84030173178.20.9A6CEBE
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id CD680140014
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:12:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=uoEujvRB;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761243128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5AD43heSxDjkMJBae7Mjv+mqYMFtNUo5qUGqikj6aF0=;
	b=lACP8vm78XJL3U5N70ffUvnv+dslQrfeIx+H3AYptEcKkCNuFlIXj3D7xl8NAICCY+3B21
	+FZbbkWG0lCqS0ecE+IsncuOn/M4TvD5udct/d99iYN+tjg+cmUOEs4CWAtQUfy9w6Hu4e
	FDAELIjXKueznzNXlIkpGPGKUetTA7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761243128; a=rsa-sha256;
	cv=none;
	b=xiNbkesgYLhKT6L+NMFcSI1f4r2L11D9LNZUJceO8NqmW4M/UZPrnYDB4AsyhWFXKhlRxw
	eSK3+GgaXSLj7ZZxUdEUUCq//kKFix9iRi4Kz/9x2V1xMJlvElp7jnloXCVNxWPyODF74k
	UpXqYebuqoDNtjB8hNrfW7Lx1/F6If0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=uoEujvRB;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 408F09AE3B;
	Thu, 23 Oct 2025 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1761243126;
	bh=5AD43heSxDjkMJBae7Mjv+mqYMFtNUo5qUGqikj6aF0=;
	h=Date:From:To:Cc:Subject;
	b=uoEujvRBgupb2RFCiqFr716ZQ851q/QBQ4vK17vtvfbtB1B1/8V0JdA7PBK0IK+aC
	 xkobpBnCvgYOwDasFsVuzpkOoiF4fXb0ZgB8YUFzX9NslctvZ9E6dtWzfatnj74Swq
	 m72+mprT08dznyBPzBTtPPUi16dRH3/r0257ssKg=
Date: Thu, 23 Oct 2025 18:12:02 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Stat-Signature: zup8xe65zyrgshg61jgq4rqz6ztsrp31
X-Rspam-User: 
X-Rspamd-Queue-Id: CD680140014
X-HE-Tag: 1761243127-670819
X-HE-Meta: U2FsdGVkX19jSOC2ypkrNbUR3SUZQlEd9lgK5uoPHfCAuNRLRTrjCi3ZM3yf8BZbNAEGsf/cDoFExr2UiHsKHdGB4bqFfG3Nozr8OuIuXwmxrduMg66gfT9xwl3PObdke/DM0M+Q2ZrLQRS8To12HQgOfZDfGkf48NNYujz8UySle/gQNbqltND1EZ0jHdxIb6LhUK5gpQ9RzrWEiyre5Osow0YgyXDi4V1ECHuHOhsgbrMRuBuqvbHL1RjWMYLfEFvYhNQWPT7qPMUfMFXcSOO9BqBKrfl0SGjO6w4Dn4zeI5epGJHjnfY9qUmqXLQAQFiW5Hbvglf8n30Znzq2qIiIUrf7BlNA+tZzUc9IJnheWDb9wrGehz4gV6Lcrf1DBSp5TUzYHA42S27OpjBgCaMtGt/C8O/rmT53wsR6TobRkX/Sb+vkDGwSeJVaLLNnl+xp2jiO/9ha1MPcA/SuLrDXz0QZj6RyqjH5xW7O725uEZzArT6LFDfW0D+rrpLoLHiiGQSAmeNakW1o53NcfooW1nEBnON82hN8x9muo4oY7d5fGbjsf9c//LsI2jEj8NLfYkjwqWfVafG2TFUiEY2SMuCmQedcKJAGoQNvgCqer6sBvFw8bjCJiHRTpCYsYugJaap5KVjFAJ8DxZ6HKN0DXjmjl0SHe1FPiFSt3lbxRQP3zbqCGenqBR37qYP2PUcJaIsuAum4p9pH/tvDQTlWkgr+N8zYFe+PmSBw5ojYAFkLU4IyM/bGGjtnVrwSsnBVn4N4vbw20qJs6tdIiz5/ybAOrstX84SFhcLPfBOHOcDtsH38i1f5d9dPfLCJ62nsLYvKhOn+Lk7E0KtnIXeVzrKr49vmSmK3Zpln8U2hvDZkzkiP1jkT8PeYt1mJJNeHwUZHmi57hdyHAZssrqLedJ2D3UwEQLYnze1HRQucXejQDINLfdloNr8kKtgOWggskNB+kgjc9BWqxRm
 4b7BiWum
 hN8TFZPDCXhAJmGStCrjcnvpIR3mM0h9f2zcr/cnaQU3Sx+klSK8lgPC+xi+aVyA0EXwntc1AkjweLsGgNjh6+RV+ApdI9o80SdUmsgfTOWW2f52o8CpJi0p2aRKyiJO3ZWOpWw63iQOWGlGVTDQha/OcxS0pBlswB8QuZaUsTEN9gO2bGGFrmtcVfO+fZWkh6otJtleCrOK/Xr35nppL4npEON8+Qz9lROONpHYszSSzofq0WypsgucYhHv8Gyd8a9il6KrkUp6TamYK9kMVtL/hDP+jXe/QirSv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow to override defaults for shemem and tmpfs at config time. This is
consistent with how transparent hugepages can be configured.

Same results can be achieved with the existing
'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
in the kernel command line, but it is more convenient to define basic
settings at config time instead of changing kernel command line later.

Defaults for shmem and tmpfs were not changed. They are remained the
same as before: 'never' for both cases. Options 'deny' and 'force' are
omitted intentionally since these are special values and supposed to be
used for emergencies or testing and are not expected to be permanent
ones.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/Kconfig | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/shmem.c | 33 ++++++++++++++++++--
 2 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index e47321051d76..5ceea38edbe1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -853,6 +853,97 @@ choice
 	  enabled at runtime via sysfs.
 endchoice
 
+choice
+	prompt "Shmem hugepage allocation defaults"
+	depends on TRANSPARENT_HUGEPAGE
+	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
+	help
+	  Selects the hugepage allocation policy defaults for
+	  the internal shmem mount.
+
+	  The selection made here can be overridden by using the kernel
+	  command line 'transparent_hugepage_shmem=' option.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
+		bool "never"
+	help
+	  Disable hugepage allocation for shmem mount by default. It can
+	  still be enabled with the kernel command line
+	  'transparent_hugepage_shmem=' option or at runtime via sysfs
+	  knob. Note that madvise(MADV_COLLAPSE) can still cause
+	  transparent huge pages to be obtained even if this mode is
+	  specified.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS
+		bool "always"
+	help
+	  Always attempt to allocate hugepage for shmem mount, can
+	  increase the memory footprint of applications without a
+	  guaranteed benefit but it will work automatically for all
+	  applications.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE
+		bool "within_size"
+	help
+	  Enable hugepage allocation for shmem mount if the allocation
+	  will be fully within the i_size. This configuration also takes
+	  into account any madvise(MADV_HUGEPAGE) hints that may be
+	  provided by the applications.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE
+		bool "advise"
+	help
+	  Enable hugepage allocation for the shmem mount exclusively when
+	  applications supply the madvise(MADV_HUGEPAGE) hint.
+	  This ensures that hugepages are used only in response to explicit
+	  requests from applications.
+endchoice
+
+choice
+	prompt "Tmpfs hugepage allocation defaults"
+	depends on TRANSPARENT_HUGEPAGE
+	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
+	help
+	  Selects the hugepage allocation policy defaults for
+	  the tmpfs mount.
+
+	  The selection made here can be overridden by using the kernel
+	  command line 'transparent_hugepage_tmpfs=' option.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
+		bool "never"
+	help
+	  Disable hugepage allocation for tmpfs mount by default. It can
+	  still be enabled with the kernel command line
+	  'transparent_hugepage_tmpfs=' option. Note that
+	  madvise(MADV_COLLAPSE) can still cause transparent huge pages
+	  to be obtained even if this mode is specified.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS
+		bool "always"
+	help
+	  Always attempt to allocate hugepage for tmpfs mount, can
+	  increase the memory footprint of applications without a
+	  guaranteed benefit but it will work automatically for all
+	  applications.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE
+		bool "within_size"
+	help
+	  Enable hugepage allocation for tmpfs mount if the allocation
+	  will be fully within the i_size. This configuration also takes
+	  into account any madvise(MADV_HUGEPAGE) hints that may be
+	  provided by the applications.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE
+		bool "advise"
+	help
+	  Enable hugepage allocation for the tmpfs mount exclusively when
+	  applications supply the madvise(MADV_HUGEPAGE) hint.
+	  This ensures that hugepages are used only in response to explicit
+	  requests from applications.
+endchoice
+
 config THP_SWAP
 	def_bool y
 	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
diff --git a/mm/shmem.c b/mm/shmem.c
index eb8161136a7f..a411d7fb6e5a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -570,8 +570,37 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* ifdef here to avoid bloating shmem.o when not necessary */
 
-static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
-static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_ALWAYS
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_WITHIN_SIZE
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_ADVISE
+#else
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#endif
+
+static int shmem_huge __read_mostly = SHMEM_HUGE_DEFAULT;
+
+#undef SHMEM_HUGE_DEFAULT
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_ALWAYS
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_WITHIN_SIZE
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_ADVISE
+#else
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#endif
+
+static int tmpfs_huge __read_mostly = TMPFS_HUGE_DEFAULT;
+
+#undef TMPFS_HUGE_DEFAULT
 
 static unsigned int shmem_get_orders_within_size(struct inode *inode,
 		unsigned long within_size_orders, pgoff_t index,
-- 
2.47.3


