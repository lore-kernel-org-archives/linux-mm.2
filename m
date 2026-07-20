Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F7BC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A900B6B0088; Sun, 19 Jul 2026 23:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A408B6B008A; Sun, 19 Jul 2026 23:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F286B008C; Sun, 19 Jul 2026 23:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC576B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:03:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5078406D0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:03:41 +0000 (UTC)
X-FDA: 85007659842.14.8AA3059
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2BC6320007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:03:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ki1HbXDf;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784516620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Enmu8Zl/5+J0ooluJh3kcPVk/sYivrIeh8Ayq7SQkGw=;
	b=ESy48/qR5x0fQHVyR1N0ETevKogu/ULpmHAQRObIJAwzAcK3iUd5djmpDjuiaRTwETjAwn
	yg4m3B0uTHu8snIGBPMuiMLR1Ia3EF6og3xZu4uQow7VBaZT9/IggNeaDQIoze8mv4brzE
	b4oN5fr0/6RHRlZJHfxRm1awbnfJ6ic=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ki1HbXDf;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784516620;
	b=pwQJkQ8CT6bD+JcNkNgoV4dosb9OsnJlfILa/2FhJXRHGXiQEK1SyvQhen+vZbwlZIbl2T
	LQ9YfzUMdADRFiJfiMRriEMExswkWFPUzw4uzJdJia6K+/pNfcXyVwka5Lt+42/2bL/7/F
	gloFiRO7VAEUs5KWfhloxtblrKBRFPQ=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ce98cb8165so33952975ad.1
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 20:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784516619; x=1785121419; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Enmu8Zl/5+J0ooluJh3kcPVk/sYivrIeh8Ayq7SQkGw=;
        b=ki1HbXDfW6zdEdokmtpssUhQwlA83tniq9vmMa/RgXZLjPYgXWWj1RBZSYM787+6dK
         imSS1KPvCkYanVjysYCFXswzqtyk/ZGBWwqrb2KaSdBp2t74gpc523NLAffDh5GI1nEH
         /PaHruGq4D1eETiX0n1O5/k+q8RsXYo05lIjsuzMrPeuuQ8JclF2CXA8ZHvZcyPxXoIj
         NjjC7doaQqW5dqFiDo2qSLEWnqa09T4nyzgedY0C4oFxnW2RA+NwRTzCr9WspS4K0ttk
         Y3ovR1x0Hgj/xw+dW0mAb9cmHkfsl+lhGKfDARB8ebvVmoUS82ssqCNMBUR7n+XiidaZ
         icSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784516619; x=1785121419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Enmu8Zl/5+J0ooluJh3kcPVk/sYivrIeh8Ayq7SQkGw=;
        b=naP0S0XbNruYNOgt+TDYUGj8Jrtvh1OgyuyNHpP0bNTETsHjT6bNI6bPmWkoSl0boq
         H59D9VGYFRh7MJpFTXtgwWR9g+fVG8KUJvTo3ehwtHZM45JNXPN6TpqlwAa2JJ155F7u
         ViXrwvwn86pzfjxNtOLHnGr1nkzwi2H5+xKc8k/3LvNib27HOSj2SfdiNVPp1k3otN5H
         /UTK6uNfR5zAw5+rKsVBQ3ts/bHiTby34Pzr7/9HDrrsU/9DaZsBdh0b+sTWaguo43br
         bTyjHm8FQlUivWq2klHIEe03vnanNdhZPLP9gnRwUSndJb4tXgnVwLC14sdxjw3PxW+0
         +k1A==
X-Forwarded-Encrypted: i=1; AHgh+RrflWcQOUyOGil2SSBgJWvH/8TpKhiuYW21tqw847qg1B82G01Rpaf7bpT/s+QhOM5l/iPr2KTmGg==@kvack.org
X-Gm-Message-State: AOJu0YzfNlJir5B0M42C/jXjlbRwHBhOVIs8OxUgF0uawaBbt0kTGwLZ
	uYvNpcdRliadwVRI1h2sIHJiiUJ0YGFTTkXqnbma+4V3WYU53Krp5nZ/
