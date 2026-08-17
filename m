Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04579C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D986B00C3; Mon, 17 Aug 2026 08:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31486B00C5; Mon, 17 Aug 2026 08:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D5B6B00C3; Mon, 17 Aug 2026 08:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 785456B00C3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2FBE1A073F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:07 +0000 (UTC)
X-FDA: 85110726414.06.8E0E2CF
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 373BA1A0005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Or1tMtat;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNN86hXrdrGG1E/YizrMzJjnTH3T1mAw0aE/Reny4I4=;
	b=A7AOJkj5GqzSM2/qPw+mJM1z1fvtikTkP0Hqe2h03i+XY2BWPm9/sHdQ8enTpMB/U+OtDy
	2FRFNzxvtdzACU7LoEL9gh04WqTsYOXH5vVVX/XVpIYNW+OLUgSBSPEvKFZ7Sq9LCRYI1p
	ZvkAE/3OVM7YTrXxRmZcuG4/s9Ke4mU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Or1tMtat;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970586;
	b=dNkJO6azMFKnXW6q0KEH2EDC2Ir4DgvYWTJfBDD1np6vKfc7tfGYCznU/jIJqXedOF550l
	QO9j/7uGEpq9tYSXwOSTyQREqQMl+BPWb35pxcF9tk8NbTLtAUKQRqx3gX4Nye2YFeIH+w
	W3QEdkjGXMT5OoJYBHZCttwzx6OuCYs=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15cd3fd760so404625066b.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970585; x=1787575385; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZNN86hXrdrGG1E/YizrMzJjnTH3T1mAw0aE/Reny4I4=;
        b=Or1tMtatrtoXCzY7QIJBBv6nVYOReefYYe4rM53ERLVkHzn197QG+7OYx6VJjdJHWy
         SLxc+z6ZbKtfC0gbHQhaWdjiL2pg8F+XkFfRNkI9qkPER8XAOpeHDEdC/5hxZS0IL+T7
         jKtyL1eOghMhwEyCIVb2etmjAV5VFFlVdXoiGS7h+QmeiU0KvbX2t0OxN73m4Gdflb5+
         6vJmLCn3RAiOTEoIPvGlmxl19JbPi6wXKnPeFyfbpsMRMWU8BsUkoUFjVqPYkXhO888k
         lQY0/M74d+nvOxHqb3Z+ycVIHyOW2XRMp8zpV0JleCG/RW9lpCLlGeol1jgzWFlL5DVJ
         jWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970585; x=1787575385;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZNN86hXrdrGG1E/YizrMzJjnTH3T1mAw0aE/Reny4I4=;
        b=QIOzzqzd0JhoO8zwOzlVPxNT5e1u0RWC4yRkD9KwXgLSY8WRoZgXch/2WUCBIu67Ut
         NcF9Q3f7edtvI1LZVBtwyE9BAJN96hpPXqS4UGLVOocIegur+vVSc5aq6rR/QyjvL9Cn
         k5ENaS9wdvINWlfr14opO7S8jzCB8/Yxq3kkQFIg20vxrZBJAcpgCyH6DtVyCaOJt88x
         Z0eLiUrbV7yWgAvQKq4ESV1FYOnUK59/s5Cjy7lDF8BEisth4C69Z7KP3EfMmssll54k
         Xd8cvoBrKnrE5ZSHOqvLViM3aKQS9jXBv8lwwS61hESniooIHNEee6D4O6WpTo/ZWV+s
         2lHg==
X-Gm-Message-State: AOJu0Yw7N0PciMgCEpveyEktQgo9+kZfBtStZ/5cGmeY8CAriJS+f1zQ
	BsFu23Hcof/JUD7OpmWpAwaHTLgqf6I3jOzSpuebEzUk97YVM9cvN/Qd
X-Gm-Gg: AR+sD12pqUCJIClitWNoOA3P4mMPoYe+JfxHkLPfnJRCst1r6yGBgw57vWUcR1LXzE/
	cVaw9ZDIg/cEvPtQyMSzqvIokJSsHZoSeHx/Kk8OGayuLl4Iq+Ial0UScj3Y+UxMAhIUW4CLXyK
	3GxVHDVPSt+kdIBB7aSjWmtcX6dbke4+vD+iITONRhxd6He2pYK7h4lMa4p4luOMAp82f/aCXsY
	W0QMNhaY9bjMUcBSh7GtfgJkgK/jPsjQp5EY2HHwG7/7ij4nOl+y9oMMuZtgF+28jEZDBD92eN1
	iHh7oM7kfAYCzb48nAcsCeqwvs0OMgSUv7rzTOG0NBPZsPg98kkRNlPqItABHMOv7+HS4DRCY9Z
	x7OrVPHWPQDpTHb9gkgICsm5jcIdsUgBD3XTwIi6/uzgHhsHWHsxgk13YjFyotAZLdZciXaZXAE
	QBUkPLpXuArIAezro9ZSCtMV0uhLRUrchSfecnDq0GugnFKutBJA==
