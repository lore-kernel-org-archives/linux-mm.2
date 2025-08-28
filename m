Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC1B2CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E8C8E0006; Thu, 28 Aug 2025 05:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125F48E0001; Thu, 28 Aug 2025 05:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F408E0006; Thu, 28 Aug 2025 05:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1C008E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:35:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90CD55C402
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:35:38 +0000 (UTC)
X-FDA: 83825658756.01.63BD001
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D63CC000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:35:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZkZB3g7u;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hoyadNB2;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GgPWbEpu8CHhhogbmqMzpTPD2evCSK47LVlVolWzQB8=;
	b=V1ib7fc/yK7Fj8/2OGLh2+QQFiFqZrURcNENyStK4Wec5iaNOmeT4hzicKIAHuSux0goAV
	N1GGFus6DN5uLUiSBbyUT0DM/SnrT7+aw1hEHKmFn/1Cxr1KdRU8Tdvn7EjlqzV+mbaGs7
	2cklcLFxi0nihTD1VVNkve1yiUBcq2w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756373735; a=rsa-sha256;
	cv=pass;
	b=75KIpYB7lMtDzvzcqSsnmoL+aUMlFsDQ3sLyg+UWJH91cP7HMUcv0FCj8+bge9STe6EQYg
	sd+yVmcrTJ2tv9uMrMahJDIJCm3gRbBsmBBwu+eWu0ynrWxtXcGsM6P6/i6VGT/YV9JYdp
	Pk5sXSlnvmUo63am2ZlTU8l3aM9EOh8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZkZB3g7u;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hoyadNB2;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S8twGm015593;
	Thu, 28 Aug 2025 09:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GgPWbEpu8CHhhogbmq
	MzpTPD2evCSK47LVlVolWzQB8=; b=ZkZB3g7ud6AKX+AmLskhIfgltMtcdBkkXI
	OQkisQAxOr5nNZC/pqqpYge/wu3iHk0OHuitbE/hpN49XgEzX9GNumOwZF4FteOQ
	4Y0LcIaFHKcmvGZbxyXuZ7VOyJdCX8vqqmKD3UGEOnZ14iRtpBlgQt/vzJFDN8fg
	AawYIbgcBGcuQQU5BGPI9b78og1L6ozuD2frJGuSYk7Ogc0KlqB8gU7xAVbtDIP2
	UsTWFWCT8ZWMfl43Zi+XceeavZQ2p1gujMnEM7VL1YUTx/evRiycv9amVXmAskKY
	k3grl4b7BnJTMjCCXEbTNeA1DC015VYkpYhKX6RLYGuDcVl7jfxw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt88xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 09:35:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57S820fU019610;
	Thu, 28 Aug 2025 09:35:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2074.outbound.protection.outlook.com [40.107.100.74])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43brq5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 09:35:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nn/K9a3IH1R9dfIZv13E0t8EtLaHmhZXKioB1PsFrZwjFtVBvjyBWD7SeYRpIjKsF8FWyYCClac1Qmix7QvSjv+kZ974PBWxEP5WSNOGqSJwdsxRyVWBxg5UY7py8idrQCa0Ofmb6O85Tym97C+por+q3NtTQw2EFBxRDJPzT2I7MudZn1TgGufofyqFg++mD2Tbd0daPLMW9n8DjbhwO8u/vptNxhVUFEaidXaYTQVpBJR+S7XCWrl4efL7IdIC0BVmINEGXo5qRwocPA1vD1dYrJ7nButWht3R7NZfYp5sFOiLvKZS6fp5iwQKVjNyD0XWDl00yOcYZcltPv79Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgPWbEpu8CHhhogbmqMzpTPD2evCSK47LVlVolWzQB8=;
 b=SyXy9Fu9Q8lUhPjsCoA/chqDuyBvKuh0XuTJf1QIv3ArVKZUx0kLrofn6l/wzrXak+02dMoU1RO8CwCzQoeEIyYmV2g5VWhvSMUu/rCXZjJh9f/LVM90hWUpirqMg3BTMNPfG8LcHIYPYv0RpOhYW7HXCLut7ukeppCgEQBVuG+fpUd8UUrzZ95/uH9KdcUDduJmsi2/A3ABMvd8amg0u2BTUBtKBwa5jPHWn7qveyOntxcPfmFSS07X/HjpZZmAvB/OtrXNN6oc1T+ehCfuXpvMWPQwSXqRyJOJe1fbXeHwiROXkt/qx+7JektG5MujUAX49r5EIaFTwhkxC/wLpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgPWbEpu8CHhhogbmqMzpTPD2evCSK47LVlVolWzQB8=;
 b=hoyadNB2fcAPlt0FMAGDx3MLSUS2uXuTU4U5ztycvbT30u5dJNiOY3pEF2SzPrYzFcm6nkqimcvWOqYtjWbhm/s+F19l6dIPTYA/q1jMwcBDnsDvXFXDlItI0sN7rpnnVXPLtIOZAnaijTixAU6amRUmbSFOKdVZScaP/GvfC+s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6115.namprd10.prod.outlook.com (2603:10b6:208:3ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 09:35:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 09:35:10 +0000
Date: Thu, 28 Aug 2025 10:35:06 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, shikemeng@huaweicloud.com, kasong@tencent.com,
        nphamcs@gmail.com, bhe@redhat.com, chrisl@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] huge_mm.h: disallow is_huge_zero_folio(NULL)
