Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F85BCCD184
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92958E000B; Sun, 12 Oct 2025 22:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A4C8E0002; Sun, 12 Oct 2025 22:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A77A8E000B; Sun, 12 Oct 2025 22:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89C6A8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:59:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45F291DE24D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:59:08 +0000 (UTC)
X-FDA: 83991584376.20.3E36F1D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id CFD7A40003
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:59:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hooMK41t;
	spf=none (imf04.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqMpmzvrENBMy7NbX0f6Mno/+2fYxO4ON6rsl2w4mjo=;
	b=SIFXJgmfbb5gh6WFArbITtgmKPKTZW3UhyGoDCsGWNR0s+JGgKIuQEvMHXpKhu4tvqc7MS
	VzkmTErsIiCgyaVuoApPwL03uWZsm6wISVbkdZZkKiEWFdUrDsDjoj4iIB2DzCwJ6VeCJZ
	X0E1ZtwqPNrpaOtpRMvGuUe7sxkxj/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324346; a=rsa-sha256;
	cv=none;
	b=zAA0irnN6JxShwYIyq6pZynIi38+Zj88OkI2IGFeox9fll9VdstnlJVZO7DgINK7gJTECw
	IVAcPe7uY8IjJe5In1GlDfbs4Tuagj0Cd+R78j3+ziYlNnvRLf6+re0tTW3TxUaScquTFj
	FNYDmR0DJ6p7B46tMcF652RWz2N4mR4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hooMK41t;
	spf=none (imf04.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SqMpmzvrENBMy7NbX0f6Mno/+2fYxO4ON6rsl2w4mjo=; b=hooMK41t3bXxsCf99o1BpcDMw8
	WfYDeaQyBA0b0R6oodz4lKBED6pp9FlG3MiZSTYa+z0CdX7OkY+HZZ/pe8KOk106r/wlutvwCn8Ly
	URKBG6Qg9Ui5oQpLFtlBPg3HuBA7VPcq7mrsOtzLnNA6NgUWDdtQKu/7AKjr3nd6i0BV13Lo2KZjQ
	d+xP5WEGIELFmYh2np8a7/2+MNlFBznDsCmUWTM8lTZfSreMH/H18WswhTq60KHxmmVDT1FqHq9NE
	E27U6Xbzo6nFVZiDXhXg+3JZOvtwxI/53zBY2ebKt6AqBOcNy6SkoCalxEkX3S93a9j7EjtpjAwUX
	4stfUbRQ==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88m2-0000000C8GM-43XE;
	Mon, 13 Oct 2025 02:58:59 +0000
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
Subject: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
Date: Mon, 13 Oct 2025 11:58:01 +0900
Message-ID: <20251013025808.4111128-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Stat-Signature: dwbampz11mj355n35yuw19khg4c9gdwm
X-Rspam-User: 
X-Rspamd-Queue-Id: CFD7A40003
X-HE-Tag: 1760324346-515501
X-HE-Meta: U2FsdGVkX18cBfqPApCzIBDHQKYkUV63ULnGZVLfOZekCvr3MA2nK1jwfsHwfzghmDNex6PvAPAAeW+6YidMe3wCudFo6LCGHgiOtEBV8FhrIcmf61lguLwLi4sO52bZjlmIKmWqXr10GQynXaoPvmvyZKiG0a8C1kbCQFtSCub2Tt99xjcXfOwfkNXaJH1Vxo3D+zqFZJrxWIix2ZPr5XwJmljhrTyAWa7IrWnDVAQMq5kDudA9Aa80YUV2kHN9OTRsNT5rwBhCZCDY019ioZPwbKzufGqwOGgVnQ1lAVphQTHykrLhqBUZF+4dIcGjgcTP3BVwVnq/4+g4mjElAQ9avCQN+NJWzAa+SlaX1Z7XPxWRfCLRG4QqC8rNcsGgZV/vHN4c0v4aQHfDKOd9iLEhYdflD5cnWaDmddTnObKHP2iVBWhFXXGJmLNIBpnbIf0wBgVoTYLk+xM/HV7zTJJkZN5u+OeSoZO1FOK4MMN7rTNaQvqKFesuLwEVugFrc86BLeFidxgAyjRBZ4vvmXTFkxFMICZlh+BU15UECalC8V+2csyxL2gZ4OkUsrBJ9zrwbUx+CUmyoRBt2VUJvI1ybqjcJr8DNPZ/HNk7w7fsuknZbMWzmyORyrzogq92WvMDblKIaP/J/QtWnbdgKapWo0mFhW+mY1HLwL66jrdB9T/jkZRtv2om7UqE/kH4VIvQcP8Vwn3D4kIoN9xY2pkHP12iRELhDIeZOJT9zolO9g51/WKbtGsuGbV79jyfCkP5xbqbyEJwxC8U+UkSDyCUOdWsM9uVQKIS7ENYjxpqRH6OedBN1IhCyhPEgUH38wP7s45jiFlWxsOkNR1/sNqjnV7QD9dYr7ZvcoL63xIFdvoHOGgJc0bcIB9gJfz062kyy5cOEDC34NhCO80Q3r4HE8EC0gbNDMYYhLaGvM1jISZf47PTsZfTxKYFJvIRjS4gtFlsnvnuGoc20QI
 LJJek4ty
 nXTf6OfsjpTiP8WMTZue8/9YQUSVKYd92QKCc8v0/BGcpXCxc1YnRODgZgjriXz0tnl/QdlITuRR8QPqMjD55ohghE2xc0OYvkBG7UfKQ4M2iOeyYbtzmtuSGdvuHlvhNCDk4rwfC3kyexSXyFu1OtyCzI83FUVVu7SKos/kgn/TPO8qFpTNiA4hZHKVfLWkqq0dHeJgp9XpPidCmMIDP/SOTDZMyGJ/y1NvrzcHqXheW1VTOPNbumpLF3qiin60qxxnkeU2YTof7zp41JSaKOZF3l0jdtVwP+8Mpsh11AhZK6R1diN/zPWyNmWnJhd2RdCScy8Fs3JNBGBPPXt7ohMy0pl5QphBfN5Y82QiprcYbY67TuZmk0XJXPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Abstract out the btrfs-specific behavior of kicking off I/O on a number
of pages on an address_space into a well-defined helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c        | 13 ++-----------
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 22 ++++++++++++++++++++++
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b97d6c1f7772..b63d77154c45 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8752,19 +8752,10 @@ static int start_delalloc_inodes(struct btrfs_root *root, long *nr_to_write,
 			btrfs_queue_work(root->fs_info->flush_workers,
 					 &work->work);
 		} else {
-			struct writeback_control wbc = {
-				.nr_to_write = *nr_to_write,
-				.sync_mode = WB_SYNC_NONE,
-				.range_start = 0,
-				.range_end = LLONG_MAX,
-			};
-
-			ret = filemap_fdatawrite_wbc(tmp_inode->i_mapping,
-					&wbc);
+			ret = filemap_fdatawrite_kick_nr(tmp_inode->i_mapping,
+					nr_to_write);
 			btrfs_add_delayed_iput(inode);
 
-			if (*nr_to_write != LONG_MAX)
-				*nr_to_write = wbc.nr_to_write;
 			if (ret || *nr_to_write <= 0)
 				goto out;
 		}
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878..fc060ce2d31d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -38,6 +38,8 @@ int filemap_invalidate_pages(struct address_space *mapping,
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
+int filemap_fdatawrite_kick_nr(struct address_space *mapping,
+		long *nr_to_write);
 int filemap_fdatawait_keep_errors(struct address_space *mapping);
 int filemap_fdatawait_range(struct address_space *, loff_t lstart, loff_t lend);
 int filemap_fdatawait_range_keep_errors(struct address_space *mapping,
diff --git a/mm/filemap.c b/mm/filemap.c
index 99d6919af60d..b95e71774131 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -474,6 +474,28 @@ int filemap_flush(struct address_space *mapping)
 }
 EXPORT_SYMBOL(filemap_flush);
 
+/*
+ * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
+ * btrfs caller should be using this.  Talk to linux-mm if you think adding a
+ * new caller is a good idea.
+ */
+int filemap_fdatawrite_kick_nr(struct address_space *mapping, long *nr_to_write)
+{
+	struct writeback_control wbc = {
+		.nr_to_write = *nr_to_write,
+		.sync_mode = WB_SYNC_NONE,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+	};
+	int ret;
+
+	ret = filemap_fdatawrite_wbc(mapping, &wbc);
+	if (!ret)
+		*nr_to_write = wbc.nr_to_write;
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(filemap_fdatawrite_kick_nr, "btrfs");
+
 /**
  * filemap_range_has_page - check if a page exists in range.
  * @mapping:           address space within which to check
-- 
2.47.3