X-Gm-Gg: AfdE7cmVLot6ns0nnnmP6iPxA+tj+DsYpVGDWYwOPhfZ5fdNemQw4ZCJ69mb+QLVVxZ
	vf9dPBKRYXV9e06DqFKiwyvMhbPu8wjsOmxvTBXDkNSqLTWWqua/VGGjfgZLSSTHULU0YH3ydlM
	f7gzfKoSbv9dnnn6T53BAv9B1HWaYcgnrIXPqIg5ngsWYFThwIixspAkeiaguvCBoqYUysEBIr/
	P5aBYXwqCzHMn5xfMtLuYXGBM+qjhzhcTcH/RDvJOdwC9o43/UU0NNTdaan/UCyz8MSd2zuVgY3
	ylWF8q1WHibLeiLQuebJ6GuWM8dOA5E4mUiIEmIoRvFQYs/otutmNhIizXDPP7wAqyoSurZy6RJ
	ImZ60WrCbyE+Tw3R6Q5fQV0xOlDRjhBir37UVYV2GCUQ9UdZ0aq7rkPfNQyW5S9ENdvxx1Fk44a
	1FNO5g6Z6b9wzJZYUQGGGdwBz5fCk=
X-Received: by 2002:a17:902:b107:b0:2cc:86d6:24cc with SMTP id d9443c01a7336-2cf3484449fmr82277405ad.4.1784516618806;
        Sun, 19 Jul 2026 20:03:38 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344d80e6sm47783065ad.29.2026.07.19.20.03.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jul 2026 20:03:38 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	gutierrez.asier@huawei-partners.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.mm@gmail.com,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
Date: Mon, 20 Jul 2026 11:03:24 +0800
Message-ID: <20260720030327.80153-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BC6320007
X-Stat-Signature: 1dgeducb1n9hxyuwmxjr6zy6uhmj8q5h
X-HE-Tag: 1784516620-971835
X-HE-Meta: U2FsdGVkX1+AWfyMTyon5L/tv08lRLyS8T40wnOJVzOAXmPo0SLvTJ1iF97EtvRdvSjqarUk9emWXdclu1QEpdLhU5iomckjyGVdJ7IbTp1tpckfqWrSLA9BQDgcwzqA17OJhauRVBtzGDMtm7k73FDs07NJc6Ua8C5iCtYRpZGvwiw5+IaGwNNg82tJghfI+/52i12HciPYnFGzzatPQhEE5PIDPEx9rSYKiU2XB9+n3P3ihljVBID7wwgA+QmnyT2teviK6npeVbrAhsN0DbtVrygRg4jfMqmXjYrDH2O1PvPdCuaTdGyPNeDpoj3FIuqdpoR4ETsFXTAujnBbuz6r4f5xWJzM9RWv6RhfhE1BWLmAkd76SbJoBJfNPWeQs9SvIIbCWREKYJnuFSTf2F+EhDOHJPN5+hN/tqXJVi+bESF8UeIObMo6QAe/0pQTUJEywGhi3ZawKlyvq6/KGQx5h9KELnEePHTWYDfs163Ia7WpvW5JAZaJfL+oPv/hZ6XDmFIU8oeT1ZlV/NI0s/lb6Gue0eysvkCFUWH48V6DXByDcQMgKvdAQQlXaui+z/EO2eYtzSumQs/lf3veqLowJ8f7pIefhF/7DoOkZcta4MyzzV74Yxu+Gm5HwZCYXjcPdWvdd/MzFznzwpH7epLcxt7XXpI1htCk5gyO/jsjgJ1ZNaPXUB7nG+cLXbsiCpD44nzcROyGFU4Fj2/9C+kRfLYBt4lDiunIUG/w8xMzvwwJRDAs/x/elyVILnrdblFhlPNuJ4xJgYU+5jZFW7Goi1EFGEkgao8uHRZQL25hQriktqTyBIE6T4BVOTdT13zHncd9xiAKUlIq6T1MyGc62tg9YNYoyRQBXmF7FkkvV0unRAkCLZsQSIwVVtGZXf6Uxu9wSTN+ZvbZ4ZUdQxz500HlRcTFaIsCMigjODBRcPPZnTCIeRUW11CFdSjQPsmBcP3Tm5lUkK75NvC
 c1T/quqq
 7fy20rVdAHVfQjWtKpd6N64KX6E5o+JFLj8vy6nQJxE87l7daXcFvbqfZnyLZpkHzz1vhgBndPp+B1SsyXIZDlbvvU0BTO4Pf7ImE5uSBtaBzNe7D5Se17nNRW7N3U+aSS7t1GeJyEB0vh9k8/Bjk/ABr5Qouts4q7/akE9aaeVkfBICKB3lNUWMQq7OLm/d6KlsEna8PJJgJFT3c7N8/uyX430V2+t/gkFha0I37CnQTCrTI1swx0c8E3Hpi/fsTqCoaplhvDMajVsVBenW1B3k4C7ynNLEVVN5YYXsCV175zPPFlXjEJoy+5CH7CGx8x0G5vvpqaIUnvkWq4yeObX9wkkz8yGrjUNs8jU8gRncFsFyZDR/umVCdNfgKhHm7081bNZV9qRMRLMSD/j27PJsSkTEKqlRmSzg9r4V3tXuFhtsGYEoiLyn8/RjB+ge14enl5QnjVamApnp0ddr5JJLkiZYXqACbIYsS+mAQUtSRSrbMcWe+oSZBxDbQU0/wlIRmJ0Es9sbMli6vzlS2+z04CDilXZxZ3qBSWcBQtm6CcvTjRPNi8bWgiWFtFd+q4qUL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS_SPLIT splits large folios in a target region down to a
