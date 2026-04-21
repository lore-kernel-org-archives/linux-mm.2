Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767CAF327BF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 08:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFA76B0088; Tue, 21 Apr 2026 04:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F946B0089; Tue, 21 Apr 2026 04:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8957F6B008A; Tue, 21 Apr 2026 04:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 770346B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:19:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC3FDC3C32
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:19:47 +0000 (UTC)
X-FDA: 84681864414.26.45C9495
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 401EB120005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:19:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TSwoK5Me;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776759586; a=rsa-sha256;
	cv=none;
	b=LZjnAuYlKbHkEuY775n37BsVPuqk/Pvst3k6hh0lYMhrLqNHZS/sYnmaW04Z/q983cO+OL
	cI6kIO6QTmc+7hSR0i4VDCysay9DUA19dsq/UOCRUYdBZ5ntRyenNPRCScUAvkp3YIxYSb
	mgAzvAUBU6ITzbyU92fzvd0xONU+m3I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TSwoK5Me;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776759586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGtVUyKkBa8Y9hW4MvBU7m2QNsNOOCiEej76WnOucvI=;
	b=cIk+kUy/rjPdV8LKawS8d6EEHgg8eWQSuCtWEtVLd3mrLSTZX0KKswA6+epU5ACENvZUIj
	Dnng8gK4eGv1h4CtZriJmV47cvKf/U4yvFHfyCEDfCWjq9LqQBIQR9Icgj6GdHZgZMgKCM
	/Yt87NxVO0t139wD1aVH6chHD3mcho4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A4A344005;
	Tue, 21 Apr 2026 08:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4196DC2BCB0;
	Tue, 21 Apr 2026 08:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776759585;
	bh=V4FX5dzUh+XiqVKzFc5sM27L6b8ZdiTUZUJVvzyyei4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TSwoK5MePptekyp3K7AJ8/o9ZokyocVGKgdP63CY67ERuOQ/iQqkTCd11fahOhxw0
	 xQYmbGgEgbv57+eDQb59/EgTMRMKJgtlKmba8T7xFhZQrSlH80NXAhn+IzCqBZwxoc
	 fUivAXeTlReHSyZLvyn59GSoBfKam5OjFsuIG4tJS6+QbNqQtUp5/iter8bVHTYYYJ
	 ZW8kSxIQUHTNRxxa2Lpen5qu2bgP1k3Q4qtHvCX/hiqD/x1RlsGscjFsOyZhpwB0Tg
	 CHgxHRvJ+g5KYhnokZVdppn4JrUMYHvkR1L6L5o0TInCMjxNhohYi24DImYbaOgIQ2
	 G/HCHTF5h2DPw==
Date: Tue, 21 Apr 2026 11:19:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 16/53] selftests/mm: protection_keys: use kselftest
 framework
Message-ID: <aeczFjEs6sqRPy0w@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-17-rppt@kernel.org>
 <f8495e44-a34a-4289-90f8-0faa71bf1a71@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8495e44-a34a-4289-90f8-0faa71bf1a71@sirena.org.uk>
X-Rspamd-Queue-Id: 401EB120005
X-Rspamd-Server: rspam12
X-Stat-Signature: 3qdiag5b4o9spem1q55z7d9b3szq64y4
X-Rspam-User: 
X-HE-Tag: 1776759586-156599
X-HE-Meta: U2FsdGVkX18KSygLcLJIc/2Z/1QuxthYBjoMQYS6vZ7oMKTMA+78YKLhDhdD7wGBjwHfbIO0+teRjpnD8f5EzXSeaBJr2bLM//c/0TeqvhyLWVJumX1enFrZ/obd2p5KuKQzdkrbVHS0p1MFmfxQmxA3zJ+nWIaRAYa2t6UxdtNjYykCkUY3EVTmzF8Tlx3+thvlgCKzwQ6mbQtdqTMaYQma8pmQiS5rlD+lGwsvlpTSDsFu+DJCAPeF1/czy7mRxYbJNqdxxscgq3AJtwmTLZgrtv6aocQqlkxcgg7VwKXinQJqythfG9F42ec18Cm9BVRCpHhVi2RWetJMir6Mjn1uaLZ7EqBsj2ColXNdRs7hDpI/KiQFK06IkrtWC60TcsfuZYGcHfuYyQYojZOl1V2/VYdg9pUuEDV6OPoGkjB6UhIAtLdYBYDaVDv/aZrDOzzZgjpdaC2UIUJha2vt3wxoI6BWEUOMqtZSgjKnWq+sZd6f0eaaTqmSOT0cQPufAl2N+qZcfJN7rNGKVxbThXsMDaIi9Hjg7aiaoh3BAA6iaLbovu8Cg5WpRM1P95ttB1qXcb9PZchPaQCkVxSZRNCRnmijC9VTjUp8+WJoOrZp4l4cE+2uSc/Re+xupTvOIABo3876f0Oz3e0IUE0bXn6Ve+FJD7J8r4TXd+L6i17ySPffaNC+FttTySkVofIEpTZxDElG9XaxDEJvSvhZK7hQjSxHlm8ZjsQrsYYvOyW9J/THvNmjWH+Axd0AKz3J5KrVBMwph9Xoq2TlhWi3vkS7lcMMoo1+lFcSxn1+LbEFE5ks8AZSDZ4iv1gaRZjsurCkzbkYh/+xHyuJ+g5951/nZ+cthEpyliHlIOfUZZgDFC/JyKAa4Li1FTAQEjuT+OOdlk6e+bv02jXPOOliTYLhDU4ccN711RRVqJgTpXjeOCvdNnxm2w+BGFd7DPboGb/i4tzop/zfGWmF0kK
 3nz5hYTN
 HMLsE4TVN4cXHy97d9JVEIDf7ox7J9bwlyDTe9csktJhJDHS4YGMpb22sUZyl78iAzaeuueIb7pPbejRm8wrlLrWe8zAms+H598AgEZhgoYsBrkKa5+1JxzOYx5lPk/PBS10sjrjxAqCrh3zKsdIYbC93cmBqH5hKKRr/5a8cmKx7v4JB32XnIK1HEqy6cFNPa1GH0d7vBr9EWw6iy3FSFtgwICBhdDc6gqg09xFEDmHjcSjqU8/Anx9ond/dsi9GywqixHrZl1MoDXFy2ubUlxrRJlxuBFN9+yAVPwxoR6aNBTprZWRnAfmZbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 06:54:31PM +0100, Mark Brown wrote:
> On Sat, Apr 18, 2026 at 01:55:01PM +0300, Mike Rapoport wrote:
> 
> > Adjust dprintf0() printouts to use "#" in the beginning of the line for
> > TAP compatibility and add fflush(stdout) in the end of the test to
> > ensure all the ksft_print_*() messages are really output.
> 
> > +	ksft_finished();
> > +	fflush(stdout);
> 
> If that fflush() is needed it should go into the helper, particularly
> since ksft_finshed() calls exit() so the fflush() will never be reachd.

Looks like I'm missing prints because of something in my environment, I'll
just drop the fflush().

-- 
Sincerely yours,
Mike.

