Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B1ACC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276A86B009D; Tue, 22 Sep 2026 22:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D616B00A0; Tue, 22 Sep 2026 22:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D1C6B00A1; Tue, 22 Sep 2026 22:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D59E96B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:40:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 941DE1204BD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:40:35 +0000 (UTC)
X-FDA: 85243473630.21.57FEB17
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7045F100003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:40:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CfpXMI5a;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790131233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3w6U0s2Y7YXfrVrGfZe4mA3TtjZw00BYj0SWxYptNI=;
	b=6/ZHcjCMA3ZTWTc7jwjG19kSEtXNSNgjXsTjOUyO0z+yFV7W/0PdrX/bMC9puXpH4rmsZX
	YbfNH2VfL4oQSI4XtN8k+scnGYi4kjOfLozhfrxRvJBnI4R8pfVKwVbVOihp7LnIm8joTF
	KvPOf84KfMjq++lVQZSfeG8oOv3yQPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790131233;
	b=BpxuzzDPq/5+v8YckLWIgdkPX2oTHIAwgn6seuENv9N4Lutmsn55HOA6V9tvg8P0cQ/ovY
	yF4FNNuS4tFU3E+Owj9algT30Zi+5lzb833kN/bQ7HVIJAAIN2R5T/36mfpUpdcaQ5Um8n
	wcYZcqohRFeDdnZ87/G4wmCz2Iq1TEU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CfpXMI5a;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=j+Y4V2mMNGYI+hceNSPMN7m7nsV8dKsfzNn4H+9807E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790131230; v=1; x=1790736030;
 b=CfpXMI5aTccg0TDiztH2M7y0sI8ldiU1pQ5qll35wjmNGh/C9kJ77aqN/x5dEDCfKsTDyfXE
 0IgqoO6zHiiVemsWUYQaNf78HpvdzZoJhCagQR9jEgnMFfRvT+GAyhF0A8Joo4Aa7kX+whzGgsT
 5zLmtkMOTdtHHMpAYyYRZ6fc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 41c7d1fbf26606a1;
	Wed, 23 Sep 2026 02:40:30 +0000
X-Mizu-Trace-ID: 41c7d1fbf26606a1
X-Migadu-Flow: FLOW_OUT
Message-ID: <15ac7069-d687-4985-90bd-25bc900b4bdd@linux.dev>
Date: Wed, 23 Sep 2026 10:40:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: Chris Down <chris@chrisdown.name>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org, Hongfu Li <hongfu.li@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
 <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7045F100003
X-Stat-Signature: zcxw31h1siqef9bp9psqqge65y7y9qjn
X-Rspam-User: 
X-HE-Tag: 1790131233-701848
X-HE-Meta: U2FsdGVkX19Z1sf/B4z/hd8+OWT2cXjK8IW9px25CNohO47qPN+QMP/e0NcPsxh5N2evrULi584WCwfz3LiNO2mzCSWlKL6LzdTX9rmB4UHHns686BtGe8gYgdthCTXe1BnvUb4peRt9Nl57kznkNJPd7eS/aFm2y+H36DI+iFErTxYpZ6f/TM9zrSQL9H0aO8rPHDuhOc4Oq7dNyVJI2NryQFQ24t9/jD6KUx6IQmUJmqOkOM4kCUGATDmIyqWwixjFUb3mLeUMlIw3FGgF8WTNDbI2uGo1yMazruzxnMWeyjME+zrc8l3YMDFSbD4z99Kph063/pMj3ygwb9zIybFlHjMcEMhvxfhZtCQfbmXzj7mQKz7c8HylX2AiUCNhlyen5tTN2qtAyUDeno7lcyS6rA7CEZgZu70Mu7+IJSXLjOkk0Pvqr0gNLFmXxQI/iWZDB5z9qt3KAMGzSNzFWEI2ktU75U4cSpkuv1qMOx26KnMytJ1RGH00dnu0uFWzvxSEFkiMnO0Yck6W0M+BzoVNGVHyHN6VuVpxO3m8kEbDAY6wasFcOAeueNqCaGAVEwMJFj+rQtkKZ6rmqlT50go2CgnG3XrXp2nIWPwjHtZadDGdjK74MqDdMuoYwrGgqh+4N4ZEQK1i5L/Wx+nUqQQEnh2faDOcD9ec2tv7eAMQsCUl6mebJeAnPddviHlHEVqXvyo6XwpuG71FOVXFxaeyBmZNSVSNaKCZEjPJH4RwjxrQDA3VEY4jDUR8CdQpjDK/+wOcTYIM7wYqUiqPZaZIGH3SNUqX0F2C/GOWSgiYvke4xENmOwNxXXHg8I3U5rV6bjMMix0REY7pnzpiEc20MRTIpDx+U3uv7A5srkvuXNlU2iDrhjuvFTr0wfructZ3vbRfAbFIUqjzDXe/wXp3JciHLXQl6jO761hNIxn9zSUs4e0DKGFZvAJ0Z7PAFxD2Hvm5vJby2iPMQPe
 ARhYEZWC
 6uPjdzn1P72zq/bIePrpvTOrp9AwOpytNxaV/6bQw4sR6cQnkRpPZ496F7v0fE+8ukaZimG9NEHeaCzuzgguV+Zw5dZ+dJLx0pSP2bK3ZqM1T4lf4oRB9aS7pnuf8SmIWtn5c883zNO1LPRfchdBjtj4lvc9dDbEjEvJZxNUJlk2i9jAQx2Q7j9uD37vbMUSu2rh+RNhTK2SIRHCfUDBShIjgRNmcZ7oC/XlbWiPVDUUAgSMa1DRZCVyeqbQbsknI8tCIIr7ajA4ClUumvgZBMn5f5S8QE7y2cmfwTv2OllTUQUzVbvzNKKBFaKvU28xOfnjidyrIA/8lQd7vB507newE0QvoRHqj1bc+6eCilSRY5BvTA+lBu87Bmn7WIMBhHYWT8bupez1DSrETrMFtYvMUlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/23 10:05, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
