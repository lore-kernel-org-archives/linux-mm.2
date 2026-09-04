Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0C4DC624DB
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 01:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484E46B0088; Thu,  3 Sep 2026 21:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E976B008A; Thu,  3 Sep 2026 21:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFED6B008C; Thu,  3 Sep 2026 21:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE9046B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:53:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58D89C0702
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:53:32 +0000 (UTC)
X-FDA: 85174407864.10.76C1159
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 342C420006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:53:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kNf3pl2d;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788486810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGWPUgjmVUxtTSwlUvNg2bFsyeXOB8dJnjZI+3J1JLk=;
	b=CAVQgqGHWz1jM6tN0NJXOAw09qRMCxOBePmMEs3HlEo/kngTfJTttN1gqAKNFfZN4ojXi2
	1TfOGll1gseoseOuFxIkxQmDLqljKTgAeChgz8pt/36/wogFBPYmdPnDQn1EWyfuR1rjP9
	Z+zTb2afP0A97d76FgNHKRMYlZJ7E1s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kNf3pl2d;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788486810;
	b=ysWzOlIAwX+knpE7gb5Qp3IYOlrxIu5PC7r/1Mx2JB1Kdc47yS955m+mKyz3J+PRZZzmQe
	gSzkRepou0XCapWWD4DFXy4AAKUdKh76f3/n8jVcbFsjKlKmUCRW+/Lvn6kC8cEgMR3OBs
	1IT7TaW5FmX9qPG5TxmUJQjUvOnXyYI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788486806; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MGWPUgjmVUxtTSwlUvNg2bFsyeXOB8dJnjZI+3J1JLk=;
	b=kNf3pl2dsTWZsvt4P/O2Q9c3qguQp3iLnUyPVBltnq5C6oOXQLd2Yue5jp4YJX0gddFrmz07ft5GGoWiRmVNyUAyqtrCTZNstAGWA4s1qKbgeZsohtqFcLXG2nSdm7wxn6WNTNYu4GwaAYxscoeyp1eY3msOszMog96mbMGN98Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XAH6eEv_1788486804;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAH6eEv_1788486804 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 09:53:24 +0800
Message-ID: <c1992315-8e2a-45eb-a042-29f1f1725f76@linux.alibaba.com>
Date: Fri, 4 Sep 2026 09:53:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] mm/mglru: move folios from oldest gen to
 second-oldest gen from head to tail
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <20260901232421.40157-1-baohua@kernel.org>
 <20260901232421.40157-7-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260901232421.40157-7-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f4d1ren4eei77hwshefc4sqquk4azszb
X-Rspamd-Queue-Id: 342C420006
X-HE-Tag: 1788486808-749906
X-HE-Meta: U2FsdGVkX1+AgJ7LgPkejtEfBUZuDUYwzV+KjaYoYnTDsANly1xBibRzoEjIBCvnfpohRx4GAcQ8wJvx4TIZeLadtcZhgaAgl2LN0vouYwsBSsCe4Qk1TlrWhXL+7SyXyolCY8GSySFmHJ04+Ba5K1GPjTU1GeA9fpCF6fjhDTM4CfwyIybfTMD8GCSzDYEKRXyUncwCcc0jLLnxZKAbNaHEA5QmA0lBk5k3DQpfFbaheD5yrpOCQYXppV8ergmA10rJhRInDQDMcAuOlgzU6/W80gFOLVjrSpBl4CidES7uxuoDJh6egGO3FlPxWk8EBZ6+1dd8uxBhxtnIQy7YrRk3634tkp+PUyN1wkHTWnrNa9yHYEZUFJLsD0s9icYUIl/VzLTdsYOLu7j79Yr3I9N3JEO6819MBVfdMeR8X7DIF+pcgK3GP/ON2OrN+el/dPF5jp5F8n2IHTKZLHLAFm3DnCYkpIsqWkuL1Ph4Ig3EOM1xFVYCc1YXuShNe/gEnqTvuKNl3o2cW3WpSyvv97KhZXyqws4w5LoslogOyJRaXBMwISspCl/8AVcyXF7e/mSX4uj/rAcrkAJryRPu5KIXUPUkpDoayrEiKa4bEvIBYfjv0UkzLTbqD1MQxkmdY1H+YMDvnz7bz4ATb/Hoh8Lp9sLLpabWEs/+jBVWcyBjJzkQFj0tuT38TqvGObgiwc7Zd6NPwCZ/G7JDh0RzEaHRO9+YoWzjFkc7BBntKsi51oUkDQ2jMle1cKE6tU9li10GRY0ZOu/nNDLkujag5lbj7uGKYw1HS6Boh5TNAHvkgZ7T0AYgLN4S6IQ7sjIcoHv7K7CnWMg2THFUyrRFhFhnecIOSA3SV5ZWQUDg2C1dK79WSpQR/TIFy/YyzERE3ttIDmvI6ilxJl53xk5yaud8MHomH14vB570/6nQcy6Oaj6WW63GqbAkOoaKmPTbppegQ4nrvl5i6sndTNo
 BOqmYf+T
 wqAIQikdL8L+xOAQzuUAMbIxx76rH7Vf4ZSalr2F0kURSUcG6Px9qJOt0k8el8eS4/tvGxSkqEYKlmwWfAb44ABU5sQPAIsvXAmZOlQnvx11DWWfGn4K7AeQacNReorItWhqSJAf3AxNNaWlZsO2UGaC14Z/37dGqE7VD1ms0xp6+6B149oJwu1+bCKu3mHaMaFJ4qaEauti1/BMYGgFr1GfOwl32eQDk3D9bJpEfwPGxy7Wgl1/z0V/7gEDO9phBPLJBFfhPsjlShJXdhUzODaAW2ThKv7o4nCYKTFf7rqldyRYe8ndTR94TD/5Zv2ugqGmR+NcyHcf5TnVxQcJp6x1LVOwx7Ux8kxf0p8nqqVOLqETeqQvL3DdEQDH4dfqNvNqHxdnbD51Q4UQtsmXgJfCqLTypQIot3kElNidjfTxzYIx5+RRqDEqlQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
> For reclamation, it makes sense to reclaim folios from tail to
> head, as folios near the head are relatively hot. However, when
> moving folios from the oldest generation to the second-oldest
> generation, using the tail-to-head order would effectively cause
> a cold/hot inversion.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> ---
>   mm/vmscan.c | 23 +++++++++++++++++++++--
>   1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1907a946840d..76dfa9575852 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_folio(struct folio *folio,
>   		prefetchw(&prev->flags);
>   	}
>   }
> +
> +static inline void prefetchw_next_lru_folio(struct folio *folio,
> +		struct list_head *base)
> +{
> +	if (folio->lru.next != base) {
> +		struct folio *next;
> +
> +		next = list_entry(folio->lru.next, struct folio, lru);
> +		prefetchw(&next->flags);
> +	}
> +}

You did not mention in the commit message why this prefetch was added. 
Just curious, does it really help performance?

