Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3505C109024D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8E76B052C; Thu, 19 Mar 2026 12:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0316B052E; Thu, 19 Mar 2026 12:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E68D6B052F; Thu, 19 Mar 2026 12:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9CF6B052C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:07:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10992C1344
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:55 +0000 (UTC)
X-FDA: 84563293710.12.E3F5EF7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D0CDA0020
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZlgqAlF6;
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=YxgjvNCT2h4rOirg7s3RqzH/92RWEdOvQDtbo4JXALH39l8o0bE4Sxlmr3xZYg8vC69AJC
	3/2eG9Cy0+5U5GwkJ6YLno+MUikT+DG40F7YtWitV7iyL2+tIE8q6DYjbDbWTBe0Z9Gnm/
	nOJc1ksbUy2u9m8AYya5UEPuFKTpHgg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZlgqAlF6;
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936473; a=rsa-sha256;
	cv=none;
	b=8oox3hjHZCw6E4LBbi+jxbkKRKYSxyDa/cX4SMm2SErYXdQRtZkGzFxM+8kXJoGUIe/3nf
	AnFzX028kmNiJZFi83mzeItZUT2C5NZ6xc60kcvtnJhmrScONp14fLcZS4ZVe8yUhEvRVy
	dbpZYTbLz0DmbMZ/sbZVACfrx9m8vkU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773936472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=ZlgqAlF6OLSCHmnPJKvvKRx+BpuYkvV/pPFftlGJRpPpluHIjJUNSIiGOWgwXj1BWIChTt
	kOYd2EE+HkTFqC8nuGHNjlDuCNjiJJrKu02UdCjBvm7K2XpPXoeyf+19Axp4FoeaeB7sv1
	aEUe7rlZNXposovprYQHs5MkPenLlag=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-OACiM49tMYSzxxk1g9DFfw-1; Thu,
 19 Mar 2026 12:07:48 -0400
X-MC-Unique: OACiM49tMYSzxxk1g9DFfw-1
X-Mimecast-MFC-AGG-ID: OACiM49tMYSzxxk1g9DFfw_1773936465
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DACE71956062;
	Thu, 19 Mar 2026 16:07:44 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67FF030001A1;
	Thu, 19 Mar 2026 16:07:36 +0000 (UTC)
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
Subject: [PATCH v4 4/5] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Fri, 20 Mar 2026 00:06:55 +0800
Message-ID: <20260319160656.1480279-5-chuhu@redhat.com>
In-Reply-To: <20260319160656.1480279-1-chuhu@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: agFP-oxRzPE-vyoY1NiEtSq9uOGT8WkLe2xUBX2P4Rw_1773936465
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 2D0CDA0020
X-Stat-Signature: 8z6axb8sdacf1yqdxhwphy6o1thgnb45
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773936473-163713
X-HE-Meta: U2FsdGVkX19R5v2QY7T8DSvXgz09qF/VLPGfHUIcRfGnKiF94dzyGeEe8888EyPymqwYP0B6+CmqOYWTQkwaA+Bci5aRxN5/eXGMoQUe217fAobuSOXXg8eR5Jkg6ChLP8c0Ev/89XEcC29iik1HQEEAYbmb9/25afgrJe4RUwVZz39Q9ZjCXSLgTsOS+5R7oJZiecJiMqLFWohFj/JXvGD/5QYp+V7YkCCkPNrxYjVUEFeG67xG4cf7c0hHduyo+O2N0gBWe+UGCzaZ7PRzUWZahm81/L5TAf96Mw/w5cUeU8zrKrIfSBNw26TukzLbo1MZ6bUg7DrmCEs0pub7ZLmxlS2X3wZbJ5rUGYBW/ctdP+wd6siJ9f22IG6Y+XG2EB4OdJTdleKDkmJWods9iIBmFvYXHC+u0V7E4ksaQqA9B/d3LyqtMW++LlpY/igFQ0q+h/XRhUGgf/P+q0rjIHJrFq8a1qxXCOzBt04yFUj/ZXXJUtn/PTLjAazZLK3jxdmKJaypGjFw6hltGbUf0+Jf0D7MuFVr564T6M8tCc8SMLxeO9CqJURHs1EQScpwm/Ya2ylETLEEYRo6Zb5xaTcbu9i0Q5GOvuAZsxJQOKsFY3SRYmTAOI4lzM5pGmwohOzj7Bppa5HYRBOQ+bPgkcoiB/myOdXb3jXfJ4caQPz6K20AwzVsk896bMW7yidhTtfXLaqgpfkTud1RHy7KcFpRxXbC1TR7diUzpOxiy0dbr5ACg3BRylM3ha9c0HMbx3iH46uTdHYaLH9GQ+2Rcjbe6E9/GG2/1TedDwhWu3cnQclb+Y85NCh4nR7vi4F6nn6RITiVap+pfvXp9RoopydzaoIZwhECLLYaMiW8c8km3Zi7LHE+CbKUviSThsp8bLUhDS+jue1Xi5e5+uJu4vSaonOSK3gantNHsRN6Th64OjoLjwlSfSXq12fX0VnuI3jp+KS8y1+gKPiXSK9
 QBJc3nJ8
 lRqdoSkkngnBJQxgzUDFHWsUCSDgrTQcf0D2aPpAOfd0Rjc7yirnu5Cm5YzURLen1uIfeBKIFSqi3kkf8wQWtmolAm8nyEfOyksM7mC4r/hhb15fnj5uHmvu0zoeiA3tpcFS06188a/oG2fmPVBapRoWJzfDSZPbJ+ukvolCeDU840es+Fx/L44Z5fphHi5GwFytta63f6DxBjdm7NOH5b6C/ucWAKrifeLn7g8TdTGX9ThmdeW8IKwKb9b5hNa53VlmIhwb5dShSUQIAb/8tq87Rp1sqF8NuXOOhf5Rg1X/Oegy5WFqBZx0UOTs5mMkEW7Qqss48ybIPy7t3TIkkupAmjlrdcHE6Ywpvi43rmEkv4+oWYaCEXGMRbJgzesSP047F8mBu67/URIurq5BBp++49nN7hlT7ZO2ThqMDlMJ8qHU4HKAArE9poQ==
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


