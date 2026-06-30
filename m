Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006B5C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31636B00A6; Tue, 30 Jun 2026 15:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE23F6B00A8; Tue, 30 Jun 2026 15:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83B66B00A9; Tue, 30 Jun 2026 15:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9496B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:05:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 182CA1C6260
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:05:14 +0000 (UTC)
X-FDA: 84937506948.21.556FE5E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF2BE40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:05:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rgsrwj1Y;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846312;
	b=3xdN5CTSZb3HgncbeVk6QVjGhpjKUU4rOflsRTYNWqAJjrJPkKxiKgT5KMv6GbDLw2Jg5d
	TicLB2NDN19rcq2IPi24TSY4i5VmzF8PQlXpT7j/q5xTvvdyBaNIwSEm1VigiHg6yVT8NL
	ALTQMxk4CZUuT7cHu92panRjlbmEr34=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FW5G+1KBuZlzub8QMEKYBoDh26PDijuF5zKaWYshN0I=;
	b=IBi/GcHfymE79HQxSJTfXfjUi4mtLKK09+7PQ+EUyT2JcFU7IlRdsBqpy8Pp7SRysldv2W
	vTzbATFGeSIOeZGfmwXFUi1uO2O0gCPMe/h7md+SRnpRm7wOfl3umzMFFjzEHMw5HnO9TE
	DCIdCOXt0qIn1rG1GMWa3zsETNmd8MM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rgsrwj1Y;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FW5G+1KBuZlzub8QMEKYBoDh26PDijuF5zKaWYshN0I=; b=rgsrwj1Y/lwGotezM1ZsF5BsSl
	QO8VRqUzKcF0+oCYOnXp22uli69/gpurqKMHTLnLxl5a+XGt5oVdNnSTjtkx3o4tP69no0q6DHRzN
	ZnRtdGdhtVWMV+pGo1WXPg1AnadO9iLPB/DLSQXmnkCs9fCBsqs4kG4EiYCX+oafj50b6sQWpXiNm
	Ntai2fc+MGJjx3t/kV3oX2IB+/l6soT6I7G+dYl4KZLhm7v9/hXT8vBGXbdBuXDnCeMJESotnL0Fh
	R0c4HVpV9ztKxT3DsaeoAqoT90Kj6pl2TNBbixA9/I4YoIkHQCzNJJwiSaFnio6d3sA+Qo+0uHv8E
	fX+u8jLQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedlb-000000005PS-4ASi;
	Tue, 30 Jun 2026 19:05:08 +0000
Date: Tue, 30 Jun 2026 15:05:05 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, keith.lucas@oracle.com, kevin.brodsky@arm.com, 
	maddy@linux.ibm.com, usama.anjum@collabora.com, yury.khrustalev@arm.com, 
	jhubbard@nvidia.com, joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
Subject: Re: [PATCH v8 0/5] selftests/mm: refactor pkey helpers and fix mmap
 error handling
