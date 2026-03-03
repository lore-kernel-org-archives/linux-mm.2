Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06072EC0463
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB5C6B00A4; Tue,  3 Mar 2026 04:33:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27F16B00A5; Tue,  3 Mar 2026 04:33:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D3E6B00A8; Tue,  3 Mar 2026 04:33:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2AEF6B00A4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:33:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94BFF1602A8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:57 +0000 (UTC)
X-FDA: 84504240114.02.445397D
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45452100004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:33:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=N012rIsr;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=RuqtFB2s;
	spf=pass (imf05.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GErfW5OKwnRyFXwMQYfYehZgqClYIHh3iyYeF5iCEjQ=;
	b=13Wbq3+VMqxK9KX6eoROe9eLiL07QDjEoRmPLyzXG2TQG7zT6M+ojTtnJVrVJ6IbyENTVa
	mhLO9oaSjfY0F6yB235fkAMKBXXWFgwohqv2EuugaLmQTdzz4ffQUTrkpzooaYcWYPL4hP
	dDlOtawtDcSJhw381eSpasRzWntYP5w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=N012rIsr;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=RuqtFB2s;
	spf=pass (imf05.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530435; a=rsa-sha256;
	cv=none;
	b=Inmv/BFnY6v6SziTyFmrvLpemFG2HQMH1eBtXUOXjEYSy6zYpgpjJ/mw7cB0FNXwUlWjFE
	YiXFQ9Nf0jyX5BS8yE8B+X/bYkWYJzVENAKB2LC3QS1mkcwxbXgM8YgUXmJ/2gaBOAU9va
	YWV+xlI9/MB1R1S1jd+49Hr1y4323/U=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239L7wr2554038
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 09:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=GErfW5OKwnR
	yFXwMQYfYehZgqClYIHh3iyYeF5iCEjQ=; b=N012rIsrwpXUlBt5lmhbGwMdKNS
	HYdreAEP/Mtf/kznRAcoBV7eRxs+pZwKcWXeKd/Le3LkbCFccCECNy4hFpEoicA7
	AxCf0vxaWYougI/3vuKvORxphPWjP2k7INhJKad/VQryitOhUracUxaoUxyvP/+G
	FdVWfd/4rdKOYrHZLWAA59TVtnXS0abcW2r9ALjIb8dYl8YC/Q0sir1rrBAUMACH
	jPdo/BAAXB22BJ5xd0gmn0yLfVX+4ClghL5CkQq6FWaMie55AdzDnyM/Flth0iQ+
	VlRK9bLpQ3LbFBiI+YaiispsgStnG9ArOx+AFAJ5CQifRSr7eMLAvNsUK7w==
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnvxf81n2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 09:33:54 +0000 (GMT)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67a04fcd7c9so23502199eaf.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 01:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772530434; x=1773135234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GErfW5OKwnRyFXwMQYfYehZgqClYIHh3iyYeF5iCEjQ=;
        b=RuqtFB2sPhodVBqNhhcYSDORzRa5Dy68RM+9jQd3JS3yOnbFFzpdpq/f53yrGugPd2
         By6GF4bLD7EhWIF8gXgIv+duuLiu2xcgblMg4RWdD6HCw0vbFlx17aWWAkihmM3PgE+l
         Q8OuUvjDcedd/hK7ZH1u8sv8DaAndNlonjefbPhw0UU4pbKNlerN6x2ewukV3FhjvQJN
         71yli/AHofBkjxZnswpgx2twqRwpPgd6KAJcDizAsEds7V+GR1qVfuftub0xkfQ/9pW1
         GUZBFckIha6/XfeXpNPTez+QnHLHfvrDnHUw9LMqE0yi0QL1xjgwAohVbeiewNh/Z5FN
         sIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772530434; x=1773135234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GErfW5OKwnRyFXwMQYfYehZgqClYIHh3iyYeF5iCEjQ=;
        b=W+L6TNw6IMFgGgPBdyPtbSchMU2LRtZsfQC3LFYx13mEK0hw0GOpRngJ5WQzSztQeN
         gSoK0Br4xNinfYY77sMT9KcZjIfjYdbavbfbGtaL7wTMv1G6UfqvmFPMKnebnG1vR5kK
         vHi/bP6sId9487SyW8eOnjmn6rs5D3jFrh+zQ0vi01gO9CGbMvX55BdUSDgItf7QATR9
         Qzpy0EHdt6G4UGTXUEH/krBwak1njO/E+uy/KQzbCwOEAdCkB4ToDGgOe8PB3Dnlju64
         Fxe+hGvMPSM1MYirfFlZ3MbcPydV2eCe7lh0QKFiNdImWU7y+QFc7Jp1OTTQp3/rfPM4
         K3Gw==
X-Forwarded-Encrypted: i=1; AJvYcCUAJJbkfREyWO+NMaTcvtA1FW7B2xI7qnrB9rz7vQo9d5R4MNzFJ2+soIh0RlP83MIVO84+2nfnzw==@kvack.org
X-Gm-Message-State: AOJu0YzMysqXmWEFo/oZAtUywfuggYC5bOBGfNokDo0cN53bj59tHAIB
	Jve0snLgyvUR5iihdGGlLhscU+YCeCg2BZD6a3otskX3q7U3XSnuZMKKH5xvYulG4Ppg0BZAUwX
	8VyzaOaDE2vExIbSadvB7GbdeCuVzFoWr66AdKP8b3m9r22DJao+JCQ==
X-Gm-Gg: ATEYQzxStRIZT1mXXT1jsBobflIQIDzDFN/EEsZoQ2dRNHnj9Dk+B4wPYuIP/QaOi34
	xU4sEUeoQPLYEcWQrw2CwLB/3UKtTgLViE1nN//SJFIX+lh/CNUm+/xtPuldlwip7b7uX+76ak8
	YfRooLkZ4Rc5pjd33y6nIQ8TL6Aojl5usfrgiwUWGXql4RDYrJyGoHZsdQ5+XfvUNcFHYghpC4h
	6YJYUTuv2DrHEvky6rL1f28UoyIf0N6P1XibXqvTWL+mD3h60/MgQatRA0czZ/HQ2vuaKhIelvD
	U0TckdncRCIhKsLWV7OpnFz6yntnGEmYAiGn/cYTP4a7MLKZI2wF16LhGt2tEOYzD86f4Idhr7H
	zlas1Q9DcMx0btGOTwIs7LT7hU7YdoYA6tR6BcXT3nw4p+OPT/tZafiAxOqgNoA3U62y0WpOBlc
	HFMTQm
X-Received: by 2002:a05:6820:4b85:b0:679:e633:6f53 with SMTP id 006d021491bc7-679faf9d7d8mr7935889eaf.68.1772530433738;
        Tue, 03 Mar 2026 01:33:53 -0800 (PST)
X-Received: by 2002:a05:6820:4b85:b0:679:e633:6f53 with SMTP id 006d021491bc7-679faf9d7d8mr7935866eaf.68.1772530433239;
        Tue, 03 Mar 2026 01:33:53 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67a1d603f31sm938666eaf.5.2026.03.03.01.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:33:52 -0800 (PST)
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
Subject: [PATCH v3 5/5] mm/page_reporting: change page_reporting_order to PAGE_REPORTING_ORDER_UNSPECIFIED
Date: Tue,  3 Mar 2026 01:33:41 -0800
Message-Id: <20260303093341.2927482-6-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MSBTYWx0ZWRfX+K9Gvle5iD43
 0jbZlYE2M3kVqwS3eVxXTk/cFW8IkCKaYLuoPSigKJ6k5kHvw0/xKKAkRpBkTFgclzEnXzVPB48
 3i7zAzkaFbR95hTPl15fRdNPkexoIQbmb74lNe+ogwOclyXoZZg9++lhkLtlmZcXQlikFsF6YsY
 89k7fz8Fx6SiVTkRnT2URJ8l9WN+gFMwOsM1V3uugEFqdVsGkJiTpYikv+kkFXABRp23zNLRHrp
 z4O1lkpmV0xGB7aDWJgHBbQaEL76Png4IpznlGI9YauRwpQqlVyuy5RlJvnZOOSaxpHnPtQ6bsq
 PwHrFMEnmHVQGhwiE02rjgfPefKGm86kF8sWMHb5kz1uVlcMeoQBMMPxHKqUp+P4uCYFKwstK3W
 uB/QUHCTbM/sS6lhVQnydjJICfABqrkR11OJJ/9uiXiQ7JiPjie0mlQ4kI13cg6lynYG0rdTMdf
 E51r1HrU8VtMPm1rgVA==
X-Proofpoint-ORIG-GUID: mPP2g5yuheFYrNkKSr1tHdxB9hGHPHtM
X-Authority-Analysis: v=2.4 cv=S+HUAYsP c=1 sm=1 tr=0 ts=69a6ab02 cx=c_pps
 a=lVi5GcDxkcJcfCmEjVJoaw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=snxPPiGZoRN-_fWW4r8A:9 a=rBiNkAWo9uy_4UTK5NWh:22
X-Proofpoint-GUID: mPP2g5yuheFYrNkKSr1tHdxB9hGHPHtM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030071
X-Rspamd-Queue-Id: 45452100004
X-Rspamd-Server: rspam07
X-Stat-Signature: isdo4f7fzct46ym1wahm5dugwaaj1ebj
X-Rspam-User: 
X-HE-Tag: 1772530435-599415
X-HE-Meta: U2FsdGVkX191/H+B/mF5ZjfDgWRmP+5lMOkT4BulVti9vvjP0oYsUJqxqmjcwaCiW4KeFkee0pdQo7AFYLBJfa61Vtmmr7PFdbk3bwlvy7TWArNcW9YIhIXmGB3EzZyurPkv0X/HRdrUZWw73d94/HsIY2JwVlxMqP3F7Jh0HKTocXn2Y1w+bXf5xKcoyT+OpiYAbwABU2TumWWGPw7BtAkC9C2ZwvyGzYN2M9YXDXSYQMp8uLTX1WsS67JNlHAqzIUMaW6zV7Vcb4yknzCAPMTJ/MsuwAphH8qki0xVsYeVeY7hkZTtsob1GhY6FaIzR6XFYvgQK0EbhFXVsQ5e+sRYJ5kuKUBl5sVIkgCt+7ePW/zl5FbkeshgWzAfYza+iwLI6Zg3M4bFWNJ88beKfFgekjVR064V7MNkKBB8Qb8E6Ybzj2R60N4VG4WzSUSlwMnazAq5fKRBUuLFcvMVJRhYSUYZCEdI24is74u8tQTmLa567gKucGZT7KcQKz0lexudyiYMj31MpiaQvkzHcZkQZ7Pozy+qSqdreF3qdXsIeBAg+tdJl9XEkM9qurWO992XyCoe3AwqGEQaallpu2TueVx5Smla2/LkcAQ6yOCYQFG2OP7viFFKk753ogpOQJ8u3zz3CnEiNlM6CR9/VZHH1fTpX0WaswkiP4+T07wDNw7sxhyG8FlMX9t/dEoPVv0lbwRQRXWHBanOGNE0yQ4YPeZscaURgNRaXWeo8ZorkRJ9Yaw2Q149pRrucNpwk2mP8Aj+VqE+qcTdRajmZZX+H/Hku8IlTTbiUOjv+KXupH1r2LXwy3a/7Fd1lyI5VdTyd6B9hSYzyIs6O4yreG13RyAJXmWMgZHs6p/zSoncbsxvCNRpXBUexPRtS8SU54TgvGN2yo7lwseYDnMoLuSTdir5RjKFFSGPJBLlcuuqJSTz7FhV9Bd7V/Qt6Ia+ijdpE/pT3SLjxwpEXeF
 XnM66cDT
 /sW8ju4gZr80tTRah0Dibu9Q5VdtHkVi4REDORPwWGCr7f3/WgljGnmWS7GQ82uznjo/JOoBBYwmJqr5lwDuzA4kxqP9KHrvRR0xDL278uVvZNjbHKutJUs/G3OK3b6Awa1t7+vgmhAf12eeU6mRXs/CA30+Ws9w1qcxpW4TKRwoChddMzORRtqigEwl5ROr7KlZ6PfERnrtUUqNFwLJw7MuUv0xcuNshd1tIC0w5TpVt5QFXoCf3Wx9ZGjdyidcPRsYVwz1ieOXJA1Akai1PHCvUBdTQrooQmiCfiKPuoczrQJh8Oqv6uyQDQ3i0W3baMy3g0ZMp0j9+hz86coh0QJMlbgy6rVAdPdixwb5PpoLqCC+BYmmToklzzdWRi3Vk0BiSTOHCgrANSGWoaj9p3Vyo//QUIoKHLb104/jZjl0kCPTBoTms9SoXPFHGwhN00tqvh3p0YMciKSr4pJmLstvcKUJwVT6kUzQk2xMUgr8I/a+OY69+acnZXRkQTGiKrn+4XTAQggJgDsWh+IC4nPwmubH1u+4GksuddTwyV0SPUt3z7T1DFWAODw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_reporting_order when uninitialised, holds a magic number -1.

Since we now maintain PAGE_REPORTING_ORDER_UNSPECIFIED as -1, which
is also a flag, set page_reporting_order to this flag.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 mm/page_reporting.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 40a756b60..21c11b75e 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -12,7 +12,7 @@
 #include "internal.h"
 
 /* Initialize to an unsupported value */
-unsigned int page_reporting_order = -1;
+unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
 static int page_order_update_notify(const char *val, const struct kernel_param *kp)
 {
-- 
2.34.1


