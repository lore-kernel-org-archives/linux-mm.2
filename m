Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B2FC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEB36B008A; Fri,  4 Sep 2026 06:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6186B0092; Fri,  4 Sep 2026 06:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D188C6B008A; Fri,  4 Sep 2026 06:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A78F06B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:10:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 353711A045A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:25 +0000 (UTC)
X-FDA: 85175660010.04.337B527
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by imf03.hostedemail.com (Postfix) with ESMTP id B87C520009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=cQVWWnVi;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf03.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788516623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYE+vq7JoinPXqlPiiLFr6Z7aSo9LWECAdI/awbwABU=;
	b=x3FAAwfv6vTi/T0LpLa9tBVMdswJFjJcDJI6zvW1DJRk/ik9ZPnS1RFO0VLJ940pkYkacd
	JeMklMzztjDMu0ZotsI5QpY6HQMrklIzbieID2e+5Ma/c12LbqxX5J04wxcqrfdg3RWgnD
	MoHHXZz97GQpYWi5K8B7IBSfSXVKHJE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=cQVWWnVi;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf03.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788516623;
	b=d5IDI5nGAivQZ3wJFH0jYkBECK30gFD1gjjzAjVT0APrfX+t3KRYy3HjHOBk2lbCOG4+Aj
	hjuw2ip0aJCLT2jQ8Ctbww8xUK3ha/o2NRE50iftYtxis7ipaPima0zQb4hSXLUwCpN9wA
	+VkkIIiMyHWLtrNKTY5BUnPUnojwuZs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788516574;
	bh=oYE+vq7JoinPXqlPiiLFr6Z7aSo9LWECAdI/awbwABU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=cQVWWnViZ2DuikCfgtFBwbwrErF1bepZdgdLzut85NMmCs7yd0Pcszzs/38HYU1HV
	 hQJ8qj54khx2k8Z7XLTHxMOvVEbGpFQTvpW3RuSCx7KfbarqH2w6rUyexh/GSWtogd
	 tFkcdcWw8iUXSREtagWvcUI1Sz4rSUe8Vopz+hAM=
X-QQ-mid: zesmtpgz4t1788516571t8b9c63d0
X-QQ-Originating-IP: cuuYc32YtZREKSHjW7EbuP6Q2GYO8WdR0JvfjfVTmqo=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 04 Sep 2026 18:09:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14653282178175958479
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: Mike Kaplinskiy <mike@recall.ai>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [RFC PATCH v1] mm/madvise: prefetch private file COW swap entries
Date: Fri,  4 Sep 2026 18:09:19 +0800
Message-ID: <D758D1DD4372AF8E+20260904100919.2139680-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CABeknB82T0d3VUjz6Xwcdfa8spHvNzO6tZNTMwjJgF00EwrWWA@mail.gmail.com>
References: <CABeknB82T0d3VUjz6Xwcdfa8spHvNzO6tZNTMwjJgF00EwrWWA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: OS03Bzyx9zEDU1sgPBctWmK9/4gN2flMQSQpp+W+wILlj/CZhZPK3D5e
	9Rdx6g2TL4GmNm1lzB6Sto5qRMIMOLoYa3LofatSOkVRodroXzznQq9iDPW8qSwJta1uGAO
	fiIIe971dHbsAPDdjsO1Zmduc2EnsamFJJmv+0G3cgi9YR4u5J8txC1d2kSYt31OQU3VhTu
	Kl+Q5J75bziHnM9ihqaH2stgJZ3LqunHAuBkYh6foakI0wWLTVlbmFlInfVTNU7w/redNUh
	YZcUKAakkp6DaVihraauFUshujSgY7FEMdi48Q0Z9akjl12iUpvdPYJ82bpZ+FjmxeXGKCt
	JzCqsevD8W07Dp2rEH8fCWShjzPA3eZrDj957JHDO0suta6lDZrJmGkNWEEJ6JislRaAFWm
	nnPNBZaqpmMvpSY8Sz2GkQMtuas8hVZ7i+ODsLomN1jqUw2wm3xj3gvMDxURftY+Zb5ECNg
	DgRexqqha+6vaYbEtvBAEpRGj4DqZL+d+4buMmSqkcpWkptE3t2aLYdSOV4m8Z8TjWEXyYD
	Dkh00XoFF0HgsHBeu9ilzD99LtL1GBg66O1dbOfBLav44OeQRM7aoxrTKcuHV5UWTSCXlyG
	RCbc+x6Z+D/o+hy3lwJjc3J6xA83CeFQ3vOysQetI1nn5t0JfUZgNvi5hAkE3o4IXjJ8uJu
	7ul+L4s/hSuAJkg4NYU6B+kuTXeCaO8iTg35awQCfsnnUCOOFRmseYA44RUBUNAUX6yKx34
	8Ljgl/65ywpHfzTnP5VKNVRHegBoH6pQirIPjyg6/JocI+7k3FOMdy5RyKdIcRxc15jYh7j
	T8YA6olDDohIbO0qR7+WT7a06nY9z/v8/9Pom8UKRVDHq8APqzRMZ/DurpertlBqRAq+EB7
	YTNfU+Olqd6MeVg6D7hGH2Isl1L2lLBvvNhDdT3eVCCO/Sh9ZjH8QaK6IoL8gmpzUQaepCV
	Itiq1Z7LUKJtte49WvPIdENuQr9gXPxLPOsIKPbclNjYIkx8ayAVVYcXhlA9oH/lqXTpdsk
	pCcGtIl5+zRuMqwMN1O/c89C1ZMp4mRkb6tnfx7zswkMTg+0R0knjU7uBLqeQ=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B87C520009
