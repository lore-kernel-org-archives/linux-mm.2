Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0BF1CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D466B0291; Fri,  8 May 2026 16:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEEB6B0293; Fri,  8 May 2026 16:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C326B0294; Fri,  8 May 2026 16:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA29D6B0291
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:57:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 783DB8B3B3
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:57:36 +0000 (UTC)
X-FDA: 84745463712.27.868606B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id B502BC0002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:57:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dVjdGo1W;
	spf=none (imf10.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778273854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu8daim6qkcaeD6OUpYjQtJ/V2hKZECcF7+XQco/y+o=;
	b=1u3zkRsYD+JOJpO8Lq9z5Jw0qCQiqOYZMd6FO67oEXSNGOKwmyAJ6xrtNUKhBwoXwJbAzK
	j0aV0hZnmA1RbFlS5gLjcOZuq6xLzP0u8oLe/4ZGX/fcNnDRjOVfwcyzvTLliA/oetkURM
	5e3nEdfUemt88rm5ZA24eUU9sZXAdr0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dVjdGo1W;
	spf=none (imf10.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778273854; a=rsa-sha256;
	cv=none;
	b=ow+YsGooVNVc68vUBP4DYaz8zgRIRmqwVrZMgFdTaKWbL+dGjzke8dSdjV/hrjaDTkt//u
	FIbaGL12avU6IDXGV3i9MWUP19sYjY3zARoX+SXB/+kZHKomZ9QWgA4oKU+gHjJUaB2q2i
	uflbBvCO8L0uBrYWZFbFoW2Oma7TxPA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mu8daim6qkcaeD6OUpYjQtJ/V2hKZECcF7+XQco/y+o=; b=dVjdGo1W+YqvAgdP/RzAqBIFIE
	S7PuZ1jYjDbsjnOIUcYBZeQl1zUPvNBz+Q7B7iHt3F2LRKZbLV9nZ1Kr5ocUh3TRqYuMkmqXQrZpr
	2FXeNgegJCfy9yq17MmHgnSCJOvgVXFivFQMDnUBmZuxju84WovJBsGnbRjlAVd6guDPMIsks8ZKx
	RbmBoiNFmyPfuIThUtGeqknQoGTuW7RsQFua9OAaSUL+6Rcn68hUTLAWtBZJA5YpAFcKR8eIpNM1S
	1RRrsvg1pa8dmWgWeA/QQfqLH8jDXtkAYdudncw5hToS+HDomPyvyvJYqsOPeZ0Qz7I/8olqKKMRZ
	xfvN/SWA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLSGI-00000007VHt-3YCB;
	Fri, 08 May 2026 20:57:31 +0000
Date: Fri, 8 May 2026 22:57:31 +0200
From: "Liam R. Howlett" <liam@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, hca@linux.ibm.com, 
	linux-s390@vger.kernel.org, brauner@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, timmurray@google.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <7g5g57jbll5joujbwjb4osqhdwqd4yzc54wmoi7ftx4a4chuax@xtxyljtqaodp>
References: <ae-Zu-VAzAA7SdLa@tiehlicka>
 <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka>
 <afFco71vwmpQy3pk@google.com>
 <afG-4hq7Hr62Uu6J@tiehlicka>
 <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
 <afHeXY-yeTwmURWh@tiehlicka>
 <4a612d63-2838-40f5-ab67-79bf35dd3a56@kernel.org>
 <afIZQOtaBabeHtCc@tiehlicka>
 <b2d9fe2b-abb0-49d1-8056-ac93aa232bbb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2d9fe2b-abb0-49d1-8056-ac93aa232bbb@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B502BC0002
X-Stat-Signature: ucigqk4az8e3gwigzdmmswccafj17icn
X-HE-Tag: 1778273854-290980
X-HE-Meta: U2FsdGVkX1/9YzI9bGLk5fYCuBiT0vN4WUkpQP6shNvK5qqDTc6nn3PE83WSP+yT5lnOsPO944b3VB1yedEcPMtQ/RVshId/37sJ+h3I0VMrtNIoeUKa4DzuDwk/vrwo/Yoeh+U9u+k4h3PYw/SCdjZXw0lx4CpUrFwUO5khTcCQqG3TmF8YIVKEGgx/8ecMeLOR4uTu9mJCMdeB4BoHR4MwhB3bRLPi4TlcG44gKbvlpsctIf3P9irRL68gRVQxlChMjDdD3xyB5Mj+dcGzKF2O7eMkba2xZxN2lJQRc/ljRCFbyYhHj3PZ0xxqDm4nx9k97jMnsqqF/Poy8AoTOh498UwmaF63P7INtBsRg64rP3GBrq/LGwqCOhOAQK8rXfUsixpK+OCg6YiyptF26FwCRz+uUJsr+y1CKfDh+qoGf4l4v2OIAnvSKH1m1vtAuC3Vcs+TbXrxlFmHZHIFg3EcgV85ajc+6+EE4u2lECI/0KvSrop7O2zXN7m+B/z6VPhO8In3Ac4W7E/pF+G5teR+TDlOr1xT6jFJiXrNar5tgZRYyVJjAduSoL0/lINJrlv1S92K8vE8twDcfUwmlXH+F5njKz04Z6Slmd4PeJgPCvp6apA1TQ+lnoermS+xMxN48K4HULPstDOis0jC9VxQBDskqkCyJOijrcBp1IC8imr5tiBpNPjQZDWnC8GKKcPn5XmO4+W+DtBpU9uiBT8NCWvGl8rFpo/9hchCpEvD55c81pAzvjUKtLJRk2KT6eUd7rlF0H9BRVqeIoYe5nXXW/AyDyI72xj5ot2Iu4bE7BTHBB5Qw+iDOTSDN6jaQRxW0xtWecXVHlLINTWFjzlHKM3v3ejXUOrX2P9USFIdC/R9vgULBMuAfpJC0wzFMGuargvDur750Uic6ARFWjdwgvLj1qgtD4rsAYY5d5EZWALnHwnuLYAz6Zwg9QR5Xw6s0PdpCNDNMNRLNNG
 fppO2wrg
 2/8Nezp2HVYvZ0mWFyW4JPnEY3NIS91w7RdozJSThLdgROwWd4csNMpD/DWABlmQMq2YZtibOY2JJ4bcqyJPvnXqN7lb78CQSvQWB88vBEzedL9GZW1VEuplpPYOPOVu9dUrY3uxHBe6Un2+SPe+ebSqm90jFk/GSRRPlU1z0G7jknJdE0cq9LO1K/EUC8XdEtQNXVCXk+T6ryLPx+jrcUTHeGN0QGR3UImfwt4FQt69mOT4+ENZ+Q0vfbdTg1mVdW/jvhCtqou9oCCmJ6xbyAFk34XysJhuCrlMsfatX6yv4ZDyqYA85qID72d7Qn4U4SjwWtSmBWkZ40e1Yxn+9ef92A1knF8NxYeShszmH4+dnvQGcOZlDNum5V0ayv0G9HRIDJfhbGJ90jWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/30 08:08AM, David Hildenbrand (Arm) wrote:
> On 4/29/26 16:44, Michal Hocko wrote:
> > On Wed 29-04-26 15:07:04, David Hildenbrand wrote:
> >> On 4/29/26 12:33, Michal Hocko wrote:
> >>>
> >>> While the oom is the only current kernel user of MMF_UNSTABLE (in a
> >>> sense it sets the flag) the flag should denote that any page faults are
> >>> reliable because it might fault in a fresh memory and user would lose
> >>> the previous content without knowing that. Not sure MMF_OOM_REAPING
> >>> would reflect that reality better.
> >>
> >> We use it for failed fork() as well, but that's slightly different semantics (no
> >> real page faults ever made sense).
> 
> Well, there is a difference: a failed-fork process was never scheduled and will
> never get scheduled.
> 
> In fact, we added the MMF_UNSTABLE to the fork path in
> 
> commit 64c37e134b120fb462fb4a80694bfb8e7be77b14
> Author: Liam R. Howlett <liam@infradead.org>
> Date:   Mon Jan 27 12:02:21 2025 -0500
> 
>     kernel: be more careful about dup_mmap() failures and uprobe registering
> 
>     If a memory allocation fails during dup_mmap(), the maple tree can be left
>     in an unsafe state for other iterators besides the exit path.  All the
>     locks are dropped before the exit_mmap() call (in mm/mmap.c), but the
>     incomplete mm_struct can be reached through (at least) the rmap finding
>     the vmas which have a pointer back to the mm_struct.
> 
>     Up to this point, there have been no issues with being able to find an
>     mm_struct that was only partially initialised.  Syzbot was able to make
>     the incomplete mm_struct fail with recent forking changes, so it has been
>     proven unsafe to use the mm_struct that hasn't been initialised, as
>     referenced in the link below.
> 
>     Although 8ac662f5da19f ("fork: avoid inappropriate uprobe access to
>     invalid mm") fixed the uprobe access, it does not completely remove the
>     race.
> 
>     This patch sets the MMF_OOM_SKIP to avoid the iteration of the vmas on the
>     oom side (even though this is extremely unlikely to be selected as an oom
>     victim in the race window), and sets MMF_UNSTABLE to avoid other potential
>     users from using a partially initialised mm_struct.
> 
> Which was later changed in
> 
> commit 43873af772f8138c5cb4b76dde9c26339e89be3b
> Author: Liam R. Howlett <liam@infradead.org>
> Date:   Wed Jan 21 11:49:42 2026 -0500
> 
>     mm: change dup_mmap() recovery
> 
>     When the dup_mmap() fails during the vma duplication or setup, don't write
>     the XA_ZERO entry in the vma tree.  Instead, destroy the tree and free the
>     new resources, leaving an empty vma tree.
> 
>     Using XA_ZERO introduced races where the vma could be found between
>     dup_mmap() dropping all locks and exit_mmap() taking the locks.  The race
>     can occur because the mm can be reached through the other trees via
>     successfully copied vmas and other methods such as the swapoff code.
> ...
> 
> and I am not sure if MMF_UNSTABLE is still required, as we don't leave these
> stale VMA copies in the maple tree.
> 
> The process might just look like just another process that is getting torn down now.
> 
> But we'd have to learn from Liam :)

Yes, it will be a zero entry tree now.

I left the flag to indicate that it's an unstable mm, not for faulting
in but to be skipped in OOM events and process_mrelease since neither
should bother doing anything in the window between the dup_mm() failure
and the exit_mmap() window where the write lock was dropped.

We can safely drop the flag now if you want to, because everything has
to deal with an empty vma tree anyways - a race can occur between a call
to unmap everything and the task seg faulting.

> 
> 
> > 
> > The bottom line is the same. Make sure PF fails rather than silently
> > provide potentially corrupted data.
> > 
> >> Looking at the original patch here, using MMF_OOM_REAPING to modify zapping
> >> behavior would be clearer than MMF_UNSTABLE, I guess.
> > 
> > Ohh, you mean to add a new flag, right?
> 
> We could do that as well, if it's of any help.

I really think this goes back to the life cycle of the mm being somewhat
difficult to figure out.  I'm fine with another flag.

Thanks,
Liam


