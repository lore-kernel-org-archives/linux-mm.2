Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F1EC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41F26B0099; Mon, 20 Jul 2026 08:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2C56B009D; Mon, 20 Jul 2026 08:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09C86B009E; Mon, 20 Jul 2026 08:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB496B0099
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:42:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 075F8A0128
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:42:12 +0000 (UTC)
X-FDA: 85009117704.20.2FFD529
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf07.hostedemail.com (Postfix) with ESMTP id A737D40002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:42:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=N8GzFteM;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPyzWaumtS4ZliY6OKFoGM1oZkZyNW2wA2zSbARXhho=;
	b=JUWwDeBfK2IV/iTDjJc38yTGh80i4Ty/QWS980ZiKIyeecIUjwqvoqUM5dgp9MzGW1+zgY
	GJXBpSgmJDPg48dHbCkeqPVt/yyxZ1IrtzB5vHrelqak6tGH7MxcFJiKSzGJodyWisP8Vq
	2M4Zd7HVD9xX0/GkdxvLnDsGWtt/fjg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551330;
	b=5wfc6NAtMXwAoX3+FtsD4HteYxsrB1GjRqqLiBZm+MfvH2N7k1nAipcnvPM5uR2Z+BM5dd
	KTZAAUOikpNIJvsCL2/x8lzziqbt0NFIOE6CKwrg4hwydoEl9Icv/QtCO3W6A4/aKETvMz
	u5XhbEeXOAcGEwWB0RrJ7EGEi0J+BpY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=N8GzFteM;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dPyzWaumtS4ZliY6OKFoGM1oZkZyNW2wA2zSbARXhho=;
	b=N8GzFteMlKy6Gl57k9Fhlu4QOOcuEBHAZxm5icOQKh1DdfiWCE40V2ILYM3YHkDYAhY21vWn0
	/hdHCP6DUna/McG9phIB3xzCsZo0wv4x3M7NlyP9X6+C3sjw9t6Nra8nl5W2xKrAmULcoTCZz+P
	kr3L3PUdiAfdVQnIJSg6AYs=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h3fzl37MjzcZyH;
	Mon, 20 Jul 2026 20:32:35 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C922740561;
	Mon, 20 Jul 2026 20:42:00 +0800 (CST)
Received: from ubuntu (10.50.87.83) by dggpemf100008.china.huawei.com
 (7.185.36.138) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Jul
 2026 20:42:00 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v3-fixup 2/6] mm: mincore: fixup for remove special handling for VM_PFNMAP
Date: Mon, 20 Jul 2026 20:41:51 +0800
Message-ID: <20260720124151.1483820-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260717091347.1144789-3-wangkefeng.wang@huawei.com>
References: <20260717091347.1144789-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A737D40002
X-Stat-Signature: g8j47hizgmpj9o1ut7e4zg7wo5kbpwk6
X-Rspam-User: 
X-HE-Tag: 1784551328-432429
X-HE-Meta: U2FsdGVkX18/PwVgFM3QZFl8INi6keucPwDbSvW21P1dd/ZoP9l3LaYnM6OQb0A37OxzWUsOQoDH2NAdiA2L0v93sw719rm10acUo6lh1+BSJTk3KedBok7RHEzZfsRmHoej/Pchfo+iDP8QHhGjGpmVWjMk1wuuS3R2VOQkBXsL0j8kOrInCA1ruJsvg+e/0v1HUv6cZNf0kVFsFK5MdVqGLaG2A8+7K7xhOT1WRN/K3wwXYaM+mnajDJmLW0c5qh0FuJxDGikTmf6XuFtgSli7zR3xf+5+jsj6fd2YTYgrQvbdL/lgWYxYua/UnjHLsIjv+x5Dvj0ET96ojPazGvvuaKcUQVflqJQ7n/Ei5LzhowUT7PhY9Ifp0DhHidILNqwjLErGtlhfQh6as3eBM6KWHq6kbrRyospy0yzvwcU0WDQKq+sXn93jx0b5se+x2eRVBC8HyrwqZd5uiIrcrBWG1gSRKLDDwOAgZKcbdMM7u2S2elIkM6qjHtq5C1pjFwtbcWnAXDCZ+oiVSzKSModDInRLiJE1nPnpjTcjSaME4JgL7UhxmdnQDZhUTu/YrJNWMYvLjSJZrQ7x8WKc/Gv3L4fDLM+uhb6BqW3yVFJtJHs/HkgnkgbzIIsR586mnLmBgB7ZgMZiD2KM0paLdQMv8wrZKNndvj7EgmXT9712rUGCFQojRodTbWoln4s5NMmpi4vXRGhKqXDS6W+7d361YglVxpVPLchF6zvYyzWoEaxqLnrn8gpqiLB7Wth9VYppWHFeZFLN4hq2sugpOxdbOC3E0iyHDXwYD9pU/J2/9BLoXIEyRtOMP+WnfSuNcy6wKOEjdALhhN51k4UBKdCTY6j09ndeOtOamaafh3ip77UgZBKsEUunLuxqnCXlVx5zo/wipVJB9xhX3ZUnfz+CGCUKvIUEYW6Dtf8yCwiHm1f4bICNLRMNk+3k5ZH5Px61YGDfwtOARB07rRq
 PLr1iNYu
 mXKCbYLaziI6e0Dkg5slaWK8djg/u4WgZYP4VqdNG6WLZUsMsnZUppbvmaPMgKdQK6Pecd4XLxjQkRNMLgzRQJoFX0VB3JMHLqK8jr0wS5mNinBFZ+Y9npiwGv+P5yrth9AcGt+udDGni6zNurZ/Uc3GUxBQRbzseSp0i829/QYbcfk2lizP0cu2GM9DMp4TURvDGI5JON9qH8aymD5FgaMGniRnxR3c3ku5IWtqyQB6GIqp9w65ht0Nd/5K0Wloy/holL01e7uP91TahghN/ntB0UqanNwkF+9RV1WWkpCuQOsoX5JW5VJLBqu+qcohnOUPx89qSVsSIiJy/80XFklwwuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Address David's comments
- rename mincore_pud_range to mincore_pud_entry
- change int nr to const unsigned long
- remove a local vec variable

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index d7841a38b54a..9ea81638d09f 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -146,16 +146,15 @@ static int mincore_unmapped_range(unsigned long addr, unsigned long end,
 	return 0;
 }
 
-static int mincore_pud_range(pud_t *pudp, unsigned long addr, unsigned long end,
+static int mincore_pud_entry(pud_t *pudp, unsigned long addr, unsigned long end,
 		struct mm_walk *walk)
 {
 	if (pud_is_huge(pudp_get(pudp))) {
-		int nr = (end - addr) >> PAGE_SHIFT;
-		unsigned char *vec = walk->private;
+		const unsigned long nr = (end - addr) >> PAGE_SHIFT;
 
-		memset(vec, 1, nr);
-		walk->action = ACTION_CONTINUE;
+		memset(walk->private, 1, nr);
 		walk->private += nr;
+		walk->action = ACTION_CONTINUE;
 	}
 
 	return 0;
@@ -233,7 +232,7 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
 }
 
 static const struct mm_walk_ops mincore_walk_ops = {
-	.pud_entry		= mincore_pud_range,
+	.pud_entry		= mincore_pud_entry,
 	.pmd_entry		= mincore_pte_range,
 	.pte_hole		= mincore_unmapped_range,
 	.hugetlb_entry		= mincore_hugetlb,
-- 
2.55.0


