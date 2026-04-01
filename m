Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E8A8D3515C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B4D6B0088; Wed,  1 Apr 2026 05:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C616B0089; Wed,  1 Apr 2026 05:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59976B008A; Wed,  1 Apr 2026 05:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B91E36B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:48:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D1401A0780
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:48:06 +0000 (UTC)
X-FDA: 84609510972.13.15D8DE5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D64120009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:48:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ST4emp8p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775036884; a=rsa-sha256;
	cv=none;
	b=tmX/mp/WOTLFXfZc/CCP7HqDmL8aao0GaWVHSNURXXFfn+GvUSHfX/5mzhT0vd7bU8FaEK
	EPWHSK7WD72iMZetrdEZlxTtyZU5TZHT1R3ox5JIcjBVBcffey5ohYVvyekxAci7MZ5jeG
	ererucpP2GZrP5DT0DqmIgUZBHiA7QI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ST4emp8p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775036884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5Fn2UlyTzbBubxoJbwHjMcPOZ/geBIS1AM3iCXfMrc=;
	b=5C6TytINu41TD9jfBR4HyKSDIRc8aq7SOB2qIuU7Ob6DIGElIprPO8LM2XWd3ixkS9sPcx
	vcmouzEoy3QM/HPzt0ZdpEbbWeWGAY/wIMli2l/HJz4AHfpC/tVDh2l75FhWR9mMaz/eUn
	hylRXNZCjULfdSFgupvTCUVELXi1IZk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775036883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P5Fn2UlyTzbBubxoJbwHjMcPOZ/geBIS1AM3iCXfMrc=;
	b=ST4emp8p0HfbFaxElkURR+xQXozyTbNouQuvW2cnmy1Dm0Ymx5FFd+l3Fnf3dmvuSEgWbX
	oAxxg8qIBthI6hUsqc7HUiOoTuDZlM4R5tNY7tMsoP7URTbeOQ18t5HK/hcdFvtpz/OFSK
	LSrVKAlDNw60sQdPWrQOewM/e4maWMM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-OchIZal7PCWIHHQhgfKtSQ-1; Wed,
 01 Apr 2026 05:48:00 -0400
X-MC-Unique: OchIZal7PCWIHHQhgfKtSQ-1
X-Mimecast-MFC-AGG-ID: OchIZal7PCWIHHQhgfKtSQ_1775036879
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A33418005BF;
	Wed,  1 Apr 2026 09:47:59 +0000 (UTC)
Received: from localhost (unknown [10.72.112.128])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1FF819560AB;
	Wed,  1 Apr 2026 09:47:57 +0000 (UTC)
Date: Wed, 1 Apr 2026 17:47:53 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v3] mm/vmalloc: Use dedicated unbound workqueues for vmap
 drain
Message-ID: <aczpyc7sxzBL4MQn@fedora>
References: <20260331202352.879718-1-urezki@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260331202352.879718-1-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: ekq9kqBeOYiXfL6hjJF7IT4YQnU6B0Jnme6U4eNN0yw_1775036879
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: uf8anwdm5rictdsjoddcewjip5k9g4m8
X-Rspamd-Queue-Id: 5D64120009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775036884-814786
X-HE-Meta: U2FsdGVkX1/clPZxN2JNGj3OZUi5ujr6sREyjlIYy9tA0kmDXOktsEAihIh15sj+9SMEdLy8/0uiuOfCI95klURlpzEC3OkvQRxwukPJ9fLbJatULXte8tQXj+hd0agiYbSXPVJ76lktWWDv0RRgYr5P7i8rIIspuNf54oH6lGywX29LAfjjRL4UsJrd0bFDqzVXldQm4plB0zBavGGoerudK2xNoetqHmqb6+kDXRxdXi31lWnwYdVl7kH0mkChGXqL5y6k2amxcgqHrOkvifvGenKCFnUDVa9TST3/2w0/1S2iWDyU2F1IZxOrK1IgWzNBfVcZZDQBrjh9NLleio9gf8MAD2tG9TaQBsReGfq90DYSPehkas4F2nfVyvdHVgN9OdqjruYXFjURaeKPVweyvdbK0j+LGsUqSgPxrmRtGqHgBm+g4edKckOEGKuPL9Vu7aZ/0mZZyVJP4Paq9ul8jZHyY2+Fe916XLtudJTCeQsCY95a0bFOtKqrc8Todh1Ny0Zsmz1tXs4GpNOL4o6Lv7+xTuJp4Va3bYfziBDWIwojTX4BpJepe2kTS/rC32JmRtOnz+wCbjumeGCqaX+EwFbuvSPUsns3bhQ0jTfA0IU6AY6+bHpQS2i89K2ghak7HR4KDQwB/75KWShHKlksNQWIbYNpOOyZZEw0v/K9baxzaUJYjDIcWuvchDq6Lu5lyg+jyxZixqRNpPK7Wwd2S/WfZsnll+TdI8Dm+pftTZNOh1k9NhLHrdjZutoq3E6HAX0x2OxAtz7tn34hJfZijuJAPiZPBR8oBfCSi6FKbKPnKTs++ZfZosJDzkO+UbS/NpGI9wCOQFnkRa4xB+sfP4G+ODpTt63UYP8i6kCpD08m8nj21ayLsoojuWSX/hsIEkycuNnhMEjtHb0aKx1ojUjxeRWKu9s2+FLJPJA+q4psoNJ5aP4cV88lixui9+OU/OAH7+JkxsJOa3G
 emuqZe2H
 m2SZg3uxJg+iwu5Erm7FdrHrgwH6JzqZygTRRzPPY6kNTqWrKybSqamo/RUlAX7RgMkyqzxuggpdNzrRGAqdRg9Pm/Rl8m3lV+W3ddIa94Ac3fLsivvQK1SP13GL1M50J/NIosR0L9feZ8V3upjO2b8wKmvOt/8yj6xX8fXqXba4lBXjr9G6rWXLO9UaHhI/oS6voTiivsTXS1vTNFq3GX3mPcLFlFurrQKM7IqfJnv7NZ+sgm1+lblayPE9vMZDIlYR50Uiz9pUA2qeKoajdxI/OSSB4fjAqKdXsJ01Z3yX3ewY6P63JGViYICPd33ThqH9jsVFB8OO4gpTS06kUu5l0ot1AWM6P1aMBRaLcsAkqy44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/31/26 at 10:23pm, Uladzislau Rezki (Sony) wrote:
