Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C6EC44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 05:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD4C6B00A4; Wed, 22 Jul 2026 01:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DFD6B00BF; Wed, 22 Jul 2026 01:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B3B6B00D7; Wed, 22 Jul 2026 01:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23F9B6B00A4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:51:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93CD41C06F8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:51:44 +0000 (UTC)
X-FDA: 85015340928.02.283C346
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 76FF5A000F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:51:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="S6ofp1a/";
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784699502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SDiqtRBxRhp3mF/7FlSaxctPd8G/uMc3TWKDq03LZFs=;
	b=E3K/YJDpRXCFCrWgnmb9gkL2p1+kpl1yN65viVFk4TRR6ndo1Jco46vXM+/pmZa/yUmqBe
	0njVhypabrhpviT8bwS//OQc2Lg+6DRA6j1/3X5sjBhdbCqUbqEl/CDq3nrYOqwPgE0n/m
	hHz9cFYz5mzOc7ZEnyDRdYCi5Fp4Yio=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784699502;
	b=4Fjc6djSNeJ3ID8ZbejaLPSzCfX3W3Oh8uZBT1jTuCVyxveQ6JhrlCJJx/A4bLUYxY0SvM
	1t4pd5dEEeoFGRavHptRh2bbQCxSqI/Cl+nFZ6JQkJI2N9DA/5fyHX+kogM9tFIHoPGsb9
	B7hn9jGgSe4GVbkNfUv8Nas3IlO/saQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="S6ofp1a/";
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4041A40218;
	Wed, 22 Jul 2026 05:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1C31F000E9;
	Wed, 22 Jul 2026 05:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784699501;
	bh=SDiqtRBxRhp3mF/7FlSaxctPd8G/uMc3TWKDq03LZFs=;
	h=Date:From:To:Subject;
	b=S6ofp1a/AC8EBAO+WtFHte519PsgOEabvkDoGOkUKrQ5EVePQgp+nZQMy+KONJTRP
	 MVLdPm7KWgveHzgrULQKWCnWHzquClKbbEZzEl+zLnJxqkbA4g/G75F2UeT6I9TpG2
	 VWKqfofnWGNAY4adWvcVYPRXQlDPnqtSePju+aJ4=
Date: Tue, 21 Jul 2026 22:51:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status at 7.2-rc4
Message-Id: <20260721225139.fd654a3a40e755d3e621899d@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 76FF5A000F
X-Stat-Signature: d8zmg3f1dww8ud13jf9qw1737fotatmx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784699502-253225
X-HE-Meta: U2FsdGVkX1+nNYlxGRcoNr/nZ0McVxHITIgbSN7JrY7Cy/KjDR8I4OqO/gEM/R5oMh0dp9uZVsTr7Oeo70Pv/koU5Kaf9ubS0eQBSsjJsArId+HZvQygdyXwzEdhvUn8nBv+8gRuPYSZRc5MHlJnwiRngJv8ZwogkxhYwtGAJqqHKdm+Zjkjp595U3TDbh039RQSi2iJztuvNQTiYsFoJwdCE5AQDXxqu/1OaO5WbI4u+wmpDn4OuffbXD681bznrL9MDwZBKRYqw1zhvbDA+SVW7V/YqTQu7Slj8utwlD6gGaJZzKu9JHyoIJO6nCKvbtlydIVcucqFr4SVy0aqg+z9OUWaWHVNcb3qyEqWgzv6SK7cjg6aPWQ1Wn7CuvXgiOaFeq2LByaYS0YzeAVsfFpWxtqNgzh1ilvK7vX3QZShvuOUPl1m0guGdyWWSRkLQ0qc33LsNWzWBN+n03Fr6XD3A4bSJqiaLRgpwRBiajj4/bfMU5h4JliOiPE20yCsX0jwNPTCsR0PWtstmfhTZhG+Ok1mNI3Z4qmd1ad59XEQLDudjN0g1sUywQRTX2RC1Ax6IVg2jBKaMVArYfSKWlEZUpM2brFHGYcd23KxjKIk/I+0JcHicFvT6fKRkmDDd+h67zs8+cyzR2anz0b+tMkgqvvixv9yzWmxP54cPLiKxYTaBHLwPM43+em+AAOaGP+XGGdaKInhEwOzEvePtLjd4D+L7SX1MfyVjBNja1Kf6rQrARK0Mf9pBquA+s6rBxxH/+J0lRlk/FC/ezLUGXW9l43QeVivIoMURkPRvRun0RjibL7Rf2Vhv5zsZdL0Q3M32Afhx8GQr9xaw1Ajjqv1mL75jEUXJ/2HZoAxAEpRrqmSeVG5XysSNQNMKUQfXmnaajgzzS+GNxPqx3xsCbBAH5hS1+4HhKh8xXubGlAtsIlrj2Pki2tjY6iMWxBeSv/rWeXo9Qs9AWGwykV
 fXueyx7h
 tYAhe3pk00hayj00k+gQfNyxI5RLXvNSGUTG/5h63SuBRpvMGR3SVciMhxVGGdBY4RjVqxKCAyVSQVXFNegOsL01Wr3gneHI9PhVm839CCblSb0k/buw3gFCi13KYWzod7R/UuiRzQbns1UrxbbGCf8SBFcHKhoGHG/br+7ACG8Dc7cUfaF4oOtxMw+0rMYSquI1jbnDktT1OtbKgJ0Jxj8njZ1LdfK3OanOfQR5WaOhupOYCpiSqgrNnI5z2W0WUQNeXgB+/fHMqYYRpV+nISFShnrK3x9JVwR5LKYtv5aqyUcVuI7TocREQK3wvqJQ6puEOy1bPMMJe5qzGJzHAtVhKhHj+ZtwoZLMLpU1mDZWIPQLkQZp3lK9jljgkNlvXWJsqjYrbFh5CZhyMROYuf1/bg2WkXndGhsU0a0u0SSK+ZTfJFjjmRj6VJbWk0yKeyNKRHeCPTgVh2hwKRrfWZZoQK4Edq2dZxOo4kGaZBRfjVQcXiBYsxnlW2yofHisFvkEeV4E6RccWZGsaRTO94g8UJpfkAyDjHjS5CMFADO7tQmMoM5YmG/vG2qO4XrHTHTufRj16BL9Fkvpmyka3JVxEarShRYq3UVmJEdPXb1RvHRKxxyUH3presrWjBZsYeWJi3G5v12Agz/Amrjxvardc6BeX72Sie9fQwAwFSsF2bHrUimLs3Hkzl1tmNG/XtpZ+nKCFr8gs2Cx2+R5OZwI7AIEYRRicIzYYkUb+eSo2uoxY92rDVq4/b1/8t4UJPq0yjBKlLcDjz/Env5fN4UxTg7NzSSl7ZnwfyLNIZHRmwL5vT0T9gWVI/AmWYTQSoEUIDuEwSK7K2vV+9cZ2vWctIVhG0iA7O1PO+6kLn0TfnCwq38kl3e19PsU4MJSrYDsrqX/WQzuTiA1zGCMCKaAvMrkDrGWZ3cHHAGoRmz5KhfUHH1tIEZUoSRoPIDqqCDbuVIRc44VjCileQW2Ww7GwEXgi
 3jCfQm4H
 Nbt3WVqC9ZlHJRtAIYYICTL0tFmg0P7UfpLaIe6I4U+DXgxTNuswsBWmid9TiOlQIeQ9Te1BskvbcNNS5QhoNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


