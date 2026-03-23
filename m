Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C22F4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E2F6B0092; Mon, 23 Mar 2026 11:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0DF6B0096; Mon, 23 Mar 2026 11:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF126B0093; Mon, 23 Mar 2026 11:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4306B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:18:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 533791A0C17
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:35 +0000 (UTC)
X-FDA: 84577684590.14.D7ECE4E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FA1720003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V4V4tExQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=vCxm/dT9AGPfWlCLmtOkMFJMSxbkL5hPropBE1SPQwPuVY56/rucH9h9t/53OeNV+15cp9
	ix+bJOjtMVuYsNNBYg4GwAx38mpswAZkAHtBlrv5OMzRuudmFMO5OfnT9k1Nhzf4cOoYMf
	qW+eqIp0lEWF1I04aKoWKLQMdi2N0iI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279113; a=rsa-sha256;
	cv=none;
	b=sO30GNJ5wdoAQi/D8f+2OMfAwnSgThSXbdXJ60Nt0y7Q0h3m/Vznh0K5pOdpo9AUpMw/V4
	ybtE4HZELpr0vHqLvJaSA7URPZ+Fok7ybh+HboTMqxoe0Y9vbEgDrdlIAZpElu4vj4R/Xn
	I/vQu276/xJ17wdEwdI0nqj8Z7Ihvxc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V4V4tExQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774279112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=V4V4tExQ7sEgnhrMf2bir1E2c2vMLStzo3ejdI87C+i0tSUPSgnry3GL6h7lQ4FnELC5e8
	/nns/a68wQ3NBTJwH2Z8RwYf18cCtdiPteKjhrtU1T8RDv/zjH9+pd4HKRe9SnlZVNCXsT
	+ZoEo0a1u2kJI8q3YTkb9nmpJ27ArGI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-xdDpdmCUP5GMepEPIkiQsQ-1; Mon,
 23 Mar 2026 11:18:28 -0400
X-MC-Unique: xdDpdmCUP5GMepEPIkiQsQ-1
X-Mimecast-MFC-AGG-ID: xdDpdmCUP5GMepEPIkiQsQ_1774279105
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60388180034E;
	Mon, 23 Mar 2026 15:18:25 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36D171955D71;
	Mon, 23 Mar 2026 15:18:16 +0000 (UTC)
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
Subject: [PATCH v5 2/6] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Mon, 23 Mar 2026 23:17:49 +0800
Message-ID: <20260323151753.2576137-3-chuhu@redhat.com>
In-Reply-To: <20260323151753.2576137-1-chuhu@redhat.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: YiQVt-OoPvz_uGlvR2G-ZSFtBBaYoWbSv80Pf9gFvFQ_1774279105
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 5FA1720003
X-Stat-Signature: h7k89ezmb1rmhw5oum3fye6aatok64x3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774279113-927494
X-HE-Meta: U2FsdGVkX1+46x6qYcypFRKZW0gSXtHjbmwR//61f4fxHa892NRkDO5L87dnqmaLsSgaRmS+6V/driY5SSFDeuuZvHAZGgrsHDuOO1GqedvsLQ1kqZIsfY0VQl/7nH+ft/otC0ekqnBE8ajEcAS9C5aJg9QLHkMM1/8gXXL1IDNaAPcioR2Tr4mFMB4lptvsI94ugCyIlJP+VlFC5NAhxx4MrO4KvAinnZ4QNkJPP1/t35bDvpUoBrd7NW7j+CLTdt8Ev2/lMk/hrhV3ZK2vyCvCOVLBErQl1u+AdIc6MWAZEy5CCfVGLETXvrYHQi+qYXdH6yYPqhg/FMRK33AvyWUbCBwEWbI4QcLa6weTvGePTZ8+iWPcGp/ZZsxTnhCQzdFacgQ410pBsoy4B7bllxP8Kz2jPNmFFdVsdVtCyRqnlR+y47unEpRR+OF53Q3H+GH7fC71EEXSHYXvdNAdea5edJ2EkKfoBAUy58elv+s9yPbBM4+BfG/RxGH6SZqfvCPkILQLGpv+74oU+jZ1ChRK3X7XwBjApjwIp/uN7T9gCdrpBePI1TVZ3dPN2QcLiZkjv7HdMw+Z8QayFfb09ofh+Y/sOG8o8x2MHghmJMhjfGwjmP6wapYSXSzUFF704XmTZ5ZmfMo0DgWKxITJdikAaapYEOdsoI0jB0UD2eTyzRAfd21RUIe4y49WMRJC4ogYUDQIROYCdNnFWDD5xS3kF3iPpGZ6MjgGNCJm8I6cAWtxhqa47TEw+7fUwD+TMsN+3SNtbrMDsWiVoTwA1v8HKbmbNda+GTqGLsyOS7j3WEzPyiiTXtvWafXGj9qqnMAA+qkTpIwlkHGlPs4/kwhKl2lrjeWnBRFnCRiKnBmIKCq6yLdKElByIzZEFmIF1BBb9ZatBKmsTeya43HebEqPbRvcnLFwKf6F7S5XGP7cYeubDtU+MwVihs2xqqczocONhj5Uxh0Cc6iKRnz
 9BhQZ2v5
 td5kMUk00Da0DDI9vTxeZB2Nigrt8huUnp1q2hsXqEjAGO8R09seKIYlcglsrIjtAfUFsbdvYMRDA6/NSECUByhapb0Y0Uh3eilNoAFlYmuAX8KkQe2lNAg9wHXuP8Hjcddk3VLPXj/k5gwPvaOipKGofxxvdwCg5DsYMPVdsXAcTDIBl6EpGfPUbC9oK4Kcj1cSJqQYsSiCrVNpgDLcop0fmE2GPImNJ8bQg3qMjm0EcB52hNu/+s0dG8n4o4lM4CHJyl3O7UHwG9mOq+9XouqshpNN/AQL+S8bpF/y/fxxvJ434alVfZU7T5C7XS3/acWR2mFRitJIREI8HBR4mYaFfb7fT5fsgfQq2rZn6JJBKMpLOXXGh4RPh3BKWRBA5WKHTywRCjDfdz0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test_hugepage test contain two sub tests. If just reporting one skip
