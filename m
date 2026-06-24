Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34E8CD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 03:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A87C6B0088; Tue, 23 Jun 2026 23:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858BB6B008A; Tue, 23 Jun 2026 23:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748BD6B008C; Tue, 23 Jun 2026 23:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5A06B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:13:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9ECBA1201FC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:13:54 +0000 (UTC)
X-FDA: 84913336788.16.8F318F5
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C0B340006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:13:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r25ADJwi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782270832;
	b=m+k0AwHKP0fIqTtecmwWs7KIDlEuCKqZe3e7jexjxwO81+QRwZU1xbknqmjmUqOZeE5QiZ
	3KBwO+MYtHhyh7SppQzW7hAPBlRLl27kk8PVbrsNX7wYUoIWkF6shJyGZBfv6HbFd5mdGt
	hxNMMtT+plk8w/E5vw8Vy3BOf/+2DTE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782270832;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQrzuV1rnE++lwljv+0k3oMRhBJ0TRHfGR8h8CiTgyE=;
	b=XqVG4jyLsjAa9oTackpYd8AggsY7xSaBDrG3PH0Q9/KO143YTkPc6Bh+n5fU3NRjyudmn3
	E0P8N0Z7D9LF6SzLMFLkcB4KAQqMFtLUbz84RgUWLNNC6y5hNHGwYJBoNYS+P1AMBDT0NN
	QgEkoTWjzcK/i4mDiAaOBQFZ/DKyC6c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r25ADJwi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c0b97e268f3so75872266b.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782270831; x=1782875631; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQrzuV1rnE++lwljv+0k3oMRhBJ0TRHfGR8h8CiTgyE=;
        b=r25ADJwiPnPy+lYR90abfCG1couqr6msUkTviRfPJuIZEssigQddKre+rlNfS1maGa
         9ajatrSnarTOYZAkTyj2DRZwEWgM0dix8g2rU5Cs4ARacqdCvqJylsQdPZ7OTXOiqml0
         oQ4Lkj3Z+ehE7QuhkHQQlnUeKxanB5TR8OowDrCIKkUsQKRqSGPK1H4eGUwOxK0uO+oF
         I7pB1XGuEsjiF+pvvxOEwUumhgZdL4ex4mQjFxDa0EM5j2Q5K6JBh6NX9D0hWzyC/ciR
         2BrZhC+oHGNFNSrLw4DpRBgHjp9dwOor2Ouk5HyHytGPJ244oBUjSg7vXMnCkOR8zpCc
         c5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782270831; x=1782875631;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQrzuV1rnE++lwljv+0k3oMRhBJ0TRHfGR8h8CiTgyE=;
        b=p7zpx21J3GDi9gmbiGZsRGQBYJI8hVHVUL8vthXvH3eaUcsGli8x0SkyhfzJBPDB3k
         Jq53wWV5HafVK1OK03dhCPUxPCTPoYdFOKF6R/D0LdVXNWzZ1+bC+67tr8+X/kT4+Oop
         f0InKticLwh0crYOrWQlGxEG7P0bD5wVjAR8xFf5HeaRMhtX6Z4NfpmfB522scgP5d8A
         hq9KoUWDHTeo1wetnJCkpWUWzdkzX5xvYDYqWg2HWDTY06eIT6ZTrSeu68w1b+pJC3Rx
         3H4hAn6kUL+bxrvBy5xulLQBR7QIKsPopqAWYwMHqJGlHC3vM8oZft0peBGfc2v63Qwf
         ZoOw==
X-Forwarded-Encrypted: i=1; AFNElJ+4cfvV/Fbu/7Tk1R+OiwIZdJeb1h8PWQa2uZyhLJNRDE0P20qmMqdLtMVFbAPaWXAMrTHpRitc3Q==@kvack.org
X-Gm-Message-State: AOJu0YxwgVBFfYcnANhC2Mr3B7dr86Y9AadO1io+gVp49lAVJQ8Cb+58
	1UiPAFA0mRb2qjDrJjYHlWnpfx7sVck0vpKfKMz16TH2DeJ2GWeJAzCN
X-Gm-Gg: AfdE7cnUSdIVUP4Q8T0K+GUKA3vKwzkgWJ2aqSrYkPftOCMNOciJX2UO9yW24/hav04
	3wLlTUyR4kM4N2qyed3n5Y9fhYxQG9FNLSG1ue2iNOqH4aRafT9yXasxzmPB+LLOZDUZ4u073fA
	mx3CpPlvPZdW8R3XjDjRt7J8I+inny6GhK5G0Z6m97pW5Dx+xRJXbKBgmhXgInowP6EZag30QK5
	h99hGNvIKEB1RretWiiYCiUXAXOp5/uhiZihf9Jp0Q6krfkRdwVfG0klLxkb7nPmkg2Eajqq8zc
	LBvncpZYS3jPfx20GRO5M3ttY+C29hYdMqcx0AEdkSj4MhnnKnmhETvpxaG7AE+1+j3coOSHms/
	OQldsiE5IfiJKmXZdZIBxEJT/kA6WHAHDeNDodnMaCoZxmugb+XfwH0j9W34Fd9YBvMz+X4+L8d
	8HqI5e46TVcyk=
