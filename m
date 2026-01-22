Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB1AD3EE96
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72526B02BE; Thu, 22 Jan 2026 12:02:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86756B02C0; Thu, 22 Jan 2026 12:02:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973296B02C1; Thu, 22 Jan 2026 12:02:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8423E6B02BE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D7B78BA75
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:42 +0000 (UTC)
X-FDA: 84360218964.08.90DE8F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 762884001C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+cqrM5OmKpd1wBEZEXXe8CbwOh4nwNeTrtDHqZrpG0M=;
	b=B4xypUib4C0MAItNdXA1nTHZAfQKQNHZv0c20QMA00S5hM/V7ZiUutl/BaUMmhsYFa0TnW
	w5PusKECU256zWRSUk6hsT6JNHniNtbYklsofWN/kYYA4hbT1hpwq4oW6wsNv99IX9OI/m
	Qv+tU+OO4k4ISaD2rvSvaRmNVAV/VqU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101360; a=rsa-sha256;
	cv=none;
	b=Hxs/c1xAS/h3ny+86UGb9ICmA6USD9xJIQ66YiZUjTT9w/CEvm+UuknCcb2ilizDcUWSwR
	zB0RCGrt8YcQQbhYSTg4AU2j3cuC3eX3+gjz8XVcqEbfAm/MVquyqnELvrhGsalOF7P56P
	dKI0cN+vRI+dc9vYMsfirebJXqym0XY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DD3E1596;
	Thu, 22 Jan 2026 09:02:33 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 245C33F632;
	Thu, 22 Jan 2026 09:02:38 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v3 3/9] selftests/mm: pass down full CC and CFLAGS to check_config.sh
Date: Thu, 22 Jan 2026 17:02:18 +0000
Message-ID: <20260122170224.4056513-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 762884001C
X-Stat-Signature: gztg9u4k6ycizczr95fzj341jtq9p6mc
X-Rspam-User: 
X-HE-Tag: 1769101360-553338
X-HE-Meta: U2FsdGVkX19HgViTmJA4yiGk3KzSoMqFklBC8a4sWvo5+wpplWCq01WgPymp2MK1YX5Ol3udJXIn06JdAFxiCOrqtxNtkcN/HGdqGjWZ6S+Zg9/4Cqj1Z4hb/xqQ4BjuyQlmjIExWT/XDYgut0ugXJ64FVU7dAMVS5GqCJ3rkcps/uCrr0+hdDtXyulstuirvnEFQNUDQvYcbSHhZi8uCQvpMb7PYCB++PeH7SaS+xVOlp71rbV+Oes7xKxsAMwL+Bs6FHC3thqHABOn0HYNo040Uli9bfkCNkpOg7baTm0RgyEFiyYu28dJ0vS9jc/rRUeinwdMgCx+CsfQZNwubgRgEGVASmqJCFcRRk4K7ErlzwMUVewetoJh90S2Td8ggwwa82W+56oYxoNruBKaNMLVmYNR3MZc4EJBawe90pZoBPHElKnx254jwEAi3UONJQY1BPCVf/DXVx9/ZuMdtqN4RXGPVzbDfJAyCMCwmAMdJqHSe3Z9+EZlOxDjTZf91wo2V0IQdNdTmqjJ2MejoPpEUGWyyJliENfBERBi7B5t4MdYy3XcuvaB5Cui4Q/9OoqFClrEojBwlzioIxubk68ZNG0VX8HAWoI29h+yCt66dqI5Z5khE4fZtt5wo1YegewQ2dFkOb4dKeTAyOhc85WsDJMMS5zdc8hkXWj5QFvdhnA66ql/mylFHQ9puP8ojEte/YVWioe+T68Gw7Y+z36BWmxoYWlO/h8WQDMpD7GyaYcUdjUqVmBSyYlvDIycIXfJEsQoTqGzw0oOOcSLEK/k8GTxypOAi5zpN3Ut5vAHJLsbcDJ7UYnKrbRHarT4FahyK9+KJdrREUHLRIi5NruWJfU8EMEzMZ/MD9Ll69Ubogy+847NRX6V1fYv8qMqkKntfP51XlkqYOhekT7zXbng1fMsvsEskKuZtXQZpJhHE1Z0fXmwMdCQICf6J+ZvEy3AEtGXEcw4UxJdAnv
 zMuce5M1
 Tb3DByaX+ClHyHBtZ6D7TQ/eoiOp81HnTzEN6stTGljR6a7gPNjsbAbSSh4Lb4/bLAzBAHb5qdS+cN7of3SJi8SQSe8kLkf5/aUH+CtSnUSd4QMecEkSg+TP8Si+rf1vGix3wPxQrou4QJFPgdzzoURMGJnbOW2H+4ecggLwHA0MyQHelP9mHnnsTEUrMFZi3FRQk/pQ/1sbrXqgv5L3n0jgmdwyxqgzppfiGiaibi5+KEZwTiAurw0siCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_config.sh checks that liburing is available by running the
compiler provided as its first argument. This makes two assumptions:

1. CC consists of only one word
2. No extra flag is required

Unfortunately, there are many situations where these assumptions
don't hold. For instance:

- When using Clang, CC consists of multiple words
- When cross-compiling, extra flags may be required to allow the
  compiler to find headers

Remove these assumptions by passing down CC and CFLAGS as-is from
the Makefile, so that the same command line is used as when actually
building the tests.

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/Makefile        | 2 +-
 tools/testing/selftests/mm/check_config.sh | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 4e5c8a330a0c..de4afc34e3b1 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -230,7 +230,7 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	/bin/sh ./check_config.sh $(CC)
+	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
index 3954f4746161..b84c82bbf875 100755
--- a/tools/testing/selftests/mm/check_config.sh
+++ b/tools/testing/selftests/mm/check_config.sh
@@ -16,8 +16,7 @@ echo "#include <sys/types.h>"        > $tmpfile_c
 echo "#include <liburing.h>"        >> $tmpfile_c
 echo "int func(void) { return 0; }" >> $tmpfile_c
 
-CC=${1:?"Usage: $0 <compiler> # example compiler: gcc"}
-$CC -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
-- 
2.51.2


