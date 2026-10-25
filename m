Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD206606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=AEItL2OD
Received: by kanga.kvack.org (Postfix)
	id E31BC6B05B2; Sat, 24 Oct 2026 22:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2936B05B3; Sat, 24 Oct 2026 22:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD13F6B05B4; Sat, 24 Oct 2026 22:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 913DE6B05B2
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:18:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C90C214048D
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:48 +0000 (UTC)
X-FDA: 85359540336.06.9F24BE4
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0FA66140002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AEItL2OD;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1r9lv2JLQ4NzTK9KfK4WRWnT+ABvHOtQg4UlHpt8dgI=;
	b=MiRaXi09BdLGAfFlhQJfHXLGADIPQ53mRxUe+QLCrPkrIB9f6Z7PHfSrVP8m8dYSZgXBqQ
	bnqUFo4eWql3neoRHzd85fehUwAUZKeHtS4cdhFOxK6joEMkhXBrMj+zm+R4WEdfuMvLGt
	wuaQ9bbzi0wqoOx7+Rbv+BDr/kwzBUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894727;
	b=6I2H9dqixjqSJfJOHUY5eIrqSTKuAbJXcFnImc63tSwwAuqnrLMov58JmnQNMVhnc4tBXH
	6aR+lnWdut2wTv7jgn4iHJkUx0wfPMXlqgprEvPGKjwjWfUbkp+ha6yEiFfeTu5r6YYIrQ
	VUiWMMxE8hOUNLUQYAhxwo/1AgssiSk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AEItL2OD;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-157fe9d771bso2415502c88.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894726; x=1793499526; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1r9lv2JLQ4NzTK9KfK4WRWnT+ABvHOtQg4UlHpt8dgI=;
        b=AEItL2ODDoBptIzBiue4oMmvRb2noU6pTiQK0P/RcQz88wV7uyajpmWQSTSfYM7PPL
         PAHBjSHA1dOx54nl19vCcNbM29DznQqH2k1EarL6ZRDNDGiDe0YI/qnikUZogxHvTNhM
         1/Myo9rkXDSQ9I7UavZ1tIyUCZ+oeHZ8edRqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894726; x=1793499526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1r9lv2JLQ4NzTK9KfK4WRWnT+ABvHOtQg4UlHpt8dgI=;
        b=J7RPVVrnbYOC2FR22pFYYKFpzEhRfEPJc9lPrXi6Bu35JX9e2w/MXXFYe4s69hx4kL
         sqdwroGIDufFrWflidJUIGJPLlCi3+4ey16qnQJMBXebRsrOKIYJfH8z0kZ2redmAsGv
         mbsW88fzi1H1rD2mftOTRKoT3lgXNMSceDmG+uhclpo45M8UxSRNES/TS0SKt2nVRXMr
         7rB9MsZU3gyrJkc/ophceply01aAt213kXReLwgSjAgwjnl47jI1UG1AwHnWyhbtd2eD
         cfeI6rCA7SMBtthUMc7/tvZMmLqQqiS+4k9YzYqGeTe7ivskdGuv+nI/7AtyJ7x6zE5d
         jTtQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLHsyUnl237+ewwdtdT+QmlmDFqIjcbyYvvk4uCFn5ms8ivXY8kRhlgxUz3TNeJ3qUHjN/0qf6UQ==@kvack.org
X-Gm-Message-State: AFq9FYIGbxYrgNay/H2r0orWHwBeYmuhY2g9a/YLWDSITMFdxZGhX/GH
	8++emGAo9yjBe2zExhoa03mrn5r5whOEEGTQGgbCJuwdScRdMUJX8a1NwoJEm28OPg==
X-Gm-Gg: AYBFou3dRn6PVxmQtRkHLXJm/M4f7W+zdIfgAUJEmUmSiWrZDAjnVAVpK/oT6XO3sBY
	v68H3YMENud4i32Z7C2Izfw8hYzsb/+CHdFfw+bP29R7xMs3JzoKEL5XRN0h2pOh/Gky95lX3Cn
	r4ICb7kIZn22sEDcX/t789369X5NH/RSd9I+3lXMWP7ZjQpE5EUdUK12UW/Dw8OSqYZIFobYxMN
	phOR4exJBnfCVN8+HVTqtY6ylqzPz9kQivd9U/xbOdkBXkgBwR58CtbU8in5cnXACkbCznI8cEv
	HvsD7/+xIsZNPcgKLCG5q82UphMA3RAQksU4x2jqatypza0j+cGFmTL+FvK4/Ezmyuh19CSRBuQ
	2XPv3jnsb+FTZs3meZu0NozdutrA6bWDdXzpFOeNoPZ3si2Q268b/Xx9PBIsle2Tns4BW52+rhw
	tTGs80PiwxVk0rTdCokKN+sZF0GEaZ80fJfL0pCiIPiCNKtKmBUmRZGcvjHv3i6VP5EZKQjQUY2
	WlT8eDLTihi2jMFGbe2gLljt7Y4NaeMfEatnCCPGilsIHofPyBoEcWS+WC6NHKkCcefwuWo3QB3
	DLxXOBjZl4rtoB0tkLhdMpxfXxIJqSaQ1/Jy52ti1O/uuM6Qmy9Yhq81lzPu5pgNsHaDxt0cX6x
	orcWyf/EBMnRnhsmWJw==
