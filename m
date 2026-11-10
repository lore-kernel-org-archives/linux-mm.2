Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288F8606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=l8z6aL+j
Received: by kanga.kvack.org (Postfix)
	id 40C366B00EF; Tue, 10 Nov 2026 17:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1A16B05B6; Tue, 10 Nov 2026 17:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2016B05C2; Tue, 10 Nov 2026 17:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05AF76B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:01:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E4DD40138
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:01:57 +0000 (UTC)
X-FDA: 85420582674.16.FDE44C1
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf26.hostedemail.com (Postfix) with ESMTP id C53EE140008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:01:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=l8z6aL+j;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf26.hostedemail.com: domain of "prvs=767c605bb=mkbund@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=767c605bb=mkbund@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794348115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvIm8IyzMWoZDef7K6s6hBXE4Y9TO88SqL4c83CIums=;
	b=i/g6W/UephgtFGWPACm+kYGajDaVIKjFxfK4RF7AOlU3KBXnGf0oEWwEUl2IfBpKb1wLS2
	dHC4LcsPOIZVwQjetUiOhLLPmquVXYqsHfL/NLG3PcOBtNT+HGBOnwNJxurbgIWrilXfDZ
	p+2yAm9E6aO0VNR6hurobIpO89iN4ks=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=l8z6aL+j;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf26.hostedemail.com: domain of "prvs=767c605bb=mkbund@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=767c605bb=mkbund@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794348115;
	b=v2Xbz/oOB8ciHKvfbH7WbyHZjI7EDV/VYdihpfr4NaiViNyshxiy01SEK9c23JKUh8dkkp
	Nce2XDv+F6gMIe+WBRQY48tjCVkSLCHqPgiKqB1dsr8y6MtiTAxTxB3S28+1Bz8RoB4aMl
	RTeyNMe/LeuHo5XfdN9Xin1X6UgbuiI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794348114; x=1825884114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OvIm8IyzMWoZDef7K6s6hBXE4Y9TO88SqL4c83CIums=;
  b=l8z6aL+jW9FHB+wGkImc8w+xlx9LtBLxFp6cDUWtzmxki1alUJ03tBlT
   k/kdKu9StAgjjE6XXuzqfc6xj6ukjuCfuwcamM7l1BeKQhGQYtaITouFo
   ylPurX6Om8fVbdsflzLzBiTlmWI8niqCztsS7RKsdb234Ml3hY6biNmLX
   Skbivm/YpTGOc5CSqFl5/qZYDA2j//BBNfQ3+APP/Pjz36OnHG82EUoiE
   p8UYdrAPYdQVnLhWutCOnhD96pTCIqkG4G5W8DigCtGM97qM/VK0Lh5oQ
   atn4KJaWLq2p3OI7e7F48YSytl6gYjEnMsjEjmiVaMDqiHpqlJEyQ+66M
   A==;
X-CSE-ConnectionGUID: W/Rf7HLpSaSTtqCfB4ZRmA==
X-CSE-MsgGUID: 5sajaJ3FTHKM2Yr6WJQ/7w==
X-IronPort-AV: E=Sophos;i="6.27,206,1787011200"; 
   d="scan'208";a="33472695"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 22:01:53 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:15733]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id 6a5fdb21-12c8-442b-9c97-414148c811c0; Tue, 10 Nov 2026 22:01:53 +0000 (UTC)
X-Farcaster-Flow-ID: 6a5fdb21-12c8-442b-9c97-414148c811c0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 22:01:53 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 22:01:52 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, Ge Yang
	<yangge1116@126.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH v3 6.12 2/2] mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios
Date: Tue, 10 Nov 2026 22:00:06 +0000
Message-ID: <20261110220006.3259056-3-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110220006.3259056-1-mkbund@amazon.com>
References: <2026-11-08-1-daily-reply-0005-hugetlb-6-12-v3@kernel.org>
 <20261110220006.3259056-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C53EE140008
