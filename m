Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE6BCCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 02:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258C28E0008; Fri,  3 Oct 2025 22:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2307F8E0002; Fri,  3 Oct 2025 22:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D278E0008; Fri,  3 Oct 2025 22:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 067028E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:13:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A563A45415
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:13:28 +0000 (UTC)
X-FDA: 83958810096.20.A261A3C
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id A469F4000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:13:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aOp5kZPR;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759544006;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJLGML/fAE3TNb3uOnRyVtfPhEJ/kKcyWW/gv7o0MK0=;
	b=ApOlkUNsHYFpYDQyqufgCByH9LqnlbCTyjxMhgxNh4E7KdGPHypG+pY9C98ARv1+YgeWwh
	6qyxoPL+/Oo5KziGerqM3wUBKHjm1BNpJlQ/S7WDqTkt7nNo8sC+lPu6c0TPlk7dh7lgjU
	2ze8g/3Wi/j68KMDm/BXPOl5U0l45pE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759544006; a=rsa-sha256;
	cv=none;
	b=EAfsmYFTt61srNzukAq5IrydinlrAzMMPGm9mb489xq2ll6G3ahR9mEIQwWC9sZT/IYi0p
	iQ4M1A0f+ZB54VgeFUBALgbUlsxK8Oi4DoaGLpjbabI5UvVgbYMOta8l4sQAdC022LFopu
	FTgwjwXEa6WimmDxFHYRSL86xI2z9OA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aOp5kZPR;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b48d8deafaeso567601266b.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 19:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759544005; x=1760148805; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJLGML/fAE3TNb3uOnRyVtfPhEJ/kKcyWW/gv7o0MK0=;
        b=aOp5kZPRYdHCWZbQaxocuj3sD3nalP1zFQxAHVVQqt2TUX8U2UQQD1FZ0o9yKBz9w6
         YzttAOXZS7yj0Jl6OtSUAMoumddaOzWzSHh6pA8kqiF/zhHvevxKH8eJA4pg87t4v5Oo
         sIFeW5c/fmVcu+4xAeYR3cxJYQ9pHu0ZSbFiQQSzuWfYCGo/sbDOW3bgtYPGJhcv++1+
         mErmgzvfIQyqKBMnm1QoKdu3+6O4w1nmKhb4KvggSXdf7AC0f76FGs84ODHEdW+JzKRn
         07Hf/gSJH0Y7DnogMj6m0LkFYdK+tC8QOMAeyg2fdtGUrdXx6b5Zjy8xDa5m6Wq37pEv
         p6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759544005; x=1760148805;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EJLGML/fAE3TNb3uOnRyVtfPhEJ/kKcyWW/gv7o0MK0=;
        b=vQ5+u5+G0Io7uqDa6og2bU9BaGYJxlbIJusK3YbTULvfkirwdMBW9bkV+pa0wzM4je
         FrkcFMoB4OfsuD6ZRLTk2aoLUqC54tISWtqMj0a1h2wWjahZJ6Wdm1tFmD/HOo46hPIN
         EJxOf2D8f3rVjKe7bPB+FityiJnzSmT51JMv8x6DzUjvn9Vs68HvaESDctqhKcOptcYN
         gzvMwZ8DYURC/Mr2ZXwW3Y/aXHt06LjEnme96mnIxZxu3wcY4Sc6+t3bgBbBDgXPmGBS
         22OYA82r6WtzT6GJpV/LljHn5yxmPm6YYEYeT5MjXnUYVCROeRpv5jmBrXQwfOrIB7BZ
         iy2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUl1fgFX1mgjzxq9Ab8QqRPwpiM8Nfq0Z0517xQMavlVOzhgv8Iuqu5lV24ANzhDMeVB7XDrthgXg==@kvack.org
X-Gm-Message-State: AOJu0Ywl6dUsm6ch6s702KY7rs+Bf/xx+fVZAXiDqHBRAZyBdcEhujoU
	N/+i0JwqYyFDzyOh7Mga7x7/9AonJFHVLr70kgPCOkQXnX3b9sTIQpl5
