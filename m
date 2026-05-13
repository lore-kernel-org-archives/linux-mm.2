Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A0FCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6466B0005; Wed, 13 May 2026 07:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E872F6B008A; Wed, 13 May 2026 07:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D406B008C; Wed, 13 May 2026 07:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBDB36B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:30:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61465120803
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:30:41 +0000 (UTC)
X-FDA: 84762179082.08.415DCD9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 038DC4000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:30:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="r1xx/9wY";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7xooceHp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="r1xx/9wY";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7xooceHp;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778671839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqQ/I3lrTsawC6GGrrwXVJNBkJMZCSf4vZnRlxubQT8=;
	b=GwLJFnHxg97/rMTyBZ+qhyVtPgu+iizi5BEe0WmVtHYhFura0UR3PCv3nWF1nuPVHbPocl
	oqQif22l/T8WjEW8QbID6qWLJ7cNGPGfRPF1/CgrQUCaM6e88EB5buAuJVbDtb4y5o1Dj8
	SNb2YJU0pzXNXyRxipzsazVWYdD+HV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778671839; a=rsa-sha256;
	cv=none;
	b=GAmpALfUHuRc33dUGPWGtdvcQTiR9TQPAkTxehh2TrNhb4zh+N+ZREcQfe/spLjTPo+Bm8
	c3nmP3ekjqPCqTqPv6RT67v3R+9i5wzEEdvKmfh+ZU30UZ1YkVELEfkvwPe4eDMGkagXov
	SxCRnGeCBHgnFcs/7Xnl/6pjRIy6J5I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="r1xx/9wY";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7xooceHp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="r1xx/9wY";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7xooceHp;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C1797611B;
	Wed, 13 May 2026 11:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778671837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uqQ/I3lrTsawC6GGrrwXVJNBkJMZCSf4vZnRlxubQT8=;
	b=r1xx/9wYWMyKW9+Gs5tj71/q83qvfYUQePfK7BK+7xbS+TTr5pSoAis3f3ZXXGFQIpWCxx
	72werDiio6Nw6Mn2+J03BKQ6zXX9C9mPmAkVBOmOAjXtjw2UfmQBKqO0mklTYSO0k2mVRY
	JrHwpdpxt0HkssPiUfKx2WGWB5Z7G50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778671837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uqQ/I3lrTsawC6GGrrwXVJNBkJMZCSf4vZnRlxubQT8=;
	b=7xooceHpU2vZpcxN6M94AhY64XXsWw1OQ1dm7TjoOsKZCnb+xEaiWUuTqVgcXwJOqGq8hA
	zaMzGcYX4XuoCwCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778671837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uqQ/I3lrTsawC6GGrrwXVJNBkJMZCSf4vZnRlxubQT8=;
	b=r1xx/9wYWMyKW9+Gs5tj71/q83qvfYUQePfK7BK+7xbS+TTr5pSoAis3f3ZXXGFQIpWCxx
	72werDiio6Nw6Mn2+J03BKQ6zXX9C9mPmAkVBOmOAjXtjw2UfmQBKqO0mklTYSO0k2mVRY
	JrHwpdpxt0HkssPiUfKx2WGWB5Z7G50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778671837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uqQ/I3lrTsawC6GGrrwXVJNBkJMZCSf4vZnRlxubQT8=;
	b=7xooceHpU2vZpcxN6M94AhY64XXsWw1OQ1dm7TjoOsKZCnb+xEaiWUuTqVgcXwJOqGq8hA
	zaMzGcYX4XuoCwCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E17CA593A9;
	Wed, 13 May 2026 11:30:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5LyNNNxgBGrpZAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 13 May 2026 11:30:36 +0000
Date: Wed, 13 May 2026 13:30:35 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/hugetlb: avoid false positive lockdep
 assertion
Message-ID: <agRg21Fq5oS4hNq9@localhost.localdomain>
References: <20260513085658.45264-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085658.45264-1-ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 038DC4000A
X-Rspam-User: 
X-Stat-Signature: o3x86de5y74n3fw1hsw55k63g8a69fgc
X-HE-Tag: 1778671838-47066
X-HE-Meta: U2FsdGVkX1/P/ND7vXyV/vNgIlAyQFEooJeAbIWwgvHx4QHEr78eMhI7MnFf46BOs4dCMp/7BaIWx2MbWOARUGDqd8FfuAfv/s1qes0Mq6FjntVSj9/wTf323uYeirD87w34GL9RxR59Z5r/gRkBHdEaFT4bjdFh96DeOB7LJzyFiUA2nWmzoTU8ZjFA8+Nc/szNjbRw5Kb4i03shSVbeF7EAZqsh3rFFG3Woel9Yw5hncj9Atc9RAPToNbCXWooLqIPLuSxZtZPGxX9YVltFMLnsAmFi4GldJVXX2FUXbfTZ+S9lK+vIH8hhJjm6qKuxfZrxFI57corYJA6AtkSP7JJv8nBj+6VmjJm5czFjUzqIfEKUGdxLTW1QqXkexpSZXZMxqIhIu+qML+jQarxdMxBOC2BXOgHlejxt+ldSu1OirxkujODHSBIz22cF+V7XhzEYkeIAP0Dex3IfnSRgvbQdkhskq4z1QsHKud7zbntYo9SFklYtUsm/evQI9G+/TSf76JVeMgiMZbaSsaVS6Xy5IHajO/v55P5IhA5CHUu/0fXPac6hn+H4mWcOrsyOuFez0Kwy1wfZA1xtW0DTUpcnem+0J9eVgEVn0zNePmK3lMZqghvqgH9Qfz+xI61FD6i+340q70qSH+Xq/lpcnv6SmsJMsJXQbfJ3eMZGC42A41oJ2lunt0VKOAetpUORmLzeVcP9MJKZP6tTPUFd94SFDL4o9dHwSygjR+oLJ1sXopoAJpn26QAh+Eq5dZvq+d6ZPXCgIZhN6x8mbgtSTsEndkUeb8+xINYOkiHBt8824NzLwxedijZaQyVPg/vQK+UQluSPRI/qstf416sAUiSwQA7evIcJNOa7aRFYGlprJydLCX5CPewcWp8soe8EyHW3cJCrd5uxFTWuBPx5QCL3kcsMA13m6hgU4KOnvCdc1tFYQ+9/zTapEq8gQiw5Kt0GTrmvhpbgftYRQn
 swnfiLNw
 hVxIOx2JE1MbS3zEeD2ZqMEB1f6BnaXEmLkj1HEK6oe4xE/Ld6YBZ9eZBmyxquCj6FIF8/0TLpgcS/B6KPlv2FZgbb+nVVNAgflj5eC/+NTMYSBnmE1xxgoq/q1tHlPxPA6nmqUCt2RRES62bPBlVU8+2ryoS1latUuprzPT1UkmIcajMXAJsCiESyvosdfz2Iv8G8n3wv0GLE+/jXK20mkyRPMdb0snGlr69eb+DBho18BrYXCP8pnuIbDeTI4lv8p+ZIrQZ8Bx//mREjCyobif9+qO8G6xISmUpafrDXhOGTrV4xu9Ktjq882lS1ID5871/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:56:58AM +0100, Lorenzo Stoakes wrote:
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

I had to re-read the flow a few times because it is getting a bit confusing but
here we are :-)

Acked-by: Oscar Salvador <osalvador@suse.de>

Thanks!



-- 
Oscar Salvador
SUSE Labs

