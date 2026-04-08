Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A491D10F9940
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E4C6B0089; Wed,  8 Apr 2026 10:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017DA6B008A; Wed,  8 Apr 2026 10:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB236B008C; Wed,  8 Apr 2026 10:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0DD66B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:25:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8980287BF1
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:25:42 +0000 (UTC)
X-FDA: 84635612124.24.F1B1B37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9C131120012
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:25:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8w13Z7t;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8w13Z7t;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775658340; a=rsa-sha256;
	cv=none;
	b=ZdYJDvQV257qhMa+e/5e75hl6q8wXmm8NNv4KBJCTaJj0QMEzWn/N1koZ41LqxcwPPD2K+
	x9c/0E2k+rI/9zIA2gGQiVg7p80T5SX7uHh37ooLMKnSE1F8rTLpbs9kCPsVV5+ZDh/cnU
	0ZbkIa5IcfKC4C1TH94rEKu7/06Ptlk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775658340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CglPymk5CLDwQkWKYUiM7+kWc5/aC8Lx2SgVlKu5QAg=;
	b=FexRejMgEEL7hH1H2hM/ptRfA8v0tliXglqjR/zfKOXBkKULjsx2pKocpBUq70D9Smtjwf
	xrzwGYaBTX2AOrVDIaKXrnNY9zNYlLaEmkAX6z+xnnEixZNwhk5W4eHQ7zlNkb9ZLS6HBt
	ilG71dcErJ2lDdzrfCQisUQQZ7OuJOo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B87BA4063F;
	Wed,  8 Apr 2026 14:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ED3C2BC87;
	Wed,  8 Apr 2026 14:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775658339;
	bh=qp5bMkCPIicW0vAK3EBrW1A8yDhhLZgvKi1mDE1KQ+Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=E8w13Z7tZwKG3xeGLv3x0jmBMpYPL3PfUJqgccOnYQntg7oRsXpq3Q1t78OijpZ8b
	 Ca8VucyWJXLtN7bk4oIHrtfk1nRiMy98z76ztseABwbrI7VWqgx63gVuvok3Fq6UAS
	 DpizIlGIwsbCGhgG9ocHvr1kt1MH8Nf/byIxoAqN0Ee1H8bAIPjZQxuDBEPb0haUJl
	 3dsxEMFie5LIacV5bRYEGGQIkNQ1FiFaNqnPvEcDQz2X4ZaTtAHxJQKRRHDYXQhe6G
	 2RDmzAlJGv1Pe0gZrA0kz9Q7mO/7LI87CS6hFgOnvH623sNqHPMw7nzjYqCOHM7pHJ
	 mUpzFxnthSzbA==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 08 Apr 2026 10:25:21 -0400
Subject: [PATCH v2 1/3] mm: kick writeback flusher instead of inline flush
 for IOCB_DONTCACHE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
In-Reply-To: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3840; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=qp5bMkCPIicW0vAK3EBrW1A8yDhhLZgvKi1mDE1KQ+Q=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp1mVfpEPxZ1DKFWwnUBWNtGPYod8zrgho1SpyC
 EpBrB6x/oSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCadZlXwAKCRAADmhBGVaC
 FSd8D/97DxdSGpMqJRUTtYA7ZwjJxYqUSrSZuP3a8ITeFMIlQhUU4vnFN5vV4/z0DgAtoFwkzfk
 l4wCk29KBgfa+nrGhWlO0ndZakYnqFP61L30vVSn0QAJm95TsuAUmkRFup1B9Vbstw1QCKcOzez
 XeD9UU8gs1Ft0afeuZz05T/U5ymF24ZwN3oWIYcbPYsTLDzUnrCE7ahsvfdmJKH4Tt+G+kBr2EO
 4YYYx02yAdnDP3z/65GpIdtVZVBxqcDWeXI6sn23BmopzDhHUCokatLqoM5GIVBC1oV3iQMQ2zE
 hmXMKtyjMzb1nJsWhfIXTs0yrUUdAn5EfNv0WJqTM9ZWor42LccpyfZHRhC0k02VAGMJAvTqhVl
 4enQn4c2S9N6AwN3T8NFUAfIM9qViPK7Q+0dT5/0ar89P8Gzy42+znK8sJNrJPCbPKG9C0KUtPa
 eFFZmxvf6wf3iwF4UjdDRUh146QSctEy/n2/XFgQiZNfljJY1XW4/W5A8oblTi+kabmotpvFq2n
 qEoa/KM/JEouKtbdVk4MVpGZUWcgcpXS4mj35GjFdVgXiI+bFHZIEl7S+myQl92xTltbvuIAail
 26L0w0byo+141FgqyUgqvaKDfd7JFVOq6HQEECkzU1lKZ4zj57E/tEUFd9iDLbF0QcBHCKiLQvN
 0EIWx1aXzxLNVOg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C131120012
