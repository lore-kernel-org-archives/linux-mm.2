Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A9B0C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B876B008A; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4058E6B00A2; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7CD6B00A3; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD856B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 615B61C1496
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:18 +0000 (UTC)
X-FDA: 85194393396.20.861587F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BD80EC000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilhVuhVB;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962656;
	b=SVbZFomVRLXt8NsqXFw5yrDSCU2z8nfK40tpyWCRoFgbw6FjIMbUu4BUM9pN4Mwrb+M6rJ
	QQc+mpns77y42dKOkirbCPAHks+EC56eWyvj17oa3wnva/xYFRGOZLSxEWu2Yqj/WjcPDF
	yKJcmdcz5AN422pIy1BvbPG/Z2qm7qI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilhVuhVB;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0TEnmWZc64GLgME/HU4PH8uoWioXFjP2oNQKmspGLrg=;
	b=RslNV8cocJ74MJXIVE4dI2074xv8760k+zf24e8pBvkIyiHYvqqAQZOMzbgcHBG0epJ/6L
	Unp9ql9HZC2DqJpQMaJEtq2c88OtCY8OOsiFVNk/Cf7rcaoYd/VV1GybFCNBzsVVp9CUMI
	eHUYD6WtbzqHLCMopQZmM5aunuyUlfc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4000360219;
	Wed,  9 Sep 2026 14:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15531F00A3D;
	Wed,  9 Sep 2026 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962656;
	bh=0TEnmWZc64GLgME/HU4PH8uoWioXFjP2oNQKmspGLrg=;
	h=From:To:Cc:Subject:Date;
	b=ilhVuhVBN3yAGSIn/p7Mf8a8gcAax2xpCGzuaD1tpKQUcGpXEF8UfJRd8KHzAOJTB
	 sO1UVLv5h55RxzglTvE3isMsY7RF30otVRvGy6ccjtWXoXknGHJo9X/u4oj4TckIIq
	 JAiJjGspAVnH2YGsywpGaDKIcFWsLYsWv27kjpAkmmbuRO6NXF7t/W+im4LmG7+Sgs
	 qY1Ka6bSoKizFn8AHRfME2aqjzwfub7eZiU3CFvYawe5TRnE2YAG5c/jdTrlto1E9N
	 QTzC/d5nLqNFVfNv3JcvOPRLU9SWOTLHirwZvV2Rh9WzY97eOy2Kn0FgX0inGSQSFr
	 T5Jh+FxZCgSuw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH REPOST 0/5] mm/damon/vaddr: support {prep,apply}_probes
Date: Wed,  9 Sep 2026 07:04:02 -0700
Message-ID: <20260909140408.104699-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD80EC000B
X-Stat-Signature: 3q8i9gu3ddckkybpynfae83d8j6i5qw8
X-Rspam-User: 
X-HE-Tag: 1788962656-839582
X-HE-Meta: U2FsdGVkX19s12Lr7Vp8Id1tNF50oi526uhh8DHHnB336LWKeP5WtB5YeTvM9MuquVZCdSFRI4QnjRfgZC2ZCN+5drRqhJ00vWKtLPN4gf/Sk7ALa3YpOWqsga0d+86o1ex/BBhKOrJywXQMnJLLiqiqiEuLuax5RhBq9M5AXxrzqeKIoI40JuRGj6NR36T6HiNN9ukPEMriqgvz/BFn+P9ZiFKclaJJVmRhXwsmLYbA6wN7X28V9aBer4j/is1lK7Eg+LGmzTe0pIwQ1uQZT8A5aqpLwBq+3LiVA/8uKs/1BvhJx07LlrWBo3OQw4Vk1LCu4EGVaAArLhLd7huMVVT5yaz3xBfWMLaga5OhKF12jIg+ec5DDh97vD/4yZJe59fDE5mt/exSkVkq/g9i53dJnHOZPlnybxoueaOUtDXAE+e/2RZLKKiCrxKtDQtTolQOvWW9gD3AqeQoaQoFND3kF9nQtSxlUxZUchxl0miNqVKtif90w6mdxasMO26E2flk/rjxcsCrolr9eqGTJnLDwQA3X0TVeFfgBaUyUG7N2arWnbEsrVCTUWl+YfXabADuyyME7mD1OIjJW5bt7hA7rRcLr0AeAZ9cIr1oJoS5cA2ukHip8OFUyAdLDFsNGazqUTSboAggZt93ZUhs6UIZp/HJD1F3jBwMqUUOM+j8r8oxP5pUjijtVjJYZQxbT35xLdICaKtBIbX9WqbvOi+gdzFXlUnNONGXjK4zmI468EFRern4Z/sVEWDza/xAiBNcqWKKq+tl0sgLZZ4jxdx5z/saRFos/FbxGfhdIwiW93vUnURb+xs2qBVtcLezUGLhwwvu9kr/ld+4wQS+N5I80tNK87gkZdcfa0mo1MtwC/OveUlBvKB4xstqzVX5JE70BKdWaqs1hVC08xeMmAi8hAAEEt6yf1UUJPbs7AR3/Gv22Dx18PgIwppxavdAwi9/0ECmim37JQw2OJR
 5WYNzvjA
 wDlSEuC4wr2b98XlU57FonCGYnk3TN/gUE7rg040YcjRJAd5i6Dzt9+ExbjYMv4XfIis3nnOeG4a+5ad5FfF2IX0jXIREXaNCziKsnHzqywC66Yn9NCtMrBz2SHm833tMgfFJ4JSvvvGciYzsKIqs4u3JlKbTbItxADIyfRyV8eukn9o5/zE5KBeUDJt/t6PavyCq3hRUHNwREVnRbOLKlDXbDSM5hMSRCc9+9F8D2U45P0IT3DjlyS05KpT7XIQImI11O0E8akAHyoKU0Kie9j+wZsgHAxq/SnJC5arW+O6AV8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON supports data attributes monitoring.  However, only the physical
