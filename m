Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8FEDC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB286B02F0; Fri, 14 Aug 2026 03:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96ED6B02F1; Fri, 14 Aug 2026 03:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B866F6B02F2; Fri, 14 Aug 2026 03:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 972F26B02F0
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:20:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E57A403C0
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:20:03 +0000 (UTC)
X-FDA: 85099025886.07.5C24811
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 710A4180006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:20:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mx3x1Bdx;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786692001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDsOUE0aOsyxSGZTsNq85XQVIx3SPPkmz2zt0ytNL/0=;
	b=j31NWVXTEkZnP+t9nsArR8cU0rvCzDJarWJVwe403sjF4YWDsJX2tpHH12egay4Ms4TgMt
	/dATVNUqfqDWZ8WIJGY99iArlX9egX064uO0Ac8MhIxiOB3Lf4R6oQjU/Yr9mzQZK6ICok
	YJScTKzjBV4jD5sHK6L/0ze7XtAZNcc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mx3x1Bdx;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786692001;
	b=P1pD/G9t20hiY8yVLhXHdEgKNYus4JVQMKiKoKj3W3joLfgIPPr59HxPE7QpcMNI58nNNn
	fd0JYRIvMpaTOvXsIBQJR0Uxgc/yC1rPo+e41OEtTTI7JH1X087SumMXPo4hA7KTV+1Tt/
	Gh6B5cDU4ZjYeT9Qs8R7rFIWDBiurFY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WDsOUE0aOsyxSGZTsNq85XQVIx3SPPkmz2zt0ytNL/0=; b=mx3x1BdxtWyZYN2Ux5uY6M6hGU
	WSzDhrwWk5KFc6HrPVqExajrFCp6LO+jnHo3vEdTbpIskUMANnaf1mXqhazC3igfglBzliDC6SOLY
	cVU5LwnzH16NGktAjSAzn/nlI9vgJp+t64q6zFAxJ+AEv+s/ia2GrNhMiC2HBwWIcw20ZCq/ozDCU
	z94/GTKoIlLHp62IBbW3G9lsZmCRt6MIACxD4Xfi0ldKjRzxIr9IF5h+I/voCtS8QecDwaajdfXVO
	k62C/6lP3Rkeu1yljn7Nt2eoq/+W1n4iS/YDiUxVSaY9NsuJLzQ9x82ZAgmpgXC0tTmIAfY6eZYQS
	TNIgJAvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wumCt-000000026hn-0TtS;
	Fri, 14 Aug 2026 07:19:59 +0000
Date: Fri, 14 Aug 2026 00:19:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] xfs: mark kmalloc'd xfs_buf items as
 __GFP_RECLAIMABLE
Message-ID: <an7Bn1ZNvQyOUWqc@infradead.org>
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <20260813204929.2253988-2-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813204929.2253988-2-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: pp7hknx3ssixgnm3cm4d7jkmaoki8i3s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 710A4180006
X-HE-Tag: 1786692000-347956
X-HE-Meta: U2FsdGVkX19cE8UV79DPDJkWcqo6DQrZxyW0+VUX833EX/8SOp2Dj37QAsHsOoxl31ZRDKkY7Su7YZTlS/ChVUtSUR0Vvxt3UIOLAQOWH6bhsvsNT4x6yn2goIdZ9AVGYy4GX5QUGwLfXRJt9dlBtm3AVvlz/jO5VDhOOW/H+CsefC21YFuwzLfYliWYQWdZrzDWzAocostM9SZ/8oKWRDoHqnHFVs0+zjzbCBjwcYKghJG5+/RLeLvLIC38K8GJuwt6xTqqw5V3aeAnOHUe1boRhNyAW0Hrmp2rjm0CuEQj41+fuB8vzrpwuFfTU2uPJ073VHwKDwpt6MzsBCIScUU9OHkTSeWN+Yq5Y6EeSxDiLkJCePIVxvhkOvOHvgFmAFr1GnOGO9tQfvzH1EQx9VH8LDiELQKJCpQHv+lhDz6JAhdcFypSmhK7pksZrETVK3GbDjiHh4d9FUbPiBAW6B0H5U7zuN9v80JUecmJuEktfgAdW2sl1M5MJ5F4zXibLDbySroFrPUTW33WP07hEY6RCRV4aGevKWpIgnsN8ZtNQ/zBqgIqOsmFeoq3gTv4WCwiGy20IH/ygLz2r8LhRsf2f3Af9N9YiPUAKzrxQJDLcFYS9f8sHjykbzCKY3IYu+ZaSFSbzbDHy/WiokGCCVnvnHLEAlMAxwgm+h9lz76lGQLug/e+EY9gZrOYidzCJw/yyHKoM+r9Uac+yKhO2BIv1LGcsQ3Z696Gm9+AkkOWXMSI2eAQO7WXZwnDmpwFPjvRmvf5SYq9c569vO5blTg2ueXdfPHBYOfYoJCz/Mo/nxJVC2SECzGQ3C6ua1bHuUzbK6Q2gqVqXb/aB2KMwcigSRmHteFCLpoqQf77jNqqy4JsEPsUxuHXb6wPrFtmIM4MWKfekLM97hFniL1Rh0Vh+A2dNNbHlmgrm+XIBLSRsofrg9mS+h0pSX4cplkysrg4c/orng+ZSePkuQY
 Biw83UsU
 N5YsuzmerzQpo1cRtFE6enCAHmmtw9mrHe0r9yVY9MiuTAkIaXq/LOdFjZVuP/iaTZodW9g1uKUu7qxyDwqrXzrJUqSe5r/jg+pW//U9wf4lWqRcGPC40FXm0c3Ttpr7JscWai3yI81PBRAz7xkSiGGnkPTsxWWATM7pnC6H40+REMXU9k/ofxCG38xmKCtTAedjCQUMrNy0Jw1KmhbweIAQ8zfka7pb4Lc684/LPvTsVuWjvZnTRwphHFXK1Y0qzT5fm9LyxMnU/FZlU4SDoVe7kLzWUryoSsRwY5cYhodT9BgPJSCmw6Bg3OSy4KT20Q2gI/sRcDTfbsNBDksDaays/R2Ks9ToXnccmE+Xg7NQ6P5JOL1TfuFDLjC8DA/0Ug+BW0s51O4Mm9tN99x/50ihyTwqZwHn0pKnp3HgEp4zBhWqP3R58yUcvEhNrdTRZDmkUZIhIrlY8Eabb0wDe9dW81hvqWf+4VCPDCaAEd8Mq/e6Gmnnsk42j32s72TTlzEji+pNLyDiTmZkyclld7Gl1w/4uubUBmOmpA5FE5N/sYpsS8PFkk9KnzzSwGCVUgdBk9Vfayimhtb/H4aH0mHOSew3mT8ozJA0r1oSceTo6ajo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:40:52PM -0500, Eric Sandeen wrote:
> xfs_bufs have a shrinker and are therefore reclaimable; mark
> them as such in the kmalloc path, so that they are accounted
> for in this way.

You can use up all 73 characters for your commit log :)

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>


