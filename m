Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43235CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295AC6B00CD; Thu, 25 Jun 2026 14:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2471B6B00CE; Thu, 25 Jun 2026 14:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15CC26B00CF; Thu, 25 Jun 2026 14:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6AF76B00CD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:41:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 707DD1C16E2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:41:50 +0000 (UTC)
X-FDA: 84919303980.09.80420F6
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48ECF180006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:41:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lK3ExJQn;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782412908;
	b=pyBGrVFyWpKhVTyI+PbW4PHMmWkEExbVFmNjguoBkvXmAbijC/zH4P3NYEdtWY5nd4x0XN
	Ev5FbuI0yn/t5I39Z1JewgdyKI9cBIaxgXNPnQGM4lonjbgZJmNbHKYFE4aQq+88JsRl5l
	q9QfiINRWRn13XFqlk5fWFYjTBezVic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782412908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1D9CBgF0HlJq0J3VbKd4okLgUS8bFp8B2vYpuNdfCds=;
	b=dRbyYmsZKRrq65EYFFUiiSF9weBFPXI8DBxvBWht47NbGeID+ZAgiZwfXtGeYhn79k91xe
	Ed/nMhLG1MQuyYvOSAUYeb+VgIG8+NDV78yRJdKCpq7Jes9rHc60OBdgqyDI490QN50SX0
	lGLsNM7e9US6Mh5U5xL2Vh5hjW4fTLg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lK3ExJQn;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5178a42caa3so1243011cf.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782412907; x=1783017707; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1D9CBgF0HlJq0J3VbKd4okLgUS8bFp8B2vYpuNdfCds=;
        b=lK3ExJQn/SlDLo7CL+a7j8bDGvWUWaPzSjIe0LZNKH7uLo02upyrgw7QgFLKVDl2rH
         u8/xr9j8lo7GLUL4dEjF8LG1EmZYTuG7ri7UhJ25o56ENlD8qWqOMpXzSGgd5083bwGs
         1zWa6XT60EmxFpphl1NXO7dE4isZ/wxccDZRmVehmsZTg7aUJPfnVHsSvYJkE+VDIvcW
         NzF5LoB9+hvDjcCojoxFD92aMv+ek/xNAoMBmcOp5v1mU5RUK7phdWN9pg/W9dxqRo4o
         ksWpWvYDNpuZqy/xDvZozD/L9YdIRUtzXPEB1iWLIp6g8ujhspCDyIuTPCZaJz3q1zEm
         nUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782412907; x=1783017707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1D9CBgF0HlJq0J3VbKd4okLgUS8bFp8B2vYpuNdfCds=;
        b=oRWfZqPvHaswS5VJs8+IYUjIiAtyfi4SFjybyDyRS1nqXHLXuAEE4V+iiWhJ29liF+
         QCzJknYIBCj8HyjLw9wuW9WC2t4XWBZxagcK3q8kKk0b8owXD31xzFfHzJcUCRkCwjSk
         eAYOgVxNYi68ilWhsdWDJ3jIuXIiwLMm+o9OIslI21ZduA7Qsc10T/Fk1uVHxiGA0kW1
         0Q1dugRvQiculP1XrloAz61ey7d0RH25iLEmAbPpsuLnQ3D9j91yi8miEy/qFJ6BW1mV
         IYH3AB3lV4Gq9/97wxmcGqzAwOzuyVKH7hiCp/KtmxZCtLTMnud1A9zeK8sQ6cZkEgjn
         wOZQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Qu/IC6NvgZow9rLN31HzQmt9HbYm1HIuycHvj6BdYkGiUGyUu2ZGUv17TM/fbXooav9ae1S1Cow==@kvack.org
X-Gm-Message-State: AOJu0Ywxm0O+ni+RWZk96xpz02Pdz7a4egOCqWh72i9P3aNe1TiF0K8F
	gWhzKN/dIR7hbaZudebDwguO/nohHZq/B2TNLXUwambMfLmJcvMobbfnjxjaqtwv5iU=
X-Gm-Gg: AfdE7ckvMJ//MloH6ODlED0MQ0ceQArpIincbRZjQhRYbSYRaUhuxDwhvMroS5U9Z0x
	zJ5QHAP/+vgRVUFeYB+GUX9w0yUp/ZZNrxcAJwnwlz2ke3ccUUDV4pWny0lM9W8HxTCvs7VK0nH
	zcX4aIy1xgp6M8hF6befxBKRdgLZoipqftQeq6YEVIM2b3OGU6whllKsM5xNPI2LnngqCeNqbqp
	TE3/FBGrRIYrYGVbVC9lQhJWNKW0nJp4jRBdjyxHtC0ok2yxsnMfwQ97jpmFpxDvVYLjqTW4W+L
	Cw6M3IhgbpxjgJVT86eiAbneH6yqzGRvDgX9t5A9lqSxV7w30UCIpL5L06I6LH49fmaHHhV2E/r
	k4QLPXKcX9bxP42i6yLqMNcWsSAP+GrGEWrwgAan/DX77LEYpHJZfvH2MOkN+d2ljV5/O21ry0o
	jYHi/rsPlgOUpJVZ3pG6Gccw==
