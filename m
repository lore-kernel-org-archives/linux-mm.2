Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99135CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9594E8E0003; Thu, 13 Nov 2025 13:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931548E0002; Thu, 13 Nov 2025 13:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846E08E0003; Thu, 13 Nov 2025 13:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 74BF68E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:00:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA1D113C068
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:00:41 +0000 (UTC)
X-FDA: 84106349082.04.3F04904
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E39AB40007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:00:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uExCiw4Q;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763056840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJUvqMO8KKpU9QC47lrNV/SLCkypRymHIv2x5kPHpBc=;
	b=dsGPchtuycWMnA1LsK/H9+ihcWzpF+WO20r5RoeVpIgHOVyb/7q0JK1oDY333jwyjWoWE8
	abUl4s1oAmNeqP8CDbmP0UyF83FLygFV83ksUG598rtCcCLJU7gOBGAs3yyGZU0x5Q7IZP
	UgO+tpnp07Ba+45eo0zTooi7y3jnsc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763056840; a=rsa-sha256;
	cv=none;
	b=X1C78G/HlrgtXHFtnbJYwv6sqkYVgLVPqaQZhLvHhBPGeG1oGcAtNwcXp2VzmisVjvji9D
	+BwunytqLQhSv86h6XxoWoW+opgY9C7LPI3pYm6nedVmWfyiR/khtu9rITlhGSIznDk5S6
	hFWG4CiGbdm+3irGPZO2kFCSrWUWT7I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uExCiw4Q;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A330B43893;
	Thu, 13 Nov 2025 18:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D9CC19424;
	Thu, 13 Nov 2025 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763056838;
	bh=uQjFI98RyT8QKeb0A93WOgYdgAa+Yip/ms5kSgmOYHU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uExCiw4Q4BfDhC2P1Phi0ydeQQD/Z2M157wiQpSZqyEJAa50R2mYTfgO1od65uQFx
	 90IICsDHeF4a8g+f4/UNr7G74HP/oHaUcaJdrex8aWcyV0oabXTb0Nj2LrZQydu2qo
	 woeQYnlt8jT6xu8Z6wznHkCxbenoV9bpfXodR83o=
Date: Thu, 13 Nov 2025 10:00:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, linux-sh@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 36/283] include/uapi/linux/const.h:20:25:
 warning: conversion from 'long long unsigned int' to 'long unsigned int'
 changes value from '17179869184' to '0'
