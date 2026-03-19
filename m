Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA90109024D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E646B052E; Thu, 19 Mar 2026 12:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75BE6B0530; Thu, 19 Mar 2026 12:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8B4A6B0531; Thu, 19 Mar 2026 12:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A68636B052E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:08:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50E091DDA7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:03 +0000 (UTC)
X-FDA: 84563294046.28.BA799E5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 70CC240006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h/h5hNay";
	spf=pass (imf27.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=DHn+eWR6lfGSij+aK62gq4sMJJ/vYQq/wxr0guNuctDtFric2coap1FOLcBKT4ZupMOsK2
	+RCWlBVkUXU5WwwdhfXgLXwJ34jYd/75Syl1JW7qarzG3clCKEsHVTsk2IWomqOV9aesyS
	LjbFJFDua19ZdJSUCgo13++8mjnw6Og=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936481; a=rsa-sha256;
	cv=none;
	b=Raqj9EWkrWciyReub8hLSiM3r/cZXPEZrSsdw9F8bW9F3kb3t9NcF6q/L+zhUTyFTLflOB
	k1z30rHeQzAjUl8rPgi4q3RRclR77aAAamogj02+QZkANbghXcL5Y0HlLFJ/xsSBXT0S9X
	F26MslNpF/cTfMfJvNcul20gLXNxRUI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h/h5hNay";
	spf=pass (imf27.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773936480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=h/h5hNayQAOc0GZ3nm4DVUnL4UFWmavI+r+L/JkJC10LVNJt1LRnNn5bNvPcaxi17cUbfa
	TngYGrcyDnJ1ryl4WbzS6P3KXS0D/3/yVNBS1kR1iHa4EbmSWNxCNPMSG1edSCzTkieWEm
	Fp+qavNSwlEA67DJWa7dAhM3sssFw9U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-8cvUmgKlOZ-xXseQPxlJNQ-1; Thu,
 19 Mar 2026 12:07:57 -0400
X-MC-Unique: 8cvUmgKlOZ-xXseQPxlJNQ-1
X-Mimecast-MFC-AGG-ID: 8cvUmgKlOZ-xXseQPxlJNQ_1773936474
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BE9A195607B;
	Thu, 19 Mar 2026 16:07:54 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82A8C30001A1;
	Thu, 19 Mar 2026 16:07:45 +0000 (UTC)
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
Subject: [PATCH v4 5/5] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Fri, 20 Mar 2026 00:06:56 +0800
Message-ID: <20260319160656.1480279-6-chuhu@redhat.com>
In-Reply-To: <20260319160656.1480279-1-chuhu@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: bgAWonkYxus9tOWKV3Mkjo3TonBAkS0yuQ48r_wqUM8_1773936474
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 6n3gmbe4w945zzxonqsoz7qg5apiizeq
X-Rspam-User: 
X-Rspamd-Queue-Id: 70CC240006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773936481-930355
X-HE-Meta: U2FsdGVkX1/PPYJzNEDNMCn1b8hcq+3GIx4atfjQgdoNrRBrCr1NkLNsuCiW0Ayw/d2GYR4xkqnmvW/q3sRM5hhAt2lgSi+Uu8x2qIPMmCTGwyz29dTaonmzncWKnvDrQle/2LVM+JXHcz6THvuIxzrLkFHAabWX7eP4DrEwix+OrHGyh1h1MILOnst2GlOYYdQUj1AljupsMO9YZP6k6NEOcXFomMIsbFSnyJYhl0y28VstzqP6vIviT6jqTRVs3FcQBw/JNb3voa5593qTyrzG9pPtn62sw4I6VszQ/IK6jqkCVt1eS29HiXtiowqYaMZdEYl0T7TJbvlJQLgvdcriRGLxycZSUHk8y3cNQWwxicq8bWFfW3Ny5U8H0hnnj1XU1JHYt7wZvDm7gGMqZzcYY0Qc1nGa4jWBbBUlsHh8jYZaPUfs6PDC0ReUODPGVwXDR9FP4uT8wN+higJ1VNNKLBVzyM15rujYNF/2ISydnYg/jC3qC3bxrRW5orX67dr3atYSjGy/zmJIvXuOATDuMSRTcjZ2kcC08K5QqJDwQjwqnJAd4khFtco/469waMKf94JfhCGM+EznO4C9cqjnHzOZ9VNoVJWnJvfEEOpQ5qjZD5RVjC/dMIZC5jl1hXWOKtYWUPDuptgtMYZ7xHtuys1AIHw7JHeUpmgSilIP8T/4ST6Ylv983jm63h0g2uEzB3NdAM1YBh8OkXIW6vViQXmBze+79wQa4W/U2cumHrj+CqSWcg5GUR2P26nhwJRkHiBW+vH7pqBR25CvmJvXwMOOqgo4KkEFrtiFsAbxZJU+G7uXE9T+zdONpm29Ky3/aTyXz9Ep7RoFFJHVuc6iFb/J9mj542mOGhMEY+tjPO2pzDAQkduTB7Jhgm/GlTSlFe37ghiSrntDxAqk9EHu9BohiM10BuPAVVc0wJjxDtQElVjORuu/Py71s9mhQ9dbm6GBaOwTo051laR
 ql5bi5Uq
 RnfdRMOUoTFDXkGzVRj5n9zfIJDCiECoCG5jdQ9ddyjUe25pPlbPJDVv9wIckWLVHBtFfUGlBgwA2saapKMDTcmqb9lCqB6xdApwUohBGf2kqR7pyptFGMaduqmST7q9qBpjAp5p/CVtAxJejvDJuROCKVnEgefDqVqx6W/56CfUUYtiJNUuS9vCbUMwX3M0u5PvevZSzjbAnOGG8XeqGOGVpK4njkIgyjX+7xrOIzLAVMJYoqseD/EsjvqrEQ2AH4fjZ75JTt1RTFzRzqqD0iPKsXLWiamcU2HnXtWlmlcHV94L+7UqkveJAzUVPiGKSeDL4eG5E9DPXoSARroj8ZuCBvB7J2cv1nTNn1kEtciy/WNMNvGSKD3yhrUCrfQPTGBEk32WQJJdSkeq0A55FBpZArNWLjvugTjTFfe40GuClkh+ots3KN2qgTw==
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


