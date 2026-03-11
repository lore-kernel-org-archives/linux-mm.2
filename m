Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57534103E2E4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 22:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9275D6B0005; Wed, 11 Mar 2026 18:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D49B6B0089; Wed, 11 Mar 2026 18:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6466B008A; Wed, 11 Mar 2026 18:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 69A876B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:05:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1698D13AE54
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:05:26 +0000 (UTC)
X-FDA: 84535164252.06.5E52FCF
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2BDA520002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:05:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cZRRBay1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of bingjiao@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773266724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXWniKRYu/9movUjNPN4FwDYQDKZWxsH7J4WhlFPgko=;
	b=iEhVgWKGkNp6C9dKAGyDcuHT7mGD2QMlJz9KjbHzdGKCd803gGwaOgk1SKfW+JYQJJHTSP
	9vPENmbKulnxEtGRhK5UiVN1vBvxt/pchJyV49/I083e8HaFK4zaLOBXdY9Oio4MGjA6rk
	jo3mMeDRy9DEoWYfki4gk3pKO4KUO/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773266724; a=rsa-sha256;
	cv=none;
	b=txyjdA62uiP4b4IBn4FS7Grw2MvPS4eDKrMyonzYQ4IUg2hzkUJOKHT1XZcFfEPIjYFTGD
	/SQGXtpsQn7I5cIr5Rhr2lA77tHE+GbMC2K5R0ZrFAylH1vJrWctdA/Xi6odzFJh/PmuvK
	K46gypR2HNEkPpRPi4uJvi3VUdDejwc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cZRRBay1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of bingjiao@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=bingjiao@google.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-126ea4e9697so1678c88.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773266723; x=1773871523; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wXWniKRYu/9movUjNPN4FwDYQDKZWxsH7J4WhlFPgko=;
        b=cZRRBay1/H/A3eSnOzpu6G3g8zurmWlamaijspH4HJUiO+ion84pUZK/DVW/b/HQSa
         SIHq5K8xFiWJ5y1fvqyRyl84k2KoW2BuMFL9v5sdVV9z/hASOMAtYiFYdHMxr/ffYLsm
         X9eMsrSvsYbH9wz4esd8d+glx2C1TB/oXitMRoqAG7ZGw6poUweKmxrFwowgCtwYNXMz
         qyGzk6uHOsY57HTez84k5/65hpkLJheyE5wFs5FPIbvxzJyk7k8KMs0/eV17vcR0RaYH
         46K3pv3tMnQdUROuyKWV/9z4Jh7DVr7CejnyjcK+htyci3324KyVSzcbF+6hdD4Ajk8s
         TOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773266723; x=1773871523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wXWniKRYu/9movUjNPN4FwDYQDKZWxsH7J4WhlFPgko=;
        b=mAEL9pzyoLNyr1n3uCgO4C5ZyIuU0fnfV6YdzmDDdGGTjDQ1CsVBYKg1+k0gHHH9bg
         Xe5AggpDaZFq1vYpj4YUbq9wUWBkdXN5hWecySZOw/CgLZuJwq/rnz/OO0RmDMtk5Hd8
         wWl+geqnOeKeZBKkvXWRwOMN5f+M4Zs0yuO1ewb2KXvKSIfSOfdBYbjJjxEkbzxokfKn
         TaYgYdKsE7CcWVfNE0EWZe+r7kwFVjzboxrCnEsvcNGTVTSBNM25axr3d1anbPGQVj51
         MJHuVTyJ8iirgSuWf6gZCUD5gRFmPaDLjXGccO00KImQyVWA/+H3qb/3I6dSTAEEHxBb
         oVzA==
X-Forwarded-Encrypted: i=1; AJvYcCVvA626LIq9R0bxcUOn/ihcWm88yZlwKvPHgmb43BQqIFxOMMPt8yanr0u6ExCmR06cfHROdnOCBA==@kvack.org
X-Gm-Message-State: AOJu0Yz4ZPQu3UWClRP5PtRZ3gqATcI/lQKf39hnitL4sCkZRMEESq+Q
	YVdrIh0qSI6NA8tgfVjJlXqdXT2ytlvH/tuaoEvhc8+UyUSCh5NfkO97Vk+5Xg5VWw==
