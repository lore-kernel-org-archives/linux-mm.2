Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD6A608343C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SeaWtDs9
Received: by kanga.kvack.org (Postfix)
	id 380CB6B029C; Mon, 19 Oct 2026 11:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331346B029E; Mon, 19 Oct 2026 11:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221686B029F; Mon, 19 Oct 2026 11:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E94A26B029C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:07:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 892631406D1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:29 +0000 (UTC)
X-FDA: 85339704618.17.8A99DF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id EE7EF4000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SeaWtDs9;
	spf=pass (imf12.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792422448;
	b=mTIS6r1nQr5cvvh4N/pLHsqA6eg6pNDFnzi5G0Kl/o3hNfapA0O6f/arc6jBcfoae/rNNy
	VGXfnJPc1J3421ED/2oF3/cIweNXlETjGjQ6KRXf8H61oMslFXHvXcf2pf7Q2veCD4bhaK
	G1SqJxaYqt1KhuEF0i7xGgIjw0gtuns=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SeaWtDs9;
	spf=pass (imf12.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792422448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fwOiNhCTnZrqfGqH9TnldJ5DIHOFF0sKxmDqg1xr2P0=;
	b=ubW6/Kd5Rj5/BSoyXRZh7VzheG6PuBvPdi7BrTcjVZi0DqhTqVRpv5UYUxfpxsFHobz7oy
	13CUUYsvmb1HRRM/MV6aDqiO4p++qmuYdh7oxOGpi2jrL6mNanflpPO4WWgvUwuV/kLZOE
	YQWsg1VAhGy19IrnCLV5kOuvB+ak63I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B416601FD;
	Mon, 19 Oct 2026 15:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D579D1F000C4;
	Mon, 19 Oct 2026 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422447;
	bh=fwOiNhCTnZrqfGqH9TnldJ5DIHOFF0sKxmDqg1xr2P0=;
	h=From:To:Cc:Subject:Date;
	b=SeaWtDs9gxmhFp+vIt4L84AgDz6rjq+MyRqzdqZNSFtglItNvDMdmTgbJcGcsq8Xz
	 Eye5aGoYQSrPh9EciHAWvyhlyAejXwTOOnsf3OonSv3DFoNVKAssZCYUFjLsQ+SybF
	 gDqesw6cIzdFPdL6GiGjKFkZuzccLI6N2Wj6XoW5T0FsT/AMV0zpkG0GGvMYMnwENH
	 wFCV0+LjkEPju3OuVrWndS6+fDWD3bMsUHIo1+g9qmV07mun11mmigFrQnIspe8AWV
	 7m4hSeJaRBnACejNXCm/7SrfHTrlhY68oChuZ1jtoGJpHS38IQulRnQnj+j5ZTVJ1p
	 md8SIrkVZesfQ==
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
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 0/6] mm, iomap, NFSD: stop uncached writes reading back shared pages
Date: Mon, 19 Oct 2026 11:07:19 -0400
Message-ID: <20261019150725.1507-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uwimwc9f51yerkbw8ot58ofy3y5s4zz8
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,
	RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE7EF4000D
X-Rspam-User: 
X-HE-Tag: 1792422447-938414
X-HE-Meta: U2FsdGVkX1/Yhj0QmFIlLiweXpOSgfiUInTwCmOTSM+C/ppexiWvedafU47JrtywqhRyS0aMf6+QW2KPIznaCUTIlXN3/GIrW0oj5Au3ff7wHzHgzgxhm2burAtg6gVErFijfWs0GEfTbWMxhy359SY8vO3POY+wA8xkIB1tVwdKgGcFT3II0aBUXZEOqk7mo8rilRnEKun2kZak4dvFsl3Ni5l884Kl4hY+VNFsDTvz1Pa2KEV6LpW4U84Cxm965DwsI4lGqNnQ7Hp3DY2HNd/fXZQ4rs8aIDCXzAz7Su+LFb3AZDHoTSpO3qiEoTiRgsl6YDBc7yfGQFA5fZhLng/qcVBgVVIXdABuk4LgUKQmlRdqJ4HOP3kiVdQr0jgJ5zVEzYNOJTTyOb2tEyfs0mjOefytxouHVEuoO+oOgN337rkI7/ltfzbxc+qrx8CUR/jc9jxs+QvPqkx9QsVHmq+A5ZRQTvVFD2Na3MWwvLhEKOyG+BeQJMeuRJruPEEOrOi/73TUgpNsf27ythwisG95JSodeMnl24eTi5lYwClGtiZNpWQMaCGhC+4azPi6/wZT0XeOwXb5aieqIuSGP+w+WgMy4mefJePoHyVDdTp1ZIO5eo+PSitWnFauOZyWz7Up5yE0JoUTF9sp98D7IIB2ufOxOGD8l3oavSQF20/V/mNIrp5y2PR3Z0r+05GOnHgh5c90Is+UVUF8vpT9AzgyD+RQgizCcy7RuN4ISo9ynqA+ZMhe/+hOnSXij3nLK3Y7B4LHQdpg/I/X+8Nq/c6lEmgr6WhpgkbCvdtBklm6IvTB1hnsTwfCJ9CzNjcEu2iF1N/vmQQSerOxejTEkhtzvf2QK2dDs09o80XfrH5pNJrq70YgutWltOxMKzXFVW/t/ogqc6j0LR6Y6cuKz6girIqoWV06fDvhimmnZdi/3p6juxbeHLBiSyyACeVGCRBsh26k6WwO/NME0a+
 SL6OYjEb
 6rqV5eo4U+10w+g/pPfA6z/RlkWwtTRlu3Z/Xv5W2YLRCSV0oIuxPZMJyU5U8iyDvNc5ie9F5wzoNlzrnrUNAHvruAAL+wFkHaMcERfgEc07La7y7iL6xUBMdpGgKGThHDk1U16ouozzNfcu0fDCxBe8zIm59WpDR3tSwoEs12ffAls6g+jNvtQUMU6k89+m5lEW7FH2k2HkPvIuLtbJQDmdikijbKtR9OJNIokZZRx31pz7hlCA6XRrVrhIYKFLKZfK8EwL5GRVUIEAkpW87r1m0yZrYr44MxVR+4MHO5LBP5N+F1qZnZXm0zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Chuck asked, of v4 7-9, whether those changes belong in NFSD or in mm:
"Seems like you've identified an issue with DONTCACHE itself that
shouldn't be limited to an NFSD-only fix."  He was right, and v5 moves
the fix into the page cache.

An uncached (RWF_DONTCACHE) buffered write drops each page it writes
once that page is written back.  A page the write covers only partly is
shared with the neighbouring write, and once the first of the two has
been written back the second has to read it back from disk before it
can write its part.  This shows without NFS.  32 threads writing
interleaved records to one file on XFS (emulated 4Kn NVMe, 4 KiB pages),
before and after 4/6:

  record  pwritev2() flags          4 KiB device       MiB/s
  bytes                             reads per write
                                    before   after     before  after
  47008   RWF_DONTCACHE             0.97     0.000     831     2281
  47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.000     601     1227
  6000    RWF_DONTCACHE             0.97     0.000     121      488
  6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.000      90      206

4/6 has the page cache keep such a page for the write that completes
it, and drop it after that.  5/6 lets a writer that syncs its own write,
as NFSD does for a stable WRITE, mark those pages itself once the sync
is done, so they are dropped without extra writeback.  6/6 is what is
left of v4's 9/10: NFSD uses 5/6 and no longer manages any page cache
state of its own.

For NFSD DIRECT, 32 interleaved writers of 47008-byte records, against
v4:

                             device reads per WRITE   MiB/s
  each record sent as        v4       v5              v4      v5
  1 FILE_SYNC WRITE          0.0102   0.0002          379     402
  2, one after the other     0.0021   0.0001          217     237
  2 at the same time         0.0401   0.0001          212     234
  2 UNSTABLE, then COMMIT    0.0944   0.0001          219     248

and a FILE_SYNC WRITE no longer wakes the DONTCACHE writeback kick at
all.  The patches' own descriptions carry the details.

How this might land:

- 1/6, tracepoints for how each direct-mode READ and WRITE is serviced,
  is NFSD only and does not depend on the rest.  Chuck, it can go into
  nfsd-testing on its own.

- 2/6 to 5/6 are mm, with small iomap changes and an IOCB flag in 4/6
  and 5/6; 6/6 is the NFSD change that uses them.  They are Cc'd to
  linux-mm and linux-fsdevel.  It would help if the mm and iomap
  maintainers could review them and, if they are agreeable, ack them for
  Chuck to take 2/6 to 6/6 through nfsd-testing, so that further NFSD
  direct-mode changes can build on them there.

The series applies to cel/nfsd-testing (b4e06bef3884) and each patch
builds with W=1 with no warnings.

Changes since v4:
- v4 1/10 to 6/10 dropped: Chuck applied them to nfsd-testing.
- v4 10/10, the tracepoints, moved first, as 1/6.
- v4 7/10 and 8/10 swapped, as 3/6 and 2/6.
- New 4/6 and 5/6: the page cache, not NFSD, keeps the shared page.
- 6/6 (was 9/10) retitled "NFSD: drop a shared boundary page only once
  both WRITEs have written it" and reduced to calling 5/6's functions.
  It folds in "NFSD: mark a shared boundary page only once the other
  WRITE has written it", posted in reply to v4 9/10.
- nfsd-io-modes.rst describes the page cache keeping the shared page.

v4: https://lore.kernel.org/linux-nfs/20261015233309.42999-1-snitzer@kernel.org/
v3: https://lore.kernel.org/linux-nfs/20261001045502.48381-1-snitzer@kernel.org/
v2: https://lore.kernel.org/linux-nfs/20260929231329.22018-1-snitzer@kernel.org/
v1: https://lore.kernel.org/linux-nfs/20260929173423.16149-1-snitzer@kernel.org/

Thanks,
Mike

Mike Snitzer (6):
  NFSD: add tracing for how direct-mode READ and WRITE are serviced
  mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
  mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
  mm, iomap: keep a partly covered page until an uncached write completes it
  mm, iomap: let an uncached writer complete its shared pages itself
  NFSD: drop a shared boundary page only once both WRITEs have written it

 .../filesystems/nfs/nfsd-io-modes.rst         |  55 ++++++-
 fs/iomap/buffered-io.c                        |  16 +-
 fs/iomap/trace.h                              |   3 +-
 fs/nfsd/trace.h                               |  77 +++++++++
 fs/nfsd/vfs.c                                 | 146 +++++++++++++++---
 fs/nfsd/vfs.h                                 |   9 ++
 include/linux/fs.h                            |   8 +-
 include/linux/iomap.h                         |   1 +
 include/linux/pagemap.h                       |  12 ++
 mm/backing-dev.c                              |  11 ++
 mm/filemap.c                                  | 106 ++++++++++++-
 11 files changed, 413 insertions(+), 31 deletions(-)

-- 
2.52.0


