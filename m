Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D967F9D0FD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 00:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4CAF6B0092; Tue, 14 Apr 2026 20:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24B56B0093; Tue, 14 Apr 2026 20:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961BC6B0095; Tue, 14 Apr 2026 20:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 832046B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:51:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 287711402D6
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:51:22 +0000 (UTC)
X-FDA: 84658961604.29.474AE7B
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 511DC1C000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:51:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J8YU0AlS;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776214280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mzC9E+DlpUUGq46xAvgFHlJHte5hw9EwrSfNtsp0mE=;
	b=dlATuMqyJq9LeCNzVazafRpmKqJQ8QQuZ6WLIuziGG7GhhcFbLk22/Jy4CdeTReGNEUtnN
	6e8OV9Nx3zpe+vFrFDJa7FlK8j3TwVHPv6BmCemYEFF8qeL10jkMudbwawZ+mzS/GxJGQp
	oDDsVF2Te+FKF2DwUIShgO5aiylnAro=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J8YU0AlS;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776214280; a=rsa-sha256;
	cv=none;
	b=sQ4uKgt7S0pOoaJESeH4DgoBeXs+NSy6wtoyr6gnqfQfMEr0MX9wg3eoUWW3iPeVHz71GE
	Iu9NiSBVjyJWeRsYuJBaqCqdFiZEIV8ShHaSuUR0TrH7+CgA3PRyjNW7wODIZB+8zErEUY
	gE5oasy6wuMH/IEagkUNk4cNIBvdhiA=
Message-ID: <9a852e74-1499-4a5a-8e98-56a33c67d639@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776214278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4mzC9E+DlpUUGq46xAvgFHlJHte5hw9EwrSfNtsp0mE=;
	b=J8YU0AlS5C5k/kXq7rlFACUywmi7oGfW7YBS4Bq+IlpZTYRixEXAT3hqtLFusz3FxsXs6B
	rD8AsY97471H0gKZlgTZq1ZtamhUSPOnl8FSJVkIFg+jDSjB0vMtLRP3uLZDLFDplN4CFi
	027XHKDxVHXTl5dh7RIN1ZMbHGu5Pj0=
Date: Wed, 15 Apr 2026 08:50:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] mm/vmstat: remove unused __node_stat_* wrappers
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Ye Liu <liuye@kylinos.cn>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260414150001.3262806-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260414150001.3262806-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: o8wo5yyi9y8x9kaneu7p3u8rxk6uofuw
X-Rspamd-Queue-Id: 511DC1C000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1776214280-161048
X-HE-Meta: U2FsdGVkX1+BjzJv+ifJIoAoZBeerpGAH0PBWktecJzAro52grtbAWzfUn62UdRMQ9B8Iun5Ay4732eZfYgOz4pcCxch/wwFsC3NMwDQ7dldO1pMXOribEKeqPND1aEBNygw5SC/mPloGTWQ265dXwIThiwvk7o6L38jda4Fbbuigi+EwJhoBn5fzQkHFy1zJeVORsks1LXtE727yrqFjK4WdD0ZqODoAMIBplBddUqymC8D+cnqKqAWyZZHhLjFb7QQdH4AC4wfqlX3X2eioiem3WKA8acvU1Qv6Cpj7gFp6XuSU9oZXgTa8dT5zrMudbk306Kokb6004uefBoWGOEPOQ1SE24/1Ur4v0JOREu6jVyZi7LKijkZM8ksjq+G6n1NUb2n/Sjoq81uN7MOabgx3MGUT0dAFGlLpyLIXcaGZwswnAVg2L2adykxTLgPV+SUCcOMMQeXxYj20Drri7EHqzztyUXz227yL6zEmG3LyQuMqlITD8iqRe2pZgNCpg1cjmi7zmo4V3FaiJt67PO3Vs6ty3dFJjHQbutRCX4lBzmiuiQeDtI8V+lIIIzaocCnLhiEdRKRdzU0Ih7IA7pmqopf4DyxPkGRZuioWEGBGldY+JkKAsm0xjsS0yVEci8nAHpzxjZqpSTMQ6o9p3V4HVpIJDrCDF319PppGkESfA/Ius4ykrDy2rbUC9ZjEosEb89w6AncED2gLEwTk/2zJ+4yGT/zFMQO6P+95nfBVVSJLnS2oWiHDdcVqp+xoP9YocjZWcOe5eCskQTL9zjhW05Gaq0n+aZgE1kcdJubslwurO0Zqp1QXrOG0zUmSL5htKMz7+vkhleOWCG3Q61Q1QDzXXlFAQfElvtmtdRbnYeBz1a1yWbxt4qOpY/PtqKDeKj5hLL++N/QjLKRNXOLOI5hHELWhl1UaacVIhU0cHUjJyB3vQZ9ecR6jMMnd73L156x6wYXz/wJ/Q1
 amMsPEYL
 mshLtYgvqIVqAziNMFjfHdjjzOJwkEJkaQrzP6KRLW0LI/o4qJdv4roMmY5lWUdXoK1eaXnnc4niwRVEBEw5LR613qCZPR7Hi1KSgE6bHEt9xdAFcFE87oqhHwBl/8ljVZEpyjCp6K0Afboov3XxhXzNukaOI4ASeD5OB2F+6myscXpgFqhwnTAxcdZl3ykn/id+BEn4K0ecCx056un69WNJ+yDG1ey1bW+jnwNgWP/eCRmk9E0YEUEUemuCpCIL9LLaRh+thnMIRiG0j6UFRJhmmZkReZkt97boAJ5XkO84Ef8oZZN1RlnjLRN+SDj4KYlSAZzJPuaTluYqkTdXmv5V78SCmFRSEjIHl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/14 22:59, Joshua Hahn 写道:
