Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A438ED358CF
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 07:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170A46B0089; Thu, 29 Jan 2026 02:05:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B9B6B008A; Thu, 29 Jan 2026 02:05:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D946B008C; Thu, 29 Jan 2026 02:05:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E805B6B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:05:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F8205BA94
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:05:17 +0000 (UTC)
X-FDA: 84384115074.13.8FF7FC5
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf03.hostedemail.com (Postfix) with ESMTP id 297132000F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:05:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769670315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TUhT9lB26vTra+CaQ80rfO6kL8XAVoHXLey94kZC3Hg=;
	b=eHB29lrZl/mmBSyTVvR6ckynBpa/zGm50fiJwdXM7EHG2ZDsnEzmwXkzrbUKIaaQ5ojhvL
	FziUk8EPe7GpGQCTt27cHYcNjhOeZnjS1Nq7jyFnZnBM3zEuC+v7N8cK0G5U0tX8t4fMke
	6pVryfOmidWfX4M2OAr59nB+Vq6QfRA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769670315; a=rsa-sha256;
	cv=none;
	b=FLtwVLuJvjqzrV/NoZI2YHppoLJuol9tTykl6hNl6tAD2armCbQ5DIfiEfAoZ/qypP6Qdh
	bbr8PxhKFeDv/ROr3KDn56yxXt9sC4EIuLqaLmhCBZAdG9nY/52rsbWpyX0A3RIwiIZete
	Yq28ELtmks4tDRoiqQzMIlkUUMszBMY=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 29 Jan 2026 16:05:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 29 Jan 2026 16:05:07 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 09/12] mm, swap: use the swap table to track the swap
 count
Message-ID: <aXsGo1lh2oBLeG66@yjaykim-PowerEdge-T330>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
 <20260128-swap-table-p3-v2-9-fe0b67ef0215@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128-swap-table-p3-v2-9-fe0b67ef0215@tencent.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 297132000F
X-Stat-Signature: gi1846y1jdfi348c91fqb19f8pz9jnjz
X-Rspam-User: 
X-HE-Tag: 1769670313-645978
X-HE-Meta: U2FsdGVkX1+mDuvZzEkbIoYIfqiBhjqFUqQpCWvG1YNSCmT6m3iHcm8T/5YVEoNCBSzZlcRlY+yxbPzCcw3pkaEpXMkqt6pu4JdA7RYHxrCwQe7RM11RgWw1FHcNvn0trbFj5xshMpNCrVv8jG/Yds9/rcyhbheSh3WkLbCVQ3+HW0lek1/nPhALI/Zs8k41283wz2T9kZjwporFQnOZT7ts7G68TlgAlPzRYaxjyVrLfz2VAZcl/bvkJqBA2HnABX3Jk/ytsQtwUuBbnGr/RO/Xzd/PBREnGQzM6vXpyr78CJ+3XUITRBrikqQL0eMDeIZyUQ0DKgDs0bIt/2t5l/ALVOtSBndl/M4C4BUrxIoWTaKhXEpcRvigI60VtInWEz0K3n5p5hgAAcAds0vC6Cqq7+x1XLHT1QadOL+XSjl3npIl/BiQSxRqYK1UhuDZW8S7JBMqQzlDhPEPxkmiu7S+yBq0/Ok5mIwPLSIWUURA/Vh9M5WZemI6gd4K9hc6v0nns5YSZJVdjloVul+Raxd6HzM2UUCt0yXyyn2E6XzfcZROWlB1DAGT9aVs7BHKvETCRoqqcgrUger71n+6KY4gNT7lKPHxYxx9jwPv3Htf3SlshKCwPOZeu2GQKzVvKslz6iGMrEj54I+HE2Abns3JK0bhwHGDgOv24TlQFqsVkXxdSvXbBRgPTZa9VipPjVcMAZqxkGlYLLqFELY9erRwUJGDz8UopyZMuVCOzNkx0s+hd1Ukl0RVhdXqXkjA6rCbfyrFbUbhZh0ItGGq63Uwgo/18Di3DaxA9B/LfE6JrsCmNGC4XbZ41MvHnTOfGvEJYYElSfaBGMvLEDgpvZ3xXDfmcrEmXqgSM/BRxhgwUwcMB6aEAVsEMP1BCyZey2vkzsUQnqRBR9JK531GoBZP+UtHKLGcLx+vhmJW5vW6kvllLfFTGfT1Z7g88uUiVpJ8fTCSPXlLe7UtVuq
 xcvp4iz2
 Ow4VN+f4zCNhOOTS19Js7xUy8CbJdUOUGYlWczS7iZj+FPnzVIFadLH5xDRLmeDDyvL4/GxfsxQVQME2udRkZ66lVnEqe6wQ6wFSOu99TIKRgh2b3ZxsaAxUK2lb1zLtIMLKBbU2mNP03WVjHwAVLUFRNl85QylXqwq8mi5Ii/2bN2NvzJhRt0/AiaM+nT/oFt70JNHAK43lQQvgY2ylcbHPbmbBhWvSshCh0UktHULxc1L8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 05:28:33PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>

> +/**
> + * swap_dup_entries_cluster: Increase the swap count of slots within one cluster.
> + * @si: The swap device.
> + * @offset: start offset of slots.
> + * @nr: number of slots.
> + *
> + * Context: The specified slots must be pinned by existing swap count or swap
> + * cache reference, so they won't be released until this helper returns.
> + * Return: 0 on success. -ENOMEM if the swap count maxed out (SWP_TB_COUNT_MAX)
> + * and failed to allocate an extended table.
> + */
> +static int swap_dup_entries_cluster(struct swap_info_struct *si,
> +				    pgoff_t offset, int nr)
> +{
> +	int err;
> +	struct swap_cluster_info *ci;
> +	unsigned int ci_start, ci_off, ci_end;
> +
> +	ci_start = offset % SWAPFILE_CLUSTER;
> +	ci_end = ci_start + nr;
> +	ci_off = ci_start;
> +	ci = swap_cluster_lock(si, offset);
> +restart:
> +	do {
> +		err = __swap_cluster_dup_entry(ci, ci_off);
> +		if (unlikely(err)) {
> +			if (err == -ENOMEM) {
> +				spin_unlock(&ci->lock);
> +				err = swap_extend_table_alloc(si, ci, GFP_ATOMIC);

Hello Kairui

Just a minor nit.
If the extended table already exists but the allocation fails, the operation
currently terminates as a failure. It seems swap_extend_table_alloc returns
failure even if it holds an extended table. It seems extend_table created 
while ungrabbing ci->lock.

If my assumtion is right,
How about adjusting the error handling in swap_extend_table_alloc, or
perhaps implementing a non-locking __swap_extend_table_alloc version?
(I think the latter is better. it avoids unneeded lock - unlock - lock sequence.)

Thanks
Youngjun Park

