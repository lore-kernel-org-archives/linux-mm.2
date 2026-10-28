Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF941606A339
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnuvrBYU
Received: by kanga.kvack.org (Postfix)
	id 0324F6B05D0; Wed, 28 Oct 2026 05:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00AA96B05D1; Wed, 28 Oct 2026 05:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63436B05D2; Wed, 28 Oct 2026 05:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC7FE6B05D0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:56:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5ECA1C44F8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:58 +0000 (UTC)
X-FDA: 85371581316.30.542CEDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DA54920005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BnuvrBYU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBVhEWu9nfuqFZTQHurOtPzvVYkt3WEwnKrb2ymcoTk=;
	b=LRlan2mq2wZ6jUlTGBcTejgBVH5K2eyOCBctm+QUd5D/5QU9C+C7ApN+6ojN3BefYkVc7P
	WCTlY1cMFs0K7MIWJa16AX/83vRCf5eLfby92dwEh2Ll527MogJTtBUukAseUTgk8xqXxK
	CG3fnyQqELfQ7WxXO0NADK/ycwhnMQ4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BnuvrBYU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181417;
	b=jINzAj9ocTaCjC4gs6NO1BOZZtQztOvyvnayVvuFRPt25Iyrxx0fOLKMX6r1u93pQf199H
	TT0ScyQi2SMLKZZ909ZXwrkqYYzEjAvYG2TIx0D6bWHc0/hpoCMB+o3UrS1XQyqa80VJSw
	Ln0Wn3rJ54rgHcMMNlWwyv3IrNqihyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 727EE40E0B;
	Wed, 28 Oct 2026 09:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F8F1F01828;
	Wed, 28 Oct 2026 09:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181416;
	bh=fBVhEWu9nfuqFZTQHurOtPzvVYkt3WEwnKrb2ymcoTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BnuvrBYUBhtuVudpLVQFk7PTkGc1/2OHBORTKrrdUPdhyyLTA+aEAFCQYcKtVsqpq
	 JyeJUGzh0K9NYkWa1FeM/X/0fw+efw5OHCwcktCgxNrZZXOvOvgU+zU/C4cRREShNE
	 yQQBbF0QlOATqnnD0cXbnSfnREofEE/T0eX2KY3pRTpuDfCD915Y23fkcVQhPITddk
	 3MI2Kf7CEVUuU4AJVd4AaMeARN99dDGPGgd1nz4sNveyeRSIZr/QJ65dhUWebuOTPm
	 hBCASdPeTl7vqkF1rcwl7TKhrB3aFt6aXQerIW+szxb60QiDAxTGOPsbLpRAubdySg
	 6znWiHu38tJxg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:10 +0100
Subject: [PATCH v3 12/15] mm/shmem: preserve allocation errors when
 swapping in large entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-12-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1547; i=david@kernel.org;
 h=from:subject:message-id; bh=4yVKTbJ/EVLH2SOhJr916+b19DoqdwAsmSvxp0HdkpE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmuqMu2y/ehinHT12ZFezdr10RHv3XUbr0t9D9bnk
 m1tfBbQUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwERaZBj+h1zZd2pVrdKq//NY
 xWZNiEgx+ucawuTzgW239SHxP5MePWL4p/fu7+SNXUE8P4rW/s1/bm/NvCzr7pEpCb/uJfMeysg
 y4gMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA54920005