That's quite a lot of patches.  In the 7.2 merge window it was 439 and
here we have 578, So far.

The review rate of 83% is OK for -rc4.  Last cycle we ended up in the
low 90's.


The past couple of cycles I've been operating what we call "quiet time"
- slow things way down to give us several weeks for review, test and
general consolidation.  I think that's been an improvement - opinions
are always welcome!

One effect of this is that when I come to process new material (late in
the merge window, after we're all merged up) I find there's a huge
amount of material buffered up.  This has all made my merging activity
more lumpy than previously - a lot of merging between -rc1 and -rc4
then it tapers down heavily.

I still have >200 emails from May to process (sorry, but it isn't
lost!) and I have ~500 emails from June/July to slowly pick through. 
The great majority of this will be obsolete by now, but there will be
some gems in there.


At this stage I'll be prioritizing fixes and tasty speedups which come
with convincing performance measurements.  And, less enthusiastically,
well-reviewed additions which have been on the mailing list for a while.

If you're working on new material then please plan on 7.3-rcX.  Now is
the time for us to place more emphasis on reviewing and testing the
existing pile.

Thanks.


mm.git review status for mm-hotfixes-unstable..mm-new

Everything:

Total patches:       578
Reviews/patch:       1.47
Reviewed rate:       64%

Excluding DAMON:

Total patches:       433
Reviews/patch:       1.89
Reviewed rate:       78%

Excluding DAMON and selftests:

Total patches:       404
Reviews/patch:       1.94
Reviewed rate:       80%

Excluding DAMON, selftests and maple_tree:

Total patches:       385
Reviews/patch:       2.02
Reviewed rate:       83%



Unreviewed patches by author:


Ackerley Tng <ackerleytng@google.com> (3 total)
    "mm: hugetlb: use error variable in alloc_hugetlb_folio"
        Link: https://lore.kernel.org/20260702-hugetlb-open-up-v4-4-d53cefcccf34@google.com
    "mm: hugetlb: move mem_cgroup_charge_hugetlb() earlier in allocation"
        Link: https://lore.kernel.org/20260702-hugetlb-open-up-v4-5-d53cefcccf34@google.com
    "mm: hugetlb: refactor out hugetlb_alloc_folio()"
        Link: https://lore.kernel.org/20260702-hugetlb-open-up-v4-6-d53cefcccf34@google.com

Andreas Gruenbacher <agruenba@redhat.com> (1 total)
    "writeback.h: fix a typo in the wbc_init_bio() description"
        Link: https://lore.kernel.org/20260615162244.2170866-2-willy@infradead.org

Andrew Morton <akpm@linux-foundation.org> (5 total)
    "mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix"
    "mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix"
    "mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix"
        Link: https://lore.kernel.org/202607020359.FMDmPwjF-lkp@intel.com
    "mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes"
    "mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix"
        Link: https://lore.kernel.org/3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org

Barry Song (Xiaomi) <baohua@kernel.org> (1 total)
    "mm: rename in_lru_cache to maybe_in_lru_cache"
        Link: https://lore.kernel.org/20260708145718.82690-1-baohua@kernel.org

Catalin Marinas <catalin.marinas@arm.com> (1 total)
    "mm: kmemleak: confirm suspected leaks with a second scan"
        Link: https://lore.kernel.org/20260713-catalin_pto-v1-0-5b93b1131089@debian.org
        Link: https://lore.kernel.org/20260713-catalin_pto-v1-1-5b93b1131089@debian.org

Kaitao Cheng <chengkaitao@kylinos.cn> (1 total)
    "mm/percpu: avoid IO/FS reclaim in backing allocations"
        Link: https://lore.kernel.org/20260618130414.96383-5-kaitao.cheng@linux.dev

Yichong Chen <chenyichong@uniontech.com> (2 total)
    "tools/mm/page_owner_sort: bound pattern output copies"
        Link: https://lore.kernel.org/20260629014316.130307-4-chenyichong@uniontech.com
    "hugetlbfs: release subpool on fill_super failure"
        Link: https://lore.kernel.org/20260720021900.1376309-1-chenyichong@uniontech.com

Yunhui Cui <cuiyunhui@bytedance.com> (1 total)
    "mm/gup_test: fix race with PIN_LONGTERM_TEST ioctls"
        Link: https://lore.kernel.org/20260608025043.88087-1-cuiyunhui@bytedance.com

David Hildenbrand (Arm) <david@kernel.org> (1 total)
    "mm: standardize printing for pgtable entries"
        Link: https://lore.kernel.org/20260709044334.1741263-1-anshuman.khandual@arm.com

Dev Jain <dev.jain@arm.com> (1 total)
    "mm/rmap: refactor anon folio unmap in try_to_unmap_one"
        Link: https://lore.kernel.org/20260713050050.1017741-5-dev.jain@arm.com

David Carlier <devnexen@gmail.com> (1 total)
    "mm/swap, PM: hibernate: atomically replace hibernation pin"
        Link: https://lore.kernel.org/20260430195651.287659-1-devnexen@gmail.com

Sang-Heon Jeon <ekffu200098@gmail.com> (2 total)
    "mm/early_ioremap: clarify early_ioremap_reset() semantics"
        Link: https://lore.kernel.org/20260708170647.362562-1-ekffu200098@gmail.com
        Link: https://lore.kernel.org/20260708170647.362562-2-ekffu200098@gmail.com
    "riscv: remove unused __late_set_fixmap() and __late_clear_fixmap()"
        Link: https://lore.kernel.org/20260708170647.362562-3-ekffu200098@gmail.com

Gregory Price <gourry@gourry.net> (2 total)
    "dax/kmem: resolve default online type at probe time"
        Link: https://lore.kernel.org/20260712154505.3564379-8-gourry@gourry.net
    "selftests/dax: add dax/kmem hotplug sysfs regression test"
        Link: https://lore.kernel.org/20260712154505.3564379-11-gourry@gourry.net

Christoph Hellwig <hch@lst.de> (2 total)
    "mm/swap: also use struct swap_iocb for block I/O"
        Link: https://lore.kernel.org/20260713093350.2154226-4-hch@lst.de
    "mm/swap: remove SWP_FS_OPS"
        Link: https://lore.kernel.org/20260713093350.2154226-7-hch@lst.de

Injae Ryou <injaeryou@gmail.com> (1 total)
    "selftests/mm: fix on-fault-limit false failure under sudo-rs"
        Link: https://lore.kernel.org/20260713092700.464376-1-injaeryou@gmail.com

Jaeyeon Lee <jaeyeon.lee.dev@gmail.com> (1 total)
    "mm/shmem: annotate benign data-race in shmem_getattr()"
        Link: https://lore.kernel.org/20260708111941.35460-1-jaeyeon.lee.dev@gmail.com

Jianhui Zhou <jianhuizzzzz@gmail.com> (1 total)
    "mm/userfaultfd: clear uffd-wp PTE state when re-registering without WP"
        Link: https://lore.kernel.org/20260601082609.170076-1-jianhuizzzzz@gmail.com

Kiryl Shutsemau (Meta) <kas@kernel.org> (2 total)
    "Documentation/userfaultfd: document RWP working set tracking"
        Link: https://lore.kernel.org/20260708111417.173443-16-kirill@shutemov.name
    "selftests/mm: add PAGEMAP_SCAN test for THP PMD holes"
        Link: https://lore.kernel.org/aljWYfPRCVc6IB2b@thinkstation
        Link: https://lore.kernel.org/20260715144234.442721-3-kirill@shutemov.name

Breno Leitao <leitao@debian.org> (3 total)
    "radix-tree: fix kmemleak false positives on tree head reassignment"
        Link: https://lore.kernel.org/20260703-radix-tree-v2-1-38bb6efb5f6e@debian.org
    "mm: kmemleak: factor leak confirmation into a helper"
        Link: https://lore.kernel.org/20260713-catalin_pto-v1-3-5b93b1131089@debian.org
    "selftests: mm: test kmemleak's N-consecutive-scan leak confirmation"
        Link: https://lore.kernel.org/20260713-catalin_pto-v1-4-5b93b1131089@debian.org

Liam R. Howlett (Oracle) <liam@infradead.org> (16 total)
    "maple_tree: add rcu locking check when LOCKDEP is enabled"
        Link: https://lore.kernel.org/20260630190843.3563858-1-liam@infradead.org
        Link: https://lore.kernel.org/20260630190843.3563858-2-liam@infradead.org
    "locking/lockdep: add sequence counter to held_lock"
        Link: https://lore.kernel.org/20260630190843.3563858-3-liam@infradead.org
        Link: https://lore.kernel.org/all/h3tpnj5kzcrxms5picmimtkpg4aypcpip5wbd6bt2rpdj5k7eb@nhtzs3lefrkq/
    "maple_tree: add write lock checking with lockdep sequence numbers"
        Link: https://lore.kernel.org/20260630190843.3563858-4-liam@infradead.org
    "maple_tree: drop dead code from mas_extend_spanning_null()"
        Link: https://lore.kernel.org/20260630190843.3563858-6-liam@infradead.org
    "maple_tree: drop MAPLE_ALLOC_SLOTS"
        Link: https://lore.kernel.org/20260630190843.3563858-7-liam@infradead.org
    "maple_tree: clarify comments on mas_nomem()"
        Link: https://lore.kernel.org/20260630190843.3563858-8-liam@infradead.org
    "maple_tree: use prefetched value in mas_wr_store_type()"
        Link: https://lore.kernel.org/20260630190843.3563858-9-liam@infradead.org
    "maple_tree: optimise mas_wr_node_store() when not in rcu mode"
        Link: https://lore.kernel.org/20260630190843.3563858-10-liam@infradead.org
    "maple_tree: micro optimisation of mas_wr_store_type()"
        Link: https://lore.kernel.org/20260630190843.3563858-11-liam@infradead.org
    "maple_tree: add bulk parent set helper"
        Link: https://lore.kernel.org/20260630190843.3563858-12-liam@infradead.org
    "maple_tree: WARN_ON_ONCE when allocations fail"
        Link: https://lore.kernel.org/20260630190843.3563858-15-liam@infradead.org
    "maple_tree: document erase and allocations better"
        Link: https://lore.kernel.org/all/20260617180419.GA231643@ziepe.ca/
        Link: https://lore.kernel.org/20260630190843.3563858-16-liam@infradead.org
    "maple_tree: change two GFP flags in tests"
        Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
        Link: https://lore.kernel.org/20260630190843.3563858-17-liam@infradead.org
    "maple_tree: fix argument name in header"
        Link: https://lore.kernel.org/20260630190843.3563858-18-liam@infradead.org
    "maple_tree: avoid extra gap calculation"
        Link: https://lore.kernel.org/20260630190843.3563858-19-liam@infradead.org
    "maple_tree: add helper mas_make_walkable()"
        Link: https://lore.kernel.org/20260630190843.3563858-20-liam@infradead.org

Hongfu Li <lihongfu@kylinos.cn> (2 total)
    "selftests/mm: fix clone cleartid race in pkey sighandler tests"
        Link: https://lore.kernel.org/20260706081600.3570203-7-lihongfu@kylinos.cn
    "selftests/mm: factor out hmm_buffer_alloc() to consolidate buffer setup"
        Link: https://lore.kernel.org/20260713033209.280435-1-lihongfu@kylinos.cn

Lorenzo Stoakes (ARM) <ljs@kernel.org> (15 total)
    "mm/vma: introduce VMA virtual page offset field and add helpers"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org
    "mm: introduce linear_virt_page_index()"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-2-2d549757a76f@kernel.org
    "mm: abstract vma_address() and introduce vma_anon_address()"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-3-2d549757a76f@kernel.org
    "mm: update print_bad_page_map() to show virtual page index"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-4-2d549757a76f@kernel.org
    "mm: introduce and use vma_filebacked_address()"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-5-2d549757a76f@kernel.org
    "mm: propagate VMA virtual page offset on map, remap, split + merge"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-6-2d549757a76f@kernel.org
    "mm/rmap: track whether the page VMA mapped walk is anonymous"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-7-2d549757a76f@kernel.org
    "mm: introduce and use linear_folio_page_index()"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-8-2d549757a76f@kernel.org
    "mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon folios"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-9-2d549757a76f@kernel.org
    "tools/testing/vma: expand VMA merge tests to assert virt pgoff"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-10-2d549757a76f@kernel.org
    "tools/testing/selftests/mm: test virtual page offset merge behaviour"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-11-2d549757a76f@kernel.org
    "mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-12-2d549757a76f@kernel.org
    "mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-13-2d549757a76f@kernel.org
    "tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-14-2d549757a76f@kernel.org
    "tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests"
        Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-15-2d549757a76f@kernel.org

Wupeng Ma <mawupeng1@huawei.com> (1 total)
    "mm/hugetlb: fix missing migratable flag on same-node hugetlb migration"
        Link: https://lore.kernel.org/20260707110254.3147686-1-mawupeng1@huawei.com

Muchun Song <muchun.song@linux.dev> (1 total)
    "mm/hugetlb: remove unused bootmem cma field"
        Link: https://lore.kernel.org/20260612035903.2468601-19-songmuchun@bytedance.com

Randy Dunlap <rdunlap@infradead.org> (2 total)
    "mm/page_owner: avoid docs build warning"
        Link: https://lore.kernel.org/20260708213548.469155-1-rdunlap@infradead.org
    "radix-tree: add/correct some kernel-doc"
        Link: https://lore.kernel.org/20260627185859.1632928-1-rdunlap@infradead.org

Mike Rapoport (Microsoft) <rppt@kernel.org> (1 total)
    "memblock tests: split stubfs from internal.h to mm_init.h"
        Link: https://lore.kernel.org/alJd1BLypyK9Mpaw@kernel.org

Sarthak Sharma <sarthak.sharma@arm.com> (1 total)
    "selftests/mm: transhuge-stress: check duration inside page loop"
        Link: https://lore.kernel.org/20260720103105.169955-1-sarthak.sharma@arm.com

Sayali Patil <sayalip@linux.ibm.com> (2 total)
    "selftests/mm: handle EINVAL when configuring gigantic hugepages"
        Link: https://lore.kernel.org/cover.1783446924.git.sayalip@linux.ibm.com
        Link: https://lore.kernel.org/2e3b585cbb30b2fc495dcd49d75de6f6da61861c.1783446924.git.sayalip@linux.ibm.com
    "selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes"
        Link: https://lore.kernel.org/78a3b0e3fb94004c0710872c5bab6f7381b7d63c.1783446924.git.sayalip@linux.ibm.com

SJ Park <sj@kernel.org> (114 total)
    "mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs"
        Link: https://lore.kernel.org/20260628220121.97360-1-sj@kernel.org
        Link: https://lore.kernel.org/20260628220121.97360-2-sj@kernel.org
    "mm/damon/sysfs: kobject_del() region and target (error) dirs"
        Link: https://lore.kernel.org/20260628220121.97360-3-sj@kernel.org
    "mm/damon/sysfs-schemes: kobject_del() scheme dirs"
        Link: https://lore.kernel.org/20260628220121.97360-4-sj@kernel.org
    "mm/damon/sysfs-schemes: kobject_del() scheme region dirs"
        Link: https://lore.kernel.org/20260628220121.97360-5-sj@kernel.org
    "mm/damon/sysfs-schemes: kobject_del() scheme filter dirs"
        Link: https://lore.kernel.org/20260628220121.97360-6-sj@kernel.org
    "mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs"
        Link: https://lore.kernel.org/20260628220121.97360-7-sj@kernel.org
    "mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs"
        Link: https://lore.kernel.org/20260628220121.97360-8-sj@kernel.org
    "mm/damon/sysfs: kobject_del() probe dirs"
        Link: https://lore.kernel.org/20260628220121.97360-9-sj@kernel.org
    "mm/damon/sysfs: kobject_del() probe filter dirs"
        Link: https://lore.kernel.org/20260628220121.97360-10-sj@kernel.org
    "mm/damon/sysfs: kobject_del() probe dirs in probes_addd_dir error path"
        Link: https://lore.kernel.org/20260628220121.97360-11-sj@kernel.org
    "mm/damon/sysfs-schemes: kobject_del() region for populate_region error"
        Link: https://lore.kernel.org/20260628220121.97360-12-sj@kernel.org
    "Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP"
        Link: https://lore.kernel.org/20260630141726.92246-1-sj@kernel.org
        Link: https://lore.kernel.org/20260630141726.92246-2-sj@kernel.org
    "Docs/ABI/damon: document probe files"
        Link: https://lore.kernel.org/20260630141726.92246-3-sj@kernel.org
    "mm/damon/tests/core-kunit: test damon_rand()"
        Link: https://lore.kernel.org/20260630141726.92246-4-sj@kernel.org
    "selftests/damon/sysfs.sh: test multiple probe dirs creation"
        Link: https://lore.kernel.org/20260630141726.92246-5-sj@kernel.org
    "selftests/damon/sysfs.sh: test {core,ops}_filters/ directories"
        Link: https://lore.kernel.org/20260630141726.92246-6-sj@kernel.org
    "selftests/damon/sysfs.sh: test dests dir"
        Link: https://lore.kernel.org/20260630141726.92246-7-sj@kernel.org
    "selftests/damon/sysfs.sh: test all files in quota goal dir"
        Link: https://lore.kernel.org/20260630141726.92246-8-sj@kernel.org
    "mm/damon/core: reduce range setup in damon_commit_target_regions()"
        Link: https://lore.kernel.org/20260630141726.92246-9-sj@kernel.org
    "mm/damon/sysfs: split probe setup function out"
        Link: https://lore.kernel.org/20260630141726.92246-10-sj@kernel.org
    "mm/damon/sysfs: split out filters setup function"
        Link: https://lore.kernel.org/20260630141726.92246-11-sj@kernel.org
    "mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/"
        Link: https://lore.kernel.org/20260630141726.92246-12-sj@kernel.org
    "mm/damon/core: introduce damon_nr_accesses_mvsum()"
        Link: https://lore.kernel.org/20260630040812.149729-1-sj@kernel.org
        Link: https://lore.kernel.org/20260630040812.149729-2-sj@kernel.org
    "mm/damon/tests/core-kunit: test damon_mvsum()"
        Link: https://lore.kernel.org/20260630040812.149729-3-sj@kernel.org
    "mm/damon/core: always update ->last_nr_accesses for intervals change"
        Link: https://lore.kernel.org/20260630040812.149729-4-sj@kernel.org
    "mm/damon/core: handle unreset nr_accesses in damon_nr_accesses_mvsum()"
        Link: https://lore.kernel.org/20260630040812.149729-5-sj@kernel.org
    "mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()"
        Link: https://lore.kernel.org/20260630040812.149729-6-sj@kernel.org
    "mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing"
        Link: https://lore.kernel.org/20260630040812.149729-7-sj@kernel.org
    "mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions"
        Link: https://lore.kernel.org/20260630040812.149729-8-sj@kernel.org
    "mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()"
        Link: https://lore.kernel.org/20260630040812.149729-9-sj@kernel.org
    "mm/damon/core: remove damon_verify_reset_aggregated()"
        Link: https://lore.kernel.org/20260630040812.149729-10-sj@kernel.org
    "mm/damon/core: remove damon_verify_merge_regions_of()"
        Link: https://lore.kernel.org/20260630040812.149729-11-sj@kernel.org
    "mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests"
        Link: https://lore.kernel.org/20260630040812.149729-12-sj@kernel.org
    "selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp"
        Link: https://lore.kernel.org/20260630040812.149729-13-sj@kernel.org
    "mm/damon/core: remove nr_accesses_bp setups and updates"
        Link: https://lore.kernel.org/20260630040812.149729-14-sj@kernel.org
    "mm/damon/core: remove attrs param from damon_update_region_access_rate()"
        Link: https://lore.kernel.org/20260630040812.149729-15-sj@kernel.org
    "mm/damon/paddr: remove attrs param from __damon_pa_check_access()"
        Link: https://lore.kernel.org/20260630040812.149729-16-sj@kernel.org
    "mm/damon/vaddr: remove attrs param from __damon_va_check_access()"
        Link: https://lore.kernel.org/20260630040812.149729-17-sj@kernel.org
    "mm/damon/core: remove damon_moving_sum() and its unit test"
        Link: https://lore.kernel.org/20260630040812.149729-18-sj@kernel.org
    "mm/damon/core: remove damon_region->nr_accesses_bp"
        Link: https://lore.kernel.org/20260630040812.149729-19-sj@kernel.org
    "mm/damon: add damon_region->last_probe_hits"
        Link: https://lore.kernel.org/20260703170605.94472-1-sj@kernel.org
        Link: https://lore.kernel.org/20260703170605.94472-2-sj@kernel.org
    "mm/damon/core: introduce damon_probe_hits_mvsum()"
        Link: https://lore.kernel.org/20260703170605.94472-3-sj@kernel.org
    "mm/damon/sysfs-schemes: set probe hits as pseudo moving sums"
        Link: https://lore.kernel.org/20260703170605.94472-4-sj@kernel.org
    "mm/damon/core: safely validate src on damon_commit_ctx()"
        Link: https://lore.kernel.org/20260705155600.96555-1-sj@kernel.org
        Link: https://lore.kernel.org/20260705155600.96555-2-sj@kernel.org
    "mm/damon/core: do parameter testing commit on damon_start()"
        Link: https://lore.kernel.org/20260705155600.96555-3-sj@kernel.org
    "mm/damon/sysfs: remove duplicated commit input validity check"
        Link: https://lore.kernel.org/20260705155600.96555-4-sj@kernel.org
    "mm/damon/reclaim: remove duplicated min_region_sz power of 2 check"
        Link: https://lore.kernel.org/20260705155600.96555-5-sj@kernel.org
    "mm/damon/lru_sort: remove duplicated min_region_sz power_of_2() check"
        Link: https://lore.kernel.org/20260705155600.96555-6-sj@kernel.org
    "mm/damon: document region size validation in damon_set_regions()"
        Link: https://lore.kernel.org/20260705155600.96555-7-sj@kernel.org
    "mm/damon/core: remove start, end check in damon_set_region_system_rams()"
        Link: https://lore.kernel.org/20260705155600.96555-8-sj@kernel.org
    "mm/damon/sysfs: remove region size validation"
        Link: https://lore.kernel.org/20260705155600.96555-9-sj@kernel.org
    "mm/damon/core: stop ctxs in damon_start() before returning an error"
        Link: https://lore.kernel.org/20260706140628.87414-1-sj@kernel.org
        Link: https://lore.kernel.org/20260706140628.87414-2-sj@kernel.org
    "samples/damon/mtier: do not stop first context for damon_start() failure"
        Link: https://lore.kernel.org/20260706140628.87414-3-sj@kernel.org
    "mm/damon/core: make damon_stop() never fail"
        Link: https://lore.kernel.org/20260706140628.87414-4-sj@kernel.org
    "mm/damon/sysfs: ignore damon_stop() return value"
        Link: https://lore.kernel.org/20260706140628.87414-5-sj@kernel.org
    "mm/damon/reclaim: ignore damon_stop() return value"
        Link: https://lore.kernel.org/20260706140628.87414-6-sj@kernel.org
    "mm/damon/lru_sort: ignore damon_stop() return value"
        Link: https://lore.kernel.org/20260706140628.87414-7-sj@kernel.org
    "mm/damon/core: change damon_stop() return type to void"
        Link: https://lore.kernel.org/20260706140628.87414-8-sj@kernel.org
    "samples/damon/mtier: stop all contexts with single damon_stop() call"
        Link: https://lore.kernel.org/20260706140628.87414-9-sj@kernel.org
    "mm/damon/core: wait ctx stop in damon_call() before reruning an error"
        Link: https://lore.kernel.org/20260706140628.87414-10-sj@kernel.org
    "samples/damon/wsse: do not stop ctx for damon_call() failure"
        Link: https://lore.kernel.org/20260706140628.87414-11-sj@kernel.org
    "samples/damon/prcl: do not stop DAMON for damon_call() failure"
        Link: https://lore.kernel.org/20260706140628.87414-12-sj@kernel.org
    "mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero"
        Link: https://lore.kernel.org/20260708135359.122587-1-sj@kernel.org
        Link: https://lore.kernel.org/20260708135359.122587-2-sj@kernel.org
    "mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/"
        Link: https://lore.kernel.org/20260708135359.122587-3-sj@kernel.org
    "mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/"
        Link: https://lore.kernel.org/20260708135359.122587-4-sj@kernel.org
    "mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/"
        Link: https://lore.kernel.org/20260708135359.122587-5-sj@kernel.org
    "mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/"
        Link: https://lore.kernel.org/20260708135359.122587-6-sj@kernel.org
    "mm/damon/core: update probe hits for new parameter commit"
        Link: https://lore.kernel.org/20260708135359.122587-7-sj@kernel.org
    "mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()"
        Link: https://lore.kernel.org/20260708135359.122587-8-sj@kernel.org
    "mm/damon/core: introduce damon_probe->weight"
        Link: https://lore.kernel.org/20260710134651.18084-1-sj@kernel.org
        Link: https://lore.kernel.org/20260710134651.18084-2-sj@kernel.org
    "mm/damon/core: ask apply_probes() ops callback to set sampling address"
        Link: https://lore.kernel.org/20260710134651.18084-3-sj@kernel.org
    "mm/damon/paddr: set samples in apply_probes() if requested"
        Link: https://lore.kernel.org/20260710134651.18084-4-sj@kernel.org
    "mm/damon/core: ask apply_probe() to return max probe hits weighted sum"
        Link: https://lore.kernel.org/20260710134651.18084-5-sj@kernel.org
    "mm/damon/core: implement damon_probe_hits_wsum()"
        Link: https://lore.kernel.org/20260710134651.18084-6-sj@kernel.org
    "mm/damon/paddr: respect return_max_wsum"
        Link: https://lore.kernel.org/20260710134651.18084-7-sj@kernel.org
    "mm/damon/core: use abs_diff() instead of abs()"
        Link: https://lore.kernel.org/20260710134651.18084-8-sj@kernel.org
    "mm/damon/core: extend merge function to work with probe hits"
        Link: https://lore.kernel.org/20260710134651.18084-9-sj@kernel.org
    "mm/damon/core: disallow probe_hits overflow on attrs only monitoring"
        Link: https://lore.kernel.org/20260710134651.18084-10-sj@kernel.org
    "mm/damon/core: validate params for probe hits weighted sum overflow"
        Link: https://lore.kernel.org/20260710134651.18084-11-sj@kernel.org
    "mm/damon/core: disable access monitoring when probe weights are set"
        Link: https://lore.kernel.org/20260710134651.18084-12-sj@kernel.org
    "mm/damon/core: set samples in apply_probes() if probe weights are set"
        Link: https://lore.kernel.org/20260710134651.18084-13-sj@kernel.org
    "mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()"
        Link: https://lore.kernel.org/20260710134651.18084-14-sj@kernel.org
    "mm/damon/core: get merge threshold from probe hits when weights are set"
        Link: https://lore.kernel.org/20260710134651.18084-15-sj@kernel.org
    "mm/damon/core: implement damon_has_probe_weight()"
        Link: https://lore.kernel.org/20260710134651.18084-16-sj@kernel.org
    "mm/damon/sysfs: implement probe/weight file"
        Link: https://lore.kernel.org/20260710134651.18084-17-sj@kernel.org
    "Docs/mm/damon/design: document attrs-only monitoring"
        Link: https://lore.kernel.org/20260710134651.18084-18-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: document weight sysfs file"
        Link: https://lore.kernel.org/20260710134651.18084-19-sj@kernel.org
    "Docs/ABI/damon: document probe weight file"
        Link: https://lore.kernel.org/20260710134651.18084-20-sj@kernel.org
    "mm/damon/core: skip aging from repeated aggressive merging"
        Link: https://lore.kernel.org/20260712165432.87609-1-sj@kernel.org
    "mm/damon/core: hide private damon_region fields"
        Link: https://lore.kernel.org/20260714143544.101305-1-sj@kernel.org
        Link: https://lore.kernel.org/20260714143544.101305-2-sj@kernel.org
    "mm/damon/core: hide private damon_target fields"
        Link: https://lore.kernel.org/20260714143544.101305-3-sj@kernel.org
    "mm/damon/core: hide private damos_quota_goal fields"
        Link: https://lore.kernel.org/20260714143544.101305-4-sj@kernel.org
    "mm/damon/core: hide private damos_quota fields"
        Link: https://lore.kernel.org/20260714143544.101305-5-sj@kernel.org
    "mm/damon/core: hide private damos_filter fields"
        Link: https://lore.kernel.org/20260714143544.101305-6-sj@kernel.org
    "mm/damon/core: hide private damos fields"
        Link: https://lore.kernel.org/20260714143544.101305-7-sj@kernel.org
    "mm/damon/core: hide private damon_filter fields"
        Link: https://lore.kernel.org/20260714143544.101305-8-sj@kernel.org
    "mm/damon/core: hide private damon_probe fields"
        Link: https://lore.kernel.org/20260714143544.101305-9-sj@kernel.org
    "mm/damon/sysfs: do not directly access damon_ctx->ops"
        Link: https://lore.kernel.org/20260714143544.101305-10-sj@kernel.org
    "mm/damon/core: hide core-private damon_ctx fields"
        Link: https://lore.kernel.org/20260714143544.101305-11-sj@kernel.org
    "mm/damon/core: avoid infinite kdamond_merge_regions() internal loop"
        Link: https://lore.kernel.org/20260715031002.108504-1-sj@kernel.org
        Link: https://lore.kernel.org/20260715031002.108504-2-sj@kernel.org
    "mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()"
        Link: https://lore.kernel.org/20260715031002.108504-3-sj@kernel.org
    "mm/damon/vaddr: drop last same folio access check optimization"
        Link: https://lore.kernel.org/20260715031002.108504-4-sj@kernel.org
    "mm/damon/paddr: drop last same folio access check reuse optimization"
        Link: https://lore.kernel.org/20260715031002.108504-5-sj@kernel.org
    "mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()"
        Link: https://lore.kernel.org/20260715031002.108504-6-sj@kernel.org
    "mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()"
        Link: https://lore.kernel.org/20260715031002.108504-7-sj@kernel.org
    "mm/damon/core: initialize damos->last_applied"
        Link: https://lore.kernel.org/20260718001442.87129-1-sj@kernel.org
        Link: https://lore.kernel.org/20260718001442.87129-2-sj@kernel.org
    "mm/damon/core-kunit: check region count before testing in split_at()"
        Link: https://lore.kernel.org/20260718001442.87129-3-sj@kernel.org
    "mm/damon/vaddr-kunit: check region count in three_regions test"
        Link: https://lore.kernel.org/20260718001442.87129-4-sj@kernel.org
    "mm/damon/core-kunit: handle region split failure in filter_out()"
        Link: https://lore.kernel.org/20260718001442.87129-5-sj@kernel.org
    "mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()"
        Link: https://lore.kernel.org/20260718001442.87129-6-sj@kernel.org
    "mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()"
        Link: https://lore.kernel.org/20260718001442.87129-7-sj@kernel.org
    "mm/damon/core-kunit: skip wrong region walk in commit_target_regions()"
        Link: https://lore.kernel.org/20260718001442.87129-8-sj@kernel.org
    "mm/damon/ops-common: use nr_accesses moving sum for quota score"
        Link: https://lore.kernel.org/20260719161136.90191-1-sj@kernel.org
    "mm/damon/core: handle region split failure in apply_min_nr_regions()"
        Link: https://lore.kernel.org/20260719155442.88794-1-sj@kernel.org

Stanislav Kinsburskii <skinsburskii@gmail.com> (2 total)
    "mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support"
        Link: https://lore.kernel.org/178413936536.1155966.8918127042760531802.stgit@skinsburskii
    "selftests/mm: add HMM test for mmap lock-dropping faults"
        Link: https://lore.kernel.org/178413937354.1155966.16649896548407894107.stgit@skinsburskii

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com> (1 total)
    "lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone"
        Link: https://lore.kernel.org/178294308408.327222.3319445682023999403.stgit@skinsburskii

Sourav Panda <souravpanda@google.com> (1 total)
    "mm/hugetlb_cma: support percentage-based hugetlb_cma reservation"
        Link: https://lore.kernel.org/20260628190155.3655895-1-souravpanda@google.com

Hajime Tazaki <thehajime@gmail.com> (3 total)
    "mm: nommu: add sysctl_max_map_count() check for do_mmap()"
        Link: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/munmap/munmap04.c
        Link: https://lore.kernel.org/20260702012830.667205-1-thehajime@gmail.com
    "mm: nommu: point to the write iterator upon split_vma"
        Link: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/mseal/mseal02.c
        Link: https://lore.kernel.org/20260702012546.665383-1-thehajime@gmail.com
    "mm: nommu: fix the error path when vma_iter_prealloc() fails"
        Link: https://lore.kernel.org/20260708083829.576036-1-thehajime@gmail.com
        Link: https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime%40gmail.com
        Link: https://sashiko.dev/#/patchset/c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime%40gmail.com
        Link: https://sashiko.dev/#/patchset/20260707235137.498738-1-thehajime%40gmail.com

Thomas Huth <thuth@redhat.com> (2 total)
    "mm: replace __ASSEMBLY__ with __ASSEMBLER__ in memory management header files"
        Link: https://lore.kernel.org/20260619131830.229804-1-thuth@redhat.com
    "percpu: replace __ASSEMBLY__ with __ASSEMBLER__ in percpu-defs.h header file"
        Link: https://lore.kernel.org/20260619154704.41293-1-thuth@redhat.com

Usama Arif <usama.arif@linux.dev> (2 total)
    "mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix"
        Link: https://lore.kernel.org/e8e1a409-48d8-4fa7-ae98-49485a1607f6@linux.dev
    "condense comment about folio reference"
        Link: https://lore.kernel.org/87bbf335-648f-4065-abc8-3eaab5a3beeb@linux.dev

Vlastimil Babka (SUSE) <vbabka@kernel.org> (1 total)
    "mm: remove the __GFP_NO_OBJ_EXT flag"
        Link: https://lore.kernel.org/20260703-alloc-trylock-v5-16-c87b714e19d3@google.com

Kefeng Wang <wangkefeng.wang@huawei.com> (2 total)
    "mm: mincore: fixup for remove special handling for VM_PFNMAP"
        Link: https://lore.kernel.org/20260720124151.1483820-1-wangkefeng.wang@huawei.com
    "mm: mincore: fixup improve mincore_hugetlb()"
        Link: https://lore.kernel.org/20260720124252.1483984-1-wangkefeng.wang@huawei.com

Yijia Wang <wangyijia.yeah@bytedance.com> (1 total)
    "selftests: mincore: count file-mmap readahead on both sides"
        Link: https://lore.kernel.org/20260713094319.771550-1-wangyijia.yeah@bytedance.com

Matthew Wilcox (Oracle) <willy@infradead.org> (1 total)
    "mm: add writeback.h to docs build"
        Link: https://lore.kernel.org/20260615162244.2170866-1-willy@infradead.org

yahia ahmed <yahia.a.abdrabou@gmail.com> (1 total)
    "mm/shmem: fix data-race in shmem_fault"
        Link: https://lore.kernel.org/20260630120222.11562-1-yahia.a.abdrabou@gmail.com

Zhen Yan <yanzhen20011121@163.com> (1 total)
    "mm: fix mapping_seek_hole_data() overflow on last page"
        Link: https://lore.kernel.org/20260630125047.703170-1-yanzhen20011121@163.com

Youngjun Park <youngjun.park@lge.com> (1 total)
    "mm/swap: clarify unreachable cond_resched() in swap_reclaim_full_clusters"
        Link: https://sashiko.dev/#/patchset/20260713025644.170839-1-youngjun.park@lge.com?part=4
        Link: https://lore.kernel.org/20260713045014.219653-1-youngjun.park@lge.com



