Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6715C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DCAF6B00C6; Mon, 31 Aug 2026 23:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F626B00C8; Mon, 31 Aug 2026 23:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708226B00C9; Mon, 31 Aug 2026 23:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC4CD6B00C6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73BCA16028D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:11 +0000 (UTC)
X-FDA: 85163722182.15.5EDABDB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8140AC0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i9aSZ3hN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWKt08g60DdFG3Icxm2Us7CxOftu08depFwjwgt6DxU=;
	b=4oA8pvgQvBOnpZ80gDrju7TbywuKFb9cIfWKHcROeoG2fBHlPwvOZiG7GXc9ZZEfzXn7RW
	HaKcPBoilxo29EHegQd8ozXZ1TdT/ZCTWGpyy2RSP5njYfsXl1TgXvGXqc9FHkyJ8TvSMj
	Dx0UKK7bc1HE9gtExSV5OgSiRfelgP8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i9aSZ3hN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232389;
	b=AmXnjENz5rGU2Y6OfnPnXaBgcD1Ku2VyEAzVAAmGd49deeb0emXJVJ4KjTAdrnznn9km8n
	fU1adVyFsXZtzcHmgaYL6OAARRZ66Ut/1DEcA/h3cBrdKvys3gy5UHSZWl99RiWTRzF7IC
	o91brda2D/i3euqXKYUqDyBo1rc+yJM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vWKt08g60DdFG3Icxm2Us7CxOftu08depFwjwgt6DxU=;
	b=i9aSZ3hNmLoB7PSwFWWcmS+h0JcC7/B8VM0fOO6uJZCcEp12QN1xwLyuaa6UbWRRVvvi/h
	sZ2ArBxZWiZls42uUH6Qd24zajXh/7tQWw9aL10JTQq2G9gkMCs6E2pnbRzPnBSBUiW9gw
	GC6ddtfK+3Kw5EiQmqd2El3MjN0j7cw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-iIcXydKnMJSdbTVyIHsEhQ-1; Mon,
 31 Aug 2026 23:13:05 -0400
X-MC-Unique: iIcXydKnMJSdbTVyIHsEhQ-1
X-Mimecast-MFC-AGG-ID: iIcXydKnMJSdbTVyIHsEhQ_1788232382
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D44B118707A6;
	Tue,  1 Sep 2026 03:13:01 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B33DF18005B7;
	Tue,  1 Sep 2026 03:12:57 +0000 (UTC)
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
Subject: [PATCH v7 05/14] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Mon, 31 Aug 2026 23:12:09 -0400
Message-ID: <f9ccdcf7faeb0ade4af6a8f98df56b7cf2f7ee27.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: _xSyYTL1yhQNsFyzplXqe0VmetJq8ldJA0sTq9E7Sus_1788232382
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: umg1oyuxf5h6ubzcajhqasn5imiujs8r
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8140AC0004
X-Rspam-User: 
X-HE-Tag: 1788232389-354242
X-HE-Meta: U2FsdGVkX1+xtz7mpf1LNit+7E2duKi/Cwk6U87CP0SP0tHem3NNTN6SVCV5CjRtbJBLnEtFLRbT8Pwrz9MZDVDDYrfNopQWVsL4LisItZ/l0WKbSzgkyWEELl3vdXZw5k0Lv1BMKOLMX5upvwAOtvY0jKbaGW89R0oIgSlyzkyoPjV+yXG6KL3urJ3rxZbXtMXXmonaE/TAfrw/U65PSlsYsazAK+jpKGsFONsMFlau+zW63xYgomDGLMFjmvKrGj0s+xRzjJbHT3GAKR+jVrCo+2DyEOewOtmNgHxjZ0wl/CKfWXmPsImfpcs6MSERlV59Pv0leB9dzQAeOGTYQWiE9Q1KJM65CjkKRPaPP3XR6IjH1fJGwt6qMMMBYzH8m4nuCDKcH5Sm5MbynVid4MdKG8qE9Q+Jdd741NHyg3KnjF2Qm0Bu6JhlqOxwTzTZFQ44tN3ywk1jn0dr+oSPEUskzBD4JbskR7IpYE1ZrTJt6AkPdC5IKebge7zfkZZX6TxOszTRLmGpLQlXBz+Ti4PVm/1Nz7bCo8AGfECkXQvIh/REQSJFWQL+nGBeqTv9SQRwcjsoEa4/XI8+otFDMgoiFAn5lAR96oDrnf5ETx1ZjslyrPwc3MYHB4vry/eXLrVzmRRR5asyg7i3A/myA5/CBnIki1UFYT43GH6jUCxGDZHU0yOhJMkPOkv8Lwo45jeS7vAQBXL1EAne0oxgJcHR1pzs45KriL/jN0Wx87HrddNq2IRomU25lFjzUczMxu4ESTErYWwjwf6UB9I+M0Q0Jf6qqZYkyellOuy/itk7rm6R7ixPVRZnX6ta02UFLaRnvp31wqgIJJ1KPPZKWd4Y5Jjs543YhGAkQEzD5/X8KNOGqo19FfgWwNgpS7p4c5lSJ5JoCKkweAfGF5cAe2+kmcrt5Vr1HHfqua+iUpdHeIzMUa5VwB0xDN7Gz4BulCUl5FOgdeyE77+4dqS
 6ZnuwBka
 0mQmccEcEMw192ztLcu3H/82aTvMW9eWiG/xgQ493wtxEfwS5aEr8l3SPRv5P/gxYvul/x6DhP7nAAAcpb5y3BpUuBZXjOGeGxkqmuZThTvNq9sM6bToqsLHxQZnvhG5xeP7YWjbw1wq7R6c63/gVHKIo6VaDDIGOUomS3yONn5jFGdJOdRtJRXsSsQv5y0Vg7Pju4k8C6PZVhoq0OFrEt46b/vZejFJ5ublUs9ASdiRHtQ4wmvTixYWDiRoqhAjXM4RcmxLteOChyDl0oMcMScRR+I3YU0baUQ4/ww05lP4VzdubBEkih77qxo8m29XQeVpiMcilJyYQIblHjvJBBdmLSfc8IepM8hr/O019wD0YCEpHZmQwMARENTtoK0rY50yGf0P5j6xX4mAKpGUHSf+RllmKNEmIi83D
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


