Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68605C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7AF86B00A3; Sun, 30 Aug 2026 00:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D055F6B00A4; Sun, 30 Aug 2026 00:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41D86B00A5; Sun, 30 Aug 2026 00:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5FD6B00A3
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B6E01A0246
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:40 +0000 (UTC)
X-FDA: 85156632120.26.49785D8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA20120005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SXgE0M1y;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Aq91nEzmhiWcCrw9x2W22xOz/ZEdIqQpE8kWR+O0NkA=;
	b=PMnUsrYtiiK6Q6dXHOHs43HALwx81HdcjcdQUMjNmTkY/nVtrPtAqSuLs5Q62i0GriZZlN
	YYaBMYFRRRnfq4W5r9hCY06G0/FmWk/uHzjdJrfpzVT7OXhcqlH4tkS1O+b0Wl4rCBGmsd
	fPFKdXQW7hKv/GYnVzIJwdNVv9f/AsM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063578;
	b=6Ldiq5UMIfY9K+H07srNQHW77+t+t6R93uaK32FVYp2zhXiXV+L1iz6is2j9O0yh+90GF8
	Yy7esJ73Bv0Q7CNC7Y4qfyo3SOVfIHabMXN9XdeDjcY6zJmgUS5XDh0Zh10MdHiFd+6MdH
	PXKrN+/jp39uPybRNAuHZjnqmzSeBvA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SXgE0M1y;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Aq91nEzmhiWcCrw9x2W22xOz/ZEdIqQpE8kWR+O0NkA=; b=SXgE0M1yzk/4IOCBxbi6JCeibY
	l/ZzAsS0d9y+MhWS2Zj9oR1xd6NyCOGh/uXFJXxsDD9xtXsFxzXDUTbwoYyo/r5vkaFA90qrevPzA
	lcSx0f7Ff8JB4PB2wkE+34bN9lcF3sELubj2ZVBVVIerSOgz/TMjaYVTkk0ruejPn9ra/2ubKqhLW
	ctO3gUBseMzwy+wqmQ1R2Fr2PyQcqg5BYkMS5LKClOhhCGxe1P18Ba7RoSizVxbOex3a5H+2Yow2J
	Jh9eKWbRJUSE/07pvTMCiIrwGBZjrjspB9zentyvDPzibetEfrvZQpHdqArWGUVK9Yi3a/4OxIb8n
	TXuImnLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Y-000000000hK-3Hg9;
	Sun, 30 Aug 2026 04:19:02 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/9] Remove FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:47 +0100
