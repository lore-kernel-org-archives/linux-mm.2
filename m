Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90BBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E346B00A6; Wed,  1 Jul 2026 11:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53FA6B00A8; Wed,  1 Jul 2026 11:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9453D6B00AB; Wed,  1 Jul 2026 11:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9686B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:59:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0938A8D328
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:59:23 +0000 (UTC)
X-FDA: 84940667406.06.B952A35
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id E4CDF40012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:59:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="U1ta/rdR";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782921561;
	b=lYPqDI3klkrHY87lL+LAk/BvHhM3jadSuULBoCpjTdlARAS/zL6IcMO9UP8exX3LuzPF0Q
	GqHj5sUk4CWaIgDr5kOZ9URVDNVQP85U01sbIKT9vFZuvx2uS0t22wD2YaWB3EUHFVcOGV
	r7r5oqkHO49hAwyurc5Em3RJwl7eVFw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782921561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vW5yMQMtKuZNWOL3QxEXaq9d8mHdlESmK4dMn+saK1g=;
	b=qi92xp+vWtqT11ytfDakkdAhRQP20W12rNQoXpk/AcBrHU+h6adGwl+HoAPDB8TrKrzqsS
	PyJrr7rqmKbFM2EzD5wwf+p94EdTTsH6cDMuq6rJnIvDjgealNxPB2sEkSByfj00btiAiJ
	WDswBDKVqp7pOp3T65pHwJDPk6ROiek=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="U1ta/rdR";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51a868b6962so7169231cf.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782921560; x=1783526360; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vW5yMQMtKuZNWOL3QxEXaq9d8mHdlESmK4dMn+saK1g=;
        b=U1ta/rdRQ77xp7IF1M3L9B3Z0BS8p7nqMyiPiXNtO9Evm6jQsMv+xRl/JihcuSzQDR
         Yy1+LmBdUuu+kRspxhIjNpiDbfDM8615vjc3TrvpTTnkKD/AO86uSy6m4+DtPn3yspLb
         MsJb1QPPjHcBFZGq0IoZwpaXoxTFG8UINUXppceAX5d8ibzdp8/rOHS6pjgkJTNyltkg
         FyfgQzO2UOoZhs1NfigFBapRP47VEa2m6pVKe224O7+WIkBS9Ph9orgnK/NqNBJ9Hxnu
         ZLYWQobV2iliikkszAFUYhZJ+YhnGqh1l5XJHDWn6NGF1LKV1zNRYHhPMA41FX8JGizf
         omFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782921560; x=1783526360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vW5yMQMtKuZNWOL3QxEXaq9d8mHdlESmK4dMn+saK1g=;
        b=HTdWP7S2MvrZr4VaK7Ket7Z4eQlEZ7ByyEpamqr6ztJCnZZ1PitdJOAjD70AIwq6ES
         cCI4Qba6FbC17omMp+t2q9npHY2ZzFSSx7BSZNqN9Oj0ih+nHgTsFD1ITlDxuN50s9XN
         WV0iavFbzua+9CoJipbvQV2eo+EikY5TCs5actvp6SZX7ALVd45om22Ls/amJy0CuKMK
         hN2Vz3A+YYURTZvCj0kAHcejE3JeQAE71bFxLQlvD7AUSbTnen/RAyO40pl32Ubf8cUd
         niHDfnkXFn7wK9LhNP6zaYNKxNWxoXuNRmy8m2Nkfb5lCGT4HDz8j48Xf1o6MPMYONXu
         sbuQ==
X-Forwarded-Encrypted: i=1; AFNElJ8yL+Dx9+1mv8PYsUG85XUe2SBpvw87n88O3Z4nugQ70WEgMt2VzGFW1mfuFvpXaZV8sJYaHui8VQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5og1/EZBFYQk/NGOzXF2AeH/I/XXnAJsLXJFH7b/Jp3HYjOm+
	wulKVfC/5PmKwhm8ld71kSmOpo0K7kkkyfmDARrQkbYxYqII0sNSAft6zs1ZE5LJnZg=
