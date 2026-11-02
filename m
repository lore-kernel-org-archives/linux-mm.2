Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05538606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aKlGuZgd
Received: by kanga.kvack.org (Postfix)
	id 2CE8D6B00EF; Sun,  1 Nov 2026 22:13:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280056B05B2; Sun,  1 Nov 2026 22:13:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197036B05B3; Sun,  1 Nov 2026 22:13:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E79A46B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:13:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6206280AE9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:13:28 +0000 (UTC)
X-FDA: 85388708496.21.3BF5A89
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	by imf09.hostedemail.com (Postfix) with ESMTP id 72B0A140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:13:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aKlGuZgd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793589206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=al/lX1HsGZpqnSf5dEL9WzmdDUFnJTHtJ4tDgI6XiAw=;
	b=DOOktqNvfX8yPw//q38E6FnpP/SrHjUqjAEXTKcSD/WKt+rXFlzJuZWMRzBAHNYT6w2dIt
	UPvtgqkkvk0EkW+jPGLlI4zFyoLadJzfpMM3grFAADs8o+dt+c2UQdqjKdPMOPwbRuvz/5
	pEt/q6P/Pxq3oM0qFCuoGUsF9dtXx6o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aKlGuZgd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793589206;
	b=YYGEvzceunJo3NTXWx334vUHU6SEwCUZMoT0QjxL6GStvPy/LCNU11pfZyDyKwckP/i6g4
	LTOZnXaWDJyaSbz/3UkTTdtBY3hr3JtK2ALqRwv4eqRJXzZsHo+g7lK6bqgcke6NIF73tb
	dbA0+JQidVHdl6jIyTPItiV8SVA4EQE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gI138F4HwUMp7+lGbqtpS276hdQB5c5uMx5zyKs0VvE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793589205; v=1; x=1794194005;
 b=aKlGuZgdM/4/9jd2QnFcTuKCJ200kJgJKdLDk+jg3vFVN2GVyRom+j2ybn1FQkp2GgbR8Gv0
 m2vgepgxf3BUZjBnzMIIpFSNl99BPSO3xfvsWBbrjmefJsPpIcVwYAlalC1H5AHQdqf5ViPdfx1
 vk/qps6DfxpuqHFpv1MPgL6c=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 24d48d207150a1f1;
	Mon, 02 Nov 2026 03:13:25 +0000
