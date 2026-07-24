Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3642CC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7716B0088; Fri, 24 Jul 2026 12:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299836B0092; Fri, 24 Jul 2026 12:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF0A6B0096; Fri, 24 Jul 2026 12:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0CFF6B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:06:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DC691603F8
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:06:32 +0000 (UTC)
X-FDA: 85024147824.13.086918C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 40DB280003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:06:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fgOPtMwy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784909190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9t83x8ui6APYaDPpbQb5BP7fzrJtMQqqyNXMrEjn00M=;
	b=kNe/LDix9bwbsqJzRQGsFNMGPJ5RNQ8gMaZ4dCeN1gvkDMReSjR5hVe7jAkszosVFqVADb
	zwAJFVNYtiWCZVJpJ5UhQ9YpxUHp9Mcx5pFAleIUyiPUOxVO0K4/wAGcexcmZQ/85esCoW
	trUIN2/3kW9ZMGCDB57sEi0CuwQwuJY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fgOPtMwy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784909190;
	b=sVAap/j+asIEFg33rpZu6C42Epq8C9KbdxtqAxC4hxq/bpuPE6h+VSMhSccgM82fxCF9J7
	yVie09AfFsCGe0FfnlPxIFM6MKJi0+asaJ1GUD/4wf1+K/GUfUUINzQUWexUY7V/2spdPV
	/wegVb/ow3/IpiJEaerJWQ4bl5Nrlug=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9t83x8ui6APYaDPpbQb5BP7fzrJtMQqqyNXMrEjn00M=; b=fgOPtMwyT8Dy0sQkjYJGxyDXuS
	3BBkNy+Da8QYkx+MePzwZEJq06SrtJtkLKVqP0DStGOLHkxXavRGVyQPoqu7rONrvVZwQkG0HAIUp
	FgTzHlXEwdV/1igOI2caLp9IJePHSWqcGj0CswjVlO3TUPe/LIncF2yydUg1/N/jgsOupgkZNHemU
	wsLnHbBEc+rJXg1kOD8fp9aBpsyOwcHXvKJJ45Aytp0TkYP7AT2uYXr+8Eb8DiS3RInwvVsMw1lHq
	M2H0dQ9ic5gO+cvf8Qre34M3Xpnh2Utfg2mk+ZeUhgdr/6ESpX7pv8sxhN30Ra03pqkEv9iTAm2Sn
	aofsQ3Gg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnIPm-00000003sOC-2RcK;
	Fri, 24 Jul 2026 16:06:22 +0000
Date: Fri, 24 Jul 2026 17:06:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 10/14] filemap: Add hwpoison handling to filemap_read()
Message-ID: <amONfpgJInjm8XgF@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-11-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-11-willy@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40DB280003
X-Rspam-User: 
X-Stat-Signature: odcixgihwt1988yxftx6a4apq8u1y3sm
X-HE-Tag: 1784909190-274270
X-HE-Meta: U2FsdGVkX1/KkStI8edmqxwJVJbJg4GznoEyGX9gBku8qF6/XVl4lV9st3ranJPU/1cvlGXsd0VFZkcSXMN4aKe8hMUTycNfffsV/245IITJOACWxLqOTGvwbHHkVZEaUlGvNF4YxYLNHeEZaOmRNh+Ya3AomP6jA1afXY/jYw8lLu7ErHeOiKZFWuVyOvSm/HLfqlXG4PNDOAPU2YuQhk/LulEn7nfB6BFt7bRmENIOmuHswSxZQiINjrufR+XFrE8bHhr6zNP5rs8+z67cSfJr70TewlSdocTfVKA/ar64OqSLTvHqfCEdexJpAoKB/ZqcNv+uz7AWj33x8COdbXD+d+OUKh+W9gtVGzan4p5IctFXQrO51dB1R5RKNf2nFa2ttczwGyifumvdcPWRzP5ITKF+WGFE6MVjUSQGJKxF2Q2oEJXSPBiRU1YMplMRty2xPsEoLlx0UC1jm5qWZQLCetEe3LSL3bO38TR/kBGWCxgpPOhhRXNJd+UdJTjPjLcQT16FvyFw/W4wXXb0NXhEdf5X3ro9SA+9/BnfHQxetihY+6X/JsduwrPyZRcIsrwYrE7Z2AK88d9mOznYSHpccPu8QREx/YG9mX0VddMmqmg3KDaZZ3EBv6g7/SZljNS4VuZcJSWq2sIRk24YMD/K3zq8X3g9lZNX4v1aK3PaXoNoKe+a+1/YPUKFTbGu22SUvZHWaKcplMtWmZjNkZmuSwQ/3xiQI5hFvgxvep+6eBhGDTvRT8MO/y3Ruca/rHKHq4SqSHFnaW+k8snTOcoNnnKFH+BDOV6d/15HuedDO0RcEzxFw6cOvOqKIT/cff59OdcHB1m/3p9b/znIWHSH5PUnZTt0e6hIN1b9tzOOz+e9JMMI6ZRQLtxgX7QQ19R2kNpKUDaPEDrWUpz1uVp/RPP3w5EefmskI3yNKaEFfhYuf5rJjmw1zZGPBHKn/hrCAv/ex/v8ZPjFUU2
 0Dg2etbZ
 5j/oR/01HK3MS1a4Srpty9AnXp53VjODRhSbzRtzKcKmcpB5a4/Luw4GunPb1PFunAGOqKqDF+l8jFodiJN+i0vRDDvJhvka5DBh0kRdPT7cmLqvpP4GgUDYSjok+sbhreielPLOKhOfeTVwSnIp6wijr7QmtNrib1ZDLrDUeN43dhL6d7uouk3JMd09+jy1lKKT66KwZpwsOfo4PgO3Efr+GmiSpQHgAkLVNmLuAnjqr5gvnBHVZX+AKPZIHO15/hMEEC/5UKPAFalMXJaD3e/k+rC1HEEfbZTKHc1ij1uib3K9dxH+uSxV9KqUwy2W2QDELrAxqiwPJQtOb1hEUf8tjgPiBgHU2zk1foXNsYF91dFMvf5We/a7HdhRH51tGXYKVu2dytm1ILThmeeOsz8P69KLY+UPYfqTyiJX+zaDRqO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [10]: [PATCH v4 10/14] filemap: Add hwpoison handling to filemap_read() ---
