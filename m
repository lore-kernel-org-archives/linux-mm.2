Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0832C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 11:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98FCB6B008A; Tue, 28 Jul 2026 07:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F01A6B008C; Tue, 28 Jul 2026 07:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793116B0093; Tue, 28 Jul 2026 07:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2F66B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:22:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADF801C0A47
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:22:28 +0000 (UTC)
X-FDA: 85037947176.12.7D1022A
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6BAEC000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:22:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m10OF59P;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785237746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnms+9vQk0XRhN8yGhD4S5jTMVSUJpQVAGAxU0TRZCc=;
	b=LUIL7EDDWBHY+m21FCHpxh54hjN4tEogxAIxQvDOHH1b2X40gNgwKFE/panNI5Xc65Wnrg
	5RA8GyKrS+X0Xm7UMrGOfpNYer07a81LNe4uDcOhxu4xRGY41H0wc81eJjs6kJGQCNI2aR
	k+5UmHvEWDYfRt3N1zAwMxlYYbsNCh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785237746;
	b=UH0M3QdZeqkzPk9kksT0lHLsRO0IW8MM8ris7Ajitk1E0knMPzMyUXvEOduC8prcNZbrCD
	Pn90cH7ndHPdE3k9E99E3WTIXtwaaBDrPAq781FquWNUIl3/1JI+GH6n3G3r6cwJ+Ki6sU
	8SA9mj1drNlIdxqglzgT8ECRbf7cIjc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m10OF59P;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso2802899a91.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785237746; x=1785842546; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fnms+9vQk0XRhN8yGhD4S5jTMVSUJpQVAGAxU0TRZCc=;
        b=m10OF59PGFKWHQnsdGkmyoOHn0A9MQ1bOgpP7cxHUSLtEoB4oazXrJuhZddM/xRCFJ
         okLjWXPzXZbrIYlYOBNcJAE5+k0EFKzOtu6VJzLfp76unKqAn75s0to/yvg88EoxfXCs
         WyrPCS5zfEEFg+o4myz+nyrw6AnkgjIexQ83e8o9lYTBhVL1MKeEcrznOVKLFg1+nGON
         h30xZc2+q0nBHLTUcE3gAAZ/0nzn3OpuanwJMCKS0YxXQMB6brOFvOVgYxnvgCRPEYQR
         oCkX7xHR5X4UX/AIJ02BiEzImNJWT3RwOErKysK/oGNbeiMr+GQuXe7XbxLzyHjTwaJc
         3hFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785237746; x=1785842546;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fnms+9vQk0XRhN8yGhD4S5jTMVSUJpQVAGAxU0TRZCc=;
        b=JU0yBk+0udBxaXDW26poQOC/IlBxqT21/dkyk8+urjtxcPbzmlHFqdJ2wXiWbEpH5h
         CtvqHc4CctRjIHyGZA08KQy6EiAAaLBO15JpGNyMb9W3KTQBNBvUxe6rjpQTHNFomhob
         DRYr7zoYbIOJCCFhqbTMT1RjDYw849mVJiUMmSa47ZwJ+BAW3+vxJhV7pg5YhV49Qica
         WPJPpG3xouFZ6+GcYGCin/AFNaw0IsPzPWgcKWpvZiKeHizFZXUEgEQMyDUpoWoG8IJ5
         YnBuGaF16dpfqxjb+Tm8WQEd/z/FNWeC1pHNhe+O00m4RCQJn2yISo+tKUwGLM8kJTOx
         UIPg==
X-Forwarded-Encrypted: i=1; AHgh+RrbOkXxkE6gRrv5XABr69VrmZkFZB3oe3a7z0uFBn1gS5zdtZtMy9VXjk6xgSAgQyiQZZe5XLkCcg==@kvack.org
X-Gm-Message-State: AOJu0YyQuwQxvMU38poCE5dX9atFu0enUgHgFryY64+mZCLVLkT9On90
	4xjWxNsh3O+7gXgQUFfaXnnOZB0ULdF6PQDQroGjheYavuY86vkbiffr
