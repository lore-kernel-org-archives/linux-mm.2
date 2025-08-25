Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BAA6CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 21:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258248E0083; Mon, 25 Aug 2025 17:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208548E0038; Mon, 25 Aug 2025 17:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1418E0083; Mon, 25 Aug 2025 17:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC0A08E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:36:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99BBE59736
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:36:42 +0000 (UTC)
X-FDA: 83816589444.05.BB50FD3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id 560FDA0004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:36:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I4PYupYi;
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756157800; a=rsa-sha256;
	cv=none;
	b=vjrG9VnylNUsw2Yu6TPX5JYASrvJe/SQUIkGepLbM6/WCSkMlsrCbsQQzDkY9XIhkgxpE1
	iT9CEThYfTmB0tMjQBnli97fg/5if+TAL03d0msD4IP588eFaYAqi+Y+iV9PiA1a1ZuG0e
	NH73zBqFqYgd0G7fNf4Uha1rxC5bnvI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I4PYupYi;
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756157800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQ7UtJJtP138+Cx1GgszqhG1nv85BE+7ClwFkts6QSs=;
	b=VBiuNBL4+AAXhNLzyowSof+Vgh5Dpm5mOhRmWZeFnfaAvW6/ymZB5P3XyJ7O038qWzbn7f
	i/yguo5WPzwPJyXTBKCoPsRxSfX6LidXHNumoo5zVmXVNGH84djMUyeGW9F8l6jtuJMWGA
	kZx0zUm44H4mjCoAt01vAYWsSHsaBs8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756157799; x=1787693799;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ENwpBGMnKJzD+vNESnlh2d9HHAvolBxZL2qadPLLmJI=;
  b=I4PYupYiWEAebmq5E0H1VSGnCTsBpB/BzEfUgqO4xJhJ/zAwsAOk/trV
   54XX+W03fUvPWGKRqvZ75MfQQ9gTtUMY2g1VV+DtRUi5xd3hiZIoosJ2z
   jfbmDjgKi8rmEsL11E7MHpnb31R2O/NbDi8qUgNcK4Y3rXfj00S86FUWw
   u8KmHp/UAemP+j8UDWCvVXpd6uhGTUm7/cd6VQUzhh35uAL/xkopoTTD8
   7Z1vFolRCVohWnCEU7RA8Psmx+KMm+snh2NSA0YZAGLwrNqtoEMebUoPv
   /dx1lapD6mE+rHucMvWD2z80Z1dyXv7hf8YZrlH74uYBm8PNRwh6s7CoC
   g==;
X-CSE-ConnectionGUID: 0VlansqmTJq6IeWiK1jhAQ==
X-CSE-MsgGUID: lVLGd1FvRhCymuuKHH6SQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="69754692"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="69754692"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 14:36:37 -0700
X-CSE-ConnectionGUID: /uyCc6NjR9KW4BMqoy2VlQ==
X-CSE-MsgGUID: 9k1EwDU6QcGQHDVezqm8Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="173575364"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.229]) ([10.125.108.229])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 14:36:35 -0700
Message-ID: <c68330de-c076-45be-beac-147286f2b628@intel.com>
Date: Mon, 25 Aug 2025 14:36:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/19] x86: LAM compatible non-canonical definition
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com,
 kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com,
 alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
 trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com,
 joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org,
 graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org,
 ardb@kernel.org, thiago.bauermann@linaro.org, glider@google.com,
 thuth@redhat.com, kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
 nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com,
 justinstitt@google.com, catalin.marinas@arm.com,
 alexander.shishkin@linux.intel.com, samuel.holland@sifive.com,
 dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com,
 dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com,
 jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com,
 kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org,
 jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com,
 ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org,
 peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com,
 ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com,
 ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org,
 akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org,
 pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev,
 will@kernel.org, andreyknvl@gmail.com, jhubbard@nvidia.com, bp@alien8.de
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org,
 llvm@lists.linux.dev, linux-kbuild@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 560FDA0004
