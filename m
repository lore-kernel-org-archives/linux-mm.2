Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B051C55174
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 02:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F5F6B007B; Sun,  2 Aug 2026 22:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927F26B0088; Sun,  2 Aug 2026 22:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864F46B008A; Sun,  2 Aug 2026 22:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7EAB6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:06:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8044A1EB5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:06:55 +0000 (UTC)
X-FDA: 85058319990.02.A116B34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6503A140007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:06:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vOC3V1kj;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785722814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAtto6COYpowGn7w8xEz/ATwLur92gvwTqS/9hGpRTs=;
	b=ZxNCGH1X6EguM/FoLGwd4mGN9y+4w1xvBhErvCYlSn3XiLwKEbfmaAgP/ug0rs90Uc4A9U
	enGf0uZcY7dckMIB2KdX2mMNNUcPoIA9ve79ZnsCnBlwLhbYG+vfB1AVP6vVMeVsml40mS
	HJNQSptTnz1PYD00ad8fcELjhuNG5NA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785722814;
	b=h8OaZILLbfHx4qSjSj3+LyQg/C5nMhYqRlLIXngux/jenhmxLv10V751r7Q9x5BbRwKSHs
	7srcoHygecuLXQWyFrzKpDm511fFg3QVT9oS5GGpT6hSF5nyJWaI8Vw7rS5Gx6q0H2sI0p
	9EK3rXJ4kfVM8It1eFdlPSyhMDhxyzY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vOC3V1kj;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vAtto6COYpowGn7w8xEz/ATwLur92gvwTqS/9hGpRTs=; b=vOC3V1kj1md7BOyGrPCz6hcIlv
	ciInho3Qww7CYBFz9ZhzGnt28wUH61GKPzt2YqnvWtLF28Q3VhwAAvwe7SYmKgV6kyuuuTluxeK/v
	xMsiQbQSvDjYtLT6gvSFGNpeXn3Ut62n7C4zKXkTwithA+Y1fLbLJFeSL2rSQ3hih7D07ICb4l29T
	qidI70jz9YMXBdEXpcGTxxq+QKH4Pxw/pAujdhSgPQWeUBLB+BpJ0j1/ANI1PiwjY6zpScj9bH+mb
	5+PCwgcsP5S15rNoeixaXQpq+DR7cyUeg1mFXUqMod8Spu16XjKClg/FoihZGIVOha75UM1hVJHoI
	w65rKB9w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wqi4R-00000000G7T-1IcH;
	Mon, 03 Aug 2026 02:06:27 +0000
Date: Mon, 3 Aug 2026 03:06:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] ceph: remove page_snap_context()
Message-ID: <am_3oyOJAoFeBFTC@casper.infradead.org>
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
 <20260802-remove-wait-on-page-writeback-v1-4-6c35d6b3ad36@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-remove-wait-on-page-writeback-v1-4-6c35d6b3ad36@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6503A140007
