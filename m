Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174EBCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163506B0093; Thu, 25 Jun 2026 02:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A896B0095; Thu, 25 Jun 2026 02:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029C06B0096; Thu, 25 Jun 2026 02:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C60446B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:40:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50B72A056C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:40:02 +0000 (UTC)
X-FDA: 84917485044.01.ED19BE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7056F20003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:40:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jHY6LLi0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782369600;
	b=HkOFDyx0qmEcioljEWv/kbCYRH+u1bo71R4Zq5igJOiVg3yPxAjRVdeHG0wv3AXIyq4rph
	tCxi1VbYA6SMO1zqvuWYw1sIdAQyV4JzuTDy97vEVX74jv7ha3FXtSn7ynXuPqLFJUgCE9
	/5Ad3CwApPY2qGaq17Mpz2hbWGYvXGA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782369600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48jbdoy6J0jG+nel/Wtfo/I8BpDJj79gACoE6Vbn1xo=;
	b=miio0TnIuZFGMF4PjzTsT4OS6XVq5WanqRGEVYb5+WOID5XvEcId94gGRR58QMlSCOZIBJ
	54G0bAGx8vIjUK0xw/Cy8j+iZ4VTovIpnEdot4vkDay4HitLZzL9939D0bHBNQaYVer600
	msGwqHaNU2s4EXTZlChaC0DTdSBEdy4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jHY6LLi0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB297400E9;
	Thu, 25 Jun 2026 06:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D341F000E9;
	Thu, 25 Jun 2026 06:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782369599;
	bh=48jbdoy6J0jG+nel/Wtfo/I8BpDJj79gACoE6Vbn1xo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jHY6LLi0YYVjV0LQFOa7dphB55vNXkFWVa7dJbfePYtvE4DSO6GpHbbbSJHyuNaAR
	 mqQ4aGqYrpdQ8bv/sg4cQKRF0Jq+vQcgGMnWpbIKrACyjLEbzl5mv/iKiBxHNwN7bU
	 WjG6uOzqxaIMWKAp8VGgviMyul3O2FSMGX1vcTZhkDm+EcDlnfPtocD33lq3zeAxYQ
	 Y5Xmv6gviPpQN0JE2Kvy1uSWucShBwjpR5KmW/BbQSkVai0dT2iKw60g8azTop04XS
	 cuc1CR/fTTdMO6PGkphwFJrhbqZCD3DyjAR+Pf9JkuYhbYEDDv+ZL0XMmGhqmujIDv
	 CnCspcYIkyjow==
Message-ID: <6e39171c-8333-463d-9ea6-db331965d2c4@kernel.org>
Date: Thu, 25 Jun 2026 08:39:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc: fix KPF_KSM reported for all anonymous pages
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, luizcap@redhat.com, willy@infradead.org,
 linmiaohe@huawei.com, svetly.todorov@memverge.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260622091539.836531-1-tujinjiang@huawei.com>
 <93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
 <601fb5dd-18e1-4a6c-bc99-dc2a655240e2@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <601fb5dd-18e1-4a6c-bc99-dc2a655240e2@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7056F20003
