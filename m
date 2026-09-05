Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86A4C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 20:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9866B00A1; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9C76B00AA; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787706B009F; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7236B00A4
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E13DA1C1EFE
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:46 +0000 (UTC)
X-FDA: 85180842012.27.401D5B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6350040003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cI9f8YtR;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788640005;
	b=oW6WMfcWW/kC0VUKTuSsylw+Kv+llvSvroUiNB/e9vjgm3Y6CanKseH1QsVt/CI3GawCnz
	CIajiN/SZbEiVFAiPcyoxNtgMZ5arYJ+EKoiyRrBpUfSGAJv57MUmDrHZVGcnuGhxRV+7E
	w5i+o9Lw/ZG1LV4Pv6uvcRbPere6adU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cI9f8YtR;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788640005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M3fBlIwPeb0MLRMMvDOp8XO46lHImBBRdMKs8udzsHQ=;
	b=InVU2LYj9DEZnhJLv1Pg54l2wiJeQwYBTqDRho8D2Iy+eWdakcqh1PJ7Y+YU9cpGQjticg
	AfouveFAb4EdZkiShFAn3mRyejhws0TyJaGCKQ3eQdhcerUKt47mPBotdDtegDFbfLfP6f
	yeoMOAujtbJOWKxWVLSC0JBFeESPYqo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AEAAE43E51;
	Sat,  5 Sep 2026 20:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACB31F00A3A;
	Sat,  5 Sep 2026 20:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640003;
	bh=M3fBlIwPeb0MLRMMvDOp8XO46lHImBBRdMKs8udzsHQ=;
	h=From:To:Cc:Subject:Date;
	b=cI9f8YtRJ+edLFJlYPyXxAzXRe8E6sxjDX+IW3YEp6gzU+FkO2TCYOxaY0tKab9xg
	 AzpLZOrtpkGQFuEWklX59RZgAvTPv5ASwtwNPR6bbSD7hAyiY+WAMdQrYX3CKSeNWY
	 Fl59i58l4G5p34IRrpvClc92blo8kMO5diA3fhI9tNcJsOePfVGDcF7zWLsqT671LD
	 Qblp6NslfepNv31/aNO8rcqqJDtnpg7qQNvK7bfa/ir0yMfCe/hVcc8o34wD/1ziDb
	 lL9HOS9ETJNmkg1yY2QqKYX/yBBIF+22icv8IAOuvnnd330Bn29qQXgwZ/wGl73zBc
	 n7dloPmQHgGhg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/5] mm/damon/vaddr: support {prep,apply}_probes
Date: Sat,  5 Sep 2026 13:26:22 -0700
Message-ID: <20260905202634.88102-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m5e4jr7majn4ihzw6oqumrsa9o3dqmsa
X-Rspamd-Queue-Id: 6350040003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788640005-313826
X-HE-Meta: U2FsdGVkX1/hXZUCeC3ulY/5CZr9h5ng4Gyj6UIvBprGA5MszerIRc9Q1QW34SDsaaq7y38xdG0jaOLjmW5tDX9r+3mMLtQIsuNbujakCB8f6/FNT+YZKv5MNDwKWKUEmxF2/QtmuYynTUqXs1tgtUzsEyA8HefC4wGee+wHVtwl0nHWV/R9W+F3AwwmUcjPGOpfPmL3aWgEQA3AEQDNe6s16/Dyac/Gb/L39taW/Wlb1JxpnpN9aa6XeM9N9eHbC5cIWEff6wC4IrN4TgSUjdJpEdKHJlMJ3vnHTHoljuGNJy5iMY+meno5FMItAc/FtXHU2kShX8eJxPfDSoTOy1Lb6PzPnhuCCtXsSmpr3FWBY8gGUa1011H1ISt84l3ziIi7uymbjR3PU3c9BCJ41k/XeSAaFm9TbDz75H3UAvLcUfJsOgIjGh4EirPLN71+7E/StJyO97gBRL+mTBGBsSLQh2rPG9ybXga4/djgSjgilNcKHug2i4QydEAh0VINF4TYLaIe3PPGvlL+iXFF4/iswCiajZvPNGy+r4tm/XFYKxDT7NfatTkRjVIF4K1H0+/AlTWJQ0NkSsghy633j9qls9sorzWxRx5ySyW1rox9otfSabqIBghQdMkqkA6z4ZRMs0bRDBRXWfGmgqrgPB4oJB4NNQlm3gg9hwEvmPMDu+wQuXYQx7ABuUvSXMCgY+NcpE9z2+bzpjqZtvMWTVSUeRMkqclHb8tXtC0iMZ6KCVwIL0RVK8wq58EQccZt5OLreAiZ/UQUHe/kioaXlFGzXaUHYlcoExyw1dVFne3qAe/rSAOOb8tLrNl7etEJtLgieMd1it14U/nayZqMUO5vK/m3Lxss5bQzQhCMmSVjadvxspuzzTg70KUBd01zHJQPITkRL/HGJHwARgFDKJu/9CWAfHnJqPQ5Np250A5cARlljEx93SIGeF+OBHYY2bA6stw5/ptT0Dstlf5
 RhYIbBBr
 yMSicBSEOQXwYZAyjvagAKDZCp1xpMui/R6xdt7AZijQEpueg+bj5sygmxfP+TeZgOj51Xs5hjzMUVqzp8NTILcfxX/aF5XQqIXmRZlHEyLAOkFMTX03SOiYpOns9cVDOGD7wmQ5l5sPll0noI9Cd1O7OGZ3Dd3Kk4uZoQFXiixRDknWvzXH+hsUG4ymZyxaHy99rrTQo1pnoVzhUm9FC73i996uKLxn9qk23oxG+IewabEhopZ8kv5TIFrfFTC4icWrROG18L0fn8EHaiO4Gt0Ohig==
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


base-commit: 59446eebc45959fe2d899aeeb301c8df6a1eaf04
-- 
2.47.3

