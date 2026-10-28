Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAD4606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T7LvDeA4
Received: by kanga.kvack.org (Postfix)
	id 7D2666B05B1; Wed, 28 Oct 2026 05:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AACA6B05CD; Wed, 28 Oct 2026 05:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8586B05CE; Wed, 28 Oct 2026 05:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED406B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:56:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6788160C20
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:43 +0000 (UTC)
X-FDA: 85371580686.11.1A09FCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0C7B91C0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T7LvDeA4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTONV0wfYTEoLkmIvz7RQ+tH1UPTg8CBB7eyk2nMDtc=;
	b=TdgDttW7euvf6gqkv6a+MOAlfKKilygOA6+f2fjmo6UuZK3MiueDbpYaJTzy1IzQqrsyhn
	EjWClIrUnIc0gfsfyxsK8ThqWqZy84IroTF3dRCbz7qaT3NOfKDGwTtb+50jGggDPTii4h
	EjBV+YRldCLyrMnzzHBpxVMaWC6yVLU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T7LvDeA4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181402;
	b=GH0f2PkJdztHeAPYr5kdW0CadLFqZMu5oSFCthwAiOOSHW3IdcE5Zq7TTbKlfLGmsahCkc
	24A/yxwvVP2/30yY3ELySg0EGMF8UYkLHbUcUTchz7pUyCyO10AnJ0wL//+hvtP+n127fm
	r9q7KTo/RePsd7CPJkH8kTC82LcZEbM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56AD340094;
	Wed, 28 Oct 2026 09:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9411F01828;
	Wed, 28 Oct 2026 09:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181401;
	bh=tTONV0wfYTEoLkmIvz7RQ+tH1UPTg8CBB7eyk2nMDtc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T7LvDeA4NM/lf+CB9jzmQfHAxXqaA3Ilna6y11k3BHwLYimyi8th7awsune2nKO06
	 9H2OBF61PJCX3HYXXz+7XH7SmhmgJeweeG5IpaOZaOOv1yL7SH0nhtRdSMcr96rkQS
	 NF2FrV2WybzV8IXuBcvvCxOANd7SfGQAjGm4WVcU8DkfAFzoZJ68tcUhc2LYaBDsb0
	 td7m++OEXW8bXS7MrcK8hBRbby4mcy4stf+J8LYOQswXRivoQ3g64SXlYFVta8lg1Z
	 Oq951tfV3xmBNNEkjbAxrjVA2tfiA/V5JEhPYhZcV7gRc3neSLCOlNU5YwgMJDMH8K
	 anruem1gGbZyg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:08 +0100
Subject: [PATCH v3 10/15] mm/shmem: rescan after nonuniform folio splitting
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-10-4ce3baf2db4b@kernel.org>
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
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2061; i=david@kernel.org;
 h=from:subject:message-id; bh=kDSUfEl5ZNv/axp1FN2MBeYxXzEoqliEBOqbPl2MeRo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmu6oaGktF8mefv+O1eUsyMWHqrtO7JsXqaBY+PcJ
 6u8DunkdpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARd1ZGhlkzfM/qP2F9KKC8
 gnEd0y+FevO9fEtWz1a59/90bW1m30mG3+yfNC47XDzyfNKO7SsaMry3Pm3dc/Giy+E/DhJcd+d
 G72MGAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 0C7B91C0007
