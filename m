Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42BE60A260F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 06:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25FB6B0417; Tue, 20 Oct 2026 02:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6066B0418; Tue, 20 Oct 2026 02:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC366B0419; Tue, 20 Oct 2026 02:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAE6D6B0417
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:59:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E8A31208DA
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:59:03 +0000 (UTC)
X-FDA: 85342102566.03.45FE9CB
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 35A931C0005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:58:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792479541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6jEJaHu9Y6VT1XeMg7m9SCTxjFKNA6Hnu81PQYRc5yc=;
	b=3OkQTt4XXYfLleZ1WgMDEb81ZFRUJ9PQDTXJY6QtPOkzyfXQZkiQHK09z6p8zJ8GVtk/qM
	Y5WHn8hJJ6WjVukgOgNMDIJXNAsvwIhJ+f9SpTWwZ7dY0i3B54+4ASGvufpxv1S41/vfKG
	Ag5HFa6wqbPAXQALWU/IdmK91wMtjGk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792479541;
	b=Emxj9pTsCL1IBXo7s+ldsqeIiohwwLsqR26MA180076O+LlW1urfyZPqlvsL+uA6Q3KCE5
	fA/HMEUVGQmpOSdGRT1H8fe7azJuYje/iOdkXvVYnGfVwSrYMrwvK3bpWNNwXVox0g3tHE
	7wpvNP9aLFTDvHajsrScHX07Jn5HSkI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.52 with ESMTP; 20 Oct 2026 15:58:53 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 20 Oct 2026 15:58:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 20 Oct 2026 15:58:53 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
Message-ID: <atcRLYvKavedT6Hs@yjaykim-PowerEdge-T330>
References: <20261019160615.2348500-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019160615.2348500-1-nphamcs@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35A931C0005
X-Stat-Signature: 8ge7wdmjxq8ridfddbzwqqp4xtx34yzt
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792479539-53893
X-HE-Meta: U2FsdGVkX19ro2Oz1JRGxKGxiapL9ZcyHotT3DO1AztiAqtiC+rd7xULtOspO4zS8mQI9pn5aXkpLT8mQzvw3Qw9HtIRkkldMDu2h+7KYfYDjc8+ay2PP4E1D9BFxv+24lKXahMTgkLb6Lanob2G7cphS3fKFkfw3O17IgknFARVrl4zCUtCLycI/lAtm6t0dznKx5UeGZsrg/8GD/wDG9lytHucEcGCJ9V/ppqnWI+9FQC6TGqLv6ZTiBJSEtLX/8QhyjwpBVemT9WDYNWDI39rVRQxOArtBEcmBHTDgE/CRPrHBhL7cnqRWSuOW4VpECspYXzge+X9wrvbQhz8OqLN8Hlc19zlcKk60hJwa6ba7/tEc0JaJefIo8/S2GrKbCX/d/xj4yok0dzeylNgirCvL98Ka7Kkq9PGKDX8PtZkBZp4izC5hCvQdOPKRYZzbzkMHybQi9+juRTJ+d6pTlIKdv72KBauPsMiXbTZIKfxyW683Ecxk+O7/6oJAjNFMfwWioQQkA2/kLgVnhjEkttJPFAHNmwQ1h4v9/xvxrwuuAWUtQj93iVbvOC9HSvTJRPCiOP5KlgdYGKBGT76WSilYVuFr7YX9vA4Fs1BJR7gLi2oYMiCGL4Zfjrl/Ln006ltApz2UgNX6jnyVmpcfUUpmIE8qTFs50UrDkWMhoPHxGyRPzYr94hv9i8VU/nSM+WiqctIWjSdSv9WFCUt3OFNgxFJRPZX9EHbbRlJrGjaYObRB4FJyTwj3LgGED+t6C5Sg/nv6fkBJT6o3UJyjc/YHgvZgQzz3yCHjEQN+mvXrnBhKa53knXHQvXLKydrNzL/d3BUXIPouD2D+bwove2M3xFoezsDbRci7dk0NALhFw1RbQ7WEaylo4mdPR31g7hAi+kYmL4VGuGZePUvRUdzpJ3HhMYrTEt+OS9GV5IQDPvnsWgErp4Jwi29U4vd7tcmfXkVVdkeX89arRq
 zU/rDpu9
 M16K0LQieebZ1KZWwzM07uzZK8a1wTLa9O+L0ixeGsBo009sHEi2FF75wGPib7bz4CY8mWw9UmHoxLkKaLpXA+OuOXagCuNkYTST0W9bHQI5E6s2J/4djvjakB4nuU0kwexIs0vaa4BS95hAQBsaD9CMZ2lORQ3Ndqi9sG6gIM0o9yTnuN36O/mQXWFMvNSt3aDS5Yrwklll35VT1nhmjEx+nc7DX2JkMq0HFrxX1GZt7h4BSeJy+ZCW8r41kwwaf6iPQsjoF2hGRhPy7j7dpmfItkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 09:06:15AM -0700, Nhat Pham wrote:
> swap_cluster_populate() can publish a cluster's table with the cluster
> lock dropped. A cached allocator can use and empty it before the
> populating allocator reacquires the lock. The resumed scan can then
> dereference a NULL table.
> 
> For example, CPU1 can retain a cached cluster offset on an SSD with
> per-page discard disabled:
> 
>     CPU0                          CPU1
>     ----                          ----
>     swap_cluster_populate()
>       swap_cluster_alloc_table() fails
>       spin_unlock(&ci->lock)
>       local_unlock(&percpu_swap_cluster.lock)
>       swap_cluster_alloc_table()
>         rcu_assign_pointer(ci->table, table)
>                                   swap_alloc_fast()
>                                   local_unlock(&percpu_swap_cluster.lock)
>                                   mem_cgroup_try_charge_swap() fails
>                                   swap_cache_del_folio()
>                                     __swap_cluster_free_entries()
>                                       free_cluster()
>                                         __free_cluster()
>                                           swap_cluster_free_table()
>                                             rcu_assign_pointer(..., NULL)
>       local_lock(&percpu_swap_cluster.lock)
>       spin_lock(&ci->lock)
>       return ci
>     alloc_swap_scan_cluster()
>       cluster_scan_range()
>         __swap_table_get()

Hello Nhat.

Good catch!

> Reject an unusable cluster under its lock before scanning it. Relocate
> it only while its table is present.
> 
> Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helpers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  mm/swapfile.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c3288910b3e3..988b7316e0a1 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -981,7 +981,11 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
>  	bool need_reclaim, ret, usable;
>  
>  	lockdep_assert_held(&ci->lock);
> -	VM_WARN_ON(!cluster_is_usable(ci, order));
> +	if (!cluster_is_usable(ci, order)) {
> +		if (cluster_table_is_alloced(ci))
> +			relocate_cluster(si, ci);
> +		goto out_unlock;
> +	}

If this patch is applied as bloew, does it prevent the issue described here?

https://lore.kernel.org/linux-mm/20260720071342.50742-2-shikemeng@huaweicloud.com/
(This patch publishes cluster table after lock acquired.)

This patch is chagned the way I suggested during review... :(

As you pointed out, another context can free the table 
without alloc context knwoing this situation.  
I missed this situation.

IMHO, Publishing the table only after reacquiring the cluster lock, as Kemeng
suggested, and rejecting an unusable cluster under the lock as in this
patch both look correct to me!

Reviewed-by: Youngjun Park <youngjun.park@lge.com>

