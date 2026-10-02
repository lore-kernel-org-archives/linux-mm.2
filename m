Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11843CA5FE2
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9946B00A2; Fri,  2 Oct 2026 10:27:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031416B00A5; Fri,  2 Oct 2026 10:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEAA6B00A4; Fri,  2 Oct 2026 10:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABEAB6B00A1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:27:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DAFAA76F8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:27:24 +0000 (UTC)
X-FDA: 85277914008.30.A221450
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf13.hostedemail.com (Postfix) with ESMTP id E26D120007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:27:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="K lMgJlB";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="g/G+Rl4b";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790951242;
	b=EepBU2VnH1F7ntRUegKsjstpUQ3F2/xpv4aDwk4YXmwSj/drEXcQ1lbkhGF7DbUghXKM4w
	ixi1ajiundJeeOB718MZ7UmPQlt/1EVHFDWJFvKdwykE5fxwlgCGLfI76wi3B/+hPD/VUK
	czm1Fjt7dwKS9hP35hFDrrwb5uKdnsk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="K lMgJlB";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="g/G+Rl4b";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790951242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbdgbdFTJvNwsF7OFSnsee/ChxmLprJ0Q1h635WZ3gw=;
	b=3EHFJ1uLxgc8caoMw8FXAdtz8pfxthbH4feVeu9ExcSyJO4YpboqhWSAghK6ocz5pzbSS7
	tuTUlt76HQQ6JEGWTq8HwTuxgMwLnkDJ+IrUhItFBjs2vxLtdbbgaLLJroh3ke+0qATjpo
	HoDTSYV2cwod1YlJ7gm9I/cqqRo9K9s=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 60398EC019E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:27:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 02 Oct 2026 10:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790951241; x=
	1791037641; bh=sbdgbdFTJvNwsF7OFSnsee/ChxmLprJ0Q1h635WZ3gw=; b=K
	lMgJlBCt1l7i2VvZgYxJNENbnUsVlaegLpQZ38g/xNapL1oKRuIQIi/ckJsE1IIz
	4gf1SdGg3sCS6hjdsTzUw1l3CGTp9IdHUc/Ba/fY9ZD/qTG7QgEHLr1V2RoMMO2f
	OARFiAPqXClTo0IShZRV4JdBdZGRHC9UJGMa/0akTbqziWUyjy9+68DHRW2wjS3U
	SwwUCIwnNvgEXbxykIA0zYZaOJ7V6NVjw19kimFn2lTDhyWrEeAiJIYdwcwHpvMI
	yr/MD41riZIy1HZhUpH95PxKawEyiILE/CIw3GsFeFV7VD127F0lnzMG4femPKBH
	xxXd9hNMv4EfC+l/12SGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790951241; x=1791037641; bh=sbdgbdFTJvNwsF7OFSnsee/ChxmLprJ0Q1h
	635WZ3gw=; b=g/G+Rl4bNuOrK13DKtF4c6aFOYnkuLrMgYu4UE/nwzI9VTV1sIF
	ceY/rvM+GOaMU3tuNJouCjyjZAjJG8it6JWgPY96AoBMTwBfnADNByEy1ph27IZF
	NqFPkcDoRTGge/lPT21N07tl8+k5rTt5cxzV58DtePOHDI3RsYgPvDiQU2GxRvQ9
	iIJEnR9n7MLfuYR2SfN29My5e8Qvl1TKUWtNWeTB+lajuD+/m0Q3YJXjzMdF2yGW
	5mVp0As6+Fjji2t/jgJ8LpbOiypaL1brk0XBLAJ0AEgESK/3M3t0cCUK9F09D3Kb
	0QklBGGNh+6oSu4OFNu5aL6dY/fRO023a7Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790951241; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:V3dypU7x8agYCl/6HpHgMH3he3hpuQzp5TxT4ZCE0yySqU2
	YSYV5bxxq7B3bpP66vVvMwPbLS2bAONcDjkpN6ATyz0JG8KH5fNSwoGw2weXYEYY
	4cEzZp/JDcBBvHPF2DZJlI3vKPMSys7wWkTfM1miBDiUoRQoum5+F+uToLc9vjGs
	NTjdYm4wmHasr24Zj5oO37hgHhRcDGR1mDehQWtd+W2YhLSR4vuZ9FnHLVPzZc75
	pO1GUpGtRgm+JXBf+IxWS6ZuGBlFs/fR/yysZPExkVX0Ix5FxfH7T6Zf+mSZMmBm
	aTS22Qyz31oHrZwfwvmnYRlNJl9KCJKGheMETKw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:vpewZRuhIM1oASSZ5cZOnkOnUeKAsvD7DkHHp86obNs=:aTYczatzxFghBxxt6+I6Ijj8xf1r7HURdlc5TARsnno=;
