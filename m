Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1DA6C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0FB6B00C0; Mon, 31 Aug 2026 23:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161DA6B00C2; Mon, 31 Aug 2026 23:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0030E6B00C3; Mon, 31 Aug 2026 23:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73FC76B00C0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1A62402ED
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:12:59 +0000 (UTC)
X-FDA: 85163721678.23.B570E5C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB35B40002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:12:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OmCUzzuV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/15VKFd0k8fjwRB+GcpY7pyNM2oKVrWq2M5AHqmwy8=;
	b=RDSDhgN1Xp3SCWP0HoJjoM7qiXl4a2zqU+BkxHRGw82vZZsAWmj6hFMW8hsNWdXa4j562+
	lh/5M912/sOLm7RMRGskKPte79aMF5Nm1DS0zizDT3QefDltNzcddD9+6Pc/PHdZKYRBHL
	vHlamE81E5sb4jqjjrd8s2I/LTlcBRc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OmCUzzuV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232378;
	b=8fm/v9zWRbZNrd70F7HW/ozqRd8/eSbN86+gzSsDq9JK0gT4pxdhZSSLvQgO8w6POwgnm0
	BmqcFs+zPIS+ZysNOyJ1yZK1arE7JGnqpNN6IQErXTdDLCHB54dFVrqPFCBq+nDIQ9ntUQ
	1WHKO7v34pjam9PIVGZAPILQIYVfQxc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/15VKFd0k8fjwRB+GcpY7pyNM2oKVrWq2M5AHqmwy8=;
	b=OmCUzzuV8YAx7iW98G26mRfJcn1OizXQ0iAdRVb7kocXY/7M+vyplVZrIpaEkVL8Ue5gVx
	63cEkhlD4Wc5YoUDIiw5vpDO+luGlm7xp6r1R0mcf6cD/tl2aO21d3cfRBB65AWygBUnMO
	g8GljM+k2JCaFvq3d+wIzSI7XQOAw4E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-s-uJBlnQOgWk27tOwn31BQ-1; Mon,
 31 Aug 2026 23:12:53 -0400
X-MC-Unique: s-uJBlnQOgWk27tOwn31BQ-1
X-Mimecast-MFC-AGG-ID: s-uJBlnQOgWk27tOwn31BQ_1788232370
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C57901955F61;
	Tue,  1 Sep 2026 03:12:48 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0AE9B18005B8;
	Tue,  1 Sep 2026 03:12:43 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v7 02/14] mm: shmem: shmem_getattr(): set blksize to highest supported THP order
