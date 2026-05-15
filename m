Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E77CD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A596B0005; Thu, 14 May 2026 20:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BC16B0088; Thu, 14 May 2026 20:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20EA6B008A; Thu, 14 May 2026 20:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90D386B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:29:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17E0D4038C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:29:49 +0000 (UTC)
X-FDA: 84767771298.14.63E5F66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5661C14000F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:29:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MVYp41fA;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778804987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cl60sidZaQSUzrQd2OgbJjeNgfP92+keuL+EjJ4HTPM=;
	b=IFnudNP0bPg+Fu8Z92OwDsJPC27I9U1ahEIherS8/FC7m2I7PY7g8d0Dc4Q+92XAu0+TWU
	50WgQUjLTKuEkjHXfTZSCAb0IZgEGpR52OvHfPeKgn0MXtNNmI1wOdGhMy41kxtD5svF8y
	tevs02sw0TpCi3K5bKCMNofVpllddmM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MVYp41fA;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778804987; a=rsa-sha256;
	cv=none;
	b=Shw5wwZlxp9UpRs3kdtCAlkRN2O01vrKcthpeRi/sYk4gFubYCArx1crEAJGlUhN5fxamz
	3q0Bs0HwuzlRyI6uaf8kC4Oy0+ahZjJ64ZpnXFdSc/fhXfxA0sHaJF/7KxJLlQCZMhOYKP
	83N+q0pWBgvUwhfM/OWUhFTPnRxPpr4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 024A843B33;
	Fri, 15 May 2026 00:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824BCC2BCB3;
	Fri, 15 May 2026 00:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778804985;
	bh=WbNqRyYAf+hkaZF5dLnG9kBdPrq6Jxs4l7qPgnpKjmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVYp41fAvhbcH6lzP0iL6HNSyElsHkR/Q+lCcK30GKR9H+vj/MFLMhVAd1v3csNBH
	 kCRRLysqV5YMJFMOV6lswhv3RvvBpMfR2bkseMs7x1fgO80AOzV7wFLKTSA3jxdTG7
	 4zuPMR9SAUtFtCXPf5J6eezX1IAiSYrGOKubXJhq23H6MzYOcCZNlpFyZEyFR9HoKP
	 SAFAOfpvqHOAVV5BcpOkfaMeaiZGEvbuoDtViEk8oIkwPs+H3BHTg7rUVyKBjchDro
	 vUntATzUUqvhc7aImuP5dFv32fo4BeHGidQoMpsgDOJmfeL1HQEENTFp7xigaOgRd5
	 16CGzJTwhE2yg==
From: SeongJae Park <sj@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
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
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 04/14] mm: add VM_UFFD_RWP VMA flag
Date: Thu, 14 May 2026 17:29:31 -0700
Message-ID: <20260515002932.124892-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b47d8d5681fd8730f6090ebfdb72f219a8edef1e.1778254670.git.kas@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5661C14000F
X-Rspam-User: 
X-Stat-Signature: 6abroqr6xkmgdmgwuqxj7hsr4oijr57a
X-HE-Tag: 1778804987-397770
X-HE-Meta: U2FsdGVkX1/YsiWgU5q/Ad81qkaWd52fcpUwPIJu22rJ+hCrVyR2Ubc7ZFNYHqXx5l2VYm4rWSfjUN/eyKzF/ad7lis2l0pybTfI+C0WDuSh5pFtp1gAaNgxLCXja9dL3+dn8ofD7ZKbzOjd0nqyo7yzIw7M/C0Y7Ax8J8vzlGz8MN/bYwzPZFL44o8YhydtDHscoFwLBK5P6ZDEG78P5QP6CnsvoRfctk8xbC+IVDXAGfbFJzPJcR3wZuCHVfIUKnm4sYVpDMGjti0gWIhN2FfsX4KDOFf44JXvwhMTsdOeGyoqxF87+MmCXYx4dwaJHG9m6EEp1DWpLXgtrYvJQMd2CDlKk5INUtyyp/O0gCY+Sxs6BxTcsME/kgknRXJR1TAHys08Btm+a4JEDAEcbp5ZtxEbwYnGiWiDNte4N6uMjFfH5WLGmekCkJHuBYAT5uZcO6ItylTIqki4bemyhUeQvgw08QntRWT5TWwWexSLthIStWdSkYGrdcaWvpMeL8LQX4eIc/kms5OS1iQHFzCxihuCUm1/ds//rB23nyJ3Yeg+QM2CoTqAWBnWnei1bTw2hdJFG3flp6NMKrP6j7qRvrMPH+cxoxadOKxyxDEtRtNvQGjUVF0UZ5KAAZYs4itZ5d/XKJPjWbAOZEq67lMaRqDVIklRrHOY6WfQevdRewgVkD/cS/g/oKnUZYaVCfXDAHR9q3n8j8p1We1Y89LER+y9Q+8e0tGrkbPvWU4YhHGrWZHmoDif0hh9YCNjcpnyzn/0EwSbhnCYpuIeMcR8ghX8qmQHhchL+N1JvhxSt762niq8n3ktPV3irZR+pS+ObPHcAvx3dDD3DD0V9HeipPiya4cuLiBJXbtvvRuVTb19nu4CS9QBCtQR5IDSpmVVj+Mux5Rip40mUZ6SmSwz1+hd+Fh3Mj5wm7qXDHDlS3zH83TOB0+rFfwK61pCEK+Azb9L0oaMCjqMcqb
 pabCt7BX
 x1N3BIbbZoj3kXMqWBxLSg644t/xgUVLTOejALsmOsHiZjtYLZ6jho4QEgRPSGmRSm47Dk0aKqPyFeb0oboLWMLN1L9I3l48d+3x3XTbxuGoxThAm4i+uU7Cdz8E1/ZW1RKmoeICIEZj7REXSQbnmVirmjUCYUGg6vw4lW/4fE+BFpswWFal8d1bU8wU+TDQ3pCLslgGrqeivZh+Zvb9qALRKJ7di2XIMajQvMJ9RH66ay6xY1TRAtcXDm4GqBx3kLzYq7bqvdL9M+9DJ8TxxPyqN0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  8 May 2026 16:55:16 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> Preparatory patch for userfaultfd read-write protection (RWP). RWP
