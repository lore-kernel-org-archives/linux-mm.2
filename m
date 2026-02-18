Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D206DE9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EA7D6B0088; Wed, 18 Feb 2026 08:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA0F6B0095; Wed, 18 Feb 2026 08:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC9E6B0096; Wed, 18 Feb 2026 08:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16FBF6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:06:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCF151B40FA
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:28 +0000 (UTC)
X-FDA: 84457601256.06.7A3CFE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 597851A0014
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gxh1vQW6;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhZqS3yjpgor8cKktiu0DaJleagvDsL8Rot+MNzhVWg=;
	b=tn7+1STVMBTsrQpcPg7hWQiE94RTfD2CVCfk1WQNseeTGxo97GQdPqyJuddBchAtfMEa0C
	iVk3zCPKxVxJ8yRzqyJ3Tx/RKJi+qNasTMF8uKyshgTkpheUbs7bbuPT5BDspv62/mb801
	PBVwugf7dRY5D0n5Uy3/9e7mTEbRDqo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gxh1vQW6;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419987; a=rsa-sha256;
	cv=none;
	b=qhLnkH/IaIv+A9trkgoNPOAla/Hf4KkaO0E5sSApkn0OxYhCEq1PkXYlRJVDXNEpS/1tEB
	CdStCfuiSpQdAdJ60cLxvEdKH7VSWXyfE2k3vggamV0iFJCPOX0wA4j94ZR/tgLWTqZPDf
	qtjNxlgpZUCdx9YIemjPTN98tZS1WzI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB4466132F;
	Wed, 18 Feb 2026 13:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCF2C19421;
	Wed, 18 Feb 2026 13:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419986;
	bh=j/VkrB+wzOf5ArcAY/u2FQnEjfTsdBcW4IzAHEUpdWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gxh1vQW6jw7hAyMUdM1nAHNZdn19vjeiRB3RlWQoowiFpi5QbM8UZILUUMlgllM9z
	 5pfRQijsu+9gFVTcM4FINYYfiyC67haX/1iajXL2vqZcBxrQyc6tVLni0WVQWjEmaQ
	 ZiCQTnO4D+9vhK9f8prmkSkWGudS0YYlxvllLRoJk19zLt9arfXN48pXGV1Pyxyn9c
	 qI2ykgriYxKUKN5+68OJpE4JCtDjcDGworBoOmB/cU7rh9QMgcH2gkKeuHTQF4u5cr
	 nWoWYNPYMQjEL/U5v/Z7+NKMcK7L4vEhpyeEa+Iu8/1oHgqOvtl0bQW8bBUu8/Vmxl
	 ytBToFGivkpmw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Uschakow, Stanislav" <suschako@amazon.de>
Subject: [PATCH 5.10.y 6/7] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Wed, 18 Feb 2026 14:05:51 +0100
Message-ID: <20260218130552.55727-7-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218130552.55727-1-david@kernel.org>
References: <2026012610-absolve-ducktail-3c64@gregkh>
 <20260218130552.55727-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 597851A0014
