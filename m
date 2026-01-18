Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A628C98315
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 20:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DFF6B00CC; Sun, 18 Jan 2026 15:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216206B00CD; Sun, 18 Jan 2026 15:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118C96B00CE; Sun, 18 Jan 2026 15:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F17DF6B00CC
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:22:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FDE81405ED
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:22:33 +0000 (UTC)
X-FDA: 84346207386.24.CAE73D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D05ED40003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:22:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nCgsRnLq;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768767751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YG/ZvzDI4YmJcxXFvTakfeHCJC54j5Dr3AzCaXeQ488=;
	b=ZPF13I7HF9HZtZJNVlL8dJJqgQbyUOIhLEFVCMG1Hy6xiQsokY9nA3cUFjffBA3Sn7/NuU
	nbgoxo52t3sRk/xc7nWNAS7iTBfRiEqgrvo73w49XsjTPNCEUZ2Gvex+SKBJx8U2daLJQ+
	v4NXKO1v9g66s9a8N7d0Jzxnvgbf4xw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nCgsRnLq;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768767751; a=rsa-sha256;
	cv=none;
	b=7qpe7EUD870rPkR6L7ozE8ZUCTswURJI46233iHQj0D1gMPZLunlcnMzkCaZZtgY9uaY1u
	+8kUrw6uYJTRcR0K166+GC+8emkaqgyo2YiTZy6rTnkbFpY9BwlBcDSQLIlHZ1B40m7/yb
	nR3Cijbay6ilkf0WWMsuLy7NOUFYVEc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EB2B60010;
	Sun, 18 Jan 2026 20:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B90C116D0;
	Sun, 18 Jan 2026 20:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768767750;
	bh=q//pica3AV44Fm9PXUee/SluWTMEByJY6QRUAywAlkE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nCgsRnLqO8g7TvPco5FEGstL+Y46pSoIrNl48qQd0dfDSWANuOCldMzfDPc5N1juS
	 HFaFCXK8bj/3gaZwjhzxxZP5gKW0/QTa3JcBJuEVf5m8oVMVBX6/yXDeYq3pbufUwy
	 71f0awTl6zXtKym0wHM1FOXtE8WQ9PQ10y0vX/NA=
Date: Sun, 18 Jan 2026 12:22:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu
 <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 <linux-trace-kernel@vger.kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Zach O'Keefe <zokeefe@google.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Stephen Rothwell
 <sfr@canb.auug.org.au>
Subject: Re: [PATCH V5 0/2] mm/khugepaged: fix dirty page handling for
 MADV_COLLAPSE
Message-Id: <20260118122229.dcdda884bbb19a9c30ec6f1e@linux-foundation.org>
In-Reply-To: <20260118190939.8986-2-shivankg@amd.com>
References: <20260118190939.8986-2-shivankg@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D05ED40003
X-Stat-Signature: njtb9nygdko3r6ddcpo4s15sh56js1y4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768767751-564243
X-HE-Meta: U2FsdGVkX19tyT3OlSM/0E0YZdr5Rq82c5awY/hMlxQAEpWu2eg/56kpsNxueLtXBown35OBcESqSFUCtlkaHbTODi4y0rZBNM6n3PcmlG8dDYf8mxGr5lpI+C+4xUv0GuiAgVLnBmSJkcdYELmY12de/pHJWpZOQ94S6ZJO9B2jb51/lzCdJZZM32lO/QgQW5o/fIsmWrfq+C/u+jsfevUGyPwBLfPX6y6vAqdwmuQ/PycJjI65R4Ay0ryODIFa7DVrS9KCVbjUHgclmmJS0YZi5ptLixJAx3Ebh+zWmstFI6rhnkuxLEE2SKKgtfXqePk8X9Nb/f9J12hP2NvwXllngIBwV2j1MXVad9Ouh3AHidKKyaJ8Lm1BMsssU56VQS8BKiHFDXYyeEXl3rVfMZdCfawZ4ElDIHB1eMX738gzch5QMW3bjic7vXuDH23XmVUBdTDNDc5NsHUWPSWj9BTpBCHzuJGa33a9r1TDUyqvaFaGggQxl8l5BndlioTtKgt7+72UaLbn7axRSeEsvfnRHNcbP1iPNJOY6TCBylMPGygJsO/HzwEpB/WMlYDO4bgs7pe3Ue18aPPfxBm2B7YJRZiQgKS0nzeCdcg1+kHPdqzWuZxAEhm3I1FTCS/23pP+m6osDR4aG5RFPIHjthAIal+sj26MdIYSuO2d1sli5jpfSKzW1s0LI5XSVJqupweuUIR4xcclO988jBsFnZzwtjFsrxsF2j2DcMgEMaAutkB6uwTDjmgfhUAQUNM1dUbwB/smkG3gT8ocmTW07kvIQfprcHM72IadWnKNan1P2FbOJrGq29ej1NOCmlXat7bGSNP5u+chnNur2zUDQHecAkklIB52rHX2XP1sVWOpJ3+uJOd+KwcfLYEx66nIlx5bW/Lt+VzHdvqcAlngV4SBJYxz1u9mQEsp9pl53Ei3t0eAdWlcMtcO2GACKwpcWb8jB2NofXu40r4ozkG
 cUUb7GS6
 fWyWnzqMUYrnMu+A05Edmn6pxwgtI6/PLrdZXMC6sJyBMscVHqQJDt6Qwu2FihvsWC/20oaRK+tip6lRxvdI0V3FPMCthFGqsNkGZ3qYhwv44MXH00/JVzprFljv01ZSHzgnobjvv6N2C3TqMj7L3TqCLQda2xe/uU6FXrO79wjNtPIHpb4i7q9TssTEw+VhNYaW+sw10P8BfJP3Hsy7TrYKy/xhAu49hHRBXRp9L2MQemilZULik+hKXiD8U9FwZsCcx9XiWwmpOnxPrSdHsWIqAl4rxWbU6zlaSmswkQgXvwuEwPkDh8kOysB1x4A6IW9C8C/yRuFCR7ZTkHhSPXP+Dmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Jan 2026 19:09:38 +0000 Shivank Garg <shivankg@amd.com> wrote:

> MADV_COLLAPSE on file-backed mappings fails with -EINVAL when TEXT pages
> are dirty. This affects scenarios like package/container updates or
> executing binaries immediately after writing them, etc.
> 
> The issue is that collapse_file() triggers async writeback and returns
> SCAN_FAIL (maps to -EINVAL), expecting khugepaged to revisit later. But
> MADV_COLLAPSE is synchronous and userspace expects immediate success or
> a clear retry signal.
> 
> Reproduction:
>  - Compile or copy 2MB-aligned executable to XFS/ext4 FS
>  - Call MADV_COLLAPSE on .text section
>  - First call fails with -EINVAL (text pages dirty from copy)
>  - Second call succeeds (async writeback completed)
> 
> Issue Report:
> https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com

Updated, thanks.

Please tolerate a little whining about the timeliess here.  We're at
-rc6, v4 was added to mm.git over a month ago, had quite a lot of
review, this is very close to being moved into the mm-stable branch and now
we get v5.  Argh.

> V5:
> - In patch 2/2, Simplify dirty writeback retry logic (David)

Are you sure this is the only change?  It looks like a lot for a
simplification and I'm wondering if we should retain the v4 series and
defer a simplification for separate consideration during the next
cycle.

Below is how this updated altered mm.git.  Could reviewers please check
this fairly soon?


--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -2788,11 +2788,11 @@ int madvise_collapse(struct vm_area_stru
 	hend = end & HPAGE_PMD_MASK;
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		bool retried = false;
 		int result = SCAN_FAIL;
+		bool triggered_wb = false;
 
-		if (!mmap_locked) {
 retry:
+		if (!mmap_locked) {
 			cond_resched();
 			mmap_read_lock(mm);
 			mmap_locked = true;
@@ -2812,52 +2812,27 @@ retry:
 
 			mmap_read_unlock(mm);
 			mmap_locked = false;
+			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
 							  cc);
-			fput(file);
-		} else {
-			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
-		}
-		if (!mmap_locked)
-			*lock_dropped = true;
-
-		/*
-		 * If the file-backed VMA has dirty pages, the scan triggers
-		 * async writeback and returns SCAN_PAGE_DIRTY_OR_WRITEBACK.
-		 * Since MADV_COLLAPSE is sync, we force sync writeback and
-		 * retry once.
-		 */
-		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !retried) {
-			/*
-			 * File scan drops the lock. We must re-acquire it to
-			 * safely inspect the VMA and hold the file reference.
-			 */
-			if (!mmap_locked) {
-				cond_resched();
-				mmap_read_lock(mm);
-				mmap_locked = true;
-				result = hugepage_vma_revalidate(mm, addr, false, &vma, cc);
-				if (result != SCAN_SUCCEED)
-					goto handle_result;
-			}
 
-			if (!vma_is_anonymous(vma) && vma->vm_file &&
-			    mapping_can_writeback(vma->vm_file->f_mapping)) {
-				struct file *file = get_file(vma->vm_file);
-				pgoff_t pgoff = linear_page_index(vma, addr);
+			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
+			    mapping_can_writeback(file->f_mapping)) {
 				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
 
-				mmap_read_unlock(mm);
-				mmap_locked = false;
-				*lock_dropped = true;
 				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+				triggered_wb = true;
 				fput(file);
-				retried = true;
 				goto retry;
 			}
+			fput(file);
+		} else {
+			result = hpage_collapse_scan_pmd(mm, vma, addr,
+							 &mmap_locked, cc);
 		}
+		if (!mmap_locked)
+			*lock_dropped = true;
 
 handle_result:
 		switch (result) {
_


