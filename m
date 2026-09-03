Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7BC7C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9C76B00B3; Thu,  3 Sep 2026 09:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A338E6B00B4; Thu,  3 Sep 2026 09:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922266B00BA; Thu,  3 Sep 2026 09:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5046B00B3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:53:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7409FA0550
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:53:21 +0000 (UTC)
X-FDA: 85172593002.20.A0FCA68
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 675F940006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:53:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ProqK7T9;
	spf=pass (imf27.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788443599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ocqYTA6ofaCSgTGdFtWQkcHvU9NCr+KZm7VPt6V+Zt4=;
	b=ioJGZOSNKx1MdmiybUE5iCLFHLhqD2/OdoUv6PMrPa7mgJ/3GqqC7U2y6u4m6f3OJsQHAj
	vON1BMUGVaIROkrg+uZzrVcTe5oPq8bAgzLvGRVbZu3zHpQFNN918JmxmgIZQiD0Jl+6KW
	c8MHps9MHAhpcczxwv6j7VnWJHiSe20=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788443599;
	b=SEp4rlo2y0l2IsNzpxUoKn3S+YzqSqhvlizx9eryhpM+zICrdeok80wXxjdwFhA55DD8WQ
	0aatbIEPcikcsURkN6vPX/59B5m76+Hpz8H0UJAwPI4noMjkPGvtnrUHR5gYU3dpehopFc
	B/mONHQspuAapWnyVinsG+qYRHiyxm4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ProqK7T9;
	spf=pass (imf27.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5COp11tZRoN06Ewjs47lpm9CAHf1L73x0BPSB614Wpk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788443597; v=1; x=1789048397;
 b=ProqK7T9pFb5BfRGKbjWo7Uw/ZAZVlw15lalAAmqYl8AjK+2OGVSQDJ+Z+Ic8iOwcpXRgjlz
 zwpePtDJOpUD/VdG/4YDjzAs/o46x9gFc0nKYM3zJwUR8y9uaj7ykuH89jhrmISlFxvrta5+4y0
 q8wBvCuU0610lm/0p5pg8ry4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8502ee06491f0eca;
	Thu, 03 Sep 2026 13:53:17 +0000
X-Mizu-Trace-ID: 8502ee06491f0eca
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: remove unreachable returns after ksft exit helpers
Date: Thu,  3 Sep 2026 21:52:51 +0800
Message-ID: <20260903135251.39593-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 675F940006
X-Stat-Signature: snyi4re46hqftiydzhmp6fc36ciqsuad
X-HE-Tag: 1788443599-163404
X-HE-Meta: U2FsdGVkX1/hw8jKqdj3/PEw4IeROfHeqDiDUiLyUiN24OcQuQ9D+NEXnE+Ik8CWjspexh4W287DW13UE/XNIuUjbQLrg/9rdUuHGrqu8EpTJgS0qfMvb5+IfSSgAqH9osEOD1choQJYnd7zBi2hB5NZOCE9V5RlKdy9KF9dSQ2sn9aZst9bexE2r7yMve0xlIwD/fDqHAhQ/rI6uhGeQFY/bpZN9X5ac5r70C+u0FaEXnJs2UUnHTzeuxPTr6kkdGPdRYgKWEim7o/o271Q4ajkxXAdCrz9UoXXPZXGcj4tlQ1ZgyOsZhXfjZwEugQGDodcx1EJ/QI7zulRMhNKEtR8Nt4P8XUUpwQGRI6TYfIQdAQadyhBwnX8bhkSH5SSwuQ8976LQhgbVFnAqoEZou3wKr9YFKSKWhqpR1hqGc8XQbJ9yDyVX3yurUsu3C4ZuEpTMK2tAmT/IzAzMXYB1uUkYp/DxIEveMO67coD+iqZpSUZryTIoTjm/ACA1D5vAkwyB8HkrARuMH3n/ZHeViROGbCNJedmO3Wd1ZGCEFV2e4+1IEmMd/y32YlNrhHloEdSDwnct3LP+TJDxaERqPQ2DinVBRD+Pj195IZVRihkeDKT0g5EozznaUIrQ51oIlt7+YDShmW38FOAEo/IrAL6vBGwcfswqWtr0h15KoqA6A6h6L2/hXKr1IHtJuSEDdM3vtN3qVkiLHyJHlhhAdoJdalKvDm6xMRAPcQSt8uzyAx0Av5SGKZnOBPdoZkuNuC6NP4Gyh0sTHElFE+ump3+LJnTNm8xMyE2+MclUHiafkhVqDt0Ptf4Ray3b3H+98G+hxZ2Nvnvrs0T6wISTyJPELvY/I0Jai2kMk8plUA3CGBtWWDtM/fyj9SowTy1vKX/8OH2aSn1SRassAkjrD6D0XcZTgkR2zxkzoGnH6+PmHTz/gU8F0wW1h+n24xboZcN6ynmgZ+u3oaD0uS
 XzArqN6V
 GRcmvdoG8TCSYOhw54e7Jdh9KhYwQyqmbWsHtOEWz0rtefhTC3hk46NvS0Uu3Ym2k1Z7QknJZQHZIY81+XLnm+VutdHe7ODdAuSusHaOZUetoziRjwVZgMgaM6KobY/zZ83yhLyaDGMULZanguRTBkga6Od3NOp6iQ0hRdyjfQHQUOpg1fsNtY1uEHeMT/+FZ+iUtDpPamNXsO4lPrsMWuLpBK32bPS9AcIcU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

The ksft_exit*() helpers such as ksft_exit_fail_msg() are declared
__noreturn, and the ksft_exit() and ksft_finished() macros expand to calls
of them, always terminating the process via exit().  Any return statements
following such calls are unreachable, both at the end of main() and on
error paths of helper functions.

Remove all of them.  No functional change.

Assisted-by: GLM-5.3 OpenCode
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/folio_split_race_test.c | 2 --
 tools/testing/selftests/mm/mlock-random-test.c     | 1 -
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 1 -
 tools/testing/selftests/mm/split_huge_page_test.c  | 4 ----
 4 files changed, 8 deletions(-)

diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 45b84f7b364e..1960635a953e 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -269,6 +269,4 @@ int main(void)
 				      NUM_ITERATIONS);
 
 	ksft_exit(iter == NUM_ITERATIONS);
-
-	return 0;
 }
