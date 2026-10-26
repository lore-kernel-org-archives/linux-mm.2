Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CB6606A331
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L9akpim6
Received: by kanga.kvack.org (Postfix)
	id 4638B6B0604; Mon, 26 Oct 2026 19:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B196B0605; Mon, 26 Oct 2026 19:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3787A6B0606; Mon, 26 Oct 2026 19:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 104A46B0604
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:32:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B8DB1408BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:32:22 +0000 (UTC)
X-FDA: 85366378524.27.D7984FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CD1AC1C0007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:32:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L9akpim6;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057540;
	b=ZJ0VWN4MlWhIkO2HipTI9x9BRdgZcHRNDDdilQ2d4ClBU/mGdGa1nSH7jsx9X96c7qISPm
	blhFPk4gXPMub/CQrmK8YKqV+ZDP/aOOqfLLXkOOwUnFPVdjq/iCGfIeNEKG3hsHvkgLBs
	zou+o25FZbIo243klJYBPAoZ2quW7GA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L9akpim6;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leDMySoi7QnuGrXCT7kUTF7p3M2NeDPBgSV/0vbZ0BI=;
	b=Wr0YjcC0Z2X//WpHxWLA6mHbjtAoQ4ULsbBPwJi0STCaAXKlK5ld8wkYC9BVaRx5+jzK0h
	baVLbVQ94dmtNa52OYR96al8hGw7VJQfWRIgYtpgyPD9Oks8Sas0prgxqCbSkRNpmwbst1
	71MEH7RlOUIt78775ZCnVRtvt91MJPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45A1E60213;
	Mon, 26 Oct 2026 23:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72011F01825;
	Mon, 26 Oct 2026 23:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057540;
	bh=leDMySoi7QnuGrXCT7kUTF7p3M2NeDPBgSV/0vbZ0BI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L9akpim6QbyBegiqBFdq/baFvmFgEdwCFWOYawuBvlzKXZmVSx0OXUe0vIKVc29Kq
	 qFDhmjhE2XC8r2UET7MbseG82Yrlr5rl8uhm+FWZXg9zSHHjcPx6jOzdtkZAUAd57/
	 SUaqIU3cTuXQ5rkuIOkuugP4Oddi+rqpi0RzyFZcXrXMvV1AJRJeL0Ka60cc/6lFzl
	 3aj7CVp9NxQgtlAVViDSO2yiUZAwQ3wkx24AZ9ntSDPW+IGf2vjdQTXbtW5e5vPduc
	 PYBh4bWzA7jbOLzBvw10CaUrJ2jvgAzk/WB3Tm80LB/7B3bjWitIFuSzSjELUy2vBJ
	 OVrw1PteZgGXQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:18:06 +0100
