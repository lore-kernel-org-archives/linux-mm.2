Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C74ABEFB7F3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 04:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E95C6B0088; Mon, 23 Feb 2026 23:25:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896BB6B0089; Mon, 23 Feb 2026 23:25:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778C06B008A; Mon, 23 Feb 2026 23:25:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 623AA6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:25:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9FE413ACF0
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:25:41 +0000 (UTC)
X-FDA: 84478061682.23.6C2B246
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id B862F14000F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:25:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FGDhRSZm;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771907139;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVibhLURJoqVyfZNYNQL1uzOVVbJJoolZJlIL8V1kQU=;
	b=xhArElCMs9koge3NkXfzxm2V96JOqG3Cl6zFlQNbU9PeH7gLJCXAkzxJGK5FgtSK1b+VwM
	2TdBRApPUicjtQpQtaYrmNTA6qqR8GW7IprNy3fjTiXTEsAiTQwkyLdzFdwF6qHk9pu8me
	A3XZwbENXj9TKW3anunQLfAaClOYnw0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FGDhRSZm;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771907139; a=rsa-sha256;
	cv=none;
	b=Kh1xD0fN+8G6sZtZtQMgQ44P00Am7uoFueLlxS8TcRz3yom9IU1bQFMQkxvyPRnjPrIMOg
	zi7oLcbc7ArxCc2Oe9TQGBvIpxSzVNhog3cVnWmIuD6cRLdFj9/HY10GpPXLYU/wapwb4Z
	UkKlW268QuKRcBIz4Vj52Dhqjlk3M7I=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b883c8dfb00so870385866b.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771907138; x=1772511938; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVibhLURJoqVyfZNYNQL1uzOVVbJJoolZJlIL8V1kQU=;
        b=FGDhRSZmBxOaEm4MY5xYRHkOzSIRfxJLBcN5HPaiyAGRbrh/tirdFn46e/Ji8/w+Qm
         fSnfRw4eUJ9qPae/7lWheboEJdICUBhvxbBSVDQnn0/ekGzgUTQX/Wy6ZZPX7PfSTCKP
         qFjta2eUPmJkI2kvCj2zf+3jaPWZI1y/wwYjc8ME2unbDXvY26iipJQLOJK5IVPhzoCI
         W3GGgKV4Bk9O6OebY1golZLu9/BwWyoMMr1gLcVgPy3L9cX7qXKqdy2vU+MwR2S4ChJu
         2MAeEc5Sa8wrnZG6dssroR2b+MNGKXgoabfjZhCAXsgVVOVIAcLe/Ox4ICMDflVQrlvq
         4H6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771907138; x=1772511938;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rVibhLURJoqVyfZNYNQL1uzOVVbJJoolZJlIL8V1kQU=;
        b=qLA3jiIBrKejoE45rn2oOCPFxma/cW6AJqB4K0lNmLXmhpkHfvMoHzwFgaIGfMxoyd
         jnyuFbiPKEV7B1gCiInVHa1J5JItHWP9+qV0E75gNrG4RAIRJWC2pUnldwhJxKIqxYYh
         XXh5GerMjxEpfLplW/397VPMK1fiSFtxOt7hA1mnmFFmJ9Wi/+h5YtQGCg94HU5uCo2j
         DBm4Cqj/SebOxyvODHV/4WSlkHpOPzXEfr+J2JOLYq8lpiziB38evekThVz1uEYvDGdt
         ovY76z6was8wBA8wlsWKSfXZjnDJ/g9K54G+FbHW6UF76sOjL+splm4eNJzv7HygoJkE
         dxtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyLUEhbSvDnZUXBk6yKoec/v02Xvf6LxhjsP5GYRNFsp2lc0mtHIYMtkh0THq4tWmHjy24MTZUdA==@kvack.org
X-Gm-Message-State: AOJu0YwWvC5ELuvrUW0+hNuKmh0TwmSlO66na7HUMeL+iL3C3E57+VUM
	kP0KXpFqI4BzOML1KadgMFT1pTLxXe6i5zurSpKmK/LzhKhyookCUB0OI4O7FQ==