> extends userfaultfd protection from plain write-protection (WP) to
> full read-write protection: accesses to an RWP-protected range --
> reads as well as writes -- trap through userfaultfd.
> 
> RWP marks ranges by combining PAGE_NONE with the uffd PTE bit, so
> the flag is only meaningful when both primitives exist. A new
> CONFIG_USERFAULTFD_RWP Kconfig symbol auto-selects when CONFIG_64BIT,
> CONFIG_ARCH_HAS_PTE_PROTNONE, and CONFIG_HAVE_ARCH_USERFAULTFD_WP
> are all set; call sites that gate on the flag depend on the symbol.
> Elsewhere VM_UFFD_RWP aliases VM_NONE and every downstream check
> folds to dead code.
> 
> Nothing sets the flag yet.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

A silly but loud thought.  Would it make more sense to put Signed-off-by: after
Assisted-by: ?

> ---
>  Documentation/filesystems/proc.rst |  1 +
>  fs/proc/task_mmu.c                 |  3 +++
>  include/linux/mm.h                 | 28 +++++++++++++++++----------
>  include/linux/userfaultfd_k.h      | 31 +++++++++++++++++++++++++-----
>  include/trace/events/mmflags.h     |  7 +++++++
>  mm/Kconfig                         |  9 +++++++++
>  6 files changed, 64 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index db6167befb7b..db28207c5290 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -607,6 +607,7 @@ encoded manner. The codes are the following:
>      um    userfaultfd missing tracking
>      uw    userfaultfd wr-protect tracking
>      ui    userfaultfd minor fault
> +    ur    userfaultfd read-write-protect tracking

Yet another silly but loud thought.  My first feeling on this was that this
reads like 'u'serfaultfd 'r'ead-protect.  And was further thinking 'uf' for
just 'u'seffaultfd 'f'ault or 'up' for 'u'serfault-'p'rotect might make sense.
But ended up thinking this is too trivial and ain't really matter.

[...]
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e8bf1e9e6ad9..ccf534a8cbc9 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1347,6 +1347,15 @@ config HAVE_ARCH_USERFAULTFD_MINOR
>  	help
>  	  Arch has userfaultfd minor fault support
>  
> +config USERFAULTFD_RWP
> +	def_bool y
> +	depends on 64BIT && ARCH_HAS_PTE_PROTNONE && HAVE_ARCH_USERFAULTFD_WP
> +	help
> +	  Userfaultfd read-write protection (UFFDIO_RWPROTECT) delivers a

Seems UFFDIO_RWPROTECT will be introduced later.  Would it make more sense to
add this config together with the patch?

> +	  userfaultfd notification on every access -- read or write -- to a
> +	  protected range, letting userspace observe the working set of a
> +	  process.
> +
>  menuconfig USERFAULTFD
>  	bool "Enable userfaultfd() system call"
>  	depends on MMU
> -- 
> 2.51.2
> 
> 

None of my comments is a blocker.

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

