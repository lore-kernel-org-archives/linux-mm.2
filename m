Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4EB606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UJkINKzK
Received: by kanga.kvack.org (Postfix)
	id A06D86B05B5; Thu,  5 Nov 2026 01:59:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE706B05B6; Thu,  5 Nov 2026 01:59:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5BE6B05B7; Thu,  5 Nov 2026 01:59:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 706236B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:59:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C9DDA0971
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:59:56 +0000 (UTC)
X-FDA: 85400165592.10.0BEADC4
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7BFBAA0009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:59:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UJkINKzK;
	spf=pass (imf15.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793861994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giKD9GBB7SqWcODKYmNlG0gh8SE1gt/R19vK2YjohsA=;
	b=2xhYeDIjlm7B5SY1q6HkvKc2uWaMV/s7pJJi9plhHc5+rweHTo76L95mAKfMnuC+kRy93r
	00oKVy+69nk8ZjZ1hub7O7CgfHySTUrKWsTSo/SVsBaTmoQnS8sjvMZgA8GLelSoywEB5q
	C/kvrPT+9RAlc0uxaGgMpuRFDpy/ZZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793861994;
	b=V+YWvemHtGQ66LkIHKNCfKqeK6ji9dVrLoWhtpb6+fTkV96NbMuFqFxk7kG+SzfcFSHQQE
	y3DybO3eUNfSy+NK5bYgq8bKZSQXE0J0HXA0Px9EzHWS4IYMx0fp5l5mK/m0u2whNKmTic
	gfuUIRTVtOHf0MeI0rbt6+9AGFNeYgQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UJkINKzK;
	spf=pass (imf15.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ht9W8rG1bvFhZOOVFyVUZBS1JBc1APtNoV+i3qOiW1c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861993; v=1; x=1794466793;
 b=UJkINKzKdtLYR8KtpZuaFU8oFOUGl8oRWRJRBWewSilr+ADj9oA9XTq+T9+x9L2sd0LBRZ6i
 Z/2TgFvG+kvx8D/3Hx3IU7wQqdyh+09q4ppm9LSPVLNI+LaQrJFS/qWfkiLqiLjqQ0vCkhMYn3y
 KBzd3Uw2/VTZ5LBroZQj6YH4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 770e8c686bfb0362;
	Thu, 05 Nov 2026 06:59:52 +0000
X-Mizu-Trace-ID: 770e8c686bfb0362
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
Subject: [RFC 3/6] dax: refuse dmabuf iterators in dax_iomap_rw()
Date: Thu,  5 Nov 2026 14:58:44 +0800
Message-ID: <20261105065847.196540-4-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y88ygbubend655qt5i84repf1wi7tj3x
X-Rspamd-Queue-Id: 7BFBAA0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793861994-65979
X-HE-Meta: U2FsdGVkX19HRqi65gGkAdl7JJGnV/oZ2+HGCPrytFFP76YQsDX/zgiok5DGQdr9kcWIPjuVEhkM4dm90dbovM9nsqG2YnuSFNoCFVELFm2vn+Ccf648BZw8OP5C+5QaHB59sY+2+BARa9mb6KFvTkKEHXPv25nMQCpr7F1OtBCJQhH6czAz3dwpmDINTS+23QHlSyr+lEceNAyXFMCD4E8PwU7e4akSIqW1Iz5h31yWCxRSe+mSeyjqd8YErpqqHBryypmpnOXyxciBpkzK2F35JH+0tA/MEnA4E0Qi8Gvm/Sh9+C29CZfybb9W0AW30yENcconFTnTd4M3snlbAnNEsOwL23oLP+zoQ234VnmextkcelaiT0HF9685AwgdRuIJtX89QO7AOlU6klgvSjlGavhVbkX0MCkRvdKIu1MNQlwQE5lI2jcEy4ONOxg3/1fG2/tNYO5Y5cXfL9H/UXPNHYe5YDkN3fjsIPrecF9uhxM+bFMPogps7JjA7eN5yK3/P5PVmR3meD2+QJPuz70K32O05V9+E29xxFrVNZpZqIYcU/hGF4DsmCcjSOOCT576SM8hhm1v0oxIEkIAUIuYLGCdBRM6kp0+loY9BBDNemfxeqilorRvMNiGT2Ac9prFAv8Pb7oLRJidz6gMpEXpDslwJm8rHzi6mg/6RGJRzmpn4qsCVIqYhYzxvfeK/weEybNbnQECZZfDKFvnV+RobqZ75Nns11yJO5+RdeGpyJW5FoDGwCVm8sZkpFqE6plvohoEGnFryXN1I0Hb4xoGr4KqbG116PNY4uPvAFLWzlRx10KZE+h0b6cRb3fedhO+y/nhF/vmbzOrIMU/dJFKPZgY++j9iNwcaA7m77yf/rKrjg1467B8Cco3/zM49AdoKVkfI7GJ6nP6n7i/KLRW44T3dZkmm5zicfCswDo1buGNpGWOMSktjowC32zMJUELs7Ozfr7uTK2Rgln
 1JAhY1qD
 c7xCCiXe5b0rdp667pqoxs5lD+s3qgEGy49yShogUoHO43QTEh1rrb26w1oWxyUPKWTLl1+DZ567CpuedVKyp1B6GANSGcq201Bwh0VUaTJUtqgsIEaZmU8jmgCirIfcuyinOVHlYjQH1zVSRFK1RZbIxoihNK/2f4w3iyWEB5yV48SencEuoAqmAJwwsClE2jYStN2E2yg1Qfq01Wk2aHWVIlJ+g2MLNlPkZIrhAosQ+6yTU8OyEPIvqH/2TwBIy5NtGKp3OTbpgLbNvECueQzPSjxMY0Z8D3PiENFogGbJhQxoUksL5SckiL6h+L+GAVpdGtQaU9g8MnFhyy4HCEMDLQsPvDXdq41xwUxisEaIVIpznMLh3S2ccxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

A dax access copies through the CPU linear address, which a device
mapping cannot provide.  A dmabuf iterator reaching dax_iomap_rw()
splats a WARN_ON_ONCE from iterate_and_advance2() and fails the I/O
with EFAULT.  Refuse it up front with -EOPNOTSUPP, as the generic
buffered copy paths already do.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/dax.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 6ba50142eeb2..6ec08316aa6c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1759,6 +1759,10 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (!iomi.len)
 		return 0;
 
+	/* dax copies through the CPU, which a device mapping bypasses */
+	if (iov_iter_is_dmabuf_map(iter))
+		return -EOPNOTSUPP;
+
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-- 
2.43.0


