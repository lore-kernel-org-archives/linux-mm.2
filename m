Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E74CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69098E0060; Wed, 15 Oct 2025 13:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A778E0005; Wed, 15 Oct 2025 13:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2FCA8E0060; Wed, 15 Oct 2025 13:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B21E78E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:57:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64400B7701
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:57:30 +0000 (UTC)
X-FDA: 84001105860.11.CCB5E2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B3AAC1C0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:57:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TNUc/9EJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760551048; a=rsa-sha256;
	cv=none;
	b=sYgu/wn1vj1AC+MA61F68ao9rQL5Gb4EUd5DpYqFK3vx7m68GvaNoHSmoxvXhhXIJcpDbE
	8TjkToGUb4YtC5lPfjI++Wbl8nyiV273HU84+hIYfxFIzPC/Agvwe3LadAzysAQlnEHpvu
	c//YuaWsfi9AifJVpo4hdS9vX6A8iIY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TNUc/9EJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760551048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYkKCnkD1z7p7cFHk82WzB9PjR79YSZfURccznXLmJU=;
	b=NlpAAx/9Olk0C0D22Nnkzt+mN4nFFr5NzsWvBqkIBPegTDYU1KiaArh2p/jlwHJAjKx9mo
	vpEHHgb9SVbXRGwOv2DTHFa+ZmIMA2wLqz95XA0ufAm5/mdlLjDLMKlGwC0V81mTkr1W/y
	JyfwzSg5mhBz6o3Lp2l4Jn1brJOHPpc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7D79604E9;
	Wed, 15 Oct 2025 17:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C08FC4CEF8;
	Wed, 15 Oct 2025 17:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760551047;
	bh=gfRoV7O/XWktQsukmzqKSNJlQpoNhjkCFzkEvFnQRC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TNUc/9EJJTvBbysSHzMsQNaKnKcGZvz+w+Dz+1NGhf3RDIOpXL1Ab+mmFHhwpa5SJ
	 wnL9rDEWuWhnZdE0vjoCK6IReeQ5h7/8c/1cNu6z/PlwaQjpHaejhNIxOhyiuY6OGU
	 39CvYWp/1/wRjnNSchCqZVEWr1mNSKwwFClSt5/+DccfnyKNMEzy+Yfuabip+5yqDx
	 kkulOH/pRpsjLmGnAL8ADnbXWz56XbVJV8lFInszGpO02yrCRjLj4RKPCAg59fPaN2
	 TQa9s/Jp2+vD4iAra0lH+fKvLyiSe0Q9KnWGX13GXLcP77A4/K+2IP72TmfM58rUMG
	 h6JwwVpqcp+fQ==
Date: Wed, 15 Oct 2025 10:57:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <20251015175726.GC6188@frogsfrogsfrogs>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B3AAC1C0003
X-Stat-Signature: 41cmpc4qxnz1iq3mdkx4eqcprfhyegkn
X-HE-Tag: 1760551048-414921
X-HE-Meta: U2FsdGVkX19r5xIYhxpLbeSQyteOAkX7APrzk61l6NWRjERe3AyvTlFBrTK/kCbNHYfpI8RZHdL0QN5hKWUSeKJ5k9E1Hxs+39VRKEkvdLNK4FtKgPDTC+zgZ+GPqA1d6VXxdMAbV5iQQN+N64FaVugnAKh3zGhn3Ub9dXR0N/YSGboIeqgzOSgJyc2MDDRHN6FIZEiooCs+mR377ReZDSqrhoahdYdbD+KekGVpSPPYxTCS6D/magSQTcfBG0LMyTvZ6rRsOufZRy21j55iXrY4MKW/yUtIQZSijCf+Wf4wIzM1eK2df6X7pTwdc9CqCtvF2ljPNpfEwulcFVRrZbkcg3fFOLj9M1zwBAUZKDg+yHkE7P3rR5dY6ZGKQGcUr2Jljjtm4b7/yFCVQ3krsLPJK7UIISCJQXRgoAvVX6s0lVemjBao1oOHeOz33ZLH5jKF8hx3bw/30WQmaf7CkKv5Tq157e7GdaQsyV/9SawL6Bp53xRaEe5Xh7iT41XptJI/p+7HkQCFoUXIVJi6JYBo64ur1Q7ePIAfwcSlkAVz17NBe5deJtFDJ8EFFmtFoW8CbnKsXC7+Qjhti9C8sm13EU2LUFarsCtRUtrXmTfXC9XNGL2DJoSjNUR2g8Y3yVc3DPvPopuk3J78grW3gcW5M0vRiTpx506wYqH61BkiA6iuRPr5+GnCOBfsAkSNM2Elvxc2q/yyD0KK4V6/Mr725Sp0SFuVr5Qv5hzq8S5g8om2GdYL97Xsz2wfBzdmIt8Naf5mDxnI10nODrSfJsq2uaT55AvGDmfPeCkCJdq5ER+bzRpxPpPYsNP7f7MmGX9SSkq+lnEjw+GOeLeh/F99Buzjk5QFFALOMercajR3vHnIhdMa8/NcSYtU8zulK0Gs2p7gJPmJc3IQWbjKVO61zSUZ4nB18Nm0DiO4jB53rU8ynGyj5381p+6wkMZ31nTlkuTHnS0qUt9ZM9z
 F5coNByw
 qhhMWhX6fO90F95MjNxSYkgRpk5rySr6UF+oXBK42cJ4f0IYZoeShCb9x+J4ai6IkBnujDJqX05eIn5iHujoQrA+BKoA2ZmUwtFcP7CzfLQ3CrFc6x6eJdvkXXsw7lObvwG2nBTFZCsUd4rrzHom9VBtKHz0Fz4d3BA87u0RIyvHsWRFLM3TV1dFHCgq74/q/G+voFb2fcnfy5w80BG4tpr4d8WEHNR/ebkdj2lSTwLGpPSxXPFmHBeE8RpJC0gqo6fk6gGuET+K5ZuZm0jhCkxFcbVHCD9bwoHClOyrPQn4v962USBzNw5Kib4c/qGxQGMgqFKW1LqqdGLd6mXNYBLeU8/9EXZ5e2Oiv35Ga3pXL0ro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 04:59:03PM +0100, Kiryl Shutsemau wrote:
> On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> > Hi there,
> > 
> > On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> > with the following:
> > 
> > --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> > +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> > @@ -1,2 +1,10 @@
> >  QA output created by 749
> > +Expected SIGBUS when mmap() reading beyond page boundary
> > +Expected SIGBUS when mmap() writing beyond page boundary
> > +Expected SIGBUS when mmap() reading beyond page boundary
> > +Expected SIGBUS when mmap() writing beyond page boundary
> > +Expected SIGBUS when mmap() reading beyond page boundary
> > +Expected SIGBUS when mmap() writing beyond page boundary
> > +Expected SIGBUS when mmap() reading beyond page boundary
> > +Expected SIGBUS when mmap() writing beyond page boundary
> >  Silence is golden
> > 
> > This test creates small files of various sizes, maps the EOF block, and
> > checks that you can read and write to the mmap'd page up to (but not
> > beyond) the next page boundary.
> > 
> > For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> > folio to cache the entire fsblock containing EOF.  If EOF is in the
> > first 4096 bytes of that 8k fsblock, then it should be possible to do a
> > mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> > to the second 4096 bytes should produce a SIGBUS.
> 
> Does anybody actually relies on this behaviour (beyond xfstests)?

Beats me, but the mmap manpage says:

       SIGBUS Attempted access to a page of the buffer that  lies  be‐
              yond  the end of the mapped file.  For an explanation of
              the treatment of the bytes in the page that  corresponds
              to  the  end  of a mapped file that is not a multiple of
              the page size, see NOTES.

POSIX 2024 says:

The system shall always zero-fill any partial page at the end of an
object. Further, the system shall never write out any modified portions
of the last page of an object which are beyond its end. References
within the address range starting at pa and continuing for len bytes to
whole pages following the end of an object shall result in delivery of a
SIGBUS signal.

https://pubs.opengroup.org/onlinepubs/9799919799.2024edition/functions/mmap.html#tag_17_345

From both I would surmise that it's a reasonable expectation that you
can't map basepages beyond EOF and have page faults on those pages
succeed.

> I think this behaviour existed before the recent changes, but it was
> less prominent.
> 
> Like, tmpfs with huge=always would fault-in PMD if there's order-9 folio
> in page cache regardless of i_size.
> 
> See filemap_map_pages->filemap_map_pmd() path.
> 
> I believe the same happens for large folios in other filesystems.

<shrug> The kernel SIGBUS'd as expected in 6.17.  For the 8k fsblock
case there indeed was a large folio caching the EOF, but then we were
also installing 4k PTE mappings.

(I'm not sure what happens if you actually have a PMD-sized page since
those are a little hard to force.)

> Some of this behaviour is hidden by truncate path trying to split large
> folios, split PMD and unmap a range of PTEs. But split can fail, so we
> cannot rely on this for correctness.
> 
> I would like to understand more about expectations in real workload
> before commit to a fix.

Yeah, I dislike the incongruities between byte-stream files vs mmapping
pages.  All the post-EOF zeroing logic is constantly getting broken in
subtle weird ways.

willy? :D

--D

> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov
> 

