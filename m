Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782A6606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLZXSBk8
Received: by kanga.kvack.org (Postfix)
	id 700546B05B3; Mon, 16 Nov 2026 14:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8466B05B4; Mon, 16 Nov 2026 14:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C2A6B05B5; Mon, 16 Nov 2026 14:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E29E6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A1A8120286
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:25 +0000 (UTC)
X-FDA: 85441923210.25.2A8D8FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B47080007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLZXSBk8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf30.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794856223;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mTux4u5KLjPPAMNNkhECddqIC/XEX60DgixGnVYe1M4=;
	b=IeQz6bQI5Ml+J90dS3PPfd9nIQ/2L1LLwPdfX47TTwKurMQJYZebTPKhMf09lJcHDoXPl8
	P4ZU7ZIXmB9ukPD/marJpyeUUzlXrA9jvoGYWLqHfiiBqyhD7B/dTLeMSk8LafCDNTT4dz
	9Z9UIycBYl/X+BJzrZi9g+Xj+l8wejE=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLZXSBk8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf30.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794856223;
	b=1fYFNS5EUQoF4YiNgA6bZD53h79v2Zkg5jeLfmTQXrSBOQT8kTNcbNU9kNCmOhEkqq9fMW
	wYnNeIatMFlp/e+xq6xfjvEZQ9IocaU2iD2CZJLOVByKPjXRNdmgxHGtii1Xk4CHhWbtpB
	CASMtnGwuUR5SVaBFPxZzlCLngZQ3LE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DE76462AE;
	Mon, 16 Nov 2026 19:10:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794856222;
	b=ajeuKy6d+/tVDPvPikK++84fdHNN/XLn15+GINJ7/eI13p/ADhPJUhI87chp4dWldTMM
	 CZfjGXVVQFHkdJ/eHbI0mIqzHyAPpaGwXNF3+zocOFlIEuPAXKJ1jtTo0iNbzgq/yUc8U
	 iXS7Qk6Vn3ctCIuEa22FyEJXWnT8IicgRNAKhVLRiLrtKznm2uR1h1d6c3oghCr+N7MIJ
	 CIAGc0bflwpHdwWEQnzMae7dGstw0oszPmNrj3YUgBFU7Kk6hX8gf82IruDi9vXcPJ2Ov
	 oCCFJB4z7nfmFESxIpwWpaDtwbDbHQazDU+sWZxpDLnmiEigm7kHQJvQc2fANDh7RbQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794856222;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=mTux4u5KLjPPAMNNkhECddqIC/XEX60DgixGnVYe1M4=;
	b=gGk4IPiZESgFH3+YkXmLU7Bdz9mRFvANge6KALzFGimG9Kv2s6Y+mNy4spTBg1B68NhM
	 FMShXz9XnJWUHi3roAv/luII6e3FGypskqt6WRB4sRZT4DFpUA0mkniJLCDGhVBFVCTsK
	 i6LCdVYoZjia/+jYoCVu61ZieFf8dKYq7j4YJ0h7dIvFPK+kEeyA8RegfABN3dVPJUmtV
	 CSEDM/oBQT3RGS8a6Vwgq1Qj5SzCjZaaELShKhC5z5GKo60iISUXtNY1GlORLxDYlZMc3
	 7vDFlgNLtIX9JKFuGQ7RsvMenX5sTeELAXgEGc5dlZ03MqsaCVIYaDZTvIMy5KSAp8g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D9C9B1F000C5;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794856222;
	bh=mTux4u5KLjPPAMNNkhECddqIC/XEX60DgixGnVYe1M4=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=lLZXSBk8PKwtEn4UEjIPxE8vGBymFs+aKxxZbhIqTImEuhDl/0Jc1OF4HL/X9latZ
	 /S0EUTXCj0WIBosH8N6iDANH7YQAFgpeHxugRIcNiKr/wfnE0Uw4oBynHhdB72xlVF
	 H0prxbw/j2El/TOLNkix5V650q0yAuxu7UgFDi3I5RbwmI+TgKhvhKWogwtF1PTw4u
	 WQaufh+9Jrr+JR9RYczAFLc8IRtkQMd73GSPUzr05fKbnyZV1R0+oYa7akqbpLr0cV
	 /DeUPdr8qxcOGAGWtnqjV/DoER0W6H1bJybaSS/8PKaiskRBqX15TgQHc2mB+C2jii
	 Z736pYfIotD3g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 37D464A595;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Subject: [PATCH 0/6] mm/damon: add sz_ops_filter_passed_last DAMOS stat
