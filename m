Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64BEF01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596816B008A; Fri,  6 Mar 2026 08:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5611A6B008C; Fri,  6 Mar 2026 08:53:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477046B0092; Fri,  6 Mar 2026 08:53:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37F556B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:53:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9BE259339
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:53:04 +0000 (UTC)
X-FDA: 84515779488.24.B4E1C9F
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf07.hostedemail.com (Postfix) with ESMTP id 16CDD4000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:52:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772805182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hT41Jm8YrS6p6Mq4D2yVoe1YQD2BXJAwDBn6aUK5JsA=;
	b=DEwC0+7JGvb6vzJIJSwZSmvdyZTe69JmDOeyBKkA5jv+P+uVIdldYBm7riaWwrEvHaDIAI
	W5eyOb20NQYuN+YRK/UdrXid7bdETzfXhkGTzDdjtjMC0SKnLcIwg9NsXkLil3P8ybNvvc
	Oc8CNMg55rcoyWzNcy8qiErmI4RhClU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772805182; a=rsa-sha256;
	cv=none;
	b=XC/zBE9Tdgs5Y0WC3FvPeB4fliBvzYEvg+N2bHWK0lSjfMyPYop871SfH/3LeDvQOWszvV
	aBTD7CehPfqXuL9JCpkb5IaR+kuVG06gGXq7fF7vK7cZ1OPqkrcH+hfIgf5luPDzqAZmt2
	/fRw5RZ3iHVaWNewKHYidbljtM1VbLQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 6 Mar 2026 22:52:35 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 6 Mar 2026 22:52:08 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/swap: fix missing locks in swap_reclaim_work()
Message-ID: <aarcCC/FgqtxEZFj@yjaykim-PowerEdge-T330>
References: <cover.1772797581.git.zhuhui@kylinos.cn>
 <02f5912caa6c427705bf8da43497801caf3b102f.1772797581.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02f5912caa6c427705bf8da43497801caf3b102f.1772797581.git.zhuhui@kylinos.cn>
X-Rspamd-Queue-Id: 16CDD4000B
X-Rspamd-Server: rspam07
X-Stat-Signature: q6f7fn6hw9f5jtqbkmzxdj3qnj7wr8hf
X-Rspam-User: 
X-HE-Tag: 1772805175-946729
X-HE-Meta: U2FsdGVkX182sotLaKOkS5BJWIdZIY64+b0UpF//LAFOGz5CKqgwELg2rO0YrCvLlLA8aUxs87or0YuwvxoJ8+EZu/rq61AJUKfQxrFSpe5kibF1GmU1noa7SfYHcEg5OzV7GWCfPFadTklHb/7aRSz4HEljv8XQum6QFEhVA/2zLeC7iZ5O5QSIF3WQBX7+JKf5zukqg677KTnO7pVswlCnV1tO4d8+HOMZicWtM1M9qFRZ38E1iAX95OtJuVsxuo/Laov0H3+uUoy9IvK9ayNBTHRIxMTbCjRn1WigW3mm1W8d+fICG0/+zNspc+7DKTH57KPeqtu9dw+RyPro9rMZ1wTMNUe2gKLg9+XsC6YVmNtYIl/dDYkDdB30uUS8sJ9/cc00FYzXiA/E1kVZlChTDnaGTfGaf9HgF6i+Ljgjgk8LfRHP2BXAXIjzvxK+wQSvsfbAuMYZxp9kT1rnvb9tzM1OY42b8mDkMAH9nS1dAt7Bs72WtGfkcjojCBQWoa0UmPoUNHq5tP+zeMmZ6FU3iRaIphHfibUYW/aQwjS7lapRvnQsrt7/RMaEIjy7S24N8Nmz29GDOscr6dSrNnSakb8S/FEtn78TZ6p9POA3n8B3auKzvr7ySx4+0twAiP/3fsOr0uXnJImI7BhPeeNoLLiz6+shu5L3zV/KcrPDTabyQK7DnMEMXpT0SNLgTM++JfJkLyo3pk4GjkqS1SsfDiX2+I/TOObVk2Qj7GxhPeFwg1wHSvGUIQ+uaSIldbsSFBDRzdXnLakb09zojXUWBcCMi6foV/PxMegB1AI2tU+1GxYYfVBxVvfqjzcW0rxqlY2DJwWa9XLYYQANSw412aokEElCcb0rGca9pdnOBk/bCK5kTiVlmqwpVjUJVi0uf54g/zTE2Geuiiercmcjom04C74IQSu+yDFAkfdHscE+V8HGbcnJlh8s9aMnEwTTJ4GZoTgVdpTxyRv
 RjhpQnsz
 tnTuUY6JPZKDCqW1D3RwwpfjCMRuMMZ27PIX671HuBfmYipV1D3hYsm44kvVTo0aPRnBN/7YHoDHZ2S7JpuW64i2vhXv8QLca83zmssG3tBtkD95tdsp5ei3PgNkm5vOEpiyzeJksUS1JlDl6Kvfo1gCpdudqsVr7DVi45J0wWzZfgSopnNCOrRflMWEzis3mX2NEtc5NUYjzdmYeZrGo2nRvbjTGOlLiTWpMGoX2OpaFcdiXjJlyCN/jz1Rx4Ekx2VDyAoEoKV6mk00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 07:50:36PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>

