Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273CEF4610D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F67F6B0005; Mon, 23 Mar 2026 09:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDDC6B0089; Mon, 23 Mar 2026 09:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A996B008C; Mon, 23 Mar 2026 09:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 709D96B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:29:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B59EC344A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:29:21 +0000 (UTC)
X-FDA: 84577409322.20.859FA73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99114C0004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:29:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVVTbnDx;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774272559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsB5c3/eIpiOOdQy5BgF0DGA1zHDDDWgvsA99LIaezo=;
	b=WJyhg/Ium2a3h+mWDina/9kxdrDBUedIrJOq34O2y2fNlnWzVhSUggXzSyYWR/L990QNXx
	Re8G7XMm0DHw6vOCsq+U/uvSLiRjpV9gDGynQrQgdmtZTMK0t3JzK0H36XIXi2nBiyRiAB
	/nAor7EwG/JQYjlRfq8ERWNYicRzeho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774272559; a=rsa-sha256;
	cv=none;
	b=nk57ZYQxUZFrGO/ErIsdGMLxhmRwBfrH22ny/Kwn3x5KFZsF5WOXUzUAXnzEG2DjdKJ1cS
	fMiKYDUyOEM0zf5rL263W2XdIqBIAR2mq6C/LeKyKLutHGF5P6DJrNW5h+QmbZOvsBhiGU
	E23RZ7a92N5dW4maUARwarUQ9lgtMSI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVVTbnDx;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 12C96600AC;
	Mon, 23 Mar 2026 13:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5084AC4CEF7;
	Mon, 23 Mar 2026 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774272558;
	bh=P9eVkuvtmt2z3nk/0veMt1ApqzvU1NdVXo2AoE58exA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HVVTbnDx7x8iyGtpS6nvyNdpZ2lFZdxuqkD8BwKCh0ozt/dsmdQiuBg9smBtq7zGh
	 mKxVwOuhJlVoSmoyI8kN4wwkGrDq4kQ8/fSZFJBl3EZsNH4MpehQDJmQ2Keb885a1n
	 8GHzS++UgJcsmuTJtz1+UrCyMraXNuUmCbLTsxqulV4eVy75moPlodS9ln6X5VlaxT
	 deCYDw21LzWx2HW0TrjFyWngv2dP9Rc1F5K5HrjfsEr9dtrWrzn/SqPjPCqkPiQDE9
	 ctssjasWQbvfsj5syAygeQ1crEEVFkIfjCgOJUW7kaskyn+KXPE5ab3uP0otEUa/IK
	 sgwf48SEimMtw==
Date: Mon, 23 Mar 2026 22:29:16 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
	usamaarif642@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 26/33] mm: vmscan: prepare for reparenting MGLRU folios
Message-ID: <acFALMLIvjP4i76U@hyeyoo>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e75050354cdbc42221a04f7cf133292b61105548.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e75050354cdbc42221a04f7cf133292b61105548.1772711148.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: nqwhs8nck3kqi95zzyxwnqy9fa6m889q
X-Rspam-User: 
X-Rspamd-Queue-Id: 99114C0004
X-Rspamd-Server: rspam12
X-HE-Tag: 1774272559-818470
X-HE-Meta: U2FsdGVkX18b+yYDTXZ4J0dSc8dq48LBTjtpAy9wAqgiy0XFZy5o3locgn2Ob5ycStaOzH5zYsQWGSppA9nipySiRgW5/Fo9S3hXw9DfluPiMA69goIrD2ybUsl36eVyjYXAvNG7KHZwnXhmRdcuZtftX4C5zlApcWyvfmSSHNCii6rnxfJVKs584zGn1c9ZazhnD0kb+MmwalseAxBNZbrZqoYjWh22FeFegGO/F8iXZVNCG9lftrtdlHr7IEnhyawIfw4KxGwJXzuTxi63TeCPfSrpy05uAKZkgzSfMZUmqny+3V/KT39wKjjhG+2gjH65Pm0BhHaAiopgfK5m1BhDOe+ME5hVROrw9YsJbZ8tO7h12gJs21YUjQxK4u/UosRRD0os/UusLO2qy2Y1j6jUVD2H52ZZYyTT3yTy3EP8jOwZX5AC7+oqy94Bs0xAxe7tYl8mUmvRaEo0AVuBpO5VnJqJXpyMT5+0lzKgaHmqNbWCZ/pW0skmVKozit29t8+rizQX7rTBGEyOO7arlmmWwd79CzXpELHsmaqa3lRGlufkWAkfVnJRckahgSRElfPfd9DMFr7UpqUTY9V5QGwXinxp7T12JJclw9HH4g/nvbZG3LbOa96mYv2iD+io1fkxOsPaQRUNjX6HWdyO2tcg4lp5kZgjY0tcktwbgr1P9akzY2eCL+utx0ZQm0In11G5FzR6IWV7m2tzhLmOeVRZhvlHU7Yo9H2itLk7rdDFmIVzGzR/NDAB8cM3+Sr+XSAt0x/+159WMjOlLbMDjDmw2hDn5HNcnikXT10lyPWIOlY+BG2lz+UV+g7apx/gaLYenjPC8Ysi36V68ptThMNs++IsSuIyCVAwBGqeEBgy9Ol2Z0IbNfUY53DXsFe8Av2TkRblMPx4RixRi1TNwdMa2wktQNO79K833X54ygLvkzHoFEkKTHTZvJn34iJSqWGufmTAN0JFDjIPCAl
 AzA5pMv2
 Z5XadKwx5w9t5+4+fq6+JeMR1nIEg6mpNT3Mc+4mZ9DNGSgUF+K7eDkZ4V1TXl7IsxjW7hXZeZbBCrmYbvU6CT1dGT9Hqc8sJWQuw2+rmH0v26tRehv94sd/ur9lHF00z1M9ce9XMD8DXpl8cOCW8l9J34thW0Bf7PZw3mutleH5Y40bMiUkl5KDPxB4HMjKbLs0N7HQYnxVlAfLHxb/mhtAGxWwWGOyOT3nGzCAJhKCS8/eChwnPm1vDWVmiMr7lzKWmX/8HhLkoiB3eQ85M0eqqb030MYiYMdgTzdcYszfl3m4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 07:52:44PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Similar to traditional LRU folios, in order to solve the dying memcg