> stats. These stats are accounted against folio_nid(): incremented on
> the folio's node when handed to a user, decremented when the folio is
> returned to the pool.
>
> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> to the new folio and drops the memcg data of the old one, so the free
> of the old folio right after the migration skips the memcg per-node
> lruvec decrement. The hugetlb count stays attributed to the old node
> for the rest of the life of the charge, while the target folio gets no
> increment on the new node; its later free decrements a counter that
> was never incremented.
>
> Migrate the per-node lruvec accounting alongside migration. Global
> memcg totals remain balanced because they track resource consumption,
> not node placement.
>
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> ---
>   include/linux/memcontrol.h |  8 ++++++++
>   mm/hugetlb.c               | 25 +++++++++++++++++++++++++
>   mm/memcontrol.c            |  5 ++---
>   3 files changed, 35 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index a8358f297b65..74110a324f9e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -984,6 +984,9 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
>   unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>   				      enum node_stat_item idx);
>   
> +void mod_memcg_lruvec_state(struct lruvec *lruvec,
> +			    enum node_stat_item idx, int val);
> +
>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>   
> @@ -1452,6 +1455,11 @@ static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>   	return node_page_state(lruvec_pgdat(lruvec), idx);
>   }
>   
> +static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
> +					  enum node_stat_item idx, int val)
> +{
> +}
> +
>   static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>   {
>   }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 519c30b338a8..76d019594b39 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -23,6 +23,7 @@
>   #include <linux/mmdebug.h>
>   #include <linux/sched/signal.h>
>   #include <linux/rmap.h>
> +#include <linux/rcupdate.h>
>   #include <linux/string_choices.h>
>   #include <linux/string_helpers.h>
>   #include <linux/swap.h>
> @@ -7378,12 +7379,36 @@ void folio_putback_hugetlb(struct folio *folio)
>   	folio_put(folio);
>   }
>   
> +static void move_hugetlb_lruvec_stat(struct folio *old_folio,
> +				     struct folio *new_folio)
> +{
> +	struct mem_cgroup *memcg;
> +	long nr_pages = folio_nr_pages(old_folio);
> +	int old_nid = folio_nid(old_folio);
> +	int new_nid = folio_nid(new_folio);
> +
> +	if (old_nid == new_nid)
> +		return;
> +
> +	guard(rcu)();
> +
> +	memcg = folio_memcg(new_folio);
> +	if (!memcg)
> +		return;
> +
> +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
> +			       NR_HUGETLB, -nr_pages);

Why not use mod_lruvec_state? mod_memcg_lruvec_state is an internal
API for memcg, I don't want it to be exported.

Thanks.

> +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
> +			       NR_HUGETLB, nr_pages);
> +}
> +
>   void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
>   			enum migrate_reason reason)
>   {
>   	struct hstate *h = folio_hstate(old_folio);
>   
>   	hugetlb_cgroup_migrate(old_folio, new_folio);
> +	move_hugetlb_lruvec_stat(old_folio, new_folio);
>   	folio_set_owner_migrate_reason(new_folio, reason);
>   
>   	/*
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 88824f783571..a5335da5d425 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>   	put_cpu();
>   }
>   
> -static void mod_memcg_lruvec_state(struct lruvec *lruvec,
> -				     enum node_stat_item idx,
> -				     int val)
> +void mod_memcg_lruvec_state(struct lruvec *lruvec,
> +			    enum node_stat_item idx, int val)
>   {
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   	struct mem_cgroup_per_node *pn;
>


