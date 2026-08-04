Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F096C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569646B0095; Tue,  4 Aug 2026 12:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8DD6B009D; Tue,  4 Aug 2026 12:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCFD6B009F; Tue,  4 Aug 2026 12:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E69C6B0095
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:42:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80884C0201
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:42:35 +0000 (UTC)
X-FDA: 85064155470.04.A6A09F0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6E514A000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:42:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MjXC96u9;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785861753;
	b=6pS0OHCsmG85r0ycyaKR7do+1no8jQb3Cu96SB0ZZENFd6GowYz6nJO6n5T9kdhiUKNUTs
	laARYDAmatUr8sy/1NZWAq+EvqOHdM7tkRsJexdvTnPeoW5gOsqjWMJEfCYIoCFGoxH9VL
	YJvzcUhvfiTlIHP5Zcf2zb/eGXr8abQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MjXC96u9;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785861753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FgAlcxiaqBdg50AghxKto22Y8/6j7/dUrK1xbeiU0Y=;
	b=ovJZeRxMLjPKADSAS6AitCeks9UEe3MQMe2Zz+sI405tGFRTzxckUmputuXNku/EG4y45C
	ZAFg08FcA0FJw6pofUfFWLwzXJTVtg1KhPg6C2Hi/ghdv1tEARrYBx5A9s1bX+33+4ZVSg
	C/PIN5lFoNroXrPtHZjj3yLiCN7iVAU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7FgAlcxiaqBdg50AghxKto22Y8/6j7/dUrK1xbeiU0Y=; b=MjXC96u9Vz+lNdgr6Hsuj0Wjt6
	xamRGnnicLl9RltHZ1rSauQbn5Gs2RCUzfU7fm/u2aRSSrxkM1PUL5ontnCkbc7A6gs3baRDVaDJs
	jmloGB7oiEZ/tlqtMHKHl2xb1JpUbZfFfSrJvxo10gt4FqOgjJExsf6Fi/vut7IXbrAfz/DRqsXcM
	9+27RbJ8ZUNpIvMqFVPIHHeV72He0Q+uGPquhlKcuLZRRdZa702F6uGf8unm7AZT6JD3a6xwVEWck
	tJ41FCkQcTzUv6rY+VeACn4mPeRCyRMBBQcqZ4WP2xJyjC4toXdg5X9qc2L40a6vZqIRGMa7dV9sx
	XcN5HCaA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrIDk-00000004IOi-34Nw;
	Tue, 04 Aug 2026 16:42:28 +0000
Date: Tue, 4 Aug 2026 17:42:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <anIWdALS_1pmGA-t@casper.infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-9-willy@infradead.org>
 <anISVv340bo1l9as@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anISVv340bo1l9as@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 6E514A000B
