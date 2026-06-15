Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3CFCCD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 01:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064FC6B0005; Sun, 14 Jun 2026 21:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35106B008A; Sun, 14 Jun 2026 21:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20156B008C; Sun, 14 Jun 2026 21:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFB146B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:50:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35BD4A0847
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:50:45 +0000 (UTC)
X-FDA: 84880468050.11.9DD988E
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id DD0674000B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:50:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781488243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sdva50k1gq7kyMFmAQ31CpVCizMYUcoJo0nxdLkBbg=;
	b=lzDfxQBE2L2uoV33QMSexN8zsLSNCg4v2lzyKd1/rKbcwoxaPhvcOJ1B0o3Op3KD8C0F9T
	Upj7i4kabdFjIdH3V2tjuRJ+WwEzoYiBCsS0vkCqhb8PMKfdH9mjgg8dE8nwO/JgLcjhJw
	hVrMUj9rqBTkOmmRcBzVxnqjytKQVS8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781488243;
	b=IcHy8MYLOoBnqTiOIcWBSRAVv85s1I2XkpO8r6R0hFQEB6JuTv9raWiRBHff4MmGLTJnLk
	kVNOf64j2FzR168CnU7JO2H/j9jXqrmNZgmhELNhy9scloAIjBteowoK4RdYLDvTluqcmG
	Or/4pwBTbFJMOvTXoitpnrsLp3xSS+s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 15 Jun 2026 10:50:38 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 15 Jun 2026 10:50:38 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>,
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/page_io: let block drivers register custom swap
 I/O ops
Message-ID: <ai9abo7GwMl+g43G@yjaykim-PowerEdge-T330>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
 <20260614-zram-swap-ops-block-register-v1-1-6c1a6639c222@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260614-zram-swap-ops-block-register-v1-1-6c1a6639c222@gmail.com>
X-Rspamd-Queue-Id: DD0674000B
X-Rspam-User: 
X-Stat-Signature: frwsjjhesn66xukjoxj4mhtmim35pxhu
X-Rspamd-Server: rspam08
X-HE-Tag: 1781488242-892489
X-HE-Meta: U2FsdGVkX1/6crdAIJfMwUoOSdMRXD3ZPT0TuK8U9xOWOl9CvKQ2FMVvL8qndv1fJtIgx3SmepW1vUqGO759MY1s7v+CbXfowbv1UZ6N0pcoqTwRM5XJXVZXAOO5PxaEFQ8L2NBaX/Nft3o1FzUefZV29nFrMi2lXEnMlJIRii1yt0YKDyOJ+cLwXupmKEwpferXT6rR+PxIJzKjz4KCsP+GV34ooEdChpaXCPWgZzntVWsDGPibUhWbgj6suJVLercp6KZdGpIp2HEkapm5Mwb97E28NqI2mDfZWWfO5rRcN0uvH2wggkNZE1MyGIzswb7Ic/hi8nJQuzlvXfbZQCiOhBVe1Dh+OENRQba1izXOHYIn8B4Gj4VvugIjol8H8laINrZJbOV/+OOz92y/2vKeNCGueaVOkcXq48T6Hf6Ir9WjgZamACp+1n7wMt5SXVW/MivctA9AxN/m7FTzf/YZ2WHjYTaermhQhZKZqIwafu2fEosIgt5Zh8BvTVs46zzjRuH2EhtXOdTuIzTIYYdk8Iy3rj7/WVShBqSTdkMay8BQm129Co2s7ZMRk4mTW2YutqgQIdRRbUZcjQRQ3/Q8ct+MjarqLs7kJl9VIUiJtv/5OftNY0wp5oYmqFv4V9S/JlHQcdWxbXGHae8QMKHHh5xAzBB8K4mD326UehZF9nczK+CM3ls3RoNxK67GWAGuaFHkCvtuv0EPfL5kqkdxt8ZS45+23T5l+2/e1jgr9cy7d6ZZIgE235oNGGtOpbL/ssozaCHmycjzbD4IVOeoPmWLC+l+AACWizprQ54RpssciyTclVxFjbqZBdTxlmx4spY9u2YRiI3FjY+znH0IdBB/lO29gCJ9OWK+TZi4i5Xqdx8SHO1HMZmXJU8EJlXqXm16/e3FEX6D+6Xs1YQZAMtc4zP42v1gYo+fPQaFS8y1isKN9bzOoUTW73P3/A1xs/aC3zn+2fb7QJf
 ilazbhRL
 4kPU8hDeBH31AnKsj74r+3RQcVGN//xOVM3Slfxqs2tH9VhSpDHFtc7QE7FUhimh5ZumkSqH3LiUU2Exwzmw9TNPQxvQ33BMYuAEzuf7kpd3f9vtaZX2LuB2GEYi5qItoFhwu2JJIbekPjvyLN11jfmPypCLrnnLnSEorHY0Hm3bi+kvmHVAgvnuvaUmcfSyxZQe0d37svW50ZMRSNap8dZiZzGBP1tyyOarIn8+/BMCR408hCkigQ+6xy/5RJ+VXnqpBHB/2Kv39VEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 11:35:29PM +0800, Jianyue Wu wrote:

...

Hello Jianyue.

Currently, the patch commit log indicates only a single custom swap
registration is supported. Shouldn't we allow multiple block drivers to
register their custom ops simultaneously from the beginning?

>  int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>  		struct list_head *folio_list);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 284eebc40a70..ebdc96092961 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2849,6 +2849,10 @@ static int setup_swap_extents(struct swap_info_struct *sis,
>  	sis->ops = &swap_bdev_ops;
>
>  	if (S_ISBLK(inode->i_mode)) {
> +		const struct swap_ops *block_ops = lookup_swap_block_ops(sis);

Also, just a personal thought on this part.

Instead of using `block_device_fops` as a lookup key, what if we handle
this similarly to how filesystems use the `a_ops->swap_activate` callback?

We could add a `swap_activate` callback directly into
struct block_device_operations (zram's zram_devops). This way, the
block device itself can set up and replace the swap `ops` directly without
needing a separate registration/lookup mechanism.

What are your thoughts on this approach?

Thanks,
Youngjun Park

