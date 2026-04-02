Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51283111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3BC6B0089; Wed,  1 Apr 2026 21:46:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAC36B008A; Wed,  1 Apr 2026 21:46:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3056B008C; Wed,  1 Apr 2026 21:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3D26B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:46:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55C9314030C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:14 +0000 (UTC)
X-FDA: 84611925468.03.F02D07A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 763E240006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eInln+uT;
	spf=pass (imf17.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775094372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/pPSxcnZYo2SMuy8vaLW5s+T4/KTmPmuksnl9sWXmE=;
	b=2CLXLcfB8sTY8OYhEnTF7od2YMPfox0AIldmBLqisq1hnU/ERgyv4ycX2oMtjspszDCu1B
	XpxtVeB/osMKdsOXOORznUONuanry5+VNQ9m6T8ip/lD8cExNIpFw6tV8Z9/B54ZOTewMq
	FoCbkAs9weZfwyyp/UAYFFF6mQGr6qk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eInln+uT;
	spf=pass (imf17.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775094372; a=rsa-sha256;
	cv=none;
	b=sNI1hWaiqF0lovmXlDKG00u2OmwqchgrU5cXnRw/N34CHcc7flQfHTTGqgKSIt+tTVPUbg
	9t5PO20WQj0Z4t9SRK6tig4qi/JdqLGqynlokyribEAC6XnfNtdcq4RNHYWf7LfkbvsRnT
	l2qc87lxDNBHtcTjbbVcOo66YnwimCs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775094371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/pPSxcnZYo2SMuy8vaLW5s+T4/KTmPmuksnl9sWXmE=;
	b=eInln+uTfuMqs3fMmqcdrc/5mhLRPYd7lQwnKnJMASDVoDxmu74Mn2msVLOmCWOnPqOYEc
	ZqA93HEAjrUGKVtrqKpWCrz+D0dMUURZTQkhUF5a9yfUhuRxZNRjaAKbXs+GnMcbrGjGcH
	AJJZ2mZ0o06W6yPFeq9af3x/OyL1EQA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-5YxuQcR5PYealfh2_AOtGQ-1; Wed,
 01 Apr 2026 21:46:08 -0400
X-MC-Unique: 5YxuQcR5PYealfh2_AOtGQ-1
X-Mimecast-MFC-AGG-ID: 5YxuQcR5PYealfh2_AOtGQ_1775094366
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC19C1956055;
	Thu,  2 Apr 2026 01:46:05 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCF761955F2E;
	Thu,  2 Apr 2026 01:45:56 +0000 (UTC)
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
Subject: [PATCH v8 1/6] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Thu,  2 Apr 2026 09:45:38 +0800
Message-ID: <20260402014543.1671131-2-chuhu@redhat.com>
In-Reply-To: <20260402014543.1671131-1-chuhu@redhat.com>
References: <20260402014543.1671131-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: bUk4nH0X1FNNgYt_AK1IocnkuxWycrXRgGFj4Y2l7ik_1775094366
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 763E240006
X-Stat-Signature: 4sa5mmxff8ya9fqi9shzq7k8bdewbcuk
X-Rspamd-Server: rspam06
X-HE-Tag: 1775094372-169459
X-HE-Meta: U2FsdGVkX1+MKHSX3C4UiuhUmPSdL/O4LrubVZtecgUtU+UJrR9QRPwYZYbMUZZFhcwQIfYXvaXHc0IUo9NAlVrYBz5YUcfosKAVykCAZ9AhYmFkeN3w/LEjkgfm/jUPSZHs4b2A4RXlXwQ2s7GMNTBuKIJ+eQPrh2wnfMNpgWjyEEWFHdY16oqaX/ae5gY0oS495UOqXuFI3lc2evsY/lHAoN9w7EyeYSfRf1EX2gjaUFnWiUMwNhnEaS04NVNyxJY95kuPa1sDV8TuA36ZhTO1g/9TOA9gdVbz/nh0DR4YGd41jlgk1BgcVMTY0kDlMfyOt2FtPg+a1fDH74y3p8/RbFeCa1KjefF4SZCTFvAitBTrCEGBcb2BzMKl3OPKUCaVHuvauNPT9uaN6orx9pETnb38LN55mkpF8t9IW0wYT+g9asPGa4Y+7+lfoL6RGsYD+hzIab+nJuh+zglipiN185Rizpvx6vyJquqn1QDK6BPJX2r1x8j9B99e0yzYwO5dbb1GurwdOcSK6Wxy2faSISWk3J1LGt2WJ7CtzkwkyNtGkpTFltcE841IrNb3DSQ9REZ9X3nozuT0AElCFXFcbuGss/8JSOhV/nWvC2Rn/8nIxMw17rP56sizzh5UMxjPgVEfIWXXX/3gXq5abxYu0oA7Y7qYb3bhGfu2xZ0jSkFb1oRyxKZIUTqLJW+FgcubtxTfCtfvlnmH9sepcB9H278tBQFVfQUfb7BUQ1nfBS4W2lkbdj+Wbjw/H1C69fedabhZNA3uy9/JoFtottOCp0cDk5XsR4P1TSqIdAVRO4gFmbjEaxCsG3iIMZDpA/Kw18nYNt88+QK+F7UXyU+8dUia1I8X2PK9rMaBcvHxuqjM3IdTcINdPkfi9v3XHaKtVAIKyXfnsdkkNjrNIY+s4B+cRAL5YKxhUOlSwRek7W2tpoF6hudi8VnzMhh0wmt9J5HQHTlpCJB409/
 MscKGa0C
 yVAiGqN5Hq9ERtDDcTx9hRqval7Tgq+Y8sjsD9cJoyzs4wWQYViBaX7UmQ9cIbheFyr2DLrlpw/PtMkoHyyyyYnVrpp9mIf2nNN3veOBaXcScUV4YxnNIOrkAo20S1SToQPyGwWqFSmgies6ZDp9fsOPeMW54Tl/r/a0/JMTdMx9qU4/0kbTAAg23UB7ufLE7dg9E7wtcsA3bzRIVp/sM4KDezg0pctRPF7ZodTtAUbRe/Zpx7oCQCx+WJV8zOeA4Ix4SCNlv+4cL5mCI2/Yn61uElTIH07abt9LImNEfEOA60ATH74VvieWy4wla++sYSKjOCvHw95UPir5EKX29FuKenpO8zGwCaJA+9jMulapcATTetOoTt54NlSLFL3SuAN1jvkPohkl8Qs8=
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

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v7:
  - Add reviewed-by from Lorenzo
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
-- 
2.53.0


