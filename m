Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F46D73E9E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AE96B009F; Thu, 29 Jan 2026 17:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E076B00A0; Thu, 29 Jan 2026 17:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A546B00A2; Thu, 29 Jan 2026 17:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10C5F6B009F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:47:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DBBCD3C0D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:47:33 +0000 (UTC)
X-FDA: 84386489586.03.3A4A721
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C941A000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:47:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HIfXK8sh;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769726852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJEzypFq45x7weCRrdusr5Ltkkh4n0qsHxk+FFI3A9g=;
	b=pZF3msgKhSzUbpYEHUSNpBrTuH5RK5Tcl/ZCUFY6ZjYcaq6YXGDLSVrcxCiHe0jS7ph7s5
	uzxAmkK9+HCgXZRchEqQuhAF0QTbPnMu7BVxj/xW5CUJajDfS69K1TyXCotwZyEbLywgMm
	0nnrSbTPcP3aq/XB/ZxLrpiio7TZg9U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HIfXK8sh;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769726852; a=rsa-sha256;
	cv=none;
	b=QEPVw1bfO3my3/pm6QXdw7PxcCeHaq9T3Qp6Y5gI8u1bIqPuA0mQGLjjOK1nboEmYcvawJ
	pnRzgEWtZyP6DlIE/lrW63ObBandweZx7LKBZWW/R9+QFepwiwV6qU+uwa95jMswKsLxPf
	WksJ86HBj9hQotNSS6rVGkAytiXvvBM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XJEzypFq45x7weCRrdusr5Ltkkh4n0qsHxk+FFI3A9g=; b=HIfXK8shJJsslT86DLJQa7Stv0
	T0OR8qZs2lRtw7vk9xbzZP7EP51zQvATjU63rhXO+sr6R7c8OZDMjXJv+8BWBexnGhzAr97m/mhdM
	g+oQ553WxQY4k5zSVjNBMF/rm0ADtbsgfGi+7eMEo6JBm+qsDNEvzzym6ei48YdOMrnGAivSNVdGH
	CNFoswRDij7cx6R5mJrVQ52qlHB7A6J9bpSSA1kEiZiAGYavMFfavIpAoF77C8IWcbXbYTOU1MC6w
	bZhl2+MNmY6xuZnuGrj+lBEE7eApPXBif+zIKPPFBYnvaw7dtfcWusoF35WqeiD+VrgvHPgbTXZbj
	bs/Avipw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlanE-0000000BJkq-14Xd;
	Thu, 29 Jan 2026 22:47:16 +0000
