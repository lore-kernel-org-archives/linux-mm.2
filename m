Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 800D3D3515E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF396B008A; Wed,  1 Apr 2026 05:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80AA6B0092; Wed,  1 Apr 2026 05:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47F46B0093; Wed,  1 Apr 2026 05:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6906B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:22:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F10413B944
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:22:38 +0000 (UTC)
X-FDA: 84609446796.23.7C9B665
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011068.outbound.protection.outlook.com [52.101.70.68])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3672B180008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:22:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=dCo5onzu;
	dkim=pass header.d=arm.com header.s=selector1 header.b=dCo5onzu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.68 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775035354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obl7m4dYfvFPJQR3BzQuzNHkPhjGc0REc6Bs8XIk1To=;
	b=OIptBTYSbLduaagIcLC+MmUQy1nTJ1rzuvF0veSNppE2IhwZHf5nnyDsiDXCV4mjcj1X2Y
	NJUty1d9I4rJYkDJBsloOAsPFmGcDK2j2iNOAUcbjS5iclUj7xbroumj39R3DHs6lsHjH7
	O9YCJCP636qr5mlpN+bhgOiQp5u/LFU=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1775035354; a=rsa-sha256;
	cv=pass;
	b=ktFc2mvL7dfSD3V1NWaggyvZqm6gN/AwLOI+XDrnuvDlg/7n8PKOX8SciMhIjKULb78VPk
	jPMT0C19S9F109P8mmEzpfzKSfbRrLtco6DkdHXpHRtaB3X0ojqrfIhlftUNDcBPIBMzJU
	AA3Jjxg4SnDTXDYIx3XMfNckAwUykyg=
ARC-Authentication-Results: i=3;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=dCo5onzu;
	dkim=pass header.d=arm.com header.s=selector1 header.b=dCo5onzu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.68 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tU9OsJloHdbT057B24lDRX9pCPoQ73L8Rd9nGFKEGaiiMna/Uovzpi/LMYdx8fmTigRJKiZpu7OyyjfAmQr5XNr5UluLMN8K1ESq7ShY9d992/tMq1iJY4/TAnroSXZZmzYCnRZwriufoAZ835qCGC+9cVrPwAyom7TEFKZVgTpNAkFsqrkmQzYbYios8+hsM8PPPOTRd7eooye6SMWokxceIZrxf/b5Jr3Da/fYS80VWWT0BIqk/BB/LywMDZ0lt2vBjQXWVm7jTtJ9vsYuORoAUSCG9jbt7bn6Mbt9JiMuhqd1DPdfP9gBJbKIMKHSGXkNuluyYDUCKE0iQU0Fhg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obl7m4dYfvFPJQR3BzQuzNHkPhjGc0REc6Bs8XIk1To=;
 b=vr86MXzeco/cV02yhjhWxAkyPaCWENGdVHTaOmIrpwqie51l7QZFSla0U0pSg+usGpGoBFCe+hLnK84MaAQ7+Vsb0J+EGaeXaCK8GDCg+INUDd4bOsy9gMU9aVTrESDKxLKIInXQKzuOfLEBpD3gptOQE6PRXA4vVDUnHubakTQXS0jZwokAL2h29YCtpl9NQ4+ggYhxUhm/5iqjxnP4aEG4e6CKO4z1JnhUJgBm2wdw7oaJCOL5Ao/RaOmBz2L0D8D0tp9d+wupSn42AcAPyqd8+2GKQfN2q2hZpQoTJQ9I4ZgBBeDBe8fN8g3MCE+KUlprm1+/SX6hCVKj1OjBwg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obl7m4dYfvFPJQR3BzQuzNHkPhjGc0REc6Bs8XIk1To=;
 b=dCo5onzuTj3YqTwhu98GL6SbYY25o9FHKUDxFG8+glb4cuCr7aYl2SNGxlaVLYXKiR2IwKJIeIQArv5dSWhVtVvofwY43636O9ItftcwPCWlWFC1/ffPRT0wbjktgFjiCOo6n96KsEEnpE6vUT2E1BXBL89FDIOeU2qL1BKQ55g=
