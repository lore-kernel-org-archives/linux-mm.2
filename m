Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF19C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F413E6B0092; Mon, 14 Sep 2026 22:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0F66B0093; Mon, 14 Sep 2026 22:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FEA6B0095; Mon, 14 Sep 2026 22:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B251A6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 985C5802EF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
X-FDA: 85214365320.05.99AF309
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2220B1C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SfaUW98I;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+BAuo6u3PIFQIMQVFTjXGRtVx3GGZoYllrQB6TBB31E=;
	b=5JnuphyySGenb1rKqcO/jx5B8OsMo40e5XOCB0yCrQZh7l1+abfbLhS+7nFSLOPzZbWYSp
	fb2zt7NiIIOD9eWiSECMSdr1jWpo7mqKgj4ZlA525cq4wtfnaK7PslQ8FdYcTD94bJQCYQ
	lnAdXY0KMsLZcIVsSYHxvi3nVMHP5uk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SfaUW98I;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438179;
	b=p/3cKXIHPRH7x+4SUqaNApLc3UxgIdvrohoWI/2Sd08ABAiUvHtuRJQw5DK4/AwN8+swl3
	5ciKzDfRDyjP1XKt4zGKimVeihh8FiHvOG4amNMK1JZl7i8Orlw6ta3SubHyKi9LKdXFN0
	/XS/gq6l7S50WCOw9ar4SxovtTYdyRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 989FD6025F;
	Tue, 15 Sep 2026 02:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C352A1F000FF;
	Tue, 15 Sep 2026 02:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438178;
	bh=+BAuo6u3PIFQIMQVFTjXGRtVx3GGZoYllrQB6TBB31E=;
	h=From:To:Cc:Subject:Date;
	b=SfaUW98I6A/MI+J1LWWVG8YvrSZJfsNvhkAk/sM0MDsGOn+u6qnd7xvjoHJmnOr4e
	 GHnryIjEjsjr9z3Ndx4TQ0rCqnNem552bzO68CUNG+uX2HTLOFOeIr1ndYQZjJS4zA
	 XTNv1/pF7zN394LXol8e6KCjZFbWrYAwFHMesUoFvt3spdkFvbyYu1A8u2admScWlp
	 tgi1OmCXqcj0zGBj1hOZHxX+GZnhD13WWJjBOZR+yXmwCKswmKzsZKE5YEuzCXXOLX
	 3QMokfb0P/5iJFutoTeAtDQX1mrhm6FslLDhioPAGgBNDaI6urTSHmHDkzZKd8pmSv
	 0xa0rTK5leAlw==
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
Subject: [RFC PATCH v3 0/8] mm/damon: introduce hugepage_size probe filter
Date: Mon, 14 Sep 2026 19:09:19 -0700
Message-ID: <20260915020929.102953-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2220B1C0003
X-Stat-Signature: w3x9ce4znf1xra4r5otrgph4dm5wamgh
X-Rspam-User: 
X-HE-Tag: 1789438179-201981
X-HE-Meta: U2FsdGVkX1/bd79707L2Iv06pPu1atpQS2hB/8dHK3rQXyMtJ5xBU21f+2OOpvKMaF1cdDdgoTHjts/2GuYWkeihEo3bObtgVQSWKWZQJb0lxOO4p08qrIsHxQRcs80Q3a4FTKaz3QRJ0eqTBUM7vAl0AUtdemO5xvax8ZwMNQ10Qj1LKZpd5rlOYh6GcPmdpaSGMQc5uJunVoP1MQY35ZXPkWiEGRMDoPsIjswyRwt5V2IfdZj2rLNtnqoedqo5y6SrCJD91vB2KSHQqUu0ITRHcmn8+WXiGWATxnVYqS/0ujj5xpjnhRvBsEuLR1vI2exfbw/Fp/VGsDPCSzbcg/95x64wV7eJJyHm4MkYhjbG3F5YP7yr729uXdX1brwmdt1rh0X/pmBoLL5SVo0qukidkwJ6BzVrmlIP+v5OFk7X9H6LRIenTFTGti8ioW9zPelwLO0GYzVsek74Ja1LY6/NBPTAV83Pd+jD90XJ9C3gHMYePcA0ngKIdpRoPdv8fSD7QZKaPhZGSubJWZFm86n1pjRTIvxmPEzbOmB1wBIkfUlNFpm8KoBxck62GUex24WOFA7XefMXC5ZoCB4gavNHhfGf4jM/LeDW5xKbkTtccFn5OC+BeiZKEgdDoBpeduM3mqF42ttuxDZxM9mmTHh8RUDDDM9C1O8yIDmGuA06lzgWINJRBOEghJMU5A2U9SmoZF1XEGiKqVQlIiOwOkQSh8MruX7HOCBHYcORrlR8PW8ZJjIjPNudgf/ZLWuEAOGdMswAYoQ1O6NcK8rP4Fi7cj5Aly9IiL1JZ3NxeBYdKX+q/+3EbtMtkaqpToJzvg5lPDM1qAS+GqfV4bfqgaQ/F2H7SfAZRKfSks2/0p5+3eEyXIDszmKlUCi4Q1VCZIUo72sm7QIWUNUr6U+W+ticrxJEOp3M4hb9L4TnZy9g57QVar4NSOBzkYArr0Nr+QVf2gjoOhvVa1U8Vak
 VSXEuBlt
 73aIjsMwWD0PGeUXeOMjR7B6SMgdPwxhe+HF7Z2PHtjO1Lm7BQK2Pi6l6V28y/f9B1MDNeL7bFBS9aaW4OCivpIAdOnfvfJfFrf+j7uDvv3bmVR+WbqbD4cdLaIk/dUOaYKO9yYiV8u6MpWwDTSJWtq+Bu34vpbcRRcJ8SvXz73BBBMnUETjB6oT9Lu1kcbZcdodnhyyDc6pgssXgmatSTWA6/zW/XvYC0Jl2zFlBzSjIUo+Unj7EJwYSvXs8i56UDKi4AmCCs/RDFe/xmjsKdW2gu0kt2rSC1y4DgD/6DTXXV527zAZLVTLvjg==
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

Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260914144448.93732-1-sj@kernel.org
- Free new filter for invalid filter commit case.
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
 mm/damon/core.c                               | 28 ++++++++--
 mm/damon/ops-common.c                         | 10 ++++
 mm/damon/sysfs.c                              | 55 +++++++++++++++++++
 7 files changed, 115 insertions(+), 6 deletions(-)


base-commit: 015e1675b7b4f621c0e89dd6fab5e0c82b83e94a
-- 
2.47.3

