Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2877CC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329656B0095; Wed,  9 Sep 2026 09:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307BD6B009B; Wed,  9 Sep 2026 09:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F00B6B009D; Wed,  9 Sep 2026 09:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD3506B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:49:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 034651A0218
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:49:55 +0000 (UTC)
X-FDA: 85194357192.20.DD21EA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 48D0380008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:49:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDWFsZxX;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788961794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+I2D35fOAYnXCoF02914TKvXlI9D2AXKNijwzpONiM8=;
	b=4bz3lU1hgWnJdyOUbB6j9NkIWGqgDHW5FxdUamC44RyGMtyS18pm682N5pBsSGReA+yoca
	ETDYEul8uCX9jB1DK/UNEVhsAQHfltXlI4L3q48eMAloUE/MU4t5bIrULh3D+gLRjiPxDQ
	TXrC5tKf6o7Mr5mKPfy/vlrWLlsA6kk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788961794;
	b=Ie2EO8kOYuJoKcpyIs3R8tz7aHcsp9BCpuwG8eGrpMP72ONVmkLk1D7nzbnx5ma5b9xoIo
	mlTdTF4kCfDW+WEccPxSve8a9Yp03dpWLoMpUBd01aDwl2xkbTpkoCB5zYmavT9LcKC/cU
	jOm5fxyoqs/MmTAOhSS+QIIxiRNJDKE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDWFsZxX;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D11C66022A;
	Wed,  9 Sep 2026 13:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396B21F00A3D;
	Wed,  9 Sep 2026 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788961793;
	bh=+I2D35fOAYnXCoF02914TKvXlI9D2AXKNijwzpONiM8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PDWFsZxXJvJiwXVwqvtyXuWs9Up6ldtcBEiMHIMBsQBnJ3t8fIumrzdV5uWwg4QMM
	 E8R/V4YZZID5FrDdTw8Cg5+/o/M+sd8X7/FwasmcNli7NUb/WT5ZbscRLoeglnucy4
	 63CSeTR2izC5APp4Bpx2ZdEOoYMWLUXL9jZzYw26lcIz56MCHsZ9fMgSiL8iXY1ikA
	 GToWzo7Kb6ILsYQHlzxEOd8SMf53oKOZ/TgRh2auRzjzKZnEhCpj5/bzSN90BIeVsr
	 HmtMMkzSsXm/Za2Yk9G2E5f34L1A+tZwl85UChjjbxw6Lj4Lz+cJX3iN2jwldlshv/
	 E4NECwsIf+WxQ==
Message-ID: <7e4a9b02-4346-4526-953c-2a1f2eea87d2@kernel.org>
Date: Wed, 9 Sep 2026 15:49:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: describe set_memory() and set_direct_map() APIs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, linux-arch@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260909-set-memory-docs-v1-1-6065d3f208e4@kernel.org>
 <e173c341-eeb0-4361-9729-9b996c3db42e@kernel.org>
 <aqE4hFXS0YHZKLEy@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqE4hFXS0YHZKLEy@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48D0380008
