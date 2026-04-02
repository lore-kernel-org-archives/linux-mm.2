Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08AEDCC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6909D6B00A1; Thu,  2 Apr 2026 02:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A0A6B00A2; Thu,  2 Apr 2026 02:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508CF6B00A3; Thu,  2 Apr 2026 02:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6416B00A1
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:38:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FB321B80A7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:53 +0000 (UTC)
X-FDA: 84612662946.07.9A27674
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 39CCE2000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PWaF/hG5";
	spf=pass (imf13.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEqNhVsQrzJKuyttIZRIIhpYJGhdAwnhMqwpTFllafE=;
	b=vgnfoW4kyckk2Oqt2V+HvdTS67JE0+lulDm/6taYoxKZyfsVQrVbzuaLEh0Mfs5Z2Jcr/a
	ZAu/ezSux/PsIKcyOS5BqQSJlOEOuU0YPc8/dBFGAkgLqda4VjVrwourI3YZ4x1xZ+iN4w
	1qomzuFJTD38VpsfSQPnApqvY7WJHHw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111931; a=rsa-sha256;
	cv=none;
	b=ehN03hnYuTt0rMnOfyR45W5Hoeoq4Lo53XhncYB6dQ70NChbf0WusUyec0mD+eZXVLoeQ+
	eJO9n552kUxNyp0jaKRk0vovEaa3WrwYDj0+VokMcHKKMgzwoVrorg99koiApRPE4DcGS/
	WiRsWZ48AXsHSkHjYv2mfY0DdB4CrTk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PWaF/hG5";
	spf=pass (imf13.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WEqNhVsQrzJKuyttIZRIIhpYJGhdAwnhMqwpTFllafE=;
	b=PWaF/hG5TI/+eCG70TRrKeW8r85eeAxAF+gDiCE+kpbRiZScHySgPSygz12yMtHo/kTMpX
	zWPXG1v6W2+w6XSM+8d2eu5+wYdhGrRJgXHe4ahqEFKH1A1P9uwKMAuwYVJE+iTUJ7qQOV
	sFVGp9EMG9PFIZGExIUgOgIkhabupes=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-E0pFoX1POSO0tnomLtchzA-1; Thu,
 02 Apr 2026 02:38:47 -0400
X-MC-Unique: E0pFoX1POSO0tnomLtchzA-1
X-Mimecast-MFC-AGG-ID: E0pFoX1POSO0tnomLtchzA_1775111924
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F10E2195608D;
	Thu,  2 Apr 2026 06:38:43 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC9491800361;
	Thu,  2 Apr 2026 06:38:34 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v6 8/8] selftests/cgroup: test_zswap: wait for asynchronous writeback
Date: Thu,  2 Apr 2026 14:37:14 +0800
Message-ID: <20260402063714.55124-9-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-1-liwang@redhat.com>
References: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: lwVrHRoZY4p_mRD6yuQ7PZ1r1n3QQ2e_QO_z93WEANo_1775111924
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 39CCE2000A
X-Stat-Signature: wk65ke44i1g6jweddm3hamo4ek1g4bh1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775111931-990500
X-HE-Meta: U2FsdGVkX1+tLFR2ajmgx2NV7KE5LcQBCJXCwE+ctHeG5ogllaSTyPZBm6uZVPaV7zTGemkm+noajkCSDE0BgqHBpZ73kjO0Hr0vUgmbrkqEVThZ/X0Yw4wI4vcWOqNy0HRK/kpAoMnvJAfr0BikK0j/SljM8bkPGd6oA0VFiQfG/2xWds+39dcxadY0UsAQgkCZOUmfrzXuU++aTdWIdKuIhSsz7MM0+ZtcC+lA5erPc6HnRoVBnkddUIxL+9ylrzsj/WUHdmbmSMP3TSbU0xr9R2z60lp7Es2hAD4bQLSXLQE8FTZtD8PUFZvHaLIA1/7WWgCEPFfcywgFveMv07DVKatzTpB7ODqoo7IXoKTKVatnwHJV5kiXm82bJK2X2nhq8svPCnYJLu2KooIwub51cSTMMgJZ+ykogGAPnPw1IudiUtud6ZsmskQCBTIJSgffiVVM6L0Gn8IcGBGNvxHu4qcZe/rovCkOub6dTp63Y8Wbnk2jPIlwQkCxblQ48IQMpcBi69C1wv038NbXRtrjDD5ICf0EpfLoGWCK/pwidLaUW4Q47t6x3m+T7wohhtbsgx4GX+IISnoBasLXnfqPZZmu4YtjgQA+yTiMRLClt//+4BnOvglrVRMALa2GA11/LA/f+L/Qr4rMVZvLQBOcEBcAuDH5qCgaWhIrZB7mNEsutHw4Vq3DVV5xPlhrD5lMDskVBfNo31czYHEeAxKNUUP1c3Vg88o42Iq8kQGaa0TXH2zZfhVjzN8QsxBqu8fg6BLeghGUsjfpcgx+Vl6+DG3hbCFCKW5do9/KNuwsii6B3fuNG5/Zqu71cW1Q9DHU/mhfKvHwleFKDhP/wbT3YMSTlk6rnbB3S2lcnj4acLvEyrm6Jku22JgOqEMIkVSeBevV1dSltlkmXVlipngR65Cu7y8wqLWbuVTy0jViaRDGUxTAhpt4Pt8vIzmT0jQ1xbtnLPZNwBUutVx
 DMOhmfNv
 l3MmSfp5hZuirfHIoMtrH863lRdrrSd8xTfphDIo6oBEx0yYmM8tJNH4tf7ktlevmI/UZOhYrwxmB2sZrnP5e9mI97qqafSXjuOk9130yRgQqc2cUlp5B9VeMINI7jLguZONADAuH8VxMKr2dLvqZhW8ousdO7r9mdraOU8Ki9YPkN1sTpMX5aw7Gi+hFLTPzgl6NhvDEpTBYV4mq+TMge1H7SEWeCFMF1deg8AMuvxEkmzLW7zc9s4q3JpYUQh7f4Hu+WIb/rut83axYkYWXtkb7S6yCvn1y39yZMUgm+cQV0Ods7VT9+vXdnZrV6r10jJHBhudnU9kAEzv0353+0rZXJRQgztE892EpTtI4mFetpr6KNKtM/pqyNu18jwVGu5izMZDyPzAibXoM0DCvI2m1sunfMtbwM7sKfm1LHTKgr0y+35O2N6ogf4CIKtMxavCnKJTZclkVKQJKWBQcvXf6nzxICfN/odR2pCF77ZQEng7q39OsDcoFR+XsbJZ7idsoQFyOUrjqlLhn7FtH9oz0H5IUOl8i9JwmyewglXMLQR2uSpzNpMBePW8nPIlZUCbjlEkLIvPY+wvetImyVBxkXLVAkkj+wyqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback is asynchronous, but test_zswap.c checks writeback
counters immediately after reclaim/trigger paths. On some platforms
(e.g. ppc64le), this can race with background writeback and cause
spurious failures even when behavior is correct.

Add wait_for_writeback() to poll get_cg_wb_count() with a bounded
timeout, and use it in:

  test_zswap_writeback_one() when writeback is expected
  test_no_invasive_cgroup_shrink() for the wb_group check

This keeps the original before/after assertion style while making the
tests robust against writeback completion latency.

No test behavior change, selftest stability improvement only.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
---

Notes:
    v6:
    	- Declear long type for elapsed and count variables.

 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index ffc037922e1b..8656130961a3 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -118,6 +118,27 @@ static char *setup_test_group_1M(const char *root, const char *name)
 	return NULL;
 }
 
