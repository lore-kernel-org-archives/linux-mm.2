Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0FD6C44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B3D6B0005; Wed, 21 Jan 2026 04:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8CC6B0088; Wed, 21 Jan 2026 04:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB8B6B0089; Wed, 21 Jan 2026 04:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE10B6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:26:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57BD31A08D8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:26:04 +0000 (UTC)
X-FDA: 84355439448.19.BEC65B6
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 67B644000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:26:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cANjJVKg;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768987562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TUVbXynyLiYQadP11oFngQdXW1RS17OiZEoFg4sbNI=;
	b=Pqoi0lrVd+N7HaRtS0i7LmdPkTmadUbCpMgzy3ZiXnBG3AeVF7hXQ9u30bbbBvEdhUZVQP
	8xhPwpbQHFMOUV79JVv19tfHiisrH8ysFi+aG4oJdEv+kQ+BkaYch0dMhAlrimXriGyM5Z
	RDmIq79hMOB1YN7eB+soUDTlZMurSt0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cANjJVKg;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768987562; a=rsa-sha256;
	cv=none;
	b=TI/gc6Dc2+P2Pir817qEVHkdoKcTie/gT01IhW5tS5T6dxxGMShi4mWUpOVz5bR2U63L2t
	aMy6t2ZBFQSSbJ+K/IkzFjg0ZHGdNGuAl5vExv9BAKymqQHL0rU1fmglWNIJ0TSo1jPC0P
	7Bujv4RIRfGq3hiUehLxwvHRbhfBDvY=
Message-ID: <ada6d430-fe18-4db7-aa1b-96a03f7af37b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768987559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0TUVbXynyLiYQadP11oFngQdXW1RS17OiZEoFg4sbNI=;
	b=cANjJVKg9+YX4wbUw7+xxjGI+2kHi0RBTQw2PT1VqgYo3aPEHbwW+2SXNAEk64x/Yex66c
	zNc5XiHbmwRUUuy2TiSVwfDKt96ZVv/3Nb22ZIe4SJb2EFeLGDhoSCK1i2qoMvK/oyjbeV
	7d/31LQqqiwjELibZP/1vC9YlsFi8tw=
Date: Wed, 21 Jan 2026 17:25:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: Fix iterator variable usage after swap()
To: zenghongling <zenghongling@kylinos.cn>, Qi Zheng <qi.zheng@linux.dev>,
 Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, dev.jain@arm.com, akpm@linux-foundation.org,
 ryan.roberts@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 linux-kernel@vger.kernel.org, baohua@kernel.org, Liam.Howlett@oracle.com,
 zhongling0719@126.com, ziy@nvidia.com, david@kernel.org,
 lorenzo.stoakes@oracle.com
References: <20260121081343.713715-1-zenghongling@kylinos.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260121081343.713715-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 67B644000D
X-Stat-Signature: yq6u37dqbmr5akhogk8u4frdf1q355uc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag: 1768987562-527144
X-HE-Meta: U2FsdGVkX19cLjq/yWz0Gik+eqqnGCWzCmU2i8XSR/2tsoGHZU9XzWjtsM6Fp3jbkSXLfJ6laYjy7BjXqVQ4BtsVjf02k5BYxFZ4Rpuwt0f0gFV4a+RTXkpvITx6GcuZ81kOXJ8E62W2lx4oDzraClEEGGl4R0nj3uteTUqPZQLG1A++I4MQY4PrYG4UTvawnfT+vP4DIysqETZKZIuXqS5CMrYtvLfoQY54A69dGKrlxLsA8z0eZ4rch7wKF4lNdYaiGhepjd4to6fQVIRrA6TUjf9nqkhklPvakVdE5S/0A9aSxnTQhYkx6MUyduZzFMcMScsPDew/RDlbVZfhmiC7Qs9qYUJE+dsWnf/ytGBCgGcrGnS4Lp532F4JWAXCJW1yKuE8hnfzxdrapCHIzMcpj2/dWcgmlRBsMSad5b3c8vJdMzI6UyUVzBHW49UPGOh2t6/4EO9vltzNe3M/iugFdR9mtApSxnlN4DlTKZYy6B+tL2oY5lWP4ToHPGCmQWZNpAe7XG0n7eYCi98ByQx69NcbHqFiwr1aPGSvLVtXUxqjYWs0ufdANX/h0mtOT1ENwNovhU+4bf9BzrrzCTXE+9HlMUaLEsIPLUceXxtpJvRvVegouSjE9ll5VsCAJmv96hWXz0Amra5DOK6DQEO89doYqfLmBCn2E+wYFIU4NzQh40BFSRUHFOv44mXVLWvmWXqxO+lgqcDADZKwtygkXSWbFxU6gIKZLoeUnntL/x9uQCYbafaW5xjISxcMamkVkB5g1kyQylD9zCtwitPHgk0KfrGOYhjZkBIGnALXlmTJ+Np7qmKVyzo4Bn3XPXH/uB9OWJ3QhdPanufXDj5Q/TmWlkKXZJrWJNa6nmzd5uiRj0lp66dAqX6gU5UmKjKVZ4N0quqemptG1SfrYMSJP0cHuCHBk2PFVe1SwHd2tUjKx1zcoAxp6Qfzj9kb2fWklRBRHwGVLg8QVP1
 wjK/8c80
 JklgQ3sSkghfOUabtat6juR47p6y1+M5m2/323E2HqJJ3+fKJQjteR+DEPTX67J1btKjNiR3kYxwjhcs/mVm5B3TZIQZiHtx8I2K2CFFdXWY38KmxxBrMQnr+D7FDvgCKlghUVtySzMwZMq+S7TuRQmJBjFIEeY4PGE+cTosLc71Wc6niSB9eTL1YHhVmoomp9HFK2/4P3gRUWCsR3RpH5OuuAXdgva42cINHyCB+047U4giPkibwvR6lwCffolbFqrznW2ec+p0RCc8dFQ0IUpHJ/H487tE/fuCsDWEcm7pB24k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/21 16:13, zenghongling wrote:
> The iterator variable 'folio' is swapped with 'prev' in the else
> branch. Using 'folio' after swap() checks the potentially NULL
> 'prev' value, not the original iterator value.
> 
> Fix by moving folio_put() call before the swap operation in the
> path where swap() occurs.
> 
> Found by:
> ./huge_memory.c:4225:6-11: ERROR: iterator variable bound on line 4178 cannot be NULL

Good catch!

But which tree is your patch based on?

Seems like that was already fixed in commit 776bde7caf80[1]. The
whole thing deferred_split_scan() was refactored using folio_batch,
so the buggy code with swap(folio, prev) is gone ...

Ccing Muchun and Qi who fixed that.

[1] 
https://lore.kernel.org/all/59cb6b6fb5ffcff9d23b81890b252960139ad8e7.1762762324.git.zhengqi.arch@bytedance.com/

Thanks,
Lance

> 
> Signed-off-by: zenghongling <zenghongling@kylinos.cn>
> ---
>   mm/huge_memory.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6cba1cb14b23..258bf4725aea 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4212,6 +4212,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   			; /* folio already removed from list */
>   		} else if (!folio_test_partially_mapped(folio)) {
>   			list_del_init(&folio->_deferred_list);
> +			folio_put(folio);
>   			removed++;
>   		} else {
>   			/*
> @@ -4220,10 +4221,9 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   			 * left on the list (which may be concurrently unqueued)
>   			 * by one safe folio with refcount still raised.
>   			 */
> +			folio_put(folio);
>   			swap(folio, prev);
>   		}
> -		if (folio)
> -			folio_put(folio);
>   	}
>   
>   	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);


