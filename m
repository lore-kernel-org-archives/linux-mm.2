Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7469C10F9314
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBAF6B0096; Tue, 31 Mar 2026 20:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2A36B0098; Tue, 31 Mar 2026 20:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10546B0099; Tue, 31 Mar 2026 20:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE2916B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:58:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79D3913B062
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:58:55 +0000 (UTC)
X-FDA: 84608177430.05.616C7D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C33BE100007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:58:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tJJdDCpx;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775005133; a=rsa-sha256;
	cv=none;
	b=jR+el+UcNPZ31H9R6ifv6awpmVxeJpU1gfwyVJTCw3FmXoNEqBu/mIyUVJu/m4w9B0WDN6
	WqyGTjTUMvOwXyp/LTL4Wytdvl540OtHK9qwppA7rJ5E2ZsTNz36w+IsO/QcPi8GXjKfco
	twPTeBzAW1DiWyHuc76ssMk25qHWykU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tJJdDCpx;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775005133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EI6ITQaTZCSabVtHDRTSHVBGbXkfQiiQnl+pETXGvgo=;
	b=8TyjS4RngbgAWKnwsOYi4CjGS2zc/H2L+e1zrdcvgxRfrsJ16bzYqK3agvqs93lU+ZSn5X
	K3ywSp1iMO9c1yK3gawU6/XsQi3U6V5KAgXgJmDlSk7I5704NKpO+61dGwODfARdYnvEnU
	DEQ2YlMRwo5gn1fABmPMhGxq5i+E2O8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2332F60053;
	Wed,  1 Apr 2026 00:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CABC2BCB0;
	Wed,  1 Apr 2026 00:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775005132;
	bh=6uvvI24uKLyEUjv5RmaJDmn4RdtHPCKZJX87cczPN3M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tJJdDCpxZgv01q20W7DE15ULLB4jV5P0rngjpWOIcxhv/oJ5W8LixjUZiH01mmeRC
	 x/C/B0L0xK7uhJ2IQLSQgkV6TfIcY9JPnkveP1nOoUpBmDDfuyUwg6Fq5gChbOa52a
	 SnkXbg1cdfONCkyZwh9eynHhbpz9V3jxj6Q2cneI=
Date: Tue, 31 Mar 2026 17:58:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, David Hildenbrand <david@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/selftests: add merge test for partial
 msealed range
Message-Id: <20260331175851.91867c426e09a5b3eccc1d6f@linux-foundation.org>
In-Reply-To: <1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local>
References: <20260331073627.50010-1-ljs@kernel.org>
	<ne3bppkwlk2srskam72k56jq5q63dhnvk67vzztciw2uxxcyr6@gki5bfznhqxa>
	<1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y8twnpwruekyb68ksnad5cgx6no98mdt
X-Rspamd-Queue-Id: C33BE100007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775005133-594753
X-HE-Meta: U2FsdGVkX1+C7XjD7Qc9lM5srU5odqu3PopUIkdX4MP2MaThgXSUs98zddcp++7GluJLkZLSYF0cM1r+fnl6ADYO9fe87dsSUWY5YjQASbEbmKOfOTDz487GqoZqA1Vmx6+twkARqAa9vKUksb5YSJDYz6EkmtPLmP2MImxKGzcmIC+qRHouDPJiS8mkVfrp3nNuzJMAbEU4v6VUYwCPjZg86T52cfHB46WMLIP4yg1ZlfAGMKtTTpGINLdNzoGthFtfyWC/utrUIoY7LkXE7QZ6KcddVDrn9f4Q6jBvPwuHvgy4orPhddl/I86emwGT6KNkl4H8f3DbjZYBCuzXPCC2Njo0AHXDPG/nuG4uJ/WeZoTPoEV6m2zJi9J+MXLI5Bwdj93YGpxL0j+QoFAGCj0vgPNJeAxTtvpoa6otmfdXstWFVR+PxANnOanb62bGuGo3zzDaoMxsbuAhGAvpJnMqbVaElSRStwd+kd0NbyJmsfemIzpg9+pBmD00ZH4e/w9Q/fJTmylrs0Iu73nlh8auIFnS9GuARPWsOXqP7y7VyHE1UtunTy3Cz7/HJmzG1sjfRJSSQ9vscke1Gm0xMiHMJzAGkxNJl4CIrgUo0BBBiUewrtYx3DTk5+nleecZfAqyMwffRgtUjGS6Aen8TgNSiA5AUdwWjkH8rUYWOEOBdAHtFP9hkf8XHeRnaY0IqWaZnpRp4XSkddNla6E3RPrCHCJPiJ2tWU7h6fpHKtjX0rqXQ1Jm5mWsuvqUpPkSmj94xt6hPaa6PQp5c1iSAM4BbSKdc/FVJ5oGgswC6L/TsjALNx5mQKRKwifibsV52IrwRFcyR7EufD5GfyhbkFrlZ2JMNsHHUv4RHRPp1HLvNi00qisj1UjNOBk1S8q6d8HI4SEuvi+Gu36yPeRXZC25KUt+aPNhqSh3Y+/WuEMi4mXxQY9aCBiF84Up5cvjlSs8cYIAbFuDoBdOu+D
 HhdWY+tu
 nkrX7cHTaNJ/FnyxgK5K6+oqZoYuubjojsw5J951DTBhkyAYhy4joeQ/29eD8OBhkkFtl9OcemSd2Bn0bGx8+jtpNfhQUBHoi851oSPdOxhDXCqvyXPtqzHJXhqM54igcNRelE2u4aIOgvQUWY0u5X1qYeekrzgwiSxKtkJF0IzuAU+P6v9O2pQC1wVOJedMaC/uwkGrhi3ZhZvMQUoU5S1T0p1Mu62HuYalG+tNOEb1/hySvhw6nw3zifKj+I+j31pv+AYGT1F+GPKHgppRzTCSX8THqioMSaYLOcC1vLefOdv9M+JqYpWj8eEvhxKjvcpxFc2Ih//dGN+lhW7s9TPK/NBgYCVS3lJhrLh/dAuscUwSPnb7fmSdsj6sJqq0cUxxbCUsxocTLFWZEaKNZc2BC2+CDDS8ZDIBEG3cIZfUGLcJ6ANdd9UEBdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 11:08:03 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Then again, and contradicting myself elsewhere on fix-patches blah blah blah,
