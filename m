Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE73CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2376B00A1; Thu, 25 Jun 2026 21:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78286B00A3; Thu, 25 Jun 2026 21:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990F26B00A4; Thu, 25 Jun 2026 21:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6836B00A1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:56:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB928C1A24
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:56:32 +0000 (UTC)
X-FDA: 84920399424.07.100CCFF
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1C9AEC0006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:56:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=W5snFvZV;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782438991;
	b=yxtEuk5qR2b8uS4vdZmefOp7E7NrIh44pwTVMMFvJF/1AqYgNyF7mtUaKge9FLH441Gmcw
	hztsLPGF80QLlt8Pv3+uEFRfwMXieHhJ2vR3sCamfLth30KtY7mj7Qf8wvAzT0yDWLr58m
	/InQXXyHghaplwbLRxnBrABLWhpEOJ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782438991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T0IN4V44VtZA6IPeMFy0yKV+OBq+WrgvYJ7s1AHVR0A=;
	b=YGbvHTsn2VcMMxSjZn2beALrWKNaWwxC0tB3hp95/6wX98dhUo4FZn8naGgv9FqnFeJmrw
	5xKOqzpzQS1WRRJMRJ3cVBcjYkrEk0RdyI5B5F1gELB1F8/xU0w2ibEy2Z7Q2BK58gGtbd
	f6CMHLgy8eFjNI4jOCLWLMiYJlsVXTc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=W5snFvZV;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=T0IN4V44VtZA6IPeMFy0yKV+OBq+WrgvYJ7s1AHVR0A=;
	b=W5snFvZVarCkHUD4nk3tP67lftHb5WG3EEqYfhrYvMRK+NN+icERFLxLfS83lFvFvFon7CE1o
	odU/SjBq/WAH2ctVXgGPfQahKPi0hsE1Ccgm3MVBQh1vDNyhi5XGWE4g6Ax6IekuI90eagnRtmW
	nFE92tb5H8Bn9eXksZEc7ks=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gmdpm2hkRzcZyj;
	Fri, 26 Jun 2026 09:47:44 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 076F94048F;
	Fri, 26 Jun 2026 09:56:25 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 26 Jun
 2026 09:56:24 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2] fs/proc: fix KPF_KSM reported for all anonymous pages
Date: Fri, 26 Jun 2026 09:32:52 +0800
Message-ID: <20260626013252.2846774-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: dmusjns6q5nsaeupzw8t5gbepuj85cjf
X-Rspamd-Queue-Id: 1C9AEC0006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782438989-354793
X-HE-Meta: U2FsdGVkX1/je6vmY6cjS/QbTG93Bc35Qr+rzIML0YwPqCvuI2yZe1zCgUOXpeFJmPQf6jPUiJZrT1kKLaCWK/LH35yK5DZfG5fbCj1Z15wUoAOAoc5fddpGMtlPp/rviDZlD0um9Pp1JreVR1OYSF3dWeS64b2rbrMB7izw+jCoZHtVBfeD8fIUMwkOZxid8pjoRVJLZClqSpzTBAbl1xMHeGSZZC+ZG1PVbr00EX5JpkFmUb65fVgF20VU0+ZR15YIdrA+1ueCxN423pJYnJcIl/OU1q1Yh+mVHp6AJMC6HaKGPwVl0OPZxez7GZtLJ8yIEyNsYXRtmK6/qHEinfroiJJ5unROGx2YWvOWtBWWKEsCmUv6Zp6y4sJC3R8OTJ6iKUFWxBAO5pwKET2hLpxEJZchpyumxcQ6lOxb+AdzTt9Gy2kpuAFykocXs3ezqeA50wol+KLG1EiPfyUuO/sMUREqSgg2oSo+EHz6iwLywQYkv7J82Fvs5W0El6O7CLLXQL6uCy7ICZ4iVpERDSwB2qTu2tHYYjB6uuQEQz9VYX0ZFkfRucNavoD/c4IWnHKz88suf0XR0s0KwdZ82/y2pGSlorTZAuDYTmcQBN3AKaD90cgeEEv8bD3cOLzaOMv9+LUHfzC6gFQo0CxmaQ1qmMIlTNrxSqO4ngowlRzLDY0FOWVTU5F7ufKyhAFTVxPIliJN7ca63ur1PQ7FxVFWfAHGZkvO/eetKJk7K1dSbtvCoTnFTGlbOQoKjQHgNeDTxry5J/RdVWfc4DB8QpeQpOFGkpWA5TVtU1ufMFzBZy3permpaloYCiocvZl87O4F15SOLLxQ6ZQzswvgZF3PZ9QW8uJM/GAXSiKs/nxr8P70eCiZeVkjSI4eqMU6QqQutjT+XfPBUhDFG9nQ57hfy0oEQQxIrFD50Gxw/ecOMHAPSH/p9sHkGWgES+FgVWHH4LqnJ7GEniMIM+b
 h7jv0RBH
 cQIuYxGl3HqfF+UV+D0GRScUUXoNkqWmOVKJP6K/rdxgummRHFRtbX9psVJFreMMFYO0y2TNqPR9bhOj88iR8zYBS4RLVisdXmn4hOInXM90pET7kq5VywLdkinjOAD6CjNUcRObg+udun4S9scAQ0K1qOXJzIsSfEKNzXbmrLjc7+mZ964d/8cKsVHNDQ8afinsCbmzXOK7zHN+T0eDu/aR4feixmOl06AlECYgLtI9xvhIkUuUN4hHS1m9F55XLhRioIsVvdVtqsCXCiblPfh8zVPmphKnmu4UY3NXL9Mifi5EXTRCHXDt+KSkti3dVihTbSgr8MGCRLDXUJNVy5DHE4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
when KSM is not in use. As a result, tools misclassify all anonymous pages
as KSM merged.

In stable_page_flags(), if the page is anonymous, then use (mapping &
FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
(mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.

To fix it, use FOLIO_MAPPING_ANON_KSM instead.

Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
Changelog in v2:
 * use FOLIO_MAPPING_KSM to match explictly instead of use FOLIO_MAPPING_ANON_KSM
only.

 fs/proc/page.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..7d9387143435 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
 		u |= 1 << KPF_MMAP;
 	if (is_anon) {
 		u |= 1 << KPF_ANON;
-		if (mapping & FOLIO_MAPPING_KSM)
+		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
 			u |= 1 << KPF_KSM;
 	}
 
-- 
2.43.0


