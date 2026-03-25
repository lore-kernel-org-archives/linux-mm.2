Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04923109C058
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675F46B008C; Wed, 25 Mar 2026 15:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627416B0092; Wed, 25 Mar 2026 15:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CD66B0093; Wed, 25 Mar 2026 15:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 420856B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:11:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E66D0BC44A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:11:24 +0000 (UTC)
X-FDA: 84585528888.06.6DD0055
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B1E4180004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:11:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tISE3rgV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465883; a=rsa-sha256;
	cv=none;
	b=ILFHTiTKAa9aBLT/Zmn7iqi8qFVRUbBKEdCk7vonUhIPrzmlodMVMeO/W1yVt/B8e79Wqp
	G0dDEZ14DJirToGrKB+487XD20JMosqseZkLNoTOskJejb0KRVC8L/HfR9XlF/t05RcHAx
	067Don+N6bpyGHIHfD/NOWE3qsP35Mc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tISE3rgV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4muvIZdik9IfFFCJrCg8Xdvp9I7cKIuqFuVgWYAry8=;
	b=JOn63XULhFqpFf75dZ3aZEl3PW3osIUa4X1Qy5XDIS4Bwalg10vBcSrwm/dETZMYQuPOum
	Q7JtJy0YLwmlPohOsdzftgDneL1N0GbSe2LZCJuCEyMGYoAOFEnZlWEG5jZ2/SV9UpBael
	th4vDZsRcDyF2cuhb2sKxpzoih30FWs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2992F4037F;
	Wed, 25 Mar 2026 19:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C55C4CEF7;
	Wed, 25 Mar 2026 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774465882;
	bh=+7WMGti3dXwAOyhG5CeCqAhjakNMSRvjhZh/2jZRxoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tISE3rgV54h2NbgNcJwFnAMi0cL06Z7rnwc1d9XbX+CnLsXyLle4Q4Y8WdNNLL5l0
	 7bEEM7w6i/vpH21LFGWA5EznC65bhF7oqFBfLUBGNHWVFL7ngdrl0n4bc5j8/kb0sF
	 fR22PbMNFGCx8vc5V0y4uEcX1G8IkjcxLJuzeoWaRp0nl0Mbv6csL7vdOUvtO7wgWx
	 33s7bEkT+2GV3j6dkyWIJ4RpSDkV1lMGNKKYftfwxHuYxmNILb6214YB3c49QgjM4+
	 I4wye5WfNV4yx/TtDtTaNamJUYakAZg8YxP5fb1A0yQD6WR1BEiB1/0msYQKQJcXCG
	 zMd3be9feOANA==
Date: Wed, 25 Mar 2026 21:10:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jianhui Zhou <jianhuizzzzz@gmail.com>, jane.chu@oracle.com,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	SeongJae Park <sj@kernel.org>, Hugh Dickins <hughd@google.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
Message-ID: <acQzLYrp8W3PJZsh@kernel.org>
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260310110526.335749-1-jianhuizzzzz@gmail.com>
 <12e822c4-a4f2-4447-80b9-2eec35a03188@oracle.com>
 <CAEgWzV5ryMBgJWH3QmWfr9LaZoihXcffFWKjK6OfJF=pDF6BtA@mail.gmail.com>
 <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
X-Rspamd-Queue-Id: 1B1E4180004
X-Stat-Signature: tg6zpttfi5zux4syytiur9xjg4fydrce
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774465882-165895
X-HE-Meta: U2FsdGVkX1+EkurR58Sj7AtQ7YlOQOXDVurhk/p+TtHy2e3NlnIA36aTNCyr8G2Jte0Vh6LO5LOTvNoHOlHhK7iscjclA+ZgyPxXtKymQACoy+hKiQ+TNNJNaUYTqbxdrj5TlaHQ0O6gB3GSo7dndX06zbFQbeWSZ0WXLyezGi07DCY0eDAw8NDQL6ZAEFuZCdHx+lElMvfj1FtsWjjubo9wMpZ2MoymanQ500jjcChzVL7oSx55MllU/ZNWvRJFaaUVAQFdwpqVyYMi6nu+CM6MfVtqsldyT+d8GtOi8lb0FHSDtB1jF6NqA8E+qtxXHzHiYir9mQVnwUnb7TBkPaVG2Bk9AvPlhdVaMgVRHSoi5nTZL5POxsRT1MGH5y/IFtMN+PMV97GO0Uat5mCVDYCJ9ZGWi+L7CN+HvpN27NgIw88DsY+/+qmUuqEkvyT7j52xJlJNPYXRM6J0O4LYp7PTdWxHz+8OMzl2xArOC1jK4Dn7GeqXVtgHVjdsLK5VYvYl0BFeTVQSPo0bP0sY1bVgICSvyEBxRvNP7pvMuAfgiQUgsA7eQM1KMW4Rymc5y6w8rLXLt7ciiFZYNxqr41W6NB4ZAlAY0hvtutKaxKI6pd/I+37Cm9lm/SpnFKBmJac6ij5wb9kbtPKe8kKIrRuebWPFllaP7ay8UzatxI6JprRoMYzVxopOdwyS+gjTSpgk1EJnd15/Lb3cypu3gzwsjwcGu0C4s1jq0LoqeyCj+4oIwR6SdfJep+5TBJIS0SLO7W8oGnRvd9FNC1XkXO/nVvZhB+8X2bFVzEHh5po+7huQ1AjCwUe5L8+Iw1OIjYD5itoVqbRDiNwQ6RMkCzZS07gFocpg+AkWn7ej5Y0eKhWOf2ZOBriRgAsqurFhoLmFStvUxOwDCmT4BzWSKOTTFii88f97LC8PUGRQLfsrb4+960YgWr9JKfcbS05PqMFkBsYIh6SlScYkRkc
 ENHielGO
 hEb3S5LdDJxqJFWt1+YLfdYpaQB577DDqXRYlcKPvYJ1hY3xGk7aLYFAuWoGabaIR3zfcYBmnPrmGEWz4m8SSEekHMFs0bC6pmiP/otCzQYqJSflPsH5aqQQN47+6YOFdwP/WRlJiw6PIeTL8UmDwAliDdLkCIOFw7c5Bt0WgSES8tPCHpf7ed1nTKu/JLBhkT3iavKO2ca1rIES0rSVNu8EwECfATeaAVMiDkRsOQJ3pkTxZ3mPH4gux//ltPeNaIz6RpUeeTnkVy9B+wMHehHO8obh5z3coM4rdo0jFZIRh3A/nMvrJr/ZlptRPSYYX8StWNTQ7mBrcrykfT7LWOQZihdCCe1GxPIQbL6K38/ZfYd7QSmwGx6SOVAHXekp03VLgFWdOZB06QiF79j0DLULO2nlwY1Ge+fqaeOj4nx39pC6kQCNo2miWEWH9yr04CHilYZvXQScpgfabzEphnP+ekvqC3HElT9qg0EJafLvLSYkQqP/80M89ZKXs49GDIN3AFb/kScv2Clqztac9RRBYN8KYlRgHcuJK/FUcB08vgSHLIGmmpEdoucQWhGQgoE4nM/IlXpSkubCWM25xfcGmHo+JzRnsZvXK2Avbkr1FvlhSZ6DLOD6tTQSUIa6adrhnOKuYlXirjZi7Zsc4FHCCZQnX67znuiO5FShLk9H7LklwFAuvwxcQQXPG4AjC5sDGqPcO/WIG2Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 05:03:11PM -0700, Andrew Morton wrote:
> On Wed, 11 Mar 2026 18:54:26 +0800 Jianhui Zhou <jianhuizzzzz@gmail.com> wrote:
> 
> > On Tue, Mar 10, 2026 at 12:47:07PM -0700, jane.chu@oracle.com wrote:
> > > Just wondering whether making the shift explicit here instead of
> > > introducing another hugetlb helper might be sufficient?
> > >
> > >      idx >>= huge_page_order(hstate_vma(vma));
> > 
> > That would work for hugetlb VMAs since both (address - vm_start) and
> > vm_pgoff are guaranteed to be huge page aligned. However, David
> > suggested introducing hugetlb_linear_page_index() to provide a cleaner
> > API that mirrors linear_page_index(), so I kept this approach.
> > 
> 
> Thanks.
> 
> Would anyone like to review this cc:stable patch for us?
> 
> 
> From: Jianhui Zhou <jianhuizzzzz@gmail.com>
> Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
> Date: Tue, 10 Mar 2026 19:05:26 +0800
> 
> In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
> page index for hugetlb_fault_mutex_hash().  However, linear_page_index()
> returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
> expects the index in huge page units.  This mismatch means that different
> addresses within the same huge page can produce different hash values,
> leading to the use of different mutexes for the same huge page.  This can
> cause races between faulting threads, which can corrupt the reservation
> map and trigger the BUG_ON in resv_map_release().
> 
> Fix this by introducing hugetlb_linear_page_index(), which returns the
> page index in huge page granularity, and using it in place of
> linear_page_index().
> 
> Link: https://lkml.kernel.org/r/20260310110526.335749-1-jianhuizzzzz@gmail.com
> Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
> Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
> Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: JonasZhou <JonasZhou@zhaoxin.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Looks fine from uffd perspective, and simple enough for stable@.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
>  include/linux/hugetlb.h |   17 +++++++++++++++++
>  mm/userfaultfd.c        |    2 +-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/hugetlb.h~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
> +++ a/include/linux/hugetlb.h
> @@ -796,6 +796,23 @@ static inline unsigned huge_page_shift(s
>  	return h->order + PAGE_SHIFT;
>  }
>  
> +/**
> + * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
> + *				 page size granularity.
> + * @vma: the hugetlb VMA
> + * @address: the virtual address within the VMA
> + *
> + * Return: the page offset within the mapping in huge page units.
> + */
> +static inline pgoff_t hugetlb_linear_page_index(struct vm_area_struct *vma,
> +		unsigned long address)
> +{
> +	struct hstate *h = hstate_vma(vma);
> +
> +	return ((address - vma->vm_start) >> huge_page_shift(h)) +
> +		(vma->vm_pgoff >> huge_page_order(h));
> +}
> +
>  static inline bool order_is_gigantic(unsigned int order)
>  {
>  	return order > MAX_PAGE_ORDER;
> --- a/mm/userfaultfd.c~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
> +++ a/mm/userfaultfd.c
> @@ -573,7 +573,7 @@ retry:
>  		 * in the case of shared pmds.  fault mutex prevents
>  		 * races with other faulting threads.
>  		 */
> -		idx = linear_page_index(dst_vma, dst_addr);
> +		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
>  		mapping = dst_vma->vm_file->f_mapping;
>  		hash = hugetlb_fault_mutex_hash(mapping, idx);
>  		mutex_lock(&hugetlb_fault_mutex_table[hash]);
> _
> 

-- 
Sincerely yours,
Mike.

