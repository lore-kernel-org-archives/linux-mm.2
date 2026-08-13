Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB40C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA936B0261; Thu, 13 Aug 2026 06:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44CC6B026D; Thu, 13 Aug 2026 06:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0CD56B0467; Thu, 13 Aug 2026 06:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 789346B0261
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:00:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA2A0160152
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:00:41 +0000 (UTC)
X-FDA: 85095801882.16.3ADD9A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3E09920006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:00:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxcOvnqT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786615240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6TCyAyinvBPmg6vnO4koIVYOjxW7RfC67mGsAHWs5M=;
	b=isB1QwQYA7a3GutJZXzpHozF65XY73V2z8dLBauWGdgldq3A1QG4SlqsDRdONDv72Gm9/T
	AYwAuGLQnmlcdaGk1DElXK9rdy/sMo//Y+e/7jKriIrKkF3EUSCdgPkLY5KuJwSs6vQCrR
	EezOBMWaaKhiPaN5Gez2UXLwFs9ecBM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxcOvnqT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786615240;
	b=LOFOxV12bQyI68b3WsZdg2cUnC/ARptTRyUuUY5Ucp+Xwg5PrpDoXU0sHOYJwK9GDWA7se
	jIUyv+bzTMtnc5JYKRqQYcvW8+BBNVQMEtmu4Jsq3T/Mims1XdBlKa73+Jj6iACrajRLNp
	LhML1T4iCYyK/ns98WehDYyc5KF8WsE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2F78600B0;
	Thu, 13 Aug 2026 10:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9471F00A3A;
	Thu, 13 Aug 2026 10:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786615239;
	bh=Z6TCyAyinvBPmg6vnO4koIVYOjxW7RfC67mGsAHWs5M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NxcOvnqTLqnucN77/ABpJZAyzChmV2Fi0KnuSgNaUtL4FtePQ3yk+d58dIAGltofZ
	 Dfd/Fh0av3tGTeKX9OydBN5Bj+R5YNfOzC142oLSyP5J5U69MtfW3Yx+T9zpe7L3fm
	 aJhWxlVnp9/UFO2sCbrT4sLwqiZQ4kUtVvrm499OTClhrhujcTKhfgbUGE1LKO490b
	 L6nOOPQS99TvdKGENVdlLz6UlkBVfZ4FhxRjgaPHR32thskI0EYAC6E4Jyq7GotH3Q
	 924JlasleBvAcWDtIghuv7dwqABEXCC60y14aDpcCVLGR8Acdi2AYiBbPpio2pG1xq
	 G4riMK/2ozqiA==
Message-ID: <89837004-b5c9-4b59-b795-3b79005379af@kernel.org>
Date: Thu, 13 Aug 2026 12:00:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
To: Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
 akpm@linux-foundation.org, ljs@kernel.org, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 muchun.song@linux.dev, osalvador@suse.de, chrisl@kernel.org,
 kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, peterx@redhat.com,
 usama.arif@linux.dev, willy@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
 <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
 <DJMS84Y4KYDY.26GNQPOZ6G4L7@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DJMS84Y4KYDY.26GNQPOZ6G4L7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nuek4nsb5tfjbqhsdkfpqfru7rjzz49r
X-Rspamd-Queue-Id: 3E09920006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786615240-336327
X-HE-Meta: U2FsdGVkX1/I6Q8urWtCSwNcsugaO/eBDeUuPW1DM5CMhBZhX/genlDvaayphvD6XJlMCyhOOyI/p2+RDJR9jZen+6gzdnDp7VTWvC3lyqNU8jt7VizzGPJdXYg81+RwSj0EbHsJHV4xpoJIV3mCDyc26TRM5gkeHo7uC9vLDrbSU84MgcQonniW/oBSCrHWBMKvQVsSRJcR0nxHymtEb69zSrR0w4RoEPRzB9Zmywb5xLTfKm/V6zGAc094b4eivH20fKRR7kB1ldMhKRvl9Fegoal4rBcY1KL652hDCYczUowJKusFM0FZv46CMHlTsM6MzdwZKt5465Pk71lehJthVeQrOqJt/fkJr2JHrysN5DzxSM0nxBPUFS+BJLW8pcXBefKAB/ld5AgHvamHm+5b7hGPH7c76uxmfrWv5x2ZZ3OaA/+Piw6oZqJxzBNy6pgiQ4mpd5W97NhOH0VcimACQeN1kfIbBbZFy5R2xNYWJFm8h7akVL5Q1u3+LknUEVfzk6/53UBdZA4mQCzz9BlnLQ6IYkaFyoxnpP9F9OP8UZU+babjeF28yr44fn9gCuoNB6WvpS2J7yqGfVUaO6KjkajJFXjvm2Dbsa+iW4E3dbUxr47yPGeFoyX/kGSCPHb1VZ26VO6t1QDcdeTcNwgtEVqEhwsDx00w7ZGJtPJMxlkxzdEsWRQbHoe2uj71lzb+bJw5aooFKE+n7n6whgNdKY1/ILHExDq3/cedjs23qrXeGylGmGB8h7uASITGJI/ZlqrVi0JC5JVbqLMMg9UGha10MdKoOsVbymFeZrZfmktiV/4x52Ph+Utr/bjwM7ZnDhVX1NmObq0MtWnLqtZQFA17qkODAnH8ERhb/1x3Pi+rUKswJ693JgczaWKNlbYRvr1E1nAbW6OmioxsLmLtjizw4l/zI0XPNlGgeBK9n6F9dSva0GkGcXToDLT7FwHG2iMyz+BL3eajUty
 UV9riI57
 POmpDo8Omp/zQnYW4D2hwt0ddU2ImHX1fCryfilL184D9mBhxrSNR+b8Tu6a6u8onp/uTzlhk58yxWzUIuwANrkja5NQTrUY/VbNrW9m85pup5sDNmxSqS0ybQTCbGv94wl17hC1ChhJKqgjXuNlpivHnH3/s4ZfdZW21MzJnDnEggAhR6JfSJlEVjjiZNd3Uuix5Xll7u4VzKf1O/dnB5f/23nQNxXU3BAUMmcqFrFk2TXB974cq1rTOn07sJlj/e03v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... digging through old mail.

> 
> You mean the reservation should be done via some file handle, like
> memfd, so that it is easy to apply memory policies to determine where
> reserved memory locates?
> 
> For existing hugetlb reservation, there is no fine control, like NUMA,
> or cgroup, of the reserved free memory.
> 
> Is that what you mean above?

I guess, it's all tricky. hugetlb reservation is a mess. We better not make
similar mistakes with THPs.

[...]

>>> 3.6 Remove Hugetlb
>>> ------------------
>>>
>>> Once reserved THP can completely replace the existing functions of hugetlb, we
>>> can gradually remove Hugetlb, leaving only one huge page management system in
>>> the kernel.
>>
>> I'm sorry, but no way this will work in any reasonable timeframe unless you
>> mimic the exact user facing ABI -- and I don't think we'll gain a lot that way.
>>
>> I know, we all like to dream, but this just isn't feasible.
> 
> Based on my understanding, the key takeway is that we want to have more
> control over reserved memory, where to get the free memory, who gets how
> much of the reserved memory, and more.

yes, it's all very complicated. Slapping on some MADV_RESERVED_THP is just
entirely the wrong way to tackle this.

-- 
Cheers,

David

