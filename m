Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEF4CF3972
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DEC6B0098; Wed, 19 Nov 2025 12:03:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6356A6B00A6; Wed, 19 Nov 2025 12:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5723E6B00A9; Wed, 19 Nov 2025 12:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 450426B0098
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:03:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68EE24E80D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:03:37 +0000 (UTC)
X-FDA: 84127978074.25.65FEEF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B20EA80003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:03:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FF4IFwQ7;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763571815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1xmb+SXJzRLtcHXoKESB8H97ENHK1Yf271vnxSLxew=;
	b=ufabffzjdskLUu4zoCXrUo2WQFyC94HDcRHc6DkwmfIOcDdBjD1o6aN8o5yNJp9ODHpnrj
	cpHANrVN12kAYhdsRfyZW7xEaakLtaavDgYR+TiK2D5m0jk5J+x2q+faD/be9ZVfIq0i/y
	jvHkcJ7tvcJ2k+zMKPikeLjOrOv9Hbw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FF4IFwQ7;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763571815; a=rsa-sha256;
	cv=none;
	b=3lhYpLqRFZweiXJ6u16mihruFwhcBym1MymykZD9BEqQF95FmDX6QGXV+K/egEozdxozwZ
	dY7BssDCBjALTfK9F5CC3zoPmrc7d1x9tDeHhOT0SnUfLVK0SM8Nr+hmZVFP0O8/jjZEm1
	1Yjgmma+oNZV6WwAL4lytlfiCkGSavM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0B456016B;
	Wed, 19 Nov 2025 17:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89F1C4CEF5;
	Wed, 19 Nov 2025 17:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763571814;
	bh=Ad3pA+wzEkXbQijUIeWOF27SgbC36/7XlRCkYhMiovg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FF4IFwQ7PlUYnw62cOpGp25F+rEYm11iKFrCXPVQ6yAziyBrJpPOI4eN2XGgkL33P
	 Wwq0V7Ql5DY7b1MGybk1xtVQFqZI1WnYiC6uO9PMcUL+kL59yRM13QAhga3M2IZAn5
	 GZAaNh8dXR5ShC81sTHI+Jmec0zm9OXxYepnZJuS5xYVeZR4vZHUtRnrooz1LWLzAO
	 9t//QnJ8Z/cWwT/s0p5Qk2NbK5518Tq1JKKD1tP4onFZWaYCFD1a+zNj5CEAvTZlgL
	 ur7L92D9bas8CaJoZnx1Ow/J3NHkOyTKbBxqEfwKlpwWQRZu69y1H913yxZTfvQEBw
	 pmcztJL2mTNpw==
Message-ID: <e023ab20-2452-4b4d-9ac9-1877e220dd77@kernel.org>
Date: Wed, 19 Nov 2025 18:03:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: rename __split_unmapped_folio to
 __split_frozen_folio
To: Zi Yan <ziy@nvidia.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>, akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, inux-kernel@vger.kernel.org
References: <20251119054639.244202-1-jiaqiyan@google.com>
 <3828920e-4a50-4f64-a25b-b6c677181fa9@kernel.org>
 <6F8BA2D3-E087-4A02-9ECE-F2EEF470CFE0@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <6F8BA2D3-E087-4A02-9ECE-F2EEF470CFE0@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B20EA80003
