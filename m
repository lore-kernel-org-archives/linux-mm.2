Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756E1CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 07:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710556B010F; Fri,  8 May 2026 03:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C07F6B0110; Fri,  8 May 2026 03:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7206B0111; Fri,  8 May 2026 03:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 506816B010F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 03:47:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9B5E1C062B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:47:17 +0000 (UTC)
X-FDA: 84743472114.10.17E7C7E
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 991C840002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:47:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ewXSNaom;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778226436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ywAzvaNWn4c6wjdRn8PKJu6vnrjvK/OKJzqJA8I7cw=;
	b=DiGExEfbcuOa9W3WdU9zacpRuk55lRMmoxJzTUYqwAA9aO+D5kqfE3kq1UoRffwcgSSFUt
	KnCjkcfqVcTPRpYTwDsHpWTeXPkwrQnUmLV04FN3LvjtpaCs0C3D11PHksPnhf1G7PzW1O
	b65XvexEggtyj9ygXgg+EZ1cQWdu6nk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778226436; a=rsa-sha256;
	cv=none;
	b=gx8IvMJXmPR1/0v/c3E7IlcN/XAHVZqVcoUJDoxdV8HmGuTIueiD0ymBzN3XHnmDpd0Aaa
	TGMDpvJaax6ZKLXbyNgK/LhTN/tdUwYcvXnYLuQ1VOjW1qSWozjWVP5uX/+cC3bCONBjkJ
	KpV7OqZ+n/7DLtoEhdu+VWIQIxMvftk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ewXSNaom;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778226432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ywAzvaNWn4c6wjdRn8PKJu6vnrjvK/OKJzqJA8I7cw=;
	b=ewXSNaomo+/VRA3wetbuDv59SQT1taIzdio5CEahqiCz4zhct+/v18Re0BtsLAuGdvyGxE
	B9Fn3h+8B6UTstuCfEXlLMJbXwvumE7KhHFX9T9NMPrhp+T6aNglDmsxIgX9qKdcns2t91
	qQ3MG3ZjU2BcYoTu8TbBcS/+tTpXuTU=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 13/14] mm/khugepaged: enable clean pagecache folio collapse for writable files
Date: Fri,  8 May 2026 15:46:43 +0800
Message-Id: <20260508074643.55548-1-lance.yang@linux.dev>
In-Reply-To: <20260429153538.727855-9-ziy@nvidia.com>
References: <20260429153538.727855-9-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 991C840002
X-Stat-Signature: ydfaehj7656ctwwuazf5k6koa5bydefo
X-Rspam-User: 
X-HE-Tag: 1778226434-910906
X-HE-Meta: U2FsdGVkX193YafaJyH3FOZ5X/FTYdiZ8nmFBnU5vTHZZietz6iLlVvAMFMZi3iw+JuOHomQXUrufSZeFZkp7jckk6YoI+1OXQ9AeDOaneciYeoHgdpwLxz+XSDnfzCGNJ/k6VVxZRw/p1CTHeiOU0TofA9H81yl/OeyxzMzHZnD2JsBcKA35tuypdziOLdVpTq/XRZSk35+1w+mkKCGrJGGi4QebVkgenSBj+4/86jrii/wi/wqNx2EmP3jB4m8B0kyghCBlYD3eYzOZESvQ1MUdfCH4C8UVgXlKH5MPxRu6Uf3/E6MvJmivC6BHORmTHkgyUD6Z4Tv9YH1JEQaVnU/8iZfSRvYz41MYd2WNJKkemLXdINPivo48E5S89afcSv/APUDVJK1Z3XF9HlIpB0wuaPb62hoCyW395GwpyroU6abzbiOqqbRjW6lyRgcqgf5XP0scIdu8WaOSHA1k52ukPZEEpZ8mBqrKb6f3kP22ivJM6gokinvyfshlI5++eCQ3/hGLNv8pY2yXcvD3sU8u/aS8SxRLqN3Q9NVucyu/FFbDGeZ++Q9p28FcwzBFtQH0BF88yBpSDO27kYYvgDDgnpdXfuuQUOak0qjJwveCr8PwKx0HPnf7rJUyF5fwEG/E3al77gcp66AfOGDej96qrGR1525b4gGB7wLvnQx3RquxvaRbweBYu+F90JpBiMTNyVJOGllYVHofJVnuiGJJN7+DspaqiTY6Lt+prz7cJY0yOtFdFcKy5/zP7mire++jlcEEpJ+uLPSLK7ZkQ77Ti8thes/f4xSLkiSQDeip0dII4TpSXHRfjmZZxXga0k10m6f5xs1jD9lSrSnzL8SuCOe9FYde1EqesB8/UxNywCOA540cH2CDIpv3iqF2VO6tmkJPLBWeKaTIQPpqzKRnNmhdCFY5nmE4yKCFLfW5irSFMjJ47rT4S1Wfm2x1uLRLo4lSAfvoDJ05bf
 +imVLDPf
 /hQkA+9WsPt3q8qsDIt8bCrqjSK06VLd4TKm5cu+Fo2QRMsRwYesgGrbUjYtkCudU+vWDf1E2gzWVhxI9+XamPJgZUV7hAE8IAO9FzqGpRSEgo/L2Kb8fAmlQktOa0dOuINStcIxP9yCJALGxlFyDGNm8LFuEjZMJaPQCIZ4R6cMPjkRkesVbkm0F9juGobpm/39Agby0davEM8z1eWqyQpuaPIq9BGTKk0SAiA/aAGGiMg8GBRoHs4JKNz5J1Cr4+4BCSgL6INDDxcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 11:35:36AM -0400, Zi Yan wrote:
>collapse_file() is capable of collapsing pagecache folios from writable
>files to PMD folios. Now enable clean pagecache folio collapse in addition
>to read-only pagecache folio collapse by removing the
>inode_is_open_for_write() from file_thp_enabled() and only performing
>filemap_flush() if the file is read-only.
>
>This means userspace needs to explicitly flush the content of pagecache
>folios before khugepaged can collapse the folios, or use
>madvise(MADV_COLLAPSE), which does the flush in the retry. The reason is
>that blindly enabling dirty pagecache folio from writable files collapse
>makes khugepaged flush these folios all the time. It is undesirable to
>cause system level pagecache flushes.
>
>To properly support dirty pagecache folio collapse, filemap_flush() needs
>to be avoided. Potentially, merging associated buffer instead of dropping
>it with filemap_release_folio() might be needed.
>
>NOTE: this breaks khugepaged selftests for writable file pagecache
>collapse, which is set to fail all the time. The next commit fix it.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/huge_memory.c | 2 +-
> mm/khugepaged.c  | 9 ++++++++-
> 2 files changed, 9 insertions(+), 2 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 9b3abb98a7e51..e1e9d59db6e70 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -97,7 +97,7 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> 	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
> 		return false;
> 
>-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>+	return S_ISREG(inode->i_mode);
> }
> 
> /* If returns true, we are unable to access the VMA's folios. */
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 1ee15b48962a3..fb7ff643973cc 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2345,7 +2345,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 				 * forcing writeback in loop.
> 				 */

Nit: the comment above now looks stale. It still says:

"There won’t be new dirty pages."

That was true when file_thp_enabled() rejected writable-open files, but
not after this patch ;)

Otherwise, LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

> 				xas_unlock_irq(&xas);
>-				filemap_flush(mapping);
>+				/*
>+				 * Only flush for read-only files. Writable
>+				 * files can have their folios dirty at any
>+				 * time; blindly flushing them would cause
>+				 * undesirable system-wide writeback.
>+				 */
>+				if (!inode_is_open_for_write(mapping->host))
>+					filemap_flush(mapping);
> 				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> 				goto xa_unlocked;
> 			} else if (folio_test_writeback(folio)) {
>-- 
>2.53.0
>
>

