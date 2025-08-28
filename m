Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50368CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5226B00A2; Thu, 28 Aug 2025 06:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685A66B00A3; Thu, 28 Aug 2025 06:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574BB6B00A4; Thu, 28 Aug 2025 06:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4511A6B00A2
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:31:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE8E25C581
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:31:05 +0000 (UTC)
X-FDA: 83825798490.16.8137DEF
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC68AC0013
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:31:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kFSC1e5W;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756377063; a=rsa-sha256;
	cv=none;
	b=DIjZmQp4K58dnFZ8s3BjQyNZYttLco1HvRKePMA01Jvv3eAIGSfo2uBep/zCZkM4HYjJxi
	jftIGeeUef2Si+pb0lLmlCnnNkHaNaKuG49/COQzoPPeaG3oAK6CjF8s5ZjuOvjLqhsvL7
	SVIBOVYob49445m/CrIvFp9fTwQfPGM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kFSC1e5W;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756377063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3HUDLwwcHzYbAtlolpUh3esRybaOlr+CrGOLxJ95c8=;
	b=liDJKra2RO0/PpRZcUlDtc4QMIvm4IF5GWy2u9UzGdv/8XYs2FF+xnY8BfR0POSJ7wmX7E
	5UhnLhtJFmFvOkttM+bSA+SJEZTvnnQN6STmYxkM2GcjyeWuVoQ4SlerhNosz8TXqBlt7q
	EvKlrWgRO968OVtofq1npmFAWIz7ixQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756377059; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=h3HUDLwwcHzYbAtlolpUh3esRybaOlr+CrGOLxJ95c8=;
	b=kFSC1e5WYi6PNUO8pZs5l2Lb6Lf8fVep/sUt0p81KDXXUmTqTZlvuKKaVIxp0iFTE/HMU00IQM3LPT6dXLY7+oKRqNbnQ1yKMm0LS/LaYN+tRftySAjN62MQ3BUvTfu8A1HyINEYZm7c8m+7DVMu+NVSEpHUwaRi8452HbnKcaA=
