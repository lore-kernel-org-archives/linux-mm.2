Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83284606A337
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cwTpowhI
Received: by kanga.kvack.org (Postfix)
	id 96B846B05B9; Fri,  6 Nov 2026 09:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91B866B05BA; Fri,  6 Nov 2026 09:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832806B05BB; Fri,  6 Nov 2026 09:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFFC6B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:14:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3ABCD1A0E09
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:14:23 +0000 (UTC)
X-FDA: 85404889206.26.8B0A4D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D573180002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:14:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwTpowhI;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9avFlgR2Q13CUtm3xqFDLDSVodrfgmDEXnm1JNjvm6g=;
	b=nbTwd8hqTrv3AdpWsYwF8GHlxitq7oukG95WsaMTZodrS+fxn8VKml8KZMq24jzLoj03kt
	9FOPob31/mLx4rlq2w0Q5so2m++WZp60/hJP2aM7rjK1zWqePmDOjfVUlVl3bMKhISailf
	vLHuSKb+9sm0EJh5qwRUn9F76A5d+gY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwTpowhI;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974461;
	b=J8p3c7sI4X6RWnzcE/+Qjq2ligvJbOrTLm0Ln6UUd7ks6EtlnsAJLijJBr70c3JNrW2Uk/
	fVaqgVbo8H59dt7AuT//nhIpnYzmWHsqytS8sFmj5EJ2gi+mn31cbx3xzfpZ56uA2r/fbF
	3hC0NbUui4Eglj4jmIZoCdWCFLEQ7FU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 114B1605E2;
	Fri,  6 Nov 2026 14:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626BE1F0089F;
	Fri,  6 Nov 2026 14:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974459;
	bh=9avFlgR2Q13CUtm3xqFDLDSVodrfgmDEXnm1JNjvm6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cwTpowhIo1+jTgCjX5+6IzfjZiGxF7z75LL0/xnttW+7iQLGTgmAPTc48kfKvjqCQ
	 sJToVtfaMXbNtk4b+ZUCr4N8b/bVXHVRBh7Dni7UnQUmDUSjS2O8JKiAtLfx8N4I/0
	 133tX38UQVvuUMA0WZsk20mXOjubFpm/ihzs6eXLsa165xTXePF1+1Ob+0r7+iz4xv
	 2+T68PI+L6TTQJxKnXbZDk/SUqCuo0AccG7YniXLvEFZjc7T9w5MVqz6so+y2buEFr
	 ld/14Wj4byupKgsVW65oRpc/Wi/vHfsYFfUw/WlWdXZX27ZTTO0GkdrXwy/7gIexPC
	 x8Qq4EqKO650Q==
Message-ID: <2655c45a-8b3e-4684-9c81-11d7b32bf696@kernel.org>
Date: Fri, 6 Nov 2026 15:14:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec
 lock
To: Andrew Morton <akpm@linux-foundation.org>,
 Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
 <20261020153648.52636815691868735e9699be@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261020153648.52636815691868735e9699be@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6jwbgcewkcyu3oo8g5zwgu8zt7y4nswe
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6D573180002
X-HE-Tag: 1793974461-809731
X-HE-Meta: U2FsdGVkX1/cAkvk87FmaD/fMpTkvIlrJqQb/vbPrPWiB5Yralksdj6S1XvF40oNT8NNz3wz0dFAA3OFaECYFjFbt0y8KU7MT3ewb/b2RfQ9h3ZBxttpzdX6rilFlxC4sNB/ErSo9ss7MuhMWWKdgsV9A3As+vPWyWqeZDccjNzKf0KNY0F/7BMdHeWWZxxwjjjio2kXdA4biNDZ8RiOW/ZSa2J9khZErSrvDzSTxhk6TErbOQILOxthJo2RKgKbUEB1ISTBMVQFWPa82U2rjKJYPHtBbviXTECYJJwMyR3xI3YiHmDb6Bt3Z3tGHi4VpWrijbFl3tRND6k+rse029Z1JFlHDTbexjU07XOPUC2F6At2LhQ0KLEW9wnSPo5nOu8XzWQ1W1jvyGoGW2K099ZH+2XdKqh+hxzT5EYAY99fmuaDHo/Jk2dbvfgnU521ZY7D1JYH81w2h1CQVn2meENQvhUvlRs+XsRAA0fK0pRE9R9qWmj/78N+KebdPyic4TsgChC7VXbNsE4GqXjho8A3NbR+Kg4SARvYrQsOI6jNK7zKMwM594MVP8RDHsHam9W9YYiSvfQyIPu73z0mFPxmwvxzuxs5KVVNw1g9kHFJCnsSsMz1NfVDHqfAsUIf+yAMEtPwibpvXbFKGkV66K2ssS4Ce99z6ZMOBU4efHNosX1y7fAxXgaK515ENz65IcKzh/xNIDwnnTvi9WSpMNWNPF1r6BrrG3TqSHGA+yNnsj6gcYtTabLC5TXOBhP2iyD2vhBx0dCH7sc/JJ2Im8K/Syvtb4+TZ7Kamdec/kLRQe7u20SQQt01uTqv8Y06bCS4ynMsJDnQWCG8nPGHxSYLjmLpYoqap1zTAivgZ9L9FPendevxISLa8Y7UEMNxJPKsFUZcSQuItpZfUGKOXXNl/05jILxTVWnnLTnVg20J+JVNyTmtT62poq4wRoIboqFUExDzpa8ffSBDyLL
 d7SbOcWi
 wrpIIFHUGDrmf4vKUBTXWK9UtRQRJCr5H7GA2hnKetsa8zvHSpmZuOrZfAm1L49mCeFYxAIOYJeA+JRN7utaZcQBR97S0ZHha1q98W0M/ekgH0vWZcLjBi8eCmGCvx20lapdvL4ZAt5+pnB+l9cFx8xokuYo02M8WZqe8N5tCy4CI0UHBBc0zK875y5Mrui/PDk2IMWsPAvOfM6gsKAVkkYFzPXyMR8b3zBh673fScImMY24wlKwP6K0R5Vv+dXXA7VOU7G2M5QPvvpNibLCrUHxVWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 00:36, Andrew Morton wrote:
> On Mon, 19 Oct 2026 16:06:46 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:
> 
>> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
>> folio_unqueue_deferred_split() on folios where the refcount has dropped
>> to zero. In these paths, folio_unqueue_deferred_split() is called with
>> the lruvec lock often held (move_folios_to_lru() always holds it and
>> folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
>> in the batch except the first). However, it's not needed to hold the
>> lruvec lock.
>>
>> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
>> the deferred split queue lives on folio->_deferred_list in
>> deferred_split_lru. The deferred_split_lru is a list_lru with its own
>> per-memcg per-node lock.
>>
>> There are already other existing callers that call
>> folio_unqueue_deferred_split() without holding the lruvec lock (eg
>> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
>>
>> Add folio_batch_unqueue_deferred_split() and use it in
>> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
>> unqueue each batch of zero-refcount folios from the deferred split list
>> after the lruvec lock is released and before
>> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
>> critical sections, which run with IRQs disabled and are highly
>> contended.
> 
> Thanks.
> 
> This is a speedup and not a correctness thing, yes?  Let's make it a
> 7.4-rcX thing, for the 7.5 merge window.
> 
> I'll park it in the mm-new branch for now.
> 
> If people think the speedup is sufficiently worthwhile then I can add a
> cc:stable to it, if clear justification is included in the changelog.

I'll pick this up for the next merge window.

-- 
Cheers,

David

