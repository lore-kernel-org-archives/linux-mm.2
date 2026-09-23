Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83132C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41436B008C; Tue, 22 Sep 2026 22:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18486B0092; Tue, 22 Sep 2026 22:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9559B6B0093; Tue, 22 Sep 2026 22:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74EB96B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:00:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A26880683
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:00:46 +0000 (UTC)
X-FDA: 85243373292.30.31239D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 484161C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:00:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="T0gr4/Nz";
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790128844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgnbZsTT2zcayHjjrB3oBDdwR1L3daWcHEyuUmxEqnk=;
	b=zGitUdCI7bMTDbqBICDw5+5+b7HfrC0sz2U9ralKWjK7DUPAnU26ZiqlJjR1uvqSnEPLp1
	o5DAY8ds8/y72vg25SHroXJNWb5aB8BhLy40ywEmvu284FzwAYWgtC0NMxJA2ntBXuqkEh
	3CZZEngYZLw9mbaxDxZXrgSeL66rh1E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790128844;
	b=J6TH2qLwKVbG/xSS2DHnjI6Ub+r6/Pxi7zv9n92o3RwjUV//JdGr37bCDV4W+FTDG/38QO
	YEOUn5C9M3qMATB2YLWP28W2u3rvoexAm2JMXDrjfGCX9jaj/fJv35LcOglem87pjEWDdG
	fAxU5R3ULstIf++T9P7CeuLlSOm8w70=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="T0gr4/Nz";
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF2B74031E;
	Wed, 23 Sep 2026 02:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521371F000FF;
	Wed, 23 Sep 2026 02:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790128842;
	bh=xgnbZsTT2zcayHjjrB3oBDdwR1L3daWcHEyuUmxEqnk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T0gr4/NzgHZOuAxvv+LRhMyimhsIk6HOCvaWDuDBnT046lrvNapYf632JUmo/2saz
	 2zo6NKareBqVAc4QotDpYKkXYKQLutCSvDkYJnyM/N1I++IwSaLzM3Hts5WGKl8hj7
	 VxbUnSPdS1dUNkiIfiHHU4vbveXIDe9quUmagP8U=
Date: Tue, 22 Sep 2026 19:00:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
 <aiqi.i7@bytedance.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH v2] mm/hugetlb: fix overbroad MMU notifiers for unshared
 PMDs
Message-Id: <20260922190041.d5d983ba6fb1475e40568eea@linux-foundation.org>
In-Reply-To: <20260922090749.24905-1-lizhe.67@bytedance.com>
References: <20260922090749.24905-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 484161C0002
X-Stat-Signature: 7cnm9xj8hdrj1icq7otegm63943493zt
X-HE-Tag: 1790128844-342745
X-HE-Meta: U2FsdGVkX1+BdCPf3FwKa0CrV2t8rJhhFquTYignOseJcv5W/KO/9ZiWAfD4UZ/Q0uw+RUWhcObw15cy6BL4m9LC0jLc4+kmrk1aIWkxAqvk2lrnVuzLmvVIzs6X4tMV+Iahb/mhJs4nbXdLei0q1KwJHziOA0azt5MK5q/p4m+9xqCN9/amNHly9COW99MCtpNZGiQ/QWgMzLHY6YaZA12XVNaPLcqU1Cv5/guSympcGI7OzEIhHxwdq5LTf9IvTwhb5p8dq0ljOOyoyPde3bPmF8Ybz86uaV+LzT9gCf8sYsHM8nqaBBAgAI7uv8FcAhognX5fQOH3+7YEqKWOjfzaa/dkOQGzt7lWZ388QbNRv0E3J2s9qtnpwrDPHZnoPg0hRazLyPy2P+McjJKDoBorw5NjHtRvf0zJjeIvH6eEh/Fm5nCbNWoytiCTmoHmznuKauGJ5BFit+E7sG91wwTlVuOO5zJsJE1P7gaMGeqvdf2xPPOhDIvSlrBYAtNiZah81laE9xWccGlGiplHd9SNyD8nVqC24vaAo1mIhf2zFK6xm1uLsbIoN3Y2pwt0xdpJAPwxrZJobZ0wak5LvOYe5v7OQdJAG+VQc71QdYSTJf4V+nnYJug/063X9IyLV1yKqfBPPGIPuO839QYCfP+ZNlwYa6caoTO6qPkGb8HQHApO3yP9L/98Gsd/IWsBa7ovdUYBUZcYKQ6SYte4AhqAtrA2B1igOeEPYEBBTui1KdCkPoQhywewo/hNuIklH2r/wXG0fWYNUyReVYYSkYXbrAUACAuMcgTtxFU+gTJkcX7J+oPVyCQo2SqHrjWcgoUzFv3SZV4Ej5AdMmTfcvj3LKbxdYNBJ0DNwaVyu3aM/64+wil+x3Y19Q5DqllCOrMOiy6iy7dzgTsPpErFl1FDCXK8i1FdIKHd2xfXWnyTPhLHkiSoc5Xe/IwgjT2OVldjeYDCjKFGwFqR5dv
 uJDi/njx
 YMVs2LMgXD9iPRGiF44wIzd2vZf+X/KYR28IY+tIUYtiBGbYIasSdG1RlS2pd9pIeJn0ONQnwb9wdGl/7GUw+CfTucsNUjbNbbMFvTQ++2It2WtG0JIy/s2N4rjEr7g+/b0fgye2+6+1CmLXTkb5sb+iRbCl9kTpT2Y9c9WVckQmyVHHpwz87HOpdKLJc3uf7Y2Bk7tr0t1eEYqMPk+hVV/l02ZJN4kGdGCUwONzuZiLv9n82gwTpBfe2KHMDf6lI2nB5AewJW+XwgqEq32ZdGzU60w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 17:07:49 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
> PMD sharing is possible. That is only needed when huge_pmd_unshare()
> actually detaches a shared PMD page table, because clearing the PUD
> invalidates the whole PUD-sized virtual address range.
> 
> For hugetlbfs hole punch, and similarly for other hugetlb unmap paths,
> a shared mapping can pass the "PMD sharing is possible" range test in
> adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file has
> never actually had any shared PMD page tables. KVM then receives a 1G
> invalidation for a 2M operation and zaps unrelated secondary mappings,
> so the guest has to fault them back in.
> 
> Avoid this by remembering, per hugetlbfs inode, whether PMD sharing was
> ever established for the file. Set the flag when huge_pmd_share()
> successfully populates a shared PMD table. For the hugetlb unmap paths,
> skip the conservative PUD-sized notifier expansion while the file has
> never seen PMD sharing.
> 
> The state is intentionally sticky and file-wide. Once PMD sharing has
> ever happened for the file, the unmap paths keep the existing
> conservative expansion. This avoids the no-sharing case without adding a
> page-table walk to every unmap.

Oh.  It's not feasible to figure out when PMD sharing has ended and go
back to never-seen-sharing state?

> On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
> improves P99 QPS stability while punching pages, reducing the QPS
> degradation ratio from 7.09% to 1.45%.

How realistic is this test?  IOW, how much benefit can people expect to
see in real-world usage?


> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -921,6 +921,9 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
>  		simple_inode_init_ts(inode);
>  		info->resv_map = resv_map;
>  		info->seals = F_SEAL_SEAL;
> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
> +		info->pmd_sharing_seen = false;
> +#endif

This could use a slightly modified hugetlbfs_set_pmd_sharing_seen() and
remove the ifdefs.

	hugetlbfs_set_pmd_sharing_seen(inode, false);

Not very important.

