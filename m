Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAD1C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6636B009F; Thu, 17 Sep 2026 21:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9024E6B00A0; Thu, 17 Sep 2026 21:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0AC6B00A1; Thu, 17 Sep 2026 21:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 403B66B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C3AFC04DB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:36 +0000 (UTC)
X-FDA: 85225193592.11.8C61C36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5204AA0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H3PT0sDj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H3PT0sDj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789695994;
	b=yfr9/korVgErbujVW/dm/mudJ1JP6c9fGPLC8U+FWuD1Cibown7n0NNMQwhN2iihxxFWp8
	oeH8FybVUwUbLHo9IMJE+Ar6g/kmq9x8u4zdYkPCSX+4OrZzi1PG75dTXsTGA69xVB/P37
	qYUa8EfrYuEDJXs2dBNZvB8i/QJe8Qk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWKt08g60DdFG3Icxm2Us7CxOftu08depFwjwgt6DxU=;
	b=1xmB3/N6QrW2cqW5B9vS9TA7LU1/vuRq4xwQcAMucFWrtzqyfB0MYtN8krMwwk61naiMGa
	ODlZsaxBRxuacLid2n3Ji48Lvxm2zLrRvGQSE+ZX0/g+W76M05D6eQZhQIcPqnQXelcYC0
	zZaisSEtBfFlUyZPf33Y26l5vgLHwRg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789695993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vWKt08g60DdFG3Icxm2Us7CxOftu08depFwjwgt6DxU=;
	b=H3PT0sDjnfjEWwY5b8mYesCPGuw/L1fVy1e/FDqBKTtVIzbmfVcF1RsGqh9ZzZoxbgJPFa
	k3Pio2wWuzHGO889k6U+HgSHeJ/V2dAAHW7K1ZBG7PThgNWWUzKZhfjabxRWQgRh7RI0Nx
	cZh0+E12lZVKprHzgziYVrhxYvqmTmE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-3JtACFm8MJC4ZpeM-akWdQ-1; Thu,
 17 Sep 2026 21:46:28 -0400
X-MC-Unique: 3JtACFm8MJC4ZpeM-akWdQ-1
X-Mimecast-MFC-AGG-ID: 3JtACFm8MJC4ZpeM-akWdQ_1789695985
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E7DB195FCDE;
	Fri, 18 Sep 2026 01:46:25 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3CD118004D2;
	Fri, 18 Sep 2026 01:46:21 +0000 (UTC)
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
Subject: [PATCH v8 05/14] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Thu, 17 Sep 2026 21:45:26 -0400
Message-ID: <55bb106b95979658b9f8e53d0388e84a8c8de90a.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Puy47fGbvtyv4hmUeyqvhwVCE2N2KdHBI-i9EHIpdow_1789695985
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 5204AA0004
X-Stat-Signature: n6dk1rnptnajaz3cefpdzc3dgjtk4ku1
X-Rspamd-Server: rspam01
X-HE-Tag: 1789695994-159743
X-HE-Meta: U2FsdGVkX1/QM58kfWaCQQ927hUe/puBiTQtgEHwCEPPTvbep/QNXsb7iLKnIyIm+4pQyJzeSBXYNQZc3YPSsp2tH6J2ZOBT7k7DXRBZQAblTU25v0BwrP309FLt1+LCztKJBwVVSGtmPWPDbKFXW3ss/0z4bWD/ERBxjkduskGPm757z8wz8qrpQPk8QOsP0fAas4kpAFVRMBJKUFlIA9JFDtgvq9kewODbsWbC7Ug+Jy8Yl/OwRhyVle4HKlcOzAsjHXNyWdHINs3QfIRh42I2m1SLlXo8pp1AqjRn2BmGDVPA9Dh11YK1uNA+/sfdB2sgBVTk0QFQacFK/AFcdkjPYbh2TYH2832v4d9nNd7KvO6uKS18qZYXa3ykmoaIuFkV4VSbJierhzN0i6C/yvU4Zm1SycBUggUq1fvxuoX3FtfT9gMMSd9JM8i4BLNmlh3Awp5bHoj4VN790CS821tQx3t78h+49koUcRSexDyeg9pxBSmgorDugtW06saNMezNS2yyNddA/6CZ7xPDVZU+k56tanplviJSh/3HBel4+Ldi5zhVpjrMFaYO5svYyeH+n1qzarysjAnHAdXwehibUraQLzsX3PdrJNt56bpdnFvfKJ4lEPRc/M3tlwlzJ8PqxHcYjnoerYPlnm6vgbEWBumW+TL9TwhdZY5UhtJlJwyp/V7rvwrxWTTPwii2KVFpaFBYipWeiQadsmm9WIHJE2efDnFosQyOQx5f/3R7Dkgg+3ZBmooQD+DkCWUJyqFr99Xuybkm7MFia13zV8THrCR9OlQXLHpvaWDS6fvgzBoST5VGvjhDKT0nUl4jzThiouxA0nIYoXjKCFBKMp9ySJ060qwnSTYpLVHFarugU33yPvafG3+aqSyeSHiWxU74gZrAZye1/U3inJBRjmfs6pANYoYodG9R1xUYcNcReKI0WdzSYd4KR9lQYVnZxwfW8tZcy0NlNJXFb1y
 VAwaouoZ
 vzKE6ksnNaoaMCEQ1CaF+OuA/aCEYR80awy5whfKEg25Ild0ykCby8JkzHnJdfF9PaN8N05svybHqxHhXZtf0r7bx1LJWKAHWZSvnaleqyGrDE5z3DPlfwnd+VW/eeCX6TNgvZXfo4f4ssmYTJG0OyNJXrfce3hhTQy4XRcEI1+YGi0ve1ZE9C/ht6PbYBHblv8hdMXgzD/Zez0n2lcZe35DgtQAfFn9HQk5QAgA1IRLdERS2PfIOkcjGWAQks1jBKlgP0f9vAzFeOtXSG1gS8xVHhNqWh2IMeXSeo1ZwzXHxzTXDMGo+uqm6KNnoIPe6aSMgvnmrJq3EmmdDxDRoDaPDg5gDIc7CpcinQJyGZHbJkQkH8jQaJrNyLo51yT5hQUsovuSpIu0ewWKffLaUjiWxw0RM6UmXT1QN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nd_pfn_supported_alignments() and nd_pfn_default_alignment() use
has_transparent_hugepage() to check if THP is supported with PMD-sized
pages. Use pgtable_has_pmd_leaves() instead. Also, check for
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) to preserve the current
implementation semantics.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/nvdimm/pfn_devs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 8fa9c16aba7e..457eb54e7ab6 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -94,7 +94,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
 
 	alignments[0] = PAGE_SIZE;
 
-	if (has_transparent_hugepage()) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    pgtable_has_pmd_leaves()) {
 		alignments[1] = HPAGE_PMD_SIZE;
 		if (has_transparent_pud_hugepage())
 			alignments[2] = HPAGE_PUD_SIZE;
@@ -109,7 +110,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
 static unsigned long nd_pfn_default_alignment(void)
 {
 
-	if (has_transparent_hugepage())
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    pgtable_has_pmd_leaves())
 		return HPAGE_PMD_SIZE;
 	return PAGE_SIZE;
 }
-- 
2.55.0


