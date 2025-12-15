Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B25D5B86F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 334A26B009F; Mon, 15 Dec 2025 16:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8396B00A0; Mon, 15 Dec 2025 16:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197D76B00A1; Mon, 15 Dec 2025 16:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEC086B009F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6B5F1403B0
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:26 +0000 (UTC)
X-FDA: 84222966492.07.6FEA1B0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 047718000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DPEOruvF;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833445; a=rsa-sha256;
	cv=none;
	b=K5uWGLJFQNtqMvBnaezrwQs8VmcLQcogTU1pJpSaex3sm8JotuZ5ItEkiVdi8dtbrWnigV
	WJjvSpJmRYvv+CUJVyb8S0MZSIlD70Ob8v14/hG1CH0Xf4/VLi9KhgQbpsL6rDN4eAo75f
	aeBlmyFsocabuSRyQNREbUppNatAQls=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DPEOruvF;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2PbOLfYPhFxdlOOiPwr4Dslly/YjHx+LvU3PsfPUTg=;
	b=1zCkH9QxHiPjG6dJZc2iS4N4AujrcIQ+eQ4NqZg/47E+tzmXXuxhrgCre/u+zv6qinpipO
	l8iObVYlJ5KYio4WZ68ZdTOD8LblAx1LWHMGFC/GlZewxXY+wzNVL559+Xqdc3/uVTdUjn
	9YPK+Z1nA+gZE8NVe1F0V8bqWoZKLvE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2PbOLfYPhFxdlOOiPwr4Dslly/YjHx+LvU3PsfPUTg=;
	b=DPEOruvFd52IAD1S7RQB00csHgJhcEwGHS3e9AnOsddMCE8XjzihgPi0N1fqT/Um8nNKKN
	tRVYbm+qKY5vdJQujYtEae9jyYOt2MceGlWVcdaOl09sLkOLLOcJHyAqbGZhaylw+6hIf/
	iFfgskG9tv3j+BoZtQmE+ggSzFL25C4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-ki4eWxA6M4yvJz2On9rXIQ-1; Mon,
 15 Dec 2025 16:17:20 -0500
X-MC-Unique: ki4eWxA6M4yvJz2On9rXIQ-1
X-Mimecast-MFC-AGG-ID: ki4eWxA6M4yvJz2On9rXIQ_1765833439
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E22DB1801212;
	Mon, 15 Dec 2025 21:17:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E4CC41956056;
	Mon, 15 Dec 2025 21:17:17 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 10/11] mm/thp: always enable mTHP support
Date: Mon, 15 Dec 2025 16:16:52 -0500
Message-ID: <b3588c1a6976cf8d00fe39f5cb8918b42e4d4c3c.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Queue-Id: 047718000D
X-Rspamd-Server: rspam04
X-Stat-Signature: rnehkoky6baqdo3tu9tuxa1tbebfh1yh
X-HE-Tag: 1765833444-77011
X-HE-Meta: U2FsdGVkX183rFO2Zq0xP0MfYOnQH+4ctZmLdHN3px4d3p89lTBDgiTxdUtcp8PqRmi47LnXw0jKQPfkgctjZOSRuuAtFikoe4YLiF1lbPT9TjjyRQ04TLC4B23JeKpqh1xtnhal3pmQaKYRjrwr9gewj4v7HQbo5/I1HYELQEaRvhKiOpkfYTeAl943B548whr3YiHgnpnL6toQ7oBHBR28kOvQ2i6UfUxSqTeQnx0sZY9PUEVC2RmbkNTSQfjiUmOMT+dkfUr7FAyELkJV6hnRk7KtVx30LW5TTbxslZzzgLfrLMnq/8hpvqPN5cX1uX4UIiAnxrpkK20OjYP7WATtVH/f9278I+KPfPC9jxCScCqkWgdO1KiNhLpGrKUI0jdHoKJJKuaP5ziG3LqDZ/mghIv3+1Nf95z5dCxMNcyEvZJqYR3/cvMYWcForiQe5TaAbBChxV+S+qnX3RjjqPAO7V7UAGB9pzpOwZ0QxvlsZ7YLQj5EoNmUdQV4bYn2+3mYYVCdsJN9HC1oJ4dm0vrZsyNVpfJ3giRUKnM9EopWVKTlXqgxMMJnILKmvjEvZvW539+kSxW2j5JlymGR1ivu6j0Y3c8ZtI580a8kNpPGT/Cxf//nvry2pra2cmqPIc8sFXM2Ng9D52Dj9ayzpiQFfbqKRDnqARCvCrOF5/3c/4/+K+dH9+Uh0ELZsDwhTHuB7ZbOyXgUevBsU6BBiBj4nH5Cnd8bnUW+tdGkwTnSLOMmaoCmHONHXUJ+hry6CK4dwZJKOst+iwK/qttbCf8TStPBZ40JbsNt5SU8VFp4zRC8ROS8V0Bz7HgPvMaGD1x8eCzUZ4AlH2OyYLSolIdGrGyVetfc7R5xgp1b0ovwkZNS0CQVaA7fqDGoY7nFQb2CqCw+pwEOM2BYgfetsaBAqSiRBG6Pl+aZdOAt3Ox3mAgacHrSo7CsCFJB1Zwjl/2KyglOcOTHmqg+vtf
 2keDMu8t
 h0Vfp4EE1PWfe7YgE62FUsDUe6a1mWiOuSLCIlPBM0YwlqQRvmlyYZJzUg4hlS35kmVS1oTLYI2LazpM+xFsWZ4nCwXcO6YCRjK8dCVbPZsbusAtvQqo/FD16FNWxQrQsT9ZtdJ7cnElxzcgcx4ghl0NEA9KerzqT108Naqj36wrbFcSYadzH8IOlfdbTf0Zdw9CadXhzLthZiAX4oQhv5q3ouM3BerH+wbWJIFRZWD/1mY/cZSISChodvFKYLjWszRitr5+oDBvVhLagJ0BAuuWmdzWeqiGy5Z6FAQr/WwR5WeQDnAkNYDqd4h54Jf/RnceaaaFdiYi27bY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If PMD-sized pages are not supported on an architecture (ie. the
arch implements arch_has_pmd_leaves() and it returns false) then the
current code disables all THP, including mTHP.

This commit fixes this by allowing mTHP to be always enabled for all
archs. When PMD-sized pages are not supported, its sysfs entry won't be
created and their mapping will be disallowed at page-fault time.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/huge_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5ea2e47f79..882331592928 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -115,6 +115,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
+	if (!pgtable_has_pmd_leaves())
+		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+
 	orders &= supported_orders;
 	if (!orders)
 		return 0;
@@ -122,7 +125,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -806,6 +809,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	}
 
 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
+	if (!pgtable_has_pmd_leaves())
+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+
 	order = highest_order(orders);
 	while (orders) {
 		thpsize = thpsize_create(order, *hugepage_kobj);
@@ -905,9 +911,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
-- 
2.52.0