X-Received: by 2002:a17:907:1c1c:b0:c09:4ad0:9a3 with SMTP id a640c23a62f3a-c119ce7c34dmr60766066b.4.1782270830624;
        Tue, 23 Jun 2026 20:13:50 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-697f3ade18esm362886a12.7.2026.06.23.20.13.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 20:13:49 -0700 (PDT)
Date: Wed, 24 Jun 2026 03:13:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, riel@surriel.com,
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, sj@kernel.org, ziy@nvidia.com, balbirs@nvidia.com,
	oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260624031347.zq2lhnnthuxqcuql@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
 <202606240042.ffPsEXVc-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202606240042.ffPsEXVc-lkp@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C0B340006
X-Stat-Signature: 3nqw1q6daznbs6xsbtufhhcouregiwnr
X-HE-Tag: 1782270832-586616
X-HE-Meta: U2FsdGVkX1+g06flZ3GSgv7Bn0Bthi7TYcXSdNrKAd7zIDgdS1Rva62353twU/r3K6s36g7B1PMdWd6vperFycInB72K0MeOqCHZKMFIPCDjJZkyICCV6r7xMoxswi6l1V1c/F17v412asAQtVAWKRMM6DNtmeOXcOPjER1wpBkrdmHOjsTLjgAabrjwLvwOeu1NzzbrA+TgoovYpY7tZTNS7BbOGVPSSt+m4lpEii1OKDMnvFnCbul2BRZyBBmFE0cnV1TeKpVeXXsN2T7XqK1n4oH0I4VGyAPW9c5IRBd74UlpT8yZGe6Uz36rDpx7rAHvz7coEZikDU14xQQkXuYU85dyYqEIuZbviP1TpS1tTrqFcIH/Nc5YrKCXBR8PcBZ6N1bJPCEzipOtjKItq8eZXcDHBWPXdVLS1Yhaq0k399vwfqoqIvtmDVu7ywEVsB3g37gs9tqrg6MAQ7rQqaK1k/sNuU/PQHiKsWsadwpILYCFSweUQAKKKaUeQmb+NcDbZI5ZZ726DakDeJbqjEqQnSzZHU+GY1YQiRBB60LbCjggQLWPfMpkEa0SOq90qoV94eIbEFa6tSEoclURZelOScfxRcMlmILRAzizKtp8EWIoLhEu0M+9cAuE0MD4yYv8D+jWhJbNgqcT6frx5x1nzztgnJ6Zt3rxck/stzQkcmRiub3BbbJadfRwY94d/GszzCmd5Fj7C692ZdYnz7TobmPbokkWQdxAYh4Adrz/pwTrGpuH60P8WzTUEYGwcbLhEfaNf4NRj5yz0qsYSkdWV+Uvt05PD8b43xTgHiLUtfTrSVd5FaDpiX5rqxFZDNA+PdoH021g2KoT9M5TPCw86U+imzp6ZHDkb+lsltvhDRhD4M0RTb7//EEFm/7MH+rJRC5EkcYZPZwYo6h7VQjrd8vfZwwECrmEH0Pi5al10LynZCgE0CiXuUvFkv5IHlfV+FbZf06JAvpMz9N
 gCKBsmeP
 o27Mpjx3MThQ33E6Xd9rr7+aPXPYOfypGDsJd5Fml4OW2+JeXTyN5LL1fgdQPeDnVwdpSwE6cFWtlATURVuxX1+Orb9OUWd5fXxFRdKA8dVhtnlDBlYoZRIY2bhEqtOfs1Bfs7XlkVubkkbcq7sJ09SBMFjOPbiqaeIr9DHUvgQ59y392lsY+avpZq+1LJXJseLXPNfdlvlNiWFen3ZANiyRi2DrBNBtu/MSZW5GL2bwwmna5m7dwW4te5FG3PfT159RPqx2sWkzgx6hcX2TuRFjFmGgDCoTPYjk2851yZDYD+YbAYtIvZeDEjNGnbEJUx1Xy8+LrvBMI6hMYMs78wL/5Dvgr1JIoxbUpDBPcazK01FZDfUmvohM7urH9aiIZXxVvRBb1HpQYTsw5CR2ZHLIdyRApeuRiHmk2c8+mzA8BdcTr4uNbdAEXeN7zprKT7x+5sCilCPTQm26w7uCWIkNTvachGdWvcanMAE0r4IMq3k2CrrqID7hjNONUhq/Os6SPAR2jp4JlwRM7TmJyPaLuodN0BSweu2k5mOyDw0WRsHPvPYZvPze1Ev61TL3Jxmwav5xON+IvvXqMO04TGD8jnPtGNIVGzKap8xB/b0b0AFBGuC3qN/4zQdPza2ojRW5pR3lDKJLaTTaNGFPqWYP/Mern3+sWwFUh/bI7KUVtY3Ar0fu60RYcDq6Dvm47g6oNjcGViP8dTedoF4NHvcj+wpEM0VnoSJinAprs4DFA0UAEu3yGg6ozCxs6Div7P7O2E2YsA4xKYwpPaCEB3IXNqbe/r9qbYU7zltG3MP/hHNxIZmzt3hFVgs0LoYVE6ZdyMyVVSS0SW4aDiDrfgUD84A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 12:18:20AM +0800, kernel test robot wrote:
