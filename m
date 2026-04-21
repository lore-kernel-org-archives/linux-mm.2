Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E93F8FA90
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 16:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D372F6B0005; Tue, 21 Apr 2026 12:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1116B0089; Tue, 21 Apr 2026 12:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF8C6B008A; Tue, 21 Apr 2026 12:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A56876B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:42:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40BF813C0D0
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:42:25 +0000 (UTC)
X-FDA: 84683131050.03.2BC3B3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 729EA8000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:42:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ccCwTj2N;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776789743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xJ0Xh8/waC9soM/askF1aJThTNpA8kZnktokrlP+h94=;
	b=GHvSRhwAPAlCtKCCs/iT8WUKbgEqobsZ+o3143MMBJQwx9PvHVVnfH/RzfVMEhYbXeix+/
	jKx1azbQCTUnCKyo0ZywO+dMM/VEfS0kC7QlT6wcPu30HrkHIZ6SiR2BXVZHtTCbKhEH5O
	lByLp9eFbW6FOwjIM4C7hq+oLMRaIHA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ccCwTj2N;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776789743; a=rsa-sha256;
	cv=none;
	b=0Yt7JJTcU4FTUQpZXWQhBFv7pJbU0JnygWQUwMwf7NEQFGeRyuvaEvm2mEKK7H9QvL+Dke
	ToCSXFIWhbcrgScy4NMts57pCxQ9toG2By+XjQeVFiYzNDgKxGxqz9ku2QLby9LThr26Wr
	77TGR2a3S4JkBnq9biZPJG9CFfkyv7Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C71B418CC;
	Tue, 21 Apr 2026 16:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15079C2BCB0;
	Tue, 21 Apr 2026 16:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776789741;
	bh=JHUdJcWSsSnWxOqPGvR/AgzSfIn9zeu1UZu2j6kDY6Q=;
	h=Date:From:To:Cc:Subject:From;
	b=ccCwTj2NJX3R6TH+8LvbJdLqKIecfvBEeWbcxSl3JH+Pz0CBRiyTfibi3mcxpCHBI
	 QqjkdOqGq+1qnNXzsDyGEd+4AdaP6j6JVlDwv3WI+29w4OYiV709qrkra7GIThh45N
	 Tr9sz/6/skJU2T9I8Z2ov9smou6rH1yvLBfxtESc=
Date: Tue, 21 Apr 2026 09:42:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>
Subject: [LSF/MM/BPF TOPIC] MM transition
Message-Id: <20260421094216.8dfe14a8c62f2420fa5aace1@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sb1ukwc5puc5jhyhh75diwgwxccwqqn3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 729EA8000C
X-HE-Tag: 1776789743-47417
X-HE-Meta: U2FsdGVkX19vCYsO6eR00AuXfcmKGEsbdKq/p4lC2Yn/ryCtnxvKQdqolA4hHqrn3pO0+MRQtsUsi1y8SwpziKZqCsBQ4jmgmgqt0sg475jfRIvGGPXnUjrb5l8cTLPbcuGZwjRqHJSAATKvbv204rucF4vYJ2LNrP0ywSKo1or0UnAgZpGVQ4KZGxPmSf2xJD3lRtnkwyMxD5pgj348FNuPixY7G8fAG0mILe/vvCH7gaB3+EwOVblyTQi8hB0Gar+Tfwd4C1/sJc4i9GUcexgd8JJeevQKdjHrwvhEYhfvuSll/oph7ti1xazd+dfFpRYyjT5TrTOfMX0rcYHZMxatr1vzdFVrL0B8cIR81bBBW2kOzyLrsTsRag8PPsLA3EPsbVDijWJiW0VpqRov0IhDkp4KH6aAalmoSZHzi7jgMmJkvLgjCydnooOZQAOan17x4u9UI5h4+KvaKEulhgzO0KUnM7ZM5Thp58JYs90+M35jWGqkNLIR/qTYsLchSzxm/5kFOqRJGx/AUmGCGqj+gD02aUcTxv5iaVGG44hhNJ4NNEva49WHLQA+6TEJcQKrI21zAOlxGJp/szE859siYRhbSB6iMGzCxXNeDIedWaZ0RtZxTl17/0GF60p5a9NhbFw1hip+5E4l5CnpuWqp75zMRsdDqgJ+skAqUxuT8FiyBN/OK3+ZrILb6e8pUmVTfyE1iayzpFbWV8wicN8Mmit/tDeStZ2QQ7l7ZgV9OCYCJxa0uidSBo58TJYbdqYDf5fILyVFijqonxqPKdU2Egpdt+7BlZqr2xXAtztgq9C3+6ErDODgQuhiN9C7mDYG5AkWcCpM/J8JUo7a12SWYNQ4JKeOMCSIJsvx16wmPPGXE/5qm36TX/hHQoG4FSpZh2lcWaVeEviaoXcpZSikM5A6FL/o/aBUNWmvs+rmPsvWB5xAgbij6eH6iECCHczrbKMCuhzTiOT8Zvu
 IF6KA5j6
 DOE7DYWPCufIXbD7ktHkEdoGnakqej9jPB3G5wD21tVgNUMoVCN0nYctcmEAsvmX2YdH1PE4vDtzeV6Speiucl5k1CgDYesJ6rdbjCaM4IAbWtVSOvUIqyivBdbIrimTg4BarRBB8qGx9PvV5a8Snj66R7XahDTDqXMAMFdNqROIZYQHXiYqsSML93NoNlxP3U9HJ1b32+PfadipOqqS4l4wiC23DBV5RmtNlkeUYWll8Rr8xXZuFu43cyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi, all.  Some things I'd like to discuss in the "MM process" slot at
