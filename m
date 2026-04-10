Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC506E99076
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02F76B0005; Fri, 10 Apr 2026 06:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3626B0089; Fri, 10 Apr 2026 06:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1DE6B008A; Fri, 10 Apr 2026 06:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A98A26B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:30:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B6A11A04E7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:30:29 +0000 (UTC)
X-FDA: 84642276978.05.0C2D7E0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 22E16A0011
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:30:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QYE6LSyO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="l/kn2BLP";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QYE6LSyO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="l/kn2BLP";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817027; a=rsa-sha256;
	cv=none;
	b=IzU0UOplZ2kAAZ8ucRmKMSEHcCvq7ejVaF4RtURaKZddA6D63MQaDWGD3EgjYCCxQ7kanO
	+t+DgpuggYDR3Sfl7TN/ylshl4F41XrKbCBMUmZLG73vdPa1X9Xgukr8+7FtqjXfCKsAT5
	Veh138a9q32kerQI5F8HkHgoUIWh9tY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QYE6LSyO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="l/kn2BLP";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QYE6LSyO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="l/kn2BLP";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2FJPleXejPlT976g0Q7mQc5tzNccUeW1djDhGuK4Xk=;
	b=KDVoP0ajdO4DSSXPRvkud9IxrkhyT+JOKtj/qcGMxJGLQWB+aozhx12HeaQ5p3xsxZiQgb
	CYpE+/lMywO4QdBQHUEAeIlvxBK9SofWqMZAN1JzoOmjjBpwmwxG3X24uaa0VviNTJG1Sz
	jRbqlI3vX856/4aMS59N/S+17W9Gniw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AC01F5BD49;
	Fri, 10 Apr 2026 10:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775817025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2FJPleXejPlT976g0Q7mQc5tzNccUeW1djDhGuK4Xk=;
	b=QYE6LSyOyUuxX7bt4HRstu6TPMqwU45FA94W0HROZjBxsYftJ9BxtqB3Xep7I5hnh8BRlo
	rVEe10pMpmefn0wDU0IfqEGv12091EFxxhXr87qRhjjk3Lehc+mXRoX0GpIU9iTyrmaWFn
	dz6ZN8yyU3ZXVwGcg7ZGWQMz6JKYFxo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775817025;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2FJPleXejPlT976g0Q7mQc5tzNccUeW1djDhGuK4Xk=;
	b=l/kn2BLPcgOXqY3WcgO9u5Y6Lx2JRhQJ1mBK776EakCFQwxpKn5ZiwHeQAGHrqJZDGLNbu
	wem1BBnO8o0mnlCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775817025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2FJPleXejPlT976g0Q7mQc5tzNccUeW1djDhGuK4Xk=;
	b=QYE6LSyOyUuxX7bt4HRstu6TPMqwU45FA94W0HROZjBxsYftJ9BxtqB3Xep7I5hnh8BRlo
	rVEe10pMpmefn0wDU0IfqEGv12091EFxxhXr87qRhjjk3Lehc+mXRoX0GpIU9iTyrmaWFn
	dz6ZN8yyU3ZXVwGcg7ZGWQMz6JKYFxo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775817025;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2FJPleXejPlT976g0Q7mQc5tzNccUeW1djDhGuK4Xk=;
	b=l/kn2BLPcgOXqY3WcgO9u5Y6Lx2JRhQJ1mBK776EakCFQwxpKn5ZiwHeQAGHrqJZDGLNbu
	wem1BBnO8o0mnlCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEAF14A0B2;
	Fri, 10 Apr 2026 10:30:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FoxlJ0DR2GkxegAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 10 Apr 2026 10:30:24 +0000
Date: Fri, 10 Apr 2026 11:30:22 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Joseph Salisbury <joseph.salisbury@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	ljs@kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
Message-ID: <peuzimkftq4t7kzyfyykwd2juka7z7h6mxsj7itt2fw6nehnvk@pfhser63fpgx>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
 <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
 <CAGsJ_4ztHnGYycwRgh3FaA7gsehJUWG5YY5nMURRBS6BBdqQ3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ztHnGYycwRgh3FaA7gsehJUWG5YY5nMURRBS6BBdqQ3w@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 22E16A0011
