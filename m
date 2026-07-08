Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 306DCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB236B0096; Wed,  8 Jul 2026 10:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D0D6B0098; Wed,  8 Jul 2026 10:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191696B00B2; Wed,  8 Jul 2026 10:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3DF66B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:15:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73A1A16817A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:15:28 +0000 (UTC)
X-FDA: 84965807136.29.E21E554
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id B609120002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:15:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AdA9oPzn;
	spf=pass (imf03.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783520125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idL2Xz0mU2qCcJAvF4YtSgzLnoGRC91n4WDotTzDTTc=;
	b=EXilNHCOv4ymoZ269J4Vs0cILd9lUdeT4MxOI4jzDg1PDtJBtxW7DszmPiogQhvU6VnLuq
	T/KPwJHw23jAkFCiyoULg5Q3ynCF5io8HfkV6ZdRol6RgWCl3D9a2G138wraDMAwSKfGoy
	ZmyW1Ll/Av9EaptK55jDyxSVcVYhZwU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AdA9oPzn;
	spf=pass (imf03.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783520125;
	b=3kFfTh661lILLhymJtXZ/XbbVumFYlqj7fmEobg3iw+t4hLBD+Y9/DODh4wWufcBC8q9As
	SNVzL+6IK8ekNoVmdeeVcIeFxGXbp0TFE6v+N/E9PmxRDKJXRecBFG/ANWM1Ga4Y0MmR9t
	gJQFIwPDdaHsmJlS7O8keH8T0AzBUZo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cca24023edso11073915ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 07:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783520125; x=1784124925; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=idL2Xz0mU2qCcJAvF4YtSgzLnoGRC91n4WDotTzDTTc=;
        b=AdA9oPznBkgs++vBVURtp3pO1wBgGLg5zHbI/gTyc3uVNnHpCDOIgfyLD1Q9OILx3Y
         4xn3kv5k37ms2LUerzx4bFDUgMOxzLfi6r5TJ95uRGHxhPkO57xhQaZRMbHaP8jMfYxz
         F6twDENJ3E0YksX4l85HfrtKQrUm7/0out+rAjzFJjCI5p4LcIaFsMF2sZCuQdwGAEol
         g4CRqlAwhfWMaZV67EhZCuT81REOHLdq4Dgi0A1aP68Qn3x+nUkmgoL//aKkYHUzf1v6
         At2x4DlZGNMDYsEqnkkItxXtgaq1XD6F4L8cXknHJ8nfl/23l4RHfkQe84UxDF3KzCxm
         rCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783520125; x=1784124925;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=idL2Xz0mU2qCcJAvF4YtSgzLnoGRC91n4WDotTzDTTc=;
        b=KnVZnICY//3R6jzFNmOob4AaIwKO/Eqq2OiveFU9fj1WTaKZrK6qydBLvIecL/DMxY
         S4G1dv8u+R1qzK3U2jPb1tOh8rPLwxfG7J7lFHvMsUhcUHPjE1JAINToP2nZh0nSCskb
         f1aHNMPh6TjoXN8DKYtxNio9PB4W7rF0DN1/pQNdHdMx2089f4Di3GDFcT1mNA1uXquX
         QpvPmaqfwXEbMxQH0GCINvyTXRUpIiHxWRsEgPYX/92YzyuXAJeXqsi2Sn8dYSdktlmK
         YmCHijnJMn3v3QXQWMAzPGBvcRVJhgPSNcJGG4Xe/EJ4yZWZDfXkCULWpscxJb23Ea+B
         uZYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq0VmJyfX6DIyqyAcXIT5KdEGRiafRBmEWKfy9Lse0VbjAhLk4iWaZ3kjQF0ZZxnD7Z8S2Y4uhLMA==@kvack.org
X-Gm-Message-State: AOJu0Yz9SL313aPUDeauHBfFBX4JYKUukIYGgKB5Tp4pyiRzIwuRrWqc
	KlkppwWnyRNuw+kgUZlHumPg38nL9OYCHicNSVGmYz1Mwpljp9zFOMkh
X-Gm-Gg: AfdE7cn+7OdCyCOaUJb/5jHmhdgSTuQ0g5FtcZnQZ4ncFPZSNFodYoCY5Fxn1ii64Td
	tZv4nf9x+uo26p4L3FtkOEyckJoZU9/7ZOinoRzqQns0Wd6gLxHVHZG4qySlZsa01TtZX0fgxxP
	eZpIPTu0HzoQtdxN0wvTx9DVjKdjLZRncfD4DX0wK6Mtg7RyGlU17vH975tlYY37VW5Zd20ZA8t
	2f5ZkR5YIl0c3TDrT2b+CEGF4/XPLeskEehs/otq6z4Jo2W4zlYmd4sQwTjEaKRrhNKOy/g2+oL
	vvai4haIbzbI8whLTArsf7TWtmJh1LOzAnxH3CiN1YHTnhk+aUfNkR7SWyFxlkQTUk8gLBw5RVG
	JH+I3wnEKjFTvFIjVZedMlkiBcsaS6an2kBFg3yW6iIYhsSSTJG9nCnxarv1k0mx1Qpq/NEd0Hg
	T06WxmEz2mcejwbk1UyawAkU8gQqV+IxH9drW7k3RYp43q
X-Received: by 2002:a17:903:3c67:b0:2ca:9d5a:8b6c with SMTP id d9443c01a7336-2ccea37d246mr27168615ad.5.1783520124216;
        Wed, 08 Jul 2026 07:15:24 -0700 (PDT)
Received: from [10.125.192.148] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9c21429sm29047715ad.37.2026.07.08.07.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 07:15:23 -0700 (PDT)
Message-ID: <bf14cfe5-e98e-c20a-231e-37b3a2489040@gmail.com>
Date: Wed, 8 Jul 2026 22:15:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com>
 <akMJ8UfeZXrVe5LN@google.com>
 <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com>
 <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
 <4ec2bd64-af40-8ebf-b8a8-2dd7421a1100@gmail.com>
 <5ce4035b-7f56-d1d2-2d2a-668446d870e8@gmail.com>
 <CAO9r8zOLe5eJfNmoszCX3rtD=6YEa_7xrvDV1acVDOtZg4vWYA@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zOLe5eJfNmoszCX3rtD=6YEa_7xrvDV1acVDOtZg4vWYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B609120002
X-Stat-Signature: 7dcadiczyba41ojbsx4uiujo6ui1a65n
X-HE-Tag: 1783520125-410912
X-HE-Meta: U2FsdGVkX186wLPgeN51t6FpnuZljClqxW4ZH+99ob7JBBVxp37wtbkGhRGUWnnFnlKgwzeHVmdNOG75xGvDwn6dNXy35XaAYmn8cGWuz02zItFcDyiy1HDYwPRLs4QYM1K2EurOLPSPc1RnElmM8buHWgquuzEpN7Ye5azjMdE71XB/9tjTKwBm+KLmflyCaCg3vqBXKEv6dK+Y0nRLSz6sI8akWDpvS84v/AM62PJmBeY3hH11qNMSgDhFZCLiS39AldVX1ylRsp4eh5udohUzp9GjyqgN9dOiFlGZiaXw35o6z40ouZSUR5x4uMxYuZQi7MAixUte/FG1r/Hnvk48CiXchQwWRMh3fAwSLNhm1mPqVp++ACfDUqPYe6usjN5T9G1cJDc+fxTa/BEw7nzCHbXo+r5gosuX++k4jiaC4D/rIgWpmHjrf1+qk+sScno+Ydc61NfFJ33vxEGaF34MGauez7e1BmnCzB2IK6nZ5+PM0omnvVjL4h2BsXgk5DJczu4GjrMjMGRH4FM97/T/ctUEgD1LlAWypYhVPhkcxF2UCKFx4hkyTKIhUSqBznWRwwRgqe4jYyIaG3xbGs9mLreC5HAnNrFyJQKbaQXCqkzXVOQFwEEQfKXHX0gfssMqfvSXyl2LGi8+oojxtLlvWELll506ORe8M02cEh5ctqKjREjpqrvss9qORJALrPlfWP6esQw61O7bUtE0S8eipgpNxI42wRb7YGccGT71QQ+fgxCgW/ifSD8oe9pmTEzHZZRMNJ0Z2WpQFaL72DPj7dFU0NpspsbCPt9g3WsNPIoQrqFWVc1bvc1eN2MPBfxNrJrz3hgw03Da9bjH0z5qnwf5YqJjn1FcIs/0xqA2RT8UEFM7lAB2If1RXEUPQUtcY+3JheAHPZOeQBEp6qQb5znXKaBJT/JlHOI/MFE0K2xihL5ICxIN0bHIpBSqZQlaJkRKxUdtt9Di5Pu
 xlQb2bQI
 fTltjft5VnBntkMoZUPTQtD55QGf8fLPpTWB5Xd6bRikwOPTpwQxVWpBJ4sO4aN6ShuNfndL12zbzPttgEx8uKA5Bzum0UdzOxOymT361St6155VyeJBxAuylVxJ9VbMQiX8FT2TGzf3JDlLjYc0/1J2P973EwrrBgKtQFAmvWuZOQrYPJSQzpgMU2y4Qnd1AKycvbaA2DVtlE5KgfuXBrdLa3KBRmSr4OAApOFBuf7jRC37omfBXIq5HZRIk02GNfFpBvyHb0jvKa6r2WiBP1qHeilv0m/puJY0yYzzwupMIxR91SvWhqZHs9HuKpZhBINjWUy6S1xhfui93a4GT6OyfrnIhXVe6VYeGllZwhDoRCjD1NnPOAfF+k+gAad05D3vIhp0kg+8ctZ/eyhxibobYGTtpbMJ80PCvYYByCWaH4VI87HyjP+W/mJziS4TDgIQBWDojKwTc0lxDTWM0fChEttuxfOAewKQSWtgbnICg1wo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/7 03:33, Yosry Ahmed wrote:
> On Thu, Jul 2, 2026 at 5:32 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/7/1 19:45, Hao Jia wrote:
>>>
>>>
>>> On 2026/7/1 00:10, Yosry Ahmed wrote:
>>>>>> Before going through more versions we need to figure out if this will
>>>>>> pivot to be a proactive demotion interfcae for swap tiering.
>>>>>>
>>>>>
>>>>> Yes. Should I drop patches 4-6 in the next version and wait for swap
>>>>> tiering to be finalized?
>>>>> We can try to get the non-memcg parts (patches 1-3) merged upstream
>>>>> first. This would also give them plenty of time to bake and catch any
>>>>> potential regressions. Thoughts?
>>>>
>>>> Patches 1-2 can be sent and merged separately, yes. For patch 2,
>>>> please include some numbers for the writeback performance before and
>>>> after batching.
>>>
>>> I'd love to collect some performance data. Do you have any recommended
>>> benchmarks for this?
>>>
>>
>> Perhaps the following test case could work?
>>
>> Test Setup:
>> - Total memory: 32 GB
>> - zswap settings: max_pool_percent=1, accept_threshold_percent=50,
>> shrinker_enabled=N
>> - cgroup constraint: memory.max=1G
>> - Workload: Run the following stress-ng command inside the cgroup for
>> 120s to
>>     continuously force zswap store failures and trigger shrink_worker():
>>
>>     bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>>     exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t
>> 120s -q'
>>
>> The following comparison results were collected over multiple runs via
>> bpftrace
>> and the 'written_back_pages' sysfs interface:
>>
>>                            Baseline         Patched
>> ---------------------------------------------------
>> shrink_worker wakeups       5,587             878
>> shrink_memcg calls      7,823,853       2,347,320
>> written_back                  257         781,214
>>
>> Conclusion:
>> Under the same workload and duration, the patched kernel shows a
>> significant reduction
>> in both shrink_worker wakeups and shrink_memcg calls, while successfully
>> executing a
>> much higher volume of page writebacks.
> 
> Hmm this is actually a bit concerning. Yes, we are invoking the
> shrinker less, but we're writing back *a lot* more memory, orders of
> magnitude more. We are using a batch size of 64, and making ~1/3 of
> the calls to shrink_memcg(), so the number of written back pages
> should be ~20x more, not 3000x more? I think I am missing something.
> 
> Also, ideally, the batching wouldn't result in significantly more
> writeback, but a similar amount of writeback over less shrinker
> invocations. If we are writing back significantly more pages then the
> batching logic is probably too aggressive?

Apologies, I think the test I constructed has a bit of a problem. This 
test has very, very heavy memory pressure and is already a very abnormal 
case.

The zswap entry returns the first time because of "second chance" after 
setting referenced to false. For the baseline, it scans 1 page per node 
each time for 16 loops. During the test, shrink_worker() basically exits 
at about 16 pages each time.

Since stress-ng periodically and randomly writes to this 4G memory, it 
keeps triggering zswapin and then waiting to zswapout new zswap entries 
after falling below the pool threshold. When the speed of zswapin/out is 
far greater than the scanning speed of shrink_worker(), a large number 
of zswap entries cannot wait until the second scan for writeback. New 
entries are stored on the zswap LRU list again, and the referenced of 
the new zswap entries is set to true again. During the test, it was 
found that 99.21% of the return values of shrink_memcg_cb() in the 
baseline kernel were LRU_ROTATE.

For the patched kernel, shrink_worker() scans at least 64 * 16 entries 
in a single pass, so it can trigger writeback during the second scan.


I have re-tested using a more common, reproducible scenario:

Test Setup:
- Total memory: 32 GB
- zswap settings: max_pool_percent=1, accept_threshold_percent=50, 
shrinker_enabled=N

Test Procedure:
Allocate 512MB anonymous pages and fill the data with random numbers (to 
avoid compression), then use cgroup memory.reclaim to force 512M 
anonymous pages into zswap.
Allocate a 4K anonymous page at an interval of 2ms, and then trigger a 
reclamation of a 4K anonymous page through cgroup memory.reclaim. When 
the pool threshold is reached, shrink_memcg() will be triggered.

The test data after running for 300s is as follows: (it will eventually 
stop writing back because the pool threshold is reached)

                           Baseline         Patched
---------------------------------------------------
shrink_worker wakeups          5126            85
shrink_memcg calls      11,003,734       173,420
written_back                40200          40233


Thanks,
Hao