X-Stat-Signature: w5h6i8uabjjhab61cmzsjxt8ftom17bo
X-Rspam-User: 
X-HE-Tag: 1775658340-939609
X-HE-Meta: U2FsdGVkX1/Ee0ZKtEV6O8dG+ZiFeQtsLG150Goq/ra7I4338PRNvmMihKhodNV13r/QS5yfNcIMBT05Za/BWSiL5/QvkomnjQ/fxzVmvbwdesJvo/twDxSVa+QVxVUC3DmDu9td+6I/Ss+Iac5O9q8Mr/NHVi7d8og6m7Yj6sB7IIFfBFwg1mb4nXP3xG7wfRCGvX0D7HOAZy+64CJN1CS+zfwxitVnHAWr4OsYHGCpIhNKRPyb62iDZ3tjW/ZR+/5bxMQ4YH5QdY1Ij8g8pZxnBeFZNpQMyKSIM3M7GkKMm1rp43LIsz8rtTCW16nWEaTYOCKJzYUYA6k+jcstgLS9RNVdS8De02xFY8Tj7k33dEg9fTxzEtdZPstEHzogkTGeu6mfuoq2lsrjqn0oGdYKCFqOamV8As004H8RBNeY7Zy2BKmNUGJjm6OivGvWcrawzx5WyRuo3r0HGz6is/KRTihuZiyK2+Ypsey5VOR/PCBL7TkAl8r29+acyE9NlsUvTNSZXPKSaLwBxXxdzsVsWQecfs/dNSmgP8cGhz9qIikwTt3fr/1O9VhlM6h6dtKZ988pcMKXUjmwpXPqiHuO2KBLLDVLve2ka+cs+zDqPQjf2o+Qr9waG/jTqKWE0FUU1wTXBUA88YjLxks0vnKR1WfCX4ExAy90uxmig472o4Y/LL7Tx191eqyUha5YIK5aMGiAlyL7YPiX7jdVvlLzIBA7THdM4s0c+67+xW69fHiPsi2Wmlg8HMm4d5YvbmQw/3Ff9MPeZHMiyA6qmmfdM4l9huTKFIeBhJHQByybZVlNz7rEgu+d7qClO2LQbrD8NTVnR75wK0YxSbKd46s7t8yQZj635VgZHr0rCpkrJ90TLqNEAIeGLfU089ynuh19cNZaw9lxItM3Vuo0wB7yutcGQcmjBstkg+BoJyaDAXsfuJjTG9LqJNczHf4ThWrMiv0EejwR5SFIfq0
 caSMxlJz
 1GbWMOaY0CrPSsLjvDm8XXOYNim40MynG15VxzMHj8GYvMybsae1XPJ9uNZXuuSKsNXvucvff0+KKvcLIEkVb3dAROJrlpicRk8TszrBGxhuUYbYdqGtWhaenox1E+ge/KJwT2snKlx1C+AIxGbRyTwEkcLnXa1ucRyiF2de25YBpXRKwWDzzNMoxUM2I+MRhhkHWxdoja0pNQ3QqlYB1+/dfvaYZIGVA41fibWBezQhTLCHx4bpg+jjGsJuTgHcvIE80+dUkHN9FJ4sxjnJ6MaHW2yOj4cshTCVwY9jfw4UHlRO/IKQIMUDbvvASrHxIiRiBCMGfG3Ev1oBuLKpoRNBblkuUJwA8Rgma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The IOCB_DONTCACHE writeback path in generic_write_sync() calls
