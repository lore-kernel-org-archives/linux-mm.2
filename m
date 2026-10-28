Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6E81606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2H+Y332
Received: by kanga.kvack.org (Postfix)
	id 1621A6B05B2; Wed, 28 Oct 2026 04:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113A96B05B4; Wed, 28 Oct 2026 04:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0013C6B05B6; Wed, 28 Oct 2026 04:49:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C56916B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:49:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3A50A89B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:49:09 +0000 (UTC)
X-FDA: 85371410418.04.82C0875
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 47FA140004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:49:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U2H+Y332;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793177348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnV+4QS26pSX7EnMfpDaRxIt7mL09p6ZtWCC/XSNX4A=;
	b=WSkloQcT2YbXraxj0keFLRyioPX9Lg3GO40XmMmJ6fyqmsjahbVwQJf2+mbqi9KMZKgg/2
	aZjUUEN9+NcOZczGJ2giuZFOrTii2XgRpUQmQ43x5sTTemVIuyNt8L+d4Jl46FTBTdZSrO
	RCUEuFYcy3UK4Mt4hUP86JfOUEBbiMo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U2H+Y332;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793177348;
	b=jpC3t8tA4zyQXrP2lJ9tKS9p8NOx+pmNREqmoawSdVvP0VEVnb6JmJK4diO0+WSu1mb5Qf
	xxvNRmvfsccZyLnWBp2mOisnzoEZkuSX7F2cxIMgGCHQEr9I0G3mn+M8+tCjaI88A51trU
	9t+IHU75bqi+ZfOzLnBaNasRmZbv648=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5A9E600DA;
	Wed, 28 Oct 2026 08:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E7D1F01825;
	Wed, 28 Oct 2026 08:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793177347;
	bh=VnV+4QS26pSX7EnMfpDaRxIt7mL09p6ZtWCC/XSNX4A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U2H+Y332KrydKkbp+oolyWdoKHr2biLx8ESo49FzvwiLvtUntLGfGSEUAiz9HDVxO
	 95NcCz1jm9zz5AhK/BlsZ4vP3FjzZd5hTb6muzfFjy304AHG8cjf+/A8sBMit+bKZA
	 PBUj8F7W1EUjiR6KV5V9CuCT+vtCyuwd5aS2hYLIBQn7n3+hYRu/wfeq9ftms5rebO
	 YtuAhjIXHrV9cwYzkXrSaeGMcX/UntIhpBS4qo4xMMsRjCRL9/Ul0GXBn82JF8iG4w
	 Xqpbki7lLEKSz8s/u2zOVumGSCMOjhJtnwqY9/HtSHhqA54Rx/65462ez2QMvwH8+V
	 0ZGrW8R33FqqQ==
Message-ID: <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org>
Date: Wed, 28 Oct 2026 09:49:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
To: Imre Kaloz <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Magnus Lindholm <linmag7@gmail.com>
References: <cover.1792609488.git.kaloz@kernel.org>
 <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
 <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org>
 <20261027212610.6798-1-kaloz@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027212610.6798-1-kaloz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 47FA140004
