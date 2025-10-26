Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E3ECCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 04:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407B38E015A; Sun, 26 Oct 2025 00:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF2F8E0150; Sun, 26 Oct 2025 00:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C858E015A; Sun, 26 Oct 2025 00:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 181168E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 00:29:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9071C57920
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:29:12 +0000 (UTC)
X-FDA: 84038985744.13.1425EC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id AAD3720003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:29:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="o/nkpgSw";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761452950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRUgegDQFpeC7zkJ1emfzH63AQVrdrHpdCwTMeB00mU=;
	b=DgmZH1Evda66pRo6zokfxLNLUhqLp7gdM0m867LG+4ydz9HgZKXjZLnv31ru19ZU9BwmB2
	0VXre9V3OZM1MMlUEdTOW+IlrumYGIcy6kfgsfhB7Hcn+IQtaWASaCPXP6VM95KHn46Cy2
	rsN+Kg7xzNHp9GsQm1XvLTU+rWYTjjM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="o/nkpgSw";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761452950; a=rsa-sha256;
	cv=none;
	b=eBKugDI6eoPfM3xlzd4gzyepcHD5xnBTqGI+ILK6xFncal8ZMkt9C8oWKCCmt/ai9jTJso
	3bFsrnodB/bpqpmMx+CysHh9KqrNqpRexKlhfMQwkFvfe08Po1XbWsmgXZtG+UxS4Rk5Je
	tCQPJxTGp1IUQwZeWqtsCpWIFsrg2mU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7162043BF4;
	Sun, 26 Oct 2025 04:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7356C4CEE7;
	Sun, 26 Oct 2025 04:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761452949;
	bh=AWB5I8OpZEfko7+3OmwoDfmZtix5Y5s/jpuoZF/Zvuo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o/nkpgSwNZ9KH1RPAuqPgYtuL6RqncBCG4hlR/jpl2kCoaC13qE2OhX9I9EPc1Rta
	 m7Bn2jvzhpvDJuHoATQux2hbXlwSMlUCNL8sHdGLnjPTrLA+tJxSH/jDo4Brh2ydDl
	 5HTPtXil1pq3aNvU9dKG3nAVg1reA6+2Q+aQH8p0=
Date: Sat, 25 Oct 2025 21:29:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Kiryl
 Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-Id: <20251025212908.8f85fad99c4b78e528a7e324@linux-foundation.org>
In-Reply-To: <aPtpt4hYMuJnwnOO@tiehlicka>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
	<aPstDXRerYqi1O2X@tiehlicka>
	<aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
	<aPtpt4hYMuJnwnOO@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AAD3720003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: st68agszetx5te543fc84qndmmfcenco
