Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2F1CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B93B6B00B1; Wed, 13 May 2026 13:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A4D6B00B2; Wed, 13 May 2026 13:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259046B00B4; Wed, 13 May 2026 13:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 145E76B00B1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:13:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D4A01C031C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:13:02 +0000 (UTC)
X-FDA: 84763041804.19.F9534C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BB11220013
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:13:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q8ERpbnR;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778692380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zy/wfEvvtQWJdoWlhxJ0mvIEi97P6Qa7qusheKCrd2Q=;
	b=crU9PTiPmcaySvbXvDfEStEn92pu7bfE3kMylH61XpRVHwmQgO8hszjWciTq5zUzJaAfKm
	r5d5supBE1VKLAiEChX4EW0MuJyEBbqfh6Vum2YstCIk3OA/A5SO0qVGadm74InK9T+gN3
	FZ68LNUjDU/8cis4B2ffD1CShvFfg8Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778692380; a=rsa-sha256;
	cv=none;
	b=GZZl3kBTiUJ28LwplwahO3IID9/zgqQn+wiIYFbRPloH/avMQI4JZ7nPt7uIQioedPL5Dp
	1CGhUSud4rpHqnpKgqXpHB9VQw2krdQNjHy3bB+VREqunlwoX1KwgFeMUP2EVRzyt6Yzgj
	1B7DMx3FyBn1SPOFDak/757qL3aT7hY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q8ERpbnR;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 154AC600AE;
	Wed, 13 May 2026 17:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2E4C19425;
	Wed, 13 May 2026 17:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778692379;
	bh=lmMu4jKtYKjrjBwVPac4GkvniCCJWHuwt4fjWHIFgEw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q8ERpbnRTSsNM3tZTWIaYEJBbiFAsU8BGEYJsVGg/IVZHXzq+Q46EQOBpwJaxW/Oq
	 NPs+zXb1Z0hY8nyZa+FMbnjU7NpADE9gad7TkXbOaXSW4xDRB3wrgMbjJqX3ArHsOA
	 mqDRXqlYQQ6dCmYla2PMWEB7nOZXBdydQGBlgZxExjh277400UTNEjcM7ngQ6zragk
	 z0y6YKld9a4OeVXnl4yz7cpxJ1bFvxyo1aPBbnWOiEbYx2IgevRCXFdWI0+f5otAZb
	 IbbuSlM6pdub+vkXg52nWKfgNXg6mCdkolSsEmb+yGq/mBMhkqgz4x6AA7ics7pjDi
	 NJqPfmRdnNRUw==
Message-ID: <e92f0175-9e9f-4061-b72c-86f6d03f28b2@kernel.org>
Date: Wed, 13 May 2026 19:12:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mmu_notifier: Fix a begin vs. start typo in the
 invalidate range comment
To: Sean Christopherson <seanjc@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Takahiro Itazuri <itazur@amazon.com>
References: <20260513163546.1176742-1-seanjc@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513163546.1176742-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB11220013
X-Stat-Signature: y9ekffgru6tfbb9ekm3zys3jskttdis8
X-Rspam-User: 
X-HE-Tag: 1778692380-862945
X-HE-Meta: U2FsdGVkX1/jPDIT2deEPFDj9/rWRgotLRWzAk7Of73qXPJ7pbLHkA4qw2lMp/uAjJgIVK8HpK2+f6C9T5XSIby0XWItLslqGJIp0+O6VTDNA1ny7PUlKdyG+VREquYxtbPdlZJg8MBrpxvW2iWLIBJVBgslwAkxUOmfzrLxC5H6XaMB8LmKU/dEC8E3z3V9wSdrAfPE5NXOvFJAObyfMjs+/gQPybj/vq9gpjW7DTtzN0/aO8WMzW5D3Dt3QGDMKEf0z0Ak81J1b5VEtZNhAqWBI+pgh5cO8Yy8q8m1kd1RSF9IwlCBR/ncbM0ZaLsHA50HSnRWlRxMXT+2kZxztp+dEGopdZe9DnGQg7E9F7E4D2Io2zE8S6bq8niRbGsWYWWLhKvShl5GgdR4N5i14vFLh8yHteI7tkLItPAFPYj737gc//CoxpUYQWQXIyOaBibKb5joJNZxgjPzdw5nyrXIas/In7KlUDbVIOfDppnc1VbYWrQULW6cSZHBDUBVQw1ZPVK3C4DOlDSwnVZhfa/Bko9orcU9zWcexpQ4ZCrtvMpMaEsEQHI6NQD+DiWDdrsc3sSvb69Vb7l8/Jn7B/LcvFHSyMlmbUom32RG8BzYVOpAsv8ZXfMks9yPVavD/ro1Hkjql1B8bBWBo5SiKN4QX6hmxCnLM8YkSGZjtmTRVZzagcXwlOyXsQqREDmRSYHpSa6vme0Bc4yedpR8dpQd6t7wji48DmM5mbW3zu5xjPBA5y4ToKkdCsHttXtKPLLRD/fS6YVyG0v7cifDequU7E9/VNmKRok3LSKGqlKD7OiaFIg07zUBVczaqzZTT/bj7igHhKQ+khaioyc939qPDmGMyXjGZP0lp4y0HsM/8O8/7TqwM/j2xtMj9qVBI/zBMU6mHpvTSyhiYIX4dzVJMNz31YTqumHb4APqM51hWWlSoJnH8G97eRzR5b/J82W/69kRVLKtn6bXV2j
 X8Mq5IDo
 X5hyKbrOXBQH+/fOPQ2mMY3yCBegEGaewsT0VFnFaIQ3yTiwOa3cy5T5aHmbPoek6qWX1z2/mh58cHMKbIcNpIQcCAIMPX7Fi0VauZPzWbx8DyzeBZJLR5QU8nifbKz1Sdd0J0ouJSDTMnE5Ecmv3e5dK5BQ3Q3vs+yYCuiLWLkEL6/EbBTyaM8+SnNPyYh84UNryyAiur691VotpcUgWRL3hjK6syFIYSzzI1QpQvuj5YMN3p1Rzr63r8NpcRvU2d+z2T6oQExr3hi7KaKkRmvUjhcj2A+novpyC0/YVHFhE/PrafpcUqnnMWpC03yDUUE9lbth/sfnKIvi1yXaynMXjyubYepAI1yGUTH3iNJAQZt/QtpYjWYMvKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 18:35, Sean Christopherson wrote:
> From: Takahiro Itazuri <itazur@amazon.com>
> 
> Fix a goof in the block comment for invalidate_range_{start,end}() where
> start() is incorrectly referred to as begin().
> 
> No functional change intended.
> 
> Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

