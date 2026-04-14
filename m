Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5D9BF531F8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE1E6B0093; Tue, 14 Apr 2026 03:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E9A6B0096; Tue, 14 Apr 2026 03:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4846B0098; Tue, 14 Apr 2026 03:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05D296B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:48:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A604CE3829
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:48:13 +0000 (UTC)
X-FDA: 84656383266.27.DC62453
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10B5EC0008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:48:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tCll1VUk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776152892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQU94fiChMs8s73Hk9p3t74X0fyEWgNmpMh4SQ5FZtA=;
	b=1sCokZm9FTd2yu8B8SXAfM5ThM5vUaIHHfzI5QoiOcCMhPH4KCg5Q5NxBb2Nz9uzkFsNBe
	O59EDj0MLy9I8JO0vaHRNb+GGgcO9VeJMMCJotNrPgzr8XIPdRAxtrM+kDokvNukhKg+Ly
	DTA99i4RHhj3+GnjGfRT2aOe+qNPV/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776152892; a=rsa-sha256;
	cv=none;
	b=gYt1GHE5ljhMQCYcms8IA4sM0c/TgZYYnAhtaKf9yFyjYu7LB1UFh2gcwxnofNJWqG4+hW
	8xFm1BOaREkVYRq6aagwl9rkZap4zY6lHf4zL12kOcEp62hrgvlsLHvhl3bySlkdujIlS2
	+Ye4UaZqVv0+CvTaF9OpfcaU0w66uGg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tCll1VUk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mQU94fiChMs8s73Hk9p3t74X0fyEWgNmpMh4SQ5FZtA=; b=tCll1VUkT0NJMf0YsZpYpkrg1o
	RTzsJU2xQlnhqreJID/gDCVDnlisTsCJTYbzcYi1E9X/yyhIvDBynb/xPodIuTB4JvJhG8JQYU/j8
	LSucQI3K8c6KBSHBTuU38+N3xWDY4uysgsZF8UpeLq7hy1gZ6wfgqTZaKTZnxW3hYZ5hxwJGZOiNf
	m1fFbMBbutq+fgqm32erUxfvGtuf9UgcexMnnv6j4RyLbpe54YzSDbybWZ2lneKzmNbbCuayaNDfb
	vpPUbpEH74RuO5OR4z7rbLjpdVu1bZFuzWo9bBSef1vd74Huag13SeGGoi2Ro2sYxaQ58vD831pK5
	iqAkoPDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCYVE-0000000GvIY-0yr4;
	Tue, 14 Apr 2026 07:48:08 +0000
Date: Tue, 14 Apr 2026 00:48:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-501448199@google.com>
Subject: Re: [PATCH] mm: Call ->free_folio() directly in
 folio_unmap_invalidate()
