Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B06D6D3CCB6
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 07:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0600B6B0088; Thu, 15 Jan 2026 02:17:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DF06B0089; Thu, 15 Jan 2026 02:17:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B986B008A; Thu, 15 Jan 2026 02:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D20346B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:17:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45FC75722B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:17:20 +0000 (UTC)
X-FDA: 84333342240.14.BD20A85
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5EA45C000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:17:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ci14WHJv;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768461438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SroIRR9h8UXJM6S3Ve2lceLMWS0gr9k4kwONMIjUn/k=;
	b=SHehpndbN8TadDoocoiupIsXeFG8g6BHbNWsCPyKphnkF4fvooPHUADoCiROvWa9jl4zLs
	UvBk/GQ8vi8HK2JKXXJFa09aqdp+SqhUAstpYG7PSxCStTvk3j2KmoMpbCA2637VAyN62S
	evBYQXn3ajlGLHK1lV4YOrzOb6K5Voc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768461438; a=rsa-sha256;
	cv=none;
	b=oo2d3rxtwphvS5G/FxgJMjq9ibgpXZEeBwx78gJNkebjaJz3m9+3eyuv5JVMewg5IB9mgU
	RRSyYgQuRH8hnGrBUz5ltbt2e2Ao++OaAWtf8BKVKD9UynzTRygqQ9hTA5FFmz9bXtgNkW
	eVV239Vgd8d6QP8juCg162GJ4ai93Ao=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ci14WHJv;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768461435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SroIRR9h8UXJM6S3Ve2lceLMWS0gr9k4kwONMIjUn/k=;
	b=ci14WHJv7NH7WnbwlVuHcNEQhsWYNL+j395Xrodh+Yc3WM2M332D4vE43Ph+kFX1baYNY2
	DZtEuPtOqrabF9xiVHFKRWLJtbtSfWPNUFNmJUXfgXbj3x9psJCKupWq71gMEYVgniXWai
	lQdR7XyZURPUjHt+LQCcmlqsSd+up5o=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ioworker0@gmail.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v1 1/1] mm/khugepaged: move tlb_remove_table_sync_one out from under PTL
Date: Thu, 15 Jan 2026 15:16:51 +0800
Message-ID: <20260115071651.42626-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5EA45C000E
X-Rspam-User: 
X-Stat-Signature: uq86eayjitd6hprfjxnxzaym1dcqdd85
X-HE-Tag: 1768461438-212099
X-HE-Meta: U2FsdGVkX19sN3D72Lidw2tR4lbqXa0Sn5/1t1aJIl6LnaOO5qem007kv5i90xhbFLwD9CP2lFJ7EWGGrWQJGwVjme2F6AWw6NTdLVmvsm0V0t+Jva9u/m8+BUpel3Pt+Etl3lkJEUtazypwCjkqtiFdTEYo1W7sNWgobgg0vegHK8IbZf7gV2Dx6ttBebgH1pScXCzVkdUTeRxakaWkWFd7gPOF2DjGN5Uyz8xuaXSt9PSOJbyjJ2OKdgwZYyGJ9laD2XT9c5XMS6E6hErDQ7ikHfMUiREw78rDNNSCC3wZZ8tAgqkVAHeEWLzeSj+2qw0zreO6n5j0auRHsoOkSAHVZn+X10TVRn9/EOjmkYAoD0lKGC29yaTvvso0cjpHvc1zjxdhmGDJWHl88ddMmyAkrlVoOg19Cy2hWdCT2c9ek27up1SVxPgE3ISIplBLpOWsSlXrzeBXKvb8IN2HsgBG6Ib7hr4W0vAR+JXht6NlCbxdO7zsUEpJgUFibKxnPlD45VumCp1KfvgJKFHTYvlwpyxjQvLylYZUdRAax1L883bQGfCtRV8ONHBrXQk9hxOOIAfgp6kxBeUPXjno1Btd9Gj4lYRafrTAMBLAVYgXu0eJ5olToxiJzQ6is3tHiB61yLhJGv7r/9h2UDlRT8X6es+8zd1gMP3luqcnPEnkDcoYzlU/YvAW66mSd/++kr34e7xfNGesmfjyWB+GXr+9Q+CLAs906FKuRKOoViBBbaRhAwBc3b4dyzf+LeAPfGcHGH3a6dIHeQTQMvZxfg2o2WX9wb742sxJy4yCiSaHVRU4FT/2UGC8uJQEvQQ6rW2AgEKGjTLk6BXKokSAVMhxP/Acxu/2wj7KlsyTnVZXnhtcCeBLIjeeM2Q8rY+m1lUU2MpE17cQ67RzVBWp04VMV4moZh9/uqtqbgh0dThpzWIXBPYdvcD+SluldF3V/JOaedXSiVn0qHjGs2U
 3sgH8THQ
 BHIqiqKL97BvTppbZI9BJVcDSQUCFBKeLshFtvvl6CpBukKlfQvn39M05r3DRthVHa8dvn0e1+ZRWjjmQfeEVAZHxcZkMs72J2CZMxW9AXnq1ALALI+15dACsLfBa6lNHJmLK6olSFdLsIsENgAeDn0V2u49w9rb5eQMzulmUzLX8vTJKn1TFC+evGfpoVVGCUNWV9sISiZhHTFLihXUmG57PU7p71kWnHWIOeBittT0OJ+/YKQzBs/iTEJybb26mRk0gH0bmyeip53exUj961IUOOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

tlb_remove_table_sync_one() sends IPIs to all CPUs and waits for them,
which we really don't want to do while holding PTL.

Just move the call to after we release PTL, and drop the macro wrapper
while we're at it.

Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/pgtable.h | 4 ----
 mm/khugepaged.c         | 5 +++--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index eb8aacba3698..fb04ed22052c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -755,7 +755,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
 	return pmd;
 }
 #define pmdp_get_lockless pmdp_get_lockless
-#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
 #endif /* CONFIG_PGTABLE_LEVELS > 2 */
 #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
 
@@ -774,9 +773,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
 {
 	return pmdp_get(pmdp);
 }
-static inline void pmdp_get_lockless_sync(void)
-{
-}
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f790ec34400..0a6cebf880e0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1664,10 +1664,10 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		}
 	}
 	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
-	pmdp_get_lockless_sync();
 	pte_unmap_unlock(start_pte, ptl);
 	if (ptl != pml)
 		spin_unlock(pml);
+	tlb_remove_table_sync_one();
 
 	mmu_notifier_invalidate_range_end(&range);
 
@@ -1818,7 +1818,6 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (likely(file_backed_vma_is_retractable(vma))) {
 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			pmdp_get_lockless_sync();
 			success = true;
 		}
 
@@ -1826,6 +1825,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 			spin_unlock(ptl);
 drop_pml:
 		spin_unlock(pml);
+		if (success)
+			tlb_remove_table_sync_one();
 
 		mmu_notifier_invalidate_range_end(&range);
 
-- 
2.49.0


