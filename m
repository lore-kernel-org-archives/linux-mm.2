Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13DBBCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E95F6B0093; Thu, 11 Jun 2026 08:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0CA6B0095; Thu, 11 Jun 2026 08:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDC96B0096; Thu, 11 Jun 2026 08:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 410346B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:45:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF8391405DA
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:45:20 +0000 (UTC)
X-FDA: 84867602400.25.8105DD4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 03EDC100010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:45:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=s+vs5POf;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781181919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ANkUBUW0AiqcdqhZCQaCikPj4wJ9n2miiY8ADVD63kM=;
	b=sKjvyABT7y5ESbMLUat0nQEAA79/n/n793kOhX1ZNN3SCeXg2nwDJV4euRMh1ix+EdZ+d0
	uvMidPfS9+xyt0m+h9kyuHzGKw0XdciyE656oawEHvlcJGvBjc969eHzicAIUxlfBt4Z0p
	Lbha8hPCq+hLKFE7L/D5H06JCSKAf+E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=s+vs5POf;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781181919;
	b=Bp3LdCyO9eHHhzkikPcb1cq9OfQNpLzZuMW+z4eSgWY6kMLyffJcyXn7aerxFShgr4cR9Y
	0+5RiqjO1MJMhS2cDg3SLlJeT7QKaa5oqfrnQQ+soIDt6iwnkHAKv9rRG/J1tHMbVb/gF3
	1z619ZGpPLuJeAz54/n7OF30R4Lp568=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=ANkUBUW0AiqcdqhZCQaCikPj4wJ9n2miiY8ADVD63kM=; b=s+vs5POfS1cOXulTEXiW7K8ehr
	zY6a8YjV0y/4Ls4zFdLGBCU0ZuCY/5PZRfLopDSytWoqYoeHV74MKFJIw7H2vbq9vRJIHhzBTgJmd
	7tO7dJ6RM3XD1DZP9qtLQmirM4LK+cSnNqlzez0J2t9dsYfPUBIkgmvzMPBZx3yHvLRcfmgthQC56
	sgfTjFRyYg0T4JhFzyo1SUU9bgyhNFhI2p9Qm0MdfogrDcyWb6lJx4gTTs+Uh1rjXQYtIYmAT9n07
	TYkj1gpzSw0r/mU3LheT41vidaSbKyjjSbbxhXkyGtGsNGvBQsof9WPldoEHDduVSSUf2uR9EOGLq
	KTH6anXQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXemU-009xy5-3A;
	Thu, 11 Jun 2026 12:45:11 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 11 Jun 2026 05:45:00 -0700
Subject: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task
 stacks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
X-B4-Tracking: v=1; b=H4sIAMutKmoC/x3MQQrCMBAF0KsMf92BJGBbshU8gNviIiRTO8RWy
 YgIpXcXfAd4O0yaiiHSjiYfNX1uiOQ7Ql7SdhfWgkgILvSu957rKutDUmV7p1y5ieVFCjsvZQj
 jaUzDjI7wajLr9x9PuF7OuB3HD6uwcCltAAAA
X-Change-ID: 20260611-kmemleak-stack-resched-01ed72858a7f
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2409; i=leitao@debian.org;
 h=from:subject:message-id; bh=Xzjey3oU6Gako3r0mVlv6us2QUMOKtJPCFgaQ6L1zU0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqKq3Sd8LpaUaDSfsNMpGN3CKrIplgCKbm0fhUT
 kFP92mZ4N+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaiqt0gAKCRA1o5Of/Hh3
 bUjcD/46jQuNP9O2OsG9TaVh86su/9q6InXfWqSnPBF+s/+TQGyVP+mC5ZNKCWKB6iKBCfoiVZz
 GUyHcW0U39m46s2slTsaH6j47rKDvGLQtUXUNYyVOtT73BuLFp8hxB947/CGvlu/QI2xIEIiy8z
 ZHkwHstRJGIfRzYnJjLyJzdXEDAilBO09+/z+USPYE79Evi8/I6nBYNd8RXH7Wb9EOOtUeDgyFw
 i1B+ov5cT54OPzFr8WjheRv+brne0s3c1Szhkf+EwLuZtCjbe1lbkORX+7jLIbO8NrC75xvZBnN
 0MUeHwdVSwDa4+mtEQFS0JTB1g118ECqkjjKUWAcbScTTPEPHlC49K+/zTAM07EF763Y3U1RX3J
 J2aveYR4O0xdyqHG7PK9MbA3nd5y8hED4PFVXdCFsb6yE+4t/lq8GyGtsb64YVoSejUzXbapGxh
 IJQ6ARWAfz/T34T6z2jQ20cFMViXFEEZ4SxEqOTxFFRo3K+l8ae0yxAa0gGjoEycnGwMsj3+MOg
 zkfq6OnaeakExjq2BHn/EXgFE9TWajOtfVYPkVBbQ0vAh0PaBYSg6AFBqVv+BXKDq0FS+DzmL8P
 bIKI6/e6c4Er2OeDudD+U7U4ktfIj3oy8guOkU1joTK/Tf48D5r6/OJnaf+WQ0ULzXlJDnehKt3
 /FWKIgixgWp/iBw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: aq9jtbettkczm7in58yy76k73o3as8wq
