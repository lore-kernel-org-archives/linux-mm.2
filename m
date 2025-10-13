Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B70CCD184
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4B78E0003; Sun, 12 Oct 2025 22:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CCF28E0002; Sun, 12 Oct 2025 22:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909DD8E0003; Sun, 12 Oct 2025 22:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6C18E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:58:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 052BD139E7D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:29 +0000 (UTC)
X-FDA: 83991582780.07.34F884B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id C383F180006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yvdjWMe1;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf16.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324308; a=rsa-sha256;
	cv=none;
	b=bMBB4c5RY4IDZTafjLKKf8gMKFV1KKqy9G6qcqEmO5waDx/07x/Uoy6a0Zdnti9ArdeB+w
	Y1IYkG2mCcdfsyLe3DYTBdlics9qkox+bgt9ZedGvWIwAoN9WxQz2bRLxD7FkKn9xXFAgH
	z8GIaFqH+aDpByHrVOpZWCZJ9HSFv/c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yvdjWMe1;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf16.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IHawD8fXUsjzdqrBUJCMerdnKe9dIKJrBNuL1oU4Go8=;
	b=tnoqGoId5wl9QTRy/R32I+FGX7v7pTb2lynsotnywouUQVqzYsrvimTNI+EgA8/A0e+YfO
	gvEPvR/gdqbIY8U8jwzpfeqzGqmTcaytg5Kkfbe/WB4jdU5OxGhlScBe2lXuBo7oHb09ZQ
	dJKauVWZxzPeSStEbbKS8PRUrPJCcoA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=IHawD8fXUsjzdqrBUJCMerdnKe9dIKJrBNuL1oU4Go8=; b=yvdjWMe1dksG8iFjNpFAfj1aEe
	A4MWib46wBHcELj51vFEJO1FLURpC0ChP3zWMAbP1jVF8ZtIJeMFGaZBYOfyIb3JZv9EPNHcHyllA
	eYIMXJljTYaRflblHSUsTsymqH6ITRsIA/qMfc+J4kwlkTl+8MWSWMuqKQF/uNtPh3pLBGTwqZSok
	iRlxAmYhIXlHBc01mgkwf4erW9kt2zjKSasJn4hFaFiEOON7+nvcIDjaSpR6Y3/O6qKbpANIlYJA1
	0qjIoWDwM9gAzWid8AygMqkE3HXcdV4HfOjr1wWfM1JqnEXNDAb0WBnodQObMz4C9QP0qa6KSqWd6
	x8Pmt9ew==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88lL-0000000C862-27OS;
	Mon, 13 Oct 2025 02:58:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: filemap_* writeback interface cleanups
