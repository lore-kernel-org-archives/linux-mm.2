Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA64C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 03:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184FD6B00A5; Mon, 29 Jun 2026 23:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136556B00A6; Mon, 29 Jun 2026 23:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41376B00A7; Mon, 29 Jun 2026 23:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C94E86B00A5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:13:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 582281C6982
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:13:13 +0000 (UTC)
X-FDA: 84935107866.11.DA867A6
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE29EA0008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:13:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="n7i/2IHW";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of yanzhen20011121@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=yanzhen20011121@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782789191;
	b=QxOcyKerjRE7DGtWdv95GKH2Rnz2BXbjiV5YvHPNQj86SWz8kL4wfXZEQn2zAuyUY2gzBE
	+UIBd56+4rp8lJqgFdtZJ+HMUyrZTO9NDx8mKKL3Y4QA9zBtK/4ZUiFQneWq5kkxEeWll8
	mwtN73HIOkE1kraXTleSKXhZPsGVMf4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782789191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ceoCjYNNF3U4NL9LaVK+JffB9FyD9tajby88BFAZU1w=;
	b=Hy6iPh8RyreGCkH4ULu/OMWe/ojcCq93OF6Dftix18N8oRet3q9QsVIXl+hLz4AyPW4KA6
	Zr3byLRKvPB0Ox1MxEqE+S9D5BIn9dhD5s14QxA37oWDs1kDI5ngzOUOlHBvBK7g7U3Sfj
	JxFtsPu5SKnn2S74gAJuiTielvk1PZM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="n7i/2IHW";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of yanzhen20011121@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=yanzhen20011121@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ce
	oCjYNNF3U4NL9LaVK+JffB9FyD9tajby88BFAZU1w=; b=n7i/2IHW94F0tg4FQA
	I8y7pyv+r4AJNY2qeZZPvuVMDowRZsPrAEY57SQsnUUdZfIKP/OvXXgX0OPmHYMv
	nVOF2A4jdwBX+u8UQKPz2gmRKw+wZxnH1zSS3DQpiJV+tROcrGAQsgYXVXkzooVl
	UwDTiQUWmtgWWvoKxpcLSCvNo=
Received: from yanzhen.lan (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCHQ_oaNENqtzXBEQ--.32894S2;
	Tue, 30 Jun 2026 11:12:27 +0800 (CST)
From: Zhen Yan <yanzhen20011121@163.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH] mm: fix mapping_seek_hole_data() overflow on last page
Date: Tue, 30 Jun 2026 11:12:26 +0800
Message-Id: <20260630031226.3141360-1-yanzhen20011121@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260629164932.b91930b0497e8446a2a549d2@linux-foundation.org>
References: <20260629164932.b91930b0497e8446a2a549d2@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCHQ_oaNENqtzXBEQ--.32894S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1UXF1DAFWDZr1fXF1kKrg_yoW8AF4kpr
	98Gr1IkrZ7Xw1ayrZ7G3ZrArWrC34vyF4UtFW3WryUZFn8Gr18Ka9093WY9FyxJryUCF4j
	vF4jvay2qr4UJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOjjDUUUUU=