Subject: [PATCH 46/46] fs/proc/task_mmu: refuse addresses beyond 32 bits on
 32bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-46-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1648; i=david@kernel.org;
 h=from:subject:message-id; bh=+RaX15JldLvyrOg9i/7002o3Wko+CCA0o+GE3n4B9o0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu3595P/+VmdMlLqcHjo7hx5XfCereZwuyfqL6dWnoT
 tPbz1nLO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIuT2MDAtnL/pcH+sjlak6
 xTFMq1Epryj302Srs5J1+1ufKrr0T2FkuFqsNvv532l6H9VM/3dH69amCF5+VDmd8zXP8lDXW2x
 ruQE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: e1bmawqjtba4ynbwe8wwwjp715d1f71x
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CD1AC1C0007
X-Rspam-User: 
X-HE-Tag: 1793057540-559317
X-HE-Meta: U2FsdGVkX1+XFBhIjdmYfRighS6zag/GTLa3kGmPN3gNutF6MxOUBag9mN/kSY+rh/X648x8dMp3GMFUjAuqicL7RYbNaEQCbcEZcXAS6wzoFoXUOKOTxPr+K1MtZHvYF+8JC0i7eDwdHllwIYC1e2PhNusYG7ensJwQ+3MRpqz/WXwYmVAhbMw+R8RHw7xWSga8r6Qk2tcIZLHLGHJmgALm6o2Q+3sYny1V1+VujVCvvB5Wr1o9QcT5u6rPxiqdROImMzzU8nAytNUGCyFaOijs0p0yzV8KqJ+laWU+jGvwpBbTAYvViGNe+gcS2YXzXlXenGvVeK0V/62HTlsgSPQM9bDB9ijVlBuIDD2zIUypv0eGrOMfno2cFu5LFBvUlehuL9NQ3G53MxgqwwClceB89wl+lA6T4pZgfnXgn0grZApYm4GzKtlWkGe2Kp/05ME8ibUUwoUzouBMINj6USnaKU7yU6PCFRWLfYWEgIF5HJrfiEa+G/sQqVE7Jg3Ssp76HKCY/hKKse99sIoiStqj/wTjVu/KaJ7g6rLC0NHnDwSQCjl0o1QqbYV31TprAG/YNplIQXzCFXl3evamn/DMveI2dtlELmMOluwJfYtRfp+DLTyR0ddXVLuUXX4u9QFZQZvgEb9zzCTg8VCoPQcmP7nDnACwFOnIZTKGvtO30uhyjv4pyKu0WF30B7X2dQofXgFAKYLukLnvlqqb1aoHEh0M4qa87eu9AavNE3cFs7T19tHSrnufrWoE9obq0sjlft5FzbByH2mB8XgvKBeukn3YurKvitxP7dvLQC4iXfb33nJ9Ltuy0gAw0y2xDacBebmHpinm91b8FArg599RxNUJS3hTfE5ArAobao6kZTtfYtMij7Z5LBRv9WpfprYnsMMidOMDH2xpO2vssesDsaCKB7tAJvBu2y8tmuBTCIFGvpo3cnlyhvbT5yA2M9jeUKdc3UaKPuVJDgl
 rSTlyG6m
 JanLMex8a9K22KxedAejmbeC/f8p67kfJKM+XzzQoMyZQcKkgzWCFwcrhHxZ70OYGDuFvkRLsDExG7dU484uTT9nStxbE8lCmOdN3F3LhoSBdJztc8Cdbw+2z7yev8Awx7mwbZP5GkAsfVPo1jXMhzjUmFd2BD1hbWhu7D05O9U0zVmUuXR4vtWmPx8mYvwghNp9e39MUJEdAPyQP4Q/6WZPx8++1/OXEaONS35QVWGPOpDBjMLnH6+L5RVkURY3dej66XM9sVfyFogd/4NDUC2BSQhQpRheiu56K+YI0E2fFPPE1VnzE+9mF65zTGg41WZI4v24FULVhVqTjPgUCrKKuil4VeNQKbugCPwYxsfgpTpbDlUfzt6KKHWM5sxPq805571aoUDs7KQk2/9v2DQaLXVj7wTSZ1tUS5jyxhjzoywM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

The addresses in struct pm_scan_arg are 64 bits wide.  The first thing
pagemap_scan_get_args() does with them is to cast them to unsigned
long.  On a 32-bit kernel the upper half is dropped without a word:
PAGEMAP_SCAN of 0x100001000-0x100002000 scans, and with
PM_SCAN_WP_MATCHING write-protects, 0x1000-0x2000, stores the result
at the lower half of vec, and reports success.

Return -EFAULT, as for other addresses outside of the address space.

This is probably not worth CCing stable.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7452b695fdaec..762b6dbb81e4a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3032,6 +3032,12 @@ static int pagemap_scan_get_args(struct pm_scan_arg *arg,
 	     arg->category_anyof_mask | arg->return_mask) & ~PM_SCAN_CATEGORIES)
 		return -EINVAL;
 
+	/* Don't cut 64-bit numbers down to addresses that happen to work. */
+	if (arg->start != (unsigned long)arg->start ||
+	    arg->end != (unsigned long)arg->end ||
+	    arg->vec != (unsigned long)arg->vec)
+		return -EFAULT;
+
 	arg->start = untagged_addr((unsigned long)arg->start);
 	arg->end = untagged_addr((unsigned long)arg->end);
 	arg->vec = untagged_addr((unsigned long)arg->vec);

-- 
2.43.0


