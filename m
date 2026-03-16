Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 833D1D58B21
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 04:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C166B0115; Mon, 16 Mar 2026 00:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58DF6B0117; Mon, 16 Mar 2026 00:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80166B0118; Mon, 16 Mar 2026 00:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6BF36B0115
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:44:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65915160D5A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:43 +0000 (UTC)
X-FDA: 84550685646.19.08563AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7FF2A120003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h8RGzcDt;
	spf=pass (imf29.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773636281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcVcRvBzVtTBY3hfLbgONkTdIQJJ/qtR9JdltENskko=;
	b=IK+x1X8ktDN2kW6bUG+BmdBfF6PdbMOdERvmOYpaBUzwcT2C8Pth2P9jysHXLUy2Yn1dz5
	iE/qjtUqDOrdTdE/9ysl9fs9HQMr2mCWXY7JfQKHR9GAI4VP6Mv3Ax30JEnPKmB2AsJO2t
	ANlSGo/tGrF1bmiacB1tO1Q1/njs620=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h8RGzcDt;
	spf=pass (imf29.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773636281; a=rsa-sha256;
	cv=none;
	b=DbtrzKgd67S8ceVaBwyGVnfkq2+hn04i0mrBwoPtLJrZvIFLpQrTlU/uLC5XKlsBKwF0Id
	c4H107US4UTUwH2LIqhOaAjKxBSjyRHgPpJ0dkmFuRMi++QE9Dusm+mvR7qYLJ3Dn3POc+
	CAqNSs0tAgm/oEno63zueMRriRW1dsc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773636280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tcVcRvBzVtTBY3hfLbgONkTdIQJJ/qtR9JdltENskko=;
	b=h8RGzcDt7PhsX7LD0f/yfSOvrCNN0LPL4s1vFUXiGpoPW9U+6EcukqDWPNrqxKIX9dBxOn
	2In0z6ZDsRtRiI4SJ99NSFcrdUVYOEl41KC7oZ7GS+ot2yLf3mu1nVE7eSRF4UsbCeZJd9
	6vM8OmFlAoKTpTDKYNjXaL/yagt5wFo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-AA6dxcJNMZWoz4jPtcyc7A-1; Mon,
 16 Mar 2026 00:44:37 -0400
X-MC-Unique: AA6dxcJNMZWoz4jPtcyc7A-1
X-Mimecast-MFC-AGG-ID: AA6dxcJNMZWoz4jPtcyc7A_1773636275
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF726180034F;
	Mon, 16 Mar 2026 04:44:34 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F5051955E80;
	Mon, 16 Mar 2026 04:44:26 +0000 (UTC)
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
Subject: [PATCH v2 5/5] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Mon, 16 Mar 2026 12:43:35 +0800
Message-ID: <20260316044335.1390608-6-chuhu@redhat.com>
In-Reply-To: <20260316044335.1390608-1-chuhu@redhat.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: jtR8zCPI12YCxNBw63-9TAziBlVk_farrp6Ny7n0_H8_1773636275
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FF2A120003
X-Rspamd-Server: rspam08
X-Stat-Signature: gqi3gf5q3sggues1f7s4ihiwfw3ida7f
X-HE-Tag: 1773636281-234142
X-HE-Meta: U2FsdGVkX1/tHjdC1QnGNYQ8otfzPcIIx7pvsXaQRFDmna72VCgK+BgLrm3KdMRJqLehvCbKZn7otuZXwvfQffB4KDWaF99Z5XqTlGPp1PvSnnmmeAC6fhZDiMJpuB05zS0r7csJQ0xQeE54+b3AsLNRkyldwhXMNSUoEokDforPUX/266Q0Qf1QNFRHgmYyehmuvXK1lv/BioAnFm+QCxlrH22MizO/ydLyPOKjwZaMKQTXMYmfomT/xKSiDY7pV/e3LEmVlSuVap5HLdWh5XlqQdvZXQNbARrvdjAaPYBQZC0YOYF7TiOObclPeWCYjDedMiyOLas2wbB9qLw+w1PSLTz9QD65GS1qAzcBKc4hWnhBKd2TuAMek207PCT1KDXKm0ZhLa4WCQjhzIum+4mXOZ/1dRIH9/oyISvD/ya4y6L1OXmaewx5w/GrowCxl/G+K9UB0CPC2/PYj9nWXhTpOz1YvnzgEh9iLTbctqlfWBtaEVuy7rCF6UqxAACQC+DG1WnW4tu7l1nWkjoglnRvwDnx54nL/ZOk4NEYJ45tu5iJFod4deLszEOCYOo0CH0HzzvMjwhB6pZBImCFl3aBV2U8TkVu0wGUa3MeOngHl0sdhqLZC2QOyFrDT4bJXFmLgx5/PiRwqifcp2Gu/0Q+lHRb2h3X/VOZnDClIlERPa3O62HG6yQQqtY69BES+OLrje0ntLekOlJLt+pdaOvB83pcd2DNnryHpKfgCuDnam3fuhI0cZrvhZdlLqBE8TIpKDiHDj6zD+lxjswpC1MQ9T4YDM3W/fp9BTzb2WVRDG+GmTjdf19QeCoMZgx9hbyrg+NHYxf1Pz8z/tGqiJS9s4i+wi+DaaGKLinDN1vCNEdBYKq1TQXLSmfF2L2PU/lY2Tc4QtwtseZFavkyb9ugVdqk+BBIekvFEIR8qMVvOap1qb5fquwmUPPd/NyN6k8t2m81xi8b+F3bPlb
 jtKieZW8
 03mFXPcihjd5HV5tDx+VSrIzz/JXl14x/1/lOKfbI+6wwMGNtEbPzpa7IQ9VGzc0r4VODduy1B2rGXzE0ZPdHnBrtlmj7m8GnO+pFsSTPcemtP8OHSmm7r+C8KNiLeZi6pwxfB4CnoIhu+mNMI+rjdnHRTPCGZq9Ih2vMq16+ZNLED+R0uPEoGhWuy4g5lqorZ9QzDxr+d3GMj9OP9xptRQzWibEFv2VOZhTbRNdYPEyjEuFBSqKW3rpPcUephmEayvSHT8VKNd28t0dbkZnto+ZmeEnjy2cYOjJeUZJBBT6G5e7kg0rkupcfohkbJupaLuL6KtQVS6bHaVrkrnhMCEIRTLjN7nDdIuLbuTkPfwYKmnO+KYbn6rNfQOs0dCYefxHmyZOIOpjIuhzoL3F0DDWrJwhPqzfk1g4qjTx6xOALH8/Tk/fZAsaZzw==
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

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
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


