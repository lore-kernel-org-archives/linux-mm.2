Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33E6CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73E26B0088; Mon, 12 Oct 2026 23:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25016B008A; Mon, 12 Oct 2026 23:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AE86B008C; Mon, 12 Oct 2026 23:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE6926B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FBD31A0AF6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:12 +0000 (UTC)
X-FDA: 85316230104.17.34FD4AF
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5633B40003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ko0xpyni;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+RirkidvU39UtoRFdOSmmCxiKM73vm7nm9nipwtgQMA=;
	b=hzyk8LrV1aeeYt7nxmHjryw7CpLb/mSlrzwSr404eOLcLcU49ig9NZrizIu5OCEfDsP1hb
	IlNgNotCHslFkz8FDy/xP+KlJgjzhOk0QQJh79GHjTjGGQoaACxsiGcwxiAnxBpsoN8FeD
	RxA6vMx2SnI7kHTNHMAxQ+DDjwTK0sI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ko0xpyni;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863530;
	b=dZI/F7HjHvg/dbYqErUxGtDcPN1+ydMJink3415KWnwiN/VlPmidwZmW1tVgY9FxPKWXBM
	4qBhbhBLLDi0KYcwee9CyqySMijhYB7b0r4J9BgoafAK+y8u+9Fx/I5t9+rdoTlax8A5iJ
	qKCfMglhBaRdBEzF9pm0zqAYMelZ9Q4=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-89c45f14afdso278053b3a.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863529; x=1792468329; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+RirkidvU39UtoRFdOSmmCxiKM73vm7nm9nipwtgQMA=;
        b=ko0xpyni9a6RYz/1TGjyjTAHDlOnH0B3qJVl+5555737IXPS6w7uEmkl5g+VfaMzMr
         tPVmhqTGAbv98yfD/iGZ5WZJw/gzCevyDYvFc0Nx4ilvMiSx91M1MqYE2+ZZbBWJbgT3
         W9PeCcalohHtEmk4A6RYFtOJfrnqXFs0lXphQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863529; x=1792468329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+RirkidvU39UtoRFdOSmmCxiKM73vm7nm9nipwtgQMA=;
        b=sV/pgnAUmScwTuw+NCdE0GoQWGn66eol8FItst3b9jQzt6by51G2PrxDsOoiKHABhN
         BsHaVwnZumvV2+p/NaOaohmGfDujZgSPys+KNxyPUqHtko5oRPQPTS4listFw3K6dG7A
         F1OifPzoP2ItYFs04Az+3yHd1U1Df7v2OO6w/PZ70IicEbt/2iHhu64YvWut4gMA04jr
         FISo48BJVN3FUphdzs+y5CF2HTYtUFHi3kGSji3SWcjl262PBRJI5EhceumpZcD5eiAC
         JL6Xdr2zfE3THVEFwp4RuQLJT+bEJojgqSx4Aof/C8lEHfiY+XQbbWlVZrOoEIAQtHQx
         wsbw==
X-Forwarded-Encrypted: i=1; AKwUvByw1TjEOgmJuDGZ1isLVPHoesaCR2ZF5TyPcu8fjm6yTUcGN68R9DDcvOMEDABp8rKxleQLmCfb8Q==@kvack.org
X-Gm-Message-State: AFq9FYLPM9tQpvrJzj5S0LMoz1k/hPRUSRH9OLDXN0gnhbpaZ41LjYkg
	Y85uqTVnJq1zaehAcnAlCi813VUNINYlXZv/6kTfkAo/6qT9B3zrhsaU9ZAv91TDW9Ev6jbCxqj
	5mtA=
X-Gm-Gg: AYBFou3bhlObvs2/k2kdxxHyzSzCKE3y5QBOARzSP4rJ8KaYBJfsMlIc7O9v87eK5DP
	mcaG5Yto8A+1mqUbyico92foYomlFsRmM/sj3VoyhJyR6wFJs9SDZFzZtAWyWKZhlBxcE8FK80Z
	uFZOjZr+bl3VchwD07alq10JAAaONx0yCIEoN0Y4TXq0UcloDf988V4ekMWcAEmSJqwexzO1kP0
	YoxC1sZFqKW5vKSKrvOKq69N/LoWa2s50o6HSqdnPZYmIj9SubN7keyCYr6zZrlcRdw6s+6DyFd
	sOAH0I9Mrr2j3l062ORtraQDuRqjkbzjEQk32p0zMF+4tYMFtq7AEJHXmyuxGBrCsAOjoVjEpLu
	QdfyNHU787zwOme1s4q+B4ks+t/3cBzr57zs7EkzFKeo1MkFIAx3m4XuBTjX5ZM0AUyn9sp+Xbj
	78+JlfPkE51ZoMNOrZqaufQqsH0kpPa5DWwRDNObH60usSrbFC+9J9mTZXvAi7g0pGdb/onYabF
	XVwkrdcmMSYJBs3jFr4s0dyW00QiGKEOfnY/EwVAZ379jOQvEmZDgO4kwI5Ow==
X-Received: by 2002:a05:6a20:9d97:b0:3e0:d508:59a6 with SMTP id adf61e73a8af0-3e16bdaa122mr9096795637.13.1791863528987;
        Mon, 12 Oct 2026 20:52:08 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:08 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 00/11] zram: redesign zcomp and rework backends
