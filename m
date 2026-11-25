Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B44606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJXjn1c+
Received: by kanga.kvack.org (Postfix)
	id 6BFEA6B0B03; Wed, 25 Nov 2026 17:35:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696EA6B0B05; Wed, 25 Nov 2026 17:35:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586B86B0B06; Wed, 25 Nov 2026 17:35:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3438F6B0B03
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:35:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C23E7A8F04
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:35:52 +0000 (UTC)
X-FDA: 85475100144.13.928F8F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0FFC20002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:35:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJXjn1c+;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646151;
	b=bP7f7Y2E65x3vaYf5LzcGtmMcTU/JK6QzQJRe27zmdTeqHPxaf63zCydf3GaSA8f6/4K2U
	e8O4iXmh/VWJIEWVzbMsnB8Y3s+qSS8JQTD/IujHdkVIVAOyMJRppjkOQvYoXfi5w0gVvG
	vWF5v8FSOz/zlW/UswS/IOzYM+ltOm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMCbRgDJx8My7FQr8Am7ZyN1elVge2GAU4cJitwdV1I=;
	b=JfSg+VjeWBMsurlKLUArBrW2MtEufbULKJSet+ACNL6oq+yi8hpi6yS3fCv0z8k9OvUm+e
	ORndS8leazzU06q//K79R61k4/m/ZP/CIo0RqKMQmMf8zdFdYNcCkaz6KmpLG5ELSR0wFd
	wn+xzeEoLltaF9q/yiFmHsjZbwA771A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJXjn1c+;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85C1562695;
	Wed, 25 Nov 2026 22:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366811F000C4;
	Wed, 25 Nov 2026 22:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646150;
	bh=YMCbRgDJx8My7FQr8Am7ZyN1elVge2GAU4cJitwdV1I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SJXjn1c+7pIabnj8kPX5lZxyarzkpDWWLusXBCpqjsExrs/MaVwmfO95QUNnTd5Re
	 r27Q2AYBE8B+MyS0tm7Ft1TS/WmNAPOPHKFXH2SPyoz2nIETvKNkU4qz3+gFP6Cozx
	 OTQezEc4bbc17FFzXQfvHMXsarQelHiOVkRJ81ZvGq0QVaBkeuPLeYZAvryL/OlLe8
	 PjAjI1j8B7T2SBg1nFfpd7ZTrXfeKZdsAFbZI1n/JUIX4eIpemDzoAwsx02LClA3bo
	 wSO/OapyRca3JYN2LWkXF5Ep0pv1mQT4bbua2hclzhdeX5VcKC2zaoSbFbw/DPOUJE
	 HLcMD7dRyvNfg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:07 +0100
Subject: [PATCH 09/21] mm/hugetlb: don't zap non-present entries when
 unmapping a folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-9-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1858; i=david@kernel.org;
 h=from:subject:message-id; bh=mlk8Hq0S+1YqGOS8OKXZSom4G0hgd8p+sLBTmZ3zL2Y=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1TkFCb7vtXncJnSciWWZdZr3xr2DvaQ8snSp86Ir
 nPsTJDrKGVhEONgkBVTZAkKvm/w8uW62mo3PmaYOaxMIEMYuDgFYCKp3Ay/mJ/q7Gvau3DWknWS
 G/XWZ/bUmfPJxTaa2vW5Hzgf7jhDjJHhoe8mazm9wuUZAVom2lkOO7bPVWw/dEbFRsN+97Mjc7b
 xAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0FFC20002
