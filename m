Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 988E01061B09
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC52E6B00A0; Mon, 30 Mar 2026 11:16:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D636B00A1; Mon, 30 Mar 2026 11:16:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C146B00A2; Mon, 30 Mar 2026 11:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C3E906B00A0
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:16:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58474534EC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:18 +0000 (UTC)
X-FDA: 84603080436.18.5F0D197
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 688A140011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SFPvP8ju;
	spf=pass (imf17.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=DC/2NBU238J4cDXrMXtOxbZP2eIhWrSpH3hWSg9jBvwIwi9KNVl3m2kNH9GxxJ3Z/+GIj+
	eefYVhX/47Tc2RM2vjYWHikii9j6IXODOnAjOLC+e28lE1YC/FqAxRplmM9hRoiARA2e0m
	MIeQxLJ5tRri11l3m1oGvZWt1+K/t40=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SFPvP8ju;
	spf=pass (imf17.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883776; a=rsa-sha256;
	cv=none;
	b=K0OVkBfBYrTRBHcC7m2M3mMxMHoQ6S/iA+rkdVcIj7oSyiaSodO928YFrg+yveB3kz8CPA
	EbRv5wwe73mI6aLLZ0EorKrkqxVKTP6TfOcvO85CcFVAvgqqnQ8zy45rpgl8MvG6Xdtl4L
	1tWlXWrHG1NqdvcEn9DFxGN2nnlUpeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=SFPvP8ju7rWMkNTLgkIqpEzkkL256S4glbxKQv7pjqFdsp1Y3G9CrCYuxX4r6oODaYuayy
	7+u5wVN0YRHuJHwrPuNwGf9pHNfm5lJsHnaNUoItyAjJkzqvjl2rJB7t75bdvi7WFy1/cs
	kdSgxus/i2bStviwKdUwxl1ccesP6DM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-ABViVErMMFeM-sRTo1Aqlw-1; Mon,
 30 Mar 2026 11:16:12 -0400
X-MC-Unique: ABViVErMMFeM-sRTo1Aqlw-1
X-Mimecast-MFC-AGG-ID: ABViVErMMFeM-sRTo1Aqlw_1774883770
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90BBF19560A2;
	Mon, 30 Mar 2026 15:16:09 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3403119560AB;
	Mon, 30 Mar 2026 15:16:00 +0000 (UTC)
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
Subject: [PATCH v7 6/7] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Mon, 30 Mar 2026 23:15:02 +0800
Message-ID: <20260330151503.670415-7-chuhu@redhat.com>
In-Reply-To: <20260330151503.670415-1-chuhu@redhat.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: z9AhDslo8SSQOrlMg4VBMm92Hzt_iGrvznnHTCiEx5g_1774883770
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 688A140011
X-Stat-Signature: xm38uk7fk8x97d7brfsgcokz75xons4c
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774883776-704369
X-HE-Meta: U2FsdGVkX1/y2JDUWAc4KNAOq0FyquQwxBd6/T4viTi/RxgzGQyncZpGRvzDNIxOFDirQR8HuxpclkeQ4VvdFXww6yaP/P0Pp8O+USLTPDfRfYcrg3PyfY4kWTihyUnIlPoNn/21ye40jdbHH25Ww+gWHG5QC8+KnKCl1IM128+OcyqEBfDJqn84x8adQKNGAO16YqPImZppy8vjW5T6MyicoVqsuwpdroDf5NSGAGIDKvI5Ix8W4Djz1kFcb9smaB6Y55NPyOH/70NHE8XtSLURvBIb6JlSiUs0rBYxQCSgvWTugsHY222vs0gzyRTlTdAj5V4Pj2NoPd98uWFr7cbT3oiqzG+1PG9OFb9NYIx8IjnMttrWjjrWoQnVCQuQZ1N2hZ4pNd6NnD6NHS5IdRQRKvm3WLVecu9emXDk9ANYnaGFvadGrMtGtZ0qdOtGc1CYun2NI03nm4I6qW9qmmwRq3e4edNON5kuC9oSr/80c0Dr6s7G1O2eRsLceOh8FuMCVTXZr9lPOkQ5HA0U3vUvMohX93kYaPGCWf1eacpc9myKK1K3LjWOi293GC1FUEd2L5keifa71vsHS9S5HAWGYFBIzl4tLvCcVR3ejZi3lbFR/mCqojvRsulTW4vF/eD7jY5NbhkqcMBmSxz/+COrRBmhRKvMhypH/MO1kCaFkouSHCZUg6BSrrVSIyFyAgMxqg+TDLqGMOMeu/exSY+eYNO6bcMfuO3fkz2vvzzwsLFE7VZ1NNu4gTv1Vw8+WGXGbeBKADKm28SYHSb0skSo7wNf3ZQ/N7U6gIdCe/LfVkrE4AHDraTXdZq2au03bsmJmWzfo586hTcLSCvCkV3afbpeOsr6e7HqZ2S2sflK9dUpexvu60dsIpXywgXKB0lGVXquWM266OIytFP/VlkRcZhZz4s2mEq6vc8fC26kyiXUSnXAe6hAPKLvFN7BbeuNrLrcPkh/FBKYiQa
 MjU1mWna
 1LogESojyLvuxKOAKeKU/OgTV9TxGR64rjuU3CZnZxMWbW1g1fxeRhAn4KHJHrc3YE1TbTGz/GF6N1V377dUV+ZxXzfpEmdAjgtrtKi3A3pLhDrLE081Xcw6JtXX1dsgot/0CQVwxAqZKQ3Tus/60ahOB/jZshxncLsSD24v7wfBln5k0UYgIPa2nEQcRLIQT+58J6G2cfyB3fWIO5fO6JkNgPPEFTdyqEVlLhwjSpE9YdFvbt4VQa/YCf/8dB+e4RpXh0h99xrR3uT8/1tOguYgeM0XoMzxejIH7lgcszC3p/R7aGy6uiQNOFRfk7YdNzUBIeKo5WykUoxaT3LrwOcSk0dqYvA52cc4enm630hF3J3IV3WlbUPfg4WaJxbOKLYYDw/bHzsKFbghCjZTCsg3t0pWu74ySJerzlaRM4IF2MmLa3vvZqZPUGQ==
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


