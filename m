Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C16606D824
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nt6X1uQl
Received: by kanga.kvack.org (Postfix)
	id D730E6B05CE; Mon,  9 Nov 2026 07:32:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88286B05CF; Mon,  9 Nov 2026 07:32:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D666B05D0; Mon,  9 Nov 2026 07:32:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9737E6B05CE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:32:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38E5E1C3FDF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:39 +0000 (UTC)
X-FDA: 85415519238.10.59C6BAC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 138991C0008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nt6X1uQl;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMMjg5Tb5QutiWvyksGb2lNhCLSGiUBKibO1R6YfCBU=;
	b=MgYEC6Bi/mhI/PKoizjbP37i944vXrtOzKkLP0kse1o+X5LNRWMLiBslbnuR/eOgutvJf1
	fVWCx9dXzIsU+0hppokySq01ehip0BIHeTxhjo5ItsoVVXylcfTy3RI7ztEWfoYBsm56pF
	AuzRsZYyLaHwxmwZ8SWSSElsBoENek8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227557;
	b=g9xo+csQjLkLpzIk80Z0ixSKYnrLJ7mhMO8hboshgCzTkz9TqbDKQlURNI4+lTgo6iUGEY
	icPo7jbFfQB1DHkZ4LSG+hVRJpmj/bB2jRSNATyfOXDFOdpo0Rdmpe4bfbHSv3kGtZfKzc
	yTwJw1Ei/7psbLm3fUCIf3NX9ip9k3o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nt6X1uQl;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29CA91576;
	Mon,  9 Nov 2026 04:32:33 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D8ED3F632;
	Mon,  9 Nov 2026 04:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794227556; bh=wo2RMPDExcAkwy96P2D0uHY6dqGY6uIQRPmpWz0sV0c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nt6X1uQlJNrlFb1A1X8e0d4wOQNnPCq9YA08w2E8SDR3QXzGBDnoBba1cpTgsjmyz
	 npjSQLJXsnVyqkY5JQw87sMGb+MSa417Ja7lIYVXl/x+cZBHYEfNMYF8U+u1k7GJ7y
	 DQjAjCEg2EqIi9cYEJpv0jaLkxj2YnukULBTlWEs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 09 Nov 2026 12:32:25 +0000
Subject: [PATCH v3 1/6] mm: khugepaged: ignore MADV_HUGEPAGE for shadow
 stacks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-refactor_gup_fast-v3-1-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
In-Reply-To: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2250; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=wo2RMPDExcAkwy96P2D0uHY6dqGY6uIQRPmpWz0sV0c=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq8b1c1s12W6hVfBJ0af2H4ECDILxl5SXY0xgRk
 dMWbEcjOCqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavG9XAAKCRBt1cPRWsUx
 M5cCC/4whLG62aLd5wDKkGxX45q5wDXTgLQzStSXiohOrwsj5ie+SOSiXuQ49zjifts5Jsb1vzu
 GopB+twzLQxnHHdLg0EcWA3qQeihfZ2jgZ008vAaetQavRt7ElV+hQnaL4b3IU+k5QR2oJJdyaU
 mOvmBwHaB71miYhWLHW/SjFSg4Q1lgMeIct4w6rcuDQfvJJZ4PlTi1Cf4kBEGpef8OoWD7yJf7w
 Oxt+p43GHsCgXiNlY5fyLElkAKbpyeNy6mJUoCMyc4aM1tWdN5p5SOXbhmO+pylxqG6YV5q0hvv
 gkjGORrbcj39v+ipCRtL7+64ljESlq1uVcYAKNLwa5sgOnuc4m6vzOlzC/nbhaCL/LRQYU95DOh
 Gds4xFEgQKNo1QxIGou8OkWn6vNlsV0AHd4rzYfx+KAGEQlvJbnZ5W5B1r7tYdnzu6B3PEnr6F7
 aUaMwK74VC6idueVz2sP02KRWkGKL4SZNlSCXzVBHow6e/x+68N0WCDksj4n5IG51mgPw=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: ffa3aibmderg35g6xd6rwt9q9eqqk7ax
