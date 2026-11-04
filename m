Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F827606A33B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sp83wNpG
Received: by kanga.kvack.org (Postfix)
	id A578E6B00EF; Wed,  4 Nov 2026 03:43:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01D76B05B1; Wed,  4 Nov 2026 03:43:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0696B05B2; Wed,  4 Nov 2026 03:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62E0B6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:43:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0247AA81B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:43:40 +0000 (UTC)
X-FDA: 85396798242.12.3AE8D23
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf05.hostedemail.com (Postfix) with ESMTP id A108210000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:43:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sp83wNpG;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793781819;
	b=ARCNh9EoOp8RwWvkgexQ7A1E6GfC6tXPNX51k+BXq0ADQSR9FD6vn2F66ixfBeOL4H2VkY
	bQR7HHDhwnoHpuFmgzzhTLh0yI8WWZmvtidTWL3lIK93+iiN4o4emfR3ZWOqKsy2IB+VnX
	dTbbyNXRcU5BCatHFNAW19KaZCa13X0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sp83wNpG;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793781819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2hk/rNUhdh8MzoGh+JB++bhZwGGGXc0fWWdJjx7Q34=;
	b=j6EZ+h1QhDe3u9zNFX9r+XWEmapkt2EUAnSgWHoOuMSrmtmghLNz8RYzF0NwKliOL2AMtw
	wD3qNOPF4rBAY4fWoWuHIXmXErgpDykLNrOdAxZBng/4ss9L/te7fgqLwA1ezEqTc9wGVc
	JI68tW90CFVn5s4dtq93tFguewRH9e8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f2hk/rNUhdh8MzoGh+JB++bhZwGGGXc0fWWdJjx7Q34=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793781817; v=1; x=1794386617;
 b=sp83wNpGcg3gaaZ8Q1xR/9GuIAN39T9nU3daATAk0D3PyazINZZkLbge+C8jvkhlT/l1yMyQ
 z4PY8O3ch/eBLnfTIKoQOWvUBUqWReMoaFrNfi96CuAqZM2S8rXHR4UmnarPZPvmVgtfzb2K9u1
 F4JsYvveNIOBOxe1A0qJ86Lg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3c5b907775b29065;
	Wed, 04 Nov 2026 08:43:36 +0000
X-Mizu-Trace-ID: 3c5b907775b29065
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	mingo@redhat.com,
	will@kernel.org,
	boqun@kernel.org,
	longman@redhat.com,
	surenb@google.com,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	yonghong.song@linux.dev,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/khugepaged: scan mm's more efficiently under mmap_lock contention
Date: Wed,  4 Nov 2026 16:43:26 +0800
Message-ID: <20261104084326.35457-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261103-khugepaged-latency-fix-v1-2-a07ab16ac860@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-2-a07ab16ac860@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A108210000E
X-Stat-Signature: m4aybmma8bsk1oxjzpxx1fxch3dwcuk1
X-Rspam-User: 
X-HE-Tag: 1793781818-481813
X-HE-Meta: U2FsdGVkX18vUtENYDoVDGLvJSR87McKHW5Lvm1J8XJvGfFMsqybYbo64mag8dGm6VSEnHKXnbouoffGJ+ENEqgeHKRKYK279ZF0g9FSM1y1IsOUQX0N8nvKYPW8AUgsDwUTbtWhz+UYLNpCTLDKqlR0UaQdXQmd4AzKNP/rH5lWOtEz0oJOAO3w9AgedDw9Hw/OjJY4fVr575xt8gfGbLBm7zW9UUw3WIaG2qPiwfSBhADYP8hAr/gkX940R1OgKrfrlaPIAY5NiivHNFpc2cHBV8QmmdpRawn+1lREzXBQo3zslgisnN4abYdtlSawppmA5LigITFlOJUCu55Bwv2hOWURpYjAkG+hpF5vw/z06c6MQ+XOpnXHZiVVGuDKgVPRRZnW0YbszNRWXmBhjuBrR3XYi0WhkD7s3J7296PhdLOTyZVMnee2vlVx+YRiNEwnTAo2XzM6u1HhD5nz99Ao1Wbdz+/750a3nExgETtVa4xJ3CpSppr1+/4G8BQtl13iplyOrXzyyZQIbEdGR2IzsknEIiqINOEf7iOauAkl+sOE0imb40t+q8RxmzPmNpVhazWg7isy1vBpvY/Qpe3+9z0FyuZXcRZLb+qOyoeNbhVUra+Yeh2hKNsRZ7yInAHYkoqg+x4pqR+5Y9h5yPyr3XjFJFeYUQ86UDMwEKQIA5anxHpf6or/AwKs1mxr8c5GMk1XvSxSSWSLT7cfU9vD6pjs33Jz+R8AYosNLoC3lP8xrJbCCqzKwvpMtiEdrGJ1uHTBBV0YBPUXGupWmoWKPAvEjj5dbWjapCvSEF4MwXYA2fpE8idZO/xeXmjpeaie9UXTHF5ocA5YskYnVnY868qZzRMOOYXEG6aWbIBmtZSNvAmvqpEuQcrzuskiU0a3UhFpKJNTn2AT1iWIKmfQWozzAez6Jj/1Gh4kSxonxhRbJIqfgFoMwSO0lCXDwh7WvVv68TS2cy+L89q
 L/y1xq/W
 CLEPVC1tYZos8Xfczg/EtM9h1I9KhruzwAzvIjDtOPwPRTR134zfP/jBl1BIQog3ZiPzjERYnXqg1n1+HwSFlIACs8BKeGIqLpIqeyvOu0gDiUjnyB5gmeO2zK6BL8KwpNYZolqZ8TbKZFHfZqzRe4zSa0f7GDQn0o0cGcEOYwTjT56RpNuYHpFRrb0B18qK0SPvde+xqBaendducy/YCt18hL2yDRuIuZ0ZEh8X8YhikPW/PPZNQbiw90Z0GMaMXZN6a5Luc78UCQ6vTYhawVEfTG4sTME216SNjmEE2FaegzA5pNkYKvh/BvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Nov 03, 2026 at 08:27:43AM +0000, Lorenzo Stoakes (ARM) wrote:
>Ostensibly khugepaged collapse traverses eligible mm's, scanning up to
>/sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan eligible pages
>at a time, sleeping for /sys/.../scan_sleep_millisecs between each
>traversal.
>
>mm's are scanned in collapse_scan_mm_slot() under the mmap read lock,
>obtained using mmap_read_trylock(), skipping the mm if there is lock
>contention, and dropping the lock before allocation.
>
>khugepaged will keep scanning the same mm until it is about to be torn
>down, prctl(PR_SET_THP_DISABLE) disables THP for it, mm->mmap_lock
>contention occurs, or all its VMAs have been scanned.
>
>When any of these occur, khugepaged doesn't keep track of where it left
>off, as the current address is tracked in
>khugepaged_scan.address (essentially a global value), which is reset.
>
>This is a problem when lock contention occurs, as when the mm is next
>scanned, it starts from address 0 again.
>
>If there's a lot of mmap_lock contention this can significantly slow down
>collapse later in the mm, since the /sys/.../pages_to_scan budget can run
>out before the end of the mm is reached.
>
>The budget is incremented (as tracked in cc->progress) at a rate of 1 page
>per ineligible VMA, but the budget is only checked once eligible VMAs are
>encountered.
>
>Then, it only takes the combined total of ineligible VMAs and eligible but
>non-collapsible pages to exceed the /sys/.../pages_to_scan budget for the
>rest of the mm to be skipped.
>
>For a system with 4 KiB page size and default sysctl settings this only
>requires 4096 ineligible VMAs/uncollapsible pages to be skipped before this
>happens.
>
>Examples of eligible but uncollapsible ranges are those containing a large
>number of forked PTE entries (more than /sys/.../max_ptes_shared), swapped
>out PTE entries (more than /sys/.../max_ptes_swap) or none or zero-page PTE
>entries (more than /sys/.../max_ptes_none).
>
>The latter might seem unlikely to happen given /sys/.../max_ptes_none
>defaults to HPAGE_PMD_NR - 1 and CONFIG_PT_RECLAIM frees PTE page tables,
>however CONFIG_PT_RECLAIM only removes the page table if the zapped range
>spans at least a PMD size (see pte_table_reclaim_possible()).
>
>Thus, userland software that applies madvise(..., MADV_DONTNEED) across
>sub-PMD ranges can thwart this, which is quite feasible for memory
>allocators and GC heaps, for instance.
>
>Resolve the issue by simply tracking the last examined address in the
>khugepaged_mm_slot object, so when the mm is resumed, the scan starts from
>where it left off.
>
>Additionally, skip to the next candidate if a VMA cannot be collapsed.
>
>This issue was noticed during some work in which an mm was instantiated
>with a large number of small VMAs under significant mmap_lock contention,
>during which collapse was observed to take 10.8s. With this patch applied
>it took 3.6s to collapse the same mm.
>
>Also, while here, update a couple VM_BUG_ON()'s to VM_WARN_ON_ONCE()'s.
>
>This patch is also a pre-requisite for a later patch in this series.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Looks good on its own, since vmi isn't reset inside the loop yet. Patch
#05 will need to handle the ALIGN() overflow Sashiko reported before
adding that reset.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

