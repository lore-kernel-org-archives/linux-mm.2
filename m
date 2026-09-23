Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E1D5C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 03:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9561D6B0093; Tue, 22 Sep 2026 23:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906C66B0095; Tue, 22 Sep 2026 23:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5D26B0096; Tue, 22 Sep 2026 23:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 549246B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:41:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E3FB120675
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:41:07 +0000 (UTC)
X-FDA: 85243626174.21.7D45A8E
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	by imf25.hostedemail.com (Postfix) with ESMTP id CBBFFA0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:41:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t5KzfUbR;
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790134865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YicmoMpBvPwbZSKoyDjZGS1lR6dkUxkLQuwNZdKD4fg=;
	b=pZnMYu2dIOZBXyxUxc1Mu9jAVWoF4e+BmsX8i87Fg2h974MtlFOCDtVfFW7w88a4QTfRfZ
	dzXWHczqkVMXjRVlluq0I2h66oHqfPlsj5iTnE/ZMKiYmiyd4jgLjmYsvsdeoBQ4q4KuoZ
	Aud41NJvi6nPwP+KfoIV8UWiSdvl9Fw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t5KzfUbR;
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790134865;
	b=lo2gSAwgh32F8bcbNxzlj/n07WgGGBgVdQnZQvkYX0TKS2EqHB2D8I4caZ1gAolEgsesC+
	ZCxH9Hd3mbIKI32ieOJtCGTefWFVVfWpj/0M/vm5wZ7zGtZ8uoSfSLHkAhE7+uur850Bc+
	qJQwQKR2AaT0CsAnrf5e8bEhc3It7l0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g0/Z5c9aDwytCwk3EVHISBOUhMOmw+UqfCuabJU23Po=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790134863; v=1; x=1790739663;
 b=t5KzfUbRPgwv6bU849Gk4sjU/WqthHJxWnYgZ9CznQ3o4Ck0wIbxT85pCzznXxrcJtwcMKwQ
 DMe4S/Mui0Td3ETfzxqRd45JJF1Q+PDHNHQjSK/l7mYjRq3dJxcyFjZq6B5/J6f/2Xg9tiZtcQL
 33KAUZsseBYKCQ+GFiDjP/p4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6f051fd9b05117c8;
	Wed, 23 Sep 2026 03:41:03 +0000
X-Mizu-Trace-ID: 6f051fd9b05117c8
X-Migadu-Flow: FLOW_OUT
Message-ID: <1835413c-e2de-41b0-8225-161afa50676a@linux.dev>
Date: Wed, 23 Sep 2026 11:40:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Chris Down <chris@chrisdown.name>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
To: Muchun Song <muchun.song@linux.dev>, Hongfu Li <lihongfu@kylinos.cn>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
 <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
 <15ac7069-d687-4985-90bd-25bc900b4bdd@linux.dev>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <15ac7069-d687-4985-90bd-25bc900b4bdd@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBBFFA0005
X-Stat-Signature: 9chjhh5idoz9hud6hid86frjip9jba1k
X-HE-Tag: 1790134864-78130
X-HE-Meta: U2FsdGVkX1+agenQUkMwi/tI5mhvMrL14HkCJG5jYagdTVcSV0JwTHZWDFjpsrgnnlNO5wwu07LsNv33c5yknzFu4EKfRIqi9UYe6XfW26Pw4IGSKQ7Q34Vv/kISBk5s+D7zzoRzToKLnhKFPuK8LVMz9J6or3qoEc/DWg+5YfOu2xdKCLReH4Z2tQLM8/oJMtPNOhNLgDU+GB6ZiftSy7VrlpthSgjHwbDjD3W0g9AR5f+U9MInxFwPRJOhdWe+ON7fuSglUVhdJVbxZTPoS6OJozmSHd7I93m6CxorrwdYDGTzM0MOYdEzcrP/Tq8CGAOdRt3iIJGm2ovkDT0gJsjvngtMSv9YsFgMZ9FTioJOaupyuO+hFyqEEOTKeGhxTDIQyz0S9ucSXklC4hBNo6s0Q+XOGwB8gIqGofHdFZYMEdxqIEbC7xmwNmpxWbBj2jY40u3+hgfSu3M5HMmMK08G6hELzlMouGaRYTui5rr3X3f/sb3UeHwJfEdmqd/ryERd7KBr32TwuFVUBNCb/jbuuK1owAspCmsx3CEOFd6LCcC0lffOeCdN2hiTlDa1r9RYybbuzEzZRS15RReXvLPB/XoDnltJehMebp3PkveKUNHhVcAk1CDzZ2QvjRDqet0etd99//wxoOqRwI2/U1+s7Z+hnS8Y43t1AcVz1SYu+8sC9cS+aXWIWwwdni3wpycQK/zI/KTZl/+o61Jp+Ql7mocOCk+rE78kz1Hfp+JcDF6gqhDcx1bQ5QVZ9ydaOfE0TfvVgEcPWpqKWhx2RZgDQ0oqDJDlFoP7akg/d8PJWhaofCDKWvS5rdfBMvMnnIQIJvjWwSK34y6n8c1YwhqFS+pN2HFEln7eLY6VaW5yAAocAxkhEBMy8v40cJmzK+yE4FEFNxgP9dRuxZTtyEHD2plxc4vHCcWd8cV9xCcafnUkZ2ucgTfnbFeby4u0AuQYq2cPAUg0MSTPHd3
 Z2yH5OPY
 rPW/qQPvZ/klkpOuqJuuq4T6RYp8D34DNVDp1Ti1CVi6mWTXULy1TcRy1bRjpjO6JytZGxIjfLXm2YTh3Tkq2uLDfGAZBrt+3yjbELN7IyoPoDWCE7APmp7VB0vLOh4a2yHFyjHrGq05yChec0Jb6FUmUCSwHmwZ9OIQ8cprDBdvIuo9+2PpYteOdJfqGHNCR27AVkF3Vkare57tkO3UuhyGuZfTH3vgmDPFWobZAbEkf/3r6nGA+zTrMuzGGgQrNFbV6zynWCcJroHwmKzqOvgfPxu9umrKoAcl2C5owqyXzC2ax/wsfL1CG3bd/4hkAe4GnSh9A4uSlnDmBnLYQjm5gAUYqbOkY34uTIxec9coUUEv3XhKUAEPc9B3k/rEvGoajoSjGehiAkgL7hu0Yr0fur4Ea6wkcfX4awBVyo85Fu+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/23/26 10:40 AM, Muchun Song wrote:
>
>
> On 2026/9/23 10:05, Hongfu Li wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
>> stats. These stats are accounted against folio_nid(): incremented on
>> the folio's node when handed to a user, decremented when the folio is
>> returned to the pool.
>>
>> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
>> to the new folio and drops the memcg data of the old one, so the free
>> of the old folio right after the migration skips the memcg per-node
>> lruvec decrement. The hugetlb count stays attributed to the old node
>> for the rest of the life of the charge, while the target folio gets no
>> increment on the new node; its later free decrements a counter that
>> was never incremented.
>>
>> Migrate the per-node lruvec accounting alongside migration. Global
>> memcg totals remain balanced because they track resource consumption,
>> not node placement.
>>
>> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>> ---
>>   include/linux/memcontrol.h |  8 ++++++++
>>   mm/hugetlb.c               | 25 +++++++++++++++++++++++++
>>   mm/memcontrol.c            |  5 ++---
>>   3 files changed, 35 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index a8358f297b65..74110a324f9e 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -984,6 +984,9 @@ unsigned long lruvec_page_state_monotonic(const 
>> struct lruvec *lruvec,
>>   unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>>                         enum node_stat_item idx);
>>   +void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> +                enum node_stat_item idx, int val);
>> +
>>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>>   @@ -1452,6 +1455,11 @@ static inline unsigned long 
>> lruvec_page_state_local(const struct lruvec *lruvec,
>>       return node_page_state(lruvec_pgdat(lruvec), idx);
>>   }
>>   +static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> +                      enum node_stat_item idx, int val)
>> +{
>> +}
>> +
>>   static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>>   {
>>   }
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 519c30b338a8..76d019594b39 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -23,6 +23,7 @@
>>   #include <linux/mmdebug.h>
>>   #include <linux/sched/signal.h>
>>   #include <linux/rmap.h>
>> +#include <linux/rcupdate.h>
>>   #include <linux/string_choices.h>
>>   #include <linux/string_helpers.h>
>>   #include <linux/swap.h>
>> @@ -7378,12 +7379,36 @@ void folio_putback_hugetlb(struct folio *folio)
>>       folio_put(folio);
>>   }
>>   +static void move_hugetlb_lruvec_stat(struct folio *old_folio,
>> +                     struct folio *new_folio)
>> +{
>> +    struct mem_cgroup *memcg;
>> +    long nr_pages = folio_nr_pages(old_folio);
>> +    int old_nid = folio_nid(old_folio);
>> +    int new_nid = folio_nid(new_folio);
>> +
>> +    if (old_nid == new_nid)
>> +        return;
>> +
>> +    guard(rcu)();
>> +
>> +    memcg = folio_memcg(new_folio);
>> +    if (!memcg)
>> +        return;
>> +
>> +    mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, 
>> NODE_DATA(old_nid)),
>> +                   NR_HUGETLB, -nr_pages);
>
> Why not use mod_lruvec_state? mod_memcg_lruvec_state is an internal
> API for memcg, I don't want it to be exported.

Thank you for the review.

mod_lruvec_state() would update the node counter a second time.  It calls
mod_node_page_state() as well, and the target's node counter is already
updated in alloc_hugetlb_folio_nodemask() (patch 1/2):

     lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));

For an uncharged folio lruvec_stat_mod_folio() only updates the node
counter.  The target folio is not charged to any memcg at that point; its
charge only appears later in mem_cgroup_migrate().  So the node side is
already covered and only the per-memcg attribution has to follow the
charge here.

>
> Thanks.
>
>> + mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
>> +                   NR_HUGETLB, nr_pages);
>> +}
>> +
>>   void move_hugetlb_state(struct folio *old_folio, struct folio 
>> *new_folio,
>>               enum migrate_reason reason)
>>   {
>>       struct hstate *h = folio_hstate(old_folio);
>>         hugetlb_cgroup_migrate(old_folio, new_folio);
>> +    move_hugetlb_lruvec_stat(old_folio, new_folio);
>>       folio_set_owner_migrate_reason(new_folio, reason);
>>         /*
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 88824f783571..a5335da5d425 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(struct 
>> mem_cgroup_per_node *pn,
>>       put_cpu();
>>   }
>>   -static void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> -                     enum node_stat_item idx,
>> -                     int val)
>> +void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> +                enum node_stat_item idx, int val)
>>   {
>>       struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>       struct mem_cgroup_per_node *pn;
>>
>
-- 
Best regards,
Hongfu


