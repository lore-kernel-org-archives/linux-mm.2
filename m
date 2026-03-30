Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949B4FC97F3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047576B00A1; Mon, 30 Mar 2026 11:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E9D6B00A2; Mon, 30 Mar 2026 11:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E764F6B00A3; Mon, 30 Mar 2026 11:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D49266B00A1
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:16:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DEE3B9FAE
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:27 +0000 (UTC)
X-FDA: 84603080814.27.C3A7C17
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id C2D3F14000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XQz4/fJ/";
	spf=pass (imf26.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=5Zjz7vKJHzhnDUWf2il3KvpluiNjWGgOoo4Pu2vvRl3mn3x5ZlJSluYUKZdUF3DBjUGMpT
	qM7arTNChTHZKoEyAbbrPsV74efLZTzka07+Z53sN7b+kAzKnlCv15FGMedtN2IDgUcoYi
	l1PdipV6BdHo5n6sKALlKBj3640+sxs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XQz4/fJ/";
	spf=pass (imf26.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883785; a=rsa-sha256;
	cv=none;
	b=KT+I+ggrMWXv4/a2x7t1S3bBjZq27eDg8pTxjE9eNNmLKHmJ/Rd44dQ2ZimtiNL80LL0PG
	rg2NEQQSB/tZB38t0U2lWPSEJABBiyCV5uSeHo+IjrVervrFa5WTlvFH1Hz4lSm78K5XQK
	cy0Qsqb2P8tvT/DTOX08rfmxf9SZBGg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=XQz4/fJ/8Im/L9Ny0cI88lbp727bqrVXiswL3ivLkDwUkYR2J+KppdEWzToCwEdKzRvuXU
	VhCRdurh5AOddNfYfVI3BgG99XTk8eh++QswP/qCHLFMf5FGdbZpemimAKJXDvfhrTyVwY
	tVNsCjngEUMS8kGk3+ev07KuhHkLoAU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-qA_E6RabNDW0a_EPyd5sZg-1; Mon,
 30 Mar 2026 11:16:21 -0400
X-MC-Unique: qA_E6RabNDW0a_EPyd5sZg-1
X-Mimecast-MFC-AGG-ID: qA_E6RabNDW0a_EPyd5sZg_1774883779
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4B301800623;
	Mon, 30 Mar 2026 15:16:18 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88E8F19560AB;
	Mon, 30 Mar 2026 15:16:09 +0000 (UTC)
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
Subject: [PATCH v7 7/7] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Mon, 30 Mar 2026 23:15:03 +0800
Message-ID: <20260330151503.670415-8-chuhu@redhat.com>
In-Reply-To: <20260330151503.670415-1-chuhu@redhat.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: LZyO39DdXJeebaMNS5GUsCDkrnBrDgZgcoellGcftxk_1774883779
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C2D3F14000D
X-Stat-Signature: u63dpqgwf6hmro969n8q1hz8z4u3iqh8
X-Rspam-User: 
X-HE-Tag: 1774883785-127779
X-HE-Meta: U2FsdGVkX18SlQMJ798cbZbZrPNGgyunLn0LnSr9A0bBRPdU56YIHNjbHOsQ4AM5jh1BNcyzZbtc/hPXJ3vueDXUXdnwzzpWDMrnXrnL+HjkoVmdd1YmR3/J4NoaOTCHNM+PIYNjSp92fQQf5nMGl7I8yPVj41Ko3Moo+m5S/dvHLMn1lry9P4yFqBuuQF72zEakJR96qcK+0M7H4Oe6WMBELPXYK2zHhgtwpT3tk0b9r3uqC1C6MWSOiO/PLQsThXAKJKHSanNHok714zPmXJphCaqlim8FamSx+ce0Mz4w+1LafQwjlncafn/u8kKFdeqKCs8yRSly4YZoXf0j/Ol0XvhBIdFZOY7OoZKLTkgmvyRORzDjMwDvhHfYHp+abvWw2RcjFdcTSQuZEWyBEJ4Pk7lfXrYbDdTcNjWTiTu+WgbgwqEMuv9A3olBPSLXOyHMH0ZuNf7cOocW0gXmxjE32MODjeoU9R6hcSt7x893iBFQ4MvnMoxljRMfcwhrQ2HGeW5YlPNSMRQisRiFJFpNcFTt1hshfaT6HA4HKNzahnqybrDbgg/1ZYyERAirtFbqBoHfs6OsbpemRTDzorTaSJsgnsi4kAbATQkf5Mh1xkYWwK9aS7i2knZ9CZrJplHahDeM4oKV2uIj/w6Mqo0pD3zjkyfUAknnKSLtCrvWPHlUjUl8d2hzBw17iJymKrOlgIZ+erLi5DQm5kuHEZAxHtYKNl9LnmNSiMzkAGIF12UF2eroLhXuCj2Zcut9NHc5kfEmZ+1VOJY/InGdBS4R8knbqMgHzEOe0oQ7uy2dx6R1R6TNRtnw1OZhs7UgotjUDNgQBxItksufm3rCJEymVgOSIsn/KNo3MXhrBNcY3cZphfU6N8CA2wTLFhN/0ahLs+uooPbMkJZ32o7UexPLTiA4usISC4ZwJrQIWloBdhK27hUCwTBcVPhJJ8jEIBICXbqBcS6ahHQI/gi
 UfKczauZ
 +Sug1wPjetj4sXR8hQE4tPEqCp2ytp9QZQ6r8fhtQbneD3yA0Qil1PXD4e9sBC+c54gHX
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


