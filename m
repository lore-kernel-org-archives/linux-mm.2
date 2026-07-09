Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF75C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EE56B00A7; Thu,  9 Jul 2026 11:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF536B00A9; Thu,  9 Jul 2026 11:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD17D6B00AD; Thu,  9 Jul 2026 11:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5AEE6B00A7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:04:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42026A01DD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:04:29 +0000 (UTC)
X-FDA: 84969559458.02.A3FA7CD
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 37CBF18001E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:04:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cJno6zVQ;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.161.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783609467;
	b=IGhjDWlNTARpWvOOAN7chUHcU0cg2YGrx5t6KO0dnC+A9MvoK2owtKjxESnbBzbhjOiJHz
	3ACfvYR5NqNrSyaqoWuVr0AkM5Km6VYOz5DHqHeODSg2JV5+bliiGFBbX22IqXfEO1sIx2
	rqP+JeffIE3zPXzVfUNatbXAwpSc5R0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cJno6zVQ;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.161.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783609467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2q8Czx79ilwPj1ckt21CqhzkvzJ8d/ykcAORqubNh4=;
	b=6SdaaNaC5EsWZhGzl/6a5hcuaUSdq3zi+Wkibc/PKQfD01YKiyoAramZH99T9Oy0fjOvSN
	frvDMCYm945Iv9Gsw/NxD1gr4fd30VRi/kqnGkFt6V1gm1iEzy/ZQlJdfB99MsRcJQhBZ1
	bWeaxLF2uu/y1nHx2wZS0+bebJ+yEhk=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a168dc590cso14216eaf.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783609466; x=1784214266; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C2q8Czx79ilwPj1ckt21CqhzkvzJ8d/ykcAORqubNh4=;
        b=cJno6zVQMdalvp2/BvTpC7iekZVkuefjin2I0Sq12Pl/SQRLBT/njl6Huf8ehwZJbU
         wx/kLv+jls/j9GkNtLcMSCG8P/WaIfZd6CXc9ZeSiL65aPrVEV5qm3yY1T9ypJaE4ieh
         CK4INYTxI239s2zO8RU+TS+kakKCtVrkk6h7/CMpSnohlZ4YDOvZHFfqsVShulcQ4TQL
         mO5NjCeHiF9DXeFg38Dea4u/thzo6km94xkRwKYNp9J8G58WXT5CLfCNOzdmFlVb4Sly
         13uwyCpeqO3DhBSkPcXgUwMOVk/e7+z0KB9/owSCzHesa9OXHK5K53q17rVY4PoP3h4s
         tw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609466; x=1784214266;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C2q8Czx79ilwPj1ckt21CqhzkvzJ8d/ykcAORqubNh4=;
        b=MYvldwfi3pVyWzitxnIynq4flONDhX5hsWSaz+Fan2Jt7vhFdkia+KKW2rt5BLcGq6
         zzDiu7Npm3Nqq+sELLFmSqCE5oNg+QJQMAP2ggl+HnJNvoSOOIo6xnD6djXppxVK8Kjr
         7azGoan5wEEkHj3r4rQmzkWyfXNh0w2NwxPFfP2DPFqCaUAb0rx/8FPRBMGfFaZ7byXD
         MtVOCYv5ZclosljrVwNzducG7z9GZvyLt0rZfT8xBF23OHPuIkf+9M/zk5k48M8YnN7Z
         /sttgYpTiUiX86PK83c72Pi3YgP/5Zlcr/MDAP2ECzBHdVOMAqRUFs/FHb7PLrBTdBda
         EPzQ==
X-Forwarded-Encrypted: i=1; AFNElJ8+E3qLOzYOXYMLhR+gcPzo6AeicovhPB/BeTjRDeYL13bVvVNUP6pZJQVq4jjkQlbcGp2BV7tHiQ==@kvack.org
X-Gm-Message-State: AOJu0YwRSuSKCct2k07plhYWF582PujW5Zr3OIFs+SZUk2O6OXIUnfjR
	nnakmLirXW0gLPiKls7rmVksyCTW4G57ontskmFNOuOVb9gCeOz4d0BrgPDI3JoWSHE=
X-Gm-Gg: AfdE7ckubgt6jJYgppgQOjQo9VIDtoG5xO5XvwrXjB84Bd+gXMz3/pVI7FUBuT8DY3H
	zS2sTZWvSt6c8ylEqGdHkJO1ft0mfq3RNHfzMuXogDsicqdpMX8mumMALJoijHSpEe+sfLmGdUY
	tZLED0W6/9PjsuTEmVQFkBnmko7yDaDM7RmH/E6jGt3nsF02+CiTt2OA6KC5hCU/ohIMFP9eFyV
	dnEf1zrt8K0qQUh0pha/vBObCgr9GpvcjT9w5qelYtvM1K7AQU1nX1fOppadeidGD6w/PU6Jj63
	pvPwDJJIQc+zv3G0PRuXV+cYD82kxcrUzPJY1p7dBxxYH6KcAmLtnUg3vfsvidOLTrYzX+IRT1d
	EbRbf8EIrCrHmAGOmhrMXf8+F2JZ73ZNbGqPGKFt7T3gf97IsntXczwD3cYT0F+7W/lmC3EhkrM
	w+rYaUJzubgHw=
