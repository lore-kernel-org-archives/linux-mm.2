Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA94606A88C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fcwaHLt9
Received: by kanga.kvack.org (Postfix)
	id 69C476B05B8; Thu, 12 Nov 2026 14:09:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DA06B05BA; Thu, 12 Nov 2026 14:09:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C4A6B05BB; Thu, 12 Nov 2026 14:09:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 297F26B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76A72C0BB5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:18 +0000 (UTC)
X-FDA: 85427405196.13.4D52235
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EB1B8A000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fcwaHLt9;
	spf=pass (imf15.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TKTNybLPBpEKnh04NOPCEWrNKO9zmS2QEgLPE1Lm2uY=;
	b=FKkhXYDEfp8i++HN7hA6MxHKpv+u7LnmWJz4ZwKDXy8M0wLMhs12uZ4DX6pRb50UAzhJ8y
	GYiEZF0lN38vHCnLL9MSjIGS/fLDEcvW9LMKRZzsRDtzXhEY5k1Cw+Ng2e2rDW7+Jhi5Cg
	KYV8mGQF0E4SmfY2NvOxyQ8uebh5efk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510557;
	b=tj/K9svfPh8UQrRvnkmNbbQlCVQVjCrdCbStVsqRERg3Bd4t4cUWURVabL8pn3TW7Jwxz3
	hNHTjK13exJHJgEU7Q1uYrqlVAs9jhaGd53Zq1hJQBGYp6jgBGAS36H4ZLlebx94VeppbD
	ARscULQRAQ8QjecqPMREt7y1HJiLxYk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fcwaHLt9;
	spf=pass (imf15.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76B5A60D64;
	Thu, 12 Nov 2026 19:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B141F000C4;
	Thu, 12 Nov 2026 19:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510556;
	bh=TKTNybLPBpEKnh04NOPCEWrNKO9zmS2QEgLPE1Lm2uY=;
	h=From:To:Cc:Subject:Date;
	b=fcwaHLt9OLtAIv0M4S2AUBsOQIcbp9263PKjlr224XFzng76KDKM3LigOhaPzGO0p
	 fUIrqF/myv9wkGoKF0KhVsF4dsg5ZxCXXEYPUKomb8iqWY/G8DBr8MQc3GZwuZ/IYI
	 dRwPIIC9cn0tpk8OIBNeI80ps8Edp+i/K0UvW+SzjhKGUiXgJ9uRY7adChF912Q+gA
	 mpZkb3KYONh3HzaTdgZVW/8cc7Yl75350p8fKz8NSyH4ZytbvC+DXM54ODpM1uWvmA
	 mysYSu1xEbNwZncea8iACe//OPE+LBnvJjkfwiitt7lW0xVIuUzcScz0+G3wpI2ZbU
	 lqTm2SB6e3r0g==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v12 0/7] mm, iomap, NFSD: stop DONTCACHE writes reading back shared pages
Date: Thu, 12 Nov 2026 14:09:03 -0500
Message-ID: <20261112190911.84702-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB1B8A000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ej1ph3my6t4474rdyb9f4infiqupqjew
X-Rspam-User: 
X-HE-Tag: 1794510556-594414
X-HE-Meta: U2FsdGVkX19jsnF7I/Kn6kDa+t+HE1hTRW0A+ey6dpcl9pZn5zpYL+MKLPPz8H32yVcwKJEueZk8s43ZLf1uQCM3EUXjPK4v+qKmVcKCLOi2BRwAiJ2yL8d40WbXmJKpcuCXefIyWGUpc+L4YNSeo2xnMBguSC8qj9t28cy818+DTdDt3xdWf5pHmviDtn+Jz03ePwMFNcev5gE1Q7v/3hOdWNClsQGh2iudzzd/VZ3/7eG0t0Es63OaRrnQDUgeJopy4VBBieMEqJnTGcgVnff0yh6+FOlD1LfkO1oBuyyKjNiPRwONUF1fNUDK2L6H6S7ZnqXcAIttrOKe0I5vaJ32LfTLJmx7pqqOtAWbyxBPC1Vbp47i1uYoGlLABTzIcSfNa7o7yQ9KUP6RmX7ssZ1+pHy/ahnaY/sQNdAExhpTInEpbcYAE2+O76kvBx3XAjw3E+NzxI+jS+ur4h1D5wgTK0KeMjr5PCFGgd/dJE4zx0gtkCM3ngsohwy+cXc2RQTvP/HmYQz7qwXAk9XPHI30eF/KUo/Vj/qew6Ky6tDPAgnJOtK7TQclrEb0KzTh9wCo4W1E66rnQSURfH84FlMPxnw9Aie4I81Fl3PtC9FspgV6YEGZU10RK2FltUX/Z4cIplKQvNJjRPFUhbXyQNGa0SftX5Rs4leAYVqgy+oQFKVaAtRBI2Ujl/6upKoiSdfEdwOD1qVfgW8oul1gZOlQ/U5j9NnWHydhj5IVx397Mh25D6S3uXMGvbjue7v3mMQNmO0A4Zl/AFe+kNs6FoDGO7AEuVhVAjnz81zGnD4bkQ+GfCeosg9jPP6fRVTt9qU4fNRhajLF6K/e5mKWfYT/WsIfUCZNGq3rUidk66xiY6hVTudhsdid61tXYNBhFXRRRwFYu7zGEbF/VKmj3hf7PoOXdoiYwBrqR6AGl8g8qNyc5anRwjYUU49hNBjGt3ecxu23+GDoheH4IPF
 mLFh/dWP
 scBMud/rMKIa9Vdy0tZSqpDGVxfO0MA2bS3Pmy7kMaO+mB/sU/KOgwnwW//5dLVgP/yZi7als7OoBj29iHUH17zGGhc1eMPUJK8tiRVrdcu1qcGomthsX8nDcZRqHIY5v8WVwDQDwrdt4/x46nefkKy3OpPBw6guf/kfYcVxmBaCs4YHxldpjAcJmq4QdO7GdceHJXmsU1GzD+rfABy8OtILuUzEp3qF2sxcrEWIfAcJ3u+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

An RWF_DONTCACHE write is buffered IO: its data goes through the page
cache, and writeback drops each folio once the folio is written back.
A write that starts or ends inside a folio covers that folio only
partially.  Usually another write covers the rest of the folio.  If
writeback drops the folio before the other write writes its part, the
other write must first read the folio back from disk.  32 threads
writing interleaved records to one XFS file, 4 KiB pages, before and
after 5/7:

  record  pwritev2() flags          4 KiB device       MiB/s
  bytes                             reads per write
                                    before   after     before  after
  47008   RWF_DONTCACHE             0.97     0.0005    831     2281
  47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.0005    601     1227
  6000    RWF_DONTCACHE             0.97     0.0001    121      488
  6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.0002     90      206

47008 bytes is the transfer size of IO500's ior-hard, in which each
rank writes interleaved records to one shared file.  Any record size
that is not a multiple of the page size has the same problem.  6000
bytes is a second example.

The test program and script: https://lore.kernel.org/linux-nfs/atqJBS8MlYfeUU-t@kernel.org/

- 1/7 moves code into a helper, with no functional change.
- 2/7 fixes 88d6f128d06d ("mm: track DONTCACHE dirty pages per
  bdi_writeback"), in v7.3: WB_DONTCACHE_DIRTY could drift.
- 3/7 reports WB_DONTCACHE_DIRTY in the bdi debugfs stats.
- 4/7 adds folio_mark_dropbehind() for a folio that is already dirty.
- 5/7 keeps a partially covered folio until the write that completes it.
- 6/7 lets a writer that syncs its own write complete those folios
  itself, after the sync.
- 7/7 makes NFSD do that for the misaligned ends of a direct-mode WRITE.

Merging: Chuck suggested taking the series through the mm tree.  1/7 to
6/7 apply cleanly to each of these mm branches:

  mm-unstable  4318887a3efa ("fs/proc/task_mmu: fix lost maps entries above 2^63")
  mm-new       daed51c91051 ("riscv: mm: fix concurrency in mark_new_valid_map()")
  mm-stable    fa4ad798f6f6 ("Merge tag 'for-7.4-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux")

7/7 needs the NFSD direct-mode changes that are in cel/nfsd-testing.
The whole series applies to cel/nfsd-testing at ab036e3a0dd4 ("NFSD:
Refuse a direct READ whose aligned range exceeds the reply pages"),
where each patch builds with W=1 with no warnings.  So 7/7 could follow
in the nfsd tree once the mm part is merged.

Changes since v11:
- 4/7: folio_mark_dropbehind() leaves a mapped folio unmarked.  Through
  its page table, a mapped folio can be dirtied without the folio lock,
  and PG_dirty set before the folio is counted.  With a stale dirty tag,
  folio_mark_dropbehind() then counted the folio in WB_DONTCACHE_DIRTY,
  and the dirtier counted it again.  sashiko found this in its review of
  v11 4/7 (https://lore.kernel.org/r/sashiko-outbox-210121@kernel.org).
  The folio lock keeps an unmapped folio unmapped, so the window is
  closed for every dirtier that does not use buffer heads.
  filemap_end_dropbehind() does not drop a mapped folio either.
- 6/7: filemap_dontcache_edge_complete() leaves a mapped folio alone,
  dirty or clean, to match.
- Jeff's Reviewed-by is dropped from 4/7, which now has a code change.
- Testing: a KUnit test (not in this series) runs the interleaving from
  sashiko's review step by step.  On an unmapped folio, the folio is
  counted twice.  On a mapped folio, v12 leaves it unmarked and the
  count is correct.  The v11 tests through NFSD and with RWF_DONTCACHE
  give the same results with v12.
- Rebased on the current cel/nfsd-testing.

v11: https://lore.kernel.org/linux-nfs/20261111015607.46338-1-snitzer@kernel.org/
v10: https://lore.kernel.org/linux-nfs/20261103211754.35352-1-snitzer@kernel.org/
v9: https://lore.kernel.org/linux-nfs/20261024221152.6965-1-snitzer@kernel.org/
v8: https://lore.kernel.org/linux-nfs/20261023024548.71123-1-snitzer@kernel.org/
v7: https://lore.kernel.org/linux-nfs/20261020220346.28020-1-snitzer@kernel.org/
v6: https://lore.kernel.org/linux-nfs/atbfEbgMU6UGkn2X@kernel.org/
v5: https://lore.kernel.org/linux-nfs/20261019150725.1507-1-snitzer@kernel.org/
v4: https://lore.kernel.org/linux-nfs/20261015233309.42999-1-snitzer@kernel.org/
v3: https://lore.kernel.org/linux-nfs/20261001045502.48381-1-snitzer@kernel.org/
v2: https://lore.kernel.org/linux-nfs/20260929231329.22018-1-snitzer@kernel.org/
v1: https://lore.kernel.org/linux-nfs/20260929173423.16149-1-snitzer@kernel.org/

Thanks,
Mike

Mike Snitzer (7):
  mm: move clearing the dropbehind flag of a found folio into a helper
  mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
  mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
  mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
  mm, iomap: keep a partially covered page until a DONTCACHE write completes it
  mm, iomap: let a DONTCACHE writer complete its shared pages itself
  NFSD: drop a shared boundary page only once both WRITEs have written it

 .../filesystems/nfs/nfsd-io-modes.rst         |  18 ++
 fs/iomap/buffered-io.c                        |  30 ++-
 fs/iomap/trace.h                              |   3 +-
 fs/nfsd/vfs.c                                 | 107 ++++++++-
 include/linux/fs.h                            |   5 +-
 include/linux/iomap.h                         |   1 +
 include/linux/pagemap.h                       |  12 +
 mm/backing-dev.c                              |   6 +
 mm/filemap.c                                  | 219 ++++++++++++++++--
 9 files changed, 370 insertions(+), 31 deletions(-)


base-commit: ab036e3a0dd410f762192f33d6244e7993b36f8d
-- 
2.52.0