Date: Mon, 16 Nov 2026 19:10:03 +0000
Message-Id: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAxV+2oC/yXMQQqDMBBA0avIrB1ojLbiVcSFScZ2BBPJ2CKKd
 zfa5Vv8v4NQZBJosh0i/Vg4+ASVZ2A/vX8TskuG4lE8lVIaXT8Fj7JhmAVNibquXmTcYKytIFV
 zpIHX+9h2f8vXjGSXawPHcQJT4AiccwAAAA==
X-Change-ID: 20261113-damon-sz-ops-b4-3857ebdfbcc5
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794856219; l=4336;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=KL42jbLaW3+y5f9RJAaNYDZJo0sdCvb1DZpH27JUO/U=;
 b=X9esLWMWkEhP4E6HhN3S5Vq1gM1ODJaamqF71Hoem0y6pvT2abvY3Er0xEBNSKZ7w2J0tLt/U
 YB1QuY6pfvcBlG4mMNCzzo36wzxj0nqCDXe39JwX0dq2/1MnUCc+KlO
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
X-Stat-Signature: eadkbdwhux9ywgeewjmnhzqi5dxfgj7m
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5B47080007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794856223-911866
X-HE-Meta: U2FsdGVkX19ioggeQjOfS8MiyrFael0R51TWq6AvhP29/n4TK1+d40eYOLGmn3WP6hVfTBw5tfKR7EI2OtBCG6Ikgu5175Vx+DHzeUXQOIw4A7wN8AJW/z86o7TOp2LDcpLlxBUqGR/5T8F3Ru/sHMZgsQNgkLNadg8fLr/Or1g576xDLN5rvMyDesKswWkKRGKzCytBv8IjxYCd8MMx78F9TQP64G76VCbagft9y/kxVNBAYhNbXoPUREFEriRYsvtBhdCEoaafU91JrOcXvM0QczJmqIEnO9CiNNz6VSCTH6L+3ozmylVa56hJP7YeQrhbpX2q9xJlzzo33AkVlwVQG+4cNWAaPTwOJBJo8OrCMsRgJ5b75zx1Pc6Po6zkhmTztKrEAlTVHYgT8ZjkWKFQF76GVhiMg5W6snIXvd+tNbPeZTMKI+v3yxsZ2GCWOLh6p2S4gZljIZQ4x9VKf09LpHq67Xq25O8YVGUnDyz4lgpSq4xEAa3sgH/+a6qrmquWw+CYDZZu+Gj252rjJPJttHChDNvLcUGhx7fxmDCkGt1OsnShd08kCJYxb4PnUbGHbJem+c39bq5njKqHaGwomhkuGiTlsazY0kUS9itDQs0RHRpEtd+Z9RQUh4qQ/grz8u7ov3KNS3BipK9yJJ3pdeWuutmIxmh5nyFCIXZ6d1zGgFzOktnGnjLNlVGGWFkuc8MSL4tOA7wRde4vHhk7n5BGNgkxKXjch/ia1MjL5wKBsfFaT/VT4rrpRpv8oeqac9/DzkdS2hcgAPSzStX5NwbLULJZKrE6sUd9ZJHlDRObtAoq/3C/L14IZIpovHj5I89qDJFU/wc/5v8Khk5DLjlll2H7vtQOyfoZ793t1usmq+hH2LFDrVE7Ed9NI0sZJlembjjGeR2Z12BdAo9AIAJg21w4aphIyy+oreeP439nW2CA+45vyhmH+GzGzlpA6iNwPwHIfO8SJuM
 QD2mRd3w
 Uny4SXPsyiypqOxUBaLsJvQ/gWbg2A7bSqmTh7O/1KEEhj2VKR3Swmjp4og79MRqBGSHsEIvj5DiWuVu/T5mZ1Vyr16QNQiPbwo+RUZA+OJH4NQi1I3tB4iqj0vk+zlDFNTvXGlY1JFR4OpYJJdZpNrbVcI0mnATIBct/amQ5XMf+74CFcPKNhMem0UtQh8+9syDOqSoxRTNUQw64kuLLPTAAtKsCMgt72QyrohaDc4mNZSg/9YpxxtRe4WNywlG9kKOVbvULEHyJa51XYRRtPaH90NR4KWqfvXjlv4O1xojsgSVedKLM172aHluvg6sXaZzR6G/VyhG7bGt611L0Er0K6haGPEm/5NxIvQTDdNHUEHkZNGN58X4+GZXbUbb+aq9rAzhs2fVIifdOc6xr+3xaEccqUA/O6Nhl0qPonuCtLAN/y2eOhkby9QbpUl4BdoPE18+OBr1HU1T2Bq83vHoFv00x8tDDiUyvGZYpEcgkX/ceMVg1afv2sCuE07sE/AajTplaIWSRTwTt8+oCgPL0r9UZn+1sNFfl+NoCTdbdJOaG4Wc1Wn1QM/2osFWCLYfT2+cVFUVnYTJdnahUEjw3ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS stat sz_ops_filter_passed shows the total bytes that passed
