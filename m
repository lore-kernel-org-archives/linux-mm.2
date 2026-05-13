Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8E3CD4F35
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844CE6B0099; Wed, 13 May 2026 07:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CE46B009B; Wed, 13 May 2026 07:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732DA6B009D; Wed, 13 May 2026 07:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63D596B0099
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:02:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 169491C0187
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:02:39 +0000 (UTC)
X-FDA: 84762108438.12.8BF63BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 56A7340006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:02:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ipHxZ5KS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778670157; a=rsa-sha256;
	cv=none;
	b=yOBW12/dgeIa7pDtfLeGlawuqLnc7yaPgr5htUowArp9SPNm95ZkAkNA2Qc8yQ/gQncGdc
	UyYJ72GisHU8dJawx56giM2ZEHrlfUpd/VaJxCjUQJBpo4bExR3HR8WxbIL758RZJFkYKF
	PJzXdzBwGH4ns25y0VSR+wLVm1TvIHI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ipHxZ5KS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778670157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVZFKxSfM7SAGz1cMbw3aPzx5EOMIR5l/rjE59cmJPA=;
	b=A5vbFkRx3q7o5rmSa+/czOtapsmgo0iwLWRcR/aAfi59ltEafC+takCvz///SP8z81nGbR
	Tph4+NXQWRE52ltQgEzjz1ky5mOAGtBu+lhjAgPQKORPvTV1Sz0A5wKq7s08M9FwPkv+tY
	7eh7xp8Tl5dtyPA4cog4IHhPnDDqdrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 648C441ABD;
	Wed, 13 May 2026 11:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9C8C2BCB7;
	Wed, 13 May 2026 11:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778670156;
	bh=nnZHtK4i4FoXFTFVrb7e0AfQto80JKRsQyrHKmhMWPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ipHxZ5KSIEFkUOvp6RWk9GYNLe/OWxCv+/2HYW4xTh1FIudx3ZTHkWbsCh2Bk9Lqh
	 v+WlSXvJy/aT5HKZnYCnmCykrEpsgBLlh8/GUDQN/R3ho7Hv8+QgJY5q1hv6h/7ffO
	 zBm5lFnwm+Cp38kL1tuM1kPERHEpzrRKI+DvY2LxJUJ3m04mIB+z4VMsMQNQwP7X8o
	 aa46i/1teBeEnJmJy7QN5u188xMZwGGx39HJJfmBCqWp6n1e4z6Nj3tSmuTGKbnCTz
	 sxZqdi1SYZW7kmgdZOUyxjnrusLL9czCk0hm40Wn5zV4zUCDi6FXQrPZsIURw+eXyJ
	 b0eHqzzzCLAOg==
Date: Wed, 13 May 2026 12:02:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/hugetlb: avoid false positive lockdep
 assertion
Message-ID: <agRZ_DdOHzDELWOg@lucifer>
References: <20260513085658.45264-1-ljs@kernel.org>
 <291cd4df-7c52-426e-a8cc-b0cf77654c52@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <291cd4df-7c52-426e-a8cc-b0cf77654c52@kernel.org>
