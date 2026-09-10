Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A175DC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBEEC6B0095; Thu, 10 Sep 2026 09:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B969B6B0096; Thu, 10 Sep 2026 09:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85466B0098; Thu, 10 Sep 2026 09:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87F0B6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:14:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E60C91C2520
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:14:48 +0000 (UTC)
X-FDA: 85197897456.24.45F2627
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 143F84000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:14:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1UWoH0w;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789046087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obrsEf1MMzEije3mF7OvjrrlMFk7kbRaeS4alytnrZA=;
	b=iQAoV6odLSMINN1wwUOvDRQNfUeWGiPcfTu73YBKkkGVel32k/O4APb4b+flVb7rm2/EKo
	6MwaMw6sJAwJH6Fs4PGP5p2qMDBZd1pIOMaEAVOI/KGUHFphxshYiwW/++rf22RMtS061n
	ek5cfPRuuupBKs9vBkuomZjQrEqMcBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789046087;
	b=psFced/yMQQLbueuEANkbpQ1YeDPPA/VJ8s9cEWvYQ4RdBi2QHkDXnj3f4F1XM2uHvsSYD
	Qz3X78dD6pEfkW6y5hF9lyV3MNPNV5n4jsP/lAnQ3ZO6Ly9ZxhIdwioe9eqAp4/I/HP0CH
	ee9rrLH9PDIObD6oCpvIw0O1Z+CguLY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1UWoH0w;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64963600E2;
	Thu, 10 Sep 2026 13:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337541F00893;
	Thu, 10 Sep 2026 13:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789046086;
	bh=obrsEf1MMzEije3mF7OvjrrlMFk7kbRaeS4alytnrZA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O1UWoH0wjxnkd0+6YaNDY/1W8OkDpvWuJwac8Ox+sLdrh2d5ZeNWuC552Ce3xc6OL
	 Lerke7gJsYZX24q11I5HKpfvO17Ai28S+4dD2G5Xhx3uOfQruwhU9n4u3f5dCTNKc6
	 lEjiFdilNrqqyf6ZK3giQ8X08NnunzlK6mWbdt616AQ3aDdFEigHIm44+JrAigQMJE
	 sgfMLJrYiJNVrOiE2AcZZoSq26Ng1A4Dynn7jetvjnO9gMCFBvXh4NWGOHXEThUjNf
	 gabXjDTR3V5R+OkhxLRjN6Hg3RcUBvRNgfzZ2KbnwGBckpsv0FdDIJ54mYyqNbU8Ni
	 k4kak9nneVsAg==
Message-ID: <8d27168e-5443-4073-bc65-24ddbe32e29a@kernel.org>
Date: Thu, 10 Sep 2026 15:14:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
 <aqKS7CP67X4h6NiM@e129823.arm.com>
 <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
 <aqKU0-Gm4yh78F3V@e129823.arm.com>
 <d6f2e6b2-9dc9-4f02-be37-14329c1a6798@kernel.org>
 <aqKfjqa6ye2AOU5k@e129823.arm.com>
 <11a36d52-89a0-4f43-8a51-a4930e171ba0@kernel.org>
 <aqKj5ojQ3dabOV5g@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKj5ojQ3dabOV5g@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: k33diswpsm99wxfco7zbqpcfhk75yqht
X-Rspamd-Queue-Id: 143F84000D
X-HE-Tag: 1789046086-432587
X-HE-Meta: U2FsdGVkX18WiitgXfyHNmMTfvQCJIWcAndyPPrX2P98r70RLtqYfHtp3Tp3mQY8h/X4l9udTX2Q/rEfHn+VbNt19/06QWbTxmtciARnH3cYiD6lIIp9hI/ohJQztqUebv0y9gKulj+2FiJ3WLYt5M42Be05PO5k966zo0SqujYGMYUaQ4LemdUkrsa32jjHSjodywln5XR55Lxno2auklGDV7JaffaZUEzukC2L7HYniyg4gqfYM0JlcgUnlJklVA5ZTfThqYZpvGHIydB24N3LE8nxi5wphr4usci5qpSqusYBvFDT+QHCoUqfv1a3ZB3GoLbNnhkudUPhhHdZ3Xe4i4YuMKJ0Zuadx+dTszdFhlDvR6VMWVo4lFQqM3fmIW/EJfdl3+iToXxM0LYSoP9C+pGovM1FiGa1OOTWxwF+OZGpVAMrHZkgO3t5vI6fGR1Rx37Ir44DJmh2c2/Egutfe693qZT0SC4g2p61k/ZXLd2rJqicTS+1hYPpSzcpJVV9dlLZ439s8wNfFJ+BCRf9p+Kyilrc2uFG6MSE8PfcNYxP0b5kOgtp92ISO5EyT5AaUnWzxOXUmwEkQfcZaAcsrlm5LXfJO7aKbhvMRoZufwdtAzQgekAoe1M82wbN98NCxE05SQ4FK/tpv5pB9Oc6FOptl+YdeJ5dhsBTeBeDOPBqTEcjtDE5JJXRUxw2sd6U/NpAwQ8p0htBbiFWMBMcVZWRPP7Jzq0lsVSJae2HNjx2yFIW80UhHPfxu0nqL3SN/Jk4rzLPIA/dpZB3VnSGr0H1bwyTp3zi6YqmhFowb8ryEfK4ohU+AcQxXlVeLu8ax4ecjzrfzHKCo0dot3Lg2ezUTnD96pnbkadkQpOp3M2u95Hwq9siLzq5cRkBxV80xt5jnQiv/i0LH1YkdxNDUJvy5/Fw9bLwvdrY+yJYnYqHiP/Su2jAF78COa2cmR5a97S9TJIX7YelNwt
 GNZcR329
 nCV7T5+/deGbFM/z9c7vsSQJVinZMDyAB3XWmVOkXuqLBNn3PGQf7LVofnzAQap+ocQkw27XsSf/gE+Rg7pdxHNOdZs4w7dYYV/GeBnKWkrUuNEPBrz62IQPWYd0inG8Mxidqk47xofuFdvCsfsH/op63iNkYS/aOd5iSLbbUQ5VmZ8bcMIMkecIuy3/TcweiIV46FU7xV0V4pyGUQ5ytEbR5Ka31RRaB71HBTyYVSWtj9XMg1qLx9Kik+hNZ3HQFfjz2d1OjemJ0TaIVB3W2lyb036365gH3r3mqdi2RcyYILjK0/eLGiFLvRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 14:34, Yeoreum Yun wrote:
> On Thu, Sep 10, 2026 at 02:25:40PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/10/26 14:16, Yeoreum Yun wrote:
>>>
>>> True. I overlooked guard bit is sticky.
>>>
>>>
>>> It's enough but alloc_isolated_mem() could be modified to allocate with
>>> PROT_NONE first and then change the prot.
>>>
>>> It seems whether make a helper or testcase should write the code
>>> properly in case of unwanted VMA merge.
>>>
>>> IMHO, instead of testcase write them all
>>
>> So far I am aware of exactly one test case, which others do absolutely need this?
> 
> True. I'll respin with your suggestion.

Don't get me wrong, if we'll need this for other tests we can add helpers. But
for a single user adding a helper is not really worth it.

-- 
Cheers,

David

