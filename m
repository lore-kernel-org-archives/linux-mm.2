Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC638C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0E66B00CF; Mon, 27 Jul 2026 08:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52A16B00D3; Mon, 27 Jul 2026 08:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A386B00D5; Mon, 27 Jul 2026 08:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 803516B00CF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:16:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D1DC1C0E9D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:16:49 +0000 (UTC)
X-FDA: 85034455338.01.6702710
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A6C814000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:16:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6rwu4UH;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785154607;
	b=fWgDuFmLc2qKSGWb4Y8gIFyiqJa8oRxyrmtOumal5n663r/flqaqUSrxkbaBCgITO1pgC4
	qf0Ofq7fU0IqzEY+RoE28+HW6ChNhv8VdI9LbRZBTxokE+rD05I6ICuJV7zG8F5RzwOr6e
	29W8wez+yiAvqkom8cStCXZP8yXmVUQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6rwu4UH;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785154607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIUEPpso+zQtbGUo/ufSKSePHycf4z7cdFiea0Gk3jE=;
	b=i1XQhln1w5jFSdrQHuGqeXho+Ph5Iru9gielI9Yxyen2f7W7KgtNQNeJPeGZZU/nECEF2a
	G7C9hfK3SEEQFAxS29MGxsQDRIbnb9QfzA8a0pI72TXTEEe58j648hJF0FGvCCK2/poHzO
	TMQDZQEwS9wMa+R3EjIIwDl9c/zaSCk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DE14437D9;
	Mon, 27 Jul 2026 12:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5911F000E9;
	Mon, 27 Jul 2026 12:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154606;
	bh=lIUEPpso+zQtbGUo/ufSKSePHycf4z7cdFiea0Gk3jE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q6rwu4UHC4+41OOIMAqYG6j3l5cKWu8sggn2bo+CTVF4li7ddiAGnzmiBbNBdJfK9
	 QCMWv2rhm0eN9ws4rbTmiRHmdyWoBNHybjSmCDe67f5aS751/cNxiNhUdY6/Kvvyj+
	 6k/21+MgMbtu183HUBHIDuVNZSwm+bOWxrs7MoRM7I3tWTQIcpd1RDJl4kr8w7Kbrp
	 sg9WAXMGglCBlmFXilGthg27+qOVuYU8GK8nkcXhi4cpDgBe/+PO0yH4/t1RLh/jTn
	 1hGZEK0gkTtuo08NsSMTP0sucDdqm7/N32BlZQuGpvmfUzNt/4unusN1nU0EXourGC
	 rqIbnAfnFO0XA==
Message-ID: <cd6652a3-547a-47b9-8907-e98a582a238e@kernel.org>
Date: Mon, 27 Jul 2026 14:16:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: Extract non-swap page handling to
 do_non_swap_page()
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, liam@infradead.org, lihongfu@kylinos.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
References: <10c60511-c841-4bd8-aa5f-0d826b676533@kernel.org>
 <20260727121047.4140-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260727121047.4140-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A6C814000A
X-Stat-Signature: 78bztimgf3jdtqhcgh7kxefzdqzphzb9
X-Rspam-User: 
X-HE-Tag: 1785154606-966812
X-HE-Meta: U2FsdGVkX1/vhWl1oL9Bb8zlxo/JD8iHuehffaEvAsQcKD6sQkTvWgKxxB/eXy46SBEFzBMdqbsYwhKmC/5JrZm27j90z5vM4f0RMNL8HKJiSf4DBUZruvG7Gl/W2gCaLepBrffvOLdPiuSTV8ZA/fKFvCrvYaJSKWTsNNiDiQhxHCj6WLn43gvvNWPcc8HFBryhPyGOm05tkiCRWrOUfM3tY4dC9aeY1cFkESg5AJKKz/pvlw+YQMIbfuzop6w/dx+FR6E+Bp9HJlVl63xpC/u+wtoFca3SGYs8Nfz8jYb1W06h1uGpRP3v0RTikPdoEg8xlcL//2WuMVE5yWfgT9/fCuvT5c5cOZLjBObr9UYmoOYgX55xJ1tfhS6reTUPVWbmbACDFwlgffrKfi9l/PbNe94QMFSOaNP1bDvvD8l7Gs4JGHtABPAjjcRZUqoCALQitX389jOVQ+/lhcAirp+i+jDTgnD4A2UVHvi4CxWe9gHoqGiyLczPSzEWe03Pexf4vkABMogH6hEhmgKPzT/ezc9YCU9mMwc90crwzdCflUJP5XNWfgdTo/bRhQLzQkm+NoD0c9zYsNKi39+vC7J8X5C4ldRUcu4gulJYn9fNLdVYcJN+wNQQeoCWDtFdFfhZ5QOVXkKRwzQGIvbTQyxCAZ27ocLXzzpxPqEuSDiRxg56iY6uRvHumXWoi+vRI2Of/tbCL6vQeVceGD4ldghNPiMkG5UneQQzorNli3gFRpMaRyvGmdyLyXAp89rRLahaxLLN2VRCqVndENcscLpweeOVLCN0lJbuCxzp5RQvouQxv2uWlipO3x4NRp3R2kPDC0B7zJ0QtAbFopzRs4VZET2UQoDQJIflWJX2sM/ErL/Cl4IJ9ECtI2RQw0HTp8iM2saHFfe8bT11IbwCIv5EIfLhuQB7H4tomnA5xJK5ji1HyFn1Y6uEb02FdHl1Y6l8LqF0avGiEQbrwVe
 vCmTzS6f
 +VXuM13Nb2YxCGsCH60IpwEPDE+UzUw+tC42XODRy29d4rZ/jr3sXJKaier78lSxYbAakyIqZNwV/zab3HL5Mg0ocRDqhIUvPyRGBm+DRuPJlJAf+dscS++qT2Zpq8GII+zuLPawlhiCg+p+5t6Ub82CXWDRIGy9u/qvXVyQc+FYpmcOrA9NUhH8BMKeG1oDbWjzv5owjE1OnlhDQ6h42OpvRn8b4m6FcWtm8Ip1tcTabhlrQFjUXc6kEME3t/Ps6xYptZrJbH3EeyEJ0RUktVZ8dF4mkCtX6ORzDBSVTq7leU1KN4Frt10DIgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 14:10, Hongfu Li wrote:
>>>  mm/memory.c | 120 ++++++++++++++++++++++++++++++----------------------
>>>  1 file changed, 69 insertions(+), 51 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index ae521baa8c84..50d8e92aef91 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4815,6 +4815,74 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>>>  	} while (--nr_pages);
>>>  }
>>>  
>>> +static vm_fault_t do_non_swap_page(struct vm_fault *vmf)
>>
>> We're handling softleaf entries that are not swap entries.
>>
>> do_nonswap_softleaf() or sth like that would be better than talking about "page"
>> if there is not even a page.
>>
>> But actually it should be the other way around:
>>
>> do_softleaf_entry() [currently do_swap_page]
>>    ... non-swap entries
>>    do_swap_entry()
>>
>> Or sth like that. Then, maybe in the future, we can just move do_swap_entry()
>> out of memory.c
>>
>> So we're factoring the wrong thing out in this patch.
> 
> Thank you very much for the detailed review, your analysis makes perfect sense to me.
>                                                                                                                                                                                                                                                                                 
> I'm glad to send out v3 shortly for your further review, with 
> do_non_swap_page renamed to do_nonswap_softleaf.

Read again, that's not what I meant.

-- 
Cheers,

David

