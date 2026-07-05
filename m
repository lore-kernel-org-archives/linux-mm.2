Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE645C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B426B009E; Sun,  5 Jul 2026 16:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CB126B00A0; Sun,  5 Jul 2026 16:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E15A6B00A1; Sun,  5 Jul 2026 16:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FCFD6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:48:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A09C1C70B1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:48:23 +0000 (UTC)
X-FDA: 84955910886.05.1E566BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 024B740004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:48:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aYuX+2ZO;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783284502;
	b=gdpFFo5bABc94+cl2B+40thqAjV64RbIfABSHz6eGQS9p/SgUGMtiSddYQ5alp4hmD+lFU
	7x/Mvvpf5CXeJnd2aiZn/4GGj0JO3h+DNOc4HvpV3N6CQycJYRCoOep6txBA73ZnUEr1i3
	la/fcfJFcnU9XdI2kYRHAuU8dXCSaIg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aYuX+2ZO;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783284502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqf23XiVeF7E6IoPTpK7HKahKDWobW5oehZgHKt5vFE=;
	b=CN+v5WaWk2Ur9mrj9tU+exGOh+qdYyGC6mBlrf4OLMIWuE4rWi9e6uEn4cJ/MM+0t1u7Lu
	VhcjV91J7l6/7LqBjZmpJUaxV27wqTvhWq24S742AfJU3Lsyqti+DNaiKQLxdjSYsKDQEQ
	4SDjADnJ0JA+MoFmRF4+/e6XH6gou/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ECEB60018;
	Sun,  5 Jul 2026 20:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D7F1F000E9;
	Sun,  5 Jul 2026 20:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783284500;
	bh=qqf23XiVeF7E6IoPTpK7HKahKDWobW5oehZgHKt5vFE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aYuX+2ZOPOZFALiltW8zNgEUGECOVLI+5MHUXK+ZduK/0uGZivRyZ38HaaZ+em3Sj
	 B2I81V9AabL9RkcM1CmYlg2XcIBpVBOugSvAhT/rdlVbw3rn5r7hdtKymbTJK0GUPD
	 zzRcW76UEZfHhXOb6lU3Y0wlp7ZY8ps7B3MjOb8c=
Date: Sun, 5 Jul 2026 13:48:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jhubbard@nvidia.com, joey.gouly@arm.com,
 keith.lucas@oracle.com, kevin.brodsky@arm.com, usama.anjum@collabora.com,
 yury.khrustalev@arm.com, zwisler@google.com, hongfu.li@linux.dev
Subject: Re: [PATCH v9 0/5] selftests/mm: refactor pkey helpers and fix mmap
 error handling
Message-Id: <20260705134819.871dbf41d2b06681f0facf12@linux-foundation.org>
In-Reply-To: <20260702062332.911786-1-lihongfu@kylinos.cn>
References: <20260702062332.911786-1-lihongfu@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 024B740004
X-Stat-Signature: b8u7rfxhhurytyhddw37x7t8ou7wkxbe
X-HE-Tag: 1783284501-259340
X-HE-Meta: U2FsdGVkX1914WXAX6Blhup0azz9HZEyETZeDoLCVvo13Ysa7QCGiP8OemJPfhs3SPIAtq78+6eOp1v11fll6T3Pda/McIFVnvSAs2kmb2woYT5c6FbbyIDX66Xk7WJh4UeeATT3Mh85a18pVlaHlI1Jv/BmIm1z0Q1fQYDrZ5Dy7vUWi3la2P4hs+2qg36grg8jyf3X7VHrWLRMyqEaRS/1+Dhcb3YT9aSGds4ACI7YxcdDm7NzLikfvguywVjKpvASsEqp+/B8itByBi0mbDHixMpqv+QaqqTlpT39tEBYyAIjpk4bPCZx/R2vNV9Yy5VhAvEnr+p2zScoJjlqxhYCWCKuxs5Gxx6qY7SNS2Eo5KS9dd4HQRMi7zeIzI6OrVUGlGbydgh0BjjmkrDrAo1OflA4S4kQRrYQdaepOdYZxij3YDVb9kBU5ZxeG9b8wCVmcexTOhGqoBRb/29W3DRYXIUFH+8UhOvtgjVJmdeWEI5PM6vAmXuTFYwJkMfo4G5ZhTIMuSNdzk3MvQ8I6P1QIzuvVSsISSQxXMt+P7/FKASm+sIgmU00Z45t2jx0IPDJfih1Ua/SOM8jJpepFpJCe99nO0jZNHQF6/0S8eVehdjjoya1G8/AXZzGE71T+iyC+rwOyAUavRdfs+XTNibxj6RS5j4Ipq0vZviHMwtjgLFpY4kM630+j4R3uevd/LYMtDk5+Up3feiAb3wh/orjzHbBprc/48bMnVVDrC+ImS1c83qYG0xrHvGQ5E9pTZWlNrMHNwmTR+TZ3cr6mkF/g5veGIG0nTiBukzX4/vKyic6YXwznOdarFeMeG8p5Vqbfo9erPxu0pF/QVf4QljaOFdzziv3mLpeKOZifCwYeZZb8hyHcBvN51P/WMNpVAHekspVIu9sg0bP2D9/43lhCBH7a5EWIsLyAP66T0tCAawVV7N/wLfgg9VheX+2ospXSnL3KSowc93yKht
 IY+27ghQ
 SWWttZFl34NdSmKyh0c7pHX/qlkGEk6tvBMyrzv4HI4/xopTKljRj/PFbi/EexDXbKJ3LAR1Ftofboa0Yj+GaUgf45DBQC3NZS+d4fjtyicTwcvrx6SPZJ8zSixJtIHAoasVg6JWy9X9O4Fw137epP+I50uKs0JGGE9+bVY7A+cLQjIyYpeoWSDnMoLcG9oXyvgRFVta8omdcSlXWDWZvBzefVANj/kwHgRG3Vu4Hlfo15JmaJOG5i2ibyTJjqDh45RKdHogC4w4QaKrKeEnvgdsESgvGLCyn9hPKrvjq2jQybCYsvX0BpCY2GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 14:23:27 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and
