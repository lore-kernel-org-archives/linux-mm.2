Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF9DF4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE426B0098; Mon, 23 Mar 2026 11:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E8E6B0099; Mon, 23 Mar 2026 11:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DCE6B009B; Mon, 23 Mar 2026 11:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B56D26B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:19:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 460785C656
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:19:00 +0000 (UTC)
X-FDA: 84577685640.24.C5D0FBB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 540472000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gC54WM+w;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gC54WM+w;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279138; a=rsa-sha256;
	cv=none;
	b=UvhWjJ662wmX2iOJ5C4UkwGI1Z8IwuHM0WupddzeTNqGC7gIB8Q4HSJomh5UtwL3Kw95bt
	wXAVBR9U87cXoy0cthXwxQRZStYLUErwHwko8p1NH9qqjBvXHSxMboK4DNDtNS58t4y8vu
	Y1Ng8QBOoOgr4oXOwP/y3yEkIt23rlQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=fVtbK7GMdBdez1wvLYcLjbzFOJJBHZDNjApiwIXTfJKdQnO1od3dM/WD1mCrgLiWlfERN4
	EWM3ydDr5iJ+JwN3yc8hD8xTM49x+e7DWaNDMDRgsDsaXGGpcoFEyU111E+DE2MxEdzhES
	3eyunPQkI02aBfgTwkWElSS493i+mDY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774279137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=gC54WM+woDuNAVeqMq6fhHDqmAwQrJXq1nlP+O5xIJ85VIpJq5GR6MSjyEC4RMUV0Znbam
	cSiYpOLRygezWS7Rzan5ts/hzvi5mVT52qOJGFaoH04/p7hZf72vokc+41qICbvxX2Ksfn
	3fkiccZKJ7cQvFcLiZnfTlVCERlquCc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-edeaLJ2qO7CPTH7vFI9A5g-1; Mon,
 23 Mar 2026 11:18:54 -0400
X-MC-Unique: edeaLJ2qO7CPTH7vFI9A5g-1
X-Mimecast-MFC-AGG-ID: edeaLJ2qO7CPTH7vFI9A5g_1774279131
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7451C1800614;
	Mon, 23 Mar 2026 15:18:51 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D2681955D71;
	Mon, 23 Mar 2026 15:18:42 +0000 (UTC)
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
Subject: [PATCH v5 5/6] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Mon, 23 Mar 2026 23:17:52 +0800
Message-ID: <20260323151753.2576137-6-chuhu@redhat.com>
In-Reply-To: <20260323151753.2576137-1-chuhu@redhat.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: uU0QtP2YcnNCqMLHHtwl26Oq-_CcPpEeD27ykrr7F3M_1774279131
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 540472000C
X-Stat-Signature: n7fn1rr6xsnkit5g4cuiradeho49okj7
X-Rspam-User: 
X-HE-Tag: 1774279138-112115
X-HE-Meta: U2FsdGVkX1+alZXSAI7vNg3SXykUBfOYugFnajDe4MEiGibZfRxuPvvD4vI5PVGlPgeImWzgF6bZ5uX+p+IKoF7Jgx1PF58s1XKfORnZ8BXrKoIr/cvQbx5mmVQ3IwBertgjMEfhRZe+xb0t2b9IBlq6RBdhR8qg4LWH811PXNfgAHnDNMWqt8ocO5OWZcYhn0sumrIJxifl+KTh2XyAh1DEIXqnIbaAIP8et/Vca5pPG6OT/nKAG6NCx2EqpXG6AgMoBlXRmYaqp5vtfNP+4xHod3NqUj9UaiuY+yaEpPIthjiPt753fLmQv0ou1NcVYt3mbrFCDG7E8svwB/+EcCCETG88tYU42oQqOB6xs7/xK0IY7FBEI/MOT9/koUrgSrrb80Afq7gUG5mk/GP69xtTc4evL08VpW1nRfDImbsLFmuKQV/7D1fOPO+3Ma58q18Er3eKuYSsteKK2RJmQu/shzHpr1x48OvQUQnBLmRDzXk0TN8yqdtzaCnRomjaGkx4uc24WlUgUaPER3QgAWgTVJsh7fVznzn5N3GPHpW5864bwVRkArT1fmSQZ0Ls8oe2MlXQCtlzUVfOuVQ45NU1LZryqrhFy1mN6ghxw4Hv6YDLkfQM13P0T2rFXrnNZOkdppg6RU5amemGN6m0av7tG1LikyIDjaJWmCG3bw9/fo3smZoz+XRTXhmJLYLkA7M5vUpp93PZgW0VRom02jxYAvjgnMLZq3DdOphtxdugmZmHWCmCuch6O9gJbVZNkdQXOYnX09ifwmwPFbXJSi/y73QHAlTjs+4nBZdxm7phjyRaQmHJGDlMLP/tCR7MAV/HLp9xB+xWkl9/JbS1FIICxoYGLNrceyTnSfsy4TO3K9DppIzijKQdYEFbfhyb++AtHknY7Tl2t+uTHZI0mJR+prghXbOy2httk+aPekkEnHn3GVF+Y0fxyZ0nwqoJEEeTjY/Pz8Sq10SF1BC
 AEKD9S6l
 /nLsaECOrWrx1E1JHA4UqMjjwnGMzqYRxWUdQ/D7yDABwfn9X/9vdIDHDKdLEU50++ywpWaxj9iVVvsF33Fdtp9xrGPQRQyVbE03tqpQ8tlYtsaudH3P/kVYFdWIcfsm+qiFckqQS0tDRPVta4LXdzUzArWcI0biqKgBjZz24J3s0um2jQM2HowRNuhJiLh7A5FlUE9IwZRd2e6AqBYPiFI41w2BKYD7uYlf1EBeyExinb6BQhu4wIXXJlQvBAUwKexCYYahpSvmXHwJH96SrzSIboosx+oGhmLico3pAnMbfTHF9yA2heOGkFlyUccLWwv8ht4GVxBd3QwgfkX8tDA9uR+wUypjbbYWI4KpiM0iNr+0DjyXZalR4zqw0jNLQ5EtZE/2goC7I8PatrzwI3nXmWE1mKiXhTicKCr5T1dQYodfaXLeI6+bsCw==
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