X-Rspam-User: 
X-Stat-Signature: drr39auq4zt49qxai6epgqzhu1gyt9zb
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793177348-370557
X-HE-Meta: U2FsdGVkX19+hQQJAHpqKoUNPbEcbAHAal7R1kEDfT0FGjC0SZGhle6QcVhtSfdDMSy2DDxQsDc0E9WnoeuNnf0G57he8/V0XvPskfIEjXPBwJmzaPqG4mKXsVBcjxUlPMlfkgSNr4C3QetQExSQ57ubmY2zSwHwjzqXQxlAkCHJnDJN7jjBsM7ZzXN4iqRJqa9oHr9r5J7+BsJIaiDmblNM41Vyh98yESoUSwFJNIL2BD8IvYmQ2HI7iA0La0X9k8frMm4UYc81Ls2/Bzy4XgVpLFic7Vi3/eOMMcbbVxH68Oxv3QVNikhPmWiShoM7wJFd0/VCYcjinh+Tp6Q3+NzCca2gIoTYgbQKy4/I08Dqzzz9VGx00feAr6rWsZbC0AxzjNCB4Ni+ZAxbDesWY0jmBWEj2Gon8RzcYdptM4sqSaSgpavkpSosKDHZeW4OglADRg2TRpbJ2HDCT3VEXK7zWUoP28n4+/D5Zvo5F9AYQwUdcngw3kwwgj5QCBlkIwuicaaVUf2ph0BkropAn19dmtnzgZpLkYihj33MTHkniCB5a2lJgzWrCSrFeCUzRiLIIXCahfN29gp/nwfX2dpDjQRIsxhoXE+jTkMjtb8AlLqnmJU9c2LxNFgHROwCj9EZt1EFy5vjWwlFEBtkqvOv7mGOEvXNr2FnNuevpYGQ2c3qUqlz5J87OqFw3XBJcM1fJR7lwvRc5q1Q7YMO4x4WVBcb3mtsVsgVuqDctQr6kgbyP1GoZcx9YF9k5hQKdcd+iOs4+hl2C2ce5VcW9Tpoaj0rNQIwk7bMCOIRGVJaHKbuUfxdLTMsTIBU1Vvyf8ST8quYMxGSWix1FL/9vZ7NAdMgY6L6tfycfJbM7/1w3ovRGyl9GD6Eul9oRyAmzIbZAK+m2ibR4DQ098RVsGJCVZVxWqUtBk3id4KSJ9vwxEgZyQXUrCupXp6lvtF+nCS+EwLRYkdVqCeIghQ
 dmOE2lAA
 QXcusTPIDjUFvCrKVX4Y6O52kQGRMfXb75n65p/ag3ZZAzgN1Ww5R944Y+vHUtnIjmr6QitmClpKfkgWOyUwh4d/qrJrHnZLSjj24ya/NlxOvcC4Jmf6DF3TREQrEdmZ/Tz6jC3RfSI/p1rkvthkXpdPPKvHn1FheSMjtjrAZqxJSOu+MFHTHvg/kfPjcJ6kxEvs6jrfak+5BY9rkiCJAsTrH0C7jhEH1YfHwz5oSqkm7YioQPjAgVK8gqZu4voexDMq5OEaHyncs7Lpaba3GJYak1XAwmD2Uh51Yp6DIS4cvIkuSC8Yc0rWMyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 22:26, Imre Kaloz wrote:
> Hi David,
> 
> On 10/23/26 22:53, David Hildenbrand (Arm) wrote:
>> Is there some way we can avoid this
>> helper-that-shouldn't-exist-but-someone-hacked-it-in entirely?
>> If it makes sparc64 slightly slower #dontcare.
> 
> I tried three ways of doing that on an Ultra 45 (UltraSPARC IIIi, two
> CPUs), all with move_pte() removed entirely:
> 
>  A) sparc64's flush_cache_range() flushes every present page in the
>     range from the D-cache;
>  B) sparc64's flush_cache_range() flushes the whole D-cache;
>  C) A for ranges of up to 10 pages, B above that.
> 
> All three pass a test that moves pages between cache colors with
> mremap() and checks for stale data. With no flush at all the same test
> finds about 15 million stale words per run, so it does catch the
> problem.
> 
> Medians of 20 runs over two boots per kernel, against this series'
> move_pte() as the baseline:
> 
>                             move_pte()        A          B          C
>   apt-cache gencaches           6.63 s     +0.2%      +0.3%      +0.1%
>   fork+exec                                +0.7%      +3.1%      -0.6%
>   mremap 8K, same color          14 us      20 us      43 us      20 us
>   mremap 8K, other color         21 us      20 us      43 us      20 us
>   mremap 1M, same color          30 us     524 us      60 us      59 us
>   mremap 8M, same color         209 us    4152 us     229 us     227 us
>   mremap 8M, other color       4176 us    4166 us     236 us     233 us
>   mremap 8M THP, same color      14 us    3933 us      43 us      42 us
> 
> flush_cache_range() has more callers than mremap(), mostly in rmap,
> so I also timed reclaim, migration and writeback (medians of 5):
> 
>                                   A          B          C
>   MADV_PAGEOUT to swap          +0.4%     +12.9%      -1.3%
>   reclaim under memory.max      +1.9%     +17.7%      +2.0%
>   msync of shared file mappings -4.4%      -3.4%      -0.4%
>   compaction, move_pages()      within 3% for all three
> 
> So A pays on large moves, B on reclaim, and C on neither: it costs
> the same as A on small ranges and the same as B on large ones. I'd go
> with C. It would only flush on Spitfire and Cheetah, which have the
> aliasing D-cache, so sun4v and the SPARC64 VII in Magnus's M3000
> series skip it.
> 
> If that works for you, I'd suggest dropping 4/4 and using C as its
> replacement; it's below the scissors, on top of 1/4-3/4.
But that's too complicated, requiring page table walks ....

People running museum piece hardware and complaining about performance of mremap
or memory reclaim should reconsider life choices.

So I'd say, make it as slow as you want while reducing core-MM complexity and
not adding more arch complexity.

-- 
Cheers,

David

