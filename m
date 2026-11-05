Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40335606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 22:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TgHZ7LH2
Received: by kanga.kvack.org (Postfix)
	id E67BB6B05B2; Thu,  5 Nov 2026 17:58:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3D6C6B05B3; Thu,  5 Nov 2026 17:58:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A786B05B4; Thu,  5 Nov 2026 17:58:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE9306B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:58:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9EB391A0A31
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:58:37 +0000 (UTC)
X-FDA: 85402581474.03.C7944D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EAC7A100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:58:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TgHZ7LH2;
	spf=pass (imf05.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793919516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+nYe4I8JfGZ8iq7Bvfptw+3SVmUNoB+MIDzTrsXpZc=;
	b=w5yZBihX7jaEI01z28vdButIaotZ8WVApcNh7cLpE6HecKb8x+Dg+RQsQ/aqhmJWQkHnvI
	ZwKSk43x+BQlJ6SPdkTFktmI4xqpmY70I5OhIAzoTN/Gutic9osqmYwtyp2RHAYMDI0jcU
	mJDJkfLwLzDqMau0iZ27Z7zPolE9chI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793919516;
	b=0AfnNNGyz4hvfFuFRySToOGI0ivaA8wli9YBIOluOo9Ucr5/F/i2dT3LjEkVydku8UBE+6
	FHOKApKR3Im0Mpnql119gJk0QPg2pnK301xzF3Qro6h/KVoVuhY8484hsNoYm3OGnzAkWt
	xwsqNTPr79QL+E68w7d2IhIc9vCKJV8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TgHZ7LH2;
	spf=pass (imf05.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EA1640F0B;
	Thu,  5 Nov 2026 22:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D243F1F0089F;
	Thu,  5 Nov 2026 22:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793918975;
	bh=S+nYe4I8JfGZ8iq7Bvfptw+3SVmUNoB+MIDzTrsXpZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TgHZ7LH2yAs2qyGTAyNNtl8frCxxpwAJZEf6PU2DcWnxnWy8Gwr2rY4WWscjskyEm
	 piib1sPyrp16ZX0SGTmaIsDb7pvL5paKi/uBo8avrLOrUUi1aOj/A7Z5bjfMQBMSjN
	 j4Eq9xsHFuM2pB920goI6zViijasUSIFu7KXGqFRJvCPeVMdAzEHY6fyhJDfuKuq+E
	 J58K9DIZLC3V7zC732nScfU/zhzvvw1oMRaZTKz8cZFFqEXg9rdDKXASjqjxeSqrtZ
	 ELHH8o3eXZWSf+wF68UCbIny6kkYndjaeDR7pwKDeuguD1MRYu20E2srlmlgMetBGp
	 cv4tnszSs4FrQ==
Date: Thu, 5 Nov 2026 17:49:33 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: Re: [PATCH v10 7/7] NFSD: drop a shared boundary page only once both
 WRITEs have written it
Message-ID: <au0H_TZCp1Snf_5U@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
 <20261103211754.35352-8-snitzer@kernel.org>
 <20261104091543.GA31130@lst.de>
 <autk-osSQ8l2LKz1@kernel.org>
 <20261105075935.GA18069@lst.de>
 <29851456-2e7c-48a7-bf00-11a1f1a35024@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29851456-2e7c-48a7-bf00-11a1f1a35024@app.fastmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EAC7A100005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: azzmf371xwwrdordyejwk7weqhxey95m
X-Rspam-User: 
X-HE-Tag: 1793919515-982520
X-HE-Meta: U2FsdGVkX180qwQUg6cZxS+9p/daufCfNSYskyyaZeJLz4BxYx5npa1eZsQwo0MMc8JIOD9iak0aOLwPGgxRgtaA5hsgRWj8mw/L2UBEc4rO0OUSjLiimLpqYmZZPCpX49g7Spjb+mk50zTvgOKNxM0cgcHWSe4DcIBbKPXnGmadJwDMRbv9GFgBZjWZUV79IGi+K2IChl7K2DOT3FG+ZJKnpudE9xhEN017gSHVymq8ZfVtOtCLX0biHog61k92mT5dVnaFWrgTQyy6REWDOqp2zr/kgsJWPIP3TJC3LBbVQe8kiqwGvLE/jPRGiCkPBf76apqhfOIY4+redkgd9w9nR2VFuWzRK7RRbxmbOF5Y1YlAmtPyqb7ysEWzGKcoXJ5T1G/5btITFrDQEGNae138gecumpieLLDslnzdo9EJpP/X44BXPiq1Gcq+d9yYlea92grSCQ88kP9bh/v2naYSll/b/5oMg+oez8cp+07rZXY7DdsEvJMx0mTjhJbLqhNhT70kmf4PUxg25/LQrR/Z1EZVsXd4FK97MmQJbuJvhIxPUGDX6OXuKEIaLVT/jZhZzluWuLwZ0q6H9Gg0WSx/8MbIzBukP3dxUVv8q0yQBlj6TZcOhjy/qstgDHFQu9J2O+OixZ1t12GtVKDGaSbU070e90Ffwj1MYgc4TvVNa60UwIGcWEUFCVtPi/GITZyK5BIIZTEalCpltaq81Ty6T2oSIfYdk6ymmrE6CDH1fjYz8oKMZeVKbGjmOE/211q0Tb7WDrffRqX1wJAjfCFEbvg4fBW0rab0ZKE2HzwvuM8TkuMbgG34omNh8YowdFe/ppOFPtqq1p1s6IdaRR+w59BOvq8gF6Z3tWdJdXkWpTkHq4IQ/XPuTRiyjofX78lxcZUx4cMT9QI9jkJAABBvDRvpi9YpilA1aQ669ErmASH0CTPrzk7QNVonNQM5TC6B7DhwooVEu8hB8p8
 UX+onp3x
 y5/9NJ/cs+EMcrQY6DZCA0nLlXwxGcWr7IM/4vH2ciFXKT0zdT7L8ewmEiofl/BXRDsxCAzCaNAOwgZPUePnuqs28Upev4ahfchn37VSD7vAne3J5ItdUZUMMnE1BRSUBVrS1KrMtRRuClbEcfWmQ+XLboHETLQAeqJ0auRSLSPlOfG9oVJ5aBwBAVNTFrxNqI3NxVmTc7Gkqb+ESDFcSRIXYkVm/+deFGq5UDHP/F9eepxVfPFiEdUAx+K5o48cMVmX5QQjMwS5bjq2FN1I2narDLCfSbJc2WgjFUQ4Q17bKBDDJmpbZZPZJHw5YS/Ps8Cf0Op2ukJWNGawEnIU3pNbMp45930XDkjVd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 08:33:34AM -0500, Chuck Lever wrote:
> 
> 
> On Thu, Nov 5, 2026, at 2:59 AM, Christoph Hellwig wrote:
> > On Wed, Nov 04, 2026 at 12:01:46PM -0500, Mike Snitzer wrote:
> >> It is the transfer size of IO500's ior-hard: every rank writes
> >> 47008-byte records, interleaved with the other ranks, into one shared
> >> file, with O_DIRECT.  It is meant as a hard case, and it is the
> >> workload that showed the problem on our servers.  The same happens
> >> with any record size that is not a multiple of the page size.  The
> >> cover letter also has 6000-byte records.
> >
> > So based on a bit googling your totally optimize this for an intentionally
> > stupid benchmarking workload.  And that's not been disclosed anywhere.

Why we're even debating this, like "IO500" is taboo or something, is
what's stupid.  Not a surprise: handling misaligned IO is "hard".

Public service announcement: Don't let Christoph taint others' work
with trivialities and needlessly hostile strawman arguments.

For would-be MM reviewers (and you too Jens), my previous reply to
Christoph in this thread [0] delivered a lot of useful context that
made this patchset instantly approachable and yet rather than
acknowledge that fact he attacked a misaligned IO benchmark as
irrelevant.
[0]: https://lore.kernel.org/linux-nfs/autk-osSQ8l2LKz1@kernel.org/

But anyone who is active in HPC filesystems development _knows_ that
"47008 bytes" is IOR-hard (part of IO500's benchmark suite).  And yes,
its aptly named as a "hard" workload to handle efficiently.

I have named "47008 bytes" and "IOR-hard" and "IO500" _to_ Christoph
and others multiple times before:
11 Jun 2025 https://lore.kernel.org/linux-nfs/aEl1RhqybSCAzv3H@kernel.org/
12 Jun 2025 https://lore.kernel.org/linux-nfs/aEs6gmTXzhzuDZOI@kernel.org/
29 Oct 2025 https://lore.kernel.org/linux-nfs/aQJG2LIuui08Bx3H@kernel.org/

Even in the context of this MM DONTCACHE patchset (now on v10)
Christoph's "not been disclosed anywhere" doesn't hold. IOR-hard was
named, with its 47008-byte record, on 22 October in a v7 reply he was
copied on, two weeks before v10:
https://lore.kernel.org/linux-nfs/atqCTLf42kkGZmSd@kernel.org/
But it was only in replies, never in a cover letter or commit message.

> > I guess everyone else was right and just ignored this bordline malicious
> > submission.
>
> It's not fair to ascribe that kind of intent. I think it's fairly
> well known that Mike and Jon are using IO500, and not mentioning it
> in the documentation for this series was a simple oversight.

Thanks Chuck.  If there is a need for v11 I will explicitly mention
IO500's ior-hard benchmark's use of misaligned IO of 47008 bytes.

Jeff Layton reviewed and provided his Reviewed-by.

I suspect MM engineers have just been busy with the merge window.
Hopefully Willy and/or Jens will give v10 the courtesy of fair review?

But as I mentioned in [0] any misaligned IO has this issue:
"The same happens with any record size that is not a multiple of the
page size.  The cover letter also has 6000-byte records."

> But IMO we do need a broader variety of benchmark results to
> understand the impact of these changes. IO500 on big hardware is
> an uncommon workload for NFSD.

IO500's IOR-hard reflects worst case, I understand the reluctance to
care about it BUT the reality is that not all IO is sized optimally.
So if steps can be taken to avoid pathological inefficiency during
worst case (misaligned IO) _without_ hurting the fast path (when IO is
sized properly) then why not take them?

This patchset doesn't hurt fast path at all.  But happy to take
direction for benchmarks others would like to see results for.

Mike

