Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61498C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF026B008A; Tue, 14 Jul 2026 06:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F796B008C; Tue, 14 Jul 2026 06:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CD56B0093; Tue, 14 Jul 2026 06:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C96FB6B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:39:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27EADC0314
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:39:23 +0000 (UTC)
X-FDA: 84987035406.23.81551AC
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36CD7180004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:39:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=FaM0bWVt;
	spf=pass (imf06.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=debian.org (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784025561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIy8s9LzAS3y+QKpstmCYWZM0GNo86vujkJXCwSEINs=;
	b=FJRnrldYa/YJ6jgPuQaYfG5C7llbpFpK8dL9XOVt5S8TSBh0VPEtVrW32gstfBrpie5/cO
	xY6r4ZnCVeiTLHu/XijUcndrLZsu6RsWFcJvzNJ3ovv4HAOPv6eycV69D1OoQ7qY/zENih
	5QlXuUyMlwwe+d+5AUiaae1hXBXpac4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=FaM0bWVt;
	spf=pass (imf06.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=debian.org (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784025561;
	b=2PU7KdkRHe9uJ3EniOavX+we3RYjyZbjk7/olW6zABQlRWXBteXJsxtkL0s90lFAq35Qum
	HPOFxORc+FaLFVdB9hLUGs1+OAP630KVEqbcTB5FcPx6Gf+MvGV5rmkYbMOrnYt9LcxBbB
	eTpbmq3y2TW3jjbZtOgbdxLrszL/DZ0=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id DB32E2003C6;
	Tue, 14 Jul 2026 12:39:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sIy8s9LzAS3y+QKpstmCYWZM0GNo86vujkJXCwSEINs=; b=FaM0bWVtNQm8x3pORnNDjylI1t
	MePw4aTl5Ae2RQCGqkEtQ0Hzwgs9Int4Ih3FL2prad7sXNFfIYyXDQWYYH0rN4IEdZOp/ezuABjI/
	QDY98y+oxgduz1iQ6/+rYICC2YqI/brpoT+mnnrduT3GcEvTmC1n9enmt5jaUFsJ2SoI=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wjaXg-00000003ZQI-0s2B;
	Tue, 14 Jul 2026 12:39:12 +0200
Date: Tue, 14 Jul 2026 12:39:12 +0200
From: Guillaume Morin <gemorin@debian.org>
To: Breno Leitao <leitao@debian.org>
Cc: Guillaume Morin <guillaume@morinfr.org>, osalvador@suse.de,
	avid@kernel.org, linux-mm@kvack.org, riel@surriel.com,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <alYR0NXacVVKKstj@bender.morinfr.org>
References: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
 <alSyhslcItgtqSHT@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alSyhslcItgtqSHT@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36CD7180004
X-Stat-Signature: 5w7d7u64j9hpc93ha1rgd7t4bj83b6nz
X-HE-Tag: 1784025561-663445
X-HE-Meta: U2FsdGVkX19pT9j3RBDnjn4vMtRgPmdlEHgTNdCm66x7VzD6A9a+G7KCCxIqcpHBVUpTlY5eFDvRO0qJt9K0kCCx7sXqXxyrMuOtO+X82/lbwPoTaUrttzjs5PAt8mMPtrCdKp2wanULCq/Fd9DMWyTnyFw8DCapw0fACL9EcYLPmUefe0dsx0Nef94bY7vuEMxUAER6R8OqRWgwbyEyPSxKMRiVvRdCr+7BKhkj05PoNSZYW7Qgyafz/t4tX54uJKV4S4YTVtco1MQe8GeO3pDXkioGEP6vz8NIZOOCTwuTyBkyAouP3/7ZF/jlqmgaPTaUHcONCvBLjR1J3faXW/N7wftKfTaC38SHH3XCyT692svuKLoANsZemMc9LkNKGk8AvpQxdX2szrctDK1WbeT2hUkwmZ+r+TJWiZ40QqhAymYj9otP4zQ0AUAMAc65WDMgBSZIFWOosQxf57tkXYt/ZONE2pa0BfeWf90k48ZGVK+1Vxr8wiUu+HQWM/kWtrsr4OuqHNXoNyBenS0oV0HvtMGEI9Ys5Z5UibZ1rO4Ly1t4Ey6sTda1sdvH+uRRFtN/smEkx8AWBPWy3sKI0C0lmgSCUjHnh24LH61f7SN6P3DR19zg5vSMwoY+w6kOyVuAoIFeQM6wzF/FQ1KmRTucKW2sE8k5FPPhcKXBsbBcCqNT6JXDZd1fGIf0NMz0ZRKJf0WBEUiy466k7gSeZxttVPZMwgF/arfxsvAx/kqM0tWiWzvwevzALeHac2UDClnnA6h1ag85hWj+2p+KF651vKxOVxy5t6xxkkNgAe9aDU2dseJZDDNlXxyxuV92xNrxS6PSb8I5gN71drG2PiBmhD1zy32JDdTOBfdcnRGAaNc0wMNFEbxVk2RYwRXFg1mTpfpZS3pZcRzMP5poVskZHr/vWeVhJTCBwAsolgzWj9w3Hp3yU9DefBEmynlMfcWrAD/CeVIoYeB1VBu
 lxf5kTfG
 WajCJ/cqRKN2d5fqlZZdVuwyTAEQkqHqOp5SeEDH2X0sxCUyPPzHmwTNSXdrO3CsNJkHrCVB+Lj40kqSiEk0Q6uJ3EQJ9UlK0VTb1KpiNln/mxi1eP6g/VWZCbQ40rhikpUJFSW6926OzI5kU/CsIXQfwTz654qjvhdo2SUz4gZDeRlU5OSdYhdCzhU4eXwqQhN3K03Pct5ghK9YjkbHHa2JBBGOKjOy4vJZe+vbvZ1o3nGC+Ps7jsa6H01a3kCV3ypeYcYBK02Wqk8nq9+AuuY/2oYUzSkv61IxFfa/wpbWV9PH+AxTMGmXWLxq75xCU03Ulx73OtJEc/xehRKl9fGXpgj8bBGXsmhmv6H2/AG9WBDXFrXN+ZHVCT5oe/04zGEsWXOsPEsLC0UGr5fHm8GQJqufnvjA+q4eLa+xk/3NtkknSrviM6JqIUWiHOFYLyQmYREHfUaFlL0yZRUf4KTf4mGrZVIvfbZ1sXQi/MAqJz6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