X-Rspamd-Queue-Id: 138991C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794227556-235870
X-HE-Meta: U2FsdGVkX1+iRVN6/zj/R+brCSMlw9adGXfRDBadHHlp17Mi780xS/kyHVpJoBkHKkSSsISJfLwGkGtOMHvYdYYj/DyaMQAZ1uuzX4/518/HwwfURbg5Y9HWIT1fc5dGMhd2IFCtN6vTrAo7G5dmHubCspSvajTy9OW4Ig36uVJoz1j9VzxsJ244dwvmxVOXqW2HecTU6tfqrFlBjpmGom1KWk/hr/4kpghKZGI+ltZlKonh+zNOPLyfq0q5mx9Q/Z+nSNAXGoZzWmFfEosedi+g8aeGYY3DRIlheSXDd/9QNGf2PT8UOR+xaKqGVYxemmfMjy2fiS/eXvugV72mwepTniRWEfismud2j1+A+h0Lp6PIIs0LzgegDNp1MDLFiYrf7ANnDgAbL6eN+Z+5Dyus9VN3VG3esib1MYlvvbVxl127brFXks3gbwb0FCGogSXUia4gF3Rx+2B2+EOLhD1+EnSLYYugYfUUBHjZ7zVUGqdSWqc7U1x3Eh8CMF2HNBl8nsotpCiQVMhjCJIYO/V4E+2MJzOOXaE6NOt5Dp5oKCBDTv3m0ZcYCG+hRy44b/MNPINGE2td5LpOXDrxMSSHWc2UKOox/ye3Es0njdbg777YamU/jiUuuDmEZWxEt7nuPLE6GMVL6snS6oF1PqNUyck90YU4H9sGAzFa+PN+5sA0sGu21iF5S9UZkzELC0xDdy2u9j3iGjYVx5cgahIuLgFgKmXD9YG8eIJiL9TUHd+xU6KD1UW1vbViJ1AxgVinrbzqkSf5XwqL0aeah+huLrkIIxTog4DMc0y2DyIiKcdV3USAR+CYc6kPhJxT4Twx2E97zn5O4tJwMFHEbMo/N5MPwtjhvmAbpnMJiYX8bmVEvPbudXZdTuB+FeKUZ41w8uFHKc1q8r+BzYG5ACbbEFtdqWYw+4GM+1zYGgCoWFf5cjlzmDdPL7WtllPuXkhOduI1NSJQv4iPOai
 LM5kGZcW
 3clg5L2uU2RcU4N5OglftyPXcny6GjJbP2w35hwb2YNKyHJE7qhMt4ed9Y5wKkfKVp+4agZTMcg5JA0WqWB/NBU9Qt3Rk2oApZf5YCFYZwqonQWfnUYurDOTOl3b/UMlPUvi+nJP8bEdae4V808VvlIsWppJKThFdZTAZ9xRWNX0YAqOMHpoykZ6EMiK/oCd9zJgYC7D9Hwhcq8Ld1c4GSls4iqF4nRs8lP12+7DfHcHUQHoeDuXhZtDf+t0V8tRGfd8Cr3IIabnBuLUbqAgVMDKLP4/BD2WmsAY0pmzYTxqBsgSpszznWbCqzm6LAVolnbKFFNhOx3mDJ2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

commit 3efb9800557b ("mm: do not map the shadow stack as THP") makes
shadow stack mappings default to VM_NOHUGEPAGE. However, userspace can
still clear this flag and set VM_HUGEPAGE through madvise().

Allowing large folios in x86 shadow stacks exposes a limitation in
folio_pte_batch_flags(). For example:

  1. create a shadow stack mapping.
  2. apply MADV_HUGEPAGE and populate the mapping with a PTE-mapped
     large folio.
  3. apply MADV_DONTFORK to the first base page of that folio.
  4. call fork().

In the parent, the first page remains writable and anonymous-exclusive,
while the remaining pages shared with the child become write-protected
and lose PageAnonExclusive(). These pages can still belong to the same
large folio.

On x86, writable shadow-stack PTEs have _PAGE_RW clear and _PAGE_DIRTY
set. Write-protected PTEs have both bits clear, with the dirty state
preserved in _PAGE_SAVED_DIRTY.

When FPB_RESPECT_WRITE is set without FPB_RESPECT_DIRTY,
folio_pte_batch_flags() normalizes PTEs using pte_mkclean(), which clears
both dirty bits. This loses the distinction between writable
shadow-stack PTEs and write-protected PTEs, allowing them to be grouped
into the same batch. GUP-fast can encounter such a batch when walking
across the VMA boundary created by MADV_DONTFORK.

Since there is no practical use-case shadow stack with large folio,
ignore MADV_HUGEPAGE for shadow stack mappings, preserving their
VM_NOHUGEPAGE setting and preventing large-folio allocation.

Fixes: 3efb9800557b ("mm: do not map the shadow stack as THP")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: <stable@vger.kernel.org>
---
 mm/khugepaged.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 40fad28c52f6f..51ec043fa26c3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -367,6 +367,9 @@ int hugepage_madvise(struct vm_area_struct *vma,
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
+		/* PTE batching doesn't work reliably. */
+		if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+			break;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		break;

-- 
2.43.0


