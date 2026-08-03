Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A294FC55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 01:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A986B007B; Sun,  2 Aug 2026 21:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341BC6B0088; Sun,  2 Aug 2026 21:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2304C6B008A; Sun,  2 Aug 2026 21:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E369F6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:31:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA9D1A05AC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 01:31:57 +0000 (UTC)
X-FDA: 85058231874.12.BB88641
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id A533B1A0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 01:31:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=hHbdq4au;
	spf=pass (imf19.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.204.34.130 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785720715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=09rkTuMDDVqF9abH3X0B/t3sherUeOedU/4OBZrumvI=;
	b=cy0vLENRAHkyOzN7uQXimeKKVT/khBIZ2tVDDKxNuPPFqQT6+BnRYKdXS+q24hTBmlnvbs
	AcJitIvW+fcT7MloDcgp/ElOTqd0s3kQUYva1Ejj1ZkXMf7ArsgiWR5qzgJcSNO0G1HIYS
	AauMAF7NHQbVHpQLAwnm5tcUt+rxaxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785720715;
	b=ht4LNDEljujZg7GdQq/OHLwkMRjpGnQkq/BqGAJ2qXhQmdGDvXIg6e3L4itz3kQ3zp63i8
	kFyOO+cYbgk9MHpXNRJRj7yfGk0FMx0kkT7qVqtEiK5sL1hPlCXrn1RgcRs7lN8cnJwJDJ
	QFg2kuS9lohR1IHG/ysCy/DnxmEO0X0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=hHbdq4au;
	spf=pass (imf19.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.204.34.130 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugreen.com;
	s=pkvm2402; t=1785720654;
	bh=09rkTuMDDVqF9abH3X0B/t3sherUeOedU/4OBZrumvI=;
	h=From:To:Subject:Date:Message-Id;
	b=hHbdq4auDq4ewFwLLVu+AyeTdfVnrigxl7vWKGimytBHudjH2RW3EPUayLjnyYBjL
	 izbtHsO5tknu9cC7ifwc99GppE1AfQQqnuQkDq0h19N64eHdFJqCcAsq9j/RGreZpw
	 8KCSurEsSxwvtQ9k06EV2kzvjZP+A54rTiQhNehY=
X-QQ-mid: zesmtpsz2t1785720645t91937be5
X-QQ-Originating-IP: bzQf6HnNiJZYwmOVBHh+2fwKuDqnUpmM2SuA4MLcqjQ=
Received: from localhost.localdomain ( [113.98.201.214])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 03 Aug 2026 09:30:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12329309936361500638
EX-QQ-RecipientCnt: 13
From: Warren Xiong <warren.xiong@ugreen.com>
To: akpm@linux-foundation.org,
	shuah@kernel.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Warren Xiong <warren.xiong@ugreen.com>
Subject: [PATCH] selftests/mm: read memory information without popen
Date: Mon,  3 Aug 2026 09:30:15 +0800
Message-Id: <1785720615-5826-1-git-send-email-warren.xiong@ugreen.com>
X-Mailer: git-send-email 2.7.4
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:ugreen.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MvEJ+bjyN/5DUN+4NULqj7ZVA2R91Rc9YXEuRgxs6ST1csaLr6YVrMR+
	beVKgz0Og8dFqNSOdTqzrJkX6EikjfyiipYzLI9bojkPGVGzFvoNCOcZYBCWZtukavsf2lT
	MBc5eSLnzjWZawWRKcEIWFxADhthBo5WQiCHgTzfouGMspuqxgMnlqOBw+ad83g1YNyxQBX
	ySz9noUNkbG/t7UDllFyHNcYFh3qCk1nMoSCt10R3T6banwAs0Ftb/Eqllc2ubvcKVL7wZa
	/1Gwei6PWmx13MBG4OyrU7rwc+nVx9QfNeKcIDHOWCDVpTDkeHS+vpL1NHN6GFFkA0dyyZu
	tbvuF5R/2DmOFzmLAz7Ti8FTdKt/5QJ0cwZhRW5kGdX3Sq+aAyO2JE5Q3DOAaqypr8MBxRR
	mxhW1k3599TRqb1I/aIjDYnsWy9OCOn6W/p8TB6wr9123oPeZ4tHnm8tGRslTWzeYdrfxon
	S/oUcXWn/yTFsAD/eN7hBXvjggHDFBdXEA7mGeQPd9jMUsaQrNndJa9KHfdxTxs1z00NDgk
	4dX4XCKdvH/iPMtBcVZY20zyVZLTlwaFUL5l2FwUTO/DmWNwZv+DPAio7Ac6MaK37Dojeaa
	v+hMTr+KkzmXOXAEjGz+lKaAnWTP/qE6P31EegVBbI81JgzS0VWr0YSTbBOMFeVAeNUaOaP
	7HO88LFLkuVxC9fmRpO0E4nfBocD3A0757YxfQazuLeY9+fpokTaa9ISCIQnko/EFSwoPuo
	MBhTASxSoY7mfssyhmZAL2rUELWSrXcOP/9wHZTr9mkcxzUhPqHl6aARrsurIjCe75Pgupp
	N21M6PjG+p16JEkyR+chdzxuSJYqYUVmZKjhCSbk7iwtYU+f0crwjOxMpOgJM3PuK9J2/GJ
	jZYKlzSzO8UPkX1kMmPhs/CzTeSd3hNK/HLBGI10lPojySKAQSTuxQbp3Iq9YlYqb2G86oP
	6qSKbWN4vGbFSlq5d1WOYMihEucf00gEombfpcZJD6+gKMR0DE3P43ZGEHAgRxWmKQ44yPR
	UMYLSO0ilPk1p4pPjl69GMffJ06EG7Gc5T9UMd6zcfTrW/loktjOAx959pC1i6IG6jsiR4L
	8fKzCqU5KE6EP5zZdhSrOg=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A533B1A0002
X-Stat-Signature: whwxdmz9ygiyxesyzuygcb5wprmejx5h
X-HE-Tag: 1785720714-643216
X-HE-Meta: U2FsdGVkX19yYhCfZZ7XC2MUpAd898J3MpXCj3/mrLFaf1WaiBLm1/v/jAo0WLH7y28xGUYgrd1JHY8kqtF0e9HTH8ZnRXYGnNuO9L86XnV1YSYorvEc5r72/zMzBKTVp0HooNnSyVba7O2/lkjfQhOmR2Pkd0kqXA4TPay8Zu3pgA8931g5iyjUtxxPVzt/K6LEhdSXpUdcLn8EIzOj+vn/xe2rGMbCDailOzbxcFGjeUCV/FjNLBC+jL/dVeL5gaIFfw6kolscmOhL6s9IIdINELGuRXSHWl0IX8qSUNn0khZW62N9FkDOz4AP8bpy6flzekqd99acp34x3UC44OIWpwq7NRT6bGoaw8nIG8XwfymR6O+GTUNu9ZiqI8IGq9Y3Mb1nw6DYKlfSCHss9/iBcZoWttK+QMwidMzTC/22dtobKlrsgIpPuVjOiqJDkqluFV1D0NYNMxDSQzoaUE8/QyuTbItdVGLpIhykup3lx+x4bYYUyd17aSBMdHRoZoiqXSC66Y3UDIsUeoCTOQaT9xcIeGYHBH8Vn3IAJwExaGEyaDumOLifRADC4iqETgh4xgTRUsNRz16VgP1LEu3bKL8a/uNh1w+bJiVKTbCjTJTToxJR66gqljDPAdG2aWHPh5/0r3E1tPi+VFBguje7Reqb0wMgGbBjp+A5tL4cMZZRgfXRiwS+yiqLwmtEzu8nJK4X8JRpeGl2WrwqIhhq15Fb82Jq8JRlpQjWkNGZoPnRC2Qqo6Ah2puIZ4fYt2Tn8Nc0pGo0dUSlAlgLsIWrTeFvoAlfFvlaHzQkGN6VT3D/6g/IDHFyPmw92auqhJ/TlBV5Q/qh62/TqW+ChMq9KT1MGhB+BQRhOBJpzqJIaYsmE1ibEm5h6BoTuZ0CTz3Ipm6eTkE/nqxNen4PpOFLjdYHTe1bJN7d0l4SNtV36iIYm1r7WYPYesYgkEK9+UzBKMBHvhkWb12kLa5
 00pOzO3m
 CgEZ8WrludxtwlEHF+ZFXuRej5ss6lMp35FL0ZJMTCkmaTfGynj/M12OVIOWVQAAxNOKs1qWRJT0mAjiW4Q+BjuoDVYPKtysByKPKeJEvIvR8cLBdAqTL+1YdHVkYHbKSDFoo2I/tAJYvxG4Y6vU1CUIYSEyMnbYxLtyKtP/IG/Kg8NndZ3mtAcfGg5EIpe/hN8Qar5ZLpjd9hh8l5S3Erf71UM9idmaa07OYKLKbJx4BbTF/sB8RRNm2hmmQ/59yqDpjmKrhwqOsVfnX0mB4lSXOiKjFrASN3PW78frNIZkV6dHOW6MwxA7Gd7iant4Wf2ScPoU4GRYztElCjZa3yPKZtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

read_memory_info() invokes two shell pipelines to obtain MemFree and
Hugepagesize from /proc/meminfo. It does not check whether popen()
returns NULL before passing the result to fgets(), and it does not call
pclose() when fgets() fails.

Open /proc/meminfo directly and obtain both values in a single pass.
This removes the unchecked NULL path, closes the file on all paths, and
avoids dependencies on external commands.

The compaction test continues to pass after this change.

Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
---
 tools/testing/selftests/mm/compaction_test.c | 43 +++++++++++++++++-----------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 5b58258..0df2000 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -7,6 +7,7 @@
  * allocated.
  */
 
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
@@ -29,30 +30,40 @@ struct map_list {
 
 int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
 {
-	char  buffer[256] = {0};
-	char *cmd = "cat /proc/meminfo | grep -i memfree | grep -o '[0-9]*'";
-	FILE *cmdfile = popen(cmd, "r");
+	char buffer[256];
+	bool memfree_found = false;
+	bool hugepagesize_found = false;
+	FILE *file;
+	int ret = -1;
 
-	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
+	file = fopen("/proc/meminfo", "r");
+	if (!file) {
+		ksft_print_msg("Failed to open /proc/meminfo: %s\n",
+			       strerror(errno));
 		return -1;
 	}
 
-	pclose(cmdfile);
+	while (fgets(buffer, sizeof(buffer), file)) {
+		if (sscanf(buffer, "MemFree: %lu kB", memfree) == 1)
+			memfree_found = true;
+		else if (sscanf(buffer, "Hugepagesize: %lu kB",
+				hugepagesize) == 1)
+			hugepagesize_found = true;
 
-	*memfree = atoll(buffer);
-	cmd = "cat /proc/meminfo | grep -i hugepagesize | grep -o '[0-9]*'";
-	cmdfile = popen(cmd, "r");
-
-	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
-		return -1;
+		if (memfree_found && hugepagesize_found) {
+			ret = 0;
+			break;
+		}
 	}
 
-	pclose(cmdfile);
-	*hugepagesize = atoll(buffer);
+	if (ferror(file))
+		ksft_print_msg("Failed to read /proc/meminfo: %s\n",
+			       strerror(errno));
+	else if (ret)
+		ksft_print_msg("Failed to parse /proc/meminfo\n");
 
-	return 0;
+	fclose(file);
+	return ret;
 }
 
 int prereq(void)
-- 
2.7.4


