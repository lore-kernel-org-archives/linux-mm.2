Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23954C79FA0
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 18:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACCF66B0088; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7DFC6B008A; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992FD6B008C; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3326B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 105DCA0587
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:27 +0000 (UTC)
X-FDA: 85184212974.11.7106008
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8609418000D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1zLryBc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788720265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CVcnKGbYuQsroSfeo45+tXGpgp7HLrTB2fSqLj66N7w=;
	b=72pMof15IxH/9UNY1V6GAoHd0QcL7jWy1ySZ9OiwBZYcwt7etpDvenViR6vTYGXvZZy88L
	tUY6BPj3NyoGvKcKoZohGfiDpIJUDI6/qlUiKZ8xXnyQClLBbbOwya6g57ERmmq5fKHWI8
	P1NTTJ1ANVOT/9XFavydiGeXtNGTEuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788720265;
	b=aQQeOuLrWwiO/Wy1+LdbUxBhYfvOGXud6lpZ7zwaHeW+yzFDXZ9MZACsFKJkHMzgvdtvno
	eovAK4qDUoUJwUvoBUgpyH+HFdEmP7+mUIqOwdjA3WD7kRifZrW0AIIqP/O2JwQO4t3Yk6
	h3/Tng4aHCdmMpqqLjrvQDQUeLJUzaw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1zLryBc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0549A601F9;
	Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729B51F00A3A;
	Sun,  6 Sep 2026 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788720264;
	bh=CVcnKGbYuQsroSfeo45+tXGpgp7HLrTB2fSqLj66N7w=;
	h=From:To:Cc:Subject:Date;
	b=O1zLryBc/iUX3iyFm4CLXnbyNTgqhfb4KtU5wDg0DzrK/Xm/xD9+MNeycr1x6I3/P
	 8biSDVOAOqdguqwaIFL7+7BvzRpQ7cca6uDEnzQqY9PF6cMKhaIwcWtTojKNgJ05r+
	 VeimpMln9miN2pKoGpZnJfE22Hg6P56fVqFLKfPhP0w6GTQVWZ4GXRNRGZqYwRQta/
	 wkPbTSuUi4KxSgnyCuDwyUWdsY47e/iaXVeMIDnr5nu6fXsB2njwJpet34EZbEhDP6
	 0n26HRNJV16+h64j1b0s5EFWUYUoJBoif6nFiMt5nUM0aWgVkZKotrmcepvRyZQouN
	 iICsSsewoWh8g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/5] mm/damon/vaddr: support {prep,apply}_probes
Date: Sun,  6 Sep 2026 11:44:10 -0700
Message-ID: <20260906184417.96621-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8609418000D
X-Stat-Signature: 6siujcgkofjte4u6mnqw9wguzphzbzg8
X-Rspam-User: 
X-HE-Tag: 1788720265-526081
X-HE-Meta: U2FsdGVkX1/icKpshr5EhSGcMS2br2a4jceCAMOU3l9JeEPJWt3rBw9TBTNh/ea5ODr0mBB/lSu+miz+2uJafxiwkcVMUGxR4puuYaID0qpWt/CaERTtAM7VQ79MdBtm6c73Dlz1VEG7abEqYXYCzjG6qBWKo7LRLSjIcf+Ytd+83JEz7T4DDo6gxJ1Vzy5LviJ/nsY+sbEmIJSw45kr31PEGlhU9zxbbgIAmFdiXhKqEEeVsezG2GP/xQihgWV+i5pCYviIIZA66pU5Gb3+Stt42lhxii5ePNwftqD8p7P2FrsP6Y1ye7TnobsILDY32X3S6R8ikGZLI/pStvIBls7wxAz8ySsl70z4KaXuOyXX9tN/S8a3hGMNBBcGE/EN0twSfIzPO6CgfrfQzvBl+RkU3ndj06+IAZWnXpfzjQnv3wsknLXnY064WJeSGm8h/DSk9NAM+/PGCFS3sl0fF3WRxflVw6fFXWFjHluxS53XmIz4QZ7y2bQNy/pWCoKJrfJIEO/onfDtbasvaZMgdoKoT68r0LRU/Pd11ky9ZNcpfIVBBRkgkEKZ6KluuxBdDqAbd6svjejMb0JqPZcQvDAq9YNIP2IEcfx+AlJVmotpZ1gV8ytfDlqN7uCZCo2p7Wx1pHVJK/uuH6GqTufW+kwuCp9TE3yxaQQOly7N1nnOTXolL+sAUpiDbEEASWbshBsL340ci9fo6+PHRJ6ps22DO0mFn6pobejg/w6faP1GPZfib7113JroSwJkR4Sle9PKOwDrUqi/toH2nDYARMuUwrysJiX+iq6+3clVej2oHlAP/PssrGXvPErOM2a9d2xKodA1u4gRzIraJNYPFKtTzQ2tOlhG86kukBfeXkGBdMhpLGRp4Ok9n9qO9n71cpNUeQsrPGNNNN+JCfZ2d5byEscUKdIBu/bGEvg/AANsSY0UycPmpVIfZ8S2BWwyK/9SAS5tLgQHBfXt4vo
 V0BGAxdz
 KVxwtN1ANYJc/ONe+kSGsOJ+EwWlZ7MIL/7UHgtMUmPeELpPldWonOXeg8Rxe9MYiUY6I9CntXlzpmoorSg+GuD1IItZv8lIgGp9m78MAcKqdHoCavbcOwJQE+xbacHumIRC3malUkms9qqJ8RZxaZ+6gvLmkR7/OIM3+zggjbpEL4VeMrKBFn9PRzHx7ENBe+hb4pB2/+WBn/P6qpn1YjZcl7Xb3Us5cYUSBDS0HVWP3brrUxHyr9augg35Wg7ItiAw9fX4QTsl+7AEzMwnYKLX6UWIwoj2UFUgfIaL0ExBNKxg=
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


base-commit: 87f579da3b3b652d1bf5ca71ccfd7e267807e8ac
-- 
2.47.3

