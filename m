Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D27109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5D56B0526; Thu, 19 Mar 2026 12:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DA56B0528; Thu, 19 Mar 2026 12:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE57F6B0529; Thu, 19 Mar 2026 12:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC1EF6B0526
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:07:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4AE013B009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:27 +0000 (UTC)
X-FDA: 84563292534.24.158581F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD0981C0019
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YMAXG76d;
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9AAlpSGzxdv8c6CONczdhhLumdRpfeuyMphF9hSKuI=;
	b=AjbdgLLhKHiudALiiNWGFgzZHTxzp8QwRDq2WEdkJqdHNsf/tzCiJmlwRZf8EuKrFL0hU1
	Rg5daJrsFjw0QLo6srhvKOvy4t0KInv6yaElgmcTKjvG2rNvuChJwv7j7lqEOe3OkDlzaS
	U3Lxnv66kUgOGnrXTPTSi+XDL77ulzg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YMAXG76d;
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936445; a=rsa-sha256;
	cv=none;
	b=MRCH5USPioaXkuc6eK8ZlZtm0eq/bp43We5b0cJbHWkqEr+DjYZsP/0ggjYSDoAodn8uXS
	o2WbQxGHiQuD4kNL6mrCxJrl0pHzXK5TFbKljRcLKIYUQKgV6Jjmo43bH0I1DoCc1tLPJG
	4CISjGeV6F+9MMdynNYciEBdZ/tpiDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773936444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V9AAlpSGzxdv8c6CONczdhhLumdRpfeuyMphF9hSKuI=;
	b=YMAXG76dwUEnpvpTMNp5a+vhmTlqMNf5UCcxdTVeFj+oXQrrWlyKf/sfZYz5XQAVCalsZE
	/18Thtjuum4ppbN4Zp+BoBqLOcN7QOUOqdnBDwqswIulkruNrzV0kTy9b6Wer9wSKZicRW
	2Tvj56yfU/hy1ElnGPmBeFMkre7ieag=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-v8jH_6VhOHm2yCsrThtz8g-1; Thu,
 19 Mar 2026 12:07:21 -0400
X-MC-Unique: v8jH_6VhOHm2yCsrThtz8g-1
X-Mimecast-MFC-AGG-ID: v8jH_6VhOHm2yCsrThtz8g_1773936439
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96AC6195608E;
	Thu, 19 Mar 2026 16:07:18 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D2E330001A1;
	Thu, 19 Mar 2026 16:07:09 +0000 (UTC)
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
Subject: [PATCH v4 1/5] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Fri, 20 Mar 2026 00:06:52 +0800
Message-ID: <20260319160656.1480279-2-chuhu@redhat.com>
In-Reply-To: <20260319160656.1480279-1-chuhu@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 4LXaHde-KaWEvYw44NP2sVku7bXdV5sKf8HmFoxT2ss_1773936439
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD0981C0019
X-Stat-Signature: d3xtgwpzm7gmgjnbcxj7h1k9oo1kna48
X-Rspam-User: 
X-HE-Tag: 1773936445-60248
X-HE-Meta: U2FsdGVkX19/B10Gxpl5KJ6I5SU5SaG6B8GBhIKqGoFM9DL22pEIOmC+4WCPh9JH7fECdh6H0HhFL7HIMo+zkNKv0V7xpvNZP2+9agqXLlY5jzBwXWE2LUCiNEzjnuei9sWsSoSs8nyFlUh12fTRyG2KJ5ZAqya5gIQWCJGkDZmRXk/rz0EGBYshICSzuCT2m/tTLt1Bqf7eGOhPuEG9LIOM4x+H9gja3uhvUQdm4LgNmDDuOSFiV6MWm7gv/wP2sdAizgXHE7xZjXET7mfv/QVHYUf0+UATkY4RbkYh/sAsKYbhrC8DnPyeaencc8bTReodF6oKfEHpNxaXXmCbqnn2Ex50qU/e2shgZdEcmr+Fg6B7erfrcbomNW/SWg3jS1dSYG0F9ta/aGUGGe3Zd7LMO8zei9KhyJ70He9ThGgnYy9DL/HQXXX/ygAtge4q5O9ES5ke0jNp9idDVm5GI8yCEycMGNUxokRL7+VMXhngRsOaN3gNoXz6dXw+zJF387+vLsyhCk0rFJFDSQrCcoFWv8XRCQdpQXvOJQ+dt5BGjvFM6TLpIz0nTtygvKgItAx7pHO6CcSXcBIISJluzTAuXm3nT1RM9bhKIGdz576nSAE3JfUFBd0YDbZikci+NXlgykmmkpmbdftNBzEa3m2pp0bmJ2Vh8j5aJj/m2Ttjzl5TNj3AG4LPuNmfTJtIvp1oDqMxrKP/Zn32u/xf1+dESRM8kVqJ0vuL47kZmzg9NxBoeDRUJ5P3Au401viISamepSfPJh1Ts9NFeEmB5SovqiOtnKSuFVrpBYfFkIrpNycPWwMIiNfaBoLmn18WBjppuWT0OYMfQr40wjkYLEulF0Vrc6guE80Ug3hDUdXWiH9cOs8bTTC2hBN09ZY2AVQCmt1wnY1ZTie1zYwGo/u2pCua89SV2zAx5JInY3fFhg/FjuSbjTC2FqME4TaQRJFK/y1wCVkgEqGP0lP
 owzYlFsm
 BSNoxIYFHOaN5l4u1A5hIkcDZGHqqDdR5mbbsEPtbjQRrD9KfLmF4ZqdO1WRSvU0Q+7gm1TQxm1ngfltI5pxIewxuoamaSnqFltYzm3ko/s1MiwOlZcqmiXlGpTCD5bWQHUxZfVBUgvBnNz25QE8vuF4Dfss7XKi3lwN5hCaJXyB1Mksn/C6euFl5o+sfvqwy53gXdEZXZDpKqax0cn0FafSxHppPqYzrq/XALgloSutCpbnMqb8pf/tEkJyhPbMFUfA7YModBXzhERNosNtZjZZCMtP8G4wo2PMt5nCsoIy53djyG+kxmnWgvbyCbbvZsqqiyyp4egBiRT2cFBSFpIyFLffWyjVtAA8uIVTf48hHNqtfdgmz9SPvdw==
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

CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
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

base-commit: 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
-- 
2.53.0