X-Received: by 2002:a17:907:608b:b0:c16:73a0:c4ec with SMTP id a640c23a62f3a-c212a26d672mr1059757766b.18.1786970584755;
        Mon, 17 Aug 2026 05:43:04 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:04 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:45 +0100
Subject: [PATCH RFC 5/9] kmsan: report trie-backed stack depot traces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-5-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: rzy1whjxy8h3b63ek33bjihp6k6qcsyx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 373BA1A0005
X-HE-Tag: 1786970586-561190
X-HE-Meta: U2FsdGVkX19VJdiukJIi3W3+LLUZUYs/lmveJH+W5GESstfyLNRWSUNo1U+VcZfGf/gfcdfVP7h4fhqUKANh4cVgtaNZSVxoB4Wmow8h9YNMjgXRKk+TOLIOk4HYVrz0I5s+AuL/vwK5BRQPnVQrhEJdUtllv3xXxWUZ4nBMS9ZEsisA9KQSm/zSkjYlpVNRiQ292CXDRVKabAsZc76uayUJ7/FmXITVSRfenQiQF1brkTqfwTVM4uhxXQ/Mq/nvpPdYTdX49Pcli1MQAW11UeQ4i1kHg/ykOjPpwRTtLr5sc1g5947A8n2QL9WN4gEF/qvhP/9KwM8/rD1MmX2nZPJLrL+x7RNxBxYlbRKrPma9zFa6dKCvkjDNMTJCHCbRq+2hb65Je2q3z+gix85XqLIu1KAPhsxyRip4E8qy4ewHNbpEt4GYJLVgDWmEgk1hwZh8a/cW62eIPWqZ/xBWj66QAQLU07AcVGyDDPEejza2NtuAQGOddfSQcMIlHeeEYl30wQR+gfbCh3w/kz6RM81HA4L6oUHyUy/adAoacJi231uuWJ7k+Egx7aAKdAsz+Ss3dg1f6TBbpwPl/Bej6LSa5hWqKSvqPZjP0Ifk6XPlp40Ivle/BwSbPeAxEvR1V/6M+Ue9l5TOXGnVcECoOLRZlGsTRR51dAjMW+2roZwKm5jmbKcjiAsDrPulFkPjIVM+LZOEpH5rTfOP3eNYMRRObcrelUIqyfqo+5HA85beMVHEryyGHjByTj9gghYLY4POq/dqHW5t2vVoc1XrVBwHoSo+OBbL+z7nLc2I1zQ7/VQihyoq6Y1xQRAEwV9QmNEGr/7nLNERptFZVjypDIvHTq+4p/jGQsPaPMBzHjMpLZTq0J/dVLIpq119eZlmWILNSk2qPw6HrqAiojxKhjeE8Dg22IEaEUQ/+Ac1NK075K6x8PY/Vaqx9PS3dmty2dAFxX/p2mCYnB/57Wu
 3M50tK/p
 UzxvXk8hnnmr9ipltwGAEU1QQjebHfbehOo7QSWGnqNODmWWMfzQmMcftAxdh9hlJ9G1zJ3Z/268oVPFgvwiijV9hO1VUvkHQTV0C5SfsRAZfCXRX1jcffT49o0xfIuvkGtxlp12h8KOBhWxRTedQD2yYjlu8tp64DqiWTtek6sccOzJahWE03kZX4/gaA41zIQxQVOj1CL825hV+bc4fjYl1EegRyrmpUM4vL60zr8eG3a5xv/Kt/Wq4o8Kq5B9ss9cScKIvzv/vRHIk7NxMgs2xz16aXY2BYAo0SlxAmhmr7geb5TfdfSDyEbTrM13vDCNe8s8s/vtI/YY67f9/qcUonT7kiLxFky20tAkHzsOg2SWqrClFlmH0PZ6l8YUiv2lAorlB0jRcUEd/kDUX1Io82lD5vsloT7UgNHQbQQPOh/1TS4PQqXPEFC/EMmb1ULDb2Y5+So2/VRCNVm19ov8dKOlM+6cvk4vE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

