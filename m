Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0F8CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740F08E0009; Thu, 11 Sep 2025 23:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA4E8E0001; Thu, 11 Sep 2025 23:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591838E0009; Thu, 11 Sep 2025 23:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4EA8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:45:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D17BF1DF450
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:45:27 +0000 (UTC)
X-FDA: 83879208294.24.5B6EE50
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf24.hostedemail.com (Postfix) with ESMTP id A9B8D18000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:45:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fXzjP3cf;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757648726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKGpjwgTH83TkZL4WURuxVYUsITlLr6bKFdE2iILSCE=;
	b=WdXSJx9n765uJx5hlyf7JZ0SSNVNMSOeUXh/OBcpkvcG165OxOw3t4H13MSmNsH8SQF27q
	mBuIyvatI3v9oPZ6DUp2vGTzHYC+USljLai3mGvkmoDmYLi9oB0ynVsLc4GLX+eNiGD/VW
	7hu3gihVtYtMs/1dDoWOKNoD1cnTKIE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fXzjP3cf;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757648726; a=rsa-sha256;
	cv=none;
	b=FgXxgyRcBRQbYlLHhwIlzOtmEVcCWpIb3j1sBqXfIltK6SmQWLHJnuATdLVGy5pVB3craK
	FyTlvBCUgWMYbH9QxpNfltCKl9z3ywnt+AglVswPyq/kiraC/U7S0sTS8cbIMz9PKaAiXs
	YeHf4tQ92U0GnkJgoK0qBSBO2I0gLfo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757648723; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=HKGpjwgTH83TkZL4WURuxVYUsITlLr6bKFdE2iILSCE=;
	b=fXzjP3cfahVwhiGm10Kb1brdp+rkGnIjSDvbca+5C0TGqausaXUH546hDMosgJWieiUzBvcnF0Cr7GkAv10PlMWHFEE5l73WfnNanHNzUaVN9dRozsTkfkSsQG/RKj/clNYnK3zmNhprhV07C89d37B5yneuaovABjAQxsgyHbk=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wnp-5IW_1757648720 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 11:45:21 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: vmscan: simplify the folio refcount check in pageout()
Date: Fri, 12 Sep 2025 11:45:08 +0800
Message-ID: <e475c5ddbb94763b12d396122ade8ee3c711a967.1757648598.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9B8D18000A
X-Stat-Signature: qa4ct58dc6t13bmdwrs5hpqmmr1jp5re
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757648725-635832
X-HE-Meta: U2FsdGVkX18gR7FXZFZWFNK4T7eakdyTLwO24fEc4ddkLoPER/dvejpWbFoyMgpY/k5O90/U53F8ovf4yTOHbWnSEdXKVajMSZKZ1vC3G7N7bMyRMW/3fT0PDG9CaaaxqL4BNYT8ErlqYqkDotz6usdLxGipKJrf2RyRcyCxAQlNmvTYlXHxC6F8yBxe6a7VFpI6duwiUb5RGIy2YdcsUMItnwfIcQv89kW3jtUU6HBmsWKBHeolgqOTEemh1/P0bRBB5frQiSMPI+hzqFI/O91H2991+l9ahceFAtIOH0hUgx4Wl4XTLn4A0PUqxv0kHQKS/wTzc7ckVQklgH9oG9C/hATTWC0q1vxHk6e2zytzDdsrU83SQvT/892dlyBF+CQ+Yhu/sh3adz3BPk6VYKm4e5qoQP7j00E6Eva25p3E9Ot9Xi0UWWtYwpsB7SJ5oLHVHj9twlS6uKwZOEzxvdPMSWr/jvpQNUoioK/DfPVm27HhyhGNDMFJNlJATwm2yK89OvvupmrSRZ6aOXGA71/+GtAghGdkv5eVnWzHMPl3ChVgJxMvhtSs/OZ5JNZuUsPe1wHDGfdHm+KoAf3QOSNgZ2oUY2+xdTalWBWlfu+Mbuuf9JuOxMkgk19rkwJ4TkF4NgMvb8Xp7r2KHlJQO26Jit5SMUeSXjovz+XHavNNe40QAqerpZvmy1AFMlXa+ERrX0Z61EcpbZNSzUFSKIJDb7y4gUu7nwLVOL7wq5ikuP6ELrs6I3FGJh7e9Cbl58p9W1vdGtMmvOKAPwJ9hZDUN4Q51U8tw2eE/0CpSA2th2ttn8JOx7PmiTBsebKgUU0ifYmhHkbCotiN37FfTK8x/7bs6lcMrn8acVMek+E/kTy4SeiBWN94RlVJd/zn5tP8Q8jhtB7p+lf8k8XxFEKpd0o0KSvy1pLkqqNc9xcEF+iXIZ40hrWLzmW7ms8NbKQMsJveWl+jUGNuBaH
 Tn274Vv3
 qCCGAwdw3EboAk2kLbANMiCJYSlpWzOW5skr3oFaip9J/pOJlElyQXyzyLvDLGPtptw8ur2eO81+aWsraty70Y793hHG7i2f8ye1IJuljUfpSDQ22ueAUuBmw8sYZd8nduu01h068DeqVGig1ymf2Mrnk2TSbkfHHv9AF0PoyodMxg29s8qbRtlxlM9hQstPOt5Fid0NSoTHLGXJBQznGXk1fq5mjN3f2eanx2O0O2XHL8IIqmuoTtbx60e2QBj+iafP8FwHnLAgf/HskM/ER5U0GBdUL7uGKQqrf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we no longer attempt to write back filesystem folios in pageout(),
and only tmpfs/shmem folios and anonymous swapcache folios can be written
back, we can remove the redundant folio_test_private() when checking the
folio's refcount, as tmpfs/shmem and swapcache folios do not use the
PG_private flag.

While we're at it, we can open-code the folio refcount check instead of
adding a simple helper that has only one user.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8056fccb9cc4..46baaadc528d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -477,17 +477,6 @@ static int reclaimer_offset(struct scan_control *sc)
 	return PGSTEAL_DIRECT - PGSTEAL_KSWAPD;
 }
 
-static inline int is_page_cache_freeable(struct folio *folio)
-{
-	/*
-	 * A freeable page cache folio is referenced only by the caller
-	 * that isolated the folio, the page cache and optional filesystem
-	 * private data at folio->private.
-	 */
-	return folio_ref_count(folio) - folio_test_private(folio) ==
-		1 + folio_nr_pages(folio);
-}
-
 /*
  * We detected a synchronous write error writing a folio out.  Probably
  * -ENOSPC.  We need to propagate that into the address_space for a subsequent
@@ -696,8 +685,11 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 	 * block, for some throttling. This happens by accident, because
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
+	 *
+	 * A freeable shmem or swapcache folio is referenced only by the
+	 * caller that isolated the folio and the page cache.
 	 */
-	if (!is_page_cache_freeable(folio) || !mapping)
+	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio) || !mapping)
 		return PAGE_KEEP;
 
 	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
-- 
2.43.7


