Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5099FC97F3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D4D6B0098; Mon, 30 Mar 2026 11:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 414CB6B0099; Mon, 30 Mar 2026 11:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32AE36B009B; Mon, 30 Mar 2026 11:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 202AC6B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:15:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27E6413B33B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:40 +0000 (UTC)
X-FDA: 84603078840.23.F34CDC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2CDDD10000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SkEY0Ern;
	spf=pass (imf14.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbsTCF78bT8G6THrBeTbtu4yq3yji6OlRuMfZnCbHBQ=;
	b=ygy8scHZmRVtNaeutLepTixirRHhrPPnVuqM0YJ2GA90t45spLsz+dcnjV19Mvb3uSczGA
	4RbqbWMyfvk9cV/NlLnMz8EQ4RQJAlAz1VBlvImHip+yhlzr+3nw+IT5G4IXUE/0BHglkt
	exkT3eMhzBXCSf9YNfqreibjMwtfi+o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SkEY0Ern;
	spf=pass (imf14.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883738; a=rsa-sha256;
	cv=none;
	b=0fqdNItnCf3qgTUC45xLEXmWlJ+P6BgMl6gtHU6beSz5y3Nb1wF6D92DRm+328mk9njlOZ
	TMXYEu7Jr/Pn8MlwH5x7PQRt/Bu+zQabfesCn3HujBoTLtr8hMmbx0+90essy3xlacEeEy
	v4zcMNbj+xCN3Se7tXn4mJN/kyQAaM8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbsTCF78bT8G6THrBeTbtu4yq3yji6OlRuMfZnCbHBQ=;
	b=SkEY0ErnpL3gK3B8Ewaihkhod3AEAJ/N3faXo8AZGNQxDEdlP3y1nNgkm8Dk0Fs9nWgdRW
	qR88v9OcfUysq/sVug8yQlyIrzC9DfyjG02chToXjkq9uy6m7SSXbERNp2hwtjl7VrAMfh
	vOEUJ0gANC4+663YGT0SH4CWjT+aVUs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-33S4G_zqMR6uLtGNQ-d1Jg-1; Mon,
 30 Mar 2026 11:15:33 -0400
X-MC-Unique: 33S4G_zqMR6uLtGNQ-d1Jg-1
X-Mimecast-MFC-AGG-ID: 33S4G_zqMR6uLtGNQ-d1Jg_1774883726
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E5031955F6A;
	Mon, 30 Mar 2026 15:15:25 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03C1019560AB;
	Mon, 30 Mar 2026 15:15:16 +0000 (UTC)
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
Subject: [PATCH v7 1/7] selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Mon, 30 Mar 2026 23:14:57 +0800
Message-ID: <20260330151503.670415-2-chuhu@redhat.com>
In-Reply-To: <20260330151503.670415-1-chuhu@redhat.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: wN9kwhtjlv2dSH_X9gGvBxxjQdIqS5MeUnp78MX2A4Y_1774883726
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2CDDD10000B
X-Stat-Signature: wtbwfgqc79goux8mpu6e8u4wa97ucedj
X-Rspam-User: 
X-HE-Tag: 1774883737-388259
X-HE-Meta: U2FsdGVkX1+Q96QVnM9SUuKupwdJ7ZjbUfmQRVbkX7n8Mf4tDyzXziiaPiC+X9ZhVI1F0/DzMwHLmVRtCrn1eyg5m9KMlhGbVuiMd2FEDEfQ4G9UYk54c/VDPHAxne7t66wRGEo7qY8A5eF2+JLSe1uMIq6hKiL3JAsOJ9wdUahID8xNufrvGNPZrgTKiYaDrNWTtbqwAlDRsTCcAlsK06kZYhpUsANn8Ho+84no0kuG0epFVE/9yc39BF4zz4BMnJ3+uQwKdAEE3SaCdSijjDjjzVpMaKvv+sZ7eGtvLU+Dq0XvKhdKtlJqDNPbiNtT4Aw+h1OLkDVHQ5EOPsDS3nQllpOLgyOqQdzz2kgG9cIE088TNNVtZO/eGu1SwbgFldFTi54MBAYdo+tJjMjRW2mfXUpiXgloIKTuWoaxEoPoFpV5EoEXxVlvXn2oE992NucKIVEK3BbpNuKzfEW2zmU/ZmK8+cpbA7hD76aF52wbkH5xCQWIWuMtUabncvr8kHP4xiovc6aF+Sph+28XbEM7QgcfNLAhiJy8XywU04lcEpyI0HEdtzHN0Ql3tOzdEx4cUCvq0K3XkiWkyr/mL9Ys8ztBBmgkxmrVRoIWYNWTa5o9fAFJ/ukfDkFtdMMPTK+5/NPDCrCUgDmu1o0LUneAn/Wy6JnKi6p+izgC5J/znTKXUbtmCTmcgfsEcB7ALzjcX/Ngtq2ysqK7ekABIG5S4dlNcGcWEuoSBrdNGgSf5VSG+1nO9jM2HYLnqhtgBsjWKImcmpNYQZ7Wfob1cKL0jHC366Oy/4O4wYdzUOBK+rtiAA6WlLuejofL+ylf/EKxfn5Jzc9DZdaHtMn+LCrJNAOdiEEq0nTYqnb3SKaxgGm+woybHPSClBTq4Cn50TnhKC8h5XIIsXOekv3DXqbharI0WJLVOEy6nIdqhzOJEIO8RuH1nkKvEeKOF/at+avdfRZPooB6lIuItRc
 dFsCoza6
 x1O1Mf5zI0mNTL0wZmpBCFPehrvRaL6qBCGsTwvvlop+UayIhYkbr9S0LCKO4pxNuj+Ydn3nl6n4WWVJm9RnCwPN6de/4GsRCxcZARcWw+QndiFc0w55pAPSrVpxfqLaJT08p6Rw8p8XAzwtEChZCOUgDxfbpDCanUjsY/QZhg65fO5gHeSe3Nv9s9IpRr722P/QLMN5DRP9NW00nR6wCl2sSD9603qHjhHXqCxpzldh+q5nOhbvvRrpd7nGOfmeR0EEyk2ImUPF4MUMhoYQdqNJ8K2UWR9hx21xnPhfoA5HiVgJX50Ck8FPBXY0jUOFVY0X9iuWey5Yhsu+LemMDVFBJnq7DplzKMDjUqrjSNG6eK3I5Wj37LM0xYXlUFApyJwQY0ZKsG2/jR7U=
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

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v7:
  - Add reviewed-by from Lorenzo
Changes in v5:
  - updated reviewed-by and acked-by
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

base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
-- 
2.53.0


