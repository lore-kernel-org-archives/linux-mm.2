Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A371CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7566B0005; Mon, 25 May 2026 06:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFB76B0088; Mon, 25 May 2026 06:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27B16B008A; Mon, 25 May 2026 06:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD28C6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:27:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0F8E1C09B0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:27:49 +0000 (UTC)
X-FDA: 84805566258.20.E98649C
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf31.hostedemail.com (Postfix) with ESMTP id D15AA20002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:27:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=RGPb0mhr;
	spf=pass (imf31.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779704867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbTwoaOkXwx1Ghzc6peFnK8IaPJSEI9x2zHIcuTcCaY=;
	b=TBCkLY5fByhndEsRHJM7U1ftRR6rjvQ82l1sgsIUgpnD5+x7VUlQwZ6yp20uICMG240JN4
	v+U1XedmMzOdYpEZehphku6b+RjXXiH/fDhSZZtkrE878EreCgXiO2RblvsLprXzqgNJ2Z
	Tv1IKzVUIdew+Ijlo1tCTvdHhCBVNgY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=RGPb0mhr;
	spf=pass (imf31.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779704868; a=rsa-sha256;
	cv=none;
	b=Y7VSa4ELHhjRfFr626jy3N3xEHxCipI9a4GRS1dBtWqqhTVVmiTQnpCrBG2NSWpC8vyvLR
	hVIe9Tv/8pZeK0ky3zJ2DPmzMPFVBfDimorLNOFjEQHl9+ARKhroNZyokEgjHtvPW9oY2G
	gSasvltE9s0SotuJn0u0BHjndOSPYwg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=zb
	TwoaOkXwx1Ghzc6peFnK8IaPJSEI9x2zHIcuTcCaY=; b=RGPb0mhrhpLnP0xwrn
	a79/V6f2tjKOIULWVDO2WIawbLM150vTiMtoSkMeuFMRrpQtftucPUFyCz9kyaS3
	ICs0PdJxsdeCKhS8fRV2ib2zJQhijsSXsonEPjEAKbq3qqXViEeEfEr7tg74Dqw3
	7OQN2XjntorNmQ2aIXdUzuKxQ=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3V9L2IxRqXqahDg--.22926S3;
	Mon, 25 May 2026 18:27:04 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: leitao@debian.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v4 1/2] mm: shmem: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Mon, 25 May 2026 10:26:59 +0000
Message-ID: <20260525102700.68707-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260525102700.68707-1-ranxiaokai627@163.com>
References: <20260525102700.68707-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3V9L2IxRqXqahDg--.22926S3
X-Coremail-Antispam: 1Uf129KBjvJXoW3WrW8WFWUAry3Jw48Ar45Awb_yoW7Kr4DpF
	4fC34fAry8Jr9rK3yxJF48tryrtrs3Ja1DtrWkJas3Aan8JryYyF1vy348Z34DJryfXr47
	KF18WasFgrWDtw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziqXdrUUUUU=
X-Originating-IP: [117.176.242.242]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7Rmm8moUI-mPVQAA3e
X-Stat-Signature: onaxnnngw53hsc3cxasiy4734iyjiy5x
X-Rspamd-Queue-Id: D15AA20002
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779704866-575875
X-HE-Meta: U2FsdGVkX19qG0HcJYMs3QbLHCYMvs8frEYO42KcWubvhFBXfyVYn95A9Sem/jFsynJ288PwiiZXHNj7/OGt+056tno+jsnRY/WCRQy65zslpw5CzFloXtpXX7JiDlDWwvob7MWK+p8NiErF8OkY3JvDIzYwyxZ4PJqQM7H5et1BCO8ybMh77vJEFInEkGpIsfXxH/KKjSTLYTDPpcuzlQwx9G0ZUhN4OFjhZo5hwJ62NPeca1zQ+uvBHeH6lJtO41WQhmBQ7gEFzYUxvvnqJjeipUAiJDGYMbvekUOLYarE2vayHm6EOz+HrGtgdzIcL5zoYiqZrLutfpzyp32zT5NO+66qRD6LiC5Z7NOhJb4zNoKi3cKspdZXgTJhrJykcc4ooAIzd+g5clMH4PjzAtB4sqkwSXIq6BLJOIu3KWkGxFs800Kbi1Y5ld87ySg+ZB6ojkSKgjePoOxwk0GuxVzBpcNcsirltb5j3kcsN1p56dqazAsA0bKHLenHSxJpBVgPXw+Rl9ac/W6MrP7N+HfOB4WxQ7LfsE0kMDnx32AJlOZGJMn/IHTbEDz4FOCgspRPvr9LsoJW8eclKweR7jfbh3K8ZMiUpsnpwvmvmfTEwg40wXLYn6O+31f/FK/Hm2bElCXfxDQBYi9MYwTUAYNf4X74h7BrFNHcKDzo989F6VfBHLjhke7PbVBYXuaiRxxICUeRVh2aJO98faOeYDu/StMMhjc81xL5m4aXxeiyeBbOxnfbR8HMUFUiYxSTHLp4dd2y2QZoIGpaf6oRYvxHRMeQ7WtDbvp91K02VCW7cKRcEQrMZSFKu3Nw9y0tQAOnx6itM3ejYrCAE84DWB0EpHpMDPoIfJb124ojhcx+9ypHP95XkTO7WoruXl0wqN718ftZ5UZpGgElHz8oX6eJMfqKZNoWdT+6rOUn8ZepmuT4HBkiltAnywpTQkvDws1/aADY6mLc3N2GrM2
 63A8mX0N
 sea/2YH1wa2rvrbhfNrwBtySClDsF1VNs08XlcQxlkczANZRxLtUQ7Oj3NVHSXKf8C3JKP95yjw/J0tqCJ/FJ+8WrD6tWhsrggRLNBl9fRCtdSJEexUzDgaCLNg+fj0VXZtv+tPEpYgzM3miSwk5w6cWtkDzyHKtNUuTWwZg51sDPqZMDS3TU5dv2fja1TW5MsUePI3IxD1oQ2XTv9CTfh5/YBquK46ouilGEQ+O272J9CZ3GHdB1IiHb4BVbnumZNo4lTlW6P9MWE/wTZ2MLjoPUxieX/60tSCqzgGWNxURKU/zuemDbe+vdFBdhc4B0Uyc0M7t4ZKPXlCEOo4ec+Zj1pTu2FxkWK/YiXhKzxYbrrWIC7b3R24CGJqIRz7ncqKSL5Mj32KbY3Rzj9W2V6WTwHhbp2aou7tB0FgH31xrmHIn0ZPeGbvDUtRtqHfBRBObYrvfPGLNNo7ldg94iaKsMsRM+5on/8VfGD+VYKLAVEi/S8MYjUqGinQ==
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

Behavioral change:
Call start_stop_khugepaged() only when the mode actually changes.
If unchanged, call set_recommended_min_free_kbytes() to preserve
legacy watermark behavior. This avoids unnecessary khugepaged restarts.

Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
all test cases passed.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
---
 mm/shmem.c | 107 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 47 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..288942b44db6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
 struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
 static DEFINE_SPINLOCK(huge_shmem_orders_lock);
 
+enum huge_mode {
+	HUGE_SHMEM_ENABLED_ALWAYS = 0,
+	HUGE_SHMEM_ENABLED_INHERIT,
+	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
+	HUGE_SHMEM_ENABLED_ADVISE,
+	HUGE_SHMEM_ENABLED_NEVER,
+};
+
+static const char * const huge_mode_strings[] = {
+	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
+	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
+	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
+	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
+	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
+};
+
+static unsigned long * const huge_mode_orders[] = {
+	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
+	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
+	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
+	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
+};
+
 static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
 					  struct kobj_attribute *attr, char *buf)
 {
@@ -5546,63 +5569,53 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+static bool set_shmem_enabled_mode(int order, enum huge_mode mode)
+{
+	bool changed = false;
+	enum huge_mode idx;
+
+	spin_lock(&huge_shmem_orders_lock);
+	for (idx = 0; idx < ARRAY_SIZE(huge_mode_orders); idx++) {
+		if (idx == mode)
+			changed |= !__test_and_set_bit(order, huge_mode_orders[idx]);
+		else
+			changed |= __test_and_clear_bit(order, huge_mode_orders[idx]);
+	}
+	spin_unlock(&huge_shmem_orders_lock);
+
+	return changed;
+}
+
 static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
-	ssize_t ret = count;
-
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
+	int mode;
 
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
+	mode = sysfs_match_string(huge_mode_strings, buf);
+	if (mode < 0)
+		return mode;
 
-	if (ret > 0) {
-		int err = start_stop_khugepaged();
+	/* Do not override huge allocation policy with non-PMD sized mTHP */
+	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
+	    shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
+		return -EINVAL;
 
+	if (set_shmem_enabled_mode(order, mode)) {
+		int err = start_stop_khugepaged();
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode hasn't changed
+		 * to preserve the legacy behavior, as this is always called
+		 * inside start_stop_khugepaged().
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+
+	return count;
 }
 
 struct kobj_attribute thpsize_shmem_enabled_attr =
-- 
2.25.1