Received: from 30.74.128.191(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0Wmmy9ac_1756377056 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 18:30:57 +0800
Message-ID: <9a02a229-96da-45cc-a0fa-ae5344faa540@linux.alibaba.com>
Date: Thu, 28 Aug 2025 18:30:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: Use pr_warn_once() for min_free_kbytes warning
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, baolin.wang@linux.alibaba.com
References: <20250828030602.204332-1-tongweilin@linux.alibaba.com>
 <aK_7GKJ4BWjye4tZ@tiehlicka>
 <35e0a580-ae78-4485-b285-7f71f91e046d@linux.alibaba.com>
 <aLAj-itGT9DD3SU3@tiehlicka>
 <9639adfe-13ba-4c27-8ba6-8bf3e2190450@linux.alibaba.com>
 <aLAq5TaqdR7GQB6J@tiehlicka>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <aLAq5TaqdR7GQB6J@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BC68AC0013
X-Stat-Signature: bkqt5535sbnas7kggtzd34kbsmr3g1g4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756377062-612209
X-HE-Meta: U2FsdGVkX1/0or8O1RvBrHhabxg4bI6uxuQn8l11Oe/c1JjhRrxJHKnTybzol6UwTrtrkDvKmkR8moqEqJQ3BWKR3sY3RUzWr4xJDcAH3u2x60HVRIOm2tM33pFKpSM291C8TzYIcVoGjA1PLT+qomsH0HjOivHwXOrEB2GedmjwaaJzZPpsvbAiSKBGR3GXDz6RbPApEYt9roDYayQ+5P13XZuRPsAvYjnKrSKou31WcU7fBzGcS4OsUoM9nVQd9AKWxXBimTdsPc16YGadSHsAsLsYKfpLxHMQn70ZHaWtNKxkEs7oikNxDuTalyWSkSJWLy4W/o2BAT3r1iP9dMe4Ysdnvoczy7+ytAhyhr+sW/yJiyBCurxvLMd/oUzrrAO8wvPbkU9LRoDcherD6PzgSXHKsnIislBsG2GWgdvBu3eiK9gEveWXXMwP9whLDlit+3swB3KuOXAGf3y339QpxmZxdzHIxj3y6X5+zDp0ITUBzqyfBog6U0fPVg+HcOobbpTg/cVmy9+aXD76+wj0gqcjOvrJmeRnn9ijLBeLBK4uKh5zERP9746yfAxn6BNirlBI0HIxnTeS35S1fvNv+qmY4+78PQoBUcAnXT18FQAAoO8uTnONDCEtLTMRJaoBlRCwZpr8e6+uxfoedzczimC941MwfCbMlpUlSz4+YAyBp7mnGiuyfVAenrpuddgXWuP0FWRtuuUDtvK1utZcBmgT2hrF7bhDZoj5U9p0sdhhNP9kUEYujPXTtuez5hHHSinN+QQlkV+tsWSXhmORc568LkS/vBA+Ekw9GSnN+4uRLjVIqIPtvR65w6iaOOJnt/fM7jrPcXD9f9/GJJCuSL/OoVlXjmHdhc+5wZwDcdOSmRdBhJ8CLR+l9F4QbX0uEJslNDT1IJHRehwKTT1Zsfw05bS6/j1UgztL0IyzrazrbNaaxcsfGbGziMEMhx8QUB2R1mLPa7pL5A/
 ov87ndwZ
 dOWJf1I63Rwv5qDJrxfFImyicEJNhRpkc90LqJl74KwOOfJBwtd3TAK7VUl5k5bdk0F/dQMqPdwsLkDCB3LzujERWq9qzcwNrb1uHuUJ5D7cmd+cPkpkEL4dQg+n/K0ofJC2+vcDB0U3FGO7HT/6YolKjGQtofXSVItLJ9pev/tX5l75mBKpyTKyWDFfqsMD2aQ+rSAqLoJS56ZwDdMZWnMW2J4FJcRXkOMV++UGlknzs8DdSvL2qzbER1uJB5750pZt62LD5aPh8yIhm8P7D7rqPKpr30bc7qqKZi9zjiTqf5Tx+X6jBBKDvyBKhStWrzWN2GocHkE/RBvaUnPZkNLFrMB3QgkPZGBEfxVpEefaHXX+WezIASKIY5e34OP+NId8o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/28 18:09, Michal Hocko 写道:
> On Thu 28-08-25 17:48:54, Weilin Tong wrote:
>> 在 2025/8/28 17:40, Michal Hocko 写道:
>>> On Thu 28-08-25 17:23:40, Weilin Tong wrote:
>>>> 在 2025/8/28 14:45, Michal Hocko 写道:
>>>>
>>>>> On Thu 28-08-25 11:06:02, Weilin Tong wrote:
>>>>>> When min_free_kbytes is user-configured, increasing system memory via memory
>>>>>> hotplug may trigger multiple recalculations of min_free_kbytes. This results
>>>>>> in excessive warning messages flooding the kernel log if several memory blocks
>>>>>> are added in a short period.
>>>>>>
>>>>>> Sample dmesg output before optimization:
>>>>>> ...
>>>>>> [ 1303.897214] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1303.960498] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1303.970116] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1303.979709] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1303.989254] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1303.999122] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1304.008644] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1304.018537] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1304.028054] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> [ 1304.037615] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>>>> ...
>>>>>>
>>>>>> Replace pr_warn() with pr_warn_once() to ensure only one warning is printed,
>>>>>> preventing large volumes of repeated log entries and improving log readability.
>>>>> pr_warn_once seems too aggressive as we could miss useful events. On the
>>>>> other hand I agree that repeating the same message for each memory block
>>>>> onlining is not really helpful. Would it make sense to only pr_warn when
>>>>> new_min_free_kbytes differs from the previous one we have warned for?
>>>> Thanks for your feedback!
>>>>
>>>> The dmesg output above comes from hotplugging a large amount of memory into
>>>> ZONE_MOVABLE, where new_min_free_kbytes does not actually change, resulting
>>>> in repeated warnings with identical messages.
>>> Yes, this is clear from the changelog
>>>
>>>> However, if memory is hotplugged into ZONE_NORMAL (such as pmem-type
>>>> memory), new_min_free_kbytes changes on each operation, so we still get a
>>>> large number of warnings—even though the value is different each time.
>>> We can check whether the value has changed considerably.
>>>
>>>> If the concern is missing useful warnings, pr_warn_ratelimited() would be an
>>>> acceptable alternative, as it can reduce log spam without completely
>>>> suppressing potentially important messages. However I still think that
>>>> printing the warning once is sufficient to alert the user about the
>>>> overridden configuration, especially since this is not a particularly
>>>> critical warning.
>>> The thing is that kernel log buffer can easily overflow and you can lose
>>> those messages over time, especially for system with a large uptime -
>>> which is far from uncommon.
>>>
>>> I am not entirely enthusiastic about rate limiting because that is time
>>> rather than even driven. Anyway, if you can make ratelimiting work for
>>> your usecase, then no objection from me but I would rather make the
>>> reporting more useful than hack around it.
>> I agree with your suggestion.
>>
>> With respect to your suggestion that “we can check whether the value has
>> changed considerably” I would like to seek your advice on how to define what
>> constitutes a significant change in this context. Do you have any
>> recommended criteria or thresholds for determining when a difference in
>> min_free_kbytes should trigger a warning?
> No really. Certainly increasing min_free_kbytes by 1% would be barely
> noticeable but 10% might show some difference. This will likely need to
> be tuned on real life usecases so start with something and we can tune
> that based on future usecases.
>
Understood, thank you for your suggestion.

I'm also looking forward to additional discussion and input from the 
community.


