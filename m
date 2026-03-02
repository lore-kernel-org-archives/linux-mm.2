Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6816EB363D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234EE6B0152; Mon,  2 Mar 2026 16:48:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8126B0162; Mon,  2 Mar 2026 16:48:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5716B0164; Mon,  2 Mar 2026 16:48:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB2EA6B0152
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:48:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9333A1A0337
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:48:27 +0000 (UTC)
X-FDA: 84502462254.25.52642C8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 08BE414000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:48:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HOHcd27p;
	spf=pass (imf23.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772488104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1qBZLjLlMYHzB9y+fBn0aD4mHxYinM6AMxL18Fcvuc=;
	b=NSRo9dvfEWKOYl9cRuREzprsbRYN01qjrg/t3N4Xkc0HPjG+0odR7fYZj/TwL6dWqZ3xUr
	UHO3LpdypriKcDTYtuC7M2TpoQte+n55ArScTgCSwt5MliOBXq+Fl7WTqtTsF93+S3ZsT1
	z+VHobCNPwLrOOIlYZw5NzEvyCaqrfE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HOHcd27p;
	spf=pass (imf23.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772488104; a=rsa-sha256;
	cv=none;
	b=7OHUlghx/HqeF9lNqSr/rbA6LCEEtj59ZG2KCwttWJcWwCkxV73QZ11g2Eesh0BnewxIl+
	BpZt119kLwz42fcLqhobnWD7I7CPQcajKXR/Jy0J0UGSvN37Vu3ABSzMumY3n82PpQRgQ3
	tk0x+UpLM1RFmtTHz2pC9Fbme8HZzE4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772488104; x=1804024104;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HDtU7jeq1RAWwfpuKLO+VZASTa3tIJBWwOvbqQermV8=;
  b=HOHcd27p2PiCSwN6lToTnREY3WwTZ6HI3ajUw/UC0nD8GxXvlMYYaAoT
   JJJtDuZ23toTpg8EYg38BofLlaQpqVyQzt5DB01jcOi3UeDBX6xTl/uPK
   APuS7rniqfI5i2zugcBUzAvMltWCWTX+vy8dnXbW40867jnKOgfCI3KW/
   CTpKpSyn88AxB539KHpNM5k2d6MJVfuO9yWFYXtqgjSb84SFw65jE86Gl
   RbciEKd5gXPPzWCQf9UR2Zm5Xok+Xo3usJht2SfZSd+4d0ojfDEVoaqeX
   J+efED2L1rEHnbBg+evfl0gbwevq/BbeR/Z9OxqPY6JU+6XB/LtFVOklE
   g==;
X-CSE-ConnectionGUID: xqkV83lCTNaMJh45bPadEw==
X-CSE-MsgGUID: KqvlzaWGQFiuFmUwzZNuUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73551637"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73551637"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:48:22 -0800
X-CSE-ConnectionGUID: UBFEFiJuTgWChgfI8GD9YQ==
X-CSE-MsgGUID: w8AcI93GQ/WYVlfeO1LCNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="240794701"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:48:22 -0800
Date: Mon, 2 Mar 2026 13:48:20 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <aaYFpEmiH99dryA4@tassilo>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
 <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org>
 <aaX2B9Efh0dBed6c@tassilo>
 <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org>
X-Rspamd-Queue-Id: 08BE414000A
X-Rspamd-Server: rspam07
X-Stat-Signature: aogrp96pajkeu43diyqrwj1ddccubqru
X-Rspam-User: 
X-HE-Tag: 1772488103-732084
X-HE-Meta: U2FsdGVkX19sprYKbu0WCsOyuMyvkDOZKPAOWHV7W5JIVOngE0hUGvLosDM9m1TVcqLqd2o4Fa9MdLq5t+Oy/InlZYzA8fmoAm5YYQ7opR1VmqIyON/36F9LBCEE4W+AaInm7dTFesn+/kDOOWm+0zp+xtO+7ag0TV1S3cUHbvikkcnjXqkQ4amhlQ0bCrVplZa2uDBdHHUzeaMIDc8XSDje87x59i2vjfeQVsggdZ1uOb1oYq8LqHKY4bsi4zzkNKxyjNxstDwCeiHJe8XlxMBhgbC0CKXkCzkpE7a9VHgOiS2E4TwDOnOzTCL/PXQ5jQ7aTBQ7Zj9vLwXSXQpvFm7ob5GbE7qBqmg7+S3LBrQawzgV2K1Ltv5B8uLK2LQR2rFZZUksa79/DNoqMnQR+3V1S0XDWUhbyGa+NuxAgOxJ+GZvZWIIQPl+2tFxKMpnrWChPoF7m+7by9a47pQtmUym36PKmMbmV9AvLAFGA+lCAw8iyL5fkohWhHco17AZamUqEYqI73iaDpIWJZoTQdndwcgKqOJwl6HSFH3x1k4ipInjnbK7e4CUcMmw275xTXchMwySD6+UCY34A2Qsqm11xr+eyJYsM9r2YdnSnqP2d3cytYC4Behwdqxx22LLgc/e+KYRuOkBQcNr8dcpounamSVQFqTzCkaT08lSdjZbG5hIabDwQEu3A2r+DTn+VCfv6WMRnrVwACRRofpf53EUE2gKh84EGrLd+hxcppIM4B/GIecguLoBWuL5tow41NdFALF+CGLakrOtEwUXzyEIVCZGezo5rN21+DgWARJWmJrtxaWdnWCebcSUuHQTIlcNJXxmviv/glw8Sblk48fwWJIevhtf01yoNuPBGK/3FqGfcOAlMzCn81CluVXiepnoz8m6kMl6GaAh1jZ1MvgJWXZx4L2a3b2RbXY9FB0UNRQol0WuEjruufXjVT/DnjW8imbQJiMnSTlR9HP
 55AXxjCB
 wCcoC0aZxhQYB4imkyab9jN6jAh5YqHAsfNvdQw5ZHEQV+35tU7Yrl1QKFc+Pp1ARCH/gcdCiifL7d12J2pNA4H6Qji8XydR0q8U8eiWg42QEZACOe3UjHeaDz/cSmMhQ/T16tNJTdbyE0VSJ9e2ZgtrfDZLRkr+G2tIjPdfbbowjJcXC7l0hGi+/Q+2WOUstqvEh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:05:23PM +0100, David Hildenbrand (Arm) wrote:
> On 3/2/26 21:41, Andi Kleen wrote:
> >> Especially after reading 3340289ddf29ca75c3acfb3a6b72f234b2f74d5c I
> >> ended up with he following conclusion:
> >>
> >> "KernelPageSize" tells you in which granularity we can mmap()/munmap()
> >> etc. Simple.
> >>
> >> "MMUPageSize" tells us how this granularity is implemented (or emulated)
> >> under the hood.
> >>
> >> The case we care about is when MMUPageSize < KernelPageSize. A process
> >> might have to know that detail even when nothing is currently/yet
> >> faulted in.
> >>
> >> Assume a process would perform an atomic that would cross MMUPageSize,
> >> but not KernelPageSize. Depending on the architecture, atomics would not
> >> work as expected in that case.
> > 
> > I thought most architectures don't support atomics crossing pages
> > anyways. x86 supports it, but it's discouraged.
> 
> Right. And if your user space thinks it has "64k" pages, when it's
> actually emulated through "4k" pages under the hood, that could be a
> problem: user space could perform an atomic "within" a 64k page that

PPC user space doesn't do it.

> actually crosses two 4k pages. So it must be aware that mmap etc operate
> in 64k, but the underlying emulation might be smaller.

Sounds like a very contrived use case, which I'm not sure actually 
happens.  From my past experiences most software usually doesn't use
complicated enumerations anyways but just hard codes something
reasonable (like in your example just always assume 4K worst case).
From their POV it makes sense, how would you test
a complicated enumeration for cases that don't happen on your
current system.

> >> I'd expect other cases where an architecture might have to care about
> >> the actual, smallest possible MMUPageSize it might be executed on while
> >> running the program.
> > 
> > That's fine, they can use the min, or just the first match
> > (which is always the smallest)
> > 
> >>
> >> It's a shame we had to add MMUPageSize, but maybe it might resurface if
> >> we ever support emulating 64K/16K user pagesizes on 4K MMUs.
> > 
> > Okay, so if I follow that correctly you're suggesting 
> > to change KernelPageSize, not MMUPageSize. I can do that change.
> 
> Not at all. I'm saying that we leave KernelPageSize and MMUPageSize
> alone, just as they are today.

That doesn't solve the problem that motivated my patch
smaps is confusing today and would stay so.

> 
> Instead, if we want better statistics (and I think we want) regarding
> how things are mapped, we should look into a better interface.

I don't see how a new interface helps really. Some of the problems
you mentioned earlier could be either solved today with smaps 
(e.g. handling the case when a folio is mapped partially and just
report the smaller page size), or are unsolveable in the general case
(what the TLB actually handles) 

A new interface doesn't really change anything given that smaps
is extensible. 

I'll look at the partial folio case, but will only handle
it if it's simple.

> Ideally, that will tell you "how much" of a certain contiguous size is
> mapped, if that contiguous size benefits somehow from TLB optimizations,
> etc.

The key word is "somehow". It's better to work with real use cases
instead of such hypothetics.

-Andi

