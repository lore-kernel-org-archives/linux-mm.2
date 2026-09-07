Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E662C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7642B6B00A5; Mon,  7 Sep 2026 02:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BF66B00A6; Mon,  7 Sep 2026 02:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679026B00A7; Mon,  7 Sep 2026 02:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 432236B00A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:27:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB02E1C266E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:27:25 +0000 (UTC)
X-FDA: 85185984450.23.E749F2E
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf21.hostedemail.com (Postfix) with ESMTP id 18D771C0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:27:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V17KH5xX;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788762442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hENVjyqztRMLk2vL/FfYPkshdB/mPunTh4py6EM4dwA=;
	b=csyfiNokm4q3QZ4v7kyw1kjpR9XTxyiE0l9gC55/THMh/w5k3YLY/OF825H1/oBjFzumvf
	/Di/8pYl0sl3MFWDNK/8cLGHI0EZToZK5vzZra8deq/kZREQf29DP5c4RivlRg29zn0TmF
	fw9u/Dhrm8pqFYwRLusNHcYad6qMOn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788762442;
	b=dY4h3FZNBpLhVym0zZIFo6Uu2sq2F3yNvwTq7WwMlgPLf6YKnGG+ba5mPjPpk+5q2q90uo
	R6Gl0VnXspjBEIEJxF2OUFf1aYsU7qeGFc3U8tn+wRm9TjqQd2MtJiN1au+hEMzrwVmX/B
	xpjZc6e2fajtOCSDW3fVmy+hbk9cT7Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V17KH5xX;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788762435; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hENVjyqztRMLk2vL/FfYPkshdB/mPunTh4py6EM4dwA=;
	b=V17KH5xXJ642QFsV/WfCquWMi5w2s5JFaMvDiFEUZOshdg9yjvSrXSD9nRN0azAvr9tBLMpa9h3rA9/hSr/I2BA6+RD9/MLvN9JSGI5yLk0Plnnf2fHGicjUIUbFuyVmgbcBPHVxx6RHpY3JuCoUvg/Gn2ltMaN4XQhX3hcqxSk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XAQ7YRv_1788762429;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAQ7YRv_1788762429 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 14:27:10 +0800
Message-ID: <ecef66b1-f0a9-4a7f-bf52-227dcd69d88f@linux.alibaba.com>
Date: Mon, 7 Sep 2026 14:27:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7Cf2ZjkW0JxtHnm06NECHA0+wCXAxd4tkbtCLhC+qA0ZA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7Cf2ZjkW0JxtHnm06NECHA0+wCXAxd4tkbtCLhC+qA0ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s4skko4wssh4ugm7qwkw1mt3g1ubgze7
X-Rspamd-Queue-Id: 18D771C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788762440-914053
X-HE-Meta: U2FsdGVkX1967DK1c2wIcyZ6F2jeLQ17TaIpUsLJO5nODbPJkPbuAl2a9QWSCnUaiFw98pd9zGqUWB4oxMCP35tJ8NCZ6/fUdb/EHXkfmKvqXUNnj4tG3qS/C1g9m3XMLp9z+VWq9n2NRVnyaOkQVHW846OnLkXCqsKbGS3J8JpFv8C9Fx12O5mel+YTuQjjsEY5Fngq5S9l+FEgt/fK/+R8wcVnK6KEoWExNhL0JiN78PNG78GtEQNwTthtr+5nYENrunf5t7WCCV4k/uZl5/k3NsmqUTgl2qEHwNLy2j7Hn0Fsk2igQ+wbzH6RdaTgMMCemV0phBmsLXjg+taDILlBmXLm59SjPtiJM+E8tRxJk4txSWSNYsZj8LbCvXAZ+QU50tCu6kj7KVA2jGFeAsUZBr2JcXa6Cdwf9TRPnqHnUQrbboe1NT5P3GHhZouadYuXCRSTUw3xpEcpY33OWSIgBMbMJ1I73lnN00YJFFY5eEARWzQSLm8apEnrpT4S1YjafD0fELooC++sSM+AJfSXA8SO/88Zjc63cp6ChbcMd6gBdjVmMkWZ8JxZtGAi+ryOshr+6w+ZbjayIdNccaWC8Yxdvd9ws6VqtYdxkorJTa1PVWMUW3NP6pY1T6XPP40yXiuVjOPIWwjodWbYvkwr+e/7U+lJJJFQa7hOW19Uo9ZTRAu4jCeMVgx+eMn2Pvf7RXRsekfzlMTbQ3XoM7GUeDWkzkNcMl2c5VPGbglNgxhzLY1I8yDDetidda0IYD3/CE/ae+5082NmEEb2Zlfp/BIgbxoYC3AgUcW/sGdhYvc8DhEptx5rdXRrJi/n+NjZkYOWZ/9qL3W+e3K2MxVxcy3JwL3PZEbQ1kF3C9x0P73CCL6MAT1cg7AfLChr9LAMma/DWATcqGBQrs1hqe1N8sCTx/ah3eo7vdSDMksv515dOlqK6P9tnoZi79Y4hwdoa2NJadf7cKZNto4
 3rq6RThW
 oUJWOEolgA+If2zkWYDb4WDFvg6lmOuFYAkksta+UkkIIV5ae0tqE3itS3Je71uRETuIkp2UuGVV00oAptb+3DLiorVYsdhDrCU55Hu2lrIdImw5//v3Hm8G7J/qKaAhtIR0981e3GwxKKiWtv3bycHsKtHwlKAUsJ5bY5OQKqr6j3hck4oKjukcQzbHIXI7xeAkrk5qvvtvUWXZvavAspyEDs/V5qNf6TOvgZZWH52KH3jRtu2VsNZ45ffwu3bx+oyT4JtMACNzljdWvOZ31Nz/FSd29R9dE9auKgwCtB1pjorLHgCm0c3gtR7gGrYvtBsddUIjm7rNjiTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/7/26 12:57 PM, Kairui Song wrote:
> On Mon, Sep 7, 2026 at 11:29 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
>> a new generation, LRU_REFS_FLAGS should be cleared so that the reference
>> counter can start over.
>>
>> For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
>> set the PG_active flag if the rejected folio is planned to be put back to
>> the oldest generation. That's fine.
>>
>> But for those that are not put back to the oldest generation (which can
>> be treated as a promotion), we do not clear LRU_REFS_FLAGS, which can
>> violate the promotion mechanism. This means the rejected folio enters the
>> new generation with stale, inflated tier bits, which can inflate reference
>> counts and distort eviction statistics for these rejected folios.
>>
>> Fix this by clearing LRU_REFS_FLAGS for rejected folios, and also do some
>> measurement. On my 32-core Arm machine, with the memcg limit set to 3G,
>> running 'make -j32' to build the kernel showed a small improvement in sys
>> time when using either a zram or NVMe swap device (averaged over 2 runs with
>> no significant variance).
>>
>> zram swap:
>>                  w/o patch       w/ patch
>> sys time:       1666.5s         1589.5s
>>
>> NVMe swap:
>>                  w/o patch       w/patch
>> sys time:       760s            741.5s
> 
> Hi Baolin,
> 
> Thanks for the patch, it makes sense and I like the idea!

Thanks for taking a look.

> However, I find it interesting that your test setup shows such a
> significant benefit with several recent changes when I can't observe a
> performance gain on any of my setups. I'm a bit worried this (not only
> this patch) might be overfitting into to the kernel build test on
> specific setups.
> 
> I did try this optimization before and found no gain, maybe it is
> somehow tangled with some other recent upstream changes?

Probably.

> 
> For example a few recently landed MGLRU optimizations sped up the ZRAM
> kernel build test on your setup, but slowed down many other cases.

I'm not sure if there are other hardware environment differences. I 
agree that for complex changes or optimizations, we need to cover more 
test cases than just the kernel build workload, such as the test 
coverage in your MGLRU-FG work.

However, for the current patch, I think it's more about correcting the 
correctness of the promotion mechanism, and the goal is not merely 
performance optimization. If we stack more changes on top of the current 
broken mechanism, I'm afraid future optimizations will become more 
fragile. So let's first reach agreement on the underlying promotion 
mechanism.

Also, as I replied to Barry, the promotion in lru_gen_set_refs() needs 
to be reconsidered as well. It similarly requires clearing reference 
counters before promotion.

So for this simple mechanism correction, I only evaluated the kernel 
build (which is still somewhat representative as a comprehensive 
workload) and it did not introduce a regression (which is fortunate). I 
wouldn't want any workload to rely on this incorrect logic for 
performance gains.

> I still think this is mergable, but before that, do you have the
> LRU_REFS_WIDTH data from your kernel build? Or lru_gen_full output? In
> some cases it shrinks to only 1 or 0 bits, leading to very different
> performance readings.

The LRU_REFS_WIDTH is always 2 on my setup.