> problem, we also need to reparenting MGLRU folios to the parent memcg when
> memcg offline.
> 
> However, there are the following challenges:
> 
> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>    number of generations of the parent and child memcg may be different,
>    so we cannot simply transfer MGLRU folios in the child memcg to the
>    parent memcg as we did for traditional LRU folios.
> 2. The generation information is stored in folio->flags, but we cannot
>    traverse these folios while holding the lru lock, otherwise it may
>    cause softlockup.
> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>    may be updated, but the folio is not immediately moved to the
>    corresponding lru list. Therefore, there may be folios of different
>    generations on an LRU list.
> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>    found based on the generation information in folio->flags, and the
>    corresponding LRU size will be updated. Therefore, we need to update
>    the lru size correctly during reparenting, otherwise the lru size may
>    be updated incorrectly in lru_gen_del_folio().
> 
> Finally, this patch chose a compromise method, which is to splice the lru
> list in the child memcg to the lru list of the same generation in the
> parent memcg during reparenting. And in order to ensure that the parent
> memcg has the same generation, we need to increase the generations in the
> parent memcg to the MAX_NR_GENS before reparenting.
> 
> Of course, the same generation has different meanings in the parent and
> child memcg, this will cause confusion in the hot and cold information of
> folios. But other than that, this method is simple enough, the lru size
> is correct, and there is no need to consider some concurrency issues (such
> as lru_gen_del_folio()).
> 
> To prepare for the above work, this commit implements the specific
> functions, which will be used during reparenting.
> 
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Suggested-by: Imran Khan <imran.f.khan@oracle.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Harry Yoo <harry.yoo@oracle.com>
> ---
> +/*
> + * Compared to traditional LRU, MGLRU faces the following challenges:
> + *
> + * 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
> + *    number of generations of the parent and child memcg may be different,
> + *    so we cannot simply transfer MGLRU folios in the child memcg to the
> + *    parent memcg as we did for traditional LRU folios.
> + * 2. The generation information is stored in folio->flags, but we cannot
> + *    traverse these folios while holding the lru lock, otherwise it may
> + *    cause softlockup.
> + * 3. In walk_update_folio(), the gen of folio and corresponding lru size
> + *    may be updated, but the folio is not immediately moved to the
> + *    corresponding lru list. Therefore, there may be folios of different
> + *    generations on an LRU list.
> + * 4. In lru_gen_del_folio(), the generation to which the folio belongs is
> + *    found based on the generation information in folio->flags, and the
> + *    corresponding LRU size will be updated. Therefore, we need to update
> + *    the lru size correctly during reparenting, otherwise the lru size may
> + *    be updated incorrectly in lru_gen_del_folio().
> + *
> + * Finally, we choose a compromise method, which is to splice the lru list in
> + * the child memcg to the lru list of the same generation in the parent memcg
> + * during reparenting.
> + *
> + * The same generation has different meanings in the parent and child memcg,
> + * so this compromise method will cause the LRU inversion problem. But as the
> + * system runs, this problem will be fixed automatically.
> + */
> +static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
> +				     int zone, int type)
> +{
> +	struct lru_gen_folio *child_lrugen, *parent_lrugen;
> +	enum lru_list lru = type * LRU_INACTIVE_FILE;
> +	int i;
> +
> +	child_lrugen = &child_lruvec->lrugen;
> +	parent_lrugen = &parent_lruvec->lrugen;
> +
> +	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
> +		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
> +		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
> +		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
> +		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;

Not a correctness thing, but...

> +		/* Assuming that child pages are colder than parent pages */
> +		list_splice_init(&child_lrugen->folios[gen][type][zone],
> +				 &parent_lrugen->folios[gen][type][zone]);

I think the other end (tail) is where cold pages go in MGLRU just like
in the traditional LRU, since  lru_to_folio(head) returns the tail folio?

> +		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> +		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> +			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
> +
> +		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
> +			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
> +			__update_lru_size(parent_lruvec, lru + parent_lru_active, zone, nr_pages);
> +		}
> +	}
> +}

-- 
Cheers,
Harry / Hyeonggon

