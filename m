Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54215C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2B96B075F; Fri, 14 Aug 2026 21:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A40F6B0761; Fri, 14 Aug 2026 21:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245926B0762; Fri, 14 Aug 2026 21:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA0226B075F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F354A0270
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:33 +0000 (UTC)
X-FDA: 85101847026.30.681239F
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9636AA0003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="B PZi3u6";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RjjQOBQw;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtJcwZE0X9O8WD49joaw69JwdIiKCMaehT7QHdQfXo8=;
	b=cbOr2ZZ3GITgmOoxz61at0xHXtqwsX83g+vhFu6Jl3rKG4s44jT900LhLgh1wwkoKlE9nj
	Jy40XRQg1NQD8H6L4lyXeAAIRu20g7pu/S83hfcSGiNsw3emkhJh7LvveImB+hlGEVhc8M
	TSQ19nb0tu+AebjcEPj0KRyFjcTE7iQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="B PZi3u6";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RjjQOBQw;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759171;
	b=lNiwgLnryP/cnktuDEI8OExkLM3qekaAJ6zOveRG60mBwJeJnRL+hRjMNE6RY0YsGtzmSQ
	VpvBOnhOBVtvgO7f+J0+Va9cdcdWT/JjDG95fG8+JRuE2OP+93/uF8qzwXXZoXOU39mUHO
	a35tCzhuhZXW0We+lYKePDyigk4A1mI=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 331D3EC022A;
	Fri, 14 Aug 2026 21:59:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 14 Aug 2026 21:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759171; x=
	1786845571; bh=WtJcwZE0X9O8WD49joaw69JwdIiKCMaehT7QHdQfXo8=; b=B
	PZi3u6hPnlGjeHkeUxXMLh1ILCR3852OQPB4P9FORawFv74kvZbxt8LkjAWYfpUG
	9QUZ4tJfuxTk8vmCAD9/CaJN2XR+/JPUz/VlLKSQrzP8g5wObb2t1ip38zI4N1Fb
	hp92CB6DSvsdR5dQEEtjEuK27ZY780S5hysO5lNdtmGFgXTQDxSq/ah8ZWjIDYL+
	W0u4rafOM7yAQmrifjgjf3Wx3Nvr0yLDD2gmiu2k3gWE00a3v/ahohk5fpx/CrKK
	RMJVjkzuuSkY6bS1410KeVNbl7z08tzR1/qUIMylgN87p9kveOr+3J1rHaYSmWck
	/b+na5PTkDkhHYM8BL/yA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759171; x=1786845571; bh=W
	tJcwZE0X9O8WD49joaw69JwdIiKCMaehT7QHdQfXo8=; b=RjjQOBQw5Kjl4fMPQ
	boZ71lSlEYIBG9CB/lZ241QEkTHAjnN0Fq6w9NM9nFO8BTZHh12Tmg3fGj9YbSGq
	H3+68wmjDQe1/QyxPgCeDzAagoDRukYKg40mj1gDsF99NETMMYXWJcmM0Ieed9Pd
	x4hu3LoIREIWa3nVRzxIE2kkyg+3vNpH0MDQaa9t/LIHhtE+jyCIb5X8okTLNEFa
	xQpUwwgQ8JbTUj4seUkoRdFgEMJyOfpaUK+zmpWwIf7iPLKVtr1TsBTFc8ndb9m2
	tq08yVyntT0I3aaJ8rgcyfm1/WbFMvKl1TyysDxUkSrXWR21sR4sJv05TALPOsrS
	+3A4g==
X-ME-Sender: <xms:A8h_ark0oRZ49LP2JbvPc9VCewQpnylyn1_dP940HH1ltBJ-d5TEEw>
    <xme:A8h_aizwt05NmKx-B4Dmf3aJtJfxQA88iwIJJQWZHi1RXX5b0CQrVD_OnBK1fxPk0
    QNgm90NHVR1JWgksTE9c9Hw4p62uJ0gqGrvbiCSmr9Acir9SpOWcQ>
X-ME-Received: <xmr:A8h_aqIKZp9lRg8uyYzdjfUraK7gVF_3Fc0AAnHtH4zZhP_I_Wc75zo8O0U>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1UpK
    vQ86E+2J6nnLLby5GHhBzZLfixCEp9w2OHJJWRdv/Abd6ZARiVy2pfDbYLsLc21fZaluFI
    VWPrJmrbL4cz0QUuPWs3Sh4v67FQmhOCoMqPzKJm4/OPeMlO1wyIo9JNLAdSBiqsOjtLoc
    7iCucaHc1r8lOvx9cxj2Wd7U0ARH2gSOtUrPRaXUkHlOV/zOUYbAo8JOgpo8dxUz2Tj9Bx
    o2wW1MHe7dAhwOjCi5NH0cPmVImhTA7MM7GdNY1p6RyMhXtY/GJJyNHhSic91vhIuxu7GJ
    /jQl/uyxuMzGLurX3ckbIzwnPrnT6WJRm+8Km7wkIMOEr1H18KZ2RHWEHw9g
