Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61189C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A465A6B0122; Thu, 16 Jul 2026 11:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14856B0126; Thu, 16 Jul 2026 11:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902FD6B0127; Thu, 16 Jul 2026 11:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1F56B0122
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:04:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8CEEC015C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:24:45 +0000 (UTC)
X-FDA: 84994860930.25.6160774
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51986C000D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:24:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ifn++u3N;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784211884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0b0D6Kjf9xQir7X3LyFTEp/Zq+ZumCcrEIpFFWjBNI=;
	b=rB/FmGIYAo/UUr3lZ/EwtSUTfu5NteFIMrV24k0nTh4QvymcMVdLJ2Q/NFpkgRXUBxTueW
	nd2xD4pgN9rFmOmaEZENaSx/Zb8H09ufbLbxnrAwAlHfe+/vAjTtykVdyHFHP91M+0vKMZ
	WqR1njC1utcTT2p4vCPAvuEB2TMZwms=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ifn++u3N;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784211884;
	b=hj2Dj1OU/VzHlN0b0noby6bhembP0nROgWEezCXqeOsOU3wJW8CQ0ehQpMviEPqeZztUDZ
	ZG5SA7QiLMk7+IezJl+ND9t8IOvW4jvwGLAtoKX4aLvgedTubpBcuN8Noqtl6Z/rzxwJRE
	4yHov/Bg2Ohls3bvGypTE9sm14gx54Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X0b0D6Kjf9xQir7X3LyFTEp/Zq+ZumCcrEIpFFWjBNI=; b=ifn++u3NseCju98sW1l2S0xUR6
	b/1dZVJ8iwqUItdOL0ICrvxwBfopYJ9SndKW409lFySe8+hPnJXR083jDS5wksU1pPtIY1DcXIMPa
	GxM1Cj4HoISaIDGYKuUTu9pP4ANmWvqIAKNLa7BuU/189WniSqd7yAAisTPfkLYrXB1jXE3Dn6Oe/
	dTNd0Wlwoag2HX2pD8xo/8Bb3JHXU9oKHIXbX7TgcgWhautMeJ6fYjqTcbf4C0ADMxBF/0M/0e219
	45dNYIdar7dn1wdkDZYfrape1U51J9B1OyfnSM0hg2TrhR6aFsUWKPI/IkA7PgydOQL0WOrHGZcg1
	7xTm9leg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wkN0s-00000002fXC-2Fnb;
	Thu, 16 Jul 2026 14:24:34 +0000
Date: Thu, 16 Jul 2026 15:24:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
Message-ID: <aljporPjnUCyhQUs@casper.infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
 <20260709184740.1286561-7-willy@infradead.org>
 <7f630930-fbf7-42bd-945d-664484defc2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f630930-fbf7-42bd-945d-664484defc2c@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51986C000D
