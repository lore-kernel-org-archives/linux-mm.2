Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEADBCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6BE6B0005; Wed, 13 May 2026 04:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E786B008A; Wed, 13 May 2026 04:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3EF6B008C; Wed, 13 May 2026 04:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8ED96B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:04:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F9CB1407C9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:04:58 +0000 (UTC)
X-FDA: 84761660676.19.6E1D329
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 95621C0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:04:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="G/om5l2u";
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778659496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1dxIimePE2VOkjQz2/ma0Z1DDa/BQxq5kyPGrdKr+k=;
	b=uIK0vFcyC5sQXdkp53obfCTF2lh0WyBGJReW2aPPFgBYlcp9/5fv2lQnlihmGl0WUJH6LL
	xlGJ4EWGugUxD9Gak933zoWHTk/JZVZuO3TSNA9dn7fTvrne688PWWISS+YP2/wzQ0PXd+
	2aYGR9QhSu2KERWU2Y3afHeXSoulxGE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="G/om5l2u";
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778659496; a=rsa-sha256;
	cv=none;
	b=F/4+5Cq4TQP6+9RWqFqmCEjOGeG4S42Bba1AXTViL5HSJYWuQIRtRACj6S5dq5b9uaHsev
	JMyROvL8z6FO0D2V4P+p0SX40B+4DcostMNp3MbrCwvaNXDsuu03sScJKLexqHMsDEhsYh
	QjL36S1H/UZVHpiGfxvrWm9MYrQgHXo=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-367c2a39fcfso2347008a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 01:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778659495; x=1779264295; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1dxIimePE2VOkjQz2/ma0Z1DDa/BQxq5kyPGrdKr+k=;
        b=G/om5l2uIDoy4Vv4lqkDz7oGcT8CMo0rKd1sWQrw6ba+A8lw2JKlXPse0CranWttsa
         FhKZx3WSyR2vl95fFn+qCdmh7orEKgbtUz89m9B+Yp3IlFAEqKVQ0ffL1GIP0O6qfhl/
         ZXZWk0Qa/gWzfPZRdGq7o7qshvLSRG4/ceKTXqb8UyBILDjmQCnLyn8vcfUFuPyNh+wR
         YtuiRs11LDY638UQO3AspFbBM/jlAmvvIM8oLAW2OmpYtRukoE3lUe2/+4MvAkN6UUds
         5hwE1mbPKfa4scWptENJfSH8Gx3gmuFGLovc/jvLoL4p0EX00gtdVpuwthTYSuSONR/r
         rAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778659495; x=1779264295;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y1dxIimePE2VOkjQz2/ma0Z1DDa/BQxq5kyPGrdKr+k=;
        b=WdHbqVHGLQLjeE6YxKTQhSH8YZoHjOLDbSt3raLfP/FBAEoKijLhYmoBVWaLGvHHCg
         eyr+JaVU+ifuvWKrIvELZSKLzCwFfNEy88DP0YrTymYixJYIMA0pv815ezdD0CyXSaNE
         aMK8bvhRbN4jpCtgE/QBb/ISBir0RgA/NEAmOmu/AxHVbWN7qhYiFQN/b1715Y5q3MgB
         B42cLSGtMgqSeXfKxrZoJgpR0j3kzUgt93iy3gJb/drlxAFWEqdqLh7rRmpiShCLvLn/
         K28n3S6g5wQnlzXPNGBpuC37KaDM40HyRz/x3X1NMvKCOSEEKwzzpC3hprFSvBmelt/g
         2iSQ==
X-Forwarded-Encrypted: i=1; AFNElJ+PBZ0EP5sU9/L9qWRn8RZJU3U7ESA+JHRpB26dNqkfXG0deOqhQPmPiC03+kFEWWDqcHprSs8RhQ==@kvack.org
X-Gm-Message-State: AOJu0YxoqcWOKn9g/amZ4cjQZl3K+CtOpZrOMLaWVcTGVIncG9LtXVIR
	qKHNwJU9rQeNmYtD0lqjBOSeKZ0jQ6TodLacVhbbMpbpo0ezdLvgvV4Y
