Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C78BC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 06:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202AF6B008A; Sat, 26 Sep 2026 02:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4266B008C; Sat, 26 Sep 2026 02:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC5A6B0096; Sat, 26 Sep 2026 02:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3BCB6B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:23:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B1AC80812
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:23:28 +0000 (UTC)
X-FDA: 85254921696.27.D7A8A6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A0A9E20009
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:23:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=er2894oU;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790403806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bE3MOvxShUcWAEYB6S4djCq0onugD031quNJ1tSWUR8=;
	b=3lrxhaORjOmepRZB/bdXIklK0Ng9iEKsOavKI+ucZgqs1+pL6frcwDphKO5IfH2l5pryOJ
	WP9sSSzYvqV6FoiCGXPdmvLIxw3OnP8wi0uafev/qRVqr7pz2f3sUy2EoAwur45LnDl+Fs
	MaopBIfF/E86WfSr9H/SO/U/QES2UdU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=er2894oU;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790403806;
	b=7RLEicpjsrD2vmVBSm4Kd3/64uApA6g9WND1n0OEWPjoSj7dMjKquay3JAkLmZgfY3X3i5
	fJmtuIEfqtv1Mc5pHyRkwlzT2QM+4FSD9x6Cc+xOBmC9Bebd2LLxuHdpwvj/eSIjNra9zW
	gGusbbFJZl/hCAZfZ9WXOAtU8x8HQF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3DCF4174B;
	Sat, 26 Sep 2026 06:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC321F000FF;
	Sat, 26 Sep 2026 06:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790403805;
	bh=bE3MOvxShUcWAEYB6S4djCq0onugD031quNJ1tSWUR8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=er2894oU8HGREcm+ENsWTD8GFKDU2iBqfr6uqeYGwoevMD/P73WWI+pNea9bf2Mo/
	 Yq+tIFVp2/ian/8rHByZNGqcdJ36bLy0tQBPXUnK/TNY8FAV4t73E4+wpfEbEiIAuV
	 jMlJPBfrKdbYSkq+O8/dQ7GD5DjGIre1K/Zd9dcY=
Date: Fri, 25 Sep 2026 23:23:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinmeng Zhou <jinmengzhou22@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jinmeng Zhou
 <zhoujinmeng@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix subpool minimum reservation rollback
Message-Id: <20260925232324.10cd660f107db2fb4f4b22e2@linux-foundation.org>
In-Reply-To: <20260907132055.26696-1-zhoujinmeng@bytedance.com>
References: <20260907132055.26696-1-zhoujinmeng@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: cshehsxn7hygdq7u9b7h3z9b6x698cij
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0A9E20009
X-HE-Tag: 1790403806-582976
X-HE-Meta: U2FsdGVkX1/r1IZdA4mKlP/BbyrsiQQCTB+xjY27KwF+wFncJTMfXLju5/3uKr3fhD4UanN+JNCTAJutFt+BJxley9rEf9RJbH2FJ9f0/HfDrB/nh0t/VKlAdgrQebrEgzt0MptJEqDCvr+SIi0PCVQ96xt70ifQqpVdPUFndUF1AO/lCXPI81/nKC6MwVnB3w4+c1q5PFdGJ7RtrXfghVAOItL8M/rDCIYICrj7zvIMQNe+Rqz9UlHQxdwv5Yz3Meqmn3efOKGo7W53wNj6WPCdV3ugXMrAJnqves9d1Mcm5X5Ms4aL2AblapIV1XobeGl3BbHpfI09YxyD/18cC+GOIg7tibngyNYMv9htGROYP7iJJo6Rj5FHP/AdZdRmgwjfLfeMUVO/u1Vudc/+xGIcHi/wGDgrQ6BLzV5HEPkcBJy4hK+xoRKFctxLHJ24Z3jPxfZm1dNCducX1imMJWQyLGTHGmFIkjTigaNTDVx+SUnm1FTtb7aIMNyOD6ARyiBxVO2THmxysDsPC37N2rAH3+awdrE479QhOIUk5uNPPblyXNGgC5WvwCNmSJJmmnMqfdqvJ3eB4znysU1pLWEorDlaETiAxpPXcug417vtFtZztcm4Yo1K/awccegaglLkb0TEGj/utSD/Iw6S44OWuWzADzxTso4IS1qgKIytp2weBB3WiOdyxgTMsHKUuvdAP4CvXcvDt3bw9IqmRrcJlgImIkV1RwToaMnh43MCLrlkor52FuYqvGpkjGfms2k3iNDCodegTJBRbznBNfd3djWMEPF6DPyBV2ESdzwKSozFlDL7A8wmtocysSqfmiSBfkLt8cIHi2KlRNMH5Vmm2XosZl4/zs3J9XDECVPwtBgfdgN3AL2iDQfrrT0UMBvu85UQG/Lcug3dgGa+/axMVsnBTrzh+u6uAyADRQEgp4l6jAlB7JLKrnxGbDjKNMGGg83JOAxd1AKpmxc
 D3/K94Ud
 60sxkvK+XkmxnuPwsI3BN18YVKVggdQHhNnOrWXlgsHWA4UqqInOUN+d6ECheU/97sOTjN89lRB1f5s5tmJwphnyn1geplZo8A5I72z6FylP1Ctgv+pN3FYQDUa0Rl/u1rwfjxxzIFhh7SB7rfUALcSw6IzYUBTiwy5XdYONt4z+QkV4mXxtaP/uYP1GnSYqnAe4VR/IuDKxUGJ3vkskO+jPcj44n3/z6gfO/fdsYCplzIsOdxpYo1fugaGi/e3IAh3ag25jCJ4tOuVKp0foQy1lLcEGzqwgm6vGuLBVN6NFtMIfpPok//CCtKLwG3ERGh50Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 21:20:55 +0800 Jinmeng Zhou <jinmengzhou22@gmail.com> wrote:

> When a reservation request is partially covered by a subpool minimum and
> the remaining global reservation fails, the error path first calls
> hugepage_subpool_put_pages() for the subpool-backed portion. It removes the
> failed global portion from used_hpages only afterwards.
> 
> hugepage_subpool_put_pages() uses used_hpages to decide whether rsv_hpages
> should be restored. Since used_hpages still includes the global portion, it
> can remain at or above min_hpages and prevent that restoration. It then
> reports the subpool reservation as releasable, causing
> hugetlb_acct_memory() to incorrectly decrement h->resv_huge_pages.
> 
> This was reproduced with four 2 MB huge pages and a hugetlbfs mount with
> size=10M,min_size=8M. After a successful three-page reservation, a two-page
> reservation which needed one subpool page and one global page failed with
> -ENOMEM. HugePages_Rsvd incorrectly dropped from four to three even though
> the subpool minimum was still four pages.
> 
> Roll back the failed global portion from used_hpages first, so that
> hugepage_subpool_put_pages() evaluates the minimum reservation against the
> current usage and returns the correct global adjustment.

Please cen we get some review of this cc:stable bugfix?

Thanks.

> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
> ---
>  mm/hugetlb.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 785772845795..3e3cda181e72 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6808,15 +6808,6 @@ long hugetlb_reserve_pages(struct inode *inode,
>  
>  out_put_pages:
>  	spool_resv = chg - gbl_reserve;
> -	if (spool_resv) {
> -		/* put sub pool's reservation back, chg - gbl_reserve */
> -		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
> -		/*
> -		 * subpool's reserved pages can not be put back due to race,
> -		 * return to hstate.
> -		 */
> -		hugetlb_acct_memory(h, -gbl_resv);
> -	}
>  	/* Restore used_hpages for pages that failed global reservation */
>  	if (gbl_reserve && spool) {
>  		unsigned long flags;
> @@ -6826,6 +6817,15 @@ long hugetlb_reserve_pages(struct inode *inode,
>  			spool->used_hpages -= gbl_reserve;
>  		unlock_or_release_subpool(spool, flags);
>  	}
> +	if (spool_resv) {
> +		/* put sub pool's reservation back, chg - gbl_reserve */
> +		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
> +		/*
> +		 * subpool's reserved pages can not be put back due to race,
> +		 * return to hstate.
> +		 */
> +		hugetlb_acct_memory(h, -gbl_resv);
> +	}
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>  					    chg * pages_per_huge_page(h), h_cg);
> -- 
> 2.39.5
> 

