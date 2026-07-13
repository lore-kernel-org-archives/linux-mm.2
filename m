Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246C0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EC16B0143; Mon, 13 Jul 2026 13:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD226B0144; Mon, 13 Jul 2026 13:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE9C6B0145; Mon, 13 Jul 2026 13:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12AB46B0143
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:15:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8777BA0039
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:15:43 +0000 (UTC)
X-FDA: 84984405366.05.7AE5263
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6D603C000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:15:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hv1aiAcn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of caixiangfeng@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=caixiangfeng@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nw+wphzpHskAbkcarmC3gNoJ47BFqLlYPBNMfUcVWJk=;
	b=03PPAzWovWf21f+s5PpnvHlNLgO5WTGmG0U3nXhRjKdLBKndFg0XD/kGlhNoJ0l/5gU6rC
	DBfzUom4wTWKWC1E/Cxj+OH08kloq08cM4NKepbuUqgN2joKlBs4/jCQ0e7sRxpo6VA+sq
	zy6S6MLHnMIAiGsyqV2Ggx1oUeSeNDI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hv1aiAcn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of caixiangfeng@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=caixiangfeng@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783962941;
	b=K7ykKZNNt0xLs+nBuU9sZTRXZ4Kfg6pfDJZASJCrLKrabEvAqt1B9JBjGKu2G78KSVySdy
	6At8eU2oDxetEP/pJ5GPMOXMc4Y5F4FPeYen89LM7pXdVZscsCL9nuHurXz5ol+md36ceq
	apmf8An+sL/s6pez8OdSOim6yUmOfc8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783962936; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Nw+wphzpHskAbkcarmC3gNoJ47BFqLlYPBNMfUcVWJk=;
 b=hv1aiAcn/0yT3QSpIcP8SEh1TTNWX0ykOHopIA9NWEyADckU+Z7pcRNqQBqrjbrLG/oml5
 3T63yANZU4Uuntj+OFE7MjMi7qkXxeWTo6wxP47VSrfdeWGJqOGdhQ2pbCOvO/+4uAVmZE
 Oc3zJC3SNbALj3I8ZZ/Dn2MecH4ybxwi0PhxG+e/kp+zGbjNc+F4mycM1ujCgREqv6Nqlc
 Oe+/bi/NVQWcn3ys3n6SbIeZIMq665/Jb61v5ZzMpQ19vidAU8DbeFMa40bcszYC1aFmHz
 PZMU1d/HC57RqWtXG/eMX3GqA5Bb4hH0AEXIS5lkMg4t5D71kCoQd7NgcVmEuA==
To: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>
From: "Xiangfeng Cai" <caixiangfeng@bytedance.com>
Mime-Version: 1.0
X-Original-From: Xiangfeng Cai <caixiangfeng@bytedance.com>
Subject: [PATCH 1/2] mm/hugetlb: fix list corruption in allocate_file_region_entries()
Date: Tue, 14 Jul 2026 01:14:55 +0800
In-Reply-To: <20260713171456.300518-1-caixiangfeng@bytedance.com>
Cc: <caixiangfeng@bytedance.com>, <richard.weiyang@linux.alibaba.com>, 
	<baoquan.he@linux.dev>, <shuah@kernel.org>, <linux-mm@kvack.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a551d36+a10a5e+kvack.org+caixiangfeng@bytedance.com>
