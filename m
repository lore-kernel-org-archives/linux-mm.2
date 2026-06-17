Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9E5CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3B96B0005; Wed, 17 Jun 2026 08:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECAD26B0088; Wed, 17 Jun 2026 08:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9D66B008C; Wed, 17 Jun 2026 08:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A25A96B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:24:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88B3EC1C70
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:24:32 +0000 (UTC)
X-FDA: 84889322784.11.C8774B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BF4B7140002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:24:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lmv/R7wz";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mg//3UQ70bj9uUlzt+8oEG9Cfm3gjKCCACIO6Tks23I=;
	b=dIkED5LMG6vmxWYSs5md20fdpLZfisSljhO9nJuGaLGMCqGcLoZWp2wgTb9/Uj0eKqlkDx
	bJwA/6a8l3iT2jExnQkFSpQLTVks/s/FlvK0ZS+poxQpTJ3kZ+HrEIeVhf5YxyKjd+gRmU
	upZj/hMq8JwJiyogDTuC0Zx1aBXh4X0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lmv/R7wz";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699070;
	b=VkJL6RhDE/SoLebaQ0rvYy7oVaXm9EgWwLOL5nJIzWdXIgnjeaDZzCPfJDqxD6OgMGdbOC
	H9pRE6bkgFAHRA3+vIlnf9lggF49sCcvB5rLgnrQggwhM7gCAnsKtXWWqT9QFhUgsMf5/g
	TtirxC+K/f1jG1jh1nnEG002NEQ1o74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AEE5541691;
	Wed, 17 Jun 2026 12:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6401F000E9;
	Wed, 17 Jun 2026 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781699069;
	bh=Mg//3UQ70bj9uUlzt+8oEG9Cfm3gjKCCACIO6Tks23I=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=lmv/R7wzQqBpZfEQbn76QBwz/iFG+yXO4BfBqmzBv3rCSigjmnak9KaK5P7drp8KS
	 X24wbmn5XrF5eyxSZkfnDlIMtU8l2CX3mTPd6AajXpEsmJHl6pyR5NmeFb7yVadowK
	 qKiTWGc7SgXYFTa/l2e9JSJ0L3Q2IFtZ5ko5ntW+l6YP/EcDf2ItWrk41+E2UDyePB
	 o3pAufiC9gsjNw/08QKk0BNQwjIuIPvyL05YxBhIhyp2FCZcKlIssm2lzlmrsQ5JEA
	 rPdOKsKKAdcaqaKrgDXFuW7eczyv0LGLGBy71qKAC0wX70wBD6YSNyz0hmeIj0JejL
	 gm0sgV+WlhCAg==
Message-ID: <100aa8c4-5848-49a4-8b6c-17875256cc5a@kernel.org>
Date: Wed, 17 Jun 2026 14:24:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] mm/vmscan: extract folio_free() from
 shrink_folio_list()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Zhang Peng <zippermonkey@icloud.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
 Zhang Peng <bruzzhang@tencent.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
 <20260525-batch-tlb-flush-v4-2-83789d6abc00@icloud.com>
 <c6220407-fbdf-47ab-a80c-732e470894bf@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c6220407-fbdf-47ab-a80c-732e470894bf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF4B7140002
