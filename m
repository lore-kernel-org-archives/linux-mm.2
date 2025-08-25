Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5924DCA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D708E003E; Mon, 25 Aug 2025 10:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C738E0038; Mon, 25 Aug 2025 10:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804508E003E; Mon, 25 Aug 2025 10:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F14D8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8174BC043C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:30 +0000 (UTC)
X-FDA: 83815585980.09.B625A23
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86E7D100009
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ErPRsXXJ;
	spf=pass (imf14.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oaQVHpJSfD6iISTq4Fs9qiBmXO38S9TJM+RHgKSb1U=;
	b=OCm6uxZrFotBqJGIAGUW2VGEbYfKzvv1KHARD4bt/DYpn7j4DVE7vvcsBpGwy0yAtUj2hR
	lRuOTPACv0B3wDh5iyiMyIEzBHn7C7ePKRkfYht7FyvED0LUsyYiZmGGz5TGDTMAJw9Yku
	zQiEVTkGe/o9HeTwbDRMQn8yv37aMEw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ErPRsXXJ;
	spf=pass (imf14.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133908; a=rsa-sha256;
	cv=none;
	b=HJW4tgS84N7jaXRG51MSHCb/yy3mwUVzhPfyB3eehE1fJlx6BgUqZq1XJ4sZcAqtw8vQDF
	Bk8d54lokVjWmEDNvmq34FLsf1/CYSnvediKH74C6e9go7vkGkuEutQrxSep3EH43thR3I
	reZG2xX3XfnY5Y6/RnCBIoOUphAbZmc=
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-771e15ce64eso795179b3a.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133907; x=1756738707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8oaQVHpJSfD6iISTq4Fs9qiBmXO38S9TJM+RHgKSb1U=;
        b=ErPRsXXJ9UhrMoBOXKYzH52eVZkqL8580OvtwWfO2m6BKlrmzY3hd/0GqnA3nMN9eH
         GbBSxA9V8ppEpZH6bHINmvbez5aA+0LP0wUmO1VigwHAplY9u3yFL5H2eS2sRjse1AtF
         36gS9BKFYhJA3j6aXlRO9Y/kvBIu/5DrdC8SKl5TGogDXE8djs5JYIwZqF6GUfCI2KIh
         Wd6YuTqOU6qg8BJO9FjUfq03y3cwwo87b4kC2uT6+t3Cvxt/gNbFXD29EVuLd2IWIeqL
         hE6wX54bfzhJhXn9T5EAIAvWl4UActyVqm/TL1bqLu5gP746kPcXN1WmD26Rm0J9EDXm
         weCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133907; x=1756738707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oaQVHpJSfD6iISTq4Fs9qiBmXO38S9TJM+RHgKSb1U=;
        b=wbwAsDgo9zMz89JwgYbhbHwQyeEILGbZdQFa97F3bdUIyGUOeWM8Zt21n34f386+g9
         QjZU5VyhewhJkWkswAo3q4ldvdPBvo5jUYKGCbA5KcKUe0Z572+ctptSo1EcoHTEKOb/
         VA5TU6VStGAotIEDjJQNzuqhsJbrKY0G0IJ57Tj/gcaXxyZj4r8r815dzQFJs1Rz+KG/
         et/N5lC/8/aX5pRyNELx1I9p2++35HH9tGfSfpW0m/r02blIv3FhSMrmHvqIe6Pgkhuc
         wCgiDA+n9eXrydm9c9saqN6PqQe7RUdl5da1owM76gBzSwTL3vUnCAQkjtlvVfEQvN68
         HVVw==
X-Forwarded-Encrypted: i=1; AJvYcCUrC+nwjirUHcos8IK82wfTfX1dX99QjMLjbds9mYrTgdAYCYFy89JpJRVgEO9Jm5EWEUnwFSgBYw==@kvack.org
X-Gm-Message-State: AOJu0Yxkh6UORSCw71Aul8p3hitWSbJdCKMT/731Ov0nmE01pD7zqGVI
	Jy6Qm6NfyZs83/Y1gWnRBiH0H9PZYN6K7dRiPHqIskEVoByfOe2904RFnGVgctrSwY0=
X-Gm-Gg: ASbGncv4UCk2W6uNzTOy4tphCNGPApeDZamNEV3N579j//cKMuM5bSLAtmehZr71NhI
	gAghgOGfKM/5KvIR0QzTOyjGb+aGAsDN/VSTvCenRiB2J53xYD7Baib0M5lKFXlUM8kJP+s31UZ
	erkUzX3u5rbOsXpnfDeqAIpG8SUbkIj6tLfK4zA+t0q5TTwwkH3gJDpREqraQlHt1KjOhZnsqli
	NB1zREUtaClH9nsOECsEVywu2q8z0g5ERcC6BIEcDRs0xfX+i8RDRJC8sJHq7npORjpcFS3wT8S
	wh2i7HuueHTdOvqeuMttauGhgnbgFBohUVIaj2kSHxZYY6AQWW5YT6dkIWiVk6y85e6l65UPsTw
	SWTbK3hOY4Yu9lXkHptqWGYHdO2/fyX6Hazde+ey5jwqhfHGpVZZvT/4fXUCf
X-Google-Smtp-Source: AGHT+IHxsFJR0AtpeGh+fp7Byt8A1eU4CZaqq20uybUbJisFaBFvzm4Vv3lYQ+kX08WwI2ansJPWUw==
X-Received: by 2002:a05:6a00:1399:b0:770:5544:dc0c with SMTP id d2e1a72fcca58-77055544aabmr8161529b3a.32.1756133907310;
        Mon, 25 Aug 2025 07:58:27 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.58.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:58:26 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] mshare: selftests: Add test case to demostrate the swaping of mshare memory
Date: Mon, 25 Aug 2025 22:57:18 +0800
Message-Id: <20250825145719.29455-16-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 86E7D100009
X-Stat-Signature: 4iqz3ccegsyuf47fw3m4fmrtbxbi4fg5
X-Rspam-User: 
X-HE-Tag: 1756133908-453508
X-HE-Meta: U2FsdGVkX18s7FEPWT5BA+G0EOvtHPz+GfSFLXJF1Zn6cWqS9CMyDq6mENjgWHYVQpKfvVfxn0N/J4P04NPLv45xZc6PL45nVcH+9fhzuM188rpPrpWcbd7G3LUp9Rgs5HEITksWt/7bK4WsisU3gtGH0XFSm0CP6RI7Cave5t/XWt4b8/mTW7T10sdmwcd/qDtZi4BaMonsbNC42TjquBbqa97sd/uqRBu1vx3pYh0LsZpbGl32oyyi4yJhAyXJZCTQI/X3aE0hcokbzoYA/94KN3zShnrwiyQ9p1rK2MRrodL7RelbGS4r3dbIoLZHuRLh4hhNFJSPs5Qir6So83ZYaGOkSyeGOqzq+sB/FWR5EiEubGd5GFAbucn3QJtNfCms31KCVNapNDetN+OPV+VpyUBNzMQoK6VsBLW2+TZBHwaBFZtKTbOhZUxG0yAV/nmAnh2zJQsT+Lx5d3Rd7QvmCIjQL/F71IdiyZJQrJLITgn7tVmmlyayvT0f/KlYcjx08UXV/5g9r85gq7O5pyS+MtG4u1VToxEyPZ8+qikRUdEciJFJpxJoHFgszkfK7gnpG1kR4fazckntK1k1zCyglR/1TszAum0h0N8Bu32vml4gD+kOgiLpUuaooEMXaAnpLTcnWW0YK6XbzJIKmejQyLfGH1BaUt2bfGvNi9a0FbEQe08I4Hr9V/wkCqAFi5y6H+PLLpqxjwZGJTDQsqDFmY9QHvZRwQ6D9/p+g7ux3GOI0G6YNsD3F8PHgFNTyprKTwgwKySmvPfGBJKfrc4xpd24lTGfPLFqAkUd0P9fQlXGzkGKV9WOgWBEm3NekAvlMXVRJjvQuRTHDRPZPCOSs8UPt5JuZ9BMWkDJeA23n7mrkhbClVBa2w87npGtpAu9r7vZhBMgOeI1P5lvqdQ+OKc9cl3c58g0N2b+ff6RnGpRr4HB9UIwuvrr33bJ+iAxkjxn/xm3SP7sYg7
 eBawBuTB
 SIFyI78e7aMcRgV/OdOdbZPNp/LpN9jt21Q2fdYJy5ShANuhkiQzD8DQhX4qU3tcOM9IsexumKMRy+h5kVRPNeWDTDZvHs8tTQ+t64zpIp/F2sdTgbR5I3azTewHV/djYk/a0NE0vCHXlMO+2fRjZKF+pD0TEEku3oq67w07qj/IPAsl4AdMrhu2kTqoLW2hddAZrNT06koZV+DbP/Bt4Zvjcu/R3TSMj9LiLiOZmY1vVsETOzFcP6VykO5Y9fJKcIIQHhYSPSfe2LuBL5qZ+Hnm2lg3OBHyOjYim3bpytWVGprqDGKGGlS9aDt8xOxdlzPLzL7zBFLsaLoVBEMZqbKfUwV04u6l7b1WepA89BhgIT14chuVfEI5Uw2EPzBa68vZzo9/RIWEfLIc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This case is quit simple by using madvise(MADV_PAGEOUT), but for verifying
the memory size of being swaped, we need to setup the memcg and attach test
process to this memcg before perform the test.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/Makefile |  2 +-
 tools/testing/selftests/mshare/memory.c | 71 +++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mshare/memory.c

diff --git a/tools/testing/selftests/mshare/Makefile b/tools/testing/selftests/mshare/Makefile
index 651658d091c5..b0418b8c30f2 100644
--- a/tools/testing/selftests/mshare/Makefile
+++ b/tools/testing/selftests/mshare/Makefile
@@ -2,6 +2,6 @@
 
 CFLAGS = $(KHDR_INCLUDES) -Wall -g -O2
 
-TEST_GEN_PROGS := basic
+TEST_GEN_PROGS := basic memory
 
 include ../lib.mk
diff --git a/tools/testing/selftests/mshare/memory.c b/tools/testing/selftests/mshare/memory.c
new file mode 100644
index 000000000000..7754c0e33506
--- /dev/null
+++ b/tools/testing/selftests/mshare/memory.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/mman.h>
+
+#include "../kselftest_harness.h"
+#include "util.c"
+
+#define GB(x) ((x) * (1UL << 30))
+
+FIXTURE(memory)
+{
+	char filename[128];
+	int fd;
+
+	char cgroup[128];
+
+	void *addr;
+	size_t allocate_size;
+};
+
+FIXTURE_SETUP(memory)
+{
+	ASSERT_NE(create_mshare_test_cgroup(self->cgroup, sizeof(self->cgroup)), -1);
+
+	attach_to_cgroup(self->cgroup);
+
+	self->allocate_size = mshare_get_info();
+	self->fd = create_mshare_file(self->filename, sizeof(self->filename));
+	ASSERT_NE(self->fd, -1);
+	ASSERT_NE(ftruncate(self->fd, self->allocate_size), -1);
+
+	ASSERT_NE(mshare_ioctl_mapping(self->fd, self->allocate_size,
+				MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED),
+			-1);
+	self->addr = mmap(NULL, self->allocate_size, PROT_READ | PROT_WRITE,
+						MAP_SHARED, self->fd, 0);
+	ASSERT_NE(self->addr, MAP_FAILED);
+}
+
+FIXTURE_TEARDOWN(memory)
+{
+	ASSERT_NE(munmap(self->addr, self->allocate_size), -1);
+	close(self->fd);
+
+	ASSERT_NE(unlink(self->filename), -1);
+	dettach_from_cgroup(self->cgroup);
+
+	ASSERT_NE(remove_cgroup(self->cgroup), -1);
+}
+
+TEST_F(memory, swap)
+{
+	size_t swap_size;
+
+	/* touch 1G memory */
+	memset(self->addr, 0x01, GB(1));
+
+	/* force to reclaim the memory of mshare */
+	ASSERT_NE(madvise(self->addr, GB(1), MADV_PAGEOUT), -1);
+
+	swap_size = read_swap_from_cgroup(self->cgroup);
+	ASSERT_NE(swap_size, -1);
+
+	/* convert to bytes */
+	swap_size *= 4096;
+
+	/* allow an error of 10% */
+	ASSERT_GT(swap_size, GB(1) * 9 / 10);
+}
+
+TEST_HARNESS_MAIN
-- 
2.20.1


