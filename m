Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BFE105A589
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF7B6B00AB; Thu, 12 Mar 2026 07:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083396B00AC; Thu, 12 Mar 2026 07:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9CC66B00AD; Thu, 12 Mar 2026 07:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC04C6B00AB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:41:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3894138E37
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:41:29 +0000 (UTC)
X-FDA: 84537220698.10.CD8E3C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C580620002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:41:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ab1wB6y+;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FFU11Mi0bBXwJKlMBJvhw89oPXuQQ6MnaqLH21R0oM=;
	b=vGQo0WH1e09xwdF8fL2hcvfV+OzXI13HAjS4cQrZ3G3OSmZLgBLbe3C4NU7e3Hv9uyaMoD
	gv7p3UR8m5Nd70w/s1QlzGlSHf6I09aqGhr9wNB1Z6kdBNCPxKtPQl8iM9eeeGnHB0KIBA
	tiXJPaHRPEYszP8bJUPw+HPXWhYdNNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315687; a=rsa-sha256;
	cv=none;
	b=bvgBqIUR02T9Kw8Dh6eJz8crKZ7SfR+EV0AkALNycyqLpfymP4nBO1uTKSgnScZKbn6YqB
	KuzGE4AIYsL43I6JPkF2ysucrkjjlEUOz6nOwxrDtWWnmWuLrDGlvamBAdM9gI+7MYXqBj
	jyCpF5ARkFME8H30z2ny8PO22HpMWTs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ab1wB6y+;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773315687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3FFU11Mi0bBXwJKlMBJvhw89oPXuQQ6MnaqLH21R0oM=;
	b=ab1wB6y+ki+kF7klV4XbBfWKXuJ+Zu4OEY9wSUKVc9nqXUM+MmdOuWIyOMd+v+K9Gcqjn/
	EZKUvj2wARYtt1LG+cK43cg+MDiKF2HAfvcvmhv+VszWx3BAxGAkoxNiyaaP/6xu/O4gmh
	3QAQz+CeoFTFnhlwOfyV47jIfqiO2KA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-VTST2Oz3P6SVUz4tR9q3BQ-1; Thu,
 12 Mar 2026 07:41:24 -0400
X-MC-Unique: VTST2Oz3P6SVUz4tR9q3BQ-1
X-Mimecast-MFC-AGG-ID: VTST2Oz3P6SVUz4tR9q3BQ_1773315681
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6072E195609F;
	Thu, 12 Mar 2026 11:41:21 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D58C180035F;
	Thu, 12 Mar 2026 11:41:12 +0000 (UTC)
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
Subject: [RESEND PATCH 4/4] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Thu, 12 Mar 2026 19:40:27 +0800
Message-ID: <20260312114027.634559-5-chuhu@redhat.com>
In-Reply-To: <20260312114027.634559-1-chuhu@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: x_xVp97rb_cmPVswXH4DRNMdi9qF_Uup4MYpIK62FZk_1773315681
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C580620002
X-Stat-Signature: rsxpy5y747yups74zzpgujy8rbubr9gz
X-HE-Tag: 1773315687-450187
X-HE-Meta: U2FsdGVkX1/EzXPEACQllvIAGe0OdCeVKibE5U5soofewOAB+0RpFdOOiyKKCsNL0dGT0/W28NU8qv0vK3a+JR8d7L76uv17N4A7ZPOevzoR1EJcRFXNNm6QHtFgzibJ9DyMPdsxhg0+mnVH9QuGAcNWr8m//l3lWg9PHyATAxkJOQsAqYFGiyLBkxZb72Sqz7hGS9R/sCR3UVFICqjirLD6xKTnJOvgYpMCjfA0SacbUkk7N7ajS7gq5UqC/nnLyNg+tOlzHZ/knXrT5GmyA81WFEQoYffa4sS9mGzkvP4hUPGz6JACcrmbXfcNbwTW9IWvBQ8fSGMoLDiNBlhvLxZld6zZN6Z6qB5PvDUqqwB3mQxIc/2pIaGzha2jiV3VUKCfLOf3fdTGD+vgNAf27/S6i6c0ty/jooR4BJxAUk0zE3C0Hk0vu0z7YDzFh0xEEGXkm+UTBuKuEevjEQ4LqvXEUyvUBiiAzwFAe2B15ytYdvMnxObzyJ7LSDWunVLV8fxejEwUwwvxyCUb7JyKurd46fymqCsWQl3Oo3zPAo6aTRAQ2NlUNYcu82GQ2BYwsRVuN8oAoBRC4SaWD+Zscw6fe29zIR3WqApNfnshR7qZGjEYbKXvS6KJClo6rCFvVikJ32BGoECNMfSLK/Hxvq9x6eO0yyMYEwKLiQJ4I4ONQNm2yBY4FaJjpcwbBPZB1H+x1z7jEEfvc807P6V7wB4NMg8sBaayWesLdkjbTG9oBAvqLxvFr/woQ4zG+E9/YdOH1IG/8DcuTH0TuPhS6TYqS3p6u4aYsiR30yAak/SF9T8BMlpGOKZX6OMwO8A5paPRdVoarrbcWwPjmwnMvdI3uvgb1BdMZ+mgndFs7EdsmF2fjVNWNhS5JLzkY43MQggkrVh3qTWG59a0Ueqc3lPjmo7+VhUqL1Dm+TUJXm3bvzYGtOU+q1xuE2IYGtv+tdKuN04bEwNwtM+GzJ5
 RQJaCZ0X
 4Kecuzgk3pqfv4vs3IUJqACcA9zZk7EozCmchdbtj4I/VfdWMvBlki/sTyQG2BxHnATtzaMU6nFVvczE5+RpeuwledgYLLpKXaDef8OiLn874fR4MJF52Y7VPfd4pHkb5HAQXu/C9ktFAy3QEhjDMHIvCLvruw6zSUPUC5gc43dZDLLV3hdanuuK/DTYss+RNirEK5newt0/XSir6ax3ufjjPU4lu5/ZMiBQFqw9AA4nFzPRlFuHs/T3fJoNUCzuciSmTjokG2+HrWnCsXuObK5V8GeAwxsqmNYDfI2GDaCguZS/I8Bnwxc3W4PGTw04weY9blrQLy7V7L2Xdph4DOk2suN2I3g4GABLBznyzNSPdsuTs501Ognv8qvjRMfQapm9TdikzMFiBWnc=
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
  # 1..0 # SKIP Transparent Hugepages not available
  # [SKIP]
  ok 5 transhuge-stress -d 20 # SKIP

CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/transhuge-stress.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
index bcad47c09518..76316696426d 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -17,6 +17,7 @@
 #include <sys/mman.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
@@ -35,6 +36,9 @@ int main(int argc, char **argv)
 	int pagemap_fd;
 	int duration = 0;
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	ksft_print_header();
 
 	ram = sysconf(_SC_PHYS_PAGES);
-- 
2.53.0


