Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A2D606A336
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YamEjt0o
Received: by kanga.kvack.org (Postfix)
	id 062EB6B05B0; Thu, 19 Nov 2026 02:29:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014356B05B1; Thu, 19 Nov 2026 02:29:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44FD6B05B2; Thu, 19 Nov 2026 02:29:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD5416B05B0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:29:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE672A09C0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:29:37 +0000 (UTC)
X-FDA: 85451043594.08.3DCF556
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8E4AF1C0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:29:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YamEjt0o;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795073376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3HLKreulGVvKzYXhYVLR8WoQPfJSmrNsNBKCFc/Lbs=;
	b=Mt43gf1kqAdPk3fWXzOZXFJj6gCJbOvvEjneD0rgROanf4tRgWOyBiJVnssh9w62hvR8zt
	UA47+E/T2wvxY3qFkw9DYpOj47jgpHjX3LiDl/Rpx3Ckd8jHdpE4agbUyIF6waU0z6b6U7
	gaVjjD3bAYaYFh8PjbTxG0KDKrcyQkg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YamEjt0o;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795073376;
	b=vanEhvuTZq/eiNkkGkTM19cFN6qbWN9kJQZbePubnljsPr23J1l42GdYugLarKm9cVkjwR
	V9hNIuEH5s9WGKgss+wi3V3Px1pPJWvW0jk5tbhKHUr5YSmAHqQ9mJIC8B/V2+momGREJ9
	O4UgSwZGVOOmHVcdGZnXj5XoYEiGHWA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Hk6Lvv4k7WqHWElEU0SMIJ3sc8Gw2+rdf3W4yBWpAD8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795073373; v=1; x=1795678173;
 b=YamEjt0o6+NDqWAmBj8Kz4gEA1SJFP1W+5N2mV9Q23JhFiFpQHRBF6rl9bzkApTKHlxFpWtz
 CozfyrWdlZZG4RfLiLElvGp3RCTYLiI37evIj2pkTADPt2EMddFYgYuL2uwcAopc3UANMJk0aCw
 yVd04+SKfBA1tdWBBz5Sv45g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 812d8d13544af841;
	Thu, 19 Nov 2026 07:29:33 +0000
X-Mizu-Trace-ID: 812d8d13544af841
X-Migadu-Flow: FLOW_OUT
Date: Thu, 19 Nov 2026 15:29:27 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Harry Yoo <harry@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: reset the mm iteration cursor in
 try_to_inc_max_seq_nowalk()
Message-ID: <av6lVy5fW47XPxre@fedora>
References: <20261117113700.453044-1-hui.zhu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117113700.453044-1-hui.zhu@linux.dev>
X-Rspamd-Queue-Id: 8E4AF1C0005
X-Stat-Signature: g6irno3xbdqttcsgysqtej36uem8n4wg
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795073375-649827
X-HE-Meta: U2FsdGVkX193p6ak7wxM4eXvlNMVCD5KweS6O5JqF9fTjDEdP54veoTozHK8NPw4PyXEoG6wH5z1YPOhvwzJjpY5lJGEznzB/IrelZTh3WVDRN3CVPGsA38G6A6C7tmZRoeKabPKuXz+a4DnWatDl0Jx10RnBui3MNc5owol//Ex6jouu/aEbvGJhW/ljrBzh01ILo+k2KWmCnrCy+7nrJMmsbbw/6gORMjJOTisIY182p3E0MVwicFlBXx9DVAOAaMHSGDxsiJsEYjXVZMNzdn6WnyHqtYcb3eQe9UbqXuvjDwdmsoSMNfzCrsVBeqE4qDM5yJz33Pjx7vacLngqFfEGdsDMABpk5lkdyKLDzg876gTkVVQv+sQO30kdSM+ZX+RtycHxxQqdDH3wk/k5IcU+5tPXoOsFIPespK+j2+6TIZ6Bowl15/182pgyd1yJau08XSaNqh4xDL7e9usD3WPRlsBkZhpamp1Sw3F91N4b8Vr+pfla3uQINW+gwUOXSsUedPJde59U9Ixdp1omzYT2Arr+z7sKbswSSUQyR3kSkMXlrRs9Fs51UogDwa/qqInLhmfAnxuBOBi4OYWPHLSVajyWiVfdbf6TOpR6+aRy5tfUjDBnX80ohyUCuaosU+2DVqy6VhfLPZT92Iv1+XllexyP2uTB4ETGu1garH4MXz06WgI08P4hoqOwYGPqocOdtLUZJYjqzu5vg48FbkXZ1WibK9yf6GmV7gCrM35iQ9C+eRNAvoKPEc9u0JP1lkt7kgcrWboFRd/Mw176vrZsgRq79TFqxKISjc4FE2UQ1Nz6Tl2ipjqyT7zOHwRWnITe3QaXyIoH9Wc6Rskrn24DRDMY/s9FYufBQPy4iF8yfYab7m2aPIfdSitXJsHXTB4jLmb6reahOsLaqqIjiS7Nh6cOjR6AOYqtLBAKJOCrNGI0ozWtyymnMCKcT2Yj6EgpIH1F5gzL1LNJ4h
 ifZltjbf
 0zxcICIh+5TeX9EwLCcyng/OZ2Q68OW0cqwLM+rLlc2WSgGUQkPPwmOFBmKtZhf7HZMDPEQD1VUHK2NxTRxid35v3uJVaf37PKz6Z/DsRhOsgEk2rN61zMs3agN3I/SoJs+WT62SlfMmcbMYzhC8j8UywjgaWgFp6Dd9AH+jvqBdHAGbtVYqekGBd1TpbPwpst99QGwnmlhKTE4WHrEDqSUS9aME5flvtl8yD9r76pbavHUC1t6odCQvm8cVf84+0YKuR7ogIaVThjJxi8mSwSLHCYDG1lDS6ceQC7M71Rd/lL57tQangTmsr+lf10DDoAJ3k6wsgu5gaTl3iHrHyV+K4CK5xhDP1JcISLztVDfXJTub3d0P81MdVO1Jy/Tz9KzfI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 at 07:37pm, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> iterate_mm_list_nowalk() and try_to_inc_max_seq_nowalk() both advance
