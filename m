Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6120860A263D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i7mb91Qq
Received: by kanga.kvack.org (Postfix)
	id 84E416B05D3; Mon, 26 Oct 2026 05:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8259E6B05D4; Mon, 26 Oct 2026 05:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763396B05D5; Mon, 26 Oct 2026 05:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55E806B05D3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:42:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4F34A82CA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:48 +0000 (UTC)
X-FDA: 85364288016.19.3372432
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18246C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7mb91Qq;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84TwrUWL26n6L+6NQSuJMlNmIQWaVGoOxoCZs9H9buM=;
	b=jr0m109NcpGvNACPYsS1+AlsLp7g7rruBdYj98r9jn6d1KmGG0syEHvOagsr0YlGcAHZNm
	vXlCTU7aAid0zIgOebXVSibKOolYdMqyrXE4IO/q7stPP6qZ72qiMvUoEcS2zMUSMnblt6
	GBPbUISWpXW2f7lOqcg3bu++InqmEMk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7mb91Qq;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007767;
	b=4ZGOblATXLU6JOXy4XSMfQ8nhmV7FUcYnJoGCdygu6m512VbAl4SAz4cXYrxZgxKQeJd9i
	hcfTUA2vY5qFubRyCgPW+0n7eD0u1lzJuUwCdASm1sCQukx8mIFmCEeJPK/tG4ZBDdqUZ5
	UOvlL5eckaUSOeZUsoV6IQefD/ud8vU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA34D601EF;
	Mon, 26 Oct 2026 09:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD0A1F01485;
	Mon, 26 Oct 2026 09:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007766;
	bh=84TwrUWL26n6L+6NQSuJMlNmIQWaVGoOxoCZs9H9buM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i7mb91QqykwQoDgzWY9M6nfCGF9CtYL0miYdF1FjCRh0LaqHPRJb//tCmgbKC/umF
	 WgVtyNPI5exENTXXI6xwP2+99qN9n+9hrWnjuf1xfV+BNi2cKGams7B+AsxNWyQxiR
	 bJlInhJx9qAq2tEv93oHYdzY4dxGjx+gnA1bBqwYt1dlsykhpcsPO3BNK+7Mvmq4lk
	 37s7HkIWBH3DHE+TPd4uELH3PWaS4exrVNnGexWjkfvysOXcvx4L3B1Apbqq+jSy/c
	 3A0lxJUmTALBaoajpr2hTpbrtd1EBQjh9efnquvyc7chjrx5YlNdy/j8/JRjAnLKB0
	 LuVgsqs5p31bw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:49 +0100
Subject: [PATCH 16/16] mm/shmem: fix truncation of files containing only
 swapin-error markers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-16-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1500; i=david@kernel.org;
 h=from:subject:message-id; bh=IWKD21922t1O1049MId3yRDZkDpskSIBwZEf2NiLDd8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK0h0lVU6Mlkwfkq8/3HWSbnEHS8VvvN47eBda8snY
 nvuQMinjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACayKYKRYd722qp1zevZ/C8e
 8VttVznfrGVK/cnM5SvPs0VZ1men+zEy/OSZbHT2zvkO5zar7b931FU7pyTu/2a9sV3p9sQd2SK
 /mAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18246C0004
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 94s1ezeoqd3ac4xsao468mxkaojob574
X-HE-Tag: 1793007766-827343
X-HE-Meta: U2FsdGVkX1+NvranN17zwBlvkQ72vwiQI/4d1iM7dWG4sBPKRge+XzW3/7zMt0tiFJm1qSEp8RhUFLAdJF57JmY0QX0yGcetBJmt7jyMBVp40D754NOq2YZ4aO9mNjxfZxqoTMv0o6iHO1WjTIRhNiPP0zohRToEaKYMZqh/9CKDcbuR1QgjJqVzXG1ynYxSeM+47VTs2A4HiRBWxM/tiftoO1cWqaoZkmIZpKYdKzSaKAy+duK/YOhKbXYbwj1sqIAsKbioOGF1A88CPkyUiB7aBpfWI57Yqap+PAfZtBN1zHF5x2wAYSs0gOExQ4nNABaYWLMKLfQRJUZyTQjK1mBeopYVH4L1zgzFJ8jKIX9h6lU6cOVD902rpaXOEVo3CtEYzCNJqsy95efVmLcdDmv/GSbmPXnbWB4ICq2mpTp0v8xaPBaW8spabJf05XuLEgcJfV/eHT7i7poh48QFANiIqNo/BfvB48yhXjV67G9HHFjXcHxCMSus6HfNgZ6XWp+fKHTL5YxX+0qx/8d+nIYgGgoQl2czIs7E/CYthD/BaEUAZEtpc/1cm4Y1YSRTvH4lO174vgUHgTvRSgiF0LLF3sZp6FxW64mHv1dpxg/oqioBoYJfSj6QD+Bp51IoCo0c2e4mYwdYppb82CIsj83OmFgptCPIZbw3j9qliINzf2ZdApKY7/zh/xbeiAtwvQgYKDgfldngwprFc8nEnZvEGE/1RgdZjxFlWnixfZ6We7pQTivN2X9eijju1lz6H9uHhO3RjbypP5lLqRyb5uQdjAgp37hUsQCAvC6MeqgxtCOvmuhn3YNpBmWJrh/CEk8aTgA35jB6dzAndcu3O2yGE93fx2l+IGeJUZN5yyizTrBCs3GoSSUMuzQ/Pia0tfSEk5ACUSdU+2snOM8g0ZLusZzsDrbSq1cxnnCL63Yq2JG23GpesXFVdctBuggPf1XcsnBVq3wpYVkBeGf
 p/OeD6n/
 99DzswqnRBKVSrvkHDDCa0KoRSRqp6SYEIQqGXYvK1jwgatwmVSOQfd42jiqEUQp6d3V4k5o+i+AAWqU3JKe4nx0cZhDvfMwcSBltJmX95a1xI2u3Ld1LxipTsms5jAY7FtHNU31T49VZ0F2swWYhSprV9PC4gYiKldq3AVglxd+oCwwyP2R9Nuot04KmAZWWdmZ93netpqShev6iqNu3f7A39OngQi3k7z7r16JuoYfbx6QiHP1t6eiH7BSNW/yeA5a9+LI1y/baPxAzUR4CsWsd5uO4ph+hXsaX1oPDxbUMf+xt7M5C8YVwdIytPPkaO88Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

It might not be very common, but we can end up with shmem files that are
composed only of swapin-error/poison markers.

Such markers are not counted in info->alloced. Consequently,
shmem_setattr() can skip shmem_truncate_range(), leaving the markers
behind.

Truncating the file to zero and growing it again will result in reads
failing with -EIO instead of returning zeroes.

Check whether the mapping contains entries, in addition to
info->alloced, before skipping the truncation. Keep the info->alloced
check so that shmem_recalc_inode(), called at the end of
shmem_undo_range(), can fix up accounting after reclaim has emptied the
mapping.

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index f5b5c9a312c53..45f6c34f161e4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1602,7 +1602,8 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-			if (info->alloced)
+			/* Swapin-error markers are not counted in alloced. */
+			if (info->alloced || !mapping_empty(inode->i_mapping))
 				shmem_truncate_range(inode,
 							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */

-- 
2.43.0


