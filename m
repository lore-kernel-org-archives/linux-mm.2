Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD72CFEC0F4
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00DF86B0088; Tue, 24 Mar 2026 21:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE90C6B0089; Tue, 24 Mar 2026 21:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFED66B008A; Tue, 24 Mar 2026 21:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEE7B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:06:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88AAE1405A9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:06:24 +0000 (UTC)
X-FDA: 84582794688.12.C0F97B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3C5A120004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:06:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WVZLXqtw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774400783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gd6whqBQMG77liRwz01EfO9H7ZhMW7tB/fbM99I9w6o=;
	b=QuOnSUnMz9axX+GrC2ABCnAS4AvnF/w2p3zWk3je4egr5b83Lhz/0snq2JXHK9daHUr3Ih
	iiE4KCIP1oKDYZ8NxD38IS/MEKkm+3MT4Ap/MY/asP5+gU300slurU3chT3Ag5ukphOyWe
	9KoKd3+uB25HHdBJGLFxYiSles3+5bU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774400783; a=rsa-sha256;
	cv=none;
	b=c2vLhPhHSjIQoeFjc9P/zDf+Uv9RAbuV7tcu0zODURxFYYcAw0rKKFvHK/H49AMdVIlaqj
	7EQh47Ooduq9hguDQBs4UU2wg2Aaffu8xKwJ23yCOcqFzcgFoZynMKN9qhC1GMHyArfn4Q
	3uSRw5yWsO8vRFC4yIj9r7se7xIt27o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WVZLXqtw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5EC04434E;
	Wed, 25 Mar 2026 01:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F63EC19424;
	Wed, 25 Mar 2026 01:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774400781;
	bh=KCKmswUuntgrxMY+FY5NFLWhFQrzDonhgajhndVTwTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVZLXqtwSvL0LjXz1uF2Fm49ZQn2TlVnQe6H6rXg7njcS9FsCpKQmoIPrynX4aEem
	 vNLZbQ6q1zEQKIwFT2DrAgMJ7F0GlO8aGvJE5g9B6nbV/2arR+uu6PmjROESoUzG0Z
	 yUzFy+iQWLrgE/2JSjj0sBUvuU7dOZom9YvWhHSvWMMK/L6wPNqHBB/Fmq67EZkMPg
	 DKU0sTc42jpNZ2sar9qJ/uNO1ibKreHppHy4X8yHBXLHJBx1k4oniFSCTQKF35srRa
	 qqH8vYGGwywRilF2WMegXvEg00TjO3vd6JVKzvghqfIcbEwjT91kSBvfcGnLPAaKbh
	 3cRYGuOmep/Pg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Jianhui Zhou <jianhuizzzzz@gmail.com>,
	jane.chu@oracle.com,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Jonas Zhou <jonaszhou@zhaoxin.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Tue, 24 Mar 2026 18:06:17 -0700
Message-ID: <20260325010618.85366-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E3C5A120004
X-Stat-Signature: r9da8an3otfobn4kaid8n3wwxyhj6y9k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774400782-413847
X-HE-Meta: U2FsdGVkX18KWlrFRsbIYwZwf1eanFSmfc0/5eQF70nmEBHP9VNBSYnaRnDd5OA1jDyOqjSu3WhXAwzX0djT9K9Ytll+pVUchJtGDuJs9j2dzjaER5/H1FNBo4aVmCE1/I5Y6GjhkFEms1CBdz2aOMggDK+adLWXqFqMG7+UJAsl7iX1r5hWQFAJRB2NUcLo0+sdZiUOTzgpMm+Mi3r3CqlSNH/UoMH/HE5+J7L1vghheI3u5e7J9oexvEx01xZd+3piNQwlRGEpq/7nSaH3dvW+XtMmuIRdg2iAgwXd/zQfOushHTzJIJO4ag3nSX2lhjDrmDEiAfzkJ4AXu6MPTr9w3P51gW25bu6lDDJ+lfaUs+px8B+qJViHmmkquRmYNlHkG7eDQZgshXlkcf5Lo5nSbk1omM/XVc50wOoQ1X5Epvl96gnTUN2CBP3EGldKTGaW8kN2OGRP2eFWYa5swtSmWmN7CYnIXmGD1IpTNp/EmlerAr7BOemw22CvRcDOEvAUdb5gIGwlea7uk9DmybbjtifvrX0DcqILnfgpvRoi3cDDU7GpRJHZda0BWai5vsRLAqGLpsijaiTuck9anbk9Rf7MUxfJ3vt4OVx1Jnmw1uPTd/k1cMx1u8yKIDHWPRgHSfbK/c1/wK48t7K6DeEz1S/DgUpTx+AYEsUSX1DUdaHTudsph7evVbb5lxbBogF3ki8roB5oNLUfd2nSBYBz9zGHuxaR7dS5BJgUO8PlkvQuXaKzO3e+nmWLi/vWOHJ4QuTGVqMCqUMZHUX8BpzfK7zqwAq+rqphOoV5QkN+xFBRODcv86L+bTSDwlcF9us/cdlmPxRImCPcowKeS4puF4TOkxT3gnwzgNycsn4FyXUNo3wHdKQQWFHhy/D+STrGVMkDVziz2rHNQrIB8bAivlwC7HsP5cBc0KR6jlojPs/APFNn0TgnVkqq6naDh/dy9vncwx65SPADiQj
 uj6lbtVK
 F4bwL44yx6ET3G28NymSuJC4GvxnUz3j98xteRalSvCZP6Z3xOYqhE0TvIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 17:03:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

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

I added trivial comments below, but looks good to me.

Acked-by: SeongJae Park <sj@kernel.org>

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

Nit.  The outermost parentheses feels odd to me.

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

Seems userfaulfd.c is the only caller of the new helper function.  Why don't
you define the function in userfaultfd.c ?


Thanks,
SJ

