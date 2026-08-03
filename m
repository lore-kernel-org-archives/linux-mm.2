Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14AD5C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A05F6B009B; Mon,  3 Aug 2026 08:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951EC6B009D; Mon,  3 Aug 2026 08:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819B66B009E; Mon,  3 Aug 2026 08:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBBC6B009B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:49:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F796C06F2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:33:43 +0000 (UTC)
X-FDA: 85059899526.08.6DF5BA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id B9A1F20009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:33:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hs5ryh27;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785760421;
	b=w86B36bECgV0/6mktllWq3cJVBQ7qmPo2I4e8dGD/3WVzaVQgxQLdVfUFQnxJ1ObL2xtxZ
	u4AhE2iQjyWD5+WnggBPDbsjD5adOG/mxAkHsq9aVXm0SVJz8COTMG4PCA0mjAEUjkXcpG
	Az+9m17tsPE5H2fWDqQMRwu2dIK/ILg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hs5ryh27;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785760421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vy1+fV5s8gyqoD5Qi6KhZFBtunC6lGeMJAfbBN3il6I=;
	b=qu7osJOzre5lSWHepdWWHfHLUs7O3QlLH/NqZrTKIkYaPztHqvbGYxDWTZuVuofHS3R2zu
	/GjCvKM1vl391/GbCf2pxWGDjYPQlYxLTtYx5eE7awfCUhBs4bzRLel8c/lYAeGzzdhb3L
	A40nFJABKeTL6ShSTlnE9fI6ZDxNI0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0439460A78;
	Mon,  3 Aug 2026 12:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378D81F000E9;
	Mon,  3 Aug 2026 12:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785760419;
	bh=Vy1+fV5s8gyqoD5Qi6KhZFBtunC6lGeMJAfbBN3il6I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hs5ryh27l8aUWixLIGvQrOzKbxSp0xKL5EqKNxeQRg/+ku7XaH/xFMeucicqAGEbg
	 e7Hl6VGynDfzwOmqxH4ZB5aWk1AR7sGtG5WzpdNSpLp1S/38zkNomvdOMODF515/gT
	 h0G3VFrjW4pOwG6vlfROuy4TUGDK/9VOx2OAy46NdtdNwWGKEGEuqrDhpW920MiASy
	 kSKsG4lWx73nhxW5bBfhR/v12Um4gTLiw1+G/pGmgNlVlBgyJhpACuJ0tjyW5b1B9t
	 z0c/255F+GjVDCdJDOa+a7FfvfA3Uh0DGT1JROnn5GPunY/Bre57L/E76C4NWWxJqt
	 yABWvYelP/kbg==
Message-ID: <f31c2c50-2239-4fd2-be3d-dd70c3d6140a@kernel.org>
Date: Mon, 3 Aug 2026 14:33:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm/gup: batch contiguous pages in follow_page_mask()
 and return them via a pages array
