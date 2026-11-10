Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F53760A380B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TtLwZxeY
Received: by kanga.kvack.org (Postfix)
	id F3DFF6B05B7; Tue, 10 Nov 2026 09:52:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEECD6B05B8; Tue, 10 Nov 2026 09:52:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7156B05B9; Tue, 10 Nov 2026 09:52:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABE6F6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:52:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32121C08B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:52:54 +0000 (UTC)
X-FDA: 85419501468.20.F293D91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3F53E16000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:52:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TtLwZxeY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6N4yimoRtRyrI1TQXjE1WplbXHKcJsyASw66CLWCFAw=;
	b=E2l++rIOwKfR/1spNw9P4tdiIL6+oe5Q1h4ajEsytUXvyhYSlJGecHpMUcGa7mCOHOKfJ5
	K/1rEw5W93GQ8Jw9Z0i7sHV1PaedqclkTCORReKEse7k0opMhYjkt09frHpfmBVnP2pI6Y
	25SsG5WCzSkoy5tnEJdlSBPgxxRLURE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TtLwZxeY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322372;
	b=gFD2dFGIijieowijuHXDjf5RTSkg/Q2ffKvfumKH+0bc2UVQRiP5lhZNvRxIeLk+oV+5up
	ARiGN4iU8mJZcS/VfSnCyh7pAByqP7otbd0ZaHUeIH7IoUpFmoJxubH3SwN7FIpQMYrzGi
	qiBUFCoBT1zw0Xy9b9Vzekn6LKLpbjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71648472B9;
	Tue, 10 Nov 2026 14:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDA31F008A3;
	Tue, 10 Nov 2026 14:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322371;
	bh=6N4yimoRtRyrI1TQXjE1WplbXHKcJsyASw66CLWCFAw=;
	h=From:To:Cc:Subject:Date;
	b=TtLwZxeYlUL/uDig4AnOw7rT4j0pf0Bak5Zr3u0S5zTys5YkIoPrnv9mBzydgUDJR
	 On67jGO2QQzV5z+3BX4xd9xVR6kgN4SfMcVizj7y1yV+IcVeZrhW92RKqE7op1sKqP
	 t2cn7SrK3DDQL+W4xaYF/GXwLJ9rRO9HkXB9vmta8hNCtQ2ARlz+KxUMV+hCxuHvb/
	 OFUr555Lx1yLSJejgL5jMpyc8Jzpm74bixxM0dZqF4aANNx7YtDsYeyc8g7qKuwlt2
	 QMisPDertw3NnI30MjpsSEQYjQnX2kVGccfEN+zJrQF801rvtKiS5ZKS5kwStB6gDa
	 oF7o2xZjVxqEw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7194E198003A;
	Tue, 10 Nov 2026 09:52:45 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 10 Nov 2026 09:52:47 -0500
X-ME-Sender: <xms:vC_zamIrxbPFlMqmqdH87bJ8oVb5OH4j-5QKaD2odtGRa378W4aMGw>
    <xme:vC_zau7iG6U6GWcxc4P6mny-A7p4SJoQZrrZvLs_mDvoGLiGsjZdk7uYTCRpA3s_1
    1pDVm15b8ig9mTHOvvB25nR04H1HdRS1wor-wiM5JgX1_RSKuuh0TDA>
X-ME-Received: <xmr:vC_zaqiyHoZbN0j8GQiEZphmP5JdoK7rL96QJ0IeJMI6ShVZYYp7Y01GchU>
X-ME-Proxy-Cause: dmFkZTGWr3Bol1il49kOQEDKgAYHsyZ47Yj7fzpOlw8TiM0gPuvQ5jH8a26arj7fWVWo8c
    uYSQI4gF+J/q2fS951R4MAEK6NSyHihCKPc8gs/Smt0oEHe2/ZNkgA1wFpTMe1NCyEh3Js
    2sOQFQl2u0oaCfgohyCrCmhrDmMmEdzNJMC3F6GAOQKLThCibPUBlYSTA6wtUNMKpaxtaj
    dGOb/Rq6NmezBvNu+QpQUTiCikoSwAPnJ0sPDBsm+TwW/3NvGIqVnTQzL+rnl9P96FOaud
    9QVmodzVH6f2pAiYKwBUmVjS32P99W7X/ARoxC9GGJiRXhxnK3ET71I2aLak1E7ScHgDGB
    Br2DNeeEux/MRQtpQWpWckTmepF25FWbH2zpcxILcX3v8zdpDpYA0mKU3vXWDmGveVY8nP
    Jm3J83mZ9Lzll07xzIjyxfcPXPgd0/Nl+jFRI2+Ps8w1WUGCVSC+Ut/B8cfsovYNhH4FfM
    k/Da/LpZE9KdncQ/IkxzRgPzAfcg2vDaR6C/9iYGSWEekPdaxHtpQSOVK/9sa+vHbA7FJH
    s4s9wxDy2pCNAajnA0e1t+EjuXIj13ZxLczwVQd1kW2RXOeKrM2qibYR+HQPyAAkmPdBjS
    nHeTjt+6RUR2pf7R3gO/B/J8SGsz4FV0ldaAoXhphfAKjj/wvDFOSNFZBPAA