X-Stat-Signature: mrhdxms9xgwsqwn4eg3bbx5otpjzme5r
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181401-945128
X-HE-Meta: U2FsdGVkX1+LXOmm5yNRhTIAZcrJAJ1vnO30kq99NQ3C9aF1HDFHxkLgsAKwTlSSbwBSn1/AslvbCkDuGFGNQt8uTmQyuOa3mEqxI5ZjHxEs3ng2YkIyfeLdCA6P4iG1AtFIXMhEkC4y2Khc3usT2M+B2EmzmNASR60A+kiMcc/QTuCd/x3ZQ9QpV7zXit/6FYA6FU27Dg1ERirqyZkbYtrVELhj4GGDNHwyec8L7Tb8YZ4nUAyAVv+YQ9F5SNna21B8b1/AD5/0/SJNF22WUziTSUTGuoipEz1dGQKgbzuCpbR2TpOKQRv4/Er+AHBfbdmPf+4OMQGI+NjzIOqlkWNK0IY/2Q3aN4gD3oYiQVVbdIqQbReQUNM8h4D/D0aHQT94TjayBzQkw46lqSNVSIpj2jxgT/YvmQgdizwq4PcwCveXHsW+hj5nnFAZChelBZIr15Ysc1BQMOai+2UA8uoLqRETXcHzh6mVjZ18OGI9ZfQycHOyTm/ikMbTD4IcDLFXvCA90qROnrKQg8bkWydCydTJUUhLdvngRVXZIP92zpRiRxwo1CizcGobBH7wtBNWjr8gnidbjo3EzHng4muH66ZhK/6bIpoRbJ9GBkQFaRvwM6ED474AQq0wj7sPTD0pIF2jjuRnLSlHgHKx+NOlbuv/nD1W9zw4FoRAAM5vZmG99bXmrlXAyjVtVemdhOKvKiXxtIMJbsQby5H1gV2Qp5KaUXOMugJAmWZLO7/EC5/KSQ9GIUZlzL0+ievMHDPWWpJ52ErScpTX64IEc2IHg54rS3g5ULCLB6QQZW49Lux85r6n1qxBTrVsY2RbETcjFqkxqFkjhg4zaHMRJMG/t9L3XWwu8LxgaxelnikF0Opy/zod3jXKRlq0E/lhFBCJcdTrSYBUGNkEDTEAZirppmi4dgQZdQFnaAgqrSgjLwagVNrZXtbEkMf756bDYG5e8cp4/cZunFP+7w6
 5a5w1R1v
 3tvjrI/Urlj1kYksaKnMVWXGPtjOst7ZEkhZZ4kJMXMLRyonSn5+BxB8o3t8LrgO2DjzHDaoCwp7YcAckk2xs1rN/9ENonOSrhgt6k9WvYQrecj0/0rSo8ez8jfCSCQJi5397YdsitCEFYdOixa8Yr37IDjdhGIdOe9bqDrxdoTvYkkZvC4RDY1bdrlp09w6QCHHwW9HnNtHRXT3CG1IWW8emafXjUlmOV050T/pX1zAfF2Twzb8qHhVcn3c/u3yyYkdBqRZGHwwlP626GdTl9hPNDJY5x+KiGJDJcnzXfZPibGvjZ6ctBFZ1FCmCQ0Der1q70OEbItV0LJSjstzdgbVNWzyd0aMuMzu/p8DlpMxqH7xqEBA2Z7ZtPgxNE3c3NzsZqY7D1w7FcvLMi3DcAV1aXturAG/Ov1wpbFMMcKlPqcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The final scan in shmem_undo_range() restarts after a successful split
only if the original folio is no longer large. A nonuniform split can
leave that folio large, so the scan skips the newly created folios.
Hole punching then leaves pages within the hole allocated even though
they could be discarded.

For example, a fault below the hole can allocate a 2 MiB folio after
boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
folio successfully but leaves the original folio at order 4. The scan
continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
The hole reads as zero, but the pages and their block charges remain.

Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a686b3d77647..21983cce9fcb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1478,18 +1478,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				} else if (truncate_inode_partial_folio(folio,
 						lstart, lend, NULL, NULL)) {
 					/*
-					 * If we split a page, reset the loop so
-					 * that we pick up the new sub pages.
-					 * Otherwise the THP was entirely
-					 * dropped or the target range was
-					 * zeroed, so just continue the loop as
-					 * is.
+					 * The folio was split. Retry the scan
+					 * to find the split folios.
 					 */
-					if (!folio_test_large(folio)) {
-						folio_unlock(folio);
-						index = start;
-						break;
-					}
+					folio_unlock(folio);
+					index = start;
+					break;
 				} else if (folio->mapping) {
 					/*
 					 * Splitting failed, but the part in the

-- 
2.43.0


