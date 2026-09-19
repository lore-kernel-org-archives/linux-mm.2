Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2766AC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C946B0088; Sat, 19 Sep 2026 03:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A67B6B008A; Sat, 19 Sep 2026 03:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049956B008C; Sat, 19 Sep 2026 03:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C73CF6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:31:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF4751C1951
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:31:42 +0000 (UTC)
X-FDA: 85229692044.11.E3BAF4F
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0452480003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:31:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lBqSQVur;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lBqSQVur;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789803101;
	b=I4NzPSw8RvlZLr5h2ozdWD7n1mDfnK08FQS+m6rruMsVrDmtkx5oQHs4r8O92y9Vko+JH1
	X91646JflFB+7/lJhwu+li/kMoxi8vra/ahDn18dzKclgO/dgMOaE7RiO+6+2mI9UWboL1
	jj5UTCTsUWWQEg6yOOuMgvjZB3EJefA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789803101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgex21lQm0G61YS9FJDDkISfh7R3E5d66BHmejgp1dg=;
	b=qy8xocROwivCb/OAp2IdR1v/6Q8ShnVZh8iRSCXWuAyhpxyamulJPwvk1owRU7M3gyl8MM
	zZ/HRp4MGNtuVln0HqcjVtp8OTdxbzwepJB6IjsUdOAYCg9NgEtS65kmyDUGr7cS3zy51+
	LascViUUdRNZ/FqIuOdgDTKkcIE7hDU=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea34ef4so1630659a12.3
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789803100; x=1790407900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hgex21lQm0G61YS9FJDDkISfh7R3E5d66BHmejgp1dg=;
        b=lBqSQVurL1coWDva4SRKKppg+JgTUp1QGGnwxhHCEsfdCr1y7LQdEXcod7aGzL+488
         Zqs/EqdTYWSY4AYGoniCOlBxX6b9yYOD6b1GBEgWfqHEZnwzaSPoOftbK12oMf/grH9f
         nxw8DQHwjy2MQobIHAuJMwuX3bwct4KDFfFXOuJ6szFn+t9QSqur+QqG5iqB6GAXDTWF
         VyV6j9wiFAvwi0bvBcQcMPn0XVAOfHG2cjmW8QgqJv0WhlNHrPMw9IQNntDVO3v0AdK8
         cxa8H9CI9u2cH8dePYp+Ooxhk9qe7qV1fUOgx3UQbQoHuEtJ5QhmSaDnY5XJgGS0hDSI
         mPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789803100; x=1790407900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hgex21lQm0G61YS9FJDDkISfh7R3E5d66BHmejgp1dg=;
        b=ZSQmnAfMECVFuReG2UlUgAPwQtKOw804SDlcMWgsv2Bb3jHzWMeE6mCQx3AtX3EgXw
         n0uY6b0N+g0woX9T2DU+SX/9RU1a/ubRJDWK3e+ArE+Od2+No8ut8mtwIuLFj5ZWLcc6
         EHX/KSEy29QpNPLBxpC6TN3AgVolgyv+FjKA99TYCxDAplwXZVlRHBRvesRW210tMACw
         EptuGV/dk95FtRhH4mrbhF7u7etKsVjBkN/mSxwb/FK1KEVvsRFzMXrO2RE7Q5OdZh2+
         50HxOYXzk/EsM9wM9KodzHnr9DAdtzIPqp4XYD/A1+RHw9E9hNM29qe1oy6Fypa3gEp+
         rR+g==
X-Forwarded-Encrypted: i=1; AKwUvBz4f14jy1IZke+vHtTzQvoTAdY8CQlgYWheU7ySGxFipMdFU1oGhT9lsEnqlJGrHrxNZL7Ye4nb9g==@kvack.org
X-Gm-Message-State: AFuF++kNRnf6I9GwQ+CGkgs7kfwTQXqvJMWe5pvP9X1XguPPhv2O10Sw
	ATtbXAI8V0i5jpebsPbpSu9v9qNBhx2b28AK/7lzr0WOxlo6I6s7VyMDA0BfJ/8P2wQ=
