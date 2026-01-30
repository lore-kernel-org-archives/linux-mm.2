Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B3CD49C91
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 09:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA96F6B008A; Fri, 30 Jan 2026 04:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D346B008C; Fri, 30 Jan 2026 04:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3266B0092; Fri, 30 Jan 2026 04:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9234F6B008A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:37:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FF54140495
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:42 +0000 (UTC)
X-FDA: 84388127964.19.13E3753
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id E1E1E140009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=QtPd3nxd;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=OODTwgBA;
	spf=pass (imf26.hostedemail.com: domain of zhongqiu.han@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=zhongqiu.han@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769765860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhzHDW78wiKVVpSEVXXLETiBR9TzCRkL2wGJiVRWaXo=;
	b=BcePpYvDrqU+TdcpYFNprVD6mkSvuS1S56HiEhmUIqmiDMa4WgnklyJHCNDXmhJiqHg0+E
	eXzDptVKQDP01jpTABrx44GfFN3JACHKebaEjyTxi5ob0zM/iXqjZ1TR6viltlE2dMqBjy
	o9XmB+Of6XkEvRKn1yaTO1dCv1hWk2s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=QtPd3nxd;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=OODTwgBA;
	spf=pass (imf26.hostedemail.com: domain of zhongqiu.han@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=zhongqiu.han@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769765860; a=rsa-sha256;
	cv=none;
	b=syQi7pEulhsOhJl843G1AaqtjbBrVZOuaFnP9YjHsI8oTY/i57NqW1SSHi5nhQg7lne9Ti
	+3w4qHUqVwAwLlCrGieQ7iBbcgcXTLxq9ZNy0F5zZYj6rYmviW/CWmRKO5Gi9t/iIW5k5u
	vlxN1bTErhnN/2Ebb607LQEGaveSVb8=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60U4boc91485695
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=lhzHDW78wiK
	VVpSEVXXLETiBR9TzCRkL2wGJiVRWaXo=; b=QtPd3nxdxeI89lWrXCuU6Qmkqr4
	uJY6MM9n2fBBAuvhBxPZEVWD9kNlV3THF80O+vtFkL0E94dJCw4bRAHiKTem25Jx
	24uiSnCjo7bRDqnJBHm9xPC8lcoiGT2OwkXCo4oAzNsd0pyL+JauFWPaPttUON+9
	6vA2VsEY0D5N4vf6Mckd5C5tUpPgypj6c3PKCvWTT3vqoxvcdRIvZhFne9V8kLUI
	ntzU2mxOCTNDlZ1mTNBs/v8lpzZEPv1s1/j4n7huxGQB1hfSBF0uJqiOUMrP7V55
	jT3l16STrrrqo1cCMf55LdK6mWKYH2XFhxYZ+vmJinm0etzFc0v8NBc4WAA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c0nsf8ua4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:38 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c5269fcecdeso1249834a12.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769765858; x=1770370658; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhzHDW78wiKVVpSEVXXLETiBR9TzCRkL2wGJiVRWaXo=;
        b=OODTwgBAGWRlqPLEkHpJD+4EF3ag0P022FyUfcyGUEyPAMl703oH54m21tIfhLKbA3
         P/6JoElROUdj3TtAsCWe0GQbmvhzSJ5ND3VN8WTz2BqfcaG9NAMOkkERNLwnVuZ7BBtg
         8yp306S/mYhUk5dCJrQfeAU6N+xmyFaty0AGK0UrwxKAN33cXlRauOJoLB+kLeAMby2R
         0KyKRu64eJqZ9MXMChmjLboPGf80IwOv7SFsjGWJgD3PF/u8/djIlqynHOaYp+2zyGOe
         EMmr9TCI6kJvfAOerNhuta5Ek+Hir58VzE3DQqKRJqAmNYu6deGffR5yMemmsYVgiMGN
         0MRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769765858; x=1770370658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lhzHDW78wiKVVpSEVXXLETiBR9TzCRkL2wGJiVRWaXo=;
        b=NW1/i4448AXJkAoH5W74YkoUaGxLsrSHm1zC339MnIUYeM+MTqhlO0r36ShxBQfT2q
         QdBrmt0aeB6m/yZJY3jVbQSBxXB/bBwsCqwnGS2/lEVOXEx/ncpN4D/ewuwnkf6Ocned
         XKFanDG8bF1VRbZ8KismiK+u+a7CtW4Xq4aJEhApg9b/ZF5sU8/p6xxySyLg9l8drIKg
         AFxv/qVkfqTSMWxbjMxpMF6pLUaS0VEwBUKhuGu1H+sJQKgHsujm70CUepu6OZJHn9UL
         ept/XUYhjURooN30RagWiQDmQPkA/uQhLdSr+tYQ88GBrQ4mF5BTLS2tdJ1NbvVo3lN1
         W2hw==
X-Gm-Message-State: AOJu0Yzw8J6Hbu3tya0QBGj2TJj087G8bt/5mzGGHxtpYE06qSJ7BccR
	Ax/twQtIRecG2HD09KDSVb1lBddG2AF0NN2X6tFhlTPR7vUA0Rq3FNYO6utKirUu640VlJUacVA
	sHFabQi+yATYxG5mtR5UD2A0+HvKKSN/bNIXU0ygyxSVL8yxXvmjWD3fFOPm4H/Hw
X-Gm-Gg: AZuq6aKSqDVcW3P2W0npbU65u/Q9n3bZLEzcCoKYmySGNZqOXR/egJ7KnRud/kjZdVV
	xLjwCq4IymiMbtb7BGjO8/O7auZzF7xPQvdwbehhmhAu1zgy4+N5it2t9oa/tayJyKjkmNjSIJx
	DrFjkTWgciQ5HJpaUej3itwrYX5lGnlWDHl1UZ01s5nz336njQvmXnAMZuPb/B2H+k0kGjzCHkL
	oaL2UG7eov+FSBFTUP93RSOv9KBbtRrRcHxkp/haVOecYSxuQ48IO1odNxd2SLgm6HFFYcEYkWR
	JytbV/EbpWE0nZAQNxf30tQzxF/6Y47vtvdkk4EG20VeM9yGvGL0/yUk/UNImuyJDSfp7+xZrst
	iZmXQoQdjMAKyAOJRA8pRw6PlJuv604s4qKRYrMoqHBfScaqYqLSIV1vgE1fvrGkJ69YvMxtEhU
	/7
X-Received: by 2002:a05:6a00:4394:b0:823:d58:c48f with SMTP id d2e1a72fcca58-823aa942882mr2498331b3a.69.1769765857712;
        Fri, 30 Jan 2026 01:37:37 -0800 (PST)
X-Received: by 2002:a05:6a00:4394:b0:823:d58:c48f with SMTP id d2e1a72fcca58-823aa942882mr2498309b3a.69.1769765857238;
        Fri, 30 Jan 2026 01:37:37 -0800 (PST)
Received: from zhonhan-gv.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b49fecsm7650432b3a.15.2026.01.30.01.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 01:37:36 -0800 (PST)
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
To: catalin.marinas@arm.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        zhongqiu.han@oss.qualcomm.com
Subject: [PATCH 2/2] mm/kmemleak: Use PF_KTHREAD flag to detect kernel threads
Date: Fri, 30 Jan 2026 17:37:29 +0800
Message-ID: <20260130093729.2045858-3-zhongqiu.han@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260130093729.2045858-1-zhongqiu.han@oss.qualcomm.com>
References: <20260130093729.2045858-1-zhongqiu.han@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: mxVMWac4f_D4u_g90mo7hRyJbLJU99nz
X-Authority-Analysis: v=2.4 cv=EvjfbCcA c=1 sm=1 tr=0 ts=697c7be2 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=xdClYPew7k9-90-fC00A:9 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-GUID: mxVMWac4f_D4u_g90mo7hRyJbLJU99nz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDA3NSBTYWx0ZWRfX1DSCIiALViNA
 4ddkFanTva96rBt68xKhWETl0/MAPsGBPo+XLwvC3BipqHb3/F0IdI3KNdPWT7xLeHxcCYPxhHb
 OyGEIziTkAbnqBQ7XtMjEISWakvQ72A8lzM7jTMbnK4dqnC646jxYPelcV4LHL4X3Lp13jSZV+i
 EtrH5fiMAmG7q6Tn2s0Gk0JlmP9GsHNJTZ/HUbk3O0YaigDxTmQD20UWc9UmjkKEV2CbTNDwXWE
 fq0nUVckNQQ7UL1Jm96FNAmWhw3gtk10X+uwynvdxD+z/5v+z+hnrKBBLWhaICJKfl6dCYtlDiT
 Js3a365Ai1HvzP/50PfpDuhpFNLJ9dmcWIskmelS3j4pL1qgOSivW+BuFSzwsxoz+gvMhiqBQei
 OaK2H0QC6Je4zgHMl/n/h/MqJg504Xfx2b6Edt4aM6s52U23BTq9F7Iew9TH3vNCuZV7Qvp/Qx8
 v/6TJdAEjIxypmn5HTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_03,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601300075
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1E1E140009
X-Stat-Signature: kjhajnitpp7byca6fui4ieqy5qfem64e
X-Rspam-User: 
X-HE-Tag: 1769765859-453662
X-HE-Meta: U2FsdGVkX1/sDkQYORl0793Liod0CwK1FT107bQQcEoK8Pn6aIuoC6njiloet742118PN7z3xysxwhYTtGSzG+cG82u96pE17ryhgCX//6dhhyEbpoa6AM/YdoPNGZVRoquXg6xuPG0Fm4NXxWQfr1SDWWa+XI1luDC/MIHi3Dy8rY1cXRskAZ/KCYiGcq75Tb2I+SgclSLN4UbP5FYin+uDfZTDy1mvx/tishm3LTKkwxhOjy0rFhgLfWFDBu7ACAXc+M+QUzCW0pQe6yFyRUpwqnrXbDIJv1EpKiUtM7Ix6dWuwoQCO1yOHXdTQuicgEmJmv8Xu4hHjS0IQ6I1/l5HZPxEOjFsfnbeecgVfbR9C9v7GpPzpWYgtpUpW9smly7nteCp+Tp8JAiQkfLqvFNa3ZXJBP6fsp3L6E6rk4OG2hPsy8kAQ8KZvEgNO5vSRKWm0AdyfH8/9Hybh1nf4fWNdyVQIKnHUhOz2MVC9gBLozrBdsT4wFn2I/uckPzLFCAssQu8icW+G15ZLgorDaJ8UMWjnzW8kd8MLJHL0wWvGRC9Ggy2E45dlL7fh9q47VCUIQdqMwviZncI1hea7VyiZVZtmsXmwn9QOlaHlmNkm3a1U59zHKnQ/7BECJWWl1p1eth9LoGhVdXLL+MXF0GPlmh7O8kbrlpPjMExQS+67katZhGS60Yuhu+vdoxrO0NoJQUPgj5g8RWovBSI0NPp9OzyF9VlB2AAzzPbgAVoTbjt/zbdlr0l3GB365GBc4VKivY/O0zLoYrFVyR5BITk5cMYMi2Lj5r1sVh9dRMj4zJZH2Ads0lAm6wt+4+tv2Z5dRnOcRs2qBHC3gr3rk/VhTD0G/M4ahJmFS4ID3uUFdvX/KBj6gfvZ9EQo4kQxaeG4rQCeaM7qCPp5Wyw9+isH28xBqpY393fqh1rAtIYV1v9W0VTL2LorPPOmOBfCq/575M7zxZDTLmqYfc
 PDfv0YbF
 e1fKTAVCt/3P/YT+m6Dx/2KFEQFD+3K7p4HhjnZJvhLd/GkrYVqhbiUY4MXRcrgfV9d+JleHbpXBsJjUSRiJDKudnWP4kMcIq7HeQePS7k7IY7zJ8FBr11mYzWJNJ/UWC8fwkKPOAbtpcp6sPheZng/DKj5jrYk4jd9QflKsKhwywwTRaXmWMw9soNWjxVSxqT5VQ837NrBFpbYJDq5acijJfoCbIgBld6pEecx8Z8Whlm0MOCrzZTR5ixGauYIZlUk74uH9N4XreOVWt+pP3inrWIRJflBCS/9BNfmjldTh+CozTX30Xlk5lUFgAEABQbm/3M5NZL3fXEbtDvi42R2F6HjBXHuuIaEng0Zc/61wMx/ATbg5Lww4hcaGqqZJ6YwX2FvMui1EekMSsgpFIfjT9fMYdptn3o+gPFJAcwsaPft34+MIb7cPPGKCzrBtNQmkgsK1OfcrTKjQSgBwIC09uH4MBXKGRRmukTgDGog+IFZRpK7P2/ZMCiDEsIlaL75FJIVDkz7NeCSZpiXil6mcOZQwhN7DjjCQG4rEC9LnAibHhkcgDd4pUXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the current->mm check with PF_KTHREAD flag for more reliable
kernel thread detection in scan_should_stop(). The PF_KTHREAD flag is the
standard way to identify kernel threads and is not affected by temporary
mm borrowing via use_mm() (although kmemleak does not currently encounter
such cases, this makes the code more robust).

No functional change.

Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
---
 mm/kmemleak.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index fb0022f34393..eb2ffbaf2f7e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1507,10 +1507,10 @@ static int scan_should_stop(void)
 	 * This function may be called from either process or kthread context,
 	 * hence the need to check for both stop conditions.
 	 */
-	if (current->mm)
-		return signal_pending(current);
+	if (current->flags & PF_KTHREAD)
+		return kthread_should_stop();
 
-	return kthread_should_stop();
+	return signal_pending(current);
 }
 
 /*
-- 
2.43.0


