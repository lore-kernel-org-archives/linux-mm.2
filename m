Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A2C3CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 23:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5688E0007; Tue,  2 Sep 2025 19:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665B98E0001; Tue,  2 Sep 2025 19:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BAC8E0007; Tue,  2 Sep 2025 19:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40B568E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:24:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB16E140421
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:24:11 +0000 (UTC)
X-FDA: 83845890702.13.6DCA44A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FCAF80004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:24:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BfAvKbbt
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756855450; a=rsa-sha256;
	cv=none;
	b=FxC0+r/5mPa6LV/xPWAKZZ6nxSPgWyc0etgmzM4BIMpbmYV81n1B3uUr1vbEKwRgFMi/Pg
	yeppsvlgZiaN6PP9PudjKvOyLrfX42aUNtjOf0zICpKc+wy+St1V9yDLwpiVat+UTx+0T7
	YrKWqKDwV/UHvDr6Rdaa24+htHdmQCk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BfAvKbbt;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756855450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8093K9Af9RgmBZa+M0omqCDsAzQQr2kiZRNF+am+7aY=;
	b=4W8Kim2ycOwnv/0Iaf15RObbbYQOOItqSp3QYnYjBqbjRgDcnE/1Ieyu7BvNTXchEL+SR+
	GzY4Lzrj8SkPN4EeXj6GMbRpeRiTBSJaAYtbRa+EHS0tzYPkHHT2/BEAs6No3MOeB3D2m/
	bz+75OWb3uNWxIfgqCDA1KtKvJlU2vI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8093K9Af9RgmBZa+M0omqCDsAzQQr2kiZRNF+am+7aY=; b=BfAvKbbtmZrNsE+DIfjPp2gxDE
	yF1lUVBBxA961C7dgvsPBtCL6tM+fAegBBU3hx6iyO+RFWxeDhFDLISRmOwVpy66hSWVnvbQfjY0X
	ObLpjp2VQMWdDgAQnPXVPv+2JmqtiGwKV6BFg9Jq9M/Ledes05JHKMZIk1tWhnx7k677L/KY4mXFk
	NnQDkwxcJQw8XPDfMrCu7kf2LHhXaRW5H2ZiXA5NtB2VmkkRPV/bxU2hVHSv2AeY2chpduYgZtvJg
	JGuwO/ihStaDjz0PbFtbPpX0rO9e7Gm/L+GHO2ywTW5AUCVXXPKuao2UFcb58gB6rY3d8Ck+5XLvj
	0YMXIn3A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utaMC-0000000CcQq-01GI;
	Tue, 02 Sep 2025 23:24:08 +0000
Date: Wed, 3 Sep 2025 00:24:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: Where to put page->memdesc initially
Message-ID: <aLd8l8v_DL75NU43@casper.infradead.org>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
 <aLdcPeb8zrfDwd2p@casper.infradead.org>
 <20250902211514.GQ186519@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902211514.GQ186519@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1FCAF80004
X-Stat-Signature: tirs4zckni888e3ritxadcku4xqmc4ky
X-Rspam-User: 
X-HE-Tag: 1756855449-337427
X-HE-Meta: U2FsdGVkX18/8gWFmJAd8tvmVoXlsrMPxFuconRssIrDNZsfUr1Jy0DpTSkZ1qWV5+lNw7oXu1n6gtchB4MDi5nKSYtnwYzv9XF7yp/q/tNybjMBuYTuCd4IzZ1qQqR7gd9DSgsYXLrt13emYLjMgJE/v80BbKYBstHRaSlaq2CBmn2vHoBbcuYWxT5yhu1ErpzkfNV6zfHFzDm7TFpETJyCILwMvs7cQtZ1oTHHY8A1+xM/6Trvapqve7PHp/Vd01wzTW2Qwm10mI2wb9TKq3167VCDUWluNDSigwvzFPu0RlsEIeXtyhAY7wrV5+0ZZY6RH5sHlNu8zUb6GLsOCgQvoXV5+nRRwYBixX9NrC9KCHbwEDaNCAiNVj9AlllNFpAq0cWrQaJInTLNFfLx4baiyLNewkTvqqxg6TQMyLgZ0TS9CueFSeOebPqXfyRZUQs/N1ZJ8EYHTiQNGA+NIknzbetTnAQZUoFpfYFhtVqxvVTLdrDnbBfhaL6MV1l4Efb4HDDUaXZYA6Ko7kl6WsRprvAbhTdLQOlvdOpH5zc3GaDT6mggdi+2GLMzL444c7ISOpUUI2I0kbKTqvs13EdIgEff948kAlSuieW4TXy6h2l2Jqo67EhaZUA3qz1WL17m1rHANvG8p4+nMZGvux11bQsEJ2Zc3pNhbDKq5jhuOHG+xWqoeHCp2I0ZKOkrtNaYeJAnMDKZm6edq5t+k18ibmP5kjb/ShnKF9XhJEVMb5bQ67KKeLqcmMe3dFvd9zIZXgQDXBEVOgNZ9fgNf36uEFLHaYjWNIgiL59VfyzQEEGNuma0dyMC/ik+mw0Wt8AWQfP6ZkEM+MexBc5nDbVAOOHzXsfAXi7K6Cs1SmPWM1gp8iM2NRmMxuh+NAtLJF2VTnOk0Jl6mTTUx0wmEI5J3bAa7lNYhRlySzwlGntridQGlfGjvl9SckJV8Jw4YRuk+hyTA7o0dmehurL
 j7UsaInn
 fOrtwWj1Ve3+JnhbjGDPRVIkitCD162iNQ7PgHBDXhwFdnwCboz1smpe6uDNAjyI3hgjq/DsLRKUsw/xiSVt7+xPxDTAlwcc3cJopfoQ5GmvDpHpn9/LmZCVj5NHrcYnpiZLZTvf/IO6jOPktdu+UYp/Zv/hPSZg/yPUsRkj9qc9M5OQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 06:15:14PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 02, 2025 at 10:06:05PM +0100, Matthew Wilcox wrote:
> 
> > I'm concerned by things like compaction that are executing
> > asynchronously and might see a page mid-transition.  Or something like
> > GUP or lockless pagecache lookup that might get a stale page
> > pointer.
> 
> At least GUP fast obtains a page refcount before touching the rest of
> struct page, so I think it can't see those kinds of races since the
> page shouldn't be transitioning with a non-zero refcount?

OK, so ...

 - For folios, there's already no such thing as a page refcount (you may
   already know this and are just being slightly sloppy while
   speaking).  If you attempt to access the refcount on a tail page,
   you're silently redirected to the folio refcount.

 - That's not going to change with memdescs; for pages which are part of
   a memdesc, attempting to acess the page's refcount will redirect to
   the folio's refcount.

What GUP-fast will do once we get to Page2025 is:

 - READ_ONCE(page->memdesc)
 - Check that the bottom bits match a folio.  If not, fall back to
   GUP-slow (or retry; I forget the details).
 - tryget the refcount, if fail fall back/retry
 - if (READ_ONCE(page->memdesc) != memdesc) { folio_put(); retry/fallback }
 - yay, we succeeded.

So that's all a little more complicated with two places to check as
an intermediate state, but I think it's doable.  It's just fiddly.

