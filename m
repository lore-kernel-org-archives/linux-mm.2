Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66360CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F426B03C4; Tue,  2 Jun 2026 09:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8474F6B03C6; Tue,  2 Jun 2026 09:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CE76B03C7; Tue,  2 Jun 2026 09:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63CB46B03C4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:16:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1F46408F4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:16:33 +0000 (UTC)
X-FDA: 84835021866.11.84E3C87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 44E9D2000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:16:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YGdI+2R9;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780406192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgt5R7wePbJ515Ib302vV0Sfov5vCy6fc1NebFpu+Bw=;
	b=M85iJNzoZNL9NjpqZr7uFl2o8vTiAWI8o/tf5V+84yvjJt245zaETujdpniOYON7P4jF49
	QLNwOEsgbW3PKLz2c7pb67r07c8jgRRZfpAlsHStdNlU6WgzLOpr/ocHisZr90iVfiiG53
	MhdLeJO9wL3d26QvYh2DpL7g6qdVOgs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YGdI+2R9;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780406192;
	b=0tPDIqRmdyyDaveNzsqhQfs4BAAcZP+Jl+Jm11c5atOIHCm+4vC3ZaRMCyIkXi7yaZ3oX1
	ctOjZG8J0a6NWZCPdZH7VeuJJBO+sm2mhfl7a0ZXjsscNFsxrzXzrW4LQKoh5vsGZNUd49
	4R5ksYbdJO3fqxIHSLG176QzrsqgATs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF33F60141;
	Tue,  2 Jun 2026 13:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3BE1F00893;
	Tue,  2 Jun 2026 13:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780406191;
	bh=qgt5R7wePbJ515Ib302vV0Sfov5vCy6fc1NebFpu+Bw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YGdI+2R9FW/ddTwpOuFyi3rGk3jJMI1ox3l5oAQJjao1zZVEC+0/rp1bnyj7ntX60
	 eIZOyAt+aWfeTBDNkH1REVsdADztNI+zAZ4zRvlr93SU4tOTzELH6UcTSVxIexG5N/
	 iZe/MqVBbqSgKOLnHGzAki1VufZWrw0j2LzQ0zO0JnkRZjUkZiEe+p/TNr2pbFtkhn
	 AYuMFXlVQPCS04zz4VO4i+jZl2T8bEX0IGfRLu1ydr0uslTs/FFKNgtnJg3mzQbxtG
	 hmjS4NVHtEDD3ZEXqdJGoKY6P3b1t+tmpYSWHhax3dXkmmjHJcdY8fGgTpOuxqQ4Ah
	 jlFWfGcCgbR/Q==
Message-ID: <58b45d62-37b3-4006-b738-08992f502b58@kernel.org>
Date: Tue, 2 Jun 2026 15:16:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org> <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <bfaa33d4-d156-4b11-8735-57a5d1b65ece@kernel.org>
 <a09bb52c-2e28-49f7-a32b-e2743abff756@kernel.org>
 <589d3c4b-77af-40a3-8506-5b00a5194aff@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <589d3c4b-77af-40a3-8506-5b00a5194aff@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 44E9D2000F
X-Stat-Signature: wxz8ph6sutwmizf3uukymu4qai48w61w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780406192-817448
X-HE-Meta: U2FsdGVkX1/IYTQw7GwqLInFMLmmeHlssyor+w/d7WFEgC4QRbOVBEIHweVR8ta/H9L/jV1wk4hxcg0SBg7MLoz847vKobOMIuTCHSSo+CSHK+EMc9YB7Rh8GRDunzqGLeF2H/oxuIkpCE0P4GmsXQq5Un+U5EbCWtJLugLpmIbl3g59KsD8dpFHcXQcU506RKN7E/r6g8RXxZbCKkW+zOMmHXAS1ziVrQqEz9SG1c48UMEA1/kl9EXts87GV3QOqr+alCdQlpTzuktirNNQafBcuUu9IXugNkOotuzIhoiQpab7vCnftPDstZVye0ouwkP04NhP4FjVfGYX/qR/zvGuBhphggA5/UVQjQJLL0zYmcQXSKwRRBHv74ElBtA4bXz2J5oCqdl2JpSbX75gE2kYcg3IDAIuK92Qz/Bkti4TJ6QxTvbYekkByqKoyuZf8HnVbZpo5LPV0ijO3W918btxrutePWzOOf4bnTW7PFlFiekafKZ9awj76XxXYroT2nlXGJPmRGUWLL2c+EvWTwGNBkhe4LLwYbmh/k3qcjrKlYiMXRIFcFwAY40As9Kp9eI2Tgb2sw0WIZHCGqw/uF7ejjy2yCYNHWiQg1Ql/BCo2D7FwWvjSA97+dnabIC+Whcn1/mbu78PhHzjQGQ0E96EupxhoUEysA6qNx+6hF5795TngR+8oEumPIvD5jHe6y9hBi1KPkmYxT/OZfUsTVHc2sVBOjiRCIuKYoRKEVufk489kuqWWgA6GJWpWT7/vTLTJr7IFkCoJrdUoxlKNxGGmHAi+D0s1G/O1bCOs7X1GvNpajqrdqG0dKZ3ZFD+4KA0RacJ0DOXL/nI2yRrn/XCUFQnDOHk4+iH6eW7pNPqSaC9stZK7LnueK05mUz0SuPKnynj8H0W5gBJAEe1IJPNAHSVBZFGbjYZE5a7Tb4cExkvUFC4qukLfOCxXE1I6IKsnE6IbQs9wyQuLYR
 onFj+yfB
 j4B5aY/8UFMsSA2P764i4151qlw40SdcZUrlStxyyC9gGj568rmVL/SYfa+jGsw8sk6luce5R0ZB3TqwsUQBShcllSAacLQpvtCG5kbhbq7z4R1LU7YxNHO1fnAHnTD0KN83KqDCvLAV7bvK9YOuLdD3tBSwbscgXv4UZtZwpAExD9yVdk8tF1c1W/NBZD7crKtl5O89chZiDkWFgyLcAgCZ+HtfbxZoqBP9m0IfbAve8PUmVeBuY5kQbuAc9cppv04BE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 15:08, Vlastimil Babka (SUSE) wrote:
> On 6/2/26 14:58, David Hildenbrand (Arm) wrote:
>> On 6/2/26 14:47, Vlastimil Babka (SUSE) wrote:
>>>
>>> The problem is that the patches would not be applied on top of the
>>> integration tree, so it doesn't make sense to base them on it in the first
>>> place. Unless they target the next cycle, where the integration tree would
>>> first become part of rc1, which would be the new base for all the
>>> submaintainer trees.
>> Why does that matter?
> 
> Well, as longs as there are no conflicts, it probably doesn't.

Yes.

> 
>> For example, the slab-next tree gets merged into the mm-next tree. Submitter
>> will send against mm-next.
>>
>> The slab maintainer will cherry-pick the patches on top of slab-next. From where
>> they end up in mm-next.
> 
> Note slab-next itself might be a collection of topic branches and it might
> be more flexible to create another topic branch (based on rc1) and merge it,
> than apply stuff on top of a product of merging.

Right, and I assume that the maintainer would then either try to fix it up
himself, or ask the submitter to base against a specific branch. (e.g., against
another topic branch etc).

I assume one can go crazy with topic branches. Fortunately, we can do that
incrementally IIUC.

> 
> (I think extreme case if vfs where almost everything is topic branch and
> even the PRs to Linus are many separate branches?)

Yes, that's also one thing TBD.

-- 
Cheers,

David