when thp not available, there will be error in the log because the test
count don't match the test plan. Change to skip two tests by running the
ksft_test_result_skip twice in this case.

Without the fix (run test on thp disabled kernel):
  ./run_vmtests.sh -t soft_dirty
  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..19
  # ok 1 Test test_simple
  # ok 2 Test test_vma_reuse dirty bit of allocated page
  # ok 3 Test test_vma_reuse dirty bit of reused address page
  # ok 4 # SKIP Transparent Hugepages not available
  # ok 5 Test test_mprotect-anon dirty bit of new written page
  # ok 6 Test test_mprotect-anon soft-dirty clear after clear_refs
  # ok 7 Test test_mprotect-anon soft-dirty clear after marking RO
  # ok 8 Test test_mprotect-anon soft-dirty clear after marking RW
  # ok 9 Test test_mprotect-anon soft-dirty after rewritten
  # ok 10 Test test_mprotect-file dirty bit of new written page
  # ok 11 Test test_mprotect-file soft-dirty clear after clear_refs
  # ok 12 Test test_mprotect-file soft-dirty clear after marking RO
  # ok 13 Test test_mprotect-file soft-dirty clear after marking RW
  # ok 14 Test test_mprotect-file soft-dirty after rewritten
  # ok 15 Test test_merge-anon soft-dirty after remap merge 1st pg
  # ok 16 Test test_merge-anon soft-dirty after remap merge 2nd pg
  # ok 17 Test test_merge-anon soft-dirty after mprotect merge 1st pg
  # ok 18 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
  # # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # # Planned tests != run tests (19 != 18)
  # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:1 error:0
  # [FAIL]
  not ok 52 soft-dirty # exit=1

With the fix (run test on thp disabled kernel):
  ./run_vmtests.sh -t soft_dirty
  # --------------------
  # running ./soft-dirty
  # TAP version 13
  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..19
  # ok 1 Test test_simple
  # ok 2 Test test_vma_reuse dirty bit of allocated page
  # ok 3 Test test_vma_reuse dirty bit of reused address page
  # # Transparent Hugepages not available
  # ok 4 # SKIP Test test_hugepage huge page allocation
  # ok 5 # SKIP Test test_hugepage huge page dirty bit
  # ok 6 Test test_mprotect-anon dirty bit of new written page
  # ok 7 Test test_mprotect-anon soft-dirty clear after clear_refs
  # ok 8 Test test_mprotect-anon soft-dirty clear after marking RO
  # ok 9 Test test_mprotect-anon soft-dirty clear after marking RW
  # ok 10 Test test_mprotect-anon soft-dirty after rewritten
  # ok 11 Test test_mprotect-file dirty bit of new written page
  # ok 12 Test test_mprotect-file soft-dirty clear after clear_refs
  # ok 13 Test test_mprotect-file soft-dirty clear after marking RO
  # ok 14 Test test_mprotect-file soft-dirty clear after marking RW
  # ok 15 Test test_mprotect-file soft-dirty after rewritten
  # ok 16 Test test_merge-anon soft-dirty after remap merge 1st pg
  # ok 17 Test test_merge-anon soft-dirty after remap merge 2nd pg
  # ok 18 Test test_merge-anon soft-dirty after mprotect merge 1st pg
  # ok 19 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
  # # 2 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:2 error:0
  # [PASS]
  ok 1 soft-dirty
  hwpoison_inject
  # SUMMARY: PASS=1 SKIP=0 FAIL=0
  1..1

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v3:
  - Add reviewed by from Mike
Changes in v2:
  - add reviewed by from Lorenzo and Zi
  - add acked-by from David
---
 tools/testing/selftests/mm/soft-dirty.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 59c0dbe99a9b..bcfcac99b436 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -82,7 +82,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
 	int i, ret;
 
 	if (!thp_is_enabled()) {
-		ksft_test_result_skip("Transparent Hugepages not available\n");
+		ksft_print_msg("Transparent Hugepages not available\n");
+		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
+		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
 		return;
 	}
 
-- 
2.53.0