X-Stat-Signature: r9aarpyiwjnhzjezxum8q8zpzrmcachy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646150-518827
X-HE-Meta: U2FsdGVkX190gTmSSz/w9auECTVjEfDVteyigWDE9ccVQaKrX1TPI82VdtotRstkLkbBUNbh/hHp8gs1pvRSM3XuP4SvzDk+X/skrq1Z3NwtWBivJP7NlTKRXuKz46IbDxQ9iUtWj+7VU4zhugAtf/qg92m86/6k6gU3Tyww8k1gt0P7Gb339kMZTlVGuz85qtzIGSnpnXIbBNdJtfo2t6HbYjsVPkDdjTAhLzpSkceNMh6RINkEkJiijlsxZ7rfwv+l3cI/T/WzjbaaHowNaPvxr/hOZeqJjvQ+Q6MNgih9+D0vAD2jp79ee9ATRe7q6N3qXQoY2Yle4Yh+oVW8O1VrFbysIma4O81e2cBuCD6tTFX7klDnCMW7Wn3oMkiKfzg7T80BFr9Q3zPpWGSNSbxnC3eYwQgzeJ5qjabOq01t0RA1GWufq63VdZtNH2oeOK4+Ti0DxtqTNkb6in4obBmuq1AfOv8XTlQ0mITtL93eNqcZrlIx2Y3S/0Qbt5cxqDyagHYqXY/YhthSH3IhjodhVHeqgmSTh764f1m3uNbZrlZXLK21aU5iX/x7MX1452msii+F6FXOZBR3s9LUDqTyZtSeEhJbkWymA7zTkrgEkJU4BHrT62KMRIv41xsRb+F+ZiYW/iI9utQz4aRofKe5oQJNpHeyaRmhdETNBzUZTiIqV4UUrN1bdEKwdB+N037XkBqgda7A2tNMucImqUozOaCxLXzSpfmz93fxgnDvIk41nVT+qeKxwH5AeJE778G0kt+hPRIVc74NydtgDgPYBzsZJbCNZ0rKg0KbVHhwQYUXbnUnPryOiUbcak9DuKqKbxThdzknYbjsjo2TxTByVNJbTgB+aacHPKX6Y82wzhYnWlm7sFAujEBCvH2YQSTSGNrnrjh2Vdo2q2A9TunuHasFk7j4T31VDZX/D48hzTetw/oXqzIoLg+ltu/y5n7VbL0Qb6t2MtTrC4P
 uZkiXj2/
 IojVCZZTcfOi6zTNHTLvJxHgOcEXHS2s1YF7GER3XThOJ69Ol7utgLKSvVfPTHx1o6FGdGhZAWFjitDYWaCkpaG2cjmcZim8Fok4/xeb5/2j0ZF/touak+mmRRvWuF0EmOwhrmNdgpHkXEfxijfgPicvnpl1ng4UnkXF/83WFpW8vhq++uPX0Np6D1PnyhylvX/omYROQkU9M9Z3IgvB2MeZF8gZIm0knid1LwpqUnDNTtpuL6AdIcfoNtwFrEt1MeCgNXlOf2GnHosS4HeAr16tusPKlf8KSzSYKEoOYXcdLqfIThTaQqySrNcuKJFXynk9Sdg/QSc4nnwS+CfLRQCDhV+nkRjVRU+hjPJcdgDQs5hEWdPVn05iHamBCMJvZuLzhU+jaGCu9xAdgpD4Z2qxeKN8W2iO+Zx8CwV4nC3YouvaVg7I8XpjNTukHQbaOa9JW3La2Q7OoIVOLTvY3TMW5qfXCvKiWu9dC2Hq6zmVlv/Smh6yN1TptG6CtMmqeqg/WDGnZNYPH/uxk4ocBGC4W4OsRm7zvQOAB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

When the owner of a private hugetlb mapping fails to allocate a folio
for COW, unmap_ref_private() unmaps the old folio from the forked
children, and marks them with HPAGE_RESV_UNMAPPED, so they get a SIGBUS
on their next access.

hugetlb_unmap_range() is supposed to only unmap that folio, but it
clears non-present page table entries unconditionally.

A child can silently lose its COWed folio while it is getting migrated,
or a hwpoison entry or uffd poison marker, without HPAGE_RESV_UNMAPPED
getting set. Consequently, it would not SIGBUS on the next access.

Let's fix it by ignoring non-present entries when unmapping a folio. As
the folio is locked, migration entries of that folio do not apply.

This has low urgency, as it requires a failing COW allocation in the
owner racing with migration or memory failure in the child. Let's not CC
stable.

Fixes: 8c4894c6bc79 ("hwpoison, hugetlbfs: fix "bad pmd" warning in unmapping hwpoisoned hugepage")
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust comment and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index befa2670cb03f..2c13349863bd8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5457,6 +5457,14 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
+			/*
+			 * If we have a folio provided, we only care about
+			 * present page table entries (folio is locked).
+			 */
+			if (folio_provided) {
+				spin_unlock(ptl);
+				continue;
+			}
 			/*
 			 * If the pte was wr-protected by uffd-wp in any of the
 			 * swap forms, meanwhile the caller does not want to

-- 
2.56.1


