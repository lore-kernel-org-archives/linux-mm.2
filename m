Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 369AEC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343996B00D1; Mon, 20 Jul 2026 10:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B686B00D3; Mon, 20 Jul 2026 10:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231FB6B00D4; Mon, 20 Jul 2026 10:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1F226B00D1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7485CA011E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:33 +0000 (UTC)
X-FDA: 85009415946.06.4B9B789
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86129180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YVzDPRz/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mra/Bn1elC7JINMhmjeUqxXqzX/2I014ABkBD0hy8Go=;
	b=FZGcMNJx+md2cCvcCanYXZ5r6S0LbepCzNRr4OHgZl6SpFxqSzn+QRVACAGPkNN2d2oOlB
	q0H+FhD2NeWgkEQSuHnBFf76aX6BWfp4HQeY4n9i3Q/c1c2tbLYD7YY6Cqpeu0+1y7njKO
	edCzr8B3/sYf7LsvsMpIvzhnKTo+OMk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YVzDPRz/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558431;
	b=nNXXPaAdqcSMZDKbpi/Ywt4Pq+wPxREe3b67nC0q/VJqhBYnzh+/nhj2kIRss0+iJtkr0G
	lGfRyZdqSgdycDis7b3sz+uhSN3oFHBNb2mWnaQ6Xgb82O4t9vXIjgyVnovync9cUXtiHJ
	3RVj/0eSPLWmmk+ESxjPE/MHcypU5RY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A87E243386;
	Mon, 20 Jul 2026 14:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06AF1F00A3A;
	Mon, 20 Jul 2026 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558430;
	bh=mra/Bn1elC7JINMhmjeUqxXqzX/2I014ABkBD0hy8Go=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YVzDPRz/8pWQGydFHClApmZFIDciQEAcRqffuZwsDx5Nkjenf01XZpd1gO1Z7MX2W
	 M2LupGQUoqO+CAvkthcCA2gCLzkyRMVuKiYn159qFjZn/shoesPYrBuY7/CnutCzL/
	 FWpz3c9kvSAEVJwuuowF8AWfbIzLdJI+J+mon5bjp24B2y7VOeFirgCZv6F5tbcuMa
	 dPwX1WoimakIDd97vAOJDXOzaV3xuraTLcY/TjthMe7Dp3y2EvrX+vych5oLgPhdtp
	 gSZUFF6e8sue5T+8SfRLefCxKhC/U/NftSbFILV8MbSh1g0GstwEN50P4VO4NmL5BC
	 J4Cwfk/2hnh9A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:36 +0100
Subject: [PATCH v2 10/15] tools/testing/vma: expand VMA merge tests to
 assert virt pgoff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-10-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8009; i=ljs@kernel.org;
 h=from:subject:message-id; bh=8h/dGKX6WdyoHbJj3ZRxxHcRRGvkZRZAPk6BbLLv6fI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN7kNsdfyTTc6uIoav9y69y7s65aPPHu0+yanjr7x
 VTTwwr5HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIlYWMDLNb1DpkoswdxQIS
 vv1ZUXNm124fTicRrgXzBf7UGk/5WMXI0Cv6ouqJmovjIxGZB9kvj9V1F2torV+fqLpFfNrRdpt
 ZjAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 86129180003