X-Gm-Gg: AR+sD1071RPpklawTZhshTzAK3XbOa9D7qE4spUp33Vo/wAOPr+h9rk0mbjwJPAuGFE
	ul35fI4gGGxHlmdpOOJaFIwm3MqAn81JJ99F3DG/fy4OUk9XITzOWXf3Xktvdw2326b20TlgmKw
	O5o2Jsli8Lj/ti4cMnfLzgeUhO+CIRnxhrBN3GaVzx52a59Pvpns/sGYN7ANDjZqsQyYRYXaU84
	Kqcu22tlJ7Fa1Lbm8cVB0li6oEAtQ6Uq4nmKtBMyc+6rovgxJ89SDcPi6BdctpxoczCIeSkZdNN
	L9zam1t6Pcvj7LYnBwwmp2IiLtMHYD3kMHuvKzZycQf5gr98cmnYGWCSDelZIt1Wb4GGwTabS5C
	2TC+Jg2Km64ibvOsYzl7BJxyP/UVY/n2uPXVw+tA5tqr3qe1eod1yiNTkc6wX6SqOGv+TTR8yzZ
	ZsPa1qPWWwTlC2k8U5Duf5OCk=
X-Received: by 2002:a17:90b:3a4c:b0:387:e0db:bc24 with SMTP id 98e67ed59e1d1-38f6a59e3f9mr2045090a91.36.1785237745515;
        Tue, 28 Jul 2026 04:22:25 -0700 (PDT)
Received: from [10.125.192.117] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f642bfc66sm1122800a91.10.2026.07.28.04.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 04:22:25 -0700 (PDT)
Message-ID: <7bf9384b-2999-f14e-f23c-0df93168c20b@gmail.com>
Date: Tue, 28 Jul 2026 19:22:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
 akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev,
 muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com>
 <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org>
 <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com>
 <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
 <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
 <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com>
 <amO-hwo8OGV5Goz0@cmpxchg.org>
 <CAO9r8zMgVmgQET+PUGexAgNqCZavA2YoTTXKSbWWoUv=A=ytSQ@mail.gmail.com>
 <f60fe501-7605-64dd-0572-77f7f3060f35@gmail.com>
 <CAO9r8zMBWA7nxM24VXQT00CVEZwFpMFNe73FFdPSZw2y=J-0HA@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zMBWA7nxM24VXQT00CVEZwFpMFNe73FFdPSZw2y=J-0HA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ks8yrw7ss517uj5ui5pjjqx6b9cm4uk4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6BAEC000B
X-HE-Tag: 1785237746-106706
X-HE-Meta: U2FsdGVkX181fLWhG2pYYCT6rByMTWlpuruoZSZkG6LRyL13WxKiDYlM1ZSfPGMiRmExxHxVHspHYqt1gk03ISkDem/t84sRgnUoSlxoMllqMIhQ0m30tLYa/I7Ar4b0iWx19iyaDIBAMiz+taDMCugffLEvUJMD25NzF7IuWKtAPWsDbuLo7Zgagsv1BHW1Kq/ZY01u6iu6hTp6FWihbM1cXFNljHyNSulzZk/SlED1YAeqcNC5zfBROfRgMpdeV7/DM6yEMDXX3Ilz+nxQO+dDbpAoPFDQXPQn/BlAId8T7EijeqHSvFtYgx6pnArmItVrpXsW9T7x+mMfSmsmgqi5UD5meCQtlXBa9HHc5B46CYYZQexxWDw6U8YHwRTmCMCQdTRU4fJ5dJTSNLpGrl0u8qAysoDjQbkcT1vHySnkLcExs8CzpHLvHQsdtgATikdi8lv/+ho1/0AuTaVcuwHa20NFjLMf82KrBG+T9r+CVODxoKGNwroi6gn9p4eoOEq943kaVITZiyjebP+mZp5yIoZJTcRpl3Hq4ockJD1Cu40hrcPamoITdPV54tt9TOk5yI0Ah8Ul9RvmD525ZPQOOchpIXA/sD1sKolAr4DayHkn0fhPVyXdsGEGl0DD8LzoJ5hi+Yu/2537fgK48IF8tHzHUXF5G8aJ3G+OYRNsesjDPu3v2rjl4nDXd4I0VSvWKN/6D8WcWVwj5tPfNHx/w+pauQEFDSsiu6KdwIJfNzDKljzt4S2uKXaJyDb8hljYdx0EJDo8WGxoKemlJSt73ejcyZmHPPIe0fdt1UUiTmTdOsTrQgi2ikeIkLa7zFIs7vwftB5pEYMjaNgXHDoXZrYXLo0uhTjg/raPZcYP6FdrwSqg+CgG3rlcsrPzHRhAoyBUPJib4edBXqhQfWKl9WaU++l7A+TIErjvCugRiUzMRq3w7Gs96ZguVT71fGDNPOvlsQVRGEF22J/
 khdZ0+Q8
 +PERrVtMfKC45CJSB77tIwvBZ06xfsDzBq9ag/NvVjSqrlQqrR3pOffkPQM0CsyAJVCaYqskogyMrBgefG+Zem2eCAPa1GFzMHLQeuGvHLLieNFtjWiyLZM/IsR/kYREkHZD5xX7TV5IfD9PaxY8Q6zmzIox5mLMxwjmxLBRZ7sfGnNSWBo0L0bC7ZtmouR0zUSnuqbW2qmOkQVG+haCMFNfZSzEAfzV3L+L3WSdPbCO/gAVZ3ZunD9/f0aU41RS8At15jjXUYFAFQx9ybx66owjTZOj2avKsIRAV93drdoRamOA2lOwLLjA39uak2ePMzxyhjlMi3LMH4k/KSVXC6jHghxXYzMR3lWB06xMEmBBhobu9/ToNOGcvfVPoVrll/QNNiYz2Xka57f/npEDaVchfptgzHEgJZXmQOpmBqG52jigIggyBIaMZJxo5eznSi3kp4bJWJju7a7Yadoci9hKXpQyd4+TXZJoRgWNMnKaAE2amvlebprvpO2u2etBxgPUDKZlJcJOPqaRRXLJ4hxYnVhnQ1VWFL5FJ1XhJYHzvrGSeZ/QRX6YhAchE6JZb9nKFJUBYShchG0yh+Y+dwc8cUM0ODkX8bCSA+t4YJEVSx1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/28 00:18, Yosry Ahmed wrote:
> On Sat, Jul 25, 2026 at 7:39 PM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/7/25 06:22, Yosry Ahmed wrote:
>>> On Fri, Jul 24, 2026 at 12:35 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>>>
>>>> On Fri, Jul 24, 2026 at 11:39:41AM -0700, Yosry Ahmed wrote:
>>>>> On Fri, Jul 24, 2026 at 11:37 AM Nhat Pham <nphamcs@gmail.com> wrote:
>>>>>>
>>>>>> On Fri, Jul 24, 2026 at 10:57 AM Yosry Ahmed <yosry@kernel.org> wrote:
>>>>>>>
>>>>>>> The numbers generally look good, the store rejection rate is
>>>>>>> decreasing and we are naturally doing more writeback which makes
>>>>>>> sense. The store rejection rate actually increases when the batch size
>>>>>>> increases to 64, maybe aggressive writeback is more likely to fail and
>>>>>>> cause a store rejection, so that also makes sense.
>>>>>>>
>>>>>>> The only part I can't immediately reason about is pswpin. How are we
>>>>>>> reading from physical swap more than we ever wrote to it?
>>>>>>
>>>>>> The same page can be swapped out once, and swap in multiple times :)
>>>>>>
>>>>>> Unlike zswap, physical swap in is not necessarily exclusive. You load
>>>>>> the page in memory, but if the swapfile is not full, etc. etc. you
>>>>>> don't invalidate the copy of the data on the swapfile. At reclaim
>>>>>> time, we notice the page is not dirty, so we just skip (z)swapout.
>>>>>
>>>>> Oh right, I forgot about that, thanks.
>>>>>
>>>>> I still don't fully understand why pswpin is significantly increased
>>>>> with batching here. I would hope that with less LRU inversion we end
>>>>> up with less disk swapin. Probably the test access patterns are just
>>>>> too random compared to real workloads?
>>>>
>>>> Maybe more time in zswap for those tail entries left behind with the
>>>> smaller batch?
>>>>
>>>> That's a 32 entry window that could zswpin with the smaller batch but
>>>> pswpin with the larger one.
>>>
>>> Oh I was talking about going from no batching to batch=32. pspwin
>>> increased by 387,400 (~30%). We are writing back 272,880 more pages
>>> but we also have 209,837 less store rejections. So overall ~ 63,043
>>> more pages should end up on disk, which doesn't explain the increase
>>> in pspwin.
>>>
>>
>> In my previous runs, I also collected zswpin. could the following
>> explanation help account for what we are seeing?
>>
>> Assuming stress-ng maintains a roughly similar memory access rate,
>> batching flushes significantly more pages back to disk (meaning pages in
>> the zswap pool are evicted faster, keeping zswap pool residency lower).
>> As a result, when stress-ng accesses swapped memory, it is more likely
>> to fault pages in from disk (pswpin) rather than hit zswap (zswpin).
> 
> We are not just writing back more pages to disk, we are also accepting
> more pages into zswap. The whole point of writeback here is to evict
> colder pages to disk and accept (relatively) hotter pages into zswap,
> as they are more likely to be swapped in again.
> 
>>
>> In fact, zswpin in batch-32 dropped by 143,425 compared to
>> baseline—which aligns with batching having a lower zswpin and a higher
>> pswpin.
>>
>> To be frank, under the Test Case 2 workload, we cannot strictly
>> guarantee that the total volume of page reads and writes remains
>> consistent across all three runs within the same time window.
>>
>>                        baseline-cgroup   batch-all-32-cgroup
>> batch-all-64-cgroup
>> shrink_worker wakeups       7,238             766                 367
>> shrink_memcg calls     12,059,142       1,961,194             983,878
>> written_back               28,277         301,157             327,997
>> zswap_store calls        1,349,572       1,168,190          1,114,549
>>      store succeeded           492,861       521,315           459,246
>>      store rejected            856,712       646,875           655,303
>>      store reject rate           ~63%           ~55%               ~58%
>> pool_limit_hit             510,130          50,096             57,715
>> pswpout                    884,989         948,032            983,300
>> pswpin                   1,251,268       1,638,668          1,878,453
>> zswpout                    492,861         521,314            459,245
>> zswpin                     309,631         166,206            84,977 <-
> 
> One possible explanation is that we are shrinking too aggressively due
> to concurrent shrinkers. That's one difference between hitting the
> global limit and the memcg limit. There's a single global shrinker
> that all store failures will just wake up, while all concurrent stores
> hitting the memcg limit will start shrinking.
> 
> The other explanation is that, as I mentioned earlier, the access
> pattern is just too random and we are consistently refaulting cold
> memory. I am honestly a bit concerned about these results.
> 
> Hao, would you be able to try re-running the test with a single
> stressor? It would help us figure out if concurrent shrinking is a
> problem. It would also be useful to increase the global limit, to
> isolate writeback from hitting the memcg limit. I don't think both
> limits will often be used in conjunction, at least not in a way where
> both limits are hit simultaneously.
> 
> It may also be useful to run an actual workload if you are able to,
> like a kernel build or something, to see if the access patterns change
> how much we end up swapping in from zswap vs. disk.