Message-ID: <da6bd1ed-3c35-4f5d-b667-a21a47585fb0@lucifer.local>
References: <0de24b30-70ad-498f-9eac-01596c8713df@redhat.com>
 <20250828084820.570118-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828084820.570118-1-max.kellermann@ionos.com>
X-ClientProxiedBy: GV3PEPF00007A86.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::618) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: 2898cf4d-f036-42d1-0f36-08dde6162e7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KSQZGMAPyl3wOHbSRIsaMBFkLcXFZAtEIqObuxJSh5QfNyle1HOHv6R4kjOn?=
 =?us-ascii?Q?k571qihDD6KztRqSrSsTTDFRcwfagBoUv5iHet66jsvbx+4q+WXfuG8Lbkq0?=
 =?us-ascii?Q?q+SBbDC8q8r8hEDM1DuF+gZxF5wfN03/Guv43eyy0/t6r8BJftkMQ3NiBbRV?=
 =?us-ascii?Q?VPxFFzrW2tKBmhDHDhALf2TE2PBYB4LThxYY011G8pz6+Q6CS6qMmraTOknz?=
 =?us-ascii?Q?VtRJ3UeKO7nbEBaGWEICYk7JQh5Q0e9x2HYkATdmikP5Ug/f5pF85OoRe9RI?=
 =?us-ascii?Q?T385VamBrkxcsAfGFSSTPfaFYoXvSiYRKuqgQXX8NAIRPL0fTy0gIYeAzYlr?=
 =?us-ascii?Q?mGCStOYXF7fxv30dNK8/DI+kv+4MW9sc0ZC9NHVTjWoK6MfZwDs0Aq8l6XM+?=
 =?us-ascii?Q?sf0TjBKmmKSFrVFJtFjSgE+neiNL+fhPzIBZloX1GB92BGBaEn9F77fdvm50?=
 =?us-ascii?Q?akp2BLOCsHl/5P1TnLkBR2kACu8INkclpeH1NYPEsvEavZ4u7MzBSZ3uREmy?=
 =?us-ascii?Q?hvL2BFnqInz4xkGm72ScGEnSoxQwoTvcnCLj76BH90KsSXF/0q0usjouDCpl?=
 =?us-ascii?Q?OAdKoUFB6TiLb8zgGkm65v5OpWnirCm9EafVTbOb1vwoZqSPUsYj8+Yt4sOv?=
 =?us-ascii?Q?obeYV/Z7XpEegFTiScgDtkRYAZp6/yLpFkw8lTYhSjH2qq5Tr40VoSvPIcdb?=
 =?us-ascii?Q?YeAIthvzlBp9XBI/EYlG+BGoDLC49uBmJt2mApk6fjLOC7QysGaCGpucgnKY?=
 =?us-ascii?Q?Uqo7jukgNtgoOKd1TXDDz16pu8Fq/DD/jOKsZtz4X02V2KKi6jWLWFiFrKVy?=
 =?us-ascii?Q?27oeoHdTYVGTOEtREdpccx0U8ZuIwRtLGcT7FjguV23302nnyp2QRB/NwfBL?=
 =?us-ascii?Q?kFv4eT75FWv8kxAVJdt8eKr8NsaSUOMQtwtAS+oVLjw1lFnRSYPtLDzhHo57?=
 =?us-ascii?Q?fMKbKcmPn+ZmWiqDQ923tvYeEs+xDI6CvLgLV/jVoJ1If3LFo+R6EH9k9EqR?=
 =?us-ascii?Q?vifHon/AWtt89mHRTkYoLNN6Hw8tb0o1bVrjeuagovKjdNgsQCs9InrDTnlh?=
 =?us-ascii?Q?PJP4h8Ro6qEogRlzMYC4DqZpza7qhYW12GvumI8UHq9q9F4gg9pJ03cvABL4?=
 =?us-ascii?Q?HwFMCeIOQJ4P6++J7GrUf6YCh6XqT+UTsMjHc+3F2xeoIy9z3kyu9RxkZ/f8?=
 =?us-ascii?Q?RlpTK/Z7+Zq8uJSrn1VSwWLUBSr63YBw1aPrjw3tFTidBsiXAbRFmPm+5emf?=
 =?us-ascii?Q?cpHSQ7UEpCylW+2RBIJ2FOtJf8bwpx8sc2LW2gFREYk/Jj8bmURZFRUSbfz2?=
 =?us-ascii?Q?9akOeSHX7zd1gDSHEIT1nPJFpQ+Oxo8VC1gz+kSrpNRaH7lMrZDeDNrpfaG9?=
 =?us-ascii?Q?NN68b4XepAcRBeLg+UwQsGdF2O4mUcqxwC8rogFoyx9XNSG06puuv3igj30d?=
 =?us-ascii?Q?yDc8FMfHU+0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yUt90S7MkI4XzSi2EBHOHwyWcx7Gk+1JKp4s3qhXtOI+uQk1r0sIhl8FNoNI?=
 =?us-ascii?Q?VZOhmwJegmAykEFdobZoV0+wU//fexcM8hLz/ckfuoVupMtEniCMBzBWOvW+?=
 =?us-ascii?Q?9OWVpU8SYnhb2uG3HGhzJgZIR5wbRHsDhq59LJjOdSbbRsa1E+0cYTJPn4OW?=
 =?us-ascii?Q?bfeWn9rTGG8mZ8VKRs91K/eYYsTUu771ILaS0IZ+hV9KqDBP2sr/rF8rqddK?=
 =?us-ascii?Q?2y4cDjTAr6XlZiNpG2JOde5g6/YbDe0vuHqUinfOwrsYO6L57MohNb5Wyq3p?=
 =?us-ascii?Q?JIr5249VGFDSqeN7i5XY5+l3WobgXXjfLRmpDf1oUJ5liTDz+pLDgAVZvr44?=
 =?us-ascii?Q?A6V6cvY2du8pCsbT1TlYTIGSOv+/Ce+MjSqSEQ0lHv8UTRlZsYImJy2C8X3l?=
 =?us-ascii?Q?YJqJnpjyB+S0gaoRc4M2VCe12GwtYnAAJNMfaO1Z6PfZbZDUZ7Tegg60blkv?=
 =?us-ascii?Q?LTScbM19k3V46KIM4QZuMwNSxoqz9pQDvezxBVZlogM++4yvVAvMasARdXS5?=
 =?us-ascii?Q?EozlxiT81b3PdYZrPd0fl1D6+5RFyw6RToIXQpekVse1rKDb3cN4YR7PyR1o?=
 =?us-ascii?Q?b5Jy7gAE3F692Ihos4r8J123FLdprfjFGnSf2rqXnGVcfLyuvbKQkk90JdC5?=
 =?us-ascii?Q?fJt4yyqmQS8BrAGDvdauEOLKaTtNDdGbInFGRdzRt+5bdr8zfZD0rKxYmkWo?=
 =?us-ascii?Q?fbu2zm08iDWylD+uSQqqA39/wb2uhJARZ5WeuYHR7B40ufZtUZpUE8o1+gZX?=
 =?us-ascii?Q?USZyF4H70RVl4hwBP8AoKr/SjsiDbl2Xr29UA4OAdkiDYEgmyXmCirvhnWVd?=
 =?us-ascii?Q?ko7mgG+VGVLQRIb21kXEiOiTJ/qzW2/zEmnc9Jy/ig/EFQUeddpKEj8mOhF9?=
 =?us-ascii?Q?68LKSD7TP9Zld65oGf0DVdJYkBfQq6lb8BdrocQRkjj0bMq0+rV1d7dGMkLT?=
 =?us-ascii?Q?nmpk0NlBo0pOcUJ04UvKnKj0SmnLiehkWV+yMr9m2IgaYXrWXvg7iIf/slC2?=
 =?us-ascii?Q?g0kIrfO05RB2U4AUEF/NpYcQKxEy+ChmZay5dzepR3ClzMt7QLmLPQrAf0Ph?=
 =?us-ascii?Q?iNCDlsBv9cEU3f7ZVfk59p1wfOzceInwivwfO7PHxHWmkBz2f9UFdE3CvuL5?=
 =?us-ascii?Q?deCWjnUPr/6YraibGWE8uIsrc4PrMVEi0Cw/ZGWurcw+3P9GHspeXC7tyLTL?=
 =?us-ascii?Q?szLMfPv/0dAPpO3OPN/fJCDgWaIN7hh9zSZgLu6aFF78rV/84jpxofWPYDUy?=
 =?us-ascii?Q?ymzTAR06t1Vhcr2KeBDIKwbK/O8AB5T+G8h4WUyioR3JvWXs9nhzyhtNMk6D?=
 =?us-ascii?Q?cbF7cvSHWxKmh+20l3VvMHgirRRWXF6Ui3Q282Waz8rshWXlJs97pVws4rqH?=
 =?us-ascii?Q?8Gd/7OpW72aOwnA+RhmhTUd334ButoFQKyC2uKYUaiWiA+2GZhcKuvnbNeIG?=
 =?us-ascii?Q?QXnWlUOYO9aWT/6Kf50RbGRNkv0OT39fysmVaOvkHoTUbCr3Ij+JVps0/1Yn?=
 =?us-ascii?Q?PVFRr/jcBveoVONEsXpf0LfZyGNJpIhhgkTA9bOCod0vOJrmHVkrB+xua5tq?=
 =?us-ascii?Q?XGnn6V4lmj4a9uvLopBGhE59op1GMbSK0ntyPPa533oEtqf3IpSCyhhZ5GDu?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GdMeLLO6oFtT9/7mCGduq36OxeUhGJpfAaubG6q2ro0piGgfsci8mJgcYDxfbqiVoNDe32DoCpx4L38V0kuLhVnwxNboYHFUJ6QgDdIzffoWJy04fkQzpa4apGwa7Xvikj2WkWcHfjJ+YWR8kHRMXRbS0UvE6/ujfscJ9dQTVryyYF+rOOS06fjIex5av6G373Nm1NAtvk+dv0uWQgORpa+ltb/+KvrFcYUhFFuxLODC7xTdmWQ/4h6fuCVuB2F/M///HOL6S/nIZB/YjoLoqqdrYF6WRDxGRUF5XZ9QnWJaWkFcfpKVu2Bz1GEzXDsUQ31KTPoIy92vKVN5HR0HlmuN+HSiuRtzhknpS8IocQ7gffhiZ/jPDIdAgTjZGuVMyFF20dfKQowWVluT4dEyIDTu9yiXtXp/JrLkJF4v9rPHCrSTfmIYwPhGjYT2O179Otg0xmy/E7max6WNgcSxrTxOyyNBVx/2M2g0cPuI8pKLthdanzGdPWvRzarEl13n5FuDvlnH776ukHHcktrXAgX6JMBRUGNOLI2iffMUV81i69hUrOX593R8brUuyxsDFwqo1uQ2DPdX1Ncxs021olT70md2wbc85q79u5ih42o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2898cf4d-f036-42d1-0f36-08dde6162e7e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 09:35:10.0823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOwLKBLulvJMR6aqmfx7OlZLpdrMDA5qEDRr/EUJYUpoPwxK1G2aLRRdKQajnnrHG/ZiirWRhTp9d0RLbkSoprokM9AEaUAsZ99Y2bA6jcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280079
X-Proofpoint-ORIG-GUID: oyQwHWy0gAo-qgTopSbSV3NP1U1NXfRA
X-Proofpoint-GUID: oyQwHWy0gAo-qgTopSbSV3NP1U1NXfRA
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b022d6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=UgJECxHJAAAA:8 a=yPCof4ZbAAAA:8
 a=IPzSgeYvqR1nT-VwbOEA:9 a=CjuIK1q_8ugA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfXxYqtsl0GAy50
 RESwmLR6RdNOMQzzXTnw4eBXFu+TrhQwYNy3hRRudfxfWncN92Ra5GsQ7eUTKPul9wG2iY/GkB5
 1ycpe5l5JeB4KmYOJQ7hKkQCVfuAnJMY2ug5+7hSoRDBWW8uutn3LlvdwNfGxeQR52zYnXJ4TWN
 BRt1DECcTbHUeJfOx/cnD/Jxh+Wbf1eEdN8iD87/dUZr3PRGbraYerOU5xQpFSKARHvSqYIdtv+
 2LBAHPk5ZUwHj2i1pY73g6qwmzShyKF4HQvHnIDxXojN6dbr0W/hdGSCNGXlINPgmrViBcrv17F
 tY9bJP0hvILP6l4ZchmZ7LFsGsT1CzqgFuwyGJ6AykthgBItSOnhxJHp/AkDGIXuXRbgRNd/Dqs
 Oh9ycnBd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D63CC000D
X-Stat-Signature: 3zb4tw1es1sbudsr57e7un48i47dopew
X-HE-Tag: 1756373735-210923
X-HE-Meta: U2FsdGVkX18/OMsGcHYz5bIVr7MebM6kb61BPNdATqlnBNtcDnX4v8Y9E+RVoXPdwSN1uFfBmScDSfaPeeG1hD4PgblbTqIsfuxVN6MGzHjePxvf8eRNE8WArECnxDMfM7JU0WRKv6IGIuZe/baBxJuvLzRbAdDt4bM62mji3UD/55cb+ITGT1tDr4gT2Tbtirj41+7KPkzAGtCAJmAP8gC8uNnI3Ie7cAD30mDYFB2/HlhWE3TNfVbNcnGLmvXjHUk8epvKll5KvPB7MZd99t0ILebv3RVQNWDkl95BPv+ld7A+8rL7hb8+I94EB/3s6eHcxDDGpwbIuG5qy+OTMk8Gu0hhg6L42rJ44Khn07f9UG6hjIueglaQe/Uz61Zlkq/Lsw5gKcZZpGif9aXzhmN6TowmZKFpKdjPZGJYOM6/ByI9rT3rT+MdAxsDb7pe6e/Zo1Fa6L7tRD32ICHfwJjxM5g8tXSj52ev3tW3kUg60z+g1hU5RPLvXsTyAt2HpYJKtwAcTTzpQntUUhhYmpnxaAQEYUIEAjLvCshblyVu56tFxwXfsmyKwnkamew2LX4QPFxaGhZWABuRgcmC2D3WNcbD2LXMynZPXNGVyWKCiG/Q5qOG9yJP3gWgNeRHIwBWP13xwzeX/BzLjocnAOEz3eL4q8nxbeO1NuX7yKKNk3LHzoQ/xdA8UP6jZulk2AZwdkDEvpZt8mX27pwiX7ETtQxwbCdhRJlEaz8GpNPXC9qx0/MZAJOt1vpox+ebzdHbv009IkR7RsbC8XMpwjg3kwMM25pcLOzhw5lk84Z0aLbvMEa3Y16Mjkb+oW3dYSFELIOpE62vHPLDKT+0oaTIeCHNQPm1ixRdqVF8VYUzHpmAOFbZzbEhWzjw+eGJHnSf/zfnVXjIDEW0/dm797ycNUaot9AuKMaR5fdACSB3FVWoobl5kQSCOcmwjAZcWY+8G00+RM/60qZtLBI
 SRSxETH1
 dbWfklsCfZ0Nty/bXmUh4+7VT65wVNG/PuppsNL+907SUH4fs7bqP0Ys2cIBdQ1c7DWi/J9bOKWeGO2u0I9UKVnpKfglT62RFzgu0Tu6b90vg8XronpMLuxopxKaqTct6uEastC1zpBteRVYx6KRmaFNMpyFPFqKxaXPtqa1TmCtO4cJZR6ciclm6HruM/nIseVqXvspv4dNCVMbtZ6cW9ZGrXK6UWS1seq3PCPeBPwRXuyVtfZmbWiw7sHacBazedTledalYED1pHrhovKvyEQc7ZQMLxwhb+oszqTfERhAK+AUMixntsAVcgPH2yLjREY6dx0x6p6yVG8STUVfxEO1EAEOBCDGFHl1BGbx4NijcM8YIBOeKid70yxjVMWjHNmlG6qqDcTrpY3ifs0JrOGNZ2d42EI3K/3kVZUNAHrTDp6NyBoaA6GtU824L+2qNgxVkEVjWngP4Ayhr1DC4a+Yu4EGVUFf4eXr/q4XVfFnzPdK8dJHThBEspNHjQLdOph8+EPBhQdoYWcIIHxKHd+sqmgQF6wnwv1/ppzIyUjG+CDI4cSOCMyr+9S8epmM8NGZ5J0A9apIHOimm6z81fdU/ofU+hf+k9MlIZqRcBzMMpN10EMQie7kLNb2O+Sj/9DOZgd2IrtJPjPp51spNUTlgRmdqWDElWWme+moe4S++chQTby+9vhfRlO0C2dPS44TKcMqebuxrOAbeFwUOhXCesygWODqX0xH1dWyfZbUn9qWy2VUykqmYNueU2wxuEMdOFsr0ZAg7FGa0GreTNTgwWd/BlCI7U75taXgi9tN3qOTBj+3SM4JqPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please don't send this in reply to previous versions, just send as a