X-ME-Sender: <xms:SL-_ahycoHtJvrfE01u9Y8ShGxLAYtakxSjjUIHx_hXlK4x3-Eva4Q>
    <xme:SL-_au5aE2-iigmFVauipP-iCCJYQ2cv4JqkYzHk97RrurP-A5DuSKtCP4mSuz5AI
    Qe4KMmS3nT-_w6ZXZnPrCRFHW_5nVm2vIWexhmRoZ7POa9I5cqWeHF7Ww>
X-ME-Received: <xmr:SL-_aisdkLUKj4rte-k0rZW1QZSEguraa2sHpaMhVCKSP1YxlN_tlBwV6nA>
X-ME-Proxy-Cause: dmFkZTE6osMbuhp93dIm3/olPTvePRSEtMiSG2yB8BD28yVvcGSQ8kW/aPp5RH7S+4LSfa
    bTM/3ZvRE9+32cpLQr/CGpHm+Yi8RYT6Byk/DtsaHMS7yVFCz7hfxGUsRHzER8EyP/fnfk
    dp40B298jELpaIf6SSNxNLO7aX0eEnbYyGnLyRxkEtipTrYhKpJ4vthG5lCuD86qn2IP17
    AYs411yzZV8ZQ2yOJDUEt8N7GYHX5M5Bcu3wNIxvJzuBny3NV6V2M57TZNmwfjSkSnqlYW
    TWEpKVq9jPTQlT04TKh2mDklcp76W1Z5REyvPrpjXEk4VgRzrbfbRe8ztlihACiNsuySYI
    sTLLE/FCDIEgtzXT9x3uYfnPqHfeK+xjfZHxsW8lkPbym0ZtxUJuI5HV+Wh13ivD0eoCnR
    hqviaf5w34ufD2Od8C7Lj9M1R+32/jPXFDyWGzob1PxP5eCYrmzlpubSo2K15J/xmuu66Y
    0PEUIY2OUyaKexZl7pnnpLIC3siTRdSb6msOuo8T5ioC8I5HI2inmPPp7XpUHEs60ukDfY
    pu5aJmSIpReyPwe9Z7jMGnGysaZBxIrGWPP9KIWYDjwf0Q9KM9tm0+0Fu7bmS5fbGK1l0p
    8aRXi+RXSFIMCRzAjBkyDDszEPoU1Q4eoydKtuK7rHmco0UJ1XN0CE+c2M8w
X-ME-Proxy: <xmx:SL-_arvZXMidHA4TJIr2OogNNR1yGXNeUsiQL9LYlOm7zlxkEZM-wg>
    <xmx:SL-_aqtucqcOI6pwBn5zXr56kiUMFHub0AZLnaFeJBK9dmYToUTDqQ>
    <xmx:SL-_ar5BWk5XwRrNDzhraZWn9W-DKyMRjEeDFOUxiU8G6Xa4Iaf85w>
    <xmx:SL-_atD8hN0hPvotiJqyEhm6-MHoGeKnuugJtDUoJ4HnUy4aTm8oxA>
    <xmx:Sb-_ag3AqfLrmlL8ECTKvBaHmWyjTJD8J3lroHPDVeHEeXP-XxrTeTkE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 10:27:19 -0400 (EDT)
Date: Fri, 2 Oct 2026 15:27:18 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 10/13] mm/collapse: open-code collapse_single_pmd() in
 its two callers
Message-ID: <ar-nKHZ5hlbsXeFP@thinkstation>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-11-kirill@shutemov.name>
 <b2133cff-ce69-4a45-bf33-c44b774dee7b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2133cff-ce69-4a45-bf33-c44b774dee7b@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: ct7znag3n1qb37f8zsgkkjr6b5uxaphq
