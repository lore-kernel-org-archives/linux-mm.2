Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F888CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 17:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8D78E000C; Tue, 21 Oct 2025 13:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0358E0002; Tue, 21 Oct 2025 13:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED0A8E000C; Tue, 21 Oct 2025 13:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB428E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:02:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC9A759E51
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:02:21 +0000 (UTC)
X-FDA: 84022739682.25.DECDA6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2BED5C0013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:02:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rFZpdOFz;
	spf=pass (imf28.hostedemail.com: domain of mcgrof@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mcgrof@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761066140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EDI8pmGXhjNQHhksgqYd5fSTDkz0B1DbUEeaw8Lt80=;
	b=dZGkhZgqdYiPMmIem0+7iynpUqNRUsJvSGB5WCjrj+ZbB3q24J8puAyPT+LWxUOqPZa6aj
	8hBvrU0sNdtpb+KHpPKfZBIbdzJ9NMyGKVlaeF54lg84+3V2wKAMAIMr807Fnkur8Fzojx
	zyfme/vlDchDkVYAw1JAq0w4KtZ5s1o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rFZpdOFz;
	spf=pass (imf28.hostedemail.com: domain of mcgrof@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mcgrof@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761066140; a=rsa-sha256;
	cv=none;
	b=jPJM7jn64aQjJcIycJ/kdu/YOsJWIXRO+yUMuND9g353NQ+TlRH8pner6yXOmkFOedzb0U
	YRcUHp6GivymO1BKBqaJ+KegLv8980lh+jTt1n2TK/QMBumBKiA2rLepPX1T707JhtREHo
	hXSTWpYuvRZaxp00fGeTHkZv9ONEzGY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 659A562580;
	Tue, 21 Oct 2025 17:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AD6C4CEF1;
	Tue, 21 Oct 2025 17:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761066139;
	bh=iu0ee6tQWz7F3623BPsbyD2yb1AVcl3Gt5U8+FrbmwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rFZpdOFz9jzsZRE9vLqWl3Ln5iKvQfR4QtYtEMg+dsnTgczxpe+AsZcjAyd0Y8Zyq
	 se9VHHbyFK6YRc1tL5rQ+Co5e6RTsPRn8ylk+QfQrIoAYng3ZhtkHHJJFSWwcaIEtz
	 MZvy3lmwFs2DhlzjDObAlMkmQf2ansKd+DM6NQZJ5EC3Xya85lTQvpDrjL3hJ/fTiV
	 sD5vImOS83+nS/stwwPEUJra3WDFt2eUjMHaEY7xyMzrQuEwW9yYDuLtuMMzceVSRc
	 wVfkLIfX3HKaMbROR4bDGtUehwV9OrUz/cccLlvk1oD6XxEBe2hFs0wfBEFPN3tubX
	 r7vlMnqjtBj/A==
Date: Tue, 21 Oct 2025 10:02:17 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Pankaj Raghav <p.raghav@samsung.com>, Zorro Lang <zlang@redhat.com>,
	akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <aPe8merkg654_sVp@bombadil.infradead.org>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
 <20251015175726.GC6188@frogsfrogsfrogs>
 <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
 <aPFyqwdv1prLXw5I@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPFyqwdv1prLXw5I@dread.disaster.area>
X-Stat-Signature: jt1rhcyjmag7iko3h6j8grtke4bkrw6f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2BED5C0013
X-HE-Tag: 1761066140-787256
X-HE-Meta: U2FsdGVkX18AX+NW8anNPuJ4LwngclBSni3c5q4IN9hdyqTIKOGebu/2aIaiEzhdeLC6eTOjWdoM/KR5YmUtD6a4l4/+2OlU/4laX5NegWeAqbkUsxXqJjcBPhk/eHw6kAszPLPcBhZEw6M6cE9YvlAyF6KXMVhOwWE/5kEeOHrTemKoRYMQLP8dZSTHD7Si6zHEQctwFJsrt68f7INrE5E7zeGDHYdqkvVT9daqZL4+mFkuosWJviQJHTG0WzolL8TEBfgD0OTONq/XhHHX6p+E2f+TQg4hv7pVz31TpLAA9WlyS2IZXkBf2pF+3utbR9BNrI2qznlL3E3J2mzIKoAxWEizDegiPgkt2nWDVWQHCm71m0vreJ10Rg3D7VlhhAqRBdnOz1D7vJaaBMvo9wbB3uvSNf9XJeYP7PR3YU9YD1Dlbsetep2OVldaltB3Ror1xV6qdJn49C0XYrDzhAATaY0YLhDIJZbsHmX9s60madGJsvhX+GfQageNt+yTsuozmN9EAwxnfs3BlUoPQRX2tLn8UCEwwhrE2476sLGADjuXc1ObFga0lPNfwflJoezUGtjNnfc3PDUy9hWoPpGmX6CvteQjknDd6g3sLj/pLUlSQHLFIvY4fsjT+HuUUOD00pqnH75BBDwLHeN4W02xE7VdgQqlBa7ZFBZB6kdnXOfbl9Ci3fKYLKWlzFggMgVJtXHnMTb6sHF3ibCfKUsu100l7p/BBWSKQTlwT09bRyGRvZS0iUK8i9s07plZvBuxRUsc9QZKNLM3PoW/SeSO4mWc7VgAjPzb4V2mCCrUiCS95yOh2TaQvB8amKNGO/kLlQslURCCiqsCw/ut7+mjuLPGa8PbQ4gVe1fUF14zYbojt/Ok0QWpcXTTFfVhsN33ShlqPzhZ4VA24u/Nlmg+ckfgUrEZUNeT/zHFBysGe10hyqc5ddJvZbucv+9LQCb5CigWqjdbblFRrLV
 FAM6I1bO
 kTs7m4HtV5qA/vcw03x5Y8WzRqu22fWvylrgbR2IQ8vbldhd0n5fQZYrbjPUtjh+RRATFKWHYQiyVAKOfhqES30YaEyyJv7+AMn7YCCxLM5UAjOSlOjAvwsU/MIpYpm1iU3MUrlC2pkNgY4gv0wDI9UDB7PP6iNofOPpzS4He3C5xU27Svn55kQrJ5QrIWMPJZg5Y/w2ecYPdNXoUJrcahBEF1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 09:33:15AM +1100, Dave Chinner wrote:
> On Thu, Oct 16, 2025 at 11:22:00AM +0100, Kiryl Shutsemau wrote:
> > On Wed, Oct 15, 2025 at 10:57:26AM -0700, Darrick J. Wong wrote:
> > > On Wed, Oct 15, 2025 at 04:59:03PM +0100, Kiryl Shutsemau wrote:
> > > > On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> > > > > Hi there,
> > > > > 
> > > > > On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> > > > > with the following:
> > > > > 
> > > > > --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> > > > > +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> > > > > @@ -1,2 +1,10 @@
> > > > >  QA output created by 749
> > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > >  Silence is golden
> > > > > 
> > > > > This test creates small files of various sizes, maps the EOF block, and
> > > > > checks that you can read and write to the mmap'd page up to (but not
> > > > > beyond) the next page boundary.
> > > > > 
> > > > > For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> > > > > folio to cache the entire fsblock containing EOF.  If EOF is in the
> > > > > first 4096 bytes of that 8k fsblock, then it should be possible to do a
> > > > > mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> > > > > to the second 4096 bytes should produce a SIGBUS.
> > > > 
> > > > Does anybody actually relies on this behaviour (beyond xfstests)?
> > > 
> > > Beats me, but the mmap manpage says:
> > ...
> > > POSIX 2024 says:
> > ...
> > > From both I would surmise that it's a reasonable expectation that you
> > > can't map basepages beyond EOF and have page faults on those pages
> > > succeed.
> > 
> > <Added folks form the commit that introduced generic/749>
> > 
> > Modern kernel with large folios blurs the line of what is the page.
> > 
> > I don't want play spec lawyer. Let's look at real workloads.
> 
> Or, more importantly, consider the security-related implications of
> the change....
> 
> > If there's anything that actually relies on this SIGBUS corner case,
> > let's see how we can fix the kernel. But it will cost some CPU cycles.
> > 
> > If it only broke syntactic test case, I'm inclined to say WONTFIX.
> > 
> > Any opinions?
> 
> Mapping beyond EOF ranges into userspace address spaces is a
> potential security risk. If there is ever a zeroing-beyond-EOF bug
> related to large folios (history tells us we are *guaranteed* to
> screw this up somewhere in future), then allowing mapping all the
> way to the end of the large folio could expose a -lot more- stale
> kernel data to userspace than just what the tail of a PAGE_SIZE
> faulted region would expose.
> 
> Hence allowing applications to successfully fault a (unpredictable)
> distance far beyond EOF because the page cache used a large folio
> spanning EOF seems, to me, to be a very undesirable behaviour to
> expose to userspace.

I think in retrospect, having been involved in carefully crafting
this test, this was certainly an overlooked and clearly valuable use
case for the test which should be documented as otherwise others may
stumble upon it and easily fight it.

So extending the test docs to cover this concern is valuable.

  Luis

