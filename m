Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC054D0D143
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E70A6B0096; Wed,  7 Jan 2026 11:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8446B0098; Wed,  7 Jan 2026 11:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6750C6B0099; Wed,  7 Jan 2026 11:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57E256B0096
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:48:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E81A1AAD9F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:58 +0000 (UTC)
X-FDA: 84305752356.28.C1DFA36
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99D98100005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804536; a=rsa-sha256;
	cv=none;
	b=wxE79rQYbU2SKN2cmQLoVYVZcTMzCzlHwIONNXNIrL6GPO2RxHmsvZfy80Za1FN24KAJtc
	cNWQNEuWVO6cQtJxDdPi6jqW6Xk1A8RtYL+waX+BgfkNQjsChTDfr0YRnNYTHB9yg7a4r3
	KyVib/KPdOTze1GPZOO7UoGWWJ6j7Es=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=itqaKDb0L3ihII/ZhInIbjXsKbh+AcfS9nkCAGiEbLY=;
	b=Q7zU38SLEjKvQ6nWxJN+1OpZxLZIft6Pe7ZxNnO78u3GfCcseRBB6oJkVJpYUl2+LdtvAU
	uD9v7M5M/FjRtZGiAViDmhxY0BfieEPZFrzK8bDed2d15euEqSG0BNcOH7ZLb+yjrVD6HW
	E4T0HWM+N3wG0VsqGiptnHQLC9dCEHw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10BF6165C;
	Wed,  7 Jan 2026 08:48:49 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DF0F3F5A1;
	Wed,  7 Jan 2026 08:48:54 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v2 3/8] selftests/mm: pass down full CC and CFLAGS to check_config.sh
Date: Wed,  7 Jan 2026 16:48:37 +0000
Message-ID: <20260107164842.3289559-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107164842.3289559-1-kevin.brodsky@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99D98100005
X-Stat-Signature: 6dqifofkdieje6mso5iin6n566b5yukx
X-Rspam-User: 
X-HE-Tag: 1767804536-685027
X-HE-Meta: U2FsdGVkX193p/UYN6DFBpS6oWF+qJrFzxQikZqnkkbh2jmy/K9JYK7PuTNLrO4skrKHMNqNY91aIO11K7RSd0/bDZCGOMHO0pwATHX5ktJxuZPxVaRju33BD3R3oXkwBrirHr12SNiVIVTLSI98diU/TsC0qnSKINbJcp3m9l3kO7fIWRzsmby0jU/Sba0HbTwtQltNeqh7iANpWyTkyL459I5QnJLQst7W/8/F/T/QJLjgAW8/EuwERnd1cathvADv3Scwl2swRvIofmiMkJGIQXUVIGqLT4DmPfso5Szggejpdiusgtt6YxHz01Mc3CgHHGlx9Ikc1fo1yNnIT5JF2ARzkYeOLN5ElLklPkuhp8/z8fE/oBZVjSplwHbh+bjf5RO1SLuUonp8FqYnnenFLNii8iqO4btFabX/VJGaHCxCm+gV95FEa1wa4LAEya25XocyTnwDIfdS5fM9VEvrwdXWuEfAhpR2NBj3K+oAmVgmZOEJYmIsgsGbZrH8Eu46BCieaCqt71iCo9Y8Tyrp8WlxhETdySgy13PL0xBHZhNhm4+I7OyGRrh0wXGbDzQIlMQsvjXJPHrX6efzD57vmMXW52MTPtJF7cQJjhsH5CqpMNa+iG5XRpmXf71ytyaDnpMw5OelYzln/NJUBIdkW35hDRzM1G9jNoUVQDgwc+Hq55i91q2PcL798H03fXSx3mNxHGUTtOTeKBQ++eIgpj41OUB/EhOG0B+ya53xI8OM4D9eEP12pUPmT+sgf/iViV08od7afxzUpRLOrYw003efCB8MztL5kTIGAl1Aig+t7VtPQ0ZPSneGaCrhBg1ebGcZq+dPc2Ivn+8hCEsGggSxR/Ej8kTgeA9nPlZFEwWP2QYTQnCOFITRcX/mYkquhndLOPXgFRi3eYx5WXcvjVhjnidXUnil+yMN0l5/3uaqykPrIffhehHzQZDOGi1boMDZMLclm5oUsH/
 LNFsk9n1
 faT3GyflSks6MgSJO7w3XSfsFlulJyKOBxUcAB1Y/Q+TOVdL7mLxn6lybaKKE1FtduhFE6aTgwqdpq24jQZI5gu+l4PezJaT42ScYHStO7zJ7J3TCnPaW55k7QFX8nT/dBimNr2uluEZ75FuLXHOrFvX/8N0lR+btGCVR2nIHISyukaCtfYxiYC90Y34Y0MUHLhP1Wo+PHPory8n3Jszi/AA2xaLhoGTc4uTI5S+0dmOSWriunRtaZWFrcw==
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


