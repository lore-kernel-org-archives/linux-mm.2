Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB63EDF04C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 07:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F896B0005; Thu, 12 Feb 2026 02:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12D86B0089; Thu, 12 Feb 2026 02:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4556B008A; Thu, 12 Feb 2026 02:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 893CC6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:08:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 389B2D701C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:08:35 +0000 (UTC)
X-FDA: 84434926590.23.BA23E82
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D06AD160002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:08:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M9QG+m1R;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770880113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6szOd8jTk+em3arREJHLemha25ur2Z/Igpvrny3vPyo=;
	b=TLM05RyHvYefVyg/MV3FObAu0vbaCPEiBxfDjThDts5G4nopl685fRrD02HcUxJzTVkTag
	TkHAg3w4g4yvjZJOJlO1QQ4sx5KkBh8mYEo7xd4TTd3z5yPzjCLUKRK2XSMq0GOtiVRPtq
	WNPQcgjewPUaMwUQEbswXagNI+nYAAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770880113; a=rsa-sha256;
	cv=none;
	b=kQxUu4orhtKzMAvJdwRb4qckOtWMS1j9f5U0X8+YUcse5VOKFRlX85id7/yjmIoYdfYO31
	qYlzQ7SD3ZVuZ+O23h1RT2d3uhuPgqUjNDLLaIoCX1wUFnws8s4YlRbEgEWhrBYXWoaTqE
	lIKJfD6kiJVCs1InRXRe5Dww9GPEXB4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M9QG+m1R;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770880112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6szOd8jTk+em3arREJHLemha25ur2Z/Igpvrny3vPyo=;
	b=M9QG+m1RUd2FMapJGH3+6MNeT1u6NVz9aXEiymG1PCNht2//fmyh25EVvaQJSOaZckYuFG
	8N5g7AJQly50LdZChbDJEwycx77GMfNmw0dPCf7TQ0oAWmlaEe2Ko6ZyqVP7ZqeXfCpPYM
	yYn3UWPdKSKhAyzyEcM97Z4+8KQIs1s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-j8iJ2SEmP-6FpcNf-FfPGQ-1; Thu, 12 Feb 2026 02:08:31 -0500
X-MC-Unique: j8iJ2SEmP-6FpcNf-FfPGQ-1
X-Mimecast-MFC-AGG-ID: j8iJ2SEmP-6FpcNf-FfPGQ_1770880110
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-480717a8ef9so14937165e9.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:08:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770880110; x=1771484910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6szOd8jTk+em3arREJHLemha25ur2Z/Igpvrny3vPyo=;
        b=JREL2JkVOG0VYL6QU8y9niPCANjucTw4/HF0rOIY4dLxH7VWVQ2yLk9c1i3TAqRBZW
         BmqFuyHbKdvLRWjBOwieBtVGoVFwHOkpcp9963yoP4gVvnuheOyQ0XJwg8j+1M+SXOAI
         Xta9c1OUaGq5/VOFvMgxyn62X6tBnYg9XcAptPlPbDNG1cr1+t/g+lJjphxVgwf+ElmU
         fLaEOLsiWmp8XiIQXqtUI/OpBbJNsWXD2wyVxDMQ+szJYCoaPIaG38hTkRsALN7d1yQM
         R5krZn6nvp+ih7wOvGg12iHQTBclXsg2JR3VvrETvfizx5sSnMiHCkfVfcT6F+GrCS9X
         XoeQ==
X-Gm-Message-State: AOJu0Yz6VhD4vun+/SsM/hJecF4jNV7VxwMeDevVWHbkJOcpHbvT2Hf0
	HhecHtWTVvpcUh8hYc6vp5XobnC8S2macAln4PjMrq9KjTMvuaxSqmYI95fegU9kx4FrzETaoVm
	qExtAd099hp73Y5TNJ+68s0EbHjoyzlfnbEmw+0mqCN1tKVmJ2xAJ