Date: Thu, 29 Jan 2026 22:47:16 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>, Song Liu <songliubraving@fb.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Message-ID: <aXvjdArhPpUNF8BI@casper.infradead.org>
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129184054.910897-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C941A000A
X-Stat-Signature: hg5dqjrw6ziwuaejo9qzxgmu13hkkjic
X-Rspam-User: 
X-HE-Tag: 1769726851-812840
X-HE-Meta: U2FsdGVkX1+Pt0hGKvLSQ0X0tEmSQz+C4egwo1yOssaitHXd1aBoqpxbrDNukkeVh/6qm+BhIlq4qol19CVBq/XIS8VT9mxzD0Tct9ixw2/drop5YBkWRJbLK4SgIL9v6Rx5F7BLHPs+sGtKCjQERBhk2cE5Gq8rq5dFa199mv8rX7BvZ+YoPfQeR7OopQ1UCYikT2G2zMZa0Hoa6oRUKSGS77GL57a+b6E5KY257FVq44hCvPtVSoF688FBbsvPBWr7Z2lwVoUiLrEhKAEVYaeF28Z6RvlExKp5nDrgoO35rcBSXTLYnYJgx6SSKP7/5D+JyhMvE5sRY3lm9rAiLSZk2QyXePQKg5C1X6ivtFC+YDLGe1qXgaXqQ8QP6Ssyl66D9H3t1+Mp9jnFNnFzoUv6YBdIZpFI2DCsxiQopAhConctMaUeatAcYGBjxVuTYOBJSOVm9sDptrVn16GWQloZRjLQ0L2PL4PRUOjrB0o38mMF9fRSCEAbcr9vz9WCPCvxSQJ1+aFvbuo4p9/S+ozp2RjpDLhFeh1id8IDrT+MouuLaXTMLEswjmpjMVglF9fqb2lb/KKyTzirRIyy7nXmzYFRuKQKN7YSXYf/VLJMJt74rc/e/E/oines3avCkOsapOcPHwky0elhGgXYrcktiMuPYqXQlTgcudoEiHhT/q1i57tQSyHvQxxX8um6BgPt4HvBRyUqIQiVwphpEc+1Oa7lEEQvncikdSNt4HqJpCWtCLisML46P6PnFLEHIxyvmWRZRMgn3pXNP2Qz1CBmfLgzvRIuNGVe1L4VpxyfoQ7X6FvA84n08bqc/5TZtQr6mav8usSRdWxCja315n9HuzsFnlHUxV3AnvTkoaJD/D8R5VWuyTtl2bJ4cEJ9de4Q10NiDU5Bdfczed9LNToyusXg/jXd1aqjWbU1JiMfyMmgRueqdIVVfkDvrdalBR5bnor0gGUhbHrKvtv
 NI88ZnI2
 sOQnCwD8lc2b5EB4ljBi+prkDEbsvesN8UBB3Ua6e610K1R7XwyI8t8LWXYs3xulKbOmNkQDEW34a0kpYRiDyL63gi1MeWNRxrtw+4dsKSJL9TSVlFd1A8SSEYLKWjJw0oKVGKI2rpmD5b+h81n2U8h/ka4uADb6dr5WQWNRBvqdBTu+1YCcdQDpp3SSiTNSrrfXJzsClNCJVZLbM8Gp5GEJUHAQf+iMCzhYFzw32BJCHmJvVhMx4dYALvXnRtGXM5q3ZCGhTzE5DgXDtbfjh67rQYEckpLtkKfmiVS1XnIJdGujNbrty85lJVqfKRdNw5/OB7Z1l9Jbm32s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 10:40:54AM -0800, Shakeel Butt wrote:
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")

Are you sure this is the right Fixes?  99cb0dbd47a1 wasn't cgroup
aware:

        if (nr_none) {
                struct zone *zone = page_zone(new_page);

                __mod_node_page_state(zone->zone_pgdat, NR_FILE_PAGES, nr_none);
-               __mod_node_page_state(zone->zone_pgdat, NR_SHMEM, nr_none);
+               if (is_shmem)
+                       __mod_node_page_state(zone->zone_pgdat,
+                                             NR_SHMEM, nr_none);
        }

b8eddff8886b added cgroup support:

        if (is_shmem)
-               __inc_node_page_state(new_page, NR_SHMEM_THPS);
+               __inc_lruvec_page_state(new_page, NR_SHMEM_THPS);
        else {
-               __inc_node_page_state(new_page, NR_FILE_THPS);
+               __inc_lruvec_page_state(new_page, NR_FILE_THPS);
                filemap_nr_thps_inc(mapping);
        }

which would seem like the right Fixes: to me?

> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/khugepaged.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1d994b6c58c6..1cf8e154e214 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2200,8 +2200,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	else
>  		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
>  
> +	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
>  	if (nr_none) {
> -		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
>  		/* nr_none is always 0 for non-shmem. */
>  		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
>  	}
> @@ -2238,6 +2238,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	 */
>  	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
>  		list_del(&folio->lru);
> +		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
> +				      -folio_nr_pages(folio));
>  		folio->mapping = NULL;
>  		folio_clear_active(folio);
>  		folio_clear_unevictable(folio);
> -- 
> 2.47.3
> 
> 

