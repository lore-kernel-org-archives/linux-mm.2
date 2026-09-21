Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFE8C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F046B00C7; Sun, 20 Sep 2026 22:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FD06B00FE; Sun, 20 Sep 2026 22:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8457A6B0102; Sun, 20 Sep 2026 22:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 655716B00C7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:45:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0E731C2C0B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:45:46 +0000 (UTC)
X-FDA: 85236229092.15.3745F53
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22D20180002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:45:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ksQCKAtI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789958743;
	b=4UJjUvKuVPr8mN6NYaFWzeoidVic1GCNbGicqV+mK3xspHofg9ewC8PqM6D6lkCgRup/PV
	mtxjlCejHjXpNy4UVrs75ezJR0D6zTaYwkDkOkBES2XWe69JXYqOkZOGqFygnZ619IjUI5
	JuO5OD1Ii77PBfyjO5R2snM4gPoD6xQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ksQCKAtI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789958743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hnw8ne9q9bP5EaHXGLaBqF6A8SqedkV9dNxVUYN6TMU=;
	b=xFcFaEDwCY3XVc1VhogJtHJzKKhXrADGpRDPNPz2R0ceTESNZO5vsjbCzMGTWrBV3WoNVk
	7qciMDd6Z33RglfiTtoIna4V8aKTWaq2LVXw8Nm10kNwNDFZm2fjoroQFg8UM0HFjZ4biY
	JTzxCIFyyZ8C6GvDzrlRDLX+rVHeDTQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789958739; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Hnw8ne9q9bP5EaHXGLaBqF6A8SqedkV9dNxVUYN6TMU=;
	b=ksQCKAtIyg7E1LCzes2+DLGU7HHPDRHjeizEwX8erGkDbHUiU7JpfO0kl4ajfa5sFLExuPCjPZ0pbaPpF0GBgb0Fv/xRtVsWU652K9AQ5daMO72Oy3TPrvjE5uBxycVBKH7uxuZTD2lZjr6q/2eokST3jOmeiEqjB/5g9vdsqpw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XBHKT4s_1789958735;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBHKT4s_1789958735 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 21 Sep 2026 10:45:36 +0800
Message-ID: <fe49c311-582b-4ee2-8d17-42a758351570@linux.alibaba.com>
Date: Mon, 21 Sep 2026 10:45:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: don't release a swapin-error marker as a swap
 entry
To: David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 kasong@tencent.com, bhe@redhat.com, chrisl@kernel.org, baohua@kernel.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, hughd@google.com,
 syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
