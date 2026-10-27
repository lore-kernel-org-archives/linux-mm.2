Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF2A606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=QqfQj6Ij
Received: by kanga.kvack.org (Postfix)
	id DEBF96B06B6; Tue, 27 Oct 2026 07:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3576B06B7; Tue, 27 Oct 2026 07:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00036B06B8; Tue, 27 Oct 2026 07:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2AB76B06B6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:27:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48BA21A0494
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:27:30 +0000 (UTC)
X-FDA: 85368180660.17.0316D10
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E13940007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:27:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=QqfQj6Ij;
	spf=pass (imf12.hostedemail.com: domain of "prvs=753d3cd48=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=753d3cd48=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793100448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Zhv98/DMFgaVHqthgMh+5047LoW5P9chJ9n6zONF7MI=;
	b=0KjEWW3U4uSOjOVx8HUw8AYWLPZ/sc++HB8eqG3QU18u+e4a4rd4dYqHhuHLZnR678MsG/
	SoTf4uansfl7y0hUTdpqWGkakdKBEjxiKxK2AyxxoDs0dS9SwMfmwG3v7dYO9kmMWLj1L5
	IJt6otTLNg0cDt03qeQSsDO4xVt93Ls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793100448;
	b=e6LIepQS8b8P9Ly06CKT7SwD8WiWcBXX0OrEMSZLD9xcesC+cSU8aPC0C2liwy8C8PfeY/
	KHM9+h8ytV7IObLr5lYijNVFNlliHycQgIF76raoZjXsapREMFJUgpcTdW5219nQ2fJfHn
	0qmS8TYzXrEo54xC0pEFJQfOIOQmBCo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=QqfQj6Ij;
	spf=pass (imf12.hostedemail.com: domain of "prvs=753d3cd48=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=753d3cd48=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1793100448; x=1824636448;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zhv98/DMFgaVHqthgMh+5047LoW5P9chJ9n6zONF7MI=;
  b=QqfQj6IjSjyw1pr5sSUC9VVkxmlX9zVur4D0dn0HHywSYI4aBjSdqZK2
   1UlkYvom1MA0IRKO8g0j+ep6iUAO11BGhX7Limw24As8u8jIygZYFVFmW
   wq3gN+HWA16/gfW+YRSND1z9d79wQ3HNK6bjkr7Uew01EMLfSxeBRSgbX
   vCQJhcPy/FUCQawog3Wt+UIeCEVtnPmSgGgy54XugR0ndge11CkOH0v5Q
   vlVqynSeXlKMsrLMsSvTolGF25BmPNJtRNj1oam+F0NxmmrcX7beEmCg5
   Xqh5Y3t4d6KXkGGW5bGyQ0hFU4me6oenXOM0CdxG1pylWDus4eLZ+/pVu
   g==;
X-CSE-ConnectionGUID: cBtv+tbPSuaYbQZrAgM8pQ==
X-CSE-MsgGUID: fKISb3HxQf+nFB973LWUPA==
X-IronPort-AV: E=Sophos;i="6.27,181,1787011200"; 
   d="scan'208";a="32129592"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:27:24 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:27038]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.97:2525] with esmtp (Farcaster)
 id 11a1da28-eaf2-40b1-b48f-53da0e26ce8e; Tue, 27 Oct 2026 11:27:24 +0000 (UTC)
X-Farcaster-Flow-ID: 11a1da28-eaf2-40b1-b48f-53da0e26ce8e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 27 Oct 2026 11:27:24 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 27 Oct 2026
 11:27:17 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <ryan.roberts@arm.com>, <abuehaze@amazon.com>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <dipietro.salvatore@gmail.com>, <rvvandan@amazon.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<linkinjeon@kernel.org>, <sj1557.seo@samsung.com>, <yuezhang.mo@sony.com>,
	<miklos@szeredi.hu>, <agruenba@redhat.com>, <djwong@kernel.org>,
	<hyc.lee@gmail.com>, <almaz.alexandrovich@paragon-software.com>,
	<cem@kernel.org>, <dlemoal@kernel.org>, <naohiro.aota@wdc.com>,
	<jth@kernel.org>, <willy@infradead.org>, <david@kernel.org>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <ritesh.list@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<exfat@lists.linux.dev>, <fuse-devel@lists.linux.dev>,
	<gfs2@lists.linux.dev>, <linux-xfs@vger.kernel.org>, <ntfs@lists.linux.dev>,
	<ntfs3@lists.linux.dev>