Message-Id: <20251113100036.70130321f6629ce9cc8956cf@linux-foundation.org>
In-Reply-To: <202511132024.tfRZgB5P-lkp@intel.com>
References: <202511132024.tfRZgB5P-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E39AB40007
X-Stat-Signature: nf6uyqngboeu8qwtr5qm3nayoychm5u1
X-Rspam-User: 
X-HE-Tag: 1763056839-730910
X-HE-Meta: U2FsdGVkX18UUKjJrB3TPG1l367PU3iFuvkV8XNpPnTaCNmwW0rA/mr9R7KR85n4PjcFbd+FFXpiIT1W5rnWBQH5zgxT4JwW3YiqXuhXyb3hvHCm/IvWs7bV27Nx2pbeLag/5OgRyMe5968fnjh2nwQDTXGrhkKNzqfoQf8W12rL+if72AJe4q792ki98Il7ZME9p+ewubnjvKJ+SfoDnjjzm4Wrfp5zDMZa2rK+JW7UM3Jx+vOtbuhtZ6O/QSpBGxpRDc/WF/IxmGKaTYuxIK4bz85rCDU2sIEVtybYfuYMtPEtr0eWCN2D5BCnJ0Agbb8do3sMfcKok1mHLcOg9CAlsNgQYIbDmk5HVgiQ//6RZYTi//+FXveoRY+geXhl8bRJsakvzfBXHPdWkz6HCMeN6DhEq/WlnNRBjqY9yV9GWtZ3fT/ANLTwgl/uUzAndIh3DLM6WILGbMPGlaubNgKNWKMqJMA5lZMmccxLA6YRddENsAkSTEPWw3ISd+vZVbFBKMpaO05XSkT/gVwbnCaAOS58QyStjhgBS32uVN3qbRTx26WIJL7dyovs7EydZplSckjiKK+jG0uqi23ibzxsD4Ug1Y1AEu/liN0HzTuIKNJYlZ3MWdww0Q94OyBYjV1ylnMtck5TI8FuSNgLMx75XR653c9+n2zOh/b8qvt4SnB5eLMGjrQZU47/PpBcRK9S2iwAwrBboNu8j5b78Ys5+/+K1SOcRe4npHju1Ylr0Mgkei/5PcHxrBnO7UFY4JluXVLsb3IP3SdDKWKKznCaNhatTgbRjW1z0jdbMnvYU0MEOExVNh6ndRr2j4upAogzDcmeBm7++wjkb025mziwA7pJVVnroOxxYiRTYQxnu5Ry+ipF35LakpmTCyOJRg12558FAZg8mRRQwodxTVbZq+eakNJXkblijpQXNE1pmAABCeDo2hG9WGTetcvm2okXmEQx6yiPSRzs+VS
 P05P8Zn7
 qUT6om3Jro2rIrj7l5oaGt1ynhbeHGKr0G5NI1GXIEepZGg8SfbHRzffbrfgmEHiWAD7KNjKEM/MwreOvZEvnZouHV4SWKHDTwnTrO72YI5blWuOpSNPdpBF7AS40yqfyqdr9Dm+EpTLJAXrt6tstxXhGoS3b0iSDGSm9rETf5apxqBuXh8L98hNr3zJQy0UaP8eu/mJrJ+tFITI4tAT6G7MWyvQiAiCPlwStAY1r8PXjzGW6k5aHl6aUIc5FHD3K3PDN6MDHUc94IFXCSafKz6X51V+agfqmK0qyxDsWV0GhIa+wqAEC05VedPT8SsAPhF+ywawYbr6ZllOl2aFjDRHh8rkkqn9y1KulX0tpp0rhlSP6dOgUWPSJQfiwLBjzSwzBQKQsynftQMUjCA9nJvOeSbZoeHoSnzd76fJd2A+sC0o3JaQUKS5l4CxPi/xlJaWHccgG4FYitq3BN0jBNhtOiFtZOVOeoCauwHmCpyqiUh5x2wH/gpUNrmbcBU9xIwsep+Xt9lIwH8LV+D+iVPHXwZyFLIidvx9thRkCrXEPG+UrzUYs2RYEvvVxmJwB7fSHEgw1C7OwTk7hlseoz2MNRGxZcwna0ct9cGNnWXBUK73+uLO4+VHTXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Nov 2025 20:26:42 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   f58b4cb6b0c11172a25c2ade23477f55596d7138
