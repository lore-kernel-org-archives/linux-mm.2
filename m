Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF67EFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 10:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5D36B0005; Tue,  5 May 2026 06:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276E66B008A; Tue,  5 May 2026 06:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D846B008C; Tue,  5 May 2026 06:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08AF36B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:46:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5CD71C0DF2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:46:12 +0000 (UTC)
X-FDA: 84733036584.02.F914311
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DFFD81A000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:46:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BRRjlRRR;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777977971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tP8zmJRscYVdbG9ZEwTpuNYhRSdN3Ymam2PGSKyV8BQ=;
	b=vV2iaTMi2J3iyyHthDsBv8qMXNmh8oe1Vr8hZ3jDah7hIkt8TklCOeZNtmmKkcNXXpIYW+
	AetvkwwF84XOzQHRSarSieiLTIOUIAZWLoIA0cDM9DnmLlWkadiqJ9tXWPx/m60D04EPeO
	j7hVk2nkqV9JosqMySWM6L8npR2YHOc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BRRjlRRR;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777977971; a=rsa-sha256;
	cv=none;
	b=3U/ICgU59OxTujwJXTJ79q3HfD/MSib5jRk1B/7V5SuRPD8bGjaNF6URcc2cGC7m41cJiX
	ofL2OFq6tr12iWlDdgSt8LTeoKh2SyPIu3lebm9Ir1e01+3yN6f/VrSM6mvII5Y8g32kTG
	oIhwjQqrZK1UE2gxBFUtcZ93rI3S5mU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D944F4017A;
	Tue,  5 May 2026 10:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505E3C2BCB4;
	Tue,  5 May 2026 10:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777977969;
	bh=+GNY90dzTILC5CDafZz5WsKt74hrsB3DqDY3Q/XEH6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BRRjlRRR+nmnd8jDCl/yDYBBP8BJ0uWyuuogsOhF2nKQ3grbbRG/+U3LA5c+ij4TY
	 vJFv4EU328MUB2ofyxWqTt3tX2jszVkVh98P3Akk1vIYzzan27vwDYjkAYMkYTPmnI
	 ofAzG9yjvC1dmm4nueiEHxmNrcNrL7uPIh+fZwxiybGfO2aMzX8ntgr2wWTc7uDJjg
	 9srLQvOGsvNq8zY1pnd0JeLKXhQO/GvCXzHoHKhMLlQPjv0uypqkEO/tsEsxShxvnw
	 zAGISLcLExl0S9IuJwk3rk/eLOTYvunWoajPfWMkIBvShpEscz1KcEnNBtBJmXl70l
	 RRvNyEB35YX5g==
Date: Tue, 5 May 2026 11:46:05 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org, 
	ziy@nvidia.com, david@kernel.org, lance.yang@linux.dev, 
	wangkefeng.wang@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not
 supported"
