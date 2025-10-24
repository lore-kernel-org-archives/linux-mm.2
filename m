Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EE2CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53CD8E0051; Fri, 24 Oct 2025 04:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C4F8E0042; Fri, 24 Oct 2025 04:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67E28E0051; Fri, 24 Oct 2025 04:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94C7B8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:05:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4809FBE3FB
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:27 +0000 (UTC)
X-FDA: 84032273094.24.E858DCE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C95C40008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=e5QxhOIc;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf07.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293125; a=rsa-sha256;
	cv=none;
	b=AfK0nBmb22gX6aI6nJVLQ24+E3ItssDEXzxo9rQfSZtJbxr8LKwaE2SEIGT+TrxWz1ZiRv
	rnqdHaPlHhpwvRLNwBKMGdr7dqNtdGLm+9BHDFz6S5g6VZPCXnwNTyP0YLYBmvKKY/adGG
	zoyoo1m5dwncxrFduF6KaAl1xcsmukE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=e5QxhOIc;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf07.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blGde8W3zS/zXI9AbS8g1T7M/TUy61wo/WYiRf9KRNo=;
	b=8AVG3tr2VDtS6yIXBnP+5XX5FhmOY3102aAHhzLwy0NN3XP3SNPXbpMiM2RgcX/FZeq7AF
	h7Iyl9/D99/5vLR7HaF581f5d/sEXZm1tRDODBeFzZ1yG9zQ8QDF2tVkiYb5BXGTQ0y+XY
	5lShxyroo4SedMFozdYbK1zAHjtmwnI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=blGde8W3zS/zXI9AbS8g1T7M/TUy61wo/WYiRf9KRNo=; b=e5QxhOIcxdiOltjAMQ/VttSoGx
	+haNlzPyaaJcJ4UUgsn3P+iWfvmyt7FRpi44/AMJTitmkY/9QmEnTO+hQO1d5W86NYd6TfQEWsuwA
	v791Kg1M4AnDF6JlNDShxoY+/19WaMjZk/UFkeOTcqrBSnbuKpSplIGIxRhvvmDWH4vg05AafnCLP
	SJIn6wwOAwK/9bKAXyVNlxw5DT8/LtOtjbrT3pbhB95rFCrr5yksba0ukCKf3JaudZHe/Kgyf8GFd
	DZfTXTdTUL22/54QcU9eIQiOQYYH7h5eScyFg7m83Lk4V2wb0T07jJTtuPQnSexE29mFYKWMYVyQC
	CefsepVQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCnZ-00000008cAP-0etU;
	Fri, 24 Oct 2025 08:05:21 +0000
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
	linux-mm@kvack.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 04/10] btrfs: use the local tmp_inode variable in start_delalloc_inodes
