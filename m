Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92408C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFEF56B008A; Thu, 23 Jul 2026 21:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF5C6B008C; Thu, 23 Jul 2026 21:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9EA06B0092; Thu, 23 Jul 2026 21:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8405D6B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:34:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B3FD1A01C5
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:34:56 +0000 (UTC)
X-FDA: 85021951392.18.F64B1C3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 03DCD20006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:34:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FWUuX0Jf;
	spf=pass (imf31.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIh7RPBAnJJFoaMlpLHLjWKSHstbWhClnoICZysb4Os=;
	b=lh08urir/hM3as4cC+l5ZErm8wgcU0G4wOmzDXaWZdIshGkOs8CNgcdcOjWsMBDTrNOA8x
	BqZ/T/fYVmuUxrkXi5V6r0H4rlVV5jBg9If4Gsl8u/sLYfDCT9EYrrfp/JUOovnwvBfvBB
	THR+qrqQGTQdROO/d8Ravom5DsurQlA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856894;
	b=CPueMNFD70XdhUWE/fHBbbcC4qikXxq7Mf2lpnXXb/EWkR2FD4I2faYZ6aGh3dYserDhUr
	3rG4Yk0iOkxZCfnKAUeD7+Z/ydL7pZ47sv3WY2YF9EH1F1J4qzQKQsDf0Ct1kaxB8CkgCl
	4UJkXwR3//8Zb6eXLLPU4ZR+vcA8Fns=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FWUuX0Jf;
	spf=pass (imf31.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aIh7RPBAnJJFoaMlpLHLjWKSHstbWhClnoICZysb4Os=;
	b=FWUuX0JfzOD1JMWHWBUZJ/06iZj31wzaf1ZlMQ5wZWvXNaQeLonG+cOIx5f2Rh/aNP6QDG
	4ugMcwJbT2VQI4gPxXxDfBEibWXK4F3Xs86N8wdBukxZRsmyqhOtdCSKTa+Z3cAi7JHWGi
	2blyRaQ7rS0CTakPV7/xuyrBs3yFnAY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-u5j-uJGsMHWUyqn-nW9p0A-1; Thu,
 23 Jul 2026 21:34:49 -0400
X-MC-Unique: u5j-uJGsMHWUyqn-nW9p0A-1
X-Mimecast-MFC-AGG-ID: u5j-uJGsMHWUyqn-nW9p0A_1784856886
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9A1D1944CFD;
	Fri, 24 Jul 2026 01:34:45 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1B5EE180059C;
	Fri, 24 Jul 2026 01:34:40 +0000 (UTC)
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
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 02/14] mm: shmem: shmem_getattr(): set blksize to highest supported THP order
Date: Thu, 23 Jul 2026 21:34:06 -0400
Message-ID: <ac8042294376ec7502579f2498daa894afea4169.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: hCl3F6tcPyg7eg_oK3260Knnm9LmOBic7ZYLAkG3JcE_1784856886
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: j9kj1bf4czby3kgittbuekc9ffaagwj7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 03DCD20006
X-HE-Tag: 1784856893-689041
X-HE-Meta: U2FsdGVkX1838nW/cOhUKbi+4JZ9hDAHZ5nG7y7EHNGKjZqDdG/F910wwzmXSd7N3cdhfQIa5inYNX1/66UXLvTnfVals3UWj1c7LhRYkmHU/y9yGdJeF0O5QltiugCrNgRFTrt+z3nEoskv+6dSdTvzc0XLXa9mNlTACOOjnYO3q2fG4O1+AiXpPSgnJs+ZAbrr19WsDmVLHVTGgRgoccZt/7EqFkzpunvXdpqx0qLWXtAWuyhUai9DMH/YSiV3/miSTqS15368ejJlQ88mbaN+mDPghkIias8v/Y1ExZvvF8cy1Kgs0cNnM4/obPOJUMpy+zpnDXbBZ1sE54N7LTKjg0H2QDzQZp2nvs+ykrO9QEO97+ET9amlfzLiI5GjPIxGYIGwAW0HT7w0tBApQggD2HIwm0VkybYP2eQw1fbgyFMhp0lViEru6sDoLl5U2rJxP6ZU+xdbp4bgoFJnHSbhdMyWnWki91A0qumN/GDvl8ih63bg3GmKIRlQ2yQ+0YGzLYP7PnXZl2NblM6MBM5R255pmmeWeFU8fSdEwVQ08Dzz5AHar6QstPyIjadYOyLgrpTn5PG1+wgv2enTbghRnYAOT24TYj2Efsj6Zl6THiZ0ZDeXGkJmA69HuB4X43pExGijDYsiiLrAp9yeoBl3kbEowiQ85UX1R2uTzPfjkxfsf/W9wY3dybLck4g+q5XXHfa5XVYoqI/hF4V/FePqwek6+34diIy+DX2Bu2M7wl76EdHiCWK2yqoBuiAiY4nA/HVM6rcpQZPYQO9SLfG+h1fG2/Mxf5JUN3xdmKaUfv86SRaqfvDa1B5k5xYu0IyjIgPyIQ8UT7wTQjCYF35XKdVF8V/iiFV5DI1u5yQIn/vVX4EU7kI6lwRMq4WlMqFmTTKgmexKzARjN9Ro1AybW1POp+eRRspAZFOgqxjf90mi5EPW1dKZmAGgR0m+I/4nUvCWMYQGJenhqQA
 liHlW4BC
 YrMwjIQ/YZbc2f0hHy4pe+OIM0C3LCXB5zl7UVNpmxMlhgJ5WhOhN/dLt3hTs/HcttaJD8k4pZzD1jn/b0Lu/59Es4QfV2iKAag6mXz2GyzJKQBqNyE8CJ3MpO0l1/3pamX3pBL5L+ENUU3IE5IEn5nkzukqecZ8LGKat2PFYs+RI8YGrAMWNNBruEDDgdR4LqvKa/5wVz0WEueVoFWjd3oJFwo+aEyhNYDGqtZswDSoIISGYNf/VjMgDXYN7IgaiASD0jzdfu7G46MsN/RdbrWrOiZZKFFqUtqF1Zcouh9IjaonuJrzmB3tg+ZrhwuPU2BdE2Lqxl6xPtGAaCZm6f2gg2TnpQwn0WGZIZl2umLg3GZXiuznzUYErlIbn82ilKeiI8J8gOWLqNEMWbx2IjHv70eWdNX5qbEI3OC2XAREYc+S1botKXJEOG1ZVuGTFrIQktp6vEIfO61c=
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
index 5071177059a9..19534e21b61f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1287,6 +1287,7 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 {
 	struct inode *inode = path->dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	unsigned int orders;
 
 	/* Fast-path hint; recalc under info->lock corrects any stale read. */
 	if (data_race(info->alloced - info->swapped != inode->i_mapping->nrpages))
@@ -1303,8 +1304,9 @@ static int shmem_getattr(struct mnt_idmap *idmap,
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