X-Gm-Gg: AYBFou1YhTUaiOT8v7/wn+aikjVRAKBcf0J/dXX+bcBQXcHAXQm2BmXLaqan/11EqdP
	IeKgYW5+pfukW4/pDbeGs3cCpF1T0qruPCiokQwTfIo9FIQBGhUaOxkytUvl1sV3qwt2FfafNfU
	FhbDqzlZMrtF+Fgsr2Hztwa05fX7y61GhgsQtsWsIEtdGYH4/29diz2OI+5jCJl4gYUYnxXSGl9
	+BbGZWlyyAj9lGdMXq9yjLot20s3VRq7KdqCGovezegCGNeHrzHhmPbl6R8xiplij9cx9/KHs8Y
	PhEiIQZZNV6mO59EMbBGhjqt/ZUErfDEGiajvRSAZWmhoskFXthH692tWtlYW9xchrUVeZZsMzf
	IpoPYzLuJQsamM9QvkwWsx8ddFR2yGhBcOstm+FdI7f1bTOcwfThW/yW7aCkXP3mgE4KSIKTp/D
	v5UD+haHh9JMycXZLx6IColnHdmjb//G1qdBFLCgT/LQs8AbxYvQrOQG8LFPzOT0l7wcqRKSqu4
	4WOrR6m7ioXdhrnKfFrDj2XpsHyptZtzst58AsaAdJkSYYPSwAcziwgaSs0jkW/vTY8rftDSPVt
	3i24B3D53UZA0Sh5f1G5nkvMUA==
