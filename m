Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B0FE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 06:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307096B0088; Wed, 18 Feb 2026 01:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28ACE6B0089; Wed, 18 Feb 2026 01:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FA96B008A; Wed, 18 Feb 2026 01:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F203E6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:45:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EF9C1602A6
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:45:05 +0000 (UTC)
X-FDA: 84456640170.11.C970B1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D98F780008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:45:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YroFoQjd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771397103; a=rsa-sha256;
	cv=none;
	b=bnekZ4W/jLWKtzqAWV8qysnqfAiDwoBga8gyld0OqGzTnf+RvuIRXb95IBrbET77WPmQcr
	3C5UYGkZjksT+13lyN6CpS1j4/gugg29vK3gCd7AVgjDmRD3i0nyLF4lkOq4hFD1pdePqc
	dDN1tAC/TSDrR3pRsuTjdBfkyE0lNmI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YroFoQjd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771397103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNQksyfa6tqPomkXx5S7dqKmFWnls++hbDRwu1vUoII=;
	b=hqW0hTgyDevg5Isp/c0b/6RjTRydgtyt3YF1G+psVw/Eu2tcaS0ZeiyVQknROMTU/sJ1ko
	x6t+ffozPnCoNDLEV+oFbH0U5seX9EdxFIUMcUvEMHvjGwk5TVVvkrSd4v9buqAZnMARll
	6JztntKoZAmfkK6Ihq5pMq2fV2j3f1o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771397102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DNQksyfa6tqPomkXx5S7dqKmFWnls++hbDRwu1vUoII=;
	b=YroFoQjduwk4wCicp53dYsXnzOXkWiC6WOH2Ga+8mwQbOxFGwlhXuanlQxjcJlzp7uwny0
	fnluxsIo4FExrmXpu/Jayo5qBnit3+qBHZ2O35Hi1PRT1WO0R3/DRiSK4ErrYEDRquAwCO
	dPLes3rEzaTnftewnsUuNnyRx/mV4mk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-EXLh-JfnOZi0KaDDN5pNXw-1; Wed, 18 Feb 2026 01:44:58 -0500
X-MC-Unique: EXLh-JfnOZi0KaDDN5pNXw-1
X-Mimecast-MFC-AGG-ID: EXLh-JfnOZi0KaDDN5pNXw_1771397097
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-435a2de6ec0so3405012f8f.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:44:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771397097; x=1772001897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNQksyfa6tqPomkXx5S7dqKmFWnls++hbDRwu1vUoII=;
        b=wdCFms99Am1vSWXYrNHhrmgbqy4i6He460sbNQpKBSeRPIKaKROEWIIANOtxp9HHeS
         YYKMDqOYpQJbEKeRAbip0CG3Rjcy3uSk0hFoOW1Wl1ay76GyWFn0ofAzknZFvx3pJC3s
         QX7cPw6uplwOoQc+HzLzEZEYb6Y/MEWBrnsQJsyqYwVdvpYUouprCY58qynFVJ12c4KH
         G0Otu95h7EywWMzTorsr/+hdwhggxoVoHFuB6xPZROc8Z+48W8nlXG6IC5m9L2uwiS/8
         yfe59PBmAtMHe3P5sOHOGL4WdpjPiBufMmJGkA6A8Fs+T5+zHGSvjBjPcEC/jjdNDqt6
         fpdA==
X-Gm-Message-State: AOJu0Yy46Pg3/H2epj4UL9faPsXBuhwYtWqW7ggJz9P9r90XcyadiCFs
	UJCuwnGq8LIlhufvhBI72ugE3+8oTKxhFlcAlGMm6NxJBpzaBIONCFUigJ/j77yUjXpHrPUalpz
	5F5nYfxF1NNPbb1X2LPjdpi+1EW9Nlmn/c5eb/9TlNK7AM+OF8AiN
X-Gm-Gg: AZuq6aIdwHcbwZs6o/QNyJKSrWX+d2+3a0k3C+t62PdiyYdhTvRtUBw/kJ0AhV1331e
	Y2LnpGk9wYN9Os5gYRkjIW+q8Y02pACc4ILhIBd46IAjJYDLtF27gMN/mMCtRZ7SjlRIvMUt07H
	mmazGeOkQtElaQjkJ75UWzdxMmjFSi95UBXOC/wuhSBfdwl7OKr2sVEg78P3Jjb7/wjRjAw2tzh
	S7UagM6KWaxVLKgve0aGrJQk69WKT4eM7cXd84LFrxVrRJ/bBgBzSQLTDHKhc0Z4VOPvtELElT9
	Du9UkxFsBL1GxtDQg9kVTUXDaKU01LNOa6dMRR55fZg2oiwcoB1KLbXBMXO0c4YsdSHkyWMAiQG
	lHeRp1ArQM/frJiUZT/OrUOqtk+5yNJoFckJkqQULGkFyOw==