Message-ID: <afnKLEIaUd5A22ls@lucifer>
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
X-Stat-Signature: h3hoeu7b3mhiyrye57ww6bsdq4419edp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFFD81A000D
X-Rspam-User: 
X-HE-Tag: 1777977970-233491
X-HE-Meta: U2FsdGVkX1+qytjuPvceJ3H76yC/fduiExn2QXyKhR2GH3d7LfdCfWtHkNozKnIexZGDWauiYyGX5tSjoZodPnELyoMCfN3nvfi9aHFD8bwcnZpi7P5FOSom0QxNnHfP1RTgpS0abpRxSu+YHUaaGcv5emTvrr4JtAElNchVmv6iAsUixLBgY3WQ3GW7o29XreJmKHEhd1rr7APZsajVHpGKCroJ6rp2BY3hOERo4NGGLkZ4ciE9aKhZZ1Y3zTQUYeQ7Fm0vMRpeqIHpM+rDqlWTocfKNpCsgQNC1DRFRoxtxfS6mY1N2O0A7/7WTJ+l8T6JO75ZjD94Z+FKDVVC7ZUHfzKvU47nRFHpAgo5/qq6eH20FWFgDHXkuGkzYnSvRRun/xDp2eympFU2/DVrF1QafAz0JV5i5SSRoY7WBr34ZanjRZ7AysR1EZIXxt12TKDgEWBdo1hZrtYGU0gL1q1qofcww52VEvmHtDJ0TicHhXsfx4APM/rua9Iar7SGpeBpO8I5VNP7grMA3zgzdcOc9sR8vDrTsUdfFgNX5+ONTuHqCRPfU1AZfxqR+ADhu8/m3sm1aVFFfOdEG/8iDrzzQcPdX6q0uulq9OA4igrf6WmgH2N7sTjiIL+rUv20LvJ+vpaPJ91vAQEEetWIMsf3PZ2vl56+SKc25RPVMHcib0IA9ev0ZMo3QHqKzUMHkFyiszJ1V6Ic4M3OIlhjr33jB+qtcShn4hmI4HMC4s/sFb/QQxptJ+S3xtvEy1hLk8qq5NFRBbeGhnz2s78N4/sL9ZwgEtCatAEHVeafEvm9dQayoMLcboJB23Y6fidw4tmA9YROus2dvc+1yHk8+FBzBMXcQ4iZbGVCQxbhs7NxC85tPWfvRs3s+tNLsRVGBCZBCqfW8G5gEn6bzsTrkjNzazDVQeeY8zUjWHTwzboYQ1GNf2fI7QLF5IMDeUtSHlITifYe0tw9mksZh+K
 Lv000e0x
 cWrP08yb3KJHT/nT93fqNSWGcbrdZchBAirJ2pGRizpqte2oti4MYxdlCAQUxmhkg2XMw50/YYqBwwQf6fY1bchlqGmuVVDwGDDAcuogK1Thznqfl0uF5Mm4ZH1UNiXfTb8vskORvPGwfwlFS1I3LH5LocNGXGRL2SwEClKfZTA/sZmoQ/5gq/ghMjAhG/4VGC/+Rpkpw0WEh5rlcP0aUfQ3Fc/gYRXRtnxO0szzBjjHv3lE+sEQIqivPzOHWpdrGKC9Qc9tl4RAZqzI/SfksPvZmvePs4zhyMoS1r6IXoAztD/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:41:42AM +0800, Baolin Wang wrote:
> This reverts commit 5a90c155defa684f3a21f68c3f8e40c056e6114c.
>
> Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
> determine whether the shmem mount supports large folios. However, for anonymous
> shmem, whether it supports large folios can be dynamically configured via sysfs
> interfaces, so setting or not setting mapping_set_large_folios() during initialization
> cannot accurately reflect whether anonymous shmem actually supports large folios,
> which has already caused some confusion[1].
>
> Moreover, for tmpfs mounts, relying on 'sbinfo->huge' cannot keep the mapping_set_large_folios()
> setting consistent across all mappings in the entire tmpfs mount. In other words,
> under the same tmpfs mount, after remount, we might end up with some mappings
> supporting large folios (calling mapping_set_large_folios()) while others don't.
>
> After some investigation, I found that the write performance regression addressed
> by commit 5a90c155defa has already been fixed by the following commit 665575cff098b
> ("filemap: move prefaulting out of hot write path"). See the following test data:
>
> Base:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
> dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
>
> Base + revert 5a90c155defa:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
>
> The data is basically consistent with minor fluctuation noise. So we can now
> safely revert commit 5a90c155defa to set mapping_set_large_folios() for all
> shmem mounts unconditionally.
>
> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

As David asked, should we have a Fixes tag? What about cc: stable?

Cheers, Lorenzo

> ---
> Note: for more investigation and test data, see:
> https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/
> Thanks Kefeng for confirming the performance issue.
> ---
>  mm/shmem.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4ecefe02881d..dafbea53b22d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3087,10 +3087,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>  	cache_no_acl(inode);
>  	if (sbinfo->noswap)
>  		mapping_set_unevictable(inode->i_mapping);
> -
> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
> -	if (sbinfo->huge)
> -		mapping_set_large_folios(inode->i_mapping);
> +	mapping_set_large_folios(inode->i_mapping);
>
>  	switch (mode & S_IFMT) {
>  	default:
> --
> 2.47.3
>

