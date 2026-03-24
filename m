Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C80F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 02:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515376B0089; Mon, 23 Mar 2026 22:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C67D6B008A; Mon, 23 Mar 2026 22:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B56B6B008C; Mon, 23 Mar 2026 22:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25F186B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:46:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 884B21B987A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:46:39 +0000 (UTC)
X-FDA: 84579418518.03.6287187
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95DBB120011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:46:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a/glTq6O";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774320398; a=rsa-sha256;
	cv=none;
	b=l4zOfa2OqM/2LFXCiYONdBZgODmgACBQva9pRKPDYeiOwac4vLS6x1VwnLQNbESAgL/dyZ
	3bewXmLJQ5eONTC3rFhgm/+xxZvuWLOKjq0SczegdS3agmhFIXSq9upC0pfLUxBmI4u7/k
	LpiXOc0El71Cia9XA/CAqqZZ7Kovk80=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a/glTq6O";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774320398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGGy2UriqUad3XopEFOCAp7JAApD+roBCI5i10BvlVY=;
	b=1EgLGkaJxhfwxqKb5UG2VlcAH8qrsuF5yUo5qg7cfZgPTEwLBILChgGWzUT2qJTzrHMe7i
	korWT8djX4GoS+8TzoZ1J/o46KsTpmz6JIeEIP139owUTK4fL/SQx97aMxvsDuP85liPbp
	U94vQYYA3tgpieGmUyf3tnMw4zcJcrw=
Message-ID: <a17b441e-fe6f-4e5c-ab26-0ab71475fbbc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774320395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGGy2UriqUad3XopEFOCAp7JAApD+roBCI5i10BvlVY=;
	b=a/glTq6OdDzqBk054fBaNRf1YQfSf9qqa7zrtsfqKjMT3HrWJygwOce3dCrKDI4GSd3pED
	v8DRAwlqTMrxaaax61tUHbDrPY4EpNBhEZUV0NakFcOZckuBTbbPVoc/RROZXQ/4LmTx6a
	MePPyWSY1LxmmfhvQscxvIgF0NUGahY=
Date: Tue, 24 Mar 2026 10:46:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 26/33] mm: vmscan: prepare for reparenting MGLRU folios
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e75050354cdbc42221a04f7cf133292b61105548.1772711148.git.zhengqi.arch@bytedance.com>
 <acFALMLIvjP4i76U@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acFALMLIvjP4i76U@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 95DBB120011
X-Stat-Signature: whn7efqh4381mh7g6r8mm5qy9cgxgijg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774320397-91529
X-HE-Meta: U2FsdGVkX18NQ4F8wUP5iz48KNjL2HZ+CR4kO2m6aUdNQE8XRcvYmEr8CMaRWFT+sfwyf/KWrp+hKHkA8aiIadpmf1vimfVnTm8nBRuITjvwy3x9g9azaWThS6DfIzS4qXztW3alStYhPVS+leGo3qG+Iqtjl7RldeTyAcmtJNJL/cJ2zfJOKFoyZtqb4QXhDJGoz8M8roMW4eskeM6mBb7IV0fXOPCunwLgxCseDlTCbiF2DMYcdK8EpufZLUMy+Lp2TYFrbBhO5JpAX1yolQ0nhgiCT/NgZ4XgM+qwrval3lkIEeh76TdMvqO0n0vE01XwLP+2I/0734c1fSwZ9lCuSo3Wcfz90oI7BnAYoYclbtWOCvuXt1trQFsLQk1YgZLcHTOtaKo8Mo2xQj8pD4S8rEU89HBPo7xScPCywlTu15v3UfNMh5tAWVLzVUp3rYFMu5Lfb5lHQ5BpfMJYfPjWnIxXm6yEq377qKK4wg/QGzRYXyzVW9JY0MsMEI5R9zrt6I1MoV635dw8WKBClg3ExbWqRM20PESN7n646JxF6Su/VrUby1s1NMS1tE9HEQ3vLuYF/GHvWoMygb2JXgmJwvhS6jeyynE44uWC4T/todDcoF0JJ0Fs8AEfqtlwVkZITzVUlNMDv4lR/5SW2JcSX9gVqwu/hZLAJw3JBnzZtnxDb9bK4o2mT1i/C8e2gMoE9/HUHIP0UM7aSq/eqmtB5Kom72JJ5zVwdwZbKCJA+Im/ch1nPhq4c1UPLRnJZnHScsaYPxNWLkbdwpuxzdldVSG3JdI3Lji/sqR8tjoSyrOkU2v/hKIFwuo+bOrUxdJpAxp/dJqHXUsvSaHYqdPzEspnEaTzkBx/esc6CEp2M/Uw/aJ3G6GXAtxaQmMI2xw/g9isAqmo6Sr8WQO7IcoV64/z+SzwVaRq6eCapsHDNRvjrRr8A4iJk8STDdvhFx/+tkSuWKW6Us5apNB
 WVvajsyL
 o44yLU2B0UiVhiwkieqbzsp2OUOLOiACSNdUoFHjsPMe/AjSoZgfQ9azOxlv+SIODjUN37NiAy3/GyqAXXXREnty1QC/Bx+LCVoGsCInxxpbmJpVvWrJVkEd/dTGuYs6Pd1arsxKB+Gq12FkMzKntuoRIzknNWWfXCoIJaiSC9imTSkMnlvua6OkCtq3ePXY6JocsGXJABxyK50Uh4PObGzPo5DbLt7qbzl/q0MWC4fZzHthGRzciiFKoigRzSeDZyVmn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/23/26 9:29 PM, Harry Yoo (Oracle) wrote:
> On Thu, Mar 05, 2026 at 07:52:44PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Similar to traditional LRU folios, in order to solve the dying memcg
>> problem, we also need to reparenting MGLRU folios to the parent memcg when
>> memcg offline.
>>
>> However, there are the following challenges:
>>
>> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>>     number of generations of the parent and child memcg may be different,
>>     so we cannot simply transfer MGLRU folios in the child memcg to the
>>     parent memcg as we did for traditional LRU folios.
>> 2. The generation information is stored in folio->flags, but we cannot
>>     traverse these folios while holding the lru lock, otherwise it may
>>     cause softlockup.
>> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>>     may be updated, but the folio is not immediately moved to the
>>     corresponding lru list. Therefore, there may be folios of different
>>     generations on an LRU list.
>> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>>     found based on the generation information in folio->flags, and the
>>     corresponding LRU size will be updated. Therefore, we need to update
>>     the lru size correctly during reparenting, otherwise the lru size may
>>     be updated incorrectly in lru_gen_del_folio().
>>
>> Finally, this patch chose a compromise method, which is to splice the lru
>> list in the child memcg to the lru list of the same generation in the
>> parent memcg during reparenting. And in order to ensure that the parent
>> memcg has the same generation, we need to increase the generations in the
>> parent memcg to the MAX_NR_GENS before reparenting.
>>
>> Of course, the same generation has different meanings in the parent and
>> child memcg, this will cause confusion in the hot and cold information of
>> folios. But other than that, this method is simple enough, the lru size
>> is correct, and there is no need to consider some concurrency issues (such
>> as lru_gen_del_folio()).
>>
>> To prepare for the above work, this commit implements the specific
>> functions, which will be used during reparenting.
>>
>> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>> Suggested-by: Imran Khan <imran.f.khan@oracle.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>> +/*
>> + * Compared to traditional LRU, MGLRU faces the following challenges:
>> + *
>> + * 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>> + *    number of generations of the parent and child memcg may be different,
>> + *    so we cannot simply transfer MGLRU folios in the child memcg to the
>> + *    parent memcg as we did for traditional LRU folios.
>> + * 2. The generation information is stored in folio->flags, but we cannot
>> + *    traverse these folios while holding the lru lock, otherwise it may
>> + *    cause softlockup.
>> + * 3. In walk_update_folio(), the gen of folio and corresponding lru size
>> + *    may be updated, but the folio is not immediately moved to the
>> + *    corresponding lru list. Therefore, there may be folios of different
>> + *    generations on an LRU list.
>> + * 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>> + *    found based on the generation information in folio->flags, and the
>> + *    corresponding LRU size will be updated. Therefore, we need to update
>> + *    the lru size correctly during reparenting, otherwise the lru size may
>> + *    be updated incorrectly in lru_gen_del_folio().
>> + *
>> + * Finally, we choose a compromise method, which is to splice the lru list in
>> + * the child memcg to the lru list of the same generation in the parent memcg
>> + * during reparenting.
>> + *
>> + * The same generation has different meanings in the parent and child memcg,
>> + * so this compromise method will cause the LRU inversion problem. But as the
>> + * system runs, this problem will be fixed automatically.
>> + */
>> +static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
>> +				     int zone, int type)
>> +{
>> +	struct lru_gen_folio *child_lrugen, *parent_lrugen;
>> +	enum lru_list lru = type * LRU_INACTIVE_FILE;
>> +	int i;
>> +
>> +	child_lrugen = &child_lruvec->lrugen;
>> +	parent_lrugen = &parent_lruvec->lrugen;
>> +
>> +	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
>> +		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
>> +		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
>> +		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
>> +		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
> 
> Not a correctness thing, but...
> 
>> +		/* Assuming that child pages are colder than parent pages */
>> +		list_splice_init(&child_lrugen->folios[gen][type][zone],
>> +				 &parent_lrugen->folios[gen][type][zone]);
> 
> I think the other end (tail) is where cold pages go in MGLRU just like
> in the traditional LRU, since  lru_to_folio(head) returns the tail folio?

I checked the history, and in v2 we used list_splice_tail_init() here,
but I don't know why I changed it to list_splice_init() in v3.

Right, lru_to_folio(head) returns the tail folio, and lruvec_add_folio()
adds folio to the head, so the tail page is colder, so now I think we
should go back and use list_splice_tail_init().

Thanks,
Qi

> 
>> +		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
>> +		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
>> +			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
>> +
>> +		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
>> +			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
>> +			__update_lru_size(parent_lruvec, lru + parent_lru_active, zone, nr_pages);
>> +		}
>> +	}
>> +}
> 


