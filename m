Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF7CC55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 21:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948EB6B007B; Sun,  2 Aug 2026 17:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9DC6B0088; Sun,  2 Aug 2026 17:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8F06B008A; Sun,  2 Aug 2026 17:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5E56B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:52:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47EB01A058E
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:52:30 +0000 (UTC)
X-FDA: 85057678860.21.FBD6418
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 55050160003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:52:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cc74KTxl;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785707548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkIZNLyjy5H2HxUDtsPS0FkLQCvxSildqvdFqEyK5e0=;
	b=hUYk9meDL9SXBGbApFJ77DHtmcPVk29WRoSsDdV9qzlsej3zTmTeRNWfNb/cVmOs09Czx7
	eMjEazdXEIqUG2B6+sm45IbhnrDdpug51M63cz/C5YePkrHeHkpGq53B82EWoiw2gLTEbU
	r9d/JYwnsArKmi52hVvV960SGNKGNNI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cc74KTxl;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785707548;
	b=hlc9oZ7P79P4A8H2YCIghXfbRaTlNKAtZgRkYnowLFakAr9Nu3VFXlWY6pq0ErUD5I46hh
	DiIeLpov1kZYrz7UIxvoMFkDUdNfmKBhbscFV8kyWPSGZsEWsssLfHdCAo/74+4NwBvPr/
	1K+6Nmzq+A2bC+2kjnTPfDBSuTfuK8o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NkIZNLyjy5H2HxUDtsPS0FkLQCvxSildqvdFqEyK5e0=; b=cc74KTxla2ziUPV1cjMhrHDDtD
	qc+2wJV6rBHWzv1DbBUH6EU3plv4phcv7RRqsYv/0IZ06ugmGZzK8rCyZ+1bp7daMTGCl/NNu8RCi
	M80z/TQBsdY19YLbCt78ZjWE9W7kfemXeWqQh94fgLBuSa0PADSGA7sCsEUIpTdQ83yFsMoaBT0uO
	XooUUgXxO61nnwzclSBrbpGQ+cyEflz3GY7rtyGsMK4JsCYr5sglDkyS7lQtPjdmJYTBsIN4a2HN7
	NThFm2ykmg5gRBYlwxxwOnGf+jhcGWy1cpTODKzeD1G+MLhFOQkU/FobtYs530PfdekKxrrRvDFJk
	Y5YhyK9Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wqe6D-00000008mjd-3nGW;
	Sun, 02 Aug 2026 21:52:01 +0000
Date: Sun, 2 Aug 2026 22:52:01 +0100
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
Subject: Re: [PATCH 1/4] ceph: add ceph_folio_snap_context()
Message-ID: <am-8AaWEHm7I9b7N@casper.infradead.org>
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
 <20260802-remove-wait-on-page-writeback-v1-1-6c35d6b3ad36@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-remove-wait-on-page-writeback-v1-1-6c35d6b3ad36@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 55050160003
X-Stat-Signature: g7oq3eharm9z85xooqs5gfdnrgy773qt
X-HE-Tag: 1785707547-176525
X-HE-Meta: U2FsdGVkX1/09kXkuejXHLahYVhnHVcN1jOM1vOtyQ6szO7nqEGCYwMxVI5JPRj2Gk88TL7hZ/sTwugHALgtxIBMPPlHqFsMiMSg7jpJM8MWc5mnzOevri1pSY5vXuaeJRrQzRFpTJGNyjdfvz6RyrogYRgVpH9iP5nMnRtXyjRUAhJoKpxHuAxe5qs/ChTbGNz8+wGBcbgJI4rOR3eIr+1KVX3wDIDRodt1WV/Xww81JPUtJ5hFQOaahws9R6pikJXmt/ahe3NQqIn4ovCoGYbou6PFpoNPXcpTSCg64szqQU1xQXU1c0ClnKnIGqQPMWfCBX1A+cK9VIBAn3dHxRJR7n6e6U3mEQtBrjEFpqcxZ60xmKYkoDM3ALaHfn6pl+9cpjJJGfgRb+wnmWg0gmtwl1ygj7OxPQibz+2Nzw21cTaQFfquDQfn5Rt8ikmIKuUd+OVUdQUjZR9vESm8r8EKKs22uDEbY7oP/+emQK6xy+qmGC67z8PHUQpyJ1QqH4YawD+pBYzmFvF33kQawaO1nNThj6X3HwlsvuNT12yESu2UvR8gRntoDtVtNH+uUH40fkLrGzFE7RYmkbiW0Sp4jOaQECXZhFyOVbD6osWLYa00sXX5UOuliiR76hBK79kwuiAMQqvukwHtzrPOStiybhrgxEvmJN1Pz1VSgAy+Cb7hmOmzLHO2Zjgb4UOMQoHzv7eKcFq5qu+t2A8g57DRexmUp8RAGzsKkPzPC/xqmxMwXs8+1iZvc71mwmPxK8O9uiUGrS/nQuXmVLRIt3kjtJfUHqg1V90D9ImmYTfF7zgImVsbXBYl04Ts8gkfyBMV4q4+uR7panNN3iZlUsiQ28wKFtbd7LIznHNUXjtkGLbHdkvBWGNlOYTHPpBF5qLBMu8XO0v7XW2DG5x9FxWlBGXwvlNl/7lR0Mmkf8PluRT7IcgbJya/hOHZRmP75QOZizQDJm/jIphu1xf
 blToEu7K
 7JmoeKEiBVU1ySN7/qsUb/ep5LM1bLsvKYI/ePjdf2qfZI6W280GI3KawHtSVG5k6IAbgjklER73fgwS+RNfaJmJfVQuLCQqMlEE0kJhLiCVz81KXrsiC1GtNyL1tbmxWhssPqyXLgghtggXluz3EREo48BSUVT9LiXxluIYfCWfGXm1d1/v8Y4EmjlEHFLDKy4iayQeZWaXvJq8Pzl01vryfdnqBrMNzSvNtvhZRer2q5E/X5PfDTwRDrSn8oj5T3tNGMouLO/nYJnX2vyUpB6MHZ3wOceAbSwMX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 12:50:02PM -0400, Tal Zussman wrote:
> +static inline struct ceph_snap_context *ceph_folio_snap_context(struct folio *folio)
> +{
> +	if (folio_test_private(folio))
> +		return (void *)folio->private;
> +	return NULL;
> +}

Filesystem folios _ought_to have folio->private as NULL when PG_private
is unset and PG_private set when folio->private is non-NULL.  Now, ceph
could be doing something Bad (I believe hugetlbfs does not honour this
for various reasons), but it looks like it's using
folio_attach_private() / folio_detach_private() appropriately.

So I think we should just do:

static inline
struct ceph_snap_context *ceph_folio_snap_context(const struct folio *folio)
{
	return folio->private;
}

(folio->private is already void *, so it doesn't need to be cast).
Splitting the definition where I did puts the unimmportant information
(static inline) on the previous line, so somebody grepping for
ceph_folio_snap_context gets the return type, while not breaking 80
columns.

