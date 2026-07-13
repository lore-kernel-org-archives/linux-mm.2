Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC32C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3386B0092; Mon, 13 Jul 2026 07:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52D76B0093; Mon, 13 Jul 2026 07:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92306B0095; Mon, 13 Jul 2026 07:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5E506B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:39:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45AB0C016B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:39:10 +0000 (UTC)
X-FDA: 84983557260.27.6221475
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3DE9040003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:39:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BlBOSvqL;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942748;
	b=L9ndNk0bY6YUrUnikO3ljCBv58lBL1yFCJ1ZMmgmbhWbM8hg5DtYlHksxWEusCWvnOwH2i
	yQSyO+DmTN3c3BKX5PZkJFZSNZIoShoyC58Xh7l1WMeo47oJYmhEfLavHEmGerNkpdsEli
	G/uyn36G2neVeAwJL66uu/MlGWxBT8U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BlBOSvqL;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyGrauJ6Z/D7QxLsQH4fnjbmvOpSdbv71QSALvp4E6s=;
	b=PxaVVGzTGyuSdcwxl0GXT4pDBTc9Zd0r46zmwGaUHNY7glzYgpd4czeBuxrhOdnjBxV+rd
	PTIGAMrDcqt5qOTZFAHRoyzB68sm1ARVmfdj6F3+46S/FdnZgEN89LvksGMKomWuKcncwE
	ZyZJ/a/p8rqXJldzaTSmZCLm2hz8IN0=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493b77b150aso25437285e9.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942747; x=1784547547; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SyGrauJ6Z/D7QxLsQH4fnjbmvOpSdbv71QSALvp4E6s=;
        b=BlBOSvqLKfAxu8mL+GG00C8ikjtpEM+eoN9S6It3/5e/8yp2d/5T2gTYmV3ZwMS+Qz
         xQAp4TejQXM1ABBSQSjhH5oksU6huLK5KnmrflSYMa71TddgZp0Cqtc3zPx2UhkdiYXz
         ZXM5gV1jyMFFCw0e/icJqOhSNpcMxXvjuT5NkYJwSnVcc+aMTFsjsX/2CdpYXO7UEFnT
         B4Rp6mSyUHnT9sm0xGHItovGqNM+4X9nTXp1SZKNFVOhWF9sVY8wAhL+8mqJUOEpD/6o
         TGnmX4sJDD1a1X5HS3KcGppa4Um8eeuYechtxl/ybZj+nJZN+HOpNjKsZAPdiL5tHeit
         wcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942747; x=1784547547;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SyGrauJ6Z/D7QxLsQH4fnjbmvOpSdbv71QSALvp4E6s=;
        b=EjEw7oOAGd36znKtrXusndM3/GgK73uCAp+z7zF/pc0vMhn5POn8C7qp2O8uN9OGmq
         e73r9BlAmq/ZTBiU8Xr4QEhcmHNx3cK55qsc0PQeyJ5WY0fPnoL8hb13kXtsG0/QzSkr
         aNl3ezIv7PI9TxuDIHTclG9teo+uWn9JdDa+2H0i6/KCm4JRGrfIzVwQx3Mju0HqJmW1
         2Xg3/Fj2CgfHRDQS3RBdBe8z0Cf6bJ8yU7blRxKopRKPqQtsHJYFkbo9xMkc2gqZREvB
         CUzq75sVqMEIbE3GhuaszdfI9T+PnN/Iv+ryh8dg86MYejLQ8fz7STQKu0yE2/KiyQr5
         WTRg==
X-Forwarded-Encrypted: i=1; AHgh+Rp4C17Ge+q+ZCz5puvdGtsCyJmeY36pWezMhPo347RjFp1ZO27xCSMl1Q4odtSq/TXUt7lkFlsbkA==@kvack.org
X-Gm-Message-State: AOJu0YzrZp73zQjF8GDFhO6tFQfLuuDeb7zMzlRN//NBX/beB+sFoktV
	EGiBvR6OiP2vFSd36uIv5xvwddwmUXLTOjmLl1NFZ4YGGAKhg21FAK8gV6E+RZQe9Gg=
X-Gm-Gg: AfdE7clzdveGJDpHw5lX/B/mjzm3tDEzLubTDWsAlWO278SLPGS9FYY4f/kKZlYmgfF
	aTKmntg+eVtflyNUSRVMACwPxggjQk3cED3Vrufa2id5vYRuibhho2IBTrYWS5HscuR3+ztvBgs
	kAABV7IgFsvhmFM9GbmETJ55UMrWn/g7PCL1o1FqcY9ByEbsh3C60B8Dho1BBNjlj3S92bbBtxr
	J+sirzw2YLiY8O63llwnPqzCmvgMml/RZd9+tjdQNjCyOA4VCxU9mG8tuuX7M9vRhAWSN15+UY2
	VV3UJix72s1G0hNxLJkWWa8gwVcdgtDObzPh9L6UGdegzkYlynvccXHf+l2dIuAQ1TLV8lxoM40
	MmDYXYNtcvSWGZUDh4BTRvc3H4LhPwwDf+hG8mwSDN0sO4F+DAoHwYSpM1rHxjcwoF67pM8XXuO
	5Al5WbuIDwPQ==