X-ME-Proxy: <xmx:A8h_atIjNEel5KUI_Du9XUTS8mh9qEfCXGhAZxy7FlKdn8bcDqSb8g>
    <xmx:A8h_ahU_whk8-KAu9tbhOhc8BVfeDGhNAkn4FrsTBQU0jssV5CPaTQ>
    <xmx:A8h_atDLBtkAvittYwBcWo8GsCb1I0H07HbJi4UetDW5-CWrdCGRFA>
    <xmx:A8h_asHNshbMU9yJ49isufBHcgssLZUCoYiG2-0iuzTw5fTuF_znXA>
    <xmx:A8h_ai48-0nXga15rwOCGYGGvn0Lk3x9g72bnKy67ut70c2SSVnW30_2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:30 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v4 13/19] selftests/mm: cover a shared-source collapse write race
Date: Sat, 15 Aug 2026 02:58:55 +0100
Message-ID: <20260815015901.1236937-14-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ncdtzj8hftcck3udmiou3116jq7dh39q
X-Rspamd-Queue-Id: 9636AA0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786759171-462579
X-HE-Meta: U2FsdGVkX19nvPIeUHWldTvMkyBqDti2Xvb3fQ8zwQplJCq5p7yu2AmTuWTJUEacR9+//tG3QmiR3c34Z9GJdcp8O/oHVo66jMObl9vwEkcf3lPupeQZEv17kgaZZ2byb+oQhM4045UzHAp/XU0EyQ6vwh7i5yj10pFEXUrTkrxXwqpnySZex7fHYhiiwPvfRz4Yka9qkYsEnBxv5T8IalirSV7ZQWT2wzdwtbVOfZWt6gpu9BTXzkjd93IVT0LPvfncePi2fb/EAY1d0ifiB65TQLSd/cHv33cfmg51FTqW7KtSoJLo4S/9rp8dZQaswHEaQwf7iS2zIR5u0+T7K0DGsuRwOVDvylhaDm4PFxwsN9BURYBabT+r/KKWLaFvJnyQcHDJBofH9gQNgWlcRnb5yUuccOgNoCjDF44lU4otnTthe1iU9+GWnoDxJt6syxqGhZY25FMS0533UiqUMa+fIKmf5G500u/kVWpK2TPDf3N8ost6lSOAQ3AXbtlLkBqOCk16s+R1f61I9j4j/SBSL9PjmoA7WhW7ynQ/0FWmCKp3W4vzro+YxzOWoHPkdiXKcgWHtR9H+VD8g1haZtqxmRCsl06ceBhqIwTJC7SemJXTHOfBXtTx3kq9CCf+Ptkps9J6oAid5IBBGDtx2TUuARvCmr3Bng9eAmp25Ewc0PM415ATlgPH+NGmQsilVOdirEDP+mW4qYtAUnEFC8Q8a0sYOqvTI+HyNBWCxnaskFps1Qatnm9xXmTbGDpLaxo5xLdaRYoehBMWPL3+Z3fflRFlTYUispeLQJrx90gwoDY8IFCVIw6VpyI9TONQKkNA8Ex9goLu/Dh601avLNa6DsjCBoVgNrT3jb/1ACmaXtpYuQtgpKtJwZPRigc6ZPuvoeKvj3B0xa7ZmgM4KTX6LHKODV66AautcfV61S8UyaMQnnzDLIB58R/NLdlwWiE4gJgymUcxFnmm+NK
 MpunVM/r
 Z6f6XF0zzfGOtwx5jh9u3cLue0hPTo+bXozrnghIOEHPsRkTfF8+V3ki5zC3OvDaKQ3SN8R9l5vs+AXcqWj8qALSMw/WpZuGJed3cQyvhMXq0mArQSWqmpVvQRUcm5enkhakKJ7F747dz6kh1fF4EVL7/lGOkdcFOeKqAuB7X9jQfxXLb3OoETeUkMWZESBNi33zc8BticykEYZZlHfzieAP0BoiMqWvyMFjDu32daFYAAkG3X6DU12TUURrHjRCxFDi4fFAEQNmR1ZQnxMmPKOQ23Ni3AW+hPgNHRBsg/n3ITbhtnm82MI9sZuAJkfV771PR2TZV/Wi8ob4usr5aU/PyWxNmq+R8KsuxlC+Guba2Ps1I0T2wH1uvn5jsa755dtNJgqVPuylp0F1kYcKoQpAzkTPc6RG5of6sit3kkYWXpupPh9QQ8UmHJ5LQawXPr53MfoekA3DWjLK5byf9cW8TG9wwR5XnKLXW8HTI69exmfcZsJ+nYdA5d/BancuY9JD3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_fork() checks that a fork-shared range collapses in the process
that asks for it while the co-sharer keeps its own page, but the co-sharer
sits still while that happens.

Add a case where the co-sharer writes to the shared range throughout the
collapse.  CoW has to keep the two sides apart under those writes: the
collapsing child must see the content from before the fork, and the
writing parent must see only its own writes.

The co-sharer unshares one page every 10ms, and only once the collapsing
side says it is about to start.  Writing the range in a burst breaks CoW
on all of it before the collapse begins, leaving the child to collapse
pages that are already exclusive to it.

Nothing here is new behaviour: the case passes on mainline, and locks in
isolation that collapse already provides.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 94 +++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 1844ddd77b59..856decd2950a 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1184,6 +1184,97 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * Content stays isolated while a co-sharer writes concurrently. A shared
+ * source is copied live (not frozen), relying on it being CoW - immutable
+ * for the duration of the copy; a co-sharer's write goes to a CoW copy. The
+ * collapsing child must see the pre-fork content, the writing parent only
+ * its own writes.
+ */
+static void collapse_fork_cow_race(struct collapse_context *c, struct mem_ops *ops)
+{
+	const unsigned long shared = 64 * page_size;
+	const int stride = page_size / sizeof(int);
+	int wstatus, child_status, i, n = shared / page_size;
+	/* volatile: the loop below must really store, on every iteration */
+	volatile int *ip;
+	pid_t child;
+	int sync[2];
+	char go = 1;
+	void *p;
+
+	p = ops->setup_area(1);
+	ip = p;
+	ops->fault(p, 0, shared);		/* shared prefix, pre-fork pattern */
+	if (pipe(sync))
+		ksft_exit_fail_perror("pipe()");
+
+	ksft_print_msg("Fork, collapse in the child while the parent rewrites...");
+	child = fork();
+	if (!child) {
+		int collapse_status;
+
+		close(sync[0]);
+		ops->fault(p, shared, hpage_pmd_size);	/* private remainder */
+		/* Start the parent unsharing, and give it a head start. */
+		if (write(sync[1], &go, 1) != 1)
+			_exit(KSFT_FAIL);
+		usleep(5000);
+		c->collapse("Collapse a range shared with a writing co-sharer",
+			    p, 1, ops, true);
+		collapse_status = exit_status;
+		for (i = 0; i < n; i++)
+			if (ip[i * stride] != i + 0xdead0000)
+				break;
+		if (i == n)
+			success("OK");
+		else
+			fail("Fail: child content");
+		/* The content check must not bury a failed collapse. */
+		if (exit_status != KSFT_FAIL)
+			exit_status = collapse_status;
+		ops->cleanup_area(p, hpage_pmd_size);
+		_exit(exit_status);
+	}
+
+	close(sync[1]);
+	if (read(sync[0], &go, 1) != 1)
+		ksft_exit_fail_msg("child never reached the collapse\n");
+
+	/*
+	 * Unshare one page at a time.  A burst would break CoW on all of them
+	 * in microseconds -- wait_for_scan() does not even poll for TICK --
+	 * and the child would collapse pages already exclusive to it.
+	 */
+	i = 0;
+	do {
+		if (i < n)
+			ip[i * stride] = i + 0xbeef0000;
+		i++;
+		usleep(10 * 1000);
+	} while (waitpid(child, &wstatus, WNOHANG) == 0);
+
+	/* Whatever the paced sweep did not reach, so the check below is exact. */
+	for (; i < n; i++)
+		ip[i * stride] = i + 0xbeef0000;
+	/* A child that died reading the racing pages is a failure, not a zero. */
+	child_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
+
+	ksft_print_msg("Check the parent sees only its own writes...");
+	for (i = 0; i < n; i++)
+		if (ip[i * stride] != i + 0xbeef0000)
+			break;
+	if (i == n)
+		success("OK");
+	else
+		fail("Fail: parent content");
+	ops->cleanup_area(p, hpage_pmd_size);
+	/* Same again: our own check must not bury the child's verdict. */
+	if (exit_status != KSFT_FAIL)
+		exit_status = child_status;
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void madvise_collapse_existing_thps(struct collapse_context *c,
 					   struct mem_ops *ops)
 {
@@ -1740,6 +1831,9 @@ int main(int argc, char **argv)
 	TEST(collapse_max_ptes_shared, khugepaged_context, anon_ops);
 	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
 
+	TEST(collapse_fork_cow_race, khugepaged_context, anon_ops);
+	TEST(collapse_fork_cow_race, madvise_context, anon_ops);
+
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_write_file_read_ops);
-- 
2.54.0