X-Rspam-User: 
X-Rspamd-Queue-Id: E26D120007
X-HE-Tag: 1790951241-911222
X-HE-Meta: U2FsdGVkX19fj70uCTWrQ9R6MGJV8JK6kRPKGXBAAbjYe9aS0Fz8J6n9TSqkV03jgfcNm09+JAK01qve7bqyVZmxuyNuU3qjjGydClzTCXwizSgizdBe62BlrPRetkJA8LAHzzn+MtJjSNuiu4MaxPqGR5mLkplGkgnm8SYuV73K5/Hy2VUzQjEiB78WRgqGjbecRRjFvXah4oyFuJtWxBIDQ/1aeA3Hts4Plo/bXyl15QfqdBAHdQNDLNZmzRyyMtmtqpEuVcWHioooy2O61tn8mKkjqhEK0h6x+8n4VJTmTIo5E3RAtECy6ec/sHPmYMgv8V+9BbX39oPFHyq2248tdCNK7t17y1+v2hU472s+gqy5rKFxI8WUaQY7Uid9wvyWlzICGIa3KZ2jSPJY0CfDaeGSt2F9kHkQMdYD4Gp00OHoNCN0KiiPE4jhT2FTAplK9femmuXZHqlRP1zzoqIYpJ6xGZmBohzoQHWP/uBnRJKEIkz4C52EW4lLYWYKegtEFZ1nJ5Ob7djyTb0Knk6fsi3h9Jp0alH8m8OJQHcFbr58VUQho8QB/mCXQhtlCOJg7QVi5dW0uaHYH4GRSBNLnpPSJBH6f5/3hw8LSJKY3NMcuPInIAYPj25UPwxICh2SZJ29pkaQ6kTMRW0KXPDGG5QMyWDGNYfWs9IT5+TauzuLc2Ap6KsZ2I5AXy6V+hE7g5LkHMhXb7krEEZ987GNhCWkwvmSgV0Dv/qTeKpvUi1pHIeQ0FgmLtkgvL5SXYOd2BXYXbumKSsINr3258VgSX3F8NMSFBdOrqetxepCQNkT5OquFjOYKQlGmmb3RTBHvhrzrqv9j6cbWM7fFTAWc/xFU04FqUhuViL4IBqZB2q/Evwp7AkeoZifLs3AUWHGWfVZ7vj49cPg0IhgTYs1crMFC0MYkwmXOHqOOSZ3NVf3IXHxnd0K9j+GC1kMZ1piIdV9s8TQXxHX6l6
 Bq7wGDtw
 4btUXDhFLMyxLTu1/3tVGEwKYtGVGYJ6SxgOYjjCrYxa+7lBEYzA+/sdcF4LzROftD0Uz6WBTV6FZCu/JcySFT17IPhWrxyHr40WiL6dwgEMs7mg3wlD/BUga/p7LmboXAAMFRkyWU1/Rr7GSW8fIKOjTk7TCXBg5DK5mrNwZzqlt5vfTxjfIAhJWWsEouyVYiw44OUrQnmf33iWzKfX6USX3K0i9ZQL6KjVhLHh/taJeIq7WwhwJ4pa9KRi+cOx0E7ZRhdmXYddE6hM5b0NP3ZnLDsYlE5MsJ8RYUBkJAxLxJkRlg2NE0go5Ha8O+dZldbdkPdFKCO8DMiAeCOX2bSnjWtk0j1Sy3Pb5Uk7eWxpbsMx3Di7qOnLkP6ntU+HF8Vh4eSTNksy5Ww42ZBzmYuzcJJ4F+Ro2RgjTe3oh7cJVHdF+Y+Hjv4O3p1hRRHmSWUNjjvFYs8buSOA2Qq6TwjQ6/3T60HXBMd3OXPH9iEVh8oJEyH/To+/RSZP9S3KMxEwOTQO66EGJlO6v7WVcWxd91mhlp+68ode4iWcmzZhm34YLhC5d8ouFFePKJUGOsJR8rs9mZB6XOM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 11:37:31AM +0200, David Hildenbrand (Arm) wrote:
> On 9/28/26 12:06, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > A scan and a collapse want different things from mmap_lock.  The scan
> > reads one PTE table under the lock the caller holds, refuses most of the
> > time, and the caller moves on to the next table without letting go.  The
> > collapse allocates, may sleep in writeback and takes the lock for write
> > itself, so the lock it is handed is of no use to it.
> > 
> > collapse_single_pmd() kept that boundary inside itself.  It dropped the
> > lock on some paths and not others, and reported which by way of a bool
> > its callers had to carry along and then act on. 
> 
> Let me think this through. collapse_scan_file: it doesn't actually need the MM at
> all. The only reason is to do tracing. Rather stupid, it just should not consume
> the MM at all anymore. Consequently it doesn't even need the mmap lock. But the
> caller needs the mmap lock to figure out the file + range from the vma (the
> per-vma lock would also be sufficient for that).

