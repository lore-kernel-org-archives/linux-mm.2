Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417B7606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eO8F7a8Y
Received: by kanga.kvack.org (Postfix)
	id 4679D6B031D; Thu, 22 Oct 2026 22:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1BD6B031E; Thu, 22 Oct 2026 22:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9E56B0321; Thu, 22 Oct 2026 22:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00F036B031D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:45:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7932D1201B6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:52 +0000 (UTC)
X-FDA: 85352350944.19.5C68DE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0783EC0004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eO8F7a8Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ousMmCqm8kZo/1f4oQY4+VQpMSnqXjb9BPVok/hW1j0=;
	b=B5NFog/VQfKn/ybog3tCgdAFyktzXmXGYxQFzzlAQsvbeH2I/nUx7PxXKQ9zpucOQIVJZQ
	kXREdblWrjD5B7vv/dmEoY0mMZwbUIUyNNeY5dqetyxHHh0UDTNFr4mZk9qB9EKGYBanZ/
	pxdmIcD3yWqz2r/8yM10+ewhIBDGhlM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eO8F7a8Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723551;
	b=Ws8znnZBWDRQBwjkts7SSVxMzep6vjUDHKwazJgZLEY+8WPiWfaDMSwSEzzaR3ElwYZMpJ
	e/+2Srsi9nuG3XFixDWkoGU4f+BqCYEL3RG4YcPguwbi+vlnVrUkamSz782vDXarfX+Kjv
	xgwXJ4x3D3RwhBiw5e1209QEjGVs3VY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6567B63E68;
	Fri, 23 Oct 2026 02:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1D61F01829;
	Fri, 23 Oct 2026 02:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792723550;
	bh=ousMmCqm8kZo/1f4oQY4+VQpMSnqXjb9BPVok/hW1j0=;
	h=From:To:Cc:Subject:Date;
	b=eO8F7a8YFqj61z0gglHJ463L52JSnLHr22JUgDiyed1l8OmW5P4JQZI/3vXGdRxBB
	 sTJSQC6xsXK950SshppPD2K19ixEvNmRZEGXS7UwfloaPJnM4EzuUDeJ9Ipa0U25Tx
	 d38T5wtcrO5Kn8V0sveNxDnGnvdWbTc6TuJC6kvRRNm4MuJg2mmlHZF1ac575onGha
	 8crHb0YyQ2i0WPIJGT9arW38XLfqnafGoMlKYzrtYPe57TIiLdGYH0aajDBPkq4XjK
	 B5ZyT64yjIho+2O7/kL++9pGYxkF0HjrNwON69asVujIls7sGtZbC1Co7XlfY6HZl2
	 zJGGzGsfN9Hng==
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v8 0/7] mm, iomap, NFSD: stop uncached writes reading back shared pages
Date: Thu, 22 Oct 2026 22:45:41 -0400
Message-ID: <20261023024548.71123-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0783EC0004
X-Stat-Signature: 4scidp7aaqkqftz3hdd5e4aqihfo9tg8
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792723550-434426
X-HE-Meta: U2FsdGVkX18n+3KNqY/NcjE4ePwf7VxSzwXmu5e/4jE4SHmnKhqnjxmuTCXF/yxs8zIFXAOFCkjuaDqc0gfk1I5UD1uhcYgtKbTVNplTqD2Ud2LVUmah4Dm4REuyeGhPv2cy/S8/vHRYf6nluK84led3vrv17yzBoqnAR3N78IHEm4D8OYZvO5/8O5mQO0yA0o3EHTn0i3Wi+2gZRqj5hM5d2l6Zg6lALdYj1nEfdmOjujAPypIt3Y1cMPIkyKvRA7jL9i4eX4n2/MdiYNgFOVGT6lauHD5A2mwZpaHuptsSh3n2O6OUhWclawBs2oXxXWY83P5S7qMAyOT773PBFu9Jk2dbiw4Req61x2SyFJu2IgxaGb3y9Z8DPivPP3zK5blHpJVFDMLveE5QBp/87Z+IzjF/xDomFjpft4KjoaCympov0u8XqixRRRD48aoFp25r51ySgz537pKbpF9cU2omjrodfTKkTGRpGROfO7EYWoldI9lBJ+62QHXAfpdy9/h9S4TiqBwz+kgkdz5co/IjmomBz1KAET4I94DWhgpJCCREhtXemAKlA+jMEqHAz3pS+l7MqonzY07X6xhM8Humnl8ZzDmTCYmj+u1sorr1kNQTmIjwN0WYg2XN8biBqxT6qBZd2ZTpvRdB5GTKpZE4OzRA7NJ8vZhy3P8Wc5F1yNKZt1Nd2RcPGvOCeeYrAlr72prSjYF/f2FjqrkoIL+gErEDRiQjop3aQZdUeWuOsayDCeGWz00aWFhwAoPiPPWDD7IvVYeTb8FFpjSME/nZXbi7r02kaHx+8DFOHvENReuppIaY7IS8+48w9bwBY9uPCop6I64DChs4k2Hr1KrFYIhEMgqHnGnmsNA4VeDevtn8aLEaWyNLH9BVAsuBBcTzPUXCYKrlFpoyFqQF+qI1Vg8QG1U3bTtk5XvvgzVp+5LvrOxtK9b/gTWKOUK9SInsEREGECJ3o02JVF1
 8B7RiWiM
 cvnXhwKMSa/QrXe6c91yDBXegqrBIaeq4hS9jRtLmmoLkzIthlkdszkM/5WaFqPjfAPubUltteVOm2/wXhPppAcDvmCExb6OWYylcMXPd+YXdRjJYXP9cj4upW3hFOC7U29B21ac+hHmgEnisVPqtJyW1XRcmriuX4mTw0pix16/DewkAHSwVuQlgm1R8shJdwbdWI6fa/av40ubVTPG6vrCe3VoFW+Ny5l4mUZu/q21LZ6bHSQkGIXl1HdZesBXUMC+i+zQen5HiUTZOQYjhxrHKI9BqQJXA7niYywQIMGgkRBovTPa0m/eGLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Please consider this v8 for the v7.5 development cycle, so that it can