separate mail :) (yes email for dev sucks and there's a bunch of weird
nuances so totally understandable!)

Hopefully Andrew will pick this up regardless.

On Thu, Aug 28, 2025 at 10:48:20AM +0200, Max Kellermann wrote:
> Calling is_huge_zero_folio(NULL) should not be legal - it makes no
> sense, and a different (theoretical) implementation may dereference
> the pointer.  But currently, lacking any explicit documentation, this
> call is possible.
>
> But if somebody really passes NULL, the function should not return
> true - this isn't the huge zero folio after all!  However, if the
> `huge_zero_folio` hasn't been allocated yet, it's NULL, and
> is_huge_zero_folio(NULL) just happens to return true, which is a lie.
>
> This weird side effect prevented me from reproducing a kernel crash
> that occurred when the elements of a folio_batch were NULL - since
> folios_put_refs() skips huge zero folios, this sometimes causes a
> crash, but sometimes does not.  For debugging, it is better to reveal
> such bugs reliably and not hide them behind random preconditions like
> "has the huge zero folio already been created?"
>
> To improve detection of such bugs, David Hildenbrand suggested adding
> a VM_WARN_ON_ONCE().
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> v1->v2: using VM_WARN_ON_ONCE() instead of checking huge_zero_folio
> v2->v3: use "!" to check NULL; removed the #include

Putting the history in is great though thanks! :)

> ---
>  include/linux/huge_mm.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7748489fde1b..96ac47603d97 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -479,6 +479,8 @@ extern unsigned long huge_zero_pfn;
>
>  static inline bool is_huge_zero_folio(const struct folio *folio)
>  {
> +	VM_WARN_ON_ONCE(!folio);
> +
>  	return READ_ONCE(huge_zero_folio) == folio;
>  }
>
> --
> 2.47.2
>

