Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473F6CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C1B6B008C; Mon, 22 Jun 2026 21:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3167B6B0092; Mon, 22 Jun 2026 21:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E02E6B0093; Mon, 22 Jun 2026 21:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E5FA96B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:58:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67E41A033A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:58:24 +0000 (UTC)
X-FDA: 84909517728.02.5B86F99
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89C42180009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:58:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nVU9jaYf;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782179902;
	b=NxDqiu/xMtut8c2zS2W8eylnDrA9NNY9ZBWPhzBscRK96V1qjc3vCZG3mwH6gYY9CWUrV8
	8XS52YuVmf/j3pPtie7cdTJTeHyvkIB1sAIYFDR1xxD4CFUfYyNTp6P6efvK5zfQnILAvD
	j9YWm/SOqDdQVAQjejCtEq/MzV5H+4w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782179902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vB3i4adRYFyfJdlhTLJBnXcY+A/xZ4fOjEV+12UNO30=;
	b=JdzZPAXiQzuJieJrNZvCUhGJZTHU4t0ViX6CLMFniD1DEI7doGNuF2VD2RxXTIdVGgnU6c
	PqoKpa1lEyGKQKz3LYjisnTJsUhv+xdp4F17YoyJvAPiE3JNiHfe2c4a66OZXSTzXNsTtd
	8ZWR8HNVWI+LOBgJwkkG9HRTKK7jR7w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nVU9jaYf;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <19710ee5-8e1c-4b13-812b-4b03ca34260d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782179900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vB3i4adRYFyfJdlhTLJBnXcY+A/xZ4fOjEV+12UNO30=;
	b=nVU9jaYfAdR3Kg5OdpQ8NdQY8lYzn36Pa3qWCV2kxePiO7/Kl01rM+fWGrhc/stxijbqL+
	qCXr20ySoNM4fnI20ayBDDhONqwbZZhvZHnPGSp2kMbEJoGjxoGqwfEvixF1W6C43KNP6F
	+W/8gm0/04WNK50L6P01p7mNDgll41Y=
Date: Tue, 23 Jun 2026 09:57:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org,
 muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
 roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
References: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
 <20260622073703.79258-1-qi.zheng@linux.dev>
 <CAGsJ_4z34ZRu_RKkaZ7EgTWMOxptUjZ90WJyNoJrXGNjzutxnA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAGsJ_4z34ZRu_RKkaZ7EgTWMOxptUjZ90WJyNoJrXGNjzutxnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rcuiant1k3ntdkyepz65f4zagaqt489g
