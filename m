Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4914DFA0C30
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A138C6B0093; Wed, 15 Apr 2026 01:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EAE16B0095; Wed, 15 Apr 2026 01:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9288F6B0096; Wed, 15 Apr 2026 01:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3B06B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:51:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AD96E3CD8
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:51:25 +0000 (UTC)
X-FDA: 84659717730.27.57A9459
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27F94100003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:51:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O1wBKG9X;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776232283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fk7YcQ6QKf5fLUVsvamkPBjeLdGsl9ofX5zFjUfyoj4=;
	b=7O77PokOZu6RZxLbDkKRozjS+wbH1iYrWANJcuJvFdEEoppk0yec9IN29dhhfPwp14ZYtS
	uwRXHZ5jG58afQSpfR47w5NSheI1P4ywMLtTNFKwXb4LZ9J8IZyYACWpIMCQBg1XOa+kCM
	ckiFQc/2UYUL55zy8sC8kNaHQOaPWL8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O1wBKG9X;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776232283; a=rsa-sha256;
	cv=none;
	b=scMG/K7yYzzYRuAxYEZBY/+DIRonFcdnVqgpecgJ47u3QXiq6JmIWrOzMx87B9ZHSRN2eH
	XjV+7T+8acJeXQvBtpsfZ4A/IZ4TNuxtJuQ4XBqu+4WCd2hVXK9eeAmA81ydkOVPYFInna
	uKo9GDHbZhw2077e+G55Bt4IAV4xGrw=
Message-ID: <c55c49d7-642b-4b99-a2c7-053cb88541d0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776232277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fk7YcQ6QKf5fLUVsvamkPBjeLdGsl9ofX5zFjUfyoj4=;
	b=O1wBKG9X40Zk2mMmuCRqGjMgiGlRuDC+q7N47GfqkXQg8WL8pshpe1HRLc8NEm4jemSF8b
	KgwkiMqtYJtlqorV/PWC5OtuPCGZ7kX+05rXeX6JYXYBzdYL9Afx3DUG7G1ez7TRaZOpgH
	dMOzuM1aV4jv9sXiJ1KcbwLPMnmhQWY=
Date: Wed, 15 Apr 2026 13:51:02 +0800
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
References: <20260415022910.1890050-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260415022910.1890050-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 27F94100003
X-Stat-Signature: wabqz631aq1h8xy44orfa1ek5opsncpj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776232282-351301
X-HE-Meta: U2FsdGVkX18XHbT4ubwUDoWBxoCsQoLr8K47FszAN6QEQ5dN5MQv8Aczsg6+K+nxDC/GX8uMN3q+DRLVgEjMTeDOGkzVIMThgtObNPn1sPCrOM6rxDW5UpGuyByfHDUuCve4edn1Ct2L3Sw0Z8rpoeaMY1VxGB5XHJQTwhJKfzAP4FslmK7PsIVQiiucVHLiLCJg6svy0izNWPerzKbdveicAtfew5AxaSPDjQ6km77H43RqmOoF7+mQfmlLLySa2+UkIR5Ca2owD/gIooeaqjD2qFUkG2CtS7x7XLVEcm4LG9q+bYHQAMG/aHYfCu4DRvuqUkQGLB2otLO+rcWoa5/hpiuOA5Bhtgeb3TJr/CrE4DH29fuKsoCqspcKTI65isP6UqA9A9iGUQn5LnWB8xx7qor/x8AJyUCjcYP3V66Hr2vaTIH0BzvCkwY21Z7vzK0oj97XntpgxWqViMPkHuWnlyVWvj/V0+db8IaiNYlUAEnqB9LR1G+bH+IB1hc/IfcZ5RjXICJ65hpdHBlaBtoV//90UQdWxbNdZNkhskew94YA2cTQFzUxoJWWqithBx0Uu/UJ23Gua6fx7w+TK6zVO4NQqJAf/Ih/FzYv69x57RihJwM4t4aE7WIVqJxUIdB6k7N4BrQpxEF7uW8rP2ZyqvB/TJb/z+QFoHSAIrVdwuU/rK7m1eQTnToT/adCIDC+1RtjAYxpj99OFFo1iz10H3m9AlVdUxPlt0yyUGdOEeserpXdS81giNmYo6h1jpl+0erYMfbJq/49Uq5RW8LR7LGn94RTQi9znbbgZu3hLB+qyauegYq1SUCUkqEjzFC7T64T7JA1f2b7Fb2Adm2vLr5viNXi9+xUGo7QZgwgAYUxgP+4N9e6svyy3le0dytAMfQ3Uqtl5m0nA5IQgdUIctA9AdfpDZqRuMyDAOYzuXODThygopPY3DoyeY0/yQL0PyBFPGYFJ8T8L80
 3i2JP68Y
 XDgCClHkKrIycXS8tgUff3ljXwYejpvwEL1EiKllTK8/SGxRNGDtLyrG31Ju3FG6r/FoaqHIwfLGAEZ3Zygo3MVKJFZ1dEd3GQAGWuulM72tswqx71UcS0lXp1uphSnNvqYZe7gfknXIcsuQFdqfX6b51dmAaKnP6GjLt4R0dsGggbB3Voj1qO2xXxIhMX4NJZnvIZHbAlXLO/YE4v00hOjI/Rh9BbKg3o30gTBDXA5UPE34ZOkDxws9P31l8wAs6hR5gYJ/YiW4RdoatG7IhKXA4RxPV5oOMUY9b52QtVYTbcvjkCrVSWuesCWDWjAiOtai2FPLfn8FBfBwhNn3BA6qYaRtueQQ0XdVX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/15 10:29, Joshua Hahn 写道:
> On Wed, 15 Apr 2026 08:50:54 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>>
>>
>> 在 2026/4/14 22:59, Joshua Hahn 写道:
>>> On Tue, 14 Apr 2026 17:15:20 +0800 Ye Liu <ye.liu@linux.dev> wrote:
>>>
>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>
>>>> Replace the single call to __node_stat_mod_folio()
>>>> with node_stat_mod_folio(), and remove the dead inline __node_stat_*
>>>> wrapper definitions from include/linux/vmstat.h.
>>>>
>>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>>> ---
>>>>  include/linux/vmstat.h | 18 ------------------
>>>>  mm/page-writeback.c    |  2 +-
>>>>  2 files changed, 1 insertion(+), 19 deletions(-)
>>>>
>>>> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
>>>> index 3c9c266cf782..54da7d820f78 100644
>>>> --- a/include/linux/vmstat.h
>>>> +++ b/include/linux/vmstat.h
>>>> @@ -440,24 +440,6 @@ static inline void zone_stat_sub_folio(struct folio *folio,
>>>>  	mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
>>>>  }
>>>>  
>>>> -static inline void __node_stat_mod_folio(struct folio *folio,
>>>> -		enum node_stat_item item, long nr)
>>>> -{
>>>> -	__mod_node_page_state(folio_pgdat(folio), item, nr);
>>>> -}
>>>> -
>>>> -static inline void __node_stat_add_folio(struct folio *folio,
>>>> -		enum node_stat_item item)
>>>> -{
>>>> -	__mod_node_page_state(folio_pgdat(folio), item, folio_nr_pages(folio));
>>>> -}
>>>> -
>>>> -static inline void __node_stat_sub_folio(struct folio *folio,
>>>> -		enum node_stat_item item)
>>>> -{
>>>> -	__mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
>>>> -}
>>>> -
>>>>  static inline void node_stat_mod_folio(struct folio *folio,
>>>>  		enum node_stat_item item, long nr)
>>>>  {
>>>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>>>> index 6f9b7b081ab7..ed3301753e89 100644
>>>> --- a/mm/page-writeback.c
>>>> +++ b/mm/page-writeback.c
>>>> @@ -2627,7 +2627,7 @@ static void folio_account_dirtied(struct folio *folio,
>>>>  
>>>>  		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
>>>>  		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
>>>> -		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
>>>> +		node_stat_mod_folio(folio, NR_DIRTIED, nr);
>>>
>>> Hi Ye, thank you for the patch,
>>>
>>> In addition to what Matthew has pointed out, I also wanted to note that this
>>> substitution isn't trivial; there are differences between the __ prefixed
>>> version of node_stat_mod_folio and the one without. Even though the correctness
>>> of the two versions might be the same, I think that a change like this should
>>> be supplemented by a description of what side effects this change has
>>> (i.e. introducing additional overhead from the cmpxchg loop).
>>>
>>> Thank you, I hope you have a great day!
>>> Joshua
>>
>> Thank you for your review, Joshua. Regarding the difference between
>> __node_stat_mod_folio and node_stat_mod_folio: in the current implementation,
>> both functions ultimately use __mod_node_page_state, as mod_node_page_state
>> is defined as __mod_node_page_state. There is no functional difference
>> between them in terms of atomicity or overhead. The __ prefixed versions
>> were wrappers that are now unused, which is why we're removing them.
> 
> Hello Ye,
> 
> Thanks for the quick response. However, I'm not sure that's true.
> For #ifdef CONFIG_HAVE_CMPXCHG_LOCAL in mm/vmstat.c, I can see that
> mod_node_page_state calls mod_node_state, which includes the cmpxchg loop.
> I think many users enalbe this config, including x86. IMHO, we should document
> this effect of the changes.
> 
> Thank you, I hope you have a great day!
> Joshua

Thank you for your review, Joshua. You are correct that there is a difference.
The __node_stat_mod_folio call goes directly to __mod_node_page_state, which
assumes the caller already has the necessary serialization. By contrast,
node_stat_mod_folio goes through mod_node_page_state, which on systems with
CONFIG_HAVE_CMPXCHG_LOCAL uses a this_cpu_try_cmpxchg() loop and on other
systems serializes via local_irq_save/restore.

That means the wrapper removal is not purely cosmetic: it changes the
update path from a direct per-cpu diff update to a serializing update
path, and therefore incurs extra overhead.

-- 
Thanks,
Ye Liu


