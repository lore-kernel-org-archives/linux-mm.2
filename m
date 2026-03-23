Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A66F46102
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBF76B0005; Mon, 23 Mar 2026 08:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACD26B0088; Mon, 23 Mar 2026 08:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B016B0089; Mon, 23 Mar 2026 08:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A76056B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:46:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A1E2160B76
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:46:51 +0000 (UTC)
X-FDA: 84577302222.09.C18D5DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2141340014
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:46:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GpDFlzck;
	spf=pass (imf01.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774270009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zj+HJ3NHVe31Ua9iuOX+I5shCryiTmPAEr1rzKm60IA=;
	b=qYLH7TAAyWBdv/KuU8wDyduTZKM0xOSiWRSe5G6dbY3rhVs4WlXOxpia6++y6/9DjKDW/R
	nKj3krFVRKLX9dB/qOIYEArDHdLxEW4DaZGDM+8uGJppqTUqqvcEvhozUhqtdtt+vKOgYt
	ZGwnSssOIV/aPwv3QIbh6Ry3fHoGkYM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774270009; a=rsa-sha256;
	cv=none;
	b=f5dYttbWFkC6xRN218tgf+RNfjSe8kBDa/54gdAuJb4Kac5Lg5hRK3dI/26yzMc2/PnrZz
	P72pJ/7XCguGgOZamRjePL6BU310xmSlTDtwX0ZHbAKa+belYe1PUUoLgOxvmgz9RGLm0+
	E3HOptvSj9RuTnmUHygSgEMaPxG2eYs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GpDFlzck;
	spf=pass (imf01.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774270008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zj+HJ3NHVe31Ua9iuOX+I5shCryiTmPAEr1rzKm60IA=;
	b=GpDFlzckhDJYw0kBL7A5QlcyrB+YaOEYEswf4or1TWT+mxM8Web6z5Ujr0Qd92gyknZ9uy
	JalQM7zO4Atj76iqh6i63K8qTZAgBrbMYzjuNNbdV92RX6dHOYBGPkJRFKrm7Lf2Rd65jZ
	QHCUQEFJ8jZ6Q8iraZROCmTJLmqG6VM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-85KMtD68NA-Tkg013tsy-Q-1; Mon, 23 Mar 2026 08:46:47 -0400
X-MC-Unique: 85KMtD68NA-Tkg013tsy-Q-1
X-Mimecast-MFC-AGG-ID: 85KMtD68NA-Tkg013tsy-Q_1774270006
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b62da7602a0so1960268a12.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774270006; x=1774874806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zj+HJ3NHVe31Ua9iuOX+I5shCryiTmPAEr1rzKm60IA=;
        b=BKQJMfIfvpX3pFVvRDugMXHTpihZotEr5nVHN55lHFxu2RxjvVri2JMOV1x263V1t4
         UygPiQjEwH8bNSRb8BYsJZomGMMrBDptZIcC9YyxT4du/4E2acyA63syA3EUQ7LZKSzp
         p5FXB43c5BsoW0wDxiuFYSiET4jrU6TWYIEJvnzlwZctx96GTWqR5L3rLkSh5I531+zc
         fYBASDBZS+Vsd0+mxdUBep9nS7EzuR2Ms64s2Geg6n5Agsf3p3i+29VvgGl5wRYvC1ld
         r9bDlGAbM3UutCD8Ex8jHuYRFirTbiXNZLx7QO/8/sMPY+ZhPCKit8Z0QPwREYsOCE0I
         7OYw==
X-Forwarded-Encrypted: i=1; AJvYcCWtvpAjgmvzL0izLwM3xxJN9KQ6seFSrdamce3Pqk+H5WGpnsxa0g+MFhVtVZiIo+eiPQCf6cnC/A==@kvack.org
X-Gm-Message-State: AOJu0YzmKVs9237TaglYFGekeUxmgQMTYxe9Pha6LAfd4zrVgWOH0Bsy
	qu1M5Lyl5XktvUij9qUrOL5S7GkQg0kEM+lLrWPmUpgXoR4p1SmT09mbDwvkU7j5t/HzKNVsgli
	77GkbsyMiADjYof3Cr3FqfTr31Lmyr9YX7mYqohaXVlhNDPxHy1rx
X-Gm-Gg: ATEYQzysDay7bPqAFO3mwr0mamFlM2x0F18qjySLvX0Wa/TwpYgFnOjsXklM4jFnj+E
	9KSt/6Z5ktMxTl+l29Q4FSmylXsJmMkuT+aClGPuWs2gvoCwJOczzzJ2LQZYwH+vTho+V8STLGE
	UUMSwK07iG+RmwgB83JkS7SBXFfW3w2q4Vzi+UMDRclewlZrIfvGJ/VZOexzyAIx1c4fQVDVwtS
	c37Fd2N9vKQOxkBnH9oe0LbaAIcgKhX6FwxKXr5ccOj5hBhHll5/ERQUDDQust55n8HHA3O6Slo
	mC+Nymj6K8NqJtzxBgur7/M+yam7AdGLado8XkRGepUarqL9RjjL8MU0jXnuA3sJc/f8Khzg/V+
	NehKwT06elpTtsrjzLw==
X-Received: by 2002:a05:6a00:2d1d:b0:829:7efc:fe20 with SMTP id d2e1a72fcca58-82a8c325f74mr10131676b3a.40.1774270006181;
        Mon, 23 Mar 2026 05:46:46 -0700 (PDT)
X-Received: by 2002:a05:6a00:2d1d:b0:829:7efc:fe20 with SMTP id d2e1a72fcca58-82a8c325f74mr10131638b3a.40.1774270005733;
        Mon, 23 Mar 2026 05:46:45 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03aa5a9bsm9609699b3a.8.2026.03.23.05.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:46:44 -0700 (PDT)
Date: Mon, 23 Mar 2026 20:46:42 +0800
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
Subject: Re: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with
 int_sqrt(nr_cpus+2)
Message-ID: <acE2MoIZ0pl7U7PX@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-2-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260320204241.1613861-2-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R_N3I10Q3Ek9dLfDS_D6KAa054u7YZV95gwZXc9msXI_1774270006
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: w3tzkkh9jrqfrpbdwwmjxmcyo6zwuemk
X-Rspam-User: 
X-Rspamd-Queue-Id: 2141340014
X-Rspamd-Server: rspam12
X-HE-Tag: 1774270008-784954
X-HE-Meta: U2FsdGVkX1/MnCLFg3rz4qpp7gyBgrKS8dR2YlcLCUpUL+TtxOdqmlNb1mke/+joQCl1CEHnLLIUIxnFMZJ4KwMAZV1rrR6qt00Py/8EGsZO1NCrZfWgHcTp1YUIqyshAFI9wwLNF2Wpo+l7a6SQH2QC9IgZJ8kzNsrI8riQ/7gPuPZbgdHdQka/gyzIE6f+7eaEd4wylrDvUQ/Xq7K4rOdkapTeP+4d82hdJ3ZzyV99ocIpiOwzBV/+nWwBxYFA7GUNfIkpzdAhBr1gIscC7lx0DQTX16mIpwebsljPdPOo7vPZh3CkSocpAfXnpi/aXrgZ1hA5UHGGUn7873a2lPmo9Hha2GJGoWUPF7J0VNMfVU3Ls1xuiOankFkLMJxk1HZaENv4nT+Dkyjjq426WBH1DBq/55jqjeX6eoFw99R5irtyK+vICmtxrJJyWJXM8Wq04ejVkl5P9YfaQHa+QIQSK0gZDSDy6QmM7yvEM/f9nOLi5qLbuSUTeWOwC+53LyCYcy/ECRCkoBIJ0OuOH4DEXwVgVoPypjeJzn166B7XRRzUsoR6jteXpQ2HEjI44mPyRm8yotXhkGtMk1BZUh9KwYoy2KZRrbKAgqWNL4xa8NINdzNO8hYX3h6L4qWyOkD1STUY7mkz4OCAsJOvhGUlMuWmmgvuOW2Kjr+wUu17lsBm+bQL95cVA7GmuOQyTcfioqlFffyv9fxYGYPqUAeEhVtXVQr7mF+jASoGp2Yg1PPQ79WR9gd4EoyrHiH38hiYuYwOb8DRfOe4dsYTs3wJnh4jATIJkKAGubRvOImEirE+XwG6iVcxb1G7EnIoO1uzuWZszlxGI6QiybfTJpBO84n+YShF+ACbcxj8jsNgYD9xrxxsQ7KV2HBtWkVsMtNzTYQGqFdtEyS47M+NGvTNHPjdBwH056p3tCXfV4xcleXPKUCT9Fs/MsAY8eSOUL0+QMbi/KEXgUZnoK4
 crn9IcJN
 uWpIoCwP5Rv9AbqLAURR0vHwZOGZC3kZPs57o5v0YBhedHJgE4WmtVce9qQZsIL69w2M1lywh/O7iWcEJwv9+JNm8ogcL8CDtUGux7HafSCTSnfELEJ9N07RpIIfUVEzzbFjBDTBrd88R81V2HjSbIB/F/NhvYhNjBaahzdT1jIo/GR8vDTd12gOIAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 04:42:35PM -0400, Waiman Long wrote:
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
> To make the output of memory.stat more correct, it is better to scale
> up the threshold slower than linearly with the number of CPUs. The
> int_sqrt() function is a good compromise as suggested by Li Wang [1].
> An extra 2 is added to make sure that we will double the threshold for
> a 2-core system. The increase will be slower after that.
> 
> With the int_sqrt() scale, we can use the possibly larger
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
> [1] https://lore.kernel.org/lkml/ab0kAE7mJkEL9kWb@redhat.com/
> 
> Suggested-by: Li Wang <liwang@redhat.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  mm/memcontrol.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 772bac21d155..cc1fc0f5aeea 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -548,20 +548,20 @@ struct memcg_vmstats {
>   *    rstat update tree grow unbounded.
>   *
>   * 2) Flush the stats synchronously on reader side only when there are more than
> - *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimization
> - *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpus) but
> - *    only for 2 seconds due to (1).
> + *    (MEMCG_CHARGE_BATCH * int_sqrt(nr_cpus+2)) update events. Though this
> + *    optimization will let stats be out of sync by up to that amount. This is
> + *    supposed to last for up to 2 seconds due to (1).
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
> @@ -5191,6 +5191,14 @@ int __init mem_cgroup_init(void)
>  
>  	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
>  				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
> +	/*
> +	 * Scale up vmstats flush threshold with int_sqrt(nr_cpus+2). The extra
> +	 * 2 constant is to make sure that the threshold is double for a 2-core
> +	 * system. After that, it will increase by MEMCG_CHARGE_BATCH when the
> +	 * number of the CPUs reaches the next (2^n - 2) value.
> +	 */
> +	vmstats_flush_threshold = MEMCG_CHARGE_BATCH *
> +				  (int_sqrt(num_possible_cpus() + 2));
>  
>  	return 0;
>  }

Reviewed-by: Li Wang <liwang@redhat.com>

-- 
Regards,
Li Wang