diff --git a/tools/testing/selftests/mm/mlock-random-test.c b/tools/testing/selftests/mm/mlock-random-test.c
index 16294bc7dae6..58772914fd79 100644
--- a/tools/testing/selftests/mm/mlock-random-test.c
+++ b/tools/testing/selftests/mm/mlock-random-test.c
@@ -71,7 +71,6 @@ int get_proc_locked_vm_size(void)
 
 	fclose(f);
 	ksft_exit_fail_msg("cannot parse VmLck in /proc/self/status: %s\n", strerror(errno));
-	return -1;
 }
 
 /*
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 74bf79a5399d..f9c728ba96a5 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -556,5 +556,4 @@ int main(int argc, char *argv[])
 	}
 
 	ksft_finished();
-	return 0;
 }
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 86a603692826..c01d227d7fd6 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -101,7 +101,6 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
 fail:
 	ksft_exit_fail_msg("Failed to get folio info\n");
-	return false;
 }
 
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
@@ -548,7 +547,6 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 err_out_unlink:
 	unlink(testfile);
 	ksft_exit_fail_msg("Failed to create large pagecache folios\n");
-	return -1;
 }
 
 static void split_thp_in_pagecache_to_order_at(size_t fd_size,
@@ -711,6 +709,4 @@ int main(int argc, char **argv)
 	free(expected_orders);
 
 	ksft_finished();
-
-	return 0;
 }
-- 
2.53.0


