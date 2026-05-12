Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4778CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8FDB6B0088; Tue, 12 May 2026 01:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E407A6B008A; Tue, 12 May 2026 01:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30296B008C; Tue, 12 May 2026 01:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2F546B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:36:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 636F1403B3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:36:49 +0000 (UTC)
X-FDA: 84757658538.30.851B7B8
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id AC56A140002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:36:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KIK+jQvS;
	spf=none (imf23.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L6G3lv4jbdMbQ4QsNCiCXE8kA9OQYRVEnsOclxNjvlk=;
	b=8mP3WwpKwahDvVLZZRuwaW2pA5S3wwtWxLL4bxFNgGy8H1bWH2/+Ubkz/6VfNe0QXvqCsL
	JXzx9LmcCwpl7/ol7tjrhLhE3jVZ2bLguIEer2OzKRGY3gkHdXvpD9f87COvX8HIp7tl9G
	untlMLyPszvh/3EZwi9QiHaFexWodYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564207; a=rsa-sha256;
	cv=none;
	b=lc9rsj83RhKLxZsCAq1Y4datSx5iPzu0RKVZXQhEL71E6MLXyisAbWSNt+jHwS2XcxLHjs
	1Z4txBpp/SrbW29FyHcegCIuYbkt+MR1oBHRguCQGqOQuBm3gd0AaIpG/M2h7Vbn542nVg
	ZiwW7gE1B42pifHI3tjvtaLyq9QKle4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KIK+jQvS;
	spf=none (imf23.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=L6G3lv4jbdMbQ4QsNCiCXE8kA9OQYRVEnsOclxNjvlk=; b=KIK+jQvSnKRXIFRrePcKSt8tSC
	gTDIoVa3ilaBJgAv2JyiBq1oBQNEEVuR8cAKQZACHFbXeQgzOq5bCCS43yMoo3rZpQpygSiDzL+5p
	k8ewxMk5abPknkbI0BLQkk18U//bp1Se74dgd8ytTOIwgIqIRD8+j0upZnmtm9RP/nG0Iay4iv5BI
	0R0Ux2iGn5C8GSW0QkgvHRpchKQA0HU/3surCqZ+w6g1XBcpaQIEofBGAUjsWIOw9fW5TdRUHOoZH
	pIElcotsE4NXj4I4GC6C78nmVfU4K8GqhWK2VIAj1M/0+2fkttDIMP1Vqdy9WFOxCQtHvlSJJWz7z
	NqzmFnXw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfnF-0000000FfDa-0NfM;
	Tue, 12 May 2026 05:36:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: improve the swap_activate interface
Date: Tue, 12 May 2026 07:35:16 +0200
Message-ID: <20260512053625.2950900-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC56A140002
X-Rspam-User: 
X-Stat-Signature: xsg49qsrzdwy5yn75jbqu4eoka8gouro
X-HE-Tag: 1778564206-571828
X-HE-Meta: U2FsdGVkX18dW9JltFe4smzJriYMHiP/PRkfdqabwsQxnb+de5q1JjzaHdpmRh3SwiLUGcDVTrDHHgHSfuaB58y3irr1LvhtnX3Fbzxh99X3lORBqD6Dr+seB6amVPd6Wlgoja4s89hvvBawly+SwcG9ABRcGHPp5DPDdhS9zQjGSYnKzo0M32OsRidGpFs2CChz86GPaDP5887u62QpiBuQ0KqipGqLOPwJ+cckbN9qOEti3e8WXsiMnbVhkXHUjGNPbj8OtEm0fPhNUEGyDj0uieZSDeKNKFRnA8Zc4Fv4x6Qx/GwhrF1+chX72wSx86z0+xL+k6a/7pinaTN/lrgClEj/jDk9cmukF6SShcd/SwGqn5nsBV0+0CEj6YHTgsiRl1ct/LCKSNqKcQnxWRE61eSa8J/UpnX0H8BQQsVsoPz7LEK5KlAn0vXwDWbusKk+u/oK19S5khHhWil6SNXNUsT44lOa5dxlOvEgH3R7K4Yf4lsWdc6VyzK7QtoTOHO1GnttmnneBCqJFTu6+D7KNc3hrLUTJfn5fUzHtbPnyS0sZbnafOE60JRvGxkdtYGOHb6gUIo/VvTN8OBaMUyX9lCV/3FFjGDo7/gaTNZXTbaQV2VocszU5JAsd1/xD4iNHLLudEFCk2ph4FbwbwAc/gMJHIBId/xNBmXKwifdGs4Qcw0fLvtlp/tOLjOsEFUM+Yic1MtCB86HbI31aKW/MpfRlX4ydNlOh9miC9n5AMeJeeW4+eahyxihq7CFxZkmta6DFePIzg5sKMVkXci5OIg/I3BP08sg8wu5Jt6WAhXpvVjuAT2tWuoiR1Z4zQVOzdSn/C/1Ux6a3TOm88pgbgpcTvDc86Suqu/iiA1g/3y3V3TcmnJxEY72EvYExTARlstmj0zzXoMe3ugU51M1Dz9QT5mbVxR+RnJtmBiYkyPpmUUW46WAvrWBIAnauvWRV+wEYN9chHbohXc
 ouIjkL/r
 U55Rx+b70iJ1B60/vlZhGqTlEVSGA+t4/smZ7EBNHLLZKYdA+4XGBlbKizcfXfWy5DLUcqdw3Uafr/EGZ2c8ndq02spzWpYyafWguIHfLX8hesTUL1YVQSaei9J5PtYWltDSWlkptdIE0wD4cHejDxzUI8SLfxycb0XitDK1xIAGHr8tPQ7Q4hsaAtQJnkWWYox6pit9Ckt29efGuR3+IcsQ0oDWYup4lGvJXncfQbjs1qWqJ08rsBa4uLBMWEon7UrhwslJrAOuNdhdWR/fIhNg85KChRH3x+eGUt2oYp1kRajOMRnQA2BYmWhQI+nT7QF1TVDIxPD5ZtoH1g8QlgKSBSfHut2NRm5JvapToC8PQKzTm0JY78kuqal6qlvtGYQxJj74K8886aBE40h9QSbh3iNUor8ON/BB0hbNYi2b3TKQptIfyJ8xL8OhR8IeL8wwuhTgX8pM18zff4BzvEnKeFUKHB+RMW47t1FFoeprFsznNCSuAGrkfsmpRfHlv+Lzs5LoGrwcyO1Z3o6Uz1rFtd6tE9tUAZelyCZNaDuO0nVtFB2AR3C2kE51WJsc4xJiv5MIpkvgdCKxzB3bxyX2r6G0EvB2DX/QVkB6nyGcrXaJ9mGea53MX2qU1qrbji+i+o/G0Pz4sloD8kpnRaGNYC9bwaafDz87F5iCH8HgigLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Darrick recently posted iomap support for fuse-iomap, which was trivial
but a bit ugly, which triggered me into looking how this could be done
in a cleaner way.  The result of that is this fairly big series that
reworks how the MM code calls into the file system to activate swap
files to make it much cleaner and easier to use.

I've tested this with swap devices manually, and using the swap tests
in xfstests on btrfs, ext3, ext4, f2fs and xfs to exercise the different
implementation.  Out of those all passed, but f2fs actually notruns all
tests even in the baseline as it requires special preparation for
swapfiles which never got wired up in xfstests.

Diffstat:
 Documentation/filesystems/iomap/operations.rst |    3 
 Documentation/filesystems/locking.rst          |   35 +--
 Documentation/filesystems/vfs.rst              |   40 ++--
 block/fops.c                                   |   15 +
 fs/btrfs/btrfs_inode.h                         |    3 
 fs/btrfs/file.c                                |    4 
 fs/btrfs/inode.c                               |   72 -------
 fs/ext4/file.c                                 |    6 
 fs/ext4/inode.c                                |   11 -
 fs/f2fs/data.c                                 |   50 -----
 fs/f2fs/f2fs.h                                 |    2 
 fs/f2fs/file.c                                 |    4 
 fs/iomap/swapfile.c                            |  165 +++---------------
 fs/nfs/direct.c                                |    1 
 fs/nfs/file.c                                  |   21 --
 fs/nfs/nfs4file.c                              |    3 
 fs/ntfs/aops.c                                 |    8 
 fs/ntfs/file.c                                 |    6 
 fs/smb/client/cifsfs.c                         |   18 +
 fs/smb/client/cifsfs.h                         |    3 
 fs/smb/client/file.c                           |   16 -
 fs/xfs/xfs_aops.c                              |   48 -----
 fs/xfs/xfs_file.c                              |   39 ++++
 fs/zonefs/file.c                               |   30 +--
 include/linux/fs.h                             |   11 -
 include/linux/iomap.h                          |    5 
 include/linux/nfs_fs.h                         |    3 
 include/linux/swap.h                           |  129 +-------------
 mm/page_io.c                                   |   45 ----
 mm/swap.h                                      |   92 ++++++++++
 mm/swapfile.c                                  |  227 ++++++++++++++-----------
 31 files changed, 471 insertions(+), 644 deletions(-)