X-Stat-Signature: mmgsq9t3sprxqyargnaouneetfb4gwzx
X-Rspam-User: 
X-HE-Tag: 1756157799-786000
X-HE-Meta: U2FsdGVkX1+A5LoUTvjfnJKkI2i+i4L60a83E8tKgIIo42oM1AxBuHFGD6i7wSL362KjSeHkImo++gW+t+wHrhehEhGCq+ykxYgN/6Cdn0l6a1asdijtQGLdS18agzidMpUdJxBYSCmaPFzluNiPpNuA8Eqs2hYHO1LT6Xdc7NltB4RhmX4kM/7Voo5c359oJJaQM/kPZBxPtHi+Uqwu8enMngULQ4IxBdjO5XUGcTBWVC/FQKJkbb6NtQLyYWg/zBlL59O1iJOk0uC8QtGDb3h9jzLoPZhfeGzRBCvbwflxupPBIk8vaskcS2WGNDlCqHwaXVsKltC2+ozzlT+RMKkM3QhgQngAPFftE/j5/7IMeYVaihPT9Z37zXTzuiazMd7Bjic/iNdS/9r4gLYkCcVTm+5TFBYMU7W7J8o5yOsryFI8XMPlNeLnHRCwtRo99fWcwWwSUeREEXKTOuPwT7TgHKwIZG267N+NZ9baeouMw9x2mCVDFMH17FK/d3wR04YC62Ouga+XcH3fbcpM+5p4av+3KqJR4IcN0wFEBCzDPwFr5eCfulBthqzVMpsip2nqLEpLw/hIglKzopusQpdOIxWy2noYN+O2YQAQk/rrd9rxgJwimAM78g9yxvACPr8I/AutTkIga0R27kmUafbP1Jq9ezZJaLU1tJcHhBpoAu7dSkGbzA7SYH1pvLihx6Omu0xm4ARhqROEeEgOI9UTA9jBtgATmwZN+xkRoBlU9W+vIvst+IdwszprnTtpybQp7H8syu/WZEbyo9RjSwJ8ITmldAO9JrHzv3PcCXdWyfqFRS3Du2RpYaHrx5p3Yj8Ui9QG+FjqFU1SoTuoqxz4hA6YftuETP7svIW1zfYz2Kgi4qBgRBhakaAoJBPhnKaHWt+EujLnSiLctDD9n64N9Gkp/za5A0NoSWXv2z0L2yaNYaCqMsW9yjwNrbjk7I35mYoi2iuFl2s7QQU
 oxoa7uqa
 LbhUWAsF2V7OWGv9xxvShtyaawNYrateqpnQFAJ/tftdly7xJsvMzv6Oxsp1MD3Zz7Lr8P6eOZ93Ms8bUNY8kVp2mT3ZZeZosykthbtF8yYkZMdWCc8b8Or1o95cow7I7pfskoKjRFpAl8KapC4+BXFAf88DYpjQgMZ3HUqp+cgdCJmDVH78Y6Lr0U+1DbODQl5nMqQ+oQ63xmLoMMmSUPV1ZQX3A1BjAvx8qPd5mk6VMWGDlH4O6m7swYDti5vbmMjh/XZDE6C2kDMz97dAvK3V49Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/25 13:24, Maciej Wieczor-Retman wrote:
> +/*
> + * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks.
> + */
> +#ifdef CONFIG_KASAN_SW_TAGS
> +static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
> +{
> +	return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
> +}
> +#else
>  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>  {
>  	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
>  }
> +#endif

This is the kind of thing that's bound to break. Could we distill it
down to something simpler, perhaps?

In the end, the canonical enforcement mask is the thing that's changing.
So perhaps it should be all common code except for the mask definition:

#ifdef CONFIG_KASAN_SW_TAGS
#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL(vaddr_bits-1))
#else
#define CANONICAL_MASK(vaddr_bits) GENMASK_UL(63, vaddr_bits)
#endif

(modulo off-by-one bugs ;)

Then the canonical check itself becomes something like:

	unsigned long cmask = CANONICAL_MASK(vaddr_bits);
	return (vaddr & mask) == mask;

That, to me, is the most straightforward way to do it.

I don't see it addressed in the cover letter, but what happens when a
CONFIG_KASAN_SW_TAGS=y kernel is booted on non-LAM hardware?