X-Stat-Signature: kttt1uu98papxmg8h81bz4cxw5bj1erc
X-Rspam-User: 
X-HE-Tag: 1788516621-90769
X-HE-Meta: U2FsdGVkX1+FUVWXprDIPefAskTeJsQYVYIk5mCq6xDOKjKJE7Fee4vb+aQWAmo7vp5YKjXHCehsehiFhRGf3liuEnANTuiq0Z3fZBq866gHPUnLGH/bN5u1Dcb47jfn87a0tobtsbHU2hOnaqGaMoQe5Dx8RAtfuqJ1NkfsgUTU+ToR0wAaaU+ksFMVCutEUtvgWXtR9mbXSsCHsoqwgKdXrsM1/V+zKaFgzSjcaFyoNXmyK4xi19s2DmyFyCl3YdTqKGghWzgUORWv60wzEl4ZUk+3kJoyZTZtdJTE06LYpMh2ohsbmHD5cE4/psA0VXkiuIlCY6yDdEp5d49t6QR6zqe94o/CISJbTyHF75XWVx/wRf4CkXMLif6h7B8Rag4DlFSzXPOJtLHfoZbVH5cUb/xLyNT7vnT3BZf/7qeVYJTVdzVXaAVRlULNq0xiUloVz0XLX9VwLXmTj1OMftPSU9MJRNVGy9i/IEC305VYIa3frWShbcKVQpRXeHhNiDQ+bZ3qAroKy1D1a6mneLszF1g5bf69uOYwHcd28Z6es835zm49oCrorsMd/UsN9WafeoOkSD7QM3EiQcVXcvZHukSeBFO1/gq9fI4Ni5gBmIYOpcHXO3q1lGGL05kl70q6I2QXR6uLqly6smDPC16HTv7QmgC6b7bZf9CiLk8bPSYPtl1AhzAVwhVhY06kpt8+8aIBs9oXMA6/zm9FQUytamspPSltQYrAQvX0VPtTl4mXRt2+dk8ltqDdVEOPfrq/V4X733VtnlhWuy++Eo07CKxtEvQgQpxwPLclo1O1sCXdtwZwlvcopDPK8BxMjbDir9dnF7o5NcWSMIqrs/UZwnUn1azJNbBqsiCm/lpN3x0Z641Wc0/5NLJTPfyqJsU5EEmPqQaWLymQBrYW7w9zhYsNk4/b9RJAh30hpVskkfuK678EGcKidq2vNl5aoZ5P3YQgXOnYA+daCFF
 HuiDXghZ
 GeTcRUtlpdl7+fnDMbqj47U125gk6odtxBgDXLuS58YoRbu7Z2UBqJUh3P7C8by+PSK+9EkWKjrOw7Cu81UZ2mlUEGzgfe9xYXWn2REZX5uk9ijqkLcKepS6nMG99IHX6dIumKeCv4HCNKL1Rkziv2/FRzcZTZFzOmcJT180ihE8FXxpky2tvYpBgb0fbxb88UuJgqFK5TfY5mqtw5J+zCNXQH2Fu5qPWGufg69Pusy3V5ZR6s6KsD5JYIg2TgrMjUNac62Et0Rb0f2wz6QOMF7SkXrIfKtwgk8QkMtqZ5BmI+qFjYMTEzgzPO2dVx5U8iuTrSeaZPJsDEnwiKXVgxnyVwXU0gSKGBQFYPllRJ7GCNzDsvjrGC8n42OHMw4LJ+XZmYP6q2sVRBD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thanks for the report and for offering to let me take a first pass at the
