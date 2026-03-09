Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0DB0EF3719
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183106B0088; Mon,  9 Mar 2026 04:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1311D6B0089; Mon,  9 Mar 2026 04:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D086B008A; Mon,  9 Mar 2026 04:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E36176B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:42:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93B92140D7E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:42:06 +0000 (UTC)
X-FDA: 84525882252.05.19814D3
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DA6E1A0010
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:42:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773045725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BlMaS1zrMN5rgyAPk07UXv8P/A1oQhQb0uwHzQEkXS0=;
	b=6hUM6duQlg1FQky+RzixonEnaQ7nJPui23kG6RNe7rz/2tyy0az9jTxDHKsIOtjPiczbxb
	whd9wufL8q5yDOVG5yKAWfqyKwBkOAbKG8AaTyHWRWXY1teC/LvXCb6M1ruSTkwe6zty/w
	cMDBPZNcEWMUCb0GighyYkoxUr3EB4o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773045725; a=rsa-sha256;
	cv=none;
	b=1FY5tWXr7hlp7oTaI6ahthWuoLzbQJp2hmMMU3yPZrR3uZujETgUiQ8sUJ76o2uUHrO2eU
	bZv7ZUKHSy6RvPrUY8Yopiqb2kK5tR91G0UF30QiQ1zahvUdsZR7IktvOSw0HC5xw2FE/Z
	yAgpWavaCP7zd77pty5QGC1/hkbqfpw=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 9 Mar 2026 17:41:57 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 9 Mar 2026 17:41:28 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 2/2] mm/swap: Add lockdep for si->global_cluster_lock
 in swap_cluster_alloc_table()
Message-ID: <aa6HuKYiv6YP7Hkk@yjaykim-PowerEdge-T330>
References: <cover.1773040982.git.zhuhui@kylinos.cn>
 <879eff096e46c02f994de62dc210a95cc58e3f19.1773040982.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <879eff096e46c02f994de62dc210a95cc58e3f19.1773040982.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DA6E1A0010
X-Stat-Signature: jpsmpr9p4d8hka3i4ddt699mtmnwzj89
X-Rspam-User: 
X-HE-Tag: 1773045723-833696
X-HE-Meta: U2FsdGVkX19rDnBxTx56dn5A2OUilWKbx56seNYrilz4chsAcdCr/SAES0r6hHWEwCtqrZNNA9nE6whEobjFoljQGv9GxlzdRt4mr8qpyO0Nvn3txoY8iKAt6Gecz3kbNGQyPuolV6u2e84cQLcRmV2+T3gaDnmRQYGePZUjj3fbOlUXYbCvtq5EbmAC35/mHiK07Rg/wyXACv5Ed+tExhpEQBcwX7l8KARkZbbuRXkd8SaWWH5TuA4PWwt04kjvDV8nfUw1QCubHrQ5BnYGkYeHTK/OK0FDlqNB++Uaka/49FYWltUxgPxUZ+ESiZPIjO58lghvEqub0t98kzOYrjA6rXi+Dquepz+GYYGZDJ3lUUB1jwNgzqM1qneND+9k7MYPSwDgpRLPQOIZN+xYOE1xgF+rTgbzS0RKd/PITl78Oiru4I3LmjBeVUq8JIMOjlosylVsYJ34bAeV7fiImsMIxEXuE+Pp7AWLqrFzdu4i2fBxGYeQ5eIRkba+vJahbZzsTym/KbkQ6ke20otFck1ynIiXXuMa9v6pT9Ni+OqsYqLIYVYvTm95WM+CS49t5Os9CPFaMKQtP3VM66iLBxu0Qeph/lQP3cLvW/gC8iRwGevlcW16GmemHNiF+DSgUTC8qrfgCCHHA3YmROSxkp5ZBCHpRbjjRa/mEJrVOg2I9zL/csb/wkAqn13yimFfVGtD14ShtP3FPUkL62ICtzkX8uAHSwSipTP3ag67gSoj/IqL6+WM4Y9xmwfnxiV9f0TW4IqPg9r5BG3rSlOdmMy8uKo6RVTWWikG02MjlI1nvACOKClO7EW59dNucdvzEx84LsARBXQgyWqY0DEWLsPXUeJ/sF5bnGUxXeeTO/pcNtW8TdellhrdRejTrCs4zkNFU9mficCO0g1pRzLbH9WqocdCmPCN+PFpmIUyEF6mpoSDzjWAOdLNz/rQ+HObg/BaO0EgXSRUcI3aQMT
 bXhqFAYx
 wEhmYmkz58wtPOJJJcpRqrpJ85TmHkEvWd7zXIWgtvRPAJer5Y/8JeB+2RHGvZGC0gOXPpYA7qiml7BwWi9xKUSdrXqI7ptun9J0/UxFyWxhx0+GsrXQhjjTxHBdRPUUgc4bKSyGk9++mgvof1aiwhJz34jD8HS/Nd2/2J03OLj4rrvlOxqn82ikRBb2b385fXdrthgZm8qc2ZTuj/xJTxCFne1XSnSmZ/KRjSGuaxeC8gfNgsn9QMtJgLct/SPYK1q6iqrtJ81K96+dG0E4DFGltAnKQd7lrHW4Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 04:05:42PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Add a lockdep_assert_held(&si->global_cluster_lock) in
> swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.
> 
> The function already requires the caller to hold both ci->lock
> and percpu_swap_cluster.lock.
> And it also necessitates si->global_cluster_lock when the device is not
> SWP_SOLIDSTATE.
> 
> Adding this assertion ensures locking consistency and helps catch
> potential synchronization issues during development.
> Change the order of lockdep_assert_held() to match the actual lock
> acquisition order.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/swapfile.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 3fc2eb30c187..b31b86263b89 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -476,8 +476,10 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>  	 * Only cluster isolation from the allocator does table allocation.
>  	 * Swap allocator uses percpu clusters and holds the local lock.
>  	 */
> -	lockdep_assert_held(&ci->lock);
>  	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +	if (!(si->flags & SWP_SOLIDSTATE))
> +		lockdep_assert_held(&si->global_cluster_lock);
> +	lockdep_assert_held(&ci->lock);
>  
>  	/* The cluster must be free and was just isolated from the free list. */
>  	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> -- 
> 2.43.0

The changes look good to me. Thanks!

Reviewed-by: Youngjun Park <youngjun.park@lge.com>

