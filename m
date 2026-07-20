Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3292C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F176B008A; Sun, 19 Jul 2026 22:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FBC6B008C; Sun, 19 Jul 2026 22:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654CD6B0092; Sun, 19 Jul 2026 22:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE826B008A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:49:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4DF48073C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:49:28 +0000 (UTC)
X-FDA: 85007624016.19.BC2EAFC
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD277140008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:49:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tU9U/1Xc";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784515767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UieMaWjn37WtAKNVXeqODJ/nhyQJ2CNCH8qbQcNSy/k=;
	b=nukW6O49aPbwvtIOk3969QHol1AWtNPnXFZva+ND4fSgiPPRakQfsA8k2C46Sfz48OldyX
	Lma9TgQE7OQC8lynyUTimbIfiApQisYlLRRzKqEMIJF6E0YmXWH8HyQpqUWgcxQ9307s4q
	QPzCfIvhuBpE5vu3OGXjiS0FRIqp+mg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tU9U/1Xc";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784515767;
	b=BpdEsbaB7h2RzYBSqHxBcYvxFBJm5VibftLUIa+RMidQ7lPIc6Eix7wGuWBKXfB9MQOJBS
	erzpxhavyX38VXR5q/8h2YqfljMBjB2Y5XDSmjVfi6cxOt3s8T7fRfLd6PRMdxMZihWEEJ
	bKYNlvES4mAj52Cudk32cHrJ2iXPXPY=
Message-ID: <c9ad9052-4f9e-42a5-a6f6-17877aad18e4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784515765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UieMaWjn37WtAKNVXeqODJ/nhyQJ2CNCH8qbQcNSy/k=;
	b=tU9U/1XcgGuRl/BZsM6szx+/SfKqjPtWrOEOswY01Srt4EvRzFDjuQMwhQJ+r0a1MpyQmU
	3VqRuFqoXLf6VUpG/5Ypzb3BZKz1gEIj3LUS1K+y+ButvYzn1Nreyl+ePLt0EaLVeyLgrf
	iWjYjL6wtw3KHFcGOqwl7C3io2OtSfg=
Date: Mon, 20 Jul 2026 10:48:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/4] mm/mglru: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Barry Song <baohua@kernel.org>, Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, shakeel.butt@linux.dev, ljs@kernel.org,
 kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev,
 dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
 <20260718095251.82937-5-ridong.chen@linux.dev>
 <CAGsJ_4zGRtDEGnQwmFqXrEcm93UrHaX8A_awJgu=b8ikceT8fA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAGsJ_4zGRtDEGnQwmFqXrEcm93UrHaX8A_awJgu=b8ikceT8fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD277140008
