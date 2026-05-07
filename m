Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D0D4CD342C
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 04:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24BD56B0088; Thu,  7 May 2026 00:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202256B008A; Thu,  7 May 2026 00:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112C06B008C; Thu,  7 May 2026 00:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 013806B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 00:50:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 980721A03E3
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:50:03 +0000 (UTC)
X-FDA: 84739396686.25.B3E8B14
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id C8579C0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:50:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BQd+lmXA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778129402; a=rsa-sha256;
	cv=none;
	b=8NiyQeIjMbFMIeWg2vN3oDGYC+9Q0gLeMInQ2c7aJ2YRAczdSdvtTV1haNAhc2mEseH9zD
	pGrwlphMOLs9ZBbJ6kA6jBQSCH5Apl7kz7Zih8LqyUcmcnTtvmRijKokDj40YvosEYg8bI
	f1kOSnIuyapIANIpsC8Msykx+7daCLE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BQd+lmXA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778129402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T92lbeSuDJF7TOb0l3mnZYGDplRGv4RFUXtmKR9fQi8=;
	b=b2b8Ss9Z1eg1l59UjWs0ntGU0pvtCYS6JUfzXaO7xQhthk5Dg6ZiTThy7JuI9lqD8rMb3I
	661VvY6ZY1KHyz26h0BNpzwkUyuVYW05N5dIr+ye1oak68pWWL5p2FY22ahI2qBFX/F+EH
	wvnYN8HANCAYHmRi78vB9sjhjCe1fGk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778129399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T92lbeSuDJF7TOb0l3mnZYGDplRGv4RFUXtmKR9fQi8=;
	b=BQd+lmXA/f8WxjtF/4MvcydOiZ2rTKsUXYuNzKxVCyqK0llXG8SamTlt4wBud+vNOjd6jY
	DeEajAO4982nOxFQgRyaNturbsK3JjGj9nIf8/wzzwGBS1WHqsGdMgEwwa6AQrffAnCajT
	exWHhM88xlcXdwqUY8+G+f2BslZyrZI=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com,
	akpm@linux-foundation.org