Message-ID: <20260830041901.2668-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dz1m7ygdg7wj4ksjpc36uskmxx4gtsc5
X-Rspamd-Queue-Id: AA20120005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788063578-253702
X-HE-Meta: U2FsdGVkX1/wcbO0LGWw6R6zKjd5s/zlq2ijlujrMnULF0bVJhAyaXbtF8AGk5xqtPgfXbHIoqylSoYkdiigAFGSGu2l9ExpGxgd483d7W10709fIuP93fUsyFWDbuplndM6Hnjzuu6Aj7ZxjeRfzjJAoRMffzVtdbBLZVxAc/TqczVps4w5KbWe/YY+wVvzseJpSUEKb5WlVLrwhVe9NpvsUjQwZjKbKbsO/s7ttDGBY03X3VbvQYRBAuPCzH4J8UXQ44Udb/Z9nUpyngwj7qS/damuxg5vzOt1CsljJpPRySPBCv5ZWvdcikHj6NX03nqwPV6DazxASlQyptiH6hMBg84QVZIgTNsD3LqXD53MlHCRzBSFGYRuweYhtGnUHIzm6g8ySzk4tV/cXdzU0JfSzGoq5TWpxt0oOSNjghEt9ppi+pY+rrcypxEGNquMSrglz6RjAeQNk5e3fhWR5ky4OeA0wwYsng8SofeSn2/zUpn7MIMN3+WrdsQFjd3hG1cR5tTEnVxTWTLDzwEXl7EZGttq8KKpTY1rB54Fxw5My5o7ymtcF7jrdH/icoDZ43pOxcGfT8T3xolIAFeLwGhJuQnrFtVkVgyHIZMKSqNyf2ZxmBRzsbi5ANIVP9rePl4K3Gko63+RL/UzAfpcmSa5pmjWqw7peyuCsRsdWjgk8HM/UgyTeE0YMhHNm1LA8INKtrXwFnInnZfnSUS+WB2nQk5rtnPMpn3ttJa2CkBkvNdwatGnHFZHGO8XCZpnchIZKqrgx5vZLGksN0mQgjroU7Oc4RVGty2lKfBsNIwtoypbyzCgdJO47oA+0Whxh+iaNJ4nWsd5VYoKis9Vv/RymLZj1Sp3G4B3u6SyJsSl+3It6jDOx3EGXx9C5AxKSdOje7ZD7GTF0AtQXKhPRkJzrFC1lvGGpttxpFAsUazUL1GfFtkiHLJs8RPaQJKPDqXZ5ohnx2nzy3s327G
 HhwDXLeo
 HrP702EOUGm8sKfweJcOB1o1Ei4QfXM6Gf5Cs2qKVFjC9IzNmGFNIbeeUYYYx5QdZK7CfuawYUxXvd977+2bAqReHy9H7QLNfeQpjOElkQ4SyKGkK3idlww4zIigkxuN1v9spnwQCML4e1Y5AmQBF+vgUNukWQmB9x3FYXjWNMh6+RqznzqIYaN7BCDMwXtcR81zEjO95+mbZ1l3JV/L7T02+jHaqZTFYCnRbZwyjeV5LylNeZoxmFdYd80fp9fxyW+fmrm18UvjC2q0D0V+arsnmf7HFdDx9pWHS5ozzyf799RBHgKN/M9jAelia0Vr/DwWr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is broad agreement that we should eliminate __GFP_FS in favour of
using memalloc_nofs_save().  This is a small step in that direction by
getting rid of FGP_NOFS.  It's also a nice simplification in its own right.

I added the documentation improvement at the start of this series, not
because anything depends on that (obviously it doesn't), but because
I thought the existing documentation was rather MM centric and it needs
to be FS centric.  Hopefully the cc'd filesystem maintainers will have
the chance to look at patch 1 and see if it makes sense to them.

There's a few different solutions here:

 - Filesystems specifying both FGP_NOWAIT and FGP_NOFS.  If you're not
   waiting, it doesn't matter if you're allowed to reclaim from FS
   context or not, you're just not doing reclaim.
 - We're already under memalloc_nofs.
 - We can prove that the MM should be allowed to reclaim from
   filesystem memory (and so specifying FGP_NOFS was wrong).
 - We can add a call to memalloc_nofs_save().

Matthew Wilcox (Oracle) (9):
  mm: Improve memalloc_nofs_save() documentation
  ext4: Remove uses of FGP_NOFS
  erofs: Remove redundant FGP_NOFS
  nfs: Remove redundant FGP_NOFS
  ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite()
  ntfs: Remove redundant FGP_NOFS from ntfs_wof_collect_dest()
  squashfs: Remove use of FGP_NOFS
  filemap: Remove redundant FGP_NOFS
  filemap: Remove FGP_NOFS

 fs/erofs/internal.h      |  2 +-
 fs/ext4/inline.c         |  6 ++----
 fs/nfs/dir.c             |  2 +-
 fs/ntfs/inode.c          |  2 +-
 fs/ntfs/wof.c            |  7 +++----
 fs/squashfs/file.c       |  5 ++++-
 include/linux/pagemap.h  | 12 +++++-------
 include/linux/sched/mm.h | 31 +++++++++++++++++++++++--------
 mm/filemap.c             |  2 --
 mm/readahead.c           | 14 ++------------
 10 files changed, 42 insertions(+), 41 deletions(-)

-- 
2.47.3


