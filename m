Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82DEF531D6
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 21:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F3C6B00A2; Mon, 13 Apr 2026 17:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FE86B00A5; Mon, 13 Apr 2026 17:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255646B00A6; Mon, 13 Apr 2026 17:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11F796B00A2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:23:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BBE856947
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:23:28 +0000 (UTC)
X-FDA: 84654808896.04.E68807B
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E7D0140005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:23:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D7QKdTHF;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776115406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yI8J2cXzEwopatsEgqidYN8N2g5P4kB/2yo2GpS+P7U=;
	b=R+Nj5dk0ROItYsYRQgMQhKBA8U3bWIUoZ79JyRqxKmqQz+Kx0MedRglT3/3XoGnYhBXepj
	9Hxal9zNnWSOw5/ClUOTtgo1iIjJ+oxuTVTpc8iY1Eov2OwrET04lZHdAyW7V3o1JVDp4u
	RrnOCveL/ugm0xVHQt2kxRV54OEAXXI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D7QKdTHF;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776115406; a=rsa-sha256;
	cv=none;
	b=cxoxisWfn8XLPlw5r9mR+s/YTd7cBf1DRblDFoX+wuaAK0nOXiV0Cv/8Z1Y0fugp6Se6z7
	OpcGnMc6stPo6KGRSPXEEuQ8KMg3xmiUQ7MsEMi4TZklErBC+LIpDllrJZKci96Vo4np14
	fXxyDVWONpftpHtGTaxJZdp8oMQOC9A=
Date: Mon, 13 Apr 2026 14:23:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776115401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yI8J2cXzEwopatsEgqidYN8N2g5P4kB/2yo2GpS+P7U=;
	b=D7QKdTHFaq/RjbXd8/DvRJ2OQdNFnKdNdh2OdyaDhsWmNEdF82Ktq6ob3qr/AZT/qFI8nk
	gMagaeWYpzzRPvATfta9l+8Q6ZjMmhCrM76idR/FgeQdR6MO9cdPQFuirZAoZOdWzvE1WA
	f0Zjkmnykf46SsHhAa6ViP9mA+IgCkc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <ad1QfUWEPSCDUDYv@linux.dev>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E7D0140005
X-Stat-Signature: r78bm6e6o9gohjcwpwocd6pdnaiufaat
X-Rspamd-Server: rspam06
X-HE-Tag: 1776115404-667971
X-HE-Meta: U2FsdGVkX188xmfxyrYATf/dd0T5WzyUur3TWwIKsCOivkkeObZbKF/L+svei7JDMZDd5BzMmk7zKxI0UK402H/mtD1/6O8PdoqsUeF6slfZys/Rvxuof8M0i3d/H/IkTE+ppqqH6QhXhCp3fsqFTPuyPnoGQNdUGRsLSo7uA6VRPDRvXAcQGYVZhFoaqwSld5/SUK4XIMS/xDh4tfMQXIWxXPALYcS2ARiUuc5bghG+/tpbDLonrZ+jy5Mm33gKZ7cwAfy1RSRNhCJIJZeuPmE4qiPlDgpcMWhtX3XPLdovHsyD9ZL00H6aLZMG1AdQr7MvQPsw+EQfl2EgqOGkquf4FWhusBISMVJqADpDiR+gMBs1V1Zxe0DomHc5yIB3jOFMQFlbeX+owe7ZhYwOTRQsDgr5t8RW4rsfxl/kxFWHL/Pqi/1ypQTkV7hkFlLJdw5Ez76QWJ/sbKyCRj6fdjOjoJhIZvFsqFZ2w0Ulehqd3e6wyVC8wfqbMhvsoJcVUAEKvhL/rRwc7kSdmTmCeRTqIzd14MmHm/dXTPWmVJZZ6MX/MjzCuolUX7zRGsKaC1eahcSkOSrgRChpPxo4cYpXXq+Hb5LaoZitM/1EpBUVRKEXkN6gWLtdIpqacQyU+cTJGP1uCWymwZh3u6cbq8jJHaKN2YXscc4a0yzmzMVNsrFtd5oIxn7aoit94f9Z3ncj1twlXrCXBI+yIDZJQVzCUgdhtEWHF9GutkOCHB9ZkuoF8ayKwdhzQJSYpXfsQ/KG6vaJyDgIHkWC7D/HgzzpMS1I9SeR18xgNmt1v+ScSsqQCNvIbcZVXsAgDp3K4da36ZEpjqyr3rjo8D6QVrWP7eKQCNgW68Me0hycUKU/c7sPXTUVSRm5dfd70XLLCQohdtm2r9rFt0Xkub+ZHdIXs7BTMWDYHFN+exMBVqY0cz0GsmtGQs0UD7C5Aum/fwNeNcHg/xJQa8pLfWY
 4n74vbPe
 2dEw35GGJ0wBE3zQi9huql+58r8Lz2dK/vwZYhaq+GX/7CVQlmhhLWZ1ffqKP0R+pXaq9SHFscgQdCN45ySIl5GEmxAsm8YsCyXjQsxg1buvCZfjHth6wl7wRj4ifmvhgnDaDjt6rtgfehF16ufJBNSq0bgocTGi7egPw4mlnmosB9qxB/q9T8nZz4voUioBZQEfwbK30/h5Otbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jan,

