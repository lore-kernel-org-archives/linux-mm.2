Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6CA6C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96CA66B008A; Tue,  4 Aug 2026 19:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943966B0092; Tue,  4 Aug 2026 19:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881176B0093; Tue,  4 Aug 2026 19:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 659966B008A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:53:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF3011C09FD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:53:56 +0000 (UTC)
X-FDA: 85065242472.18.65E0869
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2C5EBA0013
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:53:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jH2dFmcx;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785887635;
	b=uzufwj7gpL3j+HtDQz3jlwuSYlQExTq6mIvlleMJ5Jk1FMUoQR9BXDhkRuA2iLq0RYCFp2
	pJG4qpZU42dH2HXMxgHUh3iTa3uY2NHvhcj6AZWZzdJzpDTTskQQZTuvD/EevOiC8+nGpt
	rLDjyCjawPwG7lCZ5nXl0+R8awyPEhE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jH2dFmcx;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785887635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMeVpFS6N8BZKI+nhMYBTzNMVKlCDDpkyjioJy+/0kM=;
	b=ll8lNNHa/+WznsiAK692C3LNKW/tB5y5ymD/zV0u9V5XNw+OpCWNhPhBv5tlUS7PrtfCWO
	o1pFVZfLi4djPfJM250GqmJxpAHnRUEBFpzChYuYtYALChfslQD6oMC2u+EAfyOkfkJJcu
	vfR/DWN894d2C9XSkJ4dL/v4Ckc4KSk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qMeVpFS6N8BZKI+nhMYBTzNMVKlCDDpkyjioJy+/0kM=; b=jH2dFmcxEefQtDz1cvmV2YpJaG
	gWAhL16FO9WXtCg+BwwKZB4MQLPVP4Dag/k33rNCCLrqvJmAbtkhXeZVXmQ5qGZU1nCuNO07bHadj
	BEKHOI63rXldkkvyT2AmwLrvOPdjB/lCeEnxo4JOYrxBJuVXHPWF9pOkTzRoddU2KFyf4QwsSYQU2
	NPs+/txzIFHVQMgBLwDGKaDE9KtMUZz+9knX+GY/FhyHWq0l55eaOG6hUvHpYCkrMPElJmL261tLP
	8RTdYlmsWJup47q6gSt4M+xNZ1hweYGzjymL7KyLI/qBO6r/YfteKwB2RwSepM/PGydABHxbhubaL
	+BBz4mhQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrOwc-000000053I6-2gPY;
	Tue, 04 Aug 2026 23:53:14 +0000
Date: Wed, 5 Aug 2026 00:53:14 +0100
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
Subject: Re: [PATCH v2 08/10] ceph: convert page cleanup loop in
 writepages_finish() to folios
Message-ID: <anJ7am6p8iDi-wmT@casper.infradead.org>
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
 <20260804-remove-wait-on-page-writeback-v2-8-81f0ab065284@columbia.edu>
 <c0cc3539-be7d-47e0-82b7-9d7239c37907@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0cc3539-be7d-47e0-82b7-9d7239c37907@columbia.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C5EBA0013
X-Stat-Signature: nwsyud8bwd6esetas6mhyeaoys9e7mwu
X-Rspam-User: 
X-HE-Tag: 1785887635-717811
X-HE-Meta: U2FsdGVkX19nsjRVtRLwsmmWr/cZNfZZjBBpKlqCtISNItOi3HkSjhJn3XBcS4//VvIDRu9zFL2cCXnpmxWOftw9omAkbbGwPZZpe11a7iL7I5iL7pMi2i+uN0uWIQaEaT+6uRfBxHaJaobEBxcvkCnK62dl63hu5Sf2lQjfZd1aLzHOffL8TVJ1rhi2GbTaknsz3OE27aZtUxfZfEhmazJZSq9pNtAQkf+QsqLnJKjSK54pSsycMd/bHFRHixcU6RyEXOXOav6ix5pJi4rpTI1epVHlCwCkugE9XvLgJwfquDeWSgR2mz7Q4q/Vym3GvUePBoUN27LgLt0jHaso3xXP0uaPkwtxzWpMj61NAYbe1P+l5PNf3DyiFWZMr/HKq1hxd4S3awWXiDQafDYYSDUQjq/DXAjIUeiMmaMfJyxvpkJ4rrHIXYnmDwKJYW+qdIW1fwbLH6hdpAmgnHFzgVddbLzMSWj1XAghcHwOw/q/FOSJXw1+rjlboyVKBAXXtD5cuNSj8YW48ca8hXKJF+5q/CHCLjTc2js9fnUWdEZOO0IwC0V1mEuCh/XNjSmN/aor17nFDx0KsH91ATsX4V9Kpz4P8T2QOG5O/jbPYwhBJkqq6MHJr0mMUnKBZet/lXAojpD9yf2BFjPMkouEswbcIuaLbP3Eq7QLH+P5U63MnNNVbDWh2lxOTvuJPFxvq8raMX8+/f38S9DupVkzmZBtkUl3bZ1BplAzAIeDF8xwhoHCkcVcKi7sPpYZD04fec/wAcWF5DEIgKgJymK1bf72ylxpHCxLAmZvUZNKkEEMfbVwLLdGn7Doby3K6H6lx4b/SZ2TdIEDO48BGoPIumqQiFqlBEyLCv+Q6YJLWyCTVv9kjGgg5pKSQGA5s/O33qewwaPLUhAAz+kbmql4Va//K2UHRWVsUj5YjTsTsfDaFSkldWCbJO2MX0f5HT8qv1sNRjEXt9hquEl8MFY
 cimyb3nH
 a+7qzlhrTIBycqa1aKmjb1ZGfcw3conmJ3AR0iWailvVn/Mk4ItQroN4IQK9gOXv0lcM7zLREFVHTJ+FgKVrQEJDhJEnUWbsfOiThZO8MndurLqmsqL/C/z/MGdSNc9v5H3tbly9LKVzag6h0k7ymdXvF1jGQX9MXNGdMF+2IRBW67lDeyVhRYaZzMhJPdcKBtf0Oa/CNOIKbUoUljEZyqQwRh+RbTOLGqOWRj3F14LnN38hGKh5zfyZIFWQt7kisJMJfk1jZY9X1v4EfOLgABKmgnF4M39NGTBgX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 02:33:34AM +0300, Tal Zussman wrote:
> >  		for (j = 0; j < num_pages; j++) {
> > +			struct folio *folio;
> > +
> >  			fscrypt_finalize_bounce_page(&osd_data->pages[j]);
> > -			page = osd_data->pages[j];
> > -			BUG_ON(!page);
> > -			WARN_ON(!PageUptodate(page));
> > +			folio = page_folio(osd_data->pages[j]);
> > +			BUG_ON(!folio);
> > +			WARN_ON(!folio_test_uptodate(folio));
> 
> Sashiko complains:
> 
> "Since page_folio() invokes _compound_head() which dereferences the page
> pointer, won't this cause a NULL pointer dereference before reaching the
> BUG_ON(!folio) check if osd_data->pages[j] is actually NULL?
> The previous code checked the page pointer before any dereference occurred.
> Would it be safer to check the array element for NULL before passing it to
> page_folio()?"
> 
> The BUG_ON can just be removed, as fscrypt_finalize_bounce_page() cannot take
> or set its argument to NULL as constructed, so the check was unnecessary
> to begin with.

Heh, Sashiko beat me to it ;-)

I'd agree, the BUG_ON was always unnecessary, and I was going to
recommend just deleting it.

