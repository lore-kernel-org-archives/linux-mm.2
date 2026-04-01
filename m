Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 665C810FCAEA
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA736B0088; Wed,  1 Apr 2026 17:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1E46B0089; Wed,  1 Apr 2026 17:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFB16B008A; Wed,  1 Apr 2026 17:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B09A66B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:48:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 468DF1B6EC8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:48:43 +0000 (UTC)
X-FDA: 84611326926.11.A9FD644
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 57FD640013
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:48:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oRoFhmas;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775080121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJbYhrcMdyqdUCdloK0PLg0Z6SDZ5d3JkKLdQiJiWBQ=;
	b=2FCRjQ//06SFemQZ/e7vRhR9wDQxz6A/GLMNfrzO/36HodsUYHoL+4XtYkmDM8OChS4fwO
	sjloxpcY4napMZeQn90GKYrHaMz/67DyoJB24u/7lrfmsh/W0GjSz1nYZ6XXEGZNsG0AKL
	hT59AOnK32sCu/EbT+tTp+1glI8vPwM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oRoFhmas;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775080121; a=rsa-sha256;
	cv=none;
	b=tCJes5I0r/uESSXJUTW0ExDi4HjIuvLZGnINAhlguO6nFXMcmK269uNsOETydl/s0uWIrX
	6oKajjZcnqrNPY8rFMMGvDTk0HWyoa42mTLJvj4hOToasxkP0GH3s8GS3pLZlCZI1OCOG9
	rWZ6VL1sjDNVGKX6mcycQhiSjeZ4G4s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D2BC40381;
	Wed,  1 Apr 2026 21:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F860C4CEF7;
	Wed,  1 Apr 2026 21:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775080120;
	bh=DNJaCNZdFC80zGgJFtAuVlv2J8uV9wtsJdfASUh6qrI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oRoFhmasNi1W+kf51MBZlPjvlrcjkvN/UGWInXlI3S+Xz5+GenIfIzdHhFXX6Y2H8
	 cMdQlm83BYIK82l+hreGER6Wn1Ati6ozJ00tJig6GLJiyT3A3oRrpFfEljAk51Azdh
	 JFOu1iTB0R4bpScWLf39NP376IFOGgRPRDgRV4a8=
Date: Wed, 1 Apr 2026 14:48:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, richard.weiyang@gmail.com, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kartikey406@gmail.com,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm: fix deferred split queue races
 during migration
