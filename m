Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9E5606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4vULWk7
Received: by kanga.kvack.org (Postfix)
	id 341526B05D5; Tue, 10 Nov 2026 19:26:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319A96B05D6; Tue, 10 Nov 2026 19:26:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258BC6B05D7; Tue, 10 Nov 2026 19:26:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEF6B6B05D5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:26:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DD731C23C1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:26:08 +0000 (UTC)
X-FDA: 85420946016.13.C22288C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 062B9120008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:26:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4vULWk7;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x80Jur2dVbfsH8vBU7Ebsz2GwukQ6rj58JAuvqMVqv8=;
	b=YPRThIfsa/z+i52ckdUPXdI0aTzx1t7FrW9HEUT7pwv7s6DNkOYGCM8PO/6Eq0Fpbw4o0x
	y/kpBugQGVRpgbGKkn9PFGCBxGo8tA6sali61lCmhXGbY3/KLfchAfjsUp4j2db6SODY6E
	G+H0GojmjB/JZ55NuDz6zKVHrokJHzA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356767;
	b=b9hDb3w6qVzXBlxPDlkqi3bgBRcIKMww86Io5ES/T2zqIh1eyLkV+QVQgySTGociqF9RJ4
	8iWuuej9wdSggrvfUaUrNFfW/EDVQ8cvDQjhI6bTxfa0bhY7DVvZn2/aP6NqBq7+fPWlI1
	d5d1+VrayQt/7Pn8Cwv0XvXYd96RFX4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4vULWk7;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15F2760615;
	Wed, 11 Nov 2026 00:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D40E1F0089F;
	Wed, 11 Nov 2026 00:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794356765;
	bh=x80Jur2dVbfsH8vBU7Ebsz2GwukQ6rj58JAuvqMVqv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P4vULWk7Lz3JxWoQ1fFiZ1BhFF6mP3QT8MUkw0nM1uczi2dCWxzwTj2/3jymz8p1p
	 WkU4wHtcNekWZctiFGEwKCWtRaf2gf4zmkF2KtMeiGjvKTlp0fHztgrDb+UHAgtyEM
	 r+68HkuvbDNZb0WK/EMleuT9LsEO2jaMGfns2vx0CVBBvhgnkT4Lxpg2kFWieUKuPA
	 9x5WccVA1+oUhvF9GGaXM/xclcu8uBRMaMrf8F22f7F2YjbZH7vKHFRLYDsb9jeWSB
	 feB66WMI12AvuO+ctXjGtq2FFS8NHRPKneG0GhXjrHn1ddE0aABWamvGuQYlP8evjl
	 1oJGe+gP4rwOQ==
Date: Tue, 10 Nov 2026 19:26:04 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v10 0/7] mm, iomap, NFSD: stop uncached writes reading
 back shared pages
Message-ID: <avO2HG8_m4v-NYYM@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
 <20261104091740.GB31130@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104091740.GB31130@lst.de>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ijm6pa8ej7d5mxfw9c4455p4rh8w6y5x
X-Rspamd-Queue-Id: 062B9120008
X-Rspam-User: 
X-HE-Tag: 1794356766-536190
X-HE-Meta: U2FsdGVkX1/RjaCqo07Gk75KmBN779iGuGhzACka209KUthe0AYCZP+w9z/y4gp/zyfoY5r99q+YamYnX/wV6If0weg7p76pvg7MZc2F9gC1mEz92ooIMsHlT/Fw4w6D5b9g397nEIxofYUEHs+7Fmw9LBzAhzu+BEs/hlU/7ZNcYytXOvAfTOBfE1cUIrNxzs5HmUZidxqjkKaNOBJd7jKy8y1GGaeVsFTiHgNtazermtSUM8z5DnkQcjRWE18Yw0tdXQLdT98bb4p50Mgxb1eGTRDLqEsOKNHFWh/ZUCLEGULvyNO3g0jI6XPF/+z0jGvwYq2NCyT4CH4W3BgxiwfXRH+RhPFQvPpyjgXWTJyFM1+tamt5intK6K6Pf7fAz6uZ+Ouq0G2Vsj3GaDCDK2i4GABKpBIMZOe+o2KFLrQ9wj5kPjYDq2OnKSzX48RlNSnl7vKwbFJAv6ZJHp9i2AIxuFHzAie0m581QePPI1moGk+FWWXJP4E4Hra3e4CKK47m+GTA1IUSnf+EiTPe2ulG2B1rOwMsYQgCTI/FAihJu35rXzB220Sk85lJyAIiq5OKgfSZoAhrLexg555kxn82SHk/gQVw2ebsA7a1u2nBmgitl5KlCec5efPUk/Y7WdX6hItZtHNmHJJ9t4CHzqkaxxnBdLDFA1gz3Qon/mnj7r1W5ym7r74LJrPeoTYmMAddagEK4nfJZUrkl+hmq0D9isva55J1/3K96Az82+w//HVhFq0jcxxEsFjYZEuCeAKXPPN9jq4xblfP0839ppWRMu3DHoufeEjeRslEEjauI4P2NGNToqWcES13qA5qdBfoj2lAloIyl5AmUZsodTQZsf7EluHNRGH8/9LWPLq4FcO2zF3r8WmGJg3OIMwGCm4yXjvhb1Fh0y+UxOG69LZuKMDc27A1MblJiDXGybDD5yw5ZDBj4mJb1pwhxYNgIN8Am+yRB/lLNagQwSf
 jk0kQyu6
 RnM6JJNZpTWVwPBRuS/mvYk8RLk+v0a7VEBPvwNe+zoz4OhHziiP8eqCpbzh2iERjD4BM4IuBs25bgoOW4pU+NTwNsol7rCB1NSUnBP1ytfdfsvqyioYJDXm0UtfP2ETJZKLqwWPJw8sk/jXixAOWMel473JxyujMQ+1XJy5tVwYEJPDrUxH+hXT5geKF5+gpx/gGerJuCs8Piof3zEVvXtL1IBXV/iN48brWDwsJYec1X+1s4XYGuEumNmJHfKAOh5j3hg/D49fSjZOyqhqYHrrSqt5mJMc5yc/fyDFo8D52ufY9VkoKs5qDXPT+PIAwwH6lRR0LxqqtPyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[against my better judgement I'm replying, hoping technical discussion
wins out.. usually does]

