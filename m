Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C00AC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5185E6B00D9; Fri, 31 Jul 2026 05:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4597E6B00DB; Fri, 31 Jul 2026 05:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342906B00DC; Fri, 31 Jul 2026 05:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05A736B00D9
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 747FF1A03AB
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:01:13 +0000 (UTC)
X-FDA: 85048477626.30.743E18D
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20270100002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:01:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="ar2P7v/V";
	spf=pass (imf05.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785488471;
	b=ccByIPMp1F4sb6qsZ0ow2CWN3P3vRYFmRV4VRosQ2X/hoeozKfaG2HLHTmr2cDFJ+/LGxU
	EEJzlPLtpVNIBOC3qaoMHwnGBAJQ60V/dkl9Nca50tysfFSH3hqLsFuKsipLpYzpd1eQ1k
	78TusQJzrDQ1IAmqchJtsb5ChK4DVjA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="ar2P7v/V";
	spf=pass (imf05.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785488471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWHNu5nnHvi1saS37X/nC9nHmu6f5Mr/HJ2eHj6UvJo=;
	b=JvUpkcGzYfz20zT4AniVbVGvIQMbAvllrKRJPpbrONzIiDHINiwMNtdCBiD6JaH58jcf6y
	5pzsDFBAnV2j0+uTMOUOm+gTKIcAD9hoJzmQ3cVVH1Di6tanVUkiazwUVteNC3tPRB0pdC
	3H7usdo1vg0kfIRIMIRxoewyt3ANVDM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QWHNu5nnHvi1saS37X/nC9nHmu6f5Mr/HJ2eHj6UvJo=;
	b=ar2P7v/Va4ljkTEdmQImY53t3Col+VJahJqZJM50prKhJT/2RYzHbTTr020jiPWtw/9IU751e
	0paf7PyxophY5LW3YKEwP8I42KfjTuFqH43++9Lw3eBZ8y0FBmiWi47k+lRhwezu73LbLhASNcZ
	Nx4FVD5IdsCTNw69SHTpVHw=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hBKYl6rdwzRhWS;
	Fri, 31 Jul 2026 16:51:39 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id E9D3A202E6;
	Fri, 31 Jul 2026 17:01:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Jul
 2026 17:01:06 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH 2/2] mm/ksm: fix advisor_min_pages_to_scan description
Date: Fri, 31 Jul 2026 16:35:26 +0800
Message-ID: <20260731083526.3953421-3-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731083526.3953421-1-tujinjiang@huawei.com>
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20270100002
X-Stat-Signature: fyh6bdi8r9soemt8ieiozeqrs4c7q7x9
X-Rspam-User: 
X-HE-Tag: 1785488470-528752
X-HE-Meta: U2FsdGVkX1/4+RSFg3M5wa606bTyTY0RdYv//3ExnjtqwS8XhIqkxBHkS3pjKKZkvB+yExBItL2lep1Su4nUXjA0U/52vKiaWHwTx9P/8Ty69vciFZ1Qyrv1eClgl1uo5eKPks31BJrKXD0fP7LGMtQnurhopNyG2SI+/mOTtNbCnRXQHde/nFk+Y6kzKROzjUiiCYeKzaE/JCzzidd+W/qWcrc+Pk3IRzzf8zKHRTvmf92rqh7UH45Li5/Tm9HqR/8xN94QJz/2Lj1FB9bRXFGgfaZKd6KjvVjRw0WrQxuxM7+gSTJcOzHLEdCS4UvyhyOmcQvy4LMpCCzKKI9OOQC0L3PMj4n4I7wC5UIwyLg/WxknofbIgIzGWfRETSftfPR9Dblq32Dc/tyUSnFosa5b3LwoOGAGTxP/2ioVk4VmPv0Zr5xspI1dJTHU7nf0RmuQnXsibUZ8GIrtBL0iddiNb50uuu1yASYDiZrHcc15JDcfU567B13N6AmK3jpqSle8+bqNfFK3jxg+5iOMSICHZo/4AcpVbEWKkxsbE0s+8gpiqyb8M4VZkuFXy18gLap2JfKGbCGliKI6ANtLUt5AZPXFM1zsa7fsjC1Sxnxw56l3JdaN11sc46xfv1JJ42rrL9VGo7TMlQN3fmRCq8IaVT86KYpi9AaK2jtaEXE8FSXlfT5FLeNWfWn9Rn5wxq3P7RvYitlMBKlF/4UAELU52PKiGvTH/yvQLlLs3M4A4DjG6+xXIlu0yUFBYVFqfVhsWNtF0ejMhERSKfJZSc7gXSwSDvmPg8bTa5NqKQASeUBynEQS7pp4rHnbNJyYjiu0dGukpB2V8fqWahLxg9QHF7ZUXIP5yEXtTWO/LdLaFuqwdHHUfz3k5caPAb89W1TX7mdcWZToF0MhIhG8gbltFC9dkOyws2QPSweHlVCO6YD6MNIFidjxhsPPXbIADxQFQ+OTMpZGFHoaxDr
 xU8YuVum
 Vao7ZAuPffLnkb2dAElCmvzf4EK5ALx7DFL7oYwh+Ah7aazfGdxkCDoPtLRAf5OZIFuwfbJzGahJgMwHvmj1G+wdt2O8qTTtSN9A7dPcrNyxIHRoy04Wt7x+rf60v8GPcS1Jk4a9Wm9kHv/9z4ooFWqokqDaraPJwJeZgs+A0mudz4KQKcyXRk7wHImXv1Bv+/NmT2m7N77R5XWV2KORpxs41o7YtuNHbTpFsg0D1PYim5Hcqo4TKKo7M38guslB6omyA6ZqRt14kqCnakIOIi47MFHVLFb5T1utbRadt/921xpjm2IM3EmYaYFFwSvsHTsEAqgOKoRpMlwSy6qTX6eFrP4u18P0mGoIYMZnOHv+jIBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
lower limit of the pages_to_scan parameter, but that is not how the
scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
advisor") only uses it to initialize ksm_thread_pages_to_scan when the
scan-time advisor is enabled. This will mislead the users.

The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
[1], but the documention wasn't updated.

Update the documentation and comment to match the semantics of
advisor_min_pages_to_scan.

Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]
Fixes: 0710f38ad26a ("mm/ksm: document ksm advisor and its sysfs knobs")
Fixes: 66790e9a735b ("mm/ksm: add sysfs knobs for advisor")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 Documentation/admin-guide/mm/ksm.rst | 4 ++--
 mm/ksm.c                             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index c9f533b10f6f..c329ca747b8c 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -183,8 +183,8 @@ advisor_target_scan_time
         pages. The default value is 200 seconds.
 
 advisor_min_pages_to_scan
-        specifies the lower limit of the ``pages_to_scan`` parameter of the
-        scan time advisor. The default is 500.
+        specifies the initial value of the ``pages_to_scan`` parameter of
+        the scan time advisor. The default is 500.
 
 advisor_max_pages_to_scan
         specifies the upper limit of the ``pages_to_scan`` parameter of the
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..1e3a9c657a64 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -342,7 +342,7 @@ static enum ksm_advisor_type ksm_advisor;
  * Only called through the sysfs control interface:
  */
 
-/* At least scan this many pages per batch. */
+/* Initial number of pages to scan per batch when the scan-time advisor is enabled. */
 static unsigned long ksm_advisor_min_pages_to_scan = 500;
 
 static void set_advisor_defaults(void)
-- 
2.54.0


