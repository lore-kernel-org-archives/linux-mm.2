Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47100C55843
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 22:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C7D6B0088; Mon,  3 Aug 2026 18:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73FB6B008A; Mon,  3 Aug 2026 18:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9898F6B0092; Mon,  3 Aug 2026 18:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62BA86B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:17:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCEC7160826
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:17:41 +0000 (UTC)
X-FDA: 85061371122.08.CD47BC2
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2556CC000A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:17:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PcbFgZXq;
	spf=pass (imf10.hostedemail.com: domain of 3ghNxagcKCMc24n6znyt11tyr.p1zyv07A-zzx8npx.14t@flex--pratmal.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3ghNxagcKCMc24n6znyt11tyr.p1zyv07A-zzx8npx.14t@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785795460;
	b=YP6upXlwgrKv4M/erThwJ/ZiZFPc41GGK7nYHOt3GWnCSC2MvF6UHu4R+jYPzB7Jgjqlda
	N05i7K2v9b3qDHllQzB8RL3jo374Zd5Xlfd6aB4EtSrxMEmb2dVH28IKVi3rTL+wHSsCBf
	HawYwi9Tjxe7H4CZWKzFMzaIP2tRjoQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PcbFgZXq;
	spf=pass (imf10.hostedemail.com: domain of 3ghNxagcKCMc24n6znyt11tyr.p1zyv07A-zzx8npx.14t@flex--pratmal.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3ghNxagcKCMc24n6znyt11tyr.p1zyv07A-zzx8npx.14t@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785795460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2m7uZHClv1XrW6044CiQwNw33tdPDy6nZL+JxysQdrg=;
	b=ClM4Z49fiS6vwBggjWLNu9LLikXSpmcmRM/qpApoDAmsRVGhhKNH1ATPC9QWhiAodStXKF
	+ceXsLmR2Y4i6OGi5xI6Tn0V5lNJIyDrh2+vgGi5cfrJe/zDugZM4ofQT3KtU2nry0NuFt
	GRsnOCp45AS+S6SmVpQgc4uupmR6rA4=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb5ea36f969so4117364a12.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 15:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785795459; x=1786400259; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2m7uZHClv1XrW6044CiQwNw33tdPDy6nZL+JxysQdrg=;
        b=PcbFgZXqL9/ck70s+nWg3x6EQXpkvo9Tmqn1o97WWRuB8BIDS4Kw9/E0ukdVsy6SAA
         2oVvKfOeoR5eoZmGs5VzPUc6sy4OhtURJRspj9b5vPBBk4IDGKDEwXpTYXE5lMcHz7WW
         hyFQg/Q9oicEWCNOFCw6kSm1JDZBZ4Cg4UUjQ7pQEcVfYQ8nQyG4rABw7SLryJwKrN7b
         MwRsipVxaH3hlXgCAjZTKo3LcJ0nW859nwZ67A+l/CKTvgPD7iGMHIATlVccl6065DXu
         QQQyXTFrxXC5BgiBX5XUITVc9pzbwGnYuIifKjE7d7ipeopucj4seER7Ack24NAKZoSK
         eR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785795459; x=1786400259;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2m7uZHClv1XrW6044CiQwNw33tdPDy6nZL+JxysQdrg=;
        b=tFS9xo1unJnWMQWevHH8hSAGEIUT3hraUdmuPbxETv8QuzMleZwblxQ+MD4CCU8cnG
         0CiDqScQwoCKpkGhV3/1Xi+XGiI0oEhhYsYIz8R9GoO03jxnNPKg8McU11EVnttE5x3i
         wg6fBob80WBQgIWoi+P26azuNimqLDHXD7AoRzB02HsElqZtiUlQQekweeHaqsTEHtPI
         2PZWOt/1OGFj/z3Qx3SN7JqC/VOetyXKR9v4qvXzgdpK9bqhZci+e9pJi/Tpzt2g4gjg
         JG4/o6fPAX/bAnEeebCYNk4uzvIHniZkeSwbIZlbrjup64KxXRBCvsX8Ip4N6D6fEYi/
         /v5A==
X-Forwarded-Encrypted: i=1; AHgh+Rpgc3UvVWXLEc1jSWDsJhgBcprRNWCneef2A4rRO9PgnjNilQIfYNhiS6MAnhUQ5njUTmsP8lYCOw==@kvack.org
X-Gm-Message-State: AOJu0YzLHQi7Sn/49Uw1JVem2yaRYyvRfCRhWeIby7EmPhMPlR3x0R52
	1Y/w7qEW01YGbUEvDhE0XVQSumSm6VxTl2qAMHWeSgDSL8U3axrLbMcAbj3D+LLwyOteGLvVVD+
	YOG9lMuAfRg==
X-Received: from dyaz4-n2.prod.google.com ([2002:a05:693c:6384:20b0:30c:86eb:3114])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3390:b0:3c4:3ada:384d
 with SMTP id adf61e73a8af0-3c92a57baf2mr10389215637.30.1785795458586; Mon, 03
 Aug 2026 15:17:38 -0700 (PDT)
Date: Mon,  3 Aug 2026 22:17:31 +0000
In-Reply-To: <20260803221732.3651981-1-pratmal@google.com>
Mime-Version: 1.0
References: <20260803221732.3651981-1-pratmal@google.com>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260803221732.3651981-2-pratmal@google.com>
Subject: [PATCH v4 1/2] selftests/mm: rename local_config.h to local_config.h_gen
From: pratmal@google.com
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2556CC000A
X-Stat-Signature: xb7jykzpf1mmwg5g7iandcwexg3r1pja
X-Rspam-User: 
X-HE-Tag: 1785795459-652525
X-HE-Meta: U2FsdGVkX18cGPJ82gC7l3fO12MNYfLMKLqFZFVBiZpwxGDbcLJbsxOxUdSyyBuhPWn3qhf2yRGIe90TOV2kYC1oK87y8m6OZNfnm33E8e5LT517HPN+FtcSFqNgacJLnwmhAj4YBApKZsRg5zkZDxduJbg1WUcxf7ilIFHbuD3hJG6XVUbdqHI1Ic6ffcPnR5hsZm556KJN2YOGU9MLEcb8yMeOKlVSvsyYA2ctKTJb6/lWmMNA4ZhbGKjzdJNRiglHRgK1A/JJilkfHS5C16C9i+AyMIp+GBTJArU6C/qHKiX5inYd+BJe2k6IvBqko1MeiWsOK3LxsmGphxGLxuJx7Lbc0nm0ov91CyTYuq07hxLEDjrXLpwk9kCln2Vte0eyPJt0uVaTYxcWMbmaoGJvgabuplX6qNcGyjQyPWnperYMgyJzWQhkA3/0p6WjEYSejsxA39c612byJ3143dLNZJvFN10Pq9ARQf7LEis5Xp8mvu8rPzJfVXJxApQ4C6RKtkJFaPFvaxwoooSkF4kxgyfom1mK2/UXQDOS8qHQ/EUJyK6zd2oZd6Ds9Zh4Y/6gkw0JHiHNx9Gq6bdiTJn//41mwFd5FyCEKadezaIDFGGwnZ7vUlhSh1QsmkyUil6kI+EZLytmKanMS14zE2NjZLH4/pqccFLZSpyI+0HvXv/JOnfQtgXTgikb0YMqZG2PMmn05EUqbMVHhCAcNgbQxbi2/gEhshDM+ZTDbVds5w4rdiS0Q3htNuZlXjxYAuoOiDBL97ZZBXTLnYgi8rbLeQvLkfiSmPosC1u3TNaxEnuXN8uNN27+RBF3TnTZCZuZV8n2qjEXAQudZ1yjf7mjgMaX76VJAPNXvPcQdo9O1w21b0HEW6wl0XqQfvMTm35kgRa1wLCqIvVUxy929Bz87to0oWwKV+u5ZR463ct4xLAS/80UoUt3pcEBIvOdpqXPTeIhoqDqHt8E/AO
 tr5pcplb
 tjtI13sYXWekPZv38E/uNDISf319vOQuZ0+tgc2WF7k3Au3CKChaiGP2lWaYggIS3DFQqM4isl43tGxclYmvXkh7ten9D+90yZ3HC9Ka7h8nvJe7XAU8Ww3z1fWdYz5FzEKm/Enc507oEXu+UVYVrlUIHNQ1chi2klI5yYchBsoQCDoLQx++NF/offXgBbS7fRQLS5Ob9dM8P9OGVhoRAmtsvrFGXtp8Pkm86fSXyM4t/XQaHbi/UKoSis+3WIHnEzNBLFYp6nRvbDwqK6c61w1RRuhk/rIU7NsI2YWu4+T0dsu5mbVwePo8uf/rbivx+hHcQU5B1LTcbK0SipKGevZt7vj9Clu4Qf0S0WtJBdHvG6G8c/ELqDOlqGKo33+VVdoa7R6zOMpDu1Otiwo4LY4XiK5tJXdUKcljDWHw1la8bk3u3X/hza6qWt8UvCe8Se0M7nZ54UeFyqo8dm+zOmTjP2LHWpm70bNb1qM9K05+pxggCudDsP5S79kqCsCoo19Fkplf/HGbGMlCUGQTSZmsHAzIrnFnu5Q/8G2PVl3/PpVR0N5+qyFcmqEWmkLbnulWVaYLjNL1Fxrk7nwQEtjbQHUBOd6i+n5tUwHltBYRPyXxZWyExC14m6kgMfotVeKDk/KvcabKYCzY2RChDXs4wK8eLdk65TI9C7cBdxaKrjTNeqrNzbP1TNM+RqMZABXz0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

Because local_config.h is a generated build artifact, un-ignoring all
.h files in .gitignore causes it to incorrectly show up as an untracked
file in git status.

Rename it to local_config.h_gen so it no longer matches the !*.h
inclusion rule, preparing for a subsequent patch that switches
.gitignore to a pattern-matching approach.

Update Makefile, check_config.sh, and affected test sources (cow.c,
gup_longterm.c) accordingly.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
 tools/testing/selftests/mm/Makefile        | 6 +++---
 tools/testing/selftests/mm/check_config.sh | 2 +-
 tools/testing/selftests/mm/cow.c           | 2 +-
 tools/testing/selftests/mm/gup_longterm.c  | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7a5de4e9bf52..32f4b016b74f 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -5,7 +5,7 @@
 # script so kunit knows to run it, and add it to the list below.
 # If you do not YOUR TESTS WILL NOT RUN IN THE CI.
 
-LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/local_config.h_gen $(top_srcdir)/mm/gup_test.h
 LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
@@ -259,10 +259,10 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
-local_config.mk local_config.h: check_config.sh
+local_config.mk local_config.h_gen: check_config.sh
 	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
-EXTRA_CLEAN += local_config.mk local_config.h
+EXTRA_CLEAN += local_config.mk local_config.h_gen
 
 ifeq ($(IOURING_EXTRA_LIBS),)
 all: warn_missing_liburing
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
index b84c82bbf875..b46bf2d2e7f8 100755
--- a/tools/testing/selftests/mm/check_config.sh
+++ b/tools/testing/selftests/mm/check_config.sh
@@ -4,7 +4,7 @@
 # Probe for libraries and create header files to record the results. Both C
 # header files and Makefile include fragments are created.
 
-OUTPUT_H_FILE=local_config.h
+OUTPUT_H_FILE=local_config.h_gen
 OUTPUT_MKFILE=local_config.mk
 
 tmpname=$(mktemp)
diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index d9c69c04b67d..87710c5a2d3c 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -21,7 +21,7 @@
 #include <sys/wait.h>
 #include <linux/memfd.h>
 
-#include "local_config.h"
+#include "local_config.h_gen"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index f61150d28eb2..00ea0dd2f655 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -21,7 +21,7 @@
 #include <linux/magic.h>
 #include <linux/memfd.h>
 
-#include "local_config.h"
+#include "local_config.h_gen"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
-- 
2.55.0.571.g244d577d93-goog


