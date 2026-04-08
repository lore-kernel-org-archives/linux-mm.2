Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39AD510F9943
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7931F6B0005; Wed,  8 Apr 2026 10:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AE56B0089; Wed,  8 Apr 2026 10:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680A36B008A; Wed,  8 Apr 2026 10:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 576726B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:25:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8756138835
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:25:40 +0000 (UTC)
X-FDA: 84635612040.04.52178FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE3218000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:25:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZZs7UeD;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775658339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=crcLZ8cFH4LqrIIpZGJ9miIjir5nBF8mWQ3alpPWb6Y=;
	b=00FMXsAKq4EeA/Bo5UmWqIUzOJEWp7N7JuO/Ht9E7WveUBWwDJzUXTq5aXMtd/ZIYRp1bQ
	24DHJWFmZiZWtea6/JDVSwgA3dC2mk4h91tNQwAM3+9cG9AQsdVNVBjeWEQX56L9gUTY/h
	4FgzOSaZJPzbSJLPJdNo8l1o8Mid2yE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775658339; a=rsa-sha256;
	cv=none;
	b=h605UL7+Uf8nZRyueICGW2CfWYbok1yEkt9RCpnS+PuGWJIItOVlbOjk6l1e8LXr72U56T
	N9mg8xKExKEzTLPqnazvo6HH+sbFVNY+FmRtmz0oe34TvuZ5sJUrVMBId5yAu9RJeRxrjs
	tcO8ni5AWYVNfKsweb14UNDlFHdRlWw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZZs7UeD;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF02B40DE3;
	Wed,  8 Apr 2026 14:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2672C19421;
	Wed,  8 Apr 2026 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775658337;
	bh=LaU4lymwRqUzsrSYFwTvQRe3EwpBxyvxlWtQa0zSRIc=;
	h=From:Subject:Date:To:Cc:From;
	b=SZZs7UeDTuG4bF+ARiTMg6dN7DxKteaRFQtIohk0CQkZLiA75Mj8jGOxRF4ENFJFd
	 sFAVUJ/teb994zqqMgnXwgJXTy3NhwirFO4CZnkNr8CN92ZXrEUhPlQAtRn9H9/1oc
	 96QpgV0NLbOXnDU/UTszNW0QgEjCg/LHeSHxdzaEmNeeuJHtEFp8gxuOAvptUlLutD
	 6Tc0LK53WICYsRHdia1skGc7BF7TeiER/eukkp0Cet+hg9Jt/ZKBbbYTJl0DjlRpIM
	 sYBQzzVGYbW4aMK5EDz8oV60MrV2qvk6zJLto5udsicYk9tXVFaZPcsYkLg7Ls6Q8h
	 EmW1OG9t3X2vg==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 0/3] mm: improve write performance with RWF_DONTCACHE
Date: Wed, 08 Apr 2026 10:25:20 -0400
Message-Id: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23MQQ7CIBCF4as0sxYDSItx5T1MFwhDmWjAQEM0D
 XcXu3b5v7x8GxTMhAUuwwYZKxVKsYc8DGCDiQsycr1BcjlxxQVzKa7W2IBsPAuB3mk0/gT9/8r
 o6b1bt7l3oLKm/NnpKn7rP6UKxpnwo1aTN3elzfWBOeLzmPICc2vtC+SWJyyjAAAA
X-Change-ID: 20260401-dontcache-5811efd7eaf3
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5441; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=LaU4lymwRqUzsrSYFwTvQRe3EwpBxyvxlWtQa0zSRIc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp1mVaxLtjU2EQznuRQuIYxnmVa95wrmsHC/V7q
 UlgBI4HwbqJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCadZlWgAKCRAADmhBGVaC
 FWYVD/4z69kvHMYeNYgH04n3YtWn+9xJfCLt7Z50lfVF8XnEsgLlcoXPo7o/0di0i1JTam56Mqg
 yHpus74D71ygMPvJRgn/dNt10PFXwhfg1OWujD/nt3zN5xTKuSWPW41aFdvCSs2WjBIzaU1NEtD
 Dz3WHMD96TtsjZR3n2KugNx+rSU5aHiaOu1mpX8UQUvUG971iKvdmxwQ+PhNVk0zKCWbDqdQtIZ
 QsYoTu5w7xR8U5cOTPtFcI1yCesYaybctqyfts+y8RQJtrf0a4aZ+KmlJiorVokdyOZEWBHHngo
 OnzAowI+Bt6wTvTTg4uJBqpuQnakawp0Fvfn8X21YenlYVSqM5WY6ArCKCbePd5f323vAouXQhN
 sXpGxlHzr/c9m3FuDtV+zORiWoQUQdSBn4JBC/YKSyZkUqipr6n9d1fXtqQTr65tMg+/PA4NsN2
 N4trEUIxIht2+0c+DPWXR4WPOah96ZpmSv63X4jYyJ7ajDZEDGiJAInD6CHcxWIkh3BLLAcdTxw
 oVlb6XU8l+uk0Fz8rqZObxFoCm1epmGfQVbbs8fTucKsfC2WsjqIxImMR5RVi5V9n/nnQs3Biw5
 w2KDyeOOcaC//EnpAvaxxvmeak5Ozy9bH+9wOTl14Cimnk8jhNVXwH5DXbJyJXWbBbgGF76KHMf
 PQ50VyqwXEWlJpA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam12
