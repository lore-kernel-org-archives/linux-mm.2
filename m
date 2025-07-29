Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3028C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A756B0098; Tue, 29 Jul 2025 09:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E22B6B0099; Tue, 29 Jul 2025 09:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8486B009A; Tue, 29 Jul 2025 09:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6B66B0098
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:51:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C016A160645
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:51:18 +0000 (UTC)
X-FDA: 83717439036.19.F1643A7
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf16.hostedemail.com (Postfix) with ESMTP id 600C7180006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:51:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753797077; a=rsa-sha256;
	cv=none;
	b=ql2t4HZ6YEQZOVAQ7f2I2upT9rlvVgwZYYQGrlrzmkWYpqR/k+2vsEmqkUPntrmHAMhisg
	EE7ukUcWtAyl0/MXRUhMuggbU+5lyEa0tlDMMmzBpYtx4c711otcS6K83BGHJm2Pftu6Da
	3wwo+yd9pKVWpk6WvkF0RoMMM4wrFHE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753797077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Zzb8wSoLJsvcb8gzTbA+vuxxEIYYTvVKCDd/ECxzytU=;
	b=IC2EKfrBschwR9uFi9k9x4doawkJnMWdf6UoRSLC06rZcR9ge0XUP/6XAc7LeiVuayC5JK
	e+adR7FxFpgwUduK+FCFtoaFMhPhl+31ZG+uUUBPOLIfjgvyf8fWmjIELkKnmGSvdAmkUs
	7RsHMwKzeypvgJaGwkqnICbdRMNz0Dw=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4brxWc1rH3z1R8qK;
	Tue, 29 Jul 2025 21:48:28 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 88B371400D2;
	Tue, 29 Jul 2025 21:51:11 +0800 (CST)
Received: from huawei.com (10.175.124.71) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 29 Jul
 2025 21:51:10 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zhangqilong3@huawei.com>,
	<sunnanyong@huawei.com>
Subject: [PATCH] /dev/zero: try to align PMD_SIZE for private mapping
Date: Tue, 29 Jul 2025 21:49:41 +0800
Message-ID: <20250729134942.900517-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 600C7180006
X-Stat-Signature: qu9igsaqrywr96dyi4yyyqxbj7na9s6t
X-Rspam-User: 
X-HE-Tag: 1753797075-514797
X-HE-Meta: U2FsdGVkX18JXf9lrFR1ovyxicqc6V8HAyCGvn4D4NoTq06DXPvt0v8HYfaUSlkl3GHy3gh6GQEMDJPPrFfFlFYMLjoNXxB9sd0wlz+nJpMiiB4llC3GsbjjNVB43lP91z8GwqVed4dak3fPUgnP8nJUVmQocpZL45YGaZppQyCssFlScBOM5+6V081XY2jUXC+ptYMytvZes3Y6LIFtmiw+FKthC7xX2ioY0NqsZnJoP+F/zu+mIDvxHRasK8rQStdxZRaLHZ45+VcCV4az/ETiusAvzYBC/qRqmVr5AjYt6MR4AyKGeMkCcMF7TGel5i0kq5eKjIiMfbAogZRAKQWSTIce9878Te5cEsMfhcyVcr7BAwpPDHd/rs7Gfwd6OFN2DRoSx66fju9dQKhFZ0dp+Oczeu4JFY+0kjG4myh936cXjOnRLKBtoW4P96xFlWmTYBCNJMfnM1gbxaLFz5ouhcrthvkrFPIdXF3qqhPQdZiI+pMR6pEr2FSAnKjsUZy7qmj9PgIpB8NRnB8wdzjnWvSK36h+VudmslNRrlPfIFiqRcBvEiMxvACdVgPBD3hbEylbrhXdcA3zphDWZAqsEKfnHI1N/mS51WT3EUEOxzB961QJY7YtsaUpvw+pV8UW/F4do6xhobf943JQWgiGJZacT+2Bvmq7Rl9miY2EqR74hkqCNTSoWWngk040XrXc3mVkpu1ZxZJg25yCEaJq7u0D9G/5uzTMBWbDbA3tEr1OV+e6yjIkNequDHVOBeAXTWsNtC2paT26UyrJIqHN1662Obo7s1gST6rKc6DwzeKeJTJ05gZ0EEUL439XAMEgbLtbTzZSD9YmExsMOhIU5ZH3hqzMnZGIL+D3F4yD6EL6MRWlp64Xs25bTJzrf288OBqGJeS1Yp1aLbJ+LA7yIOSkHR0JojXgKimp4v25YwM7d4RVx4pqEelQ/ku8pZVzCnKYAhkvqWR/w/r
 p1DUT0zx
 lv25VUzRb1unKznvzTW8PTABFsSk+QrObrkZ7mnw6SnqpW0hUDZLTFrO81qUk3PPgOhRsDq/DntuOAqlQdI4isHp8YZQdCgghxXE3/xjwrF5DZyny0mtU2I7pyF6ZcM0WrwWzgM8wHngxDPqNay84yDyy2hPK5ggq/JHMMW1m5mbhdv8WZQVRtrJ9rTMxKvu4iIrNJ91zA423LDLJ0FAk8FQRGjMECGCUT+ak2Y0iJD6h1ObcewIoNMXeMJBOfiOAXGHV/8adF52mOYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By default, THP are usually enabled. Mapping /dev/zero with a size
larger than 2MB could achieve performance gains by allocating aligned
address. The mprot_tw4m in libMicro average execution time on arm64:
  - Test case:        mprot_tw4m
  - Before the patch:   22 us
  - After the patch:    17 us

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/char/mem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 48839958b0b1..c57327ca9dd6 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -515,10 +515,12 @@ static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 static unsigned long get_unmapped_area_zero(struct file *file,
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags)
 {
 #ifdef CONFIG_MMU
+	unsigned long ret;
+
 	if (flags & MAP_SHARED) {
 		/*
 		 * mmap_zero() will call shmem_zero_setup() to create a file,
 		 * so use shmem's get_unmapped_area in case it can be huge;
 		 * and pass NULL for file as in mmap.c's get_unmapped_area(),
@@ -526,10 +528,13 @@ static unsigned long get_unmapped_area_zero(struct file *file,
 		 */
 		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
 	}
 
 	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
+	ret = thp_get_unmapped_area(file, addr, len, pgoff, flags);
+	if (ret)
+		return ret;
 	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
 #else
 	return -ENOSYS;
 #endif
 }
-- 
2.43.0


