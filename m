Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA14E9B369
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52266B0092; Mon,  2 Mar 2026 06:18:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A319B6B0093; Mon,  2 Mar 2026 06:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA836B0095; Mon,  2 Mar 2026 06:18:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7207B6B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:18:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29F7D8CDA2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:09 +0000 (UTC)
X-FDA: 84500873898.22.26019D1
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFC48140008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:18:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="NLOkFwV/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FRNFOvpB;
	spf=pass (imf26.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+0kgesUCMdNFr3Yx0NR7alJYMdhJUrTkNwgNL8Q2lE=;
	b=PNH3ywHh6pOsQTlLFE4su7w27nspfy1Kjiz829oDOEI6VON4IknNk6f9xJPY/bEeoAvtRY
	FhFzhDuHI7khNb+PZB/BcwW/eo5Hfno4o8zQgV21I6kU4tfa/qaS6lx/n8A+fZCycIMpQW
	t7ijppM2gmFseI2qOSo2Hwem+LCoO7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772450287; a=rsa-sha256;
	cv=none;
	b=xpaytbi4EQamXJduF1uvJ+BeCXiB1LBjB0id3F97k10yNIoHmrKc058rcubaiAVDjtkLYr
	NJp6N9toUkGTLmwSiYwD1aaFjMyvDnLu1CMnKJ37CD6ZCMom8uqiUs70QOIH+ibcyeJA2j
	tznnCOr8ISoaOmgNHPQX+w/QnhQMJ0c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="NLOkFwV/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FRNFOvpB;
	spf=pass (imf26.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229EnOo3630795
	for <linux-mm@kvack.org>; Mon, 2 Mar 2026 11:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=L+0kgesUCMd
	NFr3Yx0NR7alJYMdhJUrTkNwgNL8Q2lE=; b=NLOkFwV/qYS+iMo0DscBtUWTvxW
	uynYI7C9YoIbmqZ5kSpLlMNbm7xLMYD6N1VtE9isV/qfRXK/6B6xPOFIB9+k/itc
	F7HyggLQqqUEkToi4Sq/dFUq2Fs9Au6In8tY6kPeJGw+6G3TfGzeg+J/UUGR3Cmt
	ZmDJiGlruKDuiML5aPWAhwE6E8tuL5cxuIDsOYMaIaGbHNKn5dZIit+N+4U5m8U5
	tNOiT2l7HG4wMLL8QpTY1Q/F4xXayEsyIpZvXflvaUWt1WPh0kT9H1enSC7BH6io
	oCPO+453jF7rhTW0Yxn7GmqOrzmlHGel7jGvUfvI7RVJxwc7cDSVtZVzhIA==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7rhre5f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:18:05 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-463a7f204a7so54140346b6e.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772450285; x=1773055085; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+0kgesUCMdNFr3Yx0NR7alJYMdhJUrTkNwgNL8Q2lE=;
        b=FRNFOvpBPFJaOoSZRIvZhngbY+HETE19DMk61vXfcrSeKIrj7A+mlZ238qihiqGMLO
         veihvGQdr3XQGAR0v9EPhwWo6M+WSK3VGUMm/m/uBIrl2+I9yiVZi5a1aOtlP2WzZWzR
         ATJ/yhtipRRkpvyl3FsdHKPWnzDnu2Stx5hOF0OZGHRXjeynV45qGf7pk2/02vPdUq+0
         WVYnEaWWqdn1zJ5fcALMpvrp3SYTMm9BmNJyUqEkLxS9DfMNAtd/hVhmjKrAIWecmKmr
         k4e7FA1ITMk0GL+waYDBTtXAQNBIF9oFC6e/8pt09/aGUf48hZZqgskjKJ9vV9lULeYd
         Aang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450285; x=1773055085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L+0kgesUCMdNFr3Yx0NR7alJYMdhJUrTkNwgNL8Q2lE=;
        b=sh7CVMx0gAWbNaVuxrqQE22djs5pSyaG7ii/Mg7+ACtZ6/S7E0z29vA6e27bEPIrC9
         qJ00+v9FFnUGFuazbPC+1/bwpluQ8nneoL51//2MGl5Skegn8aK08K3zg9lE3+uygcBh
         BqcWU/WVxwGdeAahsq3v0WROzS9D7h3kstHEdBVEwpLZjbYF4folI65O8l5RzHwM/acq
         9TWWLqwz5FKP3/jHvAMnoKELORn3ASS332rpxmBrLGxanyzGloEqARndVTMtCStFllRI
         CZEe74FjnRN31c5yO6edYD63NgvtE7F63NEdFjzIg3+TIAo0g3TGnwQFcO+QB4Ytw3Zr
         YR3Q==
X-Gm-Message-State: AOJu0YwlTqFL9E8B1XBA71MIU8qgf+CDsIFwobCDoc2w5Sl4N3sdjX+k
	TBoTGvCBnT1uOHby6zBt1POXePJagu8CpiOPiy1nWW7DuTm7gf9+LmEdGwNCxl3ooDPLrFbWhC+
	kAOVGIBgy4NPByVExEwnA9vcrlyQEaFkHcpUAeNhc6TEcBzAPw6pY+A==
X-Gm-Gg: ATEYQzyVAkykp3nq3mmIYtMrpJ5/5OX0wqKp9b6QmgGMHf3HVP9eDsvphLy6YUFdXuc
	TaF/6rISDJP16Vou4/kk6Zm7OIMZndegZQTiNzzsr9WtIYk6kK2D91Juw0x2jJKAhOqY5YsK3gp
	yRuL+P60ifEVf8P7JNiPYSih6ETj9DQe4ZBXckCdesjrhzHrZfoCu+2LLdUwaiqbM4KOovlXto6
	p+AyeuWi1+7E56gjkdeE2pyViv1QQCKaVAACdjpnXRQ2TaLltVarERvcBlMSf8PIyR7m41WVlKn
	SzvhYfBLB7TDRqk5dFlMRqi9kn3+apH/mCyyF61P6YiKv2TkFwPLKzUr4SBXwuLM7G9X2rL9HXB
	ELi4BhtugcmVbxPdSs0PQfprYeJAJXZOm9eSjLIUJ67lAj9s/l4JulsBGZFbpSvlGf3VsroPgDJ
	mBRkNa
X-Received: by 2002:a05:6808:1999:b0:463:4196:3d3f with SMTP id 5614622812f47-464be922ec0mr6157820b6e.7.1772450285338;
        Mon, 02 Mar 2026 03:18:05 -0800 (PST)
X-Received: by 2002:a05:6808:1999:b0:463:4196:3d3f with SMTP id 5614622812f47-464be922ec0mr6157807b6e.7.1772450284836;
        Mon, 02 Mar 2026 03:18:04 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm7354528b6e.10.2026.03.02.03.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:18:04 -0800 (PST)
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
Subject: [PATCH v2 3/4] hv_balloon: set unspecified page reporting order
Date: Mon,  2 Mar 2026 03:17:56 -0800
Message-Id: <20260302111757.2191056-4-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: eASWly27MliS0U4Hlv83aK5lqp8NuWmx
X-Proofpoint-GUID: eASWly27MliS0U4Hlv83aK5lqp8NuWmx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MyBTYWx0ZWRfX69C0VCdxBJmL
 2TgGyfQ/ixg7+zGlsg5bHHTi4ojfWiIRDhsuLt4XyQmUrzEiYtet1TMH6UImnk2lIYZAVfDy5PB
 S+I/oHleXEdn9d6uY38thU0e9XUKImCav0wGf6nFVTLdt4cWyV43s6kX5wCK8r4LUp/dyO90VOU
 QVjaHKICfwMXX+87DjEkrL94oTtS6iSS/ym+6q7Q/8hIl038HuyYYVEGBlIE46vZ5dsaxL8vCsS
 tbURUtTwdyQ71DP5uLSmrrkEBxxGiHAedRm9O8ZbkHm9+dRVG5QDYPR7YQLQS6Xd786UkqKtEfb
 NA+GqjeRmOmnAD3t87Cye+sFwWlpsP9wOXkddOApnqaP17TGh9myIVpvWXBQ6614j4mSqG7mA/q
 eEvt4PTH+k8JtAiaqJnPBHdDJLNpfIQ+tOVNNG3PK8U1gPrSqCu9XrQszpUs7OJPSMqZacIdbPF
 BlUbQOxy8ut+rgHWMJQ==
X-Authority-Analysis: v=2.4 cv=cLntc1eN c=1 sm=1 tr=0 ts=69a571ed cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=yAl3Rinrq36N4FMOn3wA:9 a=TPnrazJqx2CeVZ-ItzZ-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020093
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFC48140008
X-Stat-Signature: 5zd4gjq56s4qbcy4ce3az549wh5dwuzm
X-Rspam-User: 
X-HE-Tag: 1772450286-976386
X-HE-Meta: U2FsdGVkX19S9cbXPmdzR64YPOc7R+3KJxazUdHtX7knAKAQaAVt9khaHcCW87u3Ic9g0C8iCox9IzxGKpVSn3KbTM+UFgNchp4eLWgiDqH8WrZbN3PG+PrMSKmzdC+ptQDU/RZ01UQ4kj5SpiYgfSC7z4DYbC0ypKn85XQ85Nc1Vf7DNdIOSla6DLI+qTW62+gN9Neaw1bUBw+1I8hFi+bXdyIXL5HIGOovnbkL102Oacc947zikLqIVC9w4y6z3ITK9jBeS/TqYZ3dE9+l577oXCUh5D5r75WbStFDdFoN6vJ3+0rPFTRONT7g6CPDgxpSrsEODrAG41YHFDEC3APN0Jv5+0lXnj7gkSOKORHaOs5umJFl3XIeeYb4NFOeskO79fEmiCWgrSXk/DVN8+222OWHy8r/j61zUqbcu/2rr3cpmnje8TelEUjc/HUq5DvirYhwpHIMcdt/yT3/KChucOgGLTz8eqt02ZIjLI689WHQO+9zi+4Doh9pZjzsNt4FZneC69xqaemO9jQLVn/tTkw7Tdj4rG0ifpYyeKE9/ohcXpG5yVkNfRsL32h2KFa+1ziT6OjQbgZGDIvZxYcFgEasZnb4hEDweyqgibbM6qKSVvFK83pps35qanV4f5pGcKxoW3t/nFGAUqg3XosYNUMe49b93uEBmAhqyEzXhdq0MVLtaEpTr5pyyv6PWihiUl79WgJOrSExgiZxQcxV1G7XXNHdlBf3i8dlMDtm9LYSpC46m1f/wn274IoC8NWxRfrPBX5JtwKK3P/s534O9vAJoC545QRhOQyAqOUjYK8YkJd8F9fFawywDZec7dULxRe1AfsQkJDk8zGrfRbkRQdoGPntxfamo9nsBd7dtJDYSzN0v8KmNCqbWn8ZWB46GAg+nOEGP97q489/jei7arUYUf6NuItgQnOyR+ORTjdzFe32p2vYs/6yDWu1a+WX2HQQQsW1G/AhGBi
 L4fWNWI+
 qMTG7bBq/1WSYRGSNEmrgSQRASCj/QcuL0fzKbgFVSjPLnePZzIL66gKYqxEFwSBD6yUDOwsiz7InG71ESz+wOGRchu5GRHrOj9jED8Gmuge3fV88HlAfPSfr48XdZSXRCzIyNp/lj/7Ziy+AMAc0ngchWI9F7ftvJMEnYfUV1L+5lErLVZvRhcnMkM7PilYmdty0IJBvudCreTAn6qYJzB4AphTsQpRkZQvJnkpLfCozGpml3Eam+p5TYFx3LnMPagaubtjelv/EJp6yG915/AzLCB6ZHGgICRy9peWCPFkuB4yxvFEePf4+BduqODsGubPz2dfyP4VzYbCIQRNGES8n1CaAicRJIEU7MAsursr5UONUa5zc1hWKXsUxyvxF4aVx+VU/Gn/sxqNcmtm8/jZuDkKs2w3HaxaiHImp3WorzQdbA8RrNXZzVa3MzYvr2MTjYs4SUlOszvuERqef+s4/gbuhaliSIMiMwvU2HRdClTRuob3nedhtvx1vZJnMJXnjPMyF2C4a8jcaMZtcSR1X7h+R/185mNw04tQQD1UwuE4d+vMaJEzpkpdw19o0blCF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Explicitly mention page reporting order to be set to
default value using PAGE_REPORTING_ORDER_UNSPECIFIED fallback
value.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 drivers/hv/hv_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 2b4080e51..09da68101 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1663,7 +1663,7 @@ static void enable_page_reporting(void)
 	 * We let the page_reporting_order parameter decide the order
 	 * in the page_reporting code
 	 */
-	dm_device.pr_dev_info.order = 0;
+	dm_device.pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 	ret = page_reporting_register(&dm_device.pr_dev_info);
 	if (ret < 0) {
 		dm_device.pr_dev_info.report = NULL;
-- 
2.34.1


