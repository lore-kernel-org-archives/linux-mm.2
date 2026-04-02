Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BA7D6AAF0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 16:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970446B0088; Thu,  2 Apr 2026 12:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947986B0089; Thu,  2 Apr 2026 12:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8846A6B008A; Thu,  2 Apr 2026 12:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76AA46B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:37:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE116C27E7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:37:21 +0000 (UTC)
X-FDA: 84614171082.22.F87499D
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id F23B6A0019
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:37:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=b+rYNlSv;
	spf=pass (imf25.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775147840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6ImdGXD+GMNXPRP0/gybrarmqeg2HPXNHpY8bxE1bfA=;
	b=RQdpjghJdbXlSXWPKf3uUk39dZJt2KCSfzonKRhta3kHe7FWNdLIrDuHQiPtmqD2FpejvI
	4vNzPJb1YF0UtG3c7t3NOZxgzSijGkqh6U//2A3vkxrsS8ooATOQ97jbNeP+C9b5tggyee
	hW1Gzziqww9/CqH8YMAO4Idaoaz3QCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775147840; a=rsa-sha256;
	cv=none;
	b=oYn6nfXEnrhXVtEl0StvZPuparm7X8pscYvgRAvJ1tt1shOoGo7GOyjaHMZMCwhyrEAoDl
	qQVCbThldro54gGDtiPlgMkALoKo9vaO7ce5sPLi5KUx0xIaW5eHbo0fYqt4aRORs0mFNQ
	eY3j8QvXpGnnJwg4Yke6a6MeKmT+IxI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=b+rYNlSv;
	spf=pass (imf25.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id A688020B7001;
	Thu,  2 Apr 2026 09:37:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A688020B7001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1775147838;
	bh=6ImdGXD+GMNXPRP0/gybrarmqeg2HPXNHpY8bxE1bfA=;
	h=Subject:From:To:Cc:Date:From;
	b=b+rYNlSvmtc44YdS1xzUoiKH6C4NekpLAjRZKVtjcWMkIGVXuXmhSGhzWRT/vE1RP
	 6nuYfPlgNiFunODVhmkcRhsMtb6aDgIIF/i/D9LaOpujTfPyzDTXYUwtUts2ebzO3j
	 hFNAb/HQho2Sr69TzQzviXCJNjzjOLVQbbjG0c/M=
Subject: [RFC PATCH] mm/hmm: Add userfaultfd support to fault handling
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Apr 2026 16:37:18 +0000
Message-ID: 
 <177514781712.83496.13387671641142309152.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F23B6A0019
X-Stat-Signature: crd71jt7x4gcnbxxjaxgfse7pckm6du7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775147839-689080
X-HE-Meta: U2FsdGVkX1/qMRiQI0r7epWB9k+2xsv2AQGcHr0O6hzRvg3tsyez17PJdH6cFPqHxs7CwZcrMKSqoSHnpGVxqTrNDz7YR8aWhAq695GYoIeGY5FxACf5fnocek8V5Vu9nLxoenisxW7EOOK93QVwnD7xGD4wnnnVGCr1y2gpc11p3SsfvnMJEpDFde3gner6KBxeWwV65KeGJSb96xN6/FhDY2ij+HTMwIorg0IrfaIy7+wpucHybSdNMQg5GnKviG50jtK39xqsBcR20bl/mXwomME2CrbH8ngPIpo22IOO0VcxmAqkf6Ec5WKPKbNschjiiT7OInPI86D9UYtghnWhlZGNbMcZ6tKozCkQD82pzYtvdJFhWP5zEkgNhs9OA0ymtrjaO/uTzOxzyuxWXFSoA+TXHn6zlSVzEgs0vD24ZBqVBjUwCMHDFbFk86gqH3WgKq/3RND43XSuNijO0Mjrhs6Y+36pXGANim0ueGxsIEodhYIcviG18EAYvJFEq3/tpEx+ylHXPAyKPodVp8KmURKwOJVcuvGCDaaLkGEzCYQvHH+DuF7XuJ/ONtl44xRPdPyV0xrS4NU2uU7xUHnJubmnGcPrGt42X0PiMKAoOwenBpm8W9/uWnMMqUQHjrBOjvMbk5jl0b0MKAAl2nxQ/3+MoEFimQfktNS7WhsiVy0f2ie6c5j6YKs6iMaI+43fHWjVV97AFPPP5kivabyKb77vhbzTDUz/4qjJLL9hSSd5irbNHgR9VdtQsW9rPE3Ryh26uUfpXWUlIhYpfXzRxR+So0AigfO7n5p1zdglZzcE/jGPEkiJv1DKBzsqHUZaoMfi8tCV6Scb/iLdjt1ieRugFAJpNOOWDcvF+eX3T36j9juDp1WfDDZSOfD2WTmcCSkbZDxYC97BQtiw64dYp21a1z0nReBaCYblyHvLRKh+jEgoKw9PANss4oEuJKGEUEGkYy+Ec0lyFC+
 2xGJWRlH
 O7g3kD3A/cUGKHkhPqGu4trCjPSFY5SWvNwxNoKjKTYxg4IgTW+hueRlCDZooqfacU2WVPvaS/oZ70R3NjHtGWHkpHwncPMrnjJaFwutElT9pHrIydIA/MCGIgHixOrAM6gFzRQ8LZN3mEDuZe/gRhh0nAi8hfYQFmTNi+8lD/auiev7T5JaralXKwSKEjP2kQSMHzBbE57/MmtV6mLobgwnnSvUafsRqtUwMgYwE9v2254rRk1ybK6U2hF6mwH/EWaoa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for userfaultfd-enabled VMAs to the HMM framework.

Extract fault handling logic into hmm_handle_mm_fault() to handle both
regular and userfaultfd-backed mappings. The implementation follows
fixup_user_fault() for handling VM_FAULT_RETRY and VM_FAULT_COMPLETED, with
a key difference: instead of retrying or moving forward respectively,
return -EBUSY after reacquiring mmap_read_lock. Since the lock was
released, the VMA could have changed, so defer retry logic to the caller.

This approach is inefficient for userfaultfd-backed VMAs, as HMM can only
populate one page at a time, but keeps the framework simple by avoiding
complex retry logic within HMM itself.

v2: Addressed sashiko review comments

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
---
 mm/hmm.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index f6c4ddff4bd6..284032c4b2c8 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -59,6 +59,53 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 	return 0;
 }
 
+static int hmm_handle_mm_fault(struct vm_area_struct *vma,
+			       unsigned long addr,
+			       unsigned int fault_flags)
+{
+	int ret;
+
+	if (userfaultfd_armed(vma)) {
+		struct mm_struct *mm = vma->vm_mm;
+
+		/*
+		 * handle_mm_fault() with FAULT_FLAG_ALLOW_RETRY will
+		 * release the mmap lock via mmap_read_unlock() on
+		 * VM_FAULT_RETRY or VM_FAULT_COMPLETED.
+		 * If the caller holds the lock in write mode, the
+		 * mmap_read_unlock() call would corrupt the rwsem state.
+		 * Assert that we only hold a read lock here.
+		 */
+		lockdep_assert_held_read(&mm->mmap_lock);
+
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY |
+			       FAULT_FLAG_USER |
+			       FAULT_FLAG_KILLABLE;
+
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+
+		if (ret & VM_FAULT_COMPLETED) {
+			mmap_read_lock(mm);
+			return -EBUSY;
+		}
+
+		if (ret & VM_FAULT_RETRY) {
+			mmap_read_lock(mm);
+			if (fatal_signal_pending(current))
+				return -EINTR;
+			return -EBUSY;
+		}
+
+		if (ret & VM_FAULT_ERROR)
+			return vm_fault_to_errno(ret, 0);
+	} else {
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+		if (ret & VM_FAULT_ERROR)
+			return vm_fault_to_errno(ret, 0);
+	}
+	return 0;
+}
+
 /*
  * hmm_vma_fault() - fault in a range lacking valid pmd or pte(s)
  * @addr: range virtual start address (inclusive)
@@ -86,10 +133,13 @@ static int hmm_vma_fault(unsigned long addr, unsigned long end,
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
 
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
-			return -EFAULT;
+	for (; addr < end; addr += PAGE_SIZE) {
+		int ret;
+
+		ret = hmm_handle_mm_fault(vma, addr, fault_flags);
+		if (ret)
+			return ret;
+	}
 	return -EBUSY;
 }
 



