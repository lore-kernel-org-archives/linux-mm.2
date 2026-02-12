Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2CAFEB2719
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BE76B0089; Thu, 12 Feb 2026 03:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9676B008C; Thu, 12 Feb 2026 03:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8246B0092; Thu, 12 Feb 2026 03:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF6A6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:39:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0E248C438
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:39:29 +0000 (UTC)
X-FDA: 84435155658.13.55384A2
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf30.hostedemail.com (Postfix) with ESMTP id B64BB80006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:39:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=Kom0jmG4;
	spf=pass (imf30.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770885568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGI9E0Ah/sCKqUWdGGZrUCOyQzLXgtvn+/30CBuRp9w=;
	b=3t2+W5Azpnu2smB8D+NsRhyDWpyaxDblhkenDZBO6mnOpu+C5tsHXrxhr0Gs8DbHM8snn2
	egLaNdKJCTPHB1BIZk92ZRnUhWFVr1+DkKgjLxQf8Id8DGa5uAZyqnF+ZfcZtZNKm7rB5D
	KL3X2vMAhD9cgXI2DYcjHtjYLqOATz0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=Kom0jmG4;
	spf=pass (imf30.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770885568; a=rsa-sha256;
	cv=none;
	b=HQkK6RahypJn0FKW3wE5CZhx/t5UC/AjsUrTtGiKfFnfG5WyvDp0X756gmZgw94rA/G4Nb
	3eH5vsVllpOaHLHg/4bEhDdK9K35y0smHuteC/q4RB9ET5xeJ3GKf58RQVQBzF6VqxXnz6
	MzFFjSwOuONNP6tiqrQFd4pke8L1SNY=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4fBTHd67LVz1DDhH;
	Thu, 12 Feb 2026 09:39:25 +0100 (CET)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4fBTHb5J7Hz1DDZ7;
	Thu, 12 Feb 2026 09:39:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1770885565;
	bh=PGI9E0Ah/sCKqUWdGGZrUCOyQzLXgtvn+/30CBuRp9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Kom0jmG4cp2aCCPXYGhzvsNdpnID6H+n8FBHwTifdpEYGIUBXrnEh77Zjb+F4Uw9H
	 UXUPUIguRj6rXxio7bPxKL8EDMaAwhGefR3rfI1wHeSXx/zPR33P8qJNbunSZ43qDr
	 NgFlGeDjza2ZQm8OzzMjsW6vlhjo+CZxjlwQT+qLbYqhmgxd8Q8Ihyd2HOc3dvoADp
	 o+xiWOcZDwMxqEP+I8vJDl4qWqdv4qG5u0jzztECJfg3xosxH+CpUDCdgJZ6vEOukO
	 glY3kmdJgj3w/lSoryU0vkLnI0wkwv88sda11lAy2tHIoR1eKoCLmGUm0esizzLPxM
	 ivEADa7FfTprA==
Message-ID: <e2a3798f-cbc4-49c5-bbd3-42509c22c8fa@gaisler.com>
Date: Thu, 12 Feb 2026 09:38:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] arch, mm: consolidate empty_zero_page
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-4-rppt@kernel.org>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20260211103141.3215197-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: kmcrwzfmukihz7mskjnjoqcw3f95q37k
X-Rspamd-Queue-Id: B64BB80006
X-Rspam-User: 
X-HE-Tag: 1770885567-13125
X-HE-Meta: U2FsdGVkX19ny30fYJikr6Ik0HQM02iWzdsSXIOWAsR0uHJHfoIlpqHNGKD1W0zDzWCnmKuXbm9ltKsM8KC6oeHzc5Z61t5rNBHDpyqUCECPb4uJuC4OFm1U+kw26ddh+Fq03ZpzXgATEUVSIy9tFYwyACe+fgki+4Zgr0D6Vko5KoGKWjDvO/qTt0F9BXcbGeiT+DT59ln6DWtlFmCM1eulFKjiCJKV1Vl1jhZeLwHPKY7PfKcvyVAxJyE+MzAAA6v75HYO21iJdfFm3otT7zZcYkxliwztLRT10e1bjlHPG9QHSj9CFdRd84CJ3ptGFEIofgRvEP+DAbuHy1LzrwHnOKW3+F8p7HH1cn+YSKnyorkl4B0KuDf79xl+wwHwkhPa/VhbPQP/vHm8MnQrzzU9m6V6K0f3GkzI6v4OLiLlu1JBZrI4HNcldu6huoqYRovQX8DRrLKVRmKQnf0pV3TqwPWI5LilZNfsq+A/ju0oTwPK7Dy1Tdmjda7sjxJyNY62wYlLVLnIPYJj0zgjucyugiEQw95mz4s+g/V48EHidnpsx8FNC1+bEC+R9Xe5DwzSoqCiIp6feORstFtk19WwY244UuL8RrmHV+HS8K+LEbMdWt7Me6EWLTic0Py5bacg8IKQzIFmt2Ku5+z5Chkrd7fHyRWxDzHkiSBGHkJ1dZA99FatDoJBCvFIhRUtCpfGkfexYa8mZ72yE1H6cgrQZLzWDhHgvVkfgv+8LXSY78NStx0wwz7LVosBHlpNQiJl5ndTChJ5P/QCYDoUIFPaWhOL0mAaCiN/PuiJETw7oJWFZMPOA5FM8oqk0U/Zy7hoCw2WwW6KomFXkOIOjKoZflxQki15lAqhwc0GkKJpzC6wJAUzip+dZkLoVp2rMi79QmiGF4RyxSgdMP7Wven7c22RAlchLUkRkbnDeWbhHzwaUQ88Stc3Wv6t7fiWKkDoCdxwSH+V1TbDFs1
 JYrzzOpm
 gr57XShhAfxafT7q+rH7ca0dHJCskfoKv5RAKNCMxjuXf790hWrAQ861xW8eFoZub5q4G+hGyiPzwZiRhdMsy4K3PVHZARMo4jCvZaxpqFjUf0dx9hrTeTZds9UnsTjdJw5Xv1NxeyL1JsQHHUgXev0T/kuYJXGnwjV2p4qcY7754iO8Fss34FLQ8Jh3PWCcyDjHaFWiec6G5gU++XeghlV29VLzeTEDYL0H84/+O8uIUcoR9iM0x5SmBANYVPx90M/4Pc4bzRQnxT+1LLu+MNUgfGMzJ0oaeZuZ5ip6aYwZea8lzlJZgCeNSSuAX6+ENrUokGNVt48enZx21yNxmxEML/Q//h+1Td4R2N9T+7Zc4lFgMPioofhcUVdyP4/k5SjVAxSwRbFB0224LBr16vRyJ/JwRiP/fky1wDLnbOqUxT44eDAD2/1qXfE5BblAGJIrkSNqg6vfOK7Cf7O/CWM1/QabV5BVa7F2MO7vrlZtL4i4Bk7mh8mwsYyl4Qgxo580E7Wri1fhi8u0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-11 11:31, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> ZERO_PAGE() to 4.
> 
> Every architecture defines empty_zero_page that way or another, but for the
> most of them it is always a page aligned page in BSS and most definitions
> of ZERO_PAGE do virt_to_page(empty_zero_page).
> 
> Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> core MM and drop these definitions in architectures that do not implement
> colored zero page (MIPS and s390).
> 
> ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> inline causes severe pain in header dependencies.
> 
> For the most part the change is mechanical, with these being noteworthy:
> 
> * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
>   parameters. Switching to a generic empty_zero_page removes the aliasing
>   and keeps ZERO_PGE for boot parameters only
> * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
>   ZERO_PAGE() is kept intact.
> * m68k/parisc/um: allocated empty_zero_page from memblock,
>   although they do not support zero page coloring and having it in BSS
>   will work fine.
> * sparc64 can have empty_zero_page in BSS rather allocate it, but it
>   can't use virt_to_page() for BSS. Keep it's definition of ZERO_PAGE()
>   but instead of allocating it, make mem_map_zero point to
>   empty_zero_page.
> * sh: used empty_zero_page for boot parameters at the very early boot.
>   Rename the parameters page to boot_params_page and let sh use the generic
>   empty_zero_page.
> * hexagon: had an amusing comment about empty_zero_page
> 
> 	/* A handy thing to have if one has the RAM. Declared in head.S */
> 
>   that unfortunately had to go :)
> 
> Acked-by: Helge Deller <deller@gmx.de>   # parisc
> Tested-by: Helge Deller <deller@gmx.de>  # parisc
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

>  arch/sparc/include/asm/pgtable_32.h       |  8 --------
>  arch/sparc/include/asm/setup.h            |  2 --
>  arch/sparc/kernel/head_32.S               |  7 -------
>  arch/sparc/mm/init_32.c                   |  4 ----
>  arch/sparc/mm/init_64.c                   | 11 ++++-------
Acked-by: Andreas Larsson <andreas@gaisler.com> #sparc

Cheers,
Andreas


