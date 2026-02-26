Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08645FC5901
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694106B0092; Thu, 26 Feb 2026 02:01:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651C66B0093; Thu, 26 Feb 2026 02:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A516B0095; Thu, 26 Feb 2026 02:01:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B44D6B0092
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:01:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5CF21B7626
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:44 +0000 (UTC)
X-FDA: 84485712528.30.56FF6AF
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F1DD180004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=T9ooljO9;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=aEW7TQmQ;
	spf=pass (imf24.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6H0aClJ1xZtNoAwOJV81SP1JJ5tvKzYZ+QjZdAOzHLY=;
	b=Nookea6qIXHVBl1jriHjeuxdNgeYdTiBuVG9btCkN1edxqyDauurtdtALyDFlro2PUY8/b
	QMwxfPrs9hyC8V2I1Bm7mj6KJ0Ydjp7kUIAHrPZYn7ygxztQUHInpWKs693etCBT0F2BXO
	ZdZpP44VUjFxHt4RpIVL9vhxsH3Q0H4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=T9ooljO9;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=aEW7TQmQ;
	spf=pass (imf24.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089302; a=rsa-sha256;
	cv=none;
	b=6mz2s/ZGBtRez1aB0H2VmlxSBENo/0ACl80BdqG7jxqerSRGgLHJl7MeB2AMoJxKFZzlw9
	+1Ek4Q5vvKd7R+SXEXYl5Z7ftBk7lHWpWnhU9z0m0z18MW3Y+fm4HDipIvXhSEimWGcENp
	wlX32Fl3x8Cu+K6dn62l0Bif3SIc8OU=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q4V7Kg350077
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=6H0aClJ1xZt
	NoAwOJV81SP1JJ5tvKzYZ+QjZdAOzHLY=; b=T9ooljO9Kk1qnZracN1UJbAAvMq
	VxO74DKciFOW6Sg/H/ULiE5D2SQ0Y3bDZANp42lDFtUq9pYWcIBz8fgDcSidCyuT
	Rgq2k3zjKiPD+4bxX6U+UbuSlfJxXfXbIy7pjhJaMIf9+XW0PJ5+pyAQdch2Dxth
	rZXJkLHOT8cSMXQjD5EaRVm+gpsWv6hshSkdudyuju7DQQntNHNU7FISHbSv8IMX
	T3c1qI9rqzPfNbolx4GtJ47AGeayRFXFhQQPXEjtHYpn8ZFT+GQY0bd+NU4B4vY4
	oEA6l8CO1gwZ/VL4gg5FftQ58yikFq0hCKHqUvKUNAUKVmMiUETTBdaWFTg==
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cj54pa5wf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:41 +0000 (GMT)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67999892f00so13653557eaf.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772089300; x=1772694100; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6H0aClJ1xZtNoAwOJV81SP1JJ5tvKzYZ+QjZdAOzHLY=;
        b=aEW7TQmQL/k+cAjmwqAUsaupWKMjna6/2zYBMAfmL/CPPwxpX3At+VJeeA0w12cUcl
         dCMrojEDGdkGhymxyTVGbVRQf8rEt1tWG2RdUzIrQDfowZ2qOleNCX2HPZCRMmz2+2Vg
         YKmcTyWh6MPe3c2eqQY0A4BNc8TIb20oa6vUdnMqMsoR+OWJ7yGhjkd4HSIFS1uipKfH
         tHW5bReLkd3dd53GvfuwPSXx+VDXlIPgKLvEXDg2M4oh1HJjXKoct03KStbLFm9itXxn
         /Y2D+PTwBWZVS4q6JPqcNCGHejDEgq240CIkfuJ7fDHCRZ7EtRmLEZ3TiTL5gpj+rJtY
         2gwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089300; x=1772694100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6H0aClJ1xZtNoAwOJV81SP1JJ5tvKzYZ+QjZdAOzHLY=;
        b=v3SD7/WVZjjx92VLoPFusE470KmGHxIdsQitVQB3eETb6PxYT8WspHmfWCY8SWew9U
         zkRsx/akLFnDtcYpV33kgSIV4Kh0CJwvg7mWlYHGfRkOwlUdIzPakBglb5Bs2ZQ8RjTq
         aj/3rSZ65vgVwQGDf3KkZ0/PYA4lSGd+k0+//vd+cFG/2+WuWyAFyJ7LUZZZlEuH3zxK
         Hcz8kzoC8KreA5UCWwFQ0VBPSXe0KMe5d1iqOTN8eDVepNtwRQyo98UC9ByQvB6ylcs1
         GNtLTh6ele+ENrcsTv8+tIA7VxxEbjd5bJS69tXkKUSQsh7E4N/C7a/svzsnqHDQ9qVB
         0IPw==
X-Forwarded-Encrypted: i=1; AJvYcCVeFyukHEEPj4FElz8HOSxDsjRtY02zXWt79r1kQgqHKsnVOMMNf+TwvPH8EqobveVs0+dRHxoK1w==@kvack.org
X-Gm-Message-State: AOJu0Yx/I3AUSGde2Ekex1wRZW/89JqR+km1GPQYm21k9X0HywqQc6lj
	JSYGilsVwkDoson8ty3o/WSJBbs/b88aV6U2i4m0FrZM86ZXdcSHZ/BLvEOTvyqaCm3vrLkGFht
	2k8XTNxLbjIRwk0/mUFrIA78hQ5Ch8WhHQ9VTHPKCC6bz/EHMNp0R5A==
X-Gm-Gg: ATEYQzxGSNbeiNI/KAml7sbu7Th42pzqr4y2ORN+mCcHSwqnZ4IfmJmaSoHzY8WJfRp
	UmnNv5Hzk+ia/AnMF0Xr+4OvKzuVDTEfQTIbZPeZ1P9zC5Uw9+MLvE3dnch1YXjEvMlwgS1QO8L
	wU54IR1X2dA0RVta/eP5JEDRUwqJb1Dd2NuskrT+pj5EvGOgFNOKdzfHV59kQxHxiyjPYOIc/Ng
	cop28GKakHg/TcZuM6RmpTlOGyhGXdDqbIwJJk6HVMyGpc20V0BZwUEQBpsxQZZLw5m5Qxbd/9A
	GWjOedz6KwVxIR5XkC2qxh+5wryKUTuw8nWJZLMcn7dX4QOIVB7D429q1x58wa2ekFrVBkHlxbV
	5XGDzHCpxYPTvuXW2ih8GqNgycuTVb+ISFuqSlQkX3MFB+z/UCC67lWR9nYUJmep6L8euhO8rVz
	45IRaz
X-Received: by 2002:a4a:e842:0:b0:679:7d2b:4362 with SMTP id 006d021491bc7-679ef9653d4mr1803455eaf.48.1772089300517;
        Wed, 25 Feb 2026 23:01:40 -0800 (PST)
X-Received: by 2002:a4a:e842:0:b0:679:7d2b:4362 with SMTP id 006d021491bc7-679ef9653d4mr1803232eaf.48.1772089291548;
        Wed, 25 Feb 2026 23:01:31 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm1013246eaf.7.2026.02.25.23.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 23:01:31 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org, mst@redhat.com, david@kernel.org
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] hv_balloon: Change default page reporting order
Date: Wed, 25 Feb 2026 23:01:24 -0800
Message-Id: <20260226070125.3732265-3-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA2MSBTYWx0ZWRfXyF++ArrblabG
 v/WXmTJnIbXyijr7UOh2eET+VH0cDPHjMaFINLLgg9ILCStEYWaYuR4hFVn8g4LWyirTqhR5A4E
 /sUkZp3tbyjnjh/zYZGChNOEspjS7TsZoCH/Vc027a27AscWTxSu856geQbhtRsSmRl4EO8vM2s
 vTgAf0/vMr14uKc7PRKL0re0bk0RRpwQDawZYna3ABMk9KTKgdEa5Uuyi8g8q/hY0I/Or4m+YUH
 S1lLxkoV+nHHVM4UortEh4wQuIvmQdiPrsvmsVSnIkuMU6i5Z4D4l8XTUi7bHj0D5xEuQzb9WuT
 JvAuGP2Sc9ekfNR655ybyp1+4rKYUJBKLHbDEKUYPLogxVGamq9I+oWUAcbRHT2y18miUk4Wt6m
 Rvg+YUIXEI4y24+NfF6hmaCisHKv4RCsNOZyVdCZjGuBbwUIzNhZq/V3bLNI6hKyS7EaENUAhQ8
 ZYLUCCjwMcDUMAue14Q==
X-Proofpoint-GUID: mwC1UEQRxlpWcuprm4lZxAB9LhKdLHXu
X-Authority-Analysis: v=2.4 cv=I5Bohdgg c=1 sm=1 tr=0 ts=699fefd5 cx=c_pps
 a=lVi5GcDxkcJcfCmEjVJoaw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=IMYoWy77fT7TwZj6-SAA:9 a=rBiNkAWo9uy_4UTK5NWh:22
X-Proofpoint-ORIG-GUID: mwC1UEQRxlpWcuprm4lZxAB9LhKdLHXu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602260061
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F1DD180004
X-Rspamd-Server: rspam02
X-Stat-Signature: wxfxbmji1b5k4jbmtnoznctonjqetx4h
X-HE-Tag: 1772089301-615356
X-HE-Meta: U2FsdGVkX1+vnn0waqlzlxEaZSRa4D+mtcQLpDXCvjsOzBilXwob5KUir+Zcb5yO2hHD8/GkiiVEdhWIO9fQvt218QP7P4/wT4mqBJSCKne3BOvCPWtyue3aoHb3C1Ra4IhiwBd00f5UNqd2oEwcTEwBJ2y4k6vi9TULgrfGD+jxBioqsaDFrYM3dV/s97FPivYTX14szH32eau/Z4RQDH+MetKHgx4uH3epERT1eN6xc4MJMCVpAORVpeJ/87BeIOjxLhRKWuj3d29g70o9ivJI25iGwu6i+edEMdIgVKs16xqS0lCbvErriEFBcMiGF4VHRgDB7tp5Xw7476bH/DmufYj6vjKlg/wd9b7QNVWPALH5sfUy+vw8qkaE0/CoXzOeaEqDjsU2oknGP4ZkDGA2FcYg/eZIFcIjUlLxlj8UsG93tBuXZbKU5Aq90T5EuVX5y0T61mMdIDMrEAm9iHh2ulxFAfVu7Vi+e9Emdr12azIBhK+lgdVXaUtTTvcluHl9U62WULO8H5gKt+2OcB2Ay9H2okGP04RrkDmP+l4pDFnBIfEvxWS9EWkSfcqfaUy+HKbZ0RGVf/dayxNXVjs5arX17yHg8d7m9P7Vh5RlKBpvKqHwS1EY7G4YRtUvdoVz6dYUTP/DVvT9UPw4N6ohkOIQySn8OZPYckOB5NTGJOfmC+LchhMsyg0M76+W5Dxde/3G5q7i71lA1z+CTIrzZIaYHDRBGB2upk7xThqf6SUwB8qGmTpJbkcaqE3onMbRZPNnzk41DukeCgnpW30e1MuXgKwOn6ccwg8V5xbQnwv9mFBBUXxH8bbBNGkqjmVWvfhKBByeUc/JB8qDgpGUnyGYp/PRlsnJSCG1WjivEu+y/HwxQ5SOZVof+vEF9ORE51bEfmfh0siPdTgdaFAxpZbdOjkE+C9ChGtkO2gFOnTAjrtiFZ226sgPqC70mVNyqknzV8fO7I1LfM1
 s8B9YN8h
 6Y0sN98kl9KezuDGyb5esjM+MSgQuG1WqI0daa04jGo7mzZxNEhbspvGDzygClsv7e0+cmKxy+P1v2NME1xoHRYkxwi9IdnS5vBZxyJRMHjtbbwjSsJ0Oamz5i4kwhLWNgzClFw5E8UE9mRRgstfrPh9rhXTlVN8Vf7tDrxvxpCht8pOxQO0qx8EXnk7qn2uJYNkno9363AbvBybAr2NRQP8H9PtPz49IUUuLiq+/hdepUvROmNOK41qmACb4XHSosBcHXVUJbkk6XcZjhjca9G3q7765icCWQyoxyq7RNQeBzlZJgbs4vIMZlBv6hKpQrtEFyi9ZhhOtsA7edydJsiAokDUB5ZEN2u/Cw531H6l5xZUJ+xoeUPjZaEcmTjRd4zMejjs5IGNk+4+SC8Tp8B20iU7XRNpgzKNAmkH5rmQqHlodQq3ZNB4B3Rwz2Xc5zh9qUHnSqJvgqGRcX2+51mdZvGy/3osJa9BBhBqVOh/JqKKsLT5LdAtwuUSFGR5ODGtn/eC4mEbgn/9K5AUydNzFpynvsGZUwAPvNNF5Z0aCL86R6Fd645gmRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_reporting_order used to fall back to default
value (passed as parameter or MAX_PAGE_ORDER) if
the driver wishes to not provide it.

The way the driver used to do this was by passing
the order as zero.

Now that zero is a valid order that can be passed by
a driver to page reporting, we use -1 to signal
default value to be used.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 drivers/hv/hv_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 2b4080e51..e33d6e3b2 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1663,7 +1663,7 @@ static void enable_page_reporting(void)
 	 * We let the page_reporting_order parameter decide the order
 	 * in the page_reporting code
 	 */
-	dm_device.pr_dev_info.order = 0;
+	dm_device.pr_dev_info.order = -1;
 	ret = page_reporting_register(&dm_device.pr_dev_info);
 	if (ret < 0) {
 		dm_device.pr_dev_info.report = NULL;
-- 
2.34.1