Subject: [PATCH 0/2] mm, iomap: account dirty at page granularity for per-block dirty folios
Date: Tue, 27 Oct 2026 11:27:00 +0000
Message-ID: <20261027112702.3747009-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E13940007
X-Stat-Signature: b49f6sctpzugnb431yfu9yfyje1d6ksz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793100447-784147
X-HE-Meta: U2FsdGVkX1/1Ez7ZrTFJcO7Z2zgWMR8SGY1OGU3eA6h3x72qGn8H3K9PougIfuBPiotVn74q5XV0vqXPe9usbZqpuIcta7TmuExroKAGI41652MHpDdr2Aefy1CRxqMRk9j4g0wbOsGpbJGklltEB2jShiDY7EA3Vme+CPISmKN8w12kSRyIOdAflz7FX3TqzT573o4eieC2SpFOxQBIZPXaDwL9jNkxZ3QfyEBILYIJwlIuhb0jOiQMCILXNjD7oXproMxJaWc7B9TMZQNTpDC8TSqbLr9AQaZQt8yu3kYPfV6kRpI0pvFIVXna4Lc6R/60wW86jnq1tyRPnpAx7JFEvIiIQDrf1j/L+J12DGPdnZpJjJMxgCH1GJm6ptdXy1p/IoAPlDE2RdcFpsEIpJ5lfMBQCeHw5Dd/Zw1Y6ySOLfJvaMv0kopnmsdRr+CbymSMh8lItAheIIHjuv5lEKa92i2ASSOjgn4oQewKGYu+D1roFu5JqhRuWWyO44UKPfc47O9A2wXCmjmRlBdzOTIb07SozXuA3s69EZoaIBlGsVPY2B7dt/qQ4T0cQY6MFawx8eDA+u89gqpDxWoeA1B3PGBb7fmblrVvbFSzZLkq+6bN9fS8qiHA/KuoKYWrXLB0mBvjgn7Ufl0Ys4HewTFjngUMX89PcDJ5r7OhYr8B89ZDLLU/LpvZqIOOK9n6+rJd5J25aLT3AF+Ood29NF7VkcLaC6wi0EogfmTbL+7XdGrnfohpVPVPLuFV82Dh2O+sNhWuI8Y3eFj6i4gLPumgvnVclK/cVKpihLyi8A0Cgv5eLzxava7xuXS/LWHKAP2rj5KjvVzk1b92vPb0uI5Etxp6Nk3XGgy4C8k9QhcqzuI0M42GBHbcvBaZQdOJkHgO6YdvC/A4Ha3GqGWKBeQ5MiGekNg/Duqr/PT2S7fZgknTBQQDNwQDc5EOsVitepC2pa32yi+91+604X2
 7jrzDJ7j
 6q/NsRQac29Do7Uom9fkn1oLU3VC73aeuIKDeLqFcyda0SQwreHG88RFoSg69uNlYhPcAxzoKKPZQxtyXJil7E4w1bWJD4vUvORoN3AH8ZHnZ8iNg0dZN6+RwUHq7ZlZQ2jIWJW1Xv1o3/nT59VXT2QnmdoS0FgkHkm0Yb4s15AG3DiSmP5OukkgaCmLQWTMmyTxzK+gKcSZLPZKRaPSE2yBnxnuqp3cwkYPvmgggVYxeUqMaE9RHiCDHJpbcU+VuAWQRWUjKGKaymtGbFkTw3ScUWCdgsdSm6pp2B2kEyONqcbm03h9x4m1mFmq+UaiIw5LZdKJBlDln37fOEwy1FIVR7JVoyyXilieC8b9rAvu/g2pSurQpF1aij4/8pWBek7Ik9n2AitqFUJ5bdV1Q75weDjdsqY27tg44joNuFj8A55oTSXW8h3A7Xa9KRCN3r21V8c4NOB1RTC51DIQKdM1FDxyok1I7mVkMmBI4jWTPSbLJs7JZb/zX4jAHOmaLn6eZ9++lt2bDTnKSM4MXWgQbQz1ukw5yS9AfEe7uCGdrsYjJJdnYxiQsjmHishUh/LL2Jbs/WZVFBkwIdr5yJg5Wmm+tqA9ru0jWbJe/1zf6w0w80nAr+SNU4brG4cuiJkNUUyAWGHTnjIEqes3nIOxKtTN/CzJsgmW7i3aa99zxQfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since iomap gained per-block dirty tracking, a large folio can be
partially dirty: struct iomap_folio_state records exactly which
blocks are dirty, and writeback only writes those ranges.  The mm
dirty accounting, however, still charges the whole folio even if a
single block is dirty (up to 512x over-accounting for a 2 MB folio
over 4 KB blocks).

balance_dirty_pages() then throttles writers against a number that
is unrelated to how much data actually needs writing back.  On
workloads that repeatedly dirty small ranges of large folios --
e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
is crossed and writers are throttled long before the real dirty data
justifies it.  On the benchmark below, run on v7.3-rc7, the
unpatched kernel charges ~159 TB of dirtied pages while writing
~6 TB to the array, a factor of 27; with this series the dirtied
pages charged match the data actually written.