Date: Mon, 13 Oct 2025 11:57:55 +0900
Message-ID: <20251013025808.4111128-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: ftsrdkdq5crpczw5pdgyunu4a6eczkmx
X-Rspamd-Queue-Id: C383F180006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760324307-662528
X-HE-Meta: U2FsdGVkX18oRb5nE98pUoYt6AndQLE375EdE5QizOz0lzKYm45U6RueWJjQZES1n0yxUw4WQblT64HyttYKjJeHiO5luCxmpu+vm9YoKZZJTAXMs273f4FPfvjzp/PrUeSC6ac2tMgWA3NoOiMLRR7oHN5fSyFszdlchBLGgEn3Rwq1TcoKriU3vMyTUzudxv1NWzYwoWDt3HD84+oPWbxbcOx2B67hobFMC/KxWtrLsPI4OczhZe0cajcypXlMIJrUIhG6Gn1CtoVIMliJc4vGhJKm6z7hzm5FfMmI95P3XNf2KVB/wqtVx+ulOsnljevrgeJg/3eQMeppqz8DH9klnSy0OZCpCvh6e1PoY+mnMWJR8vf2U/tKvQ7hYtmPQEI9BrKCrsxQ8fpsiVaxhlbTtH2QMDH2RLPKxTBa3p/U1ehDrqIVYinrSdjbM59mFtaYtw7b8xhDaA+eE7Dr2Vra+Fhs5FFcoXM5mFLbN0Nyan8z66AOx+VQJW8mMn9WECQB5C7hja93VietTmEJ3mDkSwEijsA6V9ra4SQ/KH8wWVDr+TMt6dUumzsAJXl1vQeoCXecGjZv9RJpljhWegw88w+WayF0lB4TLIbiw91aS13g0WksIV1yPykf/NdeR0l/IlZkVlaMwk9ZZfqbog0ObVSBlsTVN4r22uJj1eVJM2cf2UJ1p5uJdUi7IyQnFP6FiMxzGS595mas/jfE7t9jQHAV/ffd9BKkvglVvF/IoHiqrmFcjKVQttQDuXMmoNZ+X3DUcwsgwH1N21qA39QnA/IFg1Acuygv0gmg2ZM5AqLTRJMbniKgEvpSt0v3vy7sesK0Dej/fCCk9vsf24pMlbWxiOglpr+23vVZYkQWpzXcTWndGoyphDdiynmuvv28GPY1864KOTMoowrEs9eQbr29UFNOqrdu33DNh4hStK2tJh5qTN2lpRhQ3MNawhstQnZujmti1+yIC96
 EyQv9TB/
 DrhM4gWZSYW/DTIL4tDWHim7YJIF7I6tzpRn+mD/4JWMkdYCeiCXN8jEkOWNps7sWBVnYHEqX8JXP/3ZoAgmSHpIuaNOQDO9RiGCgGQ1z6eg46M3Yr/W5dpXCFSdeUoVHvLiLg/iJP8hPwxLZkTXgl4TyNBXihELTpAV8mlGHnZ0mmqAugVpL+Vu24b/AGbYFIupolREqCQPCha/6stidTkv9sh04nFN4vOWaOACIGCPIgzg50tkxc0WueWhLTEXrtDJy63SkJUdCILWk+eQ4uPCXKddK2gURn1c7iFteFVVdryJk8juXHLHWYUEt8loMoAQtAnOZo5BDDw0QvrUqUFjkuOqR6utKnKTd6gC4TJvZ2ykRpH8+69Jly205OlnTtwUzcNVQFURcy/USaeIv76yANoEH+FZbkVRT2Snm8Qd+Vto/mxkGzKZ8lY7HwfYJybN7Q9xx/OM9SYRuS/UZnZ+g0rXlhqBCsJQzXmz3+wzUBK4K8YG3F7csuscjmVB9rGt6qPSZpfUHFVzjZUC4lZ8g//4DcxjzsRI8B4k3LJmMlHZR/6GpoWeht9iErTRRnMFYBhZX5ovIeRN6tTMSklOIntyFutOYoFtlM/k9HG7HWGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

while looking at the filemap writeback code, I think adding
filemap_fdatawrite_wbc ended up being a mistake, as all but the original
btrfs caller should be using better high level interfaces instead.  This
series removes all these, switches btrfs to a more specific interfaces
and also cleans up another too low-level interface.  With this the
writeback_control that is passed to the writeback code is only
initialized in three places, although there are a lot more places in
file system code that never reach the common writeback code.

Diffstat:
 block/bdev.c            |    2 
 fs/9p/vfs_file.c        |   17 +------
 fs/btrfs/defrag.c       |    4 -
 fs/btrfs/extent_io.c    |    3 -
 fs/btrfs/file.c         |    2 
 fs/btrfs/inode.c        |   52 +++++++---------------
 fs/btrfs/reflink.c      |    2 
 fs/btrfs/super.c        |    2 
 fs/ext4/inline.c        |    2 
 fs/ext4/inode.c         |    6 +-
 fs/fat/inode.c          |    2 
 fs/fs-writeback.c       |    6 +-
 fs/jfs/jfs_logmgr.c     |    2 
 fs/ocfs2/journal.c      |   11 ----
 fs/sync.c               |   11 ++--
 fs/xfs/xfs_file.c       |    2 
 include/linux/pagemap.h |    8 +--
 mm/fadvise.c            |    3 -
 mm/filemap.c            |  109 +++++++++++++++++++-----------------------------
 mm/khugepaged.c         |    2 
 20 files changed, 95 insertions(+), 153 deletions(-)

