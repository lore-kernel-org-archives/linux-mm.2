Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32F4606A336
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Blqa9Gyl
Received: by kanga.kvack.org (Postfix)
	id D80D46B05B8; Wed, 11 Nov 2026 05:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31786B05B9; Wed, 11 Nov 2026 05:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9176B05BA; Wed, 11 Nov 2026 05:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9417C6B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:30:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B89DA026A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:30:35 +0000 (UTC)
X-FDA: 85422469230.10.18F5166
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 225E220006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:30:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Blqa9Gyl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794393033;
	b=dRvrSm1drETQMiq+pMAh9JjXl+ZGqJra4GfKTW/JQMG+wLyOAebg/Qw2KpWNsiTkUVSK1R
	hre1UPQrQ3N5su3R2Ob4Hf8XDzk9ScIONPVoxAsR5W1tiFK9HEj2WAi0bnoEvbIUiJ7pZ8
	OOddwIzcRrKyYwVTWTGOjK+2R+pW778=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794393033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3saJzizEnMz5wH7u54dhoxxqETLwZ4xBqMdsXbVIbJg=;
	b=gIURR+L886uY+izzw8ijwxy+rNNq56ChyhYCt2n709cx68ptBBQicvY9eGKGMNkJnEDMA9
	UO3NojpAqllxrVcFp2KOWxUmcxI0rHU8QU48o6Ya53wGWCpDHFBdCC1XL9kK+kwYT0lda1
	menoIIyf371A3aC/Iqftn5FyduylC4U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Blqa9Gyl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71CBE41816;
	Wed, 11 Nov 2026 10:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39161F00A06;
	Wed, 11 Nov 2026 10:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794393032;
	bh=3saJzizEnMz5wH7u54dhoxxqETLwZ4xBqMdsXbVIbJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Blqa9GylRCpbtJozK/p/Zo193IJINi2WaRazttyjHzqBDPNoJRNAG1Vziv7InKfMm
	 xoXOB2cKk/bUFZNRGvTrkPsch1q1hPHaStFBLVqxTtF6c12RMhuX7/RgHp3U54HKX9
	 W9TgRSqiQlPDbwe6Ct2C52W2zAH8kFVJspSa8lQ1mdo5XYiv1ZsHudg21foSJpwhiw
	 PHquU0fbT4mFR6HmLFnHvH64e+t8ouqsuUuH/UT0BefrKwlHJI+iEMZt0h6tBz7UjC
	 cEdzy3mMcK7KGZB+oNBWbJ19n0lVdM1IdHxPvHTuZFM5XJSUBTwx1cKrbXnYRx+beS
	 ID87t6aBRiSNQ==
Message-ID: <45f16b1d-d53b-4bd4-80af-292880622edc@kernel.org>
Date: Tue, 10 Nov 2026 14:01:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm: gup: clarify a reason to check pte/pmd in
 gup_fast_pte_range()
To: Rik van Riel <riel@surriel.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-2-2aaef02df0e1@arm.com>
 <a6d539cbab73091647fc2308b69fdab3069b0fe5.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a6d539cbab73091647fc2308b69fdab3069b0fe5.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 225E220006
