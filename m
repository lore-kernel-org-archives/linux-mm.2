Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB65606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f9VnvS5U
Received: by kanga.kvack.org (Postfix)
	id 0088F6B05B6; Tue, 17 Nov 2026 05:29:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21D36B05B7; Tue, 17 Nov 2026 05:29:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E114D6B05B8; Tue, 17 Nov 2026 05:29:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B96AA6B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:29:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 444A11A03AC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:29:52 +0000 (UTC)
X-FDA: 85444240224.11.2E07E5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6084980007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:29:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9VnvS5U;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794911390;
	b=FNBTZ5ZwE91Na6b8iaMCqqpx5YrJlzAA9A87at/ShQW08fmrr9xNNCEP/T4E5r6vUeMe1f
	3zAsAMmuUdxpyJtR+azpVFhzY6VXOhT+UB7HIi+UTLV3x/7tB6oxaVT4/qaLu+kJ0Pz7HN
	EXb6zp+8Uy7EAKstCglveDoo2Fbh0pw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9VnvS5U;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794911390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMMalkHqyexrRI9uTeursGHU/2uETz56pJsgymByLq0=;
	b=iZYqxJ0i17G3xTR6IEFh+FEXoXYOjzqKooSBQpqu20kZz23GE6mj3nYF8Mf1hA9Xyl6PVk
	aFzR3I8puN6aSzaYbsSAopL0RNsytxypPfTjgYS8xE+1kE2EkmPpuDRVQ8cv2g+sNjE2Xo
	FcfL0ZMNzskTJioJb5lqEzCmcCWCHcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB2D4633A9;
	Tue, 17 Nov 2026 10:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26991F000C8;
	Tue, 17 Nov 2026 10:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911389;
	bh=kMMalkHqyexrRI9uTeursGHU/2uETz56pJsgymByLq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f9VnvS5UX5+LIAeVYyYRIRpkL5m0lTRnBcuVKqy827ff1wba9e2isZsOrj6XCR/ik
	 EgdzcbUfaN0xZtXR22MmzlYwP1rm0ff/emQdmF9ctm7+5ZqAoKm8d+fw3TgjDVuPh+
	 SOfKUTpVcf+uRnwivTORXAnlFyNn2vfY8x/M9eVwhNhvpurhk0nUiZhjkIn16nxrUP
	 xW6DtboYWJFnd5fjxscJLfotDtTO2IBhXqQEVGF0nh2EjfX3XrKxy2xM/tGrV0SdDr
	 f00Sc/CjbszbamBbSTzIEo9UpxCsD2QGOOMdDGMGWsKbP1do6SJMy8ezzE4zbu1Qph
	 Vrin2ViTVkDRw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0C1EC1980047;
	Tue, 17 Nov 2026 05:29:44 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 17 Nov 2026 05:29:47 -0500
X-ME-Sender: <xms:mCz8aug91pNoR66em1YAWzlIThrX5Epv1ZIhi_Kq_8QTuZw3Lqt0fg>
    <xme:mCz8agg1iPkBuhsSNmNcLK3LNtrQqQNWSCySOOswlVx09ZZfR4zvp-EurLqTixLxs
    JFBg7UhMUS6AxyaFG168RjcZEEUmD6qm9BGWnUZMPRM3eiawNF8y-op>