KMSAN stores ordinary origin stacks and synthetic alloca and chain origins
as persistent stack depot records. Once trie storage is enabled, these
handles can be trie-backed, while kmsan_print_origin() still relies on the
hash-only stack_depot_fetch() API.

Use one KMSAN_STACK_DEPTH array to materialize each origin and chained
stack in turn. Preserve the chain's head and next-origin handles before
reusing the array for the chained stack. The array covers both the regular
save limit and the smaller synthetic records.

lib/stackdepot.c is uninstrumented, so stack_depot_fetch_into() unpoisons
the successfully copied range before returning it to KMSAN. Remove the
now-redundant explicit unpoisoning of chained entries. Origin depth and
use-after-free metadata remain in the handle's extra bits and are
unchanged.

Update test_stackdepot_roundtrip() to use caller-owned storage while
retaining its frame-count and kmsan_check_memory() checks. This verifies
that the copy-out API returns initialized entries to instrumented callers.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 mm/kmsan/kmsan_test.c |  4 ++--
 mm/kmsan/report.c     | 17 +++++++----------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index 31f47cc4dab4..7c04e4b21873 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -669,7 +669,7 @@ static void test_long_origin_chain(struct kunit *test)
  */
 static void test_stackdepot_roundtrip(struct kunit *test)
 {
-	unsigned long src_entries[16], *dst_entries;
+	unsigned long src_entries[16], dst_entries[16];
 	unsigned int src_nentries, dst_nentries;
 	EXPECTATION_NO_REPORT(expect);
 	depot_stack_handle_t handle;
@@ -680,7 +680,7 @@ static void test_stackdepot_roundtrip(struct kunit *test)
 		stack_trace_save(src_entries, ARRAY_SIZE(src_entries), 1);
 	handle = stack_depot_save(src_entries, src_nentries, GFP_KERNEL);
 	stack_depot_print(handle);
-	dst_nentries = stack_depot_fetch(handle, &dst_entries);
+	dst_nentries = stack_depot_fetch_into(handle, dst_entries, ARRAY_SIZE(dst_entries));
 	KUNIT_EXPECT_TRUE(test, src_nentries == dst_nentries);
 
 	kmsan_check_memory((void *)dst_entries,
diff --git a/mm/kmsan/report.c b/mm/kmsan/report.c
index d6853ce08954..c20c24cffde5 100644
--- a/mm/kmsan/report.c
+++ b/mm/kmsan/report.c
@@ -85,7 +85,7 @@ static char *pretty_descr(char *descr)
 
 void kmsan_print_origin(depot_stack_handle_t origin)
 {
-	unsigned long *entries = NULL, *chained_entries = NULL;
+	unsigned long entries[KMSAN_STACK_DEPTH];
 	unsigned int nr_entries, chained_nr_entries, skipnr;
 	void *pc1 = NULL, *pc2 = NULL;
 	depot_stack_handle_t head;
@@ -97,7 +97,8 @@ void kmsan_print_origin(depot_stack_handle_t origin)
 		return;
 
 	while (true) {
-		nr_entries = stack_depot_fetch(origin, &entries);
+		nr_entries =
+			stack_depot_fetch_into(origin, entries, ARRAY_SIZE(entries));
 		depth = kmsan_depth_from_eb(stack_depot_get_extra_bits(origin));
 		magic = nr_entries ? entries[0] : 0;
 		if ((nr_entries == 4) && (magic == KMSAN_ALLOCA_MAGIC_ORIGIN)) {
@@ -123,14 +124,10 @@ void kmsan_print_origin(depot_stack_handle_t origin)
 			origin = entries[2];
 			pr_err("Uninit was stored to memory at:\n");
 			chained_nr_entries =
-				stack_depot_fetch(head, &chained_entries);
-			kmsan_internal_unpoison_memory(
-				chained_entries,
-				chained_nr_entries * sizeof(*chained_entries),
-				/*checked*/ false);
-			skipnr = get_stack_skipnr(chained_entries,
-						  chained_nr_entries);
-			stack_trace_print(chained_entries + skipnr,
+				stack_depot_fetch_into(head, entries,
+						       ARRAY_SIZE(entries));
+			skipnr = get_stack_skipnr(entries, chained_nr_entries);
+			stack_trace_print(entries + skipnr,
 					  chained_nr_entries - skipnr, 0);
 			pr_err("\n");
 			continue;

-- 
Git-155)


