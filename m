Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFD82F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655F06B0093; Mon, 23 Mar 2026 21:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF716B0095; Mon, 23 Mar 2026 21:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF4C6B0096; Mon, 23 Mar 2026 21:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4F26B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:33:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF6F51F682
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:33:50 +0000 (UTC)
X-FDA: 84579235020.16.09DC937
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 08498C0004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:33:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jGE6mYtI;
	spf=pass (imf22.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774316029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIhrDdzZ3tBw5GbRB95XiBB10RCe72TOzM2l9ayovpQ=;
	b=23fP6Sha9zqJYL7H/IaNGTRIm5msRGhtSNA+aZTgv+fORMGoHpTjKFfeOGeqEaipWRKq7z
	SPYxYzGny7zu5PC0Zm9BZ9DCXXhh2IbYx8owG8XuF+mkUcxidsAe66v4g1ETj+qBndbHI/
	NWHSBiMwY189+yPgN1MsbO+X7FwBoL0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jGE6mYtI;
	spf=pass (imf22.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774316029; a=rsa-sha256;
	cv=none;
	b=WecJ+nzZ1TCkOEFVH9WGrIclnZbCwvQx2XSwmXRpdZ6l7z7oqbR66ctfG2JToXFoyYdhob
	mI+xuUJFoeXm5+f+yLszE/ka8C75hueNWznUZRgYE+RCchXEcyMRzY0uMG26BCtRaF4ltr
	suVLquIBFQ/YvTIkRkOIHBYU6B2nIKI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774316028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tIhrDdzZ3tBw5GbRB95XiBB10RCe72TOzM2l9ayovpQ=;
	b=jGE6mYtIOQarbL9DAZyon8MXtzSqhdydJ9VBK1T/CMdmKu3IwQvK9LWg9KptgPS8E81tes
	qqNHFHDeQ+K//MLKNbXK03oceYo4fdCmKin8/zHQCg1fXmCAeV/wXb5z1+O64iB/qTarda
	cYgfkZaYBiBz/opg4oi+rJxRRGqTuQ0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-iNX3zPmIOISUJyTcM04kvQ-1; Mon,
 23 Mar 2026 21:33:42 -0400
X-MC-Unique: iNX3zPmIOISUJyTcM04kvQ-1
X-Mimecast-MFC-AGG-ID: iNX3zPmIOISUJyTcM04kvQ_1774316020
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D96BE195608E;
	Tue, 24 Mar 2026 01:33:39 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19D691800756;
	Tue, 24 Mar 2026 01:33:30 +0000 (UTC)
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
Subject: [PATCH v6 1/6] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Tue, 24 Mar 2026 09:33:11 +0800
Message-ID: <20260324013316.2590422-2-chuhu@redhat.com>
In-Reply-To: <20260324013316.2590422-1-chuhu@redhat.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: JEJ4oPfh1wDK343l8xt64kQyPtw-Vv-g6J3YlWackBw_1774316020
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08498C0004
X-Stat-Signature: u5fr38nhezh7jf98j5ykswqso7kua7kp
X-Rspam-User: 
X-HE-Tag: 1774316028-492374
X-HE-Meta: U2FsdGVkX18jSyFBPB2Vpdv7LTByzWo3+8eM5AVRBTjhK3xsK5r3vuEdx949PNhd+PmMsXUYuI40/lwcey4CnxV4rITL4e/Ga5voTZEfIIdCA6RVMSp3rBw/I1vmU0mNFlg1WiPFiDVgfRJMspBZznhMYQlnjSC1I2JA/4elBrZvNkSLIeuii5rv6eNaNSGVAOi7W6DP647100208DsZ48dXhGK43VJdn4/pxm/uKzfaY2J0oIC+TfERm6DPvLqDTml4MpSe1prKdNL9+1o4OwNFmFWKwWgBT1DZ2gvQQb/e66tM0NfbStlF7BHi2suQ4H3ABlY8pjv1pauHf1NroFjDSowp7Tg+UON5lCXmWYwxF4oSahYn4QTwvMQkVzKNNpDQ8LDrpmfOt+CDLPW85+Ve0N6FEahwaAzW2w9R/J6q30k6ua2t2YnudeVEIPFfzEvLXjc6zA6HQs5gb/Q3g/scGVgt6x+Bj479F67Vxfy1cLo0nUWizQLPYRUbRPKfLa5lGtFrc1gBEJeBOy9Is2fFgNbI32ywnVZSfH+jKYfY1CbuyQWiLefOnjUw5VyUP5qNRPrPYQhOuWCrBvybwop0vvfYPKICy4cbRWJLxo5O+plX1ST5hZEy8KvOXQGz04DE8ERCANS/9jpspfvH+Ap/8a6g8wWtQB66i5vFnms3FCo/kC40jBZlWgWzrJEKeFBGzMfTEZgJXTrM/Do2MbaACLAsKitVhl7dMm1Kxm+x70/iRHugAUtTkKONvQFQwkZeZ1Kb+kGLamgwKtbJFYVDVKU6GGSw7Qq/Ni886KsxMQFORIqC02yl7mBSsTvjt2PvRi7L6+/Jc+4A1qIF+sjtxeF7Hh3IwT1OiF5AsHHwekTvo67qD/bwdKcRQpk+6gGx8dgRfTmcxngC3gKp50VqNF/Z8F6KOlMC4CkRyPTx46MIl6hSD2OMS1qt5Vg2XEP6qhNx6lLlR3UIV8G
 oca6toPj
 /JgcnA53pT9tb+xB0yCroQqRRSCAt6F5uChTA1iTOSFBNE5muy7fmE3zFzgEa2az+EmyiLFcG1yyxnKIqFDL2BbKIoV4KWgg0P7x3ahf5m8uGbPCmOT2CR34ZRD0bst8zzznv48jrK3pjhEf3IEt1HLRang8Cer6A9q+BVP4qreUV+BNiz/URwyW0ajpzrnZPsVHcUzYMuQx43ol5BYlol7DJ35r5TQK3Aoev+JpXqq4a5U5tfu/VGVOJTIUlR+cRLLlQ9YSw9myxholrKJqxClE+SZSuWkSIjKt1Q/smnFSTOD3FE4hm7nPKHnwamQizP0tVxv5GEBQPtrSklCNKtVRZDSQi02JsdgN+Ln4Fx4OMZ1rWx8emxkB7MfJrUk8WVAHeankyXjC31q8=
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
-- 
2.53.0


