Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F204EB28FE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036A06B009F; Fri,  6 Feb 2026 05:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21BE6B00A0; Fri,  6 Feb 2026 05:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EDC6B00A1; Fri,  6 Feb 2026 05:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3B726B009F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:01:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B7931B2E40
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:01:47 +0000 (UTC)
X-FDA: 84413590254.18.D886B63
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id B725A40008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:01:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770372105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jya6ow62cTBWH1Pd9B7ZN3Pk8/aJdGT/6cFGya/aKPg=;
	b=kKmawFam2A7HDgXpfZDHzJfRTtv6JBlIsLOvg5MCtY/UEsTAQOhvhhRQarKWsd+fCneHhq
	Bfl4wmczl4RkMoa67rUkRvJBYdKlpAFrTL1MEssw2iQjOQCn0mzDfzM9JHQmeo1H9DTfX/
	XEnfRq8oZcvjDpfUanpGONUBi7xA0ow=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770372105; a=rsa-sha256;
	cv=none;
	b=KXJpGmv/zsqDWK88JNpRNnPZ9WQ1pRG/3k/4RRlpKCycjkVVTsBwFrGrAxJFHoNcH/iLKE
	0OuuWiX+WN/3Ruvej+kYPxoJpbsUlefqZrjS4OQF5zGD8IUDgzCcuGl4h++6SVBctLRdpI
	VbolaYPbDureQ1X96oZj8G8p/BBaJd4=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4f6qPK4PW4z5B108;
	Fri, 06 Feb 2026 18:01:41 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 616A1TjN026627;
	Fri, 6 Feb 2026 18:01:30 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Feb 2026 18:01:32 +0800 (CST)
X-Zmail-TransId: 2af96985bbfc374-0d6af
X-Mailer: Zmail v1.0
Message-ID: <20260206180132364R_lYZujwOYfhazgKmxArZ@zte.com.cn>
In-Reply-To: <20260206175609696_A7uH3a1F7VmQN-iTzjC3@zte.com.cn>
References: 20260206175609696_A7uH3a1F7VmQN-iTzjC3@zte.com.cn
Date: Fri, 6 Feb 2026 18:01:32 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <david@kernel.org>, <akpm@linux-foundation.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDIvMl0ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZcKgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 616A1TjN026627
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Feb 2026 18:01:41 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6985BC05.001/4f6qPK4PW4z5B108
X-Rspamd-Server: rspam12
X-Stat-Signature: hfhz6ucqjz4eztboz813exw3sneztm1t
X-Rspamd-Queue-Id: B725A40008
X-Rspam-User: 
X-HE-Tag: 1770372104-425149
X-HE-Meta: U2FsdGVkX18Uzp5UlltCps0N9XwCv4CsIhJDLGpbI73Zk6tOXHYjGQbeulyMz3L8p9GuLhdR2YQ2uC1wgwrBpvktCm/QVLcw+TIymNYlGST1kdHUSywUOpqK0eFZyBCl1OqSF1jgX9xJcuQ6Ey/vWzOvuF3LsG8TWLa9uWZ2q8Nkp3OLttkfZHpIucfiZ+Hx8pBOJ/NkBYMAWKt8sE6f/6YmTdzPpnFnCOhPWKZrzkgSTa6W1qT4OvxGU4fKYflnCo9HZL891EGKQ0Duu7i4U7pT/0vcbB2iTXhVG43a/lzpCR3iGGxQTfPjGspIfkp14h0cwpav5Chg2Eu7nLGTQ+wo7pk8k+yiKTCv5zt9ku90s89asCc9//4aZ8NEfsPfnM0qrjl/sj6JYznPmGWnhJv4sUZoUNGuirUP82GeS4e6EazZcFBLPLX2clzGUJVGwbz2eB7ZfysTFSmSAEIm1uuRwNqWXNdz4WP/RqW8Kk56IEbPgCy9hg8OReBI9v1LdEBZ8erfG79urWPVaZ1sXlwsdeNw0ZJE7UVlxX/uSTSgLFIkyaWiYuluel4n1reLOXPBEYuTAbr76+eLi3Q6dCKa2V9w/YzTkKh3TUkd1yp61JESs5QAK5eL7t1dRCTGZXhl9j9mgTWUM/vIrf9t+GIAzHxswDU1Ks2RMzHTZrFb5ql/rb6kK64Udq2rz+Ov58IwpfAXZaZPv6o+S8TF0AwbbpDtnbbiNJ9szG9RtBy6bLG2FKhLZ7gMnNu7Tg3WuHcQv1jEc/tBMwLcZZa05N3ATFsc23bMlI/66qxYOc0y5e9eZe0YyyBpk38rdkQAQ97VCO7E4QwGtuAG8Uw5HPJWilLKZmtZLVCmlCkMfhAhwRuv4Ykb6zN+cXoIrSSvCHzRwRPAUo4tVmrp63aTef92EWRKIxA1UB0cIiGKAY3l6bNp8675/CX0VnljD+Q92/USIKOEynN3pvZY5ng
 7m26iyO/
 1JTjmR26jQog+g6GAnlR2TihMB7YRRnHvjKSFg7jETR4VcFAYnqnfPoli7lQnUpYnpuSn8vbbytEAJ7k1kPkfr3HibuFHKI0JtIgpEzrEM4EZOh5HfXDX72bBurjBgzlJV0CseaPmdS308DzWugoFO48VDD6+LXM0aFxHyZaWTsjqZgBb2TNMTmZNlHdZ8jj3aKT9O1WIZnlqzg8dP6rIo8G+deaLcn4y3xCkj2IvP81gjo4t1+SimMjk8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Problem
