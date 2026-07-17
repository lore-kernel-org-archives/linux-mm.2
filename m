Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A84C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8906B00D2; Fri, 17 Jul 2026 14:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF796B00D4; Fri, 17 Jul 2026 14:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4DA6B00D6; Fri, 17 Jul 2026 14:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0462E6B00D2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:23:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 765D5A0420
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:46 +0000 (UTC)
X-FDA: 84999092052.14.A379755
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AC679C0004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i9kZrGVy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/iL8+q9nchQYoecoHRozmG0upgg4wUWQpXFNukM+ng=;
	b=BfXe/fcM6TJNTowUvzOuNxwnopOLnFFTjFzu/ia544mO4BasnEwZkHmP5jvN7PEN/HFSvM
	cAha+a20cshUDt8ofiCH7LS6CIY4Okpb6ak7UJsXwQGnLGWZ8niN8OGarWm37GcgeFbcrO
	0zCQWktdlbeZzUJyXNBpmVpFVMdXI+c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i9kZrGVy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312624;
	b=LlmmyukUbel/V/1PpmR7o99zkkSz4bzaZfDsXdTJ8Ny3iePsEjqcV3PJK5Ni4WKD5e7osy
	z1ez960P7Vkuy8j9maXCw1cuavjaPRctKP7PlOFV+wffN9m8GBQunMDdVSs0BR78S+ed9U
	j5vMKQWLYJF9WecyRJkewYre9gdq3dA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECC73411EF;
	Fri, 17 Jul 2026 18:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006091F00A3A;
	Fri, 17 Jul 2026 18:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312623;
	bh=e/iL8+q9nchQYoecoHRozmG0upgg4wUWQpXFNukM+ng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i9kZrGVy7LfrF2gGQSO3BKdoe0YIuNz4INwdJaJvFm61yNcpoGBzPrlU00k5ugyrh
	 l6lAXaeqTdjovB0IXT+eL7XxI2vtdg194NykBlvIGaIUs1Fhi7rXGg9vknAhEW8xAx
	 xOl+qXalWG2nob3yFTyUsM/E6MXEU5JunIdeVjYan46xBrf06Zvc8Kb9Uo9l8MPRE4
	 czOaIRBvoN5mYCi1tUtmstx2reEnop856osJafp3GYSxB8JJHoiCQu0thIo/eXF9Tv
	 +0CweEZGGTwCKAlDBULOs7yelMUgrnXW2ID8MfKVRuDknL26r8RG4zJJ5ndQ84gWbf
	 R7Nzq2ZG3fk3A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:48 +0100
Subject: [PATCH 10/15] tools/testing/vma: expand VMA merge tests to assert
 virt pgoff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-10-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6335; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2613GakduscTW0HQyjciqfb4Fv/xmKQjLs/wrRcxexM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivZ53Ywy26t1/84nP/stiqvOhX69Kqejw3Orf7dW6
 vEDbjdmd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiK9cxMrSs+PZMUNFZ9aLE
 z2XN/a73ai3Sb3kbNUfzyh5cf+YYwx2G/4ln2f0f+Dy6k8m8ctOns0khFSWbWG0vCSolhgifN96
 Rzw8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 5gds931boidi7b4pf85scwo5ipmymd6x
X-Rspamd-Queue-Id: AC679C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784312624-160742
X-HE-Meta: U2FsdGVkX1+izdXsyFceWxDV1Dg2K393kiS1ISwPlRSiZAbyHcJgOTYYtN1tDsmMbZAb666U0xZ4DjGxHCdjlIO1m0c4TIPfpK5aVi7mrC84DzLjbCl+FA5Qtlcmf5ugVJy+svqqlruLorSZDAkvjcIHq3Xp2j4FL4KMTJKTfU3C0SqjVjpw4VYF9ts0LbWHOWaBast7BPW+NLTDlumx1lf9sGlt6bAha2ccwXbQ8N4NULp3/WsYl6zcfmX/ZeLwpFC9u70NmzOVD9w4d1uwmpkxWODk5ORYYgTqcgQqphUhjU+bjnY7/9r8o9K7kzLnaGAHRwfIwHFYWV5C4L34w1yiqOx7adlm0dKMniHX23QXa/OfWDH9nlbT220TLjC4b75FRR2rwqkB3dOop9WKASv1ccTbRktTL9D0BLSPOedfgHWrjqE1XYLCqqfLnJzvR2AISjGjLPjUH8v92PI+9uiTcUu2QX7dGDeq0aGh3MR8NbHVH/aZUnMZ7wIvX9ajjBYkSttmB9Rmqr26sYIplsUFnGoKE/LU+vJFm3wxvjAgzNZXbL79bfLoLApDCrCpMsupjb+COWpkw9zEJWRImwIFj+N9zncyBSCAGyXMZdyz6suoAAhTVt23KmO4TOqnrsPH/HvC1lQbIySq5V7mu4cPSJsZJyeQYBxmjh9/I5XoAvF1c18RmB16+mfsQzs4j7kjaLDLfTuZ+KKkMsA05mjz/vrb+wBtD9BNdJ0C59Gk/sJYOHxESauiq5EFCZKUKYM06mZ5mjnTJDzqx0VvLz891cxh1aUBzRzmmTJ9VF450ytGDpKlQ//zNLQ9Rcb44BCF5P00q/IN8sP/5w/1LhC8Vz9007BO0DaePtK/lQldOuYDztUREoSfPijzYVuJbG7xXIToMFnysazzc9+X2mC1HLkqz/2Z6QK2bfFFiexku7FYSzGWlXCqouUk9PBCgNSQy8QbHMx5kWAfry4
 R6ujowvc
 sLFxs+eZskHyR1zTPaSUC1ORtFjcMQgiUjErVmLHHT80yhqanDq+9VWxLeddoxiGjHC+nab4ILN73JgoBkpTaMSoDVKDLYIPvlcLYcytWnz9RXdEA3pqGFW5/HDlsn0/dKItplGZkjWDbjmwrCLIwVuGlTxIRIoZa7HODp3cJMWol1eMIIibflWRN//Clhur4jV+Q03U4JVrMIwgyMdVHysxDpyYomiUaHomnjeMPhK6cVXwL3qIkCs/RaOxop13rchSYaxlN+fdS2svBcvnk0hKYP//xXnKB+QhAVez+3djOmelt6Qssei5eJv6ji8tewSYn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have introduced the VMA virtual page offset attribute and update it
when VMAs are manipulated, update VMA merge tests to assert that the
virtual page offset is as expected.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/tests/merge.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index 48418b82b01d..a01107ab8e21 100644
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
@@ -868,6 +882,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -934,6 +949,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -1419,6 +1435,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1459,6 +1476,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 3);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);

-- 
2.55.0