X-Stat-Signature: 9rbk47f7cw6bhep1hjst6cymk3yxckx5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775817026-828341
X-HE-Meta: U2FsdGVkX1+R+P/x+zs5P67eQGGSb2jhMs5bKnFoSX4PrFRwwQItkjC9mYmmWlZIt/MUg2BVOi3AZ1VoAAAfkhHt/xhJKyKnJ4AH+vWyuEivX/kZ+ZJUWibeDBpSd22UMXU9qNwUoHpcnnqykDcJ/aQh8m+KvntHXFkqzGvKmGiiKJ5JhZsWtLXx+m0iFWVOo2WWBgl+sPhwnQIIdBvCIVDQX8sz7WyQSvafyjyJ84vkjvMsw7QCxGSeI88CjUec0+uQXqtoDGM2CVnKNvABvLs38Jwuw+Y0nVJ4GMvM3nHGn5RfaL7+VRZisFdACvpe6QEeZzZs6HxS7UHSQi1ktxw3Di95FvL2CXoRoXTGaNIwxUQhDh/3tjVF1rYnSH1NM39k6o8Fo8Ra+FB00ebQvtYmEF1tJcBUk3nWXHoL2iru8UMMuanEQNLehKRXGDtKuNExOJSdkSbekVB2LeqQq3X1L0eCV3NoyfwUSY5yHIzurvhf3Otykwufk1fJ/fH7rYLGroo3VkhndtQ9kfiylLLgc64rtfNDXauRSSaClkEL+Xk4AVoPTgZO0+QN7F9/LiGFRLmy+JACxmGL0ItUUdIApnOFf0qHdKn/2uwOyBwzn87nShOPR/m3Cn/X9ybzBfi4kOZo3vg/UgPN74cBw+yW00HA9geluDBaUXPGy48fAl606yz/rjWOQNprixj5OzFECDcc0kKtQhvLw9I4vgN6mPBHQt3NajD6klWunr9K53KVDdvdecpfyETiNVueNCljFXCKxrk62/XOKgXvlUX2rShDUnGgdaBuRCCbGmuqDUsyLW6beX+OLCJnyYxrWwsSdrlPcDWqyiqXVthm0uyYdksfq0StlrfYoBiGwAWJosKDPMVARcWBh5PpuMzjyNJOB158y+xjJG1/qu55IbSTbmkvvTUHOIPPn8tkYDC0Fgczy1utui7+sygk16c8Y9pzx6KidxSVTO6hc94
 G0HmkxPB
 vUQdxOaqEpz5U1voKjlTgAaVBdPlatpGv3QWCuNSQr1xXqgzwbkR0lHc0zTRPX/adHTqEOuOqdlMLpiDkO8YVYW7ac/7IJdrNyPnV/rqujmbw3qQhdTKIgidqC4kdghuKc0zyhbHO6oux2arxhZK4+E5AckF8qtHlisiZCpWmJGEq8wQOi8gkfGPrxtbhXPiFgvq4qfkKXP4N5NY10rbS/8VT45d/TZpLGNdu/baL+IKFxO/Yt6PJSSKHTRijhgUtOepqRtoujsV7kj3/ZRnxcBCQU1Ul2Sm7bdnpUWKN02OmLVMecclC+0eXDbNI5aJi7fkiaa9zq/eKUeDs7tr4hs+3DuEmImeKY1Q2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 05:59:58AM +0800, Barry Song wrote:
> On Wed, Apr 8, 2026 at 4:09 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
> >
> > >>
> > >> It was also found that adding '--mremap-numa' changes the behavior
> > >> substantially:
> > >
> > > "assign memory mapped pages to randomly selected NUMA nodes. This is
> > > disabled for systems that do not support NUMA."
> > >
> > > so this is just sharding your lock contention across your NUMA nodes (you
> > > have an lruvec per node).
> > >
> > >>
> > >> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa
> > >> --metrics-brief
> > >>
> > >> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
> > >>
> > >> So it's possible that either actual swapping, or the mbind(...,
> > >> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the excessive
> > >> system time.
> > >>
> > >> Does this look like a known MM scalability issue around short-lived
> > >> MAP_POPULATE / munmap churn?
> > >
> > > Yes. Is this an actual issue on some workload?
> >
> > Same thought, it's unclear to me why we should care here. In particular,
> > when talking about excessive use of zero-filled pages.
> 
> About 2–3 years ago, I had the impression that we might need
> separate LRU locks for file and anon. This could reduce
> contention in real-world scenarios, especially when memcg is
> not enabled, but I never built a prototype for it.

Honestly, I don't think this would work. You will still contend hard.
Having a lock for file and a lock for anon just makes two very large
locks, instead of one gigalarge lock.

I think the real solution is either sharding lruvecs harder[1], percpu-caching
super-harder, or fully reworking reclaim such that we don't need to maintain
such a global list.

Alas, maybe we'll get there one day :)

For MADV_POPULATE there might be a straightforward solution, though. Using
something akin to blk_plug, maintain a per-cpu (or per-task?) list of pages
that need to be queued. reclaim would drain these lists if needed, or the
task doing MADV_POPULATE drains them at the end. It should drastically
reduce lruvec lock traffic (though yes, possibly just another bandaid).

I say "For MADV_POPULATE" simply because I suspect this idea might not be
useful or effective for regular page faulting.

[1] say, maintain a superpageblock concept that is a lot larger than a pageblock
(1GB could work? though maybe too small for large machines) and maintain LRU
ordering between those pages. though later approximating LRU order between
the superpageblocks is tricky.
-- 
Pedro

