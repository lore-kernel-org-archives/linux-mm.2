Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4879AC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DFF76B008C; Fri, 24 Jul 2026 08:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7A26B0099; Fri, 24 Jul 2026 08:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE1C6B009B; Fri, 24 Jul 2026 08:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19B1A6B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:38:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6B0680351
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:38:19 +0000 (UTC)
X-FDA: 85023623118.14.D161E73
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D62040006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:38:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nCyA3CP+;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784896698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vq7TzUbO5PV2JAWC/OnBXO7UIclCBHAcBwXIj2BzCok=;
	b=X6UHrFTaUePqTH6JSNFWCCl8bqDhctE5UzSWcsfbUB5FW9O2vEWXALiK46tsJVYGKCJIQr
	V+KIOJpyf52P4wsiPv38RxiiPiuxfcMDSFqq6WgGxX0pDHq3FX9OfrM9iJkPYlgI9UL7Ke
	wPtNMa5iAyGidYTCXOOwHgdgVG7a9bY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784896698;
	b=CGGTXIibQedHqi/aRtsrx+dvH4JgHZvuiR+EIdUDrGbStH5ZPY+Rhaq+mmgqoBu3a0HCgz
	8VRS/3KfBlj7esk0uuoWlYCOQK9AmJipqVTgPUxMGxK06v+UzHYrJhmH5zDouuzPhUoH/g
	S2UFIIQ+c1ZwyXlTkuvnxk7sTMo78mM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nCyA3CP+;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vq7TzUbO5PV2JAWC/OnBXO7UIclCBHAcBwXIj2BzCok=; b=nCyA3CP+KfPkOhjwRLdRTOnXn/
	Uz+MmYw+jRsvtGISfpyETCFyVq9TooziFqrxGTx3Gn3bwkBvYrF0cQNuXtekCpCVx33dXUQ9SzYF8
	BRN8cdOnssriTA6Mfad74AiRuWm+60XnFkz8kVXhH88tImwM/XK46dj8jg3OFpRixWuu/xL0m5EIw
	ih5Dn5npBtGqfo5zFLMWUYp2McfLEvFq7L+QjRQ0T2GI/KWksGzsJ12bFAi9lGCuDNEHzXPw5gR2H
	kCbLntV4SZaTV+uusRuwsTo/XPmjgoVnykiyFavp07A5lyBFsMU2zg9Ul8KueWZZSvV8hsduQQCna
	PxFpvmew==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnFAC-00000003T94-2zvZ;
	Fri, 24 Jul 2026 12:38:04 +0000
Date: Fri, 24 Jul 2026 13:38:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v4 04/14] hugetlb: Mark some function arguments as const
Message-ID: <amNcrLJ8QTa-DvDy@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-5-willy@infradead.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0D62040006
X-Stat-Signature: afqzfjaxez3r8gdx81aix81o7auf9gc6
X-Rspam-User: 
X-HE-Tag: 1784896697-690522
X-HE-Meta: U2FsdGVkX18uj3I9wJY3T/3/eTyv7LIuYvYvwpXTsEC5WLXGfL20CPQXJ7kpUsmjTsg4R5HJteZBhsoS2BMS3vuxUuC9O298dcZk7QA+MsqXwh4fAr/lSQf/8/sUVhhpqmfp0VSzEPFhsZa3v/sm3I9itGdxBpwZd+uPbdpt6V3l/KrxqOReCuTyXQc5sRp+kK6rebzys0XjRs+BpD6pJnIuNqLywhouWVphMxMgw05TH3g+8o41ehxXwSrckH5zN00asnBOGR1CVFZBpxH0xCHlr9ICk/ZD8+iN8HqxWE4LrMptXgxqFXQ7Vtb+4nPofsm7HJQlwy1n8mOv7J36JW5AtYmIb2tsacju6uRck3+gagYpGZNT/ycM4Fjiu5r06GBe4Hmxw0kLG/XO/rUfUC6lI86URAQaEBswTMc8eqOSY2++3oyKGLiFCk0X77n+feA74Zb3WBKEmf8Q1Hk5GaEFRgEzuV54LfS0xvf6RcXwPAw0PPBrYb0fu+F5Y1WPsIbuqRKrfwKUvKUgNOVFBhPz/9h2W5OQPDYTdWcI9OxfUvr3OHAIMBhCc9//UI5SLX21SLTc8C7wpbdyWYQHaA5lg/jzChGGNf/d4LG9KEc2+X8wPpRCs9wbreOZ+0r6//alhEK0+Rn4yZeasWWP/UBSY0qErH6+7+olox6Wfvf2O3kDH8V5yUljiUtC2CDeJMYLNpXrjt/OVc21y6vGbZMniiTKfoP7Jayoi69xebQtMuYHoH9o/t9bAwyOYLOlUGb1iZlEvQfa249wJ4uv3+EPkAtS8pIZmotxcmH+3G4HC9/uvIFWT5lON6x2NambFCCFiIVMXpc5r8/XY+xT2Jx+bY/RgvrE7b1jZpqyEiK+gJrhfLWaSWx2cU6YaG8FtGFQTDPs1mymkdNj6aE4EJXGCPFbCJ/GsF+astJzueKju5KQB5/U4VOD3IMQgvgMeAxKLucnGncO3EIHXFG
 Iak0dHpY
 PVV50m5yq1NUo0ot2floWVXGcRdIBqVkAHZVH3WItxoFs++BqmRtGtDphbffDm3Olym7suXfQs38bTJJyYSTutshxhh9yE//ysBZn/e9UL6Az8DtJqosD8ObNjmReqzDPqGXjbaJDyklrE0Jsc/9j0hckV8cQWx6OFfxLMESWW+491QBM4qeFiwQ0gZp9OiEqogB+WpQkhef4U9U7P5h7EdIEpIzIrffmMPfmvGqCzuSJ11mbuSy+2ntrERGLbRitikdn5tch5OyUtZjDy/6l1BNQqF0z+VwvUdf8aWWYFMu46Be8WLdIjGLzKS/x5Vq6ufo7vQ2zFFwtP1pHVOzHnK5uQxiKFPnr7ycoTL+BKpVi9xRMXVnhlbcdXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 03:30:21PM +0100, Matthew Wilcox (Oracle) wrote:
> These functions do not modify their folio argument, so we can mark them
> as being const which will allow for some minor optimisations and let us
> mark other function arguments as being const in the future.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Sashiko finds no issues with this patch.

