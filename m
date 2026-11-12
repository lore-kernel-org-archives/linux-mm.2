Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B51606AD50
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 01:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P5GQvKtD
Received: by kanga.kvack.org (Postfix)
	id 87A376B05B1; Wed, 11 Nov 2026 20:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A756B05B2; Wed, 11 Nov 2026 20:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719736B05B3; Wed, 11 Nov 2026 20:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5946B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:32:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB819A04B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:32:37 +0000 (UTC)
X-FDA: 85424742354.26.F7F4285
Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	by imf08.hostedemail.com (Postfix) with ESMTP id D43C4160005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:32:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P5GQvKtD;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794447156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=96+MiFGPO2U7PNuJNe4GvGKx5aN5k6zWtMq8p7nurjU=;
	b=ljvbklAaWf521N5q2dz66Qh4VGz7qe32kdYaW+TX/VHFb5PwTPXaS6fsHdI7BxfjqFjUIZ
	ztmduXeATnyFxzwRAu4oRfQu8DEfSc4lh2M5jKzLZuc6HmCpb8Z7TduHvV4wUZrnf12BbD
	b1mtwcLtH+wlRPu5Iw0wZzTFkXtxWjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794447156;
	b=vVdVFnL2E8bLoji+OgVT0AvzfjO390FpCVzmnu6dONZL+zJnqbtA2hQ6s3xvVvAtytzrLA
	qHrWu6AwM95kKnOMGyl4GBizTCRD/DbERpEWjTxDDroCXC7BEEdsBTFdRLSyIjqzM/5hqX
	XFxhVbwZzzrk2X03/hDKvktsUxiI4+s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P5GQvKtD;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sPpIa3e7L1mAcoyZ9LAbz3c730yx9yguIyx0GpYaPmo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794447154; v=1; x=1795051954;
 b=P5GQvKtDgYWwg6294JBP/iDUfSd3unmRBLbU2Q5X1Rn/CSrNJYczu1Z8Gy84DaPexwIfgMU1
 BdbcQM0Fkzo1e348QZXhaIs7ZnYdhG56sIg66zAwH4r4lv06/xkkrJ1AjGpG0eLCf7rSGmr1KxW
 HSr1FPIPPWW142PpSm8xYCSo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4ade9aa4cce312ce;
	Thu, 12 Nov 2026 01:32:33 +0000
X-Mizu-Trace-ID: 4ade9aa4cce312ce
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] memcg: flush nr_charged_bytes when the obj stock trylock fails
Date: Wed, 11 Nov 2026 17:32:20 -0800
Message-ID: <20261112013220.4064478-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D43C4160005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1su55wsjtgy1y3p71rzawh76t15itc5h
X-Rspam-User: 
X-HE-Tag: 1794447155-257016
X-HE-Meta: U2FsdGVkX1/zKFJyLPpV+1FPVqjEJq2U9vV/HNJtKouHGAVulOiee4PGeqg/C9EMFiJ7Wk3hhtMYsuSLCBreX1Vi0xkekPJ3+xAQaS2O1+QJLIKERWZLKgcNGFUseEA8v8Isz3pVzjgXJY/zRXk+yQQ8/oHZWemBq1UTlqwucNZTQC2xTJ6tKjnVQ5QO+MDkTo+O2NMse3yDiLh/ek1hkTjSzWBbONTYT8kazDUmBPDLlTdRlpXmZDRAyftFw8b8FjgTwSdt+pxk8T5qVBnDZMjSSL0TVPR4PippfkdxPqz23w2Vv5RpJlv3HIB7ZbQMJcIy8H/IQLlL5TVEhtnQhLKBGGqbeBU6JCu+gqiiW/S8Z5U1l4kltLqAtsyuEvjZbpHqEntIjigpHSbEbRSMThj5TaaHbK3ba2HMoVOyDYOy273ZLFxeHIjFCZxSnIf1PQkaOaWD//uk8zVl7hfbE4XbvLavuBT/4IIVkGNAXLPtEX4hpRIbhSHzmmlssnr+OT3cy29FmpNXPMKScBAiwvPKm9AJgAAnKcMhOJQflZUjGzf11pUkeWdCNAD+ZgOd/AJlUp5yvFQqxqkj3k0rR+uE6ubyNlmYHoze/1uKMgfVr4t57mm5OCBxTeifodIRDs+9mGm77wld/x4NVtqVvoFQCFMMwlvT2kvFOtbOJFcylLzpdNqxZvR7X+Tt7NKiJMVovlWgtg2Lz4mOxTANkiO3EBhXdbzjV5S/+ZkLQzqn81Lk+LRhDmwqAxaZ5PXu2fjBYu/UPbdOup42uybNdggwCKb9b21Bq7Ep3ZQtpZLvwhhZgUZVnjSwL8a3Tl2W++YVYUqGyo2Qij2RbvJ/D/QHMzFfC79HeD2jLcYUgidt537OzIrxr4c20phEqq5Ix7iaewiOnT6BqjAkDkffcr25asoXMURpma0hngTDvdqYjpYaHedbnQr/TuILsJgRY5N3rvUNs1O65ytpTQM
 4fS5XyJh
 ty4gWjoV9aQ2C2UQuSqdrxY/fggX1wk9pMTX4dqpRjpgRl5VocQOXSuISpRKlyhkNqXsmE85leTc/JU06Z6gxwNpoAghSXqdw+7OiBSL7BCXNEmCOLfM/0N1Z5/f8pCVpru8iYHTvW4AUJyT/RCdVB4fMei7XVqD+hWYq5WTOeNqMxV9TCl7xUbpt2EaVdBbS3QAMakQVhgU+moCH4edJ1CtyoAgthhX02qc8QEooCeHTUGsUt1o8m5Tue6BzyOQgcJ5Q25e66ZcNlXA7EKbz4AQ6PzVhu3X6DwWwJ+7sXdP0Rkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When interrupt code, such as an RCU callback in softirq, runs on top of
a task that holds the obj stock lock, its trylock fails and the bytes go
to objcg->nr_charged_bytes. Nothing empties that counter while every CPU
using the objcg keeps it in its stock, so it can grow without limit.

Users see memory.current and the "kernel" field of memory.stat keep
growing while the cgroup's real usage does not. With memory.high or
memory.max set, the cgroup is reclaimed, throttled or even OOM-killed
for memory it does not use. The counter is 32-bit, so after 4 GiB it
wraps, and those 4 GiB stay charged to the cgroup and its ancestors
until reboot, even after the cgroup is removed.

Fix it by uncharging the whole pages in nr_charged_bytes whenever the
trylock fails.

Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: stable@vger.kernel.org
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f5f567f7d4a9..091401cecf39 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3553,6 +3553,8 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
+		nr_bytes += atomic_read(&objcg->nr_charged_bytes)
+			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
-- 
2.53.0-Meta