X-Rspam-User: 
X-Stat-Signature: tw38a3n99iezxbjfz55uzb9sdqijw67k
X-HE-Tag: 1784558431-395494
X-HE-Meta: U2FsdGVkX18ZqB0T9llo50oVWzgzT4aQ76Z5yml0sp8kUZDKuDdoD2kfLePIDnxFNQa3U6+w/Tjpq05r7sm2NqbTAFWJPc0RwXkWRjM330SecBF9xLJk0xzeRG049KEfOv7HtaJJF/56L6DZ7HiHIie4maBKmyCOjZjq5+LQASIzdfzD1SkmzXaMoh+CGgY6sIOUMSikH+x3zS89nl0+UZwtAd/610NAJZ6iZAtKmXN57iR+EeGZwCFsAo+FutqOLG+tmtDicGPjfj4bzxEHrE77sEYtxbQHhfTeT2icHAss/OtMhf+OgoC+X/ePaGVJYEcmi+wYceEYP+6MOzfrIWkIdmDl+eh6PtKHe9cfu8/PML8IBdP7zs/4NPhNyF9yc2TiHVKVGcoAM4WtuZ7hjq2PiUT0wPOzsHuQcdK7oEtq8WMgpCdBETrxZRyxLcHQDsXCjw6RqYo2/pl/kCjHVlJd1nOvPYj9Al5GaNT57qahT0sbXXEwyFld0Yj/X1gvrleIsIftKHNnRBmGFAGVdooSFhDFnsBrQm/E9b7JzbNDk2J1jofiYQeq5X7XC4fHAMtLcioKN1dj5qOtp6McYzGbvG93iNXhCr8/VXQuqv8GTgnt5PkgRmFO6/aAhqC/Roac9g6CK+aJJfbgvOCHJPiwNEET1TP5Y7+cYKyHb8VJ0B/NhYMRVzgkr5Lk8/Gt09oSoA/4YsrCSRgSZ6crp+djdTQNZLO0Eol3t4IGr9/za3m1rn8oAKvDudCp/ig7/wTF2VmgwuncjPXEHRBF/kxOTBtFwioNuICTyNOzrc/2xbGqk7YOfJhJ4yR7UhhRFRax4wDohlOnbrZDDEaqpZvKeeE0YIH0AYkJdVxegDdpxkBUUk58qzobE4DhoeYIqJEx66K0GmcDA/g5CxyVdGjCLU/oz/EPAfMPZzcsOLfLraCTYarC0NuhDFcpgTh8hDBUzGW0nElMhqDcS2t
 GtdHC4Nt
 MNsBOwpV/6BrmJHPGphGHE9tDXrDGwFHyAopEBgM4kz3xWIc7BmNlZ3ntVz+rgnnhlEmdP02l0F2o67Ign5PC2soSPjiZGIy/v5410IQv+SO+dOwR0akDEZwKpm5G4djsVo1akBHnIlBBuqsNvCiPqGumAYKfSYWxndeDRr77DZsV1EnIIKTpyw5HhIOkI2b3FjFJVs6Gl1H1o9ALz6BV3tj7YhWTMG8+ETnTst7Ea0G8hPxjaXKd1foxwCJ166fcS1vvUYT0ptwOsOjgIp6G87fXenLBxo5dMPhTVbC6eOaYigxoFfrl2mhSF99AuYuJFj8a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have introduced the VMA virtual page offset attribute and update it
when VMAs are manipulated, update VMA merge tests to assert that the
virtual page offset is as expected.

Also update instances where we could use vma_start_pgoff() to do so.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/tests/merge.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index 48418b82b01d..89ba273afe4b 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -121,6 +121,7 @@ static bool test_simple_merge(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
 
 	detach_free_vma(vma);
@@ -153,6 +154,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 1);
 
 	/*
 	 * Now walk through the three split VMAs and make sure they are as
@@ -165,6 +167,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -174,6 +177,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 1);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -183,6 +187,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 2);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -212,6 +217,7 @@ static bool test_simple_expand(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -234,6 +240,7 @@ static bool test_simple_shrink(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -346,6 +353,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -367,6 +375,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -387,6 +396,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -407,6 +417,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0xa000);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -426,6 +437,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
@@ -446,6 +458,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 		ASSERT_EQ(vma->vm_start, 0);
 		ASSERT_EQ(vma->vm_end, 0xc000);
 		ASSERT_EQ(vma_start_pgoff(vma), 0);
+		ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 
 		detach_free_vma(vma);
@@ -808,6 +821,7 @@ static bool test_vma_merge_new_with_close(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -863,11 +877,13 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_next->vm_start, 0x3000);
 	ASSERT_EQ(vma_next->vm_end, 0x9000);
-	ASSERT_EQ(vma_next->vm_pgoff, 3);
+	ASSERT_EQ(vma_start_pgoff(vma_next), 3);
+	ASSERT_EQ(vma_start_virt_pgoff(vma_next), 3);
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -929,11 +945,13 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x6000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -964,7 +982,8 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x7000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
@@ -996,7 +1015,8 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x9000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
@@ -1419,6 +1439,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1459,6 +1480,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 3);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);

-- 
2.55.0