X-Received: by 2002:a05:622a:60f:b0:517:7220:b941 with SMTP id d75a77b69052e-51a51b79837mr181525901cf.32.1782412907285;
        Thu, 25 Jun 2026 11:41:47 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f018011sm193477016d6.5.2026.06.25.11.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 11:41:46 -0700 (PDT)
Date: Thu, 25 Jun 2026 14:41:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, harry@kernel.org,
	muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn,
	mhocko@kernel.org, roman.gushchin@linux.dev, ljs@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <aj12aVq3he6q7b2C@cmpxchg.org>
References: <20260625151554.55105-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625151554.55105-1-qi.zheng@linux.dev>
X-Rspam-User: 
X-Stat-Signature: ourbs54iozxjst1qc9yu31rg9ka63wai
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 48ECF180006
X-HE-Tag: 1782412908-179356
X-HE-Meta: U2FsdGVkX19yyLqGpBiiX8vjcXGGENmLmwgkfKdTKucTsdZeN2we1Dg9KdEujDDuiokCj1gVLmxXPJr2XNOo6Ekkdd5gMLkBmVRsSzox77Rvvxw94nye8ajN6pLbZgz8+ustmrBksw0RcJCsCS456E5D8tipFFpTvT0uQcYLN6CWrTtxdQ4eych421fY34KxV29rJYjH2kTamEAR7i9QYEoLbMMHC+KrRMbZkbQcCoAfsTI3NjwGk7dr/9p/5oLmH1JAM7Xic9bm78TRl9KHVfUxMBshASQENK76+jNTIC1cQ6jtNl2nG5CT9573rBS/IJCKQ60KV83f3o5UKgax7K+2RiM/3qKXEWr7Et/4XTE06IpxEmWEClrr8hAIYIyfM/WpkpEXzFoWux3Xfgwa0On9qWkFrvlEiwMqLRNi0J000MV4sijyc+FNjgwz7x2R5RDYPsJrJVe9tHBAOE73gsfTX3Mz2Ct9famcquCxY96kexKAEC2BuZ25B/r47VuUSNXQEMAqvIVJIjhBCSWlEdrJRG5vgUJ6CHjxZpN5rLkhYILDn8x47iCt9bzndE/yNqU/IG2jN/EDtxBd20+VgS23J0uQemyAi8nR7uqb7N6B4CNd8lvG/QCEkg1+qw3EVk2eLv8p3WEmSgAEUvMK2M0Ezb+ndFlYeVdQKMPPdwLMCp6VE8Zqy5qHj8tzoR3QrThkb+5gBfNJhbvnCyd5ByYDlRMm7zXJkea9nodR1NFH4BsNzRWqwLY6b6gG+FwD+fIqKNt9IiH1RPeug5fETeMV427ZWQaUvhtugIRpqYmujCpjm+l8iKaFwwC9056n7dkW5tJaYb863wx78Gqv93lURALY2I8kG0hbNfBZ4aYRUvmFHbDOzz5eEfS3HFH/SYmCI4sucOrfhfrtcpnhBPIvrQ01DjRlDlTsQ3pt3YQfNbEm+svO8XBstXIGUjg2WyBnosJnKRhmpyHSxCP
 +Ja7eez5
 RN/+DjTRidb4F1eC85YpwFSa5uct8pHz+FVshXAHcAuysaX/UE5HM0SpFHspldxz1pxyKizBGkJUaFuiZkchvb3I1bfcMdLGl0eKAYveZS9ZvDDYFfAw/5Aev3AIZNZIXdMkqrFDS/gqPHynB6qVXk67yL+fu5HLDPaE3L7oYKkDjIhhvwROEBjal/g4pzZabv0Kh6WBYHEgeJxEXo+PN8Wr0FKeRQ/XcBW8mGfbSAF5jR/ZpBHQNih/kwZN0liFQAzIYekRnd3ZL9MXM0CeV2T3OtSKNjey1GXg4Zoc7jTyFLjl3gF2Vj5KhM8nnNHJ0Rhc9Uo9bzn5xRl/sVvCTJZtKZHYvSSx1MRMaJr6Tr84LaLcd1zTNDrA3wtu54AVqqVYKzATtF4JE7li7fM6E4h7V6WyA/hAiG0zXKRoenbLWkYFmIIg+pkfaVYMRjTBR+eK+0JknNgauDSs=
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
> +{
> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> +
> +	rcu_read_lock();

Where is this unlocked?

> +	/*
> +	 * The memcg can be NULL when the memory controller is disabled.
> +	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
> +	 */
> +	if (!memcg || !css_is_dying(&memcg->css))
> +		goto lock;
> +
> +	do {
> +		memcg = parent_mem_cgroup(memcg);
> +	} while (memcg && css_is_dying(&memcg->css));
> +	lruvec = mem_cgroup_lruvec(memcg, pgdat);

	while (unlikely(memcg && css_is_dying(&memcg->css))) {
		memcg = parent_mem_cgroup(memcg);
		lruvec = mem_cgroup_lruvec(memcg, pgdat);
	}

