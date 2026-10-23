Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E22606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOy3ZWYR
Received: by kanga.kvack.org (Postfix)
	id 134FD6B0B74; Fri, 23 Oct 2026 10:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D5C6B0B76; Fri, 23 Oct 2026 10:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0498F6B0B77; Fri, 23 Oct 2026 10:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D965D6B0B74
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:12:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2317912042B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:12:11 +0000 (UTC)
X-FDA: 85354080462.23.52FF6D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 86D7D120007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:12:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BOy3ZWYR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792764729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIhIHAuUJsyJ2bLrJWbRfcrJhHgsjoA+0BiCek5rlmE=;
	b=k3nVO9FMaeaxqRd46pJnZolsP62zMBSNQKgWq6vY5q4nRT6KFtsiFifcOaZAN9rSDCWHJ8
	SWVSUy1MikgKuwV18uoYf7u8q1dbQXYmWEP9+ZCOQ1PmeFq/oWzgMIEZN+FvzGIQGnR6Gu
	vSqMIaXD+3XYcwgg/I6UxnyqJprzGiQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BOy3ZWYR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792764729;
	b=sFqOlETtGswmeFEmjYF7AN2+t/PAAZeRtxHGg5kB2rIZhNupyu9PV68R5D52JbRD9sXXtT
	2gBfvYd+lEVHVWA4iXG4ZV1CBwwvV/onSkZyy9u0A+IM/VhEwtSfjDuZcZEtdgP5jzhDSj
	34p1DvZJa+1w9q7WmCWuGEW9x6Yd3uY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B21860142;
	Fri, 23 Oct 2026 14:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AB21F01825;
	Fri, 23 Oct 2026 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792764728;
	bh=cIhIHAuUJsyJ2bLrJWbRfcrJhHgsjoA+0BiCek5rlmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BOy3ZWYRjoveUK8W+po/jFDD8LEHrWegphHy+k3GAc2Tp0axnnLdExP1eTTEGh0Lh
	 MrH8vx1kjtCygjUfbn3TzevSKCul04wT+xi9OqT4tOKCkDeV8lK47HIc35kYuDgR+1
	 drrnZQj46R1o8M20sfl44ttj2UKZgs8tUUS3Yh9cg8ShLS4GJzmOq3I+tp6lC391p3
	 7VY8442ECb45QnMpkfKWKJUpc62mCty2ja2eOhekv1A84DyUGBuaP50zrVjz2zeZ0Y
	 wJ8GmKp+QXcc14ysTKGe/U/362HGnxMEE9zp/rtrGr3ITbSiS06hVLYQY7qIQNICXi
	 yFvHORASiS2zw==
Date: Fri, 23 Oct 2026 10:12:07 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v8 0/7] mm, iomap, NFSD: stop uncached writes reading
 back shared pages
Message-ID: <attrN9__XXJNSfuW@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
 <9b43a1aec170ee810ef5fd2a2ab1288bad6508fd.camel@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b43a1aec170ee810ef5fd2a2ab1288bad6508fd.camel@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86D7D120007
X-Stat-Signature: axhp6gbkfz58eg14mkzith51k5ckeqyx
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792764729-567188
X-HE-Meta: U2FsdGVkX18eopCPykoINm4nrf5/JWw/JT4BW3Yl0Dcw63LzQOcaUns2wRawuJvQl3KAsJGHxLELVHNZ15AaLEh1OMfzPpdlHdiMXWfeXW2TtvehCcWuyQjF8PMRk7Woub/UN6uYLA5lgx9a7QrQ2HeWBQjDQTptHnDywbUVrgiL8jAgZEb6W1fTCPXnXFAidDzhxBBxPZ2MpItRWXoY3VVXfpaLHVD4VX/9vUsutlobWqSPsCA3FtP/dzFl9sbnGh1bXp0znAwKTX9mL71d8Qtt690MIZ2+kGjWzYVNCKJC6DBCnYb9VJjUTdHXThSXVma3xWkbV0TAF1u6hpuYrhhMLx7s4N4uzpMaScl4LvDw+jX7NA/NoNoCUsNY1sAYl98HnWH+JI7iU+pEBIJgZp/e9stMC4a69TCE0ai3APxyUmrXKG2NEglcn2XJiJhLH4aWYHpGZdnO9/YCO30haGutOdxB+590wXAM9CkdlmkXBaG2Ce5Y79WJVeCzxe7pldTt0u3DTz9EUJZ1jF2ElN2JgE1pbX65msbRZD0qrqg4KMlEh5MB3uDt7edWiySb0G8RZ3dAPiyubCDv3M68B65A1IqtAi36W5AeOdHCw9VLKK447xg0aHJbguQ7OTJakMQmPB+/7uLvBgEJ69uRzxvackiL+q7wt0ZdSm755Tb0LW5cQQrD2Vsu4yNNLfdSiAKYz2l4Q/2/faZFbza8eYBoezpxFz9ku69JU1nr/CLUJb3zNg8seSCqY6unECh2kohQSU/+NccqF+ZlZpSxPrqSez2arpciW2IH6+OwzaIA8arPvp/xjLlNu1SflBdrHQ1VhlBrrpVPqTffyZqwUxAU+lvHTrCn6N6DF5XY3q/hFGKeVji78RTKfOYeu6apH324VRbbWVo6X+lUQ0aTbzeSeGuKHgNNWBgbUMyDLYR3OCNmBQwaEtPzHkuX8kVhSvATD4sY3Neb5hgtqA7
 3X0CM9N2
 aXH/PJeuxDLd3/0xkPsfbtrJdQBqDio4uOVUsuHwJ1OwmP0hRA+8SdDFNdQ/0/68XSz8gCqODeg3g/+aKRozGwJJgjklQKG4BWdANYdoDP2oxWTkTPwe6CIL56/o1iTdGhammgTni8tYUPPL6UxFit+1E+UV7HN384rV1GIMCmuYys8HZ2cwjszROZN41lCeuhV3b8xxHlc2FekczPm46Mhy+VSNiLgHXmeZ3AwnE428ty2ZNnZg3ft0XkZISMOXLA7b/+KT1/3DQKnKOdQNdIh32Ckg79ChWh861Mr5revyCt4UzmYUpvTAb9+x5dctmEPNZquHLB6AuVYYJJc27X9Q20nDeR3qxVyeG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 06:57:09AM -0400, Jeff Layton wrote:
> 
> It might not hurt to have your LLM simplify the patch descriptions
> here. I find that my appetite for reading claude-ish walls of text has
> waned in recent weeks. This skill helps a lot:
> 
>     https://github.com/danyuchn/asd-ste100-skill

Thanks, I've now trained my claude monkey with it. But I'm sure it'll
still throw feces periodically.

Also, I've reviewed the sashiko review of this v8, that you kindly
forwarded this morning, and 3 of the 7 issues it flagged were real.

I don't want to spam the lists more than I already have by immediately
posting v9... but it has needed changes, blech.  I'll at least wait to
see if Chuck picks up 1/7 to fold into the commit it fixes which is
already staged in cel/nfsd-testing (and if so I'll move Chuck and Jeff
to cc and upgrade -mm and -fsdevel to the To: for v9's posting...)

But here is the changelog for pending v9, in case it helps reviewers
side-step reporting something in v8 that is already addressed in v9:

Changes since v8, from the sashiko findings Jeff Layton relayed:
- 2/7 and 4/7: a folio is counted in WB_DONTCACHE_DIRTY only when both
  PG_dirty and its dirty tag are set.  v8 tested the tag alone.
  __folio_cancel_dirty() clears PG_dirty but leaves the tag, so a
  cancelled folio that stays cached kept a stale tag.  2/7 then
  uncounted such a folio twice, and 4/7 counted it and never uncounted
  it.
- 7/7: NFSD finds the edges a buffered segment shares by the mapping's
  smallest folio, as iomap does, not by page.  On 16 KiB blocks, a WRITE
  written as one buffered segment can have page-aligned ends inside a
  block.  Nothing completed those edges, and the folios stayed cached
  until reclaim.  NFSD also completes a segment's first edge only when
  the write reached the end of the segment's bytes in that unit.  A
  short write that stopped inside the unit had not written its part.
- 1/7 and 5/7: a paragraph each on a limit the review raised.  1/7
  cannot keep a larger cached folio, left by readahead, from spanning
  the cut.  5/7 marks the folio before iomap validates the iomap.  A
  stale iomap stopped by a fatal signal then leaves a mark on a folio
  this write did not complete.  Both cost one read-back and no data.
- 3/7 and 6/7: unchanged.

Longer form for the fixes that fell out from the v8 sashiko review:

2/7, the stale dirty tag: real.  __folio_cancel_dirty() uncounts a
dropbehind folio and clears PG_dirty, but leaves PAGECACHE_TAG_DIRTY
set.  Only writeback and truncation clear the tag, and writeback skips
a clean folio.  So a cancelled folio that stays cached keeps a stale
tag, and my clear path uncounted it a second time.  The same stale tag
made folio_mark_dropbehind() in 4/7 count a clean folio that nothing
would uncount.  v9 tests PG_dirty as well as the tag in both places.
A folio is counted only when both are set.  The race the tag closes
stays closed.  A dirtier that has set PG_dirty but not yet counted the
folio has not set the tag either.

7/7, the PAGE_SIZE edge tests: real.  On 16 KiB blocks, a WRITE written
as one buffered segment can have page-aligned ends inside a block.
iomap left those edges for NFSD to complete, and NFSD never asked about
them.  Those folios stayed cached until reclaim.  v9 finds the edges by the
mapping's smallest folio, as iomap does.  Measured on the loop device,
whose dma_alignment of 511 makes every TCP payload memory-misaligned.
NFSD then writes each WRITE as one buffered segment.  32 writers of
12288-byte records: v8 left all 32,736 pages of a 128 MiB file
resident.  v9 leaves 1,348 of 262,080 pages of a 1 GiB file, 0.5%.

7/7, the short write that completes the first edge: real, and the cost
is one read-back on the retry.  v9 completes the first edge only when
the write reached the end of the segment's bytes in that unit.

