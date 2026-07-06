Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F13BBC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 23:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D2E6B009D; Mon,  6 Jul 2026 19:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F376B009E; Mon,  6 Jul 2026 19:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839D16B009F; Mon,  6 Jul 2026 19:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53E626B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:28:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A86CC8CD18
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:28:45 +0000 (UTC)
X-FDA: 84959943810.21.D30E5FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E0629140005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:28:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eS79emPp;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783380524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xY2XDGZgy2/wx1N9DCqdj5OgFf0MPlcb4W5q9mk0jSM=;
	b=l6tDGWrUg+huwXyPDo9Tb7D61JHdMqVyZjaKOoLvKgzHPR3I18e8VypTfB3xy9z0n4NcT0
	VhqkNO/YWzpSwOTnM1jOG4TTVHc8t8hc+iuBVnZi82krVx1M//hPcEh27ihkKPrXU3os69
	t7NreYsk78yFRlTvpi3y06Vn5dbccKY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eS79emPp;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783380524;
	b=3eW3kUzf5WoW1n71nfZ08tBWikGssgDD73aEUkK05B7nmsN8RqjEekaUjp7dW6S1domVh1
	uj4fV1AlCT96KvPIYKsNyhm6htzaYeWl6NsoLz3Gt6sjTZLJDwV9IvOnei/e0gDNAzzWLz
	uzNQdsuD3cJvopMYZy9Aw4C4QS17SEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CDB061834;
	Mon,  6 Jul 2026 23:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382911F000E9;
	Mon,  6 Jul 2026 23:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783380522;
	bh=xY2XDGZgy2/wx1N9DCqdj5OgFf0MPlcb4W5q9mk0jSM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eS79emPpoRWzK7gWR0/7petFLauhupa0yHOkTQqJxxfj6uoSowyN1sJlR9lkSzpFR
	 FmBcPFNIRQeR7iktkkcWn3bad9AhF+ptjDuUD5M5vdsm5rF1M63PL0l+4cgmg2VL3I
	 +ocuRwiPyyy5Anu9iCDjJLIFL6tUHqJsahR3B2fQ=
Date: Mon, 6 Jul 2026 16:28:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 jhubbard@nvidia.com, joey.gouly@arm.com, keith.lucas@oracle.com,
 kevin.brodsky@arm.com, usama.anjum@collabora.com, yury.khrustalev@arm.com,
 zwisler@google.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, hongfu.li@linux.dev
Subject: Re: [PATCH v10 0/6] selftests/mm: refactor pkey helpers and fix
 mmap error handling
