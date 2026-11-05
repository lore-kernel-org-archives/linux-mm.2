Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74204606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QaWf9wb7
Received: by kanga.kvack.org (Postfix)
	id 942686B05B3; Thu,  5 Nov 2026 01:59:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9191E6B05B4; Thu,  5 Nov 2026 01:59:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859166B05B5; Thu,  5 Nov 2026 01:59:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 606BA6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:59:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF39C1A0990
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:59:41 +0000 (UTC)
X-FDA: 85400164962.22.466D6A5
Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0A1F420006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:59:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QaWf9wb7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793861980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6jXYvV9dka+3jN4FlL/QeRxDjLIKwLo+qsWJ9KiY6Q=;
	b=unyoQRLiivg6MtlxecAMUgVAkItF97oFpodF2GnbdTHoxgZgFABqgpFsLK88ce4vjNtcUQ
	nLm84l5iW+3+wq0c9iJ3YyH5bbqwrA9yTwHLnO+Y4Ep0dmKLth44G0+K0+CskAwdQYEeTB
	1yCokbggcWOphldtZJ4znQo8YLckzV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793861980;
	b=3BiShC1OVdQ6NX+xxvmYyyqyDto+bgjOSDbYGOOj8eAsmY89kQA7Z4vJJUpFeh9JF7sYA7
	tLcrPAh/MW+lRhZ7vi5mgYOUMWND7r7Bz4J6dkEP7Intssu5ny0y9ipkP+5Qb64cFvMvvT
	5CxqUHQcpNoMvXHdtJtCJHhVqlr/xH0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QaWf9wb7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BRMlNTa2IFz117u+LpOsOZxcnQTogf6s+dFMFzcP0xM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861978; v=1; x=1794466778;
 b=QaWf9wb7wFivbY4mUbRehlCWWKN3tB0cW4ajPirSzhAocmjyx9TuV37CtcFab/80djMAdLFe
 jRYRmmPTKw1NfQidftHLvJl0yYWgWkAWXm2oWhCr421bGdGGf0wTAUxeGgQ/rZbnokP26pzIvY7
 ddWpsDXwlLWg655twgRVJAOQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 724bcf4c5e474fe1;
	Thu, 05 Nov 2026 06:59:38 +0000
X-Mizu-Trace-ID: 724bcf4c5e474fe1
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
Subject: [RFC 2/6] mm/filemap: refuse dmabuf iterators in the generic read/write copy paths
Date: Thu,  5 Nov 2026 14:58:43 +0800
Message-ID: <20261105065847.196540-3-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: auu6n6ntyh6tdjruaczd3ns9srai4xhh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A1F420006
X-HE-Tag: 1793861979-123098
X-HE-Meta: U2FsdGVkX1+pc+WmeCiFekBFhDhoxBEce89yNw/kwzSYiCKeYJOh1lhHeg+QxMFC5XXMdDe9gPfLdQvWLDaCmPM58fqrUiqU3rxbz20XOWpvdkg+1z2XstmmLz7LA4OMnV1NG9NAzrrFUBWDhASWbGU7/5ujVWD4eKjPRp9qABfHH6q1u1Qlp16PcgqiczspoITXJtG/pxqwnuAZ6q118wImP8r0AURxlh95Bo/YEdmEKX/g0xTl5HagKj8f73bhSmZ5KCZhmiUT/Tp7CrFaYTrLUyWH1MgNC/9jnZ6fQmOSu1/bnZOh4zmeJf6WB7ApkVbL3dn/fsYekJsTJ7IzOqgXQHWMzadAs9sSGBsGGF5ChkEIRG8i2+BFFT/xZPZyqVcjvKGUErilPlKIcK/2fz5U8+vmO7FunIEh0O04iBXV/SrE/F82JBvOIZZqiEdT91jw4vExLe0hB7FN5g3EQ50yd9XXquQkNWXKGLZXdxqkTcgBS675KUzFMi83Cg9Csfs4n7khUvrCIgcakafBB/PzXHTWdwLHvcAFnNprZjNyEWO1RKu8ISrEm6aNLydHgEB+7bie7okKtVpj8y5l+EJJL2yU8x7oUKnEJWspqlXRQCOim4BBKz+M8LYQ+b1YaqchUwOnhpivrpxL8WihOhXrt5zdmNfPa3or6+BJc1atk3kZ19EzWznz9qTQ5EeiLiT7X5LJ4jG+c3s8W/F7zPfBY92omUtDB7aPk3SHlUqAegQc8CYrNe57UDsM1AdqliOql7C7mQgGhNpLcYJReNhsi6DijaBqOfrK6R0h+MHTfgbXFgSCfVdx3Jf453oRggnvxu/H0mnl197ruXoSJ2ePWXCDXvm4P9oN4smzyqCwc+1oNYzLHCntbY+weT1qbSbSCbzY3VqH9Q+A2Oz8qDVYTh94DhbCtjB+Jzd0DWJIr12g+nJMlEVpRx8jk7axnThx8XMRoabexx25bYs
 aYj0Tekg
 plr8bqedUfkYyaUnevEaJGm48ZqyWfRGJDIXuYL3w4iWIMcI7Ltk6Dz1bps8iJ0eIkzTq+WLBBXTPHIH15lxiFqAFDvV5HhxwzaP28xIty0vP/mf0dEJ1SjVgHjWV89F7R/HnJ/4ozianPGPbrm0AMrsczyjzaPLpoitUoA1QMuxxgcIqewn7vkypuz2s/q0tiwuqmCu3f3zvlswDSJdwbf5Kqs7v+68Ay9RUsbaMk+aat3d+G3yUS6zPXEHGrEWoAg7fQhnUOas80rd82cCuS8ZTpxEftFreUIKElvSlvkmal+lnT3NGMyxYFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

The generic copy helpers cannot touch device memory.  Refuse a
dmabuf iterator in generic_perform_write() and the filemap_read()
fallback while keeping any direct-I/O progress, and report a busy
folio from generic_file_direct_write() as -EAGAIN instead of asking
for the buffered fallback such an iterator cannot take.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 mm/filemap.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..ab8a5391a699 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3013,6 +3013,14 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 			return retval;
 	}
 
+	/*
+	 * Buffered I/O read is not supported for dmabuf; a short direct
+	 * read before this point stands on its own, as in
+	 * direct_write_fallback().
+	 */
+	if (iov_iter_is_dmabuf_map(iter))
+		return retval > 0 ? retval : -EOPNOTSUPP;
+
 	return filemap_read(iocb, iter, retval);
 }
 EXPORT_SYMBOL(generic_file_read_iter);
@@ -4300,8 +4308,14 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	 */
 	written = kiocb_invalidate_pages(iocb, write_len);
 	if (written) {
-		if (written == -EBUSY)
+		if (written == -EBUSY) {
+			/*
+			 * Avoid fallback to buffered write for dmabuf.
+			 */
+			if (iov_iter_is_dmabuf_map(from))
+				return -EAGAIN;
 			return 0;
+		}
 		return written;
 	}
 
@@ -4353,6 +4367,12 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 	long status = 0;
 	ssize_t written = 0;
 
+	/*
+	 * Buffered write is not supported for dmabuf.
+	 */
+	if (iov_iter_is_dmabuf_map(i))
+		return -EOPNOTSUPP;
+
 	do {
 		struct folio *folio;
 		size_t offset;		/* Offset into folio */
-- 
2.43.0