> On Tue, 14 Apr 2026 17:15:20 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Replace the single call to __node_stat_mod_folio()
>> with node_stat_mod_folio(), and remove the dead inline __node_stat_*
>> wrapper definitions from include/linux/vmstat.h.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  include/linux/vmstat.h | 18 ------------------
>>  mm/page-writeback.c    |  2 +-
>>  2 files changed, 1 insertion(+), 19 deletions(-)
>>
>> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
>> index 3c9c266cf782..54da7d820f78 100644
>> --- a/include/linux/vmstat.h
>> +++ b/include/linux/vmstat.h
>> @@ -440,24 +440,6 @@ static inline void zone_stat_sub_folio(struct folio *folio,
>>  	mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
>>  }
>>  
>> -static inline void __node_stat_mod_folio(struct folio *folio,
>> -		enum node_stat_item item, long nr)
>> -{
>> -	__mod_node_page_state(folio_pgdat(folio), item, nr);
>> -}
>> -
>> -static inline void __node_stat_add_folio(struct folio *folio,
>> -		enum node_stat_item item)
>> -{
>> -	__mod_node_page_state(folio_pgdat(folio), item, folio_nr_pages(folio));
>> -}
>> -
>> -static inline void __node_stat_sub_folio(struct folio *folio,
>> -		enum node_stat_item item)
>> -{
>> -	__mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
>> -}
>> -
>>  static inline void node_stat_mod_folio(struct folio *folio,
>>  		enum node_stat_item item, long nr)
>>  {
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 6f9b7b081ab7..ed3301753e89 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -2627,7 +2627,7 @@ static void folio_account_dirtied(struct folio *folio,
>>  
>>  		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
>>  		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
>> -		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
>> +		node_stat_mod_folio(folio, NR_DIRTIED, nr);
> 
> Hi Ye, thank you for the patch,
> 
> In addition to what Matthew has pointed out, I also wanted to note that this
> substitution isn't trivial; there are differences between the __ prefixed
> version of node_stat_mod_folio and the one without. Even though the correctness
> of the two versions might be the same, I think that a change like this should
> be supplemented by a description of what side effects this change has
> (i.e. introducing additional overhead from the cmpxchg loop).
> 
> Thank you, I hope you have a great day!
> Joshua

Thank you for your review, Joshua. Regarding the difference between
__node_stat_mod_folio and node_stat_mod_folio: in the current implementation,
both functions ultimately use __mod_node_page_state, as mod_node_page_state
is defined as __mod_node_page_state. There is no functional difference
between them in terms of atomicity or overhead. The __ prefixed versions
were wrappers that are now unused, which is why we're removing them.

-- 
Thanks,
Ye Liu