fix.  I reproduced the behaviour and prepared the RFC below.  I would
appreciate feedback from you and the mm maintainers on both the scope and the
locking model before I prepare a non-RFC revision.

MADV_WILLNEED currently uses file readahead whenever a VMA has vm_file.  For
a MAP_PRIVATE file mapping, however, a write fault creates anonymous COW
folios whose swap entries live only in the PTE.  File readahead cannot
prefetch those modified contents, so the pages are still read synchronously
when the application later touches them.

This RFC walks PTEs for private file VMAs that have an anon_vma and schedules
reads for their swap entries before continuing with the existing file or
shmem path.  The anon_vma check avoids an additional walk for private file
mappings that have never taken a COW fault.  The existing shmem XArray path
is retained; private shmem COW PTEs are covered by the same walk.

The change also avoids draining the current CPU's LRU pagevec when the new
PTE walk did not find a folio.  The existing shmem path is otherwise left
unchanged in this RFC.

One detail from testing is worth calling out.  Mike's original reproducer
uses a file under /tmp, and /tmp is tmpfs (shmem) on the test VM.  I initially
tested a version that excluded shmem, but that version did not fix the
original reproducer: after a private shmem write fault, the modified
anonymous COW page has a swap entry only in the PTE, while the original
shmem page's swap entry is tracked in the shmem XArray.  Consequently, the
PTE walk is needed for private shmem COW pages even though
shmem_swapin_range() must remain for pages tracked by the shmem XArray.  The
RFC therefore covers private shmem as well as regular file mappings, while
leaving the existing shmem path in place.

Test setup
----------

I tested on x86-64 with the mm-unstable tree at e3b5239afe1b, using the
following workload:

  * 64 MiB MAP_PRIVATE mapping;
  * write one byte in every page to create private COW folios;
  * MADV_PAGEOUT, followed by approximately 1 GiB of memory pressure;
  * MADV_WILLNEED, then a page-by-page read of the mapping;
  * 2.3 GiB VM RAM and a 2.5 GiB disk-backed swap device.

The reproducer is based on Mike's original program.  I changed the backing
file to a regular XFS file for the first comparison, and added timing and
pswpin counters.  I also ran the same workload with a memfd to exercise the
private-shmem case.  The complete source is not repeated here because it is
already present in the original thread.

Results
-------

For one representative regular-file run, the counters and wall-clock times
were:

                         MADV_WILLNEED       subsequent touch
  ---------------------  -----------------  -----------------
  baseline pswpin        +2,578             +16,718
  RFC v1 pswpin          +17,610            +0
  baseline time          16.5 ms            752 ms
  RFC v1 time            274 ms             55 ms

The exact values vary with swap pressure and asynchronous I/O completion.
Across additional runs, the RFC version prefetched approximately 17,000 to
19,000 pages during MADV_WILLNEED, while the subsequent touch usually
performed no additional swap-in.

The private-shmem test also moved the majority of the COW swap-in into the
MADV_WILLNEED phase, while retaining shmem_swapin_range() for pages tracked
only by the shmem XArray.

