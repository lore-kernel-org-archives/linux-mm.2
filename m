Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA722606D805
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=G5UlDFmA
Received: by kanga.kvack.org (Postfix)
	id E497C6B05B7; Mon,  9 Nov 2026 05:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA836B05B8; Mon,  9 Nov 2026 05:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D372F6B05B9; Mon,  9 Nov 2026 05:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B28216B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:34:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D13B81205FE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:34:38 +0000 (UTC)
X-FDA: 85415221836.16.D1C7D10
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3C4E140004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:34:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5UlDFmA;
	spf=pass (imf26.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794220477;
	b=2SnF9E8WCyLPd15p8ZruPYvDjUfjSu4NZ7Ghy+/R4fataRdeZ1KiR5tXtTMOU1C6tz/O7l
	zDjVm1Vm5Lzu0qb8DQmdQuSrLRD0LHj9vqnbAwCPYw1Ez+VXQnxk7yvWYCHm2mWJTwvcQp
	xgiIiFu3MF2JZnxPQByS+dvgdYWOBiI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5UlDFmA;
	spf=pass (imf26.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794220477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtsHU++eHrXo/wih9M9uuk16BRNVVDXZX/+Z/5nwGFY=;
	b=q3nmJmE2E/5gkZuuAotYmYuQmDYaVAG7BID8xjIFvkR60q3Nxfrv6QB5xhQgZH8HziKge+
	2xl/rCM7hPQyR9D4vg7qc3GrGMj1prsLYKBHZWevQTbB+d6akSEquxxhFdyfULuYip0hKc
	e/yp+ghog7F+rB+zlmqSK8CMqgOv3wo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jiy3X41lKoHJ9TTiUEkmvmqa1hNlv04MEvb3bMfslJQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794220475; v=1; x=1794825275;
 b=G5UlDFmAxfB89RIUDbFCCBS1nF+v8gvREXBs2zhxptUYUNc1JSIXCBYnlyl5Ve2epJFTWjkg
 dM19fpY5DLMMlQVRBBK4v+INbT74Y00EEqMk2JPLOO/N2vvQokDB+yIGi84zNC11LYCM/MgDDki
 c4+CssmTN1asQAWEejKKndkQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4358eec4bb05e3ec;
	Mon, 09 Nov 2026 10:34:35 +0000
X-Mizu-Trace-ID: 4358eec4bb05e3ec
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Mon, 09 Nov 2026 05:34:11 -0500
Subject: [PATCH v2 1/3] mm/filemap: move the mmap hit check of
 filemap_map_pages() into helpers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-bug-mm-mmap-readahead-descending-v2-1-abac52890a9c@linux.dev>
References: <20261109-bug-mm-mmap-readahead-descending-v2-0-abac52890a9c@linux.dev>
In-Reply-To: <20261109-bug-mm-mmap-readahead-descending-v2-0-abac52890a9c@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0
X-Stat-Signature: 36y9rquatjbuq4resoa4kzspg8ky7gj9
X-Rspamd-Queue-Id: A3C4E140004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794220476-768260
X-HE-Meta: U2FsdGVkX19od43l9OfKqnrCBJj2vVQ0QdRrVN7LUdMIkLdxRaIzNgVHdXkvopbBIhsT32NMM4lHrq2+aZP9WAu7+XTN5xVq5CFLoQbSyDd3KP3VPdz+90LuFRf6RfISrEjoR+T2Y+0sOp4uqD45Xqppp7BvHzFa7xPDR60YzqLIRyRsowQyezzqzw/2Rjj16tp70oclwEO0mLsm0maAw8GzyEXhCr0pF2tfgHM+zplDjVHar18jdE8cobE8lh7TeZ2RzIKHmpdZHJij2tvxFBTHi7KCmWCMwBeQHdLHp2o9HNHIr2NjJvlnqNg5PCfc5kKmycHR0aySQA0KPGaja4463jlj06cyfY4ClBASjZ8RV7GF3RJce79cXLC50TZIXfvGY2dJAQizFMgVuXXcdbS+HQVacIfaH0Qju1cyjzXXLzZOD/t9IN4HobXx/oGVuIt758thv3kHDG6grF4hZlTVBHs3j3YmkVG8QT0/oR5RvzkfIxfvDtTFMOImuHOXxIuzK9G7y39CVlahRhgoXorW4IOBcgly+MzspejoC0rGZbxo7TOCBdVI0kxLpG/vo/otDGZnJpuVyR6IyxEb34M3rusDSsJBoJGehd/ipxJfw2yJ6ktzFfnnk/3tUU3sKDhrvnpNJ3bgXTxBrG4jPUZkIajCGuFGF0BAe4fl38ftxIdBf9Kp0o16ozkJu4eJx7bdPGJUznCELndHrJrYIFm1uyJU2sLgYS0aIcG1uzNcNVxEsZ9ipOyp8Fp/SetJc50h7Nrw1rmoGqRTdipgwobG9NyL1lpiQLDZ8Xj97E4K+o276aCX3y75/GQwa4LIR6/ZdWSW1COYoDKn8CmYiOVuUn17lQ4mYprf9MnfUt8CDdHRLWXHQ89WlohNZtZE2D5hR5Q9LMnpao9X8X10KBdp0+y9tcXHOPZ1NZgrHCf0FZDHA6wUjz75TF9y6VpHovWLgPw8nd56B37TXTX
 mCl0jVr3
 yT5Dn/yDzc7VGElzXLTx/NczyeOK6EGyCWGpq6b5khLALh2FdhatxfsTE6oSCCpt4KGCLGI3LsxTELM2L3WXZeZWOTFUzQanUe9Ep63J/KuYknw5xbOT7U5xdZnMEUvKHAqYRMmBrIXwRw2VOaemeEgkdM9uQ/69OQrJKa1dsLYQHmdwWxvJxeVQRrPiX122U2HzEejnkilKiwlHS39wL8KGPV+XpaVUr+eYa7ojYAFdTTq43Gmz7RsoaWQo+uCpGLJxxHp7M2MtpEDiPII5WM+05q+fBDncFdA90g90O/KOFir4vI4MeNKFxAIWrk9dPRCVzfnqtRWXwtbYBBYmanYGR3t+6+09IxvC/yj9aqpT1/bY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

filemap_map_pages() lowers mmap_miss for a folio it maps with PTEs at
the faulting address, unless the fault is a retry, the folio was
recently evicted, or the mapping skips the matching mmap_miss increment
in do_sync_mmap_readahead().

The PMD path of filemap_map_pages() returns before that loop, and the
next patch needs the same check there.

Move the check into filemap_mmap_hit() and the decrement into
filemap_count_mmap_hit().

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 mm/filemap.c | 57 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b04be64a5069f..c38f0e4cf6123 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3914,6 +3914,39 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	return ret;
 }
 
+/*
+ * Whether mapping @folio at the faulting address counts as an mmap hit,
+ * which lowers mmap_miss in do_sync_mmap_readahead().
+ */
+static bool filemap_mmap_hit(struct vm_fault *vmf, struct folio *folio)
+{
+	/* Skip the retry of a fault, which maps the folio its miss read */
+	if (vmf->flags & FAULT_FLAG_TRIED)
+		return false;
+	/*
+	 * If there are too many folios that are recently evicted in a file,
+	 * they will probably continue to be evicted. In such situation,
+	 * read-ahead is only a waste of IO. Don't decrease mmap_miss in this
+	 * scenario to make sure we can stop read-ahead.
+	 */
+	if (folio_test_workingset(folio))
+		return false;
+	/*
+	 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss increment in
+	 * do_sync_mmap_readahead(), so skip the decrement as well to keep
+	 * the counter symmetric.
+	 */
+	return !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC));
+}
+
+static void filemap_count_mmap_hit(struct file *file)
+{
+	unsigned short mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
+
+	if (mmap_miss)
+		WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss - 1);
+}
+
 vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 			     pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
@@ -3986,28 +4019,8 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		}
 		ret |= map_ret;
 
-		/*
-		 * If there are too many folios that are recently evicted
-		 * in a file, they will probably continue to be evicted.
-		 * In such situation, read-ahead is only a waste of IO.
-		 * Don't decrease mmap_miss in this scenario to make sure
-		 * we can stop read-ahead.
-		 *
-		 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss
-		 * increment in do_sync_mmap_readahead(), so skip the
-		 * decrement here as well to keep the counter symmetric.
-		 */
-		if ((map_ret & VM_FAULT_NOPAGE) &&
-		    !(vmf->flags & FAULT_FLAG_TRIED) &&
-		    !folio_test_workingset(folio) &&
-		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
-			unsigned short mmap_miss;
-
-			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
-			if (mmap_miss)
-				WRITE_ONCE(file->f_ra.mmap_miss,
-					   mmap_miss - 1);
-		}
+		if ((map_ret & VM_FAULT_NOPAGE) && filemap_mmap_hit(vmf, folio))
+			filemap_count_mmap_hit(file);
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);

-- 
2.43.0