operations layer-handled DAMOS filters, accumulated from the beginning
of the scheme's execution.  Users who want the amount for only the
latest apply interval, e.g., the size of a workload's anonymous memory
that is cold as of now, have to keep the previous value in user space
and compute the difference.  To know how many apply intervals a
difference covers, they have to rely on nr_snapshots.  But nr_snapshots
is increased once per target per apply interval, so the computation is
complicated for contexts having multiple targets.

This series introduces a new DAMOS stat, sz_ops_filter_passed_last.  It
shows the amount of sz_ops_filter_passed increase in the last apply
interval of the scheme.  It is updated at the end of each apply
interval, and kept unchanged until the next apply interval is
completed.  Like the other DAMOS stats, it is exposed under the stats/
directory of the scheme in the DAMON sysfs interface, and refreshed
together with the other stats when refresh_ms expires or
update_schemes_stats is written.

Patches sequence
================

Patch 1 introduces the stat to the DAMON core.  Patch 2 exposes it via
the DAMON sysfs interface.  Patch 3 adds a kunit test.  Patches 4-6
update the design, usage, and ABI documents, respectively.

Tests
=====

I ran the DAMON kunit tests (all 50 pass, including the new one), built
mm/damon/ with W=1 (no warnings), built htmldocs (no new warnings
compared to mm-new), and ran checkpatch.pl --strict on the patches (it
reports a warning and an error on each patch because it does not
recognize the Assisted-by tag, and four alignment checks on patches 2
and 3 for the continuation line alignment that the existing DAMON code
uses).

I also ran the DAMON selftests in a QEMU VM without KVM, on mm-new and
on mm-new with this series.  On mm-new, 12 tests pass, 2 fail
(sysfs_update_schemes_tried_regions_wss_estimation.py and
damos_tried_regions.py), and 1 is skipped (sysfs_memcg_path_leak.sh,
because kmemleak is not available).  With this series, 13 pass, 1 fails
(the wss_estimation one), and the same one is skipped, so I saw no
failure that mm-new does not also have.

None of the selftests read the new stat, so I also checked it on a
live kernel.  In the same kind of VM running this series, I started two
Docker containers, each running a Python process that allocates 512 MiB
and 2 GiB of anonymous memory and then holds it.  Each process was
monitored by its own kdamond, using the vaddr operations set and a
stat scheme with an anon operations layer filter, with refresh_ms set
to 1000.  Output from sz_ops_filter_passed_last was correct:

    # cd /sys/kernel/mm/damon/admin/kdamonds
    # cat 0/contexts/0/schemes/0/stats/sz_ops_filter_passed_last
    546385920
    # cat 1/contexts/0/schemes/0/stats/sz_ops_filter_passed_last
    2157043712

Tool use
========

Claude (Anthropic) assisted with the code, kunit test, documents, and
changelogs of this series, as noted by the Assisted-by: tags.  I
reviewed all of it and ran the tests listed above.

Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
Mattathias Pinchover (6):
      mm/damon/core: introduce sz_ops_filter_passed_last stat
      mm/damon/sysfs-schemes: add sz_ops_filter_passed_last file
      mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
      Docs/mm/damon/design: update for sz_ops_filter_passed_last
      Docs/admin-guide/mm/damon/usage: update for sz_ops_filter_passed_last
      Docs/ABI/damon: update for sz_ops_filter_passed_last

 Documentation/ABI/testing/sysfs-kernel-mm-damon |  7 ++
 Documentation/admin-guide/mm/damon/usage.rst    |  6 +-
 Documentation/mm/damon/design.rst               |  9 +++
 include/linux/damon.h                           |  6 ++
 mm/damon/core.c                                 |  5 ++
 mm/damon/sysfs-schemes.c                        | 17 +++++
 mm/damon/tests/core-kunit.h                     | 92 +++++++++++++++++++++++++
 7 files changed, 139 insertions(+), 3 deletions(-)
---
base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
change-id: 20261113-damon-sz-ops-b4-3857ebdfbcc5

Best regards,
--  
Mattathias Pinchover <mattathias.pinchover@uber.com>



