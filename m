Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE905105A589
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6786B00A7; Thu, 12 Mar 2026 07:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0A26B00A9; Thu, 12 Mar 2026 07:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC936B00AA; Thu, 12 Mar 2026 07:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB426B00A7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:41:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9E481BEA8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:41:00 +0000 (UTC)
X-FDA: 84537219480.25.44A7D83
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3F7618000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:40:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HxMeyqa/";
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeeUzwD9xvrgBKbuAuUTCtoCEVa+RZ+bhwLWLOTaBdA=;
	b=6NLQCrtfsusnu2nuFaN8plKDbj1EmecpW/ZZfXJ1pRlsF5uewbDUG8TSwqY5q/i71nBEKh
	GPN706oOBtvN866Z6OfT6iretDYJI6K/HeKfkiKtOgJf9b61HRMXTLKAnqvFEnLTH6c/fU
	SC1PdS2vGmm0T+JNFvXLCqqqUZvwDLw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315659; a=rsa-sha256;
	cv=none;
	b=216x7MA38dC9DNe2FwLavS7XrkcPU8V6uTyWQ+4dXEv2qM9uC9HJyCzoUf8tpSyCllp1Si
	y4KvTNIY12a2g2A++hUEoQPnHO4lM4uafWxqexC3tKYpynQ1YZSfQgt0KnUwD0u4M5tVjq
	Cn2Nw5wLn5wuVlKnrn7rxwCIJSI5fT8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HxMeyqa/";
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773315658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LeeUzwD9xvrgBKbuAuUTCtoCEVa+RZ+bhwLWLOTaBdA=;
	b=HxMeyqa/IX3XTc9ggsUiTQdKLli7sqWc5fTBZrVe9NbQtOOw3XiFJVTsXSivwx5hDJCxU9
	Ph9IYCQILdxA+jUKadVSnDsGC9eXRyJpqyB4TEtiJBzvBiYH558Kw4mzWNS+QbutfN5vve
	w0bOOoNCQGUaV9kp70UNHOKNt5vI6Ss=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-205-LtDIuIs8PaWgaGruvmlnmg-1; Thu,
 12 Mar 2026 07:40:55 -0400
