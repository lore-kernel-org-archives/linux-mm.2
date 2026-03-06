Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E4EFCC048
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BEAC6B00BA; Fri,  6 Mar 2026 12:19:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596106B00BD; Fri,  6 Mar 2026 12:19:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3FC6B00BE; Fri,  6 Mar 2026 12:19:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE256B00BA
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EB69BA5D1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:37 +0000 (UTC)
X-FDA: 84516299994.05.78504BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7754B18000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CwJ+JaiO;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19mADysx61wXUL5xco4RUZJAfRn++OSxGDhKOGa00mM=;
	b=jHlq+HnRGyKfR1hVjeihRkXjwtC+f6oI0UGk9H2EHv6+o4jeq1vhKikcAwyN6XlZJCd87X
	x9YiImkqvF3d121AaKUgAcJnERLfVdUewGghtM4plj8VY2rr8A5De3FFE1bD5tY2llSXly
	gXDTz8RXnabb4ZAu2o+2uAFJ11p4yR8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CwJ+JaiO;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817575; a=rsa-sha256;
	cv=none;
	b=r+ZGYBGyCN+TP/MMxXfX7yfOrbyTWvCjhBE4Rgl1A+fugtic8BKuG/QLXxnIf2n0VPA4es
	bHnAC5axPZTZB4dTU7TC2a9bJrv1vOA0yYOfU7Ohzb6BqGt0YvNMRT0XEwWO7JwSZXDyVl
	VMCBKxJ7ldnH1qcQfqholLY/BZ3ltBA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF91460127;
	Fri,  6 Mar 2026 17:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE73BC19425;
	Fri,  6 Mar 2026 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817574;
	bh=EX01Sv5lXfTYk78BKTDVygQlYzTzVovEBgCSXUVGYbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwJ+JaiOGHHxS1bFCqciSl2ZX4/9f+bGWO8AzpSyMwdcRyKNG3sAhwH/CC0EDoJmm
	 zkgyjEz8qKmt0R5fzfZ8dY1kx1NiV4XTSs9vTgXu0K9n/koVg47wydd37a43JXNGyZ
	 ZE/XhHy/DdAmMbr/vnnPfX/fzyJopSE3VCuetcLg4uHzfWlJVHp4kr+olUC+RK4EvB
	 L1KsYhaHvTBm+lkVMat2tDAlcDX/kHv7JYgFuvj2mSDAEAOeh32vxiQycKiWty2wB+
	 lWENr+BNKrt9mpGiMF22mjCckSRbEBDDMDdtHygFdbAUpyTZBaUP4BfpZ+O9UtXqXT
	 yL8z/fA+jDO1A==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 11/15] userfaultfd: mfill_atomic(): remove retry logic
