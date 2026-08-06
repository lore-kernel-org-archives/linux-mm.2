Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C173AC55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 00:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6966B008A; Wed,  5 Aug 2026 20:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87DE6B0092; Wed,  5 Aug 2026 20:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DE06B0093; Wed,  5 Aug 2026 20:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42ADF6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:46:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 582ABA2248
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:46:33 +0000 (UTC)
X-FDA: 85069003866.08.C500BB5
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 97D0320009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:46:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OYcIFQGy;
	spf=pass (imf31.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785977191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YhvDn5Po+cfi6IVgjrY4eL8GriNDWwITsE8A7C/EfUI=;
	b=ihvfHhArpIR9/vGNaJPtBT/gXfFHhDfKCKdfNcuG42nwM3ZtAa0Nc9HN0SNefA7kIPpgvc
	6svSsWJA+Rc1A2CaOAheX2c67ybEdZrNpoTkPssnU66E2KwtsfCTK7fuo1O/VALu3Hw1Q8
	v/puQQJ7AncEp01o7f73bTaBozCzbUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785977191;
	b=d6HVgYHsbhhbqylgoS989XvBm+iNKexqtL4Cx1e6XhBydcvPZhNO+pmAUDSbIXAwWch4MQ
	/6Hvf1Z5ZQJjo7HA7KiIXyMIV8V+/RvKC6F48j1fd8LUJIPW95mbUpIZ6I+0iX6u7KOeRw
	2XT1c/DnpotXfd5eGqHhySb1i860ZGM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OYcIFQGy;
	spf=pass (imf31.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785977186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YhvDn5Po+cfi6IVgjrY4eL8GriNDWwITsE8A7C/EfUI=;
	b=OYcIFQGyXZmmROar6HLe4YuJb2xX8DmpoeTyDs2CfsSRPuhRheccDrdUlQ4ZinsKyDFFVh
	Xq1kxfZgh20HA6XJ+2c7I6cwmY3k5MhH07RTdzdfAggjbWeTAti416QRnBTtaCjicSthz7
	sctG6P3OPE9di/FDI5fUsonh37WN08Q=
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
Subject: [PATCH] mm: debug_page_alloc: fix NULL buf in debug_guardpage_minorder_setup
Date: Thu,  6 Aug 2026 08:45:55 +0800
Message-Id: <20260806004556.2633049-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 97D0320009
X-Rspam-User: 
X-Stat-Signature: z5nnitg59tjdbpy3wt5tf3sga3zq6zwc
X-HE-Tag: 1785977188-392559
X-HE-Meta: U2FsdGVkX18jnoXBfgmnx4i+4N11NgZ8YhFQoOPrIcf5kWMtNZkBmuzmvWGpeIov6xS5qyjMPScEX7PX4L4UMYcnPUXp/Ym/eZKFMqH+CVN/rt5S+iuffMYb79PIcAhw6itKVwK6Rwlc74wgY8Y5LxYSFSjODjlZHGDzDuccUcuw79NBDXzhW9O/GcgU7fxRw4TEcbbBhAFOthZHBvibaEVW++jJ9lsGfXL+GFso7yZ0n/vwzjRs3z4c8L3ZL9d0cC7ESLn9jvbapH6rbLs3d8BhRSetBx6A2gqUt1CMYVNvdw3wXtTmGQkw6COwYmkTRDmZHTTzKkpzqtu8uQBapRhzAZgW+x3DWCOddwJ18ncyYuT3IUXRXrVVvGG3fXfqyZdZZaQZ3+FKjTyaFggA5fzstEdFbh9DKLUXNXc9iP+Ga6/Zp6CUrNRPKwoJLMOEnWPA2gDbE3Na82BSBjlDT1gwg3WiyKHjw71WXYiVrkZYQgksePzkYZHgCsNdFQM5HOTWn8HPhNicqLNbf7dzuQFYtbAEmgEogQ5ur7hvxp0mUApw1QKWO30vKwjRpLV+7+zLajSrSPxg4PNwf/kCq7aBNULpFulRUYSEIE82HYJeRaDN/gxw6Z3ARLWEX2R0P0YN8zGqEpv/86hcNEjkVL3OkvWq6H9Ur1hTHj9sCTaixRhFqRTajIqqXDiw0T6y6TRMhe2UYKZOHHqMUdop5oD7siL/1gnXZnL8nl1w1kTzhKeAgQ7giQZsZZtWD8cS4cVyjaOfSF5rqVo65Wwv4lmG53R8brhh3eT0VS090VRnk0iquRK2qIMJDtTkQuj1mwU+gdv6kBLozQ1fRv1BccL4BQ95IXLGIIsxBuDNQtah4Mfe2bMxImFrgMJZu/G6Wv/8CDOAQP8hVvXdicOOiH5x24D8m3/5WzDQGVivDvD0QH52Lc3MXGnGfmCtlN4c0BJOuHMWcmuFws87mzE
 1/VvU7DF
 Tu9/LjveryWDDbCArkrbx7gstEh34b2LXX0o6vQSDgmHbTY+TgYYWX4pdUN2BwbPSW1ILW7ppzaZHV3apn0wESa9zG9PRY0Erq1dJA3QpOQzYd5HbHqvfPdrm/ot2pgl7KrQxOI8T9VEX2zKHqDd40eAS7Zr2Q1Fh/6tLiHPMBMgEmNGKKCMBxKRPzqzsu9oZfM5GORH1U7hzGX+bqnJ9Fe8OxMjG61mEGD7QrGg1K3CVumvRRpxMVApVBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

If the kernel command line includes "debug_guardpage_minorder" without
an equals sign (i.e., no value is provided), the early parameter
parser passes a NULL buf pointer to the setup function.

kstrtouint() does not perform a NULL check on its input and calls
directly into kstrtoull() which dereferences s[0] unconditionally,
leading to a NULL pointer dereference and early boot crash.

Additionally, the error path's pr_err("%s", buf) would also crash with
a NULL format argument.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/debug_page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/debug_page_alloc.c b/mm/debug_page_alloc.c
index 41e3d1f1ad96..fd2664c3c86a 100644
--- a/mm/debug_page_alloc.c
+++ b/mm/debug_page_alloc.c
@@ -22,8 +22,8 @@ static int __init debug_guardpage_minorder_setup(char *buf)
 {
 	unsigned int res;
 
-	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
-		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
+	if (!buf || kstrtouint(buf, 10, &res) < 0 || res > MAX_PAGE_ORDER / 2) {
+		pr_err("Bad debug_guardpage_minorder value: %s\n", buf ?: "(missing)");
 		return 0;
 	}
 	_debug_guardpage_minorder = res;
-- 
2.25.1


