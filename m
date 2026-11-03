Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2199606A334
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XXFrdsRK
Received: by kanga.kvack.org (Postfix)
	id E88CD6B05B1; Tue,  3 Nov 2026 16:17:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E606A6B05B5; Tue,  3 Nov 2026 16:17:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D3D6B05BE; Tue,  3 Nov 2026 16:17:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABD946B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EFE8120285
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:17:58 +0000 (UTC)
X-FDA: 85395070236.21.EDEBA64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 792EA40006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:17:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XXFrdsRK;
	spf=pass (imf07.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740676;
	b=Lh6gLVOtzhhl+1U9pO1rNIIJ59RupXoi3lU4F4de3bqKr/jQEI9vY5FQ3bgug6uEUBjl0V
	vsCCWBOeK8AZmv3EbeR5dPte6NzLzoHMKDkgoEpXzPRPUUnVvkqhu15gSD7AafSCR018Jk
	3OAt34Sq4asMEErIE7+XMhDnjSLMkhU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XXFrdsRK;
	spf=pass (imf07.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XeXrDOc+70voGjQbABG90HUQoTF6Ii93pHEf5zCSnPs=;
	b=2YsSyHEbPDhYWAQ/4H4AaZy1Mmp94AKM5T4lzRbzU9zyawNEzsSPM4wU3JVqdDtvCyYbs6
	3b42SXa/UsTU5YHtLUKGIqC+zuq9/4lUslxMgjtOqyFaoCJQhJcVbdAoyXkA2+63hj8yfL
	W8MMK895AJ0mu1oj4QeAQOVTTWqcJYM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1257412E7;
	Tue,  3 Nov 2026 21:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531DE1F000C1;
	Tue,  3 Nov 2026 21:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740675;
	bh=XeXrDOc+70voGjQbABG90HUQoTF6Ii93pHEf5zCSnPs=;
	h=From:To:Cc:Subject:Date;
	b=XXFrdsRKSt+h1JHwiQ58mFXZpgsRd5fjML9ABRZ3ZDvlov2nYhH+d9yRcQbYq8Mh1
	 B0eXvnBz0TGAuvfmLFnB5ubvdu9sVxe0kL4KuIJwRSdC+Qg9BG4GrxqHmjbB7JJR1Z
	 6fBRlJCtkMWVBGwdomZFzqj0i05MPp2t7Ubi3tgDHtEXP7fa8CdTQIbHRLTEWyzwLH
	 iZ8iVR1XD7BkVFYgqr3boVCL6pzMKEU3PIM8UNzczi2qiJz6TdAeR3J7RPWe/jZ4DE
	 /jTxiS5uT5fHqmtSTd3JrAzIfbkqHnPvvbcICJzm/+9uD/KM755SSvo4FU/va6W3tz
	 raykJvyMoID3Q==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v10 0/7] mm, iomap, NFSD: stop uncached writes reading back shared pages
Date: Tue,  3 Nov 2026 16:17:47 -0500
Message-ID: <20261103211754.35352-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pbqhsggupx6kyayuyyjs4hihwpcarns1
X-Rspamd-Queue-Id: 792EA40006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793740676-698443
X-HE-Meta: U2FsdGVkX18fiHwWkrcdXECKCKXRvfz3rdUs5j6jd1KoAFtGlJsW82934K72pGrcHRWskpkI9qSjeAKuUW3F6LVFuqvTpCwulT9CfJWjAZhaB/UY1DuzjBYAzoBmaSXuBdwHRLakdrtMfcFl8OurTHk4n9Tl1+3hIB4QdWB17QDnmg9C4IwjDoMcJLfL3xynn3jRq5tYXYtjcba/JCxEKdJUL0fLT/xsDJ+ZTj2vipCWEZJNMTpmk4RZSVipQamWjZNunRCo3lKclCQ4Ivw7kRafs7PjdRKQifLV0/rx/I9iBa/51H2nWJqp4mUXp2XE7M636W6c5SuHiE8CMkPeL0FUg4MFDqKde982IIaKZhpdKpTfbetuddiY7bdSug6Unl/nKLuSsNj/WfVFNNpLIz0yU5Msyw/esr/xARjLpxkO8T2945JRj1F9+0qU4MrCanqbhH4D8fGN5lqObLE1oG/27O3fzMogUDD/PpYijSEBUI0hbxNetObyxYG1SkdEr0IDLHvu6mWxJGzxpSBV4evGZOUbYDCgF8O1CpuKNhQnd1h8tcB+I0nZvVQzQqJf6VWVblJXK/0IJz0eaoapWRwx35V3gvXoub2CB2s0NYpm97NQPg1vMrQCaDZb+6fmRgsYlr6IoL3HzuZjIKZHJyvZWfLMDJphgQ4pgjYATVj946/pVODCWa5By8ulZ4nPL27AUmmsTnT8x+aQW3NYb3ITddiYomCnesp7r6jlVOPv2JZAMMH2FypI/efzSB76sdbJYNRMuHaWdEizDRdQrqKWaQd+xqnkR9kwFXTpeYF0YZYjigL6sR82P7xnbw8OJQ1bIqs3nkwJF/THaVrmuN4KBqUR/DHS6Fle269abi/1E7nRIAO6mwNqWRFWBLz8i6kwY72KkYLGPpr1WOrYAATxQACuv15s2HapB3kkIS+0jaGsaFZfF5WXVeRQHl30jTnncOtEcV+MsFLSVjq
 ESoQOfYC
 bwee4TW9V+Zrvy8PYRnUsqIexdhgwr71WZcXuKUEVyzGL2UvK3V7GS7foz/cg8891/uDsuMlqPy7qBOl40524PBZ0H4SsDAw0MBcAfxiTU3TAD5qIC+ANTmyuHnpd3YDPguA7T+BTTx1Z4vBBP3Fx8oSECwvMs2hfXB7iXp9kv8mtcferzSAlYNxUOdMQv90K9WlNGhNsE91YmiCoSIWV3fox1zEuc9lT4V41trb/d2bTbwLMhzQlEgchyE2tIJIgMZc9Nx6DG2SfXC44+fIMioDYW/H4yrUfvQYT/QqufoO8h97P1VOFkqq05g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

An uncached (RWF_DONTCACHE) buffered write drops each folio it writes
once the folio is written back.  A folio that the write covers only
partly is shared with the neighbouring write.  If it is dropped before
the neighbour writes its part, the neighbour reads it back from disk
first.  32 threads writing interleaved records to one XFS file, 4 KiB
pages, before and after 5/7:

  record  pwritev2() flags          4 KiB device       MiB/s
  bytes                             reads per write
                                    before   after     before  after
  47008   RWF_DONTCACHE             0.97     0.0005    831     2281
  47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.0005    601     1227
  6000    RWF_DONTCACHE             0.97     0.0001    121      488
  6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.0002     90      206

The test program and script: https://lore.kernel.org/linux-nfs/atqJBS8MlYfeUU-t@kernel.org/

- 1/7 moves code into a helper, with no functional change.
- 2/7 fixes 88d6f128d06d ("mm: track DONTCACHE dirty pages per
  bdi_writeback"), in v7.3: WB_DONTCACHE_DIRTY could drift.
- 3/7 reports WB_DONTCACHE_DIRTY in the bdi debugfs stats.
- 4/7 adds folio_mark_dropbehind() for a folio that is already dirty.
- 5/7 keeps a partly covered folio until the write that completes it.
- 6/7 lets a writer that syncs its own write complete those folios
  itself, after the sync.
- 7/7 makes NFSD do that for the misaligned ends of a direct-mode WRITE.

Merging: Chuck suggested taking the series through the mm tree.  1/7 to
6/7 apply cleanly to each of these mm branches:

  mm-unstable  0ea6dc8c4a21 ("fs/proc/task_mmu: fix lost maps entries above 2^63")
  mm-new       74d73ffcffe0 ("riscv: mm: fix concurrency in mark_new_valid_map()")
  mm-stable    6628e7d4c6b2 ("Linux 7.4-rc1")

7/7 needs the NFSD direct-mode changes that are in cel/nfsd-testing.
The whole series applies to cel/nfsd-testing at 693afd3ce9ae ("NFSD:
Defer the PUTFH export security flavor check"), where each patch builds
with W=1 with no warnings.  So 7/7 could follow in the nfsd tree once
the mm part is merged.

Changes since v9, from Christoph's review:
- v9 1/6 is now two patches: 1/7 only moves the code, and 2/7 changes
  it.
- Every commit message is rewritten to state the problem, the fix and
  the result, without the earlier detail.
- The long code comments are shorter.
- Rebased on the current cel/nfsd-testing, which now has b16607436d31
  ("NFSD: cut a misaligned direct-mode WRITE at folio boundaries").
- Jeff's Reviewed-by of v9 is carried on every patch but 1/7, which is
  new, because the code changed only in comments and in the split of v9
  1/6.

The code is the same as in v9 apart from the comments, so the v9
results hold.  Patches 2, 4, 5, 6 and 7 carry notes below the ---
line: questions from earlier reviews, and the code that answers each.

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
  mm: move clearing the uncached flag of a found folio into a helper
  mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
  mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
  mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
  mm, iomap: keep a partly covered page until an uncached write completes it
  mm, iomap: let an uncached writer complete its shared pages itself
  NFSD: drop a shared boundary page only once both WRITEs have written it

 .../filesystems/nfs/nfsd-io-modes.rst         |  17 ++
 fs/iomap/buffered-io.c                        |  30 ++-
 fs/iomap/trace.h                              |   3 +-
 fs/nfsd/vfs.c                                 | 106 ++++++++-
 include/linux/fs.h                            |   5 +-
 include/linux/iomap.h                         |   1 +
 include/linux/pagemap.h                       |  11 +
 mm/backing-dev.c                              |   6 +
 mm/filemap.c                                  | 208 ++++++++++++++++--
 9 files changed, 356 insertions(+), 31 deletions(-)


base-commit: 693afd3ce9ae5cddb7225ec87975e6ef1443e502
-- 
2.52.0


