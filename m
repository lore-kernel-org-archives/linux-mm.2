Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B960F3382D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3C16B009F; Tue, 17 Mar 2026 05:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB496B00A0; Tue, 17 Mar 2026 05:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D15F6B00A1; Tue, 17 Mar 2026 05:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD366B009F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:46:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3660C16050D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:46:43 +0000 (UTC)
X-FDA: 84555075486.13.25B2F36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 069D54000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:46:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bOif3DAX;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=tubEf7PatcBCLST1sp8DnjkrijJjrDkIz425IiFeXiNDcEjkxTOMJl67uoiMz7od+oKH65
	D/10Y6wLbEpdLoYZSb+3QEjOx7L7xUKDvSmAEQKYKTkli7OExktNS77XzvcFy/0WKNMdT3
	b+7P7RtsAJisPwzYtksNTBJUmLekGh8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bOif3DAX;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740801; a=rsa-sha256;
	cv=none;
	b=nneSbtv4nwFcXfrZkDyvMUDEFz2KWKxUAbpvDEcHfPyT9YA4W9xat6NY3MmxU6BKi4ljTz
	kjYx8T021+XZkkeLLTDGtZlCkc6ksrO3O+5HQv5oKvSvCBWGm3hQRZ+dBiDvs4HuD3sSRO
	HQfZHhHRMfjnosRWnIWw1WXQErfyYTY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773740800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=bOif3DAXM8ddqiC+hI9C7TkebepJI2J9VAM6B9OQL+52XkF2ZsfETCFcRnL+2LJiemZCBw
	XZ0yrhcCsAyKLe/4GQivJ2AxVCEYr3Rn0ywi0hYlqwNEH0IPml6V77TYPReG1hmQCuuvnY
	Z8fuAQG9qrppX81aiOOMoUK/3A3PHGA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-0mhKkR4OM9-7BSVc9bVC4w-1; Tue,
 17 Mar 2026 05:46:37 -0400
X-MC-Unique: 0mhKkR4OM9-7BSVc9bVC4w-1
X-Mimecast-MFC-AGG-ID: 0mhKkR4OM9-7BSVc9bVC4w_1773740795
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66D4418002D0;
	Tue, 17 Mar 2026 09:46:35 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9935C3000223;
	Tue, 17 Mar 2026 09:45:10 +0000 (UTC)
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
Subject: [PATCH v3 5/5] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Tue, 17 Mar 2026 17:44:19 +0800
Message-ID: <20260317094419.1429259-6-chuhu@redhat.com>
In-Reply-To: <20260317094419.1429259-1-chuhu@redhat.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: kJkz7A2F3RnVqLcwm2l7qoUjsFcAIIPJInSPH3G5Ei4_1773740795
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 069D54000C
X-Stat-Signature: p6mcs6r79aia7egmaw34ios8p7axshk9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773740800-758316
X-HE-Meta: U2FsdGVkX1/IjWMcBCgDb80bNluuIxlZOFI54Ga3D8WKy0bI9A+WdHz/2Q8/8vei0TOPMYN3czy0G/awiydhNMa2Qx090arTMFystCg2d4SKD+yzMcCAOfMBBWQg2iOtJPTsMC+NQrjTXMOw7lbOhad3P2fvf+D5Fh3htm3ZvfWRhqx5JlM+VIQfEiWD3gc6XS6vDexgMpvUPTSF/K6BjwkG/8bL5UXdeSjwEZss/fTv76RDjWXOIIXqXQOoZbqrzv1SDURyJeHr7XJuKIMqUSlZzJWaZRBDpiZ8iNk2vTyIEkeTjDw8tJhK/K7MD5Lv97wpsJqq84QLo8YXmz00CK+FRkWpB78Ov8Qyyvqo7flx/MecW2f//76SCCDnn3KSgFAVqt4Ry6A2NGhRo1jM/d47rHCqd9GwD3PR4Alx7wA5/Df5IwgJimoK7lpgW+hd7/zXEwe6bEOzioIfWBBueewofTv9Qm74a+inr8ASi4Z+t1d5LbtfAzPeYAUfMG8JeSvLdfzbPbmoFkDaE2sK1ZAm5BzJX/qtlL1AG0o0/Ea4zTyxZSu7rxq/WXCuO7oWW/vDSBzw4GmWL2z2tGpnB8/o1LzVQtY3E6/WciBc4F8XtBCquYqohxwvs6k/xpmxNCxQysMUgOC1WG6zdHPKm0xnRWReWJI2BfimwmoENBHocj8JsHo4HASaYQZ1M9TfU1zqvpLbQogC64vjFVymic5DS65/RKUmscPTbha1hR3ZMwhVQFYwHS7k8R0hWHKmQSBYjcnorxjD6bOW4VEcM2pvTb15raXF/Gv6PISbkJOXfzlyvppYhRX6suP6XVMVph1GMiAWwI553tMC1laIIOo+d58+NE2WuBrfDWWOekteSopRXbNByp10tnRBYOaRQNR9MkTWq0ObHsZ5QCRPpHFlqZlMD7AzshZurBk6V8DW+djO4VO+qOSGDiBM6u0nAhwoxA+ZK+ivERgHDHW
 E0nbuooc
 YuSZTkVbuLdsjCmK9OE0avi43AhTzV2StDQnE6zsRbNarPguFP0bNeVv0m689glvkDe+lHb5hkMN0pAYPQ1CD93A/jxOElC3PMuYTOj8UI2e+Mr5KaSbItxh3Hq7ILZ9xtNttt0VleCzUYJBQl4s2fHcxef5iFwPxfSRmY7yK5yoKriNM3QDGU1Doh7A27GNPP4L0CRY47ZGiECr9ZFjWKxbP6iNl7h5sb4gYFa2uiAvEOQqu0i+r8/tCVVdyGwY1riF3vjB+85twTiIu95eyEZOklshfkwDHcFDL+pTqoqsr0v8luOgrWYUpGRdm90tQ8TkeeJ1Io1+s6+KLjur0ytbk2H6Tp8eshV2IFnmAHwwM+BZtO/QyBIzgZp6Z9jPC//AtI8nDpY0lkHlhuXl0IfgCjdYgCAI6RhxO1DIL4nvY0eJGAbiUAIyEkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test requires thp, skip the test when thp is not available to avoid
false positive.

Tested with thp disabled kernel.
Before the fix:
  # --------------------------------
  # running ./transhuge-stress -d 20
  # --------------------------------
  # TAP version 13
  # 1..1
  # transhuge-stress: allocate 1453 transhuge pages, using 2907 MiB virtual memory and 11 MiB of ram
  # Bail out! MADV_HUGEPAGE# Planned tests != run tests (1 != 0)
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 60 transhuge-stress -d 20 # exit=1

After the fix:
  # --------------------------------
  # running ./transhuge-stress -d 20
  # --------------------------------
  # TAP version 13
  # 1..0 # SKIP Transparent Hugepages not available
  # [SKIP]
  ok 5 transhuge-stress -d 20 # SKIP

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
V3 changes:
  - Add review by from Mike
  - Add acked-by from David
V2 changes:
  - Move the exit chunk to the front of ksft_print_headers() as suggested
    by David.
  - Add reviewed by from Zi and Lorenzo
---
 tools/testing/selftests/mm/transhuge-stress.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
index bcad47c09518..7a9f1035099b 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -17,6 +17,7 @@
 #include <sys/mman.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
@@ -37,6 +38,9 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	ram = sysconf(_SC_PHYS_PAGES);
 	if (ram > SIZE_MAX / psize() / 4)
 		ram = SIZE_MAX / 4;
-- 
2.53.0


