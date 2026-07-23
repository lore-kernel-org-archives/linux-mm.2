Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4CCC4453A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1ABA6B00A7; Wed, 22 Jul 2026 22:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC246B00AC; Wed, 22 Jul 2026 22:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A0A6B00AD; Wed, 22 Jul 2026 22:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 910B66B00A7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:13:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 218CE140344
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:13:37 +0000 (UTC)
X-FDA: 85018420074.17.E658320
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf31.hostedemail.com (Postfix) with ESMTP id E33402000E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:13:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="YeYK/zMm";
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784772815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63wl+OLSuyt8DrGkM/Vj7SgGoUiR2AzArICs+kt8mlg=;
	b=Q7BKVDi5PfgbTnEaXlryN5xX4mERPZAoiLe+jKZbQwva3utNL/xR6Ph3jS1S3J1zUTG27x
	jus4ddUwdviNQ1pUic/7WNyQR5BaBfmbyzIOG+qdnAkr10YLjCWntH/ZoCpYbXqlwjVxTX
	lrQtM0+AcXuxnXT1g2S7KEN0m+LjwBM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784772815;
	b=sOybFAB7A2QTCANhkkyY8FfP5H4YrTcgiycNI0YDWuOiNOoIeIMKGs9l3pBaOENs+G2kwn
	72FZB7szPZ7BfDcNiCwXdt/tJ/Xqa8s84XCeoZUGnhFMZvZ9lP/pblBoSpHAIXWM1obGJl
	I9JobdQofD/iFkAwNYez2D91EIbsCJU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="YeYK/zMm";
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92f0b5ed131so12371685a.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784772814; x=1785377614; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=63wl+OLSuyt8DrGkM/Vj7SgGoUiR2AzArICs+kt8mlg=;
        b=YeYK/zMm47JGRufHIB0l6T/kVVA2sXLp6hjyasKbKyoxL0zKYFPEsv1rv6D/D0B6eo
         Jwi+6BJ/ANTQkWzr0XjdnYVpRCEYeHOjo18+g2u2Nj1Ewsu/357DKK8EVSThXG5QxEAQ
         eEdlpSgk+tFqMRYdPfA1Y3Hzii92T3/C75wK6F7Cfw0Iwn/a45Gnwefq6Q8XrkJzPyLe
         RrRtmnYsLfNjBrXmBS2KVIvUzjULpc25JmVti1vJi/7IUVpj0E6a2j+JeaGuOCWJwXND
         SchP9E9Fys3rr7YnQWNH2IaThwjnFhsB6PAhfNPBn4WhGOj1rNqU5+0ZVlE4qXqOaHmU
         jQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784772814; x=1785377614;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=63wl+OLSuyt8DrGkM/Vj7SgGoUiR2AzArICs+kt8mlg=;
        b=UCoAdeo84Nn4DGkhdgqv3pVoa0td6QHTZCyKa/CGuGTA7kgCaB6UHTIjKQlzt7aQCl
         EgIBVsLF8bLrp0dtiHfuKPWfT5JeuKoGRuPKi076qkHYF1giyRPt7TXhTWIAwzIKeUr/
         gKcTxZ6FPEOd/gyH1hjIDgLJ1bYDAxwoxMeCbsktiFPsjJVeBZZiQ3R/a5ZEkVmyrEhk
         OObUSS7d61YGErcFc7tO056sIRAXls+UcWvbmuCJnKyQJThJ0UBR2e0QjnwlzOA7ylJ+
         noV71i72DklwtebXo2HBvrAgZ+EExa2IrbQQLJwuN132DcKQpfK+7spzib4IeDY+MuKi
         1Lsw==
X-Forwarded-Encrypted: i=1; AHgh+Rq41xeKHEiXaJpRKaPl3nELb45Z2mKZOvl0xTsskb4NfKXmss8vXxvvSk7EEqAK+5L8sJy6i41LKQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3hJFtC8r8kT29jDaVqJCF906KyAkOajCTOEnBTAMQyqqDPS2q
	3GfrGBHcW17Ml0vJUPp8jiSHat3w52L2vkhTGwWt5hx4FzqqfSa+I6zg867YiC+IVpA=
X-Gm-Gg: AR+sD13jDnxCBSehMaXK9FxyXbtUl9RtyNDAMDjliiSM65Vyf9mIJ/BPSh7TNRJDftF
	DQTq8d8fgayk+ikM+8T0gFtibWhG68gdVelY3IhcIUOIKfiNyoPS2Hxy1/sSPrbeW+JwNyqvOWz
	g9fH64hOuVZmuJou8CxPOvvOGpMHC2KaRaWiMN1HoHd63V6Vz+4u08r+cPBuXR2O+yq6tkZXQre
	q5USHPRH5kEOUIZxJNn4X/dChzRzL2lqhg2Kk9Nzaa0FDHihjCphOOyprgSCcdbkx1NIsLjAekQ
	TqBnDojuTGaQ52P2bu+WJ/RudAHoIRrp0i2PAmJBFtW3DdARD7Xh/Kum4E45zxjyfwcNlh2W5Yo
	6jMThcbg3vyVEt3/DZxtToprZyqMtGBSjXX7MpeEnoOxCJia62QTh6zcZ/u1ncWjiM+6Px5fGRH
	6o
