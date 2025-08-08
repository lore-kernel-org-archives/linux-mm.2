Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360F1C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA666B009F; Fri,  8 Aug 2025 08:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAAC76B00A0; Fri,  8 Aug 2025 08:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4BD46B00A1; Fri,  8 Aug 2025 08:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFFE6B009F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:12:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22D6C55CBC
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:43 +0000 (UTC)
X-FDA: 83753478606.16.F82E688
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4564818000F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="b/e3xPUX";
	spf=pass (imf06.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754655160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=S5yNMiVryFwGG2xAA8XVh2ZWIiCVa+aa/y2M/HZeZ14=;
	b=nbUVRmO0rDpYgvr5YqGwjADSJBopygY+z6qHYzMct3AsTT/OmjBwMRRFQa1ThbanhOI89m
	KZ1S7iEdwt8CI7FDSj2AvnN0Nv1AGP6lQh8aVQ1HooEO7pBOb1YJiK5m5TZAZ7Gs1vHnIk
	KwWpUqyTRSXIG/T1LAetbhXRjGnqcmY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754655160; a=rsa-sha256;
	cv=none;
	b=zC3zkv7/Fxnkiw+9o5FdIPeSbQt/cPtmokAWXX/cAaWR+wO1foZ9gUPd25WwnujxvGi7Gd
	5Lxb31JnRqpIlJ1PKCDjVr46D3DYoNGipq1gQhv10J3tcqusiLjmtNAfmXdOZbbfitjPfG
	2swsSgxU8haNQPVZw2JuY6eH7gnWrRo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="b/e3xPUX";
	spf=pass (imf06.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5787SM77003404
	for <linux-mm@kvack.org>; Fri, 8 Aug 2025 12:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=S5yNMiVryFwGG2xAA8XVh2
	ZWIiCVa+aa/y2M/HZeZ14=; b=b/e3xPUXUOnAbhnufsKKYJ1E7vSZty4jmz1Npl
	yvqbL10R/O8GcZ1vmx10uhaUtjh0Ef2u7C9c0sLszSfcxrE6B4ry+37+wzD++xUn
	1+iE3QrUEJ1sxKPsUdNMGtMaD+3wfuxfFJ2uzp6t383XXQ8duKfHLdRfENdwqGHB
	M4czaAP8+nKbp46G9tfuAlLdZyCh6o+ZegDVIHkP12TGz+SzQKjlT9h5vQH5unL5
	NdGDod3EzJ7S1kQA63qHoK7XEX5X9gPSdQT23Zt/PWJlP5ntTI5/Tq+QwFij+KIW
	QtA1CbWmCSX6ZQM3eiVyR+lmor4RiZ2M8QuhR+6NNTPk9CrQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48bpw025k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 08 Aug 2025 12:12:39 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2400cbd4241so32406035ad.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 05:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754655158; x=1755259958;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S5yNMiVryFwGG2xAA8XVh2ZWIiCVa+aa/y2M/HZeZ14=;
        b=Lt+r3WrPcEzpMWMKANXzZe7PMW0/AwVSqDqV2B3mJVbLumPQw5zcVBheLtxOgwsGwI
         r97TrkWhPSdBl8Hmo49jAzcOwNn74y3b7Vz/sCBfE3tQy5utysNdyuXZPvEEb14apze9
         4c8zI4fqpsdWjJo/WX4+2omxMMJHHiG9+zhVSEF8muWzcrZ7nfxrCZWr8Kp6ZV50S7Cl
         0gLMxcJQeUcWa/qEx0gJJk5CtQ4eELOcnM1wdJXZEQIOqRH0+T8/8gE0/8Qh/Yz57oUn
         ugUYQP86j16PD9W2MfEwZWZ1TWoLm78oAdP2RX/filMLBG0ByG8ViO62wAETZYe5Glhr
         RXBQ==
X-Gm-Message-State: AOJu0YxU6ybrP1lB3dJTUUW6p5FpZIk/qUsPGacMkuxmJilMdG4AivLJ
	jRi0ShSXSIcPjeQbbJojn8ZMAe0r8+5Fh0ju/RhuQRDQmKECzkFeihWhn1d8EFlg9VMJXCupOe7
	ed7BP0JyzTSb8ANFYFPkBnOBi4pmTCH86NVww5rRZJi933KjYoGaps2/0QOwhjbBC0Qo=
X-Gm-Gg: ASbGncucolRC1KAXUKtwFivSnWGYmdaHlZph89kniGLJ5Sl9i3+VJHhbHMItGbVAp6x
	zPXWp/HgMRTisqD7ZMsB3LlhgINWNON+XVUpnSavIyJU3GMwmbzGDPZDbS24LReeMWf9qiPuynK
	tEtKsH9fVwooJgPJkW5DBsGybEFdxTLvMD0VT1TOOBC6zfCy8g/mq69m4zb65EDPfjpv5tBjlPG
	Tq9sdzDq8Wd8+CU3jxNniUxPCvAeXXaEQZtnOJuCk8f8mOcekVOH/Ortkjl0ZxZd4jrnp42IdJp
	RbzckZ0qPBBi5GFvCBImWqYNrRH4
X-Received: by 2002:a17:902:f543:b0:240:6406:c471 with SMTP id d9443c01a7336-242c1fdc70fmr36226985ad.10.1754655157663;
        Fri, 08 Aug 2025 05:12:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECpKQ/v5JKdeVcyVVibX/xqzvIzneVnVstvg/MXM27SuAFO3gMxlFTqtbF7/tvuRIckv++ww==
X-Received: by 2002:a17:902:f543:b0:240:6406:c471 with SMTP id d9443c01a7336-242c1fdc70fmr36226525ad.10.1754655157181;
        Fri, 08 Aug 2025 05:12:37 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e899aaecsm209622995ad.119.2025.08.08.05.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 05:12:36 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Date: Fri, 08 Aug 2025 17:42:22 +0530
Subject: [PATCH] mm/numa_memblks: Use pr_debug instead of
 printk(KERN_DEBUG)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAKXplWgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDCwML3bzS3ETdlKR0XTOjRIskIwNLo2RTMyWg8oKi1LTMCrBR0bG1tQC
 djrgsWgAAAA==
X-Change-ID: 20250808-numa-dbg-62a8b2092c56
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754655154; l=997;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=5Qo1LK7YyFgDdROrB8rkJMFFqZAABRTthFwmSEfDAhw=;
 b=64IXFmUg2VveMuqLjbn9i7qwNPt1EejsJDYTe3JlpxUWb5ZbSTuVFgcpoyH4bo1CprNNdbXO6
 tXmVM5kgSUoB79yXLpnYbnw0kcRJ4w7+HeyFc+dzbMOskoQrLATN4xG
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Proofpoint-GUID: jLbNAVp0opRkZJTv705-S1i6z3O_HnA8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAwOSBTYWx0ZWRfXwzYyKL/K2bzU
 7j+oj/sHXh+oVj9h9Xs1Hdv0rYeLuduX4XtEN5RNCxtwy0zRN+wb457lmWZ9gWt2Kt3XAMFnJTo
 GUxpC8Ms/OVr6m5KLK+1jCTKcGDxIe6RSmhWXtxPweVqimTm01VO/w/4uyDVNaHf2JHSXhuONFW
 z5c7ZFIsHAamAfO5ZO4b0LinjiKd3UTwiwLzAl9oJXyuZaS7Ykmq7iAJEa9qKqZFZS/GabMJRzj
 /N5wRk9me+mzq4h2OoeJQ00DzICLWYxbjn2Q/wEWRbymYklt72PPhpBFvassvyKnMsp7wUS278R
 ThIGFILMZb9Xx1Cq9CZYfDYVXKuaLlRmApm9NRm8kdeGHSfhwf4sVhXRs7oCAXbJJMnk6hwCF5X
 Yl+2CO7T
X-Proofpoint-ORIG-GUID: jLbNAVp0opRkZJTv705-S1i6z3O_HnA8
X-Authority-Analysis: v=2.4 cv=NsLRc9dJ c=1 sm=1 tr=0 ts=6895e9b7 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=EUspDBNiAAAA:8 a=IjtafaaC1MEc7PSuPL8A:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508060009
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4564818000F
X-Stat-Signature: upn7gipz1j4zgkfhbdbqs7hys1ea6idd
X-Rspam-User: 
X-HE-Tag: 1754655160-624264
X-HE-Meta: U2FsdGVkX19nZS6Gt6PwypyfcZ+r72zALH/+RYw25JAMsNJims4d/ayciN7AObqipwtCG5dRMgHBfqpAWeocTVC2YXLET2Dy3MpIyNF1RYJgdB5z4GCQepanoaAVbJv7Zwy2ChKTSwSxs5qWg7S0aUlBOLpgLVS9/BcaZAiHwOkyToYG79R1QTnSTkvgagUFDbbmIKDAFxzXtO7JMrVmGDnPdmVZKzvYahImYFp2bEzq82kIxZt3snAGzNUckXmPV+lVZvx0l6yF5Nlj6/26Fz0HvI4MtMT2+B7IM0fSGc1Eb3c+Ltc2L2ECsahV1Wz/ovD6q0l6HLjbYM/o2KlRq2CWHd5GXXcKbk9T7fssed37yeWC6flO6GVNAKqwJPmGyzxui/jxUW+KaJcerHO0Q/48xlRFKoB+kqyoVMKzf1EGcG0el11WhC25Wk9/vMZg8z8YcVifSLzz63bS6yraS7qJXYpOlOAp3D7CsWeSeLhOZQRrSRHBpEZ4yb9PhA18kXyht9vfLdAHAs5Dhib8yHPJMccyvas6nvrU6e+SEQnvYBn3INrS1qccI8wxc91VFbihx6uEgKELYsACoMBsnkKzmHvZ6b8u+GNJTvktxlF8eu6K/q5Fl7mxmEbducPUDkfhoF07ZeXVQXb7UPu5dDxFZ5TzCriXCO1EIdmVE8bk6qKMx0d9OPzInvWwsOVSWl7Nfc06AEzbwmzH4NJ5BQry2ujwh152aZ4V43dxA2YnMC6oeHrf62QagXf0q8TMl7c/Wx4c1uvV5c/q6ueUUWXP2bfXkACztbTiVjgkYaPwpt0XOKLtVBw3O+JpzVMXvbXpLiYBdAOpMFU+DtFjpKAyN/0DzMdIvLEY4T9ITHkgkiskwGq7KbeSrdYyUKCX7I2a9144XEtciIxYvGSGL7lSpHJVy40MkH5n+9OnRDHsXxihILwAfl+ZqILjZUz4YuP/T1G1s6G86rMAYOO
 m6xxGUQm
 qLwJ/lRvD0RYTZ5zHkrxWMiyqL+rkMrf55SgYWup7C2+nLi06vGsg7vajQeh5RpYZtBxt3lGr111AXGnX73fZ43XoKDUTFv8y229/lVgB/CI9H0W7UyRMBgsheqQIeBRqf6vm0WMLqZAoKbn0s6bLBLIn/Ajpr76NAhO6c9hfXrpGiyyE0XKrZtRwTf37iSuKOxI6Vmd0h1tYpkAvyMGoW/gEhISzBQNjb2E6s8DG7pZh6iJG9Z/deq/XQuO62Sadd8HjT1hcQMGmIIpGOeoGYIymCGIFfyUlmxVlc4KihMerDVOx62/S7O1ELtnzApb9aL5piJ1QdZvdndeFJNvs4TUVMcWSHqAsYQAUO330qbfljglSzRnjirSiELweMHtwqsguNSY9xTcKAbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) to
align with the consistent `pr_*` API usage within the file.

Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
---
 mm/numa_memblks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 541a99c4071a67e5b0ef66f4136dee268a880003..de626525a87c3ed54d31695e86f18c980c084558 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -76,7 +76,7 @@ static int __init numa_alloc_distance(void)
 		for (j = 0; j < cnt; j++)
 			numa_distance[i * cnt + j] = i == j ?
 				LOCAL_DISTANCE : REMOTE_DISTANCE;
-	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
+	pr_debug("NUMA: Initialized distance table, cnt=%d\n", cnt);
 
 	return 0;
 }

---
base-commit: 479058002c32b77acac43e883b92174e22c4be2d
change-id: 20250808-numa-dbg-62a8b2092c56

Best regards,
-- 
Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>


