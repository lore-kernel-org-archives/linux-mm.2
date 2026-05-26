Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE733CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B2A6B00D4; Tue, 26 May 2026 11:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BFF6B00D7; Tue, 26 May 2026 11:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188B36B00D9; Tue, 26 May 2026 11:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08DE16B00D4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:23:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8C06120357
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:23:37 +0000 (UTC)
X-FDA: 84809940474.10.31169E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3CA9F2000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:23:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDuK0YBS;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779809016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pn6lDdvUYTKkSBMw3yepluGky+KaZAI74satoVYpEpQ=;
	b=KFbtSng38bP5rpWgEcbBUTgtinl/AFjrpPgyzSK5p5lFATzyctLAT11EfZ0tX88Yv05cWU
	OLNqkWH9zUwe8IcwETEsN2kikuBo4PkfAawlvLL0KAiFkGWxEUsEmeUx8NFubuTnqsKG87
	m4jxgIY6CH4zTm1HQ4VmFjFHW6FKzsY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779809016; a=rsa-sha256;
	cv=none;
	b=VhLiHiEq6Nl7x6Zj7IfIq44DVoQV99o73fizmPKccGGvmoB5MARAavYoX/SwqMHe6WbO5G
	uyUGy8q0j1SRnD/aMclyjE7tLASkYzyqM7CUOx7Ad+4FScKxymLVv2JrlYSo0fYVN+koKQ
	gLVGgTLe4hBHOta8G2fnEOXJozNIJlU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDuK0YBS;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B55C26008A;
	Tue, 26 May 2026 15:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A1F1F000E9;
	Tue, 26 May 2026 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779809015;
	bh=pn6lDdvUYTKkSBMw3yepluGky+KaZAI74satoVYpEpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BDuK0YBS08KgRFVabkIm6k7EsJI3pcFaNvckQbAgAv6dEylkVkNhfQl0AmWkh131c
	 883gxURZUnTvXro0zjELP9AeKCjYV2nzyvoWbPynnKog3bsf/Pd6xzjvkifnbImdci
	 3s8SePW2nmEpDU6byGdBjRiqH/oukzXZ3xfqOq/cASGItx+K/W9B2/46UU56ymXL66
	 H+hDYPA6lxDrVrZzJ0C8D7vwVYrG4rDatRnlyQeqRaljVP7mDJiPsInO47hW64/hCV
	 iUXvLQIG4DKCe5r8RJc3ZYT+G+tzV8UBp4U1AHkrCiPL3fPY7eAwuaxrTgISFToQHO
	 9rrD5uagP8THw==
Date: Tue, 26 May 2026 16:23:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <ahW4jWLKk4RjwNtS@lucifer>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
 <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
 <881cec2a-9425-49f5-b96e-4595813a4384@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <881cec2a-9425-49f5-b96e-4595813a4384@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: ositaccxseoz5z56eg95nsff5tr9yet8
X-Rspamd-Queue-Id: 3CA9F2000C
X-Rspam-User: 
X-HE-Tag: 1779809016-216093
X-HE-Meta: U2FsdGVkX1/zafQ20vBgQE0f0j3v32oVxKxL0JH+JUcaKHTaXDoXxgEM+HZeNjfqD9U2qSpqVmzDFAGCg/eGvQjHvh2uMBVOha2WvKrLob4f+X0HzF6XPDzam5oOt/odCeyBhwadPjAafPbzRE5LhkSkG1ZT3Mlvvo/OqO4dM6almK9+O/ECn9zTjuhmdxNtJksRAR5Dte4HVgq2VPMyIIg+IBBBcEspXHVx6fwTwr6UTwn9Bo6Z+XdwS9Ps4feXriKoFDuAguLQiRAWG1MyjzB4N6C9lbrIFRUeFuJQhF3kLU7fmJ1jYeNwFTaVwwIldW4a7uJvTipi3+alCna7hGQubb6DB1J/quGXUU8283lHXLQ7NHJiMh/kVTOxZtNf8u9BukwFi8vcpI6zqUGPcQCZF/m7Xb7TSkAJ/QWNbLOJxVl4CBzYXHim1r3gmyHxuLnJlYMzZKpaUw7BHFoaVpWeO2pFtXYcbuidS8xUtxCp9wkrVShn25lR4Zse6OR7E7GQ086blg5E73zm8kEb87bfsOT9FRuQy/WuZFQPAQ8fh+8SKg8WbMY7qkL7+T0ux09UnMUHhcnyTr5q9FiJ8w5FmAg+m4CQhOe7xuX7jXgF8JQBy0i0+JOSVvorU3LhemmMXrR00jwCA9uyU0D9kmey0IrzGrml4Ltpp0QvtA34c8mcOrPmqKTqFDacnA++z3DyjqilCiujr3V+jm+BEvxEBeNvzPVY5kqLNuXyzsSoyE9PtDBekBl9wHmf8q2UTfFsYP+1hlh8UcHFXoPati+T1J7hBKHOPllJumnKB8qmIY4aL7cqn1FlioGP3b46VjstfyYse0crUfmCFp+cRrQwfvq8WO3HZ4mnKvMtMUXjbVNmCV/EIpkWuqDOKhn7B/1/aBZwp/cbBdi1430AZE6hEYIL+ZK8+RZK/N9pEU33T3Iwipi2QOOT8puCptPF+EPevz8mF18t3Y6CtbK
 MMN2iLzu
 wJbbU3gtu90owpM3qkS1XJqw7zvG5dN4E397j5XqGYIiOPPQn0LOeudzig0eaRw24C2qib9VZEfjpLX6yOrzgQk+tGXzdhftT4OpdfifQVR3fKABMO5zgeheiQ45tzqduVKepPwBOACir6d4TfKD9k3CNAkBKt+xQe9iRv+SX0Hg1jH4xCfoXhE21rFfDvhrg77Yyfz4U/7JYKzULzRyx08LJ4wd+11yhfyqdAdF4YRns01u4y/M7DuGfH6tU/coqO0xeM7hhWUMDwKyf38tMwYGk+XNhu8pSyV6yTbLordH1oLexoBIMIOiRCgHf8XYZhGBeVdL34lvd6cQZXQeXrASbc7wrZDDfneUJ+z355fiW8r8e1ms9u+ZQvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 04:03:03PM +0200, David Hildenbrand (Arm) wrote:
