Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 321DDCF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C046B0095; Tue,  6 Jan 2026 21:25:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B276B0096; Tue,  6 Jan 2026 21:25:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838616B0098; Tue,  6 Jan 2026 21:25:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 775786B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:25:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25EDC8E587
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:25:16 +0000 (UTC)
X-FDA: 84303575832.27.BB25973
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F0B3C0013
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:25:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=eSoHDgAZ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767752714; a=rsa-sha256;
	cv=none;
	b=SeO00cNycU6EFGFSvN3O/Vl9Mb8kWMTmHouxFofQm2MwIgtgPwpUkPuSPwTKm7KX3gc7ub
	NPUWJlQWnlScjgCMgTOcUqU7hldp3DK9WpTjikNueD4TNryet+UlBuOkpyv37lc5VX5eNZ
	L/OBFNQDjOWJ4cWVYkVe4aesXNG5aVM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=eSoHDgAZ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767752714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nPVPfkr/y2YYTpshmkF6KZTylgTLjqX2OuEnIKqe7Nc=;
	b=xzlfS9PxHEbQK8e/QeXlqD39EbNg/Cq/DAWXlmDASjI6NNJ4YHoxARtDcYdlcQRy3/a+c2
	A1V89i4fcSABvr4GFsbCt/VD2Oo8WcEDLf5dFn3vqrChCdI/jxvHB6nozXi7xGQXj816nm
	tpu3tpxLDH8yzhvGgZ9/1cq1J2IsPj4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nPVPfkr/y2YYTpshmkF6KZTylgTLjqX2OuEnIKqe7Nc=;
	b=eSoHDgAZDEdyakPtnm2r4lz14cJx1JhE389G5KPkFU0OloU6l16n0E1lB5q1iRsH14ch2eHPs
	aynE6cbhCCN/lJi1pWZWgKOszrIZVfD5i2wWU/MxUZ4tilD4RKKQ40KyA5UEOp8ggUnR894tWeU
	PAuSQorJ/HHw2n5/gfJhRdc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dmBcr1kQfz12LDj;
	Wed,  7 Jan 2026 10:22:04 +0800 (CST)
Received: from kwepemk100009.china.huawei.com (unknown [7.202.194.57])
	by mail.maildlp.com (Postfix) with ESMTPS id AB7874056A;
	Wed,  7 Jan 2026 10:25:08 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemk100009.china.huawei.com
 (7.202.194.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 10:25:07 +0800
From: l00580197 <longwei27@huawei.com>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>
CC: Pratyush Yadav <pratyush@kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH] kho: test: clean up residual memory upon test_kho module unload
Date: Wed, 7 Jan 2026 10:24:27 +0800
Message-ID: <20260107022427.4114424-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk100009.china.huawei.com (7.202.194.57)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F0B3C0013
X-Stat-Signature: t6p8x3ijaustom1cpbwegtajj9rma63s
X-HE-Tag: 1767752712-227025
X-HE-Meta: U2FsdGVkX1/JvnOj0kgjSHYgeYmJzvu5ku4MP3dPy6AMhnTIBroJ3aC9s69uA/Lg6yJwlAFXRBs4w04Zyw0o1mZv8zduNu/FKBWj97IXkusGtnU1FL430EnqMYm0vi/FG0OV6HpsE6HgJVNuq6BucBNAFEuz9G+4tD0/F6Fk86GSw6ZQuLdaN1Y/LjQHekojj53Pa1LzbO+nnl+GUCWf29tNvF6eHsyjpggM/2TnFSjHiMLA4UO/o/CyEup3HC1eABlbXNWOpeMsy6WPa6OQEdeP9z6CRTQAdHc0wl2Gp+JAPKLC8Z+ZrW0R3k1e8P7AN7EyQBvpCAm7zVXtebINDLKyFD+4MEUvb0P1M+8/3+x3kgEcsn57GOYXBaWxuTztQar8gChH7nEHKFhN5aeoU9vyx/+oBI7/F8ZjMqSpzKIo9YHEEJ8N59xIPFQTWNdpEoiQf/rW3aTbMcMBWa8btGWI7+5yf/qCRUin9O21GhiA6NDCSvD/2rvF9W88T6QSKRAA0GXo8TLIrul3Qq1OjToPYFaM5J4c9L4ACXajJc1cob9CqkLK+4rewPafk7gkzcUdlTzk0FGECfaLv3eWSiUf2cxkdmkzQUdT9OVnaax9wS0xUZse9dFfi9kzpQtLavmn9qE0GFFcrih/RrTwvY6qvYksLjkRoUfjrqVFwxZiWXnjHVWjYDbWloyarnNf4C1UTxSfZr/LNnov0md971azhfCN+XhFno9JiW5aAVXe+e0OSO1dDZVFC+hz6VeURwkmzz5Tr9JuYTQ27R7RlmnkNCiITjBreH9wGAvUIaUhhgOJ3thIwfIkbEhxj2vEF6YBe+Ulmxnc1zTfkahH1MWaJGycPoSsThKsIrFcAcHPXIsWABSna2tZ4y7dquq/6aJUEqa2YVOctrOkz3Uyf1OWeTbYEbKGUUdHEPVudwK1VEm5WwSEofsL3PvEi4uxyM+/RRGK/snlsWSOZNp
 wbfEJEsv
 ijCIoU3AgYbfaL83n4qYbaBqAH3izsXp+rtqEmFlwWssdJx5ns+J07KhrYaWBSgOCdoD/dFb5Gu7vifi5JcClDaawTpQjAkHsiLzDfYlIr+OiYgjyPY6767EaoluFRGPQBlh6OIELIPN6G4CBaNKS8y/hd0lOy8LE4f4ek//qJJbVq9ZfXyoLxZM5se00LAx+edp5/S7uaMu0KhjiLI7qTjzgq9BAp+aaEDRrcnpkoDakd14h2P+n0QdunT6EHDFb+NUiKd6blUf9Nc9s9ADzHL2oRfAyKUzZyErJO0xMvSJsP1LXuKsqH0EiTfSLpCYS0kfVbBHBmAUtTQvJfU+MtNyxyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Long Wei <longwei27@huawei.com>

During the initialization phase, the test_kho module invokes the
kho_preserve_folio function, which internally configures bitmaps
within kho_mem_track and establishes chunk linked lists in KHO.
Upon unloading the test_kho module, it is necessary to clean up
these states.

Signed-off-by: Long Wei <longwei27@huawei.com>
---
 lib/test_kho.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index 47de56280795..69230da5a056 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -339,11 +339,15 @@ module_init(kho_test_init);
 
 static void kho_test_cleanup(void)
 {
+	/* unpreserve and free the data stored in folios */
+	kho_test_unpreserve_data(&kho_test_state);
 	for (int i = 0; i < kho_test_state.nr_folios; i++)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
-	vfree(kho_test_state.folios_info);
+
+	/* Unpreserve and release the FDT folio */
+	kho_unpreserve_folio(kho_test_state.fdt);
 	folio_put(kho_test_state.fdt);
 }
 
-- 
2.43.0


