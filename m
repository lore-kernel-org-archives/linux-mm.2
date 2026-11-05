Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44304606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gu3dXD8o
Received: by kanga.kvack.org (Postfix)
	id 635846B05B7; Thu,  5 Nov 2026 02:00:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DDB6B05B8; Thu,  5 Nov 2026 02:00:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5238C6B05B9; Thu,  5 Nov 2026 02:00:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD036B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:00:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CFC2A0975
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:00:09 +0000 (UTC)
X-FDA: 85400166138.06.C36B00E
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8ADDD160007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:00:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gu3dXD8o;
	spf=pass (imf08.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793862007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wrzHtFxjFXd7iU05CW3/ydQ7QCAtEugjeoklBp7xpE=;
	b=emvA0ckdXlyrDg6WV+XSM4JBdtdPa47/4ptpgnxUYZwLe9VjPkFT8LAKzhXraDs7yCzRPY
	wRL2fh7P/1z2QdkfG7PtfWbgauU+DLft49v/sQVARc2MBskvAMWT+g/ASPqaZwicOrwS4d
	8ePp8oOYhRvfRtPEIpKeWc14UwqIAfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793862007;
	b=5LvTRBIPLW4Zg+so7R94nYy1v8oIRrNUcJZ7KS5S9vA4Nkv9QZymTMAEev/r2v3n8fhdLp
	e7iSiwTQ6Wcti8dSRKLRAC06o3FPzSNFEEm1qXG5t4TcVNgcb1XyD2yllhMJmIG6GQyAgY
	pMHBaFFJzy9Ui9cmqo1er0zaee/0fPM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gu3dXD8o;
	spf=pass (imf08.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ax+wsuHoy6H96hgXiHuF6MzNsH6ADwaKJZJ1/7kMLiA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793862006; v=1; x=1794466806;
 b=gu3dXD8ovEhih0rAWmev6W2AOFR/IDaEehfUUFgeNq3wirBmvDlKHAqm5p/Tz+SA1BiOQuOG
 qCkwAa3XXnNoqIpcTagxmPi0o24Eif2ZmOzorQBk0pIqEJNSX3rILgB0r5bQ7BLrRzLo2c1K3q2
 2yZoCEZ1tjhFvPYpMUYTiwmY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 96e1fbcbd6d57c1a;
	Thu, 05 Nov 2026 07:00:05 +0000
X-Mizu-Trace-ID: 96e1fbcbd6d57c1a
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 4/6] iomap: refuse dmabuf iterators in iomap_file_buffered_write()
Date: Thu,  5 Nov 2026 14:58:45 +0800
Message-ID: <20261105065847.196540-5-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: fjyofwa9hjxa4raaezz9sfh4z1i9zqdk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8ADDD160007
X-Rspam-User: 
X-HE-Tag: 1793862007-839397
X-HE-Meta: U2FsdGVkX192RR9Wd0uoRA0gHX+PiKAsWB9DXQpTZcd/cnzd1bVJt4tzxVDXCkhqPZG4uYHAcFYOSlincKFhsbCdqvVFr2Hg4HcFqh8N13ws2d+PNBPSG7B935Lv7N0MolIKH3mBgCZefNx9An8mQvQoJOoD0uRLI+MnYXqqixGxbkV/uN/8+NvieAPnDNGZ5gMzP0YH75DBU/TnqkzxsixbGCw4jINNP8/qp75e1vEmPlHuXnIhlBTmqIyGr7ouYRyc4tV67u2Dn831jaoFQrLDSNoHOKlIbTE9wlYDDiKxXf9qZQDDfQuJb/gHG94UtWFMGntf5txqHgtLDhBm6LljNkElsnuVcFrQO8SrekZbsKbIOt8ujB2KcTMVrTuVPriwaXnuEoOeeA2Vuc9Z2NOBBcoJls/NWpvKs2oCKuHHnb4elpEnNeOrDGsuIdT7JIlaStWWqMa92eqQ2Q95Ijix5rd75gPzwt8k7uylhKzh6tx/sYyERfIBYSWBpWqsBeQ8rmV/v7/09v5Sv8RIL05bIYQ6+cCWOfC4HfdPnHsSxSB7AUqbn/MjBNqjQtP1nCDKSlqUqxWA5vXpum4Y0tYLiUdpOHUiV6QQAaGuEwL9MZKV7+14hAPsRNK2CowcGiVIc033OGDS9mc1mxe/LACzlLInsDDRqhqU42d3JdcDlSEWhcidTVcDx2i85caNDV21cbCk8/FjlVg/kmeta1Eg/qJAaF6dST7YnGI00AhfaBj57E8CjY5XmRXe45h+jmaUqqQBqvJVuu7FU8hcS6AxTALoL6iiI8MVFIFSZ2f0LBxWjDU9mz8C4N/Bj7U/8VvfYjsE8rlIqYAvb+pyVH1s9JzzvIRvnQI5RB8eGHgazAf4qK8KCx0r23E54OVN24C9RwUBLWrnbyBhFK6byMfSRdCDfCXZZi1G6YaNzGb9ygmJbsr/TymzjQb5UFlYGxRdwtoeThj8XJPWzAy
 9CSsFDHj
 vpHGaQx5hUwGnSAD/q9Yyl2t4NFNDxEz9bCYeipNGeO6q7x6gmeFkSBMIgVsCYDvF3uvHaEfcZ1KTiIGpTc61zEdHQrkx0TqLc/4tfQA02eUVqnXvsA52hSa2hoFtEpl3qM3R1N3mjiTQC78is/Tj82ynZ8dTQq3hoefzOA3iYyFj34gUvPGq1jjn2E7+udc7wUzL5neN93MZTI3q3bvc0spiW1ti3IDfk93/2KCqgJNMuzOuzDdYZImNZ0/6wbylTFA/ic/DDwMeDaw8qKcjhjY+wh4oc+bRok9DQaOhvn2Z+/KqBAbmykSktF+rc5tBY08SQjWy6JLbN2eEkgqJMkCjnYrGoMz4lxtL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

A buffered write copies through the CPU linear address, which a
device mapping cannot provide.  fault_in_iov_iter_readable() treats
a dmabuf iterator as always readable, so the copy fails with a
WARN_ON_ONCE from iterate_and_advance2() and iomap_write_iter()
retries the unchanged remainder forever.

Refuse the iterator at the entry with -EOPNOTSUPP, as
generic_perform_write() and the generic read paths already do, so
that every generic buffered copy helper turns the iterator away
before touching the page cache.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/iomap/buffered-io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..3f56bd225e8c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1304,6 +1304,13 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 	};
 	ssize_t ret;
 
+	/*
+	 * A buffered write copies through the CPU linear address, which a
+	 * device mapping cannot provide.
+	 */
+	if (iov_iter_is_dmabuf_map(i))
+		return -EOPNOTSUPP;
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iter.flags |= IOMAP_NOWAIT;
 	if (iocb->ki_flags & IOCB_DONTCACHE)
-- 
2.43.0


