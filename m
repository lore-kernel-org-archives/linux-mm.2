Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FE7606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Qf84f7xU
Received: by kanga.kvack.org (Postfix)
	id EA9CF6B05B5; Mon, 26 Oct 2026 23:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B1D6B05B6; Mon, 26 Oct 2026 23:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22496B05B7; Mon, 26 Oct 2026 23:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD82B6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:45:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19832A096D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:45:07 +0000 (UTC)
X-FDA: 85367015454.01.EE95951
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 434FF1A0007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:45:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Qf84f7xU;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793072705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Mznwc8GrpzJ8tK5EL1ob+iPEtoev+BzmKX7CHPnJ74=;
	b=tzRUWrcWtnmroYFaorUHwbGUqHjH6qaSrvQyAQNNtqEFWsDBCX6jewtd1agdEezaylFZnK
	8IKwTsLTL8mWG3yD0UElqYs6UMtX4UpNhgeuCp6KbSKRqi4iqvqxjrMAR8L5vWelRVkBD8
	j/D5yTr8W/H6iY6ZX5IxI7fPun44rDg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Qf84f7xU;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793072705;
	b=l6IAebEJwTO1ZlLWXLrA2f6/0py0D+919ilS/6qE/tbouBsJLds5rEqJXosyHZpsUBUtd0
	d9P1/1FhmcZ8cxun9bfyeuBasYsp2gqFYt9uzOnm5qHbxLAMUyOjws/LFnBkfTOAr26DI7
	OldMfAO7NjLzzE8WpUrhaO6JnqfMfKo=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b413b0a974so4291238a12.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793072704; x=1793677504; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7Mznwc8GrpzJ8tK5EL1ob+iPEtoev+BzmKX7CHPnJ74=;
        b=Qf84f7xUKmKSfC55LdktTohu8pKsNDUAH1wtH6LdgwAbwVcJNPRPQAinJbnlcszUuY
         bHyFaWOUnFYzXymOADFkq2yyrMVgDNa+9tNMoceEZXYeiB9eki2y0qc1EcM1R++bvDu1
         rontqAh/+yjFRwFVKepAB69/E15QzZhtoHchHPo7cXE7kOZHw9rovar5oWPH3rQ4wEid
         OSahR/sVZDIrYFsL5FKN6q1bJFpEnINp/fCPPrEl1kKyZkcMzMGHAL3n5skJTNmjw+v+
         jS2Ziv7NII0yFrh7xVtC3fsCgwEDqpEDMqesLrUZucoJcuX1LmayZK9aFt2mHKIwmtrd
         vZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793072704; x=1793677504;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Mznwc8GrpzJ8tK5EL1ob+iPEtoev+BzmKX7CHPnJ74=;
        b=vcAskoDAx8b5qQwOFTbrd8y0e9oyqTn9dErsZE8NRV5W39hJKTvMRJ/3CJurANOPjp
         jMOCmqm3hAD4I5F2/EN1cBmBAeuzSKkrEbVkcUQhFfwNI69KgwhjbYUzbf0sMcLyxb3O
         dEleZKVKaUeE/vO0wSOb9cJdeo3gyx2mANhOBEv+FCvz83hi0SadHG+zAhz3SlN4iPif
         6D5ZKoY54c49LvzLOK0uOOm6qyuvRMMSfsfBjRotwalGTw0D9MElQDOzAJ4dIma0zfCp
         /8ry4aN4K9Glxsg7oDpPCgp03G+FZ1SDUWegbOoj66RiyzhLlMjw77SMti/Ams6UG108
         YwDQ==
X-Forwarded-Encrypted: i=1; AKwUvBxfTAeQYGyTRIPwJuMz5K7ezobhBvsltl13DGzZj10KOhxP72c4n9vmG5ZrgFqzYnrZhPngUZLH1g==@kvack.org
X-Gm-Message-State: AFq9FYLrIBKznt3u+Ujxap0S2SBkN2zojuDrHXYViHw6ougQll8DMwbC
	6oRwn4BhmnQifTykbdz8fLTgtethx7UAzw3Hb/afIUbOll34jTKkGR6UwXA+ksjX+YU=
X-Gm-Gg: AYBFou2N/dVFerp6fG95jgzSrrCJ24YjkaKWv6eQbOK91Oppkm+E9+vl9q3n5e1sQBa
	2EqolxCrYEaWmtj+M7HApVdZZTWJAOpIi29UqAq5okzf1bcPaJCC5hs9+BX6T9Jr7aFm8CQxUl4
	0Vt8hUWV/n8q1j3/1Lk9T5Q9l9eu5IDjjZjRJRKdL9NnE4a5O/QB7tzeTF3xrpOGY12vOUBpDnR
	/4BdBtBJ+8jhuO0yr0x1zt93iFSkHS3VHOoj88wEMQCfdVUDKxaE5089m6wdnvHFnjmhY0A8qIH
	jclKNJsrObaQ5CyUyE/JQxQyn4ZYpi440xTibBdUNe17HRLU0cb+yrrL14uSzBQbRMsKpqW78U7
	JYXY1ikSqvz3ca6V2SR/un5r72RouQspqb+juyaOk1G7vLWUa/oilFbaxdB6OsmgnNCO4wWKPcG
	8GiE44gaNNg9AUh1Lt7XikM8Rdv9nZy2mIKogFl6pCjTyAjcit8NbP0Nw8QidjLcFtiVsO82TAy
	lNbvfmrd+CXNjejAVGzybr8tCqWJcRS7N0/V1j8cI16geY=
