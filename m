Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23347606A323
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=h5ZIXq0N
Received: by kanga.kvack.org (Postfix)
	id 2D0146B05BD; Tue, 20 Oct 2026 22:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280B16B05BE; Tue, 20 Oct 2026 22:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197336B05BF; Tue, 20 Oct 2026 22:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4B206B05BD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:42:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E126240445
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:46 +0000 (UTC)
X-FDA: 85345085532.24.20E8CE0
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3A93A40003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=h5ZIXq0N;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1qRBobvsLUCIbGsbEwiV9kaRSV7ZvIaGMjGH4r35+uk=;
	b=ssAUZGrCoVpgYYLLp+l0jSzCmGdbnG+XTjZwyjFfIGeliRYwr7ZlxeCxsofDj1fhin84Q1
	fadlxOdRvs3omO94symbHgyYN1bO9aN2Wk66ACxhD2Vl6dzKulliQFptSJIoZwI7/B0oPJ
	EP1UP1gZ7ujCkJHonK3Y1MiJq89Z41k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=h5ZIXq0N;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550565;
	b=wOJ4+7wd2yH6kmW9RuFc7mi/fiSw4SNRrzYVu+fWy0vjKTigCkd5El6So90LqR2fLNzdkA
	93En7irJb3tqL/rYOB9he8geK2f5hL9DdfA4SxM7M3Z7QfLvlYi6Q4VPLLHIMOvru13JE+
	4OVSgd/udrrAQHuh8BPD+XScFXGG3tw=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-15354aa70e8so777738c88.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550564; x=1793155364; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1qRBobvsLUCIbGsbEwiV9kaRSV7ZvIaGMjGH4r35+uk=;
        b=h5ZIXq0N3eKtwcsIe6PR69/C/PxXUIIa0AnkUgaEWZsLD+OfpwQ6XguIbXDcGUiJpz
         au5c3f/u64ziVZcS3qXs/2nmDFlZ4PAwzb4ahTJ/HNb1OZSvRlBBfCzDFcHihN1H0QjN
         LJyzL3XkBiNSRS8dIeEqol6O9eFWAEksXflJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550564; x=1793155364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1qRBobvsLUCIbGsbEwiV9kaRSV7ZvIaGMjGH4r35+uk=;
        b=kxkd66MglZzOcn20ydYR+ugy1Ww7T4XN/fdQokZlQj/FsUxsLyBFCKmy+TNaW7kAMC
         TM2uwZTa3t9kmxzsVgzhM/vd41QSnCgr2yzkPMSX+ctOBhUcpgTM5IjewXU+FUlZJE66
         iakzx9P8GXFl0kTUlnuN2YK/EKkUEtPBumGYCQrLnx9yTbZmL3dVezItvqp+aBoHQLTn
         HH4NNGMV9fBXlrf9LRzO/oj0NOHNAzhBnFMb4x+E7RE6SGslXU92x/dYX/fKzzLkcIgJ
         awVjJnq/Hmxv0/WTk0gtNeffLQhsGM/hJkDVRBtqDBYiCbozJxN/asIpzbVYHtu+ee3O
         dJZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzK2XPcRdmmP/PxMvTVTWSHD+kMk8XhVnoJcv3P/tuYhQKAOMDI/mvu3Rx8hgcuNZBk27tf/yO/jA==@kvack.org
X-Gm-Message-State: AFq9FYKVO4Z4cRet28TIR0nVYmoA3f3RDXPXcMB635+mKHQg4LACuHKh
	yrl5YfXh8ax2ovcmzPTDrrBRAFiWLrR3u51dCO6Uey6obxzRCbBM1NE/pFSPvv9WCQ==
X-Gm-Gg: AYBFou2y3GcFqRwhs5ZVK0naHevxY2bNaNnJ4jl+r8CWDTapddYdSQhjA+cr2aJAKGN
	QLvnZ9piJ2yfXlgk0CgKwYk1W/veYWCTjPU/qnoIA2MLU9d+mM5B+74vzoFertkb45KXskRNGR5
	jXrPLfI+4TyVXdawoiKYcoYbz9bIhEyz+Srbz8rAGbTtHQ3UfsLM0VzYh5xOaeTLWvZZd30je+A
	Ub/T2n7zvyQuTOwpRaEbx3RTLcan8xSZ8SQbRqDl/jwCdrIy462z/HZxx5KIfrEvTJLJf+lV7oA
	N2yFIHgaoHmE09dbzUnoKBPIlxw3f28TI/g4A8fmk5tk5qROI2TUMbG54EO2KMh4WO2ranMdcEF
	ulWa8rXZGeYgHtthk+aywZ2gyUg0XbFCQFatnc50l5JqvjQyW7mOooV2tVKvvGYqD8Zb7giz8k3
	nlqnzp0ZGrsJJGXj91DNWOHqruxrBc9I+Ct2FxD+Zu/UlJ6fkjyl4rtDuUIT4uUXD0hTx0xYQY2
	aP4C/zbP68/jAx8z9KoF4/3rlDsz8QWg3yFEQU8uzXX+t1Ua8t/X762Oj+M64P0v1lFOkCS2tCi
	atz3SpBliL2nSnYfqiaIZ1tlBTwjJ74gVWlAPf6EyFSq
