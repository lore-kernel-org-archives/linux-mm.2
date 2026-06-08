Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3803CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4399E6B0005; Mon,  8 Jun 2026 17:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA6E6B0088; Mon,  8 Jun 2026 17:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300126B008A; Mon,  8 Jun 2026 17:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 234D66B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:23:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCF901C1230
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:23:03 +0000 (UTC)
X-FDA: 84858020646.17.FB5DFEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 00CC1C0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:23:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DDsdTSA5;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780953782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5r8KYgeziJLoINJNNFem1kGIFqYvCyKRP4AgGvX1XNE=;
	b=KBct8v2SnFwld0QumcK6uVQqNswe6Ef9QiziceMYhmOhjmUhU82sH7Ma5dn8Dhrn+eJlNG
	DZQ6AfyKMZdP7Kuqlg6Wa+76uS4BrCtTltSVl7eS+jKCHoK+bioC1Exz3eUsrXWG5gEVmj
	rzUJm1q7qFfTQaRR8/UiOE3r22moDgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780953782;
	b=qHXS+e6HkvkmklNwgN0ZVzsMjah31ZBc6KcMbjyipNyVWdBy2aNUlpk1uSi8l6BPlNOKlm
	rbGRCxe6aFLCvOSKfKOR1f+uyt9L98BZDjRyyCseu0CLtjXdEa2XoF0NmOsxcSoIAgdhPz
	DXwu6dyYwnoXlpXIvVyk8M90rwSLUXQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DDsdTSA5;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D732140A67;
	Mon,  8 Jun 2026 21:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9D21F00893;
	Mon,  8 Jun 2026 21:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780953780;
	bh=5r8KYgeziJLoINJNNFem1kGIFqYvCyKRP4AgGvX1XNE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DDsdTSA5rUbZKCWNzLHJo7zF5CUdBD48WlZqNC1MGpV4T7hK/jsvhF/1sImwuRX8U
	 ZRT+67GqqjbhB9yzavNdqlt7SwU9Gs+Ped/8Nw2q/45UmjeW2PNiA1DxWxm37608IE
	 lukA8HrLwC1Dw3YqC1HYPDbyQv0GeVu8uB5VR9UI=
Date: Mon, 8 Jun 2026 14:22:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Smirnov <andrey.smirnov@siderolabs.com>
Cc: pasha.tatashin@soleen.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com, Thomas Gleixner
 <tglx@linutronix.de>, Thomas =?ISO-8859-1?Q?Wei=DFschuh?=
 <thomas.weissschuh@linutronix.de>, Andrei Vagin <avagin@gmail.com>, Andy
 Lutomirski <luto@kernel.org>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_table_check: do not track special (PFN-mapped)
 PTEs
Message-Id: <20260608142258.5028187b1d245b46554eb2dc@linux-foundation.org>
In-Reply-To: <20260608155758.1220420-1-andrey.smirnov@siderolabs.com>
References: <20260608155758.1220420-1-andrey.smirnov@siderolabs.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00CC1C0008
X-Stat-Signature: dparmrr5ra364n6smjzg1t98ig7nr8gg
X-HE-Tag: 1780953781-267444
X-HE-Meta: U2FsdGVkX18NZBAP57lO+XRcgqgWfNd134biCfAQ7yScVJuhsUfWnr+Xk+0Z3V17sLG+9jEj3JY7L8wNArSXXPls8W74S0/2vGGOmSGNJ5IVVOFA3os0Kc1U/xtRjuX7zO0c/+q6XtY5bRjN38SJzqLA9tZBzdoAPqEdygB1z7a7tHb9DNEOP8nYiod2ZMwNC1lMKB2aIksievi2t6Ulwm8T9yhLTTlRG3mDT9b7zwdSZD0SaRzGmstbkL74SbI0e0Ch9XUuoHwoetLjjnXtZoZ0GHomQYOwqCLFemioccBSFbeAg4BpOTRzob2rTG7+c5PhvIRAL+9EGXpmb4urPSM0V6QxODrtt1gQ3eBicimx6Z9AAPNySmYBvBKzl/kwGw5Gv350f9zoMrXxePIFc9+TZfIG+JBxDBgGbOa3SZSxcOVnf8MFCFh+CLbE3j8tUW7ioEZjzCTMXG9INjuxf8oLRqhkC6V9ZUm6U0Q8Yfvg9v42pfaBIGXObE8KDp9h7efo2rAZQEnuxjMZWNlOf2S7Oi6RlAOV3WpXtJMYcR6yzsJfXaPGbq5sN5xNVkBI/ywLTwcsIMyWpz4/DZIYPFnzFCmm9wUfyT2b40lfefYXW4Idv2phHh8llnBM/dqMMZXvpSusLX9uSogBppW9E519k1rGZylWTFkGkPkN1KesXbkKJEtiMHF0pCalY1KrkfHZokvcIkuUOWHY5sWv97ILtLGZt6GYtMm8wAe32dyRJWRDhthvZjOSYbmTEQtxgSyUWnKSKOQxcUF1Hh/dT6OEV3Byjg337gVPVSsxxHiIK1wkT0bDeFwEFn48NEZSHEXbmluTynZoc1Kv216eC5bjJ8XjVMmtQJdnkXeFjML21xVu0j0k13tZ/nO4ZbOXJ3Opgrv0o3P4erGHH+EiLmJUEOtYCrGpr2JDBlTHc7hfWR3yqdC+6+VURqcxWFdGVhXfBmw3Z2ev47vqrEk
 ixzoUbee
 UPG5fjRQEduCZH6z8ptGsRi5cFrjA3LxH4R2SPAAgEvrT1UuT6i4J7Gz1tKy87ExvAU+Hh90DNahHzHnjN5eguF7uY3Y5FxvhRKW/aDXI2MGp6NuEeWzwHDI1nTII620HjyX8+p8yDVCcYIb4ww2zyrJD8eekLbnlbYEJLQA3KfWvGxxPVB/kXWEKzCbwEkKIZyYe3AXykzwZLoPWmmnRYvbzcQNsaWapiL2r92xum3wPhGjBHgDgLny6gC5koWqdCx8boexIsDQtAhAWoutwcLc5+qdah2w9aKG2Q71qBH7X01IwzaPa8mtvCFzqb0mSl308YAFsQ8VFEYMZF6qMINRq0aFSFF4rba9x5FaX7j5n0ux0kshYO/yCCBtdIVOnQfGO/xbBnuDdM2rS/qiOQE9QqnOpC+OG6+pHQqlhEBURsIduK8HrkFZKHeyvKOM6YBVSF5oV8NNofCSWwfCQ8jHKla7CtEhA44iUKSTjz6AfGYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Jun 2026 19:57:58 +0400 Andrey Smirnov <andrey.smirnov@siderolabs.com> wrote:

> The vDSO data store ("[vvar]") special mapping is created as a VM_PFNMAP
> mapping and its pages are installed into userspace with vmf_insert_pfn(),
> which produces special PTEs (pte_special()). On x86 and arm64 (and riscv)
> pte_user_accessible_page() only tests the PRESENT/USER bits and does not
> exclude special PTEs, so page_table_check accounts these PFN mappings in
> the per-page anon/file map counters even though they are not rmap-managed
> pages (vm_normal_page() returns NULL for them).
> 
> Most of these data pages live in the kernel image and are never freed, so
> the stray accounting is invisible. The time-namespace VVAR page is the
> exception: it is a real alloc_page() page that is released with
> __free_page() in free_time_ns() when the last task of a time namespace
> exits. Across the map / unmap / vdso_join_timens() zap transitions the
> special-PTE accounting is not balanced for this page, so a non-zero
> file_map_count survives to the free path and trips:
> 
>   kernel BUG at mm/page_table_check.c:143!
>   __page_table_check_zero+0xfb/0x130
>   __free_frozen_pages+0x52f/0x650
>   free_time_ns+0x85/0xc0
>   free_nsproxy+0x7f/0x130
>   do_exit+0x313/0xa60
>   do_group_exit+0x77/0x90
> 
> This is reliably reproducible on x86_64 and arm64 under heavy container/CI
> churn that rapidly creates and destroys time namespaces (CLONE_NEWTIME via
> runc / docker-init / tini), and was independently reported by syzbot on
> riscv. It only manifests when CONFIG_PAGE_TABLE_CHECK is active.
> 
> Special PTEs have no struct-page rmap semantics and must never have been
> tracked by page table check. Skip them in both the set and clear paths so
> the counters stay balanced (always zero) for PFN-mapped pages, regardless
> of how the architecture defines pte_user_accessible_page(). pte_special()
> is available generically (it is a no-op returning false on architectures
> without ARCH_HAS_PTE_SPECIAL), so this is a single, arch-independent fix.
> 
> Note that the v7.0 generic vDSO datastore rework in commit 05988dba1179
> ("vdso/datastore: Allocate data pages dynamically") incidentally avoids
> the problem by switching the mapping to VM_MIXEDMAP + vmf_insert_page()
> with balanced struct-page accounting. This patch fixes the still-affected
> VM_PFNMAP path used by 6.18.y and earlier, and additionally makes
> page_table_check robust against any future PFN-mapped user pages.

Thanks.

The patch isn't applicable to current -linus mainline.  I reworked it
as below, then deleted it.  It would be better if this rework came from
yourself (tested), please.  And a patch which applies will get checked
by Sashiko AI review.

--- a/mm/page_table_check.c~mm-page_table_check-do-not-track-special-pfn-mapped-ptes
+++ a/mm/page_table_check.c
@@ -151,7 +151,15 @@ void __page_table_check_pte_clear(struct
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(mm, addr, pte))
+	/*
+	 * PFN-mapped (special) PTEs - e.g. the vDSO/time-namespace "[vvar]"
+	 * mapping installed via vmf_insert_pfn() - are not rmap-managed and
+	 * must not be tracked here. Tracking them can leave a non-zero map
+	 * count on a struct page that is later freed (the time namespace VVAR
+	 * page in free_time_ns()), tripping the BUG_ON() in
+	 * __page_table_check_zero().
+	 */
+	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
@@ -208,7 +216,7 @@ void __page_table_check_ptes_set(struct
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
-	if (pte_user_accessible_page(mm, addr, pte))
+	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
_


