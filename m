Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48EC71099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27076B01F1; Fri, 20 Mar 2026 15:42:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF2E6B01F3; Fri, 20 Mar 2026 15:42:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15396B01F4; Fri, 20 Mar 2026 15:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6236B01F1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:42:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 666401B73ED
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:42:32 +0000 (UTC)
X-FDA: 84567463344.16.D2A2E47
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 73A4A120010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:42:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P5qqPS52;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0K+L0ClbJ/bRAdnADzPSD6S/ZpOOnM5XsJIbMck4D/M=;
	b=ZPTeB851GAxRAxf76JuyBx6f0Gabky2XVAwwlfCKmawSNedQ1HUh7iVjfjKlBcD5xChWnE
	osnxPTkFrY9oAHGMeTYfWr45JxRUklZjru90XTX9SeWSqe8jXiuNHsyjI9h8c6nBvLYq0Z
	TbuKG8DQL45XANc3j8cNnz/1x+3nMU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035750; a=rsa-sha256;
	cv=none;
	b=Azt3/i/LEaAq1Yt+jTuWf19bpCIKz9sX/gEgW8LHeT/JD7VX1oyCB+mwxPEdYsAuvKtvIC
	iAELEHu0ZCgzcvYsBxi6b5Ej+pOOMlvYAzEFxF2LTE767qe8KHynBfXXd4d9Ra4QTNnA8x
	Cf/vZnSX5Q4vXnCZNUMrvucLdHgLcKE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P5qqPS52;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774035749; x=1805571749;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FIjZQl5XcTwAksnSQQzJWtlGlwUvvwlr0fafm9U4Dvw=;
  b=P5qqPS52T5AcbgSR3CFuoJfAS2ap7e1FvL+PxbU2BFM09CHmfG1WDNrW
   mqFjDP8JuDVYwPs01b3JBSZhJtM0Ue6hOZz9ZNXnE3OkQl1cWuwGVql7a
   2ZCdU6SnHawJFKSCzKxIDBB8GSV9DyQGkcDGvuhaGK+Fx4oXnu2jjFsqx
   0SXYAjouS3e0J6isvqc5weJZVOtobW92qlLu8HMo/HnA3i27BUJOIPRnY
   jCzg6yHyXayjuqTTVnz4JNN+QkEEL4M1nA8xVtJIFa4YgIpVkCr3SCLoq
   n/8ko3/Bs3ux1A94nNlMG3HXo2y5M0E401nmNmSxBIkn8l1S0R4JE7pzj
   w==;
X-CSE-ConnectionGUID: RoOGr5/BSnCBdg/70iNPOQ==
X-CSE-MsgGUID: g8IqWIcTQ9Ky/KeVrZTCOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="74145356"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="74145356"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 12:42:28 -0700
X-CSE-ConnectionGUID: lu07U/svTcOi6H27MkjM+Q==
X-CSE-MsgGUID: kCOGK3keQBSfNRoTO4D0Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="217205494"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.109]) ([10.125.109.109])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 12:42:27 -0700
Message-ID: <554c886f-6678-4208-8566-15aa140f6c4b@intel.com>
Date: Fri, 20 Mar 2026 12:42:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/22] x86/mm: split out preallocate_sub_pgd()
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-1-28bf1bd54f41@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260320-page_alloc-unmapped-v2-1-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fxdwdd3i54cf8qn7qj3d8b7iex5u6xwn
X-Rspam-User: 
X-Rspamd-Queue-Id: 73A4A120010
X-Rspamd-Server: rspam12
X-HE-Tag: 1774035749-649444
X-HE-Meta: U2FsdGVkX1+R1xVe4JRmGqyu3hH9AQdKi17ULW7vwKpN96ZV0KV7RIHDpfM6gfUgdOPfY4KV8KH46/yO+rY/pJ3deb0smPuNgTdAXJmmuTYQTM39uOn3PlWupqoepMG9t8wOpM9P6btujdaTJk/AU2MeVbhZjg6Erbpzxk0FpPLgtXWUPPRmUUZ5OXl0pFOg9oihS/EZ3dDp5wic6CWEaUP+SxXgbcoeycVgVbTszjCbWCNi7i95xFxHF71mOGwEt2xOg+rqvUVcVSJv5m8cn2ZpaI3j4Rk5XzsYK90BhkEi54ou23+u9DpjsZZQdo6HjL/dtDjeYM9CH7RClKdKp4/0qKn4iL72KRGxt8Y55vaMA837EOOqGHuLGGX5rGSe2DqaX+xFfZyifTW1KauJY2jEcNU+mG2moi+8KXStVg9DpMg8jDD6dvKSrKP2eTQklPugAUmWKWbbJRpbJgRalZ/L3Hr+YKcXRLIBP0VcEhMCkdI7uJk6wdtw4fLlnKDMnI1tDLWCrd8EhCAyamq42XN9Vp0xkY87cJIVxLsJPqnrtvME1h2rO0hPQcYD/XtNwefV4yYsnJJuRPsfXoFDmpd/yD35hvAlxy3VZmTb1Wbb5YzziDJvTtW0cGdfiNjmkZqjWJ8NpXg61fZIXwJKmxS7Y3Hcx7Kd6lWEyMHFQk+bRSWbP8AZR6pfSxbLTydYx13rUyH2h6O6Wjwzn4kEIHpXKvAu9V13h1J0X2u9OEvI9VehgAzZ/xKGo0FVa0dYjHLDOsT/NkFVmCUNYhK9Ebuq6OrIR0RsxcMRxiAU1qZTCIKjsefzti4GFDH5yqR5N8xrg3ijoDZ4xpJAiGoMaYOdFM0vVDPDUUaLxPZ9MviVffc6aprGorSAkYlfTwc1NiC2Z/BSzQUc3febJT0XYXSQRTNXuzYaA9PKVpJH4qFgIlYgTgrtNbcOc/LU+7pKe1NiUTxWHRHL63uyus0
 iBnpyUvb
 ZNNKTaIc8GFRzSW0ZmyCGFPVi1lUlRDfIKFPcfprgNt3l4uubbxV1OKAdD4w/2nBEIs4+JM7RfOLQym0i4eDcLfLLunWEv5xD7WlhupsEYZ42ocieQNdof+tN8TxyMOXRdhIZ5AszWsoV2Ld2TyEcPYnjlBrqH/3bwSU2zeXm+m8e8aw1McNMJoTxpvUEINgFu9ZCMwposyEaktIrzGMGLbAyTAf4AbuuHzIWceT75Pjil11Yq/X9BLfU5t6lCQzD/vLJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 11:23, Brendan Jackman wrote:
> -		/*
> -		 * The goal here is to allocate all possibly required
> -		 * hardware page tables pointed to by the top hardware
> -		 * level.

This comment is pretty important, IMNHO, and you zapped it.

The problem here is that the per-MM carved out space is PGD-sized. You
want to make sure there are page tables allocated for that space. But,
if you say "go allocate a p4d" then that will collapse down to doing
nothing on a 4-level system.

So, this is effectively:

	Go allocate a p4d or pud, depending on if it's 4 or 5 level.
	Basically, always allocate the level that the hardware PGD
	points to.

Could we put a comment to that effect around somewhere, please?

