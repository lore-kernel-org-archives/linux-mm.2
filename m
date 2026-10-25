Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E21606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=jH6xeLF4
Received: by kanga.kvack.org (Postfix)
	id 5EF696B05B0; Sun, 25 Oct 2026 07:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A00C6B05B1; Sun, 25 Oct 2026 07:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F3A6B05B2; Sun, 25 Oct 2026 07:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 235966B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:19:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4C2C16059F
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 11:19:52 +0000 (UTC)
X-FDA: 85360903824.13.8C53457
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C15920006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 11:19:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jH6xeLF4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792927191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kA7Lh0rTLJthclgKbavrfHWy6e7cc35uTBRlHHzRohY=;
	b=MIUjE49khnvqoUdlP328NDodJzk51J8pCnGHz9i9/vqkC3LaQ6Ecb3EEp/fM2ZERpoa+Ty
	eMzoSNu2k3uDSfIFfsO76B7lYb7m8ybOoWuyyDsEny8LXlu8T2qXMb8mXQDyKW3m2xlhgm
	c00Eei0dWJV1SqwBzGDJgh7v0eJVgO4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jH6xeLF4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792927191;
	b=cA7W4Ac8putEpF25t5Hq/+kzxscQtAAcvlsRmUbQ/cW6sstrioJR7/TdMn0eo9rvX1iE8y
	ictFZJgQ7kQSh5QPsQY+7Svb0+HpPBVfzmKZr4oqzEWxqCN9T31FQSkCvRFrTIzSgwDnPL
	ojDcErw6bcUQ1Y1PixBp3HhZsNk7FUw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kA7Lh0rTLJthclgKbavrfHWy6e7cc35uTBRlHHzRohY=; b=jH6xeLF43bYGfTDUhBy+5csoUm
	pd56xRlQzuo53SFq9BFZrYW+bYqPW6eXKGCTosXhPtYE6TGUIDDpHBn+JTGIlmIadOml0Q8U/IADK
	Vdr5vaD/kQPj6t+8DLcBIfERaIGCKCWSUnJzJRp3Aem2jiWaRP7Tmu0lCSAamCutj6njewt2DV++A
	i/xU/BoGFb7PPgxDged1WzrvijQkFMSZtbMZLfzvAz5KoWpdPNMcWQLEIHCaHog226iSBqfXV2Pyj
	AUmysX4U6Ak6Bzm0EaJXWbglxKTTT8WWF7Zk75UHKhRc7hD4eiPBcUZ0UQu67udXS0KKnNzEPgpnF
	lRBDVbxQ==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xKwGL-0000000AtoL-01t9;
	Sun, 25 Oct 2026 11:19:41 +0000
Date: Sun, 25 Oct 2026 11:19:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, linux-mm@kvack.org,
	"Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] mm/migrate: snapshot the source nid before the misplaced
 migration
Message-ID: <at3lzBRJzyzQX9vH@casper.infradead.org>
References: <20261023023226.29783-1-laoar.shao@gmail.com>
 <atrUeGPZgoSACpOR@casper.infradead.org>
 <DMCA1N4UNM7G.3JBXJHJE6CQ7V@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMCA1N4UNM7G.3JBXJHJE6CQ7V@nvidia.com>
