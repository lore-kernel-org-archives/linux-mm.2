Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A872FCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E41E6B009D; Thu, 14 May 2026 01:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC1C6B009E; Thu, 14 May 2026 01:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14386B009F; Thu, 14 May 2026 01:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD99E6B009D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:08:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0287C09E7
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:08:25 +0000 (UTC)
X-FDA: 84764844570.13.E10B650
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id A9D7780005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:08:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C0FOIuVq;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5WI/cYBfetw4KnALXJhO9CzYqwSx9SfriWhrTIZyTQ=;
	b=5L3/OD6C9u7uMjUo6vPCUOPgqDgzwD9tNn/TMy41YzDQEk4ULdHjAIkjmT6oResYUme4+8
	NHMHAZDVhHHPGrwfBcU46eZoN+ZLSVH/jaNGmyIaLj0SpauT1E0dRVUiWnxUQyjZXwnKQL
	coYnE5hNi4KskDE9/9T++BdyQqlzHwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778735304; a=rsa-sha256;
	cv=none;
	b=pB7CO52DZCle89sDuaNNJ2bpeVMzVRnRTxDr2Bz22wjogqUiAFtrh0yw6Kbyol93g6lyJ2
	dW0EaxLK/abtQamdr7a2uavWdBLoh+JldyunH2Kilf2n+I+hmAXo4aPYOECJ9p2RV57AIr
	It0UuvIx3oX0tgcL5uZ3EMT//VW2DQI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C0FOIuVq;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E208C1655;
	Wed, 13 May 2026 22:08:16 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.197.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0871F3F7B4;
	Wed, 13 May 2026 22:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778735302; bh=pDv1PUPolI9yQCaKV1T3osAxs2BPPEuIIJYZ+6qnyXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0FOIuVqM3n4lVlgYpvHk8RRPKzDD5+SduOW3q83jwCz6q2il5Md6IfZb/iTGZ+os
	 oKQNS84VmZM5y6W3KgNvgdeqB3HnAzkFR8cCydg4B+9Xw5pvpjyQwls0oktpX798tq
	 tl5eo8RIyC5bwHKsuNhKjV/dYBNj9pKBlY3VZbvY=
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
Subject: [PATCH 7/7] lib/tests: test_ratelimit: fix stress test thread lifecycle and leak
Date: Thu, 14 May 2026 05:04:55 +0000
Message-Id: <20260514050455.2954509-8-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514050455.2954509-1-justin.he@arm.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A9D7780005
X-Stat-Signature: czzi9moar8a8b5uxco5tqzumxx1y95h3
X-Rspam-User: 
X-HE-Tag: 1778735303-2018
X-HE-Meta: U2FsdGVkX1+3cir1lO1ozcHT0WHYkZKprDcac/P804y7EYJaxHzXrC6lceI2becqJOhZXB7Vof3pCs9GIu4X3m33WuiqKkuMvSbflyeNRqkmltoBngDmVaXJdVNJs79TGTVDdO2hLIycu7fgmaK3tZg5uj0/ksGbMOvOgHFZuh7aJf0LYn7+wSyU+Iguf0ve8+Ubt7d+L54gcJlyVJCxYGMyAbDuD3BNmCeLVHoBiJ7sJnTYuj/KvC1u67Ps+XCkTpBoerTHimMJyaqu1l6hqD8b80BW3ybJ+q34ABCCIRx7V7ku606Rp/DobmQzkePDf9lAst9GKLkj9JZcsrid24EHdoKPnnB8mwvpoX+MT2NzkR+8ux4vF7RCPsPZmimjCMBfVBt5Nw3MOBHIiwzx2Zu1hEC1sWcQyz65kMg0vca5ErlnotwCFiAD+EAifTZubiQfJPnEfptoTCeFuZQbrbcPgkX7K2+RgkYi2Wuwk0UbbvPNXvjeKZBFaCDCwz4yxO8QZ+b8JepWLWMFZ4pYRW1IbAtPIPSiOZAiyduoFxrg3Yx50G63CsLy4IgqdDWy80q5XpXzV61FJr88DfOZmgtZdPISN/WgbXoAFAbkx9h0QHUlF7LPx6n6/IyPmaXTZJ+Fl/yyyxfEI/594ebgMlIGadcJ3hHaBxxiSjEvawVaTRIkdKu573wk0bKobcmHKcJgqm7Obf9paS0XAmOjja71bdhXqGhZgXAsDDYOWS4q19Auyu++n3zi/UIFvQ9n4Txb/EadfCr9yTqg6r8TVGRAHG0HbmtrJ55wZ4Ww/tMRPDKSAic5iK4axhNSJonfvzi+pO/4+FldrdVzu3rVFNkF/Qr0BBwXIqIUha2ETFZ8wLnvgUeYICsxYUfiNjE4J+hr3D75Apyhdct2j5gnb4cTlrbgsPH8y5p73ooZ/w1zVaqza8m5nHI37EQsKboGh3s9z+e6fS4rwM5iftt
 628s0HGh
 BjrZW23euJoxdVrUp1uyun/ch4MCjEGbHNHJiR2jyFzL4GEG2OoWjyHef2bJvwm5WHKZVY+QANbu5/C0J+T6lyH4BiUTjZr8j6KOsoXf6m84D7YYwUHCco694sHuI+zC3/GIDXJKxMIwMG4r7IQZzYXpjoP76BfzyqZY9yv8YqwQBGEeqOLKgjoT7lfH2t3JaljGflNiDrx94E7crjAZJR8mRB+hj8OsD2JC52+3+fNR8yiaRKfzEtZ0TA8vaC0VbvL8zpB3io8CoAzRms2xSA/p5HPGMtoJwIKI3zIJoqQukMhfPs0xWw+KzyIDWEQqnDkkNPfVUXMhh0qYG43ZAkXF2i0cfp16F14ZB1//83wJz9UyG621FmP5TbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kthread return value was checked against the wrong variable (sktp
