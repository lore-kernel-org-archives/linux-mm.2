Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D073EDB7ED
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5CD6B0088; Tue,  7 Apr 2026 06:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F296B0089; Tue,  7 Apr 2026 06:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306BE6B008A; Tue,  7 Apr 2026 06:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0C06B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:17:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93A00C2530
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:17:47 +0000 (UTC)
X-FDA: 84631358574.02.784249A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CEAD5A0012
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:17:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OTdJze/U";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775557065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QYRsDVF40IDVAOxQQc+wPCmmlCNv7kRb63IoW0J9pI=;
	b=f8qzXg2mWxBCSlagz6dqO5zkl+7fc/5q6gQ4bGmaLZVhcbtUal9GoDdafjPX0gh/XECoR1
	L/dhr4tMOtLtsbl4CgLYyeHiD6GARwOFGCb5+TvpemC0oTBbhdje3yy3Z5x0yfFKX9JzVq
	Z78ZISk9QXV6pwFWJImbg07jGgmp+Mc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OTdJze/U";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775557065; a=rsa-sha256;
	cv=none;
	b=TeyqgByCr2oxnx9J42VQ5qFd8/C+ErqeoZV5pnRsyAxyMAIZqmCOztDV+bRPhgVL3W8SfV
	q5ebSfX5Ly5tKVuLtvwjCh0RXEdAQzpd1gNtvb30EzmAXnAHkQ1XlrW4CMrIacAwE73BRd
	v264a3M70shQpg1tYFz5JVpaYOzHiok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3D49401F1;
	Tue,  7 Apr 2026 10:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9E6C4AF0B;
	Tue,  7 Apr 2026 10:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775557064;
	bh=lgmUHC8bbxhLI5c9z3qLpA40C1UvYhk9kzrDrO1WA2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OTdJze/Uz2eFB7urIDq6to9bV2bSJ+ysctHnftxxSl18KpLrCFljWanYegNhtvdkz
	 vC7VgiYMfTF7+qPAvjzrM3RimM8VouU34fItpasx5TJkni63dDBcf5lUP3amcjC/KJ
	 ElXFT4djp0GyO0/PUte8LFzC/k840N9fTa8bZgaohIyHKBRMVQdelm050LKQu9YXZh
	 GH/jpMLsAUmmba6rQcgRVkQ4+18HwXtmGRGHOqylkrc0oPMmKssA8iisn408mBQRKq
	 811f4OsTPtFz200J3pHabTlzwWcdz7avHJ6TxRJDA13goEAkPNtx+/CsgkzjZz3wc2
	 NJXKrPGmw2rWQ==
Date: Tue, 7 Apr 2026 11:17:40 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adTZf_Du8vTnTGGO@lucifer>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aczOCqrCx7Xd5HIF@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 4xi1rbxrhzw4kp749nqm7cerj5ttn658
X-Rspamd-Queue-Id: CEAD5A0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1775557065-172927
X-HE-Meta: U2FsdGVkX1+v0zuhTNVFfH77YAEDbJ2X9nbs/6wNK+PP0jZy2JfGLCC6LGGtDbbGeXY23icig7YrZQwMP1sOfeyrWAOnqhlEzEAwExnxg15pPbIpZUIRDzihXrBKV/QL4MQcuSCGLNIxl2VmbE2f4MCz7g+UKyZpk7MaoB538a37P+m6Z50WX1RS+BBM6SqZm3m5HZXxv8uBX5RiIVh+ArJkYynSGYqq7dWc6NneyeoR94P06S+xnXz8eH3wrTlzyS4djmxFNNoXUPI3kT1YF7EGJyod5Vu1KlxYGcZ+UzwETQgAdNE54eHGeFGOvSgax1e62M/lemc/WlqTdnJluRyU/D78yePCu8Ky5QuHA47mlBPbCyTl87uS7A45ut9bsTD1qVuQBcH+TynYogcef+Y28lWZK+ilvIuEiBxCmU4d4+2Ek+mha989T7uHNeZEz4i1nkUHLCn7NO8KCOWLz1zlci09wj7i8OTWw3ZzxuJpIkxxl4fYabsB8C7uZtjR9jAdLuDQ4BLBXatTBzc6T11P3FieZAGQ3udHn1Lgd5SYqt3kfNGt2qWCodeKwx9774RJB+Y1RA7kvGhDpHHpcnqAgxyo0i3cDB7u0IBQBB0iRKJzIsPJoYxOay4PgX67MuKZSVuW1rSAH7hPxv+cglvard5ZEcmjlUzL7uoOjxtfyu/JXOBfN5x34MLaU+1WnVcD/QStysrd35iUnIyqN7/HCWdDdgiWy1N9WAOXoUVsA49wGvS7zLIIPABsYeWUa60WiTNgwoVC93ILa/N2svoDIv3G3mgyppu9nWJ+YjSHALylpIcWtrVFs7HFsx07Jfvt5+kHE5h77OXmSmfFQhyL1OjTUmZJUIdusLoMNywKMQ8IEgL/5hXPrqgJak14LSD4oL5TuHYePHFZbSCMJ9uC8oKjR9N39wfOtSpEirGR8SpDuymfLqMVIUHah0UzsonJ2saE/1MUmbkDC3/
 N5KTf0mT
 8gppuXvxh9rOBUeoDqFk1K15lER+4Pdjh4KXU8MuNfFZJ7AQjgJMRJooai27m2A/XAZs8iViDqn7pNAZC7TrUeavshn/XPYvwEwVMSKgj3UktVpHxdtXaJEkMzTkVJ8Ir9cE2qtLA88PNHrWvXJbB/Kno6kpmfWx8XosH7998269wkklknSAsjjLSag0fUEo8k844+OvG51XitZo3e2jou6JJzAVDMUL2zeWQrafNelJORR34nK5egjFdiQeXKMgo1uMJ1QqZQ9W6Dh2fgfuBHCf1eecd6NwYqbLY4SvNEI9SGNY3260uHROEoaiNJb7zG5ES
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 10:49:30AM +0300, Mike Rapoport wrote:
> Hi Andrew,
>
> On Tue, Mar 31, 2026 at 08:01:48PM -0700, Andrew Morton wrote:
> > On Tue, 31 Mar 2026 14:41:58 +0100 David Carlier <devnexen@gmail.com> wrote:
> >
> > > In mfill_copy_folio_retry(), all locks are dropped to retry
> > > copy_from_user() with page faults enabled. During this window, the VMA
> > > can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
> > > another thread), but the caller proceeds with a folio allocated from the
> > > original VMA's backing store.
>
> What does "folio allocated from the original VMA's backing store" exactly
> mean? Why is this a problem?
>
> > > Checking ops alone is insufficient: the replacement VMA could be the
> > > same type (e.g. shmem -> shmem) with identical flags but a different
> > > backing inode. Take a snapshot of the VMA's file and flags before
> > > dropping locks, and compare after re-acquiring them. If anything
> > > changed, bail out with -EINVAL.
> > >
> > > Use get_file()/fput() rather than ihold()/iput() to hold the file
> > > reference across the lock-dropped window, avoiding potential deadlocks
> > > from filesystem eviction under mmap_lock.
> >
> > Thanks, I've queued this as a squashable fix against mm-unstable's
> > "shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
> > ongoing".
>
> First, this a pre-existing and TBH quite theoretical bug and it was there
> since the very beginning, so it should not be added as a fixup for the
> uffd+guestmemfd series.
>
> Second, I have reservations about vma_snapshot implementation. What
> invariant does it exactly enforce?

Yeah me too.

Unfortunately my bandwidth is a bit limited at the moment, but if you're
comparing VMAs like this it seems something is fundamentally broken.

We should definitely at least delay this until next cycle for consideration I
think until we can figure out a sensible approach.

>
> > I've fumbled the ball on your [2/2] unlikely() fix ;).  Please resend that
> > after -rc1.
>
> This one should go the same route IMO.

Agreed, let's delay until next cycle please.

>
> --
> Sincerely yours,
> Mike.

Thanks, Lorenzo

