Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B21C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5F36B00EA; Tue, 14 Jul 2026 14:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685FB6B00EE; Tue, 14 Jul 2026 14:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E8F6B00EF; Tue, 14 Jul 2026 14:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34D2E6B00EA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:44:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B91CDA0482
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:44:19 +0000 (UTC)
X-FDA: 84988257438.18.F81E06E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2A31100003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:44:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kb5ECDFR;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784054658;
	b=Fn1nBQNzhgYV4wXrh+TVseHb8erYx2OxmpZmYCK7wHegbEx6VIsX1aV73J2NxQSgDObgob
	ahG9MfEKyTuN1QKIXe730xWSDYh2DgmJ61YFl+gikI+FIN5zUJL3oKIXVSnSsyz5IBPrsb
	mJlbmjFr4vHVWmbd9DJl7/CTtFiaj9w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kb5ECDFR;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784054658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYp3fFoWaSvK1ZQvrg6poTd1wGmPJuU6X2lxSu3LEoA=;
	b=Ua+irINF5G10zuvzcMnh1hj338BIVbBtZbLe9GtYmnW5H5NLDjovsPFadDvDV4UvMfO3uM
	tXqYownZkLAmgbUBt6hmMWqYI3k7lxEOmFvUemJAcZ+HX47oUyagrwwFTu/Q/zx/KgHyyQ
	ILCsRgSmJdEIY4keHkMerGivB+QzmTg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UYp3fFoWaSvK1ZQvrg6poTd1wGmPJuU6X2lxSu3LEoA=; b=kb5ECDFRCSmGPS58Y3hiuDcc41
	QgrD3XNA/n+0hqGvX6V3+LUkM+guvHdz7BsE5Qg+wG7/FBNkhYi6Ijz7HHfhfg/7Ch6km5/HfsU9+
	QIrCbbNc4xdLVE2cMgZnjxdLZs5yl84AUJOr331G18eR+UWv25l3eSUIuNcwEihVtuhL4f2tfsjqj
	ivv3/rWbcdTRbzQVY4CB+7ZvbzhYn7+c3Xo7HY3PS+eGysVyQuRE13uk927cV5uXt/tAJ26cmWLbp
	zlL/ZIZZ/ReVIsbHA1tLlzu+M5MEVu9bidXtwnWKHXvok2SmyJg/Xty9DdRFtpSVJTamEA+1l/dbi
	Re2YN95Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wji76-0000000Fj3Q-2ka3;
	Tue, 14 Jul 2026 18:44:16 +0000
Date: Tue, 14 Jul 2026 19:44:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v3 9/9] hugetlb: replace hugetlbfs_read_iter() with
 generic_file_read_iter()
Message-ID: <alaDgCdMQvrfUL8f@casper.infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
 <20260714180840.3731244-10-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714180840.3731244-10-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2A31100003
X-Stat-Signature: a4hk3w6yga775k5sm8kwhggfgzo7cgg1
X-HE-Tag: 1784054657-154140
X-HE-Meta: U2FsdGVkX1+vIl/Qs8r86FYh4dgXRv2b1kIgdgrg24SgUIzKCIJpFmtKdMyUiJ0ZSdAsDcNmJOZAoft8Lax11cAT/hd1rGrYNLwUj33bJydqpyvRIBpIORfyZnZwmOLl72dcnAPfWl9WsoURY+B62eu1XbAxchmUb1GoGqjhoH9BkyuAnL3Ed8HoK505PnoAZxfMs2As1v3J03vCXYEV39vYAjMvJ5cTB2PYk3lGD2tyUvy+/FDRDgO7FSBEnoNu3TjaaWCmwMWf2PxVBMP9HrR2/szc8nK4Nt6MkWyA/YYahSdwPkTS3PbGafAtAK3eU7H0Mp5UJkWUA+9/6zqEQNP7cZtQg9hoBZcMjF5LWGXa8ZSljxcCDalejqXj6ntIPDvZ6FRneyki80PQbprLdYNm7BSq6QBup9PbU+hB6sYuWHGwwLEjGgs12Pco/WMwGvqgLUSf1WB0G6KXDII4bIYnoGOKfyg3w5sswT9PQyS/6oSsgMoS4wSGUix6XlDYNnOB5YLEd74wi2+GPnNzaxG0fSzxlui1VIT3biK/BRazRryPDv6HORxP1KqW80sOMZ0rXxoTSfPTsmBd4ULtmz5ws0jvpPBm1VSr9THHxcmsUpPUncdshtdUjVVgjewIZ5GnVs7rdCFVCodOT1SkY4elNLlPtLA03nzkVtfurS0ucWyvy1JLcDUXMw9oApz6OjSOqrQ6c4JC+zKT/LOiorxrpSfcztlUROsgz4asV09P6voJlfmh2Tbb4ng4n2cQpDuj68nWEYyxy4vlkt/IV14q8TRwC6DaJvd2ujf+JmzccWS/+B2dXaZJgf2cJibqQzL09ZXQHQFXLiOT83qZlv9nxvZLqlDwzqtgFNe0A7eifbX6/XJE+Z+GhN0d8LEWPV7yKILFXC6dEytWNkR938FajhgQftOlZUmnsZpSgpug7mYQdsV2Zp8jlHZ4Has9dOQFmxLl/3Fgkh3X3RF
 Wzg4bFch
 TV3BbK+1zUl8YnGawzUd7d8/Xy2nAwzBm5NZvvMXluPDbyhoXYolIxgb1novw/ittyzax8WdhJcna0A839/JTpy9wICiyXTJFTidCOHjoSDkIAwX3tNimvSMYH9XSdYBWfKx8JkHipsAL0OjzU3w9s7u4sEXUMop2dUDdE4wW/T7AWeoqoBPQcgNpysWLJ9TLhqJBbt5TG2l7RN1wlE/s5Dvf1Ma+NgYfSVHC5/Ln/aXxjE5M45CcMlLaUGUUc9ho20Yvx9cEClAcG85RhcG5VETgijWaITu2zX0q5CXmbhNaFyq9xbPwDhcURr8d7DLHvjY6rofVmuD1b/PkfShhY2GnRJxybAjWskmQB1FXfr1O7f2ngJIDhG/bAJpyqVhmxC21Q2nUEbRC6bc7QygAxVJAA96aeiYC1BKjAeCkT60xnFNBNDA/2HVzULr0+zCzqXTy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 07:08:39PM +0100, Matthew Wilcox (Oracle) wrote:
> From: Jane Chu <jane.chu@oracle.com>
> 
> generic_file_read_iter() now handles hugetlb poison, hugetlb page
> size and missing folios correctly, so we no longer need a separate
> hugetlbfs_read_iter().
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Co-developed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/hugetlbfs/inode.c | 109 +------------------------------------------
>  1 file changed, 1 insertion(+), 108 deletions(-)

What I was _testing_ had this hunk in that I neglected to commit to git
before running format-patch:

@@ -784,6 +784,7 @@ static void hugetlbfs_init_regular_inode(struct inode *inode)
        inode->i_op = &hugetlbfs_inode_operations;
        inode->i_fop = &hugetlbfs_file_operations;
        mapping_set_folio_order_range(inode->i_mapping, order, order);
+       mapping_set_authoritative(inode->i_mapping);
 }

 /*