> On 5/20/26 15:48, David Hildenbrand (Arm) wrote:
> > On 5/20/26 14:53, Mike Rapoport wrote:
> >> On Wed, May 20, 2026 at 01:09:04PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> As this is all uffd specific, I wonder whether that should be "struct
> >>> uffd_vma_snapshot"/"vma_uffd_snapshot" etc.
> >>
> >> It's local to this file, I wouldn't worry about namespacing until there's
> >> an actual need if it will ever arise.
> >
> > Indeed, fair enough.
> >
> >>
> >>> From a high level, this LGTM.
> >>>
> >>> I wish we could identify relevant VMA changes more easily. Like, using a per-MM
> >>> sequence counter that we simply increment on any VMA changes.
> >>
> >> Do you mean per-VMA?
> >> Per-MM counter would capture unrelated changes, e.g. an masvise() for
> >> unrelated range.
> >
> > I was thinking about a per-MM thing for simplicity. If there were any changes,
> > we'd retry (-EAGAIN).
> >
> > IOW, something like &mm->mm_lock_seq, which we have for per-vma locks already.
> >
> > Not sure if unrelated changes would really be a problem in practice (another
> > thread gabbing the mmap_lock in write mode until we serviced the fault).
>
> Assume something like the following:
>
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 180bad42fc79..608bb3c3a613 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -448,9 +448,12 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
>  {
>         const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
>         unsigned long src_addr = state->src_addr;
> +       unsigned int seq;
>         void *kaddr;
>         int err;
>
> +       seq = raw_read_seqcount(&mm->mm_lock_seq);
> +
>         /* retry copying with mm_lock dropped */
>         mfill_put_vma(state);
>
> @@ -472,7 +475,7 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
>          * (e.g. replaced with a hugetlb mapping), making the caller's
>          * ops pointer stale.
>          */
> -       if (vma_uffd_ops(state->vma) != orig_ops)
> +       if (read_seqcount_retry(&mm->mm_lock_seq, seq))
>                 return -EAGAIN;
>
>         err = mfill_establish_pmd(state);
>
>
> In case there is concurrent mmap_write lock, we'd retry. But we triggered and
> resolved the fault. So the retry would just succeed in copying from the page,
> not triggering another fault here.
>
> So I'd not expect this to matter in practice?
>
>
> We'd have to implement &mm->mm_lock_seq also without per-VMA locks. Which
> wouldn't be too bad given that Dave proposed a patch set to just enable per-VMA
> locks unconditionally.

That set unfortunately is broken for its ostensible purpose AFAICT, but the
idea of making per-VMA locks permanently available is good and I hope that
we land that at some point.

>
> As a hotfix, what you have is probably better, but a simplification like this
> might later make sense.

Hmmm, but the proposed logic absolutely tolerates changes to the VMA that
does not alter the fundamental properties being checked for, so this is an
entirely different check no?

I don't think we can both say that we only care about properties X, Y, and
Z changing and simultaneously tracking whether a VMA write lock was applied
since we dropped the lock?

Also a VMA write lock having been obtained doesn't mean the VMA was necessarily
changed?

And then couldn't -EAGAIN cause spurious write locks to abort the operation
altogether?

Given reacquisition of the lock will fall back to waiting on the
mmap_read_lock() if the VMA was write locked, that makes a race very
possible.

I mean maybe we want to tolerate all of the above and just move to a safer
world where we conservatively consider any VMA write lock acquisition to be
one in which we abort the operation, which I think would be nicer...

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

