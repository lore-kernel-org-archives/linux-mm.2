Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFACDCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B07C6B002C; Wed, 27 Aug 2025 22:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061E86B002D; Wed, 27 Aug 2025 22:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0A96B002E; Wed, 27 Aug 2025 22:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBFC56B002C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:55:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CAA9160909
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:55:03 +0000 (UTC)
X-FDA: 83824649286.15.B7ACE0D
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id D4F6710000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:55:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756349701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=vP3bPNsI4a2punt8nQRuyL5lWzCFmFt+5V0Bd8BbMa8=;
	b=cElsS6d29ShVfJh8ISx/sPr9rGhuuYsC5FEd1/xcxAOKHvNnskTL5A2nA6d3ZOgl8N6+pt
	7DaB5y47/36dg7n3vos34ztEJSN8Sw9PIK4x0wASSclR91iFAZTTzji2BQ9DBRKh07SWx4
	gcNXOymU4RwPPlF/LH1dh2wxMM9cyq0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756349701; a=rsa-sha256;
	cv=none;
	b=vKJ+DeyyM6tUX2JYAUmLlc9unGSl4c+nRtVd5oOKcrGR8WRL7RIEaU87oNTspWMlsAt/Ha
	i/dROH/rrQX9iOEL59dp4H68s0g460IcjZWLMIXQC4/dIzOayz16L9luK07NmQtHIDG+bc
	7CRe+oMR7clq2kp1O3LdaJo8TEOM2c4=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cC5d00hTzz27jHf;
	Thu, 28 Aug 2025 10:56:04 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C6AB14025A;
	Thu, 28 Aug 2025 10:54:57 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 10:54:57 +0800
Received: from huawei.com (10.173.125.236) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 28 Aug
 2025 10:54:56 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>
CC: <david@redhat.com>, <nao.horiguchi@gmail.com>, <linmiaohe@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory
Date: Thu, 28 Aug 2025 10:46:18 +0800
Message-ID: <20250828024618.1744895-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: 7mkq4fmqoxf3z1zwuht1switshmxs517
X-Rspam-User: 
X-Rspamd-Queue-Id: D4F6710000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756349700-642925
X-HE-Meta: U2FsdGVkX19YS50pKoAyKa8pA5LQrHblDAUe9lwOedkGnZYJZBjZ1N/OieqhkpTD8WosqaK0EDDYUHX3hKEYN+9aJoFVZkjqvqOqD7jCiyOxyf5j/EDvcg9TmTogyXrQd6h7XZ0xaeaIeRoJkZUoIY8WoorAoBKOmEcaUVmf6K3aqRRSnSyNIPtH5v46nr1iS+SSUfXX/twenLWf9wz0g2Gyk7h9mfWvOUnj2MP5gDL0tY1df6YzZl/J8yxeO+JZmruWov1M6izFA3M+k1cn2qw5/P++k7UaHQLp//7B5pQoQbQEGgGIPwzMtz59W3Zf7J71IWQzLc13JJ1t6rQb1+SUe8h+aRY9ZLgVeD4tIDvg2K7wn66Gcy2g2JE70qB6pI9fI0GYMMc7ocxq55GvvvjYMMpjy+7KYgIPEx5v80cW8DO/fCf+QZdNQuBRvW9apYHkj0ia2W/vRO5p0T8EO6cmS0BjyaJy7BcQbMtcYw7SOSrlKzDP5GhAgVJ0wljz8pJEYerCckD1SB4BGu/zLEcOsaTgACxhTeJJhPqqCZEcLnzMC2sAeGZVxRhLndh+6ufa/zM+DGXBDXgcntEHjrPfmD1PRlZcxSFoV2bCT1/giP0MWjLgWNeS2znp/u7emvYs0RhLr3ytB/Wf/nJ2rtAIh4Wft4qcNkTn/2+rsKgZu29MlrrnLhdeiggJqG+eVjqOLY+sDE7ByQPJu9LT9wUiNsIQGaczQTvd59w3DffWkfndTV+EjXQZ/Rpztt7XsUSv7E0vUHPYRdNZ2Qi61cFMOdD11rIpdsfOmDpc1u9rK7Y0bzV6cnnI5AQNNuww3oxOSx3vsflKNKbx10SrobRXbXHHdPj1Lp8x+n05sKNPf/Mc/n6h4f1ZtbWbubMOr7sMfSegGfoPP6l+xSWHqgFh+KAVJA/XCKo1vt8rCERT0aAPvnU/8EP3Jx2Lj/foEtMD2RLSQxqfQMDhm+b
 7WkubD7t
 pwYGBk/+FENyC8jYGI8NfWUCgWEKM7lPNkbdSRZ1iwMvZDro90E3NkuMi4nhbsGlD6l/GAllrwVz4dhLYQNa3OkU76SMff4Nqln4JcQSvSBKoqh1XnZFirbMfL7/qZ0W1L77PyM5RMVqGrktyOsY0kGSlUTTHDKipYeYhOlWcG1dMUHcsogGuDadeKBOOcVZg2Y/A7jMwe6uEID82q/EU2bLKl937e66xMvb6fDI9IvWoi3QVggQ3+DnlH91Z0J7fmdterwx5sRBMn6CfLaofh8KeJ0yFmaui2Ety8dnEnNIUP4oHvR6PoaGnEbdTntJrBEOlBhfvOa3EDgk=
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

Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
v2:
  Use pfn_to_online_page per David. Thanks.
v3:
  Simply fail if pfn_to_online_page() == NULL per David. Thanks.
v4:
  Add Fixes tag and remove pfn_valid check per David. Thanks.
---
 mm/memory-failure.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c15ffee7d32b..4af8875b07b6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2569,10 +2569,9 @@ int unpoison_memory(unsigned long pfn)
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
-	if (!pfn_valid(pfn))
-		return -ENXIO;
-
-	p = pfn_to_page(pfn);
+	p = pfn_to_online_page(pfn);
+	if (!p)
+		return -EIO;
 	folio = page_folio(p);
 
 	mutex_lock(&mf_mutex);
-- 
2.33.0