X-Stat-Signature: ysp8446hs9shgtcd66icjfsruthh3dtx
X-Rspam-User: 
X-Rspamd-Queue-Id: 56A7340006
X-Rspamd-Server: rspam07
X-HE-Tag: 1778670157-625231
X-HE-Meta: U2FsdGVkX1/L5wSQ5onzBtvyNT1x+6W/tq/DAlhacfBONL244NMtdNPwdEBFEVDetKrqnHFrVun5Vq5sByoHhUInm2rLASKadkCPTQgg9+XlrbzUkYdjIJYK3z6Y7bj3wBCj+uSWC5NLnS4Qf0I/aNLw+ENGp91vYriJd6Z2+Zg0GmiBtS5F169Gg/vrh3hWLzyp9PTAf/5/aETN5ftXJ7yOoNfVz6EjPnjTItFjFEE/n6j/3qmCZCdXOzdnJX8ISpqvG5xTWyk6cU2t8vFX30tdjft/QeoUggMRx2lINLhX0xk53xloAIj/HVRbiiOcC1AZpn+vsJegpsYAKWy0wWcgf+kAAolyDxu3VWwh7KX8XuAXUQAMgAcMHWMHy0cVGDuYFU7YsRDtc7UU4YDRx59WFdJ/3VuVEc/hvTFyDp+OlGSqZlKwoPRGkIQi6XHJBPniVhyuPnUdFXODks8fJkJkn/SKGqsZAPV3cZYkdSjUtagN7i1wGcz9Z/8gJ+2aYYz3VWANe05IKxIKSnlJCl42/EFoSAXV9bLgbvzAkfmWzu+R0m3idopXyD4tV3POtONG8gmCH98v/jmS5kg14x+cts8heozRZPn8fNg5ShB6CBB+gr55SVM96D+BxANcUmw6U5nfAr4Fq4RB2yJEnWMJHfOFFl5N8HHTc+trZ4E6J+cIDtG/7w+sL6jpSwPVAp83J007oSQbTO2WRhjPWLA0ygBpi5n44nxwAjN2XvFlWOKXkTnkz3wnRAquANjTyqQf7JVjcAUQ82emuwCleu4x8tEEvvs190yJjdlwl52Yw5ZTfwYgBDMKiNbbvl4XfQZ6QRLOjXASWmcVEaFtrAj6rQyrpWCzLRvYBf2IjsOo8ZfbxX2jcCePzN94RcG/zS2VNPB9P7amRiCn9t7fUqrq5os8WyK8QpPP9QwUDERR6CasUJmw+pQMMC/HN2w54iJUuGzdgf2CtoQq4GY
 u/38pHZn
 r3p4o8lPCCNtR3TB1zYJIb/3eGK7DK4YK6mX3wSCFd0MMTBtx+fOqe+KY6VqKMdU9Qr3+TQAHuHlMpzWukYzbArctMHxUvT60QhQJtA3zch8WFsYW/ieV3l2N2zOETFfTpeergZTrDAe0G1Y75lb11u13Y3bYnYXUYV1MwivPvxK4r4+814+3yyBtvfCxYbA0sr8+jfy/vgSt9cwXoJWQjcUO6RKvQsneB7tVtIOBl8barSA7kA9w9FfM4f5ORkJX7JFgZrsYlR/WdIoyU3Li2gLF1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 12:15:23PM +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 10:56, Lorenzo Stoakes wrote:
> > Commit 081056dc00a2 ("mm/hugetlb: unshare page tables during VMA split, not
> > before") changed the locking model around hugetlbfs PMD unsharing on VMA
> > split, but did not update the function which asserts the locks,
> > hugetlb_vma_assert_locked().
> >
> > This function asserts that either the hugetlb VMA lock is held (if a shared
> > mapping) or that the reservation map lock is held (if private).
> >
> > If you get an unfortunate race between something which results in one of
> > these locks being released and a hugetlb split and you have CONFIG_LOCKDEP
>
> "hugetlb split": I assume you used that terminology because of hugetlb_split().
> Which is all just rather nasty #justhugetlbthings
>
> "hugetlb VMA split" is probably easier to get.

Yeah another one of those overloaded terms :>)

Andrew - do you mind doing s/hugetlb split/hugetlb VMA split/? Thanks!

