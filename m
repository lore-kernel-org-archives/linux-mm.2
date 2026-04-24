Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84EFCFF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 22:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D2D6B0005; Fri, 24 Apr 2026 18:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DEC66B008A; Fri, 24 Apr 2026 18:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC606B008C; Fri, 24 Apr 2026 18:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78B316B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:21:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D1C0120163
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:21:36 +0000 (UTC)
X-FDA: 84694872192.27.43A00A7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD89D80006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:21:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gXXj5axM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777069294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zs7kl0E7k4HAebgjnMtD+yvMPHAmj4f+tt+lglgxW3E=;
	b=1IgGqnAoSoeMvGV4k5zbYyRymU8JUBNNSrAKgOK8fuek+UztRdS2TFEkkSWtlaMse/aeNB
	tjRUkIkrZxt6LuykpCfkXIpWMjZSZZadn8K7WDchwJUsA0DQguGRHhA0bpTWVc+wevZvve
	DFY4Puu2fjgVa10HYQCRwjRTPQppt3Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777069294; a=rsa-sha256;
	cv=none;
	b=B926FzQlG9x3OzbJf2eypw9T90Pwb0t7s/6Jr6WP8n32oQzgb+8e4eeI+XDgDopggNURqS
	AQ8wxuIzJReGQpvmr+UhTOlKiAF7AgS989kFU1PfugHUL08aYJEvgXrUDIshtTZOUL32ix
	rbFEYaMYatGFfISWm+aXGefoxBkOAWE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gXXj5axM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777069293; x=1808605293;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uE5U/TRnsonhe9AZmpobqbLi7ulUoDyCWPdOlYCGHdA=;
  b=gXXj5axMQSXrGzearcETqZZKVSkXtFnVAO5zjabmeRoqOc6BgTh+zk+l
   4TramIvxpeLAZSn2xmuBFCbUC7yVgCG5+mKsJrNWBsxiUoGur/OECJlMI
   Z4LuWN+LBd/wnTjhKzd6uRoC1hSVf4Vut2yNkSynbdQaMYxq1zbhk6kOR
   ls7hAXiIwm8RWNOfXC0pZWHS5Y32G4TMRCY+7ySy08+Ln9eOpZOLM5zMA
   faIH4fYOa/1U5/ziReauEnw5RYTBu2OkUc2+oSAYuJCfsRcbIcUcT3+M7
   DMjzTCuW2NqX9k/057mA+jFhJAdaByBiZRC9/RDzqAXw8bF30d0cGm8Wb
   Q==;
