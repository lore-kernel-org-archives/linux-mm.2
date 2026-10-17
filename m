Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F15CCF2C7
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 23:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9966B0088; Sat, 17 Oct 2026 19:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90A76B008A; Sat, 17 Oct 2026 19:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6616B008C; Sat, 17 Oct 2026 19:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1A636B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:35:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F2A8A03BF
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:35:37 +0000 (UTC)
X-FDA: 85333727514.05.5196F72
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf08.hostedemail.com (Postfix) with ESMTP id A7052160002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:35:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792280135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=zKL5iMZAAsqjmjsRtzrlAfIvZSVlleicrZ7dYrErAqA=;
	b=m18tB4o4YpqyvbCZyI4KATnlwRTtt8qQTVHSVzADFOIjh+8uK2uvNiN6x0/2tnurtBgDcS
	RitvVunVSomkXqBbt6pntAu5t+Ff6t8y5wRwvTIblfiQ48c+PX/O6hKEbpZlITMmzeXGjA
	/yDAaHI/+KNG1JtnLtzFSFjgx5s5E64=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792280135;
	b=ofPMYVrn4yWhNMPoVkAyNPkqLBvAMt1MYjSy9iwGEe3LztGWVUbx+hjz/UyIB3uznjzi1J
	19YjjIw6OHzOBjnkjVMNDp2NIa91lYhCFYQQKNl58THHbp+saJyWHHtEwNmGthO8uv1n8j
	eVOfeNnNHK8veKZISAxdSHHRpGGKq8c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xIDvz-003oqe-5T;
	Sat, 17 Oct 2026 19:35:27 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] mm/mremap: do not charge a shrinking move twice
Date: Sat, 17 Oct 2026 19:35:26 -0400
Message-ID: <20261017233527.797191-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A7052160002
X-Stat-Signature: smx3jhac3odgr7jefm8wpyn5i5x31uds
X-Rspamd-Server: rspam05
X-HE-Tag: 1792280135-872533
X-HE-Meta: U2FsdGVkX18xXQaeXCqKOXxpeZlAyvDvbKrh552JQSx0Kx/wJMTzqXnxmtSKPDaOCD+JPggUaGfEx6wh14oGh4ICIvnO6M5Hyt9cfCsFS9+SOP+KS5qtpWfH/MO2vAW1MytlagfveblSS/4IWZDaTB2Mku9NghplYYbrBt4RnqEWDy3NalY/ITFn+bNiUlUOXlGmIgGc4xNuNm92ZUdem7zfeUlDsGXVokUnZaOMREecImXBVBa58avKCQ+OLJ6aj1wvR/n2NasrNbn/U/fBznBrxj9YLVNi/2ZQZ45eXMPMzcrcPubBBjWwvbGHWdc3jegqGobwVnrs4XXs9l+BB7/nCWa09/kxtvqZFOQePEbaauQQ6+/4kudxMUwVrp6nqG4FQF0Xdiu5WdG5blhpON0RgrDWQp2KdNhsATCRDnpu65q/m/rC0hc1knP7CJeZwtq0a/h+9ist+GKrF8G1IBqayoJNr1UBXH2knDla+XBkRke/Ipk3sfmBEpuEdKxqbMW0pILHtRe2cDjkO+I9Y7Xq72yVoEudC+OtfE6qrhqsN0y0uJMG4UrpWOHt73Flbh3EnCImm0o/PWqcuf1Cwd/HZ2aHNaXQ//hod2TPx7RaPP7pP0shYnyLm+SwH1EkE+b+kZa34LaDyNtLXXR3GNILXk9VVzGbEdkO/uQ/xynRGHGKolIwrPvEuoUYOQraZNfmJ3j8uGR9AtNpyEx2tcdhNzWWIjvNNq6sYGWQL0FPQWwWyc92Qbn/cmSPO2+dNEfZrf3JDAIm33Xk/UonBZPQ/c4U0M8SuzLwX0KIy42YVTbF1nqeGDpY77I1VLnnedbdWks/QV2d69FRpHFijOUgXbQKJY/51nifeOi3H/ZIhCvkXF2491ij1P0AHBaaZxXXZlNyz4Z/45WOX5Pzl4Gom0CfFCHxJo/vOfYHOPJrKXW+4tM/h2krpaqz7ucGpUepNA5adJCKaHn4vvB
 jT72XI8a
 F4l3/4BDjcsdO0GewJoI7FI+FbNnuzWrT0+QY1KZikj2UyXINfD5OQFn+TGl/Pba2Hu/6aQX+EO0QLMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since v6.15 every mremap() that shrinks an accounted mapping and moves
