Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A160C606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=IC0BVDBU
Received: by kanga.kvack.org (Postfix)
	id C69026B05B0; Thu,  5 Nov 2026 07:06:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF37A6B05B8; Thu,  5 Nov 2026 07:06:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1256B05BC; Thu,  5 Nov 2026 07:06:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AED76B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:06:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CE081A0A11
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:06:44 +0000 (UTC)
X-FDA: 85400938728.25.8A7C0B0
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf01.hostedemail.com (Postfix) with ESMTP id A439640005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:06:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=IC0BVDBU;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880402;
	b=YkdhOFEAqCUHvUQ+JVz99UHFIzXbNjHUVkLICj2NPCtLrDgP8g1/m4T69KCI5yzPlbwYva
	tLseNz5jW8WBuY/QlbbQcR4tVfdlN2uuZ8aPv/2cajKxCs1S6g9AIdu0i+P6lsUW7vrbub
	S3tcl/7AOcKhgy/sA0Kx+lWBscwp5yI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=IC0BVDBU;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F2Dj1yflI9lMbHlyR4uYrdt196P5usgq/G7TmvVEXEE=;
	b=g9Y32eF9rNm0CKvPppaHBqSSc2Yyuf8oLbH2akhA10fNCTC2i8G9xurDo287mK3aUh/Y7e
	HEaBWwjvzI3snvYtkqY7YrB4yMnxRgAy72xgvuQdOLAmlqjPMvBMBFHY1hgWW0l0pn9MFH
	l4/YhFc9z8OeN4me2XZILqTriJl4yw0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793880396; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=F2Dj1yflI9lMbHlyR4uYrdt196P5usgq/G7TmvVEXEE=;
 b=IC0BVDBU1YVxcV4CB1HjqP36Ym0X7BE/y3UauVeUI1wjAejdk1itEfAcsvT8vmHCvC2bY5
 6DipCSiBtnCxJNjL1rraJNtz0CCylNcWVLUsFo8Py6yb0/rZczodL7VuMnqaxp7TLFD3Eg
 fw74LJ+pB5daUR6yJTvnsYHt8UO2YTyxE+Aaf+RhEBddIVI0hq/aTWP0xoN8+xyAVD4xVD
 Xm1UIsgXEbJcs36eu1LhP+0/keBsbu0dQnXxUQG4uYw0jlOHl38m0rdkpdjsdDxN8nxwIL
 v8oB4r5uxSvDHqGY0SQ4uwVKxIa2dNE/J48PhVZeVZDrAu34Ccv/Uw6MSx4h2A==
Date: Thu,  5 Nov 2026 20:06:13 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26aec714b+5ea620+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Subject: [PATCH 0/2] mm: optimize HugeTLB bootmem hugepage init
Message-Id: <20261105120615.16817-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <apopple@nvidia.com>, 
	<balbirs@nvidia.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Stat-Signature: ib7e1nuth6kbzuz5c4zofgeampjpqsta