X-Received: by 2002:a05:701a:c90a:b0:152:92c6:8b58 with SMTP id a92af1059eb24-190a6adaa1emr781617c88.35.1792550563732;
        Tue, 20 Oct 2026 19:42:43 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:42:43 -0700 (PDT)
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
Subject: [PATCH v6 00/13] zram: redesign zcomp and rework backends
Date: Wed, 21 Oct 2026 11:42:10 +0900
Message-ID: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A93A40003
X-Stat-Signature: dsgf9gnhmmh4bqa4txsbf3cxfa4wwfmx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792550565-258879
X-HE-Meta: U2FsdGVkX18ZzWZLZAjqdSbZpkDV1Lhu2SlOByNHLl2YTHFs3EhsvssRThmO0SFyo5mZ7hcKJ6Ad58VupoMvfUaAiF651pnBY/X3ZaiKV1aPQtzx52MWymTsitgKkZ5iI1pqQjOpljgD+fTYKlcgg4bJOFLpovs9+LVtsB5lmiL83cnnGW2VDtne+UgUU6gxJA/gI31XnM336IeCTrhuuR1kVZ5wnKmlAMSYmLMRpFdkW+dCoFlXD17k6LGekXhfM/6VVRBJ+UiZieIdZL9vZClUgs64V6OGLfXXwr2XNTfi5f8ZZ6T5224zAFj2SrBWP9LMD7X3SaQRMg9mT4NVBFBxEq8XkNYBcb5hexp8bz04HhJ5ZRjv2+LzLKNHkWT71B+adwMQly0Jm03G21FHY5yvQuqCTNizJfD66LHf7YQgO7y9CPfjGQlHh6qgbqupPIeN2Fnrhdd7V5RZmXdrUl+4OyS9OPoMXd1utBfPI+ayTcUFzmqDRj9P0rKJjDHThLGS3FiEI2tKaSwh2spATBxadQGVa/Goa0EJpOiIH5+5GDnzaUz3v/yd5n6Aks5pptMyyiHH9zAtAMcEFGytA3IfSE7m/gUJV2+lYpwtbpoeOe2oN1hEmC3Xt+vTkyJVfPhVvN8/ypegubU3vabaqrZiB7Uu5t34SmtBDqzMlbLOLSPLSVvI/QkwUb+71KF9x450x9ijUEju1FfZ+ndzOxdUbqbRo3uf92s852gyR1O+HSXmHRo8L8ajECl8zm4IM/jUILIHFn0++FNep1vzjGvJGaN3M76O5ydkrgqu+AOsc3TqnjfU5g9miz7P2Ygy4E9gokm3PJNuDhncLvO8CHqTpF7PXo2oB8pCGSWwOs5ncuDSQgewCj2BhVoTA63orIFtpxrmX1XoN+akyDR1f8UUrGI5gI3pvWc1j5e8Dp4DTgamyEpl8sQ6qkK44I6bVNS7eIB/kb9sLFm+9bu
 rTLe+/TP
 8nn82nzncNiTXFARrdaqgIqZeQTroBwG4P6mUnhYp28CYHCbXPeEKmQFblyRtVnNav/rjC6cuxGTxYL1gvhm5gCKplWjkdS64c8aeIWLBRoN35wHbYLowqAA0esEDZqjh0ZgHAaXCqkoIRqYZvA/HDC1vaxmGmbjnsgRT2txRnRsk0hKtWP2ZiioeOrhE/GV45V7Dc2nY5fbxlQyEQLC/lXw6S0EVVV9Dg3VAr5jHxQdx8FXqAjuBCxWpG5Vn+tWiaqXQK5KdZzrGDnJN0tKRZFAESclub88yfoTMHMrQ5qDfZh+olyWHVfX558qLwzR3LOHn
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

v5 -> v6:
- fixed for_each_online_cpu_wrap() argument evaluation bug (Sashiko)
- moved the "reset writeback state" patch up
- updates some commit messages

Sergey Senozhatsky (13):
  zram: prefix backends printk-s
  zram: remove debugfs entry on init failure
  zram: reset writeback state in zram_reset_device()
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
 drivers/block/zram/zram_drv.c        |  55 +++--
 10 files changed, 542 insertions(+), 303 deletions(-)

--
2.56.0.212.g129ede20d9-goog