X-Gm-Gg: ATEYQzzETKBZ+eefSeIy3U5Iie0PhR83G9LpdAAglITnmgsIJX8saZHTVO195Rpc4+i
	bhQorxCubq5nG3desqlp4GmtmZe8sWgucc6bE28zNjHKn8MTcHO0IRNNDmeFB6qmo6XaKEXzVcF
	FzPG5IVu36h6JjO/QISxYbhzbb24YeqOLuJae2rleS15TGTjkve8jo6aDSeQAbIIOjoZJr+fGg3
	CjlIsrEhZ2NxBKMyD3b1/JxlkGLavELp26U4D4Fp1wo1JZnLHxQmAeCM0vAKXoejYOX2zlhInwG
	sN3iTTtHXbUheJf3k8KQPZzq/FD9W+sFf2iC03jvWaKLiTOeX1blwuVtOhPNTZf3E/VVTP/Zf2q
	kHfSDL8lFj9/uiXrcwkpJJp54HbZYSj90qX5CeDg3yW3PZyOMT8QMRJL/MJ5RxlsHQdu6cK6kEm
	UNJUAhfr7IsWiXAjcpOYuJRh3NUFlgep7Q0IWdHZdO1v71S695VmWWxD/RB9wJDZWF
X-Received: by 2002:a05:7022:5f19:b0:127:366c:8722 with SMTP id a92af1059eb24-128ed176657mr29991c88.16.1773266721865;
        Wed, 11 Mar 2026 15:05:21 -0700 (PDT)
Received: from google.com (206.238.125.34.bc.googleusercontent.com. [34.125.238.206])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128e7bffd49sm6083208c88.5.2026.03.11.15.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 15:05:21 -0700 (PDT)
Date: Wed, 11 Mar 2026 22:05:16 +0000
From: Bing Jiao <bingjiao@google.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 6/6] mm/memcontrol: Make memory.high tier-aware
Message-ID: <abHnHN74V3okn28D@google.com>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
 <20260223223830.586018-7-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260223223830.586018-7-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2BDA520002
X-Stat-Signature: a9a3835matoooqeyjakbanob8mzf95j7
X-Rspam-User: 
X-HE-Tag: 1773266723-79737
X-HE-Meta: U2FsdGVkX1+QChDrt11p5UyMaVoBU7syFqdoXCfFqfDLdzPpcDumFDxoc8kq/UteY3VpIWYArEtUvDDSLeHnAk/bABi9/sm84Kwi1W2hTNULBjYp2ljpjg8jI9w/WTd2EUh5HBW2L3y4FQGcpDPv4tjuPwtlCy7MxvD+y2lCdRVUR0/0l8EXxRg2vpLy/bLgru/KpHkEFSza1kfS2ePDkQJ/aXeIyJe4dS6O77LA3H619ZTIWcwONu1FFINodbtez1xjGBtUjtuvuKHjGIXevFIMUIiu4TSRmemp9lq3fZu8Vh4uegBvK0Cj5BEPJGWMnceBQfYEb+UTbJWusQUC5QKd644JOZK0j+OrGfO8km2GDfdv84rzA8ekJsdYoJsK4AcQG5KrUEpPU16/FU3F/a9NaOYXTYbtdAQMRL3riy6Bnri6XhtlAuS4T+lQ+ZvxfIxnGFjMo08VlquMb7E1qTTFUWB1kZwrkxbos0r1cYvMbnYIC1SChSRdVNxu//tIc37APYtZ+pO8indtsEpeIG+ZXPxkZUJc9jFEhGAaewCAOEXbEFW9TVtznj7Gb0kRYWFONCoNe+AvROOvoYHCe79vlR4TNPBZgzqfeX2qRv5lOyMr6mJzS+dM8aU1JjRQVVENQ7v+C9jRIHv1XpNrINShxvcz8SNsOUgT9S5BJrxrZktv+/iTMQGtK6eFBIYaTxSbRp0equqQK5haaUp7YLdaJo/px5Y2t+M6K6dDqknonxfRFL8Vz9jHimCB0dqDXa+ZdPncuIzw4cBnDFyUxZ/CVonhTTM6rSuE/9MtW1NzNk+fJJMxCLoWX02UZgGwhIqIlHFPtoPm+7wIw+G5FNMyxFkdCeXBv0wOLf9DFtSoINUvBF0q6uGiDJ33D20zko5SGj+mn7WHDgjTce0z5+fPUEMfwh0TXzLAwA8cw8gxO+III8zhFU8l6kivDWTj+t4To81Ob1NFboWysK+
 CqMdJN2p
 CmaB951RAmi1DtvfbB+ltYVULQ6Zw9px8cCq1e57WCdjKZOrMZwrkIbSAX0l3UU1faZnF20FWDFG0Xyv1cS0Mw16RXLWO+VnmXq8QgU/CdRG5HGo09achyIJd8mXsVqi8sj5oNuyYNR/CFPfVUR92VBn3OyUkZsC66YnXVimCbPWU9ElMDlqncoVr4Vm2FzODfEUDEfwl0DfeifXhSTCGS0X00p4b+4RUle/sambhYmHBYiVDgMS02nSWZbZoRrI+FD8MwvV+5DuLwQ5kO780gEvhUxFEES7dBpngYIQuh6ZkvvrDU5jSH2QR156xfHR2YLn5C0Lo/koGowK+234lmGyHRKSwp3QvOZhcb/xeYjDUzGKRofm83eGy0dXxkP6v6Q1pnWiPcvUOdVUEOs72Vmx3sPU5ZLhhc0yL6BE83/E5vXCmrPLpYqBDMNOG8KsNJDiBGCc6jzUFFPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 02:38:29PM -0800, Joshua Hahn wrote:
> @@ -4485,15 +4527,22 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>  		return err;
>
>  	page_counter_set_high(&memcg->memory, high);
> +	toptier_high = page_counter_toptier_high(&memcg->memory);
>
>  	if (of->file->f_flags & O_NONBLOCK)
>  		goto out;
>
>  	for (;;) {
>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
> +		unsigned long toptier_pages = mem_cgroup_toptier_usage(memcg);
>  		unsigned long reclaimed;
> +		unsigned long to_free;
> +		nodemask_t toptier_nodes, *reclaim_nodes;
> +		bool mem_high_ok = nr_pages <= high;
> +		bool toptier_high_ok = !(tier_aware_memcg_limits &&
> +					 toptier_pages > toptier_high);
>
> -		if (nr_pages <= high)
> +		if (mem_high_ok && toptier_high_ok)
>  			break;
>
>  		if (signal_pending(current))
> @@ -4505,8 +4554,17 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>  			continue;
>  		}
>
> -		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
> +		mt_get_toptier_nodemask(&toptier_nodes, NULL);
> +		if (mem_high_ok && !toptier_high_ok) {
> +			reclaim_nodes = &toptier_nodes;
> +			to_free = toptier_pages - toptier_high;
> +		} else {
> +			reclaim_nodes = NULL;
> +			to_free = nr_pages - high;
> +		}
> +		reclaimed = try_to_free_mem_cgroup_pages(memcg, to_free,
> +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> +					NULL, reclaim_nodes);
>
>  		if (!reclaimed && !nr_retries--)
>  			break;

Hi Joshua, thanks for the patch.

I have a concern regarding the system behavior when both the total
memory.high limit and the new toptier_high limit are breached.

If both mem_high_ok and toptier_high are false, memory_high_write()
invokes try_to_free_mem_cgroup_pages() with reclaim_nodes set to NULL
to target all nodes. Under these conditions, the reclaimer might attempt
to satisfy the target bytes by demoting pages from the top-tier to lower
tiers. While this fulfills the toptier_high requirement, it fails to
reduce the total memory charge for the cgroup because the counter tracks
the sum across all tiers. Consequently, since the total memory usage
remains unchanged, the reclaimer will likely become trapped in the loop
until it reaches MAX_RECLAIM_RETRIES and other situations (e.g.,
both !reclaimed && !nr_retries–), leading to excessive CPU consumption
without successfully bringing the cgroup below its total memory limit,
or causing all top-tier pages demoted to far-tier, or causing premature
OOM kills.

Given your tier-aware memcg limits, I think it is better to reclaim from
lower tiers to swap to satisfy mem_high_ok by setting the allowed nodemask
to far-tier nodes. Then demote pages from top tiers to ensure
toptier_high is okay. This also prevents reclaiming pages directly from
top tiers to swap and ensures that demotion actually contributes to
reaching the targeted memory state without unnecessary performance
penalties.

To address the issue where a memcg exceeds its total limit and demotion
cannot help to relief the memory memcg pressure, I am considering to
introduce a reclaim_options setting that prevents page demotion by
setting sc.no_demote = 1. I have a local patch for this and am preparing
it for submission.

Please let me know if I have misunderstood any part of your
implementation or if you see any issues with this proposed adjustment.

Best,
Bing


