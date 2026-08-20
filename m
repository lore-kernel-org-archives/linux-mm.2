Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2452CC5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130F06B00A3; Thu, 20 Aug 2026 15:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1D16B00A5; Thu, 20 Aug 2026 15:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12C26B00A6; Thu, 20 Aug 2026 15:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAA166B00A3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:34:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5339C12028B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:07 +0000 (UTC)
X-FDA: 85122648534.27.31F9F64
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EE43A0013
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=C00zMhG8;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254445;
	b=AtqEzJ8p7K3cn/V6bV3PpH3CaJ9ls/XLPHQT9mqY4wMF4TmpLvU6G2XjarvZNpknIsyO/Q
	ED9BHtXfunLEj9C+NgU7H0q5SsayfSeuLDM/0zULMc/iufSmjyxF3dQPUZJWXVJdJ2Z9Tm
	th0zTtyc98k9Ld9j8HGEKo5TryQ0xTE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=C00zMhG8;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yAWljnoK+mvLqOvoWL/pFcjK82r/RJzikRAIfFTqyqY=;
	b=se1W/hQ1Few3hneEvtXxnbm53GjBhDfevWNm23NuER7dleNmOlnpAWllXk1DEo0G5hGQ0I
	PSx8dDrPQPOYi38C4QRbKhMwNUmLUoLe2/ZTxDoCi6w8FLjxcxJdETg+APCBGHaOrbNBTx
	ZoktP1YvA+lXRIAUI3aRRBtki7ZPOrQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=yAWljnoK+mvLqOvoWL/pFcjK82r/RJzikRAIfFTqyqY=; b=C00zMhG850WU4xETzkGWp3TH+/
	PUkEAO3MfrJqpeL9uJ2FjdY+CEkLzKmXyFcIzfbCvf4OxOe2/+gV2ZN2KcvZ+pM7C8xwvvxear6rH
	V1BT3J6G7WSU/Hqhc5r7m/kGddxOTrDs1SqwLrrvgNgh95Y8O5fNNx8rmdATP0NURw5xGH9hnZ+zm
	4BoAUzj9B9jhKVg/tixHzG/jYKm5e6FcLyHizYp8tsd1mjChY/D2Lv5vcJIPfJMEkzZZCVw0ncayA
	m7aYUGzSo6HADhCJdm90phuEz1RKeOPc3PPlWi+dg0x+BQWPmGfcVOfD0cgf1UeI8g2XDxv2H7w/E
	z/+gF6OQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx8WG-0000000GALU-2Ve6;
	Thu, 20 Aug 2026 19:33:44 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 0/7] Remove aops->launder_folio
