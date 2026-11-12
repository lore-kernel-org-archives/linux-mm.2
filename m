Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE46D606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PbWsbuTx
Received: by kanga.kvack.org (Postfix)
	id C98DD6B05D2; Thu, 12 Nov 2026 03:46:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A316B05D3; Thu, 12 Nov 2026 03:46:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F846B05D4; Thu, 12 Nov 2026 03:46:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B55F6B05D2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:46:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B1A3C04DF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:46:10 +0000 (UTC)
X-FDA: 85425834900.14.6DC5B71
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf18.hostedemail.com (Postfix) with ESMTP id 17A731C0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:46:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PbWsbuTx;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41nsNdC3zdMjNaUNJgC+leDUiMtoCdh+/HNf/Dul+ro=;
	b=hJtqotBA8IQm0vkQjFZwmPPLsU+6namLkplj9nvpPg5Dd0DGjasGyANh5RUMqlyyQzIPLz
	UFR140RQsQuhAL0DKGPZBQkDCqmaWHN5ZBzAxKMH5NKYtyVo8YgB9W/CiWyEHoKNhPHFQi
	fzV+MSH8xu84K7UWO4GGuDZXouH76lQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PbWsbuTx;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794473168;
	b=wlWxU0Ro5TJbkFZBNFyjbsHW9feJ4cIDz8OwPyCtx1eor7RdEcpZIL1/779GD+aKPBNxyj
	aQkLVxArOdbimhqdY2GLY7lID8qSSbpNQzm09x9PDb6lGZ16Lt6hFmHV6X9EXAyRuTbGx9
	vQRGYhQH44pJPI5Hjz7O7ghLNDruVCY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794473163; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=41nsNdC3zdMjNaUNJgC+leDUiMtoCdh+/HNf/Dul+ro=;
	b=PbWsbuTxFR3Gf9eWQ9Rfn2G4msjHKi8/9yltpuhpSE8Wc9/chBT41b+lkzDD9rrgzUi9TYeP6PtwGOo6G8p+0FYfIcmoTvLrJAd+0zWaFXZw8cJ9/ecf0jo0zdpqqUw8dfHkfHqODEFBCzkNWI/NiHAuE4qQAUORLrrixMjUZwE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XEbXuRi_1794473160;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbXuRi_1794473160 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 16:46:01 +0800
Message-ID: <6722b853-3a80-439d-aee8-712011965d49@linux.alibaba.com>
Date: Thu, 12 Nov 2026 16:46:00 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: splice all generations when reparenting a
 memcg
To: Kairui Song <ryncsn@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Noah Feldt <noah@feldt.systems>,
 stable@vger.kernel.org
References: <20261111000913.22943-1-shakeel.butt@linux.dev>
 <CAMgjq7B+PE-Tw_v3bKYzNOTaT6+0_fn8gW7sNpMwzP1tPGbDug@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7B+PE-Tw_v3bKYzNOTaT6+0_fn8gW7sNpMwzP1tPGbDug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6brr3uis666o53au5tdqmethdigahrt8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 17A731C0002