This series makes iomap charge and discharge the mm dirty counters
per dirty page for folios that carry per-block dirty state, so a
partially dirty large folio is accounted for the dirty part only:

  - Patch 1 adds the mm infrastructure: an AS_DIRTY_PER_BLOCK
    mapping flag, an @accounted argument to __folio_mark_dirty()
    and __filemap_dirty_folio() to skip the generic per-folio
    charge, and an address_space_operations::accounted_dirty_pages()
    callback used by the discharge and migration paths instead of
    folio_nr_pages().  No filesystem opts in, so it is a no-op on
    its own.

  - Patch 2 makes iomap charge per dirty page from the per-block
    dirty bitmap and wires iomap_accounted_dirty_pages() into every
    iomap-based filesystem.

This was benchmarked with PostgreSQL using the pgbench simple-update
workload on v7.3-rc7.  Average throughput rises 46.8% (139.8k ->
205.2k tps) and run-to-run variability drops from a 23.60% to a
3.98% coefficient of variation: the worst iteration improves from
97.9k to 191.5k tps, while the best gains 8%, 199.4k -> 215.9k.

Ten iterations per kernel, same database and workload (tps):

  Kernel                     Avg     Min     Max      CV   iters   iters
                                                             1-5    6-10
  ______________________  ______  ______  ______  ______  ______  ______
  v7.3-rc7                139.8k   97.9k  199.4k  23.60%  164.4k  115.2k
  v7.3-rc7 + this series  205.2k  191.5k  215.9k   3.98%  200.1k  210.2k

On unpatched v7.3-rc7 the worst iteration lands ~51% below the best,
and throughput decays as the run progresses: iterations 6-10 average
30% below iterations 1-5.  With this series the decay is gone -- the
second half is similar to the first -- and the coefficient of
variation stays at 3.98%.

The over-accounting has existed since commit 4ce02c679722 ("iomap: Add
per-block dirty state tracking to improve performance"), merged in
v6.6, where the ifs bitmap started recording partial dirty state while
the mm counters kept charging whole folios.

The throughput collapse bisects to the v6.17 readahead series, first
bad commit c4602f9fa77f ("mm/readahead: store folio order in struct
file_ra_state"), which lets readahead stay at the largest folio order
once it has ramped up, so a single dirty block charges far more than
is written.  Patch 2 therefore carries:

  Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
  Cc: stable@vger.kernel.org # v6.17+

Test environment:

  Hardware:  2x AWS EC2 m8g.24xlarge
             (SUT with 12x 1TB io2, 32000 IOPS each, RAID0, XFS)
  OS:        AL2023
  Kernels:   v7.3-rc7, v7.3-rc7 + this series
  Database:  PostgreSQL 17 (with huge_pages=on)
  Workload:  pgbench simple-update
             1024 clients, 96 threads, 600s duration
             scale factor 8470, fillfactor=90, prepared protocol
  Runs:      10 iterations per configuration

How to replicate results:

This script starts two AWS EC2 m8g.24xlarge instances (SUT + driver),
then installs, loads and benchmarks PostgreSQL using the
repro-collection repository.  To run it:

  # Reproducer code (dirty-folio-regression branch):
  git clone -b dirty-folio-regression \
    https://github.com/aws/repro-collection.git ~/repro-collection

  # Concatenate patches 1 and 2 of this series, in order, into one file:
  cat 0001-*.patch 0002-*.patch > dirty-per-block.patch

  # Setup and start PostgreSQL benchmark:
  KERNEL_REPO="https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git" \
  KERNEL_BRANCH="v7.3-rc7" \
  ITERS=10 \
  PLACEMENT_GROUP="pg-test" \
  KEY="$HOME/.ssh/id_rsa" \
  KEYPAIR="<aws keypair>" \
  ./repros/repro-postgresql-dirty-folios/folio-reproduce.sh <benchmark name> \
  --patch="<path to dirty-per-block.patch>"

Salvatore Dipietro (2):
  mm: add infrastructure for per-dirty-page accounting
  mm, iomap: account dirty at page granularity for per-block dirty
    folios

 fs/buffer.c             |   4 +-
 fs/exfat/inode.c        |   1 +
 fs/fuse/file.c          |   1 +
 fs/gfs2/aops.c          |   1 +
 fs/iomap/buffered-io.c  | 167 ++++++++++++++++++++++++++++++++++++++--
 fs/ntfs/aops.c          |   2 +
 fs/ntfs3/inode.c        |   2 +
 fs/xfs/xfs_aops.c       |   1 +
 fs/zonefs/file.c        |   1 +
 include/linux/fs.h      |   7 ++
 include/linux/iomap.h   |   1 +
 include/linux/pagemap.h |  20 ++++-
 mm/internal.h           |   3 +
 mm/migrate.c            |  17 +++-
 mm/page-writeback.c     |  91 +++++++++++++++++-----
 15 files changed, 286 insertions(+), 33 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




