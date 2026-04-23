Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCB3CF99352
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 08:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE1F6B0005; Thu, 23 Apr 2026 04:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368346B008A; Thu, 23 Apr 2026 04:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255BD6B008C; Thu, 23 Apr 2026 04:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10CF66B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:31:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A992AA03C3
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:31:20 +0000 (UTC)
X-FDA: 84689151120.19.EE1BD8B
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90CC4180014
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:31:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bE5bcvvO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776933079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YwT2J6y8VB+nAR+GUBhFBsu9Q8obY1raNP6TplLRG0=;
	b=pGkn3FmihcBpo8qpyW6RaM7lclbAI3a8CDQfe0vSabnajucsLRsXlM+4OgQdURvF/d7I/U
	bQZ3TkmPzcF1mTD3OFfG8bkrmjSfESTajKuCyQgT6NaKcQcc2whLeZWAwd6UXyUUi3t15C
	FXtECE03CBWwdV6pLlmOrddGE+7GrZ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bE5bcvvO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776933079; a=rsa-sha256;
	cv=none;
	b=OYLqTboVT7IDvbvNIMZUlmsjjTwRgmjYl8+dWPVnClTqMTQWNCCvTUpyJy3z9r6GimJrl5
	UkN9O4W3/wZ+yDrUrnpuetikSDdN++KrPjY0OTxc8MOKdB4mOYOwR6tsO/lr4jj9H9m8Wl
	4nBRmVGEPFDIzfOOC5dET6GzTMhJ+y0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776933076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8YwT2J6y8VB+nAR+GUBhFBsu9Q8obY1raNP6TplLRG0=;
	b=bE5bcvvOtZaF4jMACv4gJWXGy9pHyr8ZxjVjWFRr+w6XlHcOtheOUgxbQgLv+svPUFqb4T
	GokyuelKSqLfKOt2rGQAUf3T4tMyRE7867WB0u62bDlpEYJXjKkepMxOSQNZFnhG3YNhsv
	dANjm0XSetWNnKHvHhvfdfBZT807gF4=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
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
Subject: Re: [PATCH 7.2 v3 02/12] mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Thu, 23 Apr 2026 16:30:50 +0800
Message-Id: <20260423083050.68509-1-lance.yang@linux.dev>
In-Reply-To: <20260418024429.4055056-3-ziy@nvidia.com>
References: <20260418024429.4055056-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90CC4180014
X-Stat-Signature: cfnbnnyewu466y6kpc4yxkxksjq5sohc
X-HE-Tag: 1776933078-196848
X-HE-Meta: U2FsdGVkX1+aZl7DMeNd6OlaSYIIZlbJPgAjgQVrL6ef5+6Hrs4lrdPy/VV2ZIXC+RUchMxDDC4Q7lkKqC4b7EW0CwWns0JKbNRMScZfOdw4Zo1xv3XtRjB50spqadZzDJLHwf5vq1cR3esyiGPJcGI9ZmqtnkU5P4aNDyL6XBDpNB1CFRl0dqjd9tLdxUt3O4i9lOdl/Lz8QBc3jiLIJq5AcJtD4tB7AU0YQCaUdmwFzoZup+cCpQOHRxUuyHlOGpr6VoUSR+OBnmH9IHxg+nAbfBDRpJFNSxEW+Y6tb3X61eXHSFMZ2BYQjy+S/dLqDdPvElkpLCDtLHBuRjBdc/lHwxAVVzqXs6lrfNrRHm45gUrA1GkiOXkSzNkgLCDfbtz6+qKFg5ONBg5gZkkIU9z7u29tH/kyOTGXdQouM67dA7lR7BXHZg0u3p4oNaWf02G05R7YNBQLr4ITidkIP3oCPqktdMfK3/bgbyk3dE1x9e2wGTA4v3u3Zw1vMBan8ExRr5du2DekUOFZwhRQXz8aXyVSPUvzv7IdQPpBZo/wg/OGE31ygCgUBkyYb5b7by5xwSbRwIl4VGrYl/eaauqgQM0Dn3VhHXr/mryWOuuR6nkaGoTUeycwc1pmKZbrT8KrcJDz+/chfcUnX7Y0dZjqUj0IvJw/9iwDsMDAeUGf3c9dp0x/RvUfihUKIpWw6kMp4k4Sl9+5i3Qt5ElTdTdQ4bzdf61+qs7hCfZrxL+P/Rp4thO9eLeFvh20KCKFjzIsKA9p8IGTgBt0V6mFloIg9RqmLJZvRLsXq2tK2MhjRKSEJUvqc0y9lvDVqigi2HPpHALtZsf3F6VAWPgclyTmomgs1fhWYyr3yYH/dhuJPot/u4NYzN2iV4EMGLhZaRRAhvnH33c30+pceCgdAx200HejdpJmLuG103Y2F05axYa4qwYARtu4DP+V1jKCw3LYjLFgBhwJu/JS6Y6
 5WMxECMj
 uMkZh4AWOaIr6dOQH9348ZAPIerqRyVTNatu+4+VLPPskMPHCSoQUXuNoXH6GsQVITDcEUiqUh/05xvuPU621oy6v9IrnFolW7N7NfR1HMFCFbeZWnZi+IMXovWf/++y7Zn269Vs6qFFFirLRzrA+0qwCj0TwDIcd7MywGm0FaVHdtUzPb+Qb3vB1OcfCOiHYT9noqivy6NYwShbKh2ctilpsrDQm+RqAtMbUvquiJ4O6lsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Apr 17, 2026 at 10:44:19PM -0400, Zi Yan wrote:
