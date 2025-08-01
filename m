Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AA6C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E0C6B00A5; Thu, 31 Jul 2025 20:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEDC6B00A7; Thu, 31 Jul 2025 20:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F7C6B00AA; Thu, 31 Jul 2025 20:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD8896B00A5
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A8DE140D0E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:40 +0000 (UTC)
X-FDA: 83726300280.19.8E1382D
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1BC8C100002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P4dfeRtU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008058; a=rsa-sha256;
	cv=none;
	b=TacRYLX9l0dYMODyK5WQ15YZAZ156KRA4pH1ZSTM643nD0rKq1YwVXtqZpmvuSTRTmJvsS
	Dmv3BSIOBYSAEliIIzrjrDa7gE1uN+ZuFrIvcQ5aJoLQlTeqc0NVcKSM4neF93z1eFYjHI
	bgbPEfQuUPZIFhLoDc+CyViT63RFkbg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P4dfeRtU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CAPMJh4JRf2T8eUTecykcOIk5D+apWsXjMJdfZ5OmLU=;
	b=UFsX784dID5bUfNROb4PUdfBf3dh1wbtAf25gAlnn8OI5rxvlXjUlK/uIl/OWVAxkEfaF3
	43PWxpLFrhQEDm63oDyAazF1bw4qk/+T44uAExyJ6dhc0D36kXIq9FOsh7MHqCd1GmcVoO
	7/5N9Ias3Vg2idDDgs3telKgxEjdhJ4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24031a3e05cso12215005ad.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008057; x=1754612857; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CAPMJh4JRf2T8eUTecykcOIk5D+apWsXjMJdfZ5OmLU=;
        b=P4dfeRtUq8mip9syMo8viW9YlQX9iV2db7jCcPgWKAoOC15AZjVTMvUI1IeRdZMrbX
         AD7lKjvJSBsrvRFIf77j/Nh4zR6wxFjGy6yuSKU39YqJP1rX77yqqqihmWl4PqDKCSlU
         pCIm5QmFkRYmjuIJLrvF8nMPANxOv6RwQp/3PM94HPVe8TpoHoEnCCmxpNF/IrN3FwbA
         +WbDhwnFmAIlvJ8DnlQB78lYJPibvpvRmHYOS3Z0e1tXaq3pxOFFgkxsIBnJ2vgdswC2
         H4NNjLb/LRGkOUsjysIixSdw32LqoKbiPAKrX5T4V+uazEdQWhnMJl3OmiEE9RKKKotp
         aFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008057; x=1754612857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CAPMJh4JRf2T8eUTecykcOIk5D+apWsXjMJdfZ5OmLU=;
        b=effli5npnlbzzLBGwv5wE9QqhHqeUWrXoKYw6anirjT0w/mQdNL4L7vmzGa8o0Bilq
         G4ygITFaWPA3NZEnSMkALTd5HfgxtIZ0eNqRmZaRBfFHoj/LN49K/3T8iKY+XgkbGi01
         u5YkCQQhuefNS6V0l2hcfOZwqbaFfORXb30j/nTmvG8RtANXork5H5A3LmWQxMZbxKyb
         zzR6VkV9jN5Mx9cA3b25A0Yymr2CNtM5Nmd0g+QvWEwPGcb4GFt9x4L1ZN5FUORBh3Td
         3Fi0UpB5raE6nnOIYomc7qCD9am6VOKjYLxtKfig1Pl4mwkvvZ8/aP6YRV+aJqtUTMzP
         I6IA==
X-Gm-Message-State: AOJu0YxYWxt+y+2fHYBq63gb0Xzu2WiaAHRbNrzDNNcbstPO8zlq8VWi
	JfW9p96Z0rNbJdgRz6xywOOjNoGmpKcOGpCHFDshFKTUFtGwhoRvBzNYmcp76Q==
X-Gm-Gg: ASbGncvp8hxeXC3r85yOBczEr81q/OrgMzC7ankQqpLsp0lpCDlD0eFtaOc3UgFIq8U
	Szub7kukkeqyg88Yv0UtT5vPyI2eLw/g1JC0ej1pqCyccLtDIY7cUy0Nj0R5nrDAfm1sx05IBoC
	/vsJdPcWD7Ng6ZB89qdCA495eNkNfTpE6fjglW32iLMYOB/vMg15/yIBSiRlb55c+rEO1wq0Zm5
	9SMGLorpvBcRy/+FKNPSTNB5hveNLA0realrbmgwZ5iNhoWpH0pMW2d4R0MpBmEMbJzTeLKdYfQ
	+8Akh5SyXJ571W/RIuvF1Y0XWAyQCUPlYpZA3ArSx5JATABOUCFcYTzZDT2KDwtaytxBMDAiWD4
	abZ2v0ooC/NRg8C5R2g==
X-Google-Smtp-Source: AGHT+IHzWNsW+PHX0gfTZBUsIf6NcpFKKaHSrqNk3KKofuw5NyOdzVyboY88paNtVEDHWR8z0e1cxQ==
X-Received: by 2002:a17:902:e543:b0:240:b884:2fa0 with SMTP id d9443c01a7336-24200d9a8a8mr61414635ad.26.1754008056541;
        Thu, 31 Jul 2025 17:27:36 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef67cfsm28592975ad.2.2025.07.31.17.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:36 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 00/10] mm/iomap: add granular dirty and writeback accounting
