Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08360606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j05vy9Ux
Received: by kanga.kvack.org (Postfix)
	id 1B8D76B078B; Tue, 27 Oct 2026 10:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A316B078D; Tue, 27 Oct 2026 10:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057F16B078E; Tue, 27 Oct 2026 10:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEC3C6B078B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:32:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49870120AA1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:32:05 +0000 (UTC)
X-FDA: 85368645810.05.144B326
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7A981C0011
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:32:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j05vy9Ux;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793111523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnV/zbHlczBvT7OWrHzxgEdKY9M+Nd6Op+Y0PO93fvk=;
	b=qXkXhqreONZ1Ey4nJgx4iyWCvfjXJdvVTjBV3QFQvBo99eqsfSAQFtyeAL8tyIE7Tvorm4
	Z3sxFbWiR8+m3chiTfxXRs3rsqk3Wd8DheACaee7IxOtNbirAXRKpKEgLe0mv65SEnfnyC
	/TTGx3GPIgA/Q6JaFAymV88IbmZE6XQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793111523;
	b=109TGxVzWTMd8ylxOhDLLioHIPv/QEj6tTCLy49Rzq1DeGaktDt3ooYCnXjxSjF8dcOGeC
	Q5KOGBiuLYAylQ/5rgE+Ka4R9OepjfUAaAtC5A5OLBpIc2pkLKJwrSlwtJMBKhjhEAfnjA
	HjV+vyKslPyvbp6lPCt/N76xMaS5duU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j05vy9Ux;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 506FE433DD;
	Tue, 27 Oct 2026 14:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B8F1F01825;
	Tue, 27 Oct 2026 14:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793111522;
	bh=jnV/zbHlczBvT7OWrHzxgEdKY9M+Nd6Op+Y0PO93fvk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=j05vy9UxbquH0DCLUBNFlbj73LBDWr9DkbMK7QYTqsckETUCGGIWU3G98N/BWFGM6
	 hkBvIArftZ5eGUGhQCuIRuQGM4EjuI8JQfeyWmRAm2HULYpKfcl4rqwsF9E3Iqkg+L
	 FxaqZyTME6rpbyuVJdvJ6lfRpK4/rfDMGW46qYFBJzFPgBDZa+qyDxkjXjPUfYq6rO
	 LX/PzYp/hDPShAY+6/DOG2ScmnVQXAfhv/3OxqmN1PLWeAJRhZJKptNXTGiX02E8UZ
	 7Kk7C64ad80sqyJSrEJiN2z4vLRoNAwbNvhldt72/fJABWGEV/6EUD/69yiCZT/1pP
	 62zbCCWGWGHMA==
Message-ID: <fc2ea8d6f2cd9ae83d38941f90386aac6638a497.camel@kernel.org>
Subject: Re: [PATCH v9 0/6] mm, iomap, NFSD: stop uncached writes reading
 back shared pages
From: Jeff Layton <jlayton@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>, linux-nfs@vger.kernel.org, NeilBrown	
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo	
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Christoph Hellwig
 <hch@lst.de>,  Jens Axboe <axboe@kernel.dk>, Jonathan Corbet
 <corbet@lwn.net>