X-Stat-Signature: sper3dgwa4zptuaqd6p8jm9iy736za3z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181417-859283
X-HE-Meta: U2FsdGVkX1+DO+7KqATcesHRnrYOCOj3kQLMHatIbtFo9W1Ccap+qd+R4g3RAALaMNS35Fw5pFtH6GgoZpnb3PkMLIq74ssPB/AEbrICv85Za3CodHg70YuC/w7EhiS8DDmBHzui7c/C7Ll7RvAdQ/ksE0TYRqLIxjg7r/BLzk/TdNr9vtdYKcNMEy4TcwtPtM+DkAsOOicGnEVFqNMDW5W1a2+pjOvvj8iEvq5XhtrMQUEjtx4UwGaoVPHEkOsNXmJ4XVgOAnBaPVwWXcmB8dr2lYMJap2piIMUQhFY3pOJvcH25q1RYBY+Oa+2LwHVWebdMK7M8xE95UIxSYxjRkz77dXfTujgUGNEwN2m456KeLtrWjesS4Jr9p8HN+xaPqfDfnI7G7RD03s3hh6YKTttVaPT4bph5ZRKeDYsBVa4jTnzwEXOfrCi4mXOZoYb0gxoRGFOTST9uRshDmD3kj/TngSwe0QRHdBX/N46T48zwbI3gOaenLnRD0WGwMxkLsy+cwSr50UiF129jPvAtYIrB+z5AWCBATWhzNxJVNkvgGk2K99yW36OLV70lngDooPramr9SScOQio7ofDMNeJqP/qQ49/v7GOKZP9OnLtwjgh1yVVbahGlhhMVMKap83ubuy2H4rqgkoXPlPrT5mQMaDmha5oEgHb/e9fIbRZJBQq2Q305lFtH1AkVklzQCMKojOBDEEraDZzMnUQsSjggsxZK5DWh+DMI3n6qYh0EgXiWy7y7osZWOMnt7nDM9Jyg+ivvZzysulFZAvjQavTYiE04afjHL+kaR3iemqhSVqJ8roeq+XDxMvNfjUK5djgrkZyR7j/heHYdzpVR4ItHi7sYG0zi1KnulYqkb3Wz+iCVO7wEAIaj4AU4GM33/2gQZu26XDPdVfKSNvDP4aB6tzB+218oARlx0u9kwL5Haj4F3rXaPPezvSTvKqX35+3K6wPjOw/RLTfqr5y
 OUo2Izce
 TMcEGVsBTZHJ5I6T2hC27lGh57ZNb3DtmgTECLASzmtZajeyPzMCAImwM9n9e4zhCzSLce3hJOBjZdeNuV3HvDSIvcWGwegCYCrfHxMfRBNWFk9Pc7JfabA/rrHQ6cGsNuSOzmLQ9xorIeF2m/5hgNGVCxeRNcG46gAPFtF7l0fJg8OodoOwqQ0zvlXoQMsRZ8ZLnrPyt9lLm4dz2lWfFy0DMu6pvuQiT0kBbiCzKzNCzk/EVH2GDeB/LrFh/Ux2DL3oAFuMBtdTMHpZv0mCJYSgRGoqc3VgmbsALpL8qzWbo/ZwuBDEc+1MEPTR5aPoWCaBwFkkcrPku/iba8rJDwEgk68/V5f+VejInwJDGr19WXFKHNPBve+jFGsf798vMmKarOXSXKlF3C4fpKaIP/p7RgRmdIYrI20XhooWRkn7CJ1jGiQ3qM0vxrtlXEpG3XVN5K7m3o6jC0hQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_swapin_folio() adjusts swap to the requested slot within a large
swap entry before allocating a folio. If allocation or charging fails,
the error path compares this adjusted value with the original entry
still stored in the XArray in shmem_confirm_swap().

Unless the index is at the start of the entry, this turns -ENOMEM into
-EEXIST even though nothing changed.

The caller retries -EEXIST, so persistent allocation failures can leave
the task spinning instead of returning the error.

Restore swap to index_entry on allocation failure so the existing error
path checks the original entry. This preserves the allocation error if
the entry is unchanged and still retries if it changed concurrently.

Fixes: 91ab656ece13 ("mm/shmem, swap: tidy up swap entry splitting")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 59907556369f..da2f5cd37eee 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2552,6 +2552,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			else
 				error = -ENOMEM;
 			folio = NULL;
+			/* Make sure to validate the original value. */
+			swap = index_entry;
 			goto failed;
 		}
 		if (fault_type) {

-- 
2.43.0


