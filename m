Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4EBCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 07:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FB28E00ED; Tue, 12 Aug 2025 03:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF9F8E00E4; Tue, 12 Aug 2025 03:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF088E00ED; Tue, 12 Aug 2025 03:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB8F8E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:23:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E23751A01D5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:23:22 +0000 (UTC)
X-FDA: 83767264644.15.10FBB2C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E1CE1A0006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:23:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LOji5XU5;
	spf=pass (imf19.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754983401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JjlLxLRI6fLwtv2iE/50RkS+dk+jF7EbPdI+ydJz3ow=;
	b=QpXbkojl6rbmQDFNH9WDCGcmdyFpNEawXh/nwAUo6D7dzh2biEVVfXDRdTnPfu1L/7pAyt
	4j0+m3tc08AgvTAdfiQbjFLH17ooGTCxgr6fRZB5ZYYnU/QCzR53gGKaqH67Vto43vnZ9R
	qDmHo+0fSaikXmgo8O8UcpxM4SMHAQ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LOji5XU5;
	spf=pass (imf19.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754983401; a=rsa-sha256;
	cv=none;
	b=3dp+ViPSiVFv5gpxVrdYGlzuNreXAjvJqP81IExqhr/BxCZfVV3hpDU3FIXbLdzkd22fSH
	0LGMGFt87zPqJlQO1XEpTJVbkgxO6L9HSCJlIlXV6pHvUOsjp712SP1aaAgEZAWUjPWUZq
	yHmKtBSOPa3x+WZQFzPLtscZSm6Bmh4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Jj
	lLxLRI6fLwtv2iE/50RkS+dk+jF7EbPdI+ydJz3ow=; b=LOji5XU5lpsMoVqWbl
	tnY5dHtpSWHADwj/Dsif2UfS217Fus03rsVeg9km1bHa+99SrNMJROmiJbKr+ctN
	WVaSd/4rEsz6ucQ2Bh9TiTFg4qRl9+VgjdItSwZR7DQXV7LHnjGTaBSrp4P+awB2
	qxjWZlLGLiFG29DKS5+ZxXkUU=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wC3RSPN65pon26ABQ--.34118S2;
	Tue, 12 Aug 2025 15:22:54 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH 1/3] mpage: terminate read-ahead on read error
Date: Tue, 12 Aug 2025 15:22:23 +0800
Message-ID: <20250812072225.181798-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3RSPN65pon26ABQ--.34118S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4rCFWUWry3tr18Wr4DArb_yoW8Gr1fpF
	y0kFyvkFsrJrWfXayxJFsrAryfK39Fga15JF95J347Arn8JrsIkr9xKa4UZay2yrZ5X3ZY
	vw10vFy2qa1UuFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUnYwUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawKnnWia6QNKpwAAsm
X-Rspamd-Queue-Id: 9E1CE1A0006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 99w83t4wi4ehhdnye9i1h6gu339qy7dz
X-HE-Tag: 1754983400-449139
X-HE-Meta: U2FsdGVkX1/3DqiZKbNpVzw/Z3pwMDf0Bs/cObOx2xdO/nDRujrKy9B9wnQ9bDRIyJClr2kKt/i1o/vj8SKksOMu7Q2p+rKKboXj+MeuXGcyAG7jOlBLaN9Z2cJ14Vn8KoK3mznQ+hmSzrYSQRVGXVNncVs+bKH4B91DP+jOFMeYi0NBkrS+tibb259uCx35mHulmEXVRbT0gP0Ef1/vuDsr6UNJM07qGW/HW/7CmDMu6TBg4UELsG0lrnwkUCGs1smEXfLKS9I7gmY8yhMnZP6fLL3hvcY8IS2ueMtHFmeM1sTD74eNROUdQ/fIwacs+FSzrCew6oeCTFppCF4pTMvQxry1Wc8gqYO4xiPVsk3Yl0YbPlbUvX5ar3Ch1iEw0ChUEPoqNiWNIJSEhWxLZT65VrOYKZNMamHAd1ShzzgH/eF2y3AeyeoXrDHT2/cX7QANvE3xxjqpQ003Kxrf++dl/5BxUsQ8enLLW3wOPuoat3DqoWTo/PJTGS/nrst7TH675g0KDDw8LqQ25yKqbW0oRTpt+Vw8QiTi19hGh5nznyOwzQ5dejj+oLzYnXitQyS8nwhQ6E+4L2CCSxfvguo+BUdRzPG66e/5SxEKdsedcTq5/LE8io0/wRQubeLCmJxkdW243Lm50m/NijG7uT0AijHwOt/eLbuXn1mbYwEuqRCInKm8p1Byuxu22OKzZDWSU1Jo4h5pQe3AmM8VJctAdfQ3UsAVudIixP7pgwZFh0O++1801ApkiDYO4B9PFB72FzbTh94JBVe/upEupQWGWvqc+sAGqTDm6y1cfQxrG9/3YXyFgba6iaQoHCnqceQusPodgu4k/HBgC3NKDgUw4/HIABabgQhg3aPrQF06L6vUz74yj+RMLwzoLnK2zjY1DOhs2q2t0eh/VDSf5VHCJ/2Te++DruSh9OpZeVCFezbbKR5fBIL/CuGxPCu8cbX6/LHSCsPHGFg5eIy
 V57OY7LG
 ok67wc++hnqoIJfTqEvw7iVS8sS2UqXiIgCO5VReJdHiWl9bZ0sbXX8r4e9tDcFgLvJf8VHsZ+QHTlVvidgOu2Yx0ME1s4GDOmJGZgGjxU2LXAIAuDwQJrS2ZHjfDdJs6dellEc+yjj8XDmN45vsLFdVI/bmzzneAERwhA+ySuFa2VcQ3DJmxP5g91MVI7gGW563PMUtepyDs1hpNQIr7khemCFjGeBOgN/KM1aImRDCyoHcY+jgXv5kMjJHlJ7EZDDWs53glZMV+ae/hO9bLtfWr1e8freEtkXspQYUHxObo6Yemo5q9SpZk1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

For exFAT filesystems with 4MB read_ahead_size, removing the storage device
during read operations can delay EIO error reporting by several minutes.
This occurs because the read-ahead implementation in mpage doesn't handle
errors.

Another reason for the delay is that the filesystem requires metadata to
issue file read request. When the storage device is removed, the metadata
buffers are invalidated, causing mpage to repeatedly attempt to fetch
metadata during each get_block call.

The original purpose of this patch is terminate read ahead when we fail
to get metadata, to make the patch more generic, implement it by checking
folio status, instead of checking the return of get_block().

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/mpage.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/mpage.c b/fs/mpage.c
index c5fd821fd30e..b6510b8dfa2b 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -369,6 +369,9 @@ void mpage_readahead(struct readahead_control *rac, get_block_t get_block)
 		args.folio = folio;
 		args.nr_pages = readahead_count(rac);
 		args.bio = do_mpage_readpage(&args);
+		if (!folio_test_locked(folio) &&
+		    !folio_test_uptodate(folio))
+			break;
 	}
 	if (args.bio)
 		mpage_bio_submit_read(args.bio);
-- 
2.43.0


