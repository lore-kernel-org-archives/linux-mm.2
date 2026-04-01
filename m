Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5440D3514A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1757E6B0005; Wed,  1 Apr 2026 03:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D056B0088; Wed,  1 Apr 2026 03:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062E86B0089; Wed,  1 Apr 2026 03:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAD0C6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:25:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96AA7140482
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:25:54 +0000 (UTC)
X-FDA: 84609152628.14.65EE7DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B436E8000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:25:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qX4jLvDr;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775028352; a=rsa-sha256;
	cv=none;
	b=6mKg4bWAbERntGMV9Xoqr0qjVvDSHrOwgzCs1zDd1CeBmuucazkHRj9dUMvo1k/nuiRDA3
	DI5yGJWNMQyXPzpt0xj/ttZOx6znljL9xkUCPszGvt2fC1zCUdv4KdD5SPfB5xdN2htYHj
	8swpVeSTwCy+xt9a+TA6/1KxNsLw+Xw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775028352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxqPiN/KwVdriFzVUgpAHYVxZpLTKWeNXC01oytRM8Q=;
	b=iHmTbqjPoI7yt69wj9qJv3wpiLk+gqhkfJC9kCtxCPheeZTs8bl2zPg168nDrf8EeZsT6U
	3YdgnwOMmmurm1jS9GcSD5uyhdrkpWFpPmseQUbu5iq3U1hM/UcMgEkdfrc4rXZdsmKPIl
	7sQCMxEAx+xlHp+PeTnJdpJwIl+Ckek=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qX4jLvDr;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A07D540538;
	Wed,  1 Apr 2026 07:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47795C4CEF7;
	Wed,  1 Apr 2026 07:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775028351;
	bh=/QUj0UX1GZ+e+AE52Ux3eyGjyUiHdeSeeqDFLv2q5Kg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qX4jLvDrJmxSsLVwA3eo8uG050mP8XiWMMqN5k9R/l0hndwSrsxt7kibC03ueHnSH
	 SIgUxoisUzv6UTOQsLTv1og/LOuM4Bwg81t+Mb4YddVnvmUwOn7kQDizdAKpbLtZ+u
	 b7siJsnJBGsheCh3CJPTgE1SdK9ps2QtDP+6S5w5oYCB7wykuayD2NESYpbwswixpN
	 XxXnknBzgbTfYtbX1DZCmuVnAYqOC8xpnYJb0Fp/GAUHyUBsLnakNyyA/vcAgLEsbv
	 +3qd+oZyKZXG4NWJ9BbuUEBnfAZZpruYzSfqKShx1MV2WOsb/A4hYilAxBhjeVIPzu
	 WtRTTtj5bEslw==
Message-ID: <bb05187f-2a54-4c5d-aad2-27b462707206@kernel.org>
Date: Wed, 1 Apr 2026 09:25:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <17246161-f314-45da-933a-770231ef2a49@kernel.org>
 <2183487D-0CED-4BEF-84D7-4439F3386584@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2183487D-0CED-4BEF-84D7-4439F3386584@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B436E8000C
X-Stat-Signature: rn47p4eu9pacmgg4958mhkudxe98n86p
X-HE-Tag: 1775028352-310355
X-HE-Meta: U2FsdGVkX1936iT0fQuJe+Zqeu7U7CFVTxenJOPTzXcvsPpVO33qnYkkQz6n6OQnOCPHb+1AxfnGXpWAr5jeSC6kh0QanlZ76bezpVjIwAJ7jyiEM7IOwNtMhhnw0i0EBJYl7VlHMtOjj3cqtBFsFG/1rpcrCpysIzadO4RGRZHJLvjB6rrn8f0HCRy2Q1lzoUJEjqcHou0phQTfjFElT0xfYEv58T/JTN+K4cLtEuDybtgVLc80YknrZwCltuN2W5FsG289muhdqH69eswUsuD4fI2kxeZmD6NgABfAPJGHSAIOAabSbx0rbE0iwYw6+a9QDQV1rJUSbC+vd+jWXCrwimtrf2P5CMZBZ4bNBJR+UkxbYRZpEdAkyNJgaAxTuebLWVZQDT+B3FvdgQiVktAWlVUoEa+xCadwhaaCGA/VEnrcBKwtCy5gbcGeE+Y3yonAuPSFE0iZ2DIKuC/dxfTbetJMbF+yTt2S14CC5pQwzdV1F3cIHd3eRruS/3mFOZy2ozpmbdRVRpxrmBJsAqRSzKT17iQMM/zpX7zbZygm+1xwTsev816QbaHsLYNivTIcmIOMmz2eXzD46uJz55ELI4UUGbaVs0PoZXEFtT7r1NGbKTCuYWOeb6eTvvCdiZxDTO4CU8mvxwCCIYwEQkRdJqn8t2GYQxnPnSag25R1kdHw0GcFki61bIEmYllAN1SaTgUJX//10qHj+hp12+x2hV2fdOzpPb7oMWzYvN9sQDxQG9PbH+Ch3QTLFLaKNwml/MKFHC0pjp0uyE5lK3wEpZXl1t+8/4RzJYO4ZhzEEcnIFR0vSx6pByztpKoUR0tZiLc9j4XS/ixIX+GAlHR67x0vfGMGuNnG1sVQ7TNVr703rWpFaE9Jf+8V3T+50Jw0agbYSXaNgyMEKianvsvm3rjN0zRuAtlBzL6GWco5qnjZNWDQnW/pztaEg4aqyZYJwsV3vnG2ci4HKWY
 MvZjuWRw
 pYy1Si6WVQkXqObShJ/udQx7MjhOxvGhelR5wsPMcNT7GQgSBwUb7LwZJNOWc6Mk5Gve6Yb6QE2QxusgYj5mHvFMMcEFWhipIPGsTOETglej4QIq5dfBYwq40wL8iymQdHImylxqcxMwLrB9U0aT1hBlgxUoztS1Z+wJ9g7v19pmAcYRFUWI6UamNz6iVn6zAH7n2HsGVRKyBNoSewvg9wBVSp72TJZTaUPNTYdspMYLIBzmqus9T9G/j01ZRNjvEC6KCzdcQQlOlVv2mDr5uOYYXVeCtNfy/uOeRNLYQ9HpbFDwmFRLLZLNnfeCjj/UPV2HrPb71rvPVN3sOPWaTdZeFmdd0dwGT5r0jvQQFr09JlJpWDdETB/1eZWJnUtvvYewb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 04:41, Muchun Song wrote:
> 
> 
>> On Apr 1, 2026, at 04:42, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 3/31/26 13:37, Muchun Song wrote:
>>> sparse_init_nid() is careful to leave alone every section whose vmemmap
>>> has already been set up by sparse_vmemmap_init_nid_early(); it only
>>> clears section_mem_map for the rest:
>>>
>>>        if (!preinited_vmemmap_section(ms))
>>>                ms->section_mem_map = 0;
>>>
>>> A leftover line after that conditional block
>>>
>>>        ms->section_mem_map = 0;
>>>
>>> was supposed to be deleted but was missed in the failure path, causing the
>>> field to be overwritten for all sections when memory allocation fails,
>>> effectively destroying the pre-initialization check.
>>>
>>> Drop the stray assignment so that preinited sections retain their
>>> already valid state.
>>>
>>> Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>> mm/sparse.c | 1 -
>>> 1 file changed, 1 deletion(-)
>>>
>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>> index c2eb36bfb86d..3a14b733bf71 100644
>>> --- a/mm/sparse.c
>>> +++ b/mm/sparse.c
>>> @@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>>> ms = __nr_to_section(pnum);
>>> if (!preinited_vmemmap_section(ms))
>>> ms->section_mem_map = 0;
>>> - ms->section_mem_map = 0;
>>
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Thanks.
> 
>>
>> I have some cleanup patches lying around that cleanup that code heavily.
>> I think I get rid of this questionable "failed to allocate" case entirely.
> 
> It's truly a coincidence — I also have a piece of code locally
> that does something similar. Since allocation failure would also
> affect subsequent startup processes, I simply made it panic when
> allocation fails.

Don't use BUG_ON, use actual panic(). :)

And yes, we should rip out that handling.

-- 
Cheers,

David

