Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD5BCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 13:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA728E0016; Wed, 12 Nov 2025 08:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69AFF8E0003; Wed, 12 Nov 2025 08:57:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AFF08E0016; Wed, 12 Nov 2025 08:57:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4538F8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:57:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6AC9B9BF3
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:57:53 +0000 (UTC)
X-FDA: 84102108426.06.56977B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3B284A000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:57:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uDdn5b0T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762955872; a=rsa-sha256;
	cv=none;
	b=YFE8Hm85XGQq+BPh89oEiYrCphS/EHosI+2U8zQnLHyc4U2ONbL5HW7Z8h2c1TswlSiTes
	YrcPyMuP6nr+HT1+gSVV63Wix13nzVQyQf6JwKUa9prES/GlKdKszs5FaU76Hzfoeu8Ldu
	LcpdPwqYjGGIPUGxQkjtA5NTBllen/A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uDdn5b0T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762955872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iYFkq8EoSIFdFM4yiltEoa/A9Iy/iMJWrMfuUMJqAY=;
	b=GKSicMaT+rgUBIFQAeXm+KpJLXsMS7tp389Cy5M6C7BfHIMP52oBX6Cu2svpLejP1tQwO4
	pVM6C/60TUaEfmQ46LAisQUW0aa3GO5qTeHwoH6GX5oXpnG2O1VtgtEYd8hin5UPofDlkv
	aWGZ8/uVztQs8/dw0pjgeWHo/uanyB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6148D60213;
	Wed, 12 Nov 2025 13:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29847C2BCB4;
	Wed, 12 Nov 2025 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762955871;
	bh=wyYh5JA+N7mRZY7BRonX9hRu7lWf6kG2xADXz4mWKHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uDdn5b0TMd79Lh5gGh2J4WjGYOU7mL3bVuBbQ/VXgzY4nMQRUASwOOOn1wPdm3Cym
	 W4XE28wEzp5MfEzdP2hqphehcMkmvAS/b8w6wcpUiLZxYE0rCMGLEp+rVCdW9qI4ba
	 ocobM87q4/c0/j7wdbVyzm/yrXe8KetWir7vwxyUiRXtVNS/+8DnZ7OaB4HqMTf7u6
	 36VSYtBbbyHuGEXAGGvXe/GFkuJFAWR+xBF55ycy4xXYzkSJweCr6O/7vY6qeuk4iJ
	 2JAYXvNk5KDLXblAvdwOWYLaBc3JfMXId6w7fnEaMQeOyF/yR5GPTl+Yi8z7SCHe3i
	 /nZPR2FUDupLg==
Message-ID: <ba3cf0c1-174e-4e86-b464-7c5c15a803d8@kernel.org>
Date: Wed, 12 Nov 2025 14:57:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: Kevin Brodsky <kevin.brodsky@arm.com>, Ryan Roberts
 <ryan.roberts@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <999feffa-5d1d-42e3-bd3a-d949f2a9de9d@arm.com>
 <cc9dc398-b9c5-4bb8-94ad-7e7f3ddd5b4f@arm.com>
 <824bf705-e9d6-4eeb-9532-9059fa56427f@arm.com>
 <58fd1a6e-f2c4-421c-9b95-dea4b244a515@arm.com>
 <8f70692c-25a9-4bd0-94ab-43ab435e4b1b@arm.com>
 <cdb4b97a-415b-4dba-877b-0cd570381a6d@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <cdb4b97a-415b-4dba-877b-0cd570381a6d@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B284A000B
X-Stat-Signature: o1fdwegt5xkn44hdqsbn3rysaa6bh4y9
X-HE-Tag: 1762955872-918560
X-HE-Meta: U2FsdGVkX18mMf7NrqYgUqFUiHqmLN7OCCSOri5SVzpRv83RYjblrPn9In80GVhW+ZimMX7abacz8qIlLlCOL5newg0GbUzOXX6qEBSpzfnAgXvNmF8ELfrYNdW3G6sen8MzFbdw7e8HAo6gcGTMWOLPDLFhp1FGZPCSjKZhTZPS5m0mgd4K7wd3iiPxpTIm/wr1BAbyqCO0OfdXnj67TPRqP68a5iShA0OURBqvzU9U9olQRGjj4JkC6HNMdtl3QnUsuYu2RA7SytmM8gC9b3UG2vQ8RA11WFav5BujQfU8To2a3xMTXzG5k32Y75j6QnhzTNtyuO1wd3fY/xwVsJqYYjtimeYUpVrqDGaeDQJ1vMuOZOynN0JsO1TlODioQub9qEIOS3Kg7xrudbYKmUw4yjp0wTlgNnaMUHA9ZIzxtcGCpRdolKPp1lZhpzJAxwlDYvxQPGRNZN/MAI2zDjgmbhhj6nrY4BHoEx2Yiu6Mk3qBaR9WvAKORwCo6bKqtiHN/1Y3An2V3HjFYVLRrt87WgQ5Lnz9gEkbXrdaBx65qlVvSX3SmNEG6CPaXkT1FMVzPug2c0/sz6UT363IJZOBj8AY8d7Vtejbz2gvn7LT6v+4PH2NbqltiqF99WBt1MvVMzH+vkFndkPnMd4xKfxTi8hb1BtUIscW0rq2Rqo6QVOBBFNukwzb68Ni2NSkIxCu1Qv1NYv4jgY9WJgPVf0FR3r9rpyjGTeWMVmEXYBOP99vJrLAe490GBz7FZVbHx4f/3zpblKcRYATYXnpdQPsN6xS/IOfZpErPEdb8bTgw35pyoIlDRX+W6iTWfpO9whbQmgFbf63v9UTs6pJ8muncSJn1uk10Jhwi57UROUiK9dMj1g/hKoG+Ipyt/bzaTPKI3FfYml2GUh4KDiCtqK8yYoY/eV5x/dbITTR1l02ZVPMm4TsLrkhsTRW6RvHadu7izJNdSuafWum9tL
 LRVWhJfb
 CIJ4m92fE2K2GdAFV66a4cyIBmp9e8WD447B5JAOOnieAW63YnkfOufvHj8ONjLsq1TQZ7zhOBUNFZTNPlFqTajXLEzvShEW24QfJ4Z97aIvLx6IEImS4UFhH4g4f76K3d8Mo62bvUv0PBWFTP8bkyZAxkhIveKuHkZqLRVlBYs3T8kCd6HRu/L+G8U3qAVJT/6Qd0eR8vPEO8iT9zsGCbRaUJeV8OgozZg6gJe7PKNptk8P9NcVzV/x3r2YZq3lrayN74M33uibq0lyfpi1XClpwj9J54jAGu12Yp8SNlcLRoo5IH5seDl03pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>>
>>> I don't really mind either way, but I don't see an immediate use for [C]
>>> and [D] - the idea is that the paused section is short and controlled,
>>> not made up of arbitrary calls.
>> If my thinking above is correct, then I've already demonstrated that this is not
>> the case. So I'd be inclined to go with [D] on the basis that it is the most robust.
>>
>> Keeping 2 nesting counts (enable and pause) feels pretty elegant to me and gives
>> the fewest opportunities for surprises.
> 
> Agreed, if we're going to allow enable() within a paused section, then
> we might as well allow paused sections to nest too. The use-case is
> clear, so I'm happy to go ahead and make those changes.
> 
> David, any thoughts?

I don't mind allowing nesting of pause(), so works for me.

-- 
Cheers

David