X-Received: by 2002:a05:6a20:c901:b0:3dd:a197:edee with SMTP id adf61e73a8af0-3dda197f7b9mr2964150637.61.1789803099724;
        Sat, 19 Sep 2026 00:31:39 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-198-121.dynamic-ip.hinet.net. [36.232.198.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72ae9e9c8sm654498a12.17.2026.09.19.00.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:31:39 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/memory: reuse the whole exclusive large folio on a write fault
Date: Sat, 19 Sep 2026 15:31:31 +0800
Message-ID: <20260919073134.639-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918064238.868-1-aa9736195201@gmail.com>
References: <20260918064238.868-1-aa9736195201@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0452480003
X-Stat-Signature: 1oujwdbfdxyqogs4pj7t6d6ojxwfa4hx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789803100-25711
X-HE-Meta: U2FsdGVkX19idLb5bXOA6P6maOjYsio4E9X4qz/pzeScfBphG4eH7cBcZMEUofNG8cz4hOQCXKAtXvWCyqszu/pn3/Tu/4XN7uWYNijrAh5GD9+28lcjJoj6b7xwpTzXdGrTQGTqoEjAp9RIN5+YKFD0ZwkBVCe+k7qOn8ekW4XxwbnSuDD0TFdaDCMEYMMvA+xm9/Wo3qDrOe1m4i+9E+1yY+CtZ4x0FeT31Hvh7QhllLedSiH8/PBNc5NpoRKyqCi8ncreeAyb1OR/F/zMDvKFc/ux5MXrOjiUkYidghaZzMleSAAqM4AvHKDlt355EPsA8HV3sY/BwRcJnf4Tha3p1YcejfFa3Ux6oeW/ZIgub6dH7lg6ffCxtkPmiKWJVz0iY3v2VkcspS2Xa8I+FScAyiS6y6LhchaJmdEmhvgGjXeeKwwEPYe/ICCGByiLuGyDdPwQe1iHPvVkMom90QcbrZocVZ/LhEbFiCSZ5HXzuJuqYfaIsldC7Fi0LOEhSakTh35y6s1EN9ldHez5jvtXiMJuSYrvqtXbegZbivfMwM8wR15Pe4pYgJVWD8zZoD1q1mcxIeT/7Q3waEFV9ENV5QJw87jWyFEpCMrC7xYKeipIMhBjrXQJ4C7QMGqG5NBmMNdsY4acFfrESy7tNFoW/ROLQ0wwLpeRJ5CrLzCvps8uuC+g+IhubuuSsBOy27AkSy+dP7/FYvv7pXwXM12S+8EFZjfh9l0+diinaGfm4G5jWTNyx7+5++vzwuaIREIDc8uDi4YGGNp/kUulsJLbKYnkHtzHriaj6XhW7NLnBsX9FavIiuvaY+/HkL7g0a1QjDju4O/lA8Vn8YbFOfILir3ldS/uT8diVBoC8HOARC5EzKKxYB0T7DhRwww708NQd2+9H22xvZ9QP0PnXrqE1qPwcvAjYwUEey7tGTdUz4kez1vfBJ6n7KiSidnysNXFHXNHYb0o/hK+jyb
 DtCjkkuh
 9O2YST53brRBCtK9RVuHTaGEwEZholVMO3wmJJx+HakzKhkous2meYEORWCAJuG5wkVJjIPwDsrl5gUXdUX3B7v1R4D2d690HCZrgluuu5iolWE3HC0IQ88vnrYQ73snMtpolX/j5xMeLpeN5HVV4NPzx39Aj3oo8RjsXeuMCYef+vzTCn5Wm7uDUxn5FJglJCoM4RSZmZhtjSob9GDbYOJgCFqEJWOkbAJciY5xeCgif/KvG52KB3Gx0WvaQUparzV5pgOlFiYt+Z1t4HPRx1GkPXmIQt2/nr0kLfmMdnfae+951RIGcgwA3DRZ8+B7oK6IFmmAy/xAR76MlHSzGc8UHRJDXYK2Lihgs1do+jRQQGLjCbZRSUqzbTQI7qKdJ7HO809Y6Aq/uqD/YBogw4uhG68P55vT0D04O9TK7NQQp6OyoqCR/0P4xtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After fork() and the child's exit, the parent's write faults reuse a
large anonymous folio one PTE at a time, although
wp_can_reuse_anon_folio() has already found the whole folio exclusive.

v2, after the comments on v1 [1]:
- Split in two.  1/2 handles an aligned block of 16 PTEs around the
  fault, the contpte-sized version David was fine with in the 2024
  discussion of Barry's RFC [2].  2/2 lifts that to the folio.
- The earlier discussion is linked; the changelogs say how its two
  reservations, the latency of the individual fault and how far to go
  around it, are answered.
- The bound of the walk is spelled out (Barry): folio, VMA and block or
  page table, each PTE read once by folio_pte_batch_flags().
- Changelogs cut to what is needed to judge the change.
- Same base as v1; 1/2 + 2/2 is the code of v1.

Two points from the AI review of v1, both done as mprotect() does them:
change_pte_range() does not flush_cache_range() before making PTEs
writable, and it makes clean exclusive anonymous PTEs writable without
pte_mkdirty() (the dirty rule is for shared file mappings, see
can_change_shared_pte_writable()).

Controls, unchanged: order-0 pages, PMD-mapped THPs, the COW copy path
and the order-0 and cow/fork/write-fault modes of David's
pte-mapped-folio-benchmarks.

What does not get faster on x86: stores to pages this CPU still holds
a read-only TLB entry for.  The fault makes the PTEs writable but, like
mprotect(), does not flush, so such a page takes one spurious fault,
about the cost of the reuse fault it replaces.  That is the case for
pages read since fork(), and for a loop that only stores one byte per
page in ascending order (David's reuse-byte mode): the CPU runs the
next stores speculatively while the first one faults and caches their
read-only translations.  Shown with kprobes (135,687 handle_mm_fault()
for 8,457 do_wp_page()) and an LFENCE after every store (4,100 faults
instead of 65,400); the untouched PMD-mapped case behaves the same.  A
flush_tlb_local() in the helper would fix it (that loop 28 -> 4 ms,
memset() 38 -> 21 ms, +140 ns per fault), but generic code has no way
to ask x86 for a flush that stays on this CPU, so that is for later.

Tested with DEBUG_VM, DEBUG_VM_PGTABLE, PROVE_LOCKING and
PAGE_TABLE_CHECK_ENFORCED: the mm selftests, a 12-scenario COW test
(child alive, vmsplice, PROT_READ VMA inside the folio, soft-dirty and
uffd-wp counts, mremap, holes, pageout, FOLL_FORCE), a
fork/pageout/mprotect/vmsplice stress, NUMA balancing on numa=fake=2
(protnone PTEs left alone), and arm64 under QEMU for the counters.
Cross-built for arm64 4K/16K/64K, i386 with and without PAE, x86
without THP, arm, arm nommu, riscv64, powerpc64le and s390x.

[1] https://lore.kernel.org/r/20260918064238.868-1-aa9736195201@gmail.com
[2] https://lore.kernel.org/r/20240831092339.66085-1-21cnbao@gmail.com

Yuan-Hao Hsu (2):
  mm/memory: reuse 16 PTEs of an exclusive large folio on a write fault
  mm/memory: reuse the whole exclusive large folio on a write fault

 mm/memory.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)


base-commit: 238650ef6c7c7cca08e032527329424c9fbd70e5
-- 
2.43.0


