Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDED2106F304
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7236B0005; Thu, 26 Mar 2026 04:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188566B0089; Thu, 26 Mar 2026 04:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0777E6B0095; Thu, 26 Mar 2026 04:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAB5E6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:53:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C58DC392F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:53:10 +0000 (UTC)
X-FDA: 84587599740.19.A371F8D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf18.hostedemail.com (Postfix) with ESMTP id D68901C0014
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:53:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774515188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gAv7VXC9JcDQqnfBDUkG0iOTMMA+w60vTH7VNsMKT00=;
	b=rIIxPOlDL7Or7jSpoaV4AJoFnazjW4lvmyHgX9O6EBpaDfv0Ba2D0gRFsUz7QrdAD62f+5
	KOrAC4CY18tKqA0vIiK/2WFNR019KSliVpSFWL/n5BAxPRRXv5rcpv/pjUAqLAVC5E6AwL
	lQjoQxo9Bi10zTvwNtwBJcoPlV+JBM4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774515188; a=rsa-sha256;
	cv=none;
	b=ecpY/WUzRNktrIcUHjz34/mfWFME8g2eaUAV+yhox7yRm2hMvaePfV8Bs6JsPkRfLWrFie
	uYkRf5w11nZoVd2qhF8zdanAjzIQiwh6utxt9HOnYVfpJ+9B+n8yfzMM63yMWdkiRr8ekN
	sYCYpwpCnNtheFwxGSdNIZ+kcf7tVRI=
X-UUID: 7f2d37c428f011f1a21c59e7364eecb8-20260326
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:a72e581e-92dd-4fdb-a9b0-1a082cb00933,IP:10,
	URL:25,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:5
X-CID-INFO: VERSION:1.3.11,REQID:a72e581e-92dd-4fdb-a9b0-1a082cb00933,IP:10,UR
	L:25,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:5
X-CID-META: VersionHash:89c9d04,CLOUDID:1467e7590ec80c26cdec8a7899216632,BulkI
	D:260326164801FNQ8KTQP,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:11|94|81|1,File:nil,
	RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7f2d37c428f011f1a21c59e7364eecb8-20260326
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1230445524; Thu, 26 Mar 2026 16:48:01 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v3 7/7] mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios
Date: Thu, 26 Mar 2026 16:47:27 +0800
Message-Id: <20260326084727.118437-8-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260326084727.118437-1-duanchenghao@kylinos.cn>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D68901C0014
X-Stat-Signature: sox795hb6658iunn3dtnupu6zdudrb15
X-Rspam-User: 
X-HE-Tag: 1774515187-436729
X-HE-Meta: U2FsdGVkX19VuBIkbkxtmPOnkEfwmistUfE/fdVmmWHOkB5N2oWeEONEisejcWe/KwZLv9fMCkSDwU1oKRjbfIe48P/SkKRtTvualVOypelAOjfUHkf3i9d5tdY6UK07CvpyNhxM3OV4i3MVIlMbhgPjEYZA5ac4ZtNlEoYH9o4ZxUYYjXO4T9ZIqhY5TypRfUNF9ScOSGwxRWWuJJGJubvUgu5gEU6M80YXnc12RawFRFHzCl12/HMm6DjqG7boFdCbO7vsh8LGcmDExhrJNVaZhefOwJ3TrZQM9m0d2Z0kvl3IClkjusN1FnQmNPaNs/sdmB14LMD5e8u6r1yxChTAMVdpfiCOVEIQUn6W8nXGRBLhqlSz3ee3n2UcytspGp8BRXti7X3LKLMZGGpF3mGsxZd8P7EDGMwSXC8I4Ik+bayt0SkwU0m047UIh7d902DXgTEXBe4LaUwdojDdPqlwSuN+WO1LwEZuvyOdm8yVBzadxCgrbHMVUPdYNe3YjfOkpvnIJydKYAdb/FxJFGj/iOt+YBlEYXTQMnoAsH+lJvIFALxKLeZuqYXgrqaUKcCTXEIjcwWFrqu00QCWoVvAgz75i0Szcq2WEFjiQw8B85Os9T9nApCiIC+w5palPeLmSRE5Wkl5ZGZ5BWMM6PxmeU9kcJBR6oIAetXXTd45Wf3GAzdUTrRxV3ekduLp/rDEX7uweT9l40h+JbX54Yf1nqj3UHMqAfypXnIzHRJg30P5vQv+k0cHLzalBIkPUKF59ZIu69Fpi0C1ysDym1SvadTiVp5So7OoA4iNRTOaNeKlGFoqpkUb04JyOT4lUbukRxzxgy19WyGRuAJqBV0be76tC6NIOFc6xj1NZv5LAYvaXU1c8GTTJ/QHZAxQ9wjR9EskIIijewNFA73TXymQ877WQeoEscLn4kaiD3tK3U1v1llz3u0mpBQGI6LQiKVE16BZxcQ1m0kt5Tj
 7w0ChLwe
 mVv+2QWeJcGxJ112roSAbozq7eEbGgkBjDt49T/SFo5DT7hLNu+E9JHqJkUQFUqL/Jyt/XQ0/NtV9Y9rzNcR2S0bW9CVE2Lm2YG4NTJgqrxti9fg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memfd_luo_preserve_folios(), two variables had types that could cause
silent data loss with large files:

1. 'size' was declared as 'long', truncating the 64-bit result of
   i_size_read(). On 32-bit systems a 4GB file would be truncated to 0,
   causing the function to return early and discard all data.

2. 'max_folios' was declared as 'unsigned int', causing overflow for
   sparse files larger than 4TB. For example, a 16TB+4KB file would
   calculate 0x100000001 folios but truncate to 1 when assigned to
   max_folios, causing memfd_pin_folios() to pin only the first folio.

Fix by changing both variables to 'u64' to match the types returned
by i_size_read() and the folio count calculations.

This issue was identified by the AI review.
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index f8e8f99b1848..4b4fa2f658d9 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -88,8 +88,8 @@ static int memfd_luo_preserve_folios(struct file *file,
 {
 	struct inode *inode = file_inode(file);
 	struct memfd_luo_folio_ser *folios_ser;
-	unsigned int max_folios;
-	long i, size, nr_pinned;
+	u64 size, max_folios;
+	long i, nr_pinned;
 	struct folio **folios;
 	int err = -EINVAL;
 	pgoff_t offset;
-- 
2.25.1


