Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCA7C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6806B008A; Thu, 17 Sep 2026 05:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDC86B0095; Thu, 17 Sep 2026 05:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBC16B0096; Thu, 17 Sep 2026 05:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5E56B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:59:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E02811C1E09
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:59:19 +0000 (UTC)
X-FDA: 85222806438.19.70E4070
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf08.hostedemail.com (Postfix) with ESMTP id AB4EE160007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:59:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HCFBAhsC;
	spf=pass (imf08.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789639158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/663ZQApDP6/5rAke6wqKp6Rc+P0lZ32oyBopoaNkI0=;
	b=go3Yw5OHH7GIsPWWkXhDGRPKpgIz5WR8NNyyhGJlawQ9kgwTWA4bRGzV5XPDy5yAgne7ZG
	u3gWm/efWMCecuJ5zou7VbxnvPMk3JxTgRc3Kz013auFuYYVQ5RGML9FVqfxE1pre6lCn0
	oagcnZNQXtvO9PaxG7njJyPMAb415ic=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HCFBAhsC;
	spf=pass (imf08.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789639158;
	b=TwLJ2Uac4qbVzphEP0Su7vw+hg16DkbKcudq6mYEmVjV95OdZ9Gfx5mhVBTrryl1wn97Q7
	X/5/jXyZHmUZj/dSqYx8ZuUCNCZ+L7oUQwo2k+V/jfcanOcy/HD7yxH/m9l7Iq350CS0ri
	PE3hAtqErJ3nP4PtFe6nzpMWw6FnQds=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=h3tWfqwp0BXJaEM7B1AfP1A5m7aOhxvWpLcI8mcrCIk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789639156; v=1; x=1790243956;
 b=HCFBAhsCNruCnF5Mhw0xmB/0cFp2lrFGJOaIHJrGKic0Skdk192ozMWkV8qYwc+BeiSw7i9z
 SxwXNWf+tRHIyNMkQzQta+dwcWGUMQ2CgIbjzIPz2P6m6tGBBB/MaAUHIoKQAvfoKFsTsGs554W
 d+RfkTlrveMM9y7M/uzK5GWo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 292699053d277396;
	Thu, 17 Sep 2026 09:59:16 +0000
X-Mizu-Trace-ID: 292699053d277396
X-Migadu-Flow: FLOW_OUT
Message-ID: <4e59f610-d4ca-4f88-bae8-d60464f1ebe9@linux.dev>
Date: Thu, 17 Sep 2026 17:59:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Colin Ian King <colin.i.king@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mina Almasry
 <almasrymina@google.com>, Mike Kravetz <mike.kravetz@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/hugetlb_cgroup: move per-node usage on cross node
 migration
To: Muchun Song <muchun.song@linux.dev>
References: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
 <20260916-for-hugetlb-charge-v1-1-70fb708b2e4a@kylinos.cn>
 <E35A1286-33DF-4B54-8338-888EE28BFD06@linux.dev>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <E35A1286-33DF-4B54-8338-888EE28BFD06@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB4EE160007
X-Stat-Signature: cxd3wcweabtf6w87swdh6tgoo66quti6
X-Rspam-User: 
X-HE-Tag: 1789639157-655705
X-HE-Meta: U2FsdGVkX18guP2Qs3yQOzbyeJoZzxc05AmXOOOu8gCF7+2CZaR4ALcojRAJt7YnYhcVk7Bv45luvCyEQ6Hw6z1fwhjXVYoM4qiZa3CDRAygP0Re4vrJJobaoKdjTQF+2oPjKHNBnwkFElj/6oox4iKXmfYjdLrJOCXXkGfddxi35vziiaFc/hpcSCaYlnIv6Vi8jQW+F4gDL9u9bdWpxi4BTppA2aIuGsj0AQyU4bxQzNOW2oALQZWK5eWdgWfDrEJbfDQVf62d73VJSyYTeirOdkowg7WOeiXzKOo8oWF3eqHzUA3k7gAy0IshyaMLnak/CFUuQqqHm/AYT3/y63nxM8PKNzaPWK8FFK7/zM1fQ+LJg4pjrBscGF6DJW/KODNpDdTvBWRwjr3tPOEcXMyPyQrFfnqnxhc6uJAsSVf2dHGOgwXPjPvj/+JKyGLe18UyBmnbpAxoZpCN4HoWNF9w41bRk7r7GFsNxlHsSxmwz7SahA5u3q/+eg6kpDxYlGXTT60ZLqETDOvjUQq0u1fw5hT7VIRXHvXNmSZYMXBG7+ewftKXmEGsTxedUc30sTHqetUc4A83AkK4efyXs4llCRhxUvkT1JAM7WxI8hZ8NVg1Ufm6EOac7ATA/+anYHLEl34vc8z8YSjn4JOxVfYV/nsjTp7Asi1MC1vVBedBllsJ5ArLIiEvX7ldv4jB6R7nLzpVljGFAa36XLXsp03BjIh86eE6leBacjky1wph5aOw8mk+/VTESuga1F1VC9FcA+EeTFHk5ayoJ/+5A+5oGzsK+dNwJ8H2rHZmc1ubQKYWhe2/7Gfq9uSQIAd65HQxmAijtoFvzM4sW40f1KxJ+KOWZ8XpcIGsxtLEujyHap4XZdioqQa7O3Yz0ZqeboTbgbo/i8PkCH/EzxYMU/NNleNqWpQ0ym3s6AdxikV+sONwTNcV/8nwFZ+ZPbYtiSrYEYFCkLRLYI+haH1
 7h+Qkq7C
 4zLuVHh4YXWkTDwKeoiu2LCtDrlRXAlppihkiAZwrW2udN6gIFUZqLPYLSEUS+w4iEH+ALXfhmIodFSkjL5n4WNSt7fU33TxfLDqQWzew7hAUxUJ19i9fNc7Ll8cVfE4++ebPl44Dju3kruX7h7XMrfTYC+2onMBxD5tdJOTowDqfr6Redo7xHwHAmhxpPYdrRMryTOJnmEx23OyKQBw2f1US02uRlGXjrZEbocuFwTgrkiPO3k4n106McNxni1Ny8aNCOXY1PLzmtg+Zr0qfpcGSO6Bmz9mXlLoDu3+j6TinooJBNk/tQedbLtG4tTkw9OfCIpsqGu0VsnPjJKelVoq9JRX2TKGJS95cdBdYVIR0uJp/VxS9ORIpwVNLPvo6Rhvpct9OP9BsWRGfh+t8ltj3vH7EVBVeq03ubqTXndA9z3gloisToiL3l70wzocGGa6/DxPXGcHUfSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/17/26 1:58 PM, Muchun Song wrote:
>
>> On Sep 16, 2026, at 16:30, Hongfu Li <hongfu.li@linux.dev> wrote:
>>
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> hugetlb.<size>.numa_stat uses folio_nid() to account usage in
>> __hugetlb_cgroup_commit_charge() and __hugetlb_cgroup_uncharge_folio().
>> hugetlb_cgroup_migrate() only moves hugetlb_cgroup pointers, leaving
>> per-node usage behind on the source node during cross-node migration.
>>
>> When the migrated folio gets uncharged, we subtract usage from the
>> destination node counter. This creates stale usage on the source node
>> and unsigned long counter underflow on the destination node.
>> The hugetlb.<size>.numa_stat interface exposes these incorrect per-node
>> usage values to userspace.
>>
>> Add a hugetlb_cgroup_move_usage() helper which moves the usage from the
>> old node to the new node, and call it from hugetlb_cgroup_migrate().
>>
>> Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> ---
>> mm/hugetlb_cgroup.c | 31 +++++++++++++++++++++++++++++++
>> 1 file changed, 31 insertions(+)
>>
>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>> index ecb6e0b7819a..1040406e7e1d 100644
>> --- a/mm/hugetlb_cgroup.c
>> +++ b/mm/hugetlb_cgroup.c
>> @@ -179,6 +179,34 @@ static void hugetlb_cgroup_css_free(struct cgroup_subsys_state *css)
>> hugetlb_cgroup_free(hugetlb_cgroup_from_css(css));
>> }
>>
>> +static void hugetlb_cgroup_move_usage(struct hugetlb_cgroup *from,
>> + 				     struct hugetlb_cgroup *to,
>> + 				     struct folio *from_folio,
>> +  			             struct folio *to_folio)
>> +{
>> + 	int idx = hstate_index(folio_hstate(from_folio));
>> + 	unsigned long nr_pages = folio_nr_pages(from_folio);
>> + 	int from_nid = folio_nid(from_folio);
>> + 	int to_nid = folio_nid(to_folio);
>> + 	unsigned long usage;
>> +
>> + 	lockdep_assert_held(&hugetlb_lock);
>> +
>> + 	if (!from || !to)
>> + 		return;
>> +
>> + 	if (from == to && from_nid == to_nid)
>> + 		return;
>> +
>> + 	usage = READ_ONCE(from->nodeinfo[from_nid]->usage[idx]);
> READ_ONCE is unnecessary because there is no concurrent writer.

Thanks for the review.

You're right, the READ_ONCE is indeed unnecessary here. I'll drop it in v2.

>> + 	if (WARN_ON_ONCE(usage < nr_pages))
>> + 		return;
>> + 	WRITE_ONCE(from->nodeinfo[from_nid]->usage[idx], usage - nr_pages);
>> +
>> + 	usage = READ_ONCE(to->nodeinfo[to_nid]->usage[idx]);
> Same here.
>
>> + 	WRITE_ONCE(to->nodeinfo[to_nid]->usage[idx], usage + nr_pages);
>> +}
>> +
>> /*
>>   * Should be called with hugetlb_lock held.
>>   * Since we are holding hugetlb_lock, pages cannot get moved from
>> @@ -906,6 +934,9 @@ void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
>> 	/* move the h_cg details to new cgroup */
>> 	set_hugetlb_cgroup(new_folio, h_cg);
>> 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
>> +
>> + 	hugetlb_cgroup_move_usage(h_cg, h_cg, old_folio, new_folio);
>> +
>> 	list_move(&new_folio->lru, &h->hugepage_activelist);
>> 	spin_unlock_irq(&hugetlb_lock);
>> }
>>
>> -- 
>> 2.54.0
>>
-- 
Best regards,
Hongfu


