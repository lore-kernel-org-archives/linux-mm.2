Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A78E9CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365EC6B0095; Mon,  5 Oct 2026 08:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D706B0096; Mon,  5 Oct 2026 08:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AC06B0098; Mon,  5 Oct 2026 08:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01DD36B0095
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:20:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BB20140262
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:20:54 +0000 (UTC)
X-FDA: 85288481628.07.23A5012
Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	by imf22.hostedemail.com (Postfix) with ESMTP id D003EC0004
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:20:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Wmsjshs9;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.228.37 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kr2/73o+y15EzbO0RQo9G5wswmWW+XAsy0BXTjIVojc=;
	b=aruApmSStmjiRlUBmgRyLCOwoci9dmGvJnagKsW0d9/DfN/9Z5iAUKzNgoguAkVVcLwA3/
	NGsu3zoeAtyiG9HHSGU3DnLH+mtFPNfaGm5MqYTdRj+NLNRjH1nw+F/iMgYDys4wDNgBNd
	IuU95RFrs5gL/vdEt401QfUj79lzWeQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Wmsjshs9;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.228.37 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202852;
	b=BlxeWyc7UMIDGPNMAUXFSFvJOPIhwM3M8TEoF8RoXp6Z3KUh4fWba99EVgkvQd5mJ1ZagN
	B+Nb+Qme2wDLuC8oVbrsiwO6GLE7AgwwQqLq3+Sc0rCjK5xYlUIVf/3XpR9xj7kEtbYr6O
	uUs/xYQwXQsy+2XJEJB3pcRuRTIrgNQ=
Received: by mail-pz2-f37.google.com with SMTP id 41be03b00d2f7-cc7c9c2df74so361586a12.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202852; x=1791807652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kr2/73o+y15EzbO0RQo9G5wswmWW+XAsy0BXTjIVojc=;
        b=Wmsjshs9kRLvzE77ds+oBUKFW/1SrFiJt45F6OeBwzoCQNfRhymZ/e8Eq6/YqJjfJJ
         qRc/GrNyjyDD2l2mc3JPxw2xm0O3EcGDLb0NJC6sfWRJ6xjMmobRu4EcLLMYPcWfVrGS
         7lCuP9Bg/LfLfwxg2wRjzsWb1dLsHRFqZUNTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202852; x=1791807652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kr2/73o+y15EzbO0RQo9G5wswmWW+XAsy0BXTjIVojc=;
        b=mCakNIrimb/YInutZZuBi6cOW63cn4ZyxV5VKSmUo9Ag/ORaJh18esNSbyRw+tIfUi
         4cO5mtQ7eERnGqfq/MXnhtDY3I9+6JmMh8eDztwSbf6Fl+R3513cAVyHtN5Hlznz5yRF
         ThTC9mPeaZfaTDVNNifnz7l0c9DzIR3V6GXwDCc2Bwa0y2BzRX7mSzyFLWCHpJZuj4pU
         fgfMw60JvTfFeAqnOxPJuMq9m6efIJblije2VTwsUOwgxxsJm2Z3eN47X1MYEusrDIfR
         dCl93a+MQ9tvUiqiN3d5ks3c+DLOxUCPEiT4UAIKhsKl9BseezbozW88nC3nqz3KwaqR
         WDvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwnfWwShWpvuRfJqd+dYLfQlrmwBwsTodxweolnnp+sIeUOI460lcNiFGPgs1SnAS84ds0zLMbBSA==@kvack.org
X-Gm-Message-State: AFq9FYLrKUEB4skYXzrQyr7A+SH27xgVe7GEN0xL8NV+6cUKH5UwIc69
	nFQWAuENMEtlvZPXoWGdUU3nh9aKTgQejKI8Y67NhSPuAGN/AfP+Tik3YPh20/4f40rLiOccSbC
	i5+U=
X-Gm-Gg: AYBFou03bJL+U1NMxLi5AHGFc0gva6AAj2+RED77dRkPU+TIiokPVOGTna+ZuduilAK
	7HLLGsAJXuuXRkS8MSbxfOPLf+V8HZWiOd2KhmoPQG95L/qivhq4+KOcd5swQpdxGYJ29vEiDFL
	gVWt75nhF2HGgdRq6R2OwdPGmO8GvVJpLpi+Z0jHnRqoO9xGg+oX+gXm/wwBoDcKZYbEjdNqxRn
	6rZxcr8YzGSscsYio3xk7FRQxR3SEt/1Xn/Jf9RmmK4lTNfukkuU6QdHtZaJLsIHaX8wH7ESPFJ
	G8YHyJO30wOriEqZJNU/7Jpo3GhLe4sBgUOla6o5rKPndAN6xPFQFZhNq0gOd0b4BiMhvVbz+JQ
	6Nr+7e/9zx/SZA/jx28aZE3FMgQ6CKSCoIwgWH0wa3GqlW25hnHlKRQn64J42qnndOiChEZRmJr
	dLZPWNfYAkhY8IdYqVlCXRGHOGJbI89xa+mBC6dH5ECWmx+dp728or6D4HOqJMz2R1oF6qmonRa
	C7xXx6tT6h07yKlqNZhtgph0eJMCmGS/aTNMCCHWoIDLqnzka5fSX4iRMDq2QEP
X-Received: by 2002:a17:90b:3ec7:b0:3a0:2900:f55e with SMTP id 98e67ed59e1d1-3a6cec20416mr6577046a91.29.1791202851545;
        Mon, 05 Oct 2026 05:20:51 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:20:50 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 00/10] zram: redesign zcomp and rework backends