Date: Tue, 27 Oct 2026 10:31:58 -0400
In-Reply-To: <20261024221152.6965-1-snitzer@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A981C0011
X-Stat-Signature: 5i8barcse7uz9nn8etzmbmnu7b5up8xy
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793111523-643081
X-HE-Meta: U2FsdGVkX1+QuDfje6W4UOdDf3DroCJdvKBOGL75vp140X6nZ0YkpU+J6UnH0ogmzaIPwlpv+JXcApImzWjUQebUENYurB3OF7l2Wo6g6Emu7o0rM/jwT8LDuyJZ+to8XgACti3yvw3xyp7KzvU961vVapEcr0dKrSIVEmVNpJvy4XEkQADDKx9h8EzUBJVEdpH2MT1jEG1lQKtdapRJLYVeRd+3swnZC74DZEfSO+6JkWCLB4XiGm7/frxeZ+yOtFpWlktT1cjS3fKh13oC6MX470sIV35aNzk48odyrXWEdTjgU7kuiCXWuwLb3MOQICYQEL8Edu61hOzz3TC4X8cl3i9G9jOHkO4vC+Rmlp+FTw+LJn7QEpDpbe9JjyG9LElTG/hJNm7ai7O41O+gCUu+h1JwHKvDDhptwmtW6kB+rgVVw/AxF49HuOgfjDrxCzpfyuGskKD2GqHVGwkrE72og9ogKFLn5/dzMUxeWn/Eq7/dzAPWuPFZloarJ1Px38YZmy4e6gmV8v+NcQTGvigaU/O3xLx93dP1ZJ9i4Tlv+VwUeLGeC4YElSyAGQ3qGPYNi62DpeJ2JqiRwgj0j5Ah4tG1gmhua+XU/VyJAsiZW8bBi45AycJPS0GqJvEA0pz1SdoZ/yRgUfI3Gw5sd5q9y8P0pDDVZ+wFUpp5YvJVsZUOcBoYvXfiAv4gflvAJj2TRevRCnWbhqILsC1KTaXXbm4AeGf31/WOwZyZBgv9uKVnylF7V7ETS4Ar5D1ddefSrFQgspdlArnmFRE9UqC88/367Jvps07FBZUpmrONtRQarpVmX7iyhbrFDvZ5Fq/T0CBs6AlEJ3aKi137DOiqkZysgctcG07vf7MJdNDURC8tjUHIdwqDNj7Bu5Hf//RWt5TCT8SGNsLBlFhir30x95SToT4upd3t7aMgTtBZS9b+3SbKYYFqINs7UBn2KwX6rGTkqPokrFZwbsk
 U64qk20p
 6ilcki5sxTMbs6Yd+M1pCZCiER3bCVO5G9R7TS3zB1k11PmbnGGkxlX4c8pKvv4+CccXfbKT2rzdhJpYKkWgfX6QuU9DKBaQNECxCkJNgsh6t6PtSz0qJNayUn67RM1Mqnrpg9NvbZH2QqmY2/xfrxWsS3BndZXzxy8eV8ZQ4RBp5mC3YT+yGkNntSPj5+7jjw4LrJnRBhcbVNmhYN9dtfH5IXmpb+BjPRIkGNjW2419s8wG57snyWK7karffqVHeE9knO/hp2VJWxY3LLDk4Aboof6DVS+vUhpFOqaxpLu+9Y+jx16yhJqXeXg/Ik1iQ4fHr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 2026-10-24 at 18:11 -0400, Mike Snitzer wrote:
> Hi,
>=20
> Please consider this v9 for the v7.5 development cycle, so that it can
> go upstream in the v7.5 merge window.
>=20
> An uncached (RWF_DONTCACHE) buffered write drops each page it writes
> once that page is written back.  A page the write covers only partly is
> shared with the neighbouring write.  Once the first of the two is
> written back, the second reads the page back from disk before it writes
> its part.  32 threads wrote interleaved records to one file on
> XFS (emulated 4Kn NVMe, 4 KiB pages).  Before and after 4/6:
>=20
>   record  pwritev2() flags          4 KiB device       MiB/s
>   bytes                             reads per write
>                                     before   after     before  after
>   47008   RWF_DONTCACHE             0.97     0.0005    831     2281
>   47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.0005    601     1227
>   6000    RWF_DONTCACHE             0.97     0.0001    121      488
>   6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.0002     90      206
>=20
> What is left after is metadata.  49152-byte records cover only whole
> pages, and they read 0.0005 per write either way.  The test program and
> script that produced this table, and how to run them, are in:
> https://lore.kernel.org/linux-nfs/atqJBS8MlYfeUU-t@kernel.org/
>=20
> 4/6 has the page cache keep such a page for the write that completes
> it.  5/6 lets a writer that syncs its own write complete those pages
> itself once the sync is done.  NFSD does that for a stable WRITE.  6/6
> is the NFSD change that uses it.  2/6 reports the DONTCACHE dirty count
> in the bdi debugfs stats.  3/6 adds folio_mark_dropbehind(), which 4/6
> and 5/6 use.
>=20
> 1/6 fixes 88d6f128d06d ("mm: track DONTCACHE dirty pages per
> bdi_writeback"), in v7.3.  A cached lookup that clears the dropbehind
> flag could uncount a folio that was never counted.  It could also leave
> a folio counted with nothing to uncount it.  The patch applies to v7.3
> as it is, if the mm side would rather take it alone.
>=20
> v8 1/7 is not in this series.  As Chuck asked, I post it on its own.  It
> is a revised version of 80728157d1bd ("NFSD: cut a misaligned
> direct-mode WRITE at page boundaries") in cel/nfsd-testing.  This series
> applies on cel/nfsd-testing at 6d13b7f74eec ("NFSD: Map every
> NFS_ACLv2 reply status into aclstat2"), with or without that revision.
> Each patch builds with W=3D1 with no warnings.
>=20
> 1/6 to 5/6 are mm, with small iomap changes in 4/6 and 5/6.  They are
> Cc'd to linux-mm and linux-fsdevel.  If the mm and iomap maintainers
> are agreeable, their acks would let Chuck take the series through the
> nfsd tree.  But whatever approach the maintainers prefer for this kind
> of cross-subsystem merge is obviously fine.
>=20
> Changes since v8, from two independent sashiko reviews of v8: the one
> Jeff Layton relayed, and the one that sashiko-bot posted to linux-mm.
> Some findings were in both.
> - 1/6 and 3/6 (both reviews): a folio is counted in WB_DONTCACHE_DIRTY
>   only when both PG_dirty and its dirty tag are set.  v8 tested the tag
>   alone.  __folio_cancel_dirty() clears PG_dirty but leaves the tag, and
>   so does writeback that stops at EOF after folio_clear_dirty_for_io().
>   A folio that stays cached then keeps a stale tag.  1/6 uncounted such
>   a folio twice, and 3/6 counted it and never uncounted it.
> - 4/6, 5/6 and 6/6 (second review): with blocks smaller than the folio,
>   iomap tracks uptodate per block.  The edge that a write completes is
>   then not uptodate when the write finds it, so it was never marked and
>   stayed cached until reclaim.  This happens with 4 KiB blocks on 16 or
>   64 KiB pages.  The new folio_dontcache_edge_written() also accepts a
>   folio whose blocks outside this write are uptodate.
>   filemap_dontcache_edge_completes() takes the range that the write
>   covers, and 6/6 passes it.
> - 5/6 (second review): filemap_dontcache_edge_complete() now waits for
>   writeback in flight, which could not drop the folio.  It also kicks
>   DONTCACHE writeback when it marks a dirty folio.  The earlier kick
>   came before the mark.  It drops a clean folio that is not mapped
>   without a mark.  A mark that filemap_end_dropbehind() then cleared
>   outside the i_pages lock could leave WB_DONTCACHE_DIRTY counted.
> - 6/6 (both reviews): NFSD finds the edges that a buffered segment
>   shares by the mapping's smallest folio, as iomap does, not by page.
>   On 16 KiB blocks, a WRITE written as one buffered segment can have
>   page-aligned ends inside a block.  Nothing completed those edges.
>   NFSD also completes a segment's first edge only when the write
>   reached the end of the segment's bytes in that unit (first review).
> - 4/6 (first review): a paragraph on a limit.  4/6 marks the folio
>   before iomap validates the iomap.  A stale iomap stopped by a fatal
>   signal then leaves a mark on a folio that this write did not complete.
>   This costs one read-back and no data.
> - 2/6: unchanged.
>=20
> Patches 1, 3, 4, 5 and 6 carry notes below the --- line.  The notes
> give each question from the v8 reviews, and the code, lock or check
> that answers it.  This includes the limits that the series keeps on
> purpose.
>=20
> Before posting, I ran a third review of v9 locally, with Sashiko's
> review stages and the review prompts it uses.  It found no new
> problems.
>=20
> Measured for 6/6 on 16 KiB-block XFS over the loop device.  Its
> dma_alignment is 511, so every TCP payload is memory-misaligned and
> NFSD writes each WRITE as one buffered segment.  32 writers of 12288-byte
> records, 1 GiB: v8 left all 32,736 pages of a 128 MiB file resident.
> v9 leaves 948 of 262,080 pages (0.4%) and reads 0.0003 blocks per
> record.  The v8 results hold.  In every run BdiDontcacheDirty was 0
> after the final sync.  That includes runs that mix uncached writes,
> cached writes and mmap stores on one file.  Every record verified.
>=20
> I measured all of v9 again on 4 KiB pages, with XFS blocks of 1 KiB
> and 2 KiB over the loop device.  These blocks are smaller than the page.
> 32 writers wrote 47008-byte records, 1 GiB.  Uncached application writes
> left 0 of 261,850 pages resident.  NFSD left 497 (1 KiB blocks) and 349
> (2 KiB blocks).  LOCALIO left 854 and 949.  Every path read 0.0001
> blocks per record.  A kernel without these fixes, on a 128 MiB run with
> 1 KiB blocks, left about one page for every two records.  Uncached
> writes through NFSD, cached writes and mmap stores ran together on one
> file, with 4 KiB and 1 KiB blocks.  BdiDontcacheDirty was 0 after every
> round, and every record verified.  I did not test kernels with 16 KiB
> or 64 KiB pages.
>=20
> v8: https://lore.kernel.org/linux-nfs/20261023024548.71123-1-snitzer@kern=
el.org/
> v7: https://lore.kernel.org/linux-nfs/20261020220346.28020-1-snitzer@kern=
el.org/
> v6: https://lore.kernel.org/linux-nfs/atbfEbgMU6UGkn2X@kernel.org/
> v5: https://lore.kernel.org/linux-nfs/20261019150725.1507-1-snitzer@kerne=
l.org/
> v4: https://lore.kernel.org/linux-nfs/20261015233309.42999-1-snitzer@kern=
el.org/
> v3: https://lore.kernel.org/linux-nfs/20261001045502.48381-1-snitzer@kern=
el.org/
> v2: https://lore.kernel.org/linux-nfs/20260929231329.22018-1-snitzer@kern=
el.org/
> v1: https://lore.kernel.org/linux-nfs/20260929173423.16149-1-snitzer@kern=
el.org/
>=20
> Thanks,
> Mike
>=20
> Mike Snitzer (6):
>   mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
>   mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
>   mm: add folio_mark_dropbehind() to mark a folio dropbehind and account =
it
>   mm, iomap: keep a partly covered page until an uncached write completes=
 it
>   mm, iomap: let an uncached writer complete its shared pages itself
>   NFSD: drop a shared boundary page only once both WRITEs have written it
>=20
>=20
>  .../filesystems/nfs/nfsd-io-modes.rst         |  17 ++
>  fs/iomap/buffered-io.c                        |  36 ++-
>  fs/iomap/trace.h                              |   3 +-
>  fs/nfsd/vfs.c                                 | 116 +++++++-
>  include/linux/fs.h                            |   8 +-
>  include/linux/iomap.h                         |   1 +
>  include/linux/pagemap.h                       |  14 +
>  mm/backing-dev.c                              |   6 +
>  mm/filemap.c                                  | 265 +++++++++++++++++-
>  9 files changed, 435 insertions(+), 31 deletions(-)
>=20
>=20
> base-commit: 6d13b7f74eec16e08d5e7f772ee119432a14ef2c

This all looks good to me at this point. This is a mixed mm and nfsd
set though. How do you envision this being merged?

Reviewed-by: Jeff Layton <jlayton@kernel.org>