X-HE-Tag: 1794473166-968648
X-HE-Meta: U2FsdGVkX1+pqNaLWmAXVEqnjGnl3240AUH4dJkBIUwZWJlwvERmyZZC3NlGmvli+JfrKBm4O/DxO+yKFJ0MnchriqzJXy0H/BCUNoLyZnqEhwzKvnuK5EIRAYgJAODfyoD9Vdx61b1UWAhsUNpVaOVrtcOGpgQL/f9YNvJcUUhQWAN42Y8TiZNIySEgtdHIhlfeyEhWCMQUta901vt5uQ0sHepw586xdMXwxvM8n2zX5518awUnf6fkdL5rUd4P63ZprpxCXiplreahxSX8xN7QI916diR6aR9lLewY2nJS0MH8sKM1Ovq/YLMF0FwIo5h9ISgoBTBuVqbPFIPndBWsnhO2jFaNQdS8no6YgYAOakw5JvZaOhZCnS8RSt4qUX5UAQ0guXe30QdTuYRv3R6SnSFqttBIyZK4KpMxOr4kfAOoT6jg2Q3uIlWuBvU+rPeMsd9dfLm+OziTMC2WvJeqDPJ2qUzJiTLpOc1mDgWtTrHNkCkLCGMakQk3QnYEsNq0Ljeh9HGPJS21sbqAr1v14Yu1B5g6urDObNxz/N8DRBWrKq8pGW5Hsy2v3bq2rcTEu1GuvvIoxf+S4TgdtrUvzlm+mWVoMbRPqPK6am49M8VMKJQavII662BvHbHtrUbHXqaWYQL8MRiiTpbM88IkT70v65LC/4HbOivmNt0kGXoJK665S0DY/h/kkIeZdF49iHGT1RuYOTOFzyfn0PeUNkfuHb9VwV6HM+XiMsxc2xuqxTUGxb+R8mkaaJwaSEDL3iSU9ukL7Nq6hX8XtmWLkuvlmmdxoswhl723+VMVCL91BZDq+zUwxCXMZf2bmNA0n1H2A5/eOMBnO+D5t2CN5R8JUJMbOQvw0Z8Wrolq6MIbKaFvKSpbfAweyEyk9vFqUXsZe0MIOluIm/BzN+Ty3yrk1kCkolkuB/UakehqM0lIXKRqRcWd39tZFFPPhj2Wwu4N1P2IkfneXFQ
 WZ9XxgUr
 7AYOCjjwYoY9lj5sgfQLSf4VFPj9uLhyT/crXCKJ/lap2/K6yJ8WCnKY06MIMRHP0SbUZlLuedHCCJFogHLhXtcFtOJhOZByRGYV+U1n6K1geMES9DHYjhPiesAACm7yHLOz6f9mY/0HFeqNtRneF1FZXmBP2QPRxuTp2RcZbQeeLbIE4i7qV5IEVccsYcB4klEWfMMXl+tgXZg8Jdv+pZil6peb+79DmuxOZIqUNDPv5LzmhEnnmWwqfSmEAWcG0kEFfZK6d3NIpM/c1BDu9cJY1JudQKjHsSnJV4Rw8zmuevYr9ksKcwMQxBZE1YrlA4u3PSoXuU8E3sEWjVsTPXAGmIZml/147B/Pb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 2:13 AM, Kairui Song wrote:
> On Wed, Nov 11, 2026 at 8:10 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>
>> Noah reported list_del corruption on single-node hosts running 7.2.11,
>> which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same
>> as its node"). The bad pointer is an MGLRU list head in a freed
>> mem_cgroup_per_node:
>>
>>    slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 size 1920
>>    list_del corruption. next->prev should be ffacf881ccc70e08, but was ff31bfa36a3ca010. (next=ff31bfa36a3ca010)
>>
>> When a memcg goes offline, __lru_gen_reparent_memcg() moves its MGLRU
>> lists to the parent. It moves only the generations (gens) from min_seq
>> to max_seq, and it puts each list at the same index in the parent.
>>
>> A folio's gen in folio->flags can be ahead of the list it is on. In the
>> parent, the same index can stand for an older gen, so the folio's gen
>> can end up older than its list. Once the parent's min_seq passes that
>> gen, sort_folio() puts the folio on the list for max_seq + 1, where it
>> stays until the next aging.
>>
>> If the parent goes offline before that aging, the folio is not moved to
>> the grandparent. It stays on the parent's list after the parent is
>> freed, and the next list_del() on it touches freed memory. This needs
>> two cgroups on one branch to go offline one after the other, such as a
>> container and then its pod.
>>
>> The parent always has MAX_NR_GENS gens at this point, so every index is
>> valid in it. Move all MAX_NR_GENS lists, not only the gens from min_seq
>> to max_seq.
>>
>> A reproducer that drives these steps through the lru_gen debugfs file
>> gets a KASAN use-after-free on the freed mem_cgroup_per_node without
>> this patch, and no report with it.
>>
>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>> Reported-by: Noah Feldt <noah@feldt.systems>
>> Closes: https://lore.kernel.org/all/20261110132853.71228-1-noah@feldt.systems/
>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   mm/vmscan.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 6a1af9b92349..902616a3b755 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4751,19 +4751,25 @@ void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
>>    * The same generation has different meanings in the parent and child memcg,
>>    * so this compromise method will cause the LRU inversion problem. But as the
>>    * system runs, this problem will be fixed automatically.
>> + *
>> + * Move all MAX_NR_GENS lists, not only the gens from min_seq to max_seq.
>> + * An earlier reparenting can leave a folio whose gen is older than the list
>> + * it is on. Once min_seq passes that gen, sort_folio() puts the folio on the
>> + * list for max_seq + 1, where it stays until the next aging. If that list
> 
> "sort_folio() puts the folio on the list for max_seq + 1" seems not
> very accurate as MAX_NR_GENS - MIN_NR_GENS == 2, could be any stale
> gen outside [min_seq, max_seq], right?

+1. The comments are not easy to understand. IIUC, the problem is that 
the folio's gen can fall outside lruvec->[min_seq, max_seq], potentially 
causing the folio to be left behind on a memcg that is about to be freed.

But, yes, the fix is correct. So,
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