Date: Mon,  5 Oct 2026 21:20:15 +0900
Message-ID: <20261005122036.718976-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D003EC0004
X-Rspam-User: 
X-Stat-Signature: 8we6nejnx93kwf6etge7xru3icnczy6i
X-HE-Tag: 1791202852-251597
X-HE-Meta: U2FsdGVkX19DOnT/XfWKWDpSVr2KQaav820w6r5KI51Pxs8fuN1VtAuQ6Ipd0YPbPBgSfZVTyJCQb8GjPPdyCWLPt8DEMHfAN/fYwCXnbumi6wtqnB7dMY75L7ZsdQqi9SSgByzfcK6F+MMcprz0465wgjwBUGA0T2m7wdc/EQ6SNZsO/lp4G8S9hK/Dq0gibOmuPV8ACjNR4LBoEQyYllofJEBdpIBWWqMymmJm1kkr94Mz954xxKzi0AW2bis3vTpUc/fDNhISR8g8Q/gho+PGoSbGxycDQJIDk5KPXqwS++cCxjMKNj1o9xup/lXLW9/78cW01v49rZCAyZQBGuRkX2ywBwgJlxovmJE3nBJTLx9IvcfaEkL4NQh7eD7VDLQwheegg3F8DC+T2hyDkcserp6jGUfu1iLalc07Qo8pMKhuV6BAC+774gEaJWSMtVuCbLQZtBuK32UfUF8lMqE3M4epdJxF7tQJ45xeEhpiPeh/Xmq0L5EqcQeXuAWA0yQcyW/362XV3moI3ndsypoQS8DN+LFYpWTWh2k9pbgICCLwdoKapJt5DUzMJGzwtfu3jpOTSAxIH4mlTNLSWzWypBY8xx3PWlTgC7rl05s9ACwaMS8Ru0d/1u/uamwvCT8jBEqyPeGB2ZTEI9Y7IfJNFJLemRq8TIVT0InhT2kpsm+v9+3OkT4D1PZ5Yy03FW7+T6D3p3jFfhfD0VTV4zbyankSqISzfNlPv7j1EwZzh9QfpWzJgdFPNqJ4D6lUxkmSO0of//ZnBGTeR88bOnel9PZhArkxH4hNHVVm6vNxelXNZE9wh8AHpsZyjxZMV055F+vx/vOpu7SUrnbg4GU1AT37PfJ0wx1anmsNokqqpuxNFC5uWklcTKlj1VKi6d+vArkBejqrWcBotKeK3ARj3Bw64OOrVqgmhlerQohCDoM8qlVZNdvP3OloEMO3LS56nTKX7RDB7AIvwjv
 ozmFDcVl
 h2miQP9iKRHbwEQkgtOSEy3DuktaXgBoOsoRPS6c4aNtziAZheP54PgXJJNX8zohd+ZogskRIQvP02Nx+W3r+eHdorGjzlwBPhuNJno0ZuG+kHfIGw9DpxuGrWtK4IkLs4JX2nPt/EhmjBromNO1/FRWOoqdMrfWhOUVtbYfwjBfkh01X2CbWYaz32riS+GOZwCWKfF12F92xIA7DDW4s//9kG5SuI/j4QxyA6ugUWrMJMgw2PS7JdtA64P7AF513AmIaE6Kjt1mFEgkWAyXj9wBY2WVi6grMadcPvo/JxDRWVLXJL7fJ7U0acDD0YhJsZqN5
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

The zcomp redesign and backend rework happen in the final two
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
into per-CPU Read streams and per-CPU Write streams, so that Readers
and Writers don't block each other anymore.  Kudos to Barry Song
for the idea.  Decoupling Reads and Writes results in noticeable
performance improvements on synthetic tests.

The last patch in the series builds atop of decoupled Read and
Write streams and reworks the way secondary streams are
handled.  Secondary compression streams are only used from
recompression, which is serialized by device lock, IOW it's
single-threaded.  However, we still allocated secondary streams
per-CPU (we needed to permit concurrent Reads of recompressed
objects).  Because we now have dedicated R/W streams, we can
allocate a singleton compression context (for recompression) yet
still have per-CPU decompression contexts.  This saves a notable
amount of memory with some backends and configurations (e.g. zstd,
deflate, lz4hc).

Sergey Senozhatsky (10):
  zram: prefix backends printk-s
  zram: remove debugfs entry on init failure
  zram: zstd: do not allocate empty C/D-dictionaries
  zram: lz4hc: pre-initialize dictionary stream in setup_params
  zram: lz4: use LZ4_decompress_safe_usingDict()
  zram: lz4hc: use LZ4_decompress_safe_usingDict()
  zram: zstd: do not use kvzalloc() for zstd allocations
  zram: reset writeback state in zram_reset_device()
  zram: split zcomp into separate R/W streams
  zram: use a singleton compression context for recompression

 drivers/block/zram/backend_842.c     |   6 +-
 drivers/block/zram/backend_deflate.c |  98 ++++++++------
 drivers/block/zram/backend_lz4.c     |  85 +++---------
 drivers/block/zram/backend_lz4hc.c   | 105 ++++++---------
 drivers/block/zram/backend_lzo.c     |   6 +-
 drivers/block/zram/backend_lzorle.c  |   6 +-
 drivers/block/zram/backend_zstd.c    | 133 ++++++++++++-------
 drivers/block/zram/zcomp.c           | 189 ++++++++++++++++++++++-----
 drivers/block/zram/zcomp.h           |  35 +++--
 drivers/block/zram/zram_drv.c        |  51 +++++---
 10 files changed, 421 insertions(+), 293 deletions(-)

-- 
2.56.0.rc1.315.gc6ed9934b7-goog


