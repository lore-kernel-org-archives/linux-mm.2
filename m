Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DEFCDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E3B6B0088; Mon, 22 Jun 2026 22:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8BD6B008A; Mon, 22 Jun 2026 22:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC9B6B008C; Mon, 22 Jun 2026 22:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8F376B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:21:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36398140349
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:21:14 +0000 (UTC)
X-FDA: 84909575268.16.A543B8F
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf19.hostedemail.com (Postfix) with ESMTP id 78AF21A000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:21:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VUCWDlmG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782181272;
	b=RaQGsWX+4AUk9rmwVzfoX/Zl0LDC98gO0omk6NA5BSyCmbxE0CJypQOomUHjQef7Ae0NTO
	6vtvIbkCBgum6vkwtCG8nR0PYIJvaVAILnRfbbLG2qN0vGcivKNL/0FVj3B8KhQxsMIuQo
	MqxE7vLBu7/9VcomWVwAi4bi/4IXXks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782181272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMffO2o77SuR2hBlttDpYw1QPIJxJT/T6T/rBhU7vx4=;
	b=gd992wweUaaDKzDr/OjqYwS3zZ7wYy6A1cfc8QuEe+2tJ2hLcLsR460PnthbUwViVvN4xK
	JjTWb/ruUE22gz/RwcI80N9u9EaOAqXJ8pn+qQJyzRL+BKx6IyKmu8U9AKl36yuktIscEK
	rxXRnMSsM7Qc/sKfkSjawWbJiN+FX3s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VUCWDlmG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <46730710-fa60-4332-820c-0a68acf00dd4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782181268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMffO2o77SuR2hBlttDpYw1QPIJxJT/T6T/rBhU7vx4=;
	b=VUCWDlmG7W9buVSD5ve7UbTJnBWCcsS3T/Oq+PfLVKKFkVQmc97akdOQDziHich3ufJFtK
	QaYoQwbOgqjrvYDiTCUImSPEGiC2q3Bc2U2smVp9Z5UCFzARkJS8wC1BapXmpb8mInfnh/
	6Xr+q2+2RYBYhhAh3SxFOtsSz70yPpc=
Date: Tue, 23 Jun 2026 10:20:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org,
 muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
 roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
References: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
 <20260622073703.79258-1-qi.zheng@linux.dev>
 <CAGsJ_4z34ZRu_RKkaZ7EgTWMOxptUjZ90WJyNoJrXGNjzutxnA@mail.gmail.com>
 <19710ee5-8e1c-4b13-812b-4b03ca34260d@linux.dev>
 <CAGsJ_4zC8jMNk0twWQd+oRWCzZTm523K-KgzDQ6TkjbzPq4MTw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAGsJ_4zC8jMNk0twWQd+oRWCzZTm523K-KgzDQ6TkjbzPq4MTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78AF21A000A
X-Rspam-User: 
X-Stat-Signature: 8jkyi85zu7jskakbtwfd54rkn8na74cy
X-HE-Tag: 1782181270-719721
X-HE-Meta: U2FsdGVkX19eZJUCnHxionHpv8baWpUPEuVEZqvn08nRkuW9SNC0ee2Nch6hB3eNVmaF6BF1zLM9JHRfgleCJU2jxNWG3Qiz/IhG4o8a/CeAEuI+GIKgoXYOzSLSBdtPp5oT5aihoHhd//PoJN7T3jkEtrJlB55q4TlrDyHoSU4R4sqp9uMlykS4mAU2xaMWfoc8b37W2E8vLLb9BBEL/9/LhxeJIj4lIHkHPOZ2iZxkuShLTGabvv/nz/T8Ke1SmrWapVL5TMNHrM5MPZkIrwutzkNVN0Hz00n7D90dGVrYN9I8F9jvmyLVHNuiHPsbxlt35S1OOlD6jQmgk4moJLWRKmGHhTyCIDKQRtZVmQ9D/5X+aPXFnrry8g1Vtr0FQ3PtioeDom+0BeFdS385gFHtJxCBdt6QaOc88W8SS2Eo/86AszS+0S5u+V1spikfkoBt63yDUISVSIzjwPHFg1ENv0hFLBczzHmogWTcXs6NyFhj7p6tcNr0MSTwqZuHKAUqKjLC9jEzMtRsw3IFkqQ1WqftF68+IIyPrO+X64f+Hi0GTUCSErEZu90BgnCFw7tkns5m+JPKhpOBGmQLm8eAJMp2qzKkNQZyEKUIDhmKovjN7kdWkwndiMbGkFWK9MdDHvniXrWymfCVvd+SrUWHIjAQOls0oVAkpW3rat7SkAtLjGVXOMOGPHvn1xj9e0LeaUUCxcrhB5XRdss3xwwJpxWW2VLL27eUVJ/t81q53aNiD9bBJli9t34P0mXtTfdhtwe1tizvBA5jzuoY4JLKwnJ4n3Mnqi5x+rHQwtLhZ7zWoGK+L5gQBEWQLKHL1X5RkBL/04TnX73Jy6ATO+ENzqSRj3tqk34m0sSeq7hVg4RlIRL/7BofnNLFNKeqt9Xf5ABLqEJssXCXtNzS9UinjzVV4Yljm6gCxvhu3QYAPJtelpgvMkluoZGC71qsDkk59VhbTSTd+hn+CTM
 Q0zwz9CO
 8YDiwSYSIwGAqjD0rZGumRwQyQdtDdpD37fmw+JQ6ZaEZ7Npr54L/vVcW1seqEcLf2i+GlWqQMkI7rVjwpJ7ugtbks6YmK+7qW11dNl1i2qht2qlx1M/dnRFiZYM/Fru5bHorXqd1PqL0IFN2Vf0eS7tzvOG1aFgG1UI0MNvKsTzMuKeR4+PyMHCfQaoismPTfehp6P9oC6qqd9zc1tcBODXbHmUCXg98ACGat2NpBXfO4KI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/23/26 10:15 AM, Barry Song wrote:
> On Tue, Jun 23, 2026 at 9:58 AM Qi Zheng <qi.zheng@linux.dev> wrote:
>>

[...]

>>>>
>>>> WARNING: mm/vmscan.c:5867 at lru_gen_exit_memcg+0x26f/0x300
>>>> RIP: 0010:lru_gen_exit_memcg+0x26f/0x300 mm/vmscan.c:5867
>>>
>>> I can't find 5867; instead, I can find 5828:
>>>
>>> VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>     sizeof(lruvec->lrugen.nr_pages)));
>>>
>>> Is this the warning?
>>
>> Yes, I just copy-pasted the warning log from Peiyang's report.
>>
>> Maybe the description should be changed to:
>>
>> This will trigger the following warning in lru_gen_exit_memcg():
>>
>>          VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>                                             sizeof(lruvec->lrugen.nr_pages)));
>>
>>>
> 
> Yep. Can we update the v2 changelog accordingly?

Sure, will do in v2.

Thanks,
Qi

> 
> Best Regards
> Barry


