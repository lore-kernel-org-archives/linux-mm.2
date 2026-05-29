Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533C0CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958406B0005; Fri, 29 May 2026 04:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FD26B0088; Fri, 29 May 2026 04:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845A96B008A; Fri, 29 May 2026 04:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7720B6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:10:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12E9E1410BD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:10:06 +0000 (UTC)
X-FDA: 84819734412.25.FFD5A08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2770E1C0007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:10:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e8AblKNU;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780042204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7JslTgF6DAMznv2PXmFJlZ9bFP3yUOa2T2SfQmjWjQ=;
	b=D68Taze6VgcH9llmMbbCGVHf0zF7QPIAH9MyPCn4MfHsyF02euQ0rPBkZa9o0OK3BOdEBd
	pk6sgqZlmn0eCP+fESJxuyCVsv6LxilHkQufNkbOaLexklJFaQVgyXIFfMSuZVdUOWt29v
	OB7mLBUmgSCTE5IDZx19pbd3uORSO/I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e8AblKNU;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780042204; a=rsa-sha256;
	cv=none;
	b=8Z3Y3f3ZQlLhpkZ3cAsrCpH3S3pWSffgTjo6BihyLuJDi+cZ6njROL/ljWMg88rojLcbwO
	8GlAEMQLvXBkhI5dNecaLzFwOIDtSb7ztf3OXrPY/KFc4RsxRxf8cmNshWNiTtPopHnovu
	duWl90SuC16/8fH8FwKuE+iJ5i2LEi8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25ABA41777;
	Fri, 29 May 2026 08:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339B61F00893;
	Fri, 29 May 2026 08:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780042203;
	bh=c7JslTgF6DAMznv2PXmFJlZ9bFP3yUOa2T2SfQmjWjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e8AblKNUkWLRz0yJfssvDmkzORruiLmQgypQ7b+6jWh4cBonW/n5ywTINV/eITm3f
	 uMtCw2tA8jVwOnSHZlJcCROckH0jZ5fO7qrJBtmPIq2fYU+a47f3eIQkC/eIQSKrZv
	 kXztS5K84yzJkzuSdpJoG2br6kAQq3niDGukz8nMkSHJR+yY7WZvH8qmCi+60E1+s0
	 MkOXbJJgE/SSRjUoZ9DiQMAJQdQVnGauanVv4vbLw97OxY0PuI8YWXAtLuDu/np+wK
	 /Z9e5s1U85uqtIuYJIIOFpQEFHA3kuQorYOMVVIz3B+REL/3FU7uLWoNDvW9Qyh354
	 j/DNWZcEOEWqg==
Message-ID: <7530249d-896e-4de5-b009-040e5ae8a874@kernel.org>
Date: Fri, 29 May 2026 10:09:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: free prefilled empty sheaves consistently
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, hu.shengming@zte.com.cn,
 harry@kernel.org, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn,
 cai.qu@zte.com.cn
References: <20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn>
 <202605290406.mjAKJqbo-lkp@intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <202605290406.mjAKJqbo-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ahy3siu8fyjmr3bz5ysb3qt6g34sq5pr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2770E1C0007
