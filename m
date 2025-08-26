Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30394CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606DE8E00BB; Tue, 26 Aug 2025 04:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B63E8E00A8; Tue, 26 Aug 2025 04:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7888E00BB; Tue, 26 Aug 2025 04:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29B188E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:06:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2575C069A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:06:03 +0000 (UTC)
X-FDA: 83818175406.03.5176ED9
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 559A01C000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:05:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756195561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=JsiUDWQbOcGFuPGH4PdCWZtqKbgsyDLjVXptYLbp/fM=;
	b=CVIs+6dIHgq81CBFPxhwlZ60bkiFOuzuOIlWX3XjZo8nXqyTOZfrDbunOR4RFE30mT0prX
	QpXfLcCjFcKU73Smqkc6lA6tgwYSRwB+RhLP+QdH3q6GNyQJVzAGlRtFmmpl6g3cHvcZZr
	ui/q/fnVWWwCyCO91K82OYSvObljfYg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756195561; a=rsa-sha256;
	cv=none;
	b=EXxAFccAjFVK9VeMb26Q9HRG6iiibjTqwBjFL/NnwQdQKAfq2ON93LuuuyyyOe2j1xr9eV
	5+4+9R+4KNEDCZDkMyD11doN4EYGTHdnOgnxStWDqQmSoVvtNeOHPfNLlxxUE5jB7QrpAC
	d5O1K7lJmD0z/zWeL4Aq9BBcmLvtF0A=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cB0V95MQ1zdcjH;
	Tue, 26 Aug 2025 16:01:21 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 685F01402CF;
	Tue, 26 Aug 2025 16:05:47 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 16:05:47 +0800
Received: from huawei.com (10.173.125.236) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 Aug
 2025 16:05:46 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>
CC: <david@redhat.com>, <nao.horiguchi@gmail.com>, <linmiaohe@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory
Date: Tue, 26 Aug 2025 15:57:10 +0800
Message-ID: <20250826075710.278412-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 559A01C000B
X-Stat-Signature: urxarmc6uwamg7ei9pjbj8j7g5cycsfb
X-Rspam-User: 
X-HE-Tag: 1756195559-231285
X-HE-Meta: U2FsdGVkX1/vHgtBxR87O7uHsw9MSbETA8rFzIsPK+H3C6yVaYSyyli34ljL8CL2Y0KSV6eblHE1vPBjvt2A9peJQrczSYwrN2K5bnX8DK0ZFGAAFsxnN6X8PsHMUhd4bcP3nQbytqtPKF1EsIOtDt4OT0awz4RjiG1Mjnb/sWG6WhVyDXqtSlfaMjV3kk4n14gI5nGIGpfkCBFwpOZ+/fuSBVZ84q2vmjBT7w/DTNyhU8hCoHV6ruxYnUpRigVE22Y08SaYH2n8UPtuTWfIlLsQpCelkQQp9AYcG2ztzrCMpAAXPO2eGDnivLilcKWa2dZ6LVwYX7TUkmzlgBaLqvIlU/3E83m/p6JsTXA/SRsfCD2WKDs4xR4zlRv5FwK2GQ891UW8EEF6/aTULwR/WDeLlP+bYRPMiiEI6N8nQ6khE+x6Zmk65Oe4i58hTuBMDGJWRq2GjLfx6+P3ZCZoiqYsCR2cWK3PHS/BdkjkSPAQ6I4nc6VWAXZJmW6rsJbubRiUPOYroH5Q+N/Y2O7goZIIOqqhwYNTspvLDTBRWvkLTQthfQ2IyHihpl29snBUIXDL9q3kbDlSqrfMkD16I9OJ7RWrgkUulA7rb/4R5nmRFaD7XRx9L87pWnDRGxjv1+JVnUh8Sjw+NBYxG68vYOSXJO0cEYT4P6ddeOkRUOkdnKRNDSAlmVERdmafkdSuktkz2aZZlYFLSkULFfYEbk7t7oREM8P07/uojpfKiXYqGwR6buXxfHUF25XZjbW+tBh0CKSH/SVikxtC5K10/vW37wX5NnDUkwPHwFDW45wjnFt37JGVW7cOsIW+9X+bIezZwAMNKyuDCrcStWPDpdFE7x0XYBhlELSSbbmIhlb3CzCOYhOYyo0NNcO8BEErJYCybV0EpIX6UgWRqwc469Jj+SWcqiw0cbNf9S1jpbrs8w8AWBEfcbH0//bSk5oBRnlgqvo9adtf+6U72RA
 tfpiLCKv
 c3xHQfkbSzRk9tvp3DQLGDtrd5CLowWO/RY7zQRHscVKfTEvHmiDhafMGKF8SgrpjW0xWUqxVApmzNrtv4txkJZUWg/SEW3NS9/Riv0JSxacEOpzRVWF0Tc9+DbZxmml9z0PZ5K5HzKwVrgHnaPD/LttsYutE1Evxw4q8u41Pnlayr9WodZBOFoy4i1J1ccmT4jQGFzDJFzUda/zKHCkzoMWTEYkCfEtVdatTBXIxT987yUHxeV82qX3EujNGTlcnmGKkn+LuYWIVVKJ3eQbO1bgQMvmrWmmP5nw3MGT9jgySWDAigixcwTwqHncD808qiZLo74cTjF7HNtg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When I did memory failure tests, below panic occurs:

page dumped because: VM_BUG_ON_PAGE(PagePoisoned(page))
kernel BUG at include/linux/page-flags.h:616!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 3 PID: 720 Comm: bash Not tainted 6.10.0-rc1-00195-g148743902568 #40
RIP: 0010:unpoison_memory+0x2f3/0x590
RSP: 0018:ffffa57fc8787d60 EFLAGS: 00000246
RAX: 0000000000000037 RBX: 0000000000000009 RCX: ffff9be25fcdc9c8
RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff9be25fcdc9c0
RBP: 0000000000300000 R08: ffffffffb4956f88 R09: 0000000000009ffb
R10: 0000000000000284 R11: ffffffffb4926fa0 R12: ffffe6b00c000000
R13: ffff9bdb453dfd00 R14: 0000000000000000 R15: fffffffffffffffe
FS:  00007f08f04e4740(0000) GS:ffff9be25fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564787a30410 CR3: 000000010d4e2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 unpoison_memory+0x2f3/0x590
 simple_attr_write_xsigned.constprop.0.isra.0+0xb3/0x110
 debugfs_attr_write+0x42/0x60
 full_proxy_write+0x5b/0x80
 vfs_write+0xd5/0x540
 ksys_write+0x64/0xe0
 do_syscall_64+0xb9/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f08f0314887
RSP: 002b:00007ffece710078 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007f08f0314887
RDX: 0000000000000009 RSI: 0000564787a30410 RDI: 0000000000000001
RBP: 0000564787a30410 R08: 000000000000fefe R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000009
R13: 00007f08f041b780 R14: 00007f08f0417600 R15: 00007f08f0416a00
 </TASK>
Modules linked in: hwpoison_inject
---[ end trace 0000000000000000 ]---
RIP: 0010:unpoison_memory+0x2f3/0x590
RSP: 0018:ffffa57fc8787d60 EFLAGS: 00000246
RAX: 0000000000000037 RBX: 0000000000000009 RCX: ffff9be25fcdc9c8
RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff9be25fcdc9c0
RBP: 0000000000300000 R08: ffffffffb4956f88 R09: 0000000000009ffb
R10: 0000000000000284 R11: ffffffffb4926fa0 R12: ffffe6b00c000000
R13: ffff9bdb453dfd00 R14: 0000000000000000 R15: fffffffffffffffe
FS:  00007f08f04e4740(0000) GS:ffff9be25fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564787a30410 CR3: 000000010d4e2000 CR4: 00000000000006f0
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x31c00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: Fatal exception ]---

The root cause is that unpoison_memory() tries to check the PG_HWPoison
flags of an uninitialized page. So VM_BUG_ON_PAGE(PagePoisoned(page)) is
triggered. This can be reproduced by below steps:
1.Offline memory block:
 echo offline > /sys/devices/system/memory/memory12/state
2.Get offlined memory pfn:
 page-types -b n -rlN
3.Write pfn to unpoison-pfn
 echo <pfn> > /sys/kernel/debug/hwpoison/unpoison-pfn

This scene can be identified by pfn_to_online_page() returning NULL.
And ZONE_DEVICE pages are never expected, so we can simply fail if
pfn_to_online_page() == NULL to fix the bug.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
v2:
  Use pfn_to_online_page per David. Thanks.
v3:
  Simply fail if pfn_to_online_page() == NULL per David. Thanks.
---
 mm/memory-failure.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c15ffee7d32b..212620308028 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2572,7 +2572,9 @@ int unpoison_memory(unsigned long pfn)
 	if (!pfn_valid(pfn))
 		return -ENXIO;
 
-	p = pfn_to_page(pfn);
+	p = pfn_to_online_page(pfn);
+	if (!p)
+		return -EIO;
 	folio = page_folio(p);
 
 	mutex_lock(&mf_mutex);
-- 
2.33.0


