Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E38E9DE6E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2F06B0005; Thu,  9 Apr 2026 05:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953F46B0088; Thu,  9 Apr 2026 05:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842D06B008A; Thu,  9 Apr 2026 05:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72E566B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:16:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B40E16064D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:16:57 +0000 (UTC)
X-FDA: 84638462874.26.CB63EB7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id A9440C000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:16:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cl2KFsBd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OeDSb5yP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cvjDxRnw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hT9LRiOr;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775726215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sGJ0OlHjX4pzaN/+U1PaKFUh61nxkXNQRA9d/Udbj1A=;
	b=UXrntIV9Ljdzsi4khW4a3CuwP7C+183U0wZKH6Pt/COm5NxSrE7xXQrVxev+gRQB/m/9aA
	hSafMrjb8Egl9Ly56/9Gt6KPIbH4LVnF/qjcSX9O1rRZoiSnj1/bXlMzoE0B+LnYq75d2G
	zhE7uJgeTUpNOjhi/5pYSCfHlUCWx+Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cl2KFsBd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OeDSb5yP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cvjDxRnw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hT9LRiOr;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775726215; a=rsa-sha256;
	cv=none;
	b=GLth+zqJbZqjsez6pv88uW+dOCu/ueD4vh51nYO3ixsIm/Fj06vZ3bYojwXzMSUGGBz0MG
	/JYk/5ruXQ/6xgKZVylanqySlkgF3SmQ9UJxcFmkgpk9Qa06+nQi3dXWEBYQ4TtvBb4qRf
	wp0WqlMFOHT34txjR4TaKwfoKv5BRRw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1C584EE6E;
	Thu,  9 Apr 2026 09:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775726213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=sGJ0OlHjX4pzaN/+U1PaKFUh61nxkXNQRA9d/Udbj1A=;
	b=Cl2KFsBd0NNf5T3cMlrgNZ9JdJgbCNohOoWbQDCCJYDTxBfJ0XQsmRMVA1j3IRFZN3oFf4
	3APFfJqYtTYYya+QrObagxm1Dz/yfE4srJ2VnvmTgPjOvFxafV1IJDoziDphlL/L2oppwF
	Zfj5ART7BgbD1UzWt+YJq75cEczowHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775726213;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=sGJ0OlHjX4pzaN/+U1PaKFUh61nxkXNQRA9d/Udbj1A=;
	b=OeDSb5yPLoFewX+U5tmdUAN+FcqjwngXChdeJJGPxAI7qSfTK1WwZCxoktpkGUvupXzoVs
	9zZolrzcUriAfnCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775726212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=sGJ0OlHjX4pzaN/+U1PaKFUh61nxkXNQRA9d/Udbj1A=;
	b=cvjDxRnwx32fjl0TKqDidz4CeStb2rfEisTGBm500CvxQ+bU/WKOwo5iZcRQvFC3ZfNrli
	LlkFpdHkAvyiHA1oiN9xt6fMwkEeTHSmMuo/I6r475CtFKm26+5oIWR7S9Uts7TguFqCoN
	qwi2HeEXk6OUrvETVnsPghzpDJmv19A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775726212;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=sGJ0OlHjX4pzaN/+U1PaKFUh61nxkXNQRA9d/Udbj1A=;
	b=hT9LRiOrWfkLHz6cWp+9iiJcFoWS/MENUswK30amy/J7wlx1ZIT91EAO8UqSt7Laa7ZJpb
	KFWbKAqlN+8laGDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5B304A0B4;
	Thu,  9 Apr 2026 09:16:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VMfHL4Ru12mTPwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Apr 2026 09:16:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 75939A0B66; Thu,  9 Apr 2026 11:16:44 +0200 (CEST)