X-Stat-Signature: gu967615ko6p3hsnjqrsp8fnwyawtt3i
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785861753-946318
X-HE-Meta: U2FsdGVkX1/Mk+OmCeKY5xN0ApMJxZKfbIAyjRpAkWXZhO8JKyrnbUIG2O2NO8+1Eay8KT8vBfAdcI7dIoeLGMapJodQmibrUPec1ZlG2DufAxMyAje9SY+3uWhTxWnzk3Qj4EQ/teUUJ5uyxWUdHUbdqOhnQmEGFcU7gPq2uOjYzyPRi9+RJKd4VUYKFxCX4lFcpYFLLW6VR6j+5WqgGwXg6JmRJDwMcvf/m/iRZRno0bJ77uJqAwVtvL/KC3hVdNha9Zj+uPSfzJBxlDL90B2yt0SP9lju2zczJFq5BAk9PYIJoVN7jSpDWyrdqIrdctwA6y9hEbrCJqSb+lgSyXwBZMY8Ytxn8b4Gru2TkfxipjYOO0dFHvX4tvoka/RnfR7G4qi2s9a0WKD2BkCZtWuH4Z3FxNHepVIiCbI7YE9rWuw6HZWiv7XF3UbuEOCjBNvODeADhv/eHVy6TW7zo511bD5klNiDss9R0NQwLX5f8lXzSNn38czHp1sflorPe0YUDOax558l3gKrd+MXDRjZ2WXycFWcvn4j7kLosqLwepWpJI8P9t42RKQzF3cEzv5JgMJTc26FFQwSUcBEVpn0+vcH0m3p3MzWjAhT5JrhkigHT+IaRxcvEcLcAnbTtalT2iB1zkBNn3J3Ob+yKkXR1dLVjp80Z03kS29iUcCc81Y/OpyqiR8J5H42/3Hb7FvmB/HN/AG7OoMBqV0EFgL2F7CAB3HP1QQPY3dFNaHJ8y3H1ja1fQXK2imtXfJu+9iZl1k52exJTP5ALzzZ++VWRTVGCID1fUHpytC9iY6bJ3arU/gdN1Rqn1ScNdA3moZpPtOgRdSOyY3LevhkWbWLW+mIqhoJuZDiNLluuB3XLHIyqFdK5xIPTCHxnRBsHgdfBGatxmkr7DPEULwfByxO5p0wZc5cGS4AEutGJ+2bGz3FOLmPOfWaBgzV2bxMl0jOD2+Bf+aeaj54IXj
 Ba+peMCc
 VM4TciZVkbXC1OdAgPYVN+nDSX/IXhlqK0VVKr8rSL0vd0CP3f+3GxFLJWWLRIlkT2P1n7pddhQFSzysRbhF3NUMDvi82tUc6z4QKXr0wwOs2/u0k7Xr04OL2V6oUcgCcXr9556XSipBoztBLNoHgAI0BFpU8mRJk43UrGqeAcXXudYYi23IE5CqUPx6a2sA16WaoQ2x1zlhXGW4wXhGnKPSbkEkG39/9Nmqwcrshdizlg2G/2YGcendfB1tazxB9Le+uwpLlKAS8oVoIw7TMUY/ydO3EvzyJqstDZLeBV57Nuy/XYY7ymcTGjoAwPstNvDKWfcAyv3cKJQqZzSPI01rZX+qVvmFNbeMRw0TFiNNvbZnjUCCKk1WDrh4KPjutYEc7KOOUCIMJXNrSEYCTtkwjhzUr4iSz/C9w8ZgtdutRQ+vM2SqxpIwInyb1EKif35lmQ2N8eOrj3q0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 12:28:06PM -0400, Gregory Price wrote:
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks, will add.

> > -#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
> > +#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_LARGE_FOLIO)
> >  /*
> > - * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
> > - * compound page.
> > + * folio_has_hwpoisoned indicates that at least one page is hwpoisoned in the
> > + * folio.  That page will usually also have the HWPoison flag set, but this
> > + * is not possible for folios which have HVO (see memory-failure for the
> > + * scheme used in that case).  You probably don't want to call this directly;
> > + * use folio_has_hwpoisoned_page() instead.
> >   *
> >   * This flag is set by hwpoison handler.  Cleared by THP split or free page.
> >   */
> 
> Had to google HVO, and didn't see HVO directly mentioned in
> memory-failure.  Maybe worth expanding HVO to its actual definition and
> a sentence on the quirk.

It is mentioned earlier in the same file:

include/linux/page-flags.h:      * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it

but that's not obvious when reading a patch.  I'll just expand it here:

 * The has_hwpoisoned flag indicates that at least one page is hwpoisoned
 * in the folio.  That page will usually also have the HWPoison flag
 * set, but this is not possible for folios which have HugeTLB vmemmap
 * optimization (see hugetlb_update_hwpoison() for the scheme used
 * in that case).  You probably don't want to call this directly; use
 * folio_has_hwpoisoned_page() instead.

> Does "Hugepage Vmapmem Optimization" just report poison for the head and
> we lose the sub-page poison information in general?

We only lose the sub-folio poison information if kmalloc fails in
hugetlb_update_hwpoison().  In the happy case, we retain knowledge
of which pages contain hwpoison (and later in this series, we actually
expose that information instead of just pretending the whole folio is
poisoned)

