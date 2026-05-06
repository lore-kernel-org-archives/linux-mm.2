Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8023CD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 05:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AEC6B0005; Wed,  6 May 2026 01:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0BA66B0088; Wed,  6 May 2026 01:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21856B008A; Wed,  6 May 2026 01:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BFBD06B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:24:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E0A18CDC0
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:24:35 +0000 (UTC)
X-FDA: 84735854910.14.50F3582
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 85EAFA0002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:24:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b9UhZIT1;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778045073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1w2c8Ff4EBVaptmWDiNW5OHkzAexKcOkjAxIk43isM=;
	b=njbt7UlS7/wJZdGnb8adA91FdBdGiPWWHR6Ly7t/2onxc8wLhPj3AVsp/LfuINvsUN4lmZ
	Hmt7uoItH2K6smcWfKZIFWOhEB+wO8bwEpVK1ACUsyZKdniJbWjTLQwE/6uND9bgUswbC/
	6vk0Kx0fOXL5gtMLvA6zoDo7aa1zBM8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b9UhZIT1;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778045073; a=rsa-sha256;
	cv=none;
	b=UdA1TbTTqqK6c8pJy9PP/Vo5ck37egxhG1FC3Xu5sFgCPv+4RrFbzXLV9VUhFRZi3YpiEp
	y6D9mYhX89cmLRiZpPNvt6q8lfFNc2d5yUCvIZjOcqhpUGGX50WeOSFilE9tBgQIFh/hWR
	ROQbJljhVf5+wfeUrU+WPCpcRPwxays=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778045069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s1w2c8Ff4EBVaptmWDiNW5OHkzAexKcOkjAxIk43isM=;
	b=b9UhZIT1mho4iJRIe/NF0Wb22N6oKuFN0uCmJ90L+9ONYFTY/ERbctell74yYE4Bg3x2Km
	jVwm94U2l7uI56nzb3Vu1s3FTQ2JNxPBlIqnC2nJpohkb7saC3QqMYOLYWMRQ3vl9TZ0oV
	mPEz18rGt+0O+mTEvVaQ+SsgfULNh7w=
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
Subject: Re: [PATCH v5 02/14] mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Wed,  6 May 2026 13:23:57 +0800
Message-Id: <20260506052357.91716-1-lance.yang@linux.dev>
In-Reply-To: <20260429152924.727124-3-ziy@nvidia.com>
References: <20260429152924.727124-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uy7uzkz7o9j7481ogbsco84gwdg3kxmb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 85EAFA0002
X-Rspam-User: 
X-HE-Tag: 1778045071-46347
X-HE-Meta: U2FsdGVkX1+WpOuMMZnJdcywQg1LHAPxEn/Zg/GgVLX8Entt5gdT71mfymC24PeofJyxKxt7Jb+KPFDOjZr13Mxs4IWr0Jl5tkLq84v7+gNLtHT1ltAhN4Gcv/yGAncxu5E0NGoNoQzssVyzh56bAY8M1dUbcw7vB8jz+ZvWkwAyui770P0L2k6ipEM9Crv37JgxPApji8ct3/R3lNHdHc4+d7XEUCGJNjTlC9BYzIKOkWotJa4CKh9Y1juZjkw8qcnvpHSdBhFgS9KtBjJjh6vRHwW7CmJ8VIV9tew8mPwD9Ro/tqwvhOf4dDhjYGULyJ8kvLFW25hq0hsMZmOTg0K143W7Krsjj5HTW4DdFpNbzG3jZr7KIUauv2WTZnWRFEO9b6UgSuG3ZOiqkfitNHEhQd+cA8DwLMlLmMSe5HVrpKP6IyMjj6q/eGH1G1YBcww/xxy06SU+AL1PpCuy3nP0onZSM7DFi7molIModtMJNL93/jDZbFBlBf9aWMfdlkKv5VInFEl1JspuEjmHC8Mo6AtKgT+eOCDWTiUVRQKTs/wkIg4wB/QJjbMLJ9IVekUPYFLLVPIf8q9bPSTYbHGLdwKwrGm/xxW/PW+iaMb5kQI79tfzRQWkT/mRGKf+ySGdnuiD5rwlyTpUrXqBDeSUDl0x5nepjZy8b14z4+H5DVqDRXDFE0Fn4ZODsG0ZEwaI09wWqEpKQNEEWs3GVmHtIdVCs5MsDBSz4Mz9+CFDvVjamayukw8n7ORFR3HxRf2UypEeeB5ULJajkv+oO91IALTlVy3qnTcFsL8KJk/l7U0Ljrkp7QjBZ1XruzUN/LBnq6cV2gvEJdhoxfXBrwwxMLrsncQUtrDETjQOgWkI9zFbw2gqMnRDwrPPT/Q5ASe5lKsXEr4Y7yRH9lkJAsy4JGGmLu5u6peujIIgCpcaq3cfupY6fTR5ihjEY1+YMxsdDJRE12dbgyTm+dY
 sBCgxuCH
 BWyLatAiLf89pA46esVcdTtzQiHE1DXMfaA0cWl2bkGASm90mTw4JOmS98lwYMr0IUwXw19LSD2unbezOmrt+zkz8nhozEnPwk3FKIYTMGRJnetRQzDpPcm/JbDWivJskyz0aKebmVIoyTJvlg2cuzerapkfGqHxJURZtTcA/stEdwKHLvw9CPhzbpIRHuKj3yM9aPxSOg3ax4wky3CwyZPrP+E/cGKW5HuNoGSrmaSco2BBeVGuzbfOWET5FOL/r7LTcD4DXZ6FL1ohnLlRC+LKF4DxXaw+0u+GPUY7p2sf3IF1eXYjVOfWSpJr7UiSqAxgHk2qw3rrZTrxGK2oYLQGoWrmd3DPKJ0zEc62Pds1zkyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 11:29:12AM -0400, Zi Yan wrote:
>This check ensures the correctness of read-only PMD folio collapse
>after it is enabled for all FSes supporting PMD pagecache folios and
>replaces READ_ONLY_THP_FOR_FS.
>
>READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
>and inode->i_writecount to prevent any write to read-only to-be-collapsed
>folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
>aforementioned mechanism will go away too. To ensure khugepaged functions
>as expected after the changes, skip if any folio is dirty after
>try_to_unmap(), since a dirty folio at that point means this read-only
>folio can get writes between try_to_unmap() and try_to_unmap_flush() via
>cached TLB entries and khugepaged does not support writable pagecache folio
>collapse yet.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/khugepaged.c | 28 ++++++++++++++++++++++++----
> 1 file changed, 24 insertions(+), 4 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 6808f2b48d864..71209a72195ab 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2327,8 +2327,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 				}
> 			} else if (folio_test_dirty(folio)) {
> 				/*
>-				 * khugepaged only works on read-only fd,
>-				 * so this page is dirty because it hasn't
>+				 * This page is dirty because it hasn't
> 				 * been flushed since first write. There
> 				 * won't be new dirty pages.
> 				 *
>@@ -2386,8 +2385,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
>@@ -2431,6 +2430,27 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 			goto out_unlock;
> 		}
> 
>+		/*
>+		 * At this point, the folio is locked and unmapped. If the PTE
>+		 * was dirty, try_to_unmap() has transferred the dirty bit to
>+		 * the folio and we must not collapse it into a clean
>+		 * file-backed folio.
>+		 *
>+		 * If the folio is clean here, no one can write it until we
>+		 * drop the folio lock. A write through a stale TLB entry came
>+		 * from a clean PTE and must fault because the PTE has been
>+		 * cleared; the fault path has to take the folio lock before

Yeah, try_to_unmap_one() also already documents the required arch
guarantee for a clean cached TLB entry after the PTE is cleared.

			/*
			 * We clear the PTE but do not flush so potentially
			 * a remote CPU could still be writing to the folio.
			 * If the entry was previously clean then the
			 * architecture must guarantee that a clear->dirty
			 * transition on a cached TLB entry is written through
			 * and traps if the PTE is unmapped.
			 */

Lesson learned :)

>+		 * installing a writable mapping. Buffered write paths also
>+		 * have to take the folio lock before modifying file contents
>+		 * without a mapping, typically via write_begin_get_folio().
>+		 */
>+		if (!is_shmem && folio_test_dirty(folio)) {
>+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>+			xas_unlock_irq(&xas);
>+			folio_putback_lru(folio);
>+			goto out_unlock;
>+		}

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

