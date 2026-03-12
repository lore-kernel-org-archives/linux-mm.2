Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF1F105A583
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799916B00A1; Thu, 12 Mar 2026 07:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A226B00A3; Thu, 12 Mar 2026 07:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D3B6B00A4; Thu, 12 Mar 2026 07:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 533476B00A1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:27:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EDA3C016A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:23 +0000 (UTC)
X-FDA: 84537185166.14.CCD20E6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 39F962000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DLtx8NZm;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwjhJxQ0ePsKl4AA80EzxONZrokAXIixovBJhdLwa/U=;
	b=Ap0/r/gbeVRdKOJmT9btEt/J7fudO8vS5ZI+4/dsKRXh1xDTjHAW6D87rTJCMtFN+5HCAv
	NauFe+xTGD6A6uIdcQ4XiM/JXlKcIXNKa8yw3IP/L/6fApkPlk2Bd9Fo6TGRi/b406C+Z2
	ZRaf8V0Ul+6PQh8GbCSeYDHExQhkN+M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DLtx8NZm;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314841; a=rsa-sha256;
	cv=none;
	b=1qd+ncEYT5ylOpQ5DXOIJCdUe+QMOQe6wjfQ2N5ixpQldY/iJUFp1yP0TaIl+bJW8NpB/B
	6icCVI0ayhf7uVT5CC0wg5HGMghLDCgbAKMlNVeDPoxnN+Ew/YPDwm3z36g+4N2lXfyPsw
	DwsrkHu4Au55CndkMnPr5+0vz0UsU0E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773314840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XwjhJxQ0ePsKl4AA80EzxONZrokAXIixovBJhdLwa/U=;
	b=DLtx8NZmWXwO5nEmiRl0JVntMjk7SxikzGy4PRRUU7MQF6wRGZkrqRZ3EMGO7qr3BKc33h
	OqxF7HXkZSZbySk1XtNwLTCNExx5pjtWu0ej2+vQtbZq1L8C7wEStLEye03M2taV3EAdjw
	pqOu4uZjcT5qiCfaPKm96zHbdGokh5k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-b12x3yqjMaqKW_884GPmjA-1; Thu,
 12 Mar 2026 07:27:16 -0400
