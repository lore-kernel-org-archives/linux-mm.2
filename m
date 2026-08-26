Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E20C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13CD6B0088; Wed, 26 Aug 2026 03:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E076B008A; Wed, 26 Aug 2026 03:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65E76B008C; Wed, 26 Aug 2026 03:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83A4D6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:12:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CD3F1402C7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:12:48 +0000 (UTC)
X-FDA: 85142553216.06.7864C64
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC19F80009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:12:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OwOvhmtz;
	spf=pass (imf30.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787728366;
	b=ezT5PtQqNxt9/vRVJROZL6IOLj3QtYYMm3hfOXtb6sWOTLBlJ0akphCHrLJFwuwAztS8Xw
	eJsmP0pgqqxRpD0pCdD2O51ZhuE0mqAmdEj9GbAgp5YNQqiAR8Fk+NH5a42XloDWwY5wGx
	inLZ7mSQBUztMcQU6g+uqhugOPwL4QU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787728366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMj/68VBwbCteYKyTb/CDtKHGIohm/Yd4Nbofe6Ek1M=;
	b=34RkpDRwI6vNk2eHlW538sPG4D47a8zNVvEqifVDX1GjbsmDXPlC0UBX4omRRxOHhECTj8
	9otK4qxruGygrXrLGlehHzIPi/4E39qiQdR6GWMSQbLpUIynXEJNZQrKokrhXSfEm99+qK
	+vrPMoW1nRUqwg4Iu02suJbML1UO7PI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OwOvhmtz;
	spf=pass (imf30.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=YMj/68VBwbCteYKyTb/CDtKHGIohm/Yd4Nbofe6Ek1M=;
	b=OwOvhmtzYLIzANJoLSpF536BKIWkOpx6ClJmpmafH+0+s+WE84MvEOm+sJaygN
	6z8YR9j5WujJfoOrZrrKzM/1cL8enAUxu8g+zf90dYfYHJoN2KfoJiZ/1hJnIZ8a
	Cq0saWHd2VOb0a4lEl3AyDRd3Ip1elMsOHHzVXg9Z2yks=
Received: from [IPV6:2409:8d1e:e12:7fe:b7cb:e263:e9d9:f20f] (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnl0jSkY5qucu3SA--.999S2;
	Wed, 26 Aug 2026 15:12:20 +0800 (CST)
Message-ID: <e5afbca9-77f0-4727-a825-440df45c89ca@163.com>
Date: Wed, 26 Aug 2026 15:12:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/slab_common: fix shrink budget underflow in
 kfree_rcu_shrink_scan
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, paulmck@kernel.org,
 rcu@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
References: <20260824091838.1692153-1-xialonglong2025@163.com>
 <ao5UqBL4iPh8zlpG@fedora>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <ao5UqBL4iPh8zlpG@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnl0jSkY5qucu3SA--.999S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww43ZryxArWfWw4xXw47urg_yoW8Aw1DpF
	Wqka4Utr40qr429rn7Za18JryYq3ySkFWxGF9Y9FW3J3s09wn3tay7tr1q9rWYkr1kXa1F
	9rnF93WUZa4qyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U5nYwUUUUU=
X-Originating-IP: [2409:8d1e:e12:7fe:b7cb:e263:e9d9:f20f]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3BTX0GqOkdS5VgAA3B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC19F80009
X-Stat-Signature: m5kkug3uso3n45rx9w8kztdzsebhgz6w
X-HE-Tag: 1787728364-345738
X-HE-Meta: U2FsdGVkX18/kdwlRpQf0vWQy66K3dlSXL4scT5o3zRSMxYDs0XXl46yMFJSB99AvY+mdVVg3zAphnrVX9NZSSSmoHs0L9VIBfTPPyKqi3FHkm2NXg01U/XXU77vaNXvAeLBkcMhr0C00R1qQ4jKPEI8DWRYFV8tkKE3eWVaaYqMLTjO1hhK3WEJ2SXX6k1+43H6RnFDKJcuiiRuQb5PCUNLZiCAH1wT/7NEhS4mmlYODkuM8eEekQBAS23exv/VA2baOwlxlB1nFFWXG2UgsseD0i/XaS3lIV60TzSJ1sNetKQuGoQZYPsQp7gK5TwkLoD9Xkb127dUT5LG1JR9ZtoN1euwHAHwQXUDwW/zyS14W0EAEUA1OcXEoq/MJHWz24+yGr2d8ujhOlxyn3VtD+/+GrJUWheOn+7qVCnjR09tPCoQBqOLNXdubzl/cmNKzFOG85ME7zOGxik8ESuH/DERALLx6+LOVymqCDcM37Ha0aO7HMH1aAXBSQ/LDdBIUu37wL6BsXH+Eew8OnFAuSPLBOOII3bzgeplLjBDyRvdsa7u8LU2CvhGvAViiB2Gclt3yBgJbuLcss6jpMMMcQNATp1OlPFPyEw1cTQwan7S0shbgY0vTxEXqOhmVZ+1jndoDQA9qE81+cNDR2TId5xzo4+59CRMWC9qgEC3eAfocCsbKUc7Cn9PS1UFd03+RLk1W47K6JzhrpWTs2LB6MBH2jPJVcFHgC2RNUq+aW7RC4lT8v5giOgC1G6B67XUIGBDD2R/3eW/qhCgTWPkJNlz+YMvMdkdUrEgXoG+gJcFHDqLusCqrVMwJVRUqP08JM/Z0M1JROKSNUWNpEFl4ptfvOE5gp9HsX5cOm7szV9C+N5oXvRd6V9L/yYkVDDp0Rpu/KFPV2YYTwspT3tXF6j1k7u7UPbwe1PEvTmAOD0IgSYEhajIveNoWWLuDXmWI3WAcOKmMYYzuAX7SlU
 per7Bzwl
 /vUrHwQoaskvPAhLavuyXbz8kIxqp2A3A68kq23en+N3G92l0E0sVCfQttckREHf0L0as5rj+7MkTDnTvDaHd9QKSkwXAd+5FpLnpAUfrQEk3ip6F7mtXduzfl0dxtkVACu4q8q0H1z1E6YWhUTDj9wZfX+LMHWoQz5PLWctjaBytzTHH3Yy/AOx/ooZ+kEGB8JCdcv3j9G5rn1c6AYrF0reOBk4A/lMi+ZIjZKMkNTl+XuVTuWq3bB9WYhFO2gdVz4iMs4etR0a6KXjZQJYZEM2xpzY6Eg9x3KJoX6/aR0ujLvr8bcUv/7ab7TsXEeuDR4/KmUCVqhKuOhXQLkITjUixjfm4mt7qDA47E1adI3nGfWrvdvPFYaNn2pUq4SC67JM1SuvUInxC0EJHpi/h6TEgcxkbME/OB2uo8D4EVq32dvV564sJID3nRoO9n5NFsCnQPqf+ZeumJ8GUT1Kmw1aA7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/26 10:56, Hao Li 写道:
> On Mon, Aug 24, 2026 at 05:18:38PM +0800, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> The kfree_rcu shrinker decremented sc->nr_to_scan (unsigned long)
>> and then tested the result with <= 0. When a single CPU's object
>> count exceeds the remaining budget, the subtraction wraps to a large
>> positive value and the <= 0 comparison, which is equivalent to == 0
>> for an unsigned type, never fires again. The scan loop then iterates
>> through every possible CPU instead of honouring the reclaim budget.
>>
>> Reorder the logic to compare count against nr_to_scan before
>> subtracting, so the loop exits as soon as the budget is met.
>>
>> Assisted-by: Codex:gpt-5.6-sol
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> ---
>>   mm/slab_common.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 657fd75776ea..95ddbab290d4 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -2172,11 +2172,11 @@ kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>>   		count += drain_page_cache(krcp);
>>   		kfree_rcu_monitor(&krcp->monitor_work.work);
>>   
>> -		sc->nr_to_scan -= count;
>>   		freed += count;
>>   
>> -		if (sc->nr_to_scan <= 0)
>> +		if (count >= sc->nr_to_scan)
>>   			break;
>> +		sc->nr_to_scan -= count;
> thanks, this is indeed a problem.
> I think we could make the code more better, for example:
>
> 1. remove `count` variable
> 2. add count to freed directly (also change type to unsigned)
> 3. check `if (freed >= sc->nr_to_scan)` then break.
>
> How does this sound to you?
Thanks for the reply.

Sounds good -- I'll adopt it for v2.

v2 incoming, with Suggested-by from you.


Thanks，

Longlong


