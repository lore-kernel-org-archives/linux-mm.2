Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39BE9C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9AE6B00C7; Mon,  6 Jul 2026 09:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268FA6B00C9; Mon,  6 Jul 2026 09:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17FD26B00CB; Mon,  6 Jul 2026 09:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD7AB6B00C7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:43:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62738A03E7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:43:24 +0000 (UTC)
X-FDA: 84958468728.13.5E128EC
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id F2A9F1C0011
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:43:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="oph9/hLB";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf18.hostedemail.com: domain of a929244872@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=a929244872@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hQUpE0Csfah/M8uxVY62fBjrw6KwaN/+M0p9wa2ysCE=;
	b=5uOGmINcO3N5uyF5N9qYnpbpTp6W42hhoWHLbv6t+J9n8+0vWMmkQf9Jvlis9svryJojHx
	r5Zd3hIV41b/83QJPio52tv+GWAumqxFCFWmPPiGnjD4KM4LQerM8F+2OtdFHJkjyTQjGk
	Nc4sWaXVsavzBw2G19nwtWXPPbPcnfQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="oph9/hLB";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf18.hostedemail.com: domain of a929244872@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=a929244872@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345402;
	b=2vBMzyhCBAA0BqZnSyP3bzBvhWMPFZt1vM+0Uve6INTJRwFKfGdZLlkgw/COIBz8SJW8Gj
	sfcG4Bm2IH6IMRVV6isyp8CDPPm8/97XVIbKfvH7kpsdp1FZcZdwLJJteHhH6OJ45a3gKZ
	DLbQ0XaMU5t0GrcFo0sqd71cHNSxzqc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=hQ
	UpE0Csfah/M8uxVY62fBjrw6KwaN/+M0p9wa2ysCE=; b=oph9/hLBUNqNGHlYsA
	yVrpKumUqFLle8jezuyTaNda2gyzQBAmrWIQCLQkeKIGAiMVYdHA7MPtPxw/ij3o
	Ilm64A9NYviaggNuvhkbOJSZkP16aAwQa2LBWxCzrYJXcce8+YOsgS3sXZSKN3Wl
	1fQ60FI+Lu9nv1VO9DRMdqpzM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3X9XqsEtq_MxpHg--.52234S2;
	Mon, 06 Jul 2026 21:43:06 +0800 (CST)
From: wang wei <a929244872@163.com>
To: sj@kernel.org,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: wang wei <a929244872@163.com>
Subject: [PATCH] selftests/damon: check correct path in ensure_file() not_exist case
Date: Mon,  6 Jul 2026 21:43:04 +0800
Message-Id: <20260706134305.5224-1-a929244872@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X9XqsEtq_MxpHg--.52234S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JryrXr13urW8Zr4rZFWDJwb_yoWkGrgEgr
	W0qrn3Aws5ZFsYyF13ZFn5ur4Yqay5Gr43uF45WrnIkry5XFs0qFykuF1DZ3Z3W3s8KasF
	9an0v3yxCr4jgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRhYF3DUUUUU==
X-Originating-IP: [115.193.26.221]
X-CM-SenderInfo: jdzsmjiuuylji6rwjhhfrp/
X-Stat-Signature: bet79b9w65znhu1estr57mip6j77cwoz
X-Rspamd-Queue-Id: F2A9F1C0011
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783345399-480825
X-HE-Meta: U2FsdGVkX1/IjFhR6niE6RNgIxTRoWc6FfKpmsVDpwWm67QnR07Z0mH/sUkWhKRSSuWAbwPddJzHpQOJddsy+rQktYRk4dGL5m0qbHqwIwbWwztTYXBrPt9jytrcvgMq5I4nwxWNWFY7uXAA/dXesaYw6XS2lZnAAlVlpGXgF3NELDilZAhccE++2/iiWqI9szYJo2wVWb+7QV+c/dPTJi5JHde8DLOg9X7SriJmkpqWQL30wLQ2uPOWKyWYCVeqQ3o8RIJn6sVSc4rrrg5HpC3XeEjc039T6kkwOTd7Piwqi+SXevvBRQJCOeNCEj36PtmUONXGvnsw6QquC5hGUk9uY3GWn1ZnQbRM4scsUOZHQV7dStutkHen7PoNBsBflRbILF2WWmAz+QUC1GRSOPSQSG6mH4PVCvoZiNarSzQipQ2unq5WiOHWFPf+osj6GWAAX4navOkdcV9IQ4NoQBygdpY4u+/0UtKn7DQf9mAd8tuRVWhJFs4cqCJRZjW7el173N0hieJz+F9TUc/n465M9pKMkDsMFdy/F6C+iIQHec7VU9BR+7PbKpdqnQvBw2eDLuZ2HAKTB5ynPyPPVC/Xpx/eeM9UuNycsTW8nkPG2UuSTukoZDaL3J4ftxDK6Ju9BKfHCEEXnVyDg12aVxW6VVjBEcWc5II7iSxXSA7HMW/Aay9b79Rwl8gXK8k3E6k0kSrB1KJEbzyR4DfnrFTqoLQwOtP6ff1aJCO/vJW1IDn4R7FTnMIsfqjatl57GMGP8JFTOA8/ytcttLxm9TR8eRNLD86/NBHRe58WXmDBMgwkaR6SbqQoQJPyAI/rQ+s0SX7dzXZjRup+Jdg0hrRAAveQDK60q1dRr33td9kPfpZ3ROatEEI8z9J7Ys9PR4+zNyh1R4X6oHdNNhWTLwyufoAFrZw/ok/efsDklrrO64wBKpmytjlW8cWYpYA+isnObfdHaByl38GuKpC
 B1xSxj9L
 dqjWfVuocW2grcFNFOPfG4n5XrfbrOGusVLK1mawdvaDBKCPnSPRWj3qDyZaAHbzz10FuX6qFd7FOgmKRK1Ckp99lpugEkB3Z3neD1Lu2pXNtHXnye6Kn4l4pqXpx5U6soTSFSAjoveAF1J5Kq6NuX4qLNCENPO04Kp7PV0BJOfvmTWPJzKdTPwe3766MATc0IckuHKDXF8cwLrLLPNSjuBqEh4IrQYwhYBGNs5Gkgt3qskD/DCWwKs1UVLq1mmDHrYtwXQj52NOBG1dhGWSSkE8t2lYsiCNUKg+Jz8hXY56IKDMpVbeUQJiZej7hHlKHLBqUpLlK24lhqCarUQwCcGGQel0XRikT+5rptscOExHZc4q52VUktP24zynQKanCWmD2ah7duJCOpkqpLvKYHNU7/6qFG2lHoHIU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the ensure_file() function, the "not_exist" code path checks
whether $dir exists as a regular file.  However, the intent is to
verify that the target file ($file) does not exist, not the $dir.
Testing $dir makes the existence check effectively useless --
it tests the wrong path and thus never catches the case
where the file is unexpectedly present.

Replace $dir with $file so the not_exist verification targets the
correct path.

Signed-off-by: wang wei <a929244872@163.com>
---
 tools/testing/selftests/damon/sysfs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 78f4badb5..bf4684d36 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -67,7 +67,7 @@ ensure_file()
 			echo "$file permission: expected $permission but $perm"
 			exit 1
 		fi
-	elif [ "$to_ensure" = "not_exist" ] && [ -f "$dir" ]
+	elif [ "$to_ensure" = "not_exist" ] && [ -f "$file" ]
 	then
 		echo "$file is not expected but found"
 		exit 1
-- 
2.43.0


