Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AECFEFB55
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0953A6B008C; Fri, 27 Feb 2026 09:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053AA6B0092; Fri, 27 Feb 2026 09:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC366B0093; Fri, 27 Feb 2026 09:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDAFE6B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:07:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E1E613B690
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:09 +0000 (UTC)
X-FDA: 84490413378.08.FD057F7
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5CC23A0014
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ZhFR2Utr;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=kvaqqVbL;
	spf=pass (imf25.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772201227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYPpVEPSMuPPvaHEcnQ7Yq4HJ1sGqdK+u6ZDUQS96BU=;
	b=DMFAgwcAKZH28JlI5f4Xx7ngocoa297B5FJW3QU1Bi6/Z2fU3OUkpe46K5jM/sPP8k0VOD
	zVUbm7D3VKT1reMmLkIrfkETjyK4SiTW33cGr4XgfT6/HGev4nOJjlFAF4bzBJ7VSLnXBw
	isdQdwti1q3gtwlu+JBijIuRo2x1K+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772201227; a=rsa-sha256;
	cv=none;
	b=rJic239K+HGI67/4wr1e/16RhB4uAY7u5bTuCCUjCNr2fknIgn6PJ+0vI/jUnAU2sFFrAt
	KcFBbJdmA8iQGKOnTZkItF+a7GYhYI8uMPX34KRYDKQQIU+gEGmpGQ4Dy4UIADIxrZhG6I
	Lq3ELGi3IO058JsXgRphDIYTFtGkOVA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ZhFR2Utr;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=kvaqqVbL;
	spf=pass (imf25.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RA3xSH2403258
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=AYPpVEPSMuP
	PvaHEcnQ7Yq4HJ1sGqdK+u6ZDUQS96BU=; b=ZhFR2UtrCkUAz0Gn8NnIYKS1xLj
	lLZwdRkb1ryKwiwJgp+p+CdDigW441Uj0/CgPT8o1TZorNXDfZol8EhkzCI0IbbF
	EK9ciAWiY3oIEMjvCL2javeBjUVMJaQZ3ST3Y5G7v8RjS6pBtWYjFIHS/MH8cpn7
	NC0xtuD79zH6oUeDelnjpB4qaX9gxDRv94RJbEqX29oi23Ulq9xE+sSMEAoqASEU
	85DjBpGWN+7d2d8S7WHI+T9hdOBWn8mZLGqFqe8s/Fz6gmMSBN+MDn9VtjYxJLx3
	3y7jifU9ABBzF8xMpeMuGDhkArYgkuz9Z276NGoTuVs5yat32ItWmtytBHQ==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjw23b177-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:06 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d4d4db1523so11052114a34.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772201226; x=1772806026; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYPpVEPSMuPPvaHEcnQ7Yq4HJ1sGqdK+u6ZDUQS96BU=;
        b=kvaqqVbLyiYZ7G9GQSjGpOeL4TQIiMqa0kY6A9qAhrw8Wibu5cV+PSfoMG555OKv43
         b/dq4zNc7Co05rhmt6JJZP9X5lr/NEQgcalZSyX2P9Ao2UcEXEhbzfyHOgWbb/kF+gmv
         /Fgc4fJAsEXiWvIrzKNnxPgj1DV7WP9Sy+kupJsdegObaAOok3mIXjqQuszyALs0uSGT
         nK1qEagGehpvV/x25D1PD6DBMgjnNKngI3A1EvZ63AISWznbqRTWMvSG6ZGCueYIbI/Q
         rfttoDJMyucIHjvM5NtXpibW8TjaCtXvj0dI+PyGl7dxhYJNPw8F88kQSVPiquPNQfDO
         KkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772201226; x=1772806026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AYPpVEPSMuPPvaHEcnQ7Yq4HJ1sGqdK+u6ZDUQS96BU=;
        b=VPPEUsOc0owxYddsiZW+kmozqQprezGEVU3A0SqRi+eCqTBAhrKrn6Ms6cCL9vHsYa
         9Y3xRLTXbpw1MIovL5W3bXYGwF+aOphm4IElci72j7QTfjN16VD/CUk7fQKkqRXxX49A
         Ta7eoeo2QsQZzVA6CEPGpTKVtgxBMpDcg2c4rTmpftSTHpZvSoLePxLMewwhrnCDWLqr
         ri2qjLQq4RRYsh6Kl7aeT2bHdHuEc2SykriCmKCjIPTit+SbVtkT9JZx3BbXNEPWutnX
         vrbJnP3wYf7Rz2KzBbDp9siELWcfj1Pz0HLFHjX8eHaZlCIOjV4W/l1QTKC+WvJ4fCEK
         Ntcg==
X-Forwarded-Encrypted: i=1; AJvYcCX5xaW2QjZ37jR87EmI8egutculJyGbbLx0TGak78myWHI2ukAXk0dza+pzHKMdvtoRZon5z1qSxg==@kvack.org
X-Gm-Message-State: AOJu0YznL1nRm3e6cx/D3yWRyi2ZJdAlJoCa07HlSOF2msQL531YmZaU
	t2qVMdZ10/Jv+wkAARv3AhirhGYVFbC+OatQLq65jxMvjTNlPgmYa3skgbXgnt8T/gGUCBj70hb
	8bZcvl4Amj4xPp+8uziN0wUdTOokgq9tdL0T8/vjlZkhYXUrBHoHVyg==
X-Gm-Gg: ATEYQzzeeSUcLSNDeqXjz1hteE4SifTNvbmhQ/zL1k65Ej5bnOrzFOHSN7dNx1t0iY9
	G9sYYzx6UT2tPqStZOnki4kc/uou5vvuZzttHisZBEE0EZ/qAPq+f9z7ocjvpm/RsB8x0/Nj6JF
	Y9vPVr1nqZph3+zRJeQuN12SGI7ITbZSJ3rNdTOeVGOijTpBW6pziaIYP9jayFwTJI+pJPQ3fD0
	5m3lfs3/hlKIrujUX/rp+B2qUH5eWSCqfrbLrlNR92LTy6JgZ/G2qYjihyLjrHljmn2pM3MMWtO
	wiuQaBN5RRmlfvG/Q4g3G99Lrb+3AhdkFPPU/PP9+gPGMNLvqj/b8pFqvfiyuMuNIfuUw6qjH1y
	+X4z1JoKjCOSlXMZvRYCIRuZHJ9pfLdIC2yXWBFdS6V0DQuSiy5oUsVTQfC9dpAUNy9bKCM+Wjh
	7svbzt
X-Received: by 2002:a05:6830:67fb:b0:7c7:69c8:2ce with SMTP id 46e09a7af769-7d591be2615mr1920091a34.27.1772201225864;
        Fri, 27 Feb 2026 06:07:05 -0800 (PST)
X-Received: by 2002:a05:6830:67fb:b0:7c7:69c8:2ce with SMTP id 46e09a7af769-7d591be2615mr1920072a34.27.1772201225419;
        Fri, 27 Feb 2026 06:07:05 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866269a8sm4324502a34.13.2026.02.27.06.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 06:07:04 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org
Cc: mst@redhat.com, david@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
        eperezma@redhat.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/4] hv_balloon: set default page reporting order
Date: Fri, 27 Feb 2026 06:06:54 -0800
Message-Id: <20260227140655.360696-4-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ePcyoF7Ca9VoCWbespq2F7yzvr3SespB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDEyNSBTYWx0ZWRfX7sUWzCin10vx
 +dMCQgpHXhqPornaqTmTi817pyHSDIJXzVkuYRjELuQ993zvQr80qkIzHcA4Q8aZ0eAyyn4y1TD
 s27Uor+Zxp/NNohGQFaNDtJBwKiao5YKyF/XhXkfTExsrSBPMhePPfe8q9Z5Mt41zhomLjYv/hE
 5cywdqq6+JMKUySFYJ+sx3nqLWMtiBZlMLoe98vRpEWWZp/bf9NnuYFX2/c0NFh4/Bm7AcvtOU0
 JrdsGini8kfZt1I2fsd++R7qekimyPV22UQoNc3Gf8Q8zHNHdN1S2BhhVbdfpz7X2aHGZmO4D0r
 UGeV6acHK7x/IPVNDQ23HdVVFP9ibJbROei1Ct1rsRAuV8qll+6IfefQn5IZhL9/KDcU5AVrrJM
 +F64cSRUdemxzNAGDPhDvXDCnVOlVkXRZ7LQQF5Zmbp14cL5kh7zfJsaa8mKY/Znk90/F/XKl9g
 X476a+0ddKS5IV3ErRw==
X-Authority-Analysis: v=2.4 cv=cJHtc1eN c=1 sm=1 tr=0 ts=69a1a50a cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=yAl3Rinrq36N4FMOn3wA:9 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-ORIG-GUID: ePcyoF7Ca9VoCWbespq2F7yzvr3SespB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270125
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5CC23A0014
X-Stat-Signature: b1jxom7h99mu43ma5n1uomojj566nb9x
X-Rspam-User: 
X-HE-Tag: 1772201227-652572
X-HE-Meta: U2FsdGVkX1/Dt8lTk8tuySTXJwqUIupY0re2C2GD0I1LJ9ndVI/ne8AjZzT8HQBCbk5dhloXqGMyGRu9N707pKWCnGrEsvnGVhkH1STqYB2xv6pZhkQmOODV8iMUv5xj1eqtecQAGTxETYH9kr/bax1hR5R3QYQpFlo7LDO2Z3r3tibiw5k9cF95iKyDLaIgMvyv+BYPO8DZLRVP//cKj2V70s1ZFHGXmkacO9VcvIqpUMsxYdJQIwlfkRgJoVLFjmWja8/aaLPMF9t8Q2evjxEFt4hNMjaWzTF3aba7Op4g15tJL26DXenWFW9/uE2F+gyTuo3Lq/Co8DtZ09qNvJ4gX2mCchMF9BJplBo8RSj1d+UDlyjeOAaps5shy8rcY4WegdxTSOmoJLy/CS5MrRb86Qf68aieulVwpqW2rK0vlRVr/QMBRe050pb4atZ2TALtiylyyAsny8Sl95k3KAW0H+Tkbe7NvFMCYFsTKAVpALhFLQjWVp+8DLe/GQiG4yGg2cg6/w9Rn/uoGAmFzXWP0MbU3eNX6BTnDFVLs87WjZK0V2R9u5gju95ZcyEF1Ujh3a7lc7TRwTt3gYj0aO8wdmQ/lj4kgSV0ufwYQQsuN4Qlnlzsh59G3ISCOow+R4+cDn4LPOTeniQ7TK878Cyr4h1ws+RXcm94k818u9k+7Y/6lZFCTuym2wCuY0B/vWa/d/Bm7j6Oco4ySibugfiEHDh98fbm8STX+grzRSQ1HiUa1Vfjgl2N2Hter5m55T0PVIQdBZhqk99HG9XxKYO5arar7NObTMrJ+v7z13JF8tJ4pdngJC8/yEeRktQ5+jd2hAKTMExTyk7GMeJJ+bPMvkoyns3WpslbkedyA5Si6L/Kp+uqH7cMvf8ML+RIN8CqUGHLS1Il1R37jwFBfhqeR0GC9mM5jYNbypOr8m/sHcLaTbzI/kETbD0LsAelDunDy0nYHEvSdsZ6AMz
 6XvzJoEu
 /m7Jjr2u33syPUOFIRgoApbuQh4HEsqaprpytSzJDwHdWNRR/NjO5t0E4t133sN+VbGWLngWaX7PcUiaBoQRKzW/P8I2kulN29F9MZ7DFNiee9dI/9iSsvSH0UiSuxq+aWgIa+aBM/5tMNjeHXMMGkQAznMoqr8svf/z63/aKIqUGYKsYx2CMErrP8vG/+f8wLmrqlZ6RKHME5WZW2WBWbuItBq2ofPum3QmrteciVgCrvFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Explicitly mention page reporting order to be set to
default value using PAGE_REPORTING_DEFAULT_ORDER fallback
value.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 drivers/hv/hv_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 2b4080e51..3d6bd9936 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1663,7 +1663,7 @@ static void enable_page_reporting(void)
 	 * We let the page_reporting_order parameter decide the order
 	 * in the page_reporting code
 	 */
-	dm_device.pr_dev_info.order = 0;
+	dm_device.pr_dev_info.order = PAGE_REPORTING_DEFAULT_ORDER;
 	ret = page_reporting_register(&dm_device.pr_dev_info);
 	if (ret < 0) {
 		dm_device.pr_dev_info.report = NULL;
-- 
2.34.1