> mm_state->seq without walking the mm_list, but only the former drops the
> cursor. When the latter races with an ongoing page table walk, head is
> left pointing into the middle of the fifo.
> 
> The next walker reads that as "this generation already started": it skips
> reset_bloom_filter() and resumes after the cursor. Every mm before the
> cursor is skipped, and none of them have bits in the filter being read, so

Nit:
Isn't it that mm after the cursor is skipped, none of them have bits in
the filter being read? Because bits in the filter are set in the last
generation iteration, mm after cursor didn't iterate, so no bites set
for them? 

> walk_pmd_range() descends into none of their PMDs and harvests no accessed
> bits. try_to_shrink_lruvec() ignores the failed try_to_inc_max_seq() and
> keeps evicting, so those hot folios become reclaim candidates and refault
> in the parent memcg, until head wraps around a generation later.
> 
> Factor the pattern into skip_mm_iteration(), which carries the rationale
> that used to sit in a comment in try_to_inc_max_seq_nowalk(), so the two
> callers cannot drift apart again. The wrap-around in iterate_mm_list() is
> left open-coded on purpose: there head is already back at the fifo, and
> tail has to survive for the force_scan test. Dropping the cursor is safe:
> get_next_mm() holds an mmgrab() reference, and a concurrent walker bails
> out at "walk->seq <= mm_state->seq" before touching head again. The
> unwalked part of the fifo restarts from the head next generation, as
> iterate_mm_list_nowalk() already does.
> 
> Only reachable from memcg_reparent_objcgs() -> max_lru_gen_memcg(); not a
> memory safety issue, since lru_gen_del_mm() repoints head and tail under
> mm_list->lock.
> 
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/vmscan.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a1af9b92349..0dc4017b87e4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3235,6 +3235,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
>  	do {
>  		mm_state->head = mm_state->head->next;
>  		if (mm_state->head == &mm_list->fifo) {
> +			/* head is back at the fifo; keep tail for force_scan below */
>  			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
>  			last = true;
>  			break;
> @@ -3263,6 +3264,18 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
>  	return last;
>  }
>  
> +/*
> + * Advance mm_state->seq without walking the mm_list. The cursor must be
> + * dropped as well: iterate_mm_list() resumes from head, and resets the Bloom
> + * filter only when head == &mm_list->fifo.
> + */

This looks like a good catch, while the function name here is a little bit
confusing. From the code block inside, we can't see it's doing iteration,
just a pair of pointer resetting and a max_seq advancing. I would rather
not wrap up them if no good name is concluded. Personal opinion.

Other than the nits, 

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> +static void skip_mm_iteration(struct lru_gen_mm_state *mm_state)
> +{
> +	mm_state->head = NULL;
> +	mm_state->tail = NULL;
> +	WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
> +}
> +
>  static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
>  {
>  	bool success = false;
> @@ -3275,9 +3288,7 @@ static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
>  	VM_WARN_ON_ONCE(mm_state->seq + 1 < seq);
>  
>  	if (seq > mm_state->seq) {
> -		mm_state->head = NULL;
> -		mm_state->tail = NULL;
> -		WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
> +		skip_mm_iteration(mm_state);
>  		success = true;
>  	}
>  
> @@ -4686,15 +4697,11 @@ static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
>  	DEFINE_MAX_SEQ(lruvec);
>  	bool success = false;
>  
> -	/*
> -	 * We are not iterating the mm_list here, updating mm_state->seq is just
> -	 * to make mm walkers work properly.
> -	 */
>  	if (mm_state) {
>  		spin_lock(&mm_list->lock);
>  		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
>  		if (max_seq > mm_state->seq) {
> -			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
> +			skip_mm_iteration(mm_state);
>  			success = true;
>  		}
>  		spin_unlock(&mm_list->lock);
> -- 
> 2.53.0
> 

