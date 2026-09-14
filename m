Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A37C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095D86B0099; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D536B009E; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9EAD6B009F; Mon, 14 Sep 2026 10:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8BA26B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:44:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05243C0132
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:58 +0000 (UTC)
X-FDA: 85212639918.04.9503E6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6AC41C0005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1fmbN7j;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397097;
	b=bi+BkEvaWldy5gga8FAKE4Z20DecZXgIG+LlMksqlSAhJwS6oVzRbelmdGgE6+JqF8KY6E
	1r4TUul6jBzoqAHj2quochvtSM2IU8DNXjAjre7hwApKd9MKiAA4106d4p2vqkBPBOLW8p
	stDU9B11MMdW/qXmnxEaw/mtHdPYQSA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1fmbN7j;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xH6BjEeSRz31ISnhR+m3g6NPZnp3Vl94LjU9afJPu7M=;
	b=fhvCnepx4gM+CsisNEEDhecnSKcpzUVFmPgywewDEsVLwZhdtzU9CIog1zo9r1FTEE+Eq+
	AoYplsdoufNCth24BPE/CrWrry0JbFiFqgDMu/thcU91Pnwwhlly9ZMdPrYCU2BaxyEnHt
	NpCueGMEb/qncVHnokSPq3MXwciBWKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82C9F439B7;
	Mon, 14 Sep 2026 14:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D371F000FF;
	Mon, 14 Sep 2026 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397096;
	bh=xH6BjEeSRz31ISnhR+m3g6NPZnp3Vl94LjU9afJPu7M=;
	h=From:To:Cc:Subject:Date;
	b=V1fmbN7jDWRflvAsoPY08+yEA3EyvAbYsKKzDZrD4ML+Ph1Cj5AhSLRIciEc7QcnF
	 PI/cUe1er7GoFfREhKI1SxfA4TCQbHG0VXxzi0lhPMjoz1YOGJt0iPVPRYrAG08wUQ
	 k7dqdFUzxYYRGAOCaIyp34gYCv5ndy6Xg0fpS4g9Nm7ISI2U5X77WSqoH0lx8soslR
	 Wy66YgGqugzDeifbBnrPQeiRGXAQ2kP0kzRqr3z05WgQU8ywwGaerU0U6hrY2oSM1q
	 F5R6BKombCs1noEEwE0VXTlNEXfLbR+ogcrouaQZaC2XR9fVJdZMEcP569FrUXb7fV
	 L1XNGCMSaub4g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/8] mm/damon: introduce hugepage_size probe filter
Date: Mon, 14 Sep 2026 07:44:37 -0700
Message-ID: <20260914144448.93732-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6AC41C0005
X-Rspam-User: 
X-Stat-Signature: eukdn65x9oxw9ockeystw4fyfdp97nmf
X-HE-Tag: 1789397097-644815
X-HE-Meta: U2FsdGVkX1839/K3hfAJJsWHhG8BZgW1HYJnVlP7i3+rYNGHzdOljwFTzxqcTMYvnWs4CczH3FhHfAuJbDInpcVJskMmYZkiaCSj2jU74IcynBkbFd1D0P+69xtpJl/8Ly20pXOIU4c0WnVkzKUilCDgB349l1ypFR30QHWMinw8rrdbrczd8DAPlldJ2fj+lTq5/OoUF4OGnOeyIokz6SrphI3sGd2NWYGW7UoFoLyGZPwMlZdbfselNGyHMITsV4mYGYRIHwD5kADsQoGdbM8LJcdqERs7JAUNLPjUqqoXqMhrjIH5LaIYUC221NMwXtivaQtW0xfsicZD8yoyI6Dpd0J6jFRwKQOYkX66af2Xg6g6hBThmNG+JBTPt0z9ToUvdTBdFqANVxB79z6RVTRKAuO1AUZGyihdaRehWQhVb2BCyPA7UiIXPR1Owun0PlufRinpbfHRpvW0PxSJm6jit8NfuPI5ELGIGrZzlL/+UkjtT87rMbybgvxeelCcX/bUH+8k7ap+qxtHZi6ppkeZ+Uc1xsb+QqbledHksH+dQLAcPpqpuyyQ433mfWCHY9ucZV6CZxhitucX0joH5DtW3j6UuxD60PfeAc3dswFMNQPBp+QNXj6/aOPb880gN3waKywMd6oN7wpLOGh+vtzVM/uLH4Sw7F1kQpzpRds1NiluR/9ld4UVm/e3lxD/qlvCgAIuNZTT/dyLCJxRvCbggdcxeZv6QuJ0I2avMDHHJrw8JOu0v92fizaWGawvbxgcTd7XjaXDxLU9cL2FePzuqrDOwHtBkS6EM7ICubM9KE7FIDpBhsdIJtuFF4d0cM/QLNypGaj/g1UTHXQYszDl9cMDp0v3cDHPz7DMbLxbGMcSLkDo0W/cPOQ3cXo6W8qbAT2PZ7LQgScSIEpliIW0kszLqgr97z7o2wHB9QfXhZaVLRF4+xR8LfAi/wE4CiFUBjLX+o9KwWGZzao
 CJPKW6ya
 zFtn2t7V742+6MTWI3INm/Z6076Bae1ofZcovMTxjvBL+2yF68LQbWL7k7E8WME9+8ryfi5vligxX+7wqUyl9e4mwGMo8xZg921ENK+k3Ph978L1ZFEx/ADHHrpQwaAWPqSPqEuUdk/dGpxZhrlg7+FVQWGkkIPfXAg4lg0E3hCBhJqXy4tlrKcMpSAJSrHxmL+dIKsTIxJu3c0hXss+y55wCoS3mFKcFi+KXWx3JsYgBdZidTk4QAmk2g4hYXoDICTB2+W936w7MvW5DitUSiv4knjhX9FkoEZI/jJ1mdGLt353spnrWoJ7cYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Knowing whether a given memory is backed by a hugepage of specific size
