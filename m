Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A0FC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA056B00AB; Tue,  8 Sep 2026 09:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81556B00AC; Tue,  8 Sep 2026 09:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BFFF6B00AD; Tue,  8 Sep 2026 09:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79ABA6B00AB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:54:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 852B3160650
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:54:41 +0000 (UTC)
X-FDA: 85190740362.25.B288511
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E9340A0007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:54:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z86lqUUM;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CgoRG7kKCzhkx46Y0+lhAJX5PsX1/GyoeuyPyR0dxwo=;
	b=vmX36iSjBqIUvRkbnmiKRbEkHqW6lq/W8o4QIzLzNRw0xOJmFpRoOJhTUnq6yw2Bz5P6C3
	7ed+HLX1gWDJv2bV0ZyoaJ2fABtzsHvoicmowgsQRuJpOwIKJRxAyloJGPbuvAqvHZWKbt
	z+lqKNnyO5OFAKO5K5hh0fhl3Axe88c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z86lqUUM;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875680;
	b=u5i9NwkRaEJT5fq4Jvv2eoR5Cwf2B11gAsrxAKeTysUB8I/nvHiyaJ3WtUscbr6LLpdHcO
	kbVXgZeED0wyql3YcTeqBjR/4U8FMrGxTXp39+OT9BrgZrpKHoy9IQs5NpcTCisXDVbD7B
	Ne5XOsApKNJ3OWKTtLOolV8NQSIeo/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22F2C43C2C;
	Tue,  8 Sep 2026 13:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39851F00A3A;
	Tue,  8 Sep 2026 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788875679;
	bh=CgoRG7kKCzhkx46Y0+lhAJX5PsX1/GyoeuyPyR0dxwo=;
	h=From:To:Cc:Subject:Date;
	b=Z86lqUUMYk7rbhqAZ9Zo3V48PT6WAZS89KSYGDOwN27qGsZ1M+LhuJrs9Zpu5DvFd
	 GW1l/FqbXXw5u2E/TYJMNHJ2R1J0BXwYfuZCUm+He6fr5EH9REzvqiHVCVx3tQDydS
	 BOak43kkjbizFAtOn1wR8hUkT+/1iN3EmeuXbLHxy/9b717qQ/I39p8r8j6bfiYJbh
	 SzLlXRZb+/928FB050/Wnt8jgzSbYXDhTC6Dmvmv9eSdGDBBNtX84BvMFfaOfA8eoa
	 nwAyYF7+WvVC4q4FiKMSSMQPWJBFprVg5hc6+Gs3PeKTUwipvEg/QsUJ8aLz9kzDDz
	 4+3PLFLuk9Dow==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4] mm/damon/core: allow esz to be set to zero
