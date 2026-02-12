Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A02DEE36B2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7331D6B0088; Thu, 12 Feb 2026 13:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0C56B0089; Thu, 12 Feb 2026 13:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ECC06B008A; Thu, 12 Feb 2026 13:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1C96B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:05:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD6148A728
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:05:15 +0000 (UTC)
X-FDA: 84436581390.08.0BF2C1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DDA22180015
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:05:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n+vkMhPy;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770919514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlJct5fZ3hbxhCLfVZ01mwKp2L+YbsLJgAyajOWGVI8=;
	b=EPd1BwGrZjyc/9zNGXmDSt0XYdVM3BFxGuiHl8ANCcRBhFFonjgBE/sn2X59OeZX1Mt003
	Kl4M2UP8jR2D2sOGGQK9W00b3SAsfVil33lkoCaaMahpq7lA7gAFbrt+WfucG9erXLOuoH
	Le4+e2Oxf7QR3etMMhQQ+1F0HnEWnKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770919514; a=rsa-sha256;
	cv=none;
	b=KDfOB8cvpn+AUJC7HBYiJSZ8xq93W/855J9kAEgyIlHDL0onKycvZJMApad4lTlGsnPGKj
	UeuN3SivfHovDHJigSQNAuGQl6hsWcZa2HBSM57fOYMMTPpM21r8qL46HMTK1GsrJQb2ex
	KoPq93A9Eua8pUYtnyqg/Hf5oFWesB8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n+vkMhPy;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34D916001A;
	Thu, 12 Feb 2026 18:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96593C4CEF7;
	Thu, 12 Feb 2026 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770919512;
	bh=UKfZRICIwwRzfqfHezzRxNS8OKZSZrZb8EBmzYu9ksU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n+vkMhPyIyuFnGduuFUtqLeRCeKmAEwYuzvOos0KdULgl4JlzF4Pk0PvP9tCUiP2H
	 6itvULtvqRc04eUgGoSDVBfb7GA/GXUmtRUsL4iMPSOym80x2gluNa03GQQ08dqrGE
	 zBBqRWAUf1eAbclt9Lkx699Dq7Pnbl3YF8Iv1QlxotN++HBFx6j9aAOyv1LabdS5N+
	 BFChBRXw5cPkJB/Eg6b2wkOFc+wo5V+747z4WKiKu6kYRH41ZFH6lpvvlQ3X3j7usf
	 d1wCn3YtLNQwGAz06j/rFQYhpYn1+Gj5y2of9c5vC0IbCWDJD5y55O3YaXOxdZhdmT
	 /pclZ4ckYIi8w==
Message-ID: <5c5dfe82-0b51-41dd-bfce-2ad80fbf2ff6@kernel.org>
Date: Thu, 12 Feb 2026 19:05:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smaps: Report correct page sizes with THP
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org, willy@infradead.org
References: <20260209201731.231667-1-ak@linux.intel.com>
 <94a21bda-5677-4949-a1df-3f0d90348021@kernel.org> <aY4UzC-X4a39wbG3@tassilo>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aY4UzC-X4a39wbG3@tassilo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DDA22180015
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hhiqq5ys4mdrkczdaof579m3dw9ju8id
X-HE-Tag: 1770919513-75929
X-HE-Meta: U2FsdGVkX18cGOHKFVgV2yaLbRFlARgjr/TzDvQindQS77pEasZc7fIz0we8rQOBGc1Kvhgup+G/FGnhI/GLTDbhIBpMGCgcRlQcGoWI2G1c4pD52rk7rtsKnzvJAB67UajbRPAOihnW9Lr6JCkEmAYJ+ue7zDe5fm/0cN2gzGbLzZTBGLib0KG6zDhcHcaW4WreNC9GJ9ef088P+YcEmO7nuDE5ZRklzr+8CsA2FCD6pej2FmwwHPyX0eE8274QulkdtQ/dS+XbpNoX++sb4Y4fCllOveMun/DGUg+R1473EJQMq4ESde7A6PPP9DXElnUWtlZKZG7nh/X063j6DWbsAoQAVdercyKLjA1a08EarZ71rll330UdSvsJl7xWg3orxXAF+pQvhSkUHKPkL3P6rxHOkC4Czztg/X1ExwePCBUl/BbysQGEGvWBOm7wl1bAes9RkQqrcDsE9S+Guj3uXL0H0FS9BLBBjNuK1nj5Z1Whc7WSTsDaMGju62dJfbK/7ktijQHxojfdhW4sp391lCtnPRq8lyafF5m73FzigN0owjz8I2q/9GM+MfwTYCrmISNNPBKwm5dYpplLH7q7GfURCmk9taseG+RBr4miQGET5t8jnsF+PZZeqWrAV65mJEi4WW5SP0Jw3pwfqP99/u44xBXz+GKImrFfURY+CQwTtZOlV8B7oXaLTCONcaEBomJhI/lATOtWE+Bno5vMpn/mTSpQVTh+e7hWSQew4y5oM4Y0zpqQpKJMZHkWoNA6gAOTLlGOF6jZVHcqyHU5fhmplbpscjBvM1ToiItgzdz3oscwIVdOVRsFzuFfL31gtE455zXWbJvpRHH+LDUY24b+JLLAhoYIS//o9K7LBAuUqZ534adhlep0Llu+xiveJj7kw+KsaEBJlZVUjWta/KoNwTcLxdc8ujreneLsaltLg4e1UCj3EgvisFFKCKRaPs+uY+KudgIy8Gg
 103UJKi5
 lxl1STaeG3W4vs0fnKoMtiQGRBTfjzURGCo+QKIwFHnGyoHQ4so+NJ29xk+LzvjYW9oqsgK9gCEB4c5XXdI6O3kzbRwvwAPSfjZXRBPtgKF0sCuSVWNDjf3ap9b4JLhPMxr7LxlyvkAqj/AWTQxvxIlEc8alJUorbb2VdPCtFWkR7kKXPFszfO+/dv3TCnGlzV5TI5kEIDLvKYT7/Rb7PbFDJuiCFoEz4Q2bi+n7R1m2bKwqc09y3rMac/gsxO9RFZgVw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 18:58, Andi Kleen wrote:
>> We have AnonHugePages:, ShmemPmdMapped: and FilePmdMapped: that tell you
>> exactly what you want to know.
> 
> .... if you know about it. I personally wasted a lot of time on it
> because we trusted a lie.

It is confusing, I agree. I don't know why we added it in the first place.

> 
>>
>> Especially the mixed thing is just nasty.
>>
>> Once we go into cont-pte territory (or automatic pte coalescing by hardware)
>> it all gets confusing.
> 
> In this case it can be extended to more.
> 
>>
>> Sorry, NAK.
> 
> Okay then just remove the page size if it's fictional outside hugetlb anyways?

I'm sure that would break some tooling.

-- 
Cheers,

David

