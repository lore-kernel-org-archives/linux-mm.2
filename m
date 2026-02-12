Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8586CEE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22CF6B0005; Thu, 12 Feb 2026 11:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC35C6B0088; Thu, 12 Feb 2026 11:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0016B008A; Thu, 12 Feb 2026 11:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFD2F6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:36:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67DD6160181
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:36:59 +0000 (UTC)
X-FDA: 84436358958.28.F8599A2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf22.hostedemail.com (Postfix) with ESMTP id 82CA7C0015
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:36:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cZVArcHo;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770914217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDMJ5LXpbDqnficmtwwvWgvy+SvZvSCUJvF/ibDTO4o=;
	b=dKWeS8lMHLb5SSEJxl9nQ4NDH/wrBXn6dxzd8q8zLjj3mhdeAwhpugn8TTpuzKrU9T/qxg
	DVLdjmiq9nVy4l6T/7cjhIXePSftS66qddCXkBFBlJzPC/jOQRV8l2DZBypfVqaedCcGy+
	GOnXqWpa1DzZdcS3Z5d18EwK9QT+dxA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cZVArcHo;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770914217; a=rsa-sha256;
	cv=none;
	b=NfM4zzOBcyKuvuri5cQ/RHNy2tWXM1Xdm36gGyYF+aR+XR35k4XTIAou6xDaY5T2R+wrsu
	A1z3CnXryXOT7bS7fFHszN/QyLmJIjvO6+DUmr7pQKb7rby/1LLl6L/WQWsoZrxeba4VsJ
	cGdnO2KEMwneSk93e+FB5Ng+4jIOWps=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770914217; x=1802450217;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6MRwUNz0oY7KOcisXXZYLPj4FTp5tbQQa2LCSYXG1Wc=;
  b=cZVArcHoINWbPQkb647vly9PuNL4UL09cCIjV+CCqmlCtfeS7HZqPfZb
   esthcjyilSZNwInvuaOg22fpNkppGfzTDXpvMXPGLgbE1aMuFmZsH5D8L
   tDkLFSThcCghDBVvaujVi5FfoUYO1XV0GGlSrBXXrBBgdUNfuYE4e+QEW
   gXgBvtMKacSUu1rwjoeZHNMV0YezJM9DwBpsF4Cl67zU2Gh75GkmklUUS
   +qnqXLlrlk1B1CKKqbI7r9avfXmRGmSyh7K0y2aX56fCgCoFngO/F9a0h
   UP9X/c0gngASynuVOazvSYFMG82V2ip5cnO4mP7rdCsrV1JuDRhLSNhSS
   w==;
X-CSE-ConnectionGUID: ToOZONo9RC67XexUzRkUDw==
X-CSE-MsgGUID: YJ0/j3NtSuK/vPOrauO99g==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="75935942"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="75935942"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 08:36:55 -0800
X-CSE-ConnectionGUID: UjKfZT5KR2SgE2CuVLOuKw==
X-CSE-MsgGUID: Z0neYE9tToSPannnpCtq7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="212681275"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.108.202]) ([10.125.108.202])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 08:36:54 -0800
Message-ID: <f20ec2ee-90f2-4ef7-bc3d-088f9ef6c38a@intel.com>
Date: Thu, 12 Feb 2026 08:36:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
To: Yeoreum Yun <yeoreum.yun@arm.com>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, bpf@vger.kernel.org
Cc: catalin.marinas@arm.com, david@kernel.org, ryan.roberts@arm.com,
 kevin.brodsky@arm.com, sebastian.osterlund@intel.com,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com
References: <aY3+Raf8eZqipCd6@e129823.arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aY3+Raf8eZqipCd6@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 82CA7C0015
X-Stat-Signature: pe4ipux74qwyc34t57gdxy7wdw58cxwd
X-Rspam-User: 
X-HE-Tag: 1770914216-112094
X-HE-Meta: U2FsdGVkX19W9s1G5/sEaRy26sNCBhCu7jBWidK4cAHHm/U0I6u3KDtaBPJOdqx5XkK1ccxeVrza+91Q8Hrr9ytgGD/wKNbkT1UAMrAUUGtVlOHohd6DXCifC7HL3bL/f+hL08BrraXSGrdJjIdyZn8+KhPl06wcZKQ9rN9rHvsSE8LywYf1QbqCRNDh1J6o5MuZsnrYq5E2f8YBXtO+M2NCCnz6eej3lYWnUkFHp5w0+bsChS4Lfbgj/cHHf7efsvC03h1655BiyPATiR/YNn9m8yfh8dG+GAymjgJ6qc0O/ja9HxAkQUtUww7+YG1vO+MAGurPR6EJhSVTX1s6fdb+wrWQOWqdVyfUyXOkJJgz4gtbAZI1/yVwkI0ti16kkxgZlgf25DiPbckn6WgcdphJdDDqiBDn308XO4tWBZIHFQVvctdDA58TlasdZeek3hHri7QmuHzX9oqFq6T12kEGXpS11OnH5X83Qbt5/HHUAQ2H4HA2HnQEswRjyEMB2fuWtYx0CmL/WkCtx7uSHBre12kVyEl7Ss7EkZucrx0F8OT8mPPBmgkRulvyy/WhrNmQj/SRQzGAP9ur/ovRMrvw85cO9lICzqWH4m3dNMluuNg+hJnpUZYbaXxLA7UgZIz1cbqtEebk2AlbPjJaOWOE6W+US4VKsnBIDs/kojZVF3H/w9RTuRve5P6MGMdrnrSnZI+bFgacUqX5ctZN5oy0I9xqhctihiqIJD1dY85dv46xiWYXhIm49GkPC6/SvNQhKpmzZq9+1DY4N8I3Vjl02frtQuY+xMi+WT+TQusqQRQY5FOt5q6Ci3qbOdQoLoz4LUcguTWHrrJho3Mm1PZugEOrwmrLR4RzNLrG9J7OlsUeXjsJwAL7zQp0Esm8yF6LCsdkRG4i9EzT/yzBvVq06lStZO9KoiFKUWM5rwD9gP8EEgUs4qqSWmhARS/e/4nRuQ6ez6W28vOneJY
 cA+UFgXR
 U1bUGtBs1KO0YqEQyGb7WBsnWZvsYl5Wvkgbbt8oRfYtqBLzlBbg3lrOKxUQKvnj7u6wYLqNH5oAd617uZ5AVx4teaN86z/bH6fUJvbEE7VOMzFrdqCQcnlss8TabgOrw0E7VpDUykPqeu19CyRU8iGgAOi3UQMyDc66a6SYFlJ6Nwys0kDinelTTwH11FGM/gU4xKT2Zd9jYuy0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 08:22, Yeoreum Yun wrote:
> Current status
> ==============
> 
> An RFC series is planned for around Q2 2026, and the experimental
> implementations for eBPF isolation with pkey and pkey-aware memory
> allocators have already been completed internally.  Using these
> implementations, we verified that eBPF programs running under isolation
> successfully execute several sched_ext applications provided by
> tools/sched_ext, as well as some bpf kselftest cases.

If you have code, post the code, please. It doesn't matter how ugly it is.

> To that end, this discussion introduces a set of new allocator APIs and
> explores more extensible API designs:
> 
>   - kmalloc_pkey series
>   - vmalloc_pkey series
>   - alloc_percpu_pkey series

It all sounds fun, but this doesn't exactly seem very generic. The meory
that sched_ext needs to access is super different from, say, what a
socket-filtering eBPF program would need.

So this doesn't seem to be likely to be true "eBPF isolation" as much as
sched_ext+eBPP isolation.