Date: Tue,  8 Sep 2026 06:54:11 -0700
Message-ID: <20260908135413.97570-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9340A0007
X-Stat-Signature: icmrwp1dpmrixupxmixsxo3puor3353x
X-Rspam-User: 
X-HE-Tag: 1788875679-196938
X-HE-Meta: U2FsdGVkX197+/ukbPMHjo0nKceoi1W1zmlcANya0uJ2IXa7AHHKM+hFAe4hPNeGqhJ/LXvpFOp8/TWsPeQGrQJifgEx1Fq9XoUuxR/GsRlyXrSNT/5p/BDxJSq9iBJqM7n1tPfeglh1S4kvGu9BWGzmcBIHc2+3ee4azRHuzT94HE+Qh30aCzsy0mCjewUC5z5lpcIg6qh0LmNnalVnXWz4fIfZfVj4PYwnMwjLS71ifh2QdOgRny/+FNnMfALiIGZA3jG+vH4Q2mZGU6LesyCGfUSkXTAhj1PDSu/ELeqX3+wFVnOsYidmeSXugRDGgbSSQqx/NFzewH53TAMpPmGILUYKhdMv54hCk1ABdiqaHNMKCQbpny1Q4oLTrTFmMJqcKK4xvvPU6Ns5JV7MoQSG2R27+OsmIeeXlobqeevHl4uLETvxnnvmuVFRdUZkyyruRQteZE8GNNhFwblHk0cdYCTXaOWSIuARZaFKFZIVMVZlczfiCuZQVOBSgItjtiGXaBpriGf3EcKF+iyU+2MbFObnVxxyYOGRX8c86YvtexnFbqRaKGwKg8j2DnzHXQ81PzB3Nv7U1ZMU01O3/ADc9qsxawrxhH0V7KN/j/oDFkdFgRzX8T1So9KTB2aJ1N03VjD6QjzCc34RzZ4IwefYO6pW96vk+dhCPbOeuHWfYrwNm3NCs7zko9kILncMaiEs06lC424hIZWDCbGomMyX5w+OvQwZ7KtSQ+C8haiqxd8fmU6wqj7cfHNzbml98TyEk3gjsHu0FMHA/vCx6lOuLfgX4b2KQB47Utw5Hljt1g/1utl+QfmXNlD9mk/Dr8qER9hSc1jW0QXgKh9VZC7fqLfNJLypuCJid65V/HYtA/wrVUBkxJ6iuvegk/+zRfE00dzm2bw+sz64WVk9j7DE3nEAHZRh/CXcQSZN2PRFwBajGV9Jlgy+jbW57HBo2ec2Pr1UDifgc/AGkgv
 KbI6TPcf
 zQM8DBniVH67TeVIauotASTL590D7fzB0OlRnC9oKVZ+BcAMdKBBpp9iEvVDN4k/aXTBU8Y6IYcSSFcYAfah/YS14rCo/y6RCMacQi3lhGmd6jmfzBVeDLyH+rA+VWFIh9ZA20PGp26D9xuPGtZB6A3c2iOMXVLmxsefgkU17iAaEdAkQoaO2QSDgo2jw7hemKpgzcdw8czuuCshj4Pq850eOETUGyNkrx4GDS3hzfslUaeSkN/qHqzbFAHLfJg4Pr28HfKYno+KMf8pxfj8j0Qh9sKOE04vwj56syz4pCqs97GFqYgLbvv0aPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

When the temporal quota goal tuner determines that the goal has been
achieved (score >= 10000), it sets esz_bp to zero so that the esz
becomes zero.  However, damos_set_effective_quota() clamps the esz to
min_region_sz when quota->ms is set.

This is a minor issue, the main problem is that it doesn't match the
description in the documentation, which state that if the goal has
already been [over-]achieved, the quota will be set to zero.

Fix this by set quota (esz) as minimum as possible.

Fixes: 8bbde987c2b8 ("mm/damon/core: disallow time-quota setting zero esz")
Cc: <stable@vger.kernel.org> # v7.1.x
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v3:
- v3: https://lore.kernel.org/20260905124706.3398-1-aethernet65535@gmail.com
- Collect R-b: from SJ.
Changes from v2:
- v2: https://lore.kernel.org/damon/20260902082050.19566-1-aethernet65535@gmail.com                      - Changed implementation, more general implementation provided by SJ. [1]
[1] https://lore.kernel.org/damon/20260902150301.88535-1-sj@kernel.org

Changes from v1:
- v1: https://lore.kernel.org/damon/20260901105951.106246-1-aethernet65535@gmail.com
- Changed implementation.  The initial solution skipped the
  min_region_sz clamping when esz was already zero.  However, this would
  revert the fix from commit 8bbde987c2b8 and cause a regression.  This
  revision fixes the issue by adding a specific check for a zero esz_bp.
- Changed patch title, original title: fix quota could not be set to
  zero

 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e6cd405161d4..06cf2ab7e97d7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3242,6 +3242,7 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
+	unsigned long esz_time;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
@@ -3262,8 +3263,8 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 					1000000, quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
-		esz = min(throughput * quota->ms, esz);
-		esz = max(ctx->min_region_sz, esz);
+		esz_time = max(throughput * quota->ms, ctx->min_region_sz);
+		esz = min(esz_time, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)

base-commit: 6f8c7324e336e626bd993bc36f177dcf493a871f
-- 
2.47.3

