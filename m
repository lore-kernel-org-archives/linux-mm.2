Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E1ACCD37B7
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5218E0005; Wed, 12 Nov 2025 14:41:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CDC8E0002; Wed, 12 Nov 2025 14:41:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92938E0005; Wed, 12 Nov 2025 14:41:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 916218E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:41:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 261071A0680
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:41:01 +0000 (UTC)
X-FDA: 84102973122.20.BD61935
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id 47C2A10000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:40:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cOpK2e7F;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762976459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMVqKzNLRoQP0sbvs5442g9fKDoLzrGhO39ngYXqELw=;
	b=GvXh5x7pLkDcw8buCazFU/93E2gJRoPNbXSzjG8+XABGuiM7p1kF+sjx0VBu0/PHUfehow
	IA/+n79ijxiPT1Ejt5/7gBU2XwnNgafqHyd8yhGVHuikRoKOEf1VmWv8HuJWurevp1kzdI
	tK72Cu7f2+SIAjvZeXBZc5kC4Zm5Mmw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cOpK2e7F;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762976459; a=rsa-sha256;
	cv=none;
	b=RaZfGYOweGxnQujrWLYZ0xYUMtC8KBBmHMDuPUHTWEQYZB8LO80I7zGOsnrC3+01OT4wq+
	n3sg3TO+Eo2w3+nj4tTVBcDjcixq2p4QCw0P8E66oBfNeyT0lfIWRPuyU8+HV4O5ggzUfi
	wHX2CBJ3wCoJeeX/2tChMBc+a2gKVTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762976459; x=1794512459;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1CEb0exxHNbFTNrWD8OFik1gh5Iji875G0YGz0rm2tE=;
  b=cOpK2e7FY2rMKfadGr0QcAd6x5bJzCwABXMRzqSoSSqGZy0D6UHnhILr
   MKgkrpIlMNKbXFD/ct6v/cNZTJQAOwJ/izP3C69lxNVgjUPtqgFeA5dzx
   hKHb+h2KfWT4YaDqY4jJj86w8xFavNuCRaB10A1u39ZZCsYX0yKLO/PjF
   zkgwFcYk4cN/G4AtNA97DnoWE1YFVKyND5N85w9t5v0gARVfbfzudPHIj
   FjUQlcQQn23wOghiRhavv6snmagUSYNcmiiBZE2CakCg0dXCwKJUqoLgH
   WJ8KmS0T/wThRjzdrymmjA5n4+F1NTUrppZ/B0NVACKdCvW0XV2StUrHw
   g==;
X-CSE-ConnectionGUID: V5fUirKlSFO55OnkJeutFw==
X-CSE-MsgGUID: qn3fvfGZRSCdou/zyfLNNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="68899804"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="68899804"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 11:39:43 -0800
X-CSE-ConnectionGUID: /0qMLToMSJaGNFV1iOZRcg==
X-CSE-MsgGUID: OSGF5WF3QNyy4bQejpbmWA==
X-ExtLoop1: 1
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.108.22]) ([10.125.108.22])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 11:39:41 -0800
Message-ID: <0dbdd1ff-bf23-4306-bace-97f745800c13@intel.com>
Date: Wed, 12 Nov 2025 11:39:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/21] x86/mm/asi: set up asi_nonsensitive_pgd
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
 yosry.ahmed@linux.dev
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com>
 <b0fb40f6-8baa-498f-bb88-50113cb80f53@intel.com>
 <DD7W6FACMRPU.BXJCZU93UMVQ@google.com>
 <9502454a-8065-4a65-9644-2b7fe0ec5f7f@intel.com>
 <DD80BJMZM5EF.4V737FVJY4F3@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <DD80BJMZM5EF.4V737FVJY4F3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 47C2A10000C
