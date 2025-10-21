Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25702CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4767E8E0006; Tue, 21 Oct 2025 03:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425DC8E0002; Tue, 21 Oct 2025 03:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314B98E0006; Tue, 21 Oct 2025 03:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC038E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:09:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0FC4B8C9B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:09:12 +0000 (UTC)
X-FDA: 84021244944.11.24A59E3
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 913C41C000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:09:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=R8skiern;
	spf=pass (imf18.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4aKg8jaea9UUgjVGAZ9pvPl/2rw7Jg81FmzroUsdh8U=;
	b=oomRj/K45vQHNKKU7+cSHiVrjDJS8z8co+56wvFJR9uvFYqC4ysYMa1Ug6+452RKAwuesG
	IU6JelR6CwyBLB05FdL96w+aj4wamCDV36K0Gv3Oi5lKsp2TnBajVAepa0IUXcQmJJDhYF
	xKHSqo8mXqNz0ppthI9epWcuQy5DJfI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=R8skiern;
	spf=pass (imf18.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030551; a=rsa-sha256;
	cv=none;
	b=Vc4b/T1g6/Eej+anqOOfRyEBzBeeZd/4/HAKN15vXIFPqi3+SGekcDa5Tr0rR1/53u0aw3
	8b/joxy2uaIC51vjrovbK6VSNwqEylBwvhKhdXVL9K4gxO1ZumB/V+QXXamkKf9pp8Seff
	oSAs3tyE9IY2ED7/L4n6jRP6re8M/gQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030550; x=1792566550;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4aKg8jaea9UUgjVGAZ9pvPl/2rw7Jg81FmzroUsdh8U=;
  b=R8skiernNdS+JZmqa+x+tKyWalVpR0S7v/5t1NjSoI8hh6BAR8lMhfoK
   QL5XzRqrqxQv+g6uEgE9vb+N3gK4vd3u8wCln+qIIOsyElANGyLAW63AU
   PXpX/RcaHf0zws6bzcKRd+crOYdd+8LxIAVymbRr4VaOWxdIK2Ik2n7Ns
   lQvrO9tPTLgqas3XTWwT+gSWQZ9+oVp1p1MlGDIev5s5FMW1SB4RGhGjB
   nm3w6/U4omZanaObOJvllnevhLVTWySYmPFdZvfGXjCFUo42mJnaBwpAe
   pueO5DNtq0OpZyhkt6czLXwSVDJK225maGSUxrtboZ7mCjFoac52of8kW
   w==;
X-CSE-ConnectionGUID: xhZ9wZyxSpmrCzcqqePl8A==
X-CSE-MsgGUID: 8WykqeV0SPuRFwAH0TlCVw==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3934174"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:08:59 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:10631]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.22:2525] with esmtp (Farcaster)
 id 3750a0e3-50a3-4ee5-985b-1ddb7d86a82d; Tue, 21 Oct 2025 07:08:59 +0000 (UTC)
X-Farcaster-Flow-ID: 3750a0e3-50a3-4ee5-985b-1ddb7d86a82d
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:08:58 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:08:50 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Jens Axboe
	<axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov
	<idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
	<chao@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
	<djwong@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Anna
 Schumaker" <anna@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, Damien Le Moal
	<dlemoal@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.1 0/8] Backporting CVE-2025-38073 fix patch
Date: Tue, 21 Oct 2025 09:03:35 +0200
Message-ID: <20251021070353.96705-2-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 913C41C000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9khfqu4i6hu365zku7e9rx9kfwoemyzg
X-HE-Tag: 1761030550-119906
X-HE-Meta: U2FsdGVkX1/BPVFjc0Kd+DQUO8dfaaORgeqY4sl50ceJJ83O29aTt8d6Xlb8OEODeAPHTTkNM+F6kzZtmSAAZo78Dz1RIhj7FRF+rhrtl9J89yHFBlrFSGOFWcxjns8Tnuxv2k6/oD179ZjL6xeOu+T53FbLXNG5T7U0iHyQuJR3OXoLL5q8YNIAjz4Qs0GOoh96jHXgwIduceBZm0otIX/l83Fn84j2YbbwVvtCveFB68atsIczMdV0MczZWymTQP/A3ixRi+FJcGo/URa1d/IKAsHaMQ4MW7tmfVCWwi6178TzyEkuqth8miJXlm8N5+r90X6XYCRk8GZHS5b7HfE6rVuVC5fhBbwdMYGBWIAVQaYH3SYFgNofwmbIEGx8iyluTFDnbnQSCoY03YcSlnnmaK5/1IGtV0IR7N6RQa1wExx9CerLrXy3JrAtywDWPIwS+r+t5SE7sabRnv7NWBjptFhmqDyYQi11sa7I8JMJ7yEsItclJYbUI3Sa03KeozatijUjpZIqP3gC5G6jU1W50b+Qi1S4QPzxuq21+ajFPWldsuQ+UmIJisRYFwEA72nrJLMALj1CubvHX6tL+gmS0lA4qAyYA8kYR15XGHHTWTYph/M0tl1HsO8dR3twg4xQHSJkq04W+SoLmZIw8LKuC3O0BIg0vBS36ZddzGQC+ejioFX9EZWhxOK09AM5/Dt2LqgwH2Wd+6sDTDhsOoiybvMgnvqtrsleEngXpDa6QtxR1cnxpjmmGtcSNbjXvd1y7Cv5aOEwtH3hT8ZF9EpLcbQbL4RDpL2xtT852Z2o+DBOgsK9/FTxvPHGsyPlReprP7jDykST1o3MefOYcOMGvzUEkfKmAax49QRxz1dBOTlrFIl0esgBvGJOim40uPd2pI4W+iivHYY+iaCdYu6mWRtc0mXb+jPmFbqEY1IjXizL+EAIxI/WalwePtq2wq6WDgLlcQe1KJMHU5Q
 J67jK+fc
 dCPt+Cl1ksCeDXF9NC71XJICClNxSrSrQth4W8mzCikNdkiiPeQ6JRnIfmAbFQUZ6QjnuGG18VDD6qGKOc9DQVyo4zzsDHEcukSi1QxGr5XBMf7ph210owtGsZCYXuRR6Ox20SVscHNhsajQ8YyvXHLgQcT7XmEjnpHryRT+04xWYkEbKUSufUq1rY02YZ8kePUvokfi6RufYF+Xt08GEWaSZWsupJoapPBZ6u5lToE4vKRkCSBJwkslVt3Bp3D7nIdnJ6kYUF3FpLJqYLd/ZLdQAibfyp6qHNEF77cWSvoOxmQDGL/suTJqw2+HEpKAcUz27XGm2Nr+dqFoXpUFcVkyu8iMwMRnvKzZDQF224gF9MpstXwR7BMW5Wuvgk2REDlvfg0PkTudkWhPyLXVxSREffGBF79Hz/PwwsyIUBD4tWPgZE4RkXX1BRaMKJMiV65aTf/BI7r/f6CuhXioEPy1Kv4l+370rziXkN6IjUSp6vG4HpfAbTnzALbyTuk4Y7MIBL4xz0q3S9RIY9QWP6u0tMc39t98RSkfXoMq3wtMK1YuJSwXfCTyqk9jl78fxLjTzLELzd1KfiEOz2Q8d6IMvhT3g1+aHmHookOSMLzHdubQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series aims to fix the CVE-2025-38073 for 6.1 LTS. Which is fixed
by c0e473a0d226 ("block: fix race between set_blocksize and read
paths"). This patch is built on top multiple refactors that where
merged on 6.6. The needed dependecies are:

  - e003f74afbd2 ("filemap: add a kiocb_invalidate_pages helper")
  - c402a9a9430b ("filemap: add a kiocb_invalidate_post_direct_write
    helper")
  - 182c25e9c157 ("filemap: update ki_pos in generic_perform_write")
  - 44fff0fa08ec ("fs: factor out a direct_write_fallback helper")
  - 727cfe976758 ("block: open code __generic_file_write_iter for
    blkdev writes")

Also backport follow up fixes:
- fb881cd76045 ("nilfs2: fix deadlock warnings caused by lock
  dependency in init_nilfs()").
- 8287474aa5ff ("direct_write_fallback(): on error revert the ->ki_pos
  update from buffered write")

Thanks,
MNAdam

Al Viro (1):
  direct_write_fallback(): on error revert the ->ki_pos update from
    buffered write

Christoph Hellwig (5):
  filemap: add a kiocb_invalidate_pages helper
  filemap: add a kiocb_invalidate_post_direct_write helper
  filemap: update ki_pos in generic_perform_write
  fs: factor out a direct_write_fallback helper
  block: open code __generic_file_write_iter for blkdev writes

Darrick J. Wong (1):
  block: fix race between set_blocksize and read paths

Ryusuke Konishi (1):
  nilfs2: fix deadlock warnings caused by lock dependency in
    init_nilfs()

 block/bdev.c            |  17 +++++
 block/blk-zoned.c       |   5 +-
 block/fops.c            |  61 +++++++++++++++-
 block/ioctl.c           |   6 ++
 fs/ceph/file.c          |   2 -
 fs/direct-io.c          |  10 +--
 fs/ext4/file.c          |   9 +--
 fs/f2fs/file.c          |   1 -
 fs/iomap/direct-io.c    |  12 +---
 fs/libfs.c              |  42 +++++++++++
 fs/nfs/file.c           |   1 -
 fs/nilfs2/the_nilfs.c   |   3 -
 include/linux/fs.h      |   7 +-
 include/linux/pagemap.h |   2 +
 mm/filemap.c            | 154 +++++++++++++++++-----------------------
 15 files changed, 205 insertions(+), 127 deletions(-)

-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


