Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57233CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E0B8E001F; Wed, 15 Oct 2025 08:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26308E0008; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79968E001F; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE01C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 758E91A016F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:35:30 +0000 (UTC)
X-FDA: 84000294420.05.8ED7A53
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9E5516000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:35:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=O0KE4txq;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkhosY4kudM5b2LDvScLHpmry/qDRID3Z35q3P72RpI=;
	b=kIxn+TIvvHpk2BAl2uZZTND0ucxgH45pt+HxnLMqKcxmoFKAhTI6r3lJJeifxc6IBascrd
	LdqXcW9PiR90c66H8In85pnem7ZLJCoTaZlnaVJZE0EFHA8xHENsmlwuz+3qRQMBosrxwU
	wT5YtVOirXXrh6dwqvwk9FC3UkAewvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531728; a=rsa-sha256;
	cv=none;
	b=ZXUDMOYxlnQaYNo4ogSwA3aub2mklYinrGhyx5zcNziyuK7/f1iUbJZizpCo6Ya/vhSGf/
	yoXg9KhvRW1Ez7/Sw7AtFK9hvlz6wy1ophwolnLh6yr+QUloqU4lMQsDx+g6OAVgbuHi7E
	lsqIfk7ia5+zunoDW9IhPNdvx0rPlT8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=O0KE4txq;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OkhosY4kudM5b2LDvScLHpmry/qDRID3Z35q3P72RpI=;
	b=O0KE4txqhyV3Vzh26t9+GWh7OSn/fdvdkDSIto4DukT7foH1H2jJEjZU8DETzLQZtkDWWqtzN
	uwDRBLzwt52cMawThoI2BHdPvjmJsmkYQdfHZZvBpyfkdnNbmZYSwZYqX6ivS5MAlqjwXhdR8uN
	N9xpd8CHdU+IaD7blDzlvQ8=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cmrBv1rZmzKm5G;
	Wed, 15 Oct 2025 20:35:03 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 873B818001B;
	Wed, 15 Oct 2025 20:35:23 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 20:35:22 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v3 1/3] mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Wed, 15 Oct 2025 20:35:14 +0800
Message-ID: <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Stat-Signature: zgrgeg968wkekmp5k3gn17soidxwhdq6
X-Rspam-User: 
X-Rspamd-Queue-Id: B9E5516000C
X-HE-Tag: 1760531727-744341
X-HE-Meta: U2FsdGVkX1/LF0YCJPU6DsRfSQQLZHPtWyTVwvCNy16ARfR3SU5aWfx+KRhOh1MNX42nxJrJpmUZdj+hSzoaieIfvGB92Avi0K9am6YC2PeqrKO4eTUWyG72IfzevCbcgf1pAQxrOxmsOuAjwKimYosGrUIVUdB3wFy6g9+cj6jMJg6eyuh7/ECy3lQvtzFYPUy0gbF8LzqWaDw/vfQHmyezuN4sX3d+99PvjxuKJSDNSgsdf/0fYcRxuJri1VQOXwnmNVy8h0RXQw8Zb7d5YZM+6GRe3M7gQDxMORbI2U8+avWe/dhKhVAKoHvqTDpiFOJUioF0+BdSQkFcCkdk1bdRxRy5y/FU8q/VFgGRDw5wEmNNn9c/Jrq2Lsj8kgQAWblgoNx421lASnhZxWohaGAvBAb4lKu1JBIqpOLFZfsex6TyFOzoA2KoDHkxqTWKigqv3g+4XQrfBFnJoVX4GJFGD7KZgvluS0l7Wfz3GC0JRwyTIA7+tqefgW4Psw5ag9BkZsqwVSg9nkjsUipIInj9twhmY4ahIcqNa5CPWAqbmLx89SPwLmnWhNjA/6CR6PTqkPgJbcWjEW6WOVLfVgnB8DX7eziNYwlfT340K6ryloyHvZ99ErNsPWhKOXlYjqJK3Sl4+BGcx0rIatb4ia5kqQdWygARLxGul+XVgnxQ+k2jWnpsjipxj/QDXs0wKY6RhqjeBNJydO9nzFcCF+gtVMD6NSaMlt0nVzi4wb24zu2kGFlQhJaaV8oA7tIATbNIv5PezueIkypI8sNlcJMbuJ+3gu8Npfhw5dK/Zu9fKTN7KCeJYbiW0KQQLyDQS+Dmxy+SR8IzTM7HxjgqAkJE87gcq/rOOs0n//tJj5n1DADQq8UBSK8MztlJndLTf98GNC/T3TZlNdrTrXpP43uYJJjZ7L5j8ywbs7QoEDiZq66S6th9QS4l06hgeBQ4LKF86w+LTO0DwiBdPWG
 oenV0nNZ
 xktnA8RloamyrUJEuLl7cagiVIWwMnOAp09jX66lqTQZ6bTkS/WEGP290diSPY01ja6f0nmyf5OmD1AyXyKR3ide1HQGrD0qqP/FhaBK5ux17nAv+6dqGmevpM9UPVN2sDqTZiFiScpnFM7jvUzqCHwKEwlwiyGS0YXj1gyUGPvHZ+YN7Qi7/x9dt87AupCFBa8xIObxxbBiLSEeH+PbPVR8yE+gGARSl9wuNLSwG+/UprR9ogMv+dc27BYBOagvCN16PNPfGE8iG/Lqw+4f+WL6Zyn6xvqjs6wGG+UJsvcxciDGELfZ2ACAz8gzVhw17d2ds/mxe1eFjQAdCD5uu+zx/6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the folio(even not CoW folio) is dma pinned, it can't be
migrated, so always skip pinned folio to avoid a waste of cycles
when folios migration.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 113b48985834..bb59a42809b8 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
 		goto skip;
 
-	/* Also skip shared copy-on-write pages */
-	if (is_cow_mapping(vma->vm_flags) &&
-	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		goto skip;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
 		goto skip;
 
 	/*
-- 
2.27.0


