Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9607FCA0FFE
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4678E0008; Fri, 29 Aug 2025 19:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D818E0001; Fri, 29 Aug 2025 19:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDDA8E0008; Fri, 29 Aug 2025 19:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80E78E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:39:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 545985B7FD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:52 +0000 (UTC)
X-FDA: 83831415024.30.8F3C8B2
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 996B61C0009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EwMHznhD;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=skuR78/JXGbuWZ2DLQBIUKa7ZpL0m7wYt5dK8i/gXNQ=;
	b=IItFKx25PYkKfUZWxObTbOVLnLZJJadVj/6a9W5y/RdevzOScpjjr8Dp5gw922CZeoPFQU
	sfHF5+VOX8oa7BezZ3mkHiUHqp7aYYbqK+vk4GdrfvqZaB9/GaAkZO98/9fmPuH6ioIWNv
	YpW3FJ2G2KguCP7BEjREJmvBG8Ev/CE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EwMHznhD;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510790; a=rsa-sha256;
	cv=none;
	b=XcSdKRR8LRITHRBZ57YAu5x90dLFS4dl4LdqeJtJ82FsG5KYuXJaK7yWmzEE4mYK0/h2wM
	vQ1AcDryyoxLPwPH2qXduLXNuR5EqEH2bRbIM6GQnohLJgsh2lJNGfvnSxhjVlDxs3GgJI
	zssy5m7SDyxJa0wiCkESqS7/KVR0+kQ=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4c6fee41c9so1826702a12.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510789; x=1757115589; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=skuR78/JXGbuWZ2DLQBIUKa7ZpL0m7wYt5dK8i/gXNQ=;
        b=EwMHznhDw9GovI3bIaqY2dymfV5NLKbtF6hCfuf5adGjviMrgigFU78ivO1/5Q0HnG
         LGE03GhHJ4f8N3MOeVnI6A23ROIebjF54ae+uScAMajx6ibBAdvRJOY7gs/0anEZ9X+L
         r7OLJbRffgcu0lAtSWfXpVMvURZavd1Rk0g0zZepCxi+TyL/nGAIrxHfKWQ5TKvHGjML
         Hbh8K+ZRRYVRRgbOFvUdLz1/eJRH/MJVgEx2Gse8awCl9oRxY7GJGrK24bVGSgZU85J4
         NIwOgirbM+RhauLK6YGm3YUfQomL+Ze6rjmpz2IACABrBGOrnb//siOUS0CoyqGqeSX9
         WhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510789; x=1757115589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=skuR78/JXGbuWZ2DLQBIUKa7ZpL0m7wYt5dK8i/gXNQ=;
        b=p453OD6y+sZczzWV9Iape+FBJhHpYvbKQrWLAe3PVliLWGYLFVA1uhC5d8WXIU8r77
         kiUZtxa7ttFQjag09s52cB7MoNib2TJ5cG/tkz6SUNAYyQz7MMI1SEKa1MMGvds+VQEI
         ByhSwz7+ZY03jQJ8du2TgTeCfKn7nlpRRWCb1mZrvN+evzx6fCaQCqXCjkzFQngn1GBA
         WqibBqDPsRw0d7JlUHRfZ8vZQP+xq8Bfz7xjqRAhijZuisifWGUJ451RfkukqngwENES
         Ild9ES2bffpFn7Rbeg5wNieKxZ+ATJQkJ1LqBySPCWtnXxGvX4CqLDje6ZLCFDbczOnK
         pB9w==
X-Gm-Message-State: AOJu0YwYJzcg90z/QIRmXN8uZX66HMExHTFdrrNIOkU/oy0pg1uGKJjn
	dgVgspCUrJYz+f8YZjFB1DEnqiGJwfYSXNGgCJqG77RH0SeN89ODZ86G31HGFg==
X-Gm-Gg: ASbGncszmdMNJyYsv4i8tbU/sWKYDt0MZBOyCCHEwj8UNweA4NuOV08XFSEzL2TNc8F
	zkUmIHa/pHSptPvRqoL4/PcSpOx4EE6u9C/+iB4N0Vg9+OsnGTp8Zi0HB1o/aD4GUCmDKa97nyX
	8/sRLPeHU73FeKKtpcRUqsXpvOYvby3+IC1m/QynEyawlMcWipjcKfFUGZRPWkfpJtOGPHcCGrC
	c/r+H4a8T/8dUxCc9sFPz39xoEdXfuse0U40PR8Ph/QNykHUTq9ZLygrodw+PdhNl929oMkRma/
	zZt0GfpDecozn/ncfKuk96qLBn0JwEBK0foguzW40TinY7rLme7KGCpdi0xwrnCDx0tlYavLQEw
	KVnmoj27D4ENz5qWD9GpUENoGYC4U
