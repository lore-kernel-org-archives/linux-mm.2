Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 239F1C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 18:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E246B0088; Sat, 19 Sep 2026 14:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFA36B008A; Sat, 19 Sep 2026 14:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3096B008C; Sat, 19 Sep 2026 14:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7B026B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:47:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35C251C2217
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:47:43 +0000 (UTC)
X-FDA: 85231395606.12.4E5B307
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7AAF6140004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:47:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvDXuB2t;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789843661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qyXPxD8WHiPICoNsVWMXf+1EsR7fxX7tJj8XMR1DcU=;
	b=hH/ywpNnJhIXVgCA0DMXgVOyyMd90cp1Qyyy/w5k+mXsilrleg2eSTY29KBmJ9VOVPJl6p
	zI7Bu32MuvCkSQ01xGNbMeCLwqvLk8vPJjob01z835jMf/kf9K2fs1aKdIoiPbW/o2NPq3
	V9UpSM0lNOQUTXH85i9WEmdZyiThglQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789843661;
	b=kJkKuCmGVWScYg+FprmI+n74Hv6ZLuTLlKtBwot0k7Gm0ojli0kjihGBXX09b9Feqqm9he
	DFrYG2T9KHbt/oFzDGcoy5P/WrWdCQBa8+5NhJz45diQI4/HoxHor1Ia6ExNCkdIYd+3bP
	JaTDslVv+iEhTh/8XvYhDT6lz3+Mk2M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvDXuB2t;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14A7A601FB;
	Sat, 19 Sep 2026 18:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079071F000FF;
	Sat, 19 Sep 2026 18:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789843660;
	bh=8qyXPxD8WHiPICoNsVWMXf+1EsR7fxX7tJj8XMR1DcU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WvDXuB2tiAuNcJOSr7UtZpXxQZRovBEsOYzxDU1hrBkwCpGuHM7I+si0qS30gvOCh
	 J40R+P8OqIVeWnVOJPtu8y0wxucoiBlWWxByDMC46ajsDm4osqMMXfoDRtDgwE/xZa
	 0XMGrap0LcpPMDdWTEmtIcLSc9+S+Mx1lzmkXQ1ladVleomk+vVkVvMDxLgpqDuw1P
	 55R006O7elPGojCxCOBQJJCGeO60gWLX8PEyUfXKILIbHnuHeszHM7Q4Qe+GQ0FEsT
	 AaTQLxmNgP9U95oLQ29tt9xDVJgi+MQKRk7bvx7tag3oW/HPSJqcqsnzd4z9IjZyIz
	 fsW6YiK3GB+ag==
Message-ID: <2ba1724b-7b10-4b7d-a9f9-c642bc48d3bf@kernel.org>
Date: Sat, 19 Sep 2026 20:47:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the huge
 zero page
To: Lance Yang <lance.yang@linux.dev>
Cc: kas@kernel.org, akpm@linux-foundation.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <c0979ad4-9fec-49f1-8442-d90061b79504@kernel.org>
 <20260919151446.5741-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260919151446.5741-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: f1rm6btzm7rg5hq4s5647hgashtcqp43
