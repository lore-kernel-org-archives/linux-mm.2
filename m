Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51911D49C92
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 09:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 454966B0089; Fri, 30 Jan 2026 04:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D81F6B008A; Fri, 30 Jan 2026 04:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A7F6B008C; Fri, 30 Jan 2026 04:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 107196B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:37:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB4BE1605F4
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:39 +0000 (UTC)
X-FDA: 84388127838.05.51E0D39
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7512E40005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=oVZ3lG6g;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=GP19q89t;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf07.hostedemail.com: domain of zhongqiu.han@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=zhongqiu.han@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769765857; a=rsa-sha256;
	cv=none;
	b=2oU97QRH112Xbgm8H0fguycW59RTtbGRhhWT0F8BI2vmWUiJYNSW+zVaSBRLKrqcqbzyyx
	ctWkXP6Iq1hzydQAy1yEOAqGBuwrdLfPGcMJy+UAa8mcHESs80NaD0Py8047N4YsV2ZYLT
	ba/TprM3gLT1pTmG+H5cOQLqc4F9a1s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=oVZ3lG6g;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=GP19q89t;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf07.hostedemail.com: domain of zhongqiu.han@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=zhongqiu.han@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769765857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XU08q8/C2kZxGTnhOPa3fqJSlKJ8o1QoEwjh9V6wg0c=;
	b=YePzMjMP7cxHl07r4GGLCgf4DBssLOAYvxaprlS9CyO+Gul9vjmsg+ZU2AnLI499tdh/Tr
	Wo4yZ/ASgLRdgeGhwOHPx4Df+D9Dnf2JNREuWxS8wtHNcVRzJg4op58SYXRSvf6/SnY1Ee
	kZFoX6inoe3N3OXBuOgBMsUXg/atjts=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60U9UxFa2675368
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=XU08q8/C2kZ
	xGTnhOPa3fqJSlKJ8o1QoEwjh9V6wg0c=; b=oVZ3lG6g7s6K2XIPO3SSyDi3EyT
	j5ozxiJQFXh7xOMvRb06nT8GnFBU08RRQP7HafBPLCa0E33swv8an1h+8Q/QQLjv
	/IVxynSesajXVwKE7tWRB1U4GUvupNBdJDsPvMUaiTeNmIRqF2ZHd11N2pHKw83B
	vXEdNISVBmLJmzQzFjPtaTQAoGEEvGoiUQmoqXeVDUpIxAi8WhFpQJl2P3nXSJR6
	P2j3bRIho01iJ/ZgvsGVcv7yUy7SZxhWchpxmIRoWTDrlIYEaZY7d4BXwRzSpE9X
	1xnpq66pt+cIsdxtanqr4TIuM9PrA9ZFfV5+JGmbbEm8EXGdwe7T0TLrEqg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c0t3400rm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:36 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c6310f81285so3032749a12.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769765856; x=1770370656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XU08q8/C2kZxGTnhOPa3fqJSlKJ8o1QoEwjh9V6wg0c=;
        b=GP19q89tOD3GUNUpLRtzjVtJ/RIwOyGZ3IsTZ3snjaUgR+9XdtfJND8h6Wsyu5HP3u
         Ke3VOgrYmHbgYR5qb9xVReO89iDIKJXxNSDqb4hMWJORsZZ/Yb8EtH3Tb/dKaYA6usR5
         Ta9L6YfiP5jzLe1JGv68c3DKFMCKf/4x+O64VZQ+pWiUIp0iErHoQIVw0yHRXNFRjv9P
         s6ViVgAHK162wwLARKUb4qg6wlw7RsEYMO/mRYuS3ZSqy/5znnLloZ2xAap15hS1897A
         8nyKWqc6i2LxRUFBoko0xuhZyzY7fjcVB45tDO4SKAGZPP05NSyQOgU1pEQ3OeeAp8+Q
         cW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769765856; x=1770370656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XU08q8/C2kZxGTnhOPa3fqJSlKJ8o1QoEwjh9V6wg0c=;
        b=AMXqw1szqDl0vRJCo4X48nVXbjz0vmWbXD5cJs/hfTEdjigN2vG9MKAOFNwXeP4JRQ
         8VGG3/aU3cAZXdrq4ZbjuEMxZhTBYA1fir01rok/erRlK3LrDlmGyVe/SOdUfHP4uCPY
         WGiMHIBLZ+CewWp2D5vVZFwdkZtXHVhSml0IlcGPlkzu3KuTD8VK9T/72PxVm6xcUCGi
         0OgydfGTAoAGFYcIKaqdk9gUev1h1cdbJsX3KaGU8yPTrP2FX/ZxJU9r4azU/xtS6wZ6
         cMnR7PMgOSFtj/JGNHvphO9NGmdI7o9HDjActA8iwz8/cZEBsoAB+0aEX+iKIUrdxE2/
         pIqg==
