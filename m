Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2896CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 12:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9708E0003; Tue, 11 Nov 2025 07:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0F08E0002; Tue, 11 Nov 2025 07:22:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE958E0003; Tue, 11 Nov 2025 07:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07B4C8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:22:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF7271A056C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:22:48 +0000 (UTC)
X-FDA: 84098240016.17.4719B5C
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id 03F8F1C000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:22:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="L+Uok/U3";
	spf=pass (imf18.hostedemail.com: domain of liubaolin12138@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=liubaolin12138@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762863767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PyiYxn8lL/DlnyD5mwmLoz2n8Dhjad+J4FY48YwfKxc=;
	b=ak+puDGKI0uu6UhESuXZL1i6Vep4+cAYXGX6hegjjOY0R7hxGuqmunuUuaitCYmZ/68n6/
	JHQZCACry6sQcc49Kwuw+qKvPehah8a10uCWG1eF5I0PYHsUY0d75bP8Dds7jKSYDRP/0K
	JI0Hp9nSjWpF3Z3qJBeR8obJzNV6ywE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762863767; a=rsa-sha256;
	cv=none;
	b=13u9kdcTkt8Zsg0GKT5fRp2b5Tc3r8GTTj3nOk2ndAUrJ4EilfFlb+r9UM3GMkhhIsTdi6
	WViAIfS0LK2r7s/IgEHF28kngQ2JlteLgZVIRauKf7ny0emzP4qDLkVIuNjq3V9Ykd36LQ
	DQZ7iHqMjc8GIdaOJ5ORUs2IQg5J7Lw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="L+Uok/U3";
	spf=pass (imf18.hostedemail.com: domain of liubaolin12138@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=liubaolin12138@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Py
	iYxn8lL/DlnyD5mwmLoz2n8Dhjad+J4FY48YwfKxc=; b=L+Uok/U3xP4tFRHyB/
	MQP3IVxlcWwswIm1QTvI/6ooruHjXapLNpH5rpN/8l0IYlPLKHNOwsWWmZXK/l/L
	2UTuDJ7hyDkIpeiFv1e2nJF4tO0iGNbFeCu+pbZ0EEyz8VcxgUyU0EtbINMUqTDP
	JF0fIarI9I9nY8OqvurAr8aW0=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgAHGcRvKhNptqpXDQ--.34713S2;
	Tue, 11 Nov 2025 20:22:09 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Baolin Liu <liubaolin@kylinos.cn>
Subject: [PATCH v1] mm: simplify list initialization in barn_shrink()
Date: Tue, 11 Nov 2025 20:22:05 +0800
Message-Id: <20251111122205.29940-1-liubaolin12138@163.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgAHGcRvKhNptqpXDQ--.34713S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFWfWFyUXF1UZFyDAr1DWrg_yoWfKFc_Zr
	yjvr4kCr15J3s7Cr1kuFn2gwsY9r1vg34xKrZ29ayrtryUCan8uFWDZw42krZ8WrWft345
	A395AasFyFn7GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjEdgtUUUUU==
X-Originating-IP: [183.242.174.23]
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/1tbiUh8DymkTI7SnDgAAsA
X-Stat-Signature: j17trx88crz38tm44pu6xqr734tgazww
X-Rspam-User: 
X-Rspamd-Queue-Id: 03F8F1C000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762863765-111448
X-HE-Meta: U2FsdGVkX1+F4+Dd6ePRnd+G82TCXapdFiwtWgE1HyiRHjG48R+sNbEgwZxLWQwvjMeRBzfPrIR3Qx4+U+9/a731VJivlM8hxOj26eq/wpHr64y0alhsurMaH/ja3Ez8AXO/dRCVKqgocu8Iht8xJcQ0y1Grsybxohx++Fsp7f7OtgEXG0rBF1L972S0vYWglOMZCylOGpT2F1al+CTkOTDhKM3VeRktU7a7yQ+xW4VSPRip4/DBgjYw06YsxrbZpQyTknkt+yi3GIMenHpe2+sz0roY+BMNd5QLmbT+24EHRXD7mEKOaLGvIUo45ikDUdrq6tfoaQB7Juwovn1berMtLYSB7EN19TZxWX972z/rbf3U72cbpZqXnLTgpSt4jFqsZcdZhCv3vS+ISbHTUTwQMq0BIN/TEzA5nSf+cOTPRk0Sy8GAKPrMXrvCNeqREBEUs/8QXFdVlKeBpi/h6xlodVj3f3bQnRxIIudG6B3UdKndVgFhEYs3XiDBwqIZByWraXIjbrto4GC3irXMtrsF1eHEtb6e54A4CQTGDQLgSvD9H9xtS0YQlliPjRRrUb1v52U3jf/M8WjJ+eElyKAq+rLHYZYgmLc2r0C/JKsMoA0biHw2K5HKAfLl48+JcVoilM0+b0xFnL/kcn9x6X4VIuJ+408aXxlNxKDL42l9LQHiY9bKRrSeG5x/JiYwV4q82/QggJOCXaLBGtjGV6FLMIGI5qTfStaCCr7fTvupSu09xRKRANHByCTUIgtbp9aJmY2idUL8XUxaBvbnO/IUbF+qx4jcfZOkfr8V61QWgqIUlWQaXJU3pird2v1YJo9vdbZXbmnbtCatB2GDYhHft8sSpbGbnl7w0f1n9t9mUncStIu254C36blSgt9wKw0/oHY4JKNnX5/3Gi8TbykCyUPuRa4lZzoY3vfk6MBPsAqHWl7Ac82FUBFkrU5Md4UYV0eQIkIfTj34+P/
 xgkUwVyo
 c1a1cQGKpyVUWxcihRcn7hVP8YLVJhVV0ftRorv0V62AtZ4+5ekUsWzChE22GSBg+aB7cMSic2euU+/xCvLcLeo8rV0+bDFqp7SOsYtJr8/0EX3MEICEpP5MZbSURrDwIBc3aLnmkDDjBuewqQ9eaGBMhig15AtpURTECtbchZ4mQT/KNEHmTQEKSmfakAHBE04J82KgrQSM+8hLDlCZl/g9D7VAvBaxsVVd5GM5Ze4x/KjnhQ8sX3vX6yScvu4EwqrSqvGs1o3N8Z3/68k4zsQlPBbfAxM5x/T6uUJsJfzOp5/4RuajbrKkOkZGRoPQHMEPmGWmEzAhvUco1gIKiU/Elre7JHPguI+znncGB0OcI0x3JDIMfecZW2dA+DgNW/4w+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baolin Liu <liubaolin@kylinos.cn>

In barn_shrink(),use LIST_HEAD() to declare and initialize
the list_head in one step instead of using INIT_LIST_HEAD() separately.

No functional change.

Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 mm/slub.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f1a5373eee7b..0ab5d87305af 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3011,14 +3011,11 @@ static void barn_init(struct node_barn *barn)
 
 static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
 {
-	struct list_head empty_list;
-	struct list_head full_list;
+	LIST_HEAD(empty_list);
+	LIST_HEAD(full_list);
 	struct slab_sheaf *sheaf, *sheaf2;
 	unsigned long flags;
 
-	INIT_LIST_HEAD(&empty_list);
-	INIT_LIST_HEAD(&full_list);
-
 	spin_lock_irqsave(&barn->lock, flags);
 
 	list_splice_init(&barn->sheaves_full, &full_list);
-- 
2.39.2