X-ME-Proxy: <xmx:vC_zas-vjmx1sNJQtDUEDCM8_lWziIyZYE-z3yUvQdabh6AxgB9Tag>
    <xmx:vC_zasfIDq80AsPowkfGGXRBwH16uZwrkWAbUbUZRtxhVWFNuI1ChA>
    <xmx:vC_zagltlF42Dg5urBmLLPqDKIpm3LcoDVOkzIAZZ9nRyQsHR1qlxQ>
    <xmx:vC_zamyEB-uOy-v3wawnd3EFx3P_SgwV_COkCOJlzzDK6HB-7NVFeg>
    <xmx:vS_zalEVfRoL663tcZdP2A-__TD09DaIKUUbjs8zEKw0ZUSkCtuNvFAc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 09:52:44 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amit Shah <amit@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/4] splice: remove pipe buffer stealing
Date: Tue, 10 Nov 2026 14:52:35 +0000
Message-ID: <20261110145241.536019-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F53E16000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b4hhs4iknmx3uyw1u38anesmpywj93pg
X-HE-Tag: 1794322372-487123
X-HE-Meta: U2FsdGVkX1/L2qJaun7WUBvgsvt0m5NNeGA+mz+2iU7rAc+/klUBQoOm8F3y00ilz+aUgot/G687ffUcktKqbNvlbQ+wuQCea51/OXH4xAHos+22H3bomH8ysASAgtkMRs3EkkJe3nMg6/Ojb1SBnwy/PQf4IaSbDl4cvlHulgN1B5ERax9YYF7GypMukTWXV6AIUkLb0nLOWf1ZGXfoSZtsLTd2kPIxW/wbklsG6R3gDfMSHTzHggq3AhhcejkkVHkIP0LafuOJdLq+cscsWGmRfIfHOCLFuxPqOwuR3wd2gAhe1fKW/ubbfebZGcg5eThImWXu+Vencsm8SRYmd3FPmZ8MY3T0DVagf8RfgVrtRrYkJ2nLLyk4OujV3l6KydSReOruS0R7Bpan9Ij5doLMgGzJuZnFWR3K4Wrf3fbkTki+ThS0UOUxG8LIkn20qkUiAOYtL5JwmObcOsTRDxBKt3nhnHHLuhBoUjw298HsHqRYrex9vjUYHc9p82+TrL6rBRuamfbDC7ZM6MYSo1AGXroCZ/DRKAfDaJDIsM0476F0gRWAeVpARtTzxDN2nlvdPL4xnlWdrHvqfDnwrjGVYDCQg5UQkxHuRyO/qY3887X+01gXc+Pn3Oe0U+fz3j4XFKlbtoba21cBHaL8hmzO0yUmBaLahEsP9A9Gqjww8UxqHWPytZPWWzlxsFl7aI3Wq1I7FOTyofVWKlcZ9dKDSyjB4oYtJquaSj1+atVNZS8oUJiNapy/TPhSSFSR0rPyjkO+WrYggCM+eOogp+M5sQtQUow157nuHXY9taSqgWfqZ745LRsAKFBHkXKgdBurUNm2PIkMbG18zda+aGXep0Qx/waZXEdDx8X8ExCsByKK4BIZeDHITzLxqtLw/B9S2IdVvtbvbnV1d/k2ydiNIGXNq64ea1/3jW0AKXby3Qqloz1UptREmfkrNN7m4xca4ABVVFU4lZEOJS6
 Zqx3eYFT
 hDUmHO6z0XZuElO4EN5pxReoy+rzWtexabL5+TewM4gfYv1HBrLJAq9xTn4WxZDNSH18ifmyDumpq7tDtFjcGRg8S6tXarHdMcuPUhAm/aGtDv9SubZfebs1RPMwr0l7QI2gDGRBAYmnZnUgWVhfGU18vNS5eul56G0LH7Jp4ZV+WXWusk6nR/O2B0TjygBNTC/34xMmVPR+ECuYZmDwaMG0j5Z8CQ4OfrSnr7wiKCruWdmQwtlqYgXJIJZdHCEnn/5Tycn6mvEKhzi1xTCII2sIWNrs4IxGYoEz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

