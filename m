Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B2F4E9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19CC96B008C; Mon,  2 Mar 2026 06:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0222F6B0092; Mon,  2 Mar 2026 06:18:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6CAB6B0093; Mon,  2 Mar 2026 06:18:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D02826B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:18:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A8C41B8FB1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:07 +0000 (UTC)
X-FDA: 84500873814.12.14F4122
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28340180006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=OXlaX7Ic;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=clEWAsr2;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf06.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WgQA1jpoOhhihTrIOScZsZlPh2ELGgaQLSJKmwH+o4=;
	b=jT8G76dxIdlT34UKW14qiUz5y3NegVc1KHbMph4eds9dmIWAXnUrZdsFjAj1mMo7yWMU1d
	oYsNSoBwKonMV+CWYGuFY4IF7M87l68CLm314OYeYp3/1eYMP31pA4kJvQDP3JqmmSPRis
	0ZSJJJbKB+nR5WPl/mPz4mxmjYQU6FA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=OXlaX7Ic;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=clEWAsr2;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf06.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772450285; a=rsa-sha256;
	cv=none;
	b=yD1y2M+ukR9Ixr1ZFzzgGtED7Z0v4OrD5RYbErkINKE3JVR0OUZhZnzpcBOQ9AFulzzT1R
	XLANBoH9hyzVGWuwNGXWAMVdyNS+iY0Hbn0uXUsgAY1zsqu64AmfGMuGE8+4kZ3VmLeAUF
	A6z5NeZB3LTrJu38i6/sINF//NAaZdU=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62294lol1291371
	for <linux-mm@kvack.org>; Mon, 2 Mar 2026 11:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=7WgQA1jpoOh
	hihTrIOScZsZlPh2ELGgaQLSJKmwH+o4=; b=OXlaX7IcEv9APHHnKmMYUuQUDFA
	dKWGpNp0EtanOe+OSR4C3EYxt5xmd18VOm82+nzPneU5cVDU5amU7WRIeGnhD0NN
	Taegz79kCOXYDyCctx7BryTRv6sRtHgJRTCYLOzz/h4bRrKvOnyJfqgkIM8wbMOd
	+dWa7+vOWdLCz6MkOzzU11MmysNu/zhf7l5MdwC2aYlmokLQ625+3FbbixSg4HzQ
	EOHmXEpZleHs5GPVyi4CqJkJuH5hb7mz912pccWWZE2ucv2bMeZ4DGzz5N0Xz/Qs
	MQTVV2shZN6pxe+kh5ZVMXF9+PAFNdckKIJo3S5nLxGfaNydYRocuYrzs+g==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7ku0f9r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:18:04 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-463b9608e16so52655124b6e.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772450283; x=1773055083; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7WgQA1jpoOhhihTrIOScZsZlPh2ELGgaQLSJKmwH+o4=;
        b=clEWAsr253yEu+wMh3F9oNayGQ9YdupscwAulxMj200SH8jIWpPJi4G7re3qy0d48T
         jh8SHPBQL0vslvBDsdkZW1iHmYTuaEYjQD3JHvZxdX8xqOQAXXEVaLkY3GAZyZ98SMtC
         C0GHIJMx7GibZ0/qnx4mxnNdKFRNeIaC00dsJIFjvC9/a0WAXA0+wetA/LzLc7lpcg/X
         dfDYf2tdqt3vbC+dM9EQgRqDGSLtVDW++vOLdS4aHFB44UAfiygKauZEAu+8jpV03nbC
         XN3qaVA6GRETDlR/kw6td4ZaWFZB6ncK6a/qyTzwrGTF6M7i3IgWJT+lWJXjck5fhNWH
         yY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450283; x=1773055083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7WgQA1jpoOhhihTrIOScZsZlPh2ELGgaQLSJKmwH+o4=;
        b=Ua5TG7z0IwAuc0jjoJV3PKvb6quPVM/ik/BrnD9aVdeVQL1nOHRsoAdsdXFc/b5vr6
         AArb/GE9nRWdXzg0USnJWLl7ch+BcHUkPRoXU06LGffXBzq8ODovTX92WA96mP6Pqygr
         D5Imzoev2Bd0SzZ7lOfU3CQydEFCqAFt2PXXNXHGnoRVBR0ULBDw+CrthCJg5OmBzyiq
         cg+O+bz5M+Na9V/c+ZPZO0qBx+4LAA8riMDPCabmBRehd6WYbv6lQODoXlXLO4Az/J7E
         nv4RsaWsQhT8P+azGanX3Cgr2Szr7x/Ig85uPmwtcR0NwBh8x9IFheOyxomkIcqXhjUM
         V64g==