X-Received: by 2002:a05:7022:eac3:b0:192:bb26:19fe with SMTP id a92af1059eb24-199376e0828mr5839865c88.34.1792894725429;
        Sat, 24 Oct 2026 19:18:45 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:18:44 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v7 00/15] zram: redesign zcomp and rework backends
Date: Sun, 25 Oct 2026 11:18:16 +0900
Message-ID: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0FA66140002
X-Stat-Signature: aic5mt1dxmgdxq41ehjp91ear1tfj4zn
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792894726-611595
X-HE-Meta: U2FsdGVkX1/mNoOFiVwAhHTQAqechFqJ9HrPploIpMnQFSq3wtieDajXh+1TUCbjy2nlf+wrKsD6D62DwnSLFr91NzElcB8/POokZCQS62L9ZmlT8Q5ITH3hig4uZ7DNhd7qED0lL5gL9FHrqkZ8zdXjjPbT1AfTCj/24ZrY+V0twwzlSazVBcVreTUDO6QsjIC3dL873SNna54v7o4M61JTI58At/oJc9gdu6vEMNbzy4yiooAqlpwMKWqVW8Jpkjl4lcqR03FqimmnGzK9GtqZQTofWp0LxxAd5KllIDkbCXWGCLQ+KSrxwq1K2y/MgODjCfSfa2+whmCffSi+eIw5BT4rE3bm/MNeG4nfhOiXwlp3I5Vo38NKi04si8zKa3c1dswUsdlJ2VjeJrWK/GuMJ/sCpEv3ZWKRKN0kiLlUoQUSOcWU/1j8p6xpwizA626DFLA9D7m+yogkhMpwH3pdBEfO1/HOeqie5GdbnabWu1V8K+oI+Hk7kSL4IRFZDjAiebu7ErjI2tPZ4gDrW9DGKQ92dgCtBWCHfaV7zNxwSrpkOKVdYeLKqXmkvMpYGdvVko/1IaCCZnm3xZ/FfB+ovu3C/2KfyV305pgtKRar1FvJRxUPmAcPlJ0nZocnYv/W3wZ+BgbEUOdFSng1NV2zLZXd7dzXty+FUQyR0H5dQJb/WB3HcPlBipDs+BvfFBFbmddtWlfsi8wkbUeRr1IccT3Bm26MgtQfZq+Xmb8TQX7hLq9I+kYP2+ZQDerFB8N2tEIndNoa86m6fCvSpqI62XrTVq+ugIdO5kK2JwyHBkzWdtYNplTHIOp3wuZT99R//oW9yyyodFxxmHXde1SggHVwElGf/HgKuSPKiAC81gZLY4q1Jq4ghsvdh/XCMi8OPcaCwwGJPrfmW48OFLETcA/MP0SCwkm6XmT/12/M0bInTzYFmuAFRFGbdr99XaXNAfrY/WLRqnUYApb
 MnS5+ZAl
 pMiPl1cFNr/YJQGCClIJ28pfonzNbMGcXxNpyV/8ctm9Vw30UBAPXLJLad/Vxx9NODHmd4TOBA+vDq4YRvwKsSqnG5OxyfOtTZToJ18bStY6Z/8xZPK8ONr/bGZA/kL1JQhv9PTJwWhd7zz0hvtrdxelxPFfdYzltaUBSoHK/+/XuFUHaW8HSYatGQpK2sFe0tYcndWHtOCOJfkPFhgiofAMYYFRYXFYW3KpZ4su0JyqLR5y+ClYDgJC8/nntaLQEene/r7feDn5s9YNmthckafQ41IIENgAnYdjGoA2XOIlATiA3HXq2quRnz/BoErJe9Rii
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The series has a number of memory usage optimisations and fixes
that result in savings from double digits KB to triple digits
KB per-context/per-CPU, depending on backend and its configuration.
More details are in the corresponding commit messages.