go upstream in the v7.5 merge window.

An uncached (RWF_DONTCACHE) buffered write drops each page it writes
once that page is written back.  A page the write covers only partly is
shared with the neighbouring write, and once the first of the two has
been written back the second has to read it back from disk before it
can write its part.  32 threads writing interleaved records to one file
on XFS (emulated 4Kn NVMe, 4 KiB pages), before and after 5/7:

  record  pwritev2() flags          4 KiB device       MiB/s
  bytes                             reads per write
                                    before   after     before  after
  47008   RWF_DONTCACHE             0.97     0.0005    831     2281
  47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.0005    601     1227
  6000    RWF_DONTCACHE             0.97     0.0001    121      488
  6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.0002     90      206

What is left after is metadata: 49152-byte records, which cover only
whole pages, read 0.0005 per write either way.  The test program and
script that produced this table, and how to run them, are in:
https://lore.kernel.org/linux-nfs/atqJBS8MlYfeUU-t@kernel.org/

5/7 has the page cache keep such a page for the write that completes
it.  6/7 lets a writer that syncs its own write, as NFSD does for a
stable WRITE, complete those pages itself once the sync is done.  7/7
is the NFSD change that uses it.  3/7 reports the DONTCACHE dirty count
in the bdi debugfs stats, and 4/7 adds folio_mark_dropbehind(), which
5/7 and 6/7 use.

1/7 and 2/7 are fixes the review of v7 turned up in code that is
already queued or upstream, and each stands on its own:

- 1/7 fixes 80728157d1bd ("NFSD: cut a misaligned direct-mode WRITE at
  page boundaries") in cel/nfsd-testing: where the mapping's smallest
  folio is a block larger than a page, NFSD cut a WRITE's misaligned
  ends inside a block, so the direct middle and a buffered end shared
  it.  Chuck, maybe best to fold into 80728157d1bd ?
- 2/7 fixes 88d6f128d06d ("mm: track DONTCACHE dirty pages per
  bdi_writeback"), in v7.3: a cached lookup that clears the dropbehind
  flag could take a folio off WB_DONTCACHE_DIRTY that was never counted
  there, or leave one counted with nothing to uncount it.  It applies
  to v7.3 as it is, if the mm side would rather take it alone.

The prerequisite NFSD changes are staged in cel/nfsd-testing; this
series applies on top of it at 6d13b7f74eec ("NFSD: Map every NFS_ACLv2
reply status into aclstat2"), and each patch builds with W=1 with no
warnings.

2/7 to 6/7 are mm, with small iomap changes in 5/7 and 6/7, and are
Cc'd to linux-mm and linux-fsdevel.  If the mm and iomap maintainers
are agreeable, their acks would let Chuck take the series through the
nfsd tree.  But whatever approach the maintainers prefer for this kind
of cross-subsystem merge is obviously fine.

Changes since v7, from Jeff's review and the sashiko findings he
relayed:
- 1/7 and 2/7 are new (above).
- 3/7 (v7 1/5): a comment dropped; Jeff's Reviewed-by.
- 4/7 (v7 2/5): folio_mark_dropbehind() counted a folio as DONTCACHE
  dirty when it found PG_dirty set, but PG_dirty is set before
  folio_account_dirtied() counts the folio, without the folio lock, so
  a folio marked in between was counted twice.  It now sets the flag
  and tests the dirty tag, which is set in the same i_pages section that
  counts the folio, under the i_pages lock.
- 5/7 (v7 3/5): the edge is the smallest folio the mapping allows, a
  page or a block where blocks are larger, both in iomap's test and in
  what is marked: a larger folio found there, left by readahead or
  another buffered write, is no longer marked whole.
- 6/7 (v7 4/5): an edge already clean is dropped before the folio lock
  is released, not after with a trylock that could miss it; and only
  an edge-sized folio, as in 5/7.
- 7/7 (v7 5/5): unchanged.

Tested on XFS on an emulated 4Kn NVMe, 4 KiB pages, 32 threads of
interleaved 47008-byte records (12288 bytes where noted), 4 KiB device
reads per write, v7 against v8:

                                             v7        v8
  RWF_DONTCACHE over large folios
    readahead left                          0.94      0.0026
  RWF_DONTCACHE, 16 KiB blocks              1.62      0.0014
    12288-byte records                      2.89      0.0004
  NFS WRITEs through NFSD DIRECT,
    16 KiB blocks                           3.46      0.0016

(v7 in 128 MiB runs, v8 in 1 GiB runs; on 16 KiB blocks one block read
back per write is 4.0 here.)  In every run of v8, BdiDontcacheDirty
(3/7) was back at 0 after the final sync, including runs mixing
uncached writes, cached writes and mmap stores on one file, and every
record verified.

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
  NFSD: cut a misaligned direct-mode WRITE at the mapping's smallest folio
  mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
  mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
  mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
  mm, iomap: keep a partly covered page until an uncached write completes it
  mm, iomap: let an uncached writer complete its shared pages itself
  NFSD: drop a shared boundary page only once both WRITEs have written it

 .../filesystems/nfs/nfsd-io-modes.rst         |  17 ++
 fs/iomap/buffered-io.c                        |  20 +-
 fs/iomap/trace.h                              |   3 +-
 fs/nfsd/vfs.c                                 | 113 ++++++++--
 include/linux/fs.h                            |   8 +-
 include/linux/iomap.h                         |   1 +
 include/linux/pagemap.h                       |  12 ++
 mm/backing-dev.c                              |   6 +
 mm/filemap.c                                  | 193 ++++++++++++++++--
 9 files changed, 338 insertions(+), 35 deletions(-)


base-commit: 6d13b7f74eec16e08d5e7f772ee119432a14ef2c
-- 
2.52.0


