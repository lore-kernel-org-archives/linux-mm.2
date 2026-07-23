Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D07EC44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 01:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8216B00A4; Wed, 22 Jul 2026 21:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059246B00A9; Wed, 22 Jul 2026 21:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65006B00AA; Wed, 22 Jul 2026 21:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCDF46B00A4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:21:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A59501C07DF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:21:45 +0000 (UTC)
X-FDA: 85018289370.17.1229D77
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5092C0003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:21:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RgbodzMq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784769703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjWq0EX3NUE2ngLrdLfPnZ0UVshpvVZocotK3ZKx2ZQ=;
	b=fWpLRUYQ0cnPQ9XqtEWh69Hx1tz6RSGbI/3iSsYYW0YD/dwyxXA2Zo7otYDFSLUl4oL1wP
	3B+vl3Qj6Ah1A0I3/Ik2j4i0XIoN7wSqACiNRmRTE3MR+FH5mPgcdpAPFngFM95IWFjYMw
	lwbrQWp595aTPWb0b6O5dGvbEcz6Rak=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RgbodzMq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784769703;
	b=Afc77Og01QMqMSINmdHQO4/vUVe/1aV2tB7WPmFnm0IlQ5J3CoZ8mwNGtclfFwdY13kUxm
	oA7qcZX8QTIuzaSuw/cijjrB2P9owopQDD5p/zVVkLilTtmtsZeCNpfq17ljylEoy6D8np
	nDzH+n0Y6Gdk7Z6b+dCWYUJ7ama7+yA=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so99369a91.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784769703; x=1785374503; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kjWq0EX3NUE2ngLrdLfPnZ0UVshpvVZocotK3ZKx2ZQ=;
        b=RgbodzMqegL2/v0FnKkJFI0UOvv/hZddnPZ3arN8ePGNZh0UkBLmH2v7eyhE2iVabJ
         RJOuAXxOq0eDOSdtjcoGxgGjSAjAGznM32uSXWVEXpUjhlfxu0i7YP5ur3HqbpgYsiYI
         SXOYlHVC9qF9D73NhdE/l17QyVSGhapBSlTRWNKoNVKWHDcdu+HQUisGwbhpLr7Doxa8
         eWtdlog1iE2dHozWmS/ieAN+bn7fFbkBKEaZXsm02QcxvEFSd8Hfk6nhQhbhqkAA6fEn
         YnJjQEUdNi5uPKPdn6tftUmKIYkL5IZKWWuMuaotFq+bulMOXSf6Vus4OnPGsGhjJU1l
         ofJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784769703; x=1785374503;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kjWq0EX3NUE2ngLrdLfPnZ0UVshpvVZocotK3ZKx2ZQ=;
        b=AykHlw/BlInfHLMBPiZA8ZJOARUs2a2kgvuzNsxuUH6p1YE8Au7b0luDwDmHN70A5m
         BzVgcifXpLeyi/UKOoJG71nWGc4dCzvK9cFOOkh3+IGjL5MbfU4EdZSjRSQyjatbpBJL
         lzXsy4euQo7kaSSPZ/1wz2QdxwN9osSF7vU+ETg23hJOO1xsXtlESaPeq6c8M7lkWfJZ
         cvLLONrp/052rynjtHXsYC77ZGq6Q2FlGwstBdZywjfot68eVw1qQQ/VNbqKuiydasMp
         VeB5YoaQzCr2PSuqQM199ZMGC365ZZUI7RxfNLwVf1uM0OOWmxzgbpknIp3t/1jp2YED
         27Yg==
X-Forwarded-Encrypted: i=1; AHgh+RqSjCJFzcvqCb5uuPGjlXGRoNkFBawsk4TniABZDUr773KtJ/gMaBoNAGJCdQO7zEsNLxOBABjwGg==@kvack.org
X-Gm-Message-State: AOJu0Ywdd3kP/dvh6CplV2dnLgCDzPBvws9tzpDl1cniBE5v559J7CWF
	uwLt/28D4eCjpOg54+Jsmao2OGTfi1w5iE3mKSgWwa8SJQWVQTLI7uJI