>Hi Wei,
>
>kernel test robot noticed the following build errors:
>

Thanks for reporting.

>[auto build test ERROR on akpm-mm/mm-everything]
>
>url:    https://github.com/intel-lab-lkp/linux/commits/Wei-Yang/mm-page_vma_mapped-revalidate-and-do-proper-check-before-return-device-private-pmd/20260623-012838
>base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
>patch link:    https://lore.kernel.org/r/20260622130651.23359-1-richard.weiyang%40gmail.com
>patch subject: [PATCH] mm/page_vma_mapped: revalidate and do proper check before return device-private pmd
>config: parisc-randconfig-002-20260623 (https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/config)

So this is parisc arch.

In the config file, HAVE_ARCH_TRANSPARENT_HUGEPAGE is not defined. Which leads
to !TRANSPARENT_HUGEPAGE and !PGTABLE_HAS_HUGE_LEAVES.

And then trigger the BUILD_BUG().

>compiler: hppa-linux-gcc (GCC) 8.5.0
>reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/reproduce)
>
>If you fix the issue in a separate patch/commit (i.e. not just a new version of
>the same patch/commit), kindly add following tags
>| Reported-by: kernel test robot <lkp@intel.com>
>| Closes: https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
>
>All errors (new ones prefixed by >>):
>
>   In file included from <command-line>:
>   In function 'check_pmd.isra.24',
>       inlined from 'page_vma_mapped_walk' at mm/page_vma_mapped.c:283:11:
>>> include/linux/compiler_types.h:699:38: error: call to '__compiletime_assert_406' declared with attribute error: BUILD_BUG failed
>     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                         ^
>   include/linux/compiler_types.h:680:4: note: in definition of macro '__compiletime_assert'
>       prefix ## suffix();    \
>       ^~~~~~
>   include/linux/compiler_types.h:699:2: note: in expansion of macro '_compiletime_assert'
>     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>     ^~~~~~~~~~~~~~~~~~~
>   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
>    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                        ^~~~~~~~~~~~~~~~~~
>   include/linux/build_bug.h:60:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>    #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
>                        ^~~~~~~~~~~~~~~~
>   include/linux/huge_mm.h:113:28: note: in expansion of macro 'BUILD_BUG'
>    #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
>                               ^~~~~~~~~
>   include/linux/huge_mm.h:117:26: note: in expansion of macro 'HPAGE_PMD_SHIFT'
>    #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
>                             ^~~~~~~~~~~~~~~
>   include/linux/huge_mm.h:118:26: note: in expansion of macro 'HPAGE_PMD_ORDER'
>    #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
>                             ^~~~~~~~~~~~~~~
>   mm/page_vma_mapped.c:142:13: note: in expansion of macro 'HPAGE_PMD_NR'
>     if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
>                ^~~~~~~~~~~~
>

This is in definition of check_pmd() which is already in kernel for a while.

I will update current version, and take a look to how to fix it.

>
>vim +/__compiletime_assert_406 +699 include/linux/compiler_types.h
>
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  685  
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  686  #define _compiletime_assert(condition, msg, prefix, suffix) \
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  687  	__compiletime_assert(condition, msg, prefix, suffix)
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  688  
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  689  /**
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  690   * compiletime_assert - break build and emit msg if condition is false
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  691   * @condition: a compile-time constant condition to check
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  692   * @msg:       a message to emit if condition is false
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  693   *
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  694   * In tradition of POSIX assert, this macro will break the build if the
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  695   * supplied condition is *false*, emitting the supplied error message if the
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  696   * compiler has support to do so.
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  697   */
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  698  #define compiletime_assert(condition, msg) \
>eb5c2d4b45e3d2d Will Deacon 2020-07-21 @699  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>eb5c2d4b45e3d2d Will Deacon 2020-07-21  700  
>
>--
>0-DAY CI Kernel Test Service
>https://github.com/intel/lkp-tests/wiki

-- 
Wei Yang
Help you, Help me

