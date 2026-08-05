Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5195BC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620F26B00A4; Wed,  5 Aug 2026 05:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8AE6B00A9; Wed,  5 Aug 2026 05:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535846B00AA; Wed,  5 Aug 2026 05:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 341466B00A4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:31:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8B8DC03F3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:31:51 +0000 (UTC)
X-FDA: 85066698822.17.983A4D3
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf11.hostedemail.com (Postfix) with ESMTP id A63CA40008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:31:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BUoqGyei;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785922310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vsx8ohQK/83o9MDCUHCo/Q8Sepsxz5zu7PBe7bd24eY=;
	b=6W2tXhzERRYeCgZfzaElM7I136qAn0flvMX4gFcHW4zSsDT4UJ7OaTQDE/8Da1PxHsVN4v
	xpZBLr5mae5shz9toSTlqE1yfO7tGtCj7o4k+h3V5/4LJz8ACcGtMHUIyzd8uG2GonQn9W
	4W90cFDSvC7W6wIL6+87/xAa4WslQMY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785922310;
	b=mMZIuF/ZkbyE4VLqssBLOKwUEuDDLAtOZn/J7KJ1XCEtGjiQdL4U+H3gorEfTonKD+4JmL
	ZTXLdQmQzmsc2b6y+zuIcgZJE/IFkGG+hBAM5QH6fxGWJiBOFqEjCADbKrUWbSnLxQUdv+
	l75wlRodpDh5P/xmUVLLHhU6OEU6H8c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BUoqGyei;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785922303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Vsx8ohQK/83o9MDCUHCo/Q8Sepsxz5zu7PBe7bd24eY=;
	b=BUoqGyeiVUyNF6/vZtZ+co88qVbtokARpgoSTCa0k52btw1jkwzbLSOPRuS/QokdKRKATi
	VRKcDwi+RMbxc0Csk7ERUpIon0JTvBVE5hI9/AmCHXodFhFmgVpud/nAeMta5ZDmvVIlQ5
	wYrGybf2GxSOhUvBaFx7EU6c0lLxKy0=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: debug_page_alloc: fix type mismatch for debug_guardpage_minorder
Date: Wed,  5 Aug 2026 17:31:07 +0800
Message-Id: <20260805093108.2352900-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A63CA40008
X-Stat-Signature: 9jd8r69m1nxwtzagdwien6gcergmxf3d
X-HE-Tag: 1785922308-514542
X-HE-Meta: U2FsdGVkX19pZrUDYVAlc6UcnafMHPNZAwVq3awjK1mFuzwKpFan5QXiKf3Dl/29vcK7bvp/g25JFIvuXe1HtVa8I4KVKf/NIpD/Dlob0S1TV0m5VZnSE5swmYzM5kI58WTI0Dtvo/mD3ECBwVGEfsEgZy3n+ehsue0Yl5xklDtnlkrnHFnfYwFggsdq4IkFHgW8nVbXJjGF6Zou+td8zkWr2vQdtuWJuy8CClNkYTnFOUEBKzbTxpoj3eKjj/KjC/jk/k8uEIsVOK9IJZckQtsfB5o5jfktxecQk17A58/HhxnYrMUJpCmwH2GoVmK7M2myoM0rd6oOvNe+9DIHKWS3/GEAY98qNgXfo9BI07IHF2jkwVxA3ox9Blx8NTTOOrw6U4TkTrvTzhGh1HZfUrI0Gc0X9BQS/J6/Tdqn9KnP+NQ8NZvCkKe+NtM1iSmxX4ESssQa8tmkK5bmPHPImr3hU0w3HjhdqxSYQ2rSS5WY/eqs8axpWdDgsUuR73ZuG/bIeLfw1Nl/R2gsCJ2Uau4v+um4YvQJcqVArKccb99zswps9NaZ1pRWwsTqysOMbDpg45pD5OrzyychIOhS4eUBR3p+/kFMKOQ5AUdHZn+DeT4ODTx6gBisx8AGi8afywAH1P9tmrjtSUY8l2EcKkxfnSsgoFBvtwCKKqSeyOn5HLFpY7RXsjm4iLkQ4fXbG3vfLn/5mz/JoWLLgbTjTEyLP1fpYRuzW6RVtHjgaC7gfBCZN/OQtxmP66D0bKLmc4pyhzIe3b+cd1MyXo2MODqiyJOpA7iVrNzSLJh5Btbp3YPOWc0XdgeL5PEWFLIGg1sI0nzb/nuOY86wvfwgZdT5YIavVM6DCPMaBr1VVGdr98tlsJGSde4sBK+yKB7Q74FmukMIQkrFk0+L7tZmsdLLsBnFBUjRpTxmaomWIAs4gllRpKl8OyUui4eI/y2hAFbYa5YoLFcNFyeQDLj
 3jESEcuO
 DM7GGjMLwEjaTKEbqQiuy+wzvCLdOH2PhR79Um9lYJvfCtgEFyfdXQFCN2VjOYR/Uk6fMMQlQyDE9hyJSIAd0YudlX5w+dq8gidBFRsp9Rpc3GyI0Jd5cgug4f+uLGY8NpgDGTmdZsosZwWg82iCng/YooA/nVJ8bVdaN7tZg84wjhQ258s+DnHKu6M22o/hqVVWhULwRpntMKYA1T0QKpIV6J9svAPQ4fzQonE+drV0iXtvFRxAefzEv0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The _debug_guardpage_minorder variable is declared as unsigned int,
but the debug_guardpage_minorder_setup() function uses unsigned long
and kstrtoul() to parse the value.

Use kstrtouint() with unsigned int local variable to match the actual
type of _debug_guardpage_minorder.  Also fix the format specifier
from %lu to %u accordingly.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/debug_page_alloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/debug_page_alloc.c b/mm/debug_page_alloc.c
index 6a26eca546c3..41e3d1f1ad96 100644
--- a/mm/debug_page_alloc.c
+++ b/mm/debug_page_alloc.c
@@ -20,14 +20,14 @@ early_param("debug_pagealloc", early_debug_pagealloc);
 
 static int __init debug_guardpage_minorder_setup(char *buf)
 {
-	unsigned long res;
+	unsigned int res;
 
-	if (kstrtoul(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
+	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
 		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
 		return 0;
 	}
 	_debug_guardpage_minorder = res;
-	pr_info("Setting debug_guardpage_minorder to %lu\n", res);
+	pr_info("Setting debug_guardpage_minorder to %u\n", res);
 	return 0;
 }
 early_param("debug_guardpage_minorder", debug_guardpage_minorder_setup);
-- 
2.25.1


