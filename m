Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 225FCC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16256B0099; Tue, 28 Jul 2026 15:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEEAE6B009B; Tue, 28 Jul 2026 15:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05E66B009D; Tue, 28 Jul 2026 15:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E48A6B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:20:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28FDE804AF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:20:46 +0000 (UTC)
X-FDA: 85039152492.28.5F74614
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 728FC1C000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:20:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UoSsGgyp;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MF5VoMwEnUVISBu/dFwWaOtJBONrOWPjC0YQh5tRsCA=;
	b=WYZPMnQmMoQ7snk7VxosZsAPSDf6RYhH76QS9k3hO067DrTuFs8hDISqU3ntABLEEPwT+W
	l/w+1eHLz4b31OFhFNkiTVEBua/kaqyIr2GT9d22sXCvfI7E+2tUjlogcLnNQTKPKiFWTv
	OwKA534BOseVHVTSK0aBoH+9MPcVWew=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266444;
	b=JzFpLWfx8eVvLVOoCP0JTMMLWswBi7T0Y5zm/C7ARt22Tcs6o0qBrLNMtid4FubVp2Ne5i
	lZIZiwR61C3Dz4sZMtfpEJFiXyNCcprHAxI8WRnUA0YHwKslUQ7n8dILlrlAKrXC/q/mvW
	DZ3gQeCjnWaPe46hX2QmPdiBBOCS6zM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UoSsGgyp;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00BAA60A5E;
	Tue, 28 Jul 2026 19:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084891F000E9;
	Tue, 28 Jul 2026 19:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785266443;
	bh=MF5VoMwEnUVISBu/dFwWaOtJBONrOWPjC0YQh5tRsCA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UoSsGgyprqujUEoEwo3IWrczV2nXTypjWlduC39SIC5D1C4LMzurogequIdI+/YRP
	 2bfp3ATBpM+Z/wPJUH+gBg39Dp2Xrk0OQZv/uLQlIdtB/1O72zsLfVoa8Bot5loDNN
	 0ZBbu6ON8gtyKuSZnlk9GD83BNiMAyHsY/w6k2hoBiSxr4cfsNKuTxdtZzwRYztAuk
	 CVpay9DMSJ72b61t8hkML59aGT4IWsU0Wd2QwiAigIy5Gnk72UgT1jKtdA85YL1oDn
	 oi8HebVh2DBWxB3wYxi3lN+xG7sCQU3JMmQ4v433hGuBgKAwTERp8H+1YsFr4ssD9Z
	 nbFNEtHyEDL2w==
Message-ID: <ed9e7308-09c8-4631-a012-940cd6e11bbd@kernel.org>
Date: Tue, 28 Jul 2026 21:20:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
To: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bharata B Rao
 <bharata@amd.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
 mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
 raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
 sj@kernel.org, weixugc@google.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com,
 xuezhengchu@huawei.com, yiannis@zptcorp.com, byungchul@sk.com,
 kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
 balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
 donettom@linux.ibm.com
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
 <amjz7kIDuZH6gBx9@casper.infradead.org>
 <amj3jbvruEiHIZvi@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amj3jbvruEiHIZvi@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 728FC1C000C