Message-Id: <20260401144838.e07cebebb625b2810257c2ec@linux-foundation.org>
In-Reply-To: <20260401131032.13011-1-lance.yang@linux.dev>
References: <20260401131032.13011-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 57FD640013
X-Stat-Signature: s4ie7i93tfmbc5y45e6uu4oe1q6qhm6k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775080121-110396
X-HE-Meta: U2FsdGVkX1833waeYAqwwrZzt1tha5D1kK3CIVuCCecU9xMC5xb6kO4PnVhNT7By4YtBzO7RD7YYW4wcTk+ibHEug2+oM4/gWMHuYLv6j4zbxptEzlUGXqyJn95IdjHciRCp2FS6SYM6rToG8CdFHwLB+zRBwkFcrUj7xGx66IIkib/DGpH6fOfDlyTPpby7zF60GsMEy8n5U8kZeappw80PLfJH02xi3l1cpItGGtX8OK/3m7IMkqA+Nz4R0GSDZ7V3fURprLrzZCYQ03rxwQFr+RpuqG285ZoHhGESTThnLizsKhc3q/7U/erQ7oTFYMpb89rtDyDrdf05ED/XstGJZ9GOTXK0v/PX8FXGRiwWqX1rGTTmHdBX3QgtzPJ7lo2FHsuiY0e+N9/XD8wp987X8RL++zdE5q6UP5PAB0Qgk3NBb4rsmHl+5KpKpr4evTV34uqCVOIb31Pdjw8bVR4xf63oV1nCG+T2PN6NJD4J1T31nEQxtLbcNqbxVD7dQah2S0l/+kiXyxiXoBLTP5dQqzXwASIOrDxm5Ti7t4pjKU9AK6wzAMTyFrekK0w0CYAjIFnc+uee75DqjaDreNXJB3SK8mS3pXjZyGeAe4OofB1pRYUsA6YNib4iXxl12ZsIpggPJVQmOEWr0B2mZYE9f+Fnq4Sd8M4YqNJ/Us9hmb7/CRFWLfqJOP/g8IHAuLv/2Z+u8g885J9ojT+cYGrDT9yD4qk82PkmDVw/FiVWhMwYTBJxetdpLB/1tCVyD15urbs9IRT5jha+7BuGHZeR05qNB/zfeU3Lc6g4lt7QOnu0f26oXv4YnAL7fNHQyIXBa0Kf2odxJcOTsY6yN0OYmR+tuqqXPIMmW+IZw+U7tjMEzbLQdSjnJh1UBAVmyas+SsBA9rdiguFQ824O/vycafvMJm2xOZg0yJ63I3TSMyxXnpzEBmWY7CKYXAD2vYXuXuWLdJra1/MBeuW
 PIL0TCxW
 kbp/CKm8dcT6UjmlBwMbUxGOPDztbDp5HlCrep3mTrikZoUxhEnAYHQhYCly6lg4fTDUo7MgzXMa3dxnJ99VDmSP8JIwb7dW7ihNW3arFiP7VnZ+0MZEGC0LcXq7pYnPvRj1U1yKG/+xHkH1NkJdTbdEKMmGN/2fOQ3T8sX5nRqG67tql6RDNrP0IM4QUF41Ag4P3HkCefFfBvdfdQC/sqITQpVxU8yNqlZdt+zSmLK847XXBsHwiOxyL55JIPWBPJTyMOTtZhYNzYNFbRAOuR3CGEXRF9aYh4IM5omXDzLjXOq61BqGQ/9JlfG3efz1WUGjBsINpNqmunLQ+Rxy3PZ+BM3oSCCPuL0n9tT8PLG+eg4pOhGiB0eqAzGum8zHA8YiQJEMwPIa4Rt6vo6dngs2+dyBdbLYqoEmLI3d+QELk6FJ+r5cDjaHz/9Di5mJZZV+zngF4Dz2fxTHFwt45WmnJVXkoWvkSXIHsnT6dfrs5AZGkebApFWXg1r5Aje4p4uKU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 21:10:32 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> From: Lance Yang <lance.yang@linux.dev>
> 
> migrate_folio_move() records the deferred split queue state from src and
> replays it on dst. Replaying it after remove_migration_ptes(src, dst, 0)
> makes dst visible before it is requeued, so a concurrent rmap-removal path
> can mark dst partially mapped and trip the WARN in deferred_split_folio().
> 
> Move the requeue before remove_migration_ptes() so dst is back on the
> deferred split queue before it becomes visible again.
> 
> Because migration still holds dst locked at that point, teach
> deferred_split_scan() to requeue a folio when folio_trylock() fails.
> Otherwise a fully mapped underused folio can be dequeued by the shrinker
> and silently lost from split_queue.

Thanks.

> Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
> Cc: <stable@vger.kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

I'll add this to mm-unstable with a plan to move it into the current
mm-stable batch in a few days.  So that 8a8ca142a488 and this
follow-up fix stay in the same bundle.

> [ Backport note ]
> This patch is a follow-up fix for 8a8ca142a488 ("mm: migrate: requeue
> destination folio on deferred split queue"), which is currently only in
> mm-stable, and should be backported together with it.

As far as I understand it, this should happen automatically. 
8a8ca142a488 has cc:stable, this patch has Fixes:8a8ca142a488 and
also cc:stable.

There's enough info here for the -stable people to figure it out!