X-Gm-Gg: AR+sD131bQbe19rygbLz6jJA64PgiTVyr/p869pL0DETzku1t8uNpYyIRGVxho3hCAF
	wNPFlasJpXFIkjMmEAknIO6UNcAcnnutt8PQ45yMdnQbSfsRZrVgrV5FQkWwP+PNjQ8uSqe0z+9
	wzs/o9MI4cLWZ/LXDoOJsvMpkn1ArF5v69owvQbFf6nvXJ0KrWfxPlydbkMBEUf7139Q4q8g+Sg
	cu8zbXwk7+aKK4LWeCWbhQh5OGUDf3ktypYWuxN1LTfWVkdQb9yp4fCGCfGRJLwK1SRPSjdrOY5
	V2DrfilzlIu/596aQBNleG3CmBBduKQQBO4v201f4CsfFVJv2Au68wgUuCHf93JJ8hwKDbJNtvy
	0gVhJlclEdL3WEktgD4Ap05i8jE9/uYiZ22NWTPHmMAqFfIAxoZSS5eTBInzRtjJau5lS8UYhGZ
	WSgSnR0UfYv0eWZatvZ05m+neZAPo=
X-Received: by 2002:a17:90b:5241:b0:383:5a16:bd70 with SMTP id 98e67ed59e1d1-38ec651c1f4mr1027418a91.16.1784769702664;
        Wed, 22 Jul 2026 18:21:42 -0700 (PDT)
Received: from [10.125.192.96] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38ea41f32fasm1418972a91.0.2026.07.22.18.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 18:21:42 -0700 (PDT)
Message-ID: <0a96b7ec-0d8d-2abd-afaa-739c562bc985@gmail.com>
Date: Thu, 23 Jul 2026 09:21:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2 0/2] mm/zswap: Fixes and improves the zswap global
 shrinker
From: Hao Jia <jiahao.kernel@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed
 <yosry@kernel.org>, nphamcs@gmail.com
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev,
 muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
 <CAO9r8zOrXqsEaCEJUUAxbAhhN_OQb8ejogeUa6k8hX_JV8hxxw@mail.gmail.com>
 <20260717214031.8b22e9a37ea3b0c564b466f0@linux-foundation.org>
 <7dbde343-fbbf-6a1d-1785-ebf9f5a04f6b@gmail.com>
