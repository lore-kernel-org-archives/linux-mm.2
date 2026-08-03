Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E61C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E8C6B00BC; Mon,  3 Aug 2026 08:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324D16B00BD; Mon,  3 Aug 2026 08:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F886B00BE; Mon,  3 Aug 2026 08:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFE156B00BC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:59:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74751C066F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:20:34 +0000 (UTC)
X-FDA: 85059412788.21.8BB0C23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A379E1C0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:20:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cQ/RvL0S";
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785748832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXdaGv7hV1IIr0JYIQZkL1apFdYS1zKRORz3x/OxqU0=;
	b=CK/calpT4/u/JsgWf+rrET8lrr6oHWUQ/fg7iS7nOf2uyLDHmdaYe7tuY2PgJ12bloHirR
	I5PHCZqtgnl8HZKjQmaWohQrl/PFXq5wnLON0Y2vsJdEwPRU7491Mn5nY7/gYcBCIwWhnp
	16FfJIH0TUZ6KZDiehqdSQHvGK8by9Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785748832;
	b=W6J1S0kD1IVXZv5yEWy5srmzY13O0vM4kaUtptYXzUE90WKyIMsCUUjfpZaqQbYu7fcOYr
	UrgsKLLZSZTgd6MAZlPgD7L9Ni7YdCSFcrcB+642xNiCDaKUXlT1RoovDGHswcv9vj3Otd
	HZvhGUcTlXEVOgzkmYwg6rCtrzdfCyk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cQ/RvL0S";
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B13A2410CB;
	Mon,  3 Aug 2026 09:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C64E1F00A3D;
	Mon,  3 Aug 2026 09:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785748831;
	bh=uXdaGv7hV1IIr0JYIQZkL1apFdYS1zKRORz3x/OxqU0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=cQ/RvL0S496/GYwKO5ueLFiCiA0Gokc4nJ/+kBNvZMqV/rcm3Yww4CUoejh/L8f63
	 9tPllYl3spSlPPw+QIWWqjYIXanuL3TAiiZlqhEpt+SDZ/S8wVsbSMkK/FKxoOIG0j
	 OZ7iw+EAmF8UqGc69FM9jTmpdGoSpD0OJ42FNzxT7L+pl1aziYljJVSvyMlTlgJtYv
	 sF1kQ3N9HzkNZXn4GKl7Gh4osiRpfMF3cXmQ/qN0Inu5oIypmjyxloa5N3fJkoo/wK
	 0D7Ad/Hqy2suRnfp0aNvr196+k1P28pucwwY1jJhET8FBwbNeGN09bX8bUdbaS1awN
	 CWffmU4Zoq5rw==
Message-ID: <00e90eea-9045-4f83-99db-f3631a54e5ae@kernel.org>
Date: Mon, 3 Aug 2026 11:20:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/26] mm/page_alloc: rename ALLOC_NON_BLOCK back to
 _HARDER
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>,
 Sean Christopherson <seanjc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-19-6f5729aa9832@google.com>
 <ee8df643-91dc-4a38-a676-486a0d52c919@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ee8df643-91dc-4a38-a676-486a0d52c919@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A379E1C0007
X-Stat-Signature: qfmscz38myt7w6w1bax85j3x7ifg8bdr
X-Rspam-User: 
X-HE-Tag: 1785748832-875166
X-HE-Meta: U2FsdGVkX1/WetIbaJ2bokLLXzOHfXLb4/HCJ5nudVJ01NLtUN58RaaYtdgExRrj+HutQBW87xQ3isNWMqEaeSlsd8ICkRwTi+bigq+ypAhXvUPH0+hvjjhOJL26ZS9lVDMoFL3xp5GSGIthXhoemHGX3atbQ2ByliHKh4jAwj41MYjm2NzIvTh9Ligsvh8PUqthgPRfSdgJYRhDsji2T10YMOIWlwCMopJUGNeX8pWjS/mI+/5mGi/DnRlQIIR6pNWGwARO2CsmYFWoEf/1Ig0aeG+cuSBWmLLhpyAQmLrWcDBcucusYwrS6fzAJnr4g3ut3uwE/QZS2jx0tYKBz1Rlh3321TslZdTRIFfzwOn491wKGdAzL5dld4KzxHaGmirWpeA61ogx0F9uF0t0XxVVCnWTuxyu7VizheZrjUQsTmZxCe3jHhVrwqLFAkQhKr6ZAIms4zojj6L+WIdJ8bcPZph1UGconXshYPiM/tTYPrZhtxoZDPNMR/IIrjbCnwYqgfEQjLCRJlciW75PdRdtgLDpU0E5mV+0iH98RGBO34utrnpOv4FP4YyLbclXFeMTGk0fGhGEG0lGSsYbS1+B82okyOqLvcUC1PMJGkuH9EWggoTl4EyWX1grIz8u2jANN9WM5LWz0O8b1+BN6YaZaS/lhXwls97Dh78AtqDvjAVRseZI6ChMyotjRlSWHbt51s0uVCgJj68Eb49uHl5qCg/Smr7LD6hoqUMkhOzfDZEP1lWdOF356AnFH2uiCbEByK9Fl+uz3rCOLiRYL379lXZwSz/uj+B40XWgE5LPAX//YY4JtWyzsDoL1VHAw5JJoPhya+Gfza1fwD715bDUESGT5ooZxHYb5usUYo0e0OHAh4NvuDgWWwumem6xN68f02WB4PhZ6YT7MKqHRz16p3ByHhl6hpJRZuvdNvQKYghRc5Vz/SggLbMrZIoJR6eajtnQwBdLn6bFn9e
 G0AtfCoW
 t6+k8rxYNU88HfYXQ0Hgy+WN5WNfFiFJXDF9gTfF49BMnSq9scGT+aqgPpZvYTFkK4TXLNF9igxy6AOtsVybzkbPCIzw9U+tvUJ4IOHyRMH/l+K1MutZwuI6YJOLFnd5LJEfna47qfFsyesihXHkVrrQOfK4nncZE4r2QqVfEfCN5TwnsoOqmBXR34GFlHxqH8sQCDt8MLioEHcC0vxNLRMGIKohkz1dlTzCLQk9RgdcaMQxbuEab8UEO/4UXlaWoTX4c3MPZOktX6m/vpRJ7TCrJNhJHzjM1imizdEOlzIZcz1F4b0OSXiw1IiDcSOhNJX3Yh5dIig1NDWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 16:52, Vlastimil Babka (SUSE) wrote:
> On 7/27/26 00:22, Brendan Jackman wrote:
>> Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
>> non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
>> ALLOC_NON_BLOCK because the former is "a vague description".
>> 
>> However, vagueness is accurate here, this is a vague flag. It is not set
>> for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blocking"
>> but rather "allow dipping into atomic reserves, _because_ of the need
>> not to block".
>> 
>> A later commit will need an alloc flag that really means "don't block
>> here", so go back to the flag's old name and update the commentary
>> to try and give it a slightly clearer meaning.
>> 
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> 
> I wonder if we need to do this, and instead we could repurpose
> ALLOC_NON_BLOCK directly. AFAIU it's about removing the side-effect of
> gfp_allowed_mask in the next patch. But what would happen if we did that
> using the existing ALLOC_NON_BLOCK (or maybe just renamed to ALLOC_NOBLOCK?).

Hm given how ALLOC_NOLOCK and ALLOC_NOBLOCK look so similar they can be
easily confused (at least by me), I'm not even sure about the rename.


