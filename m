Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E99F1061B0F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C7B6B008C; Mon, 30 Mar 2026 12:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613C66B0095; Mon, 30 Mar 2026 12:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550366B0096; Mon, 30 Mar 2026 12:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46C3D6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:36:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA50DBA3E8
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:36:34 +0000 (UTC)
X-FDA: 84603282708.13.28839DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27AC918000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:36:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l2pglG4S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774888593; a=rsa-sha256;
	cv=none;
	b=WLrkrRoE5PXg1qqKXhuA9VRm+qJxlCfprDhSXlIzccO0eTEIdUUnIgGVXa12nFRzg4GgrC
	jMutz/6G8FggaY35t0FCa9YG1l0IEbBczXGpINMdM8tXs/LYIp2g2e+e6dZOfmeDyQRBTZ
	v5eG+6PYBqQe9bnS3lUQnvGCbtJn3vQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l2pglG4S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774888593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKsunyI8gz7jUrn930DICJgEkX1gHpshoiYpQmo1gys=;
	b=G8LTAOCgvpQs2y7gItpe1IRjQCRzSgf37ORFXir2lFw1RxZPMTN61tIGsnrkVbt59OSULS
	lSh8eLkI+VttWH7ZlaHiONVOWkXWp+zt+6vwfb/UH+WAa+ez5jwKe35C9JDGQduOoxDnUm
	QfFu45MytpsubYQ0m91m9iT8Sr07/GE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F9E36011F;
	Mon, 30 Mar 2026 16:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFCDC4CEF7;
	Mon, 30 Mar 2026 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774888592;
	bh=anKl0l7R5c+w69kw36S4RIdGWUZ6FVWmpssD4MxoZN4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l2pglG4SHR9jCapiqjEkHhpE1dKCDO3YV4lDIYqtL0/kNMkYmLWUF9eGy21+sgmMY
	 8AJIcgqeWayh13xWk9+pe+llp3FCMDF5VFRkvDtgtrFrSRFhXcM9rqGPWmJ1fQSW2M
	 g4uOIORrHmqmH6VC28UgRJ9n26oSIwGQgBVHzL8qn3a2hBFi81D9+kJf3vnIleySgF
	 O26CFWHzw2vPqymqR0FBk251Jz2iOMkJTcPREz9j55S/LIdB1XFUEWdNjBb+7DkCrI
	 Q+8NZvtpUxzLrjXyj7+MMC/DcPJEdatv5q29U8LfulwQjZcLF+8ziR4uMGceW8AAUF
	 ymbXZ35d8o5kA==
Message-ID: <85f960e5-4988-4fef-9ad5-d5dba580b88d@kernel.org>
Date: Mon, 30 Mar 2026 18:36:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, KMSAN: Add missing shadow memory initialization in
 special allocation paths