X-Stat-Signature: apc3gixw7d7regg7358zoeaqfbqdetfx
X-Rspam-User: 
X-HE-Tag: 1762976457-153338
X-HE-Meta: U2FsdGVkX1+yNaj9rmJ0tM1Zg+nAFO3T4Tx1+cySyDxZFFY0JKfXgA7uY2RV9u/ely5EsCv2rETOu8zHcOoz+gmyYmWxAE9+abK618G8V7l+FxgQAiriTQ0D7Y8VwPULsO+w9o4Ob9o0SP7UriKjT9gf+lHWVmeoWEGGOY1iInrU3ODfoVBpzS0V68cD5ZwnooGRUAquLzuAru5MDm81dos4dQNlsyL4EzddQtjsqPg7V0KXZ0hl3scPpt1+rPoVJfQlB5AIy5bTtBu65fABvFdSPYF6dkxRiOa3zlDeeGiGoDDMJAa8VH7/8QbmiHF2TRMEuSXv1NxctM1u/Wqorhl0v87ysz9po0IzqSEOoWLT4bHWrBglxpn3iRvzCYMkEA4r2Joll1frU5G9PzmLB+2UZfo5kpa0KZlf7Kv4cB/NF+Q7yr5FPJsPJ9x7EiWHcsFPgKWPqUTsfWMCMmLoQtPXpryMpfs8lqvOBIFrNJU+efSAHOWSjB3632AQaRp56TH8Px0ZTmzdTUPjd8ZyfUglOrzh/0XXlbra0nkCkmKMvszYDhmghjJafc2Q8wIDh4FK80yPM4eFyOFamXEwW0GKvbVI50Bmj168/RQvEwUvnKgTc/nnKWD40dFfeI6JEE4O9SusgD3dASeospRwG0YIe42eADW7vV+LnYBranB2iR5FtWGjw7yWen8gkNWSXH4loHgT/T8+wONVvOnVyhf+5EcvGEYkD7HGgr8tRdO46FVdz3MyXklruEO4PSEQdW7rNS5UQM6VXOS10w3eb908HKgvF6gIyCLVo1upSRT+ye124IEAlJKopiazvi4paIh7IV1ORozRv8oEdBFVuWKMicGPg6RjlpY1OFUZ07kP86Utr/+knU1+ZE8sL+B7R8Q66BqWgOhg1nsrNVYoWd254VwVoSlbq2DU6RjqZu22AAFDwdD0LvZrdtSYkajK1KQ5VdZqK5DB+nNaF73
 0D/YdaoW
 RRWGbg+8YwODWv5fW+YgDTMAEPzTuNg8nVUnReTjtO5um6jUmUYHmfkTypCipFDylyY4UqY1DWN0rpH+oGCUtv2BlFThuE9lcnEzvMOiMP/RUbz1i7urs/d18Fwzrj8x4ztoMSmXNMz2yspnXn55gGkBV12ztBxEAV7K5UB6H7I84AzfOjf/aXKNCCJckHhuDL0b0JtKDhX8/GHD652FeZu2jfDB2JjuTU4YUUBkccbmrez7HEpzfULtSNW9z0HL1x0OW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 10:19, Brendan Jackman wrote:
> On Thu Oct 2, 2025 at 4:14 PM UTC, Dave Hansen wrote:
...>> What is the point of having a pgd if you can't put it in CR3? If you:
>>
>> 	write_cr3(asi_nonsensitive_pgd);
>>
>> you'll just triple fault because all kernel text is !_PAGE_PRESENT.
>>
>> The critical point is when 'asi_nonsensitive_pgd' is functional enough
>> that it can be loaded into CR3 and handle a switch to the normal
>> init_mm->pgd.
> 
> Hm, are you saying that I should expand the scope of the patchset from
> "set up the direct map" to "set up an ASI address space"? If so, yeah I
> can do that, I don't think the patchset would get that much bigger. I
> only left the other bits out because it feels weird to set up a whole
> address space but never actually switch into it. Setting up the logic to
> switch into it would make the patchset really big though.

The patch set has to _do_ something, though. It's fine for a patch
series to add code that then gets turned on at the end of the series.
But, at the end of the series, it has to have something to show for it.

If the series is small *and* useful, all the better. But, if I have to
choose between small or useful, it's always going to be useful.

> Like I said in the cover letter, I could also always change tack:
> we could instead start with all the address-space switching logic, but
> just have the two address spaces be clones of each other. Then we could
> come back and start poking holes in the ASI one for the second series. I
> don't have a really strong opinion about the best place to start, but
> I'll stick to my current course unless someone else does have a strong
> opinion.

Yeah, but the end of the series has to have holes poked that are
marginally useful for *SOMETHING*, at least if anyone wants it applied.

