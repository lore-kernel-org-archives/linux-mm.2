Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB89D29FEA
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88376B0095; Wed, 14 Jan 2026 06:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49396B0098; Wed, 14 Jan 2026 06:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B760F6B00A0; Wed, 14 Jan 2026 06:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7D986B0095
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:52:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55E291BC25
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:52:46 +0000 (UTC)
X-FDA: 84330407532.01.B2E4BED
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6F2018000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:52:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g8M9XsiZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768391564; a=rsa-sha256;
	cv=none;
	b=D1KzeW3U8wfsJw6lusPeq4p4Nwe1r46YJFcgwV3RaJgu9OjZ1e8dYurGFYwe7RTQuZ5Jdj
	3YW1bopbkEPx1s6+cTsJsd22IzWk/Vc3iNjhhKkZFMWw0ZcAMq0zYxxjXEFE1GMl80jMjZ
	R8eoly/VIaXCgvGxywZSrnm2BXE0Q28=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g8M9XsiZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768391564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7xSQF0mGpEu8TOyOO/LYfopVHPA4H43rsuLF6LlAVc=;
	b=nwK+DVErxPLWNIJcOGoLuSwxxftlxWu27zYutcf3MvNJVoFdmCUAuFr602qaQBuNQWMEdm
	f1ipGVCTjl4P1u+jSEJJX9F4Vnn8zzbLMqLC1ifKX3pH2dYH0MZyiAlZBaxrsbXhj8wYh5
	ap6uyYJF4DIGf7hxO82ikvlEsDSIIFQ=
Message-ID: <3ddb66f4-d3a8-4e94-8bae-ba65737a52b4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768391559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W7xSQF0mGpEu8TOyOO/LYfopVHPA4H43rsuLF6LlAVc=;
	b=g8M9XsiZxrjFp15Q1teXxp4hzG9J07BxK0fpaxR+g8fCiqoPBuvRK9cqClLeMn2C07PUb9
	IWS5VF4I7ntmJAQe8stbKuQDwtBoS2j5JWCDWSEe1TJ6QptD4e5lIXA+dIkuMvjUWIvl7S
	VIHnANPvDFMXtipTM/WdVDZiv79Czi4=
Date: Wed, 14 Jan 2026 19:52:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v4 4/6] mm: add folio_is_lazyfree helper
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, akpm@linux-foundation.org,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-5-yanglincheng@kylinos.cn>
 <78a2ab5b-5ece-4d82-a229-594fb8672108@linux.dev>
 <40381c7e-3f0a-4459-a287-4e098e9a4b13@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <40381c7e-3f0a-4459-a287-4e098e9a4b13@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D6F2018000C
X-Stat-Signature: hwpd1n7itzcp1bffz69dq4e6mrfcr7r7
X-Rspam-User: 
X-HE-Tag: 1768391562-88685
X-HE-Meta: U2FsdGVkX1/k6QAfdsMkjUUBmwN3fONMjfjqgCNXlD4aNANyIDaqQbHFP0fJyN1Wj79jn806MOzhiqYftqOkxvNgVfCCddasT6k3jdxgXIBO/UfAicheecJu76UkgkKxRB5q0+wUuADDNCYTOkbwPb9kvaJ9Ay++omv/Jn5qxMLXSnlTdXHE7KnNw4GH3PlZsfNWCbEyqOjO6JvyoYoAWqU32fSGYFpJL2GA6qyTbvhEE9YXOFQtLq+J1ImB9ChFHvHDSvaATBZbL17zly7qvu4ZHbIjpW7yitub9daeJnx7zOxEA/Ap2JwwRieFsdVcsrya8iK4Ly6RnBrJfj/tMA3Iut3tROG1bNP6xP7RkYSP4qMIzOJzpAIpcDZFp1/ubn8i5Wo1DRnHe2GdH2nASzuN1S7u9J572qCKVCX/Dd/41Z1F5RTeZJQqpTckys/PPOBcbgc7ZMRVldwptIvk8gLz88wSJiqy0nJc1zOT8LzH5lfyMWWwoUduRqMGhOBKVCFmWcA/ELe6xOQyrt1T8+9m77DIKcMAtR1/0SRhxzxs1Sq8Au0cWeGOXAlJ82syzdNx/JCK9KZxEr2T9h/CHcu+r9E8Ylb2veV5OGOlJhChSJCPH5FAocjnohkGPmGpCQQ8g+jz3ms2/MeJDsC3grc71blFusfrfRdYVicRuDIkmNrtBZPiNqoStm4GZzrKD0tT7g5zSwzlZwoE9BIPbJ9WAiBFJACmm1TPhCTLaGX8lHCPaYsQM3rSVExgR4q0i4Mt43aapgEh53wIMDcxBNPFbjIRUnQ22H6IUPiU+dNrnUiPJDnxm0xGeWE8hKBe29XTnmvZ7glsAi1PHB3lx7ZjzOu25ydKxWXsh/3aUm+SEP8lqD2VIZh+QhCR2VeuvZ1/P+6TzcwA9HkFK/7g1vDg5/mGBBfdBQs9o9tKo9fawdfaqtDziSVvoz6DmzfoSz9fmTlO6GYb1FBNxtT
 lJLPryph
 Vw2AF2Ksk7y4FwaPO8fP/oYu9tYSCMzFuAwkzmo6XpYqRHC0jFmgp57rlq+5UFIh8JBkScMxHz5F+D1RxT4Iz4DzLSE4cJdh4YwON0wcU7aRZqb6jDzBqrpDkG3PR7SF9XJpp5ZxOcr4z5xRxJhjOsnJ8P+VcOGAZqqDkQDn5W4N3Bq0m3a0ppxoDge+nd9oucClkeb37dM7dUoCV98yan3OoyFrMEgyFABn/6tp+mg3opRw6by4Bg/AsGKRJucyC93QIBWWhDJqSBNtZMoV7kjB4bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/14 19:45, David Hildenbrand (Red Hat) wrote:
> On 1/11/26 14:41, Lance Yang wrote:
>>
>>
>> On 2026/1/11 20:19, Vernon Yang wrote:
>>> Add folio_is_lazyfree() function to identify lazy-free folios to improve
>>> code readability.
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> ---
>>>    include/linux/mm_inline.h | 5 +++++
>>>    mm/rmap.c                 | 2 +-
>>>    mm/vmscan.c               | 5 ++---
>>>    3 files changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>>> index fa2d6ba811b5..65a4ae52d915 100644
>>> --- a/include/linux/mm_inline.h
>>> +++ b/include/linux/mm_inline.h
>>> @@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *page)
>>>        return folio_is_file_lru(page_folio(page));
>>>    }
>>> +static inline int folio_is_lazyfree(const struct folio *folio)
>>> +{
>>
>> It's 2026, could we use bool instead of int?
>>
>> Yeah, I see folio_is_file_lru() uses int but that's legacy ...
> 
> Right, and why not call the function folio_test_lazyfree() and move it 
> to page-flags.h?

Yep, that's even better :)