X-Stat-Signature: wupi1zhjw3qx916wh98qm58m3sb7ui6u
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794348114-463516
X-HE-Meta: U2FsdGVkX1+iDPBpFeog5NrIWKrUzaLwvNBmcLN5CMVw3t7CT5SFROUQPcajEHmialwQYxzU6Nv/ZsSZOfLaubln0997SgdrKNvwNKJpU0ELMjOMaXOyuGrAfZ+koPDOmU79IezwEfxo6YYbpAeYAicfJhlvmLodLLz0qXj1iSR9wDnT2AgVR7pQyzGIM4c7sNcdyxS8QrWB0kFOn2Wp9zSuy0YQISF17vJ2KNi8yAFipWLbW8z+XCEKctqO2HLCRTORYSso82ZHwn54XmndsszqjKjk1zb7nZh5Zo0xqnDMw/NEYUSr4vdHChU7D7iBsDxyUV76kTO7pckLWyq96e/8t3y3GZw0bBa0Doys9JFclM/nYtxnwhI17huerzcQtDx+j1eTdxsakkEaylGP0qZXAwjbO05loX5YHe1JOc6qkKe4FJFeR1YD0mYvoVX6mzI/UhnWypMTI6BwN+GB5h1OTJptjUGMoX1A7DKooX2Pg7E4jdu1vuHz6O1I9aA76AU2ldi74FiLsCrgzyGjriAyzW7Evmp/STwAsxwFv6rn+Kiy2AeuSzdufs7J92EyTrgfnquAUBhN95NCFr4m20z5UbvdJjo3rQtEf2lV6qGtTqnrPlvW2zfOwizT/0VzTUHT5bicO5dUpYemUDW+fOco1m8Q08QHbVeQPHm7j8KpeJZ3rO5ZOQY6hvw2mIiYM/3VwRvscduxjy2ZYaViIPXHk77fK0oimc3anYweQnUPkFz8tpnNwHWqfLqjdaQClhqDqa1WWWQafFGWULnnLUIvzcc0tvJigKrovEu4wr+av9pXqOiBLZgZ8XD9PPA+MBmQeBOY0oYxxei8xAdEOiOqq7MSRcNDMS9nTGRCBHYVVVv9myXuvJwkDehAGHNCM9tM0UQtwAas8NI29SyKuwkTLXYqRJS9gQK/s3Lw+eIgRMuUF7CySWXsG2W8I36ziEe1YxY3r/XBsolqsWQ
 yi6D945o
 ZTADNU6sbSStgcKqRYPqCGiTiRQdEmqEx0w7FcwO8XlBt22IxEQPOjrb7GVtxUWscGBoWL7afMvSB/wAKDksnjvZ+N1BPzZeUO6DwAtvniVfC/iNp9ye7Bl3bP310eLaCqzMXpMBOAQHoL9a+7Oqe+JLHGkxjOtT6KkENYJQ9tYXmViIs0+fBM+1EzMAq8gwT6dk819rCX5FBG8c8JXWBgtbkmUOL5BbxXbO3b1Dsc9Amjl6Rjlv6VueIJnDqmFz8T/wxSlAQBhCY4n1z2vwNLAsgL+ppXW/13zwksIyweKmAfXcOrElOY5UViUB7s2YcMwXqgKhJIhDRqVBHMa6zS0IGlj1Jp6hp7LOfrZMUY+XqYW162rsYa2ZcLhTkBIZ6qK/Bmf6XwFJpTN8muZcj/VwSlkApgeosuahYhavlBQ63od7B5QrUux7UamXM/EnAGIwYfKPaKL08HD59bRqiXIPKUeGoCtkhLLsd3qHm6ZHnccbfpu5//MWxkK1kCFoQ2IDgnul4j1LgN/D3Dg7YEyEfE/lxpD1OheCnbD0zhZCBZlCOyK5LIWX1yBK+FTXAOEj0aNQIRsJWqISiQS6qE4TYmk4FUZ2fEipDlJ2hhP2AWobPHh7+JBPBwfGoS5V9vExgE7L2nPZ6D45cxiBZvDDk5TQaqzKjRjXaZmhKrcdLTaj+edsttnGijbHaiQw4jBbeX3X0RkeB9TRV70aAkigCXb9w5kW2NcZgu8FcfWKNy1uK1wiV1P9ByiTtdaM1PeE/JDQ8k613p8+fG8C7hOhnOHSgvcm64KuVVbS5O7TFF5iSpZzkzGrYSI92O/cPITmS1xv1AK82BaHP3kJT9YNnW4ebQJBmlROKUE8u8s4cF0ytqGSVU32oLYWxrVSGmJVk3imtyKpd9/WDOhV6/9rYreAatsy7sEu2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ge Yang <yangge1116@126.com>