X-Gm-Gg: ASbGncudazkh1Nd85fpnV6UJ8qfBjZpZ4OQHXdZQiNRjHZrJ+njhFsA35mg3ZhBVApB
	edb2JkAZ8aTeKDNa34Y7EdJOOZlH/CsRoWQsDtkJFxTBeD7YTVnJN2LqPtIxF6I6bZ/TaQp2aDq
	lcHcQlktQIAQS93hEX2bILex1pnwkUa3LM2btzQO+e+vl8jEGI1kzKROT3K2+BCfrrrkOFqQr8D
	VaRB/31FRk/nqyyXJL7RVroH0mlAz2tDFeFL89e1CEKVnvhHzJsndEo7fM+xg7G9SOv17MRFWaC
	7F96zd7AS9WIXAgdpKlNcT3l5iNh5WpNwgrpanZogXBQDOP0D7OieSL+I46vzVhOLkuUazEjJ2B
	q32PW9EopjRKJrqEr7TCg+p7eqvX5e4RcqbL4rkT1zOB+jpx1AgL6xc82
X-Google-Smtp-Source: AGHT+IH6Q3EMy72+qe0t0hsQggbLgNWiTJAlAWog89Yxth2YTCEdR/jsq63Jce8LF6RMeQgMSpj70A==
X-Received: by 2002:a17:907:3f9f:b0:b3e:fe8f:764 with SMTP id a640c23a62f3a-b49c47abb5dmr658409766b.32.1759544004993;
        Fri, 03 Oct 2025 19:13:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4865e77427sm569595766b.36.2025.10.03.19.13.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Oct 2025 19:13:24 -0700 (PDT)
Date: Sat, 4 Oct 2025 02:13:24 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usamaarif642@gmail.com>, Lance Yang <lance.yang@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, wangkefeng.wang@huawei.com,
	stable@vger.kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
	npache@redhat.com, baohua@kernel.org, akpm@linux-foundation.org,
	david@redhat.com
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Message-ID: <20251004021324.t2mysqcblqvwa4bv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
 <1286D3DE-8F53-4B64-840F-A598B130DF13@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286D3DE-8F53-4B64-840F-A598B130DF13@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: A469F4000C