> commit: 2f6ff71280ffddb27ad7174d24f573e2683870cd [36/283] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
> config: sh-randconfig-002-20251113 (https://download.01.org/0day-ci/archive/20251113/202511132024.tfRZgB5P-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 11.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251113/202511132024.tfRZgB5P-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511132024.tfRZgB5P-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from arch/sh/include/asm/bug.h:112,
>                     from include/linux/bug.h:5,
>                     from include/linux/mmdebug.h:5,
>                     from include/linux/mm.h:6,
>                     from include/linux/migrate.h:5,
>                     from mm/migrate.c:16:
>    mm/internal.h: In function 'folio_set_order':
> >> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
>       20 | #define __AC(X,Y)       (X##Y)
>          |                         ^~~~~~
>    include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
>      111 |         int __ret_warn_on = !!(condition);                      \
>          |                                ^~~~~~~~~
>    mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
>      758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
>          |         ^~~~~~~~~~~~~~~
>    include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
>       21 | #define _AC(X,Y)        __AC(X,Y)
>          |                         ^~~~
>    include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
>       56 | #define SZ_16G                          _AC(0x400000000, ULL)
>          |                                         ^~~
>    include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
>     2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
>          |                                           ^~~~~~
>    mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
>      758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
>          |                                 ^~~~~~~~~~~~~~~

Oh gee.

Here's the patch: https://lkml.kernel.org/r/20251112145632.508687-1-david@kernel.org

I'll append a copy below.

For a start, you have found an sh config which sets neither
CONFIG_32BIT not CONFIG_64BIT.  Should that even be possible?

sh defconfig compiles migrate.c OK.

I think I'll just pretend I didn't see this email.  Hopefully some sh
person will hit this soon enough and will figure out how to fix it!




From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
Date: Wed, 12 Nov 2025 15:56:32 +0100

In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
runtime allocation of gigantic hugetlb folios.  In the meantime it evolved
into a generic way for the architecture to state that it supports gigantic
hugetlb folios.

In commit fae7d834c43c ("mm: add __dump_folio()") we started using
CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
have folios larger than what the buddy can handle.  In the context of that
commit, we started using MAX_FOLIO_ORDER to detect page corruptions when
dumping tail pages of folios.  Before that commit, we assumed that we
cannot have folios larger than the highest buddy order, which was
obviously wrong.

In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
when registering hstate"), we used MAX_FOLIO_ORDER to detect
inconsistencies, and in fact, we found some now.

Powerpc allows for configs that can allocate gigantic folio during boot
(not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
exceed PUD_ORDER.

To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
GiB (possible on arm64 and powerpc).  Note that on some powerpc
configurations, whether we actually have gigantic pages depends on the
setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is nothing really
problematic about setting it unconditionally: we just try to keep the
value small so we can better detect problems in __dump_folio() and
inconsistencies around the expected largest folio in the system.

Ideally, we'd have a better way to obtain the maximum hugetlb folio size
and detect ourselves whether we really end up with gigantic folios.  Let's
defer bigger changes and fix the warnings first.

While at it, handle gigantic DAX folios more clearly: DAX can only end up
creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases clearer. 
In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with HUGETLB_PAGE.

Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
also allow for runtime allocations of folios in some more powerpc configs.
I don't think this is a problem, but if it is we could handle it through
__HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.

While __dump_page()/__dump_folio was also problematic (not handling
dumping of tail pages of such gigantic folios correctly), it doesn't
relevant critical enough to mark it as a fix.

Link: https://lkml.kernel.org/r/20251112145632.508687-1-david@kernel.org
Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 include/linux/mm.h   |   12 +++++++++---
 mm/Kconfig           |    7 +++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

--- a/arch/powerpc/Kconfig~mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/arch/powerpc/Kconfig
@@ -137,6 +137,7 @@ config PPC
 	select ARCH_HAS_DMA_OPS			if PPC64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
--- a/include/linux/mm.h~mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/include/linux/mm.h
@@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pag
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
+#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
 /*
  * We don't expect any folios that exceed buddy sizes (and consequently
  * memory sections).
@@ -2087,10 +2087,16 @@ static inline unsigned long folio_nr_pag
  * pages are guaranteed to be contiguous.
  */
 #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#else
+#elif defined(CONFIG_HUGETLB_PAGE)
 /*
  * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (e.g., hugetlb, dax).
+ * currently expect: with hugetlb, we expect no folios larger than 16 GiB.
+ */
+#define MAX_FOLIO_ORDER		get_order(SZ_16G)
+#else
+/*
+ * Without hugetlb, gigantic folios that are bigger than a single PUD are
+ * currently impossible.
  */
 #define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
--- a/mm/Kconfig~mm-fix-max_folio_order-on-powerpc-configs-with-hugetlb
+++ a/mm/Kconfig
@@ -908,6 +908,13 @@ config PAGE_MAPCOUNT
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
+#
+# We can end up creating gigantic folio.
+#
+config HAVE_GIGANTIC_FOLIOS
+	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
+		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n
_


