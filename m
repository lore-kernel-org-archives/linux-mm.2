Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72711C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272CB6B00CD; Tue,  7 Jul 2026 02:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138296B00CF; Tue,  7 Jul 2026 02:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1AA56B00D0; Tue,  7 Jul 2026 02:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAC266B00CD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FA141C7E4F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:46 +0000 (UTC)
X-FDA: 84961037532.30.BEDE5BB
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id A1A561C0009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Po9PYb6U;
	spf=pass (imf21.hostedemail.com: domain of 3459MagsKCK4gcifOjdObROUccUZS.QcaZWbil-aaYjOQY.cfU@flex--souravpanda.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3459MagsKCK4gcifOjdObROUccUZS.QcaZWbil-aaYjOQY.cfU@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mr0Imss8jl6Lql5T0sFpczm9SFtWuez0AZQ8VASrGcw=;
	b=6uItK4R92bZ5CHGf9ZIzaQqJiFbjJP/suCcEbItakuT1g19ptectxiSliTl+shd7BRwyPS
	mMPAM6ROjyjh0kxvoE4N2edEirZtxF9BugMWYNmMzel5OeOoHMcE0buxJdNlt8KczopccS
	shi+P2B9SNRP8ITlHtjcdkgLbah4AY0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Po9PYb6U;
	spf=pass (imf21.hostedemail.com: domain of 3459MagsKCK4gcifOjdObROUccUZS.QcaZWbil-aaYjOQY.cfU@flex--souravpanda.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3459MagsKCK4gcifOjdObROUccUZS.QcaZWbil-aaYjOQY.cfU@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406564;
	b=FN/WCwEAmkMXfhza/rtg04/DQk5YxY97UsP247atprMT7qspJ7xxmbPgbwK8rJGnvNwgVF
	QJC8cGYDM7KhYKd2IZ8UCk+YpwtwBnhK6mKl+0zDeREdy8WZycg3vzadYVAAjFpE2VV+sQ
	jpt42iU7A29xb33YEeSAlVDPvPhXKT4=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-381abcccbf4so2827317a91.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 23:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783406564; x=1784011364; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mr0Imss8jl6Lql5T0sFpczm9SFtWuez0AZQ8VASrGcw=;
        b=Po9PYb6UEejWvMC1Pkav8a1Zo3CxqfDYcc/aBM8pxJcIz53jTYiDzD/8T9bNzzLJi+
         bQGmvHtCD9N8UGrhnY+YORCnnXv0W07aeDP6aIWpmgZ0VHGiU30BPlnqY4D510ZciyLV
         IkINbeW3SXLzfQLfipR/3HlUOFU/OWTUOSBvQKgSHqw4K+JNh2/vaWIEbBJf86JtTE+N
         mUkKVCXUXVkAljQCa5omhU6yl0OSJrRw3DvXQ6bngfIlV4+o8gSOEiouIJCCnIamJHmv
         YoAWWCwZ7+8GZcsMaJOi/fmtyLAIrL8l2yKPRjNL4/UpNtSrM8onoXQtpJuLJWE3OJOM
         OreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783406564; x=1784011364;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mr0Imss8jl6Lql5T0sFpczm9SFtWuez0AZQ8VASrGcw=;
        b=ikh0A6i0n+I56sbQ/19FePgW8WtODjiY2viKGXsoa0dW6BkO4Tnh3yl/6ETrhw93iP
         SzaLx0kNrSRVh5wH/Sqb+W9Zgzlv01qJhUNcvwvZnaEP5AicxKl9lbuymu0D2A+rVJet
         53fxmJIErq/3+bYOBEeduL4pKn59jGC8tjP8uAYcV87++hF29PZADiq035EMWGRFmJYv
         hfHmNqv08vETo+SSlCOeSEyvpj8Mq04jxDFH40JfOGojUxU2fpycuH7rS7F/9whPI9is
         Q88BedF7u0HAFuIocJPbGHcD7D78VZbq3ilNJReZ9MulkeXrzI1y9F7FHDlhwbGR5uYb
         JniQ==
X-Forwarded-Encrypted: i=1; AHgh+RoHOOe6fCJDaBhPg3u5Kq8WnSCyvGonNaQUZYNda0xLhPY1gOZiY4pkT6kE3fF2rQ1q8pUc9o1zSQ==@kvack.org
X-Gm-Message-State: AOJu0YyuXfkyxFC7sc5YRODw+D5Qu2AV++LPLH0BfZEGYRVg84iWA5zu
	YeFop49Tu1+cZ9Q44o0DCY8rNksIMtLCoXf6aWlAUtjhQ6F8f3pJjWduO4jCeU4W1b5xi8tlRC+
	/FulbOHZ9iWxSMcuNMWQdpTdoXg==
X-Received: from pjui23.prod.google.com ([2002:a17:90a:cf97:b0:382:3fe5:7a9b])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:570d:b0:37f:eaf9:4682 with SMTP id 98e67ed59e1d1-3875586394cmr3986337a91.14.1783406563403;
 Mon, 06 Jul 2026 23:42:43 -0700 (PDT)
Date: Tue,  7 Jul 2026 06:42:34 +0000
In-Reply-To: <20260707064235.1386552-1-souravpanda@google.com>
Mime-Version: 1.0
References: <20260707064235.1386552-1-souravpanda@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260707064235.1386552-6-souravpanda@google.com>
Subject: [PATCH 5/6] Documentation/admin-guide/mm/hugetlbpage.rst: document
 cache interfaces
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mst@redhat.com, 
	mhklinux@outlook.com, souravpanda@google.com, fvdl@google.com, 
	gthelen@google.com, mike.kravetz@oracle.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, riel@surriel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1A561C0009
X-Stat-Signature: md77xth9ewzzfi34wwhofccrxqcoq9fq
X-HE-Tag: 1783406564-389488
X-HE-Meta: U2FsdGVkX18+Hlbb6m4D9cDgqPCNBedUvj/tHygzytmmojkr8ctKKQ6vQztag4oFLRQtOZkyTzkP4+fz613KLboJSRtzR/q42mBZVVGpgeiUs2fNY/IWDcLFoV70GuvTevDZEhlyLdFoFv9fQx1Jh1hTBpGMPtj2KYPqDIIKhBhXVa7uOVJPJma/XgghOlBl66q3RtA1d9MeegESYuhGImGGKSRjfQeulfGWUzXmFA2wxMioCiZongBZkCdz9qLaogGibh5xyOorFDI+a6yJliaMeGRkw9LdScNy74Pqcv1/0avIH07lSsLXF99TfYwAfXPuo+VFIkHi8jvQcVjhpm1yGiAOCgmlPVcXGfsLJGShHCHoSSNXqCj03iQ7nn5s2tVH33ZAHcoTbnpp6E2g5mfCTY7bKLCVXCSSZp35SAzNOPIhJWjTzrLpeZQgUVMtASnvVIrgAaMeZ/JW4BsZoBXVsWz5PQSJ6gUxBWka5p9oaZG6RGojcWauIy9XJW5D1lQ2Vl5DPBG/oMnGXacR4VEwatiCuPNQ75Fjyt2n9tCjL/JTitlAHedvLK9tpq1mTzKNzakBjgWKR2D4s1u2AePVYqsyM3TdvRqts7YFgSBUSK+WKkhKSItJ9nW+zhAKajVFwzE+PQb4CJvwPgJVjuDrxNCIIY+7FrOR4UoMpZZN8VwFOP8UZJ/Dn2qJR2eWsTR8EtoeXyL93ELZn3A9M3E+7bCKRbhkN0h8NX5GvPYAfDbggubYnRHJHMOdld2pVCUcThbaPMMbBdObS6OuXKgDmAYg2F5NI+3eU5gunZ/81g+Z8njLDFlxeKLJEkvUhRRNqM4DYkV9KafEpJCzFpbxcCAm4yi0tKuK+yNMw5jvj8iN4r7wsBsdVNnVSM7H0tghJetRlvaC45ZWDrxV2qPayGr/apE35TLFILcyTZd02pvWSwiVDdrAyBNh0pf/fYWiPOhwRdEC/GqAmac
 k2J7WToH
 UtsZtnu4L1u8VjhflaFY8bAG/W53gVKW0NozPHoWaMgeTnDOO10uUs0QACOMXF0m8EL/6H02Ga9mf6fygDbIp4muWxODt1cGL5AhxBvlMGhzyneY6uxvoocPIaJxqc3lMmB43RguB/koa6dZFHZmNC2DY6QpzXrcSm4SUMHMueBn+AUzh+rH5BDxCOxbQmTwJBo1TBjtu7TYV++w+oa0jSfy0Q61miZCnUF2rhdZKlVqgvTBfFR5nUvj0vqFsRCLxT1qiE+1ylLOZRFahqIS55gN0B4coWp6SSL/Kg6kd1ygsBf3gV9THBhBffJSqXppB9To5yCeQRnnkOprthHY2sxbgsYSGmjivtg+Cowp2Q/lMHclXZiuakow3qP3WnHB23Ztc2VrH3v7RO5S0FhiR9qTSyMpW9+vTqliRsjrYzvn3VlARGHnBoQoVf4HVWKEpSZwM+PedKcLhUop3HjQzglKMmuU1/nmAqrCiUPFrCpKoiN818NvKj1+4nB8ZjasBL/yqN4fKfkmWov6okikdpChY0K2dNt5SNUCELkQPxVXELTQAiAecsgpb3xx87zy5cD6iWRxr2MubS7ViE4unaDytUxVyDaCRCxyIuB6O0mv8lq6LQInArstjzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the newly introduced sysfs interfaces for the HugeTLB
dynamic cache. This includes max_cached_huge_pages,
nr_cached_hugepages and their NUMA/mempolicy variants.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 Documentation/admin-guide/mm/hugetlbpage.rst | 34 ++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
index 67a941903fd2..6b96779e2584 100644
--- a/Documentation/admin-guide/mm/hugetlbpage.rst
+++ b/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -264,6 +264,10 @@ pages may exist::
 	free_hugepages
 	resv_hugepages
 	surplus_hugepages
+	max_cached_huge_pages
+	max_cached_huge_pages_mempolicy
+	nr_cached_hugepages
+	nr_cached_hugepages_mempolicy
 
 The demote interfaces provide the ability to split a huge page into
 smaller huge pages.  For example, the x86 architecture supports both
@@ -286,8 +290,28 @@ demote
         actually demoted, compare the value of nr_hugepages before and after
         writing to the demote interface.  demote is a write only interface.
 
-The interfaces which are the same as in ``/proc`` (all except demote and
-demote_size) function as described above for the default huge page-sized case.
+max_cached_huge_pages
+        is the maximum number of cached hugepages for this size (global).
+        Surplus hugepages freed by applications are recycled into this cache
+        instead of being released back to the buddy allocator immediately.
+        Subsequent allocations for surplus pages will prefer this cache.
+        A user with root privileges can write to this file to set the limit.
+        This interface accepts absolute values as well as relative adjustments
+        using +1 or -1.
+
+max_cached_huge_pages_mempolicy
+        is the same as max_cached_huge_pages, but the nodes from which pages
+        are cached are controlled by the memory policy of the task.
+
+nr_cached_hugepages
+        reports the current number of cached hugepages. Writing to this file
+        allows manual expansion or contraction of the cache.
+        A user with root privileges can write to this file.
+        This interface accepts absolute values as well as relative adjustments
+        using +1 or -1.
+
+nr_cached_hugepages_mempolicy
+        is the same as nr_cached_hugepages, but obeys the memory policy.
+
+The interfaces which are the same as in ``/proc`` (all except demote,
+demote_size, and the cache interfaces) function as described above
+for the default huge page-sized case.
 
 .. _mem_policy_and_hp_alloc:
 
@@ -372,6 +396,8 @@ contains the following attribute files::
 	nr_hugepages
 	free_hugepages
 	surplus_hugepages
+	nr_cached_hugepages
+	max_cached_huge_pages
 
 The free\_' and surplus\_' attribute files are read-only.  They return the number
 of free and surplus [overcommitted] huge pages, respectively, on the parent
@@ -382,6 +408,10 @@ specified node.  When this attribute is written, the number of persistent huge
 pages on the parent node will be adjusted to the specified value, if sufficient
 resources exist, regardless of the task's mempolicy or cpuset constraints.
 
+The ``nr_cached_hugepages`` and ``max_cached_huge_pages`` attributes return the
+number of cached huge pages and the max limit on the specified node, respectively.
+Writing to these attributes adjusts the cache on the parent node.
+
 Note that the number of overcommit and reserve pages remain global quantities,
 as we don't know until fault time, when the faulting task's mempolicy is
 applied, from which node the huge page allocation will be attempted.
-- 
2.55.0.rc0.799.gd6f94ed593-goog


