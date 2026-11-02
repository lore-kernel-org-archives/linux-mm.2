Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C13606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=vFXb9/5h
Received: by kanga.kvack.org (Postfix)
	id 47A406B00EF; Mon,  2 Nov 2026 04:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42AB86B05B1; Mon,  2 Nov 2026 04:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3408B6B05B2; Mon,  2 Nov 2026 04:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12B7E6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:07:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CB241A0C8C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:07:13 +0000 (UTC)
X-FDA: 85389599946.29.CE53DC4
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 813EC1A0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:07:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="vFXb9/5h";
	spf=pass (imf19.hostedemail.com: domain of zhenghui.hao@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793610431;
	b=d/KW/kvJ1yiRAT3MdTourHMWfciUj3Tq5jePFPJaU7Nxm+bD0aVBiVuwQoeNUzjweqDAoJ
	kCMRq3sBObFxWnzCeXKYKvF9/WEUh7W97Iwscrheg20zFx1G6faxzUe9lbrfjzd63W3to4
	JyuwgK+EJV/mYH4wpd0yJF1EEdQfZyE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="vFXb9/5h";
	spf=pass (imf19.hostedemail.com: domain of zhenghui.hao@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793610431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zfkqqiDFD5IvY8N0pAIRMYYO8A2QXCw24tO2W4iaNrw=;
	b=RutJC86RIldfP0gzF0+gqR+5i2hN+pJDRrZLth/uCYigd8w/1mQGW2fIwnaJ8UhSC1Naeq
	q0hEafb/3NdoD7kowULw/3lFYrnNTlhG3HsSIgaguxco30jw7vg67R3CgWRuZ8KC+kTEWJ
	C/9DNqHbkqL0OFqUNoDortFqegnsb2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793610424; bh=zfkqqiDFD5IvY8N0pAIRMYYO8A2QXCw24tO2W4iaNrw=;
	h=From:To:Cc:Subject:Date;
	b=vFXb9/5hHiTX/fb3/iL5Ejf7xwIzBkOlCNvmNJIlhxjlgxDAbmgDulBemUp81zL8j
	 fMeyTmrQXVZnf3YzpLkXfvdwyWS+5IG+Gf+ByUfhS98g7LhtEcua1dRdbgpdP2WPkP
	 Gi8TurbePCZHfPOmk2XEublT9kxr+ai22TUB8ctk=
Received: from XJSH01426.meizu.com ([210.13.72.171])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 1BAA426E; Mon, 02 Nov 2026 17:06:58 +0800
X-QQ-mid: xmsmtpt1793610418taggzhqn8
Message-ID: <tencent_869149E9C4305627F0ED654860AC4DDBC309@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5NjUq5Tx4KGydF6yOXyo5PhibasoGLwdQeEcKbYlTnLK7kLmPvh
	 9btrl9s30aYfWimMR9kRYjWbkag4SQSR4UcM9G872mRsZeKqs5dS62nLn6+GiniIZqWTKeGKf3Kr
	 +DXkcgChp3C4xUszJBQGr3X5+ol41F8gKwbVcxBOidvZEaiqQ36/zBrW0cBPu2tnQGW2m11Fpms8
	 sftN4M0WJN12FoICf1QCDpYKYVAZ0aAPhMjC7h/wWUjKZaAbxSuIcXYxi+M5TcJW4RVJcmxIlwDf
	 w4A0m2tW7GxFgFVBSFpt4phszc78ZRPUx+48WtUVntxzH7qTggLAQfLk0F9Q5QD73RcLAvtqWrsy
	 gOtuMNHHFzbHNu7WAMqb7BX2SOn+HVzdVbNlLarL9NLeFKXgZguvqtnKzChOziuc62tYCwdSbrwu
	 KW5fEkPUEo1J9ur7YKCZ0vCszDtV2n9YDg4BTC6JdCTrbBhfprdwY222ttwTJsOcpA0XuG6gsn+H
	 BE2HF9rjbMczIMlBOsa1t32tU9QTg4JPnPNTO38XxvFhFT28vPJnrkKfohUNKsUnKQNKOsZWXl5g
	 Qm5ImE7Zr0giV2LgZoxS0xnFE8cxKYNCI5HlCb4RXid1KGxDtlg6d5eIaSDLaO2ntCmXlDMPkCma
	 uZycLRr1UiAj4TpNPycILCcj+wMM9bnewHEyIBpPUMHlPETMcRv/2W3eCSryihhtNCPBQGOP7iBz
	 oMueG0vb/IGV2quB2nhV1wMrwawYi3+3ZEFPE3gOKwdVpH/QasHUpoRY6GIOKNhrESRjawaucKP3
	 X0IjREp7Bru+bZ2eIjyEsy3hJzQzW1VDziaIdN1G3LkvXsorX74Pa0EkIKbWg7qcP3JpKiZoO60l
	 cjXh0pJtWc8Avxvg3w7XxXQFj86y039W/VhfyzIPtQWozaU+/xIagRYq61zjk4GQjpSmmyH2UjfJ
	 vwnVk6VaFchFJ1up6cO9E9avoTpLVXaAGssguB1aGMgGKvHUdti5ROn/ho3GiPNFHcHrU6zwelNp
	 ywad7nFUh1k660OpmiNkONaaCipSS+io/MF6/dPnPbOSBPnHzpPd/ZZFxq7JL/eOMTNFQNSQ==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Zhenghui Hao <zhenghui.hao@qq.com>
To: akpm@linux-foundation.org
Cc: vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhenghui Hao <zhenghui.hao@qq.com>
Subject: [PATCH] mm/page_alloc: release isolated freepages on compound range mismatch
Date: Mon,  2 Nov 2026 17:06:44 +0800
X-OQ-MSGID: <20261102090644.1135255-1-zhenghui.hao@qq.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 813EC1A0002
X-Stat-Signature: gjirrtzj9gixz6s9fozgr9uary64fes1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793610430-776686
X-HE-Meta: U2FsdGVkX1++yimJcAhxHE/P/oKZi7bsblY5cBSPpQuXpdJChYwamcmlDkqPuCbmZ6DDux9WDYTRa5HRHY5bpuygaf2mVI1MNOsJZEb+ql2++Y68Hd07g6+AXUP2XCzZL9qM5K1UIcrnlQIsVzRFANEUT6akUKp+q35ZEZGCxHOfch8HM1tg+QrwOTi4TNQogzcUwnGADgATxi3p0MYP0nqLR5Ac+UzhqUQxx3KN/ZdcN31n2OCbcHsKf97bwD9B1cVwof6w7aN0MRbNfP1REnVf5BN/sn3VfF9f7BtzF455O25u2AZjvZK75GkhqG2iUvXd53UnZ3IDmtuW2vfuaBTLPd1XkDoVH+s8HrmvOwTaEKrsvx3K7o985viyzu7l0vX+3YZxbewdxxB8mqfS7kQBsXQ4ZyU7lIyJNrFnVlgR4fhLH88mw05UXAf5br0e+15OMa04M6z/abpqtPRq0gcfC/yUuOp06C46CpOgTowDCpm+UDm2L+N4wZtZ7zy/+pDrx5VjUqznvhv+QMq9LxduJSxgHl+A6mdeat/bawJr4e47yXsaL8wcN8Od8d6ypmVYgp9QL2ruR9VW6JIhEho2oYmuTE5DqRsIEQoW/CQfj8rfN4/HanO3fyjdRHFcUdDov0YJDtefue3qnwYYU8HRgm1yyErdsBUEO/H8Ym4+Ca5lclqC6iBBBDmMwYPhhekHsSOJUUxzTXVwNRnfaeHZbRrdpYhJlH9Y/xZ8jmG9ZlaWb1r36qPdGpnA3XOjir2n0UkmJTnoQVIOmRhmfKa3DcvJWfdkwJgU3/l6/mYsDQPf/qulfRb3UqD4JiIHzOu79g/O2Beqag9DTMWwBxDV2jCIyc4t/mYSfntqvQqN/ETFtIZ8bre+zYKpgzeCfAxUtCOhKBAeIChjuUzd/JMTINDmOAU0l09pboZxQYgBwNtE9Os1cxDnt0Fia9ehGMzhf01uvc9DDOeugbo
 SMNAGcVI
 gMln4mFF8wMWdfrMjgnm75nLQMhdPXCns/NeQz7xRgZcLvTLge6rXbFVEOCZ/3LbG6KT2+xNeL4mV6ip0D6y8M/RJ3qobWLoUgOXc3M7aqUXTrJ0ZHfndNUO1gXUN4q5X0/9KAL+QJPluh4uF4I21aKSLBvm31l3Gfa1hlknGdu4E7uRUpoKtuqh7RfWz8LTFBFzJMH8vmm26xR7iMvGxXEXOElepmVQMOFJtujBaJ1F+HjxBCpnvcmRAjGIzh15vBRqUeOpM75oZXZpmsZJlvZL53qGcLuNEKoR1YTo3AXXyd+FtNOC6jYAg5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

alloc_contig_frozen_range_noprof() isolates [outer_start, outer_end)
before checking whether a __GFP_COMP request exactly matches the
allocated range.  If it does not, the function returns -EINVAL without
releasing cc.freepages, leaking the isolated pages.

Call release_free_list() before returning -EINVAL, while the pageblock
is still isolated, matching the cleanup already used when
isolate_freepages_range() fails.

Use WARN_ONCE() as well: the condition is reachable through the exported
API, and repeated invalid calls should not flood dmesg.

Tested with an order-9 free pageblock and a one-page __GFP_COMP
subrange:
  before: free_buddy=0, leaked=512/512
  after:  free_buddy=1, leaked=0/512

Fixes: e98337d11bbdf ("mm/contig_alloc: support __GFP_COMP")
Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
---
 mm/compaction.c | 2 +-
 mm/internal.h   | 2 ++
 mm/page_alloc.c | 9 +++++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb201..11ec991206bb 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -89,7 +89,7 @@ static struct page *mark_allocated_noprof(struct page *page, unsigned int order,
 }
 #define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
 
-static unsigned long release_free_list(struct list_head *freepages)
+unsigned long release_free_list(struct list_head *freepages)
 {
 	int order;
 	unsigned long high_pfn = 0;
diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce48..364b288a0e2c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -880,6 +880,8 @@ int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
 
+unsigned long release_free_list(struct list_head *freepages);
+
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
 struct cma;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8cac5e01066..6913e0f94540 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7400,9 +7400,14 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
 	} else {
+		/*
+		 * isolate_freepages_range() has removed the pages from the buddy
+		 * allocator.  Put them back before undoing pageblock isolation.
+		 */
+		release_free_list(cc.freepages);
 		ret = -EINVAL;
-		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
-		     start, end, outer_start, outer_end);
+		WARN_ONCE(1, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
+			  start, end, outer_start, outer_end);
 	}
 done:
 	undo_isolate_page_range(start, end);
-- 
2.53.0


