Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FFAD5B86C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A756B0005; Mon, 15 Dec 2025 21:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A079F6B0089; Mon, 15 Dec 2025 21:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906E26B008A; Mon, 15 Dec 2025 21:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 716336B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:42:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06CE416045A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:42:12 +0000 (UTC)
X-FDA: 84223784904.23.D98DB37
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F6B5140007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:42:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DypHeXhf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765852930; a=rsa-sha256;
	cv=none;
	b=2XsXTCCfvNH3jBROYyEFxeNNJaqBZHlnTW2MB0MmNoA9jjrCddG0wtKE5NWXgXJY2D6tya
	pc2WLpeV/lSdgboMzb6hHzXPW7tmPRvwENxDpKelNkjGVBq0aPc20ah3czYZBHjSRG6MaW
	QTmtn/5AGeqZ1zvHfA0WJKk/oetsKA4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DypHeXhf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765852930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McLudrjs2j6oX0GPBfhtmrgo6TzeswArw6lwH1JBWU0=;
	b=UhFeTXkfslY4Kpx53xwT0gdYmCkMTnbf0brDZ++6dd/Ut358eOVSsmis4xZPawzMHZpDES
	KIaYfYYVeYRLya9HKdmTszItqU7uZArEGPnWx89X6R/CBfcsyLPtcbDJC4TOFSNP7BCf1u
	BsfTISBfvlVDFxlBQNiXSCV0l3LmMBA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=McLudrjs2j6oX0GPBfhtmrgo6TzeswArw6lwH1JBWU0=; b=DypHeXhfBLS8DsrvCzzfWPCmyo
	LLz7DvZamsbgfncd7ffQpFwKyyb+K3KiInYuOjGOkzv5lJUd9Z4MC7ymef+8DbKq2+yofAiXiaLHY
	WHf6YJjWwab3i1lurZm/N0lDii/Lkbc65Tb0oLqCWuOTKLNkiXOwvxjdmhapfF0R70aYK0FUVsAEz
	wGNuctd9DUl+1ce5B8r8NX4vpluy5jm9XqsUwtNvHZLhOSwfbfGVPQoLa8lpLgofcdWfrf2BbG3pg
	NXAFUbRBKJ7JPhv1URgED6qsgafY8bGOSm6WIVfahsUE+ekfZUTc97+iwdaiMK6QuRXXiBBiSgMd/
	nDz3kgZw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVL0o-00000002iNY-13t1;
	Tue, 16 Dec 2025 02:42:06 +0000
Date: Tue, 16 Dec 2025 02:42:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com,
	syzbot+fdba5cca73fee92c69d6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/readahead: read min folio constraints under
 invalidate lock
Message-ID: <aUDG_vVdM03PyVYs@casper.infradead.org>
References: <20251215141936.1045907-1-wangjinchao600@gmail.com>
 <aUAZn1ituYtbCEdd@casper.infradead.org>
 <aUC32PJZWFayGO-X@ndev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUC32PJZWFayGO-X@ndev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F6B5140007
X-Stat-Signature: cifx47o1hu6ehrmeuzpsiduqyxpxb544
X-HE-Tag: 1765852929-570213
X-HE-Meta: U2FsdGVkX1+6k1oDvLoAX74lUgE2gyPZ8Lm3OC1p69zXYze2l7t4w1n3NSRqhbFmfPURcpYhQwlx3UHfBuL80FgALXndTu/7OCq+orIIYJVSDcd+muUvja8PUjlBb8Zzy9TGCDivfrSpUFxn45UyP6s9kOm0fJSB6Edpv5Jd/+bMTPnnEOryW9I5Edclhdt4LH4+i2HfPF6PLOaB/TYYDX0T+f6LdWEGiVDZnwPZZU9YULUPy8zKtSRqs/I6gxYgNSF21oIYBZwPziYoC0ENY/XhxEDMfChvysyhAZFI7ePgFqGDGuqmTiB5o6gMhQCNHkiMVqd52IgP1fQ8UkVE1GwnOR+oj9Rb4MYPvkUc37LVUxRSoK8l/jePk4xGUNSJj0sF4ZQEOUEHRPwc/xmAMKl2ZQ1832hQUCZjx7Plt1W1Gt7phvmff5MbcpqE9APveQqyQUrxyVrnR1YgEXuVqdKuwN9fH4z0o9K+XdI8ZFJnHdN5+pcn1Ay5eDb53mJ8lbPWDtnROXHXq4QugiO2f/nEfKLbOQ9Srbg1tNIZFZnyRIhcVzNV2md4+cB/1216yh+LBFYQYlpEUewLntI8w4wYyKsa4XP0zJ7A8+OTXYF32anPIZLUZ50OEvyINlDuZpFfRxXzzkWRrxXTFScWXeIu3MZHu/yOWo8gpUcwwOClMJIe70J1BLGDZDzXVemR0y6oI96nBxhymqzr8oR7SYTl+6SPHyPLmluY6WdivRUx9fPD0Cr4nzaajDnkNqyojH+0mY2s1pzmXYMIzaeRxClTdL2EvneyyYZ2VkTEn7UA7nxP7QrBAfK2EWEu0d69BWXWbid2IJ8xc2bhdMT5exfJW18a1ohyfgK1WtPbAQm4Uk/ImOal/2jR0qKCqB7mv8Iw2W/0teps8of9njz6I2aJ+OURBw6nfZrxKSbIsfSRMKvU3UFSo93qtIqoZpczZR2x8tQF6ZlwHl7umHv
 5KgbuwQB
 LqX8PlRvvM/25RJKc8kJPt+hk8WcN2C8FwYdLnfRzdM6m13QlxBIGT4QitiQ5oNLO3YbW4paEgcEn/TSTv+7ThQeQGccQjcH8KtTj9DOvTmUd4a90U75xTZ9AZSjfhXk7WmA06WbAPYL559uysgzL92oPjwx4NNpeR9jdNhPzIVurdLQaWzMBLHA3sw0w28ndZOjTeflAKzi6qDMqXRaXOo9/pb4k77hIIi8xxsHsEwJ/nqTbhb3wXlSdFbmYhbhDHx3hu8Ifpg70CuUkcmR2qapCz94AgAaJ5zh+MfAxgXUdQHApNwcpOLB12oE7fdlBOU4uSFGhoh6pAUD39AldSjLc9EFcHelIAbA4eMQy6ODB/pHCxYo8OJFtSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 09:37:51AM +0800, Jinchao Wang wrote:
> On Mon, Dec 15, 2025 at 02:22:23PM +0000, Matthew Wilcox wrote:
> > On Mon, Dec 15, 2025 at 10:19:00PM +0800, Jinchao Wang wrote:
> > > page_cache_ra_order() and page_cache_ra_unbounded() read mapping minimum folio
> > > constraints before taking the invalidate lock, allowing concurrent changes to
> > > violate page cache invariants.
> > > 
> > > Move the lookups under filemap_invalidate_lock_shared() to ensure readahead
> > > allocations respect the mapping constraints.
> > 
> > Why are the mapping folio size constraints being changed?  They're
> > supposed to be set at inode instantiation and then never changed.
> 
> They can change after instantiation for block devices. In the syzbot repro:
>   blkdev_ioctl() -> blkdev_bszset() -> set_blocksize() ->
>   mapping_set_folio_min_order()

Oh, this is just syzbot doing stupid things.  We should probably make
blkdev_bszset() fail if somebody else has an fd open.