X-Rspam-User: 
X-Rspamd-Queue-Id: 89C42180009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782179902-959925
X-HE-Meta: U2FsdGVkX1+L7tvmJ4GK/VLeAILZBlLAzK25iEfQJTVC0GgCDS5ndx0p56HZwLAeqee6kTnXxA+1jyHDQRuPq0p6VFFzu/j9ZQ3ieGDLoy1EcMz93cL1ue9ltuyy98sHmtpesEkaTXEmILx8xAI5Wc9NGgchKqK28yljivSJSNL0fGZszxg61iv4G3QPjQCd3B4gdyMPsmiLFmVEoY8MJQ7D+4gdjjoF4kfxuvNsB2rLoshNH38Sl1mmwWLSKKSH0hzjuh84B3wYWCX2gE/fxraY1Y1AF/XqOymaf7dhEEqUBORi/eEsaaP7KLxytq2swoyVOu0KRwgyqU62Xj7qVgJMxl+zoqnSJab0GiS2mycziP9Om6KeIE6sVkclUXAQfiZ6gRsCqxOy4bO7vy3dX39LUxfULb2xgHV3o4fO0QHW/m6TWKtEoo3bM2Q/I7xLsMIuhsXyNjFssJ2FHmZiS8fksCVmKd6sIujNALgtDQ1hLmn4nF10+3BwKcPHTQBjYFMBqE5qrFo5WSJ7oRX2bxmY7FdSrLqDQWgrs03sfRNGmz8ohcXIm5hku2X4ArN96myDut3A5FhbPVU/Wz3tCQtELfAOkKAvie/u2d24ZQWvPrxkvvjmnpUsEmYZjHfduPyONKA3SyfFuAa26b/RxXx79B5FRp5GWEB62oG5kUkAkJDe0qLMjUuFE/YCGylX0PdyLOcdwddaIQVSv2GO8HooVBQuXucgQOx100tVd6F0V3GFCXjMYRKKq+GfvA4q4L2OGD07LDylCNjs2G5/az+JG4uacZm5sRpfSO1UCxbN4wyl9xX7u/PLocVBwA1lzFp0xVk0abVwhqMFEzsyvoXl9kJ97I0P+fLp1/U+RG12x7GeN4amr6uhV4lbGVWbLan3ohBOUtxigEx9ocllrP5GTtp7OcITCJxEqHXOs5Z/KxAtP9FgW43CJwVTIwGwlbFjGHwiT4dnwEjVHaZ
 Y+6IRaAV
 0jIMdW88IOXYnG5YJf4TgQNyejlgYOGhjVVVjtTsjydagh+nvHL0Iw4S7frS53hf704EC2//fajWzaaKojR9fiAHefyPzTTgw4xjLmsmU+n+mhcccd4O2MzKw8pz3h4a3ZaQ5KMthqu1lUdZkgt3jApIeCHzeSWvmmzaGp3/ae35V+pWZPap5VHqvSgarKVRzOTjuZukM3ajkP++KoOpBx6ws4Gvv6CIj3MO7zY4l6jP+aHpugRC6wZziuIREdvOOFkY84VvK/BmRuyhrpV7YjLD8wiwr5aGoLsIG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On 6/23/26 6:52 AM, Barry Song wrote:
> On Mon, Jun 22, 2026 at 3:38 PM Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The mglru page table walker batches per-generation size deltas in
>> walk->nr_pages while walking page tables without holding the lruvec lock.
>> The reset_batch_size() later folds those deltas into walk->lruvec under
>> the lruvec lock.
>>
>> The page table walker can run concurrently with the memcg reparenting path
>> as follows:
>>
>> CPU0                           CPU1
>> ====                           ====
>>
>> walk_mm
>> --> walk_page_range
>>      --> update_batch_size
>>          --> walk->nr_pages += delta
>>
>>                                mem_cgroup_css_offline
>>                                --> memcg_reparent_objcgs
>>                                    --> lock lruvec
>>                                        lru_gen_reparent_memcg
>>                                        --> reparent child folios to parent
>>                                        unlock lruvec
>>
>>      lock lruvec
>>      reset_batch_size
>>      --> child lrugen->nr_pages += delta
>>
>> This can trigger the following warning:
>>
>> WARNING: mm/vmscan.c:5867 at lru_gen_exit_memcg+0x26f/0x300
>> RIP: 0010:lru_gen_exit_memcg+0x26f/0x300 mm/vmscan.c:5867
> 
> I can't find 5867; instead, I can find 5828:
> 
> VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>    sizeof(lruvec->lrugen.nr_pages)));
> 
> Is this the warning?

Yes, I just copy-pasted the warning log from Peiyang's report.

Maybe the description should be changed to:

This will trigger the following warning in lru_gen_exit_memcg():

	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
					   sizeof(lruvec->lrugen.nr_pages)));

> 
>> Call Trace:
>>    <TASK>
>>    mem_cgroup_free mm/memcontrol.c:3972 [inline]
>>    mem_cgroup_css_free+0x76/0xb0 mm/memcontrol.c:4241
>>    css_free_rwork_fn+0x125/0x1260 kernel/cgroup/cgroup.c:5575
>>    process_one_work+0xa0d/0x1c30 kernel/workqueue.c:3314
>>    process_scheduled_works kernel/workqueue.c:3397 [inline]
>>    worker_thread+0x645/0xe80 kernel/workqueue.c:3478
>>    kthread+0x367/0x480 kernel/kthread.c:436
>>    ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>>    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>    </TASK>
>>
>> To fix it, add lrugen->reparented to remember the new owner of a
>> reparented lruvec, and make reset_batch_size() charge pending deltas to
>> that owner.
>>
>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Looks reasonable to me.
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks!




