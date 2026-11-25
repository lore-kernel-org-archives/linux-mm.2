Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82996606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 02:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Mft61ybF
Received: by kanga.kvack.org (Postfix)
	id E6CD86B08D3; Tue, 24 Nov 2026 21:28:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E966B08D5; Tue, 24 Nov 2026 21:28:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D340C6B08D6; Tue, 24 Nov 2026 21:28:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC5006B08D3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:28:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88F34160CBE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:28:26 +0000 (UTC)
X-FDA: 85472057412.27.745D99D
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	by imf02.hostedemail.com (Postfix) with ESMTP id 71E8580004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:28:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mft61ybF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795573704;
	b=Q8fPLm4VtnNi4xwCOiONiPcYq6xpRk9TZzABOduFd7WmZ62DLVc66KcLjQdqmb0340f0sG
	rg/eyMhUO0LPrtW7K/DScqJNUqbNWa9LSlFi514U7zy2BAi3gRIUiLVxtQUI4pC3CY4Cal
	kolN/BHoZ1W5pBwbifVgk5LVymnMV7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795573704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZvNymZsIWDzZ+4ow3hX65QKKknBxmKLM784TXmwd/I=;
	b=BcjGhffkXtNtbkqSE5PgIjAKGD1KWNhyBSwWnV2I9pwWfB213+1yE6JuTxywmO1RC3Ekxq
	6HLRI0Cx6M2IjXMpdpbHOqwsinkhYC5duG388yAsG+Vf8m9kRhPcQzKaZceJJrAvjlHL7m
	m8zSuvxaazvTHp9IUlMK+xQvJ8H7HO0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mft61ybF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qN70FMkZdcX23pDbqX8QgEonbNQPBpr2pixHzy6GHiU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795573703; v=1; x=1796178503;
 b=Mft61ybFbXimS0hLWcc6z/SDUm562c5i9yOpsoDBtyX1GU7Z0ZWwXo9vhZi4IbuUUEi2OhFw
 bA29iEsf6p9FQEEDTuVXeXxImxhhHCvcgeSTy9iORyfJG80lG8bPKWlqhjqoglkSmt4+DvhWe7C
 LHsuHdNoSddQSye83XxVyOw8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9c984972921468ab;
	Wed, 25 Nov 2026 02:28:22 +0000
X-Mizu-Trace-ID: 9c984972921468ab
X-Migadu-Flow: FLOW_OUT
Date: Wed, 25 Nov 2026 10:28:19 +0800
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
Message-ID: <awZHw6CK4_CaPUUf@fedora>
References: <20261117113700.453044-1-hui.zhu@linux.dev>
 <av6lVy5fW47XPxre@fedora>
 <0e42e0c4-c1f9-4778-a979-404fbb68130a@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e42e0c4-c1f9-4778-a979-404fbb68130a@linux.dev>
X-Rspamd-Queue-Id: 71E8580004
X-Stat-Signature: ydjw93y9beaef4ypur8os4nyagt7g3g7
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795573704-832267
X-HE-Meta: U2FsdGVkX1+xnYNoD2X6ZYhCvICtn8SH9bu5k/zoTcbi9xJSuiqIxrlW6YwWzJ5lvJ/WWdilB0A93f0yOHC4tQP04zQ2njr4lF9DuVGMjQgDgUTy7K3zwte7ZgKgG+eyt6+ErPkcuSnEvzioBDPdIcqJKzKHxUjlxBm+mJM4XLpHmgSgN1ndDgegeJw3Jut7gI7Tr6TL0eENTWE96cxjdxRgP1/dA0WNaZ5dUam6ywaYP1KJPfc4nbYBCvi/zNSUaTnVcSebvpsUnIRdlV49Pf3QDgTckrrM6KWZSSuSc4q3UYoJ3q9ByD9KzSeCf+XuVcAs5bJ2ZgO6aZvCD3/BT3aV3GqsLcSyxoGTTNb4DJ0CTg9w5m9hFvUMcpjrNdSf/FfFv1zV7pMRaMgzIsml99lHC+hPo0jjFQhFy2P64kXAzhuVKiXD6sIdPR9mjpHS4tpnMd6YGhaU6em2gFeFcaOLUctqFimlfNY9vgcsBoAwUrkKgY22oFyUEEF1v3f+eS6ss7jM/ssL453CcRzld2nhtG7hFGIIkrSUmpVskFg68r6Anju6yY6Unmtx6Rxtw7fv6aIs0Do7QG/bORkWiaTXEYRwWYlFN3iYr3vXmyxzPI0511E26KiqCzEJqn/xhdMXv3A3uBreglbPUZkUK9cBlEznqp9nLOMk7e0ozkuH8CIP/vz44VRabJrjOPvPGg6yipp1FKUixj1NZZwIfe8lXg08yoMTOZckrTL2vgNJsWECqTrW2SgFJNM/FGZpgDc2nR8JIoQHDcZEhAsDRgVkk7NkNypGV0xmbJjyMIOZuEmMH/HeWteu3fdS6AVlWjM7MXjN3OGkQoKP6LvT1UsUBGo6BTbO4MWN/MijgK+UVTJEnbkRl14YpMafvQ9CQKhdBpZ6H+C3hIEXmv1L3dDZh1AqjrGVkHgGCHs/+mC5HMcwmhLA4W3KjfFR7dIO5yArbHFjodePNo6KMWM
 AHq5+FfM
 txDlK0BczbSCYK2R+wXqEKSNLNysKX7alaNwREHcVtw6SP/Jnd4LyjplU3lYfnV1lhi5hqmQ0Mo1BEd8mood3LPGs/u+aGVkvXLqxlyQVr2NWHZQQZu2mImLte3ua24ZMRlwVnNtWcVb0PYR/EVcEepB58GxozEdC4S2gZ3gU/kIxHO27vhzszTzNxoH+9dHyQsDnkoh5MDKPJDasJYal7u9eiL2dlQ3t8Vy5NPUigoe7KdHJrdA1u/uFC+sxTur+3gsNtxQiC9tCQaSGgHiYHFYyxbIG7cQwFSrUJIHn4fu37cldTyieyxY0pmuz5CX5YG8l1iVDyWILadX1TPwfPg5s6/v5G/wgtPIl2GhNVipmZuCKRYHM330aENf/iSjsVu7kwt1ZhFQpTy9qL7hDQIZe4JbcBOhvsUZnrG1y/5NpGt/RUZ6L+krE4KtU+VTbBjuC3R/hUiR9dpBdZbV6tlpn75Fy15TH+qNAj1wG7wX9kdCa8VRDuK3TCwknrRnn5fZDAzC2U8Q5I5ZY1vkiiIHmmQybxyE/ig/0WzoGJDms5j4chGcB1aTiqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 at 05:35pm, Hui Zhu wrote:
> 
> 2026/11/19 15:29, Baoquan He:
> > On 11/17/26 at 07:37pm, Hui Zhu wrote:
> > > From: Hui Zhu <zhuhui@kylinos.cn>
> > > 
...snip...
> > > @@ -3263,6 +3264,18 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
> > >   	return last;
> > >   }
> > > +/*
> > > + * Advance mm_state->seq without walking the mm_list. The cursor must be
> > > + * dropped as well: iterate_mm_list() resumes from head, and resets the Bloom
> > > + * filter only when head == &mm_list->fifo.
> > > + */
> > This looks like a good catch, while the function name here is a little bit
> > confusing. From the code block inside, we can't see it's doing iteration,
> > just a pair of pointer resetting and a max_seq advancing. I would rather
> > not wrap up them if no good name is concluded. Personal opinion.
> How about inc_mm_state_seq(), after inc_max_seq(), leaving the "why"
> to the comment:
> 
>     /*
>      * The cursor must be dropped along with mm_state->seq:
>      * iterate_mm_list() resumes from head, and resets the Bloom filter
>      * only when head == &mm_list->fifo.
>      */
>     static void inc_mm_state_seq(struct lru_gen_mm_state *mm_state)
> 
> If that still does not read well to you, I will drop the helper in v2 and
> keep the two lines open-coded.

I feel like not wrapping them up is a little better than wrapping in
this case, while it's purely personal flavor. I would like to hear
other reviewers' opinion or it's up to you. Thanks.

> > 
> > Other than the nits,
> > 
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> 
> Thank you!
> 
> Best,
> Hui
> 
> > 
> > > +static void skip_mm_iteration(struct lru_gen_mm_state *mm_state)
> > > +{
> > > +	mm_state->head = NULL;
> > > +	mm_state->tail = NULL;
> > > +	WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
> > > +}
> > > +
> > >   static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
> > >   {
> > >   	bool success = false;
> > > @@ -3275,9 +3288,7 @@ static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
> > >   	VM_WARN_ON_ONCE(mm_state->seq + 1 < seq);
> > >   	if (seq > mm_state->seq) {
> > > -		mm_state->head = NULL;
> > > -		mm_state->tail = NULL;
> > > -		WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
> > > +		skip_mm_iteration(mm_state);
> > >   		success = true;
> > >   	}
> > > @@ -4686,15 +4697,11 @@ static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
> > >   	DEFINE_MAX_SEQ(lruvec);
> > >   	bool success = false;
> > > -	/*
> > > -	 * We are not iterating the mm_list here, updating mm_state->seq is just
> > > -	 * to make mm walkers work properly.
> > > -	 */
> > >   	if (mm_state) {
> > >   		spin_lock(&mm_list->lock);
> > >   		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
> > >   		if (max_seq > mm_state->seq) {
> > > -			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
> > > +			skip_mm_iteration(mm_state);
> > >   			success = true;
> > >   		}
> > >   		spin_unlock(&mm_list->lock);
> > > -- 
> > > 2.53.0
> > > 