Cc: david@kernel.org,
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
Subject: Re: [PATCH v5 04/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
Date: Thu,  7 May 2026 12:49:38 +0800
Message-Id: <20260507044938.12529-1-lance.yang@linux.dev>
In-Reply-To: <20260429152924.727124-5-ziy@nvidia.com>
References: <20260429152924.727124-5-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: h9iqakmchy5ka4a5y4isumwbr1xf4kqt
X-Rspam-User: 
X-Rspamd-Queue-Id: C8579C0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778129401-978020
X-HE-Meta: U2FsdGVkX1+R9OOkiB7Fls7AKc9ceAx37ssJlmy901z40BIOtu/jKUMzSJdm20xHmCuiC5IExImWMSExCZYN6bruaxmT3WEIehpgQRXlszLky0d0hoomDSil/Jao0w8kcPMo++7GLDqKWc43JLQTLMHQwidRThXDZsyhE0Lyv5UHdS589h2T+a0UoeD86qqRNM0dKiKJJHAl7jkodAlKQG1+MW7EdX2DNglS/Sn0tWMeevcdEPtYcH1JiyYBnxQktZZdTx3PTfuwXVZ7OrHAV+u9QCw2LW9fZv0U+KLZ9A7bFzFvfgxI6fYLCpaYoWL5aJtUJRQB5jMueXgk9Pn3KSfRR2jMcFMN3q8v+KFDxnUUb7phn8pbPNwZsghsrLidLlBeyxh5aHgf8xdU31jhFtYPlx6GE/epyHx6BTxVHdi0qkC5WIaD6VVVWbj25vTJzLPtZvryvbrR6ji5HjG32UHk7r3xVnNBtyIU9ND6TxDqzNJXs9OCnVGAlCL/Vp/4kPOIW02XwzfnEzMUvert2qzGtoSRtnUV5WB1LcUP85SR2R3zwzfPLE4ib/c4CWIMgQ2x1D2TGsr14YxzWqGvoxN8ZYFIAQEOWew2kw+P33cmEcQGCGb6VP7EOQEilTGSEyqSEIWZEWrlqlxrj36MM6Q9qgP7fYv3aKHoQNMsWGyWki3UxDvcraE3YVuoJMidrHC+OhaCeQhNzqeeN0rKnofw9VshhB55KoUVjhooULjhYuisr5/51RnPGAYl+V7Ytekue8F8N5LcdQX97IIwmbtZ/iOU+5UDoALg5tlkru5r9mExsjmwaeCl20QPvQgP3Imenf/k09ez+l/UbTDp0mtPWzM15NP1ssKq1mYRN6zwi25kg83G1o2NSAM8tr9rMc0t5yON7mQI/PFNn4xNH7YEuduKhkNJPrEl79yn7tggYdAS0mxxdKMvrgv8t4CiIbHSGIMwP6f+3RQcn2a
 miusc+jN
 Jy9c56pG+Wp1gNg/mSZi2bvmN0TkHIbZrMhftzqbHKI0VDPDD4MPoD3iVDxcaYAAwLQHSIbjvbKBsWy8T9BX4soXN8558n4pLoGLZl5vuM4P4NCND6q78FKL+6Jv+Jy9Zq5Ya6a4VkVzFbVRkDOXLNlS2Ak7RL+2IoqH3gVSTiUuGRD+ifc2yxeaKRq42u1H3Ak3wH61EsRvMR10gw0pP3Yxcjh/2ppVMt4AjHWSVCXjCwLZV7g56Fsn6BDW15wezIaAi4ys9b0XNKfxHnPeQAJ7iZd0JRf/Vw92ocTOEeB31jVmx96PLyRffTk9GXgS+6oWRwoaZc1VI0II=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

I just noticed that mm-new commit 83f151d1f7e3[1] links to this patch:

Link: https://lore.kernel.org/20260429152924.727124-5-ziy@nvidia.com

but the applied commit only has the include/linux/shmem_fs.h hunk ...
The mm/khugepaged.c hunk seems missing. Was this dropped unintentionally?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-new&id=83f151d1f7e3429100d148fbafc65203294e9f90

Thanks, Lance

On Wed, Apr 29, 2026 at 11:29:14AM -0400, Zi Yan wrote:
>Remove the READ_ONLY_THP_FOR_FS gate and khugepaged for file-backed
>pmd-sized hugepages are enabled by the global transparent hugepage control.
>khugepaged can still be enabled by per-size control for anon and shmem when
>the global control is off.
>
>Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
>IS_ENABLED(SHMEM) in hugepage_enabled().
>
>Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> include/linux/shmem_fs.h |  2 +-
> mm/khugepaged.c          | 26 ++++++++++++++++----------
> 2 files changed, 17 insertions(+), 11 deletions(-)
>
>diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>index 93a0ba872ebe0..acb8dd961b45c 100644
>--- a/include/linux/shmem_fs.h
>+++ b/include/linux/shmem_fs.h
>@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
> int shmem_unuse(unsigned int type);
> 
>-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
> unsigned long shmem_allowable_huge_orders(struct inode *inode,
> 				struct vm_area_struct *vma, pgoff_t index,
> 				loff_t write_end, bool shmem_huge_force);
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 71209a72195ab..d6971ada8f199 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -524,26 +524,32 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
> 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> }
> 
>+static inline bool anon_hpage_enabled(void)
>+{
>+	if (READ_ONCE(huge_anon_orders_always))
>+		return true;
>+	if (READ_ONCE(huge_anon_orders_madvise))
>+		return true;
>+	if (READ_ONCE(huge_anon_orders_inherit) &&
>+	    hugepage_global_enabled())
>+		return true;
>+	return false;
>+}
>+
> static bool hugepage_enabled(void)
> {
> 	/*
> 	 * We cover the anon, shmem and the file-backed case here; file-backed
>-	 * hugepages, when configured in, are determined by the global control.
>+	 * hugepages are determined by the global control.
> 	 * Anon hugepages are determined by its per-size mTHP control.
> 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> 	 */
>-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>-	    hugepage_global_enabled())
>-		return true;
>-	if (READ_ONCE(huge_anon_orders_always))
>+	if (hugepage_global_enabled())
> 		return true;
>-	if (READ_ONCE(huge_anon_orders_madvise))
>-		return true;
>-	if (READ_ONCE(huge_anon_orders_inherit) &&
>-	    hugepage_global_enabled())
>+	if (anon_hpage_enabled())
> 		return true;
>-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>+	if (shmem_hpage_pmd_enabled())
> 		return true;
> 	return false;
> }
>-- 
>2.53.0
>
>