The zcomp redesign and backend rework happen in the final five
patches.  zcomp part, basically, attempts to address the priority
inversion problem, that is seen on some setups.  In zcomp, we have
always kept Read and Write contexts together in per-CPU streams.
With preemptible zram this becomes a bit of a problem, as a higher
priority Reader can preempt a Writer, which may hold a stream
lock, but since the compression stream is locked by the preempted
Writer, the Reader gets blocked on the very same stream lock.
However, we don't have any reasons to have Read and Write contexts
share and compete for the stream, because Read (decompression) and
Write (compression) paths are completely independent, they never
touch each other's buffers.  Thus, we can split compression streams
into per-CPU Read streams and per-CPU Write streams (Barry Song),
so that Readers and Writers don't block each other anymore.
Decoupling Reads and Writes results in noticeable performance
improvements on synthetic tests.  The Reader vs Reader priority
inversion is still possible.  To attack this problem we introduce
shared decompression stream (Brian Geffon) which can be used when
decompression is stateless.  There, however, stateful backends (zstd,
deflate) that cannot have shared decompression contexts.  For those
backends, we introduce a remote CPU borrowing of idle exclusive
decompression contexts, if an exclusive Reader get preempted on
current CPU.  We also now allocate a per-request (Read) bounce
buffer for linearisation of spanning zsmalloc objects, so stateless
decompression contexts do not block each other.

Reader vs Reader priority inversion tests (fg reader, average of
3 runs):

  exclusive zstd
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        391k               1,064k        (+2.7x)
  Read clat max    3,208,867 us       5,881 us      (-546x)

  shared lz4
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        972k               1,466k        (+50.9%)
  Read clat max    2,204,467 us       6,442 us      (-342x)

Writer vs Reader priority inversion tests (fg reader, average of
3 runs):

  lz4
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        642k               1,472k        (+2.3x)
  Read clat max    2,393,767 us       5,711 us      (-419x)

Proxy execution was brought up during v6 review, so I re-ran the
tests with CONFIG_SCHED_PROXY_EXEC=y in both kernels, 21 runs per
configuration (lz4, zstd level 3, zstd level 12).  Per-patch commit
messages have the full tables.  In short: with proxy execution base
catches up with patched on IOPS in Reader vs Reader tests, and is
still 26-28% behind in zstd Writer vs Reader tests.  What proxy
execution does not fix is the worst case: out of 126 base runs (R-vs-R
and W-vs-R combined), 108 had a read stalled for over 100 ms and 47
for over 1 s.  Patched never exceeded 8.4 ms in 126 runs.  One thing
to notice, Proxy execution is EXPERT-only option; this series doesn't
depend on it.

The final patch builds atop of decoupled Read and Write streams and
reworks the way secondary streams are handled.  Secondary compression
streams are only used from recompression, which is serialized by
device lock, IOW it's single-threaded.  However, we still allocated
secondary streams per-CPU (we needed to permit concurrent Reads
of recompressed objects).  Because we now have dedicated R/W
streams, we can allocate a singleton compression context (for
recompression) yet still have per-CPU decompression contexts.
This saves a notable amount of memory with some backends and
configurations (e.g. zstd, deflate).

v6 -> v7:
- tested against Proxy Execution, added the numbers to commit messages
- added "move mark_slot_accessed() under existing slot lock sections"
  and "remove stale WARN_ON() from zram_read_page()" patches
- updated commit messages

Sergey Senozhatsky (15):
  zram: prefix backends printk-s
  zram: remove debugfs entry on init failure
  zram: reset writeback state in zram_reset_device()
  zram: move mark_slot_accessed() under existing slot lock sections
  zram: remove stale WARN_ON() from zram_read_page()
  zram: zstd: do not allocate empty C/D-dictionaries
  zram: lz4hc: pre-initialize dictionary stream in setup_params
  zram: lz4: use LZ4_decompress_safe_usingDict()
  zram: lz4hc: use LZ4_decompress_safe_usingDict()
  zram: zstd: do not use kvzalloc() for zstd allocations
  zram: split zcomp into separate R/W streams
  zram: introduce shared decompression streams
  zram: allocate bounce buffer for spanning objects
  zram: borrow idle decompression streams in exclusive mode
  zram: use a singleton compression context for recompression

 drivers/block/zram/backend_842.c     |   6 +-
 drivers/block/zram/backend_deflate.c |  98 +++++----
 drivers/block/zram/backend_lz4.c     |  85 ++------
 drivers/block/zram/backend_lz4hc.c   | 105 ++++------
 drivers/block/zram/backend_lzo.c     |   6 +-
 drivers/block/zram/backend_lzorle.c  |   6 +-
 drivers/block/zram/backend_zstd.c    | 133 +++++++-----
 drivers/block/zram/zcomp.c           | 298 +++++++++++++++++++++++----
 drivers/block/zram/zcomp.h           |  53 ++++-
 drivers/block/zram/zram_drv.c        |  71 ++++---
 10 files changed, 546 insertions(+), 315 deletions(-)

-- 
2.56.0.257.gf7497c7d27-goog