> since this is just test code, I checked the below and it works the same and
> triggers the regression.
> 
> So maybe we can just apply that?

Here's how the two folded together will look:


From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools/testing/selftests: add merge test for partial msealed range
Date: Tue, 31 Mar 2026 08:36:27 +0100

Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
an issue in the loop which iterates through VMAs applying mseal, which was
triggered by mseal()'ing a range of VMAs where the second was mseal()'d
and the first mergeable with it, once mseal()'d.

Add a regression test to assert that this behaviour is correct.  We place
it in the merge selftests as this is strictly an issue with merging (via a
vma_modify() invocation).

It also asserts that mseal()'d ranges are correctly merged as you'd
expect.

The test is implemented such that it is skipped if mseal() is not
available on the system.

[ljs@kernel.org: simplifications per Pedro]
  Link: https://lkml.kernel.org/r/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local
Link: https://lkml.kernel.org/r/20260331073627.50010-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   89 +++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-merge-test-for-partial-msealed-range
+++ a/tools/testing/selftests/mm/merge.c
@@ -2,6 +2,7 @@
 
 #define _GNU_SOURCE
 #include "kselftest_harness.h"
+#include <asm-generic/unistd.h>
 #include <linux/prctl.h>
 #include <fcntl.h>
 #include <stdio.h>
@@ -48,6 +49,19 @@ static pid_t do_fork(struct procmap_fd *
 	return 0;
 }
 
+#ifdef __NR_mseal
+static int sys_mseal(void *ptr, size_t len, unsigned long flags)
+{
+	return syscall(__NR_mseal, (unsigned long)ptr, len, flags);
+}
+#else
+static int sys_mseal(void *ptr, size_t len, unsigned long flags)
+{
+	errno = ENOSYS;
+	return -1;
+}
+#endif
+
 FIXTURE_SETUP(merge)
 {
 	self->page_size = psize();
@@ -1217,6 +1231,81 @@ TEST_F(merge, mremap_correct_placed_faul
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
+TEST_F(merge, merge_vmas_with_mseal)
+{
+	unsigned int page_size = self->page_size;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2, *ptr3;
+	/* We need our own as cannot munmap() once sealed. */
+	char *carveout;
+
+	/* Invalid mseal() call to see if implemented. */
+	ASSERT_EQ(sys_mseal(NULL, 0, ~0UL), -1);
+	if (errno == ENOSYS)
+		SKIP(return, "mseal not supported, skipping.");
+
+	/* Map carveout. */
+	carveout = mmap(NULL, 5 * page_size, PROT_NONE,
+			MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(carveout, MAP_FAILED);
+
+	/*
+	 * Map 3 separate VMAs:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWE    |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
+		    PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr3 = mmap(&carveout[3 * page_size], page_size, PROT_READ,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/*
+	 * mseal the second VMA:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ASSERT_EQ(sys_mseal(ptr2, page_size, 0), 0);
+
+	/* Make first VMA mergeable upon mseal. */
+	ASSERT_EQ(mprotect(ptr, page_size,
+			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
+	/*
+	 * At this point we have:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RWE    |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 *
+	 * Now mseal all of the VMAs.
+	 */
+	ASSERT_EQ(sys_mseal(ptr, 3 * page_size, 0), 0);
+
+	/*
+	 * We should end up with:
+	 *
+	 * |-----------------------|-----------|
+	 * |          RWES         |    ROS    |
+	 * |-----------------------|-----------|
+	 *            ptr               ptr3
+	 */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
_