Content-Language: en-US
To: Ke Zhao <ke.zhao.kernel@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 John Hubbard <jhubbard@nvidia.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev <kasan-dev@googlegroups.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gtdmjodi137gjwoh75fumhw97ko4rtiu
X-Rspamd-Queue-Id: 27AC918000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774888593-809275
X-HE-Meta: U2FsdGVkX1+yxvMaHIMwrlCH5yWtXYun5grNm+XVz/xzw570GtDyT45l+eC7D7/Pam3MkuJmeTtPLRlKLQ96DOfUpq61dJEkjrGVZPLW/bAlwe09B84NpCgsrkIwVkVyG9fkMCbOygJ+A6pc13odrjkoQQKJgWPUyaX5H5PXJP68rkqtx967+6tCoBWFf9oaE9ifNALhyzFg1OO+ySQscZLmCFMYfhcA64bNlrJ+zyN1YTNS89J3oqClN03zbpFJ1nMbRIvdmqtPo7emlg2CrAnHOvmaeIdKmvRt4rLvQJ9gweSzT/dISaCF3gwMHcbHI493tNMNABqD/ApOC4cvR4Zd1O9Pf+lDLxozL24FadeYNr/G1iB6UfE+hw9B6pX0NVr7oVGhE8MPIee4eY2EQC9TQs579nSFhlk//pnSRwxMc4iQzYbAJJNWhZFou2AlN+FM6Gi1OypXiLYlaxc7Fn/3fJ/EgbYjZCIdleTir+POnX9+M86yOYwJ/9bsDe6Rc5yugUf8/St0FPL5z9+CEukU6Un8AlVizCoFZ1YyjuXvMTXCs4z0AnOOgy3oVP7Hyj2CUjmRQZbvoqmbHeFlcLL9XMhq/NySQPjW9Af8ohXJjrKhkmbY3bhYBAMDKDBTA3/v2xglqR3S+jZLdb81aWDxWaWiWvH15FasAUQj4jbM0TmgxGAOKimg4NZeuu3u7wKa8jLWMCE00IqNLae67CWSP6Q5P+xnHiNZ+b8XIT8gChLKkiXeBsUN1YeiHzb6oWMrx/+OkUDquijR1GSpW8+P8Fc/veQSNLqtALs9cIEDfZx4H62vmaiTBqQ20Y+md/rcQ2UltMp3Lx1PUZtlWFKLhH+UMk77c6jA89xUJ8xfKr59DGePLGazT94vPOAxhk0dnxffpWkKnm0Xy9NgVfTcAMHJXw2s6LAc6frigBc56nwzN1D6Ka1GWnQeyBQLIkY/2JNadUgue0ctW+r
 TyN2d1Av
 B+ZEmzwCNR7kfEL0ldKJ184s9P4NLeRM+4VsBOD3L2U0XoXJ+quwOR7uSIcThpC4NEHWuqIo6ox33axqcsmKxfVrHxjYAFuE89Dz5Fs8FCjn2KWO7JXeAORXVIYBKbP25ZNdJMb3dM6BLFtJtTjlDtF2inBgTf+ZeLoN1qiHc+NOrH3L3G6yk7HqsDYYLgXfpP86JQjDz3C2UMAdvQZnmZlzH4rM4elCvxoLTzX14RK2YlM2uEImTS6V/pJOCvb5Md24vQYxbunAZkw4Ge8q7H5EjIim9+woMqn2qLUtW/qMKLil1UYVjx/bUP02YWePtXH0hTAy2ctN7iq9zJeKdCSZDB1yYe6xWxQlFIESle6guOtE0MdwettoQi3XTJuAcBN2P8I7t3MZ9dohAHptLqpFGqsTh1EkRCoMz7/CV6hbvAEgIVERCvx5WQx2+4rGHjnIY//RTG89fwPl3kCgHii0Bk9BVK2XhJPC1WmBO8mnwDca0PgBuH+edwpimgqglL12SZ63a+m2xpYOeRYP97zkqSQauv5Q1qLuY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc KMSAN folks, please review

On 3/30/26 10:36, Ke Zhao wrote:
> Some page allocation paths that call post_alloc_hook() but skip
> kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
> Fix this by explicitly calling kmsan_alloc_page() after they
> successfully get new pages.
> 
> Reported-by: syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com

FYI the report thread:
https://lore.kernel.org/all/698f1877.a70a0220.2c38d7.00c2.GAE@google.com/

> Closes: https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34

Did syzbot confirm it as fix? Wonder if this submission alone will trigger
that check without some syz test command or whatnot.

> 
> Signed-off-by: Ke Zhao <ke.zhao.kernel@gmail.com>
> ---
>  mm/page_alloc.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..6435e8708ef4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5189,6 +5189,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  		prep_new_page(page, 0, gfp, 0);
>  		set_page_refcounted(page);
> +
> +		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);

Probably makes sense to add that here, yeah.

> +		kmsan_alloc_page(page, 0, gfp);
> +
>  		page_array[nr_populated++] = page;
>  	}
>  
> @@ -6911,6 +6915,12 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>  			int i;
>  
>  			post_alloc_hook(page, order, gfp_mask);
> +			/*
> +			 * Initialize KMSAN state right after post_alloc_hook().
> +			 * This prepares the pages for subsequent outer callers
> +			 * that might free sub-pages after the split.
> +			 */
> +			kmsan_alloc_page(page, order, gfp_mask);
>  			if (!order)
>  				continue;
>  
> @@ -7117,6 +7127,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, 0);
> +
> +		trace_mm_page_alloc(page, order, gfp_mask, get_pageblock_migratetype(page));

But I'm not sure we want to use this trace event here, minimally it would be
inconsistent with the branch above using split_free_frozen_pages()?

> +		kmsan_alloc_page(page, order, gfp_mask);
>  	} else {
>  		ret = -EINVAL;
>  		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> 
> ---
> base-commit: bbeb83d3182abe0d245318e274e8531e5dd7a948
> change-id: 20260325-fix-kmsan-e291f752a949
> 
> Best regards,


