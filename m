Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40622606A320
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nk8DpZQP
Received: by kanga.kvack.org (Postfix)
	id 55D6F6B05E6; Sat, 31 Oct 2026 05:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D466B05E7; Sat, 31 Oct 2026 05:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FD266B05E8; Sat, 31 Oct 2026 05:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4616B05E6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:49:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89B24A85C4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:49:24 +0000 (UTC)
X-FDA: 85382448648.12.1BD25B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C71A980007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:49:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nk8DpZQP;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440162;
	b=GNxir/ua/2ICqjXFn/n5Fy4CJAvQHPtzjKUHlM7Uli9jU4JJebPPn7Los9Ik5eYeU1NtgD
	y7rdQ+DUXEUoA2M1gte70hYec8tHnYYy2f1hs8XMWQdh+yuZg9fgDwwy+CtXys7wZ87Sg9
	i3iTWckL+hvTTyUTsmdSwB7ZIjZMbes=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nk8DpZQP;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzeRdDMVfEMNbkMdT/nRgGx9sjoVV/E/1Sv6j9DFArI=;
	b=N7CPMLvZxGpMq3gFzEfi6NQDn6lsr8vcQfK+k6a/PpmNjo15Rr9Hnr6Ugeu0kQ3fsBfb8D
	M5vbP1uLY3Eme0T6IaD2EftokS1WjJNP/bpvYPVWm4l+Xt/5vpsci4hB9Me45IhktDYniz
	Skkxhg8gOkKU/R0NpArjJaVJdjivZrE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09C7B40D9F;
	Sat, 31 Oct 2026 09:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768741F000C1;
	Sat, 31 Oct 2026 09:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440161;
	bh=pzeRdDMVfEMNbkMdT/nRgGx9sjoVV/E/1Sv6j9DFArI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Nk8DpZQP6BzD9OA8zt/17XY/95wwW4UIU2PZ2B9LYSCoMPTi2ddtIV6u99LHr+5Oe
	 g4tDbV0A9eSd5emCxI8wukjjJ2YT2aWaeikxo/9ZsvfdGNzOUVTriMj7ENkyyLHSUr
	 /AmyIiG8Vw/uXBjmX5bA/kDSRtXD7rVcvEJxXTMudlPtX62drHe3FsXcaMp69dcM9/
	 YwYGbDDS5YN7PQOQjxE/6H/9hJFXhZl2GVnrqXpy2NO/l62R63MYQrI/IpmBB0SIR1
	 0pQhFdr/sND4w08uekTBmbzVcrRzdHw2xwe/pl3C0l93a6hCf30nDvqDtr32D5+WyV
	 NJm0qxt4y7qnw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:04 +0100
Subject: [PATCH v3 35/47] mm/memory: reject remote COW faults on PFN
 mappings
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-35-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2304; i=david@kernel.org;
 h=from:subject:message-id; bh=vy3o0JKxTUrol+3XYhfqk0XP7HsGSqgA1eThmpFZJfQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs/sadz7N7koN4X/1CmTNuOJDc28a4xv2m9VPWy6Q
 qSCb2NnRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABPxes3IMDdGTmx1U9JkAxWO
 z0JHpPjtV/9wspB8sXV9S7o/z6MaV0aGG98XcfzwDPadESJ0P5rn4aVNSzjtP99zunv3xwmuytf
 uHAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: C71A980007
