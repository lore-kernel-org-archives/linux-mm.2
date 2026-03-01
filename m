Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F27DFD0072
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 23:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2FD6B0088; Sun,  1 Mar 2026 18:59:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA12A6B0089; Sun,  1 Mar 2026 18:59:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75CC6B008A; Sun,  1 Mar 2026 18:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B66C86B0088
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 18:59:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E7455B60D
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 23:59:08 +0000 (UTC)
X-FDA: 84499162776.27.CBE7D4D
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53E9D160004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 23:59:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="nLGKdD/v";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772409546;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYCFbsYQ4AOo+ikYtXMNbwhF87HI/rD9l6LLyjnEwW8=;
	b=PcEcJx8NG9RxL9bMRpYe2ShAAtcWScJEqigp2FRfDHFNhkTAEz7P2n8WfTwyj+kLv+ZDy9
	KUq3UuK23gJKE2SdxxakuqrBILFSIzwXd02Zh3pWLOXxu+pzNpP6lTgGxJ+VbT1waoSmXH
	lWdX5Z1/7u3HRIvy/4RZMyXpHZEI8Uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772409546; a=rsa-sha256;
	cv=none;
	b=CKcJdIM3O2AbBzGrBg/v/KSAFvVrvUqVDU78avuP4hjmhNjAWyBOrYmpjy1PK9foZmBWgZ
	VxmFlp4KGfzK5H7W6Nqpq1MduVt7BqQ75A2+wLfZSNGDNiHvGcBFX5ZZ+sAfrYUYif4VXS
	kelyT+y5z0OuQvXf8Y7NyGbpxHtxcSA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="nLGKdD/v";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8fbb24a9a9so794086366b.0
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 15:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772409545; x=1773014345; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYCFbsYQ4AOo+ikYtXMNbwhF87HI/rD9l6LLyjnEwW8=;
        b=nLGKdD/vEEe1RiZfdjxMK2L6PQq45JHTg8S1u1ra6Fk4/gcw59QSx56D+FalmW699m
         4gQhOOwUNq/c95BdvW/bon++QXuqT80KEJyyrNL3xdAj+e20ah8E6lPNH+CpTu097zG8
         C2JS7PqfxudbIykjSdz7UcrLIl8Gwx34dSPE2+CZngJ4a+hgFw66GEGe3ElF4qRn5wFM
         F7jTr1bCkWRi3vnTqYKUUN6BKlbm/a3UQp9Rl1dj7eS75EG0RU0vAOTeYkSS7USVZKg4
         5ZChcZNJ40pIHPs/8KpJ+kJEidjO2rEpUsUzDV6F2hnRvVnJ6KYvS8qOiZm+KikRwIXm
         CUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772409545; x=1773014345;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WYCFbsYQ4AOo+ikYtXMNbwhF87HI/rD9l6LLyjnEwW8=;
        b=QQuPRibrY8MxShic+DVXt+eWQzUhu8NpVqWfHxtrXwQ26yznquZuBh1Qo/4Obpd8LB
         cvWxjy82BV4XkS2Tyyff7Pf5bT0L4S3rdod9jKxEQXBmuBqrSZyJB+HvKcTKkL75U9qX
         boRo3wVn35MQLH0vpD4vNqkrGuGVtftmwJgNMcttzQpIrK0eE3Cy/fzPbuKzEV2qcB/d
         0FkzvgGhexD5K5/yyUpug+O6sS91zuv1UQZKW6fwpNYE35z2jOxxzrtDj4X2QjPdZgds
         RV3l9PESjncuQIENxGcvf7wq5plvnOvw6iMdefEpjKqUVs8G6v6YC5GOjFIfMfhJ2NnQ
         46lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbM3fO5ZDgNPt96RBsO67XQMegrzEVIK3gPccKX7Vwb4iBclx7FtQCgNYBW48aUYodHDP0dxodBw==@kvack.org
X-Gm-Message-State: AOJu0Yw4Uy48uxZ2Gj9a42wsB+di0KGVOnMBybPhdw3MpeGkd9JVFdfc
	tWX5eJEpsioBxX3JeFIiFNNTjS0WK/ziAOfYK7/fXq3YnDCCeXT7tJSr
X-Gm-Gg: ATEYQzw/JQ2j33gKIAl0NqtrAh78r+Eik7vvb3tpmZf+yNjjhUppsJwLLBiwNrj2Kkx
	nLhEkhkJ442d+SIxRqn0Vz3pXH2oRs4+gnDpQrqhni3uh9wX0GgU/VKZPpI6Gi2g+v01NfmSmKG
	Cr1g4TdiubxTlbxhnoDa0BNB8leBbr8lC3NSaqyl3rQ/5UenilG+eCwoCoNy3aLNy+Of/DGTKxZ
	UlFATqv1CZ5+c9nI9a0Xf3d8047pEO1nzOPuCG3yLMYjmsV9e/v5gFcnzF07iVMoZrHrP6By6zh
	UiEj7wTM6IbK7Bh8qwgNeXf9KvJPn1V5n1Kj46JSiWkoXW15Zkdy3Qx332cxuXtuCUnbP9g0rUu
	CFiLh/cpTLuvCu15M4IQhjvZFnZWJY4CzO9oMTxA3o7wlBy84HkjzwCxLx9xe8KIECz3eQ3T3uJ
	fwH/6wwlWzLEh8T+wMJEztNQ==
