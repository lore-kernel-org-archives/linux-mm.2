Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F20606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 15:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=K6ah8pAP
Received: by kanga.kvack.org (Postfix)
	id D71F36B00EF; Fri, 13 Nov 2026 10:51:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23BB6B05B0; Fri, 13 Nov 2026 10:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12246B05B1; Fri, 13 Nov 2026 10:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4F66B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:51:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38AC41401CB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:51:08 +0000 (UTC)
X-FDA: 85430534616.28.156DE1F
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id F3FAB12000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:51:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=K6ah8pAP;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf29.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794585066;
	b=XmmhDSBhWLY8GxI2+/guzoRYRljrLavUjGe27eDo1g9Oc1e0cFXNAPLI8Xtv6DbBtXBR3d
	ixxIn3ff50+oSpQ7iMfB07AcfvKoJRo3uDZMXjtSe4Enr6pJvSShIeixDJ/bdo39ua+GL6
	QOUV0Yvohm4s1n8bNL0ytAoyKW48CLg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794585066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttqAfDxUfq10cMBrxuj6822Y6w4QHwk60wHnUr65sec=;
	b=hDnWbYwOTtc4Ev7gzwTvtGGEHm10tLtp3mz9UYwbdng3cnHjeA7HPhtQMPLDkgygQTD33D
	QKUL1n+iNnecbMHN1ovkFWhomjeOVJ3Iu2gEWsJ+Ffrr8iOj+oVRIeN9wQz2xn5WoSXtdX
	0m7ONj+gvQs7n/rUjQoJ7uW84lg7KnU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=K6ah8pAP;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf29.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794585066; x=1826121066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ttqAfDxUfq10cMBrxuj6822Y6w4QHwk60wHnUr65sec=;
  b=K6ah8pAPjUEvreiAYDBqYH+TxJ4vHRlRfIv4HblQYvf40QjU1XF9GIeV
   ZUkDDopkSbP7peo0dpubEaOWL7PQzzm5G/CkYjH7z/mBIw6RgNiXZwJUF
   krNhbysPxSxuzG/bbMMoJbaLtBduikwgynxAh91GklyBAjLLzrtjCRUJG
   DHOXF2vlYBcAcj6StRRhCSF70agY18T0o+KtkANhYFodZ4rsx1hZ05q6F
   yRvjJdaxHnZntCBbbizp3K3hTbjiG2htgvwI5Sqfp3VYalM6xeOCnae/3
   c3AsK3tmF5wzzKYeCBefbI1d+sRzl8f/Uny89FCGoWxCGiycwiSrRljXU
   w==;