X-Stat-Signature: r31sbbp1hdbkos4hjjoykeksm3xgwdqa
X-Rspam-User: 
X-HE-Tag: 1763571815-331269
X-HE-Meta: U2FsdGVkX1/M70AQ0Qig9eGwBWWjT+aAVCHN2Jx/ZGkhMAGkQIRliXEvJC05cP85ooiMwt7ox8o7K86/uWUUexahTJzLjPEhsUuUDG6k8Ad3a4M7EYkm+xGfvkI3IVAuXP14Hn7Ln8dpbNHiBuorhKbQxKGMoIgyJyqeYAJXnQ/UFCZsCZAqHzAVFDiBr7mAQFpp/yMyTbaRzHZdd57H50DZr8I/5YhGJeB6l/bV2Q9dSIyWD/rvL7ZgAhl0vHJGCa6XWtwGtUufJEmu4qUA1Rg1AG0ecL6TYekDN1yXzr5V3GMwT72bC2fHHrbriauERHA5LDulE1I/m5/k4DBPRdJzOmWxFZjr+ULq2/V4FE79P0V5Vp+LM9ZiQmkooosFLAST8Ax1v2pJNtvFQBsZiO4TARLBt+NZfsyKiH+8CVrGefIJb3SNafneSXMDG9DC5vvSBs443ZzL+Mkxb3qLj9NwxdQ7aXMfnkU3XViA4mUiTwAMM+AX7cROE9fetikbgaAn2ACkwdRKV+Zdf3lvV8/EqEDNTltQ/28j9XyUOq3PdQfGY9rC1fXoTf58SzEm0dXeKCrNZPD7njMVgEhdhA4YHxwkRGkrGHbpsFLBD96No1BW+kzuA23/aCIUe4JLOGSweU8HfkSRzk7V60P3hbjC7sMzXctHOZyo0mD4ta1Jrfp1EG9xX4gXS0m+wRPomsj2tZu+D0xWuSGR9iXuP40wVLSY3liC5ICu8qeMNtzHzKe2bwyJ6olhCboFl9pzgBjx8kkYCNmlPMbfn8grv+WcYufTzdMrPk60BK4c2Fg6oBtSdeqNKXEeJpg1LaL1CjPH79kw3cIl9/vt4moyCs64dTO8P1rdBHNJGhHjdfYrbpWAHN5teTUi9JkJ27bc7f3h/VmebYeIqc0GKVS/7Xb/0gJtwMx3L2Ve3Y5WtAsVW/K9H54ChxdRRxRsKgU1SslgnmzORYfgPcFgVZd
 EjaL5xIc
 eG+b1TuRYq9SU7aU3ZdiESd7akk30kE8N8bk1LtVrte7oZa+ePbdZIa2Np0NLm+QN3K9xHhWUl/Br3eb83UDwWg33CRoQRAkStpJD0sNI7gWBvnfCNL0WMiLVlB1LxHum7LCrbBPTRtPs9HNaSBgfaYt3ewSgoFpM+gtqk1uRe/hd81uzouYLKajNHh0lHX5M65NwVNeH3JTfJ4j0cWZKbKAoRFA0wFzu5czv1jpCMM9Ck6+ncdcxMlLa6aoWiSz0FiZ5Keluy3ihk+g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 17:52, Zi Yan wrote:
> On 19 Nov 2025, at 11:41, David Hildenbrand (Red Hat) wrote:
> 
>> On 19.11.25 06:46, Jiaqi Yan wrote:
>>> The correct prerequisite for this split utility isn't really about
>>> if the folio is unmapped; it is more about after unmapped, folio's
>>> refcount is zero and has also been frozen. So rename it to
>>> __split_frozen_folio.
>>>
>>> Add a warning in case the folio has non-zero refcount.
>>>
>>> No new function is added.
>>>
>>
>> While we're at it, can we look into calling this something with the prefix folio_split / __folio_split to get some consistent naming at one point?
> 
> Does the prefix have to be __folio_split?
> __folio_split_frozen() or __frozen_folio_split()?

Personally, I think it's all easier to understand if any folio splitting 
function starts with a common prefix.

At least when it comes to any functions exposed outside of hugetlb.c

For internal functions I don't care as much.

> 
> In terms of naming for split a folio, I used folio_split() for non uniform split,
> since split_{page,folio}* are for uniform split. Are you intended to use
> folio_split prefix for both? We probably can have a separate patch to
> change these function names all at once?

We should change all them at some point yes.

Regarding uniform vs. !uniform we could either pass the enum later or 
also have it encoded in the name.

Probably will be a longer discussion :)

-- 
Cheers

David

