Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3D6CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978DC6B0125; Fri, 26 Jun 2026 07:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950016B0126; Fri, 26 Jun 2026 07:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868A16B0127; Fri, 26 Jun 2026 07:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 639096B0125
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:21:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5F258DC3F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:21:51 +0000 (UTC)
X-FDA: 84921824022.17.8E1BB78
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf14.hostedemail.com (Postfix) with ESMTP id E97F7100003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:21:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ShybaEdE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782472910;
	b=D7flY/tCx3RY8i6p86FULpnGsFHN2ZhVKo+/Bf/MY+8lAA5a2Dg0cGz6t2RyQRECE/y3OL
	T6A2+T7po2wyYf2dnC5XTFmarUE1M67/hxYso0vtclCcLcC6n6e1Vj1L37BL3TCub+3uqq
	zpIPjAKcM0m00qLsfSAIhlLolvf5RXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782472910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXnGSQ/f8kthQgxhjN/qMHFlHYZPXPOXt+bobY0m7Ck=;
	b=JC9f+IBAKIBS9Jpdzi47A2PvPgRLYeWEb/mklsCRoc0295MujoyPgqqaGV8EsJz3MPfkY0
	LKMI6jyde7Fb7XpuvDMfKk7UgGHIhvN/rhfOmegFoue2Ql5x2Awex13QTB8hBnJFX7ShIK
	xe1aRG6uYkjUrh74LMEGnLJGHYGUnZw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ShybaEdE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <57c18afd-e2a3-4b37-90b6-f2a4c758e8aa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782472907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXnGSQ/f8kthQgxhjN/qMHFlHYZPXPOXt+bobY0m7Ck=;
	b=ShybaEdEuvjaq13R1piH2Z+U9a0wSOAEKFD90/s1i7ZE77Vs1RndU1kW6KQ7qUbtW79HcD
	vreqzNqtQaQeE+7AcQ8JQkv+EBQd3thYj97SSBWGmSD22qqs/z7PobV/u8tB2breJGoknE
	My76uAFXDSZY5f+J75MBfMNtqFjnir8=
Date: Fri, 26 Jun 2026 19:21:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Johannes Weiner <hannes@cmpxchg.org>, shakeel.butt@linux.dev
Cc: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
 roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
References: <20260625151554.55105-1-qi.zheng@linux.dev>
 <aj12aVq3he6q7b2C@cmpxchg.org>
 <4c7b0c46-14f0-4a62-893e-e50714e09b74@linux.dev>
 <46ac28bf-5be1-4600-b522-0a1aa76c28e6@kernel.org>
 <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
 <afdaff7c-fe6b-40da-8f54-aeeab8fe8867@kernel.org>
 <90fd5300-1016-42e7-abad-08ad85fb62b4@linux.dev>
 <5a0c6597-6b96-4781-a71b-fd1298b2b7bb@kernel.org>
 <c0e366ec-ee5d-42d9-ba33-7c630660e8af@linux.dev>
 <aj5I7JAXWlTHRyEW@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aj5I7JAXWlTHRyEW@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E97F7100003
X-Rspam-User: 
X-Stat-Signature: m7ajjd9yswtrgdz5sgh5wzh3o5sspes1
X-HE-Tag: 1782472909-116186
X-HE-Meta: U2FsdGVkX1+pgVQKQBQt70VeYtRNwOdYo7qAxHUD6hqOOnJs7KNEcRGmyS/I8Uzl1UtozojICiCp4FhIAY6OnruIQ4YOKvVlxGNlZBulMk06Fc5T6vI8kFoO1lSZorvHF0LKrglt1ccSr1HzRmIRuoL/Xmt9ViQR5GzvWkmb32Y8XPqonkgbQIgEoa5PsP1CtUZ5g6ado/AtUFukk2ySoDnJ/OzFdlpJF1qnS90MMMcuyKegLS99XiGpwo/Y4W8774qcqkcR9AiQxUWq9tKnVtSTWDBvNix5ecvBrvprPaCJDkS8Yki539IxF5DHTisvEvbyu+wgkTMm4eISJgg57P1bU3c+YznRagBiOH1JQ5FITMA8DxhGtpUPxmrFFiEOh2y72L5/FqoWgDoe60g8dkI5O9ISZb6UcsScxsUv5WQgUL+W67sCJNv614cvd9XqI1m9W12e3cbzIWJaEG7pxklmMWik4pma+jOQIraRvGPQ6N17KsKHjGIXCjGKlww5uDopbN/zBa7hrvHoci8IQ+8FrY5PBpXkN3L4ooxtYEFPIdLq4seaaU2Zfd6FOXALJRTmpG1Y5Myaf/1gAUkoaa/mD917zCt2O0irqfU/99iukYQhBZihTlzi1joVc80D6x5ekFt20MHccnf+Mvvia3ANtvw4nI7apJqfAQsFOYYGPnxylB7eRl6rlLUai/OHA9ZD/n/0Fx2eD1AHhH7/BJ6eEBMRdbEiyjisyTkXlN0hGz+SvPhgTNWGqzqtr943E3vs6eC/cw2/HnwB3mevT+GCPxki2ExKZGA7DSY/7Zr3E6y9vs9jrduZwS2w/pA0bTh6vJwfPu1ZOys51G7MRc8a4fmtQDZ4goNunSE79m47Y6EcmTZOAopQEoX0n1ISGglb9ya6gVr0p2QfNx8gG/mD2/xVsWPdScdy7/o5nJ135hY/vTGv6Rm/ZtQVIlGx6v/e1eaLb1WgQsVkx5o
 sNeZHKi4
 AW1IelYrjWYXXwEiVB+OR+5ui0qAFwqr/BPaI4Bhz5Vpqqz+ppfgmDeyu+4PRYoUugHafFzsT7cDYEPWoDNuDgs8PaXjk2Z/RonFSRHEMstHwT7gJVfOLaoTtJSwckJobrME0h+lTCXiKpNkp8qd+YORH9AGBW+I7GEQdcroawz3k/pZzuva2MafhyZW67f7xqw90xiv7KmjDTovINCru5yCM+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/26 5:39 PM, Johannes Weiner wrote:
> On Fri, Jun 26, 2026 at 03:04:17PM +0800, Qi Zheng wrote:
>> On 6/26/26 2:48 PM, Harry Yoo wrote:
>>> On 6/26/26 3:24 PM, Qi Zheng wrote:
>>>> On 6/26/26 12:59 PM, Harry Yoo wrote:
>>>>> Observing a dying cgroup should be rare anyway, it's worth focusing
>>>>> more on readability?
>>>>
>>>> While it's rare to encounter consecutive dying memcgs, it can still
>>>> happen, right?
>>>
>>> But is worth saving a few instruction in a basic block that is
>>> unlikely() to be executed?
>>
>> I don't have a strong opinion here. Hi Johannes, I'll leave the decision
>> up to you. If necessary, I can send out the v4.
> 
> Yes, I was thinking what Harry actually bothered to spell out ;)
> 
> The race is rare, multiple levels even rarer, and even *then*
> mem_cgroup_lruvec() is a quick inline.
> 
> This way you have one block to handle that one rare race
> condition. One place to put the comment. No labels, no goto.
> 
> Simplicity wins :)

Okay, I will update it as you suggested and send out the v4.

Hi Shakeel, do we really need to move lock_batch_lruvec() to
memcontrol.h? It's currently only used by reset_batch_size().

Thanks,
Qi


