Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98BAFF46139
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE076B008A; Mon, 23 Mar 2026 11:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0956E6B008C; Mon, 23 Mar 2026 11:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14F06B0092; Mon, 23 Mar 2026 11:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E563A6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:18:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B6581A0BCA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:28 +0000 (UTC)
X-FDA: 84577684296.09.9AB8057
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7AC9DA0007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hmfz+7Er;
	spf=pass (imf25.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQi3qtwRaACcQNZ9FduWctTgYVwSEXXVdc0PJ95pLn0=;
	b=b34wwGwYZM1xIG7DVgEfAVx9ffcy4aKT+VjN2kf884Y+pmebwc3lskaPkYkPT4LmfUQSHf
	IYe1+xZpDKZfvaX9g7H+JZmbBKIKxLx7CSSVrw5CYGSvvz4rHiYZVg+GUHq1wb6KUJsmpt
	PuDyg7+rFYfQY4vMna3s+G6uG5hqALc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279106; a=rsa-sha256;
	cv=none;
	b=J/hUDY/fbw6QCphImWQlLBoZXgVuNfNtfhc/jTbmVJuxzSktilD/0e7IjD++FXHG9Wkurp
	mhTONsqsp7xsfUyqbta9B9gXpc1wLSoN+wzPWluKnNlPF9MLMe9FcazLkc/buOvLls8HAH
	AemUzHEoB3GSHHy+9+bp4313CGYXZyY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hmfz+7Er;
	spf=pass (imf25.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774279105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vQi3qtwRaACcQNZ9FduWctTgYVwSEXXVdc0PJ95pLn0=;
	b=hmfz+7ErOpFyRAY8aAMAGs8YMImdqvv7wJe3olvmcO+v9UdKSQTeXLwk7UR22ZnatT8Me2
	n4t679xSFcmbKZeP7Yh8Q//kFBos+nPdQ2fZwywiu5sVxawyB8NH7Az9u1Z647HpAQQNhs
	UtE+l2TePT3HylbyJIIhvJq9kuL6Q3I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-89qMUu8HPeSoFDs_Z7h03A-1; Mon,
 23 Mar 2026 11:18:20 -0400
X-MC-Unique: 89qMUu8HPeSoFDs_Z7h03A-1
X-Mimecast-MFC-AGG-ID: 89qMUu8HPeSoFDs_Z7h03A_1774279097
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 828451944EB6;
	Mon, 23 Mar 2026 15:18:16 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77E2A1955D71;
	Mon, 23 Mar 2026 15:18:07 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com,
	Li Wang <liwang@redhat.com>
Subject: [PATCH v5 1/6] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Mon, 23 Mar 2026 23:17:48 +0800
Message-ID: <20260323151753.2576137-2-chuhu@redhat.com>
In-Reply-To: <20260323151753.2576137-1-chuhu@redhat.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 9Mzs5NIIfF2lZMONCyU5SCK8KVEkKUOQ-c9Zi_GNNxA_1774279097
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 7AC9DA0007
X-Stat-Signature: 514znrc7ccnmsybndtzcgmnpthuay1wk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774279106-683012
X-HE-Meta: U2FsdGVkX1+XEE89c6tSzvV4Fo8vP3S3bc23rWzkf0B01HlE7UakVv2jVooI8qWh6N6keaXdCCBYzz0mo4NEeYL9F1p+qtuzcRtS/LZN6f8NWfyBcF3SI0Tr1h/3VgY18xbuiPiT80KbAaCH6tgW+6qJsvAe3ezu9gkI8eOEBsJBOvQwfAp1ri3iWy5L2HmvBKrXMAWByf6++tpNjgeJVmnTvAGKJQemxpDW1gl2fj2g5Ro417uMV2ca8nVhqpo1coe4XY5PWe2GUbcX5SibETMogcm3OrCP1nqmcx1GEznTvpRixQHTTkuDSS1ktf9q+rfIi8uFf44Q3Zo6v0Ghhbx+MqahIdSuS2xPCstCZA1ogBmg9ggg+Wb6ExO6QNaKpvDYyBma2xXairBEytvXjxFpRbbFcuV1k5YSmQqb35UygKOhTxzIHy2lFE2KDDVR4nV/xhvB16rSMtuRR8qlX4xJmq1pGs7t/eAUSX/Q11exXDY5Xhi7JzwJRbaSg5XwvqlNbEKGSWluioZG3Gzw+Wg8d6rIh50THMVChZr2aS1MknWyLWkyv8zLX2xrkp4WBgOjsJrSnItNYEpvMvlMTSkX2WVmhBrvBqR6hByBgwDUrqWRl8UKt4ocaQZIUgNcoApTfJ9HCrCUEqpE41K63xeHMXo0GT0RDA3bW9rKunsyYa/q6OX2DczKwxYld2WVZdoHz+yZUTeLkDLSFdtkCgJjjw4Nn+ja1zJI/VwifcTImoBQ5aRsVBa+XXrMmU8nZFb9kCp1Ng3jW2KWhb3yZjuu8gTj+f/MRzUFytU0KhmJrhnfx5og5QLCYo/aPtXi3NlnD6K3vl8qDTeyBhi33n/+lIzfRyGDN/fDfYRCwqKuP34BaMdKFEu4dlSXGPKEpnbgDZRSph2sXP9SCYAJ2TgwD/Ivy9b3H5nwqHlXLbjH8+QH1L1T0fbKUZ6EaCxZmuta67+raEZ3WAiscoD
 2/F2sLT8
 ZI6T4JgLfkZo/AX6aF1wVF7fagqMBvKRpf1Fs3S5OmlllVV74gzUAbxgy19X095gK6DPssyCauuVBAQk+Na4k+qcy0NYmezKat2exow9QnfZCRlSX6GztEnQhxX76lPM2lb7GbpGFSFhcvQ1yf/gg+tv50R0mCCtHZXR1113tm/Tmcg6I4f6OqQsMubwDt1NXLPD9nXnXsXzD5tWQ7i6FjRog/fR5joBVfXfnD5sCgo3zw9BdJmhD1JWKjgiFy1AmQyS+EZ3tKXIkBHeFoSjS0yGV5qscKYbG5Yljb5C4WkGScYGiavZ4owz7/uh0MKHdXgt7KFqvXZdf1EUXBv7UX9ktJ7ZPHXwZTCLFJGXchS0IwEiZMSmR5uvACJDd2YfdV1vLIFOidzg/Xxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When thp is not available, just skip the collape tests to avoid the false
negative.

Without the change, run with a thp disabled kernel:
  ./run_vmtests.sh -t madv_guard -n 1
  <snip/>
  #  RUN           guard_regions.anon.collapse ...
  # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
  # collapse: Test terminated by assertion
  #          FAIL  guard_regions.anon.collapse
  not ok 2 guard_regions.anon.collapse
  <snip/>
  #  RUN           guard_regions.shmem.collapse ...
  # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
  # collapse: Test terminated by assertion
  #          FAIL  guard_regions.shmem.collapse
  not ok 32 guard_regions.shmem.collapse
  <snip/>
  #  RUN           guard_regions.file.collapse ...
  # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
  # collapse: Test terminated by assertion
  #          FAIL  guard_regions.file.collapse
  not ok 62 guard_regions.file.collapse
  <snip/>
  # FAILED: 87 / 90 tests passed.
  # 17 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0

With this change, run with thp disabled kernel:
  ./run_vmtests.sh -t madv_guard -n 1
  <snip/>
  #  RUN           guard_regions.anon.collapse ...
  #      SKIP      Transparent Hugepages not available
  #            OK  guard_regions.anon.collapse
  ok 2 guard_regions.anon.collapse # SKIP Transparent Hugepages not available
  <snip/>
  #  RUN           guard_regions.file.collapse ...
  #      SKIP      Transparent Hugepages not available
  #            OK  guard_regions.file.collapse
  ok 62 guard_regions.file.collapse # SKIP Transparent Hugepages not available
  <snip/>
  #  RUN           guard_regions.shmem.collapse ...
  #      SKIP      Transparent Hugepages not available
  #            OK  guard_regions.shmem.collapse
  ok 32 guard_regions.shmem.collapse # SKIP Transparent Hugepages not available
  <snip/>
  # PASSED: 90 / 90 tests passed.
  # 20 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v5:
  - updated reviewed-by and acked-by
Changes in v4:
  - use thp_available instead of thp_is_enabled() as when thp is set to
    never, madvise(MADV_COLLAPSE) will still succeed by design. So a
    failure in madvise(MADV_COLLAPSE) on guard region will verify guard
    region denies it. This is suggested from AI.
  - removed the 'Reviewed-by' and 'Acked-by' as the code changes. Sorry for
    that but it seems the changes is a little huge? (1 out of 2 lines)..
Changes in v3:
  - commit message: update the log snippet with where the fail happens and
    add the '-n1' to the command.
  - fix the 'false positive' to 'false negative'
  - add reviwed by from Mike
Changes in v2:
  - add reviewed by from Zi and Lorenzo
  - add acked-by from David
---
 tools/testing/selftests/mm/guard-regions.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index dbd21d66d383..48e8b1539be3 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -21,6 +21,7 @@
 #include <sys/uio.h>
 #include <unistd.h>
 #include "vm_util.h"
+#include "thp_settings.h"
 
 #include "../pidfd/pidfd.h"
 
@@ -2195,6 +2196,9 @@ TEST_F(guard_regions, collapse)
 	char *ptr;
 	int i;
 
+	if (!thp_available())
+		SKIP(return, "Transparent Hugepages not available\n");
+
 	/* Need file to be correct size for tests for non-anon. */
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);

base-commit: c369299895a591d96745d6492d4888259b004a9e
-- 
2.53.0


