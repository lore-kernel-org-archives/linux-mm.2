Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72EDE606EEBF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f/GtuQdE
Received: by kanga.kvack.org (Postfix)
	id 7CA7B6B05B4; Tue,  3 Nov 2026 03:33:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B706B05B5; Tue,  3 Nov 2026 03:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8C86B05BC; Tue,  3 Nov 2026 03:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46F026B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:33:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7380CA7D83
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:33:49 +0000 (UTC)
X-FDA: 85393144578.06.02BAE7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E07D4180002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:33:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/GtuQdE";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694827;
	b=VuEwmkttVAV4iTnIoNMslSAP09fai51Q4wUHwunH5HXKGkOTZYh81218/I3/Ol/hImPMWs
	U/t0tHsnyDG08hn0bTDnsAjmgsTgazHkRFLYL/X74gNuO8JRLeutCWPFN7nSfCLwydMvK6
	7KN2lFFS1H11hTKJ4xsg92N1rNtTp+Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/GtuQdE";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfvXeQqavRG0qJSmkGBAVeLuElqbc+mhuty3br9tZ5Y=;
	b=UoAZrxNn2YIf8uGiBHES39PFpDuOuberv2ZtScj+Zq1GbGDWzexkM/2Hf0Le1BUCBMHmBG
	qWA3IoEzfVQMha2Bc1/0VQZ6iIL9FYpB84qx4GerA8vfsFFalGL+Spn8HfHVBMXq1DlDGV
	uAHMo1jarfK92oyW/QPlUFFO13BVhLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 581EF605CE;
	Tue,  3 Nov 2026 08:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9787B1F00919;
	Tue,  3 Nov 2026 08:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694827;
	bh=tfvXeQqavRG0qJSmkGBAVeLuElqbc+mhuty3br9tZ5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f/GtuQdEQcRFugYP/2j1tR81r4z6KgErdVO1CFPNXSPKM43Yad13k32bTHv2iQxn/
	 X17EAqNAXwgz9XiHKAp0xSUPtRiy2QzOpzKlqhEEh8ddvarLKE2A1/f2hGPXeMug2W
	 THo2lYaveUaaIKe3lNeUqEzzCyaxDccwHdVcTIHNskQH8HLKFXg8adH6CfLvfspn9o
	 WjiJx0ZcXr9LDbW3oZXDXtVrndp+OlAO7xVoHiIB0WK+5+9OheInxmbqVqCmz6i29a
	 agyhx4CjdSE6EakD5C1zfbGuklXtRcN/VvcaIfk8syOXuSIATFUQvsOMu9CxP5Mn5r
	 8BH5LnwHocddA==
