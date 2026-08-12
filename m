Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754C5C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2146B00A0; Wed, 12 Aug 2026 04:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9166B00A1; Wed, 12 Aug 2026 04:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF506B00A7; Wed, 12 Aug 2026 04:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36F226B00A0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:04:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0BCE14032F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:04:37 +0000 (UTC)
X-FDA: 85091880594.11.B8BA0FC
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 52A5740002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:04:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786521875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t48h3kzXBMrtRbL06hPY3aelV4c4tRNevgGTuIqtj8w=;
	b=bvAzPk+8dWmujmP1xA8qrrYpV2G0sB9yU1VmRrtGj1QtEyclCE0tXDzc9ToFIaESU3LsbR
	pszoiESgx5PKp0AwXECCU72XQXT2rzJY5KSdQk2rejdxJ9oEpbHi/G7jpeYQH6p42RWw84
	ummeQhvB8ta6m4BppzS3eGy7n5JTNwM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786521875;
	b=qG+wLt46bUrKOxzXNNtkR64/qmQEdXt5t4ia+r9YDSyISFKOXOG5brRWVXuDhwfzOSa5x6
	+jgtrx9m852rt2+14J6U/YhKq1JfS+sYP8awirzmvMqmCyiR65fv92nJ17e9pGuwYc/J8t
	8lbF9/CLxhAsTlI/lH8qKnyFHiUP0nY=
X-UUID: 6e1474f6962411f1aa26b74ffac11d73-20260812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:75e5a4f8-eae9-41d8-aad9-60c9e9fdeb0e,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:75e5a4f8-eae9-41d8-aad9-60c9e9fdeb0e,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:ef6834d9f8dad171e96e31e568c51f1a,BulkI
	D:2608121604281BMG07Q4,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|136|865|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,
	RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6e1474f6962411f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2092408523; Wed, 12 Aug 2026 16:04:23 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 1/2] Docs/ABI: document transparent_hugepage/shrink_underused
Date: Wed, 12 Aug 2026 16:03:12 +0800
Message-ID: <20260812080313.330413-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812080313.330413-1-husong@kylinos.cn>
References: <20260812080313.330413-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52A5740002
X-Stat-Signature: jhpekd48uui7sb1a8ptgsipb6c4f6f5i
X-Rspam-User: 
X-HE-Tag: 1786521873-754519
X-HE-Meta: U2FsdGVkX18LMQPdbON2AS6jvSH8bSqLkmPuBcAzzmDwN4aoDnIGrnv8y4hNm/k76YjthjZLSfoz0vVDSyQEjEBQEyxXLm+lZVQV2OgLPp6vLUK0fUF9C8hu0MktZfKLFyC7GaiRt+Vn1AXtgd8KpBPncBHXYqVP6CfLCInxfA3d27tAZIjCBRpT+eoebTCRF7kOLpU/3yAKye1nGWZ6b8rVXH8dOUEYvPHdqA9Rz2fAlbwRM5mAL0JFQ/Ai20ctv/K+qYtPkwh1Ql6UluJO8jlrUWc57k6Nf07zDRatbzpuuFaxAZgd8eCGoq/VeyltWAkQHpZ03V7SJ44bKhvtxuHH3l2wWpSYEhxFNhXar4Vl900743inxyk72IudFEl55L3W2IuaPZ4v4i8aFZC3gtzh4QNEghCrrgFYd157JnAG+Z58xV7CLhGHm5FQ1GcpKX/6oqOhaQE3RkFuXOEbW/syobb/sL3WQ8HD9krV+9u4DcM5Zb6PW8tJ2b8Qo9HWEzN97UD3RIXAoXTjiZ4uGkpt/NYsW08hzfe4uuiS7BFJyEoXbHDgGzT+P7lXa2SGrM76LNf6RZeTH+qfX2D4o3FQlXX/ALCqrursZqnTd6fKYfqn0tM/J2KLu29X9ITEvHKrrjjTCsYRR0Sy2yG23r8s5WCz8q93SmbweifHeNNvGyoWpGZ8Bfs/4QJP/+6i6koHyie77dLgTx6QtoeE2y/tyyXx7pBetEOtPGYR6aweahCon+anjNSwhk4b9Hi7pZSVAMKI3h0JHuU5u1Fzs9cSkqcqhenJRJZU6WDohQIiA4TCLFucN9OKTzFVK9vEvC2KCyEEsiroOBQhbHEmyqksqXjuG8bTBLXJF3zmGerlkHgAmAtP3TiHxLIKeedmRPovlI4Qoa02ZHuglAdS5qc77ZkbQwH/LpbN0aNZaWNqWdz8qoUzizDOOvfwwDbqEqwsOets9fM3DLPaLPr
 SdIN/AQ2
 yyYHi7LFVhKMryTPKg1v0AtbqdKj+WD9H8jAkRSlMaCRyHBORrgLRZLpgQJlBs+hCKYuHJJp80yT66FsieOGEBBe92VN9rWaSMMSpoKjTgAVRiao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shrink_underused knob was added in commit 81d3ff3c6f76 ("mm: add
sysfs entry to disable splitting underused THPs") but is missing from
Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage, although
transhuge.rst already documents it.  Add the ABI entry.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 .../ABI/testing/sysfs-kernel-mm-transparent-hugepage   | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage b/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
index 7bfbb9cc2c11..bbdfae2c0caa 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
@@ -10,9 +10,19 @@ Description:
 			- hpage_pmd_size
 			- khugepaged
 			- shmem_enabled
+			- shrink_underused
 			- use_zero_page
 			- subdirectories of the form hugepages-<size>kB, where <size>
 			  is the page size of the hugepages supported by the kernel/CPU
 			  combination.
 
 		See Documentation/admin-guide/mm/transhuge.rst for details.
+
+What:		/sys/kernel/mm/transparent_hugepage/shrink_underused
+Date:		Sep 2024
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Reading and writing this file controls whether khugepaged
+		splits underused transparent huge pages (THPs) under memory
+		pressure.  A THP is considered underused when its number of
+		zero-filled pages is above max_ptes_none.  Enabled by default;
+		writing 0 disables the splitting and 1 enables it.
-- 
2.43.0


