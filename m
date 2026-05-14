Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA26BCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBF66B0096; Thu, 14 May 2026 01:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0452F6B0098; Thu, 14 May 2026 01:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E769F6B0099; Thu, 14 May 2026 01:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D45376B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:07:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96241140349
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:07:38 +0000 (UTC)
X-FDA: 84764842596.13.A5BA6B5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id A3E80120002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:07:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o0FHpsW6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEfB7h/E+IDxjLo5VL4lrBaGXW376jhpDCp5mlIFY4Q=;
	b=V/UPFumgG/dx0VEZ2kNVi2zX7b9taTkR1lbjKKe4AZslTSsca24Un5yBgIdPBf2bAucbNN
	9PfLmHU+/2ct56pWykFT4e4g6dazslZ9BH+SQqWOQAjroV704uIrpy1vHz3liF9GIbHenF
	33V8p3681iBX1HbSzQD6iobaBoVOE4U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778735257; a=rsa-sha256;
	cv=none;
	b=37fG0TfQybIjUE9ZQ4xdCTnjtdNwY2fujvYMkeM6qKj5B3oDue+9Kl3cO+UTJ7/Qk9bLZp
	31CqzAr2bccI1DutdtNmuPfwvYYF1IzB4b+EheWFGEQKOq7SRL3Tjyzq21gRUNxeVz/cGM
	eqFB4C5cRAr68Z0fKcG7rdS8I+Fb4Hg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o0FHpsW6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2CF51655;
	Wed, 13 May 2026 22:07:29 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.197.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 725C53F7B4;
	Wed, 13 May 2026 22:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778735255; bh=czAmxYpsET1Yh9/oz4/+53pPQLCrLQvlifYICwLtv+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0FHpsW6gdbF86tmY2ETArYqOqWqOOY1GNI2kiRdvM0pm7oBhmWbI0Z0X6+EHPNZl
	 qQBBP5fVos0FOErmjWVY5uBrA7RJCxa2iqP47kzzSkryHXE/vBAHPK+Hyo+H+t3yN/
	 GRfD9Ykf4sHrnO+EeU80Z+AFYPlWekU7W7R3aPKc=
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
Subject: [PATCH 4/7] kunit: platform: catch duplicate (name, id) in kunit_platform_device_add()
Date: Thu, 14 May 2026 05:04:52 +0000
Message-Id: <20260514050455.2954509-5-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514050455.2954509-1-justin.he@arm.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3E80120002
X-Stat-Signature: ut3g438chrw7xfszzsmg6dyohuz8spem
X-Rspam-User: 
X-HE-Tag: 1778735256-416914
X-HE-Meta: U2FsdGVkX1/DkOmhajGyFXGsDei/g5OYvRtDgmL6Y/cqvQdvUJXmI4Z/pNBT1pdf9tU1TH8p9wE5tg0AI7bdKDnhqPW0X0VgnprWM+fbMKQuUPElemZoRNGBQT1NVPkE1cNrPcVoHpiDsvoFOFdwNxCEH4Dz5tTc+3srx2FmabSb1LHPtrG2md38BM5dDEOZAZdDSUHx7h27T51uf5FPAVyIvJqp93sZS9L+M4uePvwdzbPvj4cerdJPXUEgsDKJQT+BTePZr36dIYpPc0KtXtzA8Dsvq1v/KVB/OvGTwCRO3B3/3iaMu9ibdi/w5oLMGbmiiQ5aaO8g2mY0vjieBk90xliYz2efxrTqFV/Tte3afaPlKwQMsvHSFN1QfwVw/n2fuqvH51jc+YuXsOzjMnsRYtF+SeqH7s8iiLVHeNYvuPK06Xk28VwMlwq91JsmDm8NKAU5L/X48IMA0ai3/92rHsRa+j0l5uicRAbXQn4Pu0jNGGHDt/YOBehKWO9Vjw6VXp5yEytrH/rDS36hSzwdP9csCKMbwkQ/SIolosqbLEcyUzAXzN23yE7z9yK+LHbWC7eiKX40Weap5XQ8d1eH3UpNGsS6V3jatW8XkoKnLr3bwwGs6Pe5V1ztJ9QXr57WJJ5hARvzj0GESXUeGuFm16yyJNpNdLQSjyC0hmJqgXo4aXA2qL+VgeD3h2e4m9zzOSRLPwM/+x6HhVZXRFLSnUbuJQEVNlPNByLS8UoWoJxt62p8NgbiGz3NPYcVd08qtVFkyNpt+beGh9q+7pc0RumwUQHgzzVIc42aMzDqVSXBa+ee3PPcXJ4GFf4Vn+srDDtPYD2XX2TZls1LAS73n1DKbz0HcrVjsfJjZicO7xWai6ULY4rRnwOQFCpW79qpkUEOMGqZu1Wkyr0tILI83W4gedrYKBBOLgw1r0Jm2J/8vX2Df4D2i3TDBnWh6PRyaa0ilzT5Z6Ctug5
 uD0sCqWt
 Ky0Mpz/lM8ZZ+0C5D9ZOkGt8Kex5jgYq6Vm0l9blfVvTcHDtRTIIiJaqAUodZphE+F5UHkYk+dUQQosCu1LXXfjSQa9hJ/g1F3vP6BvIGD1F0dSYI9AtlO84kUYfGxxphjwELyRkHbkHNfWk7holeLPr00wZl2T5lRJUdaF+TqxY7/l7jlMaV2vN3tdSqElndXZgngVV4DtJRoYC4ICYbwNtGbYZgyzdHI/zgpJWOoXkyFeYZ5CrNPlnT6xDbv1NHxrcPg+JURxIxY0V8sK204zi68QMVxSiX3mt+rzRpYLDV9FvD51U9LKAnxeakpfTtRxte24ntLRBoqEC/WPJZKzevFNdb4qdF4LJiiSmkBTDji6IzYzCAnzIcTq7l2OFhe2frEXDzHqyiJwuDw6UvpjjKtL7fC7aVugLkmuXLMEufvkhn4oF3+LvNx7gfux33edZUG5guYrJ8cp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kunit_platform_device_add_twice_fails_test registers the same device
