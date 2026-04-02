Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0937111227A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AD36B008A; Wed,  1 Apr 2026 23:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073AF6B008C; Wed,  1 Apr 2026 23:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2236B0092; Wed,  1 Apr 2026 23:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFB406B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:35:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91A7216039C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:35:24 +0000 (UTC)
X-FDA: 84612200568.17.85AECBE
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf05.hostedemail.com (Postfix) with ESMTP id D6E0F100005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:35:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="IOqE3/V0";
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775100923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCAZkr4rLrvAZkOtOmwtWC8aTcZ5AbhS1qyv6RDg3UM=;
	b=iwpCW/JGzY0qVYmKuonmfbM5jnKqemlguF4FjTy5RUfIMIG10NmLr6RP45dIXTt31ovmIK
	D/OVhXegDOlIx4EQCRbF3uVJpMzllGg/3Js4noajsqyOWLmplHiOTJRa9cP2Ln4EDjyzxB
	CJZpTMG4cMTtzwVzUTWn+Rnx0WibGX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775100923; a=rsa-sha256;
	cv=none;
	b=WyCRnTKjwguzS1LerPW66WPr9lJzCbMzGnVBTHB3DrXCs/jaFxOHo0+uqg6+eQ5QXl7tDs
	lhzfzXxFLVikqUYW2NCQur7rTI2XZHl+RK7VFsuTUXeNdpSCQadH8OOwUKWEz2+vVykktN
	brbCHxqzJzWbXtRvvE1M7SRWdVdOkD4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="IOqE3/V0";
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775100917; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QCAZkr4rLrvAZkOtOmwtWC8aTcZ5AbhS1qyv6RDg3UM=;
	b=IOqE3/V0x971kkvU8eXFyOtMNjZAKwL7G+daSOnhKYBKa23k9G9/pwmDvHj59u5oCiJFmue/J8Cl+e9n3A/aCsg2/VWYatR1ruuPw7NzRPrijMml8Ztt171ISJ/+ZOJ1aE1O9u7OO2R33cRTM8/1K/B5SZlNCSUmIZhDEBXlcV0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X0Fk3TO_1775100912;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0Fk3TO_1775100912 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 11:35:16 +0800
Message-ID: <ba39c7b1-ed1e-4cc5-bf1c-ac78946d6dfb@linux.alibaba.com>
Date: Thu, 2 Apr 2026 11:35:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for
 MGLRU
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, ljs@kernel.org, baohua@kernel.org, kasong@tencent.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jingxiang Zeng <linuszeng@tencent.com>
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
 <ac18iLvF-nNtxk1-@linux.dev> <ac3Pqq2WrGTJZLB_@KASONG-MC4>
 <0498d924-d76a-4d82-8767-e6297442967a@linux.alibaba.com>
 <ac3gP_OWXGnejtwk@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ac3gP_OWXGnejtwk@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6E0F100005
X-Stat-Signature: tmezobc6m8hndj5nanpmbg37zjxhm1hb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775100921-501338
X-HE-Meta: U2FsdGVkX1+fRorulX4aAneyWCKFvsZxYO9gH6+q66vC4JVGmEzkVwDvZz+ITf+uoC3nJLEl8bv4e6n6DMye8Od6DsCEsy9aBsj4A1eba12TW1Bff35PNjNGeGUKKZg6ULdaok8TTcF97qV8BTQTrJFVdXJAt5Cwnq2VZLTF2y/7zkRfJ+ARS5uprkXhQNYr5jadPeoNJywqRW1Pey+Ek2Debd8BhaHl8g/OPvZ8b0LLCI6V7sSkszxFnq+8TrbvqoXIHy8OuvJkJkiBjlfTH8JHVf++LjLfURlPyQQHu/1Z+aufE9DwYuvYIf6XskwB5TkDKcQ86PHOEIi7mzVqD+awgiMIklVdZKyMwYE/TQmqw9/PkJxaXdxboU4izBuqLMQFBojdAV2H49hNpW8xMDyGi0hARiqviiTAutZnawha/3ZhHwiMCfEwjdGHuJQiSj03ikkuJdI1cPCWTsbAvRzmkwABei8g1oXLfVD2TD8wp8MREcIgrzVb+Q3hniSII3r2ZhO914ZZfVarPwvoWRhCv9OhGTvZFTTwW5lQAiFvjC4AH/N5mmY0Fv3gLVLZ7A8JD4b2rEzvH9TwsXdfkfA/2RlGTcCaR9dVBIKRLy9qrbK2YKEuyIRc3NrOqNnuh/8jf2m4q978MkrZ2mVcJ2eHiBFMQGCVJtdmeqevCn97kFawuzCuIQ4NknDfMwR+EHV+q1dMaxD94eZcNv2xHkh+Y+MYOYvsAI4yRH9QybH128Ajb6DqC2/i7PMuxfqxBATPHEZhsGZJP97wPhh4PU8nDqEioq49i1pXzqxl82E/oh7TkeLkk0WBVkuFgIwYnpyLvy2MwUHgcXyhqftenUDIgOAC6H+IIhCi7LEkX+yDcaxWT6JdOJ2NYhZP26BTydWr/AfskMEFF+FI0vR3Akf6BsL80ME3gslcag1SfYEvcjR7NnQYPavPLzl8CuC/y6Ev/G613OnUGAuNaZd
 dL3VtlxV
 34iwxVk/UU2mkRo0OekI1k9AE+4fxsfsui/zZ/pnR08AOZ0+1mkDWxLMiFgkBbeHDhY7fz/QcOQz4dl7cmGHlJzvb29HVU/jpMBWlnCoYSS9sWIlnC4Bb/51xYeWVzfefvcZ3SMiWpdFQzB/obX0TWQ3ffj9F/ME2X1Pv58pA+xMaTMZszny+hDE/NZUHBcYwqyG5B+pQ2FLVY03I79KyXO9rGW2dqWH/bEIFGndKYsqjpO9OEu93+qlmd9/47NY81dUlxJPgYioLQrfbCTTSW5yABZ/MqUC6pr1vhD8zRvwXiR/pHy7YNd0a6JQhy3lxu5CrrIJ3Q1eJsb2uZI3W8Z7aYfyISoCtq/mNKhV02Cor0aw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/2/26 11:23 AM, Shakeel Butt wrote:
> On Thu, Apr 02, 2026 at 10:51:37AM +0800, Baolin Wang wrote:
>>
>>
> [...]
>>
>>>> This is v1 only and I don't care much but what is stopping you from moving away
>>>> from v1?
>>>
>>> For example memsw?
>>>
>>> https://lore.kernel.org/linux-mm/q2x4drxpjbxcxgns6bjp446ynsxgl32ckcljqcol7posds4nit@3n3tjq35anvb/
>>>
>>> I remember Jingxiang's plan is to improve the page counter first.
>>
>> Additionally, we still have some existing users on cgroup v1, and they will
>> need some time to migrate to cgroup v2.
> 
> Time is fine but is there any specific v1 feature which is a blocker for you.

Nope, I haven’t received any blockers from our customers so far.

> The memsw is a known one and is the same for Google (data center). I am aiming
> to provide memsw like behavior through my memcg_ext proposal but performance is
> an open question. I am aiming to have a prototype before LSFMM to further the
> discussion.

Great.

