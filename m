Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A490CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2466B0088; Sat, 17 Oct 2026 23:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AAE6B008C; Sat, 17 Oct 2026 23:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6556B0092; Sat, 17 Oct 2026 23:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63AA36B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:51:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA29B120402
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:36 +0000 (UTC)
X-FDA: 85334372592.07.49469CB
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 132DE160003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Vyqrrhn0;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295495;
	b=ND1kbUxEw/RYV+DA9zmbGyKEEgnt/7j6FAbVM2QKKDa2Cw4H4rYlq5jpSduVGcpjmVXrNp
	5sswGNFF6cmsT8wku5NkHx/8QizrS8o42ZeeG4XjVOJq3WvhnT1qpGh79b32hUxIr2WLwW
	Bm8uUCswaULd5a6QR55GoXhyF5euun8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Vyqrrhn0;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0b/AV3Wg+kLtcKm2wiFJRuBM+/NR2XvgAzeP+zBe6ow=;
	b=5M2ktwz2LAIW7xbRDX4aDUfF7CyEEy0Scz2Y66/PY30eHxV+KW5E967Y+FJElssgeDdD+H
	UdDW69eA3Rm8ot3amtLF2V5wlFC8KFgbe1wRJQ6qlawAQCwaT3Jd2JQWD28g+c3JaDfLDO
	FtvDp+60BSb8tLmrVQtMevxItzQ8jzI=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d577so990051a91.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295494; x=1792900294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0b/AV3Wg+kLtcKm2wiFJRuBM+/NR2XvgAzeP+zBe6ow=;
        b=Vyqrrhn0KFBtbTHRuITgVnHj0njZ23g0XTzDoSwSgb2xOw8EInJfHkalBFn/7wW9zz
         tbobRXIY99MN/rV6Ac7HCcmbiUePwK3SrbRFYR4kMdK8pSArBJlyaWh0lLC3ERw94SI6
         4GgleFwQo0ghij2gdRCvQI1NQmIQrNgkltro0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295494; x=1792900294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0b/AV3Wg+kLtcKm2wiFJRuBM+/NR2XvgAzeP+zBe6ow=;
        b=otOiI7oqOKly6dLmAJOB4pwndFWsgCamjxKG7eJwZd2aQNGFYEstTBJ727xAyDZuO0
         jhrcqlh2zQQJcwuHHEtRiptkgFjNXuFe1rmlAUwAyuZTvxe0NUFiD8FXS+w5GYqspxbE
         0LVe7TmqpL7dscXKhKxkgNWdzUL6FWwCcsbxRI2UcxOV+QoNzNmjewUaf8nbK8bMPlj+
         +MR29etFz2GLb36AJBr98DjHpfL8jBDg+9l23RcFd6G9yaB+1WTTDpBcjfXuTWITRLHo
         dJySTXHEDi4nNw7opIjnGJt/OKWTBjtvGtUTxEgy2nT9jcivZLNyPKHC0JgTjDBBRQHv
         yOlA==
X-Forwarded-Encrypted: i=1; AKwUvByBm/Biq+W9BcGP4sDUxsT2M1LzQ0Nb81ANSV6z7EZtmMtO2rQQvZZwKNnADgEit9A4qXDx/fwUAQ==@kvack.org
X-Gm-Message-State: AFq9FYJvy0CNuKFlI7eTpVafud/ww9iTyCRKR/xcTYEzIEVSra90VUcg
	O8m6XgKGoS4sfPDcerLRzlQEn5vn9WMhL5eWWlPY34jWPxhxq6Rj0QRyUf+R3wmZ6g==
X-Gm-Gg: AYBFou0alqiC1FgqfGfqSzEsBPaCyHtYoLoALkLDSaGyNVOo3YPLusCgb2cnbRYv/hO
	nQkKAWMVv3mRGKncHFEh0PCXr5VwL3Cei+sYKuzcPA7Cw7dcCGeK6D3myLovS4udRGldbma27JI
	fyTYiwfk7++YsmLHtqZiuU+RkyYJLU6hN2Y9jc84WDi3X31LOq5hQjNce00T+Y2Ra/Be5Pgf50/
	EAPQIsauqeivlnu8UrUpQBrIjzjVwvzsOexqMBbyWT86XYKT2WFTrw4qzdXnZoQgWGB3m4StkJs
	6Q51D/jtCPdGRvqYWotIw0yKU2XuKi4/hB+Xyz+e8JaDawby/cU0W5ucdDyz4RBsgBIGj9aUTLf
	h95nxs5Fvl5lPcJv7DANlGfZZHsGmkUt+qCFCY7JviFvXc9hzLgwqP1HuqaSbyjTIs8GFwXePRn
	hdRIi1mXaCC2VwaxJzf+SKMRBBobtI7DTbtrBpHi1nX2kfqLJ0qjyayPWqSDjdUf+tpWhhOXO13
	y26bdK6feB5EI36uP5YEsOSF3WurGL11bAZiVegFsxeLhMUUfF25HEgsMHq2uwHCIjEQ/Q7tLpW
	JU4yhfIh829LrxJI8CRG2JXFhXy0ks1O4HNKTO6X7QjM