X-Google-Smtp-Source: AGHT+IFD9Zx2sEc+TuW+3xEDSTMhu6/LlCaX3YjcY58K8HmxLokZECokImRcYxjOE6qu1jm7xDf7Tg==
X-Received: by 2002:a17:903:46c6:b0:246:fbeb:b66c with SMTP id d9443c01a7336-249448df282mr4463175ad.19.1756510789186;
        Fri, 29 Aug 2025 16:39:49 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:1b::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24905da1884sm35944825ad.95.2025.08.29.16.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:39:48 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 00/12] mm/iomap: add granular dirty and writeback accounting
Date: Fri, 29 Aug 2025 16:39:30 -0700
Message-ID: <20250829233942.3607248-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wy5yzws7r1oxouj4fnfmjtjxjb18o88b
X-Rspam-User: 
X-Rspamd-Queue-Id: 996B61C0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756510790-808095
X-HE-Meta: U2FsdGVkX1+tLvVhFtyc5ezQcR2Z96sPrbxfLuCOi9nCoo3V/3ybtxaocyXCn3bI9takIFQk0PTRVdyNO5IW7R0cl6izG/I1Jq6sDG4HqO4bjgDwR0WmaATWUmXm4AxJYkyTArYd6G9cv3UvosUpDs7McF1TkVLUkrAMgWC/Tm2CV+dUzknsjNfgqsH33Q4Hl1bruItKr7AsuvI7wKwxg4AAs4SOeKYWZAxKNx5IYVe9Uy2oJy/ESXuqMwWb5p19HhHLYYy8C7Z2UlT7sxkpCwPGPHIr0RlpyPSHnc8Pn09lIDjv48SQ5TeARWMFDPLFJ06iYmfKHgNpy1EoeZxMxHHzJAvmQ023PDJ0XPgDgSrVu4rlY5H6LFVJSB5QWHBdgPqLXzP7kB3k9pVCLv/cLe5o4yhic+D5QpNEzNuPSndSn6ETQtCnrx7XQFUDjlInENzNpEpz/6XMOY3IZQsYKoWrttYB8aPZqVt0WCFWxxmr4RjOJnXMK9EUGBn6KOjKKGpX7Z2qGkcoERkXGqRVgF+/P+W1nTKHWE8LGj57H+gWUmuQ5mRBehRlwJLiLyBXEtPVaVAR+FqYiRHwwc2FgVVr4UF2BT8w7RjtF5z4P85fvCZZckLGEuN0PYu3sYNq3e2E6dSTKjmzGf64xZN0eptutGAJ71It6kd+AggW9Q+W5gun3T/HCMsBR2irenxIPhzQrtRQcpSyRjDE5cpwbaARQ0rNT6j1/6u2uEJm8rXmRdlSUektdZ5Dzcglsy12ZEcQS2qc3JAUarlJnneKuOYj6N7uYCOEiGzcfpwlcCCt+iGhk1rC3PUavr5sSd0xsS2S/OnZ+oZF5T1S7Lj0W3jDaCeMWSQwR+MnocLZIi66d78NIcN8JdR4td9+shCGV8hy9sGTS50K7FEBsbFVkqZ9Tcch2OqUOjdfNxHmqQe+YZWNGE0pKwcHDpoP/IuW4B0y7E5H9Uc4e6g6Bnv
 h+xOnQiu
 C9caeCCbVVm5TKcySyGLMXzkbuIP6fcNE0WVCtZoyWcbW+mxNY69jpJaeAoUdz3CJexSjLT5oR9tb+/BIcAQRHwTK1oMrfgNpRU128YkAEHP21LZR8IV+TCN/dsGd7ZO4hi/O9/SUHddANWWwO3omDB2TTnlHCoQu/IkJ1QQ6dORa35b/dXuE8lgWWspkux8NfEGs8vl81p/+NhnHqnsfpTbjcOgueDRda+vRpsEVNsaLcBTd0nWDL1FbzhlmBDHFi2a31HXhUTQgnaOyWccjvHnINCxp0fys/oHYc0rKQd1iENEVeRP55j5+xFKCHkfWS8oUwCJyEpzeKScHNKBuJ2rTNEoXjvSYn2I/63mE+2rfRIstEjLjviRdhC+eh0jOd34lBkHn9vvlxhspom5FVUy0Z/xfrW7mK60N67705ud7hxuod7BCvoI4M8yqf4wsGT0p8L0uFxm02AdKPutH8LgxaaF1M2JyD0hw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds granular dirty and writeback stats accounting for large