X-HE-Tag: 1761452950-463735
X-HE-Meta: U2FsdGVkX19Jwdk6xcoyaPJuC5aYhhiDmBCLBbZlpj1hyjQamAtPbzPy1HLPRYDkyjTFFeDUgJJdwJiS0JBP1Rc9/RSrNhBZsWWvh3TIg/zslsyicBWmJ8cS03B6NkkDx828xtAm3rNSgwiKSL+aR/SOhgBmvZveJe4fR8CjuySOrwmlu6kKbKwWc/Bs9f2wXFCwZsrjAIlIII9/9EGxoOSt6aYYB1vvLDb01PWbGiGC76t6QZtzhRC6AYmHZ/xyz73KBXAJzcGXQgklcSqtwtzs3/onZHufyhxvy3xzAQcWq+mDQijeLM3a2utFvlULsAUpdNlS6QsjGVAhWUKh+qKgB/5O1WsSPVF9efyw68SZk5G/4M14jXdUF0ypcAWTLI9vjndzaIfrDCT1gYLVzW+kln2jj3SnzsjTcbTWxw+9Yg8v7CUCZrhY1eFvLk+lWX0yqX4BXH3uMYANi9IiSNATkaLGpnCNsD2p80kWB8jL7ya+UHZqiZ63wLsxvzMtYVD3F21pzIOaGLU3DJnN9qgRIAl+AtSjvxoEghY+0qZ9uC2PoPtJxNrqhj60KXR1dr/EXbqBlR+H7m+Px4weS1rYBiX+PFD6uGA6ESMo+45H8dnSwJtL92b+wzPHKw6wUQrdHemz7ZNit4gRsQ4X4zug105SetmIDu4cnRmHpBIC/1Y1JfbxCW9jM04ODAQBa93wJNfxPcWFy3+s1SOutXozr8531dmZ/RY77mPcnKl7hHhrfiB8GiSIE6GTTClbZOg8p1SKzkO52YYPSBNkXUeRmf5uLcK9K1hUQTQuF39NaRxrlZCuHV7KBHOOiSLIdX7GI6CafDT0Orn5X1z91zBI9sV6DJ1pMg06rW+wLOkN6X9nz62d68cFf3yxQOSLEMgnQyeUGwtg4HRewxLtuoEdvM8b/tljFeZBmzYuqxT23nNQx1CktQPfmY7T6Tqu6xOdHtGvkQgPNRidFQ9
 CldXRlq9
 wCd++zUytXoPts5eAm85z7c8Jd9mDQoJb/edo9kH2NHf2t1Gnv6MCzzS4h8Dlk3YpzESGDFKBM5zjg5Z4Rq7i/DX8GSN57////G0jql3y7gE3LA2tukrIi4Ldz9qxiIyH0+YJi1x8tlMAjQW6lBcJXMpohb3FusgrYYN47YS7n2BatKDOjxcTk9qc4DDLc6lJAEef1YPRXciXX6Ei8jgcHDafxLW1taYInsbInwh84xjTglz0fBpreQaGbV6wxXZjLfY6mE0gGDEFctkksF6couDda6jzzj/xSsLZRmEu7gsGrleDb/1EnJ1UVlFWvho8FByausG/UeqhtiDZApG3aBPYcwjT8F0Jds05GJd/1R/Y9W6Z6Y/AaG8S6jJM8x9lz5vqj9F5a5lN9Ug3DYZQaRhST/wpm4nN7NufT6eAJPQJgEVD/mzjilHjmiM1pZls+unRTT6EsYIEm8lVCmxFnvWjGULcG/k5kelAlKHFyyL6mSJVroylSf130Pm6/8Ar/rbrIA1RfACEifhVsgdAbLmln3HfMOsa9QgO/m8G2s/ccrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025 13:57:43 +0200 Michal Hocko <mhocko@suse.com> wrote:

> > In short, primary benefit is mostly operational: it provides a way to
> > codify preferred policy in the kernel configuration, which is versioned,
> > reviewed, and tested as part of the kernel build process, rather than
> > depending on potentially variable boot parameters.
> 
> Please expand the changelog with this explanation. Thanks!

I pasted it as below.

> > I hope possible operational benefits outweigh downsides from increasing
> > the config space. Please, let me know if this argument sounds
> > reasonable to you, I'll rephrase commit message for v2 to include this
> > reasoning.
> 
> Yes, this is exactly what I was looking for. Thank you.

Yep, super helpful.


From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: shmem/tmpfs hugepage defaults config choice
Date: Thu, 23 Oct 2025 18:12:02 +0000

Allow to override defaults for shmem and tmpfs at config time.  This is
consistent with how transparent hugepages can be configured.

Same results can be achieved with the existing
'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings in
the kernel command line, but it is more convenient to define basic
settings at config time instead of changing kernel command line later.

Defaults for shmem and tmpfs were not changed.  They are remained the same
as before: 'never' for both cases.  Options 'deny' and 'force' are omitted
intentionally since these are special values and supposed to be used for
emergencies or testing and are not expected to be permanent ones.

Primary motivation for adding config option is to enable policy
enforcement at build time.  In large-scale production environments
(Meta's for example), the kernel configuration is often maintained
centrally close to the kernel code itself and owned by the kernel
engineers, while boot parameters are managed independently (e.g.  by
provisioning systems).  In such setups, the kernel build defines the
supported and expected behavior in a single place, but there is no
reliable or uniform control over the kernel command line options.

A build-time default allows kernel integrators to enforce a predictable
hugepage policy for shmem/tmpfs on a base layer, ensuring reproducible
behavior and avoiding configuration drift caused by possible boot-time
differences.

In short, primary benefit is mostly operational: it provides a way to
codify preferred policy in the kernel configuration, which is
versioned, reviewed, and tested as part of the kernel build process,
rather than depending on potentially variable boot parameters.

Link: https://lkml.kernel.org/r/aPpv8sAa2sYgNu3L@shell.ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/shmem.c |   33 +++++++++++++++++-
 2 files changed, 122 insertions(+), 2 deletions(-)

--- a/mm/Kconfig~mm-shmem-tmpfs-hugepage-defaults-config-choice
+++ a/mm/Kconfig
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
--- a/mm/shmem.c~mm-shmem-tmpfs-hugepage-defaults-config-choice
+++ a/mm/shmem.c
@@ -570,8 +570,37 @@ static int shmem_confirm_swap(struct add
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
_


