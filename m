Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA0E606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gPhJibQl
Received: by kanga.kvack.org (Postfix)
	id 12A266B09A2; Wed, 28 Oct 2026 01:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC2D6B09A3; Wed, 28 Oct 2026 01:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33416B09A4; Wed, 28 Oct 2026 01:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFA3B6B09A2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:12:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62C23160BEF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:12:58 +0000 (UTC)
X-FDA: 85370865636.06.F597933
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C92C514000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:12:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPhJibQl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793164376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHqc2iluLzBkHlrPz5vi8Qhq+QGWsc1OSshMmigJpRY=;
	b=Q89mxiZoBhlpNd5AduNYxfcClsxJa3afLQ3QV8B5hnYNh38pDhlhaX5XJEaO7LS6B1zhrF
	xZERYMAPsh5ixSBn6MrC2oYZzsC+zhopLJDpnQsJEsR6FPte2jvic0gxX95+Pdhw74iL1u
	8bDiNMULPNBX3nm/1M9Y1nKk+ganQ/k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPhJibQl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793164376;
	b=AeiNkqCGmdA65IHCA3M7u9kCo0fLQ9CBhWP9632ub3gO+HCTURmglI+vmC/xyDBw3Q4Mre
	ti+CdMU5/ZooEaxTtgAE0VYOcFp59GTFY+sR5G42RAUJ+FnC9zPHBZmqSBIre/dprLjE/a
	u/G0w7/acBGGZ/DMMzav2K6j0JRJJrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6123A60136;
	Wed, 28 Oct 2026 05:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045CD1F01829;
	Wed, 28 Oct 2026 05:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793164376;
	bh=NHqc2iluLzBkHlrPz5vi8Qhq+QGWsc1OSshMmigJpRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gPhJibQlhr66uy40ZULtu24Lm5U8ODdpfi+3/4UEoEqT/2XInnndDjW3NbMUyAgGe
	 oU9+2/D0FZnfr+0F7/GdT/dJ/XkvxfvGK09PiTiVAHzs5pgoGo0g+QwlEO/NEMJz0b
	 MqwO5uMj80ITxyZf/bx6m58zhOCu/zKVqw65+fkxHb9c5l4CbNbVKjYeML/st7hS62
	 MKBtWXPdswocV5FGa9dB77/o52Evz1Dr3um7H+T1T26w72FdJ/KtuoxoxsGhS5dOER
	 Z2n15c/bv+trMAU94e5JXXLwgoSrSe6C4B1jjaGVcZImVbxl25L1n6+Z0/RK3w0MrC
	 6RsVy91S7eUrA==
Date: Wed, 28 Oct 2026 01:12:55 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v9 0/6] mm, iomap, NFSD: stop uncached writes reading
 back shared pages
Message-ID: <auGEV03MkzR2W85B@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
 <fc2ea8d6f2cd9ae83d38941f90386aac6638a497.camel@kernel.org>
 <70ef3172-9631-4e19-9b8e-4722427a5a83@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70ef3172-9631-4e19-9b8e-4722427a5a83@app.fastmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C92C514000A