instead of sktp[i].tp), so WARN_ON_ONCE(!sktp->tp) fired at line 87.

Replace kthread_run() with kthread_create()+wake_up_process() so the
return value can be validated before assigning to sktp[i].tp. On
creation failure, jump to a common cleanup path that signals doneflag,
stops all already-started threads, and frees sktp. This avoids leaving
orphan kthreads and leaked memory when a mid-loop failure occurs.

Also reset doneflag before spawning threads so back-to-back test
invocations don't race on stale state.

To: "Paul E. McKenney" <paulmck@kernel.org>
To: Petr Mladek <pmladek@suse.com>
To: Kees Cook <kees@kernel.org>

Signed-off-by: Jia He <justin.he@arm.com>
---
 lib/tests/test_ratelimit.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/lib/tests/test_ratelimit.c b/lib/tests/test_ratelimit.c
index 33cea5f3d28b..64f26260c0d8 100644
--- a/lib/tests/test_ratelimit.c
+++ b/lib/tests/test_ratelimit.c
@@ -105,26 +105,44 @@ static void test_ratelimit_stress(struct kunit *test)
 	const int n_stress_kthread = cpumask_weight(cpu_online_mask);
 	struct stress_kthread skt = { 0 };
 	struct stress_kthread *sktp = kzalloc_objs(*sktp, n_stress_kthread);
+	int n_started = 0;
 
-	KUNIT_EXPECT_NOT_NULL_MSG(test, sktp, "Memory allocation failure");
+	KUNIT_ASSERT_NOT_NULL_MSG(test, sktp, "Memory allocation failure");
+	WRITE_ONCE(doneflag, 0);
 	for (i = 0; i < n_stress_kthread; i++) {
-		sktp[i].tp = kthread_run(test_ratelimit_stress_child, &sktp[i], "%s/%i",
-					 "test_ratelimit_stress_child", i);
-		KUNIT_EXPECT_NOT_NULL_MSG(test, sktp, "kthread creation failure");
+		struct task_struct *tp;
+
+		tp = kthread_create(test_ratelimit_stress_child, &sktp[i],
+				    "%s/%i", "test_ratelimit_stress_child", i);
+		if (IS_ERR(tp)) {
+			KUNIT_FAIL(test, "kthread_create failed: %ld", PTR_ERR(tp));
+			goto out_stop;
+		}
+
+		sktp[i].tp = tp;
+		wake_up_process(tp);
+		n_started++;
 		pr_alert("Spawned test_ratelimit_stress_child %d\n", i);
 	}
 	schedule_timeout_idle(stress_duration);
+
+out_stop:
 	WRITE_ONCE(doneflag, 1);
-	for (i = 0; i < n_stress_kthread; i++) {
+	for (i = 0; i < n_started; i++) {
 		kthread_stop(sktp[i].tp);
 		skt.nattempts += sktp[i].nattempts;
 		skt.nunlimited += sktp[i].nunlimited;
 		skt.nlimited += sktp[i].nlimited;
 		skt.nmissed += sktp[i].nmissed;
 	}
-	KUNIT_ASSERT_EQ_MSG(test, skt.nunlimited + skt.nlimited, skt.nattempts,
-			    "Outcomes not equal to attempts");
-	KUNIT_ASSERT_EQ_MSG(test, skt.nlimited, skt.nmissed, "Misses not equal to limits");
+	if (n_started == n_stress_kthread) {
+		KUNIT_ASSERT_EQ_MSG(test, skt.nunlimited + skt.nlimited, skt.nattempts,
+				    "Outcomes not equal to attempts");
+		KUNIT_ASSERT_EQ_MSG(test, skt.nlimited, skt.nmissed,
+				    "Misses not equal to limits");
+	}
+
+	kfree(sktp);
 }
 
 static struct kunit_case ratelimit_test_cases[] = {
-- 
2.34.1


