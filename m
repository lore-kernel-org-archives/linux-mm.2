Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 853D6CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7A36B030D; Mon,  1 Jun 2026 06:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F6C6B030F; Mon,  1 Jun 2026 06:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4D66B0310; Mon,  1 Jun 2026 06:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88C916B030D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:22:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51B9A1A05E8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:22:28 +0000 (UTC)
X-FDA: 84830954376.06.0913C6D
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id C09534000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:22:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PvRsohE/";
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780309346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODVkNxNqhWTJOtKAdxjrGaooJs+N26LEMo3Jm83wAZk=;
	b=1pYn7isPq5GhXYKQap7HCAoxj/VHOWgZ/HyAng/NnADSuMbQV6sfZFwtXYUKTB9xpezyFb
	TP9U75EdkaEaKmELwj1WS2FxQR81hUgGBQY24NN+c64Uj/PXl4XnDj3K0duGpVi/+ICRmr
	VCagLWHvoawfGxF/OxujKOyDf29jgBg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PvRsohE/";
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780309346; a=rsa-sha256;
	cv=none;
	b=cAACnLox9Bl/HTHVx+2OHNLRoU0A7qdNw87cI82/s9w+tIKZliEdxbIbOEYaOzSBUbmIQU
	PyFf+nTiRMTC3LbxxmfQofpdbLhZTgj6wh3nahZH5gdXiH7v+vzUDo5olNRjJL+0kNbdD7
	388qoxQBFyJ+sry01ffrpgpvOFiIx98=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780309345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ODVkNxNqhWTJOtKAdxjrGaooJs+N26LEMo3Jm83wAZk=;
	b=PvRsohE/ZO3afbXRx9ClOgEAbzgQczwO49YoCB7UQqiTfEVBmtIxaF8Vwuow2kGr0loz9v
	4wQPHODBVox1noVmxIaEZhk4PUwfCGWuvg+Uu3skr76sAsSqd72Z2jFbLzJ5KIADisNOXt
	uXoCMcINK8Ff2a53qPVmFtSnw/S+72g=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: pfalcato@suse.de,
	r@hev.cc,
	jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam R. Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v7 1/2] mm: bypass mmap_miss heuristic for VM_EXEC readahead
Date: Mon,  1 Jun 2026 03:21:17 -0700
Message-ID: <20260601102205.3985788-2-usama.arif@linux.dev>
In-Reply-To: <20260601102205.3985788-1-usama.arif@linux.dev>
References: <20260601102205.3985788-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C09534000B
X-Stat-Signature: 3s8z38cesbfokp751dgeui96quzkgfet
X-HE-Tag: 1780309346-875795
X-HE-Meta: U2FsdGVkX1++zPH75FuMGqfZPVHi34T4MWGdcGx+Ft/j+HaGnneMXppkyNM0LmUqCixqPiCeHESsqZ9DdB5DxKCqpEGei1w00cNHtz23VwtL91oppTYHM6W6CWTcBzFiol39B1PVNBMPWILtrr/w985sDQ6s/ZyDNaW5NF2B1Mt3Fhd45TlH2bCwxMklhUdmP6I6q6o2pWa8kc+srPE3DpUPelZwDGf2A1uNOZlsrNo43HEg2J8AfqyE7jBgWt0wfCDxOp7eWqfINojJKRNQ+faGmxN6q9HTH2oE6EoGdpc4pyXhek19Acce454UmELjZ/V5jdqFlzdo4BO9qtvBukQFzQ+l2ePTN0Dnke3g+Ei/QS5e8aw/wg2kx3MKOBeY7lzv3aFCaiJUsRJTiUYG+S0026MUkdwuCYQciLqYYP+q4Y7o7q5+M9stY6RAz1rZgqwwcJF06bhW7GM25ZbQ/5YvhJsnGJmfUSyjy71GBVwPWg11PzMRyagr5QZWZK1kjVwsiuDQejGR1579hqy8eWL3fCBtmaL22jWOhSyu3t9iymKUXhneIxoJ9Gd4tlqc2wmJNlBff1QhU80d03UjEYRJQ7KZme/lp6ceEU3udtJsCskwmqim4T+lfoUAIVh71/t5VtsEnTCBP4zscfcunTpbSY7G9RlT+MchKI0tt7HEZzdb1+IZIxMwELWcqKfyS5VYpmMu8+PTDZPEuv0zOvRkH4Gj0FjlfwUEnxKqigqiK7a5XwLboRbZ9YJiU2uRMTgts2i117CW69WKk/ih+jsuY15w3rZ0jIoWpyp85hECt7Gi0ngX/HPaZENbLIHUUJ+39YgFQmiVOwik4RELK6j94OVDc3XbA+6aX06cefe1K+tOa3iImvyg+lbTwlDgrEommi4nf1qajwt8zgkFvZQQ6D9F4+L0pnk4RPaEQe4GlRl2JcnVHGyQtxXK78aYMTUXHmq58XcaG8Nis7X
 pSrgPIKU
 UWjc3DRBlVBC+uBeoelSeMKpLMYllfyxFsbXatspEvbZAU6cA8U/IwKTYtbSKLaZLVd+bqmmgRl/Cg3MKzP9RAucrPd/TW40bwb6FTdXMLk6//JGD30I3eFSY4OdKIONmDGcXFwj/PvyJN8SWRi/1tt4uD1jUH6Epb2KLbR2BYi7Y5AIUusMTMN6kHOwmRC9w96bRGm9h7dX5UK7SfvB1OVs9mJAuiSAX3piXf/ESYYijEKDlSSBmpXXr1Dr4ApyiH7uX4dQdFLDfMXk/CF1Taf7fOYrK/EnqVq2pDszum7DZmuZbJvmI+0eM3P7xSmIQ/a9sAwGkCtpNXCJAxvFJlLC+Fp8ZyEfT22/7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap_miss heuristic is intended to stop speculative mmap readahead