Date: Thu, 31 Jul 2025 17:21:21 -0700
Message-ID: <20250801002131.255068-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1BC8C100002
X-Stat-Signature: bdbdpzj5jidaixf6nti8eb6u7yucurub
X-Rspam-User: 
X-HE-Tag: 1754008057-397152
X-HE-Meta: U2FsdGVkX18Cs1mFph9+9O/H5YA+06F+FDWMgJMC0loq0m459dNlrgm2z9RBYUrsZ/aGCwUxvzwlkmwdVwRPgd4+qxVwIs1ZaODG40x/k2dyV3WCRtZ/u0dw74cGpbW82qItSTHzaQ8J8EF0JXtpensiXVrTB/lM/8mlvKOIvKBPqwyNsmRxF1+CG1dbL5xaV6BBI9d3k0C9G+ePnsdBqpA/ddAYyONnLUoqdGVXXuGeo/XKrgAMO4pKFuZrDWPoAoUdFyQ/LpnyMM+iDT69j1GdAYZjuIbyjVmBsC5r+MCXqvlk6pAweaVXVosPxquEMcpdODsL/mseCPUUWFTZA42G8rhyUYYtwoQ0xU/PUTjBWngp4+rS/9F/ZyPxqlcrtrc1nBhiP1dIwDFVAPnYkAIQwQnY3q4dS6orkGFLFcROhv8LDwUWTWhVGyehZJrygwpGPt3h+ivsw0wU0gfd2/VH9jIIa8KoGRsPh4QGhKc7w+1LtCgeU6ywPG/NbRs3ZHFcgGCW2ukRqDEhgT1wk6iiQzuiTuWEAtHa2OR+sTB7Bl2PbE2Z6YMFm9QaNVubRr2WzlMUvg4xanvIqPb9Y2XvPEvDLsbPiCdLayvcayivb/aQZXxGfsKdJGOBxOF6crFYLDFW6L0wrZ7bj6ZYTtuY6HGIU/Gv/Nk0uQlZocs0NAf/UmR4DpXhccnsoTwNpgin7i1tgsnnQffGQAuXydPDMzZKb1Pr5gYjcWKF2L4i62v4dhGjK+0ercz0uhNRqxPq0cSsBGP9imj9K7nd8xEcPLyKNcFz7cC89DIvPicf/foCZAhY4JC6GUEzZza4WPHnnKbjxik7zI6EpvYgX7FrbNU7sW3koLapT8UcSOYuXCrYqcrDGEcD9SWZZQTW0HwKTbM93HX4BmfpllDQMfisiZFsT0UhI6cU6AZBsLB5GEVQ55GGiKQf87mMwYxd/ZyHZHAV8QIpO5RvjIA
 wQmz2nmu
 InKP1zmK8I6KJw5PciEEyphc6NzNNvWItfjyWD6S4PiXhZXXr7SD9PT+kzrOvJZjsyv9295vtZ0l2UXRA/O9W8X6lgSsHWPTRJ3ShdiBB2i7/b1KJJzMMR/zGaqP1Glp8HRL42KasNgvCv07t177+Sqdbb+V6GIHz+szHNpOHX7aVZpY5v3L5kPU3a/CoT+8CBc9zh3+wgEjRFPAbCZ/Z1Dhzp7wnuaP8SielOCVALiYzIelbCqVtCOgFnT47vORUZNLCGVcNo4wNyRddKLjRlDlpbaM4WE/qqmPxDebkUxIS9mUOjyYrWYP/Y15LKto9PsFLzZwWQbuiYExhThSeqN1bsG4ypQM5iKvxbnww/CtJN9NVaCIni41ZRLQ3xW83rk5Ql0gyvmgZLNo24tbiFwSoLuulcrtv9iVGJoRVWUKvTehXicVal5IBZ57jFcOtIy141Qe2/4Q9gPq2hk0yOPEpY8fper1a/TccMqMnbpbkRV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is a stab at adding granular dirty and writeback stats
accounting for large folios.

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

Patch 10 adds the iomap changes that uses these new APIs. This relies on the
iomap folio state bitmap to track which pages are dirty (so that we avoid
any double-counting). As such we can only do granular accounting if the
block size >= PAGE_SIZE.

This patchset was run through xfstests using fuse passthrough hp (with an
out-of-tree kernel patch enabling fuse large folios).

This is on top of commit d5212d81 ("Merge patch series "fuse: use iomap..."")
in Christian's vfs iomap tree, and on top of the patchset that removes
BDI_CAP_WRITEBACK_ACCT [1].

Benchmarks using a contrived test program that writes 2 GB in 128 MB chunks to
a fuse mount (with out-of-tree kernel patch that enables fuse large folios) and
then does 50k 50-byte random writes showed roughly a 10% performance improvement 
(0.625 seconds -> 0.547 seconds for the random writes).


Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20250707234606.2300149-1-joannelkoong@gmail.com/


Joanne Koong (10):
  mm: pass number of pages to __folio_start_writeback()
  mm: pass number of pages to __folio_end_writeback()
  mm: add folio_end_writeback_pages() helper
  mm: pass number of pages dirtied to __folio_mark_dirty()
  mm: add filemap_dirty_folio_pages() helper
  mm: add __folio_clear_dirty_for_io() helper
  mm: add no_stats_accounting bitfield to wbc
  mm: refactor clearing dirty stats into helper function
  mm: add clear_dirty_for_io_stats() helper
  iomap: add granular dirty and writeback accounting

 fs/buffer.c                |   6 +-
 fs/ext4/page-io.c          |   2 +-
 fs/iomap/buffered-io.c     | 136 ++++++++++++++++++++++++++++++++++---
 include/linux/page-flags.h |   6 +-
 include/linux/pagemap.h    |   4 +-
 include/linux/writeback.h  |   6 ++
 mm/filemap.c               |  25 ++++---
 mm/internal.h              |   2 +-
 mm/page-writeback.c        | 127 ++++++++++++++++++++++------------
 9 files changed, 246 insertions(+), 68 deletions(-)

-- 
2.47.3