Date: Tue, 3 Nov 2026 08:33:39 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] mm: remove end_page_writeback()
Message-ID: <aumcXM1XFURi5ycE@gremlin>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-2-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-2-e7280bdb31f6@columbia.edu>
X-Stat-Signature: yqgxk7g6qksezzmucwcj3ihnxaekn8wi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E07D4180002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793694827-332819
X-HE-Meta: U2FsdGVkX18OL4tBW5zoD3DIb1wHbT8p6fw0AfS5JiAfE/nXb4NdgSZlgqaUgOAPgKrDtqK2qK6C4AHEbodcVgj7+OjysdlGdTdDbvoimWslb4ZhyePrEricp6CaWLB1MyGzCGnAcbetK8zE9u2I85Sb38dK7fDq6vJBSaX+PUst5Vupha8h2gvGrD8o4YnnQemeUOYoPr4JZuMmK3FYgC8w7LKlqc0DG88aHTYMkNBsJ4y4hx0CjIbF25ka7aLVBcy7DmemN8G3BsWdBSUCaHNtK7tfVbM0F3OA1BVtYk3Z1fFKXoCpX4Diwdr9gSG2pKIh9wKVx0qPOZ6prMsdqovxg8X5Up2RC4xHCmCgSB7KtLVNT1eThsAn5LfaYdrJ/Tr9MfwmrENohf94L7c81AmPAKxkw8jZxlLOdQCrVqa93cuDjlVa2FaYlKmSWkh6le74PNUx/304WOdvMYGzCPMteFNj+0NIJ5S+yi1qprNGRm1dTwZGqmB2q255SiHJTcrYbU7QgmxwJSvw0qgo9R/2/cYMi5In3JGilR/6Zd/nE/I0miEsmTLLIeePKmJtllJ5SVyDIZt3A4D1LuBBaExRsM2+roxjJq3i6R9LlOcmY3tLveR85bq6oQ2V4YPKGCZeIJounwA9omZP6jZ8gG45ijI26GIBa7Fw/umh6YToky14zqraHzfYn636safnCKiWBBMWDiBr5OIJH/UB3AlvmyIIaEKmigzGSbqwADXMZJe5oEOTf3czMh62gsQQ38gz9ceDcm5JnHSIrsBrnL++Ck98/LKgaBcoiADYufZpbnXHxJrOdAnQ5ukOCIiuIzuHpnzrHi3PdHfow+Io3dXMa6BJhcDUm/6KU80h4xE7zqxgtRx6Za6tg1pVAKyTnDKVbW8FzLUP5uXYCKYvOlg46B0s2XKmrD6umxzisDV4ekq3LmiJgDDxPeAtkO88bgHxv7XKH5bNXthEcL2
 LAQi43uF
 RWxlqb63oUbdNy50Eq8wXk0Fhm5r0IXpUb61EXXgXDH6Z+Q0hPbHGEBqRGrfNVJCLy7rrJW9bMjPBJdE6boxY4AcwMMWmG4xWdFANTy/6cDN0jMiinNkhdj927pO9kYnfucPAa3YtLK5ygKg8Wm6a14vmWjA+i5m2RpJn0k9niqK026kxX+rMlYzDhCJZ4WttLejx5cWHmbgYRuT08dITirGqf4tBit3FPtKLVFaraq0zh6WsiLEtp67nSEuvfmBlAN3dAnJzIMtjBdKBWBBiAPfaF+3HI7jucxLbLFRkdEOxKwrNh5KTBs07I+kzlewJoSCkLR3WxwIzaJJgQnwagjtbrl2Q08A1LJyVGAbVcVLjsrjqBDInQtu5tyWNl2+rmqeh1T1tPsoQQR/FaPjohK3XdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:07PM -0500, Tal Zussman wrote:
> There are no callers left. Update the two comments that still named
> it to refer to folio_end_writeback().
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pagemap.h   | 1 -
>  include/linux/writeback.h | 2 +-
>  mm/folio-compat.c         | 6 ------
>  mm/migrate.c              | 2 +-
>  4 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index c0f7c06dc6fd..692ce3867a1d 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1301,7 +1301,6 @@ static inline int folio_wait_locked_killable(struct folio *folio)
>  void folio_end_read(struct folio *folio, bool success);
>  void folio_wait_writeback(struct folio *folio);
>  int folio_wait_writeback_killable(struct folio *folio);
> -void end_page_writeback(struct page *page);
>  void folio_end_writeback(struct folio *folio);
>  void folio_end_writeback_no_dropbehind(struct folio *folio);
>  void folio_end_dropbehind(struct folio *folio);
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index b749a9a5a5ee..c50f404141b0 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -124,7 +124,7 @@ struct wb_domain {
>  	 * writeout speed.
>  	 *
>  	 * We do this by keeping a floating proportion between BDIs, based
> -	 * on page writeback completions [end_page_writeback()]. Those
> +	 * on page writeback completions [folio_end_writeback()]. Those
>  	 * devices that write out pages fastest will get the larger share,
>  	 * while the slower will get a smaller share.
>  	 *
> diff --git a/mm/folio-compat.c b/mm/folio-compat.c
> index f880110ac980..9f2cd0ebfbbd 100644
> --- a/mm/folio-compat.c
> +++ b/mm/folio-compat.c
> @@ -17,12 +17,6 @@ void unlock_page(struct page *page)
>  }
>  EXPORT_SYMBOL(unlock_page);
>
> -void end_page_writeback(struct page *page)
> -{
> -	return folio_end_writeback(page_folio(page));
> -}
> -EXPORT_SYMBOL(end_page_writeback);
> -
>  void mark_page_accessed(struct page *page)
>  {
>  	folio_mark_accessed(page_folio(page));
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 94e8cd46c6db..953af633ec0d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -859,7 +859,7 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>
>  	/*
>  	 * PG_readahead shares the same bit with PG_reclaim.  The above
> -	 * end_page_writeback() may clear PG_readahead mistakenly, so set the
> +	 * folio_end_writeback() may clear PG_readahead mistakenly, so set the
>  	 * bit after that.
>  	 */
>  	if (folio_test_readahead(folio))
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