X-Rspamd-Server: rspam12
X-Stat-Signature: 73ozdprmjcd49eiey8nitbxz7mz7hf1d
X-Rspam-User:
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794393033-897075
X-HE-Meta: U2FsdGVkX1+d4Zsd+bUacKrxzh1WqwL5BORUVq5QJxp+SlXVhRQIVbazvfheUNHXj2WVU/jucRnI95KtSo5nLzj18fcD+891NdilFNYhDjFh4S35JGlkZfVHwNXDHI2zrXsyNpTEdfPm3OHhNhr5v73GvxKy4rU3OHmaYeG+bFpUqXE1fc6cbPjjJEpvNQCwXIF2mxkuzTG97MkZkb3gxbQDOhNuVoS9cdadfoEJsGC1H43ysyI2tcdUvdcIXfB2TDq6boAXqMW1PdCpWu335t/e1R6gsoNM/5QtfX6F6JZUuGnpnQFfXqdfEzYetAVgN8T+tBM9IvfxbRtez9FzvJfDm5KaXE6PTVbYpxtWUWeX7pBqlVcYcLGPWxz93zSxFrPMvu8zlUTFcy8rKW2Y3eDMKMURsi/5IS9lkC3Sbxa3oEai4gBEacA4EZ5W9FX/e9SfXmEF/LR5v5ATkIAaPbsMcW+2oLrz8zoN+dd9Ni8BV3Qr0DHwJ0NY+eHxfaX+vySLrpb05lPgLbX8Ho1/iPVff44f5GqQmlyil4LiDOuhEuanTuEY8zzvsLqx1+m765YDdGRluXqr82bbf8dzKOVZkAC02UT0c32wMiK0G4m6+/ZLjeUVQvsslsFqF30oMKKYMtLpVgJhaWDbWcaZZICqrqrDIYD0qdJnoeJ9mDEdrl7DUqmG948HXy3BcW9s33WPN9lnk1OvE1OULgKSCwYa4bkATYhEGZWU9P90hgE1hQmRlpan02x6zc2lX8h6jQEeUiLL/GbJTmvfbHi6QKVFw/0/HJan1TaZy2fnKlmVaG2YBqC9/mhqwdD9eqMmIU85aPjG16JIYa7cMa/CjXadq+owGbQBs5G//oYKPvR/jiKFKY6f3oWwrhrm56ub06KQKKhdYQbzB2zAHE68Kjefc/UH2nKiQVUYXLPXpIJbukovALVFyfpv7rwH7Mk0JVGHZjBaePa/dzyoQo2
 h4cfDpFa
 GhVki7I/WwZTWwa3Xldz7jXjqENgRXDMIXUVnwGTSdBzHwm2hAwMSdEpDIQx5UPnvLvEpCQV5O5U36nx9nLoW73lSTrCXo4GIUpesaGHcslgdgQauN8ajxrRzZ4Go+Hm4LdiPjzL4YbnyPOQrPSGVT70l2X5VZwsoLEUuOuuzfhLOdgeU6mowan/rcEhXjR3cUKxQ7RHFbayo4gJdZcTGHriGtRAvwp6q292AizckKBO183KZw1588K1HNiJU7dIiVBv9ROh1U2N6YsXJJS3dpsvtF37p+naEsUKI6awM8bxHc+Fl96WB0l0KRqS0Vif5pxPJYxWh962fb2aTOcnd+bUW/6xmLLkK7l2J6u5Cb/13gHhp+r82T9SW+89KCe0VQjyAObmASqSU2rfXzHVf2mdqE/23cO/R6wo0Miwl2+ZFiMWFTE46OikGqAS0bc6iNQ96bW4Slr1VpUYv9BHy7jjzdpWYF+E3mv8k1fekdwuQkqKZg8ldXYfxhSEdjisnaWI1lre5Ep6I/kLUw6V6rmHom3tYPWeJ5YGbvCfhBdQ/m9n80fBrGNYVA8q6tKOs+Y52QYejDLAEE/mpS1GKbb/I4AS+faAT6olyyoWIhXoEJOkFq+ORHj/Xrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 04:50, Rik van Riel wrote:
> On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
>> Clarify a reason to check pte/pmd in gup_fast_pte_range().
>>
>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> ---
>>  mm/gup.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 7d43ce717b246..7f9348c633d58 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2881,6 +2881,14 @@ static unsigned long gup_fast_pte_range(pmd_t
>> pmd, pmd_t *pmdp,
>>  		if (!folio)
>>  			goto pte_unmap;
>>  
>> +		/*
>> +		 * Recheck the PTE after grabbing the folio to
>> detect concurrent
>> +		 * unmapping or protection changes such as by KSM.
>> +		 *
>> +		 * Also, recheck the PMD: THP collpase can detach
>> the PTE table
> 
> collapse
> 
>> +		 * while its entries remain unchaged. Checking the
>> PTE alone
> 
> unchanged
> 
>> +		 * would not dtect that we are walking a detached
>> page table.
> 
> detect
> 
> Other than that, Reviewed-by: Rik van Riel <riel@surriel.com>

yes, thanks!

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

A respin please (maybe tomorrow?)

-- 
Cheers,

David