X-Rspam-User: 
X-Stat-Signature: 8fqqmb7ypopwu67n7tksebq1s6putrbx
X-HE-Tag: 1782369600-441050
X-HE-Meta: U2FsdGVkX188Jenfzp85aSphI7SCameSXX62PtVp/T0+gFc7H8zmnON3dyl55EbEVSHKbmKhJoVOk7U6hOGG17UEO38yAehycxa9rJ7fi7qWM/kJlWwXH/T9bSl7nm6g707VMfa7LjRy5ifLRe9FTw+vWhkPi2ZQc89mFy9xTx5tvzMd8794gyR/TX+2a6nfLWWds8T85FrlzpJNpran8yg6j75CbtjvDwNPI6XU8LgcCjoQ4JkEQXaN8/O9dl5I0UGG7a4sC6sQouGpA5zY0WrTiueoazWBpPf3bsrp2MZhHMNcba2KS6s6m891NTM03rO2qTJiDtu4dKbgPP/7gvKdrgklCGTAR8+93D4r/x4JaKdTKvKfvN66la+EuepIssRg3hUyGiqraIKe2BzgXhnxHnKnPyQ8u1rbGLPS9jKxr+mzob96GuMrDG2jFuQq8/lDlUh2aCsxa1SlSdWzf3fqB8u3QKDXRm2GdpBQi5UoMaLf58eE63s1QJluYWyJ/rE8yaOJXWpdTDmw5mgbZM8VqOlZ7edEyF5ZKaHZe4Qkseaia/3npZOmT1TxCKmHw6Y4cO/r9QUtedXHVO2TrSFItZBGATjsoBZWWgS8TalX1GHIxAJn1yhk/DPo6LihkweCeUGtwqyCHlLPT3hHrzpTzyuynd4PXDMNW3HSt2ZSf0slUCNvIzBptP1/vhyeM5ylVXKEbiPWCqZ85snJrSlD4+GnmAYgb/brRSuvDYw2Oawcxxu84LklHbnFVXqtJPL5JUCfH+zDjhJtQ5z9NhDNQ9P78mlUoMPhmc1jtLgS3CYlRYAnZavgGnRDPscQsAOm8/gExNPoAZXRYGdIpgs/Ae+q2GAi0rPplJQeKU/2rsFbCfHI3XqIK6bK6QgIIrZw6mslzkMrI1DYo8bhCK5Tjvj1ZVw21aS6g4VSa2vjzQ96p8YWsU4SW1sBdh3RsDGHX1uNJ3VtjXP9TCH
 EoV44lra
 d1uA5Mzd6MIl+gRdvRebnuQtCPNcVpLsUZNPWOeqF54oVbmERDDrkPe1IA7G56DZA2GrT1+07EJOrRWi5wl6BOhbdS/xhHdQCWV/yKnI9qqlOkmEeKw4HIiv8HAXJAdultoUx8I229c2OQuR3pGj006geoMuMD28Xv76z4u/wQmOxyW2hwYCFbOULvSQnTZHILXjA9kE8BGIl1HA14UG6AIJTPzPikk28HPjk5E6LttsfCZh7obmgSOFKCaEKIxXMjA0RP6K+/IZpRUD4S16Ao+Cgti0iKVVuvjpzzax4SVk/Uhn1eajwwasgs8usKyIEhfilxKqQoHjHiwhdKwHOuflihSG4O/hiv1cK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 03:37, Jinjiang Tu wrote:
> 
> 在 2026/6/22 19:45, David Hildenbrand (Arm) 写道:
>> On 6/22/26 11:15, Jinjiang Tu wrote:
>>> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
>>> when KSM is not in use. As a result, tools misclassify all anonymous pages
>>> as KSM merged.
>>>
>>> In stable_page_flags(), if the page is anonymous, then use (mapping &
>>> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
>>> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
>>> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
>>>
>>> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
>>>
>>> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
>> Right,
>>
>> #define PAGE_MAPPING_KSM       (PAGE_MAPPING_ANON | PAGE_MAPPING_ANON_KSM)
>>
>> Which we later renamed to FOLIO_MAPPING_KSM.
>>
>>
>> Before switching to manual flag checks, PageKsm() translated to folio_test_ksm()
>> that checked whether the values actually matched:
>>
>> ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_KSM;
>>
>>
>> This only affects /proc/kpageflags (well, and hwpoison inject on a weird testing
>> interface), so it's not really that relevant for real workloads (debugging and
>> testing).
>>
>> So not sure whether we should CC:stable. Likely not.
> 
> /proc/kpageflags is generally used only for analysis and is unlikely to be
> used in production environments. I found this issue due to I was analyzing
> pfns allocated by which stacks are KSM-merged. So I think it's unnecessary
> to CC:stable.
> 
>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>> ---
>>>   fs/proc/page.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>>> index f9b2c2c906cd..cef8ded97610 100644
>>> --- a/fs/proc/page.c
>>> +++ b/fs/proc/page.c
>>> @@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
>>>           u |= 1 << KPF_MMAP;
>>>       if (is_anon) {
>>>           u |= 1 << KPF_ANON;
>>> -        if (mapping & FOLIO_MAPPING_KSM)
>>> +        if (mapping & FOLIO_MAPPING_ANON_KSM)
>>
>> Wonder whether we should just do
>>
>>         if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
>>
>> To match what we have in folio_test_ksm.
>>
>> (although I doubt we would reuse this flag for other purposes, likely
>> it's more future proof to check it like that)
> 
> Both are ok. The following check has checked FOLIO_MAPPING_ANON,
> 
>     if (is_anon) {
>         if (mapping & FOLIO_MAPPING_ANON_KSM)
>     }
> 
> So it's equivalent to do
>     if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
> or
>     if (mapping & FOLIO_MAPPING_ANON_KSM)

As I said, matching precisely what we have in folio_test_ksm() is clearer. We
don't have any users of FOLIO_MAPPING_ANON_KSM outside of page-flags.h for a
reason :)

-- 
Cheers,

David

