Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE01CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1903B6B015B; Mon, 19 Oct 2026 03:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FC06B015C; Mon, 19 Oct 2026 03:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056F66B015D; Mon, 19 Oct 2026 03:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D42D46B015B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:11:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60A294060A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:11:06 +0000 (UTC)
X-FDA: 85338504132.08.DE24A33
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf14.hostedemail.com (Postfix) with ESMTP id 80A83100003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:11:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kYdDaaBI;
	spf=pass (imf14.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792393864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHPmq2WlguBeJi/Zj2mPBIP3oN0WpTMEjCrzt8cxejQ=;
	b=Lo+zFXVdW2g5350GW+AEeCRKJiYILpnnHmKl8xlKHP6jwYxdPpBUHDAkQ4LzBSGdkFxUk0
	+rRxDcZwl/u9uFoVVjkCkUSk30OecJ+90Jpom9J/nU0wPa4drfRh0D7m2Tl3OQnERzDB50
	KqYwkuwlsxy+7A54enPG75KukRZEkbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792393864;
	b=pNkslWl0v3S1dMvyjnyWgMy6JeBdF9Ie+4R5EHLIKpTt/NnppHt8Ya/AWcn7dKthfVt0m0
	FW2Bt9N+djyOVBrcN8Xx4mykDWdLq+HSqHYded1KUVm4yOFLs0WJP5YxmSyP4QeVhCfzhq
	cWBHyxceCoI5UNEX3oNqmIhOnAB8Y5I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kYdDaaBI;
	spf=pass (imf14.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792393858; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=nHPmq2WlguBeJi/Zj2mPBIP3oN0WpTMEjCrzt8cxejQ=;
 b=kYdDaaBIfWRuIzxcg9Q27am+d8SfQhR1+Xe5N7UeU1EaXVHXxZUNOkF7LNGv53aB5xbtRV
 eViyCiVMIITcqGOSPEExrLjWvhSAiXXWPYz+Tgp2l0fV5ou8Ck1UaP3WWJTntjEUrzKrfD
 DvRfb4mMf1BV8ki11qC9P874LcVg0Y6FeagbNoqAZ/tGH603z/vZ9BsCZzPBn0Ze1gmTPx
 NSjmt6NsCbIuB1KKat/+c/17oxlKWpsXHmVQUCtJUJK6j9oGUhZr5VyurRqzpW/PYieIQm
 8NXZWiseRxlbjYXAPSF+dGGdmxB3h1yRbi3Zhdj0kIvv85p0RgwJzhgweSX15A==
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 19 Oct 2026 15:10:40 +0800
Content-Transfer-Encoding: 7bit
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	"Qi Zheng" <qi.zheng@linux.dev>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>
Message-Id: <61c88ac2-43e9-4e78-98c4-a1879da6f79e@bytedance.com>
In-Reply-To: <ac34f212-2e51-4298-a281-9380fb0d073c@gmail.com>
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 3/5] mm: hugetlb: track CMA reservations by page order
X-Lms-Return-Path: <lba+26ad5c280+4b8d53+kvack.org+zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com> <57cd5cac5e2749cba24c502bcd9682ad8b9f2bcd.1792136742.git.zhengqi.arch@bytedance.com> <ac34f212-2e51-4298-a281-9380fb0d073c@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 80A83100003
X-Rspamd-Server: rspam08
X-Stat-Signature: oaz8poauebf9m5posckjqgserqacs39x
X-HE-Tag: 1792393863-893328
X-HE-Meta: U2FsdGVkX1/A+mS19lYUGibsAdIItL2aajbr/99lB1T2otO/mGvVwpe+KzbK31egyBOGcE2jv8Jq+/vNCkggsD10vnFssDzsBL98us3gPLYDkJDJ+45rRdHQtNQwnltZ93iNadEV9xmANb48jLMVb7+JJkrqD3cE8m+oPi9/3+WAr2R7pLcHgJjh1nbJAAEaBe+tCC+iZoFUPHH0M1GZseGyIu/Bdex1p+n874ZaE0fwZoCoM067PTezCBZJNVJHu7RnHThFKt1/SvZlBXBeX2pOnH8+2LkHCqyNJ6hAxkL7bA4Zy4cSChS5wS7D1oj3pRtIJH+1iGsz3dDxOrL7HoHhYa5G6KudqO8/Q0tZvLAzTxYULsKZLuBOZNqoalgWlzdElthw4/gTDgxpwSboWv2usuelf903u8PXKMR+WeA7iaUOrDVTK1KeuybuGQpYZgEdAgpuzQ9T5ozVdPBgk4LJuz+tT9R08g3OC7tePB9j+ly4FSaalPv36A2IcUqzziIAODwv+sEafD+7H8lXo4BW8NbEnixKAF+k4NlAN0miwT3/MYDPgAoxoyS2FjenDPJxmosuyetT09btK30X8bnFaA0bZAO+XBC1Ao7fjrp2iU0a5z3zL9+gW3hpoIpMgB0jTkNiBRMbbr4Wmcx4ZORn5PPYNh+0DT+x+8/3iOyHB7IHT+Yx4/9zOXJdrGmf4UkeqtxcsEzc9UXdBerRhZ6beOafF7YzksyEvyZHxCHdYbKV1fytCcSRXZrNO63NMjVlajRVnWpLe56ZJxZ9jhju3V1o2cJEkicNfGeg4P2Tg9lFVbTO9B3LESezSsBadRqdAJ8h+pVL39rh4Pnv9v/LEVbfY1yrDSc3Mq4gkaSMHs7fMTFgqs6jeT5+c/N8B5mqRjyxuiFbwLNSL4QsEXI6PrseisBFITzLYOtKK/SqSmUnRxKH9CuBI9gEVvg2GHM5p9fg3tDkE1UAdzL
 u6DNFrTl
 7WWbdsBFeCVEuxVCel5mNv3wwuFlEZGKCthIKZlmpjBGpOwgtyo43FVQIxvsL2ScL91+3VMdWGkaLGJm6tI6mPNilkw6rYcWsUm6tDcOmzOSLwcIJbhPPvjEv7GgS9av6i2VDYmx2z2zYcCGmYV2qeeXanl3aJ6BehPPB7gTKHjDFnO8q8CV/TLaG/RX+Vh4uy9ra2QLSv1h2bP2NOlfw/pF94HnqnosdK90FO9I+qP0Nfxr1JQ+guGtrm42Kpk8BFPX8x5qcc41l39ALmMHpbmxzAUlQAtuSxRAOcxceq2cuMhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jose,

On 10/18/26 2:41 AM, Jose A. Perez de Azpillaga wrote:
> On 10/16/26 12:07 PM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Prepare for a separate CMA pool for PMD-sized HugeTLB pages by organizing
>> CMA areas and reservation parameters into pools identified by page order.
>>
>> Select the corresponding pool for allocation, CMA-only checks and
>> boot-time allocation decisions. Release folios through the CMA area that
>> owns their physical memory, including after demotion.
>>
>> Record each pool's successfully reserved capacity. Remove
>> hugetlb_cma_validate_params(), since the per-pool CMA-only check already
>> handles missing or empty pools.
>>
>> Continue accepting only the architecture's existing CMA page size and
>> preserve the default pool's use by all gigantic sizes. PMD-sized pool
>> support will be added in a subsequent patch.
>>
>> Assisted-by: LLM
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> [snip]
> 
>> +static struct hugetlb_cma_pool hugetlb_cma[HUGE_MAX_HSTATE] __ro_after_init;
>> +static struct hugetlb_cma_config hugetlb_cma_config[HUGE_MAX_HSTATE] __initdata;
>> +static unsigned int hugetlb_cma_nr __ro_after_init;
> 
> the commit message prepares for one more pool, the PMD one, and
> hugetlb_cma_pool() folds every gigantic order into the default pool.
> would a fixed pair work instead of an order-keyed array?

Do you mean keeping two fixed pools, like this:

enum {
	HUGETLB_CMA_DEFAULT,
	HUGETLB_CMA_PMD,
	HUGETLB_CMA_POOLS,
};

If so, I agree. That is sufficient for this series and simpler than an
order-keyed array.

Thanks,
Qi


