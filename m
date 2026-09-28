Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D9EC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 04:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06D26B008C; Mon, 28 Sep 2026 00:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DEE66B0092; Mon, 28 Sep 2026 00:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BA36B0093; Mon, 28 Sep 2026 00:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70F616B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 00:42:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8CE240B12
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:42:42 +0000 (UTC)
X-FDA: 85261925364.29.5386D83
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8386180008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:42:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bKrEwt2b;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790570561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Fit2ri7yDJd8c8m86kxeQwDV36t28/6QiK335esobw=;
	b=npzhBZGxMM44OtMh9YtF++X372FV58eyq0tXBzjA/bgqjqU7g77kc2bFWjMcQH3Xjv6WJk
	HxAjgR3qG9TuIiFAFZjxbFfEy6iZGPuRPHwLwJ/MsmwhNfiJMqFP97U0LcX27oluEtD0P1
	Dv6RcPSQb9k4d6dA4nDKekqNcLmzC5o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790570561;
	b=UKhcGUtRjStI5Fxl3f/+QFxmW+9r67a5Qzq/F9Ti6H233WlM15Sqt0ReL3aDX6aCckCiOa
	QXernS5JwJJAu9TiufTb8nSfp5AHKQPdu1ymYaJEqW3yomVpC9TXMHptb5QR5uASLri9KE
	kqI+aVpN5JBEZjUD15L/LrQKk0gJZhA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bKrEwt2b;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B62D1595;
	Sun, 27 Sep 2026 21:42:36 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5F973F85F;
	Sun, 27 Sep 2026 21:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790570559; bh=g9+BM8LQstyMyJtvF3kyKscq7+5czkGZL/4m6fk+efo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bKrEwt2bC/ZQWJUMqIbP/vuS1K0gagIxbK5QMww2e+iM4X8cIC/KbLm1H+8DoVNY9
	 URi8HP8oh6BmQp553mLeKba4VYQrdZDfLFLzocjOav/O1EFyxeVVivmwCJ0iPtKlXX
	 i5a9pmIFqdzNhYDXPlY63UsQvBcs0j0/tnvCuMnk=
Date: Mon, 28 Sep 2026 10:12:36 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [akpm-mm:mm-new 661/679] mmu.c:undefined reference to
 `__check_safe_pte_update'
Message-ID: <bao3loem52ww7aplteu4ialsb2umep6mynhofp3loamdewytxc@pexxabh7vdf4>
References: <202609270030.Y0QVBPmK-lkp@intel.com>
 <20260927133100.46a4f7067c79280dcf83731b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927133100.46a4f7067c79280dcf83731b@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: i7o9fs1g19wixcxwybgir9ufk4ibs33n
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D8386180008
X-HE-Tag: 1790570560-696419
X-HE-Meta: U2FsdGVkX1/YEXFvjKdbrQVEEABu1SswGAT+qi+rWe++auiTdvr4VJBBab8k3ucemAXZCgBcyorJrs8y4kiHk1L/M0zt2X8ltrvzCq88czHC+YWpvi4b/3YsfZzShenwP/0wijqOngEe1KBvlVywSlDRrQC+eylc+bzk4zu2VWROIVsLlEip1q44Zq8WVqjDwje4v2y58buSSX7Mps8Krj/6nIFKBYuFfU6MeRGiOKjXpEsg+4kgAtr6IpZDm0iMO/usRX9asbQUBTCSDoAFBw7hwk1hRXOrlT/qDR3jyMLy5na7Y40RST5CpIl+cWblBkpQW6rrRTbNR0SwpF1vdEtCG+78onkd897Yw5Car72jFPPXgLIverOEwGK2dD6MDR69GmZp0U9cpYBPSK46gpKtIYZOSywZj/eHmsymRCHG8zoFHINN7534wZyFFajyOnrfSJtMr/HnCIKCBQ5LxWN8Au+hBifdx6Nv2ozI/Y6BS6yFvUyxlCXg+bbo75l0VHL9gtXrnuA6B+dicoMm5Uq6tFOEWyXem/RUb7SUIqpp6fx9lmpQSmByhLtBGgYpAvGr2QIWazhP0W4hd+USl62y7B0C3R58EjcSfJUHMffFlmSbK56VfFem627WkHC5US94O6R99O6cbZGis8HCQDO8sTZSWzIzBfaYrkzbrjq5T1q8ds+RvlRsX2Tyn5oSlR5wrKO13hSYk/Q1g+MB0YTCqKPwcBGCHChj399zdAcohQ7kfXhntdqpfla5Jo6FYSV0tMmj3hFnRqGm2MrybWmOUgbhbBE7gZkt1cYvuNWTd00nHQHUDD5M9kYCuwXXZSzK123n4XfN9V/werjf7AJPJ8681G9uunm8AdkA2m6Ti0pQe+5e9kGLNUY+aVfhrkKmE7gt8JbFVCnNKQthpmoQcJi48oBvcdhco47U3Nyl+lRWJ6KYyKYy+R8huiVQGdb2xyGuk7p/MavkrSg
 ekKA1eeD
 cZNoSTEy7hWxVZWVjTgygFo1d7Pe3l85vwhQz7Ad+0+dethxn78OjPShqAjgmnA27vSkq9B6CEElO13MLKg6AIUdRUKZiUz4oEhsKq4cClUUlma8lxbBAD11UAt+Iw9kUv8EVilteopm9jLqHvl3h8jkyywz6TS3MOgQ2ZkHq+cwea+798svn5nA5XEv0ZUzVpAQWTFocK3AY0X5waIhDPMoZvD4YBmtQJNBCV/mJpGravkCbhDm0SBAIeM59HQpKk9t9ILNKYpb4UInFTBfvJyLQzJ/ufW0zlGh+JrHbzdRvwtkCGL19nPokCHXaAkfMDqordw6kgiP4vMXdjusuQ1K2CLFRINnChg+COAHP3tpSkOW6u1OzouaWV5moXrzkgqb5rJ4iST0hhJAd/He6PDgBbNqor01EMFN2RFNC1F6b5zA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 01:31:00PM -0700, Andrew Morton wrote:
> On Sun, 27 Sep 2026 00:32:54 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   b4fc90c82982d98959af08b4320420bcfc01303b
> > commit: 2862bcaf1aca55e0b43a5692a4595281ab780f05 [661/679] arm64/mm: move __check_safe_pte_update()
> > config: arm64-randconfig-1002-20260926 (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/config)
> > compiler: aarch64-linux-gcc (GCC) 8.5.0
> 
> Thanks.  It works for me, but I'm using gcc-15.2.0.

Tried building this series with a cross compiler (gcc 14.3.1) and a native
compiler (15.2.0). The series builds successfully in both cases.

- Anshuman

> 
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> aarch64-linux-ld: Unexpected GOT/PLT entries detected!
> > >> aarch64-linux-ld: Unexpected run-time procedure linkages detected!
> >    aarch64-linux-ld: arch/arm64/mm/mmu.o: in function `__set_ptes_anysz.isra.40.constprop.47':
> > >> mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: arch/arm64/mm/hugetlbpage.o: in function `__set_ptes_anysz.isra.32':
> > >> hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: kernel/bpf/arena.o: in function `apply_range_set_cb':
> > >> arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: mm/gup.o: in function `follow_page_pte':
> > >> gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: mm/memory.o: in function `__set_ptes.isra.207':
> > >> memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: mm/mprotect.o:mprotect.c:(.text+0x1080): more undefined references to `__check_safe_pte_update' follow
> > 
> 