> drain_vmap_area_work() function can take >10ms to complete
> when there are many accumulated vmap areas in a system with
> high CPU count, causing workqueue watchdog warnings when run
> via schedule_work():
> 
>   workqueue: drain_vmap_area_work hogged CPU for >10000us
> 
> Move the top-level drain work to a dedicated WQ_UNBOUND
> workqueue so the scheduler can run this background work
> on any available CPU, improving responsiveness. Use the
> WQ_MEM_RECLAIM to ensure forward progress under memory
> pressure.
> 
> Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> workqueue. This allows drain_vmap_work to wait for helpers
> completion without creating dependency on the same rescuer
> thread and avoid a potential parent/child deadlock.
...snip...  
> @@ -2385,29 +2390,31 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
>  		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
>  
> -		for_each_cpu(i, &purge_nodes) {
> -			vn = &vmap_nodes[i];
> +		for_each_vmap_node(vn) {
> +			vn->work_queued = false;
> +
> +			if (list_empty(&vn->purge_list))
> +				continue;
>  
>  			if (nr_purge_helpers > 0) {
>  				INIT_WORK(&vn->purge_work, purge_vmap_node);
> +				vn->work_queued = schedule_drain_vmap_work(
> +					READ_ONCE(drain_vmap_helpers_wq), &vn->purge_work);

The new schedule_drain_vmap_work() could submit all purge_work on one
CPU, do we need use queue_work_on(cpu, wq, work) instead?

>  
> -				if (cpumask_test_cpu(i, cpu_online_mask))
> -					schedule_work_on(i, &vn->purge_work);
> -				else
> -					schedule_work(&vn->purge_work);
> -
> -				nr_purge_helpers--;
> -			} else {
> -				vn->purge_work.func = NULL;
> -				purge_vmap_node(&vn->purge_work);
> -				nr_purged_areas += vn->nr_purged;
> +				if (vn->work_queued) {
> +					nr_purge_helpers--;
> +					continue;
> +				}
>  			}
> -		}
>  
> -		for_each_cpu(i, &purge_nodes) {
> -			vn = &vmap_nodes[i];
> +			/* Sync path. Process locally. */
> +			purge_vmap_node(&vn->purge_work);
> +			nr_purged_areas += vn->nr_purged;
> +		}
>  
> -			if (vn->purge_work.func) {
> +		/* Wait for completion if queued any. */
> +		for_each_vmap_node(vn) {
> +			if (vn->work_queued) {
>  				flush_work(&vn->purge_work);
>  				nr_purged_areas += vn->nr_purged;
>  			}
...snip...
> +
> +static int __init vmalloc_init_workqueue(void)
> +{
> +	struct workqueue_struct *drain_wq, *helpers_wq;

Maybe there's one local variable is enough like below:

	struct workqueue_struct *wq;
	unsigned int flags = WQ_UNBOUND | WQ_MEM_RECLAIM;

	wq = alloc_workqueue("vmap_drain", flags, 0);
	WARN_ON_ONCE(wq == NULL);
	WRITE_ONCE(drain_vmap_wq, wq);

	wq = alloc_workqueue("vmap_drain_helpers", flags, 0);
	WARN_ON_ONCE(wq == NULL);
	WRITE_ONCE(drain_vmap_helpers_wq, wq);

	return 0;
}

Just personal preference on nitpick, not strong opionion.