X-CSE-ConnectionGUID: mEzGvvEbQ/eZvW+yJkWFSA==
X-CSE-MsgGUID: 726PIJdYTv201+SXclxh0w==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33924868"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 15:50:57 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:27372]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 06ade6d6-3062-4e83-9e5f-28bb5c92f1e7; Fri, 13 Nov 2026 15:50:57 +0000 (UTC)
X-Farcaster-Flow-ID: 06ade6d6-3062-4e83-9e5f-28bb5c92f1e7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 15:50:55 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 15:50:49 +0000
From: Salvatore Dipietro <dipiets@amazon.com>
To: <jack@suse.cz>
CC: <abuehaze@amazon.com>, <agruenba@redhat.com>, <akpm@linux-foundation.org>,
	<alisaidi@amazon.com>, <almaz.alexandrovich@paragon-software.com>,
	<apopple@nvidia.com>, <blakgeof@amazon.com>, <brauner@kernel.org>,
	<byungchul@sk.com>, <cem@kernel.org>, <david@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<dlemoal@kernel.org>, <exfat@lists.linux.dev>, <fuse-devel@lists.linux.dev>,
	<gfs2@lists.linux.dev>, <gourry@gourry.net>, <hyc.lee@gmail.com>,
	<joshua.hahnjy@gmail.com>, <jth@kernel.org>, <liam@infradead.org>,
	<linkinjeon@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <ljs@kernel.org>, <matthew.brost@intel.com>,
	<mhocko@suse.com>, <miklos@szeredi.hu>, <naohiro.aota@wdc.com>,
	<ntfs3@lists.linux.dev>, <ntfs@lists.linux.dev>, <pfalcato@suse.de>,
	<rakie.kim@sk.com>, <ritesh.list@gmail.com>, <rppt@kernel.org>,
	<rvvandan@amazon.com>, <ryan.roberts@arm.com>, <sj1557.seo@samsung.com>,
	<surenb@google.com>, <vbabka@kernel.org>, <viro@zeniv.linux.org.uk>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<yuezhang.mo@sony.com>, <ziy@nvidia.com>, <kirill@shutemov.name>,
	<dgc@kernel.org>
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for per-block dirty folios
Date: Fri, 13 Nov 2026 15:50:15 +0000
Message-ID: <20261113155015.516481-1-dipiets@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <mcskrz2zbav5r3xtlwqytyotgjcmmi3wapeibkqornuhb3qp5y@qk22j77kvkqx>
References: <mcskrz2zbav5r3xtlwqytyotgjcmmi3wapeibkqornuhb3qp5y@qk22j77kvkqx>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F3FAB12000B
X-Rspamd-Server: rspam12
X-Stat-Signature: op8b9uoif5gc5njg34rxjbqts4sry3pr
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794585065-777423
X-HE-Meta: U2FsdGVkX19izMO1ger21VW9HjBEEiwk0lPjve46hp3lgAupNDYYe4XbFHjJvomgeUIrA7H8VwfQPTEUtZxTyI+7DIZSNBUS1ViSypa9oQUWF/0S2whK9uhxCWDjwkiB4PmBErUMTFMeh/GVcgHG7ZlkP3g4Gf9+6pchPRd7RMAw/6IIWAaQEgtAF4IWGiJEaacf8LyVkOO/ujpbo/HMrPNyXPuuz+5IwNSIY/CXNDhbmcuvYL/lEftIXUs4N022UjBmWDSNsts9VkG/dWm7poW5bhUHfIeluEzmr2V1CoVN0qjpxQxgmM7s3uqEaH4l62YP6CcHlCycv+Npw3TUU6Uvj9QrxHsvwCBZ3zTl6f2RqWZIqvC30op7Y6KxZdcj9AokxXc2bciMEo04gfmfjdYWV7n04lpDT6Z2izaXdIglrfcs+WcmprIi6ImN96/v7YGozmruoAX9erdH+UimuwqN/+8vxH4B+WZDeFOI0WW9MDQqQoMQHQyjiGH3I/L7JJtfQfPJzqyZD0bIETpOrpyFI4+E154wHhBRWNG9i/HSTXwUk0RuRFPy7mplKs3g7Oqkm0YvuIRkg0Me5fmQ/F//Xeb2lG+ts3XK+JFPaUOsnsQyH3MI1/vkfX3iC6l1O3NPqQXY5MEoHnMc/CjZ81/YeIdALD0T0xWcUW6G1JhbueTvGwKrGHgFjj8J3+BkLO4W2C3vfwP87PkwOaeBWFtEdUvhRfv/OGGNeHPB2i3V67GFPgui1Rt68Y0sVFYLiEgT/FTT0CSdkv5N+gI5xZtxRO2mnE6E9m3PwESWSg9pLzn+gK33/QFnJpSzpKNjP+Gk1w1UlZwudl2Pyk2bddC6uIE9Sa3UdQEXy/QLBBi3QJmBDnnxhxihR/TaDPOiKAAVlFaAFEuScONrXrpf+Gni6DsSBS9QU+/wJGpDGFcw4HDQOCTiRiGspIIQm0pC0nI8rqlFetIx/0IJCb1
 uBs8V756
 EbOK4+NF7AFwhwHpDhPMrVUytcLmGqhCXfAt3tAa/Qv4fHhil1kPB9qN4ffMoHbTSt97MT4ry+ByMSuITHQ5WbCY5AbkLvcUuFrJXz2C8xtlfMEplccDdHXHBf9jyKh/dfTOCdOZgwh0ZBIliJ3d2cSAXDBBAj0+2kfjjN0T2VKGCbPc7EUJDe3OvbwKBM2mnrVIgCuYJU2b/QMDbGieHIh7jIruBdP3hRElPaJnhCq3s38RY2BWDXiwssZQKbvggiF9sogNtehAKlZlMPz88kWzc3mSOCUgs7GOzvuSQCptAr+mi5bf74c5nBrQgZ73O2gYkeT3yxJOCZAQ9mzELDNlHdoNfZUDKenO5E5E6yLxPMEsgeihYdDqLaCgcH5lilHKW5N5oaFf/Ax94Pk6pekGCBcHbmSPt3Frj9PrZAjv530sOYbnW7YmkIrYII1rEXIBxDa7na1ZSGP47gTv56RxfXp6U/ucDPjkw7BCvyF5xc2v/kYgMU2aFjxRQMLIC433mFZlIzqUFdXem1Q2pt2QnLvATMXqquhU8uLbpWGpLCEA7ZPyYFqJFzyi6spL5L/WFH46AES9v8dVZDqHlijYbXhllTp/QIAUizdqOqPxyQfKBUBMihDZYXztXCcWvD9SkEdQM5mygv4LX2ekOyG4gUla+l3vFsq7Cn1rxIGSrXswsBWflAb1QQwUl1eifoeRScxN69O0FF6N/Yko8OeXfjSK6+fi0jRu6gmOJQBBesvSm+zl2h4suICf1UxhSCI2DxPBc5X5IgiNv1kjAqCPAVqZzzWthLizX8iT/SKMCXToFD4ChDy8UHx+J4URlp+hEasIalc0/+ONZpBA9U1UHdiYs++mnIrpc7J7eT5fR/M6FCzVrMjo6b6ZbGor4Dd4gSbK7w9ZNWMgoooL/Sl8P1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