Thanks for looking into this issue. I have couple of questions.

On Thu, Apr 09, 2026 at 11:16:44AM +0200, Jan Kara wrote:
> Hello!
> 
> This is a recurring topic Matthew has been kicking forward for the last
> year so let me maybe offer a fs-person point of view on the problem and
> possible solutions. The problem is very simple: When a filesystem (ext4,
> btrfs, vfat) is about to reclaim an inode, it sometimes needs to perform a
> complex cleanup - like trimming of preallocated blocks beyond end of file,
> making sure journalling machinery is done with the inode, etc.. This may
> require reading metadata into memory which requires memory allocations and

Some of these allocations may have __GFP_ACCOUNT flag as well, right? Also are
these just slab allocations or can be page allocations as well? And does the
caller holds shared locks while performing these allocations?

> as inode eviction cannot fail, these are effectively GFP_NOFAIL
> allocations (and there are other reasons why it would be very difficult to
> make some of these required allocations in the filesystems failable).
> 
> GFP_NOFAIL allocation from reclaim context (be it kswapd or direct reclaim)
> trigger warnings 

I assume these are the PF_MEMALLOC + GFP_NOFAIL warnings, right?

> - and for a good reason as forward progress isn't
> guaranteed. Also it leaves a bad taste that we are performing sometimes
> rather long running operations blocking on IO from reclaim context thus
> stalling reclaim for substantial amount of time to free 1k worth of slab
> cache.

Agreed, particularly in the multi-tenant and overcommitted environments where
unrelated direct reclaimers have to spend their CPU time to cleaup/freeup
memory from others.

BTW I think kswapd doing such hard work is fine.

> 
> I have been mulling over possible solutions since I don't think each
> filesystem should be inventing a complex inode lifetime management scheme
> as XFS has invented to solve these issues. Here's what I think we could do:
> 
> 1) Filesystems will be required to mark inodes that have non-trivial
> cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> whatever :)). Usually I expect this to happen on first inode modification
> or so. This will require some per-fs work but it shouldn't be that
> difficult and filesystems can be adapted one-by-one as they decide to
> address these warnings from reclaim.
> 
> 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> performance reasons. I expect this to be a significant portion of inodes
> on average and in particular for some workloads which scan a lot of inodes
> (find through the whole fs or similar) the efficiency of inode reclaim is
> one of the determining factors for their performance.
> 
> 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
> to process them.

This async worker is an interesting idea. I have been brain-storming for similar
problems and I was going towards more kswapds or async/background reclaimers and
such reclaimers can do more intensive cleanup work. Basically aim to avoid
direct reclaimers as much as possible.

> 
> 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> inode, doing the hard work.
> 
> This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> and they can work on freeing memory needed for freeing of hard to reclaim
> inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> they should really be addressed.
> 
> One possible concern is that s_hard_reclaim_inodes list could grow out of
> control for some workloads (in particular because there could be multiple
> CPUs generating hard to reclaim inodes while the cleanup would be
> single-threaded).

Why single-threaded? What will be the issue to have multiple such workers doing
independent cleanups? Also these workers will need memory guarantees as well
(something like PF_MEMALLOC) to not cause their allocations stuck in reclaim.

> This could be addressed by tracking number of inodes in
> that list and if it grows over some limit, we could start throttling
> processes when setting I_RECLAIM_HARD inode flag.

I assume you are thinking of this specific limit as similar to the dirty memory
limits we already have, right?