Message-Id: <20260706162841.b34d9bc1ba1aaa4be4f6254e@linux-foundation.org>
In-Reply-To: <20260706081600.3570203-1-lihongfu@kylinos.cn>
References: <20260706081600.3570203-1-lihongfu@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E0629140005
X-Stat-Signature: bsbmszoyws4metgt1ifgb77tosd45i9y
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783380523-382548
X-HE-Meta: U2FsdGVkX1/iXsxTF5rDw072ic4G21dwguUYL64b8dTV1TiMXBAOxgZE4ty8VMN5500nIIHd2qB0f2tRiaZJ5Pn4zxM1dI1LcakmWKQKYQ+SXwEgsgnJ6mg6TUN7HwTzglPpGcXSCH34I2GOR+JamSYM806l7+yJZNl70K+I/WyRXwbdZpeBDIMFWRpEiPXELxEYvzZsxal50fvI1+9XNw5WL1UbK12WqhBkvuDQRX1/3L32x7PowcgosF+ZCSmbJbog6gsVmi7KprzH3hBrjEHUUm8aK0IL0IkNJHQpZF6CWAO203Zm8zSnJNfEM+xR6wrWmMOaV5gXQs/CQjBmgIITh36T6D++nCJFz0xGXtgmR5ElWERFsJURduL6BfSTQB+Lldi7FaFRx3eH0YwwAJtCUgfNY48IMv0cSypqoqvDfUgfm6+5NJAZy1vDAX5KZMCluChKuLNThDjn5ijAq04cSE+RAlqsTqnEinBFKcNirz5Sq0XPtT4nAftkEtmskL/+YB4v0j9BW24yBezVCVSbRX+b9Cn1xdjGxZRjpPamlkm22u9EStsNQuWjpAJZb12I2e4uNLmBoVwFZDc8HLy4LHvfsKg7pVHyOYoSDR6B7+L2PstDIob9XpGCEb8OPB8ZNnbm/Dzz6Q8ZLXHWVMV232Ph/A8V/iVfZGinvzHLo0URVrWYahryT4hll699/Brw/9rmN2fI3splVY+P6pyLpvV2m98//ot7DeEM2J2HZ4OvTi6j1CpMn9oHW9X2TvPSw6OVlL/4JdGKFHOWEHVxGLVTSHgwP7od6esU7IytCnycjNtEq01JGdVV6JKkjnLtaXNTVvcenNspsRjeYgyQnmrZtTXk8YNbTjOESu/JjC6CgDGanEE9vRIIUGrkpQ2WWOC+YB4sXYAUymN15JZjB3f+YvbJ6ZKvuPoXVr56Z8dI4hukFODdl81Bp4wxfqQGfSIR7FwGn24KEfS
 tudpXZbW
 SEuL8i8uzxEi+7qTZHlCjQ9CVdYkYdgrQpYesXDa9nLxOIoVJotQKivu8aMIjnAN9HYByAA7tmK79FVcop8w4O+638p+WrpzgcvE6apQ4+nuZJJG7DtgRKVcssQa1cViTZmUvi9dhMHqkjXSkUf7jsH345QX+8hjc9C9bvz4PVf0is7Wtr6ETUfs/r11ANwLnKN+rY1uWCQVIbhwKm661IcOvgv+VCEaSlFXuZUOhBzAu9NmUuuCrgfJZofp6L/Z6gpjS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 16:15:54 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and
> per-test tracing for consistent diagnostics, and add missing mmap() return
> checks with MAP_FAILED used throughout for readability and consistency.

Thanks, I've updated mm.git to this version.

> v10:
> - Add patch 6/6 to fix a pre-existing cleartid race: remove unused
>   settid/cleartid clone flags and wait for the clone child to exit in
>   the sigsegv test.

Below is how v10 altered mm.git.  As you mentioned, this is all from
the addition of [patch 6/6].

btw, I thought the official way to wait for a child thread to exit is
pthread_join()?  Why is that sched_yield() loop used?


 tools/testing/selftests/mm/pkey_sighandler_tests.c |   20 ++++++-----
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~b
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -290,7 +290,6 @@ static void test_sigsegv_handler_with_di
 	static stack_t sigstack;
 	void *stack;
 	int pkey;
-	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
 	long ret;
@@ -330,11 +329,10 @@ static void test_sigsegv_handler_with_di
 	/* Use clone to avoid newer glibcs using rseq on new threads */
 	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
 			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
 			CLONE_DETACHED,
 			stack + STACK_SIZE,
-			&parent_pid,
-			&child_pid);
+			NULL,
+			NULL);
 
 	if (ret < 0) {
 		errno = -ret;
@@ -344,11 +342,19 @@ static void test_sigsegv_handler_with_di
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 	}
 
+	child_pid = ret;
+
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
 		pthread_cond_wait(&cond, &mutex);
 	pthread_mutex_unlock(&mutex);
 
+	/* Wait for child to exit before returning */
+	do {
+		sched_yield();
+		ret = syscall_raw(SYS_tkill, child_pid, 0, 0, 0, 0, 0);
+	} while (ret != -ESRCH && ret != -EINVAL);
+
 	ksft_test_result(siginfo.si_signo == SIGSEGV &&
 			 siginfo.si_code == SEGV_MAPERR &&
 			 siginfo.si_addr == NULL,
@@ -445,7 +451,6 @@ static void test_pkru_sigreturn(void)
 	static stack_t sigstack;
 	void *stack;
 	int pkey;
-	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
 	long ret;
@@ -504,11 +509,10 @@ static void test_pkru_sigreturn(void)
 	/* Use clone to avoid newer glibcs using rseq on new threads */
 	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
 			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
 			CLONE_DETACHED,
 			stack + STACK_SIZE,
-			&parent_pid,
-			&child_pid);
+			NULL,
+			NULL);
 
 	if (ret < 0) {
 		errno = -ret;
_