Thanks Jan, Pedro, Dave, David and Kiryl for the feedback.

Following Dave's question about how PostgreSQL gets large folios on
files it writes 8 KiB at a time, we looked deeper and found a
reproducer that needs only fio and a single disk.

What happens:

  1. A buffered sequential read (VACUUM, a backup, a scan) builds large
     folios through readahead.  They stay large in the page cache until
     they are evicted.
  2. The first small write into one of these clean folios charges the
     whole folio as dirty: a 4 KiB write into a 256 KiB folio charges
     256 KiB, while writeback only writes the dirty 4 KiB.
  3. With random writes, most writes land in a different clean folio,
     so the dirty count reaches the limits with little real data.
     balance_dirty_pages() then throttles the writers, and they end up
     paced by how many folios writeback can clean per second rather
     than by the bytes to write.

Reproducer: XFS on one EBS gp3 volume (3000 IOPS), m8g.8xlarge
(32 CPUs, 128 GiB), default read_ahead_kb=128. fio's 1 MiB reads grow
the readahead window up to the device's max_sectors_kb (256 KiB), so
the read builds 256 KiB folios.

  ; create.fio: 16 x 3 GiB files, direct I/O so nothing is cached
  [global]
  directory=/mnt/xfs/fio
  filename_format=f.$jobnum
  size=3072m
  numjobs=16
  group_reporting=1
  [create]
  rw=write
  bs=1m
  direct=1
  ioengine=libaio
  iodepth=16

  ; load.fio: buffered sequential read; builds the large folios
  [global]
  directory=/mnt/xfs/fio
  filename_format=f.$jobnum
  size=3072m
  numjobs=16
  group_reporting=1
  [load]
  rw=read
  bs=1m
  direct=0
  ioengine=psync

  ; randwrite.fio: random 4 KiB buffered writes, 32 x 312 = ~10k IOPS
  ; invalidate=0 keeps the cached folios when fio opens the files
  [randwrite]
  directory=/mnt/xfs/fio
  filename=f.0:f.1:f.2:f.3:f.4:f.5:f.6:f.7:f.8:f.9:f.10:f.11:f.12:f.13:f.14:f.15
  rw=randwrite
  bs=4k
  direct=0
  ioengine=psync
  invalidate=0
  numjobs=32
  rate_iops=312
  time_based=1
  runtime=120
  group_reporting=1