Hello Hui Zhu! :)
> 
> swap_cluster_alloc_table() assumes that the caller holds the following
> locks:
> ci->lock
> percpu_swap_cluster.lock
> si->global_cluster_lock (required for non-SWP_SOLIDSTATE devices)
> 
> There are five call paths leading to swap_cluster_alloc_table():
> swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> ->alloc_swap_scan_list->isolate_lock_cluster->swap_cluster_alloc_table
> 
> swap_alloc_slow->cluster_alloc_swap_entry->alloc_swap_scan_list
> ->isolate_lock_cluster->swap_cluster_alloc_table
> 
> swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> ->swap_reclaim_full_clusters->isolate_lock_cluster
> ->swap_cluster_alloc_table
> 
> swap_alloc_slow->cluster_alloc_swap_entry->swap_reclaim_full_clusters
> ->isolate_lock_cluster->swap_cluster_alloc_table
> 
> swap_reclaim_work->swap_reclaim_full_clusters->isolate_lock_cluster
> ->swap_cluster_alloc_table

Can isolate_lock_cluster() actually invoke swap_cluster_alloc_table()
on a full cluster? My understanding is that full clusters already have
a swap_table allocated, and swap_cluster_alloc_table() is only called
for free clusters that need a new allocation. If isolate_lock_cluster()
checks !cluster_table_is_alloced() before calling swap_cluster_alloc_table(),
wouldn't the full-cluster reclaim path skip that allocation entirely?

> Other paths correctly acquire the necessary locks before calling
> swap_cluster_alloc_table().
> But the swap_reclaim_work() path fails to acquire
> percpu_swap_cluster.lock and, for non-SWP_SOLIDSTATE devices,
> si->global_cluster_lock.

If my assumtion is right, table is not alloced so synchronization is not need.
Also, percpu_swap_cluster.lock and si->global_cluster_lock appear to protect
the percpu cluster cache and global cluster state, not the allocation
table itself as I think.

Best Regards
Youngjun Park

> This patch fixes the issue by ensuring swap_reclaim_work() properly
> acquires the required locks before proceeding with the swap cluster
> allocation.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/swapfile.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94af29d1de88..2e8717f84ba3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1031,7 +1031,15 @@ static void swap_reclaim_work(struct work_struct *work)
>  
>  	si = container_of(work, struct swap_info_struct, reclaim_work);
>  
> +	local_lock(&percpu_swap_cluster.lock);
> +	if (!(si->flags & SWP_SOLIDSTATE))
> +		spin_lock(&si->global_cluster_lock);
> +
>  	swap_reclaim_full_clusters(si, true);
> +
> +	if (!(si->flags & SWP_SOLIDSTATE))
> +		spin_unlock(&si->global_cluster_lock);
> +	local_unlock(&percpu_swap_cluster.lock);
>  }
>  
>  /*
> -- 
> 2.43.0
> 
> 

