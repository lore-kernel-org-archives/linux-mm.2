Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1727D2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 04:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D8A6B0006; Tue,  9 Dec 2025 23:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4ED56B0007; Tue,  9 Dec 2025 23:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64736B0008; Tue,  9 Dec 2025 23:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98ADA6B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 23:27:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D04C134844
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 04:27:41 +0000 (UTC)
X-FDA: 84202277922.05.D34CEE4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2717E40006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 04:27:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YoEtHsGu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765340859; a=rsa-sha256;
	cv=none;
	b=HNYb2ROnA9GoCl5/D1smGgK6Ty4uiAEa+E3cVxcWJwUA+ohKS2aysw5wUJr2i8wHxOL1IA
	MaJLeDfbFBEAURMB8W5HmJdD6vAfEbq1Iu6p+77PNLs7NBmoYiJYHIpzTuCsHxq2avh9xk
	iwmtP3oW/dhoOuKm+H8NJcKnh7+TULc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YoEtHsGu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765340859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQZTyVY5EI22OfoG+6/Jw+yO17GgHGjfzONX+f4GGdA=;
	b=uVzhS0GUmoV2tS+MLYFUd0XLGv3lZNFXxrdjLX6uirPG5wASg7sVq671CSGxlKey8nPZWB
	xaEgFy2PqVN3qM3+Cijygo7ynxk/8H7ufhAIHnskwXA2KzcW8qEesKuRcAJPBeYYKrysYS
	gBQjYoxt/7KpqE+fSIttUZlT+vswxDo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XQZTyVY5EI22OfoG+6/Jw+yO17GgHGjfzONX+f4GGdA=; b=YoEtHsGuQbLbUOQDdHALmnfwAY
	tNqObB8kUEP4Gy80sUh6a6H3/Nr0AbajRKuSYoR78lcNgmUVQq6R5pU3F43oxeaOzBqymfrpbwlsl
	cewMwuciIcEhRpC7dPshg6Y32cTaC78zq8lGz4gNi0bnkaca2Iaq1beqJzJinqtKiyBt7shpUUL+t
	D2u3r6TCbz3yxZH6CnusT0Z9Ocaniazn+dSz0vWuJRlHTH7mSLqVpLOFOc26sI0wx5RWxlBz8ekyx
	5Eyyjcz8lV7qjG9j0yy4um3BWtHJEIocISpWzduMS6rBVQ8xyNV9Psb7wKqB91GwfGalaY84SbD60
	vpvfQdFA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTBnJ-0000000CJG5-1xCy;
	Wed, 10 Dec 2025 04:27:17 +0000
Date: Wed, 10 Dec 2025 04:27:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Michal Hocko <mhocko@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, mcgrof@kernel.org,
	gost.dev@samsung.com, kernel@pankajraghav.com, tytso@mit.edu
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
Message-ID: <aTj2pZqwx5xJVavb@casper.infradead.org>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <64291696-C808-49D0-9F89-6B3B97F58717@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64291696-C808-49D0-9F89-6B3B97F58717@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2717E40006
X-Stat-Signature: s45nx5qxetazukznag6na61674y64hu8
X-Rspam-User: 
X-HE-Tag: 1765340858-832742
X-HE-Meta: U2FsdGVkX1/cPvDMyvJHAr+o3+KPHjbgyKxZU+4FML3O0R6odptTp1wa1EciFFjsHquPf9H59w4SvBE0epNka0VNghA9hJGAB/5R2QEuS71EQmdBwSN8Vla24VSxJvMfDiV1Qtcw68GehQa4da/+ZG+cOFg3gI70oULXA6iSpellViyt7BUYBO9wCgtr1uZ2eUynQ5bxZx7RNlG8Sl+7fGdt7ktV8dIpLl6TJaXzxggvB7ioyvAzK2RLsN0b+BGpB9EzR1EfZBqKZXKzUeXVbOT24nlatvyV1oAG5uPnQb5GvGnBdU0tnsdKVDTplOIT/da5RrovvNywQq4GhRME2Sl3vXwqu3sz7zOKt31o23vcgHu/PXiaNoSwtbOAbyzv+RVepXzuwMa41q7mgQ1kIX0Y75jRZXBBXzwAvZSAOMUIT0yF1ntGg4BSKs0jGOS1dWMnRWxjM1I1Hq+nFpoB35XccZqcXxA+BTd6ZrtCsQG6Nb1qVmhTZI7S4CpBHmIAMcy0Ni4w4xdxx4f62xjiddukgLmoqNlfqNlYcFBtlpzwhrJ1yON/S9LEW1K2JTvprRgVd6wva1dHMH921mRZYDD2qqDm+dITRIQ34n9hgb5ROZeWxVp1+ZCp+OugWooy+ljeJiwomvli5TXGJGrfPSUpJLgoczBVNMYzeqTWXBpczhUsSVtLSj88Y5Z5O1LOT/EbbqtBWW7PVWspc6YsW1XDr2DU8IBRZPPqUusLfKwboIVVQL8zCnWB83IrS/aFMeVDBkZWDv6c4PVHKzsNRg8lqW3x1J0e6KZ8isIKAHFzIbUdhqc0sJjgqBCKF8z2eOxOcxVRQMH0NlCGTxoGaN/C1diScTGzkZ80RaE3OYrSMFdSRMTyAfxVHR7cgR+SfrHWyxegOlJkCRLIWAYAiXEVIcSJYjGj3A8WYSyfqx4dOZKu1ANRjqFD5hR8A/nEb1GH6pIIqFyUYNlhdpP
 5gJgg0qm
 x4ygD/WD8AqPYA2iwLWUfVwi9S4tz8fBSi7hamIpM8IgSd5WeZ3F0dwdPr3xN3cxgjzd5N6dXcDsZyIZBmEK6BRobyjbuwaXR1T8CJ6b0usFofJ0iSvjI8jqJL6JCqe9i5GNXhfpwU/GIQn8DESx2kHRC5vPdvzdW1LWAUitVoziBkB+zGWA+GKdzC9jsTegD7hTV9mbd7jc6LsVkLPR7b3DBwEFW4dIgoe66lbDqpJvo0VmoEtgK9dh/PsNakNuJ5cFs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 11:03:23AM -0500, Zi Yan wrote:
> I wonder if core-mm should move mTHP code out of CONFIG_TRANSPARENT_HUGEPAGE
> and mTHP might just work. Hmm, folio split might need to be moved out of
> mm/huge_memory.c in that case. khugepaged should work for mTHP without
> CONFIG_TRANSPARENT_HUGEPAGE as well. OK, for anon folios, the changes might
> be more involved.

I think this is the key question to be discussed at LPC.  How much of
the current THP code should we say "OK, this is large folio support
and everybody needs it" and how much is "This is PMD (or mTHP) support;
this architecture doesn't have it, we don't need to compile it in".


