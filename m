Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFEB5CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590458E0010; Tue, 21 Oct 2025 03:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542718E0002; Tue, 21 Oct 2025 03:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4575C8E0010; Tue, 21 Oct 2025 03:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30FA78E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:13:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1FB41403AA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:13:08 +0000 (UTC)
X-FDA: 84021254856.25.9FF1F1B
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf15.hostedemail.com (Postfix) with ESMTP id A4407A0003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:13:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Z60DI2qa;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf15.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JG6/21Kc3LPmm7ifFU0zEa7/qVfomGnzIkk8iphJ08Q=;
	b=4PqOtNPyTEf0maDdbaGnStWauwsp4XeeEHSROGiPwBj8WmlOXthepxy4gAEREZXJRLr7fQ
	nHryXZQ9iUE9HTQzhb0iuqra0Xm/EkQU8D+N4UqLxKStdvd55U66ysubr4SsmFUVuemdvc
	xXXLJR1Kzi1u3EFDlJGtAqUtRfYaj/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030786; a=rsa-sha256;
	cv=none;
	b=EdP5VxX9UHvsjs8k1GCrTnkCPUP4isVATvUhe3LgI57AB/GRHOGkHBusNkbfS8Jdl7cTx6
	nCdmcSx6xJXD28klTJTuBG5XOHhPi06cjOitQ7+Ql9aintQT96Tve+K2693kIxp/7yK2KG
	1D2KCkEUJf8pTT/vpKj/MiRgXoYcpgs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Z60DI2qa;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf15.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030786; x=1792566786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JG6/21Kc3LPmm7ifFU0zEa7/qVfomGnzIkk8iphJ08Q=;
  b=Z60DI2qaZXDwXSWMsxHof+fzuY2PZzuK3Em2ITfR9/IBtrXJL510MFE9
   0/CrpYuQoJggxGHNQA5noiDF2yiqzKm7XYpbcI557nuOZI/n/iprhijup
   VQB7ryytmC8vg67DkXsA/LdbiPQAi2DpMrWboMRTs+vVv1Ii3XtP80zsb
   vgwdHVyI4tKG/nL//PqP6XbyWzpTTf+UqvxJIyYiVw7b/lkrz3ljDBl4W
   EPpR/Xa9fXSxQVpDXXj/0kfELj9yzRt0ygYrtmjyRlsT8Jf63wTh+Yvhh
   mfGIUQv63P5gjEjTbn5+YpykmmwG4tXW1oND1Iqoo4gW8Q4OJe++6GwkL
   Q==;
X-CSE-ConnectionGUID: 9ajDuW3IRAqJTQOmqwROGg==
X-CSE-MsgGUID: w3M+VODYSFGUxfTSLykcsw==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3832773"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:12:56 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:1068]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.47.14:2525] with esmtp (Farcaster)
 id 1553515b-eb11-4da4-8ddb-b9d47464950e; Tue, 21 Oct 2025 07:12:56 +0000 (UTC)
X-Farcaster-Flow-ID: 1553515b-eb11-4da4-8ddb-b9d47464950e
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:12:55 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:12:46 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Ryusuke Konishi
	<konishi.ryusuke@gmail.com>,
	<syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com>,
	<syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Xiubo Li
	<xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jeff Layton
	<jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o
	<tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, Trond Myklebust
	<trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, "Matthew
 Wilcox (Oracle)" <willy@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.1 8/8] nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()
