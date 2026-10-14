Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F83C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542736B0088; Wed, 14 Oct 2026 13:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBB66B008A; Wed, 14 Oct 2026 13:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392806B0096; Wed, 14 Oct 2026 13:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB266B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 994CA1C4094
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:07 +0000 (UTC)
X-FDA: 85321990614.04.612A8E6
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA5AA1A0011
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XNxfesdO;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SbfLgUW9jzchO6/pfPCWGcSWUMfF0/SvwGcRabdT2ZQ=;
	b=nI/cHuAOp30RJHDvH37tRniyG4qlXy8WLlaAhQEbTsEYYSNejz/V4+WLInxfkBtn/WpfOQ
	yCImkIJPwRS1kuPg/X+I5AUZ+bEuss2ZI1LmapFBVfNWP+N7v++C5rW5ezGH1hWc4DdKXe
	NITvmtnTxgOPiOi15CkaZiF5tKlR/k8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000685;
	b=V21XggxTODmEDb3GsDAUwoCIY/ic5m2FfKmhxryTAWSOBSVkW8ohCqSYq6nUJ627dI/FTq
	bB2zmzU7xiwBVSpBXN0XS7f+3zRNP+MAYqxpZH/t9luBG6EbuLQGY705zi3srFgZzl8ys4
	C1TTaNcst57eDCDc9YeVrm9uFIyRK9M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XNxfesdO;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93e503815adso309607985a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000685; x=1792605485; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SbfLgUW9jzchO6/pfPCWGcSWUMfF0/SvwGcRabdT2ZQ=;
        b=XNxfesdO0eL41vQMzLk6lm5lYY+OZ5cf0riTFqDPxXAB3pivjj3JjqVfrK2cin0hmH
         8L5V0U9xmfAnfR6f6ntjmE/KK+W9W/gH6CxbkkNkcALwFOhg9+RJxeFLINGNRjrK3ztJ
         J7X7dpW0M0gsGo4kbYFTzz4DZDANUw8RPoHoKOS84D3z3Dh90K8KUnZTdsSm84MWTOqT
         AibTrJM4vtXI8rJfN7mHJ9yXD2KFmQ9X9iiRYQVgupMY0hAbE1Sh6cNsJ9w66SaWjd2e
         Ua1NkhsvbeBVHI2qB+Ec8mu7rmQy0KdXgb82JvaJD4feyLg4hswScdPWdRjtTVwG5PK8
         J9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000685; x=1792605485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SbfLgUW9jzchO6/pfPCWGcSWUMfF0/SvwGcRabdT2ZQ=;
        b=AANv5r8xnIWQNTbBWu9rfjcpE4eRuCNZIH7alqOpYO857n5g4OALgUry9kw90mX0a5
         t9o3WWbrMKVPPPwAby86WR/QXf8qv3E5crK+5KxdD41K8CM2mMw3uDd+tefiHReYRQlh
         XdnxUFU3tpA0sGZz9SRZ3rTT6GcXSSjxPCI46g/DoG8izUh6FX2H1hN8bgBlB33YKdbp
         6XCGJack57+4bp45eVR63zqsdvsVO0Xaik9kP2PaDwAHM58vjH6LBWz9hU8tFycGM6KD
         cG8ehsvohnEswKNnwNNi6KOUP642GRzxB9La31jVllRmqrTB1zzGXj/a30C6GsidZrfK
         YOdQ==
X-Forwarded-Encrypted: i=1; AKwUvByojMIlLcKrcZewAws0+QKe+X9USaW+OZvTVP7hVqy+BCAna/BBwKuuXKbHISnNJFkoLEeAFydR7A==@kvack.org
X-Gm-Message-State: AFq9FYLjv7USR4soNd4YmodSMLmBJtWRT0LhLSxG0bVx3wUfqwDhNRt2
	en2tP5hg9V6KHplKCjG+MZEoyXYn5WfCj5x/tmwh7qlGyjS5iqqUkRkxRE0iGV3ZDbrETkd+eG5
	dbmt1Wt8=
