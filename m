Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C3DF105A587
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748476B00A3; Thu, 12 Mar 2026 07:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE8D6B00A5; Thu, 12 Mar 2026 07:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD0B6B00A6; Thu, 12 Mar 2026 07:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF946B00A3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:27:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2EF6C06B8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:25 +0000 (UTC)
X-FDA: 84537185250.24.10160FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 219774000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VFnJKVEt;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FFU11Mi0bBXwJKlMBJvhw89oPXuQQ6MnaqLH21R0oM=;
	b=DWqIGFSUH8fYjng/ixFAfu22DAJbyUURBo+50kQBloRG5gsDLusq5RpfhkRzqwZJ3YLa29
	H/gtX5jeZEmBN2/kimjLciYTVhoBPNDq6xBKh0k0mLZ7Z6Pgi1POgTg50d57EkwyLrgj1G
	nuRfR5DmAbso0mhupYe3CYgl/hOiUJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314844; a=rsa-sha256;
	cv=none;
	b=bY9vZ+9V+M6s10phCFrckDrh5a5QzgyMdhSBt6iHvYcv75BIzqKEme+YMF8DLe7r4GqWNm
	MXlqWuct0O6+hdpGhKg/0UZ5RoSt/RhisqFVBifH6503s6r2qS+p5/nL7a5PoqdYfFORLN
	PDynQHVQx2LR8V5VHcENTqZxZsbP/Ek=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VFnJKVEt;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773314843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3FFU11Mi0bBXwJKlMBJvhw89oPXuQQ6MnaqLH21R0oM=;
	b=VFnJKVEtzEiGEReY0rdI3BOWR+MPtEmWbpJbxjuPFfMtL0hnIt7YMpC3BLyTbZcjSs6Bax
	KynGpQbdYB1xjW78H2sMlayE9Q/BmwkV2VYpcuOHz0Wuzen0vYoOsNsS6btRfkrN9r57MA
	SJKig2IitOWopwZT7fZiWCiiU4ht26I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-tHREChPZPU6BNpVLybN1bA-1; Thu,
 12 Mar 2026 07:27:20 -0400
X-MC-Unique: tHREChPZPU6BNpVLybN1bA-1
X-Mimecast-MFC-AGG-ID: tHREChPZPU6BNpVLybN1bA_1773314837
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A52E180034F;
	Thu, 12 Mar 2026 11:27:17 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AD0A1800351;
	Thu, 12 Mar 2026 11:27:07 +0000 (UTC)
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
Subject: [PATCH 4/4] selftests/mm: transhuge_stress: skip the test when thp not available
Date: Thu, 12 Mar 2026 19:26:12 +0800
Message-ID: <20260312112612.633138-6-chuhu@redhat.com>
In-Reply-To: <20260312112612.633138-1-chuhu@redhat.com>
References: <20260312112612.633138-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: v0bgPTeyRL26oBEpzMi8R8Jsivj2ebZ78rveoJ8CNdw_1773314837
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 219774000B
X-Stat-Signature: hdr9c4r6d9idz7nit5r8t733qmksqun5
X-Rspam-User: 
X-HE-Tag: 1773314843-113921
X-HE-Meta: U2FsdGVkX185egdMkdZywy5PAsAZ+W0wVSmyLQP0aYML1uFApBp/2u3jnfbJQjQysoqwbE5127ChqEUC4rU9UWHsY0FWT4Mbb87FkGP5gVAOjeAcHWFivq3rnBtQarRtM16i84G9ptiJ9kgpKr4YvZtt+Qm6XLhCfJgbn9eiK2RcmBPd2nbwZLpo/uRwd0pRhMMiejr5B5Lfx6VBou46dMlBWn+CRChwbfe3uO9pTDMHsBFTodVEGCI+J/WB29hHovAWmfN1uIihWf4FQm3tseNLnzeNMl1eMlkQkB5fqKrURhQx+ss4MBMrMgDAZqe9zYArB2/+HAGpcP09/4W4iuCDO8l5yQy7d1A4kkkidOOqzdMv6LwdY6QDL0n+jXh9nwtHS62w2tbDtEW5L4bkKbRts6+QFSq9MX0/7E3atyis1AqwxGI/QjLnabKWzI4uVUMHj7uY0x8shb43Tyxz9oQl7xU17PZqIZVCtbk+Dnu6lTPVL/qLgiebqnsAlPNgCUwFYCiN5EBTECifFVnNMsFsax2V77AXw+5kOmRylPthFKNP/nI69hJzkQFxVfaEzavWZ0uKSUEy74cX8dZSfc4d9niz5AYBBqCW3oiRPgH0X4u9axTG8Ak71AGz/4hnNvHQ+Tr+QCy/XvprSrjblXslybqZuKuoyOgIY/XqWZCt7rKD/vFlEVdfCo4BW8jxCa3P752R0Yo8ySS14ExaXtKrw5JcSkWroC0QQ08UVJk45HyQ0no4k+VH8B2XiH6/KGOuBOsYl65h19W39MsQq31L2nyQy2I14vuwHdInF2bgz5Dk47WYciPES0x54aUbd24ogKpQhAwI3VdrvCMVm+wfBnIYoDPwKhx9JcBfPvi0q6bejbhRnFl4y9r+JL2JJrWZuSOBUkQHz/hZLkbKFLXZqqRCy/dR3/G3DHNM+/ObdeHiuOmgq4JkdnnSEznw6fTuwSvjo9Nr2UPxNDf
 w7OGySFv
 LXJWmqQqfoWAQCgGr6DNSMpRXy7N0WNj2R22xupqu5luT05/wO28dmpvOLz4MaeHyEiWnFZ0Zc7CK5paadPwJwIVwNxKLRUaeLMW1nM472PDIgR8DqTN7BFpWzeKVPvxUp5mVaX1XVPgZAufHODwTRvVZMlHwpVk89byMd3qbCWHE8lPZGzh47D4AKbqwGfRFCIoIGmZ0V0m7KP8eHZ/4dX3eQKABubrpWf7mJzs60A14dCbeuyhuTUUPWnucuFABU0hl6xumsAnMt0AYiT/htLkfotPDJ3stJrNvrZQVGCY2E4RMxBNgBvy4R6DfLpyEHqyH/dDz6iE3pHN9d8aKI6ihFSraOvH8C1SnN9rFVtVYTuhHYkZIkxme6WN2qXrQVmJTXXDyT4elB+w=
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


