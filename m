Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B194C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78306B00A9; Wed,  1 Jul 2026 10:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4AF6B00AB; Wed,  1 Jul 2026 10:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0776B00AC; Wed,  1 Jul 2026 10:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6217E6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:41:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C37E2120346
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:51 +0000 (UTC)
X-FDA: 84940472022.12.F10E5C2
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf27.hostedemail.com (Postfix) with ESMTP id 410DE40006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wxoaGK9F;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782916909;
	b=CYId4lWXSYerFD9qOunBVM4q7Ttp0uONZ7JAnp0aJ+l9n0yaM9PFS5Ev7gH4SNaA61QCxF
	XPKRmqKTlRRZLQLCGMGJZMx5cpqixTzcj4ajbV4AuVRozc7CWHzhZq9vdBy2p9mk0Mtve1
	TyN4eV3FeloM9oHORSYZm1hFPiQzbW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782916909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktyLIUOIrE7/sKQRr9pPWUXp9tsuSSIH3IZV0JHhozM=;
	b=cTmsaBsduqOcGV6i0hx9tEOxChSpl6Lvy5DqHxguyxUH9XlN1wGigeuTobTDgSzSE+AGOh
	QLZj2YISaj06cXHQY/Yt+dGpMdeeSZLwx9ZjV6txl+88xZv4xsEcEnxhp5LO2brujuE4iD
	bqantRjEjt4WE13OzpFqGCaKA+T/4zI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wxoaGK9F;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ktyLIUOIrE7/sKQRr9pPWUXp9tsuSSIH3IZV0JHhozM=;
	b=wxoaGK9F3yIjGfyQHDf6rLdwuG6kRcjlVDYTbsGM6x70MOXEo7oykyxFtzsN8eYvvXHD3O4tG
	M9rmyswva3C3GR5Q3PdvG96RfpOfiMDk/HfqttmvYdO/h66JKp0XCfc+pzmm+K1WBygjdqkX6Zp
	UrS2K/2f4RoAzjo3sk9wjl0=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gr2Xt6RNfzKm4X;
	Wed,  1 Jul 2026 22:32:30 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F12240578;
	Wed,  1 Jul 2026 22:41:43 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 1 Jul 2026 22:41:42 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new 4/5] mm: mincore: remove xa_is_value() in mincore_swap()
Date: Wed, 1 Jul 2026 22:40:46 +0800
Message-ID: <20260701144047.3786939-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
References: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: 8pyqok44hyz6w47m8oas9pbekzwa7u6f
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 410DE40006
X-HE-Tag: 1782916909-829260
X-HE-Meta: U2FsdGVkX1/GB081Gl/8KSbpVRyNA+jfPzluCdMt+yOJbZMxQKU+tORjUpTvc/8KskRK1OvrP8wqrDUVkrWmEdRR+lXFc1UI3CGDgr3Qnz0AY5Gq+k8e73fKkzi6NGy4FDGuxY5wyrltjW73fsbKdzPchcFc9ANJoIwMPvl1xN8cphnox6dPSiygP1m1LqMj9OXFot+xK+8AUgY/qk1yRNhgxE8Ay8ghdo7pZ4Av5wVPIGkJeWB1U9Wh/cRJQYye+uOj9yB1s9fRvYqyQ0ZkdJ2neNWesydSISnxqVAnvrKUj/qQw5Tn8OClUu4vTR4mYzzEoVx/9Y0DnhJngqbmfeXCF4XJcwgZNgiFStnxOuai1StcUlp+CDfEZlgp5MphFabU3fDDk9qoZZ1gajJDG95gBx+AGuCwX1bjWIl5+9sx6HDaqAi0aZkNlgy+e0jp97bpHEskTgytRvk8b8v34y3QMqTtepVHeE05AbmlIzs+reOIttbVxNDuUJwg0GPRZWxB7znkIq/bjdRAfxHw/6swsp1SaNhyjDBX54psuqZXhdytckOLlFlEI23JQmdKhTC45zfUhXmD5F4GBUGW86etqx8BlqAS30FW4bYPd4N8DVqQAv5v3Ot2et7O50S9F6bzUqsygGfNeoAx0bv7zik4z3gi0F0HzAd7/VBUlqGH1r+v7p9QcNez0FQRWfY9CCV0T9H+ZfKnuau4bUkX6rEceXo/WM6UqLdPlO/y2yCtzoQa/pU3mJ95rXAQtACWpfnHneuM9IT7y1GQnldoqI19EHUATIz9eqCj9qNQfcyvdifxv8x1aoel6/Cr3DEWguGRy4ddDqjkBV+0z90yVSXurBHBzXSBM2zkzVjbWRlrtrLsNUL6A2lxrsivmSYuyhIh4FBNgGJ8DTbX1hOBkFsWtW2LkPrrTN/9+yWGs9hH5JDg8Pv6vtQvzY8eXd8brMWAvATh9aHAo9ziJ8G
 rv+TeiY2
 agS5O1ewjoe4f0nqESJYoYMefAMm0qXVNuvi2AR/BG3bJoX994PF+zN0jXM2JTOF1xVWuUR+D/dEMU2dGkc92QKgdJFGBPg/KZMmQH5w/+9LhIkfLxzu5zow2W3tSXThTqVDGR1Nv8hK57p0ZGWPEJjGCssGEKaYzZezfdQrs17XaMse5QD447LEo24y2q/1R1fDTq5tKJ4oWt3iX6XeSBykwUfyz8Y6pjmMZm1Zc9CCCHSJa78oxPrFmLSS7Rorr9AR94nycAFR1zw2UKCzugOT7dkHEg1pNwwRAC2Gv6RRr1dxzpQvEqbkldhUq+scIunM4Lvny2A9ufV2o36rqvKIXjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap_cache_get_folio() no longer returns shadow entries, so the 
xa_is_value() check is unnecessary.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index d561f1e5c461..1c72cc3ac87b 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -92,8 +92,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	folio = swap_cache_get_folio(entry);
 	if (shmem)
 		put_swap_device(si);
-	/* The swap cache space contains either folio, shadow or NULL */
-	if (folio && !xa_is_value(folio)) {
+	if (folio) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
-- 
2.27.0