Date: Thu, 9 Apr 2026 11:16:44 +0200
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Subject: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A9440C000E
X-Stat-Signature: c6uddgu9cu53p67fikcoxfn8rmu7o3ck
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775726214-556877
X-HE-Meta: U2FsdGVkX18CeF0URbqNLG9og/P0uys8vcWMSe25X1dLd0H9RzBggkfT8RGdCNTtKdaA99lKgE9+LIq06b3qSzHCSU93G+NA9qHpWBoXEEGflSFWmIHnWrzq4U0INLalrikHU8iNUu+4SLKTOksIUvGpLV/1fVXwYJN2JshaD00vLkO/nFWnG0rKWpRIaBM0tCvY9IVLUbQx/82evLe3vpf2diR1ml+jjejlWmbzPMeFkvaARmUk1j/Hodj0e9mJBb1Mm8jbsOyaPTwzqUbRsLQ0uxIJkRy9g6H8b/hoiw/wfuQVPRgZ/RXE+FfDET6A2m+aJ3snVr5D6XEwC2+CUnhTBOnQFyuvVO7ZoLL6qFcBTMpIDOzJEjLBRlcBleER9VQi0IcFwQ4yapSRwER+sznT0kLGNq4rWFEKXHc0bhe7g6oCyel/ybQj+FGVxvetim/TStJPxs5jnodA4SEABncrkefniAbJuLakTPmqf3F/+AnTYtj8bukRyKpNoN0Vo5vNWHLiK5vLFYorHd3/CO3pMLYqPIeZvSugqk03Zbe9CFs9wUkxjxjL5O/VJv6VuNzkryrfB97EVDWvQcbtBVYBLdM51qJxV8/5rDw9DzrUSbGtGzWeVp+2CyXjcA4p542L/507BvLFi/O0R0CasltOwpebFdDGsS6bU4h2vwb/62uchmT2BADwCAxKV8OokG6hyYYIaINJgCd4l3ArV+gM9lzLgckEJ4hdtW1+iBVww+NQdkxd9fGsjWgTK4VdC8B/tATt3w5kUAVEqCAwcoRYeJfXBGXRSf1/EV5VI4yK3grc2JRh1TmADbklMJfCYhUGvpqZhMl1EvIQPB7wvaBCcmzkyaxr4iWyDekyunhJVLzXRHkXD7HzlfyWdljqlswHNLVuqvh5JRQjcV2/2Vvj887bvUbJ/c3ruMgh9bCkstaPhFdTU9Kkl+v653m6LFT1wVATLE0xbaIL1sx
 3oYFSVzc
 v26IMNh2nBpFCtbehTbpxseQiFjG2xppwifomAciZs9vK5lACg79zB2Y1EIlSJJPNrafSyM4bu0gfXIVR5isThIW16ifB8Pp8mt7AM7D0j+8BHnt6nHUFeL4PO1LmRBGccmtgPy3P2YuoGAiTY9yLFFjTlwajyv4lj7S4SAu2PweE5AKUkEpkzi2L0yrzL+K5SqjG0Xdj4DgLR/4/kyJ7ZFsDo9ov5e1toS8tPHakXlz/8LPHvLswgix1+EgJgXaszJHt1taEIWN8wmIX5LWKlxIBZJCvfestDYMzCUBbY4MErDCGFzmT3EUraCrPZwE44Se/afeZq1N/F1JSU9yJMDslnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

This is a recurring topic Matthew has been kicking forward for the last
year so let me maybe offer a fs-person point of view on the problem and
possible solutions. The problem is very simple: When a filesystem (ext4,
btrfs, vfat) is about to reclaim an inode, it sometimes needs to perform a
complex cleanup - like trimming of preallocated blocks beyond end of file,
making sure journalling machinery is done with the inode, etc.. This may
require reading metadata into memory which requires memory allocations and
as inode eviction cannot fail, these are effectively GFP_NOFAIL
allocations (and there are other reasons why it would be very difficult to
make some of these required allocations in the filesystems failable).

GFP_NOFAIL allocation from reclaim context (be it kswapd or direct reclaim)
trigger warnings - and for a good reason as forward progress isn't
guaranteed. Also it leaves a bad taste that we are performing sometimes
rather long running operations blocking on IO from reclaim context thus
stalling reclaim for substantial amount of time to free 1k worth of slab
cache.

I have been mulling over possible solutions since I don't think each
filesystem should be inventing a complex inode lifetime management scheme
as XFS has invented to solve these issues. Here's what I think we could do:

1) Filesystems will be required to mark inodes that have non-trivial
cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
whatever :)). Usually I expect this to happen on first inode modification
or so. This will require some per-fs work but it shouldn't be that
difficult and filesystems can be adapted one-by-one as they decide to
address these warnings from reclaim.

2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
performance reasons. I expect this to be a significant portion of inodes
on average and in particular for some workloads which scan a lot of inodes
(find through the whole fs or similar) the efficiency of inode reclaim is
one of the determining factors for their performance.

3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
to process them.

4) The work will walk s_hard_reclaim_inodes list and call evict() for each
inode, doing the hard work.

This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
and they can work on freeing memory needed for freeing of hard to reclaim
inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
they should really be addressed.

One possible concern is that s_hard_reclaim_inodes list could grow out of
control for some workloads (in particular because there could be multiple
CPUs generating hard to reclaim inodes while the cleanup would be
single-threaded). This could be addressed by tracking number of inodes in
that list and if it grows over some limit, we could start throttling
processes when setting I_RECLAIM_HARD inode flag.

There's also a simpler approach to this problem but with more radical
changes to behavior. For example getting rid of inode LRU completely -
inodes without dentries referencing them anymore should be rare and it
isn't very useful to cache them. So we can always drop inodes on last
iput() (as we currently do for example for unlinked inodes). But I have a
nagging feeling that somebody is depending on inode LRU somewhere - I'd
like poll the collective knowledge of what could possibly go wrong here :)

In the session I'd like to discuss if people see some problems with these
approaches, what they'd prefer etc.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

