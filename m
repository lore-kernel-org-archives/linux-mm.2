Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E08E64002
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 09:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397CB6B0088; Sun,  5 Apr 2026 05:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F736B0089; Sun,  5 Apr 2026 05:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285F36B008A; Sun,  5 Apr 2026 05:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 190396B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 05:33:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD0F8C313B
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 09:33:00 +0000 (UTC)
X-FDA: 84623988120.23.8CAE989
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC8A014000E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 09:32:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f+xPGqq8;
	spf=pass (imf23.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775381579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZwR1TIu4jDce0hEncRINH/njuTEZeMfTqNu8l/0YXY=;
	b=vcBP2dujpUTDTqDzHU9uPH0YJ9WMlHWpLHWaJvj2LWzXHPu1JM9xFflYluDpwnTt10DDqI
	h/2fMG1ISSEM7wlKro45Z3fzMwSnsXWD4pHyR1tvtL5ATt/svIZF+tE+pZuSw/E0eQfGvg
	TkSrkXoHDxpmzUa1qt596GYJEbpvorI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775381579; a=rsa-sha256;
	cv=none;
	b=8K88HCmW2KH/fAbUZWTysgI0vWaNI/lW+sL42BHWiyWwgadRWN57qBHao/4R2qxNehMSdJ
	P0UqUSD5eB73NAsjC+JBLWREZ80kKb2PWzUv6nfMzTeRSs9SDwBKDX5TLq7rY6CQQZ2FoJ
	tdgn2KnrTWHVCTfa1XHPsO1H/OepPP0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f+xPGqq8;
	spf=pass (imf23.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-82cebbdbdccso1531745b3a.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 02:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775381578; x=1775986378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZwR1TIu4jDce0hEncRINH/njuTEZeMfTqNu8l/0YXY=;
        b=f+xPGqq8S8c0XSk13WVPNvReKarHBgu44xv+op/mswp0Xo98xhq4jlT0XcZGBh0QTa
         1FvyTP4ngx0fL3ZaZzm622HJOChgjUQ9ZyjTBwOQVpi5kJ+fFGT9EPLSyKfXM3GvHRBs
         JUze0S98fJbyrqDQxHi1Ah3m/CR5xFXJkzJIByMxkQ1R2D3CCnrUwHxdzLaF44iu+tGp
         ZTq2Uv0jXrhu++JdQcrwnJZXJZWzZ7lVLrqJ9r7E1gajBZt8+XGJjqk9svZl0Tmu+hLp
         BoeGxEoQ5HEM8Q0D7ciiI8aIqz6ECWW5GSE8K0AA8Uhz+cYj1z5q2vxx/6fJRiUnGEPq
         +A8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775381578; x=1775986378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OZwR1TIu4jDce0hEncRINH/njuTEZeMfTqNu8l/0YXY=;
        b=DuIuDUK18c38abo5ugVN+ywkaq5ZiJ1EdAGAbeOi7DeakCUDgMUq2hfDHRDTpXhz2E
         +L4zG4vSCqNv3+29OcP/xQE2/FWFl0dP+FLP7mS3c/10C3otaAPKIk1CVjYAGFF4/YTt
         B2y1aQojfCszu8dfzTLtPp/gxlfYETQHDXCMKuaLS08lTvCZmvqqQltiLfvNK75VrfkO
         GMmTwzrZGNLj6KHDSfMkBiBP6c9DZ4IpqAldSQU16REU0CAalWZuM5SH26fMyotdtliT
         G91UBmVFBHYWMxU5kbKhNBbHHy87iodftfxNy1BdEt9snOM0HB2kYna9X6STOiRLFB4q
         JRjA==
X-Forwarded-Encrypted: i=1; AJvYcCWTadkvjDIU69jKPOPqkVl/gmAXapsCyW8iGKVA9h5wTg07uNCuMdd6CUgkGNC3B8YxHcxtOzqsVw==@kvack.org
X-Gm-Message-State: AOJu0Yz4s2vsYu8ZxUpS7BTg3l0x4ZkuCvbJ5G9ndjUOT9RnBIEqxJDY
	kKwWX/1dszdglqtx1IwErVmZml0RCP7YqJ6SYDR+rTrpgk021HUVpemG
X-Gm-Gg: AeBDieuE/ewIGxH40jp0+8t16Pw70OWkU6Uxkq5q+SgpD5Nwhtf6rDIItOnPfYCGAZ1
	de0E7FNQJy7MTck9pIb+sA2pSjuccCEIkHLJ8yQERltxKeyV+BgDwZD3Z70rRIQT5m40H54EtNA
	bOx4Hm+Z/j29mhymLW7PC8P+yrAWXnc+1/SIjbLWDT1dz/CxG59uHo2fUMnamvGKIHiPb6DX17I
	KstSNSprdDwTgIiDMxUY4ifMAMS5ZpTuLsoAzoak6pwl7kV+8wtL8Hc50QscfZFS4dSGY+jM8cZ
	cUkZnB/SIayHI8AwXR1jzdQCwCG8qmzUbGTWrVaw2JF+QxcGfaBQ76ZmoNox3wF1KHLcgkV8FF5
	pVjHF0lpD26vZtMM+Am6330dtXeECb+puIo5UBxux+JwuZRN3cZ0yC2vuswkal7yOki7pUWU5o8
	vDLJ30KPheCID3VKBH6ApOMnUcxYWvM+vDELBLrThlgkvMzUk/
X-Received: by 2002:a05:6a00:340a:b0:827:2d7b:5038 with SMTP id d2e1a72fcca58-82d001e9e7amr10744846b3a.5.1775381577787;
        Sun, 05 Apr 2026 02:32:57 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:d64:6e36:31e4:3a82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c9cbf6sm11547942b3a.52.2026.04.05.02.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 02:32:57 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: baohua@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	weixugc@google.com,
	yuanchu@google.com,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator and optimize pagetypeinfo access
Date: Sun,  5 Apr 2026 17:32:24 +0800
Message-ID: <20260405093224.3892321-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260402071808.41828-1-baohua@kernel.org>
References: <20260402071808.41828-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 4x49p4tezkxxywp3x9ccrdiq59f5qkae
X-Rspamd-Queue-Id: EC8A014000E
X-Rspam-User: 
X-HE-Tag: 1775381578-806268
X-HE-Meta: U2FsdGVkX1+HQcrXZhS+fDjwddbIC21WZ/BlzqR2n3fEvz8zAfsTUiUrSQqvtT4ifp1TqwxUm9iDv0xrqAd6iImCRdDFc7AiUlz4VQIaZESw9VLmSVE9XR+IAeeGatxiNWrZ0Y05LWk4JQ/6oR+6oh1L2LUa+h1+4SnxB003xvfAx0VJXKiNjdSY0byM8p6ep76n15LgnF646Bh2XVXKq7ItsjwLWrVrPfadSUOgW/ffS3rbmMXrvXBJxCSXIfTcx9V7ZzFDfO5PYsBv0/kjbqpHokosITd8PH3dgPAVUu9tg4k4la4vmhh5DClcPtDn5UgJ788/hfAfQq6JU93YczTmaX1AG4P+eyVGDsYWvh2cSt2kfhG1ljtZuofEdG8ZqnDQLQ/ddEOQJ2FrW8qZ/u4OgDoGiFHsYI7xfR+QT3t3+GXmSObNIDkbsSG9a2ihE5wBd95b4xBd25ue6Bc4yK0D0jacACbuWviauITu4416v5XTOzZWwB4seMlTFGHTn8jh4+uaQiORGMbLa+BIGoiw6VcYCDXy8DIuml+VS0xFi/myg7vMjyC3sz472isIFd826H1bZLrgW/+vcwnEHWB18Y35eQgERfzBopQXAHcv7S5PiNliCZmuT54vWV6LUiGNxdYgoi5Nfap/1y5bdgISg4uimIbuAU4TLd6WQc265n1Ye0yNssjULEtQndzu5eIYAgj3B2ek7C9FWASdvrzTCoq26l7yDw4ZON74ck2UK3G/JW6o1swg2X2WDYz75bSBtHFKK8a0/pHTi5Ysw4+FfHm7ZMqWGO+D/uct1CanTQbtjnOUKAenfSJtFNz5GITRo9w6/xXAQop8z1Qwa6wJqUAlibCC25x/gYIr1MwIH1wP7eVe6BDGg1xHdiazwTU/QZ0bWzkEfhPTDPAcTcwd8cMIu2ZkqzjrgGKd+VyFwW7MGFqfRQ0OakmXu/4Ql+yy7PpvvW1cmDlz6IY
 dLgKXbn2
 zvoebZuB7l/RgsG30j4tLZ6fd18qgxDvdoWMB99qTGQqmxHF0KTEB8sWfXZVN8O6e0pNcPDP4G/b/7Wj2/WX8fMC72jt5bQNLTzDhwUBXyqHfvBgNO/Rj+KJqhPrCM72SnM8Q0fdbDZw+Sg/nXYgxlwoQo6rGMCrZSJMe122Lfpi5drwkIlYhWhGkaMiXJHJPyTqJmHKANcSGp8kwkF6gkeZgL/L2slfOz8ZkC8HvjICs/GPOC3FH2laPYpcbd6lLEp089JlQQ9rLRxNxGa8+6i/PUpVoDvLmKKde8BHnytMn/GVGJy5l8/tuXtZ/bQj1hyNZjUqs85jaLM5Z+1r853NR0Jjf2EAxuYeYqk3aesLkjIUZOR8u4XcgmIn/LBNwtek9hrZxKgl5aiMpkdC78Cr/FJ+mkmyM6938YjdoOPvP24uONrh9ZziUohf+MAWYjlLTSx34IHERCGzsHTruCmUlxr7AERH29KZ9c1b/aN+zf6mab7+OL4kTosCKldE31rJa2btZ8kDMXrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, Nov 28, 2025 at 11:11 AM Hongru Zhang <zhanghongru06@gmail.com> wrote:
> >
> > On mobile devices, some user-space memory management components check
> > memory pressure and fragmentation status periodically or via PSI, and
> > take actions such as killing processes or performing memory compaction
> > based on this information.
> >
> > Under high load scenarios, reading /proc/pagetypeinfo causes memory
> > management components or memory allocation/free paths to be blocked
> > for extended periods waiting for the zone lock, leading to the following
> > issues:
> > 1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on Qcom
> >    8750 platforms, reducing system real-time performance
> > 2. Memory management components being blocked for extended periods,
> >    preventing rapid acquisition of memory fragmentation information for
> >    critical memory management decisions and actions
> > 3. Increased latency in memory allocation and free paths due to prolonged
> >    zone lock contention
>
> Do you have an idea how long each seq_printf call takes?
>
> Assuming seq_printf is costly, printing while holding
> zone->lock may be suboptimal. A further optimization might be:
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 2370c6fb1fcd..f501ca2840a6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1570,6 +1570,7 @@ static int frag_show(struct seq_file *m, void *arg)
>  	return 0;
>  }
> 
> +#if 0
>  static void pagetypeinfo_showfree_print(struct seq_file *m,
>  					pg_data_t *pgdat, struct zone *zone)
>  {
> @@ -1611,6 +1612,63 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
>  		seq_putc(m, '\n');
>  	}
>  }
> +#endif
> +
> +static void pagetypeinfo_showfree_print(struct seq_file *m,
> +					pg_data_t *pgdat,
> +					struct zone *zone)
> +{
> +	unsigned long freecounts[MIGRATE_TYPES][NR_PAGE_ORDERS] = { 0 };
> +	bool overflow[MIGRATE_TYPES][NR_PAGE_ORDERS] = { 0 };
> +	int order, mtype;
> +
> +	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
> +		for (order = 0; order < NR_PAGE_ORDERS; ++order) {
> +			struct free_area *area;
> +			struct list_head *curr;
> +			unsigned long freecount = 0;
> +
> +			area = &zone->free_area[order];
> +
> +			list_for_each(curr, &area->free_list[mtype]) {
> +				/*
> +				 * Cap the free_list iteration because it might
> +				 * be really large and we are under a spinlock
> +				 * so a long time spent here could trigger a
> +				 * hard lockup detector. Anyway this is a
> +				 * debugging tool so knowing there is a handful
> +				 * of pages of this order should be more than
> +				 * sufficient.
> +				 */
> +				if (++freecount >= 100000) {
> +					overflow[mtype][order] = true;
> +					break;
> +				}
> +			}
> +			freecounts[mtype][order] = freecount;
> +			spin_unlock_irq(&zone->lock);
> +			cond_resched();
> +			spin_lock_irq(&zone->lock);
> +		}
> +	}
> +
> +	/* printing completely outside the lock */
> +	spin_unlock_irq(&zone->lock);
> +	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
> +		seq_printf(m, "Node %4d, zone %8s, type %12s ",
> +			   pgdat->node_id,
> +			   zone->name,
> +			   migratetype_names[mtype]);
> +
> +		for (order = 0; order < NR_PAGE_ORDERS; ++order) {
> +			seq_printf(m, "%s%6lu ",
> +				   overflow[mtype][order] ? ">" : "",
> +				   freecounts[mtype][order]);
> +		}
> +		seq_putc(m, '\n');
> +	}
> +	spin_lock_irq(&zone->lock);
> +}
> 
>  /* Print out the free pages at each order for each migratetype */
>  static void pagetypeinfo_showfree(struct seq_file *m, void *arg)

Yes. I included the data in [1]. This seq_printf loop costs about 5 us on my
machine. I'll look into optimizing this in the next revision.

[1] https://lore.kernel.org/linux-mm/20251201122912.348142-1-zhanghongru@xiaomi.com/