X-Received: by 2002:a17:907:7fa3:b0:b8f:c684:db37 with SMTP id a640c23a62f3a-b937583ed50mr696148166b.9.1772409544521;
        Sun, 01 Mar 2026 15:59:04 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ab137a1sm415575966b.2.2026.03.01.15.59.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 01 Mar 2026 15:59:03 -0800 (PST)
Date: Sun, 1 Mar 2026 23:59:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: A potential refcount issue during __folio_split
Message-ID: <20260301235902.duqcfrymearzrpds@master>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 53E9D160004
X-Stat-Signature: j8rfmktz8g85ztynx35s1ee8pekazc51
X-Rspam-User: 
X-HE-Tag: 1772409546-487354
X-HE-Meta: U2FsdGVkX19u3BY7ZLhJdOQcciN2LpwpZwVqWXOSRVoCEJxENdfiggyXGK8Xz3/RQVHgF+QtQ2uaabVnGdRf0NfMfU9jyRk+ZPApl6Uj1z/TyD40oT2rSXwaNa5RbzZA4obEERtCjXfxCqZ3hl/NeZA7zNl9lVSW26p2klkgjcrjBKxSnZE2gQErSv67E7hbIqiAt1cIfX61g+eUUOv+HsFJ1WNCkCmpdDbY/tl9PfQQhuNsczPSVfZdGRqY+R2O1xKiMrZKy2W4AD3DtP28pL8cNO73ri83nBuUhisxD0vgbZbekP6tVRpSPHlfo/nx8I2MjLB3zD7ISWpimpLvIX8IG9D1nLoetqo/4FdxsqAxzG40lcGYr0CcPAdgPKYHx6ccVjCE67fBfIYVHr0ePydeRpfHm91gsWroEsGbbwYkm0kIy1vL469DR64F0N3hCvx6q0BmWD3fVldhm0x6wWttvDWMRm+ef0gxBglOSeDSP5SuJUQ+FJLwHmrxxpNSnO3gPOrPHQN+ZCfkv9ca41D/zWm+XTacYuLNzPxc09QJ/WHKCKZxLDHZPDcMpmIRHyxpKW8s+b81+UAY6IY5OGpv5U30iGvcMsR7F4fOpG16W9A8Q4n/J6TVbawdZE4bwDH1B2PZliUYyksBbWZ6qPFJI29n6AjN8bNfT2qF80YtS4/i9rp+6AnC2YJEcinVmfNUz2Ju8IU3O0LVLQNlYM4MjLr9x1GQqkQMTJjIY3SL7G6rwrCCWRomo7p6PNtUtT8DSXf5TdI8QIzTeT2PTy8bkIV8sPr7nYECI7JEbuswbSVM9svPxcMzUi0GiHvO5e+VeS4NRvhf8bAX2t99ShloNfVisTWI58tiDa+0zeFjxgAOHdqeW0B91oFI6B/B3v6wYFGIZQP2dyLLi2VIzdIx9nzD6EQtvVFsCrIpLoBAnepFSy8VU6RNj51udSGx28XGEXBGDrVpyWjhJ9K
 /zws6KjG
 1ArmwvNf6M6REU24ohEc0asARNvJ24PCeWwoVh0sBkNWJfDhu9uwv2AC7MzDbk0kDKriWCoEqso4zzyux3KuYvxfxOFPeueqY/dA9zquvjXW7LJjUVJjQxPW59KXH4JWapbmkHzPGOu4xmpb6s5apmfp8p/n4txNQ5jBlkb7Pq6CWUZkcAQZa6usl+bR3qu3RPt+MHzuHDPlRWRcV3wTTEIXkFv8dp/bkMeBEqO+EZ7MLQWJjeXRZF+I89E2cCAATsCCqFQXA4EHw2Bh0pt83V4Ta31cobfnx8zOSbk95uLg4r112VE3LzBDxYr0QFUJgzlOqJnh0XawhK9nRJIqJTnI60nIuluSaC9wh6Mkmhj6PTVysJ28GpiBFQXtCdZoP/gsW43ta7+K8tB9W9teRAGN1ISvszB5lQIgREUDwVsaJCWT7QEJILo48k6Hra9vX35uii3IPO1PAibztUqWsqpD72ZGuQgBYwRWXZhIeHBViYMXaFn+rCSUQb6kTzs1wPnFqPMChoDoov5t7PKeCXdgpjNzN8BLChiQ11a+O9soBITbwcynhagCIW5bz3Ui22b0THlFMVSznSOgD06IU8JJSxJw1aSBM82qNc5NdNpwIN81bxrF05m2+rYqScqqPBWF2ARVATstlfgvb6/L1zmusMkVZUu7vo9DA3aDyGjunAmJStK7mUhMqxYNOKPfDy38l0KsSme2MB03/nj99skbdpud9/Xzssfq0r2mCu3n6QAiraNCm+vjaUh6n1OA5tVSRykdGFeKcrlfdoPqw4Tg1WhI2z/ycGk3Im6ICc4Nc14ZNA6iQkcKDmQ==
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

Hi, Zi Yan

Just want to confirm what we prefer to do now. We have three options:

  1) update comment and a check on @lock_at
  2) fix it as you proposed below
  3) do nothing for now

What do we prefer to do next?

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