Received: from DU7P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::15)
 by GVXPR08MB11351.eurprd08.prod.outlook.com (2603:10a6:150:2c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 09:22:27 +0000
Received: from DU6PEPF00009524.eurprd02.prod.outlook.com
 (2603:10a6:10:54e:cafe::dd) by DU7P191CA0030.outlook.office365.com
 (2603:10a6:10:54e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.29 via Frontend Transport; Wed,
 1 Apr 2026 09:22:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009524.mail.protection.outlook.com (10.167.8.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21 via
 Frontend Transport; Wed, 1 Apr 2026 09:22:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWyFmzNRMTjurbU6W+eMqPNie40g5Wqc4MteBwebjPHdf1hEzLmyEMMmSoXgby9p6xjdorufcg1+1CfSjvo2DSEWX/oBhYsP2+nNgfGBx27l9cjFcm09Cxal/Djmep+H7IkorQJsJDH+j0JDNIU3J9XaZ3kAx98/QInStcZQDsT62j2+A0i68O+d51L5nChoEexmhSPJNU91tMBOggSCob6UyRHjUosikIzLqIX4fHZqEQISmBqAEhbtPRC/meD5K3IFvXO76AudptdSZAbB0JXRjeubj0iSeQVrwDE4IJWe9b92RCbreKXbEm9Q80Gmv7NhU2lJiy1f34Adz/TYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obl7m4dYfvFPJQR3BzQuzNHkPhjGc0REc6Bs8XIk1To=;
 b=pFP0nwtU+DUiFcWuKT5eegrMc/fylgV3VZc1cFlU0wnf+fwaMsZ58PU8fMcvxXiN/fifaRgZ878hK3LTXQYfVRLTly83ilWw5JJZw26RtUsNerp3+Xsqc6L+2mQqTJ84Pzkz1NIaccXlPkQVwU9vUox51ItiDknSfLaf7VPmI4Hum7cW9LgrXp8+fRvIntz7PS2koUfJknAMj7HwxdqVgMqLs2jw7IKrbDBlPyx4v1YtU/O1ihmGZZJxmaTeAcVyUsKVzMRKJdFT9w4yKGcHtmwOHK6fPwvxEZ6TW5OAENFbFLriFYXmU3Ed9Z/lgQy61nUdR+iWhrfvyex2Wqyi0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obl7m4dYfvFPJQR3BzQuzNHkPhjGc0REc6Bs8XIk1To=;
 b=dCo5onzuTj3YqTwhu98GL6SbYY25o9FHKUDxFG8+glb4cuCr7aYl2SNGxlaVLYXKiR2IwKJIeIQArv5dSWhVtVvofwY43636O9ItftcwPCWlWFC1/ffPRT0wbjktgFjiCOo6n96KsEEnpE6vUT2E1BXBL89FDIOeU2qL1BKQ55g=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS2PR08MB9104.eurprd08.prod.outlook.com (2603:10a6:20b:5fe::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 09:21:21 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%4]) with mapi id 15.20.9745.019; Wed, 1 Apr 2026
 09:21:21 +0000
Message-ID: <6d9dad2c-9ec7-40f3-8ee5-f32e22d90248@arm.com>
Date: Wed, 1 Apr 2026 10:21:20 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v5 1/3] mm/page_alloc: Optimize free_contig_range()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260331152208.975266-1-usama.anjum@arm.com>
 <20260331152208.975266-2-usama.anjum@arm.com>
 <f61e0fa6-a716-405f-bce9-a2bf4ef0c045@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <f61e0fa6-a716-405f-bce9-a2bf4ef0c045@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0339.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::20) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS2PR08MB9104:EE_|DU6PEPF00009524:EE_|GVXPR08MB11351:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b9eee9e-7bcd-400c-4594-08de8fd030da
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 SVzPPU64s8B3mdMpib5y8Hit+Wv0FdKDIWfCDBR3PRy3QI2xaxEiKPEH2tWB8fB+jRNur9eos4GZVDCK/AVfmw1M4DyLdG1RcGr/VclNAH1ihlaJ+O9WKv6/UpTtUhEt1W+svhH+s1nM5E0M/S7dXacU140SPAOYrFUr5mh59BtiCO3W31ieZTSgjufZORcDxnmxkUjW64LPj0sa4QTDZ+uHxMSM75Jda+63PLjAyS3DlUcFrNvMU2rRPdZjdzAH7kneMAPPh1HzHsNZTOK2HIMidT/KsH2U0tx+aIYLjxuRLPO4Kh72vjb86uCRBkpX+KUHwMBw0dAiHiaFa7fryAGenqgmgBMlK3iTX+/Kki10ertdpSpYUTbxBXXARTKul17wzamUfDff0x24ziwYOYpZoKK8Im6OIQ9lCsZ16+mkajUkYj9DT0CaOTD/uW3gwtRZDcnCLk8jnWFPwGzFCV9VeEpxWKHwNMl3e65WYAPLIMqtsRGfGMSgf2WSCDMzst7d7oVy9G21JlRZcx/EXo4ZCzHMQlN6eyubay7orLZsPjUnFd5Fz52VT6mxCdQOJjca5ut5Fy2DFFv4g5bXK5GmZbREeSmF8SfyBU/zcqnrvAe3iRDalb/GX7JFdsGHu63G5F3BRWDDn5kSiymm0CjInwcS7rwtIgL5KBTD0hZ69R053++AroNUUTcIZbCWNgwRUxJcd3wyP46h21SjA+SIggZ48ufQ4B3K/w3nJtT6tgZ5mJMGgnvB054XdEt5dIE56HxWGOrAQinvCRKHmw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 LaTSveiTUJTuyPNJBCuDf4YSV3jv2DVAzWqdnGHfcznJFerq5/F9YGr1teX3Gj5Hf49JwCMlE80ozxD6VPqekceilBZyUlPFMqEI0l/jqdFA6lrSX5CU3T7ZT5/nKkrMi7q8JAxTCHq2jjEyN8I1HTZVe2KPvZe2RPKgjs2cwGzpQT4XdwSLIhLDkwCDc1C1GvciS1ljlqOOId6Hr3pL2NT2Ien6dE0grIYw0EMlHt21AwP1pGVEzqdSUBV6ODCZqjEidwQyP54iFRYarC6u+yA/HxrrGxEQezVt8SxvEs4xpNsTffT7cPUbFSA8+1qtEXrCAEuj7QPV8AiEzdQ0hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9104
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3e36f688-3c66-442a-1608-08de8fd00a00
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|35042699022|82310400026|376014|7416014|1800799024|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	L9+Ut2MjKEPnoIT8VEENnwUjCfy0wrrcHWqBvYfEm3cEIatBoGwhIJ3W+1s/tV/rVvnII8MJDU64dkRKatr8JObhQlareG8uZ507b0io8q3u3bf+CORHFgS/qcMCck3/al/179JzonWUUY5PLGrdQwewyDMyUiYqCriqNJKJ4ucYJaUbD5y3AeKohYzox0UQ0g/8Otjd3jbiDsopLZgRKRYdwaJNH9+xfOdTLk7PDNVoj1YSZTtDLvOpORKUDDFmPUnzXTGF9up2yz2h/F/KHhZuxVk2xHk3zG+80yAKYYrFOybPIKw2hetuxaMn8FgKg0TF5ZGJ8TvfKOzrbk1HCsmOA+4DZegEPVXL3mcrAJFB90KmPb3TRzBF+aZrBVivcVZCSqQLYxPuSopRTgkiDez0YTsXeL1ay7rf/hVXU1pA7SOlAFGHea4PjrAgiIH2iA2LMail3bRNFt/ffxmA8chS6/QOzLAtWAtfJBJk4byfLmbh25ERRwxCQ2Bfmmo5Hx949HFTogQuUEW1b3fvsKRW7+mbN4WLUIV0/C9SgzrD2iA99c3d7O3NRb2wATvopx3MYM/DISttk3G1fSjw/d/pbcFd4YwRKS5XQYtp+mRyAiGWt8w9zRukxyY8mCWEWlETw8GRpeD4MpTU6fIiFTvgTO6y0ZJWVpWX4Ji438l4DYJ2DY5NfjroDFJubOAVbrJbIhXz/0zaFgtzqkHNdA6bSCuTnG3d8tUibXK9OMek2eqKdcv1jXJ4LUFUOkkXr8I6y4LyftKMS2YEEkOYy/qFg5RpY2W/gzRau6j7gkBkplUoH3tsgYLYmX5C7NpZ
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(35042699022)(82310400026)(376014)(7416014)(1800799024)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Lt6+6SnyE/1B2/kCOFVY78ogzYw5n4trbIhK+fwDHKdMyi+UZ2hvGkd5WnjCSxDR/TmxOHOuBj3jsp7E1s+1Us8M5KK9PphNWZgIH4UYleLYDRa4x777syExYh2xisitAJtVo6bdQhsp2ddEm3tSoFC9AvAeJMcbIXmoWHOrSUGUoBFdObrMnVwKE28yer1UYc/G+lB7CneK8oVXVLrak4bQYX4gQN1t49f9OWtG0FmASaEtNAXQtvzue1NlgGgqzisCL0H52e2S16z/xe9vMYDn+Hah8O3sah4wIS50hpHQnoUf80zomLYBsEVFqpREuaPPgjfafIfqgUxSR0KAmiYRoxvE37vYgY4J2Nj2nbZWGN6s6ZqIrZo01epZhzUYoNIpuxTt2B5MDhw7Q5d/sq84CDDNQiooq5SEqzoPlgo9cl1jSg1kopuh8hXuCUE3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 09:22:26.7636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9eee9e-7bcd-400c-4594-08de8fd030da
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11351
X-Rspamd-Queue-Id: 3672B180008
X-Stat-Signature: 8h4hct496wx9km79t3w7xsmostirqya3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775035353-37471
X-HE-Meta: U2FsdGVkX1/hrcy37JMmcd0zbPxTQPwkst7WO1KYoPj0vGjr4lgv0loz5AEcXoAEavhYGY2CqCa6uu+BWRLzMB36orzOetjcDDa/49IZdJChLzn9KKAvYhxxkYIQ8Jfnx/L4vPRzWPDdAMU4NqpQnt8wlOeK5IVOAwntPKQYFf39mJah1DDWiXAUDxkx9YCSoAbRLFO7PQwW27Mmoyd4p84ZKEAVFX7SIsCd2d5/N1nvVTXVLIxKdT3Rb9sET48lOzK9EOQ/fsmq4yCBPFcYBBPlCaipciW/dgPUDZ6xKDDp4KbYodlLLVnonImeARXhwLtLv+h6yFb6Q2I0D+BH5dQi3K03rqf1J39tw+7NePRmrMkx5B8n3ywWjKXWQ17d5Nsj99q1iQp1Sx099LSwNORYqX+x2SnXwGKEWYXD0r+CD6uQYKzZzYotA5xtC0lQ483dA4VfKBlDM8h9ot2OCmYpoq3Yxa6w4LLY8KuA3sFzvovkemJUHQYrxR58hWRdu/zhSBiXoHdCuWozNkdZL6ErjoQQiIF9lhbRiSIjxbm+8ae07wckF2v3wwD6LXWiANuTjNKuSj5ytsFqAVHf6+F6nmg9Aj5t/BqAulkDBqXiXDm7fU2tmHwjbwVit66qfoK5zR7KxvRi/15BDzLZh1uJidUTCEkkRWNNThbLRGwWRgZVo9KCxe41N35W+V+96eVUFAdqwCzbOQd2aDAqEfs6vbDS6jaXSdXUc82EuZwSVov3xTRBpWYucwuARhQNgPbAjYoOTeF27rt3eFuW8Z8oLwZkcM8LV8A52duSmqNwpt6l2Eoh/ESmi3eYXFtBiLE5D2Upm/MuCNNnxmctIeJ5chMx2mkfM5HSYBSp7VpCVV9NFyYeeyHtq1hld4pfwSCg7zpNItDw97LX0eQzEH0Z/3QVWeebGC/g9ONf94aPubUovog6jMGLWBBquTAolejdOkaK0Nr3J4cW0Ii
 aY2R9FUe
 hO4VTce4mtVMJNo/9+XawEdD4IrFiLFw4CZ9tQ0dNq58T967bcokPW6BFfox1iGgABglb2mMplTH/YhPyxIXYpVPkehjPRbySPKmkbvPX6sbo/bVLseFJgkCuvGEAaEUL2rvyyXvamULgnMLI6jKFzdyqrBJk6dyaGEahhONBmbfzq4D/mr6PuJVUV2TsIczDTDhMegvFF9j/899y41ELj+FH43CIa2nrunA9ys8XcLajbmOa3rbWkUKZXqfaObfYfPb7fInf0deGtfeBLAjH90/Imw34nPGirp9cEq4lnwLqPZhs90RBAoyJ7YLu0mVIk1tFbXN63hAUQriXlqrQlly+N/kOqbBprIZuuzBK7oaeBdwbsxrRZCZ/m3xFhkmzVcBC46WGBUYBQxvPyKIzxCEENdXXj7wwl9MNhzU1FhFD406P959OP+rBOjdq4oSwu5DfYNF4JfaqhAzGbtxi133oaw5H5s9KC4JrT2PXudbRQnMSuNVBtpn6LTgB0WKSynzKiL7RqZMTlyDajQ4AIWF4uYfmqcCqr9adQE6wEz/N/WSR8Fxl7TxfeRKe1Vj0rzQQjqBDN9V8pA3wHdshKMNru/2gMODkKWmKnhY7G+e9bXTMS16N0WSm2hEEriXoms5KHrEP2ci+RRn1+co0rMJKKLTtdxdcxp5BKbeXI5l61Ho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Thank you for the suggestion. I think I'll send the updated
