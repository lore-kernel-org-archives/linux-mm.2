Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34587CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284DD6B0088; Mon, 28 Sep 2026 15:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F526B0092; Mon, 28 Sep 2026 15:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FEEF6B0093; Mon, 28 Sep 2026 15:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DACD46B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:04:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C8BE14030C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:04:08 +0000 (UTC)
X-FDA: 85264096176.06.BAD2970
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 96B311C000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:04:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVgcqhtw;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790622246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4YDqvwhL3vzhgg/xwM/ybmpDNeCBVhLQL6j+EFLn6I=;
	b=mQpJ8ZmnAwP3YF8FrPnlXpTYO3dF5aupLoDD+pESEBcHrPCldG1Erz0s8EoJGA+42YEMBh
	/+KXOft8pct7MLjGjZtgFcvVls4mOYlKshtCHG8V6wsKENXMMFh+QYPj8PpRKvoqnzArd1
	SvsTiACZwzdCJn+zqZgnv9b3lt8IG2E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVgcqhtw;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790622246;
	b=I6ykjh69c3kZYKql8NI7EStzq1HENYMyZsHKacwSqEi+YkOqCIgkYVScb2ObqwPzujlqlP
	FQUyqXdWhYVNK7EFyDfADCvds30cvZC5G6RAbVXvd/s8XipaKYJyCT+/uhlfqjxR1wbpdy
	z3ToZLl43s/J1pbwz2Cq3j5aKydbb38=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5E7A601EF;
	Mon, 28 Sep 2026 19:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EF11F00893;
	Mon, 28 Sep 2026 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790622245;
	bh=F4YDqvwhL3vzhgg/xwM/ybmpDNeCBVhLQL6j+EFLn6I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fVgcqhtweOtwfYvkZOdYQ7qi8viute+9VAJk8LTZeI01KZeNI5ueFS7Xb4aROgo/M
	 tO5PsY45//Ob7rRzeLURKndsIHICPBWMblUo8RzJMQF8bY7Btaa6+WfnuZikHsDBeE
	 a7e9WgRf1mnCTa+E7z9TrzXeKDCknefGyzqQpmkS7ekPzht3IeWbzusU07aLXuKlFO
	 J2c9UwBDl1TDIrhNnp1eezGnZs5xPwVedAMwjCBEqCmJ7mG+YchMudb3qC0VVkoP60
	 8t27zEBwygphA72pHwRAjzOSKfUxzYBJnnmYQQg5A00khxp3PeZpoMrsIL+FS21smv
	 6VVIbtpZKIuZg==
Message-ID: <e36e8b24-81fc-45c7-8eb9-8b363e3d89be@kernel.org>
Date: Mon, 28 Sep 2026 21:03:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
 <607759bf-59f2-4ad6-b95b-e780ed2acba3@kernel.org>
 <8385F749-0F72-494E-9CA2-2E433A066712@linux.dev>
 <se2tjmpk.ritesh.list@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <se2tjmpk.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 96B311C000B
X-Rspam-User: 
X-Stat-Signature: qtcc7nowgmkdkhsqbipoyaex6zq6ongz
X-HE-Tag: 1790622246-658823
X-HE-Meta: U2FsdGVkX18b+/9Migt7WKgzG+vKLzyXfSr16zA0BiRucp8JvE4NhCyv/m9BbElakdgJY97D7t/lRRPKDyS+8ljKMlj3e2MEzSbF0sWipVdRur8sHzXlORTAujp/sG2CL/EtTO5oVXPIJRPm6zrRoE0PPW7fMNgI9e3IYzpjrW4gyTsy68uaLZEkiLo1JXjZiSIqQvghtf+t+G1NfYdAwRHeS2/70Ehs8zqnjBwPeBWgENcbLbiv5iJl/NjZ24EhANvhJvBqr2yEA180w6amUgAIEcqTNfQX3KIXcVCz0/St1TeJuPmLA1IH4EDj5ctAAtpG/XfRzuF1558TS0Rze2vJZBeiHBRqdzqst5s7lM26LPOu83QuVWEpHwD3UVDXQwXaduXlqH9/27E6zCf3xSCKowan5hrRUkyG4ipxLFNMnXDxuW5i7pdnX78zbQUxdkDVvsE6zpDL/zQKmLLvCTlj8MjMVALrij0guTV1UrFyX3ACNE0Z9l1PuxeYqE1mO09YghxZ5+mfk6+IRCp63p2jXXMrLnUCH4wr23OzdqD9ypRVxBRzwrZLwY1bOB5AMhQeWkeUtkhJFIGz7oZj7SfnUPrr6SpUvsgq8GkFL9sJtlBxhwFVHJVZeKeTYWaP4wSTSxypcUYTD7QDu4k5JXfdehtyIe59N3WuaSwyi6QSPq2EmRa7frGQRQ1m8L6rpkoy58d0WGEvNTPo1u0FVHnS7GxmOZUvaZgtPGoGxtShSupT0oSUHZZ7XTTdxOfDOqtLCDF9y6jWXu2rYVz8tAe7xwJYqBMvo0O88NfPXcDnKNLvV8DjpIIPm5d+a87i54CxB4Omp5ZdmCBCmGkkRsjNOU64g8uSNUVVGyP0a+0rHnh0ls3IdgD7vGCdjxGR6ea+nFWym5TDAX7cWjtGahOHnriDd7BPgNFoWbFc3qe55SK35X6da4TCtlgtGnExQIXb3xlBT7gs/Ywxhk3
 oCJV4d0e
 aiZXaWikUpR0CQUZiuKGoGMTl84R3w/+DpgkSUMUehp16JGmDhKqPJa3bFZIOkV38fNFhfRgUfLjGH+p4GTVd7KVmefxrdiu1Z9p+GaYDhOGn7wJaIzCKziZXycXQTYHot7q56pZEkS9aFiWWEU/ULPftycqnmS8KYnToDq7ArB4yW246l8DUFOBQPh3l3qb/BoLrGlaP0K4wIzYpCTBBy4bWzlOWw59jkHXPrYB6waoAJaRWCSrqOGfltzJu3yUHsWnxrHHzpnkb9Lo/O0Dgp5/VLADDVygYTsFopj4l91Iv/8VPiOjtnnVt22QoZaf+5baxi0cV++ldhr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 19:43, Ritesh Harjani (IBM) wrote:
> Muchun Song <muchun.song@linux.dev> writes:
> 
>>
>> If you're planning to review this series, I'd suggest waiting for my rebased
>> version.
>>
> 
> Hello Muchun,
> 
> Thanks for taking care of powerpc side of the changes. Is it possible to
> share your git/github tree somewhere? Sorry, but it's hard to follow
> which series is based on which and the overall multi-series is based on
> which upstream tree. If you could share your updated tree somewhere -
> that would make my life simpler.

Yes, that usually helps. And next time better clearly spell out the current list
of series, where they currently are (mm-new, mm-unstable, on list etc) and the
dependencies.

I was a bit confused :)

-- 
Cheers,

David

