Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD5AC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 22:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37BEF6B007B; Tue,  4 Aug 2026 18:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CEB6B0092; Tue,  4 Aug 2026 18:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D926B0093; Tue,  4 Aug 2026 18:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFC246B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:05:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84D98A17EE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:05:58 +0000 (UTC)
X-FDA: 85064970396.29.7745C32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id ACB348000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:05:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0fkrlLd;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785881156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFvycaE6HyRvj662ncTXzZ2lEUnpPku3d1eDVKU1XJU=;
	b=wo6Kxi0LJEAHlikprr6ltosIOb1SkuULMqcf2PYiuinUvdV4eCCTBeWGd5Bl+AwjKIRufZ
	180+yOyEg37eUdV7E+GJ3so40GluO6dI3qfr9N6ppd+JqbaPdOxsou7weuMYlmea4p75+s
	CmJYmqKMX5FzYXQiNQH+WgnXt0srEyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785881156;
	b=1S738kWaJHQ0wraFvkvOYoDy3hUiPnsiw5mU814XpQLR69NZWzsCx9cy6dsO6C3m7EMPsw
	jKwW07/T4yvQYXrzcRyuUx8mmz8+pDzD7uUsFZQGPhtefd1iNZDSypqTUw6Gz84m0Sh7FT
	58lPEZ8vWJGg1UkIK9uKfE3HdWboe/w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0fkrlLd;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0531141760;
	Tue,  4 Aug 2026 22:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD101F000E9;
	Tue,  4 Aug 2026 22:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785881154;
	bh=xFvycaE6HyRvj662ncTXzZ2lEUnpPku3d1eDVKU1XJU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S0fkrlLdOdV6vmDx7sATY5Wbc3Ki/D2mR7nyYdpaLQIg9+EIP6+0yZey5MClouwfw
	 2r4FUQxf/+7EymJKF08yQq0sOy4Ba+t9CUwoZOkWxiW+dlF7PqZJMJ0rM6KRFz3Lbn
	 0Y5+Otc/BsOW5Xh2EvfEdDCxUzKDcHoyAJ3S6wfdggFf0/oZiAMdG/5X8iUyXr2lZc
	 6Uh8WwNNc5AnKVVlWjg3sF3PQ5c9l5xdIAtcRJeEaqIYe4x5RNFCRcupDJuRpPs6wf
	 31bnIwJCiTNv/nmCaige1dL14rs4IzpcKfCnOBkvsYeZMpOPZPhgHmA1PE8LzUbYzt
	 YTnIfrCSYbcsQ==
Message-ID: <94c7988a-3ecf-4b26-b0a8-011bdc76283b@kernel.org>
Date: Wed, 5 Aug 2026 00:05:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: Yang Shi <yang@os.amperecomputing.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 dennis@kernel.org, tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <anIXr4Kbn59Ac31Y@lucifer>
 <69f4cd9c-bd6c-4e5d-b8d1-a7be8408a57a@os.amperecomputing.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <69f4cd9c-bd6c-4e5d-b8d1-a7be8408a57a@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACB348000E
X-Rspam-User: 
X-Stat-Signature: nzc61h5sdhz41jdswsu9hyjrng4dayo5
X-HE-Tag: 1785881156-490059
X-HE-Meta: U2FsdGVkX1++ENbJKcovIqef9NJ18SC6hbOxvfteAspgDEUbzuJKQYBeD5gk+1ekZYvgQsxQDxFlny8c8rwCR6UCber3udgwopF10ZlNG6wVIN4HycGGCjJiBIoZ9mpTOsEcUQpkmkelPtBhmWbbWex+tSMUb1ntv+sEwm4dqs/G1uwjm1ztDIIpRb3sz5xfkWGy64a7wrJmxNEKekIDI2tng8Fh9VPhXcKsDTtDhWMn9S8qMIa5ea5Gp9WA7CWClcbdUsFTYIPWdP5oS5jY0WRGrnE72a1MO0izD2XvCdpCXL53bFDMnuuuoP4MZRLLslSN4NrSFU69JB97VwGOi6fjdo0+oBT7PdhPKGR3MIJHqo2jZdzxMPDqls81BKaftzlIgPMAfe1ODJBUB2pKmkA4XnEyPJhUeM/jdqC0RBff+TCqCLx14eGcbaisTkloopYaCCVsW2DzaZpzrEQaGG8pyXXJOQsOqzCtZYUaRmlHc0l7sW+gmrzznZOmoEh7dEEyHKzavamtVy5jKaL4l+mbYo78/g+U1m0qmADJJPNl90fJJRdFXJyQVweLsAHUNhxfUBHvm0//ZraZsg129kJBQJdDCufIXGtdWRVyxqlPIsTp0pdKaAXH/b8c7xIYriy+k1xdbN5tDFi5CabzhiXZ+DcRxkmCGlYptxLRKnryz4cYgGOn+rSkUgvKDTh5O4GN08ENag1bSB1vaIm7vVj5X94KqHqOzPaQGFyEzlMRaG/meOeGXcyFJsKehUy/aSfjjoqyoF7Q9ZNUUNu1EItuT+6gtYdI5lLFOHiFrdjVF1k1jxcKT+5nDWGd8O3Uqb3shgcpQCHsqggG1cIBC0lelQH0DIivHxIjXWix1oP9azxi/kWg5A5By+SvswfJAXge0//tMM2L7fwo3oCjyXT43TLdjZH1Rla9Brqf596AJw3dWkcldY2GhWEGCE0Lloz89D0HPbiWb9o6Sqg
 D7v++X53
 mub05WUPxjv0N+Nzop58GX6/YNKUcJ9SWV+hLCzHsRGWlavejcUrjt2Mxur9JG4u3RQQ0wSsg91a5JkOrP/3osMLSvsn4dRWbe/YQvjKHbX8e2YwXvb7vfO0bs0Nl7dUzrLamHaHAVTVefXF7OWqnPSwzdtacAMbAXsdEB1KxmEN56hmA34Wpwl8Mmc4c1TZj2Ftb8YJY7uKTo79cgVVcDHQ4xm0MD3qA5o9eIZu4CIbQ0qh4Exlnlr4wmCKKLPLx/YuuAiAz+G8YmFQTFUIh8zwCRMKbuKGEuHg9gP5gNVqd761OA+W//6WRHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> The LSF session was not encouraging ([2]) and as an mm maintainer I'm not at all
>> happy with this myself, nor does the arm64 community seem all that enthused so I
>> would against gently suggest to Christoph to be a little more open-minded about
>> the the proposed alternative which he seems to have dismissed out of hand.
> 
> Nobody disagreed Mark's approach also achieved good result, we just thought the
> series can do better. 

Okay, you thought it can do better. Did you only think that or did you measure it?

The cover letter obviously only compares to upstream Linux, not to Mark's
series. Are there performance results I am missing that directly show that the
additional instructions have an actual measurable performance impact?

That's really all we are asking for. If there is a measurable performance
difference, great. Share the results or point us at them if we missed them.

-- 
Cheers,

David

