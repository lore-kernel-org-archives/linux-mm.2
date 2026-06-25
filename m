Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FEFCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D038D6B0116; Thu, 25 Jun 2026 07:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CE36B0117; Thu, 25 Jun 2026 07:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3FA6B0118; Thu, 25 Jun 2026 07:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 887536B0116
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02FAD90318
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:26 +0000 (UTC)
X-FDA: 84918219414.18.00805E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 573524000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=r34I+0qp;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387085;
	b=Irzqy0TYypgnrsuMToFiGUxKVgZ05ckxS7TTCzmo7vy/h1/MRXwT7d1v0XBjk0TZDcYjFA
	EheYfKmmAZuE2xwWeNNUIWYhRJ9hvAqiAzihHVVm7f5ZMAmBzIweO7WyH4WvKeD9APxft3
	TvhjLrFv8lcz4FqPYkFwxAV008twc3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=T4RwVyWcduCtLjwCvYsW7FnU2hKDZrDKxcr1mZM6v5g=;
	b=N91Ey3NIeCGgXkt65a3xyP4GGY/EovtISLVIh2+RAi4Lsun6g781c5HYYz2/LYodOIeMoZ
	R1f1Fu5Z77lK9BFhjLFDE23MPjdu6QjRJNgQgN/YSyZzD20JtTEm+rQE1TgPDy7dX68A1R
	cGcIQEBU2gqgIqiDfdd8lzGgOQe4lAQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=r34I+0qp;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0D7F6014C;
	Thu, 25 Jun 2026 11:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026A91F000E9;
	Thu, 25 Jun 2026 11:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387084;
	bh=T4RwVyWcduCtLjwCvYsW7FnU2hKDZrDKxcr1mZM6v5g=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=r34I+0qp/mDUOGop6NADhedkSwhJujnFrAUWt6nHr5Z7beNcI4NbXiAJmSRGNqyOP
	 TFmWlbNrSwsAcRP06yaEk+zFcfOVxSBaURQDoJ0F1RWJLb3HYuN2DqLpSc4GqDwV5O
	 SQ21qIcPShmsYL2cDpz62Muw+fflWzSRZ7tB5+oo=