X-Stat-Signature: 5c8m41zp7noaiwfapycu1shig3hujj8x
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793164376-836083
X-HE-Meta: U2FsdGVkX19V1u1j//fEvJvadAiOC+wXt4Mx/ZDGq3dWHhd8gsNp8vunj6XnsIXRdqsrgDvlU209A5R+Y9YEw/UfmaonFzMABohqTQrIzFZWwRO48TuCpKA+Ttt5hvVM5Bn2vTfh9nV5o7x/WMQQCuxV3cVPUvBgGteebVld3x9y4lFwdYsfb/MHNymNx44dTUgUHDnbkCIll/q+ZAw+rfSRfnrn6DX4PrYoS4tTC5LXF0yDq6ycBVbddgDzm0aOtx8IgG6dvXAndq+thBRPaBYDqS5vN9djzbuCLVWimz131NrcIRnk1ByAEsnWc/4l1GmrcmQ6IqDSFVXape1rlFqC/ZpXyb/MQKrri2Cpz7ylG1H5N1WM4ef47IdG8Pz8z1anPbLTd9KEQ0J949w/gCFFJMA/e6C+FTJq1lbAU758xqzBL8x6K3HnMNUmYDWHjUX+36ZRq62qSUdWp5SCHlNWcySPwJEVfNQ1sNGYJjAiMROeV/Y7Qy68p5W9Bk/o2tX+5DL5emh5nM25wNl7Ktyn4rewD0LZwpYu5HLBOoVPQVEQtj25zZIgSvWm4w8ZyhAd90FZQav4XIz/QvTF5WjEBdBnvpxPbktSSJM2evy5mtGZn+ADQCdxHe1Kz1GcpKazpi3M2WHUzWDj6svBgzbA5s1FR9A6ssiyuKqN4TYivQpl9AT0A0+qA9I0RASAkWMGCVWa+mQ9kG+whYndWzmKkB/WDlRIswbDBqsTuJ1pMImIBSZuVBl205qQ1y07qeF6bP0CfW33DM+m1rQlxSxv+3jUtaNpK+B8nI2i7DwdwCxI3ENlZSEf33ouAiphAsK6LbapU0H/r2Jj4xU1k6IW4rD3juAu95iratuZzPkviJg+bCj2RRjOrNssc82w+TsJFvzT0p7OucKR5Ar0jXhp9UoZOXBDF2k3QI1WO7iwLj8L42IDJCiWIR/WCo+TIU0rXnX8IhaiJYQjLS+
 KeoCPRe7
 a+ynML7GAEIdRvGaTnYYrt1Wx37FZZ+ElvYaDoLYZFmEvkUiRSQkF9SpaBq5qUS4qhVpnB5G8gjzKGDqhorrDLmyen2Lm1gUgbjsDvGIbLq8s0GG+gv5kWgos51nvloo9fvc9sPrLzwf7llMBAD9p5qsdEnkLeI8u0bZbGFLVCVnK8h6J8p1jYwauDz3A+Zjrii+epUGwLYGR3Jgw2i7BwZH6q+EKz+VSbELkrmrP1fIl6YYDHPyb6gl40ovhRG2pEPmDcRPX1c3ni9ARDINQ6Cl5lxpyIPMUI6zwyhhSYld67HeimfNCeX+bXXhI6KDCFx3O+URgo70QMydX68uppnbBIhul+UbBGomk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 11:36:44AM -0400, Chuck Lever wrote:
> 
> 
> On Tue, Oct 27, 2026, at 10:31 AM, Jeff Layton wrote:
> > On Sat, 2026-10-24 at 18:11 -0400, Mike Snitzer wrote:
> >> Hi,
> >> 
> >> Please consider this v9 for the v7.5 development cycle, so that it can
> >> go upstream in the v7.5 merge window.
> >> 
> >> An uncached (RWF_DONTCACHE) buffered write drops each page it writes
> >> once that page is written back.  A page the write covers only partly is
> >> shared with the neighbouring write.  Once the first of the two is
> >> written back, the second reads the page back from disk before it writes
> >> its part.  32 threads wrote interleaved records to one file on
> >> XFS (emulated 4Kn NVMe, 4 KiB pages).  Before and after 4/6:
> >> 
> >>   record  pwritev2() flags          4 KiB device       MiB/s
> >>   bytes                             reads per write
> >>                                     before   after     before  after
> >>   47008   RWF_DONTCACHE             0.97     0.0005    831     2281
> >>   47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.0005    601     1227
> >>   6000    RWF_DONTCACHE             0.97     0.0001    121      488
> >>   6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.0002     90      206
> >> 
> >> What is left after is metadata.  49152-byte records cover only whole
> >> pages, and they read 0.0005 per write either way.  The test program and
> >> script that produced this table, and how to run them, are in:
> >> https://lore.kernel.org/linux-nfs/atqJBS8MlYfeUU-t@kernel.org/
> >> 
> >> 4/6 has the page cache keep such a page for the write that completes
> >> it.  5/6 lets a writer that syncs its own write complete those pages
> >> itself once the sync is done.  NFSD does that for a stable WRITE.  6/6
> >> is the NFSD change that uses it.  2/6 reports the DONTCACHE dirty count
> >> in the bdi debugfs stats.  3/6 adds folio_mark_dropbehind(), which 4/6
> >> and 5/6 use.

<snip>

> >
> > This all looks good to me at this point. This is a mixed mm and nfsd
> > set though. How do you envision this being merged?
> >
> > Reviewed-by: Jeff Layton <jlayton@kernel.org>

Thanks for the review Jeff

> My recommendation was take all of this through the MM tree, since
> the NFSD patch looks like the first consumer of the work, and it
> depends on how the MM API is changed during review.

Chuck, I agree, the mm changes would certainly do well to go through
the mm tree.  But the 6/6 NFSD patch that makes use of the preceding
mm dontcache interface changes requires 4 of the 6 prerequisite
changes to NFSD DIRECT that have have staged in cel/nfsd-testing.

So I think we might need a post-merge NFSD tree for 7.5 that applies
the 6/6 NFSD change ontop of the changes that would land through mm.

Willy, I would like to work with you (and others in mm if they are
interested), Jeff and Chuck between now and April 2027 to see these
changes accepted for the 7.5 merge window. And if that were to happen
I cannot wait to celebrate with all of you at LSF/MM in Portugal!

Thanks,
Mike

