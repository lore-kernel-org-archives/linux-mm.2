Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0042CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAA56B0095; Fri, 16 Oct 2026 00:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB906B0096; Fri, 16 Oct 2026 00:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2806B0098; Fri, 16 Oct 2026 00:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D89F6B0095
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:44:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AD83A7724
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:39 +0000 (UTC)
X-FDA: 85327248678.10.179CCCE
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id B0BDDA0007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AiOl1HZT;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GBrnIo3XSNA4XGYMofOPHvvSVBtQNBIdSVaE9YyG9CE=;
	b=e2FjL+VSgZqEVLjNSGYXQGc7brGV5c6N/pw/ymI9Q9WfZxmfXh8sQwWI7jnw91Y8Tr/Efl
	daveyUd4ckUS5gOuAbQnSvnjsjaqzqB6g3CR/7noJX3kz1cwvG3I26yJH2mWmB6o+PjngI
	Hgr9DmcbSLzSp180GqIqZYV7XsLiNAs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AiOl1HZT;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125877;
	b=lF9ob/bDEHHHAdJrDrpXSD3p7xreAwfVUVmnOAJbZFcJ2t+osrzPFyJU+PD1Z6cP1fq7RF
	kJmfo5RBOtRojV3XCJg+HX+t9KZefXpr9moeSBATKzKvy38LlznqHx6BsSlHrv2u83Vn65
	a4pszJarYKoXTZSKFqFhPFKwLneWYrE=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e6038cebefso45415835ad.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125876; x=1792730676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GBrnIo3XSNA4XGYMofOPHvvSVBtQNBIdSVaE9YyG9CE=;
        b=AiOl1HZTn/6txkST37ssswOiSGM49nj86SWNiAnPdByQpzrbDmr+6lV67fAxa1esB4
         AojDZmHmeh8pihax8HudkmbLyNn5SjggX1TtLK+Sw1IEuNs43pmyJBuOheAZ15lNEp8U
         qEiSTDDOtjyLKbSbdTV6fXVNwCFGXXo9NohVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125876; x=1792730676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GBrnIo3XSNA4XGYMofOPHvvSVBtQNBIdSVaE9YyG9CE=;
        b=jQmbmiKUHr2UeneVLqsckhi3qES6X0UjABKYK8ssA376kupXPJk5ZvevMqhEtQ2sWc
         QH8KB/jL0KLHmuISWdvHaP469FNgLs4JQH376jErBWTuW6rTV9KBvzN17aMAw585u3c4
         4pYBxWEIQD9gvYP74/9uA0qXQMJ48iq1aG6NUfIfXqCSW9aIzbQUt1wEHmU5dtaNIczp
         3GWHASFWlUeurCdQZ1tkhzy6rBhVOXNAJLrkrAFoV492awzVvct2RXDu+iimmnQ7YDY3
         1+8XFkenv6C+KNlCIhu9/je328evZ1gNcK8J+BqjAMEzNSDxx8N5fbtp7nhdhLvDZjFc
         KN4Q==
X-Forwarded-Encrypted: i=1; AKwUvBxABU3dDs51ee9t6rVYyRxkELE31yIelVYcuKirNJMekUgYMfx3r7jO94G/qJTUcZ4bP6unt/AZ3g==@kvack.org
X-Gm-Message-State: AFq9FYKYetcOXorayc549Jtj1EUAD+k0UcakDPE6qTMzw5xsZbX9Lg0R
	/LdgZRn7Y+DmDosMWefHdwxTBVTiM/jO7lczaF2M+KzBYUGprNjPEv3A2Xxz7edj9g==
X-Gm-Gg: AYBFou2z0BVivsL1rILu/CxcscCK2sGgqd8EWFRHq2bVxtiVS1zo+HY1fBuQEkra9es
	xb6scDdRbyOKjcuVxWzNp56bScQzmSzDg1O37PgPRpY8pPIr3SVxSsa6rQowyNpY2nMgfu01VZv
	qeX91wfYMvA71bdH+MbpspK+f4AM+XS5qiFEFww2TpwECR9S4r/1Nx94k1HGj4uzmsirvLIR8lk
	AMIrFjOGI36Ggp/CFESCQP2Vcf2EedVuOfVNzHhS133RhcwDC+OTzSYCHtrMQJV/5qqX8Wi8i+a
	geNtwwHo/4+etz2CfXSTEyqEHAh8C2ZLvLg0dSDeyqZ76k1OCve3hotwCEiV6Heis2qTjA9rkS6
	ZvA8pZvylYehOgSWpf9K6H34bpnIez5r67cZ++A4TOY2M8/4D5t9Ox/EziV67pAqdPD5vzsccUK
	Y2Y8MoRsEu02oUkgaCZtqxNKGu5yreTjciDn+bLRNgTO8sYlu3StHTwRDgmgLOsqWJnGhqo2aip
	s05DxqVJa7N3BsYu46A49NC0BcRFyPwUaIxVV4o0v0+LwScKavjXkMQgw4NGbec