LSFMM.

I wish to start unwinding my MM involvement.  Because I'd like to be
able to retire one day.  And because things feel excessively
concentrated - I'm doing too much stuff, others have valuable views. 
I'm healthy (enough), plenty motivated and my mind is still sharp
(shaddup) but bad things happen to 67 year olds and they can happen
swiftly.

I want this this transition to be gradual, orderly and incremental - no
sudden changes.  Give ourselves about one year to do one thing at a time,
re-evaluate at each step, make alterations if needed, on to the next step.
Of course, we have our ongoing mm/ development work and let's avoid
disrupting that.


The model I wish to move towards is a more conventional top-level
integration tree (working title "mm-next") which pulls together N
component[1] trees.  mm-next is the usual source of our mm->linus
pulls.  mm-next will have a hotfixes branch for that material which
we're fast-tracking upstream.

David Hildenbrand has kindly agreed to set up and operate mm-next and I
hope/expect that David will take a leading role in this transition.  

("mm-next" isn't really an appropriate name, but mm.git is being a
namespace hog - some renaming might be needed)

mm-next will initially contain mm.git and, I hope, any other git trees
we can find.  slab and memblock at least temporarily, if Vlastimil and
Mike are agreeable.  I want other trees in there apart from mm.git so
the tooling, processes etc can be worked out.  An "aggregation" tree
which aggregates a single tree is a bit silly.

Once mm.next is up and operating and the pulls are flowing smoothly, let's
introduce one other tree.  This might be "vma" from that component's
maintainers.  Then another tree and so on.  So mm.git gets smaller and
smaller.

I expect that as the backup catchall, mm.git will always have a
significant amount of material.  It will continue to act as a hosting
service for Maintainers who don't wish to operate their own tree.  MM has
~38 listed M:aintainers; many of these parts are small, with low change
rates and M:aintainers have differing levels of engagement, and that's
fine.  Also, there are parts with no identifiable maintainer, some
maintainers will sometimes be unavailable, etc.  Also those little changes
which nobody feels inclined to look at.  MM will continue to need a team
Mom.

I plan to keep running the mm-nonmm branches.  Kernel-wide team Mom - it's
pretty quiet.  And maybe mm.git if it's small enough, if I'm not getting
in the way and if I can't find a sucker^Wkind person to take it over.

For this discussion and in the upcoming meeting please let's not get too
far down into the weeds of tree structures, workflow, individual's roles,
etc.  At this time let's focus on the final implementation and upon my
plan to get from here to there, then we can discuss details.  David will
be hosting some "transition workgroup" meetings after LSFMM to further
these matters.

Thanks.

[1] Terminology: MM is a subsystem of Linux, so the various MM
    subsystems are really subsubsystems.  Confusing!  I propose that we
    Not Do That, and start referring to the various parts of MM as
    "components".  So mm-next aggregates component trees.