X-Stat-Signature: e9x8zajec7wdeeqden18chya1zc6brwd
X-HE-Tag: 1781699070-84864
X-HE-Meta: U2FsdGVkX1+3rqrT6cCBGmLZdWupQigOrbgeOF6YVYe09Z8cneTY588ZeAE1brru2ohJg0KDtYTZxWUiNv1Q3mpxfHciGtaE+Mk8brRs2kqPTu4YjCnb8iL9EPbWCzYteip3Z29qjHd1bo0lUvibv2iWax13euqFFJARSaxP72kvgqs3Ln5FG1yDEJQbAGT02z+uEy2wiBvnrHiAw6N/2reyRFl5VKZ4MohcP1tGVmRJekwNEqngsA0vLbl4/KmjBJMLDR04PohJN7/bUJ/PidvHo4KniD/2e0tDNri4ax0MQiyQogfPxoFQPreU0puQEPzhl+uCxGhv4puiU/4Y6ZQXTtz1auVHOfhjz0O0HxbJ3H1tsv4j8wzvehZi4hHpOEbfIkbhaVYzrjwubFEVshcfmywohkS4xQyZiz9VpHOf4rSvnXrpjRm6zTnoANIu+6HS9YmdGU3tOOd9Z6Geu5gtiUTY0xoBK6O1fxkRZv6MfYj+Kgj6m0f/b4GHOjOghB9gRAYWsiYsuCwd4TSfiFSufK8f6OVU/8e8rsMIR2oQ62E788zJsRMcwocSUQidwQunlfn7pa1XZEuwZY3Eu6TLqxSGLZJZPZk+f7Q623Xwcz0m+0s/q+sK0JjXlFEGSh1h6y6XOy4LJve1zBWWIGpm7xlJmSESzjq0hQ/dZzDTR8yX4Kix5/fRJGbR3SzkAu5TUqIZNBrM3ayhd1yiBy7GPrHwTCrDi9mDJMGTxCfIUxP7qNdWlrDt8z0an/PG51ZijUD8i+anB2sKm6Z8U08K2nWWABZxVITyFX09zKwECyedH2bsBbU7npPYWFcJgI+4VDG0j02Rb4HwiMgEahvTXs/N0jc/Xwo9T2svdNughYBdTkl8m1MMmqIwuRYnPrwyptysVlBCZNtPfHh3zGo7r6U/O2CVUdNAvk5Nd+cCcJU435GRCYYG3AIRM4rZ7qh3+NTVoPkeBK1GYbN
 tGw+KWRX
 JIAMg2hmVvdxXa4KJieeeqSMa5B2/eB/3NpPCYuMAh8gAuFKJgAhZMbvdsIVqfHErflRQZdIalnqfTRuoREJnrP3Rn0+faFnYV3clFftuFfSOmo7nLMG2xx1thdGX37SktNGDSeSHIOfPqM6pKX0eAuQJ3qndm6UHg3HZnT9oGL4P/qOT/Zn+LNCcARIX3dFYGs7H/cPMfyfO5YBsO581J4qZmIaz6Lqvr4sgDPCVaVKDp6S9ZnkVwq/AkOrBAWX9ILF5eLSikk3AhGtreLVCQ0OCdMrYLA3jrhIzpaNQyi7dhfHPxonbSq6ZfWCW/S6yCHA47pGhHOHw/lY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 14:17, David Hildenbrand (Arm) wrote:
> On 5/25/26 16:57, Zhang Peng wrote:
>> shrink_folio_list() contains a self-contained folio-freeing section:
>> buffer release, lazyfree, __remove_mapping, and folio_batch drain.
>> Extract it into folio_free() to reduce the size of shrink_folio_list()
>> and make the freeing step independently readable.
>>
>> No functional change.
> 
> As you are touching the code, I'll suggest some simple improvements as part of
> the move.
> 
>>
>> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
>> ---
>>  mm/vmscan.c | 168 +++++++++++++++++++++++++++++++++---------------------------
>>  1 file changed, 92 insertions(+), 76 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 886d8b4843aa..b31f67801836 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1072,6 +1072,95 @@ static void folio_activate_locked(struct folio *folio,
>>  	}
>>  }
>>  
>> +static bool folio_free(struct folio *folio, struct folio_batch *free_folios,
> 
> I don't quite like the function name, as it sounds like something very generic,
> when it's really specific to memory reclaim code and does things like removing
> the folio from the pagecache.
> 
> Any way we can easily make that clearer? I think it should contain something
> about release and reclaim.
> 
> folio_release_for_reclaim() or just "folio_reclaim()" ? Not sure.
> 
> 
> 
>> +		struct scan_control *sc, struct reclaim_stat *stat,
>> +		unsigned int *nr_reclaimed)
> 
> Instead of returning a bool, can we just return 0 / -EBUSY? IMHO, a bool mostly
> only makes sense if the function name implies some sort of yes/no test. (there
> are exceptions).

Stumbling over patch #4, I think if we call this something with a "try", a bool
would be fine.

-- 
Cheers,

David

