Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93378C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 22:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F0B6B008A; Mon,  3 Aug 2026 18:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606816B0093; Mon,  3 Aug 2026 18:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC926B008A; Mon,  3 Aug 2026 18:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCF16B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:17:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D0791A083C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:17:43 +0000 (UTC)
X-FDA: 85061371206.23.76F6984
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id E7AD520006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:17:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SidHXcqI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3hBNxagcKCMk46p81p0v33v0t.r310x29C-11zAprz.36v@flex--pratmal.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3hBNxagcKCMk46p81p0v33v0t.r310x29C-11zAprz.36v@flex--pratmal.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785795461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAWFWvnBUh9ir1S9XV305sn5ZoY+nCCz6Prdpi+wHYw=;
	b=rmttM1Ok3AU0lkVQ7xhZrQ7/hKYta0Xr8Mpr+nkOOzWSWz8dka6EDk0eZPpf5zNafWRVTr
	asH7Psr4lIg3bbCrLzjHKyu13BIXwmtAwUPG8i7uu2lLSCz0bD1Omug9QEp2P/GuyPZhdV
	FMJ1+wgk3EOk82DIYJTkWBEQuN0NVDA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SidHXcqI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3hBNxagcKCMk46p81p0v33v0t.r310x29C-11zAprz.36v@flex--pratmal.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3hBNxagcKCMk46p81p0v33v0t.r310x29C-11zAprz.36v@flex--pratmal.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785795461;
	b=ZSP91JZB51PmDrjYCHwkA3iv+1yra3tV7iv+HAbt068mZCnDxhyD7u6fglFJeemTyGX7gX
	G8ugXzQeyYRkH2+WRbzchVFpwVnqtpN2AMBMkvaAVkVghQGEZrs8EafWnp8CuLPJHMgW8J
	+MTBuCSFEF74fx9FbDVPLn51VVYTOSg=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb74d5db64eso4718532a12.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 15:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785795461; x=1786400261; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TAWFWvnBUh9ir1S9XV305sn5ZoY+nCCz6Prdpi+wHYw=;
        b=SidHXcqImzAn/1BBUOGoEvgM0U2wJGCE5TeDDTZUPDptoqGvj4pfBn6GwLSBEVQWX1
         o3lGBejxCRcJ38XmHUGD9mx8hSkrBKbaavy9sh8Hw9mKpePu9UvYAJtBPqQE3h7MFqmo
         7HOeFE4arAAmpoVtrY+FZWCqm6aMoAQRXHpt/p3GSIesLXuXUHBUGelUSeQPpbyc6aH2
         ktg0w4jOIy6xkFl5d6w37GSOiVWGvIbPdMoNnI8dbtNR+X8eVwQI4eT5abjsBk1NtgKK
         Ot5PHO/t/iNN7iNovRYNnbiN9k4+klnkUKU8gv77zkqa9p1cMx5XUXet3GjGmXUYJ+cd
         QlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785795461; x=1786400261;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TAWFWvnBUh9ir1S9XV305sn5ZoY+nCCz6Prdpi+wHYw=;
        b=dFXn22kBblELNZH1taLWaFKbFKN4fljX4sIOpFXL9vgHD6S1EvEsS4ncvPXAkBkGuS
         qxDbHsgVH4T1rKSbGBf5PJRsPriAGcsG7UBuo5Mqe6qpbId+F19lyWszC7LXIs1qNbfv
         RNERPg2EO/SsVN5wMol1YvPGBprZRvxJ5kZh8OahUzCCCdzmkzW83imBCA/wz6InK8aC
         2uDR5zfiKgTFsKWpxsE8/duC+mAVMIJ17cB02oVQZJfe7XETrf/qGaWCYHVoyGwzqOxc
         f0Rj5xXjo2/YIcGXZ52H1/e5rNtuNv+TGvo6H/jgLOr2yD/bGtdaDkDnrVOFHhI8xkwK
         nLFQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr7z/iKelQvDODticqjI2tRY1rmTCJ+BdWpLUGWUa1Hegbf0IE+gYKot2jtP4BIo0f1iPHZacIVgQ==@kvack.org
X-Gm-Message-State: AOJu0YxiBzT5TgPqpi/dLHsldP8FDbnAdEk1Hqa6usUMt0Hh6dlr17mB
	q47mheBQm4yRwHiOQx9FkkFqGc99Q5sOdgWyxeOr7vZe5AKFvQG66MEv+BgHyQcAOteRHP5W/h0
	6Q6cgBqzxow==
X-Received: from dybb26.prod.google.com ([2002:a05:693c:609a:b0:30e:953c:b434])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7a95:b0:3c1:85d:fa2f
 with SMTP id adf61e73a8af0-3c92a89c7bbmr13299159637.36.1785795460577; Mon, 03
 Aug 2026 15:17:40 -0700 (PDT)