For mappings with no swap entries, repeated advice calls showed no measurable
extra cost for private-none or private-clean mappings because of the
anon_vma guard.  A private-COW mapping paid for the additional PTE walk; the
observed extra wall time was roughly 20 us for 64 MiB, 0.1--0.2 ms for
256 MiB, and 0.5--0.6 ms for 1 GiB on this VM.

On an x86-64 VM with a 64 MiB mapping, 2.3 GiB RAM and 2.5 GiB swap, the
unpatched kernel read 2,578 pages during MADV_WILLNEED and 16,718 pages on
the subsequent touch.  This version read 17,610 pages during MADV_WILLNEED
and none on the touch in the corresponding run.  The advice/touch wall time
was 16.5/752 ms before and 274/55 ms after; values vary with swap pressure.
The same test with a memfd (private shmem) also prefetched the COW pages,
while retaining the existing shmem XArray path.

Locking and open questions
--------------------------

The PTE walk keeps the mmap read lock, as the existing anonymous
MADV_WILLNEED path does.  Swap reads for ordinary block devices are normally
submitted asynchronously, but folio allocation, zswap, and synchronous swap
devices can still make this path block.  I have not attempted to collect
addresses, drop mmap_lock, and perform the reads later: doing that safely
would require pinning or revalidating the VMA, PTEs, swap entries, and NUMA
policy after the unlock.

Could the maintainers please advise on the following points?

  1. Is reusing the existing mmap-lock and PTE-walk model acceptable for this
     small fix, or should this wait for a more general swap-in redesign?
  2. Should private shmem COW PTEs be included in this change, or should the
     first version be limited to regular file mappings?
  3. Is the anon_vma guard and conditional LRU drain the right trade-off, or
     would you prefer a smaller change that keeps the existing drain calls?

I have built mm/madvise.o, run git diff --check, and run checkpatch.pl --strict
on this version.  Any review of the implementation, test methodology, or
the proposed scope would be very helpful before I send a v2.

Fixes: 1998cc048901 ("mm: make madvise(MADV_WILLNEED) support swap file prefetch")
Reported-by: Mike Kaplinskiy <mike@recall.ai>
Link: https://lore.kernel.org/linux-mm/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---
 mm/madvise.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 73c2901b9adb..96cbce6c7f8b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -193,10 +193,16 @@ static int madvise_update_vma(vm_flags_t new_flags,
 }
 
 #ifdef CONFIG_SWAP
+struct swapin_walk_ctx {
+	struct vm_area_struct *vma;
+	bool swapped;
+};
+
 static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 		unsigned long end, struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->private;
+	struct swapin_walk_ctx *swc = walk->private;
+	struct vm_area_struct *vma = swc->vma;
 	struct swap_io_ctx ctx = {};
 	pte_t *ptep = NULL;
 	spinlock_t *ptl;
@@ -223,8 +229,10 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 
 		folio = read_swap_cache_async(&ctx, entry, GFP_HIGHUSER_MOVABLE,
 					vma, addr);
-		if (folio)
+		if (folio) {
+			swc->swapped = true;
 			folio_put(folio);
+		}
 	}
 
 	if (ptep)
@@ -297,10 +305,22 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
 	loff_t offset;
 
 #ifdef CONFIG_SWAP
-	if (!file) {
-		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
-		lru_add_drain(); /* Push any new pages onto the LRU now */
-		return 0;
+	bool private_file = file && !(vma->vm_flags & VM_SHARED);
+
+	/*
+	 * A private file mapping can contain anonymous COW pages. Once such
+	 * pages are swapped out, their PTEs contain swap entries even though
+	 * the VMA still has vm_file set. Prefetch those pages as well; file
+	 * readahead can only fetch the original file contents.
+	 */
+	if (!file || (private_file && vma->anon_vma)) {
+		struct swapin_walk_ctx ctx = { .vma = vma };
+
+		walk_page_range_vma(vma, start, end, &swapin_walk_ops, &ctx);
+		if (ctx.swapped)
+			lru_add_drain(); /* Push any new pages onto the LRU now */
+		if (!file)
+			return 0;
 	}
 
 	if (shmem_mapping(file->f_mapping)) {
-- 
2.43.0