X-Gm-Gg: Acq92OFNQ8FDKwR+D3ckQPQNlsrlZqmEaEhnmjDadzS6m7kigm1DKxgXskNDPmx9HXp
	Q/woVrzIdf9seWUhfgMnmWLOPmdgWcH02yrlezWFyDoUL/pvEwg68tGofHciiatgrHL3qC2RrTJ
	7hm3sG8YNUUGXU3y14HeJMg9cwTb1AHDZZSO0JdJIb2KUcuyq1jLXf+gaIg+10TsGpRvk0Eyx6F
	xQFTh+nvUsQ8wX/CFnk1AP2aMts6VyAdy/86jjtBhC+i7PuDnoB7PVFB+ZsFMjo17kf5K1tacSU
	rbeJlAZ59bvcsnS+ZdENqNMG9+A4SKbBubmj1544HeSjKfyfNpEDMIiT9SiMx+b59i3cl8CuvWb
	+qWO7mvEqPL42hXTSUHrXUwSboXESRF6Vb/J6kSID0Uy0v1TKFPZWoWu6Q0q8y13O1NtKNioBd9
	3qOnzrewQ8O08KVi9yuXu2J6XVCd7R0GPFEGcjTVMaGVE=
X-Received: by 2002:a17:90b:3f8c:b0:368:ed92:6f5 with SMTP id 98e67ed59e1d1-368f77f6980mr1854188a91.4.1778659494907;
        Wed, 13 May 2026 01:04:54 -0700 (PDT)
Received: from [10.125.192.65] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368ede2d545sm2895850a91.6.2026.05.13.01.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 01:04:53 -0700 (PDT)
Message-ID: <6fc7fdf0-368c-5129-038e-623f9db2aa88@gmail.com>
Date: Wed, 13 May 2026 16:04:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>, Alexandre Ghiti <alex@ghiti.fr>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com>
 <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
 <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
 <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com>
 <CAKEwX=MOixJAUGiwUcMQa0Stvg-mR-MvpDRD8WA4YMtRvnUYTg@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=MOixJAUGiwUcMQa0Stvg-mR-MvpDRD8WA4YMtRvnUYTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95621C0002
