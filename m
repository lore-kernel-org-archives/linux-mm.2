Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 743CD105A58D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51C46B00AA; Thu, 12 Mar 2026 07:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5E86B00AB; Thu, 12 Mar 2026 07:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C6A6B00AC; Thu, 12 Mar 2026 07:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8D236B00AA
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:41:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73871136DF1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:41:23 +0000 (UTC)
X-FDA: 84537220446.29.682E7DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8BAAFA000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:41:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IASn8e49;
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwjhJxQ0ePsKl4AA80EzxONZrokAXIixovBJhdLwa/U=;
	b=lcdwW4FBNwZWp+Vmh8qJc9Vtr/5fTQktAczcrKc+4Dfbg+MEqkWhXveX0kQAyyyxJmoKNk
	I9h1aE4iEcgGUrU8nzeBXmAzDgIAr1ONoAEYyage8LSYqiUl2PyXmX0uVY9QVWu6otpiZ1
	HSpDtBwApTY7Ygtw/yB/EPuHzoIruL4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IASn8e49;
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315681; a=rsa-sha256;
	cv=none;
	b=RIci+QxeJ0iVHMw8m8jHhabARWXaSrzf5CmHJbW56V0SFj33Fc7q5Ur8SYA4x4Z5zW7xMU
	EQPnfXyEri1/cJdb95tTFxfda834LEE1tD6HgYKds5FdI8CzqLQ44QXiaXG8ld+xxe98QK
	e7WbtVZ/H+GCEq6SfED/pc3WsBK7sYQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773315681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XwjhJxQ0ePsKl4AA80EzxONZrokAXIixovBJhdLwa/U=;
	b=IASn8e49fQfVD9FXH/jm64T9kDyceWsdN6WjfDKhUAodNj9P4OqMmHE+Fh3/4iLU8rQQam
	0E4J7nkZ4IdvFEXmv4FzSnRs4ixv3Rvnce3dqhdSUp7q/4anjASVsV15nhWJfKjw+sbG3R
	L+V5irMOng5py79QGCANc1fjbtOPBX0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-43TIW4ZPPuWWDee0nSai2w-1; Thu,
 12 Mar 2026 07:41:15 -0400
X-MC-Unique: 43TIW4ZPPuWWDee0nSai2w-1
X-Mimecast-MFC-AGG-ID: 43TIW4ZPPuWWDee0nSai2w_1773315672
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1D8F18002E7;
	Thu, 12 Mar 2026 11:41:11 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B50E4180058B;
	Thu, 12 Mar 2026 11:41:02 +0000 (UTC)
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
Subject: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Thu, 12 Mar 2026 19:40:26 +0800
Message-ID: <20260312114027.634559-4-chuhu@redhat.com>
In-Reply-To: <20260312114027.634559-1-chuhu@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: lm67P8Zw7YMMAE_K6LJuJ9EtGWRvXu2zIT3Au2YEWr8_1773315672
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 8BAAFA000E
X-Rspamd-Server: rspam07
X-Stat-Signature: qzkhx1ku3w3cis1txyoa47j64bdhomo7
X-Rspam-User: 
X-HE-Tag: 1773315681-16775
X-HE-Meta: U2FsdGVkX18VNhFCvKVkwninfaqEQA+vkev631trDASPsmOB7OCQ6knaR1yju7RAN0i7JU0I1OnXuB8Ha2B+Ozi0xuSvEXmpxdEibkAFYNT9Ky2epnYScnY3tfsKhhOS4CODHZmzj68N6IQXR3QlwIzt8M3JvN5Jr/JARKkpKyvaHbtvaqSGwkQt0gKo3yRDpJmnVagd5+4VNc+eyhmTfutzlScYAO3yuLNKjlX3olvoHKUahjUiwt+tYb/BZftqDrvlCdqi2SkNVgnP4YFPprYTLGe9cRK+eNn8qmSVNycQqG8Ud/ZW5u4tiikVHUvgYO3t+c3emwLVKjNbqZ7eonpKJYnnRqynTwLLm7BAjHM02zRhQ1k9LSfiig19ozwRalHm9MNpETJ2XMTRHhwvEk94NvNTy74AblLNW2lfUTChCFr2QAbKLLTrqCt9xUqCJ7xbPIFJqPgf6S7a5Ehv5Eb4zJlTE4Lz/+7cKovp6bJY9N1Cnf4L5SdUdg6mlwK5jC441l/Af0XCDM+ocJF+IzFp8+vzrDxqRpqIvx9vyfr5scLBAYP4N9hygE05jioSznkphvsiUPY8FG2i/1RtJjzjBU/LTjx1Js42A5TQH7q8NOdH3LuVybmIn7kRC9gEyPjBUpdrKb2IgCGcyjBj1aaaW4WbKpbxEFmW9/F+K+FNcikaMVfm/Sya+DAS6ZESyXjAbbAPz7Ovu6nOSeMzZTXfsZncIs9fd3pWHQeNnDs/PfQNJNEVkI4IX06Tkeav4Je6/ohNhfcbhPkp7dqwdmymDKMVF8QJHVvVm1jv47TvtWR8Yhd6l6EJPc20FqvlZMKTieumvPZfXntdF2JZ8Cd8LAItZ13BxGRllj5H0O8sXaEhPqjK9uqaJ7OwHbq6/A9EHyt7MM9y2HDAsLxpA1PhoxIX8gAX0qwyluSL0q7bCmFoD2vdIev3TeBw23a0Ju7RNl9Jn+d9kYa5M88
 8nTPhhvh
 gZ011DABzOeR4BqTxCP6q/sb5c9zcRVr8PptmTv+7XqTIkHlYuj1GMgdgwYoDapItjMI12K5BtLYbSUTu49ZYV6jjsLRoRCMRThRKW5bAs9XjVkwhLwe6vwtg6KhKrRlbEFsZdDncSYjK1VyQjBgmNkeEsstxWsrmtOkOPkfIi1vigXA+0gsZeTN2+7ioBa704MQOvt8zvbOcaaw0MlVz+jvaysUgLfviASQIeMnsh3xuV4jFiDzL2tiljzOJULB3675fBsWgJ0daJJ/oGVxhc/9KfcRA8w2iNysgZtcvpy97OM06plMnpS7zAa68MmmtegKRkehk7xtJ124kzqCEXG78ZjVUoaWs5JprozxU9xBqMmEwN6/i3Kdx3JPvOKT5+0Cfmn5Yr/j1dSc=
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