X-Gm-Gg: AZuq6aJgxws7ikA/p4qf+nC/npzNWG1eGMSuTEOtHXYl0S4GHdW+YY7iA3wNFeyJSju
	3CSIKAYTUbX0PNw9hbC+pwmjc+ItyG6HLkndcQYnt0THKs6OzNAjYCd5t/+s6JGMCaMiN1Nc0M0
	4XWncUZrQPBEV5055b/93REv/8Yx2KL4Hna1aoNY3dsFmy4GcQjT6exTm9asUNPvIqAtjS+0agD
	/0lxBOS9ybp/0TgT1hLUmV7yxIOjP9KOXm45p14/XOQM9Rttiy9l/+knBJF3yPKlPAJTXzvfTp1
	Jq6ZvqPTdRsK3cNvSAihArVS5ifi69A+xcJtLNYlYYQp4eug+A9SsFfOooWUlyjySszumFlLgIZ
	h2mfK+yshVq0WuXJxEKEyvzC/zx+3e4DeyE3UCvyCUAXXoajPHV1Rji/JbhV+fY6YrwnFNUhkZ9
	lhlJV5lSZX3x33dvkbl2RIaA==
X-Received: by 2002:a17:906:fb1a:b0:b8d:e79c:906d with SMTP id a640c23a62f3a-b9081bd74fbmr493403966b.52.1771907138030;
        Mon, 23 Feb 2026 20:25:38 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084e892fcsm377131266b.47.2026.02.23.20.25.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Feb 2026 20:25:36 -0800 (PST)
Date: Tue, 24 Feb 2026 04:25:35 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: A potential refcount issue during __folio_split
Message-ID: <20260224042535.l3ss2w2jvfv22ddl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
 <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
 <3e22afe6-ecf7-4180-9287-c48fea7b8be1@kernel.org>
 <20260223115948.sbylmtqhznmabcth@master>
 <097A507A-C60A-47AF-9590-1D6CF712B1FE@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <097A507A-C60A-47AF-9590-1D6CF712B1FE@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: B862F14000F
X-Rspamd-Server: rspam02
X-Stat-Signature: hz31d8966ninbj8aphfnf6aify69pd9m
X-HE-Tag: 1771907139-23635
X-HE-Meta: U2FsdGVkX181SHoMXZjA0JMXXgreSnO2+3D26VbdAGKEmSjEv4OlYbCzwvwKRHD49rz0U6kJ1W2JTGKecQQoDMpzvT++DS+PJNzqkLlx2JcccX2LltgX1aYuZoeitzTl2zWfgy4C+VrL51knwDAUSYu6P5bL8xYzLTXf1mCHNfmuAaO55bkBhSuZactZ+Fn/tIO6IZgQz7cznJe48orE47GFEVDhkqvM0CLOqNtD4BT0PcFIBIzNIAbf9tud9JMhqgaYOFxGyq4Em+61OiGjw3hqEIp2Qj8c+OKJzSSlwpNLEsn5l4yBqAFWcccIc1jLfWnQ0vwszfL//8ILkqw6FbjyYMYSLiPoMdJ42eiSTLYXDxhXYwE/4VeNd7TlPwSOw+XLVVFRxgtxo3JZTiWAJn6NTgIy98dVqO4J6wAIYbr06LgaJ3FtpnhETzEmSrxZqF/2BTl8Gw+TYmPtPm9to/pLGpkvEdwkquK9QsSviZFPplrCVM+dSMZBCdJ2b8OnlnaHHd5Q4FAJ89/MY0a7iDbOrN2RewYwNk69HuqS1r/wbJxLXtB29KoVvmP7IDjS5KBxIpglmHaTP0iA/xMN0PCew7lRffjNNvgO5w3oma2fIb3qlyI9Sf0tZFuyt26P2eA/qKsufdsypqxRp0b22uRpO1k0Jqca7QJFSxLReN5HabsT1FE7Gtd7BeErD+2uKIJXq8w4/a/emAs5iwZPN959rX5xnTYBPOp8TtpRWDgftirUgyHeE65utoAzTqvkckYYZX+awH6Cm7HXihqUr720jXh2Uju4t0npJdrXhrijGv5lVrB4I7J3ZHyoMv3ZW5woGnS3vbv+mnUli2d5/+xAoRciEaqfiMpFtEg+/XY6rC6V0CJvvty/WaujQT1yLqetsqOx1SqeUnYhui/43hNp1eyqAcBjTsbJGPMeP9MPIXYicCpmZuTLPMIKFKfkR8/sTjzyd5zidFzQlIn
 OmPv1//7
 txVf+g8Iuva1i970mrSQIMgPKZsDCzaG5gA1tz25BZ1QpZWAzXiPESgIGxiqCk8SRj1cNe6ziC+6zqNkQPn3Cz3hmm6PVABWv/HNmQ0N6cljCdI1Oy+1o6DjLBVx9DDmpDQagWvHL+9BDc41Us9kJSBRKVc+/VLf7aPC18kCZz97cIiT99FGsa+pHgTRYJHK+0obAhi3gAKSSB9cf3NgHUMbBDV2D+MdTXMnBswKbsVjxK336ucs5b2zEUc3mcoREHD3CHGh8yQ7Du8MExEExCscqUd10cAnPCywAR2TQ9TBUwU4Fr/kKFVbaCdSXX51OTNoQOrQXKTxCVIHvUCG5L552Y2WdFIHqzEnjdzEnOrvEkEmT08NNroCA3ALZyroDKd+GGYsUmhUCuJFy9EWqO3iqcvCdBClI4kjmr4C7TfIRIrJCksnH6XzxqWYT36Ewbp1k1TSsh6GUX2FCc/IcRK3BH9J5jsOoSLposFl336BYgczF06/vhlQgK1ufpwMEC+bg+dDFuVpZgFiJXzmtUlBjBJLkaon9p3p1iA2AurVLKVYXzjLaUtXPiJi2rcMehXGd5aRhEl+g0UqZpGJlVI/zBwoNZRyBf4wdxFKxWvtol4cCgSWVlqpiB2O3B8YXNSQ9qngl7y72pQUzLoYDeh6sz2M6iR/m4YEvHEsnK+6h3LMzdR4NQpRYYBt6M4roW5qdlHp+DVX+n08Fc5CHImyIA/0ckEiS2ouZxhSFBKAqX4gnLWUVgc2UnHJM3IMgmtYiCY9Z5NIIdhpIxQLa6TcCXgm+L0ZkV0GzdnYfsBeybNno8dwO4njOFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:00:01PM -0500, Zi Yan wrote:
