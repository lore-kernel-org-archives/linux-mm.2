Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BDACEC1433
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18BF86B013F; Tue,  3 Mar 2026 06:30:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136856B0141; Tue,  3 Mar 2026 06:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3E16B0142; Tue,  3 Mar 2026 06:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C819A6B013F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:30:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91217551B9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:42 +0000 (UTC)
X-FDA: 84504534324.22.D5865E1
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 474E31A0012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:30:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KbOV+ITG;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dhpgn1Nf;
	spf=pass (imf19.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7rYseVkxS5+KfcyGe26QQjJgka7f1dcyKVc/ATKtdbs=;
	b=Qy0061lw3PZuy9Kf9rKNYbXb86etvkZY2BM29z1bhNXrcAXKmOUEzQabxBCTcuHfN4nkXe
	r4CsdsgeF7mSorBoV8r/1A60eYPPeOrVV50iZUayzu61+oekExocX1Jhh4WT7VuIANvGog
	9YBNh7p731oM+n/1pqsC3SHLcgmzges=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537440; a=rsa-sha256;
	cv=none;
	b=AubKQtPSpJYr6GOBWIHlQU9yYPOxnI9pifZSYbhA1jVrXN+xoCcD5xseWrC9WeJLLFMAB8
	iB2DYvc0wwxpjPVKNYJPvj0PlFG7FmRv0Dgj05qDiVJfUzhDCvVMjCuvrg5OdSTLMxS+Ob
	Z/dKl7PggXtzCuFXOOqlHBXW+Rxo9go=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KbOV+ITG;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dhpgn1Nf;
	spf=pass (imf19.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239mnUj3951840
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 11:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=7rYseVkxS5+
	KfcyGe26QQjJgka7f1dcyKVc/ATKtdbs=; b=KbOV+ITGzgxWA7RFsNR5bM1JHaM
	4/f/favWm2i73bz0g03m+FpAdqs0yTsVtyCMRuqkOqHyS/3vaNWJ9+FBVUpGUkZn
	mk9smX2Iuwo/49nl41OzGdv9EYfYF4cyVguSF0vYkGP3r/vf65p/2Yp6uAOKlo0J
	zhwb6KGAPslXzD0W442CX0I9vCNRPkxgDF6lOyrm+n1tuiGDbIxpp6ubGpyaIqEE
	bIyc39j6xESkjgt6/GSXgtVPgnGNtHSA/CgJT6N+FEnsvn6dXZnRY2FCogg05Rwa
	11RxwRHPdOEpOcK9SQZLn3N3jqQRFajN7SN25b/TUGuTOPQIC1sua16Eyzw==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnu3n8tp5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:30:39 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-46335278e7bso110781666b6e.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772537439; x=1773142239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7rYseVkxS5+KfcyGe26QQjJgka7f1dcyKVc/ATKtdbs=;
        b=dhpgn1NffA9U2MuuC1FfBguRASrJG1EizDHNmQWgEM+WoIWhRLt1vP097OciksSp7y
         Lj1vtdt8oQKJNNS0vJKvRHdp5eOjNOUqnsmTmT08fMPAlSexdfJOotBccLs2t1j0TW6j
         VUbCgOCwu1PfXWzbff1PDen2JQa9968n4CTOgiBmnxPXYrjOLIZFnP7dto59I6C/vyN7
         7cMYAWzVyLdHJwJSn4Zrz6Ar8Cb36TEgEtioEkrbRgU1UV2fDRf2/0e5t0oLT31Z4qxq
         B47TpaDAOufgl/YdVMOHyoxF8AG9Bp1YImj1MST33uHr01aIW7OzpqcfTl7lDOGRRTzc
         GmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772537439; x=1773142239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7rYseVkxS5+KfcyGe26QQjJgka7f1dcyKVc/ATKtdbs=;
        b=hs89rYbU2c744p2Sy9RIP34fjVqPVtqgKPE9NyvT2okVNE2ow/nLe+A4L261BgbfGH
         866CQ68JofI+qsvpPj8vNfkOBO/MZT32C8HgBoF/+d0n/d4UAwaUsbl1Kp4l1TmPgPS9
         ldD4tZ+rU89riGR18zMI6Cy6PzNyNT6EctOc9mjbQnEvmFfEsREJJK2GiRmrHGvPWreH
         SPEirvGJ1bAZ+IAhaFneHscvKFq2YbGIRl3hoEwA04LPj/ZORUCLo1XHcZXYt84djLPU
         mLjzYotz+pfVlz4/Nj9UeFAp4NOmqRjFnHt5ZniVbX5Lba2332CJQWyoEvk8zKAFvSOT
         yG/A==
X-Forwarded-Encrypted: i=1; AJvYcCWCqg+SjIZIdYbRejHl1+AwGCNtfugVZTr2zBfk3+MCWZep1WzL/L00Npu2fV08xV0LNTlSWaJd7Q==@kvack.org
X-Gm-Message-State: AOJu0YyLLVrxzzQXeeDfRejT2xQPu+IieKX0Wa/DdEF+RpJZ8cWMV4lr
	eIzSgDjvkVn/0blhVyu7bMWTJt5snnyFcgQf9hk0vS7pGaz+KcYlF8PLaZx8tptZjlvP/74FEHN
	5Xz6p3uRwUCkbG3SLKuPY+i+Y8VRukLJP2O849AZoO5DgFdUhxsMNoA==
X-Gm-Gg: ATEYQzyVWIsX6wGSPvwzZRWlEIqRDg4v0X5wTxsNZmqC3pFPH7gSAE81pjh23cKjoiC
	HWRYu0Wl0XHAvMnJrTmFjvqtdqMIPy69Cy4mIql4QLb+R6NudtJTYRmHxx/QYOBMF2ZNnHL3rz0
	l4gZbQ8O3s3bbDsrvaji9GHeKxoxxVOeSjAz1/adpiS/JGXC1YiZuL+givIJ2rcJbMSJ9+AYv3P
	Xy6dPvVDraQtPw8dybvgkPU7c8D3l0k0eUcu1znHWA6QsIsbf+TKsWO4sVjRa29KwbZRO7blIjy
	5j+t2b2GT19sTNjCTEZkR+uMFEjuUi9c6ohL+xjCBANOVwjyQWWjQkuso3kb8Bc95hQO9rKVKf4
	CbsCMlx6X7R30ZbZwh//o3nv8ylG8Hu5lLlbVmMhbfl5TiFCXvbbaDBt+lt3rrbq/Y9isNF9f8J
	dMTpXA
X-Received: by 2002:a05:6808:1206:b0:45a:58af:fed6 with SMTP id 5614622812f47-4650c7a1614mr811610b6e.17.1772537438692;
        Tue, 03 Mar 2026 03:30:38 -0800 (PST)
X-Received: by 2002:a05:6808:1206:b0:45a:58af:fed6 with SMTP id 5614622812f47-4650c7a1614mr811578b6e.17.1772537438134;
        Tue, 03 Mar 2026 03:30:38 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d59785d8d5sm9311790a34.17.2026.03.03.03.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:30:37 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: mst@redhat.com, david@kernel.org
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, longli@microsoft.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        linux-mm@kvack.org
Subject: [PATCH v4 2/5] virtio_balloon: set unspecified page reporting order
Date: Tue,  3 Mar 2026 03:30:29 -0800
Message-Id: <20260303113032.3008371-3-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=JaexbEKV c=1 sm=1 tr=0 ts=69a6c65f cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=Jvdq4yWlxvBRgq3Xg-wA:9 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-ORIG-GUID: JxFeQsbjN5wgyMim6wWxCozbOm2UavPZ
X-Proofpoint-GUID: JxFeQsbjN5wgyMim6wWxCozbOm2UavPZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4OSBTYWx0ZWRfX7flL8sxZ/jg9
 IgtzimzC3m+AIBuzHYw5s/cIG50dDFi5fXLA2lltaK3RwJimV4Jg6s3k566Q6q9VjHrz0Yvt7n3
 po3oOGzcnzwjsqQj8X2JRveMe8BuQ9MOVKBC6jwJsh1w0Ipcg1MDNEZ30PbPkZ7xex+CBveZ2nk
 WsE8PcGKry/CoOknQrXDgXMUYe85NjiUSF+cAFWtZVogCBDbK7MllWaALaC8AdcZxiQ9mysLSqC
 Aq04MQIIFbBD4trruzBd3TloR0cVVF/gEMATv2TDbiZNPRkxxYl5p7qDvyyrypBLA1xgfBaGkNj
 kDCCiiLZjwfQOXw1BAU3TcWwO4tOp3iUEQtCpH7f5CWpFk5T420e9dUvaQ5qz6240EFLmWtZ7/J
 6HKz0G+++VBHtHSB7RfO3HMxNWEDiTkTOxsVbK4TNlqKfgbqJEmNRWsZFDPhHwrsCfgzJXqMpDo
 l4yzVWDKwPuwVPHWoJg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603030089
X-Stat-Signature: cic91t58nsb6ghi9t4nsz8w33su3z9d1
X-Rspam-User: 
X-Rspamd-Queue-Id: 474E31A0012
X-Rspamd-Server: rspam12
X-HE-Tag: 1772537440-174270
X-HE-Meta: U2FsdGVkX1/j1+IdM8YCZc5kvlyU6ZBlno8laJ+MMzEOJjps2Rz1aQsdqsRO2caquQoln7AyS11Xoco4fC0HDGZ9dWl6dOo2tzXKzdPV+ZpA/cf9RCvhaRkskTVeFcaI2hGiglw8wfh/Chev/AQPWYMLCGcJNszCoaHRidCApKLBA47J6auL1SozmE4jTpZjSyqP96Pxad68EE28a4lGFOJPJNwPSSnUF+VEuIcEZ1bUu07rrjfT9hn/XFkuvNV5V50ELg3eh0oo+Qwy0TGYZ84fAg3nC7MJ8v/+1QZIhSLMSs5l1yhuQRYvZCBPkntfIC79MgnKIYWvhibtNL0bQHEMbXi3Qd0rjkV/3nMGNeYy4wynR1EjEGKyIH1t9Xla7TQUYRPHNcjWGPCSJM5DjVAWPIfXQL0au7rIjKmmZ2Itd4nbhhkFlJNNMObpMKO8XP1p5veoplNrgbdLQW5qr1Qp+giV10G7q2mPGERQkHEUveO2wmWI1q2xfLirlGx78y6nhXRkSvYyUQzfVk5zOzvhRlbS8uPaOVDuYNg0fuDPn5XyrB4fSTD4gBOlQ5bUUKt3CAclSq8O0Eq1ADeUcB9KM4+BqaMyuki37U+s88kAN3RbfklxL2tkIyXsl1Yj9adk4Cct9STG/hTY+c3AnFa1GPLFNeSsB2WMSbWKjTjcl+Bj/sEHKWdsaRRgNSPpTLHzlr3uysBz1QhAMOStzRiLUO3x7XOqOy3vvLoqsrjHqb46RfreYUd5eb4XJHks84F05vwZU4NfhmoSapO9Mr+cZr4zMjVKsb6kRR0q6bsQjybjRDwucJ9e/SJ8TqySy3o1do1JbQJnQsoSsPDZFz31eFw1ia71S/1n6aHIIqJQjGMvG8zIrLHlgYnq4qX9qwqCL8uHgc1HZR58m8GzgM6eG1QiCy0dEToTBUhXq3O9EN7Y+JHOpFxxACiGKurDIgilel1gKFvPWNss7OZ
 jc1BYd+e
 EDCRfNvRFG6AFAIpBQlln6yj0pP1UMRkRk5hJGm6Ptnjv+obJS+Vdfu6gLGJnMp6WBbzkRT6oKBHKRMRuV/IL3HQyu8ioPbHHumjygkWERxctA87CCmVshYbwgNPcgKZN7nlE3aiB/2zK/+jTr3PIRL9CMkv4gRlKJlFPUApWcgg/rjVfMpvJJIenQ4DabZ9hgPf+Hev0flAEy526luhVS5kUTkaYiOW3H/1oaCnSKTNXNxdgeGx9/F6PHNbZW8fqRDJIEeKeIGvMPumZQ6RUtUx65IRMfouq9Oqs/VuqnJpORCAWGBd+S/B+bffsqYQ9FK7//flPvrQ8RINiJQVYpvsdx698k6de4ugofC7nu02dhsfAQyYEFW4aQZVlWz+EL9NFEzHxjPidRZPZadeylH/a+p2Hlrb7L7DRdjFJW+6ZX/aAXN7CZMbLYe6YnUl3c7EXgpCOh4hEMrtFPE1TJ5ST3y8noAbuNqxreoNIMlAYwU1Pp7fckNHq5/RC1QvQNad5D5v0c8IrCgDJ1sCqy4mkIw6Z2VpVpcO7lrtT5oh+dGKlF2qSoXfBTtkXZTGi7VU5FQ0mPy6HIblRw8HIVqhoTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

virtio_balloon page reporting order is set to MAX_PAGE_ORDER implicitly
as vb->prdev.order is never initialised and is auto-set to zero.

Explicitly mention usage of default page order by making use of
PAGE_REPORTING_ORDER_UNSPECIFIED fallback value.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 drivers/virtio/virtio_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 74fe59f5a..2dfe2bcd8 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1044,6 +1044,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			goto out_unregister_oom;
 		}
 
+		vb->pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
+
 		/*
 		 * The default page reporting order is @pageblock_order, which
 		 * corresponds to 512MB in size on ARM64 when 64KB base page
-- 
2.34.1