X-Stat-Signature: ndiotcdanqsrpntuek1jjw9m8jp87guu
X-HE-Tag: 1785722813-953335
X-HE-Meta: U2FsdGVkX19y3TyYecWsQuCjjCNLFKECSwIq3NyXEQpP+2hWjv743mgSQv815EQzAbMc52Y5zUiWjT+fbgnP6J/LtA93imHBnHIDr1yTS7ZEp5slw0emCcd2FvWjQDV4YE5eN27Aird5aPaO6yAeD6WBBm5045eEvbSuxhMnau44bfWIOWpETzasOl/GLkHLzm5k74dqaWwjUshDdUEujH4TZnfnyvC3i0Ly6YZkMm5iZWO9nJ/guRCPT5kT85fNTCHFntCC60IttV0/vawypxZgwdPkSxsDh12k7BpNQy85GcCzd1jF27r1tPRLCpJDs41rFJOTNHaUlhC6Ybkh532e5wX40R4reHwn8TzmObsU1uqKwHa29vcCLHoNeIz6RFogVDMMjkfVCMkvnSS0NLKtEoHCwf6A8WAYqLTaisyv+jfYg6q/fKNn0O5ygLApNHFXNknWnzvBKnWxh/R3igPGGdvPwyHTh1TY49L4C8fGPi7/hZbYmwT5SjkbTUA3If91fY6IFy0tNqXDu16loRgKQMv8imiaMjrdbE0+jFkatUWPcyGpEqof4CSp9dK46dPDY0oq8FMcqAAxtl/4nbb3/C/kO4Q0yNtsrczDE8Vx+Bpk9EkW71Zinuh+vwuKF2q01LQE6Xxggl3Vdma8oamXMkhD7aOnKRc8FM/xzCcpTCa2beYKXpGUuCk5IUg1XPyx3zPHL4TkhHUi3OAku/IsSXsvjFZfPahyOSPaj20tfGkxnIrF1pQWP2TmkKojjcX5jkLsMOeL4+Edizs7ZPe0K/LUhWlLolDQt84PLRbMc4yqata0qN6H3e+E1h/b5Rc8wqAp0bRwtitmbkd9YiDNg/Eq18GWLcmm/Wa6Y4MoeVMY9X0YadbWn6t4a4vGwyZoyJkp5JTah4Wxgruwnnc2ayXZvvx5pydy3r3DNjXdBul7Ewzp2zDKoO58KmC4RMeOieoVG7Pqfui81+q
 CqGXC+7V
 6gYFYd5wRryIic/aTGKPN/cUArkCqhh9efVrXRtUG42DmQ+NljHo47PJmn7WJ9KoyTgkFSiW0lwDZGquAcBlmYGFuqTE9U80ZnX71T212LMUKQWKXCXSX+vL46g8nXJ7wLQCSUTWUrvSDx6QmQGvYcJP0DUA821orAOeY9ojLdLbrHVB46CSRRGsxlOOjKldk7p/3vpUy1HeXM5bKtQF3/o6m68U23CKtc8wRsnJL+ml2ne3gYw72hH6CY6rE6C05j9RiaOBQ22IfrmrqgMBSpMuHMcCp8UCn4U/i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 12:50:05PM -0400, Tal Zussman wrote:
> Convert the final caller in get_writepages_data_length() to use a folio
> and ceph_folio_snap_context(), then remove page_snap_context().
> 
> This drops the last open-coded use of page->private in ceph's writeback
> path.

This one I'm deeply conflicted about.  It's adding an extra call to
compound_head() ... and we're not getting much for it.

I'd feel better about it if it started with::

 static u64 get_writepages_data_length(struct inode *inode,
                                       struct page *page, u64 start)
 {
+	struct folio *folio = page_folio(page);

and then we had a ceph_fscrypt_pagecache_folio() function and
ceph_fscrypt_folio_offset() (we already have a fscrypt_is_bounce_page())

That way we'd have this function entirely converted except for its
argument, and a future patch can do the conversion with little fuss.
And we'd get rid of one of the four remaining calls to
fscrypt_is_bounce_page()

> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/ceph/addr.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index f4aaf9a5f196..702cf5fc1eab 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -29,9 +29,9 @@
>   *
>   * There are a few funny things going on here.
>   *
> - * The page->private field is used to reference a struct
> - * ceph_snap_context for _every_ dirty page.  This indicates which
> - * snapshot the page was logically dirtied in, and thus which snap
> + * The folio->private field is used to reference a struct
> + * ceph_snap_context for _every_ dirty folio.  This indicates which
> + * snapshot the folio was logically dirtied in, and thus which snap
>   * context needs to be associated with the osd write during writeback.
>   *
>   * Similarly, struct ceph_inode_info maintains a set of counters to
> @@ -68,13 +68,6 @@
>  static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
>  					struct folio **foliop, void **_fsdata);
>  
> -static inline struct ceph_snap_context *page_snap_context(struct page *page)
> -{
> -	if (PagePrivate(page))
> -		return (void *)page->private;
> -	return NULL;
> -}
> -
>  static inline struct ceph_snap_context *ceph_folio_snap_context(struct folio *folio)
>  {
>  	if (folio_test_private(folio))
> @@ -697,7 +690,7 @@ static u64 get_writepages_data_length(struct inode *inode,
>  	u64 end = i_size_read(inode);
>  	u64 ret;
>  
> -	snapc = page_snap_context(ceph_fscrypt_pagecache_page(page));
> +	snapc = ceph_folio_snap_context(page_folio(ceph_fscrypt_pagecache_page(page)));
>  	if (snapc != ci->i_head_snapc) {
>  		bool found = false;
>  		spin_lock(&ci->i_ceph_lock);
> 
> -- 
> 2.39.5
> 

