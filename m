Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70639C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 03:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EADE6B0144; Thu,  2 Jul 2026 23:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09BD36B0145; Thu,  2 Jul 2026 23:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD196B0147; Thu,  2 Jul 2026 23:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B946E6B0144
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 23:50:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 102E116867B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:50:02 +0000 (UTC)
X-FDA: 84946087044.12.80F58EE
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EBA480007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:49:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IudMrMT9;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783050600;
	b=dJi50/pXpxJiuYNEaTL2GcNLKMkYuXOorjP2xKMTCaZvoYuAW2O2Jj/cWho7h2GdyQXqoA
	8V36H6AimyGjC04qjKp2G+j9GBK4Mf/aYJItwCmSbRzJ1wceLw8hR4wMKf9o0vO8uEZahT
	x4VcpWK1wycq1YtuB6lrsPwvBB29iLo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783050600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XG2onznUxb2a1bjAl7eu7EX+0tUl3lnnp+uaCTwK2zc=;
	b=dYyl7tlhQycU+djbC80L12YIMTFG49wIqKzDdLMCc7SSvgQ+s7rveMJ/4nyH3WGm+qBDMm
	UMZ7o2lvL844WiZl5l7fGkLy/NZ6AjB+49xW87VJOn02t6hvhZb8iPjARRzcPLVZhwn+S2
	+es/TK7UW63UaNR8fxJE5HRa8KBy4nU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IudMrMT9;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783050596; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XG2onznUxb2a1bjAl7eu7EX+0tUl3lnnp+uaCTwK2zc=;
	b=IudMrMT9+lPk1sjRVPyycDCCyf5DE6rFfCYTLCCHBEhqu4HBFQRp3hZpI+loW/JaeuHt2TARZBBjgm/m+aejPG6mpROYxCORikNgIFDBsQdeSILWGIVmNuetTBL3Y/v6wedKyB6XteJlkOhYRzbBcwGVwujQOvc0/b1ghi0QQkQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0X6Hnc.J_1783050593;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6Hnc.J_1783050593 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jul 2026 11:49:54 +0800
Message-ID: <110e92b2-f7a6-487a-94a2-25ef1242afb7@linux.alibaba.com>
Date: Fri, 3 Jul 2026 11:49:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Song Liu <song@kernel.org>,
 Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>,
 Gregg Leventhal <gleventhal@janestreet.com>
References: <20260702165409.164568-1-pfalcato@suse.de>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260702165409.164568-1-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: emzndmpcqu1nkx1ypehxwsrtq4z6jr54
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3EBA480007
X-HE-Tag: 1783050598-625465
X-HE-Meta: U2FsdGVkX1+RjdanouKSrXUphWZrFm3xFsvoFGTJ4B4JE1Vbe84bbIWsNNOqukRQCcK892OibdiwJ0fnY12Tko9MtmKUI25EASKE3iGtWRPRdKzPq38of8qEymAs/1wxzCVMoq4Ir96sOtSEVKEwnFTSSKNOFIOsUOiiBugO0NTJDANu27lLAv/wjP6L4fOyl6b6tKyCUBjgLEu59BSuocHcFQAyVpq/GzHs/aItX6Jgne9daa1OLLEHz34YHi/azhFkJzdUXbqHnKcTLwFgMO8kCyjG4KUDRTG75QFirV8UiBfA4JOqnMRAy2zPe+FtNUCgFIbrsBerzBBb81GPOWBfBCjUiQJ5iDZ0Rm0TuqFatWkZQWo8EGZN+1tBcXmiiYTx4mSvA/Uz+tiq61VkEyp3k4t9ky1ThG4qIDb1LOj8dgBoTXCbnaIl7L+bY9dicFDnxlLtziS4W6aNP/KQJiYYF1GokjkeDgKySFIIVixgkVezN5Pr8ZHb0WPUaZKe4XWPc54F8iPTcvFcBv9BXajeUa+KF/jSaS3jYe6Z/ym9aLcXBm8wvhtWgxu5K77d93ev9Wgp8DVpdJF2niKvDzzW9XLhcifylU4YNsCPzpltNpFsj3qpBOaMtg3TPRKJzLjyrmxUo3vG1MRYWxO5BPXir7pnvq6uTGzBmKfOcZ/IwUQtxzuZ6GT6gF8fHJFUtldi/c7wSNIbm8bCJ82u6QaqTP0kwo3Izq8f/GL2v1BoihmiCPXv5i+djYplNhA4p0wiW8qxWWMh8g8LZJJbjOEfBRzX3CUCAbKg87QyjBFDHPjDkUh+q5Tcf/hFGqm2IparZ6Y/IU//pq6H6g7z8hC8AeWUgkatRjhuXtkKKKx7StUPznZcZWYHr/Qa8qxM2Y3pnK/6B8mTD7Nd8fosEk8BaJCB/rHMfmLZRcJo1G3dZWzxOWqVuh0fy7qglxtfqMpopWGwtJ2NRwyIMuB
 Pv610P6C
 s9iuEjejwZWodzdDo1FAD/HhMiGeM1gxcq5igUEvuVcaohZLYXCMjW77Vkqb43eaLpjZEGUPjqNKkud2/he6ZcJUQmyCwrLkjeVlqJYPLYswBDBbH12oSng4ZeedrBqyOZAtFvQGuXBUFqh6VqNzRKgyDOYzmgIqgUOYoMUOPtMc1mq7PJCrkzkYLgQuM8YJDEJteUMKIiboxIOhokSK4PA8Sc5frfIYDe2g8vNJya/HIuDl4flVMmTqjBzZPFbTFrfNpr1CyhnJOFoQCz0Ml7LGBuGtbcUKvnX4tmD4G2nQEEhkUE+7tlwiGKJNEnVtAgH5UxNc+SHMCuWNDyj4K/Whnjcy3rOCnlRWEm+/OpRTijy7IJHgoh50pA3EIj+zLr6QEHEUpy88Hjq0AO5q5WLNS6DJmZ3B4O6Qsnz+E7ACu+aIVYPS06C9SrxaVmQfPTqA4YUuVpF1u4vh1ECOKRzrqn8VOkn8jFAIVlVHWFaJZdQXBtomhskmIldTnBUl8UIv03w1x2/tDnLFljfBCnr2O7Isl5tiE/WwMqHBdmongnCAup56C8v0Vow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/3/26 12:54 AM, Pedro Falcato wrote:
> As-is, khugepaged and writable-file opening exclude each other. A file
> cannot be open writeable and have THPs (because the filesystem is not aware
> of them). khugepaged will never collapse file pages for files that are
> opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
> particular file is dropped. This is fine because nothing could've been
> dirtied.
> 
> However, there is an edge-case: collapse_file() might not be able to
> coexist with concurrent writers, but it can coexist with dirty folios
> (from previous writers). Therefore, the following can happen:
> 
> open(file, O_RDWR)
> write(file)
> close(file)
> madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
> open(file, O_RDWR)
>   nr_thps > 0
>    truncate_inode_pages()
>      /* THPs are cleared out, but so are the dirty folios */
> 
> When this edge-case happens, there is data loss, as the dirty folios are
> fully discarded.
> 
> Fix it by fully writing back the page cache (and waiting) when collapsing
> file THPs. Doing so provides the guarantee that no dirty folio will be
> observed while there are active THPs. To fully ensure this is safe, the
> invalidate_lock needs to be held while doing the writeout, so that
> do_dentry_open()'s page cache truncation excludes this write-and-wait.

Thanks for explaining the race, and it looks reasonable to me. One nit 
below.

> Cc: stable@vger.kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Song Liu <song@kernel.org>
> Cc: Eric Hagberg <ehagberg@janestreet.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
> Tested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
> This patch is written against 7.1.0 (because the code no longer exists in mainline).
> 
> Zi, I kept your Tested-by, but I had to move some things around and
> use the invalidate lock. Please re-test if you can.
> 
>   mm/khugepaged.c | 39 +++++++++++++++++++++++++--------------
>   1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..0707d719a270 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2094,32 +2094,43 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   		goto xa_unlocked;
>   	}
>   
> -	if (!is_shmem) {
> +xa_locked:
> +	xas_unlock_irq(&xas);
> +xa_unlocked:
> +
> +	/*
> +	 * If collapse is successful, flush must be done now before copying.
> +	 * If collapse is unsuccessful, does flush actually need to be done?
> +	 * Do it anyway, to clear the state.
> +	 */
> +	try_to_unmap_flush();
> +
> +	if (result == SCAN_SUCCEED && !is_shmem) {

Actually, the operations below only for those mappings that do not 
support large folios. For mappings with large folio support, 
filemap_nr_thps() always returns 0, so the race described in the commit 
message won't happen. We can add mapping_large_folio_support() here to 
filter them out.

if (result == SCAN_SUCCEED && !is_shmem && 
!mapping_large_folio_support(mapping)) {

Otherwise LGTM.