Message-ID: <ad3xOI71tU2Uofo_@infradead.org>
References: <20260413184314.3419945-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413184314.3419945-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 10B5EC0008
X-Stat-Signature: ur9obgckfjuyc3wcadcm7bo779ydcbtc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776152890-809198
X-HE-Meta: U2FsdGVkX19Oiq7/GU7EBQZGQD3LWQ96iCc1ZOr7O991/Gb7wOJ9GVqxIvk2wmVdPpu2whoHJGIr2ah48tOVYbzbdS9HotrhN+PSJfejAQ+RblWZ32fv6OhKGCs1AV74bPi80sNl20yJs1IqnjLaO9bSSq58Kj3VTzkpdrffmJds3XZXBWvAGJfJxd8KyuPnBH3TEIblP5t/llDeLnwq3SGpOh4ebSvYq9p+21tj8fk/Zl/P4RUqZdn/6TDcnsKHXIX+dbYD9qJAmZyu2iKNTooUVPMe3k9Bz221pvhUgdYFZ3Ob5u7hN0f36872WxyL7uxTxmTq6jkivNAXv3vkEzChf5cH/sUet2g2txORgIvPuf6RJ43/GnA1K1ythL2SaXyu5EnhNJv7KftIZnn9XC0scxd2TWXaQhheoOKZJyZCULLtUOw3sjX2jqLOyEmJCbOGrchemK2Mxmu0pceyYoD0VmqW/b3Q4/n1d3JvUkhn01jsgFUcvy0ZmnRM2CDLVga23RAvdBeK4mg37D2aRPxfkdIMJt3YnVLydKYe6dD0/UKIYF3HtPdiyz2SenbBu2M17z9jU330nbtrJ9Se6Edtyq8RX0bwom0Mit6VeGAtvK09ltSQuQjb7WLaeNEP32sX4XOIV1GVzHmGxX6lKuaVFtvUFrA1nkWuBt9JI7RBY7uV8cg26sfnxGzkXoHrBy2J5z2GpF6Pm2b70q4phbHqOkQW6/lCytmCVV4nWZEjnDCSlwpekUXKqkGGlllLXsQ6DZMjL8x1kCRp5tHE9ZZiz0EkhSiSKU2msHfMABzKfIOWxa4wt04Uu01GdYaiUWGwkWJnCRqqssLe+2cEc5cUzaV3Dh7KF0tH3UEJSYP9u8ykygwnPOTTshXYm2xv1ELb/2udmUgv3Yj3dt1oZAcmCorMFlnrafr73bEimz+sCvQlKAFiHc0mYB75USqbKa0beR+QA5N2VpGYEfB
 hYF38Z6S
 PIGlLRBX68w6uIagHtD4KEn9WJFfiPGrqVMPRWWjryPdkWnpKT3cCetbaWpCVoH9mg9n8cMpDLTy+abTYHG8d/4H3v39oh7ydkpiB8TJ1rmD8FUEalJh71bhr0NE2iOoLL36LkePkfv8fcCcz4UVrcm6yWMKFXpIofg36VMvsJfCKezUAbPB85x+netqrmmjYp7hiFBhPAEDqFz9M7X0JyVLauLFJ+rCGxs0JFQ2CDpXHoUjiyOczZyUx9mmn+C9f5yzh5A9RgXCOgVb+0mpBYQje0ZssYy8ggUoo7fMxrUXMt3OgHkobZDoJRQXUukfewkPTXSCQZWCszxp5KAjjSnf185Hs27egZs2j6OkW+iGVoKj5cyzGPZ4bTjHb4RC5ER0Tpv3ludpvPMybbRgteBrAdIwnjzRuHqZM/1U8D6UzRp0uCp0+D+6j9utL3ffjOJJaZWpvDa7lTH1thjje4KQ//I8vbdgabVPDatvPIwTxge1wN91ZAdrg0mQW+khtSxxYfNm+k0GDKSmE/uB85BXcDd7feFIGIlORDL6jztPliDrz76qT4K/Ru/NUC8CYuK7Y3SFaXJ41kQYhhZWjNFXc64hnwMJt1E1O+xuu1TBzz1ARdiGPLc93ojSDTWu5FDAUYSVMHUjXSpPxlz99BwUNSZAFZK8jM+iz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 07:43:11PM +0100, Matthew Wilcox (Oracle) wrote:
> We can only call filemap_free_folio() if we have a reference to (or hold a
> lock on) the mapping.  Otherwise, we've already removed the folio from the
> mapping so it no longer pins the mapping and the mapping can be removed,
> causing a use-after-free when accessing mapping->a_ops.
> 
> Follow the same pattern as __remove_mapping() and load the free_folio
> function pointer before dropping the lock on the mapping.  That lets
> us make filemap_free_folio() static as this was the only caller outside
> filemap.c.
> 
> Fixes: 4a9e23159fd3 (mm/truncate: add folio_unmap_invalidate() helper)

That commit just consolidated code, but did not change the locking
assumptions, and did in fact not touch this part of the code at all
despite moving it into a new helper.  So I don't it this is the
culprit.