X-Gm-Gg: AYBFou1DuBPR4XxWZ6MJ3FdykhivzEDKvqViRzA+3KEE1Ip3djXfnYQ/zK1YDSl10Rf
	2EqxfNv54CV8qw3+2wzwBwiPVfzYxAiYLJIBwoDjNsuLtJXiO7MFH/ihWbzKAMBsTJWJxafntIt
	riOZADDcPtZYm8KmO/0v/Pj+OkSRTAKYzWv+XpIBYBC3Dji+E9vFZyYekBKwWwp+wElO3895RGP
	2R3M3C4cHuhYRF7eICWaU5KIcZ+l/UEms5+NrarZmuB/4aivLSfaV9gi/CPwQozR5Ll/0oW4M+h
	0+LPCw3pnsGEaIEYaA/ZUqHhfC+LCzovDwyxpV1i/9+skWu2o7sq4p/YYB/+Pw9g1cRkZrkM5Bh
	MQ6f8XVOMYiPoKKLqRXgp48dEwLPGIdnHuz6aGyMiSYpvOm2M5Ao3BZGa5qkSg6RND/95Gu55GZ
	xh9n16JeTMfIo1Rlf2A59F6/O/EQaXtgBf5n/GA3YQqIgO67WjJY/SNG10W+swUIyD6JpMzo8Hv
	A3Nexee5cBHw0b8iRqmYf0daEZJjLpGVlC85g0EjG+ynbPNz8PMAmYuiKGtyKbeeYk8C5E=
X-Received: by 2002:a05:620a:4591:b0:939:6dfa:48fd with SMTP id af79cd13be357-93ebd23398emr2633773185a.51.1792000684921;
        Wed, 14 Oct 2026 10:58:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:04 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 0/8] selftests/mm: add MADV_COLD and MADV_PAGEOUT contract tests
Date: Wed, 14 Oct 2026 13:57:48 -0400
Message-ID: <20261014175756.2035176-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA5AA1A0011
X-Stat-Signature: 6kgtk1na13srpuychbod9xe7y5yg7xg4
X-HE-Tag: 1792000685-732941
X-HE-Meta: U2FsdGVkX1/dz68S8kUU2fiT6Ohbnbg+FfMisy9hn2uxb2Ay2ZTAUEnuPCjyek4NE9IPZxVSK9igMWYJavfykrNUNtY60kF9iMp8MKd7N24tGh1rUVmRhVbgsqkRb55xOG8iQ7aaDt3+nDsez7a9bI/AP2YGSPf1Uo0/mnujY6f7/60+FOtmKv3rcQJDQ9W93zTC9ear9m0Re+7Ycn7q+g4idRFaAKKkj7MXag/DHcH4xXRpwrt0VSAVdD4gCTj0JgiiSKNWoZjE+TAC/h9lvJnoVzzJ4wJzm6CXEzGzAW3Qv6IuBtxBy4Pw4EJgZyl+ZaJGs/1rwYn3m5I8I9+cA+j8MjY6XNW8gK9NHGRK2Ah5Aa3DwACbvCd7+vNuT5tww0SeitsG+pTUvZ8dmVxRpTo8r7kJYE0B/BDre3ynCAMFe/V8ONZVlasfdwq7JiUK0jhznc66MuLgUL80wVUjtlUNe/vmn5MCPjUoXa/as/4tfR+HWdrdDrpsJx+N1GE9U85GEUdSsOYFyu0oF/OTb6+hY2juZEvlHc0ObyYSbrrkogMO4H5u96tLfjFhB4iE4sElXQT2bc5zfSOcIFU0xVgX62i/5Uao9uhiRgS9Wd9qVZQfheSE6X69T/iXamtDaydP5G0Z+YYw/Y597/o/T05pFUObsPKdYBvvybK+JWhSXpmGqciKEM08cNLORvSDw78inEjywWULglU6XNmAWbskmTfyjzvqiDA9DctvP41u3RXmtUhW3jF+sr8uhc1yVM6l6AR1w0gUFw5WgZUggBdKEx96rvU5yWxjHqrgR+tn0SXQZSZqfBDtQ8JRAaUaeFdmIwho9QNmL0pN9FdafRzUAPhSxCEV4VxL8Pqhvl/m7Zp3cF6KCWAPVSAO4g3S7CN4qfC3oiUq8xMeEWcwLW8PaeeNliibSrHLFTbiODDzIEXtZmsBiae3F35azf/W3koULKwqJokoovpFcml
 7dtAKcYt
 5VQ1ZxUuUPtH12A2//VtPHCXMXP8bg5eV/hf8qgvUy+GMxIkAUZHGl9hsw9AV+s+u/7MPJ4H/GpuZBIsNUGWCc59g+Pg7HEnJdl/Lu94D0EjEdYK8ILzK1/+xSuvvhAXe8ufpfFyEuNmZXkbRGt++KeUv3ItSg/KNOn02s+jPGhHfuNECMvMbo9qT1H5Xf7vCkEz8FwoCMIhcNjbR0UP6G/djKzOSGezejPThAjalHhKy2uw4JGPudiAq+t/sTa5Xu/Rr3Cw3CKN3h/J8VSLDe32tGXlauwkIQ4xXowR5cSgZCtXuB101rUBYnOUdYd2NU5iusboLQlt9h11TJZC+O9S3phaqfg84yGvlVW9OMnQATuQH1se8F2AR1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLD and MADV_PAGEOUT share a page-table walker in mm/madvise.c