Subject: Patch "testing/selftests/mm: add soft-dirty merge self-test" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,avagin@gmail.com,david@kernel.org,elaidya225@gmail.com,gorcunov@gmail.com,gregkh@linuxfoundation.org,jannh@google.com,liam.howlett@oracle.com,linux-mm@kvack.org,ljs@kernel.org,lorenzo.stoakes@oracle.com,mhocko@suse.com,pfalcato@suse.de,rppt@kernel.org,surenb@google.com,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 25 Jun 2026 12:29:48 +0100
In-Reply-To: <20260515124218.151966-11-elaidya225@gmail.com>
Message-ID: <2026062548-squall-dimmer-386f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: 4edmw1y3mfo6iu1hpiene7giumig5acu
X-Rspam-User: 
X-Rspamd-Queue-Id: 573524000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782387085-734256
X-HE-Meta: U2FsdGVkX19B4OkPj7QrAr99uXpqyrhZl7ZB6L/yt9nXLF5wtqIqKH69yWNPe3g9gVtWkfknFFjJXai2lJPmLgkvr5rdMFLTOUXvNHJ1eKQR4sAs2PAxmsM09nyT5umwb3TRus5/eeF4aQiXHdNWuuwQZIZwcMt3xpMLtYe87s5afMQC/6ALhHgN66ttpO8+ph64G8Ajqk9qyg9yK6UuoY1v2xlAm9E6lTqEBArohEYFmXmVru4z8nDj7ye422PG9HqH42L2bOkU99q0zlz3l7fVQym3DUaIbqEfhlyL7Ji9ifW+z06e9wMtc3PlpIapo+O5c0ZxyCVYFRfg/luq5d/qtjaKy3ObV8ntzPFlUUS16q0ekkR+4Dl5YV8WCMbzZCoeC0565E+04UTJ6GTptVgHoLYodlOurz4V+iwfQThUF2qgYXjUSv+fkXwHgxnF3lu1veC5Av2zh4cNkBb2ypFREPSNJqVzldC3OyNAq7/YPHMrjSqAPQABGgnr7/fBE+qei86pkIBdMXlSGDI8PEIqjSIjpV+SwcUubXgGpQBcfm6ZHMSJN51oGndH/bZTE188uvhGoeA6RECI2MMZahE7lCgqTlI6g2xyQk/I3J9Elwq//QIPA5iFGOCOGAt9+RfQkUCIifbeBCGSaoXHcrDG5ErrC0YLsNNMcXycnHtKCycucSUFADpoV9LCYrptLqCj9udHon0ROYWN5/wFbCJEtIxHFk8pXQ1x1woY1+cYRhY3nz/94cR1kIxV61CPjD7HIOYyBl3leyCPD2G2HnAWW3bYAHKNepnfWglV84Jtv65dOKguSuAYfstpZxTFG8MtQONetowKxehnxjTeIBxi4IJpjyBVcjPVFN1fhMNaevXjQ6HqWwuItsVtCJdYp0zr+wC+ZEQ6V9DaArLK9W0FSng+sQLT+r2YNIpqalEO3g+SXnimT5acAXOrdIO9oWT6feHhvWzpheD4Ayy
 4pMJsZcT
 qB8sVEfwwf0jLi2xKolwtEulKwSqzzBGJroRuCGdVm+LsVXjHj6ZRbFGchCqghVmAmtbayU5AQad5zgIhT82f+t7vcy4WQnRZHrnReNR+L7f0Yno6qo1y+oRau8ZOH40Ly34D344ohrTjpk5dsTlLHmnchF2/KShYkVCYIQq+hChgfl4xoLfVMhzPPWQWEeb2l9M7iGzoZM0JKbbC+Dxp+m4RfvAChel4ya3+yorPApMe0naGXRUoiCoSVK+08NWTrvVm4kkyxquP1BTL/RkKAUOmftk+g3ARnTA4tVaYGyuiiqkT7cDMYtWaM0nakbnJlC/7namPc4fmaPTiTeNRBr1pjcBQi+tcCL1dfNgQ6VQypPQ1LUvYirxYUmKpc5m/mkWDiyeReIkqdWRaDPubtBZndD7b/wqgC05Oe5tEX2ujySD0E3GwhV6SbEruesWAl6TmirE/p7xHJq8BLES+APedTKklbfGllN9dPFytk0JRzq7pqXKiCd4hcQtmdTVM4fnv9pfn0QuJ7o3aFYxSCv+SAK2dGMpn4F0qOzsP5y/s5Nsd7zEIzutsVgsxWowGuehVnTK2ns8Sg4JY7oDmYFf8eI79tUuPRRKvU27HLUzNDQk24p2K5gptZMVfDpeG8ZxRPk5CZv7fwH+cGC7MTGA4xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    testing/selftests/mm: add soft-dirty merge self-test

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     testing-selftests-mm-add-soft-dirty-merge-self-test.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-247756-greg=kroah.com@vger.kernel.org Fri May 15 14:06:06 2026
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 15 May 2026 15:42:19 +0300
Subject: testing/selftests/mm: add soft-dirty merge self-test
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, avagin@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Jann Horn <jannh@google.com>, Liam Howlett <liam.howlett@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Cyrill Gorcunov <gorcunov@gmail.com>, Ahmed Elaidy <elaidya225@gmail.com>
Message-ID: <20260515124218.151966-11-elaidya225@gmail.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit c7ba92bcfea34f6b4afc744c3b65c8f7420fefe0 upstream.

Assert that we correctly merge VMAs containing VM_SOFTDIRTY flags now that
we correctly handle these as sticky.

In order to do so, we have to account for the fact the pagemap interface
checks soft dirty PTEs and additionally that newly merged VMAs are marked
VM_SOFTDIRTY.

We do this by using use unfaulted anon VMAs, establishing one and clearing
references on that one, before establishing another and merging the two
before checking that soft-dirty is propagated as expected.

We check that this functions correctly with mremap() and mprotect() as
sample cases, because VMA merge of adjacent newly mapped VMAs will
automatically be made soft-dirty due to existing logic which does so.

