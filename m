Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E486E9A050
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F00A6B008A; Thu, 19 Feb 2026 12:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B11B6B008C; Thu, 19 Feb 2026 12:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BE86B0092; Thu, 19 Feb 2026 12:09:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 428BC6B008A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:09:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10F711C4C1
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:09:17 +0000 (UTC)
X-FDA: 84461841954.09.DA74511
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 54F2A20019
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:09:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cDz1BuWN;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771520955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jI3if3NIQc22/QmQNEOIA3RNLD+gKfFnXOQ8mFyFj7A=;
	b=gIx4tHYJOD0e3hVXdJ4Lb20VjA899gqFW/3ipmxYnJswGfeFbdqhl7EmogMVYuM1OvpujB
	AdvhNhrxFerKAO1xiycCOxs3c8KDCbc2vMt9ZfmV7+py3CZZz93dIHj87X4BMAY0s2h4CK
	niKdEUDpbC8YX4+PJ00cLBKJZrIWK7E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cDz1BuWN;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771520955; a=rsa-sha256;
	cv=none;
	b=E5akhQ9USsmuYXbS4a8suNtk5ZFw7nzFS2G4YCA1V4vE9XkQLBGwZ73kx2FzC+X4NiWZIF
	Y010zoPlIiHe5sUsHyiR3OzF5eyBM5eWyR/RnmeUdkwN0A7jwxbcd8AxN3qVOxfMKU7/lW
	Z77mUZ1fp0F8ufOHdAwpTEXVaySQdUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93B4D6132F;
	Thu, 19 Feb 2026 17:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43D8C4CEF7;
	Thu, 19 Feb 2026 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771520954;
	bh=UjbEwHCLAlRPRnGztN5Qtc5zs+16ZgPdDu1lHfw3ues=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cDz1BuWNxxN7WcY42EaYiFgRbNk1Bz9YL8BF23ErfOnmrLOgLQ9ip/OoOlDShXdp6
	 iWx1WNJggasZvbnikY+s8C8YLPEZKSPOvuDXzqKG8OiJ+oeINw9+9Cn143357ZIDmY
	 QZuWb+enqgFxxcVMvHEp/12lEGD1F0gxds6EbR80AQ2glSePSOybbPNxpxfFCaaXMR
	 3Y7iCDpaT5hNwtZJUU4pB+dLmsx2RBbf43yPhmS73Q9Vzm6R+fNl+xXuC1Wj9o0zn8
	 2zs3SwfbFETH1rdcEI3KVb8wKZ03fEMoffRNxURGuroO/oz/9z3tWRJGGhagotM2ME
	 gGR/Y5iPVyGaw==
Message-ID: <43a065a3-dcff-4d6a-8c5a-c68cda7065ee@kernel.org>
Date: Thu, 19 Feb 2026 18:09:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
To: Zi Yan <ziy@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>, willy@infradead.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, riel@surriel.com,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lance Yang <lance.yang@linux.dev>, Frank van der Linden <fvdl@google.com>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
 <aZc-8dMBz1XCJI3n@cmpxchg.org>
 <A4DDD3A2-104A-42BD-B174-676012166BEC@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <A4DDD3A2-104A-42BD-B174-676012166BEC@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9fz86f3j1mr11kf8dypxf6gbdcxwekgo
X-Rspam-User: 
X-Rspamd-Queue-Id: 54F2A20019
X-Rspamd-Server: rspam01
X-HE-Tag: 1771520955-954287
X-HE-Meta: U2FsdGVkX1/TNEw1LlORVhZlajtHithQDMPCLudFfzjPCnda3uULh68NI0+8A73GLze2CpQIdY/Q2ShA+shPE82Vaucw+bUiSwqMjaMSyDBM+b5IRHuvArSLDmER3H/30iKfDZA0hWJ7KfrO6f3+ROsdijU5CisXZI5QkhJwQEYuXS0ekRsa+CrN0tXW1oHjYFqyPlb6MchC2909C4tao9pj5Y5bP2jTD2gT0qEwR45bdeTc/UDihYxN8dBsvYLLR9meTjcuiysK7l9Qct+qtKQAkN/0ysemOInUx7ZxnZcx5cv1UWbMNPvvWGq24MGyKj7vQQSsdoP71oqw4Yz59NdpJF6UKnLZicnDHkr76YO5ixC7vok+qvJWpu21A5xd+jrrKDmwGPCEbjLvc26waj0wmZsGCLSlFWvvQi6rhwovDavnnt1iRyD6O6xjqj0vNg+N38ZXRxvFZgWBvG3MYCeVCdSe8ojToN/L4WG4GbrRRi5Ag+FgGUNWJYmPBJyNy5cOJE0rgHDWV2srSrqV/LKpw+HQXQZ7VpOwDTC5q3waqKKB4+2xWUjjSyqLWd0vHicahk4gJOJRJtTnAL5dlt8yO7PAVTMLNuEUIGljtypoRJApUA0S/PqTufgo27NnrX7kSDN9X44P0iFbsCScBKThyJq++SD/IWIfrI80xwixL1c01cYcDe0oyx3VSdL3r3ReAVqLVhUQ2P9zqtQBEuZuFSQYSYt3iVHLxq3rraVxBXdQBAxz8OGkey4LKw79YeH1jdyFe/PKI1mXnDBukL5bbp9SmPfxr7Z2UgrHRzVg5VUCzBzOpyyGAI+n7GteGfwnc/xv1cIMsw/O/TeghQP6joFh4wr1OIjy2uSiTw1OAHjC6UFjhQrKiAfD4veILH36vs8ewF/ll7KSKjhuKJW3LW4HtJBZDPvxEDjgaOOTYss20MzyM1tcLUezyn9NsFZYZ59r/2yrkdbpCTb
 fnApl1GL
 O6WiZGqBXPRmMGRMlvlE5dPXsSXaUtvWTlLuuG2rU37wTYrKUdsNY3vRDmLX0F5eVK6GblFubI9YCyLfsPwTBu9q5g8iP8PTpSXchUs1Ll7TNS0l1SWvb/w+kKMBQo0m412az2by8kvjHDmzdO++rX0pzjqKI+Nct83vfqxWHAdiRPiXwns7CRtjKu6sWCA6xcFUMSDuZG+JnjjQtzySsYH15RJ78QqYSBEzgItLWjaGzQMaDd8NlevrZZY/1LsKojXnYpSR02FN+PP6xSBk9wkUNmXjeduLQkMWB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 17:52, Zi Yan wrote:
> On 19 Feb 2026, at 11:48, Johannes Weiner wrote:
> 
>> On Thu, Feb 19, 2026 at 05:00:19PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>>
>>> There once was this proposal where we would, instead of splitting a THP,
>>> migrate all memory away instead. That means, instead of splitting the 1
>>> GiB THP, you would instead return it to the page allocator where
>>> somebody else could use it.
>>
>> With TLB coalescing, there is benefit in preserving contiguity. If you
>> lop off the last 4k of a 2M-backed range, a split still gives you 511
>> contiguously mapped pfns that can be coalesced.
> 
> Which CPU are you referring to? AMD’s PTE coalescing works up to 32KB
> and ARM’s contig PTE supports larger sizes. BTW, do we have PMD level
> ARM contiguous bit support?

Yes. It's used for hugetlb only so far, obviously (np THP > PMD).

-- 
Cheers,

David

