Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B01CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 15:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBFE8E0041; Mon, 25 Aug 2025 11:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C208E0038; Mon, 25 Aug 2025 11:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1CF8E0041; Mon, 25 Aug 2025 11:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 439968E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:12:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAE3C160467
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:12:10 +0000 (UTC)
X-FDA: 83815620420.17.1253395
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1EE1B14000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:12:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RiRrf02A;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756134729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyFlJScCtQkbQgBnZmz9mPu9QvkCJE05iM3Z29qiiQw=;
	b=CFL0iGO2tCjN5+zDWkCjJahL2Mp81FO6w1ovg//UnbextV4lc3NQ7LSLOCd7gP9R+BkJGu
	fH9yobufArgEnwE/C5GT+cTjKfJgn6Zr53aKFMSGRReZFundQx/i/UpuRPf+Llc+5nOyHc
	5HK8wqhQawULPrYv3wu4/Wdb9l8L3lw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RiRrf02A;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756134729; a=rsa-sha256;
	cv=none;
	b=bUY//jFVUKu+JCtMmVV9O8h4r1VdIKbYHAs4jVUxNYPGvVg0AWpBy1Nc2gxemFkwxjFDqG
	rzh0vqWmcupwUr/74N1cV2QVnIi3SIVWAA32/R0OOZhfSuXIoPZVXjP8irIjSqrbHbRVtg
	533atbbar00GkNqJQaJ+okbZTC/HP20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06EF1419E2;
	Mon, 25 Aug 2025 15:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88D3C4CEED;
	Mon, 25 Aug 2025 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756134727;
	bh=RCzfFRa9bhcrr9RKjF/YQSphWZ97OW8ZYfBC6HmBfP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiRrf02AmMTYLGGM314qi6OKtLmE6osCEHMol980vuE6MQZuBnyse61RheqKkDlUQ
	 DtzLAiVgHeU48Pn5/tfFdDsTQMwCRVTiwKkR7DtAgR7VYPleF12dtPRgAtfyrnktI/
	 fUznpf/s6C3U80anf45FZgF4TAgBLVUflzRM7XxS8XIoNPkaLm6qvuPnVlgP+Njl1m
	 t2Mbt9hF06AWNNQvG/qU2TG5tWL1oUgpULkhftHzVmpnZwVhgwIHHN3jKzm+bakEv+
	 q0WDSSspIeZ2vtGC0PaSU9L55d2dmZ4Bb/c52lJ+EgYLwkCNnxtkSVd7JtHn//N6P5
	 qZdMt+Ax8S94g==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Mon, 25 Aug 2025 08:12:05 -0700
