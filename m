Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE17C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133746B0096; Fri, 24 Jul 2026 08:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3EB6B0098; Fri, 24 Jul 2026 08:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F182B6B0099; Fri, 24 Jul 2026 08:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCA786B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:36:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4941C1402EA
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:36:46 +0000 (UTC)
X-FDA: 85023619212.26.B6ADDCA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id A86808000D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:36:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AsEU+6LX;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784896604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAcRu8XyRC6c1KYvag2E6br+9Ab27aPo7Usr2cRo7Bg=;
	b=X5ngwGknHVUuU+L73F82cafhmCntpmjLRGhhE8YgrTB0WZZKyzoV0sDvQgYwZ8JETd/AKT
	y6pIUSpfWvDrB+Ypk+0JYiobGiEs0DaXZIUODQoKoT6d2hhevbB0tZySIRVW7PVWLg4TFC
	eLytwEb+6opbqxNM0vvM/iaScIF9Ewk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784896604;
	b=dmnqB0U8sJvKUF8e4ZmYxZn1RxhM9q0dpAxoR5Bg5afSbT842KF2dsq/9NHN+WAf9PSGcQ
	nGUf7aq9G8pGHHn5FRMn74QvKievduoQQcmb7paSxu5bw7T7xZhdW08lZYevG9vyQ7LM2U
	FVLgn0OpsOCSu/JjkFnQ7CWSEylnsHI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AsEU+6LX;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pAcRu8XyRC6c1KYvag2E6br+9Ab27aPo7Usr2cRo7Bg=; b=AsEU+6LXkOOTnSJN5srnxDHToM
	3BkK3affkSfkdzX83j3/PTatcDBhdCqF3kRdsxk2dO6SHqa5SVAoRuhxmmf1FLIAL/UtYw4tVwfY+
	c0jRgm28iGO8JiBIW8BPe8M/kqS3Uv0x7S6JEyAW82VtWay9DuYWE8lMAjL7qn1107zWs0q9lUZDl
	bVV1zMxfKpOB4TgSvcDclocdtcU6k/NUYnykQXqHtWieQNwIS0EGTEeOyC7oR21bvKj/5ejrRLhss
	CJMt/yPrmAAN4nMSvNU5Kw8/61i0E+qBPoiDO4sWZ0TqRwQxxPirg8gorwIWmukjjI5CJCL7dPHAE
	JIMivmyw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnF8s-00000003SyC-0Fy2;
	Fri, 24 Jul 2026 12:36:42 +0000
Date: Fri, 24 Jul 2026 13:36:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v4 03/14] mm: Rename folio_contain_hwpoison_page() to
 folio_has_hwpoison_page()
