Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D32BCA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 06:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9F06B0088; Wed, 30 Sep 2026 02:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB236B008A; Wed, 30 Sep 2026 02:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0A06B008C; Wed, 30 Sep 2026 02:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6906B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:43:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB6A6406CB
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:43:49 +0000 (UTC)
X-FDA: 85269488178.30.264587B
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf11.hostedemail.com (Postfix) with ESMTP id 91A5D40007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:43:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=adaj1yXP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790750628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mdpGDSuoMrpnOMeORo8QVVPfWWsh5cud9+yMOi/on1E=;
	b=CEQLQ7FLEetZSyWcHGGxocyBdNg67+8Xws9Py9u6vJQ7rXhNPJ0q82hR7w1LrFiyVB96w7
	PLsorM9P8oVc+bD69QP3XuPTSF96z//exWiKVMLCaIACjSOFA6TjcBVA+fefD+4rIKGBbc
	IodD3OtIsDo4BeTc/utq3OIq8q6gHgY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=adaj1yXP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790750628;
	b=X01yMEedCz2AqE9RBoiEgPpWRU8MafDH61FpVcrvHnSOh7jHKOLXtPZgKbD/aYN3B/IlyS
	7ZGEFELsmidN+4E1pAa/u/dGXBitLdlQsKQMmG7/bqkeAr+aaJXd3kK9YTetIyHfw2dRG/
	cBgeAChvDVOKU+DPt0eS1laSIXp4R1w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790750620; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=mdpGDSuoMrpnOMeORo8QVVPfWWsh5cud9+yMOi/on1E=;
 b=adaj1yXP2VFfsYRGa4FS/AHaib5803hNtnnAQJw0nToW1gadg29L9jrr7XILLrwz0vtSBg
 BMr8LZuY3QcCDwE9GjcAT6jKRXnHjF81sYSJKSWO7XfY/TDaiOAQmSw0pYuBiX8OU73lAY
 ftyqw3NMNzamF9+Zqq9BK2v1Z7fkDirpNkt0HJARIN/njckBCCjjf4s/Elc7O/OjjGjnEL
 8JXIzKBWS8MTYbgR6PbqWptcS314WETPMk/LuFYU13mck9I/7fsLsJ9s/1B2dGjIYaluLB
 d2q36FDERHdh6PJrW8JW7R6fYTl9pgJNe6OB69hsFHnZng0ZUolOcaxO9/U4zw==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
Content-Transfer-Encoding: 7bit
Message-Id: <20260930064308.58159-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26abcaf9a+f67a35+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Date: Wed, 30 Sep 2026 14:43:08 +0800
Mime-Version: 1.0
X-Rspamd-Queue-Id: 91A5D40007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ownrk4xsmuo53xeegtzso75kyg9w1rb9
X-HE-Tag: 1790750627-147486
X-HE-Meta: U2FsdGVkX19eYVY9W6O39xXPvQQMBDwkk3F8v9lPdbQeBwcz8ZHJGGIcuqywTeMOUAlA/LcPRenlmunvOKzd9iVm+OCApj8xXJZ187W+OZboAKON6AWFfscF6nCkdVBAPMp8SN4dlk9iwohYDa9gUj30tLoySRiRgeuRiEJB5JV5Per1S02s4L7pAOpNnYfiXPgPCxR7F8LmYYmwqiWXW90LXzazj7Yv8JJZaTgBqTqvROQUDpeaJjQhyIcbvy0bwKjKUjfha2ZQ3JsBRdEGvj9q7gEslFF8M/zm+A0YLDN4LV4BxI6ivEG4j+z458guGVOWkaiheo7F0x3zfxHzbOwU64An79y6l8LqyIGRHBPNVhXt0FVgh+pLZnVs4uSx+QZNQGTAdvFdL6/Qym6G9r+m/16SEdUGR+fxL9BdvLedtUiDrF6jaFSUqP/R4NrVax3rPphpcU/p6GYm2/hpzdHpc43hSeFzQX+Sx02f9GqowWiqdC6JFAWd3jgYmMT8+mSntPVDzDJnj13dZ5P1fexZzIVcWq8EZ3jmzcpiE8CxO0Y9A+vMMlQjc3Nbk3dA6XlDIWUMmf6XUgSl/q7E7M9Y2ElkdTRPMkLt4zDc7B0F/Zaycne1f0cFNnpsvLcoNEwckSJ+6ZqoHXnuHDaA3RkKu9/dH3fymPK7iHBbVmqZ+DCDqqcWmFfLaZv+v1LnZoz+okKTI+V+cJ+Uorsx4kw8cce5L/VcDhG2ZmT6oa/mjjWSYQ+zIKHY59Bs8xEd8Q2qhhRGLzxUg7C7PbjyviJDzbnK38OETuIJjTcJ7723mSxxjjI7COr9QEtG/IPZj76ZVtcfppBfC2BnnjFejUH+R88M6Spw6LStCmc74f8AfyHP9EQhvCVoYJdyjDWMxiNAYtSJ/gwEN7X8j66dge/Avqgg2YDpi3rZmXbJs57qEvV/Zw1GDrAe9tBIXILV3mWoVUw7ba/jSoi8WQc
 SmYFSCOT
 K/1PxWFkFJW+uYNFwP3cO1WewGRjwMf9ilB9riyTTX/aOv8563xAO2454EcLwa+10TwlCbKWFC0BP0TsCyUt1vjplTPao5OirRsK2S7w1kvaYs7KFc2dED7ESdY1HVXgDI+JhvUFT9cYYdw5VSJfoa/SslKkKDv4DjNKAI978PrPvVocSD1gSQXPidlF7vIxu9keL5YLvU8NPUwMguqD+R61ezjojVmeC0ufUdGqNLrIes8YSPdnNgDggqCrLYLDb6KqXaippcDzEY20KmwFUe/I9LC/CqxkcFOUUTcbiHT5s0xk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

huge_pmd_share() always takes i_mmap_rwsem for read before looking for a
shareable PMD page table.

That is unsafe for callers that already hold the same mapping lock for
write.  In particular, move_hugetlb_page_tables() takes i_mmap_rwsem for
write to prevent truncation races, then calls huge_pte_alloc() for the
destination address.  If the destination PUD is empty and PMD sharing is
possible, huge_pte_alloc() can call huge_pmd_share(), which then tries to
take the same rwsem for read and can deadlock on itself.

PMD sharing is only an optimization.  If the read side of i_mmap_rwsem
cannot be acquired immediately, fall back to allocating a private PMD
table instead of blocking in the sharing path.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cea25773a6c95..75631101a6807 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6995,7 +6995,15 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	pte_t *spte = NULL;
 	pte_t *pte;
 
-	i_mmap_lock_read(mapping);
+	/*
+	 * Some callers already hold i_mmap_rwsem for write, for example
+	 * move_hugetlb_page_tables(). PMD sharing is only an optimization, so
+	 * fall back to a private PMD table instead of blocking on the same
+	 * rwsem in read mode.
+	 */
+	if (!i_mmap_trylock_read(mapping))
+		goto alloc;
+
 	mapping_rmap_tree_foreach(svma, mapping, idx, idx) {
 		if (svma == vma)
 			continue;
@@ -7024,8 +7032,10 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 	spin_unlock(&mm->page_table_lock);
 out:
-	pte = (pte_t *)pmd_alloc(mm, pud, addr);
 	i_mmap_unlock_read(mapping);
+
+alloc:
+	pte = (pte_t *)pmd_alloc(mm, pud, addr);
 	return pte;
 }
 
-- 
2.20.1