References: <20260920155002.1030454-1-devnexen@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260920155002.1030454-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 22D20180002
X-Stat-Signature: x6sde6mjttowz85r3ojtjeqtryddhfeq
X-HE-Tag: 1789958741-180194
X-HE-Meta: U2FsdGVkX1+UptYM/efU9gIS6iXyaQimZn2iDvcMKdulAeeDVk/pTClW7vIPFT++j3HG5gFa/oRcyn5GID+1WYaGx91NVM4b2V7M5/qKOwEeQAb4RZ1BWewh5myB6lTfu3Z1sLBN5jqp0rPiFX5osxHrMEHBNovvYILUgYfJoW/cBa8cyu/xcbtjHMndNOPnkYhh9qLwLApbLDgMyqLd5gloFK1Bplvt9EPif2RdzlgkrkBvuPOgYeqflY6sZKlSyD2YaNTzIe0M8lycrN9DLh7O/cX0LSi8JFXjqDeSeTdesIaBu09lcYRc2TI75XXSgHA2XhqMf9i0JHNc9XdlP8Va77dk0DQeFZHEQ9ZYdKnw0bbLXhskLXwPYbB7pdQbxNNB+VzPcWzkOHWKPJ/gGgfCvlxcx7uWFa28jhwQ2Yxx5af1EZ2go41N6Z8OKU4S5/LRVu2EHNOUFhyJvzSg34OAN8n6m8IBc5m/Zc9mKwaViH/jSE+wUUMT3vtlASqpRT4ULz2vEKbdhYxHQ8sHv3GQSDU6V+RK6aP29joXp25jy0RzFoLSMgbwMzqhmJob6GKI95WAYgbY1HauH1czx5uYYebHdGTLoz1lCff9PabULuipWqDaNeq5h6JsgZUF6CsqXzzO9snslmT0MoFR5tjDLg79Ofj8vqRhK+WRx+B2n5WNQm0mW1engvgfUr5ALgDrCxlqC1Ohx9GftMDlD2Z0lb7n0M7zx6vAcDHWh5o1EtkFGnsp/fswGAjU8gezmJ6fvIcXoTtiZKP6YJZVMegPJTJ9xrG6KRmVr732Sjgi/nA9n+BbZDwZfxHmyTVKpd5l3OLgIvl6Q2/gvOaft9BYPY/mLTRsAWw7euLKvw1C57sKZwJWCu5ngWgTWJwP6Xil7APWdyxivlmPPOA1PJxJjAdcYki1B5xUPfPnSOWGp4vD8svZQ55Gh7MZAn5EiCSFn080OycmPR72oGJ
 HNPRVbNp
 NEv3BrxJPD14Ka+DID8MgKRr6un9CUJGCaPMrFkYRd1QnIn/Cxn7JW9SJYlQG+lwKc8EtTqpkGrlWiWJjeEua3sQThhNu1KPFg0npBtuxJykH6EePCVvjpO4Y0pZfsecwVmBUDczfIEv3Q9iugI7+e/GYXNOPx9Z9gx5vKlor2tOXSXNaUeSA1WNLAETcqunuPB+xsmPACvndBJQLOFRUAGg7NYGuQUdMLb5pFEw6dgy3FdURfE9IOuKoupVjV38LodL+V5zfRtMkNGMr0zgVqCxB171eXo1/gDHalRL607x7/BPs64HcC+TUe4SJxx8CtlRkxI+28HAm4w6REFXCY3m49ysTjAunX8O7cRsg22KA2JucypiFTOZVEIYhYhnKMiVeJhdQSpfAH3x3ZFIUB5HWAVrlsNq69nm3QzEkHUm5sgsqbHWtYBwBncjlWpSyBadtq2H9pFDVY1CeCWBPqvX43f6b4K4/YsCiJN8GAPXfcoVpJnoFaxfytbS3nEyctGu/8nMs8l0uNJTHqWDB61+ITvjbhqFGv/7Qsdor+ZoIwYeyej1ZTIUJhQki5i4LO3jfU7NQXWL2GSG7GyfegS1D/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/20/26 11:50 PM, David Carlier wrote:
> A failed shmem swapin frees the swap slot and leaves a PTE_MARKER_POISONED
> entry in the page cache. On truncate or eviction shmem_free_swap() passes
> that marker to swap_put_entries_direct(), which warns because it is not a
> swap entry. There is nothing left to release either way.
> 
> Skip the release for non-swap entries, as every other caller already does.
> 
> Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
> Fixes: ac2d3268284b ("mm/swapfile.c: remove the unneeded checking")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>   mm/shmem.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b572c60f2af8..94f2c59c8cfc 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1184,6 +1184,7 @@ static long shmem_free_swap(struct address_space *mapping,
>   			    pgoff_t index, pgoff_t end, void *radswap)
>   {
>   	XA_STATE(xas, &mapping->i_pages, index);
> +	const softleaf_t swp = radix_to_swp_entry(radswap);
>   	unsigned int nr_pages = 0;
>   	pgoff_t base;
>   	void *entry;
> @@ -1200,8 +1201,9 @@ static long shmem_free_swap(struct address_space *mapping,
>   	}
>   	xas_unlock_irq(&xas);
>   
> -	if (nr_pages)
> -		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
> +	/* A swapin-error marker holds no swap slot, so just drop it. */
> +	if (nr_pages && softleaf_is_swap(swp))
> +		swap_put_entries_direct(swp, nr_pages);
>   
>   	return nr_pages;
>   }

Makes sense to me.

But another issue caught my eye. Since we already call 
shmem_recalc_inode() to decrement 'info->swapped' when handling poisoned 
entries in shmem_set_folio_swapin_error(), shmem_free_swap() still 
returning 'nr_pages' for poisoned entries would cause a second call to 
shmem_recalc_inode(inode, 0, -nr_swaps_freed), thus triggerring 
WARN_ON(i_blocks) in shmem_evict_inode().

I'm not sure if you've observed this warning. IIUC, shmem_free_swap() 
should return 0 for poisoned entries.