[ Upstream commit 113ed54ad276c352ee5ce109bdcf0df118a43bda ]

A kernel crash was observed when replacing free hugetlb folios:

BUG: kernel NULL pointer dereference, address: 0000000000000028
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 28 UID: 0 PID: 29639 Comm: test_cma.sh Tainted 6.15.0-rc6-zp #41 PREEMPT(voluntary)
RIP: 0010:alloc_and_dissolve_hugetlb_folio+0x1d/0x1f0
RSP: 0018:ffffc9000b30fa90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000342cca RCX: ffffea0043000000
RDX: ffffc9000b30fb08 RSI: ffffea0043000000 RDI: 0000000000000000
RBP: ffffc9000b30fb20 R08: 0000000000001000 R09: 0000000000000000
R10: ffff88886f92eb00 R11: 0000000000000000 R12: ffffea0043000000
R13: 0000000000000000 R14: 00000000010c0200 R15: 0000000000000004
FS:  00007fcda5f14740(0000) GS:ffff8888ec1d8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000028 CR3: 0000000391402000 CR4: 0000000000350ef0
Call Trace:
<TASK>
 replace_free_hugepage_folios+0xb6/0x100
 alloc_contig_range_noprof+0x18a/0x590
 ? srso_return_thunk+0x5/0x5f
 ? down_read+0x12/0xa0
 ? srso_return_thunk+0x5/0x5f
 cma_range_alloc.constprop.0+0x131/0x290
 __cma_alloc+0xcf/0x2c0
 cma_alloc_write+0x43/0xb0
 simple_attr_write_xsigned.constprop.0.isra.0+0xb2/0x110
 debugfs_attr_write+0x46/0x70
 full_proxy_write+0x62/0xa0
 vfs_write+0xf8/0x420
 ? srso_return_thunk+0x5/0x5f
 ? filp_flush+0x86/0xa0
 ? srso_return_thunk+0x5/0x5f
 ? filp_close+0x1f/0x30
 ? srso_return_thunk+0x5/0x5f
 ? do_dup2+0xaf/0x160
 ? srso_return_thunk+0x5/0x5f
 ksys_write+0x65/0xe0
 do_syscall_64+0x64/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

There is a potential race between __update_and_free_hugetlb_folio() and
replace_free_hugepage_folios():

CPU1                              CPU2
__update_and_free_hugetlb_folio   replace_free_hugepage_folios
                                    folio_test_hugetlb(folio)
                                    -- It's still hugetlb folio.

  __folio_clear_hugetlb(folio)
  hugetlb_free_folio(folio)
                                    h = folio_hstate(folio)
                                    -- Here, h is NULL pointer

When the above race condition occurs, folio_hstate(folio) returns NULL,
and subsequent access to this NULL pointer will cause the system to crash.
To resolve this issue, execute folio_hstate(folio) under the protection
of the hugetlb_lock lock, ensuring that folio_hstate(folio) does not
return NULL.

Link: https://lkml.kernel.org/r/1747884137-26685-1-git-send-email-yangge1116@126.com
Fixes: 04f13d241b8b ("mm: replace free hugepage folios after migration")
Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
 mm/hugetlb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 929ea7dbd900..0f72edd25225 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3012,12 +3012,20 @@ int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 
 	while (start_pfn < end_pfn) {
 		folio = pfn_folio(start_pfn);
+
+		/*
+		 * The folio might have been dissolved from under our feet, so make sure
+		 * to carefully check the state under the lock.
+		 */
+		spin_lock_irq(&hugetlb_lock);
 		if (folio_test_hugetlb(folio)) {
 			h = folio_hstate(folio);
 		} else {
+			spin_unlock_irq(&hugetlb_lock);
 			start_pfn++;
 			continue;
 		}
+		spin_unlock_irq(&hugetlb_lock);
 
 		if (!folio_ref_count(folio)) {
 			ret = alloc_and_dissolve_hugetlb_folio(h, folio,
-- 
2.50.1