X-Rspamd-Queue-Id: 03EDC100010
X-HE-Tag: 1781181918-952626
X-HE-Meta: U2FsdGVkX1+Mj33BygNIOj/i6S/cWAjsbx7gWtYK2C0zsH8r7U2lMLbC1qhB0LjHLBe8Iy3oNvzXvV2b5PyK7/8rtL5csbxr7EKnLAkn8OFV5UN8JtBkWJQJG607WFIyPACLCAaFi5426qUIbreTmC5giME1n1vRuPui7VIoQcy74Z16dPQWvmSENQK96+cFHfWbcIkMCqunv6udWjvBGAQWUkDeN5F82LcqBHqBl0rtW4KlAYmFM6GR0CM4BhBIJBOdUg02Ip7Z5L+gImbaHVc87fiI9BuPyNppkpg2Zp+DZ941E1cqRjHd1iUtiADS0LHCvw2AJauYQmBl59Xa/cLIjNK4cLl3U7jqWPyOvFBlEHrJ3WTdOQg+Pv8ofBnMIwxAkZNpK3HRfcqywsxA2sr2uimIEZc/Kf8U+DAqN2OoHmciGZBqXmShEcrIb2u/ZHK58LsiTzv2x73dkliGfCsloRlsgpkkzpHIvR7Iun7FeamewcSFIsEPvodB6Dh1IYfhF0H8fd/3YckpC9rGHe44MsZA7sPUatcUZlZqhF/M96NMaEcmrVvNcc7XA9k6CAEa/UtM23VPBd3PFu7ArKd1mEqSkMxPX4Uc8mKGq5k9Ci/ElHAPH9Wp0RGdac8RSESZ/Uow7VBpA9EY9OkzCG7UrK/arRfhiCYqrqPx3rJdRes6ksptxZ6/Z9+mo8S4tGiPUx1MtzN7oe3YlQZG0ZXxRNdkbTwesQ4qwkxjOOiL0bIi3iDmXD6yd4jrVULxflAVtC7hQrh88hI+/WB5o7fXIx6hwJtMsCYmBvTtRZoRKry8yG1CQkk50PFoyWtIhzv84+oUamGXOt6JsjtwcE1xxRerlhlFf39Dvc2HlDHzAiKge8LHA4wokHom2oqNUzpxOHE0yUSq2JKmNkvP+z3HV2SoAOK45MmHDmMIQujv1Ta5stvsSvijOSbw9Jh8cgYpj5rucYVU239VMqr
 lNeixdDc
 q4YA3iN8jNNArldGLQezAP5zpzcTXseSczZBjeY/bl4osnIdhYy+n1YNlL0PN/fHJSESKfCEOezhVMZij2xzbpNdPzeRRyqQ9Hdl74rKgNeXmDtp1jY0XQgRiZLwMS8wP869oau10szCVQx4U+/M181q6k4EQMv9NZPtGa4W8hfcTu9KvAeJpW4Dw3/Ia6ZcD2kOX60p4NVDfr/krVQzujOIORTQVOWd+INaMCZ7s1WH26Up7Hatqu93LzECrvnoSLBqJCkA7d2HEjhWawVE7weNGeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemleak_scan() walks every thread and scans its kernel stack under a
single rcu_read_lock() with no reschedule point. On a host with very
many threads -- amplified by KASAN/lockdep in debug builds -- this loop
can hog a CPU long enough to trip the soft lockup watchdog:

  watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
   scan_block
   kmemleak_scan
   kmemleak_scan_thread
   kthread

A cond_resched() cannot be added directly: the loop runs inside an RCU
read-side critical section.

Split the scan in two parts:

1) get the list of tasks (with RCU read lock) in an array
2) run scan_block() for the tasks (with cond_reschd()).

Is it a sane approach?

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7c7ba17ce7af0..9f8a35ecbb50c 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -62,6 +62,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/stat.h>
 #include <linux/sched/task.h>
 #include <linux/sched/task_stack.h>
 #include <linux/jiffies.h>
@@ -1885,17 +1886,34 @@ static void kmemleak_scan(void)
 	 * Scanning the task stacks (may introduce false negatives).
 	 */
 	if (kmemleak_stack_scan) {
-		struct task_struct *p, *g;
+		struct task_struct **tasks, *p, *g;
+		unsigned int nr = 0, max, i;
 
+		max = nr_threads + 64;
+		tasks = kvmalloc_array(max, sizeof(*tasks), GFP_KERNEL);
+
+		/* Snapshot the threads under RCU */
 		rcu_read_lock();
 		for_each_process_thread(g, p) {
-			void *stack = try_get_task_stack(p);
+			if (!tasks || nr >= max)
+				break;
+			get_task_struct(p);
+			tasks[nr++] = p;
+		}
+		rcu_read_unlock();
+
+		/* now scan_block for the tasks above with cond_resched() */
+		for (i = 0; i < nr; i++) {
+			void *stack = try_get_task_stack(tasks[i]);
+
 			if (stack) {
 				scan_block(stack, stack + THREAD_SIZE, NULL);
-				put_task_stack(p);
+				put_task_stack(tasks[i]);
 			}
+			put_task_struct(tasks[i]);
+			cond_resched();
 		}
-		rcu_read_unlock();
+		kvfree(tasks);
 	}
 
 	/*

---
base-commit: abe651837cb394f76d738a7a747322fca3bf17ba
change-id: 20260611-kmemleak-stack-resched-01ed72858a7f

Best regards,
-- 
Breno Leitao <leitao@debian.org>