it with MREMAP_MAYMOVE | MREMAP_FIXED leaves old_len - new_len bytes
charged to vm_committed_as for good.  An unprivileged process that
repeats such a call keeps raising Committed_AS in /proc/meminfo; with
vm.overcommit_memory=2 it reaches CommitLimit, after which every
accounted allocation in the system (private writable mmap(), brk(),
fork()) fails with ENOMEM until reboot.  A loop of 1000 calls moving a
2 MiB private anonymous mapping to a 1 MiB fixed destination raises
Committed_AS by 1 GiB.

mremap_to() first unmaps the tail of the source with shrink_vma(),
which uncharges it, and then sets old_len to new_len so that the move
looks like a same-size one.  vrm->delta, the absolute difference of the
two lengths computed in do_mremap(), is not updated, and
vrm_calc_charge() charges delta pages for the move.  For a move that
does not unmap the source the charge only has to cover the growth from
old_len to new_len, which here is zero; nothing ever releases the extra
charge.  Before the vma_remap_struct conversion move_vma() charged
new_len - old_len with the updated old_len.

Recompute delta after the shrink.

Tested with the program in the notes under QEMU (x86_64 defconfig):
Committed_AS grows by about 1 GiB per run without this patch and stays
flat with it.

Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Reproducer (any accounted private mapping; watch Committed_AS):
    
    #define _GNU_SOURCE
    #include <stdio.h>
    #include <sys/mman.h>
    
    static long committed_kb(void)
    {
    	char line[128];
    	long kb = -1;
    	FILE *f = fopen("/proc/meminfo", "r");
    
    	while (f && fgets(line, sizeof(line), f))
    		if (sscanf(line, "Committed_AS: %ld kB", &kb) == 1)
    			break;
    	if (f)
    		fclose(f);
    	return kb;
    }
    
    int main(void)
    {
    	const size_t old_len = 2 << 20, new_len = 1 << 20;
    	long before = committed_kb();
    
    	for (int i = 0; i < 1000; i++) {
    		char *src = mmap(NULL, old_len, PROT_READ | PROT_WRITE,
    				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    		char *dst = mmap(NULL, new_len, PROT_NONE,
    				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    
    		if (mremap(src, old_len, new_len, MREMAP_MAYMOVE | MREMAP_FIXED,
    			   dst) != dst)
    			return perror("mremap"), 1;
    		munmap(dst, new_len);
    	}
    	printf("leaked %ld kB\n", committed_kb() - before);
    	return 0;
    }
    
    $ gcc -O2 -o mremap-shrink-charge mremap-shrink-charge.c && ./mremap-shrink-charge
    before: leaked 1024000 kB   (every run; Committed_AS 3744 -> 1027744 -> 2051744 kB)
    after:  leaked 0 kB

 mm/mremap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 444f37d7cd28..2dd41c611fdd 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1523,6 +1523,7 @@ static unsigned long mremap_to(struct vma_remap_struct *vrm)
 
 		/* Set up for the move now shrink has been executed. */
 		vrm->old_len = vrm->new_len;
+		vrm_set_delta(vrm);
 	}
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */

base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
-- 
2.53.0


