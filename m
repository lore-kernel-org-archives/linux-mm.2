Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB58DC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F786B0088; Thu, 27 Aug 2026 04:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0496B008A; Thu, 27 Aug 2026 04:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBEE6B0096; Thu, 27 Aug 2026 04:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4376B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:09:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AD64A2E1C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:09:17 +0000 (UTC)
X-FDA: 85146324354.08.EAD3D47
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3E414100008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:09:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="b/Jw30FJ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787818155;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sL2OyFqHiwHA+nDxyBcNBcYoIZso16H9hpW7CuWjgtQ=;
	b=te9Hg4a8JtR+8GLv5fRqOMsp2Sz/EKQCmMA5+N5VIdx+L1IW6Tfq+eYAtXWZGcjESQXnu8
	bIaP2stT9NSL/Qt+ZRcVM2R8dl3x1v3B29kK1+S62x0c9z5iC9fPuOm4Mm7+pLeJj7iyR1
	vi1BCYXTv+Yc3o5Vtko6LVDmOxcn3dw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="b/Jw30FJ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787818155;
	b=EPhrVT1eryUiOJ2L5Nlo+xqgaug9Aq/wvs1WcG5dSSuTMzkT7dEEuvzMD03SmSM1sL+tdJ
	Mlzdu44JD7cSwKF0ZlQ2Yz12/ZgO98ugjbajFCo8jLyvaiSuPO1RV3g91ZA5RV3ELN2AFU
	1hSK2YhlAETkykwFC5dHcWS0LMuq2oc=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1677c91969so210023266b.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787818154; x=1788422954; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sL2OyFqHiwHA+nDxyBcNBcYoIZso16H9hpW7CuWjgtQ=;
        b=b/Jw30FJ/Gck5mpkFYJP+p2GpDiENsQGmNZ2WjLH30lOklQVlXarzLyLSdmahAJECL
         R2vtOGyQ+sMxx6ApA7/4IcnImFsxB8PwFpTamtjg7MLmSlByRuKZnwwVcJ7VcYKootEU
         +73bc/EboGV1x3cM09GEWsoeZlEGOMX5lKn+TS49Pp6vbvGYqm9e7wnWzISILECwj8fC
         ulA6oSM8PcwQjb70v3UYW6Utj5yLIRL6JjmErA3bW3y3GPaWOB/EZ1kiKfAyAqLh1oF6
         zxi1kwZqABgLFD5ngsXPL94Bb8QSY5AcWR1BfaMf6zOoRXE1v2aFQusdau3VuXXUkGEg
         z5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787818154; x=1788422954;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sL2OyFqHiwHA+nDxyBcNBcYoIZso16H9hpW7CuWjgtQ=;
        b=FFh0QwkhowsGd3/dItyun+icFCHwdAxm9XNepkvgsDQ9jYOqSfoLT7QGYvhQywIPaV
         SufmaITbDQdVZk50R9Re35DBGH4F8YShSpCX6RpwIUU/Bk8ev6hUI//CbK035YfoJIi3
         feLBEqt2lFNeibI50XvYpumcfplzpMS0xcgfdFZUdfLsh1UUqmvTUTOqAETrrs+mjFbV
         LrsBWTNTax41iLy6XyzsktPuobueaOlj7aZ2wRrtkBKrSxzOZqpjv+fXaLW+z32JDS/b
         IE2BE5o+u4ooR78lXdy+WLzGtIx3li0oV9JdY0oNrD962BumVGv6vePKSdiY47v2BGNX
         8x+g==
X-Forwarded-Encrypted: i=1; AHgh+RovlrYaoWtThXfksRzAz1TK/lj0mV33RQxAMslM9ZaMSzyQbTqGc8nwzqiYYBZFNyf9H5uEc1iy0w==@kvack.org
X-Gm-Message-State: AFuF++k+eySGwH2drv/LU4cgGJZJKjLro9P70xwk2DdFGa8dUSXQQyQR
	DjAu30rkCuATVoLzu8TTxt9RZHWWaw8zR3lRCiXt8LnKSaDm2E0w0S/P
