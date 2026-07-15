Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B91C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21F06B00ED; Wed, 15 Jul 2026 09:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA076B00EE; Wed, 15 Jul 2026 09:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDFD6B00EF; Wed, 15 Jul 2026 09:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57EB26B00ED
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:57:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A20A040151
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:28:24 +0000 (UTC)
X-FDA: 84990787728.13.775D34E
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id D03DAC0007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:28:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FLbPEUis;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784114902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjZpJ/ZGdtH4VffFiXS+PfV8IVOQCwOAwF8cWS5dH18=;
	b=GwNJqhU4IFOGgVuk/0w3jdB1UVRgzHe1l/RLQelo4fFZ4cbXtpH6haEzn5OOFC3L5nhLqZ
	nrQ/7HhJmWaUPIE8HelTGsAzGaj4KNZfL5N9Y+FQ12YZ/plH1I46JTX7eT9yVaV5eq2dHT
	mkFqO4fhGmNDU/HmHcVJfYTOmUloOuk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784114902;
	b=S9dBTIwwNKP1r6C5trQGyv7RYEvCXpFr/BBPUYLFsj/7Y6oXcYj9IZ3kQNkIjA0nOZIqNK
	8gFyMV57ElsGRJch+O8NbGCkkvW04H35YlpCMBzH/+8EWURduoihi46JUuZimfz0A4fdyj
	dzywYyLnzGN3xTr2gwlcyiSRQajkO+s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FLbPEUis;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c88a4d79ba5so3464672a12.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784114901; x=1784719701; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BjZpJ/ZGdtH4VffFiXS+PfV8IVOQCwOAwF8cWS5dH18=;
        b=FLbPEUisfUdLDsKgmOGENhm8PbtmEY3xmloD3rDVyk+ZH9VHr7vIH3jnk6fTu2QJqW
         D3syD/ItGCwpQomx3jAtCDmBcxrzhefRg7T0OXHXimbFYS0nMI0h2mhzYqNtz6lYMeks
         jLxfEJjdr05OZ4f09imZoi0V7A6HU9h/TeDKVfrbBhMzvyev13h5yTxdj85dtY04a8Vo
         BSGmSYpeXWJtRGdW6ngxxgsU0+nu5uT0S+QAEWsb1I2BONCisASL6T/jDkssX8TPd1Qb
         PJ+/g9WTu/VQIGf0M1t5qngFz3TkUQTfOmk1M7q1rphzDnl30XvGULo+7RBof1HlNz3G
         Vhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784114901; x=1784719701;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BjZpJ/ZGdtH4VffFiXS+PfV8IVOQCwOAwF8cWS5dH18=;
        b=WRZ5XNqwkcm8BNCwx9H/ypqQR0AwhfL1+DCQdnnM1+bamhRv9PH2ejWwvZTruGJKRb
         9HlEn+rAgRopxZ9/4GpyClYAlh0GAl3Bz5aXRHUjfOqvRWlYhomnY+o6/GwIlOY4B42j
         cJV4DwajjF/H6kscRf1xSmB8TQik9ZUK8HvhZEi7ZSDXCzPjJFGWMLtJj09IXpoVDzQA
         Qb858tiJCawt0J1rOgxuW/z2prDfVJInj6KWaa5vjcGr7LXlPUYzwhkuEbkRgYb3s+jG
         5MM71JF3DF6XVCDuoRfZT9a9Qi/cibWHgp+V8lG2U15+NI3lqW8yFMbVyqAr9qpgjKYA
         ViYA==
X-Forwarded-Encrypted: i=1; AHgh+RrUY6BjTRs9TglBRdJpd69pjUws6wgg9g7QP71KR1koO6xyr1ASBI0D/mGNki3WfQ5/E5VdUcrYew==@kvack.org
X-Gm-Message-State: AOJu0YzbOwMU+FEAgl7FnGrzfOGKND8TC3N7oozB8lxhrCUDvcRCSukc
	VHo/o9kUaRaZwZkA0PMNA2JAe/r0Fh+Flo8GGsvO/2hlTrepsouICdvW