X-Stat-Signature: dye1uadonhnnkzeu3iup9ngjsw8q3auy
X-HE-Tag: 1784515766-854299
X-HE-Meta: U2FsdGVkX1+Ffo4ofPXwNM/moJbU8rOd1/xL8iiTIYKg9d4du9eAMaNlZBmqmz4a3TgB7T4ZQuI+v8LiGLfASi13ovkAHfgbdbCOnUVV3dxPrO9BhRTN8uMSGkP/kUHLZ4f8atR8ONbSbZUaZg4wqXXs6pcDGLZxf0ZsXQDkoQWg9HSelLwRazcbconA0z9M7/ruaarX1pu4rX61+YFKzJ302vfCXzNt1DkSk6sYcsssEMoIEyo15/SpdmODKTcQRA7YL8ZjPbyOCuzr21jhxZyEpj2qBJBSnUJ8h9cXwct1omHF1yzS3goLHCpgsjlZECNMFBFb6LmwVUZc184woHLeeyXEAuyQyerFOmxbJvr4PXIai2mPf1wOHpD1wvW1TJ6cQDIxIuB5ByTQ90CAL1BUpraxjV39K4ESi1oEjlPyNHlxJptCNQhjWUkMHTptzAkYvb9/SL6jbgwLBnTWrOypOhds17v0P0QA9lKrCD7XxgHM0hdzjciSjDOT8pH8YqYNXyf8PXcjY9kiNpmqZs0qOPyAgawCbb0ZAtA16WjswK3vYrfIEY2Qw6+9Kd3rWqaJ9jhhnJ8pxLNiMmQcZT1UtHLQpgITh+gqGikGvf64bF/nbPuBErWhbg39/IV9cALBfZVwFcTS6owCvjN3b/CV6WuqWdfyoUYxkGJ46DUAMbXhYxqm9KdkTzaoVsFUGiEBLdtVU4axiGVA1hMZr0+PDSMhgLaBoaE9gkOM2IVQhcDD2nYeXwJJnzRWYuMQ24v4dSE700GSR+HORw2M7Frpde5sFx0+niQZ27zUNMSj4rx1NOj5TDRdnpsfmmT4xJfl8BpbNT2HN+u5/AjyQBrpycZriE5tjnE92WXj4gRvN5zAoLHBzMNIntaMIltLTwJ1gHGyVOTVZ3pcuTnYCqNctnLkTjixMd2/BRERQTAneMPpxM68mvSnj2qmFgcyMqUIJFdc30vwt2UVH8F
 wLfAemKK
 I5DyNL8KFVMlXgBURgmKJiF/ID4+Eyi/zyxa2y9IrQX2rCXZ6oT87/YUOb9UQUpGxCxBSvAGeDpE7sekyltAQ6kMfSJY+QxfK5d30KXL9shVXOrLGN4QqrUeZqL/Nw//iKROiJyK2wzN05xvmvIciuL9W2lHrXN/UkAvhYLySyRbV3O77vNmLU15YqwZthg2mRkN0WLcqnwmlBalsk/t+jAklNIN3TWuSHynbkMq1Vq3ldRL01YoCAG1SlVhccF7XZddP6Znx7OzjoVlb7yJ+oPQZCuNidZNq01i9FJRe5X6PQqQu+Q48ZEQT6uVKaGW2Y2ip
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/18/26 9:43 PM, Barry Song wrote:
> On Sat, Jul 18, 2026 at 5:54 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> The previous patch fixes this issue for the traditional LRU, which also
>> exists in MGLRU [1]. Fix this by checking whether swappiness is
>> SWAPPINESS_ANON_ONLY in get_swappiness() first, and returning 0 from
>> get_nr_to_scan() when swappiness is SWAPPINESS_ANON_ONLY and anon pages
>> cannot be reclaimed, to avoid useless work.
> 
> Is this intended to avoid unnecessary work, or to prevent file folios
> from being reclaimed incorrectly?

Based on the test results below, it seems primarily intended to prevent
file pages from being mistakenly reclaimed. Also, bailing out early in
the SWAPPINESS_ANON_ONLY + !can_reclaim_anon_pages case is to avoid
unnecessary work.

Hi Ridong, perhaps the commit message could be clearer. ;)

> 
>>
>> The test result:
>> Before fix:
>>
>>    # cat /sys/kernel/mm/lru_gen/enabled
>>    0x0007
>>    # cat memory.stat
>>    anon 204800
>>    file 67108864
>>    ...
>>    pgsteal_proactive 0
>>    pgscan_proactive 0
>>
>>    # echo "64M swappiness=max" > memory.reclaim
>>    # cat memory.stat
>>    anon 208896
>>    file 0
>>    ...
>>    pgsteal_proactive 16384
>>    pgscan_proactive 16384
>>
>> After fix:
>>
>>    # cat memory.stat
>>    anon 188416
>>    file 67215360
>>    kernel 1970176
>>    ...
>>    pgsteal_proactive 0
>>    pgscan_proactive 0
>>
>>    # echo "64M swappiness=max" > memory.reclaim
>>    -bash: echo: write error: Resource temporarily unavailable
>>    # cat memory.stat
>>    anon 204800
>>    file 67215360
>>    ...
>>    pgsteal_proactive 0
>>    pgscan_proactive 0
>>
>> [1] https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@linux.dev
>>
>> Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/vmscan.c | 14 +++++++++++++-
>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>

Overall, this looks good to me.

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