In-Reply-To: <7dbde343-fbbf-6a1d-1785-ebf9f5a04f6b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5092C0003
X-Rspam-User: 
X-Stat-Signature: 8a55roiq97qtgf7bfzxnnhcp3u1qzm79
X-HE-Tag: 1784769703-15573
X-HE-Meta: U2FsdGVkX1967JAS3hd21T7KLbHTRuGW2kIsyrANNEnKkghzQnIApmh2U2Jr6FJVx8xYCOmEYV+29JR0A8FtuyXj9Qd5v/VTsoBRPvexc4c5sQl+balHgt4OWbJUilK40Asb82wTcBCZrjadyKThDy9ugMHzQ9fjYod7ZH0Bqy9AbW+pDVX/rNyXYw9LtD/TYtBglKT+gtVPaal2cdgDI1N/iOBurMWKwZo+imz3d7/qzWJk/GPtoQQjty5BZhE7Ew+r5pVkBG5taOdrXfqyum1FDB5sYHESu4Ew6cgBnDtI6HY7yqb+RAh5Gj3qlizPUd0X+a4Eg+yRjKgme5O5qaOdBXUmJjI5zkJTLCyinyWZskpgSEzyvJXbolln4GW5IzV1GwPRwpiDhyvqWhoXhKbtXHatqmSzFLphbbrE5sfelKkcvL3DWtzpp0k13tyGpvTzPT3kDMQJOIUv7COwtRk6yUdUJsYK/P91GAKeGz9+6IoqkyjqGAIwLBwN8nAPl05GpgHcvb5CAhyEmIcLh39KWxm2/AGA43U7MECOr4cEQkkM4GdOc/GQvGiq+ipLyG+wgTyLsb3u3B+t1zi1EE6EjIo8Wls4U1BIRFpmm1XJlx0AXiNuInlOFqV6x/PMzQK++JOBMoTzZw0FTJLA7fLXGNPOLi+sWSqQDEkR44lg3+VgvGvQS4rLAwpq5bb8NWWl85MHnBqzWOM1s9KzUF+4TFljxkGAO6NpvpCjRQtdx6qlnPa91+oMWlMtGThjGQTdl4IP1hrrPv1BWf/lMKoOmm4Oq96U75NS0BpsrnICkhVmT1WrP3wcMWmMnGRfzrA5/si3Q5uCDwvdAfu5IRc5wXGtkh6B+ge1vpaznplBZHJUZPhk+X5mUSWeUpUU3LFdEUW4gjD+jNT9fDnjLUmW8koZI4v2IWpFsa+lBz42cyuH51rF4FmF7mLGAB4Mfh6L4PR7sffVRwv/dCd
 mTqwRlxS
 a3w178Deg30dAFFIWRhfRaFbEdoEzHDd6qNT5/HphFNO/jtuOEpt+ox9ke1qv+giIcEusj2mWD6Q2RsQqmp55nt6daQwo4qFjCHxHiB/+eSrIv98VJ2sQq+/v971GFyw5axPtXNdr7enI0DzckvCRNukpAz/L4wWZdqjeloAo9euPwJVMln03ylZ0L8ac3/azM49TEkqp5GgDWHur4Nmdor9H1clvFsrLe0TOshxYzFw6rdI+sIH62cQThTzxIPAujNYpDo4RszKtyTmvZzbyY2aE/hRZ63dCA1829Z/qXZbqaIkPeb34lMTFNkozRD/ie/AP+L6nm94MI/5eqDVHWVj/as2ydMsdwOSepTRF3AxU+6AelwiE3/I/iRop8xorWByGBXudNywb72ZTD3UirumQyK5jwEiXyrWkZv8ShzUK/EgIpQU16+0Q0ABTV6J8o0xGDau4IO6O2IrrK/3a0pvFbcpMnCLCsvtU9F5IPcRUyzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/20 09:26, Hao Jia wrote:
> 
> 
> On 2026/7/18 12:40, Andrew Morton wrote:
>> On Fri, 17 Jul 2026 18:28:04 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>>
>>>>
>>>> The [1/2] changelog lacks a description of how the flaw impacts users.
>>>> Please describe this fully and maintain that info within the
>>>> changelogging.  This info helps -stable maintainers and others
>>>> understand why we're proposing a backport and helps myself and others
>>>> with timing decisions.
>>>
>>> The first line in the changelog should be sufficient imo: "Zswap
>>> writeback on hitting the pool limit is broken when memory cgroup is
>>> disabled"
>>
>> "broken"?  Perhaps this means "fails to occur".
>>
>> But what is the userspace-visible impact?  IOW, why are we proposing a
>> backport?
>>
> 
> Perhaps the first paragraph of the commit1 message could be modified as 
> follows? I have added a description of the issues that occur without 
> this patch.
> 

Hi Andrew, Yosry, and Nhat,
Any thoughts on this change?

Thanks,
Hao
> Zswap writeback on hitting the pool limit fails to occur when memory 
> cgroup is disabled, because mem_cgroup_iter() always returns NULL. 
> Therefore, the global shrinker shrink_worker() always takes the !memcg 
> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives 
> up, so it fails to write back anything. As a result, once the pool 
> reaches the zswap limit, every subsequent zswap shrink work run is a 
> no-op. This leads to zswap store failures, forcing pages to bypass zswap 
> and be written directly to the backing swap device, which can trigger 
> issues such as LRU inversion.
> 
> 
> Thanks,
> Hao

