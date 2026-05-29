Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FCACD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7566A6B009B; Fri, 29 May 2026 10:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DAA6B009E; Fri, 29 May 2026 10:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66AF36B009F; Fri, 29 May 2026 10:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59EFF6B009B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04419A015C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:24 +0000 (UTC)
X-FDA: 84820758330.14.F00BCCA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1865E4000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iGVF06Sn;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnKNVm1AN9C30K44qCES2in+Z5atORKCoBPhRGLDeIE=;
	b=o37/dj7PQtiBKtWrYnNuHSf4Xr5mDUuQvWVhVBz+hrSHZFC6HqqAvF37a8LcFGKByoTU1Y
	8+pI1TSd4G2DIhs7UYe+VRmKLiLiRm50PYexX5f+s1a3aV1A4ZclWNdRTO86KLbSL1Aqr6
	mg3JNHR9aA1eojIbYN0F0Fh+oCvFkYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066583; a=rsa-sha256;
	cv=none;
	b=ND39+j9+NU62cwsQjaNyH4O9hKHXqNNLcgR3M3idbhsIQHJLwTBavhmLe2r+vIqkqAm0dX
	Yymw91odE9Uw0JtzzAi+7tV7o7K4+NjCkZMhJuHHA7bn5KacYMD5DEsJmdwH1rYFpSdMFk
	s0PHtE/ll2bWTW9vhxSw6C6WgU9eZv8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iGVF06Sn;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NnKNVm1AN9C30K44qCES2in+Z5atORKCoBPhRGLDeIE=;
	b=iGVF06SnOWfndyP7faFBWZ2lF2B0FxDqfHQKsyvL+3uB6AJJjDmqNqcmd0E2V+Zl787RIH
	Xhs50/GAGp9Mdaq6ZvTc6nkul7Z1rhlTxfSSxIY+6kePJcRItPocpZtnIEC/sTOBAmvm9d
	bj0pwsDOqlxMCZpCbZv+u0KEt4ZGKhk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-u8BUhzhHO2W-ugi3dX2Sjw-1; Fri,
 29 May 2026 10:56:16 -0400
X-MC-Unique: u8BUhzhHO2W-ugi3dX2Sjw-1
X-Mimecast-MFC-AGG-ID: u8BUhzhHO2W-ugi3dX2Sjw_1780066573
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5ABB518005B2;
	Fri, 29 May 2026 14:56:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 14E0130001BB;
	Fri, 29 May 2026 14:56:07 +0000 (UTC)
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
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org
Subject: [PATCH v5 02/14] mm: shmem: shmem_getattr(): set blksize to highest supported THP order
Date: Fri, 29 May 2026 10:55:20 -0400
Message-ID: <e8e07851283c47a07a52d342afc60c19fe2b0421.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: NQaH8hdEWMP1ZXa2Yj3daJVwlBzKOpdSUGws08Z_O4Q_1780066573
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: 9s7j78py1g8wa14dz63wg693cwhee18g
X-Rspamd-Queue-Id: 1865E4000D
X-Rspam-User: 
X-HE-Tag: 1780066582-143486
X-HE-Meta: U2FsdGVkX1+KMhmh93ZuO98dGd7SJmoJl3ru50SUlkWlSrpuVbTgUMlqG9IcMCvPbNo/ZctejNC2bB0rc0VYkOvFT+bOLogJEhWv7ZI+w5Zvjw7Dxf5tZ3+moyhoYWHyKE3Vn90f1QqmYYjH/HEdiGa+338sgxUObVK1uFXbYffm1BnDu6mM9T3h5DTc5M5jHtF8zFZjKv4g59KO2Em4I2GMIHIsL6EMWXcWkoEPJCYYm1S8scOeRZLE9Dls+cZ5ycoZgnQrJaPSL+h4z3ySQCwrcHlGMr8/zMtV+wVqIqoqL3Cw0Ew8Acw+zTzBbXSklzV04GeH1FrliCdlxz52MAM/nTcBs1eYxdZE2KxpOg4NkovwHsx+yixCbKNuT0n44eMG3heLgeTbOalkVqLrtT1zxc0l4gSIq0nemSQedlToMBjEFdCNpvcygDET0xE/+kE+YzBtPtUPYg2qkJOOfl9S+49znBVZGmWBjasa2xHJ/zEpgzgdckz7oFTVufhcz5SyqOiKar90O1FmFmZwZx22i1a6X9UXgYNKHTe4UmfRnTQwUHVvsHIRBE/UAESOWJ96uj95+0srExagXxld5uz69EHJ05ZmtqhKgF2k6jLgHVXtEyx15Db+DmMDzmN1WYNKWCuA1fAKwH4gNOup+3XiZb8W7xrPzOgSF80FpvGSMc/hFLSfi0j/oVmW7sU/FDarVeCI/YqhGjzLmet95kitspuiuaENUvTTsRo+cSxbkucluhybOKSXxFxl2v6zFoYpyGMCYSbDgOu2bggj+jK1RZVUB7NSwp1uKFi+gyw2ofVj7i6OSwXPR6h3MHWRpedzFWeC++V1YfOBMq2j0HYo74TyFMwuTwjisysFZcYDxdSHKvZpd2CRBCbti0Q2jm1S+zrzc97G5Y0KHDYNJC/g7QxM+i0rqHJhu2lLY646D3cDxWAPh833dBH9hc15x/d5Ce1kP2lDz3l5GR7
 2le5PDvw
 ewtaAbenwFB5E5UGtcW/ubKt1WzxRW5tZKAHBx4XPYbAKoeMqYYSfUhIRVP8ZaHctgcSpVlk91bhMroMa99L5VKUsi+Uk/R1iYnkrWQrfLtCLirajsfci4a2WVVcEhcLnKAtvG/57/yrhcnWpQuYWx+sYzPIcHGQZZL9nFgot1oeJPdZt6BVA2rAoSwEUvDol1GIBn6GTmIEGpIAmkfBNU4CX27th9wH6u6ixIfHuK54599ds2q5oFt9L+wDZdCU66/Iy8bo+L3s9CyB9AUNHa01oy+r0Zn3eNX90lIEqyGcUSuywnbwteji1zmWwipHTvbC/ucIY4dJnln0QUi49lO/GLsDUIGBT0kyFc67vpzNSHr03d1nla+eA4PX8ofCDciguG8GZevL59XbsLQibk5faYFR4ubTLc74wvpd30fecD318Bv5WubavBA==
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
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..88bc0c292f1a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1286,6 +1286,7 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 {
 	struct inode *inode = path->dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	unsigned int orders;
 
 	if (info->alloced - info->swapped != inode->i_mapping->nrpages)
 		shmem_recalc_inode(inode, 0, 0);
@@ -1301,8 +1302,9 @@ static int shmem_getattr(struct mnt_idmap *idmap,
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
2.54.0