X-Received: by 2002:a05:600c:3acf:b0:493:f176:dc69 with SMTP id 5b1f17b1804b1-493f884f5f2mr85117975e9.37.1783942746646;
        Mon, 13 Jul 2026 04:39:06 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6ccdbbsm372032495e9.3.2026.07.13.04.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:39:05 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:39:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: update state_local when flushing NMI
 stats
Message-ID: <20260713113901.GG276793@cmpxchg.org>
References: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3DE9040003
X-Stat-Signature: 8x9kxjjqtgkbzn6tnqh35gsn8a3qbae3
X-HE-Tag: 1783942748-316249
X-HE-Meta: U2FsdGVkX19naYTNWumsNX2v5u5rpj0LSSHd0LfUXRAIuNJrf9FSmVPVD+oaquYu/fAkYPY7S4Ko9xK1m6cbeub+c2HAextXYduFF7Vtj/LN+ElV/WsdHhEzdkZ0qXutJER4pF3QsyN3hFBIk6KZs4Y/K6lEa9UApdS+DJCoDlMsBGlo63+bbaFaV0a1maO/2A6FwUL6/0282bd51pNVugjNKlk4d11QJL0n1QZwiHCHrSg9oaSU6b0ynqxAgLHAJfFa7tSMWhGp6JuJBjPv4TKX/mgfTnjOQjFzGrEWuRp5OcRGcPFw0MAlTSog3tPxieT3cYMzToIem48eR6sUaM9QDU/M0mv6Ztm0QVxV7RFr8D/ixaV+rXO4ZqmN/tgruQgdK7n2/DESypkjsJk6a2ptYNQX/3Tr1+aLIebWvvC7t2o2idp14DIHPi7mwSSCXKuYFcG4KEE9XC6GEbRap4b2AY/sLqR+K5jMgxMrnYr7+dzIi6H49b+0jYeQ7I5kW9hIFvQLSmzaRdzuAXkpCgq6xuQ5PkwxHW7Pk8ssajF8qUffknTT8b1fhi2CibJVudYi+wGz9/Xq4ktjK540IKYwa34x/ff2XZflEYrg+2PpVkVuxZuDaw8or+D9/PNsC5AbGGrR1FXEsV4kSjS2IQS+eSIk1ZGcyf9N5pJ43VxoxR8kQSz0/NDWbb1IkRxpcR4FKChJe++Uso4Mrc+CLC244ikvPf1vN2wbUcP+9fklkkOaLMimhZ16UObboaE/0PsEilHUHo3ArgPNlRJTg3i/Af4gEteE5k5EZCGxMeE/gcXJZYmhWR+DPUODwHtuInu9CeTeGnQfqwH0wT6p8mJisWMympX9gzzaMUv/s8P3AFdLyUeAXAZCE1l1AqxZDj+MvZay27w9HN5dzIGhXInjEJPw3lgwJu5ZZApJ/Gy8vwjQzREbkdfbexYs+dcKaueojJMrUA71asoklfS
 wrVjYFYU
 gsMLPPihpKlCGgpG8+Us7ZVVZNci2DlSkcAsqjwp91yWb728VrPOJ4RVchlifnUGo8EeIUxzhU+kbCpg7rY/e1tmz7gQvAo/x8HsCzyJvzbQRnc2z/8X1L76rIENnupHQvtL83KO7bE3wsA0Z5vxlcFWQQb+zYrYpd+p5HTgHGXEh7w2Le+vvKW7ek3YqKWuAu8NhazfXH02gugz2NFKqs+0nsXD8vbUU8KVxh18QK9lz5LqbQI1b8TGoiqY+9vAGlAY94JUmq/HuuUViiBR4gMSepMR0+fF5JRpm2Svf+H6SQJ22VtHfvAKWzg2lP7YzRrKF93eTcZagS4aoYUluKcLVwAhe3A53HXWl2OJPXHGtnpb4JM5Y+EYE1FLCln9B1M7VhC9+KWkSZ6B36EiURNMpl4rK1Gda7sVtUU7QcKjD3qIYqTnL0bqEjWA4y+aN62WrSDYJRWgm2nO3XxxLgE5RjDujEbYyqkQq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:50:53PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() updates state[] for kmem and slab counters but leaves
> the corresponding state_local[] counters unchanged. Local kmem and
> slab statistics therefore miss updates collected through the NMI-safe
> atomic path.
> 
> Update state_local[] together with state[].
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

This issue affects memcg1 but also the workingset shrinker.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

And we should probably CC: stable # 6.15. Shakeel?