X-Stat-Signature: reykeb6hbqniky3bqjmza87gsgi5g3hc
X-Rspamd-Queue-Id: CE3218000E
X-Rspam-User: 
X-HE-Tag: 1775658338-826322
X-HE-Meta: U2FsdGVkX18Ng6oatmegYyIN/5TDDgc/BR+eXzwiqhoOaTLYe8VpRRiNr5kyn9p7km7pncyy36snAF2aqFpttwfNh/Dc0HA34UmP0tHc+07IJd0kxNt88PNznHCrD7Mye0IEfAUm1hMFt3qZIG4W+D23W1PPPN1VwsyBRRiw7imjcMIFkiX9djckBfyI3cpv7rIXx0l5t0FApIz8OLj5QkML/TYzGZLsU/5AbCf/M1/YknWfVkOnYxFAOGrSSpxAYPknkVrrXnzP3IHMEmzP3u3UlZfJZIi1gkthX2iiGdYYD6NWpKbckPnyAX3LBtUXqGoOHTsjnKaojMQsEK/JqWkAXjjIGXT8AapLXdpsYeUkSF4Zh6sMcYEnS4PmdeBXWQr2qLBtmMOdsIg7v0/f7liNp3MDpiBf0zsdMGLjgtK1vLU7QoXNln2z2CjfDo0UIcMuVKYQhH0zCrSRemH1nYwh5LlPEn/ysokn8+RCb2hncjPbPUbDS3HBEsS4D7yXiwwXrO1bVauYvVpwWwdR2ADUbSv2CPj1Y1WJl6ts8yimrEExwFSsyW4aSvpn4oVDo6g8bHSOhWZZKGJwdBlvcehub8XTcdTPRuYoD5N6e0se0Ptj7jZNjZ2LBwa6KqVjCRarCjpncElnUSulKBpBhpL0f7TM92gizHkS5t/rPH/xlo8j97WmvER4pZaQpadK23Sa77Yueb0QGfnAtCEaagQszmXR2fa7k70e77VtWOGlG+okJPZArsEpgy+wnTRdit6AsY58ptCcLgA9y99ckQzUphZA17mLm1GvwgVm1nELJD94P3o/Gv+P0WUC1gAxxLFvcIgL5JizbSgzrrqd/Lt6ch2FOBQij3/KXPDQdFaZo4Z4XuFBGIwk7TYYRNUtgHKFzoCZMXAbTE0D4Okr5FvhJIFb7SNJUIb5X5eqEIm1i+jv0N5jFvVNHj14HurDjDbryTKR9SyoPUC/Vy/
 YSMCMoWP
 U6oi4F335ECeoYgSrQFNXScnB67aiZR1LpoS2G5m42zvnZ9aQXnS3NCqO7JQJybiWPPRi1mODnSUigu/Jm7ZP5F0DrbBLkk3vleNvO8WfIfeeSFlbv4dZgKKqK0WS+Ba5KzOvWwGoZ4dXy8Gn5TXfwCPS0Wp5bMWnbjfSoZAqnUn9uRQ6f7jbQsf04c7eKTVQWRp/z4hns9OEe3nP8DQ+s8iRpDQyngFaHyxXtRlYwyT4Nl0GQQ4Srhk8TG+j3TziPFLH5zCZvpGbGqQLy4dWWLJPU7o2cJebqewBo0U34sbp7lD39Nxd3UzWyGbIdrZIo0Ud0z6HcroNijCpgnekMr9UbEZqXu7+/r4Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This version adopts Christoph's suggest to have generic_write_sync()
kick the flusher thread for the superblock instead of initiating
writeback directly. This seems to perform as well or better in most
cases than doing the writeback directly.

Here are results on XFS, both local and exported via knfsd:

    nfsd: https://markdownpastebin.com/?id=1884b9487c404ff4b7094ed41cc48f05
    xfs: https://markdownpastebin.com/?id=3c6b262182184b25b7d58fb211374475

