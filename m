Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA885111224E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A0C6B0088; Wed,  1 Apr 2026 21:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12736B0099; Wed,  1 Apr 2026 21:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28036B009B; Wed,  1 Apr 2026 21:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D10846B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:47:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9284214030C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:47:00 +0000 (UTC)
X-FDA: 84611927400.06.5070D54
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B73BBC0007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zyf8yEwr;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775094418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=g0mNwbM5Vc2ze1kRWwRJFhaqjq82blJF0ZFCEQsaHjq0udHPIzTbOLStx9FKa9yjGE2MQ2
	r9bxLVvvvAGRtyw1oyciaNSfCAKy+ZOYjOAqe27pRQyTfbV+JJ1yGJyDmSRpckAfTLy7pe
	np/1bXflm0STyafnKTwBqQcmQ5W7p9Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zyf8yEwr;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775094418; a=rsa-sha256;
	cv=none;
	b=uaZFbWNGf/WXeet9sFbw5mHADJeXvGrrcOuEYw1093qiso666e75C319Lkbt/6BcvbM4Rn
	h6L8AK5389C5FZlG+u13290MZZ2nJuhP8WXgGAndOhCEEdHSSH9dQ7BR3UjA+Etqxu9EQw
	wHbfWvh6EUv2ICPD/yd4h0w+6E+6pM4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775094418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=Zyf8yEwryo83qWWjkE0h2yD4lFxw0ceQYKCjV0hvcyXsoHxhwPr5/fK04q6Nj2RByTi1yw
	7PewdptvfRQkjlYlckWQ+yh3Bt9+dK2iKCLxVjIc++LRe18YivEZKBlh7i3VJdrc54mVhS
	2JMovlgaW4I/dOxi4W5F81h059No6RY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-304-Ys615eQANGK9p86PrAQtoA-1; Wed,
 01 Apr 2026 21:46:52 -0400
X-MC-Unique: Ys615eQANGK9p86PrAQtoA-1
X-Mimecast-MFC-AGG-ID: Ys615eQANGK9p86PrAQtoA_1775094410
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4879E1956055;
	Thu,  2 Apr 2026 01:46:50 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE9F519560AB;
	Thu,  2 Apr 2026 01:46:41 +0000 (UTC)
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
Subject: [PATCH v8 6/6] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Thu,  2 Apr 2026 09:45:43 +0800
Message-ID: <20260402014543.1671131-7-chuhu@redhat.com>
In-Reply-To: <20260402014543.1671131-1-chuhu@redhat.com>
References: <20260402014543.1671131-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: ci-0veJZ19E4DouwGYJKFc2qIK-z7gZxAByFjlRNkjs_1775094410
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: B73BBC0007
X-Stat-Signature: t967wo7yjopxyxnmhctd37ywdab9j1x8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775094418-882543
X-HE-Meta: U2FsdGVkX1+UjmpENzj85U5mMGB1IfyEk9vsrH6RHvsvsx4E6+LPs6Rp9g2gXpSogjzxfVoIgTWhrgUvJ8WM6sVjt3ZeU8NOvWpyCIQcmBsd9oR/kYKnrCIiQTfkpb8YoUO1fi7ubaSmrfI1HwP70j2vBQO7J4V6JvK24ir9tjTM8rIbdPvxPX95T9RzfcUhkKKcWJHXOW19xy3VJ6SleNsI32uuGRZDEPHneVfHYpRD6wPwhxuwrXfq4mnE2LAcwxM3lgA/jmd9jKw52sm3NiNLv6XsMQ2ExkGG3kdpShgsyPN8NCgUBuMzq/Qpnpr2SU2TvrUkBMh+5dObPknoYqg/2S2ov5xTH9Da9J8N0Rh7NHPvG+Dxrs+3ahyAu7+f3ZhaPrxn94YponDHClTUyVi+qxxme8zAxjqu7YChMX3wJQMpxLpMA0hBIico93f72MZ7ohj6YonvZ/TDHMIAlKVp9Np25CqEOLcrzHgaW66gvgJXAlkZH1kWdo+UeMOH+YWixCvYbDO9yL5dryBqrCLYj8MWvnO3tJa3ylXiRxUiaBe7ySA20S9QHdXuF5Gdg5C6fJgZjbJ5iXsz196jjZhGVUoZWHjOV+G/5xKCgj/k418e0nWTWTnc38bbeMMWiZblL8fCvWAKB+lJ5VzYjogOBGvJkI/00kv9DYzdxcxWIhsq65HdwqFyODApmTdAwdnueoyk00Hyba1b5B0Y5YV3/fc0g51R69xIFfHEy7Km/zC9jeLj0aBytkYfjl0ry6gAbrleRwkG6PrJm2N4dASPadWpgyvX5204jhVCLad3Wupf1rhu79L+lXFEsrUdEzWn+CixqjLzpR1ynwXz2VXRN3gqLjoMioIxXPZRz1IL0TAMqeQbNHGzSfKYKfLjngxpNtylpO+IJ9FBwqWetvE4xS8bDt+WAyTMJCg300ll0d5ccClH6NCCiMVTap4zO4WvLILhkN+5GylYVHV
 gyuXP6GV
 kwRPzszI2+maqDpf2X0aNKk/ENmke4fRUrsYHHUwPiB1Pyq9sodbk8ykTZsSPh5/YaBmcv4LzCJLMbgIMqxB9UCE2O9gsOU0SJP9dNIZcwTv6ioMvRSc3RI9uc+adBs+dqYfJ3PRlN3glGGGczJOigkjw3ohst7ZqpjjVY3jLY2PaYcT5f2lAXoCKa0Tw0Ec3KoNcKyFN+ucqv7JE50Ya+tka7E1zQOkiztpedmZHd1OqhqS8Yh59cNEsM91208znjWt9Eg0YYkndvoe0zAwIKNlEIhyunYdUVGs3r034mv1GqpOZ6fDwf8w1Y12VGe3eS+nUe1YIjXDoHjrRsMOsfYj6V5ehAyO+uRQpU6waZDceOKUBQO4MpgvMNofUnaP1UDvLNFz02lST/7Mg9LvfJSHDIz5uWv6+vX4PMR529ZNGi9fEbkXAaGEFCg==
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