Right on both.

As I mentioned before, virtual address scanning might not be the best
way to collapse page cache.

We might want to start from inodes on superblocks that have large folios
enabled.

But it is out of scope for the patchset.

> Also, I guess we can convert some of the scanning to use per-vma locks in the
> future, whereby we would actually want to scan with the per-vma lock held.

That is the reason the caller owns the lock here.

On top of this series I have khugepaged scanning under the per-VMA lock:
the scan asserts whatever lock the caller holds, the caller does
vma_end_read() before the run, and the run takes the locks it needs
itself.

Neither the scan nor the run changed for it.

With collapse_single_pmd() dropping the lock, it has to know which lock
the caller took. process_madvise() on another process's mm cannot move
to the VMA lock: untagged_addr_remote() asserts mmap_lock, so a remote
MADV_COLLAPSE keeps it while a local one and khugepaged move on.

The single call would need a flag saying which lock to drop. That is
the lock_dropped bool again, pointing the other way.

> I do wonder about one thing: should we really care so much about keeping the
> mmap lock locked? Meaning, why not provide a single collapse_single_pmd() that
> 
> * Is always called without the mmap lock (as is)
> * Always returns with the mmap lock unlocked (change)

Yes, we should.

Walking the tables under one hold and giving the lock up only to
collapse is how khugepaged has worked since ba76149f47d8 ("thp:
khugepaged").

The bool is just how that signal got plumbed when MADV_COLLAPSE arrived
in 50ad2f24b3b4, and it has already cost one bug, 5a62019807da
("mm/khugepaged: fix issue with tracking lock").

This series removes the bool and keeps the behaviour.

> Sure, we drop+re-acquire the mmap lock a couple of times and lookup the vma, but
> isn't that actually being nice to the other parts of the system? In the future
>  it would simply get called with the per-vma lock and would return with it unlocked.
> 
> In the good old days, looking up VMAs was expensive, but nowadays ... not sure
> if it still matters?

The rwsem and the VMA lookup are not the only cost.

In your version every table is a visit to the mm: unlock,
khugepaged_mm_lock, back through khugepaged_do_scan(),
khugepaged_mm_lock again, a trylock and a VMA walk, for a scan that on
memory already huge is one pmd read.

I measured your prototype against patch 9 as posted, both on a production
config, 8G of anonymous memory already collapsed, scan_sleep_millisecs 0,
pages_to_scan 65536, PMD order only, five runs each, medians:

                                     as posted    yours
  khugepaged, nothing to collapse:
    full passes over 8G in 20s         251,180    55,477
    khugepaged CPU                        100%      100%
    cost per refused table               19 ns     88 ns
  MADV_COLLAPSE, already huge:
    512M per call, p50                  3.8 us   17.4 us
    2M per call, p50                    703 ns    703 ns
  tables walked in full then refused
    (max_ptes_none 0), passes in 20s       803       836

On being nice to the rest of the system: the scan is already bounded.
The read hold ends after pages_to_scan worth of progress. We already
have properly sized scan batching in place.

> khugepaged? Not sure if this matters. madvise? I suspect many real users operate
> on a single PMD only (e.g., tcmalloc, jemalloc). For the other ones, not sure if
> dropping the lock every PMD is really a problem?

khugepaged matters. We run it across the fleet, and its scan cost is
what decides how aggressive we can afford to be with it. I am not
giving up scan rate to keep one entry point into the engine.

For a single PMD there is no difference either way. For a range, today a
MADV_COLLAPSE over memory that is already huge walks it without letting
go of the lock at all; in your version it relocks and revalidates for
every table, and tells madvise_walk_vmas() to look the VMA up again.

> IOW, how bad would the following simplification be (prototype that needs more
> work and thought):
> 

...

> 
> Based on that, I'd rather want to see collapse_single_pmd() to just inline the file
> and anon paths, and see how we can further optimize the locking internally (e.g., perform
> the pagecache scanning without the mmap lock).

I see the appeal of the single entry point for the collapse engine. I do.

But it costs us on both the locking picture and the scan rate. That
does not work for me.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