X-Stat-Signature: tq84ejfdyxdqpxhsgptoc8zqf9f49rim
X-HE-Tag: 1778659496-272990
X-HE-Meta: U2FsdGVkX1/kmcUeesTgRet7rqKTJ4UXc7GvNIbOjX6ZiFzvyjXS6no1vMsLeWolCqdgdP65MBTQ4PT6vxPBKn9bOIyL08mFFVHft4Ok9ZDHqHcLCOM09r5/o+lGDDRrvbsXFxMBVKBxwfSq26ZHZ4/FAkPx9vAnB9Blog9Xausz0lCxiD5bRSRmGsqkoSIXUMHQWJ0fmlgSFkJd7B7pn8EW4T1GEH5eWBqvtDxgEOjFta+ZpoAUOuy9bkUo63aGPVveWE/ZbOg5OUXYMqc1H+84WPVoGz4uRFalqcvN3qslj7SAVF0006eio+9LdlG5HqSuy/vg1+kXGksDYCXZXEc/QNuxiQa+MfF5YwN5VgKLUM0exaO8ANUvcWTWi0u0sL32JMMTtl6R6CItSrGqHGbNc4IAEiyz86mpFwFzI9i+LeqRq1xPJIsnB1OLFDg/LhQu9WgetV01wR8+7C73sHerjCohqccwKyjYTLmLhf0UM+FiGJDU3l4obVyZ7qAgEdsGPRqjytn/gexTESx9hkyicl9LiklHdwmpViFsKArCH2Ycizw/Wal7mMqkTvV53KEVNP7Tfqgzz7neCtdL0FN84QoH1aCie8nuWI/guGNID9OUCrPW/fnpOQGXM0Wl0yiQczsmlCjIATzxAp+bdWoDfrY/t7Pe6Ngf8RoIY7i1u9GuRo36YiPqaHpFdwhSktfDR1hO4lHxC/Ry/xXzy8eEw60Mi/V4OZmkOcK3ZcCuNwbjdD+WzMTHQnmD8LLFigWrGpJ+juk6elayIpJwR+WwbjMf4EIru6k2BbbAwNbZAFeNZhziAIHDTVZNV2vdOGm3RnMXMN4gflJt3M2V7naWpmwV6Fxx7vmLJxRd/mOv3ppWZ3CWjHS8fqQ7MKoNJB4CdHVZa2BK9VwEArXUTT9UGY5eIaYSqoeVzBKoWLitzkHq+3RiietZ4yUzduvkfSmHdMtf3rDscbV9pqt
 6ikfvt+1
 6VLJ4LcbmlIdnP3NebqHzdPuVwj2sPXXYS0xJU3HOAXi/e+lPBsLjJeIV7XSgGBS/jJUg2jo5dSG48nB7T8lpJJn76hzKcrdbo+s3Iv3ygp5sujvVHGsLpzkWGo0dcZV81RN8XSGZzzd3PD/Ku4grA++i7jDRjguGk6/9YpB9dDeTMhunNxAjYG2NCU0PJ8ChSyN0q+YSM7EawAvlXN7qIFWNPxN6lM4J6WVyfLMZc2Zd5Cn40YP9x/ID4li1sMebya1G8ehzuoVyZFjtRYjE8Qwjryz50dXFPxAK4rqaW7DJhT0C91y+i2BkQPCTJWtam8Lre+6DTnDk6vTLCFHJfbGMTa7aJ6fzfCSGDjLEhvG2vRcq9SdCz/T66Ow9s4h6zTjHtuS5KseudeXrDFi9h5aQdnI77+rpktFFElAD/3FJ0znlN9O0jv/uGw+1TwLqjT5Ck0muYghjB+C+j5f7vFq63R9AHG2BY+J0ZWkcZNzsKfh9Weameh/4KS3kAAK7C46NY2NsoM9o2V3DMI8Ee96mFPAKv9uF3h2oQcWisEglHQJQDr2oGlAO5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/12 23:47, Nhat Pham wrote:
> On Tue, May 12, 2026 at 2:32 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/5/12 03:57, Yosry Ahmed wrote:
>>> On Mon, May 11, 2026 at 12:49 PM Nhat Pham <nphamcs@gmail.com> wrote:
>>>>
>>>> On Mon, May 11, 2026 at 3:52 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>>>
>>>>> From: Hao Jia <jiahao1@lixiang.com>
>>>>>
>>>>> Zswap currently writes back pages to backing swap devices reactively,
>>>>> triggered either by memory pressure via the shrinker or by the pool
>>>>> reaching its size limit. This reactive approach offers no precise
>>>>> control over when writeback happens, which can disturb latency-sensitive
>>>>> workloads, and it cannot direct writeback at a specific memory cgroup.
>>>>> However, there are scenarios where users might want to proactively
>>>>> write back cold pages from zswap to the backing swap device, for
>>>>> example, to free up memory for other applications or to prepare for
>>>>> upcoming memory-intensive workloads.
>>>>>
>>>>> Therefore, implement a proactive writeback mechanism for zswap by
>>>>> adding a new cgroup interface file memory.zswap.proactive_writeback
>>>>> within the memory controller.
>>>>
>>
>> Thanks Nhat, Yosry — let me address both comments together.
>>
>>>>
>>>> We already have memory.reclaim, no? Would that not work to create
>>>> headroom generally for your use case? Is there a reason why we are
>>>> treating zswap memory as special here?
>>>
>>
>> Apologies for the lack of detailed explanation in the patch description,
>> which led to the confusion.
>>
>> While we are already utilizing memory.reclaim, it does not fully address
>> our requirements.
>>
>> Our deployment runs a userspace proactive reclaimer that drives
>> memory.reclaim based on the system's runtime state (memory/CPU/IO
>> pressure, refault rate, ...) and workload-specific
>> policy. That first stage compresses cold anon pages into zswap. Entries
>> that then remain in zswap past a policy-defined age threshold are
>> considered "twice cold", and the reclaimer wants
>> to write them back to the backing swap device at a moment of its own
>> choosing, to further reclaim the DRAM still held by the compressed data.
>>
>> This is the "second-level offloading" pattern described in Meta's TMO
>> paper [1]. zswap proactive writeback is what this series introduces to
>> address that second-level offloading stage.
>>
>> [1] https://www.pdl.cmu.edu/ftp/NVM/tmo_asplos22.pdf
> 
> Yeah that's what we've been trying to work on as well :) We are
> working on a couple of improvements to the mechanism side of this path
> (cc Alex) - hopefully it will help your use case too!
> 
> Anyway, back to my original inquiry: I understand your use case. It's
> pretty similar to our goal. What I'm not getting is why is
> memory.reclaim (which you already use) not sufficient for zswap ->
> disk swap offloading too?
> 
> Zswap objects are organized into LRU and exposed to the shrinker
> interface. Echo-ing to memory.reclaim should also offload some zswap
> entries, correct? Are there still cold zswap entries that escape this,
> somehow?
> 