Message-ID: <aydheissr7yviudm6s3y57usfyx2kh4p6bdnd6mjdcnvvonga5@ydj327gtjo2m>
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630073235.3802271-1-lihongfu@kylinos.cn>
X-Stat-Signature: da149tpo198qr9bzjfeqag3tpi9ao6u1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF2BE40002
X-HE-Tag: 1782846311-213486
X-HE-Meta: U2FsdGVkX1+LsDiNAF15DQeuvPZU1vs3ZO1ZKrsb8NeWjfsurBzzEtcHRx8lEX0T16YI7ulBr+ZptFTuR0mpPlAFrWaIUOBaLoJeEc0h9dLS4PTo2cecKxGF8t7WpMp1BYNqRglewpRx/FAeloK9SIeJCZFvok88AqQEsJOggLWwnhcCJBBFApWz0kp53BzOZwzvD9//32HMlzBmGWxNbPuLWGZmQ79uLQCuAs85VMBjwcEyKh1RSIMnHnIapjQ95dEZheDKQG5wtlRsobSlZP2ibR9DFT+y43Yt0KurjEbPyK5iE/uy72EGXZBzpqqCahgBrHZYbY/uaXNbSfvNijrHEP+uBydi2RbcobftnownX7vhc+dnBF83zGVd1sMTjoFNpPodteAXkTz6NvXomkwlvGbr40UNhqkyc4L0FdcyAqI+HPhxi71SMwN53zXTcA1JcPhtXbRvkqH3M6teH+YmPt/62ATtdoezR/HJcKR/FvemZGhEGT36wCfm3InuaMfsVOVpvtdjECFCMBvuwIn8ijITtvis5ycrrtpX+M+xBeAS/qi6FyMO9RqNeymknKI8DyyHGFPx8i1co8JJm2MdG1LhOe/ZRf7wqR8vOxSnBTpfr8KIVmqI0KywDOXHBoGNj79S+u1uhRXUN/7QYZq/iCNIh4TplzkDcbvbRGIJp6aU/oEEWVy8NSJR243Cz9agrwDAPcIVLFpu2ICL1yTPkNI091OaYxPKgMuPDDE50bqb+gq3x2gHmPZoztCsgL4+rfCVCaPI+99obazmiOBBhyq4nyG03R5CadOZM6gRdY4XLGy9XlO7NOwN0XmRFE0fRkqx7jD4fYeBHfhjE4SUFC2D6D35JowWSVL4JF4IdZin9/c+AQ+kTwCXyYh9D+42FLOIGfRqxP2qg+BMmQO52PqOQMXFZO7LXnzSSbMGVMUZ6A2V6WoxxFe4PmDmrH8d91dWvLdXaSHEvp/
 Ax5sbZnl
 zEKDqdu4pwgdarbVYomKbvoIdheTlcbuUy6fdwJ/n9HqVZDFdqn8SlUaciM0x8bMUXDmvrTkrt5mLDkFRgjpXUvJT5Htj92czvgm6H4FKmkq+ghofdCAkBIxzZ16oBWor5T81DJk4hL7sldkEstgaTiwp8a2/I7Je0kteRN6Y0vruxX8g2WKfzsbZSZDyReAnRHRIpqu8tCZpUids8FzHSyX/dtqJ8TdJzobsNMT9opW8Dklb8xPBw6SWtbWPEm7NaaWtJ2KOMpbTTa8WL9Vk3iDc0yF+JRVo+0XT0CdxbXZ98CNwfSz329wR0XEYtXTpCRwBhMfl+Rk8iYiYuxXtms9VAHngUQC5J6Q1LqrQtTZfX0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/06/30 03:32PM, Hongfu Li wrote:
> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and 
> per-test tracing for consistent diagnostics, and add missing mmap() return 
> checks with MAP_FAILED used throughout for readability and consistency.
> 
> Hongfu Li (5):
>   selftests/mm: move pkey selftest helpers to pkey_util.c
>   selftests/mm: unify pkey sighandler selftest assertions and tracing
>   selftests/mm: use pkey_assert on clone_raw failure in pkey test
>   selftests/mm: add missing mmap() return checks in pkey tests
>   selftests/mm: add missing pthread_create() return checks in pkey tests
> 
>  tools/testing/selftests/mm/pkey-helpers.h     |  4 +-
>  tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
>  .../selftests/mm/pkey_sighandler_tests.c      | 81 ++++++++--------
>  tools/testing/selftests/mm/pkey_util.c        | 86 +++++++++++++++++
>  tools/testing/selftests/mm/protection_keys.c  | 95 ++-----------------
>  5 files changed, 141 insertions(+), 127 deletions(-)

Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> 
> ---
> v8:
> - No code changes (relative to v7).
> - Updated Cc list: added developers identified via `git blame` and
>   `git log` on tools/testing/selftests/mm/pkey*
> v7:
> - As previously suggested, wait for v7.2-rc1 and rebased the whole series
>   on top of it. No functional code changes.
> v6:
> - Add missing pthread_create() return checks (new patch 5/5).
> - In patch 2/5, call tracing_off() at the start of test_pkru_sigreturn
>   before the SIGSEGV handler is reset to SIG_DFL, to avoid leaving ftrace
>   enabled on crash.
> v5:
> - Use ret instead of child_pid to hold the return value of clone_raw().
> - Make tracing_on(), tracing_off() non-static.
>   Remove cat_into_file() declaration from pkey-helpers.h.
> v4:
> - Base changes on top of the latest mm-unstable branch.
> - Split the first patch into three:
>   patch 1: move pkey selftest helpers to shared code;
>   patch 2: unify sighandler selftest assertions and per-test tracing;
>   patch 3: use pkey_assert() on clone_raw() failure.
> - Use ksft_exit_fail_perror() in main() for mmap() failure.
> v3:
> - Use pkey_assert() for remaining sigaction() and clone_raw() error
>   checks for consistency.
> v2:
> - Update commit message
> - Move shared tracing and assertion helpers to a common file,
>   replace assert() with pkey_assert() in sighandler tests
> - Drop assert() from main() in protection_keys.c and add a proper error
>   message instead.
> - Link to v1: https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/
> -- 
> 2.25.1
> 

