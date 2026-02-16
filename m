Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0485E81A25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476316B0005; Mon, 16 Feb 2026 09:43:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44DE96B0088; Mon, 16 Feb 2026 09:43:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305406B0089; Mon, 16 Feb 2026 09:43:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1F26B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:43:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C36FB160D9F
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:43:31 +0000 (UTC)
X-FDA: 84450588222.01.BA19346
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 705CA40006
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:43:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=J+u3kctg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="D55/eRAf";
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771253008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ds4wNpkWVzZXreZwbJVQQ6dG55hDkwE/yCVMZ6B7+d4=;
	b=Gkb1t8jMxgM/935YGqyDLDeZyZUgKq0Y0uO4a1ut2/Okzaedj6bAOvSu1QNkvOGnSyZMs2
	/Zjiee/FxNOtLKHxz1/OVbkOjeSSu5T3Jv5P6nSnKXKlDlRlA9M85tNXUTpRAThSrr1dQx
	cSlSZkOkuDamGGQkxmtfwD4pcTm7LFE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=J+u3kctg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="D55/eRAf";
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771253008; a=rsa-sha256;
	cv=pass;
	b=lk9bP17aHgthhT5PpPssVR0NELH2GoVGo/5ZbIJsKNxDAut6NH2Q8jaxxngwNIxa3mL7ef
	4XZBBSGQuwt0HpS1Sw40ot4hUM3Psf8kKcSPH5LgXSnQz+OgAJDyIFf5rW/AZ56E6Oswu5
	ACnkaSVTviIQO+xdTYw62AyrcyItngA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GESp1h440346;
	Mon, 16 Feb 2026 14:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ds4wNpkWVzZXreZwbJ
	VQQ6dG55hDkwE/yCVMZ6B7+d4=; b=J+u3kctgLpTP9WgO7Lypyt0+HAjyWAGwIO
	wNi++HAZNckaH1+hmH7DzFl0F3V8M8tKW+SNqmBrTS/iA54KDgg6Qza6HlCF+N6B
	FNdfsipira/jNVEPVHk0Vr4514FLMvh3BLK7h9G1uY6TjciVleueWwrpO6/P1tAe
	Dp3mwf7CCE9iL3J1MW0pvbTIisviWIsveNsWsgilh43HoOf1FPtV7tOmTNPl5Y4a
	8BGuXPkqthWUQKnNLpaNHRFNJuwL8SpM92F0yvvPWZoYHmPIK238gLtpb8oimjCq
	moQKgBQNn/az3Pia1n06TjQ+H9PWqufGym5LUzbXHP1KWKXzAH8Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj4at5yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 14:43:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61GE4411035563;
	Mon, 16 Feb 2026 14:43:21 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013044.outbound.protection.outlook.com [40.93.196.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cafg8eyhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 14:43:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDKo28sR5yfcqcgnQr23NG0vFiqQv018AI6jbEhcD4rUOUCj0ND+YjXYJMfQ5thwY4JshicIePGF3dCcE63LBKnpTFIcn3OD2tJl4MwbRyblBWcMmaAr6FcLWd45xddAClHE5VR3xL8lO9AcYjBalCVR5dpmEP7YHn5NLqRTF3QtRhV8F7cn3j8Ntchwklv7rbYhxRWjkNU1YIjITwUjn275aNKepbcMzI3A6bVvA2NWOY279OuG9+xAQ6Mg7JoChXh5ABbfy6KzcR4Z+hzT6Z1ZBQx0uObnH9V3Hu8U+I8KmhcyntPGLDp5NrXX6TFPiH81cOn0xPTO0hbGuqQ4sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ds4wNpkWVzZXreZwbJVQQ6dG55hDkwE/yCVMZ6B7+d4=;
 b=aJ5NrpirYXE7rQ6er9XzPOVoXkDvXFXsMlF70Hv2iI4713xLHJY+HpQ6LWsTV2NuQ7xMg3iRo8+CPXdyJBV1DzhoSj1BYLldXlurhl5u9zlKH4614xJg4KoLTxa1vZNkEzPMX4MK73qfdis/tUAbH43h0u4yj6ArKY2FArOUodP2Li+eZ6vyeq8ohTdUW9hh483fwsQrwZsooo8IsFaiPyDxhREl9DmueA6LV0LuRYDFZDszm9KOgW8gRBNbLfCDx6fGCdjDlQII6NFjyZJxE1GFdxTzNdNulhTvNf62CKgDcHYHUfAmVITHGs0WejWtJ3czdz3J6xQoudfPTg9l4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ds4wNpkWVzZXreZwbJVQQ6dG55hDkwE/yCVMZ6B7+d4=;
 b=D55/eRAfFyoxMa6oDX+lJKKzS2dr5ZjsUkinov2yWqbM4JZWMq0YlWroSBTmr3FXZbBoqloBxVTf/FFRSlXX14jsQOytKXthpIVxnIdjkOV17v5qgz3P5MQIhI3ZDwd8+whpPxSoha3lPUc9H2jGRdb+Zejru5VbmUV/UwT+2OY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4186.namprd10.prod.outlook.com (2603:10b6:5:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 14:43:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Mon, 16 Feb 2026
 14:43:18 +0000
Date: Mon, 16 Feb 2026 14:43:17 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: syzbot <syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com>,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, npache@redhat.com,
        ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] kernel BUG in __khugepaged_enter
Message-ID: <aaf78721-0bb0-40d5-9fdc-595942c66fd0@lucifer.local>
References: <6990a57d.050a0220.2757fb.0028.GAE@google.com>
 <5e95c945-dbd4-4714-afb0-9546b08ff561@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e95c945-dbd4-4714-afb0-9546b08ff561@kernel.org>
X-ClientProxiedBy: CPBP307CA0001.DNKP307.PROD.OUTLOOK.COM
 (2603:10a6:380:1::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4186:EE_
X-MS-Office365-Filtering-Correlation-Id: 064be061-68b6-44f4-dc74-08de6d69b982
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A3Ye3UlkLKoHYIGSUSeKQYWHijpIGH1c7gDt3qccEjuPrj4Q1Z2hnCksXFV+?=
 =?us-ascii?Q?8Z19L1IH5JUdJFHXf8M4kGudA/+Eg4FLr9C3oZ9MvRrhmWkhLxfxM/Kj1SnF?=
 =?us-ascii?Q?UU/6EMAQtf+v9YVpQydV3y5uvMmSL95KazQNFUu/XTZFERYdny9DtI2/MhfV?=
 =?us-ascii?Q?hJh7uPX6PMPOoBYgK5bHweZa50WyD9Zih8+ywdd7wslP/AQggmxiwrbf7SkZ?=
 =?us-ascii?Q?gOjJTVoYM2GTp7Z+NY4dWhKEL28uL5CHHlWKFOdLr2W7MKv0+Z4ul7WKuCPR?=
 =?us-ascii?Q?dULov1Z8EzmntPriwkfabbjUdOAJLCgwWBY+Po3UIcwVR41q7ymtBMXAroOD?=
 =?us-ascii?Q?zeNf85GL3zVlTRFEu44Dqx4VAeEih7as6Y10GwFnMixAqrv/d+Q+OxlvKcFT?=
 =?us-ascii?Q?S7DJd2HKrJb43xxPSCg7mx9Nk5Pryv5HNOcw+XpuLs7/jqvhDPVsCPSubUvi?=
 =?us-ascii?Q?sJa9C9kKKsCLWlCYok0FHcasmxHsZ2QVc0/pgaeUrH/1YwvBRs2xWKl2OsEa?=
 =?us-ascii?Q?u/tcUnAJJaxC2QKam3hznMhGIW3JGGLuHufwTX16/wRueP2r+xY5d+gtTQvx?=
 =?us-ascii?Q?gTF0F4pM9fSaDJyGxlaLhHrTychMrhXuQVy9iIHXAurVafF4fDNNv7BbiADC?=
 =?us-ascii?Q?BO2asQnIaeBQiyFOUjfX3fUJFxQ9J9uPTQD+2jS+A0ZbnYXgHLHIzUGYV0bn?=
 =?us-ascii?Q?dFww2Q4hrnpF4K9ir5/Z4Lmm/g9qE9jxXN8+IXHNrID2QUh3AS6d4VAnNv5j?=
 =?us-ascii?Q?St7A8xXX3vhxPVLOcFjuL/EoMRS9qu4p54EPjXpdnt8vKMwZIMtt1v61GEdL?=
 =?us-ascii?Q?ZszC6cv/8AyiLBHzFtRVk98bToZEGboO9MmaJTsWylijUzTXyIBAuAgM9ozG?=
 =?us-ascii?Q?AJZ+1rtlDUNnJu61hharuYV8oE4YJXTOnFF9O53cTAU6X8if6nR0sRwk02ke?=
 =?us-ascii?Q?Hjv1eHySxWmdfglX7/sHk1XbzVbgTUpUzR+8wOHNyR725pZ3Dawlr6vdQIMx?=
 =?us-ascii?Q?gxHhBPCwbcGRoJgwXxSRF3GIvSrjbF5ismNoWq2PHRNGDq/XbplQyB8YBj+V?=
 =?us-ascii?Q?4+C7MvrEzn5qaWg6gwa4BGG1WhdmR7v7lIA2LqK2hEdbIVZlBjA1OeCC35r0?=
 =?us-ascii?Q?KBZEFFsEEGE1ugWlmNAAtYR8BgkEYYNQoajIAXrqlUjCepEqWA+2McjW/n8t?=
 =?us-ascii?Q?qpyH8gVJTwOB5AiF31pjCrz6Jm0UuPwy9+MwQcCFa8FT97hsIG0kJBPZmPs0?=
 =?us-ascii?Q?bs07WU0APZt3WydHAhftRRN1aydA0pPZRsNS78XhK7a+eQ+/Mcj6/4tnDrj0?=
 =?us-ascii?Q?nf++gBucjNW8GDC/J0BQ5EwLbHbB3iVlIz3jwwlITYHidE2UaKArkf28nbDQ?=
 =?us-ascii?Q?Zlph9yDClSfpCK6zVAirG2PBfoNd9ZVR/gkMwMR6cOqjupuocoDrHkWeVrhj?=
 =?us-ascii?Q?gdKBfITmywCKpuz/jvXs+EFpTMbWy/gkREa+JQZ2UGd+wpq+0aW5JIRUoQ6+?=
 =?us-ascii?Q?ydYMKIAbdDIZwspb8k521hRE4LypZMq2XG69?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IFwLEbtsjeV4vEK5SGzjniB3aW63HOSm+gryAABKSxUx+8W4WOmyCUwd2t9T?=
 =?us-ascii?Q?n9zVoXOue6RuS3oXw1hmc7wGK8Xd2WV+ZyySEyCdUD2OXhSPfvGYTNIkuLxq?=
 =?us-ascii?Q?CHW9JNhO3stdOYwNDzJloik/F8rOifadYGdTGcPtRjeiUE6fJnPSQfowuCad?=
 =?us-ascii?Q?diHNWQq85ME18nnDr0+pAq/iFhzcdcbej3cLgMkcThYxMnSfyMk93vKdLvlu?=
 =?us-ascii?Q?2LG4HFe5K6V2k8OjhGfJUYpMuvYz1Wx2BXhyxdOlBNy2HE5cIqh7l8lSMTep?=
 =?us-ascii?Q?dLe8mqyvlED9vCq4X7QuKwB8cvXrwGSS3yChyd4ilRtZZk45T7pXHi8SuvVt?=
 =?us-ascii?Q?OpJEbP/Yd5hJVX6xmCdBm9jAOfDGmN8O4O3qwzBZgwVo+8VW4xiWeBAPJHcl?=
 =?us-ascii?Q?6eZapIXlQ9YtIyib3Jdv1ODFcqTrwtgbQEL+BpYHzIuqkgj7npkUts90pQnC?=
 =?us-ascii?Q?sML+YVlRKa9iE4vdlRnDnTJ6g0DZsVUEstF8q+5HalCMkzaeVhklP4MIDR1n?=
 =?us-ascii?Q?qoXQRr+rraIBCxKaK7803reM9j5/Rc35ciaNJPDK8t2fvC+uCmBQPWkYxKna?=
 =?us-ascii?Q?cDicfkcz8GhdmDlSo5Dl0hWagzBt0fwWSwFTQEKgmPCbELdL+ChP85VEi6Oe?=
 =?us-ascii?Q?YEyKwOO0t4mjFV3KvVxKpLRIIOCijNA1FCbpVVyr9XBBz6fb+KmRbc+K7fZN?=
 =?us-ascii?Q?fjb7MdYyM0tJxLveAjaqL+6xuGdnTal8k6FiPW6vPtgMwHcuYzE13nKjKOoM?=
 =?us-ascii?Q?hAmq4xOUSfvidpCmYcfAm/+pFN6ixkog+eAjkqoBlHOI15OaKmHNKFQGqsZZ?=
 =?us-ascii?Q?3h/kxJLRhEkqxTjXwg6GtdWjulA/sxgzXWM3Phjd2Wvy7NRbY2jRqEPqJKzc?=
 =?us-ascii?Q?7J9eS9/1MR9snpv534na0ivLEJl845LmNoaxPtqBb07bLpK1PGtvNdI85zim?=
 =?us-ascii?Q?Tsl65G7JbYiqGTQgXNYeyksheKCqi97occyOgFY08xg20Wz7Onh4kh47f5Hq?=
 =?us-ascii?Q?mAnu5xBD6OC1gI4PMhwP3SDlVZFK1QKFEzS55gPan3APJH0xKF9WckIZyBFU?=
 =?us-ascii?Q?CWTfbMKCmJv25XN4kX2daRjTPfyEJiuQNEfCgrsEe5VUdvn79w4ZFI7U317a?=
 =?us-ascii?Q?AcjjcCUxYRjOJtoKWMDJsouQm7lu5Uu7z8A/atRMdYQUW50b0CkvF4c0lsEg?=
 =?us-ascii?Q?syN84GazbXCPPRUbOghWzJawGPP4IuqpWxYEsa3OI/TbqC0089P9esBOOV/U?=
 =?us-ascii?Q?W4f2fyjkiFGRjrQEfuxpaFAVh0s8KT/FrrbNAA6v99cRhtNEhIqgHnPGWvTM?=
 =?us-ascii?Q?c7Xf6U7CABV7StoFtN6ErYzLUwSJdOOMzIJKHtZKBL5zIPlb4ReZmG9m//KE?=
 =?us-ascii?Q?duCGhqH6KAS85hOB3tdqoQMG7AZLaCgeq79kkytJVE0Iepqz5n/xkC+kU+/g?=
 =?us-ascii?Q?JUvH14XR1DCwwLOfqxR2SnyNIzZo/qlyfQExcsSTpX2hYewxOJoKIWu4YVPk?=
 =?us-ascii?Q?LOsGkBjC35SO6CQnLe6Hkrc3CRitm9TF2OcioLoxBJ+qy5EKqMau/nSLUxqB?=
 =?us-ascii?Q?lEGxbJbWIV8vANSwo8pDs0KmkCL+XW5A+BIcRQQhBpuBbjEdvQZD2cCna6KM?=
 =?us-ascii?Q?3yyMjuayFbowBjoKISoJ9JzNc9thqMVR0JYtRRZ4J2C8mCNhwq4bEEUKZRxB?=
 =?us-ascii?Q?rpIGSM2E6DB3DnyzTEOufZlam3etQmc7tlBEXtpYFNGzeHLu/SFsQaEgQ+zI?=
 =?us-ascii?Q?GjN1k/uu2ZWNzzDoI/B0oklHPCc/mJ0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q8LLVc9L9gaZBEyErzQV7HEaxv+8kOtsC3EIC+UPwBWytJwkLsx9QAq+oTCGPw7p96h0aUjQQssRgKmHdiYAGUyDnjB1jSmTmYj5WJDZbhnSIDatt79kx1dru4tB9meeFWG37Xmv4YIVSKaJyzcb0GSOI6sDzo9+PAmTwyPrP4vS9b4Rfix296CpD1fIBUBVwCW8vZPTxaJJ3xJanpGkBj0BWqa9B/vFDziQ0JqFW20Zmm6xtTNs7qiQ1yBhaoo32ckqXHlxsiwaOApMCTM9aGanyY/n0EtTXfBAea/y/PhbBxOoIbffApuSBWzH44Dj2272oCTPMozqj/sfjltE3B1RI98U1Fh5zOqzOqs8UZuq4/ZPi66ha9Fv/EAyEBYAjLYnhaDOmSFrBc/LzE2w6takJMugS8eiwNfEDaLG004ueWtCsvfXn7/3XOw5urXBVs2yAm0pVBG6OJSos0L9HjUh2zwoydbgHdDp/GCWXd7JXgo9cDhVI+eM1mZ9tZkGE9MBVgJfwUCEueGOOEOQ2g0FF5HQ01oYoYFZzMc34rCiJbJLhS7kd9WDgv/rJxrJpC8wTw+vCqunUgSSUWWA9dA0ziy2wDgUe/LJZLIDrQw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 064be061-68b6-44f4-dc74-08de6d69b982
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 14:43:18.6076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWRW4fOYqrRE4PqHrSdVbc/e+FTejZVdrj+Xfsycm8GFuiI00KHu4honjVwJpVu+xkoz6eML2dwRIlCdiIOddX7+z52Mg+5uGzcX4o7z9Hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602160125
X-Proofpoint-ORIG-GUID: JDcchuy0ENw_deUa9upqt64A5rhsSptd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDEyNSBTYWx0ZWRfXzcgyCR4sBZT6
 OF42HcFFAFVmlJ+OA2YPPj323AQJvkHq8x1A7AmksVoRhT4QfBImQZtr1dXRCiU9iEBaEuccT5v
 CCMbkcIlv98ZDeO9riSv1yVAwltfkfwDqvOTulQZRPtuPcuGhe0A14CWSJj2qxVMkNEuFcVwo/n
 x9bljuXp87AuoqtsVdpEvnaLkYhPYIIdgAH7A15HgkRMwlikGI8qrRBYvZqZRu377DZanAHZ9j7
 uSRxRtmlSLCnSjIxmIz/uVoZ/0428kwcXdEmcC7t4n4GlzOHB6hCSLzaTDcQOPo9LGG0xbc3B4M
 3AuD1fMOS0Av/9PY6IFr18Gh5J1Ia4H+pGJH0Aj+pOMm4tZRJvsedeO4Cmx+bjzT1X3HL9IHDJQ
 L+Q4AJc11b/oAmAZR1dd9kaOqHEvjeaclG09fO53wOl0bt4JEVsd3njx0nrBTheA1BcAv6B4dr6
 aBrwagbNxdLpdcyq42w==
X-Authority-Analysis: v=2.4 cv=SI9PlevH c=1 sm=1 tr=0 ts=69932d0a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=edf1wS77AAAA:8
 a=3g80flMcAAAA:8 a=hSkVLCK3AAAA:8 a=rORrwtLmLAej3nsguV0A:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: JDcchuy0ENw_deUa9upqt64A5rhsSptd
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 705CA40006
X-Stat-Signature: 36gwqwyur88w1kmwyke7ucqcfybgfne7
X-Rspam-User: 
X-HE-Tag: 1771253008-340887
X-HE-Meta: U2FsdGVkX19lXZlMImICX7CFh88DPI4j4HzCaild82JVnaIHmSQcyU48l4/irNl/UJnT0bENnzCgwUOYg3rB5cWbH9Pp6ET81VwOFNZYNeS1fjeCVp3VOiYRj5T+hZ6BxGGyUAGnsQpoE7665uzHEkqArRvC+GLoFQsXppnT/o2RBfv+kI/UhPFBM4Kz7J3/XL/pQkkYBqRUTYzPycCJbswgnN7Usy9vakapiIGbektRX2xddhayP8SytVwzscH1L10cy2CjSOC6nP/kDUQMXRKGF/Eehw1rMmriydnillm9WgX4uaQD5DqIUQo2EmUyr+Me5ASmVeq6XJEJD98jjTgx5oTqczbp5VDcTBTrdHJn+HFIvJ3NSh8GDHOvu4sqH1WnXgnz6bhYR+6QyrMOczy9Qt7SF88SIDBlIx9GycbhKmSwoBPja56FqI6lUArxv1X8lmoQSYpZnmrJjwqZtOBMrPAmXDsKbEUCNyLoBzRXSiY9ev4LMwZxDT+y6lyDsSMfGpXrhJYbwzNjnY+5n3TVc4pxIMOsy2lDAweuzzV+CJsLI2ZkuR/+mIaEzdUwNgsCaEx54waqRtjxk3hSZQKcaAXPfUIGALpACFbKwfpJwduCJP/1LNukh8+StbvlSQcDxY0jVSAT2e3vSsEj+PThA7l1jFth18dz4MVxvL39u7bNQAz4U8X+iBPYN8guxslNxMFvRlZSP/Ib0Uv7WQRYWCYVMHm54cg+bjKJbHX/Slj6t0/l3BAybD74+shc1UpsAKTzl2Wj+5rM0pnZg9tqU1NKY6rZZxIdoIDXU8ZUIpYWgH43oxykUCDqoaBuo3S4OXF9X06FJZpo4GzGC6KlRaW8ztFhGdlfh0zunz0yvduqtJpVjYw93zIji6o1OjN36d1y+zR6lNyzwTEvyoJbXK7+7JUGOb//GKBckasGKznstxP0RecN38MW3kys0j6mpSpgaJZiUczmh9o
 AtL8qR4i
 8KB6fc2+2kRahm39z4f5wwr2uF4uGCzAS7m+SjMSj7dLQ7R2yskltqCbq8z73pRhyCip31JvsoLWWZ0rKPisRFg8Wt9QVsqKairR8S1CPBYlP91SBZSgRk2NPMABiwD/B2gT2iUIdNmXYbxtONkPrTNli23jZb90z4S31dTr+6rnbzbZ43q3yZ7+4zbLfiD74m973JMRqs/vi0pcMA4Kty2dZCs31bITLK1GMDbHOjzOKKz/BkbUHkXsLxx32pJJFFTT08KlTCWSkDhnUqzBD0okEcHXYZxyN07FGdYtjr/C6/FTvENKyRGSYXVm/APynL4UN+pUSTHB8h2Q8puJf64DTb6ZZzPYNTBl3ih98QKMF5/K0HYM4LQAm/KfE0esM+pPLrZp9O2hJcncnAInXZn6GiOHHE6OxSCXrNoGvnRKlXHYwPbyUJbMLzHET59ask/8qMRCLb/icRdgoo2IyMq5SJzuCjXEOM50qcdfRVH4VuoDbH6MgOjryfcmK3VjibV4JYURMDZIX5LpQAd3Eza1into0OnTUdR5N3iJnd71vxzRunArJHRqHCabz6dMMUDbUsHf2TmgsgHiM1HMMW9VBJavK9lF8POjCQIM5KrnZPqo0FPSStmTC/vLlvzU3Xo+gNxa80O0Y73H/KTEUhr/6GQsq5bObrefEpXuYwnhfyEwTcNRzeDZVGiGimODK1XzKqcoZfv7PQS08+ps9GKRXW7GMPLwPMPaB28bIh+pxRFKxirXCZ959L8HByHbtkQwNWoeiYVVYcHHB3NJUfREmyLyRQ5uJ3UUj00BugEPlcjD5q4un2OBA4nBOMtW+dXOXiEQIXgfNIye+nI7lJPJDbTfER7KEZCcLraiMHwf721m3CABGZeC38Q0VPPvYTXP53Y0uNjLmnNZHIwEFqX+MbCnkEX04Igbx9rCk1pfyJF8SOO8HzPCqYR6KIF3HDSPT2vlPTOdHqxfCzuwIe59EvPXw
 t3d/EExh
 nAf4wxrQz2TjZ4oVMLpaHC8HRRQjvcx89IAZ9brIkVcAojOuLCpocR+bMTdfr7p8oTmVCuuXZKAm/aSEGYDbPKwNIQ190Ofm5TpGKCKCn8zNwP+KpHJy+TJDolhDo0QkUqQ9jcU9W3w63bW7hBVj4NR2dBxmVHg2WtFtwLcuVEGNoPnsa/m8ZhZPj+CmkV6JDcn4VJq0xrUJCDADTBtGI041PQao5NI3+WDu5corq/mKl1uuVJFTJmY8bo+15sE3aGnYj+Iyd3N6AWvXUzSew5NQGwlNxxdL7CfUn9gnCPa58MhICqK2PA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 03:40:21PM +0100, David Hildenbrand (Arm) wrote:
> On 2/14/26 17:40, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    1e83ccd5921a sched/mmcid: Don't assume CID is CPU owned on..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1169dae6580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=54ae71b284dd0e13
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6b554d491efbe066b701
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/ed43f42e3ea1/disk-1e83ccd5.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/d8af54a32588/vmlinux-1e83ccd5.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/34e6a8cc1037/bzImage-1e83ccd5.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > kernel BUG at mm/khugepaged.c:438!
> > Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> > CPU: 0 UID: 0 PID: 16472 Comm: syz.3.2372 Tainted: G     U  W    L XTNJ syzkaller #0 PREEMPT(full)
> > Tainted: [U]=USER, [W]=WARN, [L]=SOFTLOCKUP, [X]=AUX, [T]=RANDSTRUCT, [N]=TEST, [J]=FWCTL
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> > RIP: 0010:__khugepaged_enter+0x30a/0x380 mm/khugepaged.c:438
> > Code: 64 7e 8e e8 a8 dc 66 ff e8 93 e6 8d ff 5b 5d 41 5c 41 5d 41 5e 41 5f e9 04 6c 04 09 e8 7f e6 8d ff 48 89 df e8 17 33 d9 ff 90 <0f> 0b 48 89 ef e8 dc 51 f8 ff e9 3b fd ff ff e8 f2 52 f8 ff e9 e1
> > RSP: 0018:ffffc9000e98fba8 EFLAGS: 00010292
> > RAX: 000000000000031f RBX: ffff888079b24980 RCX: 0000000000000000
> > RDX: 000000000000031f RSI: ffffffff81e5b2c9 RDI: fffff52001d31f1c
> > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000080000000 R11: 0000000000000001 R12: 0000000008100177
> > R13: ffff88804adf9510 R14: 0000000000000000 R15: 0000000000000000
> > FS:  00007f06093436c0(0000) GS:ffff8881245b1000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fff341d3f52 CR3: 00000000319b0000 CR4: 00000000003526f0
> > Call Trace:
> >   <TASK>
> >   khugepaged_enter_vma mm/khugepaged.c:467 [inline]
> >   khugepaged_enter_vma+0x137/0x2c0 mm/khugepaged.c:461
> >   do_huge_pmd_anonymous_page+0x1c8/0x1c00 mm/huge_memory.c:1469
> >   create_huge_pmd mm/memory.c:6102 [inline]
> >   __handle_mm_fault+0x1e96/0x2b50 mm/memory.c:6376
> >   handle_mm_fault+0x36d/0xa20 mm/memory.c:6583
> >   do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
> >   handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> >   exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
> >   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
>
> This is the VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm), which checks
>
> 	atomic_read(&mm->mm_users) == 0;
>
> So we have mm->mm_users == 0 while processing a page fault. Weird.

mm lifecycle... pinging Liam :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