X-Stat-Signature: fzx1f3p934itk4g5pckcso3zf5im7qq5
X-HE-Tag: 1784211883-297786
X-HE-Meta: U2FsdGVkX18eE/61i4HB5Dcoxk+tKV0hVc8wXQn4X8pCE7CfoxxFI5CwG/0KLmYLyX5PtSq5scSfwrDER6JaPhAMTDAuI0SeLkXZTg3z2iRcGH/06pgzPB15sk3KY+BPDB4WF1WILKUvc2rljlkoETVKpVXwn4u7GHh8TCIPhHQ+UOcnWIbTUWY9RamkpDsDkxXCIu7hwmFpNiWx3rTkLTXKgvpaKOg3R62Ka8HPZaFWkSitIar+aFRgkP5Blp+unUOrQxd2JsIygk6ewVjuMx5lzG3GIJoLrRxkvATB4NFTafIqXJf78ndSuJveSRNYEvNA+fitqTZ8tu4oT89OtVrACKfD2Svh/yG1to6NZJ2uySqzaUfJJzZQtGqzsLj1soDmi3MTmfD/pjb5SKXjJn1I/6UzR5g/cksOjQqFY1WC6QhsleEKSR7az8muQSJk1Q+ipRLKYFcvErFiOTNB6qzOhtU39IdjXIqyhKwghLo/ou5ZwLiIA471yPFx65t6CYJlqNhHiMJ1hiY0jjSCbeWovq89/mDTbZvyY3UIzCRsh4CUeQplh47pLLrIBiDjQz0Oe9zFR7kxB7FLPtjAO3gkQvHwjPCbglJuz6sFu51pKrxwKIohobDuPC2T8TGBpES7emD3VGfwN5J4PU6HkDWE409Ny7EgE63TpR4vwim+SHElPqPCiPYRdf6G6XGw4OItAyv9FWvODDhI9DpUtKe36U6BYI6T6lc7DV/fY5TCk9CUwe6N6YYglWYzONbeHIAOUwJtjPIfKPIFtco2QfzshcpNjAEeN4RInN2zTkhZ2n/+QC1JRswMsu1VMqPMhb9r3f6YkpyAmvpL6/EFVcjKNL5LYwNSmywmXD6nQ4Tjf2B7JUmYZIDO2aKEk6o9WL3o2mj845xcNknM1aXoiV8kvpLGYw8CBq4eObFFGlpkBA4/TKn8oGSqAJJu3x820usuzZWKrXsDuDJg52n
 inyjfkQu
 0WnXwQ9fq4ErYdFDmWuClg2MDO7kVvte0e6UXyEpyX92yB2XxyIHV7Xbua+a+C+hURdifhAQQZfutGyPZgx6WbQvdXaWinj8EYpN516Ot5wswSUHl+h1/VPZWrqB1srUFXEnscs7kEkH/LSgE0COCaWj50s1YORuAatvKwWhZeAYN7cf5joxsJ+iCl7L2aI2bK9jUpWyisSXJtVniQwv284O7+wcsM9LtEDvmU7BZAC3JRViBCU/ZvEgSOJal1BQp0Px8HZJvAAnBdLnZm9gSbdMbablFoYwpA0RJNm1FG0G7nrhgLxwtHkyM1FjoPkpheqO1FvwKlbzJYo4HrjV+NGrdnMJMkmnwjS1vQ1I0HcqYG0NnBydZKXPqAf1fivWNKw8Lzym97epX2u5IrALmkCboFaLyzmCQ3okx+e3pyfBz6c2WS61H6E8cBOC7HO0eVnID
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 11:16:48AM +0200, David Hildenbrand (Arm) wrote:
> On 7/9/26 20:47, Matthew Wilcox (Oracle) wrote:
> > Most accesses to the raw_hwp_page list are protected by mf_mutex.
> > However, the call to folio_clear_hugetlb_hwpoison() in mm/hugetlb.c
> > does not.  This is probably OK today as this is in the freeing path and
> > I think all current calls to is_raw_hwpoison_page_in_hugepage() hold a
> > reference to the folio.  However, the next patch will call this function
> > without holding a reference on the folio, which will expose this race.
> 
> As mentioned yesterday, I wonder if we can remove the entire subpage hwpoison
> tracking. With HVO it is just beyond ugly and not really fun to maintain as it
> seems.

I have other ideas for making it better.  Even with HVO, we have space
in the array of struct pages to store this information.  We keep
PAGE_SIZE worth of struct pages writable and map the rest as aliases.
With a 4KiB PAGE_SIZE, a PUD is 1GB, composed of 2^18 pages.  A bitmap
would be 2^15 (32KiB), so there's no space for one bit per page, but
memory failure should be relatively rare.  We have about 32 uncommitted
bytes per tail page, so we could store 8 32-bit page indices in each of
about 60 tail pages, allowing us to track 480 defective pages in a 1GB
page.  That feels somewhat more reasonable than this llist_head
structure.

> Regarding read(), it was added 3 years ago [1], and the cover letter did not
> even state a single real use case.
> 
> "Since memory_failure already tracks the raw HWPOISON subpages in a
> hugepage, a natural improvement is possible: if userspace only asks for
> healthy subpages in the pagecache, kernel can return these data."
> 
> I doubt there is practical use. But I'm happy to be educated :)
> 
> Is anybody aware of practical use for that?
> 
> [1] https://lore.kernel.org/linux-mm/20230713001833.3778937-1-jiaqiyan@google.com/

I don't think Google did that for fun ;-)  Take a look at
https://lore.kernel.org/linux-mm/20240924043924.3562257-2-jiaqiyan@google.com/

and it's fairly obvious their use case is for trying to recover from bad
memory when using hugetlb to back guest memory.

But hey, Jiaqi is still active, so they can speak for themselves.  Cc
added.