X-Rspamd-Queue-Id: 0C15920006
X-Stat-Signature: e4wkon33qbbaayhtnn4aha5azi61f5w1
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792927189-680458
X-HE-Meta: U2FsdGVkX1/Ae98qlxT4HGEUrnnyuMhmB1Mh3lQwo4UnK16zWyWRAqc3G6wEfjzn71LQ1kYclmH+h8Mclvk2jkSqgG13xPxDHb9PXaHvzHjYFKL8Tjs9r1EbQchY7+8DUCHMUayirt6aZkYAugpQ7AAKKiyj+Ikv/U7mZgS1KRJ37eJAISkWOMu3m0XYWSMhnRNbwb0sIWqLG+T2JbOfIKo7/XUJRohtakwmWki2TbROrMNI9M3xPH7XJQ+kfOrR+G3HZdtxr7skuq0lFbJ9Y88cJ1poWPyNQlbUTk+3z2HoeygUPb7yBu6kz7Y3mtx6znReWEB3mxDKLdPLNHL8MNGEkIAyL+tmP77G1muvwS90Z8YaNvF7ll7gl+ownD51bTN0m/4WsGykdkhMzIxdVNhR9gmnb5oG/c1l4mMOBoa9Wu79HRbZQe+n9FlKrpA1cgZXMS/o5obH0n9Rp959K23BFQy/nM/ANi/jEhwXIiOVoWYNCVFSRBzE6dBgh9ah85TV869TvPBvuiq/A6nhnYIQAZ9QV6TG6O50iOHFpQzE4uyZXGwkdTjm/8pB39ZHlbkrpQuRHu1+SUS74d6p+yWJiIhF7OlN2GHiWxQx0l9eN+Vgw04W2SQKXagPHZFsCZ/HLS7MdaqyfaXMlY8unmuswwV4oAh4IfHujbMgUS9bnTBdPU8I8sFnMHiC5ViOE1y50vQTeVpeKS3ykOWa7X2rl/QHOhJ6zSJiBrT3CzabzEZZniaRpIcEj8iANrFMDEUmvxDsjPAOCQ1LeQi/iV3hi1/cg0Rh8ujsDxDgHVywdw7/Ph9GfrPV3H1t9rwxEcvnlJr5ZCrNY1jeWmm96/c04IGiXlqgNewz4TF1m6mWF+f+R6veC+4F25xmu1Axvr1gPHW8pMFvaMqv9Qo81OcvoqaZwMgaY9s67b/c1NuzsFbIENOJ8gAVAJEhCqhuLpyrpHsoEAJ/YJVP8n7
 Y5iJ7Qvm
 6r3eqjmQdH3hrcfwM1nBeLwTUx39a+5hBWv2ZLCYyy4iodWsbfJfKYbtAQKLuO1SHp6a3SAjwihSrFBXQggAX4N5tgG6keqENmbXDW4YnEKCXxoF/K8LcEUisiNq6eJKeXcU3OcR4ZVw28/vUlLoOO9kbMnXBlIaNunR/qKZ+B6+iLHLTvYrQo20WBp4ibWx8aDBmMLG0sywS78BibbtJ7kvsANOjn4CwW2PVHN3TN7Arg9EpyA+dJytM9rwaEyA7Jv5mmWwehSvnuGlMsajOkrI2P22ZNeX1pp7Kf7onHkgk1WM91WK+VokfGYqup7SHMuxkGWjZNee3ex1cS6sy9UCZxIug0T83ViNi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 10:11:34AM -0400, Zi Yan wrote:
> On Thu Oct 22, 2026 at 11:28 PM EDT, Matthew Wilcox wrote:
> > On Fri, Oct 23, 2026 at 10:32:26AM +0800, Yafang Shao wrote:
> >> A successful migration frees the source folio, so the folio_nid() read
> >> in the promotion counter update can pick up a reallocated page's nid.
> >> Snapshot the nid before the migration, next to the memcg snapshot the
> >> function already takes.
> >
> > I don't understand how a node ID can change even after the folio has
> > been freed.  I don't think this patch is wrong, but I don't think
> 
> I agree with you in the current code base.
> 
> > there's actually a bug here that's being fixed.
> 
> Strictly speaking, it can be seen as a benign UAF. It works, because
> 
> 1. folio->flags happens to be the same as page->flags,
> 2. folio/page nid is stored in the ->flags and never changed.
> 
> In memdesc world, after a folio is freed, I assume folio->flags would be
> zeroed since struct folio is freed and calling folio_nid() on a freed
> folio would give a bogus result (yeah, it can be mitigated by not
> zeroing node field and each node has its own struct folio pool, but that
> makes folio_nid() implementation dependent).

Oh, once struct folio is separately allocated, it's a UAF.  It could be
recycled to a different NID or maybe the slab containing the folio could
be freed (assuming we're not holding the RCU read lock at this point in
migration, and I don't see why we would be).

With a better commit message, I have no objection to this patch.

