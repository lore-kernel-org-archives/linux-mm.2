Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A658FF532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD666B0005; Tue, 24 Mar 2026 01:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94FA6B008A; Tue, 24 Mar 2026 01:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C845A6B0092; Tue, 24 Mar 2026 01:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA1326B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:38:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B5291FF80
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:38:20 +0000 (UTC)
X-FDA: 84579851160.29.E6DAB0E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1065140002;
	Tue, 24 Mar 2026 05:38:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Lz9EGP21;
	spf=none (imf27.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Lz9EGP21;
	spf=none (imf27.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774330698; a=rsa-sha256;
	cv=none;
	b=Od4gzD6qJow9joQoAnoCdwZ9SryzWvlN56mGjugRdLEi7pALV7YbQ56+VljiDAGjv6Oa/T
	b3Lh9snrb4vh0avCjMHwBNHkxuJTRhvd1AjXeme3afvoSAJdw8ncONyiXIJSS/dyB6+QW4
	gOYPMk4KXPGsSGJ72fxK/AE6KKJiplQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774330698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVQa6cRqLks0P01rcxaIrLnv8Mgq3ZwrRJH1SzRJAHQ=;
	b=qkdwWPBLHUw1drvglwXz6aNco1cYqzlEcLkWyzk1ublFoCdpV/QDcrwK5J1qclF/g3mBCW
	6uHTFk8JKnc4jd8SCXGlq/7HCJrBJjGhG5hyENUdwL6aJqS76D9CRBSurCeLGf1EunkCHp
	yhKRFbRPpqJ2AQseMu+/sTgx2mC3svY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lVQa6cRqLks0P01rcxaIrLnv8Mgq3ZwrRJH1SzRJAHQ=; b=Lz9EGP21r3Ckl7whnnUBaDo15q
	FO0M82HZT+fhnwVrNphEXkrWPHkrfbfmds2myTY+EFBGuJksvmWya7ISOOA3mFNCzfhHTSVL21gYd
	kIZF0EXvxeOGjeIZIQWp+pbZmeMmz3oEe60N+FYSaVm06E8iQIsEDBtP34DnBKcomlUkzvvaVsQwp
	/xenBeGw+jpHtqoB/KDeeI3k6LmSMIr4HImpYLxVxnPRZafonpuRyIoXZ+qDCxZRsRX/AaX6FyJD2
	4jzU+9M133RjoBO//tiVMxD1U671rLErGmyPMLyCNiLvEh0Rqm/ejAO+Qb6eelJLhHcwbcS14iWMq
	b91AyDXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uSv-00000000bK8-0TYN;
	Tue, 24 Mar 2026 05:38:09 +0000
Date: Mon, 23 Mar 2026 22:38:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 08/41] udf: Switch to generic_buffers_fsync()
Message-ID: <acIjQVRICiVBndVr@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-49-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-49-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1065140002
X-Stat-Signature: bd6gp61xa5x1giebu17xph19h5hr5aqm
X-Rspam-User: 
X-HE-Tag: 1774330696-316550
X-HE-Meta: U2FsdGVkX19k5bbCh43Cw2srQrVP1XwFx1+VccKMmyETXTbpha0UN3xrE6ly2GA3D6QPC0lC9tAU+wC/eMNUOSdxjGlW2a0gWVbX/CuYBkduvWo9c4Zma6S1eplzsiwBKULkcJhhlqOoo9Xo92+H5o8J0dIiMjsCv8/BlJ8uhch9ziDFcGeErnPoi02MTAfJDbhTaarUSPtx/RqIN7qZAqlapw4gMpqfgYysrHAZIxs2oChxRvgShieWCG1+aXNWjO6d0H4bqxJvcJP1aSV0aLTaX9a2sZ6dxHxQSoqemVpuOVSRAn1k2rywd0SPANII2I2diDHHjGycytU2AC5VUTwae6eHecp1znYbYCj5AAr/tqAS7MD8o+c0ALiUgUrVerpVB37Xg6gOippn8MhSzdwp6TCxpSM4hQRoaY3aob0YDws/AcQHkkDofbu9LLjnsKwNjQ4W5wqUilv/KuSYOpP9Gn2celTd5YARN92wQR3lMLd7IHPhAn+IGlJkoCNNtIwcrPkVR14WPQAr+BvgJek5LlhGFj5sg0BEBx92VmTvPsAfCMMVet/BvpNa6Yq4SG1ouS4aYwyUVF9OIq1pMGsjYIjUxGKuNLWPHQ+bQ20GShmdjpf4YuwzHAXz7WogA8GRGAIFUOAdK4uhqp2H8T5lz6dIv9nMAv+/y8e/OVxs8lMwFcl+C3TNYxbWs1a6zuxT8T71W7BJ2ZecrISJc4xhw9sUq8L6SlwBw4W/5HC8qgbIIxdP4UNqsp1LB5oGlhn9PfK7uYC0Do7Rd6UpdpZ+h16T73yzjAGq1nQGfCByR5pScA07NNJzv0aDwSm543RfZvi/W0hLY57MFGj2LdTqMuS7bqrifOIt6ndwFWncrnxxhmi0fOsGhspX1y41iXLrO4JfqVdRuipNxqxXOLmSG1GCqTUpdzXs+k65HsB6Xcg1shLVGRXlUEEWF00JmGsi6LrAuU0x34rDagy
 BDHafcv0
 AfXIwFUw9JC+/oMeP7KdvnEg7F9fRORlr9FKjDjdsJWrTpib0xpW2cvkd/Y3v+NqAKhPmWaN/3dKwSOmrfYElqKooqfR3rt0ouxyP4bpZh/bphvjZAkXwLH+J8z8EiHOpTgPeDf7rE2by/prqwsLzsCxTorDyHC1d1lUbzHkYfXKfqzllUx0S+Mb5xApyjgs0qCgbgEc+mzKSzm8fzMPwJ7sLBDeSJNQAzp0/4OYSudn1x9p4TXb5tFJy7M5pDkDgK+DKUvu2qzh3oceGN4SAQt3FzdHYatltDzQMz4pUzkcEtQnAKT+ZrE7OFfbeXadhHPwbU2ZUPNEiSLaZBJjBJ4ZnR2x9c9bJ9y3Xh5VI+XcBYU1P5gd+d7mY9tWoQHm9JbJde0lC82x8h1jrNlBX5uZ7oapyvdrQ2yQQDfl2FUhz3ybZXPiehJMxPsdFH1mQvkDStrlOxMBWhiI9GBsrPHrlnKWcYy7zv3Z5TUM+CJ/Elkvvg3sNwNLcpqjnn2V0VvHxLI4FpkPnqXl//V7xlU0sXu4igjEhvkkgzv2f4lk+RtCy216WrR4j467YlCtkg9Ek6aFtnigAMaOCfDoijxURVneB1ZqFH6VS+afFQdrYwh88sKl/dGn1ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 02:41:03PM +0100, Jan Kara wrote:
> UDF uses metadata bh list attached to inode. Switch it to
> generic_buffers_fsync() instead of generic_file_fsync().

Can you explain this a bit more?  Right now the only difference between
generic_file_fsync and generic_buffers_fsync is that the former takes
i_rwsem and the other does not.  I'd expect the commit log to explain
why dropping the lock is safe and desirable.

Same for the other similar patches.