filemap_flush_range() on every write, submitting writeback inline in
the writer's context.  Perf lock contention profiling shows the
performance problem is not lock contention but the writeback submission
work itself — walking the page tree and submitting I/O blocks the
writer for milliseconds, inflating p99.9 latency from 23ms (buffered)
to 93ms (dontcache).

Replace the inline filemap_flush_range() call with a
wakeup_flusher_threads_bdi() call that kicks the BDI's flusher thread
to drain dirty pages in the background.  This moves writeback
submission completely off the writer's hot path.  The flusher thread
handles writeback asynchronously, naturally coalescing and rate-limiting
I/O without any explicit skip-if-busy or dirty pressure checks.

Add WB_REASON_DONTCACHE as a new writeback reason for tracing
visibility.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c                | 14 ++++++++++++++
 include/linux/backing-dev-defs.h |  1 +
 include/linux/fs.h               |  6 ++----
 include/trace/events/writeback.h |  3 ++-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3c75ee025bda..88dc31388a31 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2466,6 +2466,20 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
 	rcu_read_unlock();
 }
 
+/**
+ * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
+ * @mapping:	address_space that was just written to
+ *
+ * Wake the BDI flusher thread to start writeback of dirty pages in the
+ * background.
+ */
+void filemap_dontcache_kick_writeback(struct address_space *mapping)
+{
+	wakeup_flusher_threads_bdi(inode_to_bdi(mapping->host),
+				   WB_REASON_DONTCACHE);
+}
+EXPORT_SYMBOL(filemap_dontcache_kick_writeback);
+
 /*
  * Wakeup the flusher threads to start writeback of all currently dirty pages
  */
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index c88fd4d37d1f..4a81c90a8928 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -55,6 +55,7 @@ enum wb_reason {
 	 */
 	WB_REASON_FORKER_THREAD,
 	WB_REASON_FOREIGN_FLUSH,
+	WB_REASON_DONTCACHE,
 
 	WB_REASON_MAX,
 };
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25e..2fd36608ac73 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2610,6 +2610,7 @@ extern int __must_check file_write_and_wait_range(struct file *file,
 						loff_t start, loff_t end);
 int filemap_flush_range(struct address_space *mapping, loff_t start,
 		loff_t end);
+void filemap_dontcache_kick_writeback(struct address_space *mapping);
 
 static inline int file_write_and_wait(struct file *file)
 {
@@ -2643,10 +2644,7 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
 		if (ret)
 			return ret;
 	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
-		struct address_space *mapping = iocb->ki_filp->f_mapping;
-
-		filemap_flush_range(mapping, iocb->ki_pos - count,
-				iocb->ki_pos - 1);
+		filemap_dontcache_kick_writeback(iocb->ki_filp->f_mapping);
 	}
 
 	return count;
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 4d3d8c8f3a1b..9727af542699 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -44,7 +44,8 @@
 	EM( WB_REASON_PERIODIC,			"periodic")		\
 	EM( WB_REASON_FS_FREE_SPACE,		"fs_free_space")	\
 	EM( WB_REASON_FORKER_THREAD,		"forker_thread")	\
-	EMe(WB_REASON_FOREIGN_FLUSH,		"foreign_flush")
+	EM( WB_REASON_FOREIGN_FLUSH,		"foreign_flush")	\
+	EMe(WB_REASON_DONTCACHE,		"dontcache")
 
 WB_WORK_REASON
 

-- 
2.53.0