On Wed, Nov 04, 2026 at 10:17:40AM +0100, Christoph Hellwig wrote:
> On Tue, Nov 03, 2026 at 04:17:47PM -0500, Mike Snitzer wrote:
> > Hi,
> > 
> > An uncached (RWF_DONTCACHE) buffered write drops each folio it writes
> > once the folio is written back.  A folio that the write covers only
> > partly is shared with the neighbouring write.  If it is dropped before
> > the neighbour writes its part, the neighbour reads it back from disk
> > first.  32 threads writing interleaved records to one XFS file, 4 KiB
> > pages, before and after 5/7:
> 
> Very colourful terminology here.  Who is "the neighbour".  How do we
> know a "neighbour" exists and what it wants to do?

"the neighbour" was meant to convey the other write that covers the
rest of a page that another write covers only partly.  For example,
with 4 KiB pages, a write of bytes 0 to 5999 covers bytes 4096 to 5999
of the second page.  A write that starts at byte 6000 covers the rest
of that page.

We do not know that such a write will come, and patch 5/7 does not
assume it.  5/7 looks only at the state of the page:

- If the page is not uptodate, it is not fully written.  5/7 does not
  mark it dropbehind.  It stays in the page cache, like a page from a
  normal buffered write, until a write completes it or reclaim drops
  it.
- If the page is uptodate, it already holds the other part, and this
  write completes it.  5/7 marks it dropbehind, and the writeback that
  cleans it drops it.

So if no other write comes, at most the first and last page of each
write stay cached.  If one comes, writeback drops the page after both
writes, and the second write does not read it from disk.

> In general if the user gave a very clear indication that the data
> should not be cached, it is a bit awkward to second [g]uess that.

RWF_DONTCACHE does not keep data out of the page cache.  It is buffered
IO, so all of the data goes through the page cache.  The flag only asks
the kernel to drop the pages after writeback: "buffered IO that drops
the cache after reading or writing data" (include/uapi/linux/fs.h).  It
is also best effort today: an RWF_DONTCACHE write drops only the pages
that it creates, not the pages that it finds in the cache.

5/7 does not change whether the data goes through the page cache.  It
changes only when the kernel drops a partially written page.  Today the
kernel drops the page before another write might get to it.  That write
must then read the page back from disk into the page cache, to merge its
own bytes.  So the page cache does not hold less: it holds the same page
twice, with a disk read between.  In the cover letter test, that is 0.97
device reads per write, and 831 MiB/s instead of 2281 MiB/s.  The user
asked for less page cache use, not for a read-modify-write of each
misaligned write.

> Especially if the expectations are not very clearly documented.

The 5/7 commit message states it: "An edge whose neighbour never writes,
such as the last page of a file, stays cached until reclaim."  So the
only change to what the user sees is: an RWF_DONTCACHE write can leave
the first and last page of the write in the page cache, if no other
write completes them.  Writeback drops all other pages of the write,
as before.

Mike

ps. I'll reduce the "colourful terminology" in v11 (e.g. drop
"neighbour" jargon) and also address the 2 issues sashiko raised
against v10's 6/7.