is useful for efficient utilization of hugepages.  For easy monitoring
of the information, introduce a new data attribute probe filter type,
hugepage_size.  It works similar to the DAMOS filter of the same name.
It works for memory that is backed by a hugepage of a given size range.

Patch 1 introduces the new probe filter type to DAMON API and extends
related data structures.  Patch 2 updates probe filter commit logic to
handle the size range.  Patch 3 Updates the filtering logic to support
the new type.  Patch 4 adds new DAMON sysfs files for the size range.
Patch 5 updates DAMON sysfs interface to fully support the new filter
type.  Patches 6-8 updates design, usage and ABI documents for the new
feature.

Test
====

Set THP always and start a test workload using masim [1].

    $ echo always | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
    $ ./masim.py run --config_file ./configs/stairs-500mb.cfg --repeat 10

Using the DAMON user-space tool, damo [2], start DAMON with two probes.
The primary probe monitors access.  The secondary probe monitors 2 MiB
sized hugepages.  The region adjustment weight is given to only the
primary probe.  That is, this setup is for showing access temperature
and additionally how many 2 MiB hugepages are being used for the region
of the access temperature.

    $ sudo ./damo start $(pidof masim) \
            --probe \
                --probe_prep set_pgidle --probe_filter allow pgidle_unset \
                --probe_weight 1 \
            --probe \
                --probe_filter allow hugepage_size 2M 2M

Show the monitoring results.

    $ sudo ./damo report attrs
    heatmap: 000000000003[...]666666666666666666666666666666666666666666666668888888888888988888888[...]8
    # min/max temperatures: -2,770,000,000, 68,474,934, column size: 69.784 MiB
    probes
    - prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    - allow hugepage_size [2.000 MiB, 2.000 MiB] (weight: 0)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   250.805 MiB  86.185 TiB    27.700 s      0 0
    1   556.285 MiB  86.184 TiB    27.400 s      0 0
    2   1.629 GiB    127.488 TiB   8.500 s       0 4
    3   535.770 MiB  127.490 TiB   8.400 s       0 7
    4   1.066 GiB    127.490 TiB   8.200 s       0 6
    5   501.332 MiB  127.492 TiB   600 ms        0 12
    [...]
    50  146.133 MiB  127.492 TiB   200 ms        2 20
    51  16.000 KiB   127.492 TiB   200 ms        11 20
    52  144.000 KiB  127.492 TiB   200 ms        17 20
    53  48.000 KiB   127.492 TiB   200 ms        18 20
    54  1.930 MiB    127.492 TiB   200 ms        19 20
    [...]
    101 1.996 MiB    127.492 TiB   2.100 s       1 20
    102 1.992 MiB    127.492 TiB   2.100 s       20 20
    103 1.984 MiB    127.492 TiB   2.200 s       1 20
    104 2.000 MiB    127.492 TiB   2.300 s       20 20
    105 2.000 MiB    127.492 TiB   2.600 s       20 20
    memory bw estimate: 0 B per second
    total size: 5.452 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

The first probe_hits count and the age show the access temperature of
each region.  The region is sorted by access temperature, which is a
weighted sum of the first probe_hits count and the age.  That is,
regions at the beginning of the list are colder than those at the end of
the list.  The second probe_hits count shows the ratio of 2 MiB
hugepages in the region.

For example, region 5, which has 501.332 MiB size, has not accessed for
the last 600 milliseconds and uses 2 MiB THP for ~60% (12/20) of the
region.

Region 105, which is 2 MiB size, has been accessed at least 20 times per
100 milliseconds for the last 2.6 seconds) and fully backed by 2 MiB
hugepage.

[1] https://github.com/sjp38/masim
[2] https://github.com/damonitor/damo

Changes from RFC
- RFC: https://lore.kernel.org/20260913171133.102366-1-sj@kernel.org
- Commit size range for newly added hugepage_size filter.
- Rebase to latest mm-new.

SJ Park (8):
  mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
  mm/damon/core: commit hugepage_size type damon filter
  mm/damon/ops-common: support hugepage_size damon filter matching
  mm/damon/sysfs: add min,max files under probe filter directory
  mm/damon/sysfs: support hugepage_size probe filter
  Docs/mm/damon/design: update for hugepage_size probe filter
  Docs/admin-guide/mm/damon/usage: update for hugepage_size
  Docs/ABI/damon: update for hugepage_size probe filter

 .../ABI/testing/sysfs-kernel-mm-damon         | 14 +++++
 Documentation/admin-guide/mm/damon/usage.rst  |  4 +-
 Documentation/mm/damon/design.rst             |  2 +
 include/linux/damon.h                         |  8 +++
 mm/damon/core.c                               | 26 +++++++--
 mm/damon/ops-common.c                         | 10 ++++
 mm/damon/sysfs.c                              | 55 +++++++++++++++++++
 7 files changed, 113 insertions(+), 6 deletions(-)


base-commit: 40d32defbd03e19f5767a2118f8d28cd0241dded
-- 
2.47.3