>
> > enabled, you can therefore see a false positive assertion arise when there
> > is in fact no issue.
> >
> > Since this change introduced a new take_locks parameter to
> > hugetlb_unshare_pmds(), which, when set to false, indicates that locking is
> > sufficient, simply pass this to the unsharing logic and predicate the
> > lock assertions on this.
> >
> > This is safe, as we already asserted the file rmap lock and the VMA write
> > lock prior to this (implying exclusive mmap write lock), so we cannot be
> > raced by either rmap or page fault page table walkers which the asserted
> > locks are intended to protect against (we don't mind GUP-fast).
> >
> > Separate out huge_pmd_unshare() into __huge_pmd_unshare() to add a
> > check_locks parameter, and update hugetlb_unshare_pmds() to pass this
> > parameter to it.
> >
> > This leaves all other callers of huge_pmd_unshare() still correctly
> > asserting the locks.
> >
> > The below reproducer will trigger the assert in a kernel with
> > CONFIG_LOCKDEP enabled by racing process teardown (which will release the
> > hugetlb lock) against a hugetlb split.
> >
> > void execute_one(void)
> > {
> > 	void *ptr;
> > 	pid_t pid;
> >
> > 	/*
> > 	 * Create a hugetlb mapping spanning a PUD entry.
> > 	 *
> > 	 * We force the hugetlb page allocation with populate and
> > 	 * noreserve.
> > 	 *
> > 	 * |---------------------|
> > 	 * |                     |
> > 	 * |---------------------|
> > 	 * 0                 PUD boundary
> > 	 */
> > 	ptr = mmap(0, PUD_SIZE, PROT_READ | PROT_WRITE,
> > 		   MAP_FIXED | MAP_SHARED | MAP_ANON |
> > 		   MAP_NORESERVE | MAP_HUGETLB | MAP_POPULATE,
> > 		   -1, 0);
> > 	if (ptr == MAP_FAILED) {
> > 		perror("mmap");
> > 		exit(EXIT_FAILURE);
> > 	}
> >
> > 	/*
> > 	 * Fork but with a bogus stack pointer so we try to execute code in
> > 	 * a non-VM_EXEC VMA, causing segfault + teardown via exit_mmap().
> > 	 *
> > 	 * The clone will cause PMD page table sharing between the
> > 	 * processes first via:
> > 	 * copy_process() -> ... -> huge_pte_alloc() -> huge_pmd_share()
> > 	 *
> > 	 * Then tear down and release the hugetlb 'VMA' lock via:
> > 	 * exit_mmap() -> ... -> vma_close() -> hugetlb_vma_lock_free()
> > 	 */
> > 	pid = syscall(__NR_clone, 0, 2 * PMD_SIZE, 0, 0, 0);
> > 	if (pid < 0) {
> > 		perror("clone");
> > 		exit(EXIT_FAILURE);
> > 	} if (pid == 0) {
> > 		/* Pop stack... */
> > 		return;
> > 	}
> >
> > 	/*
> > 	 * We are the parent process.
> > 	 *
> > 	 * Race the child process's teardown with a PMD unshare.
> > 	 *
> > 	 * We do this by triggering:
> > 	 *
> > 	 * __split_vma() -> hugetlb_split() -> hugetlb_unshare_pmds()
> > 	 *
> > 	 * Which, importantly, doesn't hold the hugetlb VMA lock (nor can
> > 	 * it), meaning we assert in hugetlb_vma_assert_locked().
> > 	 *
> > 	 *            .
> > 	 * |----------.----------|
> > 	 * |          .          |
> > 	 * |----------.----------|
> > 	 * 0          .     PUD boundary
> > 	 */
> > 	mmap(0, PUD_SIZE / 2, PROT_READ | PROT_WRITE,
> > 	     MAP_FIXED | MAP_ANON | MAP_PRIVATE, -1, 0);
> > }
> >
> > int main(void)
> > {
> > 	int i;
> >
> > 	/* Kick off fork children. */
> > 	for (i = 0; i < NUM_FORKS; i++) {
> > 		pid_t pid = fork();
> >
> > 		if (pid < 0) {
> > 			perror("fork");
> > 			exit(EXIT_FAILURE);
> > 		}
> >
> > 		/* Fork children do their work and exit. */
> > 		if (!pid) {
> > 			int j;
> >
> > 			for (j = 0; j < NUM_ITERS; j++)
> > 				execute_one();
> > 			return EXIT_SUCCESS;
> > 		}
> > 	}
> >
> > 	/* If we succeeded, wait on children. */
> > 	for (i = 0; i < NUM_FORKS; i++)
> > 		wait(NULL);
> >
> > 	return EXIT_SUCCESS;
> > }
> >
> > Fixes: 081056dc00a2 ("mm/hugetlb: unshare page tables during VMA split, not before")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
>
> LGTM, all rather nasty with "take_locks" parameters ...

Yeah it is, but since that's already there, I guess this is the easiest way to
do it! :)

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Cheers!

>
> --
> Cheers,
>
> David