References: <20260713171456.300518-1-caixiangfeng@bytedance.com>
X-Mailer: git-send-email 2.55.0.122.gf85a7e6620
Message-Id: <20260713171456.300518-2-caixiangfeng@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 6D603C000C
X-Stat-Signature: qfcs1krf7wjmy7d44szgw9owtgy4qnrm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783962941-730039
X-HE-Meta: U2FsdGVkX182wNX/IEAEGDfX2Af4sisizsYigYuJNgq5ZPl5Ilv3oBCgHLFL1QxP+okJ1rkYWET66hr6i/Mce/0H+0Gxlm1XEz17ILMWrmnS/tJI4r4dUiXdDZ2mbk4yRB2UQA9Q72jBmXZsViGnfa3SgD2Kw9ftAYNM6F7Z9PVfIB5zA20DNXk/aVbB751UM5SYABmpg0IJETyn+Ipv/f0MAk/B0HlAhZQIlgWOu4vA/2XO36XxcPMlekxLVAXLh0Hi2jvVjYWLNFf7lwOK+jisA0OM7siJkCdpQ4IQuEa780suMkVYYAeggZp4hbEOod2f3QRcMhH1yzO2WCb8KsyFXfvQmh0qiXJpOVvkmkR+RcHDyBCESsxCYSZx75Hvdanm1E78wvzw5ztQlqIdavnStvbdfgGoCoJNYF0eUiDdOGKlAty8QkkZzIIDe1VHw3e9ExkxsASCpVzAsgTRIqHHfCjzTEjhY9pa87h7Lp/nTISiSXZ/TVhxispdbTMxFTOaz1jMnL3Si+/QwkfrA7YAq0JsMWW1rSX3uKKq48MzxvaC0OTKQYQR4oIN8vfTcqn3JnJmENUdSeZCK0W5qlCrpDeo+KyYlDVShU13s0HsDd2qVfT1J63krZIzGE1hbDNFvB9bjGsQsDcQNQYWgZlNgzfDOpUhzdtUwocvHAQpE4jdUmo2X2EVxnjQ2HDdJeXxym+eJXK5v+zb6989bdWfVRWfh5LdfUkFGFM/y/1ftwQ6LtAPBsnM6/SbbUxjwc6LPYKC0Sjw+29rQcJjiPhOYDYevs370GXRlHf35W0khSHvSIsOx92It4JdW1b9EoQNSkmbXOZTUOa85SCobVQQdJng1EQAb1J9FuwQXXt3TN55g+jNMGmpcdyT5P+MGoFgyIAfZvT8lZPXFAM/Xd4rDiipYZVOz/crQdWtP8M9OQvq1GEXS4MmG2Ir3mS4rl0z1ICRo6CCQMi69DU
 hpbTs9s0
 rJyealvsAMfUg7noluX7PkGtS9icYgBe5knVUoohPL0pWfbvVEvXsl48UuQPke67jV/5WrvT+PIh9/NOTOG90bMxYQzbGDCKOjuP6FN0rmnwYj3TfC58ET6ceK9b+rNUoxKt8nx7AO1VkVaZ7NaMDcOcidO8qkSeedlMYWGlJjIoF9rY6HLfVIfruYPergzZ1dHxDuiJrpbjMCWAu/8ZlkvOmmgUVRbH8mkAGI2lRa/Lq1Mr0hhyImUHTTLgUFVeK+jLg5tX8OCwEdhJv9Iy1M5gwhtrL03mHob/NKYaLoXWUFvxLitk4wHJT6xcymxhYpV/k6S1yf3M2o3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

allocate_file_region_entries() tops up resv->region_cache with freshly
allocated file_region descriptors.  The allocation uses GFP_KERNEL, so
resv->lock is dropped around it: the new entries are gathered on a
stack-local list head, allocated_regions, and spliced into
resv->region_cache once the lock is re-acquired.

The splice used list_splice(), which moves the entries but does not
re-initialize the source head, so allocated_regions is left pointing at an
entry that now lives on resv->region_cache.  The top-up runs in a while
loop that re-checks the cache deficit after re-acquiring the lock.  For a
shared mapping the resv_map is shared by every mapper of the hugetlbfs
inode, so a concurrent region_chg()/region_add()/region_del() on the same
resv_map can consume cache entries during the unlocked window and force a
second iteration.  That iteration calls list_add() on the stale head and
corrupts the list; with CONFIG_DEBUG_LIST the __list_add_valid() check
trips:

  list_add corruption. next->prev should be prev (ffffc900011ff7f8),
  but was ffff88814c281460. (next=ffff88814c545640).
  kernel BUG at lib/list_debug.c:31!
   allocate_file_region_entries+0x191/0x420
   region_chg+0x267/0x300
   hugetlb_reserve_pages+0x387/0xc80
   hugetlbfs_file_mmap+0x2ce/0x3f0
   mmap_region+0x1348/0x1a80
   do_mmap+0x85e/0xb90
   vm_mmap_pgoff+0x18c/0x330
   ksys_mmap_pgoff+0x2a1/0x3e0
   do_syscall_64+0xd7/0x420

Without CONFIG_DEBUG_LIST the bad list_add() silently links a kernel-stack
address into resv->region_cache, leading to later use-after-free.

Use list_splice_init() so the source head is re-initialized empty after
each splice, making the retry loop safe.

Fixes: d3ec7b6e09e5 ("mm/hugetlb: use list_splice to merge two list at once")
Cc: <stable@vger.kernel.org>
Signed-off-by: Xiangfeng Cai <caixiangfeng@bytedance.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..f9577a789fe6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -693,7 +693,7 @@ static int allocate_file_region_entries(struct resv_map *resv,
 
 		spin_lock(&resv->lock);
 
-		list_splice(&allocated_regions, &resv->region_cache);
+		list_splice_init(&allocated_regions, &resv->region_cache);
 		resv->region_cache_count += to_allocate;
 	}
 
-- 
2.55.0.122.gf85a7e6620