To reproduce it, run (as root):

  fio create.fio
  sync; echo 3 > /proc/sys/vm/drop_caches
  fio load.fio          # skip this step for the control run
  fio randwrite.fio

fio asks for ~10k write IOPS, more than the volume's 3000, so dirty
data builds up in both runs.  In the control run (no load step) each
4 KiB write creates a 4 KiB folio: after 120 s only 3.3G is dirty,
below the 12.2G background threshold, and nothing is throttled.  After
the load step the same writes land in 256 KiB folios, and each write
into a clean folio is charged 256 KiB: the dirty count passes the
background threshold after 6 s and writers are throttled from 13 s.

Results on v7.4-rc2, one run per kernel, each on a fresh instance.
Writer sleep is the total balance_dirty_pages() pause time over the
32 writers during the 120 s write phase:

                         write   p99 / max   writer   max    folio
                          IOPS     lat ms    sleep s  dirty  size
  baseline, control      9,984  0.01 / 0.30      0    3.3G    -
  baseline               4,061    60 / 160     179   23.5G   256K
  v1 (this series)       9,984  0.01 / 0.67      0    3.6G   256K
  max order cap 64K      7,071    50 / 280      73   22.3G    64K
  max order cap 16K      9,984  0.02 / 0.05      0   11.9G    16K
  split on write         9,984  0.02 / 0.17      0    3.6G   256K
  evict on write         9,984  0.03 / 0.19      0    3.3G   256K
  POSIX_FADV_RANDOM      9,984  0.02 / 0.05      0    3.3G     4K

The control run gave 9,984 IOPS and max latency up to 0.30 ms on every
kernel.

  - max order cap: the global cap in mapping_max_folio_order() that Jan
    suggested trying.  At 64 KiB a 4 KiB write still charges 16x and is
    throttled.  At 16 KiB this run is not throttled, but dirty reached
    11.9G, just below the 12.2G background threshold.  The cap that
    avoids throttling depends on the write size, and it removes large
    folios for every file, including ones that never see small writes.
  - split on write: when a buffered write (iomap opts in, not for
    zeroing or unshare) finds a clean, uptodate, unmapped folio at least
    4x the write size, folio_split() it down to the write's order before
    dirtying it.  The rest of the folio stays cached in large folios.
    On the concerns Jan raised about splitting [1]: split on write only
    splits clean, uptodate, unmapped folios, so it needs no new
    filesystem state beyond an opt-in flag in iomap, and if
    folio_split() fails the write simply proceeds as today; evict on
    write avoids splitting altogether.
  - evict on write: same trigger, but mapping_evict_folio() the folio
    instead of splitting it (~40 lines).  This discards the folio's
    other cached data; nothing reads it back in this test, so the read
    cost does not show here.
  - POSIX_FADV_RANDOM (Dave's question): fio's fadvise_hint=random on
    the load job.  It avoids the problem without a kernel change, but
    only where the application opts in: the hint is per open file, so
    every process that reads a file must issue it, and a reader that
    doesn't (a backup or copy tool, for example) still builds large
    folios.  Every application that reads files sequentially and then
    rewrites them in place would have to adopt it, and keeps the
    regression until it does.  It also turns readahead off for those
    files, so their sequential reads lose readahead.

Split and evict on write keep whole-folio accounting and act at write
time, so they also cover large folios already in the page cache,
whoever built them, without each application having to opt in.  Both
only touch clean, uptodate, unmapped folios at least 4x the write
size, and only on iomap buffered writes.  Split keeps the rest of the
folio cached at the cost of the split; evict is simpler but drops it.
I'd appreciate your opinion on these options, or any other direction
you think is more appropriate.

Thanks,
Salvatore

[1] https://lore.kernel.org/all/oocwnxqgd4klrem6hkya3sddqoxkosml4ysz23if4j7wj2qdwi@5skgc4ftu7io/



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