Message-ID: <amNcWf9ORxyNqpiU@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-4-willy@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A86808000D
X-Stat-Signature: witqjcefgfb7t8a9urw7tjaxaifc11hh
X-Rspam-User: 
X-HE-Tag: 1784896603-457032
X-HE-Meta: U2FsdGVkX1+9EIB1rSZZ6YVqPdJ/QkZDyRDcQ02aG9a1rAo4Mwr03LJ5kgpv8xIHhQbp4FPHbYCS3YMG9Nu1Hd0BSVnLcnZ2k+6FYqNdEnZDLYVxZA/FsbeXmG3cq65oUoFFBj4nZwsaLmOkn1JCHJHS+4Re6oEYiqVFFqzIpCH/Emd27zBMOy5iDs6SFz3P8hpD85YRsfWMfcAwfJdA4CZn6mJnTTdB81o23FmXcUgM6DUxVBm6EaODMTolFK2Gfs0pLgZEsLIaFhLutTfBn7MiU9hn5B5hOnlwKKSkkDFLyP9DKB5GYwSzB/lS+L8jIYELCxI1jabpdJOJRJIlVwfPkmarWDj5n4XJMoLQF9YMPOwn933acRTjUa+s2OZ7jtfOR5F26oBSAOLqgkFDt0UGqEZcgmzcvNqby1FUscX0dcqlnUKryge/B/Ii7xPqWuLIHBIuOdMwJWjoEfijtrmqdfLTDzsRaRt064sus7MOUqdmgw3DwBj8Gklw9sEdr5aAtQJCXvXhidAsyG/ZxuMeQ1NWCfWgEccb3Oho4FrsPyoG58oz3DldrILeWvnyHiEIfxA98hAJryyDOkiJfrBzGK59iLwwr+UFPZf4WZrMn+lKol8E/s5NR9Rv0yJFXkotiJV8vIapLDj88KHqZ1acEKLZsPQsWOGDso/0pTxyhf/7bcMRsry+xJGKw0RjgTToXxgU+hI1Ve88QVEfkcUV2XBWDnyBMW6lVYBwKwp3gmcRUBnsl66nI8IH+iZZmQNSztWbV5IM+hUt5roSMOFpf/6jkcpP5Vwh6zNv8NZCUnXP/7HZAj6tTQTQEArFp4Y457ClFiSDLfzcI5ukQpMQct0uJ+GRFP0ZOYsxA57XcHkHyApVe5GbC8PeQPLHQP5zSCCIBxmbCt8EyX9p40MxxW6VI7O8DvIm3GTwFYPYrT2KPzcyrUnWJJqkC0sWCIGPbnd3E0ZF7lOzV0D
 Oy3FJHRq
 092u+MxRPzjVKgnmAqPvdEbtEfnPD5xmmSTtBW0aXk/0NrPmycaHba0E6tVaQsuaYN/KpsFpXjaJzQ7CVOJlzJbCi/Jm+tLPVd033CwAoEeC9U+vcJrRZ2XNKsTQz23ieU7Isg4LyHjjfQWyoXzZHnf6lDH4rx/l4d0RP8ElNzxCdJr73l0Eu0Sxn+Kt/sqt07Bwk488ma6diiK/ayuBYRQnD8wrX8jW6clrpXlsmP9biyBXmPaG+dpvrt/0nnhAxUYffc725BRu9c7jj+Z/039evuqwA6nioRHqlOGFkVPZuPjgI1ZqFIzENJ6nuy9/TW0MmDDhjuTxExQq+ND9ip3576IH6+oTgxhKRcKX/7fLsmQJl945pnoZ6fcK22XcqBdaIdJ5dwn5ifM/sxPV/cU/V3wye+3kliBNzSO+Pjf3MrgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [3]: [PATCH v4 03/14] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page() ---
> commit 82722dc6d8a8b8030006cbc0fae2e5f36ec21fa1
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
> 
> This commit renames folio_contain_hwpoison_page() to
> folio_has_hwpoison_page() for better naming clarity. It also makes the
> argument const to allow other callers to be made const, with no functional
> change.
> 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 7223f6f4e2b40..4185a03a45cf7 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct page *page)
> >  	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
> >  }
> 
> This is a pre-existing issue, but while reviewing the surrounding context I
> noticed a speculative folio access here.
> 
> When a privileged process reads /proc/kcore, read_kcore_iter() in 
> fs/proc/kcore.c iterates over PFNs and calls is_page_hwpoison() on raw
> page pointers without holding a reference:
> 
> fs/proc/kcore.c:read_kcore_iter() {
> 	...
> 	page = pfn_to_online_page(pfn);
> 	if (!page || PageOffline(page) ||
> 	    is_page_hwpoison(page) || !pfn_is_ram(pfn) ||
> 	...
> }
> 
> Inside is_page_hwpoison(), the page is converted to a folio and its flags
> are accessed immediately:
> 
> 	const struct folio *folio = page_folio(page);
> 	return folio_test_hugetlb(folio) && ...
> 
> Since the folio is unreferenced, could this cause a kernel panic via
> VM_BUG_ON_PGFLAGS(PageTail(page), page) in const_folio_flags() if the
> compound page is split or freed concurrently? 
> 
> Should this path stabilize the folio with folio_try_get() and re-validate
> before checking folio_test_hugetlb()?

This is fixed later in the patch series.  Bad bot, no cookie.