To: Rik van Riel <riel@surriel.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Aristeu Rozanski <aris@ruivo.org>
References: <20260730035350.1fc95dd8@fangorn> <amyUQahYOgov0z8c@lucifer>
 <e969b38ce882b32d041b7279499fddcd00f18b35.camel@surriel.com>
 <am2_dWJKZBzwd8EK@lucifer>
 <517bf6a8072a6e66f28f8ec08bec4b604f29491d.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <517bf6a8072a6e66f28f8ec08bec4b604f29491d.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j5hakjqe51oxs9a7a36yzcq46bdtzdk3
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B9A1F20009
X-Rspam-User: 
X-HE-Tag: 1785760421-33560
X-HE-Meta: U2FsdGVkX182oIPZgLYXTC2hiRZ9GZy5+rIt0LKFcUPHJ/3ao5+Usk+knHTUWxYv6Fa5wHACcVGwF3IbIa5sUci451VfDO1/yppzVE44JF5xNAsDjiZasLOER/rXc/pJPZHZ/CbEC60HFghSrNPOGhUoEjAHSdzWuKaQfqcwGbTchT7KnD7Z8u9z7BHBzYDktjIZ9fJwx7xlwW6O0fUZ040/1o2/IsffTcxxlM8umGTulHlNDK+uf3PW4KI2CcRNGnSCMMq/kao1nYcFDE9AjZ2eF9hDAjohtq8huQBDvFz2ajVbcPt6dxlJg7JpRekYbrpSdqBmrJvUC8PvoYX6CCanUr2NYcsulWpjNn6nQCM21BVemgjV4jCAEeX8VRV8NEoTJ5D68qYwearun09Mo1lw6dCQ16keK3ApyR/WLEO5DzpkdwKCzwesnu6QmPmLvniNTqEMfycw34XRGZc7fhUnn3ZryFh1c0JXadiDH28D5gxE6a2uExhdqG+zJXhinudeb76DX4PwwjjG9/4uKMAjCsCvsL7GZzx+RpuvxicxIXLczEBCaDhN2HN6W8yzCYxfTHOJ5G0v5fRPxMe/3Np8Fk8rvf4+VGOn9UhGOEdxQs0OFwAakBJxchiDwK0fWIcQ0gxm/nycn6T/ZjyiAxAXkE43lgAqVoycLaBQN+RzRN32r8UP1W7pmdU+hXAkAuoIB1hNayRpELstdl6MD268FgNc02+CmO4xcWvZYm6Nv06aGyRE/Ct0se+KB1jl3ikCfiZnIlJbUH6FEE6yd41miMm2KzC4e1VH6AWn41eiQ3WT6A9AZgFmd/wvgZ/65ajJgcIyQ9nIIeFphoFdQxJ8Dz3EEIWKBzOHyS3kuWN+vWcVlP5TQmdQDM6IR6JOX5qXPZrE4HsN19BFQ93KmSgAzRkDA/zWAOoHBwlXmCylY6RUqz5z9X6HzI+8CCIZV7n+QgB1NrOY+y1Amij
 jIKl/t3w
 20xMm6Rs/FN382qjHAfA8aFwlk5Je0HyaNck0F97w12AEOdmj4g51h2dmPX1C8dFve8QS6gF5CeXkW3qKgxMtcg3oYYZtUKTqB/WQz9XZbFpj/hiTFWtMKXLCZMUYWihAAam3DpRcydoVIhGSMpHXTntfeVFhQTbn6nIIeESMolyC1mHJ2x0Te3cdvXDQlq0W9V1tTlC42hRgOn5ZL+ajSPuefMVRcopq4UcPe9vQXtqU46LbBPP8il0uoyWUfsjSqwZ891yaHrEulJN4y4Nx1YcfiXRb2ZCAWceIazPqLQ+8Lx9T4ORsthhxVtrC+rzUHLgB1vHuvoR3bs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/26 14:25, Rik van Riel wrote:
> On Sat, 2026-08-01 at 10:54 +0100, Lorenzo Stoakes (ARM) wrote:
>>
>> Thanks for doing a human pass but it LLM's habits really carried
>> through
>> here. In general:
>>
>> - No walls of text please - fewer words are better, clarity is king.
>>
>> - Don't write the code in English as a comment/commit msg - redudant
>> and
>>   distracting.
>>
>> - Sensible patch separation obviously please.
>>
>> - Write as elegant/reasonable code as possible. If the code you touch
>> was
>>   some horrible mega-function, take the time to refactor it. Pay down
>>   technical debt.
>>
>> These are all things LLMs are extremely bad at (even fable). So they
>> need
>> to be done by a human.
> 
> LLMs can apply those rules, when expressed in a way
> that they get interpreted unambiguously by the LLM.
> 
> I'm slowly building up a collection of such rules
> in the kernel-style repository.
> 
> AI can write in any style you ask it to.
> 
> /*
>  * Long in the Halls of Rq the weary wait,                   
>  * till __schedule, herald of the turning years,             
>  * calls forth the next to walk the road of fate             
>  * as prev fades west.                
>  */      
> 
> AI can also flag such issues, once it knows to
> look for them. 

Just the important note that people can use LLMs to make themselves
more efficient (if they think so), but not by delegating the hard work
of sifting through slop (code and/or comments) to the poor souls that have
to review it.

LLM exercises should be done behind closed curtains without us noticing.

> 
>>
>>>
>>> In order for them to produce code that is at least a
>>> good starting point for editing, they need to follow
>>> rules.
>>>
>>> Once you apply the rules, Opus and Sonnet do not
>>> produce results that are all that different from
>>> each other.
>>>
>>> I just added a few new rules, so the tooling won't
>>> even let me create too-large patches any more.
>>
>> I mean, sure, but what's needed here is human Rik :)
> 
> The 80/20 rule comes into play here.
> 
> If AI produces junk, the person starting with
> LLM-produced code can spend days cleaning it
> up, without getting things in a reasonable state.

Right. But what happens instead is that people think it's okay to not do
that work and instead workslop us.

That is simply not acceptable, and we'll have to start ignoring people
where this is a recurring theme. We simply don't have the time to do other
peoples work.

-- 
Cheers,

David