X-Received: by 2002:a17:903:1a0e:b0:2e8:4066:d247 with SMTP id d9443c01a7336-2e842ab27c7mr190565875ad.33.1792125876506;
        Thu, 15 Oct 2026 21:44:36 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:35 -0700 (PDT)
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
Subject: [PATCH v4 00/12] zram: redesign zcomp and rework backends
Date: Fri, 16 Oct 2026 13:44:05 +0900
Message-ID: <20261016044429.1304561-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0BDDA0007
X-Rspam-User: 
X-Stat-Signature: c3wsmfno8dtcrapmwnmjg8cm7qtocrhi
X-HE-Tag: 1792125877-581216
X-HE-Meta: U2FsdGVkX1/lyjnTlN1J+anf6gfSWBnxb1SylaZkIvtY22ys3lnS1WA8+KK8T2opDUwCqauYhQLb0LyrM6t+8HnT+Kn4ib4WH76AQlCiFN5h6MJPQIXem7wqVe+SjiF6tPJrDLcKioHgvmyxVQvb/pBIs5k4F1knl0mdnZN5C97vCxXmINcTriNUpjZEEqptJjXmwkbfd+tqR8vR2ZXJDpUC9rNn7eWb0aBGJrMTq2hpoemLUySNgXIcbu2qJH4r3P9o+Gqvx37WdvJNWtFJbWSsIDF9Zw3WIfoYJgGBT8IU90bwyOZ6owvzUNw3d4NQGEnIBntCKorLM6dLqcmCB5JBonO8ZPb/4CY2udBl3HBAeSBeYpkkbKAPw/jQTNLEtqhKBfOrQwD3gsuiYMbyLYB/cz8OudxauVodXV+V+0IeeBMZfC2sAzsA63OJFYy7s7aSpJNdS07L8UuC8rUFCnVGS4GJ6qXN1V1mbqENRWdm3HxLOryKEeKh1CFCp1zwKs0EmM5ZD8S3rZvrD6ycBp4Q7fapbDI8IBoBY4a+AjFvnAZhfgfPmNmn2/s6+zZ4kkaxLZn1ABLft9Kavi4/NvC2ZdTO9Rsc9zh+1vwNtfynydXXkr78mp3r4v/OHbvrN6Az2MHhu2r/uQ9qH+OA/xNd8032qIrlw2f2aLswWfs3R35lrZAlSfGzf09OLJJwFV1i03JZtFPJKpEWwryZ6AT47cR3V+II/+VAtUr70ukGdjad3/7GfC32xdzqQZm8AkOZe1mSLM2sF7hwQbLCxvpiAR3mgkwbs2MtkSzCg+QvpujQds74BrwVH4jKA1fPtl4zO+AnqRfIRLY3oTRjcpRr9JnX8/1nsAZYo45mX4JaRFoSWUWCdJKzPY6jaaChssobahbdhwBJFNEdrNRwEweSpGn3PoGeH1zpTipmiL2DdYmhuJwqBMHDWZwStitF5X5Q8VqjQ+kJcFxSgs+
 sI7H7BSC
 AsGr0EQPSo4pPGlk1lYOCfJONgnFAuDe+8Oj0p5AhzeVMC0ZpHY3AIIK/UOW13/jpZb8l/5gIK+dX5thk3ObamciYCr0LId4hkbeZDfF6LscMS1IplIdKH0m+ksNqoIdif0EU/H4IXaR2ye90ngen4o15bdwV5UQGJtjG5JPzdmcIkUeIwNWPWz41rJNYsawUT8PCEUDaj/caWFrQXPf8nC/93FjR9AoQ1TH+BUxFq/c0a7q4fw/f++HMj0SqW4UinkADR4JxZCgtpnQQb1mrEbCMvINv1JYV+3YAu+fqtu3tEHjYsaTdgVDmfgBvrYB2FjxI
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
decompression is stateless.  We also now allocate a per-request
(Read) bounce buffer for linearisation of spanning zsmalloc objects,
so stateless decompression contexts do not block each other.

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

v3 -> v4:
-- use a temp bounce buffer for read requests

Sergey Senozhatsky (12):
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
  zram: use a singleton compression context for recompression

 drivers/block/zram/backend_842.c     |   6 +-
 drivers/block/zram/backend_deflate.c |  98 ++++++----
 drivers/block/zram/backend_lz4.c     |  85 ++-------
 drivers/block/zram/backend_lz4hc.c   | 105 ++++-------
 drivers/block/zram/backend_lzo.c     |   6 +-
 drivers/block/zram/backend_lzorle.c  |   6 +-
 drivers/block/zram/backend_zstd.c    | 133 +++++++++-----
 drivers/block/zram/zcomp.c           | 265 ++++++++++++++++++++++-----
 drivers/block/zram/zcomp.h           |  50 ++++-
 drivers/block/zram/zram_drv.c        |  55 +++---
 10 files changed, 506 insertions(+), 303 deletions(-)

--
2.56.0.176.g3575e65682-goog