X-Rspamd-Queue-Id: A439640005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793880401-415738
X-HE-Meta: U2FsdGVkX1/BYVUW+2ZGVUp25X2rTn6K1ApZhfPDTqkWVz05CyerS8iLLf4tyci9iwYNORqlmcrJDhvCr5Me58EytNQlGhuWfTs2DMENHQU7kxMTvSTZHnShqkB9KAWghmF2xM2fP6K5ulJdGHuuSgv2Btw/5XR0+2jKBvEQ6eQcw736u5cvC4mLNI5wTJvsSbonzdKn1oiGAtLwuYrWs2d86XCCQqxhguFTtu9uzeVfAKDIx1ZDYdxIcWiMKxxIFEVRk8TgqKIMFtoBrQen3KUp8Vyfq7E2KDN5xhz5t+HD5g8imuhuX/IOidMd3X5SDSjC9pBOUulbMn7NXMss4c3z4xg2rckB1d5MxBTmON/Aoh+UD6r1tOpkuFlGOmLopstFpy5wVEg2DdTQaUpyWXtf/8YltVJBS5mxxmSxZLepyKFUNzhFh2vtTJ3XQzD+Qt3xN+GyrYETwqB8ISGaoCyyo0DL+mBqMAzPECOaRpqJaBk0YY9wglAwIrk09Uu2L3krvBcxYmGIUIbB57rEjB0BSIvrua8b8es+xOS4vsgHXIAGrimYJJNttpc1xOnNYwcvPecwXUxFbeNm6LnEVumWDrPMLAR9SAIM8r/r3CG77TGs2wrxuIZzSSe7HxViEnhGskwsWJCWpByHgl/d2eAa2vewChw6rKLa2+L6Wyrt7TLR4/5/m6HhF7uxk166cuFt7k95Js6HGzv56gID9HXhQutMLz8DcFnDWbHICA2wBIHZ4FtMg3qlWlIigAyIzJL/bcvUvbD7UaKSeyYCIhHhcawJvZ1ay/Nr0qR9EaxMbWsyAemGiphsttnMXjX1q/6e5l+LlXamRDH22WIxeTognbJsl5tZm69Ad59zhhyqRIEcDwN+dOBjd71P5ljtnSbKeyPlu7LjVznsV9S+QRXET2GYtxSQRI7oQRzElY9MSqRZjXUEa2YOZ0u9ZhGlwsDiuP/oWk8eAn+ZM9T
 /Qp5IyVr
 eEu3CgS90gEAUQ+QAsi74+mBgt/6PFa2rzBWLKvnTmpBRTYBpTO8IrdB7RbF77NQF4q/2sjc0RYIcaul7RICxQtX+jj/qdzV1JN4TpAxc6graUYklY1iyaAen2fM3qytQPK4j0n7wPovhqs2ylxQY9gHe4/IK1rDks3vWgY53v7TP9ltmzymaIoqMuhqsG+etUPJE1q7PxeS4Aibg/ZrnaeciQ8FE364oZP1+X+D3MarHh68jNfY1kCa6GNbD1kvQCdLo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series speeds up the fallback initialization path for HugeTLB tail
struct pages during boot-time hugepage allocation, when HugeTLB vmemmap
optimization (HVO) is unavailable or fails.

Patch 1 factors the existing ZONE_DEVICE template-copy operation into
memmap_init_page_from_template().

Patch 2 reuses that helper in hugetlb_folio_init_tail_vmemmap():
initialize the first tail page normally, copy it into a local template,
then initialize the remaining tail pages by refreshing only PFN-dependent
fields before copying the template.

In the earlier discussion, Mike asked whether the same kind of
template-based initialization also helps the ordinary struct page
initialization path:

https://lore.kernel.org/all/akfB6Qe-jKDEMUxz@kernel.org/

I tested that direction as well, but did not see a measurable benefit
for ordinary struct page initialization. The measurable improvement I
could find is in the HugeTLB bootmem hugepage tail path, where gigantic
pages can require initializing a large number of tail struct pages when
HVO does not cover the allocation.

Tested on an arm64 QEMU/KVM guest with 4K base pages and 64 boot-time 1G
hugepages. HVO is unavailable on arm64 in v7.4-rc1, so the fallback tail
initialization path is exercised.

Results averaged over five boots, measured with a temporary
jiffies-based printk:

  base:             318.4 ms
  with this patch:  202.4 ms

This is a 36.43% reduction in the measured fallback tail initialization
time. The temporary measurement instrumentation is not part of this
series.

Li Zhe (2):
  mm/mm_init: factor out memmap_init_page_from_template()
  mm/hugetlb: optimize bootmem hugepage tail vmemmap init

 mm/hugetlb.c | 23 ++++++++++++++++++-----
 mm/mm_init.c | 29 +++++++++++++++--------------
 mm/mm_init.h |  2 ++
 3 files changed, 35 insertions(+), 19 deletions(-)

-- 
2.20.1

