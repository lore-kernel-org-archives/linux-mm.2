Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58928CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 18:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B72E6B008A; Sat, 17 Oct 2026 14:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4687C6B008C; Sat, 17 Oct 2026 14:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DD66B0095; Sat, 17 Oct 2026 14:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA6B6B008A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:50:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15FC58022A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:50:51 +0000 (UTC)
X-FDA: 85333009902.23.B1CE361
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E0CC180003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:50:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5V3qfQL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792263049;
	b=x44dMR3A+vyYJwB/80Vc+rwx/vMfkh7zNWviehva8VihtBaNClTUsOSEFc2QupVfNI3OKl
	5GYNH1nHyTk+qcidK86RT7PzzpeQQXy6eFRemw0tce5Q98jbXEYzXe6tZ0KC4OJGbwRXrE
	dOhWQt+akTHTAdm7utAJiMBT32CgZCA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5V3qfQL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792263049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRmpfEyl7ALg+ojzByVLMDgHoT/+5hYO8aHk7hFVTbw=;
	b=x9SHiCTm2v+zPFR0pJyExlViH79oJ6PnjiVjbmwyvlLnx1PS+uX0j+rZTYZHQuVOMuedcx
	XER6wwudTumWxtFxhEVH1J1TpsBeDsz3ks4Ojvg7+RLsL+KuBfYEuflRjwneDdhO1UTZhU
	zmJ3dR/0CPWVuQ/kKZYGdmfUHfJXbVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A955743F65;
	Sat, 17 Oct 2026 18:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E251F000C4;
	Sat, 17 Oct 2026 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792263047;
	bh=HRmpfEyl7ALg+ojzByVLMDgHoT/+5hYO8aHk7hFVTbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g5V3qfQLwRTyTaLALqXAlk5deVyDyqO46ougZRpsy5EGtSM6R56hqjfC2keqlAEf3
	 l9bbiKrkhZM8n+7kzv5Vs9KVpOCko+Q75eh7brYwpm2hbmfbh/QUcklcNGJbVctJRS
	 C76P44n1Jw3vZakHzeLhiv3QyAphWGVOODjCS50JSbGBXJA+xYp3TIpqxaMymDWaU/
	 jN4LyxI3iPAb8wdYoGUx21GTkVcAS4PdeBaBFoueu9zJ0uVU0Uo4SjYrzA0G0joGh1
	 WdmujLpf65HUIcnLJ6xdvJV7UbCxYLpOHxiE4fPTEiuuvoRvduXwxg/2oK6xVKQW+E
	 YXhMoQsXai6Qw==
Date: Sat, 17 Oct 2026 14:50:46 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/10] NFSD: keep direct-mode I/O out of the page cache
Message-ID: <atPDhmfdneS-d5qM@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
 <f60b0363-c4d5-4539-990c-1c6c7967f8f0@slotpi15m67>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f60b0363-c4d5-4539-990c-1c6c7967f8f0@slotpi15m67>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E0CC180003