X-Received: by 2002:a05:6000:248a:b0:436:38a4:2423 with SMTP id ffacd0b85a97d-4379db66905mr24077946f8f.22.1771397097247;
        Tue, 17 Feb 2026 22:44:57 -0800 (PST)
X-Received: by 2002:a05:6000:248a:b0:436:38a4:2423 with SMTP id ffacd0b85a97d-4379db66905mr24077906f8f.22.1771397096669;
        Tue, 17 Feb 2026 22:44:56 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b2d1sm42700412f8f.4.2026.02.17.22.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 22:44:56 -0800 (PST)
Date: Wed, 18 Feb 2026 01:44:51 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mhocko@suse.com, vbabka@suse.cz, apopple@nvidia.com,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
	eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: move pgscan and pgsteal to node stats
Message-ID: <20260218014442-mutt-send-email-mst@kernel.org>
References: <20260218032941.225439-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260218032941.225439-1-jp.kobryn@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hhap94DT3rLBpW5JwFYEZb6clZbFbRDMyGSEGSWPfrg_1771397097
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D98F780008
X-Stat-Signature: domdwq6co1idwmjcb4pq419fyfci3rhe
X-HE-Tag: 1771397102-294330
X-HE-Meta: U2FsdGVkX1/crAYyqdN0ZP8bJvQ71mBO2+kYic6S/dWPShBOJFuIsjKeNWjtnk3VgNM/FoyvANX2b5hpdcGq2JBmoy7q0EXviJMNBJ/RvfQU7KhxtqrqCsfn8YASmbi1zHzjapA4FHe+gP7S4MB1fRSGMyZ/cfmxQwvH6X5YQ3AEY8Bqh+TkNDlDk7LAG5QLYevBi+2cWcXqGqNWXtE4ddnm/OaBbmAsDb2Aikw+RL9W9R3RwFCs2k/T15Mr8Hebu3j7IC7II87VJ7KRDDlzm5TIUP9QfpIWnn4prdfpLHuqp3IAhMTNFGxIBJPbcGunahyKsGcZrXyccqt16E+Z35yvol1+M0WIqDmdwBhxiVgEqFj+Vx/h/BubOK1pOOOzW/HVgj3jy7CFbeKc9R9syEqkT7km7HMwwBPG80bQAzefE0HEbwjTaN4RVYe84dbaiJzjWqJeAbW8PHC/A24aji1WtGHY7AMDgwuTkX3NlxAVwDYM0WQPewa7AcZBfyA5H0Yb900LntrPe7dtD8M3kLm3hPb7tZ36UhMzJVELnc8m3xscR5SCFHkrlGUh7DUgFWOhSWYjhY9oTJCqKRXF8bghAIth2FTiBk7uK36JuzbvnZCMkaL2U/L7NIC3cZq79Va4uFSFF0Vn2EwycGYHtjU70dVVLS44d5PadFr9nc7LH5Xt1lEYtYda/MXRJHs5JGTrC/q5Mw4arxC5/XDMyVUxeSqzg8o2Kjbfk9TZF6V5ZKLwRd9BN7zAQBA/N1zwwsfsNkW348g+02W8BfcjQo/x7wkdA4ruOncB8EcgKML/wOWviqFpCSUSK0zj7ZhcH6bhL2rX2G5FsKvzmtoCNX+nfdw63x9AfHyYkgMpXxu34lNjF9LrOPzdKu1zjYJmeT+hMvCtcwuiZDVXBZuZ9km1T3HmpC7J2nEgaeMwRg3yVhjvKHWG3v2voEE8UltuJ5fIWjPe3YI0jCXVeo+
 JYyfP0lj
 xDwX2OjV1ThsMolIFPtLw2iZVnDBOAB3MNWesZcL6xrPxCNyXAFRoLFdGfNYOyCJRGRnzWVv+WnGdCbQWpOqYyPHQ7KT2vP5sEU7XdD+/2bjMnoaxMe/5MMQkw9MyePSPGU2EODYvmTRPTY/i2IaP1K7pzZ8/YAN25dlEjjYGQkNAZNykk6ntDb0M7RXY8uv6tV3LE8mPgHTkM7bdr+co+NdwwDafa952lNIUaXPEZrphkrEzMugyi6g8EtfAbn+EP8ESJgd5Do2n62DWmB9AX/kgY9Xmh9ehYe7tMr+zdR5ddSvZQ2YzfALfCEmcx9tLqv/2UA9ksDHOClgLEYulG4FUUTlpCy/mAD/2JNssuQcJC9ivg4P3uKVHkywInnEj4EAIzbK3fi3NX9kdoZfn/bXhyQHp3/92FXTER7RxwElj3HJcuZlaqlfLeubxu/XPaTC3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 07:29:41PM -0800, JP Kobryn (Meta) wrote:
> From: JP Kobryn <jp.kobryn@linux.dev>
> 
> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan and pgsteal counters from vm_event_item to node_stat_item
> to provide per-node reclaim visibility. With these counters as node stats,
> the values are now displayed in the per-node section of /proc/zoneinfo,
> which allows for quick identification of the affected nodes.
> 
> /proc/vmstat continues to report the same counters, aggregated across all
> nodes. But the ordering of these items within the readout changes as they
> move from the vm events section to the node stats section.
> 
> Memcg accounting of these counters is preserved. The relocated counters
> remain visible in memory.stat alongside the existing aggregate pgscan and
> pgsteal counters.
> 
> However, this change affects how the global counters are accumulated.
> Previously, the global event count update was gated on !cgroup_reclaim(),
> excluding memcg-based reclaim from /proc/vmstat. Now that
> mod_lruvec_state() is being used to update the counters, the global
> counters will include all reclaim. This is consistent with how pgdemote
> counters are already tracked.
> 
> Finally, the virtio_balloon driver is updated to use
> global_node_page_state() to fetch the counters, as they are no longer
> accessible through the vm_events array.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>


balloon changed:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/virtio/virtio_balloon.c |  8 ++---
>  include/linux/mmzone.h          | 12 ++++++++
>  include/linux/vm_event_item.h   | 12 --------
>  mm/memcontrol.c                 | 52 +++++++++++++++++++++++----------
>  mm/vmscan.c                     | 32 ++++++++------------
>  mm/vmstat.c                     | 24 +++++++--------
>  6 files changed, 76 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 4e549abe59ff..ab945532ceef 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -369,13 +369,13 @@ static inline unsigned int update_balloon_vm_stats(struct virtio_balloon *vb)
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
> index 3e51190a55e4..1aa9c7aec889 100644
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
>  #ifdef CONFIG_HUGETLB_PAGE
>  	NR_HUGETLB,
>  #endif
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 22a139f82d75..1fa3b3ad0ff9 100644
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
> index 007413a53b45..e89e77457701 100644
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
> @@ -1382,6 +1386,14 @@ static const struct memory_stat memory_stats[] = {
>  	{ "pgdemote_direct",		PGDEMOTE_DIRECT		},
>  	{ "pgdemote_khugepaged",	PGDEMOTE_KHUGEPAGED	},
>  	{ "pgdemote_proactive",		PGDEMOTE_PROACTIVE	},
> +	{ "pgsteal_kswapd",		PGSTEAL_KSWAPD		},
> +	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
> +	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
> +	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
> +	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
> +	{ "pgscan_direct",		PGSCAN_DIRECT		},
> +	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
> +	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
>  #ifdef CONFIG_NUMA_BALANCING
>  	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
>  #endif
> @@ -1425,6 +1437,14 @@ static int memcg_page_state_output_unit(int item)
>  	case PGDEMOTE_DIRECT:
>  	case PGDEMOTE_KHUGEPAGED:
>  	case PGDEMOTE_PROACTIVE:
> +	case PGSTEAL_KSWAPD:
> +	case PGSTEAL_DIRECT:
> +	case PGSTEAL_KHUGEPAGED:
> +	case PGSTEAL_PROACTIVE:
> +	case PGSCAN_KSWAPD:
> +	case PGSCAN_DIRECT:
> +	case PGSCAN_KHUGEPAGED:
> +	case PGSCAN_PROACTIVE:
>  #ifdef CONFIG_NUMA_BALANCING
>  	case PGPROMOTE_SUCCESS:
>  #endif
> @@ -1496,15 +1516,15 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
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
> index 44e4fcd6463c..dd6d87340941 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1984,7 +1984,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  	unsigned long nr_taken;
>  	struct reclaim_stat stat;
>  	bool file = is_file_lru(lru);
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  	bool stalled = false;
>  
> @@ -2010,10 +2010,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
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
> @@ -2030,10 +2028,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
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
> @@ -4542,7 +4538,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  {
>  	int i;
>  	int gen;
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	int sorted = 0;
>  	int scanned = 0;
>  	int isolated = 0;
> @@ -4601,13 +4597,11 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
> @@ -4692,7 +4686,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	LIST_HEAD(clean);
>  	struct folio *folio;
>  	struct folio *next;
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	struct reclaim_stat stat;
>  	struct lru_gen_mm_walk *walk;
>  	bool skip_retry = false;
> @@ -4756,10 +4750,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
> index 99270713e0c1..d952c1e763e6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1276,6 +1276,18 @@ const char * const vmstat_text[] = {
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
>  #ifdef CONFIG_HUGETLB_PAGE
>  	[I(NR_HUGETLB)]				= "nr_hugetlb",
>  #endif
> @@ -1320,19 +1332,7 @@ const char * const vmstat_text[] = {
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