> per-test tracing for consistent diagnostics, and add missing mmap() return
> checks with MAP_FAILED used throughout for readability and consistency.

Updated, thanks.

AI review might have found a pre-existing thing:
	https://sashiko.dev/#/patchset/20260702062332.911786-1-lihongfu@kylinos.cn

> v9:
> - In patch 1/5, define test_nr, iteration_nr and dprint_in_signal in
>   pkey_util.c and remove them from protection_keys.c and
>   pkey_sighandler_tests.c.
> - In patch 1/5, cat_into_file() used the wrong argument in the open()
>   failure message; print file instead of str. Update the commit message
>   accordingly.
> - In patch 2/5, align clone_raw() continuation lines to the opening parenthesis.
> - In patch 5/5, set errno from pthread_create() return value before
>   pkey_assert(0) on thread creation failure.
> - Add Acked-by, Reviewed-by and Tested-by tags to each patch.

Here's how v9 altered mm.git:

 tools/testing/selftests/mm/pkey_sighandler_tests.c |   38 +++++------
 tools/testing/selftests/mm/pkey_util.c             |    6 +
 tools/testing/selftests/mm/protection_keys.c       |    4 -
 3 files changed, 25 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~b
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -35,10 +35,6 @@ static pthread_mutex_t mutex = PTHREAD_M
 static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 static siginfo_t siginfo = {0};
 
-int iteration_nr = 1;
-int test_nr;
-int dprint_in_signal;
-
 /*
  * We need to use inline assembly instead of glibc's syscall because glibc's
  * syscall will attempt to access the PLT in order to call a library function
@@ -225,7 +221,10 @@ static void test_sigsegv_handler_with_pk
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
 	ret = pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
-	pkey_assert(ret == 0);
+	if (ret) {
+		errno = ret;
+		pkey_assert(0);
+	}
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
@@ -265,7 +264,10 @@ static void test_sigsegv_handler_cannot_
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
 	ret = pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
-	pkey_assert(ret == 0);
+	if (ret) {
+		errno = ret;
+		pkey_assert(0);
+	}
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
@@ -327,12 +329,12 @@ static void test_sigsegv_handler_with_di
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
 	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
-			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
-			     CLONE_DETACHED,
-			     stack + STACK_SIZE,
-			     &parent_pid,
-			     &child_pid);
+			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
+			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
+			CLONE_DETACHED,
+			stack + STACK_SIZE,
+			&parent_pid,
+			&child_pid);
 
 	if (ret < 0) {
 		errno = -ret;
@@ -501,12 +503,12 @@ static void test_pkru_sigreturn(void)
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
 	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
-			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
-			     CLONE_DETACHED,
-			     stack + STACK_SIZE,
-			     &parent_pid,
-			     &child_pid);
+			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
+			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
+			CLONE_DETACHED,
+			stack + STACK_SIZE,
+			&parent_pid,
+			&child_pid);
 
 	if (ret < 0) {
 		errno = -ret;
--- a/tools/testing/selftests/mm/pkey_util.c~b
+++ a/tools/testing/selftests/mm/pkey_util.c
@@ -8,6 +8,10 @@
 
 #include "pkey-helpers.h"
 
+int iteration_nr = 1;
+int test_nr;
+int dprint_in_signal;
+
 #if CONTROL_TRACING > 0
 static void cat_into_file(char *str, char *file)
 {
@@ -20,7 +24,7 @@ static void cat_into_file(char *str, cha
 	 * pkey_assert()
 	 */
 	if (fd < 0) {
-		fprintf(stderr, "error opening '%s'\n", str);
+		fprintf(stderr, "error opening '%s'\n", file);
 		perror("error: ");
 		exit(__LINE__);
 	}
--- a/tools/testing/selftests/mm/protection_keys.c~b
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -49,11 +49,7 @@
 #include "hugepage_settings.h"
 #include "pkey-helpers.h"
 
-int iteration_nr = 1;
-int test_nr;
-
 u64 shadow_pkey_reg;
-int dprint_in_signal;
 
 noinline int read_ptr(int *ptr)
 {
_