address space operation set (paddr) is supporting it.  Add the support
to the virtual address space operation set (vaddr).

Patch 1 adds prep_probes support to vaddr.  Patch 2 moves probe filter
handling code in paddr.c that can be reused by vaddr to ops-common.c.
Patch 3 adds minimum apply_probes support to vaddr.  Patch 4 extends the
support for hugetlb.  Patch 5 extends the support for pgidle_unset
filter.

Test
====

I confirmed it can capture ~48 mb working set of masim in vaddr mode,
like below.

First, start masim [1] to access ~48 mb memory at a time, in the
background.

    $ ./masim/masim.py run \
            --config_file ./masim/configs/stairs-50mb.cfg \
            --repeat 10 --quiet &

Note that the config says the working set is 50mb.  It is 50 million
bytes, so ~48 MiB.

Start traditional access monitoring of masim's virtual address space
using damo [2].

    $ sudo ./damo/damo start $(pidof masim)

Confirm it can capture the ~48 MiB working set as the 4-th region on the
snapshot.

    $ sudo ./damo/damo report access
    heatmap:
    11111111334[...]3000000000000000000000000000000000000000489999997777777743333333555556[...]8
    # min/max temperatures: -1,150,000,000, 80,009,499, column size: 6.963
    MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 85.355 TiB   size 55.703 MiB  access 0 hz   age 9.500 s
    1   addr 85.355 TiB   size 18.984 MiB  access 0 hz   age 6.700 s
    2   addr 127.183 TiB  size 278.516 MiB access 0 hz   age 11.500 s
    3   addr 127.183 TiB  size 7.570 MiB   access 0 hz   age 900 ms
    4   addr 127.183 TiB  size 48.133 MiB  access 190 hz age 800 ms
    5   addr 127.183 TiB  size 54.977 MiB  access 0 hz   age 1.700 s
    6   addr 127.183 TiB  size 55.113 MiB  access 0 hz   age 6.700 s
    7   addr 127.183 TiB  size 37.902 MiB  access 0 hz   age 3.900 s
    8   addr 127.990 TiB  size 120.000 KiB access 0 hz   age 11.400 s
    9   addr 127.990 TiB  size 8.000 KiB   access 70 hz  age 0 ns
    10  addr 127.990 TiB  size 4.000 KiB   access 0 hz   age 11.200 s
    memory bw estimate: 8.931 GiB per second
    total size: 557.027 MiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Stop access monitoring and start probe-only mode access monitoring.

    $ sudo ./damo/damo stop
    $ sudo ./damo/damo start $(pidof masim) --probe_prep set_pgidle \
            --probe_filter allow pgidle_unset --probe_weight 1

Confirm it can also capture the ~48 MiB working set as the 11-th region
on the snapshot.

    $ sudo ./damo/damo report attrs
    heatmap:
    00000000113[...]40000000000000000000000000000000000000000000000001111114999999533333336[...]6
    # min/max temperatures: -840,000,000, 330,002,000, column size: 6.961
    MiB
    probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   8.000 KiB    127.990 TiB   8.700 s       0
    1   120.000 KiB  127.990 TiB   8.600 s       0
    2   55.543 MiB   127.183 TiB   8.400 s       0
    3   110.008 MiB  127.183 TiB   8.300 s       0
    4   55.352 MiB   127.183 TiB   8.100 s       0
    5   55.605 MiB   127.183 TiB   8 s           0
    6   55.691 MiB   85.355 TiB    7.900 s       0
    7   54.430 MiB   127.183 TiB   7.900 s       0
    8   50.391 MiB   127.183 TiB   6.900 s       0
    9   18.879 MiB   85.355 TiB    6 s           0
    10  52.844 MiB   127.183 TiB   3.500 s       0
    11  48.039 MiB   127.183 TiB   3.300 s       20
    12  4.000 KiB    127.990 TiB   8.500 s       20
    memory bw estimate: 0 B per second
    total size: 556.910 MiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

[1] https://github.com/sjp38/masim
[2] https://github.com/damonitor/damo

Changes from v1 original post
- v1: https://lore.kernel.org/20260906184417.96621-1-sj@kernel.org
- Rebase to latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20260905202634.88102-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.

SJ Park (5):
  mm/damon/vaddr: support prep_probes
  mm/damon/paddr: move probe filter handling to ops-common
  mm/damon/vaddr: support apply_probe
  mm/damon/vaddr: extend apply_probes() for hugetlb
  mm/damon/vaddr: support pgidle_unset probe filter type

 mm/damon/ops-common.c |  32 ++++++
 mm/damon/ops-common.h |   2 +
 mm/damon/paddr.c      |  23 +----
 mm/damon/vaddr.c      | 232 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 267 insertions(+), 22 deletions(-)


base-commit: da659d141e9797b3a2e5d0e2b457bfa4e8a8cb2d
-- 
2.47.3

