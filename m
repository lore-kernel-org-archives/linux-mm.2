Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21385C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7F36B008A; Fri,  1 Aug 2025 05:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F6B6B008C; Fri,  1 Aug 2025 05:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA50E6B0092; Fri,  1 Aug 2025 05:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6C86B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:28:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A81C1A13C0
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:28:12 +0000 (UTC)
X-FDA: 83727662424.03.3CB88A3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5674E40008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:28:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754040490; a=rsa-sha256;
	cv=none;
	b=A7B6l1U00FaM0Yb/uZWlQxq8pFaZMi/iKW3O1o959Qa2l4fOube+vnsOPU56scq5UVADcQ
	5AvBwNd9GYhGmvfqC8Dq0zjEME4W9P4+NuTbv9fODphhDaRUb1fBizzhLEv/W4Y/OectDf
	jFTZb8MDTkHKqDi2z8YXDYB65MXsXio=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754040490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=X3OyRbnd9tzDjFgTDuxacn2jSWdNOiudDnCqVY7X/Ro=;
	b=SfY640LqYzudViFAXfwljiC+JMxdTu4sOtcH6pN1movBWadcjodSN2UNI45lwDqdJeJnjm
	5QPrngRSClBcraL/2CrqM75qOGtSkHh9WFdBOeFhr/92gbird7OlFloFDeNSsg8U96oq5i
	fDG3d6SJ+uapPmpxa7XXruNzkoJ4fo8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CA46169C;
	Fri,  1 Aug 2025 02:28:01 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BEE833F66E;
	Fri,  1 Aug 2025 02:28:07 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: thomas.weissschuh@linutronix.de,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2] kasan: disable kasan_strings() kunit test when CONFIG_FORTIFY_SOURCE enabled
Date: Fri,  1 Aug 2025 10:28:05 +0100
Message-Id: <20250801092805.2602490-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5moohac593sbdr6bt9toyx86p6mgsg14
X-Rspam-User: 
X-Rspamd-Queue-Id: 5674E40008
X-Rspamd-Server: rspam02
X-HE-Tag: 1754040490-720600
X-HE-Meta: U2FsdGVkX1+3B5DL5tlQHeKwSbMuCexSXwJcERf37OqFIDzHxRQ8AQj5u23QEKy7Tejmb/Yv64Kt5Y4XK888uxmPeMb4LdkfKj+RSE3JBk97rZqTbCbIp74W9Ogz2ZDwe8eRNSZqFNEPuvGH2sJ6I6FpqOtjJ2u7EqAfG4vh9VDTGWrr9RkuUi+cCio4JNCcpcbd+/LmMEkP3GkuYQPKTwkIxkxacEV/d/jJb0+86DB4OrrmjAPb1y3cKvAjRLQmcSo/Jp+1pcXBUg1u1NLVc09dwh3DZEgxwN3tMkSMEJRAiyX8oCWDDtWHd9KT3jTosKahUtnENPyWuh8G3CyZ8oB/ysYu7o60CyuROYkubyGWzK3vJodP2PGNiPKDfCym5KtcZC6jiSpjKtPi8Vq6cqQKCkNR7Yh9oVnGqlqF9JEMxQVi4DmmcIZ22DhvqLqvXL3feE3uGkr54XhAkWCs0OasJ69S/oVJvzgeFr4PlfJ0PlxzS9hygUU/kaaxydUpMcn/mRw22l0ONrS+SU5JAmbAgeW8/L0XYX3N12aB1QZH4E4fNLOtxkNyPtiQBmki1YwkysJKkTI4cGnr23kBw/qSx8EXoXtlTLqtXdkLgqbXdHGCMzbYDHavPtKJKFzTec1l+S8vrkwU/z6c6mhUdnMH4z4KqEBKfCKeS6xNFaTPlV/0l5yaWY5eFDw+4vGPqY6w4drO15Ew+y+bD7pO2HZfoxLbrE0rJjo2Nvz/62gz26In98/wFnV3P4q5Sr4F0SFQ3t/Ca8CDlSybBhD10nT9SEomY3FAEh7fss8DA6D3bNREsOQk+JQL05E7ZkHPkDtNCcZK1ukzj0F4oD66lySB6VUheztHMKFdv4MzJq8yjUjAF0GkO0XBO7PeuQjsl7NSJtnu7i/yg81bhh2juouqdpwBkRKrUUqHWpr6aT109TJrW1nH6/Y0vbVo6CqeTWV0qE1MV19+mLalleX
 jbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_FORTIFY_SOURCE is enabled, invalid access from source
triggers __fortify_panic() which kills running task.

This makes failured of kasan_strings() kunit testcase since the
kunit-try-cacth kthread running kasan_string() dies before checking the
fault.

To address this, add define for __NO_FORTIFY for kasan kunit test.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/kasan/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
index dd93ae8a6beb..b70d76c167ca 100644
--- a/mm/kasan/Makefile
+++ b/mm/kasan/Makefile
@@ -44,6 +44,10 @@ ifndef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
 CFLAGS_KASAN_TEST += -fno-builtin
 endif

+ifdef CONFIG_FORTIFY_SOURCE
+CFLAGS_KASAN_TEST += -D__NO_FORTIFY
+endif
+
 CFLAGS_REMOVE_kasan_test_c.o += $(call cc-option, -Wvla-larger-than=1)
 CFLAGS_kasan_test_c.o := $(CFLAGS_KASAN_TEST)
 RUSTFLAGS_kasan_test_rust.o := $(RUSTFLAGS_KASAN)
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