->try_steal() lets the consumer of a pipe buffer take its page instead
of copying the data.  Two consumers use it:

  - fuse, when a server splices a read reply into /dev/fuse with
    SPLICE_F_MOVE: the page goes into the fuse file's page cache;
  - virtio_console, which passes the page to the host.

The page can come from the page cache of another file, from a write()
into the pipe, or from vmsplice(SPLICE_F_GIFT).  Stealing it takes page
cache folios out of their files, and turns pages into page cache folios
and back.  That gets in the way of reading the page cache without folio
references [1] and of telling folios apart with a PG_folio flag.  It
works only on pages that nothing else holds, for fuse only on clean,
unmapped, order-0 ones, and it has needed fixes again and again:

  32f98877c57b ("fuse: don't check refcount after stealing page")
  b89ecd60d38e ("fuse: ignore PG_workingset after stealing")
  712a951025c0 ("fuse: fix page stealing")
  59ba47b6be9c ("fuse: Check for large folio with SPLICE_F_MOVE")
  15c20483d915 ("fuse: validate folio state before pipe_buf_try_steal() in fuse_try_move_folio()")

Linus and David suggested removing it [2].  Both consumers already copy
when a steal fails; with this series they always do.  vmsplice() and
splice() still accept SPLICE_F_GIFT and SPLICE_F_MOVE, and fuse still
advertises FUSE_SPLICE_MOVE, so that servers which ask for it mount as
before.

Miklos, Amit: do you know of users of the fuse move, or of virtio_console
splice, that depend on the copy being avoided?

Without ->try_steal(), nosteal_pipe_buf_ops is the same as
default_pipe_buf_ops, and the last patch keeps only the latter.

Tested on x86_64 with a FUSE server that answers reads by splicing the
page cache pages of a backing file into /dev/fuse with SPLICE_F_MOVE.  On
v7.4-rc1 how much moves depends on folio sizes: with order-0 folios on
both sides, one read of a 16M fuse file took 3968 of the backing file's
4096 pages out of its page cache.  With the series nothing moves, and the
data read through fuse is the same, also when the server reads its
requests with splice().  A virtio-serial port fed by splice() from a pipe
and from a file, and vmsplice(SPLICE_F_GIFT), SPLICE_F_MOVE, tee() and
AF_UNIX socket splice checks also give the same data before and after.

[1] https://lore.kernel.org/all/20261104130118.2507513-1-kas@kernel.org/
[2] https://lore.kernel.org/all/CAHk-=whhp=Q8qR+wPoM9+mxYPQ_OXMOEoKmT7J0JZikFZusuqw@mail.gmail.com/

Kiryl Shutsemau (Meta) (4):
  virtio_console: copy pipe buffers in splice_write()
  fuse: don't move pipe buffers into the page cache
  splice: remove pipe buffer stealing
  splice: replace nosteal_pipe_buf_ops with default_pipe_buf_ops

 drivers/char/virtio_console.c |  39 ++++-----
 fs/fuse/args.h                |   1 -
 fs/fuse/dev.c                 | 146 +---------------------------------
 fs/fuse/file.c                |   1 -
 fs/fuse/fuse_dev_i.h          |   1 -
 fs/pipe.c                     |  43 ----------
 fs/splice.c                   | 104 ++----------------------
 include/linux/pipe_fs_i.h     |  38 ---------
 kernel/watch_queue.c          |   4 -
 mm/shmem.c                    |   7 --
 net/core/skbuff.c             |   2 +-
 11 files changed, 26 insertions(+), 360 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.54.0


