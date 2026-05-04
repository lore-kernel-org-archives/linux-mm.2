Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B671FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 07:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493246B0005; Mon,  4 May 2026 03:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443A06B008A; Mon,  4 May 2026 03:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A546B008C; Mon,  4 May 2026 03:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 256F06B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:48:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1B4DA02CF
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:48:56 +0000 (UTC)
X-FDA: 84728961072.14.47335B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C13A40010
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:48:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdrspOkK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777880935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6cfewTo+i6gmiGJ1mvBZsv3mUjPocnI8DVGUlf3oSM=;
	b=zFUbDbudLYQDB9neNxBcVweUUDsVb79f7h6Af9PlEIq8EYneEXr6yvQ/yIplNVhLLvAVvY
	MQ/kO+EDYXR2/Ov4OEHcJh+apzW/RMzRwWWHfLmerUgqp+Jtyv5iU1YfWKdvFolgUgx530
	3DEPXJrcnWyZx3erDAQMi5AnhbI5jYI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777880935; a=rsa-sha256;
	cv=none;
	b=ipHZ74yH/RMbzxfHrhTdlwXgrh1RLG0LsgYQAmwyYcud3Ce/Bxrmxl9JqCP9uvUDzkOA60
	4+u5m1pnKGD6D1ktPoGxB9wu17ppkbmyLPQ9IctEqIw3xUt7DpiuAYCFBhagHKiiJERztA
	HVbt1asK0WqHaY86qB7xgzsvJC8ifAY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdrspOkK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7307660125;
	Mon,  4 May 2026 07:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF6EC2BCB8;
	Mon,  4 May 2026 07:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777880934;
	bh=hvT42DeLxt0G1flXefxTAisAOAsIFUCaS+f6nn9KqVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TdrspOkKI/X8T3QdrKzyX8KNipEz9X3bOSmaWdacC5A1e017WryZgJC9Z4MD+4VhD
	 066QFiGfp6MoC0ZlBy9OeqKoQrG0Zt2vWMiZxQI1zdJSEjCdAx0R1MspDyjrW0iJ78
	 QE0WmKsnN5Gv6gf0oOns5WDSRRV6LWU+66Yqrv3urH11sjUTLaHBgsTVRX2BU9/Q0J
	 JFE1z7/h7+/QliIq4ZH23DknBot/9Ou3dFU0R7h/IcbRLjPxwxUhLaNSV2B0cqM4rv
	 PhN/ADH/AsvT9vrkKyt0Rsrci0onnGkmQL5OsNE3jssqyE2miF+a2VzLugfhB2pJPG
	 lA/51IkPNVp4Q==
Date: Mon, 4 May 2026 09:48:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 01/14] mm: decouple protnone helpers from
 CONFIG_NUMA_BALANCING
Message-ID: <afhPWW52f2PtrjXj@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-2-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260427114607.4068647-2-kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C13A40010
X-Rspamd-Server: rspam04
X-Stat-Signature: qphsxo6ixrt8r9yromsuax9gmeqnzp8z
X-HE-Tag: 1777880935-105686
X-HE-Meta: U2FsdGVkX1/lb7M5c3Qk7k/zMJ24M0WSelqy8ntZ6B6s1w4v27IWb0RW3szvz/XcwKc/8jDLYTwI3GU39UyOrIKONOq51R5RgdTd/li2Zyb3YMtnteKSY8SABdIJ4U5VlwJ4zZMmms2SwpwMaIyN21a1uSwJX943s5nE/jdh4q4a6PB9VADGuueUnnlMzWqdi1W+Wc7fDd9oeJxb2MByxcvVCwfdpIoXMt4aFABPk3vDk3oygE8cd8LSonnm9YOapJFalvhism7/6f0Dg0a95ipqkcdYgkV3ryuKHXrld3IDm4uF0ZkTqgUft6u/e3fcpubTupW13C63Za5PxhuT9KogmyV3+yJVGOVyYrqDEEeCFxivxDOqVG/DnWBc0qO/I7wnsw71X/2gcSCtki7wwcw+g40Bv7QUDWSb2Bm3TpehGra/3mayV/zMT/WXa5YX2Yo7LfaXOmnGls3rXyuIQsHNw+HICzWPD6/4pdlVqlwAnaoDDbZ73iqmTSdrqIsxYBZjkQaNqWCUOjatn7vrNFwX1zLpBd/+Q6Yu5C0Tl18Xc0SbEpFHbjjYCqFvW+j6zeqxHHfZOkLnc3X0xYD+UTF9HZnD/eCYGgusQjpto27sRB6rsJmPH8Ux5kr/Oaqr9JC90cvN9meaZBMFqXFYb1MQHN4aLyn/51eRlFyf9I2CcWi82AhB5tE6jJRJkLyQwA+SRvBpV68mvQG/WkK8cI1FJcUN9gY94SwAN0hiEVmC/r7NRciWRo3f/VxYUaSkMNhAN1nIJw63unYzTXcLJ0HJuEPUao13/C/AvqVV247T/NuRJsueYBx3nmpCnzUsdLINcJABqC+7lgmnAUPDraP0YLnVG73AgC2qBmwHJ5prfL7eg7kEopiWYHGdJ+U2/zxdnY7CuPmUEShGl5sMHkLRe4KRzOK+ZHZ/ARnY9K2lM1hRF0JQQt1RXeWtsaDvRARsoCBWpAGdpCzvmLK
 BXSqVjLA
 PQHknjWGhiWfEgQto9/lWZ7MIVfQ85j5UMT3vawvGeBgXgTztNfoQ01p71PzFRwmN7RSxXf7Qbo2xAPeSSVXWcoivqJobSM01lXAS7/cn1fXRGqOHOEEq/atQ9JPAGybW7A4T1hvTWSOKc/X7QlcxIrhyY+0A6hK2491oAYDf5uDgpk+/ZgwaKqZ0HweeaLzbRD2fayFuf9u3I2ptcnXx6eXABvyfABhsx+q0SJegMfP+cFf8DR6lF772RDUoYaROJiFQAuy0LZdV+rqHm4mGJ+fERdngIALKLBO9bbp+zLqojDvTgFgitpCjvwdJFzk6OTQ8LuhAOfRlmAQPEFb+OwJtN1qQMAa5/aQG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 12:45:49PM +0100, Kiryl Shutsemau (Meta) wrote:
> pte_protnone() and pmd_protnone() detect present-but-inaccessible page
> table entries. This capability is useful beyond NUMA balancing — for
> example, userfaultfd working set tracking uses protnone PTEs to track
> page access without unmapping pages.
> 
> Introduce CONFIG_ARCH_HAS_PTE_PROTNONE to decouple the protnone PTE
> infrastructure from CONFIG_NUMA_BALANCING. The six architectures that
> support protnone PTEs (x86_64, arm64, powerpc, s390, riscv, loongarch)
> now select this option, and CONFIG_NUMA_BALANCING depends on it.
> 
> No functional change — the same set of architectures continues to have
> working protnone support, but the infrastructure is now available
> independently of NUMA balancing.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

With a small nit below

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/arm64/Kconfig                           |  1 +
>  arch/arm64/include/asm/pgtable.h             |  7 ++-----
>  arch/loongarch/Kconfig                       |  1 +
>  arch/loongarch/include/asm/pgtable.h         |  4 ++--
>  arch/powerpc/include/asm/book3s/64/pgtable.h |  8 +++----
>  arch/powerpc/platforms/Kconfig.cputype       |  1 +
>  arch/riscv/Kconfig                           |  1 +
>  arch/riscv/include/asm/pgtable.h             |  7 ++-----
>  arch/s390/Kconfig                            |  1 +
>  arch/s390/include/asm/pgtable.h              |  4 ++--
>  arch/x86/Kconfig                             |  1 +
>  arch/x86/include/asm/pgtable.h               |  8 ++-----
>  include/linux/pgtable.h                      | 22 +++++++++-----------
>  init/Kconfig                                 |  8 +++++++
>  mm/debug_vm_pgtable.c                        |  4 ++--
>  15 files changed, 40 insertions(+), 38 deletions(-)
> 
> @@ -2052,18 +2052,12 @@ static inline int pud_trans_unstable(pud_t *pud)
>  	return 0;
>  }
>  
> -#ifndef CONFIG_NUMA_BALANCING
> +#ifndef CONFIG_ARCH_HAS_PTE_PROTNONE
>  /*
> - * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It is
> - * perfectly valid to indicate "no" in that case, which is why our default
> - * implementation defaults to "always no".
> - *
> - * In an accessible VMA, however, pte_protnone() reliably indicates PROT_NONE
> - * page protection due to NUMA hinting. NUMA hinting faults only apply in
> - * accessible VMAs.
> - *
> - * So, to reliably identify PROT_NONE PTEs that require a NUMA hinting fault,
> - * looking at the VMA accessibility is sufficient.

I think it's better to rephrase the original comment so that it'll actually
describe what pte_protnone() means rather than remove it altogether.

> + * Stubs for architectures that do not support present-but-inaccessible
> + * (PROT_NONE) page table entries. Generic code may still reference
> + * PAGE_NONE from paths that fold to dead code on these arches; the
> + * BUILD_BUG() fallback fires only if such a reference is actually live.
>   */
>  static inline int pte_protnone(pte_t pte)
>  {
> @@ -2074,7 +2068,11 @@ static inline int pmd_protnone(pmd_t pmd)
>  {
>  	return 0;
>  }
> -#endif /* CONFIG_NUMA_BALANCING */
> +
> +#ifndef PAGE_NONE
> +#define PAGE_NONE ({ BUILD_BUG(); (pgprot_t){0}; })
> +#endif
> +#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
>  
>  #endif /* CONFIG_MMU */

-- 
Sincerely yours,
Mike.