X-Received: by 2002:a17:906:9f85:b0:c41:5a0e:3356 with SMTP id a640c23a62f3a-c46bded5befmr907107666b.41.1793072703836;
        Mon, 26 Oct 2026 20:45:03 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:49::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd4e7c83sm382468666b.30.2026.10.26.20.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:45:02 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 41/46] mm/vma: call ->may_split() before a partial
 merge
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
In-Reply-To: <20261027-fixes_core-v1-41-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-41-6f74bec9a5bb@kernel.org>
Date: Mon, 26 Oct 2026 20:45:01 -0700
Message-Id: <179307270137.1171062.14886397073081900278.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 434FF1A0007
X-Stat-Signature: ngwk1obz9gpxdf436eb765nbbneszjhk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793072705-153243
X-HE-Meta: U2FsdGVkX1+rwn+XAXZJwjzEWU2WXj7bk0+iaRiurG9TV7WaWAB21W5gvefb51OrCkH5XA1Dx1YQwEuQbMP6SdCXzmMLhlqx7+IfcBLuvc8jlXdRDas2QTB2jJ5rbLvlBXgIMTbQDYzRpu+bAumfl+pyRoj/zMQ0JRmfGQ3x5hPxs9HNmpEFKUJU/o967c149wg8+/VTTAPM+8s55qPvcpYlAP5uhJmBRoXW1Ayk9Mg/5hK8zSd7f7R4kxDN9PDiQ0v+Cjf06rUnSEIzQaDnP8G4JF21ve6PT095yXdMms/MAiIofwzZ5n3SZS1i+rN1GrVTasdlvBxnnSSFoJ3QyEUnXrXm0Xe33GUYVZJ2b/7QffpxzYeD7AB3wbi/WRaOW9Pch7qxrsXGyOU+o+Sc8LGD9lAP1Cqhx86EKiuFvmY+MZu6uN3lOWpn+kj3a3SyBdGB8af39AKuwQS0MvW/5z8EjUxFJw9Q5IKAThJT3bNcokXOZcje7n70Kk83ScIZ/fkF3Hw8wiV0wtBlAlHNYMdouDh6r/pXa1iHoWMTMEOPvRAAczfsavf0Crcg/19ewW45qeQBhd/hBCt3kapWuG85MP23fZjArnxtGrnH07q6+oKysdNjCsm8YFMkXvXOUeDpVxCcCH3gvbVK3Qkj5cwzMlv1mhfQWunaLG5bZjK6viDg19w/tpjQMozAui0EA126XnMbI2uRLVp2k+Hxvs/PQJydtZWPGcrovYeQ2iR+jOF0e2ut1Vczjj0if82SuDkEfIaCqKlhAeT5hOFWHzgIQLK8Xj7D6C9brPomVNbDaur3DYo97dMWk4O/Siti4OBXz7YIMJXfDP7EdX5bebDIYG2HS73gI4C+CriU9ELK6u6hb5Qc4Ek+nQ5kxshJM4N1Zc84tPD6Bqdi+Th2YokcbwIwFxRG5Yt6CT4WqSgiYz6JQ3+/C13LCINhN47rBQEerv2eBl2oSu/0kqz
 ir+FODgL
 QRLsInDLPRqP40TfHEfmpyMSnQ8kC+1OkuUg+9pgNnXCLP+OEydUt3OZhZTMW+CJqwAl4gIwOa7hJ8wEjurEcXEN3nFUydygGK6JEMUoSLF2sKCyLlx6Gi5Eng7WP6o9kuTpHjkOuuhJWvsK0EuiEN6mDDCghb/zwhpgi7ENAgF02ODmW4q7SJBXL0+D6O8T//tDkW4/CwovSUs1Dv35dUCEMIi5JhLoUj5pWB95LFnE1rwa6r9B2UjLG52oD5eAStxL8hZ3rdK7cSW//BUQDBMM5q5gZiO8jAtMuY9KiQsSLmQIsdXb90q0dMo2NdLknt+V7htoEBv3haHfAdenw7RUw9KcRzPO0oQFmTd0EL4bQcHzOgZigxuM8De5DQ9lUiz4JQKMz6zdgLWWfMu/8Ye42ARAvWWOalDvfs5AfCxq6TnrwbbydLiZq+FpqJ4Ht3b0g1yJg9cat45zstHsds5e58zLxHUwXGIg64CDlnjKge2Uvy+A9Ifeaufb+HpMLXwMA8uNtl4ljf8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:18 +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A driver can use the ->may_split() hook to forbid a VMA boundary at