X-Received: by 2002:a05:6820:2007:b0:6a1:189a:daf1 with SMTP id 006d021491bc7-6a36d85f68amr6255352eaf.4.1783609466197;
        Thu, 09 Jul 2026 08:04:26 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90cbd6c9sm1674520885a.33.2026.07.09.08.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:04:25 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:04:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Barry Song <baohua@kernel.org>, Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [RFC PATCH v2 2/3] mm: distinguish large folio swap allocation
 failures
Message-ID: <ak-4d67hVnC2_BBH@cmpxchg.org>
References: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
 <20260709145124.764807-3-xueyuan.chen21@gmail.com>
 <ak-3r4i2qdejYzSP@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak-3r4i2qdejYzSP@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37CBF18001E
X-Stat-Signature: fhdoo5k8rxkdsow85gkip9aqsn45amdg
X-HE-Tag: 1783609467-626470
X-HE-Meta: U2FsdGVkX18wlDg1RlYeUmUXEt5ca37zbWgi7Lw/2XJenAd54NdXyzvS+I+2FY8zOLXG+/ZnpZQ6qICRzBerBne8gmiRwhlBnR0KZq8ePMxq//7Y3rAsY0Y/nLtdY5Dn+2JfKezZM0GuD+HkKleDbC/Zwh51LU6KLx0v60xzXtG3kMZGFP6oRZOJs6hyrVMqDFMd1ulEbwD4zFi6Zz5nfrz1Pk0cKmLbmI7G+0AAljKku/CkQyMsKeen8l6d1Wm6HZg3xcg6HjmnhtEwFpa4fSMXnbZaOf49H13k+LxPdUtHOHcr2fkk3m+lDh+IdSJAf+jlJY6nn5R6CoZvrI/EOICDGTdOTDwZGs1vov6aqoTO/3GRA7ayJ6yv8Wo+SCedpG/5HZN4F2xA8kIDchGlh0aO9AEIPDH0S7j4M+7e2xC2EXc0QsGIe7lHyJnTdGii449Z49ZKts9rCNXRs7sY7wfYvoTyo4P8bHpDjXdPKy9sZfuUxie9yaP1mXnxPUBB4SN0aIgBoPDly8p9c3bjm3XFy7eE1xS4SY8MGtN0Usn9yZKoSk2IH3XLAOi8lOIzvCoHo6ExOs1aTGNMskgnz/4uUWXviLlQwScDO3ke/YF3lKa70pzyvb9A72E4lDqfb7xuKfZHy4Eq0z0TaQArizwWcAbgM2yprSP9gWjnuNvquUBpHjf01AxHcfbu21P99mOipt0OY43dZqzkAzIqPZNclBSI4e8ZSLG5PM2NOqAKGa9qly8VpkM7O9RqHsSEz2JJhCmIuHmwVSI2H3Iey+TEY2EFwKN3GUnHxKEu9yWDMQJRvah/vlFh+oJGaotDO7jYlqR6X7fpqi5sxUuMD6jpJcZhrJ2VC71t/PybrMtaDcDQ5w7+xI0I2b1LbiThNexcoYuoMTJ3gokcSVL2lj8hZMavIO9OwVMv5hpdIstgbf5399x/6IRqwiRqfAalSIWqygboIq+SJYMu+fS
 yco8LCpO
 6tBIc258OXUNwyLwrkwu6eH/Tbb2jQwAHSv9dF2tKst28iBjc9Spg8BguqY1BAyjsNKNkI1RismySj4MirS+3OSX0HJN2N2kgICixwticjShzY0pqRwavDVYgzdyRBQ9d4NxKOPekBM3zicH0iquDkLdRaYpt92O13y4W0zmD4ekttqdM0g4Tu6AUWVpLH6hZlO5jXHbRpjZgvqJZDPftLK4mXoQWY1h/3OMxEkMH01zgZ21TcmOH6bvHqo+rVifU/kW08do70WIZBVRG6bYjMt8LtOp6Dsq6zavgiXt84p54AlW4BiextUwHkr1rQczbuRN0L04A3OMjG2HQH4wn+jV6yRpDXyNIdgf3V2paXF8VGtb0iDnTO668RRCDzpqRYhHo7/qCQ1FmUnDoA7PX3ig/WvQJDakB9wD7VviF2DbjnCsSMrevlRCvk2f7BFP4ilALwLB8+fmF5rCj8cpLYhOBnu8jbY7dHF3TPko4eFBp5mjX/g0O54mgVTm2yjINSkv7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 11:01:12AM -0400, Johannes Weiner wrote:
> On Thu, Jul 09, 2026 at 10:51:23PM +0800, Xueyuan Chen wrote:
> > @@ -5550,10 +5558,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> >  
> >  	if (mem_cgroup_disabled() || do_memsw_account())
> >  		return nr_swap_pages;
> > -	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
> > -		nr_swap_pages = min_t(long, nr_swap_pages,
> > -				      READ_ONCE(memcg->swap.max) -
> > -				      page_counter_read(&memcg->swap));
> > +	nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
> 
> This hunk is unrelated to this patch. Don't mix refactor work with new
> functionality. Make the previous patch a pure refactor job (where you
> add page_counter_margin() and use it here ^), like I had proposed.

I also liked my version of mem_cgroup_get_nr_swap_pages() a bit
better. Please just use my patch, keep the From: and you can add

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