X-Stat-Signature: br86uej918ttijx7x7g1z9swe6o3qwnt
X-HE-Tag: 1792263049-856931
X-HE-Meta: U2FsdGVkX19QoqqYZ+cEGJxOlXVVNOteyc2KC9GcWHe3N0k75fXWrSpL4y92UM1dCGIlyotiM4p+xIbMx0fV/wx5EZzHTXdKeCAMY1IBFpJea2fvXGMOkPDG41Ok/Vce1icpUWpA5ZiNl674E3UqU3zMa6Xpm+c4CJmowsiDh81bOio0cGZ5U7lC0pNKzcF4qBHPRnczf89dX8sEoPnLH9JanrK+whY0yyLmuSIAlix3odaUUm91rjm3MGN4eKUGbRNxgpPIK1VvWg0Fxi6Opfjud9TbawP2EqZ0WZvwSvcl0A3WnGSKPRUO7IavIMbG0JbXsE/fxG7xN8kiln48xkTPu8XjNPGyJtUTFEj9SJPjxG9PVb8P8ZMlSMVb0Dfxecn876OtocefsSWcfKfGLHIFu2ov6NhhEsrbNlyCPNwa90zhA6Ol7P3Ju0XFLJRADTJ4J0FYkk8TuccRfitPDBARGI92x/UYexFGgBDP4fn9wWe2b1oIdEAvIYoc7aY0LUprRMPsyTB75ht8hHVJ8wUCCOzaLRB6SDA985+NAPpHPGjRgslHHRYVkXk4vc3TQA3e3TcG6GAhfiNmYQg3ytjI99rtw4D1oPOjj2NseSwR93sX/ArVt4o7WSoXoWFEuNaNfnBYemZDjH5fh7E7mKBNnBpE0yLxNDLXKxptGE8Y+Ya+PD9PwSPvzb07zhNcYqv4FfXu/LM4AxcTbMmcuPekwyWIEVs1wPkSeIO9VTEtDMPLRZlluzFc7MgykphVBr3+xBtGiciKiTrC/ddanNlY1sAGgn3EPWgE80Ovhfptb5K+xLx/0DEzeXYEkdBzykJ2QL8BPVzR3/Egr2fxED80Vy5dlqImrpo28o7aRTFBS/jKVxaBYn4FFDpYQ5UAiKXFjjlM0wvh00+M0FL18RP9R+UJ+zpkgo75hmJ3bB4fylE00kq0rXr+EvOHTuXDTfyqD09G1X9mYxeWbLO
 2TCcWA/U
 4nxJpl5nh1ueYB9kewoqdvG/y6p3BX/REa3f/hviwIWErWz7hcXWaO6Dm/scgqRdsgFtGywXsMh/84Ky/tf/tMsqaf/aMmRWOg1ZzujLaIn9uaAJNzw3cfIGGex1Aa23LlvnTURypP3TFSDz7gUMchqIvpnKz3lZXIdjSmMCvOhyx2x8PYPI/E7JWkNm7C9Ze0apkWTEnRFrrH1mcwbpaaIW2R/3A+gqi0WZI+FGkV2wMHt7AggvqOOYLS2Ha/Z8NFYao/qNZGFHAgJJuWVHT6vKR2rxflhXxy28cOjJXUE8UuRzLoz8FOzIe3JEkKSz7BWAHopL0eAVVH/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 03:23:27PM -0400, Chuck Lever wrote:
> On Thu, 15 Oct 2026 19:32:59 -0400, Mike Snitzer wrote:
> > 9/10 calls folio_mark_dropbehind() to keep the page two misaligned
> > WRITEs share until both have written it, with no state in NFSD: 704
> > device reads for 42895 WRITEs where there were 45144 for 45664
> > (47008-byte records, 32 interleaved writers, 4 KiB pages), and on a
> > four-server pNFS flexfiles rig 0.003 device reads per record instead of
> > 0.014-0.015, about 2.9 GiB of page-cache growth instead of 11 GiB, and
> > 2.4% to 4.9% more write throughput.
> 
> The direct-mode WRITE path started as one decision: aligned, go
> direct; otherwise split and go buffered for the ends. This series
> adds a page-boundary cut rule that depends on the relation between
> offset_align and PAGE_SIZE, a minimum middle size, a knob for
> whether the ends are DONTCACHE, a floor on READ size, a rule for
> when the sync is issued, and then the shared-page pairing in 9/10.
> Each is small and each has a measurement behind it. Taken together
> they make it hard to say, for a given WRITE, what I/O NFSD will
> issue and what the page cache will look like afterward, and that is
> the property we need to hold onto when a corruption or a performance
> report comes in. I'm not yet convinced that 1/10 through 6/10 buy
> enough to give that up.
> 
> 9/10 gives NFSD a semantic that DONTCACHE does not have: drop this
> page after the second writer, not the first. It builds that out of
> page-cache presence, with an unmarked folio standing in for "a
> partner is coming" and -EEXIST standing in for "the partner has
> been here".
> 
> Neither layer actually knows either of those things with certainty.
> mm cannot know another WRITE is on its way, and NFSD can only guess:
> a page left by a READ, by readahead, or by an earlier claim whose
> partner never arrived makes the first writer look like the second,
> and the description already lists the cases where a claimed page
> stays cached until reclaim because nobody comes to complete it.