that handles ordinary PTEs, PTE-mapped large folios and huge PMDs.
Existing selftests cover little of its range, folio and permission
handling.

The walker has needed several fixes recently, and it's clear we need
to refactor this walker to make it maintainable.  Ahead of that, lets
add some selftests to at least cover contractual behaviors.

This series adds tools/testing/selftests/mm/madvise.c to test only
behaviors userspace can rely on, so that it stays valid across changes
to the walker's implementation.

Each patch adds one group of tests, simplest first:

  1. MADV_COLD skips PTE holes and swapped pages.
     both hints reject locked VMAs
  2. the same hole and swap checks for MADV_PAGEOUT
  3. zero-length, unaligned and partly unmapped ranges
  4. hugetlb VMAs are rejected
  5. shared file, shared anonymous and SHM_LOCK'd memory is preserved
  6. whole and partly advised THPs, including that MADV_PAGEOUT never
     reclaims pages outside the advised range
  7. the file permission rule in can_do_file_pageout()
  8. the same rule for large file folios mapped by a PMD or by PTEs

Tests that need root, swap, THPs or hugetlb pages skip when those are
unavailable, and tests that need a page to be reclaimed skip when reclaim
does not happen. Where a skip would hide the bug a test looks for, it first
checks with a control page that reclaim works at all.

All 24 tests pass over three consecutive runs, with no skips and no
warnings in dmesg, as root in a virtme-ng guest with 4 CPUs, two NUMA
nodes, a 2G swap disk, 16 hugetlb pages, THP set to always,
CONFIG_DEBUG_VM and CONFIG_PROVE_LOCKING.

Run unprivileged on a host with swap, 18 pass and 6 skip:
  - 5 need root
  - 1 needs reserved hugetlb pages

original set: https://lore.kernel.org/linux-mm/20260922235830.2350770-2-gourry@gourry.net/

Gregory Price (Meta) (8):
  selftests/mm: add MADV_COLD and MADV_PAGEOUT contract tests
  selftests/mm: check that MADV_PAGEOUT skips holes and swapped pages
  selftests/mm: check MADV_COLD and MADV_PAGEOUT range handling
  selftests/mm: check that MADV_COLD and MADV_PAGEOUT reject hugetlb
  selftests/mm: check that MADV_COLD and MADV_PAGEOUT preserve shared
    memory
  selftests/mm: check MADV_COLD and MADV_PAGEOUT on partly advised THPs
  selftests/mm: check MADV_PAGEOUT file permissions
  selftests/mm: check that unauthorized MADV_PAGEOUT skips large file
    folios

 tools/testing/selftests/mm/Makefile        |   2 +
 tools/testing/selftests/mm/ksft_madvise.sh |   4 +
 tools/testing/selftests/mm/madvise.c       | 846 +++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh  |   5 +
 tools/testing/selftests/mm/vm_util.h       |   1 +
 5 files changed, 858 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_madvise.sh
 create mode 100644 tools/testing/selftests/mm/madvise.c

-- 
2.56.0