X-MC-Unique: b12x3yqjMaqKW_884GPmjA-1
X-Mimecast-MFC-AGG-ID: b12x3yqjMaqKW_884GPmjA_1773314833
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88630193F042;
	Thu, 12 Mar 2026 11:27:07 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 367A91800756;
	Thu, 12 Mar 2026 11:26:57 +0000 (UTC)
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
Subject: [PATCH 3/4] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Thu, 12 Mar 2026 19:26:11 +0800
Message-ID: <20260312112612.633138-5-chuhu@redhat.com>
In-Reply-To: <20260312112612.633138-1-chuhu@redhat.com>
References: <20260312112612.633138-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: h0KzG-mUIzM1fsIme5Dw9K78XtCEuzHK5vUBeHJQ5cs_1773314833
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 39F962000B
X-Rspamd-Server: rspam08
X-Stat-Signature: benspwkfrks56j4k13t6k8pfwd4f351e
X-HE-Tag: 1773314841-881958
X-HE-Meta: U2FsdGVkX1+Hq4FaV3790Sg3xrbbAHm02kqsgIncfLqpGQ981xCXYXZqjuqCn+YEIS51xzrksvxlmr3UiyMmGoVJXPGw63KVVCxOhRHjNAk7IZXLnf3OPsgfaRg5BUpd0r6xCJnOaUfxQXfqSCbPut7xOUvNh6+XBL6Of+lcYzISuRkJim9OdkBq3EXP5AmxpZwUu/d+/MOY5fcfn+IZ3zBvOZQNbOd/syAKONhED7qyisZk8u3ZRMp63R8kSoBHuP7Oc3SfaLZPhDbqsaIJEET/gf7rXR8QkE/khOS5ahRkgKaLEHHvPwsK8ReJsibkFoFXKudrsXr8Qsck0dVjL0Uw8V4xbVnR8pSWLB8VQgARVMh3hOSJvsLjIetug5hjfeZ/Ztwk3ZYhADMpLUjF6vRbcHzNQBp9OtJbri9iXzKfIgcZ2mI/65CbqugZFgwxU1HJChcBbrmgDFVLbsA4GcHiPVUT078r/xgqQ0Vg59JgtaJMGX6d/6+GDQVp4kTXbrKHrUiiy1PB/9KWoaXdz6iQ0uFoQHoQrux+tcbCCkoLv42Jr6ZHIgRQNilw25ba3jFhSZTNzThF5Anu4mzYwBXtC7A8marTPIyULSn08am7SeQmNgSw0oXcwqsV2gRhnu7V3okk9cVANCHY9B0OzW0FYXdOLQKN6knX7d8O1MuxI2FGZq4i+GxFWrSjzRMb7SE7mweftNHksB65ymrheExZr//ByU4rYbMB+dnwdRk28vpIl6C70R2ZF67mbKrJHh3Yf59nu2m5TQFc7Khifi97y12SZXh0I4qfHEwtgbGtH5B5OQfz8waRI1X+OrzeLD2sVfDYvLRmbLtGwfaWrgFX0rZNshKUCcFaEKzymmGlPik3uF8FFvWqxwyNQ9Y+pzltBjRdKZoQZqPnK8kYzy8ta+SNmwXlNTr1V6eXyu+lvb/h76Mw4qVIQpDhDx+21anvK72wjchCydZq8iF
 D7bHs4GP
 7rRY+IgspdxO1cDvXv8zUD4NVb7vOxbSf3hvZ/6EjZs3/QcFPPDIDL3eKqczkje60z48bJuA/UqE3fqd1SHej+pYClniTgC34xZUQkWrOrRxbE2iX+wKIhKC0w8lrszBOt7xzBz4w4ob67MobAJo4MUxl3d4wBURhDWky7kC+QyT8FSgLemhn3R79Fh/VBuCsmRwwk8smBr46dEDCcakmboA784eJhDXtNBNuHEBX66l03SBPMgkRqChLCDTqLjKx91Y01eIu6WDYJ5rWX+yjEvaPHM0E5mGW/D9EPIt3JStY/cB+uyby0HFv2fnIfWGavARM+kOxF9b85y/EA5YO5tURp6awg3jETxOk67Al9+f3wN7wqzSJUR/5fGCHsjertLhoM6oq9MS3694=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When thp is not enabled on some kernel config such as realtime kernel, the
test will report failure. Fix the false positive by skipping the test
directly when thp is not enabled.

There's a naming conflict on write_file() function, both thp_settings.h and
split_huge_page_test.c define it. To make use of thp_is_enabled() helper in
the thp_settings.h, rename this local write_file to safe_write_file to
avoid the conflict. The reason to use 'safe_' is it does some error check.

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

CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index e0167111bdd1..615b75ca62cc 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,6 +21,7 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
@@ -255,7 +256,7 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 	return status;
 }
 
-static void write_file(const char *path, const char *buf, size_t buflen)
+static void safe_write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd;
 	ssize_t numwritten;
@@ -283,7 +284,7 @@ static void write_debugfs(const char *fmt, ...)
 	if (ret >= INPUT_MAX)
 		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
 
-	write_file(SPLIT_DEBUGFS, input, ret + 1);
+	safe_write_file(SPLIT_DEBUGFS, input, ret + 1);
 }
 
 static char *allocate_zero_filled_hugepage(size_t len)
@@ -772,6 +773,10 @@ int main(int argc, char **argv)
 		ksft_finished();
 	}
 
+	if (!thp_is_enabled()) {
+		ksft_exit_skip("Transparent Hugepages not available\n");
+	}
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-- 
2.53.0