X-Stat-Signature: wutsigo9cpyjk7igkcwhykqmzxfbs5dm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759544006-561326
X-HE-Meta: U2FsdGVkX18jFzkr4rdA5phpeKZF2NFpB1z0nPpN4kDKiA7s9tWaIAGOPzksnHELtValKq7oidrZdVUdlVuWnd/Qzn8Cdhdh3As9loJvNY3M06TbBjEyw5UVETof0Po7JQvXGEHVbkCPNaKodj9zIMUHM7wMoKFKAsSSfWvMPTrZ2HvrHP/dd20qCBo05DAVCzaE5yfEi7JQjH8YbkXmogdp1Gjbqfe0oUDo3SiQzrZwOHBR1ijsU38P433bKCjzwf7+mUSd+c9tsVUlux+tz+bmm9pxYQE3Xfg5uGQ2FUZKVQGuztzZpdZwaiIUiVjwu9LbNsy1e9mTr2wQTj47xX3ObnT6J5BYlINV64KZB6NxnOotrSOROoM8OqLQpGB+hbj20DMlT+NWhGnMh/prvDtfjTiWNfqa4gpbr1BieRVuYUn7yxgKGeCj8xO5C1jk/1B29+/bmgBY42lW/DcGLfEjVf5iGx3pMoFzxQlNKwWR4QfcKO+Tk+xokC5d5x5rqlmJQLdF41jWqZq/DgLdXb9+N28zYWrW5O6UGA2wsLPNLcEjNdQ2+/7AThlFd4x/OdD1dgBJyruTpuDduR16ZpKD7X/hUbCTWqKGfmQNuBoFyNvQELBygNOF8qH+SahKJ2fCXMy55fpakFRZYHYlRUpUU/AgGArtP+qRXNdExntHEOOd31RO+3W6L0ag18bHYH6WXenephGIVaAaGg0cF0QOPycTBSpQnhimzdn7WhOcaRK0pYMueGlE6OKSmSL8lvD/4hwj8lq1zk6FXSFOtiJ78hLR1PEM94YYJdHg3cTIqdtAai0ehBV+xZ9NJ0hUWOK/fCymHCFdHVI3+zRPtZsMa3pr9LzbjZLJudgzRmugDXL5vGIZA8c01LzMvbGu9dEShMOaUy5R1avDmDmxdALJZB/5aHvkp/CbiwqY2zCwvEZY71j3ONpFuru5WKZX+R/HQz17EwIrCvvOZ/w
 uqJG5H9c
 c3TLeLuuktM5NyUp6ph9U36VcWEMT/m542jAOhe6QLM+eRVE4WkcdKmGHzowwUnSReFBtFyrSbBOrkxzXiZNP0Bg7776RiNiUD8uOhwY5mNX8zKIpXezf4R1+sCPk+t8tQ8Oy/c4/e4A97LvFoVxUL4UQMU58ct8q+8cKXv6cyzp2eIiHWTvz1m//w3iy1ONODy00yNLxm5H1gtmgVRbNmOwDOirSe1nYjTegOMsy52R/EGGCkIgejXfGpJXdHR197mJhglk2EpvruMhmzCYIddgOwo8JzN8KmV4bH6YYoQe584AeYYLu4Jq7X9h0f/sLcEuKZuaVab+sPlqIxpxI6urb0OuZIaW/K1UnVimiq8Ods96LKJv5ZlFO0wShbeIe4Ujy3bQ671R0/7C5Kk+gaOeIDa76z0qhN8vWGCKoq65oWLQpPCFpnYAJ78A3YzA1w7fMkNhel8jaWtcY4tOythj6RFKIkn4Hbnul2iV0Qw4vzd6SQKv85twxONhfiv9E6KHb1F+fYihrAtJa+G80P/kxARJTuJBWnCOZjC5Xn/bugPc6o2DPIZpD/1D6WCfEXF0UPc1QyDXbtLOA3Fm6hqu22+QAe7b2d/YCn9H0gMFFdvxL9Gl9uTov3K27k/k9lfTUnI+v9EXc+Lhb5w4ZmY/jJw0A2foa1aY5XMZMv4v5yvpoIPEtpbGoE61wzB3CAuNMFhiw0l4MTVyVCJYL1PBki/Kp4MiTwnQiihKA1mSvljc5WN+H3Ty7zxzoSXOc/3Ya
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 10:08:37AM -0400, Zi Yan wrote:
>On 3 Oct 2025, at 9:49, Lance Yang wrote:
>
>> Hey Wei,
>>
>> On 2025/10/2 09:38, Wei Yang wrote:
>>> We add pmd folio into ds_queue on the first page fault in
>>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>>> memory pressure. This should be the same for a pmd folio during wp
>>> page fault.
>>>
>>> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
>>> to add it to ds_queue, which means system may not reclaim enough memory
>>
>> IIRC, it was commit dafff3f4c850 ("mm: split underused THPs") that
>> started unconditionally adding all new anon THPs to _deferred_list :)
>>
>>> in case of memory pressure even the pmd folio is under used.
>>>
>>> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>>> folio installation consistent.
>>>
>>> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
>>
>> Shouldn't this rather be the following?
>>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>
>Yes, I agree. In this case, this patch looks more like an optimization
>for split underused THPs.
>
>One observation on this change is that right after zero pmd wp, the
>deferred split queue could be scanned, the newly added pmd folio will
>split since it is all zero except one subpage. This means we probably
>should allocate a base folio for zero pmd wp and map the rest to zero
>page at the beginning if split underused THP is enabled to avoid
>this long trip. The downside is that user app cannot get a pmd folio
>if it is intended to write data into the entire folio.

Thanks for raising this.

IMHO, we could face the similar situation in __do_huge_pmd_anonymous_page().
If my understanding is correct, the allocated folio is zeroed and we don't
have idea how user would write data to it.

Since shrinker is active when memory is low, maybe vma_alloc_anon_folio_pmd()
has told use current status of the memory. If it does get a pmd folio, we are
probably having enough memory in the system.

>
>Usama might be able to give some insight here.
>

-- 
Wei Yang
Help you, Help me

