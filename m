Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7983110FC456
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 02:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803E66B0005; Wed,  8 Apr 2026 22:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5076B0088; Wed,  8 Apr 2026 22:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAB96B008A; Wed,  8 Apr 2026 22:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C65A6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:07:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAFE5140366
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:07:49 +0000 (UTC)
X-FDA: 84637381458.11.987DAB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3387140004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:07:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eJOGiaka;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775700468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqlE6AJjctyRx6Wy0xNY7ePP4J+esP0ggSOpTU/KgI4=;
	b=Q/v+C7Vcze0a1KnILRo/sIf5pUcnlQ0t1COlsFNPgj30cTplPY6l1doGwJrDONl5p2QuQf
	81R9t3S4h5Jer3WJ+DCLgYdoTNH4Hc3ldGgRfhadLRn1Dh7D1OQi04CRfm0eUBHYFjUCT+
	dFh0VUKgdhcTdes9/e8RO/fcgeYwRgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775700468; a=rsa-sha256;
	cv=none;
	b=OAYKLFiJsxGaUtXvHIr7DceCUz4o41EQsKh7dxAwW6zDYJ/JPpmlCTjkhldUMjqIXfubsS
	3xkDiLhw1tA4IVer9+fAEwZS+TlwZ8UNhiwiv5kWm9IXdpcyfwZulkriLh3SfXVwBUzuS2
	Xtz40mtPR7OI9qaYVo2c3HXSLfU8e1k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eJOGiaka;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6CAA44197;
	Thu,  9 Apr 2026 02:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8988FC19421;
	Thu,  9 Apr 2026 02:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775700466;
	bh=f+BvsdXCelqVPu1ZTii6+3t7WeF9lW4AmeZ0lcGbNM4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eJOGiakaGP9bFmnUhNDXoJ5WHtDM8DNU3thdhKpYCHTNePFYo+WbI7ute6MoV0Wz1
	 GgKeSn6Etk3si2QyCLnYknLPsgrIoXHDlEc+A4pZaa2tdeHUy9HruM4MmMOFmJhGEh
	 +uSKdrmqrofCbwM4+Kf2/BP0VxbH/zxDxB5snep0=
Date: Wed, 8 Apr 2026 19:07:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>, LKML
 <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Sourab Gupta
 <sougupta@nvidia.com>
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
Message-Id: <20260408190745.40f0c0231a475e697c970fd4@linux-foundation.org>
In-Reply-To: <20260409014647.397515-1-jhubbard@nvidia.com>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3387140004
X-Stat-Signature: uf9jcj7fjud7rg4rt4pkks8kcpwyb9nn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775700467-955552
X-HE-Meta: U2FsdGVkX1/TBHQQTlAQDg8D2bYyfMruzntPdKEqSDb0dy9AN4rgoNWpihT74fyyFWan7mX6SbYLHTB+tEbO0x0N81EPy9dhtuSqBNBIr4pmCLvknrxQI92stChi5DyE7wvJs5OZ34tRXkl+LgiczS/b+isOzNGAttLiR8Nkqq3MQLmvoyQUOy5wRcWB5kO+SQC6ntECyWpJ2pKgWK82yMJ8iRAu3ZfCllEYTnzAyCLVw+RmY1jJPrXoE9R3eqdgfvS0aJ6BaNde7o2o9lBdpeR1dCAthKgzCE1vlOXUbx2rO/0PkBo/mK00rZifDbHMfhX8XwPgJF588DXhWuCrAr27SZCWweRc6Md4jw76zOYHEkbl1r+ISdonfK8w6CngpVBqr75BKONSpfxp5d5SeiABlZA9GiU4HARvpq7IFtj8k0VKjCaPgO2VTJQLpoyap+qVR+C/utG4Tbleyti4wVn8NHKnWE2GxjwSJigPOYlkBTaYkNmTqNwQJ4ne7KELXq13YABIB6MMPXEB/KVipzuUEzl72d77dCFFgDJ5Rst3CPvxeA1Sss17OkCxuk0sRGCDZ2fhgRJ2E3ju5EOrVAPM4CkerxUkxxqZDqxlyN64BAQMCc00kXnTLQDXBjsVj/ETT5NiEkIeBcAzAJJKXC83sOyNK4OOdTs3xywKtF2g1JZFDNbX2ygtI/dJW6j73ym1a1DHZh/tVwzTvzSDvQPHD6OwTNn5bqcmA1C21lc7eSjYALcFc7v8ewiirRa/TeNklAFnPWLa6KSVQkEzT+Nwce30rLDLHVD0ErOPvYW0QndcKhvpcxlkNMnixa5c8uQj7L4eljIoqTPIOkFSHl2zBrb6BmxnusfAnQWrXQKa98wwA7I4pjvT4PUHuLALwyNqgQcKma9MbrFg05V6b5+5KiePIu1mk4h1TOrSpcUhUATWPVl2dddwysHV8NyQ99BMLSl9iMxt80G3U3Y
 4nHJLuN5
 2ZuE5t6kYoSvF8AbqqUzXWQLNvj6Chd8pVl1qY2BKVVc0MZWKP3uKDqWaSR/lx00Q9vdhC7WgWGG6OHlRA3Zym4u99NYhxDFfbDgwzfcHxiosJPuD9Ft1799MFlih8+oq8Do7Zb4+saqCjZT3H9Ji1172K57260yvoo5Uoe6c/sBcMh0wz4WycrF4BxzBDx1LJgmIZ58gGU1AXZp+uappsmvwPVpfR/vZ8LXGURdLvJaatc+6hbk2NEsEwsCJHAcBeO5dHgJXC74gGac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Apr 2026 18:46:47 -0700 John Hubbard <jhubbard@nvidia.com> wrote:

> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
> gup_fast_folio_allowed() falls back to the slow path for any order-0
> folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
> performance regression for drivers that allocate pages with alloc_page()
> and insert them into VMAs via vm_insert_page(). These pages legitimately
> have a NULL folio->mapping, but they cannot be secretmem pages.

How significant is the slowdown?

> Secretmem pages are always added to the secretmem inode's page cache via
> filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
> A folio with a NULL mapping can never be a secretmem folio. The
> NULL-mapping check was intended to handle truncated file-backed pages (a
> reject_file_backed concern), not secretmem detection.
> 
> When only check_secretmem is true (and reject_file_backed is false), a
> NULL mapping is sufficient to prove the folio is not secretmem, so the
> fast path can proceed.

