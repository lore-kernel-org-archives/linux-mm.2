Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA0E2D1267F
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 22:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FD76B000A; Tue,  2 Dec 2025 17:56:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366E86B0011; Tue,  2 Dec 2025 17:56:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C716B0012; Tue,  2 Dec 2025 17:56:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12B946B000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:56:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAF75132AFA
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:56:38 +0000 (UTC)
X-FDA: 84176042076.10.E9AE537
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8EBBF80005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:56:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eGR1Ms5b;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764716197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gOBQqE/HyGqpgfqgim1hZAdMA8Tl09+44pTCSGAB7A=;
	b=eLPzPWQ9s5C0EGv6VwWhue3nSWv19FNx6bx6Wnu5M9wilL7SvK23rI9otmVifvZSRbAKh6
	+L+vY0M+aUoI3e71tY/KGFQf0gQr4FzbT9V4mKWWv2q/lEaN+R+gA/hH3bUEH0ciXDJ0MW
	6zieNMm+APUScIywHI5uFoDGj2VCj7o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eGR1Ms5b;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764716197; a=rsa-sha256;
	cv=none;
	b=pStEhwd/yVj/xtY3Na/5YFbAUChcPqCPDrsiiJMVENOwOYPsOyfVv31fqjEAS6nCwY+ksX
	hVy6D5EhPHs3jCIC07uXpaFizBAkp2FSEfETvTdk4A85Q26lLAehhSK/YCeJORyqzgWtpP
	b6IyJXJgsrxyUeYf4MM1+eHZ99q7vSY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/gOBQqE/HyGqpgfqgim1hZAdMA8Tl09+44pTCSGAB7A=; b=eGR1Ms5bvq4eQIpTsJqVcmrbsR
	s6CfxzUISzPI4tVx6/cUxHWayuqHm3crBH0ilaQ8GehgOb5zUZu4CfoXpizymJOVr5Ifc1eGZ4+KD
	7yJ++EdZnpwZkUAdXps40p/xitjdwv4kl/hbmoFoNix7IIvOsv3NO0GwU4yEVBdgt9ph2JQNBsJie
	gAF66dMBTQ8pZ1ZifgQgveYCDZevgeedk0Zi9MDIMRUfr5AOTEgz+JzuV3NC5gNv4OjS77UrggpmN
	gu8nWRugQSqCV4tA6V88rgrutCw75dV6+7BQIJiz3lVnZRmKepIZqErUu0zBjt/i4SnHOT1AomzOU
	m5kWT8oQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQZIP-00000001tG7-48Vi;
	Tue, 02 Dec 2025 22:56:34 +0000
Date: Tue, 2 Dec 2025 22:56:33 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm/readahead: try to allocate high order pages for
 FADVISE_FAV_WILLNEED
Message-ID: <aS9uod21hG_qq7Rd@casper.infradead.org>
References: <20251202013212.964298-1-jaegeuk@kernel.org>
 <20251202013212.964298-4-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202013212.964298-4-jaegeuk@kernel.org>
X-Stat-Signature: 9mebbwnwhkps1kz9xizot3k9wj1467ja
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EBBF80005
X-Rspamd-Server: rspam09
X-HE-Tag: 1764716196-733885
X-HE-Meta: U2FsdGVkX18F/4+jfOI34ZoGtm2udyB4f5q007nrH4qenFO6BfJY9C5/zfLki7CouV2tu7dCZWpUc4adgNfzQhgyhRVRibFoffuhZSBZLdx6hChoArlSUd5mrepzK8Yaekv+BXnW8v3jvfA/Mc1ihTNizZSly+0OjFaF9DEK1hmkopyd2C3U3z5pkPr/15tkWRBtAoZZ4TzdcGUe7RTMkJucoErkVmVbzanyvMCoBcgzVj7wGSWFkuGcnLC0BGC/smUSd3A1KC8mq848qRjuyTbIP0wRrXr8yWtvXNT4XxsK+RHarVOJb0NT2AdTh/aVOvmyvRoEFFFODZCKx2C5F56xk6S3eplhye48SbbhJx7Q1AjR9kQVW/FNIUNDplvnAuID+qF0BksBnC6iznxnsch8aU0+8U0wC2KfsrAMMZ10qpS+H56l7gyAJVxP3CtXJMoB3vdJkNplizyuU6Az7dJqdK3c0eyj4AHC0HIopoPc8OftcxdBv0ON2SIcwFcv+kkRh6moVixZ+Dn4L9OAziAhYmd8pY51BPvIXh9GoiL+H9xO/zE4em2nFu22Jw/nWtNQwP+84TWaMCByEEC4k+37reoPbaP9RZvbqDerLcsuBZwY8BQn01T3ymPoOVstx0BkPOAQqmpJEBKf/PhxaJT+In4Xi6+3MN0S1cx9+WOaRQ6ZD/r9LlT50tDJJ6NiBpE1fBTnJBerYSB0vxHt3HyY3fq1DIYS2CvST9vyau7VpX/NHdV/R0wv0AXhzMsC8NCx75ZwpoBN6GkuNUye9Z4XFhqEoUoRW25L3lsjrp0go14yh4a3f9vE7mwuRbQbMleQAcqQesK+yOYqJ9lllSf5THGtJsMJzRzfMHXmComR6cSxZJ/dJcqp2viPNjGBUQrrXsROXH0eHpTBizAJRfe1QKdaTmjCMH0PQG193g14D80CoWtAqpcD4J6U426ZM9o8IdtEJbUDBkUVfXA
 1aa25Xgy
 J4m4jO+9nj3l4PChFsF/+jL87GSB1UaPLGDB2qbVRpMVdX9dupP8brxRsR8U5J/+37x3ff/eRdo1EJayfIouwduy9baTBGuhAzmahV6bbTuQDpxeEoWT7fAUjIqt/6kOZ4sxdDH5EDCZI6LW0+ktYzFNajSIB6OEQOn+xlhSrqF1saMnYt7j6M+mrSpKgRmBKU7geU/6GyWN0vxXYMiKOCecmgHcJK8PIP0qlIO7bbzgVSSmV0e6cAdRpt7qq/5LYqtO36hJndBEtLMIdk1wIU3czkke7GH88QbUiMIEBvrkSzyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 01:30:13AM +0000, Jaegeuk Kim wrote:
> @@ -627,7 +628,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
>  	ra->size = min(contig_count + req_count, max_pages);
>  	ra->async_size = 1;
>  readit:
> -	ra->order = 0;
> +	ra->order = mapping_max_folio_order(ractl->mapping);
>  	ractl->_index = ra->start;
>  	page_cache_ra_order(ractl, ra);
>  }

I suspect this is in the wrong place, but I'm on holiday and not going
to go spelunking through the readahead code looking for the right place.

Also, going directly to max folio order is wrong, we should use the same
approach as the write order code, encapsulated in filemap_get_order().
See 4f6617011910

