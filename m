Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED23FC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310AF6B00CA; Mon, 31 Aug 2026 23:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2076B00CC; Mon, 31 Aug 2026 23:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B3F6B00CD; Mon, 31 Aug 2026 23:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA9186B00CA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6411980321
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:20 +0000 (UTC)
X-FDA: 85163722560.01.9D7AC3C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7FA2940007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PChqRjzi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/r7ApZA/+iU7/IPziHFVic/Rma7PRrQe4ZXAKweg9I=;
	b=Kgr237aG3Cdvw0BxmcLF45xGyUdhxOiLUSRhgagl9JeII18PCZDzNZBd6AgNhQbVSW49CD
	HpPIImpubcdzkDYW8ZmhoKPRwqxJ2grXa0E4Z+QYz0PE42+3z1D391MRY2itxGElujc6Wp
	IL1qdu9rdf8uiv4WTKTIawO+22RkgF0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PChqRjzi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232398;
	b=JigiXUqvfddZk2jc3NIU9CZoH7pmvtEIw0hp7M6tJKlJW2VTBgLYaqqCvg5kFSbBBtCr/l
	lPCmAPmZqsLWU1BlXQP5gbfhuhHsiITr5GE68j7vtmRlVKo0EZSjXO6RiYu6YFqCMK+23Z
	copQ95V30p6Vi+xKvnXiQP5PwYHCEGA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5/r7ApZA/+iU7/IPziHFVic/Rma7PRrQe4ZXAKweg9I=;
	b=PChqRjziT7qmnfgQo3xMuK1LavC/pmFprs0WNgrlWUJ6v/NXyblNWVlDdPK9jEPLI4ot4P
	iwZcfpy68c8PbwYiDYiOgjSdUrmsWptFE0/2xHd3keEha/PVZYK0CGfPulhr/5ZEzPGTdl
	FFt5a6y34OfDGLp/W7PipxPjws+ypI4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-K3s1vfWkNe6lSHNICysDqg-1; Mon,
 31 Aug 2026 23:13:13 -0400
X-MC-Unique: K3s1vfWkNe6lSHNICysDqg-1
X-Mimecast-MFC-AGG-ID: K3s1vfWkNe6lSHNICysDqg_1788232390
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BE0C1843AD5;
	Tue,  1 Sep 2026 03:13:10 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A41AC18005B8;
	Tue,  1 Sep 2026 03:13:06 +0000 (UTC)
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
Subject: [PATCH v7 07/14] mm: shmem: allow THP support determination at folio allocation time
Date: Mon, 31 Aug 2026 23:12:11 -0400
Message-ID: <600c346841252a68d4c1792f74c515c345ace4ce.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: L1s44LQssk2bgaTZJmL0K8VqAOtoyqWQ1-1aCU_pd4o_1788232390
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ogf5iqsjoywy65s5ctsciqm9d3nshy5y
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7FA2940007
X-Rspam-User: 
X-HE-Tag: 1788232398-505608
X-HE-Meta: U2FsdGVkX1++mjMsBQ4HMGFGKRzYnJkrWjXdUawHEZSS22vFOdhu4IMU3eTLysbRkx6vTxzyFCWv23w+/mFLRBpN0dVfBiBdUcY05TQhl8G3TXT9WknZ2aU9USH5+kbfbZWoJKd6BRu1NaWBHLSbrweH483iJt40egsfD7HHOnfozgO4CPf4kWUvgPZUDpwXe5vdX4LZhIqZ20toUocYURcZRy/ikfZPG0er3r7PJnvH3UuQfm2R1gbuOYFBrbQf8VPaGqyELRiVNSQqhXhLhpFmolE28qhoyhk2Id8KZx8JpMracuj28pB88T3KrDLWZXqtGrwueLOsC7tKovrFLPastMNIev5iB/aDTKrGMDaghMg1KfKEFHsrkWBXqwx5iw1ighqWpxGqqITcDL+DuExunvZFe7gekK1+6IHRGljTEkmfBstRGFBLYBCFPg8nFwojDYukZyS2miLQeloV0/VCTB7+zIkWU3trTjz4GQnPs2iEoTWEh6X9LK82NikqRD59hh8LLWqINxXn+yAZg94URw7nZGgoP0gpZM6YoqZllUsBORjtBt9rK8CwvXT3XXwINjAXczVawqX69T6TvgvU4xGfdiYg1WynAvjUUrfUMSxeI0Jqxjs6XoAZH/DEJgi/Y8BNW2V6Fth05R4DM20ntnUzRDn2jI4V3EQB1iVvghM+pN+9THC+y+/xz+anQ+j3RDFbfd5vLtp7E3hzb+fmtgNIy8j4oDLU14HZ1Cf/t6Sw2GSejJPGeaz8w7uQ50cwl2MvOzT2cIjK7L5ZCQ2NDN3iQektqd5+08zflxmPqwqE/ECqtmnaEkYcwXilB4Bd7v3JCCCRuzoPLGNPvv/bEqpRzE+TjE7H53Uf6A055s53+lZDu+7fCiqZPmLc3OUtONrZa1hPvqq85MHgcv92Rrsx7yehVZY9tl8KxYOxsqW9088wORn3P5K1NrkOCxwmo4SupDzKjV1E16N
 kwlYlIV5
 OKlvt3qLYsHWOmVFDYb/Vzbp5andZUCHhA6grCakFGV6jeZJIrgXrTXsSGqIVYi9SjsRpxkV1kGK/qZ4T4D9XbKAOgkHht1srfchI+U5Y52RtJdOer44DhIp/V2SmaR9ZHSnE2YsFbtvg9JtgRSsQJGhB8wA35eDJA3IjL5XtPAecF51bGXbv4P1XLhhdlL278mhNe70F5yVbP4rLgusbKnSpciA7+xLbH8fkfA9R9F8lrVbW0KjTO/FngdMV4Iur1FLTKpfEHri/yOd5xWGpB3QvcPv0soxQ3PVsCo7sVbQc2Dd6/bsySMoGaV/lE7DRKrRlN61tzMl70E9wBjeB/691kfwkEuAooJwJFf3HvhbiF9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to enable THP support in shmem today, besides the user
configuration required, the CPU must support PMD-sized pages. This
is the case because of the following has_transparent_hugepage()
usage:

- shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
  if the CPU supports PMD-sized pages

- shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
  the code block calling has_transparent_hugepage(), the
  has_transparent_hugepage() call is exclusively checking if the CPU
  supports PMD-sized pages

While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
in all cases, shmem can determine THP size support at folio allocation
time. Therefore, drop the has_transparent_hugepage() usage listed above
while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.

Additionally, we need to check if PMD size order is supported in
shmem_getattr(). Use pgtable_has_pmd_leaves() for that.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b963f55640a8..c285cb7fd32e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -690,7 +690,7 @@ static int shmem_parse_huge(const char *str)
 	else
 		return -EINVAL;
 
-	if (!has_transparent_hugepage() &&
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
@@ -1524,6 +1524,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 	generic_fillattr(idmap, request_mask, inode, stat);
 
 	orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
+	if (!pgtable_has_pmd_leaves())
+		orders &= ~BIT(PMD_ORDER);
 	if (orders)
 		stat->blksize = PAGE_SIZE << highest_order(orders);
 
@@ -4810,8 +4812,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_huge:
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-		      has_transparent_hugepage()))
+		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
 		break;
@@ -5616,7 +5617,7 @@ void __init shmem_init(void)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
+	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
-- 
2.55.0