X-CSE-ConnectionGUID: 4GLYXEoyQbKUDYh+T5JPOQ==
X-CSE-MsgGUID: MVvqDED4TwmqCOOuiZcr5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="65588333"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="65588333"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 15:21:17 -0700
X-CSE-ConnectionGUID: TeWDlCjsSMC9c6fOyjTsqA==
X-CSE-MsgGUID: ejurBT7OTL+I8y/fVM45tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="237035212"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.113]) ([10.125.108.113])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 15:21:17 -0700
Message-ID: <8cd528ca-ff9d-4825-bf10-921ed19ec3c3@intel.com>
Date: Fri, 24 Apr 2026 15:21:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Stevens <stevensd@google.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com> <aevhw9xqz1pWA2Ow@plex>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aevhw9xqz1pWA2Ow@plex>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BD89D80006
X-Rspamd-Server: rspam04
X-Stat-Signature: awdmyihgoodzkd3dogz8z8uk78f9gzuf
X-HE-Tag: 1777069292-774017
X-HE-Meta: U2FsdGVkX1+mOR1+c8jjPH36CdCBumC4v1oLRqSv43BF5J+VcH71qz2WmlawVBVykuQPA1tquPdi31o29l8dCSajxZytOThMtibLKa6WQ2qJwXs4NreUMzWQJztDQVkkH06fvjdlrZ4beIiu+IZoDreIypsBJdCuMga3Ht/h35ZW/L1spl5dwn+gXnod5aCtHQP9yIPHPLx9krczwx2q7bhmDKihF52Vnx3X6pt/Rqr+esHCtmdX6aaO+10doQKtJXSfpLcHaLQFLu59g6Spj0VjFQmQn6uGWEye4TIwMuAQJocMazOl5SrmV1mACY/FULMFCopca4168FFMPTQ27vSX6ayQMCla7PPweVfGRi3pnYvSss57Na/RthKIjF5J/A76sZ2p4CmQl6mCI1Im+FSJa/Hltinmd5CdVB5zmVUj7d7f5RAT/DB4JfyqqwEBMsFw7DZF1sqTKtxpg4YULJSL/YWqt1CdYg4ZCFPnDpzsAzk2Pq6qFYab2DxrFKS7AWpbrXbgpSN6w5XKEza6ew8Nuh5SGWNTrzWkA0hyXf6H7vIXCkafAtX9SLqvh9o3GQfRzMNr1yt2YrmAyB0mGTzt1LIlrbcoSmKaQve8zbcUYc7hUGSU8s9ODe/vteTQQqcSw00Dt+ISUNFDkUROQs02lMFTz3ISzKmg0dQ5Ey5oFUPkNhHCDzbA85v0UVzhqM2fNZhmJvAn/UiG5g7VxtlMKE8/EOPz9Hxfsd47h/WlbkhQdobu/V16aDNM7Gah4U/FBCwPr4f144ZRxOqaRjmzWm/KzAWRtDZ66it9SYobxVRNiDMU9CU61aNt4KkgV1RKlIC1P+ev+0GMCh+hDHmjP36LgNzgJNj1TP6EpKNvNIR0FTHRPLUHwqV6mGLbDaqp811DGwwY20aXFRxz7d7rizGck7e8JZteZedvVsvVlJEEYcqAhEh3pX2Hd3epnsw1lGKSl8QFS9YthFo
 9NEl2Qze
 yrAZxcA9fjUUrJpAimnjMQZge1N8ZZ8Zm9OGzueStZQHpnaA0d8S1gMXj6+1Wf22pE400N4fFs8nOQILfKGJ6qn2o71kKn7aVIrFGTYP12xIWkeIKj9uKWu468pGsGntJJ4ugQosWFHGZNXm6AjXFI1OscP+UYkXeIxlkEAccbw9RKFebfNjbK5WMMNF2tanGRgmOFd+NA8bWcN2gCsUmfO761rSpN2WWvpTE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 14:35, Pasha Tatashin wrote:
> On 04-24 12:41, Dave Hansen wrote:
>> On 4/24/26 12:14, David Stevens wrote:
>>> The question is then: is this approach something that is fundamentally
>>> untenable in the kernel
>> Yes. Fundamentally untenable.
>>
>> Not allowing stack faults has been a wonderful simplification. It's one
>> of those things that just plain makes the kernel easier to maintain.
>> Saving low single digits of system memory is not exactly making me eager
>> to go back to the harder-to-maintain days.
>>
>> I seriously doubt that this 1% is the lowest hanging fruit for memory
>> bloat on these systems. 😉
> This true until, in a fleet of millions of machines, you encounter a 
> one-in-a-billion chance of a stack overflow. You are then forced to 
> double the statically allocated kernel stacks on every machine, paying a 
> memory tax even though 99.999..% of threads never exceed 4K. This 
> overhead accumulates to petabytes of wasted capacity.

I don't disagree with you. But, at that point, you're picking your
poison: bugs dynamic kernel stacks versus crashes from stack overflows.

At some point, I might be able to be talked into dynamic stack as a
FRED-only feature. But FRED isn't widespread enough to go to the trouble
today. I'm sure the folks who want this also don't want to wait until
all the devices in the field have FRED because that even *longer* off.

So maybe this is one of those things that folks just need to deploy
out-of-tree for a couple of years, come back with some data to show us
that we were just paranoid, and we'll look at it again.

