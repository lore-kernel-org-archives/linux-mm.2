Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF05ACD343F
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 08:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D544B6B0306; Sat,  9 May 2026 04:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B796B0307; Sat,  9 May 2026 04:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41866B0308; Sat,  9 May 2026 04:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2FB76B0306
	for <linux-mm@kvack.org>; Sat,  9 May 2026 04:31:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48FB314054A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:31:21 +0000 (UTC)
X-FDA: 84747211962.20.DA7845D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id AEA3316000C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:31:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OCpf21JB;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778315479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIA1R/XeFaOasUgHQYgPPMo0X7HiP0qBj2jv2ULT8R4=;
	b=1fufWHH9Wsnm7Hk9FA35lh7HiCp7qf07ZJce0wre2vmAvvtmsraHTUHAhjtGSVRBUvr2zw
	MGZ221yHtYACh4w0QjlH2QIeIyQ9XVxFnfJfdnqi3Tz5gGvwE8LlbqYXLHKqbMUgc/qeEe
	r53iLCOjopj/n83xOZ4gkasEFNV+JKk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OCpf21JB;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778315479; a=rsa-sha256;
	cv=none;
	b=VdfT9gyGUvI6YIEa2ezCFLlj8NFbZ2KDM9BTpMqgEcTTOcHSO+BR9mXS4ZtxB2mTy/8xXC
	tXP3ChgmVKkrDR9HOhW392y0CoqrNLJ7WQ43qI4zAmWW89HbaWIijewBZysaD4Fe0Tkot6
	W5qvM1ZB4c6EivJSzV1W42d/74CLZac=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bIA1R/XeFaOasUgHQYgPPMo0X7HiP0qBj2jv2ULT8R4=; b=OCpf21JBfcT3gG1rqLHiLJG0YK
	pm2+y6nwqUMOpyitmNkmEb0LSS3u+YoL6IPtEQfDVcc15nDBd5uxt12VKxJSVAp4EfGvEDUpEsHHu
	DhbOMHYDrl9nqMDUPXrh8IoCVn/lj1nD7IjLGdbcdc1MFYEQLRgS4DcTRjij8pcvcHgAkaHypXCXW
	qEENndE3dkHSM9Gpxh9k+6HWwTjxOuaz99KE2Tmom2iAZc4+p3fs1rt1F+LQO6cAirObyRdVi6C4g
	RlUBGeXNgD+g5YZlrhDf7URE/iOSG3YOmQw3XZ9bZ90fuSzhYrAspA7cZmnp0evA9s5hpMEK6fz6b
	rw4VPAyw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLd5d-00000005NCx-2HCc;
	Sat, 09 May 2026 08:31:13 +0000
Date: Sat, 9 May 2026 09:31:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] maple_tree: document that "last" in mtree_insert_range()
 is inclusive
Message-ID: <af7w0Zly7Se5my_c@casper.infradead.org>
References: <d5qyczrzz7yzxpveshdbm2u3fl7p3db73iczjydbm5aghkjkno@t5jf4hgkzpqk>
 <20260509005947.84550-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260509005947.84550-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEA3316000C
X-Stat-Signature: 476xip6zfdtj1qsdrpmqh76q6h6te3oc
X-HE-Tag: 1778315478-862756
X-HE-Meta: U2FsdGVkX1/o4WILhJJFdU/GcxXfbu/X7M4BFbvTfDWMCcNOtvj6jymV/sRcr1+e5NXMD3vUutvm/G06Flc+rHbmQZe8IlH8OOOKbR4Jhb+oEd5Ka61x4qr7wvveHZjls2Jm7l4Y4N39dhf4jyZaZ+ab1yl5Rc/0lnAlZ28Nbhs+kSW8x5KfYNCEd2zhtwUR1oTBwAm4NuBRI8D/nEYFFGdWUVQI+h8P+yKIO4eLf+0m2Cd7eVlRA+6AOj3tXx3J9MxmJcNFSM7cPYIXqJsHB0Pj4KsDqkKH+xL+SZrwFVrPQ7KzHFR6awgWsFmsHNvB3hhnUBpm3MhNeG0jd/zTDOpDpgezgucDwjsUBilKEh/530oRMR2rjXutA1SXbnhJc/RHAz0jRgfK6KzPk3A68zhMKziKM3+7o7OOGZzHRY2XkZGwDZPNeilM6u4KJkdkvKFH7+0MAScQUJVRFGyQd0eJJPvW5nSHFRV0hrsbgFlcPb+Bj2mYRGxFGRCNpErYQ8exj/Vjk/75vy7J7aUfWirPL0SANAACkhKLjbrqMPtROpNA4DMy8lxb5Emqyoqu3UnN5b16w6So/JwuB40Nhn+PPJNRvVwEc4mOyGSQQzaYZFM/ZKYMtQ1sb+fmTOzo17Ddizr0m9+MoIFqOGB3NBRmD30CVNTfAJwWH1r5VJLlJHkj5YdAmYmfD1h5wVioJIHdunsvJfGHf1xd7Ktgi7oIyo8T+k1zTefp9hnkGkwwhzRVbEseOE68MlCkd9OZGIh4G+zpih/aJJaGedY3KdqUYw4UBtaHDEvgVqCQ+MXUOgYfF5CLj5jhcP+F2F+WWZ2JWhlTiMhdb0UZ4PFRpJZVNH/MNMHV3I0wK3umo2n45M08Gs7wcBNOBGrY/I9JYmeEL5YsWJG+3jDMKV+s5nzBSJuj7j4WNJpRKP+JboPFDdgrgvEjrlBkf6mgdoi8dG0sXz2fYBSfvioy+tB
 W4+068N/
 DSrnTlrJWTfn6TmrGf9I+SRvtYgYfqtvorDjj+gU3ZLYG7tNn5zlnNqrMii+r4Mz9sPDIZVKDRebEZj3ANNrz+Mnu7X6hvTq4zTKGEvNB9Yuk8aTyXu1luW7z/IUULNAwhPERs8Jtyl+Zv6cIqM3J2FWsxgvH2Ld8ne4iIP8ukzgffjOkHYVXGOFAnR/44EFuQlyiUdM5K1l0ufcCCJJiLKm/Y3PZSu7p30DlMLvnkWi3IEmLbkz5xtCcCZtF/9bZRdJMuMBS+YlCszpqcDXiYOlHatHRu+YdLpN3eBEyX57uOTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 05:59:46PM -0700, SeongJae Park wrote:
> > > * @first: The start of the range
> > > * @last: The end of the range (inclusive)
> > 
> > 
> > I like this.
> 
> +1.  I'm also wondering if it make sense to add '(inclusive)' for 'first', too.

I can't think of a situation in computing where we use an
exclusive-first.  Pure mathematics, yes, we might want to express a
range as (1,2) to exclude both 1 and 2 but include 1+epsilon for all
epsilon > 0.  Maybe I don't work with floating point numbers enough,
but I've never seen a kernel programmer make an off-by-one with the
start of a range.  End-of-the-range is all too common.