X-Gm-Gg: AZuq6aJ04DXksxh8frTByaCCDPSaL1DFtH+wDGYD+qR8BkoW5BjRI0FIFun3eMnjdar
	/RqBgGnz9IUN2OoKJexx6XSfLQWtQuIGQ3Vi37TUGqWcgwGYt2XljZkEVEzd4I3zqewoBJ/WDtk
	gxtgJvmsc0zQaEO9/o5LzwwK5/PwJg6moxfZTup+ugTQZjWzvSB1uO1ul9Xw5A0DdX1xp7AuqPl
	hqhNMh+MPQclJT0SK4jD6XfxkPxHt5CVFV1o6pFNDxxdXI/f4Wyl3/i1cepc7SxjdloNMdGdCrT
	V05zn0qr5WoN1P+12JQfrcU6JbkaXzjCnvpcorOBX6lgoymTosfA+L3KrxJDki/j37K71AgyQUI
	1zZjY8AHnCLX0SnVGMUKlF+nnnjpwgeN0H/+uObviTmJQiQ==
X-Received: by 2002:a05:600c:4e4f:b0:47d:333d:99c with SMTP id 5b1f17b1804b1-483660425a9mr18452095e9.18.1770880109529;
        Wed, 11 Feb 2026 23:08:29 -0800 (PST)
X-Received: by 2002:a05:600c:4e4f:b0:47d:333d:99c with SMTP id 5b1f17b1804b1-483660425a9mr18451585e9.18.1770880109005;
        Wed, 11 Feb 2026 23:08:29 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d989165sm119619155e9.2.2026.02.11.23.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 23:08:28 -0800 (PST)
Date: Thu, 12 Feb 2026 02:08:24 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com,
	mhocko@suse.com, rppt@kernel.org, muchun.song@linux.dev,
	zhengqi.arch@bytedance.com, rakie.kim@sk.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
	virtualization@lists.linux.dev, vbabka@suse.cz, weixugc@google.com,
	xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
	yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm: move pgscan and pgsteal to node stats
Message-ID: <20260212020724-mutt-send-email-mst@kernel.org>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-3-inwardvessel@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260212045109.255391-3-inwardvessel@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x0yV-cTwvnPCapoHlN3Nj5ujkgfIhMtJqjwNQUC2ZiQ_1770880110
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: D06AD160002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: n7duq75rjciiprhn3t1x3uca5upsoi1t
X-HE-Tag: 1770880112-14775
X-HE-Meta: U2FsdGVkX1+TrLYGrp4ccn+7BOZpKNgGmSzP7OcUgccUQQkPTIsdzpxeidj9AopCmPZG7RAhDQ7lhcqsY3pfVj+HbbUiwSDhCbSbUOCifeYYg/uVMQEpG4jJQ/Wbh7PPBw9XkfI+7TF1V3pvXEHHI+khU3QofY1gRLt7FDqP6u1/irxlXIWi0otXpbzdbpJMIpdULCc6Q2HrPY2+wSd1uC9YKoXOLqlPbJDP6sTfLv8kiI1aK2uigiVbU2NxJu91lZ1nF00ERfsBoAA0jyIV56N6L1SxAoEkjedr6RAJ5xQ4vbks0gIxRkI+uqisuOXCqQ4Y4t+CT+AiRJmVWnfb9gOW44vlSjB996rxMYfOYkHbm0BRnTtwVWPF3MJj0+R8PD+cVKnPqI2RKb/ABEvNyBEgwGhvT4ttLsZwRLfw3iRckkHMsDJ9EGUGjVWtJl4EALeTPsMW3SMoaSMgrgWECkDA49Hjq2ByevN1K73TLBZiMxPBUujNdvmlHQSDo1a7/Zv6xHm+Xb8LyaBq1k567FxIZjlGudpbzaKk2BHcyAhlbRQ+U9RPn5e1+bXNPbGuQim8Y2p/Aexbk90XUntgGT5E3efUdl4sIlXN4oprxNdSVt2/2k6hTYGrqh6sEg2v/w2+Cg59npQ1ezPZP44XScF5aDNs5x3Sp37lbIR+Y5C3GeFNbkfTUzvIjKWURVZ0BJp8j5l8uGXZcxWsrqy/lkowpta904hcWZAfJ4OmtgPpX/BqMalmaCBfrDi5VRDlakqW805yiANEt/PfDO1RVCWIiEZzLGNy6YQuWK4PZ/khkrib5DhcNzJlIZdiYlcr4tf93z8oc6YjZsopoJSfq3hGFFS6dg3Gsl7sQh7+lqgMfU74VIqtgHU8q5lsJvaeXdsarMz6nrhrp2jX28xkzleshPmTn8Sc42aLXo9unqvAwTGFX8GB8Xmpw7qHfaaa26TPzCtkL0MUbB5dH8x
 v5OtxZTg
 +hWexvZS9y05oZ0R/PWd3T2U5iBdSkO9VXaBtAzrnIWQEECHcu8uPgrYaUROz2AOxXUUd2v+rOYuOQN+DNML0cDgFL+yIYAxejs4mwTWjccwEd1mcTBNtWPl6Y6TmGcR1K7izGdh0lsPBlz/z14z/UER+KJiYSkNPFRPC9xvCBqxIrK2MRu43QudJpWYjoc6vtVz15I/35yWPdb4g14GXjC3YZtbOORjxVO9n5efYhUU8EDmVPcycF8xQB3ojLWu0NP5J4MJeR0e5ZhYjIN6OfVFK1Ai8N4kRAGDQCI+epeiOdvjnuiO1dhaKorKbVJEctwzi89lcfPiRfjYE7lHnk4UqLGjQV+fk4BlsZa/SMB0t2Y2kOoA72zuCS19gUi++WZYuDVRW8Z6yY4gotcHULvxPPsYPsINuWvii6VX1Y9KykwW3EtCWI/8oLAGUw2m0Zh7nFMopLlseLXUEnsRsMtxobkRHhp8epmgGGjUnJMBLxdA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 08:51:09PM -0800, JP Kobryn wrote:
> It would be useful to narrow down reclaim to specific nodes.
> 
> Provide per-node reclaim visibility by changing the pgscan and pgsteal
> stats from global vm_event_item's to node_stat_item's. Note this change has
> the side effect of now tracking these stats on a per-memcg basis.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>

virtio_balloon changes

> ---
>  drivers/virtio/virtio_balloon.c |  8 ++++----
>  include/linux/mmzone.h          | 12 +++++++++++
>  include/linux/vm_event_item.h   | 12 -----------
>  mm/memcontrol.c                 | 36 ++++++++++++++++++---------------
>  mm/vmscan.c                     | 32 +++++++++++------------------
>  mm/vmstat.c                     | 24 +++++++++++-----------
>  6 files changed, 60 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 74fe59f5a78c..1341d9d1a2a1 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -374,13 +374,13 @@ static inline unsigned int update_balloon_vm_stats(struct virtio_balloon *vb)
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_ALLOC_STALL, stall);
>  
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_SCAN,
> -		    pages_to_bytes(events[PGSCAN_KSWAPD]));
> +		    pages_to_bytes(global_node_page_state(PGSCAN_KSWAPD)));
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_SCAN,
> -		    pages_to_bytes(events[PGSCAN_DIRECT]));
> +		    pages_to_bytes(global_node_page_state(PGSCAN_DIRECT)));
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_RECLAIM,
> -		    pages_to_bytes(events[PGSTEAL_KSWAPD]));
> +		    pages_to_bytes(global_node_page_state(PGSTEAL_KSWAPD)));
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_RECLAIM,
> -		    pages_to_bytes(events[PGSTEAL_DIRECT]));
> +		    pages_to_bytes(global_node_page_state(PGSTEAL_DIRECT)));
>  
>  #ifdef CONFIG_HUGETLB_PAGE
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_HTLB_PGALLOC,
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 762609d5f0af..fc39c107a4b5 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -255,6 +255,18 @@ enum node_stat_item {
>  	PGDEMOTE_DIRECT,
>  	PGDEMOTE_KHUGEPAGED,
>  	PGDEMOTE_PROACTIVE,
> +	PGSTEAL_KSWAPD,
> +	PGSTEAL_DIRECT,
> +	PGSTEAL_KHUGEPAGED,
> +	PGSTEAL_PROACTIVE,
> +	PGSTEAL_ANON,
> +	PGSTEAL_FILE,
> +	PGSCAN_KSWAPD,
> +	PGSCAN_DIRECT,
> +	PGSCAN_KHUGEPAGED,
> +	PGSCAN_PROACTIVE,
> +	PGSCAN_ANON,
> +	PGSCAN_FILE,
>  #ifdef CONFIG_NUMA
>  	PGALLOC_MPOL_DEFAULT,
>  	PGALLOC_MPOL_PREFERRED,
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 92f80b4d69a6..6f1787680658 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -40,19 +40,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		PGLAZYFREED,
>  		PGREFILL,
>  		PGREUSE,
> -		PGSTEAL_KSWAPD,
> -		PGSTEAL_DIRECT,
> -		PGSTEAL_KHUGEPAGED,
> -		PGSTEAL_PROACTIVE,
> -		PGSCAN_KSWAPD,
> -		PGSCAN_DIRECT,
> -		PGSCAN_KHUGEPAGED,
> -		PGSCAN_PROACTIVE,
>  		PGSCAN_DIRECT_THROTTLE,
> -		PGSCAN_ANON,
> -		PGSCAN_FILE,
> -		PGSTEAL_ANON,
> -		PGSTEAL_FILE,
>  #ifdef CONFIG_NUMA
>  		PGSCAN_ZONE_RECLAIM_SUCCESS,
>  		PGSCAN_ZONE_RECLAIM_FAILED,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 86f43b7e5f71..bde0b6536be6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -328,6 +328,18 @@ static const unsigned int memcg_node_stat_items[] = {
>  	PGDEMOTE_DIRECT,
>  	PGDEMOTE_KHUGEPAGED,
>  	PGDEMOTE_PROACTIVE,
> +	PGSTEAL_KSWAPD,
> +	PGSTEAL_DIRECT,
> +	PGSTEAL_KHUGEPAGED,
> +	PGSTEAL_PROACTIVE,
> +	PGSTEAL_ANON,
> +	PGSTEAL_FILE,
> +	PGSCAN_KSWAPD,
> +	PGSCAN_DIRECT,
> +	PGSCAN_KHUGEPAGED,
> +	PGSCAN_PROACTIVE,
> +	PGSCAN_ANON,
> +	PGSCAN_FILE,
>  #ifdef CONFIG_HUGETLB_PAGE
>  	NR_HUGETLB,
>  #endif
> @@ -441,14 +453,6 @@ static const unsigned int memcg_vm_event_stat[] = {
>  #endif
>  	PSWPIN,
>  	PSWPOUT,
> -	PGSCAN_KSWAPD,
> -	PGSCAN_DIRECT,
> -	PGSCAN_KHUGEPAGED,
> -	PGSCAN_PROACTIVE,
> -	PGSTEAL_KSWAPD,
> -	PGSTEAL_DIRECT,
> -	PGSTEAL_KHUGEPAGED,
> -	PGSTEAL_PROACTIVE,
>  	PGFAULT,
>  	PGMAJFAULT,
>  	PGREFILL,
> @@ -1496,15 +1500,15 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>  
>  	/* Accumulated memory events */
>  	seq_buf_printf(s, "pgscan %lu\n",
> -		       memcg_events(memcg, PGSCAN_KSWAPD) +
> -		       memcg_events(memcg, PGSCAN_DIRECT) +
> -		       memcg_events(memcg, PGSCAN_PROACTIVE) +
> -		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
> +		       memcg_page_state(memcg, PGSCAN_KSWAPD) +
> +		       memcg_page_state(memcg, PGSCAN_DIRECT) +
> +		       memcg_page_state(memcg, PGSCAN_PROACTIVE) +
> +		       memcg_page_state(memcg, PGSCAN_KHUGEPAGED));
>  	seq_buf_printf(s, "pgsteal %lu\n",
> -		       memcg_events(memcg, PGSTEAL_KSWAPD) +
> -		       memcg_events(memcg, PGSTEAL_DIRECT) +
> -		       memcg_events(memcg, PGSTEAL_PROACTIVE) +
> -		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
> +		       memcg_page_state(memcg, PGSTEAL_KSWAPD) +
> +		       memcg_page_state(memcg, PGSTEAL_DIRECT) +
> +		       memcg_page_state(memcg, PGSTEAL_PROACTIVE) +
> +		       memcg_page_state(memcg, PGSTEAL_KHUGEPAGED));
>  
>  	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
>  #ifdef CONFIG_MEMCG_V1
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 614ccf39fe3f..16a0f21e3ea1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1977,7 +1977,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  	unsigned long nr_taken;
>  	struct reclaim_stat stat;
>  	bool file = is_file_lru(lru);
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  	bool stalled = false;
>  
> @@ -2003,10 +2003,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  
>  	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
>  	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
> -	if (!cgroup_reclaim(sc))
> -		__count_vm_events(item, nr_scanned);
> -	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
> -	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
> +	mod_lruvec_state(lruvec, item, nr_scanned);
> +	mod_lruvec_state(lruvec, PGSCAN_ANON + file, nr_scanned);
>  
>  	spin_unlock_irq(&lruvec->lru_lock);
>  
> @@ -2023,10 +2021,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  					stat.nr_demoted);
>  	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>  	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
> -	if (!cgroup_reclaim(sc))
> -		__count_vm_events(item, nr_reclaimed);
> -	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
> -	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
> +	mod_lruvec_state(lruvec, item, nr_reclaimed);
> +	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
>  
>  	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>  					nr_scanned - nr_reclaimed);
> @@ -4536,7 +4532,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  {
>  	int i;
>  	int gen;
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	int sorted = 0;
>  	int scanned = 0;
>  	int isolated = 0;
> @@ -4595,13 +4591,11 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	}
>  
>  	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
> -	if (!cgroup_reclaim(sc)) {
> -		__count_vm_events(item, isolated);
> +	if (!cgroup_reclaim(sc))
>  		__count_vm_events(PGREFILL, sorted);
> -	}
> -	count_memcg_events(memcg, item, isolated);
> +	mod_lruvec_state(lruvec, item, isolated);
>  	count_memcg_events(memcg, PGREFILL, sorted);
> -	__count_vm_events(PGSCAN_ANON + type, isolated);
> +	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
>  	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
>  				scanned, skipped, isolated,
>  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> @@ -4686,7 +4680,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	LIST_HEAD(clean);
>  	struct folio *folio;
>  	struct folio *next;
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	struct reclaim_stat stat;
>  	struct lru_gen_mm_walk *walk;
>  	bool skip_retry = false;
> @@ -4750,10 +4744,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  					stat.nr_demoted);
>  
>  	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
> -	if (!cgroup_reclaim(sc))
> -		__count_vm_events(item, reclaimed);
> -	count_memcg_events(memcg, item, reclaimed);
> -	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
> +	mod_lruvec_state(lruvec, item, reclaimed);
> +	mod_lruvec_state(lruvec, PGSTEAL_ANON + type, reclaimed);
>  
>  	spin_unlock_irq(&lruvec->lru_lock);
>  
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 74e0ddde1e93..e4b259989d58 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1291,6 +1291,18 @@ const char * const vmstat_text[] = {
>  	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
>  	[I(PGDEMOTE_KHUGEPAGED)]		= "pgdemote_khugepaged",
>  	[I(PGDEMOTE_PROACTIVE)]			= "pgdemote_proactive",
> +	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
> +	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
> +	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
> +	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
> +	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
> +	[I(PGSTEAL_FILE)]			= "pgsteal_file",
> +	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
> +	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
> +	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
> +	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
> +	[I(PGSCAN_ANON)]			= "pgscan_anon",
> +	[I(PGSCAN_FILE)]			= "pgscan_file",
>  #ifdef CONFIG_NUMA
>  	[I(PGALLOC_MPOL_DEFAULT)]		= "pgalloc_mpol_default",
>  	[I(PGALLOC_MPOL_PREFERRED)]		= "pgalloc_mpol_preferred",
> @@ -1344,19 +1356,7 @@ const char * const vmstat_text[] = {
>  
>  	[I(PGREFILL)]				= "pgrefill",
>  	[I(PGREUSE)]				= "pgreuse",
> -	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
> -	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
> -	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
> -	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
> -	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
> -	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
> -	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
> -	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
>  	[I(PGSCAN_DIRECT_THROTTLE)]		= "pgscan_direct_throttle",
> -	[I(PGSCAN_ANON)]			= "pgscan_anon",
> -	[I(PGSCAN_FILE)]			= "pgscan_file",
> -	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
> -	[I(PGSTEAL_FILE)]			= "pgsteal_file",
>  
>  #ifdef CONFIG_NUMA
>  	[I(PGSCAN_ZONE_RECLAIM_SUCCESS)]	= "zone_reclaim_success",
> -- 
> 2.47.3


