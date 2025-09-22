Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF501CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 03:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED238E0005; Sun, 21 Sep 2025 23:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C54B8E0001; Sun, 21 Sep 2025 23:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001AC8E0005; Sun, 21 Sep 2025 23:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E428A8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:10:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94BE658F52
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:10:01 +0000 (UTC)
X-FDA: 83915407002.20.3ED6709
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf04.hostedemail.com (Postfix) with ESMTP id B68B140005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:09:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="V+p+8mK/";
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758510600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZ2gdkX08ci0+g9mdPNAJE+ZbpX5mtgiwL2vmxSQH40=;
	b=1jVchcNeKiT7At7xBK8/NKYmflse2oQNG0lxiKWpA9WdfjduKfH0jUKc4d2Alw6/kl8CR4
	ZaWzM5Acg9Wd/ZuG2Aq+DXCPnUJwKx9nAsKjxU/AF+pqpgy8fr2B/JWD0gElgE9pH4718w
	kDT63YtjtWpFIpN5Oe4i32LTId+Omb4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758510600; a=rsa-sha256;
	cv=none;
	b=yy67c8lBMMtir5rVeAkez3F+QDFDErIDOwmY3GibkVvIS8c1DFYty1RvFwx45eK6+Sem9e
	doZsVVa4dmaCqE9jU7br0F1fRRsWl2MJQcq2Rf6MzKH0St8z147J7GtmzIP20BLtsPlN37
	7ndTJRVClxXarBmFgSEtTYs4HUV8JuE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="V+p+8mK/";
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758510596; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aZ2gdkX08ci0+g9mdPNAJE+ZbpX5mtgiwL2vmxSQH40=;
	b=V+p+8mK/j8LPRpxJtgVLrkZrcRX8y+wKubpCF1EcU0wEGKQUeqDZtYKPQBSqZhCYmmm7eT1RsKK0Nh9rdWdv1dkiVlczSnH9q9BYA1mqri5HSxtiHe8ayw5tj0TQGwYvbhz23mBYM03pYT1H9JkMPf/xd1REJV8bJzYXGi/1sfU=
