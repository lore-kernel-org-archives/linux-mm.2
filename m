Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E464CC5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51516B00B6; Mon, 17 Aug 2026 06:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C298D6B00C6; Mon, 17 Aug 2026 06:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B184F6B03CB; Mon, 17 Aug 2026 06:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 835586B00B6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:34:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEF5412073E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:34:40 +0000 (UTC)
X-FDA: 85110402720.04.FD4DA46
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 370A118000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:34:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LVFHAo7y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of njilav@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=njilav@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786962879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Z4LaCEquN0Z047/3Rwp1z8GkQCCa4hzM+M2Iotc0RKY=;
	b=ow/SVi4a/CPhm0CbiLkmkr4J8TEGOK/7y6avbWvFaqiqiMBTPNwBdms4zN/mzi7Df/qtGE
	mDSlzb6pJcmmrMchSIdSaFWz2/f4Aue2X/9AJv83kXuriO1zdyPhtShQS6SGelX4BFhKWI
	GlMNQCNwqPesKkoW2A1lAaR33as4oP4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LVFHAo7y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of njilav@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=njilav@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786962879;
	b=y1ABWe5l8Ct0d/dfSlKLYt6ARlgPGn0NdfN7w1/PjGA3ZvQNMKaZW67aGVk00quxYQk3pg
	5asDCogbNy4UkX9kHyQdclRwT2tmJ201YiNV8a9+rwuyYmZzWQxBqKhX0GvcBOXInyczxQ
	CnKI4fUwjdttgXDF6rXXtZ6M1+Rv11M=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39c7ce122c7so25991171fa.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786962877; x=1787567677; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z4LaCEquN0Z047/3Rwp1z8GkQCCa4hzM+M2Iotc0RKY=;
        b=LVFHAo7yPG+q+4KzL5sp0GOK2p+9b61vs33cye1KfnGGDf1V6tYBa3LBwv0QnySp/s
         MO/Z23xNpJ5P+BUQOOyNgGzeJn4RE9RJ5yG1iPaQHqyR44XzQtNOw/U+qK31zXLoiJTX
         0dEmV9TSVDkKP48+jWGqHkzUGtVgA9qkQpwQ/0/WHtRylOLDGWGXPf3Ciak4g6ghJSLF
         X4kM6azyF8FoizzHmvNTL+SQNcyxYrzdHgGPSCinWYJEMyd3YCr5g/eszUoEa/WN2fC1
         3euk8UzDvMMQIPhRpm8z1BhvcC0LbJqDh/EY4Jjyp0/w27wh7+tO1YlXCDmRDXId5Lqw
         SZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786962877; x=1787567677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z4LaCEquN0Z047/3Rwp1z8GkQCCa4hzM+M2Iotc0RKY=;
        b=DgjODY9vwjFzx35hroGRMHf7UaV2k81+B3ulIJyP39jcFz+wNLYo/AVkniB9fFMt+F
         5GNgeKxR9C+oK28rlzW/Fy1w5K6gMSMKWJPAoVNPfOVyuDv6rO5zcb63wsSTZjISrYgz
         B7A6GJ43Sfk2Pi36lOw11vtNGfrCshSsLVVG9a3OgX+L6gdZyYgLFnPveua0Xo5KcRqB
         nBdnuA50cMHfmD58TMI0sRf+MrbPijeWxVhH/5YF5o5qr8VjwGwlqM9cmfraz7QlmaSt
         Pazaemcv6IZJuJalhanpXdtiFbhOjpKKOyZS3QQZaobLjNz/WsgY/7JLb42qCdzwBv34
         lS+Q==
X-Forwarded-Encrypted: i=1; AHgh+RqVi1L+DBdLTJF8YAU8guZ0h6Qydx3tok9MogiexRE4OVTozexg/RUhejtH/us3H0MU0Vq8WO+JSg==@kvack.org
X-Gm-Message-State: AOJu0YyzFr61xjcM0EaIpjmLj5lMHTPCK1zASsDi+IhGE2NyfhBVBrvc
	pZEAF0BpN4iMaUKSsmHLlzX0dMc9VtSzWKA77n/v6ZfqJYqix29lXm7d
