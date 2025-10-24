Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A227CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE1E8E0053; Fri, 24 Oct 2025 04:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EADEC8E0042; Fri, 24 Oct 2025 04:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D468E0053; Fri, 24 Oct 2025 04:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C40D78E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:05:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84CF988F71
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:43 +0000 (UTC)
X-FDA: 84032273766.05.F9678B7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id DDF34180002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Js/UGbVF";
	spf=none (imf16.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dt5Y9yUiiRdlF2Ic+Ii5j4wLNf1I5IugK8AmLWSy1WY=;
	b=SHGlSIzeaemaS7thdKInbM2CiUxAusFE0KStgktTJecXvd096Y3iUncqj9sJw0Ld6mow67
	AdFEodxU/xDj4GhL+MSdspmIUalW1gK4jtwlX2QFqI6drZOp9daB4tKfrSyOAmCS2wBYqu
	6Fn5q8lunn9D/yZL5vQYIK3kqpUTplE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Js/UGbVF";
	spf=none (imf16.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293141; a=rsa-sha256;
	cv=none;
	b=t3eqSXy0Qb6eOWio/S+I+lFqDBlSO9W+1tEw5Y3lkuYRgeeghxfU2GW7YsXMi2yH+VSUOM
	9YYh/otka7LJVhpNfXgcf1nROwCc0xTSBUtZZZcDcdGG21IDyLuy4EL8tu2oCO6fDWmTTT
	iZTWAKIR1zzgd4//aq5nJMIbMJmQPMI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dt5Y9yUiiRdlF2Ic+Ii5j4wLNf1I5IugK8AmLWSy1WY=; b=Js/UGbVFZZ+OME4DUpP16a6gKq
	abrzc4WOMNevqV2nkdK0YUfY8pKvH4grE6fpxHacd2uTTimgcnn7O9U3ihpVcPb+2Ozjnnz4uiZ8q
	nnAnEXrVeNUOXgZ8E76x7T2/YyGmAlwEUcqfQQ6doNhxQ/ooD98B+lj/03Fdpv62sWQT1Y0zCVe58
	k/rPUZOiQUKnEHokwUOhgGsNqh6Z41ZKICvaKoxR5RjXBnfuk4nxxy3+JCartGOCv6OrYphXMbW7K
	I1q/uJTmTYOMiVXAbW3rg6juNoqiA85xiEuBN7VjsYGxv7Fi+UWb970IT9epMHNZAgfY2YhZty9xL
	75TfRhKw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCnp-00000008cEG-1P9g;
	Fri, 24 Oct 2025 08:05:37 +0000
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
	David Hildenbrand <david@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 06/10] mm,btrfs: add a filemap_flush_nr helper
Date: Fri, 24 Oct 2025 10:04:17 +0200
Message-ID: <20251024080431.324236-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: DDF34180002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1s1rp4fyqp6phf8nxqc38eonzcrur4re
X-HE-Tag: 1761293141-18781
X-HE-Meta: U2FsdGVkX1/AgeJQa4jDXph4vbuK5i7Yl37jM1XSdSAcRKvKDpF1SGGwrrqKv4y6LlYaATaRYgQold59xPsXPo8BienLHuXsN8Ma73P0aGyFvzZVvD9TV27ufEGWmFrG+SaLuQqgCpQAMffSF+uyU3v+St0HTnA7AGrKEYe65UV+1FN7mRtCYCfIEyL2d8beq7uuiv1IXV0lL8GTAzUWI0fMRzHL6vbXnj15PlCm9QFsiItaQ+OKJKCX7Mt6Pi1mA61RuSiKqO1Ojxffc26xtfAnePwzCcD9+cQtIylrLF3GDb6+sWENTS9Hinenzu1GvPD4XZGU6aoySFLOpg8LTTm6eDcxFFnbSZsh3iCscUX+vO/9E8IgdgosbVi8VwYCAvRcihEgqHXjATYjqynYktBhmldxECG6Dn8L3ryxK2m853cFZhKAdlTavp1Di9ALzT+92LrNeeAKhKDV5iqc27zgWis060t9azSPaXlMURSpzY9jycN5H1yYpOAAGDvan9yWKlHw+w+p1UWjcQIfP6zZwBwfOa1JJ97LJlb3lal+cXf6959ISPdIv7PcKcNA+8zFVRJW1sNMXuYWVOHVssBbRFRu8NG+TD3y8rODF/zquOyEKYZkrWxiqLBF+kUEatYKx+3yjHf1+2lBt8HBNolrNiO4kS5fsrt48EzEj/FW1JFKtHi4QRmkXvQccoT05et6H0Pz3z0SV8eKWpq/BsPezbG4TJmtABYIEWKZEYuHO+HlRcUKknqhr9TZwyvOh/IJHqP5Oe6qCt+MHj6p7YJr7qQXIisWBpXwMKlFwye9xmtGgZhbNh3RPheg3efCY4w1qVJTlrsrqoBB7z+zZA0O41kCwunqnqaoAmmyyo7Pj0AhgvITS3r92qLxdbi3An/Kcrf5WI/ZGgrX/XD8pfIoJ7RbAZSmI/s/ddiH2wCX0C3jvb6V5JUNjRMIFOuBVVjS/VioLf+vZt4GTEv
 vnvxu9pq
 J+GiJUDjUe2AgBNkMDyyFLuDl020iazCetKzp8FeMFJnlmwPtBMCdEQTeLTh83IUYmhNFAevvNBVmMe9CjXU7fBVPO4wQTXqr19qQh1hnWjkQV7PPXhbwN8mNagV6XseYPHwNoLCHUSYhvZ2/X//LjkLnsu2AzwF9K2dYJOw21auTXB28GdFVf9cDAxtxsWGIEZh9KtqojMwpXf3UFqW9CwNCLHfVckjWjBe7xdoAYpX65vgy5SawuuE/ji74E/pESzwj+aCbsxXOpblHzOdVgooWGyjQNJqZ6SeDM9FtyvARDOCpCafHpPaGX29M6rr7sf/i9+t2/zyH5wf1XDGM8lDBLEVBjuj+pvebk2ABLDkrgDF7JHqFHFFJeQ9T8tcIYCDn/oXTtTc/vY6UszDNi1o6LEn9aLOvdRZPJG0yN/5i1Z5MbtC3aKRxzAXQtWdNX8WcekuCXm67OiZlTJ7x+vHrZNH7qvASM08b23cDFtwvl7tY4bClqsg3rLfyRpVi+S8Q/pi4fHIVBuaXx2aD5659CKHIzi9tNrP2iYkjdxpnAj8cgPa+cFZ0JN13m4WgO35F2KDInThLFD3QjONjs6FnbsOQ5bgzwnYXbfpCxpZimnnw81mWnnwrxlfATu323cxvwmglm91YNu5RUrauvh0p/Hm+jJ96Ilk5Xlm+93rgEz89dEk3oN+ul+169e9gN5kIUtJp16pdqczrZGpB9gO0bZ9/Jf2gtKhWaPN6Z30dJ7COlgLcQW626Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Abstract out the btrfs-specific behavior of kicking off I/O on a number
of pages on an address_space into a well-defined helper.

Note: there is no kerneldoc comment for the new function because it is
not part of the public API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/inode.c        | 13 ++-----------
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b97d6c1f7772..d12b8116adde 100644
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
+			ret = filemap_flush_nr(tmp_inode->i_mapping,
+					nr_to_write);
 			btrfs_add_delayed_iput(inode);
 
-			if (*nr_to_write != LONG_MAX)
-				*nr_to_write = wbc.nr_to_write;
 			if (ret || *nr_to_write <= 0)
 				goto out;
 		}
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878..cebdf160d3dd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -38,6 +38,7 @@ int filemap_invalidate_pages(struct address_space *mapping,
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
+int filemap_flush_nr(struct address_space *mapping, long *nr_to_write);
 int filemap_fdatawait_keep_errors(struct address_space *mapping);
 int filemap_fdatawait_range(struct address_space *, loff_t lstart, loff_t lend);
 int filemap_fdatawait_range_keep_errors(struct address_space *mapping,
diff --git a/mm/filemap.c b/mm/filemap.c
index 99d6919af60d..e344b79a012d 100644
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
+int filemap_flush_nr(struct address_space *mapping, long *nr_to_write)
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
+EXPORT_SYMBOL_FOR_MODULES(filemap_flush_nr, "btrfs");
+
 /**
  * filemap_range_has_page - check if a page exists in range.
  * @mapping:           address space within which to check
-- 
2.47.3


