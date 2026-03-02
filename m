Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C30FE9B36A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833846B008A; Mon,  2 Mar 2026 06:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8000C6B008C; Mon,  2 Mar 2026 06:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5556B0092; Mon,  2 Mar 2026 06:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3496B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:18:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E61B160C4A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:06 +0000 (UTC)
X-FDA: 84500873772.24.DA789E8
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD389100015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=oa59O0vF;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=A7ymT+hY;
	spf=pass (imf05.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5q/hINUJXjBL3eVDeinCAxrmv1WwAgppapGU7zlyf5Y=;
	b=G/XKwtbvxpAUVMBQnrfw4bRt8JflN/R7TzeL8bNIkro8K5kaw7s/VBFPqSG3blx6SADhpQ
	WBtNySTQ0vMjkmH8qK05EXflOipeqlxPwnC32uO2lfqIB0n5Do5/CAVxYS0AWC+7qJ2sME
	4AGuhk1bKxE+r/0yK5SwXSlPegw3Mt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772450283; a=rsa-sha256;
	cv=none;
	b=okkG5c6HcSCbxbTZw1QcJYGtqDDm+3tbsB2AqkUqsCBFJGfWw8GcLm3aMCScmXKek4rIBU
	YPhR+jvC7ifsaz3DoOKFz7sz9ei+hdjSbvw7jH3fkwkgux2OHlkI2F8rleD955jX4bhTbI
	VmYGcdAJ1YZ5yL3gbQ2+bmQ76RUveHI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=oa59O0vF;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=A7ymT+hY;
	spf=pass (imf05.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6226h9l82504594
	for <linux-mm@kvack.org>; Mon, 2 Mar 2026 11:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=5q/hINUJXjB
	L3eVDeinCAxrmv1WwAgppapGU7zlyf5Y=; b=oa59O0vFv/WQU338Lx4dq+BNaOT
	MiSA/QVro7cxbv7wqwQdKu2XDycslEPuyxrSHBUHCBuAta64YXZlSZTN7vhhlZBn
	EMgQZTr2YwwZGmepL3qezrqfW8oRJzZnOO6qrRB330VhcrzVfkcijALBKqAq13lu
	aGeWEPRIhQ6EjiGk7TFY/eMSR4HmMurUC/vbPDG3NHiKliPSAw9j8bL7uWUtg/xB
	mbuc5H3AgLa93XlgXhOlpU9EK0qifbq9CrmP1d9Er8oT8XIWNZkL6HzUh6GJTE1r
	Xvr2hAKhIg9OSjh4Qv/f95wGxSsEfhdlaThO90k0xwoh0+QaZ+AivjUxrZw==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn5hes08j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:18:02 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-464a0af43deso20347612b6e.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772450282; x=1773055082; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5q/hINUJXjBL3eVDeinCAxrmv1WwAgppapGU7zlyf5Y=;
        b=A7ymT+hYe1t27G73D5DNo8pQM3xCkElBJ3AnDJGXYpjStc/tBqVp2WhDl98qpE0x+B
         S5tyqnsftcr+ZBm9Q9Da75GApOmjcV3xFN4FvIAolniw3QtqdaXuHToOpy0ijQaQ+N3v
         d1lHpeQFAyJ6+K3z+btY8efY99w5rw1ucFjZjPWVQryaSI7MOn5B/y6+m7VS6POYNnfU
         GytdMpUHTqJHcevTRVwFgBEN9v0a3rHMhgTZYb7p2QaX7RjC+qWYDFZt+WgpsKZEeDuU
         FJZAF9b0bMswmOY0Hf5JyJOW5BGPVxjWGYnR8+eOBsLrxAb9tN9WqK77sQpmPTx3+WnR
         62Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450282; x=1773055082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5q/hINUJXjBL3eVDeinCAxrmv1WwAgppapGU7zlyf5Y=;
        b=Y3ZSHQggeORq/aN4CvvzBkqhWmR09MGieGJpKgiPzwVCYJ32FnqbyZWLfvY0ZKZLv0
         X3XWiOS92D3IGY8L2IVwHeuJvr8JBO5dau+xqONuuBeTw1ga8GZ+bcS11QUYuh89pROh
         jwo6u1ieoy1Ih9aaME0EIgzKPw4AN0cE2qlLc2BSEcWaDOEnl1jF6bUbqwDbtlanZeaJ
         tq7rrMe4xz+LfYqR/ZL6V/kCMLxiiiP0CHHVkfuSduqNFQarCPsyxWsf731t7ZutuOYt
         ms4vq7ZUwjs/Je405PH9l5p4qBE0AekImOQ4lPoTSt++Fng3il9Z4PaPXOYmyK9D2lN4
         YaNA==
X-Gm-Message-State: AOJu0YyY5qThXon5uMVLlIHT3ApeWBm+3wETVpcGgdym6doAUZXXNEuG
	cfQ+Sucy5AqWrZooPBmgrjPMw6+XBAam1jJRfYrD6rwE8Bm7fvUb3EenL+ej8Z0y5D7GHa+lIYx
	Dd1vmGidZ0kosRkYM85Rb9HC86wEczBJFiFElWf9QPM9pPwrXvxMhEw==
X-Gm-Gg: ATEYQzxzwqIR14Vekk3BDz1N1EnRITBJiiq9Adctcz0jF/tvneP0+J0E0f6UUOhqJsa
	hYhUXQ96I2xHGFgpUahRwknBW/4OZQV8jWmMiL5yIzA4i5NJSQkpJ0PAjN7Og7j6NSIxASq9/FO
	7W/bidLaVo5sN9mfcGKKdr74QvgPKGH4fP5OxMOTEKXL9+UBMizpynWvGMi+80TgIE6sr8KN8qM
	ZDlzbyUG3jGtkBqu6h/UVTvBtwHbadUnlq1+poS+xIIpX/ozFbCpvjW99UazIStHSX6+SKqRQkK
	voRGDB6MlIqGNID2LU7IHvtdTs1f2YQeI0QuvfL02Yqk5qLnWQj1c+7Zz+cq09MZLyx1sTeoxyn
	OMtQLHkafHNMrLEQVg3C4j/5SWLolGyb9U/TGj7dlKP8hviqHFRzcR3KLi3JsdGatKTo7zmtIV4
	Q4vPjU
X-Received: by 2002:a05:6808:1b0a:b0:459:9630:3742 with SMTP id 5614622812f47-464be9b7765mr5628527b6e.22.1772450281746;
        Mon, 02 Mar 2026 03:18:01 -0800 (PST)
X-Received: by 2002:a05:6808:1b0a:b0:459:9630:3742 with SMTP id 5614622812f47-464be9b7765mr5628511b6e.22.1772450281324;
        Mon, 02 Mar 2026 03:18:01 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm7354528b6e.10.2026.03.02.03.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:18:00 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org, mst@redhat.com, david@kernel.org,
        jasowang@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
Subject: [PATCH v2 1/4] mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
Date: Mon,  2 Mar 2026 03:17:54 -0800
Message-Id: <20260302111757.2191056-2-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=BI++bVQG c=1 sm=1 tr=0 ts=69a571ea cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=DkB-CqvKoiMeaEFB2csA:9 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-GUID: Ln8UwMEBvSpO86pvdnJS2_OSKSCJDwvV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MyBTYWx0ZWRfX2W0kldFzHZjW
 kHPkfL1H7jiO0+Me7sLeX8tUFNl3By+v57xYcWyFeVb5zT59taaLwASGevhSZwxdla/8d+p1MZP
 CiSzzQeDt/rBSiMQ2iZOEelUsSpVXdoXMLXB3LXiL4S9Wjw8iD3xD2wroFZg/+QMWAZT54hu2OQ
 GqCfkAaPy/QHs2vEhIUsXEN9r41Q+niMuOdkPmASiWtBmCxDj/FR0CX4TyRpsRQFRlEhqO+ud4O
 EycNCYNyNMPa95X/PYrpK6qgEX3VylairlZaJaB1TwTIWIG0xXODp35Kqq8kg4Y1IrMG3Yrd0Qo
 mdtwW6u99HSj3MaMaCAoxZ35v1GiB7tvWovWtgV+/JiClOZc1JyyhuuNC+as1x9wECmllC6eTZ4
 X/jjKkDW8ZIxQ01rPj8KjPRfOk7yUb3+GRmTrqnTEKxnuLDnVa56cFK6IKGVYC9f1QIDoecQHj1
 pPm8RHSskfjddSS2s8w==
X-Proofpoint-ORIG-GUID: Ln8UwMEBvSpO86pvdnJS2_OSKSCJDwvV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020093
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD389100015
X-Stat-Signature: cadpd38dxwz3htkjcbe1gmw7k8nong8q
X-HE-Tag: 1772450283-13071
X-HE-Meta: U2FsdGVkX18Atp3V7qthxgW7uYTu0Ve9hu8VuYasqR1OF652FgcM+Op8ZXuFOTRjy205X5ymk+gmOzFmgWSKnoBCHMAvgNuNcylaHeE1Ib84Q30yqXjQBNzGlebWVoNSddLZwnGvTpk7pA8t/dSwpsfYupYCeJyGBht/iQpv/erv9lsya+acjeGivnHZK3SamWqkiwhXwTaWGCR29Ry0z1HlCegLWAP5ZwxHpZoBPVcZQ2IkJpYxbowCChxA9JG1gMVBcZyZDln4UM4Tcd5pQdtiglrbRwkhnkeT81oyJUvqUzb81yxTIp4LmxGExWonWDMb/pRmAWLSr/GuYNsAWfZFMHkHbZ9p/gAbyi3Cg99xzA0exm1RNaapJCy5/QLE/WxorA1rFcOmo+dkK4PDhqzJffi337PXF4rZWxl5uiTuA8DLp+fmMYgLinrpK1FMUVLp3K4lunncATC3EgFE2+3UnTPfnSi6+fBw0hGTys60GkJzpCPOs+tOO5sUOs16wZkgNldLIBcsTi90gR4cJ1VvqmgP54AmkWP7S0FnVjIvd4c5YcXh5a5ysXk4v8ei/TXEC0VVKhs1sZGzT8CpcYSvbNsnqUwSCOLzmT7KJCeEtn3jO7ydnaSYfwqzlAt7cMJ+a82xkPWDFdyHTs4Wr5ryg8WbFQNztxlSAHuCxs3iDI6mkun6CeUOXNIspdu0nht1udeYiMYjJlQAxErl3LD2AUw1FFRZJZtOnB3/GzpZXfdIXz0FXM3RAzvsB+HRvi6a3fksCLXqH9p3JLRNvJ/pWQ4ffenH+WWbZQ3s8MwHgi97kTPKAMt/mYcmm+7XNW0jZSPKiH2MAYFN8AjqPPHuHNuej2G889y0r6ZGtD/h0EHFaFVA63k+6fM/yZ5WZvnkFT61whlD0JP1MiWUhUhQMnVCghorFhFHIrVE0K1LiFfI9ollJkMsd4V4+8PR+K97IerAS5sNWgIfxKo
 OlE0IMPP
 6l+8PNhseQ/pa/dPjYq04cuhYrFF+6vnlQ42nd/ievWA32rM/cQ9dpOoKCbb0imsMIRof9phXadDP776zSzWJ2dw9KhtP4UeTR6KEwYUY/AfULbAcjb8l20OiO+fg6QhNbnWHqPGknDd29pwkBgapKzfDgTiFWVp1zNmmamOvreRaNQgyWzTrkkEF8pyHISyEKK5eMjjFrkop/1NQ0WigdBEHlLHOMpb62jKH5naPpZFbyjiBbVKKdUvE/grbSh5y5r+H5tRcwV3J8fJnBtMGjG2vq+YDaX9pjumvDivVx/006aG1T45ccWpPM3qJNu1Cdo+5f6+KbTHHeet+7hUngXYSgU0t394voPuNW+1P8I26xeVNOGN2vhqBdwtP67M3V/h7UAJgsVIQZhpFY6VrMatvAZy4AvCU/EaF7hLkg71+h5xI3CiE0T5zur9w7CMAF7XTHbN0zcAGZzl8qRmM6go9MA/2XdZZVde6u/87LSJ+j1QQzOYLVr8n3rfpJkPBAZ33CZT9QMPHndsch/abkBt07A4eXUw/DArbYFJCecNzO593DsXXRqRbktMfN0ea+SRSifto0TS9XMIWqXzWksZx3qhv9MZg9M37
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drivers can pass order of pages to be reported while
registering itself. Today, this is a magic number, 0.

Label this with PAGE_REPORTING_ORDER_UNSPECIFIED and
check for it when the driver is being registered.

This macro will be used in relevant drivers next.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 include/linux/page_reporting.h |  1 +
 mm/page_reporting.c            | 14 +++++---------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3..d1886c657 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -7,6 +7,7 @@
 
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
+#define PAGE_REPORTING_ORDER_UNSPECIFIED	0
 
 struct page_reporting_dev_info {
 	/* function that alters pages to make them "reported" */
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index e4c428e61..51cd88faf 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -12,7 +12,7 @@
 #include "internal.h"
 
 /* Initialize to an unsupported value */
-unsigned int page_reporting_order = -1;
+unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
 static int page_order_update_notify(const char *val, const struct kernel_param *kp)
 {
@@ -25,12 +25,7 @@ static int page_order_update_notify(const char *val, const struct kernel_param *
 
 static const struct kernel_param_ops page_reporting_param_ops = {
 	.set = &page_order_update_notify,
-	/*
-	 * For the get op, use param_get_int instead of param_get_uint.
-	 * This is to make sure that when unset the initialized value of
-	 * -1 is shown correctly
-	 */
-	.get = &param_get_int,
+	.get = &param_get_uint,
 };
 
 module_param_cb(page_reporting_order, &page_reporting_param_ops,
@@ -369,8 +364,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	 * pageblock_order.
 	 */
 
-	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+	if (page_reporting_order == PAGE_REPORTING_ORDER_UNSPECIFIED) {
+		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
+			prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
-- 
2.34.1


