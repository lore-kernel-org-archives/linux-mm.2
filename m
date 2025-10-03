Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8447ACAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49958E000B; Fri,  3 Oct 2025 16:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA378E000A; Fri,  3 Oct 2025 16:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1F48E000B; Fri,  3 Oct 2025 16:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7768E000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:38:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 451251A094E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:38:59 +0000 (UTC)
X-FDA: 83957967198.23.1CE12BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 975FFC0007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:38:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S4L3F+p0;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759523937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcrl7/60KaX1jcDkKq5wApSgdb7W8rnhd6D53REykqE=;
	b=y8JmJpJLdu2mfpvIxBLjwpymQZZ834I0ZtnnVAQFfhsja4CdwYBPonsWMamDte1VfUdL0N
	n2uV6S3LAu4irkmicbz+qWQI2uehLSRIHn+GgA/ph+utWllnrPzijwfei+OIbtm7tev+Xj
	ryr8ukixncipFkh4F+DH/rBIPQ/bD2g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S4L3F+p0;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759523937; a=rsa-sha256;
	cv=none;
	b=b/qP6LevQhhSZ50p4aQJk569zatFxdtBq6hObUB7VAHkVMcUybe+M/Pnscm1KUiC1Q0/+H
	YkJS1x39Gqpu3dfF+MAb3QJ4lfjImnhkhrvSMMVzP4UiipqT51WDsT+wOlLSPOOhIH1vzj
	xmgk/ePRPOVHGXjmbB+uZGn9F0ZqXt8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BCE948A20;
	Fri,  3 Oct 2025 20:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150B2C4CEF5;
	Fri,  3 Oct 2025 20:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759523936;
	bh=AeleWDuyUJnZpkc4cw1hO6AX2XUTuOPcOCcE8L+UJic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4L3F+p0Ttkg83PfSG5zfqt7CI7+pPYaDjiPpSuK35EUoIoIVcuv6V3Srzu1o/oKT
	 9k5MNgcTUyTGP/6F/niObr5CU6kwDh1uTRUkFuXkatr32bordchdMQnkRl0y094nju
	 eTi74st4JX/ZgYbTKIZ1GzKKL6KGtwE5YbGha4Hdwmh549xHD5PF9gkls4rkvCnAvD
	 /4S6BzjJ4j7n+OEb1uZ6TWMF/GML3AsDTMWqhK9ESVCCjPXLQssq9I/yNoc0wl8jxO
	 MjAoh0wHLzU652q6+EVeUyv5+wU4eC/gUVoPHunRMdBcZm25AoUQu1TZMn3rqkYwU0
	 JlYwX08bTtpVg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	cgroups@vger.kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm/zswap: fix typos: s/zwap/zswap/
Date: Fri,  3 Oct 2025 13:38:49 -0700
Message-Id: <20251003203851.43128-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251003203851.43128-1-sj@kernel.org>
References: <20251003203851.43128-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 975FFC0007
X-Stat-Signature: jnsy4qhumnc1seiiu5pxu7f4p8bwm1wz
X-HE-Tag: 1759523937-611926
X-HE-Meta: U2FsdGVkX192eu8gTXdbACuIUgMHNIz0rPaQ7yh4e1vslS1Hbw48wGJsw2Yo1TGkL6m+ERBfXQepfLOH/ms1yGpZojzrqgDLqtsCYp6XjE8yoMsbfKgS4W4Euyq68DrtqgJSm+ofdPwnGfb405STIOA+g/5FopAZ+euOc+dGWG5rPvvIZOq2HSpqEiqlplNbajJoAU6te8ieF5EKAMRORBZXio6AR4/PeZzWFyT/dzV/8tZk4bi/cHrlKTqcmmtNw6FfOxgZx5HZ0ISpXDiwnfDm58oiALdjkxu9JKNy8P8z5uvKDz+gQ9rhZXnOpcZd14ZTStM/KTnKBzU8Sip4Uu1K4ZvpKsBRNBMS6jbP6r52qN6PO3iMb5uXCQtyR1DxjiqVQAwyirww8XSnREy3SPU/z7vX3KKZ+72ohNfHdFEEty06yd+K+lQ0JM3wm6ah9v9AyDqvuE2muld1jB5w8FG3eKRBbepO/Dk9INGO+2rkI7LQuhx5DL1JUMS21UztY3TyR40/cFkgzsEBrpVm3guWsxRTLaO0+YBXImVZKl18RbyKuxvvSiSwQWU/j/z9uY2XG/xadT53AszcrK2rloig4Go4TDLNqwoR9M8rppCgiu74+Bx0x1ISYE26G0949iF0IAFr8ni5wAG69uFF1ynmQjy4jxZfiX+ZWbUg5Pp2RyEWxe9nr/RjspI0zsyCkQ07d8I3xfln9IS9t36/U2Kvdvj5gYHqCkZsf/Ux4YB2XZP4xHLLitCLBrmTAWwkkVHMKSXedFqzgoqfQWTd8DRz1/SZZazV/ks4EFRTIIx0xCmyUOxJ1+cl/bZ8CyZB6OFDxhGOwnEYUzVSlD9h4UHJGU+BZyXTTos2oaP8HJrFnNZ37BITa3NDLfbx3BkXDylse8dOW805vZ2l5wgZl41soR8sC7SJNPvDZES5WdCQrRdx9soHvyA30IBiWNHBNaT1DTv5fAr875exu1r
 jZ9QysOO
 Q7L3WDe9Lt46mouWjQ6RGR5UOwposgijFXwA0SQlnoJo6MfGYBo2w4WCmFNKJAGd4BhBgeaQCGEIzd3FnyNJza5l+dbMLbGL4x/4LbVMxQTWS5P6KLWlN3KVrJeDCftTnkHQRdstbXPR8Q/0iOPPU+0lRpeBA9Zw4GOpo4q5rcXWglwoIwaH+mtTGyU7CZxXy8rExvDsDzR3Pdc5+WDVKlwxZ2nzsLCY1e2K7VHJi/6ZNgLg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As the subject says.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/memcontrol.c | 2 +-
 mm/zswap.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 69c970554e85..74b1bc2252b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5421,7 +5421,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
  * @size: size of compressed object
  *
  * This forces the charge after obj_cgroup_may_zswap() allowed
- * compression and storage in zwap for this cgroup to go ahead.
+ * compression and storage in zswap for this cgroup to go ahead.
  */
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 {
diff --git a/mm/zswap.c b/mm/zswap.c
index 80619c8589a7..f6b1c8832a4f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -879,7 +879,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * acomp instance, then get those requests done simultaneously. but in this
 	 * case, zswap actually does store and load page by page, there is no
 	 * existing method to send the second page before the first page is done
-	 * in one thread doing zwap.
+	 * in one thread doing zswap.
 	 * but in different threads running on different cpu, we have different
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
@@ -1128,7 +1128,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 *
 	 * 1. We extract the swp_entry_t to the stack, allowing
 	 *    zswap_writeback_entry() to pin the swap entry and
-	 *    then validate the zwap entry against that swap entry's
+	 *    then validate the zswap entry against that swap entry's
 	 *    tree using pointer value comparison. Only when that
 	 *    is successful can the entry be dereferenced.
 	 *
-- 
2.39.5

