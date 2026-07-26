Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 171FAC531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 02:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC026B008A; Sat, 25 Jul 2026 22:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D606B008C; Sat, 25 Jul 2026 22:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346C06B0093; Sat, 25 Jul 2026 22:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC0EC6B008A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 22:39:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6972F160182
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:39:21 +0000 (UTC)
X-FDA: 85029371322.19.128204A
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 887E880002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:39:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="U07TGis/";
	spf=pass (imf02.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785033559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW+wiTCoYSaXX59UFoOal4WDMR2PcNiHO7r7ABZvv94=;
	b=4Z1lxvxFihzpkOouo5Zi46auJSxWs5DbOF1Ro++jCmkW6eKG6GRntbgJEp5dax9eM3FhJE
	jAXEenRO/G6R6ThfHeDAnKYGuQRajXf4ctOpmEj+QOLf6xostwKuOZpcezfPRCgbNChUQ6
	3Q8A3qxHbG86TOnmxACJY9r14bLzVxU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="U07TGis/";
	spf=pass (imf02.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785033559;
	b=Xgs7ud1+WeF5F/hTbJZ5PygnA5WCejQZsrKVpo3bfUoqbcJIRbqvtwRa/MFbC8vgTp8F6D
	/GgLhSmjSjfMZDFwCwCQyGp2EWdidpQm8RuWKJEvwb8bnFSyRK/kGRdF2329w9qpDEqINa
	sH9qSc2qYyqsJ1Gy+yW3IPcZ5DISzec=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ceae1ed204so16725435ad.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 19:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785033558; x=1785638358; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tW+wiTCoYSaXX59UFoOal4WDMR2PcNiHO7r7ABZvv94=;
        b=U07TGis/wnHSMMbnL6FLGf3Mu6qvufXdukyR2E6tjV+4ZF7GgpRk++tpyn4YiN0s6R
         4Aqdx1U3A8tYRNWaVALHCmIJ38PuXgY0wibKXBV2R49sRN3HA65WDajzs4fxEhyi7vmC
         48KoHpD4ytAPfTWmLdGBa2hxyrFSrSe5koBGDeymSZip0hn1IWylIS5u5BIXjFZLNWwd
         HuP5K9oaOlOxHBkhbBcceH1DqoNQHYOkvUZPV6IgZFJNFg85NztWnSUu53y3+hrof4tA
         VVJvNvNrYbqlLkxCrCMgHgwElaNZbVRMGYcuN545aY5riKTkh84jdW5LAuAYctSrYv/8
         j7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785033558; x=1785638358;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tW+wiTCoYSaXX59UFoOal4WDMR2PcNiHO7r7ABZvv94=;
        b=TJ+n7ymt0pLD57UZ38KJRoxmVsNL/3zzU6r7Z4LLkDzul14Ex66IyQENXYHMM+tvrM
         KPcOAASEdOuM9+smi0oV5hgch9rRK2EkbFjFSCdNZ7NLSrncEoeFx+K4xwnJGO61EyRt
         1Uxj5Vchbn48vf18YzRwS/qQc8VbSWeYqvNRULhnhHixVU7MP1WxmYuOqhL1yY69pfaF
         ObxC+IKpjDZXBTB54BQH+nMEwkxh79s89bigzJyKNd1t9bhRDQHKdNnhAD1o5phCbBUj
         FPtItyydf3MtQ6AKWCV7euszQ/Qo5LZ3SlrsM4AZ5z9Zcu/FdDiMU35y0E9lvJWJsQdk
         PFbg==
X-Forwarded-Encrypted: i=1; AHgh+RregLNp7etLxpgw5DsfKuO7jA9ajF2ayyzEkQeZhXkUse+OxMwnQVY9wf6P9Csu5rzWLoXhPBwxNA==@kvack.org
X-Gm-Message-State: AOJu0Yx4vJDYp7gIptHM9z12ZqHhoJZhf2Xev5BMFMreN6e8hNAPSWid
	2Lbrwqynm8rULwLzSIBo19kx4/Am4I5nlqSOrolOwg3qc+vfYBVL7Vy+
X-Gm-Gg: AR+sD10FxAkD5U2N28mXCRSksA20lqJFvyjLrH7Qqznn3Coe/so70wZhMCWGefLZ2j1
	Frg81zBe/MJfTaLL8SUYKq7wqB9zqsiLrPHnieTUEUH8An4gEZr8OmnZyqnwEyTpxa4eVeI5i+y
	ittXQ6GVC1YlQpcGe0NLnDTsQi7mriYr5OA7ZFGAzW7bqW+46ChBJK+j4KtWlJKekYyN6G6wtf3
	zLlPaF6FqlOc1+igM/xI3IAoFoKuUdbifKkECG4jHtx0xwWjxgHchIbFlfiMChnGMPuCwgdA9V4
	ArNOOuKvFb0QAiPRy89BJTPR1uFOP0r95ICWgBFs/6P4DhsrDwI9/DSUHlyfzcSLnruoiOy2D4l
	uOcpEc10G0E2j0eLNFXar01NAcgGE4enf8KPXXQpVHb/HTPAiK4uiWfLh0KeOgptk7SOTL1g3ky
	49lVP9vbzgL+TPgrpOl06hcQ==
X-Received: by 2002:a17:903:1aa7:b0:2cb:2b84:f431 with SMTP id d9443c01a7336-2cfde8a6856mr36446495ad.47.1785033558387;
        Sat, 25 Jul 2026 19:39:18 -0700 (PDT)
Received: from [10.240.225.60] ([114.111.24.203])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc585sm15263525ad.51.2026.07.25.19.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2026 19:39:17 -0700 (PDT)
Message-ID: <f60fe501-7605-64dd-0572-77f7f3060f35@gmail.com>
Date: Sun, 26 Jul 2026 10:37:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
To: Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, tj@kernel.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
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
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zMgVmgQET+PUGexAgNqCZavA2YoTTXKSbWWoUv=A=ytSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 887E880002
X-Rspamd-Server: rspam01
X-Stat-Signature: n9cw4rqrhsbzw6swuuosxupnuyu43878
X-HE-Tag: 1785033559-957359
X-HE-Meta: U2FsdGVkX19mJq1IhxLrMkfq1HBiWZBi+wObyvuf45f4fKmn1jyvzGRECd6ByuEyIZ8IHFuPPfWy3g8vMHsSbwU1nqn2ccT0L5sNcuQVVYJQs3IPLxE/DDnVcZg0HsM7AxnI15M5YWT7R7/qrVVTliPfl4Esd8GXRQedF6GeslpA9ec6hb+ES2omdolSwZerNme7cfmlfRoqiFIYZXU6Dq1AzmLO+bZ5Vz+VeEE/JiJaWyi1p6o8HhFPs2wKIzfeZql/bX+tBSm/yipBgif5GYObxmAFf8h+tx52LVHqKUqrYnrdX7iIqF7J9Ft6xskMrA4FjWd7/IEaKRaNvGdwQF7XAx1IbFgxl8J5T3QjyonwID6bbtsfz55TQD83oyE3Us2eqhYdC5KZCP+W+Jn+FQWLHnTTwSVlnTPiX5rDLGseiGKxQz7kcHxsZ/h8RJ8NCwJz9DYhRrVkwlQCox7jVnpUG4qCSns6f5MTaDn3ioy+3L4xRfJLB7RhIh32PC+5KVt9ikS/8Bch/sICexKjYm8BONZJVegdiaJo00ZwNPO1SJlh3HWTthUKcDULU00V7+/pVf+WZp4SdhAJliEQflXNjyx4dI9Jl1xfGjhW002stmpCeLhYJ3Aj4YG96RJBab41dmZYEmTdjV9YGAeFA2X0fBBEhlPB+nrlQDX5sv6nt6SYrsLH5LO/JbKZxu7Q2cPPMN4hwl7cjsir6DpAgW71rSI50LCBKOlk/WfgGZ8uR1A+dOX33Xwn8atH0cdS+AaZPT/6b1tlOkip7ZsV43o6b/UMmJpz44wLHNt7uoW/Ath3CN9XcHY0q0nvq4JNwx4IlyXBrr4BKcIKwkdvezxkZpsabRvNN7JP6fCzu2RqUXFf+oob7WjX4MSE0XNSdvFTjjV4p4NFJAmCeHLPMakh7wBiLzwsmDNqg+OSlm44J/sLQKxjXfUE9sss1eJ8gxeacLazJgR2hCrqY0T
 8KtT+Pqi
 usY7liKuH9ANskF04KIlnN8Fl8dO8C/I5dy5ujtTqDGnmL14aVzt4Z1DnwVZdMICc9nGsyYkz6Djzxs+H9Olfgz/vcKPNA7ZYu+owHtE3kLvHVyi3T9NqI5qKU4ce7z2aDu484NNHMoWd39lddfSET23ESSLvVhLKsl5tSkFqaZliUPgT2ggeBhBDGMYL2a2Ft3wtI0ZVCiVmwHt3N8zgSecfSOqTHODqC8M2VRbg9x858WPvOkAq41HPnhqXx1iix6TESzdH1dr2iuhOR1mGB5H76FQMTYYrQlPkjxnnGFigs1kf5JleHh4635F9UosASfMmP5STRQJhbzDOlX9l91lrIXFG/bvOfK6iAvqjIIFxS25yj+NPUCDLYPTOH+Gq1r9ainUGNydNS9eiDuNsPg2dU1OFTt4zoX5U05DxAFgPQP8SLNwXZh0gb8EH8oLLa4XhnQM8o4UI7270/2R9m4OeNY/BoW3adSksSPp2o01D9C6pxdYykGtdAUYgGxQ+GKF4AKIJ5XJ5CDYpH3HI1easWORSOOviOjnj5+7f/O5pemN8YEeHEW7m7YAlPgQTty78bdmzsYKVooyhME2T2Xjcm7ilYBywdQFcK3pudic4TRY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/25 06:22, Yosry Ahmed wrote:
> On Fri, Jul 24, 2026 at 12:35 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>> On Fri, Jul 24, 2026 at 11:39:41AM -0700, Yosry Ahmed wrote:
>>> On Fri, Jul 24, 2026 at 11:37 AM Nhat Pham <nphamcs@gmail.com> wrote:
>>>>
>>>> On Fri, Jul 24, 2026 at 10:57 AM Yosry Ahmed <yosry@kernel.org> wrote:
>>>>>
>>>>> The numbers generally look good, the store rejection rate is
>>>>> decreasing and we are naturally doing more writeback which makes
>>>>> sense. The store rejection rate actually increases when the batch size
>>>>> increases to 64, maybe aggressive writeback is more likely to fail and
>>>>> cause a store rejection, so that also makes sense.
>>>>>
>>>>> The only part I can't immediately reason about is pswpin. How are we
>>>>> reading from physical swap more than we ever wrote to it?
>>>>
>>>> The same page can be swapped out once, and swap in multiple times :)
>>>>
>>>> Unlike zswap, physical swap in is not necessarily exclusive. You load
>>>> the page in memory, but if the swapfile is not full, etc. etc. you
>>>> don't invalidate the copy of the data on the swapfile. At reclaim
>>>> time, we notice the page is not dirty, so we just skip (z)swapout.
>>>
>>> Oh right, I forgot about that, thanks.
>>>
>>> I still don't fully understand why pswpin is significantly increased
>>> with batching here. I would hope that with less LRU inversion we end
>>> up with less disk swapin. Probably the test access patterns are just
>>> too random compared to real workloads?
>>
>> Maybe more time in zswap for those tail entries left behind with the
>> smaller batch?
>>
>> That's a 32 entry window that could zswpin with the smaller batch but
>> pswpin with the larger one.
> 
> Oh I was talking about going from no batching to batch=32. pspwin
> increased by 387,400 (~30%). We are writing back 272,880 more pages
> but we also have 209,837 less store rejections. So overall ~ 63,043
> more pages should end up on disk, which doesn't explain the increase
> in pspwin.
> 

In my previous runs, I also collected zswpin. could the following 
explanation help account for what we are seeing?

Assuming stress-ng maintains a roughly similar memory access rate, 
batching flushes significantly more pages back to disk (meaning pages in 
the zswap pool are evicted faster, keeping zswap pool residency lower). 
As a result, when stress-ng accesses swapped memory, it is more likely 
to fault pages in from disk (pswpin) rather than hit zswap (zswpin).

In fact, zswpin in batch-32 dropped by 143,425 compared to 
baseline—which aligns with batching having a lower zswpin and a higher 
pswpin.

To be frank, under the Test Case 2 workload, we cannot strictly 
guarantee that the total volume of page reads and writes remains 
consistent across all three runs within the same time window.

                      baseline-cgroup   batch-all-32-cgroup 
batch-all-64-cgroup
shrink_worker wakeups       7,238             766                 367
shrink_memcg calls     12,059,142       1,961,194             983,878
written_back               28,277         301,157             327,997
zswap_store calls        1,349,572       1,168,190          1,114,549
    store succeeded           492,861       521,315           459,246
    store rejected            856,712       646,875           655,303
    store reject rate           ~63%           ~55%               ~58%
pool_limit_hit             510,130          50,096             57,715
pswpout                    884,989         948,032            983,300
pswpin                   1,251,268       1,638,668          1,878,453
zswpout                    492,861         521,314            459,245
zswpin                     309,631         166,206            84,977 <-

Thanks,
Hao
> The only explanation I can think of is that the test is just randomly
> accessing memory, so it ends up accessing colder memory that we moved
> to disk more than hotter memory that we kept in zswap. IOW, the access
> patterns do not conform to a "normal" workload that benefits from the
> LRU.