Date: Thu, 20 Aug 2026 20:33:33 +0100
Message-ID: <20260820193343.3852967-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7EE43A0013
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: sffs638sdi3djrr7gkmuyfw4mzs9tno8
X-HE-Tag: 1787254445-89174
X-HE-Meta: U2FsdGVkX18jeA0NPKODpo+Z6SQU3Zl0uaAiFEtJzuU4CQxWI7LMM5KY0NFn0kFTe92AguVmLAGxPq4lFZOYXFmuF9yn0Ay2BRPtQKVBqkKJcoDJyZs5lUWC5w3LklRjh1SP7mQqxEyQTAC1LctBoHfvI1nlrVkQq2x5RyQsTwJIDSGprnwpANehdFRScjLAWjUa2CXtxn+dhOITtWU6e5zWiBOIRvrRp1xuPjpncI/Qmu/SeR062dM3xqhiABSmwZrlm7dLZZiUqbc+Q7et8rWmSC2YnAfB5Bqr+AvFcVCKgGEGhqhhZv4M3DI8TxmazcYCWuQvBO/LeHGJhAXCmu0gTQk8pozCgS8hs6IFFQ4ndW7UkjZ13bO09ENSLM2vR7RuiQ9L46Sn5ra41zoWr2wFw1mi0/FhNDuxf8A9OlJ9PiRgFt1HgGyChawGd9H9sAtwcyON/WKLaIjR8Em3tQ7WHYB1mKyDtIR/yszz9rrDRiAhNcYyzXq9jbCnlLV/lJNdB8t3NoG2+s6TxRiGfQ9IowbM7r2o8IlylIjc86TQu4Y3qFy8pXGHs/h+snIGb4uBXhcmHhRT2NGs16x4JUQz06dHhBpL1cVLzb8TogXn+AB8uwxjovMSdVTZ3YUnxFWFYls7ysTvJApJVeebEogcJCZCReSdrsSQ/I1e6pKg+exLtBbXELleT1ZUrzh3NDH/701itdKFi5zVP2OSTXPtvx9u/AekCmGLafE5vhVwE190P+4uy4xEwrbX5f8uVkaKgTWoSwniKglTGdIJbtvypUNziv/ua82X8no8p0GIPEsRUvFYgwA4Y3sERckgqPEl0ZlaVGk4FRYWS2Xjpej8iVm7OFbS3XlsSvLMK6SEfqluULzJb47nDy0+ROw7etoaUDUVVVTo+Pvr17rhnxp//plM6dZ2OMmljxYRadsfvSGWsP1uqbDn9eur98IuC82osfrl+wPT1PSfWsp
 d67Aj+PO
 GEd6C0A3tSHckheENRtJkL8IyfJgotgTuTewzvp50y50KThR64R8qYseoF9Cxq7UknlNqQefPMy7XqaV8PFHsl+gNNqsmq9GHB6adJm+g64hZNwURm20DkxJl8Ez4DvwGaGNw4OaySQbr9JreLZeML11xaz0GwtZskgOnerTPkVtsryVpbpUGr+UZXFTyfkZwx6WgHuapRCchkys5A230VtTg/rYlGOa857hE9C6xTiTpV0PJOs3SC2IX/84VKSxFsDb9t7GtK4kcQcNt43fPf/JufSQch7TSm/T2wdQVMq6CpBelMA8swwpZN0y//PR8thMDrC5+U3Ms0HvEVzf563wwzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's really no reason to implement ->launder_folio.  Most filesystems
don't.  The only problem is that some filesystems rely on dirty folios
being written back this way, so we need to make sure that folios are
written back before invalidating them.  filemap_invalidate_pages()
works well for that, once we remove the 'nowait' parameter.

Matthew Wilcox (Oracle) (7):
  filemap: Export filemap_invalidate_pages() to modules
  fuse: Use filemap_invalidate_pages()
  btrfs: Use filemap_invalidate_pages()
  nfs: Use filemap_invalidate_pages()
  orangefs: Use filemap_invalidate_pages()
  orangefs: Remove launder_folio implementation
  Remove folio_launder()

 Documentation/filesystems/locking.rst |  8 -----
 Documentation/filesystems/vfs.rst     |  6 ----
 block/ioctl.c                         | 14 +++++---
 fs/btrfs/direct-io.c                  |  2 +-
 fs/btrfs/disk-io.c                    | 11 ++++---
 fs/btrfs/free-space-cache.c           |  4 +--
 fs/btrfs/inode.c                      | 12 ++-----
 fs/btrfs/volumes.c                    |  4 +--
 fs/fuse/dax.c                         | 15 ++-------
 fs/fuse/dir.c                         | 12 ++++---
 fs/fuse/file.c                        | 46 ++++-----------------------
 fs/fuse/inode.c                       | 17 +++-------
 fs/nfs/dir.c                          |  7 ++--
 fs/nfs/direct.c                       |  5 ++-
 fs/nfs/file.c                         | 24 --------------
 fs/nfs/inode.c                        |  5 +--
 fs/nfs/nfs42proc.c                    |  3 +-
 fs/nfs/nfstrace.h                     |  1 -
 fs/orangefs/file.c                    |  4 +--
 fs/orangefs/inode.c                   |  1 -
 include/linux/fs.h                    |  1 -
 include/linux/pagemap.h               |  2 +-
 mm/filemap.c                          | 42 ++++++++++++++++--------
 mm/truncate.c                         | 15 ++-------
 24 files changed, 87 insertions(+), 174 deletions(-)

-- 
2.47.3


