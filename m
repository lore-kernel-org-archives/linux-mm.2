Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657B2CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 16:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36868E0003; Thu,  2 Oct 2025 12:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C348E0002; Thu,  2 Oct 2025 12:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21ED8E0003; Thu,  2 Oct 2025 12:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90D038E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:40:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53C1A11A645
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:40:38 +0000 (UTC)
X-FDA: 83953737756.13.76BF906
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68765180006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:40:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wh5z+je+;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759423236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UI2O/Ta36ByxCChXaJmYqERAVkz/MEfA5hrAWV/nVUs=;
	b=C73+Bd5gtAWe7Y35BS5NJ+X1aMQ08PUtcEtuarE83GbXaqrLAS/JZL0dTlTxY+uPG1fRFP
	uSjkRQtAim6aU1MHdBKnxCmCl/kHnNfpzQky4yxyWDyDj/90EuvAm+vZA4Gd5sqWM4fCAv
	fjJtwiWWyWYVk2jqsbHC82xP3z95GXg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759423236; a=rsa-sha256;
	cv=none;
	b=IBT8cmNiobbX7mDq8giJsTgsj2LZ25FrCFYfQca+/I6TTabnOEl1YtmsNlOoJHudSnwnIb
	Uw9+kZRxdgacvhldAIfTj7dV43o5fYS78WdYNjD5mRqFYKwI0i8cdRJgIzGf1AlOWTly1e
	CzjUZPGSEV+rq3vu3WaSqIfCPedkWF4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wh5z+je+;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759423235; x=1790959235;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ibke5hIrVui4nGEtrIYn9QjlwZMC043RVeGvmwn63Ww=;
  b=Wh5z+je+1uCaKMdvqxNYfTWMajdOcweMsulZCnGyws21P6TpJuo4DXEM
   JAGSJw7iBej7IchAqj8h7wRDWtukpu6l1YTucEhpkTvIO34zM9nQEe5hm
   yHKSWCeal7wR0BiSxqb5sirgzGzXs2C2sFRTl9SF3whON+X8NGnn+d4ST
   2tDD0nJqMD2dwnQWHQtn3Ky1UdHkLxi8XPm3xOkFgEx5/+DUAls1v75N7
   VWBZDdR5NVwCrx6MqQrcX8zY6mCP1i3xtq2KrDHtWnaud6gKSYIc9WhVC
   6IGnqT0tfoWZ55lyyvkzplxi29Y5to1rRyfdqbHOjnx7nt3+BF/KsXrE0
   g==;
X-CSE-ConnectionGUID: mZcENxTGQY2cARB7zJx30w==
X-CSE-MsgGUID: 3uh2wvZfQXWXezFRwKQqGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11570"; a="79135884"
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="79135884"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 09:40:29 -0700
X-CSE-ConnectionGUID: 8u4u+yw2TUab9+EwTMdbRg==
X-CSE-MsgGUID: IdoaEtPSQkufnv7O5PzOhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="183484713"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.109.249]) ([10.125.109.249])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 09:40:28 -0700
Message-ID: <19e5012a-3c58-4696-9e4e-39e2b7d2b5af@intel.com>
Date: Thu, 2 Oct 2025 09:40:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
To: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
 mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
 david@redhat.com, derkling@google.com, junaids@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
 rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
 <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
 <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 68765180006