X-Gm-Message-State: AOJu0YwMUGj5vwb5sNe+sAZDGUliOUb0Xq34ODAal57ift2XLOy/8L1B
	kV7/wSt5bg4JM15L2JdySB1FlgET9OmsKLRhZ2GcrCKSnh1VjKGjeMIxgZvfIFBRgJpDmUwS7qp
	O22o+f9/37XS+wQr07HG1/5gidbcnKma0MdD0q3nwzR7/XtmXfZmgJg==
X-Gm-Gg: AZuq6aJ/PvAAzjyt+Kbtx6xsDy1i+bQSUa2lkmG9fFvsp4tlK1g+n8Mb4UTxtoB4ZNu
	W1jyjrzEdS7pW7n5mOyUSQ/23lsQonzM1jQ2bZr+/NrAta44Voy83E4uvWXVq7aC0stT3psIuZF
	6ynLG6pk3CVCidR1I4ZxMsF4+8X5xCe8FLT2ejhYQ0IAXwzm3n80+cpYVIl+nzc5cUNXcLYanld
	l31FnFYIouBif2RKQZLZdNJ3c39LSBrOC98epSPigdk8dzggRBaRzEdnUuRUtdS0jT3P3mUHt1R
	ixcAaW2WsnsQmwHPnQ4dTxPo4tSibmuJjI4KK1rj676pg3R2aXwq9GCN0KDEkATiMevSpAzZNOa
	tdubS9T7RMF0hEPvXloYCrBQsMvXTCIY2LIqQuZ4wLpv2uhGNcHAoZblBgy65gd6UZUmO09Uast
	NO
X-Received: by 2002:a05:6a00:14d4:b0:823:bbb:76fb with SMTP id d2e1a72fcca58-823ab755b53mr2081844b3a.46.1769765855530;
        Fri, 30 Jan 2026 01:37:35 -0800 (PST)
X-Received: by 2002:a05:6a00:14d4:b0:823:bbb:76fb with SMTP id d2e1a72fcca58-823ab755b53mr2081818b3a.46.1769765855046;
        Fri, 30 Jan 2026 01:37:35 -0800 (PST)
Received: from zhonhan-gv.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b49fecsm7650432b3a.15.2026.01.30.01.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 01:37:34 -0800 (PST)
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
To: catalin.marinas@arm.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        zhongqiu.han@oss.qualcomm.com
Subject: [PATCH 1/2] mm/kmemleak: Remove unreachable return statement in scan_should_stop()
Date: Fri, 30 Jan 2026 17:37:28 +0800
Message-ID: <20260130093729.2045858-2-zhongqiu.han@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260130093729.2045858-1-zhongqiu.han@oss.qualcomm.com>
References: <20260130093729.2045858-1-zhongqiu.han@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDA3NSBTYWx0ZWRfX/U3lM05uNrZ0
 eJoNjp73LgBb/QTFjPx7S1H/pw/8tYG5AEJHdAWrg4S6yqPIVn4oZoT8qPcCB0rXX+zzAKS1e8A
 smdWAUzMykpq5IRlcfz00RGQ7/5NGGpWIMFrfQnTzdaQBJKBNFWpRKuK5k5Q7UnE9ikLruNxyYH
 7Tm8JtWWlqIn4J086tHdYB+qzMxoh5ZvDvT2b3HNRtuHD1oRDJhSauL1w9FUziTznEMXH4qkHhX
 LFgFG1ECe6Qn/a7XPSt1eBPHzYpzhB50+amsmVGkgo/uGbqOMUduzRHWhbQ6zUMjRv1eGQjgbKP
 fgPLDyvTd5xR5waW8VvSTGiz2XwvBfAKsEIvsJUskF6BESleGlMjkyD6UiUjqGQTvaKZ+JmWFoO
 y3lHTJds/LDA85h/7X06SWi+xVrsq0p2wXWLXJ0MMxArbUlUC/x6D+BJkJ2/XpNiPugUYOrXc+T
 Ujr33nycRJezyM28DGQ==
