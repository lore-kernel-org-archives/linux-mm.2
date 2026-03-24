Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F7D6F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E63C6B0099; Mon, 23 Mar 2026 21:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397266B009B; Mon, 23 Mar 2026 21:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286206B009D; Mon, 23 Mar 2026 21:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18A896B0099
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:34:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B015A1610DE
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:34:35 +0000 (UTC)
X-FDA: 84579236910.11.9134B96
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id C27FCC0004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:34:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VsW/Lvcp";
	spf=pass (imf22.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VsW/Lvcp";
	spf=pass (imf22.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774316073; a=rsa-sha256;
	cv=none;
	b=K5bBRcX5t420dfkfOpVyO8ZEYQS4ZqRqBNil63OCF+7nSOKdP4RwuajN/etK8BQJ6T1KhY
	q1Oxo0TexbQjdOEI2OVhD92GHGR1MoXaNOjaj+rD2eNFIhlLhvbSXhyjok0T2+mW7dH8i1
	aG+hjSVohH6VDJZ5e5/+CkBsYIX+NFA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774316073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=tJniIzPzfkFVLWEQo+U0QfuZ6Ulk52jAd1zbq3YyadDLf4nXMJ3v8LBB3eFoKzM1ADsrUc
	U8rNtORqNeWoJg/u5DgF5ioJ7UhycMIicdpf7NGY6xs297lXeLdRpLAG0SaAkSAqeKn9Vv
	VN5iJId/sIbLAuZpxVWZRXZ/+AkUIgA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774316073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=VsW/LvcpDE4w24ZeQVzLGtiQXPkmiLp0Pb8r/q28UiEiLlxgk59+qnq+KHQkL2XyT2Dx1k
	yiaW3rq9Ws4NxrZTnacpA7mKnF/6Q3SiBNIRdmxJVSdMB0zHaG2dQkE2H412iqXTG4FF9M
	84Qm5GMQ1KlUwCC0lyPkkwKFzTrxd2U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-hsgMjuCTOcy5mAVb2IZLbA-1; Mon,
 23 Mar 2026 21:34:26 -0400
X-MC-Unique: hsgMjuCTOcy5mAVb2IZLbA-1
X-Mimecast-MFC-AGG-ID: hsgMjuCTOcy5mAVb2IZLbA_1774316063
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 715F719560A1;
	Tue, 24 Mar 2026 01:34:23 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FBA0180058C;
	Tue, 24 Mar 2026 01:34:15 +0000 (UTC)
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
Subject: [PATCH v6 6/6] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Tue, 24 Mar 2026 09:33:16 +0800
Message-ID: <20260324013316.2590422-7-chuhu@redhat.com>
In-Reply-To: <20260324013316.2590422-1-chuhu@redhat.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ATYVQ0Dy5imFpH9aS5vW4DVoOcJhaz0xVBo7zrKsPQ8_1774316063
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C27FCC0004
X-Stat-Signature: 3gbhpumkqcn7psueiw7hrdcf3w1it7fa
X-Rspam-User: 
X-HE-Tag: 1774316073-19707
X-HE-Meta: U2FsdGVkX1/gqeQBQnY5N7Iso766xu2ZRY/r9aG7AUmKWXcDh08mgF/XWlMy7d+3MUzfjsK+EGN1viKhB3rIRzWKHKx61LVgC93Y28UqbnNdjegi6jeErOnlzPKuwsFTFHLpyPkOa+u+wA5vlsbs248/RycabC78eau4CeTNVIKp+SvDZwQ0AI/gO7BGitD/km2WZ+c7BD62ejXAVqVOco6i8ZAb4OZngbMsvY16H52ckpiQrBjV15BvRRZ/Y2Sr1uPnGcFjVpT29KeB/ynMve7cI0h9+66iHJ23G1QcZtqjoqWapQ/AzUDa/Gst/ZXR1Ou/aKsYEd1Qmfiz/J9O+shaK5ETW15KHzJBb98vnLiGJNtrpnNEPEQjQBPQlzhE4bGCbJImie6ETOjr+2nG16xFADftonhh85XRW6G//ighwA9kzV1kqrk2Gcw7IY0vQ/tMz+Lty9pnDdWLcIt7nfK0obgd2UmjiO9QwRB5alVoPbMHhI7JGUwxhq0WqUm+VoaJlAKOuGXN4SPyuLrzHwzD2HcUGfcCmqIkOedAS00Y3lrfycYCfZUjQWU1pAXVX4Ds5ScbbPkgxpW11HQm9lu+3Ezb4l+0o9rtdlfwgMpjABjkzMUCgiymR4gM6hmI479si6B8zPQtqulT4lixAvGtNkaR99hJA3hdFG68DADpQIb5EfjIBMIn5yD661AJCtG4dgnKpSi8SPycuR5pHyS376P3Ef+bnYc6npA5Ru7IKEXfmwHdoLvpo9m1EbDaFHXLHIpZLOYT9y5rdMk3xAtPfisMknA7MahWHYHJMw718FoB18UkdbASJwNjEaqeT4tj+X6PkV/WnWkKzBtQ+FWkN1UerQF82cBUCyeqGeb/GDqEokkCMyPP1AO1Sb8RcxL0X1GbMghtJZhVb/UFEDDJBfQmpQ1oy5tDx+5R/UvwxYtkNY/kj/YO+Rogkb/qytCzwL4nZVYo32d2sbZ
 w0CgEeFw
 07bSr5vRHtcltSpx0YEQbKbdXSEEHjl/PRDncJ+PKEwgmHXynNzwas2Vp7ki5Jk6GVMS0tB9Z0d075RtnVyv/jlvtMnQIR5mIHu2T+r3cw+Q2kiN91jlrO2q9o2hK8X4XxNOP46/6mkw8LJ9g9Zc8lVLudJcO5A0heZJwnP7V51Ttw9yLmhAT5BkrxvGxGFFIJ/GZR8AbeEWfgFxERjSB4SGxl8ez7X3fOfiqqXbxGr2NuHiCBzfYq5KLkvPg6XPbqzKUh+RtSo/RYSBDn4XPDGx0IfBatMvAP0TOcucYpMGBAb3T+n/SQkq04BVTlPTV0gMoM88rc1MFt7FrsS3VJ4mP/nmHo7hMmz6o+3F5s+4ri+CylvRQABZEXIFeOAlWlvj2mi5is2b4qmVp7CdNjV75KYpumjo7kr8ki+LwTRJ/M9LH6VxcgJddVw==
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