X-Gm-Gg: AR+sD130LO5acoKZ2QEEzceemMhZn0DMM/h8wmuDN/MiLQdQtVhmRG0TZpwkxPifFgi
	+eSqZFJECyMOZrRSSibulr1xz27RPttU/ih9uaCcrlIwU5GJEeXIxjljOtmDFukSBNJU3u1rv+K
	HehiO0U5xp4gRp1/Ih0vrVCG5svPMRspp5GbnW6cf5/dcSVSQSQ456BAMV1BjvCw3isuyk2xZ7U
	AajnatWsBTPYSaD8yywybaid7HATl1UAe40BA8MjKKeOZPheTQB0LX7g7zJjsqvWJYOHiV/+17E
	TsSjJeJqgpP513eN9u7vbG+gocJpjWGlG5G3ijmGeE0makvqOJVb4x87Hh+HDVsZ7rk4HnkuGIB
	gz4FSDq5BIdmIOvOipH3SV8yNqehaeb8WC9gMzBCTJCyetdp5jgxzfArfBVxJnDM8AfervKozBi
	VLvbhdMHcI4YV7ObVGG84S59CZZO/XScykX3TCTpzcW5cuQw16vXeLfIgH8bo=
X-Received: by 2002:a17:907:1b0a:b0:c20:f529:2d6a with SMTP id a640c23a62f3a-c250c37f351mr1488301066b.22.1787818153321;
        Thu, 27 Aug 2026 01:09:13 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a5d68desm1033042766b.10.2026.08.27.01.09.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Aug 2026 01:09:12 -0700 (PDT)
Date: Thu, 27 Aug 2026 08:09:12 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove out-dated document of __GFP_NOFAIL
Message-ID: <20260827080912.3qh75gqhzkoe6ghb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260827030548.16631-1-richard.weiyang@gmail.com>
 <cbc344a4-77b7-4282-9bdd-004822642ab5@kernel.org>
 <20260827074921.mracnqv2m2cugasb@master>
 <78561ffa-d075-4570-aaed-60744f11160f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78561ffa-d075-4570-aaed-60744f11160f@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E414100008
X-Stat-Signature: maqx3qiychtiarn4y1dc1xk6hjkupz6g
X-Rspam-User: 
X-HE-Tag: 1787818155-501491
X-HE-Meta: U2FsdGVkX1/YaRL4DownSNNF3kMsOBHMCEgkwx1rXpi32cEiQQZAVO4hfwlbn7vZP8vPjvExOqgCcFJXRiPtpl+mV+IBOloRNQzT/ZyIusRQMJR04/1Yg4g/3IY5FVchLnu/ZjU3DmosJ8+kx2WSUqeOM5zSNF+oiFhb9HXMxDxm7SF7G9fqBIEwUKG/ol4z/QWqAMkTCHAhucSbzaglsdT3yMWb+t1eS7YPdNMVZBgqPaF1zYqciXRIPg8MdwE3c4ILI/0jWpfe4ORDFxEzV5YJ38G2o3/ru1wf0zV6A/G+NJDUyOizQf2KnEVMVFSMyJRDzRk58cqbXwrzFLHtvf6rToyl7NcWkGpFbfiH8esJYUtCbR/2gsr+ykTPvDi6yqcPCWDx+WF84Ysf8aLsfouT+OsIDKPkXQwRE5U2cgAfAlH+JZhQmF46l1IUN9mCsj/GqU0BYW1HHBoVaF9aDm9K8zHymxBQ/K3FH9paADifsCjs1MTbZSu5CCkdgy7+hZ2Emi4P3HvwCVhgWrIvuYwt/uL0KIdPzW30RUSVusHRJ+g5fQpnRjLHUy+S9NSzipPpgg5631LG/zCC6ANU7oDHY+vEeYo2tfXSIX9y7st8/27SI9nCc6faMXZEd1g6//VZ9jPS+6G2g+L88ymHJyDQIWXCiG5Np19VgXk2bLW3OSHCP6U3IQt36mbZlk+g0KsUsMK0vR5e3hQ8oN9G5F4NIPsP9nkz8Nd/kLQI5NXYP+bNYBMaUhhzeL9Pjvx+Qz9t2H4Hm//ggVsI33+xuehPej+16JTPmpSET/AJd3dlaDq9jg3Cpa7HKcN/CF5Hw9EP2iX9Kz3oqtIWUVMS62yGM5r01DW3OG7Ktho9oWT9uMw52isUqQwnG7b6DW2aHCmqQ7ozPTakgGQircEyyEAn2gCPEKSYj7niMfPN4z0wp4kvm6aHHX379PyRS9LKJRaNmDFXL0MnqyqX0nk
 LKQxFypO
 LMBAexQIfL6oC9Fop4rOShaK3OnOQwecW5UWxbUfWac6zUSmiz3e6DHvCUiRvSx1fkhgr6FprLu+Efz0uCwO1Vaf5UjKfZh+dVKoJ4L0BoqLAFkHt3aR2hQbN8igNHKGfHhgTYGefoci7zLp9DnqWAQ0OaFhphWKSttSOImjulL6/hiS9H0SmHd6yZgN67ANnbEA3fE3FuQU1mV26NerGJ9+H7bQRGbmwUticRg8vdpNQrwg6hun5vh21uzrcaSOdhjeGcSh3c8rlpRb3EKo1+/FYmhqT/m6H0qJzmAJIUHi1ITIdOU7cpvgtIiTz/5KzKmAtKQYS4aW1If4rgAMPLymLO5Gl3Xb6e1uGPuoGJzifFK4RKTVPcWAIoQmHgKywRCGj6oN3+ojvYvEonbJlSouz7K33lhZ74UHQdPNteq8b4gJ7jcfOEpVOwsFUvGZnXu++YR9MD8lyJmvLL38wvuXKJ9ffJjHW6G6axaMnZ+94k0yGP1g3oeN9hwprpk800FIZ3UdL8uDt2L3DdrCG6psxqfcpURb+BaIn6mwYx54QqxWjSvRfIXVroK6KAwcO7Tb+hWUKYyQ6iRhaGn57UNAUA0P8eUj11i5QqsItpRGAr4AGssdRp+Lb/6h3kumVpKAw+2Mb3iYrrrnTiLRxRmq+D7po1BlLLgBgACqtQwrZICFFp2nW+w1jfPkA9VYFlSmdAf9dpNkshA/Qu4FDfIGH2gzOS52UErZzBDhULZj5YR9+g9MwPATfb6nrkTEVNx3eXagpNZXyzZZJ08hdzwXq3nz+k7sLrMedEs9KN58EhgN5xLsICHDDZo7dnom8vHtbUrgMOplsYZqiAU0l+lh4LwoYBmsGYpmSfP7frIiND3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:03:41AM +0200, Vlastimil Babka (SUSE) wrote:
>On 8/27/26 9:49 AM, Wei Yang wrote:
>> On Thu, Aug 27, 2026 at 09:35:26AM +0200, Vlastimil Babka (SUSE) wrote:
>>> On 8/27/26 5:05 AM, Wei Yang wrote:
>>>> Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
>>>> with __GFP_NOFAIL") remove a warning on allocating large folio with
>>>> __GFP_NOFAIL, which is adjusted by commit 903edea6c53f ("mm: warn about
>>>> illegal __GFP_NOFAIL usage in a more appropriate location and manner").
>>>
>>> "which is adjusted by commit" sounds as 903edea6c53f came later than
>>> ee040cbd6e48, but it's the opposite. Maybe say "which was placed there"?
>>>
>> 
>> Got it.
>> 
>>>> While in that commit, it also documented this behavior which is
>>>> out-dated now.
>>>>
>>>> Adjust the document to align to current code, and adjust the comment
>>>> while at it.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Baokun Li <libaokun1@huawei.com>
>>>> ---
>>>>  include/linux/gfp_types.h | 2 --
>>>>  mm/page_alloc.c           | 2 +-
>>>>  2 files changed, 1 insertion(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>>>> index 190191411009..24fde8eb73df 100644
>>>> --- a/include/linux/gfp_types.h
>>>> +++ b/include/linux/gfp_types.h
>>>> @@ -243,8 +243,6 @@ enum {
>>>>   * used only when there is no reasonable failure policy) but it is
>>>>   * definitely preferable to use the flag rather than opencode endless
>>>>   * loop around allocator.
>>>> - * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
>>>> - * not supported. Please consider using kvmalloc() instead.
>>>
>>> I'm not sure if we want to simply remove the lines, or rather say it's
>>> discouraged (instead of not supported) and still suggest kvmalloc() if
>>> possible.
>>>
>> 
>> Reasonable.
>> 
>> As mentioned in [1], kvmalloc() maybe not suitable for some cases, I would
>> suggest below change.
>> 
>>  * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
>>  * discouraged. Please consider using kvmalloc() instead if possible.
>
>Yeah that's great! Thanks.
>

Thanks, I will wait a while for other comment before sending v2.

>> Or, you prefer only s/supported/discouraged/ ?
>> 
>> [1]: https://lore.kernel.org/all/aQTHMI3t5mNXp0M1@casper.infradead.org
>> 
>>>>   */
>>>>  #define __GFP_IO	((__force gfp_t)___GFP_IO)
>>>>  #define __GFP_FS	((__force gfp_t)___GFP_FS)
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index ab385bc252cc..146f7e0a9462 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>>>  
>>>>  	if (unlikely(nofail)) {
>>>>  		/*
>>>> -		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>>>> +		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>>>>  		 * otherwise, we may result in lockup.
>>>>  		 */
>>>>  		WARN_ON_ONCE(!can_direct_reclaim);
>> 

-- 
Wei Yang
Help you, Help me