X-Originating-IP: [114.215.250.79]
X-CM-SenderInfo: h1dq6xdhqsiiqrrrjii6rwjhhfrp/xtbC9Rx-g2pDNBw0qQAA3J
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE29EA0008
X-Stat-Signature: xepj68xec64mw5hc8ytw9xi5jbph85wx
X-HE-Tag: 1782789190-797191
X-HE-Meta: U2FsdGVkX1+h1wHNyinQTK8IxeRKVJjswFjdSZjXKggQUSkac9o1dVZzIvLiehAoWJ+ljebH85aExwj6QPm8h1LIojbKGwEGOpfkbFBKpR4uS03FVAymzMpQw5MJJhkKmRIKpkjzEdDA87k4q5Wbyzjipy3pGXl+0vFDw7vxmbWjMyPXg3Vwc2ZoU9BrMx8JGTlG/sh0WVkOLUOXGsCuNIBo6MmXF3IU+FBKYrbq3oe0wFUW0mQIF2l9dsBe6K6zSXPWLSRUnp4V+4E/QBml9UP4uPdfQuo5811KKE0NWteZNgYxpG8pGruxVDmOBfV3zcE1ZTer5E5+Z+S2cvsesaBdsfF8ggqQbgTJAmr9KpV4miwEXSgt64i4MKTrK9VzMDe6F+HEanaBjn39E9p0peKCJ5DarDwYZw117TMNQDN3o6SBCxfSPi/rE9uUx349NIE5iAdGQTer6pVzDEroiQct3n0gNe3qIge4bswsevez1eUf32aAbVQZg1M/qsuJ9rcVM/iQPpm9daLhE7K0L4jtRSNPQNondVW77DGY0NMx3F8MPogx2HUhIfsUh58BaDuPLfXwBvMF6o9pi0wnyoljGw8oc/U/K16Pdpfg1/gsLxbP7Y/lu700ib9b+p3Q2fUw++uzBzWLynIRDbYMWJIT0Sb6/06s8zDqVOVkwa9dMUShojYrCP5wOO4tuP2TfYhonLaxFCDhneckCa6iWWoDEbRfaPsUTgyu3KdAIRiYpR92Cp/4gdqAsWJcBt813lRCfFX/RorjwU4motKHWSGnzJo0lgFKkZoqcFCBJrdgd940ON4w79jQtofXA3LZODopPSZ4TYL9+xBU1GS1/Q8B7wsRn2lv6v+BuBWkLCH8foRzLDCg4t7HjwQjb8965KHkg0ay5urRLQi5igV2ICTnJCuQpLuK8xmauCFKr4HjBLZJf3opHnTz+3Egql3UucNsGBvzuBM8Ev0tZip
 Z19C0xnp
 vVfh50CkKY8D2/Z+5Y6mF7yKu2JIQE5lA5drKZfxfUCeRxP3fe/gNOXOOe2jDUhpXHrYF3yiYut9BdMkNOG5v0LZTFvnl64K9yxBjvqs9Gs/L462yMwyW94uEe0B+qMyZ+aPU5+MsV2O6LkouJuxbFJRD9Q9crtn7iqAHKw2xDaFcPzy4S9r3UhJnMuAi5z5YEtYciaMy5sko+j/UZapg0VkVNoMIOMrovsoOrwhjm97XbARGRyoZu7BuTVCXqX0dksfhrnG4HGbkX3wedYBAsRKFXHzsj3MQXPRiY/POGGZlWdedtiPoOSK419xbAMDAfY82xjOwh/qamUGNUVpdpr1C3P+VhvLcEDLjV44i21kVFm4e82cEPEpxvpVXNKEo4NibCV3zcGQbaa+fIwoIFtsnTMZdkMkbsn8k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A local unprivileged process can create a shmem/tmpfs file with
i_size == LLONG_MAX using memfd_create() and fallocate().  If the last
page is present in the page cache, lseek(SEEK_HOLE) on that page
returns 0x8000000000000000 as a successful offset, which is LLONG_MIN
when stored in loff_t.

The same file has readable data at the last byte, but SEEK_DATA from
that offset returns ENXIO.

The overflow is in mapping_seek_hole_data():

  pos = round_up((u64)pos + 1, seek_size);

For the final page below LLONG_MAX, the next page boundary is
0x8000000000000000, which is then used as a signed file offset.

This violates the lseek() ABI for shmem/tmpfs: a successful seek
returns a negative offset, and SEEK_DATA can miss readable data at EOF.
Hole-aware copy, backup, and sparse-file scanners may skip the last
cached byte range.

Keep mapping_seek_hole_data() inside its documented [start, end)
search range by clamping the rounded-up position to end before passing
it to folio_seek_hole_data().

Signed-off-by: Zhen Yan <yanzhen20011121@163.com>
---
 mm/filemap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5af62e6abca5..22a1534ec8b3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3234,6 +3234,8 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,

 		seek_size = seek_folio_size(&xas, folio);
 		pos = round_up((u64)pos + 1, seek_size);
+		if (pos > end)
+			pos = end;
 		start = folio_seek_hole_data(&xas, mapping, folio, start, pos,
 				seek_data);
 		if (start < pos)
--
2.25.1

Sorry, my previous email may have been lost due to network
filtering issues.  Resending the revised patch with the
requested changes (tabs preserved, CCs added, signoff added).


