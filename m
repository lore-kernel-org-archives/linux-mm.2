Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD5FCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C127C6B009D; Tue, 13 Oct 2026 11:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9BB6B009E; Tue, 13 Oct 2026 11:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF466B009F; Tue, 13 Oct 2026 11:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA686B009D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:07:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9307440D26
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:07:22 +0000 (UTC)
X-FDA: 85317931524.04.B791A46
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf27.hostedemail.com (Postfix) with ESMTP id E1E0940015
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:07:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=SxW88Jvm;
	spf=pass (imf27.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0DuSW8h3oK0JqSTaiXCXkEcOayaPZ/o6qLNy4sk/1Ks=;
	b=aWTi4TQPErsfRumNnEWNQF5PKTYjqMgfrQXCMWKLiFcdRf7vuP/2ZeLwDvGt6UajqczSRC
	aSKO3H1yCRWCPLMbkz/bFhU6gbmSzG9yjbKZfRG0Crsa91boirAspvSZls82B5xH/SOYKc
	gAey+GSiFKCfQIgYingn7djZNEXahSQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=SxW88Jvm;
	spf=pass (imf27.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904041;
	b=8ELmDji8xIxQBHCLQkrHe579ql1cRZojj1tn5lv/f6+PEgiSVXXs/KXNCQZxYdR40YoYwR
	+PYIgWH2zGCETWzNX/HOjbTNxCx7kAO6Spp98Y6XPd/P19IE2EBpe7XaxPOFTBWTCYeS4h
	9A5BlBVvrNgjByDtdymnQjP6cFMGvkM=
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1791904039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0DuSW8h3oK0JqSTaiXCXkEcOayaPZ/o6qLNy4sk/1Ks=;
	b=SxW88JvmzrUoQ2q8YanoJRrI9cEXCX7r19T0GwiHFrfru/4m3DYS/n2r17oh5C/3SVNKGh
	3NcdhXl2pIWCrkXiQFySUke4DvnTVLsXYGECVrxvwQRyJtc9bdZaB1on1nT7wCPEafZ1jc
	NpqMYyArj9yLeI1AAghx7ioiJQ7li74=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Andreas Larsson <andreas@gaisler.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	stable@vger.kernel.org
Subject: [PATCH v2] fs/proc/task_mmu: fix lost maps entries above 2^63
Date: Tue, 13 Oct 2026 17:07:12 +0200
Message-ID: <20261013150712.1827315-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1E0940015
X-Rspam-User: 
X-Stat-Signature: 1gf3sxp4nucosokaca5s8hyxm76cyxzp
X-HE-Tag: 1791904040-438362
X-HE-Meta: U2FsdGVkX1//n2Px16hHm7gonvmKVHTZdESff/2NaTeENs94VCVH4tQVk8mJ0TbNRmihY+LER8/96BBaUzXRlcvtrlFslApxR1Daj1v5oIsYxY9ocFhz7qm0Gh2FITqgjd4pR0vX5hBCu4FrP74cmUIH9lMe/W1xPUDirJybpy6+THuETStyL/zxIByvtlOA1SzolfwfFgayXsjb4e/fflM4AFlzdY+fsiF4ErVXm+4B0E50hyjUJ2jj25LYMTt341/4FnoLgngCX/iJOGs6Sb+2YFWSh6T9iZmqDxM0GGO/Cs6Mf+DOcojON19CrJaZY1xTBxEWOaj3OWGZkjJkyXozHTWn1+0mkerzq6pIRErqOsF3cYJWXSfsI15FyJV8B4ReXcLcM0gQMGOiFFBX7QUBsBaQLuCh10w9bg4h9y1NFUW0F1VfZGzbqD7hcTMd1mGRJhSIA35B9k8mocB1XHLdBD57Kyx9KKWgLiytZ3xsUXXiftUoOtlWxBjgGfwaueaNF9Unyle6+7+12FFojCjvtzNTG7aHPiHJhwZI+NClpOhUf8564+1s9yqqUPENQw1zMYvnzmQZ6SRscPVNyWM2g+TaCexcRGPVq1n951pKIhHDAKRUWlkUPI8ThlP1B8jEoujb87E82CCoWDPj/cN3GzYyw9jpsIit6B0bs+cULC+cG91Yns3e1nW7Hq/mFCBjZRQ2kjBt6C63MMK3jB+fxVykpb92tPM+h5ynqhR8cgRVhwsIS5EV4lDiNzQQjZcP0iKKwUC+y5HWu7PWGXFs8xiX6s62dRfrHSj6v6VwjYA4d5QMn1AZAZNPgkBJJF4YMc6/MxVVgMuAw/DbG2ZxJ3HkSZ+xKZ2i4qP9dvsqrm2t38g/sSWh/1hncohxycM/DVheW1MSQxm4aCZB9x6/+Ddjv3dklHRJ/68/+E3Gs2f2ZdjyzqHHJliMAG0EF8Wj2+xWhzCEXX/VwSN
 mmat2VpD
 wURwjlh0AZPm6KlFW+fhCyJ/73YbdAvqRsjtbRBcX4l8HAQlxyh9sBtVYUp5nwMt/rzDcJU0k0IOcvLWu+CHBAZWweF+b1HAhqvDq3t6TAJDdvNg5ntpVcF2mo2yFHuAkn0hurHvfNbVS1vF2O5fjkUJHHTinLx3zHrvetY7Uz8QBH3yfMk8gy9zxo1PA+XA0/ats0y4gIIQNlRPzL/YCKYD1SIe8jEodDZRNevha3faMLGe/KKS8Jsq8KbwEB/AVQ4la
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a read of /proc/pid/{maps,smaps,numa_maps} resumes, m_start()
rewinds *ppos to priv->last_pos so that the vma which did not fit into
the previous buffer is shown again. It only does so for last_addr > 0,
meaning to exclude the start of the file and SENTINEL_VMA_GATE, but
last_addr is a signed loff_t holding a vm_end. sparc64 maps shared
libraries, anonymous memory and the stack above 0x8000000000000000, so
the rewind does not happen there and one entry is lost at every read()
boundary.

Reading the maps file of a process with read sizes from 64 to 8192
bytes in steps of 64 loses lines at 126 of the 128 sizes, smaps at 123
and numa_maps at 97, and the proc-maps-race selftest fails 4 of its 6
tests. Python's sys.remote_exec() reads maps with fgets() and fails
intermittently when it misses the libpython data mapping.

Skip the rewind only for 0 and the two sentinels instead, with an
addr_is_sentinel() helper.

Fixes: 5631da56c9a87 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Closes: https://github.com/sparclinux/issues/issues/111
Cc: stable@vger.kernel.org
Signed-off-by: Stian Halseth <stian@itx.no>
---

Notes:
    v2: addr_is_sentinel() covering both sentinels, as the comment says
    (David Hildenbrand). No functional change: m_start() returns early on
    SENTINEL_VMA_END. Re-tested on the T4 (7.2.10): maps and smaps read at
    128 sizes, 200 and 1000 mappings, no lost lines.
    v1: https://lore.kernel.org/all/20261011162019.922436-1-stian@itx.no/
    
    Tested on a SPARC T7-1 (sun4v, 7.3-rc5), a T4-1 (7.2.9) and a Sun Fire
    V240 (sun4u, 7.3-rc5): no lost lines at any read size afterwards, and
    Python's sys.remote_exec() test passes 20/20. On an amd64 KVM guest maps,
    smaps, numa_maps and the proc selftests are unchanged.

 fs/proc/task_mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe21182..9fd6a360919b9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -32,6 +32,11 @@
 #define SENTINEL_VMA_END	-1
 #define SENTINEL_VMA_GATE	-2
 
+static inline bool addr_is_sentinel(loff_t addr)
+{
+	return addr == SENTINEL_VMA_END || addr == SENTINEL_VMA_GATE;
+}
+
 #define SEQ_PUT_DEC(str, val) \
 		seq_put_decimal_ull_width(m, str, (val) << (PAGE_SHIFT-10), 8)
 void task_mem(struct seq_file *m, struct mm_struct *mm)
@@ -339,7 +344,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	 * Reset current position if last_addr was set before
 	 * and it's not a sentinel.
 	 */
-	if (last_addr > 0)
+	if (last_addr && !addr_is_sentinel(last_addr))
 		*ppos = last_addr = priv->last_pos;
 	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
-- 
2.43.0


