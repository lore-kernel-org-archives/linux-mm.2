Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213D0CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724116B0092; Thu, 14 May 2026 01:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D40D6B0093; Thu, 14 May 2026 01:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2EB6B0095; Thu, 14 May 2026 01:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6BF6B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:07:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD70B1C0218
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:07:08 +0000 (UTC)
X-FDA: 84764841336.04.3C0A0C7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id E95B52000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:07:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u6aPQJ7B;
	spf=pass (imf13.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3O8eRbUVYramxWyuUj8M2r7FqqoKtg0Lc9uAYSPgUw=;
	b=4vaBHu6SH8Pyh44OW4A3Bvx8plJhu4Cik2ywQFNz9BHT57y4oQx+gZp7nsZ3wESPRmchCz
	ODshz86CbKdJWlmAonpwFbsxWUuVpDE/Es/SoybmWgIP9kSuBDnY49aapczWaQgmnmUiU4
	ULz5UB6TwUWf2CnKgmtgRdsyDwer0nU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u6aPQJ7B;
	spf=pass (imf13.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778735227; a=rsa-sha256;
	cv=none;
	b=3ha3DKdHWpLBAH6Nqk13I+EApTTpi3kmX//p0QqlzYJ2gp5XSfaik5DTbJSZKM7LK4z2vi
	PQgWu3Sxd6gAWDKrPajiIdRzwhGqUaHEP4IxWJ7ROA36iqC2fQtxeiKVY5H9FQdEHZAxxp
	29zgzRMcXeNMwxD7N+XCDQEUA6umWSo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2A8634FE;
	Wed, 13 May 2026 22:06:59 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.197.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A3BAE3F7B4;
	Wed, 13 May 2026 22:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778735224; bh=BANIRIqsq1p4Sc4QnkiivpJhCJpebYuZdrDjdfih8k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6aPQJ7BZumqfz7tiHCCZ5t+ueVed1AOrEwtNEyTCj+4NwgHp4vP4fA6JCwowBPef
	 g040pef32i4nOIkeFUYUReBkJGPP7GNHe9Ep2/337vVuPkKKUbMnw/ebiHUnzEX17l
	 UJMfvVR4OtpSKlNBiTseH8qZl1SU/yS+4JiOqAK4=
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
Subject: [PATCH 2/7] kfence: kunit: skip when no pool is available
Date: Thu, 14 May 2026 05:04:50 +0000
Message-Id: <20260514050455.2954509-3-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514050455.2954509-1-justin.he@arm.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E95B52000D
X-Rspam-User: 
X-Stat-Signature: 38uo6a99jrjszobqn9xr5d71p3ce9sbp
X-HE-Tag: 1778735226-541610
X-HE-Meta: U2FsdGVkX19aon02DkmgQvgoNYFkTDhfjSaxpdlEcUDT6hv//ZL6XizoR7kapSXu7bj9UGru8/TVkxRlnOPowAfIZK3aEW4AlgX75/sGZ8LS8g/wVsnlst54kUfgVPbmN3jQPe68XyiXOM9rjyVn5BFx82LNUOesWlcuxJZCeXKOr51mcJYS766DjlCXq7z7blhEFi5wEqeN8VpGkbPkWtRWULLRJfj4hRLv/5pnCm0/IqzhHSnE4x9rdn0KEV6bY8OO/ofraZebS2iV9dlboTdOrylmvUq80lknN+rPTp1l/xPbw87ydFxpnH66R0Fea4FKqQbQ/DeB/NmBtTl5d6ytQgmP4Q7AUncGlGZ9g3BuT5AvlUhbvGkF1Mg+4OpGZRy8ZZmlS9+7bbJ2D3+KRr70Brih42oXsVwm5Hi3/RKUI96e7kZmDs9nllNNDZHFvkSxfFGIoWXbQ5cPIjgB/hSu8sGuaP69aarfdeIdE7Doasj9a18ZGPSsKvINN8kgipn2VvrWw7/1FFWKPB8h9I472CknuhPjd1Z6EAonxf6IeuZphWrt+j4MU4nunxrJRbeOJMJ0HIPguYMt769qoSimae75uyofrVZwb8anq8vVcTyKa3H+11l0tfuI4WZxHh7kom6ekQ8kS2UaDsSvgzAAhvyh31owIBLR0yHb023iPVfANPCTFYekp+exCZ0byOir+XHBgfvcxyvL0Hmm5prVi2hT1rIYRgoX0SZi+qnTGWBDI5+HnS3aDAmzb6hS9AXU+p8WnNrnhG6AaVhedghjrSViK6SkBGB+lRxxsi3Gn6D90ujBi+hiQQNECo0JLt/qe8Q34qy85ZkZJgyR3uA9cCyUESK/p3PTi/x1ELTVU1SjyVAvvLES6X4qFc1IupfzIEqe6K/MhPanHjbfyFBIgYBIPNkVUt/E1LludwdaiTlTTqLtvnem0qNxnIGjKSmNxzWWA9XoT0ZNDAd
 m3Sdvuxe
 cZ1Kl/IcKSnIKadCZesAA45tvef2yS3mWwl0YM0reqo5qMPZMRp6cAtZhqzj9REiLX8Tl9XTBx6KuIkgDFUJnskeR9TsPyXNAmXEFsDSffuf22rYVfKk35nS8sOnHoHXzX3vosrYsvFDjuu4l9u9Lc+pa8MsiZ1pViot+o4avMmjiWVsHmBjZEzQdIxBfLihG9aJ8//xVpBKpGo5DC9c+gnbI28Gl9ogxhOIPWxI13RCyRN632muAX+MJBg35L5bTtkgsY+RKezUHt1F16LK+MFzwiokzoh6gsICwGtSsheA9WXYvbSyT8RLbeX695FNJtR1EBviQAqgQRKRb0Ki5wM+6pCIKQT29Ol3Lok12oe/cN90iAbgXOxRWglxMY0qK9QWP79EGtLa+EfWRBL0hC58T1AfOffyqQOEXojj3iqWGTotOCMM7AZ+dYH0TN26ZBlS0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KFENCE is compiled in but disabled at boot (KFENCE_SAMPLE_INTERVAL=0)
or __kfence_pool is not allocated, every kfence kunit case fails with
-EINVAL.

Use kunit_skip() so they are reported as skipped instead.

To: Alexander Potapenko <glider@google.com>
To: Marco Elver <elver@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org

Signed-off-by: Jia He <justin.he@arm.com>
---
 mm/kfence/kfence_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 5725a367246d..e376329dd621 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -822,8 +822,10 @@ static int test_init(struct kunit *test)
 	unsigned long flags;
 	int i;
 
-	if (!__kfence_pool)
-		return -EINVAL;
+	if (!__kfence_pool) {
+		kunit_skip(test, "kfence pool not allocated or kfence not enabled");
+		return 0;
+	}
 
 	spin_lock_irqsave(&observed.lock, flags);
 	for (i = 0; i < ARRAY_SIZE(observed.lines); i++)
-- 
2.34.1


