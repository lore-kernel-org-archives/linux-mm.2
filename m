Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519D9C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABAA6B007B; Fri, 24 Jul 2026 12:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C886B008A; Fri, 24 Jul 2026 12:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D727A6B008C; Fri, 24 Jul 2026 12:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A97C26B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:08:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E4581A03E6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:08:45 +0000 (UTC)
X-FDA: 85024153410.15.2CDAC7D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4779D180003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:08:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uGVl2qU2;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784909323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXStzKxn08yiwCsk0RV725qSWDOorXbCbPNItU+sABQ=;
	b=hYhDBC9F9+tMAlBIw9+RVPumj3Ocq+xfjBp6AFWVAOnrN5L9QpuPsZYFO79iqBfdKtRPqY
	qanDmFg6O23p0k173hYIq3WMKC6x9Xq06MbeWFRL5HI51Jg+VSPAGeOcVFkS9C0Wihyz14
	jc+lZeFqEgvgnGHbForAU1k5R+5fWdE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784909323;
	b=67bCqc2sZBn0ZLgQy49QNQBtCw8p+AjpZ8qL89aGOYfcmybJeKwIdE/5wL5GbEOCkPC0fY
	NsH5CSPqaok9aYD9TUJ1iqrPW6+W2olM66FvXnPLfEekZH8uGn7K/+N2gJiF7sD0m9Z72C
	gHD3fR4mN8Ls1rS4ZOkgXUiioBcz1DE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uGVl2qU2;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qXStzKxn08yiwCsk0RV725qSWDOorXbCbPNItU+sABQ=; b=uGVl2qU2We/HQriv2zRTu8jrWe
	52XFKY+0Eg0r8WY5X3dRexzhOALY4O2Er6CL+LrQrvBWdIS/DM1Pej2Uq0JUmSw/9wvbcdR7ciZNS
	mGNF2vHYdlPt3Vl2Chl03tLVrCgws7F7HWbZ2JKRir5pAc+7pAX5gSnl1xIu9S5bCKkT+O8ECq/PW
	FUtrkdJvJskpytGyVKOk0WZda9IxTihCH2xXyIXXU9npsZylISma+aJomMuiUtmtRQsVt06ZoAkR6
	NRCJ9Wzl9o9+J/kdh8/sTy4Xi/3/tvou5YhQWXYoO28ORfclbOJhv5sKBE74HCjvEdJtH6tIUl7T9
	dqmSKWmA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnIS0-00000003sba-1Q6u;
	Fri, 24 Jul 2026 16:08:40 +0000
Date: Fri, 24 Jul 2026 17:08:40 +0100
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
Subject: Re: [PATCH v4 11/14] filemap: Remove checks in
 mapping_set_folio_order_range()
Message-ID: <amOOCGrT2LEDIl60@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-12-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-12-willy@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4779D180003
X-Stat-Signature: raegt6th4mybmjbnegr8ufradyuu1qp6
X-Rspam-User: 
X-HE-Tag: 1784909323-732407
X-HE-Meta: U2FsdGVkX1+bNhJMO91ydCCDwcZvZLE0A85U8CL5UEpFjfc61hvbLUyAztPgkJlzqnjJ1RkuCmbNXu+7Yk7d1vj6NZumDng4FiA9sb0c9XG7PS9Kgzf7fiDJIy045sd/sT02il/pqj7JB6bCQwQVbOlTehQgz9opB3tPxXlzF0EjJxGCpgsdbLhE8w1XLE53Xd1/xzb1FSQhDnaTOkpCmO9jPBXEsjVIbO1F+ESkou1Y0ysZSSxfiNeNx9LVw0rAsNJkAV1GZ2+CIheVXw+FQIj7jVohzZJxr45NdKIk4bDGB1Bo5gSb42z4zstI0LVnoNICxWTMNkDBujnnEL9PFNPn02w4SaPJpM2+QlXW8xILmtu8RTKD7KB8VGhH/mrg3CD29bn22r78N1UNBX1zYQDxksqZIFd52f6Fjsk17DINqPEivsKhTFr3Vq4kveOUEaVagg1qu31PyW1MQkUAwggslIYxeifqtxgpCWmKdBCOusu29gPCOlSwhtSmNehAFLq43gAQth4Lk7czajlfrKFFD/7DNBx97q5Ap6THATbRKrfjy/lbYusgJxeZY9U+zhyUcmo4UOAmyT54CsRwkZX91CN46ToNTQoaavej33yYRUmOp0qtZOBYZn71hWBrMEfbs5rII6sElYRBJmgy9JvguKGL05NUXLTTQagyMN5AZvnaGqIrOxtg1vbSjR3S4Oo+5pXzOekV1buXPHQ7I5HAHOMXQuFVuhMWUe5Szv/MxynZhbbxZFdcvShzrp6kfN8mH3h591k9Mf2KKxGmi++0094OC/8DGT28zGMReKbhNQaBLJprAoT2Gm7u06U72JTKHjelmrd4QBvKmSzSc8tk+cKkdUloFrrsc6NkwHEVOO8rNt80PwnCJWcraQCkSymQMG/1RIx/cqd8dijpAFMl0w+TyFOzfy2fJ4b7APm9lvjfXzPhwW5afY6YoS/w6fUBvh5PZ/NcTYM0btn
 nmt6NBId
 v2D8FD8b0PhrdeVSgDEQJ72kmq2ZdXdHb0w5Vv5oBbLj12DxBcIMVUgxoOSHGXtToHn7QxWOBSsVPizEhJR2sP68y/s0CSOxPRDDi071MDdOdHK0d67eEONhwRyQ539C+h3M3uSnhkNfnKBrw48R0lYkJrKTZ4EGJw3wrOlgQYCjtz4lYQaQQvkDX5sOF4pGzVt3kz6XTy6idJyVpUH/PeKgWjKDPGAgdJgLRDStBzRgqaq0FvFlOfPNbfLj38C7zvP4aL7gDEgw5gqcTWTWlt+HYw9Kc82tCr+ahda+7ufRqI/Mp5posxRdr9UiDTmsIYDKW+zYuiKrtEauU/h+wThUJZLe8vjTaHoJPFT/F5X/ZyeLXCbNfABXOcR8y1X4O4FYvrZXYCsUuwveTZxzZp/vXB4FEeC3FeFvscH0hmbwhXeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [11]: [PATCH v4 11/14] filemap: Remove checks in mapping_set_folio_order_range() ---
> commit 795dd7139e11d246506bb93b2bb441409e4bbfbf
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> filemap: Remove checks in mapping_set_folio_order_range()
> 
> This patch removes max and min order bounds checking from
> mapping_set_folio_order_range() to allow its use with hugetlb. It also
> switches the configuration gate from CONFIG_TRANSPARENT_HUGEPAGE to
> CONFIG_FILEMAP_LARGE_FOLIO across several folio order functions.
> 
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index 2c3718d592d6d..436987f47aed4 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> [ ... ]
> >  static inline void mapping_set_folio_order_range(struct address_space *mapping,
> > -						 unsigned int min,
> > -						 unsigned int max)
> > +		unsigned int min, unsigned int max)
> >  {
> > -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> > +	if (!IS_ENABLED(CONFIG_FILEMAP_LARGE_FOLIO))
> >  		return;
> 
> Is CONFIG_FILEMAP_LARGE_FOLIO defined anywhere in the codebase?

Oops.  Forgot to continue the rename into this patch.  Fixed.

