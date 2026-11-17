Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E90606A89D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l6/NGbAL
Received: by kanga.kvack.org (Postfix)
	id 077A06B05B4; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CD56B05D8; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4156B05D7; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 925676B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 263581405CA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:12 +0000 (UTC)
X-FDA: 85446189024.12.0576FB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 11B6E20008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l6/NGbAL";
	spf=pass (imf13.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794957790;
	b=1DntNcmzCe0UgoPF0q74B6V8s2u5QYPGbrKON5SSIm4MXHQsZg2VJKJzYbWaG3zLkjLDWJ
	w0RKx+oT9qfRmoz+B9p3V3bP/YmzzdhGDqROCUK+Ub9pf4J7Ki0rWEJtIUOQkxyNZlSRBy
	4qXdgJeoGbWksA2A8KJlS9Hb1MX8cYM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957790;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QcI1iYp2Szn7s5lOa8cjGgLqtq9b9DOgh+gRlyRZzzQ=;
	b=dE4zL1f8D6li64ndRy8fWVsBdxoR6P/hfLIocOxnmu0WCWJZqJwIaamY0SspSRaVhGy/Qp
	iWTWR32DsGAcIGE/rKEapFSZKQSGIkRSNbCh+gjD++bLuud7L7ZIDQmf7bB74BWV0tn6Rx
	CuMUdGWAGPO9iCSX2qzgSidGvdIpjoE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l6/NGbAL";
	spf=pass (imf13.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88B57605C8;
	Tue, 17 Nov 2026 23:23:09 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794957789;
	b=SegFix1aqHldnic+eCkcTfdRM9uR51/tFMSByK0U5DTUDOXDBgL+Y8quSdfm5DOG0Zia
	 gHamrNBUeblXykWg/ua3pKdVP6etHR3rLbjCo1O91ItBhzU51AYJ+MDgHARk2o/00ASe9
	 ioRACcB2Wg0A9/YHYWBt2LQUIHUWvCUmGGxv3JEs79pxfglM0NtHzoSXDEpogVV5qG9mF
	 /1F6lnCGWugf28PdrDquyEutbl1Q7U1Kr8ZYSjUyNYiw1BvbRRU7QIeEigXXskQQyZ5QV
	 U/MiDqJLOaj43pqfNmO8khSVL4CA2omdoj4sAI0TJ82GFJfk5bl91GcRGw1acL/r2Lw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794957789;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=QcI1iYp2Szn7s5lOa8cjGgLqtq9b9DOgh+gRlyRZzzQ=;
	b=KxNGWDBSRQMwZs33d3IvMmvSUR76Gl7BTHfqNRapfMQfa3X+eL3HNrV4mTnSdZEvFVej
	 og5mekvOgVruzzfHasDC5Y9ftaAFbHW1DH0b+wjsbp8kOVK2f5isTzOtczZu1xUP5l+qb
	 JNJ/JeOKbJnUamZpdfTfN5H8JrENes5QDvpdQ8flVY7q/tjTDMIbA17pNvVPpWUiSqHP5
	 n9Dc39FwW4HYuH2iSYjCfAq+dWnnDMfJpFQF4knOLhxSUSeZXOJuXzSAs6fBb9fx7NFJ9
	 7SyrTLrIPeVp/TNRwOYj8qPKQo3t1o2/9clCQlcjlzdltUYKg7o30GMMvNUzUElI4pg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 424CA1F000C4;
	Tue, 17 Nov 2026 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957789;
	bh=QcI1iYp2Szn7s5lOa8cjGgLqtq9b9DOgh+gRlyRZzzQ=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=l6/NGbALCq4stdMfm4ie4uhGZX23Do3scqC+8bRnkUrH7f0PTeAaXB2dDPRNKhASj
	 Zy364pLfSpLnOV62ZAEAonWJuND4/pVCusWGhkUmZ7M4xCzCh8zjFCeCTzy9RqY2/j
	 7ynnjNnzIQxIkTN8pF/hKuDscYs/KZe3e16r57H7HAJ2tCwDx7xp1zblGq2+CiaY99
	 njjjn7F6B9bA7n0C1djTz9g48BMRli94uaszS9kLjXDkX4YUz00T0CK4xkGsR4GhP4
	 xcF8rhuUy22ua8HJFasr7wSFpfoCAjfO79NlyQ9nxYpb690pX+Enf6sMwqqldrFJlg
	 iufgibn4HQWKA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 948564AB3C;
	Tue, 17 Nov 2026 23:23:07 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Subject: [PATCH v2 0/6] mm/damon: add sz_ops_filter_passed_last DAMOS stat
Date: Tue, 17 Nov 2026 23:22:14 +0000
Message-Id: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKbh/GoC/2WNQQ6CMBBFr0Jm7RhaBIwr72FY0HYqNYGSDhCV9
 O5SjCuXL3n//RWYgiOGS7ZCoMWx88MG8pCB7trhTujMxiBzWQkhCjRt7wfkN/qRUZ2wOJc1KWO
 V1iVsqzGQdc+9eGu+zLN6kJ5SJhmd48mH1365iOT96tVffRGYo9DWUi1lTZW5zorCUfsemhjjB
 1Z/T6a/AAAA
X-Change-ID: 20261113-damon-sz-ops-b4-3857ebdfbcc5
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794957787; l=5068;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=lX/+yj6tp13LokI6+o6FxethEyIg7dcyNoFvFf1Qr+Q=;
 b=gZpxTPFSUoC8+qYn04ZU02GKtqWqJeuDxnZQsHv2rTeTERkILSnSQ60db1s0JADIJ9EVQ6jOC
 G+3GzAQ/VR0Afl77YYhOgijyvk8DZiR3CYg4auP++rgL/uil0BXdNV9
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
X-Rspamd-Queue-Id: 11B6E20008
X-Rspam-User:
X-Stat-Signature: m6re7fzubxn8b5rbbwoxiq7fznd7uut3
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794957789-987502
X-HE-Meta: U2FsdGVkX18vYjKPJuP2GByn2r0jH9VntS9dm/VewWE6DOAmC9PHuQBn0muZ7LuUs4x0KD41N7ACgGfhQYWThozqysRcEKicBOl1GI1Vz9gRyRSVofjjZSlnKMlIspdgUt2VSK/A+dIuI2GdCW3nDX40skyp3vyga/mBac+sJ68kJ3f8Zk/AjjP8TEQ1ihY6JmUX26RNk5yNisK6ALy/kw6oWy7ZR8s5SGJRR3klbepOMVWF7D7jmQ82jMyfZwq2C+AlxUopKgm5w3TeTuullv43qB8sWyz7BZXdkC1BGAYX+hpSE0WbDcddFkuUFQZjp6lZRDHnxvQUTymZTHxFYNVlMDxQ48irId27DdW1oh5l0g6/KEwmEsDLI+N5wCkRhTmlwc99VL7Ofuz0T/BYwQbPQc58HEYOcao3fPnHiMLEbEkFE0ad2I4I32o03oiqDyTFwXauGGkkSxxwUbC6128a1OkW7wYZ6ecW/QVVpf+uF33tu+gtCHKzKJbwtp63mk6UzxpviT2Yv1hOZQefOTcJT92wci9lAj4PlGOFy7PsId2RB4wr6cgBQOpDIaA5Sf/iI/GQs6/GGn50JfPstyiiSp/Lbx7o7pDpSPTduSZ99RJR/LAVlFTguJLn8b1+Klu2OUsHO7LCfUHwPtlTUXysaxlBpa8zuYyoWUxzCtggc61Sy71SlZHtj84dELt+jOvdsafycyqabq4SqYKffeY6JqbJm+X5TeuuJxGreWssjDyrqsjpr+Mr87HIaWs5SQ6bwW7de26xrImwVsM4ew7pXKWqX0g1bIdJlLCW7LuMMoZ+juvCffieXwt3hC1SFT7TRfdfP74aMJYKNCdhmbsgi0sEgR/qMy3rKA4bfA3ODoniiQ2MIRyDnlUggzSx865BkeOT3B7JJZXf+IYWid78ITVs8p7kZzacUW3/b+d1c7tiVNpntpo+nIgXaLO3sS8xJ5t+2VgGDptDjuy
 uc7H8Rtb
 Vspfr3lOhPjff3xXnoG1DWNPu6Cpj+1yZ1qiDvuNrG9iim+Zxfowu88pPtnLcNXzV5JI8bZhk2VI+yIHjbDbZPHbT8nLppm8UjweI6MV49BGxMAdI4bPXLjFtWRvjRN5+ttiyl5Pc2qtEK+elOiIbFwskT25SjpZ3MXyC/7pFwvRumxzu5P8oanF7cmT8+muiqVU6BMOd3y16fbcwA0FTT3kEsmOIwu9OCWUci1iuxVX5JzVykT6Ed/rS1QX7Yl+8BHu6wF0S8k/LQ9IIL4Qyj361OFBQAnx3EtsIY+Blcgwq2oFw4OaeKId6i9bXPV0o5Kdd3e+yVup08FHtlL1tDFETnbQFjQbxkL+IOX5cVqb1PUyABuf8cmlx/sLpgyLcTo76ax7qcZjE76IqiVhM8dByNPbRcnm0w6nhRnkspcAjTKVaZ6zo3S0MmWRfr5c5MrfuBFeRuse8Bn2T+Rz/tjPvgtW6FGc9MJBRVnsokJ/2mX1yX5YiIfeych/uiApV7AL8RCkn1DkhN2txE2NKNGi6qMpPiwVDl6ecfysCvWgZhhnAogOaKmKVkhg8I6WhqG/sRMrZTJo/fWDQZVHTbVQI/F3i5FQs8FkwJl+ALA2F4D9vqPgt/Zj0SJfPr5e+ESifxxCCjVeIzehWKMsDjeys4kS7oTRHk/doecgaHpoFXavWmVVHM8tbbTD0BEmNtofzFN6Jn3GL3zFintGSsnZyLXLRdAFV64WN9fKDlu6LqAxUYx8FROEcN4oSE5OiCRT4KYCSxhHpiP9LGzPPx7xE/4+MghBH/7ctj0xXYQhDbggydBrV/ImSx2gznYxdzoV3BrD6xL0vblo+QfQJMES2+UlRp17Iowzve1stvetyywec3vWvMhOXRHbQLvfB1T/TFIE8SpDMyJJqa7o1ROIBRi21+xkGFAy8LtdAFNzVPxXyFXlMPhvA8FfSJe4kMYuQzC9f5pyIhQ4jxY0PFN8auK2o
 ILEteUMs
 6IL5loj7uwzycQu8uNvltu1mH2eQKLGJOteLV2MYvXB6qJh35uss3hmK0ETxKRd2UfEhiq6iMC1dFj+Cre616iulqGOLKQLHdEoT0lwu8taXIEZ9zbCjA2Y0xCQPvwpk
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
Changes in v2:
- Patch 2: join the attribute declaration onto one line 
- Patch 3: call damos_set_filters_default_reject() before adding the
  scheme 
- Patch 4: keep only the stats list bullet, dropping the explanation
  that the stat is not accumulated 
- Patch 5: wrap the stats line in the usage document
- Link to v1: https://patch.msgid.link/20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com

To: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org

---
Mattathias Pinchover (6):
      mm/damon/core: introduce sz_ops_filter_passed_last stat
      mm/damon/sysfs-schemes: add sz_ops_filter_passed_last file
      mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
      Docs/mm/damon/design: update for sz_ops_filter_passed_last
      Docs/admin-guide/mm/damon/usage: update for sz_ops_filter_passed_last
      Docs/ABI/damon: update for sz_ops_filter_passed_last

 Documentation/ABI/testing/sysfs-kernel-mm-damon |  7 ++
 Documentation/admin-guide/mm/damon/usage.rst    |  9 ++-
 Documentation/mm/damon/design.rst               |  2 +
 include/linux/damon.h                           |  6 ++
 mm/damon/core.c                                 |  5 ++
 mm/damon/sysfs-schemes.c                        | 16 +++++
 mm/damon/tests/core-kunit.h                     | 93 +++++++++++++++++++++++++
 7 files changed, 135 insertions(+), 3 deletions(-)
---
base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
change-id: 20261113-damon-sz-ops-b4-3857ebdfbcc5

Best regards,
--  
Mattathias Pinchover <mattathias.pinchover@uber.com>



