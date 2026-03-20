Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 879DE108B8E9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9C76B0005; Fri, 20 Mar 2026 06:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2656B0088; Fri, 20 Mar 2026 06:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6C46B008A; Fri, 20 Mar 2026 06:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2F76B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:40:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69C4586864
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:40:09 +0000 (UTC)
X-FDA: 84566096538.19.908C949
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3F1B94000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:40:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D+YvyVpd;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774003207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3EfRhA4fDW6Hdtad/Pghe6EEW3AEZgUxlL1m715MFE=;
	b=6/AsOVudcVi5rudRUjT4uLAJDNvbI7DCiiivPpe066UyH6/qKdggPIv3tJE6zRkF83dQ8/
	ECxyDplFQhUIsTWNy1AKp2ct1F5cZPzgvl347ZM7uqQjERXAr6zhRC2mG79Ib55qybLTsB
	oM6DUKpA3IB4R6n6Hz8fb2fSOh3cv0Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D+YvyVpd;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774003207; a=rsa-sha256;
	cv=none;
	b=6E/SqcuD0tZiW/IxXfNU9TifPU2xbsDGPsrZZo8XbLVt0HBdxkjjUTgLr8pLh9QAv1qprX
	mpFPLhQG/2IxGz1lS43j6pSEBeNJspRqODHUh/MjRnO+Z7pXbkHp6zJCjTRw/MMfnBkJbN
	OLMCsQj0X7VIZVFFOPhX910CRtAwqwo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774003206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x3EfRhA4fDW6Hdtad/Pghe6EEW3AEZgUxlL1m715MFE=;
	b=D+YvyVpdufFFkX3ltikMY5kAMBAl1Wh+fvQAjfIu0FAgK7HidVcs+hyvRXBwXuwP0kGV3P
	iJsxFocHZTCqWOHq2QIyEKAjKMehCRzGm4PSQ64en6c6cYWBqb8Hwp0mM8YRzKeU4f9J8C
	oZInWDSYedWr1F9fO9UaFkxyu3P53tI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-6sS8x87FOYWHAU3WFYuUOA-1; Fri, 20 Mar 2026 06:40:05 -0400
X-MC-Unique: 6sS8x87FOYWHAU3WFYuUOA-1
X-Mimecast-MFC-AGG-ID: 6sS8x87FOYWHAU3WFYuUOA_1774003204
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aad5fec175so87605675ad.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774003204; x=1774608004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x3EfRhA4fDW6Hdtad/Pghe6EEW3AEZgUxlL1m715MFE=;
        b=qAsC67o4kH9Ro5QfKPH0kqwmPXN3al7e2Lvye5v45m0Ng7U9YJD18AN7LlKOnxX4mc
         PoTTwS33ULX2h0uz3VKVrjFn1ty7b69ynD/02Gf7S9cM1NtqpPCrE8vuW0pFYtuVtj/E
         p3PiispDBftUnN4i+LUy5Y0JbzNLD4gu94jvwZspxlXr06NnI2Ovs+ggaRQOMHTAfkER
         PTeqNK2LQrFZS1xTCyIWq3Whu6E8wIuLIL1UYaOiiaaYIkLlskvaxxgERpxgCv1IPW2n
         QyqGHLMj8cmlfCE/oPDbkW37LyP92wd0q2S1tCCKOEmAs14HaNDdqzjVrJ3IAV9R1S9x
         htoA==
X-Forwarded-Encrypted: i=1; AJvYcCV3Jx5ghdBydxbcH2itwHhR0Q15XZrVzqAF2pAA7NpgfQyzWk5hJcCOnWIbXE20Zkc0/Xmw7/hzjw==@kvack.org
X-Gm-Message-State: AOJu0YwVkz5LFGnWxk9RD1jqjNoz4wjZG3FBee8PjnNmZMdQ2l16fpFp
	NHU40U1cS8EHL+lmlc3LNKWjfWti3IzeJmNSRP20eH+Ig0xhiOnAh0XoDtGMSroIZZ26BvZ0pNr
	A43WLw2q8UDOcil81+URz3xL6OtKkzegafKeovgsaYRbNL9QsnjYc