X-Mizu-Trace-ID: 24d48d207150a1f1
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/memory: use pmdp_get() for the lockless pmd read in do_fault_around()
Date: Mon,  2 Nov 2026 11:13:08 +0800
Message-ID: <20261102031308.66177-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72B0A140005
X-Stat-Signature: spw7a5e71jqqa9eaza3htcy5gm89mwgt
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793589206-918563
X-HE-Meta: U2FsdGVkX19Pi/Afl1b1MkFRFKYqHXXdTm3Zcuth6HLbC5WhiaZHd+6y6DUQCjvud3cx8eoT60xStcZY2KePxFq9vN4OyEwFRBJYd5p/E4MJiF+87NlmY2JUx+pWBOlOrscJaKanK4Ba5HiSLRQJb+q3s78fOkvv0OtQnNP2+4KMHdAl5RniVNzbOCjIjiTG2LkYFqjyDg+G/YKIvBCCegBhMEIBH/C4AhynmLR0MDQfNLaYDGKeS/rXzWasX0V9bD9JiujydQ65m1YTaS8tdbYTMiTBVLt7ERz1m7UNRjOUBtT4K93a32+IF9BCRfOOsDYWiE/NVtsJUZQHy+gZDoWrw35ngrtyBErRUctG9PToACX9ipQV3yoWMj6d28LKNQEfIDWcXFCaSsegttswQUQBhhhVblRxBTy+7m2VNj7qU0VeGCBoxqMewfPVHTlg33cB5AutRUucZYZsKG0AECJ5c52HZtiMJgQ5xs0J+I3NfHLrYOX6hncbFm9yDL4uIEMOug6/mZ5jdhp6n/ZlEzLt8XFynGPUGkTmKjc4fEUqYlW9Snb+IGRlncIU69pElx3CXGFBbgvSSt+AwbOFf9xd9+Gxt8OdIb7A0v1k9stnudLQ7+wS824NIW/7+xjk1c+uXzOda+9nhO5NmQDrqw36WL68s3sc8iVasZv4aJkk3y7WaxyzVnVjOiyMfg89OWm1kA8IqIQJB5jZoX3KvfuGxmbyO46Bil4xIYpohfho65cPR04sY6DbAERiHNooBmR+J3etw3N2o07XZYCap+zz4hWo2Sp1ljyj31uIAfJrsEENzUti6wz90pV72VU8w5JpdMhURkBbrCt+FSdjra0OBHJJOf6BD47p5Q2bsDKVPRIVEpfdpmm06J/0M/3m/MS1YTudtA2fhsfAZV2ZCe02GiWWJrrNajnCxSDf+usvRuSW2eJ04IliMJeo0hu1gmAimCAEMHOSbtgnGvv
 5TwrhufD
 i/JZikRMJEtnGPphK//pFIm9JvE4ZLWXZV45EzhHKQ68MXsR+hoDDI3D/QrQ0/crjgjlx0kLu5z14RYYOr40ocZia0GvPiRKZ8cSDDzI0QIjPXwdF15JkgjWfxqbNgWcD4XJ+VNbZts/rDqVFMN4w63oKNNPbeyH6LH7A1SuLAnYng3HXDocdf2PvGdVudT74uMUMaxbJywurdVyV1KP4woV2+VtLC+w28ZK/eJOCiHoJu6o2CtnxWqzy/YTYbX1AflSjY3Y9aBeoQS/kfqckNalMIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data-race in do_read_fault / pmd_install; the same code
is in mainline:

  write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
   native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
   pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
   pmd_install+0xe0/0x120 mm/memory.c:444
   finish_fault+0x5bc/0xb00 mm/memory.c:5204
   do_cow_fault mm/memory.c:5432 [inline]
   do_fault+0x5d0/0x6e0 mm/memory.c:5526
   handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
   __mm_populate+0x144/0x270 mm/gup.c:2207
   __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764

  read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
   do_fault_around mm/memory.c:5341 [inline]
   do_read_fault+0x162/0x670 mm/memory.c:5381
   do_fault+0x31a/0x6e0 mm/memory.c:5524
   handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
   faultin_page_range+0x227/0x530 mm/gup.c:2156
   __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479

  value changed: 0x0000000000000000 -> 0x000000001386c067

do_fault_around() reads vmf->pmd without the pmd lock to decide whether
->map_pages() needs a preallocated PTE page, while pmd_install() publishes
the entry with WRITE_ONCE() under the pmd lock.  Both paths above only hold
mmap_lock for read, so they can fault into the same VMA concurrently.

The race is benign.  The pmd is a naturally aligned 8 byte object, the
store is a single WRITE_ONCE() and pmd_none() only tests the low word, so
no torn value is possible.  A stale none pmd only allocates an extra
prealloc_pte, which pmd_install() leaves unused because it rechecks
pmd_none() under the pmd lock, and do_fault() frees it on the error path.
A pmd already seen as populated makes ->map_pages() find no PTE, and
do_read_fault() then falls back to __do_fault() and finish_fault(), which
allocate the page table properly.

Read the entry with pmdp_get() so that the load becomes a READ_ONCE()
pairing with the WRITE_ONCE() in pmd_install().

No functional change intended.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memory.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd63..90afbd124d503 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6017,7 +6017,11 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
 	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
 		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
 
-	if (pmd_none(*vmf->pmd)) {
+	/*
+	 * Lockless hint: pmd_install() may populate this pmd concurrently and
+	 * rechecks it under the pmd lock, so a stale value is harmless.
+	 */
+	if (pmd_none(pmdp_get(vmf->pmd))) {
 		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-- 
2.43.0


