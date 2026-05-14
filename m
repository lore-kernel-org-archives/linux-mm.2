Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 844B5CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27E56B008C; Thu, 14 May 2026 01:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8956B0092; Thu, 14 May 2026 01:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7DB6B0093; Thu, 14 May 2026 01:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB0BA6B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:06:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AF78A04D9
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:06:52 +0000 (UTC)
X-FDA: 84764840664.20.A3020B4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 662D618000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:06:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b673L7Bl;
	spf=pass (imf24.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AW2IdWoE2RSqUG7Yesj8ulGHUlii0SF0cle+4odB8qo=;
	b=3qatEoMNapGJPz7nHiB09lA4jdgdwh4VNWk7uI88aluM4s7wSHZpDgwC85ATkUoLXMzRQS
	N6Ano6AL1gO8fMMVfcqaA4yYUq0cKrlbwAfmhLf7Td+gATSlKVvw4Gj1qOSIOF1PhQK+AQ
	wKGhh12mPhNuho55aew7EsHYLcuYst4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778735210; a=rsa-sha256;
	cv=none;
	b=lsRpf4j3lgkZtv2DyOEbB2p0lfn48N0zZz52hGT83Fq9jls8UjlWJR9Yey7NVeWJcpMxs9
	izvfa1Xrs5xaH0J7ohGMu0fmaanDpcqZO3IfupmPnaGt8Rn7iSQT3kfsvaVSSJ4IllEVOn
	Uixq9/j7yhgtpPFIOgcxSUAHEVPTnRk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b673L7Bl;
	spf=pass (imf24.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE14F34E9;
	Wed, 13 May 2026 22:06:43 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.197.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BBDE73F7B4;
	Wed, 13 May 2026 22:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778735208; bh=bamNddKdXVgxZqutIBQo9gEmJk9kTncPd0EXZfEgTdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b673L7Blg3xg5L8WNcH7Zu5Qed2gjayMHfkv11+YttJp8eNSGYY+dy8l8+bWF+x3d
	 GlV5mp0EmcKddlaO/ogQAMiO2Nji6JgHdJUq+fZ1MI3eFkgo3FhjlM0/0ipeiPA3gT
	 pRAhQbybLcIUmVcUZ1v2H5Kk8WOLYxSe6HEv6GMA=
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
Subject: [PATCH 1/7] init/initramfs_test: wait_for_initramfs() before running
Date: Thu, 14 May 2026 05:04:49 +0000
Message-Id: <20260514050455.2954509-2-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514050455.2954509-1-justin.he@arm.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 662D618000D
X-Rspam-User: 
X-Stat-Signature: 9ycohk77wqcb4mpqnmcdf6y9huwasad1
X-HE-Tag: 1778735210-482225
X-HE-Meta: U2FsdGVkX1/uzY0067bWE0bHMn5LPRo7IJnkfQiINRO25n7LYGBnDn2DsZbxjiRJBTBZh3bxW8f3sp5yYugzc45aflBECGUNyyrOQshXEf4eboiWGbZzIFYY664R38cHWI8T4abQixwnsQ9su2LgPjPlFq9z0CcqDASc5ym6Kuc1OE7PpPJNdb7zGEdGdTs4vS7fVY11XbpZlghklHq9cQrn0xNmI4lH3Uu2anyT6OplBlE+Ip7Ovv0RZgtmN8ln+tAItWWGzBGXRqierYkpdsFSaZFm+stzgaRAispJK0g2tz9nS2LOJw0V11kyM4nElU2LY3qM2qHHcSGWdDwMe3wFM3h4zuaD6abeEkDyf+bjvTvYVKVMlxdpZJ33JcC+M0xQQXjrTMuvKCSu2bazIlhYs3XMTKyOYDMkL1mpIZZeYbhkQ9FgEhoZ2Xkr9j/Rkhzj5fuC8vjzJutE5bTD/Poj6Rtxq/Ron+SFCC6Zpf67bqR/NtVEy9AdbS+qkeFGf4wlzsfN7KCh/VIcaHkmR/E2yFwdcvdR2QBkGD94m/uSFN5gRQVogP5uhPOj0VNp2xaqmRFQsbKyxGOzoOIdxmp0hIfbZTIT/7KXwCcK1hQ7PJbzU0eWxulD4rr+3szuiw90fpk0Hv6Q+sSNv3eJeqcVIdRM4OjR/TXDCVaopPxolOEWADkiOsOXal2XhTBAc+PfuAg1tuK0A/PLX4b2INGa7l4W8LZwnT/pBcggZqWCDvW5vgCqPhXi+vObmfzLzM9/c+kc18fFeJjXTw80CgOfH+VXh22SCHNwPxcaSuC273Br+EZjcENG6QYuCm4D++cQA0vpFtY7goq2qvnWzRE2+udV5LN0Ubv9p10pCaEGTWJs2B/sqvu41CvMGh1OpkgKwQJtSP1xjs7i/Uf0+Cg5eNQXZdLal5+31HbqrfvCBkbV44qbPCwkq8Xu3QAAKW0rqOiTeLpDqKf636M
 viN/DU+n
 jGfT80/PN9SxH5oAAs0081vI4KEslxnzJRP73TdCjLtnzAfI0d3C+bUSXXGOUjwDp9FVKX/jtU6j2Vafh+pFfzFem6GX04Bul1GkbWwWbniX/qzimpw3JX44dBBz33f2ZtbqZqwUuUdnQCGXlobYItwA1owNZZOZxkA1yhuiE5Ju3SkxFnoPBN9/S75fLsK/UZkMcP2va9ZuIvbrdk9tgp5ku6I0Uyxwk7XKQ0xxL7nlUgx5gvfppto6FokvTOfZRgsrlojBJcHcpkpHrd8gpqv5gdZcAcm3ezN+hAHvryUyCw5re1KzS6/sadBld6JHvYjDGCs9qESinCUtXjlpjMcSN279OYUWG2AL9tDjrIfgd3lof2cLkSjuz4ieamkqRGh0VR+umMLZVavRXzoEcT7frYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

initramfs_test_extract() and friends call unpack_to_rootfs() from a
kunit kthread while do_populate_rootfs() may still be running
asynchronously from rootfs_initcall. unpack_to_rootfs() keeps its
parser state in module-static variables (victim, byte_count, state,
this_header, header_buf, name_buf, ...), so the two writers corrupt
each other.

On arm64 v7.0-rc5+ this oopses early in boot:

  Unable to handle kernel paging request at virtual address ffff80018f9f0ffc
  pc : do_reset+0x3c/0x98
  Call trace:
   do_reset
   initramfs_test_extract
   kunit_try_run_case
  Initramfs unpacking failed: junk within compressed archive

do_reset() faults because 'victim' was overwritten by the boot-time
unpacker; the boot unpacker meanwhile logs the bogus "junk within
compressed archive" on the real initrd because the test wrecked its
state machine.

Add a suite .init that calls wait_for_initramfs() so the async unpack
is quiescent before the first case runs.

To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-fsdevel@vger.kernel.org

Fixes: 83c0b27266ec ("initramfs_test: kunit tests for initramfs unpacking")
Signed-off-by: Jia He <justin.he@arm.com>
---
 init/initramfs_test.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/init/initramfs_test.c b/init/initramfs_test.c
index 2ce38d9a8fd0..eb76f63f302e 100644
--- a/init/initramfs_test.c
+++ b/init/initramfs_test.c
@@ -3,7 +3,9 @@
 #include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/init.h>
 #include <linux/init_syscalls.h>
+#include <linux/initrd.h>
 #include <linux/stringify.h>
 #include <linux/timekeeping.h>
 #include "initramfs_internal.h"
@@ -510,8 +512,21 @@ static struct kunit_case __refdata initramfs_test_cases[] = {
 	{},
 };
 
-static struct kunit_suite initramfs_test_suite = {
+static int __init initramfs_test_init(struct kunit *test)
+{
+	/*
+	 * unpack_to_rootfs() uses module-static state (victim, byte_count,
+	 * state, ...). The boot-time async do_populate_rootfs() may still be
+	 * running, so wait for it to finish before we call unpack_to_rootfs()
+	 * from the test thread, otherwise the two writers race and crash.
+	 */
+	wait_for_initramfs();
+	return 0;
+}
+
+static struct kunit_suite __refdata initramfs_test_suite = {
 	.name = "initramfs",
+	.init = initramfs_test_init,
 	.test_cases = initramfs_test_cases,
 };
 kunit_test_init_section_suites(&initramfs_test_suite);
-- 
2.34.1


