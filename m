Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4059ACCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 10:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FF08E0006; Sun,  2 Nov 2025 05:32:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600A18E0002; Sun,  2 Nov 2025 05:32:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A738E0006; Sun,  2 Nov 2025 05:32:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA3C8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 05:32:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A01FA13B222
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 10:32:11 +0000 (UTC)
X-FDA: 84065302062.20.1F3D0A3
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012009.outbound.protection.outlook.com [52.101.66.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id A23F440016
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 10:32:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=MmLTQp9M;
	dkim=pass header.d=arm.com header.s=selector1 header.b=MmLTQp9M;
	spf=pass (imf12.hostedemail.com: domain of Ryan.Roberts@arm.com designates 52.101.66.9 as permitted sender) smtp.mailfrom=Ryan.Roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762079528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ebsofgis/vx3L2rnF2yxCHPJKi4DV4XMBauYvrzG7fE=;
	b=ZzVuD+WJhEM6U8Lg3a475pcqu2SkGLyJm+09AAFMfWYD74sHvhjLjgs/c2ZWuOJn+R/kBo
	IkXEohn2BJtEXsLltEE9CkTdOCOhoUql3ADVILkh/bIGU8SPd7ATcMwPmFQr8QMjlhIhhh
	v3yIHBaXxqp8imd0ECcE5celgV8A4FQ=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=MmLTQp9M;
	dkim=pass header.d=arm.com header.s=selector1 header.b=MmLTQp9M;
	spf=pass (imf12.hostedemail.com: domain of Ryan.Roberts@arm.com designates 52.101.66.9 as permitted sender) smtp.mailfrom=Ryan.Roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1762079528; a=rsa-sha256;
	cv=pass;
	b=o7omDYf9wphIn6E39BqzqhneQzTESg3ytvYdq6pqglV9zBm2J1urhNdgy5biYD1sz9QTjs
	+aOJLcu1kep3cTOSLhzMYuT7vYR/P1Hw8qWS/QX0V7lX3y9IF4nLMNRZT3JbCmBaCoziw9
	NEkD2/a7chs8sKxNrOS2JrVQ27PtB5M=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YmFMC08PDMzgNZRViD2kEfiob5Fi/ofrAv/JXiaY8pt4bcT/tzQ5yyziYymtnFj6e2Vka5KmfY1YRE5jZTxF2SEsrscaompTPcSWtiCT3673v1qWFXeXQUEzxXpiu/Isw6z69eJr+iPK6cdEs0EzemvEhwLkGBqUFNgt68YHzYSaDhPuK6QRd+ax3jZ5iJON7vMSl7j605kTJqVoBTErB8W4aBxpXcP1tOICb4YFxlgO1PWyAThfkzeFnVFURrP9Fct9OhRtpiwAe6rQuFq7M/Ry8nMEogR54NzEWlAQ1JmUj6uK9RvxiK0g/C4gDzCKTJavfmkvKTBqvLSYKR0FQw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ebsofgis/vx3L2rnF2yxCHPJKi4DV4XMBauYvrzG7fE=;
 b=lQIoqvTJhJRkpQO3N1L+G8R+ue/VFtRB48B2cdg/87ZfEa0JqIe/Re8wZJWsH+CMIdHznRCHxki8DW7moDu3jOA9wfD7EyFPe9yeuWdSw3Ktb8HyxusyfPAFSHJN6kltVQ//JRieWhKZUjITICORj6W1OgwQLZYJa480jQAtDnwVGKljZIZQWn/6yUPGlu7wmecL2cRs+NFv5pf/7KO61r65hfWfmFhsXXz6laSEofcPfoabbgqQaciAy/v6y0ypLwS2iANR4JEKslT9U+FPM+El1jKS0C1jyjs/S5TivIHdUCzblCMr2lx+/G4Ma/lXTzoZWygodnjrABeytrbunQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=roeck-us.net smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ebsofgis/vx3L2rnF2yxCHPJKi4DV4XMBauYvrzG7fE=;
 b=MmLTQp9MuYopB1seDzkbPoHKzBIcEJEE7i8zaKXlZR3ghS+OK8c1PIM84ZGWYk+TFB6SzmMqhJQYB8+6LVA0CJEcRVoM1+lgSNIkrMn+vxskh2sGqt8nquBib7v62qp1pMnW0zwlz73Ct1ztLi6q3YLUK7uLl9eAxCiq1rsYCgU=
Received: from DU2PR04CA0166.eurprd04.prod.outlook.com (2603:10a6:10:2b0::21)
 by DB4PR08MB8055.eurprd08.prod.outlook.com (2603:10a6:10:388::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sun, 2 Nov
 2025 10:32:01 +0000
Received: from DB5PEPF00014B8E.eurprd02.prod.outlook.com
 (2603:10a6:10:2b0:cafe::83) by DU2PR04CA0166.outlook.office365.com
 (2603:10a6:10:2b0::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Sun,
 2 Nov 2025 10:32:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8E.mail.protection.outlook.com (10.167.8.202) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.6
 via Frontend Transport; Sun, 2 Nov 2025 10:32:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U0+UFdTL/EilBSsuroLlVY69UqSIcvgJjP5PODiI+V8ysc7cbz2Xs4eJ6zpFk/jFspflayQwUBtsUPoIOuaKgcGWNsAOHl3xPU0LuMKBRo6h+H25E9GDb4nC9crHPbwpP/1fR0MZKplwNXbAx4vO+tsz3KRwD319VWh+PK1y4YCf6jp+UfuWsNkTYTo//YTygiMXQPyncttTJdT9LOkuI1gM8zQSfaOLc734SGnULQIJvE5bb3dcL5J0eHmdd2BepzckfGgul+2UkPVIDKiqsf1GQCYK6lFOAGKiTGK3RY8MJ6HrAtBex9PUWvfIwfnnbTT8/pkqmWv8S2BaevxHRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ebsofgis/vx3L2rnF2yxCHPJKi4DV4XMBauYvrzG7fE=;
 b=LTy/5wNOVyNTJsJhMgwDtg0o0NxZ5U87ex2yn2Q9ZckV/9z5P8bX5zFwu+Iffa+TaC5H2xxR2ZJvkU6lqUtPat9CgldfsLlWFDGplkPZbkeoBwIEQL4FijdRlratdKRnvGSxdEsclwaHVaSDGuFhc98COZIXKTYGlNCmx4Me+4iRMyuUDqM34J+HNd0Qt23ru9Uns+gaaTG2dRzxDIseaAZu06g9VJUZlF/JsfzzNFwx6EKinhWw1Iiy1loLkTn+ycTLRl0w6NIb0G9ddPoI83a65kxHp8cP139Q7a2N69LZ2vIWGtrC3hCdmAXNa3rhnSU0C9+H8H4W3h3g02XsEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ebsofgis/vx3L2rnF2yxCHPJKi4DV4XMBauYvrzG7fE=;
 b=MmLTQp9MuYopB1seDzkbPoHKzBIcEJEE7i8zaKXlZR3ghS+OK8c1PIM84ZGWYk+TFB6SzmMqhJQYB8+6LVA0CJEcRVoM1+lgSNIkrMn+vxskh2sGqt8nquBib7v62qp1pMnW0zwlz73Ct1ztLi6q3YLUK7uLl9eAxCiq1rsYCgU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB11445.eurprd08.prod.outlook.com
 (2603:10a6:150:2c0::19) by AS2PR08MB9074.eurprd08.prod.outlook.com
 (2603:10a6:20b:5fc::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Sun, 2 Nov
 2025 10:31:28 +0000
Received: from GVXPR08MB11445.eurprd08.prod.outlook.com
 ([fe80::fa0f:733c:3b98:b13b]) by GVXPR08MB11445.eurprd08.prod.outlook.com
 ([fe80::fa0f:733c:3b98:b13b%7]) with mapi id 15.20.9275.013; Sun, 2 Nov 2025
 10:31:27 +0000
Message-ID: <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
Date: Sun, 2 Nov 2025 10:31:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
Content-Language: en-GB
To: Guenter Roeck <linux@roeck-us.net>, Yang Shi <yang@os.amperecomputing.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nd@arm.com
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
 <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0264.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::15) To GVXPR08MB11445.eurprd08.prod.outlook.com
 (2603:10a6:150:2c0::19)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB11445:EE_|AS2PR08MB9074:EE_|DB5PEPF00014B8E:EE_|DB4PR08MB8055:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b5ebcc2-6150-4d94-f0cf-08de19fb0f1f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?V0xmVVd0Y0krM1pqMmVRWXJMMDV3MmEyTE92RnUxZnNFbjlCLzJSSGRYeUlI?=
 =?utf-8?B?MUVmWHZHS0xJTkN3WWpaUW9oVzl0YUJ0UXJWdDU3N2U5enJCdHRQREFnOTlx?=
 =?utf-8?B?bDlEVUNEMjBVbXBsbTBseUd3Z3IxVFhvUmJpazBSaWtJYlJ3ZGdiQnRBdmQ1?=
 =?utf-8?B?aUVVSkl4NWxmTENybkt0RGozMlphUi9NdStsaW05WTA4SURGSGpEdmpyaEUv?=
 =?utf-8?B?TnpYQkZ2cy94bTZsR3liL3R4L3BKeXUyckgrYWFPMkJIb3NzUnBFN1BzeGVs?=
 =?utf-8?B?aWREdk1KdEg5QVVlbjhQcHZRZlIyV1lzV3Y5a2xxQlRxZkZySE8wWmN1WGV2?=
 =?utf-8?B?Sk9qSHFIdzJXQldXNElLeWJGNkdjVTNZMjl1a2dSZDZ6d1YyVFU0R1dJcFZn?=
 =?utf-8?B?UTJ6Z2FKUWtieDJDa2lkOFdiSDFVTDJCelBYTGdxUFZ3ZUltcG81Ui9JMHll?=
 =?utf-8?B?VkFuZFMyRldiUnMramVnc3EwblpkZGJuN0RNcXpaa0NQRjhTRlZ0bEZON3RO?=
 =?utf-8?B?cmV6NjBNTjdZSTdKZnB0UkFBMWM4V0F3cU1RZVdURFFGSG9pMWpXYWZqNzMv?=
 =?utf-8?B?OWphOEcwZGdDUWQ3Wmd4a2NVSkZnaGliWnhER0dHM2VvcVRBRWFtMTlkeERF?=
 =?utf-8?B?UXZyNU1yWCs1eTBCaHY5ZzN4WTVEdEh1aUJNUFZUemhoRDlDM1BtMXI1aGxO?=
 =?utf-8?B?a09JK0JYT0dHWmZGN3NmejVySndlNVJzSSswLzBGeHdXK05pekpWT0Y4QUtL?=
 =?utf-8?B?aVEzZFpkNDlTUFBzNjRsZER5aitSdFFDbVEzYzZqdklCRWdXVU5ZaXladUh6?=
 =?utf-8?B?SjRwUTFEeFJwclB0UWdaZ1huWTFBY2RjMnZXR09lRjJTSUg1bi9MT3FYVlJN?=
 =?utf-8?B?WUFCTkpTQWNOdHRadEoxTFRxbXR4M2xIU3ZBVWNBMmhvUjdJNjFld3FpYjRq?=
 =?utf-8?B?cXFkd2w0RVczTVRGSVFZTEd3bWpUN0UrZDl3em1rcEFQbkdTdnhLbFk3K1pD?=
 =?utf-8?B?NVhaK3p5NWdHWktHU1VFMXROdFRSeVBCWDhhRzBES05WU2lNaEhHWitjNXBC?=
 =?utf-8?B?QWNxcUhJSzVWdHlZL1BGUThPMXlVMm9hWVo5dWdxS3Z1bDI2Z1RQbUp5SlVD?=
 =?utf-8?B?YkcwRjNvcmdoYjFFQ2lKUG82d2VEUklSQXpXbDUyYlNlOTA4cXFrRDJKZFBt?=
 =?utf-8?B?czhZV0ZPK2t1bzk2bGVEMEpYNE5TY1JTNjhFYmNYdGswZlV3bnk1MUtXR1FW?=
 =?utf-8?B?NjVuS25DMFB4ZXJtRTNNaGZWQ2lzUGpBcm45TTdneGR5cmFteC84SXROVHBT?=
 =?utf-8?B?UkRtK21pWWJ1RUFFTTZxM1ZKdEZIbmhvUXBzUUU1VjhlemxDanpjL21jUVZR?=
 =?utf-8?B?YTZtOWxWQk5USHBleFZxRTRLdkJMeWNKWXBaTlY3WjJqVXR0ZUtocldJQWZK?=
 =?utf-8?B?ckx5clVwcVFsUUxNM3pzQ2wzMjhLT1crdmdOOFlxSGl0dEZhaE9Ma2E3Wll2?=
 =?utf-8?B?SytEVXBjeFZnQ3VXNjdKc1F6Nnp5TFBzd21QNnZmV0NteUhvaFN2ck9Vc240?=
 =?utf-8?B?WVBhNlpOaFl4YlRsenlod3BHOFhUclRUZXgzV1p1VnFLUjVUeFlQdHlYYlU4?=
 =?utf-8?B?TitmS0E1WFMzVGZiOWJqWmpFR3Rua0diMDJDQzg3a1RFazN2NFlDdWh5ODV6?=
 =?utf-8?B?YzhFNERvTE9PRFkyREtvcVhBQVV5VjJWQ2xaVksvZDNaWHJGZENHd0t0d1U5?=
 =?utf-8?B?RWU5azlrZ2RGalFHcmRRN2lvdnF2V3pLZ2lNZS9ZYUIzcFVzSVJuZHc1bEg2?=
 =?utf-8?B?azJxNEZSRkQrUG10ODdQODRWbDE0OVVjYjV4TTVvSENJN2ltWXJJUHJ6dS85?=
 =?utf-8?B?TG9paldyL1E5NVhBb2xybFc0Z0pRRWloZWdsNkJEclRxRmc9PQ==?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB11445.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9074
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	04508013-c66d-4317-6620-08de19fafada
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|35042699022|7416014|376014|14060799003|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTlIbE84MjdibG5sd2VKd3VlcGp1S0VFV3l4TVJDNm5HQ2FtcHFRdlpkeEYr?=
 =?utf-8?B?aFBQeHlLSVRUK2wxYnFsZSt0RW9ybi9lZVh1WE0zOXB1WVJKbUtmSytiT3RC?=
 =?utf-8?B?WEx4NWZjQXpHSFZNek5PWWNneVNDc254VnVxMzdlR1IwQ3RFSjBlQUdZKzRU?=
 =?utf-8?B?RVRQdSttYjJZa1Z6VXRKcnRyODRhS2hoQmEwdVE2WWVkWG0wTEF0MmtXeFVU?=
 =?utf-8?B?WVoxOGZqOFEybUxjUjd1TG5MZ01NMmFXbkd1VGQ3ZGJkTm9vcExYcWI0K3FM?=
 =?utf-8?B?aHZCRDNxUURBSjNCS0N1dXYvYmtkYXVxaG14a3dJbTd6OGR1T2Y3SUVDUnNz?=
 =?utf-8?B?N0lKVzdHamt5QTBQV1prbmpwMElxMEpZTWp6MVNmU21ZeEdjMWhDQk4yaXZh?=
 =?utf-8?B?NjFveHlhOHpYSXJQaDY2OE83ZUJWTHV2alV5ZmhVOVY3U0Vkb3FabFNMWmlo?=
 =?utf-8?B?UUdtbUxGSGV5U0xRV2xTMDlVOW81REUxZklTMUVEMENpWXBTVTRzbUtpQzJ5?=
 =?utf-8?B?a3NHd3lVdmFXbWtUS2NlODNzWWhVUkZaTjZzWUIrSUxnajl3b2dtNnpTaU9I?=
 =?utf-8?B?ekFsQ1pwbmhJM1gwVVFkcCtZVzV5SS9mZnQxdHVkWEV6aSs4RXR6Vlh3MjlE?=
 =?utf-8?B?Qnh4cUExd2wxbjA2TC9UUWk2UnhyTTQ5aTNQZGoxNGxJTDNUTE5XSEdSbGlx?=
 =?utf-8?B?YWJ4SGdTRFZSemhuazI2c0JhZlpuMUErQWh2YWp4bVZXRWU3U082Y3M4NXVG?=
 =?utf-8?B?NG0zRFMyb2F3RHF6WGRtbUVVcjlUVmxUWjJVVC9EaGsySFFXcUc0RVN5UXR3?=
 =?utf-8?B?SnpzN1NMUHBDQ2NSSjZNNjNPMmJ6SGs2Wm5yeGgzMWlJcURPNTBNbEEyZzdH?=
 =?utf-8?B?TlZ4eTR6d1ZzaS9MR3lEN3RzS0VIWFJLdWF1c1NjcEYyOVJYR2R5bDFpYnl6?=
 =?utf-8?B?T3NhZFVOSGdwUnV2Zm9JT2hWL0tsbzdMbk5LWGhKbFEwTGpxQkNNK2E2QUc4?=
 =?utf-8?B?cXdNdHRkSmxaa2NvVTFsdUFlTnpTdHlqNFVpQmZDS1Qvc3Zab240bStwWXBD?=
 =?utf-8?B?WkJrUzdxeHBPdVdDbVprWjdWZGtBZlJFckpCM3VRMTdGS2VsNVhVdjU4Z0Uv?=
 =?utf-8?B?T2xUQXF3YVp5akczU3gveFM3NFdaU2FTV1dwaWFoVHJxMGtCV0RQZDFVZ2o4?=
 =?utf-8?B?c2RTc05wc1dkdWcwVklublIxRlNKWUg1S2gxdU9odzM4bHMwejdDaUQzUzJS?=
 =?utf-8?B?WFkvc0VYczNrcDJsVFFPVTVGNkhIblFwdkYxdm5wOEp2MXo4ZXVBWlhqa0dY?=
 =?utf-8?B?cWMyUmFIUW1xVEttanVzUmNlUXkvd1d5cEZ0Nzk2K1djTWhoNDhlMTJuVXpO?=
 =?utf-8?B?ZjhoNGlmcjVnMjAwRFRxaCtwS3o2R2hFSEJVeWFlTy9rTk0yaFQ2Q1l1akd6?=
 =?utf-8?B?LzJGeEJlbDNWTjZCVjZJNWZaM3ZPM25mbkFTQU9BQ0RERWxnWGJ3Njg0ZjR0?=
 =?utf-8?B?akRXUnJzb1lTeE1QVTlmaGZuK0JicWhhUnd1QjZIdUhObGhrMGRhZ2UzKzdt?=
 =?utf-8?B?QW1BTnE5a3dxUTZqOVZoOXo2RlViTDFtdXdzSU9iV0tKU2l4UzVrNHF4dXdp?=
 =?utf-8?B?OHFtb2FZemR6YW9mWElURHJZcE9LN3JQNExYVEpFUlFyTmU5aCtSMkVEOG8w?=
 =?utf-8?B?VDZlTmZjN3pvVHphSlRuMTdEUUFBY3YzcVMyckRacU4rTVA0a2srYWppZnky?=
 =?utf-8?B?UlM3eDhNK2dIbXFPQWhmSXU3SGdGSjVXVUVCemxaQmtzb212MVlnemdSKzVN?=
 =?utf-8?B?dzVPUHBtb3JxYzZmRjJtT0ZEdWFPdVRRVkMwRkVxdWhZaGIxRWRSWHhhYWJQ?=
 =?utf-8?B?cXg0dEZibnVkWEx1YUE3d3pybThSUnFCNkRORlAzYnluUzl3dHBDRElIdUxF?=
 =?utf-8?B?SG12SGNUbnR2WU94T2RSTXVzVFFveXVFaCt1ejRaRVRncVEvSlp2SGF2Ky8z?=
 =?utf-8?B?eXpCeGlWRmdqTmpwVVdhd1RtVG5EenZ2ZStoQXExYzM5RTZaSS9QS1FKNEJ1?=
 =?utf-8?Q?enTEHN?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(35042699022)(7416014)(376014)(14060799003)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2025 10:32:01.3324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5ebcc2-6150-4d94-f0cf-08de19fb0f1f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8055
X-Stat-Signature: cyjutduckq5tdg5qycxom56k7ac6zx4s
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A23F440016
X-HE-Tag: 1762079527-8704
X-HE-Meta: U2FsdGVkX19bBohh8YVNvlAYv5sb+OTNqXDndSrkscALzAAQG2BIRvSoOPf36GhnbiBfJoSzdrjWAwOijRef4Wp/3FKzhAv+dEYszwtOXnC03KM+UBPZnXcOUtkoPcTA4r5E+4ymoiyC65CPifzJsp7WgRH2PscpEttfczUawjn4bzt91rhQzkpilFECqsJYnx6X1eqD/aAinL1b0bcr+jpkEBkxwZphHcWhi8sqpTerXKE8GF2JWp1WuAPq1YGM8XmkJOvn41sfcISQlByEsl2lyLM9klYAcJi3X6CD3fsfAqcOJABq+T5tcPIA0PV00EHNPx9npd+Exbbr0EOO57gc+UDWAFEZ9GBA0PZHtRly1ZT9m2OEkzRs4luX+eKmpxvkEcz1d3KwkeV87Ec38oweAjj4gM2AYxxEQSXJSOd/7URfI43HaFiSwIqM9D7AzDpjxo2Yye3x0fbjcMwmVrLMJrDQYqtgFxp8iIpaRdpGmbgubBp439OSoDa0PZWWkA9MAV8XBODIwqmI6V8nSFOV3KWnrVWI8C+edW8hCj226ybMdMHxDNjya9+H0EXp+sdKTS3wrSOg+EQDXNoDtoX3J1G02FQg7h4auaH3NRTVlK2kdnIZTdm7Qbr1sNh1BEymGy78DPrWQS68JR/mgYbsldvu8QCC5WtoiQByPPXivkT4b9FEbzM6D7vuKwp3hLOgG/e2zGEfPZMCKNG2tAVH0Il4GHI/35Zz3eRJXoypKZja62CuA0Soa9r3WTCp+ATdKysye4Bc87zeXDCQW/5DStzfeSbpXNekPbEq75QJ4GqwM2UTugYx3ndXykeI+nTmP6l8f5rBJ1wPd2SrF483UdxKe2j4tR8zT1jG+4+p2rQzG0C6SOhIm+1c+Na+ee6+Zh6BCMn2qZr50yxu9Ds10g6gmcgRXJ8oCoxhmfimtUdYugo1YAjYC2TG47fr56/FsFKXhZ+0ZpLBCOe
 mTVaehaG
 r/cXZGTQswi1rOYuWl1GkePO8vWSPpXL6390JsU5vsnxaQ/7UwC90ff9n+IMsQymT7txlkZOREQirUmTOWzZwORSEHyCt2ptwkljribXkzK95EqpA3yUQzoQ1+a8lqc2hgbjT2xPg/71gWlVZNpNTXRsx2xOyfjf3kY4lwEa8q1TBjzg2LcpiPn5iT73gqhRwdrYqB9kDF/mzKvdgdRVwaDRCFjipbeFZ/FfsqSQ+7GooXY+nCVUK6qO9fk36a6GBfUXVMxpgd+5CnCxOLNFKI6U65+cTFqtryCGIFJt34d9G8Oi7tmO9zHBKQIhNucCeRLc8/DktUUz+9Ns8hEzi6PyJooJFeBJ0ZCokSc3RPYPI6f2AyXudp7BfV0ipMH4syNM5ecBjHYpMKFryp0y+gesuCqGSJI7xHRY3LXPNBosQmi1QLtx4AHPcWhEmw4WbYkFK4e5HEu3CiL9f2Ye2+/uHTFSyFQb1fpje9uSzVIgubR6Dr1IAL9676wMrX2PqDljWkRwTAgCecJZVmfAFvWMXF5d43GH+9obWXFFpUN62EEZT0MiMmJTVgNVwUyNmo2wvzM7b4xSuQqs7Xxt3U63+u335XMK7CUV9+vT9shKUFz+Jy8AEjXRXHgGsESL2zvrW5+XVNx3fSAesSZnyjzIy/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/11/2025 16:14, Guenter Roeck wrote:
> Hi,
> 
> On Wed, Sep 17, 2025 at 12:02:09PM -0700, Yang Shi wrote:
>> When rodata=full is specified, kernel linear mapping has to be mapped at
>> PTE level since large page table can't be split due to break-before-make
>> rule on ARM64.
>>
>> This resulted in a couple of problems:
>>   - performance degradation
>>   - more TLB pressure
>>   - memory waste for kernel page table
>>
>> With FEAT_BBM level 2 support, splitting large block page table to
>> smaller ones doesn't need to make the page table entry invalid anymore.
>> This allows kernel split large block mapping on the fly.
>>
>> Add kernel page table split support and use large block mapping by
>> default when FEAT_BBM level 2 is supported for rodata=full.  When
>> changing permissions for kernel linear mapping, the page table will be
>> split to smaller size.
>>
>> The machine without FEAT_BBM level 2 will fallback to have kernel linear
>> mapping PTE-mapped when rodata=full.
>>
>> With this we saw significant performance boost with some benchmarks and
>> much less memory consumption on my AmpereOne machine (192 cores, 1P)
>> with 256GB memory.
>>
>> * Memory use after boot
>> Before:
>> MemTotal:       258988984 kB
>> MemFree:        254821700 kB
>>
>> After:
>> MemTotal:       259505132 kB
>> MemFree:        255410264 kB
>>
>> Around 500MB more memory are free to use.  The larger the machine, the
>> more memory saved.
>>
>> * Memcached
>> We saw performance degradation when running Memcached benchmark with
>> rodata=full vs rodata=on.  Our profiling pointed to kernel TLB pressure.
>> With this patchset we saw ops/sec is increased by around 3.5%, P99
>> latency is reduced by around 9.6%.
>> The gain mainly came from reduced kernel TLB misses.  The kernel TLB
>> MPKI is reduced by 28.5%.
>>
>> The benchmark data is now on par with rodata=on too.
>>
>> * Disk encryption (dm-crypt) benchmark
>> Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
>> disk encryption (by dm-crypt).
>> fio --directory=/data --random_generator=lfsr --norandommap            \
>>     --randrepeat 1 --status-interval=999 --rw=write --bs=4k --loops=1  \
>>     --ioengine=sync --iodepth=1 --numjobs=1 --fsync_on_close=1         \
>>     --group_reporting --thread --name=iops-test-job --eta-newline=1    \
>>     --size 100G
>>
>> The IOPS is increased by 90% - 150% (the variance is high, but the worst
>> number of good case is around 90% more than the best number of bad
>> case). The bandwidth is increased and the avg clat is reduced
>> proportionally.
>>
>> * Sequential file read
>> Read 100G file sequentially on XFS (xfs_io read with page cache
>> populated). The bandwidth is increased by 150%.
>>
> 
> With lock debugging enabled, we see a large number of "BUG: sleeping
> function called from invalid context at kernel/locking/mutex.c:580"
> and "BUG: Invalid wait context:" backtraces when running v6.18-rc3.
> Please see example below.
> 
> Bisect points to this patch.
> 
> Please let me know if there is anything I can do to help tracking
> down the problem.

Thanks for the report - ouch!

I expect you're running on a system that supports BBML2_NOABORT, based on the
stack trace, I expect you have CONFIG_DEBUG_PAGEALLOC enabled? That will cause
permission tricks to be played on the linear map at page allocation and free
time, which can happen in non-sleepable contexts. And with this patch we are
taking pgtable_split_lock (a mutex) in split_kernel_leaf_mapping(), which is
called as a result of the permission change request.

However, when CONFIG_DEBUG_PAGEALLOC enabled we always force-map the linear map
by PTE so split_kernel_leaf_mapping() is actually unneccessary and will return
without actually having to split anything. So we could add an early "if
(force_pte_mapping()) return 0;" to bypass the function entirely in this case,
and I *think* that should solve it.

But I'm also concerned about KFENCE. I can't remember it's exact semantics off
the top of my head, so I'm concerned we could see similar problems there (where
we only force pte mapping for the KFENCE pool).

I'll investigate fully tomorrow and hopefully provide a fix.

Yang Shi, Do you have any additional thoughts?

Thanks,
Ryan

> 
> Thanks,
> Guenter
> 
> ---
> Example log:
> 
> [    0.537499] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
> [    0.537501] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
> [    0.537502] preempt_count: 1, expected: 0
> [    0.537504] 2 locks held by swapper/0/1:
> [    0.537505]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x24/0x38
> [    0.537510]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x0/0x40
> [    0.537516] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-dbg-DEV #1 NONE
> [    0.537517] Call trace:
> [    0.537518]  show_stack+0x20/0x38 (C)
> [    0.537520]  __dump_stack+0x28/0x38
> [    0.537522]  dump_stack_lvl+0xac/0xf0
> [    0.537525]  dump_stack+0x18/0x3c
> [    0.537527]  __might_resched+0x248/0x2a0
> [    0.537529]  __might_sleep+0x40/0x90
> [    0.537531]  __mutex_lock_common+0x70/0x1818
> [    0.537533]  mutex_lock_nested+0x34/0x48
> [    0.537534]  split_kernel_leaf_mapping+0x74/0x1a0
> [    0.537536]  update_range_prot+0x40/0x150
> [    0.537537]  __change_memory_common+0x30/0x148
> [    0.537538]  __kernel_map_pages+0x70/0x88
> [    0.537540]  __free_frozen_pages+0x6e4/0x7b8
> [    0.537542]  free_frozen_pages+0x1c/0x30
> [    0.537544]  __free_slab+0xf0/0x168
> [    0.537547]  free_slab+0x2c/0xf8
> [    0.537549]  free_to_partial_list+0x4e0/0x620
> [    0.537551]  __slab_free+0x228/0x250
> [    0.537553]  kfree+0x3c4/0x4c0
> [    0.537555]  destroy_sched_domain+0xf8/0x140
> [    0.537557]  cpu_attach_domain+0x17c/0x610
> [    0.537558]  build_sched_domains+0x15a4/0x1718
> [    0.537560]  sched_init_domains+0xbc/0xf8
> [    0.537561]  sched_init_smp+0x30/0x98
> [    0.537562]  kernel_init_freeable+0x148/0x230
> [    0.537564]  kernel_init+0x28/0x148
> [    0.537566]  ret_from_fork+0x10/0x20
> [    0.537569] =============================
> [    0.537569] [ BUG: Invalid wait context ]
> [    0.537571] 6.18.0-dbg-DEV #1 Tainted: G        W
> [    0.537572] -----------------------------
> [    0.537572] swapper/0/1 is trying to lock:
> [    0.537573] ffffb60b011f3830 (pgtable_split_lock){+.+.}-{4:4}, at: split_kernel_leaf_mapping+0x74/0x1a0
> [    0.537576] other info that might help us debug this:
> [    0.537577] context-{5:5}
> [    0.537578] 2 locks held by swapper/0/1:
> [    0.537579]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x24/0x38
> [    0.537582]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x0/0x40
> [    0.537585] stack backtrace:
> [    0.537585] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.18.0-dbg-DEV #1 NONE
> [    0.537587] Tainted: [W]=WARN
> [    0.537588] Call trace:
> [    0.537589]  show_stack+0x20/0x38 (C)
> [    0.537591]  __dump_stack+0x28/0x38
> [    0.537593]  dump_stack_lvl+0xac/0xf0
> [    0.537596]  dump_stack+0x18/0x3c
> [    0.537598]  __lock_acquire+0x980/0x2a20
> [    0.537600]  lock_acquire+0x124/0x2b8
> [    0.537602]  __mutex_lock_common+0xd8/0x1818
> [    0.537604]  mutex_lock_nested+0x34/0x48
> [    0.537605]  split_kernel_leaf_mapping+0x74/0x1a0
> [    0.537607]  update_range_prot+0x40/0x150
> [    0.537608]  __change_memory_common+0x30/0x148
> [    0.537609]  __kernel_map_pages+0x70/0x88
> [    0.537610]  __free_frozen_pages+0x6e4/0x7b8
> [    0.537613]  free_frozen_pages+0x1c/0x30
> [    0.537615]  __free_slab+0xf0/0x168
> [    0.537617]  free_slab+0x2c/0xf8
> [    0.537619]  free_to_partial_list+0x4e0/0x620
> [    0.537621]  __slab_free+0x228/0x250
> [    0.537623]  kfree+0x3c4/0x4c0
> [    0.537625]  destroy_sched_domain+0xf8/0x140
> [    0.537627]  cpu_attach_domain+0x17c/0x610
> [    0.537628]  build_sched_domains+0x15a4/0x1718
> [    0.537630]  sched_init_domains+0xbc/0xf8
> [    0.537631]  sched_init_smp+0x30/0x98
> [    0.537632]  kernel_init_freeable+0x148/0x230
> [    0.537633]  kernel_init+0x28/0x148
> [    0.537635]  ret_from_fork+0x10/0x20
> 
> ---
> bisect:
> 
> # bad: [3a8660878839faadb4f1a6dd72c3179c1df56787] Linux 6.18-rc1
> # good: [e5f0a698b34ed76002dc5cff3804a61c80233a7a] Linux 6.17
> git bisect start 'v6.18-rc1' 'v6.17'
> # bad: [58809f614e0e3f4e12b489bddf680bfeb31c0a20] Merge tag 'drm-next-2025-10-01' of https://gitlab.freedesktop.org/drm/kernel
> git bisect bad 58809f614e0e3f4e12b489bddf680bfeb31c0a20
> # bad: [a8253f807760e9c80eada9e5354e1240ccf325f9] Merge tag 'soc-newsoc-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
> git bisect bad a8253f807760e9c80eada9e5354e1240ccf325f9
> # bad: [4b81e2eb9e4db8f6094c077d0c8b27c264901c1b] Merge tag 'timers-vdso-2025-09-29' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad 4b81e2eb9e4db8f6094c077d0c8b27c264901c1b
> # bad: [f1004b2f19d7e9add9d707f64d9fcbc50f67921b] Merge tag 'm68k-for-v6.18-tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
> git bisect bad f1004b2f19d7e9add9d707f64d9fcbc50f67921b
> # good: [a9401710a5f5681abd2a6f21f9e76bc9f2e81891] Merge tag 'v6.18-rc-part1-smb3-common' of git://git.samba.org/ksmbd
> git bisect good a9401710a5f5681abd2a6f21f9e76bc9f2e81891
> # good: [fe68bb2861808ed5c48d399bd7e670ab76829d55] Merge tag 'microblaze-v6.18' of git://git.monstr.eu/linux-2.6-microblaze
> git bisect good fe68bb2861808ed5c48d399bd7e670ab76829d55
> # bad: [f2d64a22faeeecff385b4c91fab5fe036ab00162] Merge branch 'for-next/perf' into for-next/core
> git bisect bad f2d64a22faeeecff385b4c91fab5fe036ab00162
> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/misc' into for-next/core
> git bisect good 30f9386820cddbba59b48ae0670c3a1646dd440e
> # good: [43de0ac332b815cf56dbdce63687de9acfd35d49] drivers/perf: hisi: Relax the event ID check in the framework
> git bisect good 43de0ac332b815cf56dbdce63687de9acfd35d49
> # good: [5973a62efa34c80c9a4e5eac1fca6f6209b902af] arm64: map [_text, _stext) virtual address range non-executable+read-only
> git bisect good 5973a62efa34c80c9a4e5eac1fca6f6209b902af
> # good: [b3abb08d6f628a76c36bf7da9508e1a67bf186a0] drivers/perf: hisi: Refactor the event configuration of L3C PMU
> git bisect good b3abb08d6f628a76c36bf7da9508e1a67bf186a0
> # good: [6d2f913fda5683fbd4c3580262e10386c1263dfb] Documentation: hisi-pmu: Add introduction to HiSilicon V3 PMU
> git bisect good 6d2f913fda5683fbd4c3580262e10386c1263dfb
> # good: [2084660ad288c998b6f0c885e266deb364f65fba] perf/dwc_pcie: Fix use of uninitialized variable
> git bisect good 2084660ad288c998b6f0c885e266deb364f65fba
> # bad: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm' into for-next/core
> git bisect bad 77dfca70baefcb988318a72fe69eb99f6dabbbb1
> # first bad commit: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm' into for-next/core
> 
> ---
> bisect into branch:
> 
> - git checkout -b testing 77dfca70baefcb988318a72fe69eb99f6dabbbb1
> - git rebase 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>   [ fix minor conflict similar to the conflict resolution in 77dfca70baefc]
> - git diff 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>   [ confirmed that there are no differences ]
> - confirm that the problem is still seen at the tip of the rebase
> - git bisect start HEAD 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
> - run bisect
> 
> Results:
> 
> # bad: [47fc25df1ae3ae8412f1b812fb586c714d04a5e6] arm64: map [_text, _stext) virtual address range non-executable+read-only
> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/misc' into for-next/core
> git bisect start 'HEAD' '77dfca70baefcb988318a72fe69eb99f6dabbbb1~1'
> # good: [805491d19fc21271b5c27f4602f8f66b625c110f] arm64/Kconfig: Remove CONFIG_RODATA_FULL_DEFAULT_ENABLED
> git bisect good 805491d19fc21271b5c27f4602f8f66b625c110f
> # bad: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large block mapping when rodata=full
> git bisect bad 13c7d7426232cc4489df7cd2e1f646a22d3f6172
> # good: [a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8] arm64: Enable permission change on arm64 kernel block mappings
> git bisect good a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8
> # first bad commit: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large block mapping when rodata=full


