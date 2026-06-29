Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F96EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178496B011F; Mon, 29 Jun 2026 13:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129BA6B0121; Mon, 29 Jun 2026 13:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6196B0124; Mon, 29 Jun 2026 13:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C42156B011F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:04:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16DB3C12CF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:04:37 +0000 (UTC)
X-FDA: 84933574194.17.ACD5372
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2CEB21C0011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:04:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KR+HDkX/";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782752675;
	b=e5HefH/nNojHkJbePHuk/bZsUEwsDzDGy+KbsJArkmI/wwpyNGTa94tfyGJJrs8OLdh/io
	71aGjNPPIoHEhm4j9p87hd8CsOjvWHGxKkk1f5MO+Gj053W8nGdFtPWLJDncd/fX3YiC9T
	/E4xZi4bidUEr7uJZDJNXh1H9LnlAts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782752675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ul6f7sQKvd0dorXycCkumAOsgczpxyVqCRrPVWEZxzE=;
	b=bg2Om6zoVE3FGxvJuT9ClRrIbo3HUaCOSFR0F8F4C4yVfqundfC1Gl6AV21SGZGYuGebQS
	SWObs9NivG4RuZpAu4E0epsG8KhH8yJU0n0m39TlDypCvsDV0oSU7eabn9zm+MZPV6ZY3C
	CZb1j4k6JcGkPE3pmHdqByWB7op1T/8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KR+HDkX/";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60E2342A7F;
	Mon, 29 Jun 2026 17:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80491F000E9;
	Mon, 29 Jun 2026 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782752674;
	bh=Ul6f7sQKvd0dorXycCkumAOsgczpxyVqCRrPVWEZxzE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KR+HDkX/e+DWcI70K4NbnOWmimZctb8DsZesFzOfoRbt2YiJJd5ywFThe+vJUJZdh
	 p63fxw//X5QEMiVKFfh+/Xo7AbACmQSqVfULumqMNXeqwt7oYJdiswxglOvpvm+gYP
	 RuBv/kqyqTbU50PT22VB7eCTe1A12DHVqVdOoo56Y4B6UyZeBUUWz9OKlMZ8FyaPhJ
	 +LLqVW339hEBK/8pv6fsO0HBTB4ZgQT69C7X+n022la3K8wqD1ZFVfO0XvoFWTY1AS
	 pq3oPNKGNHJOSTzC5LxbaMmsFi/5xTr02h+zqPvJgtGu4vb69ixMJRmkmRaMkE8uxw
	 NltG1ROyCmuVw==
Message-ID: <20a5dfd4-b3c7-450a-8a70-08d0345aade4@kernel.org>
Date: Mon, 29 Jun 2026 19:04:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: Andi Kleen <andi@firstfloor.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <cover.1782676497.git.mst@redhat.com>
 <akHUboUaYi-OJHFu@firstfloor.org>
 <20260629033608-mutt-send-email-mst@kernel.org>
 <20260629043417-mutt-send-email-mst@kernel.org>
 <akKjOG6iFhGNTFYC@firstfloor.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <akKjOG6iFhGNTFYC@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2CEB21C0011
