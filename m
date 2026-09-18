Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCD4C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5566B009E; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6AC66B0092; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A176B009D; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5206B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06C9DA5DDC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:59 +0000 (UTC)
X-FDA: 85225527198.24.CDC7C69
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf15.hostedemail.com (Postfix) with ESMTP id B5A9EA000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VBzDERMy;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUu5Mif0L8trLz2WDJF44yPBNDrTZZYsfYbfGjVTknY=;
	b=RmhBwiOoBnfSyYpAbxEHHRfK85nkf/37IlL8Sw/EWJBf4dTb6w6fWAbjr9COvEOP+Xphc7
	u85KIeYjQ0oGaaKKQbB0pev9ii6b+EqjkIwpaXzAFZ8HX5SGzOr+v5biMmVn62DeqfIbO6
	MSe4QjFjH1Yx0qdELeIyhNwfimcWMxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703936;
	b=EMKXk+eF/4Rra9MveZHzITRt5k7Q0fGD7qNoOvfk6VUH7Y7Z7hG+GmGv914OehgqeXpIpa
	BgS4HEFExeiRay/j7Fr/4k0W8m6kkMZej+nRG1euxklISv8GrS8MparVTsXSo3eyjac625
	8Yqn9toc9BgUYwMuh7XOQ6ok4+/iD6g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VBzDERMy;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703932; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=aUu5Mif0L8trLz2WDJF44yPBNDrTZZYsfYbfGjVTknY=;
	b=VBzDERMygeCgMKc9Py9Tmq3ZF1MI3WEj4LjY3Q8607hicA4+DdGUCPna8Ws/u2nc/C1njdpHoco9nl9F+sD3haiNee09t/odqvWVJesDw3V75EaWIIqC4ltfOTFwXVCb3Zb+Zi5NY9VO/obdbHcHRkrMkht0MIaPmQkJSfHiqPM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9uK4l_1789703929;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9uK4l_1789703929 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:50 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] mm: shmem: don't expose 'deny' and 'force' via the kernel command line
Date: Fri, 18 Sep 2026 11:58:34 +0800
Message-ID: <eeb806b057f2097a4d8d2edcb9ccf850aad8f38d.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B5A9EA000A
X-Stat-Signature: e7sbaz7g3to6chkxz66r8dchpbcc9acc
X-Rspam-User: 
X-HE-Tag: 1789703935-547245
X-HE-Meta: U2FsdGVkX19lR7ajr9oMobo4CwakTqfqd42uwCuNqgEUphCtJH7Yitn12drw1rh0cBIwjZxq5wkW8Mjp3pNaCf8+2DkEFmtLxxuq1FD9llKobLnwyZOP5VxO0DeGDRnO2WNg4dvBCR/JQyA/ZVQRLlPk7ZCrZ1vw+8giFlucwmRzlpa19zke8y7oWcOrhSD288hJXSiVGxDFTWlX/YuUNOqqCTikqpzEIN9yzW3PuAEUGhCS+kzv0HTGruAhwhWxpXATugRBEuc6PEbQB3Q3ojwNPtGdXg6laX0d5ZAZRLWYOniK3R2BgreQaeFZE4oXC9MFotVRmsXHo2RfZLRNlPrjyEZKnQig1efrL0Caw7t9A6yDPosR+y5dCyZdJx3iLKGhJntUBoCFHXg5UEaco5KNrmtdE7IiUAEt1wB77DJdFhJiGlzETnVUzBFSmLGundY16F/iLkINQvEZg21kg7yrlu5LfPOKRSfA/HVU/NZKfru/y1PtzIR73tw9MYLGya50uIS2yP1neg4ZhaScz1EbtoOUSknSiXJSeRB/h7KVT34yWTUAqahLd9cOZ9gnVOXBjS2MfQFENrbwRzUrkifYYxlPh/fMLRNjPiTmK/ogslKUDyi8Yo4fLXcSXeXhjo+O+tzXvtM8sPGZFzVpV7UMU8713Ds/43c7JxjkHxGrxJPi/SNa213T5TsIkdTOkRo4MuzA38aEqmsy4yRGjdrmjy5fjk6fLw0k5b797a0zZ0iNfHRCr5PeEXxGhhjXtqxbapFv5N90Xr3b+JR05TkMo/VfSsEkRzpMdXkmb/8Q2KteSDnrO/Mk+s4yPrnjUzczUJbs/p92bbhbfYGk/oKtZhDKtEAH/J2039kTmzFSY8Am26mK/fxuxEzJzeaZIrvop1YuCYtC7JqExDIcTrQZTlmMG9m/gEX/wxG1XoaESBfUxXmIRHBOkjACw03BYJFJl8gdsolbDb12sz/
 W2QgPVX4
 HA7RcQI/i/A3SpPJYyF53oDnVePOh0u5JuUqr8vUHdCLjT6+L0F71WBI5iGH4sNgPbFfqwqmFwn9Hug1TJgdBr2Up1/hAm0rBwAEMJBlF8FY32i6Jlif5n1FsHiA9vzga19sH2xDpk/62D/PVQe19kUvOrhLhNsQ0F74e8FGAL1T3Od8ksMMk1lkgd/6GdFHDLcByr2aiJ8okuLN40dNwoG6u8N4bckWHAOb+FYwkB0dxJXe9jc5slHcYtstzjpGoBseDvcxAnEdNth9N83wzZQ9voA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Based on the previous discussion with Lorenzo[1], the 'deny' and 'force'