> certain addresses.
> 
... snip ...
> 
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: improve description; cleanup the code ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

Attached a vma unit test I used to test this

-- >8 --
From: Gregory Price <gourry@gourry.net>
Subject: [PATCH] tools/testing/vma: test may_split during partial merges

A partial VMA merge moves a boundary just as a split does, so it must
consult the driver's may_split callback. Removing an entire VMA during a
merge needs no split check.

Exercise permitted and rejected partial merges in both directions through
vma_modify_flags(). Check the callback address and resulting boundaries,
including unchanged boundaries on rejection. Also check that a full merge
succeeds without calling a rejecting may_split callback.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/vma/tests/merge.c | 87 +++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index b26f1a66a1707..fcc052be15601 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -1488,8 +1488,95 @@ static bool test_expand_only_mode(void)
 	return true;
 }
 
+static unsigned long split_checked_addr;
+static unsigned int split_checks;
+static bool split_allowed;
+
+static int merge_may_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	split_checked_addr = addr;
+	split_checks++;
+	return split_allowed ? 0 : -EINVAL;
+}
+
+static const struct vm_operations_struct merge_split_ops = {
+	.may_split = merge_may_split,
+};
+
+static bool check_partial_merge_split(bool left_edge, bool allow)
+{
+	struct mm_struct mm = {};
+	vma_flags_t left_flags = mk_vma_flags(VMA_READ_BIT, VMA_MAYREAD_BIT,
+					      VMA_MAYWRITE_BIT);
+	vma_flags_t right_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					       VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	struct vm_area_struct *left = alloc_and_link_vma(&mm, 0x1000, 0x3000,
+							1, left_flags);
+	struct vm_area_struct *right = alloc_and_link_vma(&mm, 0x3000, 0x5000,
+							 3, right_flags);
+	struct vm_area_struct *middle = left_edge ? right : left;
+	unsigned long start = left_edge ? 0x3000 : 0x2000;
+	unsigned long end = left_edge ? 0x4000 : 0x3000;
+	vma_flags_t flags = left_edge ? left_flags : right_flags;
+	struct vm_area_struct *result;
+	VMA_ITERATOR(vmi, &mm, start);
+
+	left->vm_ops = &merge_split_ops;
+	right->vm_ops = &merge_split_ops;
+	split_checks = 0;
+	split_allowed = allow;
+	result = vma_modify_flags(&vmi, left, middle, start, end, &flags);
+	ASSERT_TRUE(split_checks > 0);
+	ASSERT_EQ(split_checked_addr, left_edge ? end : start);
+	if (allow) {
+		ASSERT_EQ(result, left_edge ? left : right);
+		ASSERT_EQ(left->vm_end, left_edge ? end : start);
+		ASSERT_EQ(right->vm_start, left_edge ? end : start);
+	} else {
+		ASSERT_EQ(PTR_ERR(result), -EINVAL);
+		ASSERT_EQ(left->vm_end, 0x3000);
+		ASSERT_EQ(right->vm_start, 0x3000);
+		ASSERT_EQ(mm.map_count, 2);
+	}
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
+static bool test_partial_merge_may_split(void)
+{
+	ASSERT_TRUE(check_partial_merge_split(true, false));
+	ASSERT_TRUE(check_partial_merge_split(false, false));
+	ASSERT_TRUE(check_partial_merge_split(true, true));
+	ASSERT_TRUE(check_partial_merge_split(false, true));
+	return true;
+}
+
+static bool test_full_merge_no_split(void)
+{
+	struct mm_struct mm = {};
+	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_MAYREAD_BIT);
+	struct vm_area_struct *left = alloc_and_link_vma(&mm, 0x1000, 0x3000,
+							1, flags);
+	struct vm_area_struct *right = alloc_and_link_vma(&mm, 0x3000, 0x5000,
+							 3, flags);
+	VMA_ITERATOR(vmi, &mm, 0x3000);
+
+	left->vm_ops = &merge_split_ops;
+	right->vm_ops = &merge_split_ops;
+	split_checks = 0;
+	split_allowed = false;
+	ASSERT_EQ(vma_modify_flags(&vmi, left, right, 0x3000, 0x5000, &flags), left);
+	ASSERT_EQ(split_checks, 0);
+	ASSERT_EQ(left->vm_start, 0x1000);
+	ASSERT_EQ(left->vm_end, 0x5000);
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 static void run_merge_tests(int *num_tests, int *num_fail)
 {
+	TEST(partial_merge_may_split);
+	TEST(full_merge_no_split);
 	/* Very simple tests to kick the tyres. */
 	TEST(simple_merge);
 	TEST(simple_modify);

-- 
Gregory Price <gourry@gourry.net>