Date: Tue, 13 Oct 2026 12:50:47 +0900
Message-ID: <20261013035201.2809924-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m3fzcsn4oositintcr69rzpu5fg7e9bm
X-Rspam-User: 
X-Rspamd-Queue-Id: 5633B40003
X-Rspamd-Server: rspam08
X-HE-Tag: 1791863530-576169
X-HE-Meta: U2FsdGVkX19ivlBj2twI42y42hyK4JRXi8H8Iwb1wsiAKLeaErsff3XQFsJZGppmJKMpStYtT6kFxVLJ1xFbHq7yAL6pSJKYo1kyFsCJVl4vYEP/cBvJ2jMpQAdK9p/TK7Qz30/fbbMoCKXoZNe9Z8owIBgMCOCI+VRNFwMiw9r1QA0recuq/typqXxrh8n1pzZPGKWrjpRYzzcDKnfu4PSnuoSS/cTOOJA9k9Xyq7XE9DOrshw6hLn4zb74zSV/h1Zvu1klkVJizJDT878qoGsxrFQ1uPvk+e7K31op1qafGfq1gqIancMc/+0D0ZGXm32aHn4QlCtp11YLuZnffalSY05y3mkQyT7h/DhbAV2lx63iPjCbV+9IS3HPEWDbrJhmCIP1TGFiLiVcSnWgopDb3M0nLyIVU8tn9ODT51KeA4DxScmqwflV2JieHZpzeg4LvBl3oTF5pzjbtQwBd5/ow/PburMyiJqhONTg0tV/RES/O+djACKRnVn+jNWOfOhEwFV3Ph9ykfNU1gKLfZvkcjg45sDWcxvOsg3/cV00Fr8XVtz3b6cgKDXYJDksgu97DhcLe2ZWGx2Q334o7rEnvF1DmitECuLUtw+mmgmkxh4Qhk7uFkt+Yjv3r5OJ//sChRngCZo723+dASgxCE+EOajB2usIzf82eXoWOP7RPGgQYfpwPbQ/0PZws74CD9qd9XeSkERTOvCLfctOkPSo469Rp5F+j7xpFD8EtfEdnkwkV0dn+ahEkZI58uwP/PaemxyEBfw4MGGmC4+f1yBLqAzpgzJfp9cBPWfOd3azC5twHyaZkpjhkZ5dT25mrnHnT/pw3W9UNwBIypa7peB+Fm46B79nqX2Zrt+dYF3aQx7eFTJdZ5j/mM6B8sv0W2+EgCJs2CqLt1YDLFthDMVH3f6L8hTdJEQE0KSj1SZ+s9Mym74s209dVjvQgaJ4VC6iqo7tyijJffiLNz3
 Yyeb37dS
 77SkaT3MaqYZ0XJUi/GYKZ8Lx5XFGVvHdOHRzdo/FB3j+RQ9bF2J+rwTWPyVLAEPD0f8xTiNuSJyeqJn9/sJsxM4HUvU8Crpsn6wDWRNcxokQasGbMB4bvp8JBGG7luf/BxKJtYf+ts2CJofgQq3ztNUW86/0K2fSZgpMLgsh6EvdxkO73FRQmB11q/mZ1Pc+79eCMGKyVEskLwwnyIVIDWnMr8uyYXpiyytED521+YZk9fZfDbsuw8rWSFMVhwraDGZYjDxIbm0o0IPU3Lh/eDhp/CWthYwciuIgaLLhmSaPV4grOE2r+9fYCxvj0kbu6/9F
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
decompression is stateless.

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

v2 -> v3:
-- reworked shared dstrm patch: new internal zcomp API for shared/excl
   dstrm and a mutex to protect ->local_copy bounce buffer and ->ctx
-- updated commit messages
-- reshuffled patches

Sergey Senozhatsky (11):
  zram: prefix backends printk-s
  zram: remove debugfs entry on init failure
  zram: zstd: do not allocate empty C/D-dictionaries
  zram: lz4hc: pre-initialize dictionary stream in setup_params
  zram: lz4: use LZ4_decompress_safe_usingDict()
  zram: lz4hc: use LZ4_decompress_safe_usingDict()
  zram: zstd: do not use kvzalloc() for zstd allocations
  zram: reset writeback state in zram_reset_device()
  zram: split zcomp into separate R/W streams
  zram: use rw_semaphore for decompression streams
  zram: use a singleton compression context for recompression

 drivers/block/zram/backend_842.c     |   6 +-
 drivers/block/zram/backend_deflate.c |  98 +++++++-----
 drivers/block/zram/backend_lz4.c     |  85 +++-------
 drivers/block/zram/backend_lz4hc.c   | 105 +++++-------
 drivers/block/zram/backend_lzo.c     |   6 +-
 drivers/block/zram/backend_lzorle.c  |   6 +-
 drivers/block/zram/backend_zstd.c    | 133 ++++++++++------
 drivers/block/zram/zcomp.c           | 228 ++++++++++++++++++++++-----
 drivers/block/zram/zcomp.h           |  50 ++++--
 drivers/block/zram/zram_drv.c        |  55 ++++---
 10 files changed, 477 insertions(+), 295 deletions(-)

-- 
2.56.0.385.gd3acb90ef8-goog