Apologies—there was a flaw in my previous test setup. I had configured 
zswap.max=320M alongside max_pool_percent=1. Since the global zswap pool 
capacity was roughly 314M (< 320M), the global pool limit was actually 
being hit before the cgroup zswap.max limit. Both limits were likely 
interleaving throughout the run, making the results difficult to analyze.

Re-running with **zswap.max=280M** yields results that align with 
expectations:

Test Case: zmax280 stress-4 pool1%
                             baseline        batch-all32      batch-all64
   shrink_worker wakeups            0                0                0
   shrink_memcg calls         698,990           57,187           29,649
   written_back               655,570          865,131          883,508
   store succeeded          1,054,928        1,124,990        1,190,608
   store rejected             229,722           22,642           11,659
   store reject rate             ~17%              ~1%              ~0%
   reject_reclaim_fail            110           15,454           12,985
   pswpout                    885,437          888,027          895,478
   pswpin                   2,035,415        1,305,341        1,384,751
   zswpout                  1,054,928        1,124,990        1,190,608
   zswpin                     280,675          162,684          158,556

To isolate the cgroup zswap limit, I also tested with 
max_pool_percent=50 (which should behave similarly to the zswap.max=280M 
case above, bounded strictly by cgroup zswap.max):

Test Case: zmax320 stress-4 pool50%
                            baseline        batch-all32      batch-all64
   shrink_worker wakeups            0                0                0
   shrink_memcg calls         687,608           54,002           28,116
   written_back               639,176          846,663          862,347
   store succeeded            992,816        1,208,123        1,213,286
   store rejected             231,431           20,425           10,915
   store reject rate             ~18%              ~1%              ~0%
   pswpout                    870,745          867,360          873,553
   pswpin                   1,707,823        1,216,814        1,378,381
   zswpout                    992,816        1,208,123        1,213,286
   zswpin                     250,220          210,791          185,716


Finally, here is the dataset for zswap.max=320M and max_pool_percent=1 
with a single stress-ng worker (stress-1), which also looks consistent 
with your expectations:

Test Case: zmax320 stress-1 pool1%
                           baseline        batch-all32      batch-all64
   shrink_worker wakeups        9,279              980              557
   shrink_memcg calls      14,247,647        2,638,751        1,465,915
   written_back                 7,702          439,809          482,809
   store succeeded            329,603          531,224          566,150
   store rejected             883,945          517,578          482,644
   store reject rate             ~73%             ~49%             ~46%
   pswpout                    891,647          957,388          965,453
   pswpin                     692,255          628,246          582,781
   zswpout                    329,603          531,224          566,150
   zswpin                     248,871                3            7,872

Thanks,
Hao



