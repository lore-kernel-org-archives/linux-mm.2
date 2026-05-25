Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938C0CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050166B0093; Mon, 25 May 2026 02:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0266B6B0095; Mon, 25 May 2026 02:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5BA6B0096; Mon, 25 May 2026 02:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D950A6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:50:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82036161805
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:50:13 +0000 (UTC)
X-FDA: 84805017906.28.EDA3A85
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf20.hostedemail.com (Postfix) with ESMTP id 80B601C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:50:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779691810; a=rsa-sha256;
	cv=none;
	b=Yarhj4M7OLRhymBQYs3tZa3W9d9zanbOSJGMy0FORkkuwwHsDwrSfZ0arUQaM4Vi8HSZsf
	GQSf87+0r/cG0VlQ5EeZTJmS930FypIuh1TrhPRsHBSegz8ju5r3XLLDnahUgoxKtyykC3
	HPGtqmafNE7YdtQ58AhbhnmSfuqfllc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779691810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=spNAZTSfbnvz6N/xyyowiDZEcN3RTQoAHekBHklWDLs=;
	b=OkQPnVnzlraZLyoGmdZSx5UJ4ySFt3fyedkAXrSVfJY9qVW0t1ECpTNCAPmA5UWSHs+FAB
	6m3Se+yreO6C0fHTbqaPy30WtMLa5CeGeixx3n/VFA/Jlu+t7mv+mtlr8ocAi8AcBHeA61
	EVJnFgUEZkN3CCd86/fKOjnSDYqQcLw=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gP62P4qT6z8Xrr9;
	Mon, 25 May 2026 14:50:05 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 64P6nws0036196;
	Mon, 25 May 2026 14:49:58 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 25 May 2026 14:50:00 +0800 (CST)
X-Zmail-TransId: 2af96a13f118096-76827
X-Mailer: Zmail v1.0
Message-ID: <20260525145000501-t0VQTKCI5BtrK9-y4tAI@zte.com.cn>
In-Reply-To: <20260525123938427-2LRlh6S2Ew79m61xNh6S@zte.com.cn>
References: 20260525123938427-2LRlh6S2Ew79m61xNh6S@zte.com.cn
Date: Mon, 25 May 2026 14:50:00 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <wang.yaxin@zte.com.cn>, <chen.junlin@zte.com.cn>, <david@kernel.org>,
        <stable@vger.kernel.org>, <akpm@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
        <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
        <rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
        <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <wang.yaxin@zte.com.cn>, <jiang.kun2@zte.com.cn>,
        <tu.qiang35@zte.com.cn>, <ran.xiaokai@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBzdGFibGUgNS4xMF0gbW06IG51bWE6IHByZXNlcnZlIFBNRCB3cml0ZSBwZXJtaXNzaW9ucyBpbiBtaWdyYXRlX21pc3BsYWNlZF90cmFuc2h1Z2VfcGFnZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64P6nws0036196
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 25 May 2026 14:50:05 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A13F11D.001/4gP62P4qT6z8Xrr9
X-Rspam-User: 
X-Rspamd-Queue-Id: 80B601C0007
X-Rspamd-Server: rspam03
X-Stat-Signature: p4n8n8hhxf8ij1ujnjmeshhzczdf4gab
X-HE-Tag: 1779691809-636715
X-HE-Meta: U2FsdGVkX18BsgxA6S3goknG7bI6VBbWXJ/41wzxrZWjBTfn9Aj6hlzm2XkOTIINl/gRcyFBRnAbE675rnJpOrQXems31ehXQ+8OmyHZFsaD214TulttjChlqNI14/RXWc29xJxcjLVH73yVhEmG8GrSEWSmADIa0IauZj0p1YJ3OFZkKGuqjhYIYtZnTkBRctJanv8+ssVVbZLlvhCHZ6UdxopGstVOnrRz4e4HfekUplnfpq9JDI4B6eyuCLhWQwI2K2Q34A69l+qzmHsDsE2llG+BbDvfGT0ca6bleh8nOaoO6zukPGdRIEDsXdt0QyHyi5ps1UN+KCAzNlWM3nXwpKDQ6vBf0YbgMfZIDI2zkXI66WhCqfLyZ0Sw0TZyHsANtfu3DJAcUMMkfSFucDngyRCww8YJmuUnCWgq6lX1LRIhQirZec8H4l0ZYJJ5LvxryBbab1eLHfqpIJDAW/K9qXtsfGog+Wvkooqb+keHYUyJtIff2Dp06xLK908N9ocS3e2ih59ewBJKpBHf6aOXjCBRcTLu3FQpk/HLVxbPWSivJg1EPAXeMOZBmVKPEcakUYIj6CTb3YMvOnxyXZathULiPQvMS0k6UF7zh5/7eKk+f0t3oeebS8LanXoGvUR1UmqCRl/u18/8udw5o7iSzXP6lLn/rWyw2Fa8e6UkaX4vzvgbs7MC+C5UF/BWhHCphJuP2anBn7E6j7WPfW8Qe4qP967wrdZNDQ6gMwg3NF7heQRp54hTQe0/guuDDwvAtZx1RgRVYSXxNt8AWmbrCRMtirnCU46caJO7p7ycd/JnSwVuj1vpUx6TUIFM13F/YM+lRfOjt7fVy0xwlnI0Iz2EMUf35IrBj4JE/keut7qN9R/eiHih3Jdm5rDrJM7r9Wvrarf1OILeY557XB7FwLCUn0wAMUVSQ/fZTdPVrEzDYRpZ04GXlGxnNfwiScIx/WcJWlXnUpgRJEJ
 YM/W2iE9
 7DNbUTIOjMX81XOkshLBIklMeCLINvTwAA4l3lm8XKwvfAPc1aGuV4ZpES6TN6ZJcxABiHXSWTcaOjn9inaWhOn6KYJkB1vz5NXJ2mQocQn43sDBT7dG0Bw4xqvRmPelopQYc0vHC8drj/4DjKvzctQ7N+BfJgdoJAU6VFQ2NIn+s34hQoYtxowmV/x8We6wvlW/GOZBgvR9u7/kUpBffb0fHCcN3DSexx4qwaBn3skFaQlGnsK8DW3En88XOXyOyBrUyMJbSrrFFOV+ZqczbO8+pQauD/3EPmYbgqOWZiE3a9CsjuBStN+uKYrcRIIFNuKUk3RYNjbqv1awQDCSYStyN8Iy6pBMRa14D/ty8dGDwfXWo53Yvl7EZIqPUWXrYDrPE/N76hRwDYqPJj3W87sptNh90qIHnmvfBaBZ3N2RUcREq53W6AdgMiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> When a process allocates a transparent huge page in its address space, and
