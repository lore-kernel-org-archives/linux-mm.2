Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E432ACD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5293A6B008C; Thu, 14 May 2026 01:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9F36B0092; Thu, 14 May 2026 01:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C99E6B0099; Thu, 14 May 2026 01:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7986B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:08:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E91D9C09E7
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:08:07 +0000 (UTC)
X-FDA: 84764843814.01.F18CE7E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3649B40006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:08:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cJgfkrqj;
	spf=pass (imf04.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVUS8nSGC8T6vcl8/O4CNUAuZgl/WZ2FKsnnP7R0WdA=;
	b=txO12Jt8r6JsDszk/Aafhd5x/vd8BM2955ZKjD03WECCuK2R+G7EVSaTv7ifdhyTUUq85M
	kKZXZrA4nTTZkYFso052rOKAA1AwKuQfbtlB8vR3DsSDRGTyg3dhiuOiwSO1Z+6B8ftcRP
	nd6wLnFvDERsdSrapBtgb5hokJY61EI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cJgfkrqj;
	spf=pass (imf04.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778735286; a=rsa-sha256;
	cv=none;
	b=h42gcpluky1NWsHPvcZ8U+JOS4usR2mr3k3TpDDsaUTTVntHyxtxm0nOA9QJZ6DgtH5pBl
	q7/BXqYS34uoeMETkM6v34tZw+OqgCugPLLU8KmT2MDgIFDPFOW6br336uxkxAQJusN+WH
	sdD3Jy05rvA/frZIXEaQclKzOK4oC7Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CCA61655;
	Wed, 13 May 2026 22:08:00 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.197.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E2E9F3F7B4;
	Wed, 13 May 2026 22:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778735285; bh=i4bByhR3/GFn5EdsOuSs2aNtMnt37PAf+rz4tzgOO5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJgfkrqjF4tm9WRMUGgxzSWx/aIjRhFMv+ZZmwwkUccWMLOjzt+2qB/zt9dbgQKnT
	 VFVuNrhwmSE2wQVt7y+3ZuYXRDIB5w+f3SKI5bKovaizZe7rdeyjGhvmf0WxlXiRVm
	 U9BO0xWYArD/yhGbOFKPq0eNKZMHnjJbZ7Tn/0fM=
From: Jia He <justin.he@arm.com>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jia He <justin.he@arm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Kees Cook <kees@kernel.org>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 6/7] hw_breakpoint_test: fix test_many_cpus failure on large systems
Date: Thu, 14 May 2026 05:04:54 +0000
Message-Id: <20260514050455.2954509-7-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514050455.2954509-1-justin.he@arm.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3649B40006
X-Rspam-User: 
X-Stat-Signature: 5ybeg1atfk19febuygu1wuxf5og3muuf
X-HE-Tag: 1778735286-873514
X-HE-Meta: U2FsdGVkX19rrAI8tBq9j4Ay0xJ2+dQySPzBFu2keCy2xaDP0hj6OqXmFWu3VQRABeA4vnIb1m60LSSguvVpVtcrFCWMS5ljqPgWeOyIZ5GNB15kyacGzl8amv9ldaP+MI+dgMUA0VNSfuA1FTaJEH7UR8LhXujn8bG+NB4BlW6C8SurP33jORiJnVQ8kEKgoZeHZl6LHO52vaZJCiFZPUDXx/YZkgR4iNLDiBP+gnsrbnqL+6smyzfHcKD7ngLrQeHJjbj6mdXiVgrw8bFLwCZAAE+EP3paxf0VEjDPDv/i0I6NtxsbO+4TmmUKAVeyy9ZA+qKEGksvCCQRUzcIIIo1m1vXnuCW3Aug262+JKWhXga4aGeT07gnOfmjnIqQQyW8BFwfM12SMS2hVR02pFvar8ehPH2amHIgiF6yAPBajiudrZ5OmO49ZGRVtDsO9jjRPmY004+stymsh9P2sv+dRoz+b/2uDQgUpdwZVHyXi4wpTSgqYSa4sKbJP0q1U9tAC+YX7BSFmE9FKpNCTOOLWBAR+NNDSxEFRVHWQS3D7L1DHMcN1l6eenWpzebc67/o8FVzbLWWEW9H1ytLEeftMyOV0xjgcMiyMdAqRjbNL1E3DyjbBZhZIgP3iYalkuPPiJdRjIquRvxIvDc4NjbPOKh1cdM3OijbQbpmez+T0URA3kVCxzoQPV3tiwzstjp2ae5fOwHBldYl6FrEHWN4PUA8ct4KvSRyCHR79FMqh0pB38bK6M210bZLkRAwGu+MNlInww3tAqGtz2S7u3UAr9PT2Um42huUpw8TQHrw2yX2sPOqc4TI7wzC7X5gntETzahxvlabGl158g85Sq5FMZ9guOjyfXvi0b7DlNBxoiqIyw/UlhKMo+8BQGT/uxcrlnClCRpxxFPoOPyikwIfYVB3oZbNO9IUW80Ctmw9EPyHDupEy/laqSnepXERdyOw443nfMBn/BX5CJj
 zkN4sDsb
 h23dKnPqasWct0W6qsOrnTzoKi/VlydtiFJv73qYntc1EhctUZq2nw5JLqln0pH/PEkHuhhQTPvU7EnStr6KYuzux3HCErROcMsz+I8Xds/K9HAPyTtOpzLlIt5GAFupmmAW/AwczbS6ACY71bJSyEC6SS2Xd3/xfAjZokQLv8hOdXqJ1T3RS51r4baV7DdftdK5dnTD3FriADC67Gtz7fcxngrzoOodOsDFDrUBPiMxp2Cyrgw8l5hXS6XsnHf3gGw7T+IcoQZQ8sUzg3LSVKvG/FiIaUAk3pFC0w/hfbDwmdSEwBcT9BB381or7anBah8Wo/ia+AjD4xICJGUG99y6Rsk8vQhJTFEznhbpO6cee6iodRmvc+Ag7AHOiTSqx4+HN7XKDx65cfaikjf6dRThDIPYuUWs9MszbfM+bjC42Wz4tiwjDvujH2VFbYwodyy2Q8m9ZfEE+ExcZJiEJwCZg6zhok9lXjslTsAcqSo0Y4u8DKZgeOWdnUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with many CPUs (e.g. 128 cores x 4 HW breakpoint slots =
512 = MAX_TEST_BREAKPOINTS), test_many_cpus() advances idx to
MAX_TEST_BREAKPOINTS after the last fill_bp_slots(). The subsequent
register_test_bp() call hits WARN_ON(idx >= MAX_TEST_BREAKPOINTS),
returns NULL, and the -ENOSPC expectation fails.

Bail out of the loop when idx reaches the limit. Earlier iterations
already validate the NOSPC path on other CPUs.

To: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Jiri Olsa <jolsa@kernel.org>
To: Ian Rogers <irogers@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
To: James Clark <james.clark@linaro.org>
Cc: linux-perf-users@vger.kernel.org

Signed-off-by: Jia He <justin.he@arm.com>
---
 kernel/events/hw_breakpoint_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/hw_breakpoint_test.c b/kernel/events/hw_breakpoint_test.c
index 2cfeeecf8de9..943d040d2224 100644
--- a/kernel/events/hw_breakpoint_test.c
+++ b/kernel/events/hw_breakpoint_test.c
@@ -137,6 +137,9 @@ static void test_many_cpus(struct kunit *test)
 	for_each_online_cpu(cpu) {
 		bool do_continue = fill_bp_slots(test, &idx, cpu, NULL, 0);
 
+		if (idx >= MAX_TEST_BREAKPOINTS)
+			break;
+
 		TEST_EXPECT_NOSPC(register_test_bp(cpu, NULL, idx));
 		if (!do_continue)
 			break;
-- 
2.34.1