> commit c46fb3fcf6cb7055457888cfb186af5ae3a493c2
> Author: Jane Chu <jane.chu@oracle.com>
> 
> filemap: Add hwpoison handling to filemap_read()
> 
> This commit adds hardware poison handling to filemap_read(). It allows the
> read iterator to make a best-effort copy of data from clean pages,
> preventing Machine Check Exceptions when the page cache contains HWpoison.
> 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 9cde74320e48a..b146c5228741c 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -1111,6 +1112,16 @@ static inline bool is_page_hwpoison(const struct page *page)
> >  	return PageHWPoison(page);
> >  }
> >
> > +static inline bool is_ref_page_hwpoison(const struct folio *folio,
> > +		const struct page *page)
> > +{
> > +	if (PageHWPoison(page))
> > +		return true;
> > +	if (folio_test_hugetlb(folio))
> > +		return hugetlb_page_hwpoison(folio, page);
> 
> Does this lockless traversal risk a Use-After-Free?
> 
> When this function calls into hugetlb_page_hwpoison(), it eventually reaches
> precise_page_poisoned() which performs a lockless iteration of the
> hugetlb_hwpoison llist:
> 
> precise_page_poisoned()
>   llist_for_each_entry(p, READ_ONCE(list->first), node) {
>     ...
>   }
> 
> However, a concurrent memory_failure() can free the list nodes while the
> lockless traversal is in progress, since __folio_free_raw_hwp() calls
> kfree(p) on the nodes without an RCU grace period.
> 
> While filemap_read() does not process hugetlb folios, hugetlbfs_read_iter()
> (added earlier in this series) does, making the Use-After-Free directly
> reachable.

Will be addressed by the spinlock I mentioned earlier.

> [ ... ]
> 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 58eb9d2406434..26a5f18121f90 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -2483,6 +2483,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
> >
> >  		if (!folio_batch_add(fbatch, folio))
> >  			break;
> > +		if (folio_has_hwpoisoned_page(folio))
> > +			break;
> 
> This isn't a bug introduced by this patch, but does returning a poisoned
> folio here risk a Machine Check Exception if a disk read populates the folio?

Sure, but we remove hwpoisoned pages from the pagecache for
storage-backed files.  So this doesn't come up.

> If a poisoned folio in the page cache is not uptodate,
> filemap_get_read_batch() will return it as the last folio in the batch.
> 
> Then filemap_get_pages() will see !folio_test_uptodate(folio) and call
> filemap_update_page(), which locks the folio and passes it to the
> filesystem's read_folio callback:
> 
> filemap_update_page()
>   error = filemap_read_folio(iocb->ki_filp, mapping->a_ops->read_folio,
>                              folio);
> 
> If the filesystem populates the folio using CPU operations (which is common
> for inline data, fscrypt, squashfs, or block device emulation), the CPU will
> access the poisoned memory and trigger an unrecoverable Machine Check
> Exception. The patch guards the userspace copy path, but misses guarding the
> cache-miss path where the kernel itself reads into the poisoned folio.
> 
> >  		if (!folio_test_uptodate(folio))
> >  			break;
> 
> [ ... ]
> 
> > @@ -2862,14 +2887,18 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
> >  			if (writably_mapped)
> >  				flush_dcache_folio(folio);
> >
> > -			copied = copy_folio_to_iter(folio, offset, bytes, iter);
> > +			copied = adjust_range_hwpoison(folio, offset, bytes);
> > +			if (copied < bytes)
> > +				error = -EIO;
> > +			copied = copy_folio_to_iter(folio, offset, copied, iter);
> 
> This isn't a bug introduced by this patch, but will filemap_splice_read()
> still trigger a Machine Check Exception on poisoned pages since it lacks
> similar protection?
> 
> While this patch successfully updates filemap_read() to use
> adjust_range_hwpoison() to prevent reading poisoned memory,
> filemap_splice_read() was left unmodified.

Hugetlb doesn't implement splice_read(), so this is irrelevant.

> filemap_splice_read() uses the same filemap_get_pages() logic, loops over
> the returned batch, and unconditionally splices each folio into the pipe:
> 
> filemap_splice_read()
>   ...
>   n = splice_folio_into_pipe(pipe, folio, *ppos, n);
> 
> When a userspace process subsequently reads from the pipe, the kernel will
> access the poisoned physical page (e.g., via copy_page_to_iter()), triggering
> an unrecoverable Machine Check Exception.