X-Stat-Signature: ru18kub1n3rez6ry7nwoiom9zja7ag4c
X-HE-Tag: 1771419987-101475
X-HE-Meta: U2FsdGVkX1+8YEOWL20PQgkDLODqgxc0ckbWQYzDeBMgcU6pAt6mbyU7hDQxQ7z1PVB+5j9mdqtqTyzgxA0Z37ZoGSJZ5qik3JHBsYDeUM8ZWEpzljJGan+MXyoDTdMlc7AjHZghjMzSbNHblLigBe0IDjvUFXkpM9Tn1UrDXIyigImklLX26bBWCdxCK92N2ln6pmLRdXUoEsUd7KGtZltEIuZwkjELiA+EKJUibymotgWklrqWUBNB0JGhVV/g01JZn9wCQf/6xi37cTpPgaoYfEIu5CDdAy5hj0lABzQrBQKPHehAAjNKKoM/GlFXOjBJXqFXdkml8yyWFJHmsAkeun77Vs8EGLoT9XKrIZ72DYJEDYkZz+l8neVy4n1zxewryD98dF2ndWSQGQ1Urj9AzprH6n1SMSTObduon4Br08iWjM+FcUtctffl5TlqzlBJye47IO3v9PAcf7Vu3ssFbpOBYow73Y7ZonJcY7yoBVo6k066euM1+Cf+eflA3L3NyUrcO3fmlYag5LiVn2CS07vqrBSJSAdKvIgaud76xOhsLe1A9qcZHNCodzPy107SpW+4B3sBIYXaKNUzS8DErArirMKXfIzpdFvejvW8ud2teKifX+6FiCw1AL12rbk0Xo6VanTz1ZpIlgGZRx3gpwIqFE5BN4xr7aSaSjJBbTPJ0N7JKvvReA+lEeeQkaf0XlUiSmKuAr2Rh5N1Y6iD910KnyJg91CHxJFc0ZrA65fAM64RbhDppzToLuEHTnQwVVTSpfPuhHwI40SPpSnjA2ptiAg7eSHDbVCn5cRxtLg/W/UbQGB2qQCJXh2UpNAv43vnTfla5PuBJTtUFSJOvIFYKIZ2Qnz7dGM1Fruv777YT1JD09lnHAQyGb8dpMELd+Offanw6pg4ttyVC+DxtQi0LGezOCNKIFSrsJfNodeykfpEC9/iDPGNcmrs/v5pd/SC8/96dooOQ87
 yQ00QCr2
 LqAwO+axZLlx5A+h7aqGiEE0I09U/v8AVpoQkhj3ZuHl27z3BPIrigs8Tah4hB4iBFA0IG4aH8MNyvRSULdm4jtFVynJuDjJ3ySYwhRh6NzzSsW4fi3Kq9yJykGhj9OAqJt5iCdm2MXyMVHQKnv4ZB9HrJmSJInn/cRbW1eW7CkMEWKInkYHbVa6DOYM9r6AIRo6LDygWsZlQrtPPbHbOp73GnYvL9phD/UJTHT2IElCNe8uKEns0pIgkooHJYTe0jO92J9puv75ZTQyqa8bvyTE779F4hgkM2R9zCedS4l5TTqVDIuMI4EwoUgyFQIRLN9tNbYH7g6JHFezgMMsh6zQBSPvyC/U2ILAbpLYYtaRGERJBlYpYnQq/nrwZXuMvOu2lcRY7G80zNwECJ9oQhEW0YflyCbZ6Jl7vB0huFAFsvQaATV6h+sOpK49bWBwksADQzs/w2/K8OemucDBIAMRGlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

PMD page table unsharing no longer touches the refcount of a PMD page
table.  Also, it is not about dropping the refcount of a "PMD page" but
the "PMD page table".

Let's just simplify by saying that the PMD page table was unmapped,
consequently also unmapping the folio that was mapped into this page.

This code should be deduplicated in the future.

Link: https://lkml.kernel.org/r/20251223214037.580860-4-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit a8682d500f691b6dfaa16ae1502d990aeb86e8be)
[ David: We don't have 40549ba8f8e0 ("hugetlb: use new vma_lock
  for pmd sharing synchronization") and a98a2f0c8ce1 ("mm/rmap: split
  migration into its own so changes in mm/rmap.c looks quite different. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/rmap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index e6f840be1890..315d7ceb573a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1490,13 +1490,8 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 							      range.end);
 
 				/*
-				 * The ref count of the PMD page was dropped
-				 * which is part of the way map counting
-				 * is done for shared PMDs.  Return 'true'
-				 * here.  When there is no other sharing,
-				 * huge_pmd_unshare returns false and we will
-				 * unmap the actual page and drop map count
-				 * to zero.
+				 * The PMD table was unmapped,
+				 * consequently unmapping the folio.
 				 */
 				page_vma_mapped_walk_done(&pvmw);
 				break;
-- 
2.43.0