Date: Mon, 31 Aug 2026 23:12:06 -0400
Message-ID: <4d61dc5e8d6ffe957020eb34f57fb51099c2913b.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: dH8JCpB5ciu5-JDqHl5-nRv0gVJp8RiXO2z0pOx5thA_1788232370
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB35B40002
X-Stat-Signature: mzr7ma91e81jfubaro8iyh93iwgzrxfp
X-Rspam-User: 
X-HE-Tag: 1788232377-34424
X-HE-Meta: U2FsdGVkX19EzSaT1Ue9ggonz7GyYK45/WTflBJyeRYqKR3bzQvwrNwWu2wl6wuSPJsHxy/1UwKXPZ3Ib2V6ZX5UKESEy316ly4YMddW/nbCZTScmr3H2PpeRmDYv2NYvTvPf0QXbIH4JVyEL+Ajlie6ili3oDHJk0TckfTjmzIkDh09Rsqm3didc3yXZGDCgwJ9n3Qi6td8KJzjCR1rLdpq4kuwu1/YfVv2jiGQ4RmbFdN3dQVGjUvUB8ZOSMHMDMOtp/naLadBRzSMsRF/NGtr67hoXPz9+x7yIvh6n9UJzqXgWLqiBL9RBVLriYBGleFmCtoniOZGDUQ8ePoja3lxCZKZeKCzGbHZ/2SpaySWh3XpbpokR66hQlUtVuKgLln6PgVxeFY7uR7DaTb7d68dwt15BZ1kNHj6KI4MMIm2v5cGiEZtezPiPev+Eq171dats3Dy7G7+xxlN+QN94I2ivYf7PbmDrNA7bypN+06fVlj3DS8OIMC27VPrSg8ZDI10FFNWztLtg7aO/HLFccy9sR0iRi6BrQ9yXwZ3EQjJQr+Ic+QH+VxOf4Ku0PmyoOkVIzBspzjNx0Luoif5aV2EpKoXgFY4BhMdbQQ4tSKNg4ls2Zsb7iZvtAvp94vmQcxAdhWOy8mXu9ghR0L0RsiYgTQO//tJpzp0Dx5NdTe2I8hjXITucRRr3+/3IGrnUi+kR3eBc93Yx1cYzhUPDEBE11BmGV3jYaPaco1Mlv1lQQ0YoXa3kStgdBEW3j5/HwVR3lIgPLa7/w/ij5NzME/wy/MahwwXSCv/4sgbCdCDYv33Ql1eehO+rArfXv/u9cS3L9ayX0Hm4VlcJb9ZELKgaVuk3cMWFe/L4IFSLbQXNUOfApMa50i5UxsnNW2PDe3tZ02KuK0S2kIarjgbbc6r56pTzmXctVr+AwpoaOwSkN/oETnR9J0mbIqnkKGFdeMcK+k0MqUZ7x3ZlZR
 9FiayA2Q
 dZNV16OfOFTnofNCKw4gmFnaE/SwtWVmgMcrgMQLsVwyrsOUERcsorRAYYXF4Zykfzd/52xCsGRcPCUIAC8RE5ZsB4Elumvk+se7uttkNvZ6ATQV4sYYPpeDG9UHE4NJg3wtrTSjE+fyZxyjOCfnjYZUs6m9r1pLT+pqJEFrZAq0rEBOibXpOlXffIcfNjSRv7nw2pWg5666ymvRcalezDCqJRG2ULQAHIFjf5UURfvWo9SbNlCIvepR2fN/th8j/Mm7ihX2JEJk4cV5cYHe/46LicOw1l7ApZbY1w4Wk6icaSUAzc1y4wSS5n5sOeWExX38vADe4YAu3T7Ye3+g9O3b3R6DqNP3ZH+9W9nNc9oJJiJUVhaiCWHNZaZAWsPLRhTz0vMr6Jif814v72mhR9Wj9d3ekUPTBrkWogEcg6klbT3S3cHX27WZ3i0b6F8TSEjvLHt6B6zV5WB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today, shmem_getattr() sets stat->blksize to PMD size whenever
shmem_huge_global_enabled() returns non-zero. While this works fine
for the normal THP-enabled case as explained by Baolin in [1], this
has two problems:

 1. Theoretically, when shmem is configured for within_size, this
    could set blksize to PMD size even though the allocation may
    be a smaller mTHP order

 2. A future commit will allow shmem THP support to be enabled
    even when the CPU doesn't support PMD-sized pages. We should
    not allow blksize to be set to PMD size in this case

In order to fix #1 and prepare for #2, this commit sets blksize
to the size of the highest supported order returned by
shmem_huge_global_enabled().

  [1] https://lore.kernel.org/linux-mm/6591a74c-7ef9-4614-9ae9-cb2fbed86ebf@linux.alibaba.com/

Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index eeb9a78c125a..b963f55640a8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1506,6 +1506,7 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 {
 	struct inode *inode = path->dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	unsigned int orders;
 
 	/* Fast-path hint; recalc under info->lock corrects any stale read. */
 	if (data_race(info->alloced - info->swapped != inode->i_mapping->nrpages))
@@ -1522,8 +1523,9 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 			STATX_ATTR_NODUMP);
 	generic_fillattr(idmap, request_mask, inode, stat);
 
-	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
-		stat->blksize = HPAGE_PMD_SIZE;
+	orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
+	if (orders)
+		stat->blksize = PAGE_SIZE << highest_order(orders);
 
 	if (request_mask & STATX_BTIME) {
 		stat->result_mask |= STATX_BTIME;
-- 
2.55.0