Date: Mon,  3 Aug 2026 22:17:32 +0000
In-Reply-To: <20260803221732.3651981-1-pratmal@google.com>
Mime-Version: 1.0
References: <20260803221732.3651981-1-pratmal@google.com>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260803221732.3651981-3-pratmal@google.com>
Subject: [PATCH v4 2/2] selftests/mm: use pattern matching in .gitignore
From: pratmal@google.com
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wdrd8tbdicoadma4i8khwkmhahys7ju3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7AD520006
X-Rspam-User: 
X-HE-Tag: 1785795461-43114
X-HE-Meta: U2FsdGVkX19KrMEPcWE6gacR5KR33wMOj1hcUn74/oLZJ2QvuaAfNG9Iziy3gNRKcQc+xTKUWiKL1FZHYkpPEPapvJhrJR0ZslTW2xqI7gzWE5vp+/KbzKKkYSJ4m38XiOnGQUx+uReItrpTgqjOlbXUfakkRGPJh9JwrWGNL1+rInTkFx79S54Hj86o9HzOOmmrpizfGdJ20f28oAL79eGnkcocrnflugfXcxs8ygagbP11ciVEGcJYiPt5axu4jMsF2vAYlU4TFp98nB+Ff/nLQfdonB758ERFzkPh4hDVl6irWmrrj99Sl9bPngKoT4UDgkTub952+O7b+vqQA+T0dXalUGlhIfgEb/KbhYAnRlH/zHJkDa8bjQxTULPFsj3WzK9gyAX4ePdOAL4hYhdEXDDiou/ScZMLOiSruyA1MRm+Ub/+8LMLMjvHK8f1L+up/uER0B5KgIbsN+18VliWZIZQn3eRkJm18NaRIyA0dlXRrzjfrfNHNs72QyIUY/cYuOHgFN5kphgsdupphhRHKzU+cttuNSELk9ofurC+3Q66IDGkYvmH5mrAvonrJJvDUu3fCXcsqcYrOiy5Uw65aA5e1wnEYwy7owJtGNgcFuR3QwQciowE5f8DLaYvk/fM/e5Qb4PVC0bTmWRk+jFQnMV9Kz6scBGtv3b/VZ4I9d5+v0Z1T6jbMbLzZ1GZLKT4H3i7A2uhHCZ7MVWkErMYlWT2RivB5QYW4uQnjGXW+kgOHOPzSoNDt+EQEGs9ZXCVsj5mXZrtM7C/i0gc23aSp3oP/M/Qb7QzWMj0h5ynI+1CEDEkV9m29eu/ZL6ZUgPVvIXsNQxGE7wDm/Y6qiqqqQtpO+OSXWJmDyeetrNQ1yOE71P+aTB82kSa/rKoO+86q9ML60GWjT+or4295V/TXFcN5/BHonxsG3ibR0K6oBJyn8v+2IYyrO7hiCMARkoXfG2XqezIHlnRaB4
 Jut5RcAa
 M3F+DImZ5WKblcgKTfUGXu62umg2ZcWhRRbvGhBZfdOti2zCMSlctBii0FYc2PwMIjpq7jnynY2zNOKw72qPEP9mi9qyU4TYJNLMmNe/anLt1qhMbZW7cBlC9W725XiGZEk8uHNe8oeienR/o4CZnEcBgm+l7SC0wVIhL/r26ouZ89IxLwuW6lFZV7RKp2iXPBy1j6YeyJd/LsbJ8F7p6m9rIJzFk4kwV3PdPTZxpZZF7ZPwLn0vmen0+wlzs99qXdw6I0NEVtVry87SzYAUJ7U93gvHKPbfrlWoxoqwoCr2Xjtcg0Io1LuB1X9q6mibtk422w6PQVTtbo9dl74HfShqvojQZMYHIyxYlK1/yHRICuuZgniXqTsdlthAI+H+S8HEhjx7Gi9mGPbCYPwoV8ESqhEZ6mJ29VLFpQ9RZ0kqwpP9MbzIgb5lhNGv5mIK4hRqhqEcrQ7+jKDDrztN/kaWS8itxTAtnuKvoQBgOPZM6Nc/8RtwWTwQUUWh9dYtAJgQIlHTyM4+ceCiC6ewLvMxI+AQdouQftlB5Vmtz2z5mReLFzIa1JAkZYvyqcmuB1t9qjhJ19PZ9UJS9oPf+avVOJwi7SpF272dwaTKVs+a/XADUNIhCA5qFNkgvOpayMfuUTjTPGK/FjC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

The current .gitignore hardcodes each generated test binary by name,
requiring updates every time a new test is added.

Switch to the pattern-matching approach similar to KVM:selftests.
Ignore everything by default and then allow source extensions (.c, .h, .sh)
and tracked non-source files.

Note that local_config.h was renamed to local_config.h_gen in a previous
patch so that un-ignoring *.h files does not cause generated build
artifacts to become untracked.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
 tools/testing/selftests/mm/.gitignore | 71 ++++-----------------------
 1 file changed, 9 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 83ad9454dd9d..fcd892ed21e3 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -1,63 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-cow
-hugepage-mmap
-hugepage-mremap
-hugepage-shm
-hugepage-vmemmap
-hugetlb-madvise
-hugetlb-read-hwpoison
-hugetlb-soft-offline
-khugepaged
-map_hugetlb
-map_populate
-thuge-gen
-compaction_test
-memory-failure
-migration
-mlock2-tests
-mrelease_test
-mremap_dontunmap
-mremap_test
-on-fault-limit
-transhuge-stress
-pagemap_ioctl
-pfnmap
-process_madv
-*.tmp*
-protection_keys
-protection_keys_32
-protection_keys_64
-madv_populate
-uffd-stress
-uffd-unit-tests
-uffd-wp-mremap
-mlock-intersect-test
-mlock-random-test
-virtual_address_range
-gup_test
-va_128TBswitch
-map_fixed_noreplace
-write_to_hugetlbfs
-hmm-tests
-memfd_secret
-soft-dirty
-split_huge_page_test
-ksm_tests
-local_config.h
-local_config.mk
-ksm_functional_tests
-mdwe_test
-gup_longterm
-mkdirty
-va_high_addr_switch
-hugetlb_fault_after_madv
-hugetlb_madv_vs_map
-mseal_test
-droppable
-hugetlb_dio
-pkey_sighandler_tests_32
-pkey_sighandler_tests_64
-guard-regions
-merge
-prctl_thp_disable
-rmap
+*
+!/**/
+!*.c
+!*.h
+!*.sh
+!.gitignore
+!Makefile
+!config
+!settings
-- 
2.55.0.571.g244d577d93-goog


