Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79913F5A8AB
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 18:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7656B0088; Mon, 20 Apr 2026 14:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88546B0089; Mon, 20 Apr 2026 14:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E516B008A; Mon, 20 Apr 2026 14:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1656B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:41:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E25C13C02A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:41:09 +0000 (UTC)
X-FDA: 84679801458.14.A42CD8E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D6FBA0006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:41:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Uxw8dq3M;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776710467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=US7xk5FxdqbPrtNDg67ilQoyRup65Jv5pMgq4MufUEM=;
	b=5EdyvRMkRoeSHSuIi6IBYORqnHBd38EGtFNmcheJzZxPaKUsksE2/MbQXiZXylt15ljp7U
	SZl3MsX0TB2Qb9Nl71DVLhtRroXdFsZa7cFNUyssvGQeO0XHL+2qdb1928FsVinJdRHZFJ
	CavcGjBEcjkLaiwUwPqaa0mFPGwfZA0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Uxw8dq3M;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776710467; a=rsa-sha256;
	cv=none;
	b=wWAoyVk7NbdJ2UTFY2V/ky6PSLK4Yc+COkIUbQKpKi4TcHebqz7meiGDDSvBVnOOv7dj2y
	Ua3kM3hVLrYaI3OqkqmoSOBOcI9+0Ue/KuafqtbxNpmQYzesv1o16RzKGk3tuIyyyPzEyU
	yZZFhY2Ex/CoztURnO02mWw1pKB+TQk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=US7xk5FxdqbPrtNDg67ilQoyRup65Jv5pMgq4MufUEM=; b=Uxw8dq3MdMz8mXBvJk8pRiEKn1
	inBCGK8of1iaOkAOH8Q5SLMr9p+3iW9qIQ8VWWQtQsyHX6nwUex+PY9yVzSVVgA3yXPfUiZPwLRqM
	ifRYOL01IYQ533ffUK5FqeBZw8iaqD+nHhNWjrG/IDhJ7AqvE2UjNA/Mp+KgioX/2xx3GZ4lVQKgG
	VWDRAR8/tUtwx2bd3UPIqeK61prrotV4e9ab/HuIliklfa2kXB2i9m88KnHIrn33QIunjlcdGlkdb
	DLOpWdWmXYDYW5q9O/JWD9++JoreSB0f7kYG9O2n8UM1rFHqSwbOzkwCYYOV0vySueq0pgy5x0HyQ
	593oZOZQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEtYN-00000008sKB-3rpU;
	Mon, 20 Apr 2026 18:41:04 +0000
Date: Mon, 20 Apr 2026 19:41:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org,
	ritesh.list@gmail.com, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] mm/filemap: avoid costly reclaim for high-order folio
 allocations
Message-ID: <aeZzP6iQel-tkZOu@casper.infradead.org>
References: <20260420161404.642-1-dipiets@amazon.it>
 <20260420095106.86ecdb685cd31e0847362512@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420095106.86ecdb685cd31e0847362512@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D6FBA0006
X-Stat-Signature: saughakrzfgwt6t93x6poitq7s346bzo
X-Rspam-User: 
X-HE-Tag: 1776710467-278181
X-HE-Meta: U2FsdGVkX19C/eAH9g5zkR2n8OqT1Fp9goxoNKnCQ7QfjrLL8sZnLFn2amN/shZdxVITogHwzv+PPvqM/cA4+GRUk8OGJAjLhP+noaCpu1jvj+8cZuD2JaDxseq4h/ytBQGL6K3ji5g6IYedZ8JDxd1fQFv7MlGwcdWCZ53WZ3YaVVEGN+zDXwjytIImD1JsJ9SlTLPfHb8/ZolO1WsRC+xaZj39p2bZERgJ/Wzb6+/jRrdO7K3PruJ6eaMioR9MMj0OggNckKbKKcHq98f8pVH9p9q84xPKQDG5zLTXfFWw1OPLpM6EZlMwM4NeJlhIxQAoGa48UAmfeo2o8xjmDXBv6mItlzAy4cmfgUP62r+ua9J1ZITSkwQgeIFvtLkLm5XZcfdeZAuiF2aCaFsHqIzOTNV7pVUnnTuK50mU6zQ7pxEyAxoKTZZLcIcXE26gdaD/xM/wbuRRtjBwpVCpW8l1d+bO/YOtKTYafAdTxlZEQAAxQcBGVUK4UabGnnEfpmsCtC8/vFawiRqSnGIdpbCcK4w7l3PnEOzF4Wqa3KoNPw5tEWn0I73t0qRTI6aPRwVgcqB0V9WOAXgTGkyDS2qJWHxJtFPtZbURgIAtqi7H74id2V7TqeRG/1EIl+8q0UeZrLiuTHVU7WxPQjtNuk569y14gpTq7eRF5dh87enl9Me5ZUT05YOvmwv52bKOnH8bwFVJZ/Vr0yduheEtUcZNBTGtSDGvbT8Jk48f4MfEPPuJBnFamoA89D1g8QfMU4SyIWP2zmqj9rN4pGJCyU0gxoNOA9Fvcd1yCRtYNHnnnJhpQ7g7vdBVRxa9uifDoJJFk6jAXkOXUeSDk52CGRDLBr+sc2iQPvNdymwm2rRtWruJAFUsWRQ3kb/SOnqI/ThJnl4AfGoMj0J0NBGhNGOB92CG7j5QtuXun0Ve36YDpg546O09n9OpgtNiHvMJkS1tljJWI9XWOnyRyPc
 nARVKqs4
 7UdfRIu2VidfQn8b7ILzqmm3+Q26y4oLPU9u18Q6BchhriJAyeOsIeCcLH/RJQQuG16JFPGLhVrD6dX9XL9PVEnm0b+LCsGPqudYmuTVD/HwukJA5RQRvDhOk8YpL1CvdZgwNxYOt00nEdsWUZm4hPId8reBRcx/HRx2d5NaKKX4If1SC09kO71Px+kQl/i3FZbUy0PV+SVMEypMfiYM1aZ+U8guhqzcBITQEDpbCznZ5dcz4Jk2yaOLb1+O8NxtljvwJdeR/ixhHbaeBYB8wLN2qYJ0yIVDu/tldPdjX+dImR2lZqb5UmrFP0c5F/qveaY/ZNvYxYZW5BTPHc3K6ZCWPqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 09:51:06AM -0700, Andrew Morton wrote:
> On Mon, 20 Apr 2026 16:14:03 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:
> > Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> > introduced high-order folio allocations in the buffered write path.

No it didn't.  5d8edfb900d5 only allows the use of larger folios if they
already existed in the page cache.  d6bb59a9444d allows the creation of
large folios.

> > When memory is fragmented, each failed allocation above
> > PAGE_ALLOC_COSTLY_ORDER triggers compaction and drain_all_pages() via
> > __alloc_pages_slowpath(), causing a 0.75x throughput drop on pgbench
> > (simple-update) with  1024 clients on a 96-vCPU arm64 system.

Why are you pretending this is new instead of already being the source
of much recent discussion?

https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/

> "Good money after bad"?  Prove me wrong!
> 
> Instead of performing weird fragile hard-to-maintain party tricks with
> the page allocator to work around the damage, plan B is to simply
> revert 5d8edfb900d5.

lol.  best of luck with that.  you'd break a lot of other things if you
did.

> 5d8edfb900d5 came with no performance testing results.  Does anyone
> have any evidence that it improved anything?  By how much?

Christoph reported it doubled write performance with NFS once NFS was
converted to use it.

