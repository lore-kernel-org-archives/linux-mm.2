Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A9CFCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 02:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D7A6B008A; Tue, 26 May 2026 22:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEE86B008C; Tue, 26 May 2026 22:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F42C6B0092; Tue, 26 May 2026 22:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC156B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 22:39:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C302140494
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:39:22 +0000 (UTC)
X-FDA: 84811643364.10.A3116A3
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB945180004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:39:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aB5y85eU;
	spf=pass (imf24.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779849560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGwC6eNLghO2bBmS4gKEtdX6PelNtfsnZTEHkZ16hk4=;
	b=i/9o1SZpRq2FTDTYaZEJVc9HKLqRDwUtcnsAIekS/gfNrDaSgUbTzFdKwK7F0eV3lbPZHN
	+pvcCt5wGDivYhMcqwePV67DtZZC8kAx4+lfwgJ0YNmpG+FL96XP2OtLETP8GRJg/x6Pqq
	ZjAtm1ept8nDYwMrUFuuI0yGZNAH9SU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aB5y85eU;
	spf=pass (imf24.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779849560; a=rsa-sha256;
	cv=none;
	b=qONAeikoDSBnss64mhepielfcvqvfNwCdFHIR+qxakDlVjH1F9x4M9a+Ym8QHrua0rBXs4
	K4ZDZQI8FEXo8FBmKsAsnma8/dYuHO/SUQiFV1o57xozT75iNA8/FI6CtF11Mx6qkC1srR
	SX/OzNJaJixiBphah7W1Db0eVGtQZeI=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3684a6f3b0bso5564592a91.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 19:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779849559; x=1780454359; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGwC6eNLghO2bBmS4gKEtdX6PelNtfsnZTEHkZ16hk4=;
        b=aB5y85eUO3OW8pGqNObhl3dsE77PG+vvK4DOQdXP+MkbaNC5FFqAHPo0j0Atiil2JB
         yel7ZbJD3IklJZzHpc3JQxF5YyIt8bzguiOLttSIE4xvZI5SO7FJE07DTgNCKcAzoF8f
         aiWZqEkp0zRyJsic1pf0pmOQCmNPdhihBBlKqLrmc+9L11bOVZSIj0ReN0pTV/isGc3v
         Ep6+O+FgqZKeIyAy/EtU0O/l1u/qvADPMobcOLZkGFsSkwNNXMvO0QQEs57yViz9/R3V
         I/QTQ8ek6pOg1EwWZ1II8dCElXih3KXMflh7QNzrjJhg6vwr54iILp4IVCUsPu5n/Ymr
         P3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779849559; x=1780454359;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sGwC6eNLghO2bBmS4gKEtdX6PelNtfsnZTEHkZ16hk4=;
        b=kdMGecCeL5sUIg882DiTZNzs0euKLSlo1iIqZM/lbZLnjKWP7/K/wewaPbuHlbjrT/
         rEI6fn3Ica7BdTo8RmhcM4Z5gvpmjEUs80XqzeiEIz9WOmJBbSEGbVagQa4O8Q86cclA
         jXbS4yN61YuLmCWvbKFz4eYtAguvMVLV7q8ExFeyE7Xi4OTvX5tRBeYEQaQ5WXA9aT2P
         Z6NfvFMId6cinBiXoO/3+HQQ+FJFpaKTOzseGmfhT8edz7VovlNGsS/t2N693zKDpetV
         QieB9jDdJ4pXRfBFin5lbuljkHcruAVspH/3bjQQYoot84Pkk232VNK+/tBmXAbR5g2U
         bFoA==
X-Forwarded-Encrypted: i=1; AFNElJ/A3p2q6n8+3hf2RvamvnR2VZqRoBpTGSbHbiBSy1o+zTye9l6Nl0hVaPc2MkURXNDabAfoU8hryQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+mFgh8sGCyZL11GOKgGqaQtNa0IVazz9PiJiIR1fS+0sy8s16
	RJPQ5dStUUvm/sIYYXw3z3CZmjQ8/I4jJB/ukcGiKjVczTqb8jMxXofA
X-Gm-Gg: Acq92OFkdRSD5sGcTVAF95bSHuPH3dhN5V+c3zSQPrQGr1FuC7gQe4Jj9hq/vXCaqUm
	Vsm9+Kd4pgjcPphZQpckhj/MQWb0BKBd4xo5YBLp7KzZWUntmw1bEq6x9ecYZe9CBJ3RBnRtjP5
	lMiGa7My3vkXYGLvca+61JlrftUcgOT0SjmyRwfN72HjjmlXJ+0QX+1Y5lsuDZfagDBQxh9GYtb
	kUig7jaEATMniitG4dOOy/7YXfMGN3iR2GO6AvQ/FYBaPaW32Wfj1TjeHtECMSRztkfDMBM5557
	ko+rUzMP+Fxfg00d2M9+SD4NMnXUIdBmv+/qvB4kyuXJzWf9Ewdappcbi6ZxNniwuRLnWwvb+Ua
	aDss2d8390bUcNrezp6rfwycTWB1Hxzp6dMSG0zMYg94rorscXX2ht2fEfJU5oCas7pwcJLoRQI
	o1jj/ydHoPCbONLWHxygRY/KGmHU1xXQlqGI16mUUJD8o5WexSRhSmO94=
X-Received: by 2002:a17:90a:ac10:b0:36a:5b56:5c1d with SMTP id 98e67ed59e1d1-36a5b565cf7mr12903624a91.11.1779849559393;
        Tue, 26 May 2026 19:39:19 -0700 (PDT)
Received: from [10.125.192.130] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85202b946dsm11616672a12.13.2026.05.26.19.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 19:39:18 -0700 (PDT)
Message-ID: <8eea0a0d-615f-ff72-b019-0634a5f1028b@gmail.com>
Date: Wed, 27 May 2026 10:39:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2 0/4] mm/zswap: Implement per-cgroup proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 mkoutny@suse.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
 muchun.song@linux.dev, roman.gushchin@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260525122242.36127-1-jiahao.kernel@gmail.com>
 <20260525122424.3b2818f06832d9d55da8d69b@linux-foundation.org>
 <9b2ac88c-a67f-2512-d898-3dadd50ec03e@gmail.com>
 <CAO9r8zO1+brQroYufMZ2K=ZH_PBBpzYPsdYm-DT3K2GxoKJs9A@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zO1+brQroYufMZ2K=ZH_PBBpzYPsdYm-DT3K2GxoKJs9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eb7h1wm496rztdz1grweq5eiofnkxhzb
X-Rspamd-Queue-Id: DB945180004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779849560-117781
X-HE-Meta: U2FsdGVkX18df0/+1r/fw5wp8OKoq/N5wu4JK2Jg+7lNNbtQoysw/wdNxO+bWd5WoMNmo4KgxuwXFtI//w6S7be76GsWIsFfThq/Pqg/hfmX6hxSPpKznVqDLrfMJhlmxz8EPs54lk8Pxvyfjxn+CxD9DJWp2ytoOVrMM8fTfI03rNF5jpvVmdAeyjWbY0X8YnTShH8KFQlknGIDjnWGIeas3IeXef5LNOES37fL6kGHfUI3mBAMsi8qZVnVMI3gUFtxpElhz9W2sJhKrPLIDxgYgZ/zZa1sYrx60sHEZKhtJc/LTtsSVqaSNtIBlCB11FMYpNrC7o+fkRiqWhya42zprLdkWNNNIo1MhhJs7fvWsqmk2RVIfFFvoUjIURqqLBynD+G/fbVReoM+nsNjX5XTdZnk0X56yuJwR7yZLal8iCVm6QLiqwDVoItmhgVf18SZY6k5at7oDEop49CPog/v15UEyjiTfknfjCTPOFLxLTJDMakru25unTaese+JjoQWzzsauFwYTEaMsUf4OKGyKq4Zv7C0GevuVspLUiwgoqVVg/T8IpvlhM2sZZf08H0S+CVXpluhO2BaVBlKnEKhDGr4gq007PwuOwrKRVHPrRZ/OZL0XTtmlTgxZTkHsumbUGT4ifvUnVR5ofqH/9oOSfGN87PWB8iL+At+wVrN/kos+P/za36dDheMFG71jQMn4PhIaczfvEgtmpwe1ienDwZBQ9incTaOv4uBUHT/aDFCsZrXq42DPWVsll1RTt3jPCA6h+sWsLAxYp74MpDEIy8B0EidsR4otDCTHvfj/3c1878hAWNKS0S0Xh1N670sk7zBT2vXYjGCifWYrvdiao3DDix8hpnhZrvx2SHtBreq96ARDri7qoIiMLGmwcaB3DNosjI6rHtxNOj+pZ3l4QgXv39ynmsqexXn4RF0tkhtwUPyyXRgqrvfZJiBrAgi/5AEcoOq0uueUtO
 wVUdQWaE
 bSvBT+T/zmE/A4FYr7eS79wT5PCGjxqsMBQNfOnCtK8j3jAemVP0f/Lav3hFsQdMfgfoi9vBfE4YT7iwq9vDM0EFrgscH32vMPIS7CXL2hMFsF5nymGf9YyF3Q2FkZsc8slNGrt1qp9kJy6Mjp38YTbdQlHZyVI8It0m8sUsmn+Co9WjolHPIg4EtlgYwvhrM4TaLjPCmKQJB1QPsK0G5rv6BmDvgU9faUqJ5u9Yz0dlPXQIJrVcJxR0yGyOLrsA5O+k+izluDz3yVpAGj0emlVP7+Xiewyo9dx0DCD3xnwqZnoQDW2D60CQEOp0siZUZdvBna56JFLR7y1+wmllHqpCeF2w92tAL8A5edwXT9Y2Esq687ta3Xq+a7+t3ESrXG+AssqX6lVfIrja6TFc+ZjrtNr0MULNnFgQxSVdOFykYUBTalB3FMDPrxVgFwqguNQfCmEqH7o8Wg1lVyw5yNXGygjkFleG1k4Eg4GttewYPfgAYYeVY8+ho+1Ve5ac4Kjjt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/27 02:55, Yosry Ahmed wrote:
> On Tue, May 26, 2026 at 4:56 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/5/26 03:24, Andrew Morton wrote:
>>> On Mon, 25 May 2026 20:22:38 +0800 Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>
>>>> Zswap currently writes back pages to backing swap reactively, triggered
>>>> either by the shrinker or by the pool reaching its size limit. Although
>>>> proactive memory reclaim can automatically write back a portion of zswap
>>>> pages via the shrinker, it cannot explicitly control the amount of
>>>> writeback for a specific memory cgroup. Moreover, proactive memory reclaim
>>>> may not always be triggered during a steady state.
>>>>
>>>> In certain scenarios, it is desirable to trigger writeback in advance to
>>>> free up memory. For example, users may want to prepare for an upcoming
>>>> memory-intensive workload by flushing cold memory to the backing storage
>>>> when the system is relatively idle.
>>>>
>>>> This patch series introduces a "zswap_writeback_only" key to memory.reclaim
>>>> cgroup interface, allowing users to proactively write back cold compressed
>>>> pages from zswap to the backing swap device. When specified, this key
>>>> bypasses standard memory reclaim and exclusively performs proactive zswap
>>>> writeback up to the requested budget. If omitted, the default reclaim
>>>> behavior remains unchanged.
>>>
>>> Thanks.  AI review found a few things to complain about, one of them
>>> described as "preexisting".
>>>
>>
>> Thanks Andrew.  I have replied to the AI's review comments in a separate
>> email and posted v3.
>> https://lore.kernel.org/all/20260526114601.67041-1-jiahao.kernel@gmail.com
> 
> Generally speaking, please give time for reviewers to take a look
> before sending a new version. Less than a day is usually too fast
> (unless you're iterating super fast with the reviewers). Review
> feedback does not have to be addressed immediately, usually wait for a
> bit to collect as much feedback as possible before spinning a new
> version.
>

Thanks for the advice, Yosry. Got it.

> I will take a look at v3 soon, thank you.

Appreciate you taking a look at v3.

Thakns,
Hao