>On 23 Feb 2026, at 6:59, Wei Yang wrote:
>
>> On Mon, Feb 23, 2026 at 10:23:11AM +0100, David Hildenbrand (Arm) wrote:
>>>> BTW, in the folio world, I do not think it is possible to perform the aforementioned
>>>> split_huge_page_to_list_to_order() pattern any more, since you always work on folio,
>>>> the head. Unless there is a need of getting hold of a tail after-split folio after
>>>> a folio split, the pattern would be:
>>>>
>>>> tail_page = folio_page(folio, N);
>>>>
>>>> folio_get(folio);
>>>> folio_lock(folio);
>>>> folio_split(folio, ..., /* new parameter: lock_at = */ tail_page, ...);
>>>> tail_folio = page_folio(tail_page);
>>>> folio_unlock(tail_folio);
>>>> folio_put(tail_folio);
>>>
>>
>> Missed this. Agree.
>>
>>> Agreed. Maybe it would be even nicer if the split function could return the
>>> new folio directly.
>>>
>>> folio_get(folio);
>>> folio_lock(folio);
>>> split_folio = folio_split_XXX(folio, ..., tail_page, ...);
>>> if (IS_ERR_VALUE(split_folio)) {
>>> 	...
>>> }
>>> folio_unlock(split_folio);
>>> folio_put(split__folio);
>>>
>>
>> I am afraid it would be complicated?
>>
>> Well, we don't have this usecase now, could decide it when we do need it.
>
>The patch below should work, but for now, since we do not have any user,
>it is better to update the comment and add a check to make sure @lock_at
>always points to the head page if @list is not NULL.
>

Agree.

