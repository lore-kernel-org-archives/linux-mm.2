Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F954FC5910
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC336B0088; Thu, 26 Feb 2026 03:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699E96B0089; Thu, 26 Feb 2026 03:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B9F6B008A; Thu, 26 Feb 2026 03:40:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4548E6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:40:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 901D613BF60
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:40:52 +0000 (UTC)
X-FDA: 84485962344.02.53F9658
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 98FD5180008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:40:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T5K+2bTN;
	spf=pass (imf16.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772095251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r6ok+REfdEcAEOyYdN8mpwOjfAi6PmuRiNBeuWg5TUU=;
	b=xKhjJLCoDO9zCinhRDCIC4TxkjL0AoyvR4IqQv70qZAxJoADJoVQlTmIPdjoi3TfFEIrxv
	6qRWuSRijUV99FQVjZSHvQD3lVRacbinwkcwmg8xcAcx8lUbAUDOvN85qMQxXTEnBk3f8s
	TvQtLbXaBM+MW31Kui8IFBFgjIOPN/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772095251; a=rsa-sha256;
	cv=none;
	b=BBhQlrhnI8v24OQGWbmWrGyf/xYygPV7dXRL3KLCZIA+ub1buLXIgZOF+91a+3xugXCrH4
	zdqSckDLJm6cAyGVuWpfI8GQyVMiqU+3P5gZ7vRY6udWgXfTEfqKwRxTeA7SbxKLVJlLkY
	ps7ZFpVp81ADhzxu6U1vlfisv4odG6c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T5K+2bTN;
	spf=pass (imf16.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772095248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r6ok+REfdEcAEOyYdN8mpwOjfAi6PmuRiNBeuWg5TUU=;
	b=T5K+2bTNXbyiZNubyfIgKzDWc7n++7B7nePN71sU4f09J1Z1zIXlbtNc+/wUPPFZr90CyP
	WGRtf1eL2ccboUEI1sH532tb4YN/k/NZBD/VWOkRmOeKLQR6AWkjAVuuyOzUIdv48y05/E
	r/+dWZ9KNUA0tglW3MTUw+5KWgo1dkU=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+6880f676b265dbd42d63@syzkaller.appspotmail.com,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ntfs3@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1] mm: annotate data race of f_ra.prev_pos
Date: Thu, 26 Feb 2026 16:40:07 +0800
Message-ID: <20260226084020.163720-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 98FD5180008
X-Stat-Signature: psbqhshf9fx7ag4ucbypri87mier9jti
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772095250-775351
X-HE-Meta: U2FsdGVkX19LKfBTMCTulmZmxBKp5n7Zv5ZaSiT4AueXq1gGDWYzwwpVPEq4GGHOhxjYaP0gqO0AQEHdDytXYXLYnHyxy9QBn+giFgmqkxYEBmZIxVN37GLA4zFijMFGRlQ0svMcTX8Kg6Zq9009Zn98cqUicdU1yFaU/pVonaQAUGjzjKDaQ7TVf9BqOmrdmweu4hdSw3GWZIgxmiHU91lCHJSOd1dJy7/RO57b9EzuH9ucJ5BF8A2DGb1x9d/P6W1bocz1lHdKyV7oMOOD6F/aqVz61qP+sbf/zPj2pGCFk0AcJ7nzgz70GxtrczYH0XnT+YiVEaizFaaeKQoLYBT8bHMClMkJ7D6nPV5t6PBwX1T7t7Vmi48TbH3kv4aMKAfQ40gcNVQplDlRcRxh3AJiLggwcvc0Wkkxlr8oWZTL6WdJBM4nLtDXJNzbSP3r+fKk2oAQpWFa6qpsHz5WnDMGy5RP7ktLBcJX2nmoLu69Qkn0J2Wqkg6RTGgjX5NEMlYEfQ4UtljOqd1dQqQeNAQXnqm213HIXqTLuWr/jmd3wqtGPnCU+azcodocTWx03drjIQgXu0FjnytmqrUD5PaLyHaUpFNSWgGjObpMuG3aDkeHKbgF5sZRMTUkFwPrjtDpo0yy8Fi8y0aJw/bKF0U8Y/yQNhqWUg55Ky5uOyDC7WBoZVTIGbkjptBORRuzGsAYdIiqR60oRvZhRkTK7xVcrDIx8e+2ZijFsij0yJO4ejrM0L9UY7WV6iIh2zRlu9nM+zFlFAlF5S2/J5JNVblZRHTuxV2dU5K5oMdUcngfwLSpTNVOCFwZo4U0aLiAjf+6I2ouPEmmItCvKgRYttiH7gw1WGr+OsTqqRAitj0GddNQZZNXfK0gQaxHY17j096ztdsqEejl+kwW0Q8eT6gCm5VRp3szANMJLKMvnr/5hwK1duYEm0embkPfasncjo+WkDVrapzyQaL8NAW
 JQDy5Bv8
 5n4/mewwagcp9mgIGpiQM8GvIiSdiXcppAEhLNIi4UgcOq0Zl5pFKKrEC0CS55b9OdSeLHPT8+iiOtkLeLLz+d2lL/5XW478X4fUZUIAe0HOFCpcsBpaaXM071T2mihdARVfak56lRUM5lpvwzZCxvNSFqePPoKZ76QqHUhQJGO9TwL9U6A7eDvRD2WjIJDilJkT6qkSo2RH1M5PCsSMMDgj7RUbvV1Jf+M18hTKzD+X2SIt7PFmz3y3DJqvIf/XlYtyYp/4405GoNRravqBh2+O+VgGjLA03UVo3HI/Kc/oxFuXpmpH40aGSU3kqVOar7582/AN7HMI9MhdE9S7N2pH7LDbZr5znHeco/pgNYgDSzMJ0G4Jrty5OliELOzxFrpxLRhnxX6aqYnHenpl+GsrQAhSmijhUKxvi5iBDu36CxR/NFwm/+j5FiFsSD8Ue9bNsHGuDyDSTnC+x0/7Z/U3/AZ1vp4riW1OtXxn5Jnupox0l+6RPoHgoSw1fZ8ZosspQ/zLpW2QFEG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

KCSAN reports a data race when concurrent readers access the same
struct file:

  BUG: KCSAN: data-race in filemap_read / filemap_splice_read

  write to 0xffff88811a6f8228 of 8 bytes by task 10061 on cpu 0:
   filemap_splice_read+0x523/0x780 mm/filemap.c:3125
   ...

  write to 0xffff88811a6f8228 of 8 bytes by task 10066 on cpu 1:
   filemap_read+0x98d/0xa10 mm/filemap.c:2873
   ...

Both filemap_read() and filemap_splice_read() update f_ra.prev_pos
without synchronization. This is a benign race since prev_pos is only
used as a hint for readahead heuristics in page_cache_sync_ra(), and a
stale or torn value merely results in a suboptimal readahead decision,
not a correctness issue.

Use WRITE_ONCE/READ_ONCE to annotate all accesses to prev_pos across
the tree for consistency and silence KCSAN.

Reported-by: syzbot+6880f676b265dbd42d63@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=6880f676b265dbd42d63
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 fs/ext4/dir.c                    | 2 +-
 fs/ntfs3/fsntfs.c                | 2 +-
 include/trace/events/readahead.h | 2 +-
 mm/filemap.c                     | 6 +++---
 mm/readahead.c                   | 4 ++--
 mm/shmem.c                       | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 28b2a3deb954..1ddf7acce5ca 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -200,7 +200,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 					sb->s_bdev->bd_mapping,
 					&file->f_ra, file, index,
 					1 << EXT4_SB(sb)->s_min_folio_order);
-			file->f_ra.prev_pos = (loff_t)index << PAGE_SHIFT;
+			WRITE_ONCE(file->f_ra.prev_pos, (loff_t)index << PAGE_SHIFT);
 			bh = ext4_bread(NULL, inode, map.m_lblk, 0);
 			if (IS_ERR(bh)) {
 				err = PTR_ERR(bh);
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 0df2aa81d884..d1232fc03c08 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1239,7 +1239,7 @@ int ntfs_read_run_nb_ra(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 			if (!ra_has_index(ra, index)) {
 				page_cache_sync_readahead(mapping, ra, NULL,
 							  index, 1);
-				ra->prev_pos = (loff_t)index << PAGE_SHIFT;
+				WRITE_ONCE(ra->prev_pos, (loff_t)index << PAGE_SHIFT);
 			}
 		}
 
diff --git a/include/trace/events/readahead.h b/include/trace/events/readahead.h
index 0997ac5eceab..63d8df6c2983 100644
--- a/include/trace/events/readahead.h
+++ b/include/trace/events/readahead.h
@@ -101,7 +101,7 @@ DECLARE_EVENT_CLASS(page_cache_ra_op,
 		__entry->async_size = ra->async_size;
 		__entry->ra_pages = ra->ra_pages;
 		__entry->mmap_miss = ra->mmap_miss;
-		__entry->prev_pos = ra->prev_pos;
+		__entry->prev_pos = READ_ONCE(ra->prev_pos);
 		__entry->req_count = req_count;
 	),
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 63f256307fdd..d3e2d4b826b9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2771,7 +2771,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	int i, error = 0;
 	bool writably_mapped;
 	loff_t isize, end_offset;
-	loff_t last_pos = ra->prev_pos;
+	loff_t last_pos = READ_ONCE(ra->prev_pos);
 
 	if (unlikely(iocb->ki_pos < 0))
 		return -EINVAL;
@@ -2870,7 +2870,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
-	ra->prev_pos = last_pos;
+	WRITE_ONCE(ra->prev_pos, last_pos);
 	return already_read ? already_read : error;
 }
 EXPORT_SYMBOL_GPL(filemap_read);
@@ -3122,7 +3122,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 			len -= n;
 			total_spliced += n;
 			*ppos += n;
-			in->f_ra.prev_pos = *ppos;
+			WRITE_ONCE(in->f_ra.prev_pos, *ppos);
 			if (pipe_is_full(pipe))
 				goto out;
 		}
diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c89ea..de49b35b0329 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -142,7 +142,7 @@ void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
 	ra->ra_pages = inode_to_bdi(mapping->host)->ra_pages;
-	ra->prev_pos = -1;
+	WRITE_ONCE(ra->prev_pos, -1);
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
@@ -584,7 +584,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	}
 
 	max_pages = ractl_max_pages(ractl, req_count);
-	prev_index = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
+	prev_index = (unsigned long long)READ_ONCE(ra->prev_pos) >> PAGE_SHIFT;
 	/*
 	 * A start of file, oversized read, or sequential cache miss:
 	 * trivial case: (index - prev_index) == 1
diff --git a/mm/shmem.c b/mm/shmem.c
index 5e7dcf5bc5d3..03569199baf4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3642,7 +3642,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 		len -= n;
 		total_spliced += n;
 		*ppos += n;
-		in->f_ra.prev_pos = *ppos;
+		WRITE_ONCE(in->f_ra.prev_pos, *ppos);
 		if (pipe_is_full(pipe))
 			break;
 
-- 
2.43.0