X-Rspamd-Queue-Id: 7AAF6140004
X-HE-Tag: 1789843661-696477
X-HE-Meta: U2FsdGVkX1+d6sDEeiTOaNLrNHMOiziSZPJ6jvU5bcGTcVcfwHtoyQRhJ0va9gbGwwdXHPnP8/atpvkvzDbiUxYUzOAqPA9Ard0zNSafGsO6+w2D3rNaNb6UBU/LPEg56VWCNVBG4vycIjIUw2/0dOKIzduqOPWcLDTdqM+7vDwB68d3xPIPW2Mi8IEaE+qSVcAFhK8Cc4alYNbsC+8ZRA8BBmWXaHWtkjeEqQM7UWgZj9lx64AOu43z+Z+WpZ8LSDvZHX6Z0wCILm1P9yJqMohv1SspFi474PmJnlLdCI53M+fsQGXfDgq1l3u0b10HmPUyOBKZnkqjw+JSGYUBzvjrTgD39AOcjlTP2BYeZbb17WONIklcJQBiM7XwT6NN7UUTsHXgwYQhKrWJMLdT0VpGmcK2YV2kVSHDgSXs92EsT1MQucRL8MZJZHnI1gCy3frU/Q2h5KFTk782UbMXKv4Ih+F/r6INq4UDjOlOxVH50+plfuTlF9GQ2yNGHNBOFr7fMDZJiRN6glZIEaoIk57TCg4jcna8BkLVd08cTwQrGU5yyBEq3oxdoZrJvprdET2aUcNq6z8m3g+PSa0p12yINveHKydJN5YkG/eo9O9/yHXgz+97Zcbkkrj2AnI3QPsQsJ8CzCTNz9+//DuzXy8F8+vOpGPepP4E2z1uQ94KgGbPiYM1/jg6vHgKKdwTgi65h2RAoj2kyBscKVMe2wbg3e2/8MFDHvqizTj/NJ5Jt13TX4LCewy5a0kllA4W0jmAWiOJOkAmjeVkA1TRKxoQVaIGc+e1U+tkHQoKePk0SffBpF8vRDKClwe0lI2Pd/SOzd9pVFN3OPcJZff3cj3v4gbnEe5iATB9r52e9u0Nr3ET7sXW+Ep97USA07hgrRZGG9FtuosSRbDz8mqu3bfEHWVFEugCC7a7PLcgA3oBjDHRInmFEZP1UMqlNUEx7ktUGLJXAOym8hFMGHE
 7a65+bp7
 lI4mElmM97+XnWsS9ji+fwB4tSfxxzkmgMlT2+kVXWpipU/Rgi9Nbvu1mDuac//M+SgX3ZOmQExzbC3wXYslo6tjQOvZWkQh7smLzKsnZlrr3WQXNK2Rmyfp7aPdZHUgYwp6ffZk4jFl1jF57eaqXSy7CLUTM7xOwpUSrl4ux8sMgQjO8rNYueo0RR9uikIGApMSec6lZ4qGw9dfu+28L1ozpFvxnykUuaY+Psymgu5IPyrOABPkt/fpFEDDXj1S+p72HdynOqlUg+P4O8BpfRLb3etAhNu37DUHCeqQ2qN2hxgG5/n2s6l+37w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/26 17:14, Lance Yang wrote:
> 
> On Fri, Sep 18, 2026 at 10:37:27PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/18/26 04:52, Lance Yang wrote:
>>>
>>>
>>> No in-tree user inserts the zeropage through vmf_insert_pfn_prot(), so
>>> rejecting it there should be fine.
>>>
>>> Something like:
>>>
>>> ---8<---
>>> The huge zeropage is reclaimable, but a raw PFN mapping does not pin it.
>>> A PMD mapping of huge_zero_pfn can therefore outlive the folio.
>>
>> Well, just with any other folio that we PFNMAP, the mapping would have to hold a
>> reference. mm_get_huge_zero_folio() can be used for that, or just grabbing a
>> folio reference (not so nice, but works; GUP uses that, for example, to keep the
>> huge zero folio alive).
>>
>>>
>>> No in-tree user needs either mapping, so reject both with VM_FAULT_SIGBUS
>>> rather than risk making either shared zero page writable.
>>
>> That is the better reason. You could also just say that handling shared
>> zeropages correctly is more involved (see vm_mixed_ok()), and as there are no
>> users, we can just disallow it instead of trying to fix it.
> 
> Ah I see, thanks! obviously, I hadn't fully understood that ...
> 
> How about this instead?
> 
> "
> Handling the huge/shared zeropage correctly in vmf_insert_pfn_pmd()
> and vmf_insert_pfn_prot() is more involved. We would need to check
> whether the VMA allows it and keep the mapping read-only, similar
> to the checks in vm_mixed_ok().
> 
> No in-tree user needs that support, so reject these mappings with
> VM_FAULT_SIGBUS rather than complicate the code for now.
> "

Works for me.

-- 
Cheers,

David