X-ME-Received: <xmr:mCz8aqojE7bomun_BA0hgxs9p1QqMt-NlFnfo7O5gTaLHvic3P0R9FqL7mo>
X-ME-Proxy-Cause: dmFkZTFWht0HuXcLPxNLST5jGk7LEnSc4D1QzzdUn/dMpxot85529SlKu9p5b6DrbabwHb
    U1Qe8kzPDpQS/ETM1hDqgmCVEktjdOhhANEYt/LI80k9Q69nOSi6h0tcHNNU6FjfzwQwXh
    dygIdfWp2cmscSyQe2XvhShcOVYPiwajXDuDzUKj+tJ858wuSiY3qPHauvrgPvSlXq6Df0
    uUe0kRQh4jdjDqjwxcWNnVmUFE2g8/IcroHpvHWqlR7eEB1RQbH/Vb9K/yZ2VmpefvexOr
    /M6uW021gxUkfQ+yi+YpC310rSzvh/bTmuLORYOCAvsG0jP8FPKuJDTjA3Teg4/v9gznEQ
    cG8rIfCuXV/Y4EHkBmLiLzUqEOKYSS6zfgYxqyMS9rztZi6rk9QF8sHIEeKLXwADKHnqrr
    nwYmFArIggU5U5ZMdjjCUoeNzGDAu6cAESZ/ZaghRAe75DM1QD0fS/0Ch51y0R1Sb+v/oS
    6YETzi0Lq39gG+gDAWD2ZZgJDCKUaafY8two1BWSBB0WA8V9apq4oD8Jy5qvxhtpRhQWJ9
    2R4l2Z1nd2/lPBsARD2bSHYXkk7FMtr0LzX4Cy6tX1NmowJ/Up9JJfWhvkedtrys9KziTP
    dl+nt3DgrNrEpQN47uRmWgWrH7CPELhP+mgIk81lJMkI44b0GoOM2dKmnBHg
X-ME-Proxy: <xmx:mCz8amyV2qhW2qczQFdj0pybGNjjlEHdDeqtin34cQv1IJp9yehVZQ>
    <xmx:mCz8apz-12YK2dwhzoV7bSb3pq2xClcXWW20yjeI_JEv1rCXuTTWXA>
    <xmx:mCz8auamK2IpklSycQZm3OXNYbswF4V3Pz43koguSAWH7rt3h3VhPw>
    <xmx:mCz8aqm9QaTytRvHEqOl6qvgrBLh8yeVkhr0in9mRNe_0VeG2Z9ccw>
    <xmx:mCz8ajF43WNrC2vEOtTUqZEctJr_4ZxrF7Hje7WNvexSNWE0ytLVTwg_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 05:29:43 -0500 (EST)
Date: Tue, 17 Nov 2026 10:29:42 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Dev Jain <dev.jain@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/compaction: do not skip the free scanner's periodic
 lock drop
Message-ID: <avwsUxvOymaJqcXX@shutemov.name>
References: <20261116125746.2897395-1-kas@kernel.org>
 <20261117013702.109081-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117013702.109081-1-sj@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6084980007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zg7s8by6rdqr6nbqje9ndhee77nkdw1h
X-Rspam-User: 
X-HE-Tag: 1794911390-376591
X-HE-Meta: U2FsdGVkX18cFCjMjp0aeGae8nycGaTeqf+uGv67oR4mLmK5LEHvpWx8RKgAdwbS4aXib5TrmujV4KcIqBSyl+4V4QUtrcHZLV5ybSDzXLE7GV8xSezDn/ZWFS/XicjgdJ3bhM2NgyDhUv7KIo7AbrtrANtB7yQirgcncxSz/VhW6I1oGBGydyR5a/4DfL6g/xS+QEEieCsaKp4wxMfhYxHiU9J1aHulp6UggqiyzQxsr3BPAnIVEKn8rSGyO7eIWGHiZCBfvLF985l/D/9CV5pYMjvaBIZXpThRzgFA+GEpArNGmUJS1aupcYH8OtoyO0uU2N/W7tTrn37Pvk26GFSfCxkyb+L9Aeo4h1JnybTSo5s6eLPyk7nV+rMzFJoKlc5JWt6/p04NcJ7XKANuLAXiW/F56SxzCuG4iNghqwExDLqTDQhZY8ib3qsY9PnhmA+TNfcDw60YohyvRNJ/ESriOAexTzTDK7ojpY2ZOIyTB/y9oAJZbQ0TPAI58+zqmcYOuyWZJ0ZIOEjEYwQNhYEVCGpxc8/5ocF0uXEM3Wi8ZXJ6W31Chd8e3T8ecTaOXsLJ2qBJtlkSIAeizI+xyMeMFkSHyLZJeJ8x737uRY3tCGT6sabnRNC4UOlmkwFgm2SPaOBN4QNsurzg78MvWMG5SZgV/G/wMri3ElYSdtqNCu6jmzLjQer2Mu9/QA0LenDGsyYV1QI3AG5Ljv76HPxk4Ga07jH4FZxz5SubooBZ4J6MdMJAxyc0/kOk8bfj/ap0kBHMOWxeeP7A65fTRMtkikGW+VvTIUX88OtnwGucg+oiYpeNBp8ndlsC/Vsdjp6cOMCx1Ct9MlESNGtozOzWm0brBrANt8ioHY2WlnNoMmc3+zm5NNXNwaMnu8kPgGCfaHPIxuxxwIsof9flf0HgWUQAnmzmrDCWVBU/wocuNoC+Y2UmE5r+Zv/Z92TzsHI1Y1hl3/0oyrm2OCI
 1/UU7oMh
 nsYXi8NmlptDuMT5vwk24I8B4UY/+fU3ZGidnjckScz4enwiykmIzHVh5kohEnkQF6EuAjnp2hPQuZKe7YYYVIShWCSvyRUZ6g5glmWJ95QrAlf0TDbatuxs/RdZ+XHiFyfihjZvqt069XXoXSRZJURTSsQPVaaxCmoFmblaQBPRi99Nr2Zz9qjPveZPO+dh2ekxVs+pgr8DFgbz2qRD2+5P9OlQdeBWz7xbPr16AGZAFRRHYTvqJSj0jH9oV0NkTcnEWjqDW3jnIWXY3cwmE5qzNZ0XON4Blv45J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 05:37:02PM -0800, SJ Park wrote:
> On Mon, 16 Nov 2026 12:57:45 +0000 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:
> 
> > isolate_freepages_block() drops zone->lock, checks for a fatal signal
> > and calls cond_resched() at every pfn that is a multiple of
> > COMPACT_CLUSTER_MAX.
> > 
> > With a stride above one, the scan steps over a compound page, or over a
> > high-order free page it has just isolated, to a pfn that is not a
> > multiple of the stride.  From there it never reaches a multiple of
> > COMPACT_CLUSTER_MAX, so the rest of the pageblock is scanned without the
> > check, possibly with zone->lock held and interrupts off.
> > 
> > Count probes instead, and check every COMPACT_CLUSTER_MAX of them.
> 
> Makes sense to me.
> 
> > 
> > Fixes: 4fca9730c51d ("mm, compaction: sample pageblocks for free pages")
> 
> I understand you intentionally not Cc-ing stable@, buecase the user impact is
> not that bad.  I think that makes sense.  I just wanted to call out this for a
> case that it was not intentional.

Right, I have not see the actual user effect of the bug.

> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  mm/compaction.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index f1b2060eb201..4465c1551406 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -579,7 +579,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
> >  				unsigned int stride,
> >  				bool strict)
> >  {
> > -	int nr_scanned = 0, total_isolated = 0;
> > +	int nr_scanned = 0, nr_probes = 0, total_isolated = 0;
> >  	struct page *page;
> >  	unsigned long flags = 0;
> >  	bool locked = false;
> > @@ -599,13 +599,15 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
> >  		/*
> >  		 * Periodically drop the lock (if held) regardless of its
> >  		 * contention, to give chance to IRQs. Abort if fatal signal
> > -		 * pending.
> > +		 * pending. Count probes rather than pfns, as the scan does not
> > +		 * always land on a multiple of COMPACT_CLUSTER_MAX.
> >  		 */
> > -		if (!(blockpfn % COMPACT_CLUSTER_MAX)
> > -		    && compact_unlock_should_abort(&cc->zone->lock, flags,
> > -								&locked, cc))
> > +		if (!(nr_probes % COMPACT_CLUSTER_MAX) &&
> > +		    compact_unlock_should_abort(&cc->zone->lock, flags,
> > +						&locked, cc))
> 
> Why don't you let the later two lines unchanged?  No strong opinion, no
> blocker.

&& on the new line is odd to me.


> Reviewed-by: SJ Park <sj@kernel.org>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