>This check ensures the correctness of collapse read-only THPs for FSes
>after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
>PMD THP pagecache.
>
>READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
>and inode->i_writecount to prevent any write to read-only to-be-collapsed
>folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
>aforementioned mechanism will go away too. To ensure khugepaged functions
>as expected after the changes, skip if any folio is dirty after
>try_to_unmap(), since a dirty folio means this read-only folio
>got some writes via mmap can happen between try_to_unmap() and
>try_to_unmap_flush() via cached TLB entries and khugepaged does not support
>writable pagecache folio collapse yet.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/khugepaged.c | 25 +++++++++++++++++++++----
> 1 file changed, 21 insertions(+), 4 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 3eb5d982d3d3..1c0fdc81d276 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1979,8 +1979,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 				}
> 			} else if (folio_test_dirty(folio)) {
> 				/*
>-				 * khugepaged only works on read-only fd,
>-				 * so this page is dirty because it hasn't
>+				 * This page is dirty because it hasn't
> 				 * been flushed since first write. There
> 				 * won't be new dirty pages.
> 				 *
>@@ -2038,8 +2037,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 		if (!is_shmem && (folio_test_dirty(folio) ||
> 				  folio_test_writeback(folio))) {
> 			/*
>-			 * khugepaged only works on read-only fd, so this
>-			 * folio is dirty because it hasn't been flushed
>+			 * khugepaged only works on clean file-backed folios,
>+			 * so this folio is dirty because it hasn't been flushed
> 			 * since first write.
> 			 */
> 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>@@ -2083,6 +2082,24 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 			goto out_unlock;
> 		}
> 
>+		/*
>+		 * At this point, the folio is locked, unmapped. Make sure the
>+		 * folio is clean, so that no one else is able to write to it,
>+		 * since that would require taking the folio lock first.
>+		 * Otherwise that means the folio was pointed by a dirty PTE and
>+		 * some CPU might have a valid TLB entry with dirty bit set
>+		 * still pointing to this folio and writes can happen without
>+		 * causing a page table walk and folio lock acquisition before
>+		 * the try_to_unmap_flush() below is done. After the collapse,
>+		 * file-backed folio is not set as dirty and can be discarded
>+		 * before any new write marks the folio dirty, causing data
>+		 * corruption.
>+		 */
>+		if (!is_shmem && folio_test_dirty(folio)) {
>+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>+			goto out_unlock;

Looks buggy :)

This runs after folio_isolate_lru() and after xas_lock_irq(&xas) ...

If not missing something, "goto out_unlock" would leave the xarray lock
held and the folio off the LRU :)

Note that the block right above does call xas_unlock_irq(&xas), and it
also does call folio_putback_lru(folio):

---8<---
		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
			result = SCAN_PAGE_COUNT;
			xas_unlock_irq(&xas);     <-
			folio_putback_lru(folio); <-
			goto out_unlock;
		}
---

So we should follow the same cleanup as that block here, right?