configured target order, using the existing split_folio_to_order().
No new core-mm code or exported symbols are introduced.

Based on mm-unstable at 61cccb8363fc ("mm/swap, PM: hibernate:
atomically replace hibernation pin").

Different addresses within a PMD-mapped folio resolve to the same
PMD Accessed bit.  Accesses to a small part of the folio can
therefore coarsen DAMON's observed hot set relative to the actual
working set.

DAMOS already provides promotion actions (HUGEPAGE, COLLAPSE) but
has no corresponding demotion action.  DAMOS_SPLIT fills this gap.
It is a mechanism, not a policy -- it does not decide which folios
to split.  Selection is left to DAMON's existing access patterns,
filters, and future probe/PMU signals.

target_order selects the split target: 0 for order-0 base pages,
or a supported smaller mTHP order.  Both anonymous and file-backed
folios are supported.  The locking follows split_huge_pages_in_pid()
in mm/huge_memory.c.

Tests
=====

damos_split.py (VM + Kunpeng 920):
  anon THP -> order-0 split: PASS

sangfor_exp.py (Kunpeng 920, tmpfs, 4096 MiB):

  - Created a 4 GiB PMD-mapped tmpfs workload.
  - Applied DAMOS_SPLIT with target_order=0.
  - ShmemPmdMapped dropped from 4194304 KiB to 0 in every round.
  - Repeated for five rounds without functional failures.

The functional selftest (damos_split.py) is included in this series.
Additional experiment scripts and raw results are available on
request.  Performance characterization using masim [1] and KMB [2]
is in progress.

[1] https://github.com/sjp38/masim
[2] https://gitee.com/OpenCloudOS/kernel-multi-bench

Open questions
==============

- Selection policy: this series keeps folio selection outside the
  action and relies on DAMOS access patterns, filters, and quotas.
  Is this the appropriate layering for future probe-based signals?

- Hysteresis: khugepaged may re-collapse a just-split folio.
  Should cooldown live in DAMON policy or khugepaged?

- File-backed folios: adjust target_order upward to filesystem
  minimum, or keep current "fail and skip"?

Beyond the action API itself, feedback on real workloads that need
proactive large-folio demotion is particularly welcome.  Follow-up
work will evaluate candidate selection signals, including DAMON
probes and hardware-assisted sampling, as well as target-order
selection and split/collapse hysteresis.  Those policies are
intentionally kept outside this series.

Changes since v2 [3]
====================

- Split-only series (collapse deferred).
- Dropped SPE feedback (mechanism/policy separation).
- DAMOS_MTHP_SPLIT -> DAMOS_SPLIT.
- order field in existing union (no struct size increase).
- Added functional selftest (damos_split.py).
- checkpatch: 0 errors, 0 warnings.

[3] https://lore.kernel.org/20260701123000.00000-1-lianux.mm@gmail.com/

Lian Wang (Processmission) (3):
  mm/damon: introduce DAMOS_SPLIT action
  mm/damon/vaddr: implement DAMOS_SPLIT handler
  selftests/damon: add functional test for DAMOS_SPLIT

 .../ABI/testing/sysfs-kernel-mm-damon         |  7 ++
 Documentation/mm/damon/design.rst             |  5 +
 include/linux/damon.h                         | 15 ++-
 mm/damon/core.c                               |  2 +
 mm/damon/sysfs-schemes.c                      | 48 +++++++
 mm/damon/vaddr.c                              | 90 +++++++++++++
 tools/testing/selftests/damon/Makefile        |  1 +
 tools/testing/selftests/damon/_damon_sysfs.py |  9 +-
 tools/testing/selftests/damon/damos_split.py  | 99 +++++++++++++++
 tools/testing/selftests/damon/sysfs.py        | 11 +-
 10 files changed, 279 insertions(+), 8 deletions(-)