X-Gm-Gg: AfdE7clEAFntl6uyip6fY8I4zfv+uzJzZAY2odCaSYDrUhpjAQ4pDtsfoqrz1hnQtzQ
	sfN0ctxiy1Jl44bwEjKtb3+Il0NSE7JG0T5rAfSeq4g2zFcC1FKySZ8+pDK3iKvAh69EX8MGFAW
	Z32doMTfn+G/B5R2DHu9JtJEy3TbbMvvcvAl3dto/atLykISuEwO+Nv3549/kHBJsAGTa/Q0ELp
	otRCtpblVSlAkF42i+KzI1lPjiCL/MLIZqf4+icDzThuRxeDbcuDFSuVMF+FRIoV97mfoK4PODj
	mxb0qeFl8Ef0jp5EcuZ/8oyizOKOvxWtnnR2z8iVJPc1x5ybYdeYz48lUE/bzAh9p5PYzDJDFKp
	XwfFyUNFHTdbA4tFKRKdTbefIEYcKdVqnVwRizTvaOxovHqWp0e2U/ytWfZWj/9DjRXnfQLSpzW
	scYR37z/bUadM=
X-Received: by 2002:a05:622a:4088:b0:517:6804:3732 with SMTP id d75a77b69052e-51c26b0fceemr29104571cf.55.1782921559721;
        Wed, 01 Jul 2026 08:59:19 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c10a37dc5sm49375091cf.31.2026.07.01.08.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:59:18 -0700 (PDT)
Date: Wed, 1 Jul 2026 11:59:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Harry Yoo <harry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, muchun.song@linux.dev,
	peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
	roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <akU5VdOBkLGInh_t@cmpxchg.org>
References: <20260701145736.3785016-1-usama.arif@linux.dev>
 <2fb5ce53-666b-4b0a-a4ad-2b3a28c54768@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fb5ce53-666b-4b0a-a4ad-2b3a28c54768@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ks7bym78w1ouon5ykaz6ijeeuaacurzi
X-Rspamd-Queue-Id: E4CDF40012
X-Rspamd-Server: rspam06
X-HE-Tag: 1782921560-269932
X-HE-Meta: U2FsdGVkX18hPWYGRoffkF4pYfzO/5RuVzqEHVcAtW2PATct9lQw/e+KF+RxgsTbOf4DBIgJWnalcfVAy/VmgKdMDFA7Q/1M4lDNEClUZjWdD3ZgzTvkosvODiYcIyDDz1UyTBi68sm3ejKnaY9COsSGNi33sJjBQVtykmLGjIbjZ58rq0hP1ArG6IgmBv8Tc91K7/GaG8vf54aTtcecfOraIryTGASRuq21jb6ZS8S3ObwApKNLFqkgL6oVE3pBft3i0DqsRwq7RXbpLorI45zX0T3lQD0YKGqM1zjBJpgE7jLT7y3EebXCjFlxXNyY9OCu+n4qDvlogRzVZXhhkFxbc+C49D5qAgcgtnDZhozriR0bD7IDn16wANnIYCTINf+n6ROlf9sE5ZHi+kKC6DI9jkmgvES7NNhJ9glCjrWQkVfa1v2wLqBO2O1w3J2JZcARjF/wild4bYEZV0IE9zicyvRe2mlqTZOHaCAbUE2Jgbtb0b0GQUAeVW4+X6SAMrmI3ISz4fptT9EVsEZmvNu7zeA7LJl3EWd7GlwBuV8QtUFKSZylMPaPoc2RP0Ax58eZGZxa+Bw5I3xjuBDf+10+1zjG0qaaHjIvLXHmFVMYHJjvWnfSaxMPMF8oGkhVH9BNx2d3F+KILHSpkgP+ekx9/x5UuOBS44FUJz3jg0oTimGS8rwoAZvBe7wM1J0xtrMAeH+kFy50nz6PEUn+/DRn+L+bOGcfO/OC3wwGya+flJ5dxutRLFECOLAg0dqJsvnIqTp8MVsI8PrKjQEg72KY5AxE/uGjZLV7Zn8BVp5A/dj//g/6UtiXRLDU0rUItMWLQkqWYR8m8dXMZdVTGtXhcizd8+OrSQClfbg0uBRL2Pcg7/7WSiLlD3txL3d//LjcYBQdH+l/BvkXolCZI9cN3Zxh0hNYdOs9TvZJDQ81hIKwTMMLF6QsY9aO1gekGPcPt8h4W6AyW7Arr3M
 IvCRSLgZ
 V98BETe5IkSGRWP562cBGTwo0dENbjD1RzZcfza+ySlBTGLzc6eAWk0vtSmuBUe8Ip0VwgD1ptH0/X8lKurGnZjncNyiALZ7LHqYbl4i9uZUwY1kfFYe1VJuT9CW4+END4EzCeCdaK+DfP8nwf07OIn3UoV9DGjwbO9/YbircfnjxWZ82Olk9+C36GnqUuUwmIizx6CFc/WJW6jamhNbovZVXZz4i5Bs5QR5j+Y47SKQpGqPU9kBpdfc3v9Kk0Idaf1NAqDQrQkaedrVFHSqUEZSD805gywIRf5JH4cIxfNnW57PZmk+Mrl//Jdj9A6HHjD++SOI5sP2X3r94Jn+DqY7lPSIO0oAt2ZEA7qh7xC9i+txUmISswixuyHHjc/EPOwSlz9ewR8zHCtnxzKZMw/DLgarohO3qBA+S+cGKVJvzapePtvUw5lEwCzen//QdIPiVEPy742KoUuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:36:42AM +0900, Harry Yoo wrote:
> 
> 
> On 7/1/26 11:57 PM, Usama Arif wrote:
> > On Wed,  1 Jul 2026 15:52:51 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> > 
> >> From: Qi Zheng <zhengqi.arch@bytedance.com>
> >>
> >> The mglru page table walker batches per-generation size deltas in
> >> walk->nr_pages while walking page tables without holding the lruvec lock.
> >> The reset_batch_size() later folds those deltas into walk->lruvec under
> >> the lruvec lock.
> >>
> >> The page table walker can run concurrently with the memcg reparenting path
> >> as follows:
> >>
> >> CPU0                           CPU1
> >> ====                           ====
> >>
> >> walk_mm
> >> --> walk_page_range
> >>     --> update_batch_size
> >>         --> walk->nr_pages += delta
> >>
> >>                               mem_cgroup_css_offline
> >>                               --> memcg_reparent_objcgs
> >>                                   --> lock lruvec
> >>                                       lru_gen_reparent_memcg
> >>                                       --> reparent child folios to parent
> >>                                       unlock lruvec
> >>
> >>     lock lruvec
> >>     reset_batch_size
> >>     --> child lrugen->nr_pages += delta
> >>
> >> This will trigger the following warning in lru_gen_exit_memcg():
> >>
> >> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> >> 				   sizeof(lruvec->lrugen.nr_pages)));
> >>
> >> And the user-visible impact of underestimated nr_pages in MGLRU was
> >> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
> >> reaches zero, but there are still more pages.
> >>
> >> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> >> flushing the pending batch. A non-dying memcg keeps the original lruvec
> >> stable against RCU-delayed offlining; a dying memcg redirects the deltas
> >> to the first non-dying ancestor.
> >>
> >> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> >> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> >> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> >> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> >> ---
> >> Changes in v4:
> >>  - re-implement lock_batch_lruvec() in a simpler way
> >>    (suggested by Johannes and Harry)
> >>  - collect Reviewed-by
> >>  - rebase onto the next-20260630
> >>
> >> Changes in v3:
> >>  - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
> >>    (suggested by Harry)
> >>  - update the commit message (suggested by Harry)
> >>  - temporarily drop the previous Reviewed-by tags
> >>    (since the sync method has changed)
> >>  - rebase onto the next-20260624
> >>
> >> Changes in v2:
> >>  - update the commit message (pointed by Barry)
> >>  - collect Reviewed-by
> >>
> >>  mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++++-------
> >>  1 file changed, 34 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 35c3bb15ae96..ca1e2a870d51 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -3262,10 +3262,40 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
> >>  	walk->nr_pages[new_gen][type][zone] += delta;
> >>  }
> >>  
> >> +#ifdef CONFIG_MEMCG
> >> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> >> +{
> >> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> >> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> >> +
> >> +	rcu_read_lock();
> >> +
> >> +	/*
> >> +	 * The memcg can be NULL when the memory controller is disabled.
> >> +	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
> >> +	 */
> >> +	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> >> +		memcg = parent_mem_cgroup(memcg);
> >> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> >> +	}
> >> +
> >> +	spin_lock_irq(&lruvec->lru_lock);
> > 
> > Do we need an rcu_read_unlock() here?
> 
> lruvec_unlock_irq() does that.

Yeah, that tripped me up too. And it makes me think Shakeel was right
after all: this should live next to the other lruvec_lock() primitives.

Sure, MGLRU is the only user, but it's still much easier to understand
this if the code sits next to the rest of the API (and the unlock!).

lruvec_live_lock_irq()?