Date: Fri, 24 Oct 2025 10:04:15 +0200
Message-ID: <20251024080431.324236-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 4i688qjxzfafwx11pig6f5nubd4qowe7
X-Rspamd-Queue-Id: 9C95C40008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761293125-3014
X-HE-Meta: U2FsdGVkX191APzXzxwlxaZlX+uHQKtfWaPvfVE3BQ5Ljtq877XhpJYHay5f8uDnCvdDPLNWtB6P+0lyoAEfLf+VV1vXU6ZsIKlX//ft8qbvqWbyH4wgqrsnmV2sv7f39ikN4Ll9ue0OkGksNe6nVeNsGf+UBQLkQrRNCZe+L1u2+UfMfPnyEis3qJ4+r3wRVc7gFcP9meCnLwF5Ih+dwz3gmIMXH26jmT3Io7dg9YvSd/Ppz5rC8A2CfjjZA+8W0VEDA0tmaVZQHlj8HblpCDqNiT4VBAWvD/x+Jr2Hqui6G6JVmu8JA5XwVI5LVOd6l9rcpyxkOLCcerzFRwCqGqkyyMunEAtMyTI+P6D9KHVreOkxeYaEixozTgAoZioPyjzof7MjjAnVR3y383NcWjpPgke4FPZAeVPLwA1TNdHTPzoClW29eqczyrJXpu5jQztNfq6W5ZfExuFju2Im2Dw/0RNvgM1WEQfOYCFntEQZJR4LFCK/FzHD9wpxXeZ+7CBAu/ko27WWul0bC/yapdGokCL6Dw33ZEt8Xxk47LqAyMRbhL5OvYAq8v6EhZJPzJS5ymce4uUoxj1/QaPoQVxE8bpx1Pc2AUdvcId2AbDYZgEvdiG1Lqq6EAhXuUXKP3imVijZjF1ywElcDy1v92NFMiIN2HWTZKq0ZLDMsxFsKcY4vEqM3KRDy9imjvX9tjKza16yJS8uZ6C2+k+Ko7nEVi6BmOQxBWDxoS4KXmTMUsqr9w8JibD3IMr1lZSb5cmaLV45Otd4zS9pF9Fsys/xR7HipCE42rEh47P76ZdPoJ46wirb6ffu8O976Z7HKFQCh3OIdnDWbAa/idYxBKzQIW3jvVrOiWpoOPmChXUgDESDiNv3BzkBWBrKQ1M+DB+THw4MYOjo8rbvnhf+cg0t/2ZmzG51KelJFulMpa53g14WCxwUsKvcUdUNw7X4roQb+97C949s4OszpGy
 vFE8vwJj
 xL+A8sTxvK7gx7p1X+OtuvFUb8VG8Ma2iJKr0W3FSfJupT1HH9psZXwaeoUzQpFMd/0raEsY7emTmGGUotBW2+vewpqf9c70a/JsPGanJjac0wAvF/ogbqbGZlEZ/Rl3L22ovwPL/nBc6A8N8LhvipPM88iisK1oWF3HR2WDHx9xuo+kNreuhWZXbkmO2GGsgrD7Pyy5Lwy7qUrHN/XBoxU+HU+OsOS+wNvVYgQhlkiScjyaOALnF1WT8j7Vvo5blgPPRoRjfWCVf9HG4Q/STHp4btHg+pt+kolOsIiw4bijHPUL8aYRbdx9JM/Her9qFjxtSLkQ009vVOu1rIJgF8M/QU9LueFPyUevwf6IuGncwGIYPwalRLxYbbUuoVFDB6ilrIOmzdVNlQvqrCobfeLw8zHV7V1hD9IR2VU6WXabBUV7FWuSXPwuU07Y6oweXlfbH4HjWTFB5jp5wKS4mLdjrxdDJjQMFb062OVx6vAIIAUH+h8PSEub/5uwWAcaydUGqX7C8adC8nJDXc2kFmkTnjRyFqmhu93YvOouXEH11DGaDMN2UuJzGx5BzH+rYia59Ee6ETk/aGKxHtifxSolj90vRdi8/AnuRLMFbxCnGDBZNuvmEd4Nro3Vhc1OhiVhWTh8GVBJ+wlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

start_delalloc_inodes has a struct inode * pointer available in the
main loop, use it instead of re-calculating it from the btrfs inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3b1b3a0553ee..9edb78fc57fc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8744,9 +8744,9 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 		if (snapshot)
 			set_bit(BTRFS_INODE_SNAPSHOT_FLUSH, &inode->runtime_flags);
 		if (full_flush) {
-			work = btrfs_alloc_delalloc_work(&inode->vfs_inode);
+			work = btrfs_alloc_delalloc_work(tmp_inode);
 			if (!work) {
-				iput(&inode->vfs_inode);
+				iput(tmp_inode);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -8754,7 +8754,7 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 			btrfs_queue_work(root->fs_info->flush_workers,
 					 &work->work);
 		} else {
-			ret = filemap_fdatawrite_wbc(inode->vfs_inode.i_mapping, wbc);
+			ret = filemap_fdatawrite_wbc(tmp_inode->i_mapping, wbc);
 			btrfs_add_delayed_iput(inode);
 			if (ret || wbc->nr_to_write <= 0)
 				goto out;
-- 
2.47.3


