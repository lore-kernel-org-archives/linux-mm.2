Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CFF9D6AAF6
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 17:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DFB6B0088; Thu,  2 Apr 2026 13:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60EA76B008A; Thu,  2 Apr 2026 13:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551086B0088; Thu,  2 Apr 2026 13:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 424796B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:54:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E26FFE1807
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:54:20 +0000 (UTC)
X-FDA: 84614365080.14.19A0B2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 569F740009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:54:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CWCGGADv;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CWCGGADv;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775152459; a=rsa-sha256;
	cv=none;
	b=cJJy5AJ5RAx0gmf+TWHqPhnK1A2WY0Pcu03QIzVgcyl93mPftDe+K1Es65KAtaTeeiLZTS
	Z6flfQP0/9MD3WaudA5hJyU5c+M1mmLu0bgbhHobnGfdXMTi5srWowRk5n4iilmIHToygo
	lZ9IBco1V3oeVFHZp7kIdRbodJyG0GY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775152459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUi0lJUVyUsDPEyUuUr8Ht8PnrT3PlD3PFopYNqmhnM=;
	b=F3TVDg9MFzDQsVBw7EUjNTegbLKAT+je++Dw4CVLTQUC0dbReOxf3JVMduT43k0iIYtLCL
	tcactMAn2mEYoEqBVknwtcF4p2zC5mywAEeg+Ijahp/AxjCyfdH9SmJSe+sLzOT4jF/P50
	BCQoEIWyS1MLjx9fJYq5EYWYL+uKVag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50DD343D71;
	Thu,  2 Apr 2026 17:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C29C116C6;
	Thu,  2 Apr 2026 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775152458;
	bh=ohA1vLaZYkMMUT2MxNiBsI1iR7gLzjDmahvd/sGiQgs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CWCGGADvtvRKN2WyO+UfdjqpjwayOjBtuRXAbw/bh2xZ5Se6sGj8zMiOafMSdWuvR
	 u7w7E0C9EduOGZ/bZc+9XF/6qveWEBuEJcp6/zLtWg8yoXTj4t6A8nOye8aldpy5/p
	 Y7u7HvO4mbIh8zcfOor0A5wZY1y1GbqKQRn9sbdU=
Date: Thu, 2 Apr 2026 10:54:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Chenghao Duan <duanchenghao@kylinos.cn>, pasha.tatashin@soleen.com,
 rppt@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 6/7] mm/memfd_luo: remove folio from page cache when
 accounting fails
Message-Id: <20260402105417.b495f2fbe9069caa19ea7b05@linux-foundation.org>
In-Reply-To: <2vxzzf3lfujq.fsf@kernel.org>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-7-duanchenghao@kylinos.cn>
	<2vxzzf3lfujq.fsf@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 569F740009
X-Stat-Signature: weo8s4ytf6jp6ma811durpgc5rrymssm
X-Rspam-User: 
X-HE-Tag: 1775152459-68785
X-HE-Meta: U2FsdGVkX1+DzG1TORLWHMtHpmmCxEf2T0wasoFJ1GwKcvh9XBv4T2UBdQFOh1R9ruiiMheyugFYhFPWTCyQiCwPe6wNwmrS6CNp99cmvf7BLV2f8ULHPbVT2mMUZ8qzUWkAGCNkzz7DWXP0KGfcfcujiVRg/bpgWaDsY3LC4tZKlu0k588Wi2f3iFgK6oivZEwd4IZJKEGYQnbT68g3ZKxKC/e6iBr13TZUJ8cdoxk0c79FtsrldYWbk1x/BJO7Z97WYuNK2B1BpbDIgWLwCb6LOoM0tYcqMOVXWxHY5gQ5TDYBDPSwshfd08gCmhkziNCUsxa1CZUObjffuh9inUnzp/K6+i4CcXa56dIc8SaHPLObw5zvoALzVVMh06djmiHftp9YT7CcY3ZgxYLYECTf52xIVVbA76rFJq6NmVjYbHUlWnZRkch0Y0S9z+lACQQcErv137walameFrQaW2kBwSLLd/WOowZhvrRWX4wDXlG4ft+mfZX2aafOUShnPAzqTNdPiwZiLkK+gq7s6W3LyobVHjMm5ScPj12nE9m3fCGmtmcNlQYz8JKTtnqy/z/XhTgqzs8smXMXpV2ALaBgfBHXElx/ifAMSAienMvHR9qayI+wcah5SGz9Rd99CVgresXhalomaBe8Qs/DfWcrVdic182dmdW+QpccUK12juziwpXHTQOmshQXf6aaT5m0+3ZrwE2/KumiKACnVXQgp2ap1jiJKlGAi0oXnIWja40EQUJyxUQ28wUn2tfOXezDfVggHbAFmjySI/2F+k1WV7xK/6w31krt/MysC8ZT5TdRnvLAoAHzTtqSK7cFhtQGikq/ZOjzhvDiGAoF8rXw4NFDasKg4JYjb5ngzqQ/lRAiPz36L/UQp7MT2VaZlD+6XujVkPsmXzMzszLY2PXDgvW1d2qeoF/drLryRHIekQWflskP89qVYAFr+p1+l5Gkr9G+T6nVjS1az/0
 9Ahs4K/s
 DwmSJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Apr 2026 11:52:57 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:

> So I think the commit message needs reworking. Perhaps something like
> the below:
>
> ...
>
> With that,
> 
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thanks, I did this:

From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: remove folio from page cache when accounting fails
Date: Thu, 26 Mar 2026 16:47:26 +0800

In memfd_luo_retrieve_folios(), when shmem_inode_acct_blocks() fails
after successfully adding the folio to the page cache, the code jumps
to unlock_folio without removing the folio from the page cache.

While the folio eventually will be freed when the file is released by
memfd_luo_retrieve(), it is a good idea to directly remove a folio that
was not fully added to the file.  This avoids the possibility of
accounting mismatches in shmem or filemap core.

Fix by adding a remove_from_cache label that calls
filemap_remove_folio() before unlocking, matching the error handling
pattern in shmem_alloc_and_add_folio().

This issue was identified by AI review:
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

[pratyush@kernel.org: changelog alterations]
  Link: https://lkml.kernel.org/r/2vxzzf3lfujq.fsf@kernel.org
Link: https://lkml.kernel.org/r/20260326084727.118437-7-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails
+++ a/mm/memfd_luo.c
@@ -461,7 +461,7 @@ static int memfd_luo_retrieve_folios(str
 		if (err) {
 			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
 			       i, npages, err);
-			goto unlock_folio;
+			goto remove_from_cache;
 		}
 
 		nr_added_pages += npages;
@@ -474,6 +474,8 @@ static int memfd_luo_retrieve_folios(str
 
 	return 0;
 
+remove_from_cache:
+	filemap_remove_folio(folio);
 unlock_folio:
 	folio_unlock(folio);
 	folio_put(folio);
_