when a file looks like a random-access workload. That does not fit the
VM_EXEC path very well.

VM_EXEC readahead is already constrained differently from ordinary mmap
read-around: it is bounded by the VMA, uses exec_folio_order() to choose
an order useful for executable mappings, and sets async_size to 0 so it
does not create follow-on readahead. When VM_HUGEPAGE is also present,
the larger readahead is an explicit userspace opt-in.

The mmap_miss counter is decremented from cache-hit paths in
do_async_mmap_readahead() and filemap_map_pages(). Those paths are not
always enough to balance the synchronous miss increments for executable
mappings. In particular, when fault-around is effectively disabled, such
as configurations where fault_around_pages is 1, filemap_map_pages() is
not reached from the fault path. The counter can then become a stale
throttle for VM_EXEC mappings and suppress the readahead behavior that
the executable-specific path is trying to provide.

Skip both mmap_miss increments and decrements for VM_EXEC mappings,
matching the existing VM_SEQ_READ treatment and keeping the counter
accounting symmetric.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index cca20e350c95..a16b33e0fc71 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3339,7 +3339,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		}
 	}
 
-	if (!(vm_flags & VM_SEQ_READ)) {
+	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
@@ -3434,12 +3434,12 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	 * times for a single folio and break the balance with mmap_miss
 	 * increase in do_sync_mmap_readahead().
 	 *
-	 * VM_SEQ_READ mappings skip the mmap_miss increment in
+	 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss increment in
 	 * do_sync_mmap_readahead(), so skip the decrement here as well to
 	 * keep the counter symmetric.
 	 */
 	if (likely(!folio_test_locked(folio)) &&
-	    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
+	    !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3941,14 +3941,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		 * Don't decrease mmap_miss in this scenario to make sure
 		 * we can stop read-ahead.
 		 *
-		 * VM_SEQ_READ mappings skip the mmap_miss increment in
-		 * do_sync_mmap_readahead(), so skip the decrement here as
-		 * well to keep the counter symmetric.
+		 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss
+		 * increment in do_sync_mmap_readahead(), so skip the
+		 * decrement here as well to keep the counter symmetric.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio) &&
-		    !(vma->vm_flags & VM_SEQ_READ)) {
+		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
-- 
2.52.0