X-Proofpoint-ORIG-GUID: dLi7Tr6NqjrZ-V_bJKYM3C4ujgWkweIj
X-Authority-Analysis: v=2.4 cv=QfFrf8bv c=1 sm=1 tr=0 ts=697c7be0 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=M4yuILNbWragLVBGtl0A:9 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-GUID: dLi7Tr6NqjrZ-V_bJKYM3C4ujgWkweIj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_03,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601300075
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7512E40005
X-Stat-Signature: cywczakjwoed4kmy5wjbk4hzik4ssp4p
X-HE-Tag: 1769765857-528083
X-HE-Meta: U2FsdGVkX19DQmIFOT+FvCXK1bp4bF7pFsT36DfIWbkFIxneaW9uhoNJThPPLKqvZYEuyNPucJuFDZzZLdxYyym/dxjA7G5PY/j28YyCcRlVbHNLz+Lw5wDuNgaKZzuLCWd2tfyGLoweoRGcpQioIL5Gp3fzt0WFh37/rTVJeFvpGw2HcDWefx853QHE+9HJaP4YNNWWMagi+2wrzYWFBwmbFsQR37kun2m6P7Y+Ctuw82oSEG/U+J9rd2vGRYKQIjioSMidN7bUvbikXDFqh7JzbAagEZv6VtP3uxTbRlx0RfhbxKlIkccOuMWoGwwUlUujXfLMabzOjUQuHXhzCwEEy82b8D8N9w7kCPCo5IkKjh0uwaKD+pMWYu8bJVzVpgLiNUinApz7/yeSifR8RqC5mQRTI3qsdglbW3kpD94kgb2HYap81R0uJaMyzcqjXsExvvs3RwRUMnmUHy8xk8IwTLYzGPTwvRy4IkSIUHSoTBUcwQucAvslUrPpcFWiQwqAiGhC2ICEK0LGI+8yhpVY7qnbSXdHIhruFONTk5NHCDawO/p1HHONRwCQMr0j/u11p81gk6qkFlVO97/Wt4uO1IfdWSFfQeF5SO/FNi/mgQo0mKFsuun6QRLs59C/ouNi6tv822RZQawn3d5m9vp/oJwraUlCbyQQhwQGuTKVAjfpnKe80drxSysxcNOrTehYNKPs0Gd9pnYtieIaMhQuoLlp7T6MSqBiCDrht6oiHDJrb8on1oW25L6MLckSdeKxu7dkr+nwJrC3zEbmoo5s6qV69telpu5uJkTYYHM+Y8kt3devqI1U9XT012CNHfuo5yGTeeQBrz3ppaXM+WFbmzdEcaWCZhV1DIEBeHdb2/mO/MjUkmR5x8Epl0vBjeX1rewZjNaaS5Ys9qxnCbQlrCoZoj8j/c/aMC19+XkOPRgf2JzIBAc7SdFxEjlU73o3CZ7Ce/kOuQrR1jg
 +rEKj+23
 j+PRKZPN+o0740l8YfEB13s9tLHwJODnExynoxsiZRP81aZG0omx6+YmlBnQYd2w61PvMhd1QL47nAV1zAUmfQaixGcFSJfDvoP3yd/9tgj834S55R8aJJd45YUcHYveTUA8X3rOcky/onBOpWyjb6mxB6AtoT9+aSP6oQq/8kL9ae2ql15PQRQk+GvvlXT5/pH7bjjnBhXvqRlGMStn1NDd70lWZhr1BgiZxhgdCYwVVYfyhBvr0Fz2X7ZlsHUcGxsebDuR3hW00EgHxQtK60VYrlpRxaP4nEDhT/AGYGSu6I+i+ah2d4CBSOSzuU57eOStGn0BAnZgKO+9HTxlzEUxUsRAl/20t1I/E80W16RrWBcOdZY1xvFlziBbkoG2b3M4yTknAyK9futhFF1FDU11rvLjALcHGjDUb0LB37BXTvqdtrBddXGcxUP/1x3uRh2EOXPUjIoce3dOK9WSEweVmDhUJT3FHybqlZzjqcRC4a3Cm8ZBk36Cvfv9c0DYM6MIp7gl59HJVVopUoUR1Fgc2u8lz4FPO59L3gjageHPw/H+VPB9xhywGkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove unreachable "return 0;" statement as all execution paths return
before reaching it.

No functional change.

Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
---
 mm/kmemleak.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index fe33f2edfe07..fb0022f34393 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1509,10 +1509,8 @@ static int scan_should_stop(void)
 	 */
 	if (current->mm)
 		return signal_pending(current);
-	else
-		return kthread_should_stop();
 
-	return 0;
+	return kthread_should_stop();
 }
 
 /*
-- 
2.43.0


