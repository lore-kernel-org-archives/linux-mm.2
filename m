Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D4D5CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7692E6B008C; Tue, 12 May 2026 08:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7181C6B0092; Tue, 12 May 2026 08:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655586B0093; Tue, 12 May 2026 08:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57F1C6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:07:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4C1CC1CB6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:07:17 +0000 (UTC)
X-FDA: 84758642514.29.45D4206
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E73FA0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:07:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=eDICJYrI;
	spf=pass (imf15.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778587636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Dz83lsq073grgSifOFWs9rUfMneboNx6kp9/4maQqrg=;
	b=GezYZLHBnBSd/tRAtvEE+KpD1Uag/XWhRVDqIuzvM96wpkRtw8QTRjdgMiFZkrLw0lcTfr
	z5yVy37IBMexZBWM0qZWz//V+XPOfjkn9ZpIb48ZjD/yE/U4oLan2dk7bJcJlnKTL5qmHT
	r2iOzSTwjqWjwv7TAqkoULtNuEQTWxg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=eDICJYrI;
	spf=pass (imf15.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778587636; a=rsa-sha256;
	cv=none;
	b=gW/Vxm3LxIjvf8Lx7qhAgMQyNzvtO6yGwjGCavMLGi+bd85ezUp05iunjpiTy90qiFCdvt
	GkNaZoLoxWZMKZR6aqN475SRImJAaI1rKxC/s0jMhLR6qiKGNnm4huX6Pa8iOF4GMskhFT
	2H/NKVfBIK6zZ/SrRBPKWYUkD/LQPR0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Dz
	83lsq073grgSifOFWs9rUfMneboNx6kp9/4maQqrg=; b=eDICJYrI9Pf5YscXgG
	pMs/fAu2qUzCQY9lGKxrJ7nZlMaMV+mbT+tOibfydFyHJ5+Scvea+zszkfYGsSO+
	+tJEjy5YNg+ZQ37k6e3wkGKtoPAD1bnhxcnDb98ncSuh20Xqrt97v3i5HskhCtl5
	oNgBaEuPvoN0AsBHglKaMgznE=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCncianFwNqsj3nEA--.14956S2;
	Tue, 12 May 2026 20:06:00 +0800 (CST)
From: ranxiaokai627@163.com
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Tue, 12 May 2026 12:05:55 +0000
Message-ID: <20260512120557.49995-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCncianFwNqsj3nEA--.14956S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF4rCFWruFy3uw1xJrW7XFb_yoW7JF1kpF
	4fC34fAry8JryDK3yxJF40yryrtrs3Ja1DtrykAas3Aan8JryYyFykt348Z34DAryfXr43
	Kr18WasxGrWDtr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR1E_ZUUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxglLl2oDF6kEtgAA32
X-Stat-Signature: sci8icgw6xqnbqu1ywe99d437ieewidi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2E73FA0007
X-Rspam-User: 
X-HE-Tag: 1778587634-267190
X-HE-Meta: U2FsdGVkX1/v165K2Ctul4r9OTojbLmV6IqUYYSb+1vLprKjUFys/tWsUgZKprLogaRyUaiiHcKQnnUiNzof0xCjR5RNRAdDdUIzdOH7XND7LMnU0aXW0jrHzeHgGps1OEJjIOY5asWa2hPAo8c3ZGhjCsceqQ+4Zi86+ltK3kCb9a2o0+veL2fT8HdL2cmG+jiE1KjQ5WkuJjw7cIkLRPaqhxU3wB3f0z7PTeCPwtpOi3+tjbpNLZfHN9yU1qGk1frXSK2hf4VOq61Cwp6wK2LfMCrmJ1HJJJ6WOzbKbQlRczn2FrEMfzwtXE/PUH/BRkLia5hUjXheesalxpMB3Lnlx10zEKxn0F9794g833Xc7axYWkjigOkhX5c6bhbIc9fAA6BRTidAfciGDITxXFtF5weFtl8Fm5qmJPlIFaDuPH5KQLkywJdSC5Zf+MAc2H6q8q/gmpN5UBBzDaEyXBzZlgOMO1inYD8RSqcZCFVeJx2f+yjw1x2zVmHZAtp3C4n83CuCVTmt4+IM5W0HHkbHnqXlSwpWz5+TBZgpr2jfebjP0tA6wnliDHEs4mQQngmNCZcZUtj+85dCT7eK6rFaZgEtE5NtrIDElHyLa+KPuoeTVjQQyldhV6jzS37R4nThbnR/jL/I0ArSPDLKCNungtazmQhe3P0W4DwymHuYNHjaszAyE22mdq1AzF3sMXg6JI3qJDQPMBq8u2bRebJlJqigvBW456KPuwBeVYLuFCNgRuJOKaW0cwkSAqTudc6w58VOZ06OtmhRUYm5kC4+GFyPl2VvWGX16dbKy3KB2tXCLAcHHpBWnxGiyVM6tsBQdrekPItPXfioEh30rGDAK5rzjt9ML1f7VLK9yS9/jm1j7G93fJ1nV4fVHrVs7HQ4UzccOfKMBapnnNzXffFhaElaGHtXKJpbb26Scvh03A+qlHdNv7/XLyb8lKQdZlvqvPbyf/4PzbEayet
 SFzZ0TOT
 JIzUg951e2Lf6lzZ+KDwa8sOLsgYwtiTzYeo0zbFzwsfZoPLG2VQsDewYs4J8OnsMVb8WwSmjMv0PSZS1+ePfMoqWnKIuvVQ++N6cHh6n6zJlMCLD5gFeUc8v4pQyUFVDrEhuKaQw0FAMnToeDLJ1pAWojBDzBfEwUPo0w+yboFoZokt9ZgHQswOjnfUTNdRjS6LakxlnVBGfmCLZSn+lEbVKVvoxk8x00LPZJH2WBUrIFWZIPg4WV/Oy4aeU2OJJEMZWs678sQ3iu5cRQRYU8N1BJpq7QGJpDN0DoTr4p7ROLW5kGG48UX0owfDL6VfT7piuGrETeaYG3llu2JBOGJGuw8M/Sq/Q9AD8+xCU9wvnWKMHodjUJ5NBHNA4I0J+pexyI5iGgap5mC/uebppDpqz5D0qLGE6/4KFhUREkgRsNWSfHaN8uNGXCdEoxYzURUQk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
anon_enabled_store() with set_anon_enabled_mode()"), refactor
thpsize_shmem_enabled_store() using sysfs_match_string().
This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
calls across all branches, reducing code duplication.

Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
all test cases passed.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/shmem.c | 88 ++++++++++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..0cc7872cc576 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
 struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
 static DEFINE_SPINLOCK(huge_shmem_orders_lock);
 
+enum huge_shmem_enabled_mode {
+	HUGE_SHMEM_ENABLED_ALWAYS = 0,
+	HUGE_SHMEM_ENABLED_INHERIT,
+	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
+	HUGE_SHMEM_ENABLED_ADVISE,
+	HUGE_SHMEM_ENABLED_NEVER,
+};
+
+static const char * const huge_shmem_enabled_mode_strings[] = {
+	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
+	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
+	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
+	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
+	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
+};
+
+static unsigned long * const huge_shmem_orders_by_mode[] = {
+	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
+	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
+	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
+	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
+};
+
 static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
 					  struct kobj_attribute *attr, char *buf)
 {
@@ -5551,57 +5574,32 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
 					   const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
+	int mode, m;
 	ssize_t ret = count;
+	int err;
 
-	if (sysfs_streq(buf, "always")) {
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_inherit);
-		clear_bit(order, &huge_shmem_orders_madvise);
-		clear_bit(order, &huge_shmem_orders_within_size);
-		set_bit(order, &huge_shmem_orders_always);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "inherit")) {
-		/* Do not override huge allocation policy with non-PMD sized mTHP */
-		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
-			return -EINVAL;
+	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_always);
-		clear_bit(order, &huge_shmem_orders_madvise);
-		clear_bit(order, &huge_shmem_orders_within_size);
-		set_bit(order, &huge_shmem_orders_inherit);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "within_size")) {
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_always);
-		clear_bit(order, &huge_shmem_orders_inherit);
-		clear_bit(order, &huge_shmem_orders_madvise);
-		set_bit(order, &huge_shmem_orders_within_size);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "advise")) {
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_always);
-		clear_bit(order, &huge_shmem_orders_inherit);
-		clear_bit(order, &huge_shmem_orders_within_size);
-		set_bit(order, &huge_shmem_orders_madvise);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "never")) {
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_always);
-		clear_bit(order, &huge_shmem_orders_inherit);
-		clear_bit(order, &huge_shmem_orders_within_size);
-		clear_bit(order, &huge_shmem_orders_madvise);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else {
-		ret = -EINVAL;
+	/* Do not override huge allocation policy with non-PMD sized mTHP */
+	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
+		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
+		return -EINVAL;
+
+	spin_lock(&huge_shmem_orders_lock);
+	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
+		if (m == mode)
+			set_bit(order, huge_shmem_orders_by_mode[m]);
+		else
+			clear_bit(order, huge_shmem_orders_by_mode[m]);
 	}
+	spin_unlock(&huge_shmem_orders_lock);
 
-	if (ret > 0) {
-		int err = start_stop_khugepaged();
+	err = start_stop_khugepaged();
+	if (err)
+		ret = err;
 
-		if (err)
-			ret = err;
-	}
 	return ret;
 }
 
-- 
2.25.1