We are therefore exercising other means of merging VMAs.

Link: https://lkml.kernel.org/r/d5a0f735783fb4f30a604f570ede02ccc5e29be9.1763399675.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrey Vagin <avagin@gmail.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/soft-dirty.c |  127 +++++++++++++++++++++++++++++++-
 1 file changed, 126 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -184,6 +184,130 @@ static void test_mprotect(int pagemap_fd
 		close(test_fd);
 }
 
+static void test_merge(int pagemap_fd, int pagesize)
+{
+	char *reserved, *map, *map2;
+
+	/*
+	 * Reserve space for tests:
+	 *
+	 *   ---padding to ---
+	 *   |   avoid adj.  |
+	 *   v     merge     v
+	 * |---|---|---|---|---|
+	 * |   | 1 | 2 | 3 |   |
+	 * |---|---|---|---|---|
+	 */
+	reserved = mmap(NULL, 5 * pagesize, PROT_NONE,
+			MAP_ANON | MAP_PRIVATE, -1, 0);
+	if (reserved == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	munmap(reserved, 4 * pagesize);
+
+	/*
+	 * Establish initial VMA:
+	 *
+	 *      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* This will clear VM_SOFTDIRTY too. */
+	clear_softdirty();
+
+	/*
+	 * Now place a new mapping which will be marked VM_SOFTDIRTY. Away from
+	 * map:
+	 *
+	 *       -      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   | 2 |   |
+	 * |---|---|---|---|---|
+	 */
+	map2 = mmap(&reserved[3 * pagesize], pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now remap it immediately adjacent to map, if the merge correctly
+	 * propagates VM_SOFTDIRTY, we should then observe the VMA as a whole
+	 * being marked soft-dirty:
+	 *
+	 *       merge
+	 *        S/D
+	 * |---|-------|---|---|
+	 * |   |   1   |   |   |
+	 * |---|-------|---|---|
+	 */
+	map2 = mremap(map2, pagesize, pagesize, MREMAP_FIXED | MREMAP_MAYMOVE,
+		      &reserved[2 * pagesize]);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mremap failed\n");
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after remap merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after remap merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+
+	/*
+	 * Now establish another VMA:
+	 *
+	 *      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* Clear VM_SOFTDIRTY... */
+	clear_softdirty();
+	/* ...and establish incompatible adjacent VMA:
+	 *
+	 *       -  S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 | 2 |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map2 = mmap(&reserved[2 * pagesize], pagesize,
+	PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now mprotect() VMA 1 so it's compatible with 2 and therefore merges:
+	 *
+	 *       merge
+	 *        S/D
+	 * |---|-------|---|---|
+	 * |   |   1   |   |   |
+	 * |---|-------|---|---|
+	 */
+	if (mprotect(map, pagesize, PROT_READ | PROT_WRITE | PROT_EXEC))
+		ksft_exit_fail_msg("mprotect failed\n");
+
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after mprotect merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after mprotect merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+}
+
 static void test_mprotect_anon(int pagemap_fd, int pagesize)
 {
 	test_mprotect(pagemap_fd, pagesize, true);
@@ -204,7 +328,7 @@ int main(int argc, char **argv)
 	if (!softdirty_supported())
 		ksft_exit_skip("soft-dirty is not support\n");
 
-	ksft_set_plan(15);
+	ksft_set_plan(19);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
@@ -216,6 +340,7 @@ int main(int argc, char **argv)
 	test_hugepage(pagemap_fd, pagesize);
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
+	test_merge(pagemap_fd, pagesize);
 
 	close(pagemap_fd);
 


Patches currently in stable-queue which might be from elaidya225@gmail.com are

queue-6.18/testing-selftests-mm-add-soft-dirty-merge-self-test.patch
queue-6.18/mm-implement-sticky-vma-flags.patch
queue-6.18/mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
queue-6.18/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
queue-6.18/mm-propagate-vm_softdirty-on-merge.patch
queue-6.18/mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
queue-6.18/mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
queue-6.18/mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch

