Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE89AC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1386B0198; Wed, 12 Aug 2026 23:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179916B0199; Wed, 12 Aug 2026 23:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067316B019A; Wed, 12 Aug 2026 23:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C57126B0198
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:43:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6464D1C1665
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:43:57 +0000 (UTC)
X-FDA: 85094852514.14.0A8D330
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4040F40002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:43:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LX4wVwMe;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786592635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjBzaVi/IBnAB+6E2zKl2/5vb4yZbYCndoVA24pa6UE=;
	b=3FNZHTK3U1fU/Cli0AdSxusCyzziXzKmwsIlzr4QLN1CGZGrbpGgnpyGi3NXos47zySEyF
	HSM6a3pIMht03VHkR90eekuixyKLYwse7HwXy4BMCDUyuGpi3+DjymvIZY0OR9amvDJLlu
	+pGnYUQm+lrRCXMWFAS3X23e3H0xyFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786592635;
	b=X1Ck7pp6GhM6kIM5AVyC70kuFKUSszQf2O5Hp4p9XnqAZqecMicDRhdGElI/321QhJ2IKH
	mX3WPn8G2ExJV15oZfdABqJvRC96RTbD8pzpbuYNyryfZARlcdBRbdGBO4Mr8ihLcIZ68W
	VDoq+rGob8cjSogaflUZJfPETiwH7uw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LX4wVwMe;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jjBzaVi/IBnAB+6E2zKl2/5vb4yZbYCndoVA24pa6UE=;
	b=LX4wVwMeZgkz+qMnt97vEkblyz3yQOrKqcdK/aNq6s8mE/A6b7Dzbc0Kz4SZ/YsBdPtC/OQOK
	c/5L937ERZx/tly9nHckstPsOSV44z797WTwJMnl4lzF8s//Hnhl1N6wF+feS71f7eJopKsX2Yw
	SezLjl6oK2ITvBzVw1BiZ5s=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hL9v94M8Mz1T4Fq;
	Thu, 13 Aug 2026 11:33:57 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 16F1A4057F;
	Thu, 13 Aug 2026 11:43:49 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 11:43:48 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 2/2] mm/ksm: fix advisor_min_pages_to_scan description
Date: Thu, 13 Aug 2026 11:17:22 +0800
Message-ID: <20260813031722.569983-3-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813031722.569983-1-tujinjiang@huawei.com>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: uj5gwgtf4ra5itsowpu1q5yju47kot8n
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4040F40002
X-HE-Tag: 1786592635-65194
X-HE-Meta: U2FsdGVkX18DAY1KR6J6e/X9Xxdd8Tl8adzaxcwRSMGA8Uy2RjQdAYdEUl6MqP/i79mgKjRoiTrjQGF1kvgm4TdthvA7DHleLYzIq3mDhEZl8xRigQXJr3FuLxdoAX2B1JeXl9K3NS9HE9AbAqVDU37ujE6dXH8PxVDLA74ZPhuaSLrAtg5WUYhKTvHjy+KLIvz/kVd0g8OCRWfa5zs/eW+9zN8UCJtJaAIWBA+wsV1KHxq4TT6Jdtib5YsG1gHKLYhRWX98Eiv5heF19d1jbKUYGOnv78jRCsm1m0DY83RwLYtqsD5x2g3nTvStF2YR2/z1L/ALFd25a/ZtA+E7mAmfE0tfadQTveDnYwQWceq6JhDDBmeIAnglo88kfIfN1l5HeKnmCv3Umq2m3mseNRtHTsoV8CoPkB0gKdfmCeIBBFmrtn76YuhYvSpC1P17GQaX6+7cSGx0ZKXjLKb0tDWSTef5apVTbEETyMAI2yUjH1ajSpXXxI61nMOnj1Tv7r4Qj9fnt7kQPLgzfhDrmL1TDuXEezKysMqlJFJbzfAsnj/jOUfGwYgIhfhN+CJqzcwEGWVwCiDG53cDI7b+jYv8aKqPKZ91Lfeh8UIopNS4LWi97XjTdPtyXGXmVpLWDrnDrzvhjzGJL82e8GHmVnHj2LIw8JeY9ukbjGgj0dagiuW6Cz4fc+4UMvDriugq/cM3PiXLRJ/0JvSFkhH6FIUyXdiCr8vygS1ujU+I8yHyUXsthdK96ks/4D80gx3BxAzHoVhifx82RfNY2Vw0LlNlH8zY2l7zlPqIO0zBGVbNc7FEjOkGeknYZcUyFR+Ue5EqYA4SNDvfVTDyL+S0/wg3ZdirAh9vYHSXsfogbJFdFrdImdu3hsRRbeSUpJuGpC+Jh5GwIGpMZQ1PJsC4LjsoDudTxa1s6xA2EwxdatWo9E6wBvTtXf3ELXPRgb6hO+//GJ7ORw4LJHuJDVF
 YBbCe8Ke
 b2w0WzVoECLVeI3gQr64lesup5disrJTs/mqvGKsPl1Hn3OMIBfihsLcZkQk1SBGF8YxvTmgCk5/s2uF2WmP1bob/HAg78Uhf6ILMySe21cuUTrQC9plYvsd7M6urzlNSxByYYWtmy9sD25EM0bGJf0njFWyhai14hNAJ8w82X0hQsy7Tnwi+rBcye5pKLK42p3bi0+XJiULuo4OJjfs4eKdlp9/+7FnLXyTq3AH7yGVzxjKuifzBwo2yVNpkAY7lZUTqxgKjpFIk0fVFFbpa7rTx4tklVfGV401nbdwJKcdVCa1jn5Ym8Bl/MjuvOHuSPYyQkfZU84iBijed4DfHbN4Jnc6vIb/qKEOaUKv41FbwVOU=
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
[1], but the documentation wasn't updated.

Update the documentation and comment to match the semantics of
advisor_min_pages_to_scan.

Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]
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
index 7d5b76478f0b..4a6cf8cf5d60 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -342,7 +342,7 @@ static enum ksm_advisor_type ksm_advisor;
  * Only called through the sysfs control interface:
  */
 
-/* At least scan this many pages per batch. */
+/* Initial number of pages to scan per batch. */
 static unsigned long ksm_advisor_min_pages_to_scan = 500;
 
 static void set_advisor_defaults(void)
-- 
2.43.0