X-Gm-Gg: AR+sD130DLcrgxo92Evo9ZvI2dEuWQEo6ueSDOIzL53oKAIXBbmqiXbqDcNY1uMjVSC
	evwZmZh3Y41yHK7Pz26Vo/UIIMr0pq+/4bhoR/6Qlaywl8NbjwM2c37WI9HgYLCUBZqfgbOsF4u
	rd2l/Xj1t461Azy58UdfzhF2jNMa0XHJyeLdEaVVn04utO0FqBZTxIPnDIRQCvR2HcAqwlxXHa7
	VfrN1yc8ZNEVDcHrt/6DWrUmnOqJ/66+Hj0S46WG4nOEf7ltt++Bv5KI0DUT90aFtm60qt1Yw5L
	i+uaySSUOw//QNfciNRW50jXjCORt9etLoEP3YbSxYr5PVc3bjCQW1c2oAD61FDE2111UTHv6wC
	s9LEaPaCa0jGjcspNQ+CoAGmUw7F4F8N52mn6U6fZwY4rCJEdJ+8qioDHYKKMdfPva7rXDIdKWM
	3yJEH7PVWLNQWci4f/33UqHsFdQoNhSkW7aj6DjGVJlVRK
X-Received: by 2002:a05:651c:220c:b0:3a1:4f33:f625 with SMTP id 38308e7fff4ca-3a14f340463mr12014321fa.31.1786962877044;
        Mon, 17 Aug 2026 03:34:37 -0700 (PDT)