X-Stat-Signature: nxxqw4e5n95u1sr8axikjwkjj89c7qer
X-Rspam-User: 
X-HE-Tag: 1788961794-589087
X-HE-Meta: U2FsdGVkX18U2Z5m4VVHg3UDskJ665DVSidilsnuwvKRKif8ouqbpMwVgmOwUIRI0m1u8tdfUbLXAQVjvehE8pkMbH4d8h2YphC5vSDv0y7ddYcbacUKOJP295MTbAMpwKnGYXN8PXnVm5br/hMJ3FFZwTdAvjolkC7NeudfudUVfNjNmkttBaZA105g/5NXe5j0DQ3SPX95HBtWmBaU3tnSJSPPy5Kv0g6sBRiNBxWwaLJnCw54YtpYWKWPiCapuaUc3+T12Z0cgqEpvu3J0+3a2KHnkyKK6fOLzJvbtSTwtvNZTn/e1LLkF+/Cb4g0BR4XXY8HszbwtP8nWgYilefSYez71e8zD2xcRgHqvjBAhhM7LQ/n8YdMjrE5EloiqY5w6ec4L69h9iA9BdHUbQjP0Bu8T4PiOL/lJjPl8jfvq928H/XSNuYqIO2bO/kocQ1fRxynIGqD++vi4gKgbMhQ30hXWa3x4ZNRRwpTbcqI+aCLCsiBm+63V0HK+0y42hMcc1n9WFvfjDkZQjYFdfO+0aeUW5qRu3xkHpX4/Gd+jB1f4xI2aJywXgnQwIO75zM1s5nf7nsvrQq4Zl6Fxkv2nEiHfC82a+SeGegmXLMi/ItpkDsIsC3ISMJmIUH19OnkZPLPwFdv9krciYoN/oKeKawpBEp8rEDJNgTE0yCXQck55HOxKauzt557xPCplgDuJDQvY0zTi8HkfssCvKQl7WIyY2l1G9ij2IoLPF1y5W2KuGQte5ZJNMWxaoMSIi2bEImn7EanTvROLcX8jxZHahF+eaUK0GcAIbdpaiYyQP6uNNzzSbZIr4i/jMwIPZvhTSEGcWiYWBQzP0cirv6QA/4GK8BvymL1TaH459MUeh7JGg5RW6fGUoNNFVuHIWzO4ZANHa8CcMBfMEF7vHHjHDqxUl+G1XAs4GgARNIxQ5LQo6dDMN5wb4ND3/fh5DlDZB6ezlJ3QM36TA/
 JIcjfeQa
 9lwKxHT/BekWwY8LOCkfSX/7No2Rk8VDs+MImFppJMf4yhfAOK5RJaZ1Bz1TgC/wPbPOaO4noFZ08kKokEMyu98wZaXunFXlMpdHNkf2HG5YEMc1pg86W7VshQRO9aEIN8jvvz9xtiCQiCiZzaQ4ECWM7SPC9iFAe4aoizO3UI/KVMwzWMHK3KgTi0wQCozPctP+DSZR4ILCAQCAc839E16qQYjhVg9wTuSIdN4bwHomTBATzIpm9WYXiCIXp82ORKyK4oIKXCYz9yyCQIblRt1zq9s+cPqt/8pwijAU4+96S+Q7G8oqTbs4QW5QLtELbIB3PYgf6Ju42lQjcvStRbTrfoZ97AAiAV/HH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 12:44, Mike Rapoport wrote:
> On Wed, Sep 09, 2026 at 12:30:01PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/9/26 11:45, Mike Rapoport (Microsoft) wrote:
>>> The set_memory() and set_direct_map() APIs change permissions of existing
>>> kernel mappings, but their semantics are only described by the code, and
>>> that code differs from architecture to architecture.
>>>
>>> Add Documentation/mm/kernel-page-tables.rst that briefly describes what the
>>> kernel page tables consist of, defines the semantics both APIs have in
>>> common, including the parts that are easy to get wrong, and lists the
>>> differences between the architecture implementations.
>>>
>>> Add kernel-doc comments for the generic set_memory() and set_direct_map()
>>> stubs and link them into Documentation/core-api/mm-api.rst.
>>>
>>> Assisted-by: copilot:claude-opus
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>> The semantics of set_memory() and set_direct_map() are currently described
>>> only by the code, and the code differs from architecture to architecture.
>>>
>>> Document what these APIs actually promise, what they merely hint at, and how
>>> the architectures disagree.
>>>
>>> The discussions that prompted this:
>>>
>>> https://lore.kernel.org/all/a98df077-3e97-4eea-8bfe-470bad9ff9e0@kernel.org
>>> https://lore.kernel.org/all/5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com
>>> ---
>>>  Documentation/core-api/mm-api.rst       |   9 +
>>>  Documentation/mm/index.rst              |   1 +
>>>  Documentation/mm/kernel-page-tables.rst | 402 ++++++++++++++++++++++++++++++++
>>
>> Before I read any of this, how much did you review and edit whatever the LLM
>> came up with?
> 
> I never send something I don't like :)

Good. The rather excessive doc patch arrived rather fast so I had to ask :)

-- 
Cheers,

David