Yes, the memory.reclaim path does drive some zswap writeback, but
it is not enough for our case.

1. For a memcg that has reached steady state (a common case being
when memory.current is below the policy target), the userspace
reclaimer may not invoke memory.reclaim on it for a long time,
and so no second-level offloading happens through
memory.reclaim. In this state we want
memory.zswap.proactive_writeback to write back entries that
have sat in zswap past an age threshold, to further reclaim
the DRAM still held by the compressed data.

2. Even when memory.reclaim is running, the fraction of zswap
residency that ends up reaching the backing swap device is
still very small for many of our workloads, and the userspace
reclaimer has no way to participate in or control the
granularity of zswap writeback. So in our deployment we prefer
to leave the zswap shrinker disabled, decouple LRU -> zswap
from zswap -> swap, and use a dedicated proactive-writeback
interface that lifts the writeback policy into userspace where
it can evolve independently of the kernel.

Thanks,
Hao

> Furthermore, we already have a way to detect the "twice cold" entries
> you mentioned: the referenced bit. This is analogous to the way we
> treat uncompressed pages.
> 
>>
>>
>>> +1, why do we need to specifically proactively reclaim the compressed memory?
>>>
>>> Also, if we do need to minimize the compressed memory and force higher
>>> writeback rates, we can do so with memory.zswap.max, right?
>>
>> Here are a few reasons why memory.zswap.max is not enough:
>>
>> 1. Writing memory.zswap.max itself does not trigger any writeback
>> immediately. For a memcg that has reached steady state (on which the
>> userspace reclaimer is no longer invoking
>> memory.reclaim), after enough time has passed, the reclaimer has no good
>> way to trigger proactive writeback for second-level offloading by
>> lowering memory.zswap.max, because in steady
>> state nothing drives the zswap_store() -> shrink_memcg() path. The
>> userspace reclaimer still has no control over when proactive writeback
>> happens.
>>
>> 2. memory.zswap.max currently triggers zswap writeback via zswap_store()
>> -> shrink_memcg(), and each over-limit event can write back at most
>> NR_NODES entries. If zswap residency is far
>> above memory.zswap.max, converging to the target size requires at least
>> O(over-limit pages / NR_NODES) zswap_store() events, with no batching —
>> proactive writeback therefore has
>> significant latency.
>>
>> 3. memory.zswap.max is a stateful interface. If the userspace reclaimer
>> crashes for any reason mid-operation, it may leave memory.zswap.max at
>> some set value, putting the application in a
>>    persistently throttled bad state.
>>
>> 4. Once the userspace reclaimer has lowered memory.zswap.max, if the
>> workload is rapidly expanding and triggers memory reclaim via
>> memory.high / kswapd / etc., the actual amount written
>> back can exceed what was intended.
> 
> One more reason: IIRC, when you set memory.zswap.max to a value other
> than 0 max, every zswap store incurs a pretty expensive check
> (obj_cgroup_may_zswap), which does a force flush
> (__mem_cgroup_flush_stats). That was pretty expensive last time some
> of our internal services played with it. So yeah, it's not ideal...
> 
> (if you're using this, might wanna profile this as well).
> 
>>
>> Thanks,
>> Hao

