Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80FBC111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4FBC6B0098; Wed,  1 Apr 2026 21:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27B66B0099; Wed,  1 Apr 2026 21:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D986B009B; Wed,  1 Apr 2026 21:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFB7F6B0098
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:46:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D28F13A764
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:51 +0000 (UTC)
X-FDA: 84611927022.06.6595ED8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA89720005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Npi382Mh;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775094409; a=rsa-sha256;
	cv=none;
	b=MIxjhxvwQ9CXjr4qCyNhR+ZEubwMIO3FVXRWNzMwDEAc7U9FsCWLQEf3C2VcE7BCf/Ce/B
	u3Ajpk5NTPryFoCCcoWg+D376Y3EdVrOdUMaIxAfQTdtaoH7GEB7N/bIZ2jQzF5dP0Vp2H
	QHHga+Nz9ax6tFXdY93gkH+c68hutgg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775094409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=Af7idCNf/KZZjtfTiCAY27/sZWnnDqi3SY8QX2aRGKSaK+1sm9oc+L+PXxTVR2nwNTWVrM
	XFcY0pSE9XHIPZIIoocrkCjZJCIhwRZ0nF2ZvowHKjKJoJgXgQIWtWezgnjcTsH5XaWHL4
	XoUZgYsS1IdqpOJcQyDAvThK/rdpizo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Npi382Mh;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775094409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=Npi382Mh1HkX60nQRMOZ2Y+fYQB3PRTJEnH3iv0/RU4M7qJDz/yO5PUaSXmTof0XvOk9bg
	MV+1BaRD5qgPcY9gKbhRMw3aSaSBIruXQ0pN/2Q7FkBpLeDuHyYVSTo6M2RH7gvsmUhJa0
	i0Vkvc+SygqtW1H0O3gctwBdcJFZpwE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-147-ikX5ZTKfMBSHvO7QSL9muw-1; Wed,
 01 Apr 2026 21:46:43 -0400
X-MC-Unique: ikX5ZTKfMBSHvO7QSL9muw-1
X-Mimecast-MFC-AGG-ID: ikX5ZTKfMBSHvO7QSL9muw_1775094401
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D56C19560A2;
	Thu,  2 Apr 2026 01:46:41 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB5E219560AB;
	Thu,  2 Apr 2026 01:46:32 +0000 (UTC)
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
Subject: [PATCH v8 5/6] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Thu,  2 Apr 2026 09:45:42 +0800
Message-ID: <20260402014543.1671131-6-chuhu@redhat.com>
In-Reply-To: <20260402014543.1671131-1-chuhu@redhat.com>
References: <20260402014543.1671131-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: kNeYep6ysvuehG3z6WXAgxCavu7k14z-DlbANqNhi2k_1775094401
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA89720005
X-Stat-Signature: h8rnstit7uxhz8d3j58yqr6x4u636kg6
X-HE-Tag: 1775094409-134330
X-HE-Meta: U2FsdGVkX1/QFViH73rszN/0HzHj2tpWInzB/vf49Lhev3Of+RxaYYGqu3MTV3DYyyB5eGb1lZKgpFlp0esEvGOetRbYBKl6lj4dLuxIgu0UfdOpTzwv9bdqmBAqMebx+H/86q8xAAojIcbcsrm9trg/WWZN/BrEXj87Etb5LZzWLtKPJcdqePgnM8n65Vaa/ojyIukHtg+5s2Cj6Qdiki7jd3ffF4MfruR0ekb22C8fL3P83f1v/+DkAD3fuPN5/ax5EYUloUKj0wbhnV14ti4CV0LFWzKxp0UnRxRC+RCvyPU2wxiURqMa5fDhf4JY7AwIWvQcxdstLiDpbgZbWzVuuEUUgs6K7cQaoPnwz+08a17BaD7gSiYIikbdk8DelV+MDMUz9H3xL7YXh2dLchyCLnuv9d9M8ryV1TbeujGowi4SDZQK9HNzqHt15Zn3MP1nC3qOv9O2+w230FucY4YpG3fhkoLYTQbvgUJl954ud+S8WJvd0uzd9rs1NRVOdjm1S1ogQR82u/+GGnDORRHxnOVIc0jhy77Q/0aTW0HAQzNPWjd+GT/KOXhwV+26qPFirGqvbMTFO6D6KmcahDuInHxXerDPKFf9ofakqaIZmmzifcaBd0mOM/0qVgVL3sPzVz3ofeP3a/YKkOALmVafaloiUluuix0UQuy2lQcDHCB0WbTCdUk9FVtI6KqOd6HyVpvA0gtHAwMcXPcE5H3k5vM3WZhRDctkA85S6Dyb7dNdJzTW3ViUtC3d8a4EtUCb0xgSnJVOoBvmjksT6iLqQrltcX7d4YKBfV+U1NzCk1hmIdY94qYgyryrLsXSDAquEXHDPN5LYYf9TIlQIXPuRpdz8nP+WJDbRqyoI+ebH+ruxtZNZ4yqaQg0PMAOh1Yfoyl2MNOpjxCD6Nhq6sUeAfudbbnkpI944ouP6hhsY84DxPzDTCKiTDm4fawptiG4LKBDhbAGSkxxAJK
 LuU4DYxk
 MRr/2WXLcsbLz7Y0yt670zWbob8zP0oau9sRQgbOBrQri8PEWHTBc+UOcJ8pzmzjjpMM5bMbC16fseTRVnT8Fuqccihqw5y6nqZebeWhGgmsQfbKFvu6XZLKclaxet6UD9sU4hRWmTz96COvzbC5/xr7heycdJO40x8pRujf9uE/snkWcDEdRRcbiaOofOHzEwYYnPPivP+nhHhP/a7CFSMkjU181gG5gK7vnFr+MCnrSAgmcN/mzpsQGEB5ui3MJujtaGXBh4TCT/0+5wTvjxIPp02G8mOkwm3SUcp5XZ/XNrbC8IlB0omR/NbI9LPh4tj6ZKftZHyLPkwQoOdFCttAGc583Swxzi/4TnFeKs9NOzq99+6yukUDg2EwxuJ83I8FwhKSGZ5RNdO1hWdUz4R1cwqetRkarT91jXvwJoy6D+yBRYpo87SihrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When thp is not enabled on some kernel config such as realtime kernel, the
test will report failure. Fix the false positive by skipping the test
directly when thp is not enabled.

Tested with thp disabled kernel:
Before The fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
  # --------------------------------------------------
  # TAP version 13
  # Bail out! Reading PMD pagesize failed
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1

After the fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
  # --------------------------------------------------
  # TAP version 13
  # 1..0 # SKIP Transparent Hugepages not available
  # [SKIP]
  ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
V3 chagnes:
  - add acked-by from David
  - add reviewed by from Mike
V2 changes:
  - removed the {} in if block
  - removed the write_file helper rename chunk, as there's a new patch 3 to
    resolve the conflict with thp_settings.h by moving it to vm_util.
  - Add reviewed by from Zi and Lorenzo
---
 tools/testing/selftests/mm/split_huge_page_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 93f205327b84..500d07c4938b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,6 +21,7 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
@@ -757,6 +758,9 @@ int main(int argc, char **argv)
 		ksft_finished();
 	}
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-- 
2.53.0