Date: Fri,  6 Mar 2026 19:18:11 +0200
Message-ID: <20260306171815.3160826-12-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7754B18000B
X-Rspamd-Server: rspam08
X-Stat-Signature: s7e1hr3anyui431nn3iih7ymwth7waa1
X-HE-Tag: 1772817575-12000
X-HE-Meta: U2FsdGVkX18Zfu1/Cro7L9M8cCnxKQdR4f7WnlWGYQMVUnlAiKFLNfhdPLnpyhjvO+49iuOBf1GYH/8aFg9p4ncOEFc7xrecL11CbJdCRSAyg+j2NHzDdkFRXWBoS0J6ZeNKTM7oGWGbzQNH9o9zNyLf43QY7bnT06IM+sP7pxsgNDvHoDLe6U5Bi4t0cCDQ6PNmmeg9/qLZu8XdPG5euWB18Yc5YYkwFTV3sUHlWs0WjjJ/W2O9/d0UZ4fWWPOJ/RpClF0zB39N94lbPwuPy57aBXtc70AYnePtyjMr7qPUnqa5hdlNRntH/mtjmn8XvqdybRR6O7VNiyR3o+fKLkTBxzA2Lrx0Y7uqsbT8p3GRHp9h55nrKSTTz84iw6A9+5UEPmuY4Qd23bwaqzGDAI71YZLqq6cVEUVj7TPywEOayy2v/OvkAiqLGvpF7r3uZNcs9qOs30WUDeYUme7afuxIYoaaP81JWZnt6rLdQ6nPWXjrqBJ3o/UW5G9Fc8bN7CM4gPdde4DJnJR4rn6yTMy14REcIu1Jb+xucY7gUGqVp3Iv4eOR1OxK+QZYife0Q9oY7HjR3sUr6/D9m3mz7ueBW6lE9oU1T1b19FFomGORVOTxoQI6S0ftgnMCw2P7PyClxpZHFrNdUXw82cvxAenpn6OU8eEe8VHc4y7aD17TZ2HMkQ3gyctvej8daZU1n+wu5u64FsAP3TfLOwdq5yGN4uCcVgyQ/7WSJJK+ZtHPvBOQw/9Xa3fcmPB/l373b5JBazYr5H3DyskP8iEiYhrLQQ9HBiJ+5Ioi5nS6QMaAdAfOaqmEolFnsQm1NEcaCo5oMHyXed/f9OIntEr4UNSI0SKD+DIGgdcCsc2Y8Yx04TjFxROXO7wyICloD98kjS9CJc3XpHfgT8wdCiiN6HWJcWjlFAfxQx5Kpi8cX7Pgb/l3dJWobqqEE6PkHOZhLAHPsd9mr2bc/KFyrfn
 Fr+ZOeiQ
 f+khEEGAnm2aBU/GRzjaHKtK8Cv4+xXdMxmbuUhgpV2Kyy9s9xj1PmvGQVsTUNF1U+6v3oM80zbtipu3t9IAW6qXGyDEOAcY36OW5wMfP5JpvW+Dk2b5or45ikx0YL1cJonglDCaBr4BZ/z+hTzrfeXhuDrORsngz9O+1RMf1U2dabsRR/3gVRBURClEfuWhVrAJf9baGTRzh8tsy7JHVLcP4y3mDHbhvJ+yV+dxDjpGM2MkcIUCNWlsiBxWHeOuo8rDWYYU27jnC/n80okbU+UDrBTMUVA3p0Mtv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since __mfill_atomic_pte() handles the retry for both anonymous and
shmem, there is no need to retry copying the date from the userspace in
the loop in mfill_atomic().

Drop the retry logic from mfill_atomic().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index a0f8e67006d6..7cd7c5d1ce84 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -29,7 +29,6 @@ struct mfill_state {
 	struct vm_area_struct *vma;
 	unsigned long src_addr;
 	unsigned long dst_addr;
-	struct folio *folio;
 	pmd_t *pmd;
 };
 
@@ -898,7 +897,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-retry:
 	err = mfill_get_vma(&state);
 	if (err)
 		goto out;
@@ -925,26 +923,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
-		if (unlikely(err == -ENOENT)) {
-			void *kaddr;
-
-			mfill_put_vma(&state);
-			VM_WARN_ON_ONCE(!state.folio);
-
-			kaddr = kmap_local_folio(state.folio, 0);
-			err = copy_from_user(kaddr,
-					     (const void __user *)state.src_addr,
-					     PAGE_SIZE);
-			kunmap_local(kaddr);
-			if (unlikely(err)) {
-				err = -EFAULT;
-				goto out;
-			}
-			flush_dcache_folio(state.folio);
-			goto retry;
-		} else
-			VM_WARN_ON_ONCE(state.folio);
-
 		if (!err) {
 			state.dst_addr += PAGE_SIZE;
 			state.src_addr += PAGE_SIZE;
@@ -959,8 +937,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 
 	mfill_put_vma(&state);
 out:
-	if (state.folio)
-		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
-- 
2.51.0