=======
When available memory is extremely tight, causing KSM pages to be swapped
out, or when there is significant memory fragmentation and THP triggers
memory compaction, the system will invoke the rmap_walk_ksm function to
perform reverse mapping. However, we observed that this function becomes
particularly time-consuming when a large number of VMAs (e.g., 20,000)
share the same anon_vma. Through debug trace analysis, we found that most
of the latency occurs within anon_vma_interval_tree_foreach, leading to an
excessively long hold time on the anon_vma lock (even reaching 500ms or
more), which in turn causes upper-layer applications (waiting for the
anon_vma lock) to be blocked for extended periods.

Root Reaon
==========
Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check
"if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
number of loop iterations are ineffective. This inefficiency arises because
the pgoff_start and pgoff_end parameters passed to
anon_vma_interval_tree_foreach span the entire address space from 0 to
ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
In fact, we can significantly improve performance by passing a more precise
range based on the given addr. Since the original pages merged by KSM
correspond to anonymous VMAs, the page offset can be calculated as
pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
defining:

	pgoff_start = rmap_item->address >> PAGE_SHIFT;

since KSM folios are always order-0, so folio_nr_pages(KSM folio) is always 1,
so the line:

	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"

becomes directly:

	"pgoff_end = pgoff_start;"

Performance
===========
In our real embedded Linux environment, the measured metrcis were as follows:

1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
            and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
            in a loop of anon_vma_interval_tree_foreach.

The result is as follows:

                 Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
Before patched:  228.65       22169                 22168                    0
After pacthed:   0.396        3                     0                        2

The referenced reproducer of rmap_walk_ksm can be found at:
https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 950e122bcbf4..54f72e92b7f3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3170,6 +3170,9 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const pgoff_t pgoff_start = rmap_item->address >> PAGE_SHIFT;
+		/* KSM folios are always order-0 normal pages */
+		const pgoff_t pgoff_end = pgoff_start;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3184,7 +3187,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		}

 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       pgoff_start, pgoff_end) {

 			cond_resched();
 			vma = vmac->vma;
-- 
2.25.1