Received: from 30.74.144.144(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoR-W6p_1758510594 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Sep 2025 11:09:54 +0800
Message-ID: <58895de6-58e5-4cb5-b2b3-4a66283908a8@linux.alibaba.com>
Date: Mon, 22 Sep 2025 11:09:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: fix too little space for tmpfs only fallback
 4KB
To: Vernon Yang <vernon2gm@gmail.com>
Cc: hughd@google.com, akpm@linux-foundation.org, da.gomez@samsung.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20250908123128.900254-1-vernon2gm@gmail.com>
 <c245dbb5-2e2b-4308-a296-f711b74002eb@linux.alibaba.com>
 <3349E5A6-BCDC-47B9-956B-CB0D0BC02D84@gmail.com>
 <fd0664f4-2ee7-420c-a63c-b4b1c923e1c2@linux.alibaba.com>
 <kh5nq3ycj5neufhmiqetl5vtosictiflk73xyb2fdl2p4txmu3@4ndr7cw4b2j6>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <kh5nq3ycj5neufhmiqetl5vtosictiflk73xyb2fdl2p4txmu3@4ndr7cw4b2j6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B68B140005
X-Stat-Signature: pbi3ibcqgwsj3i9cznec5cap69cduyus
X-Rspam-User: 
X-HE-Tag: 1758510598-932704
X-HE-Meta: U2FsdGVkX1+Pt8XkxBwvxhyZSKKKQVXd9ubt92w6hIunHyawuTfQ7h8TVj3PicYytwhJHFJd9SC1Mw/xXLlmWrRyEVp9R0oAgv8OdWj+9dzNfRlPBpKfupjqgFaq7B91eTHKJyYy+wlwFjR7mKNazVcGMmHH82FcsJIqwZrrcMMwCrbgoV+4LgFteKdHOuUgcoqYbrZJ5n++MWHKm3LggEoF1pCbSpsWZMEDu911L5dPDwTM6XFwWtOjeIzuAFwuqKM5ddw5SeY2CISvV034+RXqCVRPp8FRHmgjUxU4FeWbIIA5RbiRov3M7oZSYLUXMG4LbBRlJTxSU/hAV/JxpCzoTWXgaN0rsvLQunIvXGCZlcgpZvgZ4VKAqDizh0aOGtIFnR5Yy2E4ymdtcOrQ8/q8ERlruRlYVDYDNpVOgKLHjd1kMPtDD3dY6F0xFxirwJLqjxiKuhYyCcIVfyZLRjh9BqE3smkdQglgl80E/ApTcndLnBIrRMcfXDXIh0eJh9e+SLKef2sOATzyGIg/dXM/LQjELfxnjpBGLSz21kT36WSS24WBNeT0VohS03KpyUbAe10yWn52Z1nWqHG6jdMbgSjhg4r1Rn5QIJ4ULYYpNzAoeWFL9aM661MzrQClRpJOEuJGqhFbRdfLJGVKS+NY2wISJMGs1MEgYDmI1ZyRfYhS8X1JQvnVnDCuerAgvaBLJMsh30WtBjIxcy2saKQrfwLOGgf0VSClXd2Dp7vs1jmPbdfiFgN37DJbK7f0Gb8XiBVd21h7+Bc/FcVF4iYWEJK8dQs+34tfJAiJ/OjinTe2yo6lkL5vLb9z1BhCu9E2tGPB7yrOROJbAkuVE5+U4X5gymRQqiKfnY0wMA6dHZ/74VLhqEYuyLv8sYwutD1doPr+ZfiRNDM3Omedvl0+JXtbB/gwChudjTkDoCs3wkDqlKJjCSSQ98TTA2MDxH+tRSNZ7o81CWFwRTD
 0vp7utE7
 cb/ZzFPp20y1ErdCDACD5yfKYIrjJccCvku8wG1auzLwgAkutiJ025j1KzbHpw16i+ys2iN66F1JRFN5sYDXs29nDcv5j6HsC9P/d7mbP2mi/1kxpXA8z+LjGrqdHkr350V/20q0LNkU5aPLYcwgLvD6LDl4YhbGc+vHUnwODvNwokJTdM0UBNsnWZtUgKXnyLSy0ZxLowJRETHTBjHOYIjlrBrGH9mncmKXAOhMEp3pJTTq5t78+HUPG7YZGEvGjqrswtNVmtTBNbiJUE/lzvjFO50vj+UXEy7KumDo7Oa4Y+SwNuDLKU+hzhKpbGbDLL/K4HKtT8KjwNKDPlmvbK/ZYdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/22 10:51, Vernon Yang wrote:
> On Mon, Sep 22, 2025 at 09:46:53AM +0800, Baolin Wang wrote:
>>
>>
>> On 2025/9/9 20:29, Vernon Yang wrote:
>>>
>>>
>>>> On Sep 9, 2025, at 13:58, Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2025/9/8 20:31, Vernon Yang wrote:
>>>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>>> When the system memory is sufficient, allocating memory is always
>>>>> successful, but when tmpfs size is low (e.g. 1MB), it falls back
>>>>> directly from 2MB to 4KB, and other small granularity (8KB ~ 1024KB)
>>>>> will not be tried.
>>>>> Therefore add check whether the remaining space of tmpfs is sufficient
>>>>> for allocation. If there is too little space left, try smaller large
>>>>> folio.
>>>>
>>>> I don't think so.
>>>>
>>>> For a tmpfs mount with 'huge=within_size' and 'size=1M', if you try to write 1M data, it will allocate an order 8 large folio and will not fallback to order 0.
>>>>
>>>> For a tmpfs mount with 'huge=always' and 'size=1M', if you try to write 1M data, it will not completely fallback to order 0 either, instead, it will still allocate some order 1 to order 7 large folios.
>>>>
>>>> I'm not sure if this is your actual user scenario. If your files are small and you are concerned about not getting large folio allocations, I recommend using the 'huge=within_size' mount option.
>>>>
>>>
>>> No, this is not my user scenario.
>>>
>>> Based on your previous patch [1], this scenario can be easily reproduced as
>>> follows.
>>>
>>> $ mount -t tmpfs -o size=1024K,huge=always tmpfs /xxx/test
>>> $ echo hello > /xxx/test/README
>>> $ df -h
>>> tmpfs            1.0M  4.0K 1020K   1% /xxx/test
>>>
>>> The code logic is as follows:
>>>
>>> shmem_get_folio_gfp()
>>>       orders = shmem_allowable_huge_orders()
>>>       shmem_alloc_and_add_folio(orders) return -ENOSPC;
>>>           shmem_alloc_folio() alloc 2MB
>>>           shmem_inode_acct_blocks()
>>>               percpu_counter_limited_add() goto unacct;
>>>           filemap_remove_folio()
>>>       shmem_alloc_and_add_folio(order = 0)
>>>
>>>
>>> As long as the tmpfs remaining space is too little and the system can allocate
>>> memory 2MB, the above path will be triggered.
>>
>> In your scenario, wouldn't allocating 4K be more reasonable? Using a 1M
>> large folio would waste memory. Moreover, if you want to use a large folio,
>> I think you could increase the 'size' mount option. To me, this doesn't seem
>> like a real-world usage scenario, instead it looks more like a contrived
>> test case for a specific situation.
> 
> The previous example is just an easy demo to reproduce, and if someone
> uses this example in the real world, of course the best method is to
> increase the 'size'.
> 
> But the scenario I want to express here is that when the tmpfs space is
> *consumed* to less than 2MB, only 4KB will be allocated, you can imagine
> that when a tmpfs is constantly consumed, but someone is reclaiming or
> freeing memory, causing often tmpfs space to remain in the range of
> [0~2MB), then tmpfs will always only allocate 4KB.

Please increase your 'size' mount option for testing. I don't see why we 
need to add more such logic without a solid reason.

Andrew, please drop this patch.

