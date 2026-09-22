Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73A5C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BF16B00A1; Tue, 22 Sep 2026 05:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB6D6B00A2; Tue, 22 Sep 2026 05:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908366B00A4; Tue, 22 Sep 2026 05:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA576B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:39:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7C7B403D9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:39:03 +0000 (UTC)
X-FDA: 85240899366.16.9674BA7
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf13.hostedemail.com (Postfix) with ESMTP id 888DF2000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:39:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cASNak4y;
	spf=pass (imf13.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790069942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qtlFeXSOZ9GGEZMi6z1/hHIAqyyLNkdSaIaqPPEsXQ=;
	b=I6Ek/u1tfm/iaMNg49VgyPexZt7Uew63uuaZNCy0+Qh5S7hU72P/M1ggH5VxvCaTKsKEmM
	p3QUMOqJh3/CsQS4VK/u4lPuDTc04HpCaP28HJz2c4e8+Ful+rrAU6mzaF+h/OxQJvwDou
	MzoIPCKersBq4jHAQgPUXT6AH4/cwMM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790069942;
	b=2LhSQvA9KKU3P8KK31QgUJwnLtynt4fvciiceI//1HaJH7jKvfXT7xSd0sC0xspFcNex8/
	/fqTDos9cX+W5IEZriB2YNeF4dB1aWSVVl+XwhVSj04b69KH/Lh80YQHvOTio2tLz6CHOP
	yXNX2bomE8edbUe2m0DoekmwCJYNs0Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cASNak4y;
	spf=pass (imf13.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hi1vDGEifONMUPQI29D6K7Rz4VLkNWGHmR08F4W6XWs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790069939; v=1; x=1790674739;
 b=cASNak4ysuWjNi33n5bSDcBdcWis2zVS9qvdGrVjHVup11L/H4Fy2JLJIERrGeYANXz8CszW
 oLautxEeyd2Gjpi4VrSY37vqwZe2ZMcT5H+QQ91vdpC6IbVWed6Etmxj5X9apohdoXYrE+Gj8TE
 q0+yoU3mYLQ4aBgDeLCnyNpw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9d2428c7de0bd619;
	Tue, 22 Sep 2026 09:38:59 +0000
X-Mizu-Trace-ID: 9d2428c7de0bd619
X-Migadu-Flow: FLOW_OUT
Message-ID: <d9c97d83-f29b-440c-9385-47d13afc38f3@linux.dev>
Date: Tue, 22 Sep 2026 17:38:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
To: Muchun Song <muchun.song@linux.dev>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
 <B710AD66-B826-4138-B1D4-2DB3E00FDC1D@linux.dev>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <B710AD66-B826-4138-B1D4-2DB3E00FDC1D@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zdj5kfdsjuuy4ycyy8b1gftwchqdmcxy
X-Rspamd-Queue-Id: 888DF2000A
X-HE-Tag: 1790069941-480709
X-HE-Meta: U2FsdGVkX1/tGMjt4f5FVQeor93guZ1eZmR2lLf9Dli8n2e+B/Zl09uu1qYVGNKIBDGW/OcbCA6HteGJwY6ylKC1sa6huSgrkb4tlElPEDOl5iylrzGJYT+u53ELtffG0Efzj2tpVlSZ5njEmrUzzGLVLVfBixeRwrGQ2v5JFpXdZEKcFuPuJLpCT3BATj2aJoxRomHKEGSL4gltRiEmXAh32/UvzJGmmK6mOTAmklWvTVY2fUlEMv+r8nLEIHpnPxCHab1Z8ZDzeB5EnMuaQp4H3GAP4ipUnwCGW0VWsaKIunry6TCX8bfIvfQj9T1QtzWIxoxgK46iePkZJ9d0RhkK4IdukFcPgDCTR38dsMLYF19sPbmZ7cggQ7aehYMG3NQVUGe5iFXVhuWx9mQac3SDg/RIDTB8BxI0Vt8QlBrK3e6egjG1iuIbLEOnG+GcwZpMy/66b6xoxpPZB0z66OxRhR6razPUIAvyVwEO8nNO25/IPNacFA+hWYBuyAKP4i8MZ28mpUvXf/2cD9K+W7/4wLqmsS6agYVGQ4x/qXx/4i80GB/NN3UYfkxU23nQqTs1PM468OW8BmdCr8ZZrodB7ZrTWPyOwPQfT2Eg0ReW9BBN0mZZ/snvrvmdPqiuIDKYx+VWOh6pjQTUvUEdGlS+81JhYSMYgeKCvH/CJQB4lVoBlvZ4TVEWZVTXvCeSud4zocPm8Ha/x8Fi/Fe4rot8vIDAesqPMH+duak4WhwJiNpBSlCbFutMYkWF2Hl9nMGhdYClC4veF7m2fgRHh/G0uBjKsJKf21UgrfpD/qHB4sDh0IpakpT9AcBgS0nQ/OjaAlaA7XDybQD7IvZvqFdKEFTGzgeyk5xHg6XlbhtDtkrNVGJm4hGFaNL0/Yj0eDaxrANUtlR1Og8xItGuhCg+IHLm/5GfZ6CyRH8d74n7Cx4HNU50Pud0fjGc6QtFjmK7PdIwlWKyd/HySxy
 P2GCf4eA
 ys9rnoo8W8P8v4KvCR2Y+nwEWu9JencYq/MTvdYfcilyKf1/O8nWGhqq2HivyUEabz9W81SVvg8Z6zoWdqH3eAplq91Lxd2iE2d9hUTSNj6/YDzDR5b+MCmGf+C9ZOFddathwOlQNrRd9m3CUdXiGfswyr7nGaFstaq9x4hRMUFTh2iNmrfmjVpE7CHakjUZn8uVwyvdzcM+tmt/A0F87PpK+bnmJsjV7gV9O5urpY9URgYsDN2rjMUh7v2Ur1+M6UoLlWRqX9aznhJzv4rjJwfzQzWBdbmuHb6HMoeYJmbP9VlzF6WNE1iZk/9vwMQS1iSdl4aw7a6R/3WRPBNi4NAUb1W/m+Xc0UfzFiptftR47sdCQPnGZcKq8KQoaFX/fm8hHIA4MQexv0uE1NVuD34Avug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/22/26 2:18 PM, Muchun Song wrote:
>
>> On Sep 21, 2026, at 17:12, Hongfu Li <hongfu.li@linux.dev> wrote:
>>
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
>> ---
>> mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
>> 1 file changed, 31 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1460cba53588..9c96ebd5436f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>> rcu_read_unlock();
>> }
>>
>> +#ifdef CONFIG_HUGETLB_PAGE
>> +static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
> Actually, we don't need this objcg parameter since we could get it from folio.
> And I'd like to move this function to hugetlb.c.
>
>> +     				struct folio *old, struct folio *new)
>> +{
>> + 	long nr_pages = folio_nr_pages(old);
>> + 	struct mem_cgroup *memcg;
>> + 	int old_nid = folio_nid(old);
>> + 	int new_nid = folio_nid(new);
>> +
>> + 	if (old_nid == new_nid)
>> + 		return;
>> +
>> + 	rcu_read_lock();
> Please use guard(rcu)() to simplify the code a little.

Hi Muchun,

Thanks a lot for your suggestions. I will drop the objcg parameter of
move_hugetlb_lruvec_stat(), move the function to mm/hugetlb.c, and use
guard(rcu)() in it.  I will post a v2 for review shortly.

>> + 	memcg = obj_cgroup_memcg(objcg);
>> + 	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
>> +       		NR_HUGETLB, -nr_pages);
>> + 	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
>> +       		NR_HUGETLB, nr_pages);
>> + 	rcu_read_unlock();
>> +}
>> +#else /* CONFIG_HUGETLB_PAGE */
>> +static inline void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
>> +    					struct folio *old,
>> +    					struct folio *new)
>> +{
>> +}
>> +#endif /* CONFIG_HUGETLB_PAGE */
>> +
>> /**
>>   * mem_cgroup_migrate - Transfer the memcg data from the old to the new folio.
>>   * @old: Currently circulating folio.
>> @@ -5635,6 +5663,9 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
>>
>> 	new_objcg = get_migration_objcg(old, new);
>>
>> + 	if (folio_test_hugetlb(old))
>> + 		move_hugetlb_lruvec_stat(new_objcg, old, new);
>> +
>> /*
>> * @old was charged through a non-root objcg, so its charge is in the
>> * page counters. If the re-derivation walked up to the root objcg -
>>
>> -- 
>> 2.54.0
>>
-- 
Best regards,
Hongfu