X-Stat-Signature: 58r7j1ctmetn5tz8976641j8tbh7888q
X-Rspam-User: 
X-HE-Tag: 1785266444-873330
X-HE-Meta: U2FsdGVkX1+4ck/f8dau8mwceVoyF5lBqAoFC+v0fd08JhFuH6qQYJ/UTd5Y1mefjPMubx3Vx/SEsxRcX619ngjAdcLOmm6h1OiHObpLDgwMtJSU6cuRenMWq8M52VadDBE8+OyiNwbpe7QDobzNdTm0Rd8DZo62S6T6nbgg5i4GEcXehCVr6h8FaiPfPxH60Mj7/uANVik4PTD5f9+XWvy03YrN6jCDNUz1H7vKrKoF32dotK3TUSsc0W7z0YW4KcHBszsIro7flFSDsjKPkc8MART2axwnlwlkI4OqTbBvuq82HNiamNTrf0rfW4UYgatTYN8W17DrTDwPMaZgHmjbR2yHiJbVFUCOciRWRLZiZTBEoTUC+MnqqxQShcd0qrEYCxNP80Jbtxr+RX4yA7OjrSoi1COECZNxqfMQDDvcRer54wCLev3E092PzaZbgqOOhUOcIodGpZZs0pQV64Hc4fyvzXVdDGo72mk4Jem5GavLVsBJAolFFAmdzYjCkWcOcNBi75V1jmIi4HXOkopQhrwt8DgcnY1uhl9mRCwKeqRQsl1RcRRsovJW2n4Qseu4TrXPQjLFa3tPc/NGAGb1C+se4Y+YEFLm6lmoOQp9979Drcrsx5/d2dDk3ocUWWyFdX0Ff5chMJOglPP9kdWUoN9/j0fjOHHwkE1+fr9ygchHbnA+zhJhyswtxuLkdjOphsk/X/2kZrz1YQHOkWu9JgSqrhVzPRaiOuyRWpD7AsYVEN/T1PFUINkELXmOldrRGmGw4goi7kVMkzjgCqh97Bw2nISnaXe4ipEhswJoCKTjMSUjk7T1FqwX6GriwadyL/K29Due0+a0Va7h2Yt0CUoM2Ti7PbguEv7GmHRMjTvvoLcuf5Hy6acWt/WUptDRV7xQQcUHkb+PFS/eeI5oOIWl4VvoC91RblVlNnOmC2uYm/nr4gDBLj2pOJbTNeHIkHRpvrVnArPWmla
 dK8NsnfS
 7Xj5dRJUlTrv/7MOTQkfTPjF4gMUni16u+UQAgU6GZxSH10psQsQZKHcZdjjiTgtHHdinIt9hdfvSfUXzNFjG92+qOSWcHUKUsA2+VP8H7JqMpDHpyP6b+mtFLU0WZwGrOQIZs+odOj1TZ2WRFt8XOB7rqZDZz1FPW2oIinK+Wg1TmeumeYKKOwY6dTJGcOLdShEWIQpaXP6GfJoCnVCQqm03gbihbg/Ti+BMvU1ZDkvB67MMYPIq4vdxH5+5yqB3bp5MAaMc+blQQGQhlOiWOzj/QEdYS5Nrh4oe5bfvhXNJXut09g7vZGPiJxBeZsU+HqiE/JIOIBITqWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 20:57, Gregory Price wrote:
> On Tue, Jul 28, 2026 at 07:24:46PM +0100, Matthew Wilcox wrote:
>> On Tue, Jul 28, 2026 at 11:14:01AM -0700, Andrew Morton wrote:
>>>
>>>
>>> Can DAMON be used to do this sort of thing adequately?
>>>
>>> Thanks, I'll await review input on this.
>>
>> I don't think we should do this.  I don't think it's a use-case that
>> customers actually want; I think it's something CPU vendors think their
>> customers want.  I've said this repeatedly over the months this patchset
>> has been in development.  I say no.
>>
> 
> I've been consistent about saying we (Meta) have been actively
> interested in this work and helping to drive the design of it.
> 
> So it's not simply something born out of a CPU vendor think tank,
> we're actively working on solving real problems with it.
> 
> I don't have data I can share now, but I think it's fair to wait
> for that data before faith-merging this on the hopes it's impactful.
> It does make it more difficult for us to do fleet-scale testing
> without it being upstream, but we'll get something.
> 
> Tiered memory is being deployed aggressively [0] for considerable
> value, and is here to stay - like it or not.

The diffstat is scary, to say the least. And the x86 stuff certainly needs x86
maintainer acks.

So far there is no real review -- we're in v8 without a single tag.

So this is far away from being mergeable.

I'm afraid this will need a lot more discussions, and likely RFC would have been
still appropriate at this point.

It's a shame this work was going on for quite a while without feedback (blame me
if you want :) but there are only so many hours in a day), but the main problem
is that this work in particular was not perceived to be high or even medium
priority so far.

-- 
Cheers,

David