X-Gm-Message-State: AOJu0YxNYRruCaMdm6lwi2K3WD6DSJH5u2DLklp5bfXeqsYwAtYR1gUq
	I14cipiFtO0il1grHden6e14SVGqej+zbWCoQdDGsbjcWPcAyR2a45M1YbnoupsYGm6wJ6dDh9d
	SVPg9MPafyu0zaNVbDgv8L4HF0Bcf1pSC751mRKfzZuAoAWiGv9MTNw==
X-Gm-Gg: ATEYQzx1T9mmLeHMDJcU1ITnbD1DMfjo2xkEoO5VHuBnvZ+Wc9SrUf0jzKwJT40CN7f
	izoCguI32QIaOjPr4zjqkSDbrh/a57vmHknqFJEGCG5GaZXsKr9u/d1fn/A6ATs1iFnoMisNlhE
	8tjwGZM/GlxSkt2L8slf09JfomyLIX1Z6STEb83dsdtWRSmK+fhBS41p4921dJmLQQEQPWoGyuc
	Iw1K9uq0Lai4WL8fT3sUbuf8PCLWqHTpKKAbos+uwT9sGRl195gzyRb7LYspdduXYVZE5dOVVL4
	KTA0rzl1xyHF5at5tZQhg8dp6VW56xb/UK7Sfy208Rw4uiUIXuyZ+Ty6lKpLvSPBcrEs/00g5fg
	gvkgXTCigTFOA/sGAG39KE29ucr/sB4JZA2qEG0ZPEP/tXB88I7VW5Cw0fpl4XzlujVRGKQ7fTH
	Rbo6Ba
X-Received: by 2002:a05:6808:1396:b0:463:f9ad:a4cf with SMTP id 5614622812f47-464be9de029mr6940038b6e.23.1772450283486;
        Mon, 02 Mar 2026 03:18:03 -0800 (PST)
X-Received: by 2002:a05:6808:1396:b0:463:f9ad:a4cf with SMTP id 5614622812f47-464be9de029mr6940018b6e.23.1772450282960;
        Mon, 02 Mar 2026 03:18:02 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm7354528b6e.10.2026.03.02.03.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:18:02 -0800 (PST)
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
Subject: [PATCH v2 2/4] virtio_balloon: set unspecified page reporting order
Date: Mon,  2 Mar 2026 03:17:55 -0800
Message-Id: <20260302111757.2191056-3-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=V4NwEOni c=1 sm=1 tr=0 ts=69a571ec cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=Jvdq4yWlxvBRgq3Xg-wA:9 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-GUID: emqv7oypXt5pnlTKTCrz_bjWVkog7tPQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MyBTYWx0ZWRfX44CJ5mhfbnCY
 I84I5BBqorytyvS9hRUA8UKnnGoUOJnf5K4qiN5M2tvWiPuaUxja3CsPJfGAHA1WdBOgbDmCxMR
 x1EwmujlsMBc99dxvo6VpbJvG2Urcdz5XUhBUGdbdXraYj7kTyGcUBkEpMRP2QvBzmHyifce/At
 2YxrzjMzdxW+VGW6pekZKuWq12Tgcb9GoUETS0OVAXxUPd9rCbRehNQyUaQj12O8O5nF3mPsAiB
 dEW0sNPVpn6QMJkcELadT7MTwJl5ZZoKY47UZAdH5CPLeicm8l0uM5ApZoRZk9r7AwrTFRWRL+v
 pUWPxQkM44Igpd2jgX/bAyA9IFIOWpUN1hgkro44K6LOmEUpMQ9rO9ujy+TK27L4l6SBndvFXtS
 HQ1U8pEps7yMbnNj8dQf0yeb26fmSJiyrgvPTjD/TmZyTSsTwxuU5PhNz1J/fCMaNon7gI/5vMi
 W7QbhQ/j7c0kvnXsLFQ==