X-MC-Unique: LtDIuIs8PaWgaGruvmlnmg-1
X-Mimecast-MFC-AGG-ID: LtDIuIs8PaWgaGruvmlnmg_1773315652
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2ECEC18002D1;
	Thu, 12 Mar 2026 11:40:52 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1694A180035F;
	Thu, 12 Mar 2026 11:40:41 +0000 (UTC)
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
Subject: [RESEND PATCH 1/4] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Thu, 12 Mar 2026 19:40:24 +0800
Message-ID: <20260312114027.634559-2-chuhu@redhat.com>
In-Reply-To: <20260312114027.634559-1-chuhu@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: V1VzOrbDTxooMyoCaJUxmi4Mqio4UJ9Nqra1kys3KWE_1773315652
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E3F7618000D
X-Stat-Signature: e3o74k16nh87gbtugy5i9o98hkmok6im
X-Rspam-User: 
X-HE-Tag: 1773315658-761392
X-HE-Meta: U2FsdGVkX19lZYIzop/CrswDS1747N58QiA8s6vbxQO5Y90CI8aIRCg/p6okVfHbl83JQVpV+2nrts1VqH14UJSBJsI5SDsJeUv5/yNuonQfMvonFE9FtvuIIzkFyW6dgCNcvr0qUj9RNPGSQ7kARYg245nzYpmqtuqT8Bovh71aq+0aTA42OqN/RZPJDEfvLSryj22bPOLIM3RZ56gR0il3pAaZ3aRWNO31rDaCYTAMmoaPtJgV98k6jKVXEStglB9bi1COoAHfNkuNBa8IflDKKTV58UqrD8wfmVqDj/GUuBm/1TYeDqQro4w0k0Y/2jVfETIZRubNvh/unBnbak/jRYmRSg8lQ8IdKiwlgJKe6XYzFlLL+jjepFFZm6H04PsCzwOleVdP6bJP4KlsQhiGnpSRFL4cr+4Z5k5gQK7GBxPG+HGueo69QaUr1tC7f/pD8yhHU8TbSOx4VPWmX4Wp9DParxpBfB1TEI+xa76kHY97/ETaKzO8oUP8OabFi2JRlbjVvcIomYLff/y4WFCCgh4atg24o8h2Q1UvDnetpdnkRdvJH3b4JV/6JeaVJsmhhsXJkQA26tHo24lrIXDQDmbgLJ5yqjkHuHt8Z04Hj0UrrASbKURl9cZcicBodxThXq3umdrms8dfHXSvWLYJTLL+7bv+L3uj4/T7gJdr8xImm7oDXxwJkFGeymvFbbskRrRRqaYBNeVOmDGOkkOzmigQDYLTEiu+RFn0Wlm+WKIqmbvortsYsoktCmSLwDV3wvSva9ehmQUPf+4volfRVJI4mCteLeLgyKfXhB8f6qtTJhO7/VRHP3sRbkxtwqdKJU/qPvPD8F7q6Sudd+5t3ibG6K46+5+dA+c+9pi33WQzUj1mCf5ZX0mB//VjPl66t3+31pfgmVKJjYmmGO9ewWkGPLPzDrr+2+PUtyPvsihT8kJGmlLv7Oflx73+h24Ca2/0PZvqGNMXbbg
 I6XubfT2
 AgByDIkWkG8oHvP+n94eWkc1EiAEMQXOExNlR6EQSJMLVm9wtoFtllb+AqrUZ+Hefx5Ri8/mf6DrfNFjQuylUnV+HPNOhi9XRE/jworX0pJTiRxmC+HsvmfaUntx/SkT0h0rY0sbJsKyHXEiKO9uvZuT+MrhSXxYMQxRqNXrF0J40kyOyWJ96Z8Er+h7X587FRPCWK5NEEfA3wQdDl9yvjPbEN7uFr1MQCEvKO2UI3brvljmMjbHAGr3aHvjzhZIFKGlRZkSteHPeHHR/Ha4Lihp6ZTglK+pLyrLpq+jXwEkNtaOZ2eupjol0KNUVARxsbuhEGIWnJGqtmKZ4OAZXC5KLzxRvcjQl8Rw42dhv5jRzy0Vm/WjeN6+kFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When thp is not available, just skip the collape tests to avoid the false
positive.

Without the change, run with a thp disabled kernel:
  ./run_vmtests.sh -t madv_guard
  <snip/>
  # #  RUN           guard_regions.file.multi_vma ...
  # #            OK  guard_regions.file.multi_vma
  # ok 89 guard_regions.file.multi_vma
  # #  RUN           guard_regions.file.basic ...
  # #            OK  guard_regions.file.basic
  # ok 90 guard_regions.file.basic
  # # FAILED: 87 / 90 tests passed.
  # # 17 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0
  # [FAIL]
  not ok 1 guard-regions # exit=1
  hwpoison_inject
  # SUMMARY: PASS=0 SKIP=0 FAIL=1

With this change, run with thp disabled kernel:
  ./run_vmtests.sh -t madv_guard
  <snip/>
  # ok 90 guard_regions.file.basic
  # # PASSED: 90 / 90 tests passed.
  # # 20 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0
  # [PASS]
  ok 1 guard-regions
  hwpoison_inject
  # SUMMARY: PASS=1 SKIP=0 FAIL=0
  1..1
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/guard-regions.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index dbd21d66d383..897af9c512f9 100644
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
 
+	if (!thp_is_enabled())
+		SKIP(return, "Transparent Hugepages not available\n");
+
 	/* Need file to be correct size for tests for non-anon. */
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
-- 
2.53.0


