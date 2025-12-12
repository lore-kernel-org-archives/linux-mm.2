Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2380ED43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 03:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431386B0005; Thu, 11 Dec 2025 22:13:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E21A6B0006; Thu, 11 Dec 2025 22:13:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F166B0007; Thu, 11 Dec 2025 22:13:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 209A56B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:13:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9404C036A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:13:36 +0000 (UTC)
X-FDA: 84209348832.10.D853FC4
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1DC6E10000E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:13:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EzyenkBz;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765509215; a=rsa-sha256;
	cv=none;
	b=L24N6kChRj6mVh5mkz7LmvFIW9kwIDlm3Fu9QsomjcYgoJ1gNxDCE9xL9bX2NICdvgENBv
	xxpWMZpVYeRwuxQFnayvKFSA+zdzohleq1tdYg3dQeaP2uWb73hmIrE9wZ2Cbg0MfbX/El
	/eI5hYX7NKdvHzCwBr1udHGcD4iSm2I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EzyenkBz;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765509215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=byRirJCR8uUeqSLSE6TQmk0JDyPI4CmoE6vRDYCIDjQ=;
	b=KoQFDVSPMaz0EwWanuqr0lhewLokpsrYM1ePu9HoE7/UHr9HsDnaTrgj7TB8Ki2Sr6gssr
	PIV95nbMCL6rxNq7HVOPMZyHSvjWPOR8kdH6p9WmlPuaOSeZshIRxGWdoqgF0H/MM7e84P
	pAlXQm996b3sQ1p4ItBlhYjCH6cdm8I=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765509210; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=byRirJCR8uUeqSLSE6TQmk0JDyPI4CmoE6vRDYCIDjQ=;
	b=EzyenkBzgPCMyGRCLJtda2JnXYALLxTpAkSLPCJXAvXJeAhrF3O/aXaSJ1QCnj5qEnW0rR/xA6Xqonuwe2dP7lm43Kj4kTz+k/X5ZBXyJ95Az9T20dCQutwsKa2c0GWQ6S2ZSpif47toCyj3H108heClnJyx3478N3DFbf8s22U=
Received: from localhost.localdomain(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0Wucbb11_1765509197 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 11:13:29 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Weilin Tong <tongweilin@linux.alibaba.com>
Subject: [RFC PATCH] mm/shmem: add mTHP swpout fallback statistics in shmem_writeout()
Date: Fri, 12 Dec 2025 11:12:51 +0800
Message-ID: <20251212031250.206571-2-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1DC6E10000E
X-Stat-Signature: thgu6qf3ji65z5owmbe87e6nushxjx5m
X-Rspam-User: 
X-HE-Tag: 1765509213-757020
X-HE-Meta: U2FsdGVkX1/NHID8CJ019sDBhtbIlI5HFkj17GOEDTAqMFn9mZnpqJFWYxCI0wYujk5e9+tlqOmG4+9OUVpAH8TJEbvc6LDfoyypTSdL4p4Bop4HpRiB4sFR/8FcC8OnuyTrQM8ZpWcDkjxc0a74fk4OhXwHHnSXpXQMlnTJKienbT+49mcV/Tt4BFEVRCxre/FbZtvc7cD0/t4O+AH0NShsMS0u32+/iMYhqQch/kZhrEtQERHPCe+EeUf0sN2lh7ysGUzcZMMzUWCLdVG1p1QC5sfQE3rAgKFrcF1L/Rm3JNBRfTIPKIIZM8O+EGmwhCj6j0uoCxekCpvjZouti6xofEXsgEM3YEJcNQeAUxO5hvaJXHr+vZbFoSu+1V9kVgKo7/3ndgdGNC5ViFrEh+fyfUsDIpDgMtoQkAZ9tRXwu2JuwdG+R/m8aMsm51IxJj/o7+6fR+puJD7Q1SeUyIuiuA78oo+ggzBfR5owurqzX8ElAO0C7YDdbKIjiDRv2kubY6x1uPJ51cfU8wNwt+nOuV8jMAhvteFOvWmLaaEF4MAAvh89A5TfoLaNZwplvipqMFeeJZaxRW0W4MaP9RejNmjShXDaBc+5cMJsrG8ZEmPaNBS0vVEZ7rw8HK5KlY0QYc2d3ZM3nij9XsOc3IJbA2Ti+I+oTrK8vdD/ydd8d6h9/FXsV1lWxqn97+o9Gj2Eq8OokHu07nl1rR4z0a8Y+t2xpDvCwerBBUptTkaVhf38dYLEXK4FLihBmAH6QFCSv+YS6moYveBD/Tzgc5u1jFgAghju2yQ5VtFQz/HNeWYRBXVwCiU5f+9rWJk7vzNNMzEqipMXBo5h5EYASMugzbph3EgkkyrHQ9oUoSggamUmWxdsbQciyjhVKdnrlMHrijGYwVhAtUhXbTza7KM9PjxwJT1hbvedXRbNxxL/BQ/PB8NTjoUretREhg5hzXw3OMRdutYJbpGHzVJ
 eQa1244U
 NBjG/TjSB275KzuiGbmCmBwbsBD99R3oBQ9R+iuQsj6boUxzauVxzfPDiy10cM7zpZa9MKirJwYaKgxCeBMyswKCe3E2pYmY873QmzbPRWQpT2GmybTCksPp9pdavI2PZIFuTv1Kv8WsHzvZUqjWGbPlkCFm1Z5Ic/DBJWh3w0X1xgiw3X2cINxt3XO8LEgsnfWj+WbmVo7sz2zMF9RiHPw0dy2waUXw6BSwntXa+CK+QQyDgQjnjxGkFb+7sbFvJgB/4NJN0C7DZtz03bFTPpqVqXEzAoO3S+PivqHxyinfRsVCuPiYOeAEReNiHPpZkbZY2c7kYLdRG6OM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, when shmem mTHPs are split and swapped out via shmem_writeout(),
there are no unified statistics to trace these mTHP swpout fallback events.
This makes it difficult to analyze the prevalence of mTHP splitting and
fallback during swap operations, which is important for memory diagnostics.

Here we add statistics counting for mTHP fallback to small pages
when splitting and swapping out in shmem_writeout().

Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
 mm/shmem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3f194c9842a8..aa624c447358 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1593,11 +1593,23 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	}
 
 	if (split) {
+		int order;
+
 try_split:
+		order = folio_order(folio);
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
 		if (split_folio_to_list(folio, folio_list))
 			goto redirty;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (order >= HPAGE_PMD_ORDER) {
+			count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
+			count_vm_event(THP_SWPOUT_FALLBACK);
+		}
+#endif
+		count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
+
 		folio_clear_dirty(folio);
 	}
 
-- 
2.43.5


