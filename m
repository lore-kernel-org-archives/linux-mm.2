Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767F7C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8677A6B00AA; Thu,  3 Sep 2026 07:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8180F6B00AB; Thu,  3 Sep 2026 07:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7090B6B00AC; Thu,  3 Sep 2026 07:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF6C6B00AA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:48:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1DEEA051B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:48:52 +0000 (UTC)
X-FDA: 85172279304.10.A616AA7
Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	by imf04.hostedemail.com (Postfix) with ESMTP id 61D6240004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:48:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wSbeXHvQ;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788436131;
	b=jYFoZB+CsjRkhrVvx09ruBlZzRhLWFYFxbPIr/eBQ/M0WOBQtPham5kB8DGB5MhP4GOJOC
	1dJTDiBUm98qu+C0EduntlNoh2slNBbH+wOBudxB3EwJ81OwNJsyjw2kfgl+8QhDdkftYl
	4CiDpWHD0CJ0ZAykQUwODnXPWtm+ofY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788436131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngH+XG93Q1dA+pRGw2L4iZ+67jv+0CWStmFqky/vDKs=;
	b=0d3WToynxqDrRA/DtJyuN1RP6WQK7hbFHZSuKQNit5r6/BS8nBhETeksrb7uWi2yGYj7D+
	DcfGhobaWLDfQackK9/WOO7k9dG1U8dFg8bin3E6mhUi+EvQ1hjeIxI3sECz9GYfmmqqva
	gZFbxUgsmxU52cVnDAOkZHGr4kjnhZ8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wSbeXHvQ;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=77ef0smQwTHv7ciVNhDJeRJa0P6JZyLYvgjHop8xgXY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788436127; v=1; x=1789040927;
 b=wSbeXHvQyPXACQ87knWMG+fFUtXPa0OXGmpOcpoeeAsV+vJmsnIKeP+5Ar+WaUPxf2croYc/
 Se/GtUzOU+7aaM19BqgxhkxOMr+GrsuAaFFb8smpOgUXLsy+v0E4Z1VRV/Tm4EHMrOY9PSP+fiF
 aLTrw6hjht4yeIEgZjNX1MfA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 10f1446bfee7baed;
	Thu, 03 Sep 2026 11:48:47 +0000
X-Mizu-Trace-ID: 10f1446bfee7baed
X-Migadu-Flow: FLOW_OUT
Message-ID: <f067f8c9-00f0-484a-adf3-da58fe972bfe@linux.dev>
Date: Thu, 3 Sep 2026 19:48:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>,
 Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
 <20260903031952.1120321-3-ridong.chen@linux.dev>
 <CAGsJ_4wKaboESQfUJPi8y4BNJuxpEWG2Prjb44NvFKDV_aeVhw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wKaboESQfUJPi8y4BNJuxpEWG2Prjb44NvFKDV_aeVhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61D6240004
X-Stat-Signature: qzrtew7wrxy5u1yaz4ui4d76w7uionbm
X-HE-Tag: 1788436129-554561
X-HE-Meta: U2FsdGVkX18Wy7zLpFi3710NCcNiKZrxkCGoOkDZM+JBIShhoAhaEhW8WWbKlcItWW+guDSrJPjviPs1PEWrhBmPuJlqWvl40icvt2RCmZdWOFfVp2zzxRQr0gj2cgZHnSqtnZjcd131SQ2tlUyUNGXfB7rCyWKiblloppqf9BPODd+bgj2z4xUraUJyGPbIJVt0HLZ4icZ/mbbL9t+LSwj6ftq8hCg53KlbgsKmzpKXa4PZ3Et05nMWq5eWl4lZ51W8w9j84ZHQ82l9xOWU3OBoAuvWBaG550XsLKYk62OCwTyQivtLHAV9iLuONm1hDbHlXPdQT0rM8mnEXNZ5JIJbeNLrC/Ebo7jG6C2RkrtpQdbaIZUuNweIN7b6Pju/3rE8pItfonp68KbIf0Dak6U+Vizz0heNegH5zp57ctw6ZMtVobYaFbdTUizIrlZzNR+StEkiDi6Z8fiPjocLXp3Fl4RYAhiPG0cWt43nsRr+o+garWNsSVw6s1/TqonoXb4J5LPfRX2bJdlticD6JPv+iX9DT08Jpco5pjX5BtDYmXArKXzTqlVgMXXd5vpyESrDN4zi6QcUyZvSBT+zEltZk5BuzHeejh2TdgrLDZtlBCPDOCr+7HVkDzXHiErru8dXS9nM6cE3UtNSgkiYwKmKlCFLYG8U8TcXzPulqWmj4EabLB+dDd7k16xOXUfJ4vp480l9fvwpG2h1UAnT1eHg2dsR5Lh7JvOFyhysoxcH37OtOoDIzcvC+m3ASKvXQc89TZmG4uuX8oGOXqLXw8ZtBjR13oXuNjW4mef0ThYR94oPJfmDgUMpVZAPBvuECMiarDKc5BDU2Lm3PaVpJvrn6JuDKE+Azh9zQVpfxZh+y0wFlrbAhC11ckYAIEe6moU1d03aEiSLF/+UB8pnkQFZivZdHOIXmr653bbHSM/MNSPd7Oc5cVcMyFJgxXLi2mhzBzC+q7dwnxS1C2e
 Zu6PPOIE
 DMH/DDqtavayA9djycO3SeJK+OjlBMfvciMkZIPDIqwhbYmo5sortfecdhlHhzXAXo4gJlUgfUuyYAHiMdMv2dB1t6hmt3F7AQblDKMUOBBCgXD11R2Rai7in+r1HqZF1yFh9yjtBwHQaPdFP84fG3qoAj+hn02/KEP2bO7525DoJ2MdUShLOaqOE8prOvsqUME0j4CCJEoXMa7z+UTdBdRK1PCdOteMiut3N0pQAVXiam+tYLWh5y/R4bYGtw5+mnEleVFVWUVeG7kskIhHe9eonIw7UNFnxgYkaXRlNqQ59Wuixhzbg6l5sf7LJ6OUt+K9xu4CS1PxuYNsiyrlFEKozAlBgKc//Emak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/3/2026 2:30 PM, Barry Song wrote:
> On Thu, Sep 3, 2026 at 11:20 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> For MGLRU, memory.min/low is not honored during global proactive reclaim
>> (writing to the root memory.reclaim) and global direct reclaim, because
>> these paths shrink memcgs using stale or effective protection (emin/elow).
> 
> Are you sure it should be “stale or effective”?
> My gut feeling is that we don't need the “or” here.
> 

My bad. It was a typo. Will remove "or".

> [...]
>>
>> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
> 
> With a few nits:
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 
> [...]
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index b4c9b8f3dfe9..500cc2051d13 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5111,7 +5111,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>>          struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>          struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>
>> -       /* lru_gen_age_node() called mem_cgroup_calculate_protection() */
>> +       /*
>> +        * For kswapd, lru_gen_age_node() has already called
>> +        * mem_cgroup_calculate_protection()
>> +        */
> 
> Could be clearer:
> 
> /*
>   * For kswapd, mem_cgroup_calculate_protection() has already
>   * been called during the top-down cgroup traversal.
>   */
> 

Thank you, will update.

>> +       if (!current_is_kswapd())
>> +               mem_cgroup_calculate_protection_path(NULL, memcg);
> 
> Best Regards
> Barry

-- 
Best regards
Ridong


