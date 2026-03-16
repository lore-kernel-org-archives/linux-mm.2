Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A572D58B21
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 04:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E71F6B010E; Mon, 16 Mar 2026 00:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B20E6B010F; Mon, 16 Mar 2026 00:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE5A6B0110; Mon, 16 Mar 2026 00:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC5B6B010E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:44:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DD7913C334
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:10 +0000 (UTC)
X-FDA: 84550684260.03.48705B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 24D0B40007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HaHqR/Eo";
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773636248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2x6ia0fOtjNFpMwFjrWEQ0OzFaYrAPdncllfx5wNUeo=;
	b=pT432atPNZ/tk2xpg8aDL4tr+W0jNS3StJvMx5rt9HcJkwKtTA9Tl6oDh5p3s2dS9KTaKT
	Rs3rB/l80dkPMIbVB7R0W2Z8/NMUmfmWS4JWiw/+hmqK05hbg4IXHSC9tORiy6B4wp437X
	FkaI2jupogZf7kjxtSD6/eajWMUoFLM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HaHqR/Eo";
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773636248; a=rsa-sha256;
	cv=none;
	b=WOx4QeIWwpPf1SOIlRYJfrw8Frv+l7uK2OhlJOXd7+VXmTu5fbp68V/6IvDM8tXYUApW0+
	YIAPr2DA4IehkFPoQ9obirIiTv51OiVhbH7USpf3bDlhd5c7rJy8c5/GZ7KNXt/6d04q+B
	edVV5ZgVSBWxfEoCc/NHK8o7IqvZXfc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773636247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2x6ia0fOtjNFpMwFjrWEQ0OzFaYrAPdncllfx5wNUeo=;
	b=HaHqR/Eot0h8R12X3ueWptHIpHET94nEuLrfDctB9IbPn/vQKfr9OHhk999mX17atvvz6D
	xyZCcnvYfvN3qK70v4Lm9rivIcmJQEhgHnWRIAX+AdOHfSW//EqrcFhOz2zRK8q6HGUKw6
	OkjyYK6H+FZCJy1PXP4yLjLt/RX2Iic=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-V2YXIBYvOvuT3hqnEv4IEA-1; Mon,
 16 Mar 2026 00:44:02 -0400
X-MC-Unique: V2YXIBYvOvuT3hqnEv4IEA-1
X-Mimecast-MFC-AGG-ID: V2YXIBYvOvuT3hqnEv4IEA_1773636240
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 907C119560B5;
	Mon, 16 Mar 2026 04:43:59 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B3571955E75;
	Mon, 16 Mar 2026 04:43:49 +0000 (UTC)
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
Subject: [PATCH v2 1/5] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Mon, 16 Mar 2026 12:43:31 +0800
Message-ID: <20260316044335.1390608-2-chuhu@redhat.com>
In-Reply-To: <20260316044335.1390608-1-chuhu@redhat.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: ru5-eFdZUxUuvfv42BYbetU-KHPsbl_1kCA7cuxuc0c_1773636240
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 24D0B40007
X-Stat-Signature: w7dh6njojgjyu7pn468ktb5r4h66wgqa
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773636247-739404
X-HE-Meta: U2FsdGVkX1+BZGQlz/nAXoWKfRM/ewPa30X9yQCblKReQsXoAA7Z0pfFZKDWtAt1SrKSlYWOPoK3Huu6rY4M2o/Sszj+05nCBrntzoeKgjPPbvwAyX9weJPh1yR2w4Z6CFz772RQGoK4/v4ezpf3Z4x4o8eY2D7K58GWIgMgLGOuRC6l1TrhbgW3uGodKS4JZ6ON/MUObmuspRxXry9ExaL4Wse0N8iG9Ja8oAbAb1bLSEKxssU9Esfe5dVjFPdDV0GxF3EgxfJgsFG7xfcjPkny1jJP5oQFSda3Dfm1c2g94T6qzMhYe6/aREtLm2E3ICZaqKIDjHi7l4sK5cw8OmnbdWPV6DnFWcsIEx2kYtU3BMVAUVNv6ocz5SmPz2EDZUMnkRoR9rhYTk06DRyO3ExiGrCaPJ/RVKUqwvbJEeWemda6gNLdQP9gzRZ2rbbMjUqRnJNoLqxdmODTyHw3kVZN1M8edPojiu8qy9HfJdpLW09T+omHeEngXW7E3bNGoteRYg33bx6+oNUHPdZlGC2Ht02RNLfXyOwBl9UZdvqkFcAxcXelGWvN+wxyZ3vMOcLpbSYU1mxlIXtP/eSfrH/MAu+mgvt93jsuY7AuulYzBSl77KfuwZujXN05bMbtXvCXhXs09gJcMQTRVFVQ3X0vfLuW4CnwPnzwVytwJE4w8r7ycfULkwOJiPgfExV3BE9MD5gpDFMhzgfCA9/PTIcHm7E3WsezF0YUfs+cvleOSP3d7R6ZlOmROryYE0G46rV3I+I694YpTHwrr6kTmJWp1ToyEFmFh5bBUlWCe9NBjbeJyC+Nk/8daY5QHSuHX1BOG+57nHJiFCpDrvKxud6C6CVPlLIEHt1INAIV0GOZNS+eAfNVW32NWR+YtK4oSl6mkUZRIp1aUTEYkvmFajfen6+XP/Mbm+r45Po/8BV+JKscDdVy50d3vVbdpl7pR4WxIFx6w0qmyPSgUMo
 dGOV9mRh
 lsJVpjkwtUL4hA6svS9tdAIqYpPOSrtqVQ7y63XP1ssOcSMbG3H/RX7E5n4JHO7EcdZWHkJkVLfHXfYfuHHHVvCWwtHRsOO7Inml36fS1a4csnNPsRaaHX+xIT/p4sRf+WVrxinrX/+4+r7wm2dDDVXftFat23lPO8LNmRkTvY219cBY7HF2YcmcCQOJUNbSKfTVDDBtPZmLHvog7vinzSJuYS4VyZaN6WW0qxI5eqjxSyNpHiEtkydVVBYvRbyAw7YTU11ENZEq/HPXi0iUowkBhYYTq72bmD7OdLR7WRaFLMQz9So1ViI74Qm4JCNcsj5H86PZtrNArum5mx9WAtGw8/s5ZeuaDaGW0ULwUXtgu1m0PIC5DeGm0WOdOhthpSTInjrUNr8tGRFw=
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

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v2:
  - add reviewed by from Zi and Lorenzo
  - add acked-by from David
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

base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.53.0