>From 66e24e6cc4397caa134f5600d22d77fdb9b58049 Mon Sep 17 00:00:00 2001
>From: Zi Yan <ziy@nvidia.com>
>Date: Mon, 23 Feb 2026 21:59:18 -0500
>Subject: [PATCH] mm/huge_memory: allow caller to unlock any subpage of a folio
> after split
>
>Transfer to-be-split folio's reference to an after-split folio that caller
>wants to unlock and put.
>
>Also let __folio_split() return the folio containing @lock_at for caller to
>use.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/huge_memory.c | 65 ++++++++++++++++++++++++++++++++++--------------
> 1 file changed, 47 insertions(+), 18 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 0d487649e4de..d051d611c6e5 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3768,10 +3768,9 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
> }
>
> static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
>-					     struct page *split_at, struct xa_state *xas,
>-					     struct address_space *mapping, bool do_lru,
>-					     struct list_head *list, enum split_type split_type,
>-					     pgoff_t end, int *nr_shmem_dropped)
>+		struct page *split_at, struct page *lock_at, struct xa_state *xas,
>+		struct address_space *mapping, bool do_lru, struct list_head *list,
>+		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
> {
> 	struct folio *end_folio = folio_next(folio);
> 	struct folio *new_folio, *next;
>@@ -3855,7 +3854,11 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> 			folio_ref_unfreeze(new_folio,
> 					   folio_cache_ref_count(new_folio) + 1);
>
>-			if (do_lru)
>+			/*
>+			 * skip @lock_at since caller wants to unlock and put it
>+			 * after split
>+			 */
>+			if (do_lru && new_folio != page_folio(lock_at))
> 				lru_add_split_folio(folio, new_folio, lruvec, list);

This makes me thing whether we need to always grab lru lock.

If the folio has already been removed from lru, it looks not necessary?

Well this is another thing.

>
> 			/*
>@@ -3898,8 +3901,17 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> 		 */
> 		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
>
>-		if (do_lru)
>+		if (do_lru) {
>+			/*
>+			 * caller wants to unlock and put @lock_at instead of
>+			 * @folio, treat @folio as other after-split folios
>+			 * by either elevating its refcount and putting it in
>+			 * @list or putting it back to lru if @list is NULL.
>+			 */
>+			if (folio != page_folio(lock_at))
>+				lru_add_split_folio(folio, folio, lruvec, list);
> 			unlock_page_lruvec(lruvec);
>+		}
>
> 		if (ci)
> 			swap_cluster_unlock(ci);
>@@ -3925,14 +3937,13 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  * preparing @folio for __split_unmapped_folio().
>  *
>  * After splitting, the after-split folio containing @lock_at remains locked
>- * and others are unlocked:
>- * 1. for uniform split, @lock_at points to one of @folio's subpages;
>- * 2. for buddy allocator like (non-uniform) split, @lock_at points to @folio.
>+ * and others are unlocked and the caller's folio reference is transferred to
>+ * @lock_at's folio. @lock_at can point to anyone of @folio's subpages.
>  *
>  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
>  * split but not to @new_order, the caller needs to check)
>  */
>-static int __folio_split(struct folio *folio, unsigned int new_order,
>+static struct folio* __folio_split(struct folio *folio, unsigned int new_order,
> 		struct page *split_at, struct page *lock_at,
> 		struct list_head *list, enum split_type split_type)
> {
>@@ -4052,8 +4063,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 		}
> 	}
>
>-	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
>-						true, list, split_type, end, &nr_shmem_dropped);
>+	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at,
>+						lock_at, &xas, mapping, true,
>+						list, split_type, end,
>+						&nr_shmem_dropped);
> fail:
> 	if (mapping)
> 		xas_unlock(&xas);
>@@ -4100,7 +4113,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 	if (old_order == HPAGE_PMD_ORDER)
> 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
> 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
>-	return ret;
>+
>+	if (!ret)
>+		return page_folio(lock_at);
>+	return (struct folio*)ERR_PTR(ret);
> }
>
> /**
>@@ -4138,9 +4154,10 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
> 		return -EAGAIN;
>
> 	local_irq_disable();
>-	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
>-						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
>-						0, NULL);
>+	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page,
>+						&folio->page, NULL, NULL, false,
>+						NULL, SPLIT_TYPE_UNIFORM, 0,
>+						NULL);
> 	local_irq_enable();
> 	return ret;
> }
>@@ -4196,9 +4213,14 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
> 				     unsigned int new_order)
> {
> 	struct folio *folio = page_folio(page);
>+	struct folio *ret;
>
>-	return __folio_split(folio, new_order, &folio->page, page, list,
>+	ret = __folio_split(folio, new_order, &folio->page, page, list,
> 			     SPLIT_TYPE_UNIFORM);
>+	if (IS_ERR_VALUE(ret))
>+		return PTR_ERR(ret);
>+
>+	return 0;
> }
>
> /**
>@@ -4228,8 +4250,15 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
> int folio_split(struct folio *folio, unsigned int new_order,
> 		struct page *split_at, struct list_head *list)
> {
>-	return __folio_split(folio, new_order, split_at, &folio->page, list,
>+	struct folio *ret;
>+
>+	ret = __folio_split(folio, new_order, split_at, &folio->page, list,
> 			     SPLIT_TYPE_NON_UNIFORM);
>+
>+	if (IS_ERR_VALUE(ret))
>+		return PTR_ERR(ret);
>+
>+	return 0;
> }
>
> /**
>-- 
>2.51.0
>
>
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

