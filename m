Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF4ECD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC87E6B0095; Mon, 25 May 2026 10:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FA06B0096; Mon, 25 May 2026 10:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC966B0098; Mon, 25 May 2026 10:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D04FB6B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:58:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EB3E1A015F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:58:03 +0000 (UTC)
X-FDA: 84806247246.19.309E6A4
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id EDE19C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:58:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dhw9rzwZ;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fl57Ady6J/3/I/Lz0zKZ4/vMXEK3F3tyaeoZhQFZ73M=;
	b=CkiWTxcElVvQnFm0Rizk/D9qqqYIwCdZjyTvz8c7KDsNy533LOSxh/DhMAYpDJX/gf07av
	iuImWoCbEZO1qPGzC2kxECPJLaufDMHGYb6bzUFkDT4NJ47Z5Pf7mmnmCGlrCZP7jkQr3A
	CzFRPaS8SfyoPU03n4zx9cB9uc+6ZD4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dhw9rzwZ;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721082; a=rsa-sha256;
	cv=none;
	b=6H4nrCESEnmv/TRCNzS/pyKtmPTua2eJQAfMSZr2CiujHK7mYWeZbsDpH9haZJcyp6duXA
	DlUVBDxxDcxsc0HUVOcdwHleKRZALLa1ETtZs/zbJ6oYQBnWd/Eibh+qevEz1+DAY+vCpy
	wOAqyMpImhG7Bf8OjJtJ1GxUoBE+zhM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779721078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fl57Ady6J/3/I/Lz0zKZ4/vMXEK3F3tyaeoZhQFZ73M=;
	b=Dhw9rzwZEUbDdhxSLI5HfhEQ/j1sgVyG1jehGc9eIYhUwabxAyasFX0LpXESkHtuEmJe65
	NYtTfr+kbM8Lp9muiWBelV0+xWGNcp5kIc9TO3LLIRSo1KD2cKM4zd78k8Ce3QfLSaNtvs
	sDyFye7xTf/wJlMhJ1KHFIWnkEZLdaw=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	david@kernel.org
Cc: hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] mm: make mmap_miss accounting symmetric for VM_SEQ_READ
Date: Mon, 25 May 2026 07:57:51 -0700
Message-ID: <20260525145751.2671248-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ch4hp7i4o8ykyyjjbr8cfnmw57nbtqd9
X-Rspamd-Queue-Id: EDE19C0007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779721081-763470
X-HE-Meta: U2FsdGVkX190FZloi1etF7f84X9ciK4ESUGialcQRMpxR94OE/p9dEMBr9XeWgBgV3bKctYdmUwSI76J6jB3Eb4u9CtE9BqCEhQcdcDb/a2xTIBo0KAxbWDYZB1zApdfiHzlZtZoBUdq/rPdtJ2lFsCJTXVyC/qS0h/5AY/h+cFsNJQPyoIZyFab10s4QgTGukL+gv1LMPV9SRXzKZNSalHLc0M27QeFwpZDZDTuZwGUXFglk2QyNXHQ15KWiG60vFbadk5VLIvQdR5oqbrNisNZfDp3UEx8zaQktU0Lpzn6XoBofLLEWUadF3nGBgl+epMjx+WVLAhMcOJVxTAlaAvNuIYp1TeS44RuUTNBuhE0Ne9agqIu3cUyV+LtL0aFWlA+BXa76qWfM7XAKi5flLO0N9g3y2t4Qu+MZ+JixDN9mdwMpvoXg3zf2UZ1b1Jl0kdlEK7bJN5hVkej2yucDJHAN9Pmp7ZtiIe6aCS94swwT4HRnCwNMiVcERKTLCEI1qJRq4SyBjp95FPq5/tqGSM/moLs/b2+9+SfbcKv5clp9ef5zbMUSS4EgbAmi5M5538kKjsV2qFL3mmk96k2h3E9FEvFtdJyZlHtj6bhPGiCrGcNS3HQ+1rQevDMtEU65Lpp78p2Pkbc8i45BDRAonJ6qcwda0SAauXrs7SFLKERhxqRe5v3s5SEIXg2cY8Pp7l1/0SchDk2u0eRofEJBdpZESURq3EogiIn6iPoKLWnRQAB+8f0XK7va2Jfg4GSjQfVhMDPiubH/x1UwMUqZniUhStG//jtKrT+k7Ya7TfbzdX4e0h0aobV02/kC+nh9S62ZLMhPOS6KndVX0dVCACvzdDDmSm9P98rAHDxBE4iYjWMATfeD6R85Z0Ne+xxfBOeYPbkUAnIQOWfTwqVfar0xn9U1EEP1YK92S/U9WG5p1KIePXIboq1UwQY+IvGVgRaZS+gibbIPtbWTA6
 9RinU2aI
 0+jv+rIkw/a3YEZ9SpE/daYA1uauuW2TBGsvLq1dC0XFIcAl1kzFgoiF3eNNyvnW4kIc/OXIS0wTspHQ78Qedg8UkmRznuo5R9CetwZwOoCf+nH5iySiOkADoAQgJjqaXgpBh1y1muPlWrSzh8Bvx8f3Dn4CGI2oT4H58CwpTOkR5qnz0rRKPN7HLHOf1WIyNVK89ffiYOIa1denbl46E+eAOO+gtfK4U3lrC2IPa/q8N+laAJ9PQz38h8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_sync_mmap_readahead() skips both the mmap_miss increment and the
MMAP_LOTSAMISS check for VM_SEQ_READ mappings, since sequential access
is non-speculative and should always read ahead. The two decrement
sites in do_async_mmap_readahead() and filemap_map_pages() do not
mirror this skip, so concurrent faults on a VM_SEQ_READ mapping can
still drive ra->mmap_miss down to zero through the decrement paths
even though nothing in the sync path ever increments it. The counter
itself is per-file (file->f_ra.mmap_miss), so it can be moved by any
VMA mapping the file, not just the one currently faulting.

Skip the decrement for VM_SEQ_READ in both decrement sites so the
counter only moves for mappings that also participate in the
increment side. No functional change for VM_SEQ_READ users, since the
increment-side gate already prevents the counter from being consulted
on their behalf, but it stops a VM_SEQ_READ mapping from biasing the
counter for other mappings of the same file.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/filemap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5aaba0d3e81d..cca20e350c95 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3433,8 +3433,13 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
 	 * times for a single folio and break the balance with mmap_miss
 	 * increase in do_sync_mmap_readahead().
+	 *
+	 * VM_SEQ_READ mappings skip the mmap_miss increment in
+	 * do_sync_mmap_readahead(), so skip the decrement here as well to
+	 * keep the counter symmetric.
 	 */
-	if (likely(!folio_test_locked(folio))) {
+	if (likely(!folio_test_locked(folio)) &&
+	    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3935,10 +3940,15 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		 * In such situation, read-ahead is only a waste of IO.
 		 * Don't decrease mmap_miss in this scenario to make sure
 		 * we can stop read-ahead.
+		 *
+		 * VM_SEQ_READ mappings skip the mmap_miss increment in
+		 * do_sync_mmap_readahead(), so skip the decrement here as
+		 * well to keep the counter symmetric.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
-		    !folio_test_workingset(folio)) {
+		    !folio_test_workingset(folio) &&
+		    !(vma->vm_flags & VM_SEQ_READ)) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
-- 
2.52.0


