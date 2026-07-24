Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF24C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F28B6B0099; Thu, 23 Jul 2026 21:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3D46B009D; Thu, 23 Jul 2026 21:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786426B0099; Thu, 23 Jul 2026 21:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 310E16B0099
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB780A0A6D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:17 +0000 (UTC)
X-FDA: 85021952274.06.898559E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB63CC0003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F5ldbCSI;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYklReB2oAm0GSZc5icymDcgDC+npGwNtMCe2qntLC4=;
	b=AS/Yye0nxc+DP0eyLeKoZIFlqBlCSZ/a1xfBXvBQKshL/BapaHn61eveci/RJHOW6uuvaR
	Co4TaPnaf5MlsMPA9WkS+lCHRiyuZBG7Him6EYOJSy9fSyCe2mhrgprSh+Avco1dOhYNkj
	CiOHU75WrWGuHDHJsulxQvE3oLXrrNQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856915;
	b=CiWnGA7Hix1OQuM+JjOCMh7ts3GbKZ6WIOocNuq6GGDR6svDON2kv5MMWtjYjTnkrKj5qG
	+2L/WnZRX4wDfPP3pJcVyJkxTbGOiCOxqXpH54+QNSLfkdNo7L/kVLW6TGrUg3QuXEVYm0
	/52XM8F4H9uLYMSdtp5kC1CWXU/TZCE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F5ldbCSI;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HYklReB2oAm0GSZc5icymDcgDC+npGwNtMCe2qntLC4=;
	b=F5ldbCSI3ognhTvULvCQptd8pwzd8wfCgDk3QeVYFps9b7t0CCTbBQzfBBRXFwhO8492LQ
	kBxuI9jfLJHVj2wOuZNiqIncaGpCV+Yu7YRjM6umpzCdjq3eLxEZGiKnXry47wyOZJqYiZ
	6dUZQF4OoizsOHBz+lbfiohAQTrCpos=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-o0NMr0p_OPOKS36bmNUCzg-1; Thu,
 23 Jul 2026 21:35:10 -0400
X-MC-Unique: o0NMr0p_OPOKS36bmNUCzg-1
X-Mimecast-MFC-AGG-ID: o0NMr0p_OPOKS36bmNUCzg_1784856907
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39204180AAB5;
	Fri, 24 Jul 2026 01:35:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F84A1800594;
	Fri, 24 Jul 2026 01:35:03 +0000 (UTC)
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
Subject: [PATCH v6 07/14] mm: shmem: allow THP support determination at folio allocation time
Date: Thu, 23 Jul 2026 21:34:11 -0400
Message-ID: <bca5ef881f13ed8cdb65d4fff7527d757b6489fc.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: OUJu_o5MnDsNvm6ItMaBwnfsB4EF8vSc73DApJKYowE_1784856907
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB63CC0003
X-Stat-Signature: 9hm99db9cnw8yjjzpa5kqppzmg3otboi
X-HE-Tag: 1784856915-474715
X-HE-Meta: U2FsdGVkX18TpCiZ09jVmXYUe5/s+cDY1dgePKIAozCpr37m+9DXKadp3j7N3LHuFOyp4+RBOFEPJ543/LIlvUFYH6AfbLCFsLUimtAQm8rZUX+BikKve2mElKyA92r+ynqzftEvzIu8vGVP4B/mHCj0XUEXiV/wV/Gp+lo1/VZl4rdfQ5T5S8ZkKa5dIfF218puh3WcFGxFuFxZpcx2hMYPOVlqK9vp+J3hZ/9CgYMcYfjNmYkLPjHyNCvRbeipZXcl1uYU+x8w3d2+sG8iLE7U7QX+BZP5AS8P08zvQZ+5/myF30C/8wFDOFFviOkLNr9HArvXNfYp1j0El6Zmh2ad83RswsbO4podqWycSbEPQqQXZpbMDUxtVqZvBAp8BLkI2Tgc4dnq+DLtpnT9BIC/PGbKIuWPHejybilYkQbMfmUt5lZjTD6hjBtimzQ1sjRAlsSp3ernNdS4yq+izRhHIRlyRd+YV8hpjeIB2k3aEnGuI2Cgy/TqxLwpZS8eU9ZOmQCDisemtZcrCoQemXqM4rX2hOCJP+l5S+TtBxsGCByQI7F3SoXOFtcXRxY4bEgIj7ijPrEhqtAMqQSWbdDrZhp5nQ62Z2rIDQgWaGKJYqTaPTcs9YuvHxYD6tKLpKuRxqAohJRcIMT/E23S0tFVEIpA8JZ1ViA+FvNeLIZv158zawRxz/NzplIjnTeRceE+xGL3P1xdDC1JoYSusVcCqex8zgurbmvj17Bat/im98CIOUtQNYQDmIniGUrICSy2L/bvitWw8LnsahCPPzxOwoIpeEbl4eg7kmo1hsZXrOtncOVhJibeV48LaIbbN6qOPYv9vmzMt0DFiRLLmR5Brn+vA90f27xXobpWOfEIfVhb2X0cKa1Ze2tshxO7oXiSpud1Xax1GlZlgZzdLzndOHJFdFcxLifZCrOE6OoIQM3neZZGBM+NxdASgSqHEZJBS/m+252uW+6rlC/
 OtBcYGGw
 zCYEt7F55WXZ1MXb+FQNuqx88vkjkzvdGx8yqJot+Mr/Iaf7W8xsDzgZ7tBhYHUXq1t+qek7UzikxPBDtCQ7T+3OOtrFSKtn40HkTJP9JMtgAHmLrVbWvqjEUqS1OfWYEL/xmQWrkictyyr/kM5GqpkEvpEywsd/g5/beOkKQo/LaaWZBM1LOiS97+a39c+0TP8sJhoMXq1zC45AasT0A9uRN2lIFbsKrGFy5Z7jPvF6LxLSl2fLu4ttIrwL/RLr3OYoH9nYg+2GiPpxXBhS5nEXmFhOn/yLvaguJQ/6vQFM1jZDwCGAmHTKUZfevFT5dD28m5vnKl5EEO6Hr1MUtzhPuhB1zn1adaPpfFD0tyrM4KSs=
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
index 19534e21b61f..68ae606b5c4c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
 	else
 		return -EINVAL;
 
-	if (!has_transparent_hugepage() &&
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
@@ -1305,6 +1305,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 	generic_fillattr(idmap, request_mask, inode, stat);
 
 	orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
+	if (!pgtable_has_pmd_leaves())
+		orders &= ~BIT(PMD_ORDER);
 	if (orders)
 		stat->blksize = PAGE_SIZE << highest_order(orders);
 
@@ -4589,8 +4591,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_huge:
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-		      has_transparent_hugepage()))
+		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
 		break;
@@ -5385,7 +5386,7 @@ void __init shmem_init(void)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
+	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
-- 
2.55.0


