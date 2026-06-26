Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4538CCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD956B00B7; Thu, 25 Jun 2026 22:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2844F6B00B8; Thu, 25 Jun 2026 22:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173B16B00B9; Thu, 25 Jun 2026 22:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E75A76B00B7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:46:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71C04C1A97
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:12 +0000 (UTC)
X-FDA: 84920524584.01.2E14CC5
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf02.hostedemail.com (Postfix) with ESMTP id D50BF80002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MuNcYjPT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441970;
	b=xMz6a7wDUC79wum40rpuwALerhQVBY/GrcBTJrXm758vX1qKc8zg1EMG1mePJ5so2WQKHi
	ymAOveIIkfzslU+FTqPQxn6b6NZNvb2sO6FjjnsnWMmgyJlvHN5huwSmDPw8WSDdhN99Sw
	uH7SpYqVl0lbzyRgKdhRpjT9SKfji00=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dUyOBnUAmeOV/VpmEyx25JanzSfW2aamrhE6D4NgAk=;
	b=khY5MKpalDGcX+SwzCMJMAtRk5xDpMa6y6L/8SzjBztSJkLn8Bmg2+ZXRs20X02xlZyM/8
	kcjw48Ap6sAggn/R702MIxEDO7GFb8ePcKMsA6RaQsKjmnHfTlmF2KIWWUnyIpGXFce2NF
	cMtjZJRNCGyHIeR+yxhNPAK81VqWg+4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MuNcYjPT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0dUyOBnUAmeOV/VpmEyx25JanzSfW2aamrhE6D4NgAk=;
	b=MuNcYjPTB0GgnR9RtSNJrEf2vkrdCPnkRQcySpNJ/NWqNCOdi4qwh0Fm04fcx7tDpdGN7J
	lvSCzFstf9W0WUx/4VNp4L8WrcXXf4ZGDQBaoyNryyQyqjLQJtBh3Fx15T0HccwW/PYDmu
	PlOSaHpdxnX2HHWR4b0PrXzZqSgNPE0=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] mm/page_owner: use MIGRATE_REASON_NONE instead of -1 for last_migrate_reason
Date: Fri, 26 Jun 2026 10:45:41 +0800
Message-ID: <20260626024550.25677-3-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-1-ye.liu@linux.dev>
References: <20260626024550.25677-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D50BF80002
X-Stat-Signature: 95tiap9t59z7wzsbyy87hh763iyagg9s
X-HE-Tag: 1782441970-723848
X-HE-Meta: U2FsdGVkX19tS1gjk2WWK0Pf/sLHzhIc6hEn36cBWsFMOXU6SPpayuwmU7WtN3Cd6+jX3CD427+fb+06UH+4pD677Jp1fSdHkYen4Ya7YbV1wKtnpC5ZFaCfPSIYj7izWAD+rKs4s9P0W83/J4b1N3TghtJvy5jrgHrpWse1mXvYab/cXmlc+QRsiQOEzOeg/ZmMJtrowzNbLU5DkYq6oT2B2FkwX7HeaUJSh32abrYH4Fi98obmKQwI4nZSofmYWHONJLDTnX47CbI7HMEA4/uTam1Jwm496sYp+dVUfJm61487nxZB+1/rvhUTJcQRU1UEs8IWlBjXT+oRnWPrNzHzGI29fMoGVuy6K7NK9tHe0N07Bn7flXDJDxfKKzYXwSN1L05rAbcIwDdU5ZRGVIqhUzwrlIOAmx0ygB3dGFpiZtPpKD+cYO+uPv3YkBys8twdIa4EZZX5sSu3MWodjKHuH+zlajY6TNrHu0DQl/HkJ+LntKelhzpSI+nYN9D8Mgq3sFi58ECzyVH2E5wLCMtaEcAWHU856McDBS4z+AU+60vexZu2KF3JGGn2MhulfiSqPMxCi2/kIav0ckodMcuDuHQ5V1vIIhU/0HvVNG0sXmlGpaJ9Yj7aJbJdfea3KAariFuYuI75TrZt7+c+AEh2VYQn9g442HWJTlBvKDcsyzMZ0jik9MuU3HfSsjwnqvhoncP/QwRJAjVnQ2SUcktG0relKI2PuHPwjZ4QhJv+dw06tHcndCNGVYxWhg3Rhu3T7qj4fT9lql7e6TypzmJtMAeB+aC7yPn/BoToG6wW/2M3+ovLVqHsvKYZvaxqYZdp9NXm5aIrh3QiY2Z+j9612aiy5FQQlb6jflktkyZdn9eFvSUjVeyiGzVnNylSh8TfSIBy292Qsz+d9z4cuXU4S3MyeVKljiFZYQsOcQlNV3N4XfnHXNbNxDGYKrp2WwQUoAPkP0zRb7J7laN
 ajHSXzKa
 A05HOxFDVOD3j9BN0LiKY2QSHEzZiHjrE7R6+dKibtJxi4WaDYcWq5OKE3rZ2peuvtWEP71/amYygv7VmQuTV8kpgICPG+sJzrZX3JrjxuzetiAxI66JryJl2HIoHBRxm14CSSfs64LfxxU5xCMWeP+KfU018lpEqy5vaqfcb1xZXM4IRZfAQnhKVaVoWzdWdMXLmzOB7Bmwt42PJV2LqRRFsnuamxTutrk/G9LVsIdHVaBuNowkk8stQDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last_migrate_reason field uses -1 as a sentinel value to mean "no
migration has happened".  Replace the four bare -1 occurrences with a
local MIGRATE_REASON_NONE define so the intent is explicit and the
magic number is eliminated.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 342549891a8d..ebafa9d7ff07 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -21,6 +21,13 @@
  */
 #define PAGE_OWNER_STACK_DEPTH (16)
 
+/*
+ * Used to indicate that a page has never been migrated, as the valid
+ * migrate_reason values are non-negative enum members (MR_* in
+ * include/linux/migrate_mode.h).
+ */
+#define MIGRATE_REASON_NONE (-1)
+
 struct page_owner {
 	unsigned short order;
 	short last_migrate_reason;
@@ -339,7 +346,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 	depot_stack_handle_t handle;
 
 	handle = save_stack(gfp_mask);
-	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
+	__update_page_owner_handle(page, handle, order, gfp_mask, MIGRATE_REASON_NONE,
 				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
@@ -596,7 +603,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 	if (ret >= count)
 		goto err;
 
-	if (page_owner->last_migrate_reason != -1) {
+	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE) {
 		ret += scnprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
@@ -667,7 +674,7 @@ void __dump_page_owner(const struct page *page)
 		stack_depot_print(handle);
 	}
 
-	if (page_owner->last_migrate_reason != -1)
+	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE)
 		pr_alert("page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	page_ext_put(page_ext);
@@ -826,7 +833,7 @@ static void init_pages_in_zone(struct zone *zone)
 
 			/* Found early allocated page */
 			__update_page_owner_handle(page, early_handle, 0, 0,
-						   -1, local_clock(), current->pid,
+						   MIGRATE_REASON_NONE, local_clock(), current->pid,
 						   current->tgid, current->comm);
 			count++;
 ext_put_continue:
-- 
2.43.0