X-HE-Tag: 1780042203-660559
X-HE-Meta: U2FsdGVkX1+QPPT3NHrPBh3JT+FN3uCBV/6AXyHoQ31ummXJ4biqxxvp1pZbexCDlrmD766Zwbv2Epqvlg6SDp21vv6/mZYtkNJdQ0ftvJxQ5nWooMQaOQoa4ULrlzCNkkdiuVVSVeBnOnvdDu8ahO5B/HS4wxTgR9mcEUyM8pF7eRa/4s0IEz/sHad3EfRE5tZJQXbbtxN+Qd8tqIUG/pLYMC7XtB7sz92qgQikUJIN68Fv7wa+vYlPBfdXMC5CPafX0KIr65tzFFwdBjvaYnua550BH1j60J9VDQorsm3XnDhiOlNfgaWtNqyDXayTBWZUt8YrKM14XHISYCa5Vaj/CSq+nFPKyO0FL7C9Xa4PAGqMnO06nbdPHcIWcTk815ui1lkNSqt+AL3QIi3kGn+/EWCesGczlwPopIBubOlZgGr3NwY4dmtKQgHkc/kaZY5AYAxADw3uHqc7w3wScNFuLJ4N7s+L0CBngPuuoTZP7dI6ySvmhZPG6lm8tbVZ9bK78bsPQbtaaFL6ob6UPEc6I2AVLcwrTMsAkpyKzqiUOTB3BmIuAgOurXV3dv1mSiPvfxLfNIPWpFEhDSudAY3jUIcDkTRM3pW04O8s/iKCNhbUY0jXAfbA9Ks/o6geTBkQFtXXFlLE0xzDyJ0hY24wairsEMwcuy3mBiV3vxZmA4tcUNwioGkQf5tEpJgnf+vJEFdNnd+UUN60KmhiDmF6res4GEtW1agp8RISPwgyY+7iZbno+aa2c2cxhvoF0YxwzhLasZdiBNaNkTIsCibPAHWN54ONkXv+1Zq8x95OZBrx62CALq4bGB/VthKKF1u/p3q50eY/Vs4ODug+yMF+3Nm3au0PbrxSiRQQggSsSNq+NbxIG/KrXZwuACifBm4PY8BIX5DFCRzuLMvyfhUK93yKAjPg9g+EyMvwjMAVHOrgnoKrM5r4QNkm6VJ6nSpFwmup+WOG1uF4gDz
 RKszSmEH
 kiRcqPWo98QBb7JA6OlaW99t+f6/Aq//mIl58m5aHlCX2b5aXyLkZhoVLPpxgR9ZsJL1Ds/pdl4oMdjNTQua26sv9d+F/RyotabLrs8fOm//qzUpgIM5cfeNcCkDruVuFZCW08m448JeWs4RvLnpLzpv64gK+vNc5osNyaXPORnROhIcM5XvKRcV+mP8dMze7mewo38OpZ4VaTh/2ofsYwmH+BwLaGCGVpwjzsttd+A61n2aZljxlMXUuQ0SVHaNKuiUEWml1PfT2dbGXuilk6LD/s0Dvr0j1TLDOj2igSvUwY4Mgnr08XB+fzf0gIaEHWCpCHUUK6rgXaKEYfHoxMOyBCsp0UEZRjAg3w0Kyev/FDd7o1JnthchN2k5t6ctUPMREbuAWf+9Le8fpqqIm+7K7TVpyPHvhUVFl6M6ZLmKuAlx0cbSLYGua1yJoreJi/IWz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 22:29, kernel test robot wrote:
> Hi,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/hu-shengming-zte-com-cn/mm-slub-free-prefilled-empty-sheaves-consistently/20260525-211805
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260525211000387LYqTHmxYL900XIB8qwV3h%40zte.com.cn
> patch subject: [PATCH v3] mm/slub: free prefilled empty sheaves consistently
> config: powerpc-randconfig-002-20260529 (https://download.01.org/0day-ci/archive/20260529/202605290406.mjAKJqbo-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605290406.mjAKJqbo-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605290406.mjAKJqbo-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> ld.lld: error: relocation R_PPC_ADDR16_HA cannot be used against symbol 'decrementers_next_tb'; recompile with -fPIC
>    >>> defined in vmlinux.a(arch/powerpc/kernel/time.o)
>    >>> referenced by time.c
>    >>>               arch/powerpc/kernel/time.o:(decrementer_set_next_event) in archive vmlinux.a
> --
>>> ld.lld: error: relocation R_PPC_ADDR16_HA cannot be used against symbol 'ppc_emulated'; recompile with -fPIC
>    >>> defined in vmlinux.a(arch/powerpc/kernel/traps.o)
>    >>> referenced by align.c
>    >>>               arch/powerpc/kernel/align.o:(fix_alignment) in archive vmlinux.a

Looks like a false positive, the patch didn't touch any of that.

> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki


