Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276A6C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB346B008C; Thu, 27 Aug 2026 12:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260856B0092; Thu, 27 Aug 2026 12:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173856B0095; Thu, 27 Aug 2026 12:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFAF26B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:22:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6E0AC0121
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:22:42 +0000 (UTC)
X-FDA: 85147567764.25.8A86611
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 17D1C1C0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:22:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c6ijVLhU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7WrhVCgAaUOL4xGEC6xlCmy8BBYILHhfXa7lkRioBQ=;
	b=YTL9pZ6o6ii8KZHGfpnKMdnrO/Z29X1Lzljd9EPbnuDQagki1UR5iAACUFo7s1EfddRgli
	HCJvVTxnSfzjwNH7ZkYjCS2h06BhJiv8Vuk3iLcnhi5H9cR91of5O0yOXuwK0wIGz2M8Zp
	soPLZujl/yBroFEcirD3+RGkNOxeIUU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c6ijVLhU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847761;
	b=uDz7J2usJ8J+YUWwmaSnM9zpcr0lXXzpo553QeUxDRUR4q4dHeu+2CFWME65g85MBnlXhz
	2Wjlb0y8p+hNYxA93yzTTUOwqXfLFdutYxvlW56Q20yg88jHBG+DiljSnftxhBvgcWFTKG
	IxOUr4iOirMuMPFSUJu0GKG1k3+142A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CCAB600D3;
	Thu, 27 Aug 2026 16:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90061F000E9;
	Thu, 27 Aug 2026 16:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847760;
	bh=O7WrhVCgAaUOL4xGEC6xlCmy8BBYILHhfXa7lkRioBQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c6ijVLhUqtExNvDwiI66mgRF5nYkLa3T6pS1wQ3aSXFcB334soGZPAHVq3d9QUeSA
	 bHirNEtaAf8LcabVz65gpkeEYYF7uZK25EiLYNtja44LG/ljEzsyZ6SY7zRuiTqbQs
	 oE6CXsEtEFBcTWsRcmPGM98tiaVzaqswrE2cAp6PlTRJeI0LIFmybz2jCihzwsb3UD
	 NbxsCGjV4rrsYPJ4/4YJlJ8sp2LazTtoqnPqAdsdumgzK1Hfv8J3fRNgtK1wQuL35m
	 P8PcLhbAdKgepAUpWuxc7G+huxNe+JbSYK9T8ToIHtupXu5i1W/cWln4VV9RGjg0S8
	 H7brryOC3wovQ==
Message-ID: <c796694d-7783-4f99-9ce2-331e1c551415@kernel.org>
Date: Thu, 27 Aug 2026 18:22:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/18] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
To: Kiryl Shutsemau <kirill@shutemov.name>, kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-5-9b43f5163238@tencent.com>
 <apBQqJZ89MHZi2RJ@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <apBQqJZ89MHZi2RJ@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17D1C1C0002
X-Stat-Signature: a8rqotipsdto43xkufrat8amdaqk1bpz
X-Rspam-User: 
X-HE-Tag: 1787847760-454269
X-HE-Meta: U2FsdGVkX199eK2XjKfJyJvC4thPAcAkcXaslMEw0HdBcNIic9ORmU98s6JGAtSnakPMVn72JXgMtrz0AJp8Ih5VF9ZL/vRfDHAzXB1K1CwgtTW54yTY4XFJx902NWpQKDYpXU1jHEw/pUdOg8JPrhG08RhRCxMl76zoBbSRN5mNHiV3g7/6wiH0wHXiWJcNUlELa4Sj60ZY+mjdUrGchc6nMfIgpwhn75WmKxBW8XNBHkhWwTcJuAev3NFfMq0xrNH9U+dLa21xThRX/zEsknKEMFU2ooakS6RFnpnYnA0xd0JpHHeGcu1xUsovGwROPDBTURAi5LOfYwR0etAMyATvC2eb0X9au1zVjXHx/CAf1mrfl5bG0ku0ldJ+q4kZhfPsmnEhTZHlKHJjGr0x/SV8jMyLBdocFF8Ws30J/6ACQ3kwQhM+b4GJcVn/uDHDlPOXCRngaJNr8fNJUv+x2RdC1fYc4ANxI0wLTaLH2hv42pdgYMPKFSVLIuDjOb9nfEtKzHgIt8iJtiP0oD0CY8qTaI+SPdOxGiigE/PqynhJlrGB7WBasrwSYTpia+hYsuSrUeLX/aHhH1jstq4H9wWTYFKm6nXsR6gT95Em7FineZE9hBhZMCXynLAez70DBn/6TQ9cF1YYz19xGgunDZETuVyVK9dfzKGfvjbfhsNuJGfhFd+dzVcme5hacJdlVlklwFagyh6/qrvZh2dkq0tMrKZ3mrAyCadHByyPQy1a4QDoofFdjMPGC7jN+JLTxiBiLyYW39ddzwde5gGABcR1nNlJudmfatTJL9Jw9PpjxWgBgNmcCD1TkDxSnFMvzMa4zP5UYx7ZtQci+OYGRRsGYd1nyYo0cgjAH/nuKNA++lTcTHO6iyB6fQ1h+oectDjJn9UsV6hkDFIRpJoe90oCJjnewIold8fbKNZ99DXpO1Hq7yrTLz/Haozj7icsLoiLKl0/JAj+a03ZjVr
 810z6iCx
 wra9Rn6uFQkuOegWqP/DnZyXKhYQ6SVA99CMVev8Sn5+BqU/2Z6FIuShEefzuIM6zNoP0x8uZ9rtx7KZLMZ4Em+akNPkhV/lgky0wSLVTqR+ILylzdvf2LxgUmmmEMuC2oYoqKf6zWckdYq9orQlfEJLIKjd5KrrwITz7o3TeuH8hfyWnwJo4yo+u2oMlNOs74xL+PSu0DNxVQIXwqqrRbFylhTz4dpXLi7beGOe4/G7L0RKXvzmLXAD1wMiNbJiTksMhfcoIEsQZoR5vqzEC+HLSjWduxmE3gIenUanxT7N1upveW9i0LoOg6RdIlTnMvHk6rjjbuf+nDU0zgIzWUpK5jTswyEB1HrSIrqho6umcCNrAA7M8g3Gbm57b0i2ve78y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 17:06, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 02:55:18AM +0800, Kairui Song via B4 Relay wrote:
>> From: Kairui Song <kasong@tencent.com>
>>
>> The helper splits a folio whose refcount is frozen: the frozen refcount
>> is the state it relies on, while unmapping is arranged by the caller
>> beforehand. The old name caused confusion and people may try to call the
>> helper on non-frozen folios.
>>
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> This patch is fine:
> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 
>> @@ -3989,8 +3989,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
>>  	if (do_lru)
>>  		lruvec = folio_lruvec_lock(folio);
>>  
>> -	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
>> -				     NULL, split_type);
>> +	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
>> +				   NULL, split_type);
>>  
>>  	/*
>>  	 * Unfreeze the post-split folios and put them back to the right
>> @@ -4053,8 +4053,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
>>  	if (do_lru)
>>  		lruvec = folio_lruvec_lock(folio);
>>  
>> -	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
>> -				     mapping, split_type);
>> +	ret = __split_frozen_folio(folio, new_order, split_at, xas,
>> +				   mapping, split_type);
>>  
>>  	/*
>>  	 * Unfreeze after-split folios and put them back to the right
> 
> But now you have *unmapped_anon/file() call *frozen_folio().
> 
> Given that you introduced *unmapped_anon/file() in the previous patch,
> why not give them the right names from the start?
> 

+1

And just for completeness:  we cannot possibly freeze a mapped folio. So frozen
implies unmapped.

So the function can possibly just be called

	__folio_freeze_split_file

And we can can add a

	VM_WARN_ON_ONCE(folio_mapped(folio));

to self-document the expectation in the code.

-- 
Cheers,

David