X-Stat-Signature: qcjq34a6b9qzri3p9jd9q5hpm5ounpha
X-Rspam-User: 
X-HE-Tag: 1759423235-919141
X-HE-Meta: U2FsdGVkX1+BE/gjzaVW1SMjh5NXVrpYzp3u+v9HQrKamQudyccmzRR2n0wCSwAclIeB8xcQxRUA4IFbzs7sT6amuZtVZtIYb6L8bhc6hpW9LXRAwN6ZYIbdCQYOdmdG9P8AMGE3yRly6BUPHabrNrJ1RYcVP/xwEe//lYbWM7mBbQbqEpPvIYwI51qdH82s470UmDuMoExi/WH1IOys4szr1V27BVU2lMXTykUxETA5u3hVyEX8V9O6YwXSy9G+lm5BaxsgHuHs7MPLUzTo5qJiovBsv92Yy/nFynXpIP2w4RKFWKXOyWcUUnByPF8m8Pr/tqVHuEeuczksRljwm2xmNIBjvKrQMrWBFwdO+aO2KLM+uJ0VjarxW/l/QH9d8HfTozWeK1MRxcYUYXoETtr0Pa0tVatwo1cDs76yKotJJfRDKRuL22RsppHj/RdgAFnISi0DXqEj9+mLz2ZcTSshZqA/oy+CAaJL3u0hrPHhYecQPo38ipZ+yml1rdSaGt0yqOfEJCwIWp5cWAPkez3xJ5DLQjjw41ug0LC8zDSw8Q53eiXle40KRwR7E1ZA4zNHmSAsZGblZ7o1t8dpVLycZXKQ9nAjWVcYN6NDH8q1AQ3t0lnhjURDfY6IqpdgfQI/zR31LkmGLJa3M+Ro7A8xFnS7Z9FO5qPEhRanDDjtlY8Rxsu9hBt+R5G3KOAyK8JkQJYTWSYiH0w9Ma/9QsBMJYlGaJRMH8rnt8mESU+VR6dpv9FzIrolImEy2gUHok8CpdtM3q1YhTaJ3HTeZMWbNmB9A5u5NphqtrtWm544nTTh8EZMsAtvVx47dpaxrlQD5ovkg7Zc//qURTFNXAsyX2BsarpuzLRYTg3PuM+YlH9KyymwLPkKQ5odXH+eGg2xMwgxo/b/2+hkTkhAW7kgdwF+guHeaRYf9ZPmk4SzIW/XXzkbXPnS2ukM2X25jbmDrux51Z3fwpFkjdz
 /LHj+7Rd
 CbEBDKKGNSNjHNupA2k40XdlAq/KhvYyEl6TqCbttn/215FQcsRw5QR14LsLqzmjv+XaJ2cMPyouAic8IRICJk6KlLDJj7lDTW5lvPuGO1+k20jM3F06VZaEd5NVUOkusYD2QtUqIWbF1GL/AnR0AsktVPvn9KO+w4dFkS3uVdUlsuGyRELV1wcB+3jKqBWKkldU0eu9wiorIhWk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 07:31, Brendan Jackman wrote:
> On Wed Oct 1, 2025 at 8:50 PM UTC, Dave Hansen wrote:
...
>> But let's say someone is doing something silly like:
>>
>> 	set_memory_np(addr, size);
>> 	set_memory_p(addr, size);
>>
>> Won't that end up in here and make the "unrestricted PGD" have
>> _PAGE_PRESENT==1 entries?
> 
> Er, yes, that's a bug, thanks for pointing this out. I guess this is
> actually broken under debug_pagealloc or something? I should check that.
> 
> This code should only mirror the bits that are irrelevant to ASI. 

It's actually anything that has _PAGE_PRESENT in cpa->mask_set. There
are a number of those. Some of them are irrelevant like the execmem
code, but there are quite a few more that look troublesome outside of
debugging environments.

>> Also, could we try and make the nomenclature consistent? We've got
>> "unrestricted direct map" and "asi_nonsensitive_pgd" being used (at
>> least). Could the terminology be made more consistent?
> 
> Hm. It is actually consistent: "unrestricted" is a property of the
> address space / execution context. "nonsensitive" is a property of the
> memory. Nonsensitive memory is mapped into the unrestricted address
> space. asi_nonsensitive_pgd isn't an address space we enter it's just a
> holding area (like if we never actually pointed CR3 at init_mm.pgd but
> just useed it as a source to clone from).
> 
> However.. just because it's consistent doesn't mean it's not confusing.
> Do you think we should just squash these two words and call the whole
> thing "nonsensitive"? I don't know if "nonsensitive address space" makes
> much sense... Is it possible I can fix this by just adding more
> comments?

It makes sense to me that a "nonsensitive address space" would not map
any sensitive data and that a "asi_nonsensitive_pgd" is the root of that
address space.

>>>  static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>>>  {
>>>  	unsigned long numpages = cpa->numpages;
>>> @@ -2007,6 +2033,8 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>>>  		if (!debug_pagealloc_enabled())
>>>  			spin_lock(&cpa_lock);
>>>  		ret = __change_page_attr(cpa, primary);
>>> +		if (!ret)
>>> +			ret = mirror_asi_direct_map(cpa, primary);
>>>  		if (!debug_pagealloc_enabled())
>>>  			spin_unlock(&cpa_lock);
>>>  		if (ret)
>>>
>>
>> Is cpa->pgd ever have any values other than NULL or init_mm->pgd? I
>> didn't see anything in a quick grep.
> 
> It can also be efi_mm.pgd via sev_es_efi_map_ghcbs_cas().

It would be _nice_ if the ASI exclusion wasn't so magic.

Like, instead of hooking in to __change_page_attr_set_clr() and
filtering on init_mm if we had the callers declare explicitly whether
their changes get reflected into the ASI nonsensitive PGD.

Maybe that looks like a new flag: CPA_DIRECT_MAP or something. Once you
pass that flag in, the cpa code knows that you're working on init_mm.pgd
and mirror_asi_direct_map() can look for *that* instead of init_mm.



