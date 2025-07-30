Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F7EC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 11:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D546B0093; Wed, 30 Jul 2025 07:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC3A6B0095; Wed, 30 Jul 2025 07:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2346B0096; Wed, 30 Jul 2025 07:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2046B0093
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:34:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B32BEB96E6
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:34:16 +0000 (UTC)
X-FDA: 83720722512.20.B1378E0
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6624C40009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:34:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=hfhYQeLA;
	spf=pass (imf12.hostedemail.com: domain of manivannan.sadhasivam@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=manivannan.sadhasivam@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753875254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BhCKTD8r+PtEiCiOXNxswbUmBHQNdQ6OsmNmzxRSaec=;
	b=rE2gaDAkDfnwiFe2tOaSQzT8vZT+4ZhMeNQgL8k/hYu0BwN8maLWXfANjBmbeyGHt2KNtD
	B5IVIl5W45MLDcZ70pSx/3cdRwhceYIuZFwMOYHEVRVQ/G70jUIXqXIIj7gYNN8C5+6T94
	wnfDyvY9Bm8QLbAsRdVDBtjthH5/LYI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753875254; a=rsa-sha256;
	cv=none;
	b=No58B85pPeTAMu7XB9cFpWK0bY0cCjFCyu1YURih2HRthropK5OVHwHE4u1rsJoRpvDkLI
	OXS5LdpF/o2rtrnjeHonQZV2Xu9E9eRHNuM4fR/tBeB3XLC7767UczVd1FGizjWjccDiEY
	QvET7cDj7aULOntKmKsrf01CAIevaIs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=hfhYQeLA;
	spf=pass (imf12.hostedemail.com: domain of manivannan.sadhasivam@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=manivannan.sadhasivam@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56U7QViH030179
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=BhCKTD8r+PtEiCiOXNxswbUmBHQNdQ6OsmN
	mzxRSaec=; b=hfhYQeLAjdvpelqJbPDopViDbil4yS3ew278zWna8mHW849q8Co
	heEhRK2hkJ7DFS/TAZnH4jTsAmufVP8GJC2WVNGwW3F4UCxkoPqXHlHGKBaNoahp
	Ek5GTUO9alBX1gkUfl1H8wDOeAfNE4B+ZTwkKkiauxcT7uU7ZjhUkScXrkWSA2T1
	IzQgM449PPm1iMay7ZozZz1XEYnzFumm35sjuB9os8W9bl8cnZS6HpCdMCiAzQUp
	rwn/50M4gkuCYlvyLatOM9sdU082WZ+Ns4t5Y0ZCtH8z5g8cHiP26dKQ5BYxKvY+
	ZJNvdkIiLDyan+cnEYP39QJRlkjHVDEXkhA==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 484pbm3f6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:34:13 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-7073b4fb53eso13806616d6.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:34:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753875252; x=1754480052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhCKTD8r+PtEiCiOXNxswbUmBHQNdQ6OsmNmzxRSaec=;
        b=cEYFs09jrsit1qm2omrID0RaPOUq7RpTjQP9t1mKosVaZndeOuLfhjorOU1exaudBE
         xdEDwLARDJH9X/2w3nc2j5dwjkYXAMCQzRBPw9xFYXg3F/XS32OfDpQ2kB8hV1tt7qZg
         Y3oUnz7wCBXSw31HxVxtA3rYAwvPeW6qSivxhY52bffHuapfOGk+M9msv2qs8xyUz3Ug
         TdxRSKCpfjyXPX2TdoAn+N4GsT8fEFN7y4Z26gIWNDE+DerawAV3V4Vfs3GVHIWObn9o
         SWaH0xNpvIAEXMEUpCcgS/JIFLjwmqLzuzuRT1tmazApkFn2gvXIGTNhr+ReBs9Its3P
         hnYg==
X-Forwarded-Encrypted: i=1; AJvYcCX2oBA8hTpifN3BFA6IbTy9jEhJSJ/sVds8ak7h3QOWurlbog4ojZHtji5pne+exh/D/qFcubOAOw==@kvack.org
X-Gm-Message-State: AOJu0YwUwIVmKdQO1Qxwr/V+rDqQq6D+ejwjqYrKDhEDwC/n96bh2nyB
	E44MNJK60cyXuEeLdZRPkd4NaYYiZo8DDAX++3aQMgflVOm+O6KIvmTbFyuZ/Gyw8fWmL0ivZsU
	/0JP2qlS71W2Ydih4kqyoCbIEaAmyTLszbhAeR+iYWgZ4AgdlGujmhA==
X-Gm-Gg: ASbGncsAvwHix8PyIg2bdSJrmo3P9l/zhylZx+qPsPW7jccaANjJlsa6z/+R4qjmNYL
	g18yc/2ix60RjSobM3yfx7TN7G9wPRM7hNURGC/37P5+QTcSwjKtuDtuZEGd/dsAx3ekXN+O62b
	aSVet31GU1x8cJaSJmm4Zg6HVDFCuqWL6QDMbTVfrfulpQFWqqkn2CY22eG7MXqKCZNjQDApBEf
	0Q1XVUY2C82sRSOjD4XBbVlJOMCJeCDfPnSn28QWcSqd9HsIDZta4J2zYSJuqxn4+elVZuEOjnD
	6IRfzlovjeFfPRrdsx2snq01bF9eBnjPTxyAx0W/KIZdbE7/VWFXAeppWl94
X-Received: by 2002:ad4:5aa3:0:b0:704:ac29:dda0 with SMTP id 6a1803df08f44-70766e7f5damr42274056d6.18.1753875252416;
        Wed, 30 Jul 2025 04:34:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGexGDGuxaehZW2/cifgkeDlHP40UB5yPKGc7P/QMgOHs9eSLCivNSPwq4Mlwv+4EQiv5YxTg==
X-Received: by 2002:ad4:5aa3:0:b0:704:ac29:dda0 with SMTP id 6a1803df08f44-70766e7f5damr42273556d6.18.1753875252021;
        Wed, 30 Jul 2025 04:34:12 -0700 (PDT)
Received: from work.. ([117.193.215.211])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae9951745asm64937751cf.6.2025.07.30.04.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 04:34:11 -0700 (PDT)
From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
To: willy@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH] idr: Fix the kernel-doc for idr_is_empty()
Date: Wed, 30 Jul 2025 17:04:02 +0530
Message-ID: <20250730113402.11733-1-manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: git-send-email 2.45.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=LsaSymdc c=1 sm=1 tr=0 ts=688a0335 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=+urnqZw5vKot7juVQre6pw==:17
 a=Wb1JkmetP80A:10 a=EUspDBNiAAAA:8 a=-2WPVV21f4NiumMF_pwA:9
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA4MiBTYWx0ZWRfXwDXrumJnvl41
 GZygQ0N9SEeJfgFG7wAGwrMvftwaCxtlWeL6o8Rx3HF3HRSSwdBVy+jfMlJIFPKUk/pf+lJCz/u
 3UQffbwdpkOw3y2P3Gb7Wvg4QPXT2dW+sf9jk3EJ7bAz70J5jES1AwAYkkb1xmi/38NiAIxJHUP
 PTOTSpYWlQouOSMQ5KtWVigrp1JHBA/vdEJX/1GQ/XrVAKMrhA8NcDEKgLWbUY7yD1QTG3ygsQh
 krGH3FU83kucAEc9dSvvOICxQnU9bEb5UBlWcxEkDQuIzePgj+bMtZWX5bB6oRDsbNlwGoPm2tw
 ms1AF+NDggaMb9iheLoX3J8dZ9Ptf0H/sqql369ixQ/MBpTd/ClsbT1D6Dj9csvoXkqJSixtum1
 7eWkhOEMq0UaVs7/X38z03Dv3j8y7WWfH2ztIKvVs8fYox50Gi+YMtYEY6sX+YWTZbQkD9Rb
X-Proofpoint-ORIG-GUID: 6oMBCz7LujxLcRp263bb64ZM3J0GQXRb
X-Proofpoint-GUID: 6oMBCz7LujxLcRp263bb64ZM3J0GQXRb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_04,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507300082
X-Rspamd-Queue-Id: 6624C40009
X-Stat-Signature: b4ikgxn8xqid6oixj1s1hus69xyspwty
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753875254-309434
X-HE-Meta: U2FsdGVkX1/n83hAIAu920YFvqA8lRauSWd05hQSPuNJDLMljhjKgvv1QTQ08/36Y3zvvzr7owdDsuOZoyi0q40XNQzq0Tz0MbCsK2vY/hc2EmiVkkdOb7l46Tw1iJLXaBgP9jOah9xwdb0PxQVqfYYnQuYL5jknO2ZMzBxI/G07nHvAOZB9kHI0VydqPRewiDr+X0hB5dbFv/COn99Hp9er0SNh3gqHL/G234f10nNfxeA6fAne5aZXICYPQDyCquRFwxVc3rNoHQykCnEq8TcW3BWCceu9h3DklXXv8FEatnsg3TMm0oqVkjk6UmKj7gO8a4YJ4qBO7PFX7AKyWnx5gkkiokwvOvLc6XPdubqGj82hPu1Xri8hgzg1pGGr9GJcDfm8nirUxIeFXAHwWNAcpvZ9CFgTHYy/qcJ0hdUg8xOLWX6zatfbWDM/ITcLLkKEO7uXvjKBCMRZo0h55rFeLlmlXHZ2oflKaYjA8bUjCe2uzQJ7UFobqLbVcHrBxyF2+BXbvfcV+4kf9VZtw3AXPQiij5zA9oFy5Cnn0uAa66D8FkfhNSpaiTIcu7BSHEt3DkovYO6RzuXNiW547GhEtjiR/9MBbisKMoxUOvYnkY1O3Mq+RpoOcz/JgLltTwarF1Bo/rtWKdMo37wOB+EZ2aL1OjUMU9Bfdv8dhEoC3CliwuERak57qIIMhll+bBNVCmOSIVog4jbC/I4BzqNZz3sLk1dTiESg7raYKXM/NRoxJMXosiqIKPgAJw3ISruepTiWPOaJTeFY0+4LQwfe9okEadwKq/PBECzESYfAfmREPKw4GJToTqy9XR13xgSf8GU9iWPwK0eqbtnnN8hkgH3QXo8SWoKy1/8oxzzl0YQ72zPta3Ty4bPzJueSfdYCHGZYnXRZwtzbWqibxrS36hvxx0rBObOm6V45VB1p21XuSDGsi3ZoNMyRg5IdbswSm+Xb0HVgKs8nW/8
 T4cH+B1v
 cKnmGiDHd2oLuRz2aEC+Cs13XX1+I9a9Dd5k/kKBRgGmYxB4rMutVIx/uCtyIjPk6WTzUmGY35ltsA8XbVR2OZufvYiP4/8mG30GkTTDPHIQdswhVpq3nFlxjBNlvBX0UOW12xfCU3rKpL648NY5J3b66isDs/WvTKO/BR1G8Hl859O/Lps9mfAH7a/ykhlDvYWKL6qddE6FkXxSulMJ6+7A3j0aSadNNsE+fybd+twl1zk2q68nSD/mrQ0l//rPK+bzOEW1JUwGQz+zhCF5bflt3hFCYcXmwXqhMWvIM6NRPdGy4cFerhMza0Lo7Ptw59IbPisTNuEhbaa6e++QhbXWPcgTqvs2FwO9X7q2yy1hA0vpz/NWjHd/aCb3qmt/hyFokxI9J49m1kk0nP28jbo/KtH7fQHe9Q12MI/+r690rip+ZuTcq7HID6At9Cr1poZ7LHGetCIJeIjFvUGH9T2BMZ84k5Zlht3lV/E+bQZ8omGGvmWMcGFsjyZtuwUlOLt1R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

idr_is_empty() will return 'true' if IDR is empty and 'false' if any IDs
have been allocated from it. But the kernel-doc says the opposite. Hence,
fix it.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---

Btw, I'm not sure if we really need the radix_tree_tagged() check in this
function. It looks redundant to me. But since I'm not too sure about it, I left
it as it is.

 include/linux/idr.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 2267902d29a7..4955cf89e9c7 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -172,7 +172,9 @@ static inline void idr_init(struct idr *idr)
  * idr_is_empty() - Are there any IDs allocated?
  * @idr: IDR handle.
  *
- * Return: %true if any IDs have been allocated from this IDR.
+ * Return:
+ * * %true if this IDR is empty, or
+ * * %false if any IDs have been allocated from this IDR.
  */
 static inline bool idr_is_empty(const struct idr *idr)
 {
-- 
2.45.2


