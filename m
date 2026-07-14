Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F2CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93DB86B0005; Tue, 14 Jul 2026 06:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEE76B0088; Tue, 14 Jul 2026 06:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD3C6B008A; Tue, 14 Jul 2026 06:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8E56B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:48:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA596C0323
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:48:25 +0000 (UTC)
X-FDA: 84987058170.16.5D77916
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF8A5C0002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:48:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=owAkIuyg;
	dmarc=pass (policy=quarantine) header.from=morinfr.org;
	spf=pass (imf10.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784026104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEgwL1IKqZfGUrOyC7LTidplKFGkQUk+g+MtogZxKQs=;
	b=fiOVlax9J0o8/lc8skXvDPEJfDFaCYNEo0nHCAuiB3FYnoEKnrkAtPOIJjQo+HVKWTHbyu
	rZo7rD0kUcY80TiYryjg8T1bw6Bx1Osgnc/RlXjm/vfrGN9hlsuOtLnI+mN+exL1ioiX9a
	lONDWwP9HZe63T2Cepvin+bESl2kLpI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=owAkIuyg;
	dmarc=pass (policy=quarantine) header.from=morinfr.org;
	spf=pass (imf10.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784026104;
	b=nDMRiCUyBMNJ6jc1EIvJ+CtFlMqI8/eOoD2GNTIF0wlsYJ/02Zh5yUhdYIKOTGspjYqCwG
	7Sr0w6k8zPtzkX4QHBuwnx5pIYeNigG9uSR6gvtXAuM79N36b51jFNyEomu/cyJ3E1Xwr0
	PcWIlsC72S0CKAHdPgFJleyvL1MoWQQ=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id C5F4E2003BE;
	Tue, 14 Jul 2026 12:48:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bEgwL1IKqZfGUrOyC7LTidplKFGkQUk+g+MtogZxKQs=; b=owAkIuygiGas8VfqRdJaiFwZV1
	m4sKUiqDyCY7lwLYT+vtEM69Y2aPcIvq0U1yzmrazE+/pqjceqK7woQlMU9mO0MljUarmyIeL6FVv
	X2IAwfuh9uIpy+VvbX05a1Dxulg0IasPKuNPjuYpL4BOkXdbTQBdprDpY1VBosFC3bjg=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wjagS-00000003ZbJ-0zzM;
	Tue, 14 Jul 2026 12:48:16 +0200
Date: Tue, 14 Jul 2026 12:48:16 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Breno Leitao <leitao@debian.org>
Cc: Guillaume Morin <guillaume@morinfr.org>, osalvador@suse.de,
	avid@kernel.org, linux-mm@kvack.org, riel@surriel.com,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <alYT8J9aRQDx_8pP@bender.morinfr.org>
References: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
 <alSyhslcItgtqSHT@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alSyhslcItgtqSHT@gmail.com>
X-Stat-Signature: jjisxjw3pbox6mh4pw1xup8mzg9z5f8i
X-Rspamd-Queue-Id: CF8A5C0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784026103-635715
X-HE-Meta: U2FsdGVkX1/7Cx58TQybWvR0RqN8dMZrkPlkEkwoteJcs1Q7utkSODUXI3LkIgJia5wWCf9cz6xhgTb26IcxvrILMlZmkCpRRkG4f32fHM5Qw/V1ftYcqApR0YXFhX7gSuzBJ8IGeGl4pO30VsJHrXI3QmLQU+P2Sy8mpXcVNUag2is0dY7aWlPczaUjjjximZ/v7lB49oWDxt6nPu2K4tetcJRW2UxrNu9oAibEKgQgJcnKSrM97Tsy4Cj2xAb5IuuyhWpnLWQspcI+FHi2PPc8YqnQhtDlwrraKe6EimmRKvyEzjtUUjztLdjmozv5KT6+fCx3hEX8HCVrjkZWY1JuG2ehkPfIm3NsG4qivoa6gnv/zrg5TsUHhHs3SHo/lZL51FDPX2NI2cojtf15D5+oaYjvyqWp3wOChJEOiNrCNzGAQrwx+KPPyBkQcuIajY8gc9fgVVwu2D1ndaPitRJokMwSQF1hvan86ZFqdqdLVMNGiWnxlBwN5PUB+Hc2Mj+2yff29KOJpugrFP7KcQSqnKIDWa3LLTvHk8PPP4WKD+k27n2+tsLY/hQaRuEg+DaatIOv7lFt0qbut4JW/o1olenI2Ei9mfBoarj4fHYgCEXC6Bc5XpWTXO0zQFQRd3/PvE6W//fcHKoIuRL81P4xEYriOiPrwvGWE4xYIDt6FR7SHY+GQVcpNH+izEY+hoRc48bWJ4RQabivl3V0Pl/OD0GHc8CAU/zlQ4JvMaxab7BKsMQja39CWvki1g7ADD55oZ7EqbNduO+gHYQs20HlK33bBWuD6l9U9dIN0tiaClI9IYihUE+KAJK33sJ7UL9bbaSE+UDF/HCcI4fgDD0nm4FQLRcQUUVF+Kuo0/ITPTKCH4Ew/T8ndXvvx1XYXnk/Rxt2TGZIYJ7gJJy8rRbIQQqcyNpN83o6HNCBjLa+OGsdnWBvI/aDA9PKNxbwOCpL0VdYGKAYiA12z2D
 mSN6JIDs
 A768jiam9gDloSaLoAkZM3B692nJmkrylycrfCEAdcXxCdOEO2X6EYXRxcel8+gAth+RGWtgr2d9MlCmKp+NmcS/cWthFgPbMvoBy582pKqiygHx5ZnMWn5ndcewX4+hCweWI98162QhrG+Y1qq4xjniyKljVz4KxbDFhtnxphGZO9nbZxVFu287L//KCzb4b5NKsx4PqhvrreyVaJj2HcAh5Oo/ZK+oZZfsYttnb64yjDDgnM2NdqZkCX1pm72O9rodyrL8NPkjDYK6ULu1Hf8v7JBzNizyVSQYZApZgd3SPGmKLgHZo+tQ6RO+kAMTsOoI/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the resend, an old send hook put an old email address. Fixed
now.

Hello Breno,

On 13 Jul  2:43, Breno Leitao wrote:
> On Fri, Jul 10, 2026 at 05:02:43PM +0200, Guillaume Morin wrote:
> > Hi,
> > 
> > We've encountered a temporary underflow in the reserved count after a fork when
> > a parent unmaps a faulted hugetlb page before a child process. 
> > 
> > After a reservation is consumed (i.e the page is faulted), if there is a fork()
> > and the parent munmaps the page before the child, the reserved count
> > underflows. The count is restored when the child unmaps the page/exits. I have
> > reproduced the issue in 6.12.95 and 6.18.38. I believe it's still present in
> > 7.2-rc2 but didn't try to reproduce.
> 
> Thanks for the detailed report and the reproducer.
> 
> I reproduced the underflow on current linux-next (7.2.0-rc2-next-20260710)
> with your program — it fires on every run. I also confirmed your
> folio_mapcount() == 0 check fixes it: with it applied the underflow is gone
> across many runs, and the existing hugetlb reservation selftests still pass.
> 
> > The patch that seems to have introduced the issue is df7a6d1f6405, "mm/hugetlb:
> > restore the reservation if needed"
> > 
> > I am not sure what the best fix is but checking folio_mapcount() == 0 
> > in __unmap_hugepage_range() seems to do the trick
> > 
> >                 adjust_reservation = false;
> >  
> >                 spin_lock_irq(&hugetlb_lock);
> >                 if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> > -                   folio_test_anon(folio)) {
> > +                   folio_test_anon(folio) &&
> > +                   folio_mapcount(folio) == 0) {
> >                         folio_set_hugetlb_restore_reserve(page_folio(page));
> >                         /* Reservation to be adjusted after the spin lock */
> >                         adjust_reservation = true;
> 
> The fix looks correct to me.

Excellent! Will you be submitting a patch or do you need me to do
something there?

> > Reproducer (it only works if HugePages_Rsvd is 0 at the beginning of the test)
> 
> Would you be up for turning your reproducer into an expansion of the selftest
> I've added a while ago for the fix I've added a while ago:
> 
>     tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> 
> Your case is a nice complement to it, so it'd be great to have it there.

I've never used the selftest API but I gave it a shot. Hopefully it's a
decent first try

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 2eab2110ac6a..02323389df39 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <ctype.h>
 #include <dirent.h>
 #include <fcntl.h>
 #include <limits.h>
@@ -449,6 +450,34 @@ unsigned long hugetlb_free_pages(unsigned long size)
 	return read_num(path);
 }
 
+bool hugetlb_nr_resv_pages(unsigned long *num)
+{
+	const char* field = "HugePages_Rsvd: ";
+	FILE *f = fopen("/proc/meminfo", "r");
+	char line[256];
+
+	if (!f) {
+		ksft_perror("Could not open /proc/meminfo");
+		return false;
+	}
+	while (fgets(line, sizeof(line), f)) {
+		if (strncmp(line, field, strlen(field)))
+			continue;
+		const char *p = line + strlen(field);
+		while (*p && isspace(*p))
+			++p;
+		if (!*p) {
+			break;
+		}
+		*num = strtoul(p, NULL, 10);
+		fclose(f);
+		return true;
+	}
+	fclose(f);
+	ksft_perror("could not parse /proc/meminfo");
+	return false;
+}
+
 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
 {
 	unsigned long free = hugetlb_free_pages(size);
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 726c73c43c05..a73146c8e4a4 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -98,6 +98,7 @@ unsigned long default_huge_page_size(void);
 unsigned long hugetlb_nr_pages(unsigned long size);
 void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
 unsigned long hugetlb_free_pages(unsigned long size);
+bool hugetlb_nr_resv_pages(unsigned long *num);
 
 static inline void hugetlb_save_settings(void)
 {
diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index f94549efcc6f..f3ee3aa49322 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -15,13 +15,20 @@
  *
  *  Touching the first page after thread3's allocation will raise a SIGBUS
  *
+ *  We setup a 2nd test where we create a child process, then unmap the page in
+ *  the parent while the child waits and verify that there is no underflow
+ *  of the reserved count.
+ *
  *  Author: Breno Leitao <leitao@debian.org>
  */
+#include <limits.h>
 #include <pthread.h>
+#include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <unistd.h>
 
 #include "vm_util.h"
@@ -86,7 +93,7 @@ int main(void)
 	int max = 10;
 
 	ksft_print_header();
-	ksft_set_plan(1);
+	ksft_set_plan(3);
 
 	if (!hugetlb_setup_default_exact(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
@@ -120,5 +127,88 @@ int main(void)
 	}
 
 	ksft_test_result_pass("No unexpected huge page allocations\n");
+	huge_ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+
+	if ((unsigned long)huge_ptr == -1)
+		ksft_exit_fail_msg("Failed to allocate huge page\n");
+
+	{
+		pid_t pid;
+		int pipe_fds[2];
+		unsigned long nr_reserved = 0;
+		if (!hugetlb_nr_resv_pages(&nr_reserved))
+			ksft_exit_fail_msg("Cannot read number of reserved pages\n");
+		else if (nr_reserved != 1)
+			ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 1\n",
+					   nr_reserved);
+
+		/* Force the fault to ensure the reservation is consumed */
+		*huge_ptr = 0;
+		if (!hugetlb_nr_resv_pages(&nr_reserved))
+			ksft_exit_fail_msg("Cannot read number of reserved pages\n");
+		else if (nr_reserved != 0)
+			ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 0\n",
+					   nr_reserved);
+
+		if (pipe(pipe_fds) != 0) {
+			ksft_exit_fail_msg("pipe failed");
+		}
+
+		pid = fork();
+		if (pid < 0) {
+			ksft_exit_fail_msg("fork failed");
+		}
+
+		if (pid == 0) {
+			/* Child: Simply wait for the parent */
+			char b;
+			close(pipe_fds[1]);
+			if (read(pipe_fds[0], &b, 1) < 0) {
+				ksft_exit_fail_msg("child read failed");
+			}
+			return 0;
+		}
+
+		/* Parent */
+		close(pipe_fds[0]);
+
+		/* First unmap, this will close the vma */
+		if (munmap(huge_ptr, mmap_size) != 0) {
+			kill(pid, SIGKILL);
+			ksft_exit_fail_msg("munmap failed");
+		}
+
+		if (!hugetlb_nr_resv_pages(&nr_reserved))
+			ksft_exit_fail_msg("Cannot read number of reserved pages\n");
+		if (nr_reserved == ULONG_MAX) {
+			ksft_test_result_fail("After the munmap, HugePages_Rsvd underflowed!\n");
+		} else if (nr_reserved == 0) {
+			ksft_test_result_pass("Underflow not present!\n");
+		} else {
+			ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after munmap, should "
+					   "be 0 or -1. Repeat the test\n",
+					   nr_reserved);
+		}
+		/* Make the child exit, this should restore HugePages_Rsvd to 0 */
+		if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
+			kill(pid, SIGKILL);
+			ksft_exit_fail_msg("write failed");
+		}
+		close(pipe_fds[1]);
+		if (waitpid(pid, NULL, 0) <= 0) {
+			ksft_exit_fail_msg("write failed");
+		}
+
+		if (!hugetlb_nr_resv_pages(&nr_reserved))
+			ksft_exit_fail_msg("Cannot read number of reserved pages\n");
+		if (nr_reserved == 0) {
+			ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
+		} else {
+			ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after "
+					   "the child termination munmap, should be 0 or -1. "
+					   "Repeat the test\n", nr_reserved);
+		}
+	}
 	ksft_finished();
 }

-- 
Guillaume Morin <guillaume@morinfr.org>

