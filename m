Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E45CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CBB6B008A; Wed, 13 May 2026 06:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DB86B008C; Wed, 13 May 2026 06:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E926B0092; Wed, 13 May 2026 06:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D24806B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:15:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78D3D8ECF3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:15:30 +0000 (UTC)
X-FDA: 84761989620.20.2195120
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id BFE46C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:15:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SuIPOCoI;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778667328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htEzZXLUkX7+8GBDV22ZNU5RKYUW3+8QnLgxbzo8G0w=;
	b=OVq2bb5dWcG7a5c0yx0E9Lwxh7MFh4f9JRi/XXXOkVfisF9uT7JYpg7PGhyvoAKEK/dbDm
	aTmoCW750mC0AY68J7mOOLS5lwHOg50Ma0EXbZMjub5VfJVkNB/ukVSlsTsCYJRCQccJ7x
	4iWN8ttVzqOQnREzjX/NnSxnGzHzovs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778667328; a=rsa-sha256;
	cv=none;
	b=PK5whcVY9VwWB6eBpWbJRYCDOehrUWBDxwUZwZGBsqwnKJMDY3GTEo1hxu3XMFDJDxgtay
	rbA9xR05WU3inpGoWbE1KjGqcqitx9UW0YW0v3dtd1D/O8XC8skvj8Et39nRTihMrCBe8A
	T2kkzotNifY+t5FrTWQKBbP0xn6YXOA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SuIPOCoI;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B3FC60126;
	Wed, 13 May 2026 10:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC99AC2BCB7;
	Wed, 13 May 2026 10:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778667327;
	bh=q2O5EU1M9LAwDFxvC1kACL2BPQVBEFSmu2p0v2BeLTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SuIPOCoIGr7Ez0zRklgTOxZeEf5a4KuTjvQEHwRuH7qe579n73wzkYJVUkyZuLTcC
	 PYUOvVhj4dTRXFqR3j/B6y282fRhKCg9lZdOL0IerEk49jJvwjE1RkwIEKM7BlaiSz
	 8FvBzs3Qsrlsr+R03e8dSeskq82c3yVH6cfpEPoaEiccOKTISiOx9qmmwcKo3SzQgu
	 KonCtkImdVpAprhnP026Lbvhbdgyz5T4CLhiR/zxCfWHIfN677n4Ejb7ubuHEqG6/k
	 DW+txvCTPFmkzu5vKxJUyo5YmL87aBcRgXbfBZoUg8BD9lkP6AaXN2LH6IhCTR0cEB
	 3Ff/+S9BSJ6Kw==
Message-ID: <291cd4df-7c52-426e-a8cc-b0cf77654c52@kernel.org>
Date: Wed, 13 May 2026 12:15:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/hugetlb: avoid false positive lockdep
 assertion
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260513085658.45264-1-ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513085658.45264-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BFE46C0005
X-Rspam-User: 
X-Stat-Signature: arjn3o3sgzfres3mket1wx4zggo54k7s
X-HE-Tag: 1778667328-392656
X-HE-Meta: U2FsdGVkX19mkpQxvcKVgD36P1k46MG6eKqH4WALIS/72PIYQJBi0IhvO7uU4Yu1EMO6CQEW6O3gC66g/WiDksJQZ9e6TiuWujJmbzE8cmkDFb0CmVU6Wb6nenMaD+tQLiKFoauQoqpOxt7TqR3fxj+LAfI2BZpiyWyKs/Sa26DWikjtfLreOtDu6HyCHIMjeigFHTBSbfHVn9IlpmOK8X3a1wHut+8ewJ86g9r0KGEmbyUzVgBi1jlLCUCVZx6UOEYLwCMBkBNR5OdIkz1FLlmNBVJc1ivWEp2wF8NFMUMEVRzwvEVFa91iw+PaB5ebgwvTCtx7Vd9J1g1WxYR5Ye5bNK4fDn2fOwGcT7lMCLOVkkiN8YiVpwv0LjTvsw+bM5QMrqC9FhQsiKDjLeGGP8FKKpliC2rs/310wblyTqfvX6WHSM47sDMalUSERvQWFMlpj9c7WAa37IIW1Znvq5BkFQ12e6fbLuND8q/CnoFg/MmpqgFTQF8zQwcf/bHftDJEu46iprDIVweiMK/cM3/vFq+W2FhpzM6brA7g2vEf14oaOpa2he5n6GbAkJ3xcKE2kt2Wfkr8gFM0SvHn09uJZ/34Jk91m99i88G4TFubDGKEDRm7FtgwlXoSFXtLhtVLNOlQU2BrVrdnoY54JkI0W4jLjHF2Oxc3Z3QghjyXQaORXEkmZghzlSEtDEqxmPww+c6mVL9yCmDhIMOsPL+Ov8g8a8UMQatrUhCHrJBBtKTzYQAbVwCJO9Nefun0b5GJJb95642z2kXOxcw2cMK/ytTyuqk8Ykgi/NIBHvqbt9dnadO1xWEUgMLcu5S4c0KmQrL2npwydOWZEnXoKEPspamWSaROxbumLYIufRZprOLzejjXt95sveF0x2a/8Ihr02XMt/D9LqG00lF9BeH85JqnZNkpiBBCk0CYcP++Bb+9E0X4R7/zzkGS8vgJgolAHfvyzy1qF8BF491
 uKVA9lcu
 KthzLN85w0XRcANJPpiu0wRJZSXs3Q0ogg28HCXM0T9ZN/oW/23m+4eQOJRmG5Rq9A3mm45Icp2suQ9zTYp1iXmLv186III1TED6rgSblRHqqTZlPnQNKAXjrf7I/kfzTIYaK/wRyAMgyUTmZAcj+z367hRhIxPbiio93SDXQu13ZGo0F1qIw/0+Xo0QrvLxTLHgd6xMz4iO1zOBAg9hGIh1sKablzhwig+fpF5n8dIdqCo54Mu2J53p6fHQ58CuktwjxobWeqSFHIWuU6c4sdrZCBaPUN8KC6RYL63d+Gltp/x2orP4+IGrCig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 10:56, Lorenzo Stoakes wrote:
> Commit 081056dc00a2 ("mm/hugetlb: unshare page tables during VMA split, not
> before") changed the locking model around hugetlbfs PMD unsharing on VMA
> split, but did not update the function which asserts the locks,
> hugetlb_vma_assert_locked().
> 
> This function asserts that either the hugetlb VMA lock is held (if a shared
> mapping) or that the reservation map lock is held (if private).
> 
> If you get an unfortunate race between something which results in one of
> these locks being released and a hugetlb split and you have CONFIG_LOCKDEP

"hugetlb split": I assume you used that terminology because of hugetlb_split().
Which is all just rather nasty #justhugetlbthings

"hugetlb VMA split" is probably easier to get.

> enabled, you can therefore see a false positive assertion arise when there
> is in fact no issue.
> 
> Since this change introduced a new take_locks parameter to
> hugetlb_unshare_pmds(), which, when set to false, indicates that locking is
> sufficient, simply pass this to the unsharing logic and predicate the
> lock assertions on this.
> 
> This is safe, as we already asserted the file rmap lock and the VMA write
> lock prior to this (implying exclusive mmap write lock), so we cannot be
> raced by either rmap or page fault page table walkers which the asserted
> locks are intended to protect against (we don't mind GUP-fast).
> 
> Separate out huge_pmd_unshare() into __huge_pmd_unshare() to add a
> check_locks parameter, and update hugetlb_unshare_pmds() to pass this
> parameter to it.
> 
> This leaves all other callers of huge_pmd_unshare() still correctly
> asserting the locks.
> 
> The below reproducer will trigger the assert in a kernel with
> CONFIG_LOCKDEP enabled by racing process teardown (which will release the
> hugetlb lock) against a hugetlb split.
> 
> void execute_one(void)
> {
> 	void *ptr;
> 	pid_t pid;
> 
> 	/*
> 	 * Create a hugetlb mapping spanning a PUD entry.
> 	 *
> 	 * We force the hugetlb page allocation with populate and
> 	 * noreserve.
> 	 *
> 	 * |---------------------|
> 	 * |                     |
> 	 * |---------------------|
> 	 * 0                 PUD boundary
> 	 */
> 	ptr = mmap(0, PUD_SIZE, PROT_READ | PROT_WRITE,
> 		   MAP_FIXED | MAP_SHARED | MAP_ANON |
> 		   MAP_NORESERVE | MAP_HUGETLB | MAP_POPULATE,
> 		   -1, 0);
> 	if (ptr == MAP_FAILED) {
> 		perror("mmap");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/*
> 	 * Fork but with a bogus stack pointer so we try to execute code in
> 	 * a non-VM_EXEC VMA, causing segfault + teardown via exit_mmap().
> 	 *
> 	 * The clone will cause PMD page table sharing between the
> 	 * processes first via:
> 	 * copy_process() -> ... -> huge_pte_alloc() -> huge_pmd_share()
> 	 *
> 	 * Then tear down and release the hugetlb 'VMA' lock via:
> 	 * exit_mmap() -> ... -> vma_close() -> hugetlb_vma_lock_free()
> 	 */
> 	pid = syscall(__NR_clone, 0, 2 * PMD_SIZE, 0, 0, 0);
> 	if (pid < 0) {
> 		perror("clone");
> 		exit(EXIT_FAILURE);
> 	} if (pid == 0) {
> 		/* Pop stack... */
> 		return;
> 	}
> 
> 	/*
> 	 * We are the parent process.
> 	 *
> 	 * Race the child process's teardown with a PMD unshare.
> 	 *
> 	 * We do this by triggering:
> 	 *
> 	 * __split_vma() -> hugetlb_split() -> hugetlb_unshare_pmds()
> 	 *
> 	 * Which, importantly, doesn't hold the hugetlb VMA lock (nor can
> 	 * it), meaning we assert in hugetlb_vma_assert_locked().
> 	 *
> 	 *            .
> 	 * |----------.----------|
> 	 * |          .          |
> 	 * |----------.----------|
> 	 * 0          .     PUD boundary
> 	 */
> 	mmap(0, PUD_SIZE / 2, PROT_READ | PROT_WRITE,
> 	     MAP_FIXED | MAP_ANON | MAP_PRIVATE, -1, 0);
> }
> 
> int main(void)
> {
> 	int i;
> 
> 	/* Kick off fork children. */
> 	for (i = 0; i < NUM_FORKS; i++) {
> 		pid_t pid = fork();
> 
> 		if (pid < 0) {
> 			perror("fork");
> 			exit(EXIT_FAILURE);
> 		}
> 
> 		/* Fork children do their work and exit. */
> 		if (!pid) {
> 			int j;
> 
> 			for (j = 0; j < NUM_ITERS; j++)
> 				execute_one();
> 			return EXIT_SUCCESS;
> 		}
> 	}
> 
> 	/* If we succeeded, wait on children. */
> 	for (i = 0; i < NUM_FORKS; i++)
> 		wait(NULL);
> 
> 	return EXIT_SUCCESS;
> }
> 
> Fixes: 081056dc00a2 ("mm/hugetlb: unshare page tables during VMA split, not before")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

LGTM, all rather nasty with "take_locks" parameters ...

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

