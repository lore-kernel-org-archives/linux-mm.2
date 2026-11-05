Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510AF606A338
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l+wnEHJf
Received: by kanga.kvack.org (Postfix)
	id E49D76B05B1; Thu,  5 Nov 2026 01:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFAD76B05B2; Thu,  5 Nov 2026 01:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10806B05B3; Thu,  5 Nov 2026 01:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADABA6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:59:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EE1614092A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:59:16 +0000 (UTC)
X-FDA: 85400163912.14.9304664
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 98D5820003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:59:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+wnEHJf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793861955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8CTBv2FsWWNYoIFrDUziKjer08OPepQNcF8zDvYRVUM=;
	b=HeH5Tpi7+91SR+Zw4e6XRlc8C65GSo86Y/kSxNmRuoJNCdgybBmuWksY1JC6cfqWc22PeA
	SiIadZZPgWtFmrxVg9epICJuz72lWusfwRY0fy1+U6hnJ1pcTMHETQ1HERjb8Z9Z1D5YAD
	sHlo4n4MQRtOuB8MFAMWj9tvBrK2Ofg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+wnEHJf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793861955;
	b=nagUyUdwe0xvUSRMhBld8hmLudmgLa7CINmVqZsR1alCflxLDRV/hOtSmA2YPuxXHBjVNN
	5ICZhcxNcTpCvmAw511Jd33t3eQVI9xrJ1v4QRRilu+cekRWrKKue8dN+eZ1RUz8RJE5A1
	IIjDte2ESmr7mKFZdDicxFHDf5KtL3k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fD7pQ7iJNJUJ2Lt+Fn/kSJBY5hEsxqJHEyhADQZ0hVw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861952; v=1; x=1794466752;
 b=l+wnEHJf6Oiyr1JLlLvY1SuR55TOc9qTue71B8BOIDVVCSFo+lpfKq7XMsobufkA1UDFYuZg
 S/4hbx3RQyzDu0U7TxzFT70wLujr3gW8YUSoIvIo9yke829B2TSk5zIlzdtImG9Q4nyXjjfNiiI
 9RSLtJX0JrbHg4jDSxSgZSDo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id deff676cf379e19e;
	Thu, 05 Nov 2026 06:59:12 +0000
X-Mizu-Trace-ID: deff676cf379e19e
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
Subject: [RFC 0/6] ext4: Add dma-buf read/write support
Date: Thu,  5 Nov 2026 14:58:41 +0800
Message-ID: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98D5820003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4p1bkksetyow9i4p7u8xrs1h8waf7kdz
X-HE-Tag: 1793861954-11067
X-HE-Meta: U2FsdGVkX189hWvIN+gfjcPgVJilPZr/RKqMikKKA4kRKPK8pvd/apT4tZX6qJKJkSw+thSI8wiw0NV327V2wQFVeRO9ib+ifHVG4UDJ2SwJQh8Ojl11YIVcy8YdKLxNEHO21gzieAPlIsumry21Yy+jcVxd9vrm6vkB8L/o6ANEa6rsqybseFEE+WnQ8h8N6xaCVZoinRXX0WCfVBjYDDBJvYZSXiPvtHtulYMazSxZd7OLllf8U1M79c3ZDsoNuV1PF7aGMqU96Q3dx+h0fIiAM0QfZ380d6NcrYChZSEiY5K1GlFf9RW7g9QiHu+1oWSIuxGog1UA6iLVtaMXyUqROaVu52bmRKALL4xgCIzThc9XxOkpT9hWNl+ytObYHKT0P1WDjlKH9h+FzJVz1ToatfgXt7iZeD0rzSh2BxqsXhxSXs4tg+rVIR4/ex2UiEHEFzCwD8qYs9A2Hsc5op99YPpRsOpE+HwSmQqGP2ofk8n3CDQPgahK5MWoQmfndMaSHv2hgPM7eRckQgEPiDP9JkNRxseVrbrAjoBRO3okZCYXNzEmOCpcXRh9hu3N3dokQfO8U5Iq3wADIbcPgh0bxsrAcW+l++tGFaVtMSsooc9FP6RVfw7FZTrXXGaAiKHHQTdaXau6HBYikpn072kNvhe7I4Hr9HcWQXPyOsBPmraCySqKaSP7PiuKzSDvXdOP55PnNjPOdZ7D4dN474f42mTMsHEx8IbXyjSL0KuyuhCGeZo2QFP18bfCfB6pl5S+NmYX5sK9V9w+YrWc/UxNDRjjZni8vwQuNKwjox7xNApyvF+oIVg4/CbYlqMs66P1pvXwI1wgGDRBLg04siqKk+SVvXwwxIkRbTf4ZZR0JB9O3vE2SNPkAnca1ux8SWdj9HFIXhWF49WaAEN4AM13cnypgpcjTEPGwEl64bz+Nl5fybP5tY4nXNhVPz5h8jB1gfPZI/Cwow0WEdr
 /+5rLVYJ
 EvAiXLgJfV62maUuqn4Uhw8tEsZ83vOXg6yeaL/khZ12xgHKci5zaVX9oSgWupBarsGuHcvDy2YT1OrCAPPYZ7Cw3XW6On5Wv2Uhp8Mm2u93p9bnZFdodBSNBGjWndqloVVYg2sxiZM8N0w9c57S2L6Rq3ZjREDBhyrDBE9yg8RKyO8EfXXKVmKFbInNJPXyVJNsUMLzAAxJdjTZZelv+HwY3rP+I6Lj2lcCS8iJvNZmtm32jpjhsy1JhOLFtc/X6V3QgiwL37gaCgpr4+gOcJi/XtivLWHk+sVmrbbEjemnXKowosFbfFoaFs2iXXkWOY3JlE45stsk+67/jKRsWjF9NJha4jvczyMTDCEPhQqC6i0pSazTzmftnaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

This series add dma-buf read/write support for ext4. The dma-buf direct
I/O infrastructure allows dma-buf to be handed to file I/O as an iov_iter,
currently it only supports raw device. To better serve the GPU-NVME direct
access through normal filesystem, prior work for XFS has been discussed
at [1]. We also are interested in this field and working on it[2]. This
patchset is based on Anuj Gupta's patchset as there are common parts at
block/iomap. The base tree is:
https://github.com/anuj7781/linux-kernel/tree/anuj/fs-dmabuf-rfc-v11-desc-v2

Patches 1-5 add dma-buf guards at several common paths at block,
mm/filemap, dax and iomap. Patches 6 add dma-buf support for ext4.

[1] https://lore.kernel.org/linux-xfs/20261016091919.971295-1-anuj1072538@gmail.com/
[2] https://lore.kernel.org/all/20260908131545.105987-1-liwang@kylinos.cn/

Mengmeng Zhao (6):
  block: refuse a dma-buf bio that carries a crypto context
  mm/filemap: refuse dmabuf iterators in the generic read/write copy
    paths
  dax: refuse dmabuf iterators in dax_iomap_rw()
  iomap: refuse dmabuf iterators in iomap_file_buffered_write()
  iomap: refuse dmabuf iterators on contents-encrypted inodes
  ext4: support dma-buf registered buffers for direct I/O

 block/blk-mq.c         |  4 +++-
 fs/dax.c               |  4 ++++
 fs/ext4/file.c         | 33 +++++++++++++++++++++++++++++++++
 fs/iomap/buffered-io.c |  7 +++++++
 fs/iomap/direct-io.c   | 10 ++++++++++
 mm/filemap.c           | 22 +++++++++++++++++++++-
 6 files changed, 78 insertions(+), 2 deletions(-)

-- 
2.43.0


