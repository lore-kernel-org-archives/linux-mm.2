Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA5FF3382F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2AB16B0092; Tue, 17 Mar 2026 05:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB9A6B0093; Tue, 17 Mar 2026 05:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1D06B0095; Tue, 17 Mar 2026 05:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB1396B0092
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:44:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E27C1A05F2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:51 +0000 (UTC)
X-FDA: 84555070782.17.F93C5E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B8BE4000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S/6VC62f";
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HIqxqaQmlJmdMID07fNGAM+MeOy6zpSAIFTosPHxvM=;
	b=eYT1jGpJF7c2z3t1pjm+QvAKNBnox9em28eay9asXcz6DYp+umiyJG1NaGljKoI5YzaF3e
	pXouO0ZA3bHBtOygGuWY/WuSCvfmeb5wlr7hhScTR8v4zph+agH4oZTnr8fdfswfOUwRzT
	9M6vafDTkE1tup1riPQFnQQwp/A6anM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740689; a=rsa-sha256;
	cv=none;
	b=ZeGytBI0MNYYBbXwBJyaibvnuh4zttcQyxEXP66xpRWvBt9qujpJTPaRgaUYlPw8ntvc2b
	eOHjwEL0hpz0K0b/950GQf9C484OSPk7aWg14OaLIIdPlbmg99vvWOT2DXmA7ZVWVwYXBe
	j3vYXdMdQEga+GyVH40bLsBy3eZYTM8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S/6VC62f";
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773740688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1HIqxqaQmlJmdMID07fNGAM+MeOy6zpSAIFTosPHxvM=;
	b=S/6VC62fVGmGp3qLhLFHZ+OMKoZO+7BACMCIkonkDQP/7cfsb18vr1zbaBSUzkq2XgdkdX
	sIAItbIzhe3vaRbz3HO97ouox5e8Q54aZmKhpy4j2w61C+/OFnXxcCYz+Om2RC8dQWXIxY
	cUVsUFrDy7lyCXq3CZjgFTfMnDhtM3Y=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-22-zBLcBpMzNzy-13PzXxUSuQ-1; Tue,
 17 Mar 2026 05:44:44 -0400
X-MC-Unique: zBLcBpMzNzy-13PzXxUSuQ-1
X-Mimecast-MFC-AGG-ID: zBLcBpMzNzy-13PzXxUSuQ_1773740681
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADA2C19560A2;
	Tue, 17 Mar 2026 09:44:41 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C014E30002DF;
	Tue, 17 Mar 2026 09:44:32 +0000 (UTC)
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
Subject: [PATCH v3 1/5] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Tue, 17 Mar 2026 17:44:15 +0800
Message-ID: <20260317094419.1429259-2-chuhu@redhat.com>
In-Reply-To: <20260317094419.1429259-1-chuhu@redhat.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: oVCW0pxJ7IXdhUl8Iru-Si0bE8NJ35WF9PY94fK4MHY_1773740681
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: fw3pb58tocdjkqq1bfhqtpkyfbufnupo
X-Rspamd-Queue-Id: 6B8BE4000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773740689-354323
X-HE-Meta: U2FsdGVkX18q+iAH4ctZUiyHNpmhrB737vs25MyDHLX6pTOaT6P2K5LKQPI88hLbCjeJvarIM7PKnLXV55lJpvlBFzeOjo1NhLBf6OBfMd7SlW3QMLQYYR290V5ivmMOHKoDaVPumLYk1QgPyvKBWBRYWhU4d8EWCkO1cX9s/rxFE/kLsXX2jpkbbE4qttUbwltiHzO61ScBtT0Gg6hVXNHsVR+OS3TBpXvNU9iwtlvYrKLe+sn9BM/cl6ras8QxTg+CbDFgLvSKsCtiPmuYyuLkZOMflHx6hXYgmzSZafKPS4FKy/CTofic97VcrWr25GRjXF8c92feN5DWhj1c/KGR/wnptGEadInwf81f7oF21CeWYn8UmLB8ym9VM3phaeO4XTKyuNnhDgkV0sd8KGkQIaJAenYVspsVNYqleMoDoxR0TWoScMF316uMMGmfkIjcUsjXirFXK4wje+5cSIsxKTlUy7xobty9rjUXYWbuW+bwgQuaslHVkQHxz+JLehQsJO2r0xSc4yflE1lSlWLucdnWLh6NNMHaynCJAwc4IQX6dakV3PnpoNtrb3UgUvXDvFcoHZ7Je1wrJ57l65jvCo27zekwqNtL5JMSRLqnttj+qJTS3Uh+aAFMMlBuzmp7JF1wdQjWYFYipeyacSgBFki1ROsH/PDm2bUh4EUs9TbO91MaKx0mYdq29kizxI4QhzARkUwgHCR6lEZUW6kHXcu8wBdR/upLbEp2Jc5QfgYl2y+bdi5unp774tXbRHvRR8hVTd+wZ5Jy/YwjitbZPgoi4GMeNEEs9PuTqvRLWpeqtiPMMFUIkm3FqN8qTItmN+hab98OKF6oU5hLr0CqfIex/C8CKaX77P4XE8uk0ci9lySEX+gyzjAHPR53ZRI+rp4+STB+WfGNF72VdcnzK+t1l3Jh0itbiuiFkojDjHsTQliURujFH+YbrXmgRX1srSDP07k9xE9iTP/
 SNSHWeoU
 elxsWHBqqAmIiNrOiJfCsFX6+mAgkDqtXXOWJEVB2otVejVYXmn46A22gt8i5zOWBPA0oRWghgeq1W2uB2AzPyChEdgbSd/MBd47VmLOX7KJqeI759/zLBpWYUTZkIDyfY11eGDDmnn9XiAdfq0ECLqaTygqI8bob2ua+tEkIJkizP2IV+LoeNO/v75G/+ur3Xv1FOKAuLCjGlWJmQMTiXAODXnDjnu+HAY4bvGkhGIAYQ3otd4NgweikflwquyERUTyF3LB30q6TedcdZ+GG54yVxPclEjt3KhVauiFLEBN8wQkWCnZ8Nv86h3R54and9QJWnsn7wLFAGCGmGSg22FpAhj4XFsvC6J6V0hDW9v2ciAz5zUxnbeHjA6Tq1L5/BGXT1qE0QNbaxJQ=
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
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

base-commit: 2d1373e4246da3b58e1df058374ed6b101804e07
-- 
2.53.0


