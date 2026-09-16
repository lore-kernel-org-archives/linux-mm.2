Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F427C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 17:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235F46B0088; Wed, 16 Sep 2026 13:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF496B008C; Wed, 16 Sep 2026 13:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086F66B0092; Wed, 16 Sep 2026 13:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D64106B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:38:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A24D160795
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:38:51 +0000 (UTC)
X-FDA: 85220335662.28.04934FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D16E2180004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:38:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X4BufaVm;
	spf=pass (imf16.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789580329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmdjUNL1XY7zBDucnHHtvP/PymRScu1lUWAizmkODYI=;
	b=GNvSI5N3eTZ+XZeqnGPb1lMmMA5NJN8RqlDdFKWqhwBB/brhsKDPTyRtXWQXolxxHm8aTx
	qyXKdDPnxrQ5fNoogCE4/IHzV+iqE1FUU51Fkh2+nTb4kD6qzr0iJ6pb/bHot2R53dbX7y
	4Cs1Ez+D8bxl4D2PESjPcmycF5A/z9A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X4BufaVm;
	spf=pass (imf16.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789580329;
	b=J+URNmK+l+c/y92w9ih5QgX3r2KhLDSNoz7/yU+iOLVXO+PDQmp+8os+gG2YWz1lx9EEzn
	L0IrwiPIAvp7iSBQZwHbn7Zkjg4pC2ncy4NMTBTphTdoU3u60sKQ6CY/WR73uBz49QI9fG
	W4EQC4YLgi8qVwhyWuDGrXgcmhXov5Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789580328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cmdjUNL1XY7zBDucnHHtvP/PymRScu1lUWAizmkODYI=;
	b=X4BufaVmFqhZw567ZHFqDRNk/0ruOj+1BrfVSSpe1+TmeOygt6tcfJtM8IZDhTVRsPlXOl
	B+4yybX/sFXhuXswLADA5CIRmnYWh+FL0l7vtSIhtimQ5k8Y0qNJjJJdUqdjcSQdCfWV1l
	N5K4lZstDhAQ2m9J8zklqGtdECX/5YM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-AEY05fytPNudNZBo7klhJg-1; Wed,
 16 Sep 2026 13:38:44 -0400
X-MC-Unique: AEY05fytPNudNZBo7klhJg-1
X-Mimecast-MFC-AGG-ID: AEY05fytPNudNZBo7klhJg_1789580321
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 817AA195422C;
	Wed, 16 Sep 2026 17:38:40 +0000 (UTC)
Received: from bfoster (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83CE21956087;
	Wed, 16 Sep 2026 17:38:35 +0000 (UTC)
Date: Wed, 16 Sep 2026 13:38:33 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, hughd@google.com,
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
	ziy@nvidia.com, joannelkoong@gmail.com, djwong@kernel.org,
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
Message-ID: <aqrUGRd0JClEZNzN@bfoster>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20260916092450.654408-2-yi.zhang@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: BOuamSkdszM2qVaDZJSPFiF72gSbIuRtaV9rNzoR6fo_1789580321
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D16E2180004
X-Stat-Signature: 4c3hmzodts9fj4rm88qs86ngi3c1yziq
X-Rspam-User: 
X-HE-Tag: 1789580328-519787
X-HE-Meta: U2FsdGVkX18Ygg10UUtY0Ch5UukNI2/T7khTNKjxLY+bJBZePZoPSil/SLKX8O0pnwXDyPcz5LWRfQhygvfV2Vduf44NC+M4tw/bENVw7Us+o8newcyl6Kzr4EBwp8224mUW6qZDbiM9oNEHT8JcJPk0PqUuYQQqwSvZlQ3A0GWBnLVvrx47rc6cJEqjHcoXM6kE0tgiqAYxnPN5zgAZh3+EMEgBtr4NEtg2JzBe3kje4siQY2tiuT9750CvCuTYCtXF1E9pS9J5SVtCVUHme+SR2DhshWOE6zd8rgZ+PD8rAep2LFmNQBHqS7/QJLs00BWnX6Soj+NYmcmkFQGXwxanYrSLhAMWyo/dKmTUrNuQkxcEiRZrkEm2bnbuaeNcXM6XfglrO/KIdSVXAIpYNbrAWBAN1ob0+HG9jjugwbZU6o5Omm2ICutNb2jARkmo7lhD2pxCqTBoFTXAIbmqlLhr/xd1QdD4LHj0D4jjUXnuFuUXG+An18+wD6wcMs+BrMPldLu/IvQkhbFcm1a83S4/OhCCdiascEWM9IBKBpXkjxXVcR1Ei70mgQ+axnCvLKGGRS2P2pPvVUe69AbMxlWntRzqHVXwOUYvT+7WVoIbQKi8AqedZMtOt69nYTGRP74PaOvc0Nj3vVRgCRGhc2CCo5iGpf4N6nMWHuS7pYhFJKf9KnQn/NCKMjU50PLFFHdYMR8f5oUGW6lcyumjKPxBxbOxR7zrczndyMY3IBRrMohbdkoBPZ7FNStLGqKjWWz89i4UVBilk5DgmbtDqSJ9JLBGGO06YiiOq9PLijb0wrHfBF/dpOCg1/H/nkLsSkEUQ4mWXaxSl0qXfvUgdsN4ERR5r6FYBJrSsAgW1pfDVWuwtuzHKxSBc9d26rXvdB2hbyD8jcKWlEVdYDmG2NJ2gcaiWXMyfNMlUHkayledD0E/zRBAqxOW89dNx3uTEs0guRf4bZ6VhQqCcFb
 43yUzznV
 fTw6zw2eDGlJ0f/JhrzQsUaKEWA9tSXyjLwBOe/NmSfeWO4HVM/odK016S7jHCyvnbm8QHu3cu2W5tsOx9q4FVPnu0Kp2c9lkHQKUoT0g4rBSedvQvcxPNB1XU0K7/Dl4G13EYLggCnfxbI6vtC/vf3rE2mmwVmG1cVScnuPqaVjWCjkwVPgI2XgYlTfA0W4eqcHFb2lqMR1UwtzccfxgIQDkQigG+rWf0KCPcQIhtNdntJv8i/E43T1e531FwILtgUO+QWFDRhjsS6Zhje9+086zoQCeWNZo86G2BS9dilCUucqksNwIRNtRN2Qym/z3O5VGdSIbITl/9gnsVLLlf2UNRJ4oGO+AFNwc6D/MeRKF6EChatlIqrE1YiPo3ar6Stamkc+ZEppVDWNHeMYSDWh7vPW21UEfnoD8G37bKRq5ol8pCoP37ywsyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 05:24:48PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
> 
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
> 
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
> 
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio == true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end = 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
> 
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
> 
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.
> 
> Rework the contract so the caller is told the page range to discard:
> 
>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>     range fully covered by [lstart, lend] after any split (or none),
>     i.e. the pages wholly within the range and safe to discard.
> 
>   - Adjust the ordering of the validate check when splitting folio2.
>     folio2->index is only reliable after the reference count and lock
>     have been successfully acquired, since it may have been split
>     concurrently, or freed and recycled to an unrelated mapping. On any
>     failure to obtain a reliable end position, fall back to
>     folio->index, which is safe but leaves the sub-folios split off at
>     the offset edge in the page cache.
> 
>   - Rename the byte-range parameters start/end to lstart/lend to better
>     express their semantics.
> 
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
> &pstart for the folio at the start edge and &pend for the folio at the
> end edge, so the truncate loop drops exactly the fully covered pages and
> never touches a straddling folio that still holds valid out-of-range
> data.
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 89 ++++++++++++++++++++++++++++++++++++---------------
>  3 files changed, 71 insertions(+), 35 deletions(-)
> 
...
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..bec6d881d022 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
...
> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		pgoff_t end, aligned_end = (pos + offset + length) >>
> +					   PAGE_SHIFT;
>  
> -		if (offset + length == size)
> -			goto no_split;
> +		if (pstart)
> +			*pstart = round_up(pos + offset, PAGE_SIZE) >>
> +				  PAGE_SHIFT;
> +
> +		if (offset + length == size) {
> +			end = aligned_end;
> +			goto out;
> +		}
>  
>  		split_at2 = folio_page(folio,
>  				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>  		folio2 = page_folio(split_at2);
>  
> +		/*
> +		 * folio2 may become stale due to a concurrent split or
> +		 * freeing, so validate it before and after taking its lock.
> +		 * If it fails, we can't get an accurate end position and fall
> +		 * back to folio->index, which may leave sub-folios split off
> +		 * at the offset edge in the page cache this round.
> +		 */
> +		end = folio->index;
>  		if (!folio_try_get(folio2))
> -			goto no_split;
> -
> -		if (!folio_test_large(folio2))
>  			goto out;
>  
> +		if (folio2->mapping != folio->mapping ||
> +		    !folio_test_large(folio2))
> +			goto out_put;
> +

Hi Zhang,

The only thing that sticks out to me in this version is the
!folio_test_large() check above. If we split (or something happens) such
that folio2 is no longer large, wouldn't it be more likely to catch it
here and fail to update end like we do in the same check a bit further
down after the folio lock? Maybe I'm missing something here, but it
seems a little odd for the same condition to return two possible states
like this. Otherwise I like the changes you've made and the rest of the
patch LGTM.

Brian

>  		if (!folio_trylock(folio2))
> -			goto out;
> +			goto out_put;
>  
> -		/* make sure folio2 is large and does not change its mapping */
> -		if (folio_test_large(folio2) &&
> -		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		if (page_folio(split_at2) != folio2) {
> +			folio_unlock(folio2);
> +			goto out_put;
> +		}
> +		if (!folio_test_large(folio2)) {
> +			end = aligned_end;
> +			folio_unlock(folio2);
> +			goto out_put;
> +		}
> +
> +		/* Split failed: back off to the head of the straddler */
> +		if (folio_split_or_unmap(folio2, split_at2, min_order))
> +			end = folio2->index;
> +		else
> +			end = aligned_end;
>  
>  		folio_unlock(folio2);
> -out:
> +out_put:
>  		folio_put(folio2);
> -no_split:
> +out:
> +		if (pend)
> +			*pend = end;
>  		return true;
>  	}
>  	if (folio_test_dirty(folio))
> @@ -413,11 +455,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>  	if (!IS_ERR(folio)) {
>  		same_folio = lend < folio_next_pos(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> -			start = folio_next_index(folio);
> -			if (same_folio)
> -				end = folio->index;
> -		}
> +		truncate_inode_partial_folio(folio, lstart, lend, &start,
> +					     same_folio ? &end : NULL);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		folio = NULL;
> @@ -427,8 +466,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>  						FGP_LOCK, 0);
>  		if (!IS_ERR(folio)) {
> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
> -				end = folio->index;
> +			truncate_inode_partial_folio(folio, lstart, lend,
> +						     NULL, &end);
>  			folio_unlock(folio);
>  			folio_put(folio);
>  		}
> -- 
> 2.52.0
> 