series today as I don't see any outstanding item now.

On 01/04/2026 10:07 am, Vlastimil Babka (SUSE) wrote:
> On 3/31/26 17:21, Muhammad Usama Anjum wrote:
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Decompose the range of order-0 pages to be freed into the set of largest
>> possible power-of-2 size and aligned chunks and free them to the pcp or
>> buddy. This improves on the previous approach which freed each order-0
>> page individually in a loop. Testing shows performance to be improved by
>> more than 10x in some cases.
>>
>> Since each page is order-0, we must decrement each page's reference
>> count individually and only consider the page for freeing as part of a
>> high order chunk if the reference count goes to zero. Additionally
>> free_pages_prepare() must be called for each individual order-0 page
>> too, so that the struct page state and global accounting state can be
>> appropriately managed. But once this is done, the resulting high order
>> chunks can be freed as a unit to the pcp or buddy.
>>
>> This significantly speeds up the free operation but also has the side
>> benefit that high order blocks are added to the pcp instead of each page
>> ending up on the pcp order-0 list; memory remains more readily available
>> in high orders.
>>
>> vmalloc will shortly become a user of this new optimized
>> free_contig_range() since it aggressively allocates high order
>> non-compound pages, but then calls split_page() to end up with
>> contiguous order-0 pages. These can now be freed much more efficiently.
>>
>> The execution time of the following function was measured in a server
>> class arm64 machine:
>>
>> static int page_alloc_high_order_test(void)
>> {
>> 	unsigned int order = HPAGE_PMD_ORDER;
>> 	struct page *page;
>> 	int i;
>>
>> 	for (i = 0; i < 100000; i++) {
>> 		page = alloc_pages(GFP_KERNEL, order);
>> 		if (!page)
>> 			return -1;
>> 		split_page(page, order);
>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>> 	}
>>
>> 	return 0;
>> }
>>
>> Execution time before: 4097358 usec
>> Execution time after:   729831 usec
>>
>> Perf trace before:
>>
>>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>>             |
>>             ---kthread
>>                0xffffb33c12a26af8
>>                |
>>                |--98.13%--0xffffb33c12a26060
>>                |          |
>>                |          |--97.37%--free_contig_range
>>                |          |          |
>>                |          |          |--94.93%--___free_pages
>>                |          |          |          |
>>                |          |          |          |--55.42%--__free_frozen_pages
>>                |          |          |          |          |
>>                |          |          |          |           --43.20%--free_frozen_page_commit
>>                |          |          |          |                     |
>>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>>                |          |          |          |
>>                |          |          |          |--11.53%--_raw_spin_trylock
>>                |          |          |          |
>>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>>                |          |          |          |
>>                |          |          |          |--5.64%--_raw_spin_unlock
>>                |          |          |          |
>>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>>                |          |          |          |
>>                |          |          |           --1.07%--free_frozen_page_commit
>>                |          |          |
>>                |          |           --1.54%--__free_frozen_pages
>>                |          |
>>                |           --0.77%--___free_pages
>>                |
>>                 --0.98%--0xffffb33c12a26078
>>                           alloc_pages_noprof
>>
>> Perf trace after:
>>
>>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>>             |
>>             |--5.52%--__free_contig_range
>>             |          |
>>             |          |--5.00%--free_prepared_contig_range
>>             |          |          |
>>             |          |          |--1.43%--__free_frozen_pages
>>             |          |          |          |
>>             |          |          |           --0.51%--free_frozen_page_commit
>>             |          |          |
>>             |          |          |--1.08%--_raw_spin_trylock
>>             |          |          |
>>             |          |           --0.89%--_raw_spin_unlock
>>             |          |
>>             |           --0.52%--free_pages_prepare
>>             |
>>              --2.90%--ret_from_fork
>>                        kthread
>>                        0xffffae1c12abeaf8
>>                        0xffffae1c12abe7a0
>>                        |
>>                         --2.69%--vfree
>>                                   __free_contig_range
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Nit below:
> 
>> @@ -6784,6 +6790,103 @@ void __init page_alloc_sysctl_init(void)
>>  	register_sysctl_init("vm", page_alloc_sysctl_table);
>>  }
>>  
>> +static void free_prepared_contig_range(struct page *page,
>> +		unsigned long nr_pages)
>> +{
>> +	while (nr_pages) {
>> +		unsigned long pfn = page_to_pfn(page);
> 
> Sorry for not noticing earlier. I now realized that because here we are
> guaranteed to be restricted to the same section, we can do page_to_pfn()
> just once outside the loop and then "pfn += 1UL << order;" below?
Please let me make this update.

> 
>> +		unsigned int order;
>> +
>> +		/* We are limited by the largest buddy order. */
>> +		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
>> +		/* Don't exceed the number of pages to free. */
>> +		order = min_t(unsigned int, order, ilog2(nr_pages));
>> +		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
>> +
>> +		/*
>> +		 * Free the chunk as a single block. Our caller has already
>> +		 * called free_pages_prepare() for each order-0 page.
>> +		 */
>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>> +
>> +		page += 1UL << order;
>> +		nr_pages -= 1UL << order;
>> +	}
>> +}
>> +
>> +static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
>> +		bool is_frozen)
>> +{
>> +	struct page *page, *start = NULL;
>> +	unsigned long nr_start = 0;
>> +	unsigned long start_sec;
>> +	unsigned long i;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		bool can_free = true;
>> +
>> +		/*
>> +		 * Contiguous PFNs might not have contiguous "struct pages"
>> +		 * in some kernel configs: page++ across a section boundary
>> +		 * is undefined. Use pfn_to_page() for each PFN.
>> +		 */
>> +		page = pfn_to_page(pfn + i);
> 
> Hm ideally we'd have some pfn+page iterator thingy that would just do a
> page++ on configs where it's contiguous and this more expensive operation
> otherwise. Wonder why we don't have it yet. But that's for a possible
> followup, not required now.
Yeah, it'll be useful and will make the code overall simple to follow.

> 
>> +
>> +		VM_WARN_ON_ONCE(PageHead(page));
>> +		VM_WARN_ON_ONCE(PageTail(page));
>> +
>> +		if (!is_frozen)
>> +			can_free = put_page_testzero(page);
>> +
>> +		if (can_free)
>> +			can_free = free_pages_prepare(page, 0);
>> +
>> +		if (!can_free) {
>> +			if (start) {
>> +				free_prepared_contig_range(start, i - nr_start);
>> +				start = NULL;
>> +			}
>> +			continue;
>> +		}
>> +
>> +		if (start && memdesc_section(page->flags) != start_sec) {
>> +			free_prepared_contig_range(start, i - nr_start);
>> +			start = page;
>> +			nr_start = i;
>> +			start_sec = memdesc_section(page->flags);
>> +		} else if (!start) {
>> +			start = page;
>> +			nr_start = i;
>> +			start_sec = memdesc_section(page->flags);
>> +		}
>> +	}
>> +
>> +	if (start)
>> +		free_prepared_contig_range(start, nr_pages - nr_start);
>> +}
>> +
> 
> 

-- 
---
Thanks,
Usama


