Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446E3606A683
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658A66B0A38; Wed, 25 Nov 2026 09:32:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630376B0A3A; Wed, 25 Nov 2026 09:32:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56AFF6B0A3B; Wed, 25 Nov 2026 09:32:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324DA6B0A38
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:32:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C12B740F47
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:32:15 +0000 (UTC)
X-FDA: 85473881430.09.09F364C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf27.hostedemail.com (Postfix) with ESMTP id EBE5D40010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:32:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795617134;
	b=AtGhA9pbDYeM1zgnQy39ZKCfEzyYP2dki57aNbawBSnU4YfACA58Dxzn6MtkHnitSGU0jA
	k5aO6jy1JWTzsPFBbeEwQoeCx4pgPZgozSPa0l4iXaGQvBwUbcQQqCXxx2I8Y+t3sBK9KO
	efz9Hd7XkScFK5r+g4Lzo+W5yky5iow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795617134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PtRllFgQeaJJif96OcO1z/etvW3YwrHKGtxNZDdO9hA=;
	b=c/8agz51d/oeQVO6BYilp36M5NqAFJ5ErGGszHAKIjkln8By86jJO8TWXttKSiLCFaKRSu
	merOvB7vSSdMFhEPwlktjrpKo+KrU4LlDi/XhKoZ8OlGhsAdJHoS5Tj87nOKE2UAQg24RP
	f5r3KA15b7Y0w9M9TwkHbgq8m9pdJQQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2966F68BFE; Wed, 25 Nov 2026 15:32:07 +0100 (CET)
Date: Wed, 25 Nov 2026 15:32:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Rik van Riel <riel@surriel.com>,
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Removing ->dirty_folio
Message-ID: <20261125143206.GA15229@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com> <ao3y8TtEGjniZ_4f@casper.infradead.org> <20260826050733.GB15122@lst.de> <20261125085814.GA24887@lst.de> <woe7ui2vuwznrdt4zxynkbnte7r57juoaicwuk4hmwmlhq7lmp@no52geqttfyk>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <woe7ui2vuwznrdt4zxynkbnte7r57juoaicwuk4hmwmlhq7lmp@no52geqttfyk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EBE5D40010
X-Stat-Signature: tudqsmiodmiccxyiq5zd8pcyb6xw5gtu
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795617133-563774
X-HE-Meta: U2FsdGVkX1+N8cXJaVMU6FD/OuB8bgZCo+e7HmQgPqJociOtV0Xe2wSVIq42XovPveBhnMisdbvLsNkTeIswVHO8ZtSXka5MSy7BP0i/B2aelcAjYkX2y8u7qHnJVSu2IW2k3XUQQyV1a+m9WSl68Ml7vTKdk/5DOffQXglDLB4UFvozYkOevXu8g+bUKM1CkMMZU6J3kNkVT8t1GQqZiUtSoxqfbKEDnS6yIyqKctT5m28keYUEGgNKCltea59jsX8rxswQh26VQ3yduj4/+vknfRA7htnSSoCNlEx6fbHXmAqMCqJgxxJzQKXvroE3gw7qsdfQZgao/+3MO7NTQYKpVRgFnTCjxzJtfx1grrV+Fh3oiexTTxf6FmXEqo1QmeeAwzRu7fT65vXQbpUwld0sTGjV6IRJu+a1+wq3weulbN1oyxglVqY4hs1B96HgLYXFc4vmCudLvXpXlpwRoiR4v+O1Gi3QgxIy1eo8sOvihIfYkePTSwsxuBJsaimjclIjDbLPAQI5ig4bwJV1ihiNZYnlPQZI11R3TPa/aLYmT/YgiMiodQyXxK61zfXj1rskVrRFcHc3M4jtdT6BzxC3EiIuL35vJQaQsj4pfNtyRSIvAhoWsNMJ1Vut9X/P819eaLVVZPDDgUqyw5s9b1CuGe7kAe9yykr0QbQO/ibzEcExneXI3oqsdg/WfqhAhGoIL52VXP+VCLxCanHrqgXmGKp3XKEouftR3orr7mz9dksf+Gw5NYfZqUZuIA3u17iBLgGVbMBf2iG5wMZq1ryq7AFqTnsTuMofrWLr8IW136VQoqL25Zpv89hWYXl/X5l/DD3FLchYi8pIjEeTbBj/uScRvG8QuWcdVeTKdPovBA0vMiDBgGmPZK0ro/9XQ/UXwY2ZNkT7TUAtHek2pLzeOJsMUSfxiecD+qdXSycNRhIc2P09xo1maBOm012ms9cVbabeBPG2kSY4u6j
 KTaRNFHW
 pNSYb2tNgfG+pwoO8s4KlPOHVNdLKPRRG+2NkqpW9YTRSn720haAgq0vBLPuxWZeHNzNapqZPZa+d4e5hSDIsOYmTEZqktrBjRMDxi2cSQsvfuFt1vzUeaZzQP9Dx0gW2jnzEwe9ldzM7Af+CxkukOXUZJ8Em/eTWrkfYhqFqv8nwro8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:15:40AM +0100, Jan Kara wrote:
> I think we agree regarding the direction where this should be going :).

Well, that's good.

> Regarding the tracking of longterm pins, I remember when we started working
> of the GUP / pin_user_pages() fixes, one of the ideas that we floated was
> to take pinned pages off the LRU (they cannot be freed anyway) and use that
> space in struct folio for the tracking we need. John? even had patches for
> that but the performance overhead was too big (primarily due to LRU locks
> contention) for direct IO. But for longterm pins, the additional overhead
> of the setup could be acceptable and that would significantly increase our
> maneuvering space in what we can do (because longterm pins are yet another
> page refcount in the end).

Yes, additional significant overhead for plain FOLL_PIN would be bad.
But for longterm pins it should not be an issue, as they should last
long enough to amortize additional cost