Date: Tue, 21 Oct 2025 09:03:43 +0200
Message-ID: <20251021070353.96705-10-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ajbg1xqrfkmzkrr5y5ih4uo366568rw7
X-Rspam-User: 
X-Rspamd-Queue-Id: A4407A0003
X-HE-Tag: 1761030786-473405
X-HE-Meta: U2FsdGVkX18lCUIEstDCB1kM3D1ansEon1hrEuxq7vA0rqmIS8goYNdIM0DDZnFGKOvheBhOU0Lr7at1cWnA/wTxxDu6PHVm6WwbGyptGo8FOw8sWdDQHb/VoxgITcl5dRbOzyA5ZUj1eYIgw3DXFs49F+wbQinKe7pcMBbWguu6QxmhZSjwuPMy7bLJ0ie87tkq0KMNdSCpB6mnWHZqiFZXF6aKC1dmlPV+QtiqcEi7/+bIdBFZI//4LfzGk+hm+UlqJQPKgDhVhyhO4VUO8ujM3tFtfrQ6Qi8mhnWDChmMrBzuGo0m80ozw2soq5dCkJECNM3HCFu+6EL77athr3kSTRuECyErKonHqCNO0WsoCwr8vNkVzHQfTfmbMq3b7aFThW1Faoz1FoAZwEANIsVw9yOot1obB1QawX5OOiPJS3ur1f9toI62mCeB0OoXeTH2qyzhqKdIkz45NEq1HIBBP7OMw5E1/5mWUzK/yWhgDHjTilAzI2FQ5DV3smaUTQJYCl45JkKxgocInZUta1u6mQ/HGwOL0yvH1SeSWiPDGEv12r2gXN7uVWf1Y6UmxpGezn25DkJnC+k/PmS/uuftmhQRBtwOWxV2bEAiWsD1ampvN5YuQ+ABFbJtJQLIrQ0DQHlc/uhnJMPnXVqQFQC7/3ap2LlJN0bWz3eDhnexNy+4+ht7juXnPNQiVzhgSC6H7yq3qS9+3Jel2PUVPBkUhDgEOJzDG5wgt9fdJFLWRGpkkoKDktigp16be7T22ctCme2zNb5+oJ/foxOwNTkxXomyZplMvQwdYDOTSEwS/QYTeCsx/QQBeI4iiIpRPX2Mw4Dx2AhZBn+G/n6fe2Mehp1ofmU9jHGCvM1t7Dp9gImZxsPvdWENpul2BQpKpnYibGTO1bul4Cmeibq9+u2GLW4o4pnxnM07L9g0i7kh9PqeX8yT2AKz4v7Bm6wxHwA8jXFEko+d5tMP8Yk
 glzPbv6x
 qHVShOtJhm4ub/k+hPinune/m/ger/fGfJ4ncip0lpGCSRjItUnEUhloK9FbLk5wT+0Z9yytYRr+HWNDKDZz5CfhM0MC+i5OGC1UMV7aB4nhoyMOY5dRjp4yVCuWRTytTd+U75ROxUuPca/S3jpL8nxnSyumf7TG5YCWi1O5cUXUK50kZ75XDcsP4Rf+rw4Loq+yn8FHDJQ8U5ctoK2yeHp2AYPnoyM60hoRwFRxymbPLu57zXX8xWhiAdvI/GdYYTlvORFUKfWMw3VMClw8xrsd/ntOA7WJKBq3cGbFRySiFx0YuLH1WvawKvnRiWtC4cTg43RjLmuvLSwqDpkrWfwcCE1S3oeKSwM5tOTb+EH0olbZyKR6CIW+o7UELiRV7tp1jHBOwFmdwAs7dE9F+c6spt9Wh1ar+U3me+407Oik6kmx2dnqZedAvRO8awQK+ecoSgqVsDDrFp5rI1lPdP88S1JQZqXs+pVwAKOp03uIBasuW5lCJwPfQpm4wlZhPryQghQ4xGKh7XgIbGnMsX6PT6HnRv6dfZPmoggwyUvBpsvG4ZQfJtc+28qEiCiaLKHrFiej1kFG5cLqTv2zWSYyqxUQToejZ7qMhjJWcOYdey/wpKBEfwYHBYQ9w3qxnfNQ6rnyGPmDrLL700w6aEp1W/WklPZd0/4ylbK+mmr63JhW0jN5XHc1HnXOo9hRUfvfE++nbAPy+CpDbHfU1Fjq7xaOMlNsNdZAzY+83QjYgAXsX/HTP7t/fwOjDBSfZ44QlDgYSeUkBNmnx6uCyL3Hf4zF4Ww0Cy7uJXuEQbLHDTgFDrGGbJnqpgxfCVEuEEc0GaVPqb7wiu+wAUIT3jRlgosyQLAcgkNRdNfp+m4Nc11C7ahObNBl0ADTAzNsagbFz9ZLsd80lVOsLLJXgVg9Q/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit fb881cd7604536b17a1927fb0533f9a6982ffcc5 upstream.

After commit c0e473a0d226 ("block: fix race between set_blocksize and read
paths") was merged, set_blocksize() called by sb_set_blocksize() now locks
the inode of the backing device file.  As a result of this change, syzbot
started reporting deadlock warnings due to a circular dependency involving
the semaphore "ns_sem" of the nilfs object, the inode lock of the backing
device file, and the locks that this inode lock is transitively dependent
on.

This is caused by a new lock dependency added by the above change, since
init_nilfs() calls sb_set_blocksize() in the lock section of "ns_sem".
However, these warnings are false positives because init_nilfs() is called
in the early stage of the mount operation and the filesystem has not yet
started.

The reason why "ns_sem" is locked in init_nilfs() was to avoid a race
condition in nilfs_fill_super() caused by sharing a nilfs object among
multiple filesystem instances (super block structures) in the early
implementation.  However, nilfs objects and super block structures have
long ago become one-to-one, and there is no longer any need to use the
semaphore there.

So, fix this issue by removing the use of the semaphore "ns_sem" in
init_nilfs().

Link: https://lkml.kernel.org/r/20250503053327.12294-1-konishi.ryusuke@gmail.com
Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00f7f5b884b117ee6773
Tested-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Reported-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f30591e72bfc24d4715b
Tested-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 fs/nilfs2/the_nilfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index be41e26b782469..05fdbbc63e1f5f 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -680,8 +680,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	int blocksize;
 	int err;
 
-	down_write(&nilfs->ns_sem);
-
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		nilfs_err(sb, "unable to set blocksize");
@@ -757,7 +755,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
-	up_write(&nilfs->ns_sem);
 	return err;
 
  failed_sbh:
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


