Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0DB4D3EE72
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1E16B020E; Thu, 22 Jan 2026 10:19:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99CC26B0213; Thu, 22 Jan 2026 10:19:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881BD6B0246; Thu, 22 Jan 2026 10:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6473A6B020E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:19:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FA3A14042A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:19:04 +0000 (UTC)
X-FDA: 84359957808.20.6E8DB66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5CE18100011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:19:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZX7P+4UF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769095142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qw3TV9M0z7w+/42jDLfF625zQqC7LBcHteau685r7nw=;
	b=HYZlqiGFRhKmRFv8h/cTfpecBoGck9D1lziWjlD2UdRSnj0a9C3wxQF5QhYDWj6JbJQkON
	GPr4E5AtVX1HuOBVB2I5R+IS8b9dmJLRqX1CglCcCCCWMc9cifvFkD0py9snKJytdmohg4
	7RF9eRstq77ifeVgvNkvF4/bkbvWDkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769095142; a=rsa-sha256;
	cv=none;
	b=dDXagytTToAtXyLGX0PDLcmC7erZISBBeoMyERP01eSFyKJHFmllZQGn90M+eCbHznrtGV
	a56VGWopfWV2tdxkgytu4C3EBXaKDzngtuVi1BsNcQUZpRSozSWAiJEa9oIVbGVU1e1PS/
	Wdla+1NCYNEcrWYo4/+C8KM1raaufaI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZX7P+4UF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D9E444161;
	Thu, 22 Jan 2026 15:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA89BC116C6;
	Thu, 22 Jan 2026 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769095141;
	bh=YLJlkAxZgahTe6DNHbxTJdYXwUdyk5vxfIME+2fG3k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZX7P+4UF9IYUrVIBMSwkZXOxFg4C4bYpv88wdSwsODGZatPaTAAHNDBjQn/qZX4N8
	 13Gtn9SyiPwYl0ljdV4idd1buk9vvd1oFf2hYK+tledpfTNbEMF2CpZh9bVBNMRz0F
	 qEHoKrhq7mSwWDSXkyDEgEyPBHOGJMAVEVS3iDtik76/OupwBO6vfgcm1bRoINpkKv
	 TKi5Ty3kvB4cl4zeyEGirEK77KJjMR1oSpVcws0tbAhnoOZu07x/2sCprKQ/Dugdt3
	 dJRyQg/FLVKexjSgiDRpxH1tWzst5yL7b3nYixzKI+QqCu0RbX05n82FWjbqFHgkMI
	 SoxcYB7hYnDsw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm: memfd_luo: use memfd_alloc_file() instead of shmem_file_setup()
Date: Thu, 22 Jan 2026 16:18:40 +0100
Message-ID: <20260122151842.4069702-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260122151842.4069702-1-pratyush@kernel.org>
References: <20260122151842.4069702-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5CE18100011
X-Stat-Signature: u4skzcc7zfagp8469q6un8i68sor35b1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769095142-810669
X-HE-Meta: U2FsdGVkX1/YEkzDRAJHlmh6+gOO7ozITsw/Gcf0qe79lbGr3CXGK5HdIbuvJqw8gl7p/2v9PCcBy5naC1xZjqb8bdnFg1BRMwC+xadh8Esudd3efPJJbSPPPmR7Zc0+gOAbFSwTzue+CRCWNqlE6haQzI/gO6lZIa8JIknZa4F4uaFGqQr4ccQN7tuaNLcwIKTXWX0jmmHyxgc5VqcnZG8nYoj0W5hn5XAqifoUhuWYnvQ3Ty69z7iS0Hqy5HLC0K9iw/6ZPpcBl2oEYghQT21drx4WX3JC/Miy2pSeVFfedAj+SzQCXUnxMuo6dLg1Flpj6r+25jyksEJwSale59EYZJU6gf+/AprOidO1xbPTm6L9CYo/yKGQT+3mIy+MCP/39UcGyF5uwTfFDCwvqSEv8AbjNxnt16iD0/fTSXQHlxY5yIirHce2gSTVM1AnHxgfIL6UFU7ysLZy4ptaVFOVYXsBApCzxWKU+xG7ZUQxWWybHCAjA+w3bFT45oJoH8drATgdeA66+PV/ADoOG3/sOv1LsCn3UwdehfE5xqs8Eko4XJ/kgVHWzH6Q2t4Hk9tC+sttxNPP0fBqlchdNx4zXBpghjAig4FlBTBzWm2KjKZjaEYFe5Z5JV17vjCzcIUk2np17d400O7MiatJNCC7i9keo1OZQEp3uZ/gMhitwMmZXiNoQ1pkFYb3ZpRXGaEXEdGbIOSfXUq6eb2GbhYzLmj/f0MSId2YRxvGcLH98L6mRvFgelC3KT5CI58gmAmerizhaHXpNtSig1wHW5H09di5O5Dg/pOA1w/40Pn72Zf8V+E9hqPnLSSslUM4teY5jHwED16o5Ad8uho2OHr08OK9Bjl6uCDU/ImHU453WYCnP0Gay8P98J6PqoFBxmTOw5qBNHW/WT12yK3LvIQjtUJGlUW1/ELy4MR369Vf+Th8Eiqhf7WgrBMTVhabOC0SIWxtDVGeTln0At/
 v19H+acm
 3xLa0hoChDmaH6LKAbtOvz0QNB7ygfhBS9S3GWk8B0KhI74Y3OnQa9bfZ8CALFCR/rBJkuoeU58FP2h2p5wV/maNBOHhjOo5qhcsXiS+9ZJ+6ahN9q4DtdKwb/eDgtGN14l8qkZU6ZATRLFqgNyrUhy8s0B7+20AaBTqfv2PKaTFHfLK5q+AOwdw6ZGEqRrzOcaGmdajwbqRRrcgwEXbmVON3T4nfFl2l+H1vDAmt6J8JbadD8S3mtlsD9vJogJVeQwu2ef2A9UlqZcLHplGDNXFlouzCjyaxxzBc9DQi4nqSARcg6Un/FMsQXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

When restoring a memfd, the file is created using shmem_file_setup().
While memfd creation also calls this function to get the file, it also
does other things:

  1. The O_LARGEFILE flag is set on the file. If this is not done,
  writes on the memfd exceeding 2 GiB fail.

  2. FMODE_LSEEK, FMODE_PREAD, and FMODE_PWRITE are set on the file.
  This makes sure the file is seekable and can be used with pread() and
  pwrite().

  3. Initializes the security field for the inode and makes sure that
  inode creation is permitted by the security module.

Currently, none of those things are done. This means writes above 2 GiB
fail, pread(), and pwrite() fail, and so on. lseek() happens to work
because file_init_path() sets it because shmem defines fop->llseek.

Fix this by using memfd_alloc_file() to get the file to make sure the
initialization sequence for normal and preserved memfd is the same.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memfd_luo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 4f6ba63b4310..01a72e4d3ef6 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -78,6 +78,7 @@
 #include <linux/liveupdate.h>
 #include <linux/shmem_fs.h>
 #include <linux/vmalloc.h>
+#include <linux/memfd.h>
 #include "internal.h"
 
 static int memfd_luo_preserve_folios(struct file *file,
@@ -443,8 +444,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
-	file = shmem_file_setup("", 0, VM_NORESERVE);
-
+	file = memfd_alloc_file("", 0);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
 		return PTR_ERR(file);
-- 
2.52.0.457.g6b5491de43-goog


