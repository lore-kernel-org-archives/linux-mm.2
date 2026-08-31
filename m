Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22FB0C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202A76B0088; Mon, 31 Aug 2026 04:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA486B0098; Mon, 31 Aug 2026 04:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2876B00A1; Mon, 31 Aug 2026 04:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD4A46B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:44:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66F8914020B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:44:13 +0000 (UTC)
X-FDA: 85160927586.03.EEF652E
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf09.hostedemail.com (Postfix) with ESMTP id 889EE140003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:44:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cevqBSxQ;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788165851;
	b=JzGlkHN3QEpbvNQaffWELxc6EsXRctM2r2FqocPZvVbm2yqgrem8nd6/Aa8fLdaC36qL6X
	CmqggTVCC+RGspe1PQh5FRvyaAiQe/Fjx8PErcSCZX1XIz2k73V1l4Zk8TuvmVh33E0f84
	d3ICLqabMBheMNMvalspo41lhMe3QgM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cevqBSxQ;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788165851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etMu0VI5+wpQmX7ykhBd022G3QB/fUHBgr7JAI3YPJM=;
	b=Ci1S/DsfF3i9rtUD15MJPz2DiY6rLguYWlnlvK70wCU/cQQrAmW59JAghWVWmxUS4b4B31
	ONgVSRfNqztrSVke7RAuXkai/uUIVNWl9aIv9PB76RwL8mQ3AqRdeJkj5tGFxvZFXyFaFj
	Bt1Ltff8YV4ni8+YOHN7ZJqrLDvEa9A=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788165847; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=etMu0VI5+wpQmX7ykhBd022G3QB/fUHBgr7JAI3YPJM=;
	b=cevqBSxQRajevCQFQ+HdGO4EPC6guL4gROTd6mkT8PBKMewT39P/Wb/Xqszd4qDN4rXu9YUGqJ78+PwSYkrm+ffCsQp877qX4kL1gbZYajT+ituC9IE5CFNRt+IiSdeVny1nGZIIq3Z9eAUBfdJKB4UkAGH+8tYsfandruLw4Po=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9vX2gk_1788165843;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9vX2gk_1788165843 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 16:44:04 +0800
Message-ID: <fc1721d9-aee5-4ffa-96a7-9f9b68ae0871@linux.alibaba.com>
Date: Mon, 31 Aug 2026 16:44:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mglru: make retry logic explicit in
 isolate_folios()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com
References: <20260829074204.45304-1-baohua@kernel.org>
 <20260829074204.45304-3-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260829074204.45304-3-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1j564crhy14cf7daj9u1oc1cqcqyqwqb
X-Rspamd-Queue-Id: 889EE140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788165850-671334
X-HE-Meta: U2FsdGVkX1+398sAZmVhmJcydVK6nHMbxg+1FMYqcoIEWbXu83xtjl88yJK3oHgOyqVwYXGUUM53HVOa+P5JqVqg9S+XRkEdN2fxuOWOu6V1YtlapMA44Mvr4BWSQ0alvA0YEwzctfOSGHVE1ggO4sllR5NVUu9sho5YaklvBlxU3wbIUKvyp1KszQaWVRuAfqg59DKOAK4aHjLKX3brk3Gp80nBoFpMehuDfJrE6qqEs3IrGP/oMqrSE9VZPlzvMAQFMA6eoG2UjL9ROzxhH/5uzOQfWgo2ohJhP3VulVJODe0k9cE86NXDr0PR8/hznH93dQ0zMwh9RsnRqhky1vuLzgLvccKlcyPSq/cQO6edk5l0A6yF4EKNCrmw7ZIiSpOxyFghJKG5pKkjmyt9D2syxDY5P70tCcjAneErJ36eNRtAbZunjPpHlok5Taf1XuDog6kdhVeIp83hXgKDWhaMcVIIVctm0UgG+8z85IPTtDCGT6Quvg4cK4uhkMkg8Vx1eMW1hVsYDcTg/K5QpgQPUfyZsFt/Uv1V28ND9+OC0HJfO2aQdW7uLR6yUFMG5AOPolPjIXVoQOvWtCdTMozY0aPq/2pvcTzZDC/MdJG0GKpjTilB3Pj1ND7tfrdBQBk1PdXMRTmz441IOH2bR1+zWb0ZATf4zQ0EJEZGliLIGi7GII+GNsuC0ibzQtkQevnplJ4TJwPAtnRaGRHrowDb8x7Hqb/GR9S8CUfUjALd45Yp2D0QXtJcLVlJRKswGpDT6YNTWh31SD6mApOAxX9D1GP7g6+e+rfdutbHMQ9ap180ySWVrdg0JJvE2MO23XawjUHkeIScpjklMTCxIplGiuq8qKy0Oo0y2MIgfOetAUCKR8BNEedysbmlvTt01F60ri0OCjoExse5cylY1cGMr6/QYGU+Q5ZN9uBAugoqEG6psHcXWKwd08HA8z7e/eThgo4rC6XUuYFr+qx
 /XDATPOj
 HGh9j5j5xc31h46WB5RH07egvPy2yI/npxYQIbb0fWsEQZLsmDH7jmJp6Ffrr+T3WPaIYXal8eTjHzl8M4rtVvLzSQVmWO3ehVOEPu9KdvfrY7Or0M6dpEzlfU1qExGW5Iw/acqwWeOkR20O1oBhBuhMy4yK8WoMlkrlfOGnFAwBp8TIK1ReaQvRgy59fFWNqh1anGSGbY45oc4f+WYazqn5IzVKO8OiDxtXRxH4vQVeGrldKDjovSwQtIlEYqxCw8/jMqFvGRndU2TizAkD1wbsJRnmIge6mhnoMKEV5vCb0frKnFzTJ6OVxdNY5dgzb5GI4/dDJhlRDPzxTq+f1HQPNA0jCS4HV/kokp64tpvZbe2gvr8HitO24ppyKgUwVarktVHZWgZCa0gEG9ApoJf2m1JOz1EPqQUr6xh40Wcx46bKU33O5Yf02nWbrejQVjg85
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/29/26 3:42 PM, Barry Song (Xiaomi) wrote:
> The existing mainline code retries the same type once in a rather
> subtle way. `for_each_evictable_type()` may provide one more iteration,
> allowing the same type to be retried if we scanned some folios but
> failed to isolate any due to protections, promotions, or races. This
> patch makes the retry behavior explicit.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

