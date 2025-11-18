Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2784CEBF92
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1999B8E0009; Tue, 18 Nov 2025 03:16:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B508E0002; Tue, 18 Nov 2025 03:16:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038E38E0009; Tue, 18 Nov 2025 03:15:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E69AD8E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:15:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DA4812EC03
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:15:59 +0000 (UTC)
X-FDA: 84123019638.06.AE0F129
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id 067EE140002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:15:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=KvWvv9U6;
	spf=pass (imf09.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.50 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763453757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Dgq9GdB+TDgt9ubpi2QIxJvPWQziPEpk10JhrXaywjo=;
	b=nKCXwrnBQIqrH/OhLxvaVJiZveDOAUxBrGdTl6sBK6qtBCM9Hqvh+oxKxb3Y87ZWlj0Ybc
	4zSt2DNRUwJrdp9o9RZ0XNb9rqE861UGBMskFEETxTdwB7VJEFxpLs0eELsz90eEz9ZEpM
	CIkq8tg4sJCnXhnL3hhCKxl8L6vMhO4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=KvWvv9U6;
	spf=pass (imf09.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.50 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763453757; a=rsa-sha256;
	cv=none;
	b=lNvpo4+bfvj3DRJCaHJ5xKbItWKBYrVd2O9kHSTOBXCqyGqAQvXmLJTtlgpxmasjg+Q5qs
	IUiUh4xDOqARgNX6a3O/bB/IBeHO1ZKHzFMwURlcQb7+n1eSJc2nDwxr8ZBpyviO9cq+jD
	mFJmTJNXAUBekRp8nsSYEfMHhRTa5V4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763453754;
	bh=Dgq9GdB+TDgt9ubpi2QIxJvPWQziPEpk10JhrXaywjo=;
	h=From:To:Cc:Subject:Date;
	b=KvWvv9U60g+tkussAJeFBfvD7+XPO5vl62rOZVcRlriPXH8fHcZJUomoNvbbW+BUq
	 STcZc2pin+eTwotA6EBBscVTKEIvoJ02dFBEGpszT1RK9SXAITEeNEMyi5GshPeZ0N
	 DXuLaItG7x2WAQr0+AZQUi6VTO7iRNMNcEjkBwbk=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 3F3904AA; Tue, 18 Nov 2025 16:15:51 +0800
X-QQ-mid: xmsmtpt1763453751tb4jwdjo9
Message-ID: <tencent_2FEBA8888C5B7C3CC495E17C29EFE76BA805@qq.com>
X-QQ-XMAILINFO: M43YobM9g9iNuzsmc412q5ZBUR8Jmyt41yWOZ/ah1ScleaQUkJu1WSNxFIpu2+
	 zEQI2tbP2zDTM1Koz8aN0zMJIUcMBpN/da3Vm0RbepEb04IqVomtMs8+FQGNDbwXevM3V4RWZ7+m
	 BfY0Zsy1X2jEquQ67BGYDPFgxYKAEIWHslbEli9DpC8xdWi532MsiDWyV417xXRb8hYzKvaIv0ya
	 3QT5nlw+NdUUaNA7ZPDUQhn8NcZtx6SQSEsoVXo4A1jGhojFTBaw+zXqf2HqZD4Iczd4NQNkhibD
	 Oos7L7iJHA8tTIJFmlhTAOybxe9l87Uh48QCCQt0sR34lKvN/cg3oiyzS17lvlMQPYtm2oNc+IGI
	 T7pvwqzzKzMuWBMpvK8LyKUD5vyELNP6RdcCwCt3JihUdsdkogJBa/MPE5jR4VuTIEXHw0TBtQ4J
	 mFpEBCfynWxIbSvxUmIyxBQu9ZC8WPesCa7slZcKiD7V0vQdfMRFqLQTd1kw/aDifEEkAUoB0/HW
	 QqhdZdmhZ+N1uam2kQuJpQ9Xjswq6Qhf2iCNe6OCrhQj8PoWoRAQH13Fhw2jB/VvbkVR61lliky1
	 OMKE5drLNg5OJwE0pnoPmYzV5ZkUJPLX4SCpXwWcY67nKNR1RtCjkXlRMo7c0imFlgfVzMY9Xy/4
	 N18Rwlg/F9ep5kR/tGMM3pGXT2t9lqmSYJw5UBj1j/vdSjGjqFczoP1dvoSoK1dN40ETtKW1FHzg
	 frLgMC6bMvTLKvjwHXyBh9rHWzFnhuVFuoxZhL5Eg38PTu1thro1rIA2112D6xc1Y+VStaLtb8X9
	 agZxlT5KIWWvi2hofarshXtwf5FR0lzO6yGyFhtiD6lG3eeV7J4CS+CGBKb7e/SL7Z+uL0q97qWb
	 VHZwDGxklpE4L8vtm6rLHW1Qil2vO39Z5ddURnWAfHNihxrtUzlWc2lCtQJMN6+vHMH/fi4bdg4b
	 yUWUT+IWQBr0bW59qamzPkz9+UJXC6auQnqFIbEWgrReFa0NPNfn9bBIo13YbGKT2DlHyOD6LW71
	 Aw8er9tEoDNjbdBJFZh8nU+y79mKmUoyN3hdPCn0oTWq2pqzFEhdUxqexwIeAds/SvzPc9H2SMhc
	 NbArsQG59he7ZKwmZ0aityYwMFfBwJrY2RnFBHMsxaO8Dq180xUcDckx7rrnKFEwMfrolz0+/fkz
	 4Ow8V8dbsUrFH3Uhmajm2X85vN
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: [PATCH v2] zram: Fix the issue that the write - back limits might overflow
Date: Tue, 18 Nov 2025 16:15:50 +0800
X-OQ-MSGID: <20251118081550.2809090-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 067EE140002
X-Stat-Signature: m4faq3eq1fnjf45tgdwtwhzbyaiph1be
X-Rspam-User: 
X-HE-Tag: 1763453756-154473
X-HE-Meta: U2FsdGVkX19oVsM9LbA4OCpShtr6OjlHCr45XcW4Dyo8EfMibmmaT/VIhzvmQXtt9x3kMYlvMmutRLV/6woCGLOpJ0wMFlB5YLdekIs4x9U3O9Wri3HsQDULDmtnrfKoozAXTw7J3OFyzKGO4Cgo23FCCN/UiLl2+/XXgZGw2GPaDFgKWx1sPr/MoKlie0jP6AnEJxu4bB55kVXh008XE+Loi1HAE7HiCCZeyje68yuRaeMvlkOIB3bIrGJrNtaXrcAo2oB4wTxR6iDI+zO3Aw8XRZFAD+q3lSUiQKShqOeJ1IEs4P6LgjgASeYxldu3aZFK6jwbKPAgeqN2N22b5/Emtw5TVezXkXiEn/CiQjuhE9Is5XO9Wn9c6gV5Fi+5oyUqWh3M8k8A7NyraedQablPoW0Cckc2lafTFVO8iutBPGaiJAA3awABmWQws9kPPh+WMz7kFB8OmIu8GZZigJwqEtoUeRGtf7wgUeutuXb3CW+lHzAtMhIlx8/WZCWp7i0y74ivEHy5srKVqb1RHwiUxo40SuBzWgc/AVbFj7OJ6u9/tKR1hdpkHqN0XeScd94Tqc2Dq7USbPjjk0r5bgw8eotconPRFyMloqVj2ac9uhtbHRoEuCmoxNN1HbyDM+8Fv1xIuI0b1MN6VZnSHrVov8zQP60vf1ebvrOrMW9r54Xz7D9mrR63p3b0aYnK/0qUTKjoTEH22IzzNhfc288IrBn2QEXAyFYL2dQVRU8jmOPEaQIbJ+hNmGVaBR7vUXDymrXF1LKOXn4VPbhpDoRgpxSEf0AUlAohT109CmUAWHZXnwx5f8PE0FtYdkMe+ltYUeq3Af0MZC0pzDk4D+xdM+y8XCnbC7CQSml2Al5NMzZqS06Cc3P+uWdaxZw9QL2SRo4ED4kgJrnCc+6jEVG8OsiB/wc+G5fdOV1st2gVUIxRvERX31t9YSwHcLPELmVZdLaeRgGYA30130C
 i/IA0li+
 kQkaI0+4CNDKZ+Qhh2IZbvVkgH0p0xesgpGQYKmP9qbCdMLCKGf8KQOCek8/EQqPF/wW+kzFr8q++4eEw4rOE2YvbnbaB8rjRVnmKBc5OnvyuokNd/nXjl1y5Oqh/5fXNLfrbLDRLIpDxGzR2OttwLiYX0yvrIyZE20o9x2zncGGV9s8rYZby8oYfCr8WJFIapgcWKvsPEQbGypjj5y4mK5FMBIeVLl+BzvOadJcZ/mkPbVh4eEC1rCrzmFJuJ8Q5RjubQERN9uAImaQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the value of bd_wb_limit is an unsigned number, when the
page size is larger than 4 KB, it may cause an out-of-bounds situation.

This patch fixes the issue by limiting bd_wb_limit to be an
integer multiple of PAGE_SIZE / 4096.

Fixes: 1d69a3f8ae77e ("zram: idle writeback fixes and cleanup")
Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
---
Changes in v2:
  - Rebase the patch to adapt to the latest version.

 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8a13729..5780604 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -579,6 +579,7 @@ static ssize_t writeback_limit_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
+	val = val & (~((1UL << (PAGE_SHIFT - 12)) - 1));
 	down_write(&zram->init_lock);
 	zram->bd_wb_limit = val;
 	up_write(&zram->init_lock);
-- 
2.34.1


