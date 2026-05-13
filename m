Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1850CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61C86B0005; Wed, 13 May 2026 05:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15096B008A; Wed, 13 May 2026 05:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29966B0095; Wed, 13 May 2026 05:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD3856B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:45:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EBCD1203D3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:45:45 +0000 (UTC)
X-FDA: 84761914650.10.E329DE6
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF802C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:45:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LZSnsbi8;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778665543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=caRtC8vLr/yalP2Wx9m78i8TJ8NZ21hIDKNxEZYYRL0=;
	b=8DBp3RHhIF0n17Pxc2bxqCUlcLeWVS8ZQ+Pg+p0OFBOEy9n0xPwVQObVmU10EqaVu4y158
	9FShlslj4iiWtXDIXbH3+deYX0Az9sTgwQuAZP1WYjw0UvF/jRZHJNltizMBjZpcSGPh8U
	hiSfDVz4qqh+QYKFXFNoXoyc9eRHjr0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778665543; a=rsa-sha256;
	cv=none;
	b=t6cJioaqaacUsAJBjzfGA6c+4lgeMt4J8nvtDGHSNSM7mnFcxpCVGQ7cwC+sa/ozeeSsyN
	xQyMA9z0cRO927m2YeD1MLRqF72nEMBhl/2eGEPX+rIc3ulvM+dBWD/cR208yfd/0RTuNU
	b62WgZycS7tSfj5Qg/A0nOGCCExRCYY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LZSnsbi8;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ca
	RtC8vLr/yalP2Wx9m78i8TJ8NZ21hIDKNxEZYYRL0=; b=LZSnsbi8/pxI6fUhoK
	GAO5PjAqZV4Z8h/g1AGn/3Tuens8TGjxfhbPiUECFiCzP+hkhzb01rgKDA8WS24I
	XS3A5dOlr7RiMlm/TINSgjYRzeX5Xr+sc8xRk/FE3Ok3wFBDB0m25aJ93/13Ebhd
	pFkP8iX/cqiAjMrs+PC2GR6lU=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgBXXvImSARqv3FNDg--.31S2;
	Wed, 13 May 2026 17:45:13 +0800 (CST)
From: ranxiaokai627@163.com
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: leitao@debian.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v2 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Wed, 13 May 2026 09:45:07 +0000
Message-ID: <20260513094508.50888-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgBXXvImSARqv3FNDg--.31S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3JryUWrWrZr13Ar4rurWkCrg_yoW7Xw13pF
	4fC34fAry8XryDK3yxJF40yryrtrs3Ja1DtrykAas3Aan8JryYyFykt348Z34DAryfXr43
	Kr18WasxG3yDtr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRHmh5UUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxQq3BGoESCoakwAA35
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF802C0005
X-Stat-Signature: keg8do6qwzcd74bsa9w7n5zhqte8tz6n
X-Rspam-User: 
X-HE-Tag: 1778665541-57169
X-HE-Meta: U2FsdGVkX18MuayOMM6OC0chcMGEm8IeHEkwUXuk02iY6Is2QB552Ym4cjXPue2xgAvs6/twNrP4sRtUt9SEz8PcSzJDPDy/alBoAQ5bfdPsSsyPecMsyeyxrMDb+sL6gMoAEeCc0ybdPLzh+zzGsD44GRlPuxWO7vwlFOIS0UkRhTAeO9ZPAodz1JGaLWlijs+r30uCZaoQPprTrmWUi1oKv1d20q+CZ5Zqnvn0BfCTcndPUI/KwVJtOorDLIjRWJ3s9eBxozoXCuGQ7TixU0ftZnpqOVMhmrqc6sNxIxl+xexRQrAd/4iyZCdAwB69KrcmefgIJhzCusFOFJBHgce5tzZoRcfWYiQDSFa+Pni1jQZxiT0jE6GXcOGwWCS7GvFw7nYpDjmWRE4f3Gkbicknvykbs1fNc9XCWa4w9ZPHucxpMRUQM9IH6QvHgYC7ULAKohOnYaTTEt74lKNeABkkEp4kXt5PEcsmUN3RTVi/TPN9c8xnPwJFGecv6eLkAel5Wgs/79XLGCFBjOFFQpaZNRuzSGtDorv8fMcG8Tf0JcPmPlcHSh5MixTz/9A70jPjAsLbxEaqjpXagyxo//9QqTYKz/5oP//WqsCofR9zT2MoRjWMrwoGFGo0GO4PWwyZN/DjO1D5I+l5Rq/Zb8SVCW9dyjHHBfio2Sm/eF/P2gJsD2UOktN+pQBiwCk8rjEfjwX37aPzEO+db+DViS137UsTaSxvxxVh7g0+qEgZPfWlFXTdij39cqrgZnpmtKSRXxwfEZgougFpk35YalnK9K31h0SnnLwV94dYYhckFjZTDbusv60xE93tHtW4upKnXyGM8rb7vixnVIsjCyTvf7Ovuk440dVYLclIa9Nfi/fh+PivD0ePoDmvpgnQ6eaBONxIiBtLOA3lXAUzcIxDOydu2NsmHa5hzWat5tnubeySWswK00v+HNTkznh8txOvD9qo8VfxWGpNdVY
 YpqopHp0
 34sfYMCFbXS9DDkEo4IBus5BeMYamX/S8e/X+nSTdCkzXDnTTrcLRBR2UeOervWT1SyYCK/Nerlhe2LwKj14B1aRxKIQxDxdNxwV9dzIUEb1fP44PdszlEF/0pwo6jjAVzVPZFH93X9ussy9G5nVAM/MPxhtUDDGKvsBtxE4dHI/ooncBoWDjMqj4SBOM9l+6GJF4NFog4Fyta5766+4snkGSkV+wl/5ynpEe1jTYr6SE/jqnFAndlDtZN1HsIrR7TixeQgtdd9dt3icldNCTkiT2AKqfw7dia91mcsvn/n2ZkhHdjseOO8K7PfLj+V5KGtDXYQV0ldEXk3K0QT306RomT0blP/P9dOjexF4F7mj2Vpx2218F11MT2CXPMN66EKjxS7TL6y0cpSwt0RBn3C+fxRicqF1z4h4r00qqK98FeuRSVs1Oi7pzZI51y3Q7InaaAmv5uMSBWZ7A8tjvBw6XMa+SEc43BlW4V9rMCPTrhnvkarLitS6FlD2v94E87SVqloBLT5PFHgD7QWI/Ue8pBQ==
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
 mm/shmem.c | 94 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..60cb10854f11 100644
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
@@ -5551,57 +5574,42 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
 					   const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
+	int mode, m;
 	ssize_t ret = count;
+	int err;
+	bool changed = false;
 
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
-	}
+	/* Do not override huge allocation policy with non-PMD sized mTHP */
+	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
+		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
+		return -EINVAL;
 
-	if (ret > 0) {
-		int err = start_stop_khugepaged();
+	spin_lock(&huge_shmem_orders_lock);
+	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
+		if (m == mode)
+			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[m]);
+		else
+			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[m]);
+	}
+	spin_unlock(&huge_shmem_orders_lock);
 
+	if (changed) {
+		err = start_stop_khugepaged();
 		if (err)
 			ret = err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode hasn't changed
+		 * to preserve the legacy behavior, as this is always called
+		 * inside start_stop_khugepaged().
+		 */
+		set_recommended_min_free_kbytes();
 	}
+
 	return ret;
 }
 
-- 
2.25.1