X-Stat-Signature: g55xxcfmodxkntkb4pe16qa8d9r43gtc
X-HE-Tag: 1782752675-267238
X-HE-Meta: U2FsdGVkX185+uqTdQo4Yb8w8TIND8oMJGbyGnRmH0TUWB4qpKyi3VgKn0Il+p9+EKEvToXdO3876aEf94UZk4BQvHOoLv+QKD87yHa6QpZNcF+kGUU5upjLQ6UJamyoD74ioEYQmLXcJObyP7M2R+1dqA2b4mZwYSYNt3nlaq3PArspRykk+v9jZ6gp94t2/oo8FLP3tHp3aCNcKQ0WcqcrDugw86uiqFpocwq0QVMOzzkzGNnbm8spbcFCixWw61WA98d834sM8Oy+XFlnDl8BOw9QNnnyka/DQn55TvILIRX3q5kCgrkl7UCQbmxVxoM6oFvpnfySGSmMXQyWfhasajrisdghOeCdI6SkMPsFla8jLkDEtXE6Efnw7uoZZQDL/kHYIbb38yJbcgKJwZm3+MjHXHLryzpOMUhvNZfmvnI/FMmXDu1w9MuX+VDt6+4kGrms4iMfaKzRTmtzG5g7PEpaACmG1XaXbi1XJUyhSVWsCCPhs19IHd42RUQNP9SDKtHdPoni/2XiGRW7+br3JzGJedNqWCxzP+L5ACne6IbKLJi4foFzGsVFtKlTRy1oFhDaGyb58XnabkV0R0JFG2Ig3f7tMin7qk5XTHeWRqavbBcsluxwvXUGctqpJpx56TbWh+Ku9g6p3jrsm1EdM3Hvt21nklX+Ljn1BSO5g8D6MGS4uxIZngVtgpVDchYI+Jrw+nakGQPtblFgNf0ZcaM+Ukfeu56WCMW4Fr9D+I/lMHjPlPKPkWHPgLf7Aypvrzg1JC5/xI/GdX+hZuTvlFZ1rCZ2Xw/aWcu0GThkTBIBcRluO2jqO9yyEvO1c98vVH3eNKfVuMDKQ72Vcfm9RUAYvHk9HTWyj4fek2wH2KOQoNzr1eAcQ/lPTdhhrFrwet7pGGic/X4PnGY6Vu0J5LGKhPGhjGtd0XuAdJxgNr4l8akJYlX+aZ8axIVgB+6nmSQKtU74cNyQl87
 aSf6TRZD
 0ZTkQGohIeBO5uhlfx/z16v0JrJnb4tBOUiKmRq3tZbQof3JdKW3ILx0sUMDOr75gCxK6oHeBoiwGsVL50TsEDRBGp6OUqyl7mntkfuQJdKMJdZ6527ccUPiHnpfXFH+bRQqL3Dsdj/ao75kqApkmbB5M4gYoFfWEz/vklxtWnjkXB5vbX3HqOCDL5Om2gpFhinWzZoGyl4LwK+l4DENA7p4FizCXgVnzHDaUCdyIjgmUcO2ejO5gDsaetz5vN9kMhSWGpyeHpeKAxf13sXaDjoNeEmz3mzEtyT8LXKfgKfErrUU2LYoGqvLFuxX+rewFoybgWgMFYKgdz03G6jfZJXp78g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 18:54, Andi Kleen wrote:
>> However, this was a basic test, when allocating 4k pages. With 2M hugepages:
>>
>>                                    insns/iter    cycles/iter
>>      -------------------------------------------------------
>>        base                       20758 +/- 12.5   191208 +/-1946.6
>>        rcu                        20785 +/-  3.7   197108 +/- 132.1
>>        atomic                     20727 +/-  6.4   204591 +/- 160.2
>>
>>        rcu vs base                  +27 (+0.13%)     +5900 (+3.09%)
>>        atomic vs base               -31 (-0.15%)    +13383 (+7.00%)
>>
>> and even with THP:
>>
>>                                    insns/iter    cycles/iter
>>      -------------------------------------------------------
>>        base                       27220 +/-  2.8   192151 +/- 483.3
>>        rcu                        27248 +/- 30.1   194159 +/-2746.6
>>        atomic                     27186 +/-  3.2   200526 +/- 746.2
>>
>>        rcu vs base                  +28 (+0.10%)     +2008 (+1.04%)
>>        atomic vs base               -34 (-0.12%)     +8374 (+4.36%)
>>
>>
>> needs more thought.
> 
> Well the alternative is to not bother with RCU, but just wait a bit and
> check if the bit stuck and repeat if needed. While that could in theory
> livelock it is extremely unlikely (especially if you add a bit of randomization 
> to the sleep)

We discussed that a bit already. Hypervisors make it fairly unpredictable how
long you would actually have to spin.

-- 
Cheers,

David