X-Stat-Signature: rq397qhmuqggxx4qmwhzukahd7r4q65q
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440162-264639
X-HE-Meta: U2FsdGVkX18B5txbFy4UdBAIQctazL3/8b0X6OatuMdCA9NNU7rdfTxmnyfawVcr19E7NvMjWDT85Qh4lGRiQj+Z3vl6yr1HwYRW2/fMKt0flPYr1ceLYczPkShMi6PDKgPFHNlAn7den7nCj26h7jZzbW6e7yzDmh1TkdQzRgcHTkA1fmk1PtgP1vSSlilNKubY4FcUgaNT47MuzDW9ZpSn0fPayQE+f6YMxJcaywz7mFUh2HW4EBIVXxQoONyOe0pN4/rB5Y8l8AxNA9zfQMiwxfJXS8bSabhIIFBaG/7V++7HJvBWizb11pRr+0pVm9CKGUz4rTl1wBCeyPGWgEGy9mOPDa2TX27e02VDW/4L11jMBmkjl/m32YMovzHaDOvfGp+N7f5swS6Lxmt4xrMe1b0DisFExgvt6v63Z+EgNWkbOlNz6+51A1WQfRketku5WEVFncu9rrxtin+UuPDsEvFBSP1uRhUXS46qRUdLAIj85LcPhG74whSK7ANiVUGbIHudlNx/LLrWkeaoUwsQe0wgbvVULBExlq1TxIkjcUnRpDoriXtNZD0Q1d8LQlF7JaOYWO179jygsyyKV1VxzDInEdFwqZbJW01o8r8mJ5Wg+QtLsKR3ur6drmsIMx7VttaHQ+el8gHW/4sqVg2tlMPeUbhA1iPBe5FA7tjzYdHz2AWN0UkMAQymfCUmXqFG44FW3TkOXjfOE3evA2fpmqdg1Y6H4v6RhGqgI7SbQFd0HnWwnfGmg2A51kM/ocZ8ViEgyWuc8UrLlOdxEGPcKYI0TJieBhCUm2zqlhwWIbJ0ZGQp76QwFQp/eTgnMrd4qW8wATMJ4+Ayg/o46T+M8Opie3yjroEk0cxAnJGzAhQ8K1iWXH0PjK9ay6+BT3/4cvApqfHoEJBvkUPpSy0wCQXOKvHLIyNCEzS2Jv4YbFJu9MsYC/bRndoG6mHalG/0jHL5ygKlyx/7PR+
 23wyHS3a
 5f/XiuqNmGQ1B/4HgpNVtqCiShWAqTLrj6LzYj+k2JEeg+ZiYOhnSkjYASBvocVWiyQA4gD/jqXof5uyQlpBewIOu9fWIxHGVJxjN2Mt5z/o16qNmgM7r8OEXdTZnVlyXgpUCDWK4Ay7NQHkt8ifR9kYDxlOnBorxYkyRHVzVcyDeCoiQ3sycqpEvyPpHUWXrY+SmO+NjaN3YURcWLla8zjEom0oP/dDfjxUnPiO2Nw3ciY9WjnwOQJXljNLKuHX6QF3Ozt4/GcbIOhKvJIKlEU0gLfBeblHeQoCanF5aS+K0C6X3nYHTmEC5Dgk9T+ODq2QwpqGC9Zw5Qzt57JQJQwgIzxj5pexjLiclP6lT26gRgcgN+I5ufAtAFyUAOax7rWrJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

When handling a COW fault without a normal source page (PFN mappings),
__wp_page_copy_user() copies from the faulting user address. For remote
faults, this accesses the wrong address space, resulting in wrong data
getting copied.

For example, user_events updates an enable bit in the registering
process's memory. If that memory needs to be faulted in,
user_event_enabler_fault_fixup() calls fixup_user_fault() from a work
item. Placing the enable bit in a private PFN mapping can trigger this
remote COW path.

Reject these faults with VM_FAULT_SIGBUS when the target mm differs from
current->mm: remote faults. Ordinary (non-PFN) mappings are not affected.

The user-address copy dates back to commit 6aab341e0a28 ("mm: re-architect
the VM_UNPAGED logic"); likely, actual ways to get remote faults in
there on COW PFN mappings appeared afterwards. But the fix is simple and
straight forward.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 6aab341e0a28 ("mm: re-architect the VM_UNPAGED logic")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: simplify comment and description ]
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 5392bcb1d24d6..ae8d567bc6ba3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3761,6 +3761,13 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
 		return 0;
 	}
 
+	/*
+	 * __copy_from_user_inatomic() only works as expected for local faults.
+	 * Reject remote faults.
+	 */
+	if (unlikely(mm != current->mm))
+		return -EFAULT;
+
 	/*
 	 * If the source page was a PFN mapping, we don't have
 	 * a "struct page" for it. We do a best-effort copy by
@@ -4086,6 +4093,8 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 				folio_put(old_folio);
 
 			delayacct_wpcopy_end();
+			if (err == -EFAULT)
+				return VM_FAULT_SIGBUS;
 			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
 		kmsan_copy_page_meta(&new_folio->page, vmf->page);

-- 
2.43.0