I'll be posting a followup 11/10 patch, because your note ^ caused me
to revisit the handling of -EEXIST and I found concurrent receive of
the partner caused the code to be ineffective.  So yes, it wasn't
quite right.  More below.

> The 6000-byte numbers in 9/10 show the shared page is not a splitting
> problem. Those records are never split, and they still cost a read
> per record when the ends are DONTCACHE, because DONTCACHE drops the
> page after the first writer's writeback. So the choice is really
> between two things we already have: issue the ends and unsplit
> WRITEs DONTCACHE and pay a read-modify-write per boundary, or issue
> them as ordinary buffered I/O and let reclaim take the pages.

Agreed on the first part: the shared page is not a splitting problem.
Any buffered DONTCACHE write that covers a page only partly shares that
page with its neighbour, split or not, and 9/10 claims the partly
covered pages of an unsplit WRITE the same way, which is where the
6000-byte numbers come from.  The subject and opening paragraph of 9/10
frame it as a split-WRITE problem, and that is too narrow; v5 will say
what you said.

But I don't think the choice is only between those two.  Each pays for
one of the two things NFSD DIRECT is trying to avoid:

- DONTCACHE without 9/10 pays the read-modify-write: 45144 device reads
  for 45664 WRITEs of 47008-byte records, 196589 reads for the 6000-byte
  records.

- Ordinary buffered I/O (direct_misaligned_dontcache=N) avoids the
  reads, but every page the buffered segments touch stays in the page
  cache until reclaim.  On the pNFS rig in 9/10 that grew the page cache
  by about 630 GiB over the runs, against about 11 GiB with DONTCACHE
  ends.  For records too small to split, such as the 6000-byte ones,
  the whole WRITE is buffered, so every page written stays cached:
  NFSD DIRECT for those workloads becomes plain buffered I/O, which is
  what the DONTCACHE ends are there to avoid.

9/10 keeps each shared page only until both of its writers have written
it, and then drops it.  That gets the footprint of the first option and
the reads of the second together: 704 reads for the 47008-byte records,
385 for the 6000-byte ones, 81 of the file's 524066 pages left resident,
and on the rig 0.003 reads per record (from 0.014-0.015) with 2.9 GiB of
page-cache growth instead of 11 GiB, and write throughput up 2.4-4.9%.

More about patch 11/10 that bears on this: finding the folio already
in the page cache says only that the other WRITE has claimed the page,
not that it has written it.  Two WRITEs that arrive together, such as
the RPCs of one O_DIRECT write larger than the client's wsize, both
claim the page first, and the page could be dropped before the second
half was in it. With the fix, a page whose two writers arrive together
is simply not marked, so for that page alone 9/10 falls back to your
second option and reclaim takes it.  That is the cost I'd rather pay
where NFSD can't tell the order, but only there, not on every
boundary.

> If ordinary buffered ends turn out to cost throughput with flexfiles
> (or any NFSv3 I/O) other than just occupying memory, that is a
> reclaim or DONTCACHE result worth bringing to linux-mm on its own,
> and the right fix would be a DONTCACHE semantic that mm is willing
> to define, not special state in NFSD.
> 
> Consider splitting this into two series (which I already proposed
> for merge process-related reasons). 1-6 need careful scrutiny to
> understand the trade-offs between scalability gains and
> predictability. 7-9 need to be explored as an issue with DONTCACHE
> that should be resolved below NFSD, not within it.
> 
> I'll study 1-6 more.

Patch 10 too please, it improves tracing so we know precisely how each
segment is issued.

Thanks,
Mike

