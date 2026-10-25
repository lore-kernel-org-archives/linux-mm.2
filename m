Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E22606A32D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 12:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=a+alNaFD
Received: by kanga.kvack.org (Postfix)
	id 57E5E6B05B0; Sun, 25 Oct 2026 08:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52EF86B05B1; Sun, 25 Oct 2026 08:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4449F6B05B2; Sun, 25 Oct 2026 08:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 268266B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 08:41:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EBD98040F
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:41:52 +0000 (UTC)
X-FDA: 85361110464.13.C584D0E
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf11.hostedemail.com (Postfix) with ESMTP id 12D8840007
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:41:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=a+alNaFD;
	spf=pass (imf11.hostedemail.com: domain of yaojiale02@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=yaojiale02@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792932110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGxgnZ4Nb5+HVxPTfCx+RwDc2J83kiFYIRes4qeJPT8=;
	b=Zd0Qv2zBd7hZmNqzfLl77EHp/s3Z+7NGrDMjvfOQ4TTDOVjz/GOr+Uj2c1FUPkHobO1VUE
	OAKC657dzC+W8bvYVBYb72z9i/WQ9D1vKjOkmfOchHAhpaBtKIpwA8mKTprvHeX3JAif2z
	Np39IfqdioeGz6+pXX4kbsof/hxsEIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792932110;
	b=KgUEm4pbPjYMlhAyyZpnxJTomm9g0D323azrFg4+Q54PMvgCXvKeweuVlHJYhv/+PFDepX
	e4Fp18JH1OY448J1CiU2LEXIxa0nTG8H83YsGm6sT2jB3SgJ7e6dDOY65aJjAPWrNdbCCe
	pOP9m2Ka29gDdjIub554WiPixaepP9Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=a+alNaFD;
	spf=pass (imf11.hostedemail.com: domain of yaojiale02@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=yaojiale02@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=xG
	xgnZ4Nb5+HVxPTfCx+RwDc2J83kiFYIRes4qeJPT8=; b=a+alNaFDKo+L25nvd2
	DmanOPi1/a4qkJ36ZoDSJFtO6iTrhrhjvmJznpgNhzuiiiQoHwZlL/5E0/YVl7zK
	L+1tFgK10dUln03+UuJddpld7lfXjLcnLp+vb7oNi3FNUPvCeOkWUIR7DgkbSmIi
	hikcDJW/NwRtFozzxIQdwOm+Q=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnvTzs+N1qxJALCA--.54355S3;
	Sun, 25 Oct 2026 20:41:20 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 1/5] filemap: drain in-flight DIO before buffered writes
Date: Sun, 25 Oct 2026 20:41:10 +0800
Message-Id: <20261025124115.3178287-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261025124115.3178287-1-yaojiale02@163.com>
References: <20261025124115.3178287-1-yaojiale02@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnvTzs+N1qxJALCA--.54355S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1DtryfXFW7uFyxArykuFg_yoW8WrykpF
	Z0gryFkrn3trWxCws3Ca1Uu34rKFWDAay3JryUWas8Zr1kGrW3KF10qryYga1rAFs3Wr4a
	vrsYk34kCwn8ZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UM6wZUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xCMxmrd+PA7ewAA3K
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12D8840007
X-Stat-Signature: qok939rbzj1c7117pajisfzih1e5i7os
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792932108-199593
X-HE-Meta: U2FsdGVkX19WPRACoIUlPzsONWd+6HGzYiJMgRu5Iky9cGws6++gQIRnPRtnUey6j1nPBMYMzj9i0HFweXqkwSKziOKA9JGVcXlP+ZgLI1PBfzGlzu8YGTBKuhRzkPcGeuBIzWHXuDUntQFpCfvgt0SQfbRK2hCyYEdMksyJd2Br5V7HTLzx+pSSvXp5T/bSA8lUFlGs4CrL6HceFrZPI/5Ov2NLwiMJS+bpnKCGfTNMMnXTGD7JWA7AFvnPCFTSCbjIg5p1tLUGu3qabnOvk92QR2G+dBRFroBrtQvRN0bUW0duwXQRas5/iV9Uvg/E60Yr2zZgiHphNxUaD6jxWJYxaIZwimRKFsWNLFdmJXemlepNL1PzAfQ83slEpHJOeKaTnVtz/uceK1zcmK8f3JXJM3X3X0atjZ+kvq6aJ+Q6SSNFMqpr8zoBkSc7RE1gV/jtaLGjfD8r/cV0QCwwMODrwys3r+R9svin95vZV3RMVAJ6NVYoidde7bilOM2+GWq/B33/T6mYuI5zbreWzW6s4QXgf2JazJ0f6rUSpU8BXdFZ0OsrryBj+nvtby9AMg+cdqSt4BoDQyLlAMw93/QKAYgQ6b8v+jUs6CJ2cs8IycbET+Lao2BUOldLCnKocZPWi1+XqeE715rfH/YvAcrhVWR56G/3E8VRseEnZ0WeLhxPv7d8GhTO19wjbejkSHEJzY9lbLePuPSxQ6D+aNhFjzXQRodpdkx5ZznW1uVV/R1Bh1dfyYFfMGj7Ux1LKgK8a27zHdBJTDo58ZB+nXlIgMd7m5bk4bRU/oPDI74CJVtXI82Z1YT2Elmr/BvN4aEE9fMUvTWWTpdXQlsbNJeoKtboydZggTVhgyFK6sDZOiIF8qT5HAO7YkilaYO4BQshqChBe/akkWMKut23/QTbY1opTaHozUwpwE+S0k1FI95CereRyzfIBjo2OyuS9H/8ISrXRj9zHTVAuWU
 sFkcC35+
 HusQAad0Sl3u9b4LRCwLeRUH+FublFxBy+Wnl2WXlusCB3E74XgCZyy4qGY+5ZT4DFsNIcs0wv1kURKKEZA7ZvxGLc7x30BYCmsdrWK1n4NsOfffY1FODDkjVvXXj2KQzpTFQ1VItq6/R+39ifOt/qLj0Uzjm4LEPVNA0UUYm31XXnMYysZ0CfIX4T4Nbg8Umo5N3RkyhnCKNMkvf/nbrWPdKQORFiCcpanP+CkJzlAQAHtrIK2Y1pIOQ9TTgARMHpaW91P1Yxu80Ny3fc2esaNagpnQDI22ag2sf/P/lA1STqszNMZuerQHHqiemFkYpbbdUI6asaAX9RdscB9LcehYqXRSW40LV6V8C9dAU4Z0QQ6j+0K1HPjew7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An asynchronous direct write can remain in flight after its submitting
thread releases the inode lock. A buffered write can then dirty page
cache before the direct write completes its post-I/O invalidation. The
invalidation finds dirty pages, reports a possible data corruption, and
records -EIO in the mapping error sequence.

Drain in-flight DIO before both regular buffered writes and direct I/O
fallbacks in __generic_file_write_iter(). Preserve IOCB_NOWAIT semantics
by returning -EAGAIN when waiting would be required, while retaining a
positive partial direct write result.

Fixes: 8174202b34c3 ("write_iter variants of {__,}generic_file_aio_write()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 mm/filemap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..289b8ca44ada 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4502,10 +4502,19 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 */
 		if (ret < 0 || !iov_iter_count(from) || IS_DAX(inode))
 			return ret;
+		if ((iocb->ki_flags & IOCB_NOWAIT) &&
+		    atomic_read(&inode->i_dio_count))
+			return ret ?: -EAGAIN;
+		inode_dio_wait(inode);
 		return direct_write_fallback(iocb, from, ret,
 				generic_perform_write(iocb, from));
 	}
 
+	if ((iocb->ki_flags & IOCB_NOWAIT) &&
+	    atomic_read(&inode->i_dio_count))
+		return -EAGAIN;
+	inode_dio_wait(inode);
+
 	return generic_perform_write(iocb, from);
 }
 EXPORT_SYMBOL(__generic_file_write_iter);
-- 
2.34.1