X-Proofpoint-ORIG-GUID: emqv7oypXt5pnlTKTCrz_bjWVkog7tPQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020093
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28340180006
X-Stat-Signature: a983wu8sj876d1b4346z9bdjaic54n5n
X-Rspam-User: 
X-HE-Tag: 1772450284-36088
X-HE-Meta: U2FsdGVkX19nDL5T8ooJUWI1+RgaqLXL8dzTFriktYzS6sv35wWX+YFk0keqlo7S3c+DEDaDDWuit+MAUVKb7JKNbQf9w7WWDqXLhRSOzyQlnHoQ3sJ9WvOhn7Du1pWkSTi+9a5LOX5ChIhiBW7GtRRrQiS6Y8zZsVbii42ATJ8hkLOXPimUdJrc3VBNm7W5NxTX6cHir7bejYJ3yemTKjEtNcqaoq5mvS2NNvA3AyQjln1A5U94ighd2FHNhIJSvaYBfO72iClJigkuOQaGkKROvmdF3su8++/SY9QDjF1ZI3hChwLIVvkOhwS7qBlsZD2QoMUYdxiHk9r95l7+Xu4x8gPvZLczXxQRvo4VqvTSGWpI0DHg+5qWo2yLhF2r2K4BgQU2mYyGa54HL7RbMRAVZtmOCleCd1fIQdGbeJx4s82r+oCLEWIctdUccmVMXRV7Ap7wCiS/oX9icHsejcein3dzpB8uj5pkbEig2dOhk8zQ2qGPdY1OptWVNQLRkPZd7VwQ9D7vGHF3fWXBudDWvxDhJcGJyWj/6VBJV6NzID1GRYsPhuiaCfEOF034jhFhTH65P9XR7vo/ydiv4p3gI2ObyuWs3B80+U7dimUB+mod9f10xAPMqGOcNtrKwqdaXXsXgNpx9RPLdeL3iTpr2JnqMP52GtFNDDxbv/bRrFU7hq/HhxxKF+4TxED3GHgV5CS8QaZzIuoEbgZ9i5HxZXj8nzdQC/A/MkfFGnntj9obz1NFigbhhyVQHYRYElo2V+RQgTQyoE6zrttzK5ysqAXqf6cmLIuS4QNhAlitzHqmCaMRFmvcPefZTBiWGX6e+xPcFtNsnzssBk5KfKHztnU8OKs5v51wxT/5sbQJkx9OHO/kFrE+AR1OIDjfmNf+EbTRwzp374qHpCtB4Wz3Xd5DJAo13pGa5PCZGdknkx9rXLfVTTDHW9V7VfBO5Dh2UvL6awf+oBpHscy
 hOoR/iiH
 /84c24TZdo5+zQtsZyid3UKaqM1DMntPsjOJ21sB2Y/xuVut4WzQsZ4Ar6Fp+LnztShCWXE9p9KmhPKJZWGNsoW5cJSMBPUNvSu1rikUyzVN+m/0n0RjDmTtWK89F3nmGczXgg0vo1zkSlwsnwzt2XMrlMIFSgU+pqq6bSD+onZR4HGlRiFXZtcVNOU1eBx+e9AS1x9RDVW2+PyYDiybUmTtGRPOPj/RVF542JYYcdolSGBy2edA8rIEwvRncVbWN0h9H1OG//b2b1mZoujDjnhPeYL1Oxiz5bjRp5FTvFkyy4eFvFcnbOW+hZbzBEgaN42iZ04ygQPDyH9s2Z0pXc7ASDJKolAaYC/BJk0wWwTO/gmm+14wSapAZzUbOo/UVqbrJKKxaxmxYFmTlYKACiv4GCkUI6Yu/puT4RPn/bvu4gASOsEXc7zwLirx41ZlXUkSSwVC/IwtpDZf2LGfFTAQ6Svke6Kmv3pMY9c5CHEM74UHUJ3XPqLKh4wS7cf/Xj6IXSPrE3YqMdHaEvgK56hOZa0BtmvfFEik+Dt/HEhEZt6/9pXkTQoBJUcZhWGNxhUeL
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