X-Gm-Gg: ATEYQzyYdLRmu570kjmgaW0oZQkYHaKTxUH9Zltxf+/bZh2NOMmlZiPkSpZn4KBU6/s
	qIU4goCnQkbn8hMk7n012JxO61b7IoZnKH9L0GT9TpdoQGiO5LSG/OWNnbUrM6/PzaZ/ZKUm6vz
	VFSqmgJNeauis9NvaoqRY9PwjVFGR3UDj+OC8BxJwVB5SOx35+OgrvnKbLsVfzf7/Oe10K8YKCw
	WrGLw+eL/4KqhSrYivw+DiENhZkgwEfewhdZh5ipRCvJZ7pPPBHxV/H8w3f8a/rsdmncAmRkowf
	ZjTiSa/qRdgBvLprE8ag0sfS0tiptT2/m6tk5aLbQf76V9It8X2WiduYsCBQAzxaRsduMNazLD+
	9bDu3tGgxdApYlAmjyw==
X-Received: by 2002:a17:903:acb:b0:2b0:44da:6245 with SMTP id d9443c01a7336-2b082797679mr24677855ad.31.1774003204413;
        Fri, 20 Mar 2026 03:40:04 -0700 (PDT)
X-Received: by 2002:a17:903:acb:b0:2b0:44da:6245 with SMTP id d9443c01a7336-2b082797679mr24677495ad.31.1774003203994;
        Fri, 20 Mar 2026 03:40:03 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083679867sm23410205ad.65.2026.03.20.03.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 03:40:03 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:40:00 +0800
From: Li Wang <liwang@redhat.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH 1/7] memcg: Scale up vmstats flush threshold with
 log2(nums_possible_cpus)
Message-ID: <ab0kAE7mJkEL9kWb@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
 <20260319173752.1472864-2-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260319173752.1472864-2-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HPcUVZWutg3JMkwds0tBGbICMoTZlmYSp2tpYxHpTlc_1774003204
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F1B94000C
X-Rspamd-Server: rspam08
X-Stat-Signature: 15rs66ognhzi7p61s1w3g587m8qm37if
X-HE-Tag: 1774003207-413458
X-HE-Meta: U2FsdGVkX189LE8haqx4iuxAmVJWEnNO/KPg8NEfIrFw9I3mkwqHTjR1wPa53F/EjLO92SvxPP//M4zuk1OO6VLUe01AAfeUcacpnts4SRkELpndpACuPdOUMksjAEutV+7txRWezwGj1WUqE5cl0F+ajSyKzcrONfrkp1/Eh3x54yF1BRfgKFJ/z0UZ1u6ng3oik1bTqEY+WiBSI7Gg6p6dDTI2uYcZ4mL523dp/6pZclhkJCuol+OwdYPtap9EFOZJduEC+R5Px8ELpWZhNMLFfcd4BPz/VURz1XgDgaOANpYFyH+mcAMl664BOUjxSvcIF3jPbDOQpBmxdLWOqOY9pBJRdgfeVuKb5wBVZkumut0a5FAKmafRUKIPX8Pxu3CYZ7JC4JiDSxpBK9F4R83KrmCDSXPDfrhLakmsaBsrBiQjBo7Y+H6qa3ySZgc69cobXAKWodKjkm6vu0SDqUX/OK8BU6qgpnRfiLen/XH/9KZ8RTdQfJ/2BJHwdSSeRIP+XVsLdg15sAZs2lmsSLCqbJbl/T3XZEpz6EeL1DiYDdwTl0xWK1aYCafR/3lwJKqsimiu4Ydr53JY6+MKEQlYQUyMVEWxkRi9zZoJkDcD7kUmdliOxktHplYm3UBY7YhxGvPpI3o2OfTW5Wkh1ip0qYpw6ZzsfaedxVLtbtfoU0tS4ORrBgpxFADGo+Hzf2YHYD0pj5fOcq7KQF7TBNz0Ozm4WG2v+ThgLjeGP/6Dq23CIeFkdJJf2CLiVJWcM8MZVCr7Yp1kS6u1WUrncFXEmU5AhvSTRQBKN9VOCCaO8iWCwPVqtAkz9M4YjqfomvyxOkv5ELp8BevdjsfIvE0eF7oe7sjEnrkNqvYv+QSg/E6sKRSxhTbLEoXY+i2KDamUDM8cUvwHfEWrFzD3A8da+YA+cbosHAe83HcQyeMwUxD6jPLqz0hGMj4162yLGVYY4zxAM0H97mLqWcY
 xMVyBSvd
 0twhZD2z2OlTlA0+SrGKVzY4Y0jRLRvY3CYRkuBVfM3ZcE5rBLRJ5kwxvEKP3Jku+LwxUUaXgwdmqFmfDg7rYzNTQX68bvWZ44YAJ3GCfPTH85/tCFOgHfRX6pEeKSc/GTfAkoAO3Pi/6ROKoPhqfxY5bPQHkxm/wJCQtnI2jS8gJTk/b8dJGEL/Spg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 01:37:46PM -0400, Waiman Long wrote:
> The vmstats flush threshold currently increases linearly with the
> number of online CPUs. As the number of CPUs increases over time, it
> will become increasingly difficult to meet the threshold and update the
> vmstats data in a timely manner. These days, systems with hundreds of
> CPUs or even thousands of them are becoming more common.
> 
> For example, the test_memcg_sock test of test_memcontrol always fails
> when running on an arm64 system with 128 CPUs. It is because the
> threshold is now 64*128 = 8192. With 4k page size, it needs changes in
> 32 MB of memory. It will be even worse with larger page size like 64k.
> 
> To make the output of memory.stat more correct, it is better to
> scale up the threshold logarithmically instead of linearly with the
> number of CPUs. With the log2 scale, we can use the possibly larger
> num_possible_cpus() instead of num_online_cpus() which may change at
> run time.
> 
> Although there is supposed to be a periodic and asynchronous flush of
> vmstats every 2 seconds, the actual time lag between succesive runs
> can actually vary quite a bit. In fact, I have seen time lags of up
> to 10s of seconds in some cases. So we couldn't too rely on the hope
> that there will be an asynchronous vmstats flush every 2 seconds. This
> may be something we need to look into.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  mm/memcontrol.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 772bac21d155..8d4ede72f05c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -548,20 +548,20 @@ struct memcg_vmstats {
>   *    rstat update tree grow unbounded.
>   *
>   * 2) Flush the stats synchronously on reader side only when there are more than
> - *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimization
> - *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpus) but
> - *    only for 2 seconds due to (1).
> + *    (MEMCG_CHARGE_BATCH * (ilog2(nr_cpus) + 1)) update events. Though this
> + *    optimization will let stats be out of sync by up to that amount but only
> + *    for 2 seconds due to (1).
>   */
>  static void flush_memcg_stats_dwork(struct work_struct *w);
>  static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
>  static u64 flush_last_time;
> +static int vmstats_flush_threshold __ro_after_init;
>  
>  #define FLUSH_TIME (2UL*HZ)
>  
>  static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
>  {
> -	return atomic_read(&vmstats->stats_updates) >
> -		MEMCG_CHARGE_BATCH * num_online_cpus();
> +	return atomic_read(&vmstats->stats_updates) > vmstats_flush_threshold;
>  }
>  
>  static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
> @@ -5191,6 +5191,13 @@ int __init mem_cgroup_init(void)
>  
>  	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
>  				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
> +	/*
> +	 * Logarithmically scale up vmstats flush threshold with the number
> +	 * of CPUs.
> +	 * N.B. ilog2(1) = 0.
> +	 */
> +	vmstats_flush_threshold = MEMCG_CHARGE_BATCH *
> +				  (ilog2(num_possible_cpus()) + 1);

Changing the threashold from linearly to logarithmically looks smarter,
but my concern is that, on large systems (hundreds/thousands of CPUs),
the threshold drops dramatically.

For example, 1024 CPUs it goes from 65536 (256MB) to only 704 (2.7MB),
that's almost 100x. Could this potentially raise a performance issue
as frequently read 'memory.stat' on a heavily loaded system?

Maybe go with MEMCG_CHARGE_BATCH * int_sqrt(num_possible_cpus()),
which sits between linear and log2?

-- 
Regards,
Li Wang


