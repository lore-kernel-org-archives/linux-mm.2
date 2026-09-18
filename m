Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DCDC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35DAC6B0098; Thu, 17 Sep 2026 21:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335296B0099; Thu, 17 Sep 2026 21:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24BA66B009B; Thu, 17 Sep 2026 21:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECFEB6B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73D3FA5DC0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:23 +0000 (UTC)
X-FDA: 85225193046.23.FFEB0FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7163AA0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EtogpLhP;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nu0VWB6WJUsLY8Seekb2z32XfHWSxsRL/xoH2InAx9g=;
	b=EYW2qhH0/gTQLazQoshuqRAaA8ED4vHyQtZR2ccf55NMP5VpT47zHnIHe/wKegdh4Ew/if
	oJFRrF4lgu6nSSQ8tjo42tI85DJDcn8TI1zxM6836By1f9SBnkkzubMmxGQp0HLeKGklPK
	Kz8GLKZ3mWbpTivngqM3mUEIcaPlvZo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EtogpLhP;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789695981;
	b=nRnLxpYaPFVE4Mq9nC6/I/ZxLAzj/nSgTXOEYMIpKcCxBW/m1yWT342kHLq5MKaUBefMGh
	l78B1LbpOZJRAsOW75W383h0rix7LeJ4S/VMFUFxccL2ydf8CHJXpk/oGpkjCHkFyUYsbo
	neH0Amdmjt7Kw1nr0Ye+ONElE82Psj4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789695980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nu0VWB6WJUsLY8Seekb2z32XfHWSxsRL/xoH2InAx9g=;
	b=EtogpLhPNHTktih9Fp7RDJkVaAAYfeLOZblBZWENjm2Tnis+MXBOp0kmAvZIv5/W0P2SX8
	Uhx2rwEFOTFXCxN/vEdELIiMoNXCzWCKN9r1Q7KcHmcHaa8uRQrF8nUISENlWDLAQFQV/k
	CqLQa5vupDrKljIAg34p4IDqdmS1OMQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-351-ka5wWLBlPva_h9-srx9ilA-1; Thu,
 17 Sep 2026 21:46:16 -0400
X-MC-Unique: ka5wWLBlPva_h9-srx9ilA-1
X-Mimecast-MFC-AGG-ID: ka5wWLBlPva_h9-srx9ilA_1789695973
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8ED251977019;
	Fri, 18 Sep 2026 01:46:12 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 58DA718004D2;
	Fri, 18 Sep 2026 01:46:07 +0000 (UTC)
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
Subject: [PATCH v8 02/14] mm: shmem: shmem_getattr(): set blksize to highest supported THP order
Date: Thu, 17 Sep 2026 21:45:23 -0400
Message-ID: <0f18a45baec44d193f8dbc760ef57c0430e04bdb.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: EBMOzESHjZj7B-yvhNHLbrZt1tVBplbiAA73Yvjm5uw_1789695973
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7163AA0002
X-Stat-Signature: 3ht5jr3p7ip8mwkk3uhzg98nof14kx84
X-Rspam-User: 
X-HE-Tag: 1789695981-17827
X-HE-Meta: U2FsdGVkX1+maRZZo/dp8uUlAF2NUlsLGjG4s/pd2LDpmu3y14hpoictooETAhXCcUBeYq4tuvixTfPgwipfcTckUnZJDYMOdxTfggu2sr/evRElW7V/40yguQVo0cAyqzB6Y7nP8/rW/10FpFGzpmOqXDZ+wgCLL2HecbAEtSt4D+kZKsDzsMTFOBSogPDEb6UQTHrk1niszYB/jJGLhemPojYhrs30UKX8wol75nLXp8dXwe5qpq8iNUjCDJzvMr+ffkgC1gxc/WRm1fsHcUeoJ4K5Ii6/JpO9D59vl5dzu3IiWCLo5XMQaXm6Y7IlJnJ34YIo5r/Zb684cIZH1fBW6EOyepev78NwMnyZGq1GBdvC/CkoRjB+1wDm09vbHGuT+gDxKP/lzy+7snOIN97fkfkwssTP0GzIy8FNc/fpngKRCw6xw2y6xldDvI+ZnnYKcyx5aN53iijCcnZWkcGRr5PHVWLLE4fBg5qEXXvjRlL9SdCvGJP7HzDpf6fdBSzuwz3xmagO6ERZjJZev2WvVDkM5a2VyGcoGX7q/9k/rMPHYDD2X4a6HIF30j0iYHIH0njx52PMcpa0ucWZLHlAOH0vOBd4bKa+IBL7CXAgqb3rO5AFh90jVtxRi/3ziX42rxe3+v3j6X0170PawzNTYoofEn0NYsklj6NkHdJO4YG6CHAaNX626vblpbTW9/M7jtbhKioT6baMWqg3F8ruMkNZSUm+ZECu3ZcXf3f2p7oOrNkGpqnEHPFyixNwrNmZpGio9jVKj2kSIcdmQyHrTygZaTuv3LFjVRwyhtFJrLNwaQytBD8apLDsXHDd42SPgx6OPYnN5pcKMCr2z+Aj4hoIWVh6Vte62LpM2a4iy4/MHlSGnS+UZMCiMSx2zlD5vE1PFIZXAdtihrDW7qwoY+wvlNtrgSP4EEZqZ8kVC/xvuchhgr9ZvDTywHlUV7IUdHXWnawKNZEH/rR
 yE3iYoQg
 xzYiL6UqZiAB9WOm7K9xXSJAV7HiyyjJjBpUxaT2tugVVMUmx+XMqXmwWjV1ei9/e7glZZ64H2gd6R0YCOfQ6y7ptfpicoVuaFb9rrfs/f4hu8KwFtR6IVmi98BQfd070zLdv7PFyo69JZMqPJszy4YgFQiRu9xsbEZKfg+BA+YM9nYtk09KF86m8GDJWFNpxfPvhx66pBXVvQ2gepO1M0NCQ2pNDFyMhiMlY1Vl7op3mlAhA+TGhhnOoNDy6LgJCufC67276mxGOtSDa44JycKx+OVEgFTVgC8gl/tnF7I2xA8XUANk+04/n7sGvBhvXtsi7FaHxugOajr/xV6p2ZmP8SaTddtFlmdD9Bp1JD9IYu79gV2VPWZHRRF9BJqMyrcuxDbanc/DyLV87mTz/KgiJvfou1amClJRUNm+zohvjpg6jw31/oHK8pkNvDaZYNQGdw1KfDJC5rIQ=
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
index b572c60f2af8..776dff8a848e 100644
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


