Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBFD606A333
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=hammerspace.com header.i=@hammerspace.com header.a=rsa-sha256 header.s=google header.b=IVa0+bbl
Received: by kanga.kvack.org (Postfix)
	id A5EDA6B0567; Tue, 20 Oct 2026 18:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36AF6B0568; Tue, 20 Oct 2026 18:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DFE6B0569; Tue, 20 Oct 2026 18:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7A26B0567
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:03:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 998DC1C2CD8
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:51 +0000 (UTC)
X-FDA: 85344382662.09.2EBFC2E
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0E934000C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b=IVa0+bbl;
	dmarc=pass (policy=quarantine) header.from=hammerspace.com;
	spf=pass (imf12.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792533829;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oiJsb2ENhg2Lat5WWUqDnx4kJNVMy/Qtqe/7sshNmdw=;
	b=SYbA8zfk0AoHfCaU2arV6qLxxqzNv7oHvFSZGLN3JSja8KCd906ia74/vHYDfWhRbJcB7H
	/JxdNtS7PNMx8f4PO0hmWPphzjhhFvLLocw9TQuGdTCZoU0S2xFwaNKMFlJ5yfMbEsuS/P
	8VJuu9kqfRbdSCdk5JS+38bIzcKn5AE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b=IVa0+bbl;
	dmarc=pass (policy=quarantine) header.from=hammerspace.com;
	spf=pass (imf12.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792533829;
	b=vDj7ng4tUYv797bROqejUHL3iMzIlg2oCgRDfJhwTcT8d8QDY6nxwChspV2deaSNNgzS0/
	rSBLWMK92y63nWzvAuT4YI+d8Km0YcatCf8RZuAdfo1CqITRksfXOYubbQHfqrd5UO/O3S
	Yodc4zsal5XX82TQWp54U7QHi5zccQY=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93e515769d3so9157685a.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hammerspace.com; s=google; t=1792533829; x=1793138629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oiJsb2ENhg2Lat5WWUqDnx4kJNVMy/Qtqe/7sshNmdw=;
        b=IVa0+bblkvUKcZK8goOAN/6fbGOYtzJsyylgbUQkaqiQZU9ijLhKSO2tr+CgtlZ/KO
         BHb112DdrI0LmLCdMm69QjxGeb81SUI0BJjK2hQwtrHWWwNCffQ39wOBFBARDjy4iL4C
         VKbPlQzrcAm6JgLzN27ZrWiKluSodiPmAIac3JzKzfSuqLLRaGYsJ/FIjJ71u79CKIwf
         En6zkNGfkk++nzOf26+N3Rg9H++6pOtYMZKqvXJDhI8SYiV51hNvMwXyQDrIP5ynSmK+
         XtLhT7K8ybQoFaVsWo7+4TpOWM5jTj4MGprTA5u2dkzkZQ5h3EjsdXfUPcEpk1emnHX8
         UZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533829; x=1793138629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oiJsb2ENhg2Lat5WWUqDnx4kJNVMy/Qtqe/7sshNmdw=;
        b=Njj9bpsl5V27vQhaXvZ1XwHzbwbrCctZeq6GFYfXzSUNpvMXd14JPvThd2mILQF/MV
         QpHn7+1ZE3ECOxq59hKPT4e461tQVupPUEkBRaKMR5851dWKsYnjEa0UN0zwYxENCqBN
         RqmY9Ql9gdjqxVnWJ/+2FuE6HS3Brw2Qc5bhQkiY/Sr5BkbtWt4aNkAvqxTV/Es4k7jP
         S0yQkEX7V3b2nFoA9CU0KbAK2yYceexBLx6JtHWK8AUyBa1De8Peu0edCQLfUts+ZH07
         SJm7s6HIFz3YddxSF9xwL8anGZIL9wypxL4UqSvHbueXvtTi3bEbSjYbnr/YVTlqzL8G
         0pKg==
X-Forwarded-Encrypted: i=1; AKwUvBwHW3rwPemZASUf2v/dkcQrWQYNkK59uWwKZENQC1wFpmqqBe0OlS/X119tSlrclGjYzBcZJyZpRg==@kvack.org
X-Gm-Message-State: AFq9FYIqMrbaHgaxPa0/CQSYsjMIb6y8dLVGNuyj2Xc7xebc4HKkOUz0
	nT1z751G9gd2XgzNxrQLX83N1JfIKIPoBHFAWgpSnnFS2ys3E6/Bkg3AsHpytjDbkAk=
X-Gm-Gg: AYBFou1ST15yyV/l86FBNaoRd7SCLS0O64+5718sllBWnciHwS3xzovX+PbBc2s77cv
	IPWoa/AqXoZc70YGPNdBF8EdgmNuoOBQP57ovDyWmdUSveo1jrV0BcnDgJpf7kiadvmezIskTvq
	Qn7bnMIe/RqT+4pJLSuHs0NqKl4GkmwTOSvMO0mLWc9yTSlMwJJ7tq74vK8tkzK2EPB3qeakNv7
	p7fyuLcYFZo6VxQMVQVySqad12GTL4rm9Nwc6KaJbg1CTGzn8ZZIT8eTmkyZYmRrpYDQA75Nndy
	4aYUQvSp7mG/AUtNu7x2z+023tfbYNoyTPI0oq0xqYTYHOE4dzCEanp7fNAl2w+ESzYtAR79T4y
	o6WeLrj4JKXgKHMZsGJnzU1WTEdBvDrrqJvqSpIs+IyQ/Verf1zrZQacXiqUX/cqFBd/63scdzD
	eLFFSJe9Foaly4Q2X+tax7gchOHvQYKmPvz0fY5mIQUuve2z1tLE9v9Ppk1ZD+VxbWIuf6x8ff/
	mdzx7GUR8kBb6bwk2GrOnDV1wII79A/pZ2BSNj8/yWGWN74FQgT63dKkll2YKGI++PLyZCFN5Ri
	zHUpL2Ozf6jRE6gtOAtsso71zutlacPI7KmD+EaXkvlKsZljuwx9wNMQ63TtrtfOfA==
X-Received: by 2002:a05:620a:690e:b0:93f:52c5:a32 with SMTP id af79cd13be357-93f57f7aff1mr111231185a.83.1792533828633;
        Tue, 20 Oct 2026 15:03:48 -0700 (PDT)
Received: from localhost (pool-68-160-167-46.bstnma.fios.verizon.net. [68.160.167.46])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56ddd369sm92332385a.21.2026.10.20.15.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:03:47 -0700 (PDT)
From: Mike Snitzer <snitzer@hammerspace.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
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
Subject: [PATCH v7 0/5] mm, iomap, NFSD: stop uncached writes reading back shared pages
Date: Tue, 20 Oct 2026 18:03:41 -0400
Message-ID: <20261020220346.28020-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0E934000C
X-Stat-Signature: ixsrpcb43huf33ztu9ogwd4qyd9p97qq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792533829-153485
X-HE-Meta: U2FsdGVkX1/mhKcJiVKCHPB+lpBFY3BLEIQYcsFouV8LVWZ1O/DCooYolTQfWtVi/KDIHockIVoDqCmwz6LiyBYZFrBIU0mDKjhqwuFnLE5WDXTT9TJATlJ8ok4Sys4HG/qWUh3VLIyJ/0jPg3NvqPT/3++JwY4QcVn1k1ys9qqB07+yN9rSONKy1wlpAezclE1SFgts6I3qX6gJ6fdB89PW9yBoVBd4+UMexUftmaZT3RiYcuDZXAuCpZpURWErC+StqiZPbMztD3ZjHO8Y8BiGLm03hBUFeN233n8oqlj3DRJZxy1/bqCYRkrD+Mnk3B1H4wWjevdmUssEjRTB5ESfRVlw2DAtkwxKbTUDova5Dd7HKsV+4Qlvq5fxijC9GRf73znuwiOSAuNYx5NT3ix3H8odP8cdL6MVLPXU14kivy35HxFDiDB90F5VvPJQUS+tqAKf0VoNDL9NJv5HmHJr63sPryVzmM6dCw5OuOiiBo9kr59sZEp3nE+5roBf+UJHKYgaw7GTT3Oa221q87R6ijENMOK8/phu6ylsWQVAr4bvoGl7dWctFV81hLrF23c2kYZUePyB+EUgtdUUXdcgA6HgwbkuiMt2llzXp3+1BdI8JoIPLq2hVA30+Hsamm2kt6y/7n/TMRnKpttltOkoo3cpddKg37U4LVVPcrf8d7kvsxdpH63niNeHN0NIHQJD2jHV2P2KLQRz9YB4HjZunYgBCKBYiqRIttdEOQp+nDGt6ymdBqAwUI8tDYuJIwUbEk3tjcE/rY8eFfcqSRg7ykOUx9Zid78QkeG1m1+RhskhewpV5NpyfJdGuKmoyQSov9G5C92yTjq/HjC1+Gz5mSt19dPw6I83wVsWLNN5+Kt04FQe+TnOndqX9ASbTZ98cw0kre0yrTemLUkzfcBgvZo1t3Or08Y9WzmytQjgVfbcTf4RCfwk134PAta3hiZazYEOctBAAPNdA1H
 oErp9RJd
 Qq6U/A9DXvfB868bt+YtN0idKY7XQIU9zgXhq/oHDRLDMfoUSLx9sLfDvcZyWmHmm9GA7/pJOLsSiJvejU929sdiNfjzxdAbMuyEWvEdnXOp28uvwime/63dJ8RY9eVdhjF4fy4/Xq2gC8Es0VO75Cm/N5qLGd/yrafQs45nK4/7DTZJPixfjrEoG5zJDXW/Jxqs0ydNSOkrkvyKeTOXNXViA2QgSp15n5Rgs3qBtL88JL3iWn8gzCI8QkXwxuE/Rel+dhBMZzRe4Tm+DGU/sWh+NOrw2NEAjVfJHjta9E96R5ZFRanVhYq65waZ81sA5CVS1lmTcoTcXPhqBmF3kRzYub7SIucmCmG4e28CGOBVbXNSGNsTAZU86G0dSLUgve+tIa+dWAwa6Y2TWNHkQZOu7cUuchhIf3eNyT1JQkklLxiZcgFPR1FtXf/YOgDLKwgg5cEPvasVAy3x/dD1h4R9aR1HaLCDhbSeDU+tIoob/HzL1vJIxdMYQO4EpupGwcoWGXFFJDvWpsqkuxNER7fma/HO6uPjJeHkYcvAFMk1/a00syhsI5NGikLdoHzk7WoLuHkPvcFTRCBECcdqSoXv2qU528sdLrzai39CDa7OUdZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Please consider this v7 for the v7.5 development cycle, so that it can
go upstream in the v7.5 merge window.

An uncached (RWF_DONTCACHE) buffered write drops each page it writes
once that page is written back.  A page the write covers only partly is
shared with the neighbouring write, and once the first of the two has
been written back the second has to read it back from disk before it
can write its part.  32 threads writing interleaved records to one file
on XFS (emulated 4Kn NVMe, 4 KiB pages), before and after 3/5:

  record  pwritev2() flags          4 KiB device       MiB/s
  bytes                             reads per write
                                    before   after     before  after
  47008   RWF_DONTCACHE             0.97     0.000     831     2281
  47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.000     601     1227
  6000    RWF_DONTCACHE             0.97     0.000     121      488
  6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.000      90      206

3/5 has the page cache keep such a page for the write that completes
it.  4/5 lets a writer that syncs its own write, as NFSD does for a
stable WRITE, complete those pages itself once the sync is done.  5/5
is the NFSD change that uses it.  1/5 reports the DONTCACHE dirty count
in the bdi debugfs stats, and 2/5 adds folio_mark_dropbehind(), which
3/5 and 4/5 use.

The prerequisite NFSD changes are staged in cel/nfsd-testing, through
ad42983b887e ("NFSD: add tracing for how direct-mode READ and WRITE
are serviced"), which was v6's 1/6.  This series applies on top of it,
and each patch builds with W=1 with no warnings.

1/5 to 4/5 are mm, with small iomap changes in 3/5 and 4/5, and are Cc'd
to linux-mm and linux-fsdevel.  If the mm and iomap maintainers are
agreeable, their acks would let Chuck take the series through the nfsd
tree.

Changes since v6:
- v6 1/6 dropped: Chuck applied it to cel/nfsd-testing as ad42983b887e.
- 1/5 to 4/5 (v6 2/6 to 5/6) are unchanged; 5/5 (v6 6/6) only differs
  in context, from its rebase.

v6: https://lore.kernel.org/linux-nfs/atbfEbgMU6UGkn2X@kernel.org/
v5: https://lore.kernel.org/linux-nfs/20261019150725.1507-1-snitzer@kernel.org/
v4: https://lore.kernel.org/linux-nfs/20261015233309.42999-1-snitzer@kernel.org/
v3: https://lore.kernel.org/linux-nfs/20261001045502.48381-1-snitzer@kernel.org/
v2: https://lore.kernel.org/linux-nfs/20260929231329.22018-1-snitzer@kernel.org/
v1: https://lore.kernel.org/linux-nfs/20260929173423.16149-1-snitzer@kernel.org/

Thanks,
Mike

Mike Snitzer (5):
  mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
  mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
  mm, iomap: keep a partly covered page until an uncached write completes it
  mm, iomap: let an uncached writer complete its shared pages itself
  NFSD: drop a shared boundary page only once both WRITEs have written it

 .../filesystems/nfs/nfsd-io-modes.rst         |  17 +++
 fs/iomap/buffered-io.c                        |  16 ++-
 fs/iomap/trace.h                              |   3 +-
 fs/nfsd/vfs.c                                 |  99 ++++++++++++++--
 include/linux/fs.h                            |   8 +-
 include/linux/iomap.h                         |   1 +
 include/linux/pagemap.h                       |  12 ++
 mm/backing-dev.c                              |  11 ++
 mm/filemap.c                                  | 106 +++++++++++++++++-
 9 files changed, 257 insertions(+), 16 deletions(-)

-- 
2.52.0


