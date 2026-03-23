Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396DAF4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0DE86B0099; Mon, 23 Mar 2026 11:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE966B009B; Mon, 23 Mar 2026 11:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD926B009D; Mon, 23 Mar 2026 11:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71B8A6B0099
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:19:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 214DC8CEAC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:19:11 +0000 (UTC)
X-FDA: 84577686102.08.7041F3D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A82940009
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:19:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TiPblorx;
	spf=pass (imf11.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=6Wy5yvRIjWbVfa7rV+QqSy/ZB7gqJbjnVbbM/oKvbbybrEBUUPSZFO38CVvjszAYOIxnrd
	NaxjXL7lKY6GJPbQJjsJ09fgnsneFmieq2Md43+yA8QbUei9OTylVdjfP5O2KekMIVwK1L
	uONYcEQ0FPfhAkzsV4FzQOzJkkn41mw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TiPblorx;
	spf=pass (imf11.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279149; a=rsa-sha256;
	cv=none;
	b=dVpET3oQiHJ14lBcshYFh06FX6LkfLrQRN2JRA16U4rhoSBMqpxb82muMRPxVDPmegDG6L
	EiBhEjGOt4vONUKkZEjg7lZIPsguFcwCCQKw+XdO5mHst3wZwzHokawyLKOTejp/aKsLrb
	fIl5hn5w4QB9QvM6jFPWD2qTp2pciXc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774279148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5cQUZey16cto7EAHb0l8lICJnDidIXEapbKPGxTzr4=;
	b=TiPblorxlqjKMSX6euv6FRt34szexLU3Uj/hzH6e1Q/geaPkKo4SIAn2Ioo9MuUImw84B1
	MRf8dD5MWuPwskTQlDxR+uiXUFVQ3ehMpsT1oE9s5ugnFzc16Ilsqx4tb18lZCBssV/juK
	jiliBQW27Z/c2OUhkZrkp11NWiJUDj8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-ZWzrsvwjNu6mzhFNQTtqkQ-1; Mon,
 23 Mar 2026 11:19:02 -0400
X-MC-Unique: ZWzrsvwjNu6mzhFNQTtqkQ-1
X-Mimecast-MFC-AGG-ID: ZWzrsvwjNu6mzhFNQTtqkQ_1774279140
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B52518002D0;
	Mon, 23 Mar 2026 15:19:00 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B93E1955D71;
	Mon, 23 Mar 2026 15:18:51 +0000 (UTC)
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
Subject: [PATCH v5 6/6] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Mon, 23 Mar 2026 23:17:53 +0800
Message-ID: <20260323151753.2576137-7-chuhu@redhat.com>
In-Reply-To: <20260323151753.2576137-1-chuhu@redhat.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: uBu-VuFHttUjVExIpjXwiZsXi3WiATBOP9N6iq5b8qA_1774279140
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A82940009
X-Stat-Signature: ao4yxbxyxrjfwgpw5pijx89ittwkdbb3
X-Rspamd-Server: rspam06
X-HE-Tag: 1774279149-371985
X-HE-Meta: U2FsdGVkX1/JM1PZhpnJe3yktzhako+5+0z9ttdgIMqbOLNvww1KvjTJLV8B9tM97k8HzAGHz90GeDCjqKPkmI3cnN8ZMGsXq0EFiMbJMRYvqmw3Z5e1dIni+lDNW5b5bxwyRb2vj7aIXwVXVlWwDChUMr0u6Q2YwxzVkNH727OaAW1YhMUw+B3LbI4GwInYMEcnvtbkflRaRY8GhxGLtbm0jW/TA8DwZFXl1BJUufUl2Uy4HaBhEPBL8rqnRU9zuo9cZm3SKdWwEZcqjnIPFZ8GwZwQb57Anixr6CLPub5Vx9FmdQw9kdgGDqd+p1fDOMFbjnt4TsabqC/Bg/PKCxIdRcAifStNe0L5djWck1nUXdPnxOyvksUMQODNDa4hrpJN9IYJcWGch/BKuL3KownI6dvBXhEGWp3lZaX1XZCcTaFv/cWyBusHEBzpB3qpgZSfFqLfKfWpWf8oXnXjzRsIgPj/BBl2LwlK0em9n4nM3UaEb/Nowd5SbIXILEjQZ7s/vfRuitRnW/MISn5w8sYCPoJCxAy2zib1Mvm6fYgWB9uheDN3DiEHvAMZoMp8PybE329HuhdzxnzmyvplMkbSTCKBroFs6DuiMy7qUl0OexNy0kKP7SO6NKIVmcdbPuZ+I6iqLlrLerIrAT15T8ku42VYn/lp6Dzq8ZiR3vtMFUOdF7Ajed8Z5lycZ8Qknlqoj+mEewSjgAKDCkqjnHY/JaLqhr2FaSJ+1ZzlNBhHUPh8x2zWbgS0Zblc+6/MvpkCzp7lSeg9yBmT4S12HPEKHNTvs/0XIAK+KaW4+tKqQFcp+u3Y8KmooweKP4hPuWEE+jD5BOt0VulrDButCzN5C4lbswPRN2PEG/RI5a86ynPnouh8lSaupUTiQyuzwlZ9MXdGrGDehEJmHgh+08yXIcoI0GEf/s2O3z+wOLqT7yJ3bPtCwH+9Sej8yrENREnawfBITo2CWr+c1Ey
 1BZ+NTZs
 PcG8BLKkYrAaZGEBC7yMABO+q56qXJ8i9OF+iS0JQ1as4t23xXRd8QeWg0GhuUo1IMhh1CGCPv5bNGkzks9fsom04JVOg3YLEsNrxJBxecXnQZumz//EHg41HqQBrs3op8d2pn2BBqUud8FyGegWFVRS+m4LSAPAsjNoSqjVgakRtRlV2obOGPYYuaP7Gt+QW3KQHTF9MNmxaOugAmrzS2ChEhZ3Rrk8SzX/1VKWyPY3bsxkbm/Dg702yIrQ7cHAl5HGuXxU/vJW2Vwdgjax1xibiekPagVFMAMLuW6NVaTT82HRIAu9L1XTFpKfn5UiHblUSh5P3CdFNAaki5wwTxyLNQScGgr1r5mNnNLjmPPXg/H0uXupa1HfgMyA0wjn7el2mGGnzdImOPx32GQFw8U4X7hXmpms4HIoT+JlK9ro0x4LvrKWCSGsKwg==
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