+/*
+ * Writeback is asynchronous; poll until at least one writeback has
+ * been recorded for @cg, or until @timeout_ms has elapsed.
+ */
+static long wait_for_writeback(const char *cg, int timeout_ms)
+{
+	long elapsed, count;
+	for (elapsed = 0; elapsed < timeout_ms; elapsed += 100) {
+		count = get_cg_wb_count(cg);
+
+		if (count < 0)
+			return -1;
+		if (count > 0)
+			return count;
+
+		usleep(100000);
+	}
+
+	return 0;
+}
+
 /*
  * Sanity test to check that pages are written into zswap.
  */
@@ -343,7 +364,10 @@ static int test_zswap_writeback_one(const char *cgroup, bool wb)
 		return -1;
 
 	/* Verify that zswap writeback occurred only if writeback was enabled */
-	zswpwb_after = get_cg_wb_count(cgroup);
+	if (wb)
+		zswpwb_after = wait_for_writeback(cgroup, 5000);
+	else
+		zswpwb_after = get_cg_wb_count(cgroup);
 	if (zswpwb_after < 0)
 		return -1;
 
@@ -474,7 +498,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	}
 
 	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(zw_group) == 0)
+	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
 		ret = KSFT_PASS;
 out:
 	cg_enter_current(root);
-- 
2.53.0