> then enters the kernel driver via an ioctl system call, a driver (eg.
> ib_uverbs) calls the pin_user_pages_fast function to pin the process’s
> virtual addresses to physical pages. Subsequently, when the process
> accesses this pinned memory across NUMA nodes, triggering the system’s
> NUMA balancing capability, a page fault occurs and the kernel enters
> do_huge_pmd_numa_page, then it calls migrate_misplaced_transhuge_page to
> migrate the transparent huge page. However, because the memory within the
> huge page has been pinned by pin_user_pages_fast, numamigrate_isolate_page
> returns 0. migrate_misplaced_transhuge_page proceeds to the out_fail path,
> where it changes the PMD page table entry to write-protected by pte_modify.
> If the process then performs a fork operation, copy_huge_pmd is invoked.
> Due to the pinned memory, __split_huge_pmd is called to split the PMD page
> table entry into PTE page table entries. These PTEs are also set to
> write-protected. Finally, when the process writes to this memory region, a
> copy-on-write (COW) operation takes place, allocating a new physical
> memory page. This breaks the binding between the process’s virtual
> address and the pinned physical memory.
> 
> commit b191f9b106ea ("mm: numa: preserve PTE write permissions across a
> NUMA hinting fault") added write permission recovery in
> do_huge_pmd_numa_page, but did not add the same recovery in
> migrate_misplaced_transhuge_page. Later, commit d042035eaf5f ("mm/thp:
> Split huge pmds/puds if they're pinned when fork()") enforced that
> transparent huge pages with pinned memory must have their PMD page
> tables split into PTE page tables in copy_huge_pmd. After that, this
> issue started to appear.
> 
> So, the simplest way to fix this issue is to also perform the
> corresponding write permission recovery in the out_fail code path of
> migrate_misplaced_transhuge_page.
> 
> Signed-off-by: Chen Junlin <chen.junlin@zte.com.cn>

It seems the latest kernel version is not affected by the issue you point out
because commit f66e2727ddfc ("mm: huge_memory: use folio_can_map_prot_numa() for pmd folio")
will make pined huge pages skip numa_balancing.

Could you please add two tags?  
1) Add a "fixes" tag (the commit that introduced this issue)
2) Cc: stable@vger.kernel.org

and Could you answer which other long-term stable branches are also affected?


The patch itself seems fine; if the above questions is resolved, feel free to add:
Reviewed-by: xu xin <xu.xin16@zte.com.cn>