X-Received: by 2002:a17:90b:28c7:b0:3ab:27f0:c90b with SMTP id 98e67ed59e1d1-3acef3c3662mr3992376a91.53.1792295493775;
        Sat, 17 Oct 2026 20:51:33 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:51:32 -0700 (PDT)
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
Subject: [PATCH v5 00/13] zram: redesign zcomp and rework backends
Date: Sun, 18 Oct 2026 12:51:02 +0900
Message-ID: <20261018035125.3120704-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 132DE160003
X-Stat-Signature: ao5qgmux8957eghcmqf1brxh18ag1njg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792295494-124937
X-HE-Meta: U2FsdGVkX19/RxZjHK/PRgtiqXBYRet8RfIfDp0nU9IFrMhvrI9wrJNYHLKYZ9RlwP0dbbXNLp0v/3gA88uWcFme3NZf6EUUDf0c7UbENmME6PElxTZiHEitX4Nz9SWprejxZmgBCHFhhhEZMa2DeswORlSVXXJgQ16njaCMm5+OaTfGm4OICoI5z6tBHZAt1TmIIpPxZ+b00hoBVsgf6NfaO+D2lA2w7bJYbDflXTflaEJWYv8ufBCdR/XUzaiXseM3R2c0gSNSAkRXtq5O5ztlJgvhn2TjU1cnP8iCQvs4hH63CtYpwqDbJrnzNBksMFJVVtxL8gHwgzNRS/U6YWvhoNlsDcfYMbJBr2NFyMYJT9ukIusC5ofUNmvkzRQ21E+JFpj1Wg6ca5zsh24cHSH3z8/6la3gniW0rPfGjyoAqt8L0BnoWDJLkKJNGfW4QRK1ah16donWrsn11n+gYFZo1jLsq+w3OwzxnukgFQU48Sv405XEz6qiYVmDiiAiGmiW+Lq00G4hcPe8zdN6D3vkNsjl7Qt7yobWMXf8XbR8nyGAvov8gFFNydJiRywNNwVqxAHXHrjK6UFt7uL7jyc6Q0SfacKxM2b3I2hghXvkOzyN1shvqllzyWoLXRumSxczlgtmI3ciURjbSoZWI46r+OOEYochaGE1KZ1WC6UHul+HvRxs5xDeTR9SMhqH+4j3HRHgvsQxV2U3VouSCf/otZlMrQORQqrl3h7i60Gm1XVLyv2+8GHhdQwYuDCGWphN2aNqODkwHOqG1Oh0A5bcgLo7AnWX6eyDiz2WSkdxnnQMR1itSTQOCfaGGgTSw/ka0F1a15Li/BzQHmqQg5VNvt0wjALmJ6czUQXbW4qZEq60C1Z5TclQWV0ldG1EjBm/CmrbbqnvGVLGs8+KcnDNdexRMneGGhV6XNFCNuPyjlCwWJ6LBsMr2DE/vO/tPlLb3ZzwrwArM5tX8Gx
 nizAe7g9
 6RLWm36v7tuKPO4MnUKxELVpmEy4moM/aUgsAt/CiVmqcDnJe4eci2A5ZAV1ogSQQHtBcJMWY8OaAfM/3ieugJCUa+2R+tQQhMB6wY61sR1w1CBQ4TwHXUjj8bgqU6RLmTvPU0x1O9ABAfkmr2ARTqqvU0BiPrJ12siXksUyBXYtSB801fHtDXHEAcoXOXJjiO383WLZ/66LQjCzVZmRgaHBWceTW5+svPPeoGzhs2Zn9CYprwKJl6fFq9DcFOd+ebUjMBjtl1kqLlkb+kIVZeyIvBAWYGN58RJV76Fw06FFqW/xhp2OM278Q0gQ9dB6Pv41W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The series has a number of memory usage optimisations and fixes
that result in savings from double digits KB to triple digits
KB per-context/per-CPU, depending on backend and its configuration.
More details are in the corresponding commit messages.

The zcomp redesign and backend rework happen in the final three
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

Reader vs Reader priority inversion tests:

  exclusive zstd (fg reader, average of 3 runs):
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        391k               1,064k        (+2.7x)
  Read clat avg    49.07 us           9.68 us       (-5.1x)
  Read clat stdev  7,179.16 us        30.64 us      (-234x)
  Read clat max    3,208,867 us       5,880.87 us   (-546x)

  shared lz4 (fg reader, average of 3 runs):
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        972k               1,466k        (+50.9%)
  Read clat avg    11.56 us           3.29 us       (-3.5x)
  Read clat stdev  2,738.84 us        16.57 us      (-165x)
  Read clat max    2,204,467 us       6,442.50 us   (-342x)

Writer vs Reader priority inversion tests:

  lz4 (fg reader, average of 3 runs):
  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        642k               1,472k        (+2.3x)
  Read clat avg    23.97 us           3.28 us       (-7.3x)
  Read clat stdev  4,303.64 us        14.85 us      (-290x)
  Read clat max    2,393,767 us       5,710.53 us   (-419x)

The final patch builds atop of decoupled Read and Write streams and
reworks the way secondary streams are handled.  Secondary compression
streams are only used from recompression, which is serialized by
device lock, IOW it's single-threaded.  However, we still allocated
secondary streams per-CPU (we needed to permit concurrent Reads
of recompressed objects).  Because we now have dedicated R/W
streams, we can allocate a singleton compression context (for
recompression) yet still have per-CPU decompression contexts.
This saves a notable amount of memory with some backends and
configurations (e.g. zstd, deflate, lz4hc).

v4 - > v5:
-- borrow idle decompression streams in exclusive mode from remote CPUs
   when exclusive reader is preempted.

Sergey Senozhatsky (13):
  zram: prefix backends printk-s
  zram: remove debugfs entry on init failure
  zram: zstd: do not allocate empty C/D-dictionaries
  zram: lz4hc: pre-initialize dictionary stream in setup_params
  zram: lz4: use LZ4_decompress_safe_usingDict()
  zram: lz4hc: use LZ4_decompress_safe_usingDict()
  zram: zstd: do not use kvzalloc() for zstd allocations
  zram: reset writeback state in zram_reset_device()
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
 drivers/block/zram/zram_drv.c        |  55 +++--
 10 files changed, 542 insertions(+), 303 deletions(-)

--
2.56.0.176.g3575e65682-goog