twice and expects failure. Without an early check the second
platform_device_add() reaches sysfs_create_dir_ns() and dumps a
backtrace via sysfs_warn_dup() on every run.

Walk the platform bus for a device with matching name and id and return
-EEXIST. PLATFORM_DEVID_AUTO assigns its id inside add() and can't
collide, so skip it.

To: Brendan Higgins <brendan.higgins@linux.dev>
To: David Gow <david@davidgow.net>
To: Rae Moar <raemoar63@gmail.com>
Cc: linux-kselftest@vger.kernel.org
Cc: kunit-dev@googlegroups.com

Signed-off-by: Jia He <justin.he@arm.com>
---
 lib/kunit/platform.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/lib/kunit/platform.c b/lib/kunit/platform.c
index 0b518de26065..515f7c859014 100644
--- a/lib/kunit/platform.c
+++ b/lib/kunit/platform.c
@@ -7,6 +7,7 @@
 #include <linux/device/bus.h>
 #include <linux/device/driver.h>
 #include <linux/platform_device.h>
+#include <linux/string.h>
 
 #include <kunit/platform_device.h>
 #include <kunit/resource.h>
@@ -80,6 +81,20 @@ kunit_platform_device_alloc_match(struct kunit *test,
 
 KUNIT_DEFINE_ACTION_WRAPPER(platform_device_unregister_wrapper,
 			    platform_device_unregister, struct platform_device *);
+
+struct kunit_pdev_dup_match {
+	const char *name;
+	int id;
+};
+
+static int kunit_pdev_dup_match_fn(struct device *dev, void *data)
+{
+	struct kunit_pdev_dup_match *m = data;
+	struct platform_device *p = to_platform_device(dev);
+
+	return p->id == m->id && p->name && !strcmp(p->name, m->name);
+}
+
 /**
  * kunit_platform_device_add() - Register a KUnit test managed platform device
  * @test: test context
@@ -95,6 +110,22 @@ int kunit_platform_device_add(struct kunit *test, struct platform_device *pdev)
 	struct kunit_resource *res;
 	int ret;
 
+	/*
+	 * Detect duplicate (name, id) registrations early, before
+	 * platform_device_add() reaches sysfs_create_dir_ns() and
+	 * unconditionally dumps a stack trace via sysfs_warn_dup(). This keeps
+	 * tests that intentionally exercise the duplicate-add failure path
+	 * (e.g. kunit_platform_device_add_twice_fails_test) quiet without
+	 * losing the negative return value they assert on.
+	 */
+	if (pdev->name && pdev->id != PLATFORM_DEVID_AUTO) {
+		struct kunit_pdev_dup_match m = { pdev->name, pdev->id };
+
+		if (bus_for_each_dev(&platform_bus_type, NULL, &m,
+				     kunit_pdev_dup_match_fn))
+			return -EEXIST;
+	}
+
 	ret = platform_device_add(pdev);
 	if (ret)
 		return ret;
-- 
2.34.1