X-Received: by 2002:a05:620a:1726:b0:930:9a5e:bbc3 with SMTP id af79cd13be357-93103aee31bmr115743585a.49.1784772813954;
        Wed, 22 Jul 2026 19:13:33 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-931062c4ea8sm22128285a.28.2026.07.22.19.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 19:13:33 -0700 (PDT)
Date: Wed, 22 Jul 2026 22:13:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev,
	mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com,
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
Message-ID: <amF4yRobGT9x67y3@cmpxchg.org>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-2-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717085151.22822-2-jiahao.kernel@gmail.com>
X-Stat-Signature: ynkusygs1wu3wfsikxsn7krmw67g9uhw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E33402000E
X-HE-Tag: 1784772814-860287
X-HE-Meta: U2FsdGVkX19cawgn7B9z6qgRxP/6xuuPBVGW2x3imZUz3YYRb1H+N5N21dueItzpUxin6QUIYlImHVohCIIgl4P16ve5YL27hskRAxh76VsPK2pXPckAthvniThChk0ETBTIVG4dws3tw5lHLLkuW1UuFruiAEa/EzYNxY3/IUGm7xLD0K66tLOsyNjDgTtrejdVUKWGXY/x1Jj1ny2aznfzG4fj2Z0EMva+W1TbDDT9pOS1Aa6TPPY4YIYb/p1qGeBrmfa2Ubw8drj8hDHeufaqbZQLbAQWsHnlCYYS0IqvzyUcf0lSxcr+DN8XozX72Gkhub+LiXJSv9TsAHqmyb8pD/ypcTGpsuYVKkZq8EhsGwhAhJ7kdUroxP0bTIrhzUTl1Cyzmcya+FH6EhHw9Iq45HOVUHKFgdv8PikqwOt9KNrZC5Yl/9hwhXAH1UAT3wpORxCRKV56OdMJvFkm9FJ3hGbK30cLmDVyjocekFi5VAjDbUcmWQ4HI2lPWbclvAjg59MZWiUFi2X9YDDqZk27LbJ3C5xMNEEPTBbT9SINZv3SMkm0Lcqbr5xcTiJCBjSEk/P4hbjHIjzPHuipKXMDSdC5yAVtIGvPAO1tcmcyFd+WDT9GgabwHJebipI3S+rgKsZLgrT3JZScLZAsHhrNmwsmS3R7mQsZiHPo6eHw5g0luwD4KS5ezLKQxY9YXyKUbbeIXy4122mczV7KZz6kQ3dfNOti0YshkWfGixvURPqBHCsUlhbheCUA72eaRQrl8VcTCSJOjPoelSdof0fHLPLOhZlMZt9Sc/I8Nmo+uHd1AtmE43zK3900X9zc3su9YPvkqr3OUafXctzhrIm/zWlra9y6azMgDxQ8RFjlDYVjuFk2PjCLxeAYrgJukHz0aJs7H2wcmqa9wq8wiB8/4UBXhdpIaPjxNdBFgV5AjTAQ5coJXdW7Fv7YR3FzCXgFQzP4jZbZtiHUrG1
 IXguY+wN
 GP44CMe7MjEd3HFl2bDqQBD2EKR+wCnMyt32u/nFyRFGXrEqdFkVAChRxSIlglNRt20rDv8n0Sa6MmNxxHp44FCAZYX6t2gonGnA5wGdpSXxztmQFzvNASxxrGkORuJAVsFWWqiaslVlNmeIoZ4GGw/mgR/93fXovXoWpnm7IONuMdH6Kul1G6P7S6qwodTjf/yimLzQyzQmfkWKGkduuR9VFJGY9j3piM7DgpF42lG+3QnstDpKOykZo+xTU0ORHhhfWMMUltN9d+Gf27HdBdY+iGLK2GOV5ckiQhrnwotLmm7hU7t5cGmc6q9bi202In9/UyXX/8Nv3yv3o6Msl+EA7stPZolKO3JqFp6ospv2fuQ2Z34B3EiMHSBbKxjTevkRaDkhENwjSf8ZUIIddVOzaHwy1g53lksEw+C5gNEZkqCngg9hsisL7ZkGu4O2x/NELmSbpO1eZ5NFu2gQ2MYRzeMXOuMkEWhmlsTZoonTkdAm7hSGevrz3FpRuean0aXpRROONq1a3XaGVYHfC2onr4ncYep5m1yUjK/xpqyUmTY8pVWduNznJcKNHUf0M6Gxfq5BYwcNgMjmXW1rKP7iB01VozqBiITR85C2ZYceGTQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 04:51:50PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> Zswap writeback on hitting the pool limit is broken when memory cgroup
> is disabled, because mem_cgroup_iter() always returns NULL. Therefore,
> the global shrinker shrink_worker() always takes the !memcg branch.
> After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up, so it
> fails to write back anything.
> 
> Therefore, when memory cgroup is disabled, fall through with the !memcg
> branch and shrink the root memcg directly.
> 
> With memcg disabled, shrink_memcg() only returns -ENOENT when the root
> LRU is empty, which means the total pages are already below thr. In the
> absence of heavy concurrent zswap stores, the loop then safely bails out
> via the zswap_total_pages() <= thr check; otherwise, it will resume
> shrinking the memcg after processing the reschedule check. For any other
> return value from shrink_memcg(), the loop is guaranteed to terminate,
> either after MAX_RECLAIM_RETRIES failures or once the threshold is met.
> 
> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> Cc: stable@vger.kernel.org
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Reported-by: Yosry Ahmed <yosry@kernel.org>
> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

