Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D21E9B36A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8054A6B0093; Mon,  2 Mar 2026 06:18:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DB66B0095; Mon,  2 Mar 2026 06:18:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615926B0096; Mon,  2 Mar 2026 06:18:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5112F6B0093
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:18:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEA66C356F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:11 +0000 (UTC)
X-FDA: 84500873982.13.D16E28E
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E3B1100006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=e7dupRXg;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=JAsuVGm2;
	spf=pass (imf14.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SaV6NeFszmMR6mTHDZ6hjb5x1BYzXavRsIhe+Tko7A=;
	b=qNTLuHluGnyqFNyz2tDl8Ebm3zTOv4qbmEYbLHNTxJz2aBVvCiH4f1liXlcsftqMLuxWkd
	5LbG1TOtliUhmunwOxn7T0qYEftQcHuXTJcEu2Oo7A44VYyrGQA1j3CA9sPK+udCHQRpCA
	vir7iIFgCRG59bxuqixSgjd6PsoTaEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772450289; a=rsa-sha256;
	cv=none;
	b=UQrPXdH1fnrVpWt6Q1PROrWWMeiqdnerjLwfGB9aFji0112Ole/ojdXiL18wr0CjDzTmIo
	V/QkFILLee8/bCnkkZfD9LtJ/hNyk/84Ypg0UYW4MV8ykovsLZSOiGAdNfQweIctFYX1CS
	03fDro0w5Sy5Jat8o3oonsy8RalmS/I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=e7dupRXg;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=JAsuVGm2;
	spf=pass (imf14.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6226h90f2504590
	for <linux-mm@kvack.org>; Mon, 2 Mar 2026 11:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=9SaV6NeFszm
	MR6mTHDZ6hjb5x1BYzXavRsIhe+Tko7A=; b=e7dupRXgFjWwN5RgK14fr25qfiE
	ViK+0pp8NQ9Biv6jQfqP03nbbdCBZ23zvXjZZhkSR4P9uuO48s6zwScjChTDoVqN
	cMvhLgEAXeZJE1335THfZvZr9Ic2qSLVrn0RUtuY6CJPhzf1kXzypUmxtVWZy7s6
	Z3Wf1Bxn/rmgK5d08iU//gLwYHSspodfSQeNQv4NC6ruBmIWeKicTQhXMWzNfWoz
	DhfL87Qiiha++Ya4rGDPV3tJW4E+7HrBDSWa6jdr+Yz/fhAg9hjonXDjpkXXZeXc
	esfCSegwQCW3rwELNNkw1Hz04rl1NXOBZ1UqDgpRG+Rh6hbG6A/BguFy7Qg==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn5hes08y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:18:07 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4639c5de2b5so52329872b6e.2
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772450287; x=1773055087; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SaV6NeFszmMR6mTHDZ6hjb5x1BYzXavRsIhe+Tko7A=;
        b=JAsuVGm2W51qZMtWT5nMU4NKfpcJY0S3cywC2PjrIsaZk+Q+Er3++B3rp42JggzK1C
         P1jWvzOK6H0iiz48dNSsp4TdQglWIOFospwNvkbCKntg2ATy9piDBsI8fyh5AlKCHIk4
         gEut7kl4fVQS71VjgQYAOO2pRntz5i6GFF0pW0t2h1HfdAL4xRzLu7drz8DDJQy+A7zH
         n14smZnRfPTYZ37DP4zEl3VwramACeKpEf0jNDVjWpXuLwN6x+mQmvyyYn2+e4c7fH+z
         In31aB0ycaJeZRxYRl2vbfXJ8FcTCLqyoE9V5OYeFtCwliO398BWQMWCHPq0gjFRquM6
         rLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450287; x=1773055087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9SaV6NeFszmMR6mTHDZ6hjb5x1BYzXavRsIhe+Tko7A=;
        b=chW6Ir9KB7ryl3P1UpSCAcKx/J3o786OvCO0GAEhgL+RCkC8Xh/96S7fHxv+MzZPG8
         2H+4FMaEwiPn8LeALTFGTaV9emWhKA/4IpcWdJoCRxoX1/sY0aCNMKSJ0gOsHZrPvw/s
         /wgSeIvCPsyO7vjo4zZfAVMMe1A8NNZeH7H6G0e/6wToNImvvTG/QQMDiN4zmK5SIs1q
         e2uN8BuNnmveWrrjJCkSE07hEatS9NneVmdFLoOWUQ64TgX774zRkscVPS7l1jQJ3iRt
         2wBFU53mbtszQEvWG7chSc8UTaD9vy0Oxiel1GMYvYtbw0HkB3un2jAp0gdv/lInk+PF
         9JVw==
X-Gm-Message-State: AOJu0YzHcpPlmA0UmbG3SPg9FMyZRB29SawRd3uj+A0jXqCBIelRQWDA
	k9Su+qrLDCqa+djHZZFemv24mzpj0tzeo2oV0+aUzTCQ31jlh0gvK/GmCUTQhq/Pc+arAJ23k7l
	1Fnm+BBsNA49g1RR4GxIrvHcqNCgicUJX6FhIXHFLt0xBc9kUWFxtVA==
X-Gm-Gg: ATEYQzzPcR2X0XeZwvonOum5HvzSMi4n2k7CAf1lGgFLXtCC8OvkFOApwUZzBcr7EIo
	saZcfwNoLQ7DItCZxgeALs9zx8hNawEiopU4/pHQFuQh39izlmwkbW7yhBUNruHF8Ibh7RK/lc1
	1VNk1xffF/tAft+hWMHCbCiUUafpEgFJmxiJic4vIbrJtCBjmeeWtc+5hY9Vw9/daiO+JYIRGdN
	woONDv4dgbdES5mJ3IP4+K40SHDTn/7V4TLW6pMicKJnZ8po+OXDMThMDsKfrD0B/EKip18POLp
	RKgTPyVy4YGGE/lIU5JqRmxJlMw6PeFmvUisa2nxoz2qGHmnygxYWGEJQVLUkiuFIeQGAYylsZr
	2SQb7RpPZR+Ee50S3PbduqssPnZ+1tsx/SG79I0Qy8O1Q3mm8qX/LjaIOgxOAlpH+inmDgpfcYn
	R7cLuM
X-Received: by 2002:a05:6808:1a29:b0:463:a32f:ed4b with SMTP id 5614622812f47-464be9c74e5mr5728056b6e.22.1772450287116;
        Mon, 02 Mar 2026 03:18:07 -0800 (PST)
X-Received: by 2002:a05:6808:1a29:b0:463:a32f:ed4b with SMTP id 5614622812f47-464be9c74e5mr5728038b6e.22.1772450286733;
        Mon, 02 Mar 2026 03:18:06 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm7354528b6e.10.2026.03.02.03.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:18:06 -0800 (PST)
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
Subject: [PATCH v2 4/4] mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
Date: Mon,  2 Mar 2026 03:17:57 -0800
Message-Id: <20260302111757.2191056-5-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=BI++bVQG c=1 sm=1 tr=0 ts=69a571ef cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=c6WgzpUFESAvjm-ZtrYA:9 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-GUID: BuiWq-8-YSnTnKGa1H2y8v6veNX_SIPD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MyBTYWx0ZWRfX4ovLL7TyPItq
 eellDXxLU4QMKSSwBMQY2oQbXIBOn6/Y24sWUUr9Svx9vdaROLKOswKPjQ1dvfStPAE6EdJg9pK
 JMdHAZ5YuuDu7BDOQME8ntND74xNOiNJ9GUMJsKrKyFMXs/rnIC1b1RPLf2I7VEvm0KtqZH4MI/
 Re6dVPPzKl/m1ucH3Z9BZKjGpOotNvUBTGYKDcUfYznoAQ+sgVAd8WIFpzgzCFhWD4pkrK/qJa3
 uoQU9eXJnmFkbwoWRu4fEj9RjprLlw9fUQOjPfdwBcD5WCn6l8FOHvDpTPzWPnnKOUHlubplUxO
 uqQUIpTsiz9/cvRXiuzzTnyYF/mQcAqz3+3m77rzfNXkgpkboMvvhFcY9vDTy+OCtoSCm5XJrzO
 ARHE+lWTzAnCZ3h3DOZhbGnS3j0zNtNpc7NTAKP0WXqlvP8g6ZBp5xSjeZ4oV0vyxRyW6xT6QJW
 IeOgIaDuZESDxVzYoMA==
X-Proofpoint-ORIG-GUID: BuiWq-8-YSnTnKGa1H2y8v6veNX_SIPD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020093
X-Stat-Signature: y87u9scaqguodpjox4rsi8qh56opfm7o
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E3B1100006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772450289-334967
X-HE-Meta: U2FsdGVkX1/J9sfqtyqVVJtyFje3GreVlGoaO4nb6YGuMMHsrC7hppEFJHiLe8Phkx0mna8UluM0PZ9C4kE/56hZlMrh/SiCuAG5BLlGV3JlUmMS5a8xucjAkCTnQOOGL4qHiOT9KD2S1ZZCnYcCYyx64HREfif8TGxOCaCMMp8wNgY9HVWrdrXqsNK2KKZziksucc2c9OqZDLygxV6DZM3MlbMw3EtHVHliMB/vBfeHFOuKd4moGgExgtd597q9y7k3iceB9E32zmPvxbzK3SVUV0cL2Ab7BiHikEtrS6Z0+BfoE2Eju3r2642RC3l2tik62h3MkSmVQWNfvfiBVZUCiJCQE3mVMLU630F9oAlaug7Nos7KS3EN3Eaj8jMd0vfOzJdk4ZBF7vbK2d/vP8iJhSsxIftSwwcBvr4j0TuX1db/Y0AOocDE27D4+tBmAc0HPkmuPVF60sNkbdkEKgW1Th9jyr5iW5ELmUvmGlOf50u4wy1WlwYR4+WJheu9zcPZ3sjrgCV2A8W8I0ydSJ6+LqG+bca4WQb5dYF1a4bYpyvnco/3s553WasSQ/Bep03RiodPgMG1LLuBeXAKl5qahnYVY8J4TvpCj6z4YBB1kgkSMev21fKjVAI6KtycXdzrVs3cBoFktRZttVCJZFChC2Uq1EVtiVoTojoXLtmw4BREq941Ws4XBoK2ayoI883RHyyKqi1/C04SXbVrav5Mnq77cLDyXoQKUp4jb3KHN2xi/h+AXnNJAe5GEoYr8V1cJqvhhjaIrAR7QJgNN1A2IDSK0qfXYjXe4KBFE8HpOb2CuUBWEflUAZBUP4eZ9sxSSvsmC1OsFp9KFIBrnN42T/uGMmwIftGzhzp5dztrDyoYWhczETEXjCDc7XslHBtaIeSsEByPC6b3tDNIvcEDaLO8PlLI/YtZRtNaCOzjHyzGd54+HjNlOxjGsOaHOvebaJIOSkJiX/PMxq5
 k1/OKOlX
 VB/SiZ6arN1avBNTv5it/B9kUTIrEIPnSwPJlpmY/OAT6Gjs5l5mRmJ5EgkDBGhW6zWGGBsPbZtjUkgXX0MtQL6ny0W9uGyvYFQSacimZc581TI+LgoLLqXWfAxCLLiwfOkMdXqiVYT/9iqKkpaxp3MwOB/9h73BSDuIOgsWH2RmOTrNJMe2VEBdOiAgiLpZVxmBZP3sj1CraWcMlPidkYAbS1T74aA8o6X5EwmLfbKT3B04aHsZjyTRZ/YU1+7Z+wXy/mgdobvjc4GiwtvCW+/c2mV5RByVxsDFQzFkqlgZ1PLbnKo68n1FdoaYDa3DKaIJF/iNhwzXPo0clxlX6V3+u+lhQcJtcEnOXNVUQ4H7ufiTPL9orPfDRdRoaBJvavPX1f02Tgqv9ubiR+OKdi4dW0G/Zyb0xLV7jSTkhmloLkaSYrT62X3hQZL4/rX+SIYZZwrRQqme5zs4yqCMxwyJs6RVlfnoMi2NHodS+ut7dMEpioQEM1EkpbngbfM6yNiSOBqiXJ4UyqqYgE8fvZn25IPyKLlqENowZa6ebpCZuxzh5lwRixtj7aeOhMxTwrPii
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PAGE_REPORTING_ORDER_UNSPECIFIED is now set to zero. This means,
pages of order zero cannot be reported to a client/driver -- as zero
is used to signal a fallback to MAX_PAGE_ORDER.

Change PAGE_REPORTING_ORDER_UNSPECIFIED to (-1),
so that zero can be used as a valid order with which pages can
be reported.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 include/linux/page_reporting.h | 2 +-
 mm/page_reporting.c            | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index d1886c657..9d4ca5c21 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -7,7 +7,7 @@
 
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
-#define PAGE_REPORTING_ORDER_UNSPECIFIED	0
+#define PAGE_REPORTING_ORDER_UNSPECIFIED	-1
 
 struct page_reporting_dev_info {
 	/* function that alters pages to make them "reported" */
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 51cd88faf..21c11b75e 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -25,7 +25,12 @@ static int page_order_update_notify(const char *val, const struct kernel_param *
 
 static const struct kernel_param_ops page_reporting_param_ops = {
 	.set = &page_order_update_notify,
-	.get = &param_get_uint,
+	/*
+	 * For the get op, use param_get_int instead of param_get_uint.
+	 * This is to make sure that when unset the initialized value of
+	 * -1 is shown correctly
+	 */
+	.get = &param_get_int,
 };
 
 module_param_cb(page_reporting_order, &page_reporting_param_ops,
-- 
2.34.1


