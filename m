Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCBB7105A587
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292B16B0099; Thu, 12 Mar 2026 07:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AA06B009D; Thu, 12 Mar 2026 07:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C5F6B009E; Thu, 12 Mar 2026 07:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 019336B0099
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:26:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B28E1B6D7D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:26:47 +0000 (UTC)
X-FDA: 84537183654.14.7C348F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 95B2F80009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:26:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gc2hK4Fv;
	spf=pass (imf30.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RS4GMvKlK4/Sj9p49EgJ5m59kYkjl/i0vUA6l6Qn/oU=;
	b=Qp2xG3oUpb1vGyV5GZ8KcM31Y0ix5Mdqdt+3wSUpDzRsCjcbhlCOKpEYhJeAMDzsQf0VrO
	SMJXcPpVdnd8tjNMb8T6lwnq56qwRnzltqB10hRw1zl5OefzY3jL+ss0WkWaqOxQ2V+YtU
	N6ICpNdpBfkRdQJinChhWVjQCm7e1LU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314805; a=rsa-sha256;
	cv=none;
	b=p3UQtAlW56i6lQlkqYV8OIfnyABfsU9XGbO4KzIFUcfzZgxrdzJVm8cafhdjlCaQL+l6H6
	S7r/lst709/qXZTQvoJ5FXFXtNZijfwIzDblDpXbzlmWInZpNgxDEn4p9tzxTOwlsY3ZsS
	sV4/nDYeS8NFYgyAV9Jo+Glckh2xiV0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gc2hK4Fv;
	spf=pass (imf30.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773314804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RS4GMvKlK4/Sj9p49EgJ5m59kYkjl/i0vUA6l6Qn/oU=;
	b=gc2hK4FvPOd9cmfROpRhkXt7n+xp1hXDZOQABnG0PNsLYh4sen6i6tK6dJ+MSnlqxGssPY
	IC3xSxyyR6CWvRpADaat/MkACuNVR8KRcXBGisydDqK0X1TqX5VkxTgAxW8Ch+a5vuKSfo
	j1lcMADn+J6c2z0bVM/j0GnedF6TFWI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-bmMlgpqgOG-GIAMR6SmlmA-1; Thu,
 12 Mar 2026 07:26:41 -0400
X-MC-Unique: bmMlgpqgOG-GIAMR6SmlmA-1
X-Mimecast-MFC-AGG-ID: bmMlgpqgOG-GIAMR6SmlmA_1773314798
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F7021800629;
	Thu, 12 Mar 2026 11:26:37 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B6031800351;
	Thu, 12 Mar 2026 11:26:27 +0000 (UTC)
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
Subject: [PATCH 1/4] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Thu, 12 Mar 2026 19:26:08 +0800
Message-ID: <20260312112612.633138-2-chuhu@redhat.com>
In-Reply-To: <20260312112612.633138-1-chuhu@redhat.com>
References: <20260312112612.633138-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ww4JPxgjKaUQ3gV2zuDD6v02wHHzDy2ujTKlI2C7aEI_1773314798
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: st93qir5fxgb4dfz8dz538qi6pfuztfy
X-Rspamd-Queue-Id: 95B2F80009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773314805-591308
X-HE-Meta: U2FsdGVkX194+7un4JgmvfPKUONgaS88aAWLJrJeVzIJJT4DvFa/ZliBcvImwd9pAF062b23R6kSKXHBmIhvd4lMHbFTqukHdYpQccTkuV4WdHSYlZo9eTZhSVksrVn4jbzfKrgKmQAaOKrhcypB+p5FuUAD5UJ73LVtvfkX8eXcQwEDyUeUgTrFngO8p/HLdDrOI1J61YYhpTX7g8gg4eOPWaveFa12T7Oj6nMe5+xlb0Zck1CUJDCPlmMwiFyhJ2uzvbb+yq48pNABbFRFcX2Qf4St0ulbLv+remUXUUuVUGfidl4dhnRtrPPGFlW/qaGw+9+0tBwcsEt+CDXNuITD6tV9GnF+lDFoOVHsuWCVSAsKSIInWdFiZhrRkw1xJoiiWH8OmWhX5jmuM1Ad+BCjyVhFzv3sOu8AJ/UHBBhtkh2JFZBdOc+qzKQOYBegy91z6N1glg/XdVaAEDqatDWgyMvi1KnsBOpX3lCu1vfwXdEUHpSOzrqggXUWfFkXUbtqdmAlXTa3gRcgYsyeKRY+5u0DUWDELTyVhYBfX5VsXpQCDgLYzDd2PPA+qV8dXKkze2oZITN8qnKa3rjSSOL12NSo+cAiOkYQJhBEQFqQMk2WzOmJvv5kgtTchnjjNLTxFmkx9eDw7k80CmT5bv0yB4O7sAAKawJTtnymzOPZkmNvk5dyn93IFBXmxMD9HKKj2YUBxkJDq08/jsBDoS3HYxuwSjaqMYy+7qotY6ctp4Yo5rma8XUqBOjni9Av3A0Sm+Zngxr6dMZm2HLEhcUGTKPkGYpUZv00fbSOg1g/oaExZun55Ko4P8neI/pOqjb27zfU1Hm44vflDPM8SVRT/UctlKcV1m3i/v1ANACtjcAZ+FLLQdIbE0RiLSx1MEOJb7xhXTrUskcdJOV8I4u57vNLF6T0d00nkGyntVO0zcPYhMxjJ9kY0Qy5hf01otS+cS7CZ1Z7EGRbS9D
 6kThQ3py
 bWaz5HVnmdKMIhupveqBJbV7R8TtCVsdm6/v2cRij44inG7iYK9mxTMTWewV6a5PSU5Wt1GpANAiMErl/qKhj9vd7Fj32j+s5QG9MBb9AitMAbg1sl9Rn+yVBh1vBWt3jUJmSUcIfJEkmWFNwX8fgAMt1ULpjzDwkW3tuNByHfgoOEBie7YjxpWOC504BP5ZOgBHiiyR7NAJG+VgcOBYvl5Z/labmE6gWh3JXXusp6+sKfXDPQG1qNulY7A4qN4tXLCFE6V5cuskyjI+U7wAAwBUU8cdlxCyghLnWR/FxuIqsk6PCjwINJb2Tkn7CPTXqRX9agi0Zn5hi7872ySNg3/doQPtPiNmXsa2HhWTc4UI6Jh/5uKYDHRiBMg==
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

base-commit: 80234b5ab240f52fa45d201e899e207b9265ef91
-- 
2.53.0