Received: from c.. ([213.165.253.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a16b1a98dfsm3389391fa.21.2026.08.17.03.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 03:34:35 -0700 (PDT)
From: Narek Jilavyan <njilav@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Narek Jilavyan <njilav@gmail.com>
Subject: [PATCH] mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()
Date: Mon, 17 Aug 2026 10:34:33 +0000
Message-ID: <20260817103433.191266-1-njilav@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hr9mqxxi7jnaocuyfyosu479iyk1bitu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 370A118000C
X-HE-Tag: 1786962879-195440
X-HE-Meta: U2FsdGVkX1+xuWElUp3OSuPnLP01LddZ2BNWE1d0fLSypP3b+/ktTmNH12mF2ZabM3Y2EjGn7uWFXtSV9UJjI57Q4e+PsQcWWgP32OnkpuOWR6LVz/AI2oqRcul8pZuBacxyTef8NoD9k7kyHfY/O6F7FFscNEzMj35A3eCRWrB/8g7a3/eXVrMVDzoS5dSTVhUfb5Y5pPEw2Er3r8t1YH74cFQ+wTAenkDsuPNfmz1H7ze1KweurJbYx80ck/6e1newzS5Fc/CqNjWGJVjTLc4K+i1bVCDjPDVJ1fz5DEzo/FxKzlno2+pGUvYQAsr7dXCafM0W2Y1VxZUX0Lx4hozih8+1q7M7B2adVerPTRN3RaDnVH4rnyX3kaE/6XDw14xTMWCppGSHjLc+vSCaPyq1YG0Yf6MMdVVPyQ4XrhCAAjvxKJbBbohuUjkhFWJda7Mhwy/U5B/Cjghpv2lDOladE4WmmuapZ06ve71cPyxqIrQJrfBLZVykNVQQs3cN3hgR/hCOcLPfP7DPWa96nBOTmUSpP2dlpIh18QBJNrZpZ02FHm3Pfiyv3urIAbVr1iPZkLL7HMwwk3Njb/aDpkDg0iiXT4MOOhm8gwbSG0Lv20uqoOzyJGEfkTqn0pjsOkPCg2avj/KT8vzfVutPi+apYgzJUtNoe7PVN2Y0AXznuMYGs68Y0Hr7g26JbQsqNeI3J5GMRJrmwZ9bWZcqGPZlG/adBehfFdZtVmcss1mjSlkX/bPL71xkgfOGbpaeb3IP0nK2BGpn0nR+fjfTft4KOc3RClhFGW9vrpa6nQGGHzrvHsvMmLtJsOiuIV++rFOojY/ECZKzZwtwcnQvreq7I6zhHKsUMyrH8CLsxpQPtDPtRfO5273RMncTBb8StVzIaHJMj40n4TgFWugPWCzNlR6vLHv9isn7e5zeM6ChPufahz6JNGZynUyXvmZ5zFZpiDI8FD5Y85uFch3
 KCvHvwXC
 rtGnu3CQY5Rrjg2MEl/hl7IH/ZNQl75CID2RVYy9gaby6+FELixcCZpoyGMfeX2ZazxwBflX5BTGnO+xEYPJUr22KXlh4cMJXkdazZOngzpxVXp7c1bu3qFoZDKeeFcotGnDCz83emkRIhJ/uQIPEs5EHBELprmJVkA2hB0fRmZlmbQ5cirjHPatfVagED8FDrlQvOLYDfB/L16UeBXkj8f3AFDphEIfLp2LdQGAgG31YyGK3ow9PxzawrWs/PzaQaawjmakcYDx1rrRFhRwtQSDgWWzZPE2xlgUk/8+YDCDKdJZZy7hjqK/kwACZ00Btbc/PexbW6BroA/N01i04NonLYjwupYOnY404yhzzUuJ3DSCUfaZtLG+yB7SFlnV8cwR3y8FPX3Hhxwhg77Fe9O9kBiIY2owsWJ7iPbSMj3G0i3TlrdSKi6fUcoItrea9oAUBr+WZGUVxdiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_cgroup_css_alloc() rounds the counter limit down to a multiple of
the huge page size and then applies it inside an assertion:

	VM_BUG_ON(page_counter_set_max(fault, limit));
	VM_BUG_ON(page_counter_set_max(rsvd, limit));

With CONFIG_DEBUG_VM=n, VM_BUG_ON(cond) is BUILD_BUG_ON_INVALID(cond),
i.e. ((void)(sizeof((__force long)(cond)))), whose operand is never
evaluated.  page_counter_set_max() is not a predicate - it performs
xchg(&counter->max, nr_pages) - so on every non-debug kernel the limit is
never applied and the counters keep page_counter_init()'s
PAGE_COUNTER_MAX.

That is user-visible, because hugetlb_cgroup_read_u64_max() recomputes
the same rounded value and uses equality as its "unlimited" sentinel.
PAGE_COUNTER_MAX is LONG_MAX / PAGE_SIZE = 2251799813685247, which is
odd, so round_down() really does change it and the two sides disagree.
With CONFIG_DEBUG_VM=n:

	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
	9223372036854771712

and with this patch:

	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
	max

A debug option should not change cgroup output.

Call the function, then assert the result, as v6.12 did.  Use
VM_WARN_ON_ONCE() rather than restoring VM_BUG_ON(): the two are
identical under CONFIG_DEBUG_VM=n, and checkpatch asks that new code not
use BUG() variants.

Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Narek Jilavyan <njilav@gmail.com>
---
 mm/hugetlb_cgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index e0083de1ca..ecb6e0b781 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -97,6 +97,7 @@ static void hugetlb_cgroup_init(struct hugetlb_cgroup *h_cgroup,
 		struct page_counter *fault, *fault_parent = NULL;
 		struct page_counter *rsvd, *rsvd_parent = NULL;
 		unsigned long limit;
+		int ret;
 
 		if (parent_h_cgroup) {
 			fault_parent = hugetlb_cgroup_counter_from_cgroup(
@@ -118,8 +119,10 @@ static void hugetlb_cgroup_init(struct hugetlb_cgroup *h_cgroup,
 		limit = round_down(PAGE_COUNTER_MAX,
 				   pages_per_huge_page(&hstates[idx]));
 
-		VM_BUG_ON(page_counter_set_max(fault, limit));
-		VM_BUG_ON(page_counter_set_max(rsvd, limit));
+		ret = page_counter_set_max(fault, limit);
+		VM_WARN_ON_ONCE(ret);
+		ret = page_counter_set_max(rsvd, limit);
+		VM_WARN_ON_ONCE(ret);
 	}
 }
 
-- 
2.43.0