X-Gm-Gg: AfdE7cknRybelyUc4AB7V221RI9DCl8+kNBR0cLnt7VTpAeJd4pbJ2MjUCPvmEiIATc
	zhBXwJxQSlENN+fe7JYh450hayUd27gZ6Fsbe7emWMd6L90ShrELeYSkNInpBEIsIIH7h8/oVwb
	QkFcW2yggSh2VtzI15R4YKYENpgry/jFEKqUz7avVtqkC70NDpzvKgrce9x/Oqq2zI9dKZevXYK
	nC0h3uMgSEZYYMi7d5DKUPRUOI0rfHIm8FXWcYvaNrxflnjDdn1hbh9GepYGT0Gl1zY7p1OMpIw
	R/6qgvr7ONNIwO1xKVBhlBU/YoaQzhPP5r/V+d81e3oRLT7t09h3zCcOoMn9JKqOTZsx8I3LtZe
	iixtiYp2UhCrAUMnmwA3eQvB0jP+kMcQeOfdxPYBHqYrIPS90Pcur0rcvMwLOE9Q2y1hVFtJ1eY
	77xZcq9C1xdLHpMMrNayAMMkWw/o/0Vwb42Q==
X-Received: by 2002:a05:6a21:730e:b0:3a2:d838:bfc6 with SMTP id adf61e73a8af0-3c3573f6e82mr7065531637.29.1784114901393;
        Wed, 15 Jul 2026 04:28:21 -0700 (PDT)
Received: from [10.125.192.114] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258fcfe20sm59594a12.15.2026.07.15.04.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 04:28:20 -0700 (PDT)
Message-ID: <2bc8e4f6-46a0-5b74-6eaa-59e7aef9227e@gmail.com>
Date: Wed, 15 Jul 2026 19:28:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-3-jiahao.kernel@gmail.com>
 <CAO9r8zNiT63LUHx8X5i_aboX1UWuGkcFf+p9ch-pekURUuDdXg@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zNiT63LUHx8X5i_aboX1UWuGkcFf+p9ch-pekURUuDdXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D03DAC0007
X-Stat-Signature: 1na7bkeqatxycbnifrznjafrymd379ry
X-HE-Tag: 1784114902-876788
X-HE-Meta: U2FsdGVkX1/LCUavnk0roKi46RLTy8MK5i3ky4m435yQ5cnpWnFHUiH5XNy2hq+EuXhLBS28wdzQ09VlwMbmCAoG3YSdqIePjWPtG3pxxAW0iVs4z4CjGZLDZEmJDZqtIezxck7QgHBh/y/2MbCyoavqRdZULZae1YwOrPdU/zRBu5TX+RGNoRSCLbS4n2WtTqbE24aqmSnuv77n78I5uAqLab38edOEMczi2/rijWXBIaqeY9hl77g2drHBseDY+hj1Vak2tWWyYaFGxCL7FneZ/k4+nOQAAbh9S+RMCRWhTzBWTgtRkMURHC8C7LDYQ6rxeOMjoNgrci0n4rdG5wltCAAPXOg9KqoOCPbZzOnRq57lDvAkQrEX+zYApftwBzT+MLLW7i6kaWh3lmo5FHFuTbHlSet5Ecw0mZEm2WwSQvPgNYWMrv5L8o/ae9WG5oiARUcMQm2s0X/fYB44sta5CbCZN1Y2BDOGIeSTDNLrINDs3yc8a8HxImA+/dd7mmpUNXW35CoBHzA8XpTFiXslqk6VYmkBZcaIJJDQKCgKTUvAlUNimkiM22k+YRTQdiX2K2N8ExtaSpXfpyLKqsYhxgJAPQCf6UxmB7+64P+H7mXbSrAUPxAWfIJVbwCJTxDZMYuApIZy5oFlaEEedBJaBDInv+bj5I5iOefBvefbfe6oFcRamVsHoUvyiwslpLnhx18AfXTk+G6SbJ8Jwrcxx8kGzSw3ohKXMR4WqwGUW5rGEZrcUhKyAzT4ceU5pMx6o5vEJf4D/aUYUGzgKnwO484dqTmelcnHRwsa0oOuuH7gOYekf44IwNNUrbNPSYVGoj0jZ5fn+1ymVLK/Lhc95MB0N5QBfXdLScTL3id6qz9Ny85c1eyD8p5lGX88Zem6KXE62xKp7iFDxbAu6vwVUncslqtP2S5hxhShnzfz2rhzmn0tCCpI7L5yNVm6a9aBGMWQnWU3Vb9/4s6
 rKzHOow1
 425p47mgWDRraqwr//clI8EfTCsqxz+s6d0+SrEnuhDMUeGlLd0YXQ+yUrLjXCNGAXd1DOIQJeA9SXMP42YXJHS2NLpC6380aznPF8XMfNkNj9rfDD2etJUwm65QpGcNOaVg+ccza7wyjOIXVgONFTdhuL6370WlPHBZTlu50lv4C5z9408RXKyTc830uo/Smiyd/PAeJOPcFXooymKOgvxkpG3NEQAf+w4zee8tilmG2q87OFJ7n8jgoYHSMFcxCzwp8ywsZ9UzyhFw5zoxTSoN51pOzBI5tYcPwca3YoDm9CspcUdNVX2ZO5ve2xtGz1TjzzQvPd/aeoWCjaW2ZEXGyoCPYA1WytUQaZbag0G7O3G7PQ0AKB+yG6aYFVFEh75kj8Ak/P9Gu9jUwSb3N8Sy3Guv5upKi8F9cbNERfMhZGYao/cFPXI7Wtb03mM8DmgsVM2ZaYtCryqSKKw+XYYKamxOfzcxif9+9shVJVH6KizYTan5FXcxC7ZI3IAwdmJrFArf3eMS6BikMyF3O0FJU1r21vZhap3MXJ1doiVWRilv65j7j2x0oIEzGd/N3EwxrCEX/3H11XcsXBP7JfAk19Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/15 00:52, Yosry Ahmed wrote:
> On Tue, Jul 14, 2026 at 1:15 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> Currently, shrink_memcg() writes back at most one entry per-node during
>> its traversal. This makes shrink_worker() inefficient, as it must
>> repeatedly re-enter shrink_memcg() to make any substantial progress.
> 
> Please also mention the case about writeback being slow to keep up
> with refaults in some cases, leading to zswap store failures and pages
> skipping zswap and going directly to disk, which is an LRU inversion.
> 

Will be done in the next version.


>>
>> To address this, extend shrink_memcg() and rewrite its LRU iteration logic
>> to support batch writeback. Introduce the nr_to_scan parameter to bound how
>> many pages are scanned per call. This enables batch writeback in the
>> shrink_worker() path, while maintaining a low scan budget in the
>> zswap_store() path.
>>
>> Additionally, to prepare for future proactive writeback, update the return
>> value semantics of shrink_memcg(): a positive value now represents the
>> actual number of compressed bytes written back, 0 indicates that candidates
>> existed but no writeback succeeded, and a negative value represents an
>> error code.
> 
> This part should be dropped for now, and added with the proactive
> writeback, as it's currently unused AFAICT. Removing
> zswap_shrink_walk_arg will simplify the patch and make it focused on
> the batching part.

Will be done in the next version.

> 
>>
>> Test Setup:
>> Total memory: 32 GB.
>> zswap settings: max_pool_percent=1, accept_threshold_percent=50,
>> shrinker_enabled=N.
>> Allocate 512MB of anonymous pages and fill them with random data (to avoid
>> compression), then use cgroup memory.reclaim to force a large amount of
>> anonymous pages into zswap. At an interval of 2ms, allocate a 4K anonymous
>> page where the first 4 bytes are random numbers and the rest are zeros, and
>> then trigger a reclamation of this 4K anonymous page through cgroup
>> memory.reclaim. When the pool threshold is reached, shrink_memcg() will
>> be triggered.
>>
>> The test data after running for 120s is as follows:
>>                             Baseline         Patched
>> shrink_worker wakeups          5363             85
>> shrink_memcg calls       11,345,012        188,264
>> written_back                  40214          40275
>>
>> Conclusion:
>> Under the same workload and run duration, the patched kernel shows a
>> significant reduction in both shrink_worker wakeups and shrink_memcg calls.
> 
> Please also include data from the case where zswap store failures are
> observed and pages go to disk, and compare before and after this
> patch. I think that part is also really important.

I retested and added some collected information. Perhaps 
`pool_limit_hit` and `pswpout` can explain that batch shrinking of zswap 
can reduce the number of pages that fail to be stored due to the pool 
limit, allowing zswap to skip zswap and go directly to disk.

                               Baseline      Patched
shrink_worker wakeups         5,363            85
shrink_memcg calls       11,373,201      180,928
written_back pages            40,212       40,236
zswap_store calls            161,190      168,741
   store succeeded (ret=1)    102,743      127,644
   store rejected (ret=0)      58,447       41,097
   store reject rate            ~36%         ~24%
pool_limit_hit delta          55,826       14,062
pswpout                       98,659       81,333
pswpin                            2            1


Thanks,
Hao

