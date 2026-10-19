Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CA3CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70756B015E; Mon, 19 Oct 2026 03:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21466B0160; Mon, 19 Oct 2026 03:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B374D6B0161; Mon, 19 Oct 2026 03:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F02C6B015E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:17:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29AE91C3EB5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:17:44 +0000 (UTC)
X-FDA: 85338520848.12.815A117
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9338B1C0005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:17:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KV3YTZP5;
	spf=pass (imf20.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792394262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wMu227B4xd1nmenvmIGVICqaK2mH0QFftyQxpbMflg=;
	b=0SQJymP99U7MZJA7nI91rvUqVscSWCkSBDc8gPqZ3gLp7CQA8l6yx+tPU3u5iCAebhbu2J
	LeL0//f+py3Hrz+xgVTtuJCAnX16TgdcwKoEsASK6H0F6Jctyj90Ov2cNlZu83zi80Sutb
	dFlAHcCg/0F+XIFBuTyCBIpETt4goUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792394262;
	b=2K7uro+Tip7IUD+Oli3x4vHvr6mvN2QqkPRxStW6Z9bAmYaL3xPwz/yJsGoHKlbLC+2aGw
	Zy3KVQPY4udPnyVUtmIB4QOYstXMkkmCSMpOkQ25s9czLN6/N6XSQBAq4H3wBBqI0SaT4P
	Ml8OR5RFuA7V2PqD1MAoMtHsg7+RnVQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KV3YTZP5;
	spf=pass (imf20.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792394253; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6wMu227B4xd1nmenvmIGVICqaK2mH0QFftyQxpbMflg=;
 b=KV3YTZP5BhPdSkH5AA+7IFwmQmLo2zAoDCGpqBwo0w05cMwsolYrqh8UcrLIYWz5AfKCVe
 L9JGU+9U6MSH5sAOfKf2sabmfOv/toDBWjT++oq2LmIQs+vX12MvLUPOkOP+NC0vOCP8RP
 /kFL+hUh6ZqZ91zyt89z811gpZqy05BW7hzx+MFjcJ2G+ErkGDDfM4p5dCxrAvrX/qfuIk
 DdmxBiWkihx0azz5dKUckfnZUdIMgjFveW9e95XiJHg6dfCZWkBkUrsSOLpKlf8uh4VvcC
 QObNnd6/nokgC1jcrMhuRSkiY7xnoEXUgrt113jQTh/oUqW/YCtEFPDfb9IB6A==
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	"Qi Zheng" <qi.zheng@linux.dev>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>
Date: Mon, 19 Oct 2026 15:17:16 +0800
Message-Id: <5dd986d1-b2f8-4f9a-b8f8-d70759603564@bytedance.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 4/5] mm: hugetlb: avoid recursive CMA allocation during migration
References: <cover.1792136742.git.zhengqi.arch@bytedance.com> <d145aeb815b318ddd4dd9058d20038acfe5dc1bb.1792136742.git.zhengqi.arch@bytedance.com> <fe58f891-7752-4691-9e67-b5a4a5c125a7@gmail.com>
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <fe58f891-7752-4691-9e67-b5a4a5c125a7@gmail.com>
X-Lms-Return-Path: <lba+26ad5c40b+751957+kvack.org+zhengqi.arch@bytedance.com>
X-Stat-Signature: riwnys63xkpxchp6p8zjy4tg4hbxoymx
X-Rspam-User: 
X-Rspamd-Queue-Id: 9338B1C0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792394261-530738
X-HE-Meta: U2FsdGVkX19I5ynpfB9tca6ZIvRejtn3r1wmvAHBIryV1BPYAMYPUbYynhSfYhVaTJQPDbjXj8V8Mze4hydTUXyLDoHIme7chYRmkcnIjajhAx4nncVpAzm8TpqB16WjnwpB6B1gyZzrvVWz/X6N9rbBeQFOChs3XIz0PVtfwMerOyBLJj6WcBUDHzEwXTeP8k6l6Q6/6h5xB4qvZu1RjdQMar2nRqvnjYCcBcMUC23zuNmEGtD9BXF3lu/ynLfOIROxXaUsdLO4oK33P5GrWTcdUP1Z/XkzYHvI/KCvcxfT8XhpGrvyQg0leW+nffMpGMTP3pFtZWFUhLY5xphbyhThx72c6xy0M9kMGVj8tCaoyIFzLi6td1V/tjL++rC4UF7Mso7ByXwidKV83lqZ9hTRT1WESc9SWt+LWs2hqroulbdsL4DLlOhlDmyOWDO7E5RP+NVNsH6PBZvGYrnIimHYz0JlCxTvsONeKFeJkm1mhhukQjRnnZvIrTPDWcZwLWoYLQS1fxozIqPNolcXSaCqzGSqvesb3tuS8Z3R3AoyTdTwRf3oiON8biusdiCI/3iaIyBCGPrxQszervyKO/JegzoG7LvJ0XO/iR5q/JUgUFFzrgXpZwV7asdxQ9aCRNc4z4vFVUfDHH+pJ934ba0OW3UT5diryLQuGyrax2laWqpbc+8ghkiwYfa7PLGQ8gk2Gec5lI/ma8k99bQsCvbhb59AJPqOz8b3BN+vOHLmT14jNpLJ1sJyL96oOl7Xno377KFDR4apO4lBSO7K62HwEkMquQ1fJHn17eSZf8H2aQaKb/vnzz9JMmhSUUsH322mQqB6vpUW0rRAR28wZM+BFJOAezh/Gf0FDYOUDbWgBaxcQcTdknmZh64uTnx8xjaDvbRo/3C+43KrItmrp1b2fU/8Xp89DZbzHK01Rwz5YPx0PcfM+igMZEK5t18FTohOWeblOkUqyDfMj9c
 b1gQuI26
 ww90br+YIBYyHLg2IL+3iOek4qIqeZziHHFZIksg3B2Xxxlf2ZseufF2I2Yx39H5TaIluX2npFYYhKwLlbDHqCzknaGpnOCbH+svZIHSt+VG24DTq6FnUueOHl7St33WftNB4U7x38PqXvN7OyRq1PL0onA9x6oLgT3SPiXLuGgFCM+H3XxWSKoXLGKG8CuGGd5XpK0RE4JaALNui1Zn9TAsCEpXNAtU4Dwirad/PHl1PXeWj9ETtAkeIVNIUWqwUUL2oDStXMddV1ePKCO3Khm5ozsHC/B2poFZ5/f9ocoggWCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/18/26 2:54 AM, Jose A. Perez de Azpillaga wrote:
> On 10/16/26 12:07 PM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Contiguous allocation can migrate allocated HugeTLB folios or replace free
>> HugeTLB folios while holding a CMA allocation mutex. Allocating a
>> replacement through CMA would recurse into that allocation path once
>> non-gigantic HugeTLB pages can use CMA.
>>
>> Add a fresh allocation helper that bypasses CMA, and use it for free folio
>> replacement. Pass an explicit allow_cma argument through the migration
>> allocation API and disable it for MR_CONTIG_RANGE. Honor hugetlb_cma_only
>> by failing fresh allocation when the corresponding size requires CMA.
>>
>> The existing gigantic migration restriction is unchanged.
>>
>> Assisted-by: LLM
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> [snip]
> 
>>   /*
>> - * Common helper to allocate a fresh hugetlb folio. All specific allocators
>> - * should use this function to get new hugetlb folio
>> + * Common helper to allocate a fresh hugetlb folio.
> 
> couldn't allow_cma be passed down to alloc_fresh_hugetlb_folio() instead
> of adding a second copy of it, so this line can stay?

make sense, will do.

Thanks,
Qi