Message-Id: <20250825151205.36288-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250822093420.2103803-4-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 95y9gg1u9yfumg9md9nsf17sry77ij3u
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EE1B14000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1756134728-59499
X-HE-Meta: U2FsdGVkX1/vN0dha6pBqx3JCTZvZeeSABnoh/vsZ+Kw5dJffVwhX+znTdvLaQ7aJwS2ypc7H7wGslovBKi9va+NF3qTZ9nZlhfyWx7O1JRxTgyKK8x/258AIwTH7elB9yl9Xbtsy6us5qiTTbsuDd2A8Z+wcbJT64QZRnkRXUfb6uVgAm2ObOv1ohkfeUmV/RDA0C8iBimR68yqzBr5ztPzIURnOCHO2UwM6lmYiL01hxtO2zYAihVz8en9CSOuta9cSiwUa8xguAuYDpPzWVFojRgjJu3v5igI4m+e3MWh3QSJQikNNffMV/xSZS37lwS8DqbTApZrHkyFANTSyAUzIrJBQsNY7GP84R+e9U5DQkmvsEuBww1mw7KH59Ay427LI0XlW6HemLRCwRvpxaL9swsTVm21gNZ1mBtyK8TqW2eIFd/0UwAyN5vbyP1Yba9YTZWRSllkJIw0a8GP1Juk/kyhqCCQYWY3kr3mtIoRtwLl4whe1+SjdlC0Kmrv+HVyMtqPnUBZiNPhsmrxpQkxy/20PnFrlJEZ6REN93M6uff0qW3bD5JBtMm4EE30ZUf9b2uVaFNsht7owjvBqjyHaH4/JQhwzwLxjf38uHUig9GjDQQdqLgaeYbNGrpbjrOXNoFDqROsg0V/CddHXmjiWiy9PmVyEWCEcDe1sCzL8bBcy+LNGFVQMM9fg97p7ebn5uqfdeYNwqyAbLuoei/J+HgxIeuiPT2IhCSAmLmpbx3jKf6WpckDkno5yKzZAVhu8aZlneJbOP9S7y6KoIJJzHU5IkrFuRaX3fUluc7DHHhAbWcTEm6YWvGLMP5mKW1I01rmpuuFtR2pzqwcEuadJHnOqw1eUCkSKnzFrbjeRz5558qXl5oZPyxGy0wEAKUCRrjU0GrqhMDxme5gHHo6E/gOjMHj7uoHA8Okbla65l+MKtv8GjIUfTZyjhykBpO47SiqhyvWbhzfyW9
 ivBWHY7+
 nCPZ2RfvUgbmvpF67iIO7wA1yOQjbQImJwBieqkj1DLkH++EsqcQbQkJm6DqTKzW8R5kmXmXg4Jr/6DBfYQmI4QRLCzQp6WXX+j3K1mbe1+gC8ZFJLouS3Loul7kZFQ6ymCszlANC5Fk5uQOvMI8JK8uFF2kqsDCiLetlE+aSTJbYlPabGS6IV3QKXboVNos+ZjCC00JAB/TW6ZwtZyIBOy2tQ6jH1XtMUSd2yr4irTfDF7cfoNCdBEICHKyY5utXvWRqNNHxkX22qffJsTTCH1TsNA7PPcN5kT4MtcYvE+48QOI122DHtTORV4M3IvZFz1iKeE0cbO7SSzzrHfks6KdY61ErzpKH/KSO28rnFJPOL3KIY9i4n+dfEzQoVosMCdB3Sut3BRRSKUV/A2r+mShSIrb77waAIP5hHxK0vxrh/T/DS2MjYbl/0l5fxPkz84BZap8F3Tr6qfP0tOmCqC/Daq7tdjYGhqLwY4qn1jk9fx20jFSSetGg2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 17:34:11 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_PAGEOUT action handling from the
> DAMOS operation implementation for the physical address space.
[...]
> -	return applied * PAGE_SIZE;
> +	return applied * PAGE_SIZE / addr_unit;
>  }

Kernel test robot [1] found this can cause __udivdi3 linking issue.  Andrew,
could you please add the below attached fixup?

[1] https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/


Thanks,
SJ

[...]

==== Attachment 0 (0001-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_pageo.patch) ====
From hackermail Thu Jan  1 00:00:00 1970
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev
Cc: kernel-team@meta.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Date: Mon, 25 Aug 2025 07:41:33 -0700
Subject: [PATCH 1/3] mm/damon/paddr: use do_div() on i386 for damon_pa_pageout()
         return value

Otherwise, __udidi3 linking problem happens on certain configs.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5fad2f9a99a0..09c87583af6c 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
 	return false;
 }
 
+/* convert physical address to core-layer address */
+static unsigned long damon_pa_core_addr(phys_addr_t pa,
+		unsigned long addr_unit)
+{
+#ifdef __i386__
+	do_div(pa, addr_unit);
+	return pa;
+#else
+	return pa / addr_unit;
+#endif
+}
+
 static unsigned long damon_pa_pageout(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
@@ -190,7 +202,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE / addr_unit;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
-- 
2.39.5