Ritesh had also asked about getting perf lock traces to confirm the
source of the contention. I did that (and I can post them if you like),
but the results from the unpatched dontcache runs didn't point out any
specific lock contention. That leads me to believe that the bottlenecks
were from normal queueing work, and not contention for the xa_lock after
all.

Kicking the writeback thread seems to be a clear improvement over the
status quo in my testing, but I do wonder if having dontcache writes
spamming writeback for the whole bdi is the best idea.

I'm benchmarking out a patch that has the flusher do a
writeback_single_inode() for the work. I don't expect it to perform
measurably better in this testing, but it would better isolate the
DONTCACHE writeback behavior to just those inodes touched by DONTCACHE
writes.

Assuming that looks OK, I'll probably send a v3. Original cover letter
from v1 follows:

-----------------------------------8<------------------------------------

Recently, we've added controls that allow nfsd to use different IO modes
for reads and writes. There are currently 3 different settings for each:

- buffered: traditional buffered reads and writes (this is the default)
- dontcache: set the RWF_DONTCACHE flag on the read or write
- direct: use direct I/O

One of my goals for this half of the year was to do some benchmarking of
these different modes with different workloads to see if we can come
up with some guidance about what should be used and when.

I had Claude cook up a set of benchmarks that used fio's libnfs backend
and started testing the different modes. The initial results weren't
terribly surprising, but one thing that really stood out was how badly
RWF_DONTCACHE performed with write-heavy workloads. This turned out to
be the case on a local xfs with io_uring as well as with nfsd.

The nice thing about these new debugfs controls for nfsd is that it
makes it easy to experiement with different IO modes for nfsd. After
testing several different approaches, I think this patchset represents a
fairly clear improvement. The first two patches alleviate the flush
contention when RWF_DONTCACHE is used with heavy write activity.

The last two patches add the performance benchmarking scripts. I don't
expect us to merge those, but I wanted to include them to make it clear
how this was tested.  The results of my testing with all 4 modes
(buffered, direct, patched and unpatched dontcache) along with Claude's
analysis are at the links below:

nfsd results: https://markdownpastebin.com/?id=0eaf694bd54046b584a8572895abcec2
xfs results: https://markdownpastebin.com/?id=96249deb897a401ba32acbce05312dcc

I can also send them inline if people don't want to chase links.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v2:
- kick flusher thread instead of initiatin writeback inline
- add mechanism to run 'perf lock' around the testcases
- Link to v1: https://lore.kernel.org/r/20260401-dontcache-v1-0-1f5746fab47a@kernel.org

---
Jeff Layton (3):
      mm: kick writeback flusher instead of inline flush for IOCB_DONTCACHE
      testing: add nfsd-io-bench NFS server benchmark suite
      testing: add dontcache-bench local filesystem benchmark suite

 fs/fs-writeback.c                                  |  14 +
 include/linux/backing-dev-defs.h                   |   1 +
 include/linux/fs.h                                 |   6 +-
 include/trace/events/writeback.h                   |   3 +-
 .../dontcache-bench/fio-jobs/lat-reader.fio        |  12 +
 .../dontcache-bench/fio-jobs/multi-write.fio       |   9 +
 .../dontcache-bench/fio-jobs/noisy-writer.fio      |  12 +
 .../testing/dontcache-bench/fio-jobs/rand-read.fio |  13 +
 .../dontcache-bench/fio-jobs/rand-write.fio        |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-read.fio  |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-write.fio |  13 +
 .../dontcache-bench/scripts/parse-results.sh       | 238 +++++++++
 .../dontcache-bench/scripts/run-benchmarks.sh      | 562 ++++++++++++++++++++
 .../testing/nfsd-io-bench/fio-jobs/lat-reader.fio  |  15 +
 .../testing/nfsd-io-bench/fio-jobs/multi-write.fio |  14 +
 .../nfsd-io-bench/fio-jobs/noisy-writer.fio        |  14 +
 tools/testing/nfsd-io-bench/fio-jobs/rand-read.fio |  15 +
 .../testing/nfsd-io-bench/fio-jobs/rand-write.fio  |  15 +
 tools/testing/nfsd-io-bench/fio-jobs/seq-read.fio  |  14 +
 tools/testing/nfsd-io-bench/fio-jobs/seq-write.fio |  14 +
 .../testing/nfsd-io-bench/scripts/parse-results.sh | 238 +++++++++
 .../nfsd-io-bench/scripts/run-benchmarks.sh        | 591 +++++++++++++++++++++
 .../testing/nfsd-io-bench/scripts/setup-server.sh  |  94 ++++
 23 files changed, 1928 insertions(+), 5 deletions(-)
---
base-commit: 9147566d801602c9e7fc7f85e989735735bf38ba
change-id: 20260401-dontcache-5811efd7eaf3

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