options are testing-only configurations and shouldn't be exposed via the
shmem kernel command line.

So drop these debug options from the shmem kernel command line and update
the documentation to make this clear.

[1] https://lore.kernel.org/all/6e4aae7b-2c71-4109-945c-6481efde3636@linux.alibaba.com/
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 Documentation/admin-guide/mm/transhuge.rst |  4 ++--
 mm/shmem.c                                 | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index b187d618452f..0a8265d1cb55 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -389,8 +389,8 @@ is not defined within a valid ``thp_anon``, its policy will default to
 Similarly to ``transparent_hugepage``, you can control the hugepage
 allocation policy for the internal shmem mount by using the kernel parameter
 ``transparent_hugepage_shmem=<policy>``, where ``<policy>`` is one of the
-seven valid policies for shmem (``always``, ``within_size``, ``advise``,
-``never``, ``deny``, and ``force``).
+four valid policies for shmem (``always``, ``within_size``, ``advise``,
+``never``).
 
 Similarly to ``transparent_hugepage_shmem``, you can control the default
 hugepage allocation policy for the tmpfs mount by using the kernel parameter
diff --git a/mm/shmem.c b/mm/shmem.c
index b572c60f2af8..951e922091fe 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -668,7 +668,7 @@ static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index
 	}
 }
 
-static int shmem_parse_huge(const char *str)
+static int shmem_parse_huge(const char *str, bool skip_deny_force)
 {
 	int huge;
 
@@ -683,9 +683,9 @@ static int shmem_parse_huge(const char *str)
 		huge = SHMEM_HUGE_WITHIN_SIZE;
 	else if (!strcmp(str, "advise"))
 		huge = SHMEM_HUGE_ADVISE;
-	else if (!strcmp(str, "deny"))
+	else if (!strcmp(str, "deny") && !skip_deny_force)
 		huge = SHMEM_HUGE_DENY;
-	else if (!strcmp(str, "force"))
+	else if (!strcmp(str, "force") && !skip_deny_force)
 		huge = SHMEM_HUGE_FORCE;
 	else
 		return -EINVAL;
@@ -5680,7 +5680,7 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
 	if (count && tmp[count - 1] == '\n')
 		tmp[count - 1] = '\0';
 
-	huge = shmem_parse_huge(tmp);
+	huge = shmem_parse_huge(tmp, /*skip_deny_force=*/false);
 	if (huge == -EINVAL)
 		return huge;
 
@@ -5807,7 +5807,7 @@ static int __init setup_transparent_hugepage_shmem(char *str)
 {
 	int huge;
 
-	huge = shmem_parse_huge(str);
+	huge = shmem_parse_huge(str, /*skip_deny_force=*/true);
 	if (huge == -EINVAL) {
 		pr_warn("transparent_hugepage_shmem= cannot parse, ignored\n");
 		return huge;
@@ -5822,7 +5822,7 @@ static int __init setup_transparent_hugepage_tmpfs(char *str)
 {
 	int huge;
 
-	huge = shmem_parse_huge(str);
+	huge = shmem_parse_huge(str, /*skip_deny_force=*/true);
 	if (huge < 0) {
 		pr_warn("transparent_hugepage_tmpfs= cannot parse, ignored\n");
 		return huge;
-- 
2.47.3


