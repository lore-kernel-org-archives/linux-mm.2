Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377DAC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D656B0088; Wed, 30 Jul 2025 05:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7386B0089; Wed, 30 Jul 2025 05:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B59B6B008A; Wed, 30 Jul 2025 05:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 68C0C6B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:20:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E579CB60B1
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:20:45 +0000 (UTC)
X-FDA: 83720386050.28.C5C5FC8
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1E65E1C0006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:20:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=bkan4aYK/XCUnm1K6ecDNYX/Qne09sSRNdg9ztDIwGU=;
	b=aNhQYlupLs6HbSyoAE+L7YPqSOlX/JxLOAmf3Q6UfgVWEmJBE1MAuJUMh2TTgO1iO1HX46
	8Ewu/kgCDDgeD6d6qBPjVJjle4laJNGICdf1mRbOSfZOhIGJws1IxV+CGFksY30sgI2KnG
	aSWLgPAEbJctYfz5e4tzMtoT2d9pCc4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753867244; a=rsa-sha256;
	cv=none;
	b=y7GC7u3afY0hCOzPLlU8Cul76KzfDAvTMpEQ8wCwcZZFTrhpt58ghMtn3XZP7K6l5NhsPc
	jYl/8GrNcdqP61HDpeb7WiPIgcFTzcAWySr3ho4Sr8/+7eGwPFw/HrW8FJ7DvQ+f5cyiK9
	kugKDNmim+bXpBkR1yOfaeclp4lAtOc=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bsRRC75LvzdcBV;
	Wed, 30 Jul 2025 17:16:23 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 87E8E1402CC;
	Wed, 30 Jul 2025 17:20:37 +0800 (CST)
Received: from huawei.com (10.175.124.71) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 30 Jul
 2025 17:20:36 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <david@redhat.com>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>, Zhang Qilong
	<zhangqilong3@huawei.com>
Subject: [PATCH resend v2] /dev/zero: try to align PMD_SIZE for private mapping
Date: Wed, 30 Jul 2025 17:19:05 +0800
Message-ID: <20250730091905.383353-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E65E1C0006
X-Rspamd-Server: rspam06
X-Stat-Signature: ncz5zcczf4ty4yfn3fggrhefxauosi87
X-HE-Tag: 1753867242-327529
X-HE-Meta: U2FsdGVkX1+lAzW5oGFmhLCOTer1lIVVvpua9FKaOCdGFCEKsTUJoRdURfxDIaahR2tQdQLrBXysg+X53hUUgvfTUqS1FpyzaFRKM3YFn+K7AR50Tqs06REs3V+BqykeyWzbckblURRwgBkAS72w58TypYEafRyzzsWfa1zAHAF9rrsTUhXFCWimQYUpDyk33XmYbat6/N7+La2wxBwRKIHXmH+dCjk+nOaupAYjHaMpWdRjyZMgcsn5F7NzBJkFgmfRqklEus5XQz0ZzL3rQDsfLEJ8wyT1F2ql9iSCOhlNjz1zl8pSlXU4OgvV69yfFobVPpW9euEBvRgb8dCYCjCKBc7R7JWyssL0lW7um9l5bLV+B00C829oMZfeead5F/7BiEa6QtMfC8YZ2EFpDKicCxbqxQCxbd9kvlnZnW2ncZQ7FpdtSjTJNBIlhDJWJrqSOqbcy0msto9/YG0fflbb/3xjFbMUzaQ6Zet5fDAejvgRLgNPiImG1FQs/MqdvOOIaSBdahNiXOy5Y0WHtWdO1y88FMZT/73b68LIduchohlw0HAy/lNBjC9TBWmZU3ytIqvor7RSENrBXyNgP18dkRCI/zaGMqjZlf88fyQqIPAPj8toJnb1w/kQMtrueheMN7fbIhYhC9ox/W2FhgxryJ5smVa7CrYUbxJQ/mPHpURTHvsJ23uej/f7xNA78cjni5sllO3L5c6u3dpjhZROlQezplHXJb6d4bYmRMSB8+SX78ZPW7+xDuNJXL21HaRmD968FeC6CebOBQlmAHhjWNx4dass1ueV8yaYsiUakW89tWKIyHUZ37Q//3aW7rcGxJpQKlfDVNG7HahOwL5A9bLYzRbyHyJctBsRXv9CrNYbUHlZOH8TBBG7oEaA0u7whw/1mVGL4mmEKxfWhgH4+R7VtlsnbnEqVF5r4oz7E6pRZZhhyTXfh8vahH65xXfFhQkZgYVEXAZipJF
 gpspewfq
 Rp+EFfPs4YgEhrPydXQnVuHPnLukq72rdhIs12lEhoQ3lOEEqxAz8tolpul+sBdlZCRwyrtz7NY0OnoXfkfGfQ2xvofpkmPeBRGxBK9f0cLuQJAYMOOxTqhUTejFI09wcuXC5pzGLo89AEFzbxIcja4Fk3Sm3fBNNJtG7O5Cs2NP6nUxTmsl6Gz9+teY7gS0T9KcWujVDeLe6E4tT9HQFealUAlTMv3z8P2XCxy00rDYshAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Attempt to map aligned to huge page size for private mapping which
could achieve performance gains, the mprot_tw4m in libMicro average
execution time on arm64:
  - Test case:        mprot_tw4m
  - Before the patch:   22 us
  - After the patch:    17 us

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
v2:
- Add comments on code suggested by Lorenzo
- Use IS_ENABLED to check THP config

 drivers/char/mem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 48839958b0b1..c27cc89bd02d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -525,11 +525,18 @@ static unsigned long get_unmapped_area_zero(struct file *file,
 		 * so as not to confuse shmem with our handle on "/dev/zero".
 		 */
 		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
 	}
 
-	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
+	/*
+	 * Otherwise flags & MAP_PRIVATE: with no shmem object beneath it,
+	 * attempt to map aligned to huge page size if possible, otherwise we
+	 * fall back to system page size mappings.
+	 */
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return thp_get_unmapped_area(file, addr, len, pgoff, flags);
+
 	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
 #else
 	return -ENOSYS;
 #endif
 }
-- 
2.43.0


