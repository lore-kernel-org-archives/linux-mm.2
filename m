Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E38CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB026B00B2; Thu, 25 Jun 2026 16:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CF66B00B4; Thu, 25 Jun 2026 16:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92F56B00B5; Thu, 25 Jun 2026 16:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82FA46B00B2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:23:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13F5C1C0DC6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:23:10 +0000 (UTC)
X-FDA: 84919559340.11.B4CD5AA
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6BD762000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:23:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t2yafPs0;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782418988;
	b=fyfXoAZScpGETrXc1KWLHSuTB1kUsSzTDNifwMZIvHPqajUxKNMuqAofzKp6Jkr5rA7FeT
	62pR7DDlG+fTlI8xZEBn6o214ihyPc2CcKfFMOChhVgccqx56Hd8tVHIOCJqyXNKc5cZHW
	S6P+dOTt51Ui2wcxE/2Ornstf7dV/l0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782418988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4666zdLjJLZrpvKtSAgWM48xKMLs0ArCqLFSxNE1+L8=;
	b=F7MbcUWSmUWs/CmzvTlobT1651eVK4/q7yXydouyRVBDJL8aLnm5CaN6Pqu6K/8dybTVGA
	tFhzsDLqDt0epAV4fkVbfV/4Zm2RBeg6g+dqa1BAOsOjok+fhTGjHVX4opTRBlZYrzx3kn
	+AKMywIcI6s79z0F0I1nfnC/yOvhuNY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t2yafPs0;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 25 Jun 2026 13:22:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782418983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4666zdLjJLZrpvKtSAgWM48xKMLs0ArCqLFSxNE1+L8=;
	b=t2yafPs094NOh1WTpNMPZTHY/qli/6qioi0s7PHyfGYLLwRVTq1sRqEpQA07Q1fIM1NRmV
	C51OX/DEP2PPFJOPcZteAcOzhct1bqnJbnUqVRgwjpViy8GrrkUXRkdPqV/DdX1HOwcwUj
	HNlmU7yFsgzQO3IBaUfW4U00RtqcGRc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, harry@kernel.org, muchun.song@linux.dev, 
	peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <aj2MsQ3tF0ACCCGi@linux.dev>
References: <20260625151554.55105-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625151554.55105-1-qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6BD762000F
X-Stat-Signature: dwafhwpckfscgyu57aknoki7ezhk7h4e
X-HE-Tag: 1782418986-904115
X-HE-Meta: U2FsdGVkX18uqX5W2foVU9Jivayn4I/csftwdbLmZOVJ8t5nSSTbQKCRVYBIa1zfGTUK5jfukWicT9V75aZUpgG3ElbXqp5LWWvkIw54ZTB2ybGoQnxaBGnZ9thMltGkERTbAP5m5+QJKQkXHw7x4EGb89VBWpHC6FOqXUUsk2p00VDcddnP6/hJNpW6rH1jJYw0+tlOdQQFhj5tUY6WCwFY5j1oeSrvk3V6Fv7BrmDvuZh7PaEDE6/ZGMNdvr/+U2OrxVtOLOrZtQjvDyqe922YQ3Ivam3BkQT+TW+HAOF255Azp03+zlULjkGdCUCTv+3XPSm74xglZijVAE05cgKQY5V3L5Nj2We7K3Rg88IjaMFYvPkCuod5pAAK49tXbBmgRoL9N3bZL6h13v/NgeFsPFdDVVqF1cFT5sR/inaVnOhoRtzx7dXhlFBqxe90AWkj517FXU0eJ1ry90anOPWaJcNN5k6q+07VP5k5qpoSuiuoA75W2wPhZuWNN/CHpG5oZjKzIGsiVwzyyZF7cVul90jd0nbq8XsZEJE+Qel7RsVrcfklY5NnpklI+4suPg0YZSkcQroTow6wICzi7GRH67aq945jh3YhOjtjmSDbIogvvuBrd5bZrdKfoEZRkKXOye+zkc3s1ZIidEuvZPtaO5OC7xw7mWw/8dGaMGIxVRstauRe3yD+pCK/ae84OX/N2aKHyS3G+cm2dDARiwigaVifsptQtyr5eBAtbyjn8bsqQFYGSF+m9ZV5B9l3s3p5IynC4PtDAVNm6XNVeyVZZ3KXF3fnezw8QjHRkQqKvA4mI5cO9n3Z8E9jeODVSlnPngdfhukfTXe2X5Vh4jzwsdZL8EeaTYFOvOnaim2diw9NQx0QbCC3CVObluqh5W1hOhOsnq4f9cpcG2xerQ/GTNZbPQx6AzhbeBTdpZhw3gSbV6rjzn0NfvLnKYBm6FMNnYPsl5zaqF8NYa+
 vk8Bmil6
 KiDmC+1nFnFw9oi1cYkeIMalMBGIyUOv7hbVssajTHyDncEUhlVhi9c2KbJj+IDPrbGD59zNJokoIvSHh26iEmFjHKPF14HXsyqXkN4KcwRqUigu+SBtqSyFO3JaTz+vTyN5taFsEh+K4Z0Q8Oo8LfT1AjKpqcfp+qKGULPf+6vJ1gEnlVE27W4w8/yxXoB5M/sfI/M/ixXySigct9BIYMra5QFiAyeS89nJInVNVF6bYhF4IHfpez3fJiS8LV6pPzhac
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:15:54PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
> 
> The page table walker can run concurrently with the memcg reparenting path
> as follows:
> 
> CPU0                           CPU1
> ====                           ====
> 
> walk_mm
> --> walk_page_range
>     --> update_batch_size
>         --> walk->nr_pages += delta
> 
>                               mem_cgroup_css_offline
>                               --> memcg_reparent_objcgs
>                                   --> lock lruvec
>                                       lru_gen_reparent_memcg
>                                       --> reparent child folios to parent
>                                       unlock lruvec
> 
>     lock lruvec
>     reset_batch_size
>     --> child lrugen->nr_pages += delta
> 
> This will trigger the following warning in lru_gen_exit_memcg():
> 
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
> 
> And the user-visible impact of underestimated nr_pages in MGLRU was
> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
> reaches zero, but there are still more pages.
> 
> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> flushing the pending batch. A non-dying memcg keeps the original lruvec
> stable against RCU-delayed offlining; a dying memcg redirects the deltas
> to the first non-dying ancestor.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
> Changes in v3:
>  - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
>    (suggested by Harry)
>  - update the commit message (suggested by Harry)
>  - temporarily drop the previous Reviewed-by tags
>    (since the sync method has changed)
>  - rebase onto the next-20260624
> 
> Changes in v2:
>  - update the commit message (pointed by Barry)
>  - collect Reviewed-by
> 
>  mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..1ec8c23c72b9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3262,10 +3262,44 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
>  	walk->nr_pages[new_gen][type][zone] += delta;
>  }
>  
> +#ifdef CONFIG_MEMCG
> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)

This is memcg specific function, move this function next to similar functions
like lruvec_lock_irq. Also put irq in the name.

BTW have you checked other places where lruvec_lock_irq is used and if similar
kind of situation can happen?