folios.

The dirty page balancing logic uses these stats to determine things like
whether the ratelimit has been exceeded, the frequency with which pages need
to be written back, if dirtying should be throttled, etc. Currently for large
folios, if any byte in the folio is dirtied or written back, all the bytes in
the folio are accounted as such.

In particular, there are four places where dirty and writeback stats get
incremented and decremented as pages get dirtied and written back:
a) folio dirtying (filemap_dirty_folio() -> ... -> folio_account_dirtied())
   - increments NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE,
     current->nr_dirtied

b) writing back a mapping (writeback_iter() -> ... ->
folio_clear_dirty_for_io())
   - decrements NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE

c) starting writeback on a folio (folio_start_writeback())
   - increments WB_WRITEBACK, NR_WRITEBACK, NR_ZONE_WRITE_PENDING

d) ending writeback on a folio (folio_end_writeback())
   - decrements WB_WRITEBACK, NR_WRITEBACK, NR_ZONE_WRITE_PENDING

Patches 1 to 9 adds support for the 4 cases above to take in the number of
pages to be accounted, instead of accounting for the entire folio.

Patch 12 adds the iomap changes that uses these new APIs. This relies on the
iomap folio state bitmap to track which pages are dirty (so that we avoid
any double-counting). As such we can only do granular accounting if the
block size >= PAGE_SIZE.

This patchset was run through xfstests using fuse passthrough hp (with an
out-of-tree kernel patch enabling fuse large folios).

This is on top of commit 4f702205 ("Merge branch 'vfs-6.18.rust' into
vfs.all") in Christian's vfs tree, and on top of the patchset that removes
BDI_CAP_WRITEBACK_ACCT [1].

Local benchmarks were run on xfs by doing the following:

seting up xfs (per the xfstests readme):
# xfs_io -f -c "falloc 0 10g" test.img
# xfs_io -f -c "falloc 0 10g" scratch.img
# mkfs.xfs test.img
# losetup /dev/loop0 ./test.img
# losetup /dev/loop1 ./scratch.img
# mkdir -p /mnt/test && mount /dev/loop0 /mnt/test

# sudo sysctl -w vm.dirty_bytes=$((3276 * 1024 * 1024)) # roughly 20% of 16GB
# sudo sysctl -w vm.dirty_background_bytes=$((1638*1024*1024)) # roughly 10% of 16GB

running this test program (ai-generated) [2] which essentially writes out 2 GB
of data 256 MB at a time and then spins up 15 threads to do 50-byte 50k
writes.

On my VM, I saw the writes take around 3 seconds (with some variability of
taking 0.3 seconds to 5 seconds sometimes) in the base version vs taking
a pretty consistent 0.14 seconds with this patchset. It'd be much appreciated
if someone could also run it on their local system to verify they see similar
numbers.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20250707234606.2300149-1-joannelkoong@gmail.com/
[2] https://pastebin.com/CbcwTXjq

Changelog
v1: https://lore.kernel.org/linux-fsdevel/20250801002131.255068-1-joannelkoong@gmail.com/
v1 -> v2:
* Add documentation specifying caller expectations for the
  filemap_dirty_folio_pages() -> __folio_mark_dirty() callpath (Jan)
* Add requested iomap bitmap iteration refactoring (Christoph)
* Fix long lines (Christoph)

Joanne Koong (12):
  mm: pass number of pages to __folio_start_writeback()
  mm: pass number of pages to __folio_end_writeback()
  mm: add folio_end_writeback_pages() helper
  mm: pass number of pages dirtied to __folio_mark_dirty()
  mm: add filemap_dirty_folio_pages() helper
  mm: add __folio_clear_dirty_for_io() helper
  mm: add no_stats_accounting bitfield to wbc
  mm: refactor clearing dirty stats into helper function
  mm: add clear_dirty_for_io_stats() helper
  iomap: refactor dirty bitmap iteration
  iomap: refactor uptodate bitmap iteration
  iomap: add granular dirty and writeback accounting

 fs/btrfs/subpage.c         |   2 +-
 fs/buffer.c                |   6 +-
 fs/ext4/page-io.c          |   2 +-
 fs/iomap/buffered-io.c     | 281 ++++++++++++++++++++++++++++++-------
 include/linux/page-flags.h |   4 +-
 include/linux/pagemap.h    |   4 +-
 include/linux/writeback.h  |  10 ++
 mm/filemap.c               |  12 +-
 mm/internal.h              |   2 +-
 mm/page-writeback.c        | 115 +++++++++++----
 10 files changed, 346 insertions(+), 92 deletions(-)

-- 
2.47.3


